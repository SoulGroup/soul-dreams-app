# Plan: journal-core (the journal's foundations, with no screen)

*No matter where you are on your journey, the steps you take are equally important.*

Written by Claude Code (Opus) on 2026-11-11 from the investigation (`.scratch/for-build-chat/journal-core-investigation.md`)
and the owner's rulings D48 and D49. **Proven before committing as far as the sandbox allows** (Part 5). Only this file
is committed by the planning step. Nothing here is implemented yet.

## Part 1 · Spec

### In plain words

The journal gets its foundations, and no screen yet. Three things:

1. **The design values.** A generator reads the Design System's tables (type, both themes' colours, spacing) into one
   Dart file of named values, the way the words generator reads the register. G1 proves the file is the generator's
   output. The five typefaces are bundled with the app, each file fingerprinted, never fetched at run time.
2. **The store.** Each night is one small JSON file on the phone, in `Library/Application Support/Journal`. The folder
   is kept out of the phone's backups, and every file has iOS's strongest file protection (unreadable while the phone
   is locked). A save writes a temporary file and renames it into place, so the folder only ever holds one whole
   version of each night. A small piece of Swift does the file work; no package is added.
3. **The proofs.** Tests on the Mac show that deleting a night leaves nothing of it in any file, that deleting the
   journal empties the folder (the first-use flag too), that an interrupted save leaves the last whole version and no
   temporary file, and that a file that does not read as a night is skipped with a code and never touched. On the
   phone, a check built into SoulDreams Dev reads back the backup flag and both protection classes, and the owner
   looks in the downloaded app container for any trace of its probe.

### What this branch builds

- `tool/checks/designgen.py` and its tests; G1 extended to prove `app/lib/design/tokens.g.dart`.
- G0 knowing `.txt` in `app/assets/fonts/` only; G2 proving every font file against `app/assets/fonts/fingerprints.txt`.
- `app/assets/fonts/`: twelve files and the fingerprints, the owner's download (Task 5); `pubspec.yaml` declaring them.
- `fixtures/invented-nights.json` (R2), four invented nights, and the tests' reader.
- `app/lib/journal/`: the night and its file format (version 1), the folder's interface, the store, the channel, and
  the phone check; `AppDelegate.swift`'s folder code; `main_dev.dart` running the check when asked.
- `docs/Status.md`: this branch's state, the rulings and the banked items.

### What it does not build (D49)

No screen, no night rules (the 21:00 boundary), no typing, no Settings, no Delete-journal control: they wait for
Product's answers to P1 to P14 (the investigation, §7), sent through the head, and come in a later branch. Nothing in
the founder or tester entry points changes (O1). No package is added (D47; O8).

### The decisions, by number

| | Ruling | Where it lands |
|---|---|---|
| D48 | As this plan reads it (Part 4, Q1): the brief that opened the branch: the journal on the phone, nothing leaves it, invented nights only, installs the owner's | All tasks |
| D49 split | This branch builds only what needs no Product answer: (a) the design values, the fonts; (b) the store; (c) the deletion tests | Tasks 2 to 10 |
| D49 a | `designgen.py` with G1 extended; the owner downloads static TTFs and OFL licences into `app/assets/fonts/`, fingerprinted; G0 learns `.txt` there only | Tasks 2 to 6 |
| D49 b | One JSON file per night in `Library/Application Support/<journal dir>` (`Journal`); the folder excluded from backup; complete file protection; a version field from day one; a small Swift channel; no package | Tasks 8 to 10 |
| D49 c | Tests: deletion removes everything (night file, temporary files, the first-use flag on Delete journal); an unreadable night file is skipped with a code and never touched | Tasks 9, 10 |
| D49 O1 | Journal code reaches `main_dev.dart` only; `main.dart` and `main_founder.dart` unchanged | Task 10 |
| D49 O2 | English; no `flutter_localizations` | Nothing to build here |
| D49 O3 | The generator plus a guard (G1 extended) | Tasks 2, 3 |
| D49 O4 | The owner downloads the fonts; G0 learns `.txt` in that one folder | Tasks 4, 5 |
| D49 O5 | The format may change freely until it first reaches the founder app; `version` from day one | Task 8 |
| D49 O6 | The first-use flag lives in the journal's folder and goes with Delete journal | Task 9 |
| D49 O7 | An unreadable night file is never deleted or rewritten; skipped with a code | Task 9 |
| D49 O8 | Per-night JSON and a Swift channel, no package | Tasks 8 to 10 |
| D49 O9 | The 21:00 tests use a fake zone table, no `check_all.sh` change | Waits with the night rules |
| D49 O10 | Read by the Build chat: the backup exclusion may be set on a directory, covers its contents, and is guidance to the system, not a guarantee; iOS snapshots the UI after backgrounding, and Apple advises hiding sensitive information first. The rest stays ASSUMED, proven by the owner's phone checks | Tasks 10, 11 |
| D49 Status | Status.md records D46 (already there, branch 4), D47 (`1b3e93b`), D48, D49, and banks the lists becoming English only (head, C156-I/C157-I): `lists-shape` will need a ruling at the next lists filing | Task 12 |

### The files after this branch

~~~~
tool/checks/
  designgen.py              the design values generator (new)
  guardlib.py               DESIGN, TOKENS, FONTS, FINGERPRINTS
  g0_kinds.py               .txt known in app/assets/fonts/ only
  g1_words.py               also proves tokens.g.dart
  g2_copies.py              also proves each font's fingerprint
  tests/test_designgen.py   12 tests (new)
  tests/test_g0.py          +2;  tests/test_g1_g2.py  +5 (G1), +7 (G2)
  tests/mutations.py        rows 69 to 75; row 58's pattern follows g1_words.py
