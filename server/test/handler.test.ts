// The handler (D42 Q15): 404 with no body and one logged code; on a
// failure, 500 and a code, never the error's message (R3).
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import { handler } from '../src/handler.ts';
import { setSink } from '../src/safe-log.ts';

let lines: string[] = [];
let restore = (): void => {};
beforeEach(() => {
  lines = [];
});
afterEach(() => {
  restore();
});

test('every request: 404, no body, one code', async () => {
  restore = setSink((line) => {
    lines.push(line);
  });
  assert.deepEqual(await handler(), { statusCode: 404 });
  assert.deepEqual(lines, ['notFound']);
});

test('a failure: 500 and a code, never its message', async () => {
  let first = true;
  restore = setSink((line) => {
    if (first) {
      first = false;
      throw new Error('invented failure text');
    }
    lines.push(line);
  });
  assert.deepEqual(await handler(), { statusCode: 500 });
  assert.deepEqual(lines, ['handlerFailed']);
});
