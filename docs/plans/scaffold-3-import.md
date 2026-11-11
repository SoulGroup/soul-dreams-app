# Plan: scaffold-3-import (Scaffolding, branch 3 of 4)

*No matter where you are on your journey, the steps you take are equally important.*

Written by Claude Code (Opus) on 2026-11-10 from the investigation (`.scratch/for-build-chat/scaffold-3-investigation.md`)
and the owner's rulings D32. **Proven before committing as far as the sandbox allows** (Part 5). Only this file is
committed by the planning step; nothing here was implemented yet. **The branch is built. Where the build differs from
this text (the owner's rulings D33 to D40), Part 6 says so and governs; Parts 1 to 5 are kept as planned.**

## Part 1 · Spec

### In plain words

The owner imports the documents the build reads, and the register and lists the app's words come from. Each file is
copied at the sha256 its filing recorded, from a clean and synced documents repository, and listed in
`docs/source/SOURCES`. A generator turns the register and lists into Dart (`lines.g.dart`, `lists.g.dart`) and into
the iOS home-screen name and microphone text. G1 then proves on every commit that the generated words are exactly what
the generator makes from the imported files, and G2 that every copy matches its hash. The awaiting-import marker goes,
and both guards are armed. Claude Code never reads the documents repository: the owner runs the import.

### What branch 3 builds

- `tool/import.sh` and `tool/checks/importer.py`: the import (D32 Q2 to Q5, Q21). Its allowlist is
  `tool/checks/import_rows.py`.
- `tool/checks/wordsgen.py`: the words generator (D32 Q6 to Q17).
- G1 armed with the generator comparison, and with a rule that nothing else sits in `app/lib/words/` or
  `app/assets/words/`. G0, G2 and G4 changed as D32 Q18 rules.
- The iOS wiring: `words.g.xcconfig` included by the three flavours, `Info.plist`'s microphone key and
  `CFBundleName`, and `InfoPlist.strings` in English and Swedish in the Xcode project (D32 Q16, Q17; banked items 1
  and 29).
- The first import (the owner's), and Status.md, CLAUDE.md and `docs/workflow.md` brought up to date.

### What branch 3 does not build

- No screen uses a line yet. Nothing is shown to a dreamer that was not shown before, except the home-screen name of
  the founder and tester apps, which `[MP·55]` held until now.
- No plural or grammar logic (D32 Q13, banked). No language choice at run time, and no `CFBundleLocalizations`
  (D32 Q17).
- **Later branches, not this one** (Head of Technology, with D32): the import gains a kind for lens sections 3, 4,
  5, 6 and 11 only, with a guard G10 refusing any other `## ` heading in them, and a kind for
  `lens-register-waking-material-pass.md`, imported whole into `server/instructions/`. The importer's `KINDS` table
  and `import_rows.py` are where both land; nothing for them is built now.
- No new dependency, app or server. Python standard library and POSIX shell only (D6).

### The decisions, by number

| | Ruling | Where it lands |
|---|---|---|
| D31 | The brief that opened this branch, 2026-11-10: the owner runs the import with each file's expected sha256 from its filing; the script refuses a dirty or unsynced documents repository; the copied set is Status.md's branch 3 list; lines only for "written", "written, in its parts" and "composed (stand-in written)"; any unknown status stops the generator; both languages generated; MP·55 replaces `[MP·55]` and `CFBundleName` follows it; EM·3 becomes the iOS microphone text. *Read as D31 by this plan: Part 4, question 1* | All tasks |
| D32 Q1 | Import first: the copies arrive (Task 2) before the generator is written (Task 4), and Task 3 reads their shape | Order of tasks |
| D32 Q2 | Three arguments: documents path, sha256, filing ordinal. `docs/workflow.md`'s import line is edited to match (the owner approves at the prompt) | Tasks 1, 9 |
| D32 Q3 | The wrapper `tool/import.sh`; the code in `tool/checks/importer.py` and `tool/checks/wordsgen.py` | Tasks 1, 4 |
| D32 Q4 | "Unsynced": after `git fetch`, HEAD differs from its upstream, or there is none | Task 1 |
| D32 Q5 | At Task 2 the owner gives each row's documents path, destination name and current filing ordinal | Task 2 |
| D32 Q6 | The status table, with `paused:`, `blocked:` and `merged into <handle>` as prefixes, the handle checked | Task 4 |
| D32 Q7 | "no line: by decision" and "no line: prohibition" get no constant | Task 4 |
| D32 Q8 | A line status with an empty English or Swedish field stops the generator | Task 4 |
| D32 Q9 | A leading BOM in the register is accepted | Task 4 |
| D32 Q10 | The generator ignores `flag`: the status alone decides whether a line exists; screen specs read flags | Task 4 |
| D32 Q11 | `" / "` gives a list of parts; alternative or successive is each screen's spec | Task 4 |
| D32 Q12 | `¶` becomes `"\n\n"` inside a part | Task 4 |
| D32 Q13 | Slots by plain replacement, `{n}` an `int`; plurals banked | Task 4 |
| D32 Q14 | The compile-time Dart API (`Lines.MP_55`, `Lang`, `parts()`, `text()`, `standIn`, slot methods) | Task 4 |
| D32 Q15 | The lists' shape settled at Task 3 from the real file; any section but TECH·1 to TECH·5 stops the generator | Tasks 3, 4 |
| D32 Q16 | The home-screen name is not localized. MP·55 is one name in both languages, and **the generator stops if its English and Swedish ever differ** | Task 4 |
| D32 Q17 | A generated `words.g.xcconfig` included by all three flavours; the base microphone value `$(WORDS_MIC_USAGE)`; `sv` in `knownRegions`; no `CFBundleLocalizations` yet. Supersedes the owner's earlier in-place lean | Task 7 |
| D32 Q18 | G0 knows the two `InfoPlist.strings`; G4 exempts the generated words (EM·3 is about 15 words); G1 refuses unknown files in the words folders; G2 refuses `privacy-ethics-safety.md` by name | Task 5 |
| D32 Q19 | The settings additions, after a canary proof at Task 0 | Task 0 |
| D32 Q20 | The K-items (banked item 14) stay banked | — |
| D32 Q21 | The import refuses to run on `main` | Task 1 |

### The import

    SOUL_DREAMS_DOCS=<documents repository> tool/import.sh <documents path> <expected sha256> <filing ordinal>

- **Where the documents are.** The wrapper reads their location from `SOUL_DREAMS_DOCS`, which the owner sets in his
  paste. No file in this repository names the documents repository's path (R6). It refuses to start when it is unset.
  This is a reading of D32 Q2 (Part 4, question 2).
- **Refusals**, each a code, each writing nothing:
  - the arguments: `usage`, `bad-hash` (not 64 lowercase hex), `bad-ordinal` (empty, outer spaces, a control
    character), `bad-path` (absolute, empty, `.` or `..` parts, a backslash);
  - `refused-document`: a `restricted` folder anywhere in the path, or `privacy-ethics-safety.md`;
  - `not-allowed`: the path is not a row of `import_rows.py`; `bad-row`: a row whose destination does not fit its
    kind;
  - this repository: `app-not-a-repository`, `on-main`;
  - the documents repository: `docs-not-a-repository`, `docs-dirty` (anything in `git status --porcelain
    --untracked-files=all`), `docs-fetch-failed`, `docs-no-upstream`, `docs-unsynced`;
  - the file: `not-tracked`, `not-a-file` (a symlink), `hash-mismatch`, `not-text` (a NUL byte or not UTF-8);
  - `sources-malformed`: the existing SOURCES has a line that does not parse.
- **The bytes are read from `HEAD:<path>`**, never the working file, so what is hashed is what is copied, and it
  is what the documents repository committed.
- **Kinds.** `copy` lands as `docs/source/<name>.md` (flat, CLAUDE.md's `docs/source/technology-handover.md`);
  `words` is the register, `lists` the lists. A row's destination must fit its kind.
- **SOURCES**: a two-line `#` header, then one line per file, sorted by path, in the branch 1 format
  `<sha256>␠␠<path>␠␠<ordinal>` that `guardlib.parse_sources` reads. Written atomically. Re-importing the same file
  at the same hash and ordinal changes nothing and says `unchanged`.
- **After a `words` or `lists` import** (from Task 5 on), the generator runs and writes, once both files are present.
  A generator refusal is reported by code and row, and the import exits 1.
- It never stages or commits. It ends `import: review git status, then commit`.

### The generator

`wordsgen.generate(csv_bytes, lists_bytes)` returns `{path: bytes}` for the five generated paths. It is a pure
function, so G1 calls it on the bytes it reads from the index. `--write` writes them, `--check` compares them.

| Status | Line | Dart |
|---|---|---|
| `written`, `written, in its parts` | English and Swedish | `static const X = Line('X', [...], [...]);` |
| `composed (stand-in written)` | the stand-in | the same, `standIn: true` |
| `to rewrite`, `to write`, `composed, no stand-in`, `paused: …`, `blocked: …` | none | `Line('X', null, null)`: shows `[X]` (R1) |
| `retired`, `no line: by decision`, `no line: prohibition`, `merged into <handle>` | none | no constant |
| anything else | the generator stops: `unknown-status`, with the row | |

- The register must have exactly the header `handle,place,source,screen,also_on,moment,must,never,length,status,
  draft,english,swedish,flag`. Only `handle`, `status`, `english` and `swedish` are read. The register is never
  bundled into the app.
- Handles match `^[A-Z][A-Z0-9]*·[0-9]+$` and are unique; the Dart name is the handle with `·` as `_`.
- `" / "` splits parts, `¶` (spaces around it trimmed) joins paragraphs with `"\n\n"`, and both languages must have
  the same number of parts.
- Slots: `{n}` (`int n`), `{pointed image}` (`String pointedImage`), `{tradition}`, `{read image}` (`readImage`).
  Any other brace stops the generator; both languages must use the same slots. A place with slots is a method:
  `Lines.X(n: 3)` returns a `Line` with the slots filled in one pass.
- MP·55 and EM·3 must each be one part, one paragraph, no slot; their English must hold no `//` and no `$`
  (xcconfig cannot escape them); MP·55 must be the same in both languages (D32 Q16).
- The lists are provisional until Task 3 (D32 Q15): a `# ` title, any text before the first section, then `## TECH·1`
  to `## TECH·5` in order, each holding only `- word` lines and blank lines.
- Errors carry a source (`register` or `lists`), a code and a row number, never content. The summary prints the
  status counts with free text cut to `paused:`, `blocked:` and `merged into`.
- **Generated, byte for byte deterministic:** `app/lib/words/lines.g.dart`, `app/lib/words/lists.g.dart`,
  `app/ios/Flutter/words.g.xcconfig` (`WORDS_APP_NAME`, `WORDS_MIC_USAGE`),
  `app/ios/Runner/en.lproj/InfoPlist.strings` and `sv.lproj/InfoPlist.strings`
  (`NSMicrophoneUsageDescription`). UTF-8, LF, the input's sha256 in each header, nothing else that varies.
- **G4 and the generator's own source:** `wordsgen.py` is code, so its Dart template is held as short lines (no
  literal of twelve words or more).

### Placeholders (R1)

- `[MP·55]` leaves `founder.xcconfig` and `tester.xcconfig` in Task 7.
- Every waiting place (`to rewrite`, `to write`, `composed, no stand-in`, `paused:`, `blocked:`) shows its handle as
  `[HANDLE]` through `Line.parts()`. Their handles are known only from the real register: Task 3's report lists them,
  and Task 9 writes the list into Status.md. No screen uses one yet.

### The guards after this branch

- **G1** (armed): SOURCES lists the register and lists at their hashes; the five generated files are what the
  generator makes from them (`generated-missing`, `generated-differs`, `generator-refused:<code>`); nothing else is
  in `app/lib/words/` or `app/assets/words/` (`words-unknown-file`).
- **G2** (armed): as built, plus `refused-document` for any tracked `privacy-ethics-safety.md` or path through a
  `restricted` folder, marker or not.
- **G0**: knows the two generated `InfoPlist.strings` by exact path; any other `.strings` is `unknown-kind`.
- **G4**: exempts the five generated paths, which G1 proves.
- **Two tests change their fixture, not their claim.** `test_hook.py` and `test_check_all.py` built trees that
  relied on the repository's own marker. They now write a marker into their own throwaway tree, and
  `test_check_all.py` also leaves out `docs/source/`. They still prove what they proved (the hook reads the index; a
  failing guard fails `check_all.sh`). Without this, both fail the moment Task 6 deletes the marker (found by the
  replay, Part 5).

### Test plan

| Area | Refused (control) | Passed | Mutations that must be caught |
|---|---|---|---|
| Import | each refusal above, each writing nothing; a working file that differs while `skip-worktree` hides it (copies HEAD) | a clean import; a re-import replacing the line; the same import twice; SOURCES read back by `parse_sources`; the wrapper with and without `SOUL_DREAMS_DOCS` | 33 skip the hash compare. 34 drop the dirty check. 35 drop the upstream compare. 36 read the working file. 37 allow any path |
| Generator | every error code; free text never printed; a refusal writes nothing | each status; parts, paragraphs, slots, escaping; BOM; same bytes twice; `--write` then `--check`; the iOS files | 38 an unknown status becomes a line. 39 no `" / "` split. 40 `$` unescaped. 41 `retired` gets a constant. 42 MP·55 may differ by language |
| G1 | no generated files; a changed `lines.g.dart`; a hand-edited xcconfig; extra files in both words folders; a register or lists the generator refuses | a full invented set | 43 skip the byte compare. 44 drop the unknown-file rule. 45 ignore a generator refusal |
| G2 | `privacy-ethics-safety.md` listed and matching; a `restricted/` folder; the name outside `docs/` | `restricted.md`, `restricted-x/` | 46 empty the refused names |
| G0 | `de.lproj/InfoPlist.strings`, `a.strings` | the two generated paths | 47 drop the two paths |
| G4 | 12 words in `founder.xcconfig` | 15 words in `words.g.xcconfig` | 48 drop the exemption |
| App (Task 7) | — | MP·55 one part, the same in both languages; EM·3 written in both; a waiting place shows `[HANDLE]`; parts agree; handles unique | — |

Totals once built: **172 guard tests and 48 mutations** (from 117 and 32: Task 1 adds 17 tests and 5 mutations,
Task 4 25 and 5, Task 5 13 and 6). The app's tests go from 9 to 14. Every control is invented: placeholder words
(`word`, `Name`, `mic word`), placeholder hosts (`x.example`), and registers built in the test. No dreamer line, no
dream and no register line appears in this plan (R1, R2).

---

## Part 2 · Settings (the owner's, in Task 0)

`.claude/settings.json` is the owner's; Claude Code cannot write it. D32 Q19 adds:

- `permissions.deny`: `Edit(/app/ios/Flutter/words.g.xcconfig)`, `Edit(/app/ios/Runner/en.lproj/**)`,
  `Edit(/app/ios/Runner/sv.lproj/**)`.
- `permissions.ask`: `Edit(/tool/import.sh)`.
- `sandbox.filesystem.denyWrite`: `./app/ios/Flutter/words.g.xcconfig`, `./app/ios/Runner/en.lproj`,
  `./app/ios/Runner/sv.lproj`, `./tool/import.sh`.

Already covered: `app/lib/words/`, `app/assets/words/`, `docs/source/` (Edit and sandbox), and `tool/checks/`
(sandbox; Edit allowed, as for the guards).

---

## Part 3 · The tasks

**Who runs what.** Tasks marked **[OWNER]** are the owner's pastes. Claude Code stops before each, gives the paste,
and waits for the output. Everything else is Claude Code's.

**How files are written.** As in branch 2: files under `tool/checks/` and `tool/import.sh` go in through the Write
and Edit tools (the sandbox refuses shell writes there); so do files under `app/`. A **New file** block is written
whole. An **Edit** block replaces its first fence with its second, and the first must occur exactly once.

**Commits.** Each Claude Code task ends green with its own commit, through the hook (never `--no-verify`). Every
commit message ends with the line `Co-Authored-By: <the model that wrote it> <noreply@anthropic.com>`.
**From Task 2 to Task 6, the imported copies sit untracked in the working tree.** Claude Code stages by path only
(`git add tool/`, never `git add -A` or `git add .`). Staged by mistake, they are refused by the marker: G1
`marker-with-sources` and G2 on each copy.

**Red, then green.** Each Claude Code task first writes its tests and runs them; the run must fail as stated. Then
it writes the code, and the run must pass with the stated count. Any other result stops the task (R14).

**The gate** at the end of every Claude Code task, from the repository root:

    python3 -I -B tool/checks/tests/run_tests.py
    python3 -I -B tool/checks/tests/mutations.py
    python3 -I -B tool/checks/guards.py

and, from `app/` in Tasks 4 and 7: `fvm flutter analyze --no-pub` (`No issues found!`) and `fvm flutter test --no-pub`
(`All tests passed!`). Claude Code never runs `pub get` or `tool/check_all.sh` in this branch (Part 4, question 5).

### Task 0 · Canary proof, settings and baselines (D32 Q19)

1. **Canary, before the settings change.** Claude Code runs, from the repository root:

       : > tool/checks/__canary__; echo "exit=$?"; ls tool/checks/__canary__ 2>&1

   Expected: a refusal (`Operation not permitted`), a non-zero exit, and `No such file`. **If the file was created,**
   Claude Code deletes it and stops: the sandbox does not enforce `settings.json` there, and the owner decides
   (the investigation saw `tool/checks` among this session's writable paths and could not tell which rule wins).

2. **[OWNER] The settings.** The owner adds the Part 2 lines to `.claude/settings.json`, commits them on this branch,
   restarts Claude Code (`/exit`, then the opening command in `docs/workflow.md`), and sends back
   `git show --stat HEAD`.

3. **Canary, after.** Claude Code runs:

       for p in tool/import.sh app/ios/Flutter/words.g.xcconfig app/ios/Runner/en.lproj/x app/ios/Runner/sv.lproj/x; do
         mkdir -p "$(dirname "$p")" 2>/dev/null; : > "$p" && echo "WROTE $p"; done; git status --short

   Expected: four refusals, no `WROTE`, `git status` empty. A `WROTE` line stops the task (remove that file, report).

4. **Baselines.** `python3 -I -B tool/checks/tests/run_tests.py` ends `Ran 117 tests`, `OK`;
   `python3 -I -B tool/checks/tests/mutations.py` ends `mutations: 32 run, all caught`; from `app/`,
   `fvm flutter analyze --no-pub` prints `No issues found!` and `fvm flutter test --no-pub` passes 9 tests. Any other
   result stops the branch.

### Task 1 · The import (D32 Q2 to Q5, Q21)

Red: write `tool/checks/tests/test_import.py` (below) alone, then run
`python3 -I -B tool/checks/tests/run_tests.py test_import`. Expected: `Ran 17 tests`, `FAILED (failures=17)` (the
importer does not exist). Then write the other files and the mutation rows, and run it again. Expected: `Ran 17 tests`, `OK`.
Gate: `Ran 134 tests`, `OK`; `mutations: 37 run, all caught`; guards all passed (G1 and G2 NOT ARMED).

**New file `tool/checks/import_rows.py`**

~~~~python
# The files the import may copy (docs/workflow.md, "Imports"; D32 Q5).
# One row per file: its path in the documents repository, its path in
# this repository, and its kind (importer.KINDS). Anything not listed
# here is refused. The owner gives the documents paths; Task 2a fills
# them in.
ROWS = ()
~~~~

**New file `tool/checks/importer.py`**

~~~~python
# The import (docs/workflow.md, "Imports"; D32). Copies one file the
# owner names, at the sha256 its filing recorded, from the documents
# repository into this one, and records it in docs/source/SOURCES.
# Only the owner runs it, through tool/import.sh: Claude Code cannot
# read the documents repository (R6). On any doubt it refuses and
# writes nothing. It prints codes and paths, never a file's content.
# Usage: importer.py --docs DIR <documents path> <sha256> <ordinal>
# Exit 0 done (or unchanged), 1 refused, 2 internal error.
import os
import posixpath
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
TOP = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)

from guardlib import CSV, LISTS, SOURCES, report, sha256  # noqa: E402
import import_rows  # noqa: E402

# Each kind says where its files may land. Later kinds (the model's
# instructions in server/instructions/, the lens sections with their
# own guard) are new rows here and in import_rows.py (D32).
KINDS = {
    'copy': lambda dest: dest.startswith('docs/source/') and dest.endswith('.md')
    and dest.count('/') == 2 and dest != SOURCES,
    'words': lambda dest: dest == CSV,
    'lists': lambda dest: dest == LISTS,
}
REFUSED_NAMES = ('privacy-ethics-safety.md',)
HEX = re.compile(r'^[0-9a-f]{64}$')
SOURCES_LINE = re.compile(r'^([0-9a-f]{64})  (\S+)  (\S.*)$')
HEADER = ('# Every imported file: its sha256, path here and filing.\n'
          '# Written by tool/import.sh only. Never edited by hand.\n')


class Refused(Exception):
    def __init__(self, code):
        Exception.__init__(self, code)
        self.code = code


def git(where, *args):
    r = subprocess.run(('git', '-C', where) + args, capture_output=True)
    if r.returncode != 0:
        return None
    return r.stdout


def check_args(path, digest, ordinal):
    if not HEX.match(digest):
        raise Refused('bad-hash')
    if (not ordinal or ordinal != ordinal.strip()
            or any(ord(c) < 32 or ord(c) == 127 for c in ordinal)):
        raise Refused('bad-ordinal')
    parts = path.split('/')
    if path.startswith('/') or '\\' in path or any(p in ('', '.', '..') for p in parts):
        raise Refused('bad-path')
    if 'restricted' in parts or parts[-1] in REFUSED_NAMES:
        raise Refused('refused-document')


def row_for(path):
    for docs_path, dest, kind in import_rows.ROWS:
        if docs_path == path:
            if kind not in KINDS or not KINDS[kind](dest):
                raise Refused('bad-row')
            return dest, kind
    raise Refused('not-allowed')


def check_docs(docs):
    top = git(docs, 'rev-parse', '--show-toplevel')
    if top is None or os.path.realpath(top.decode().strip()) != os.path.realpath(docs):
        raise Refused('docs-not-a-repository')
    if git(docs, 'status', '--porcelain', '--untracked-files=all') != b'':
        raise Refused('docs-dirty')
    if git(docs, 'fetch', '--quiet') is None:
        raise Refused('docs-fetch-failed')
    head = git(docs, 'rev-parse', 'HEAD')
    upstream = git(docs, 'rev-parse', '@{u}')
    if upstream is None:
        raise Refused('docs-no-upstream')
    if head != upstream:
        raise Refused('docs-unsynced')


def read_committed(docs, path):
    # The bytes of the file as committed at HEAD, never the working file.
    tree = git(docs, 'ls-tree', 'HEAD', '--', path)
    if not tree:
        raise Refused('not-tracked')
    mode = tree.split(b' ', 1)[0]
    if mode not in (b'100644', b'100755'):
        raise Refused('not-a-file')
    data = git(docs, 'cat-file', 'blob', 'HEAD:' + path)
    if data is None:
        raise Refused('not-tracked')
    return data


def read_sources():
    full = os.path.join(TOP, SOURCES)
    entries = {}
    if not os.path.exists(full):
        return entries
    with open(full, 'rb') as f:
        text = f.read().decode('utf-8')
    for line in text.split('\n'):
        if not line.strip() or line.startswith('#'):
            continue
        m = SOURCES_LINE.match(line)
        if not m or m.group(2) in entries:
            raise Refused('sources-malformed')
        entries[m.group(2)] = (m.group(1), m.group(3))
    return entries


def write_atomic(rel, data):
    full = os.path.join(TOP, rel)
    folder = os.path.dirname(full)
    os.makedirs(folder, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=folder, prefix='.import-')
    try:
        with os.fdopen(fd, 'wb') as f:
            f.write(data)
        os.replace(tmp, full)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def sources_text(entries):
    lines = [HEADER]
    for path in sorted(entries):
        digest, ordinal = entries[path]
        lines.append('%s  %s  %s\n' % (digest, path, ordinal))
    return ''.join(lines).encode('utf-8')


def run(docs, path, digest, ordinal):
    check_args(path, digest, ordinal)
    dest, kind = row_for(path)
    if git(TOP, 'rev-parse', '--git-dir') is None:
        raise Refused('app-not-a-repository')
    if git(TOP, 'symbolic-ref', '--short', '-q', 'HEAD') == b'main\n':
        raise Refused('on-main')
    check_docs(docs)
    data = read_committed(docs, path)
    if sha256(data) != digest:
        raise Refused('hash-mismatch')
    if b'\0' in data:
        raise Refused('not-text')
    try:
        data.decode('utf-8')
    except UnicodeDecodeError:
        raise Refused('not-text')
    entries = read_sources()
    full = os.path.join(TOP, dest)
    if entries.get(dest) == (digest, ordinal) and os.path.isfile(full):
        with open(full, 'rb') as f:
            if f.read() == data:
                report('import: unchanged ' + dest)
                return kind
    entries[dest] = (digest, ordinal)
    write_atomic(dest, data)
    write_atomic(SOURCES, sources_text(entries))
    report('import: hash ok, copied ' + dest)
    report('import: recorded in ' + SOURCES)
    return kind


def main(argv):
    if len(argv) != 5 or argv[0] != '--docs':
        report('import: refused usage')
        return 1
    try:
        run(argv[1], argv[2], argv[3], argv[4])
    except Refused as e:
        report('import: refused ' + e.code)
        return 1
    report('import: review git status, then commit')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception as e:  # never print a message: it could quote a file
        report('import: internal error ' + type(e).__name__)
        sys.exit(2)
~~~~

**New file `tool/import.sh`** (executable: `git update-index --chmod=+x tool/import.sh` after adding)

~~~~sh
#!/bin/sh
# The owner's import (docs/workflow.md, "Imports"; D32). Usage:
#   SOUL_DREAMS_DOCS=<documents repository> tool/import.sh <path> <sha256> <ordinal>
# Only the owner runs it: Claude Code never reads the documents (R6).
set -eu
: "${SOUL_DREAMS_DOCS:?set it to the documents repository}"
top=$(cd "$(dirname "$0")/.." && pwd)
exec python3 -I -B "$top/tool/checks/importer.py" --docs "$SOUL_DREAMS_DOCS" "$@"
~~~~

**New file `tool/checks/tests/test_import.py`**

~~~~python
# The import, end to end, in throwaway repositories in $TMPDIR: a
# documents repository with a bare remote, and an app repository
# holding a copy of tool/checks with test rows. Nothing real is read.
import hashlib
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

from helpers import CHECKS

ENV = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1',
           GIT_AUTHOR_NAME='t', GIT_AUTHOR_EMAIL='t@x.example',
           GIT_COMMITTER_NAME='t', GIT_COMMITTER_EMAIL='t@x.example')
ROWS = ("ROWS = (\n"
        "    ('product/handover.md', 'docs/source/handover.md', 'copy'),\n"
        "    ('product/register.csv', 'app/assets/words/places-register.csv', 'words'),\n"
        "    ('product/lists.md', 'app/assets/words/founder-lists-for-technology.md', 'lists'),\n"
        "    ('product/odd.md', 'docs/elsewhere.md', 'copy'),\n"
        "    ('restricted/a.md', 'docs/source/a.md', 'copy'),\n"
        ")\n")
BODY = b'# Handover\n\nword word\n'
WRAPPER = os.path.join(os.path.dirname(CHECKS), 'import.sh')
ORDINAL = 'C1-T item 2'


def digest(data):
    return hashlib.sha256(data).hexdigest()


def git(where, *args):
    r = subprocess.run(('git', '-C', where) + args, capture_output=True, env=ENV)
    if r.returncode != 0:
        raise RuntimeError('git')
    return r.stdout


class Import(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix='import-')
        self.docs = os.path.join(self.tmp, 'docs')
        remote = os.path.join(self.tmp, 'remote.git')
        git(self.tmp, 'init', '-q', '--bare', '-b', 'main', remote)
        git(self.tmp, 'init', '-q', '-b', 'main', self.docs)
        self.put('product/handover.md', BODY)
        self.put('product/register.csv', b'a,b\n')
        self.put('product/odd.md', BODY)
        self.put('product/lists.md', b'# Lists\n')
        self.put('restricted/a.md', BODY)
        git(self.docs, 'add', '-A')
        git(self.docs, 'commit', '-q', '-m', 'docs')
        git(self.docs, 'remote', 'add', 'origin', remote)
        git(self.docs, 'push', '-q', '-u', 'origin', 'main')
        self.app = os.path.join(self.tmp, 'app')
        git(self.tmp, 'init', '-q', '-b', 'work', self.app)
        checks = os.path.join(self.app, 'tool', 'checks')
        shutil.copytree(CHECKS, checks, ignore=shutil.ignore_patterns('__pycache__', 'tests'))
        if os.path.exists(WRAPPER):  # not in the mutation checks' copy
            shutil.copy2(WRAPPER, os.path.join(self.app, 'tool', 'import.sh'))
        with open(os.path.join(checks, 'import_rows.py'), 'w', encoding='utf-8') as f:
            f.write(ROWS)

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def put(self, path, data):
        full = os.path.join(self.docs, path)
        os.makedirs(os.path.dirname(full), exist_ok=True)
        with open(full, 'wb') as f:
            f.write(data)

    def run_import(self, *args):
        script = os.path.join(self.app, 'tool', 'checks', 'importer.py')
        r = subprocess.run([sys.executable, '-I', '-B', script, '--docs', self.docs] + list(args),
                           capture_output=True, env=ENV)
        return r.returncode, r.stdout.decode()

    def app_files(self):
        out = []
        for d, dirs, files in os.walk(self.app):
            dirs[:] = [x for x in dirs if x not in ('.git', 'tool')]
            out += [os.path.relpath(os.path.join(d, f), self.app) for f in files]
        return sorted(out)

    def refused(self, code, *args):
        args = args or ('product/handover.md', digest(BODY), ORDINAL)
        rc, out = self.run_import(*args)
        self.assertEqual(rc, 1)
        self.assertIn('import: refused ' + code, out)
        self.assertEqual(self.app_files(), [])

    def sources(self):
        with open(os.path.join(self.app, 'docs', 'source', 'SOURCES'), encoding='utf-8') as f:
            return f.read()

    def test_clean_import_copies_and_records(self):
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 0, out)
        with open(os.path.join(self.app, 'docs', 'source', 'handover.md'), 'rb') as f:
            self.assertEqual(f.read(), BODY)
        line = '%s  docs/source/handover.md  %s\n' % (digest(BODY), ORDINAL)
        self.assertTrue(self.sources().endswith(line))
        self.assertEqual(self.app_files(), ['docs/source/SOURCES', 'docs/source/handover.md'])

    def test_sources_reads_back_through_guardlib(self):
        self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.run_import('product/register.csv', digest(b'a,b\n'), 'C2-P item 1')
        sys.path.insert(0, CHECKS)
        import guardlib
        src = guardlib.Source(self.app, 'walk')
        entries, findings = guardlib.parse_sources(src)
        self.assertEqual(findings, [])
        self.assertEqual(sorted(entries), ['app/assets/words/places-register.csv',
                                           'docs/source/handover.md'])

    def test_reimport_replaces_the_line(self):
        self.run_import('product/handover.md', digest(BODY), ORDINAL)
        new = BODY + b'more\n'
        self.put('product/handover.md', new)
        git(self.docs, 'commit', '-q', '-am', 'change')
        git(self.docs, 'push', '-q')
        rc, out = self.run_import('product/handover.md', digest(new), 'C3-T item 1')
        self.assertEqual(rc, 0, out)
        self.assertNotIn(digest(BODY), self.sources())
        self.assertEqual(self.sources().count('docs/source/handover.md'), 1)

    def test_same_import_twice_is_unchanged(self):
        self.run_import('product/handover.md', digest(BODY), ORDINAL)
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 0)
        self.assertIn('import: unchanged docs/source/handover.md', out)

    def test_wrapper_needs_the_documents_location(self):
        self.assertTrue(os.path.exists(WRAPPER))
        script = os.path.join(self.app, 'tool', 'import.sh')
        env = {k: v for k, v in ENV.items() if k != 'SOUL_DREAMS_DOCS'}
        r = subprocess.run(['sh', script, 'a', 'b', 'c'], capture_output=True, env=env)
        self.assertNotEqual(r.returncode, 0)
        r = subprocess.run(['sh', script, 'product/handover.md', digest(BODY), ORDINAL],
                           capture_output=True, env=dict(ENV, SOUL_DREAMS_DOCS=self.docs))
        self.assertEqual(r.returncode, 0, r.stdout)
        self.assertIn(b'import: hash ok, copied docs/source/handover.md', r.stdout)

    def test_hash_mismatch_refused(self):
        self.refused('hash-mismatch', 'product/handover.md', digest(b'other'), ORDINAL)

    def test_bad_arguments_refused(self):
        self.refused('bad-hash', 'product/handover.md', 'abc', ORDINAL)
        self.refused('bad-hash', 'product/handover.md', digest(BODY).upper(), ORDINAL)
        self.refused('bad-ordinal', 'product/handover.md', digest(BODY), '')
        self.refused('bad-ordinal', 'product/handover.md', digest(BODY), 'C1\tx')
        self.refused('bad-ordinal', 'product/handover.md', digest(BODY), ' C1')
        rc, out = self.run_import('product/handover.md', digest(BODY))
        self.assertEqual(rc, 1)
        self.assertIn('import: refused usage', out)

    def test_paths_refused(self):
        for path in ('/product/handover.md', 'product/../product/handover.md',
                     'product//handover.md', './product/handover.md'):
            self.refused('bad-path', path, digest(BODY), ORDINAL)
        self.refused('refused-document', 'restricted/a.md', digest(BODY), ORDINAL)
        self.refused('refused-document', 'product/privacy-ethics-safety.md', digest(BODY), ORDINAL)
        self.refused('not-allowed', 'product/other.md', digest(BODY), ORDINAL)
        self.refused('bad-row', 'product/odd.md', digest(BODY), ORDINAL)

    def test_dirty_docs_refused(self):
        self.put('product/new.md', b'x\n')
        self.refused('docs-dirty')

    def test_changed_working_file_refused(self):
        self.put('product/handover.md', b'changed\n')
        self.refused('docs-dirty', 'product/handover.md', digest(b'changed\n'), ORDINAL)

    def test_reads_the_committed_bytes(self):
        # A working file git is told to ignore: status is clean, but the
        # import must still copy the bytes committed at HEAD.
        self.put('product/handover.md', b'changed\n')
        git(self.docs, 'update-index', '--skip-worktree', 'product/handover.md')
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 0, out)
        with open(os.path.join(self.app, 'docs', 'source', 'handover.md'), 'rb') as f:
            self.assertEqual(f.read(), BODY)

    def test_unsynced_docs_refused(self):
        self.put('product/new.md', b'x\n')
        git(self.docs, 'add', '-A')
        git(self.docs, 'commit', '-q', '-m', 'local only')
        self.refused('docs-unsynced')

    def test_no_upstream_refused(self):
        git(self.docs, 'branch', '-q', '--unset-upstream')
        self.refused('docs-no-upstream')

    def test_not_a_repository_refused(self):
        shutil.rmtree(os.path.join(self.docs, '.git'))
        self.refused('docs-not-a-repository')

    def test_untracked_symlink_and_missing_refused(self):
        os.symlink('handover.md', os.path.join(self.docs, 'product', 'link.md'))
        git(self.docs, 'add', '-A')
        git(self.docs, 'commit', '-q', '-m', 'link')
        git(self.docs, 'push', '-q')
        with open(os.path.join(self.app, 'tool', 'checks', 'import_rows.py'), 'a',
                  encoding='utf-8') as f:
            f.write("ROWS += (('product/link.md', 'docs/source/link.md', 'copy'),\n"
                    "         ('product/gone.md', 'docs/source/gone.md', 'copy'))\n")
        self.refused('not-a-file', 'product/link.md', digest(b'handover.md'), ORDINAL)
        self.refused('not-tracked', 'product/gone.md', digest(BODY), ORDINAL)

    def test_on_main_refused(self):
        git(self.app, 'checkout', '-q', '-b', 'main')
        self.refused('on-main')

    def test_malformed_sources_refused(self):
        os.makedirs(os.path.join(self.app, 'docs', 'source'))
        with open(os.path.join(self.app, 'docs', 'source', 'SOURCES'), 'w') as f:
            f.write('not a line\n')
        rc, out = self.run_import('product/handover.md', digest(BODY), ORDINAL)
        self.assertEqual(rc, 1)
        self.assertIn('import: refused sources-malformed', out)
        self.assertFalse(os.path.exists(os.path.join(self.app, 'docs', 'source', 'handover.md')))


