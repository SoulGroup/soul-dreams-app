// The model's instructions (R7; head's message 33): files dropped into
// server/instructions/, read in name order; the placeholder is not one.
import assert from 'node:assert/strict';
import { mkdtempSync, readdirSync, readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { test } from 'node:test';
import { PLACEHOLDER, readInstructions } from '../src/instructions.ts';

const folder = (files: Record<string, string>): URL => {
  const dir = mkdtempSync(join(tmpdir(), 'instructions-'));
  for (const [name, text] of Object.entries(files)) {
    if (name.endsWith('/')) mkdirSync(join(dir, name));
    else writeFileSync(join(dir, name), text);
  }
  return pathToFileURL(`${dir}/`);
};

test('the folder holds only the placeholder, and it is empty', () => {
  const here = new URL('../instructions/', import.meta.url);
  assert.deepEqual(readdirSync(here), [PLACEHOLDER]);
  assert.equal(readFileSync(new URL(PLACEHOLDER, here), 'utf8'), '');
  assert.deepEqual(readInstructions(here), []);
});

test('every .md file but the placeholder, in name order, unchanged', () => {
  const dir = folder({ [PLACEHOLDER]: '', 'b.md': 'two\n', 'a.md': 'one', 'c.txt': 'no', 'e.md/': '' });
  assert.deepEqual(readInstructions(dir), [
    { name: 'a.md', text: 'one' },
    { name: 'b.md', text: 'two\n' },
  ]);
});

test('no folder: an error, never an empty set of instructions', () => {
  assert.throws(() => readInstructions(new URL('gone/', folder({ 'a.md': 'x' }))));
});
