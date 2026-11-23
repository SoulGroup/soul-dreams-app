// The Black Forest Labs image test (D144), on the owner's Mac: the trial's
// six invented prompts, sent one after another to BFL's EU image API, the
// images, the times and the credits saved in the folder given, outside the
// repository. The key comes from the environment (the owner reads it from
// Parameter Store); nothing sent or received is written anywhere, and an
// error is a code. The API answers at once with an address to poll; the
// finished image is fetched from the address it names (which gets no key).
//   BFL_API_KEY=... node trial/bfl.ts <folder>
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { BFL_API_URL, BFL_HOST_SUFFIX } from '../src/hosts.ts';
import { prompt, SCENES } from './measure.ts';

export interface Reply {
  readonly status: number;
  json(): Promise<unknown>;
  bytes(): Promise<Buffer>;
}
export type Send = (
  url: string,
  init: { method: 'POST' | 'GET'; headers: Record<string, string>; body?: string },
) => Promise<Reply>;

export interface Clock {
  now(): number;
  sleep(ms: number): Promise<void>;
}

// The two cheapest FLUX models and their request fields, as BFL's pages
// give them [READ, docs.bfl.ai, 2026-11-23]: the first sizes by tier, the
// second by width and height.
export const BFL_MODELS = [
  { name: 'flux-3-image-klein', size: { resolution: '1k', aspect_ratio: '1:1' } },
  { name: 'flux-2-klein-4b', size: { width: 1024, height: 1024 } },
] as const;

const PNG = Buffer.from([0x89, 0x50, 0x4e, 0x47]);
const GIVE_UP_MS = 120000;
const POLL_MS = 1000;
const WAITING = ['Pending', 'Reasoning', 'Generating'];
const MODERATED = ['Request Moderated', 'Content Moderated'];

async function call(send: Send, url: string, init: Parameters<Send>[1]): Promise<Reply> {
  try {
    return await send(url, init);
  } catch {
    throw new Error('bfl-network');
  }
}

function secure(value: string): boolean {
  try {
    return new URL(value).protocol === 'https:';
  } catch {
    return false;
  }
}

function pollingUrl(value: unknown): string {
  if (typeof value !== 'string') {
    throw new Error('bfl-reply');
  }
  let url: URL;
  try {
    url = new URL(value);
  } catch {
    throw new Error('bfl-polling');
  }
  // The key is sent to this address: only to BFL's own hosts, over https.
  if (url.protocol !== 'https:' || !url.hostname.endsWith(BFL_HOST_SUFFIX)) {
    throw new Error('bfl-polling');
  }
  return url.href;
}

/** One painting: the request, the polling, the image's bytes and the credits. */
async function paint(
  send: Send,
  key: string,
  clock: Clock,
  model: (typeof BFL_MODELS)[number],
  i: number,
): Promise<{ png: Buffer; credits: number }> {
  const headers = { 'x-key': key };
  const body = JSON.stringify({ prompt: prompt(i), ...model.size, seed: 1000 + i, output_format: 'png' });
  const made = await call(send, `${BFL_API_URL}/${model.name}`, {
    method: 'POST',
    headers: { ...headers, 'Content-Type': 'application/json' },
    body,
  });
  if (made.status !== 200) {
    throw new Error(`bfl-http-${made.status}`);
  }
  const task = (await made.json()) as { polling_url?: unknown; cost?: unknown };
  const polling = pollingUrl(task.polling_url);
  const credits = typeof task.cost === 'number' ? task.cost : NaN;
  const until = clock.now() + GIVE_UP_MS;
  for (;;) {
    const polled = await call(send, polling, { method: 'GET', headers });
    if (polled.status !== 200) {
      throw new Error(`bfl-http-${polled.status}`);
    }
    const state = (await polled.json()) as { status?: unknown; result?: { sample?: unknown } };
    if (state.status === 'Ready') {
      const sample = state.result?.sample;
      if (typeof sample !== 'string' || !secure(sample)) {
        throw new Error('bfl-reply');
      }
      const got = await call(send, sample, { method: 'GET', headers: {} });
      if (got.status !== 200) {
        throw new Error(`bfl-http-${got.status}`);
      }
      return { png: await got.bytes(), credits };
    }
    if (typeof state.status === 'string' && MODERATED.includes(state.status)) {
      throw new Error('bfl-moderated');
    }
    if (typeof state.status !== 'string' || !WAITING.includes(state.status)) {
      throw new Error('bfl-failed');
    }
    if (clock.now() >= until) {
      throw new Error('bfl-no-result');
    }
    await clock.sleep(POLL_MS);
  }
}

export async function measure(send: Send, key: string, folder: string, clock: Clock): Promise<void> {
  for (const model of BFL_MODELS) {
    const dir = join(folder, model.name);
    mkdirSync(dir, { recursive: true });
    const milliseconds: number[] = [];
    const credits: number[] = [];
    for (const [i] of SCENES.entries()) {
      const start = clock.now();
      const made = await paint(send, key, clock, model, i);
      milliseconds.push(clock.now() - start);
      credits.push(made.credits);
      if (!made.png.subarray(0, 4).equals(PNG)) {
        throw new Error('bfl-not-png');
      }
      writeFileSync(join(dir, `${i + 1}.png`), made.png);
    }
    writeFileSync(join(dir, 'timings.json'), `${JSON.stringify({ milliseconds, credits }, null, 2)}\n`);
    writeFileSync(join(dir, 'results.md'), table(model.name, milliseconds, credits));
  }
}

// One credit is USD 0.01 [READ, docs.bfl.ai, 2026-11-23].
const USD_PER_CREDIT = 0.01;

function table(name: string, milliseconds: readonly number[], credits: readonly number[]): string {
  const seconds = milliseconds.map((m) => m / 1000);
  const mean = seconds.reduce((a, b) => a + b, 0) / seconds.length;
  const total = credits.reduce((a, b) => a + b, 0);
  const rows = seconds.map((s, i) => `| ${i + 1} | ${s.toFixed(1)} | ${(credits[i] ?? NaN).toFixed(2)} |`);
  return [
    `# ${name} on Black Forest Labs, EU endpoint`,
    '',
    'Seconds from request to image,' + ' one at a time, 1024 x 1024.',
    '',
    '| Painting | Seconds | Credits |',
    '|---|---|---|',
    ...rows,
    '',
    `Mean: ${mean.toFixed(1)} seconds. Credits: ${total.toFixed(2)}, USD ${(total * USD_PER_CREDIT).toFixed(3)}.`,
    '',
  ].join('\n');
}

export function parseArgs(
  env: Readonly<Record<string, string | undefined>>,
  argv: readonly string[],
): { key: string; folder: string } {
  const key = env.BFL_API_KEY;
  const [folder] = argv;
  if (key === undefined || key === '' || folder === undefined || folder === '' || argv.length > 1) {
    throw new Error('bfl-usage');
  }
  return { key, folder };
}

if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const { key, folder } = parseArgs(process.env, process.argv.slice(2));
  await measure(
    async (url, init) => {
      const r = await fetch(url, { ...init, signal: AbortSignal.timeout(60000) });
      return { status: r.status, json: () => r.json(), bytes: async () => Buffer.from(await r.arrayBuffer()) };
    },
    key,
    folder,
    { now: () => Date.now(), sleep: (ms) => new Promise((r) => setTimeout(r, ms)) },
  );
}