if __name__ == '__main__':
    unittest.main()
~~~~

**Edit `tool/checks/tests/mutations.py`** (1 of 1). Replace exactly:

~~~~python
     ['test_g5.G5.test_apple_writers_refused_in_swift_and_headers']),
]
~~~~

with:

~~~~python
     ['test_g5.G5.test_apple_writers_refused_in_swift_and_headers']),
    # Branch 3, Task 1 (D32): the import.
    ('importer.py', "if sha256(data) != digest:", "if False:",
     ['test_import.Import.test_hash_mismatch_refused']),
    ('importer.py', "if git(docs, 'status', '--porcelain', '--untracked-files=all') != b'':",
     "if False:",
     ['test_import.Import.test_dirty_docs_refused']),
    ('importer.py', "if head != upstream:", "if False:",
     ['test_import.Import.test_unsynced_docs_refused']),
    ('importer.py', "data = git(docs, 'cat-file', 'blob', 'HEAD:' + path)",
     "data = open(os.path.join(docs, path), 'rb').read()",
     ['test_import.Import.test_reads_the_committed_bytes']),
    ('importer.py', "    raise Refused('not-allowed')", "    return 'docs/source/x.md', 'copy'",
     ['test_import.Import.test_paths_refused']),
]
~~~~

Commit: `git add tool/checks/import_rows.py tool/checks/importer.py tool/import.sh tool/checks/tests/test_import.py
tool/checks/tests/mutations.py && git update-index --chmod=+x tool/import.sh`, message
`Import: tool/import.sh and importer.py, refusing on any doubt (D32 Q2-Q5, Q21)`. The commit records the file as
executable; the file on disk stays without its executable bit (the Write tool makes it, and Part 2 refuses shell
writes there), so `git status` shows `M tool/import.sh` until the owner's `chmod` in Task 2c.

