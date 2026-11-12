# Plan: journal-screens (the journal's pages, in SoulDreams Dev only)

*No matter where you are on your journey, the steps you take are equally important.*

Written by Claude Code (Opus) on 2026-11-12 from the investigation
(`.scratch/for-build-chat/journal-screens-investigation.md`) and the owner's rulings D56, D57 and D58; **amended the
same day** with D59, the owner's answers to Part 4. **Proven before committing as far as the sandbox allows**
(Part 5). The amendment commits this file and `fixtures/invented-nights.json` (D59 Q9); nothing else is implemented
yet.

## Part 1 · Spec

### In plain words

SoulDreams Dev gets the journal's pages. Nothing changes in the founder's or the testers' app except what they share
with Dev: the theme now follows the clock, and Flutter's own localizations are loaded. Neither app shows a page of
the journal; a test proves they cannot reach its code.

1. **The journal list**, the app's home in Dev.
   - One row per night, newest first: the date (or a name and the date), then the first dream cut to three lines,
     with any TECH·1 framing at its very start trimmed.
   - A month divider over each month that has nights: the phone's own month name, capitalised; the year too, before
     this year.
   - The record button at the bottom opens the typing screen. With no night, C4-P·5 and the record button.
2. **The typing screen.**
   - The top line is MP·10 the first time, MP·32 after. Then the empty field, with MP·12 as its placeholder, and
     Save.
   - Save and Back both keep what was typed as a new dream, and go back. Nothing typed keeps nothing.
   - The same screen, filled, edits a dream.
3. **A night's page.**
   - The date, "Dreams", and the dreams; tapping one edits it. "Add dreams" adds one.
   - The "⋯" menu holds one item: deleting the night, behind the phone's own confirmation dialog.
4. **The night rules.**
   - A night closes at the first 21:00 after its first recording, in the zone of that moment. The closing instant is
     kept, so a journey or a clock change never moves it.
   - The typing screen decides its night when it opens. An emptied dream disappears; a night with no dream left is
     deleted.
5. **Night/Day automatic.**
   - Dark from 21:00 to 08:00 by the phone's clock. A five-second fade if the app is open; instant with Reduce Motion,
     at start, and on returning to the app.
   - The app's own lines appear a word every 60 ms, whole with Reduce Motion.
6. **The pending lines.**
   - MP·60 ("Delete") and MP·61 ("Cancel") are not yet in the register. They live in a small file the owner writes
     (`app/assets/words/pending-lines.csv`), fingerprinted, and the words generator makes them into
     `pending.g.dart`.
   - A `PendingLine` cannot stand where a filed line is asked for. Its words show only in SoulDreams Dev; any other
     build shows its handle.
7. **The screenshots.** The founder's journal screenshots, invented content only, sit in `docs/reference/screens/`,
   fingerprinted (G2). They set, by eye, the values the Design System leaves unset. Those values are named stand-ins
   in one file. No word is ever taken from a screenshot.

### What this branch builds

- **Guards** (Tasks 2, 3):
  - `wordsgen.py` reads the pending lines and writes `pending.g.dart`;
  - G1 proves the pending file against its fingerprint, and `pending.g.dart` against the generator;
  - G0 knows the two fingerprint files by exact path;
  - G2 proves `docs/reference/screens/`.
- **The app** (Tasks 5 to 12):
  - the night's closing instant;
  - the night rules and the journal's operations;
  - the row's text and the month dividers;
  - the palette, Night/Day automatic and Flutter's localizations;
  - the app's word-by-word line;
  - the named stand-ins;
  - the three pages;
  - Dev's first page;
  - the import walk.
- **The owner's** (Tasks 1, 4, 14, 15):
  - the packages;
  - the pending lines;
  - the screenshots;
  - the phone checks.
- **Claude Code's** (Task 14): the stand-ins measured from the screenshots, numbers only.

### What it does not build

- Settings, and with it Manual mode, the quick toggle, Word Animation, Language and Delete journal (P8).
- Search (P8). Naming a night (P7; its row look is built, D57 Q6).
- Recording by voice, Start Interpretation and the space below the dreams.
- Any change to the founder's or the testers' entry points (D49 O1).

### The decisions, by number

| | Ruling | Where it lands |
|---|---|---|
| D56 | The brainstorm's five leans: the scope; pending lines in a small file the owner adds; month names through Flutter's localization package; the screenshots as reference only; Night/Day automatic now | All tasks |
| D57 Q5 | The record button opens the typing screen, Dev only | Task 11 |
| D57 Q6 | A named row's look is built, though nothing names a night yet | Task 11 |
| D57 Q9 | `flutter_localizations` and `intl` added; Flutter's framework words are not ours under R1 | Tasks 1, 7 |
| D57 Q10 | `TextCapitalization.sentences`, so the phone's own setting decides; nothing else overridden | Task 9 |
| D57 Q11 | The pending-lines file, its fingerprint, `PendingLine`, Dev only, `pending-filed` | Tasks 2, 4, 10, 12 |
| D57 Q12 | English only for Cohort 0: `appLanguage = Lang.en`, one line to switch later; Swedish built and tested | Tasks 6, 7 |
| D57 Q13 | Two nights open (the clock moved back): the latest first recording is tonight's | Task 5 |
| D57 Q14 | Format version 1 gains `closes`; the owner removes and reinstalls SoulDreams Dev | Tasks 5, 15 |
| D57 Q15 | The theme at start and on returning is instant; the fade only while the app is open | Task 7 |
| D57 Q16 | Night/Day in `app.dart`, so in all three apps, like the cover | Task 7 |
| D57 Q18 | The fixture gains an invented night; the owner moves the phone's date by hand; no seeding | Tasks 11, 15 |
| D58 Q1 | MP·39 as written, Dev only, until naming | Task 10 |
| D58 Q2 | The moment the typing screen opens fixes a typed night's date and 21:00 | Tasks 5, 9, 11 |
| D58 Q3 | An emptied dream disappears, the others remain; whitespace alone is empty (founder) | Tasks 5, 10 |
| D58 Q4 | Editing opens the typing screen filled, with Save and Back; no inline editing (founder) | Tasks 9, 10 |
| D58 Q7 | The first dream cut to three lines; TECH·1 as a whole word or phrase, ignoring case | Tasks 6, 11 |
| D58 Q8 | The phone's standard confirmation: Cancel first, Delete destructive (founder); an unread night's dreams as the screenshots show | Tasks 10, 14 |
| D58 Q11 | MP·60 "Delete", MP·61 "Cancel" (and Swedish) as pending lines under those handles; W27·5 keeps its handle | Tasks 4, 10 |
| D58 Q17 | Word by word at about one word every 60 ms | Task 8 |
| D58 screens | Not filed: the owner's reference folder `docs/reference/screens/` with a fingerprints file; G0, G2 learn it | Tasks 3, 4, 14 |
| D59 | Part 4 answered: Q1 the suggested `CLAUDE.md` wording, edited in the docs task; Q2 Opus changes numbers only; Q3 `newQueueForTests()` `@visibleForTesting`; Q4 to Q8, Q10 the leans; Q9 the new invented night committed with this amendment | Tasks 9, 11, 14, 16 |

### The places these pages use

All from `lines.g.dart`, status "written", except the two pending lines. No placeholder handle is shown in Dev.

| Handle | Where |
|---|---|
| C4-P·5 | The empty journal, in the app's voice, word by word |
| MP·11 | The record button |
| MP·10, MP·32 | The typing screen's top line, first use, then after |
| MP·12 | The empty field's placeholder |
| MP·13 | Save |
| MP·14 | The back arrow's spoken name (its tooltip) |
| MP·38 | The section label "Dreams" |
| MP·29 | "Add dreams" |
| MP·39 | The "⋯" menu's spoken name (its tooltip) |
| EM·11, second part | The menu's one item, delete this night |
| C4-P·4 | The confirmation's sentence |
| MP·61, MP·60 | The confirmation's Cancel and Delete: **pending lines**, Dev only |
| TECH·1 (lists) | The framing trimmed from a row's opening |

Month names come from Flutter's localization data (D56; D57 Q9), never typed. The date's digits are day/month/year.

### The format, still version 1 (D57 Q14)

Each night's file gains one key, `closes`: the UTC instant of the first 21:00 after `firstRecorded`, in the zone then
in force. A file without it, or with one that is not UTC or not after `firstRecorded`, is not a night (skipped, never
touched, D49 O7). Nothing has reached the founder app, so this is not a storage change under `docs/workflow.md` (c).
The owner removes and reinstalls SoulDreams Dev to clear its earlier invented nights (Task 15).

### The named stand-ins (P13; Task 14)

`app/lib/design/stand_ins.dart` holds every value the Design System leaves unset. The plan sets first values; Task 14
measures them from the screenshots.

- The page side, the row gap and padding, and `space.journal.end`.
- The divider's space above and below.
- The record button's height, width and place.
- The button, label and bubble padding, the bubble gap, the field padding and the screen's gap.
- The summary's type role (the dreamer's voice).

They are never written into `tokens.g.dart`, which G1 pins to `design-system.md`.

Also stand-ins, banked for the founder's look:
- Material's `Icons.hotel` for Save's sleeping person;
- `Icons.arrow_back_ios_new` for Back;
- a Material popup for the menu;
- the linear fade curve.

## Part 2 · Settings

None change. Every edit below is to a path Claude Code may already write, except:
- `tool/checks/wordsgen.py`, under "ask" (D40 c): the owner approves its Task 2 edit at the prompt;
- the words folders (`app/assets/words/`, `app/lib/words/`), closed to Claude Code. Tasks 2 and 4 regenerate there
  by the owner's hand.

D58 approves G0's two new known paths: `app/assets/words/pending-fingerprint.txt` and
`docs/reference/screens/fingerprints.txt`. `CLAUDE.md` is the owner's: its R1, G0, G1 and G2 lines need his words
(Part 4, Q1).

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, generated from the commit that proved it (Part 5). Apply it
from the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit
through the hook with the message given. A block never holds an owner's file: the pending words, the screenshots and
generated words are made by the owner's own commands, given in full.

Every task ends green:
- `fvm flutter analyze --no-pub` prints `No issues found!`;
- `fvm flutter test --no-pub` passes, at the count given;
- for guard tasks, `python3 -I -B tool/checks/tests/run_tests.py` ends `OK` at the count given, and
  `python3 -I -B tool/checks/tests/mutations.py` ends `all caught`.

Claude Code runs the app's analyzer and tests in the sandbox (D55).

### Task 0 · Baselines

