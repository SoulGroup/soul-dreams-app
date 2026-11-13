// Reads one SecureString, decrypted (D69; D71 Q13 a). The code runs on
// the AWS SDK for JavaScript v3 that the Lambda runtime carries; the
// package is a devDependency for its types only, and is never in the
// Lambda's code folder. A failure carries no message of ours.
import { GetParameterCommand, SSMClient } from '@aws-sdk/client-ssm';

const client = new SSMClient({ region: 'eu-north-1' });

export async function readParameter(name: string): Promise<string> {
  const reply = await client.send(new GetParameterCommand({ Name: name, WithDecryption: true }));
  const value = reply.Parameter?.Value;
  if (value === undefined || value === '') {
    throw new Error('parameter-empty');
  }
  return value;
}
