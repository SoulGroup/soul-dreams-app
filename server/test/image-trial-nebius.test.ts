// The Nebius image test (D142), against a fake of its API: no key, no
// network. The key and the folder are invented.
import assert from 'node:assert/strict';
import { existsSync, mkdtempSync, readdirSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { NEBIUS_IMAGES_URL } from '../src/hosts.ts';
import { prompt } from '../trial/measure.ts';
import { measure, parseArgs, type Send } from '../trial/nebius.ts';

const KEY = 'invented-key-0123456789';
const PNG = Buffer.from([0x89, 0x50, 0x4e, 0x47, 1, 2, 3]);

interface Seen {
  url: string;
  headers: Record<string, string>;
  body: Record<string, unknown>;
}

function fakeSend(status = 200, image: Buffer = PNG): { send: Send; seen: Seen[] } {
  const seen: Seen[] = [];
  const send: Send = async (url, init) => {
    seen.push({ url, headers: init.headers, body: JSON.parse(init.body) as Record<string, unknown> });
    return {
      status,
      json: async () => (status === 200 ? { data: [{ b64_json: image.toString('base64') }], id: 'x' } : { error: KEY }),
    };
  };
  return { send, seen };
}

function clock(): () => number {
  let t = 0;
  return () => (t += 1500);
}

test('each model paints the six prompts; images and times are saved', async () => {
  const { send, seen } = fakeSend();
  const folder = mkdtempSync(join(tmpdir(), 'trial-nebius-'));
  try {
    await measure(send, KEY, folder, clock());
    assert.equal(seen.length, 12);
    for (const s of seen) {
      assert.equal(s.url, NEBIUS_IMAGES_URL);
      assert.equal(s.headers.Authorization, `Bearer ${KEY}`);
      assert.equal(s.headers['Content-Type'], 'application/json');
      assert.equal(s.body.response_format, 'b64_json');
      assert.equal(s.body.response_extension, 'png');
      assert.equal(s.body.width, 1024);
      assert.equal(s.body.height, 1024);
    }
    assert.deepEqual(
      seen.map((s) => s.body.model),
      [...Array(6).fill('black-forest-labs/flux-schnell'), ...Array(6).fill('stability-ai/sdxl')],
    );
    assert.deepEqual(
      seen.slice(0, 6).map((s) => [s.body.prompt, s.body.seed]),
      [0, 1, 2, 3, 4, 5].map((i) => [prompt(i), 1000 + i]),
    );
    assert.equal(seen[0]?.body.num_inference_steps, 4);
    assert.equal(seen[6]?.body.num_inference_steps, 30);
    for (const m of ['flux-schnell', 'sdxl']) {
      assert.deepEqual(readdirSync(join(folder, m)).sort(), ['1.png', '2.png', '3.png', '4.png', '5.png', '6.png', 'results.md', 'timings.json']);
      assert.deepEqual(JSON.parse(readFileSync(join(folder, m, 'timings.json'), 'utf8')), { milliseconds: Array(6).fill(1500) });
      const text = readFileSync(join(folder, m, 'results.md'), 'utf8');
      assert.equal(text.includes(KEY), false);
      assert.equal(text.includes(prompt(0)), false);
    }
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('an error stops with a code, nothing of the reply', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-nebius-'));
  try {
    await assert.rejects(measure(fakeSend(401).send, KEY, folder, clock()), { message: 'nebius-http-401' });
    const failing: Send = async () => {
      throw new Error(`down ${KEY}`);
    };
    await assert.rejects(measure(failing, KEY, folder, clock()), { message: 'nebius-network' });
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('a reply that is not a PNG stops the test', async () => {
  const folder = mkdtempSync(join(tmpdir(), 'trial-nebius-'));
  try {
    await assert.rejects(measure(fakeSend(200, Buffer.from('not an image')).send, KEY, folder, clock()), {
      message: 'nebius-not-png',
    });
    assert.equal(existsSync(join(folder, 'flux-schnell', '1.png')), false);
  } finally {
    rmSync(folder, { recursive: true, force: true });
  }
});

test('the command needs the key from the environment and a folder', () => {
  assert.deepEqual(parseArgs({ NEBIUS_API_KEY: KEY }, ['/tmp/x']), { key: KEY, folder: '/tmp/x' });
  for (const [env, argv] of [
    [{}, ['/tmp/x']],
    [{ NEBIUS_API_KEY: '' }, ['/tmp/x']],
    [{ NEBIUS_API_KEY: KEY }, []],
    [{ NEBIUS_API_KEY: KEY }, ['']],
    [{ NEBIUS_API_KEY: KEY }, ['/tmp/x', 'more']],
  ] as const) {
    assert.throws(() => parseArgs(env, argv), { message: 'nebius-usage' });
  }
});
