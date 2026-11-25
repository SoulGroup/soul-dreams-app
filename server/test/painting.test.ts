// The night's personal painting (D143, D145, D146, D123; D162), against a
// fake of BFL's API: no key, no network. The key and every address are
// invented; the scene is the stand-in's placeholder.
import assert from 'node:assert/strict';
import { test } from 'node:test';
import { BFL_API_URL } from '../src/hosts.ts';
import { aiTagged, jpegSize } from '../src/jpeg.ts';
import { STAND_IN_SCENERY } from '../src/models.ts';
import {
  type BflReply,
  type BflSend,
  type Clock,
  FRAME,
  GIVE_UP_MS,
  MILLIONTHS_PER_CREDIT,
  PAINTING_BYTES_LIMIT,
  PAINTING_MODEL,
  PAINTING_SIZE,
  PaintingFailure,
  paint,
  paintingRefused,
  paintNight,
  promptOf,
  SCENE_LIMIT,
  SCENERY_PROMPT,
  sceneOf,
  STYLE,
} from '../src/painting.ts';
import { STYLE as TRIAL_STYLE } from '../trial/measure.ts';
import { FRAME as TRIAL_FRAME, SCENES } from '../trial/scenes.ts';
import { fakeJpeg, segment } from './curated-fakes.ts';

const KEY = 'invented-key-0123456789';
const POLLING = 'https://api.eu.bfl.ai/v1/get_result?id=n';
const IMAGE = 'https://delivery-eu1.bfl.ai/n.jpeg';
const JPEG = fakeJpeg(PAINTING_SIZE.width, PAINTING_SIZE.height);

interface Seen {
  method: string;
  url: string;
  headers: Record<string, string>;
  body: Record<string, unknown> | undefined;
}

interface Options {
  post?: number;
  statuses?: readonly string[];
  polling?: unknown;
  sample?: unknown;
  cost?: unknown;
  image?: Buffer;
  imageStatus?: number;
  throws?: 'post' | 'poll' | 'image';
  pollStatus?: number;
}

// Every request takes 500 ms; each poll answers the next status, the last
// one again and again.
function fake(options: Options = {}): { send: BflSend; seen: Seen[]; clock: Clock } {
  let t = 0;
  let polls = 0;
  const seen: Seen[] = [];
  const reply = (status: number, json: unknown, bytes?: Buffer): BflReply => ({
    status,
    json: async () => json,
    bytes: async () => bytes ?? Buffer.alloc(0),
  });
  const statuses = options.statuses ?? ['Pending', 'Ready'];
  const send: BflSend = async (url, init) => {
    t += 500;
    seen.push({
      method: init.method,
      url,
      headers: init.headers,
      body: init.body === undefined ? undefined : (JSON.parse(init.body) as Record<string, unknown>),
    });
    if (url.startsWith(BFL_API_URL) && init.method === 'POST') {
      if (options.throws === 'post') throw new Error('invented network failure');
      return reply(options.post ?? 200, {
        id: 'n',
        polling_url: 'polling' in options ? options.polling : POLLING,
        cost: 'cost' in options ? options.cost : 1.5,
      });
    }
    if (url === POLLING) {
      if (options.throws === 'poll') throw new Error('invented network failure');
      const status = statuses[Math.min(polls, statuses.length - 1)];
      polls += 1;
      return reply(options.pollStatus ?? 200, { status, result: { sample: 'sample' in options ? options.sample : IMAGE } });
    }
    if (options.throws === 'image') throw new Error('invented network failure');
    return reply(options.imageStatus ?? 200, null, options.image ?? JPEG);
  };
  return {
    send,
    seen,
    clock: {
      now: () => t,
      sleep: async (ms) => {
        t += ms;
      },
    },
  };
}

async function failsWith(promise: Promise<unknown>, code: number): Promise<void> {
  await assert.rejects(promise, (e) => e instanceof PaintingFailure && e.code === code);
}

test("style and framing are the set's, the placeholder its first scene", () => {
  assert.equal(PAINTING_MODEL, 'flux-2-klein-4b');
  assert.equal(STYLE, TRIAL_STYLE);
  assert.equal(FRAME, TRIAL_FRAME);
  assert.equal(STAND_IN_SCENERY, SCENES[0]);
  assert.equal(promptOf('a calm sea'), `a calm sea, ${FRAME}, ${STYLE}`);
  assert.deepEqual(PAINTING_SIZE, { width: 1280, height: 960 });
});

test('a request holds nothing: only {} is taken', () => {
  assert.equal(paintingRefused('{}'), null);
  assert.equal(paintingRefused(' { } '), null);
  for (const body of ['', 'x', '[]', 'null', '1', '{"dreams":["a"]}', '{"a":1}']) {
    assert.equal(paintingRefused(body), 400, body);
  }
  assert.equal(paintingRefused(`{${' '.repeat(63)}}`), 413);
});

test('the scenery step reads nothing of the night', () => {
  assert.deepEqual(SCENERY_PROMPT, { fixed: [], words: '' });
  assert.ok(Object.isFrozen(SCENERY_PROMPT));
});

test("a scene: one line, not blank, within its limit", () => {
  assert.equal(sceneOf('  a calm sea '), 'a calm sea');
  assert.equal(sceneOf('x'.repeat(SCENE_LIMIT)), 'x'.repeat(SCENE_LIMIT));
  for (const text of ['', '   ', 'a\nb', 'a\rb', 'x'.repeat(SCENE_LIMIT + 1)]) {
    assert.equal(sceneOf(text), null);
  }
});