fixtures/invented-nights.json   four invented nights (R2)
app/
  pubspec.yaml              the fonts block
  assets/fonts/             12 font and licence files, fingerprints.txt (the owner's)
  lib/design/tokens.g.dart  generated: TypeRoles, LightColours, DarkColours, Spacing
  lib/core/safe_log.dart    four journal events
  lib/journal/night.dart                  a night; format version 1
  lib/journal/journal_files.dart          the folder's interface; validName; Protection
  lib/journal/journal_store.dart          the store
  lib/journal/channel_journal_files.dart  the folder on the phone, through the channel
  lib/journal/self_check.dart             the phone check
  lib/main_dev.dart         runs the check when built with JOURNAL_SELF_CHECK=true
  ios/Runner/AppDelegate.swift   the channel and the folder's file work
  test/fixtures.dart, test/fixtures_test.dart
  test/design/tokens_test.dart, test/design/fonts_test.dart
  test/journal/night_test.dart, io_journal_files.dart, journal_store_test.dart,
               channel_journal_files_test.dart, self_check_test.dart
.scratch/journal-core/      (not committed) fonts.sh, app_mutations.py, invented-nights.json
~~~~

### The format, version 1

One file per night, `night-<id>.json`, UTF-8 JSON with exactly these keys: `version` (1), `id` (32 lowercase hex
digits, 128 bits from `Random.secure`, never sent, R4), `firstRecorded` (UTC, ISO 8601), `date` (`YYYY-MM-DD`, the
phone's date at the first recording, kept so it never moves), `lang` (`en` or `sv`), `name` (a string or null), and
`dreams` (a list of strings, in order). Anything else is not a night: it decodes to null and the store skips it.
Which fields a night holds is settled again with Product's answers (P2, P9, P10); until the format first reaches the
founder app it may change freely (O5).

### Test plan

| File | Tests | What they prove |
|---|---|---|
| `tool/checks/tests/test_designgen.py` | 12 | Each type, colour and spacing form; "as in the light theme"; each theme's own roles; an unset value has no constant; pure, carries the hash; every refusal code and its line; the command line writes, checks, and prints a code and a line only |
| `test_g1_g2.py`, G1 | +5 | The design file missing; the tokens missing or hand-edited; the generator's refusal with its line; the design checked beside a words refusal |
| `test_g0.py` | +2 | `.txt` known in the fonts folder only, as UTF-8; a font is binary |
| `test_g1_g2.py`, G2 | +7 | Fonts listed pass; unlisted, changed, missing, malformed, no fingerprints; checked when not armed |
| `app/test/design/tokens_test.dart` | 3 | Letter spacing; a role's text style; gradients |
| `app/test/design/fonts_test.dart` | 3 | Every family and weight the tokens use is declared; Nunito's italic; declared fonts and files agree |
| `app/test/fixtures_test.dart` | 3 | The fixture's shape |
| `app/test/journal/night_test.dart` | 6 | Round trip; the exact fields; fifteen malformed files decode to null; ids; refusals with a code; immutable dreams |
| `app/test/journal/journal_store_test.dart` | 9 | Save and read back; delete leaves no trace (text, JSON-escaped text, name, id) in any file and every other file byte-identical; an edit leaves one version; Delete journal empties the folder; a cut save; unreadable files skipped with a code and untouched; other files left alone; the first-use flag; bad ids refused |
| `app/test/journal/channel_journal_files_test.dart` | 5 | Each call's name and arguments; answers; missing answers never read as protected; failures as codes, bad names never sent; the Swift side answers every method |
| `app/test/journal/self_check_test.dart` | 4 | Passes and leaves nothing; fails at step 3 for each missing protection, probe removed; fails at step 2; keeps other nights |

**Totals after the branch:** guard tests 195 → **221**; guard mutations 68 → **75**; app tests 14 → **47**; app
mutation checks **8** (A1 to A8), by hand with the scratch runner (Part 4, Q4). The new guard mutation rows:

| | Break | Must fail |
|---|---|---|
| 69 | `designgen.py`: any colour note accepted | `test_designgen.Generate.test_refusals` |
| 70 | `designgen.py`: the minus sign not read | `test_designgen.Generate.test_type_roles` |
| 71 | `designgen.py`: an unset value not recognised | `test_designgen.Generate.test_an_unset_value_has_no_constant` |
| 72 | `g1_words.py`: the design never checked | `test_g1_g2.G1.test_tokens_hand_edited_refuses` |
| 73 | `g0_kinds.py`: `.txt` known anywhere | `test_g0.G0.test_txt_in_the_fonts_folder_only` |
| 74 | `g2_copies.py`: a font's hash not compared | `test_g1_g2.G2.test_font_hash_mismatch_refuses` |
| 75 | `g2_copies.py`: the fonts never checked | `test_g1_g2.G2.test_font_unlisted_refuses` |

The app's mutation checks, in `.scratch/journal-core/app_mutations.py` (Task 10):

| | Break | Must fail |
|---|---|---|
| A1 | delete names the file but deletes nothing | deleting a night leaves nothing of it anywhere |
| A2 | save writes in place, no temporary file | a save cut short leaves the last whole version |
| A3 | open sweeps no temporary file | a save cut short leaves the last whole version |
| A4 | Delete journal deletes night files only | deleting the journal empties the folder |
| A5 | a skipped file is not logged | an unreadable file is skipped with a code, never touched |
| A6 | a file whose id differs from its name is read | an unreadable file is skipped with a code, never touched |
| A7 | extra keys accepted | anything not a version-1 night decodes to null |
| A8 | the protections not checked | each missing protection fails at step 3, probe removed |

---

## Part 2 · Settings

None change. D49 approves G0's new kind (`.txt` in `app/assets/fonts/`, CLAUDE.md G0). `tool/checks/` is writable by
Claude Code (`Edit(/tool/checks/**)` allowed); nothing here edits `check_all.sh`, `.githooks`, `CLAUDE.md`,
`docs/workflow.md`, the importer or `wordsgen.py`.

---

## Part 3 · The tasks

**Who runs what.** Tasks marked **[OWNER]** are the owner's pastes. Claude Code stops before each, gives the paste,
and waits for the output. Everything else is Claude Code's.

**How files are written.** A **File** block is written whole through the Write tool, exactly as given. An **Edit**
block changes an existing file through the Edit tool: its first fence is replaced by its second, and the first must
occur exactly once. The edits of one file are applied in the order given.

**Commits.** Each Claude Code task ends green with its own commit, through the hook (never `--no-verify`), staged by
path only (never `git add -A` or `git add .`). Every commit message ends with the line
`Co-Authored-By: <the model that wrote it> <noreply@anthropic.com>`. `git -C`, `git reset` and `git config` are denied
by the settings: commands `cd` instead, and `git restore --staged` unstages.

**Red, then green.** Each Claude Code task first writes its tests and runs them; the run must fail as stated. Then it
writes the code, and the run must pass with the stated count. Any other result stops the task (R14).

**The gate** at the end of every Claude Code task, from the repository root:

    python3 -I -B tool/checks/guards.py
    cd app && fvm flutter analyze --no-pub && fvm flutter test --no-pub

Expected: `guards (tracked): all passed`; `No issues found!`; the task's app test count and `All tests passed!`.
Tasks that change `tool/checks/` also run `python3 -I -B tool/checks/tests/run_tests.py` (expected: the task's count,
`OK`) and the mutation rows for the files they changed.

### Task 0 · Baselines

From the repository root, on `journal-core` with a clean tree:

    python3 -I -B tool/checks/tests/run_tests.py
    python3 -I -B tool/checks/tests/mutations.py
    python3 -I -B tool/checks/guards.py
    cd app && fvm flutter analyze --no-pub && fvm flutter test --no-pub

Expected: `Ran 195 tests`, `OK`; `mutations: 68 run, all caught`; `guards (tracked): all passed`; `No issues found!`;
`+14: All tests passed!`. Any other result stops the branch.

### Task 1 · The scratch files

Write the three files the later tasks use, none committed (`.scratch/` is ignored):

- `.scratch/journal-core/fonts.sh` (Task 5's block);
- `.scratch/journal-core/app_mutations.py` (Task 10's block);
- `.scratch/journal-core/invented-nights.json`: already there, kept by this plan's proof (Part 4, Q2). Check it:

      shasum -a 256 .scratch/journal-core/invented-nights.json

  Expected: `feb1baaea50d2d313dc5aefd3f3b21af0d47690a6564614894af13eec6985932`. If it is missing or differs, stop: the owner decides (Part 4, Q2).

### Task 2 · The design values generator (D49 a, O3)

1. **Edit** `tool/checks/guardlib.py`, then write the tests and the mutation rows:

**Edit `tool/checks/guardlib.py`**

~~~~python
GENERATED = (LINES, LIST_WORDS, WORDS_XCCONFIG, STRINGS_EN, STRINGS_SV)

~~~~

~~~~python
GENERATED = (LINES, LIST_WORDS, WORDS_XCCONFIG, STRINGS_EN, STRINGS_SV)
# The design values (D49 a): designgen makes TOKENS from DESIGN, and G1
# proves it.
DESIGN = 'docs/source/design-system.md'
TOKENS = 'app/lib/design/tokens.g.dart'
# The fonts (D49 a): every file here is listed in FINGERPRINTS with its
# sha256, which G2 proves; G0 knows .txt files here only.
FONTS = 'app/assets/fonts/'
FINGERPRINTS = 'app/assets/fonts/fingerprints.txt'

~~~~

**File `tool/checks/tests/test_designgen.py`**

~~~~python
# The design values generator (D49 a) on invented Design Systems, built
# here in the real file's shape: its four headings, its table headers
# and each value form it uses.
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

import helpers  # noqa: F401  (puts tool/checks on the path)
import designgen
from guardlib import DESIGN, TOKENS

MINUS = '−'
ARROW = '→'


def r(*cells):
    # One table row, built from its cells (no long literal here, G4).
    return '| ' + ' | '.join(cells) + ' |'


TYPE_ROWS = [
    r('type.h2', 'Sorts Mill Goudy', 'Regular', '33px', '1.2', '%s0.02em' % MINUS, 'Titles'),
    r('type.button', 'Inter', 'Semibold', '14px', '1.4', '0', 'Buttons'),
]
LIGHT_ROWS = [
    r('color.page', '#F5F5EC'),
    r('color.surface (rows)', '#FFFFFF'),
    r('color.surface.border', '1px #CCCCCC'),
    r('color.text.summary (a summary)', '#767676, only ever on white'),
    r('color.button', '#FFFFFF, border 1px #CCCCCC, text #333333'),
    r('color.record', 'gradient #8F3D24 %s #6B2B18, text #FFFFFF' % ARROW),
]
DARK_ROWS = [
    r('color.page', '#0F0D29'),
    r('color.surface', 'gradient #3D376E %s #26214F, border #26214F' % ARROW),
    r('color.field', '#CFCDC1, no border'),
    r('color.button.filled', 'as color.button: gradient #F5F5EC %s #ABAB93, text #333333' % ARROW),
    r('color.record', 'as in the light theme'),
]
SPACING_ROWS = [
    r('radius', '30, in both themes'),
    r('space.box', '50px above and below, 30px left and right'),
    r('size.field.search', '50px tall'),
    r('space.bubble', '30px from the left edge, 10px from the right'),
    r('space.turn', '20px more space after the last reply'),
    r('space.night.header', '20px above the header, 10px below, in both themes'),
    r('space.end', 'Space below the list: [to set in Framer]'),
    r('Everything else', '[to set in Framer]'),
]


def doc(type_rows=None, light=None, dark=None, spacing=None, extra=''):
    def section(heading, header, rule, rows):
        return '%s\n\nProse.\n\n%s\n%s\n%s\n\n' % (heading, header, rule, '\n'.join(rows))
    return ('# The Design System\n\n'
            + section(designgen.TYPE, r('Role', 'Face', 'Weight', 'Size', 'Line', 'Letter', 'Used for'),
                      r('---', '---', '---', '---', '---', '---', '---'), TYPE_ROWS if type_rows is None else type_rows)
            + section(designgen.LIGHT, r('Role', 'Value'), r('---', '---'),
                      LIGHT_ROWS if light is None else light)
            + section(designgen.DARK, r('Role', 'Value'), r('---', '---'),
                      DARK_ROWS if dark is None else dark)
            + '## 4. Contrast\n\nProse.\n\n'
            + section(designgen.SPACING, r('Role', 'Value'), r('---', '---'),
                      SPACING_ROWS if spacing is None else spacing)
            + extra).encode('utf-8')


def text(data):
    return designgen.generate(data)[TOKENS].decode('utf-8')


class Generate(unittest.TestCase):
    def refused(self, data, code, line=None):
        with self.assertRaises(designgen.DesignError) as ctx:
            designgen.generate(data)
        self.assertEqual(ctx.exception.code, code)
        if line is not None:
            self.assertEqual(ctx.exception.line, line)

    def test_type_roles(self):
        t = text(doc())
        self.assertIn("static const h2 = TypeRole('SortsMillGoudy', FontWeight.w400, 33, 1.2, -0.02);", t)
        self.assertIn("static const button = TypeRole('Inter', FontWeight.w600, 14, 1.4, 0);", t)

    def test_colour_forms(self):
        t = text(doc())
        self.assertIn('static const page = ColourRole(colour: Color(0xFFF5F5EC));', t)
        self.assertIn('static const surfaceBorder = ColourRole(border: Color(0xFFCCCCCC), borderWidth: 1);', t)
        self.assertIn('static const button = ColourRole(colour: Color(0xFFFFFFFF), border: Color(0xFFCCCCCC), '
                      'text: Color(0xFF333333), borderWidth: 1);', t)
        self.assertIn('static const record = ColourRole(colour: Color(0xFF8F3D24), colourEnd: Color(0xFF6B2B18), '
                      'text: Color(0xFFFFFFFF));', t)
        self.assertIn('static const surface = ColourRole(colour: Color(0xFF3D376E), colourEnd: Color(0xFF26214F), '
                      'border: Color(0xFF26214F));', t)
        self.assertIn('static const buttonFilled = ColourRole(colour: Color(0xFFF5F5EC), '
                      'colourEnd: Color(0xFFABAB93), text: Color(0xFF333333));', t)
        self.assertIn('/// Noted: only ever on white.', t)

    def test_as_in_the_light_theme_copies_the_light_value(self):
        t = text(doc())
        dark = t[t.index('abstract final class DarkColours'):]
        self.assertIn('static const record = ColourRole(colour: Color(0xFF8F3D24), colourEnd: Color(0xFF6B2B18), '
                      'text: Color(0xFFFFFFFF));', dark)

    def test_each_theme_has_only_its_own_roles(self):
        t = text(doc())
        light = t[t.index('abstract final class LightColours'):t.index('abstract final class DarkColours')]
        dark = t[t.index('abstract final class DarkColours'):t.index('abstract final class Spacing')]
        self.assertIn('textSummary', light)
        self.assertNotIn('textSummary', dark)
        self.assertIn(' field =', dark)
        self.assertNotIn(' field =', light)

    def test_spacing_forms(self):
        t = text(doc())
        self.assertIn('static const double radius = 30;', t)
        self.assertIn('static const box = EdgeInsets.symmetric(vertical: 50, horizontal: 30);', t)
        self.assertIn('static const double sizeFieldSearch = 50;', t)
        self.assertIn('static const bubble = EdgeInsets.only(left: 30, right: 10);', t)
        self.assertIn('static const double turn = 20;', t)
        self.assertIn('static const nightHeader = EdgeInsets.only(top: 20, bottom: 10);', t)

    def test_an_unset_value_has_no_constant(self):
        t = text(doc())
        self.assertNotIn(' end ', t)
        self.assertIn('  // `space.end`\n', t)
        self.assertEqual(designgen.summary(doc())[-1], 'designgen: unset 1')

    def test_pure_and_carries_the_hash(self):
        data = doc()
        self.assertEqual(designgen.generate(data), designgen.generate(data))
        self.assertIn(designgen.sha256(data), text(data))

    def test_refusals(self):
        self.refused(None, 'missing', 0)
        self.refused(b'\xff', 'not-utf8', 0)
        self.refused(doc().replace(designgen.DARK.encode('utf-8'), b'## 3. Gone'), 'section-missing')
        self.refused(doc(extra=designgen.TYPE + '\n'), 'section-repeated')
        self.refused(doc().replace(b'| Role |', b'| Name |', 1), 'table-header')
        self.refused(doc(light=[r('color.page', '#F5F5EC', 'extra')]), 'table-cells')
        self.refused(doc(type_rows=[r('type.h1', 'Comic', 'Regular', '9px', '1', '0', 'x')]), 'face-unknown')
        self.refused(doc(type_rows=[r('type.h1', 'Inter', 'Bold', '9px', '1', '0', 'x')]), 'weight-unknown')
        self.refused(doc(type_rows=[r('type.h1', 'Inter', 'Regular', '9pt', '1', '0', 'x')]), 'type-form')
        self.refused(doc(light=[r('color.page', '#F5F5EC, almost always')]), 'colour-form')
        self.refused(doc(light=[r('color.page', '#f5f5ec')]), 'colour-form')
        self.refused(doc(light=[r('color.page', '#F5F5EC'), r('color.page', '#FFFFFF')]), 'role-repeated')
        self.refused(doc(dark=[r('color.other', 'as in the light theme')]), 'as-unknown')
        self.refused(doc(spacing=[r('space.x', 'about 20px')]), 'spacing-form')
        self.refused(doc(spacing=[r('Everything else', '10px')]), 'spacing-form')
        self.refused(doc(light=[r('Page colour', '#F5F5EC')]), 'role-form')

    def test_refusal_names_the_line(self):
        data = doc(light=[r('color.page', '#F5F5EC'), r('color.odd', '#12')])
        line = data.decode('utf-8').split('\n').index(r('color.odd', '#12')) + 1
        self.refused(data, 'colour-form', line)


class Cli(unittest.TestCase):
    def setUp(self):
        self.root = tempfile.mkdtemp(prefix='designgen-')
        os.makedirs(os.path.join(self.root, os.path.dirname(DESIGN)))
        with open(os.path.join(self.root, DESIGN), 'wb') as f:
            f.write(doc())

    def tearDown(self):
        shutil.rmtree(self.root)

    def run_gen(self, *args):
        script = os.path.join(os.path.dirname(designgen.__file__), 'designgen.py')
        r = subprocess.run([sys.executable, '-I', '-B', script] + list(args) + ['--root', self.root],
                           capture_output=True, text=True)
        return r.returncode, r.stdout

    def test_write_then_check(self):
        self.assertEqual(self.run_gen('--check')[0], 1)
        code, out = self.run_gen('--write')
        self.assertEqual(code, 0)
        self.assertIn('designgen: wrote ' + TOKENS, out)
        self.assertEqual(self.run_gen('--check'), (0, 'designgen: up to date\n'))

    def test_hand_edit_differs(self):
        self.run_gen('--write')
        with open(os.path.join(self.root, TOKENS), 'ab') as f:
            f.write(b'// x\n')
        self.assertEqual(self.run_gen('--check'),
                         (1, 'designgen: differs %s\ndesigngen: different\n' % TOKENS))

    def test_refusal_prints_code_and_line_only(self):
        with open(os.path.join(self.root, DESIGN), 'wb') as f:
            f.write(doc(light=[r('color.page', 'secret words')]))
        code, out = self.run_gen('--write')
        self.assertEqual(code, 1)
        self.assertRegex(out, r'^designgen: refused colour-form line \d+\n$')


if __name__ == '__main__':
    unittest.main()
~~~~

**Edit `tool/checks/tests/mutations.py`**

~~~~python
     ['test_wordsgen.Command.test_symlinked_input_is_treated_as_missing']),
]
~~~~

~~~~python
     ['test_wordsgen.Command.test_symlinked_input_is_treated_as_missing']),
    # journal-core (D49 a): the design values and the fonts.
    ('designgen.py', "        elif part in NOTES:", "        elif True:",
     ['test_designgen.Generate.test_refusals']),
    ('designgen.py', "return text.replace(MINUS, '-')", "return text",
     ['test_designgen.Generate.test_type_roles']),
    ('designgen.py', "        if value.endswith(UNSET):", "        if False:",
     ['test_designgen.Generate.test_an_unset_value_has_no_constant']),
]
~~~~

2. Red: `python3 -I -B tool/checks/tests/run_tests.py test_designgen` ends `FAILED (errors=1)` (no module
   `designgen`).

3. Write the generator:

**File `tool/checks/designgen.py`**

~~~~python
# The design values generator (D49 a). From the Design System's tables
# (docs/source/design-system.md: §1 type, §2 and §3 colour, §5 spacing)
# to app/lib/design/tokens.g.dart, every value named by its role. A pure
# function of the file's bytes, so G1 can run it again and compare. It
# knows each value form the tables use and stops on any other, with a
# reason code and a line number, never a file's content.
# Usage: designgen.py --write           write tokens.g.dart
#        designgen.py --check           exit 1 if it differs
#        add --root DIR to read the input, --out DIR to write or compare
#        elsewhere (the tests and the plan's proof).
# Exit 0 done, 1 refused or different, 2 internal error.
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TOP = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)

from guardlib import DESIGN, TOKENS, report, sha256  # noqa: E402
from wordsgen import read, write_atomic  # noqa: E402

TYPE = '## 1. Type'
LIGHT = '## 2. Colour: the light theme'
DARK = '## 3. Colour: the dark theme'
SPACING = '## 5. Spacing and radius'
TYPE_HEADER = ('Role', 'Face', 'Weight', 'Size', 'Line', 'Letter', 'Used for')
VALUE_HEADER = ('Role', 'Value')
# Each face the system names, and its font family in pubspec.yaml. A new
# face needs its font files first, so it stops the generator.
FACES = {'Tangerine': 'Tangerine', 'Sorts Mill Goudy': 'SortsMillGoudy', 'Inter': 'Inter',
         'Nunito': 'Nunito', 'Habibi': 'Habibi'}
WEIGHTS = {'Regular': 'FontWeight.w400', 'Semibold': 'FontWeight.w600'}
# The notes a colour value may carry after its colours; kept as comments.
NOTES = ('only ever on white', 'and on the bubble gradient everywhere',
         "a row's summary included", 'no border')
UNSET = '[to set in Framer]'
EVERYTHING_ELSE = 'Everything else'
MINUS = '−'
ARROW = '→'
HEXC = r'#([0-9A-F]{6})'
ROLE = re.compile(r'^([a-z][a-z0-9]*(?:\.[a-z0-9]+)*)(?: \((.+)\))?$')
NUMBER = re.compile(r'^\d+(?:\.\d+)?$')
SIZE = re.compile(r'^(\d+)px$')
LETTER = re.compile(r'^(-?\d+(?:\.\d+)?)em$')
SOLID = re.compile('^' + HEXC + '$')
GRADIENT = re.compile('^gradient ' + HEXC + ' ' + ARROW + ' ' + HEXC + '$')
LINE_ONLY = re.compile(r'^(\d+)px ' + HEXC + '$')
BORDER = re.compile(r'^border (?:(\d+)px )?' + HEXC + '$')
TEXT = re.compile('^text ' + HEXC + '$')
AS_ROLE = re.compile(r'^as color\.[a-z.]+: (.+)$')
AS_LIGHT = 'as in the light theme'
SCALAR = re.compile(r'^(\d+)(?:, in both themes)?$')
BOX = re.compile(r'^(\d+)px above and below, (\d+)px left and right$')
SIDES = re.compile(r'^(\d+)px from the left edge, (\d+)px from the right$')
HEADER_GAP = re.compile(r'^(\d+)px above the header, (\d+)px below(?:, in both themes)?$')
TALL = re.compile(r'^(\d+)px tall$')
AFTER = re.compile(r'^(\d+)px (?:more space )?after \S.*$')


class DesignError(Exception):
    def __init__(self, code, line):
        Exception.__init__(self, code)
        self.code = code
        self.line = line


def decode(data):
    if data is None:
        raise DesignError('missing', 0)
    try:
        return data.decode('utf-8')
    except UnicodeDecodeError:
        raise DesignError('not-utf8', 0)


def table(lines, heading, header):
    # [(line number, cells)] of the first table under heading, which must
    # stand exactly once.
    at = [n for n, line in enumerate(lines) if line == heading]
    if len(at) != 1:
        raise DesignError('section-missing' if not at else 'section-repeated', 0)
    n = at[0] + 1
    while n < len(lines) and not lines[n].startswith('|'):
        if lines[n].startswith('## '):
            raise DesignError('table-missing', at[0] + 1)
        n += 1
    rows = []
    while n < len(lines) and lines[n].startswith('|'):
        cells = tuple(c.strip() for c in lines[n].strip().strip('|').split('|'))
        rows.append((n + 1, cells))
        n += 1
    if len(rows) < 2 or rows[0][1] != header or set(''.join(rows[1][1])) - set('-: '):
        raise DesignError('table-header', at[0] + 1)
    for line, cells in rows[2:]:
        if len(cells) != len(header):
            raise DesignError('table-cells', line)
    return rows[2:]


def role_of(cell, line):
    m = ROLE.match(cell)
    if not m:
        raise DesignError('role-form', line)
    return m.group(1), m.group(2)


def ident(role, line):
    parts = role.split('.')
    if parts[0] in ('type', 'color', 'space') and len(parts) > 1:
        parts = parts[1:]
    name = parts[0] + ''.join(p[:1].upper() + p[1:] for p in parts[1:])
    if not re.match(r'^[a-z][A-Za-z0-9]*$', name):
        raise DesignError('role-form', line)
    return name


def number(text):
    return text.replace(MINUS, '-')