### Task 2 · [OWNER] The rows, then the import (D32 Q1, Q5)

**2a [OWNER].** The owner gives, for each file of Status.md's branch 3 list, the documents path, the destination
and the current filing ordinal. Claude Code's proposed destinations (the owner confirms or changes each):

| File | Destination | Kind |
|---|---|---|
| the handover | `docs/source/technology-handover.md` | copy |
| the main path | `docs/source/main-path.md` | copy |
| how the AI appears | `docs/source/how-the-ai-appears.md` | copy |
| the design system | `docs/source/design-system.md` | copy |
| the experience map | `docs/source/experience-map.md` | copy |
| the product principles | `docs/source/product-principles.md` | copy |
| the requirements list | `docs/source/requirements-list.md` | copy |
| the tester disclosure specification | `docs/source/tester-disclosure-specification.md` | copy |
| `interpretation/change-record.md` | `docs/source/interpretation-change-record.md` | copy |
| `product/product-change-record.md` | `docs/source/product-change-record.md` | copy |
| `technology/technology-change-record.md` | `docs/source/technology-change-record.md` | copy |
| `technology/technical-answers.md` (once filed) | `docs/source/technical-answers.md` | copy |
| the places register | `app/assets/words/places-register.csv` | words |
| the founder's lists | `app/assets/words/founder-lists-for-technology.md` | lists |

Every copy must be a Markdown file (the `copy` kind accepts `.md` only, and G0 knows no other document kind).
`privacy-ethics-safety.md` stays out.

**2b.** Claude Code replaces `tool/checks/import_rows.py`'s `ROWS = ()` with the owner's rows, one per line, in
the form `    ('<documents path>', '<destination>', '<kind>'),`, keeping the header comment, and commits
`Import: the rows the owner gave (D32 Q5)`. Gate as in Task 1.

**2c [OWNER].** Paste 1 — Terminal (one `tool/import.sh` line per row; the sha256 and ordinal from each filing):

    cd ~/Developer/soul-dreams-app && chmod +x tool/import.sh && git status --short && export SOUL_DREAMS_DOCS=~/Developer/soul-dreams-docs
    tool/import.sh <documents path> <sha256> "<ordinal>"
    git status --short && python3 -I -B tool/checks/guards.py | grep -E 'G1|G2|guards'

Expected: the first `git status` prints nothing. Then, per file: `import: hash ok, copied <destination>`, `import: recorded in docs/source/SOURCES`,
`import: review git status, then commit`. Then `?? app/assets/` and `?? docs/source/` (untracked), and G1 and G2
`NOT ARMED (awaiting import)`, `guards (tracked): all passed`. **Do not stage or commit anything.** Any refusal
stops here: send the code.

**Send back** the whole output (paths, codes and counts only; no file's content is printed).

### Task 3 · The shape of the real files (D32 Q1, Q15)

Claude Code writes this script (not committed) and runs it from the repository root:
`python3 -I -B .scratch/scaffold-3/shape.py`. It prints counts, column names, slot names, handles and heading names,
never a line.

**File `.scratch/scaffold-3/shape.py`**

~~~~python
# scaffold-3-import, Task 3 (D32 Q1, Q15): the shape of the imported
# register and lists, against what the plan assumed. It prints counts,
# handles, column names, slot names and heading names, never a line.
# Run from the repository root: python3 -I -B .scratch/scaffold-3/shape.py
import csv
import io
import re
import sys

CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'
LINE = ('written', 'written, in its parts', 'composed (stand-in written)')
KNOWN = LINE + ('retired', 'to rewrite', 'composed, no stand-in', 'no line: by decision',
                'no line: prohibition', 'to write')
SLOTS = ('{n}', '{pointed image}', '{tradition}', '{read image}')
HANDLE = re.compile(r'^[A-Z][A-Z0-9]*·[0-9]+$')


def say(line):
    sys.stdout.write('shape: ' + line + '\n')


def main():
    data = open(CSV, 'rb').read()
    say('register bom %s, crlf %s' % (data.startswith(b'\xef\xbb\xbf'), b'\r\n' in data))
    text = data.decode('utf-8').lstrip('﻿')
    rows = list(csv.reader(io.StringIO(text, newline=''), strict=True))
    say('header ' + ','.join(rows[0]))
    body = rows[1:]
    say('rows %d, widths %s' % (len(body), sorted(set(len(r) for r in body))))
    h = rows[0]
    col = {name: h.index(name) for name in ('handle', 'status', 'english', 'swedish')}
    counts = {}
    waiting = []
    for r in body:
        s = r[col['status']]
        key = s if s in KNOWN else ('paused:' if s.startswith('paused:') else
                                    'blocked:' if s.startswith('blocked:') else
                                    'merged into ' + s[12:] if s.startswith('merged into ') else
                                    'UNKNOWN')
        counts[key] = counts.get(key, 0) + 1
        if key in ('to rewrite', 'to write', 'composed, no stand-in', 'paused:', 'blocked:'):
            waiting.append(r[col['handle']])
    for k in sorted(counts):
        say('status "%s" %d' % (k, counts[k]))
    say('waiting places (placeholders) ' + ' '.join(waiting))
    handles = [r[col['handle']] for r in body]
    say('handles not matching the pattern %d: %s'
        % (sum(1 for x in handles if not HANDLE.match(x)),
           ' '.join(x for x in handles if not HANDLE.match(x))))
    say('repeated handles %d' % (len(handles) - len(set(handles))))
    lines = [r for r in body if r[col['status']] in LINE]
    for lang in ('english', 'swedish'):
        t = [r[col[lang]] for r in lines]
        say('%s: empty %d, " / " %d, pilcrow %d, newline %d' % (
            lang, sum(1 for x in t if not x.strip()), sum(1 for x in t if ' / ' in x),
            sum(1 for x in t if '¶' in x), sum(1 for x in t if '\n' in x or '\r' in x)))
        found = {}
        other = 0
        for x in t:
            for m in re.findall(r'\{[^{}]*\}', x):
                if m in SLOTS:
                    found[m] = found.get(m, 0) + 1
                else:
                    other += 1
            other += x.count('{') + x.count('}') - 2 * len(re.findall(r'\{[^{}]*\}', x))
        say('%s slots %s, other braces %d' % (lang, sorted(found.items()), other))
    for handle in ('MP·55', 'EM·3'):
        r = [r for r in body if r[col['handle']] == handle]
        if not r:
            say(handle + ' missing')
            continue
        r = r[0]
        en, sv = r[col['english']], r[col['swedish']]
        say('%s status "%s", same in both %s, words en %d sv %d, "//" %s, "$" %s, " / " %s' % (
            handle, r[col['status']], en == sv, len(en.split()), len(sv.split()),
            '//' in en, '$' in en, ' / ' in en))
    md = open(LISTS, 'rb').read()
    say('lists bom %s, crlf %s' % (md.startswith(b'\xef\xbb\xbf'), b'\r\n' in md))
    section = None
    shapes = {}
    for line in md.decode('utf-8').split('\n'):
        line = line.rstrip('\r')
        if line.startswith('#'):
            level = len(line) - len(line.lstrip('#'))
            name = line.lstrip('#').strip()
            shown = name if re.match(r'^TECH·\d+$', name) else '(other heading)'
            say('heading level %d %s' % (level, shown))
            section = name if level == 2 else section
            continue
        if not line.strip():
            continue
        kind = ('dash' if line.startswith('- ') else 'star' if line.startswith('* ') else
                'number' if re.match(r'^\d+\. ', line) else 'indented' if line[0] in ' \t'
                else 'table' if line.startswith('|') else 'other')
        key = (section or '(before any section)', kind)
        shapes[key] = shapes.get(key, 0) + 1
    for (sec, kind), n in sorted(shapes.items()):
        shown = sec if re.match(r'^TECH·\d+$', sec) or sec.startswith('(') else '(other)'
        say('lines in %s: %s %d' % (shown, kind, n))


main()
~~~~

Expected, from the brief (D31): the header above; 164 rows, all 14 wide; `written` 104, `written, in its parts` 1,
`composed (stand-in written)` 10, `retired` 35, `to rewrite` 3, `composed, no stand-in` 2, `no line: by decision`
2, `no line: prohibition` 1, `merged into W27·6` 1, `to write` 1, `paused:` 2, `blocked:` 2, and no `UNKNOWN`; no
handle outside the pattern and none repeated; no empty field, no newline and no stray brace in a line; only the
four slots; MP·55 written, the same in both languages, with no `//`, `$` or `" / "`; EM·3 written, with no `//`,
`$` or `" / "`; the lists' headings `TECH·1` to `TECH·5` at level 2 after one level-1 title, and inside them only
`dash` lines.

**Any difference stops the branch.** Claude Code writes `.scratch/for-build-chat/scaffold-3-shape.md` with the
output and a proposed amendment to Task 4 (for example, a list format other than `- word`), and the owner rules.
The waiting places' handles from this output are the placeholders list for Task 9.

### Task 4 · The words generator (D32 Q6 to Q17)

Red: write `tool/checks/tests/test_wordsgen.py` alone and run
`python3 -I -B tool/checks/tests/run_tests.py test_wordsgen`. Expected: `No module named 'wordsgen'`,
`FAILED (errors=1)`. Then the rest. Expected: `Ran 25 tests`, `OK`. Gate: `Ran 159 tests`, `OK`; `mutations: 42 run, all caught`;
guards all passed.

**Edit `tool/checks/guardlib.py`** (1 of 1). Replace exactly:

~~~~python
LISTS = 'app/assets/words/founder-lists-for-technology.md'
~~~~

with:

~~~~python
LISTS = 'app/assets/words/founder-lists-for-technology.md'
# The words the generator makes (R1; D32). G1 proves each one is exactly
# the generator's output; G0 and G4 read this list too.
WORDS_ASSETS = 'app/assets/words/'
WORDS_LIB = 'app/lib/words/'
LINES = 'app/lib/words/lines.g.dart'
LIST_WORDS = 'app/lib/words/lists.g.dart'
WORDS_XCCONFIG = 'app/ios/Flutter/words.g.xcconfig'
STRINGS_EN = 'app/ios/Runner/en.lproj/InfoPlist.strings'
STRINGS_SV = 'app/ios/Runner/sv.lproj/InfoPlist.strings'
GENERATED = (LINES, LIST_WORDS, WORDS_XCCONFIG, STRINGS_EN, STRINGS_SV)
~~~~

**New file `tool/checks/wordsgen.py`**

~~~~python
# The words generator (R1; D32). From the places register and the
# founder's lists to the app's words: lines.g.dart, lists.g.dart, and
# the iOS home-screen name and microphone text. A pure function of the
# two files' bytes, so G1 can run it again and compare. It stops on
# anything it does not expect, with a reason code and a row number,
# never a file's content.
# Usage: wordsgen.py --write           write the five files (the owner)
#        wordsgen.py --check           exit 1 if any file differs
#        add --root DIR to read the inputs, --out DIR to write or compare
#        elsewhere (the tests and the plan's proof).
# Exit 0 done, 1 refused or different, 2 internal error.
import csv
import io
import os
import re
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
TOP = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)

