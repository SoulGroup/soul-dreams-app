// A short-lived Soniox key for one recording (technical-answers a; D71
// Q10): a minute to open, one stream only, thirty minutes at most. The
// request is exactly these four fields: never a reference of ours,
// which Soniox would record in its usage logs (R4).
import { SONIOX_TEMPORARY_KEY_URL } from './hosts.ts';

export const TEMPORARY_KEY_REQUEST = Object.freeze({
  usage_type: 'transcribe_websocket',
  expires_in_seconds: 60,
  single_use: true,
  max_session_duration_seconds: 1800,
});

export interface TemporaryKey {
  readonly key: string;
  readonly expiresAt: string;
}

/** Soniox did not give a key: its HTTP status, 0 for no answer, -1 for an unreadable one. */
export class SonioxFailure extends Error {
  readonly status: number;

  constructor(status: number) {
    super('soniox-key');
    this.status = status;
  }
}

export type Fetch = (url: string, init: RequestInit) => Promise<Response>;

export async function requestTemporaryKey(projectKey: string, fetchFn: Fetch = fetch): Promise<TemporaryKey> {
  let reply: Response;
  try {
    reply = await fetchFn(SONIOX_TEMPORARY_KEY_URL, {
      method: 'POST',
      headers: { authorization: `Bearer ${projectKey}`, 'content-type': 'application/json' },
      body: JSON.stringify(TEMPORARY_KEY_REQUEST),
      signal: AbortSignal.timeout(5000),
    });
  } catch {
    throw new SonioxFailure(0);
  }
  if (reply.status !== 201) {
    throw new SonioxFailure(reply.status);
  }
  let parsed: unknown;
  try {
    parsed = await reply.json();
  } catch {
    throw new SonioxFailure(-1);
  }
  const fields = typeof parsed === 'object' && parsed !== null ? (parsed as Record<string, unknown>) : {};
  const key = fields['api_key'];
  const expiresAt = fields['expires_at'];
  if (typeof key !== 'string' || key === '' || typeof expiresAt !== 'string') {
    throw new SonioxFailure(-1);
  }
  return { key, expiresAt };
}
