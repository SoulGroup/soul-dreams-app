// The front door (head's message 14; D71; D152): a Lambda function URL with
// no authentication of its own, and the beta key checked here. POST / with
// the beta key as a bearer token gets a short-lived Soniox key; POST
// /feedback with it keeps one feedback (feedback.ts); anything else gets
// nothing. It reads the method, the path and one header, and the body only
// for feedback, after the key: never the caller's network address or any
// other header. It logs codes and numbers only (R3, R4).
import { isBetaKeyShape, sameKey } from './beta-key.ts';
import { parseFeedback, utcDay } from './feedback.ts';
import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from './parameter-names.ts';
import { safeLog } from './safe-log.ts';
import { SonioxFailure, type TemporaryKey } from './soniox.ts';

export interface DoorEvent {
  readonly rawPath?: string;
  readonly headers?: Readonly<Record<string, string | undefined>>;
  readonly requestContext?: { readonly http?: { readonly method?: string } };
  readonly body?: string;
  readonly isBase64Encoded?: boolean;
}

export interface Reply {
  readonly statusCode: number;
  readonly headers?: Readonly<Record<string, string>>;
  readonly body?: string;
}

export interface DoorDeps {
  /** A SecureString's value, decrypted. */
  readonly readParameter: (name: string) => Promise<string>;
  readonly temporaryKey: (projectKey: string) => Promise<TemporaryKey>;
  /** Keeps one feedback's text under its UTC day (D152). */
  readonly keepFeedback: (day: string, text: string) => Promise<void>;
  readonly now: () => Date;
}

const BEARER = 'Bearer ';

export function makeDoor(deps: DoorDeps): (event: DoorEvent) => Promise<Reply> {
  return async (event) => {
    try {
      return await answer(event, deps);
    } catch {
      safeLog('handlerFailed');
      return { statusCode: 500 };
    }
  };
}

async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
  const post = event.requestContext?.http?.method === 'POST';
  const path = event.rawPath;
  if (!post || (path !== '/' && path !== '/feedback')) {
    safeLog('notFound');
    return { statusCode: 404 };
  }
  const refused = await checkBetaKey(event, deps);
  if (refused !== undefined) return refused;
  return path === '/' ? issueKey(deps) : takeFeedback(event, deps);
}

// The beta key, by its shape and then by the kept one; undefined when right.
async function checkBetaKey(event: DoorEvent, deps: DoorDeps): Promise<Reply | undefined> {
  const header = event.headers?.['authorization'];
  const given = header !== undefined && header.startsWith(BEARER) ? header.slice(BEARER.length) : '';
  if (!isBetaKeyShape(given)) {
    safeLog('keyRefused');
    return { statusCode: 401 };
  }
  let betaKey: string;
  try {
    betaKey = await deps.readParameter(BETA_KEY_PARAMETER);
  } catch {
    safeLog('parameterFailed');
    return { statusCode: 500 };
  }
  if (!sameKey(given, betaKey)) {
    safeLog('keyRefused');
    return { statusCode: 401 };
  }
  return undefined;
}

async function issueKey(deps: DoorDeps): Promise<Reply> {
  let projectKey: string;
  try {
    projectKey = await deps.readParameter(SONIOX_KEY_PARAMETER);
  } catch {
    safeLog('parameterFailed');
    return { statusCode: 500 };
  }
  let key: TemporaryKey;
  try {
    key = await deps.temporaryKey(projectKey);
  } catch (failure) {
    safeLog('sonioxKeyFailed', [failure instanceof SonioxFailure ? failure.status : 0]);
    return { statusCode: 502 };
  }
  safeLog('keyIssued');
  return {
    statusCode: 200,
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ key: key.key, expiresAt: key.expiresAt }),
  };
}

// One feedback (D152): its text alone, under the server's UTC day; 204 when
// kept, nothing in the reply.
async function takeFeedback(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
  const raw = event.body ?? '';
  const body = event.isBase64Encoded === true ? Buffer.from(raw, 'base64').toString('utf8') : raw;
  const parsed = parseFeedback(body);
  if ('refused' in parsed) {
    safeLog('feedbackRefused', [parsed.refused]);
    return { statusCode: parsed.refused };
  }
  try {
    await deps.keepFeedback(utcDay(deps.now()), parsed.text);
  } catch {
    safeLog('feedbackFailed');
    return { statusCode: 502 };
  }
  safeLog('feedbackKept');
  return { statusCode: 204 };
}
