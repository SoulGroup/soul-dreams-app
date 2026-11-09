# Plan: scaffold-1-guards (Scaffolding, branch 1 of 4)

*No matter where you are on your journey, the steps you take are equally important.*

Spec and plan in one file, as `docs/workflow.md` step 5 allows for a small task. Written by Claude Code (Opus) on
2026-11-07, after the read-only investigation and the owner's rulings D1 to D14. **Nothing here is implemented yet.**
The owner answered every question in Part 4 on 2026-11-07, and the plan was amended to match the answers (Part 5).
After the review of Task 2, the owner's ruling D16 added Task 2a, the lexer and library fixes (Part 5, second
amendment). After the review of Task 2a, the owner's ruling D17 added Task 2b, which makes the guards fail closed on
what they don't understand (Part 5, third amendment). The owner's rulings of 2026-11-07 on that amendment's questions,
and on the Cohort 0 app, the distress check and Help, changed Tasks 2a (prose only), 2b (prose only), 14 and 15 (Part 5,
fourth amendment). The owner's ruling that crisis material, the crisis check and the Help page are scrapped
indefinitely, filed upstream (C147-I, C15-P), changed Tasks 14 and 15 (Part 5, fifth amendment). After the review of Task 2b, the owner's ruling of 2026-11-07 added
Task 2c, which makes G0 refuse undecodable text and reads a Swift `/` after `try` as a possible regex, and banked the
review's other findings in Task 15 (Part 5, sixth amendment). After the review of Task 2c, the owner's ruling of
2026-11-09 added Task 2d, which makes G0 know code and config only when they decode, sharpens one of Task 2c's
controls, and lists every place a guard can read nothing (Part 5, seventh amendment).

---

## Part 1 · Spec

### What branch 1 builds

The standing guards G1 to G9 from `CLAUDE.md` and G0 file kinds (D17), the tests that prove each one refuses what it
should and passes what it should, a mutation check for every guard, the pre-commit hook, `tool/check_all.sh`, and
`docs/Status.md`.

- **Language (D6):** POSIX shell for the two entry points (`.githooks/pre-commit`, `tool/check_all.sh`). Python 3
  standard library for the checks, always run as `python3 -I -B`. `-I` isolates Python from the environment and the
  user's packages. `-B` stops it writing `__pycache__` into the repository (Q8). `check_all.sh` prints the Python
  path and version it ran with. Nothing is installed and no dependency is added.
- **Layout:**
  - `tool/checks/guards.py` runs the guards.
  - `tool/checks/g0_kinds.py` to `g9_hosts.py` hold one guard each.
  - `tool/checks/lex.py` holds the lexers. They find string literals and comments in Dart, TypeScript or
    JavaScript, Swift, Python and shell.
  - `tool/checks/guardlib.py` decides which files are read and what kind each one is.
  - `tool/checks/awaiting-import` is the marker from D5.
  - The guard tests are in `tool/checks/tests/`, with `mutations.py`.
- **What each run reads:**
  - The hook reads the **index**, the snapshot the commit will record.
  - `check_all.sh` reads the **tracked files**.
  - The tests build throwaway trees in `$TMPDIR`.
- **Output never quotes a file (R3 in spirit).** A finding is printed as `G5 app/lib/a.dart:12 writer-print`: the
  guard, the path, the line and a reason code. An internal error prints only the exception's type. Exit codes: 0 all
  passed, 1 findings, 2 internal error.
- **Files the guards cannot read fail closed.** A code file that cannot be lexed is a finding (`unlexable`).
  Binary files are skipped. Files with secret names, in any case, are never opened. A tracked path that is not
  valid UTF-8 is the finding `bad-path` (D16). A file of a kind the guards do not know is refused by G0 as
  `unknown-kind` (D17), and so is a Markdown, CSV or other listed unscanned file that is not UTF-8 text (Task 2c), and
  a code or config file that is not UTF-8 text (Task 2d).
- **Forbidden tokens in the guards' own source** are built from pieces (`'client_' + 'reference_id'`). This lets the
  guards scan themselves with no exclusion. Test controls are built the same way, at run time.
- **Mutation checks never touch the repository.** `mutations.py` copies `tool/checks` to `$TMPDIR` and runs the named
  tests on the unbroken copy, where they must pass. It then breaks the copy and runs them again, and they must fail.
  `check_all.sh` runs all 25 mutations every time.

### What branch 1 does not build

- `app/`, `server/` and their analyzers. `check_all.sh` already runs them once they exist, and says `SKIPPED` until
  then.
- The import script, the words generator, `lines.g.dart`, `docs/source/` or `fixtures/invented-nights.json`.
- **G1 and G2 stay NOT ARMED (D5).** When armed, G1 checks the hashes. It then refuses with `generator-not-built`
  until branch 3 replaces that one line with the generator comparison.
- No safe loggers yet. G5 only names their paths (D13).
- No new dependency, app or server.

### The decisions, by number

| | Ruling | Where it lands |
|---|---|---|
| D1 | Status.md is created by this branch's final docs task | Task 15 |
| D2 | Prove the sandbox read block with the owner's canary at `~/.soul-dreams/__canary`, read through a shell variable. Report the exact result. The owner deletes the canary afterwards | Task 0, proof S1 |
| D3 | The owner runs `chmod +x` and `git config core.hooksPath .githooks`. `check_all.sh` fails loudly if the hooks path is not `.githooks` | Task 12 (the check), Task 13 (the owner's paste) |
| D4 | The owner's commit `e98039f` closes the settings gaps. Prove its new rules too | Task 0, proofs S10 to S16 |
| D5 | The `tool/checks/awaiting-import` marker: G1 and G2 print NOT ARMED while it exists, and refuse it beside `docs/source/SOURCES` | Task 3 |
| D6 | POSIX shell and `python3 -I`, standard library only. Print the Python version | All tasks, Task 12 |
| D7 | G8 allows imports within `app/lib/founder/**` and from `app/test/founder/**` | Task 9 |
| D8 | G3 to G6, G8 and G9 scan code (`.dart .ts .js .py .sh`, and extensionless shell or Python scripts by their `#!` line) and config (`pubspec.yaml`, `package.json`, `.plist .entitlements .pbxproj .xcconfig .xcscheme`). They skip Markdown, `docs/` and lockfiles. G7 scans every tracked text file | `guardlib.Source.kind` |
| D9 | G7 exempts only `docs/source/SOURCES` and integrity fields in lockfiles | Task 8 |
| D10 | G3: a literal passed to `Text`, `TextSpan`, `semanticsLabel`, `semanticLabel`, `tooltip`, `label`, `title` or `hintText` outside `app/lib/words/` is refused. App only | Task 4 |
| D11 | G9 adds `ws://`. The server's hosts live in `server/src/hosts.ts`. The CLAUDE.md line is proposed below, and the owner approves it at the prompt | Task 10, Task 14 |
| D12 | G5 adds `stdout.write`, `stderr.write`, `process.stdout.write` and `FlutterError.dumpErrorToConsole`. `Math.log(` is allowed | Task 6 |
| D13 | The safe loggers are `app/lib/core/safe_log.dart` and `server/src/safe-log.ts` | Task 6 |
| D14 | Installing or pinning Flutter stays the owner's | Nothing here touches FVM |
| D16 | After the review of Task 2: the lexer and library fixes F1 to F11, with mutations for F1, F2, F3 and F6. It amends D8's reading: `.mjs .cjs .tsx .jsx .swift`, every `.json .yaml .yml` but lockfiles, and code under `docs/` are scanned; only Markdown and lockfiles are not | Task 2a; Tasks 4, 8, 11, 15 |
| D17 | "Guards catch mistakes, not deliberate evasion; the sandbox and settings are the hard boundary (Task 0). From Task 3 on, a reviewer finding that ordinary code would slip through, or that the plan contradicts itself, stops the build. A finding that needs a deliberately constructed input to evade a guard is banked in Status.md, and the build continues." With it, after the review of Task 2a: G0 file kinds (R1); `.tsx` and `.jsx` out of TypeScript (R2); a Swift `/` where a regex could start (R3) and a heredoc word starting with a digit (R4) unlexable; F10's prose corrected (R5); mutations for R1 and R3 | Task 2b; Tasks 11, 12, 14, 15 |
| 2b review | The owner's ruling of 2026-11-07 on the review of Task 2b: `.md`, `.csv` and every listed name or path are known to G0 only as UTF-8 text with no NUL byte (C1); in Swift, `try` joins the words after which a `/` starts a regex (C2); a mutation for C1; K1 to K4 and the reviewer's named notes banked | Task 2c; Tasks 11, 12, 15 |
| 2c review | The owner's ruling of 2026-11-09 on the review of Task 2c: config is known to G0 only when `src.text()` reads it (D1), with a mutation; `test_division_near_try_still_lexes` compares TypeScript's code whole, with a mutation dropping the Swift-only condition (D2); every place a guard can read nothing listed, and each that reads nothing for a file G0 accepts fixed (D3) | Task 2d; Tasks 11, 12, 15 |

### How each guard reads its rule

Where this reading goes beyond the words of `CLAUDE.md`, Part 4 asks about it.

- **G0 file kinds (D17).** It runs first. Every file must be code, config, or an unscanned kind listed in
  `g0_kinds.py`: Markdown and CSV, `.gitignore`, lockfiles, `docs/source/SOURCES`, the marker, and binary files (a
  NUL byte). The listed kinds are known only when they read as UTF-8 text with no NUL byte (Task 2c), and so are
  code and config (Task 2d). Anything else
  is refused as `unknown-kind`, and so is an extensionless file whose `#!` names an
  interpreter the guards don't know. A later branch that brings a new kind extends the lists, and the owner approves
  the change at the prompt.
- **G1 words.** When the marker exists without `SOURCES`, G1 prints NOT ARMED. The marker beside `SOURCES` is
  refused. With no marker:
  - `SOURCES` must exist.
  - `places-register.csv` and `founder-lists-for-technology.md` must each be listed, present and match their hashes.
  - Then `generator-not-built`, until branch 3.
- **G2 copies.** When the marker exists, any file under `docs/source/` is refused, which is stricter than D5 (Q5).
  With no marker:
  - `SOURCES` must exist and parse.
  - Every listed file under `docs/source/` must exist and match its hash.
  - Every file under `docs/source/` must be listed.
  - A listed path outside `docs/source/` is refused unless it is one of the two words files.
- **G3 no literal words.** It scans `app/lib/**/*.dart` outside `app/lib/words/` (Q2).
  - **Dreamer-facing literals are refused.** A literal is dreamer-facing when it sits *directly* in the arguments of
    `Text`, `Text.rich` or `TextSpan`, or is the value of one of D10's named arguments. The marker does not excuse it.
  - **Any other literal of three or more words needs the marker.** The marker is a comment
    `// not-dreamer-facing: <reason>`, with a non-empty reason, on a line the literal occupies.
  - **Counting words:** whitespace-separated, with `\n` and `\t` counted as spaces.
- **G4 invented only.** It refuses any literal of 12 or more words in a code file. Config strings are read as in
  Q4. Exempt: `fixtures/invented-nights.json` and `app/lib/words/`.
- **G5 logging.** These writers are refused in code with its strings and comments removed, and in config:
  - `print(`, `debugPrint(` and `log(`, each as a whole name, so `showDialog(` and `catalog(` pass (Q6);
  - `console.`, `stdout.write`, `stderr.write` (which covers `process.stdout.write` and `writeln`) and
    `FlutterError.dumpErrorToConsole`.

  Whitespace before `(` or around `.` does not hide a writer. `Math.log(` passes. Exempt: the two safe loggers, and
  the checks' own writer `tool/checks/guardlib.py` (Q1).
- **G6 identifiers.** It refuses the four names in code and config, ignoring case, `_` and `-`, so `clientReferenceId`
  and `device_info_plus` are refused too (Q6).
- **G7 secrets.** It refuses a file named `.env` or `.env.*`, or ending `.p8`, `.pem`, `.p12` or `.mobileprovision`,
  anywhere, in any case (D16). In every text file, Markdown included, it refuses:
  - AWS access keys;
  - PEM blocks of any kind;
  - `sk-` or `sk_` tokens, GitHub, Slack and Google key shapes, and JWTs;
  - a key, secret, token or password name assigned a value of 16 or more characters with letters and digits;
  - any run of 32 or more key characters that mixes upper case, lower case and digits, has high entropy and is not
    pure hex. Pure hex is left alone so that Status.md can hold hashes.
- **G8 export.** It refuses any Dart `import`, `export` or `part` directive whose URI resolves into
  `app/lib/founder/`, conditional URIs included. The URI may be `package:<any>/founder/…` or relative. Allowed: D7's
  four places.
- **G9 hosts.** It refuses `http`, `https`, `ws` and `wss` followed by `://`, in any case:
  - in code with its comments removed (strings and code both, so an unquoted address in a shell script is caught);
  - in config, except XML `<!DOCTYPE` lines.

  Exempt: `app/lib/core/hosts.dart`, `server/src/hosts.ts`, and the test folders `app/test/`,
  `app/integration_test/`, `server/test/` and `tool/checks/tests/`.

### Test plan

| Guard | Refused (control) | Passed (clean case) | Mutation that must be caught |
|---|---|---|---|
| G0 | `.tsx`, `.jsx`, `.mts`, `.m`, `.h`, `.kt`, `.txt`, `Makefile`; a listed name at another path; an unknown `#!` interpreter, even on a listed path; text with no NUL byte. Task 2c: Markdown, CSV and each listed name or path in Latin-1, cp1252 or UTF-16, or with a NUL byte. Task 2d: a UTF-16 `package.json`, a Latin-1 `pubspec.yaml`, a binary `Info.plist`; Dart, TypeScript, Swift, Python and shell in Latin-1 or UTF-16, or with a NUL byte | each code kind and config; Markdown, CSV, `.gitignore`, `SOURCES`, the marker, lockfiles; a binary file. Task 2c: UTF-8 Markdown and CSV. Task 2d: UTF-8 `package.json`, `pubspec.yaml` and `Info.plist` | 21: every file is known. 23: a listed kind is known without being read. 24: code and config are known without being read |
| G1 | marker beside SOURCES; no marker and no SOURCES; register hash mismatch; register unlisted; armed without generator | marker alone (NOT ARMED) | 1: drop the marker-with-sources refusal. 2: compare the hash with itself |
| G2 | marker beside SOURCES or any copy; no SOURCES; hash mismatch; unlisted copy; listed but missing; malformed line; unknown path | marker alone; a matching copy | 3: skip the hash compare. 4: ignore copies under the marker |
| G3 | literal in `Text`, `Text.rich(TextSpan(text:))`, each named argument; a named argument in a bare parenthesis; `m.Text`; marked dreamer literal; 3 unmarked words; marker with no reason; marker on another line; unlexable file | `app/lib/words/`; two words; three marked words; `Text(lines['k'])`; files outside `app/lib/` | 5: three words become four. 6: stop exempting `words/`. 7: drop `tooltip` |
| G4 | 12 words in `.ts`, `.dart` (tests too), `.py`, `.sh`; in `package.json`, `Info.plist`, `pubspec.yaml` | 11 words; fixtures, `words/`, Markdown, comments | 8: limit 13 |
| G5 | each of the seven writers, in Dart, TypeScript and Python | the safe loggers; writers inside strings and comments; `showDialog(`, `catalog(`, `Math.log(` | 9: drop `console.`. 10: stop allowing `Math.log(` |
| G6 | each name in `.dart`, `.ts`, `pubspec.yaml`, `Info.plist`; `clientReferenceId`; `device_info_plus` | `device` and `info` apart | 11: misspell one name |
| G7 | each secret file name, in either case; each key shape in Markdown; an integrity line outside a lockfile; other lockfile lines | hex hashes; SOURCES; lockfile integrity; ordinary code; binary files | 12: drop the PEM rule. 13: exempt integrity lines everywhere |
| G8 | `main.dart`; another file, by package, relative, `export`, `part` and conditional URI | the four allowed places; look-alike names | 14: allow `main.dart` |
| G9 | each scheme in Dart, in any case; in TypeScript; unquoted in shell | both hosts files; test folders; comments; DOCTYPE | 15: exempt every path |
| Lexer | quotes, raw, triple, escapes, nested interpolation, nested comments, call frames and named arguments; TypeScript template and regex; Python f-strings; shell quotes, substitution and heredocs; unterminated input refused. Task 2a: `/` after `x++` and after `if (…)`; an unterminated regex; Python with no final newline; deep nesting; Swift strings, interpolation and nested comments; bare parentheses; shell arithmetic and hyphenated heredoc words. Task 2b: a Swift `/` where a regex could start; a heredoc word starting with a digit. Task 2c: a Swift regex after `try` | Task 2b: Swift division. Task 2c: Swift division after `try f(x)`, `retry` and `tryCount`; TypeScript's `try` unchanged, its code compared whole since Task 2d | 16: let a string run past its line. 17: `/` after `++` starts a regex. 18: `/` after `if (…)` divides. 19: an unterminated regex passes. 22: a Swift `/` never raises. 25: `try` starts a regex in TypeScript too |
| Library (Task 2a) | secret names in upper case; a lexer's `RecursionError`; a path that is not UTF-8 | file kinds by extension and shebang (`.tsx` and `.jsx` none since Task 2b); YAML block scalars and quoted `#` | 20: compare secret names case-sensitively |
| Hook | a staged writer; a bad file staged then fixed only in the working tree; a staged path that is not UTF-8 | a clean index; a good file staged then broken only in the working tree | (end-to-end tests) |

Totals once built: **108 tests and 25 mutations** (Task 2a added 18 tests and 4 mutations, Task 2b 7 tests and 2
mutations, Task 2c 4 tests and 1 mutation, Task 2d 3 tests and 2 mutations, and Tasks 4 and 11 three more tests). Every control is invented: placeholder words (`word word word`),
placeholder hosts (`x.example`) and key-shaped strings assembled at run time. No dream, night or dreamer line appears
anywhere (R1, R2).

---

## Part 2 · Settings proofs (Task 0, before any file is written)

Every probe is harmless if it is not refused. The probes use dry runs, the nonexistent ref `__canary`, `--help` or
`--version`, and invented canaries. Each result is reported exactly as printed: **PASS** means refused as expected,
**FAIL** means not refused. A FAIL stops the task (R14), and the owner decides.

| # | Rule | Probe | Expected |
|---|---|---|---|
| S1 | Sandbox read block on the home folders (**D2**) | `p="$HOME/.soul-dreams/__canary"; cat "$p"` | `Operation not permitted`. The word `canary` must not print. Report the exact output. The owner then deletes the canary |
| S2 | Read deny on the five home folders | The Read tool, then `cat` with the literal path, on `__canary_does_not_exist` in each of `~/Developer/soul-dreams-docs`, `~/Developer/soul-dreams`, `~/.soul-dreams`, `~/.aws`, `~/.ssh` | Refused by the permission system |
| S3 | Read deny on the secret file names | In `./.scratch/canary/` (gitignored, inside the repository; see Q10), write `.env`, `.env.local`, `k.p8`, `k.pem`, `k.p12` and `k.mobileprovision`, each holding `canary`. Read each with the Read tool, with literal `cat` and with variable `cat` | All three refused for each file. Then `rm -r .scratch/canary` |
| S4 | Edit deny on `/app/assets/words/**`, `/app/lib/words/**`, `/docs/source/**` | The Write tool on `__canary` in each | Refused |
| S5 | Sandbox `denyWrite` on the same three, plus `./fixtures`, `./.git/config`, `./.git/hooks` | `p=<dir>; mkdir -p "$p"` for the folders; `p=.git/hooks/__canary; touch "$p"`; `p=.git/config; touch "$p"` | `Operation not permitted` |
| S6 | `git push`, `git merge`, `git rebase`, `git branch -D` | `git push --dry-run origin __canary`; `git merge __canary`; `git rebase __canary`; `git branch -D __canary` | Refused |
| S7 | `git config` | `git config --get core.hooksPath` | Refused |
| S8 | `--no-verify` | `git commit --no-verify --dry-run` | Refused |
| S9 | `flutter run`, `flutter install`, `xcrun simctl`, `open -a Simulator`, `aws`, `cdk`, `npx cdk`, `curl`, `wget` | `flutter run --help`, `flutter install --help`, `xcrun simctl help`, `open -a Simulator`, `aws --version`, `cdk --version`, `npx cdk --version`, `curl --version`, `wget --version` | Refused |
| S10 | **D4** `fvm flutter run`, `fvm flutter install` | `fvm flutter run --help`; `fvm flutter install --help` | Refused |
| S11 | **D4** `fvm use`, `fvm install`, `fvm global` | each with `--help` | Refused |
| S12 | **D4** `git -c`, `git -C` | `git -c core.pager=cat status`; `git -C . status` | Refused |
| S13 | **D4** `git reset` (all forms) | `git reset __canary`; `git reset -q --hard __canary` | Refused |
| S14 | **D4** `git commit -n` (all forms) | `git commit -n --dry-run`; `git commit -nm x --dry-run` | Refused |
| S15 | **D4** `Edit(/.git/config)` | Read `.git/config`, then the Edit tool replacing `__canary_absent__` with `x` | Refused by permission. If it is not refused, it still fails with "string not found" and changes nothing |
| S16 | **D4** `Edit(/.git/hooks/**)` | The Write tool on `.git/hooks/__canary` holding `canary` | Refused. If it is written, it is inert (no hook has that name); FAIL, and the owner deletes it |
| S17 | `ask` on `/CLAUDE.md`, `/docs/workflow.md` | The Edit tool appending nothing-changing whitespace to each | A prompt appears; the owner **declines** |
| S18 | `sandbox.enabled`, `allowUnsandboxedCommands: false` | `echo "$SANDBOX_RUNTIME"`; `ps`; S5's `touch` retried with `dangerouslyDisableSandbox` | Set; `ps` refused; still `Operation not permitted` |
| S19 | `network.allowedDomains` | `python3 -I -c` with `urllib` HEAD requests to `pub.dev` and to `example.com` | `pub.dev` answers; `example.com` refused by the proxy |
| S20 | `ask` and `denyWrite` on the branch's own paths: `/.githooks/**`, `/tool/checks/**`, `/tool/check_all.sh` | Proven as the files land: every Write shows a prompt (the owner approves). In Task 13: `p=tool/checks/__canary; touch "$p"`, and the same for `.githooks/__canary` and `tool/check_all.sh` | Prompts shown; `Operation not permitted` |

Not repeated: the `allowWrite` proofs in `~/.pub-cache`, `~/fvm`, `~/.dartServer` and `~/.npm` from the
investigation's §5. They would write outside the repository, which D2 rules out (Q10).

---

## Part 3 · The tasks

**How files are written.** The sandbox refuses shell writes to `.githooks/`, `tool/checks/` and `tool/check_all.sh`.
Every file there goes in **through the Write tool**, and the owner approves it at the prompt, so the owner sees each
file before it lands. Other files may use the Write tool too.

**Commits.** Each task ends green with its own commit. Every commit message ends with the line
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, shown below as `<trailer>`.

**Executable bits.** Files written by the Write tool are not executable. For the two entry points the plan uses
`git update-index --chmod=+x`, which records the right mode in the commit without touching the protected file. The
owner's `chmod +x` in Task 13 makes the working tree match (Q8).

**Red, then green.** Each task first writes its test and runs it, and the run must fail as stated. Then it writes the
code and runs again, and the run must pass with the stated count. Any other result stops the task (R14).

### Task 0 · Settings proofs

Run S1 to S19 from Part 2 in order and report each exact result. Write nothing, commit nothing. S20 runs in Task 13.

### Task 1 · Ignore scratch space and Python caches

**File `.gitignore`**

~~~~text
.scratch/
__pycache__/
~~~~

Check: `mkdir -p .scratch && git check-ignore .scratch/x tool/__pycache__/x`. Expected: both paths printed.

    git add .gitignore && git commit -m "Ignore scratch worktrees and Python caches" -m "<trailer>"

### Task 2 · Lexers, shared library, test runner, mutation runner

**Red.** Write the runner, the helpers, the lexer tests and the mutation table:

**File `tool/checks/tests/run_tests.py`**

~~~~python
# Runs the guard tests: all of them, or the named ones
# (for example test_g3.G3.test_text_literal_refused).
import os
import sys
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))


def main(names):
    loader = unittest.TestLoader()
    if names:
        suite = loader.loadTestsFromNames(names)
    else:
        suite = loader.discover(HERE, pattern='test_*.py', top_level_dir=HERE)
    result = unittest.TextTestRunner(verbosity=1).run(suite)
    return 0 if result.wasSuccessful() else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
~~~~

**File `tool/checks/tests/helpers.py`**

~~~~python
# Test helpers: build a throwaway tree in $TMPDIR and run one guard on it.
import os
import shutil
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
CHECKS = os.path.dirname(HERE)
if CHECKS not in sys.path:
    sys.path.insert(0, CHECKS)

import guardlib  # noqa: E402


def make_tree(files):
    root = tempfile.mkdtemp(prefix='guards-')
    for path, body in files.items():
        full = os.path.join(root, path)
        os.makedirs(os.path.dirname(full), exist_ok=True)
        with open(full, 'wb') as f:
            f.write(body if isinstance(body, bytes) else body.encode('utf-8'))
    return root


def run(guard, files):
    root = make_tree(files)
    try:
        findings, notes = guard.check(guardlib.Source(root, 'walk'))
        return sorted(f.key() for f in findings), notes
    finally:
        shutil.rmtree(root)