def read_type(lines):
    out = []
    for line, (role, face, weight, size, height, letter, used) in table(lines, TYPE, TYPE_HEADER):
        role, _ = role_of(role, line)
        if not role.startswith('type.'):
            raise DesignError('role-form', line)
        if face not in FACES:
            raise DesignError('face-unknown', line)
        if weight not in WEIGHTS:
            raise DesignError('weight-unknown', line)
        m = SIZE.match(size)
        e = LETTER.match(number(letter))
        if not m or not NUMBER.match(height) or not (letter == '0' or e):
            raise DesignError('type-form', line)
        out.append((line, role, used, (FACES[face], WEIGHTS[weight], m.group(1), height,
                                       e.group(1) if e else '0')))
    return out


def colour_value(value, line):
    # {'colour', 'end', 'border', 'width', 'text'} and the notes.
    v = {}
    notes = []
    m = AS_ROLE.match(value)
    if m:
        notes.append(value.split(':', 1)[0])
        value = m.group(1)
    parts = value.split(', ')
    first = parts[0]
    if SOLID.match(first):
        v['colour'] = SOLID.match(first).group(1)
    elif GRADIENT.match(first):
        v['colour'], v['end'] = GRADIENT.match(first).groups()
    elif LINE_ONLY.match(first):
        v['width'], v['border'] = LINE_ONLY.match(first).groups()
    else:
        raise DesignError('colour-form', line)
    for part in parts[1:]:
        if BORDER.match(part) and 'border' not in v:
            v['width'], v['border'] = BORDER.match(part).groups()
        elif TEXT.match(part) and 'text' not in v:
            v['text'] = TEXT.match(part).group(1)
        elif part in NOTES:
            notes.append(part)
        else:
            raise DesignError('colour-form', line)
    return v, notes


def read_colours(lines, heading, light=None):
    out = []
    seen = {}
    for line, (role, value) in table(lines, heading, VALUE_HEADER):
        role, note = role_of(role, line)
        if not role.startswith('color.'):
            raise DesignError('role-form', line)
        if role in seen:
            raise DesignError('role-repeated', line)
        if value == AS_LIGHT:
            if light is None or role not in light:
                raise DesignError('as-unknown', line)
            v, notes = light[role][0], [AS_LIGHT]
        else:
            v, notes = colour_value(value, line)
        seen[role] = (v, notes)
        out.append((line, role, note, v, notes))
    return out, seen


def read_spacing(lines):
    out = []
    unset = []
    seen = set()
    for line, (role, value) in table(lines, SPACING, VALUE_HEADER):
        if role == EVERYTHING_ELSE:
            if value != UNSET:
                raise DesignError('spacing-form', line)
            continue
        role, _ = role_of(role, line)
        if role in seen:
            raise DesignError('role-repeated', line)
        seen.add(role)
        if value.endswith(UNSET):
            unset.append(role)
            continue
        for rx, kind in ((SCALAR, 'scalar'), (BOX, 'box'), (SIDES, 'sides'),
                         (HEADER_GAP, 'gap'), (TALL, 'scalar'), (AFTER, 'scalar')):
            m = rx.match(value)
            if m:
                out.append((line, role, value, kind, m.groups()))
                break
        else:
            raise DesignError('spacing-form', line)
    return out, unset


def comment(text):
    return '  /// ' + ' '.join(text.split())


def colour(hexa):
    return 'Color(0xFF%s)' % hexa


def colour_const(role, note, v, notes, line):
    args = []
    for key, name in (('colour', 'colour'), ('end', 'colourEnd'), ('border', 'border'),
                      ('text', 'text')):
        if key in v:
            args.append('%s: %s' % (name, colour(v[key])))
    if v.get('width'):
        args.append('borderWidth: %s' % v['width'])
    doc = [comment('`%s`%s' % (role, ' (%s)' % note if note else ''))]
    if notes:
        doc.append(comment('Noted: ' + '; '.join(notes) + '.'))
    return doc + ['  static const %s = ColourRole(%s);' % (ident(role, line), ', '.join(args))]


HEAD = ''.join(line + '\n' for line in (
    '// GENERATED by tool/checks/designgen.py from docs/source/design-system.md',
    '// (sha256 @SHA@). Do not edit: import the Design System again.',
    '',
    "import 'package:flutter/painting.dart';",
    '',
    '/// A type role (Design System §1). Sizes are logical',
    "/// pixels and grow with the phone's text size; [height]",
    '/// is a multiple of the size.',
    'final class TypeRole {',
    '  const TypeRole(this.family, this.weight, this.size, this.height, this.letterEm);',
    '',
    '  /// The font family, as pubspec.yaml declares it.',
    '  final String family;',
    '  final FontWeight weight;',
    '  final double size;',
    '  final double height;',
    '',
    '  /// Letter spacing in em.',
    '  final double letterEm;',
    '',
    '  /// Letter spacing in logical pixels.',
    '  double get letterSpacing => letterEm * size;',
    '',
    '  TextStyle style(Color colour) => TextStyle(',
    '        fontFamily: family,',
    '        fontWeight: weight,',
    '        fontSize: size,',
    '        height: height,',
    '        letterSpacing: letterSpacing,',
    '        color: colour,',
    '      );',
    '}',
    '',
    '/// A colour role (Design System §2, §3): a colour, or',
    '/// a gradient from [colour] to [colourEnd], with the',
    '/// border and text colour the role names. A part the',
    '/// role does not name is null.',
    'final class ColourRole {',
    '  const ColourRole({this.colour, this.colourEnd, this.border, this.borderWidth, this.text});',
    '',
    '  final Color? colour;',
    '  final Color? colourEnd;',
    '  final Color? border;',
    '  final double? borderWidth;',
    '  final Color? text;',
    '',
    '  bool get isGradient => colourEnd != null;',
    '}',
    '',
))


def tokens_dart(type_rows, light, dark, spacing, unset, digest):
    out = [HEAD.replace('@SHA@', digest)]
    out.append('/// Design System §1.\nabstract final class TypeRoles {\n')
    body = []
    for line, role, used, (family, weight, size, height, letter) in type_rows:
        body.append('\n'.join([comment('`%s`: %s' % (role, used)),
                               "  static const %s = TypeRole('%s', %s, %s, %s, %s);"
                               % (ident(role, line), family, weight, size, height, letter)]))
    out.append('\n\n'.join(body) + '\n}\n\n')
    for name, section, rows in (('LightColours', '§2, the light theme', light),
                                ('DarkColours', '§3, the dark theme', dark)):
        out.append('/// Design System %s.\nabstract final class %s {\n' % (section, name))
        out.append('\n\n'.join('\n'.join(colour_const(role, note, v, notes, line))
                               for line, role, note, v, notes in rows) + '\n}\n\n')
    out.append('/// Design System §5, in logical pixels.\n')
    out.append('abstract final class Spacing {\n')
    body = []
    for line, role, value, kind, g in spacing:
        if kind == 'scalar':
            code = '  static const double %s = %s;' % (ident(role, line), g[0])
        elif kind == 'box':
            code = ('  static const %s = EdgeInsets.symmetric(vertical: %s, horizontal: %s);'
                    % (ident(role, line), g[0], g[1]))
        elif kind == 'sides':
            code = ('  static const %s = EdgeInsets.only(left: %s, right: %s);'
                    % (ident(role, line), g[0], g[1]))
        else:
            code = ('  static const %s = EdgeInsets.only(top: %s, bottom: %s);'
                    % (ident(role, line), g[0], g[1]))
        body.append(comment('`%s`: %s' % (role, value)) + '\n' + code)
    out.append('\n\n'.join(body) + '\n')
    if unset:
        out.append('\n  // Not set in the source yet ([to set in Framer]),\n')
        out.append('  // so no constant:\n')
        out.append(''.join('  // `%s`\n' % role for role in unset))
    out.append('}\n')
    return ''.join(out)


def parse(data):
    lines = decode(data).split('\n')
    type_rows = read_type(lines)
    light, light_roles = read_colours(lines, LIGHT)
    dark, _ = read_colours(lines, DARK, light_roles)
    spacing, unset = read_spacing(lines)
    return type_rows, light, dark, spacing, unset


def generate(data):
    # {repository path: bytes}: the one generated file.
    type_rows, light, dark, spacing, unset = parse(data)
    text = tokens_dart(type_rows, light, dark, spacing, unset, sha256(data))
    return {TOKENS: text.encode('utf-8')}


def summary(data):
    type_rows, light, dark, spacing, unset = parse(data)
    return ['designgen: type %d' % len(type_rows), 'designgen: light %d' % len(light),
            'designgen: dark %d' % len(dark), 'designgen: spacing %d' % len(spacing),
            'designgen: unset %d' % len(unset)]


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
        report('designgen: usage: --write | --check, with --root DIR, --out DIR')
        return 1
    out = out or root
    try:
        data = read(root, DESIGN)
        outputs = generate(data)
        lines = summary(data)
    except DesignError as e:
        report('designgen: refused %s line %d' % (e.code, e.line))
        return 1
    if mode == '--write':
        if read(out, TOKENS) != outputs[TOKENS]:
            write_atomic(out, TOKENS, outputs[TOKENS])
            report('designgen: wrote ' + TOKENS)
        for line in lines:
            report(line)
        return 0
    differs = read(out, TOKENS) != outputs[TOKENS]
    if differs:
        report('designgen: differs ' + TOKENS)
    report('designgen: %s' % ('different' if differs else 'up to date'))
    return 1 if differs else 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception as e:  # never print a message: it could quote a file
        report('designgen: internal error ' + type(e).__name__)
        sys.exit(2)
~~~~

4. Green: `python3 -I -B tool/checks/tests/run_tests.py test_designgen` ends `Ran 12 tests`, `OK`; the whole run ends
   `Ran 207 tests`, `OK`. Then, from the repository root, `python3 -I -B tool/checks/designgen.py --check` prints
   `designgen: differs app/lib/design/tokens.g.dart`, `designgen: different` and exits 1 (no tokens yet; nothing is
   written in this task).

5. The gate (14 app tests). Commit `guardlib.py`, `designgen.py`, `tests/test_designgen.py`, `tests/mutations.py`:
   "Design values: designgen.py reads the Design System's tables into tokens (D49 a)". Then
   `python3 -I -B tool/checks/tests/mutations.py designgen.py` ends `mutations: 3 run, all caught`.

### Task 3 · G1 proves the tokens (D49 a)

1. The G1 tests and the new mutation row (and row 58's pattern, which follows the code), and the Dart test:

**Edit `tool/checks/tests/test_g1_g2.py`** (1 of 3)

~~~~python
import g2_copies
import test_wordsgen as invented
import wordsgen
from guardlib import GENERATED, LINES, WORDS_XCCONFIG

~~~~

~~~~python
import g2_copies
import designgen
import test_designgen as invented_design
import test_wordsgen as invented
import wordsgen
from guardlib import DESIGN, GENERATED, LINES, TOKENS, WORDS_XCCONFIG

~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (2 of 3)

~~~~python

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

~~~~python

def armed(csv_bytes=None, lists_bytes=None, generated=True, design=None):
    # An armed tree from an invented register and lists, with SOURCES
    # matching them and, when it can be made, the generated words; and an
    # invented Design System with its tokens (D49 a).
    c = csv_bytes if csv_bytes is not None else invented.register()
    l = lists_bytes if lists_bytes is not None else invented.lists()
    d = design if design is not None else invented_design.doc()
    files = {CSV: c, LISTS: l, DESIGN: d, SOURCES: line(CSV, c) + line(LISTS, l) + line(DESIGN, d)}
    if generated:
        files.update(wordsgen.generate(c, l))
    if design is None:
        files.update(designgen.generate(d))
    return files
~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (3 of 3)

~~~~python
                         [(LISTS, 5, 'generator-refused:lists-shape')])


class G2(GuardTest):
~~~~

~~~~python
                         [(LISTS, 5, 'generator-refused:lists-shape')])

    # D49 a: the design values.
    def test_design_missing_refuses(self):
        files = armed()
        del files[DESIGN]
        self.assertEqual(self.refused(files), [(DESIGN, 0, 'missing')])

    def test_tokens_missing_refuses(self):
        files = armed()
        del files[TOKENS]
        self.assertEqual(self.refused(files), [(TOKENS, 0, 'generated-missing')])

    def test_tokens_hand_edited_refuses(self):
        files = armed()
        files[TOKENS] = files[TOKENS].replace(b'0xFFF5F5EC', b'0xFFF5F5ED')
        self.assertEqual(self.refused(files), [(TOKENS, 0, 'generated-differs')])

    def test_design_refused_by_its_generator_refuses(self):
        bad = invented_design.doc(light=['| color.page | #F5F5EC, almost always |'])
        files = armed(design=bad)
        row = bad.decode('utf-8').split('\n').index('| color.page | #F5F5EC, almost always |') + 1
        self.assertEqual(self.refused(files), [(DESIGN, row, 'generator-refused:colour-form')])

    def test_design_checked_beside_a_words_refusal(self):
        files = armed()
        del files[TOKENS]
        files[CSV] = b'changed\n'
        found = self.refused(files)
        self.assertIn((CSV, 0, 'hash-mismatch'), found)
        self.assertIn((TOKENS, 0, 'generated-missing'), found)


class G2(GuardTest):
~~~~

**Edit `tool/checks/tests/mutations.py`** (1 of 2)

~~~~python
     ['test_g1_g2.G1.test_unknown_words_file_refuses']),
    ('g1_words.py', "return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown, []",
     "outputs = {}",
~~~~

~~~~python
     ['test_g1_g2.G1.test_unknown_words_file_refuses']),
    ('g1_words.py', "return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown + design, []",
     "outputs = {}",
~~~~

**Edit `tool/checks/tests/mutations.py`** (2 of 2)

~~~~python
     ['test_designgen.Generate.test_an_unset_value_has_no_constant']),
]
~~~~

~~~~python
     ['test_designgen.Generate.test_an_unset_value_has_no_constant']),
    ('g1_words.py', "    design = design_findings(src)\n", "    design = []\n",
     ['test_g1_g2.G1.test_tokens_hand_edited_refuses']),
]
~~~~

**File `app/test/design/tokens_test.dart`**

~~~~dart
// The generated design values (D49 a). G1 proves the file is the
// generator's output; these tests prove what its two classes compute.
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/tokens.g.dart';

void main() {
  test('letter spacing is the em value times the size', () {
    const role = TypeRole('Inter', FontWeight.w600, 20, 1.4, -0.02);
    expect(role.letterSpacing, closeTo(-0.4, 1e-9));
  });

  test('a type role makes its text style', () {
    const colour = Color(0xFF333333);
    final style = TypeRoles.h2.style(colour);
    expect(style.fontFamily, TypeRoles.h2.family);
    expect(style.fontWeight, TypeRoles.h2.weight);
    expect(style.fontSize, TypeRoles.h2.size);
    expect(style.height, TypeRoles.h2.height);
    expect(style.letterSpacing, TypeRoles.h2.letterSpacing);
    expect(style.color, colour);
  });

  test('a gradient has an end colour; a plain colour has none', () {
    expect(LightColours.record.isGradient, isTrue);
    expect(LightColours.page.isGradient, isFalse);
  });
}
~~~~

2. Red: `python3 -I -B tool/checks/tests/run_tests.py test_g1_g2` ends `FAILED (failures=5)`.

3. Write G1 (the whole file):

**File `tool/checks/g1_words.py`**

~~~~python
# G1 words: the register's and the lists' hashes match SOURCES, and the
# generated words (guardlib.GENERATED) are exactly what wordsgen makes
# from them. Nothing else may sit in the two words folders. The design
# values (D49 a): TOKENS is exactly what designgen makes from DESIGN,
# whose hash G2 proves. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside SOURCES.
import designgen
import wordsgen
from guardlib import (CSV, DESIGN, GENERATED, LISTS, MARKER, SOURCES, TOKENS, WORDS_ASSETS,
                      WORDS_LIB, Finding, parse_sources, sha256)

