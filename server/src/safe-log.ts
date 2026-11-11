// The server's only logger (CLAUDE.md R3; G5 exempts this file). It
// takes an event code and numbers, never a string: nothing from a night
// can reach a log. Lambda sends each line to CloudWatch, kept 7 days.

/** Every event the server may log. A new event is a new value here. */
export const LOG_EVENTS = ['notFound', 'handlerFailed'] as const;
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
