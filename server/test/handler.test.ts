// The handler is the front door, wired (D71). What it decides is tested
// in door.test.ts; here, a request it must refuse reaches neither
// Parameter Store nor Soniox, and logs its one code.
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import type { PutInput } from '../src/feedback-store.ts';
import { handler, wire } from '../src/handler.ts';
import { type Caller, STAND_IN_SCENERY, STAND_IN_TEXT, standInSceneryCaller } from '../src/models.ts';
import { type BflSend, type Clock, promptOf } from '../src/painting.ts';
import { BFL_KEY_PARAMETER } from '../src/parameter-names.ts';
import { aiTagged } from '../src/jpeg.ts';
import { fakeJpeg } from './curated-fakes.ts';
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
  const door = wire({}, async () => {}, async () => KEY, { 'stand-in': caller, 'stand-in-scenery': standInSceneryCaller }, () => [
    { name: 'a.md', text: 'b' },
  ]);
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

// The wiring of a painting (D162): the scenery step's stand-in, its scene
// painted with BFL's key from Parameter Store, the JPEG tagged, as base64.
test("a painting: the scenery stand-in's scene, BFL's key, the tagged JPEG", async () => {
  const read: string[] = [];
  const posted: { url: string; key: string | undefined; prompt: unknown }[] = [];
  const send: BflSend = async (url, init) => {
    posted.push({ url, key: init.headers['x-key'], prompt: init.body === undefined ? undefined : JSON.parse(init.body).prompt });
    const json = url.includes('get_result')
      ? { status: 'Ready', result: { sample: 'https://delivery-eu1.bfl.ai/n.jpeg' } }
      : { polling_url: 'https://api.eu.bfl.ai/v1/get_result?id=n', cost: 1.4 };
    return { status: 200, json: async () => json, bytes: async () => fakeJpeg(1280, 960) };
  };
  const clock: Clock = { now: () => 0, sleep: async () => {} };
  const door = wire({}, async () => {}, async (name) => {
    read.push(name);
    return name === BFL_KEY_PARAMETER ? 'invented-bfl-key' : KEY;
  }, undefined, () => [], send, clock);
  const reply = await door({
    rawPath: '/painting',
    headers: { authorization: `Bearer ${KEY}` },
    body: '{}',
    requestContext: { http: { method: 'POST' } },
  });
  assert.equal(reply.statusCode, 200);
  assert.equal(reply.isBase64Encoded, true);
  assert.ok(aiTagged(Buffer.from(reply.body ?? '', 'base64')));
  assert.deepEqual(read, ['/souldreams/beta-key', BFL_KEY_PARAMETER]);
  assert.equal(posted[0]?.prompt, promptOf(STAND_IN_SCENERY));
  assert.deepEqual(posted.map((p) => p.key), ['invented-bfl-key', 'invented-bfl-key', undefined]);
  assert.deepEqual(lines, ['modelUsage 3 1 0 0 0 0 0', 'paintingGiven 14000']);
});
