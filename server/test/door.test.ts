// The front door (head's message 14; D71; D152): POST / with the beta key
// gets a short-lived Soniox key; POST /feedback with it keeps one feedback;
// anything else gets nothing, with one code. It never touches the caller's
// address or another header, and reads a body only for feedback, after the
// key (R3, R4).
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

// Not today's date, so a door that took the clock's own day is caught.
const NOW = new Date('2025-12-31T23:30:00Z');

interface Calls {
  read: string[];
  soniox: string[];
  kept: [string, string][];
}

function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
  const calls: Calls = { read: [], soniox: [], kept: [] };
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
      keepFeedback: async (day, text) => {
        calls.kept.push([day, text]);
      },
      now: () => NOW,
      ...over,
    },
  };
}

// A function URL's event in which everything but the method, the path
// and the authorization header throws when touched; with [body], the body
// and whether it is base64 may be read too.
function event(method: string, path: string, authorization?: string, body?: string, base64 = false): DoorEvent {
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
      body: body ?? 'a body',
      isBase64Encoded: base64,
      requestContext: guard({ http: guard({ method, sourceIp: '192.0.2.1' }, ['method']) }, ['http']),
    },
    body === undefined ? ['rawPath', 'headers', 'requestContext'] : ['rawPath', 'headers', 'requestContext', 'body', 'isBase64Encoded'],
  );
}

const feedback = (text: unknown): string => JSON.stringify({ text });

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
    ['GET', '/feedback'],
    ['POST', '/feedback/'],
    ['POST', '/Feedback'],
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

test('feedback: kept under its UTC day, 204, one code', async () => {
  const d = deps();
  const reply = await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, feedback('The app opens slowly.')));
  assert.deepEqual(reply, { statusCode: 204 });
  assert.deepEqual(d.calls.kept, [['2025-12-31', 'The app opens slowly.']]);
  assert.deepEqual(d.calls.read, [BETA_KEY_PARAMETER]);
  assert.deepEqual(d.calls.soniox, []);
  assert.deepEqual(lines, ['feedbackKept']);
});

test('feedback: a base64 body is read as its text', async () => {
  const d = deps();
  const body = Buffer.from(feedback('Två rader.'), 'utf8').toString('base64');
  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, body, true)), { statusCode: 204 });
  assert.deepEqual(d.calls.kept, [['2025-12-31', 'Två rader.']]);
});

test('feedback: a bad key refused before the body is read', async () => {
  for (const authorization of [`Bearer ${KEY.slice(0, 47)}1`, undefined, 'Bearer short']) {
    const d = deps();
    lines = [];
    // A body that throws when read: the key is checked first.
    const e = event('POST', '/feedback', authorization);
    assert.deepEqual(await makeDoor(d.deps)(e), { statusCode: 401 });
    assert.deepEqual(d.calls.kept, []);
    assert.deepEqual(lines, ['keyRefused']);
  }
});

test('feedback: refused, nothing kept, its status logged', async () => {
  for (const [body, status] of [
    ['', 400],
    [feedback(' \n '), 400],
    ['not json', 400],
    [JSON.stringify({ text: 'a', day: '2026-11-24' }), 400],
    [feedback('a'.repeat(2001)), 413],
  ] as const) {
    const d = deps();
    lines = [];
    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, body)), { statusCode: status });
    assert.deepEqual(d.calls.kept, []);
    assert.deepEqual(lines, [`feedbackRefused ${status}`]);
  }
});

test('feedback: the store failing: 502 and a code', async () => {
  const d = deps({
    keepFeedback: async () => {
      throw new Error('invented failure text');
    },
  });
  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, feedback('The app opens slowly.'))), {
    statusCode: 502,
  });
  assert.deepEqual(lines, ['feedbackFailed']);
});

test('feedback: Parameter Store failing: 500, nothing kept', async () => {
  const d = deps({
    readParameter: async () => {
      throw new Error('invented failure text');
    },
  });
  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, feedback('a'))), { statusCode: 500 });
  assert.deepEqual(d.calls.kept, []);
  assert.deepEqual(lines, ['parameterFailed']);
});
