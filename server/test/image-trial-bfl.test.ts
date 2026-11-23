// The Black Forest Labs image test (D144), against a fake of its API: no
// key, no network. The key and the folder are invented.
import assert from 'node:assert/strict';
import { existsSync, mkdtempSync, readdirSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { BFL_API_URL } from '../src/hosts.ts';
import { prompt } from '../trial/measure.ts';
import { measure, parseArgs, type Clock, type Reply, type Send } from '../trial/bfl.ts';

const KEY = 'invented-key-0123456789';
const PNG = Buffer.from([0x89, 0x50, 0x4e, 0x47, 1, 2, 3]);
const POLLING = 'https://api.eu.bfl.ai/v1/get_result?id=n';
const IMAGE = 'https://delivery-eu1.bfl.ai/n.png';

interface Seen {
  method: string;
  url: string;
  headers: Record<string, string>;
  body: Record<string, unknown> | undefined;
}

interface Options {
  post?: number;
  statuses?: readonly string[];
  polling?: string;
  image?: Buffer;
  throws?: boolean;
}

// Every request takes 500 ms; a poll answers Pending first, then the status.
function fake(options: Options = {}): { send: Send; seen: Seen[]; clock: Clock; elapsed: () => number } {
  let t = 0;
  const seen: Seen[] = [];
  let polls = 0;
  const reply = (status: number, json: unknown, bytes?: Buffer): Reply => ({
    status,
    json: async () => json,
    bytes: async () => bytes ?? Buffer.alloc(0),
  });
  const send: Send = async (url, init) => {
    t += 500;
    seen.push({
      method: init.method,
      url,
      headers: init.headers,
      body: init.body === undefined ? undefined : (JSON.parse(init.body) as Record<string, unknown>),
    });
    if (options.throws) {
      throw new Error(`down ${KEY}`);
    }
    if (init.method === 'POST') {
      const post = options.post ?? 200;
      return reply(post, post === 200 ? { id: 'n', polling_url: options.polling ?? POLLING, cost: 0.9 } : { detail: KEY });
    }
    if (url === IMAGE) {
      return reply(200, {}, options.image ?? PNG);
    }
    polls += 1;
    const status = options.statuses?.[Math.min(polls - 1, options.statuses.length - 1)] ?? (polls % 2 === 1 ? 'Pending' : 'Ready');
    return reply(200, status === 'Ready' ? { status, result: { sample: IMAGE } } : { status, detail: KEY });
  };
  const clock: Clock = {
    now: () => t,
    sleep: async (ms) => {
      t += ms;
    },
  };
  return { send, seen, clock, elapsed: () => t };
}

test('each model paints six prompts; images, times, credits saved', async () => {
  const f = fake();
  const folder = mkdtempSync(join(tmpdir(), 'trial-bfl-'));
  try {
    await measure(f.send, KEY, folder, f.clock);
    const posts = f.seen.filter((s) => s.method === 'POST');
    assert.equal(posts.length, 12);
    assert.deepEqual(
      posts.map((s) => s.url),
      [...Array(6).fill(`${BFL_API_URL}/flux-3-image-klein`), ...Array(6).fill(`${BFL_API_URL}/flux-2-klein-4b`)],
    );
    for (const s of posts) {
      assert.equal(s.headers['x-key'], KEY);
      assert.equal(s.headers['Content-Type'], 'application/json');
      assert.equal(s.body?.output_format, 'png');
    }
    assert.deepEqual(
      posts.slice(0, 6).map((s) => [s.body?.prompt, s.body?.seed]),
      [0, 1, 2, 3, 4, 5].map((i) => [prompt(i), 1000 + i]),
    );
    assert.equal(posts[0]?.body?.resolution, '1k');
    assert.equal(posts[0]?.body?.aspect_ratio, '1:1');
    assert.equal(posts[6]?.body?.width, 1024);
    assert.equal(posts[6]?.body?.height, 1024);
    // The key goes to the API and to its polling address, never to the image's.
    for (const s of f.seen.filter((x) => x.method === 'GET')) {
      assert.equal(s.headers['x-key'], s.url === IMAGE ? undefined : KEY);
    }
    for (const m of ['flux-3-image-klein', 'flux-2-klein-4b']) {
      assert.deepEqual(readdirSync(join(folder, m)).sort(), ['1.png', '2.png', '3.png', '4.png', '5.png', '6.png', 'results.md', 'timings.json']);
      assert.deepEqual(JSON.parse(readFileSync(join(folder, m, 'timings.json'), 'utf8')), {
        milliseconds: Array(6).fill(3000),
        credits: Array(6).fill(0.9),
      });
      const text = readFileSync(join(folder, m, 'results.md'), 'utf8');
      assert.equal(text.includes(KEY), false);
      assert.equal(text.includes(prompt(0)), false);
      assert.match(text, /Mean: 3\.0 seconds/);
    }
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('an error stops with a code, nothing of the reply', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-bfl-'));
  try {
    for (const [options, code] of [
      [{ post: 401 }, 'bfl-http-401'],
      [{ throws: true }, 'bfl-network'],
      [{ statuses: ['Request Moderated'] }, 'bfl-moderated'],
      [{ statuses: ['Content Moderated'] }, 'bfl-moderated'],
      [{ statuses: ['Error'] }, 'bfl-failed'],
      [{ statuses: ['Task not found'] }, 'bfl-failed'],
    ] as const) {
      const f = fake(options);
      await assert.rejects(measure(f.send, KEY, folder, f.clock), { message: code }, code);
    }
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a polling address off the API host gets no request', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-bfl-'));
  try {
    for (const polling of ['https://polling.example.org/x', 'http://api.eu.bfl.ai/x', 'not a url']) {
      const f = fake({ polling });
      await assert.rejects(measure(f.send, KEY, folder, f.clock), { message: 'bfl-polling' }, polling);
      assert.deepEqual(f.seen.map((s) => s.method), ['POST']);
    }
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a result not in two minutes stops the test', async () => {
  const f = fake({ statuses: ['Pending'] });
  const folder = mkdtempSync(join(tmpdir(), 'trial-bfl-'));
  try {
    await assert.rejects(measure(f.send, KEY, folder, f.clock), { message: 'bfl-no-result' });
    assert.ok(f.elapsed() >= 120000 && f.elapsed() < 130000, String(f.elapsed()));
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('an image that is not a PNG stops the test', async () => {
  const f = fake({ image: Buffer.from('not an image') });
  const folder = mkdtempSync(join(tmpdir(), 'trial-bfl-'));
  try {
    await assert.rejects(measure(f.send, KEY, folder, f.clock), { message: 'bfl-not-png' });
    assert.equal(existsSync(join(folder, 'flux-3-image-klein', '1.png')), false);
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('the command needs the key from the environment and a folder', () => {
  assert.deepEqual(parseArgs({ BFL_API_KEY: KEY }, ['/tmp/x']), { key: KEY, folder: '/tmp/x' });
  for (const [env, argv] of [
    [{}, ['/tmp/x']],
    [{ BFL_API_KEY: '' }, ['/tmp/x']],
    [{ BFL_API_KEY: KEY }, []],
    [{ BFL_API_KEY: KEY }, ['']],
    [{ BFL_API_KEY: KEY }, ['/tmp/x', 'more']],
  ] as const) {
    assert.throws(() => parseArgs(env, argv), { message: 'bfl-usage' });
  }
});
