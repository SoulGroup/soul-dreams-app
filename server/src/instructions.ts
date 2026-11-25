// The model's instructions (R7; head's message 33). They are not written
// yet: they wait for Interpretation's redrafts, and reach the build as files
// the owner's import copies into server/instructions/, which the build
// copies into the Lambda's code folder beside the compiled code. Until then
// the folder holds only the placeholder, empty, which is not an instruction.
import { readdirSync, readFileSync } from 'node:fs';

/** The empty file that keeps the folder until the instructions come. */
export const PLACEHOLDER = 'AWAITING-INSTRUCTIONS.md';

/** The folder beside the compiled code (dist/src/instructions). */
export const INSTRUCTIONS = new URL('instructions/', import.meta.url);

export interface Instruction {
  readonly name: string;
  readonly text: string;
}

/** Every instruction file in [dir], word for word, in name order. */
export function readInstructions(dir: URL): Instruction[] {
  return readdirSync(dir, { withFileTypes: true })
    .filter((f) => f.isFile() && f.name.endsWith('.md') && f.name !== PLACEHOLDER)
    .map((f) => f.name)
    .sort()
    .map((name) => ({ name, text: readFileSync(new URL(name, dir), 'utf8') }));
}