CODE = 'G1'
NAME = 'words'
KNOWN = (CSV, LISTS) + GENERATED


def design_findings(src):
    if not src.has(DESIGN):
        return [Finding(DESIGN, 0, 'missing')]
    try:
        outputs = designgen.generate(src.read(DESIGN))
    except designgen.DesignError as e:
        return [Finding(DESIGN, e.line, 'generator-refused:' + e.code)]
    if not src.has(TOKENS):
        return [Finding(TOKENS, 0, 'generated-missing')]
    if src.read(TOKENS) != outputs[TOKENS]:
        return [Finding(TOKENS, 0, 'generated-differs')]
    return []


def check(src):
    marker = src.has(MARKER)
    if marker and src.has(SOURCES):
        return [Finding(MARKER, 0, 'marker-with-sources')], []
    if marker:
        return [], ['NOT ARMED (awaiting import)']
    if not src.has(SOURCES):
        return [Finding(SOURCES, 0, 'no-sources')], []
    design = design_findings(src)
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
        return findings + unknown + design, []
    try:
        outputs = wordsgen.generate(src.read(CSV), src.read(LISTS))
    except wordsgen.WordsError as e:
        where = CSV if e.source == wordsgen.REGISTER else LISTS
        return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown + design, []
    for path in GENERATED:
        if not src.has(path):
            findings.append(Finding(path, 0, 'generated-missing'))
        elif src.read(path) != outputs[path]:
            findings.append(Finding(path, 0, 'generated-differs'))
    return findings + unknown + design, []
~~~~

4. Generate: `python3 -I -B tool/checks/designgen.py --write`. Expected, exactly:

       designgen: wrote app/lib/design/tokens.g.dart
       designgen: type 11
       designgen: light 16
       designgen: dark 14
       designgen: spacing 9
       designgen: unset 1

   `shasum -a 256 app/lib/design/tokens.g.dart` prints `0fe490a94ea69b682e88b169cbdac70b0c6e7d04a3fb5b428476be3636abcbda`; its second line names the Design
   System's sha256, `fcf8e8140d2b…`. A different hash stops the task.

5. Green: `run_tests.py test_g1_g2` ends `Ran 28 tests`, `OK`; the whole run `Ran 212 tests`, `OK`. The gate: 17 app
   tests. Commit `g1_words.py`, `tests/test_g1_g2.py`, `tests/mutations.py`, `app/lib/design/tokens.g.dart`,
   `app/test/design/tokens_test.dart`: "G1 proves tokens.g.dart is the generator's output from the Design System
   (D49 a)". Then `mutations.py g1_words.py` ends `mutations: 6 run, all caught`.

### Task 4 · The fonts' guards (D49 a, O4)

1. The tests and rows:

**Edit `tool/checks/tests/test_g0.py`**

~~~~python
class G0(GuardTest):
    guard = g0_kinds
~~~~

~~~~python
class G0(GuardTest):
    # D49 a: .txt is known in the fonts folder only, as UTF-8 text.
    def test_txt_in_the_fonts_folder_only(self):
        self.passed({'app/assets/fonts/OFL-Inter.txt': 'licence\n'})
        self.refused({'app/notes.txt': 'x\n'}, 'unknown-kind')
        self.refused({'app/assets/fonts/sub/OFL.txt': 'x\n'}, 'unknown-kind')
        self.refused({'app/assets/fonts/OFL.txt': b'\xff\xfe'}, 'unknown-kind')

    def test_a_font_is_binary(self):
        self.passed({'app/assets/fonts/A-Regular.ttf': b'\x00\x01font'})

    guard = g0_kinds
~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (1 of 2)

~~~~python
COPY = 'docs/source/handover.md'

~~~~

~~~~python
COPY = 'docs/source/handover.md'
FONTS_LIST = 'app/assets/fonts/fingerprints.txt'

~~~~

**Edit `tool/checks/tests/test_g1_g2.py`** (2 of 2)

~~~~python

    def test_unknown_path_outside_docs_source_refuses(self):
~~~~

~~~~python

    # D49 a: the fonts and their fingerprints.
    def fonts(self, listed=None, files=None):
        files = {'A-Regular.ttf': b'\x00a', 'OFL-A.txt': b'licence\n'} if files is None else files
        listed = files if listed is None else listed
        tree = {'app/assets/fonts/' + name: body for name, body in files.items()}
        tree[FONTS_LIST] = ''.join(hashlib.sha256(body).hexdigest() + '  ' + name + '\n'
                                   for name, body in listed.items())
        tree.update({COPY: 'h\n', SOURCES: line(COPY, 'h\n')})
        return tree

    def test_fonts_listed_pass(self):
        self.passed(self.fonts())

    def test_font_unlisted_refuses(self):
        tree = self.fonts(listed={'A-Regular.ttf': b'\x00a'})
        self.assertEqual(self.refused(tree), [('app/assets/fonts/OFL-A.txt', 0, 'font-unlisted')])

    def test_font_hash_mismatch_refuses(self):
        tree = self.fonts()
        tree['app/assets/fonts/A-Regular.ttf'] = b'\x00b'
        self.assertEqual(self.refused(tree),
                         [('app/assets/fonts/A-Regular.ttf', 0, 'font-hash-mismatch')])

    def test_font_listed_but_missing_refuses(self):
        tree = self.fonts(listed={'A-Regular.ttf': b'\x00a', 'B.ttf': b'\x00b'},
                          files={'A-Regular.ttf': b'\x00a'})
        self.assertEqual(self.refused(tree), [('app/assets/fonts/B.ttf', 0, 'font-missing')])

    def test_fingerprints_malformed_refuses(self):
        tree = self.fonts()
        tree[FONTS_LIST] += 'abc  A-Regular.ttf\n'
        self.assertIn((FONTS_LIST, 3, 'fingerprints-malformed'), self.refused(tree))

    def test_fonts_without_fingerprints_refuse(self):
        tree = self.fonts()
        del tree[FONTS_LIST]
        self.assertEqual(self.refused(tree), [(FONTS_LIST, 0, 'no-fingerprints')])

    def test_fonts_checked_when_not_armed(self):
        tree = self.fonts()
        tree['app/assets/fonts/A-Regular.ttf'] = b'\x00b'
        del tree[COPY], tree[SOURCES]
        tree[MARKER] = 'x\n'
        self.refused(tree, 'font-hash-mismatch')

    def test_unknown_path_outside_docs_source_refuses(self):
~~~~

**Edit `tool/checks/tests/mutations.py`**

~~~~python
     ['test_g1_g2.G1.test_tokens_hand_edited_refuses']),
]
~~~~

~~~~python
     ['test_g1_g2.G1.test_tokens_hand_edited_refuses']),
    ('g0_kinds.py', "fonts_txt = ext == '.txt' and posixpath.dirname(path) + '/' == FONTS",
     "fonts_txt = ext == '.txt'", ['test_g0.G0.test_txt_in_the_fonts_folder_only']),
    ('g2_copies.py', "        elif sha256(src.read(path) or b'') != listed[path]:", "        elif False:",
     ['test_g1_g2.G2.test_font_hash_mismatch_refuses']),
    ('g2_copies.py', "    refused += font_findings(src)\n", "",
     ['test_g1_g2.G2.test_font_unlisted_refuses']),
]
~~~~

2. Red: `run_tests.py test_g0 test_g1_g2` ends `FAILED (failures=7)`.

3. The guards:

**Edit `tool/checks/g0_kinds.py`** (1 of 2)

~~~~python
# unknown-kind. A branch that brings a new kind of file extends these
# lists, and the owner approves the change at the prompt.
import posixpath

from guardlib import LOCKFILES, MARKER, SOURCES, STRINGS_EN, STRINGS_SV, Finding

~~~~

~~~~python
# unknown-kind. A branch that brings a new kind of file extends these
# lists, and the owner approves the change at the prompt. D49 a: .txt is
# known in the fonts folder only (the licences and the fingerprints).
import posixpath

from guardlib import FONTS, LOCKFILES, MARKER, SOURCES, STRINGS_EN, STRINGS_SV, Finding

~~~~

**Edit `tool/checks/g0_kinds.py`** (2 of 2)

~~~~python
        return False
    if ext in UNSCANNED_EXT or b in UNSCANNED_NAMES or path in UNSCANNED_PATHS:
        # Known only as UTF-8 text with no NUL byte. Otherwise no guard
~~~~

~~~~python
        return False
    fonts_txt = ext == '.txt' and posixpath.dirname(path) + '/' == FONTS
    if fonts_txt or ext in UNSCANNED_EXT or b in UNSCANNED_NAMES or path in UNSCANNED_PATHS:
        # Known only as UTF-8 text with no NUL byte. Otherwise no guard
~~~~

**Edit `tool/checks/g2_copies.py`** (1 of 3)

~~~~python
# a folder named restricted (D32 Q18): those never leave the documents.
from guardlib import CSV, LISTS, MARKER, SOURCES, Finding, parse_sources, sha256

~~~~

~~~~python
# a folder named restricted (D32 Q18): those never leave the documents.
# The fonts (D49 a), armed or not: every file in the fonts folder is
# listed in its fingerprints file with its sha256, and matches it.
import re

from guardlib import (CSV, FINGERPRINTS, FONTS, LISTS, MARKER, SOURCES, Finding, parse_sources,
                      sha256)

~~~~

**Edit `tool/checks/g2_copies.py`** (2 of 3)

~~~~python
REFUSED_NAMES = ('privacy-ethics-safety.md',)

~~~~

~~~~python
REFUSED_NAMES = ('privacy-ethics-safety.md',)
# shasum -a 256's own line: the digest, two spaces, a plain file name.
FINGERPRINT = re.compile(r'^([0-9a-f]{64})  ([A-Za-z0-9._-]+)$')

~~~~

**Edit `tool/checks/g2_copies.py`** (3 of 3)

~~~~python

def check(src):
    refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
    in_dir = [p for p in src.paths if p.startswith(DIR)]
~~~~

~~~~python

def font_findings(src):
    fonts = [p for p in src.paths if p.startswith(FONTS) and p != FINGERPRINTS]
    if not src.has(FINGERPRINTS):
        return [Finding(FINGERPRINTS, 0, 'no-fingerprints')] if fonts else []
    listed = {}
    findings = []
    for n, line in enumerate((src.text(FINGERPRINTS) or '').split('\n'), 1):
        if not line:
            continue
        m = FINGERPRINT.match(line)
        if not m or FONTS + m.group(2) in listed:
            findings.append(Finding(FINGERPRINTS, n, 'fingerprints-malformed'))
            continue
        listed[FONTS + m.group(2)] = m.group(1)
    for path in fonts:
        if path not in listed:
            findings.append(Finding(path, 0, 'font-unlisted'))
        elif sha256(src.read(path) or b'') != listed[path]:
            findings.append(Finding(path, 0, 'font-hash-mismatch'))
    for path in sorted(listed):
        if not src.has(path):
            findings.append(Finding(path, 0, 'font-missing'))
    return findings


def check(src):
    refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
    refused += font_findings(src)
    in_dir = [p for p in src.paths if p.startswith(DIR)]
~~~~

