// The image trial's requests and its arithmetic (D135, D136). The six
// prompts are invented scenery, with no person and nothing from any
// dream (R2). Every price is read from AWS's Price List (see PRICES).
import { STYLE } from '../src/painting.ts';

export type ModelKey = 'flux' | 'sdxl';

// not-dreamer-facing: the trial's invented scenery, one per painting.
export const SCENES = [
  'a wheat field under a swirling starry sky',
  'cypress trees bending in the wind beside a village',
  'a blossoming almond branch against a pale blue sky',
  'sunflowers in a clay vase on a wooden table',
  'an olive grove on rolling hills under a yellow sun',
  'a stone bridge over a calm canal at night',
] as const;
// The one style (D146) lives with the server's painting now.
export { STYLE };

export function prompt(index: number): string {
  const scene = SCENES[index];
  if (scene === undefined) {
    throw new Error('trial-prompt');
  }
  return `${scene}, ${STYLE}`;
}

// Each model's settings as its card or the library sets them, square
// at 1024, the models' own size.
export const SETTINGS: Record<ModelKey, Record<string, number>> = {
  flux: { num_inference_steps: 4, guidance_scale: 0, max_sequence_length: 256, height: 1024, width: 1024 },
  sdxl: { num_inference_steps: 50, guidance_scale: 5, height: 1024, width: 1024 },
};

/** The request's body: the same seed for the same prompt on every model. */
export function requestBody(model: ModelKey, index: number): string {
  return JSON.stringify({ inputs: prompt(index), parameters: { ...SETTINGS[model], seed: 1000 + index } });
}

// USD per hour, on demand, eu-north-1 [READ, AWS Price List API,
// AmazonSageMaker, eu-north-1, published 2026-11-22T02:34:21Z, effective
// 2026-11-01]. ml.g6.xlarge: EUN1-AsyncInf. ml.g6e.xlarge has no
// AsyncInf or Host entry there: its Training and Processing price
// stands in, as the two are equal for every type listed with both
// [ASSUMED until the owner's bill shows it].
export const PRICES: Record<string, number> = {
  'ml.g6.xlarge': 1.195,
  'ml.g6e.xlarge': 2.7636,
};

/** What the run measured, in milliseconds since the epoch. */
export interface Round {
  readonly paintings: number;
  readonly submitted: number;
  /** When each result reached the bucket, in order. */
  readonly done: readonly number[];
  readonly scaleOutStart: number;
  readonly scaleOutEnd: number;
  readonly scaleInEnd: number;
}

export interface Run {
  readonly model: ModelKey;
  readonly instanceType: string;
  readonly idleMinutes: number;
  /** One painting waking the machine. */
  readonly single: Round;
  /** Six paintings sent together, waking it once. */
  readonly batch: Round;
}

export interface Costs {
  readonly pricePerHour: number;
  /** From the scale-out to in service, seconds. */
  readonly coldStart: number;
  /** Seconds between paintings, warm, from the batch. */
  readonly perPainting: number;
  /** After the single painting until the instance was gone, seconds. */
  readonly tail: number;
  /** Instance seconds billed for the single painting. */
  readonly singleBilled: number;
  readonly batchBilled: number;
  readonly warm: number;
  readonly wake10: number;
  readonly wake2: number;
  readonly batchMeasured: number;
  /** Paintings per daily wake, and the cost of each. */
  readonly daily: readonly (readonly [number, number])[];
}

export const DAILY = [10, 60, 100] as const;

function seconds(from: number, to: number): number {
  if (!(to >= from)) {
    throw new Error('trial-times');
  }
  return (to - from) / 1000;
}

function last(r: Round): number {
  const t = r.done[r.done.length - 1];
  if (t === undefined || r.done.length !== r.paintings) {
    throw new Error('trial-round');
  }
  return t;
}

export function costs(run: Run): Costs {
  const price = PRICES[run.instanceType];
  if (price === undefined) {
    throw new Error('trial-price');
  }
  const perSecond = price / 3600;
  const first = run.batch.done[0];
  if (first === undefined || run.batch.paintings < 2) {
    throw new Error('trial-round');
  }
  const perPainting = seconds(first, last(run.batch)) / (run.batch.paintings - 1);
  const singleBilled = seconds(run.single.scaleOutStart, run.single.scaleInEnd);
  const batchBilled = seconds(run.batch.scaleOutStart, run.batch.scaleInEnd);
  // The same wake with an idle time of 2 minutes: the measured one less
  // the minutes it waited beyond 2.
  const shorter = (run.idleMinutes - 2) * 60;
  return {
    pricePerHour: price,
    coldStart: seconds(run.single.scaleOutStart, run.single.scaleOutEnd),
    perPainting,
    tail: seconds(last(run.single), run.single.scaleInEnd),
    singleBilled,
    batchBilled,
    warm: perSecond * perPainting,
    wake10: perSecond * (singleBilled - (run.idleMinutes - 10) * 60),
    wake2: perSecond * (singleBilled - shorter),
    batchMeasured: (perSecond * batchBilled) / run.batch.paintings,
    daily: DAILY.map((n) => [n, (perSecond * (singleBilled + (n - 1) * perPainting)) / n] as const),
  };
}

function usd(n: number): string {
  return `USD ${n.toFixed(4)}`;
}

function s(n: number): string {
  return `${n.toFixed(1)} s`;
}

/** The results as Markdown, for the owner and the Build chat. */
export function report(run: Run): string {
  const c = costs(run);
  const basis =
    run.instanceType === 'ml.g6e.xlarge'
      ? 'USD 2.7636 per hour, the Training price [READ]; hosting [ASSUMED]'
      : 'USD 1.195 per hour, EUN1-AsyncInf [READ]';
  return [
    `# Image trial: ${run.model} on ${run.instanceType}`,
    '',
    `Price basis: ${basis}. Idle setting: ${run.idleMinutes} minutes.`,
    '',
    '| Measure | Value |',
    '|---|---|',
    `| Cold start, scale-out to in service | ${s(c.coldStart)} |`,
    `| Time per painting, warm | ${s(c.perPainting)} |`,
    `| Tail after the last painting | ${s(c.tail)} |`,
    `| Billed, one painting waking it | ${s(c.singleBilled)} |`,
    `| Billed, six paintings waking it once | ${s(c.batchBilled)} |`,
    '',
    '| Cost per painting | USD |',
    '|---|---|',
    `| Warm | ${usd(c.warm)} |`,
    `| Woken for each, idle 10 minutes | ${usd(c.wake10)} |`,
    `| Woken for each, idle 2 minutes (derived) | ${usd(c.wake2)} |`,
    `| Six together, measured | ${usd(c.batchMeasured)} |`,
    ...c.daily.map(([n, cost]) => `| Daily batch of ${n} (derived) | ${usd(cost)} |`),
    '',
  ].join('\n');
}