from guardlib import (CSV, GENERATED, LINES, LIST_WORDS, LISTS, STRINGS_EN,  # noqa: E402
                      STRINGS_SV, WORDS_XCCONFIG, report, sha256)

HEADER = ('handle', 'place', 'source', 'screen', 'also_on', 'moment', 'must', 'never',
          'length', 'status', 'draft', 'english', 'swedish', 'flag')
# The statuses with a line, and whether the line is a stand-in (R1).
LINE = {'written': False, 'written, in its parts': False,
        'composed (stand-in written)': True}
# Known statuses with no line. Waiting places show their handle; the
# others have no constant at all (D32 Q6, Q7).
WAITING = ('to rewrite', 'to write', 'composed, no stand-in')
WAITING_PREFIXES = ('paused:', 'blocked:')
NO_LINE = ('retired', 'no line: by decision', 'no line: prohibition')
MERGED = 'merged into '
# Each slot: its token in the register, its Dart argument and type.
SLOTS = (('{n}', 'n', 'int'), ('{pointed image}', 'pointedImage', 'String'),
         ('{tradition}', 'tradition', 'String'), ('{read image}', 'readImage', 'String'))
HANDLE = re.compile(r'^[A-Z][A-Z0-9]*·[0-9]+$')
APP_NAME = 'MP·55'
MIC = 'EM·3'
TECH = tuple('TECH·%d' % n for n in range(1, 6))
REGISTER = 'register'
LIST_FILE = 'lists'


class WordsError(Exception):
    def __init__(self, source, code, row):
        Exception.__init__(self, code)
        self.source = source
        self.code = code
        self.row = row


class Place:
    def __init__(self, row, handle, en, sv, stand_in, slots):
        self.row = row
        self.handle = handle
        self.en = en
        self.sv = sv
        self.stand_in = stand_in
        self.slots = slots


def decode(data, source):
    if data is None:
        raise WordsError(source, 'missing', 0)
    try:
        text = data.decode('utf-8')
    except UnicodeDecodeError:
        raise WordsError(source, 'not-utf8', 0)
    return text[1:] if text.startswith('﻿') else text


def has_control(text):
    return any(ord(c) < 32 or ord(c) == 127 for c in text)


def classify(status):
    if status in LINE:
        return 'line'
    if status in WAITING or status.startswith(WAITING_PREFIXES):
        return 'waiting'
    if status in NO_LINE:
        return 'none'
    if status.startswith(MERGED):
        return 'merged'
    return None


def label(status):
    # The status as counted in the summary: free text is never shown.
    for prefix in WAITING_PREFIXES:
        if status.startswith(prefix):
            return prefix
    if status.startswith(MERGED):
        return MERGED.strip()
    return status


def read_register(data):
    text = decode(data, REGISTER)
    reader = csv.reader(io.StringIO(text, newline=''), strict=True)
    try:
        rows = list(reader)
    except csv.Error:
        raise WordsError(REGISTER, 'bad-csv', reader.line_num)
    if not rows or tuple(rows[0]) != HEADER:
        raise WordsError(REGISTER, 'bad-header', 1)
    out = []
    seen = set()
    for n, r in enumerate(rows[1:], 2):
        if len(r) != len(HEADER):
            raise WordsError(REGISTER, 'bad-row', n)
        f = dict(zip(HEADER, r))
        if not HANDLE.match(f['handle']):
            raise WordsError(REGISTER, 'bad-handle', n)
        if f['handle'] in seen:
            raise WordsError(REGISTER, 'repeated-handle', n)
        if has_control(f['status']):
            raise WordsError(REGISTER, 'control-character', n)
        seen.add(f['handle'])
        out.append((n, f['handle'], f['status'], f['english'], f['swedish']))
    return out


def parse_text(text, row):
    # " / " separates parts; a pilcrow separates paragraphs (D32 Q11, Q12).
    if has_control(text):
        raise WordsError(REGISTER, 'control-character', row)
    parts = []
    for part in text.strip().split(' / '):
        paragraphs = [p.strip() for p in part.split('¶')]
        if not all(paragraphs):
            raise WordsError(REGISTER, 'empty-part', row)
        parts.append('\n\n'.join(paragraphs))
    return parts


def slots_of(parts, row):
    found = set()
    for part in parts:
        rest = part
        for token, _, _ in SLOTS:
            if token in rest:
                found.add(token)
                rest = rest.replace(token, '')
        if '{' in rest or '}' in rest:
            raise WordsError(REGISTER, 'unknown-slot', row)
    return found


def places_of(rows):
    handles = set(r[1] for r in rows)
    out = []
    for row, handle, status, en, sv in rows:
        kind = classify(status)
        if kind is None:
            raise WordsError(REGISTER, 'unknown-status', row)
        if kind == 'merged':
            if status[len(MERGED):] not in handles:
                raise WordsError(REGISTER, 'merged-unknown', row)
            continue
        if kind == 'none':
            continue
        if kind == 'waiting':
            out.append(Place(row, handle, None, None, False, ()))
            continue
        if not en.strip() or not sv.strip():
            raise WordsError(REGISTER, 'missing-language', row)
        en_parts, sv_parts = parse_text(en, row), parse_text(sv, row)
        if len(en_parts) != len(sv_parts):
            raise WordsError(REGISTER, 'parts-differ', row)
        en_slots, sv_slots = slots_of(en_parts, row), slots_of(sv_parts, row)
        if en_slots != sv_slots:
            raise WordsError(REGISTER, 'slots-differ', row)
        slots = tuple(s for s in SLOTS if s[0] in en_slots)
        out.append(Place(row, handle, en_parts, sv_parts, LINE[status], slots))
    return out


def read_lists(data):
    # Provisional until Task 3 reads the real file's shape (D32 Q15):
    # a title, then "## TECH·1" to "## TECH·5" in order, each holding
    # only "- word" lines and blank lines.
    text = decode(data, LIST_FILE)
    sections = []
    current = None
    for n, line in enumerate(text.split('\n'), 1):
        line = line.rstrip('\r')
        if line.startswith('## '):
            current = (line[3:].strip(), [])
            sections.append(current)
        elif line.startswith('#'):
            if current is not None or not line.startswith('# '):
                raise WordsError(LIST_FILE, 'unexpected-heading', n)
        elif current is None or not line.strip():
            continue
        elif line.startswith('- '):
            word = line[2:].strip()
            if not word or has_control(word):
                raise WordsError(LIST_FILE, 'bad-word', n)
            current[1].append(word)
        else:
            raise WordsError(LIST_FILE, 'unexpected-line', n)
    if tuple(s[0] for s in sections) != TECH:
        raise WordsError(LIST_FILE, 'sections', 0)
    for name, words in sections:
        if not words:
            raise WordsError(LIST_FILE, 'empty-section', 0)
    return sections


def dart_string(s):
    out = []
    for c in s:
        if c == '\\':
            out.append('\\\\')
        elif c == "'":
            out.append("\\'")
        elif c == '$':
            out.append('\\$')
        elif c == '\n':
            out.append('\\n')
        else:
            out.append(c)
    return "'" + ''.join(out) + "'"


def dart_list(parts):
    return 'null' if parts is None else '[' + ', '.join(dart_string(p) for p in parts) + ']'


def ident(handle):
    return handle.replace('·', '_')


LINES_HEAD = ''.join(line + '\n' for line in (
    '// GENERATED by tool/checks/wordsgen.py from the places register',
    '// (sha256 @SHA@). Do not edit: import the register again.',
    '// ignore_for_file: constant_identifier_names',
    '// ignore_for_file: non_constant_identifier_names, unused_element',
    '',
    '/// The two languages every line is written in.',
    'enum Lang { en, sv }',
    '',
    '/// One place in the register: its line in both languages,',
    '/// or none yet.',
    'final class Line {',
    '  const Line(this.handle, this._en, this._sv, {this.standIn = false});',
    '',
    "  /// The place's handle in the register.",
    '  final String handle;',
    '',
    '  /// True when this is the stand-in for a line',
    '  /// composed at run time.',
    '  final bool standIn;',
    '',
    '  final List<String>? _en;',
    '  final List<String>? _sv;',
    '',
    '  /// True when the register has a line for this place.',
    '  bool get written => _en != null;',
    '',
    '  /// The parts, split at " / " in the register.',
    '  /// A place with no line yet shows its handle',
    '  /// as a visible placeholder (R1).',
    '  List<String> parts(Lang lang) =>',
    "      (lang == Lang.en ? _en : _sv) ?? ['[$handle]'];",
    '',
    '  /// A line of one part.',
    '  String text(Lang lang) {',
    '    final all = parts(lang);',
    "    assert(all.length == 1, 'text() needs a line of one part');",
    '    return all.single;',
    '  }',
    '',
    '  Line _fill(Map<String, String> slots) =>',
    '      Line(handle, _fillAll(_en, slots), _fillAll(_sv, slots), standIn: standIn);',
    '',
    '  static List<String>? _fillAll(List<String>? parts, Map<String, String> slots) =>',
    '      parts?.map((p) => p.replaceAllMapped(_slot, (m) => slots[m[0]] ?? m[0]!)).toList();',
    '',
    "  static final _slot = RegExp(r'\\{[a-z ]+\\}');",
    '}',
    '',
    '/// Every place with a line, or waiting for one,',
    '/// by handle (D32 Q14).',
    'abstract final class Lines {',
))


def lines_dart(places, digest):
    out = [LINES_HEAD.replace('@SHA@', digest)]
    names = []
    for p in places:
        name = ident(p.handle)
        const = name if not p.slots else '_' + name
        names.append(const)
        stand_in = ', standIn: true' if p.stand_in else ''
        out.append('  static const %s = Line(%s, %s, %s%s);\n'
                   % (const, dart_string(p.handle), dart_list(p.en), dart_list(p.sv), stand_in))
        if p.slots:
            args = ', '.join('required %s %s' % (t, a) for _, a, t in p.slots)
            fills = ', '.join('%s: %s' % (dart_string(k), "'$%s'" % a if t == 'int' else a)
                              for k, a, t in p.slots)
            out.append('  static Line %s({%s}) => %s._fill({%s});\n' % (name, args, const, fills))
    out.append('\n  /// Every place above, in the register\'s order.\n')
    out.append('  static const all = <Line>[%s];\n}\n' % ', '.join(names))
    return ''.join(out)


def lists_dart(sections, digest):
    out = ['// GENERATED by tool/checks/wordsgen.py from the founder\'s lists\n',
           '// (sha256 %s). Do not edit: import the lists again.\n' % digest,
           '// ignore_for_file: constant_identifier_names\n\n',
           '/// The founder\'s list words, by section (R1).\n',
           'abstract final class ListWords {\n']
    for name, words in sections:
        out.append('  static const %s = <String>[%s];\n'
                   % (ident(name), ', '.join(dart_string(w) for w in words)))
    out.append('}\n')
    return ''.join(out)


def one_line(places, handle):
    # MP·55 and EM·3 go into Xcode's files: one part, one paragraph, no
    # slot, and nothing an xcconfig value cannot hold (D32 Q16, Q17).
    for p in places:
        if p.handle == handle:
            if p.en is None:
                break
            if len(p.en) != 1 or p.slots:
                raise WordsError(REGISTER, 'ios-line-parts', p.row)
            if '\n' in p.en[0] or '\n' in p.sv[0]:
                raise WordsError(REGISTER, 'ios-line-paragraphs', p.row)
            if '//' in p.en[0] or '$' in p.en[0]:
                raise WordsError(REGISTER, 'xcconfig-unsafe', p.row)
            return p.en[0], p.sv[0], p.row
    raise WordsError(REGISTER, 'ios-line-missing', 0)