From the repository root, on `journal-screens`, with a clean tree:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 && (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- nothing from `git status`;
- the plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+60: All tests passed!`.

Anything else: stop (R14).

### Task 1 · [OWNER] The two packages (D57 Q9)

The sandbox reaches no package registry, so `pub add` is the owner's (D47).

Paste 1 — Terminal
```
cd ~/Developer/soul-dreams-app/app && fvm flutter pub add 'flutter_localizations:{"sdk":"flutter"}' 'intl:^0.20.3' && git diff --stat pubspec.yaml pubspec.lock
```

Expected: `pubspec.yaml | 3 +++` and `pubspec.lock | 13 +++++++++++++`.
- `pubspec.yaml` gains `flutter_localizations: sdk: flutter` and `intl: ^0.20.3` under `dependencies`.
- `pubspec.lock` gains `flutter_localizations` (sdk) and `intl` 0.20.3, sha256 `1ca20c89…a867`, both
  `direct main`.
- Any other version, or any other changed package: stop and bring the output.

The proof made the same two changes with `--offline` from the pub cache (Part 5).

Then Claude Code checks (`fvm flutter analyze --no-pub`, `fvm flutter test --no-pub`: 60 tests) and commits:

> App: flutter_localizations and intl 0.20.3, the owner's pub add (D56, D57 Q9)

### Task 2 · The pending lines: the generator, G1 and G0 (D57 Q11)

`wordsgen.py` learns the owner's pending lines:
- `read_pending` reads them, refusing with a code and a row;
- `pending_dart` writes `pending.g.dart`.

`guardlib.py` names the three paths and shares the fingerprint pattern with G2. G1 proves the pending file against
its fingerprint, and `pending.g.dart` against the generator. G0 knows the fingerprint by exact path.

Five new guard mutation rows (81 to 85). Rows 58, 60, 66 and 67 follow the code they break.

Editing `wordsgen.py` asks; the owner approves.

**Steps:**
1. Apply the block.
2. Then the owner generates the empty `pending.g.dart`, which Claude Code cannot write:

   Paste 2 — Terminal
   ```
   cd ~/Developer/soul-dreams-app && python3 -I -B tool/checks/wordsgen.py --write | grep -E 'wrote|pending' && shasum -a 256 app/lib/words/pending.g.dart
   ```

   Expected:
   - `wordsgen: wrote app/lib/words/pending.g.dart`;
   - `wordsgen: pending lines 0`;
   - `d1954a98b582f318919cd21c82f4626d88b4952aed298181cee8e0425664c463`.

3. Stage everything (`git add -A`), then run the guard tests and the guard mutations. The hook tests copy the tracked
   files, so staging comes first.

Expected:
- `Ran 238 tests`, `OK`;
- `mutations: 85 run, all caught`;
- the app unchanged at 60 tests.

Commit:

> Guards: the pending lines, generated as PendingLine and proven by G1 with their fingerprint (D57 Q11)

**The block** (from the proof's `30e6870`):

~~~~diff
diff --git a/tool/checks/g0_kinds.py b/tool/checks/g0_kinds.py
index 6ee59d0..fa3eb8d 100644
--- a/tool/checks/g0_kinds.py
+++ b/tool/checks/g0_kinds.py
@@ -5,17 +5,20 @@
 # unknown '#!' interpreter, or of any other kind, is refused as
 # unknown-kind. A branch that brings a new kind of file extends these
 # lists, and the owner approves the change at the prompt. D49 a: .txt is
-# known in the fonts folder only (the licences and the fingerprints).
+# known in the fonts folder only (the licences and the fingerprints);
+# D57 Q11: and the pending lines' fingerprint, by exact path.
 import posixpath
 
-from guardlib import FONTS, LOCKFILES, MARKER, SOURCES, STRINGS_EN, STRINGS_SV, Finding
+from guardlib import (FONTS, LOCKFILES, MARKER, PENDING_FINGERPRINT, SOURCES, STRINGS_EN,
+                      STRINGS_SV, Finding)
 
 CODE = 'G0'
 NAME = 'file kinds'
 UNSCANNED_EXT = ('.md', '.csv')
 UNSCANNED_NAMES = ('.gitignore',) + LOCKFILES
 # The two generated InfoPlist.strings, by exact path: G1 proves them (D32).
-UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV)
+# The pending lines' fingerprint, by exact path: G1 proves it (D57 Q11).
+UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV, PENDING_FINGERPRINT)
 
 
 def known(src, path):
diff --git a/tool/checks/g1_words.py b/tool/checks/g1_words.py
index cee1a62..89cec93 100644
--- a/tool/checks/g1_words.py
+++ b/tool/checks/g1_words.py
@@ -2,16 +2,39 @@
 # generated words (guardlib.GENERATED) are exactly what wordsgen makes
 # from them. Nothing else may sit in the two words folders. The design
 # values (D49 a): TOKENS is exactly what designgen makes from DESIGN,
-# whose hash G2 proves. NOT ARMED while the awaiting-import marker
-# exists; refuses the marker beside SOURCES.
+# whose hash G2 proves. The pending lines (D57 Q11), when the owner has
+# written them: the file matches its fingerprint, and pending.g.dart is
+# made from it. NOT ARMED while the awaiting-import marker exists;
+# refuses the marker beside SOURCES.
 import designgen
 import wordsgen
-from guardlib import (CSV, DESIGN, GENERATED, LISTS, MARKER, SOURCES, TOKENS, WORDS_ASSETS,
-                      WORDS_LIB, Finding, parse_sources, sha256)
+from guardlib import (CSV, DESIGN, FINGERPRINT, GENERATED, LISTS, MARKER, PENDING_CSV,
+                      PENDING_FINGERPRINT, SOURCES, TOKENS, WORDS_ASSETS, WORDS_LIB, Finding,
+                      parse_sources, sha256)
 
 CODE = 'G1'
 NAME = 'words'
-KNOWN = (CSV, LISTS) + GENERATED
+KNOWN = (CSV, LISTS, PENDING_CSV, PENDING_FINGERPRINT) + GENERATED
+WHERE = {wordsgen.REGISTER: CSV, wordsgen.LIST_FILE: LISTS, wordsgen.PENDING: PENDING_CSV}
+
+
+def pending_findings(src):
+    # The pending file and its fingerprint come together or not at all.
+    # The fingerprint is one shasum line naming the file.
+    has_csv, has_print = src.has(PENDING_CSV), src.has(PENDING_FINGERPRINT)
+    if not has_csv and not has_print:
+        return []
+    if not has_print:
+        return [Finding(PENDING_CSV, 0, 'pending-unfingerprinted')]
+    if not has_csv:
+        return [Finding(PENDING_FINGERPRINT, 0, 'pending-missing')]
+    text = src.text(PENDING_FINGERPRINT) or ''
+    m = FINGERPRINT.match(text[:-1]) if text.endswith('\n') else None
+    if not m or m.group(2) != PENDING_CSV.rsplit('/', 1)[1]:
+        return [Finding(PENDING_FINGERPRINT, 1, 'fingerprint-malformed')]
+    if sha256(src.read(PENDING_CSV)) != m.group(1):
+        return [Finding(PENDING_CSV, 0, 'hash-mismatch')]
+    return []
 
 
 def design_findings(src):
@@ -45,15 +68,16 @@ def check(src):
             findings.append(Finding(path, 0, 'missing'))
         elif sha256(src.read(path)) != entries[path][0]:
             findings.append(Finding(path, 0, 'hash-mismatch'))
+    findings += pending_findings(src)
     unknown = [Finding(p, 0, 'words-unknown-file') for p in src.paths
                if p.startswith((WORDS_ASSETS, WORDS_LIB)) and p not in KNOWN]
     if findings:
         return findings + unknown + design, []
     try:
-        outputs = wordsgen.generate(src.read(CSV), src.read(LISTS))
+        pending = src.read(PENDING_CSV) if src.has(PENDING_CSV) else None
+        outputs = wordsgen.generate(src.read(CSV), src.read(LISTS), pending)
     except wordsgen.WordsError as e:
-        where = CSV if e.source == wordsgen.REGISTER else LISTS
-        return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown + design, []
+        return [Finding(WHERE[e.source], e.row, 'generator-refused:' + e.code)] + unknown + design, []
     for path in GENERATED:
         if not src.has(path):
             findings.append(Finding(path, 0, 'generated-missing'))
diff --git a/tool/checks/g2_copies.py b/tool/checks/g2_copies.py
index 3f274bd..3be38a0 100644
--- a/tool/checks/g2_copies.py
+++ b/tool/checks/g2_copies.py
@@ -5,17 +5,13 @@
 # a folder named restricted (D32 Q18): those never leave the documents.
 # The fonts (D49 a), armed or not: every file in the fonts folder is
 # listed in its fingerprints file with its sha256, and matches it.
-import re
-
-from guardlib import (CSV, FINGERPRINTS, FONTS, LISTS, MARKER, SOURCES, Finding, parse_sources,
-                      sha256)
+from guardlib import (CSV, FINGERPRINT, FINGERPRINTS, FONTS, LISTS, MARKER, SOURCES, Finding,
+                      parse_sources, sha256)
 
 CODE = 'G2'
 NAME = 'copies'
 DIR = 'docs/source/'
 REFUSED_NAMES = ('privacy-ethics-safety.md',)
-# shasum -a 256's own line: the digest, two spaces, a plain file name.
-FINGERPRINT = re.compile(r'^([0-9a-f]{64})  ([A-Za-z0-9._-]+)$')
 
 
 def refused_document(path):
diff --git a/tool/checks/guardlib.py b/tool/checks/guardlib.py
index 4240db7..96dbda2 100644
--- a/tool/checks/guardlib.py
+++ b/tool/checks/guardlib.py
@@ -22,7 +22,14 @@ LIST_WORDS = 'app/lib/words/lists.g.dart'
 WORDS_XCCONFIG = 'app/ios/Flutter/words.g.xcconfig'
 STRINGS_EN = 'app/ios/Runner/en.lproj/InfoPlist.strings'
 STRINGS_SV = 'app/ios/Runner/sv.lproj/InfoPlist.strings'
-GENERATED = (LINES, LIST_WORDS, WORDS_XCCONFIG, STRINGS_EN, STRINGS_SV)
+# The pending lines (D57 Q11, D58 Q11): given and approved, not yet filed.
+# The owner writes the file and its fingerprint; never Claude Code.
+PENDING_CSV = 'app/assets/words/pending-lines.csv'
+PENDING_FINGERPRINT = 'app/assets/words/pending-fingerprint.txt'
+PENDING_DART = 'app/lib/words/pending.g.dart'
+GENERATED = (LINES, LIST_WORDS, WORDS_XCCONFIG, STRINGS_EN, STRINGS_SV, PENDING_DART)
+# shasum -a 256's own line: the digest, two spaces, a plain file name.
+FINGERPRINT = re.compile(r'^([0-9a-f]{64})  ([A-Za-z0-9._-]+)$')
 # The design values (D49 a): designgen makes TOKENS from DESIGN, and G1
 # proves it.
 DESIGN = 'docs/source/design-system.md'
diff --git a/tool/checks/tests/mutations.py b/tool/checks/tests/mutations.py
index 69f76dc..3cb1feb 100644
--- a/tool/checks/tests/mutations.py
+++ b/tool/checks/tests/mutations.py
@@ -142,12 +142,12 @@ MUTATIONS = [
      ['test_g1_g2.G1.test_generated_differs_refuses']),
     ('g1_words.py', "and p not in KNOWN]", "and False]",
      ['test_g1_g2.G1.test_unknown_words_file_refuses']),
-    ('g1_words.py', "return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown + design, []",
+    ('g1_words.py', "return [Finding(WHERE[e.source], e.row, 'generator-refused:' + e.code)] + unknown + design, []",
      "outputs = {}",
      ['test_g1_g2.G1.test_generator_refusal_refuses']),
     ('g2_copies.py', "REFUSED_NAMES = ('privacy-ethics-safety.md',)", "REFUSED_NAMES = ()",
      ['test_g1_g2.G2.test_refused_documents_refused']),
-    ('g0_kinds.py', ", STRINGS_EN, STRINGS_SV)\n", ")\n",
+    ('g0_kinds.py', ", STRINGS_EN, STRINGS_SV, PENDING", ", PENDING",
      ['test_g0.G0.test_generated_strings_pass']),
     ('g4_invented.py', "\n            or path in GENERATED)", ")",
      ['test_g4.G4.test_generated_words_pass']),
@@ -162,9 +162,11 @@ MUTATIONS = [
      ['test_import.Import.test_copy_destinations_must_fit_their_kind']),
     ('importer.py', "sys.exit(2)", "sys.exit(1)",
      ['test_import.Import.test_internal_error_exits_two_and_prints_no_content']),
-    ('wordsgen.py', "    except csv.Error:", "    except KeyError:",
+    ('wordsgen.py', "    except csv.Error:\n        raise WordsError(REGISTER, 'bad-csv'",
+     "    except KeyError:\n        raise WordsError(REGISTER, 'bad-csv'",
      ['test_wordsgen.Generator.test_bad_csv_and_missing_inputs_stop']),
-    ('wordsgen.py', "    if data is None:", "    if False:",
+    ('wordsgen.py', "    if data is None:\n        raise WordsError(source, 'missing'",
+     "    if False:\n        raise WordsError(source, 'missing'",
      ['test_wordsgen.Generator.test_bad_csv_and_missing_inputs_stop']),
     ('wordsgen.py', "or os.path.islink(full):", "or False:",
      ['test_wordsgen.Command.test_symlinked_input_is_treated_as_missing']),
@@ -199,6 +201,17 @@ MUTATIONS = [
     ('designgen.py', "    return doc + [",
      "    doc.append(comment('Noted: ' + '; '.join(notes) + '.'))\n    return doc + [",
      ['test_designgen.Generate.test_every_role_comment_is_a_role_name_only']),
+    # journal-screens, Task 2 (D57 Q11): the pending lines.
+    ('g1_words.py', "    findings += pending_findings(src)\n", "",
+     ['test_g1_g2.G1.test_pending_lines_need_their_fingerprint']),
+    ('g1_words.py', "if sha256(src.read(PENDING_CSV)) != m.group(1):", "if False:",
+     ['test_g1_g2.G1.test_pending_fingerprint_must_match']),
+    ('g0_kinds.py', ", STRINGS_SV, PENDING_FINGERPRINT)", ", STRINGS_SV)",
+     ['test_g0.G0.test_pending_fingerprint_known_by_path_only']),
+    ('wordsgen.py', "        if handle in filed:", "        if False:",
+     ['test_wordsgen.Pending.test_a_filed_handle_stops']),
+    ('wordsgen.py', "        if f['status'] != PENDING_STATUS:", "        if False:",
+     ['test_wordsgen.Pending.test_each_row_rule_stops']),
 ]
 
 
diff --git a/tool/checks/tests/test_g0.py b/tool/checks/tests/test_g0.py
index 99274f4..4c308c0 100644
--- a/tool/checks/tests/test_g0.py
+++ b/tool/checks/tests/test_g0.py
@@ -14,6 +14,13 @@ class G0(GuardTest):
         self.refused({'app/assets/fonts/sub/OFL.txt': 'x\n'}, 'unknown-kind')
         self.refused({'app/assets/fonts/OFL.txt': b'\xff\xfe'}, 'unknown-kind')
 
+    # D57 Q11: the pending lines' fingerprint, by exact path only.
+    def test_pending_fingerprint_known_by_path_only(self):
+        self.passed({'app/assets/words/pending-fingerprint.txt': 'x\n',
+                     'app/assets/words/pending-lines.csv': 'x\n'})
+        self.refused({'app/assets/words/other.txt': 'x\n'}, 'unknown-kind')
+        self.refused({'app/assets/words/pending-fingerprint.txt': b'\xff\xfe'}, 'unknown-kind')
+
     def test_a_font_is_binary(self):
         self.passed({'app/assets/fonts/A-Regular.ttf': b'\x00\x01font'})
 
diff --git a/tool/checks/tests/test_g1_g2.py b/tool/checks/tests/test_g1_g2.py
index 27105bd..9bd40ae 100644
--- a/tool/checks/tests/test_g1_g2.py
+++ b/tool/checks/tests/test_g1_g2.py
@@ -8,7 +8,8 @@ import designgen
 import test_designgen as invented_design
 import test_wordsgen as invented
 import wordsgen
-from guardlib import DESIGN, GENERATED, LINES, TOKENS, WORDS_XCCONFIG
+from guardlib import (DESIGN, GENERATED, LINES, PENDING_CSV, PENDING_DART, PENDING_FINGERPRINT,
+                      TOKENS, WORDS_XCCONFIG)
 
 MARKER = 'tool/checks/awaiting-import'
 SOURCES = 'docs/source/SOURCES'
@@ -128,6 +129,47 @@ class G1(GuardTest):
         self.assertIn((TOKENS, 0, 'generated-missing'), found)
 
 
+    # D57 Q11: the pending lines and their fingerprint.
+    def pending_tree(self, body=None, fingerprint=None, made=True):
+        files = armed()
+        body = body if body is not None else invented.pending(invented.pending_row('MP' + invented.DOT + '60'))
+        files[PENDING_CSV] = body
+        files[PENDING_FINGERPRINT] = (fingerprint if fingerprint is not None else
+                                      hashlib.sha256(body).hexdigest() + '  pending-lines.csv\n')
+        if made:
+            files[PENDING_DART] = wordsgen.generate(files[CSV], files[LISTS], body)[PENDING_DART]
+        return files
+
+    def test_pending_lines_with_their_fingerprint_pass(self):
+        self.passed(self.pending_tree())
+
+    def test_pending_lines_need_their_fingerprint(self):
+        files = self.pending_tree()
+        del files[PENDING_FINGERPRINT]
+        self.assertEqual(self.refused(files), [(PENDING_CSV, 0, 'pending-unfingerprinted')])
+        files = self.pending_tree()
+        del files[PENDING_CSV]
+        self.assertEqual(self.refused(files), [(PENDING_FINGERPRINT, 0, 'pending-missing')])
+
+    def test_pending_fingerprint_must_match(self):
+        files = self.pending_tree()
+        files[PENDING_CSV] = files[PENDING_CSV] + b'MP' + invented.DOT.encode() + b'61,p,pending,a,b,c\n'
+        self.assertEqual(self.refused(files), [(PENDING_CSV, 0, 'hash-mismatch')])
+        for bad in ('', 'x\n', '0' * 64 + '  other.csv\n', '0' * 64 + '  pending-lines.csv'):
+            self.assertEqual(self.refused(self.pending_tree(fingerprint=bad)),
+                             [(PENDING_FINGERPRINT, 1, 'fingerprint-malformed')])
+
+    def test_pending_dart_must_be_generated(self):
+        files = self.pending_tree()
+        files[PENDING_DART] = wordsgen.generate(files[CSV], files[LISTS])[PENDING_DART]
+        self.assertEqual(self.refused(files), [(PENDING_DART, 0, 'generated-differs')])
+
+    def test_pending_refusal_names_the_pending_file(self):
+        body = invented.pending(invented.pending_row('MP' + invented.DOT + '55'))
+        files = self.pending_tree(body, made=False)
+        self.assertEqual(self.refused(files), [(PENDING_CSV, 2, 'generator-refused:pending-filed')])
+
+
 class G2(GuardTest):
     guard = g2_copies
 
diff --git a/tool/checks/tests/test_wordsgen.py b/tool/checks/tests/test_wordsgen.py
index d403b99..831cafb 100644
--- a/tool/checks/tests/test_wordsgen.py
+++ b/tool/checks/tests/test_wordsgen.py
@@ -12,7 +12,7 @@ import unittest
 import helpers  # noqa: F401  (puts tool/checks on the path)
 import wordsgen
 from guardlib import CSV, GENERATED, LINES, LIST_WORDS, LISTS, STRINGS_EN, STRINGS_SV
-from guardlib import WORDS_XCCONFIG
+from guardlib import PENDING_CSV, PENDING_DART, WORDS_XCCONFIG
 
 DOT = '·'
 PILCROW = '¶'
@@ -65,10 +65,74 @@ def gen(*rows):
     return wordsgen.generate(register(*rows), lists())
 
 
+def pending_row(handle, en='pa', sv='pb', status='pending', given='a message'):
+    return [handle, 'a place', status, en, sv, given]
+
+
+def pending(*rows, header=None):
+    out = io.StringIO(newline='')
+    w = csv.writer(out, lineterminator='\n')
+    w.writerow(header or wordsgen.PENDING_HEADER)
+    for r in rows:
+        w.writerow(r)
+    return out.getvalue().encode('utf-8')
+
+
+def pending_dart(pending_bytes, *rows):
+    return wordsgen.generate(register(*rows), lists(), pending_bytes)[PENDING_DART].decode('utf-8')
+
+
 def lines(*rows):
     return gen(*rows)[LINES].decode('utf-8')
 
 
+class Pending(unittest.TestCase):
+    # D57 Q11, D58 Q11: lines given and approved, not yet filed.
+    def refused(self, code, pending_bytes, *rows):
+        with self.assertRaises(wordsgen.WordsError) as cm:
+            wordsgen.generate(register(*rows), lists(), pending_bytes)
+        self.assertEqual((cm.exception.source, cm.exception.code), ('pending', code))
+        return cm.exception
+
+    def test_no_pending_file_makes_an_empty_class(self):
+        dart = pending_dart(None)
+        self.assertIn('(sha256 none)', dart)
+        self.assertIn('final class PendingLine {', dart)
+        self.assertIn('  static const all = <PendingLine>[];\n}\n', dart)
+
+    def test_pending_lines_are_their_own_type(self):
+        body = pending(pending_row('MP' + DOT + '60', 'pa / pc', 'pb / pd'))
+        dart = pending_dart(body)
+        self.assertIn("  static const MP_60 = PendingLine('MP" + DOT + "60', ['pa', 'pc'], ['pb', 'pd']);",
+                      dart)
+        self.assertIn('  static const all = <PendingLine>[MP_60];', dart)
+        self.assertIn("    if (flavor != 'dev') return ['[$handle]'];", dart)
+        self.assertIn('(sha256 %s)' % wordsgen.sha256(body), dart)
+        self.assertNotIn('Line(', dart.replace('PendingLine(', ''))
+
+    def test_a_filed_handle_stops(self):
+        filed = row('MP' + DOT + '60', 'written', 'w', 'v')
+        e = self.refused('pending-filed', pending(pending_row('MP' + DOT + '60')), filed)
+        self.assertEqual(e.row, 2)
+        retired = row('MP' + DOT + '61', 'retired')
+        self.refused('pending-filed', pending(pending_row('MP' + DOT + '61')), retired)
+
+    def test_each_row_rule_stops(self):
+        h = 'MP' + DOT + '60'
+        self.refused('bad-header', pending(header=('handle', 'english')))
+        self.refused('bad-row', pending(pending_row(h)[:-1]))
+        self.refused('bad-handle', pending(pending_row('mp60')))
+        self.refused('repeated-handle', pending(pending_row(h), pending_row(h)))
+        self.refused('dart-name-clash', pending(pending_row('MP-60')), row('MP' + DOT + '60', 'retired'))
+        self.refused('pending-status', pending(pending_row(h, status='written')))
+        self.refused('pending-given', pending(pending_row(h, given=' ')))
+        self.refused('missing-language', pending(pending_row(h, sv='')))
+        self.refused('parts-differ', pending(pending_row(h, 'pa / pc', 'pb')))
+        self.refused('pending-slot', pending(pending_row(h, '{n} pa', '{n} pb')))
+        self.refused('control-character', pending(pending_row(h, 'p\ta')))
+        self.refused('bad-csv', b'handle,"place\n')
+
+
 class Generator(unittest.TestCase):
     def refused(self, code, csv_bytes=None, lists_bytes=None):
         with self.assertRaises(wordsgen.WordsError) as cm:
@@ -361,6 +425,18 @@ class Command(unittest.TestCase):
         os.symlink(real, path)
         self.assertEqual(self.run_gen('--check'), (1, 'wordsgen: refused register missing row 0\n'))
 
+    def test_pending_file_is_read_from_root(self):
+        with open(os.path.join(self.root, PENDING_CSV), 'wb') as f:
+            f.write(pending(pending_row('MP' + DOT + '60')))
+        rc, out = self.run_gen('--write')
+        self.assertEqual(rc, 0, out)
+        self.assertIn('wordsgen: pending lines 1', out)
+        with open(os.path.join(self.root, PENDING_DART), 'rb') as f:
+            self.assertIn(b'static const MP_60 = PendingLine(', f.read())
+        with open(os.path.join(self.root, PENDING_CSV), 'wb') as f:
+            f.write(pending(pending_row('MP' + DOT + '60', status='filed')))
+        self.assertEqual(self.run_gen('--check'), (1, 'wordsgen: refused pending pending-status row 2\n'))
+
     def test_usage(self):
         self.assertEqual(self.run_gen()[0], 1)
         self.assertEqual(self.run_gen('--write', '--check')[0], 1)
diff --git a/tool/checks/wordsgen.py b/tool/checks/wordsgen.py
index 2e19069..759a8d8 100644
--- a/tool/checks/wordsgen.py
+++ b/tool/checks/wordsgen.py
@@ -1,7 +1,8 @@
 # The words generator (R1; D32, D36). From the places register and the
 # founder's lists to the app's words: lines.g.dart, lists.g.dart, and
-# the iOS home-screen name and microphone text. A pure function of the
-# two files' bytes, so G1 can run it again and compare. It stops on
+# the iOS home-screen name and microphone text; and from the owner's
+# pending lines, if any, pending.g.dart (D57 Q11). A pure function of
+# the files' bytes, so G1 can run it again and compare. It stops on
 # anything it does not expect, with a reason code and a row number,
 # never a file's content.
 # Usage: wordsgen.py --write           write the five files (the owner)
@@ -20,8 +21,8 @@ HERE = os.path.dirname(os.path.abspath(__file__))
 TOP = os.path.dirname(os.path.dirname(HERE))
 sys.path.insert(0, HERE)
 
-from guardlib import (CSV, GENERATED, LINES, LIST_WORDS, LISTS, STRINGS_EN,  # noqa: E402
-                      STRINGS_SV, WORDS_XCCONFIG, report, sha256)
+from guardlib import (CSV, GENERATED, LINES, LIST_WORDS, LISTS, PENDING_CSV,  # noqa: E402
+                      PENDING_DART, STRINGS_EN, STRINGS_SV, WORDS_XCCONFIG, report, sha256)
 
 HEADER = ('handle', 'place', 'source', 'screen', 'also_on', 'moment', 'must', 'never',
           'length', 'status', 'draft', 'english', 'swedish', 'flag')
@@ -48,6 +49,14 @@ TECH = tuple('TECH·%d' % n for n in range(1, 6))
 LIST_HEADING = re.compile(r'^## (TECH·[1-5]) — \S')
 REGISTER = 'register'
 LIST_FILE = 'lists'
+# The pending lines (D57 Q11; D58 Q11): lines given and approved but not
+# yet filed in the register. Shown in SoulDreams Dev only, never as a
+# filed line (pending.g.dart's PendingLine). A row whose handle the
+# register already holds stops the generator, so a filed place retires
+# its pending row.
+PENDING = 'pending'
+PENDING_HEADER = ('handle', 'place', 'status', 'english', 'swedish', 'given')
+PENDING_STATUS = 'pending'
 
 
 class WordsError(Exception):
@@ -140,15 +149,15 @@ def read_register(data):
     return out
 
 
-def parse_text(text, row):
+def parse_text(text, row, source=REGISTER):
     # " / " separates parts; a pilcrow separates paragraphs (D32 Q11, Q12).
     if has_control(text):
-        raise WordsError(REGISTER, 'control-character', row)
+        raise WordsError(source, 'control-character', row)
     parts = []
     for part in text.strip().split(' / '):
         paragraphs = [p.strip() for p in part.split('¶')]
         if not all(paragraphs):
-            raise WordsError(REGISTER, 'empty-part', row)
+            raise WordsError(source, 'empty-part', row)
         parts.append('\n\n'.join(paragraphs))
     return parts
 
@@ -197,6 +206,105 @@ def places_of(rows):
     return out
 
 
+def read_pending(data, register_rows):
+    # None (no file) is no pending line. Each row: a handle of the
+    # register's shape that the register does not hold, the status
+    # "pending", where it was given, and one plain line in each language,
+    # with the same number of parts and no slot.
+    if data is None:
+        return []
+    text = decode(data, PENDING)
+    reader = csv.reader(io.StringIO(text, newline=''), strict=True)
+    try:
+        rows = list(reader)
+    except csv.Error:
+        raise WordsError(PENDING, 'bad-csv', reader.line_num)
+    if not rows or tuple(rows[0]) != PENDING_HEADER:
+        raise WordsError(PENDING, 'bad-header', 1)
+    filed = set(r[1] for r in register_rows)
+    names = set(ident(h) for h in filed)
+    seen = set()
+    out = []
+    for n, r in enumerate(rows[1:], 2):
+        if len(r) != len(PENDING_HEADER):
+            raise WordsError(PENDING, 'bad-row', n)
+        f = dict(zip(PENDING_HEADER, r))
+        handle = f['handle']
+        if not HANDLE.match(handle):
+            raise WordsError(PENDING, 'bad-handle', n)
+        if handle in seen:
+            raise WordsError(PENDING, 'repeated-handle', n)
+        if handle in filed:
+            raise WordsError(PENDING, 'pending-filed', n)
+        if ident(handle) in names:
+            raise WordsError(PENDING, 'dart-name-clash', n)
+        if f['status'] != PENDING_STATUS:
+            raise WordsError(PENDING, 'pending-status', n)
+        if not f['given'].strip() or has_control(f['given']):
+            raise WordsError(PENDING, 'pending-given', n)
+        if not f['english'].strip() or not f['swedish'].strip():
+            raise WordsError(PENDING, 'missing-language', n)
+        en, sv = parse_text(f['english'], n, PENDING), parse_text(f['swedish'], n, PENDING)
+        if len(en) != len(sv):
+            raise WordsError(PENDING, 'parts-differ', n)
+        if any('{' in p or '}' in p for p in en + sv):
+            raise WordsError(PENDING, 'pending-slot', n)
+        seen.add(handle)
+        names.add(ident(handle))
+        out.append((handle, en, sv))
+    return out
+
+
+PENDING_HEAD = ''.join(line + '\n' for line in (
+    '// GENERATED by tool/checks/wordsgen.py from the pending lines',
+    '// (sha256 @SHA@). Do not edit: the owner changes pending-lines.csv.',
+    '// ignore_for_file: constant_identifier_names',
+    "import 'package:flutter/services.dart' show appFlavor;",
+    '',
+    "import 'lines.g.dart' show Lang;",
+    '',
+    '/// A line given and approved, not yet filed',
+    '/// in the register (D57 Q11). Not a [Line]:',
+    '/// it cannot stand where a filed line is asked.',
+    '/// Its words show in SoulDreams Dev only;',
+    '/// other builds show its handle (R1).',
+    'final class PendingLine {',
+    '  const PendingLine(this.handle, this._en, this._sv);',
+    '',
+    '  final String handle;',
+    '  final List<String> _en;',
+    '  final List<String> _sv;',
+    '',
+    '  /// The parts, in SoulDreams Dev only.',
+    '  List<String> parts(Lang lang, {String? flavor = appFlavor}) {',
+    "    if (flavor != 'dev') return ['[$handle]'];",
+    '    return lang == Lang.en ? _en : _sv;',
+    '  }',
+    '',
+    '  /// A line of one part.',
+    '  String text(Lang lang, {String? flavor = appFlavor}) {',
+    '    final all = parts(lang, flavor: flavor);',
+    "    assert(all.length == 1, 'text() needs a line of one part');",
+    '    return all.single;',
+    '  }',
+    '}',
+    '',
+    '/// Every pending line, by handle.',
+    'abstract final class PendingLines {',
+))
+
+
+def pending_dart(pending, digest):
+    out = [PENDING_HEAD.replace('@SHA@', digest)]
+    for handle, en, sv in pending:
+        out.append('  static const %s = PendingLine(%s, %s, %s);\n'
+                   % (ident(handle), dart_string(handle), dart_list(en), dart_list(sv)))
+    out.append('\n  /// Every pending line above, in the file\'s order.\n')
+    out.append('  static const all = <PendingLine>[%s];\n}\n'
+               % ', '.join(ident(h) for h, _, _ in pending))
+    return ''.join(out)
+
+
 def item_like(line):
     # D38: a line that looks like a list item. A dash-led line is one
     # unless it is a rule of three dashes or more; "*" and "+" count only
@@ -389,9 +497,11 @@ def strings_file(text, digest):
             '"NSMicrophoneUsageDescription" = "%s";\n' % (digest, value))
 
 
-def generate(csv_bytes, lists_bytes):
+def generate(csv_bytes, lists_bytes, pending_bytes=None):
     # {repository path: bytes} for every path in guardlib.GENERATED.
-    places = places_of(read_register(csv_bytes))
+    rows = read_register(csv_bytes)
+    places = places_of(rows)
+    pending = read_pending(pending_bytes, rows)
     sections = read_lists(lists_bytes)
     digest = sha256(csv_bytes)
     name_en, name_sv, row = one_line(places, APP_NAME)
@@ -410,20 +520,24 @@ def generate(csv_bytes, lists_bytes):
         WORDS_XCCONFIG: xcconfig,
         STRINGS_EN: strings_file(mic_en, digest),
         STRINGS_SV: strings_file(mic_sv, digest),
+        PENDING_DART: pending_dart(pending, 'none' if pending_bytes is None
+                                   else sha256(pending_bytes)),
     }
     assert tuple(sorted(out)) == tuple(sorted(GENERATED))
     return {path: text.encode('utf-8') for path, text in out.items()}
 
 
-def summary(csv_bytes, lists_bytes):
+def summary(csv_bytes, lists_bytes, pending_bytes=None):
     counts = {}
-    for _, _, status, _, _ in read_register(csv_bytes):
+    rows = read_register(csv_bytes)
+    for _, _, status, _, _ in rows:
         counts[label(status)] = counts.get(label(status), 0) + 1
     lines = ['wordsgen: rows %d' % sum(counts.values())]
     for name in sorted(counts):
         lines.append('wordsgen: status "%s" %d' % (name, counts[name]))
     words = sum(len(en) + len(sv) for _, en, sv in read_lists(lists_bytes))
     lines.append('wordsgen: list words %d' % words)
+    lines.append('wordsgen: pending lines %d' % len(read_pending(pending_bytes, rows)))
     return lines
 
 
@@ -453,12 +567,13 @@ def write_atomic(root, path, data):
 def write_all(root, out):
     # Generates from root's inputs and writes into out. Raises WordsError.
     csv_bytes, lists_bytes = read(root, CSV), read(root, LISTS)
-    outputs = generate(csv_bytes, lists_bytes)
+    pending_bytes = read(root, PENDING_CSV)
+    outputs = generate(csv_bytes, lists_bytes, pending_bytes)
     for path in GENERATED:
         if read(out, path) != outputs[path]:
             write_atomic(out, path, outputs[path])
             report('wordsgen: wrote ' + path)
-    for line in summary(csv_bytes, lists_bytes):
+    for line in summary(csv_bytes, lists_bytes, pending_bytes):
         report(line)
 
 
@@ -485,7 +600,7 @@ def main(argv):
         if mode == '--write':
             write_all(root, out)
             return 0
-        outputs = generate(read(root, CSV), read(root, LISTS))
+        outputs = generate(read(root, CSV), read(root, LISTS), read(root, PENDING_CSV))
     except WordsError as e:
         report('wordsgen: refused %s %s row %d' % (e.source, e.code, e.row))
         return 1
~~~~

### Task 3 · The screenshots' folder: G0 and G2 (D58)

G2's fonts check becomes `fingerprint_findings`, which runs for the fonts (codes unchanged) and for
`docs/reference/screens/` (`screen-unlisted`, `screen-hash-mismatch`, `screen-missing`, `no-fingerprints`). G0 knows
`docs/reference/screens/fingerprints.txt` by exact path. A screenshot is binary, which G0 already knows.

Two new mutation rows (86, 87); row 83 follows the import line.

Stage, then check. Expected:
- `Ran 241 tests`, `OK`;
- `mutations: 87 run, all caught`.

Commit:

> Guards: the screenshots' folder, docs/reference/screens/, fingerprinted as the fonts are (D58)

**The block** (from the proof's `18b7aa0`):

~~~~diff
diff --git a/tool/checks/g0_kinds.py b/tool/checks/g0_kinds.py
index fa3eb8d..f1a3922 100644
--- a/tool/checks/g0_kinds.py
+++ b/tool/checks/g0_kinds.py
@@ -6,11 +6,12 @@
 # unknown-kind. A branch that brings a new kind of file extends these
 # lists, and the owner approves the change at the prompt. D49 a: .txt is
 # known in the fonts folder only (the licences and the fingerprints);
-# D57 Q11: and the pending lines' fingerprint, by exact path.
+# D57 Q11: and the pending lines' fingerprint, by exact path; D58: and
+# the screenshots' fingerprints, by exact path.
 import posixpath
 
-from guardlib import (FONTS, LOCKFILES, MARKER, PENDING_FINGERPRINT, SOURCES, STRINGS_EN,
-                      STRINGS_SV, Finding)
+from guardlib import (FONTS, LOCKFILES, MARKER, PENDING_FINGERPRINT, SCREEN_PRINTS, SOURCES,
+                      STRINGS_EN, STRINGS_SV, Finding)
 
 CODE = 'G0'
 NAME = 'file kinds'
@@ -18,7 +19,8 @@ UNSCANNED_EXT = ('.md', '.csv')
 UNSCANNED_NAMES = ('.gitignore',) + LOCKFILES
 # The two generated InfoPlist.strings, by exact path: G1 proves them (D32).
 # The pending lines' fingerprint, by exact path: G1 proves it (D57 Q11).
-UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV, PENDING_FINGERPRINT)
+# The screenshots' fingerprints, by exact path: G2 proves them (D58).
+UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV, PENDING_FINGERPRINT, SCREEN_PRINTS)
 
 
 def known(src, path):
diff --git a/tool/checks/g2_copies.py b/tool/checks/g2_copies.py
index 3be38a0..d274e7d 100644
--- a/tool/checks/g2_copies.py
+++ b/tool/checks/g2_copies.py
@@ -3,10 +3,11 @@
 # exists; refuses the marker beside any file in docs/source/. Armed or
 # not, no tracked path anywhere may be privacy-ethics-safety.md or sit in
 # a folder named restricted (D32 Q18): those never leave the documents.
-# The fonts (D49 a), armed or not: every file in the fonts folder is
-# listed in its fingerprints file with its sha256, and matches it.
-from guardlib import (CSV, FINGERPRINT, FINGERPRINTS, FONTS, LISTS, MARKER, SOURCES, Finding,
-                      parse_sources, sha256)
+# The fonts (D49 a) and the screenshots (D58), armed or not: every file
+# in each folder is listed in its fingerprints file with its sha256, and
+# matches it.
+from guardlib import (CSV, FINGERPRINT, FINGERPRINTS, FONTS, LISTS, MARKER, SCREEN_PRINTS,
+                      SCREENS, SOURCES, Finding, parse_sources, sha256)
 
 CODE = 'G2'
 NAME = 'copies'
@@ -19,34 +20,39 @@ def refused_document(path):
     return parts[-1] in REFUSED_NAMES or 'restricted' in parts[:-1]
 
 
-def font_findings(src):
-    fonts = [p for p in src.paths if p.startswith(FONTS) and p != FINGERPRINTS]
-    if not src.has(FINGERPRINTS):
-        return [Finding(FINGERPRINTS, 0, 'no-fingerprints')] if fonts else []
+def fingerprint_findings(src, folder, prints, what):
+    files = [p for p in src.paths if p.startswith(folder) and p != prints]
+    if not src.has(prints):
+        return [Finding(prints, 0, 'no-fingerprints')] if files else []
     listed = {}
     findings = []
-    for n, line in enumerate((src.text(FINGERPRINTS) or '').split('\n'), 1):
+    for n, line in enumerate((src.text(prints) or '').split('\n'), 1):
         if not line:
             continue
         m = FINGERPRINT.match(line)
-        if not m or FONTS + m.group(2) in listed:
-            findings.append(Finding(FINGERPRINTS, n, 'fingerprints-malformed'))
+        if not m or folder + m.group(2) in listed:
+            findings.append(Finding(prints, n, 'fingerprints-malformed'))
             continue
-        listed[FONTS + m.group(2)] = m.group(1)
-    for path in fonts:
+        listed[folder + m.group(2)] = m.group(1)
+    for path in files:
         if path not in listed:
-            findings.append(Finding(path, 0, 'font-unlisted'))
+            findings.append(Finding(path, 0, what + '-unlisted'))
         elif sha256(src.read(path) or b'') != listed[path]:
-            findings.append(Finding(path, 0, 'font-hash-mismatch'))
+            findings.append(Finding(path, 0, what + '-hash-mismatch'))
     for path in sorted(listed):
         if not src.has(path):
-            findings.append(Finding(path, 0, 'font-missing'))
+            findings.append(Finding(path, 0, what + '-missing'))
     return findings
 
 
+def font_findings(src):
+    return fingerprint_findings(src, FONTS, FINGERPRINTS, 'font')
+
+
 def check(src):
     refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
     refused += font_findings(src)
+    refused += fingerprint_findings(src, SCREENS, SCREEN_PRINTS, 'screen')
     in_dir = [p for p in src.paths if p.startswith(DIR)]
     if src.has(MARKER):
         if in_dir:
diff --git a/tool/checks/guardlib.py b/tool/checks/guardlib.py
index 96dbda2..9925cc8 100644
--- a/tool/checks/guardlib.py
+++ b/tool/checks/guardlib.py
@@ -38,6 +38,11 @@ TOKENS = 'app/lib/design/tokens.g.dart'
 # sha256, which G2 proves; G0 knows .txt files here only.
 FONTS = 'app/assets/fonts/'
 FINGERPRINTS = 'app/assets/fonts/fingerprints.txt'
+# The founder's screenshots, a design reference only (D56; D58): every
+# file here is listed in SCREEN_PRINTS with its sha256, which G2 proves;
+# G0 knows that one .txt file here. No word is ever taken from them.
+SCREENS = 'docs/reference/screens/'
+SCREEN_PRINTS = 'docs/reference/screens/fingerprints.txt'
 
 CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.mjs': 'ts', '.cjs': 'ts',
             '.swift': 'swift', '.py': 'py', '.sh': 'sh'}
diff --git a/tool/checks/tests/mutations.py b/tool/checks/tests/mutations.py
index 3cb1feb..682fd8e 100644
--- a/tool/checks/tests/mutations.py
+++ b/tool/checks/tests/mutations.py
@@ -206,12 +206,17 @@ MUTATIONS = [
      ['test_g1_g2.G1.test_pending_lines_need_their_fingerprint']),
     ('g1_words.py', "if sha256(src.read(PENDING_CSV)) != m.group(1):", "if False:",
      ['test_g1_g2.G1.test_pending_fingerprint_must_match']),
-    ('g0_kinds.py', ", STRINGS_SV, PENDING_FINGERPRINT)", ", STRINGS_SV)",
+    ('g0_kinds.py', ", STRINGS_SV, PENDING_FINGERPRINT, SCREEN", ", STRINGS_SV, SCREEN",
      ['test_g0.G0.test_pending_fingerprint_known_by_path_only']),
     ('wordsgen.py', "        if handle in filed:", "        if False:",
      ['test_wordsgen.Pending.test_a_filed_handle_stops']),
     ('wordsgen.py', "        if f['status'] != PENDING_STATUS:", "        if False:",
      ['test_wordsgen.Pending.test_each_row_rule_stops']),
+    # journal-screens, Task 3 (D58): the screenshots.
+    ('g2_copies.py', "    refused += fingerprint_findings(src, SCREENS, SCREEN_PRINTS, 'screen')\n", "",
+     ['test_g1_g2.G2.test_screens_unlisted_changed_or_unprinted_refuse']),
+    ('g0_kinds.py', ", PENDING_FINGERPRINT, SCREEN_PRINTS)", ", PENDING_FINGERPRINT)",
+     ['test_g0.G0.test_screen_fingerprints_known_by_path_only']),
 ]
 
 
diff --git a/tool/checks/tests/test_g0.py b/tool/checks/tests/test_g0.py
index 4c308c0..13c8a80 100644
--- a/tool/checks/tests/test_g0.py
+++ b/tool/checks/tests/test_g0.py
@@ -21,6 +21,13 @@ class G0(GuardTest):
         self.refused({'app/assets/words/other.txt': 'x\n'}, 'unknown-kind')
         self.refused({'app/assets/words/pending-fingerprint.txt': b'\xff\xfe'}, 'unknown-kind')
 
+    # D58: the screenshots' fingerprints, by exact path; a screenshot is binary.
+    def test_screen_fingerprints_known_by_path_only(self):
+        self.passed({'docs/reference/screens/fingerprints.txt': 'x\n',
+                     'docs/reference/screens/journal.png': b'\x89PNG\0'})
+        self.refused({'docs/reference/screens/notes.txt': 'x\n'}, 'unknown-kind')
+        self.refused({'docs/reference/screens/journal.png': b'no nul byte'}, 'unknown-kind')
+
     def test_a_font_is_binary(self):
         self.passed({'app/assets/fonts/A-Regular.ttf': b'\x00\x01font'})
 
diff --git a/tool/checks/tests/test_g1_g2.py b/tool/checks/tests/test_g1_g2.py
index 9bd40ae..fe12bf1 100644
--- a/tool/checks/tests/test_g1_g2.py
+++ b/tool/checks/tests/test_g1_g2.py
@@ -251,6 +251,32 @@ class G2(GuardTest):
         del tree[FONTS_LIST]
         self.assertEqual(self.refused(tree), [(FONTS_LIST, 0, 'no-fingerprints')])
 
+    # D58: the screenshots, fingerprinted as the fonts are.
+    def screens(self, listed=None):
+        files = {'journal.png': b'\x89PNG\0a', 'night.png': b'\x89PNG\0b'}
+        listed = files if listed is None else listed
+        tree = {'docs/reference/screens/' + name: body for name, body in files.items()}
+        tree['docs/reference/screens/fingerprints.txt'] = ''.join(
+            hashlib.sha256(body).hexdigest() + '  ' + name + '\n' for name, body in listed.items())
+        tree.update({COPY: 'h\n', SOURCES: line(COPY, 'h\n')})
+        return tree
+
+    def test_screens_listed_pass(self):
+        self.passed(self.screens())
+
+    def test_screens_unlisted_changed_or_unprinted_refuse(self):
+        tree = self.screens(listed={'journal.png': b'\x89PNG\0a'})
+        self.assertEqual(self.refused(tree),
+                         [('docs/reference/screens/night.png', 0, 'screen-unlisted')])
+        tree = self.screens()
+        tree['docs/reference/screens/night.png'] = b'\x89PNG\0c'
+        self.assertEqual(self.refused(tree),
+                         [('docs/reference/screens/night.png', 0, 'screen-hash-mismatch')])
+        tree = self.screens()
+        del tree['docs/reference/screens/fingerprints.txt']
+        self.assertEqual(self.refused(tree),
+                         [('docs/reference/screens/fingerprints.txt', 0, 'no-fingerprints')])
+
     def test_fonts_checked_when_not_armed(self):
         tree = self.fonts()
         tree['app/assets/fonts/A-Regular.ttf'] = b'\x00b'
~~~~

### Task 4 · [OWNER] The pending lines MP·60 and MP·61, and the screenshots (D58 Q11)

**The pending lines.** Never typed by Claude Code; its settings refuse the folder. The owner writes
`app/assets/words/pending-lines.csv` in a text editor: UTF-8, LF line ends, no BOM.

- The header line, exactly: `handle,place,status,english,swedish,given`.
- Then one row per line, from the head's message 16 and D58 Q11:
  - `handle`: `MP·60` and `MP·61` (the middle dot, as in the register);
  - `place`: the owner's few words saying what it is;
  - `status`: exactly `pending`;
  - `english` and `swedish`: the approved words;
  - `given`: where they were given, for example `head's message 16, founder-approved`.
- A field holding a comma is put in double quotes.

Then, in the terminal:

Paste 3 — Terminal
```
cd ~/Developer/soul-dreams-app/app/assets/words && shasum -a 256 pending-lines.csv > pending-fingerprint.txt && cat pending-fingerprint.txt && cd ~/Developer/soul-dreams-app && python3 -I -B tool/checks/wordsgen.py --write | grep -E 'wrote|pending' && grep -c 'PendingLine(' app/lib/words/pending.g.dart
```

Expected:
- the fingerprint line, `<64 hex>  pending-lines.csv`;
- `wordsgen: wrote app/lib/words/pending.g.dart`;
- `wordsgen: pending lines 2`;
- `3` (the class's constructor and the two lines).

A refusal prints `wordsgen: refused pending <code> row <n>`. Fix that row and run Paste 3 again. Bring the
fingerprint line to the Build chat, which checks the file against message 16.

**The screenshots.** Invented content only (head's message 16), never from the Cohort 0 app. Copied from wherever
the owner keeps them, as PNG files with plain names (letters, digits, `.`, `_`, `-`):

Paste 4 — Terminal
```
cd ~/Developer/soul-dreams-app && mkdir -p docs/reference/screens && cp <the screenshots>.png docs/reference/screens/ && cd docs/reference/screens && shasum -a 256 *.png > fingerprints.txt && cat fingerprints.txt
```

Expected: one line per screenshot.

Then Claude Code:
- runs the guards (`python3 -I -B tool/checks/guards.py` after `git add -A`), expected `all passed`;
- runs the app's tests, expected 60;
- commits:

  > Words and screens: the pending lines MP·60 and MP·61, and the founder's screenshots (the owner's, D58)

Before any later task opens a screenshot, the owner has said each holds invented content only (R2).

### Task 5 · A night's closing instant, the 21:00 rules, the journal's operations

- `Night` gains `closes` (required, UTC, after `firstRecorded`), its file key, `withDreams`, and equality over it.
  `decodeNight` refuses a missing, local or too early `closes`.
- `night_rules.dart`:
  - the `Zone` interface and `PhoneZone`;
  - `closesAfter` (the first 21:00 strictly after) and `dateOf`;
  - `tonight` (the latest open night, D57 Q13);
  - `Target` (`IntoNight`, `NewNight`) and `targetAt`;
  - `isEmptyText`.
- `journal.dart`: `addDream` (an empty Save keeps nothing; a new night or a dream added), `editDream` (an emptied
  dream removed; a night left empty deleted), `delete`, and the first-use flag.
- The self-check and the fixtures' reader give `closes`; the store's tests use `withDreams`.
- Tests: a fake Stockholm zone table (`zones.dart`, D49 O9), `night_rules_test.dart` (8),
  `journal_test.dart` (7), and `night_test.dart` (+1).

Expected: 76 tests. Commit:

> Journal: a night's closing instant, the 21:00 rules and the journal's operations (D57 Q13, Q14; D58 Q2, Q3; P9, P10)

**The block** (from the proof's `0d41147`):

~~~~diff
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
new file mode 100644
index 0000000..1515101
--- /dev/null
+++ b/app/lib/journal/journal.dart
@@ -0,0 +1,89 @@
+// The journal's operations, on the store (D56; D58). Plain Dart: the
+// pages call these and decide nothing themselves.
+//
+// - A Save of new text makes a new dream (P2). The first Save makes the
+//   night, and an empty Save keeps nothing (P10).
+// - An edit replaces a dream's text. An emptied dream disappears and the
+//   night's other dreams remain (D58 Q3); a night left with no dream is
+//   deleted, as a deletion deletes it (P10).
+import 'dart:math';
+
+import '../words/lines.g.dart' show Lang;
+import 'journal_store.dart';
+import 'night.dart';
+import 'night_rules.dart';
+
+final class Journal {
+  Journal(this._store, {this.zone = const PhoneZone(), DateTime Function()? now, this.random})
+      : _now = now ?? (() => DateTime.now().toUtc());
+
+  final JournalStore _store;
+  final Zone zone;
+  final DateTime Function() _now;
+
+  /// The source of new nights' ids; the system's secure one when null.
+  final Random? random;
+
+  /// Now, in UTC.
+  DateTime now() => _now();
+
+  /// Every night, newest first recording first.
+  Future<List<Night>> newestFirst() async => (await _store.nights()).reversed.toList();
+
+  /// The night with [id], or null.
+  Future<Night?> night(String id) async {
+    for (final n in await _store.nights()) {
+      if (n.id == id) return n;
+    }
+    return null;
+  }
+
+  /// Where a typing screen opened now from the journal saves.
+  Future<Target> targetNow() async => targetAt(await _store.nights(), _now());
+
+  /// Saves [text] as a new dream at [target]. Returns whether anything
+  /// was kept.
+  Future<bool> addDream(Target target, String text, Lang lang) async {
+    if (isEmptyText(text)) return false;
+    switch (target) {
+      case NewNight(:final begun):
+        await _store.save(Night(
+          id: newNightId(random),
+          firstRecorded: begun,
+          date: dateOf(begun, zone),
+          closes: closesAfter(begun, zone),
+          lang: lang,
+          dreams: [text],
+        ));
+      case IntoNight(:final id):
+        final n = await night(id);
+        if (n == null) return false;
+        await _store.save(n.withDreams([...n.dreams, text]));
+    }
+    return true;
+  }
+
+  /// Replaces dream [index] of night [id] with [text].
+  Future<void> editDream(String id, int index, String text) async {
+    final n = await night(id);
+    if (n == null || index < 0 || index >= n.dreams.length) return;
+    final dreams = [...n.dreams];
+    if (isEmptyText(text)) {
+      dreams.removeAt(index);
+    } else {
+      dreams[index] = text;
+    }
+    if (dreams.isEmpty) {
+      await _store.delete(id);
+    } else {
+      await _store.save(n.withDreams(dreams));
+    }
+  }
+
+  /// Deletes the night, and everything of it (X11).
+  Future<void> delete(String id) => _store.delete(id);
+
+  Future<bool> firstUseSeen() => _store.firstUseSeen();
+
+  Future<void> markFirstUseSeen() => _store.markFirstUseSeen();
+}
diff --git a/app/lib/journal/night.dart b/app/lib/journal/night.dart
index 2c36002..3ec0da1 100644
--- a/app/lib/journal/night.dart
+++ b/app/lib/journal/night.dart
@@ -15,7 +15,7 @@ const formatVersion = 1;
 
 final _id = RegExp(r'^[0-9a-f]{32}$');
 final _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
-const _keys = {'version', 'id', 'firstRecorded', 'date', 'lang', 'name', 'dreams'};
+const _keys = {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'};
 
 /// A new night's id: 128 bits from the system's secure source, as 32 hex
 /// digits. It names a file on the phone and is never sent anywhere (R4).
@@ -41,6 +41,7 @@ final class Night {
     required this.id,
     required this.firstRecorded,
     required this.date,
+    required this.closes,
     required this.lang,
     this.name,
     required List<String> dreams,
@@ -48,6 +49,7 @@ final class Night {
     if (!_id.hasMatch(id)) throw ArgumentError('id');
     if (!firstRecorded.isUtc) throw ArgumentError('firstRecorded');
     if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');
+    if (!closes.isUtc || !closes.isAfter(firstRecorded)) throw ArgumentError('closes');
   }
 
   final String id;
@@ -58,6 +60,11 @@ final class Night {
   /// The phone's date at the first recording, kept so that it never moves.
   final NightDate date;
 
+  /// The first 21:00 after the first recording, in the zone in force at
+  /// that moment, in UTC (C152-I item 2; D58 Q2, P9). Fixed once: a later
+  /// change of zone or clock never moves it.
+  final DateTime closes;
+
   /// The language the night was recorded in.
   final Lang lang;
 
@@ -67,18 +74,23 @@ final class Night {
   /// The dreams, in the dreamer's words, in order.
   final List<String> dreams;
 
+  /// The same night holding [dreams] instead.
+  Night withDreams(List<String> dreams) => Night(
+      id: id, firstRecorded: firstRecorded, date: date, closes: closes, lang: lang, name: name, dreams: dreams);
+
   @override
   bool operator ==(Object other) =>
       other is Night &&
       other.id == id &&
       other.firstRecorded == firstRecorded &&
       other.date == date &&
+      other.closes == closes &&
       other.lang == lang &&
       other.name == name &&
       listEquals(other.dreams, dreams);
 
   @override
-  int get hashCode => Object.hash(id, firstRecorded, date, lang, name, Object.hashAll(dreams));
+  int get hashCode => Object.hash(id, firstRecorded, date, closes, lang, name, Object.hashAll(dreams));
 }
 
 String _two(int n) => n.toString().padLeft(2, '0');
@@ -89,6 +101,7 @@ Uint8List encodeNight(Night n) => utf8.encode(jsonEncode({
       'id': n.id,
       'firstRecorded': n.firstRecorded.toIso8601String(),
       'date': '${n.date.year.toString().padLeft(4, '0')}-${_two(n.date.month)}-${_two(n.date.day)}',
+      'closes': n.closes.toIso8601String(),
       'lang': n.lang.name,
       'name': n.name,
       'dreams': n.dreams,
@@ -110,14 +123,17 @@ Night? decodeNight(Uint8List bytes) {
         'id': final String id,
         'firstRecorded': final String recorded,
         'date': final String date,
+        'closes': final String closes,
         'lang': final String lang,
         'name': final String? name,
         'dreams': final List<Object?> dreams,
       }) {
     final at = DateTime.tryParse(recorded);
+    final shut = DateTime.tryParse(closes);
     final d = _date.firstMatch(date);
     final language = Lang.values.where((l) => l.name == lang).firstOrNull;
     if (!_id.hasMatch(id) || at == null || !at.isUtc || d == null || language == null) return null;
+    if (shut == null || !shut.isUtc || !shut.isAfter(at)) return null;
     final (y, m, day) = (int.parse(d[1]!), int.parse(d[2]!), int.parse(d[3]!));
     if (!_isDay(y, m, day)) return null;
     if (dreams.any((x) => x is! String)) return null;
@@ -125,6 +141,7 @@ Night? decodeNight(Uint8List bytes) {
       id: id,
       firstRecorded: at,
       date: (year: y, month: m, day: day),
+      closes: shut,
       lang: language,
       name: name,
       dreams: dreams.cast<String>(),
diff --git a/app/lib/journal/night_rules.dart b/app/lib/journal/night_rules.dart
new file mode 100644
index 0000000..d5f4f28
--- /dev/null
+++ b/app/lib/journal/night_rules.dart
@@ -0,0 +1,98 @@
+// What one night is (C152-I item 2; main-path.md, Recording, "Nights";
+// D58 Q2, P9, P10). A night closes at the first 21:00 after its first
+// recording, by the phone's local time in the zone in force at that
+// moment; the instant is kept, so a later change of zone or clock never
+// moves it, and the date shown never moves. Until a night closes, a new
+// dream joins it. Plain Dart, no screen: the clock and the zone are
+// passed in, so tests use a fake zone table (D49 O9).
+import 'night.dart';
+
+/// A wall-clock reading of an instant.
+typedef Wall = ({int year, int month, int day, int hour});
+
+/// The phone's time zone, as the night rules need it.
+abstract interface class Zone {
+  /// What the wall clock showed at [utc].
+  Wall wall(DateTime utc);
+
+  /// The instant the wall clock shows [hour]:00 on that day. The day may
+  /// run past the month's end.
+  DateTime instantAt(int year, int month, int day, int hour);
+}
+
+/// The phone's own zone, through Dart's local time.
+final class PhoneZone implements Zone {
+  const PhoneZone();
+
+  @override
+  Wall wall(DateTime utc) {
+    final l = utc.toLocal();
+    return (year: l.year, month: l.month, day: l.day, hour: l.hour);
+  }
+
+  @override
+  DateTime instantAt(int year, int month, int day, int hour) =>
+      DateTime(year, month, day, hour).toUtc();
+}
+
+/// The hour a night closes (C152-I item 2).
+const closingHour = 21;
+
+/// The first 21:00 strictly after [first], in [zone].
+DateTime closesAfter(DateTime first, Zone zone) {
+  final w = zone.wall(first);
+  final same = zone.instantAt(w.year, w.month, w.day, closingHour);
+  return same.isAfter(first) ? same : zone.instantAt(w.year, w.month, w.day + 1, closingHour);
+}
+
+/// The phone's date at [first], in [zone].
+NightDate dateOf(DateTime first, Zone zone) {
+  final w = zone.wall(first);
+  return (year: w.year, month: w.month, day: w.day);
+}
+
+/// Tonight's night: of the nights not yet closed at [now], the one with
+/// the latest first recording (D57 Q13), or null.
+Night? tonight(Iterable<Night> nights, DateTime now) {
+  Night? out;
+  for (final n in nights) {
+    if (!n.closes.isAfter(now)) continue;
+    if (out == null) {
+      out = n;
+      continue;
+    }
+    final c = n.firstRecorded.compareTo(out.firstRecorded);
+    if (c > 0 || (c == 0 && n.id.compareTo(out.id) > 0)) out = n;
+  }
+  return out;
+}
+
+/// Where a typing screen saves. Fixed when the screen opens, so a screen
+/// open across 21:00 saves into the night it began in (P10; D58 Q2).
+sealed class Target {
+  const Target();
+}
+
+/// Into a night that exists.
+final class IntoNight extends Target {
+  const IntoNight(this.id);
+
+  final String id;
+}
+
+/// Into a new night, begun when the screen opened.
+final class NewNight extends Target {
+  const NewNight(this.begun);
+
+  /// The moment the screen opened, in UTC: the night's first recording.
+  final DateTime begun;
+}
+
+/// The target of a typing screen opened at [now] from the journal.
+Target targetAt(Iterable<Night> nights, DateTime now) {
+  final open = tonight(nights, now);
+  return open == null ? NewNight(now) : IntoNight(open.id);
+}
+
+/// Nothing but whitespace counts as empty (P10; D58 Q3).
+bool isEmptyText(String text) => text.trim().isEmpty;
diff --git a/app/lib/journal/self_check.dart b/app/lib/journal/self_check.dart
index d3d8bdd..86765ee 100644
--- a/app/lib/journal/self_check.dart
+++ b/app/lib/journal/self_check.dart
@@ -10,6 +10,7 @@ import '../words/lines.g.dart' show Lang;
 import 'journal_files.dart';
 import 'journal_store.dart';
 import 'night.dart';
+import 'night_rules.dart';
 
 const journalProbe = 'journal-probe-d49';
 
@@ -26,6 +27,7 @@ Future<bool> journalSelfCheck(JournalFiles files, JournalProtection protection,
       id: probeId = newNightId(),
       firstRecorded: local.toUtc(),
       date: (year: local.year, month: local.month, day: local.day),
+      closes: closesAfter(local.toUtc(), const PhoneZone()),
       lang: Lang.en,
       dreams: const [journalProbe],
     );
diff --git a/app/test/fixtures.dart b/app/test/fixtures.dart
index 3076d6a..4d8c640 100644
--- a/app/test/fixtures.dart
+++ b/app/test/fixtures.dart
@@ -41,6 +41,7 @@ List<Night> nightsFromFixtures([int seed = 1]) {
         id: newNightId(random),
         firstRecorded: at = at.add(const Duration(hours: 1)),
         date: (year: at.year, month: at.month, day: at.day),
+        closes: at.add(const Duration(hours: 14)),
         lang: Lang.values.byName(n.lang),
         name: n.name,
         dreams: n.dreams,
diff --git a/app/test/journal/journal_store_test.dart b/app/test/journal/journal_store_test.dart
index 8f1b564..dc1a851 100644
--- a/app/test/journal/journal_store_test.dart
+++ b/app/test/journal/journal_store_test.dart
@@ -137,12 +137,7 @@ void main() {
     final store = await JournalStore.open(files);
     final [first, second, ...] = nightsFromFixtures();
     await store.save(first);
-    final edited = Night(
-        id: first.id,
-        firstRecorded: first.firstRecorded,
-        date: first.date,
-        lang: first.lang,
-        dreams: second.dreams);
+    final edited = first.withDreams(second.dreams);
     await store.save(edited);
     final all = files.everything();
     expect(all.keys, [JournalStore.fileOf(first.id)]);
@@ -186,12 +181,7 @@ void main() {
     final night = nightsFromFixtures().first;
     final store = await JournalStore.open(files);
     await store.save(night);
-    final changed = Night(
-        id: night.id,
-        firstRecorded: night.firstRecorded,
-        date: night.date,
-        lang: night.lang,
-        dreams: nightsFromFixtures()[2].dreams);
+    final changed = night.withDreams(nightsFromFixtures()[2].dreams);
     final broken = await JournalStore.open(BrokenRename(files.dir));
     await expectLater(broken.save(changed), throwsA(isA<FileSystemException>()));
     expect(files.everything().keys, [JournalStore.fileOf(night.id)],
@@ -209,12 +199,7 @@ void main() {
     final store = await JournalStore.open(files);
     final [first, second, ...] = nightsFromFixtures();
     await store.save(first);
-    final edited = Night(
-        id: first.id,
-        firstRecorded: first.firstRecorded,
-        date: first.date,
-        lang: first.lang,
-        dreams: second.dreams);
+    final edited = first.withDreams(second.dreams);
     await files.write(JournalStore.tempPrefix + JournalStore.fileOf(first.id), encodeNight(edited));
     await store.delete(first.id);
     expect(files.everything(), isEmpty);
diff --git a/app/test/journal/journal_test.dart b/app/test/journal/journal_test.dart
new file mode 100644
index 0000000..28986a7
--- /dev/null
+++ b/app/test/journal/journal_test.dart
@@ -0,0 +1,116 @@
+// The journal's operations (D58): the first Save makes the night, an
+// empty Save keeps nothing, a screen saves into the night it began in,
+// an emptied dream disappears, and an emptied night is deleted.
+import 'dart:convert';
+import 'dart:io';
+import 'dart:math';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night_rules.dart';
+import 'package:souldreams/words/lines.g.dart' show Lang;
+
+import '../fixtures.dart';
+import 'io_journal_files.dart';
+import 'zones.dart';
+
+void main() {
+  late Directory dir;
+  late IoJournalFiles files;
+  late DateTime clock;
+  late Journal journal;
+  final a = invented('two-dreams-en').dreams;
+  final b = invented('one-dream-sv').dreams;
+
+  setUp(() async {
+    dir = Directory.systemTemp.createTempSync('journal-');
+    files = IoJournalFiles(Directory('${dir.path}/Journal'));
+    clock = stockholm(2026, 6, 10, 23);
+    journal = Journal(await JournalStore.open(files),
+        zone: const FakeStockholm(), now: () => clock, random: Random(3));
+  });
+
+  tearDown(() => dir.deleteSync(recursive: true));
+
+  test('an empty Save keeps nothing', () async {
+    for (final text in ['', '  \n ']) {
+      expect(await journal.addDream(await journal.targetNow(), text, Lang.en), isFalse);
+    }
+    expect(files.everything(), isEmpty);
+  });
+
+  test('the first Save makes the night; later Saves add to it', () async {
+    final opened = clock;
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    clock = stockholm(2026, 6, 11, 7);
+    await journal.addDream(await journal.targetNow(), a[1], Lang.en);
+    final [n] = await journal.newestFirst();
+    expect(n.dreams, a);
+    expect(n.firstRecorded, opened);
+    expect(n.date, (year: 2026, month: 6, day: 10));
+    expect(n.closes, stockholm(2026, 6, 11, 21));
+    expect(n.lang, Lang.en);
+  });
+
+  test('after 21:00 a Save starts a new night', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    clock = stockholm(2026, 6, 11, 21);
+    await journal.addDream(await journal.targetNow(), b[0], Lang.sv);
+    final nights = await journal.newestFirst();
+    expect([for (final n in nights) n.dreams], [b, [a[0]]]);
+  });
+
+  test('a screen open across 21:00 saves into its own night', () async {
+    clock = stockholm(2026, 6, 11, 20, 58);
+    final none = await journal.targetNow();
+    clock = stockholm(2026, 6, 11, 21, 2);
+    await journal.addDream(none, a[0], Lang.en);
+    final [made] = await journal.newestFirst();
+    expect(made.date, (year: 2026, month: 6, day: 11));
+    expect(made.closes, stockholm(2026, 6, 11, 21));
+    // Begun before 21:00 and saved after: the next screen starts fresh.
+    expect(await journal.targetNow(), isA<NewNight>());
+
+    final into = await journal.targetNow();
+    clock = stockholm(2026, 6, 12, 0, 30);
+    await journal.addDream(into, a[1], Lang.en);
+    final open = (await journal.targetNow()) as IntoNight;
+    clock = stockholm(2026, 6, 12, 21, 5);
+    await journal.addDream(open, b[0], Lang.en);
+    expect([for (final n in await journal.newestFirst()) n.dreams], [
+      [a[1], b[0]],
+      [a[0]],
+    ]);
+  });
+
+  test('an edit replaces the dream; an emptied dream disappears', () async {
+    for (final d in [...a, b[0]]) {
+      await journal.addDream(await journal.targetNow(), d, Lang.en);
+    }
+    final id = (await journal.newestFirst()).single.id;
+    await journal.editDream(id, 0, b[0]);
+    expect((await journal.night(id))!.dreams, [b[0], a[1], b[0]]);
+    await journal.editDream(id, 1, ' \n');
+    expect((await journal.night(id))!.dreams, [b[0], b[0]]);
+    expect(utf8.decode(files.everything().values.single).contains(jsonEncode(a[1])), isFalse);
+  });
+
+  test('a night whose every dream is emptied is deleted, nothing left', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    await journal.addDream(await journal.targetNow(), a[1], Lang.en);
+    final id = (await journal.newestFirst()).single.id;
+    await journal.editDream(id, 1, '');
+    await journal.editDream(id, 0, '\t');
+    expect(await journal.night(id), isNull);
+    expect(files.everything(), isEmpty);
+  });
+
+  test('a Save into a night that is gone keeps nothing', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    final t = await journal.targetNow();
+    await journal.delete((t as IntoNight).id);
+    expect(await journal.addDream(t, a[1], Lang.en), isFalse);
+    expect(files.everything(), isEmpty);
+  });
+}
diff --git a/app/test/journal/night_rules_test.dart b/app/test/journal/night_rules_test.dart
new file mode 100644
index 0000000..86e00bc
--- /dev/null
+++ b/app/test/journal/night_rules_test.dart
@@ -0,0 +1,84 @@
+// What one night is: the first 21:00 after the first recording, in the
+// zone in force then (C152-I item 2; D58 Q2, P9, P10).
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/night_rules.dart';
+
+import '../fixtures.dart';
+import 'zones.dart';
+
+const sthlm = FakeStockholm();
+
+Night nightAt(DateTime first, {String id = 'a'}) {
+  final base = nightsFromFixtures().first;
+  return Night(
+    id: id * 32,
+    firstRecorded: first,
+    date: dateOf(first, sthlm),
+    closes: closesAfter(first, sthlm),
+    lang: base.lang,
+    dreams: base.dreams,
+  );
+}
+
+void main() {
+  test('an evening night closes at 21:00 the next day', () {
+    expect(closesAfter(stockholm(2026, 6, 10, 23), sthlm), stockholm(2026, 6, 11, 21));
+    expect(closesAfter(stockholm(2026, 6, 11, 7), sthlm), stockholm(2026, 6, 11, 21));
+  });
+
+  test('20:59 closes a minute later; 21:00 itself starts a new night', () {
+    expect(closesAfter(stockholm(2026, 6, 10, 20, 59), sthlm), stockholm(2026, 6, 10, 21));
+    expect(closesAfter(stockholm(2026, 6, 10, 21), sthlm), stockholm(2026, 6, 11, 21));
+    expect(closesAfter(stockholm(2026, 6, 10, 21, 1), sthlm), stockholm(2026, 6, 11, 21));
+  });
+
+  test('a night across a clock change still closes at 21:00 local', () {
+    final spring = stockholm(2026, 3, 28, 23);
+    expect(closesAfter(spring, sthlm).difference(spring), const Duration(hours: 21));
+    final autumn = stockholm(2026, 10, 24, 23);
+    expect(closesAfter(autumn, sthlm).difference(autumn), const Duration(hours: 23));
+    expect(sthlm.wall(closesAfter(autumn, sthlm)).hour, 21);
+  });
+
+  test('the date is the local date of the first recording', () {
+    expect(dateOf(stockholm(2026, 12, 31, 23, 30), sthlm), (year: 2026, month: 12, day: 31));
+    expect(dateOf(stockholm(2027, 1, 1, 0, 30), sthlm), (year: 2027, month: 1, day: 1));
+    expect(closesAfter(stockholm(2026, 12, 31, 22), sthlm), DateTime.utc(2027, 1, 1, 20));
+  });
+
+  test('the first zone fixes the 21:00 and the date (P9)', () {
+    final n = nightAt(stockholm(2026, 6, 10, 20));
+    const west = FixedZone(-5);
+    // The phone moves west; the night still closes at Stockholm's 21:00.
+    expect(tonight([n], stockholm(2026, 6, 10, 20, 59)), n);
+    expect(tonight([n], stockholm(2026, 6, 10, 21)), isNull);
+    expect(west.wall(n.closes).hour, 14);
+    expect(n.date, (year: 2026, month: 6, day: 10));
+  });
+
+  test("tonight's night is the latest one not yet closed", () {
+    final older = nightAt(stockholm(2026, 6, 9, 23), id: 'a');
+    final newer = nightAt(stockholm(2026, 6, 10, 23), id: 'b');
+    expect(tonight([older], stockholm(2026, 6, 10, 20)), older);
+    expect(tonight([older, newer], stockholm(2026, 6, 11, 7)), newer);
+    expect(tonight([older, newer], stockholm(2026, 6, 11, 21)), isNull);
+    // The clock moved back by hand: both open, the latest wins (D57 Q13).
+    expect(tonight([newer, older], stockholm(2026, 6, 9, 23, 30)), newer);
+  });
+
+  test('the target is fixed when the screen opens', () {
+    final n = nightAt(stockholm(2026, 6, 10, 23));
+    expect((targetAt([n], stockholm(2026, 6, 11, 20, 58)) as IntoNight).id, n.id);
+    final opened = stockholm(2026, 6, 11, 21, 2);
+    expect((targetAt([n], opened) as NewNight).begun, opened);
+    expect((targetAt([], opened) as NewNight).begun, opened);
+  });
+
+  test('whitespace alone is empty', () {
+    for (final t in ['', ' ', '\n\t ', ' ']) {
+      expect(isEmptyText(t), isTrue, reason: t.codeUnits.toString());
+    }
+    expect(isEmptyText(nightsFromFixtures().first.dreams.first), isFalse);
+  });
+}
diff --git a/app/test/journal/night_test.dart b/app/test/journal/night_test.dart
index 4d9379c..81cb8ba 100644
--- a/app/test/journal/night_test.dart
+++ b/app/test/journal/night_test.dart
@@ -24,11 +24,12 @@ void main() {
     final n = nightsFromFixtures().first;
     final json = fields(n);
     expect(json.keys.toSet(),
-        {'version', 'id', 'firstRecorded', 'date', 'lang', 'name', 'dreams'});
+        {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'});
     expect(json['version'], 1);
     expect(json['id'], n.id);
     expect(json['firstRecorded'], '2026-10-12T06:40:00.000Z');
     expect(json['date'], '2026-10-12');
+    expect(json['closes'], '2026-10-12T20:40:00.000Z');
     expect(json['lang'], 'en');
     expect(json['dreams'], n.dreams);
   });
@@ -49,6 +50,10 @@ void main() {
       bytesOf(with_('firstRecorded', 'tomorrow')),
       bytesOf(with_('date', '2026-02-30')),
       bytesOf(with_('date', '12/10/2026')),
+      bytesOf(without('closes')),
+      bytesOf(with_('closes', '2026-10-12T20:40:00.000')),
+      bytesOf(with_('closes', good['firstRecorded'])),
+      bytesOf(with_('closes', '2026-10-12T06:39:00.000Z')),
       bytesOf(with_('lang', 'de')),
       bytesOf(with_('name', 7)),
       bytesOf(with_('dreams', [1])),
@@ -70,17 +75,31 @@ void main() {
   test('a bad id or a local time is refused', () {
     final n = nightsFromFixtures().first;
     expect(
-        () => Night(id: 'x', firstRecorded: n.firstRecorded, date: n.date, lang: n.lang, dreams: n.dreams),
+        () => Night(
+            id: 'x', firstRecorded: n.firstRecorded, date: n.date, closes: n.closes, lang: n.lang, dreams: n.dreams),
         throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'id')));
     expect(
-        () => Night(id: n.id, firstRecorded: DateTime(2026), date: n.date, lang: n.lang, dreams: n.dreams),
+        () => Night(
+            id: n.id, firstRecorded: DateTime(2026), date: n.date, closes: n.closes, lang: n.lang, dreams: n.dreams),
         throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'firstRecorded')));
   });
 
+  test('a local or too early closing instant is refused', () {
+    final n = nightsFromFixtures().first;
+    for (final closes in [n.firstRecorded, n.firstRecorded.subtract(const Duration(minutes: 1)), DateTime(2027)]) {
+      expect(
+          () => Night(
+              id: n.id, firstRecorded: n.firstRecorded, date: n.date, closes: closes, lang: n.lang, dreams: n.dreams),
+          throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'closes')),
+          reason: '$closes');
+    }
+    expect(n.withDreams(const ['x']).closes, n.closes);
+  });
+
   test('a date its file could not hold is refused', () {
     final n = nightsFromFixtures().first;
     Night on(NightDate date) =>
-        Night(id: n.id, firstRecorded: n.firstRecorded, date: date, lang: n.lang, dreams: n.dreams);
+        Night(id: n.id, firstRecorded: n.firstRecorded, date: date, closes: n.closes, lang: n.lang, dreams: n.dreams);
     for (final date in [
       (year: 2026, month: 2, day: 30),
       (year: 2026, month: 13, day: 1),
diff --git a/app/test/journal/zones.dart b/app/test/journal/zones.dart
new file mode 100644
index 0000000..4c7360a
--- /dev/null
+++ b/app/test/journal/zones.dart
@@ -0,0 +1,51 @@
+// Fake zone tables for the night rules' tests (D49 O9): no test depends
+// on the Mac's own time zone.
+import 'package:souldreams/journal/night_rules.dart';
+
+/// Stockholm in 2026: UTC+1, and UTC+2 from 29 March 01:00 UTC to
+/// 25 October 01:00 UTC.
+final class FakeStockholm implements Zone {
+  const FakeStockholm();
+
+  static final _summerFrom = DateTime.utc(2026, 3, 29, 1);
+  static final _summerTo = DateTime.utc(2026, 10, 25, 1);
+
+  int _offset(DateTime utc) => !utc.isBefore(_summerFrom) && utc.isBefore(_summerTo) ? 2 : 1;
+
+  @override
+  Wall wall(DateTime utc) {
+    final l = utc.add(Duration(hours: _offset(utc)));
+    return (year: l.year, month: l.month, day: l.day, hour: l.hour);
+  }
+
+  @override
+  DateTime instantAt(int year, int month, int day, int hour) {
+    final naive = DateTime.utc(year, month, day, hour);
+    for (final o in const [2, 1]) {
+      final c = naive.subtract(Duration(hours: o));
+      if (_offset(c) == o) return c;
+    }
+    return naive.subtract(const Duration(hours: 1));
+  }
+}
+
+/// A zone with a fixed offset from UTC, in hours.
+final class FixedZone implements Zone {
+  const FixedZone(this.hours);
+
+  final int hours;
+
+  @override
+  Wall wall(DateTime utc) {
+    final l = utc.add(Duration(hours: hours));
+    return (year: l.year, month: l.month, day: l.day, hour: l.hour);
+  }
+
+  @override
+  DateTime instantAt(int year, int month, int day, int hour) =>
+      DateTime.utc(year, month, day, hour).subtract(Duration(hours: hours));
+}
+
+/// The instant Stockholm's wall clock shows this minute.
+DateTime stockholm(int year, int month, int day, int hour, [int minute = 0]) =>
+    const FakeStockholm().instantAt(year, month, day, hour).add(Duration(minutes: minute));
~~~~

### Task 6 · A row's opening, the date's digits, the month dividers (D58 Q7; P5)

`row_text.dart`:
- `opening` trims TECH·1 from the very start only: a whole word or phrase, ignoring case, the longest first; nothing
  when only framing is left.
- `dayDigits` gives day/month/year.
- `monthDivider` uses `intl`'s standalone month name for the language, first letter capitalised; the year is added
  before this year.
- `listItems` gives a divider over each run of nights in one month.

The tests type no month name and no framing: they read both from `intl` and from the generated lists (R1).

Expected: 83 tests. Commit:

> Journal: a row's opening trimmed of TECH·1, the date's digits and the month dividers (D58 Q7; P5)

**The block** (from the proof's `e03996e`):

~~~~diff
diff --git a/app/lib/journal/row_text.dart b/app/lib/journal/row_text.dart
new file mode 100644
index 0000000..e8561b5
--- /dev/null
+++ b/app/lib/journal/row_text.dart
@@ -0,0 +1,77 @@
+// What the journal list shows of a night, in plain Dart (main-path.md,
+// The Journal; C131-I items 1, 2; D58 Q7; P5).
+// - The opening: the first dream as told, with TECH·1's framing trimmed
+//   from its very start only, matched as a whole word or phrase and
+//   ignoring case, the longest first. When unsure, nothing is trimmed.
+// - The date: day/month/year, never a time.
+// - The month divider: the phone's own month name for the language
+//   (Flutter's localization data), the first letter capitalised; the month
+//   alone in the current year, month and year in an earlier one.
+import 'package:intl/intl.dart';
+
+import '../words/lines.g.dart' show Lang;
+import '../words/lists.g.dart';
+import 'night.dart';
+
+final _wordChar = RegExp(r'[\p{L}\p{N}]', unicode: true);
+
+/// The first dream's opening, with its framing trimmed.
+String opening(Night night) {
+  final dream = night.dreams.first;
+  final framings = [...(night.lang == Lang.en ? ListWords.tech1En : ListWords.tech1Sv)]
+    ..sort((a, b) => b.length.compareTo(a.length));
+  for (final f in framings) {
+    if (dream.length < f.length) continue;
+    if (dream.substring(0, f.length).toLowerCase() != f.toLowerCase()) continue;
+    if (dream.length > f.length && _wordChar.hasMatch(dream[f.length])) continue;
+    final rest = dream.substring(f.length).trimLeft();
+    return rest.isEmpty ? dream : rest;
+  }
+  return dream;
+}
+
+String _two(int n) => n.toString().padLeft(2, '0');
+
+/// The night's date: day/month/year (main-path.md, Every Screen; MP·27).
+String dayDigits(NightDate d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';
+
+/// The month divider's words, in [lang].
+String monthDivider(int year, int month, int currentYear, Lang lang) {
+  final at = DateTime(year, month);
+  final words = year == currentYear
+      ? DateFormat.LLLL(lang.name).format(at)
+      : DateFormat('LLLL y', lang.name).format(at);
+  return words.isEmpty ? words : words[0].toUpperCase() + words.substring(1);
+}
+
+/// One entry of the journal list: a month divider or a night.
+sealed class ListItem {
+  const ListItem();
+}
+
+final class MonthItem extends ListItem {
+  const MonthItem(this.year, this.month);
+
+  final int year;
+  final int month;
+}
+
+final class NightItem extends ListItem {
+  const NightItem(this.night);
+
+  final Night night;
+}
+
+/// The list: newest first, a divider above each run of nights in one
+/// month, and no divider over a month with no nights; no count anywhere.
+List<ListItem> listItems(List<Night> newestFirst) {
+  final out = <ListItem>[];
+  (int, int)? month;
+  for (final n in newestFirst) {
+    final m = (n.date.year, n.date.month);
+    if (m != month) out.add(MonthItem(m.$1, m.$2));
+    month = m;
+    out.add(NightItem(n));
+  }
+  return out;
+}
diff --git a/app/test/journal/row_text_test.dart b/app/test/journal/row_text_test.dart
new file mode 100644
index 0000000..67c01aa
--- /dev/null
+++ b/app/test/journal/row_text_test.dart
@@ -0,0 +1,109 @@
+// What a journal row shows (D58 Q7; P5): the opening trimmed of TECH·1's
+// framing at its very start only, the date's digits, the month dividers.
+// No month name and no framing is typed here: both come from the
+// generated lists and from Flutter's localization data (R1).
+import 'package:flutter_test/flutter_test.dart';
+import 'package:intl/date_symbol_data_local.dart';
+import 'package:intl/intl.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/words/lines.g.dart' show Lang;
+import 'package:souldreams/words/lists.g.dart';
+
+import '../fixtures.dart';
+
+Night told(String first, {Lang lang = Lang.en, NightDate date = (year: 2026, month: 10, day: 12)}) {
+  final base = nightsFromFixtures().first;
+  return Night(
+      id: base.id,
+      firstRecorded: base.firstRecorded,
+      date: date,
+      closes: base.closes,
+      lang: lang,
+      dreams: [first]);
+}
+
+void main() {
+  setUpAll(() => initializeDateFormatting());
+
+  final rest = invented('two-dreams-en').dreams.first;
+  final restSv = invented('one-dream-sv').dreams.first;
+
+  test('each framing is trimmed from the very start, ignoring case', () {
+    for (final f in ListWords.tech1En) {
+      expect(opening(told('$f $rest')), rest, reason: f);
+      expect(opening(told('${f.toUpperCase()}  $rest')), rest, reason: f);
+      expect(opening(told('${f.toLowerCase()}\n$rest')), rest, reason: f);
+    }
+    for (final f in ListWords.tech1Sv) {
+      expect(opening(told('$f $restSv', lang: Lang.sv)), restSv, reason: f);
+    }
+  });
+
+  test('a framing is trimmed only whole, at the start', () {
+    final f = ListWords.tech1En.first;
+    for (final t in ['${f}s $rest', '$rest $f', ' $f $rest', f]) {
+      expect(opening(told(t)), t);
+    }
+    // The other language's framing is not trimmed.
+    expect(opening(told('$f $rest', lang: Lang.sv)), '$f $rest');
+  });
+
+  test('the longest framing wins', () {
+    // A pair where one framing begins with the other and a space.
+    final all = ListWords.tech1Sv;
+    final (short, long) = [
+      for (final a in all)
+        for (final b in all)
+          if (b.length > a.length && b.toLowerCase().startsWith('${a.toLowerCase()} ')) (a, b)
+    ].first;
+    expect(opening(told('$long $restSv', lang: Lang.sv)), restSv);
+    expect(opening(told('$short $restSv', lang: Lang.sv)), restSv);
+  });
+
+  test('the invented framed night loses its framing', () {
+    final framed = invented('framed-opening-en').dreams.first;
+    final trimmed = opening(told(framed));
+    expect(framed.endsWith(trimmed), isTrue);
+    expect(trimmed.length, lessThan(framed.length));
+  });
+
+  test('the date is day/month/year, with no time', () {
+    expect(dayDigits((year: 2026, month: 3, day: 5)), '05/03/2026');
+    expect(dayDigits((year: 2026, month: 12, day: 31)), '31/12/2026');
+  });
+
+  test('a divider: the month alone this year, month and year before', () {
+    for (final lang in Lang.values) {
+      final own = DateFormat.LLLL(lang.name).format(DateTime(2026, 10));
+      final now = monthDivider(2026, 10, 2026, lang);
+      expect(now.toLowerCase(), own.toLowerCase());
+      expect(now[0], now[0].toUpperCase());
+      expect(now.contains(RegExp(r'\d')), isFalse);
+      final before = monthDivider(2025, 10, 2026, lang);
+      expect(before, '$now 2025');
+    }
+    // Flutter's Swedish month names are lower case; the divider's is not.
+    final sv = DateFormat.LLLL('sv').format(DateTime(2026, 10));
+    expect(sv[0], isNot(sv[0].toUpperCase()));
+    expect(monthDivider(2026, 10, 2026, Lang.sv)[0], sv[0].toUpperCase());
+  });
+
+  test('a divider over each month with nights, and no other', () {
+    final nights = [
+      told(rest, date: (year: 2026, month: 11, day: 2)),
+      told(rest, date: (year: 2026, month: 11, day: 1)),
+      told(rest, date: (year: 2026, month: 9, day: 30)),
+      told(rest, date: (year: 2025, month: 9, day: 30)),
+    ];
+    final items = listItems(nights);
+    expect([
+      for (final i in items)
+        switch (i) {
+          MonthItem(:final year, :final month) => '$year-$month',
+          NightItem(:final night) => night.date.day,
+        }
+    ], ['2026-11', 2, 1, '2026-9', 30, '2025-9', 30]);
+    expect(listItems(const []), isEmpty);
+  });
+}
~~~~

### Task 7 · Night/Day automatic, the palette, Flutter's localizations (D56; D57 Q9, Q12, Q15, Q16; P14)

- `palette.dart`: a `ThemeExtension` of every colour the pages use, from the generated tokens, so the whole page fades
  together; `themeFor`.
- `night_day.dart`:
  - dark from 21:00 to 08:00 by the wall clock, checked every minute and on returning;
  - a five-second fade while the app is open;
  - instant with Reduce Motion or disabled animations, at start and on returning.
  - On iOS, Reduce Motion is `AccessibilityFeatures.reduceMotion`, not `MediaQuery.disableAnimations` (the
    investigation, §6).
- `language.dart`: `appLanguage = Lang.en` (D57 Q12).
- `app.dart`: `NightDay` around `MaterialApp`, both themes, the fade, the locale, and
  `GlobalMaterialLocalizations.delegates`.
- Tests: `night_day_test.dart` (6).

Expected: 89 tests. Commit:

> App: Night/Day automatic, faded over five seconds, instant with Reduce Motion; the palette; Flutter's localizations (D56; D57 Q9, Q12, Q15, Q16; P14)

**The block** (from the proof's `8b39b71`):

~~~~diff
diff --git a/app/lib/app.dart b/app/lib/app.dart
index 162f86b..f3050c1 100644
--- a/app/lib/app.dart
+++ b/app/lib/app.dart
@@ -1,22 +1,41 @@
 import 'package:flutter/material.dart';
+import 'package:flutter_localizations/flutter_localizations.dart';
 
+import 'core/language.dart';
+import 'core/night_day.dart';
 import 'core/privacy_cover.dart';
+import 'design/palette.dart';
 
-/// The app. For now a blank screen with no text (scaffold-2-app), under
-/// the cover (D50 2) on every page.
+/// The app, under the cover (D50 2) on every page, in the theme Night/Day
+/// mode sets (D56; P14), in the language it shows (D57 Q12). Flutter's
+/// own localizations give the month names (P5) and the framework's own
+/// words, which are not ours under R1 (D57 Q9).
 class SoulDreamsApp extends StatelessWidget {
-  const SoulDreamsApp({super.key, this.home});
+  const SoulDreamsApp({super.key, this.home, this.clock});
 
-  /// The first page; a blank one when null. Only SoulDreams Dev sets it
-  /// (the keyboard check, D50 1).
+  /// The first page; a blank one when null. Only SoulDreams Dev sets it.
   final Widget? home;
 
+  /// The phone's local time now; tests pass their own.
+  final DateTime Function()? clock;
+
   @override
   Widget build(BuildContext context) {
-    return MaterialApp(
-      debugShowCheckedModeBanner: false,
-      builder: (context, child) => PrivacyCover(child: child!),
-      home: home ?? const Scaffold(),
+    return NightDay(
+      now: clock ?? DateTime.now,
+      builder: (context, mode, fade) => MaterialApp(
+        debugShowCheckedModeBanner: false,
+        theme: themeFor(Brightness.light),
+        darkTheme: themeFor(Brightness.dark),
+        themeMode: mode,
+        themeAnimationDuration: fade,
+        themeAnimationCurve: Curves.linear,
+        locale: Locale(appLanguage.name),
+        supportedLocales: const [Locale('en'), Locale('sv')],
+        localizationsDelegates: GlobalMaterialLocalizations.delegates,
+        builder: (context, child) => PrivacyCover(child: child!),
+        home: home ?? const Scaffold(),
+      ),
     );
   }
 }
diff --git a/app/lib/core/language.dart b/app/lib/core/language.dart
new file mode 100644
index 0000000..a3d4b7f
--- /dev/null
+++ b/app/lib/core/language.dart
@@ -0,0 +1,6 @@
+// The language the app shows (D57 Q12): English only for Cohort 0;
+// Swedish is built and tested, not shown. The switch to the phone's own
+// language (main-path.md, Every Screen) is this one line, later.
+import '../words/lines.g.dart' show Lang;
+
+const appLanguage = Lang.en;
diff --git a/app/lib/core/night_day.dart b/app/lib/core/night_day.dart
new file mode 100644
index 0000000..9a19771
--- /dev/null
+++ b/app/lib/core/night_day.dart
@@ -0,0 +1,80 @@
+// Night/Day mode, Automatic (design-system.md §6; main-path.md, Settings;
+// P14; D56): dark from 21:00, light from 08:00, by the phone's local time
+// now. A change found while the app is open fades over five seconds; with
+// the phone's Reduce Motion on, or animations disabled, it is instant. A
+// change found at start or on returning to the app is instant (D57 Q15).
+// On iOS, Reduce Motion is its own flag, which MediaQuery does not carry,
+// so it is read from the platform's accessibility features. There is no
+// Settings page yet, so no Manual mode and no Word Animation (P8).
+import 'dart:async';
+
+import 'package:flutter/material.dart';
+
+/// Dark from 21:00 to 08:00, by the wall clock.
+bool isNightAt(DateTime local) => local.hour >= 21 || local.hour < 8;
+
+class NightDay extends StatefulWidget {
+  const NightDay({super.key, required this.now, required this.builder});
+
+  /// The phone's local time now.
+  final DateTime Function() now;
+
+  final Widget Function(BuildContext context, ThemeMode mode, Duration fade) builder;
+
+  /// The fade while the app is open (§6).
+  static const fade = Duration(seconds: 5);
+
+  /// How often the clock is looked at.
+  static const tick = Duration(minutes: 1);
+
+  @override
+  State<NightDay> createState() => _NightDayState();
+}
+
+class _NightDayState extends State<NightDay> with WidgetsBindingObserver {
+  late bool _night = isNightAt(widget.now());
+  Duration _fade = Duration.zero;
+  late final Timer _timer;
+
+  @override
+  void initState() {
+    super.initState();
+    WidgetsBinding.instance.addObserver(this);
+    _timer = Timer.periodic(NightDay.tick, (_) => _check());
+  }
+
+  @override
+  void dispose() {
+    _timer.cancel();
+    WidgetsBinding.instance.removeObserver(this);
+    super.dispose();
+  }
+
+  @override
+  void didChangeAppLifecycleState(AppLifecycleState state) {
+    if (state == AppLifecycleState.resumed) _check(returning: true);
+  }
+
+  bool get _still {
+    final f = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
+    return f.reduceMotion || f.disableAnimations;
+  }
+
+  bool get _open {
+    final state = WidgetsBinding.instance.lifecycleState;
+    return state == null || state == AppLifecycleState.resumed;
+  }
+
+  void _check({bool returning = false}) {
+    final night = isNightAt(widget.now());
+    if (night == _night) return;
+    setState(() {
+      _night = night;
+      _fade = !returning && _open && !_still ? NightDay.fade : Duration.zero;
+    });
+  }
+
+  @override
+  Widget build(BuildContext context) =>
+      widget.builder(context, _night ? ThemeMode.dark : ThemeMode.light, _fade);
+}
diff --git a/app/lib/design/palette.dart b/app/lib/design/palette.dart
new file mode 100644
index 0000000..c85a402
--- /dev/null
+++ b/app/lib/design/palette.dart
@@ -0,0 +1,144 @@
+// The two themes' colours as one theme extension, built from the
+// generated design values (design-system.md §2, §3), so that every page
+// fades with the theme when Night/Day mode changes it (§6). No value is
+// typed here except the dark field's absent border ("no border", §3).
+import 'package:flutter/material.dart';
+
+import 'tokens.g.dart';
+
+@immutable
+final class Palette extends ThemeExtension<Palette> {
+  const Palette({
+    required this.page,
+    required this.text,
+    required this.surfaceTop,
+    required this.surfaceBottom,
+    required this.surfaceBorder,
+    required this.summary,
+    required this.field,
+    required this.fieldBorder,
+    required this.fieldText,
+    required this.placeholder,
+    required this.buttonTop,
+    required this.buttonBottom,
+    required this.buttonBorder,
+    required this.buttonText,
+    required this.recordTop,
+    required this.recordBottom,
+    required this.recordText,
+    required this.sectionTop,
+    required this.sectionBottom,
+    required this.sectionText,
+  });
+
+  final Color page;
+  final Color text;
+  final Color surfaceTop;
+  final Color surfaceBottom;
+  final Color surfaceBorder;
+  final Color summary;
+  final Color field;
+  final Color fieldBorder;
+  final Color fieldText;
+  final Color placeholder;
+  final Color buttonTop;
+  final Color buttonBottom;
+  final Color buttonBorder;
+  final Color buttonText;
+  final Color recordTop;
+  final Color recordBottom;
+  final Color recordText;
+  final Color sectionTop;
+  final Color sectionBottom;
+  final Color sectionText;
+
+  static final light = Palette(
+    page: LightColours.page.colour!,
+    text: LightColours.text.colour!,
+    surfaceTop: LightColours.surface.colour!,
+    surfaceBottom: LightColours.surface.colour!,
+    surfaceBorder: LightColours.surfaceBorder.border!,
+    summary: LightColours.textSummary.colour!,
+    field: LightColours.field.colour!,
+    fieldBorder: LightColours.fieldBorder.border!,
+    fieldText: LightColours.text.colour!,
+    placeholder: LightColours.textPlaceholder.colour!,
+    buttonTop: LightColours.button.colour!,
+    buttonBottom: LightColours.button.colour!,
+    buttonBorder: LightColours.button.border!,
+    buttonText: LightColours.button.text!,
+    recordTop: LightColours.record.colour!,
+    recordBottom: LightColours.record.colourEnd!,
+    recordText: LightColours.record.text!,
+    sectionTop: LightColours.labelSection.colour!,
+    sectionBottom: LightColours.labelSection.colourEnd!,
+    sectionText: LightColours.labelSection.text!,
+  );
+
+  static final dark = Palette(
+    page: DarkColours.page.colour!,
+    text: DarkColours.text.colour!,
+    surfaceTop: DarkColours.surface.colour!,
+    surfaceBottom: DarkColours.surface.colourEnd!,
+    surfaceBorder: DarkColours.surface.border!,
+    summary: DarkColours.text.colour!,
+    field: DarkColours.field.colour!,
+    fieldBorder: const Color(0x00000000),
+    fieldText: DarkColours.fieldText.colour!,
+    placeholder: DarkColours.textPlaceholder.colour!,
+    buttonTop: DarkColours.button.colour!,
+    buttonBottom: DarkColours.button.colourEnd!,
+    buttonBorder: DarkColours.button.border!,
+    buttonText: DarkColours.button.text!,
+    recordTop: DarkColours.record.colour!,
+    recordBottom: DarkColours.record.colourEnd!,
+    recordText: DarkColours.record.text!,
+    sectionTop: DarkColours.labelSection.colour!,
+    sectionBottom: DarkColours.labelSection.colourEnd!,
+    sectionText: DarkColours.labelSection.text!,
+  );
+
+  static Palette of(BuildContext context) => Theme.of(context).extension<Palette>()!;
+
+  @override
+  Palette copyWith() => this;
+
+  @override
+  Palette lerp(Palette? other, double t) {
+    if (other == null) return this;
+    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
+    return Palette(
+      page: c(page, other.page),
+      text: c(text, other.text),
+      surfaceTop: c(surfaceTop, other.surfaceTop),
+      surfaceBottom: c(surfaceBottom, other.surfaceBottom),
+      surfaceBorder: c(surfaceBorder, other.surfaceBorder),
+      summary: c(summary, other.summary),
+      field: c(field, other.field),
+      fieldBorder: c(fieldBorder, other.fieldBorder),
+      fieldText: c(fieldText, other.fieldText),
+      placeholder: c(placeholder, other.placeholder),
+      buttonTop: c(buttonTop, other.buttonTop),
+      buttonBottom: c(buttonBottom, other.buttonBottom),
+      buttonBorder: c(buttonBorder, other.buttonBorder),
+      buttonText: c(buttonText, other.buttonText),
+      recordTop: c(recordTop, other.recordTop),
+      recordBottom: c(recordBottom, other.recordBottom),
+      recordText: c(recordText, other.recordText),
+      sectionTop: c(sectionTop, other.sectionTop),
+      sectionBottom: c(sectionBottom, other.sectionBottom),
+      sectionText: c(sectionText, other.sectionText),
+    );
+  }
+}
+
+/// The theme for [brightness]: the page colour and the palette.
+ThemeData themeFor(Brightness brightness) {
+  final p = brightness == Brightness.dark ? Palette.dark : Palette.light;
+  return ThemeData(
+    brightness: brightness,
+    scaffoldBackgroundColor: p.page,
+    canvasColor: p.page,
+    extensions: [p],
+  );
+}
diff --git a/app/test/core/night_day_test.dart b/app/test/core/night_day_test.dart
new file mode 100644
index 0000000..1cf0722
--- /dev/null
+++ b/app/test/core/night_day_test.dart
@@ -0,0 +1,83 @@
+// Night/Day mode, Automatic (design-system.md §6; P14; D56; D57 Q15):
+// dark at 21:00, light at 08:00; a five-second fade while the app is
+// open; instant with Reduce Motion, at start and on returning.
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/core/night_day.dart';
+import 'package:souldreams/core/privacy_cover.dart';
+import 'package:souldreams/design/palette.dart';
+import 'package:souldreams/design/tokens.g.dart';
+
+Color pageOf(WidgetTester tester) =>
+    Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor;
+
+void main() {
+  final light = LightColours.page.colour!;
+  final dark = DarkColours.page.colour!;
+
+  test('dark from 21:00 to 08:00, by the wall clock', () {
+    expect(isNightAt(DateTime(2026, 6, 10, 7, 59)), isTrue);
+    expect(isNightAt(DateTime(2026, 6, 10, 8)), isFalse);
+    expect(isNightAt(DateTime(2026, 6, 10, 20, 59)), isFalse);
+    expect(isNightAt(DateTime(2026, 6, 10, 21)), isTrue);
+    expect(isNightAt(DateTime(2026, 6, 10, 0)), isTrue);
+  });
+
+  testWidgets('at start the theme is the hour\'s, with no fade', (tester) async {
+    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 22)));
+    expect(pageOf(tester), dark);
+    expect(Palette.of(tester.element(find.byType(Scaffold))).page, dark);
+  });
+
+  testWidgets('at 21:00 the open app fades to dark over five seconds', (tester) async {
+    var now = DateTime(2026, 6, 10, 20, 59, 30);
+    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
+    expect(pageOf(tester), light);
+    now = DateTime(2026, 6, 10, 21, 0, 30);
+    await tester.pump(NightDay.tick);
+    await tester.pump(const Duration(milliseconds: 2500));
+    final mid = pageOf(tester);
+    expect(mid, isNot(light));
+    expect(mid, isNot(dark));
+    expect(mid, Color.lerp(light, dark, 0.5));
+    await tester.pump(const Duration(milliseconds: 2600));
+    expect(pageOf(tester), dark);
+    // And back to light at 08:00.
+    now = DateTime(2026, 6, 11, 8, 0, 30);
+    await tester.pump(NightDay.tick);
+    await tester.pump(NightDay.fade);
+    expect(pageOf(tester), light);
+  });
+
+  testWidgets('with Reduce Motion the change is instant', (tester) async {
+    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(reduceMotion: true);
+    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
+    var now = DateTime(2026, 6, 10, 20, 59, 30);
+    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
+    now = DateTime(2026, 6, 10, 21, 0, 30);
+    await tester.pump(NightDay.tick);
+    await tester.pump();
+    expect(pageOf(tester), dark);
+  });
+
+  testWidgets('a change found on returning to the app is instant', (tester) async {
+    var now = DateTime(2026, 6, 10, 20, 50);
+    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
+    now = DateTime(2026, 6, 10, 23);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pump();
+    await tester.pump();
+    expect(pageOf(tester), dark);
+  });
+
+  testWidgets('the cover follows the dark theme', (tester) async {
+    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 23)));
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
+    await tester.pump();
+    expect(tester.widget<ColoredBox>(find.byKey(PrivacyCover.coverKey)).color, dark);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pump();
+  });
+}
~~~~

### Task 8 · The app's line word by word, the stand-ins, the pages' parts (D58 Q17; P13)

- `app_line.dart`:
  - one word, then one more every 60 ms;
  - unshown words are transparent, so the line never reflows;
  - whole with Reduce Motion;
  - whole to a screen reader.
- `stand_ins.dart`: the named values Task 14 measures.
- `parts.dart`: the section label (a heading), the plain button, the record button, a surface, the dreamer's bubble,
  and the back arrow (MP·14 as its tooltip).
- Tests: `app_line_test.dart` (3).

Expected: 92 tests. Commit:

> App: the app's words word by word at 60 ms, whole with Reduce Motion; the named stand-ins; the pages' parts (D58 Q17; P13)

**The block** (from the proof's `a1cce70`):

~~~~diff
diff --git a/app/lib/core/app_line.dart b/app/lib/core/app_line.dart
new file mode 100644
index 0000000..18f2abf
--- /dev/null
+++ b/app/lib/core/app_line.dart
@@ -0,0 +1,81 @@
+// A line in the app's own voice, appearing word by word (How the AI
+// Appears §4): one word about every 60 ms, the founder's pace to judge in
+// Cohort 0 (D58 Q17). With the phone's Reduce Motion on, or animations
+// disabled, the line stands whole. A screen reader always gets the line
+// whole (§8). Words not yet shown keep their place, so the line never
+// reflows as it appears.
+import 'dart:async';
+
+import 'package:flutter/widgets.dart';
+
+/// The pace of the app's own words (D58 Q17).
+const wordPace = Duration(milliseconds: 60);
+
+class AppLine extends StatefulWidget {
+  const AppLine(this.text, {super.key, required this.style, this.textAlign = TextAlign.center});
+
+  final String text;
+  final TextStyle style;
+  final TextAlign textAlign;
+
+  @override
+  State<AppLine> createState() => _AppLineState();
+}
+
+final _afterSpace = RegExp(r'(?<= )');
+
+class _AppLineState extends State<AppLine> {
+  late List<String> _words;
+  int _shown = 0;
+  Timer? _timer;
+
+  @override
+  void initState() {
+    super.initState();
+    _start();
+  }
+
+  @override
+  void didUpdateWidget(AppLine old) {
+    super.didUpdateWidget(old);
+    if (old.text != widget.text) _start();
+  }
+
+  @override
+  void dispose() {
+    _timer?.cancel();
+    super.dispose();
+  }
+
+  void _start() {
+    _timer?.cancel();
+    // Each word with the space after it, so the parts join to the line.
+    _words = widget.text.split(_afterSpace);
+    final f = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
+    if (f.reduceMotion || f.disableAnimations) {
+      _shown = _words.length;
+      return;
+    }
+    _shown = 1;
+    _timer = Timer.periodic(wordPace, (t) {
+      setState(() => _shown++);
+      if (_shown >= _words.length) t.cancel();
+    });
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    const hidden = TextStyle(color: Color(0x00000000));
+    return Semantics(
+      label: widget.text,
+      excludeSemantics: true,
+      child: Text.rich(
+        TextSpan(children: [
+          for (final (i, w) in _words.indexed) TextSpan(text: w, style: i < _shown ? null : hidden),
+        ]),
+        style: widget.style,
+        textAlign: widget.textAlign,
+      ),
+    );
+  }
+}
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
new file mode 100644
index 0000000..51f3f03
--- /dev/null
+++ b/app/lib/design/stand_ins.dart
@@ -0,0 +1,48 @@
+// Values design-system.md leaves unset ("[to set in Framer]", §5, §7),
+// each a named stand-in matched by eye to the founder's screenshots
+// (P13; D58), never added to tokens.g.dart. The founder corrects them in
+// Cohort 0. Every one is listed in docs/plans/journal-screens.md.
+import 'package:flutter/painting.dart';
+
+import 'tokens.g.dart';
+
+abstract final class StandIns {
+  /// The page's side margin.
+  static const double pageSide = 20;
+
+  /// The space between two journal rows.
+  static const double rowGap = 12;
+
+  /// Inside a journal row.
+  static const rowPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 20);
+
+  /// space.journal.end: below the last row, so the list scrolls clear of
+  /// the record button.
+  static const double journalEnd = 120;
+
+  /// Above a month divider.
+  static const double dividerAbove = 24;
+
+  /// Below a month divider.
+  static const double dividerBelow = 12;
+
+  /// The record button.
+  static const double recordHeight = 64;
+  static const double recordWidth = 240;
+  static const double recordBelow = 24;
+
+  /// Inside a button, and a section label.
+  static const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 14);
+  static const labelPadding = EdgeInsets.symmetric(horizontal: 18, vertical: 8);
+
+  /// Inside a dreamer's bubble, and between two of them.
+  static const bubblePadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
+  static const double bubbleGap = 12;
+
+  /// Inside the typing field, and around the typing screen's parts.
+  static const fieldPadding = EdgeInsets.all(20);
+  static const double gap = 20;
+
+  /// A row's summary: the dreamer's words (type role unset).
+  static const summary = TypeRoles.voiceDreamer;
+}
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
new file mode 100644
index 0000000..4248a44
--- /dev/null
+++ b/app/lib/journal/pages/parts.dart
@@ -0,0 +1,155 @@
+// The journal pages' shared parts, from the palette, the type roles and
+// the named stand-ins. No words here: each part is given its line.
+import 'package:flutter/material.dart';
+
+import '../../core/language.dart';
+import '../../design/palette.dart';
+import '../../design/stand_ins.dart';
+import '../../design/tokens.g.dart';
+import '../../words/lines.g.dart';
+
+BoxDecoration _pill(Color top, Color bottom, [Color? border]) => BoxDecoration(
+      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]),
+      borderRadius: BorderRadius.circular(Spacing.radius),
+      border: border == null ? null : Border.all(color: border),
+    );
+
+/// A section label: a pill in the green gradient, white text, heard as a
+/// heading (How the AI Appears §2.6, §8).
+class SectionLabel extends StatelessWidget {
+  const SectionLabel(this.text, {super.key});
+
+  final String text;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Semantics(
+      header: true,
+      child: DecoratedBox(
+        decoration: _pill(p.sectionTop, p.sectionBottom),
+        child: Padding(
+          padding: StandIns.labelPadding,
+          child: Text(text, style: TypeRoles.button.style(p.sectionText)),
+        ),
+      ),
+    );
+  }
+}
+
+/// A plain button (color.button).
+class PlainButton extends StatelessWidget {
+  const PlainButton(this.label, {super.key, required this.onPressed, this.icon});
+
+  final String label;
+  final IconData? icon;
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final style = TypeRoles.button.style(p.buttonText);
+    return Semantics(
+      button: true,
+      child: GestureDetector(
+        onTap: onPressed,
+        child: DecoratedBox(
+          decoration: _pill(p.buttonTop, p.buttonBottom, p.buttonBorder),
+          child: Padding(
+            padding: StandIns.buttonPadding,
+            child: Row(mainAxisSize: MainAxisSize.min, children: [
+              if (icon != null) ...[
+                ExcludeSemantics(child: Icon(icon, size: style.fontSize! * 1.4, color: p.buttonText)),
+                const SizedBox(width: 8),
+              ],
+              Text(label, style: style),
+            ]),
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// The record button: the biggest thing on the journal's screen, the
+/// terracotta gradient, its words in white (main-path.md, The Journal).
+class RecordButton extends StatelessWidget {
+  const RecordButton({super.key, required this.onPressed});
+
+  static const buttonKey = Key('record-button');
+
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Semantics(
+      button: true,
+      child: GestureDetector(
+        key: buttonKey,
+        onTap: onPressed,
+        child: Container(
+          constraints: const BoxConstraints(minHeight: StandIns.recordHeight, minWidth: StandIns.recordWidth),
+          decoration: _pill(p.recordTop, p.recordBottom),
+          padding: StandIns.buttonPadding,
+          alignment: Alignment.center,
+          child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(p.recordText)),
+        ),
+      ),
+    );
+  }
+}
+
+/// A surface: a journal row or a dreamer's bubble (color.surface, radius).
+BoxDecoration surface(Palette p) => BoxDecoration(
+      gradient: LinearGradient(
+          begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [p.surfaceTop, p.surfaceBottom]),
+      borderRadius: BorderRadius.circular(Spacing.radius),
+      border: Border.all(color: p.surfaceBorder),
+    );
+
+/// A dream in the dreamer's bubble, from the right (Spacing.bubbleDreamer).
+class DreamBubble extends StatelessWidget {
+  const DreamBubble(this.text, {super.key, required this.onTap});
+
+  final String text;
+  final VoidCallback onTap;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Padding(
+      padding: Spacing.bubbleDreamer,
+      child: Align(
+        alignment: Alignment.centerRight,
+        child: GestureDetector(
+          onTap: onTap,
+          child: DecoratedBox(
+            decoration: surface(p),
+            child: Padding(
+              padding: StandIns.bubblePadding,
+              child: Text(text, style: TypeRoles.voiceDreamer.style(p.text)),
+            ),
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// The back control, top left: an arrow whose spoken name is MP·14.
+class BackControl extends StatelessWidget {
+  const BackControl({super.key, required this.onPressed});
+
+  static const buttonKey = Key('back');
+
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) => IconButton(
+        key: buttonKey,
+        onPressed: onPressed,
+        tooltip: Lines.MP_14.text(appLanguage),
+        icon: Icon(Icons.arrow_back_ios_new, color: Palette.of(context).text),
+      );
+}
diff --git a/app/test/core/app_line_test.dart b/app/test/core/app_line_test.dart
new file mode 100644
index 0000000..7320d2e
--- /dev/null
+++ b/app/test/core/app_line_test.dart
@@ -0,0 +1,52 @@
+// The app's own words, word by word at about 60 ms a word (D58 Q17);
+// whole with Reduce Motion; always whole to a screen reader.
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/app_line.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+const style = TextStyle(fontSize: 18, color: Color(0xFF333333));
+
+/// How many of the line's words are shown (not transparent).
+int shown(WidgetTester tester) {
+  final rich = tester.widget<RichText>(find.descendant(of: find.byType(AppLine), matching: find.byType(RichText)));
+  var n = 0;
+  (rich.text as TextSpan).visitChildren((span) {
+    if (span is TextSpan && span.text != null && span.style?.color != const Color(0x00000000)) n++;
+    return true;
+  });
+  return n;
+}
+
+void main() {
+  final line = Lines.C4_P_5.text(Lang.en);
+  final words = line.split(' ').length;
+
+  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
+      Directionality(textDirection: TextDirection.ltr, child: Center(child: AppLine(line, style: style))));
+
+  testWidgets('one word, then one more every 60 ms', (tester) async {
+    await pump(tester);
+    expect(shown(tester), 1);
+    await tester.pump(wordPace);
+    expect(shown(tester), 2);
+    await tester.pump(wordPace * (words - 2));
+    expect(shown(tester), words);
+    await tester.pump(wordPace * 3);
+    expect(shown(tester), words);
+  });
+
+  testWidgets('with Reduce Motion the line stands whole', (tester) async {
+    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(reduceMotion: true);
+    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
+    await pump(tester);
+    expect(shown(tester), words);
+  });
+
+  testWidgets('a screen reader hears the whole line at once', (tester) async {
+    final handle = tester.ensureSemantics();
+    await pump(tester);
+    expect(find.bySemanticsLabel(line), findsOneWidget);
+    handle.dispose();
+  });
+}
~~~~

### Task 9 · The typing screen (P2 to P4, P10, P12; D58 Q4)

`typing_page.dart` (see Part 1).

`JournalStore.newQueueForTests()` is `@visibleForTesting`. It exists because the store's one queue (D54) is static,
and a widget test's fake-async zone strands it for the next test: each widget test renews it inside its own zone.
App code never calls it.

Test support:
- `memory_journal_files.dart`;
- `pages/harness.dart` (an in-memory journal on the fake Stockholm clock, inside the app; `Opener`; `keep`).

Tests: `typing_page_test.dart` (8).

Expected: 100 tests. Commit:

> Journal: the typing screen; the store's queue renewed per widget test (P2 to P4, P10, P12; D58 Q4)

**The block** (from the proof's `21e9f98`):

~~~~diff
diff --git a/app/lib/journal/journal_store.dart b/app/lib/journal/journal_store.dart
index a65e6e5..8f15dce 100644
--- a/app/lib/journal/journal_store.dart
+++ b/app/lib/journal/journal_store.dart
@@ -12,6 +12,8 @@
 // deleted. A save that fails removes its own temporary file.
 import 'dart:typed_data';
 
+import 'package:flutter/foundation.dart' show visibleForTesting;
+
 import '../core/safe_log.dart';
 import 'journal_files.dart';
 import 'night.dart';
@@ -36,6 +38,12 @@ final class JournalStore {
   // another queued one.
   static Future<void> _tail = Future<void>.value();
 
+  /// Starts a new queue. For widget tests only: each test runs in its own
+  /// fake-async zone, and a queue left by an earlier test's zone never
+  /// moves again in the next one.
+  @visibleForTesting
+  static void newQueueForTests() => _tail = Future<void>.value();
+
   static Future<T> _run<T>(Future<T> Function() operation) {
     final result = _tail.then((_) => operation());
     _tail = result.then<void>((_) {}, onError: (_) {});
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
new file mode 100644
index 0000000..dbe27bf
--- /dev/null
+++ b/app/lib/journal/pages/typing_page.dart
@@ -0,0 +1,136 @@
+// The typing screen (main-path.md, Recording, as P2 to P4, P12 and D58
+// shape it): the top line (MP·10 on first use, MP·32 after), the field
+// only, never tonight's earlier dreams, with MP·12 as its placeholder;
+// Save (MP·13) bottom right; Back (MP·14) top left, which saves just like
+// Save; Save carries a sleeping-person icon (Material's "hotel", a
+// stand-in until the founder's own). The same screen, filled with a dream, edits it (D58 Q4). The
+// keyboard follows the phone's own settings (P12; D57 Q10). Not built:
+// the record button and Start Interpretation.
+import 'package:flutter/material.dart';
+
+import '../../core/app_line.dart';
+import '../../core/language.dart';
+import '../../design/palette.dart';
+import '../../design/stand_ins.dart';
+import '../../design/tokens.g.dart';
+import '../../words/lines.g.dart';
+import '../journal.dart';
+import '../night_rules.dart';
+import 'parts.dart';
+
+/// A dream to edit: its night, its place, its text.
+typedef DreamEdit = ({String id, int index, String text});
+
+class TypingPage extends StatefulWidget {
+  const TypingPage({super.key, required this.journal, required this.target, this.edit});
+
+  static const fieldKey = Key('typing-field');
+  static const saveKey = Key('typing-save');
+
+  final Journal journal;
+
+  /// Where a new dream is saved, fixed when the screen opened (P10).
+  final Target target;
+
+  /// The dream being edited, or null for a new one.
+  final DreamEdit? edit;
+
+  @override
+  State<TypingPage> createState() => _TypingPageState();
+}
+
+class _TypingPageState extends State<TypingPage> {
+  late final _text = TextEditingController(text: widget.edit?.text);
+  bool? _firstUse;
+  bool _saving = false;
+
+  @override
+  void initState() {
+    super.initState();
+    widget.journal.firstUseSeen().then((seen) async {
+      if (!seen) await widget.journal.markFirstUseSeen();
+      if (mounted) setState(() => _firstUse = !seen);
+    });
+  }
+
+  @override
+  void dispose() {
+    _text.dispose();
+    super.dispose();
+  }
+
+  Future<void> _save() async {
+    if (_saving) return;
+    _saving = true;
+    final e = widget.edit;
+    if (e == null) {
+      await widget.journal.addDream(widget.target, _text.text, appLanguage);
+    } else {
+      await widget.journal.editDream(e.id, e.index, _text.text);
+    }
+    if (mounted) Navigator.of(context).pop();
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final edge = OutlineInputBorder(
+      borderRadius: BorderRadius.circular(Spacing.radius),
+      borderSide: BorderSide(color: p.fieldBorder),
+    );
+    final first = _firstUse;
+    return PopScope(
+      canPop: false,
+      onPopInvokedWithResult: (didPop, _) {
+        if (!didPop) _save();
+      },
+      child: Scaffold(
+        body: SafeArea(
+          child: Padding(
+            padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
+            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
+              Align(alignment: Alignment.centerLeft, child: BackControl(onPressed: _save)),
+              if (first != null)
+                AppLine((first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),
+                    style: TypeRoles.voiceApp.style(p.text)),
+              const SizedBox(height: StandIns.gap),
+              Expanded(
+                child: TextField(
+                  key: TypingPage.fieldKey,
+                  controller: _text,
+                  autofocus: true,
+                  expands: true,
+                  maxLines: null,
+                  keyboardType: TextInputType.multiline,
+                  textCapitalization: TextCapitalization.sentences,
+                  textAlignVertical: TextAlignVertical.top,
+                  style: TypeRoles.voiceDreamer.style(p.fieldText),
+                  cursorColor: p.fieldText,
+                  decoration: InputDecoration(
+                    hintText: Lines.MP_12.text(appLanguage),
+                    hintStyle: TypeRoles.button.style(p.placeholder),
+                    filled: true,
+                    fillColor: p.field,
+                    contentPadding: StandIns.fieldPadding,
+                    border: edge,
+                    enabledBorder: edge,
+                    focusedBorder: edge,
+                  ),
+                ),
+              ),
+              const SizedBox(height: StandIns.gap),
+              Align(
+                alignment: Alignment.centerRight,
+                child: KeyedSubtree(
+                  key: TypingPage.saveKey,
+                  child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
+                ),
+              ),
+              const SizedBox(height: StandIns.gap),
+            ]),
+          ),
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/test/journal/memory_journal_files.dart b/app/test/journal/memory_journal_files.dart
new file mode 100644
index 0000000..5241b6c
--- /dev/null
+++ b/app/test/journal/memory_journal_files.dart
@@ -0,0 +1,47 @@
+// The journal's folder in memory, for the pages' widget tests: the same
+// rules as the phone's (journal_files.dart), no disk.
+import 'dart:typed_data';
+
+import 'package:souldreams/journal/journal_files.dart';
+
+class MemoryJournalFiles implements JournalFiles {
+  final files = <String, Uint8List>{};
+
+  void _check(String name) {
+    if (!validName(name)) throw ArgumentError('name');
+  }
+
+  @override
+  Future<void> open() async {}
+
+  @override
+  Future<List<String>> list() async => files.keys.toList()..sort();
+
+  @override
+  Future<Uint8List?> read(String name) async {
+    _check(name);
+    return files[name];
+  }
+
+  @override
+  Future<void> write(String name, Uint8List bytes) async {
+    _check(name);
+    files[name] = Uint8List.fromList(bytes);
+  }
+
+  @override
+  Future<void> rename(String from, String to) async {
+    _check(from);
+    _check(to);
+    files[to] = files.remove(from)!;
+  }
+
+  @override
+  Future<void> delete(String name) async {
+    _check(name);
+    files.remove(name);
+  }
+
+  @override
+  Future<void> deleteAll() async => files.clear();
+}
diff --git a/app/test/journal/pages/harness.dart b/app/test/journal/pages/harness.dart
new file mode 100644
index 0000000..f79f616
--- /dev/null
+++ b/app/test/journal/pages/harness.dart
@@ -0,0 +1,82 @@
+// The pages' widget tests: an in-memory journal on a fake Stockholm clock,
+// inside the app (theme, localizations, cover), with every night from
+// fixtures/invented-nights.json (R2).
+import 'dart:math';
+
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/night_rules.dart';
+import 'package:souldreams/words/lines.g.dart' show Lang;
+
+import '../../fixtures.dart';
+
+import '../memory_journal_files.dart';
+import '../zones.dart';
+
+final class Harness {
+  Harness._(this.files, this.store, this.journal);
+
+  final MemoryJournalFiles files;
+  final JournalStore store;
+  final Journal journal;
+
+  /// The journal's clock, in UTC; tests move it.
+  static DateTime clock = stockholm(2026, 6, 10, 12);
+
+  static Future<Harness> make() async {
+    clock = stockholm(2026, 6, 10, 12);
+    JournalStore.newQueueForTests();
+    final files = MemoryJournalFiles();
+    final store = await JournalStore.open(files);
+    final journal = Journal(store, zone: const FakeStockholm(), now: () => clock, random: Random(5));
+    return Harness._(files, store, journal);
+  }
+
+  Future<List<Night>> nights() => journal.newestFirst();
+
+  /// The app at noon, so in the light theme, opening on [home].
+  Future<void> pump(WidgetTester tester, Widget home) async {
+    await tester.pumpWidget(SoulDreamsApp(home: home, clock: () => DateTime(2026, 6, 10, 12)));
+    await tester.pumpAndSettle();
+  }
+}
+
+/// Saves the invented night [key] as begun at [at] (Stockholm).
+Future<Night> keep(Harness h, String key, DateTime at) async {
+  final n = invented(key);
+  final lang = Lang.values.byName(n.lang);
+  final target = NewNight(at);
+  await h.journal.addDream(target, n.dreams.first, lang);
+  final made = (await h.nights()).firstWhere((x) => x.firstRecorded == at);
+  for (final d in n.dreams.skip(1)) {
+    await h.journal.addDream(IntoNight(made.id), d, lang);
+  }
+  return (await h.journal.night(made.id))!;
+}
+
+/// A first page with one control that opens [page].
+class Opener extends StatelessWidget {
+  const Opener(this.page, {super.key});
+
+  static const openKey = Key('open');
+
+  final Future<Widget> Function() page;
+
+  @override
+  Widget build(BuildContext context) => Scaffold(
+        body: Center(
+          child: IconButton(
+            key: openKey,
+            icon: const Icon(Icons.add),
+            onPressed: () async {
+              final next = await page();
+              if (context.mounted) await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => next));
+            },
+          ),
+        ),
+      );
+}
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
new file mode 100644
index 0000000..a74965c
--- /dev/null
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -0,0 +1,118 @@
+// The typing screen (P2 to P4, P10, P12; D58 Q4): the field only, MP·12
+// as its placeholder, MP·10 once then MP·32; Save and Back keep the text
+// as a new dream; an empty Save keeps nothing; an edit replaces.
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/journal/pages/typing_page.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+import '../../fixtures.dart';
+import 'harness.dart';
+
+void main() {
+  final dreams = invented('two-dreams-en').dreams;
+
+  Future<Harness> open(WidgetTester tester, {DreamEdit? edit}) async {
+    final h = await Harness.make();
+    await h.pump(
+        tester,
+        Opener(() async =>
+            TypingPage(journal: h.journal, target: await h.journal.targetNow(), edit: edit)));
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    return h;
+  }
+
+  testWidgets('the field only, with MP·12 as its placeholder', (tester) async {
+    final h = await open(tester);
+    await h.journal.addDream(await h.journal.targetNow(), dreams[0], Lang.en);
+    expect(find.byKey(TypingPage.fieldKey), findsOneWidget);
+    expect(find.text(Lines.MP_12.text(Lang.en)), findsOneWidget);
+    // Never tonight's earlier dreams (P2).
+    expect(find.textContaining(dreams[0]), findsNothing);
+    expect(find.text(Lines.MP_13.text(Lang.en)), findsOneWidget);
+  });
+
+  testWidgets('MP·10 on first use, MP·32 after', (tester) async {
+    final h = await open(tester);
+    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsOneWidget);
+    await tester.tap(find.byKey(BackControl.buttonKey));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    expect(find.bySemanticsLabel(Lines.MP_32.text(Lang.en)), findsOneWidget);
+    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsNothing);
+    expect(await h.journal.firstUseSeen(), isTrue);
+  });
+
+  testWidgets('Save keeps the text as a new dream and goes back', (tester) async {
+    final h = await open(tester);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsNothing);
+    expect([for (final n in await h.nights()) n.dreams], [
+      [dreams[0]]
+    ]);
+  });
+
+  testWidgets('Back saves like Save; a second Save adds a dream', (tester) async {
+    final h = await open(tester);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
+    await tester.tap(find.byKey(BackControl.buttonKey));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[1]);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect([for (final n in await h.nights()) n.dreams], [dreams]);
+  });
+
+  testWidgets("the system's back gesture saves too", (tester) async {
+    final h = await open(tester);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
+    await tester.binding.handlePopRoute();
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsNothing);
+    expect((await h.nights()).single.dreams, [dreams[0]]);
+  });
+
+  testWidgets('an empty Save keeps nothing', (tester) async {
+    final h = await open(tester);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), ' \n ');
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsNothing);
+    expect(await h.nights(), isEmpty);
+    expect(h.files.files.keys.where((n) => n.startsWith('night-')), isEmpty);
+  });
+
+  testWidgets('an edit opens filled, and Save replaces the dream', (tester) async {
+    final h = await Harness.make();
+    await h.journal.addDream(await h.journal.targetNow(), dreams[0], Lang.en);
+    final id = (await h.nights()).single.id;
+    await h.pump(
+        tester,
+        Opener(() async => TypingPage(
+            journal: h.journal, target: await h.journal.targetNow(), edit: (id: id, index: 0, text: dreams[0]))));
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    expect(find.text(dreams[0]), findsOneWidget);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[1]);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect((await h.nights()).single.dreams, [dreams[1]]);
+  });
+
+  testWidgets("the keyboard follows the phone's own settings (P12)", (tester) async {
+    await open(tester);
+    // As the field resolves them: nothing turned off by the app.
+    final field = tester.widget<EditableText>(find.byType(EditableText));
+    expect(field.autocorrect, isTrue);
+    expect(field.enableSuggestions, isTrue);
+    expect(field.textCapitalization, TextCapitalization.sentences);
+    expect(field.keyboardType, TextInputType.multiline);
+  });
+}
~~~~

### Task 10 · A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8, Q11)

`night_page.dart` (see Part 1). The confirmation is `CupertinoAlertDialog`: C4-P·4, then `PendingLines.MP_61`, then
`PendingLines.MP_60` with `isDestructiveAction`. Outside Dev, and in tests, the two show their handles.

Tests: `night_page_test.dart` (11).

Expected: 111 tests. Commit:

> Journal: a night's page: header, Dreams, editing, Add dreams, the menu and its one confirmation (P1, P6, P7; D58 Q1, Q3, Q4, Q8, Q11)

**The block** (from the proof's `ba7dd34`):

~~~~diff
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
new file mode 100644
index 0000000..257ff8f
--- /dev/null
+++ b/app/lib/journal/pages/night_page.dart
@@ -0,0 +1,150 @@
+// Inside a night, not yet read (main-path.md, The Journal, designs 2 and
+// 3; P1, P6, P7; D58 Q1, Q4, Q8): the header (the date, or the name and
+// the date); the "⋯" menu top right, spoken as MP·39, holding only
+// "delete this night" (EM·11's second part), plain; one confirmation, the
+// phone's standard dialog, Cancel first and Delete destructive (MP·61,
+// MP·60, pending lines); the dreams under "Dreams" (MP·38), each opening
+// the typing screen to edit it; "Add dreams" (MP·29). Not built: naming,
+// Start Interpretation, and the space below the dreams.
+import 'package:flutter/cupertino.dart';
+import 'package:flutter/material.dart';
+
+import '../../core/language.dart';
+import '../../design/palette.dart';
+import '../../design/stand_ins.dart';
+import '../../design/tokens.g.dart';
+import '../../words/lines.g.dart';
+import '../../words/pending.g.dart';
+import '../journal.dart';
+import '../night.dart';
+import '../night_rules.dart';
+import '../row_text.dart';
+import 'parts.dart';
+import 'typing_page.dart';
+
+class NightPage extends StatefulWidget {
+  const NightPage({super.key, required this.journal, required this.id});
+
+  static const menuKey = Key('night-menu');
+  static const deleteKey = Key('night-delete');
+  static const addKey = Key('night-add');
+
+  final Journal journal;
+  final String id;
+
+  @override
+  State<NightPage> createState() => _NightPageState();
+}
+
+class _NightPageState extends State<NightPage> {
+  Night? _night;
+
+  @override
+  void initState() {
+    super.initState();
+    _load();
+  }
+
+  // A night gone (every dream emptied) leaves its page (P10).
+  Future<void> _load() async {
+    final n = await widget.journal.night(widget.id);
+    if (!mounted) return;
+    if (n == null) {
+      Navigator.of(context).pop();
+      return;
+    }
+    setState(() => _night = n);
+  }
+
+  Future<void> _type(DreamEdit? edit) async {
+    final page = TypingPage(journal: widget.journal, target: IntoNight(widget.id), edit: edit);
+    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
+    await _load();
+  }
+
+  Future<void> _delete() async {
+    final yes = await showCupertinoDialog<bool>(
+      context: context,
+      builder: (context) => CupertinoAlertDialog(
+        content: Text(Lines.C4_P_4.text(appLanguage)),
+        actions: [
+          CupertinoDialogAction(
+            onPressed: () => Navigator.of(context).pop(false),
+            child: Text(PendingLines.MP_61.text(appLanguage)),
+          ),
+          CupertinoDialogAction(
+            isDestructiveAction: true,
+            onPressed: () => Navigator.of(context).pop(true),
+            child: Text(PendingLines.MP_60.text(appLanguage)),
+          ),
+        ],
+      ),
+    );
+    if (yes != true) return;
+    await widget.journal.delete(widget.id);
+    if (mounted) Navigator.of(context).pop();
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final n = _night;
+    return Scaffold(
+      body: SafeArea(
+        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
+          Row(children: [
+            BackControl(onPressed: () => Navigator.of(context).pop()),
+            const Spacer(),
+            PopupMenuButton<int>(
+              key: NightPage.menuKey,
+              tooltip: Lines.MP_39.text(appLanguage),
+              icon: Icon(Icons.more_horiz, color: p.text),
+              onSelected: (_) => _delete(),
+              itemBuilder: (context) => [
+                PopupMenuItem<int>(
+                  key: NightPage.deleteKey,
+                  value: 0,
+                  child: Text(Lines.EM_11.parts(appLanguage)[1], style: TypeRoles.button.style(p.text)),
+                ),
+              ],
+            ),
+          ]),
+          if (n != null)
+            Expanded(
+              child: ListView(
+                padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
+                children: [
+                  Padding(
+                    padding: Spacing.nightHeader,
+                    child: Semantics(
+                      header: true,
+                      child: n.name == null
+                          ? Text(dayDigits(n.date), style: TypeRoles.h2.style(p.text))
+                          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
+                              Text(n.name!, style: TypeRoles.h2.style(p.text)),
+                              Text(dayDigits(n.date), style: TypeRoles.button.style(p.text)),
+                            ]),
+                    ),
+                  ),
+                  Align(alignment: Alignment.centerLeft, child: SectionLabel(Lines.MP_38.text(appLanguage))),
+                  const SizedBox(height: StandIns.gap),
+                  for (final (i, d) in n.dreams.indexed) ...[
+                    DreamBubble(d, onTap: () => _type((id: n.id, index: i, text: d))),
+                    const SizedBox(height: StandIns.bubbleGap),
+                  ],
+                  const SizedBox(height: StandIns.gap),
+                  Center(
+                    child: KeyedSubtree(
+                      key: NightPage.addKey,
+                      child: PlainButton(Lines.MP_29.text(appLanguage), onPressed: () => _type(null)),
+                    ),
+                  ),
+                  const SizedBox(height: StandIns.gap),
+                ],
+              ),
+            ),
+        ]),
+      ),
+    );
+  }
+}
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
new file mode 100644
index 0000000..ab6e756
--- /dev/null
+++ b/app/test/journal/pages/night_page_test.dart
@@ -0,0 +1,159 @@
+// A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8): header, "Dreams",
+// the dreams; editing through the typing screen; Add dreams; the menu
+// holding only delete, spoken as MP·39; one confirmation, Cancel first,
+// Delete destructive; deleting leaves nothing.
+import 'package:flutter/cupertino.dart';
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/pages/night_page.dart';
+import 'package:souldreams/journal/pages/typing_page.dart';
+import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/words/lines.g.dart';
+import 'package:souldreams/words/pending.g.dart';
+
+import '../../fixtures.dart';
+import '../zones.dart';
+import 'harness.dart';
+
+void main() {
+  late Harness h;
+  late Night n;
+
+  Future<void> open(WidgetTester tester) async {
+    h = await Harness.make();
+    n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id)));
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+  }
+
+  Future<void> openMenu(WidgetTester tester) async {
+    await tester.tap(find.byKey(NightPage.menuKey));
+    await tester.pumpAndSettle();
+  }
+
+  testWidgets('the header, the label "Dreams", the dreams in order', (tester) async {
+    await open(tester);
+    expect(find.text(dayDigits(n.date)), findsOneWidget);
+    expect(find.text(Lines.MP_38.text(Lang.en)), findsOneWidget);
+    final first = tester.getTopLeft(find.text(n.dreams[0]));
+    final second = tester.getTopLeft(find.text(n.dreams[1]));
+    expect(first.dy, lessThan(second.dy));
+    expect(find.text(Lines.MP_29.text(Lang.en)), findsOneWidget);
+  });
+
+  testWidgets('"Dreams" is heard as a heading', (tester) async {
+    final handle = tester.ensureSemantics();
+    await open(tester);
+    expect(tester.getSemantics(find.text(Lines.MP_38.text(Lang.en))).flagsCollection.isHeader, isTrue);
+    handle.dispose();
+  });
+
+  testWidgets('tapping a dream opens it filled; Save replaces it', (tester) async {
+    await open(tester);
+    await tester.tap(find.text(n.dreams[1]));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsOneWidget);
+    final other = invented('one-dream-sv').dreams.single;
+    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(find.text(other), findsOneWidget);
+    expect((await h.journal.night(n.id))!.dreams, [n.dreams[0], other]);
+  });
+
+  testWidgets('an emptied dream disappears; the others remain', (tester) async {
+    await open(tester);
+    await tester.tap(find.text(n.dreams[0]));
+    await tester.pumpAndSettle();
+    await tester.enterText(find.byKey(TypingPage.fieldKey), '  ');
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(NightPage), findsOneWidget);
+    expect(find.text(n.dreams[0]), findsNothing);
+    expect((await h.journal.night(n.id))!.dreams, [n.dreams[1]]);
+  });
+
+  testWidgets('a night emptied of every dream leaves, deleted', (tester) async {
+    await open(tester);
+    for (final d in n.dreams) {
+      await tester.tap(find.text(d));
+      await tester.pumpAndSettle();
+      await tester.enterText(find.byKey(TypingPage.fieldKey), '');
+      await tester.tap(find.byKey(TypingPage.saveKey));
+      await tester.pumpAndSettle();
+    }
+    expect(find.byType(NightPage), findsNothing);
+    expect(await h.nights(), isEmpty);
+    expect(h.files.files.keys.where((k) => k.contains(n.id)), isEmpty);
+  });
+
+  testWidgets('Add dreams adds to this night, even after its 21:00', (tester) async {
+    await open(tester);
+    Harness.clock = stockholm(2026, 6, 9, 12);
+    await tester.tap(find.byKey(NightPage.addKey));
+    await tester.pumpAndSettle();
+    final added = invented('one-dream-sv').dreams.single;
+    await tester.enterText(find.byKey(TypingPage.fieldKey), added);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect((await h.journal.night(n.id))!.dreams, [...n.dreams, added]);
+    expect(await h.nights(), hasLength(1));
+  });
+
+  testWidgets('the menu: spoken as MP·39, holding only delete, plain', (tester) async {
+    await open(tester);
+    expect(find.byTooltip(Lines.MP_39.text(Lang.en)), findsOneWidget);
+    await openMenu(tester);
+    expect(find.byType(PopupMenuItem<int>), findsOneWidget);
+    expect(find.text(Lines.EM_11.parts(Lang.en)[1]), findsOneWidget);
+    expect(find.text(Lines.MP_28.text(Lang.en)), findsNothing);
+  });
+
+  testWidgets('one confirmation: Cancel first keeps the night', (tester) async {
+    await open(tester);
+    await openMenu(tester);
+    await tester.tap(find.byKey(NightPage.deleteKey));
+    await tester.pumpAndSettle();
+    expect(find.text(Lines.C4_P_4.text(Lang.en)), findsOneWidget);
+    final actions = tester.widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction)).toList();
+    expect(actions, hasLength(2));
+    expect(actions[0].isDestructiveAction, isFalse);
+    expect(actions[1].isDestructiveAction, isTrue);
+    expect((actions[0].child as Text).data, PendingLines.MP_61.text(Lang.en));
+    expect((actions[1].child as Text).data, PendingLines.MP_60.text(Lang.en));
+    await tester.tap(find.byWidget(actions[0]));
+    await tester.pumpAndSettle();
+    expect(find.byType(NightPage), findsOneWidget);
+    expect(await h.nights(), hasLength(1));
+  });
+
+  testWidgets('Delete removes the night, leaving nothing, and goes back', (tester) async {
+    await open(tester);
+    await openMenu(tester);
+    await tester.tap(find.byKey(NightPage.deleteKey));
+    await tester.pumpAndSettle();
+    final delete = tester.widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction)).last;
+    await tester.tap(find.byWidget(delete));
+    await tester.pumpAndSettle();
+    expect(find.byType(NightPage), findsNothing);
+    expect(await h.nights(), isEmpty);
+    expect(h.files.files.keys.where((k) => k.contains(n.id)), isEmpty);
+  });
+
+  testWidgets('pending lines are placeholders outside Dev, words in Dev', (tester) async {
+    expect(PendingLines.MP_60.text(Lang.en), '[MP·60]');
+    expect(PendingLines.MP_60.text(Lang.en, flavor: 'tester'), '[MP·60]');
+    expect(PendingLines.MP_60.text(Lang.en, flavor: 'founder'), '[MP·60]');
+    expect(PendingLines.MP_60.text(Lang.en, flavor: 'dev'), isNot('[MP·60]'));
+    expect(PendingLines.MP_61.text(Lang.sv, flavor: 'dev'), isNot(PendingLines.MP_61.text(Lang.en, flavor: 'dev')));
+  });
+
+  testWidgets('text at twice the size does not overflow', (tester) async {
+    tester.platformDispatcher.textScaleFactorTestValue = 2;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await open(tester);
+    expect(tester.takeException(), isNull);
+  });
+}
~~~~