def sentence(n):
    # n words, built at run time so no long literal sits in this source.
    return ' '.join(['word'] * n)


class GuardTest(unittest.TestCase):
    guard = None

    def refused(self, files, reason=None):
        findings, _ = run(self.guard, files)
        self.assertTrue(findings, 'expected a refusal')
        if reason:
            self.assertIn(reason, [f[2] for f in findings])
        return findings

    def passed(self, files):
        findings, notes = run(self.guard, files)
        self.assertEqual(findings, [])
        return notes
~~~~

**File `tool/checks/tests/test_lex.py`**

~~~~python
import unittest

import helpers  # noqa: F401
import lex


def texts(lx):
    return [l.text for l in lx.lits]


class Dart(unittest.TestCase):
    def test_quotes_raw_and_triple(self):
        lx = lex.lex_dart("a('x'); b(\"y\"); c(r'\\d'); d('''p\nq''');")
        self.assertEqual(texts(lx), ['x', 'y', '\\d', 'p\nq'])
        self.assertEqual(lx.lits[3].line, 1)
        self.assertEqual(lx.lits[3].end_line, 2)

    def test_escaped_quote(self):
        self.assertEqual(texts(lex.lex_dart("f('it\\'s');")), ["it\\'s"])

    def test_interpolation_keeps_code(self):
        lx = lex.lex_dart("f('a ${g('b')} c');")
        self.assertEqual(texts(lx), ["a ${g('b')} c", 'b'])
        self.assertIn('g(', lx.code)
        self.assertNotIn('a ', lx.code)

    def test_nested_block_comment(self):
        lx = lex.lex_dart("/* a /* b */ 'c' */ f('d');")
        self.assertEqual(texts(lx), ['d'])
        self.assertEqual(len(lx.comments), 1)

    def test_line_comment_is_not_code(self):
        lx = lex.lex_dart("x(); // p('q')\ny();")
        self.assertEqual(texts(lx), [])
        self.assertNotIn('p(', lx.code)
        self.assertEqual(lx.comments[0].line, 1)

    def test_frames_and_named(self):
        lx = lex.lex_dart("Text('a'); f(title: 'b'); "
                         "Text(m['k']); Text.rich(TextSpan(text: 'c'));")
        got = [(l.text, l.frame, l.named) for l in lx.lits]
        self.assertEqual(got, [('a', 'Text', ''), ('b', 'f', 'title'), ('k', '[', ''),
                               ('c', 'TextSpan', 'text')])

    def test_unterminated_raises(self):
        with self.assertRaises(lex.LexError):
            lex.lex_dart("f('a);\ng(1);'")


class TypeScript(unittest.TestCase):
    def test_template_and_interpolation(self):
        lx = lex.lex_ts("f(`a ${g('b')}`);")
        self.assertEqual(texts(lx), ["a ${g('b')}", 'b'])

    def test_regex_is_not_a_string(self):
        lx = lex.lex_ts("const r = /it's/g; f('x'); "
                       "const d = a / b / c;")
        self.assertEqual(texts(lx), ['x'])

    def test_block_comment(self):
        lx = lex.lex_ts("/* 'a' */ f('b');")
        self.assertEqual(texts(lx), ['b'])


class Python(unittest.TestCase):
    def test_strings_fstrings_comments(self):
        lx = lex.lex_python("a = 'x'\nb = f'y{a}z'  # c('d')\n"
                            "c = '''p\nq'''\n")
        self.assertEqual(texts(lx), ['x', 'y{a}z', 'p\nq'])
        self.assertEqual(len(lx.comments), 1)
        self.assertNotIn('c(', lx.code)


class Shell(unittest.TestCase):
    def test_quotes_comments_substitution(self):
        lx = lex.lex_shell("a='x y'\nb=\"p $(c 'q') r\" # s('t')\necho $#\n")
        self.assertEqual(texts(lx), ['x y', "p $(c 'q') r", 'q'])
        self.assertEqual(len(lx.comments), 1)
        self.assertIn('c ', lx.code)

    def test_heredoc_body_is_a_literal(self):
        lx = lex.lex_shell("cat <<'EOT'\none two\nEOT\necho done\n")
        self.assertEqual(texts(lx), ['one two\n'])
        self.assertIn('echo', lx.code)

    def test_unclosed_heredoc_raises(self):
        with self.assertRaises(lex.LexError):
            lex.lex_shell('cat <<EOT\nnever closed\n')


if __name__ == '__main__':
    unittest.main()
~~~~

**File `tool/checks/tests/mutations.py`**

~~~~python
# Mutation checks: each row breaks one guard in a copy of tool/checks
# in $TMPDIR, and the named tests must then fail. The named tests are
# first run on an unbroken copy and must pass. The repository itself
# is never changed. Arguments, if any, limit the run to those files
# (for example g3_literals.py).
import os
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
CHECKS = os.path.dirname(HERE)
sys.path.insert(0, CHECKS)

from guardlib import report  # noqa: E402

MUTATIONS = [
    ('g1_words.py', "if marker and src.has(SOURCES):", "if False:",
     ['test_g1_g2.G1.test_marker_with_sources_refuses']),
    ('g1_words.py', "!= entries[path][0]", "!= sha256(src.read(path))",
     ['test_g1_g2.G1.test_words_hash_mismatch_refuses']),
    ('g2_copies.py', "elif sha256(src.read(path)) != digest:", "elif False:",
     ['test_g1_g2.G2.test_hash_mismatch_refuses']),
    ('g2_copies.py', "if in_dir:", "if False:",
     ['test_g1_g2.G2.test_marker_with_sources_refuses']),
    ('g3_literals.py', "words(lit.text) > 2", "words(lit.text) > 3",
     ['test_g3.G3.test_three_words_unmarked_refused']),
    ('g3_literals.py', "and not path.startswith('app/lib/words/'))", ")",
     ['test_g3.G3.test_inside_words_passes']),
    ('g3_literals.py', "'tooltip', ", "",
     ['test_g3.G3.test_named_arguments_refused']),
    ('g4_invented.py', "LIMIT = 12", "LIMIT = 13",
     ['test_g4.G4.test_twelve_words_refused_in_each_language']),
    ('g5_logging.py', "('console', re.compile(B + r'console\\s*\\.')),", "",
     ['test_g5.G5.test_each_writer_refused']),
    ('g5_logging.py', "if name == 'log' and MATH", "if False and MATH",
     ['test_g5.G5.test_strings_comments_and_lookalikes_pass']),
    ('g6_identifiers.py', "'device' + '_info'", "'device' + '_infox'",
     ['test_g6.G6.test_each_name_refused_in_code_and_config']),
    ('g7_secrets.py', "('pem-block', re.compile(DASHES + r'BEGIN [A-Z0-9 ]+' + DASHES)),", "",
     ['test_g7.G7.test_key_shapes_refused_markdown_included']),
    ('g7_secrets.py', "if lock and 'integrity' in line:", "if 'integrity' in line:",
     ['test_g7.G7.test_integrity_outside_lockfile_refused']),
    ('g8_export.py', "ALLOWED = ('app/lib/main_founder.dart',",
     "ALLOWED = ('app/lib/main.dart', 'app/lib/main_founder.dart',",
     ['test_g8.G8.test_tester_main_refused']),
    ('g9_hosts.py', "or path.startswith(TESTS):", "or True:",
     ['test_g9.G9.test_each_scheme_refused']),
    ('lex.py', "if c == '\\n' and not multiline:\n                raise LexError('string')",
     "if c == '\\n' and not multiline:\n                pass",
     ['test_lex.Dart.test_unterminated_raises']),
]


def run_named(checks, tests):
    runner = os.path.join(checks, 'tests', 'run_tests.py')
    r = subprocess.run([sys.executable, '-I', '-B', runner] + tests, capture_output=True)
    return r.returncode


def main(only):
    bad = 0
    ran = 0
    for n, (name, old, new, tests) in enumerate(MUTATIONS, 1):
        if only and name not in only:
            continue
        ran += 1
        tmp = tempfile.mkdtemp(prefix='mutation-')
        try:
            copy = os.path.join(tmp, 'checks')
            shutil.copytree(CHECKS, copy, ignore=shutil.ignore_patterns('__pycache__'))
            path = os.path.join(copy, name)
            with open(path, encoding='utf-8') as f:
                text = f.read()
            if text.count(old) != 1:
                report('mutation %d %s: SETUP FAILED (pattern not found once)' % (n, name))
                bad += 1
                continue
            if run_named(copy, tests) != 0:
                report('mutation %d %s: SETUP FAILED (tests fail unbroken)' % (n, name))
                bad += 1
                continue
            with open(path, 'w', encoding='utf-8') as f:
                f.write(text.replace(old, new))
            if run_named(copy, tests) == 0:
                report('mutation %d %s: SURVIVED' % (n, name))
                bad += 1
            else:
                report('mutation %d %s: caught' % (n, name))
        finally:
            shutil.rmtree(tmp)
    if not ran:
        report('mutations: FAILED (none ran)')
        return 1
    report('mutations: %d run, %s' % (ran, 'FAILED' if bad else 'all caught'))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_lex`. Expected: exit 1, `ModuleNotFoundError: No module named
'guardlib'`.

**Green.** Write the lexers and the library:

**File `tool/checks/lex.py`**

~~~~python
# Small lexers for the guards: string literals, comments, and the code
# with both blanked out. Standard library only. Dart, TypeScript or
# JavaScript, Python and POSIX shell. Unclear input raises LexError,
# which the guards turn into a finding (they fail closed).
import bisect
import io
import tokenize


class LexError(Exception):
    pass


class Lit:
    # One string literal. text is the source between the quotes,
    # interpolations included. frame is the call (or bracket) it sits
    # directly inside; named is the named argument it is the value of.
    def __init__(self, text, pos, line, end_line, frame='', named=''):
        self.text = text
        self.pos = pos
        self.line = line
        self.end_line = end_line
        self.frame = frame
        self.named = named


class Comment:
    def __init__(self, text, start, end, line, end_line):
        self.text = text
        self.start = start
        self.end = end
        self.line = line
        self.end_line = end_line


class Lexed:
    def __init__(self, src, lits, comments, code):
        self.src = src
        self.lits = sorted(lits, key=lambda x: x.pos)
        self.comments = comments
        self.code = code  # strings and comments blanked

    def without_comments(self):
        out = list(self.src)
        for c in self.comments:
            _blank(out, c.start, c.end)
        return ''.join(out)


def _blank(out, a, b):
    for k in range(a, b):
        if out[k] != '\n':
            out[k] = ' '


class _Lines:
    def __init__(self, src):
        self.starts = [0]
        for i, ch in enumerate(src):
            if ch == '\n':
                self.starts.append(i + 1)

    def line(self, pos):
        return bisect.bisect_right(self.starts, pos)


IDENT_START = set('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$')
IDENT = IDENT_START | set('0123456789')
REGEX_KEYWORDS = {
    'return', 'typeof', 'instanceof', 'in', 'of', 'new', 'delete', 'void',
    'throw', 'case', 'do', 'else', 'yield', 'await',
}


class _CLike:
    # Dart (dart=True) or TypeScript and JavaScript (dart=False).
    def __init__(self, src, dart):
        self.s = src
        self.n = len(src)
        self.i = 0
        self.dart = dart
        self.out = list(src)
        self.lines = _Lines(src)
        self.lits = []
        self.comments = []
        self.frames = []
        self.prev = []
        self.chain = ''

    def run(self):
        self.code(False)
        return Lexed(self.s, self.lits, self.comments, ''.join(self.out))

    def push(self, kind, value):
        self.prev.append((kind, value))
        del self.prev[:-3]

    def comment(self, a, b):
        ln = self.lines.line
        self.comments.append(Comment(self.s[a:b], a, b, ln(a), ln(max(a, b - 1))))
        _blank(self.out, a, b)
        self.i = b

    def block_end(self, a):
        s = self.s
        if not self.dart:
            j = s.find('*/', a + 2)
            if j < 0:
                raise LexError('comment')
            return j + 2
        depth = 0
        j = a
        while j < self.n:
            if s.startswith('/*', j):
                depth += 1
                j += 2
            elif s.startswith('*/', j):
                depth -= 1
                j += 2
                if depth == 0:
                    return j
            else:
                j += 1
        raise LexError('comment')

    def regex_allowed(self):
        if not self.prev:
            return True
        kind, value = self.prev[-1]
        if kind == 'p':
            return value not in ')]'
        if kind == 'id':
            return value in REGEX_KEYWORDS
        return False

    def regex(self):
        s = self.s
        a = self.i
        j = a + 1
        in_class = False
        while j < self.n:
            c = s[j]
            if c == '\\':
                j += 2
                continue
            if c == '\n':
                raise LexError('regex')
            if c == '[':
                in_class = True
            elif c == ']':
                in_class = False
            elif c == '/' and not in_class:
                j += 1
                break
            j += 1
        while j < self.n and s[j] in IDENT:
            j += 1
        _blank(self.out, a, j)
        self.i = j
        self.push('re', '')

    def call_name(self):
        if self.prev and self.prev[-1][0] == 'id':
            return self.chain
        return '('

    def code(self, interp):
        s = self.s
        depth = 0
        while self.i < self.n:
            i = self.i
            c = s[i]
            if c in ' \t\r\n':
                self.i += 1
                continue
            if s.startswith('//', i):
                j = s.find('\n', i)
                self.comment(i, self.n if j < 0 else j)
                continue
            if s.startswith('/*', i):
                self.comment(i, self.block_end(i))
                continue
            if not self.dart and c == '/' and self.regex_allowed():
                self.regex()
                continue
            if c in '\'"' or (not self.dart and c == '`'):
                self.string(i, i, False)
                continue
            if (self.dart and c == 'r' and i + 1 < self.n and s[i + 1] in '\'"'
                    and (i == 0 or s[i - 1] not in IDENT)):
                self.string(i, i + 1, True)
                continue
            if c in IDENT_START:
                j = i
                while j < self.n and s[j] in IDENT:
                    j += 1
                word = s[i:j]
                if (len(self.prev) >= 2 and self.prev[-1] == ('p', '.')
                        and self.prev[-2][0] == 'id'):
                    self.chain = self.chain + '.' + word
                else:
                    self.chain = word
                self.push('id', word)
                self.i = j
                continue
            if c.isdigit():
                j = i
                while j < self.n and (s[j] in IDENT or s[j] == '.'):
                    j += 1
                self.push('num', s[i:j])
                self.i = j
                continue
            if c == '(':
                self.frames.append(self.call_name())
            elif c == '[':
                self.frames.append('[')
            elif c == '{':
                self.frames.append('{')
                depth += 1
            elif c in ')]':
                if self.frames:
                    self.frames.pop()
            elif c == '}':
                if interp and depth == 0:
                    self.i += 1
                    return
                depth -= 1
                if self.frames:
                    self.frames.pop()
            self.push('p', c)
            self.i += 1
        if interp:
            raise LexError('interpolation')

    def string(self, start, q_pos, raw):
        s = self.s
        q = s[q_pos]
        triple = self.dart and s.startswith(q * 3, q_pos)
        delim = q * 3 if triple else q
        multiline = triple or q == '`'
        frame = self.frames[-1] if self.frames else ''
        named = ''
        if (len(self.prev) >= 2 and self.prev[-1] == ('p', ':')
                and self.prev[-2][0] == 'id'):
            named = self.prev[-2][1]
        content = q_pos + len(delim)
        j = content
        mark = start
        end = None
        while j < self.n:
            if s.startswith(delim, j):
                end = j
                j += len(delim)
                break
            c = s[j]
            if c == '\n' and not multiline:
                raise LexError('string')
            if not raw and c == '\\':
                j += 2
                continue
            if not raw and c == '$' and j + 1 < self.n and s[j + 1] == '{':
                _blank(self.out, mark, j + 2)
                self.i = j + 2
                saved = self.prev
                self.prev = []
                self.frames.append('${')
                self.code(True)
                self.frames.pop()
                self.prev = saved
                j = self.i
                mark = j - 1
                continue
            j += 1
        if end is None:
            raise LexError('string')
        _blank(self.out, mark, j)
        ln = self.lines.line
        self.lits.append(Lit(s[content:end], start, ln(start), ln(end), frame, named))
        self.i = j
        self.push('s', '')


def lex_dart(src):
    return _CLike(src, True).run()


def lex_ts(src):
    return _CLike(src, False).run()


def _py_body(tok):
    k = 0
    while k < len(tok) and tok[k] not in '\'"':
        k += 1
    body = tok[k:]
    q = body[:3] if body[:3] in ('"""', "'''") else body[:1]
    return body[len(q):len(body) - len(q)]


def lex_python(src):
    lines = _Lines(src)
    out = list(src)
    lits = []
    comments = []
    open_strings = []

    def pos(rc):
        return lines.starts[rc[0] - 1] + rc[1]

    try:
        for tok in tokenize.generate_tokens(io.StringIO(src).readline):
            name = tokenize.tok_name[tok.type]
            a, b = pos(tok.start), pos(tok.end)
            if name == 'COMMENT':
                comments.append(Comment(tok.string, a, b, tok.start[0], tok.end[0]))
                _blank(out, a, b)
            elif name == 'STRING':
                lits.append(Lit(_py_body(tok.string), a, tok.start[0], tok.end[0]))
                _blank(out, a, b)
            elif name.endswith('STRING_START'):
                open_strings.append((a, tok.start[0]))
            elif name.endswith('STRING_END'):
                a0, l0 = open_strings.pop()
                lits.append(Lit(_py_body(src[a0:b]), a0, l0, tok.end[0]))
                _blank(out, a0, b)
            elif name == 'ERRORTOKEN' and tok.string.strip():
                raise LexError('python')
    except (tokenize.TokenError, SyntaxError, IndexError):
        raise LexError('python')
    return Lexed(src, lits, comments, ''.join(out))


class _Shell:
    def __init__(self, src):
        self.s = src
        self.n = len(src)
        self.i = 0
        self.out = list(src)
        self.lines = _Lines(src)
        self.lits = []
        self.comments = []
        self.heredocs = []

    def run(self):
        self.code(False)
        if self.heredocs:
            raise LexError('heredoc')
        return Lexed(self.s, self.lits, self.comments, ''.join(self.out))

    def lit(self, a, content, end):
        ln = self.lines.line
        self.lits.append(Lit(self.s[content:end], a, ln(a), ln(max(a, end))))

    def code(self, until_paren):
        s = self.s
        depth = 0
        while self.i < self.n:
            i = self.i
            c = s[i]
            if c == '\\':
                self.i += 2
                continue
            if c == '\n':
                self.i += 1
                if self.heredocs:
                    self.read_heredocs()
                continue
            if c == '#' and (i == 0 or s[i - 1] in ' \t\n;&|()'):
                j = s.find('\n', i)
                j = self.n if j < 0 else j
                ln = self.lines.line
                self.comments.append(Comment(s[i:j], i, j, ln(i), ln(i)))
                _blank(self.out, i, j)
                self.i = j
                continue
            if c == "'":
                j = s.find("'", i + 1)
                if j < 0:
                    raise LexError('quote')
                self.lit(i, i + 1, j)
                _blank(self.out, i, j + 1)
                self.i = j + 1
                continue
            if s.startswith("$'", i):
                self.double(i, i + 1, "'")
                continue
            if c == '"':
                self.double(i, i, '"')
                continue
            if s.startswith('<<', i) and not s.startswith('<<<', i):
                self.heredoc_start()
                continue
            if until_paren:
                if c == '(':
                    depth += 1
                elif c == ')':
                    if depth == 0:
                        self.i += 1
                        return
                    depth -= 1
            self.i += 1
        if until_paren:
            raise LexError('paren')

    def double(self, a, q_pos, q):
        s = self.s
        j = q_pos + 1
        mark = a
        while j < self.n:
            c = s[j]
            if c == '\\':
                j += 2
                continue
            if c == q:
                self.lit(a, q_pos + 1, j)
                _blank(self.out, mark, j + 1)
                self.i = j + 1
                return
            if q == '"' and s.startswith('$(', j):
                _blank(self.out, mark, j + 2)
                self.i = j + 2
                self.code(True)
                j = self.i
                mark = j - 1
                continue
            j += 1
        raise LexError('quote')

    def heredoc_start(self):
        s = self.s
        j = self.i + 2
        strip = False
        if j < self.n and s[j] == '-':
            strip = True
            j += 1
        while j < self.n and s[j] in ' \t':
            j += 1
        if j < self.n and s[j] in '\'"':
            q = s[j]
            k = s.find(q, j + 1)
            if k < 0:
                raise LexError('heredoc')
            word = s[j + 1:k]
            j = k + 1
        else:
            k = j
            while k < self.n and (s[k].isalnum() or s[k] == '_'):
                k += 1
            word = s[j:k]
            j = k
        if not word:
            raise LexError('heredoc')
        self.heredocs.append((word, strip))
        self.i = j

    def read_heredocs(self):
        s = self.s
        for word, strip in self.heredocs:
            a = self.i
            j = a
            while True:
                if j >= self.n:
                    raise LexError('heredoc')
                k = s.find('\n', j)
                k = self.n if k < 0 else k
                line = s[j:k]
                if (line.lstrip('\t') if strip else line) == word:
                    ln = self.lines.line
                    self.lits.append(Lit(s[a:j], a, ln(a), ln(max(a, j - 1))))
                    _blank(self.out, a, j)
                    self.i = min(k + 1, self.n)
                    break
                j = k + 1
        self.heredocs = []


def lex_shell(src):
    return _Shell(src).run()
~~~~

**File `tool/checks/guardlib.py`**

~~~~python
# Shared by the guards: which files to read, what kind each one is,
# and the one place the checks write their results.
import hashlib
import os
import posixpath
import re
import subprocess
import sys

import lex

MARKER = 'tool/checks/awaiting-import'
SOURCES = 'docs/source/SOURCES'
CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'

CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.py': 'py', '.sh': 'sh'}
CONFIG_NAMES = ('pubspec.yaml', 'package.json')
CONFIG_EXT = ('.plist', '.entitlements', '.pbxproj', '.xcconfig', '.xcscheme')
LOCKFILES = ('pubspec.lock', 'package-lock.json', 'npm-shrinkwrap.json',
             'Podfile.lock', 'yarn.lock', 'pnpm-lock.yaml')
SKIP_DIRS = ('.git', '.scratch')


def report(line):
    # The checks' only writer (G5 exempts this file). It is given guard
    # codes, repository paths, line numbers and reason codes, never the
    # content of a file.
    sys.stdout.write(line + '\n')
    sys.stdout.flush()


class Finding:
    def __init__(self, path, line, reason):
        self.path = path
        self.line = line
        self.reason = reason

    def key(self):
        return (self.path, self.line, self.reason)


def is_secret_name(path):
    b = posixpath.basename(path)
    return (b == '.env' or b.startswith('.env.')
            or b.endswith(('.p8', '.pem', '.p12', '.mobileprovision')))


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def _git(root, *args):
    r = subprocess.run(('git',) + args, cwd=root, capture_output=True)
    if r.returncode != 0:
        raise RuntimeError('git')
    return r.stdout


class Source:
    # mode 'walk': every file under root (the guard tests use this).
    # mode 'tracked': the files git tracks, read from the working tree.
    # mode 'staged': the index, the snapshot a commit would record.
    def __init__(self, root, mode):
        self.root = root
        self.mode = mode
        self._blobs = {}
        self._cache = {}
        self._lexed = {}
        if mode == 'walk':
            paths = []
            for d, dirs, files in os.walk(root):
                dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS)
                for f in files:
                    full = os.path.join(d, f)
                    rel = os.path.relpath(full, root).replace(os.sep, '/')
                    if not os.path.islink(full):
                        paths.append(rel)
        elif mode == 'tracked':
            out = _git(root, 'ls-files', '-z').decode('utf-8')
            paths = [p for p in out.split('\0') if p]
        elif mode == 'staged':
            out = _git(root, 'ls-files', '-s', '-z').decode('utf-8')
            paths = []
            for entry in out.split('\0'):
                if not entry:
                    continue
                meta, path = entry.split('\t', 1)
                fmode, blob, _ = meta.split(' ')
                if fmode in ('120000', '160000'):
                    continue
                self._blobs[path] = blob
                paths.append(path)
        else:
            raise ValueError(mode)
        self.paths = sorted(set(paths))
        self._set = set(self.paths)

    def has(self, path):
        return path in self._set

    def read(self, path):
        if path not in self._set or is_secret_name(path):
            return None
        if path not in self._cache:
            if self.mode == 'staged':
                data = _git(self.root, 'cat-file', 'blob', self._blobs[path])
            else:
                full = os.path.join(self.root, path)
                if os.path.islink(full) or not os.path.isfile(full):
                    data = None
                else:
                    with open(full, 'rb') as f:
                        data = f.read()
            self._cache[path] = data
        return self._cache[path]

    def text(self, path):
        data = self.read(path)
        if data is None or b'\0' in data:
            return None
        try:
            return data.decode('utf-8')
        except UnicodeDecodeError:
            return None

    def kind(self, path):
        # 'dart', 'ts', 'py', 'sh', 'config' or None (not scanned by
        # G3 to G6, G8 and G9). Markdown, docs/ and lockfiles are None.
        b = posixpath.basename(path)
        if path.endswith('.md') or path.startswith('docs/') or b in LOCKFILES:
            return None
        ext = posixpath.splitext(b)[1]
        if ext in CODE_EXT:
            return CODE_EXT[ext]
        if b in CONFIG_NAMES or ext in CONFIG_EXT:
            return 'config'
        if ext == '':
            text = self.text(path)
            first = text.split('\n', 1)[0] if text else ''
            if first.startswith('#!'):
                if 'python' in first:
                    return 'py'
                if first.rstrip().endswith(('sh', 'bash')):
                    return 'sh'
        return None

    def lexed(self, path):
        # A Lexed, or None when the file cannot be lexed (fail closed).
        if path not in self._lexed:
            text = self.text(path)
            fn = {'dart': lex.lex_dart, 'ts': lex.lex_ts,
                  'py': lex.lex_python, 'sh': lex.lex_shell}[self.kind(path)]
            try:
                self._lexed[path] = None if text is None else fn(text)
            except lex.LexError:
                self._lexed[path] = None
        return self._lexed[path]


