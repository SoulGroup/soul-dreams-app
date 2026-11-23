// The trial's weights script (trial/fetch-weights.sh) against a fake hub
// and a fake AWS CLI, both small programs on PATH: no network, no AWS.
// The repository, files and token are invented.
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { chmodSync, existsSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';

const SCRIPT = fileURLToPath(new URL('../trial/fetch-weights.sh', import.meta.url));
const HUB = 'https://hub.invented';
const REPO = 'maker/model';
const REV = 'a'.repeat(40);
const TOKEN = 'invented-token-value';
const BUCKET = 'trial-bucket-invented';

const sha256 = (b: Buffer): string => createHash('sha256').update(b).digest('hex');
const gitOid = (b: Buffer): string =>
  createHash('sha1').update(Buffer.concat([Buffer.from(`blob ${b.length}\0`), b])).digest('hex');

// The hub's files: [path, content, large (with a sha256)].
const FILES: [string, string, boolean][] = [
  ['model_index.json', '{"_class_name":"Pipe","unet":["d","U"],"vae":["d","V"],"tokenizer":["t","T"]}', false],
  ['unet/config.json', '{"u":1}', false],
  ['unet/diffusion_pytorch_model.safetensors', 'unet weights', true],
  ['unet/diffusion_pytorch_model.fp16.safetensors', 'unet half', true],
  ['unet/model.onnx', 'onnx', true],
  ['vae/diffusion_pytorch_model.safetensors', 'vae weights', true],
  ['tokenizer/vocab.json', '{"a":1}', false],
  ['tokenizer/merges.txt', 'a b', false],
  ['vae_1_0/diffusion_pytorch_model.safetensors', 'other vae', true],
  ['whole.safetensors', 'single file', true],
  ['README.md', 'readme', false],
];
const WANTED = [
  'model_index.json',
  'tokenizer/merges.txt',
  'tokenizer/vocab.json',
  'unet/config.json',
  'unet/diffusion_pytorch_model.safetensors',
  'vae/diffusion_pytorch_model.safetensors',
];

const FAKES = fileURLToPath(new URL('trial-fakes/', import.meta.url));

interface Setup {
  state: string;
  run: (args?: string[], env?: Record<string, string>) => { status: number | null; stdout: string; stderr: string };
}

function setup(changeHub: (b: Buffer, p: string) => Buffer = (b) => b): Setup {
  const state = mkdtempSync(join(tmpdir(), 'trial-fetch-'));
  const bin = join(state, 'bin');
  mkdirSync(bin);
  for (const name of ['curl', 'aws']) {
    writeFileSync(join(bin, name), `#!/bin/sh\nexec '${process.execPath}' '${FAKES}${name}.cjs' "$@"\n`);
  }
  chmodSync(join(bin, 'curl'), 0o755);
  chmodSync(join(bin, 'aws'), 0o755);
  const tree = FILES.map(([p, content, large]) => {
    const b = Buffer.from(content);
    const file = join(state, 'hub', p);
    mkdirSync(dirname(file), { recursive: true });
    writeFileSync(file, changeHub(b, p));
    const entry = { type: 'file', path: p, size: b.length, oid: gitOid(b) };
    return large ? { ...entry, lfs: { oid: sha256(b), size: b.length, pointerSize: 130 } } : entry;
  });
  writeFileSync(join(state, 'tree.json'), JSON.stringify([{ type: 'directory', path: 'unet', size: 0, oid: 'x' }, ...tree]));
  const run = (args = [HUB, REPO, REV, 'sdxl', BUCKET], env: Record<string, string> = {}) => {
    const r = spawnSync('bash', [SCRIPT, ...args], {
      encoding: 'utf8',
      env: {
        PATH: `${bin}:${process.env['PATH'] ?? ''}`,
        TMPDIR: tmpdir(),
        FAKE_STATE: state,
        FAKE_TOKEN: TOKEN,
        FAKE_HUB: HUB,
        FAKE_REPO: REPO,
        FAKE_REV: REV,
        ...env,
      },
    });
    return { status: r.status, stdout: r.stdout, stderr: r.stderr };
  };
  return { state, run };
}

function uploaded(state: string): string[] {
  const root = join(state, 's3', BUCKET, 'models', 'sdxl');
  return WANTED.filter((p) => existsSync(join(root, p))).concat(
    FILES.map(([p]) => p).filter((p) => !WANTED.includes(p) && existsSync(join(root, p))),
  );
}

test("weights: only the parts' files, checked, kept on a rerun", () => {
  const { state, run } = setup();
  try {
    const first = run();
    assert.equal(first.status, 0, first.stderr);
    assert.equal(first.stdout, 'fetched 6 kept 0\n');
    assert.deepEqual(uploaded(state), WANTED);
    for (const p of WANTED) {
      const content = FILES.find(([q]) => q === p)?.[1] ?? '';
      assert.equal(readFileSync(join(state, 's3', BUCKET, 'models', 'sdxl', p), 'utf8'), content);
    }
    const again = run();
    assert.equal(again.status, 0, again.stderr);
    assert.equal(again.stdout, 'fetched 0 kept 6\n');
  } finally {
    rmSync(state, { recursive: true, force: true });
  }
});

test('weights: the token never on a command line or screen', () => {
  const { state, run } = setup();
  try {
    const r = run();
    assert.equal(r.status, 0, r.stderr);
    const argv = readFileSync(join(state, 'argv'), 'utf8');
    assert.equal(argv.includes(TOKEN), false);
    assert.equal(r.stdout.includes(TOKEN) || r.stderr.includes(TOKEN), false);
    assert.match(argv, /"--name","\/souldreams\/trial\/hf-token","--with-decryption"/);
    for (const line of argv.trim().split('\n')) {
      const call = JSON.parse(line) as string[];
      if (call[0] === 'aws') {
        assert.equal(call[call.indexOf('--region') + 1], 'eu-north-1', line);
      }
    }
  } finally {
    rmSync(state, { recursive: true, force: true });
  }
});

test('weights: a large file read back wrong is removed; a stop', () => {
  const { state, run } = setup();
  try {
    const r = run(undefined, { FAKE_CORRUPT: 'unet/diffusion_pytorch_model.safetensors' });
    assert.equal(r.status, 3);
    assert.equal(r.stderr, 'fetch-hash unet/diffusion_pytorch_model.safetensors\n');
    assert.equal(existsSync(join(state, 's3', BUCKET, 'models', 'sdxl', 'unet', 'diffusion_pytorch_model.safetensors')), false);
  } finally {
    rmSync(state, { recursive: true, force: true });
  }
});

test('weights: a small file unlike the hub is never uploaded', () => {
  const { state, run } = setup((b, p) => (p === 'unet/config.json' ? Buffer.from('{"u":2}') : b));
  try {
    const r = run();
    assert.equal(r.status, 3);
    assert.equal(r.stderr, 'fetch-hash unet/config.json\n');
    assert.equal(existsSync(join(state, 's3', BUCKET, 'models', 'sdxl', 'unet', 'config.json')), false);
  } finally {
    rmSync(state, { recursive: true, force: true });
  }
});

test('weights: the arguments are refused unless exact', () => {
  const { state, run } = setup();
  try {
    assert.equal(run([HUB, REPO, REV, 'sdxl']).status, 2);
    assert.equal(run([HUB, REPO, REV, 'sd3', BUCKET]).status, 2);
    assert.equal(run([HUB, REPO, 'main', 'sdxl', BUCKET]).status, 2);
    assert.equal(run([HUB, REPO, 'A'.repeat(40), 'sdxl', BUCKET]).status, 2);
    assert.equal(run([HUB, REPO, 'a'.repeat(39), 'sdxl', BUCKET]).status, 2);
    assert.equal(existsSync(join(state, 'argv')), false);
  } finally {
    rmSync(state, { recursive: true, force: true });
  }
});