### Task 11 · The journal list (P5, P8; D57 Q5, Q6; D58 Q2, Q7)

`journal_page.dart` (see Part 1):
- the list is rebuilt on returning to the app, so the dividers follow a new year;
- the record button fixes the typing screen's target when it opens.

`fixtures/invented-nights.json` gains `long-dream-en`, one invented dream of more than 60 words, and
`fixtures_test.dart` asks for it. The fixture was committed with this plan's amendment (D59 Q9), so the block does
not touch it; this task checks it first:

```
shasum -a 256 fixtures/invented-nights.json
```

Expected: `7341767362b5ea064ed9f89d6b0f617eabba9b75d2197a52c788a4791919aafb`. A different hash: stop. Then apply the
block.

Tests: `journal_page_test.dart` (8).

Expected: 119 tests. Commit:

> Journal: the journal list: rows, month dividers, the record button, the empty journal; a long invented dream (P5, P8; D58 Q7)

**The block** (from the proof's `568198b`):

~~~~diff
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
new file mode 100644
index 0000000..7fdead5
--- /dev/null
+++ b/app/lib/journal/pages/journal_page.dart
@@ -0,0 +1,162 @@
+// The journal list, the app's home (main-path.md, The Journal, design 1;
+// C131-I items 1, 2; S5): one row per night, newest first, never a time;
+// a month divider over each month with nights; the record button bottom
+// centre; C4-P·5 when there is no night. No Settings entry and no search
+// (P8). Nothing on a row grades it: no badge, count or status.
+import 'package:flutter/material.dart';
+
+import '../../core/app_line.dart';
+import '../../core/language.dart';
+import '../../design/palette.dart';
+import '../../design/stand_ins.dart';
+import '../../design/tokens.g.dart';
+import '../../words/lines.g.dart';
+import '../journal.dart';
+import '../night.dart';
+import '../row_text.dart';
+import 'night_page.dart';
+import 'parts.dart';
+import 'typing_page.dart';
+
+class JournalPage extends StatefulWidget {
+  const JournalPage({super.key, required this.journal});
+
+  final Journal journal;
+
+  @override
+  State<JournalPage> createState() => _JournalPageState();
+}
+
+class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
+  List<Night>? _nights;
+
+  @override
+  void initState() {
+    super.initState();
+    WidgetsBinding.instance.addObserver(this);
+    _load();
+  }
+
+  @override
+  void dispose() {
+    WidgetsBinding.instance.removeObserver(this);
+    super.dispose();
+  }
+
+  // On returning, the year may have turned: the dividers are built again.
+  @override
+  void didChangeAppLifecycleState(AppLifecycleState state) {
+    if (state == AppLifecycleState.resumed) _load();
+  }
+
+  Future<void> _load() async {
+    final nights = await widget.journal.newestFirst();
+    if (mounted) setState(() => _nights = nights);
+  }
+
+  Future<void> _push(Widget page) async {
+    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
+    await _load();
+  }
+
+  // The screen's target is fixed now, when it opens (P10; D58 Q2).
+  Future<void> _record() async {
+    final target = await widget.journal.targetNow();
+    if (mounted) await _push(TypingPage(journal: widget.journal, target: target));
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final nights = _nights;
+    final year = widget.journal.zone.wall(widget.journal.now()).year;
+    return Scaffold(
+      body: SafeArea(
+        child: Stack(children: [
+          if (nights != null && nights.isEmpty)
+            Center(
+              child: Padding(
+                padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
+                child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+              ),
+            ),
+          if (nights != null && nights.isNotEmpty)
+            ListView(
+              padding: const EdgeInsets.fromLTRB(StandIns.pageSide, 0, StandIns.pageSide,
+                  StandIns.journalEnd + StandIns.recordHeight + StandIns.recordBelow),
+              children: [
+                for (final item in listItems(nights))
+                  switch (item) {
+                    MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
+                    NightItem(:final night) =>
+                      _Row(night, onTap: () => _push(NightPage(journal: widget.journal, id: night.id))),
+                  },
+              ],
+            ),
+          Positioned(
+            left: 0,
+            right: 0,
+            bottom: StandIns.recordBelow,
+            child: Center(child: RecordButton(onPressed: _record)),
+          ),
+        ]),
+      ),
+    );
+  }
+}
+
+class _Divider extends StatelessWidget {
+  const _Divider(this.text);
+
+  final String text;
+
+  @override
+  Widget build(BuildContext context) => Padding(
+        padding: const EdgeInsets.only(top: StandIns.dividerAbove, bottom: StandIns.dividerBelow),
+        child: Semantics(
+          header: true,
+          child: Text(text, style: TypeRoles.h4.style(Palette.of(context).text)),
+        ),
+      );
+}
+
+/// A night's row: an unnamed night's date (h3), or a named night's name
+/// (h5) with its date under it in the button style; then the opening,
+/// always three lines (C10-P; D58 Q7).
+class _Row extends StatelessWidget {
+  const _Row(this.night, {required this.onTap});
+
+  final Night night;
+  final VoidCallback onTap;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final summary = StandIns.summary.style(p.summary);
+    final name = night.name;
+    final lines = MediaQuery.textScalerOf(context).scale(summary.fontSize!) * summary.height! * 3;
+    return Padding(
+      padding: const EdgeInsets.only(bottom: StandIns.rowGap),
+      child: GestureDetector(
+        onTap: onTap,
+        child: Container(
+          decoration: surface(p),
+          padding: StandIns.rowPadding,
+          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
+            if (name == null)
+              Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
+            else ...[
+              Text(name, style: TypeRoles.h5.style(p.text)),
+              Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
+            ],
+            const SizedBox(height: 8),
+            ConstrainedBox(
+              constraints: BoxConstraints(minHeight: lines),
+              child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
+            ),
+          ]),
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/test/fixtures_test.dart b/app/test/fixtures_test.dart
index c8aa5a4..b3b20d1 100644
--- a/app/test/fixtures_test.dart
+++ b/app/test/fixtures_test.dart
@@ -26,5 +26,7 @@ void main() {
   test('the cases the journal tests need are there', () {
     expect(inventedNights().any((n) => n.dreams.length > 1), isTrue);
     expect(inventedNights().any((n) => n.name != null), isTrue);
+    // journal-screens: a dream long enough to be cut at three lines.
+    expect(invented('long-dream-en').dreams.single.split(' ').length, greaterThan(60));
   });
 }
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
new file mode 100644
index 0000000..1b78811
--- /dev/null
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -0,0 +1,115 @@
+// The journal list (main-path.md, The Journal; S5; D58 Q7; P5, P8): the
+// empty journal, rows newest first with no time and no count, dividers,
+// the record button opening the typing screen, a row opening its night.
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/pages/journal_page.dart';
+import 'package:souldreams/journal/pages/night_page.dart';
+import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/journal/pages/typing_page.dart';
+import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+import '../../fixtures.dart';
+import '../zones.dart';
+import 'harness.dart';
+
+void main() {
+  testWidgets('the empty journal: C4-P·5 and the record button, nothing else', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
+    expect(find.text(Lines.MP_11.text(Lang.en)), findsOneWidget);
+    // No Settings entry and no search (P8).
+    expect(find.text(Lines.MP_25.text(Lang.en)), findsNothing);
+    expect(find.byType(TextField), findsNothing);
+  });
+
+  testWidgets('rows newest first: the date, then the trimmed opening', (tester) async {
+    final h = await Harness.make();
+    final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    final newer = await keep(h, 'framed-opening-en', stockholm(2026, 6, 9, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final newDate = tester.getTopLeft(find.text(dayDigits(newer.date)));
+    final oldDate = tester.getTopLeft(find.text(dayDigits(older.date)));
+    expect(newDate.dy, lessThan(oldDate.dy));
+    expect(find.text(opening(newer)), findsOneWidget);
+    expect(find.text(newer.dreams.first), findsNothing);
+    // A row shows no time, and no count of dreams.
+    expect(find.textContaining(':'), findsNothing);
+    expect(find.textContaining('2 '), findsNothing);
+  });
+
+  testWidgets('a divider over each month with nights; years before this', (tester) async {
+    final h = await Harness.make();
+    await keep(h, 'two-dreams-en', stockholm(2025, 10, 4, 23));
+    await keep(h, 'framed-opening-en', stockholm(2026, 5, 4, 23));
+    await keep(h, 'one-dream-sv', stockholm(2026, 5, 8, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    expect(find.text(monthDivider(2026, 5, 2026, Lang.en)), findsOneWidget);
+    expect(find.text(monthDivider(2025, 10, 2026, Lang.en)), findsOneWidget);
+    expect(find.text(monthDivider(2026, 6, 2026, Lang.en)), findsNothing);
+    expect(monthDivider(2025, 10, 2026, Lang.en), endsWith(' 2025'));
+  });
+
+  testWidgets('a named night shows its name, then its date', (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 2, 23));
+    final name = invented('named-three-dreams-sv').name!;
+    // Naming is not built (P7); a name reaches the store only directly.
+    await h.store.save(Night(
+        id: n.id, firstRecorded: n.firstRecorded, date: n.date, closes: n.closes, lang: n.lang, name: name, dreams: n.dreams));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final nameAt = tester.getTopLeft(find.text(name));
+    final dateAt = tester.getTopLeft(find.text(dayDigits(n.date)));
+    expect(nameAt.dy, lessThan(dateAt.dy));
+  });
+
+  testWidgets('the summary is always three lines', (tester) async {
+    final h = await Harness.make();
+    await keep(h, 'long-dream-en', stockholm(2026, 6, 2, 23));
+    await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final long = find.textContaining(invented('long-dream-en').dreams.single.substring(0, 20));
+    final text = tester.widget<Text>(long);
+    expect(text.maxLines, 3);
+    expect(text.overflow, TextOverflow.ellipsis);
+    final short = find.text(invented('one-dream-sv').dreams.single);
+    expect(tester.getSize(short).height, closeTo(tester.getSize(long).height, 1));
+  });
+
+  testWidgets('the record button opens typing; a Save adds a row', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsOneWidget);
+    final dream = invented('one-dream-sv').dreams.single;
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dream);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(find.text(dream), findsOneWidget);
+    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsNothing);
+  });
+
+  testWidgets("a row opens its night's page", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await tester.tap(find.text(dayDigits(n.date)));
+    await tester.pumpAndSettle();
+    expect(find.byType(NightPage), findsOneWidget);
+    expect(find.text(n.dreams[1]), findsOneWidget);
+  });
+
+  testWidgets('text at twice the size does not overflow', (tester) async {
+    final h = await Harness.make();
+    await keep(h, 'long-dream-en', stockholm(2026, 6, 2, 23));
+    await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 3, 23));
+    tester.platformDispatcher.textScaleFactorTestValue = 2;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    expect(tester.takeException(), isNull);
+  });
+}
~~~~

