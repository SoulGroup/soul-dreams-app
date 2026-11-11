# Plan: scaffold-4-server (Scaffolding, branch 4 of 4)

*No matter where you are on your journey, the steps you take are equally important.*

Written by Claude Code (Opus) on 2026-11-11 from the investigation (`.scratch/for-build-chat/scaffold-4-investigation.md`)
and the owner's rulings D41 and D42; **amended for D43** (the answers to Part 4), which commits the server's mutation
checks as a script run by hand and marks Tasks 6 and 7 for an Opus review. **Proven before committing as far as the
sandbox allows** (Part 5). Only this file is committed by the planning step. Nothing here is implemented yet.

## Part 1 · Spec

### In plain words

The server gets its first code: a TypeScript handler for AWS Lambda that answers every request with "not found", a
logger that can write only event codes and numbers, an empty hosts file, and the AWS infrastructure as code (AWS CDK
in TypeScript): one Lambda behind an HTTP API in Stockholm (eu-north-1), its logs kept 7 days, with no access logs and
nothing that identifies anyone. **Nothing is deployed.** The tests build the infrastructure's template on the Mac,
with no AWS credentials, no CDK command line and no network, and prove what it holds and what it does not. The owner
installs the five packages; Claude Code never installs anything.

### What branch 4 builds

