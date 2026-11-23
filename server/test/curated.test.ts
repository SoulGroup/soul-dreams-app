// The curated set's painter (D147), against a fake of BFL's API and a
// stand-in for sips: no key, no network. Every folder is a fresh one in the
// temporary folder.
import assert from 'node:assert/strict';
import { existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';
import { createHash } from 'node:crypto';
import { BFL_API_URL } from '../src/hosts.ts';
import {
  CAP_CREDITS,
  ITEMS,
  MODEL,
  PAINTING,
  RESERVE_CREDITS,
  SKY,
  checkJpeg,
  fileOf,
  paintSet,
  parseArgs,
  proof,
  repaint,
  seedOf,
  ship,
  sipsArgs,
  sipsConvert,
  type SetState,
} from '../trial/curated.ts';
import { aiTagged, hasSrgb, jpegSize, withAiTag } from '../trial/jpeg.ts';
import { STYLE } from '../trial/measure.ts';
import { FRAME, SCENES, SKY_SCENE, scenePrompt, skyPrompt } from '../trial/scenes.ts';
import { KEY, fakeApi, fakeConvert, fakeJpeg, fakePng, fakeProfile } from './curated-fakes.ts';

function folder(): string {
  return mkdtempSync(join(tmpdir(), 'curated-'));
}

function state(dir: string): SetState {
  return JSON.parse(readFileSync(join(dir, 'set.json'), 'utf8')) as SetState;
}

const words = (s: string) => s.split(/\s+/).filter(Boolean).length;

test('sixty invented scenes, each short, the frame and the style', () => {
  assert.equal(SCENES.length, 60);
  assert.equal(new Set(SCENES).size, 60);
  for (const scene of [...SCENES, SKY_SCENE]) {
    assert.ok(words(scene) < 12, scene);
    assert.doesNotMatch(scene, /\b(man|woman|child|people|person|figure|word|sign|letter)s?\b/i);
  }
  assert.equal(scenePrompt(1), `${SCENES[0]}, ${FRAME}, ${STYLE}`);
  assert.equal(scenePrompt(60), `${SCENES[59]}, ${FRAME}, ${STYLE}`);
  assert.equal(skyPrompt(), `${SKY_SCENE}, ${STYLE}`);
  assert.throws(() => scenePrompt(0), /^Error: curated-scene$/);
  assert.throws(() => scenePrompt(61), /^Error: curated-scene$/);
});

test('the set: sixty paintings and the sky, sizes, seeds, the model', async () => {
  const api = fakeApi();
  const dir = folder();
  try {
    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
    const posts = api.seen.filter((s) => s.method === 'POST');
    assert.equal(posts.length, 61);
    assert.ok(posts.every((p) => p.url === `${BFL_API_URL}/${MODEL}`));
    assert.deepEqual(posts[0]?.body, {
      prompt: scenePrompt(1),
      width: 1600,
      height: 1200,
      seed: seedOf(1, 1),
      output_format: 'png',
    });
    assert.deepEqual(posts[60]?.body, {
      prompt: skyPrompt(),
      width: 1200,
      height: 336,
      seed: seedOf('sky', 1),
      output_format: 'png',
    });
    const seeds = posts.map((p) => p.body?.seed);
    assert.equal(new Set(seeds).size, 61);
    assert.deepEqual(ITEMS.length, 61);
    const s = state(dir);
    assert.equal(s.credits, 61 * 1.5);
    assert.deepEqual(s.items['07'], { attempt: 1, seed: seedOf(7, 1), credits: 1.5 });
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('each finished painting is a tagged sRGB JPEG of its size', async () => {
  const api = fakeApi();
  const dir = folder();
  try {
    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
    for (const item of ITEMS) {
      const jpeg = readFileSync(join(dir, fileOf(item, 1)));
      assert.deepEqual(jpegSize(jpeg), item === 'sky' ? SKY : PAINTING);
      assert.equal(hasSrgb(jpeg), true);
      assert.equal(aiTagged(jpeg), true);
    }
    // Nothing of the work is left behind.
    assert.equal(existsSync(join(dir, 'work.png')), false);
    assert.equal(existsSync(join(dir, 'work.jpg')), false);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('a stopped run goes on from where it stopped', async () => {
  const dir = folder();
  try {
    const first = fakeApi({ failAt: { post: 5, status: 500 } });
    await assert.rejects(paintSet(first.send, KEY, first.clock, fakeConvert().convert, dir), /^Error: bfl-http-500$/);
    assert.deepEqual(Object.keys(state(dir).items), ['01', '02', '03', '04']);
    const again = fakeApi();
    await paintSet(again.send, KEY, again.clock, fakeConvert().convert, dir);
    const posts = again.seen.filter((s) => s.method === 'POST');
    assert.equal(posts.length, 57);
    assert.equal(posts[0]?.body?.prompt, scenePrompt(5));
    // The failed request's reserve stays counted.
    assert.equal(state(dir).credits, 61 * 1.5 + RESERVE_CREDITS);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('a repaint takes the next seed and keeps the earlier image', async () => {
  const dir = folder();
  try {
    const api = fakeApi();
    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
    const more = fakeApi({ costs: [1.6] });
    await repaint(more.send, KEY, more.clock, fakeConvert().convert, dir, [7, 'sky']);
    const posts = more.seen.filter((s) => s.method === 'POST');
    assert.deepEqual(
      posts.map((p) => [p.body?.prompt, p.body?.seed]),
      [
        [scenePrompt(7), seedOf(7, 2)],
        [skyPrompt(), seedOf('sky', 2)],
      ],
    );
    const s = state(dir);
    assert.deepEqual(s.items['07'], { attempt: 2, seed: seedOf(7, 2), credits: 1.6 });
    assert.equal(s.items.sky?.attempt, 2);
    assert.equal(s.credits, 61 * 1.5 + 2 * 1.6);
    assert.ok(existsSync(join(dir, '07-1.jpg')) && existsSync(join(dir, '07-2.jpg')));
    assert.deepEqual([seedOf(7, 1), seedOf(7, 2), seedOf('sky', 1), seedOf('sky', 2)], [20701, 20702, 29901, 29902]);
    assert.notEqual(seedOf(7, 2), seedOf(8, 1));
    assert.match(readFileSync(join(dir, 'set.md'), 'utf8'), /Painted again: 07, sky\./);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('a repaint of an item not painted yet is refused', async () => {
  const dir = folder();
  try {
    const api = fakeApi();
    await assert.rejects(repaint(api.send, KEY, api.clock, fakeConvert().convert, dir, [3]), /^Error: curated-usage$/);
    assert.equal(api.seen.length, 0);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('the cap: no request that could pass USD 3', async () => {
  const dir = folder();
  try {
    writeFileSync(join(dir, 'set.json'), JSON.stringify({ credits: CAP_CREDITS - RESERVE_CREDITS + 0.5, items: {} }));
    const api = fakeApi();
    await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-cap$/);
    assert.equal(api.seen.length, 0);
    writeFileSync(join(dir, 'set.json'), JSON.stringify({ credits: CAP_CREDITS - RESERVE_CREDITS, items: {} }));
    await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-cap$/);
    assert.equal(api.seen.filter((s) => s.method === 'POST').length, 1);
    assert.equal(CAP_CREDITS, 300);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('a reply naming no cost, or too much, stops', async () => {
  for (const [cost, counted] of [
    [undefined, RESERVE_CREDITS],
    ['1.5', RESERVE_CREDITS],
    [RESERVE_CREDITS + 1, RESERVE_CREDITS + 1],
  ] as const) {
    const dir = folder();
    try {
      const api = fakeApi({ costs: [cost] });
      await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-cost$/);
      assert.equal(api.seen.filter((s) => s.method === 'POST').length, 1);
      assert.equal(state(dir).credits, counted);
      assert.deepEqual(state(dir).items, {});
    } finally {
      rmSync(dir, { recursive: true });
    }
  }
});

test('a painting of the wrong size stops', async () => {
  const dir = folder();
  try {
    const api = fakeApi({ size: { width: 1600, height: 1184 } });
    await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-size$/);
    assert.deepEqual(state(dir).items, {});
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('a converter that loses the profile stops', async () => {
  const dir = folder();
  try {
    const api = fakeApi();
    const convert = fakeConvert({ icc: 'none' });
    await assert.rejects(paintSet(api.send, KEY, api.clock, convert.convert, dir), /^Error: curated-srgb$/);
    assert.deepEqual(state(dir).items, {});
    assert.equal(readdirSync(dir).filter((f) => f.endsWith('.jpg')).length, 0);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('a finished JPEG is checked for size, sRGB and the tag', () => {
  assert.throws(() => checkJpeg(fakeJpeg(1600, 1200), PAINTING), /^Error: curated-tag$/);
  assert.throws(() => checkJpeg(fakeJpeg(1600, 1199), PAINTING), /^Error: curated-size$/);
  assert.throws(() => checkJpeg(fakeJpeg(1600, 1200, { icc: 'p3' }), PAINTING), /^Error: curated-srgb$/);
});

test('the contact sheet shows each last attempt with its crops', async () => {
  const dir = folder();
  try {
    const api = fakeApi();
    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
    const more = fakeApi();
    await repaint(more.send, KEY, more.clock, fakeConvert().convert, dir, [12]);
    const sheet = readFileSync(join(dir, 'sheet.html'), 'utf8');
    assert.equal(sheet.match(/<figure>/g)?.length, 61);
    assert.ok(sheet.includes('<img src="12-2.jpg"'));
    assert.equal(sheet.includes('12-1.jpg'), false);
    assert.equal(sheet.match(/class="crop row"/g)?.length, 60);
    assert.equal(sheet.match(/class="crop header"/g)?.length, 60);
    assert.equal(sheet.match(/class="crop pill"/g)?.length, 1);
    assert.ok(sheet.includes('.row{width:330px;height:64px}'));
    assert.ok(sheet.includes('.header{width:390px;height:287px'));
    assert.equal(sheet.includes('http'), false);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('ship: the last attempts, renamed, with their fingerprints', async () => {
  const dir = folder();
  const target = folder();
  try {
    const api = fakeApi();
    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
    await repaint(api.send, KEY, api.clock, fakeConvert().convert, dir, [2]);
    ship(dir, target);
    const files = readdirSync(target).sort();
    assert.equal(files.length, 62);
    assert.deepEqual(files.slice(0, 2), ['01.jpg', '02.jpg']);
    assert.deepEqual(files.slice(-3), ['60.jpg', 'fingerprints.txt', 'sky.jpg']);
    assert.ok(readFileSync(join(target, '02.jpg')).equals(readFileSync(join(dir, '02-2.jpg'))));
    assert.equal(readFileSync(join(dir, '02-1.jpg')).equals(readFileSync(join(dir, '02-2.jpg'))), false);
    const prints = readFileSync(join(target, 'fingerprints.txt'), 'utf8').trimEnd().split('\n');
    assert.equal(prints.length, 61);
    for (const line of prints) {
      const m = /^([0-9a-f]{64}) {2}([A-Za-z0-9._-]+)$/.exec(line);
      assert.ok(m, line);
      const digest = createHash('sha256').update(readFileSync(join(target, m[2] ?? ''))).digest('hex');
      assert.equal(m[1], digest);
    }
    // Again over its own result: the same.
    ship(dir, target);
    assert.equal(readdirSync(target).length, 62);
  } finally {
    rmSync(dir, { recursive: true });
    rmSync(target, { recursive: true });
  }
});

test('ship refuses a set not finished, or a folder holding more', async () => {
  const dir = folder();
  const target = folder();
  try {
    const first = fakeApi({ failAt: { post: 61, status: 500 } });
    await assert.rejects(paintSet(first.send, KEY, first.clock, fakeConvert().convert, dir), /^Error: bfl-http-500$/);
    assert.throws(() => ship(dir, target), /^Error: curated-ship-missing$/);
    const rest = fakeApi();
    await paintSet(rest.send, KEY, rest.clock, fakeConvert().convert, dir);
    mkdirSync(join(target, 'more'));
    assert.throws(() => ship(dir, target), /^Error: curated-ship-folder$/);
    rmSync(join(target, 'more'), { recursive: true });
    writeFileSync(join(dir, fileOf(5, 1)), fakeJpeg(1600, 1200));
    assert.throws(() => ship(dir, target), /^Error: curated-tag$/);
  } finally {
    rmSync(dir, { recursive: true });
    rmSync(target, { recursive: true });
  }
});

test('the key goes to BFL only, and is written nowhere', async () => {
  const api = fakeApi();
  const dir = folder();
  try {
    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
    for (const s of api.seen) {
      const keyed = s.headers['x-key'] === KEY;
      assert.equal(keyed, !s.url.startsWith('https://delivery-eu1.bfl.ai/'), s.url);
    }
    for (const f of readdirSync(dir)) {
      assert.equal(readFileSync(join(dir, f)).includes(KEY), false, f);
    }
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('the arguments: four modes; items 1 to 60, or sky', () => {
  const env = { BFL_API_KEY: KEY };
  assert.deepEqual(parseArgs(env, ['paint', 'f']), { mode: 'paint', folder: 'f', key: KEY });
  assert.deepEqual(parseArgs(env, ['repaint', 'f', '7', 'sky', '60']), {
    mode: 'repaint',
    folder: 'f',
    key: KEY,
    items: [7, 'sky', 60],
  });
  assert.deepEqual(parseArgs({}, ['proof', 'f', 'a.png']), { mode: 'proof', folder: 'f', path: 'a.png' });
  assert.deepEqual(parseArgs({}, ['ship', 'f', 't']), { mode: 'ship', folder: 'f', path: 't' });
  for (const argv of [
    ['paint', 'f', 'x'],
    ['repaint', 'f'],
    ['repaint', 'f', '0'],
    ['repaint', 'f', '61'],
    ['repaint', 'f', '7a'],
    ['repaint', 'f', '7', '7'],
    ['ship', 'f'],
    ['other', 'f'],
    ['paint'],
  ]) {
    assert.throws(() => parseArgs(env, argv), /^Error: curated-usage$/, argv.join(' '));
  }
  assert.throws(() => parseArgs({}, ['paint', 'f']), /^Error: curated-usage$/);
  assert.throws(() => parseArgs({ BFL_API_KEY: '' }, ['repaint', 'f', '1']), /^Error: curated-usage$/);
});

test('sips makes quality 82 with the sRGB profile', () => {
  assert.deepEqual(sipsArgs('in.png', 'out.jpg'), [
    '-s',
    'format',
    'jpeg',
    '-s',
    'formatOptions',
    '82',
    '-E',
    '/System/Library/ColorSync/Profiles/sRGB Profile.icc',
    'in.png',
    '--out',
    'out.jpg',
  ]);
});

test('sipsConvert: sips leaves no profile, so ours is embedded', async () => {
  const dir = folder();
  try {
    const profile = join(dir, 'srgb.icc');
    writeFileSync(profile, fakeProfile());
    const png = join(dir, 'in.png');
    const jpg = join(dir, 'out.jpg');
    writeFileSync(png, fakePng(1600, 1200));
    const seen: string[][] = [];
    const run = async (args: string[]) => {
      seen.push(args);
      writeFileSync(jpg, fakeJpeg(1600, 1200, { icc: 'none' }));
    };
    await sipsConvert(run, png, jpg, profile);
    assert.deepEqual(seen, [sipsArgs(png, jpg)]);
    const out = readFileSync(jpg);
    assert.equal(hasSrgb(out), true);
    checkJpeg(withAiTag(out), PAINTING);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('sipsConvert: a missing or false profile stops early', async () => {
  const dir = folder();
  try {
    const png = join(dir, 'in.png');
    const jpg = join(dir, 'out.jpg');
    const bare = fakeJpeg(8, 8, { icc: 'none' });
    let ran = 0;
    const run = async () => {
      ran += 1;
      writeFileSync(jpg, bare);
    };
    await assert.rejects(sipsConvert(run, png, jpg, join(dir, 'none.icc')), /^Error: curated-profile$/);
    assert.equal(ran, 0, 'a missing profile stops before sips runs');
    const wrong = join(dir, 'wrong.icc');
    writeFileSync(wrong, 'not a profile');
    await assert.rejects(sipsConvert(run, png, jpg, wrong), /^Error: curated-profile$/);
    assert.equal(ran, 1);
    const failing = async () => {
      throw new Error('curated-sips');
    };
    await assert.rejects(sipsConvert(failing, png, jpg, wrong), /^Error: curated-sips$/);
  } finally {
    rmSync(dir, { recursive: true });
  }
});

test('proof: a PNG through the same steps, with no request', async () => {
  const dir = folder();
  try {
    const convert = fakeConvert();
    await proof(convert.convert, dir, fakePng(1024, 1024));
    assert.equal(convert.calls, 1);
    const jpeg = readFileSync(join(dir, 'proof.jpg'));
    assert.equal(aiTagged(jpeg), true);
    assert.match(
      readFileSync(join(dir, 'proof.md'), 'utf8'),
      new RegExp(`^Proof: 1024 x 1024, sRGB, tagged, ${jpeg.length} bytes, quality 82\\.\\n$`),
    );
    await assert.rejects(proof(convert.convert, dir, Buffer.from('no png')), /^Error: curated-not-png$/);
  } finally {
    rmSync(dir, { recursive: true });
  }
});