### Task 12 · SoulDreams Dev opens on the journal; the import walk (D49 O1; D57 Q11)

- `journal_home.dart` opens the folder through the channel, then shows the list. A folder that cannot open leaves a
  blank page and logs `journalOpenFailed`, a new `LogEvent`.
- `main_dev.dart` opens on it; `KEYBOARD_CHECK` still opens the keyboard check.
- `dev_only_test.dart` follows every import, relative and `package:souldreams/`, from `main.dart` and
  `main_founder.dart`. Neither may reach `lib/journal/` or `lib/words/pending.g.dart`; Dev reaches both.
- Tests: `dev_only_test.dart` (4), `journal_home_test.dart` (2).

Expected: 126 tests. Commit:

> Dev: SoulDreams Dev opens on the journal; the tester and founder apps reach no journal code and no pending line (D49 O1; D57 Q11)

**The block** (from the proof's `0a7e543`):

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index 00c3eb6..6068e71 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -16,6 +16,9 @@ enum LogEvent {
   journalFileSkipped,
   journalCheckPassed,
   journalCheckFailed,
+
+  /// SoulDreams Dev's journal could not open its folder (journal-screens).
+  journalOpenFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
new file mode 100644
index 0000000..cb09381
--- /dev/null
+++ b/app/lib/journal/pages/journal_home.dart
@@ -0,0 +1,38 @@
+// SoulDreams Dev's first page (D49 O1; D56): it opens the journal's
+// folder on the phone, then shows the journal list. Until the folder is
+// open the page is blank; if it cannot be opened it stays blank and logs
+// a code, never a night's words (R3).
+import 'package:flutter/material.dart';
+
+import '../../core/safe_log.dart';
+import '../journal.dart';
+import '../journal_files.dart';
+import '../journal_store.dart';
+import 'journal_page.dart';
+
+class JournalHome extends StatefulWidget {
+  const JournalHome({super.key, required this.files});
+
+  final JournalFiles files;
+
+  @override
+  State<JournalHome> createState() => _JournalHomeState();
+}
+
+class _JournalHomeState extends State<JournalHome> {
+  Journal? _journal;
+
+  @override
+  void initState() {
+    super.initState();
+    JournalStore.open(widget.files).then((store) {
+      if (mounted) setState(() => _journal = Journal(store));
+    }, onError: (Object _) => SafeLog.event(LogEvent.journalOpenFailed));
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final journal = _journal;
+    return journal == null ? const Scaffold() : JournalPage(journal: journal);
+  }
+}
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
index 13e1731..3aad203 100644
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -1,5 +1,5 @@
 // SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
-// nights only.
+// nights only. It opens on the journal (D49 O1; D56).
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -9,6 +9,7 @@ import 'core/flavour.dart';
 import 'core/keyboard_check.dart';
 import 'core/safe_log.dart';
 import 'journal/channel_journal_files.dart';
+import 'journal/pages/journal_home.dart';
 import 'journal/self_check.dart';
 
 void main() {
@@ -17,7 +18,9 @@ void main() {
   // The keyboard check (D50 1): only in a build made with
   // --dart-define=KEYBOARD_CHECK=true.
   runApp(SoulDreamsApp(
-      home: const bool.fromEnvironment('KEYBOARD_CHECK') ? const KeyboardCheck() : null));
+      home: const bool.fromEnvironment('KEYBOARD_CHECK')
+          ? const KeyboardCheck()
+          : const JournalHome(files: ChannelJournalFiles())));
   // The phone check (D49 c): only in a build made with
   // --dart-define=JOURNAL_SELF_CHECK=true.
   if (const bool.fromEnvironment('JOURNAL_SELF_CHECK')) {
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
new file mode 100644
index 0000000..c7143ef
--- /dev/null
+++ b/app/test/dev_only_test.dart
@@ -0,0 +1,55 @@
+// The journal and the pending lines reach SoulDreams Dev only (D49 O1;
+// D57 Q11). G8 reads direct imports only (banked item 25), so this test
+// follows every import, from each entry point, through every file it
+// reaches in lib/. `flutter test` runs in app/.
+import 'dart:io';
+
+import 'package:flutter_test/flutter_test.dart';
+
+final _import = RegExp(r"^\s*(?:import|export)\s+'([^']+)'", multiLine: true);
+
+/// Every file in lib/ that [entry] reaches through its imports.
+Set<String> reached(String entry) {
+  final seen = <String>{};
+  final todo = [entry];
+  while (todo.isNotEmpty) {
+    final path = todo.removeLast();
+    if (!seen.add(path)) continue;
+    final text = File(path).readAsStringSync().split('\n').map((l) => l.split('//').first).join('\n');
+    for (final m in _import.allMatches(text)) {
+      final uri = m[1]!;
+      if (uri.startsWith('dart:')) continue;
+      if (uri.startsWith('package:')) {
+        if (uri.startsWith('package:souldreams/')) todo.add('lib/${uri.substring(19)}');
+        continue;
+      }
+      todo.add(Uri.parse(path).resolve(uri).path);
+    }
+  }
+  return seen;
+}
+
+void main() {
+  const pending = 'lib/words/pending.g.dart';
+
+  for (final entry in ['lib/main.dart', 'lib/main_founder.dart']) {
+    test('$entry reaches no journal code and no pending line', () {
+      final files = reached(entry);
+      expect(files, contains('lib/app.dart'));
+      expect(files.where((f) => f.startsWith('lib/journal/')), isEmpty);
+      expect(files, isNot(contains(pending)));
+    });
+  }
+
+  test('SoulDreams Dev reaches the journal pages and the pending lines', () {
+    final files = reached('lib/main_dev.dart');
+    expect(files, contains('lib/journal/pages/journal_page.dart'));
+    expect(files, contains('lib/journal/pages/night_page.dart'));
+    expect(files, contains(pending));
+  });
+
+  test('the walk follows relative and package imports', () {
+    final files = reached('lib/journal/pages/night_page.dart');
+    expect(files, containsAll(['lib/words/pending.g.dart', 'lib/journal/night.dart', 'lib/design/tokens.g.dart']));
+  });
+}
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
new file mode 100644
index 0000000..d369487
--- /dev/null
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -0,0 +1,39 @@
+// SoulDreams Dev's first page: the journal, once its folder is open.
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/pages/journal_home.dart';
+import 'package:souldreams/journal/pages/journal_page.dart';
+
+import '../memory_journal_files.dart';
+
+/// A folder that cannot be opened.
+final class Unopenable extends MemoryJournalFiles {
+  @override
+  Future<void> open() async => throw StateError('journal-io');
+}
+
+void main() {
+  // The queue is renewed inside each test's own zone (journal_store.dart).
+  testWidgets('it opens the folder, then shows the journal', (tester) async {
+    JournalStore.newQueueForTests();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: MemoryJournalFiles())));
+    await tester.pumpAndSettle();
+    expect(find.byType(JournalPage), findsOneWidget);
+  });
+
+  testWidgets('a folder that cannot open: a blank page, a code', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: Unopenable())));
+    await tester.pumpAndSettle();
+    expect(find.byType(JournalPage), findsNothing);
+    expect(find.byType(Scaffold), findsOneWidget);
+    expect(lines, ['journalOpenFailed']);
+  });
+}
~~~~

