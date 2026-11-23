// Small images and a fake of BFL's API for the curated set's tests (D147):
// no key, no network, no sips. The key and every address are invented.
import { readFileSync, writeFileSync } from 'node:fs';
import type { Clock, Reply, Send } from '../trial/bfl.ts';
import type { Convert } from '../trial/curated.ts';
import { pngSize } from '../trial/jpeg.ts';

export const KEY = 'invented-key-0123456789';
const POLLING = 'https://api.eu.bfl.ai/v1/get_result?id=';
const IMAGE = 'https://delivery-eu1.bfl.ai/';

export function segment(marker: number, data: Buffer): Buffer {
  const head = Buffer.from([0xff, marker, 0, 0]);
  head.writeUInt16BE(data.length + 2, 2);
  return Buffer.concat([head, data]);
}

/** A PNG's signature and header, enough for its size. */
export function fakePng(width: number, height: number): Buffer {
  const png = Buffer.alloc(33);
  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]).copy(png, 0);
  png.writeUInt32BE(13, 8);
  png.write('IHDR', 12, 'latin1');
  png.writeUInt32BE(width, 16);
  png.writeUInt32BE(height, 20);
  return png;
}

export interface JpegOptions {
  jfif?: boolean;
  icc?: 'ascii' | 'utf16' | 'p3' | 'none';
  frame?: boolean;
  progressive?: boolean;
  extra?: readonly Buffer[];
  /** A byte in the scan, so two images of one size differ. */
  mark?: number;
}

/** A JPEG's start, its segments up to the scan, a few bytes and its end. */
export function fakeJpeg(width: number, height: number, options: JpegOptions = {}): Buffer {
  const parts: Buffer[] = [Buffer.from([0xff, 0xd8])];
  if (options.jfif !== false) {
    parts.push(segment(0xe0, Buffer.from('JFIF\0\x01\x01\0\0\x01\0\x01\0\0', 'latin1')));
  }
  const icc = options.icc ?? 'ascii';
  if (icc !== 'none') {
    const name =
      icc === 'utf16'
        ? Buffer.from([0, 0x73, 0, 0x52, 0, 0x47, 0, 0x42])
        : Buffer.from(icc === 'p3' ? 'Display P3' : 'sRGB IEC61966-2.1', 'latin1');
    parts.push(segment(0xe2, Buffer.concat([Buffer.from('ICC_PROFILE\0\x01\x01', 'latin1'), name])));
  }
  parts.push(...(options.extra ?? []));
  if (options.frame !== false) {
    const sof = Buffer.from([8, 0, 0, 0, 0, 3, 1, 0x22, 0, 2, 0x11, 1, 3, 0x11, 1]);
    sof.writeUInt16BE(height, 1);
    sof.writeUInt16BE(width, 3);
    parts.push(segment(options.progressive ? 0xc2 : 0xc0, sof));
  }
  parts.push(segment(0xda, Buffer.from([3, 1, 0, 2, 0x11, 3, 0x11, 0, 0x3f, 0])));
  parts.push(Buffer.from([1, 2, (options.mark ?? 3) & 0x7f, 0xff, 0xd9]));
  return Buffer.concat(parts);
}

/** A stand-in ICC profile: the header's 'acsp' mark and a name, nothing more. */
export function fakeProfile(name = 'sRGB IEC61966-2.1'): Buffer {
  return Buffer.concat([Buffer.alloc(36), Buffer.from('acsp', 'latin1'), Buffer.alloc(24), Buffer.from(name, 'latin1')]);
}

/** sips's stand-in: the PNG's size, as a JPEG with an sRGB profile, or as [options] says. */
export function fakeConvert(options: JpegOptions = {}): { convert: Convert; calls: number } {
  const state = {
    calls: 0,
    convert: async (png: string, jpg: string) => {
      state.calls += 1;
      const size = pngSize(readFileSync(png));
      if (size === null) {
        throw new Error('fake-convert');
      }
      writeFileSync(jpg, fakeJpeg(size.width, size.height, { mark: state.calls, ...options }));
    },
  };
  return state;
}

export interface Seen {
  method: string;
  url: string;
  headers: Record<string, string>;
  body: Record<string, unknown> | undefined;
}

export interface ApiOptions {
  /** The cost each POST names, in turn; the last repeats. */
  costs?: readonly unknown[];
  /** A size painted instead of the one asked for. */
  size?: { width: number; height: number };
  /** The POST that answers with a status of its own (1-based), and the status. */
  failAt?: { post: number; status: number };
}

/** BFL's API, faked: every request 500 ms; a poll answers Ready with the image. */
export function fakeApi(options: ApiOptions = {}): { send: Send; seen: Seen[]; clock: Clock } {
  let t = 0;
  let posts = 0;
  const seen: Seen[] = [];
  const asked = new Map<string, { width: number; height: number }>();
  const reply = (status: number, json: unknown, bytes?: Buffer): Reply => ({
    status,
    json: async () => json,
    bytes: async () => bytes ?? Buffer.alloc(0),
  });
  const send: Send = async (url, init) => {
    t += 500;
    const body = init.body === undefined ? undefined : (JSON.parse(init.body) as Record<string, unknown>);
    seen.push({ method: init.method, url, headers: init.headers, body });
    if (init.method === 'POST') {
      posts += 1;
      if (options.failAt?.post === posts) {
        return reply(options.failAt.status, { detail: KEY });
      }
      const id = String(posts);
      asked.set(id, { width: Number(body?.width), height: Number(body?.height) });
      const costs = options.costs ?? [1.5];
      const cost = costs[Math.min(posts - 1, costs.length - 1)];
      return reply(200, { id, polling_url: POLLING + id, cost });
    }
    if (url.startsWith(POLLING)) {
      const id = url.slice(POLLING.length);
      return reply(200, { status: 'Ready', result: { sample: `${IMAGE}${id}.png` } });
    }
    const id = url.slice(IMAGE.length, -'.png'.length);
    const size = options.size ?? asked.get(id) ?? { width: 0, height: 0 };
    return reply(200, {}, fakePng(size.width, size.height));
  };
  const clock: Clock = {
    now: () => t,
    sleep: async (ms) => {
      t += ms;
    },
  };
  return { send, seen, clock };
}
