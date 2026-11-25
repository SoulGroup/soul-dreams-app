// Every model call through one interface (head's message 34): the model
// named per step in one setting; each call's tokens and cost counted and
// logged as numbers only; prompt caching off until AWS's pages say it fits
// retention mode none; the stand-in behind it like any model.
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import {
  type Caller,
  MODELS,
  PRICES,
  PROMPT_CACHING,
  SETUP,
  STAND_IN_TEXT,
  STEPS,
  callModel,
  costOf,
  standInCaller,
} from '../src/models.ts';
import { setSink } from '../src/safe-log.ts';

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

const prompt = { fixed: ['instructions'], words: '{"dreams":["a"]}' };

test('the steps, and one setting naming each step its model', () => {
  assert.deepEqual(STEPS, ['opening', 'readings', 'checks', 'scenery', 'recurrence']);
  assert.deepEqual(MODELS, ['stand-in']);
  assert.deepEqual(Object.keys(SETUP), [...STEPS]);
  for (const step of STEPS) assert.deepEqual(SETUP[step], { model: 'stand-in' });
  assert.ok(Object.isFrozen(SETUP));
});

test('prompt caching is off until confirmed', () => {
  assert.equal(PROMPT_CACHING, false);
});

test("a call goes to its step's model, prompt and caching switch", async () => {
  const seen: unknown[] = [];
  const caller: Caller = async (choice, p, cache) => {
    seen.push([choice, p, cache]);
    return { text: 'x', usage: { input: 10, output: 2, cacheRead: 3, cacheWrite: 4 } };
  };
  const setup = { ...SETUP, readings: { model: 'stand-in' as const, reasoningCap: 64 } };
  const answer = await callModel('readings', prompt, { setup, callers: { 'stand-in': caller }, caching: false });
  assert.deepEqual(seen, [[{ model: 'stand-in', reasoningCap: 64 }, prompt, false]]);
  assert.deepEqual(answer, {
    text: 'x',
    call: { step: 'readings', model: 'stand-in', input: 10, output: 2, cacheRead: 3, cacheWrite: 4, cost: 0 },
  });
});

test('each call logs its step, model, tokens and cost, numbers only', async () => {
  const caller: Caller = async () => ({ text: 'never logged', usage: { input: 7, output: 5, cacheRead: 1, cacheWrite: 2 } });
  await callModel('scenery', prompt, { setup: SETUP, callers: { 'stand-in': caller }, caching: false });
  assert.deepEqual(lines, ['modelUsage 3 0 7 5 1 2 0']);
});

test('the cost: each count at its price, in millionths', () => {
  assert.deepEqual(PRICES['stand-in'], { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 });
  const price = { input: 4, output: 20, cacheRead: 1, cacheWrite: 5 };
  assert.equal(costOf(price, { input: 1000, output: 100, cacheRead: 10, cacheWrite: 2 }), 4000 + 2000 + 10 + 10);
});

test("a model failing: the call fails, nothing logged", async () => {
  const caller: Caller = async () => {
    throw new Error('invented failure text');
  };
  await assert.rejects(callModel('readings', prompt, { setup: SETUP, callers: { 'stand-in': caller }, caching: false }));
  assert.deepEqual(lines, []);
});

test('the stand-in: the same placeholder, zero tokens, whatever asked', async () => {
  const one = await standInCaller({ model: 'stand-in' }, prompt, false);
  const two = await standInCaller({ model: 'stand-in' }, { fixed: [], words: 'other' }, true);
  assert.deepEqual(one, { text: STAND_IN_TEXT, usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 } });
  assert.deepEqual(two, one);
});
