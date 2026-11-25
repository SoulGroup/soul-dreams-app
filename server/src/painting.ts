// The night's personal painting (D143, D145, D146, D123; D162): the scenery
// step names a neutral scene through the one model interface (models.ts),
// and Black Forest Labs' flux-2-klein-4b on its EU endpoint paints it in the
// one style. Until the readings' model writes the scene inside our chain,
// the scenery step's stand-in names one fixed placeholder scene and reads
// nothing of the night: the request holds nothing at all (D143). The image
// comes back as a JPEG, gets the invisible AI tag written by our own code
// (D123) and goes to the phone; nothing is kept here, and only numbers are
// logged (R3). The key is the owner's, from Parameter Store, sent to BFL's
// own hosts only, over https.
import { BFL_API_URL, BFL_HOST_SUFFIX } from './hosts.ts';
import { aiTagged, jpegSize, withAiTag } from './jpeg.ts';
import type { Prompt } from './models.ts';
import type { Ask } from './reading.ts';

/** The model (D145). */
export const PAINTING_MODEL = 'flux-2-klein-4b';

/** The one style (D146), first written for the image trial. */
// not-dreamer-facing: the painting style sent to the image model (D146).
export const STYLE = 'Van Gogh style oil painting, thick impasto brushstrokes, no people';

/** The framing every painting shares: the subject in the middle band (D147 item 2). */
// not-dreamer-facing: the framing sent to the image model (D147).
export const FRAME = 'wide view, the subject across the middle band, no text';

/** The curated set's size (D148), so a night's picture is cut the same way. */
export const PAINTING_SIZE = Object.freeze({ width: 1280, height: 960 });

/** The most a painting may weigh, on its way to the phone. */
export const PAINTING_BYTES_LIMIT = 4194304;

/** The longest scene the scenery step may name. */
export const SCENE_LIMIT = 500;

/** A request's body may be this long at most: it holds nothing (`{}`). */
export const PAINTING_BODY_LIMIT = 64;

/** How long BFL may take, from the request to its last poll, and between polls. */
export const GIVE_UP_MS = 30000;
export const POLL_MS = 500;

/** Each request to BFL waits this long at most. */
export const REQUEST_MS = 10000;

/** One credit is USD 0.01 [READ, docs.bfl.ai, 2026-11-23]: in millionths of a dollar. */
export const MILLIONTHS_PER_CREDIT = 10000;

/**
 * No painting: BFL's HTTP status; 0 no answer; -1 an answer not as its
 * pages give it; -2 moderated; -3 failed; -4 no image in time; -5 an image
 * not as asked (not a JPEG of the size, too big, or holding a packet of
 * its own where the AI tag goes); -6 a scene that is none.
 */
export class PaintingFailure extends Error {
  readonly code: number;

  constructor(code: number) {
    super('painting');
    this.code = code;
  }
}

export interface BflReply {
  readonly status: number;
  json(): Promise<unknown>;
  bytes(): Promise<Buffer>;
}

export type BflSend = (
  url: string,
  init: { method: 'POST' | 'GET'; headers: Record<string, string>; body?: string },
) => Promise<BflReply>;

export interface Clock {
  now(): number;
  sleep(ms: number): Promise<void>;
}

/** The scenery step's prompt: nothing of the night (D143). */
export const SCENERY_PROMPT: Prompt = Object.freeze({ fixed: Object.freeze([]), words: '' });

/** Why a painting's request is refused (400 or 413), or null: it must hold nothing. */
export function paintingRefused(body: string): 400 | 413 | null {
  if (body.length > PAINTING_BODY_LIMIT) return 413;
  let parsed: unknown;
  try {
    parsed = JSON.parse(body);
  } catch {
    return 400;
  }
  const empty = typeof parsed === 'object' && parsed !== null && !Array.isArray(parsed) && Object.keys(parsed).length === 0;
  return empty ? null : 400;
}

/** The scenery step's text as a scene: one line, not blank, not too long; else null. */
export function sceneOf(text: string): string | null {
  const scene = text.trim();
  return scene === '' || scene.length > SCENE_LIMIT || /[\r\n]/.test(scene) ? null : scene;
}

/** What BFL is asked to paint: the scene, the framing and the style, in that order. */
export function promptOf(scene: string): string {
  return `${scene}, ${FRAME}, ${STYLE}`;
}

const WAITING = ['Pending', 'Reasoning', 'Generating'];
const MODERATED = ['Request Moderated', 'Content Moderated'];

async function call(send: BflSend, url: string, init: Parameters<BflSend>[1]): Promise<BflReply> {
  try {
    return await send(url, init);
  } catch {
    throw new PaintingFailure(0);
  }
}

