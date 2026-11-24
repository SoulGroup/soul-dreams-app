// The server's one entry point, behind its function URL (head's message
// 14; D71; D152): the front door (door.ts), wired to Parameter Store, to
// Soniox and to the feedback bucket. Everything it decides is in door.ts
// and feedback.ts and tested there.
import { makeDoor } from './door.ts';
import { FEEDBACK_BUCKET_VARIABLE } from './feedback.ts';
import { makeFeedbackStore, putToS3, type Put } from './feedback-store.ts';
import { readParameter } from './parameters.ts';
import { requestTemporaryKey } from './soniox.ts';

/** The door, wired: [env] names the feedback bucket, [put] sends to it. */
export function wire(
  env: Readonly<Record<string, string | undefined>>,
  put: Put,
  read: (name: string) => Promise<string>,
) {
  return makeDoor({
    readParameter: read,
    temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
    keepFeedback: makeFeedbackStore(env[FEEDBACK_BUCKET_VARIABLE] ?? '', put),
    now: () => new Date(),
  });
}

export const handler = wire(process.env, putToS3, readParameter);
