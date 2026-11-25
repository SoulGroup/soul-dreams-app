// The curated set of night paintings (D147), painted on the owner's Mac
// with Black Forest Labs' flux-2-klein-4b on the EU endpoint (D145) in the
// one style (D146): sixty invented scenes at 1280 x 960 and New Dream's
// night sky at 1200 x 336, each made a JPEG of quality 75 with an sRGB
// profile by macOS's own sips, then given the invisible AI tag by our own
// code (D123), and checked. Everything is kept in the folder given,
// outside the repository: the images, `set.json` (each one's attempt, seed
// and credits, and the credits spent), `set.md` and the contact sheet,
// `sheet.html`. Every request is counted against a cap of USD 3, repaints
// included, from the credits BFL's own replies name. The key comes from
// the environment; nothing sent or received is written anywhere but the
// images, and an error is a code.
//   BFL_API_KEY=... node trial/curated.ts paint <folder>
//   BFL_API_KEY=... node trial/curated.ts repaint <folder> <n or sky>...
//   node trial/curated.ts proof <folder> <a PNG>
//   node trial/curated.ts ship <folder> <the app's assets/paintings>
import { execFile } from 'node:child_process';
import { createHash } from 'node:crypto';
import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { paintOnce, type Clock, type Send } from './bfl.ts';
import { aiTagged, hasSrgb, jpegSize, pngSize, withAiTag, withProfile, type Size } from '../src/jpeg.ts';
import { SCENES, scenePrompt, skyPrompt } from './scenes.ts';

export const MODEL = 'flux-2-klein-4b';
// 1280 x 960 and quality 75 (D148): the first measure, 1600 x 1200 at 82,
// would have made the set about 81 MB in the app.
export const PAINTING: Size = { width: 1280, height: 960 };
// About 1200 x 340 (D147 item 3), at a multiple of 16 [ASSUMED: BFL's
// pages give no rule; a size it does not paint stops at the size check].
export const SKY: Size = { width: 1200, height: 336 };
export const QUALITY = 75;
// USD 3 (D147 item 4); one credit is USD 0.01 [READ, docs.bfl.ai].
export const CAP_CREDITS = 300;
// What one request is counted as until BFL's reply names its cost, and
// the most one may cost: 1280 x 960 is 1.4 to 1.5 credits [READ: 1.4 for
// the first megapixel, 0.1 for each more]. A reply naming more stops.
export const RESERVE_CREDITS = 3;
export const SRGB_PROFILE = '/System/Library/ColorSync/Profiles/sRGB Profile.icc';

/** One item of the set: a painting, 1 to 60, or the sky. */
export type Item = number | 'sky';

interface Painted {
  readonly attempt: number;
  readonly seed: number;
  readonly credits: number;
}

export interface SetState {
  /** Every credit counted so far, failed requests' reserves included. */
  credits: number;
  items: Record<string, Painted>;
}

/** PNG in, JPEG out: macOS's sips on the owner's Mac, a fake in the tests. */
export type Convert = (png: string, jpg: string) => Promise<void>;

export const ITEMS: readonly Item[] = [...SCENES.map((_, i) => i + 1), 'sky'];

function itemName(item: Item): string {
  return item === 'sky' ? 'sky' : String(item).padStart(2, '0');
}

/** A seed of its own for every item and attempt, never one used before. */
export function seedOf(item: Item, attempt: number): number {
  return (item === 'sky' ? 29900 : 20000 + item * 100) + attempt;
}

function sizeOf(item: Item): Size {
  return item === 'sky' ? SKY : PAINTING;
}

function promptOf(item: Item): string {
  return item === 'sky' ? skyPrompt() : scenePrompt(item);
}

export function fileOf(item: Item, attempt: number): string {
  return `${itemName(item)}-${attempt}.jpg`;
}

/** Credits to a millionth, so sums of BFL's figures stay as written. */
function counted(credits: number): number {
  return Math.round(credits * 1e6) / 1e6;
}

