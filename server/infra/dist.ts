// The Lambda's code folder, dist/src (D42 Q5). `clean` empties dist/
// before tsc writes it, so no stale file reaches the asset. `mark`
// writes the module marker beside the compiled files: without it,
// Lambda reads them as CommonJS and the first import fails.
import { mkdirSync, rmSync, writeFileSync } from 'node:fs';

const DIST = new URL('../dist/', import.meta.url);
const CODE = new URL('src/', DIST);

const step = process.argv[2];
if (step === 'clean') {
  rmSync(DIST, { recursive: true, force: true });
} else if (step === 'mark') {
  mkdirSync(CODE, { recursive: true });
  writeFileSync(new URL('package.json', CODE), '{"type":"module"}\n');
} else {
  process.exitCode = 2;
}
