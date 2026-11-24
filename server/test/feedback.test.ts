// Feedback (D152): what a request may hold, the UTC day, an object's name,
// and what is put in the bucket: the text alone, nothing else (R3, R4).
import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  BODY_LIMIT,
  FEEDBACK_BUCKET_VARIABLE,
  FEEDBACK_LIMIT,
  characters,
  feedbackKey,
  parseFeedback,
  utcDay,
} from '../src/feedback.ts';
import { makeFeedbackStore, type PutInput } from '../src/feedback-store.ts';

const body = (text: unknown): string => JSON.stringify({ text });

test('at most 2,000 characters, as a person counts them', () => {
  assert.equal(FEEDBACK_LIMIT, 2000);
  assert.equal(characters('abc'), 3);
  // One family emoji is one character, though eight UTF-16 units.
  assert.equal(characters('👨‍👩‍👧'), 1);
  assert.equal(characters('é'), 1);
  assert.equal(characters(''), 0);
});

test('one text: kept as sent, spaces and all', () => {
  assert.deepEqual(parseFeedback(body('The app opens slowly.')), { text: 'The app opens slowly.' });
  assert.deepEqual(parseFeedback(body('  Two\nlines  ')), { text: '  Two\nlines  ' });
});

test('exactly 2,000 characters kept; one more refused', () => {
  assert.deepEqual(parseFeedback(body('a'.repeat(2000))), { text: 'a'.repeat(2000) });
  assert.deepEqual(parseFeedback(body('a'.repeat(2001))), { refused: 413 });
  const family = '👨‍👩‍👧'.repeat(2000);
  assert.deepEqual(parseFeedback(body(family)), { text: family });
  assert.deepEqual(parseFeedback(body(`${family}a`)), { refused: 413 });
});

test('a body too long is refused before it is read', () => {
  assert.equal(BODY_LIMIT, 65536);
  assert.deepEqual(parseFeedback(`${body('a')}${' '.repeat(BODY_LIMIT)}`), { refused: 413 });
  assert.deepEqual(parseFeedback(`{${' '.repeat(BODY_LIMIT)}`), { refused: 413 });
});

test('empty, blank, not JSON or not one text: refused', () => {
  for (const given of [
    '',
    'text',
    '[]',
    'null',
    '"a text"',
    body(''),
    body(' \n\t '),
    body(3),
    body(null),
    JSON.stringify({}),
    JSON.stringify({ text: 'a', day: '2026-11-24' }),
    JSON.stringify({ words: 'a' }),
  ]) {
    assert.deepEqual(parseFeedback(given), { refused: 400 }, given);
  }
});

test('the UTC day, whatever the hour', () => {
  assert.equal(utcDay(new Date('2026-11-24T00:00:00Z')), '2026-11-24');
  assert.equal(utcDay(new Date('2026-11-24T23:59:59.999Z')), '2026-11-24');
  assert.equal(utcDay(new Date('2026-11-25T00:30:00+01:00')), '2026-11-24');
});

test("an object's name: its day, then 128 random bits, nothing else", () => {
  assert.equal(feedbackKey('2026-11-24', Buffer.alloc(16, 0xab)), `2026-11-24/${'ab'.repeat(16)}.txt`);
});

test('the store puts the text alone, as text, under its day', async () => {
  const puts: PutInput[] = [];
  const keep = makeFeedbackStore(
    'a-bucket',
    async (input) => {
      puts.push(input);
    },
    () => Buffer.alloc(16, 1),
  );
  await keep('2026-11-24', 'The app opens slowly.');
  assert.deepEqual(puts, [
    {
      Bucket: 'a-bucket',
      Key: `2026-11-24/${'01'.repeat(16)}.txt`,
      Body: 'The app opens slowly.',
      ContentType: 'text/plain; charset=utf-8',
    },
  ]);
});

test('each feedback its own random name', async () => {
  const keys: string[] = [];
  const keep = makeFeedbackStore('a-bucket', async (input) => {
    keys.push(input.Key);
  });
  await keep('2026-11-24', 'one');
  await keep('2026-11-24', 'two');
  assert.equal(keys.length, 2);
  assert.notEqual(keys[0], keys[1]);
  for (const key of keys) assert.match(key, /^2026-11-24\/[0-9a-f]{32}\.txt$/);
});

test('no bucket named: nothing put, a bare failure', async () => {
  let called = false;
  const keep = makeFeedbackStore('', async () => {
    called = true;
  });
  await assert.rejects(keep('2026-11-24', 'The app opens slowly.'), { message: 'feedback-bucket' });
  assert.equal(called, false);
});

test("the bucket's name reaches the Lambda in one variable", () => {
  assert.equal(FEEDBACK_BUCKET_VARIABLE, 'FEEDBACK_BUCKET');
});