function readState(folder: string): SetState {
  const path = join(folder, 'set.json');
  if (!existsSync(path)) {
    return { credits: 0, items: {} };
  }
  const state = JSON.parse(readFileSync(path, 'utf8')) as SetState;
  if (typeof state.credits !== 'number' || typeof state.items !== 'object' || state.items === null) {
    throw new Error('curated-state');
  }
  return state;
}

function writeState(folder: string, state: SetState): void {
  writeFileSync(join(folder, 'set.json'), `${JSON.stringify(state, null, 2)}\n`);
}

/** Whether a finished JPEG is what the set ships: its size, sRGB and the AI tag. */
export function checkJpeg(jpeg: Buffer, size: Size): void {
  const got = jpegSize(jpeg);
  if (got.width !== size.width || got.height !== size.height) {
    throw new Error('curated-size');
  }
  if (!hasSrgb(jpeg)) {
    throw new Error('curated-srgb');
  }
  if (!aiTagged(jpeg)) {
    throw new Error('curated-tag');
  }
}

/** A PNG made a JPEG, tagged and checked, at [jpg]. */
async function finish(convert: Convert, folder: string, png: Buffer, jpg: string, size: Size): Promise<void> {
  const work = join(folder, 'work.png');
  const raw = join(folder, 'work.jpg');
  writeFileSync(work, png);
  try {
    await convert(work, raw);
    const tagged = withAiTag(readFileSync(raw));
    checkJpeg(tagged, size);
    writeFileSync(jpg, tagged);
  } finally {
    rmSync(work, { force: true });
    rmSync(raw, { force: true });
  }
}

async function paintItem(
  send: Send,
  key: string,
  clock: Clock,
  convert: Convert,
  folder: string,
  state: SetState,
  item: Item,
): Promise<void> {
  if (state.credits + RESERVE_CREDITS > CAP_CREDITS) {
    throw new Error('curated-cap');
  }
  const name = itemName(item);
  const attempt = (state.items[name]?.attempt ?? 0) + 1;
  const seed = seedOf(item, attempt);
  const size = sizeOf(item);
  // Counted before the request, so a request that fails after BFL has
  // charged it is still within the cap.
  state.credits = counted(state.credits + RESERVE_CREDITS);
  writeState(folder, state);
  const made = await paintOnce(send, key, clock, MODEL, { prompt: promptOf(item), ...size, seed });
  if (!Number.isFinite(made.credits) || made.credits < 0) {
    throw new Error('curated-cost');
  }
  state.credits = counted(state.credits + made.credits - RESERVE_CREDITS);
  writeState(folder, state);
  if (made.credits > RESERVE_CREDITS) {
    throw new Error('curated-cost');
  }
  if (pngSize(made.png) === null) {
    throw new Error('curated-not-png');
  }
  // The JPEG's check stops a painting of another size than asked.
  await finish(convert, folder, made.png, join(folder, fileOf(item, attempt)), size);
  state.items[name] = { attempt, seed, credits: made.credits };
  writeState(folder, state);
}

/** Every item the folder does not hold yet, in order; a stopped run goes on from where it stopped. */
export async function paintSet(send: Send, key: string, clock: Clock, convert: Convert, folder: string): Promise<void> {
  mkdirSync(folder, { recursive: true });
  const state = readState(folder);
  try {
    for (const item of ITEMS) {
      if (state.items[itemName(item)] === undefined) {
        await paintItem(send, key, clock, convert, folder, state, item);
      }
    }
  } finally {
    writeReport(folder, state);
  }
}

/** The items named, each painted again with its next seed. */
export async function repaint(
  send: Send,
  key: string,
  clock: Clock,
  convert: Convert,
  folder: string,
  items: readonly Item[],
): Promise<void> {
  const state = readState(folder);
  for (const item of items) {
    if (state.items[itemName(item)] === undefined) {
      throw new Error('curated-usage');
    }
  }
  try {
    for (const item of items) {
      await paintItem(send, key, clock, convert, folder, state, item);
    }
  } finally {
    writeReport(folder, state);
  }
}

