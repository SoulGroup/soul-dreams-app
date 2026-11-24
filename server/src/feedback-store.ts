// Where feedback is kept (D152 item 1): one object per feedback in the
// private bucket, named by its UTC day and 128 random bits, holding the
// text alone: no name, phone, journal, network address or time of day
// (R3, R4). The S3 client is the one the Lambda runtime carries; the package
// is a devDependency for its types only, as the SSM client is. A failure
// carries no message of ours.
import { randomBytes } from 'node:crypto';
import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { feedbackKey } from './feedback.ts';

export interface PutInput {
  readonly Bucket: string;
  readonly Key: string;
  readonly Body: string;
  readonly ContentType: string;
}

export type Put = (input: PutInput) => Promise<unknown>;

/** Keeps one feedback's text under its day in [bucket], through [put]. */
export function makeFeedbackStore(
  bucket: string,
  put: Put,
  random: () => Buffer = () => randomBytes(16),
): (day: string, text: string) => Promise<void> {
  return async (day, text) => {
    if (bucket === '') throw new Error('feedback-bucket');
    await put({ Bucket: bucket, Key: feedbackKey(day, random()), Body: text, ContentType: 'text/plain; charset=utf-8' });
  };
}

let client: S3Client | undefined;

/** One object put, in eu-north-1. */
export const putToS3: Put = (input) => {
  client ??= new S3Client({ region: 'eu-north-1' });
  return client.send(new PutObjectCommand({ ...input }));
};