def words(text):
    return len(text.replace('\\n', ' ').replace('\\t', ' ').split())


QUOTED = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
PLIST_STRING = re.compile(r'<string>(.*?)</string>', re.S)


def _line_at(text, pos):
    return text.count('\n', 0, pos) + 1


def config_strings(path, text):
    # (line, string) pairs: what counts as a string literal in config.
    b = posixpath.basename(path)
    out = []
    if b.endswith(('.plist', '.entitlements')):
        for m in PLIST_STRING.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    elif b.endswith(('.yaml', '.yml')):
        for n, line in enumerate(text.split('\n'), 1):
            body = re.sub(r'(^|\s)#.*$', '', line).strip()
            if body.startswith('- '):
                body = body[2:]
            key, sep, value = body.partition(': ')
            out.append((n, value if sep else body))
    elif b.endswith('.xcconfig'):
        for n, line in enumerate(text.split('\n'), 1):
            body = line.split('//', 1)[0]
            out.append((n, body.partition('=')[2]))
    else:
        for m in QUOTED.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    return out


SOURCES_LINE = re.compile(r'^([0-9a-f]{64})  (\S+)  (\S.*)$')


def parse_sources(src):
    # {path: (sha256, line)} and findings for malformed or repeated lines.
    entries = {}
    findings = []
    text = src.text(SOURCES) or ''
    for n, line in enumerate(text.split('\n'), 1):
        if not line.strip() or line.startswith('#'):
            continue
        m = SOURCES_LINE.match(line)
        if not m:
            findings.append(Finding(SOURCES, n, 'sources-malformed'))
        elif m.group(2) in entries:
            findings.append(Finding(SOURCES, n, 'sources-repeated'))
        else:
            entries[m.group(2)] = (m.group(1), n)
    return entries, findings
~~~~

Run the same command. Expected: `Ran 14 tests`, `OK`.

**Mutation:** `python3 -I -B tool/checks/tests/mutations.py lex.py`. Expected: `mutation 16 lex.py: caught`,
`mutations: 1 run, all caught`.

    git add tool/checks && git commit -m "Guards: lexers, shared library, test and mutation runners" -m "<trailer>"

### Task 2a · Lexer and library fixes (D16)

Task 2 is committed as `d95607d`, identical to the plan above, and stays as written. The Opus reviewer of Task 2
found the cases below, and the owner ruled on them in D16 (2026-11-07). This task fixes them in `tool/checks/lex.py`
and `tool/checks/guardlib.py`, red then green: each case is a failing test first, with the exact input of the ruling
where it gives one.

| | Fix | Test (red first) |
|---|---|---|
| F1 | TypeScript: `/` after postfix `++` or `--` is division | `TypeScript.test_slash_after_postfix_is_division` |
| F2 | TypeScript: `/` after `)` is a regex only when that `(` followed `if`, `while`, `for` or `with`; otherwise division | `TypeScript.test_slash_after_condition_is_regex` |
| F3 | An unterminated regex at the end of input raises `LexError` | `TypeScript.test_unterminated_regex_raises` |
| F4 | Python without a trailing newline: one is appended before tokenizing; positions unchanged | `Python.test_no_trailing_newline` |
| F5 | Nesting deeper than `MAX_NESTING` (100) raises `LexError`; any lexer exception, `RecursionError` included, makes the file unlexable | `Nesting.test_deep_nesting_raises_lex_error`; `Library.test_any_lexer_exception_is_unlexable` |
| F6 | `is_secret_name` ignores case: `.ENV`, `x.PEM`, `AuthKey.P8` are refused by name and never opened | `Library.test_secret_names_ignore_case` |
| F7 | `kind()`: `.mjs .cjs .tsx .jsx` are `ts`; `.swift` is `swift`; every `.json .yaml .yml` but lockfiles is `config`; shebangs by interpreter name (env and flags skipped); code under `docs/` is scanned | `Library.test_kind_by_extension`; `Library.test_kind_by_shebang`; `Swift.test_multiline_string`, `Swift.test_interpolation_keeps_code`, `Swift.test_nested_block_comment` |
| F8 | YAML: block scalars (`\|` and `>`) are joined into one string; a comment is stripped only when its `#` is outside quotes | `Library.test_yaml_block_scalars_joined`; `Library.test_yaml_comment_only_outside_quotes` |
| F9 | A literal in a bare parenthesis keeps the enclosing call and named argument | `Frames.test_bare_parenthesis_keeps_call_and_named` (the G3 tests come in Task 4) |
| F10 | Shell: `$(( ))` is arithmetic code, not a heredoc or substitution; heredoc words may contain `-` | `Shell.test_arithmetic_is_code`; `Shell.test_heredoc_word_with_hyphen` |
| F11 | A tracked path that is not valid UTF-8 does not crash `Source`: it becomes the finding `bad-path` | `Library.test_undecodable_path_is_a_finding` (Task 11 reports it) |

The lexer tests are in a new file, `test_lex_fixes.py`, and the library tests in another, `test_guardlib.py`, so
Task 2's `test_lex.py` is not touched.

**How the fixes work.**
- **F1, F2:** the TypeScript lexer reads `++` and `--` as one token, after which `/` divides. A `)` now records the
  frame it closes: `/` after it starts a regex only when that frame is `if`, `while`, `for` or `with`.
- **F3:** the regex reader raises unless it found the closing `/`.
- **F4:** `lex_python` tokenizes the source with a newline appended, and returns code cut back to the original
  length. Every position is unchanged, because the newline comes after the last character.
- **F5:** each string interpolation (Dart, TypeScript, Swift) and each shell substitution inside a string counts one
  level of nesting. Past `MAX_NESTING` the lexer raises `LexError('nesting')`, well before Python's recursion limit.
  `Source.lexed` turns any exception from a lexer into `None` (unlexable), never a crash.
- **F6:** `is_secret_name` lowers the file name before comparing.
- **F7:** Swift is read by the same lexer as Dart and TypeScript, in a third mode, `swift`:
  - strings `"…"` and `"""…"""` (multiline), and the extended `#"…"#` forms;
  - escapes with `\`, and interpolation `\( … )`, read as code up to its matching `)`;
  - nested `/* */` comments, as in Dart;
  - a `'` outside a string or comment is not Swift, and raises `LexError`.

  The guards that read code (G4, G5, G6 and G9) read `.swift` files from now on. G3 and G8 stay Dart-only.
  Swift's regex literals (`/…/`, `#/…/#`) are not read as regexes, and a `"`, `//` or `/*` inside one can hide code
  without making the file unlexable (finding B1; Task 2b's R3 closes it). Shebangs: `env`, its flags and its
  `VAR=value` settings are skipped, and the program is read by the last part of its path. `sh`, `bash`, `dash` and
  `zsh` are `sh`, `python*` is `py`, and `node` is `ts`. Markdown and lockfiles are left unscanned, wherever they are,
  and so is every file whose kind is not known (finding B3; Task 2b's G0 refuses those). Extensions are compared in
  lower case. (Prose corrected by the owner's ruling of 2026-11-07, fourth amendment.)
- **F8:** the YAML reader is `yaml_strings`. A value of `|` or `>` (with any `-`, `+` or digit after it) takes every
  following line indented deeper than its key, blank lines included. Their stripped text is joined with spaces into
  one string, given the key's line number. `#` starts a comment only at the start of a line, or after a space or tab,
  and only outside quotes.
- **F9:** a frame is now `(name, named, bare)`. A call's `(` takes the call's name, as before. A bare `(` keeps the
  enclosing frame's name and the named argument it is the value of. So in `f(tooltip: ('x'))` the literal is `f`'s
  `tooltip`, and in `Text(('y'))` it is `Text`'s.
- **F10:** `$((` starts arithmetic, read up to its matching `))`. In code it stays code. Inside double quotes it is
  skipped whole, so a `<<` in it starts no heredoc, but it stays part of the string and is blanked as string, as
  `Shell.test_arithmetic_is_code` asserts (prose corrected by D17, R5). Heredoc words may contain `-`.
- **F11:** `Source` reads git's paths as bytes and decodes each one alone. A path that is not UTF-8 is left out of
  `paths` and added to `Source.findings` as `bad-path`, named with its bytes escaped (for example `app/a\xff.txt`).

**Red.** Write the two test files and add the four mutation rows:

**File `tool/checks/tests/test_lex_fixes.py`**

~~~~python
# Task 2a (D16): the lexer fixes, each with its exact input.
import unittest

import helpers  # noqa: F401
import lex


def texts(lx):
    return [l.text for l in lx.lits]


def nested(n):
    # n Dart strings, each inside the last one's interpolation.
    return "'${" * n + '1' + "}'" * n


def nested_shell(n):
    # n shell strings, each inside the last one's substitution.
    return 'echo ' + '"$(' * n + 'x' + ')"' * n + '\n'


class TypeScript(unittest.TestCase):
    def test_slash_after_postfix_is_division(self):
        lx = lex.lex_ts('a = x++ / 2; console.log(y); z = w / 3;')
        self.assertEqual(texts(lx), [])
        self.assertIn('console.log(y)', lx.code)

    def test_slash_after_condition_is_regex(self):
        lx = lex.lex_ts('if (a) /"/.test(b); console.log(x);')
        self.assertEqual(texts(lx), [])
        self.assertIn('console.log(x)', lx.code)
        self.assertEqual(texts(lex.lex_ts("f(a) / 2; g('x') / h(1) / 3;")), ['x'])

    def test_unterminated_regex_raises(self):
        with self.assertRaises(lex.LexError):
            lex.lex_ts('f(); /console.log(1)')


class Python(unittest.TestCase):
    def test_no_trailing_newline(self):
        src = "a = 'x'  # c"
        lx = lex.lex_python(src)
        self.assertEqual(texts(lx), ['x'])
        self.assertEqual(lx.lits[0].pos, 4)
        self.assertEqual(len(lx.comments), 1)
        self.assertEqual(len(lx.code), len(src))


class Nesting(unittest.TestCase):
    def test_deep_nesting_raises_lex_error(self):
        for n in (150, 600):
            with self.assertRaises(lex.LexError):
                lex.lex_dart(nested(n))
            with self.assertRaises(lex.LexError):
                lex.lex_ts(nested(n))
            with self.assertRaises(lex.LexError):
                lex.lex_shell(nested_shell(n))
        self.assertEqual(len(lex.lex_dart(nested(20)).lits), 20)


class Swift(unittest.TestCase):
    def test_multiline_string(self):
        lx = lex.lex_swift('let a = """\none "two"\n"""\nf("b")\n')
        self.assertEqual(texts(lx), ['\none "two"\n', 'b'])
        self.assertEqual(lx.lits[0].end_line, 3)

    def test_interpolation_keeps_code(self):
        lx = lex.lex_swift('f("a \\(g("b")) c")\n')
        self.assertEqual(texts(lx), ['a \\(g("b")) c', 'b'])
        self.assertIn('g(', lx.code)
        self.assertNotIn('a ', lx.code)

    def test_nested_block_comment(self):
        lx = lex.lex_swift('/* a /* b */ "c" */ f("d")\n')
        self.assertEqual(texts(lx), ['d'])
        self.assertEqual(len(lx.comments), 1)


class Frames(unittest.TestCase):
    def test_bare_parenthesis_keeps_call_and_named(self):
        lx = lex.lex_dart("f(tooltip: ('x')); Text(('y')); if (a) g('z');")
        got = [(l.text, l.frame, l.named) for l in lx.lits]
        self.assertEqual(got, [('x', 'f', 'tooltip'), ('y', 'Text', ''), ('z', 'g', '')])


class Shell(unittest.TestCase):
    def test_arithmetic_is_code(self):
        lx = lex.lex_shell('x=$((1 << 2))\necho "$((3<<1))"\n')
        self.assertEqual(texts(lx), ['$((3<<1))'])
        self.assertIn('x=$((1 << 2))', lx.code)

    def test_heredoc_word_with_hyphen(self):
        lx = lex.lex_shell('cat <<END-OF\nbody\nEND-OF\necho done\n')
        self.assertEqual(texts(lx), ['body\n'])
        self.assertIn('echo done', lx.code)


if __name__ == '__main__':
    unittest.main()
~~~~

**File `tool/checks/tests/test_guardlib.py`**

~~~~python
# Task 2a (D16): the library fixes.
import os
import shutil
import subprocess
import tempfile
import unittest
from unittest import mock

from helpers import make_tree, sentence
import guardlib
import lex


def kinds(files):
    root = make_tree(files)
    try:
        src = guardlib.Source(root, 'walk')
        return {p: src.kind(p) for p in src.paths}
    finally:
        shutil.rmtree(root)


class Library(unittest.TestCase):
    def test_secret_names_ignore_case(self):
        for name in ('.ENV', '.Env.Local', 'x.PEM', 'AuthKey.P8', 'k.P12', 'a.MobileProvision'):
            self.assertTrue(guardlib.is_secret_name('app/' + name), name)
        root = make_tree({'app/x.PEM': 'canary\n'})
        try:
            os.chmod(os.path.join(root, 'app', 'x.PEM'), 0)
            src = guardlib.Source(root, 'walk')
            self.assertEqual(src.paths, ['app/x.PEM'])
            self.assertIsNone(src.read('app/x.PEM'))
        finally:
            shutil.rmtree(root)

    def test_kind_by_extension(self):
        got = kinds({'a.mjs': '', 'a.cjs': '', 'a.tsx': '', 'a.jsx': '', 'a.swift': '',
                     'a.json': '', 'a.yaml': '', 'a.yml': '',
                     'package-lock.json': '', 'pnpm-lock.yaml': '',
                     'docs/tool.py': '', 'docs/a.dart': '', 'docs/a.md': ''})
        self.assertEqual(got, {'a.mjs': 'ts', 'a.cjs': 'ts', 'a.tsx': 'ts', 'a.jsx': 'ts',
                               'a.swift': 'swift', 'a.json': 'config', 'a.yaml': 'config',
                               'a.yml': 'config', 'package-lock.json': None,
                               'pnpm-lock.yaml': None, 'docs/tool.py': 'py',
                               'docs/a.dart': 'dart', 'docs/a.md': None})

    def test_kind_by_shebang(self):
        got = kinds({'a': '#!/bin/sh -eu\n', 'b': '#!/usr/bin/env bash\n', 'c': '#!/bin/dash\n',
                     'd': '#!/bin/zsh\n', 'e': '#!/usr/bin/env -S python3 -u\n',
                     'f': '#!/usr/bin/python3.12\n', 'g': '#!/usr/bin/env node\n',
                     'h': '#!/usr/bin/perl\n', 'i': 'no shebang\n'})
        self.assertEqual(got, {'a': 'sh', 'b': 'sh', 'c': 'sh', 'd': 'sh', 'e': 'py',
                               'f': 'py', 'g': 'ts', 'h': None, 'i': None})

    def test_yaml_block_scalars_joined(self):
        half = sentence(6)
        for mark in ('|', '>-', '|2'):
            text = 'description: ' + mark + '\n  ' + half + '\n\n  ' + half + '\nname: x\n'
            got = guardlib.config_strings('app/pubspec.yaml', text)
            self.assertIn((1, sentence(12)), got)
            self.assertIn((5, 'x'), got)
            self.assertEqual(max(guardlib.words(t) for _, t in got), 12)
        got = guardlib.config_strings('a.yml', '- |\n  ' + half + '\n  ' + half + '\n')
        self.assertIn((1, sentence(12)), got)

    def test_yaml_comment_only_outside_quotes(self):
        text = '\n'.join(['a: "p # q r"', 'b: s # t u', "c: 'v # w'", '# x y', ''])
        got = guardlib.config_strings('app/pubspec.yaml', text)
        self.assertEqual(got[:4], [(1, '"p # q r"'), (2, 's'), (3, "'v # w'"), (4, '')])

    def test_any_lexer_exception_is_unlexable(self):
        root = make_tree({'app/lib/a.dart': 'f() {}\n'})
        try:
            src = guardlib.Source(root, 'walk')
            with mock.patch.object(lex, 'lex_dart', side_effect=RecursionError):
                self.assertIsNone(src.lexed('app/lib/a.dart'))
        finally:
            shutil.rmtree(root)

    def test_undecodable_path_is_a_finding(self):
        root = tempfile.mkdtemp(prefix='guards-')
        env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1')

        def git(*args, data=None):
            return subprocess.run(('git',) + args, cwd=root, env=env, input=data,
                                  check=True, capture_output=True).stdout

        try:
            git('init', '-q')
            blob = git('hash-object', '-w', '--stdin', data=b'x\n').strip()
            for name in (b'app/a\xff.txt', b'app/b.txt'):
                git('update-index', '--add', '--cacheinfo', b'100644,' + blob + b',' + name)
            for mode in ('tracked', 'staged'):
                src = guardlib.Source(root, mode)
                self.assertEqual(src.paths, ['app/b.txt'])
                self.assertEqual([f.key() for f in src.findings],
                                 [('app/a\\xff.txt', 0, 'bad-path')])
        finally:
            shutil.rmtree(root)


if __name__ == '__main__':
    unittest.main()
~~~~

**Edit `tool/checks/tests/mutations.py`.** Replace

~~~~python
     ['test_lex.Dart.test_unterminated_raises']),
]
~~~~

with

~~~~python
     ['test_lex.Dart.test_unterminated_raises']),
    ('lex.py', "return value not in (']', '++', '--')", "return value not in (']',)",
     ['test_lex_fixes.TypeScript.test_slash_after_postfix_is_division']),
    ('lex.py', "return value in PAREN_KEYWORDS", "return False",
     ['test_lex_fixes.TypeScript.test_slash_after_condition_is_regex']),
    ('lex.py', "if not closed:\n            raise LexError('regex')",
     "if False:\n            raise LexError('regex')",
     ['test_lex_fixes.TypeScript.test_unterminated_regex_raises']),
    ('guardlib.py', "b = posixpath.basename(path).lower()", "b = posixpath.basename(path)",
     ['test_guardlib.Library.test_secret_names_ignore_case']),
]
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_lex_fixes test_guardlib`. Expected: exit 1, `Ran 18 tests`,
`FAILED (failures=9, errors=9)`:
- **Failures (9):** `test_slash_after_postfix_is_division`, `test_unterminated_regex_raises`,
  `test_deep_nesting_raises_lex_error`, `test_bare_parenthesis_keeps_call_and_named`, `test_secret_names_ignore_case`,
  `test_kind_by_extension`, `test_kind_by_shebang`, `test_yaml_block_scalars_joined`,
  `test_yaml_comment_only_outside_quotes`.
- **Errors (9):**
  - `test_slash_after_condition_is_regex`, `test_no_trailing_newline`, `test_arithmetic_is_code` and
    `test_heredoc_word_with_hyphen`: `LexError`.
  - The three Swift tests: `AttributeError`, because `lex` has no `lex_swift` yet.
  - `test_any_lexer_exception_is_unlexable`: `RecursionError`.
  - `test_undecodable_path_is_a_finding`: `UnicodeDecodeError`.

**Green.** Replace both files whole:

**File `tool/checks/lex.py`**

~~~~python
# Small lexers for the guards: string literals, comments, and the code
# with both blanked out. Standard library only. Dart, TypeScript or
# JavaScript, Swift, Python and POSIX shell. Unclear input raises
# LexError, which the guards turn into a finding (they fail closed).
import bisect
import io
import tokenize


class LexError(Exception):
    pass


# How deep strings may nest inside interpolations or substitutions.
# Deeper input is refused, well before Python's own recursion limit.
MAX_NESTING = 100


class Lit:
    # One string literal. text is the source between the quotes,
    # interpolations included. frame is the call (or bracket) it sits
    # directly inside; named is the named argument it is the value of.
    def __init__(self, text, pos, line, end_line, frame='', named=''):
        self.text = text
        self.pos = pos
        self.line = line
        self.end_line = end_line
        self.frame = frame
        self.named = named


class Comment:
    def __init__(self, text, start, end, line, end_line):
        self.text = text
        self.start = start
        self.end = end
        self.line = line
        self.end_line = end_line


class Lexed:
    def __init__(self, src, lits, comments, code):
        self.src = src
        self.lits = sorted(lits, key=lambda x: x.pos)
        self.comments = comments
        self.code = code  # strings and comments blanked

    def without_comments(self):
        out = list(self.src)
        for c in self.comments:
            _blank(out, c.start, c.end)
        return ''.join(out)


def _blank(out, a, b):
    for k in range(a, b):
        if out[k] != '\n':
            out[k] = ' '


class _Lines:
    def __init__(self, src):
        self.starts = [0]
        for i, ch in enumerate(src):
            if ch == '\n':
                self.starts.append(i + 1)

    def line(self, pos):
        return bisect.bisect_right(self.starts, pos)


IDENT_START = set('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$')
IDENT = IDENT_START | set('0123456789')
REGEX_KEYWORDS = {
    'return', 'typeof', 'instanceof', 'in', 'of', 'new', 'delete', 'void',
    'throw', 'case', 'do', 'else', 'yield', 'await',
}
# A '/' after the ')' of one of these starts a regex: if (a) /x/.test(b)
PAREN_KEYWORDS = {'if', 'while', 'for', 'with'}
NO_FRAME = ('', '', False)


class _CLike:
    # Dart, TypeScript and JavaScript ('ts'), or Swift. A frame is
    # (name, named, bare): the call or bracket a literal sits in, the
    # named argument a bare parenthesis stands for, and whether the
    # '(' was bare rather than a call.
    def __init__(self, src, lang):
        self.s = src
        self.n = len(src)
        self.i = 0
        self.lang = lang
        self.out = list(src)
        self.lines = _Lines(src)
        self.lits = []
        self.comments = []
        self.frames = []
        self.prev = []
        self.chain = ''
        self.nesting = 0

    def run(self):
        self.code(None)
        return Lexed(self.s, self.lits, self.comments, ''.join(self.out))

    def push(self, kind, value):
        self.prev.append((kind, value))
        del self.prev[:-3]

    def comment(self, a, b):
        ln = self.lines.line
        self.comments.append(Comment(self.s[a:b], a, b, ln(a), ln(max(a, b - 1))))
        _blank(self.out, a, b)
        self.i = b

    def block_end(self, a):
        s = self.s
        if self.lang == 'ts':
            j = s.find('*/', a + 2)
            if j < 0:
                raise LexError('comment')
            return j + 2
        depth = 0
        j = a
        while j < self.n:
            if s.startswith('/*', j):
                depth += 1
                j += 2
            elif s.startswith('*/', j):
                depth -= 1
                j += 2
                if depth == 0:
                    return j
            else:
                j += 1
        raise LexError('comment')

    def regex_allowed(self):
        # A '/' starts a regex where an operand may begin, and divides
        # where one has just ended.
        if not self.prev:
            return True
        kind, value = self.prev[-1]
        if kind == 'close':
            return value in PAREN_KEYWORDS
        if kind == 'p':
            return value not in (']', '++', '--')
        if kind == 'id':
            return value in REGEX_KEYWORDS
        return False

    def regex(self):
        s = self.s
        a = self.i
        j = a + 1
        in_class = False
        closed = False
        while j < self.n:
            c = s[j]
            if c == '\\':
                j += 2
                continue
            if c == '\n':
                raise LexError('regex')
            if c == '[':
                in_class = True
            elif c == ']':
                in_class = False
            elif c == '/' and not in_class:
                j += 1
                closed = True
                break
            j += 1
        if not closed:
            raise LexError('regex')
        while j < self.n and s[j] in IDENT:
            j += 1
        _blank(self.out, a, j)
        self.i = j
        self.push('re', '')

    def named_here(self):
        if (len(self.prev) >= 2 and self.prev[-1] == ('p', ':')
                and self.prev[-2][0] == 'id'):
            return self.prev[-2][1]
        return ''

    def where(self):
        # (frame, named) for a literal or a bare '(' at this point.
        top = self.frames[-1] if self.frames else NO_FRAME
        return top[0], self.named_here() or (top[1] if top[2] else '')

    def paren(self):
        # A call's '(' takes the call's name. A bare '(' keeps the
        # enclosing call and named argument: f(tooltip: ('x')) is
        # still f's tooltip.
        if self.prev and self.prev[-1][0] == 'id':
            return (self.chain, '', False)
        name, named = self.where()
        return (name or '(', named, True)

    def swift_string_at(self, i):
        j = i
        while j < self.n and self.s[j] == '#':
            j += 1
        return j < self.n and self.s[j] == '"'

    def code(self, close):
        # close is None at the top level, or the character that ends
        # the interpolation being read: '}' after '${', ')' after '\('.
        s = self.s
        opener = {'}': '{', ')': '('}.get(close)
        depth = 0
        while self.i < self.n:
            i = self.i
            c = s[i]
            if c in ' \t\r\n':
                self.i += 1
                continue
            if s.startswith('//', i):
                j = s.find('\n', i)
                self.comment(i, self.n if j < 0 else j)
                continue
            if s.startswith('/*', i):
                self.comment(i, self.block_end(i))
                continue
            if self.lang == 'ts' and c == '/' and self.regex_allowed():
                self.regex()
                continue
            if self.lang == 'swift':
                if c in '"#' and self.swift_string_at(i):
                    self.swift_string(i)
                    continue
                if c == "'":
                    raise LexError('quote')
            elif c in '\'"' or (self.lang == 'ts' and c == '`'):
                self.dart_ts_string(i, i, False)
                continue
            if (self.lang == 'dart' and c == 'r' and i + 1 < self.n and s[i + 1] in '\'"'
                    and (i == 0 or s[i - 1] not in IDENT)):
                self.dart_ts_string(i, i + 1, True)
                continue
            if c in IDENT_START:
                j = i
                while j < self.n and s[j] in IDENT:
                    j += 1
                word = s[i:j]
                if (len(self.prev) >= 2 and self.prev[-1] == ('p', '.')
                        and self.prev[-2][0] == 'id'):
                    self.chain = self.chain + '.' + word
                else:
                    self.chain = word
                self.push('id', word)
                self.i = j
                continue
            if c.isdigit():
                j = i
                while j < self.n and (s[j] in IDENT or s[j] == '.'):
                    j += 1
                self.push('num', s[i:j])
                self.i = j
                continue
            if c in '+-' and s.startswith(c * 2, i):
                self.push('p', c * 2)
                self.i += 2
                continue
            if c == close and depth == 0:
                self.i += 1
                return
            if c == opener:
                depth += 1
            elif c == close:
                depth -= 1
            if c == '(':
                self.frames.append(self.paren())
            elif c in '[{':
                self.frames.append((c, '', False))
            elif c in ')]}':
                top = self.frames.pop() if self.frames else NO_FRAME
                if c == ')':
                    self.push('close', '' if top[2] else top[0])
                    self.i += 1
                    continue
            self.push('p', c)
            self.i += 1
        if close:
            raise LexError('interpolation')

    def dart_ts_string(self, start, q_pos, raw):
        s = self.s
        q = s[q_pos]
        triple = self.lang == 'dart' and s.startswith(q * 3, q_pos)
        delim = q * 3 if triple else q
        self.string(start, q_pos + len(delim), delim, triple or q == '`',
                    None if raw else '\\', None if raw else '${', '}')

    def swift_string(self, start):
        s = self.s
        j = start
        while s[j] == '#':
            j += 1
        hashes = s[start:j]
        q = '"""' if s.startswith('"""', j) else '"'
        self.string(start, j + len(q), q + hashes, q == '"""',
                    '\\' + hashes, '\\' + hashes + '(', ')')

    def string(self, start, content, delim, multiline, escape, interp, close):
        s = self.s
        frame, named = self.where()
        j = content
        mark = start
        end = None
        while j < self.n:
            if s.startswith(delim, j):
                end = j
                j += len(delim)
                break
            c = s[j]
            if c == '\n' and not multiline:
                raise LexError('string')
            if interp and s.startswith(interp, j):
                _blank(self.out, mark, j + len(interp))
                self.i = j + len(interp)
                self.nesting += 1
                if self.nesting > MAX_NESTING:
                    raise LexError('nesting')
                saved = self.prev
                self.prev = []
                self.frames.append((interp, '', False))
                self.code(close)
                self.frames.pop()
                self.prev = saved
                self.nesting -= 1
                j = self.i
                mark = j - 1
                continue
            if escape and s.startswith(escape, j):
                j += len(escape) + 1
                continue
            j += 1
        if end is None:
            raise LexError('string')
        _blank(self.out, mark, j)
        ln = self.lines.line
        self.lits.append(Lit(s[content:end], start, ln(start), ln(end), frame, named))
        self.i = j
        self.push('s', '')


