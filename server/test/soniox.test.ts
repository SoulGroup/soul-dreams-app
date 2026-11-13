// The request for a short-lived Soniox key (D71 Q10; R4): its address,
// its four fields exactly, and every way the answer can fail.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { SONIOX_TEMPORARY_KEY_URL } from '../src/hosts.ts';
import { type Fetch, requestTemporaryKey, SonioxFailure, TEMPORARY_KEY_REQUEST } from '../src/soniox.ts';

const PROJECT = 'project-key-in-a-test';

function answering(status: number, body: string, seen: { url?: string; init?: RequestInit }[] = []): Fetch {
  return async (url, init) => {
    seen.push({ url, init });
    return new Response(body, { status });
  };
}

async function failure(fetchFn: Fetch): Promise<number> {
  try {
    await requestTemporaryKey(PROJECT, fetchFn);
  } catch (e) {
    assert.ok(e instanceof SonioxFailure);
    return e.status;
  }
  assert.fail('no failure');
}

test('exactly these four fields and no other (R4)', () => {
  assert.deepEqual(Object.keys(TEMPORARY_KEY_REQUEST).sort(), [
    'expires_in_seconds',
    'max_session_duration_seconds',
    'single_use',
    'usage_type',
  ]);
  assert.deepEqual(TEMPORARY_KEY_REQUEST, {
    usage_type: 'transcribe_websocket',
    expires_in_seconds: 60,
    single_use: true,
    max_session_duration_seconds: 1800,
  });
  assert.ok(Object.isFrozen(TEMPORARY_KEY_REQUEST));
});

test('one POST to the EU host, the project key as bearer', async () => {
  const seen: { url?: string; init?: RequestInit }[] = [];
  const key = await requestTemporaryKey(
    PROJECT,
    answering(201, JSON.stringify({ api_key: 'snx_temp_test', expires_at: '2026-11-13T12:00:00Z' }), seen),
  );
  assert.deepEqual(key, { key: 'snx_temp_test', expiresAt: '2026-11-13T12:00:00Z' });
  assert.equal(seen.length, 1);
  assert.equal(seen[0]?.url, SONIOX_TEMPORARY_KEY_URL);
  assert.equal(seen[0]?.init?.method, 'POST');
  assert.deepEqual(seen[0]?.init?.headers, {
    authorization: `Bearer ${PROJECT}`,
    'content-type': 'application/json',
  });
  assert.deepEqual(JSON.parse(String(seen[0]?.init?.body)), TEMPORARY_KEY_REQUEST);
  assert.ok(seen[0]?.init?.signal instanceof AbortSignal);
});

test("Soniox's refusal carries its status", async () => {
  assert.equal(await failure(answering(402, '{}')), 402);
  assert.equal(await failure(answering(429, '{}')), 429);
  assert.equal(await failure(answering(200, '{}')), 200);
});

test('no answer is 0; an unreadable answer is -1', async () => {
  assert.equal(
    await failure(async () => {
      throw new TypeError('fetch failed');
    }),
    0,
  );
  assert.equal(await failure(answering(201, 'not json')), -1);
  assert.equal(await failure(answering(201, '{"expires_at":"x"}')), -1);
  assert.equal(await failure(answering(201, '{"api_key":"","expires_at":"x"}')), -1);
  assert.equal(await failure(answering(201, '{"api_key":"k"}')), -1);
  assert.equal(await failure(answering(201, 'null')), -1);
});
