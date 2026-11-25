// The server's one entry point, behind its function URL (head's message
// 14; D71; D152; head's messages 33 and 34; D162): the front door
// (door.ts), wired to Parameter Store, to Soniox, to the feedback bucket,
// to the models through their one interface (models.ts): each step's model
// from SETUP, its caller from [callers] (the stand-ins' until Claude's
// come), handed the instructions read once from the folder beside the code;
// and to Black Forest Labs for the painting ([send], [clock]). What it
// decides is in door.ts, feedback.ts, reading.ts, painting.ts and models.ts.
import { makeDoor } from './door.ts';
import { FEEDBACK_BUCKET_VARIABLE } from './feedback.ts';
import { makeFeedbackStore, putToS3, type Put } from './feedback-store.ts';
import { type Instruction, INSTRUCTIONS, readInstructions } from './instructions.ts';
import { readParameter } from './parameters.ts';
import {
  type Caller,
  callModel,
  type ModelName,
  PROMPT_CACHING,
  SETUP,
  standInCaller,
  standInSceneryCaller,
} from './models.ts';
import { type BflSend, type Clock, fetchSend, paint, paintNight, realClock } from './painting.ts';
import { type Ask, readNight } from './reading.ts';
import { requestTemporaryKey } from './soniox.ts';

/** The door, wired: [env] names the feedback bucket, [put] sends to it. */
export function wire(
  env: Readonly<Record<string, string | undefined>>,
  put: Put,
  read: (name: string) => Promise<string>,
  callers: Readonly<Record<ModelName, Caller>> = { 'stand-in': standInCaller, 'stand-in-scenery': standInSceneryCaller },
  instructions: () => readonly Instruction[] = () => readInstructions(INSTRUCTIONS),
  send: BflSend = fetchSend,
  clock: Clock = realClock,
) {
  let held: readonly Instruction[] | undefined;
  const ask: Ask = (step, prompt) => callModel(step, prompt, { setup: SETUP, callers, caching: PROMPT_CACHING });
  return makeDoor({
    readParameter: read,
    temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
    keepFeedback: makeFeedbackStore(env[FEEDBACK_BUCKET_VARIABLE] ?? '', put),
    readNight: (request) => readNight((held ??= instructions()), request, ask),
    paintNight: (bflKey) => paintNight(ask, (scene) => paint(send, bflKey, clock, scene)),
    now: () => new Date(),
  });
}

export const handler = wire(process.env, putToS3, readParameter);
