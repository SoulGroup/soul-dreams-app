// The readings (head's message 33; C3-T 2e): what a request may hold, and
// the model behind them. A request holds the night's language, its dreams
// in the dreamer's words and, only while Life Context is on, the sentences
// it keeps (D134): never an id, a date or anything of the phone (R4).
// Nothing here logs or keeps anything (R3).
import type { Instruction } from './instructions.ts';
import { type Call, type Prompt, STAND_IN_READINGS as MODEL_STAND_IN, type Step } from './models.ts';

/** A body longer than this is refused before it is read. */
export const READING_BODY_LIMIT = 262144;

export type Lang = 'en' | 'sv';

export interface ReadingRequest {
  readonly lang: Lang;
  readonly dreams: readonly string[];
  /** Empty while Life Context is off: nothing kept was sent. */
  readonly kept: readonly string[];
}

/** One reading: its tradition, as its place among the lens labels (W13), and its words. */
export interface Reading {
  readonly lens: number;
  readonly text: string;
}

export type ParsedReading = { readonly request: ReadingRequest } | { readonly refused: 400 | 413 };

const KEYS = new Set(['lang', 'dreams', 'kept']);

const strings = (x: unknown): x is string[] => Array.isArray(x) && x.every((s) => typeof s === 'string');

/** One night's request, as sent; or the status that refuses it. */
export function parseReading(body: string): ParsedReading {
  if (body.length > READING_BODY_LIMIT) return { refused: 413 };
  let parsed: unknown;
  try {
    parsed = JSON.parse(body);
  } catch {
    return { refused: 400 };
  }
  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) return { refused: 400 };
  const json = parsed as Record<string, unknown>;
  if (!Object.keys(json).every((k) => KEYS.has(k))) return { refused: 400 };
  const { lang, dreams, kept = [] } = json;
  if (lang !== 'en' && lang !== 'sv') return { refused: 400 };
  if (!strings(dreams) || dreams.length === 0 || dreams.some((d) => d.trim() === '')) return { refused: 400 };
  if (!strings(kept)) return { refused: 400 };
  return { request: { lang, dreams, kept } };
}

/** The readings' prompt: the instructions first, in their order; the night last. */
export function promptFor(instructions: readonly Instruction[], request: ReadingRequest): Prompt {
  return { fixed: instructions.map((i) => i.text), words: JSON.stringify(request) };
}

const READING_KEYS = ['lens', 'text'];

/** The model's text as one to three whole readings, or null. */
export function parseReadings(text: string): Reading[] | null {
  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    return null;
  }
  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) return null;
  const json = parsed as Record<string, unknown>;
  const list = json['readings'];
  if (Object.keys(json).length !== 1 || !Array.isArray(list) || list.length === 0 || list.length > 3) return null;
  const readings: Reading[] = [];
  for (const r of list as unknown[]) {
    if (typeof r !== 'object' || r === null || Object.keys(r).sort().join() !== READING_KEYS.join()) return null;
    const { lens, text: words } = r as Record<string, unknown>;
    if (!Number.isInteger(lens) || (lens as number) < 0 || typeof words !== 'string' || words === '') return null;
    readings.push({ lens: lens as number, text: words });
  }
  return readings;
}

/** A night's readings, and the calls that made them. */
export interface Read {
  readonly readings: readonly Reading[];
  readonly usage: readonly Call[];
}

export type Ask = (step: Step, prompt: Prompt) => Promise<{ text: string; call: Call }>;

/** Reads one night: the readings step, through [ask]; an answer that is not readings fails. */
export async function readNight(instructions: readonly Instruction[], request: ReadingRequest, ask: Ask): Promise<Read> {
  const { text, call } = await ask('readings', promptFor(instructions, request));
  const readings = parseReadings(text);
  if (readings === null) throw new Error('reading-unreadable');
  return { readings, usage: [call] };
}

/** The stand-in's readings (models.ts), as a night's readings. */
export const STAND_IN_READINGS: readonly Reading[] = MODEL_STAND_IN;