/** A PNG through the same steps as a painting, with no request: sips's proof. */
export async function proof(convert: Convert, folder: string, png: Buffer): Promise<void> {
  const size = pngSize(png);
  if (size === null) {
    throw new Error('curated-not-png');
  }
  mkdirSync(folder, { recursive: true });
  const jpg = join(folder, 'proof.jpg');
  await finish(convert, folder, png, jpg, size);
  const bytes = readFileSync(jpg).length;
  writeFileSync(
    join(folder, 'proof.md'),
    `Proof: ${size.width} x ${size.height}, sRGB, tagged, ${bytes} bytes, quality ${QUALITY}.\n`,
  );
}

/**
 * The set, each item's last attempt, copied into the app's paintings
 * folder as `01.jpg` to `60.jpg` and `sky.jpg`, with `fingerprints.txt`
 * as shasum writes it. Refused unless every item is painted and checks,
 * and unless the folder holds nothing else.
 */
export function ship(folder: string, target: string): void {
  const state = readState(folder);
  const names = ITEMS.map((item) => `${itemName(item)}.jpg`);
  const extra = readdirSync(target).filter((f) => !names.includes(f) && f !== 'fingerprints.txt');
  if (extra.length > 0) {
    throw new Error('curated-ship-folder');
  }
  const sources = ITEMS.map((item) => {
    const painted = state.items[itemName(item)];
    if (painted === undefined) {
      throw new Error('curated-ship-missing');
    }
    const from = join(folder, fileOf(item, painted.attempt));
    checkJpeg(readFileSync(from), sizeOf(item));
    return from;
  });
  const lines = sources.map((from, i) => {
    const name = names[i] ?? '';
    copyFileSync(from, join(target, name));
    return `${createHash('sha256').update(readFileSync(join(target, name))).digest('hex')}  ${name}\n`;
  });
  writeFileSync(join(target, 'fingerprints.txt'), lines.join(''));
}

