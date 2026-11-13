// The beta key's check (D18; D71 Q19). The keys here are plain repeats,
// never key-shaped secrets (R5, G7).
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { isBetaKeyShape, sameKey } from '../src/beta-key.ts';

const KEY = 'Ab0'.repeat(16);

test('the shape: 48 characters of A-Z, a-z and 0-9', () => {
  assert.equal(isBetaKeyShape(KEY), true);
  assert.equal(isBetaKeyShape(KEY.slice(1)), false);
  assert.equal(isBetaKeyShape(`${KEY}A`), false);
  assert.equal(isBetaKeyShape(`${KEY.slice(1)}-`), false);
  assert.equal(isBetaKeyShape(`${KEY.slice(1)}\n`), false);
  assert.equal(isBetaKeyShape(''), false);
});

test('the same key matches; one character off does not', () => {
  assert.equal(sameKey(KEY, KEY), true);
  assert.equal(sameKey(`${KEY.slice(0, 47)}1`, KEY), false);
  assert.equal(sameKey(KEY.slice(1), KEY), false);
});

test('the comparison hashes both keys and takes the same time', () => {
  // A test cannot see time, so this pins the method (D71 Q19).
  const text = readFileSync(new URL('../src/beta-key.ts', import.meta.url), 'utf8');
  assert.match(text, /return timingSafeEqual\(a, b\);/);
  assert.equal(text.match(/createHash\('sha256'\)/g)?.length, 2);
  const door = readFileSync(new URL('../src/door.ts', import.meta.url), 'utf8');
  assert.match(door, /!sameKey\(given, betaKey\)/);
  assert.doesNotMatch(door, /betaKey\s*[!=]==|[!=]==\s*betaKey/);
});
