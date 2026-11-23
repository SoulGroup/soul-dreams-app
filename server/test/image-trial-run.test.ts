// The image trial's arithmetic and its run, against a fake AWS CLI and a
// fake clock: no credentials, no network. The bucket is invented.
import assert from 'node:assert/strict';
import { existsSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { costs, prompt, report, requestBody, SCENES, STYLE, type Run } from '../trial/measure.ts';
import { framed, parseArgs, round, trial, type Aws, type Trial } from '../trial/run.ts';

const BUCKET = 'trial-bucket-invented';
const T0 = Date.parse('2026-11-23T09:00:00.000Z');

test('six invented scenes, each with the one style', () => {
  assert.equal(SCENES.length, 6);
  assert.equal(prompt(0), `${SCENES[0]}, ${STYLE}`);
  assert.equal(new Set(SCENES.map((_, i) => prompt(i))).size, 6);
  assert.throws(() => prompt(6), { message: 'trial-prompt' });
  assert.throws(() => prompt(-1), { message: 'trial-prompt' });
});

test("a request: the prompt, the model's settings, the prompt's seed", () => {
  assert.deepEqual(JSON.parse(requestBody('flux', 2)), {
    inputs: prompt(2),
    parameters: { num_inference_steps: 4, guidance_scale: 0, max_sequence_length: 256, height: 1024, width: 1024, seed: 1002 },
  });
  assert.deepEqual(JSON.parse(requestBody('sdxl', 2)), {
    inputs: prompt(2),
    parameters: { num_inference_steps: 50, guidance_scale: 5, height: 1024, width: 1024, seed: 1002 },
  });
});

const s = (n: number): number => T0 + n * 1000;
const RUN: Run = {
  model: 'flux',
  instanceType: 'ml.g6e.xlarge',
  idleMinutes: 10,
  // Scale-out 300 s, the painting 20 s later, gone 660 s after it.
  single: { paintings: 1, submitted: s(0), done: [s(380)], scaleOutStart: s(60), scaleOutEnd: s(360), scaleInEnd: s(1040) },
  // Six, 5 s apart.
  batch: {
    paintings: 6,
    submitted: s(2000),
    done: [s(2380), s(2385), s(2390), s(2395), s(2400), s(2405)],
    scaleOutStart: s(2060),
    scaleOutEnd: s(2360),
    scaleInEnd: s(3065),
  },
};

test('the costs, from what was measured', () => {
  const c = costs(RUN);
  const perSecond = 2.7636 / 3600;
  assert.equal(c.pricePerHour, 2.7636);
  assert.equal(c.coldStart, 300);
  assert.equal(c.perPainting, 5);
  assert.equal(c.tail, 660);
  assert.equal(c.singleBilled, 980);
  assert.equal(c.batchBilled, 1005);
  assert.ok(Math.abs(c.warm - perSecond * 5) < 1e-12);
  assert.ok(Math.abs(c.wake10 - perSecond * 980) < 1e-12);
  assert.ok(Math.abs(c.wake2 - perSecond * (980 - 480)) < 1e-12);
  assert.ok(Math.abs(c.batchMeasured - (perSecond * 1005) / 6) < 1e-12);
  assert.deepEqual(c.daily.map(([n]) => n), [10, 60, 100]);
  assert.ok(Math.abs((c.daily[0]?.[1] ?? 0) - (perSecond * (980 + 9 * 5)) / 10) < 1e-12);
  assert.ok(Math.abs((c.daily[2]?.[1] ?? 0) - (perSecond * (980 + 99 * 5)) / 100) < 1e-12);
});

test('g6.xlarge at its own price; an unknown instance refused', () => {
  assert.equal(costs({ ...RUN, model: 'sdxl', instanceType: 'ml.g6.xlarge' }).pricePerHour, 1.195);
  assert.throws(() => costs({ ...RUN, instanceType: 'ml.g5.xlarge' }), { message: 'trial-price' });
  assert.throws(() => costs({ ...RUN, single: { ...RUN.single, scaleInEnd: s(10) } }), { message: 'trial-times' });
  assert.throws(() => costs({ ...RUN, batch: { ...RUN.batch, done: [s(2380)] } }), { message: 'trial-round' });
});

test('the report: the basis, the measures and every cost', () => {
  const text = report(RUN);
  assert.match(text, /Price basis: USD 2\.7636 per hour, the Training price \[READ\]; hosting \[ASSUMED\]/);
  assert.match(text, /\| Cold start, scale-out to in service \| 300\.0 s \|/);
  assert.match(text, /\| Time per painting, warm \| 5\.0 s \|/);
  assert.match(text, /\| Warm \| USD 0\.0038 \|/);
  assert.match(text, /\| Woken for each, idle 10 minutes \| USD 0\.7523 \|/);
  assert.match(text, /\| Woken for each, idle 2 minutes \(derived\) \| USD 0\.3838 \|/);
  assert.match(text, /\| Daily batch of 60 \(derived\) \| USD 0\.0163 \|/);
  assert.match(report({ ...RUN, instanceType: 'ml.g6.xlarge' }), /USD 1\.195 per hour, EUN1-AsyncInf \[READ\]/);
  for (const scene of SCENES) {
    assert.equal(text.includes(scene), false);
  }
});

test('the command line', () => {
  assert.deepEqual(parseArgs(['flux', BUCKET, '/tmp/x']), {
    model: 'flux',
    bucket: BUCKET,
    folder: '/tmp/x',
    instanceType: 'ml.g6e.xlarge',
    idleMinutes: 10,
  });
  assert.equal(parseArgs(['flux', BUCKET, '/tmp/x', '10', 'yes']).instanceType, 'ml.g6.xlarge');
  assert.equal(parseArgs(['sdxl', BUCKET, '/tmp/x', '2']).idleMinutes, 2);
  for (const bad of [
    [],
    ['sd3', BUCKET, '/tmp/x'],
    ['flux', 'Bad_Bucket', '/tmp/x'],
    ['flux', BUCKET],
    ['flux', BUCKET, ''],
    ['flux', BUCKET, '/tmp/x', '1'],
    ['flux', BUCKET, '/tmp/x', '10', 'maybe'],
    ['flux', BUCKET, '/tmp/x', '10', 'no', 'more'],
  ]) {
    assert.throws(() => parseArgs(bad), { message: 'trial-usage' }, bad.join(' '));
  }
});

// The fake AWS: the endpoint wakes 60 s after a request, is in service
// 300 s later (or coldMs, a wait for capacity), paints one every 20 s, and is gone 10 minutes after its
// last painting.
interface Fake {
  aws: Aws;
  calls: string[][];
  now: () => number;
  sleep: (ms: number) => Promise<void>;
}

function fake(options: { fail?: boolean; notPng?: boolean; rmFails?: boolean; coldMs?: number } = {}): Fake {
  let now = T0;
  const calls: string[][] = [];
  const results: { key: string; ready: number }[] = [];
  const failures: string[] = [];
  const acts: { to: number; start: number; end: number }[] = [];
  let pending: number[] = [];
  let busyUntil = 0;
  const instances = (): number => {
    const live = acts.filter((a) => a.end <= now).at(-1);
    return live?.to ?? 0;
  };
  const aws: Aws = async (args) => {
    calls.push([...args]);
    const [service, op] = args;
    if (service === 'sagemaker' && op === 'describe-endpoint') {
      return JSON.stringify({ ProductionVariants: [{ CurrentInstanceCount: instances() }] });
    }
    if (service === 's3' && op === 'cp') {
      const to = args[3] ?? '';
      if (!to.startsWith('s3://')) {
        writeFileSync(to, options.notPng ? 'nope' : Buffer.from([0x89, 0x50, 0x4e, 0x47, 1]));
      }
      return '';
    }
    if (service === 's3' && op === 'rm') {
      if (options.rmFails) {
        throw new Error('fake-rm');
      }
      return '';
    }
    if (service === 'sagemaker-runtime') {
      const id = `${results.length + failures.length}`;
      if (options.fail) {
        failures.push(`fail/flux/${id}-error.out`);
      } else {
        if (busyUntil < now) {
          // A wake: out from none, in service, then idle.
          const cold = options.coldMs ?? 300000;
          acts.push({ to: 1, start: now + 60000, end: now + 60000 + cold });
          busyUntil = now + 60000 + cold;
        }
        busyUntil += 20000;
        results.push({ key: `out/flux/${id}.out`, ready: busyUntil });
        pending.push(busyUntil);
      }
      return JSON.stringify({
        OutputLocation: `s3://${BUCKET}/out/flux/${id}.out`,
        FailureLocation: `s3://${BUCKET}/fail/flux/${id}-error.out`,
      });
    }
    if (service === 's3api' && op === 'list-objects-v2') {
      const prefix = args[args.indexOf('--prefix') + 1] ?? '';
      if (prefix.startsWith('fail/')) {
        return JSON.stringify({ Contents: failures.map((k) => ({ Key: k, LastModified: new Date(now).toISOString() })) });
      }
      const ready = results.filter((r) => r.ready <= now);
      return JSON.stringify(
        ready.length === 0
          ? {}
          : { Contents: ready.map((r) => ({ Key: r.key, LastModified: new Date(r.ready).toISOString() })) },
      );
    }
    if (service === 'application-autoscaling') {
      return JSON.stringify({
        ScalingActivities: acts
          .filter((a) => a.end <= now)
          .reverse()
          .map((a) => ({
            Description: `Setting desired instance count to ${a.to}.`,
            StartTime: new Date(a.start).toISOString(),
            EndTime: new Date(a.end).toISOString(),
            StatusCode: 'Successful',
          })),
      });
    }
    throw new Error('fake-unknown');
  };
  const sleep = async (ms: number): Promise<void> => {
    now += ms;
    // After the last painting, 10 idle minutes and a minute to go.
    if (pending.length > 0 && results.every((r) => r.ready <= now)) {
      const lastReady = Math.max(...pending);
      if (now >= lastReady) {
        acts.push({ to: 0, start: lastReady + 600000, end: lastReady + 660000 });
        pending = [];
      }
    }
  };
  return { aws, calls, now: () => now, sleep };
}

function trialOf(f: Fake, folder: string, notes: string[]): Trial {
  return {
    aws: f.aws,
    clock: { now: f.now, sleep: f.sleep },
    model: 'flux',
    bucket: BUCKET,
    folder,
    note: (code, numbers = []) => notes.push([code, ...numbers].join(' ')),
  };
}

test('a round: requests through S3, PNG asked, times from S3', async () => {
  const f = fake();
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    const r = await round(trialOf(f, folder, []), [0, 1], 'batch');
    assert.equal(r.submitted, T0);
    assert.deepEqual(r.done, [T0 + 380000, T0 + 400000]);
    const invokes = f.calls.filter((c) => c[0] === 'sagemaker-runtime');
    assert.equal(invokes.length, 2);
    for (const c of invokes) {
      assert.deepEqual(c.slice(0, 4), ['sagemaker-runtime', 'invoke-endpoint-async', '--endpoint-name', 'souldreams-trial-flux']);
      assert.equal(c[c.indexOf('--content-type') + 1], 'application/json');
      assert.equal(c[c.indexOf('--accept') + 1], 'image/png');
      assert.match(c[c.indexOf('--input-location') + 1] ?? '', new RegExp(`^s3://${BUCKET}/in/flux/`));
    }
    for (const c of f.calls) {
      assert.equal(c[c.indexOf('--region') + 1], 'eu-north-1', c.join(' '));
    }
    // The request files are gone from the Mac once sent.
    assert.equal(readdirSync(tmpdir()).filter((n) => n.startsWith(`trial-flux-${T0}-`)).length, 0);
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a failed painting stops the run with a code', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    await assert.rejects(round(trialOf(fake({ fail: true }), folder, []), [0], 'single'), { message: 'trial-failed' });
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('the run: one painting, then six, each round back to none', async () => {
  const f = fake();
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  const notes: string[] = [];
  try {
    const run = await trial(trialOf(f, folder, notes), 'ml.g6e.xlarge', 10);
    assert.deepEqual(readdirSync(join(folder, 'flux')).sort(), [
      '1.png',
      '2.png',
      '3.png',
      '4.png',
      '5.png',
      '6.png',
      'raw.json',
      'results.json',
      'results.md',
      'wake-1.png',
    ]);
    assert.equal(run.single.paintings, 1);
    assert.equal(run.batch.paintings, 6);
    const c = costs(run);
    assert.equal(c.coldStart, 300);
    assert.equal(c.perPainting, 20);
    assert.equal(c.tail, 660);
    assert.equal(readFileSync(join(folder, 'flux', 'results.md'), 'utf8'), report(run));
    assert.deepEqual(notes, ['waitIdle', 'submitted 1', 'singleDone', 'submitted 6', 'batchDone', 'finished']);
    for (const name of ['raw.json', 'results.json', 'results.md']) {
      const text = readFileSync(join(folder, 'flux', name), 'utf8');
      assert.equal(text.includes(STYLE), false, name);
    }
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

// Every request, result and failure of the model is deleted when the run
// ends, after the images are saved (D138; the lifecycle rule is the backstop).
function removals(calls: string[][]): string[][] {
  return calls.filter((c) => c[0] === 's3' && c[1] === 'rm');
}
const REMOVED = ['in', 'out', 'fail'].map((p) => [
  's3',
  'rm',
  `s3://${BUCKET}/${p}/flux/`,
  '--recursive',
  '--only-show-errors',
  '--region',
  'eu-north-1',
]);

test('the run deletes its requests, results and failures when it ends', async () => {
  const f = fake();
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    await trial(trialOf(f, folder, []), 'ml.g6e.xlarge', 10);
    assert.deepEqual(removals(f.calls), REMOVED);
    // After the last image is saved, and nothing is read from S3 after.
    const last = f.calls.length - 1;
    assert.deepEqual(f.calls.slice(last - 2), REMOVED);
    const lastCopy = f.calls.map((c) => c[0] === 's3' && c[1] === 'cp').lastIndexOf(true);
    assert.ok(lastCopy < last - 2);
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

// A stop keeps fail/, the only record of a failure on SageMaker's side
// (D139): the teardown empties the bucket, the lifecycle rule backs it up.
test('a stopped run keeps fail/, deletes in/ and out/', async () => {
  for (const options of [{ fail: true }, { notPng: true }, { fail: true, rmFails: true }]) {
    const f = fake(options);
    const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
    try {
      await assert.rejects(trial(trialOf(f, folder, []), 'ml.g6e.xlarge', 10), {
        message: options.notPng ? 'trial-not-png' : 'trial-failed',
      });
      assert.deepEqual(removals(f.calls), options.rmFails ? REMOVED.slice(0, 1) : REMOVED.slice(0, 2));
    } finally {
      rmSync(folder, { recursive: true, force: true });
    }
  }
});

// A wake can wait for capacity: about 90 minutes once (D140).
const MINUTE = 60000;

test('a wake that waits for capacity still gets its result', async () => {
  const f = fake({ coldMs: 178 * MINUTE });
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    const r = await round(trialOf(f, folder, []), [0], 'single');
    assert.deepEqual(r.done, [T0 + 60000 + 178 * MINUTE + 20000]);
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a result after three hours is not waited for', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    await assert.rejects(round(trialOf(fake({ coldMs: 181 * MINUTE }), folder, []), [0], 'single'), {
      message: 'trial-no-result',
    });
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

// The request is still in SageMaker's queue after this stop, so its input
// stays (D140); the lifecycle rule deletes it.
test('a stop with no result keeps in/ and fail/, deletes out/', async () => {
  const f = fake({ coldMs: 4 * 60 * MINUTE });
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    await assert.rejects(trial(trialOf(f, folder, []), 'ml.g6e.xlarge', 10), { message: 'trial-no-result' });
    assert.deepEqual(removals(f.calls), [REMOVED[1]]);
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a deletion failing after a good run stops with a code', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    await assert.rejects(trial(trialOf(fake({ rmFails: true }), folder, []), 'ml.g6e.xlarge', 10), {
      message: 'trial-cleanup',
    });
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a result that is not a PNG stops the run', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-run-'));
  try {
    await assert.rejects(trial(trialOf(fake({ notPng: true }), folder, []), 'ml.g6e.xlarge', 10), {
      message: 'trial-not-png',
    });
    assert.equal(existsSync(join(folder, 'flux', 'results.md')), false);
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a round with no scaling found is refused, not guessed', () => {
  const r = { submitted: s(0), done: [s(380)] };
  assert.throws(() => framed([], 1, r), { message: 'trial-activities' });
  const out = { to: 1, start: s(60), end: s(360) };
  assert.throws(() => framed([out], 1, r), { message: 'trial-activities' });
  const late = { to: 1, start: s(60), end: s(400) };
  const inn = { to: 0, start: s(980), end: s(1040) };
  assert.throws(() => framed([late, inn], 1, r), { message: 'trial-activities' });
  assert.deepEqual(framed([out, inn], 1, r), {
    paintings: 1,
    submitted: s(0),
    done: [s(380)],
    scaleOutStart: s(60),
    scaleOutEnd: s(360),
    scaleInEnd: s(1040),
  });
});