function escape(text: string): string {
  return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

/** `set.md`, what was spent, and `sheet.html`, every item's last attempt with its crops. */
function writeReport(folder: string, state: SetState): void {
  const painted = ITEMS.filter((item) => state.items[itemName(item)] !== undefined);
  const repainted = painted.filter((item) => (state.items[itemName(item)]?.attempt ?? 1) > 1);
  writeFileSync(
    join(folder, 'set.md'),
    [
      '# The curated set',
      '',
      `Painted: ${painted.length} of ${ITEMS.length}. Painted again: ${repainted.map(itemName).join(', ') || 'none'}.`,
      `Credits counted: ${state.credits.toFixed(2)} of ${CAP_CREDITS}, USD ${(state.credits / 100).toFixed(3)}.`,
      '',
    ].join('\n'),
  );
  const cards = painted.map((item) => {
    const p = state.items[itemName(item)] as Painted;
    const src = escape(fileOf(item, p.attempt));
    const crops =
      item === 'sky'
        ? `<div class="crop pill" style="background-image:url('${src}')"></div>`
        : `<div class="crop row" style="background-image:url('${src}')"></div>` +
          `<div class="crop header" style="background-image:url('${src}')"></div>`;
    const label = `${itemName(item)} · attempt ${p.attempt} · ${escape(promptOf(item).split(',')[0] ?? '')}`;
    return `<figure><img src="${src}" alt=""><figcaption>${label}</figcaption>${crops}</figure>`;
  });
  writeFileSync(
    join(folder, 'sheet.html'),
    [
      '<!doctype html><meta charset="utf-8"><title>The curated set</title>',
      '<style>',
      'body{font:14px system-ui;background:#222;color:#eee;margin:16px}',
      'main{display:grid;grid-template-columns:repeat(auto-fill,minmax(400px,1fr));gap:16px}',
      'figure{margin:0}img{width:100%;display:block}',
      '.crop{background-size:cover;background-position:center;margin-top:6px;border-radius:12px}',
      '.row{width:330px;height:64px}.header{width:390px;height:287px;border-radius:0}',
      '.pill{width:330px;height:50px}',
      '</style>',
      `<main>${cards.join('')}</main>`,
      '',
    ].join('\n'),
  );
}

export interface Args {
  readonly mode: 'paint' | 'repaint' | 'proof' | 'ship';
  readonly folder: string;
  readonly key?: string;
  readonly items?: readonly Item[];
  readonly path?: string;
}

function item(word: string): Item {
  if (word === 'sky') {
    return 'sky';
  }
  const n = Number(word);
  if (!/^[0-9]+$/.test(word) || n < 1 || n > SCENES.length) {
    throw new Error('curated-usage');
  }
  return n;
}

export function parseArgs(env: Readonly<Record<string, string | undefined>>, argv: readonly string[]): Args {
  const [mode, folder, ...rest] = argv;
  if (folder === undefined || folder === '') {
    throw new Error('curated-usage');
  }
  const key = env.BFL_API_KEY;
  const keyed = key !== undefined && key !== '';
  if (mode === 'paint' && rest.length === 0 && keyed) {
    return { mode, folder, key };
  }
  if (mode === 'repaint' && rest.length > 0 && keyed) {
    const items = rest.map(item);
    if (new Set(items).size !== items.length) {
      throw new Error('curated-usage');
    }
    return { mode, folder, key, items };
  }
  if ((mode === 'proof' || mode === 'ship') && rest.length === 1 && rest[0] !== '') {
    return { mode, folder, path: rest[0] };
  }
  throw new Error('curated-usage');
}

/** macOS's sips: a JPEG of quality 75, from a PNG that names no profile (sips takes it as sRGB). */
export function sipsArgs(png: string, jpg: string): string[] {
  return ['-s', 'format', 'jpeg', '-s', 'formatOptions', String(QUALITY), '-E', SRGB_PROFILE, png, '--out', jpg];
}

/**
 * sips's JPEG with the OS's own sRGB profile embedded by our code: sips on
 * macOS 26 states sRGB through Exif and writes no ICC profile, which the
 * set's check (and a viewer that reads only ICC) needs. A profile file that
 * is missing or is no ICC profile stops ('curated-profile').
 */
export async function sipsConvert(
  run: (args: string[]) => Promise<void>,
  png: string,
  jpg: string,
  profile: string = SRGB_PROFILE,
): Promise<void> {
  let icc: Buffer;
  try {
    icc = readFileSync(profile);
  } catch {
    throw new Error('curated-profile');
  }
  await run(sipsArgs(png, jpg));
  writeFileSync(jpg, withProfile(readFileSync(jpg), icc));
}

if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const args = parseArgs(process.env, process.argv.slice(2));
  const sips = (sipsOptions: string[]): Promise<void> =>
    new Promise((done, fail) => {
      execFile('/usr/bin/sips', sipsOptions, (error) => (error ? fail(new Error('curated-sips')) : done()));
    });
  const convert: Convert = (png, jpg) => sipsConvert(sips, png, jpg);
  const send: Send = async (url, init) => {
    const r = await fetch(url, { ...init, signal: AbortSignal.timeout(60000) });
    return { status: r.status, json: () => r.json(), bytes: async () => Buffer.from(await r.arrayBuffer()) };
  };
  const clock: Clock = { now: () => Date.now(), sleep: (ms) => new Promise((r) => setTimeout(r, ms)) };
  if (args.mode === 'paint') {
    await paintSet(send, args.key ?? '', clock, convert, args.folder);
  } else if (args.mode === 'repaint') {
    await repaint(send, args.key ?? '', clock, convert, args.folder, args.items ?? []);
  } else if (args.mode === 'proof') {
    await proof(convert, args.folder, readFileSync(args.path ?? ''));
  } else {
    ship(args.folder, args.path ?? '');
  }
}
