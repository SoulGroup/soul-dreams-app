// Every host the server talks to lives here, and nowhere else
// (CLAUDE.md R10, G9). Parameter Store, like Bedrock later, is reached
// through the AWS SDK by Region, not by a host of ours.

/** Soniox's EU REST host, which issues the short-lived keys (D69). */
export const SONIOX_TEMPORARY_KEY_URL = 'https://api.eu.soniox.com/v1/auth/temporary-api-key';

/**
 * Black Forest Labs' EU image API, and the end of the hosts it answers from:
 * for the image trial's test script (`trial/bfl.ts`, D144) and the curated
 * set's painter (`trial/curated.ts`, D147), on the owner's Mac only. Not a
 * host of the server, so not in HOSTS.
 */
export const BFL_API_URL = 'https://api.eu.bfl.ai/v1';
export const BFL_HOST_SUFFIX = '.bfl.ai';

/**
 * Not hosts, and never fetched: the names inside the invisible AI tag that
 * the curated set's painter writes into every shipped painting (D123, D147),
 * the IPTC digital source type in an XMP packet. Here because every such
 * literal lives in this file (G9).
 */
export const XMP_HEADER = 'http://ns.adobe.com/xap/1.0/';
export const XMP_RDF = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
export const XMP_IPTC_EXT = 'http://iptc.org/std/Iptc4xmpExt/2008-02-29/';
export const AI_SOURCE_TYPE = 'http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia';

export const HOSTS: readonly string[] = Object.freeze(['api.eu.soniox.com']);
