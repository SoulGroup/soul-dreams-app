// The server's one entry point, behind its function URL (head's message
// 14; D71; D152): the front door (door.ts), wired to Parameter Store, to
// Soniox and to the feedback bucket. Everything it decides is in door.ts
// and feedback.ts and tested there.
import { makeDoor } from './door.ts';
import { FEEDBACK_BUCKET_VARIABLE } from './feedback.ts';
import { makeFeedbackStore, putToS3 } from './feedback-store.ts';
import { readParameter } from './parameters.ts';
import { requestTemporaryKey } from './soniox.ts';

export const handler = makeDoor({
  readParameter,
  temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
  keepFeedback: makeFeedbackStore(process.env[FEEDBACK_BUCKET_VARIABLE] ?? '', putToS3),
  now: () => new Date(),
});
