// The handler is the front door, wired (D71). What it decides is tested
// in door.test.ts; here, a request it must refuse reaches neither
// Parameter Store nor Soniox, and logs its one code.
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import type { PutInput } from '../src/feedback-store.ts';
import { handler, wire } from '../src/handler.ts';
import { type Caller, STAND_IN_TEXT } from '../src/models.ts';
import { STAND_IN_READINGS } from '../src/reading.ts';
import { setSink } from '../src/safe-log.ts';

const KEY = 'Ab0'.repeat(16);

let lines: string[] = [];
let restore = (): void => {};
beforeEach(() => {
  lines = [];
  restore = setSink((line) => {
    lines.push(line);
  });
});
afterEach(() => {
  restore();
});

test('another method: 404, no body, one code', async () => {
  const reply = await handler({ rawPath: '/', requestContext: { http: { method: 'GET' } } });
  assert.deepEqual(reply, { statusCode: 404 });
  assert.deepEqual(lines, ['notFound']);
});

test('a misshapen key: 401 before anything is read', async () => {
  const reply = await handler({
    rawPath: '/',
    headers: { authorization: 'Bearer short' },
    requestContext: { http: { method: 'POST' } },
  });
  assert.deepEqual(reply, { statusCode: 401 });
  assert.deepEqual(lines, ['keyRefused']);
});

test('feedback with a misshapen key: 401, nothing read or kept', async () => {
  const reply = await handler({
    rawPath: '/feedback',
    headers: { authorization: 'Bearer short' },
    body: JSON.stringify({ text: 'a' }),
    requestContext: { http: { method: 'POST' } },
  });
  assert.deepEqual(reply, { statusCode: 401 });
  assert.deepEqual(lines, ['keyRefused']);
});

// The wiring of feedback (D152 item 1): the bucket is the one the Lambda's
// variable names, and with none named nothing is sent.
const sendFeedback = (door: ReturnType<typeof wire>) =>
  door({
    rawPath: '/feedback',
    headers: { authorization: `Bearer ${KEY}` },
    body: JSON.stringify({ text: 'The app opens slowly.' }),
    requestContext: { http: { method: 'POST' } },
  });

test('feedback goes to the bucket the variable names', async () => {
  const puts: PutInput[] = [];
  const door = wire(
    { FEEDBACK_BUCKET: 'bucket-in-a-test' },
    async (input) => {
      puts.push(input);
    },
    async () => KEY,
  );
  assert.deepEqual(await sendFeedback(door), { statusCode: 204 });
  assert.equal(puts.length, 1);
  assert.equal(puts[0]?.Bucket, 'bucket-in-a-test');
  assert.equal(puts[0]?.Body, 'The app opens slowly.');
  assert.deepEqual(lines, ['feedbackKept']);
});

test('no bucket named: feedback fails with 502 and nothing is sent', async () => {
  const puts: PutInput[] = [];
  const door = wire(
    {},
    async (input) => {
      puts.push(input);
    },
    async () => KEY,
  );
  assert.deepEqual(await sendFeedback(door), { statusCode: 502 });
  assert.deepEqual(puts, []);
  assert.deepEqual(lines, ['feedbackFailed']);
});

// The wiring of a reading (head's messages 33 and 34): the readings step's
// model, through the one interface, handed the instructions read from the
// folder beside the code, first, and the night last.
test("a reading goes to its step's model with the folder's instructions", async () => {
  const seen: unknown[] = [];
  const caller: Caller = async (choice, prompt, cache) => {
    seen.push([choice, prompt, cache]);
    return { text: JSON.stringify({ readings: [{ lens: 1, text: '[x]' }] }), usage: { input: 3, output: 2, cacheRead: 0, cacheWrite: 0 } };
  };
  const door = wire({}, async () => {}, async () => KEY, { 'stand-in': caller }, () => [{ name: 'a.md', text: 'b' }]);
  const reply = await door({
    rawPath: '/reading',
    headers: { authorization: `Bearer ${KEY}` },
    body: JSON.stringify({ lang: 'en', dreams: ['A red door.'] }),
    requestContext: { http: { method: 'POST' } },
  });
  assert.deepEqual(reply.statusCode, 200);
  assert.deepEqual(JSON.parse(reply.body ?? ''), {
    readings: [{ lens: 1, text: '[x]' }],
    usage: [{ step: 'readings', model: 'stand-in', input: 3, output: 2, cacheRead: 0, cacheWrite: 0, cost: 0 }],
  });
  const night = JSON.stringify({ lang: 'en', dreams: ['A red door.'], kept: [] });
  assert.deepEqual(seen, [[{ model: 'stand-in' }, { fixed: ['b'], words: night }, false]]);
  assert.deepEqual(lines, ['modelUsage 1 0 3 2 0 0 0', 'readingGiven 1']);
});

test('the handler reads with the stand-in, and the instructions once', async () => {
  let reads = 0;
  const door = wire({}, async () => {}, async () => KEY, undefined, () => {
    reads++;
    return [];
  });
  const send = () =>
    door({
      rawPath: '/reading',
      headers: { authorization: `Bearer ${KEY}` },
      body: JSON.stringify({ lang: 'sv', dreams: ['x'] }),
      requestContext: { http: { method: 'POST' } },
    });
  const first = await send();
  await send();
  assert.equal(reads, 1);
  assert.deepEqual(JSON.parse(first.body ?? '').readings, STAND_IN_READINGS);
  assert.equal(JSON.parse(STAND_IN_TEXT).readings.length, 3);
});
