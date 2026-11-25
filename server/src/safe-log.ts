// The server's only logger (CLAUDE.md R3; G5 exempts this file). It
// takes an event code and numbers, never a string: nothing from a night
// can reach a log. Lambda sends each line to CloudWatch, kept 7 days.

/** Every event the server may log. A new event is a new value here. */
export const LOG_EVENTS = [
  'notFound',
  'handlerFailed',
  // The front door (D71): a key given, a beta key refused, Soniox's
  // answer not a key (with its status), Parameter Store failing.
  'keyIssued',
  'keyRefused',
  'sonioxKeyFailed',
  'parameterFailed',
  // Feedback (D152): one kept; one refused (with its status, 400 or 413);
  // the bucket failing. Never a word of it (R3).
  'feedbackKept',
  'feedbackRefused',
  'feedbackFailed',
  // A night's readings (head's message 33): given (with their count);
  // refused (with its status, 400 or 413); the model failing. Never a word.
  'readingGiven',
  'readingRefused',
  'readingFailed',
  // Every model call (head's message 34): its step and model (their places
  // in STEPS and MODELS), its input, output, cache-read and cache-written
  // tokens, and its cost in millionths of a dollar. Numbers only.
  'modelUsage',
] as const;
export type LogEvent = (typeof LOG_EVENTS)[number];

type Sink = (line: string) => void;

const toConsole: Sink = (line) => {
  console.info(line);
};
let sink: Sink = toConsole;

/** For tests: where lines go. Returns a function that restores it. */
export function setSink(next: Sink): () => void {
  sink = next;
  return () => {
    sink = toConsole;
  };
}

export function safeLog(code: LogEvent, numbers: readonly number[] = []): void {
  if (!(LOG_EVENTS as readonly string[]).includes(code)) {
    throw new TypeError('safe-log-code');
  }
  for (const n of numbers) {
    if (typeof n !== 'number' || !Number.isFinite(n)) {
      throw new TypeError('safe-log-number');
    }
  }
  sink([code, ...numbers.map(String)].join(' '));
}