4. Green: `run_tests.py test_g0 test_g1_g2` ends `Ran 49 tests`, `OK`; the whole run `Ran 221 tests`, `OK`. The gate
   (17 app tests; no font yet, so G2's font check finds nothing). Commit the five files: "Fonts: G0 knows .txt in
   app/assets/fonts/ only; G2 checks each font's fingerprint (D49 a)". Then `mutations.py g0_kinds.py g2_copies.py`
   ends `mutations: 10 run, all caught`.

### Task 5 · [OWNER] The fonts (D49 a)

1. Claude Code has written this script in Task 1 (not committed):

**File `.scratch/journal-core/fonts.sh`**

~~~~sh
#!/bin/sh
# journal-core, Task 5 (D49 a): the owner's. Copies the static fonts and
# their licences from the five Google Fonts downloads into
# app/assets/fonts/, then writes fingerprints.txt (shasum -a 256).
# Nothing is copied unless every file is found, and the target folder
# must not exist yet.
# Run from the repository root:  sh .scratch/journal-core/fonts.sh [folder]
# The folder holds Tangerine.zip, Sorts_Mill_Goudy.zip, Inter.zip,
# Nunito.zip and Habibi.zip (default: ~/Downloads). It stops, copying
# nothing, if a download or a file in it is missing.
set -eu
DL="${1:-$HOME/Downloads}"
OUT=app/assets/fonts
TMP=$(mktemp -d "${TMPDIR:-/tmp}/fonts.XXXXXX")
trap 'rm -rf "$TMP"' EXIT
fail=0
if [ -e "$OUT" ]; then
  echo "fonts: $OUT already exists; STOPPED"
  exit 1
fi
mkdir "$TMP/out"

# take ZIP FILE NAME: the first file called FILE anywhere in ZIP.zip,
# set aside as NAME.
take() {
  if [ ! -f "$DL/$1.zip" ]; then
    echo "fonts: missing download $1.zip"
    fail=1
    return
  fi
  if [ ! -d "$TMP/$1" ]; then
    mkdir "$TMP/$1"
    unzip -q "$DL/$1.zip" -d "$TMP/$1"
  fi
  found=$(find "$TMP/$1" -type f -name "$2" | head -n 1)
  if [ -z "$found" ]; then
    echo "fonts: $1.zip has no $2"
    fail=1
    return
  fi
  cp "$found" "$TMP/out/$3"
  echo "fonts: found $3"
}

take Tangerine Tangerine-Regular.ttf Tangerine-Regular.ttf
take Tangerine OFL.txt OFL-Tangerine.txt
take Sorts_Mill_Goudy SortsMillGoudy-Regular.ttf SortsMillGoudy-Regular.ttf
take Sorts_Mill_Goudy OFL.txt OFL-SortsMillGoudy.txt
take Inter Inter_18pt-Regular.ttf Inter-Regular.ttf
take Inter Inter_18pt-SemiBold.ttf Inter-SemiBold.ttf
take Inter OFL.txt OFL-Inter.txt
take Nunito Nunito-Regular.ttf Nunito-Regular.ttf
take Nunito Nunito-Italic.ttf Nunito-Italic.ttf
take Nunito OFL.txt OFL-Nunito.txt
take Habibi Habibi-Regular.ttf Habibi-Regular.ttf
take Habibi OFL.txt OFL-Habibi.txt

if [ "$fail" != 0 ]; then
  echo "fonts: STOPPED (nothing copied)"
  exit 1
fi
mkdir -p "$OUT"
cp "$TMP"/out/* "$OUT"/
cd "$OUT"
shasum -a 256 *.ttf OFL-*.txt > fingerprints.txt
echo "fonts: $(ls | wc -l | tr -d ' ') files, fingerprints.txt written"
~~~~

2. **[OWNER]** Download five families from fonts.google.com, each with "Get font", then "Download all", into
   `~/Downloads`: **Tangerine**, **Sorts Mill Goudy**, **Inter**, **Nunito**, **Habibi**. The zips are expected as
   `Tangerine.zip`, `Sorts_Mill_Goudy.zip`, `Inter.zip`, `Nunito.zip` and `Habibi.zip` [ASSUMED; rename one if your
   browser named it otherwise]. Then:

   Paste 1 — Terminal

       cd ~/Developer/soul-dreams-app && sh .scratch/journal-core/fonts.sh && cat app/assets/fonts/fingerprints.txt && git status --short

   Expected: twelve `fonts: found …` lines, then `fonts: 13 files, fingerprints.txt written`; twelve fingerprint
   lines (seven `.ttf`, five `OFL-*.txt`); `git status` shows `?? app/assets/fonts/`. If it prints
   `fonts: … has no …` or `missing download`, it copied nothing: send the output. Inter's files are its 18pt statics
   (Part 4, Q6). Send the output to Claude Code; nothing else from the downloads is needed.

### Task 6 · The fonts declared (D49 a)

1. The test:

**File `app/test/design/fonts_test.dart`**

~~~~dart
// The fonts (D49 a): every face and weight the design values use is
// declared in pubspec.yaml, every declared file is there, and every font
// file is declared. G2 proves each file's fingerprint. `flutter test`
// runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// (family, weight, italic) for each asset pubspec.yaml declares, read
/// from its fonts block.
Map<String, (String, int, bool)> declared() {
  final out = <String, (String, int, bool)>{};
  var family = '';
  var asset = '';
  for (final line in File('pubspec.yaml').readAsLinesSync()) {
    final f = RegExp(r'^    - family: (\w+)$').firstMatch(line);
    final a = RegExp(r'^        - asset: (\S+)$').firstMatch(line);
    final w = RegExp(r'^          weight: (\d+)$').firstMatch(line);
    if (f != null) family = f[1]!;
    if (a != null) {
      asset = a[1]!;
      out[asset] = (family, 400, false);
    }
    final (name, weight, italic) = out[asset] ?? ('', 400, false);
    if (w != null) out[asset] = (name, int.parse(w[1]!), italic);
    if (line == '          style: italic') out[asset] = (name, weight, true);
  }
  return out;
}

void main() {
  test('every family and weight in the design values is declared', () {
    final tokens = File('lib/design/tokens.g.dart').readAsStringSync();
    final used = {
      for (final m in RegExp(r"TypeRole\('(\w+)', FontWeight\.w(\d+),").allMatches(tokens))
        (m[1]!, int.parse(m[2]!)),
    };
    final have = {for (final d in declared().values) if (!d.$3) (d.$1, d.$2)};
    expect(used, isNotEmpty);
    expect(have.containsAll(used), isTrue, reason: '$used against $have');
  });

  test("the dreamer voice's italic is declared (Design System §1)", () {
    expect(declared().values, contains(('Nunito', 400, true)));
  });

  test('every declared font is there, and every font file is declared', () {
    final files = Directory('assets/fonts')
        .listSync()
        .map((e) => e.path.replaceAll(r'\', '/'))
        .where((p) => p.endsWith('.ttf'))
        .toSet();
    expect(declared().keys.toSet(), files);
  });
}
~~~~

2. Red: `cd app && fvm flutter test --no-pub test/design/fonts_test.dart` ends `+0 -3: Some tests failed.`

3. Declare the fonts:

**Edit `app/pubspec.yaml`**

~~~~yaml
  uses-material-design: true
~~~~

~~~~yaml
  uses-material-design: true

  # The faces the Design System names (D49 a), bundled: never fetched at
  # run time (R10). Each file is fingerprinted in assets/fonts/.
  fonts:
    - family: Tangerine
      fonts:
        - asset: assets/fonts/Tangerine-Regular.ttf
    - family: SortsMillGoudy
      fonts:
        - asset: assets/fonts/SortsMillGoudy-Regular.ttf
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
    - family: Nunito
      fonts:
        - asset: assets/fonts/Nunito-Regular.ttf
        - asset: assets/fonts/Nunito-Italic.ttf
          style: italic
    - family: Habibi
      fonts:
        - asset: assets/fonts/Habibi-Regular.ttf
~~~~

4. Green: the gate, 20 app tests. `python3 -I -B tool/checks/guards.py` passes with the fonts in place (G2 checks
   every fingerprint). Commit `app/pubspec.yaml`, `app/test/design/fonts_test.dart` and `app/assets/fonts` (the
   thirteen files, staged by that path): "Fonts: the five faces bundled, fingerprinted and declared (D49 a)".

### Task 7 · The invented nights (R2)

The fixture's text is not in this plan: invented nights live in one file (R2; Part 4, Q2).

1. The reader and its test:

**File `app/test/fixtures.dart`**

~~~~dart
// The invented nights (R2): every test night comes from
// fixtures/invented-nights.json, read here. `flutter test` runs in app/.
import 'dart:convert';
import 'dart:io';

/// One invented night, as the fixture file holds it.
final class InventedNight {
  const InventedNight(this.key, this.lang, this.name, this.dreams);

  final String key;
  final String lang;
  final String? name;
  final List<String> dreams;
}

/// Every invented night, in the file's order.
List<InventedNight> inventedNights() {
  final json = jsonDecode(File('../fixtures/invented-nights.json').readAsStringSync());
  return [
    for (final n in (json as Map<String, Object?>)['nights'] as List<Object?>)
      if (n case {'key': String key, 'lang': String lang, 'dreams': List<Object?> dreams})
        InventedNight(key, lang, (n as Map)['name'] as String?, dreams.cast<String>()),
  ];
}

/// The invented night named [key].
InventedNight invented(String key) => inventedNights().singleWhere((n) => n.key == key);
~~~~

**File `app/test/fixtures_test.dart`**

~~~~dart
// The invented nights file (R2) has the shape the tests rely on.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  test('every entry reads as a night', () {
    final json = jsonDecode(File('../fixtures/invented-nights.json').readAsStringSync());
    final raw = (json as Map<String, Object?>)['nights'] as List<Object?>;
    expect(inventedNights(), hasLength(raw.length));
  });

  test('keys are unique; both languages; every dream has words', () {
    final nights = inventedNights();
    expect(nights.map((n) => n.key).toSet(), hasLength(nights.length));
    expect(nights.map((n) => n.lang).toSet(), {'en', 'sv'});
    for (final n in nights) {
      expect(n.dreams, isNotEmpty, reason: n.key);
      expect(n.dreams.every((d) => d.trim().isNotEmpty), isTrue, reason: n.key);
    }
  });

  test('the cases the journal tests need are there', () {
    expect(inventedNights().any((n) => n.dreams.length > 1), isTrue);
    expect(inventedNights().any((n) => n.name != null), isTrue);
  });
}
~~~~

2. Red: `cd app && fvm flutter test --no-pub test/fixtures_test.dart` ends `+0 -3: Some tests failed.`

3. From the repository root: `mkdir -p fixtures && cp .scratch/journal-core/invented-nights.json fixtures/`, then
   `shasum -a 256 fixtures/invented-nights.json` prints `feb1baaea50d2d313dc5aefd3f3b21af0d47690a6564614894af13eec6985932`.

4. Green: the gate, 23 app tests. Commit `fixtures/invented-nights.json`, `app/test/fixtures.dart`,
   `app/test/fixtures_test.dart`: "Fixtures: the invented nights file, and the tests' reader (R2; D49)".

### Task 8 · A night and its format (D49 b, O5)

1. The test, and the reader's helper that makes Nights from the fixture:

**File `app/test/journal/night_test.dart`**

~~~~dart
// A night and its file format, version 1 (D49 b).
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';

import '../fixtures.dart';

Map<String, Object?> fields(Night n) =>
    jsonDecode(utf8.decode(encodeNight(n))) as Map<String, Object?>;

Uint8List bytesOf(Map<String, Object?> json) => utf8.encode(jsonEncode(json));

void main() {
  test('every invented night survives encoding and decoding', () {
    for (final n in nightsFromFixtures()) {
      expect(decodeNight(encodeNight(n)), n);
    }
  });

  test('the file holds exactly the version-1 fields', () {
    final n = nightsFromFixtures().first;
    final json = fields(n);
    expect(json.keys.toSet(),
        {'version', 'id', 'firstRecorded', 'date', 'lang', 'name', 'dreams'});
    expect(json['version'], 1);
    expect(json['id'], n.id);
    expect(json['firstRecorded'], '2026-10-12T06:40:00.000Z');
    expect(json['date'], '2026-10-12');
    expect(json['lang'], 'en');
    expect(json['dreams'], n.dreams);
  });

  test('anything not a version-1 night decodes to null', () {
    final good = fields(nightsFromFixtures().first);
    Map<String, Object?> without(String key) => {...good}..remove(key);
    Map<String, Object?> with_(String key, Object? value) => {...good, key: value};
    final bad = <Uint8List>[
      Uint8List.fromList([0xff, 0xfe]),
      utf8.encode('not json'),
      utf8.encode('[]'),
      bytesOf(without('dreams')),
      bytesOf(with_('extra', 1)),
      bytesOf(with_('version', 2)),
      bytesOf(with_('id', 'ABC')),
      bytesOf(with_('firstRecorded', '2026-10-12T06:40:00.000')),
      bytesOf(with_('firstRecorded', 'tomorrow')),
      bytesOf(with_('date', '2026-02-30')),
      bytesOf(with_('date', '12/10/2026')),
      bytesOf(with_('lang', 'de')),
      bytesOf(with_('name', 7)),
      bytesOf(with_('dreams', [1])),
      bytesOf(with_('dreams', 'one')),
    ];
    for (final (i, b) in bad.indexed) {
      expect(decodeNight(b), isNull, reason: 'case $i');
    }
  });

  test('a new id is 32 hex digits, and two differ', () {
    final a = newNightId();
    final b = newNightId();
    expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(a, isNot(b));
    expect(newNightId(Random(7)), newNightId(Random(7)));
  });

  test('a bad id or a local time is refused', () {
    final n = nightsFromFixtures().first;
    expect(
        () => Night(id: 'x', firstRecorded: n.firstRecorded, date: n.date, lang: n.lang, dreams: n.dreams),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'id')));
    expect(
        () => Night(id: n.id, firstRecorded: DateTime(2026), date: n.date, lang: n.lang, dreams: n.dreams),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'firstRecorded')));
  });

  test("a night's dreams cannot be changed in place", () {
    final n = nightsFromFixtures().first;
    expect(() => n.dreams.add('x'), throwsUnsupportedError);
  });
}
~~~~

**Edit `app/test/fixtures.dart`** (1 of 2)

~~~~dart
import 'dart:io';

~~~~

~~~~dart
import 'dart:io';
import 'dart:math';

import 'package:souldreams/journal/night.dart';
import 'package:souldreams/words/lines.g.dart' show Lang;

~~~~

**Edit `app/test/fixtures.dart`** (2 of 2)

~~~~dart
InventedNight invented(String key) => inventedNights().singleWhere((n) => n.key == key);
~~~~

~~~~dart
InventedNight invented(String key) => inventedNights().singleWhere((n) => n.key == key);

/// Each invented night as a Night, with ids from a seeded source and
/// first recordings an hour apart.
List<Night> nightsFromFixtures([int seed = 1]) {
  final random = Random(seed);
  var at = DateTime.utc(2026, 10, 12, 5, 40);
  return [
    for (final n in inventedNights())
      Night(
        id: newNightId(random),
        firstRecorded: at = at.add(const Duration(hours: 1)),
        date: (year: at.year, month: at.month, day: at.day),
        lang: Lang.values.byName(n.lang),
        name: n.name,
        dreams: n.dreams,
      ),
  ];
}
~~~~

2. Red: `fvm flutter test --no-pub test/journal/night_test.dart` fails to load (`night.dart` not found).

3. The night:

**File `app/lib/journal/night.dart`**

~~~~dart
// A night as the journal keeps it on the phone (D49 b; R11), and its
// file format. Which fields a night holds is settled with Product's
// answers; until the format first reaches the founder app it may change
// freely (D49, O5). After that, any change is a storage change
// (docs/workflow.md, "On-phone storage changes").
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../words/lines.g.dart' show Lang;

/// The file format's version, written in every night's file.
const formatVersion = 1;

final _id = RegExp(r'^[0-9a-f]{32}$');
final _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
const _keys = {'version', 'id', 'firstRecorded', 'date', 'lang', 'name', 'dreams'};

/// A new night's id: 128 bits from the system's secure source, as 32 hex
/// digits. It names a file on the phone and is never sent anywhere (R4).
String newNightId([Random? random]) {
  final r = random ?? Random.secure();
  return [for (var i = 0; i < 16; i++) r.nextInt(256).toRadixString(16).padLeft(2, '0')].join();
}

/// A calendar date, as the phone showed it at the first recording.
typedef NightDate = ({int year, int month, int day});

final class Night {
  Night({
    required this.id,
    required this.firstRecorded,
    required this.date,
    required this.lang,
    this.name,
    required List<String> dreams,
  }) : dreams = List.unmodifiable(dreams) {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    if (!firstRecorded.isUtc) throw ArgumentError('firstRecorded');
  }

  final String id;

  /// The moment of the first recording, in UTC.
  final DateTime firstRecorded;

  /// The phone's date at the first recording, kept so that it never moves.
  final NightDate date;

  /// The language the night was recorded in.
  final Lang lang;

  /// The dreamer's name for the night, if they gave one.
  final String? name;

  /// The dreams, in the dreamer's words, in order.
  final List<String> dreams;

  @override
  bool operator ==(Object other) =>
      other is Night &&
      other.id == id &&
      other.firstRecorded == firstRecorded &&
      other.date == date &&
      other.lang == lang &&
      other.name == name &&
      listEquals(other.dreams, dreams);

  @override
  int get hashCode => Object.hash(id, firstRecorded, date, lang, name, Object.hashAll(dreams));
}

String _two(int n) => n.toString().padLeft(2, '0');

/// The night's file: UTF-8 JSON, version [formatVersion].
Uint8List encodeNight(Night n) => utf8.encode(jsonEncode({
      'version': formatVersion,
      'id': n.id,
      'firstRecorded': n.firstRecorded.toIso8601String(),
      'date': '${n.date.year.toString().padLeft(4, '0')}-${_two(n.date.month)}-${_two(n.date.day)}',
      'lang': n.lang.name,
      'name': n.name,
      'dreams': n.dreams,
    }));

/// The night in [bytes], or null when they are not a whole night of this
/// format. Nothing is guessed or repaired.
Night? decodeNight(Uint8List bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _keys)) return null;
  if (json
      case {
        'version': formatVersion,
        'id': final String id,
        'firstRecorded': final String recorded,
        'date': final String date,
        'lang': final String lang,
        'name': final String? name,
        'dreams': final List<Object?> dreams,
      }) {
    final at = DateTime.tryParse(recorded);
    final d = _date.firstMatch(date);
    final language = Lang.values.where((l) => l.name == lang).firstOrNull;
    if (!_id.hasMatch(id) || at == null || !at.isUtc || d == null || language == null) return null;
    final (y, m, day) = (int.parse(d[1]!), int.parse(d[2]!), int.parse(d[3]!));
    final check = DateTime.utc(y, m, day);
    if (check.year != y || check.month != m || check.day != day) return null;
    if (dreams.any((x) => x is! String)) return null;
    return Night(
      id: id,
      firstRecorded: at,
      date: (year: y, month: m, day: day),
      lang: language,
      name: name,
      dreams: dreams.cast<String>(),
    );
  }
  return null;
}
~~~~

4. Green: the gate, 29 app tests. Commit the three files: "Journal: a night and its file format, version 1 (D49 b)".

### Task 9 · The store (D49 b, c, O6, O7)

1. The test folder and the tests:

**File `app/test/journal/io_journal_files.dart`**

~~~~dart
// The journal's folder on the Mac, for tests: the same rules as the
// phone's (journal_files.dart), with no backup flag or file protection.
import 'dart:io';
import 'dart:typed_data';

import 'package:souldreams/journal/journal_files.dart';

class IoJournalFiles implements JournalFiles {
  IoJournalFiles(this.dir);

  final Directory dir;

  File _file(String name) {
    if (!validName(name)) throw ArgumentError('name');
    return File('${dir.path}/$name');
  }

  @override
  Future<void> open() => dir.create(recursive: true);

  @override
  Future<List<String>> list() async => [
        for (final e in dir.listSync())
          if (e is File) e.uri.pathSegments.last,
      ]..sort();

  @override
  Future<Uint8List?> read(String name) async {
    final f = _file(name);
    return f.existsSync() ? f.readAsBytesSync() : null;
  }

  @override
  Future<void> write(String name, Uint8List bytes) async =>
      _file(name).writeAsBytesSync(bytes, flush: true);

  @override
  Future<void> rename(String from, String to) async => _file(from).renameSync(_file(to).path);

  @override
  Future<void> delete(String name) async {
    final f = _file(name);
    if (f.existsSync()) f.deleteSync();
  }

  /// Every file's bytes, by name: what a look at the whole folder finds.
  Map<String, Uint8List> everything() => {
        for (final e in dir.listSync(recursive: true))
          if (e is File) e.path.substring(dir.path.length + 1): e.readAsBytesSync(),
      };
}
~~~~

**File `app/test/journal/journal_store_test.dart`**

~~~~dart
// The journal store (D49 b, c): deleting removes everything, an edit
// leaves one version, an interrupted save leaves nothing behind, and a
// file that does not read as a night is skipped and never touched.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';

import '../fixtures.dart';
import 'io_journal_files.dart';

/// True when [haystack] holds [needle] anywhere.
bool holds(Uint8List haystack, List<int> needle) {
  for (var i = 0; i + needle.length <= haystack.length; i++) {
    var all = true;
    for (var j = 0; j < needle.length && all; j++) {
      all = haystack[i + j] == needle[j];
    }
    if (all) return true;
  }
  return false;
}

/// Each way a night's words could sit in a file: as typed, and as JSON
/// writes them.
List<List<int>> traces(Night n) => [
      for (final d in n.dreams) ...[utf8.encode(d), utf8.encode(jsonEncode(d))],
      if (n.name != null) utf8.encode(n.name!),
      utf8.encode(n.id),
    ];

/// The rename fails: a save interrupted between its two steps.
final class BrokenRename extends IoJournalFiles {
  BrokenRename(super.dir);

  @override
  Future<void> rename(String from, String to) async => throw const FileSystemException('rename');
}

void main() {
  late Directory dir;
  late IoJournalFiles files;
  final lines = <String>[];
  final sink = SafeLog.sink;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('journal-');
    files = IoJournalFiles(Directory('${dir.path}/Journal'));
    lines.clear();
    SafeLog.sink = lines.add;
  });

  tearDown(() {
    SafeLog.sink = sink;
    dir.deleteSync(recursive: true);
  });

  test('saved nights come back, earliest first, one file each', () async {
    final store = await JournalStore.open(files);
    final nights = nightsFromFixtures();
    for (final n in nights.reversed) {
      await store.save(n);
    }
    expect(await store.nights(), nights);
    expect(files.everything().keys.toSet(), {for (final n in nights) JournalStore.fileOf(n.id)});
    expect(lines, isEmpty);
  });

  test('deleting a night leaves nothing of it anywhere', () async {
    final store = await JournalStore.open(files);
    final nights = nightsFromFixtures();
    for (final n in nights) {
      await store.save(n);
    }
    final gone = nights[1];
    final before = files.everything();
    await store.delete(gone.id);
    final after = files.everything();
    expect(after.length, before.length - 1);
    for (final bytes in after.values) {
      for (final t in traces(gone)) {
        expect(holds(bytes, t), isFalse);
      }
    }
    after.forEach((name, bytes) => expect(listEquals(bytes, before[name]), isTrue, reason: name));
    expect(await store.nights(), [for (final n in nights) if (n != gone) n]);
  });

  test('an edit leaves one version, and the earlier words nowhere', () async {
    final store = await JournalStore.open(files);
    final [first, second, ...] = nightsFromFixtures();
    await store.save(first);
    final edited = Night(
        id: first.id,
        firstRecorded: first.firstRecorded,
        date: first.date,
        lang: first.lang,
        dreams: second.dreams);
    await store.save(edited);
    final all = files.everything();
    expect(all.keys, [JournalStore.fileOf(first.id)]);
    for (final t in traces(first).take(first.dreams.length * 2)) {
      expect(holds(all.values.single, t), isFalse);
    }
    expect(await store.nights(), [edited]);
  });

  test('deleting the journal empties the folder', () async {
    final store = await JournalStore.open(files);
    for (final n in nightsFromFixtures()) {
      await store.save(n);
    }
    await store.markFirstUseSeen();
    await files.write('night-${'0' * 32}.json', utf8.encode('{}'));
    await files.write('notes', utf8.encode('x'));
    await files.write('${JournalStore.tempPrefix}night-${'1' * 32}.json', utf8.encode('x'));
    await store.deleteAll();
    expect(files.everything(), isEmpty);
    expect(await store.firstUseSeen(), isFalse);
    expect(await store.nights(), isEmpty);
  });

  test('a save cut short leaves the last whole version', () async {
    final night = nightsFromFixtures().first;
    final store = await JournalStore.open(files);
    await store.save(night);
    final changed = Night(
        id: night.id,
        firstRecorded: night.firstRecorded,
        date: night.date,
        lang: night.lang,
        dreams: nightsFromFixtures()[2].dreams);
    final broken = await JournalStore.open(BrokenRename(files.dir));
    await expectLater(broken.save(changed), throwsA(isA<FileSystemException>()));
    expect(files.everything().keys.where((k) => k.startsWith(JournalStore.tempPrefix)), hasLength(1));
    final reopened = await JournalStore.open(files);
    expect(files.everything().keys, [JournalStore.fileOf(night.id)]);
    expect(await reopened.nights(), [night]);
    expect(lines, ['journalTempSwept']);
  });

  test('an unreadable file is skipped with a code, never touched', () async {
    final store = await JournalStore.open(files);
    final [good, other, ...] = nightsFromFixtures();
    await store.save(good);
    final wrongId = encodeNight(other);
    final bad = <String, Uint8List>{
      'night-${'a' * 32}.json': utf8.encode('not json'),
      'night-${'b' * 32}.json': Uint8List.fromList([0xff, 0xfe, 0x00]),
      'night-${'c' * 32}.json': wrongId,
      'night-${'d' * 32}.json': utf8.encode(utf8.decode(encodeNight(good)).replaceFirst('"version":1', '"version":2')),
    };
    for (final MapEntry(:key, :value) in bad.entries) {
      await files.write(key, value);
    }
    expect(await store.nights(), [good]);
    expect(lines, List.filled(bad.length, 'journalFileSkipped'));
    await store.save(other);
    await store.delete(good.id);
    final all = files.everything();
    bad.forEach((name, bytes) => expect(listEquals(all[name], bytes), isTrue, reason: name));
  });

  test('a file that is not a night is left alone, silently', () async {
    final store = await JournalStore.open(files);
    await files.write('notes', utf8.encode('x'));
    expect(await store.nights(), isEmpty);
    expect(lines, isEmpty);
    expect(files.everything().keys, ['notes']);
  });

  test('the first-use flag is kept until the journal is deleted', () async {
    final store = await JournalStore.open(files);
    expect(await store.firstUseSeen(), isFalse);
    await store.markFirstUseSeen();
    expect(await store.firstUseSeen(), isTrue);
    expect(await (await JournalStore.open(files)).firstUseSeen(), isTrue);
    await store.deleteAll();
    expect(await store.firstUseSeen(), isFalse);
  });

  test('a malformed id is refused before any file is named', () {
    expect(() => JournalStore.fileOf('../x'), throwsArgumentError);
    expect(() => IoJournalFiles(dir).read('../x'), throwsArgumentError);
  });
}
~~~~

2. Red: `fvm flutter test --no-pub test/journal/journal_store_test.dart` fails to load (`journal_files.dart` not
   found).

3. The log events, the folder's interface and the store:

**Edit `app/lib/core/safe_log.dart`**

~~~~dart
/// Every event the app may log. A new event is a new value here.
enum LogEvent { appStarted, wrongFlavour }

~~~~

~~~~dart
/// Every event the app may log. A new event is a new value here.
enum LogEvent {
  appStarted,
  wrongFlavour,

  /// The journal (D49): a temporary file from an interrupted save removed;
  /// a file that does not read as a night skipped; the phone check's result.
  journalTempSwept,
  journalFileSkipped,
  journalCheckPassed,
  journalCheckFailed,
}

~~~~

**File `app/lib/journal/journal_files.dart`**

~~~~dart
// The journal's folder, as the store sees it (D49 b): a flat folder of
// named files. On the phone it is Library/Application Support/Journal,
// excluded from backup, every file with complete file protection
// (ChannelJournalFiles and AppDelegate.swift). In tests, a folder on the
// Mac.
import 'dart:typed_data';

final _name = RegExp(r'^[A-Za-z0-9._-]+$');

/// A name the folder accepts: letters, digits, '.', '_' and '-', never
/// '.' and never starting with '..'. The Swift side holds the same rule.
bool validName(String name) => _name.hasMatch(name) && name != '.' && !name.startsWith('..');

abstract interface class JournalFiles {
  /// Creates the folder if needed and applies its protections.
  Future<void> open();

  /// Every file's name, sorted.
  Future<List<String>> list();

  /// The file's bytes, or null when there is no such file.
  Future<Uint8List?> read(String name);

  /// Creates or replaces the file.
  Future<void> write(String name, Uint8List bytes);

  /// Renames [from] to [to] in one step, replacing [to].
  Future<void> rename(String from, String to);

  /// Deletes the file; nothing happens when there is none.
  Future<void> delete(String name);
}

/// What the phone check reads back (D49 c): whether the folder is
/// excluded from backup, and whether the folder and the named file have
/// complete file protection.
typedef Protection = ({bool excluded, bool folderComplete, bool fileComplete});

abstract interface class JournalProtection {
  Future<Protection> protection(String name);
}
~~~~

**File `app/lib/journal/journal_store.dart`**

~~~~dart
// The journal on the phone (D49 b; R11): one JSON file per night. A save
// writes the whole night to a temporary file and renames it into place,
// so the folder always holds one whole version of each night and no
// earlier one. Deleting a night deletes its file; deleting the journal
// deletes every file in the folder. A file that does not read as a night
// is skipped with a code and left exactly as it is (D49 c), until the
// journal is deleted.
import 'dart:typed_data';

import '../core/safe_log.dart';
import 'journal_files.dart';
import 'night.dart';

final _nightFile = RegExp(r'^night-([0-9a-f]{32})\.json$');
final _id = RegExp(r'^[0-9a-f]{32}$');

final class JournalStore {
  JournalStore._(this._files);

  final JournalFiles _files;

  /// What a save writes first, before the rename.
  static const tempPrefix = '.tmp-';

  /// Kept once the recording screen's first-use line has been met
  /// (MP·10, then MP·32); removed with the journal (D49 c, O6).
  static const firstUseFlag = 'first-use-seen';

  /// The name of a night's file.
  static String fileOf(String id) {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    return 'night-$id.json';
  }

  /// Opens the folder, and removes what an interrupted save left.
  static Future<JournalStore> open(JournalFiles files) async {
    await files.open();
    for (final name in await files.list()) {
      if (name.startsWith(tempPrefix)) {
        await files.delete(name);
        SafeLog.event(LogEvent.journalTempSwept);
      }
    }
    return JournalStore._(files);
  }

  /// Every night that reads, earliest first recording first.
  Future<List<Night>> nights() async {
    final out = <Night>[];
    for (final name in await _files.list()) {
      final match = _nightFile.firstMatch(name);
      if (match == null) continue;
      final bytes = await _files.read(name);
      final night = bytes == null ? null : decodeNight(bytes);
      if (night == null || night.id != match[1]) {
        SafeLog.event(LogEvent.journalFileSkipped);
        continue;
      }
      out.add(night);
    }
    out.sort((a, b) {
      final c = a.firstRecorded.compareTo(b.firstRecorded);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
    return out;
  }

  /// Saves the night whole, replacing any earlier version.
  Future<void> save(Night night) async {
    final name = fileOf(night.id);
    await _files.write(tempPrefix + name, encodeNight(night));
    await _files.rename(tempPrefix + name, name);
  }

  /// Deletes the night's file.
  Future<void> delete(String id) => _files.delete(fileOf(id));

  /// Deletes every file in the journal's folder.
  Future<void> deleteAll() async {
    for (final name in await _files.list()) {
      await _files.delete(name);
    }
  }

  Future<bool> firstUseSeen() async => (await _files.list()).contains(firstUseFlag);

  Future<void> markFirstUseSeen() => _files.write(firstUseFlag, Uint8List(0));
}
~~~~

4. Green: the gate, 38 app tests. Commit the five files: "Journal: the store, one file per night, with the deletion
   proofs (D49 b, c)".

### Task 10 · The folder on the phone, and the phone check (D49 b, c, O1, O10)

1. The tests:

**File `app/test/journal/channel_journal_files_test.dart`**

~~~~dart
// The Dart side of the journal's channel (D49 b): each call's name and
// arguments, as AppDelegate.swift reads them. `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/channel_journal_files.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(journalChannel);
  final calls = <MethodCall>[];
  late Object? Function(MethodCall) answer;
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    calls.clear();
    answer = (_) => null;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return answer(call);
    });
  });

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('each call has its name and arguments', () async {
    const files = ChannelJournalFiles();
    final bytes = Uint8List.fromList([1, 2, 3]);
    await files.open();
    await files.write('a.json', bytes);
    await files.rename('a.json', 'b.json');
    await files.read('b.json');
    await files.delete('b.json');
    await files.list();
    expect([for (final c in calls) c.method],
        ['open', 'write', 'rename', 'read', 'delete', 'list']);
    expect(calls[0].arguments, isNull);
    expect(calls[1].arguments, {'name': 'a.json', 'bytes': bytes});
    expect(calls[2].arguments, {'from': 'a.json', 'to': 'b.json'});
    expect(calls[3].arguments, 'b.json');
    expect(calls[4].arguments, 'b.json');
  });

  test('answers come back as the store expects', () async {
    const files = ChannelJournalFiles();
    answer = (call) => switch (call.method) {
          'list' => ['a', 'b'],
          'read' => Uint8List.fromList([7]),
          'protection' => {'excluded': true, 'folderComplete': true, 'fileComplete': false},
          _ => null,
        };
    expect(await files.list(), ['a', 'b']);
    expect(await files.read('a'), [7]);
    expect(await files.protection('a'),
        (excluded: true, folderComplete: true, fileComplete: false));
  });

  test('a missing answer reads as nothing, never as protected', () async {
    const files = ChannelJournalFiles();
    expect(await files.list(), isEmpty);
    expect(await files.read('a'), isNull);
    expect(await files.protection('a'),
        (excluded: false, folderComplete: false, fileComplete: false));
  });

  test('a failure arrives as a code; a bad name never leaves', () async {
    const files = ChannelJournalFiles();
    answer = (_) => throw PlatformException(code: 'journal-io');
    await expectLater(files.open(),
        throwsA(isA<PlatformException>().having((e) => e.code, 'code', 'journal-io')));
    calls.clear();
    expect(() => files.read('../x'), throwsArgumentError);
    expect(calls, isEmpty);
  });

  test('the Swift side answers every method this side calls', () {
    final swift = File('ios/Runner/AppDelegate.swift').readAsStringSync();
    expect(swift, contains('"$journalChannel"'));
    for (final m in ['open', 'list', 'read', 'write', 'rename', 'delete', 'protection']) {
      expect(swift, contains('case "$m":'), reason: m);
    }
    for (final k in ['name', 'bytes', 'from', 'to', 'excluded', 'folderComplete', 'fileComplete']) {
      expect(swift, contains('"$k"'), reason: k);
    }
    expect(swift, contains('.completeFileProtection'));
    expect(swift, contains('isExcludedFromBackup = true'));
  });
}
~~~~

**File `app/test/journal/self_check_test.dart`**

~~~~dart
// The phone check (D49 c), on the Mac: it passes with every protection
// in place, fails at the step that broke, and never leaves its probe.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_files.dart';
import 'package:souldreams/journal/self_check.dart';

import 'io_journal_files.dart';

final class Says implements JournalProtection {
  const Says(this.answer);

  final Protection answer;

  @override
  Future<Protection> protection(String name) async => answer;
}

const all = Says((excluded: true, folderComplete: true, fileComplete: true));

final class NoRename extends IoJournalFiles {
  NoRename(super.dir);

  @override
  Future<void> rename(String from, String to) async => throw const FileSystemException('rename');
}

void main() {
  late Directory dir;
  final lines = <String>[];
  final sink = SafeLog.sink;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('check-');
    lines.clear();
    SafeLog.sink = lines.add;
  });

  tearDown(() {
    SafeLog.sink = sink;
    dir.deleteSync(recursive: true);
  });

  test('every protection in place: it passes and leaves nothing', () async {
    final files = IoJournalFiles(dir);
    expect(await journalSelfCheck(files, all), isTrue);
    expect(lines, ['journalCheckPassed']);
    expect(files.everything(), isEmpty);
  });

  test('each missing protection fails at step 3, probe removed', () async {
    for (final p in [
      (excluded: false, folderComplete: true, fileComplete: true),
      (excluded: true, folderComplete: false, fileComplete: true),
      (excluded: true, folderComplete: true, fileComplete: false),
    ]) {
      lines.clear();
      final files = IoJournalFiles(dir);
      expect(await journalSelfCheck(files, Says(p)), isFalse);
      expect(lines, ['journalCheckFailed 3']);
      expect(files.everything(), isEmpty);
    }
  });

  test('a save that cannot finish fails at step 2', () async {
    expect(await journalSelfCheck(NoRename(dir), all), isFalse);
    expect(lines, ['journalCheckFailed 2']);
  });

  test('the probe is one marker word, and other nights stay', () async {
    final files = IoJournalFiles(dir);
    await files.write('night-${'e' * 32}.json', Uint8List(3));
    expect(await journalSelfCheck(files, all), isTrue);
    expect(files.everything().keys, ['night-${'e' * 32}.json']);
    expect(journalProbe, matches(RegExp(r'^[a-z0-9-]+$')));
  });
}
~~~~

2. Red: both fail to load (`channel_journal_files.dart`, `self_check.dart` not found).

3. The channel, the check, the Swift and the Dev entry point:

**File `app/lib/journal/channel_journal_files.dart`**

~~~~dart
// The journal's folder on the phone (D49 b), through the Swift channel
// in ios/Runner/AppDelegate.swift. A failure there arrives as a
// PlatformException carrying a code only (R3).
import 'package:flutter/services.dart';

import 'journal_files.dart';

const journalChannel = 'souldreams/journal_files';

final class ChannelJournalFiles implements JournalFiles, JournalProtection {
  const ChannelJournalFiles([this._channel = const MethodChannel(journalChannel)]);

  final MethodChannel _channel;

  String _checked(String name) {
    if (!validName(name)) throw ArgumentError('name');
    return name;
  }

  @override
  Future<void> open() => _channel.invokeMethod<void>('open');

  @override
  Future<List<String>> list() async =>
      await _channel.invokeListMethod<String>('list') ?? const <String>[];

  @override
  Future<Uint8List?> read(String name) => _channel.invokeMethod<Uint8List>('read', _checked(name));

  @override
  Future<void> write(String name, Uint8List bytes) =>
      _channel.invokeMethod<void>('write', {'name': _checked(name), 'bytes': bytes});

  @override
  Future<void> rename(String from, String to) =>
      _channel.invokeMethod<void>('rename', {'from': _checked(from), 'to': _checked(to)});

  @override
  Future<void> delete(String name) => _channel.invokeMethod<void>('delete', _checked(name));

  @override
  Future<Protection> protection(String name) async {
    final m = await _channel.invokeMapMethod<String, bool>('protection', _checked(name)) ??
        const <String, bool>{};
    return (
      excluded: m['excluded'] ?? false,
      folderComplete: m['folderComplete'] ?? false,
      fileComplete: m['fileComplete'] ?? false,
    );
  }
}
~~~~

**File `app/lib/journal/self_check.dart`**

~~~~dart
// The phone check (D49 c; the plan's Task 11): SoulDreams Dev runs it
// once when built with --dart-define=JOURNAL_SELF_CHECK=true. It saves a
// probe night, reads back the folder's backup flag and both protection
// classes, reads the probe, deletes it, and checks no file names it. It
// logs journalCheckPassed, or journalCheckFailed with the step's number.
// The probe holds one marker word, never a dream; the owner looks for
// it in the downloaded container, and must not find it.
import '../core/safe_log.dart';
import '../words/lines.g.dart' show Lang;
import 'journal_files.dart';
import 'journal_store.dart';
import 'night.dart';

const journalProbe = 'journal-probe-d49';

Future<bool> journalSelfCheck(JournalFiles files, JournalProtection protection,
    {DateTime? now}) async {
  var step = 1;
  String? probeId;
  JournalStore? store;
  try {
    store = await JournalStore.open(files);
    step = 2;
    final local = (now ?? DateTime.now()).toLocal();
    final probe = Night(
      id: probeId = newNightId(),
      firstRecorded: local.toUtc(),
      date: (year: local.year, month: local.month, day: local.day),
      lang: Lang.en,
      dreams: const [journalProbe],
    );
    await store.save(probe);
    step = 3;
    final p = await protection.protection(JournalStore.fileOf(probe.id));
    if (!p.excluded || !p.folderComplete || !p.fileComplete) return _failed(step);
    step = 4;
    if (!(await store.nights()).contains(probe)) return _failed(step);
    step = 5;
    await store.delete(probe.id);
    probeId = null;
    if ((await files.list()).any((n) => n.contains(probe.id))) return _failed(step);
    SafeLog.event(LogEvent.journalCheckPassed);
    return true;
  } on Object {
    return _failed(step);
  } finally {
    if (store != null && probeId != null) {
      try {
        await store.delete(probeId);
      } on Object {
        // The failure is already logged; the owner's container check finds the probe.
      }
    }
  }
}

bool _failed(int step) {
  SafeLog.event(LogEvent.journalCheckFailed, [step]);
  return false;
}
~~~~

**File `app/ios/Runner/AppDelegate.swift`**

~~~~swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var journalChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "JournalFiles") {
      journalChannel = JournalFiles.channel(messenger: registrar.messenger())
    }
  }
}

// The journal's folder on the phone (D49 b; R11): Library/Application
// Support/Journal, excluded from backup, the folder and every file with
// complete file protection. Plain file operations; the store's rules are
// in Dart (lib/journal/). A failure answers with a code only, never a
// path or a message (R3).
enum JournalFiles {
  static let channelName = "souldreams/journal_files"
  private static func allowed(_ c: Unicode.Scalar) -> Bool {
    return ("a"..."z").contains(c) || ("A"..."Z").contains(c) || ("0"..."9").contains(c)
      || c == "." || c == "_" || c == "-"
  }

  enum Failure: Error { case name, arguments, rename }

  static func channel(messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      do {
        result(try handle(call))
      } catch {
        result(FlutterError(code: "journal-io", message: nil, details: nil))
      }
    }
    return channel
  }

  static func folder() throws -> URL {
    let base = try FileManager.default.url(
      for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return base.appendingPathComponent("Journal", isDirectory: true)
  }

  // The same rule as validName in lib/journal/journal_files.dart.
  static func file(_ name: Any?) throws -> URL {
    guard let n = name as? String, !n.isEmpty, n != ".", !n.hasPrefix(".."),
      n.unicodeScalars.allSatisfy(allowed)
    else { throw Failure.name }
    return try folder().appendingPathComponent(n, isDirectory: false)
  }

  static func arguments(_ call: FlutterMethodCall) throws -> [String: Any] {
    guard let a = call.arguments as? [String: Any] else { throw Failure.arguments }
    return a
  }

  static func handle(_ call: FlutterMethodCall) throws -> Any? {
    let fm = FileManager.default
    switch call.method {
    case "open":
      var dir = try folder()
      let complete: [FileAttributeKey: Any] = [.protectionKey: FileProtectionType.complete]
      try fm.createDirectory(at: dir, withIntermediateDirectories: true, attributes: complete)
      try fm.setAttributes(complete, ofItemAtPath: dir.path)
      var values = URLResourceValues()
      values.isExcludedFromBackup = true
      try dir.setResourceValues(values)
      return nil
    case "list":
      return try fm.contentsOfDirectory(atPath: folder().path).sorted()
    case "read":
      let url = try file(call.arguments)
      guard fm.fileExists(atPath: url.path) else { return nil }
      return FlutterStandardTypedData(bytes: try Data(contentsOf: url))
    case "write":
      let a = try arguments(call)
      guard let bytes = a["bytes"] as? FlutterStandardTypedData else { throw Failure.arguments }
      try bytes.data.write(to: try file(a["name"]), options: [.completeFileProtection])
      return nil
    case "rename":
      let a = try arguments(call)
      let from = try file(a["from"])
      let to = try file(a["to"])
      // POSIX rename: one step, replacing the target.
      guard Darwin.rename(from.path, to.path) == 0 else { throw Failure.rename }
      return nil
    case "delete":
      let url = try file(call.arguments)
      if fm.fileExists(atPath: url.path) { try fm.removeItem(at: url) }
      return nil
    case "protection":
      let dir = try folder()
      let excluded = try dir.resourceValues(forKeys: [.isExcludedFromBackupKey])
        .isExcludedFromBackup ?? false
      let folderClass = try fm.attributesOfItem(atPath: dir.path)[.protectionKey] as? FileProtectionType
      let fileClass = try fm.attributesOfItem(atPath: file(call.arguments).path)[.protectionKey]
        as? FileProtectionType
      return [
        "excluded": excluded,
        "folderComplete": folderClass == .complete,
        "fileComplete": fileClass == .complete,
      ]
    default:
      return FlutterMethodNotImplemented
    }
  }
}
~~~~

**Edit `app/lib/main_dev.dart`** (1 of 3)

~~~~dart
// nights only.
import 'package:flutter/widgets.dart';
~~~~

~~~~dart
// nights only.
import 'dart:async';

import 'package:flutter/widgets.dart';
~~~~

**Edit `app/lib/main_dev.dart`** (2 of 3)

~~~~dart
import 'core/safe_log.dart';

~~~~

~~~~dart
import 'core/safe_log.dart';
import 'journal/channel_journal_files.dart';
import 'journal/self_check.dart';

~~~~

**Edit `app/lib/main_dev.dart`** (3 of 3)

~~~~dart
  runApp(const SoulDreamsApp());
}
~~~~

~~~~dart
  runApp(const SoulDreamsApp());
  // The phone check (D49 c): only in a build made with
  // --dart-define=JOURNAL_SELF_CHECK=true.
  if (const bool.fromEnvironment('JOURNAL_SELF_CHECK')) {
    const files = ChannelJournalFiles();
    unawaited(journalSelfCheck(files, files));
  }
}
~~~~

4. Green: the gate, 47 app tests (`entry_points_test.dart` still passes: the flavour check stays the first statement).

5. The Swift type-checks against Flutter's iOS framework, from a copy in the temporary folder (the plugin header is
   ignored by git, so it comes from the working tree):

       cd app && FW=$PWD/.fvm/flutter_sdk/bin/cache/artifacts/engine/ios/Flutter.xcframework/ios-arm64_x86_64-simulator && T=$TMPDIR/swiftcheck && rm -rf $T && mkdir -p $T && cp ios/Runner/AppDelegate.swift ios/Runner/SceneDelegate.swift ios/Runner/Runner-Bridging-Header.h ios/Runner/GeneratedPluginRegistrant.h $T/ && cd $T && xcrun --sdk iphonesimulator swiftc -typecheck -target arm64-apple-ios15.0-simulator -module-cache-path $TMPDIR/mcache -F $FW -import-objc-header Runner-Bridging-Header.h -I . AppDelegate.swift SceneDelegate.swift; echo "swift exit $?"

   Expected: `swift exit 0` (the sandbox's `xcrun_db` cache warnings aside). If `GeneratedPluginRegistrant.h` is
   missing, stop: the owner's next `flutter` build makes it.

6. Commit the six files: "Journal: the Swift folder (backup-excluded, complete protection), its channel, and the
   phone check (D49 b, c)".

7. The app's mutation checks. The runner (written in Task 1, not committed; Part 4, Q4):

**File `.scratch/journal-core/app_mutations.py`**

~~~~python
# journal-core: the app's mutation checks (D49 c), run by hand from the
# repository root:  python3 -I -B .scratch/journal-core/app_mutations.py
# Each row breaks one thing in app/lib/, runs the named test, which must
# fail, and puts the file back byte for byte, whatever happens. Prints
# row codes only. Exit 0 when every row is caught.
import os
import subprocess
import sys

ROWS = [
    ('A1', 'lib/journal/journal_store.dart',
     '  Future<void> delete(String id) => _files.delete(fileOf(id));',
     '  Future<void> delete(String id) async => fileOf(id);',
     'test/journal/journal_store_test.dart', 'deleting a night leaves nothing of it anywhere'),
    ('A2', 'lib/journal/journal_store.dart',
     '    await _files.write(tempPrefix + name, encodeNight(night));\n'
     '    await _files.rename(tempPrefix + name, name);',
     '    await _files.write(name, encodeNight(night));',
     'test/journal/journal_store_test.dart', 'a save cut short leaves the last whole version'),
    ('A3', 'lib/journal/journal_store.dart',
     '      if (name.startsWith(tempPrefix)) {',
     '      if (name.startsWith(tempPrefix) && false) {',
     'test/journal/journal_store_test.dart', 'a save cut short leaves the last whole version'),
    ('A4', 'lib/journal/journal_store.dart',
     '    for (final name in await _files.list()) {\n      await _files.delete(name);',
     "    for (final name in await _files.list()) {\n      if (name.startsWith('night-')) await _files.delete(name);",
     'test/journal/journal_store_test.dart', 'deleting the journal empties the folder'),
    ('A5', 'lib/journal/journal_store.dart',
     '        SafeLog.event(LogEvent.journalFileSkipped);\n',
     '',
     'test/journal/journal_store_test.dart', 'an unreadable file is skipped with a code, never touched'),
    ('A6', 'lib/journal/journal_store.dart',
     'if (night == null || night.id != match[1]) {',
     'if (night == null) {',
     'test/journal/journal_store_test.dart', 'an unreadable file is skipped with a code, never touched'),
    ('A7', 'lib/journal/night.dart',
     ' || !setEquals(json.keys.toSet(), _keys)',
     '',
     'test/journal/night_test.dart', 'anything not a version-1 night decodes to null'),
    ('A8', 'lib/journal/self_check.dart',
     '    if (!p.excluded || !p.folderComplete || !p.fileComplete) return _failed(step);\n',
     '',
     'test/journal/self_check_test.dart', 'each missing protection fails at step 3, probe removed'),
]


def say(line):
    sys.stdout.write(line + '\n')
    sys.stdout.flush()


def run(test, name):
    r = subprocess.run(['fvm', 'flutter', 'test', '--no-pub', test, '--plain-name', name],
                       cwd='app', capture_output=True)
    return r.returncode


def main():
    bad = 0
    for code, path, old, new, test, name in ROWS:
        full = os.path.join('app', path)
        with open(full, 'rb') as f:
            original = f.read()
        text = original.decode('utf-8')
        if text.count(old) != 1:
            say('%s: SETUP FAILED (pattern not found once)' % code)
            bad += 1
            continue
        if run(test, name) != 0:
            say('%s: SETUP FAILED (the test fails unbroken)' % code)
            bad += 1
            continue
        try:
            with open(full, 'wb') as f:
                f.write(text.replace(old, new).encode('utf-8'))
            caught = run(test, name) != 0
        finally:
            with open(full, 'wb') as f:
                f.write(original)
        say('%s: %s' % (code, 'caught' if caught else 'SURVIVED'))
        bad += 0 if caught else 1
    say('app mutations: %d run, %s' % (len(ROWS), 'FAILED' if bad else 'all caught'))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
~~~~

   From the repository root: `python3 -I -B .scratch/journal-core/app_mutations.py`. Expected: `A1: caught` to
   `A8: caught`, then `app mutations: 8 run, all caught`; `git status --short` prints nothing afterwards (every file
   put back).

### Task 11 · [OWNER] The phone checks (D49 c; O10)

SoulDreams Dev only, invented nights only (R12). Nothing here touches the founder app.

1. **[OWNER]** The check, on the phone. Paste 1 — Terminal

       cd ~/Developer/soul-dreams-app/app && fvm flutter devices && fvm flutter run --flavor dev -t lib/main_dev.dart --dart-define=JOURNAL_SELF_CHECK=true -d <the phone's id from the list>

   It builds, installs SoulDreams Dev and starts it (a blank screen). Open the DevTools link `flutter run` prints,
   then its **Logging** view, and look at the lines named `souldreams`. Expected: `appStarted`, then
   `journalCheckPassed`. `journalCheckFailed 3` means a protection is missing (the backup flag or a protection
   class); any other `journalCheckFailed n`, a failure at that step. That the log shows in DevTools' Logging view is
   [ASSUMED]; if it does not, tell Claude Code, which may read it through the Dart and Flutter tools on SoulDreams
   Dev with your consent (R12). Quit with `q`.

2. **[OWNER]** Nothing left behind. In Xcode: Window → Devices and Simulators → the phone → Installed Apps →
   SoulDreams Dev → the "⋯" button → Download Container, saved into a new empty folder `~/Desktop/jc-container`.
   Then Paste 2 — Terminal

       cd ~/Desktop/jc-container && ls && find *.xcappdata/AppData/Library/Application\ Support/Journal -type f | wc -l && grep -rl journal-probe-d49 . | wc -l

   Expected: one `.xcappdata`; then `0` (the folder exists and holds no file: Dev has no nights yet, and the probe was
   deleted); then `0` (no trace of the probe anywhere in the container, caches included). Delete
   `~/Desktop/jc-container` afterwards.

3. **[OWNER]** Optional: Settings → your name → iCloud → Manage Account Storage → Backups → this iPhone. SoulDreams
   Dev's backup size is about zero [ASSUMED; Apple calls the exclusion guidance to the system, not a guarantee].

4. Report the three results to Claude Code. A failure stops the branch before Task 12.

### Task 12 · `check_all.sh` and the docs (D49 Status)

1. From the repository root: `tool/check_all.sh`. Expected: `Ran 221 tests`, `OK`; `mutations: 75 run, all caught`;
   `flutter: pinned 3.47.9, running 3.47.9`; `No issues found!`; `+47: All tests passed!`; `node: pinned 24, running
   24`; `ℹ tests 28`, `ℹ fail 0`; `check_all: all passed`. It takes about ten minutes.

2. **Edit** `docs/Status.md`, the seven blocks below. In the first, `YYYY-MM-DD` is the day of the run; in the last,
   D48's line is the owner's answer to Part 4, Q1, word for word (the task waits for it).

**Edit `docs/Status.md`** (1 of 7)

~~~~markdown
Last updated: 2026-11-11, at the end of branch `scaffold-4-server`, by Claude Code.
~~~~

~~~~markdown
Last updated: YYYY-MM-DD, at the end of branch `journal-core`, by Claude Code.
~~~~

**Edit `docs/Status.md`** (2 of 7)

~~~~markdown
`scaffold-4-server`: Scaffolding, branch 4 of 4. Plan: `docs/plans/scaffold-4-server.md`. Its Part 6 says where the
build differs from Parts 1 to 5 (the owner's rulings D44 to D46, below) and governs.
~~~~

~~~~markdown
`journal-core`: the journal's foundations, with no screen (D49). Plan: `docs/plans/journal-core.md`. The screens,
the night rules (the 21:00 boundary) and typing wait for Product's answers to P1 to P14, sent through the head, and
come in a later branch.
~~~~

**Edit `docs/Status.md`** (3 of 7)

~~~~markdown
## Road ahead

~~~~

~~~~markdown
## Road ahead

- The journal's screens, the night rules and typing, once Product answers P1 to P14 (D49; the plan's Part 1).
~~~~

**Edit `docs/Status.md`** (4 of 7)

~~~~markdown
- The app's analyzer baseline: `No issues found!`. The app has 14 tests.
~~~~

~~~~markdown
- The design values (D49 a): `tool/checks/designgen.py` reads the Design System's §1, §2, §3 and §5 into
  `app/lib/design/tokens.g.dart` (`TypeRoles`, `LightColours`, `DarkColours`, `Spacing`), and G1 proves it. One value
  is unset in the source (`space.journal.end`) and has no constant.
- The fonts (D49 a): Tangerine, Sorts Mill Goudy, Inter (Regular and SemiBold, the 18pt statics), Nunito (Regular,
  Italic) and Habibi, static TTFs with their OFL licences in `app/assets/fonts/`, each listed in `fingerprints.txt`
  (G2), declared in `pubspec.yaml`. The owner's download; never fetched at run time (R10).
- The journal's store (D49 b, c), with no screen yet: `app/lib/journal/`. One JSON file per night, format version 1,
  in `Library/Application Support/Journal`; the folder excluded from backup; the folder and every file with complete
  file protection, through the Swift channel in `AppDelegate.swift`. A save writes a temporary file and renames it; a
  file that does not read as a night is skipped (`journalFileSkipped`) and never touched; Delete journal empties the
  folder, the first-use flag included. The format may change freely until it first reaches the founder app (D49 O5).
- SoulDreams Dev runs the phone check when built with `--dart-define=JOURNAL_SELF_CHECK=true` (the plan's Task 11).
  Journal code reaches `main_dev.dart` only (D49 O1).
- The app's analyzer baseline: `No issues found!`. The app has 47 tests, and 8 mutation checks (A1 to A8), run by
  hand with `python3 -I -B .scratch/journal-core/app_mutations.py` (not committed; banked item 60).
~~~~

**Edit `docs/Status.md`** (5 of 7)

~~~~markdown
- Totals: 195 guard tests and 68 mutation checks.
~~~~

~~~~markdown
- G1 also proves the design values; G2 also proves every file in `app/assets/fonts/` against `fingerprints.txt`,
  armed or not; G0 knows `.txt` in `app/assets/fonts/` only (D49 a).
- Totals: 221 guard tests and 75 mutation checks.
~~~~

**Edit `docs/Status.md`** (6 of 7)

~~~~markdown
    fire by hand). A test that fails unbroken now stops the runner (`2fbaad6`).
~~~~

~~~~markdown
    fire by hand). A test that fails unbroken now stops the runner (`2fbaad6`).

Banked in journal-core:

59. The check lists will become English only (head, C156-I and C157-I), so the lists' per-language shape
    (`lists-shape`, D36 Q3) needs a ruling at the next lists filing (D49).
60. The app's mutation checks are a scratch runner, run by hand (the plan's Part 4, Q4); committed, with tests, in the
    screens branch.
61. The importer does not regenerate the tokens after an import of `design-system.md`; G1 refuses until
    `python3 -I -B tool/checks/designgen.py --write` (the plan's Part 4, Q11).
62. `designgen.py` knows the Design System's value forms and notes exactly; a new form or note stops it
    (`colour-form`, `spacing-form`) until a branch teaches it. The notes ("no border", "only ever on white") reach
    `tokens.g.dart` as comments only; code honours them by hand.
63. The fonts' fingerprints prove the files have not changed since the owner's download, not where they came from.
    The zip names and Inter's 18pt statics are `fonts.sh`'s assumptions.
64. The phone check logs through `SafeLog` only, so its result shows in DevTools' Logging view, not the terminal.
65. Apple calls the backup exclusion guidance to the system, not a guarantee (D49 O10). The app-switcher snapshot of
    a night on screen waits for Product's answer to P11.
~~~~

**Edit `docs/Status.md`** (7 of 7)

~~~~markdown

## Documents as last imported
~~~~

~~~~markdown

## Rulings during journal-core

- D47: the sandbox reaches no package registry, only `storage.googleapis.com`; `pub get` and `pub add` are the
  owner's (the owner's commit `1b3e93b`).
- D48: <the owner's words, the plan's Part 4, Q1>
- D49: the investigation's rulings. This branch builds only what needs no Product answer: the design values
  generator with G1, and the fonts (G0, G2); the store (one JSON file per night, the folder out of backups, complete
  file protection, a version field, a Swift channel, no package); the deletion tests, and the unreadable file
  skipped and never touched. The screens, the night rules and typing wait for P1 to P14, sent through the head. O1
  to O10 accepted; O10's two Apple facts read by the Build chat. The lists becoming English only banked (item 59).

## Documents as last imported
~~~~

3. The gate. Commit `docs/Status.md`: "Docs: journal-core in Status.md; D47 to D49 and the banked items".

---

## Part 4 · Open questions (numbered; a blank is not a yes)

1. **D48.** The ruling's text did not reach this session. *Lean:* it is the brief that opened the branch (the journal
   on the phone, nothing leaves it, invented nights only, installs the owner's, the head's four rulings relayed), and
   Part 1 cites it so. *If otherwise:* Part 1's row and Task 12's line change; no code does.
2. **The fixture's text is not in the plan.** R2 keeps every invented night in one file, so the plan names
   `.scratch/journal-core/invented-nights.json` (kept by the proof, sha256 given) and Task 7 copies it. *Lean:* yes.
   *If not:* the fixture is committed now with the plan, and Task 7 only checks its hash.
3. **"Never touched" and Delete journal.** An unreadable night file is never read into the list, rewritten or
   deleted by a night's delete; Delete journal removes it with everything else (R11: deleted completely). *Lean:*
   yes. *If not:* Delete journal leaves such a file, and W27·12's "removes the journal" is no longer wholly true.
4. **The app's mutation runner stays a scratch script** (as the server's did before D43). *Lean:* yes for this branch;
   committed as `tool/app_mutations.py`, with its own tests and `guardlib.report` (G5), in the screens branch. *If
   committed now:* a Task 10a, and two runner tests.
5. **`CLAUDE.md`'s G0, G1 and G2 lines** do not mention this branch's additions, and `CLAUDE.md` is the owner's.
   *Lean:* after the merge the owner adds: G0 "…, and `.txt` in `app/assets/fonts/` only"; G1 "…, and
   `app/lib/design/tokens.g.dart` is exactly what `designgen.py` makes from `design-system.md`"; G2 "…, and every
   file in `app/assets/fonts/` matches `fingerprints.txt`". *If not:* the guards still run; the summary lags.
6. **Inter's optical size.** The Design System sets Inter at 12 to 24px; Google's download holds 18pt, 24pt and 28pt
   statics. *Lean:* 18pt, the text cut. *If another:* `fonts.sh`'s two Inter lines change.
7. **Every face now**, including Tangerine, Habibi and Nunito's italic, which no screen uses yet. *Lean:* yes, so every
   type role's family exists and D49's "the fonts" is done once. *If only the journal's:* the fonts test would need
   the tokens' other families exempted.
8. **G2 checks the fonts even before an import** (with the awaiting-import marker): fonts are not imported copies.
   *Lean:* yes.
9. **The phone check's probe** is a night with one marker word, `journal-probe-d49`, never a dream, saved and deleted
   in SoulDreams Dev only. *Lean:* yes.
10. **D46** is already recorded under branch 4 in Status.md; Task 12 adds D47 to D49 and does not repeat it. *Lean:*
    yes. *If wanted twice:* one line more.
11. **After an import of `design-system.md`**, the importer does not regenerate the tokens; G1 refuses until
    `python3 -I -B tool/checks/designgen.py --write` (banked item 61). *Lean:* bank it; the importer's change asks
    (it is under "ask") and waits for a later branch.

---

## Part 5 · How this plan was proven

On 2026-11-11, before this file was committed:

1. **Built in a scratch worktree**, `./.scratch/build-jc`, detached at `1b3e93b`, with the app's Flutter link and
   package configuration copied in. Every block in Part 3 is generated from the files built and committed there,
   and compared back. Its commits, in task order: `e868b26`; `c317230`; `5945fbc`; `0578402`; `8503f70`; `ab1f763`; `9eb8750`; `a04c33d`.
2. **Each task, red then green, through the pre-commit hook** (`guards (staged): all passed` each time), with the
   counts Part 3 states: generator tests red `errors=1`, then 12; G1 red `failures=5`; fonts' guards red
   `failures=7`; fonts test red `-3`; fixtures red `-3`; the app 17, 20, 23, 29, 38, 47. Guard mutations: `3 run`,
   `6 run`, `10 run`, each `all caught`; the whole runner `75 run, all caught`. App mutations: `8 run, all caught`,
   and `git status` clean after.
3. **The owner's download (Task 5) was simulated** with five fake zips holding the expected names (Inter's and
   Nunito's under `static/`), each "font" a few bytes with a NUL. `fonts.sh` stopped with `fonts: missing download
   Habibi.zip`, `STOPPED (nothing copied)`, when one was missing; wrote 13 files when all were there; and refused a
   second run (`already exists`). The real files are the owner's; only their names and the script's logic were
   proven.
4. **The Swift type-checked** (`swiftc -typecheck`, iOS 15 simulator SDK, Flutter's framework): exit 0. It was not
   built or run: the phone is the owner's (Task 11).
5. **`tool/check_all.sh` on the worktree** ended `check_all: all passed`: `Ran 221 tests`, `OK`; `mutations: 75 run,
   all caught`; `flutter: pinned 3.47.9, running 3.47.9`; `No issues found!`; `+47: All tests passed!`; `node:
   pinned 24, running 24`; the server's 28. Its offline `pub get` passed with the fonts block in `pubspec.yaml`.
6. **The plan replayed on a clean worktree**, `./.scratch/replay-jc`, detached at `1b3e93b`: every File and Edit
   block applied in task order (each Edit's old text found exactly once), Task 5 from the fake zips, Task 12's
   blocks with a stand-in D48 line, each task committed through the hook, and the final tree compared with the build
   worktree's: no difference at Task 10 (`git diff --stat` printed nothing), and Task 12's seven Status.md blocks applied, each found once. On the replayed tree: `guards (tracked): all passed`; `Ran 221 tests`, `OK`; `No issues found!`; `+47: All tests passed!`.
7. **Found by the proof and fixed in the plan:** G4 counts test names and Python strings, so long ones were
   shortened or built from parts; G7's high-entropy rule refused a Swift alphabet literal, now three ranges; two old
   mutation rows' patterns followed the code they break (row 23's pattern stays unique, row 58's follows G1);
   `mktemp -d` needs a template under the sandbox; `fonts.sh` copies nothing unless every file is found.
8. **Not provable in the sandbox, and so the owner's:** the real fonts (Task 5), the iOS build and the phone (Task
   11), whether the log shows in DevTools, and iCloud's backup size.
9. The scratch worktrees are removed after the proof (`git worktree remove --force`); their commits were on
   detached HEADs and reach no branch.

*No matter where you are on your journey, the steps you take are equally important.*
