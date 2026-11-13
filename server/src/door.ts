// The front door (head's message 14; D71): a Lambda function URL with no
// authentication of its own, and the beta key checked here. POST / with
// the beta key as a bearer token gets a short-lived Soniox key; anything
// else gets nothing. It reads the method, the path and one header only:
// never the caller's network address, the body or any other header. It
// logs codes and numbers only (R3, R4).
import { isBetaKeyShape, sameKey } from './beta-key.ts';
import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from './parameter-names.ts';
import { safeLog } from './safe-log.ts';
import { SonioxFailure, type TemporaryKey } from './soniox.ts';

export interface DoorEvent {
  readonly rawPath?: string;
  readonly headers?: Readonly<Record<string, string | undefined>>;
  readonly requestContext?: { readonly http?: { readonly method?: string } };
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
  if (event.requestContext?.http?.method !== 'POST' || event.rawPath !== '/') {
    safeLog('notFound');
    return { statusCode: 404 };
  }
  const header = event.headers?.['authorization'];
  const given = header !== undefined && header.startsWith(BEARER) ? header.slice(BEARER.length) : '';
  if (!isBetaKeyShape(given)) {
    safeLog('keyRefused');
    return { statusCode: 401 };
  }
  let betaKey: string;
  let projectKey: string;
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
