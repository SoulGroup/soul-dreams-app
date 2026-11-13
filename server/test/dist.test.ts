// The Lambda's code folder (D42 Q5): the compiled code alone, with the
// module marker beside it. `npm test` builds it first.
import assert from 'node:assert/strict';
import { readdirSync, readFileSync } from 'node:fs';
import { test } from 'node:test';

const CODE = new URL('../dist/src/', import.meta.url);

test('the compiled files and the marker, nothing else', () => {
  const files = readdirSync(CODE, { recursive: true }).map(String).sort();
  assert.deepEqual(files, [
    'beta-key.js',
    'door.js',
    'handler.js',
    'hosts.js',
    'package.json',
    'parameter-names.js',
    'safe-log.js',
    'soniox.js',
  ]);
});

test('the marker makes the code a module', () => {
  assert.equal(readFileSync(new URL('package.json', CODE), 'utf8'), '{"type":"module"}\n');
});

test('imports end in .js', () => {
  assert.match(readFileSync(new URL('handler.js', CODE), 'utf8'), /from "\.\/safe-log\.js";/);
});
