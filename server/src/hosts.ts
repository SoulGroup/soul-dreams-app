// Every host the server talks to lives here, and nowhere else
// (CLAUDE.md R10, G9). Parameter Store, like Bedrock later, is reached
// through the AWS SDK by Region, not by a host of ours.

/** Soniox's EU REST host, which issues the short-lived keys (D69). */
export const SONIOX_TEMPORARY_KEY_URL = 'https://api.eu.soniox.com/v1/auth/temporary-api-key';

/**
 * Black Forest Labs' EU image API, and the end of the hosts it answers from:
 * for the image trial's test script (`trial/bfl.ts`, D144) on the owner's
 * Mac only. Not a host of the server, so not in HOSTS.
 */
export const BFL_API_URL = 'https://api.eu.bfl.ai/v1';
export const BFL_HOST_SUFFIX = '.bfl.ai';

export const HOSTS: readonly string[] = Object.freeze(['api.eu.soniox.com']);