def lex_dart(src):
    return _CLike(src, 'dart').run()


def lex_ts(src):
    return _CLike(src, 'ts').run()


def lex_swift(src):
    return _CLike(src, 'swift').run()


def _py_body(tok):
    k = 0
    while k < len(tok) and tok[k] not in '\'"':
        k += 1
    body = tok[k:]
    q = body[:3] if body[:3] in ('"""', "'''") else body[:1]
    return body[len(q):len(body) - len(q)]


def lex_python(src):
    # tokenize wants a final newline. One is added after the last
    # character, so no position moves, and it is dropped again.
    padded = src if src.endswith('\n') else src + '\n'
    lines = _Lines(padded)
    out = list(padded)
    lits = []
    comments = []
    open_strings = []

    def pos(rc):
        return lines.starts[rc[0] - 1] + rc[1]

    try:
        for tok in tokenize.generate_tokens(io.StringIO(padded).readline):
            name = tokenize.tok_name[tok.type]
            a, b = pos(tok.start), pos(tok.end)
            if name == 'COMMENT':
                comments.append(Comment(tok.string, a, b, tok.start[0], tok.end[0]))
                _blank(out, a, b)
            elif name == 'STRING':
                lits.append(Lit(_py_body(tok.string), a, tok.start[0], tok.end[0]))
                _blank(out, a, b)
            elif name.endswith('STRING_START'):
                open_strings.append((a, tok.start[0]))
            elif name.endswith('STRING_END'):
                a0, l0 = open_strings.pop()
                lits.append(Lit(_py_body(padded[a0:b]), a0, l0, tok.end[0]))
                _blank(out, a0, b)
            elif name == 'ERRORTOKEN' and tok.string.strip():
                raise LexError('python')
    except (tokenize.TokenError, SyntaxError, IndexError):
        raise LexError('python')
    return Lexed(src, lits, comments, ''.join(out[:len(src)]))


class _Shell:
    def __init__(self, src):
        self.s = src
        self.n = len(src)
        self.i = 0
        self.out = list(src)
        self.lines = _Lines(src)
        self.lits = []
        self.comments = []
        self.heredocs = []
        self.nesting = 0

    def run(self):
        self.code(False)
        if self.heredocs:
            raise LexError('heredoc')
        return Lexed(self.s, self.lits, self.comments, ''.join(self.out))

    def lit(self, a, content, end):
        ln = self.lines.line
        self.lits.append(Lit(self.s[content:end], a, ln(a), ln(max(a, end))))

    def arithmetic_end(self, a):
        # $(( ... )) is arithmetic, which is code: '<<' in it is a
        # shift, not a heredoc. Returns the position after the '))'.
        s = self.s
        depth = 0
        j = a + 3
        while j < self.n:
            if s[j] == '(':
                depth += 1
            elif s[j] == ')':
                if depth == 0:
                    if s.startswith('))', j):
                        return j + 2
                    raise LexError('arithmetic')
                depth -= 1
            j += 1
        raise LexError('arithmetic')

    def code(self, until_paren):
        s = self.s
        depth = 0
        while self.i < self.n:
            i = self.i
            c = s[i]
            if c == '\\':
                self.i += 2
                continue
            if c == '\n':
                self.i += 1
                if self.heredocs:
                    self.read_heredocs()
                continue
            if c == '#' and (i == 0 or s[i - 1] in ' \t\n;&|()'):
                j = s.find('\n', i)
                j = self.n if j < 0 else j
                ln = self.lines.line
                self.comments.append(Comment(s[i:j], i, j, ln(i), ln(i)))
                _blank(self.out, i, j)
                self.i = j
                continue
            if c == "'":
                j = s.find("'", i + 1)
                if j < 0:
                    raise LexError('quote')
                self.lit(i, i + 1, j)
                _blank(self.out, i, j + 1)
                self.i = j + 1
                continue
            if s.startswith("$'", i):
                self.double(i, i + 1, "'")
                continue
            if c == '"':
                self.double(i, i, '"')
                continue
            if s.startswith('$((', i):
                self.i = self.arithmetic_end(i)
                continue
            if s.startswith('<<', i) and not s.startswith('<<<', i):
                self.heredoc_start()
                continue
            if until_paren:
                if c == '(':
                    depth += 1
                elif c == ')':
                    if depth == 0:
                        self.i += 1
                        return
                    depth -= 1
            self.i += 1
        if until_paren:
            raise LexError('paren')

    def double(self, a, q_pos, q):
        s = self.s
        j = q_pos + 1
        mark = a
        while j < self.n:
            c = s[j]
            if c == '\\':
                j += 2
                continue
            if c == q:
                self.lit(a, q_pos + 1, j)
                _blank(self.out, mark, j + 1)
                self.i = j + 1
                return
            if q == '"' and s.startswith('$((', j):
                j = self.arithmetic_end(j)
                continue
            if q == '"' and s.startswith('$(', j):
                _blank(self.out, mark, j + 2)
                self.i = j + 2
                self.nesting += 1
                if self.nesting > MAX_NESTING:
                    raise LexError('nesting')
                self.code(True)
                self.nesting -= 1
                j = self.i
                mark = j - 1
                continue
            j += 1
        raise LexError('quote')

    def heredoc_start(self):
        s = self.s
        j = self.i + 2
        strip = False
        if j < self.n and s[j] == '-':
            strip = True
            j += 1
        while j < self.n and s[j] in ' \t':
            j += 1
        if j < self.n and s[j] in '\'"':
            q = s[j]
            k = s.find(q, j + 1)
            if k < 0:
                raise LexError('heredoc')
            word = s[j + 1:k]
            j = k + 1
        else:
            k = j
            while k < self.n and (s[k].isalnum() or s[k] in '_-'):
                k += 1
            word = s[j:k]
            j = k
        if not word:
            raise LexError('heredoc')
        self.heredocs.append((word, strip))
        self.i = j

    def read_heredocs(self):
        s = self.s
        for word, strip in self.heredocs:
            a = self.i
            j = a
            while True:
                if j >= self.n:
                    raise LexError('heredoc')
                k = s.find('\n', j)
                k = self.n if k < 0 else k
                line = s[j:k]
                if (line.lstrip('\t') if strip else line) == word:
                    ln = self.lines.line
                    self.lits.append(Lit(s[a:j], a, ln(a), ln(max(a, j - 1))))
                    _blank(self.out, a, j)
                    self.i = min(k + 1, self.n)
                    break
                j = k + 1
        self.heredocs = []


def lex_shell(src):
    return _Shell(src).run()
~~~~

**File `tool/checks/guardlib.py`**

~~~~python
# Shared by the guards: which files to read, what kind each one is,
# and the one place the checks write their results.
import hashlib
import os
import posixpath
import re
import subprocess
import sys

import lex

MARKER = 'tool/checks/awaiting-import'
SOURCES = 'docs/source/SOURCES'
CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'

CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.mjs': 'ts', '.cjs': 'ts',
            '.tsx': 'ts', '.jsx': 'ts', '.swift': 'swift', '.py': 'py', '.sh': 'sh'}
CONFIG_EXT = ('.json', '.yaml', '.yml', '.plist', '.entitlements', '.pbxproj',
              '.xcconfig', '.xcscheme')
SHELLS = ('sh', 'bash', 'dash', 'zsh')
LOCKFILES = ('pubspec.lock', 'package-lock.json', 'npm-shrinkwrap.json',
             'Podfile.lock', 'yarn.lock', 'pnpm-lock.yaml')
SKIP_DIRS = ('.git', '.scratch')


def report(line):
    # The checks' only writer (G5 exempts this file). It is given guard
    # codes, repository paths, line numbers and reason codes, never the
    # content of a file.
    sys.stdout.write(line + '\n')
    sys.stdout.flush()


class Finding:
    def __init__(self, path, line, reason):
        self.path = path
        self.line = line
        self.reason = reason

    def key(self):
        return (self.path, self.line, self.reason)


def is_secret_name(path):
    b = posixpath.basename(path).lower()
    return (b == '.env' or b.startswith('.env.')
            or b.endswith(('.p8', '.pem', '.p12', '.mobileprovision')))


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def _git(root, *args):
    r = subprocess.run(('git',) + args, cwd=root, capture_output=True)
    if r.returncode != 0:
        raise RuntimeError('git')
    return r.stdout


def interpreter(first):
    # The program a '#!' line names: env, its flags and its VAR=value
    # settings are skipped, and a path is read by its last part.
    words = first[2:].split()
    if words and posixpath.basename(words[0]) == 'env':
        words = [w for w in words[1:] if not w.startswith('-') and '=' not in w]
    return posixpath.basename(words[0]) if words else ''


class Source:
    # mode 'walk': every file under root (the guard tests use this).
    # mode 'tracked': the files git tracks, read from the working tree.
    # mode 'staged': the index, the snapshot a commit would record.
    # A path that is not valid UTF-8 cannot be checked: it is left out
    # of paths and becomes the finding 'bad-path' in findings.
    def __init__(self, root, mode):
        self.root = root
        self.mode = mode
        self.findings = []
        self._blobs = {}
        self._cache = {}
        self._lexed = {}
        paths = []
        if mode == 'walk':
            for d, dirs, files in os.walk(root):
                dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS)
                for f in files:
                    full = os.path.join(d, f)
                    rel = os.path.relpath(full, root).replace(os.sep, '/')
                    rel = self._name(rel.encode('utf-8', 'surrogateescape'))
                    if rel is not None and not os.path.islink(full):
                        paths.append(rel)
        elif mode == 'tracked':
            for raw in _git(root, 'ls-files', '-z').split(b'\0'):
                path = self._name(raw) if raw else None
                if path is not None:
                    paths.append(path)
        elif mode == 'staged':
            for entry in _git(root, 'ls-files', '-s', '-z').split(b'\0'):
                if not entry:
                    continue
                meta, raw = entry.split(b'\t', 1)
                fmode, blob, _ = meta.decode('ascii').split(' ')
                path = self._name(raw)
                if path is None or fmode in ('120000', '160000'):
                    continue
                self._blobs[path] = blob
                paths.append(path)
        else:
            raise ValueError(mode)
        self.paths = sorted(set(paths))
        self._set = set(self.paths)

    def _name(self, raw):
        try:
            return raw.decode('utf-8')
        except UnicodeDecodeError:
            shown = raw.decode('utf-8', 'backslashreplace')
            self.findings.append(Finding(shown, 0, 'bad-path'))
            return None

    def has(self, path):
        return path in self._set

    def read(self, path):
        if path not in self._set or is_secret_name(path):
            return None
        if path not in self._cache:
            if self.mode == 'staged':
                data = _git(self.root, 'cat-file', 'blob', self._blobs[path])
            else:
                full = os.path.join(self.root, path)
                if os.path.islink(full) or not os.path.isfile(full):
                    data = None
                else:
                    with open(full, 'rb') as f:
                        data = f.read()
            self._cache[path] = data
        return self._cache[path]

    def text(self, path):
        data = self.read(path)
        if data is None or b'\0' in data:
            return None
        try:
            return data.decode('utf-8')
        except UnicodeDecodeError:
            return None

    def kind(self, path):
        # 'dart', 'ts', 'swift', 'py', 'sh', 'config' or None (not
        # scanned by G3 to G6, G8 and G9). Markdown and lockfiles are
        # None; code under docs/ is scanned like code anywhere else.
        b = posixpath.basename(path)
        ext = posixpath.splitext(b)[1].lower()
        if ext == '.md' or b in LOCKFILES:
            return None
        if ext in CODE_EXT:
            return CODE_EXT[ext]
        if ext in CONFIG_EXT:
            return 'config'
        if ext == '':
            text = self.text(path)
            first = text.split('\n', 1)[0] if text else ''
            if first.startswith('#!'):
                prog = interpreter(first)
                if prog in SHELLS:
                    return 'sh'
                if prog.startswith('python'):
                    return 'py'
                if prog == 'node':
                    return 'ts'
        return None

    def lexed(self, path):
        # A Lexed, or None when the file cannot be lexed (fail closed).
        # Any exception from a lexer, RecursionError included, is None.
        if path not in self._lexed:
            text = self.text(path)
            fn = {'dart': lex.lex_dart, 'ts': lex.lex_ts, 'swift': lex.lex_swift,
                  'py': lex.lex_python, 'sh': lex.lex_shell}[self.kind(path)]
            try:
                self._lexed[path] = None if text is None else fn(text)
            except Exception:
                self._lexed[path] = None
        return self._lexed[path]


def words(text):
    return len(text.replace('\\n', ' ').replace('\\t', ' ').split())


QUOTED = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
PLIST_STRING = re.compile(r'<string>(.*?)</string>', re.S)
YAML_BLOCK = re.compile(r'[|>][-+0-9]*')


def _line_at(text, pos):
    return text.count('\n', 0, pos) + 1


def _indent(line):
    return len(line) - len(line.lstrip(' '))


def yaml_uncomment(line):
    # The line less its comment. '#' starts a comment at the start of
    # the line or after a space or tab, and only outside quotes.
    quote = ''
    for k, ch in enumerate(line):
        if quote:
            if ch == quote:
                quote = ''
        elif ch in '\'"':
            quote = ch
        elif ch == '#' and (k == 0 or line[k - 1] in ' \t'):
            return line[:k]
    return line


def yaml_strings(text):
    # (line, string) pairs. A block scalar (| or >) is joined into one
    # string, given the line of its key; its lines hold no comments.
    out = []
    lines = text.split('\n')
    k = 0
    while k < len(lines):
        body = yaml_uncomment(lines[k]).strip()
        if body.startswith('- '):
            body = body[2:]
        key, sep, value = body.partition(': ')
        value = value.strip() if sep else body
        if YAML_BLOCK.fullmatch(value):
            parts = []
            j = k + 1
            while j < len(lines) and (not lines[j].strip()
                                      or _indent(lines[j]) > _indent(lines[k])):
                parts.append(lines[j].strip())
                j += 1
            out.append((k + 1, ' '.join(p for p in parts if p)))
            k = j
            continue
        out.append((k + 1, value))
        k += 1
    return out


def config_strings(path, text):
    # (line, string) pairs: what counts as a string literal in config.
    b = posixpath.basename(path)
    out = []
    if b.endswith(('.plist', '.entitlements')):
        for m in PLIST_STRING.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    elif b.endswith(('.yaml', '.yml')):
        out = yaml_strings(text)
    elif b.endswith('.xcconfig'):
        for n, line in enumerate(text.split('\n'), 1):
            body = line.split('//', 1)[0]
            out.append((n, body.partition('=')[2]))
    else:
        for m in QUOTED.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    return out


SOURCES_LINE = re.compile(r'^([0-9a-f]{64})  (\S+)  (\S.*)$')


def parse_sources(src):
    # {path: (sha256, line)} and findings for malformed or repeated lines.
    entries = {}
    findings = []
    text = src.text(SOURCES) or ''
    for n, line in enumerate(text.split('\n'), 1):
        if not line.strip() or line.startswith('#'):
            continue
        m = SOURCES_LINE.match(line)
        if not m:
            findings.append(Finding(SOURCES, n, 'sources-malformed'))
        elif m.group(2) in entries:
            findings.append(Finding(SOURCES, n, 'sources-repeated'))
        else:
            entries[m.group(2)] = (m.group(1), n)
    return entries, findings
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py`. Expected: `Ran 32 tests`, `OK` (Task 2's 14 and these 18).

**Mutations:** `python3 -I -B tool/checks/tests/mutations.py lex.py guardlib.py`. Expected: mutations 16 to 20 each
`caught`, then `mutations: 5 run, all caught`.

    git add tool/checks && git commit -m "Guards: lexer and library fixes (D16)" -m "<trailer>"

### Task 2b · Fail closed on what the guards don't understand (D17)

Task 2a is committed as `61dcd57`, identical to the plan above, and stays as written. The Opus reviewer of Task 2a
found places where the guards read a file without understanding it, and the owner ruled on them in D17 (2026-11-07).
The reviewer's report is `.scratch/for-build-chat/scaffold-1-review-2a.md`. This task makes the guards refuse what they
cannot read, red then green: each case is a failing test first.

| | Change | Review finding | Test (red first) |
|---|---|---|---|
| R1 | New guard G0 "file kinds", run by `guards.py` before G1: every file must be of a known kind, or it is refused as `unknown-kind`. An unknown `#!` interpreter is `unknown-kind` too | B3 | `G0.test_unknown_kinds_refused`, `G0.test_unknown_shebang_refused`, `G0.test_binary_needs_a_nul_byte`; control `G0.test_known_kinds_pass` |
| R2 | `.tsx` and `.jsx` are no longer TypeScript: they are unknown kinds | B2 | `Library.test_kind_by_extension` (one expectation changed, below); `G0.test_unknown_kinds_refused` |
| R3 | Swift: a `/` where a regex literal could start raises `LexError`. Ordinary division still lexes | B1 | `test_fail_closed.Swift.test_slash_where_regex_could_start_raises`; control `test_fail_closed.Swift.test_division_still_lexes` |
| R4 | Shell: a heredoc word that starts with a digit raises `LexError` | B5 | `test_fail_closed.Shell.test_heredoc_word_starting_with_digit_raises` |
| R5 | F10's prose in Task 2a corrected to match its code and test. No code change | A/B-1 | None new: `Shell.test_arithmetic_is_code` already asserts it |

Findings B4 and B6 and the reviewer's seven minor notes are banked in Status.md (Task 15), as D17 says. The new tests
are in two new files, `test_g0.py` and `test_fail_closed.py`.

**How the changes work.**
- **R1:** `tool/checks/g0_kinds.py` decides, for each file, in this order:
  1. `Source.kind` gives it a code kind or `config`: known.
  2. An extensionless file whose first bytes are `#!` names an interpreter `kind` does not know: refused, whatever
     its name.
  3. Its extension is `.md` or `.csv` (in any case), its name is `.gitignore` or a lockfile (`guardlib.LOCKFILES`),
     or its path is `docs/source/SOURCES` or `tool/checks/awaiting-import`: known, and not scanned.
  4. It holds a NUL byte: known as binary.
  5. Anything else is refused: other text, and a file that cannot be read (a secret name, which G7 also refuses).

  The lists are built for this branch's tree only. A branch that brings a new kind of file (an Objective-C header, an
  XML file, an image without a NUL byte) extends them in `g0_kinds.py`, and the owner approves the change at the
  prompt. G0 names the path only, like every guard. `guards.py` runs it first (Task 11). As Task 2a's F7 prose says,
  a file of an unknown kind was silently unscanned (finding B3); it is now refused.
- **R2:** `.tsx` and `.jsx` leave `CODE_EXT`. JSX is not TypeScript: the `/` of `</b>` reads as a regex start and can
  hide code (finding B2). They now fall to G0. `test_kind_by_extension` is changed to expect `None` for both. This
  is the rule changing by the owner's ruling, not a test weakened: the changed test fails until the code changes.
- **R3:** In Swift, a `/` where `regex_allowed()` says an operand may begin raises `LexError('regex')`: at the start,
  after an operator, `(`, `,`, `=`, `#`, a keyword such as `return`, or the `)` of `if`, `while`, `for` or `with`.
  After a name, a number, a string, `]` or any other `)` it divides, as before. As Task 2a's F7 prose says, a regex
  literal could hide code without making the file unlexable (finding B1); now its opening `/` does.
- **R4:** `heredoc_start` raises `LexError('heredoc')` when the word, quoted or not, starts with a digit. So
  `(( y = 1 << 3 ))`, `let x=1<<2` and `$[1<<2]` make the file unlexable, instead of hiding every line up to one
  that reads `3` or `2` (finding B5). `$(( ))` is still read as arithmetic (F10).
- **R5:** Task 2a's F10 line now says what its code and test do: inside double quotes, `$(( ))` is skipped whole, so
  `<<` in it starts no heredoc, but it is blanked as part of the string.

**Red.** Write the two test files, change one expectation in `test_guardlib.py`, and add the two mutation rows:

**File `tool/checks/tests/test_g0.py`**

~~~~python
# Task 2b (D17): G0 file kinds.
import unittest

from helpers import GuardTest
import g0_kinds


class G0(GuardTest):
    guard = g0_kinds

    def test_known_kinds_pass(self):
        self.passed({'app/lib/a.dart': '', 'server/src/a.ts': '', 'app/ios/a.swift': '',
                     'tool/a.py': '', 'tool/a.sh': '', '.githooks/pre-commit': '#!/bin/sh\n',
                     'app/pubspec.yaml': '', '.claude/settings.json': '{}\n',
                     'docs/a.md': '', 'app/assets/words/places-register.csv': '',
                     '.gitignore': '', 'docs/source/SOURCES': '',
                     'tool/checks/awaiting-import': '', 'server/package-lock.json': '',
                     'app/pubspec.lock': '', 'app/icon.png': b'\x89PNG\r\n\x1a\n\0\0'})

    def test_unknown_kinds_refused(self):
        for path in ('a.tsx', 'a.jsx', 'a.mts', 'a.m', 'a.h', 'a.kt', 'a.txt', 'Makefile',
                     'docs/SOURCES', 'app/awaiting-import'):
            found = self.refused({path: 'x\n'})
            self.assertEqual(found, [(path, 0, 'unknown-kind')])

    def test_unknown_shebang_refused(self):
        for body in ('#!/usr/bin/perl\n', '#!/usr/bin/env deno\n',
                     '#!/usr/bin/env -u HOME python3\n'):
            self.refused({'tool/run': body}, 'unknown-kind')
        self.refused({'tool/checks/awaiting-import': '#!/usr/bin/perl\n'}, 'unknown-kind')

    def test_binary_needs_a_nul_byte(self):
        self.passed({'a.bin': b'\0\xff'})
        self.refused({'a.bin': b'\xff\xfe'}, 'unknown-kind')


