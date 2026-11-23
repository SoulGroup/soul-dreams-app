// The trial's serving code (server/trial/code/inference.py) against
// stand-ins for PyTorch and diffusers: each case is one run of
// trial_inference_cases.py, which exits 0 when it holds.
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';

const CASES = fileURLToPath(new URL('trial_inference_cases.py', import.meta.url));

function holds(name: string): void {
  const run = spawnSync('python3', ['-I', '-B', CASES, name], { encoding: 'utf8' });
  assert.equal(run.status, 0, run.stderr);
}

test('serving: full precision, straight onto the GPU', () => holds('full_precision'));
test('serving: a request gives its words, settings and seed', () => holds('request'));
test('serving: refusals are codes, never the words', () => holds('refusals'));
test('serving: seeded on the GPU, answered as PNG', () => holds('seeded_on_the_gpu'));
test('serving: 8 bits from the pinned wheel, offline', () => holds('eight_bit'));
