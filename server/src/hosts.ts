// Every host the server talks to lives here, and nowhere else
// (CLAUDE.md R10, G9). Parameter Store, like Bedrock later, is reached
// through the AWS SDK by Region, not by a host of ours.

/** Soniox's EU REST host, which issues the short-lived keys (D69). */
export const SONIOX_TEMPORARY_KEY_URL = 'https://api.eu.soniox.com/v1/auth/temporary-api-key';

/**
 * Nebius Token Factory's image API: for the image trial's test script
 * (`trial/nebius.ts`, D142) on the owner's Mac only. Not a host of the
 * server, so not in HOSTS.
 */
export const NEBIUS_IMAGES_URL = 'https://api.tokenfactory.nebius.com/v1/images/generations';

export const HOSTS: readonly string[] = Object.freeze(['api.eu.soniox.com']);