if __name__ == '__main__':
    unittest.main()
~~~~

**File `tool/checks/tests/test_fail_closed.py`**

~~~~python
# Task 2b (D17): fail closed where the lexers cannot tell.
import unittest

import helpers  # noqa: F401
import lex


class Swift(unittest.TestCase):
    def test_slash_where_regex_could_start_raises(self):
        for src in ('let r = /"/; print(x); let t = /"/\n',
                    'let r = #/"/#; print(x); let t = #/"/#\n',
                    'let r = /https?:\\/\\//; print(x)\n',
                    'let r = /[/*]/; print(x); let q = /[*/]/\n'):
            with self.assertRaises(lex.LexError):
                lex.lex_swift(src)

    def test_division_still_lexes(self):
        for src in ('let a = b / 2\n', 'let c = (a + 1) / x[0] / f(2)\n'):
            lx = lex.lex_swift(src)
            self.assertEqual(lx.lits, [])
            self.assertEqual(lx.code, src)


class Shell(unittest.TestCase):
    def test_heredoc_word_starting_with_digit_raises(self):
        for src in ('(( y = 1 << 3 ))\nlog_it\n3\n', 'let x=1<<2\n2\n',
                    'echo $[1<<2]\n2\n', "cat <<'2'\nx\n2\n"):
            with self.assertRaises(lex.LexError):
                lex.lex_shell(src)
        lx = lex.lex_shell('cat <<EOF2\nbody\nEOF2\necho done\n')
        self.assertEqual([l.text for l in lx.lits], ['body\n'])


if __name__ == '__main__':
    unittest.main()
~~~~

**Edit `tool/checks/tests/test_guardlib.py` (R2).** Replace

~~~~python
        self.assertEqual(got, {'a.mjs': 'ts', 'a.cjs': 'ts', 'a.tsx': 'ts', 'a.jsx': 'ts',
~~~~

with

~~~~python
        self.assertEqual(got, {'a.mjs': 'ts', 'a.cjs': 'ts', 'a.tsx': None, 'a.jsx': None,
~~~~

**Edit `tool/checks/tests/mutations.py`.** Replace

~~~~python
     ['test_guardlib.Library.test_secret_names_ignore_case']),
]
~~~~

with

~~~~python
     ['test_guardlib.Library.test_secret_names_ignore_case']),
    ('g0_kinds.py', "return data is not None and b'\\0' in data", "return True",
     ['test_g0.G0.test_unknown_kinds_refused']),
    ('lex.py', "if c == '/' and self.regex_allowed():\n                    raise LexError('regex')",
     "if False:\n                    raise LexError('regex')",
     ['test_fail_closed.Swift.test_slash_where_regex_could_start_raises']),
]
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_g0`. Expected: exit 1, `ModuleNotFoundError: No module named
'g0_kinds'`.

Run `python3 -I -B tool/checks/tests/run_tests.py test_fail_closed test_guardlib`. Expected: exit 1, `Ran 10 tests`,
`FAILED (failures=3)`:
- `test_slash_where_regex_could_start_raises` and `test_heredoc_word_starting_with_digit_raises`: `LexError not
  raised`.
- `test_kind_by_extension`: `.tsx` and `.jsx` are still `ts`.

`test_division_still_lexes` passes here and after: it is the control that proves R3 does not break division.

**Green.** Write G0 and make four replacements, two in each file:

**File `tool/checks/g0_kinds.py`**

~~~~python
# G0 file kinds: every file must be of a kind the guards know, so that
# nothing goes unread by mistake. Known: guardlib's code kinds and
# config, and the unscanned types, names and paths below. A file with an
# unknown '#!' interpreter, or of any other kind, is refused as
# unknown-kind. A branch that brings a new kind of file extends these
# lists, and the owner approves the change at the prompt.
import posixpath

from guardlib import LOCKFILES, MARKER, SOURCES, Finding

CODE = 'G0'
NAME = 'file kinds'
UNSCANNED_EXT = ('.md', '.csv')
UNSCANNED_NAMES = ('.gitignore',) + LOCKFILES
UNSCANNED_PATHS = (SOURCES, MARKER)


def known(src, path):
    if src.kind(path) is not None:
        return True
    b = posixpath.basename(path)
    ext = posixpath.splitext(b)[1].lower()
    data = src.read(path)
    if ext == '' and data is not None and data.startswith(b'#!'):
        return False
    if ext in UNSCANNED_EXT or b in UNSCANNED_NAMES or path in UNSCANNED_PATHS:
        return True
    # A binary file: one with a NUL byte. Other text is not known.
    return data is not None and b'\0' in data


def check(src):
    return [Finding(p, 0, 'unknown-kind') for p in src.paths if not known(src, p)], []
~~~~

**Edit `tool/checks/guardlib.py`, R2.** Replace

~~~~python
CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.mjs': 'ts', '.cjs': 'ts',
            '.tsx': 'ts', '.jsx': 'ts', '.swift': 'swift', '.py': 'py', '.sh': 'sh'}
~~~~

with

~~~~python
CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.mjs': 'ts', '.cjs': 'ts',
            '.swift': 'swift', '.py': 'py', '.sh': 'sh'}
~~~~

**Edit `tool/checks/guardlib.py`, the comment on `kind`.** Replace

~~~~python
        # 'dart', 'ts', 'swift', 'py', 'sh', 'config' or None (not
        # scanned by G3 to G6, G8 and G9). Markdown and lockfiles are
        # None; code under docs/ is scanned like code anywhere else.
~~~~

with

~~~~python
        # 'dart', 'ts', 'swift', 'py', 'sh', 'config' or None (not
        # scanned by G3 to G6, G8 and G9). Markdown and lockfiles are
        # None; code under docs/ is scanned like code anywhere else.
        # G0 refuses a None file unless its kind is listed as unscanned.
~~~~

**Edit `tool/checks/lex.py`, R3.** Replace

~~~~python
            if self.lang == 'swift':
                if c in '"#' and self.swift_string_at(i):
~~~~

with

~~~~python
            if self.lang == 'swift':
                # Swift's regex literals are not read: a '/' where one
                # could start makes the file unlexable (fail closed).
                if c == '/' and self.regex_allowed():
                    raise LexError('regex')
                if c in '"#' and self.swift_string_at(i):
~~~~

**Edit `tool/checks/lex.py`, R4.** Replace

~~~~python
        if not word:
            raise LexError('heredoc')
~~~~

with

~~~~python
        # A word that starts with a digit is a shift in arithmetic, as
        # in (( 1 << 3 )), let x=1<<2 or $[1<<2]. Refused (fail closed).
        if not word or word[0].isdigit():
            raise LexError('heredoc')
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py`. Expected: `Ran 39 tests`, `OK` (Task 2a's 32 and these 7).

**Mutations:** `python3 -I -B tool/checks/tests/mutations.py g0_kinds.py lex.py guardlib.py`. Expected: mutations 16 to
22 each `caught`, then `mutations: 7 run, all caught`.

    git add tool/checks && git commit -m "Guards: G0 file kinds; fail closed on Swift regexes and digit heredoc words (D17)" -m "<trailer>"

### Task 2c · Fail closed on undecodable text; try before a Swift regex

Task 2b is committed as `ef4360c`, identical to the plan above, and stays as written. The Opus reviewer of Task 2b
found two places where the plan says the guards fail closed and they do not, and the owner ruled on them on
2026-11-07. The reviewer's report is `.scratch/for-build-chat/scaffold-1-review-2b.md`. This task makes both fail
closed, red then green: each case is a failing test first.

| | Change | Review finding | Test (red first) |
|---|---|---|---|
| C1 | G0: `.md`, `.csv` and every listed name or path are known only when `src.text(path)` is not `None`: the file decodes as UTF-8 and holds no NUL byte. Otherwise `unknown-kind` | S1 | `G0.test_undecodable_unscanned_refused`; control `G0.test_utf8_unscanned_pass` |
| C2 | Swift: `try` joins the words after which a `/` starts a regex. Swift only, so TypeScript is unchanged | S2 | `test_fail_closed.Swift.test_slash_after_try_raises`; control `test_fail_closed.Swift.test_division_near_try_still_lexes` |

The reviewer's K1 to K4 and the notes the owner named are banked in Status.md (Task 15). The new tests go into the
existing `test_g0.py` and `test_fail_closed.py`.

**How the changes work.**
- **C1:** step 3 of G0 (Task 2b) no longer returns "known" on the name alone. A file with a listed extension, name or
  path is known only when `guardlib.Source.text()` reads it: UTF-8, no NUL byte. A Latin-1 Markdown note, a CSV saved
  from Excel as Windows-1252 or as UTF-16, or a listed name holding a NUL byte is refused as `unknown-kind`, and does
  not fall through to step 4 as binary. So no file that G7 would skip unread (its `if text is None: continue`) passes
  G0 as a kind the guards know. Binary files of other kinds (step 4) are unchanged.
- **C2:** `regex_allowed()` also returns true after the name `try` when the language is Swift. So the `/` in
  `try /(\d+)x/.wholeMatch(in: s)`, Apple's own form, raises `LexError('regex')`, as Task 2b's R3 prose says. `try!`
  and `try?` already raised, because their `/` follows `!` or `?`. Division after a call that follows `try`, as in
  `try f(x) / 2`, and after names such as `retry` or `tryCount`, still lexes.

**Red.** Make two replacements in the tests and add the mutation row:

**Edit `tool/checks/tests/test_g0.py` (C1).** Replace

~~~~python
    def test_binary_needs_a_nul_byte(self):
        self.passed({'a.bin': b'\0\xff'})
        self.refused({'a.bin': b'\xff\xfe'}, 'unknown-kind')
~~~~

with

~~~~python
    def test_binary_needs_a_nul_byte(self):
        self.passed({'a.bin': b'\0\xff'})
        self.refused({'a.bin': b'\xff\xfe'}, 'unknown-kind')

    def test_undecodable_unscanned_refused(self):
        # Task 2c (C1): a listed kind is known only as UTF-8 text with no
        # NUL byte. The euro sign has no Latin-1 byte: the CSV is cp1252.
        self.refused({'docs/a.md': 'word é\n'.encode('latin-1')}, 'unknown-kind')
        self.refused({'app/assets/words/places-register.csv': 'word,€\n'.encode('cp1252')},
                     'unknown-kind')
        for path in ('docs/a.md', 'a.CSV', '.gitignore', 'server/package-lock.json',
                     'docs/source/SOURCES', 'tool/checks/awaiting-import'):
            for body in (b'word\0\n', b'word \xff\n', 'word\n'.encode('utf-16')):
                found = self.refused({path: body})
                self.assertEqual(found, [(path, 0, 'unknown-kind')])

    def test_utf8_unscanned_pass(self):
        self.passed({'docs/a.md': 'word é\n',
                     'app/assets/words/places-register.csv': 'word,€\n'})
~~~~

**Edit `tool/checks/tests/test_fail_closed.py` (C2).** Replace

~~~~python
    def test_division_still_lexes(self):
        for src in ('let a = b / 2\n', 'let c = (a + 1) / x[0] / f(2)\n'):
            lx = lex.lex_swift(src)
            self.assertEqual(lx.lits, [])
            self.assertEqual(lx.code, src)
~~~~

with

~~~~python
    def test_division_still_lexes(self):
        for src in ('let a = b / 2\n', 'let c = (a + 1) / x[0] / f(2)\n'):
            lx = lex.lex_swift(src)
            self.assertEqual(lx.lits, [])
            self.assertEqual(lx.code, src)

    def test_slash_after_try_raises(self):
        # Task 2c (C2): Apple's own form puts a regex after try.
        with self.assertRaises(lex.LexError):
            lex.lex_swift('if let m = try /(\\d+)x/.wholeMatch(in: s) {}\n')

    def test_division_near_try_still_lexes(self):
        for src in ('let a = try f(x) / 2\n', 'let b = retry / 2\n',
                    'let c = tryCount / 2\n'):
            lx = lex.lex_swift(src)
            self.assertEqual(lx.lits, [])
            self.assertEqual(lx.code, src)
        # TypeScript is unchanged: there, a '/' after try divides.
        lx = lex.lex_ts('let d = o.try / 2 / 3\n')
        self.assertEqual(lx.lits, [])
~~~~

**Edit `tool/checks/tests/mutations.py`.** Replace

~~~~python
     ['test_fail_closed.Swift.test_slash_where_regex_could_start_raises']),
]
~~~~

with

