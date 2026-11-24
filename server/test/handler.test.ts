// The handler is the front door, wired (D71). What it decides is tested
// in door.test.ts; here, a request it must refuse reaches neither
// Parameter Store nor Soniox, and logs its one code.
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import { handler } from '../src/handler.ts';
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
