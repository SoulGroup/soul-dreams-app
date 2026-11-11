// The server's safe logger (CLAUDE.md R3, G5): an event code and
// numbers, never a string.
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import { LOG_EVENTS, type LogEvent, safeLog, setSink } from '../src/safe-log.ts';

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

test('the events are these', () => {
  assert.deepEqual(LOG_EVENTS, ['notFound', 'handlerFailed']);
});

test('a code alone', () => {
  safeLog('notFound');
  assert.deepEqual(lines, ['notFound']);
});

test('a code and numbers', () => {
  safeLog('handlerFailed', [3, 0.5, -1]);
  assert.deepEqual(lines, ['handlerFailed 3 0.5 -1']);
});

test('an unknown code is refused', () => {
  assert.throws(() => safeLog(('other' as string) as LogEvent), { message: 'safe-log-code' });
  assert.deepEqual(lines, []);
});

test('a number that is not finite is refused', () => {
  for (const n of [Number.NaN, Number.POSITIVE_INFINITY]) {
    assert.throws(() => safeLog('notFound', [n]), { message: 'safe-log-number' });
  }
  assert.deepEqual(lines, []);
});

// Never called: `npm run check` fails if either line stops being an
// error, that is if the logger ever takes a string (R3).
export function neverCalled(): void {
  // @ts-expect-error a string is never a log number
  safeLog('notFound', ['x']);
  // @ts-expect-error a code is one of LOG_EVENTS
  safeLog('x');
}
