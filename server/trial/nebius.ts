// The Nebius image test (D142), on the owner's Mac: the trial's six
// invented prompts, sent one after another to Nebius Token Factory's
// image API with each model's own settings, the images and the times
// saved in the folder given, outside the repository. The key comes from
// the environment (the owner reads it from Parameter Store); nothing sent
// or received is written anywhere, and an error is a code.
//   NEBIUS_API_KEY=... node trial/nebius.ts <folder>
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import { NEBIUS_IMAGES_URL } from '../src/hosts.ts';
import { prompt, SCENES } from './measure.ts';

export interface Reply {
  readonly status: number;
  json(): Promise<unknown>;
}
export type Send = (
  url: string,
  init: { method: 'POST'; headers: Record<string, string>; body: string },
) => Promise<Reply>;

// The models' IDs and steps as Nebius's image page gives them [READ,
// docs.tokenfactory.nebius.com, 2026-11-23].
export const NEBIUS_MODELS = [
  { name: 'flux-schnell', id: 'black-forest-labs/flux-schnell', steps: 4 },
  { name: 'sdxl', id: 'stability-ai/sdxl', steps: 30 },
] as const;

const PNG = Buffer.from([0x89, 0x50, 0x4e, 0x47]);

export async function measure(send: Send, key: string, folder: string, now: () => number): Promise<void> {
  for (const model of NEBIUS_MODELS) {
    const dir = join(folder, model.name);
    mkdirSync(dir, { recursive: true });
    const milliseconds: number[] = [];
    for (const [i] of SCENES.entries()) {
      const body = JSON.stringify({
        model: model.id,
        prompt: prompt(i),
        width: 1024,
        height: 1024,
        num_inference_steps: model.steps,
        seed: 1000 + i,
        response_format: 'b64_json',
        response_extension: 'png',
      });
      const start = now();
      let reply: Reply;
      try {
        reply = await send(NEBIUS_IMAGES_URL, {
          method: 'POST',
          headers: { Authorization: `Bearer ${key}`, 'Content-Type': 'application/json' },
          body,
        });
      } catch {
        throw new Error('nebius-network');
      }
      if (reply.status !== 200) {
        throw new Error(`nebius-http-${reply.status}`);
      }
      const answer = (await reply.json()) as { data?: { b64_json?: unknown }[] };
      const image = answer.data?.[0]?.b64_json;
      if (typeof image !== 'string') {
        throw new Error('nebius-reply');
      }
      milliseconds.push(now() - start);
      const png = Buffer.from(image, 'base64');
      if (!png.subarray(0, 4).equals(PNG)) {
        throw new Error('nebius-not-png');
      }
      writeFileSync(join(dir, `${i + 1}.png`), png);
    }
    writeFileSync(join(dir, 'timings.json'), `${JSON.stringify({ milliseconds }, null, 2)}\n`);
    writeFileSync(join(dir, 'results.md'), table(model.name, milliseconds));
  }
}

function table(name: string, milliseconds: readonly number[]): string {
  const seconds = milliseconds.map((m) => m / 1000);
  const mean = seconds.reduce((a, b) => a + b, 0) / seconds.length;
  const rows = seconds.map((s, i) => `| ${i + 1} | ${s.toFixed(1)} |`);
  return [
    `# ${name} on Nebius Token Factory`,
    '',
    'Seconds from request to image,' + ' one at a time, 1024 x 1024.',
    '',
    '| Painting | Seconds |',
    '|---|---|',
    ...rows,
    '',
    `Mean: ${mean.toFixed(1)} seconds.`,
    'The price per image is on the pricing page.',
    '',
  ].join('\n');
}

export function parseArgs(
  env: Readonly<Record<string, string | undefined>>,
  argv: readonly string[],
): { key: string; folder: string } {
  const key = env.NEBIUS_API_KEY;
  const [folder] = argv;
  if (key === undefined || key === '' || folder === undefined || folder === '' || argv.length > 1) {
    throw new Error('nebius-usage');
  }
  return { key, folder };
}

if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const { key, folder } = parseArgs(process.env, process.argv.slice(2));
  await measure(
    (url, init) => fetch(url, { ...init, signal: AbortSignal.timeout(300000) }),
    key,
    folder,
    () => Date.now(),
  );
}