### Task 13 · The app mutations A25 to A39

`tool/app_mutations.py` gains fifteen rows:
- the 21:00 comparison;
- the latest open night;
- the empty Save;
- the emptied dream;
- the emptied night;
- the target fixed at opening;
- TECH·1 as a whole phrase, and ignoring case;
- the year on a divider;
- Reduce Motion, in the fade and in the line;
- the fade itself;
- the word pace;
- the one confirmation;
- `main.dart` importing the journal.

`typing_page_test.dart` gains the test A30 needs: a screen open across 21:00 saves into its own night.

Expected:
- `+126: All tests passed!`;
- `python3 -I -B tool/app_mutations.py` ends `app mutations: 39 run, 39 caught` (about ten minutes);
- `git status` clean after.

Commit:

> Journal: the app mutations A25 to A39, and the typing test across 21:00

**The block** (from the proof's `0afbdf1`):

~~~~diff
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index a74965c..e0ca749 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -8,6 +8,7 @@ import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/words/lines.g.dart';
 
 import '../../fixtures.dart';
+import '../zones.dart';
 import 'harness.dart';
 
 void main() {
@@ -79,6 +80,20 @@ void main() {
     expect((await h.nights()).single.dreams, [dreams[0]]);
   });
 
+  testWidgets('a screen open across 21:00 saves into its own night', (tester) async {
+    final h = await Harness.make();
+    Harness.clock = stockholm(2026, 6, 10, 20, 58);
+    await h.journal.addDream(await h.journal.targetNow(), dreams[0], Lang.en);
+    await h.pump(tester, Opener(() async => TypingPage(journal: h.journal, target: await h.journal.targetNow())));
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    Harness.clock = stockholm(2026, 6, 10, 21, 2);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[1]);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect([for (final n in await h.nights()) n.dreams], [dreams]);
+  });
+
   testWidgets('an empty Save keeps nothing', (tester) async {
     final h = await open(tester);
     await tester.enterText(find.byKey(TypingPage.fieldKey), ' \n ');
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 3ec13f4..3e59d1a 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,6 +1,6 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
-# Expected: A1 to A24 each "caught", then "app mutations: 24 run, 24
+# Expected: A1 to A39 each "caught", then "app mutations: 39 run, 39
 # caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
@@ -129,6 +129,70 @@ ROWS = [
      "    if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');\n",
      '',
      'test/journal/night_test.dart', 'a date its file could not hold is refused'),
+    # journal-screens: the night rules and the journal's operations
+    ('A25', 'lib/journal/night_rules.dart',
+     'return same.isAfter(first) ? same',
+     'return !same.isBefore(first) ? same',
+     'test/journal/night_rules_test.dart', '20:59 closes a minute later; 21:00 itself starts a new night'),
+    ('A26', 'lib/journal/night_rules.dart',
+     'if (c > 0 || (c == 0',
+     'if (c < 0 || (c == 0',
+     'test/journal/night_rules_test.dart', "tonight's night is the latest one not yet closed"),
+    ('A27', 'lib/journal/journal.dart',
+     '    if (isEmptyText(text)) return false;\n',
+     '',
+     'test/journal/journal_test.dart', 'an empty Save keeps nothing'),
+    ('A28', 'lib/journal/journal.dart',
+     '      dreams.removeAt(index);',
+     '      dreams[index] = text;',
+     'test/journal/journal_test.dart', 'an edit replaces the dream; an emptied dream disappears'),
+    ('A29', 'lib/journal/journal.dart',
+     '    if (dreams.isEmpty) {',
+     '    if (false) {',
+     'test/journal/journal_test.dart', 'a night whose every dream is emptied is deleted, nothing left'),
+    ('A30', 'lib/journal/pages/typing_page.dart',
+     'await widget.journal.addDream(widget.target, ',
+     'await widget.journal.addDream(await widget.journal.targetNow(), ',
+     'test/journal/pages/typing_page_test.dart', 'a screen open across 21:00 saves into its own night'),
+    # the rows
+    ('A31', 'lib/journal/row_text.dart',
+     '    if (dream.length > f.length && _wordChar.hasMatch(dream[f.length])) continue;\n',
+     '',
+     'test/journal/row_text_test.dart', 'a framing is trimmed only whole, at the start'),
+    ('A32', 'lib/journal/row_text.dart',
+     '.toLowerCase() != f.toLowerCase()',
+     ' != f',
+     'test/journal/row_text_test.dart', 'each framing is trimmed from the very start, ignoring case'),
+    ('A33', 'lib/journal/row_text.dart',
+     'final words = year == currentYear',
+     'final words = false',
+     'test/journal/row_text_test.dart', 'a divider: the month alone this year, month and year before'),
+    # motion
+    ('A34', 'lib/core/night_day.dart',
+     'return f.reduceMotion || f.disableAnimations;',
+     'return f.disableAnimations;',
+     'test/core/night_day_test.dart', 'with Reduce Motion the change is instant'),
+    ('A35', 'lib/core/night_day.dart',
+     '? NightDay.fade : Duration.zero',
+     '? Duration.zero : Duration.zero',
+     'test/core/night_day_test.dart', 'at 21:00 the open app fades to dark over five seconds'),
+    ('A36', 'lib/core/app_line.dart',
+     'if (f.reduceMotion || f.disableAnimations) {',
+     'if (f.disableAnimations) {',
+     'test/core/app_line_test.dart', 'with Reduce Motion the line stands whole'),
+    ('A37', 'lib/core/app_line.dart',
+     '    _shown = 1;\n',
+     '    _shown = _words.length;\n',
+     'test/core/app_line_test.dart', 'one word, then one more every 60 ms'),
+    # deleting, and Dev only
+    ('A38', 'lib/journal/pages/night_page.dart',
+     '    if (yes != true) return;\n',
+     '',
+     'test/journal/pages/night_page_test.dart', 'one confirmation: Cancel first keeps the night'),
+    ('A39', 'lib/main.dart',
+     "import 'core/safe_log.dart';\n",
+     "import 'core/safe_log.dart';\nimport 'journal/journal.dart';\n",
+     'test/dev_only_test.dart', 'lib/main.dart reaches no journal code and no pending line'),
 ]
 
 
~~~~

### Task 14 · [OWNER + Opus] The stand-ins from the screenshots (P13; D58 Q8)

Only after Task 4, and after the owner has said every screenshot holds invented content only.

Claude Code (Opus) opens each screenshot and changes **only the numbers** in `app/lib/design/stand_ins.dart`,
and the summary's type role among `TypeRoles`. Nothing else, no new name, no word.

**Not proven here:** the screenshots were not available to the proof, so no block is given. That is Part 4's Q2.

The task reports a table: each stand-in, its first value, its measured value, and the screenshot it came from. If a
screenshot shows something the code cannot do by changing a number, it goes to the owner as a question and is not
built:
- an unread night's dreams not in bubbles (D58 Q8);
- a different menu;
- an icon.

Then:
- the app's tests at 126, every one still green;
- the app mutations `39 run, 39 caught`.

Commit:

> Design: the stand-ins measured from the founder's screenshots (P13)

### Task 15 · [OWNER] The phone checks, SoulDreams Dev, invented nights only

1. Remove SoulDreams Dev from the phone (its earlier invented nights have no `closes`, D57 Q14), then build and
   install it as usual.
2. Run these checks, typing only text from `fixtures/invented-nights.json`.

**The empty journal and typing**
- The empty journal shows C4-P·5, word by word, and the record button.
- The record button opens the typing screen.
  - The first time: MP·10 at the top. Every later time: MP·32.
  - The field is empty, with MP·12 in grey.
  - The keyboard is the phone's own: autocorrect, suggestions and auto-capitals as the phone's Settings say.
- Save keeps the dream. The back arrow and the edge swipe keep it too. An empty Save keeps nothing.

**The list and a night's page**
- A row shows the date (no time) and the first dream cut at three lines.
- A night's page:
  - the date, "Dreams", then the dreams;
  - tapping a dream opens it filled, to edit;
  - emptying a dream removes it;
  - emptying every dream removes the night.
- "⋯":
  - VoiceOver reads MP·39;
  - it holds one item;
  - the confirmation shows Cancel first and Delete in red, with the pending words;
  - Cancel keeps the night; Delete removes it.

**The 21:00 rule and the theme** (Settings → General → Date & Time, automatic off; restore it after)
- A dream saved before 21:00 and one after are two nights.
- A typing screen opened at 20:59 and saved after 21:00 joins the 20:59 night.
- A night started in one time zone, then the zone changed before 21:00: the date stays, and it closes at the first
  zone's 21:00.
- The theme turns dark at 21:00 over about five seconds with the app open, and light at 08:00. With Reduce Motion on
  (Settings → Accessibility → Motion), it changes at once.
- Nights in two months, and one in an earlier year: the divider names the month (capitalised), with the year only
  for the earlier year.

**Accessibility and the cover**
- Largest text size: nothing cut off.
- VoiceOver reads "Dreams" as a heading, and each app line whole.
- The app switcher card is plain in both themes.

Bring the results as a checklist (passed, or what was seen), never a screenshot of a night.

### Task 16 · Status.md and the docs

Status.md:
- this branch's state;
- the new guard and app counts;
- the pending lines under their own heading, "Pending lines, to file before Cohort 1" (the investigation's §2c,
  lock 4);
- banked items 75 to 80;
- the rulings D56 to D58.

And `CLAUDE.md`, in the owner's words ruled by D59 Q1:
- R1 gains the pending lines;
- G0 gains the two fingerprint files;
- G1 gains the pending lines and `pending.g.dart`;
- G2 gains `docs/reference/screens/`.

`CLAUDE.md` is under "ask": the owner approves the edit at the prompt.

Replace the date in "Last updated" with the day's date. Then check with:
- `python3 -I -B tool/checks/guards.py`;
- the owner's `tool/check_all.sh`, expected `check_all: all passed`.

Commit:

> Docs: Status.md at the end of journal-screens; CLAUDE.md's R1, G0, G1 and G2 lines (D56 to D59)

**The block** (from the proof's `a74a9b3`):

~~~~diff
diff --git a/CLAUDE.md b/CLAUDE.md
index 7803ddd..b57bd5c 100644
--- a/CLAUDE.md
+++ b/CLAUDE.md
@@ -15,7 +15,10 @@ numbered question. Never settle it in code.** Never edit a copy: copies change o
 ## The rules. Each one is checked; breaking one stops the task.
 
 **R1 · Words.** You never write, translate, reword or invent a dreamer-facing line, nor a word on any check list. Every
-dreamer-facing line comes from `app/lib/words/lines.g.dart`, generated from `app/assets/words/places-register.csv`. Every
+dreamer-facing line comes from `app/lib/words/lines.g.dart`, generated from `app/assets/words/places-register.csv`.
+Lines given and approved but not yet filed are pending lines: the owner writes them in
+`app/assets/words/pending-lines.csv`, fingerprinted, the generator makes `app/lib/words/pending.g.dart`, and their words
+show in SoulDreams Dev only (D57 Q11). Every
 list word comes from `app/assets/words/founder-lists-for-technology.md`. Both are copied by the owner's import after a
 hash check. A place whose status is not "written", "written, in its parts" or "composed (stand-in written)" has no line;
 an unknown status stops the generator. Where a line is missing, use the place's handle as a visible placeholder (e.g.
@@ -85,13 +88,16 @@ merge command runs all of it. The guards (built in the first task, each with a m
 
 - **G0 file kinds** — every tracked file is a kind the guards know: code, config, or an unscanned type, name or path
   listed in `tool/checks/g0_kinds.py`. Anything else, an unknown `#!` interpreter included, is refused. A branch that
-  brings a new kind of file extends the list, and the owner approves it; and `.txt` in `app/assets/fonts/` only.
+  brings a new kind of file extends the list, and the owner approves it; and `.txt` in `app/assets/fonts/` only; and the
+  pending lines' and the screenshots' fingerprints by exact path.
 - **G1 words** — the generated words (`lines.g.dart`, `lists.g.dart`, `words.g.xcconfig` and the two
   `InfoPlist.strings`) are exactly what the generator makes from the CSV and the lists, nothing else sits in
   `app/lib/words/` or `app/assets/words/`, and the CSV's and lists' hashes match `docs/source/SOURCES`; and
-  `app/lib/design/tokens.g.dart` is exactly what `designgen.py` makes from `design-system.md`.
+  `app/lib/design/tokens.g.dart` is exactly what `designgen.py` makes from `design-system.md`; and the pending lines
+  match `pending-fingerprint.txt`, and `pending.g.dart` is what the generator makes from them.
 - **G2 copies** — every file in `docs/source/` matches its listed hash; no tracked `privacy-ethics-safety.md`, and
-  nothing in a folder named `restricted`; and every file in `app/assets/fonts/` matches `fingerprints.txt`.
+  nothing in a folder named `restricted`; and every file in `app/assets/fonts/` matches `fingerprints.txt`; and every
+  file in `docs/reference/screens/` matches its `fingerprints.txt`.
 - **G3 no literal words** — no string literal shown to a dreamer outside `app/lib/words/`; any other literal of more
   than two words needs `// not-dreamer-facing: <reason>` on its line.
 - **G4 invented only** — no string literal of twelve words or more outside `fixtures/invented-nights.json`,
diff --git a/docs/Status.md b/docs/Status.md
index e836d4e..03a26b9 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-12, at the end of branch `journal-core`, by Claude Code.
+Last updated: 2026-11-12, at the end of branch `journal-screens`, by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,13 +14,12 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`journal-core`: the journal's foundations, with no screen (D49), and two app-wide protections (D50). Plan:
-`docs/plans/journal-core.md`. The screens, the night rules (the 21:00 boundary) and typing come in
-`journal-screens`, built to Product's answers to P1 to P14.
+`journal-screens`: the journal's pages in SoulDreams Dev only (D49 O1; D56): the journal list with month dividers,
+the typing screen, a night's page with editing and deleting the night, the 21:00 rule, and Night/Day automatic, built
+to Product's answers P1 to P14 and the answers of D58. Plan: `docs/plans/journal-screens.md`.
 
 ## Road ahead
 
-- `journal-screens`: the journal's pages, the night rules and typing, to Product's answers to P1 to P14 (D48, D49).
 - The first server feature, and before it the front door (banked item 44); then the first deploy, after "Before
   the first deploy" below.
 - A later branch, by the Head of Technology's direction (with D32): the import gains a kind for lens sections 3, 4, 5,
@@ -70,10 +69,35 @@ rulings given during each branch are listed in this file, one line each, under "
   third-party keyboard was not offered in SoulDreams Dev and was in Notes; the app-switcher card was plain, with no
   field, keyboard, logo, words or suggestion bar, including with an invented word typed. The backup size (optional)
   was not looked at.
-- The app's analyzer baseline: `No issues found!`. The app has 60 tests, and 24 mutation checks (A1 to A24) in
+- The journal's pages (D56), in SoulDreams Dev only: `main_dev.dart` opens on `JournalHome`, and a test follows every
+  import from `main.dart` and `main_founder.dart` to prove neither reaches `lib/journal/` or the pending lines
+  (`app/test/dev_only_test.dart`). The pages: the journal list (rows newest first, the date or the name and date,
+  the first dream cut to three lines with TECH·1's framing trimmed, month dividers, the record button, C4-P·5 when
+  empty); the typing screen (MP·10 once, then MP·32; the field only, MP·12 its placeholder; Save and Back both
+  save; the same screen edits a dream); a night's page (the header, "Dreams", the dreams, "Add dreams", the "⋯" menu
+  holding only delete, one confirmation with Cancel first and Delete destructive). No Settings, search, naming,
+  recording or Start Interpretation (P7, P8).
+- The night rules (`app/lib/journal/night_rules.dart`, `journal.dart`): a night stores its closing instant, the
+  first 21:00 after its first recording in the zone then in force (format version 1, D57 Q14); the typing screen's
+  target is fixed when it opens; an empty Save keeps nothing; an emptied dream disappears; a night with no dream left
+  is deleted (D58 Q2, Q3; P9, P10).
+- Night/Day automatic (`app/lib/core/night_day.dart`): dark 21:00 to 08:00 by the phone's clock, a five-second
+  fade while the app is open, instant with Reduce Motion (read from the platform's own flag, which iOS does not put
+  in `MediaQuery`), at start and on returning (D57 Q15). The app's own lines appear a word every 60 ms, whole with
+  Reduce Motion (`app/lib/core/app_line.dart`; D58 Q17). The palette (`app/lib/design/palette.dart`) fades with the
+  theme. The app shows English only (D57 Q12; `app/lib/core/language.dart`).
+- Packages: `flutter_localizations` (SDK) and `intl` 0.20.3, the owner's pub add (D57 Q9): the month names, and
+  Flutter's own framework words, which are not ours under R1.
+- The pending lines (D57 Q11; D58 Q11): `app/assets/words/pending-lines.csv` and its fingerprint, the owner's;
+  `wordsgen.py` makes `app/lib/words/pending.g.dart`, whose `PendingLine` is not a `Line` and shows its words in
+  SoulDreams Dev only (any other flavour gets its handle), and G1 proves both. A row whose handle the register holds
+  stops the generator (`pending-filed`).
+- Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
+  founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
+  (P13).
+- The app's analyzer baseline: `No issues found!`. The app has 126 tests, and 39 mutation checks (A1 to A39) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 24 run, 24 caught`); `check_all.sh` does not call it (D55). A night's date is a day its
-  file can hold (the final review, `a559b66`; row A24).
+  (expected: `app mutations: 39 run, 39 caught`); `check_all.sh` does not call it (D55).
 
 ## The server
 
@@ -130,7 +154,10 @@ The owner's, in this order (D42 Q10, Q12, Q16; D44 d; D45):
   (`NPM_CONFIG_UPDATE_NOTIFIER=false`; D46, proved by `test_check_all.py`).
 - G1 also proves the design values; G2 also proves every file in `app/assets/fonts/` against `fingerprints.txt`,
   armed or not; G0 knows `.txt` in `app/assets/fonts/` only (D49 a).
-- Totals: 227 guard tests and 80 mutation checks.
+- G1 also proves the pending lines against `pending-fingerprint.txt` and `pending.g.dart` against the generator; G2
+  also proves every file in `docs/reference/screens/` against its `fingerprints.txt`; G0 knows those two
+  fingerprint files by exact path (D57 Q11, D58).
+- Totals: 241 guard tests and 87 mutation checks.
 
 ## Banked
 
@@ -324,6 +351,26 @@ Banked by D17 (the reviews in journal-core; D52, D54):
     and the owner runs `tool/check_all.sh` whole. Flutter may now write `~/.dart-tool`, and the app's analyzer and
     tests run in the sandbox again.
 
+Banked in journal-screens:
+
+75. `JournalStore.newQueueForTests()`: the store's one queue (D54) is static, and a widget test's fake-async zone
+    strands it for the next test; each widget test starts a new queue inside its own zone. App code never calls it.
+76. MP·39, the menu's spoken name, names naming, which is not built (D58 Q1): as written, Dev only, until naming.
+77. The stand-ins (`stand_ins.dart`) and these choices await the founder's look in Cohort 0 (P13): the summary's type
+    role (the dreamer's voice), Material's "hotel" icon for Save's sleeping person, the back arrow, the menu's form,
+    the linear fade curve, and the dark field's absent border drawn as a transparent one.
+78. A named night's row is built (D57 Q6) but nothing in the app can name a night yet (P7).
+79. Word Animation, the setting, is not built (P8): only Reduce Motion stops word by word and the fade.
+80. The month names come from `intl`'s CLDR data, assumed to match iOS's own for English and Swedish (D56).
+
+## Pending lines, to file before Cohort 1
+
+Lines given and approved, shown in SoulDreams Dev only until Product registers them (D58 Q11):
+
+- MP·60 (the confirmation's Delete) and MP·61 (its Cancel), head's message 16, founder-approved.
+- W27·5's privacy-page text (head's message 16) waits for the disclosure and privacy page, under Settings; it is not
+  in the pending file.
+
 ## Rulings during branch 2
 
 - D21: answers Q1 to Q7 before Task 0: Flutter may write `~/.config/flutter` (`flutter config` and analytics denied); only the owner runs `check_all.sh` in this branch; CLAUDE.md's G5 line names Apple's loggers; a debug `--no-codesign` build per flavour; RunnerTests kept; founder scheme Run is `Release-founder`; the template's orientations kept.
@@ -404,6 +451,24 @@ Banked by D17 (the reviews in journal-core; D52, D54):
   `tool/server_mutations.py` (D43; banked item 60 closed); `CLAUDE.md`'s G0, G1 and G2 lines name the branch's
   additions; the plan gains a Part 6, where the build differs from it.
 
+## Rulings during journal-screens
+
+- D56 (owner, 2026-11-12): the brainstorm's five leans: the scope (the journal list with month dividers, the typing
+  screen, a night's page with edit and delete night, the 21:00 rule, Night/Day automatic); pending lines in a small
+  file the owner adds; month names through Flutter's own localization package; the screenshots as design reference
+  only; Night/Day automatic now.
+- D57: the investigation's build questions: Q5, Q6, Q9 (Flutter's framework words are not ours under R1), Q10, Q11,
+  Q13 to Q16 and Q18 as leaned; Q12 English only for Cohort 0, Swedish built and tested, one switch later; Q14
+  format version 1, the owner removes and reinstalls SoulDreams Dev.
+- D58 (Product, through the head): Q1 MP·39 as written, Dev only; Q2 the typing screen's opening fixes a typed
+  night's date and 21:00; Q3 an emptied dream disappears, whitespace alone is empty (founder); Q4 editing in the
+  typing screen (founder); Q7 the first dream cut to three lines, TECH·1 whole word or phrase, ignoring case; Q8 the
+  phone's standard confirmation, Cancel first, Delete destructive (founder); Q11 MP·60 and MP·61 pending; Q17 a word
+  every 60 ms. The screenshots: not filed; the owner's reference folder, fingerprinted.
+- D59 (owner, 2026-11-12): the plan's Part 4: `CLAUDE.md`'s R1, G0, G1 and G2 lines in the plan's words, approved at
+  the prompt; Opus changes the stand-ins' numbers only; `newQueueForTests()` test-only; the other leans; the new
+  invented night committed with the plan's amendment.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C16-P state (`ff3b229`), in commit `ca29414` (Task 6). The ordinal
~~~~

## Part 4 · Questions (numbered; a blank is not a yes)

**Q1 to Q10 were answered by the owner on 2026-11-12 (D59)**, and the plan now builds to the answers:

- **Q1:** the suggested wording for R1 and the G0, G1 and G2 lines. The edit is made in Task 16, and the owner
  approves it at the prompt (`CLAUDE.md` is under "ask").
- **Q2:** Opus changes numbers only, and reports each value against its screenshot (Task 14).
- **Q3:** yes. `newQueueForTests()` is `@visibleForTesting`, so app code can never call it; the analyzer flags any
  call outside a test (Task 9's block, as proven).
- **Q4 to Q8, Q10:** the leans.
- **Q9:** the new invented night is committed to `fixtures/invented-nights.json` with this amendment, as
  journal-core did. Task 11 checks the fixture's hash instead of copying it, and the scratch copy is deleted.

As first asked, for the record:

1. **`CLAUDE.md` is the owner's, and this branch changes what its R1, G0, G1 and G2 lines describe.** *Lean:* after the
   merge, the owner adds:
   - **R1**, after "…generated from `app/assets/words/places-register.csv`": "Lines given and approved but not yet
     filed are pending lines: the owner writes them in `app/assets/words/pending-lines.csv`, fingerprinted, the
     generator makes `pending.g.dart`, and their words show in SoulDreams Dev only (D57 Q11)."
   - **G0**: "…; and the pending lines' and the screenshots' fingerprints by exact path."
   - **G1**: "…; and the pending lines match `pending-fingerprint.txt`, and `pending.g.dart` is what the generator
     makes from them."
   - **G2**: "…; and every file in `docs/reference/screens/` matches its `fingerprints.txt`."

   *If not:* the guards still run, and R1's text says less than the build does.
2. **Task 14 cannot be proven in advance.** The screenshots were not in this session. *Lean:* Opus changes only the
   numbers in `stand_ins.dart`, and the summary's role among `TypeRoles`, reports each value with its screenshot,
   and brings anything else to the owner. *If not:* the owner gives the values in the Build chat, and Task 14 types
   them.
3. **`JournalStore.newQueueForTests()`** adds a test-only line to D54's store. Without it, the second widget test in
   a file waits forever on a queue stranded in the first test's zone (seen in the proof). *Lean:* yes,
   `@visibleForTesting`. *If not:* every widget test runs its store calls through `tester.runAsync` on real files,
   which is slower and more code.
4. **Night/Day looks at the clock once a minute**, so the change can come up to a minute after 21:00 or 08:00.
   *Lean:* yes; it also survives a clock moved by hand. *If not:* a timer to the next boundary, reset on returning
   and on a clock change, which Flutter does not report.
5. **A row's TECH·1 list follows the night's own language**, not the language the app shows, since the telling is in
   the night's language. *Lean:* yes. *If not:* `appLanguage`'s list for every row.
6. **The "⋯" menu is Material's popup**, plain, one item. *Lean:* yes until Task 14. If the screenshots show iOS's
   pull-down menu, Q to the owner. *If not now:* `CupertinoContextMenu`-style code, more than a number.
7. **`journalOpenFailed`**, a new `LogEvent`, when Dev cannot open the folder. *Lean:* yes (R3: a code only).
8. **The dark field's absent border** ("no border", §3) is drawn as a transparent 1px border, so the field keeps its
   size between themes. *Lean:* yes.
9. **The new invented night is not in this plan** (R2: every dream lives in the fixture file). The proof kept the
   new fixture at `.scratch/journal-screens/invented-nights.json`, sha256 `73417673…aafb`, and Task 11 copies it.
   *Lean:* yes, as journal-core first proposed. *If not:* the fixture is committed with an amendment of this plan,
   as journal-core's Q2 ruled, and Task 11 only checks its hash.
10. **The test count for the hook's copy.** The guard tests copy tracked files only (as in journal-core), so each
   guard task stages before testing. *Lean:* as written in Tasks 2 and 3.

## Part 5 · How this plan was proven

**First proof, 2026-11-12, before `b043d42` committed the plan:**

1. Built task by task in a scratch worktree at `fc6f960`. Every block was generated from those commits.
   `tool/check_all.sh` ended `check_all: all passed`, and the app mutations `39 run, 39 caught`.
2. Replayed on a clean worktree from the plan's own blocks: every block applied, every commit passed the hook, and
   the final tree matched the build's (0 lines of difference).
3. **Found by that proof and fixed in the plan:**
   - G4 refused long test names and long generated comments; both were shortened.
   - G3 refused a literal inside a `TextSpan`; the words are now split with no literal.
   - Five guard mutation patterns followed the code they break.
   - The store's static queue stranded widget tests (`newQueueForTests()`, Q3), and the renewal sits inside each
     test, not in `setUp`.
   - The keyboard test reads the resolved `EditableText`.

**The amendment (D59), the same day, before it was committed with the fixture:**

4. **Rebuilt on the amendment's base.** A scratch worktree, `./.scratch/build-js`, at `b043d42` with the new
   fixture committed on top, as the amendment commits it.
   - Its baseline: 60 app tests, so the fifth invented night breaks no earlier test.
   - Tasks 1 to 13 were applied there from the first plan's blocks, through the hook, with the same counts as
     before.
   - Task 16 was built again with D59's line in Status.md and the four `CLAUDE.md` lines.
   - The blocks in Part 3 are generated from these commits.
5. **The owner's steps were simulated, never with the real words or images.**
   - Task 1: `pub add --offline` from the pub cache: the same two lines, `intl` 0.20.3.
   - Task 2: the empty `pending.g.dart`, sha256 `d1954a98…c463`.
   - Task 4: two pending rows, `MP·60` and `MP·61`, with stand-in words that are not the approved ones, and two fake
     PNG files, each with its fingerprint.
6. **Checks on the rebuilt tree:**
   - `tool/check_all.sh`: `check_all: all passed`: `Ran 241 tests`, `OK`; `mutations: 87 run, all caught`; `flutter: pinned 3.47.9, running 3.47.9`; `No issues found!`; `+126: All tests passed!`; `node: pinned 24, running 24`; the server's `fail 0`. The app mutations were run on the first build (`39 run, 39 caught`), and the app code is unchanged by the amendment.
7. **This amended plan replayed on a clean worktree**, `./.scratch/replay-js`, at `b043d42` with the fixture
   committed on top.
   - Every block was extracted from this file and applied with `git apply`, and each applied.
   - Task 11 checked the fixture's hash. Each task was committed through the hook with its message from this file:
     `guards (staged): all passed` every time.
   - The counts: Task 1, 60 app tests; Task 2, `Ran 238 tests`, `OK`, `mutations: 85 run, all caught`, `pending.g.dart` at `d1954a98…c463`; Task 3, `Ran 241`, `OK`, `87 run, all caught`; Task 4, 60; then 76, 83, 89, 92, 100, 111, 119 (the fixture at `73417673…aafb`), 125 and 126, with `No issues found!` at each; Task 16, `guards (tracked): all passed`.
   - The replayed tree's last commit against the rebuilt one: `git diff` printed 0 lines.
8. **Not provable in the sandbox, so the owner's:**
   - the real pending words, and their check against message 16;
   - the real screenshots, and Task 14's values;
   - the `CLAUDE.md` prompt;
   - the iOS build and every phone check (Task 15).
9. **Read in the pinned SDK:**
   - On iOS, Reduce Motion is `AccessibilityFeatures.reduceMotion` and does not set `disableAnimations`.
   - `FakeAccessibilityFeatures` takes `reduceMotion`.
   - `MaterialApp.themeAnimationDuration` exists.
   - `flutter_localizations` loads `intl`'s date data with its delegates.
10. The scratch worktrees are removed after the proof; their commits are on detached HEADs and reach no branch.
    `.scratch/journal-screens/` is deleted (D59 Q9).

## Part 6 · Where the build differs from this plan

Added by the final whole-branch review.

*No matter where you are on your journey, the steps you take are equally important.*
