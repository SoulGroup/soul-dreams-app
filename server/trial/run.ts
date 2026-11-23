// The image trial's run, on the owner's Mac with his AWS profile (D135,
// D136; docs/plans/image-trial.md): one painting waking the endpoint,
// then six together, each round waiting for the endpoint to scale back
// to none. The images and the results go to the folder given, outside
// the repository. It writes no prompt anywhere: the requests go to S3 as
// files, and its own notes hold codes and times only.
//   node trial/run.ts <flux|sdxl> <bucket> <folder>
import { execFile } from 'node:child_process';
import { appendFileSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { endpointName, trialModel, VARIANT } from '../infra/image-trial.ts';
import { REGION } from '../infra/stack.ts';
import { report, requestBody, SCENES, type ModelKey, type Round, type Run } from './measure.ts';

/** Runs the AWS CLI with these arguments; resolves its standard output. */
export type Aws = (args: readonly string[]) => Promise<string>;

export interface Clock {
  now(): number;
  sleep(ms: number): Promise<void>;
}

export interface Trial {
  readonly aws: Aws;
  readonly clock: Clock;
  readonly model: ModelKey;
  readonly bucket: string;
  readonly folder: string;
  /** A note of a step: a code and numbers, into the folder's notes. */
  readonly note: (code: string, numbers?: readonly number[]) => void;
}

const WAIT_IDLE_MS = 60 * 60 * 1000;
const WAIT_RESULT_MS = 60 * 60 * 1000;
const PNG = Buffer.from([0x89, 0x50, 0x4e, 0x47]);

async function json(t: Trial, args: readonly string[]): Promise<unknown> {
  return JSON.parse(await t.aws([...args, '--region', REGION, '--output', 'json']));
}

export async function instances(t: Trial): Promise<number> {
  const d = (await json(t, ['sagemaker', 'describe-endpoint', '--endpoint-name', endpointName(t.model)])) as {
    ProductionVariants?: { CurrentInstanceCount?: number }[];
  };
  const n = d.ProductionVariants?.[0]?.CurrentInstanceCount;
  if (typeof n !== 'number') {
    throw new Error('trial-endpoint');
  }
  return n;
}

/** Waits until the endpoint has no instance. */
export async function waitIdle(t: Trial): Promise<void> {
  const until = t.clock.now() + WAIT_IDLE_MS;
  while ((await instances(t)) !== 0) {
    if (t.clock.now() > until) {
      throw new Error('trial-not-idle');
    }
    await t.clock.sleep(15000);
  }
}

function key(location: string, bucket: string): string {
  const prefix = `s3://${bucket}/`;
  if (!location.startsWith(prefix)) {
    throw new Error('trial-location');
  }
  return location.slice(prefix.length);
}

interface Listed {
  readonly key: string;
  readonly modified: number;
}

async function listed(t: Trial, prefix: string): Promise<Listed[]> {
  const d = (await json(t, ['s3api', 'list-objects-v2', '--bucket', t.bucket, '--prefix', prefix])) as {
    Contents?: { Key: string; LastModified: string }[];
  };
  return (d.Contents ?? []).map((c) => ({ key: c.Key, modified: Date.parse(c.LastModified) }));
}

/** Sends these paintings together; resolves when each result is in. */
export async function round(t: Trial, indices: readonly number[], label: string): Promise<{
  submitted: number;
  done: number[];
  outputs: string[];
}> {
  const stamp = t.clock.now();
  const outputs: string[] = [];
  const failures: string[] = [];
  let submitted = 0;
  for (const i of indices) {
    const file = join(tmpdir(), `trial-${t.model}-${stamp}-${i}.json`);
    writeFileSync(file, requestBody(t.model, i));
    const input = `s3://${t.bucket}/in/${t.model}/${stamp}-${label}-${i}.json`;
    try {
      await t.aws(['s3', 'cp', file, input, '--only-show-errors', '--region', REGION]);
    } finally {
      rmSync(file, { force: true });
    }
    const answer = (await json(t, [
      'sagemaker-runtime',
      'invoke-endpoint-async',
      '--endpoint-name',
      endpointName(t.model),
      '--input-location',
      input,
      '--content-type',
      'application/json',
      '--accept',
      'image/png',
    ])) as { OutputLocation?: string; FailureLocation?: string };
    if (submitted === 0) {
      submitted = t.clock.now();
    }
    if (typeof answer.OutputLocation !== 'string' || typeof answer.FailureLocation !== 'string') {
      throw new Error('trial-invoke');
    }
    outputs.push(key(answer.OutputLocation, t.bucket));
    failures.push(key(answer.FailureLocation, t.bucket));
  }
  t.note('submitted', [indices.length]);
  const until = t.clock.now() + WAIT_RESULT_MS;
  for (;;) {
    const fail = await listed(t, `fail/${t.model}/`);
    if (fail.some((f) => failures.includes(f.key))) {
      throw new Error('trial-failed');
    }
    const out = await listed(t, `out/${t.model}/`);
    const done = outputs.map((o) => out.find((f) => f.key === o)?.modified);
    if (done.every((d): d is number => d !== undefined)) {
      return { submitted, done: [...done].sort((a, b) => a - b), outputs };
    }
    if (t.clock.now() > until) {
      throw new Error('trial-no-result');
    }
    await t.clock.sleep(2000);
  }
}

interface Activity {
  readonly to: number;
  readonly start: number;
  readonly end: number;
}

export async function activities(t: Trial): Promise<Activity[]> {
  const d = (await json(t, [
    'application-autoscaling',
    'describe-scaling-activities',
    '--service-namespace',
    'sagemaker',
    '--resource-id',
    `endpoint/${endpointName(t.model)}/variant/${VARIANT}`,
  ])) as { ScalingActivities?: { Description: string; StartTime: string; EndTime?: string; StatusCode: string }[] };
  return (d.ScalingActivities ?? [])
    .filter((a) => a.StatusCode === 'Successful' && a.EndTime !== undefined)
    .map((a) => ({
      to: Number(/count to (\d+)/.exec(a.Description)?.[1] ?? NaN),
      start: Date.parse(a.StartTime),
      end: Date.parse(a.EndTime ?? ''),
    }))
    .sort((a, b) => a.start - b.start);
}

/** The scale-out after the round's request, and the scale-in after its last result. */
export function framed(
  all: readonly Activity[],
  paintings: number,
  r: { submitted: number; done: readonly number[] },
): Round {
  const lastDone = r.done[r.done.length - 1] ?? NaN;
  const out = all.find((a) => a.to === 1 && a.start >= r.submitted - 60000);
  const inn = all.find((a) => a.to === 0 && a.start >= lastDone);
  if (out === undefined || inn === undefined || out.end > (r.done[0] ?? NaN)) {
    throw new Error('trial-activities');
  }
  return {
    paintings,
    submitted: r.submitted,
    done: r.done,
    scaleOutStart: out.start,
    scaleOutEnd: out.end,
    scaleInEnd: inn.end,
  };
}

async function save(t: Trial, outputs: readonly string[], names: readonly string[]): Promise<void> {
  for (const [n, o] of outputs.entries()) {
    const file = join(t.folder, t.model, `${names[n]}.png`);
    await t.aws(['s3', 'cp', `s3://${t.bucket}/${o}`, file, '--only-show-errors', '--region', REGION]);
    if (!readFileSync(file).subarray(0, 4).equals(PNG)) {
      throw new Error('trial-not-png');
    }
  }
}

export async function trial(t: Trial, instanceType: string, idleMinutes: number): Promise<Run> {
  mkdirSync(join(t.folder, t.model), { recursive: true });
  t.note('waitIdle');
  await waitIdle(t);
  const one = await round(t, [0], 'single');
  await save(t, one.outputs, ['wake-1']);
  t.note('singleDone');
  await waitIdle(t);
  const all = SCENES.map((_, i) => i);
  const six = await round(t, all, 'batch');
  await save(t, six.outputs, all.map((i) => String(i + 1)));
  t.note('batchDone');
  await waitIdle(t);
  const acts = await activities(t);
  // Kept before anything is worked out from it.
  writeFileSync(join(t.folder, t.model, 'raw.json'), `${JSON.stringify({ one, six, acts }, null, 2)}\n`);
  const run: Run = {
    model: t.model,
    instanceType,
    idleMinutes,
    single: framed(acts, 1, one),
    batch: framed(acts, all.length, six),
  };
  writeFileSync(join(t.folder, t.model, 'results.json'), `${JSON.stringify(run, null, 2)}\n`);
  writeFileSync(join(t.folder, t.model, 'results.md'), report(run));
  t.note('finished');
  return run;
}

const cli: Aws = (args) =>
  new Promise((resolve, reject) => {
    execFile('aws', [...args], { maxBuffer: 16 * 1024 * 1024 }, (error, stdout) => {
      if (error !== null) {
        reject(new Error(`trial-aws ${args[0] ?? ''} ${args[1] ?? ''}`));
      } else {
        resolve(stdout);
      }
    });
  });

/** The command line: <flux|sdxl> <bucket> <folder> [idle minutes] [eight-bit]. */
export function parseArgs(argv: readonly string[]): {
  model: ModelKey;
  bucket: string;
  folder: string;
  instanceType: string;
  idleMinutes: number;
} {
  const [model, bucket, folder, idle = '10', eightBit = 'no'] = argv;
  const idleMinutes = Number(idle);
  if (
    (model !== 'flux' && model !== 'sdxl') ||
    bucket === undefined ||
    !/^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$/.test(bucket) ||
    folder === undefined ||
    folder === '' ||
    !Number.isInteger(idleMinutes) ||
    idleMinutes < 2 ||
    idleMinutes > 60 ||
    (eightBit !== 'yes' && eightBit !== 'no') ||
    argv.length > 5
  ) {
    throw new Error('trial-usage');
  }
  // The run's instance is the stack's, by the same rule.
  return { model, bucket, folder, instanceType: trialModel(model, eightBit === 'yes').instanceType, idleMinutes };
}

async function main(argv: readonly string[]): Promise<void> {
  const { model, bucket, folder, instanceType, idleMinutes } = parseArgs(argv);
  const notes = join(folder, `${model}-notes.txt`);
  mkdirSync(folder, { recursive: true });
  await trial(
    {
      aws: cli,
      clock: { now: () => Date.now(), sleep: (ms) => new Promise((r) => setTimeout(r, ms)) },
      model,
      bucket,
      folder,
      note: (code, numbers = []) => appendFileSync(notes, `${new Date().toISOString()} ${code} ${numbers.join(' ')}\n`),
    },
    instanceType,
    idleMinutes,
  );
}

if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
  await main(process.argv.slice(2));
}
