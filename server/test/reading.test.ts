// The readings' request and the stand-in model (head's message 33; D134):
// what a request may hold, and the fixed placeholder readings the stand-in
// gives for every night, reading nothing of it.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { STAND_IN_TEXT } from '../src/models.ts';
import {
  READING_BODY_LIMIT,
  STAND_IN_READINGS,
  parseReading,
  parseReadings,
  promptFor,
  readNight,
} from '../src/reading.ts';

const night = (over: Record<string, unknown> = {}): string => JSON.stringify({ lang: 'en', dreams: ['a', 'b'], ...over });

test('a night: its language, dreams, and kept sentences when sent', () => {
  assert.deepEqual(parseReading(night()), { request: { lang: 'en', dreams: ['a', 'b'], kept: [] } });
  assert.deepEqual(parseReading(night({ lang: 'sv', kept: ['c'] })), {
    request: { lang: 'sv', dreams: ['a', 'b'], kept: ['c'] },
  });
  assert.deepEqual(parseReading(night({ kept: [] })), { request: { lang: 'en', dreams: ['a', 'b'], kept: [] } });
});

test('anything else: 400', () => {
  for (const body of [
    '',
    'not json',
    '[]',
    'null',
    JSON.stringify({ dreams: ['a'] }),
    JSON.stringify({ lang: 'en' }),
    night({ lang: 'de' }),
    night({ dreams: [] }),
    night({ dreams: 'a' }),
    night({ dreams: ['a', 1] }),
    night({ dreams: ['a', ' \n '] }),
    night({ kept: 'c' }),
    night({ kept: ['c', 2] }),
    night({ kept: null }),
    night({ id: 'x' }),
  ]) {
    assert.deepEqual(parseReading(body), { refused: 400 }, body);
  }
});

test('a body over the limit: 413, unread', () => {
  const at = night({ dreams: ['a'.repeat(READING_BODY_LIMIT - night({ dreams: [''] }).length)] });
  assert.equal(at.length, READING_BODY_LIMIT);
  assert.ok('request' in parseReading(at));
  assert.deepEqual(parseReading(`${at} `), { refused: 413 });
});

test("the prompt: the instructions first, in their order; the night last", () => {
  const request = { lang: 'sv' as const, dreams: ['Ett hus.'], kept: ['En mening.'] };
  const p = promptFor([{ name: 'a.md', text: 'one' }, { name: 'b.md', text: 'two' }], request);
  assert.deepEqual(p.fixed, ['one', 'two']);
  assert.equal(p.words, JSON.stringify(request));
  // Nothing of the night in the fixed, cacheable part.
  assert.ok(p.fixed.every((f) => !f.includes('Ett hus') && !f.includes('En mening')));
});

test("the model's answer: one to three whole readings, or null", () => {
  const r = (n: number) => Array.from({ length: n }, (_, i) => ({ lens: i, text: '[x]' }));
  assert.deepEqual(parseReadings(JSON.stringify({ readings: r(1) })), r(1));
  assert.deepEqual(parseReadings(JSON.stringify({ readings: r(3) })), r(3));
  for (const text of [
    'not json',
    '[]',
    JSON.stringify({ readings: [] }),
    JSON.stringify({ readings: r(4) }),
    JSON.stringify({ readings: [{ lens: -1, text: '[x]' }] }),
    JSON.stringify({ readings: [{ lens: 1.5, text: '[x]' }] }),
    JSON.stringify({ readings: [{ lens: 1, text: '' }] }),
    JSON.stringify({ readings: [{ lens: 1, text: '[x]', more: 1 }] }),
    JSON.stringify({ readings: r(1), more: 1 }),
  ]) {
    assert.equal(parseReadings(text), null, text);
  }
});

test('the stand-in: three placeholder readings, marked, the same for every night', async () => {
  assert.deepEqual(STAND_IN_READINGS, [
    { lens: 0, text: '[STAND-IN · 1]' },
    { lens: 1, text: '[STAND-IN · 2]' },
    { lens: 2, text: '[STAND-IN · 3]' },
  ]);
  assert.equal(STAND_IN_TEXT, JSON.stringify({ readings: STAND_IN_READINGS }));
  assert.deepEqual(parseReadings(STAND_IN_TEXT), STAND_IN_READINGS);
  assert.ok(Object.isFrozen(STAND_IN_READINGS) && STAND_IN_READINGS.every((r) => Object.isFrozen(r)));
});

test('a night read: the readings step, prompt, readings, one call', async () => {
  const request = { lang: 'en' as const, dreams: ['A red door.'], kept: [] };
  const seen: unknown[] = [];
  const read = await readNight([{ name: 'a.md', text: 'one' }], request, async (step, p) => {
    seen.push([step, p]);
    return { text: STAND_IN_TEXT, call: { step, model: 'stand-in', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 } };
  });
  assert.deepEqual(seen, [['readings', { fixed: ['one'], words: JSON.stringify(request) }]]);
  assert.deepEqual(read, {
    readings: STAND_IN_READINGS,
    usage: [{ step: 'readings', model: 'stand-in', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 }],
  });
});

test('an answer that is not readings fails the night', async () => {
  await assert.rejects(
    readNight([], { lang: 'en', dreams: ['a'], kept: [] }, async (step) => ({
      text: 'not readings',
      call: { step, model: 'stand-in', input: 1, output: 1, cacheRead: 0, cacheWrite: 0, cost: 0 },
    })),
  );
});