test('a painting: the request, the polling, the tagged JPEG, the credits', async () => {
  const f = fake();
  const made = await paint(f.send, KEY, f.clock, 'a calm sea');
  assert.equal(made.credits, 1.5);
  assert.deepEqual(jpegSize(made.jpeg), PAINTING_SIZE);
  assert.ok(aiTagged(made.jpeg));
  assert.equal(aiTagged(JPEG), false);
  assert.deepEqual(f.seen, [
    {
      method: 'POST',
      url: `${BFL_API_URL}/flux-2-klein-4b`,
      headers: { 'x-key': KEY, 'Content-Type': 'application/json' },
      body: { prompt: promptOf('a calm sea'), width: 1280, height: 960, output_format: 'jpeg' },
    },
    { method: 'GET', url: POLLING, headers: { 'x-key': KEY }, body: undefined },
    { method: 'GET', url: POLLING, headers: { 'x-key': KEY }, body: undefined },
    { method: 'GET', url: IMAGE, headers: {}, body: undefined },
  ]);
});

test("BFL's statuses: refused, moderated, failed, no answer", async () => {
  let f = fake({ post: 402 });
  await failsWith(paint(f.send, KEY, f.clock, 'a'), 402);
  f = fake({ pollStatus: 500 });
  await failsWith(paint(f.send, KEY, f.clock, 'a'), 500);
  f = fake({ imageStatus: 404 });
  await failsWith(paint(f.send, KEY, f.clock, 'a'), 404);
  for (const status of ['Request Moderated', 'Content Moderated']) {
    f = fake({ statuses: [status] });
    await failsWith(paint(f.send, KEY, f.clock, 'a'), -2);
  }
  for (const status of ['Error', 'Task not found', undefined]) {
    f = fake({ statuses: [status as string] });
    await failsWith(paint(f.send, KEY, f.clock, 'a'), -3);
  }
  for (const where of ['post', 'poll', 'image'] as const) {
    f = fake({ throws: where });
    await failsWith(paint(f.send, KEY, f.clock, 'a'), 0);
  }
});

test('no image within its time: it gives up, and stops polling', async () => {
  const f = fake({ statuses: ['Pending'] });
  await failsWith(paint(f.send, KEY, f.clock, 'a'), -4);
  assert.ok(f.clock.now() <= GIVE_UP_MS + 1500);
  assert.ok(f.seen.length > 10);
});

test("the key goes only to BFL's hosts, over https", async () => {
  for (const polling of ['http://api.eu.bfl.ai/x', 'https://bfl.ai.example/x', 'not a url', 7, undefined]) {
    const f = fake({ polling });
    await failsWith(paint(f.send, KEY, f.clock, 'a'), -1);
    assert.equal(f.seen.length, 1);
  }
  for (const sample of ['http://delivery-eu1.bfl.ai/n', 'https://example.com/n', 7]) {
    const f = fake({ sample });
    await failsWith(paint(f.send, KEY, f.clock, 'a'), -1);
    assert.equal(f.seen.at(-1)?.url, POLLING);
  }
});

test("a cost that is no number: fails before polling", async () => {
  for (const cost of ['1.5', -1, Number.NaN, undefined]) {
    const f = fake({ cost });
    await failsWith(paint(f.send, KEY, f.clock, 'a'), -1);
    assert.equal(f.seen.length, 1);
  }
});

test('an image not as asked fails: size, kind, weight, a packet', async () => {
  const xmp = segment(0xe1, Buffer.from('http://ns.adobe.com/xap/1.0/\0<x/>', 'latin1'));
  const heavy = Buffer.concat([JPEG.subarray(0, JPEG.length - 2), Buffer.alloc(PAINTING_BYTES_LIMIT), JPEG.subarray(-2)]);
  for (const image of [
    fakeJpeg(1024, 1024),
    Buffer.from([0x89, 0x50, 0x4e, 0x47]),
    heavy,
    fakeJpeg(1280, 960, { extra: [xmp] }),
  ]) {
    const f = fake({ image });
    await failsWith(paint(f.send, KEY, f.clock, 'a'), -5);
  }
});

test('a night: the scenery step, its scene painted, the cost', async () => {
  const asked: unknown[] = [];
  const painted: string[] = [];
  const made = await paintNight(
    async (step, prompt) => {
      asked.push([step, prompt]);
      return { text: ` ${STAND_IN_SCENERY}\n`, call: { step, model: 'stand-in-scenery', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 } };
    },
    async (scene) => {
      painted.push(scene);
      return { jpeg: JPEG, credits: 1.4 };
    },
  );
  assert.deepEqual(asked, [['scenery', SCENERY_PROMPT]]);
  assert.deepEqual(painted, [STAND_IN_SCENERY]);
  assert.deepEqual(made, { jpeg: JPEG, cost: 14000 });
  assert.equal(MILLIONTHS_PER_CREDIT, 10000);
});

test('a night whose scene is none: nothing painted', async () => {
  let painted = 0;
  const call = { step: 'scenery', model: 'stand-in-scenery', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 } as const;
  await failsWith(
    paintNight(
      async () => ({ text: 'a\nb', call }),
      async () => {
        painted += 1;
        return { jpeg: JPEG, credits: 1 };
      },
    ),
    -6,
  );
  assert.equal(painted, 0);
});