- `server/package.json`, its lockfile (the owner's install), `.gitignore`, two tsconfigs and `cdk.json`.
- `server/src/`: `handler.ts`, `safe-log.ts`, `hosts.ts` (banked item 2).
- `server/infra/`: `dist.ts` (the build's two steps), `account.ts` (the deploy refusal), `stack.ts`, `app.ts`.
- `server/test/`: 28 tests on Node's built-in runner, in 7 files.
- `tool/server_mutations.py`: the server's 13 mutation checks, committed and run by hand; `check_all.sh` does not
  call it (D43 Q3).
- `tool/check_all.sh`: the pinned Node, then `npm ci --offline`, `npm run check` and `npm test`.
- `.claude/settings.json`: the install denials (the owner's, Task 0).
- `docs/Status.md`: the server, the first-deploy checklist, the banked items, D41 and D42.

### What branch 4 does not build

- No deploy, no `cdk bootstrap`, no AWS command (R13). No beta key and no spending stop (D42 Q10).
- No Bedrock call, no Soniox key, no feedback, no totals: no feature at all.
- The model's instructions and the lens files (D41; R7; banked item 12), and their import kinds (Status, Road ahead).
- No change to the guards. G0 to G9 already know every new file kind (the investigation, §4), and the totals stay at
  192 guard tests and 68 mutations.

### The decisions, by number

| | Ruling | Where it lands |
|---|---|---|
| D41 | The brainstorm: infrastructure as code, tested, nothing deployed; minimal packages; the owner installs them; the instructions and lenses in a later branch | All tasks |
| D42 Q1 | Five devDependencies at exact versions, no runtime dependency: `typescript` 6.0.3, `@types/node` 24.19.2, `aws-cdk-lib` 2.275.0, `constructs` 10.8.1, `aws-cdk` 2.1147.0 | Tasks 1 to 3; `test/package.test.ts` |
| D42 Q2 | `check_all.sh` checks the Node major against `engines`, then `npm ci --offline --no-audit --no-fund`, `npm run check`, `npm test` | Task 7 |
| D42 Q3 | The CDK CLI's telemetry, notices and version reporting off in `cdk.json`, and `analyticsReporting: false` on the stack, with a test that catches re-enabling | Task 6; mutations S6, S11 |
| D42 Q4 | The HTTP API for this branch; the 30-second limit banked for the head and the Architecture worker | Task 6; Task 9 (banked item 44) |
| D42 Q5 | The module marker (`{"type":"module"}`) beside the compiled files, with its test | Tasks 4, 5; mutation S5 |
| D42 Q6 | Strict tsconfig without `exactOptionalPropertyTypes`; `skipLibCheck` false | Task 4 |
| D42 Q7 | arm64; CDK's default memory and timeout; JSON logs; application INFO; system WARN | Task 6; mutation S7 |
| D42 Q8 | A role that writes only to its own log group, no managed policy | Task 6; mutation S8 |
| D42 Q9 | The region a literal; the account never in the repository; the app refuses unless the resolved account equals the one passed as context | Task 6; mutations S9, S10 |
| D42 Q10 | Neither the beta key nor the spending stop here; both before the first deploy | Task 9 (the checklist) |
| D42 Q11 | The two `npm audit` findings recorded in Status.md; no downgrade | Task 2 (seen); Task 9 (banked item 45) |
| D42 Q12 | The first-deploy checklist in Status.md | Task 9 |
| D42 Q13 | `npm install`, `npm i`, `npm ci` without `--offline`, `npm update` and `npx npm` denied to Claude Code in the settings, as the owner's Task 0 | Task 0; Part 4, questions 1 and 2 |
| D42 Q14 | TypeScript 6.0.3 | Task 1 |
| D42 Q15 | Every request 404 with no body, and one logged code | Task 5; mutation S4 |
| D42 Q16 | Synth proven in-process only; the owner's `npx cdk synth` an optional checklist line | Task 6; Task 8; Task 9 |
| D43 Q1 | Every direct `npm ci` denied; `check_all.sh` runs the offline install | Task 0; Task 7 |
| D43 Q2 | The nine deny rules beyond D42 Q13's list | Task 0 |
| D43 Q3 | The server's mutation checks committed as a script run by hand, not called by `check_all.sh` | Task 6, step 5 |
| D43 Q4 | A different lockfile hash at Task 2 is not a stop by itself | Task 2 |
| D43 Q5 | `registry.npmjs.org` stays on the sandbox's network allowlist | Nothing changes |
| D43 Q6 | Task 8, the CLI's synth, is run once | Task 8 |
| D43 | Tasks 6 and 7 are reviewed by an Opus reviewer before the next task | Tasks 6, 7 |

### The files after this branch

~~~~
server/
  package.json          the five packages, exact; engines Node 24; three scripts
  package-lock.json     the owner's npm install (Task 2)
  .gitignore            node_modules/  dist/  cdk.out/  cdk.context.json
  tsconfig.json         strict, no emit: src, infra, test
  tsconfig.build.json   src only, into dist/src
  cdk.json              the app command and the three opt-outs
  src/handler.ts        404, no body, one code
  src/safe-log.ts       codes and numbers only (G5 exempts it)
  src/hosts.ts          no host yet (G9 exempts it)
  infra/dist.ts         clean dist/ before tsc; write the module marker after
  infra/account.ts      the deploy refusal
  infra/stack.ts        the stack
  infra/app.ts          the CDK app: one stack, SoulDreamsServer
  test/*.test.ts        package, safe-log, hosts, handler, dist, account, stack
tool/
  server_mutations.py   S1 to S13, run by hand (D43 Q3)
~~~~

The scripts: `npm run check` is `tsc -p tsconfig.json` (type check, no output). `npm run build` empties `dist/`,
compiles `src/` into `dist/src`, and writes the marker. `npm test` builds, then runs every `test/**/*.test.ts` with
`node --test`. Node 24 runs the `.ts` tests directly by type stripping, so the code is erasable TypeScript only
(`erasableSyntaxOnly`: no `enum`, namespace or parameter property).

### Test plan

| File | Tests | What they prove |
|---|---|---|
| `package.test.ts` | 3 | The five packages, exact, dev only, `private`, a module; `engines` and the running Node are 24; the lockfile holds the five, at those versions, and no package has an install script |
| `safe-log.test.ts` | 5 (+2 compile-time) | The events list; a code alone; a code and numbers; an unknown code and a non-finite number refused, nothing written. Two `@ts-expect-error` lines make `npm run check` fail if the logger ever takes a string |
| `hosts.test.ts` | 1 | One export, `HOSTS`, empty and frozen |
| `handler.test.ts` | 2 | 404 with no body and `notFound`; a failure gives 500 and `handlerFailed`, never the error's text |
| `dist.test.ts` | 3 | `dist/src` holds exactly the three compiled files and the marker; the marker's bytes; relative imports end `.js` |
| `account.test.ts` | 5 | `pickAccount` in every case; the app itself, run as a child process with invented accounts, refuses as the CLI would see it |
| `stack.test.ts` | 9 | Exactly 9 resource types; eu-north-1 and termination protection; Node 24 on arm64; logs 7 days, JSON, INFO, WARN; no environment or tracing; no access logs, CORS or authorizer; the role writes only to its log group; no version-reporting metadata, with the CLI's own context on; `cdk.json`'s three opt-outs |

**28 tests.** The mutation checks, in `tool/server_mutations.py` (D43 Q3), each in a copy of `server/` in the
temporary folder. Run by hand from the repository root, `python3 -I -B tool/server_mutations.py`; expected, thirteen
lines `S1 caught: …` to `S13 caught: …`, then `server mutations: 13 run, 13 caught`, exit 0:

| | Break | Must fail |
|---|---|---|
| S1 | drop the unknown-code check | an unknown code is refused |
| S2 | drop the finite check | a number that is not finite is refused |
| S3 | the logger takes `unknown[]` | `npm run check` (an unused `@ts-expect-error`) |
| S4 | the handler's catch answers 404 and logs nothing | a failure: 500 and a code, never its message |
| S5 | the build skips the marker | the marker makes the code a module |
| S6 | drop `analyticsReporting: false` | no version reporting |
| S7 | retention one month | logs: 7 days, JSON, application INFO, system WARN |
| S8 | the Lambda gets CDK's default role | the role writes to its own log group only |
| S9 | `pickAccount` accepts no account passed | none passed, or another: refused |
| S10 | the app ignores the resolved account | the app refuses a resolved account not passed |
| S11 | `"notices": true` | cdk.json switches off the three reports |
| S12 | `aws-cdk-lib` as a range | the five packages, exact, for development only |
| S13 | a second log group in the stack | these resources and no others |

And in Task 7, `check_all.sh` with `engines` set to Node 22 must end `FAILED: node-version`.

Every test value is invented: the accounts are `111111111111` and `222222222222`, the error text is "invented failure
text". No night, line or key appears in this plan (R1, R2, R5).

---

## Part 2 · Settings (the owner's, in Task 0)

`.claude/settings.json` is the owner's. D42 Q13 adds to `permissions.deny`, through the script in Task 0:

- `Bash(npm install*)`
- `Bash(npm i)`
- `Bash(npm i *)`
- `Bash(npm add*)`
- `Bash(npm ci)`
- `Bash(npm ci *)`
- `Bash(npm update*)`
- `Bash(npm up)`
- `Bash(npm up *)`
- `Bash(npm upgrade*)`
- `Bash(npm audit fix*)`
- `Bash(npm publish*)`
- `Bash(npm exec *)`
- `Bash(npx npm*)`
- `Bash(*node_modules/.bin/cdk*)`
- `Bash(*aws-cdk/bin/cdk*)`

Permission patterns match the start of a command, so "`npm ci` without `--offline`" cannot be written as a pattern:
the script denies every direct `npm ci`, and Claude Code runs `npm ci --offline` only inside `tool/check_all.sh`,
which writes the flag itself (D43 Q1). The rules beyond D42 Q13's list close the other spellings of an
install (`npm add`, `npm up`, `npm upgrade`), the investigation's Q13 lean (`npm audit fix`, `npm publish`), and the
two ways to start the CDK CLI that `Bash(npx cdk *)` misses (`npm exec`, the CLI's own path) (D43 Q2).

---

## Part 3 · The tasks

**Who runs what.** Tasks marked **[OWNER]** are the owner's pastes. Claude Code stops before each, gives the paste,
and waits for the output. Everything else is Claude Code's.

**How files are written.** Files under `server/`, and `tool/server_mutations.py`, go in through the Write tool,
whole, exactly as given. `tool/check_all.sh`
and `docs/Status.md` change through the Edit tool: an **Edit** block replaces its first fence with its second, and the
first must occur exactly once.

**Commits.** Each Claude Code task ends green with its own commit, through the hook (never `--no-verify`), staged by
path only (never `git add -A` or `git add .`). Every commit message ends with the line
`Co-Authored-By: <the model that wrote it> <noreply@anthropic.com>`. `git -C` is denied by the settings: commands
`cd` instead.

**Red, then green.** Each Claude Code task first writes its tests and runs them; the run must fail as stated. Then it
writes the code, and the run must pass with the stated count. Any other result stops the task (R14).

**The gate** at the end of every Claude Code task, from the repository root:

    python3 -I -B tool/checks/guards.py
    cd server && npm run check && npm test

Expected: `guards (tracked): all passed`; `npm run check` prints only its two header lines (`> check`,
`> tsc -p tsconfig.json`) and exits 0; `npm test` ends with the task's count and `ℹ fail 0`. The guard tests and
mutations (`run_tests.py`, `mutations.py`) run in Task 0 and in Task 7, through `check_all.sh`.

### Task 0 · [OWNER] The settings; then Claude Code's canary and baselines (D42 Q13)

1. Claude Code writes this script (not committed), then stops.

   **File `.scratch/scaffold-4/settings_task0.py`**

~~~~python
# scaffold-4-server, Task 0 (D42 Q13): adds the npm and CDK-path denials to
# .claude/settings.json, leaving every other line as it is. Run from the
# repository root. Prints how many were added (0 on a second run).
import json
import sys

PATH = '.claude/settings.json'
NEW = [
    'Bash(npm install*)',
    'Bash(npm i)',
    'Bash(npm i *)',
    'Bash(npm add*)',
    'Bash(npm ci)',
    'Bash(npm ci *)',
    'Bash(npm update*)',
    'Bash(npm up)',
    'Bash(npm up *)',
    'Bash(npm upgrade*)',
    'Bash(npm audit fix*)',
    'Bash(npm publish*)',
    'Bash(npm exec *)',
    'Bash(npx npm*)',
    'Bash(*node_modules/.bin/cdk*)',
    'Bash(*aws-cdk/bin/cdk*)',
]

with open(PATH, encoding='utf-8') as f:
    settings = json.load(f)
deny = settings['permissions']['deny']
added = [rule for rule in NEW if rule not in deny]
deny.extend(added)
with open(PATH, 'w', encoding='utf-8') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write('\n')
sys.stdout.write('settings: %d added\n' % len(added))
~~~~

2. **[OWNER]** Paste 1 — Terminal:

       cd ~/Developer/soul-dreams-app && python3 -I .scratch/scaffold-4/settings_task0.py && git diff --stat && git add .claude/settings.json && git commit -m "Settings: deny installs and the CDK CLI's other routes to Claude Code (D42 Q13)" && git show --stat HEAD

   Expected: `settings: 16 added`; `.claude/settings.json | 18 +++++++++++++++++-` (16 lines added, and the
   comma on the line before them); the commit through the hook (`guards (staged): all passed`). A different count
   stops the task: send the output. Then `/exit`, and reopen Claude Code with the opening command in
   `docs/workflow.md`.

3. **Canary.** Claude Code runs `npm i --dry-run` from the repository root. Expected: the permission system refuses
   it before it runs. If it runs, the task stops (report; nothing is installed by a dry run).

4. **Baselines.** From the repository root: `python3 -I -B tool/checks/tests/run_tests.py` ends `Ran 192 tests`, `OK`;
   `python3 -I -B tool/checks/tests/mutations.py` ends `mutations: 68 run, all caught`;
   `python3 -I -B tool/checks/guards.py` ends `guards (tracked): all passed`; `node --version` prints `v24.` and more.
   Any other result stops the branch.

### Task 1 · The package file, and the packages' test (D41; D42 Q1, Q14)

Write the three files below, then run, from `server/`:

    node --test test/package.test.ts

Expected (red): `ℹ tests 3`, `ℹ pass 2`, `ℹ fail 1`, the failing test `the lockfile holds them, with no install
script` (no lockfile yet). **No commit.** Stop for Task 2.

**New file `server/package.json`**

~~~~json
{
  "name": "souldreams-server",
  "private": true,
  "type": "module",
  "engines": {
    "node": ">=24 <25"
  },
  "scripts": {
    "check": "tsc -p tsconfig.json",
    "build": "node infra/dist.ts clean && tsc -p tsconfig.build.json && node infra/dist.ts mark",
    "test": "npm run build && node --test \"test/**/*.test.ts\""
  },
  "devDependencies": {
    "@types/node": "24.19.2",
    "aws-cdk": "2.1147.0",
    "aws-cdk-lib": "2.275.0",
    "constructs": "10.8.1",
    "typescript": "6.0.3"
  }
}
~~~~

**New file `server/.gitignore`**

~~~~
node_modules/
dist/
cdk.out/
cdk.context.json
~~~~

**New file `server/test/package.test.ts`**

~~~~ts
// The server's packages (D41; D42 Q1, Q14): the five named, at exact
// versions, for development only, none running a script when installed,
// on Node 24. The owner installs them (D41); the lockfile records it.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

type Json = Record<string, unknown>;

function read(name: string): Json {
  return JSON.parse(readFileSync(new URL(`../${name}`, import.meta.url), 'utf8')) as Json;
}

const PACKAGES = {
  '@types/node': '24.19.2',
  'aws-cdk': '2.1147.0',
  'aws-cdk-lib': '2.275.0',
  constructs: '10.8.1',
  typescript: '6.0.3',
};

test('the five packages, exact, for development only', () => {
  const pkg = read('package.json');
  assert.deepEqual(pkg['devDependencies'], PACKAGES);
  assert.equal(pkg['dependencies'], undefined);
  assert.equal(pkg['private'], true);
  assert.equal(pkg['type'], 'module');
});

test('Node 24, pinned and running', () => {
  assert.deepEqual(read('package.json')['engines'], { node: '>=24 <25' });
  assert.equal(process.versions.node.split('.')[0], '24');
});

test('the lockfile holds them, with no install script', () => {
  const packages = read('package-lock.json')['packages'] as Record<string, Json>;
  assert.deepEqual(packages['']?.['devDependencies'], PACKAGES);
  assert.equal(packages['']?.['dependencies'], undefined);
  for (const [name, version] of Object.entries(PACKAGES)) {
    assert.equal(packages[`node_modules/${name}`]?.['version'], version, name);
  }
  const scripts = Object.keys(packages).filter((k) => packages[k]?.['hasInstallScript'] === true);
  assert.deepEqual(scripts, []);
});
~~~~

### Task 2 · [OWNER] The install (D41)

Paste 2 — Terminal:

    cd ~/Developer/soul-dreams-app/server && npm install --no-audit --no-fund && shasum -a 256 package-lock.json && npm ls --depth=0; npm audit; cd .. && git status --short

Expected:
- `added 9 packages` (the five, and four that `aws-cdk-lib` and `@types/node` bring).
- The lockfile's sha256. The proof's was `9b74f3c0367e8d392846303251712f6b27a9903832127cf17a1aeb69077abc01`. A different hash is not a stop by itself: npm may
  resolve a newer version within a range one of the five declares. Task 3's test and `npm ls` decide (D43 Q4).
- `npm ls`: exactly `@types/node@24.19.2`, `aws-cdk-lib@2.275.0`, `aws-cdk@2.1147.0`, `constructs@10.8.1`,
  `typescript@6.0.3`.
- `npm audit`: `2 moderate severity vulnerabilities`, both through `minimatch` inside `aws-cdk-lib`
  (GHSA-g3hv-75wg-m249). Do **not** run `npm audit fix` (D42 Q11). Any other finding stops the branch: send it.
- `git status --short`: `?? server/` and nothing else.

**Send back** the whole output.

### Task 3 · The lockfile, proven and committed

From `server/`: `node --test test/package.test.ts` ends `ℹ tests 3`, `ℹ pass 3`, `ℹ fail 0`; `npm ls --depth=0`
shows the five as in Task 2. Then, from the repository root:

    git add server/package.json server/package-lock.json server/.gitignore server/test/package.test.ts
    git status --short

Expected: exactly those four, `A`. Commit: "Server: the five packages and their lockfile (D41; D42 Q1, Q14)". The
hook ends `guards (staged): all passed`.

### Task 4 · The tsconfigs, the build, the safe logger and the hosts file (D42 Q5, Q6; banked item 2)

1. Write `tsconfig.json`, `tsconfig.build.json`, `infra/dist.ts`, `test/safe-log.test.ts` and `test/hosts.test.ts`.
   From `server/`, run `node --test test/safe-log.test.ts test/hosts.test.ts`. Expected (red): `ℹ tests 2`,
   `ℹ pass 0`, `ℹ fail 2`, each `ERR_MODULE_NOT_FOUND` for `src/safe-log.ts` and `src/hosts.ts`.
2. Write `src/safe-log.ts` and `src/hosts.ts`. The gate: `npm test` ends `ℹ tests 9`, `ℹ pass 9`, `ℹ fail 0`, and
   `dist/src` holds `hosts.js`, `package.json` and `safe-log.js`.
3. Stage the seven files by path; commit: "Server: tsconfig, the build, the safe logger and the hosts file (D42 Q5,
   Q6; banked item 2)".

**New file `server/tsconfig.json`**

~~~~json
{
  "compilerOptions": {
    "target": "ES2024",
    "lib": ["ES2024"],
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "types": ["node"],
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "verbatimModuleSyntax": true,
    "isolatedModules": true,
    "erasableSyntaxOnly": true,
    "allowImportingTsExtensions": true,
    "rewriteRelativeImportExtensions": true,
    "forceConsistentCasingInFileNames": true,
    "skipLibCheck": false,
    "noEmit": true
  },
  "include": ["src", "infra", "test"]
}
~~~~

**New file `server/tsconfig.build.json`**

~~~~json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "noEmit": false,
    "rootDir": "src",
    "outDir": "dist/src"
  },
  "include": ["src"]
}
~~~~

**New file `server/infra/dist.ts`**

~~~~ts
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
~~~~

**New file `server/test/safe-log.test.ts`**

~~~~ts
// The server's safe logger (CLAUDE.md R3, G5): an event code and
// numbers, never a string.
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import { LOG_EVENTS, type LogEvent, safeLog, setSink } from '../src/safe-log.ts';

let lines: string[] = [];
let restore = (): void => {};
beforeEach(() => {
  lines = [];
  restore = setSink((line) => {
    lines.push(line);
  });
});
afterEach(() => {
  restore();
});

test('the events are these', () => {
  assert.deepEqual(LOG_EVENTS, ['notFound', 'handlerFailed']);
});

test('a code alone', () => {
  safeLog('notFound');
  assert.deepEqual(lines, ['notFound']);
});

test('a code and numbers', () => {
  safeLog('handlerFailed', [3, 0.5, -1]);
  assert.deepEqual(lines, ['handlerFailed 3 0.5 -1']);
});

test('an unknown code is refused', () => {
  assert.throws(() => safeLog(('other' as string) as LogEvent), { message: 'safe-log-code' });
  assert.deepEqual(lines, []);
});

test('a number that is not finite is refused', () => {
  for (const n of [Number.NaN, Number.POSITIVE_INFINITY]) {
    assert.throws(() => safeLog('notFound', [n]), { message: 'safe-log-number' });
  }
  assert.deepEqual(lines, []);
});

// Never called: `npm run check` fails if either line stops being an
// error, that is if the logger ever takes a string (R3).
export function neverCalled(): void {
  // @ts-expect-error a string is never a log number
  safeLog('notFound', ['x']);
  // @ts-expect-error a code is one of LOG_EVENTS
  safeLog('x');
}
~~~~

**New file `server/test/hosts.test.ts`**

~~~~ts
// Every host the server talks to lives in src/hosts.ts (R10, G9).
import assert from 'node:assert/strict';
import { test } from 'node:test';
import * as hosts from '../src/hosts.ts';

test('no host yet', () => {
  assert.deepEqual(Object.keys(hosts), ['HOSTS']);
  assert.deepEqual(hosts.HOSTS, []);
  assert.ok(Object.isFrozen(hosts.HOSTS));
});
~~~~

**New file `server/src/safe-log.ts`**

~~~~ts
// The server's only logger (CLAUDE.md R3; G5 exempts this file). It
// takes an event code and numbers, never a string: nothing from a night
// can reach a log. Lambda sends each line to CloudWatch, kept 7 days.

/** Every event the server may log. A new event is a new value here. */
export const LOG_EVENTS = ['notFound', 'handlerFailed'] as const;
export type LogEvent = (typeof LOG_EVENTS)[number];

type Sink = (line: string) => void;

const toConsole: Sink = (line) => {
  console.info(line);
};
let sink: Sink = toConsole;

/** For tests: where lines go. Returns a function that restores it. */
export function setSink(next: Sink): () => void {
  sink = next;
  return () => {
    sink = toConsole;
  };
}

export function safeLog(code: LogEvent, numbers: readonly number[] = []): void {
  if (!(LOG_EVENTS as readonly string[]).includes(code)) {
    throw new TypeError('safe-log-code');
  }
  for (const n of numbers) {
    if (typeof n !== 'number' || !Number.isFinite(n)) {
      throw new TypeError('safe-log-number');
    }
  }
  sink([code, ...numbers.map(String)].join(' '));
}
~~~~

**New file `server/src/hosts.ts`**

~~~~ts
// Every host the server talks to lives here, and nowhere else
// (CLAUDE.md R10, G9). None yet: Bedrock is reached through the AWS SDK
// by Region, and Soniox's key endpoint arrives with the branch that
// uses it.
export const HOSTS: readonly string[] = Object.freeze([]);
~~~~

### Task 5 · The handler (D42 Q5, Q15)

1. Write `test/handler.test.ts` and `test/dist.test.ts`. From `server/`, `npm test`. Expected (red): `ℹ tests 13`,
   `ℹ pass 10`, `ℹ fail 3`: `test/handler.test.ts` (it cannot import the handler), `the compiled files and the
   marker, nothing else` and `imports end in .js`.
2. Write `src/handler.ts`. The gate: `npm test` ends `ℹ tests 14`, `ℹ pass 14`, `ℹ fail 0`.
3. Stage the three files by path; commit: "Server: the handler, 404 with no body and one code (D42 Q5, Q15)".

**New file `server/test/handler.test.ts`**

~~~~ts
// The handler (D42 Q15): 404 with no body and one logged code; on a
// failure, 500 and a code, never the error's message (R3).
import assert from 'node:assert/strict';
import { afterEach, beforeEach, test } from 'node:test';
import { handler } from '../src/handler.ts';
import { setSink } from '../src/safe-log.ts';

let lines: string[] = [];
let restore = (): void => {};
beforeEach(() => {
  lines = [];
});
afterEach(() => {
  restore();
});

test('every request: 404, no body, one code', async () => {
  restore = setSink((line) => {
    lines.push(line);
  });
  assert.deepEqual(await handler(), { statusCode: 404 });
  assert.deepEqual(lines, ['notFound']);
});

test('a failure: 500 and a code, never its message', async () => {
  let first = true;
  restore = setSink((line) => {
    if (first) {
      first = false;
      throw new Error('invented failure text');
    }
    lines.push(line);
  });
  assert.deepEqual(await handler(), { statusCode: 500 });
  assert.deepEqual(lines, ['handlerFailed']);
});
~~~~

**New file `server/test/dist.test.ts`**

~~~~ts
// The Lambda's code folder (D42 Q5): the compiled code alone, with the
// module marker beside it. `npm test` builds it first.
import assert from 'node:assert/strict';
import { readdirSync, readFileSync } from 'node:fs';
import { test } from 'node:test';

const CODE = new URL('../dist/src/', import.meta.url);

test('the compiled files and the marker, nothing else', () => {
  const files = readdirSync(CODE, { recursive: true }).map(String).sort();
  assert.deepEqual(files, ['handler.js', 'hosts.js', 'package.json', 'safe-log.js']);
});

test('the marker makes the code a module', () => {
  assert.equal(readFileSync(new URL('package.json', CODE), 'utf8'), '{"type":"module"}\n');
});

test('imports end in .js', () => {
  assert.match(readFileSync(new URL('handler.js', CODE), 'utf8'), /from "\.\/safe-log\.js";/);
});
~~~~

**New file `server/src/handler.ts`**

~~~~ts
// The server's one entry point, behind the HTTP API (D42 Q4). No feature
// yet: every request is answered 404 with no body, and one code is
// logged (D42 Q15). It never reads the event, which carries the
// caller's network address, and never logs an error's message (R3).
import { safeLog } from './safe-log.ts';

export interface Reply {
  readonly statusCode: number;
}

export async function handler(): Promise<Reply> {
  try {
    safeLog('notFound');
    return { statusCode: 404 };
  } catch {
    safeLog('handlerFailed');
    return { statusCode: 500 };
  }
}
~~~~

### Task 6 · The stack, the account refusal and the template tests (D42 Q3, Q4, Q7 to Q9, Q16; D43 Q3) · **Opus review**

1. Write `test/account.test.ts` and `test/stack.test.ts`. From `server/`, `npm test`. Expected (red): `ℹ tests 16`,
   `ℹ pass 14`, `ℹ fail 2`: the files `test/account.test.ts` and `test/stack.test.ts` (they cannot import `infra/`).
2. Write `cdk.json`, `infra/account.ts`, `infra/stack.ts` and `infra/app.ts`. The gate: `npm run check` clean;
   `npm test` ends `ℹ tests 28`, `ℹ pass 28`, `ℹ fail 0`.
3. Nothing outside `server/` changed: from the repository root, `git status --short` lists only the six new files
   (`??`), and `git status --short --ignored server` adds only `server/dist/` and `server/node_modules/` (`!!`).
   The in-process synth writes its staging to the temporary folder, never into the repository.
4. Stage the six files by path; commit: "Server: the CDK stack, its account refusal and its template tests (D42 Q3,
   Q4, Q7 to Q9, Q16)".
5. **Mutation checks (D43 Q3).** Write `tool/server_mutations.py` (below) and run, from the repository root:

       python3 -I -B tool/server_mutations.py; echo "exit=$?"

   Expected: thirteen lines `S1 caught: an unknown code is refused` to `S13 caught: these resources and no others`,
   then `server mutations: 13 run, 13 caught` and `exit=0`. Each row works on a copy of `server/` in the temporary
   folder, with `node_modules` linked, never on the repository; `git status --short` then lists only
   `?? tool/server_mutations.py`. A `missed` or `not-applied` line stops the task. The gate's guards line, then stage
   that one file and commit: "Server: the mutation checks, run by hand (D43 Q3)".
6. **Opus review (D43).** An Opus reviewer reads this task's two commits against this plan and `CLAUDE.md` (the
   stack, its template tests, the account refusal and the mutation runner) and gives a verdict. Claude Code waits for
   it before Task 7. Findings go to the Build chat; nothing is changed on a finding without a ruling (D17).

**New file `server/test/account.test.ts`**

~~~~ts
// The deploy refusal (D42 Q9), in the function and in the app itself.
// The two accounts are invented.
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { tmpdir } from 'node:os';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { pickAccount } from '../infra/account.ts';

const A = '111111111111';
const B = '222222222222';

test('no credentials and none passed: no account', () => {
  assert.equal(pickAccount(undefined, undefined), undefined);
  assert.equal(pickAccount(undefined, ''), undefined);
});

test('the account passed is the one resolved', () => {
  assert.equal(pickAccount(A, A), A);
  assert.equal(pickAccount(111111111111, A), A);
});

test('none passed, or another: refused', () => {
  assert.throws(() => pickAccount(undefined, A), { message: 'account-mismatch' });
  assert.throws(() => pickAccount(B, A), { message: 'account-mismatch' });
});

test('one passed with no credentials: refused', () => {
  assert.throws(() => pickAccount(A, undefined), { message: 'account-unresolved' });
});

const APP = fileURLToPath(new URL('../infra/app.ts', import.meta.url));

// Runs the app as the CLI would, with only these variables (and PATH and
// the temporary folder, where the CDK stages its files). Returns the
// refusal's code, 'ok' when it ran, or 'other'.
function app(env: Record<string, string>): string {
  const base = { PATH: process.env['PATH'] ?? '', TMPDIR: tmpdir() };
  const run = spawnSync(process.execPath, [APP], { env: { ...base, ...env }, encoding: 'utf8' });
  if (run.status === 0) {
    return 'ok';
  }
  return /Error: (account-[a-z]+)/.exec(run.stderr)?.[1] ?? 'other';
}

test('the app refuses a resolved account not passed', () => {
  const context = (account: string): string => JSON.stringify({ account });
  assert.equal(app({}), 'ok');
  assert.equal(app({ CDK_DEFAULT_ACCOUNT: A }), 'account-mismatch');
  assert.equal(app({ CDK_DEFAULT_ACCOUNT: A, CDK_CONTEXT_JSON: context(A) }), 'ok');
  assert.equal(app({ CDK_DEFAULT_ACCOUNT: A, CDK_CONTEXT_JSON: context(B) }), 'account-mismatch');
  assert.equal(app({ CDK_CONTEXT_JSON: context(A) }), 'account-unresolved');
});
~~~~

**New file `server/test/stack.test.ts`**

~~~~ts
// The template (D41, D42), synthesized in-process: no AWS credentials, no
// CLI and no network. The App carries the CLI's own context, version
// reporting on, so the stack's opt-out is what keeps the metadata out.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { App } from 'aws-cdk-lib';
import { Match, Template } from 'aws-cdk-lib/assertions';
import { ServerStack } from '../infra/stack.ts';

const app = new App({ context: { 'aws:cdk:version-reporting': true } });
const stack = new ServerStack(app, 'Test', {
  account: undefined,
  codeDir: fileURLToPath(new URL('../dist/src/', import.meta.url)),
});
const template = Template.fromStack(stack);

type Resource = { Type: string; Properties?: Record<string, unknown> };
const resources = Object.values(template.toJSON()['Resources'] as Record<string, Resource>);

function only(type: string): Resource {
  const found = resources.filter((r) => r.Type === type);
  assert.equal(found.length, 1, type);
  return found[0] as Resource;
}

test('these resources and no others', () => {
  assert.deepEqual(resources.map((r) => r.Type).sort(), [
    'AWS::ApiGatewayV2::Api',
    'AWS::ApiGatewayV2::Integration',
    'AWS::ApiGatewayV2::Route',
    'AWS::ApiGatewayV2::Stage',
    'AWS::IAM::Policy',
    'AWS::IAM::Role',
    'AWS::Lambda::Function',
    'AWS::Lambda::Permission',
    'AWS::Logs::LogGroup',
  ]);
});

test('eu-north-1, termination protection on', () => {
  assert.equal(stack.region, 'eu-north-1');
  assert.equal(stack.terminationProtection, true);
});

test('Node 24 on arm64, its own handler', () => {
  template.hasResourceProperties('AWS::Lambda::Function', {
    Runtime: 'nodejs24.x',
    Architectures: ['arm64'],
    Handler: 'handler.handler',
  });
});

test('logs: 7 days, JSON, application INFO, system WARN', () => {
  template.hasResourceProperties('AWS::Logs::LogGroup', { RetentionInDays: 7 });
  template.hasResourceProperties('AWS::Lambda::Function', {
    LoggingConfig: {
      LogFormat: 'JSON',
      ApplicationLogLevel: 'INFO',
      SystemLogLevel: 'WARN',
      LogGroup: Match.anyValue(),
    },
  });
});

test('no environment, no tracing', () => {
  const props = only('AWS::Lambda::Function').Properties ?? {};
  assert.equal(props['Environment'], undefined);
  assert.equal(props['TracingConfig'], undefined);
});

test('no access logs, no CORS, no authorizer', () => {
  assert.equal(only('AWS::ApiGatewayV2::Stage').Properties?.['AccessLogSettings'], undefined);
  assert.equal(only('AWS::ApiGatewayV2::Api').Properties?.['CorsConfiguration'], undefined);
  assert.equal(only('AWS::ApiGatewayV2::Route').Properties?.['AuthorizerId'], undefined);
});

test('the role writes to its own log group only', () => {
  assert.equal(only('AWS::IAM::Role').Properties?.['ManagedPolicyArns'], undefined);
  template.hasResourceProperties('AWS::IAM::Policy', {
    PolicyDocument: {
      Statement: [
        {
          Action: ['logs:CreateLogStream', 'logs:PutLogEvents'],
          Effect: 'Allow',
          Resource: { 'Fn::GetAtt': [Match.stringLikeRegexp('^Logs'), 'Arn'] },
        },
      ],
    },
  });
});

test('no version reporting', () => {
  assert.equal(resources.filter((r) => r.Type === 'AWS::CDK::Metadata').length, 0);
});

test('cdk.json switches off the three reports', () => {
  const cdk = JSON.parse(readFileSync(new URL('../cdk.json', import.meta.url), 'utf8'));
  assert.equal(cdk.versionReporting, false);
  assert.equal(cdk.notices, false);
  assert.equal(cdk.context['cli-telemetry'], false);
  assert.equal(cdk.app, 'node infra/app.ts');
});
~~~~

**New file `server/cdk.json`**

~~~~json
{
  "app": "node infra/app.ts",
  "versionReporting": false,
  "notices": false,
  "context": {
    "cli-telemetry": false
  }
}
~~~~

**New file `server/infra/account.ts`**

~~~~ts
// The deploy refusal (D42 Q9). The account is never in the repository.
// With AWS credentials, the CDK CLI resolves an account; the app then
// refuses unless it equals the one the owner passes with
// `-c account=<id>`. With no credentials nothing can be deployed, and
// the stack is synthesized for no account.
export function pickAccount(passed: unknown, resolved: string | undefined): string | undefined {
  const wanted = typeof passed === 'number' ? String(passed) : passed;
  if (resolved === undefined || resolved === '') {
    if (wanted !== undefined) {
      throw new Error('account-unresolved');
    }
    return undefined;
  }
  if (wanted !== resolved) {
    throw new Error('account-mismatch');
  }
  return resolved;
}
~~~~

**New file `server/infra/stack.ts`**

~~~~ts
// The server's AWS infrastructure (D41, D42): one Lambda behind an HTTP
// API in eu-north-1, its logs kept 7 days, with no access logs, no
// tracing, no environment and no identifier. Nothing is deployed in
// branch 4; test/stack.test.ts proves the template.
import { RemovalPolicy, Stack } from 'aws-cdk-lib';
import { HttpApi } from 'aws-cdk-lib/aws-apigatewayv2';
import { HttpLambdaIntegration } from 'aws-cdk-lib/aws-apigatewayv2-integrations';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as logs from 'aws-cdk-lib/aws-logs';
import type { Construct } from 'constructs';

export const REGION = 'eu-north-1';

export interface ServerStackProps {
  /** The workload account, or none (infra/account.ts). */
  readonly account: string | undefined;
  /** The compiled code, dist/src. */
  readonly codeDir: string;
}

export class ServerStack extends Stack {
  constructor(scope: Construct, id: string, props: ServerStackProps) {
    super(scope, id, {
      env: { account: props.account, region: REGION },
      analyticsReporting: false,
      terminationProtection: true,
    });
    const logGroup = new logs.LogGroup(this, 'Logs', {
      retention: logs.RetentionDays.ONE_WEEK,
      removalPolicy: RemovalPolicy.DESTROY,
    });
    // Only its own log group: no managed policy, which could create a
    // default log group kept for ever (D42 Q8).
    const role = new iam.Role(this, 'Role', {
      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),
    });
    logGroup.grantWrite(role);
    const fn = new lambda.Function(this, 'Handler', {
      runtime: lambda.Runtime.NODEJS_24_X,
      architecture: lambda.Architecture.ARM_64,
      code: lambda.Code.fromAsset(props.codeDir),
      handler: 'handler.handler',
      role,
      logGroup,
      loggingFormat: lambda.LoggingFormat.JSON,
      applicationLogLevelV2: lambda.ApplicationLogLevel.INFO,
      systemLogLevelV2: lambda.SystemLogLevel.WARN,
    });
    new HttpApi(this, 'Api', {
      defaultIntegration: new HttpLambdaIntegration('Handler', fn),
    });
  }
}
~~~~

**New file `server/infra/app.ts`**

~~~~ts
// The CDK app, run by cdk.json. `npm run build` first: the stack takes
// its code from dist/src.
import { fileURLToPath } from 'node:url';
import { App } from 'aws-cdk-lib';
import { pickAccount } from './account.ts';
import { ServerStack } from './stack.ts';

const app = new App();
new ServerStack(app, 'SoulDreamsServer', {
  account: pickAccount(app.node.tryGetContext('account'), process.env['CDK_DEFAULT_ACCOUNT']),
  codeDir: fileURLToPath(new URL('../dist/src/', import.meta.url)),
});
~~~~

**New file `tool/server_mutations.py`**

~~~~python
# The server's mutation checks (D43 Q3), run by hand from the repository
# root: python3 -I -B tool/server_mutations.py
# Each row breaks one thing in a copy of server/ in the temporary folder
# (node_modules linked, never the repository), runs the type check or the
# tests there, and the named test must fail. check_all.sh does not call
# it. It reports row codes and test names only, through the checks' own
# writer. Exit 0 when every row is caught, 1 otherwise.
import os
import shutil
import subprocess
import sys
import tempfile

TOOL = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(TOOL, 'checks'))

from guardlib import report  # noqa: E402

SERVER = os.path.join(os.path.dirname(TOOL), 'server')

# (code, file, old, new, 'check' or 'test', the test that must fail)
ROWS = [
    ('S1', 'src/safe-log.ts',
     "    throw new TypeError('safe-log-code');\n", '',
     'test', 'an unknown code is refused'),
    ('S2', 'src/safe-log.ts', '!Number.isFinite(n)', 'Number.isNaN(n)',
     'test', 'a number that is not finite is refused'),
    ('S3', 'src/safe-log.ts', 'numbers: readonly number[] = []',
     'numbers: readonly unknown[] = []', 'check', 'test/safe-log.test.ts'),
    ('S4', 'src/handler.ts', "    safeLog('handlerFailed');\n    return { statusCode: 500 };",
     '    return { statusCode: 404 };',
     'test', 'a failure: 500 and a code, never its message'),
    ('S5', 'package.json', ' && node infra/dist.ts mark', '',
     'test', 'the marker makes the code a module'),
    ('S6', 'infra/stack.ts', '      analyticsReporting: false,\n', '',
     'test', 'no version reporting'),
    ('S7', 'infra/stack.ts', 'RetentionDays.ONE_WEEK', 'RetentionDays.ONE_MONTH',
     'test', 'logs: 7 days, JSON, application INFO, system WARN'),
    ('S8', 'infra/stack.ts', '      role,\n', '',
     'test', 'the role writes to its own log group only'),
    ('S9', 'infra/account.ts', '  if (wanted !== resolved) {',
     '  if (wanted !== resolved && wanted !== undefined) {',
     'test', 'none passed, or another: refused'),
    ('S10', 'infra/app.ts', "process.env['CDK_DEFAULT_ACCOUNT']", 'undefined',
     'test', 'the app refuses a resolved account not passed'),
    ('S11', 'cdk.json', '"notices": false', '"notices": true',
     'test', 'cdk.json switches off the three reports'),
    ('S12', 'package.json', '"aws-cdk-lib": "2.275.0"', '"aws-cdk-lib": "^2.275.0"',
     'test', 'the five packages, exact, for development only'),
    ('S13', 'infra/stack.ts', "    new HttpApi(this, 'Api', {",
     "    new logs.LogGroup(this, 'Extra');\n    new HttpApi(this, 'Api', {",
     'test', 'these resources and no others'),
]


def failed_names(output):
    # The names node:test marks as failed, and the files tsc names.
    names = set()
    for line in output.splitlines():
        if line.startswith('✖ '):
            names.add(line[2:].rsplit(' (', 1)[0])
        elif ': error TS' in line:
            names.add(line.split('(', 1)[0])
    return names


def run_row(code, path, old, new, what, name):
    copy = tempfile.mkdtemp(prefix='server-mutation-')
    try:
        shutil.copytree(SERVER, copy, dirs_exist_ok=True,
                        ignore=shutil.ignore_patterns('node_modules', 'dist', 'cdk.out'))
        os.symlink(os.path.join(SERVER, 'node_modules'), os.path.join(copy, 'node_modules'))
        target = os.path.join(copy, path)
        with open(target, encoding='utf-8') as f:
            text = f.read()
        if text.count(old) != 1:
            return 'not-applied'
        with open(target, 'w', encoding='utf-8') as f:
            f.write(text.replace(old, new))
        cmd = ['npm', 'run', 'check'] if what == 'check' else ['npm', 'test']
        r = subprocess.run(cmd, cwd=copy, capture_output=True, text=True)
        caught = r.returncode != 0 and name in failed_names(r.stdout + r.stderr)
        return 'caught' if caught else 'missed'
    finally:
        shutil.rmtree(copy, ignore_errors=True)


def main():
    if not os.path.isdir(os.path.join(SERVER, 'node_modules')):
        report('server mutations: no server/node_modules (the owner installs them)')
        return 2
    caught = 0
    for row in ROWS:
        result = run_row(*row)
        caught += result == 'caught'
        report('%s %s: %s' % (row[0], result, row[5]))
    report('server mutations: %d run, %d caught' % (len(ROWS), caught))
    return 0 if caught == len(ROWS) else 1


if __name__ == '__main__':
    sys.exit(main())
~~~~

### Task 7 · `check_all.sh`: the pinned Node, then the locked packages offline (D42 Q2; D43 Q1) · **Opus review**

1. **Edit `tool/check_all.sh`**

~~~~sh
if [ -d server ]; then
  (cd server && npm run check && npm test) || fail server
else
~~~~

~~~~sh
if [ -d server ]; then
  # The pinned Node first (package.json "engines"), then the locked
  # packages (offline: nothing is fetched), the type check and the tests
  # (D42 Q2).
  want=$(sed -n 's/.*"node": *">=\([0-9]*\) .*/\1/p' server/package.json)
  have=$(node --version 2>/dev/null | sed -n 's/^v\([0-9]*\)\..*/\1/p')
  echo "node: pinned ${want:-none}, running ${have:-none}"
  if [ -z "$want" ] || [ "$want" != "$have" ]; then
    fail node-version
  else
    (cd server && npm ci --offline --no-audit --no-fund \
      && npm run check && npm test) || fail server
  fi
else
~~~~

2. From the repository root, `sh tool/check_all.sh`. Expected, among its lines: `guards (tracked): all passed`;
   `Ran 192 tests`, `OK`; `mutations: 68 run, all caught`; `flutter: pinned 3.47.9, running 3.47.9`;
   `No issues found!`; `All tests passed!` (14); `node: pinned 24, running 24`; `added 9 packages`; `ℹ tests 28`,
   `ℹ fail 0`; last line `check_all: all passed`. (Claude Code may run `check_all.sh` from branch 3 on, D33.)
3. **The Node check can fail.** Run:

       sed -i '' 's/">=24 <25"/">=22 <23"/' server/package.json && sh tool/check_all.sh | grep -E '^(node:|FAILED|check_all)'; git checkout -- server/package.json && git status --short

   Expected: `node: pinned 22, running 24`, `FAILED: node-version`, `check_all: FAILED: node-version`; then
   `git status --short` lists only ` M tool/check_all.sh`.
4. Stage `tool/check_all.sh`; commit: "check_all: the pinned Node, then the server's locked packages offline (D42 Q2)".
5. **Opus review (D43).** As in Task 6, step 6, on this commit. Claude Code waits for the verdict before Task 8.

### Task 8 · [OWNER] The CLI's own synth, once (D42 Q16; D43 Q6)

The template is proven in Task 6; this is a single look at the CLI itself, with no AWS credentials at all. The CLI
cannot run in Claude Code's sandbox (the settings deny it, and its hosts are not on the network allowlist).

Paste 3 — Terminal:

    cd ~/Developer/soul-dreams-app/server && npm run build && env -u AWS_PROFILE AWS_CONFIG_FILE=/dev/null AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_EC2_METADATA_DISABLED=true npx cdk synth --quiet && grep -o '"Type": "[^"]*"' cdk.out/SoulDreamsServer.template.json | sort -u; cd .. && git status --short

Expected (ASSUMED: not provable in the sandbox): no notice and no telemetry message; exactly the nine types of
`these resources and no others` and no `AWS::CDK::Metadata`; `git status --short` prints nothing (`cdk.out/` is
ignored). **Send back** the output. A tenth type, or an error, stops the branch.

### Task 9 · Docs (D41, D42)

Edit `docs/Status.md` with the blocks below, in order. In the first, `DATE` is the day of this commit
(`YYYY-MM-DD`). Then the gate's guards line, and commit: "Docs: branch 4 in Status.md: the server, the first-deploy
checklist, D41 and D42". `CLAUDE.md` and `docs/workflow.md` already name `npm run check` and `npm test`, and do not
change.

**Edit `docs/Status.md` (1 of 9)**

~~~~
Last updated: 2026-11-11, at the end of branch `scaffold-3-import`, by Claude Code.
~~~~

~~~~
Last updated: DATE, at the end of branch `scaffold-4-server`, by Claude Code.
~~~~

**Edit `docs/Status.md` (2 of 9)**

~~~~
`scaffold-3-import`: Scaffolding, branch 3 of 4. Plan: `docs/plans/scaffold-3-import.md`. Its Part 6 says where the
build differs from Parts 1 to 5 (the owner's rulings D33 to D40, below) and governs.
~~~~

~~~~
`scaffold-4-server`: Scaffolding, branch 4 of 4. Plan: `docs/plans/scaffold-4-server.md`.
~~~~

**Edit `docs/Status.md` (3 of 9)**

~~~~
- Branch 4, `scaffold-4-server`: the empty TypeScript server for Lambda, with its tests; nothing deployed.
~~~~

~~~~
- The first server feature, and before it the front door (banked item 44); then the first deploy, after "Before
  the first deploy" below.
~~~~

**Edit `docs/Status.md` (4 of 9)**

~~~~
## The guards
~~~~

~~~~
## The server

- Node 24, pinned by `engines` in `server/package.json`; `check_all.sh` checks the running major. TypeScript, strict
  (`server/tsconfig.json`; no `exactOptionalPropertyTypes`, D42 Q6). Five packages, for development only, at exact
  versions: `typescript` 6.0.3, `@types/node` 24.19.2, `aws-cdk-lib` 2.275.0, `constructs` 10.8.1, `aws-cdk`
  2.1147.0 (D42 Q1, Q14). The owner installs them; Claude Code's settings deny every install, and it runs `npm ci
  --offline` only through `check_all.sh` (D42 Q13).
- `server/src/`: the handler (every request 404 with no body, one logged code; D42 Q15), `safe-log.ts` (codes and
  numbers only) and `hosts.ts` (no host yet). `server/infra/`: the CDK app, its account refusal and the stack.
  `npm run build` writes `dist/src` with the module marker beside the compiled files (D42 Q5).
- The stack: one Lambda (`nodejs24.x`, arm64, CDK's default memory and timeout) behind an HTTP API in eu-north-1;
  logs kept 7 days, JSON, application INFO, system WARN; a role that writes only to its own log group; no access
  logs, tracing, environment, CORS or authorizer; termination protection on (D42 Q4, Q7 to Q9). The CDK CLI's
  telemetry, notices and version reporting are off (D42 Q3). **Nothing is deployed.**
- `npm test` proves the template in-process, with no AWS credentials, CLI or network (D42 Q16). The account is never
  in the repository: with credentials, the app refuses unless the resolved account equals `-c account=<id>` (D42 Q9).
- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 28 tests, and
  13 mutation checks (S1 to S13) in `tool/server_mutations.py`, run by hand from the repository root with
  `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 13 run, 13 caught`); `check_all.sh` does not
  call it (D43 Q3).

## Before the first deploy

The owner's, in this order (D42 Q10, Q12, Q16):

1. The front door is settled (banked item 44).
2. The beta key (48 characters, D18) and the spending stop are built, in a branch of their own.
3. The workload account is bootstrapped for the CDK in eu-north-1 (never the management account; C4-T item 15).
4. In the workload account: Bedrock model invocation logging is off, and the retention mode is `none` under the
   service control policy (technical-answers b).
5. The deploy runs from the workload account's profile with `-c account=<workload id>`; the app refuses any other.
6. After one request: CloudWatch holds codes and numbers only; no `/aws/lambda/...` log group exists; the stage has
   no access logs (technical-answers e and p, "[ASSUMED until built and shown]").
7. Optional: `npx cdk synth`, its resource types compared with `server/test/stack.test.ts`.

## The guards
~~~~

**Edit `docs/Status.md` (5 of 9)**

~~~~
- `check_all.sh` also checks that the Flutter running is the one pinned, then runs `pub get` offline against the
  lockfile, the analyzer and the app's tests.
~~~~

~~~~
- `check_all.sh` also checks that the Flutter running is the one pinned, then runs `pub get` offline against the
  lockfile, the analyzer and the app's tests; and that the Node running is the major pinned, then runs `npm ci`
  offline against the server's lockfile, `npm run check` and `npm test` (D42 Q2).
~~~~

**Edit `docs/Status.md` (6 of 9)**

~~~~
2. The server's safe logger (`server/src/safe-log.ts`) and hosts file (`server/src/hosts.ts`) arrive with branch 4.
   The app's exist since branch 2.
~~~~

~~~~
2. CLOSED in branch 4: the server's safe logger (`server/src/safe-log.ts`) and hosts file (`server/src/hosts.ts`).
~~~~

**Edit `docs/Status.md` (7 of 9)**

~~~~
3. The server's analyzer baseline is saved by branch 4. The app's is above.
~~~~

~~~~
3. CLOSED in branch 4: the server's analyzer baseline is in "The server", above.
~~~~

**Edit `docs/Status.md` (8 of 9)**

~~~~
## Rulings during branch 2
~~~~

~~~~
Banked in branch 4:

44. D42 Q4: the 30-second limit goes to the head and the Architecture worker before the first server feature (front
    door for the reading call).
45. D42 Q11: `npm audit` reports 2 moderate findings, in the `minimatch` that `aws-cdk-lib` bundles
    (GHSA-g3hv-75wg-m249). It runs at build time on the Mac and is not in the Lambda's code. No downgrade (the fix
    offered is `aws-cdk-lib` 2.239.0); recheck at each dependency change, never `npm audit fix --force`.
46. `tool/server_mutations.py` is run by hand, not by `check_all.sh` (D43 Q3): a server change that weakens a test
    is caught only when someone runs it. It takes about 20 seconds.
47. The account refusal assumes the CDK CLI sets `CDK_DEFAULT_ACCOUNT` whenever credentials resolve; shown at the
    first deploy (step 5 above).
48. System logs at WARN leave out Lambda's START, END and REPORT lines; if their counts are wanted, the level is INFO
    (D42 Q7).

## Rulings during branch 2
~~~~

**Edit `docs/Status.md` (9 of 9)**

~~~~
## Documents as last imported
~~~~

~~~~
## Rulings during branch 4

- D41: the brainstorm that opened the branch: infrastructure as code, tested, nothing deployed; minimal packages; the owner installs them; the model's instructions and the lens files in a later branch.
- D42: answers Q1 to Q16 of the investigation, every lean accepted: the five packages at exact versions; `check_all.sh` pins Node and installs offline; the CDK CLI's three reports off, with a test; the HTTP API kept, its 30-second limit banked (item 44); the module marker; no `exactOptionalPropertyTypes`; arm64, JSON logs, application INFO, system WARN; the scoped log policy; region literal, no account in the repository, the deploy refusal; no beta key or spending stop before the first deploy's branch; the audit findings banked (item 45); the first-deploy checklist; installs denied to Claude Code in the settings; TypeScript 6.0.3; 404 with no body; synth proven in-process only.
- D43: answers the plan's Part 4: every direct `npm ci` denied, `check_all.sh` installs offline; the nine extra deny rules; the server's mutation checks committed as `tool/server_mutations.py`, run by hand; a different lockfile hash is not a stop by itself; `registry.npmjs.org` stays on the allowlist; Task 8 run once. Tasks 6 and 7 reviewed by Opus.

## Documents as last imported
~~~~

---

## Part 4 · Open questions (numbered; a blank is not a yes)

**All six answered by D43** (2026-11-11): 1 yes; 2 yes; 3 the mutation checks committed as a script run by hand, not
called by `check_all.sh` (amended: `tool/server_mutations.py`, Task 6 step 5); 4 yes; 5 yes; 6 yes, Task 8 is run
once. The questions as asked:

1. **Every direct `npm ci` is denied, not only those without `--offline`** (Part 2). Permission patterns match a
   command's start, so the ruling's wording cannot be written as one. *Lean:* deny all; Claude Code reaches
   `npm ci --offline` only through `check_all.sh`, which fixes the flag. *If not:* deny only the bare `npm ci`, and an
   online `npm ci --no-audit` stays open to Claude Code.
2. **Nine more rules than D42 Q13 names** (Part 2): `npm add`, `npm up` (two rules), `npm upgrade`, `npm audit fix`,
   `npm publish`, `npm exec`, and the CDK CLI's two paths under `node_modules`. *Lean:* yes; they are other spellings of
   an install, the investigation's Q13 lean, and routes past `Bash(npx cdk *)`. *If not:* the script's `NEW` list
   loses them, and Task 0's count changes from 16.
3. **The server's mutation checks are a scratch script, not committed** (banked item 46). *Lean:* yes for this branch;
   the guards' `mutations.py` is for the guards. *If a committed runner is wanted:* a small task adds it under
   `tool/checks/` (it would run `npm test` thirteen times, about 20 seconds) and `check_all.sh` calls it.
4. **A different lockfile hash at Task 2 is not a stop** if `npm ls` and Task 3's test pass. *Lean:* yes; npm may
   resolve a newer version within a range that `aws-cdk-lib`'s own dependencies declare. *If not:* any difference
   stops the branch until the Build chat compares the two lockfiles.
5. **`registry.npmjs.org` stays on the sandbox's network allowlist.** *Lean:* yes; Claude Code still runs `npm view`
   and `npm audit`, and the denials keep installs the owner's. *If removed:* nothing in this plan changes; later
   checks of a version or an advisory become the owner's.
6. **Task 8, the CLI's synth, is optional.** *Lean:* run it once, with no credentials, as a look at the CLI's
   behaviour before the first deploy. *If skipped:* the checklist's step 7 stays for the first deploy.

---

## Part 5 · How this plan was proven

On 2026-11-11, before this file was committed:

1. **Built in a scratch worktree**, `./.scratch/build4`, detached at `2a5e9fb`. Every file in Part 3 is the file that
   was built and committed there; the plan's blocks are generated from those files and compared back, byte for byte.
2. **The owner's install (Task 2) was simulated.** D42 makes `npm install` the owner's, so the proof used the
   lockfile from the investigation's prototype. Its root entry (name, the five exact versions, `engines`) equals
   this plan's `package.json`, checked field by field. It was installed with `npm ci --offline` from the local
   cache: `added 9 packages`. Its sha256 is `9b74f3c0367e8d392846303251712f6b27a9903832127cf17a1aeb69077abc01`. `npm ls --depth=0` showed the five at their versions.
3. **Each task, in order, through the pre-commit hook** (`guards (staged): all passed` each time):
   - Task 1 (red): `ℹ tests 3`, `ℹ pass 2`, `ℹ fail 1`.
   - Task 3: `ℹ tests 3`, `ℹ pass 3`; commit `f7529a1`.
   - Task 4: red `ℹ tests 2`, `ℹ fail 2` (`ERR_MODULE_NOT_FOUND`); `npm run check` clean; `ℹ tests 9`,
     `ℹ pass 9`; commit `513d44c`.
   - Task 5: red `ℹ tests 13`, `ℹ pass 10`, `ℹ fail 3`, the three named; `ℹ tests 14`, `ℹ pass 14`; commit
     `f37d99b`.
   - Task 6: red `ℹ tests 16`, `ℹ pass 14`, `ℹ fail 2`; `npm run check` clean; `ℹ tests 28`, `ℹ pass 28`; commit
     `5ab11ff`; the scratch mutation script (since replaced, step 8 below) `13 run, 13 caught`; only `server/dist/`
     and `server/node_modules/` ignored.
   - Task 7: `check_all.sh` ended `check_all: all passed`, with `Ran 192 tests` `OK`, `mutations: 68 run, all
     caught`, `flutter: pinned 3.47.9, running 3.47.9`, `No issues found!`, the app's 14 tests, `node: pinned 24,
     running 24`, `added 9 packages`, `ℹ tests 28`, `ℹ fail 0`. With `engines` at 22: `FAILED: node-version`.
     Commit `e86b489`.
   - Task 9: all nine Status.md blocks applied, each old text found once; guards all passed; commit `a6066eb`.
4. **Task 0's script** ran on a copy of `.claude/settings.json`: `settings: 16 added`, then `settings: 0 added` on a
   second run. The diff held the 16 lines and the comma before them, nothing else; the file is otherwise
   byte-identical after `json.dump` (checked on the real file, read only).
5. **Found by the proof and fixed in the plan:**
   - The app's child process could not stage its asset: the sandbox refuses `/tmp`, so `account.test.ts` passes
     `TMPDIR` through. Its check is now the refusal's code (`account-mismatch`, `account-unresolved`), not only a
     non-zero exit, so a crash for another reason cannot pass it.
   - `git -C` is denied by the settings; every command in Part 3 uses `cd` instead.
6. **Not provable in the sandbox, and so the owner's:** the settings change and its canary (Task 0); the real
   install, its lockfile hash and `npm audit` (Task 2); the CLI's synth (Task 8); everything at deploy (the
   checklist in Task 9).
7. The scratch worktree is removed after the proof (`git worktree remove --force .scratch/build4`); its commits
   were on a detached HEAD and reach no branch.
8. **The D43 amendment, proven the same way** in a fresh worktree, `./.scratch/build4b`, detached at `89f946e`:
   Tasks 3 to 6 replayed through the hook (`ℹ tests 3`, `9`, `14`, `28`, each `ℹ fail 0`); `tool/server_mutations.py`
   committed through the hook and run **from its committed location**: `S1 caught` to `S13 caught`,
   `server mutations: 13 run, 13 caught`. A row that changes nothing the tests see was reported
   `missed`, `server mutations: 1 run, 0 caught`, exit 1, so the runner can fail. S13 adds a second log group (the
   first draft's second Lambda was a literal of twelve words or more, which G4 refuses). Task 7's `check_all.sh`
   ended `check_all: all passed` (`node: pinned 24, running 24`); Task 9's nine `Status.md` blocks (now with D43)
   applied, each found once; guards all passed. The worktree was then removed.
