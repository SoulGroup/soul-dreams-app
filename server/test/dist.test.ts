// The Lambda's code folder (D42 Q5): the compiled code, with the module
// marker and the model's instructions folder beside it (head's message 33).
// `npm test` builds it first.
import assert from 'node:assert/strict';
import { readdirSync, readFileSync } from 'node:fs';
import { test } from 'node:test';

const CODE = new URL('../dist/src/', import.meta.url);

test('the compiled files, the marker and the instructions, nothing else', () => {
  const files = readdirSync(CODE, { recursive: true }).map(String).sort();
  assert.deepEqual(files, [
    'beta-key.js',
    'door.js',
    'feedback-store.js',
    'feedback.js',
    'handler.js',
    'hosts.js',
    'instructions',
    'instructions.js',
    'instructions/AWAITING-INSTRUCTIONS.md',
    'jpeg.js',
    'models.js',
    'package.json',
    'painting.js',
    'parameter-names.js',
    'parameters.js',
    'reading.js',
    'safe-log.js',
    'soniox.js',
  ]);
});

test('the marker makes the code a module', () => {
  assert.equal(readFileSync(new URL('package.json', CODE), 'utf8'), '{"type":"module"}\n');
});

test('imports end in .js', () => {
  assert.match(readFileSync(new URL('handler.js', CODE), 'utf8'), /from "\.\/door\.js";/);
});

test("imports: its own, Node's, and the two AWS clients", () => {
  const files = readdirSync(CODE).filter((f) => f.endsWith('.js'));
  const outside = new Set<string>();
  for (const file of files) {
    const text = readFileSync(new URL(file, CODE), 'utf8');
    for (const m of text.matchAll(/from ["']([^"']+)["']/g)) {
      const from = m[1] ?? '';
      if (!from.startsWith('./')) outside.add(from);
    }
  }
  assert.deepEqual([...outside].sort(), ['@aws-sdk/client-s3', '@aws-sdk/client-ssm', 'node:crypto', 'node:fs']);
});

test('the instructions folder is copied whole, the placeholder empty', () => {
  assert.equal(readFileSync(new URL('instructions/AWAITING-INSTRUCTIONS.md', CODE), 'utf8'), '');
});