def strings_file(text, digest):
    value = text.replace('\\', '\\\\').replace('"', '\\"')
    return ('/* GENERATED by tool/checks/wordsgen.py from the places register\n'
            '   (sha256 %s). Do not edit: import the register again. */\n'
            '"NSMicrophoneUsageDescription" = "%s";\n' % (digest, value))


def generate(csv_bytes, lists_bytes):
    # {repository path: bytes} for every path in guardlib.GENERATED.
    places = places_of(read_register(csv_bytes))
    sections = read_lists(lists_bytes)
    digest = sha256(csv_bytes)
    name_en, name_sv, row = one_line(places, APP_NAME)
    if name_en != name_sv:
        raise WordsError(REGISTER, 'name-languages-differ', row)
    mic_en, mic_sv, _ = one_line(places, MIC)
    xcconfig = ('// GENERATED by tool/checks/wordsgen.py from the places register\n'
                '// (sha256 %s). Do not edit: import the register again.\n'
                '// The home-screen name, MP·55, and the microphone text, EM·3\n'
                '// (the base value; InfoPlist.strings holds each language).\n'
                'WORDS_APP_NAME = %s\n'
                'WORDS_MIC_USAGE = %s\n' % (digest, name_en, mic_en))
    out = {
        LINES: lines_dart(places, digest),
        LIST_WORDS: lists_dart(sections, sha256(lists_bytes)),
        WORDS_XCCONFIG: xcconfig,
        STRINGS_EN: strings_file(mic_en, digest),
        STRINGS_SV: strings_file(mic_sv, digest),
    }
    assert tuple(sorted(out)) == tuple(sorted(GENERATED))
    return {path: text.encode('utf-8') for path, text in out.items()}


def summary(csv_bytes, lists_bytes):
    counts = {}
    for _, _, status, _, _ in read_register(csv_bytes):
        counts[label(status)] = counts.get(label(status), 0) + 1
    lines = ['wordsgen: rows %d' % sum(counts.values())]
    for name in sorted(counts):
        lines.append('wordsgen: status "%s" %d' % (name, counts[name]))
    words = sum(len(w) for _, w in read_lists(lists_bytes))
    lines.append('wordsgen: list words %d' % words)
    return lines


def read(root, path):
    full = os.path.join(root, path)
    if not os.path.isfile(full) or os.path.islink(full):
        return None
    with open(full, 'rb') as f:
        return f.read()


def write_atomic(root, path, data):
    full = os.path.join(root, path)
    folder = os.path.dirname(full)
    os.makedirs(folder, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=folder, prefix='.wordsgen-')
    try:
        with os.fdopen(fd, 'wb') as f:
            f.write(data)
        os.replace(tmp, full)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def write_all(root, out):
    # Generates from root's inputs and writes into out. Raises WordsError.
    csv_bytes, lists_bytes = read(root, CSV), read(root, LISTS)
    outputs = generate(csv_bytes, lists_bytes)
    for path in GENERATED:
        if read(out, path) != outputs[path]:
            write_atomic(out, path, outputs[path])
            report('wordsgen: wrote ' + path)
    for line in summary(csv_bytes, lists_bytes):
        report(line)


def main(argv):
    mode, root, out = None, TOP, None
    args = list(argv)
    while args:
        a = args.pop(0)
        if a in ('--write', '--check') and mode is None:
            mode = a
        elif a in ('--root', '--out') and args:
            if a == '--root':
                root = args.pop(0)
            else:
                out = args.pop(0)
        else:
            mode = None
            break
    if mode is None:
        report('wordsgen: usage: --write | --check, with --root DIR, --out DIR')
        return 1
    out = out or root
    try:
        if mode == '--write':
            write_all(root, out)
            return 0
        outputs = generate(read(root, CSV), read(root, LISTS))
    except WordsError as e:
        report('wordsgen: refused %s %s row %d' % (e.source, e.code, e.row))
        return 1
    differ = [p for p in GENERATED if read(out, p) != outputs[p]]
    for path in differ:
        report('wordsgen: differs ' + path)
    report('wordsgen: %s' % ('different' if differ else 'up to date'))
    return 1 if differ else 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception as e:  # never print a message: it could quote a file
        report('wordsgen: internal error ' + type(e).__name__)
        sys.exit(2)
~~~~

**New file `tool/checks/tests/test_wordsgen.py`**

~~~~python
# The words generator on invented registers and lists, built here from
# placeholder words. No register line appears in this file (R1, R2).
import csv
import io
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

import helpers  # noqa: F401  (puts tool/checks on the path)
import wordsgen
from guardlib import CSV, GENERATED, LINES, LIST_WORDS, LISTS, STRINGS_EN, STRINGS_SV
from guardlib import WORDS_XCCONFIG

DOT = '·'
PILCROW = '¶'


def row(handle, status, en='', sv=''):
    f = dict.fromkeys(wordsgen.HEADER, '')
    f.update(handle=handle, status=status, english=en, swedish=sv, flag='a note')
    return [f[h] for h in wordsgen.HEADER]


def table(rows):
    out = io.StringIO(newline='')
    w = csv.writer(out, lineterminator='\n')
    w.writerow(wordsgen.HEADER)
    for r in rows:
        w.writerow(r)
    return out.getvalue().encode('utf-8')


def ios_register(name_en, name_sv, mic_en, mic_sv):
    return table([row('MP' + DOT + '55', 'written', name_en, name_sv),
                  row('EM' + DOT + '3', 'written', mic_en, mic_sv)])


def register(*rows):
    return table([row('MP' + DOT + '55', 'written', 'Name', 'Name'),
                  row('EM' + DOT + '3', 'written', 'mic word', 'mik ord')] + list(rows))


def lists(body=None):
    if body is None:
        body = ''.join('## TECH%s%d\n\n- word%d\n- other\n\n' % (DOT, n, n) for n in range(1, 6))
    return ('# Lists\n\nintro text\n\n' + body).encode('utf-8')


def gen(*rows):
    return wordsgen.generate(register(*rows), lists())


def lines(*rows):
    return gen(*rows)[LINES].decode('utf-8')


class Generator(unittest.TestCase):
    def refused(self, code, csv_bytes=None, lists_bytes=None):
        with self.assertRaises(wordsgen.WordsError) as cm:
            wordsgen.generate(csv_bytes if csv_bytes is not None else register(),
                              lists_bytes if lists_bytes is not None else lists())
        self.assertEqual(cm.exception.code, code)
        return cm.exception

    def test_every_path_generated(self):
        self.assertEqual(sorted(gen()), sorted(GENERATED))

    def test_same_input_same_bytes(self):
        a = gen(row('A' + DOT + '1', 'written', 'x / y', 'x / y'))
        b = gen(row('A' + DOT + '1', 'written', 'x / y', 'x / y'))
        self.assertEqual(a, b)

    def test_line_statuses_make_lines(self):
        out = lines(row('A' + DOT + '1', 'written', 'en', 'sv'),
                    row('A' + DOT + '2', 'written, in its parts', 'a / b', 'c / d'),
                    row('A' + DOT + '3', 'composed (stand-in written)', 'e', 'f'))
        self.assertIn("static const A_1 = Line('A·1', ['en'], ['sv']);", out)
        self.assertIn("static const A_2 = Line('A·2', ['a', 'b'], ['c', 'd']);", out)
        self.assertIn("static const A_3 = Line('A·3', ['e'], ['f'], standIn: true);", out)

    def test_waiting_statuses_make_placeholders(self):
        for n, status in enumerate(('to rewrite', 'to write', 'composed, no stand-in',
                                    'paused: some reason', 'blocked: other reason'), 1):
            out = lines(row('W' + DOT + str(n), status, 'draft', 'draft'))
            self.assertIn("static const W_%d = Line('W·%d', null, null);" % (n, n), out)
            self.assertNotIn('draft', out)
            self.assertNotIn('reason', out)

    def test_statuses_without_constant(self):
        for status in ('retired', 'no line: by decision', 'no line: prohibition',
                       'merged into EM' + DOT + '3'):
            out = lines(row('N' + DOT + '1', status, 'en', 'sv'))
            self.assertNotIn('N_1', out)

    def test_unknown_status_stops(self):
        e = self.refused('unknown-status', register(row('A' + DOT + '1', 'Written', 'x', 'y')))
        self.assertEqual(e.row, 4)
        self.refused('unknown-status', register(row('A' + DOT + '1', 'pause: x', 'x', 'y')))
        self.refused('unknown-status', register(row('A' + DOT + '1', '', 'x', 'y')))

    def test_merged_into_unknown_handle_stops(self):
        self.refused('merged-unknown', register(row('A' + DOT + '1', 'merged into Z' + DOT + '9')))

    def test_missing_language_stops(self):
        self.refused('missing-language', register(row('A' + DOT + '1', 'written', 'x', '')))
        self.refused('missing-language', register(row('A' + DOT + '1', 'written', ' ', 'y')))

    def test_parts_and_paragraphs(self):
        out = lines(row('A' + DOT + '1', 'written', 'a ' + PILCROW + ' b / c', 'd' + PILCROW + 'e / f'))
        self.assertIn("['a\\n\\nb', 'c'], ['d\\n\\ne', 'f']", out)
        self.refused('parts-differ', register(row('A' + DOT + '1', 'written', 'a / b', 'c')))
        self.refused('empty-part', register(row('A' + DOT + '1', 'written', 'a /  / b', 'c')))
        self.refused('empty-part', register(row('A' + DOT + '1', 'written', PILCROW + ' a', 'c')))

    def test_slash_without_spaces_is_text(self):
        out = lines(row('A' + DOT + '1', 'written', 'a/b', 'c/d'))
        self.assertIn("['a/b'], ['c/d']", out)

    def test_slots(self):
        out = lines(row('S' + DOT + '1', 'written', '{n} x {tradition}', '{tradition} y {n}'),
                    row('S' + DOT + '2', 'written', '{pointed image} / {read image}',
                        '{read image} / {pointed image}'))
        self.assertIn("static const _S_1 = Line(", out)
        self.assertIn("static Line S_1({required int n, required String tradition}) => "
                      "_S_1._fill({'{n}': '$n', '{tradition}': tradition});", out)
        self.assertIn("static Line S_2({required String pointedImage, "
                      "required String readImage})", out)
        self.assertIn('static const all = <Line>[MP_55, EM_3, _S_1, _S_2];', out)

    def test_slot_errors_stop(self):
        self.refused('unknown-slot', register(row('A' + DOT + '1', 'written', '{name}', '{name}')))
        self.refused('unknown-slot', register(row('A' + DOT + '1', 'written', 'a } b', 'c')))
        self.refused('slots-differ', register(row('A' + DOT + '1', 'written', '{n}', 'x')))

    def test_dart_escaping(self):
        out = lines(row('A' + DOT + '1', 'written', "it's $5 \\ ok", 'x'))
        self.assertIn("['it\\'s \\$5 \\\\ ok']", out)

    def test_register_shape_stops(self):
        self.refused('bad-header', b'handle,status\n')
        bad = register().replace(b'Name,Name,a note', b'Name,Name')
        self.refused('bad-row', bad)
        self.refused('bad-handle', register(row('a' + DOT + '1', 'written', 'x', 'y')))
        self.refused('bad-handle', register(row('A-1', 'written', 'x', 'y')))
        self.refused('repeated-handle', register(row('EM' + DOT + '3', 'retired')))
        self.refused('control-character', register(row('A' + DOT + '1', 'written', 'a\nb', 'c')))
        self.refused('not-utf8', b'\xff\xfe')

    def test_bom_accepted(self):
        self.assertEqual(wordsgen.generate(b'\xef\xbb\xbf' + register(), lists())[LINES],
                         gen()[LINES].replace(
                             wordsgen.sha256(register()).encode(),
                             wordsgen.sha256(b'\xef\xbb\xbf' + register()).encode()))

    def test_flag_is_ignored(self):
        out = lines(row('A' + DOT + '1', 'written', 'x', 'y'))
        self.assertNotIn('a note', out)

    def test_ios_files(self):
        out = gen()
        xc = out[WORDS_XCCONFIG].decode('utf-8')
        self.assertIn('\nWORDS_APP_NAME = Name\nWORDS_MIC_USAGE = mic word\n', xc)
        self.assertTrue(out[STRINGS_EN].decode('utf-8').endswith(
            '"NSMicrophoneUsageDescription" = "mic word";\n'))
        self.assertTrue(out[STRINGS_SV].decode('utf-8').endswith(
            '"NSMicrophoneUsageDescription" = "mik ord";\n'))

    def test_strings_escaping(self):
        out = wordsgen.generate(ios_register('Name', 'Name', 'a "b" \\ c', 'd'), lists())
        self.assertTrue(out[STRINGS_EN].decode('utf-8').endswith('= "a \\"b\\" \\\\ c";\n'))

    def ios(self, name_en, name_sv, mic):
        return ios_register(name_en, name_sv, mic, mic)

    def test_ios_lines_checked(self):
        self.refused('name-languages-differ', self.ios('Name', 'Namn', 'mic'))
        self.refused('ios-line-parts', self.ios('Name', 'Name', 'a / b'))
        self.refused('ios-line-parts', self.ios('Name', 'Name', '{n} x'))
        self.refused('ios-line-paragraphs', self.ios('Name', 'Name', 'a ' + PILCROW + ' b'))
        self.refused('xcconfig-unsafe', self.ios('Name', 'Name', 'a // b'))
        self.refused('xcconfig-unsafe', self.ios('Na$(X)', 'Na$(X)', 'mic'))
        missing = ios_register('Name', 'Name', 'mic', 'mic').replace(b'written,,Name,Name',
                                                                     b'to write,,,')
        self.refused('ios-line-missing', missing)

    def test_lists(self):
        out = gen()[LIST_WORDS].decode('utf-8')
        self.assertIn("  static const TECH_1 = <String>['word1', 'other'];\n", out)
        self.assertIn("  static const TECH_5 = <String>['word5', 'other'];\n", out)

    def test_lists_shape_stops(self):
        four = ''.join('## TECH%s%d\n- w\n' % (DOT, n) for n in range(1, 5))
        self.refused('sections', lists_bytes=lists(four))
        swapped = ''.join('## TECH%s%d\n- w\n' % (DOT, n) for n in (2, 1, 3, 4, 5))
        self.refused('sections', lists_bytes=lists(swapped))
        extra = ''.join('## TECH%s%d\n- w\n' % (DOT, n) for n in range(1, 6)) + '## Notes\n- w\n'
        self.refused('sections', lists_bytes=lists(extra))
        prose = '## TECH%s1\nsome prose\n' % DOT
        self.refused('unexpected-line', lists_bytes=lists(prose))
        empty = ''.join('## TECH%s%d\n%s' % (DOT, n, '' if n == 3 else '- w\n') for n in range(1, 6))
        self.refused('empty-section', lists_bytes=lists(empty))
        self.refused('unexpected-heading', lists_bytes=lists('## TECH%s1\n### sub\n' % DOT))
        self.refused('bad-word', lists_bytes=lists('## TECH%s1\n- \n' % DOT))


