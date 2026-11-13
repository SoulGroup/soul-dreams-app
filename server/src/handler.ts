// The server's one entry point, behind its function URL (head's message
// 14; D71): the front door (door.ts), wired to Parameter Store and to
// Soniox. Everything it decides is in door.ts and tested there.
import { makeDoor } from './door.ts';
import { readParameter } from './parameters.ts';
import { requestTemporaryKey } from './soniox.ts';

export const handler = makeDoor({
  readParameter,
  temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
});
