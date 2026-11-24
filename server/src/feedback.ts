// Feedback (D110; C18-P's MP·46 to MP·49; D152): what a dreamer sends from
// Settings, about the app. A request holds one text and nothing else; the
// day is the server's, in UTC. Nothing here logs or keeps anything.

/** At most this many characters, as a person counts them (D152 item 3). */
export const FEEDBACK_LIMIT = 2000;

/** A body longer than this is refused before it is read. */
export const BODY_LIMIT = 65536;

/** The Lambda's one variable: the feedback bucket's name (D152 item 1). */
export const FEEDBACK_BUCKET_VARIABLE = 'FEEDBACK_BUCKET';

const graphemes = new Intl.Segmenter('en', { granularity: 'grapheme' });

/** The characters in [text] as a person counts them: a family emoji is one. */
export function characters(text: string): number {
  let n = 0;
  for (const _ of graphemes.segment(text)) n++;
  return n;
}

export type Parsed = { readonly text: string } | { readonly refused: 400 | 413 };

/** One feedback's text, as sent; or the status that refuses it. */
export function parseFeedback(body: string): Parsed {
  if (body.length > BODY_LIMIT) return { refused: 413 };
  let parsed: unknown;
  try {
    parsed = JSON.parse(body);
  } catch {
    return { refused: 400 };
  }
  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) return { refused: 400 };
  const text = (parsed as Record<string, unknown>)['text'];
  if (Object.keys(parsed).length !== 1 || typeof text !== 'string' || text.trim() === '') return { refused: 400 };
  if (characters(text) > FEEDBACK_LIMIT) return { refused: 413 };
  return { text };
}

/** The UTC day of [now], YYYY-MM-DD: all a feedback keeps of when. */
export function utcDay(now: Date): string {
  return now.toISOString().slice(0, 10);
}

/** An object's name: its day, then 128 random bits that name nothing. */
export function feedbackKey(day: string, random: Buffer): string {
  return `${day}/${random.toString('hex')}.txt`;
}