class Command(unittest.TestCase):
    def setUp(self):
        self.root = tempfile.mkdtemp(prefix='wordsgen-')
        for path, data in ((CSV, register()), (LISTS, lists())):
            os.makedirs(os.path.join(self.root, os.path.dirname(path)), exist_ok=True)
            with open(os.path.join(self.root, path), 'wb') as f:
                f.write(data)

    def tearDown(self):
        shutil.rmtree(self.root)

    def run_gen(self, *args):
        script = os.path.join(helpers.CHECKS, 'wordsgen.py')
        r = subprocess.run([sys.executable, '-I', '-B', script, '--root', self.root] + list(args),
                           capture_output=True)
        return r.returncode, r.stdout.decode()

    def test_write_then_check(self):
        self.assertEqual(self.run_gen('--check')[0], 1)
        rc, out = self.run_gen('--write')
        self.assertEqual(rc, 0, out)
        for path in GENERATED:
            self.assertIn('wordsgen: wrote ' + path, out)
        self.assertIn('wordsgen: status "written" 2', out)
        self.assertEqual(self.run_gen('--check'), (0, 'wordsgen: up to date\n'))
        with open(os.path.join(self.root, STRINGS_SV), 'ab') as f:
            f.write(b'\n')
        rc, out = self.run_gen('--check')
        self.assertEqual(rc, 1)
        self.assertIn('wordsgen: differs ' + STRINGS_SV, out)

    def test_summary_hides_free_text(self):
        with open(os.path.join(self.root, CSV), 'wb') as f:
            f.write(register(row('A' + DOT + '1', 'paused: hidden reason')))
        rc, out = self.run_gen('--write')
        self.assertEqual(rc, 0, out)
        self.assertIn('wordsgen: status "paused:" 1', out)
        self.assertNotIn('hidden', out)

    def test_refusal_names_code_and_row_only(self):
        with open(os.path.join(self.root, CSV), 'wb') as f:
            f.write(register(row('A' + DOT + '1', 'secret status')))
        rc, out = self.run_gen('--write')
        self.assertEqual((rc, out), (1, 'wordsgen: refused register unknown-status row 4\n'))
        self.assertFalse(os.path.exists(os.path.join(self.root, LINES)))

    def test_usage(self):
        self.assertEqual(self.run_gen()[0], 1)
        self.assertEqual(self.run_gen('--write', '--check')[0], 1)


if __name__ == '__main__':
    unittest.main()
~~~~

**Edit `tool/checks/tests/mutations.py`** (1 of 1). Replace exactly:

~~~~python
     ['test_import.Import.test_paths_refused']),
]
~~~~

with:

~~~~python
     ['test_import.Import.test_paths_refused']),
    # Branch 3, Task 4 (D32): the words generator.
    ('wordsgen.py', "    return None\n\n\ndef label", "    return 'line'\n\n\ndef label",
     ['test_wordsgen.Generator.test_unknown_status_stops']),
    ('wordsgen.py', "text.strip().split(' / ')", "[text.strip()]",
     ['test_wordsgen.Generator.test_parts_and_paragraphs']),
    ('wordsgen.py', "out.append('\\\\$')", "out.append('$')",
     ['test_wordsgen.Generator.test_dart_escaping']),
    ('wordsgen.py', "NO_LINE = ('retired', ", "NO_LINE = (",
     ['test_wordsgen.Generator.test_statuses_without_constant']),
    ('wordsgen.py', "    if name_en != name_sv:", "    if False:",
     ['test_wordsgen.Generator.test_ios_lines_checked']),
]
~~~~

**Proof on invented data, and on the real files (not committed).** From the repository root:

1. An invented register, generated into a copy of `app/` and analyzed there:

       P=$TMPDIR/s3 && rm -rf $P && mkdir -p $P/in/app/assets/words && cp -R app $P/app
       python3 -I -B - "$P/in" <<'EOF'
       import sys; sys.path[:0] = ['tool/checks/tests', 'tool/checks']
       import test_wordsgen as t; D = t.DOT
       r = t.register(t.row('A' + D + '1', 'written', 'one / two', 'ett / tva'),
                      t.row('A' + D + '2', 'composed (stand-in written)', 'x', 'y'),
                      t.row('A' + D + '3', 'to write'),
                      t.row('A' + D + '4', 'written', '{n} {tradition}', '{tradition} {n}'))
       open(sys.argv[1] + '/app/assets/words/places-register.csv', 'wb').write(r)
       open(sys.argv[1] + '/app/assets/words/founder-lists-for-technology.md', 'wb').write(t.lists())
       EOF
       python3 -I -B tool/checks/wordsgen.py --root $P/in --out $P --write
       (cd $P/app && fvm flutter analyze --no-pub)

   Expected: five `wordsgen: wrote` lines, `rows 6` and the counts, and `No issues found!`.
2. The **real** register and lists, read where Task 2 put them, generated into another copy (nothing is written in
   the repository):

       O=$TMPDIR/s3real && rm -rf $O && mkdir -p $O && cp -R app $O/app
       python3 -I -B tool/checks/wordsgen.py --root . --out $O --write | grep -v '^wordsgen: wrote'
       (cd $O/app && fvm flutter analyze --no-pub)

   Expected: the counts Task 3 printed, `list words <n>`, and `No issues found!`. A refusal or an analyzer issue
   stops the branch with its code. Delete both folders afterwards.

Commit: `git add tool/` only. Message `Words: the generator, from the register and lists to Dart and iOS (D32
Q6-Q17)`.

### Task 5 · G1 armed, and G0, G2 and G4 (D32 Q18)

Red: apply the six test files' edits first (`test_g1_g2.py`, `test_g0.py`, `test_g4.py`, `test_hook.py`,
`test_check_all.py`, `test_import.py`), then run
`python3 -I -B tool/checks/tests/run_tests.py test_g1_g2 test_g0 test_g4 test_import test_hook`. Expected:
`Ran 65 tests`, `FAILED (failures=11)`, exactly these: G1's `test_armed_with_generated_words_passes`,
`test_armed_without_generated_files_refuses`, `test_generated_differs_refuses`, `test_generator_refusal_refuses`,
`test_hand_edited_xcconfig_refuses`, `test_unknown_words_file_refuses`; G2's `test_refused_documents_refused`; G0's
`test_generated_strings_pass`; G4's `test_generated_words_pass`; the import's `test_generator_refusal_is_reported`
and `test_words_run_the_generator`. Then the code and the mutation rows; the same run: `Ran 65 tests`, `OK`. Gate:
`Ran 172 tests`, `OK`; `mutations: 48 run, all caught`; guards all passed (G1 and G2 still NOT ARMED: the marker is
still in the repository, and the copies are untracked).

**New file `tool/checks/g1_words.py`**

~~~~python
# G1 words: the register's and the lists' hashes match SOURCES, and the
# generated words (guardlib.GENERATED) are exactly what wordsgen makes
# from them. Nothing else may sit in the two words folders. NOT ARMED
# while the awaiting-import marker exists; refuses the marker beside
# SOURCES.
import wordsgen
from guardlib import (CSV, GENERATED, LISTS, MARKER, SOURCES, WORDS_ASSETS, WORDS_LIB,
                      Finding, parse_sources, sha256)

CODE = 'G1'
NAME = 'words'
KNOWN = (CSV, LISTS) + GENERATED


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
    unknown = [Finding(p, 0, 'words-unknown-file') for p in src.paths
               if p.startswith((WORDS_ASSETS, WORDS_LIB)) and p not in KNOWN]
    if findings:
        return findings + unknown, []
    try:
        outputs = wordsgen.generate(src.read(CSV), src.read(LISTS))
    except wordsgen.WordsError as e:
        where = CSV if e.source == wordsgen.REGISTER else LISTS
        return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown, []
    for path in GENERATED:
        if not src.has(path):
            findings.append(Finding(path, 0, 'generated-missing'))
        elif src.read(path) != outputs[path]:
            findings.append(Finding(path, 0, 'generated-differs'))
    return findings + unknown, []
~~~~

**Edit `tool/checks/g2_copies.py`** (1 of 2). Replace exactly:

~~~~python
# G2 copies: every file in docs/source/ is listed in SOURCES with its
# sha256 and matches it. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside any file in docs/source/.
~~~~

with:

~~~~python
# G2 copies: every file in docs/source/ is listed in SOURCES with its
# sha256 and matches it. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside any file in docs/source/. Armed or
# not, no tracked path anywhere may be privacy-ethics-safety.md or sit in
# a folder named restricted (D32 Q18): those never leave the documents.
~~~~

**Edit `tool/checks/g2_copies.py`** (2 of 2). Replace exactly:

~~~~python
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
~~~~

with:

~~~~python
DIR = 'docs/source/'
REFUSED_NAMES = ('privacy-ethics-safety.md',)


def refused_document(path):
    parts = path.split('/')
    return parts[-1] in REFUSED_NAMES or 'restricted' in parts[:-1]


def check(src):
    refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
    in_dir = [p for p in src.paths if p.startswith(DIR)]
    if src.has(MARKER):
        if in_dir:
            return refused + [Finding(p, 0, 'marker-with-sources') for p in in_dir], []
        if refused:
            return refused, []
        return [], ['NOT ARMED (awaiting import)']
    if not src.has(SOURCES):
        return refused + [Finding(SOURCES, 0, 'no-sources')], []
    entries, findings = parse_sources(src)
    findings = refused + findings
~~~~

**Edit `tool/checks/g0_kinds.py`** (1 of 2). Replace exactly:

~~~~python
from guardlib import LOCKFILES, MARKER, SOURCES, Finding
~~~~

with:

~~~~python
from guardlib import LOCKFILES, MARKER, SOURCES, STRINGS_EN, STRINGS_SV, Finding
~~~~

**Edit `tool/checks/g0_kinds.py`** (2 of 2). Replace exactly:

~~~~python
UNSCANNED_PATHS = (SOURCES, MARKER)
~~~~

with:

~~~~python
# The two generated InfoPlist.strings, by exact path: G1 proves them (D32).
UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV)
~~~~

**Edit `tool/checks/g4_invented.py`** (1 of 2). Replace exactly:

~~~~python
# G4 invented only: no string literal of twelve words or more outside
# fixtures/invented-nights.json and app/lib/words/.
from guardlib import Finding, config_strings, words
~~~~

with:

~~~~python
# G4 invented only: no string literal of twelve words or more outside
# fixtures/invented-nights.json, app/lib/words/ and the generated words,
# which G1 proves are the generator's output (D32 Q18).
from guardlib import GENERATED, Finding, config_strings, words
~~~~

**Edit `tool/checks/g4_invented.py`** (2 of 2). Replace exactly:

~~~~python
    return path == 'fixtures/invented-nights.json' or path.startswith('app/lib/words/')
~~~~

with:

~~~~python
    return (path == 'fixtures/invented-nights.json' or path.startswith('app/lib/words/')
            or path in GENERATED)
~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (1 of 4). Replace exactly:

~~~~python
import g2_copies
~~~~

with:

~~~~python
import g2_copies
import test_wordsgen as invented
import wordsgen
from guardlib import GENERATED, LINES, WORDS_XCCONFIG
~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (2 of 4). Replace exactly:

~~~~python
def line(path, body, ordinal='C0-T item 1'):
    return hashlib.sha256(body.encode('utf-8')).hexdigest() + '  ' + path + '  ' + ordinal + '\n'
~~~~

with:

~~~~python
def line(path, body, ordinal='C0-T item 1'):
    if isinstance(body, str):
        body = body.encode('utf-8')
    return hashlib.sha256(body).hexdigest() + '  ' + path + '  ' + ordinal + '\n'


def armed(csv_bytes=None, lists_bytes=None, generated=True):
    # An armed tree from an invented register and lists, with SOURCES
    # matching them and, when it can be made, the generated words.
    c = csv_bytes if csv_bytes is not None else invented.register()
    l = lists_bytes if lists_bytes is not None else invented.lists()
    files = {CSV: c, LISTS: l, SOURCES: line(CSV, c) + line(LISTS, l)}
    if generated:
        files.update(wordsgen.generate(c, l))
    return files
~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (3 of 4). Replace exactly:

~~~~python
    def test_armed_refuses_until_generator_is_built(self):
        files = {CSV: 'a\n', LISTS: 'l\n', SOURCES: line(CSV, 'a\n') + line(LISTS, 'l\n')}
        found = self.refused(files)
        self.assertEqual([f[2] for f in found], ['generator-not-built'])
~~~~

with:

~~~~python
    # Branch 3 (D32): the generator comparison replaces generator-not-built.
    def test_armed_with_generated_words_passes(self):
        self.passed(armed())

    def test_armed_without_generated_files_refuses(self):
        found = self.refused(armed(generated=False))
        self.assertEqual(found, sorted((p, 0, 'generated-missing') for p in GENERATED))

    def test_generated_differs_refuses(self):
        files = armed()
        files[LINES] = files[LINES] + b'// x\n'
        self.assertEqual(self.refused(files), [(LINES, 0, 'generated-differs')])

    def test_hand_edited_xcconfig_refuses(self):
        files = armed()
        files[WORDS_XCCONFIG] = files[WORDS_XCCONFIG].replace(b'= Name', b'= Other')
        self.assertEqual(self.refused(files), [(WORDS_XCCONFIG, 0, 'generated-differs')])

    def test_unknown_words_file_refuses(self):
        files = armed()
        files['app/lib/words/extra.dart'] = 'const s = 1;\n'
        files['app/assets/words/old.csv'] = 'a\n'
        self.assertEqual(self.refused(files),
                         [('app/assets/words/old.csv', 0, 'words-unknown-file'),
                          ('app/lib/words/extra.dart', 0, 'words-unknown-file')])

    def test_generator_refusal_refuses(self):
        bad = invented.register(invented.row('A' + invented.DOT + '1', 'unheard of'))
        self.assertEqual(self.refused(armed(bad, generated=False)),
                         [(CSV, 4, 'generator-refused:unknown-status')])
        four = invented.lists('## TECH' + invented.DOT + '1\n- w\n')
        self.assertEqual(self.refused(armed(lists_bytes=four, generated=False)),
                         [(LISTS, 0, 'generator-refused:sections')])
~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (4 of 4). Replace exactly:

~~~~python
    def test_unknown_path_outside_docs_source_refuses(self):
~~~~

with:

~~~~python
    def test_refused_documents_refused(self):
        # D32 Q18: armed or not, these never leave the documents.
        pes = 'docs/source/privacy-ethics-safety.md'
        found = self.refused({pes: 'h\n', SOURCES: line(pes, 'h\n')}, 'refused-document')
        self.assertEqual(found, [(pes, 0, 'refused-document')])
        self.refused({MARKER: 'x\n', 'notes/restricted/a.md': 'h\n'}, 'refused-document')
        self.refused({MARKER: 'x\n', 'app/privacy-ethics-safety.md': 'h\n'}, 'refused-document')

    def test_lookalike_names_pass(self):
        self.passed({MARKER: 'x\n', 'docs/restricted.md': 'h\n', 'docs/restricted-x/a.md': 'h\n'})

    def test_unknown_path_outside_docs_source_refuses(self):
~~~~

**Edit `tool/checks/tests/test_g0.py`** (1 of 1). Replace exactly:

~~~~python
    def test_unknown_kinds_refused(self):
~~~~

with:

~~~~python
    def test_generated_strings_pass(self):
        # D32: the two InfoPlist.strings the generator writes, by path.
        self.passed({'app/ios/Runner/en.lproj/InfoPlist.strings': '"k" = "v";\n',
                     'app/ios/Runner/sv.lproj/InfoPlist.strings': '"k" = "v";\n'})

    def test_other_strings_refused(self):
        for path in ('app/ios/Runner/de.lproj/InfoPlist.strings', 'app/ios/Runner/a.strings'):
            self.assertEqual(self.refused({path: '"k" = "v";\n'}), [(path, 0, 'unknown-kind')])

    def test_unknown_kinds_refused(self):
