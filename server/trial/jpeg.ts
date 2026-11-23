// What the curated set's painter reads and writes inside its images
// (D147), in plain bytes, with no package: a PNG's size; a JPEG's size,
// its colour profile and its AI tag; and the tag itself, written by our
// own code (D123): an XMP packet naming the IPTC digital source type
// "trainedAlgorithmicMedia", in an APP1 segment after the JPEG's start.
import { AI_SOURCE_TYPE, XMP_HEADER, XMP_IPTC_EXT, XMP_RDF } from '../src/hosts.ts';

export interface Size {
  readonly width: number;
  readonly height: number;
}

const PNG_SIGNATURE = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);

/** A PNG's width and height from its header, or null when it is no PNG. */
export function pngSize(png: Buffer): Size | null {
  if (png.length < 24 || !png.subarray(0, 8).equals(PNG_SIGNATURE) || png.toString('latin1', 12, 16) !== 'IHDR') {
    return null;
  }
  return { width: png.readUInt32BE(16), height: png.readUInt32BE(20) };
}

interface Segment {
  readonly marker: number;
  /** Where the marker's 0xFF stands. */
  readonly at: number;
  /** The segment's bytes after its length. */
  readonly data: Buffer;
}

/** The segments from the start to the scan, or 'curated-jpeg' when malformed. */
function segments(jpeg: Buffer): Segment[] {
  if (jpeg.length < 4 || jpeg[0] !== 0xff || jpeg[1] !== 0xd8) {
    throw new Error('curated-jpeg');
  }
  const found: Segment[] = [];
  let at = 2;
  for (;;) {
    if (at + 4 > jpeg.length || jpeg[at] !== 0xff) {
      throw new Error('curated-jpeg');
    }
    const marker = jpeg[at + 1] ?? 0;
    const length = jpeg.readUInt16BE(at + 2);
    if (length < 2 || at + 2 + length > jpeg.length) {
      throw new Error('curated-jpeg');
    }
    found.push({ marker, at, data: jpeg.subarray(at + 4, at + 2 + length) });
    if (marker === 0xda) {
      return found;
    }
    at += 2 + length;
  }
}

// The frame markers that carry the size: SOF0 to SOF15 but DHT, JPG and DAC.
const FRAMES = new Set([0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf]);

/** A JPEG's width and height from its frame header. */
export function jpegSize(jpeg: Buffer): Size {
  const frame = segments(jpeg).find((s) => FRAMES.has(s.marker));
  if (frame === undefined || frame.data.length < 5) {
    throw new Error('curated-jpeg');
  }
  return { width: frame.data.readUInt16BE(3), height: frame.data.readUInt16BE(1) };
}

const ICC = Buffer.from('ICC_PROFILE\0', 'latin1');
const SRGB_ASCII = Buffer.from('sRGB', 'latin1');
const SRGB_UTF16 = Buffer.from([0, 0x73, 0, 0x52, 0, 0x47, 0, 0x42]);

/** Whether the JPEG carries an sRGB colour profile (an APP2 ICC profile naming sRGB). */
export function hasSrgb(jpeg: Buffer): boolean {
  return segments(jpeg).some(
    (s) =>
      s.marker === 0xe2 &&
      s.data.subarray(0, ICC.length).equals(ICC) &&
      (s.data.includes(SRGB_ASCII) || s.data.includes(SRGB_UTF16)),
  );
}

const XMP_ID = Buffer.from(`${XMP_HEADER}\0`, 'latin1');

/** The AI tag's XMP packet: the IPTC digital source type, and nothing else. */
export function aiPacket(): string {
  return [
    '<?xpacket begin="﻿" id="W5M0MpCehiHzreSzNTczkc9d"?>',
    '<x:xmpmeta xmlns:x="adobe:ns:meta/">',
    `<rdf:RDF xmlns:rdf="${XMP_RDF}">`,
    `<rdf:Description rdf:about="" xmlns:Iptc4xmpExt="${XMP_IPTC_EXT}"`,
    ` Iptc4xmpExt:DigitalSourceType="${AI_SOURCE_TYPE}"/>`,
    '</rdf:RDF>',
    '</x:xmpmeta>',
    '<?xpacket end="r"?>',
  ].join('');
}

function xmpSegments(jpeg: Buffer): Segment[] {
  return segments(jpeg).filter((s) => s.marker === 0xe1 && s.data.subarray(0, XMP_ID.length).equals(XMP_ID));
}

/** Whether the JPEG carries the AI tag: an XMP packet naming the source type. */
export function aiTagged(jpeg: Buffer): boolean {
  const named = `Iptc4xmpExt:DigitalSourceType="${AI_SOURCE_TYPE}"`;
  return xmpSegments(jpeg).some((s) => s.data.toString('utf8', XMP_ID.length).includes(named));
}

/**
 * The JPEG with the AI tag written in: an APP1 segment after the start and
 * after a JFIF APP0 if one leads. One that already holds XMP is refused
 * ('curated-xmp'): nothing else's packet is overwritten or doubled.
 */
export function withAiTag(jpeg: Buffer): Buffer {
  const found = segments(jpeg);
  if (xmpSegments(jpeg).length > 0) {
    throw new Error('curated-xmp');
  }
  const first = found[0];
  const after = first !== undefined && first.marker === 0xe0 ? first.at + 4 + first.data.length : 2;
  const payload = Buffer.concat([XMP_ID, Buffer.from(aiPacket(), 'utf8')]);
  const head = Buffer.from([0xff, 0xe1, 0, 0]);
  head.writeUInt16BE(payload.length + 2, 2);
  return Buffer.concat([jpeg.subarray(0, after), head, payload, jpeg.subarray(after)]);
}
