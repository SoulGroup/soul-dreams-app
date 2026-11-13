// The front door (head's message 14; D71): POST / with the beta key gets a
// short-lived Soniox key; anything else gets nothing, with one code. It
// never touches the caller's address, the body or another header (R3, R4).
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import { type DoorDeps, type DoorEvent, makeDoor } from '../src/door.ts';
import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from '../src/parameter-names.ts';
import { setSink } from '../src/safe-log.ts';
import { SonioxFailure } from '../src/soniox.ts';

const KEY = 'Ab0'.repeat(16);
const PROJECT = 'project-key-in-a-test';
const ISSUED = { key: 'snx_temp_test', expiresAt: '2026-11-13T12:00:00Z' };

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

interface Calls {
  read: string[];
  soniox: string[];
}

function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
  const calls: Calls = { read: [], soniox: [] };
  return {
    calls,
    deps: {
      readParameter: async (name) => {
        calls.read.push(name);
        return name === BETA_KEY_PARAMETER ? KEY : PROJECT;
      },
      temporaryKey: async (project) => {
        calls.soniox.push(project);
        return ISSUED;
      },
      ...over,
    },
  };
}

// A function URL's event in which everything but the method, the path
// and the authorization header throws when touched.
function event(method: string, path: string, authorization?: string): DoorEvent {
  const guard = <T extends object>(target: T, allowed: string[]): T =>
    new Proxy(target, {
      get(t, p) {
        if (typeof p === 'string' && !allowed.includes(p)) throw new Error(`touched ${p}`);
        return Reflect.get(t, p);
      },
    });
  const headers: Record<string, string> = { 'user-agent': 'x', 'x-forwarded-for': '192.0.2.1' };
  if (authorization !== undefined) headers['authorization'] = authorization;
  return guard(
    {
      rawPath: path,
      headers: guard(headers, ['authorization']),
      body: 'a body',
      requestContext: guard({ http: guard({ method, sourceIp: '192.0.2.1' }, ['method']) }, ['http']),
    },
    ['rawPath', 'headers', 'requestContext'],
  );
}

test('the right key: 200 and a short-lived key, one code', async () => {
  const d = deps();
  const reply = await makeDoor(d.deps)(event('POST', '/', `Bearer ${KEY}`));
  assert.deepEqual(reply, {
    statusCode: 200,
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify(ISSUED),
  });
  assert.deepEqual(d.calls.read, [BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER]);
  assert.deepEqual(d.calls.soniox, [PROJECT]);
  assert.deepEqual(lines, ['keyIssued']);
});

test('a wrong, missing or misshapen key: 401, Soniox never asked', async () => {
  for (const authorization of [
    `Bearer ${KEY.slice(0, 47)}1`,
    undefined,
    KEY,
    `bearer ${KEY}`,
    `Bearer ${KEY} `,
    'Bearer ',
  ]) {
    const d = deps();
    lines = [];
    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', authorization)), { statusCode: 401 });
    assert.deepEqual(d.calls.soniox, []);
    assert.deepEqual(lines, ['keyRefused']);
  }
});

test('a misshapen key is refused before anything is read', async () => {
  for (const authorization of [undefined, 'Bearer short', `Bearer ${KEY}-`, KEY]) {
    const d = deps();
    lines = [];
    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', authorization)), { statusCode: 401 });
    assert.deepEqual(d.calls.read, []);
    assert.deepEqual(lines, ['keyRefused']);
  }
});

test('another method or path: 404, nothing read', async () => {
  for (const [method, path] of [
    ['GET', '/'],
    ['POST', '/x'],
    ['PUT', '/'],
    ['POST', ''],
  ] as const) {
    const d = deps();
    lines = [];
    assert.deepEqual(await makeDoor(d.deps)(event(method, path, `Bearer ${KEY}`)), { statusCode: 404 });
    assert.deepEqual(d.calls.read, []);
    assert.deepEqual(lines, ['notFound']);
  }
});

test('Parameter Store failing: 500 and a code', async () => {
  const d = deps({
    readParameter: async () => {
      throw new Error('invented failure text');
    },
  });
  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 500 });
  assert.deepEqual(lines, ['parameterFailed']);
  const later = deps({
    readParameter: async (name) => {
      if (name === SONIOX_KEY_PARAMETER) throw new Error('invented failure text');
      return KEY;
    },
  });
  lines = [];
  assert.deepEqual(await makeDoor(later.deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 500 });
  assert.deepEqual(lines, ['parameterFailed']);
});

test("Soniox failing: 502 and its status, never its message", async () => {
  for (const [thrown, logged] of [
    [new SonioxFailure(402), 'sonioxKeyFailed 402'],
    [new SonioxFailure(-1), 'sonioxKeyFailed -1'],
    [new Error('invented failure text'), 'sonioxKeyFailed 0'],
  ] as const) {
    const d = deps({
      temporaryKey: async () => {
        throw thrown;
      },
    });
    lines = [];
    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 502 });
    assert.deepEqual(lines, [logged]);
  }
});

test('a failure anywhere else: 500 and a code', async () => {
  let first = true;
  restore();
  restore = setSink((line) => {
    if (first) {
      first = false;
      throw new Error('invented failure text');
    }
    lines.push(line);
  });
  assert.deepEqual(await makeDoor(deps().deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 500 });
  assert.deepEqual(lines, ['handlerFailed']);
});