~~~~

**Edit `tool/checks/tests/test_g4.py`** (1 of 1). Replace exactly:

~~~~python
    def test_exempt_places_pass(self):
~~~~

with:

~~~~python
    def test_generated_words_pass(self):
        # D32 Q18: G1 proves these are the generator's output.
        self.passed({'app/ios/Flutter/words.g.xcconfig': 'WORDS_MIC_USAGE = %s\n' % sentence(15)})

    def test_hand_written_xcconfig_refused(self):
        self.refused({'app/ios/Flutter/founder.xcconfig': 'X = %s\n' % sentence(12)},
                     'long-literal')

    def test_exempt_places_pass(self):
~~~~

**Edit `tool/checks/tests/test_hook.py`** (1 of 1). Replace exactly:

~~~~python
                        ignore=shutil.ignore_patterns('__pycache__'))
~~~~

with:

~~~~python
                        ignore=shutil.ignore_patterns('__pycache__'))
        # This tree has no import: it holds the marker whether or not the
        # repository still does (branch 3 deletes it there; D32).
        with open(os.path.join(self.tmp, 'tool', 'checks', 'awaiting-import'), 'w') as f:
            f.write('x\n')
~~~~

**Edit `tool/checks/tests/test_check_all.py`** (1 of 3). Replace exactly:

~~~~python
# tests are not what this checks).
~~~~

with:

~~~~python
# tests are not what this checks). It is a tree before any import: no
# docs/source/, and the awaiting-import marker (branch 3 deletes the
# repository's own; D32).
~~~~

**Edit `tool/checks/tests/test_check_all.py`** (2 of 3). Replace exactly:

~~~~python
LEFT_OUT = ('app/', 'server/')
~~~~

with:

~~~~python
LEFT_OUT = ('app/', 'server/', 'docs/source/')
MARKER = 'tool/checks/awaiting-import'
~~~~

**Edit `tool/checks/tests/test_check_all.py`** (3 of 3). Replace exactly:

~~~~python
        f.write('x\n')
    for args in
~~~~

with:

~~~~python
        f.write('x\n')
    with open(os.path.join(tmp, MARKER), 'w') as f:
        f.write('x\n')
    for args in
~~~~

**Edit `tool/checks/tests/mutations.py`** (1 of 1). Replace exactly:

~~~~python
     ['test_wordsgen.Generator.test_ios_lines_checked']),
]
~~~~

with:

~~~~python
     ['test_wordsgen.Generator.test_ios_lines_checked']),
    # Branch 3, Task 5 (D32): G1 armed, G0, G2 and G4.
    ('g1_words.py', "elif src.read(path) != outputs[path]:", "elif False:",
     ['test_g1_g2.G1.test_generated_differs_refuses']),
    ('g1_words.py', "and p not in KNOWN]", "and False]",
     ['test_g1_g2.G1.test_unknown_words_file_refuses']),
    ('g1_words.py', "return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown, []",
     "outputs = {}",
     ['test_g1_g2.G1.test_generator_refusal_refuses']),
    ('g2_copies.py', "REFUSED_NAMES = ('privacy-ethics-safety.md',)", "REFUSED_NAMES = ()",
     ['test_g1_g2.G2.test_refused_documents_refused']),
    ('g0_kinds.py', ", STRINGS_EN, STRINGS_SV)\n", ")\n",
     ['test_g0.G0.test_generated_strings_pass']),
    ('g4_invented.py', "\n            or path in GENERATED)", ")",
     ['test_g4.G4.test_generated_words_pass']),
]
~~~~

**Edit `tool/checks/importer.py`** (1 of 3). Replace exactly:

~~~~python
import import_rows  # noqa: E402
~~~~

with:

~~~~python
import import_rows  # noqa: E402
import wordsgen  # noqa: E402
~~~~

**Edit `tool/checks/importer.py`** (2 of 3). Replace exactly:

~~~~python
    report('import: recorded in ' + SOURCES)
    return kind
~~~~

with:

~~~~python
    report('import: recorded in ' + SOURCES)
    if kind in ('words', 'lists'):
        # The words follow their inputs at once (D32): the generator
        # writes, and stops on anything it does not expect.
        if os.path.isfile(os.path.join(TOP, CSV)) and os.path.isfile(os.path.join(TOP, LISTS)):
            wordsgen.write_all(TOP, TOP)
        else:
            report('import: the generator waits for the register and the lists')
    return kind
~~~~

**Edit `tool/checks/importer.py`** (3 of 3). Replace exactly:

~~~~python
    except Refused as e:
        report('import: refused ' + e.code)
        return 1
~~~~

with:

~~~~python
    except Refused as e:
        report('import: refused ' + e.code)
        return 1
    except wordsgen.WordsError as e:
        report('import: generator refused %s %s row %d' % (e.source, e.code, e.row))
        return 1
~~~~

**Edit `tool/checks/tests/test_import.py`** (1 of 3). Replace exactly:

~~~~python
from helpers import CHECKS
~~~~

with:

~~~~python
from helpers import CHECKS
import test_wordsgen as invented
~~~~

**Edit `tool/checks/tests/test_import.py`** (2 of 3). Replace exactly:

~~~~python
        self.put('product/lists.md', b'# Lists\n')
~~~~

with:

~~~~python
        self.put('product/lists.md', invented.lists())
~~~~

**Edit `tool/checks/tests/test_import.py`** (3 of 3). Replace exactly:

~~~~python
    def test_wrapper_needs_the_documents_location(self):
~~~~

with:

~~~~python
    def test_words_run_the_generator(self):
        register = invented.register()
        self.put('product/register.csv', register)
        git(self.docs, 'commit', '-q', '-am', 'register')
        git(self.docs, 'push', '-q')
        rc, out = self.run_import('product/register.csv', digest(register), ORDINAL)
        self.assertEqual(rc, 0, out)
        self.assertIn('import: the generator waits for the register and the lists', out)
        rc, out = self.run_import('product/lists.md', digest(invented.lists()), ORDINAL)
        self.assertEqual(rc, 0, out)
        self.assertIn('wordsgen: wrote app/lib/words/lines.g.dart', out)
        self.assertIn('app/ios/Runner/sv.lproj/InfoPlist.strings', self.app_files())

    def test_generator_refusal_is_reported(self):
        register = invented.register(invented.row('A' + invented.DOT + '1', 'unheard of'))
        self.put('product/register.csv', register)
        git(self.docs, 'commit', '-q', '-am', 'register')
        git(self.docs, 'push', '-q')
        self.run_import('product/lists.md', digest(invented.lists()), ORDINAL)
        rc, out = self.run_import('product/register.csv', digest(register), ORDINAL)
        self.assertEqual(rc, 1)
        self.assertIn('import: generator refused register unknown-status row 4', out)
        self.assertNotIn('app/lib/words/lines.g.dart', self.app_files())

    def test_wrapper_needs_the_documents_location(self):
~~~~

Commit: `git add tool/` only. Message `Guards: G1 compares the generated words; G0, G2, G4 for the import (D32
Q18)`.

### Task 6 · [OWNER] Generate, delete the marker, commit (G1 and G2 armed)

Paste 1 — Terminal:

    cd ~/Developer/soul-dreams-app && python3 -I -B tool/checks/wordsgen.py --write && git rm -q tool/checks/awaiting-import && git add docs/source app/assets/words app/lib/words app/ios/Flutter/words.g.xcconfig app/ios/Runner/en.lproj app/ios/Runner/sv.lproj && git status --short && python3 -I -B tool/checks/guards.py --staged

Expected:
1. `wordsgen: wrote` for the five files, then the counts Task 3 printed.
2. `git status --short`: `D  tool/checks/awaiting-import`, `A ` for every copy, SOURCES, the two words inputs and
   the five generated files, and nothing else.
3. Every guard `ok`, G1 and G2 **without** `NOT ARMED`, `guards (staged): all passed`.

Paste 2 — Terminal (only if Paste 1 ended `all passed`):

    cd ~/Developer/soul-dreams-app && git commit -m "Import: the documents, the register and the lists; G1 and G2 armed (D32)" && git log --oneline -1 && tool/check_all.sh 2>&1 | tail -15

Expected: the commit, then `check_all: all passed`, with `Ran 172 tests` and `mutations: 48 run, all caught`.

**Send back** both outputs.

### Task 7 · The iOS wiring and the app's word tests (D32 Q16, Q17; banked items 1, 29)

Red: write `app/test/words/lines_test.dart` and run `fvm flutter test --no-pub test/words` from `app/`. Expected:
5 tests pass (the generated file exists since Task 6; this test proves the API on the real register). It has no red
step of its own; the wiring below is proven by `plutil` and by the owner's Task 8.

**Edit `app/ios/Flutter/founder.xcconfig`** (1 of 2). Replace exactly:

~~~~
#include "Generated.xcconfig"
~~~~

with:

~~~~
#include "Generated.xcconfig"
#include "words.g.xcconfig"
~~~~

**Edit `app/ios/Flutter/founder.xcconfig`** (2 of 2). Replace exactly:

~~~~
// Register place MP·55, until branch 3's generator writes it (D20 Q2).
APP_DISPLAY_NAME = [MP·55]
~~~~

with:

~~~~
// Register place MP·55, from the words generator (D32 Q16, Q17).
APP_DISPLAY_NAME = $(WORDS_APP_NAME)
~~~~

**Edit `app/ios/Flutter/tester.xcconfig`** (1 of 2). Replace exactly:

~~~~
#include "Generated.xcconfig"
~~~~

with:

~~~~
#include "Generated.xcconfig"
#include "words.g.xcconfig"
~~~~

**Edit `app/ios/Flutter/tester.xcconfig`** (2 of 2). Replace exactly:

~~~~
// Register place MP·55, until branch 3's generator writes it (D20 Q2).
APP_DISPLAY_NAME = [MP·55]
~~~~

with:

~~~~
// Register place MP·55, from the words generator (D32 Q16, Q17).
APP_DISPLAY_NAME = $(WORDS_APP_NAME)
~~~~

**Edit `app/ios/Flutter/dev.xcconfig`** (1 of 1). Replace exactly:

~~~~
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = app.souldreams.dev
~~~~

with:

~~~~
#include "Generated.xcconfig"
// The microphone text, EM·3 (D32 Q17). The name below stays.
#include "words.g.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = app.souldreams.dev
~~~~

**Edit `app/ios/Runner/Info.plist`** (1 of 2). Replace exactly:

~~~~xml
	<key>CFBundleName</key>
	<string>souldreams</string>
~~~~

with:

~~~~xml
	<key>CFBundleName</key>
	<string>$(APP_DISPLAY_NAME)</string>
~~~~

**Edit `app/ios/Runner/Info.plist`** (2 of 2). Replace exactly:

~~~~xml
	<key>LSRequiresIPhoneOS</key>
	<true/>
~~~~

with:

~~~~xml
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>NSMicrophoneUsageDescription</key>
	<string>$(WORDS_MIC_USAGE)</string>
~~~~

**Edit `app/ios/Runner.xcodeproj/project.pbxproj`** (1 of 6). Replace exactly:

~~~~
		97C147011CF9000F007C117D /* LaunchScreen.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = 97C146FF1CF9000F007C117D /* LaunchScreen.storyboard */; };
~~~~

with:

~~~~
		97C147011CF9000F007C117D /* LaunchScreen.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = 97C146FF1CF9000F007C117D /* LaunchScreen.storyboard */; };
		D3200001000000000000A004 /* InfoPlist.strings in Resources */ = {isa = PBXBuildFile; fileRef = D3200001000000000000A003 /* InfoPlist.strings */; };
~~~~

**Edit `app/ios/Runner.xcodeproj/project.pbxproj`** (2 of 6). Replace exactly:

~~~~
		97C147021CF9000F007C117D /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
~~~~

with:

~~~~
		97C147021CF9000F007C117D /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
		D3200001000000000000A001 /* en */ = {isa = PBXFileReference; lastKnownFileType = text.plist.strings; name = en; path = en.lproj/InfoPlist.strings; sourceTree = "<group>"; };
		D3200001000000000000A002 /* sv */ = {isa = PBXFileReference; lastKnownFileType = text.plist.strings; name = sv; path = sv.lproj/InfoPlist.strings; sourceTree = "<group>"; };
~~~~

**Edit `app/ios/Runner.xcodeproj/project.pbxproj`** (3 of 6). Replace exactly:

~~~~
				97C147021CF9000F007C117D /* Info.plist */,
				1498D2321E8E86230040F4C2
~~~~

with:

~~~~
				97C147021CF9000F007C117D /* Info.plist */,
				D3200001000000000000A003 /* InfoPlist.strings */,
				1498D2321E8E86230040F4C2
~~~~

**Edit `app/ios/Runner.xcodeproj/project.pbxproj`** (4 of 6). Replace exactly:

~~~~
				97C146FC1CF9000F007C117D /* Main.storyboard in Resources */,
			);
~~~~

with:

~~~~
				97C146FC1CF9000F007C117D /* Main.storyboard in Resources */,
				D3200001000000000000A004 /* InfoPlist.strings in Resources */,
			);
~~~~

**Edit `app/ios/Runner.xcodeproj/project.pbxproj`** (5 of 6). Replace exactly:

~~~~
			name = LaunchScreen.storyboard;
			sourceTree = "<group>";
		};
/* End PBXVariantGroup section */
~~~~

with:

~~~~
			name = LaunchScreen.storyboard;
			sourceTree = "<group>";
		};
		D3200001000000000000A003 /* InfoPlist.strings */ = {
			isa = PBXVariantGroup;
			children = (
				D3200001000000000000A001 /* en */,
				D3200001000000000000A002 /* sv */,
			);
			name = InfoPlist.strings;
			sourceTree = "<group>";
		};
/* End PBXVariantGroup section */
~~~~

**Edit `app/ios/Runner.xcodeproj/project.pbxproj`** (6 of 6). Replace exactly:

~~~~
			knownRegions = (
				en,
				Base,
			);
~~~~

with:

~~~~
			knownRegions = (
				en,
				Base,
				sv,
			);
~~~~

**New file `app/test/words/lines_test.dart`**

~~~~dart
// The generated words (D32): read by handle only, never quoted (R1).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/words/lines.g.dart';

void main() {
  test('the home-screen name is one line, the same in both languages', () {
    expect(Lines.MP_55.written, isTrue);
    expect(Lines.MP_55.parts(Lang.en), hasLength(1));
    expect(Lines.MP_55.text(Lang.sv), Lines.MP_55.text(Lang.en));
  });

  test('the microphone text is written in both languages', () {
    expect(Lines.EM_3.written, isTrue);
    expect(Lines.EM_3.text(Lang.en), isNotEmpty);
    expect(Lines.EM_3.text(Lang.sv), isNotEmpty);
  });

  test('a place with no line yet shows its handle', () {
    for (final line in Lines.all.where((l) => !l.written)) {
      expect(line.parts(Lang.en), ['[${line.handle}]']);
      expect(line.parts(Lang.sv), ['[${line.handle}]']);
    }
  });

  test('every written line has its parts in both languages', () {
    for (final line in Lines.all.where((l) => l.written)) {
      expect(line.parts(Lang.sv), hasLength(line.parts(Lang.en).length));
      expect(line.parts(Lang.en).every((p) => p.isNotEmpty), isTrue);
      expect(line.parts(Lang.sv).every((p) => p.isNotEmpty), isTrue);
    }
  });

  test('handles are unique', () {
    final handles = Lines.all.map((l) => l.handle).toList();
    expect(handles.toSet(), hasLength(handles.length));
  });
}
~~~~

