// The server's one entry point, behind the HTTP API (D42 Q4). No feature
// yet: every request is answered 404 with no body, and one code is
// logged (D42 Q15). It never reads the event, which carries the
// caller's network address, and never logs an error's message (R3).
import { safeLog } from './safe-log.ts';

export interface Reply {
  readonly statusCode: number;
}

export async function handler(): Promise<Reply> {
  try {
    safeLog('notFound');
    return { statusCode: 404 };
  } catch {
    safeLog('handlerFailed');
    return { statusCode: 500 };
  }
}