~~~~python
     ['test_fail_closed.Swift.test_slash_where_regex_could_start_raises']),
    ('g0_kinds.py', "return src.text(path) is not None", "return True",
     ['test_g0.G0.test_undecodable_unscanned_refused']),
]
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_g0 test_fail_closed`. Expected: exit 1, `Ran 11 tests`,
`FAILED (failures=2)`:
- `test_undecodable_unscanned_refused`: `expected a refusal`.
- `test_slash_after_try_raises`: `LexError not raised`.

`test_utf8_unscanned_pass` and `test_division_near_try_still_lexes` pass here and after: they are the controls that
prove C1 and C2 do not refuse what they should not.

**Green.** Make two replacements in `g0_kinds.py` and two in `lex.py`:

**Edit `tool/checks/g0_kinds.py`, the header (C1).** Replace

~~~~python
# nothing goes unread by mistake. Known: guardlib's code kinds and
# config, and the unscanned types, names and paths below. A file with an
# unknown '#!' interpreter, or of any other kind, is refused as
~~~~

with

~~~~python
# nothing goes unread by mistake. Known: guardlib's code kinds and
# config, binary files (a NUL byte), and the unscanned types, names and
# paths below when they read as UTF-8 text. A file with an
# unknown '#!' interpreter, or of any other kind, is refused as
~~~~

**Edit `tool/checks/g0_kinds.py`, step 3 (C1).** Replace

~~~~python
    if ext in UNSCANNED_EXT or b in UNSCANNED_NAMES or path in UNSCANNED_PATHS:
        return True
~~~~

with

~~~~python
    if ext in UNSCANNED_EXT or b in UNSCANNED_NAMES or path in UNSCANNED_PATHS:
        # Known only as UTF-8 text with no NUL byte. Otherwise no guard
        # can read it (G7 skips it), so it is refused (fail closed).
        return src.text(path) is not None
~~~~

**Edit `tool/checks/lex.py`, the Swift keyword (C2).** Replace

~~~~python
# A '/' after the ')' of one of these starts a regex: if (a) /x/.test(b)
PAREN_KEYWORDS = {'if', 'while', 'for', 'with'}
~~~~

with

~~~~python
# A '/' after the ')' of one of these starts a regex: if (a) /x/.test(b)
PAREN_KEYWORDS = {'if', 'while', 'for', 'with'}
# Swift only: a '/' after one of these can start a regex, as in
# try /x/.wholeMatch(in: s). TypeScript is unchanged.
SWIFT_REGEX_KEYWORDS = {'try'}
~~~~

**Edit `tool/checks/lex.py`, `regex_allowed` (C2).** Replace

~~~~python
        if kind == 'id':
            return value in REGEX_KEYWORDS
~~~~

with

~~~~python
        if kind == 'id':
            return value in REGEX_KEYWORDS or (
                self.lang == 'swift' and value in SWIFT_REGEX_KEYWORDS)
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py`. Expected: `Ran 43 tests`, `OK` (Task 2b's 39 and these 4).

**Mutations:** `python3 -I -B tool/checks/tests/mutations.py g0_kinds.py lex.py guardlib.py`. Expected: mutations 16 to
23 each `caught`, then `mutations: 8 run, all caught`.

    git add tool/checks && git commit -m "Guards: fail closed on undecodable text; try before a Swift regex (Task 2c)" -m "<trailer>"

### Task 2d · Every readable kind must decode

Task 2c is committed as `18c428b`, identical to the plan above, and stays as written. The Opus reviewer of Task 2c
found that a config file that does not decode passes G0 while no later guard reads it, and that one of Task 2c's
controls does not catch the break it is there for. The owner ruled on 2026-11-09. The reviewer's report is
`.scratch/for-build-chat/scaffold-1-review-2c.md`. This task is red then green: each case is a failing test, or a
surviving mutation, first.

| | Change | Review finding | Test (red first) |
|---|---|---|---|
| D1 | G0: a config file is known only when `src.text(path)` is not `None`: it decodes as UTF-8 and holds no NUL byte. Otherwise `unknown-kind` | S1 | `G0.test_undecodable_config_refused`; control `G0.test_utf8_config_passes`; mutation 24 |
| D2 | `test_division_near_try_still_lexes`: its TypeScript case also asserts `lx.code == src` | Weak test | Mutation 25, which drops `self.lang == 'swift' and`, survives the test as it was, then is caught |
| D3 | The sweep below. Its one place that read nothing for a file G0 accepts, G6 and G7 on code that does not decode, is closed by the same G0 line as D1: code too is known only when it decodes | Owner's sweep | `G0.test_undecodable_code_refused` |

The new tests go into the existing `test_g0.py` and `test_fail_closed.py`.

**The sweep (D3).** Every place in `tool/checks`, as built by this plan to Task 11, where `src.text()`, `src.read()`
or `src.lexed()` can return `None`, and what happens there. `read()` is `None` for a secret name, and in `walk` and
`tracked` modes for a symlink or a file missing from the working tree; `text()` also for a NUL byte or bytes that are
not UTF-8; `lexed()` also when the lexer raises.

| # | Place | On `None` |
|---|---|---|
| 1 | `guardlib.Source.kind`, an extensionless file (`self.text`) | No kind; G0 decides (rows 4 to 7) |
| 2 | `guardlib.Source.lexed` (`self.text`) | `None`; every caller reports `unlexable` |
| 3 | `guardlib.parse_sources` (`src.text(SOURCES) or ''`) | Reads nothing; G0 refuses that `SOURCES` (row 6) |
| 4 | G0 step 1, code and config (`src.kind`) | **Read nothing until this task**: known without being read. Now refused (D1, D3) |
| 5 | G0 step 2, the `#!` test (`src.read`) | Not a `#!` file; falls to steps 3 and 4 |
| 6 | G0 step 3, the listed kinds (`src.text`) | Refused, `unknown-kind` (Task 2c) |
| 7 | G0 step 4, binary (`data`) | Refused, `unknown-kind` |
| 8 | G1 and G2, `parse_sources` | As row 3 |
| 9 | G1 and G2, `sha256(src.read(path))` | A `TypeError`: `guards.py` stops with `internal error`, exit 2. Fails closed, with no finding |
| 10 | G3, G4, G5, G8 and G9 on code (`src.lexed`) | Finding, `unlexable` |
| 11 | G4, G5 and G9 on config (`src.text(path) or ''`) | Reads nothing; G0 refuses the file (row 4, D1) |
| 12 | G6, code and config (`if text is None: continue`) | Reads nothing; G0 refuses the file (row 4, D1 and D3) |
| 13 | G7, every file (`if text is None: continue`) | Reads nothing. G0 refuses every such file but one kind: binary files (a NUL byte), skipped by design (Part 1; Part 4, Q4; banked K4) |

**How the changes work.**
- **D1 and D3:** a new first test in G0's `known()`: a file with a code kind or `config` whose `src.text()` is `None`
  is refused. For config this is the reviewer's rule (`return src.kind(path) != 'config' or src.text(path) is not
  None`), written as a refusal before step 1 so that one line also covers code (D3) and mutation 23's pattern stays
  unique. A UTF-16 `package.json`, a Latin-1 `pubspec.yaml` or a binary `Info.plist`, and a code file in Latin-1,
  UTF-16 or with a NUL byte, are refused as `unknown-kind`. An undecodable code file was already refused as
  `unlexable` by G4 or G5, which between them read every code path; it is now also refused by G0, so G6 and G7 no
  longer skip a file G0 accepts. Extensionless scripts are unchanged: they have a kind only when they decode.
- **D2:** with `self.lang == 'swift' and` removed, `try` starts a regex in TypeScript too, and in
  `let d = o.try / 2 / 3` the regex `/ 2 /` swallows the division. There are no literals either way, so the test as it
  was passes. Comparing the code whole catches it.

**Red.** Make two replacements in `test_g0.py` and add the two mutation rows:

**Edit `tool/checks/tests/test_g0.py`, the imports (D1).** Replace

~~~~python
import unittest

from helpers import GuardTest
import g0_kinds
~~~~

with

~~~~python
import plistlib
import unittest

from helpers import GuardTest
import g0_kinds
~~~~

**Edit `tool/checks/tests/test_g0.py`, the tests (D1, D3).** Replace

~~~~python
    def test_utf8_unscanned_pass(self):
        self.passed({'docs/a.md': 'word é\n',
                     'app/assets/words/places-register.csv': 'word,€\n'})
~~~~

with

~~~~python
    def test_utf8_unscanned_pass(self):
        self.passed({'docs/a.md': 'word é\n',
                     'app/assets/words/places-register.csv': 'word,€\n'})

    def test_undecodable_config_refused(self):
        # Task 2d (D1): config is known only as UTF-8 text with no NUL
        # byte. G4, G5 and G9 would read it as empty; G6 and G7 skip it.
        cases = {'server/package.json': '{"name": "word"}\n'.encode('utf-16'),
                 'app/pubspec.yaml': 'name: word é\n'.encode('latin-1'),
                 'app/ios/Runner/Info.plist': plistlib.dumps({'k': 'word'},
                                                             fmt=plistlib.FMT_BINARY)}
        for path, body in cases.items():
            found = self.refused({path: body})
            self.assertEqual(found, [(path, 0, 'unknown-kind')])

    def test_utf8_config_passes(self):
        self.passed({'server/package.json': '{"name": "word"}\n',
                     'app/pubspec.yaml': 'name: word é\n',
                     'app/ios/Runner/Info.plist': plistlib.dumps({'k': 'word'})})

    def test_undecodable_code_refused(self):
        # Task 2d (D3): code too. G4 and G5 call it unlexable, but G6 and
        # G7 skip a file that does not decode.
        cases = {'app/lib/a.dart': "const s = 'é';\n".encode('latin-1'),
                 'server/src/a.ts': 'let a = 1;\n'.encode('utf-16'),
                 'app/ios/a.swift': b'let a = 1\0\n',
                 'tool/a.py': b'a = 1 \xff\n',
                 'tool/a.sh': b'a=1\0\n'}
        for path, body in cases.items():
            found = self.refused({path: body})
            self.assertEqual(found, [(path, 0, 'unknown-kind')])
~~~~

**Edit `tool/checks/tests/mutations.py`.** Replace

~~~~python
     ['test_g0.G0.test_undecodable_unscanned_refused']),
]
~~~~

with

~~~~python
     ['test_g0.G0.test_undecodable_unscanned_refused']),
    ('g0_kinds.py', "if src.kind(path) is not None and src.text(path) is None:", "if False:",
     ['test_g0.G0.test_undecodable_config_refused']),
    ('lex.py', "self.lang == 'swift' and value in", "value in",
     ['test_fail_closed.Swift.test_division_near_try_still_lexes']),
]
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_g0 test_fail_closed`. Expected: exit 1, `Ran 14 tests`,
`FAILED (failures=2)`: `test_undecodable_config_refused` and `test_undecodable_code_refused`, each `expected a
refusal`. `test_utf8_config_passes` passes here and after: it is the control that proves D1 does not refuse UTF-8
config.

Run `python3 -I -B tool/checks/tests/mutations.py lex.py`. Expected: exit 1, mutations 16 to 19 and 22 each `caught`,
`mutation 25 lex.py: SURVIVED`, then `mutations: 6 run, FAILED`. This is the reviewer's finding: the test does not
catch the break.

**Edit `tool/checks/tests/test_fail_closed.py` (D2).** Replace

~~~~python
        # TypeScript is unchanged: there, a '/' after try divides.
        lx = lex.lex_ts('let d = o.try / 2 / 3\n')
        self.assertEqual(lx.lits, [])
~~~~

with

~~~~python
        # TypeScript is unchanged: there, a '/' after try divides.
        src = 'let d = o.try / 2 / 3\n'
        lx = lex.lex_ts(src)
        self.assertEqual(lx.lits, [])
        self.assertEqual(lx.code, src)
~~~~

Run `python3 -I -B tool/checks/tests/mutations.py lex.py`. Expected: mutations 16 to 19, 22 and 25 each `caught`, then
`mutations: 6 run, all caught`.

**Green.** Make two replacements in `g0_kinds.py`:

**Edit `tool/checks/g0_kinds.py`, the header (D1, D3).** Replace

~~~~python
# nothing goes unread by mistake. Known: guardlib's code kinds and
# config, binary files (a NUL byte), and the unscanned types, names and
# paths below when they read as UTF-8 text. A file with an
~~~~

with

~~~~python
# nothing goes unread by mistake. Known: guardlib's code kinds, config,
# and the unscanned types, names and paths below, each only when it
# reads as UTF-8 text; and binary files (a NUL byte). A file with an
~~~~

**Edit `tool/checks/g0_kinds.py`, `known` (D1, D3).** Replace

~~~~python
def known(src, path):
    if src.kind(path) is not None:
        return True
~~~~

with

~~~~python
def known(src, path):
    if src.kind(path) is not None and src.text(path) is None:
        # Code and config are read as text. One that is not UTF-8 with no
        # NUL byte is skipped by G6 and G7, and config is read as empty by
        # G4, G5 and G9: refused (fail closed; Task 2d, D1 and D3).
        return False
    if src.kind(path) is not None:
        return True
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py`. Expected: `Ran 46 tests`, `OK` (Task 2c's 43 and these 3).

**Mutations:** `python3 -I -B tool/checks/tests/mutations.py g0_kinds.py lex.py guardlib.py`. Expected: mutations 16 to
25 each `caught`, then `mutations: 10 run, all caught`.

    git add tool/checks && git commit -m "Guards: every readable kind must decode (Task 2d)" -m "<trailer>"

### Task 3 · G1 words and G2 copies, with the awaiting-import marker (D5)

**Red.**

**File `tool/checks/tests/test_g1_g2.py`**

~~~~python
import hashlib
import unittest

from helpers import GuardTest
import g1_words
import g2_copies

MARKER = 'tool/checks/awaiting-import'
SOURCES = 'docs/source/SOURCES'
CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'
COPY = 'docs/source/handover.md'


def line(path, body, ordinal='C0-T item 1'):
    return hashlib.sha256(body.encode('utf-8')).hexdigest() + '  ' + path + '  ' + ordinal + '\n'


class G1(GuardTest):
    guard = g1_words

    def test_marker_alone_is_not_armed(self):
        notes = self.passed({MARKER: 'x\n'})
        self.assertEqual(notes, ['NOT ARMED (awaiting import)'])

    def test_marker_with_sources_refuses(self):
        self.refused({MARKER: 'x\n', SOURCES: '# empty\n'}, 'marker-with-sources')

    def test_no_marker_no_sources_refuses(self):
        self.refused({}, 'no-sources')

    def test_words_hash_mismatch_refuses(self):
        files = {CSV: 'a,b\n', LISTS: 'l\n', SOURCES: line(CSV, 'changed\n') + line(LISTS, 'l\n')}
        found = self.refused(files, 'hash-mismatch')
        self.assertIn((CSV, 0, 'hash-mismatch'), found)
        self.assertNotIn((LISTS, 0, 'hash-mismatch'), found)

    def test_words_unlisted_refuses(self):
        self.refused({CSV: 'a\n', SOURCES: line(LISTS, 'l\n'), LISTS: 'l\n'}, 'unlisted')

    def test_armed_refuses_until_generator_is_built(self):
        files = {CSV: 'a\n', LISTS: 'l\n', SOURCES: line(CSV, 'a\n') + line(LISTS, 'l\n')}
        found = self.refused(files)
        self.assertEqual([f[2] for f in found], ['generator-not-built'])


class G2(GuardTest):
    guard = g2_copies

    def test_marker_alone_is_not_armed(self):
        notes = self.passed({MARKER: 'x\n'})
        self.assertEqual(notes, ['NOT ARMED (awaiting import)'])

    def test_marker_with_sources_refuses(self):
        self.refused({MARKER: 'x\n', SOURCES: '# empty\n'}, 'marker-with-sources')

    def test_marker_with_any_copy_refuses(self):
        self.refused({MARKER: 'x\n', COPY: 'h\n'}, 'marker-with-sources')

    def test_no_marker_no_sources_refuses(self):
        self.refused({}, 'no-sources')

    def test_matching_copy_passes(self):
        self.passed({COPY: 'h\n', SOURCES: line(COPY, 'h\n')})

    def test_hash_mismatch_refuses(self):
        self.refused({COPY: 'h\n', SOURCES: line(COPY, 'other\n')}, 'hash-mismatch')

    def test_unlisted_copy_refuses(self):
        self.refused({COPY: 'h\n', 'docs/source/extra.md': 'e\n', SOURCES: line(COPY, 'h\n')},
                     'unlisted')

    def test_listed_but_missing_refuses(self):
        self.refused({SOURCES: line(COPY, 'h\n')}, 'missing')

    def test_malformed_line_refuses(self):
        self.refused({SOURCES: 'not a line\n'}, 'sources-malformed')

    def test_unknown_path_outside_docs_source_refuses(self):
        self.refused({'app/x.txt': 'h\n', SOURCES: line('app/x.txt', 'h\n')}, 'unknown-path')


if __name__ == '__main__':
    unittest.main()
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_g1_g2`. Expected: exit 1, `No module named 'g1_words'`.

**Green.**

**File `tool/checks/g1_words.py`**

~~~~python
# G1 words: the register's and the lists' hashes match SOURCES, and
# lines.g.dart is what the generator makes. NOT ARMED while the
# awaiting-import marker exists; refuses the marker beside SOURCES.
from guardlib import CSV, LISTS, MARKER, SOURCES, Finding, parse_sources, sha256

CODE = 'G1'
NAME = 'words'
LINES = 'app/lib/words/lines.g.dart'


def check(src):
    marker = src.has(MARKER)
    if marker and src.has(SOURCES):
        return [Finding(MARKER, 0, 'marker-with-sources')], []
    if marker:
        return [], ['NOT ARMED (awaiting import)']
    if not src.has(SOURCES):
        return [Finding(SOURCES, 0, 'no-sources')], []
    entries, findings = parse_sources(src)
    for path in (CSV, LISTS):
        if path not in entries:
            findings.append(Finding(path, 0, 'unlisted'))
        elif not src.has(path):
            findings.append(Finding(path, 0, 'missing'))
        elif sha256(src.read(path)) != entries[path][0]:
            findings.append(Finding(path, 0, 'hash-mismatch'))
    # Branch 3 builds the generator and replaces this line with the
    # comparison of LINES against the generator's output.
    findings.append(Finding(LINES, 0, 'generator-not-built'))
    return findings, []
~~~~

**File `tool/checks/g2_copies.py`**

~~~~python
# G2 copies: every file in docs/source/ is listed in SOURCES with its
# sha256 and matches it. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside any file in docs/source/.
from guardlib import CSV, LISTS, MARKER, SOURCES, Finding, parse_sources, sha256

CODE = 'G2'
NAME = 'copies'
DIR = 'docs/source/'


def check(src):
    in_dir = [p for p in src.paths if p.startswith(DIR)]
    if src.has(MARKER):
        if in_dir:
            return [Finding(p, 0, 'marker-with-sources') for p in in_dir], []
        return [], ['NOT ARMED (awaiting import)']
    if not src.has(SOURCES):
        return [Finding(SOURCES, 0, 'no-sources')], []
    entries, findings = parse_sources(src)
    for path, (digest, line) in sorted(entries.items()):
        if path.startswith(DIR):
            if not src.has(path):
                findings.append(Finding(path, 0, 'missing'))
            elif sha256(src.read(path)) != digest:
                findings.append(Finding(path, 0, 'hash-mismatch'))
        elif path not in (CSV, LISTS):
            findings.append(Finding(SOURCES, line, 'unknown-path'))
    for path in in_dir:
        if path != SOURCES and path not in entries:
            findings.append(Finding(path, 0, 'unlisted'))
    return findings, []
~~~~

**File `tool/checks/awaiting-import`**

~~~~text
G1 and G2 wait for the first import. Branch 3 deletes this file.
~~~~

Expected: `Ran 16 tests`, `OK`. **Mutations:** `… mutations.py g1_words.py g2_copies.py`. Expected: 4 run, all caught.

    git add tool/checks && git commit -m "Guards: G1 words and G2 copies, not armed until the first import" -m "<trailer>"

### Task 4 · G3 no literal words (D10)

**Red.**

**File `tool/checks/tests/test_g3.py`**

~~~~python
import unittest

from helpers import GuardTest, sentence
import g3_literals

A = 'app/lib/a.dart'
MARK = '// not-dreamer-' + 'facing: a test id'


class G3(GuardTest):
    guard = g3_literals

    def test_text_literal_refused(self):
        self.refused({A: "w() => Text('Hi');\n"}, 'dreamer-literal')

    def test_textspan_and_rich_refused(self):
        found = self.refused({A: "w() => Text.rich(TextSpan(text: 'a'));\n"})
        self.assertEqual(found, [(A, 1, 'dreamer-literal')])

    def test_named_arguments_refused(self):
        for name in ('semanticsLabel', 'semanticLabel', 'tooltip', 'label', 'title', 'hintText'):
            self.refused({A: 'w() => f(%s: "x");\n' % name}, 'dreamer-literal')

    def test_parenthesised_named_argument_refused(self):
        self.refused({A: "w() => f(tooltip: ('x'));\n"}, 'dreamer-literal')

    def test_prefixed_text_refused(self):
        self.refused({A: "w() => m.Text('x');\n"}, 'dreamer-literal')

    def test_marker_does_not_excuse_dreamer_literal(self):
        self.refused({A: "w() => Text('a b c'); " + MARK + '\n'}, 'dreamer-literal')

    def test_inside_words_passes(self):
        self.passed({'app/lib/words/lines.g.dart': "w() => Text('Hi'); const s = 'a b c';\n"})

    def test_three_words_unmarked_refused(self):
        self.refused({A: "const s = 'one two three';\n"}, 'unmarked-literal')

    def test_two_words_pass(self):
        self.passed({A: "const s = 'one two';\n"})

    def test_three_words_marked_pass(self):
        self.passed({A: "const s = 'one two three'; " + MARK + '\n'})

    def test_marker_needs_a_reason(self):
        self.refused({A: "const s = 'one two three'; // not-dreamer-facing:\n"}, 'unmarked-literal')

    def test_marker_on_another_line_refused(self):
        self.refused({A: MARK + "\nconst s = 'one two three';\n"}, 'unmarked-literal')

    def test_lookup_inside_text_passes(self):
        self.passed({A: "w() => Text(lines['k']);\n"})

    def test_outside_app_lib_not_scanned(self):
        self.passed({'app/test/a_test.dart': "w() => Text('Hi');\n",
                     'server/src/a.ts': "const s = '%s';\n" % sentence(5)})

    def test_unlexable_refused(self):
        self.refused({A: "const s = 'open;\n"}, 'unlexable')


if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_g3`. Expected: exit 1, `No module named 'g3_literals'`.

**Green.**

**File `tool/checks/g3_literals.py`**

~~~~python
# G3 no literal words (app/lib/ only). A literal passed directly to
# Text, Text.rich or TextSpan, or as one of the named arguments below,
# is dreamer-facing and refused outside app/lib/words/. Any other
# literal of more than two words needs the not-dreamer-facing marker
# in a comment on a line the literal occupies.
import re

from guardlib import Finding, words

CODE = 'G3'
NAME = 'no literal words'
CALLS = ('Text', 'TextSpan')
NAMED = ('semanticsLabel', 'semanticLabel', 'tooltip', 'label', 'title', 'hintText')
MARK = re.compile(r'^//\s*not-dreamer-facing:\s*\S')


def in_scope(path):
    return (path.startswith('app/lib/') and path.endswith('.dart')
            and not path.startswith('app/lib/words/'))


def dreamer_facing(lit):
    last = lit.frame.rsplit('.', 1)[-1]
    return last in CALLS or lit.frame.endswith('Text.rich') or lit.named in NAMED


def check(src):
    findings = []
    for path in src.paths:
        if not in_scope(path):
            continue
        lx = src.lexed(path)
        if lx is None:
            findings.append(Finding(path, 0, 'unlexable'))
            continue
        marked = {c.line for c in lx.comments if MARK.match(c.text)}
        for lit in lx.lits:
            if dreamer_facing(lit):
                findings.append(Finding(path, lit.line, 'dreamer-literal'))
            elif words(lit.text) > 2 and not marked.intersection(
                    range(lit.line, lit.end_line + 1)):
                findings.append(Finding(path, lit.line, 'unmarked-literal'))
    return findings, []
~~~~

Expected: `Ran 15 tests`, `OK`. **Mutations:** `… mutations.py g3_literals.py`. Expected: 3 run, all caught.

    git add tool/checks && git commit -m "Guards: G3 no literal words" -m "<trailer>"

### Task 5 · G4 invented only

**Red.**

**File `tool/checks/tests/test_g4.py`**

~~~~python
import unittest

from helpers import GuardTest, sentence
import g4_invented


def ts(n):
    return "export const s = '%s';\n" % sentence(n)


class G4(GuardTest):
    guard = g4_invented

    def test_twelve_words_refused_in_each_language(self):
        bodies = {
            'server/src/a.ts': ts(12),
            'app/test/a_test.dart': "const s = '%s';\n" % sentence(12),
            'tool/a.py': "s = '%s'\n" % sentence(12),
            'tool/a.sh': "s='%s'\n" % sentence(12),
        }
        for path, body in bodies.items():
            self.refused({path: body}, 'long-literal')

    def test_eleven_words_pass(self):
        self.passed({'server/src/a.ts': ts(11)})

    def test_config_strings_refused(self):
        self.refused({'server/package.json': '{"description": "%s"}\n' % sentence(12)}, 'long-literal')
        self.refused({'app/ios/Runner/Info.plist': '<string>%s</string>\n' % sentence(12)}, 'long-literal')
        self.refused({'app/pubspec.yaml': 'description: %s\n' % sentence(12)}, 'long-literal')

    def test_exempt_places_pass(self):
        self.passed({'fixtures/invented-nights.json': '["%s"]\n' % sentence(30),
                     'app/lib/words/lines.g.dart': "const s = '%s';\n" % sentence(30),
                     'docs/plans/p.md': sentence(30) + '\n',
                     'tool/a.py': '# %s\n' % sentence(30)})


if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_g4`. Expected: exit 1, `No module named 'g4_invented'`.

**Green.**

**File `tool/checks/g4_invented.py`**

~~~~python
# G4 invented only: no string literal of twelve words or more outside
# fixtures/invented-nights.json and app/lib/words/.
from guardlib import Finding, config_strings, words

CODE = 'G4'
NAME = 'invented only'
LIMIT = 12


def exempt(path):
    return path == 'fixtures/invented-nights.json' or path.startswith('app/lib/words/')


def check(src):
    findings = []
    for path in src.paths:
        kind = src.kind(path)
        if kind is None or exempt(path):
            continue
        if kind == 'config':
            pairs = config_strings(path, src.text(path) or '')
        else:
            lx = src.lexed(path)
            if lx is None:
                findings.append(Finding(path, 0, 'unlexable'))
                continue
            pairs = [(lit.line, lit.text) for lit in lx.lits]
        for line, text in pairs:
            if words(text) >= LIMIT:
                findings.append(Finding(path, line, 'long-literal'))
    return findings, []
~~~~

Expected: `Ran 4 tests`, `OK`. **Mutations:** `… mutations.py g4_invented.py`. Expected: 1 run, all caught.

    git add tool/checks && git commit -m "Guards: G4 invented only" -m "<trailer>"

### Task 6 · G5 logging (D12, D13)

**Red.**

**File `tool/checks/tests/test_g5.py`**

~~~~python
import unittest

from helpers import GuardTest
import g5_logging

P = 'pri' + 'nt('


class G5(GuardTest):
    guard = g5_logging

    def test_each_writer_refused(self):
        cases = [
            ('app/lib/a.dart', 'f() { ' + P + '1); }\n', 'writer-print'),
            ('app/lib/a.dart', 'f() { debugPrint(1); }\n', 'writer-debugPrint'),
            ('app/lib/a.dart', 'f() { developer.log(1); }\n', 'writer-log'),
            ('server/src/a.ts', 'console.info(1);\n', 'writer-console'),
            ('server/src/a.ts', 'process.stdout.write(1);\n', 'writer-stdout.write'),
            ('app/lib/a.dart', 'f() { stderr.writeln(1); }\n', 'writer-stderr.write'),
            ('app/lib/a.dart', 'f() { FlutterError.dumpErrorToConsole(e); }\n',
             'writer-dumpErrorToConsole'),
            ('tool/a.py', P + '1)\n', 'writer-print'),
        ]
        for path, body, reason in cases:
            self.refused({path: body}, reason)

    def test_safe_loggers_pass(self):
        self.passed({'app/lib/core/safe_log.dart': 'f() { ' + P + '1); }\n',
                     'server/src/safe-log.ts': 'console.info(1);\n'})

    def test_strings_comments_and_lookalikes_pass(self):
        self.passed({'app/lib/a.dart': "f() { showDialog(); catalog(); } // " + P + "\nconst s = '" + P + "';\n",
                     'server/src/a.ts': 'const y = Math.log(2);\n'})


if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_g5`. Expected: exit 1, `No module named 'g5_logging'`.

**Green.**

**File `tool/checks/g5_logging.py`**

~~~~python
# G5 logging: none of the writers below in code (strings and comments
# are not code) or in config, outside the two safe loggers and the
# checks' own writer. Math.log( computes a logarithm and is allowed.
import re

from guardlib import Finding

CODE = 'G5'
NAME = 'logging'
EXEMPT = ('app/lib/core/safe_log.dart', 'server/src/safe-log.ts',
          'tool/checks/guardlib.py')
B = r'(?<![\w$])'
WRITERS = [
    ('print', re.compile(B + r'print\s*\(')),
    ('debugPrint', re.compile(B + r'debugPrint\s*\(')),
    ('log', re.compile(B + r'log\s*\(')),
    ('console', re.compile(B + r'console\s*\.')),
    ('stdout.write', re.compile(B + r'stdout\s*\.\s*write')),
    ('stderr.write', re.compile(B + r'stderr\s*\.\s*write')),
    ('dumpErrorToConsole', re.compile(B + r'FlutterError\s*\.\s*dumpErrorToConsole')),
]
MATH = re.compile(r'(?<![\w$])Math\s*\.\s*$')


def scan(path, text, findings):
    for name, rx in WRITERS:
        for m in rx.finditer(text):
            if name == 'log' and MATH.search(text, 0, m.start()):
                continue
            line = text.count('\n', 0, m.start()) + 1
            findings.append(Finding(path, line, 'writer-' + name))


def check(src):
    findings = []
    for path in src.paths:
        kind = src.kind(path)
        if kind is None or path in EXEMPT:
            continue
        if kind == 'config':
            scan(path, src.text(path) or '', findings)
            continue
        lx = src.lexed(path)
        if lx is None:
            findings.append(Finding(path, 0, 'unlexable'))
            continue
        scan(path, lx.code, findings)
    return findings, []
~~~~

Expected: `Ran 3 tests`, `OK`. **Mutations:** `… mutations.py g5_logging.py`. Expected: 2 run, all caught.

    git add tool/checks && git commit -m "Guards: G5 logging" -m "<trailer>"

### Task 7 · G6 identifiers

**Red.**

**File `tool/checks/tests/test_g6.py`**

~~~~python
import unittest

from helpers import GuardTest
import g6_identifiers

NAMES = ['client_' + 'reference_id', 'identifier' + 'ForVendor',
         'advertising' + 'Identifier', 'device' + '_info']


class G6(GuardTest):
    guard = g6_identifiers

    def test_each_name_refused_in_code_and_config(self):
        for name in NAMES:
            for path in ('app/lib/a.dart', 'server/src/a.ts', 'app/pubspec.yaml',
                         'app/ios/Runner/Info.plist'):
                self.refused({path: 'x ' + name + ' y\n'}, 'identifier')

    def test_other_spellings_refused(self):
        self.refused({'server/src/a.ts': 'const clientReference' + 'Id = 1;\n'}, 'identifier')
        self.refused({'app/pubspec.yaml': '  device' + '_info_plus: any\n'}, 'identifier')

    def test_near_miss_passes(self):
        self.passed({'app/lib/a.dart': 'final device = 1; final info = 2;\n'})


if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_g6`. Expected: exit 1, `No module named 'g6_identifiers'`.

**Green.**

**File `tool/checks/g6_identifiers.py`**

~~~~python
# G6 identifiers: none of the four names below, in any spelling that
# differs only by case, underscores or hyphens. Built from pieces so
# this file does not refuse itself.
from guardlib import Finding

CODE = 'G6'
NAME = 'identifiers'
NAMES = ['client_' + 'reference_id', 'identifier' + 'ForVendor',
         'advertising' + 'Identifier', 'device' + '_info']


def norm(s):
    return s.replace('_', '').replace('-', '').lower()


NEEDLES = [norm(n) for n in NAMES]


def check(src):
    findings = []
    for path in src.paths:
        if src.kind(path) is None:
            continue
        text = src.text(path)
        if text is None:
            continue
        for n, line in enumerate(text.split('\n'), 1):
            flat = norm(line)
            for needle in NEEDLES:
                if needle in flat:
                    findings.append(Finding(path, n, 'identifier'))
    return findings, []
~~~~

Expected: `Ran 3 tests`, `OK`. **Mutations:** `… mutations.py g6_identifiers.py`. Expected: 1 run, all caught.

    git add tool/checks && git commit -m "Guards: G6 identifiers" -m "<trailer>"

### Task 8 · G7 secrets (D9)

**Red.**

**File `tool/checks/tests/test_g7.py`**

~~~~python
import unittest

from helpers import GuardTest, run
import g7_secrets

D = '-' * 5
AWS = 'AK' + 'IA' + 'Q3EXAMPLE7KEY2ZX'
PEM = D + 'BEGIN ' + 'PRIVATE KEY' + D
SK = 's' + 'k-' + 'proj' + 'Xq3vB8mN2pL5tR9wY4zC'
GH = 'gh' + 'p_' + 'A1b2C3d4E5f6G7h8I9' + 'j0K1l2M3n4O5p6Q7r8'
RANDOM = 'Zq8' + 'Lm3vT9xQ2pW7kR4n' + 'B6yH1cJ5dF0gS8aE'


class G7(GuardTest):
    guard = g7_secrets

    def test_secret_file_names_refused(self):
        for name in ('.env', '.env.local', 'k.p8', 'k.pem', 'k.p12', 'x.mobileprovision',
                     '.ENV', 'x.PEM', 'AuthKey.P8'):
            self.refused({'app/' + name: b''}, 'secret-file')

    def test_key_shapes_refused_markdown_included(self):
        cases = [(AWS, 'aws-key'), (PEM, 'pem-block'), (SK, 'sk-token'),
                 (GH, 'github-token'), ('api' + 'Key = "a1B2c3D4e5F6g7H8"', 'assigned-secret'),
                 (RANDOM, 'high-entropy')]
        for text, reason in cases:
            self.refused({'docs/notes.md': 'see ' + text + '\n'}, reason)

    def test_hex_hashes_pass(self):
        self.passed({'docs/Status.md': ('ab12' * 16) + '\n' + ('9f' * 20) + '\n'})

    def test_sources_and_lockfile_integrity_exempt(self):
        self.passed({'docs/source/SOURCES': RANDOM + '\n',
                     'server/package-lock.json': '"integrity": "sha512-' + RANDOM + '"\n'})

    def test_lockfile_other_lines_still_scanned(self):
        self.refused({'server/package-lock.json': '"x": "' + RANDOM + '"\n'}, 'high-entropy')

    def test_integrity_outside_lockfile_refused(self):
        self.refused({'server/a.json': '"integrity": "' + RANDOM + '"\n'}, 'high-entropy')

    def test_plain_code_passes(self):
        self.passed({'tool/a.py': 'tokens = tokenize.generate_tokens(read)\n'
                                  'secret_name = is_secret_name(path)\n'})

    def test_binary_file_skipped(self):
        findings, _ = run(self.guard, {'a.bin': b'\0' + RANDOM.encode()})
        self.assertEqual(findings, [])


if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_g7`. Expected: exit 1, `No module named 'g7_secrets'`.

**Green.**

**File `tool/checks/g7_secrets.py`**

~~~~python
# G7 secrets: no secret-named file anywhere, and no key-shaped string
# in any tracked text file, Markdown included. Exempt: docs/source/SOURCES,
# and lines naming an integrity field in a lockfile.
import math
import posixpath
import re

from guardlib import LOCKFILES, SOURCES, Finding, is_secret_name

CODE = 'G7'
NAME = 'secrets'
DASHES = '-' * 5
SHAPES = [
    ('aws-key', re.compile(r'\b(?:AKIA|ASIA)[0-9A-Z]{16}\b')),
    ('pem-block', re.compile(DASHES + r'BEGIN [A-Z0-9 ]+' + DASHES)),
    ('sk-token', re.compile(r'\bsk[-_](?:live[-_]|test[-_]|ant[-_])?[A-Za-z0-9_-]{20,}')),
    ('github-token', re.compile(r'\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,})')),
    ('slack-token', re.compile(r'\bxox[abprs]-[A-Za-z0-9-]{10,}')),
    ('google-key', re.compile(r'\bAIza[0-9A-Za-z_-]{35}')),
    ('jwt', re.compile(r'\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}')),
    ('assigned-secret', re.compile(
        r'(?i)(?:api[_-]?key|secret|token|passw(?:or)?d)[A-Za-z0-9_-]*["\']?\s*[:=]\s*'
        r'["\']?(?=[A-Za-z0-9+/_=-]*[0-9])(?=[A-Za-z0-9+/_=-]*[A-Za-z])[A-Za-z0-9+/_=-]{16,}')),
]
RUN = re.compile(r'[A-Za-z0-9+_=-]{32,}')
HEX = re.compile(r'[0-9a-fA-F]+')


def entropy(s):
    counts = {}
    for c in s:
        counts[c] = counts.get(c, 0) + 1
    return -sum(k / len(s) * math.log2(k / len(s)) for k in counts.values())


def high_entropy(run):
    return (not HEX.fullmatch(run)
            and any(c.isupper() for c in run) and any(c.islower() for c in run)
            and any(c.isdigit() for c in run) and entropy(run) >= 4.2)


def check(src):
    findings = []
    for path in src.paths:
        if is_secret_name(path):
            findings.append(Finding(path, 0, 'secret-file'))
            continue
        if path == SOURCES:
            continue
        text = src.text(path)
        if text is None:
            continue
        lock = posixpath.basename(path) in LOCKFILES
        for n, line in enumerate(text.split('\n'), 1):
            if lock and 'integrity' in line:
                continue
            for name, rx in SHAPES:
                if rx.search(line):
                    findings.append(Finding(path, n, name))
            if any(high_entropy(m.group(0)) for m in RUN.finditer(line)):
                findings.append(Finding(path, n, 'high-entropy'))
    return findings, []
~~~~

Expected: `Ran 8 tests`, `OK`. **Mutations:** `… mutations.py g7_secrets.py`. Expected: 2 run, all caught.

    git add tool/checks && git commit -m "Guards: G7 secrets" -m "<trailer>"

### Task 9 · G8 export (D7)

**Red.**

**File `tool/checks/tests/test_g8.py`**

~~~~python
import unittest

from helpers import GuardTest
import g8_export

IMP = "import 'package:souldreams/founder/export.dart';\n"


class G8(GuardTest):
    guard = g8_export

    def test_tester_main_refused(self):
        self.refused({'app/lib/main.dart': IMP}, 'founder-import')

    def test_any_other_file_refused(self):
        self.refused({'app/lib/ui/a.dart': IMP}, 'founder-import')
        self.refused({'app/lib/ui/a.dart': "import '../founder/export.dart';\n"}, 'founder-import')
        self.refused({'app/lib/a.dart': "export 'founder/export.dart' show x;\n"}, 'founder-import')
        self.refused({'app/lib/a.dart': "part 'founder/p.dart';\n"}, 'founder-import')
        self.refused({'app/lib/a.dart': "import 'x.dart'\n  if (dart.library.io) 'founder/y.dart';\n"},
                     'founder-import')

    def test_allowed_importers_pass(self):
        self.passed({'app/lib/main_founder.dart': IMP, 'app/lib/main_dev.dart': IMP,
                     'app/lib/founder/a.dart': "import 'b.dart';\n",
                     'app/test/founder/a_test.dart': IMP})

    def test_lookalikes_pass(self):
        self.passed({'app/lib/a.dart': "import 'package:x/founders.dart';\n"
                                       "import 'founder_note.dart';\nconst s = 'founder/x';\n"})


if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_g8`. Expected: exit 1, `No module named 'g8_export'`.

**Green.**

**File `tool/checks/g8_export.py`**

~~~~python
# G8 export: only main_founder.dart and main_dev.dart, files inside
# app/lib/founder/ and tests in app/test/founder/ may import, export or
# take part of a file in app/lib/founder/.
import posixpath
import re

from guardlib import Finding

CODE = 'G8'
NAME = 'export'
FOUNDER = 'app/lib/founder/'
ALLOWED = ('app/lib/main_founder.dart', 'app/lib/main_dev.dart')
ALLOWED_DIRS = (FOUNDER, 'app/test/founder/')
DIRECTIVE = re.compile(r'(?<![\w$.])(?:import|export|part)\b')


def into_founder(importer, uri):
    if uri.startswith('package:'):
        return uri[len('package:'):].partition('/')[2].startswith('founder/')
    if ':' in uri.split('/', 1)[0]:
        return False
    target = posixpath.normpath(posixpath.join(posixpath.dirname(importer), uri))
    return (target + '/').startswith(FOUNDER)


def check(src):
    findings = []
    for path in src.paths:
        if src.kind(path) != 'dart':
            continue
        if path in ALLOWED or path.startswith(ALLOWED_DIRS):
            continue
        lx = src.lexed(path)
        if lx is None:
            findings.append(Finding(path, 0, 'unlexable'))
            continue
        for m in DIRECTIVE.finditer(lx.code):
            end = lx.code.find(';', m.end())
            end = len(lx.code) if end < 0 else end
            for lit in lx.lits:
                if m.start() <= lit.pos < end and into_founder(path, lit.text):
                    findings.append(Finding(path, lit.line, 'founder-import'))
    return findings, []
~~~~

Expected: `Ran 4 tests`, `OK`. **Mutations:** `… mutations.py g8_export.py`. Expected: 1 run, all caught.

    git add tool/checks && git commit -m "Guards: G8 export" -m "<trailer>"

### Task 10 · G9 hosts (D11)

**Red.**

**File `tool/checks/tests/test_g9.py`**

~~~~python
import unittest

from helpers import GuardTest
import g9_hosts

S = '://'


class G9(GuardTest):
    guard = g9_hosts

    def test_each_scheme_refused(self):
        for scheme in ('http', 'https', 'ws', 'wss', 'HTTPS'):
            self.refused({'app/lib/a.dart': "const u = '" + scheme + S + "x.example';\n"}, 'host-literal')

    def test_server_and_shell_refused(self):
        self.refused({'server/src/a.ts': "const u = 'https" + S + "x.example';\n"}, 'host-literal')
        self.refused({'tool/a.sh': 'fetch https' + S + 'x.example\n'}, 'host-literal')

    def test_hosts_files_and_tests_pass(self):
        u = "const u = 'https" + S + "x.example';\n"
        self.passed({'app/lib/core/hosts.dart': u, 'server/src/hosts.ts': u,
                     'app/test/a_test.dart': u, 'server/test/a.test.ts': u})

    def test_comments_and_doctype_pass(self):
        self.passed({'app/lib/a.dart': '// see https' + S + 'x.example\n',
                     'app/ios/Runner/Info.plist': '<!DOCTYPE plist PUBLIC "x" "http' + S + 'x/y.dtd">\n'})


if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_g9`. Expected: exit 1, `No module named 'g9_hosts'`.

**Green.**

**File `tool/checks/g9_hosts.py`**

~~~~python
# G9 hosts: no web address scheme (http, https, ws, wss; any case)
# outside the two hosts files and tests. Code is read without its
# comments; config is read whole, less XML DOCTYPE lines.
import re

from guardlib import Finding

CODE = 'G9'
NAME = 'hosts'
EXEMPT = ('app/lib/core/hosts.dart', 'server/src/hosts.ts')
TESTS = ('app/test/', 'app/integration_test/', 'server/test/', 'tool/checks/tests/')
SCHEME = re.compile('(?i)(?<![a-z])(?:https?|wss?)' + ':' + '//')


def check(src):
    findings = []
    for path in src.paths:
        kind = src.kind(path)
        if kind is None or path in EXEMPT or path.startswith(TESTS):
            continue
        if kind == 'config':
            text = src.text(path) or ''
            lines = ['' if l.lstrip().startswith('<!DOCTYPE') else l
                     for l in text.split('\n')]
            text = '\n'.join(lines)
        else:
            lx = src.lexed(path)
            if lx is None:
                findings.append(Finding(path, 0, 'unlexable'))
                continue
            text = lx.without_comments()
        for m in SCHEME.finditer(text):
            findings.append(Finding(path, text.count('\n', 0, m.start()) + 1, 'host-literal'))
    return findings, []
~~~~

Expected: `Ran 4 tests`, `OK`. **Mutations:** `… mutations.py g9_hosts.py`. Expected: 1 run, all caught.

    git add tool/checks && git commit -m "Guards: G9 hosts" -m "<trailer>"

### Task 11 · The guard runner and the pre-commit hook

**Red.**

**File `tool/checks/tests/test_hook.py`**

~~~~python
# The pre-commit hook, end to end, in a throwaway git repository:
# it checks the index, not the working tree.
import os
import shutil
import subprocess
import tempfile
import unittest

from helpers import CHECKS

ROOT = os.path.dirname(os.path.dirname(CHECKS))
HOOK = os.path.join(ROOT, '.githooks', 'pre-commit')
BAD = 'f() { ' + 'pri' + 'nt(1); }\n'
GOOD = 'f() {}\n'


class Hook(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix='hook-')
        self.env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1')
        self.git('init', '-q')
        shutil.copytree(CHECKS, os.path.join(self.tmp, 'tool', 'checks'),
                        ignore=shutil.ignore_patterns('__pycache__'))
        os.makedirs(os.path.join(self.tmp, '.githooks'))
        shutil.copy(HOOK, os.path.join(self.tmp, '.githooks', 'pre-commit'))
        self.git('add', '.')

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def git(self, *args):
        subprocess.run(('git',) + args, cwd=self.tmp, env=self.env, check=True,
                       capture_output=True)

    def write(self, body):
        os.makedirs(os.path.join(self.tmp, 'app', 'lib'), exist_ok=True)
        with open(os.path.join(self.tmp, 'app', 'lib', 'a.dart'), 'w') as f:
            f.write(body)

    def hook(self):
        return subprocess.run(['sh', '.githooks/pre-commit'], cwd=self.tmp, env=self.env,
                              capture_output=True, text=True)

    def test_clean_index_passes(self):
        r = self.hook()
        self.assertEqual(r.returncode, 0, r.stdout)
        self.assertIn('G1 words: NOT ARMED', r.stdout)

    def test_staged_writer_refused(self):
        self.write(BAD)
        self.git('add', 'app/lib/a.dart')
        r = self.hook()
        self.assertEqual(r.returncode, 1)
        self.assertIn('G5 app/lib/a.dart:1 writer-print', r.stdout)

    def test_unstaged_change_is_not_checked(self):
        self.write(GOOD)
        self.git('add', 'app/lib/a.dart')
        self.write(BAD)
        self.assertEqual(self.hook().returncode, 0)

    def test_staged_bad_fixed_only_in_worktree_refused(self):
        self.write(BAD)
        self.git('add', 'app/lib/a.dart')
        self.write(GOOD)
        self.assertEqual(self.hook().returncode, 1)

    def test_undecodable_path_refused(self):
        blob = subprocess.run(('git', 'hash-object', '-w', '--stdin'), cwd=self.tmp, env=self.env,
                              input=b'x\n', check=True, capture_output=True).stdout.strip()
        self.git('update-index', '--add', '--cacheinfo', b'100644,' + blob + b',app/a\xff.txt')
        r = self.hook()
        self.assertEqual(r.returncode, 1)
        self.assertIn('source app/a\\xff.txt:0 bad-path', r.stdout)



if __name__ == '__main__':
    unittest.main()
~~~~

`run_tests.py test_hook`. Expected: exit 1, five errors, each `No such file or directory` naming
`.githooks/pre-commit`.

**Green.**

**File `tool/checks/guards.py`**

~~~~python
# Runs the standing guards. Usage:
#   python3 -I -B tool/checks/guards.py            the tracked files
#   python3 -I -B tool/checks/guards.py --staged   the index (pre-commit)
#   add --only G3 (repeatable) to run some guards; --walk DIR for a folder.
# Exit 0 when every guard passes, 1 on findings, 2 on an internal error.
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import guardlib  # noqa: E402
import g0_kinds, g1_words, g2_copies, g3_literals, g4_invented, g5_logging  # noqa: E402
import g6_identifiers, g7_secrets, g8_export, g9_hosts  # noqa: E402

GUARDS = [g0_kinds, g1_words, g2_copies, g3_literals, g4_invented, g5_logging,
          g6_identifiers, g7_secrets, g8_export, g9_hosts]
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def main(argv):
    mode, root, only = 'tracked', ROOT, set()
    args = list(argv)
    while args:
        a = args.pop(0)
        if a == '--staged':
            mode = 'staged'
        elif a == '--walk' and args:
            mode, root = 'walk', args.pop(0)
        elif a == '--only' and args:
            only.add(args.pop(0))
        else:
            guardlib.report('guards: unknown argument')
            return 2
    try:
        src = guardlib.Source(root, mode)
        failed = 0
        for f in src.findings:
            guardlib.report('source %s:%d %s' % (f.path, f.line, f.reason))
        if src.findings:
            guardlib.report('source: FAIL')
            failed += 1
        for g in GUARDS:
            if only and g.CODE not in only:
                continue
            findings, notes = g.check(src)
            for note in notes:
                guardlib.report(g.CODE + ' ' + g.NAME + ': ' + note)
            for f in sorted(findings, key=lambda f: f.key()):
                guardlib.report('%s %s:%d %s' % (g.CODE, f.path, f.line, f.reason))
            guardlib.report('%s %s: %s' % (g.CODE, g.NAME, 'FAIL' if findings else 'ok'))
            failed += 1 if findings else 0
    except Exception as e:  # never echo a message: it may quote a file
        guardlib.report('guards: internal error ' + type(e).__name__)
        return 2
    guardlib.report('guards (%s): %s' % (mode, 'FAILED' if failed else 'all passed'))
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
~~~~

**File `.githooks/pre-commit`**

~~~~sh
#!/bin/sh
# Runs the standing guards on the staged snapshot (the index).
set -eu
top=$(git rev-parse --show-toplevel)
exec python3 -I -B "$top/tool/checks/guards.py" --staged
~~~~

Expected: `Ran 5 tests`, `OK`. Then, on the repository:
- `python3 -I -B tool/checks/tests/run_tests.py`: `Ran 108 tests`, `OK`.
- `python3 -I -B tool/checks/tests/mutations.py`: `mutations: 25 run, all caught`.
- `python3 -I -B tool/checks/guards.py`: first `G0 file kinds: ok`, then G1 and G2 `NOT ARMED (awaiting import)`,
  every guard `ok`, and `guards (tracked): all passed`.

<!-- -->

    git add tool/checks .githooks && git update-index --chmod=+x .githooks/pre-commit
    sh .githooks/pre-commit && git commit -m "Guards: runner and pre-commit hook" -m "<trailer>"

(The hook is run by hand here, because the owner arms it only in Task 13. Expected: `guards (staged): all passed`.)
From this commit until Task 13, `git status --short` shows ` M .githooks/pre-commit`. That is only the mode: the
commit holds 755 and the file on disk is 644. After Task 12 it shows ` M tool/check_all.sh` too.

### Task 12 · tool/check_all.sh (D3, D6)

**Red.** `sh tool/check_all.sh`. Expected: `No such file or directory`.

**Green.**

**File `tool/check_all.sh`**

~~~~sh
#!/bin/sh
# Runs every guard, the guard tests and the mutation checks, then the
# analyzers and tests of app/ and server/ where they exist. Runs every
# step, then exits 1 if any failed.
set -u
top=$(git rev-parse --show-toplevel) || exit 2
cd "$top" || exit 2
failed=''

fail() {
  failed="$failed $1"
  echo "FAILED: $1"
}

echo "python3: $(command -v python3)"
python3 -I -B --version || fail python

hooks=$(git rev-parse --git-path hooks)
if [ "$hooks" != ".githooks" ]; then
  echo "FAILED LOUDLY: core.hooksPath is not .githooks"
  fail hooks-path
fi
for f in .githooks/pre-commit tool/check_all.sh; do
  [ -x "$f" ] || fail "not-executable:$f"
done

python3 -I -B tool/checks/guards.py || fail guards
python3 -I -B tool/checks/tests/run_tests.py || fail guard-tests
python3 -I -B tool/checks/tests/mutations.py || fail mutations

if [ -d app ]; then
  (cd app && fvm flutter analyze && fvm flutter test) || fail app
else
  echo "SKIPPED: app/ is not present yet"
fi
if [ -d server ]; then
  (cd server && npm run check && npm test) || fail server
else
  echo "SKIPPED: server/ is not present yet"
fi

if [ -n "$failed" ]; then
  echo "check_all: FAILED:$failed"
  exit 1
fi
echo "check_all: all passed"
~~~~

Run `sh tool/check_all.sh`. Expected, until Task 13:
- the Python path and version;
- `FAILED LOUDLY: core.hooksPath is not .githooks`;
- `FAILED: not-executable:.githooks/pre-commit` and `FAILED: not-executable:tool/check_all.sh`;
- the guards, `Ran 108 tests`, `OK` and `mutations: 25 run, all caught`;
- `SKIPPED: app/ is not present yet` and `SKIPPED: server/ is not present yet`;
- last line `check_all: FAILED: hooks-path not-executable:.githooks/pre-commit not-executable:tool/check_all.sh`,
  exit 1.

Any other failure stops the task.

    git add tool/check_all.sh && git update-index --chmod=+x tool/check_all.sh
    sh .githooks/pre-commit && git commit -m "check_all.sh: guards, tests, mutations, app and server" -m "<trailer>"

### Task 13 · The owner arms the hook (D3), and the last proofs

Claude Code stops and gives the owner:

    Paste 1 — Terminal
    cd ~/Developer/soul-dreams-app && chmod +x .githooks/pre-commit tool/check_all.sh && git config core.hooksPath .githooks && git status --short && tool/check_all.sh; echo "exit=$?"

Expected:
- `git status --short` prints nothing, because the modes now match the commits.
- `check_all.sh` ends with `check_all: all passed`, and `exit=0` is printed.

If either differs, the owner pastes the output back and nothing goes further.

Then Claude Code:
- runs proof S20;
- runs `tool/check_all.sh` itself, expecting `check_all: all passed`;
- proves the armed hook refuses a bad commit:
  - writes `app/lib/__canary.dart` holding `f() { ` + `print` + `(1); }`;
  - stages it and runs `git commit -m canary`;
  - expects the commit to be **refused** with `G5 app/lib/__canary.dart:1 writer-print`;
  - then removes only what the task made, with `git rm --cached -q app/lib/__canary.dart && rm app/lib/__canary.dart
    && rmdir app/lib app`, and expects `git status --short` to print nothing.

Nothing is committed in this task.

**Watch item.** If `check_all.sh` fails on `hooks-path` after the owner has set `core.hooksPath`, stop and report.
Do not change the check.

### Task 14 · CLAUDE.md and docs/workflow.md (D11, D17; Q1, Q7; the owner's rulings of 2026-11-07)

The owner approves each edit at the prompt. There are fourteen replacements, made in order, each applying exactly
once: eight in `CLAUDE.md` and six in `docs/workflow.md`. Edits 1 to 4 bring the rules up to date with the guards as
built. Edit 5 adds R15. Edit 6 adds where reports for the Build chat go. Edit 7 adds G0 to the list of checks (D17),
and Edit 8 adds it to `docs/workflow.md` (e). Edits 9 to 12 are the owner's rulings of 2026-11-07: the server's
feedback at a cohort's review (d), the safety copy before a storage change (c), and the Cohort 0 app's own identifier
(i). Edits 13 and 14 are the owner's ruling of 2026-11-07, filed upstream (C147-I, C15-P): crisis material, the crisis
check and the Help page are scrapped indefinitely, so R8 no longer names the distress results and R9 is replaced.

**Edit 1 of 14 · `CLAUDE.md`, R10, the hosts files (D11).** Replace

~~~~text
live in one file, `app/lib/core/hosts.dart`. No package that sends data anywhere: no analytics, crash reporting,
~~~~

with

~~~~text
live in one file, `app/lib/core/hosts.dart`; the server's live in `server/src/hosts.ts`. No package that sends data
anywhere: no analytics, crash reporting,
~~~~

**Edit 2 of 14 · `CLAUDE.md`, G5 (D12, D13; Q1, Q7).** Replace

~~~~text
- **G5 logging** — no `print(`, `debugPrint(`, `log(` or `console.` outside the two safe loggers.
~~~~

with

~~~~text
- **G5 logging** — no `print(`, `debugPrint(`, `log(` (`Math.log(` allowed), `console.`, `stdout.write`, `stderr.write`
  or `FlutterError.dumpErrorToConsole` outside the two safe loggers (`app/lib/core/safe_log.dart`,
  `server/src/safe-log.ts`) and the checks' own writer (`tool/checks/guardlib.py`).
~~~~

**Edit 3 of 14 · `CLAUDE.md`, G8 (D7; Q7).** Replace

~~~~text
- **G8 export** — nothing but `main_founder.dart` and `main_dev.dart` imports `lib/founder/`.
~~~~

with

~~~~text
- **G8 export** — nothing but `main_founder.dart` and `main_dev.dart` imports `lib/founder/`, besides files inside it
  and tests in `app/test/founder/`.
~~~~

**Edit 4 of 14 · `CLAUDE.md`, G9 (D11).** Replace

~~~~text
- **G9 hosts** — no `http://`, `https://` or `wss://` literal outside `hosts.dart` and tests.
~~~~

with

~~~~text
- **G9 hosts** — no `http://`, `https://`, `ws://` or `wss://` literal outside `app/lib/core/hosts.dart`,
  `server/src/hosts.ts` and tests.
~~~~

**Edit 5 of 14 · `CLAUDE.md`, R15 (Q7).** Replace

~~~~text
check refusing: stop and report. Never improvise around it, never weaken a test or a check.
~~~~

with

~~~~text
check refusing: stop and report. Never improvise around it, never weaken a test or a check.

**R15 · No connectors.** Never sign in to, connect or use any claude.ai connector (email,
drive, calendar or any other) in a session in this repository.
~~~~

**Edit 6 of 14 · `docs/workflow.md`, reports for the Build chat (Q7).** Replace

~~~~text
- Anything longer than a few lines is a downloadable script, never pasted by hand.
~~~~

with

~~~~text
- Anything longer than a few lines is a downloadable script, never pasted by hand.
- Reports for the Build chat (investigations, plan summaries, reviews, long outputs) are
  written by Claude Code to `.scratch/for-build-chat/`, which git ignores; the owner attaches
  the file to the Build chat. Plans and specs are still committed under `docs/`.
~~~~

**Edit 7 of 14 · `CLAUDE.md`, G0 in "The checks" (D17).** Replace

~~~~text
- **G1 words** — `lines.g.dart` is exactly what the generator makes from the CSV, and the CSV's and lists' hashes match
~~~~

with

~~~~text
- **G0 file kinds** — every tracked file is a kind the guards know: code, config, or an unscanned type, name or path
  listed in `tool/checks/g0_kinds.py`. Anything else, an unknown `#!` interpreter included, is refused. A branch that
  brings a new kind of file extends the list, and the owner approves it.
- **G1 words** — `lines.g.dart` is exactly what the generator makes from the CSV, and the CSV's and lists' hashes match
~~~~

**Edit 8 of 14 · `docs/workflow.md` (e), G0 among the guards (D17; owner, 2026-11-07).** Replace

~~~~text
`CLAUDE.md` run on every commit: words (G1), copies (G2), no literal words (G3), invented only (G4), logging (G5), no
identifier (G6), no secrets (G7), the export (G8), hosts (G9).
~~~~

with

~~~~text
`CLAUDE.md` run on every commit: file kinds (G0), words (G1), copies (G2), no literal words (G3), invented only (G4),
logging (G5), no identifier (G6), no secrets (G7), the export (G8), hosts (G9).
~~~~

**Edit 9 of 14 · `docs/workflow.md` (d), the server's feedback at a cohort's review (owner, 2026-11-07).** Replace

~~~~text
cache or temporary file, or in anything the app can open. The original's method applies only to the server's feedback
and totals, when a cohort's review ends: back up first, list exactly what goes, delete by exact ID, check every count
moved as expected.
~~~~

with

~~~~text
cache or temporary file, or in anything the app can open. At a cohort's review, the server's feedback is deleted with
no backup or copy kept; only the combined totals are kept. The original's method (back up first, list exactly what
goes, delete by exact ID, check every count moved as expected) applies to the totals only.
~~~~

**Edit 10 of 14 · `docs/workflow.md` (c), the safety copy before a storage change (owner, 2026-11-07).** Replace

~~~~text
4. Only then does it reach the Cohort 0 app, and only then any tester.
~~~~

with

~~~~text
4. Before it reaches the Cohort 0 app, the owner exports each night as C142-I item 3 rules the export (AirDrop to his
   Mac, into restricted/), as a safety copy, and deletes that copy once the updated app is checked.
5. Only then does it reach the Cohort 0 app, and only then any tester.
~~~~

**Edit 11 of 14 · `docs/workflow.md` (i), the Cohort 0 app's identifier (owner, 2026-11-07).** Replace

~~~~text
- **SoulDreams** (`app.souldreams`), the owner's Cohort 0 app: **release builds only**, built from `main_founder.dart`.
~~~~

with

~~~~text
- **SoulDreams** (`app.souldreams.founder`), the owner's Cohort 0 app: **release builds only**, built from
  `main_founder.dart`, installed from Xcode only.
~~~~

**Edit 12 of 14 · `docs/workflow.md` (i), the TestFlight build (owner, 2026-11-07).** Replace

~~~~text
- **Never install the TestFlight build on the owner's phone.** It shares the Cohort 0 app's identifier and would
  replace it.
~~~~

with

~~~~text
- **Never install the TestFlight build on the owner's phone.** It is the testers' app (`app.souldreams`), built
  without the export; the owner's two apps stay the only SoulDreams apps on his phone.
~~~~

**Edit 13 of 14 · `CLAUDE.md` R8, no distress results (owner, 2026-11-07; C147-I, C15-P).** Replace

~~~~text
does: in a tester build it is not hidden, it is not built in. It shares one night by AirDrop, leaves out the distress
results, and goes through no server or service.
~~~~

with

~~~~text
does: in a tester build it is not hidden, it is not built in. It shares one night by AirDrop and goes through no server
or service.
~~~~

**Edit 14 of 14 · `CLAUDE.md` R9, crisis material, check and Help scrapped (owner, 2026-11-07; C147-I, C15-P).** Replace

~~~~text
**R9 · The distress check's result stays on the phone.** It is never sent anywhere, never exported, never logged.
~~~~

with

~~~~text
**R9 · No crisis material, crisis check or Help.** All three are scrapped indefinitely (owner, 2026-11-07). There is no
screen, placeholder, stub, flag, setting or name for any of them anywhere in `app/` or `server/`.
~~~~

Then `tool/check_all.sh` (expected: all passed), and:

    git add CLAUDE.md docs/workflow.md && git commit -m "CLAUDE.md and workflow.md: guards as built, R15, Build chat reports, owner's rulings of 2026-11-07" -m "<trailer>"

Expected: the hook prints `guards (staged): all passed` before the commit is recorded.

### Task 15 · docs/Status.md (D1)

**File `docs/Status.md`**

~~~~markdown
# Status — SoulDreams app

Last updated: <date>, at the end of branch `scaffold-1-guards`, by Claude Code.

*No matter where you are on your journey, the steps you take are equally important.*

Status is not the record. Rulings live in `technology/technology-change-record.md` in the documents repository; this
file points to them and never restates them. The rulings for branch 1 (D1 to D14, D16 and D17) were given in the Build
chat and are listed in `docs/plans/scaffold-1-guards.md`, Part 1, and the answers to its questions in Part 4. The
owner's rulings of 2026-11-07 on the third amendment's questions are listed in its Part 5, fourth amendment, the
ruling on the review of Task 2b in its sixth, and the ruling on the review of Task 2c in its seventh.

## Current branch

`scaffold-1-guards`: Scaffolding, branch 1 of 4. Plan: `docs/plans/scaffold-1-guards.md`.

## Road ahead

- Branch 2, `scaffold-2-app`: the empty Flutter app in three flavours, each with its entry point: the testers'
  SoulDreams (`app.souldreams`, `main.dart`), the owner's Cohort 0 SoulDreams (`app.souldreams.founder`,
  `main_founder.dart`, release builds only, installed from Xcode), and SoulDreams Dev (`app.souldreams.dev`,
  `main_dev.dart`); Flutter pinned through FVM. Confirm that an Xcode-installed release build needs no App Store
  Connect record.
- Branch 3, `scaffold-3-import`: the import script, the words generator (`lines.g.dart` and the iOS permission-text
  files from EM·3), the docs copies, and arming G1 and G2 by deleting `tool/checks/awaiting-import`. The docs copies
  are the handover, main path, how the AI appears, design system, experience map, product principles, requirements
  list and tester disclosure specification, plus read-only copies of `interpretation/change-record.md`,
  `product/product-change-record.md`, `technology/technology-change-record.md` and
  `technology/technical-answers.md` once filed. Claude Code reads only the entries a spec cites, by ordinal.
  `privacy-ethics-safety.md` stays out.
- Branch 4, `scaffold-4-server`: the empty TypeScript server for Lambda, with its tests; nothing deployed.

## The guards

- G1 words and G2 copies: **NOT ARMED** until the first import (`tool/checks/awaiting-import`).
- G0 and G3 to G9: armed, on every commit (`.githooks/pre-commit`) and in `tool/check_all.sh`.
- The hook runs once `core.hooksPath` is `.githooks`, which the owner sets on each clone. `check_all.sh` fails loudly
  if it is not.
- Totals: 108 guard tests and 25 mutation checks.

## Banked

1. The microphone permission text is place EM·3 in the register (status "written", English and Swedish). Branch 3's
   generator writes the iOS permission-text files from EM·3 (`InfoPlist.strings`, en and sv, and the base value),
   and G1 then checks them as it checks `lines.g.dart`. Branch 2 adds no microphone setting (plan Part 4, Q3).
2. The safe loggers named in G5 (`app/lib/core/safe_log.dart`, `server/src/safe-log.ts`) and the hosts files named
   in G9 (`app/lib/core/hosts.dart`, `server/src/hosts.ts`) do not exist yet; they arrive with `app/` and `server/`.
3. The analyzer baseline the workflow asks for is saved by the branch that creates `app/` or `server/`.
4. In tracked mode (`check_all.sh`), G7 does not scan tracked symlinks, or tracked files deleted from the working
   tree. The hook reads the index, so every commit is covered (D16).
5. Replace the hand-written lexers in `tool/checks/lex.py` with the official Dart analyzer and TypeScript scanner,
   once branches 2 and 4 bring them (D16).
6. YAML: G4 reads multi-line plain and quoted scalars line by line, so a long one can pass (D17; `scaffold-1-review-2a.md`, finding 5, B4).
7. Python: the code in an f-string's `{}` is blanked as string, so G5 can miss a writer there (D17; `scaffold-1-review-2a.md`, finding 7, B6).
8. Shell: backticks inside double quotes are blanked as string, so the guards can miss code there (D17; `scaffold-1-review-2a.md`, finding 7, B6).
9. Shell: substitutions in an unquoted heredoc's body are blanked as string, so the guards can miss them (D17; `scaffold-1-review-2a.md`, finding 7, B6).
10. The reviewer's seven minor notes on Task 2a, C1 to C7 in `scaffold-1-review-2a.md` (D17).
11. Shell: inside double quotes, `$(( ))` is blanked as string, so a command substitution in it, as in `"$(( $(cmd) + 1 ))"`, is hidden from the guards (D17; `scaffold-1-review-2a.md`, A/B-1).
12. The model's instructions need their own home, exempt from G4; defined when they arrive.
13. Plan Part 2 S1/S2 expectations amended by D15 during implementation (S1 proved by the sandbox on a real canary; S2's shell results on missing files are not evidence).
14. Banked by D17 at Task 2b's review: K1 (two Swift regexes after try with quotes on one line), K2 (shell <<< read as a heredoc), K3 (shift by a variable name in (( )) read as a heredoc), K4 (a NUL-byte file with an unlisted extension counts as binary). See scaffold-1-review-2b.md.
15. G0 refuses .gitkeep and .fvmrc: branch 2 extends g0_kinds.py when it adds app/. These fail closed as unlexable (false findings, safe): Swift 'x! / y' and '} / n'; shell '<<=' and '<<\EOF'.

## Documents as last imported

None yet. `docs/source/SOURCES` does not exist.
~~~~

`<date>` is that day's date. Then `tool/check_all.sh` (expected: all passed), and:

    git add docs/Status.md && git commit -m "Status.md: created at the end of scaffold-1-guards" -m "<trailer>"

---

## Part 4 · Questions for the owner (numbered; a blank is not a yes)

**Answered by the owner on 2026-11-07.** Q1, Q2, Q4, Q5, Q6, Q8 and Q10: yes, each lean accepted. Q3, Q7 and Q9
were answered differently from, or beyond, the lean; each answer is written under its question. The plan above
follows every answer.

1. **G5 and the checks' own output.** The checks are `.py` files, and D8 puts `.py` under G5. They have to print
   their findings.
   - *Lean:* exempt one file, `tool/checks/guardlib.py`, whose `report()` is the only writer. It is given guard codes,
     paths, line numbers and reason codes, never a file's content.
   - *If not:* the checks would have to write through an API G5 does not list (for example `os.write`), which obeys
     the words of the rule and dodges its intent. I would rather not.
2. **G3 and tests.** CLAUDE.md's second clause (more than two words needs the marker) reads as covering every Dart
   file. In `app/test/` every test name would need the marker.
   - *Lean:* G3 scans `app/lib/**` only. Tests are never shown to a dreamer, and G4 still covers them.
   - *If not:* G3 scans `app/test/` and `app/integration_test/` too, and every test name carries the marker.
3. **Dreamer-facing words in `Info.plist` (banked, for the branch that adds the iOS project).** The microphone
   permission text is shown to the dreamer, but iOS reads it from `Info.plist` or `InfoPlist.strings`, not from
   `lines.g.dart`. R1 says every dreamer-facing line comes from `lines.g.dart`, and G3 cannot see plists.
   - *Lean:* bank it in Status.md. When the iOS project arrives, the generator also writes the plist strings from the
     register, and a guard checks they match.
   - *If you'd rather:* settle it now with Product & Design.
   - **Answer: not a conflict.** The register already holds the microphone text: place EM·3, status "written",
     English and Swedish. Branch 3's generator writes the iOS permission-text files (`InfoPlist.strings`, en and sv,
     and the base value) from EM·3, and G1 then checks them as it checks `lines.g.dart`. Branch 2 adds no microphone
     setting. Status.md's banked item 1 says exactly this.
4. **How config and scopes are read.**
   - *G4 in config:* strings are read as
     - `<string>` elements in plists;
     - quoted strings in JSON, `.pbxproj` and `.xcscheme`;
     - the value after `=` in `.xcconfig`;
     - the value after `key: ` (or the whole line) in YAML.
   - *G5, G6 and G9 in config* read the whole text, less DOCTYPE lines for G9.
   - *"Tests" for G9* means `app/test/`, `app/integration_test/`, `server/test/` and `tool/checks/tests/`.
   - *G7* skips binary files.
   - *Lean:* accept all of these. *If not:* say which, and that guard changes.
5. **SOURCES format and G2's strictness.**
   - *Lean on the format:* one line per file, `<sha256>  <repo-relative path>  <filing ordinal>`, separated by two
     spaces, with `#` lines as comments. Branch 3's import script writes this format.
   - *Lean on strictness:* while the marker exists, G2 refuses **any** file under `docs/source/`, not only SOURCES.
     A listed path outside `docs/source/` is refused unless it is one of the two words files.
   - *If not:* give the format, and G2 and G1 change to match.
6. **Readings that differ from the words of CLAUDE.md.**
   - **Stricter:**
     - G6 ignores case, `_` and `-`.
     - G9 matches any case, and reads code as well as literals (comments excluded).
     - G7 adds key shapes beyond the examples.
     - G3 treats `Text.rich` as `Text`.
   - **Narrower:** G5 matches `print(`, `debugPrint(` and `log(` only as whole names. Read as plain substrings, `log(`
     would refuse Flutter's own `showDialog(` and any `catalog(`.
   - *Lean:* accept all of these.
   - *If not:* G5 matches the plain substring `log(`, and dialogs are written around it.
7. **How much of CLAUDE.md Task 14 changes.** D11 approved only the hosts line.
   - *Lean:* also bring the G5, G8 and G9 lines up to date with D7, D12 and D13 (and Q1), so CLAUDE.md describes the
     guards as built.
   - *If not:* Task 14 changes only R10 and G9, and the G5 and G8 lines stay as worded.
   - **Answer: yes, all four edits, plus two more in Task 14:** Edit 5 adds R15 (no connectors) to `CLAUDE.md`, and
     Edit 6 adds to `docs/workflow.md` where reports for the Build chat go.
8. **Method details.**
   - `-B` beside `-I` keeps `__pycache__` out of the repository.
   - `git update-index --chmod=+x` records the executable modes in the commits.
   - The hook checks the whole index, not only the changed files.
   - *Lean:* accept all three.
9. **Branches 2 to 4.** Status.md's "Road ahead" needs their names and scope. I know only that branch 3 delivers the
   import and arms G1 and G2.
   - *Lean:* the Build chat supplies them before Task 15. Until then they stay `[to confirm]`.
   - **Answer:** `scaffold-2-app`, `scaffold-3-import` and `scaffold-4-server`, as now written in Task 15's
     Status.md.
10. **"Nothing else outside the repo is touched" (D2).**
    - *Lean:* this covers the settings proofs. S3's canaries move into `./.scratch/`, and the investigation's
      home-folder `allowWrite` proofs are dropped.
    - `$TMPDIR` (the sandbox's own session temp folder) is still used by the guard tests, the mutation checks and the
      hook test, as the investigation proposed. Each removes what it made.
    - *If not:* the tests' throwaway trees move under `./.scratch/`, which changes `helpers.py`, `mutations.py` and
      `test_hook.py`.

---

## Part 5 · How this plan was proven

On 2026-11-07, before this file was committed:
1. Every file above was built and run in a scratch worktree, `./.scratch/build`.
2. In that worktree, the whole branch was staged and the hook was run on the index. `check_all.sh` was run there, and
   its only failure was `hooks-path`, as expected without the owner's step.
3. The plan was then replayed from this file on a clean worktree, `./.scratch/replay`, task by task:
   - every file was extracted from this document;
   - every red run failed as stated, and every green run passed with the stated count;
   - every mutation was caught;
   - the four CLAUDE.md replacements each applied exactly once;
   - every task was committed there with the hook run by hand.
4. G7 was run over this file itself.
5. Both scratch worktrees were then removed.

Task 0 and Task 13 were not replayed: they need the owner.

**Amendment, 2026-11-07.** After the owner's answers, the following changed: the header; Task 13 (narrower clean-up
and the watch item); Task 14 (six edits, Edits 5 and 6 new); Task 15's Status.md (road ahead, banked item 1, and a
pointer to Part 4); Part 4 (the answers); and this part. Nothing in Tasks 0 to 12 changed. On a clean worktree,
`./.scratch/replay`, the whole plan was replayed again from this file:
- Tasks 1 to 12 as before.
- Task 13, as far as the sandbox allows:
  - the owner's `chmod +x` was run;
  - `git config` is the owner's, so `check_all.sh` was expected to fail on `hooks-path` alone, and did;
  - the canary was refused by the hook, run by hand;
  - the new clean-up left `git status --short` empty.
- Task 14: all six edits applied exactly once.
- Task 15 committed.

Every staged commit passed the hook. The worktree was then removed.

**Second amendment, 2026-11-07 (D16).** After the Opus reviewer of Task 2, the owner's ruling D16 added Task 2a, the
lexer and library fixes F1 to F11, between Task 2 (committed as `d95607d`, identical to the plan) and Task 3. Task 2
is unchanged. What else changed:
- **Part 1:** D16 in the decisions; Swift among the lexers; secret names in any case, and `bad-path`; the test plan's
  G3, G7, Lexer and Hook rows and a new Library row; totals of 94 tests and 20 mutations.
- **Task 4:** two more G3 tests, a named argument in a bare parenthesis and `m.Text('x')`, both refused (15 tests).
- **Task 8:** G7's secret-file test also names `.ENV`, `x.PEM` and `AuthKey.P8` (still 8 tests).
- **Task 11:** `guards.py` reports `Source.findings` (`source <path>:0 bad-path`, then `source: FAIL`), and a fifth
  hook test proves a staged path that is not UTF-8 is refused. The repository totals are 94 tests and 20 mutations.
- **Task 12:** the same totals.
- **Task 15:** Status.md's totals, the pointer to D16, and banked items 4 (G7 in tracked mode) and 5 (the official
  lexers).

The files were first built and run in a scratch worktree, `./.scratch/build`. The whole plan was then replayed from
this file on a clean worktree, `./.scratch/replay`, detached at `5ca866c`, the commit before Task 2:
- Tasks 1 to 12 and Task 2a, as stated: every red run failed as stated, every green run passed with the stated
  count, all 20 mutations were caught, and every commit passed the hook, run by hand.
- Task 2's files, extracted from this plan, were byte-identical to `d95607d`.
- Task 13, as far as the sandbox allows: `check_all.sh` failed on `hooks-path` alone, the canary was refused by the
  hook, and the clean-up left `git status --short` empty.
- Task 14: all six edits applied exactly once.
- Task 15 committed.

The guards were then run over the replayed tree with this file in it, and all passed. The worktrees were removed.

**Third amendment, 2026-11-09 (D17).** After the Opus reviewer of Task 2a, the owner's ruling D17 (2026-11-07) added
Task 2b, "Fail closed on what the guards don't understand", between Task 2a (committed as `61dcd57`, identical to the
plan) and Task 3. Tasks 2 and 2a are unchanged, except F10's prose in Task 2a, corrected to match its code (R5). What
else changed:
- **Part 1:** D17 in the decisions; G0 in what branch 1 builds, the layout, the fail-closed rule and the guards'
  readings; the test plan's new G0 row and its Lexer and Library rows; totals of 101 tests and 22 mutations.
- **Task 11:** `guards.py` runs G0 first. The repository totals are 101 tests and 22 mutations.
- **Task 12:** the same totals.
- **Task 14:** Edit 7 adds G0 to `CLAUDE.md`'s list of checks; the edits are now numbered of 7. `CLAUDE.md` does not
  contain the words "G1 to G9", so no replacement of them was written.
- **Task 15:** Status.md's rulings pointer names D17, G0 is listed as armed, the totals, and banked items 6 to 10
  (findings 5 and 7, and the seven minor notes, from `scaffold-1-review-2a.md`).

Task 2b was first built and run in a scratch worktree, `./.scratch/build`. The whole plan was then replayed from this
file on a clean worktree, `./.scratch/replay`, detached at `5ca866c`, the commit before Task 1:
- Tasks 1 to 12, 2a and 2b, as stated: every red run failed as stated, every green run passed with the stated count,
  all 22 mutations were caught, and every commit from Task 11 on passed the hook, run by hand.
- Task 2's files, extracted from this plan, were byte-identical to `d95607d`, and Task 2a's to `61dcd57`.
- Task 13, as far as the sandbox allows: `check_all.sh` failed on `hooks-path` alone, the canary was refused by the
  hook, and the clean-up left `git status --short` empty.
- Task 14: all seven edits applied exactly once.
- Task 15 committed.

The guards were then run over the replayed tree with this file in it, and all passed. The worktrees were removed.

**Fourth amendment, 2026-11-09 (the owner's rulings of 2026-11-07).** The owner answered the third amendment's
questions: CLAUDE.md needs no "G1 to G9" replacement beyond Edit 7; G0 is added to `docs/workflow.md` (e); the hidden
substitution in quoted arithmetic (A/B-1) is banked; and Task 2a's two untrue F7 sentences are corrected in place. The
owner also ruled that the distress check and Help's Call, Chat and Read are gone, with nothing built for them, and that
`CLAUDE.md` R8, R9 and R10 stay as they are. No code changed. What changed:
- **The header:** this amendment.
- **Task 2a:** F7's prose on Swift regex literals (finding B1) and on unscanned kinds (finding B3), corrected to match
  its code.
- **Task 2b:** the two sentences of R1 and R3 that pointed at those statements, reworded to match.
- **Task 14:** twelve edits, numbered of 12. Edit 8 adds G0 to `docs/workflow.md` (e). Edit 9: the server's feedback
  is deleted at a cohort's review with no copy, and only the totals keep the original's method (d). Edit 10: a safety
  export before a storage change reaches the Cohort 0 app (c). Edits 11 and 12: the Cohort 0 app is
  `app.souldreams.founder`, installed from Xcode only, and the TestFlight build is the testers' `app.souldreams` (i).
  The commit message names the rulings.
- **Task 15:** Status.md's rulings pointer names this amendment; branch 2 is the app in three flavours; branch 3 names
  the docs copies; banked items 11 (A/B-1), 12 (the model's instructions and G4) and 13 (the distress check and Help
  are gone; R8 and R9 to be amended once the ruling is filed upstream).

The whole plan was replayed from this file on a clean worktree, `./.scratch/replay`, detached at `96c2787` ("Read-block
Downloads and iCloud folders"), where Tasks 1, 2 and 2a are already committed:
- Tasks 1, 2 and 2a: `.gitignore` matched and both paths were ignored; Task 2's six files, extracted from this plan,
  were byte-identical to `d95607d`; with Task 2a's applied, the eight files were byte-identical to `61dcd57` and to the
  start commit, with nothing else under `tool/`; `Ran 32 tests`, `OK`; mutations 16 to 20 caught.
- Tasks 2b to 12, as stated: every red run failed as stated, every green run passed with the stated count, all 22
  mutations were caught, and every commit from Task 11 on passed the hook, run by hand.
- Task 13, as far as the sandbox allows: `check_all.sh` failed on `hooks-path` alone, the canary was refused by the
  hook, and the clean-up left `git status --short` empty.
- Task 14: all twelve edits applied exactly once, in order.
- Task 15 committed.

The guards were then run over the replayed tree with this file in it, and all passed. The worktree was removed.

**Fifth amendment, 2026-11-09 (the owner's ruling of 2026-11-07, filed upstream as C147-I and C15-P).** The owner
accepted all four of the fourth amendment's leans. Crisis material, the crisis check and the Help page are scrapped
indefinitely. No code changed. What changed:
- **The header:** this amendment.
- **Task 14:** fourteen edits, numbered of 14, eight in `CLAUDE.md`. Edit 13: R8 no longer names the distress results.
  Edit 14: R9 is replaced by "No crisis material, crisis check or Help". The intro says so, in place of "R8, R9 and
  R10 stay as they are".
- **Task 15:** banked item 13 (the distress check and Help) is removed, resolved by Edits 13 and 14.

The whole plan was replayed from this file on a clean worktree, `./.scratch/replay`, detached at `96c2787`, as in the
fourth amendment:
- Tasks 1, 2 and 2a: byte-identical to `d95607d` and `61dcd57`, `Ran 32 tests`, `OK`, and mutations 16 to 20 caught.
- Tasks 2b to 12, as stated: every red run failed as stated, every green run passed with the stated count, all 22
  mutations were caught, and every commit from Task 11 on passed the hook, run by hand.
- Task 13, as far as the sandbox allows: `check_all.sh` failed on `hooks-path` alone, the canary was refused by the
  hook, and the clean-up left `git status --short` empty.
- Task 14: all fourteen edits applied exactly once, in order.
- Task 15 committed, with banked items 1 to 12.

The guards were then run over the replayed tree with this file in it, and all passed. The worktree was removed.

**Sixth amendment, 2026-11-09 (the owner's ruling of 2026-11-07 on the review of Task 2b).** Task 2b is committed as
`ef4360c`, identical to the plan. The reviewer's report is `.scratch/for-build-chat/scaffold-1-review-2b.md`. What
changed:
- **The header:** this amendment.
- **Part 1:** the ruling in the decisions; G0's reading and the fail-closed rule (listed kinds only as UTF-8 text);
  the test plan's G0 and Lexer rows; totals of 105 tests and 23 mutations.
- **Task 2c, new**, between Task 2b and Task 3: C1, G0 knows `.md`, `.csv` and every listed name or path only when
  `src.text(path)` is not `None`; C2, in Swift, `try` joins the words after which a `/` starts a regex; four new
  tests (two failing first, two controls) and mutation 23 for C1.
- **Tasks 11 and 12:** totals of 105 tests and 23 mutations.
- **Task 15:** Status.md's totals, the pointer to this ruling, and banked items 13 (S1 and S2 under D15), 14 (K1 to K4)
  and 15 (G0 and `.gitkeep` and `.fvmrc`; the false findings that fail closed).

Task 2c was first built and run in a scratch worktree, `./.scratch/build`, detached at `ef4360c`. The whole plan was
then replayed from this file on a clean worktree, `./.scratch/replay`, detached at `ef4360c`, where Tasks 1 to 2b are
already committed:
- Tasks 1 to 2b: `.gitignore` matched; Task 2's files, extracted from this plan, were byte-identical to `d95607d`, with
  Task 2a's to `61dcd57`, and with Task 2b's to `ef4360c` and to the start commit, with nothing else under `tool/`;
  `Ran 39 tests`, `OK`; mutations 16 to 22 caught.
- Tasks 2c to 12, as stated: every red run failed as stated, every green run passed with the stated count, all 23
  mutations were caught, and every commit from Task 11 on passed the hook, run by hand.
- Task 13, as far as the sandbox allows: `check_all.sh` failed on `hooks-path` alone, the canary was refused by the
  hook, and the clean-up left `git status --short` empty.
- Task 14: all fourteen edits applied exactly once, in order.
- Task 15 committed, with banked items 1 to 15.

The guards were then run over the replayed tree with this file in it, and all passed. The worktree was removed.

**Seventh amendment, 2026-11-09 (the owner's ruling of 2026-11-09 on the review of Task 2c).** Task 2c is committed as
`18c428b`, identical to the plan. The reviewer's report is `.scratch/for-build-chat/scaffold-1-review-2c.md`. What
changed:
- **The header:** this amendment.
- **Part 1:** the ruling in the decisions; G0's reading and the fail-closed rule (code and config only as UTF-8
  text); the test plan's G0 and Lexer rows; totals of 108 tests and 25 mutations.
- **Task 2d, new**, between Task 2c and Task 3: D1, G0 knows config only when `src.text(path)` is not `None`; D2,
  `test_division_near_try_still_lexes` compares TypeScript's code whole; D3, the sweep of every place a guard can read
  nothing, whose one gap (G6 and G7 on code that does not decode) the same G0 line closes; three new tests (two
  failing first, one control) and mutations 24 (D1) and 25 (D2, which survives first).
- **Tasks 11 and 12:** totals of 108 tests and 25 mutations.
- **Task 15:** Status.md's totals and the pointer to this ruling. The banked items are unchanged.

Task 2d was first built and run in a scratch worktree, `./.scratch/build`, detached at `18c428b`. The whole plan was
then replayed from this file on a clean worktree, `./.scratch/replay`, detached at `18c428b`, where Tasks 1 to 2c are
already committed:
- Tasks 1 to 2c: `.gitignore` matched; Task 2's files, extracted from this plan, were byte-identical to `d95607d`, with
  Task 2a's to `61dcd57`, with Task 2b's to `ef4360c`, and with Task 2c's to `18c428b` and to the start commit, with
  nothing else under `tool/`; `Ran 43 tests`, `OK`; mutations 16 to 23 caught.
- Tasks 2d to 12, as stated: every red run failed as stated, mutation 25 survived and then was caught as stated, every
  green run passed with the stated count, all 25 mutations were caught, and every commit from Task 11 on passed the
  hook, run by hand. The build tree's `tool/` was byte-identical to the replayed Task 2d commit.
- Task 13, as far as the sandbox allows: `check_all.sh` failed on `hooks-path` alone, the canary was refused by the
  hook, and the clean-up left `git status --short` empty.
- Task 14: all fourteen edits applied exactly once, in order.
- Task 15 committed, with banked items 1 to 15.

The guards were then run over the replayed tree with this file in it, and all passed. The worktree was removed.

*No matter where you are on your journey, the steps you take are equally important.*