Then, from the repository root: `plutil -lint app/ios/Runner/Info.plist app/ios/Runner.xcodeproj/project.pbxproj
app/ios/Runner/en.lproj/InfoPlist.strings app/ios/Runner/sv.lproj/InfoPlist.strings` prints four `OK`. From
`app/`: `No issues found!` and `All tests passed!` (14 tests). Guards all passed. Commit: `git add app/` only.
Message `iOS: the name and microphone text from the generated words (D32 Q16, Q17)`.

### Task 8 · [OWNER] The Xcode checks and a compile per flavour

Claude Code writes this script (not committed), then stops:

**File `.scratch/scaffold-3/xcode_checks.sh`**

~~~~sh
#!/bin/sh
# scaffold-3-import, Task 8: the flavours read the generated words. It
# prints settings and yes or no, never the microphone text.
set -u
cd "$(git rev-parse --show-toplevel)/app" || exit 2
for f in dev founder tester; do
  t=lib/main_$f.dart; [ "$f" = tester ] && t=lib/main.dart
  fvm flutter build ios --debug --no-codesign --flavor "$f" -t "$t" >/dev/null 2>&1 \
    && echo "$f: build ok" || echo "$f: BUILD FAILED"
  plist=build/ios/iphoneos/Runner.app/Info.plist
  for k in CFBundleDisplayName CFBundleName; do
    echo "$f: $k = $(plutil -extract $k raw "$plist" 2>/dev/null || echo MISSING)"
  done
  m=$(plutil -extract NSMicrophoneUsageDescription raw "$plist" 2>/dev/null)
  case "$m" in ''|'$('*) echo "$f: microphone text MISSING" ;; *) echo "$f: microphone text present" ;; esac
  for l in en sv; do
    [ -f "$(dirname "$plist")/$l.lproj/InfoPlist.strings" ] && echo "$f: $l.lproj present" \
      || echo "$f: $l.lproj MISSING"
  done
done
~~~~

Paste 1 — Terminal:

    cd ~/Developer/soul-dreams-app && sh .scratch/scaffold-3/xcode_checks.sh; git status --short

Expected, for each of `dev`, `founder` and `tester`: `build ok`; `CFBundleDisplayName` and `CFBundleName` equal
(`SoulDreams Dev` for dev, the MP·55 name for founder and tester, never `[MP·55]` or `souldreams`); `microphone text
present`; `en.lproj present`, `sv.lproj present`. `git status --short` prints nothing. **Send back** the output; a
`MISSING` or `FAILED` stops the branch. (The built app's path, `build/ios/iphoneos/Runner.app`, is Flutter's usual
one and was not provable in the sandbox; if every key reads `MISSING` after `build ok`, send the build's last lines.)

### Task 9 · Docs (D32 Q2; R1's placeholders)

1. **`docs/workflow.md`** (ask; the owner approves at the prompt). Replace the "Imports" section's command block and
   the sentence after it with:

   ~~~~
       cd ~/Developer/soul-dreams-app && SOUL_DREAMS_DOCS=~/Developer/soul-dreams-docs tool/import.sh <documents path> <expected-sha256> "<filing ordinal>"

   It refuses on any doubt: a mismatch, a dirty or unsynced documents repository, a path not in
   `tool/checks/import_rows.py`, or `main`. On a match it copies the file into `docs/source/` (or
   `app/assets/words/` for the register and the lists), records its hash and the filing's ordinal in
   `docs/source/SOURCES`, regenerates the words when the register or the lists change (`lines.g.dart`,
   `lists.g.dart`, `words.g.xcconfig` and the two `InfoPlist.strings`), and stops for the owner to commit.
   ~~~~
2. **`CLAUDE.md`** (ask). Three lines:
   - G1: "the generated words (`lines.g.dart`, `lists.g.dart`, `words.g.xcconfig` and the two `InfoPlist.strings`)
     are exactly what the generator makes from the CSV and the lists, nothing else sits in `app/lib/words/` or
     `app/assets/words/`, and the CSV's and lists' hashes match `docs/source/SOURCES`."
   - G2: append "; no tracked `privacy-ethics-safety.md`, and nothing in a folder named `restricted`."
   - G4: "outside `fixtures/invented-nights.json`, `app/lib/words/` and the generated iOS words".
3. **`docs/Status.md`**: "Current branch" names this plan; "Road ahead" drops branch 3 and adds the Head of
   Technology's direction for a later branch (lens sections 3, 4, 5, 6 and 11 with G10; the waking-material lens
   whole into `server/instructions/`); "The guards": G1 and G2 armed; totals 172 tests and 48 mutations; the app's
   tests 14; banked items 1 and 29 closed; banked: plurals (D32 Q13); the placeholders list from Task 3 (handles
   only); "Documents as last imported": each SOURCES line's path, ordinal and first 12 hex digits; "Rulings during
   branch 3": D31 and D32, one line each.

---

## Part 4 · Open questions (numbered; a blank is not a yes)

1. **D31.** This plan reads D31 as the brief that opened the branch (the owner's leans, listed in Part 1). *If not,*
   give D31's text, and Part 1's row changes; nothing else depends on its wording.
2. **The documents repository's location comes from `SOUL_DREAMS_DOCS`**, set in the owner's paste, so no file in
   this repository names it (R6). *Lean:* yes. *If not:* `tool/import.sh` names the path itself, which R6's
   "never reference" forbids Claude Code to write; the owner would write that line.
3. **The `copy` kind accepts only `.md`.** *Lean:* yes; every listed document is Markdown as far as the Build chat
   knows. *If a document is not:* a new kind, and G0 learns its extension, at the owner's approval.
4. **The two fixture changes** (`test_hook.py`, `test_check_all.py`; Part 1, "The guards after this branch").
   *Lean:* yes; they keep their claims. *If not:* those two tests fail after Task 6, and the branch cannot end green.
5. **`check_all.sh` stays the owner's in this branch** (Tasks 6 and 8). *Lean:* yes, as in branch 2. The replay ran
   it in the sandbox (Part 5), so a later branch may hand it to Claude Code. *If not:* Claude Code runs it at the end
   of Tasks 5 and 7.
6. **The status counts in Task 3** come from the Build chat's copy of the register. *Lean:* any difference stops the
   branch for a ruling, even one that the generator would accept. *If not:* only differences the generator refuses
   stop it.

---

## Part 5 · How this plan was proven

On 2026-11-10, before this file was committed:

1. **Built** in a scratch worktree, `./.scratch/build3` (detached at `89c0cf0`), with an invented register and lists.
2. **Every task's code in Part 3 is generated from one list of operations** (a builder in Claude Code's scratchpad),
   which first checks that the operations, applied in order to `89c0cf0`, give the proven tree byte for byte.
3. **Replayed on a clean worktree**, `./.scratch/build3r`, from those same operations, each Claude Code task
   committed through the pre-commit hook:
   - Task 0: `Ran 117 tests`, `OK`; `mutations: 32 run, all caught`.
   - Task 1: `Ran 134 tests`, `OK`; `mutations: 37 run, all caught`; guards all passed, G1 and G2 NOT ARMED.
   - Task 2, simulated: invented rows; an invented documents repository with a bare remote in `$TMPDIR`; three
     imports through `tool/import.sh` with `SOUL_DREAMS_DOCS` set, each `hash ok`; the copies untracked;
     `guards (tracked): all passed`, G1 and G2 NOT ARMED.
   - Task 4: `Ran 159 tests`, `OK`; `mutations: 42 run, all caught`.
   - Task 5: `Ran 172 tests`, `OK`; `mutations: 48 run, all caught`; G1 and G2 still NOT ARMED.
   - Task 6, simulated: `wordsgen.py --write` (five files), the marker removed, the exact `git add` of the paste,
     `guards (staged): all passed` with G1 and G2 armed, the commit through the hook; then 172 tests and 48
     mutations again.
   - Task 7: `plutil -lint` four `OK`; `fvm flutter analyze --no-pub` `No issues found!`; `fvm flutter test --no-pub`
     `All tests passed!` (14).
   - The replayed tree's tracked files equal the proven tree's, apart from the simulated `import_rows.py` and
     `SOURCES`.
   - `tool/check_all.sh` on the replayed tree: `flutter: pinned 3.47.9, running 3.47.9`, `check_all: all passed`.
4. **The reds**, each checked on its own: Task 1's test alone, `Ran 17 tests`, `FAILED (failures=17)`; Task 4's,
   `No module named 'wordsgen'`; Task 5's test edits on Task 4's commit, `Ran 65 tests`, `FAILED (failures=11)`,
   exactly the eleven named.
5. **The Dart API on an invented register**, generated into a copy of `app/`: analyzer clean, and a throwaway test
   passed for parts, `standIn`, a waiting place's `[A·3]`, slots filled in both languages, `$`, `'` and `\`
   escaped, and `ListWords.TECH_3`. A multi-part line's `text()` throws in debug.
6. **Found by the replay and fixed in the plan:** `test_hook.py` and `test_check_all.py` relied on the repository's
   own marker, and fail once Task 6 deletes it (Part 4, question 4); `test_import.py` needed `tool/import.sh`, which
   the mutation checks' copy of `tool/checks/` does not hold (the copy is now conditional, and the wrapper's own test
   asserts it exists); the generator's Dart template first held literals of twelve words or more, which G4 refuses.
7. **Not provable in the sandbox, and so the owner's:** the settings and both canaries (Task 0); the real import
   (Task 2); Task 3's shape and Task 4's real-file proof; Task 6 on the real files; every `xcodebuild` (the sandbox
   refuses Xcode's package cache: "You don't have permission to save the file 'repositories'") and the built app's
   path (Task 8).
8. The scratch worktrees were removed after the proof. The replay's invented documents repository, in `$TMPDIR`,
   committed under a throwaway identity set for that repository's command only.

---

## Part 6 · What the build changed (the final review's docs pass, 2026-11-11)

Written after the branch was built and reviewed. The rulings are listed in `docs/Status.md`, "Rulings during branch 3".
**Where this part and Parts 1 to 5 differ, this part governs.**

### The commits, in order

`1e928eb` settings (D32 Q19) · `a69319c` Task 1, the import · `fe30009` Task 1a (D35) · `6c6f4a3` Task 2b, the rows ·
`0093fe2` Task 4, the generator (D36) · `51c5906` Task 4a (D37) · `e5999c2` Task 5, the guards · `79bca6d` Task 5a (D38)
· `448cef3` Task 5b (D39) · `ca29414` Task 6, the owner's import · `8ac1cfb` Task 7, the iOS wiring · `b3c50ba` Task 9,
the docs. Tasks 3 and 8 are not committed (`.scratch/`); Task 3's report is
`.scratch/for-build-chat/scaffold-3-shape.md`. Task 0's canary was waived (D34).

### The totals

Guard tests and mutation checks, by task: Task 0 baseline 117 and 32 · Task 1 134 and 37 · Task 1a 141 and 45 · Task 4
170 and 54 · Task 4a 171 and 55 · Task 5 184 and 61 · Task 5a 185 and 62 · Task 5b 188 and 63 · D40's tests 192 and 68.
**Final: 192 tests, 68 mutations** (Task 1 +17/+5, 1a +7/+8, 4 +29/+9, 4a +1/+1, 5 +13/+6, 5a +1/+1, 5b +3/+1, D40
+4/+5). The final review's docs pass (`b3c50ba`, `7e97a45`) saw 188 and 63. The app's tests: 14. The plan's
172 and 48, its 159 and 42, and its 134 and 37 gates in Tasks 4 to 6 and 9 are superseded by these.

### Superseded text, in order

1. **Lines 75 to 77 and Part 4, Q2:** "no file in this repository names the documents repository's path" is not what the
   repository says: `docs/workflow.md` and Task 9's paste name it as the owner's command (and R6 and the settings do
   as refusals). What holds is that no *code* reads it; `tool/import.sh` takes it from `SOUL_DREAMS_DOCS`.
2. **Lines 96 to 97 (after a words or lists import):** a generator refusal leaves the copy and `SOURCES` already
   written, and the generated words stale; G1 then refuses any commit (`generator-refused:<code>`). Nothing is rolled
   back (D40); the importer's header and `docs/workflow.md` say so.
3. **The status table (line 105):** `written, in its parts` with both fields empty gets no constant (D36 Q2).
4. **The handle rule (line 116):** `^[A-Z][A-Z0-9]*(-[A-Z0-9]+)*(·[0-9]+)?$`; the Dart name replaces both `·` and `-`
   with `_`; two handles with one Dart name stop the generator with `dart-name-clash` (D36 Q1).
5. **The lists (lines 124 to 126, Task 4's `read_lists`, Task 3's expectations):** five `## TECH·n — <title>` sections;
   in each, the items under the `**English**` and `**Swedish**` marker lines; a non-blank line that is not an item
   closes the list (D37); a line that looks like an item but is not one stops (D38); every shape error is
   `lists-shape`. `lists.g.dart` holds ten constants, `tech1En` to `tech5Sv` (class `ListWords`). The codes
   `sections`, `unexpected-line`, `empty-section`, `unexpected-heading` and `bad-word` no longer exist; `TECH_1` and
   `TECH_5` in Task 4's test, and `ListWords.TECH_3` in Part 5, are `tech1En`, `tech5Sv` and `tech3En`.
6. **Task 3 (lines 803 to 838 and 895 to 905):** the real counts are `written` 99, `composed (stand-in written)` 9,
   `retired` 36, `to rewrite` 7, `composed, no stand-in` 3 (the others as expected); 41 handles are outside the first
   pattern; one `written, in its parts` row is empty; the lists are per language. "Any difference stops the branch"
   was relaxed to the structural ones by D33 (point 1), and Part 4, Q6 with it.
7. **Task 4 (lines 907 to 912 and the code and test blocks to line 1693):** the generator and its tests as committed in
   `0093fe2`, `51c5906` and `79bca6d`: 29 tests and 9 mutation rows, then 4a (+1/+1) and 5a (+1/+1); the gate was
   170 and 54, not 159 and 42. The BOM test in `decode()` holds the literal character, as the plan has it.
8. **Task 5 (lines 1729 to 1738 and 1987 to 1993):** the gate is 184 and 61; the red run had 72 tests with the eleven
   named failing; the lists refusal expects `(LISTS, 5, 'generator-refused:lists-shape')`.
9. **Tasks 5a and 5b were added** (D38: an item-like line stops, `79bca6d`; D39: G7's high-entropy rule is off under
   `docs/source/` and every key shape still applies, `448cef3`, with `test_g7.py` +3 and one mutation row).
10. **Task 6 and Task 9 (lines 2280 and 2601):** the totals were 188 and 63 at those tasks (192 and 68 after D40).
    Task 6 ran with Task 5b's change in place.
11. **Part 5:** the proof of the plan as first written; its counts (159/42, 172/48) and `ListWords.TECH_3` are
    superseded as above.
12. **Task 1a (D35)** is not in the plan: the review's fixes: `on-main` compares the full ref (a tag named `main`, a
    detached HEAD at `main`), `git()` drops every `GIT_*` variable, the ordinal refuses C1 controls and the Unicode
    line and paragraph separators, three refusal codes tested, the wrapper test no longer passes through `bad-hash`.

*No matter where you are on your journey, the steps you take are equally important.*
