// Every model call goes through one interface (head's message 34): the
// step names its model in one setting, so swapping a step's model is one
// line in SETUP; each model has one caller, the stand-in's included. Every
// call's tokens (input, output, read from and written to the cache) and its
// cost are counted and logged as numbers only, never a word (R3). A prompt is
// fixed text first (the instructions) and the dreamer's words last, so only
// fixed text could ever be cached; prompt caching stays off until AWS's own
// pages say it fits retention mode none (C3-T 2d).
import { safeLog } from './safe-log.ts';

/** The steps that call a model. Only the readings' is built. */
export const STEPS = ['opening', 'readings', 'checks', 'scenery', 'recurrence'] as const;
export type Step = (typeof STEPS)[number];

/** The models with a caller. Claude's are added with their caller. */
export const MODELS = ['stand-in'] as const;
export type ModelName = (typeof MODELS)[number];

/** A step's model, with its reasoning capped in tokens where it has one. */
export interface ModelChoice {
  readonly model: ModelName;
  readonly reasoningCap?: number;
}

export type Setup = Readonly<Record<Step, ModelChoice>>;

/** The one setting: the model for each step. */
export const SETUP: Setup = Object.freeze({
  opening: { model: 'stand-in' },
  readings: { model: 'stand-in' },
  checks: { model: 'stand-in' },
  scenery: { model: 'stand-in' },
  recurrence: { model: 'stand-in' },
});

/** Off until AWS's pages confirm caching fits retention mode none. */
export const PROMPT_CACHING = false;

/** Fixed text first, in order (the cacheable part); the dreamer's words last. */
export interface Prompt {
  readonly fixed: readonly string[];
  readonly words: string;
}

export interface Usage {
  readonly input: number;
  readonly output: number;
  readonly cacheRead: number;
  readonly cacheWrite: number;
}

/** A model's answer: its text and what it counted. */
export interface Answer {
  readonly text: string;
  readonly usage: Usage;
}

/** One model's way of answering a prompt. */
export type Caller = (choice: ModelChoice, prompt: Prompt, cache: boolean) => Promise<Answer>;

/** Millionths of a US dollar per token. */
export type Price = Usage;

export const PRICES: Readonly<Record<ModelName, Price>> = Object.freeze({
  'stand-in': { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
});

/** One call's counts and cost (millionths of a dollar), as the phone keeps them. */
export interface Call extends Usage {
  readonly step: Step;
  readonly model: ModelName;
  readonly cost: number;
}

export function costOf(price: Price, usage: Usage): number {
  return (
    usage.input * price.input +
    usage.output * price.output +
    usage.cacheRead * price.cacheRead +
    usage.cacheWrite * price.cacheWrite
  );
}

export interface CallDeps {
  readonly setup: Setup;
  readonly callers: Readonly<Record<ModelName, Caller>>;
  readonly caching: boolean;
}

/** Asks [step]'s model; logs the call's counts and cost, numbers only. */
export async function callModel(step: Step, prompt: Prompt, deps: CallDeps): Promise<{ text: string; call: Call }> {
  const choice = deps.setup[step];
  const answer = await deps.callers[choice.model](choice, prompt, deps.caching);
  const { input, output, cacheRead, cacheWrite } = answer.usage;
  const cost = costOf(PRICES[choice.model], answer.usage);
  safeLog('modelUsage', [STEPS.indexOf(step), MODELS.indexOf(choice.model), input, output, cacheRead, cacheWrite, cost]);
  return { text: answer.text, call: { step, model: choice.model, input, output, cacheRead, cacheWrite, cost } };
}

/**
 * The stand-in (head's message 33): fixed placeholder readings, marked as
 * such, the same whatever it is asked; it reads nothing of the prompt, writes
 * nothing that imitates the practice (C4-T item 4) and counts no tokens.
 */
export const STAND_IN_READINGS = Object.freeze(
  [1, 2, 3].map((n) => Object.freeze({ lens: n - 1, text: `[STAND-IN · ${n}]` })),
);
export const STAND_IN_TEXT = JSON.stringify({ readings: STAND_IN_READINGS });

export const standInCaller: Caller = async () => ({
  text: STAND_IN_TEXT,
  usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
});