async function jsonOf(reply: BflReply): Promise<Record<string, unknown>> {
  let parsed: unknown;
  try {
    parsed = await reply.json();
  } catch {
    throw new PaintingFailure(-1);
  }
  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) throw new PaintingFailure(-1);
  return parsed as Record<string, unknown>;
}

// An address BFL names: only its own hosts, over https, ever get a request.
function bflUrl(value: unknown): string {
  if (typeof value !== 'string') throw new PaintingFailure(-1);
  let url: URL;
  try {
    url = new URL(value);
  } catch {
    throw new PaintingFailure(-1);
  }
  if (url.protocol !== 'https:' || !url.hostname.endsWith(BFL_HOST_SUFFIX)) throw new PaintingFailure(-1);
  return url.href;
}

/** The image as the phone gets it: a JPEG of the size asked, under the limit, with the AI tag (D123). */
export function finished(jpeg: Buffer): Buffer {
  let tagged: Buffer;
  try {
    const size = jpegSize(jpeg);
    if (size.width !== PAINTING_SIZE.width || size.height !== PAINTING_SIZE.height) throw new PaintingFailure(-5);
    tagged = withAiTag(jpeg);
  } catch {
    throw new PaintingFailure(-5);
  }
  if (!aiTagged(tagged) || tagged.length > PAINTING_BYTES_LIMIT) throw new PaintingFailure(-5);
  return tagged;
}

/** One painting of [scene]: the request, the polling, the image and the credits BFL's reply names. */
export async function paint(
  send: BflSend,
  key: string,
  clock: Clock,
  scene: string,
): Promise<{ jpeg: Buffer; credits: number }> {
  const until = clock.now() + GIVE_UP_MS;
  const made = await call(send, `${BFL_API_URL}/${PAINTING_MODEL}`, {
    method: 'POST',
    headers: { 'x-key': key, 'Content-Type': 'application/json' },
    body: JSON.stringify({ prompt: promptOf(scene), ...PAINTING_SIZE, output_format: 'jpeg' }),
  });
  if (made.status !== 200) throw new PaintingFailure(made.status);
  const task = await jsonOf(made);
  const polling = bflUrl(task['polling_url']);
  const credits = task['cost'];
  if (typeof credits !== 'number' || !Number.isFinite(credits) || credits < 0) throw new PaintingFailure(-1);
  for (;;) {
    const polled = await call(send, polling, { method: 'GET', headers: { 'x-key': key } });
    if (polled.status !== 200) throw new PaintingFailure(polled.status);
    const state = await jsonOf(polled);
    const status = state['status'];
    if (status === 'Ready') {
      const result = state['result'];
      const sample = typeof result === 'object' && result !== null ? (result as Record<string, unknown>)['sample'] : undefined;
      const got = await call(send, bflUrl(sample), { method: 'GET', headers: {} });
      if (got.status !== 200) throw new PaintingFailure(got.status);
      let bytes: Buffer;
      try {
        bytes = await got.bytes();
      } catch {
        throw new PaintingFailure(0);
      }
      return { jpeg: finished(bytes), credits };
    }
    if (typeof status === 'string' && MODERATED.includes(status)) throw new PaintingFailure(-2);
    if (typeof status !== 'string' || !WAITING.includes(status)) throw new PaintingFailure(-3);
    if (clock.now() >= until) throw new PaintingFailure(-4);
    await clock.sleep(POLL_MS);
  }
}

/** A night's painting, as the phone gets it, and what it cost in millionths of a dollar. */
export interface Painted {
  readonly jpeg: Buffer;
  readonly cost: number;
}

/** The scenery step through [ask], then [paintScene]; a scene that is none fails (-6). */
export async function paintNight(
  ask: Ask,
  paintScene: (scene: string) => Promise<{ jpeg: Buffer; credits: number }>,
): Promise<Painted> {
  const { text } = await ask('scenery', SCENERY_PROMPT);
  const scene = sceneOf(text);
  if (scene === null) throw new PaintingFailure(-6);
  const made = await paintScene(scene);
  return { jpeg: made.jpeg, cost: Math.round(made.credits * MILLIONTHS_PER_CREDIT) };
}

/**
 * Node's fetch, each request waiting [REQUEST_MS] at most. A redirect is
 * refused, never followed: BFL's key goes only to the address checked.
 */
export const fetchSend: BflSend = async (url, init) => {
  const r = await fetch(url, { ...init, redirect: 'error', signal: AbortSignal.timeout(REQUEST_MS) });
  return { status: r.status, json: () => r.json(), bytes: async () => Buffer.from(await r.arrayBuffer()) };
};

export const realClock: Clock = {
  now: () => Date.now(),
  sleep: (ms) => new Promise((done) => setTimeout(done, ms)),
};
