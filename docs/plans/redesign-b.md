# Plan: search (redesign-b)

Branch `redesign-b`, from `main` at `e81f29c`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D95. Written by Claude Code (Opus) on 2026-11-21. The investigation stopped once (D116 item 4: the
register had no place for the count lines); D117 answered it. The owner's checks are by eye only.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

The journal gets a search field at the top, as in the founder's screenshot. Once the dreamer has typed three
characters, the journal shows only the nights whose dreams contain what they typed. Above those rows it shows a count
("1 match", "{n} matches") or, when nothing is found, "No matches". Under each row is one line of context: a few words
before the match, the match in bold, and what follows. Tapping a result opens the night with the match in bold in its
dream. Back under three characters, the journal is as before.

Matching ignores capital letters, keeps å, ä, ö and other letters with marks distinct, and finds the typed characters
only at the start of a word. "hus" finds "huset" but never the "hus" inside a longer word. It searches the told dreams
of every night, not names, readings or Life Context. Each night counts as one match, at its first place. The
matcher is one function, which recurring images will reuse later.

The three lines are the founder's words (D110), shown as pending lines until Product files them. A pending line could
not take a slot such as `{n}`, so the first task (the owner's, D60) teaches the words generator to accept the
register's slots in a pending line, under the register's own rules.

### What this branch builds

1. **The generator** (`tool/checks/wordsgen.py`; the owner applies it, D60): a pending line may hold the register's
   slots, the same ones in both languages; an unknown slot or slots that differ stop the generator
   (`unknown-slot`, `slots-differ`, as for the register). A line with a slot is a private constant plus a function
   of its handle's name (`PendingLines.MP_67(n: 3)`), as for a filed line. `PendingLine` gains the same `_fill`.
2. **The owner's pending lines** (D117): MP·66, MP·67, MP·68 in `pending-lines.csv`, fingerprinted, generated.
3. **The matcher** (`app/lib/journal/search.dart`, plain Dart):
   - `searchable(typed)`: the query trimmed, or null under three characters (code points, so one character
     outside the basic plane counts once).
   - `firstMatch(text, query)`: each character folded by itself with Dart's Unicode-aware `toLowerCase`, so a letter
     with a mark stays its own; the first place where the folded query occurs and the character before it is no
     letter, digit or mark; the span in the text's own code units.
   - `findIn(night, query)`: the told dreams in order (a waiting recording has no text), the first match, with its
     entry. `search(nights, query)`: the nights with a match, in the order given.
   - `contextOf(text, span)`: up to three words before the match (`cut`, an ellipsis, before them when words were
     left off), the match, the rest; each run of spaces or breaks one space.
4. **The journal** (`journal_page.dart`):
   - **The field:** first in the list, 20 down, 50 tall (`size.field.search`), as wide as a row (48 from each
     side), a pill in `color.field` with `color.field.border` (none in the dark theme). It has a magnifier drawn in
     code, which a screen reader does not hear, and EM·4 as its placeholder in `color.text.placeholder`. The typed
     words are in the button type, with no autocorrect and no suggestions; the keyboard's key is Search. There is no
     clear button. The space below it keeps the sky mark 140 down, where it was.
   - **From three characters:** where the list starts, the count (MP·66 for one night, MP·67 for more, MP·68 for none)
     in the button type, centred. Then only the matching nights' rows, newest first, under their month dividers,
     each with its context line under it, 6 below the row. The line is as wide as the row, centred, one line cut
     with an ellipsis, in the button type and `color.text.summary`, with the match in Inter SemiBold. MP·68 replaces
     C4-P·5 while searching. Under three characters, the journal is as before.
   - **The query:** held only while the page lives, never kept or logged (R3), so there are no recent searches.
5. **The opened night** (`night_page.dart`, `parts.dart`): `NightPage` takes the query a result was opened from.
   Its first match shows in SemiBold in its dream's bubble, found again on each read, so an edit that removes the
   word removes the bold. When the page goes, the bold goes. A row opened with no search hands no query.

### What it does not build

- The settings gear (D116 item 5), Settings, the consent's controls, Life Context and "Made by AI".
- A list of each word's forms (C140-I item 6's plain forms): D117 Q4 chose the start-of-word rule for now.
- Normalising text (NFC), which would need a package (banked item 146).
- Any change to the store, the typing screen, recording, onboarding, the export, the guards other than the
  generator, Swift or the server.

### The decisions, by number

- D110 (founder, 2026-11-20; head's message 24): search from three characters, each match with context under its
  row, the count lines and "No matches". Head's message 10: capital letters ignored. Head's message 8: recurring
  images later use search's matcher.
- D116 (owner, the brainstorm), items 1 to 5. D117 (owner, on the stop): Q1 to Q8, each built as leaned in the stop's
  report (`.scratch/for-build-chat/redesign-b-stop.md`).
- D60: the generator's task and the words are the owner's to apply. D91, D95, D67 (a row whose code moved follows it).

### Decided under D91 (how to build only)

1. **The magnifier and the field's pill are drawn** (no icon font needed, as the chevrons). The field is a
   `TextField` with a collapsed decoration inside our own pill, so its height is 50 at the usual size and grows at
   large text.
2. **Dart folds one character to one.** The fold map is kept per code unit, so a folding that changed a length
   would still map back to whole characters (banked item 147).
3. **The context line's colour is `color.text.summary`** (the dark theme's text), unused since redesign-a.
4. **The search tests run on a phone-sized view (390 by 844)** where a row must be absent, since the default view
   builds only what is near the screen (a row left out of the build would pass for absent; found by A457).
5. **`dev_only_test.dart`** now also checks that SoulDreams Dev reaches `search.dart` and `pending.g.dart`. The other
   two entry points are already checked never to reach `pending.g.dart`.

### The places this branch uses

Filed: EM·4 (the field's placeholder), C4-P·5 (as before), and the rows' and pages' places as before. W25 is not used
(D117 Q2).

**Pending, the owner's (D117; D110's words; shown in SoulDreams Dev only, their handles elsewhere, R1):**

| Handle | Place |
|---|---|
| MP·66 | the count when one night matches |
| MP·67 | the count when more nights match (`{n}`) |
| MP·68 | the search's empty result |

### The tests (test-first, on the Mac)

Every task adds its tests before its code. Tasks 3 to 5's new tests were run on the code before them and failed to
load. Task 1's tests were run on the old generator and failed (one failure, one error). Each assertion is shown to
bite by its row (Part 5). App tests: 577 at the start, 601 at the end. App mutation rows: 29 new (A442 to A470), 3
follow the code (D67: A322, A377, A379), 460 to 489. Guard tests: 249 to 250. Guard mutation rows: 4 new, 92 to 96.
The by-eye review on the phone is the owner's (Task 7).

## Part 2 · Settings and packages

No new package, no change to settings, Swift, the server, AWS or Soniox, and no storage change. One guard-tool
change, `wordsgen.py`, with its tests and mutation rows, which the owner applies (Task 1, D60). The pending lines and
their generated file are the owner's (Task 2).

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, generated from the build that proved it (Part 5). For Claude
Code's tasks (3 to 6), apply it from the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit
through the hook with the message given.

Every Claude Code task ends green:
- `cd app && fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub` passes at the
  count given;
- the task's rows (D95): `python3 -I -B tool/app_mutations.py --rows <the task's rows>`, every one caught;
- the hook: `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `redesign-b`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected: nothing from `git status`; the plan's commit; `guards (tracked): all passed`; `No issues found!`;
`+577: All tests passed!`. Anything else: stop (R14).

### Task 1 · [OWNER applies, D60] A pending line takes the register's slots (D117 Q1)

`wordsgen.py`: `slots_of` takes the source it reports. `read_pending` replaces `pending-slot` with the register's
rules (`unknown-slot`, `slots-differ`) and keeps each line's slots. `pending_dart` writes a line with a slot as a
private constant and a function, through `slot_function`, which `lines_dart` now shares. `PendingLine` gains
`_fill`. `pending.g.dart` is regenerated from the empty pending file (its sha256 unchanged in its header). Tests:
`test_wordsgen.py`, one new test (`test_a_pending_line_takes_the_registers_slots`) and the row rules' test
widened. Guard mutation rows: four new (93 to 96).

**Steps.**

1. Claude Code writes the block below, exactly, to `.scratch/redesign-b/task-1.diff` (ignored by git) and stops.
2. The owner, Paste 1 — Terminal:

   ```
   cd ~/Developer/soul-dreams-app && git apply --check .scratch/redesign-b/task-1.diff && git apply --whitespace=nowarn .scratch/redesign-b/task-1.diff && python3 -I -B tool/checks/wordsgen.py --check | tail -1 && git add -A && python3 -I -B tool/checks/tests/run_tests.py 2>&1 | tail -3 && python3 -I -B tool/checks/tests/mutations.py wordsgen.py | tail -1 && git status --short
   ```

   Expected:
   - `wordsgen: up to date`;
   - `Ran 250 tests`, `OK`;
   - `mutations: 21 run, all caught`;
   - `M ` for `app/lib/words/pending.g.dart`, `tool/checks/tests/mutations.py`, `tool/checks/tests/test_wordsgen.py`
     and `tool/checks/wordsgen.py`, and nothing else.

   Anything else: stop and bring it to the Build chat. Then commit:

   ```
   cd ~/Developer/soul-dreams-app && git commit -m "Words: a pending line takes the register's slots, as a filed line does (D117 Q1)"
   ```

   Expected: `guards (staged): all passed`, then the commit.
3. Claude Code then checks the app is unchanged: `No issues found!`, `+577: All tests passed!`.

**The block:**

~~~~diff
diff --git a/app/lib/words/pending.g.dart b/app/lib/words/pending.g.dart
index adc9d25fde323b3811e7e507a90b44e21bc67c2b..13d8ec39b9dda789487519dc706d0f99c64a4e72 100644
--- a/app/lib/words/pending.g.dart
+++ b/app/lib/words/pending.g.dart
@@ -1,6 +1,7 @@
 // GENERATED by tool/checks/wordsgen.py from the pending lines
 // (sha256 5e35d8a4539c157589e7ed9dd9417a414daab23a2b11d15c938c8317fd956517). Do not edit: the owner changes pending-lines.csv.
 // ignore_for_file: constant_identifier_names
+// ignore_for_file: non_constant_identifier_names, unused_element
 import 'package:flutter/services.dart' show appFlavor;
 
 import 'lines.g.dart' show Lang;
@@ -29,6 +30,14 @@ final class PendingLine {
     assert(all.length == 1, 'text() needs a line of one part');
     return all.single;
   }
+
+  PendingLine _fill(Map<String, String> slots) =>
+      PendingLine(handle, _fillAll(_en, slots), _fillAll(_sv, slots));
+
+  static List<String> _fillAll(List<String> parts, Map<String, String> slots) =>
+      parts.map((p) => p.replaceAllMapped(_slot, (m) => slots[m[0]] ?? m[0]!)).toList();
+
+  static final _slot = RegExp(r'\{[a-z ]+\}');
 }
 
 /// Every pending line, by handle.
diff --git a/tool/checks/tests/mutations.py b/tool/checks/tests/mutations.py
index 2b4de02b140a8bd6c3aeed7911b421c5376c33c5..5ec48d7796b15f47febbb0199414ed37b701a13c 100644
--- a/tool/checks/tests/mutations.py
+++ b/tool/checks/tests/mutations.py
@@ -212,6 +212,17 @@ MUTATIONS = [
      ['test_wordsgen.Pending.test_a_filed_handle_stops']),
     ('wordsgen.py', "        if f['status'] != PENDING_STATUS:", "        if False:",
      ['test_wordsgen.Pending.test_each_row_rule_stops']),
+    # redesign-b, Task 1 (D117 Q1): a pending line takes the register's slots.
+    ('wordsgen.py', "        if en_slots != sv_slots:\n            raise WordsError(PENDING, 'slots-differ', n)\n", "",
+     ['test_wordsgen.Pending.test_each_row_rule_stops']),
+    ('wordsgen.py', "            raise WordsError(source, 'unknown-slot', row)",
+     "            raise WordsError(REGISTER, 'unknown-slot', row)",
+     ['test_wordsgen.Pending.test_each_row_rule_stops']),
+    ('wordsgen.py', "            out.append(slot_function('PendingLine', name, const, slots))\n", "",
+     ['test_wordsgen.Pending.test_a_pending_line_takes_the_registers_slots']),
+    ('wordsgen.py', "        const = name if not slots else '_' + name\n        names.append(const)",
+     "        const = name\n        names.append(const)",
+     ['test_wordsgen.Pending.test_a_pending_line_takes_the_registers_slots']),
     # journal-screens, Task 3 (D58): the screenshots.
     ('g2_copies.py', "    refused += fingerprint_findings(src, SCREENS, SCREEN_PRINTS, 'screen')\n", "",
      ['test_g1_g2.G2.test_screens_unlisted_changed_or_unprinted_refuse']),
diff --git a/tool/checks/tests/test_wordsgen.py b/tool/checks/tests/test_wordsgen.py
index e0e0d5c95ae9d8ffec5aa1a9b12e6a5ea691d6db..fae0fbd32435b8a74c93cfaab1adec97b89a5406 100644
--- a/tool/checks/tests/test_wordsgen.py
+++ b/tool/checks/tests/test_wordsgen.py
@@ -110,6 +110,16 @@ class Pending(unittest.TestCase):
         self.assertIn('(sha256 %s)' % wordsgen.sha256(body), dart)
         self.assertNotIn('Line(', dart.replace('PendingLine(', ''))
 
+    def test_a_pending_line_takes_the_registers_slots(self):
+        # D117 Q1: as a filed line does, a private constant and a function.
+        body = pending(pending_row('MP' + DOT + '67', '{n} pa', 'pb {n}'), pending_row('MP' + DOT + '68'))
+        dart = pending_dart(body)
+        self.assertIn("  static const _MP_67 = PendingLine('MP" + DOT + "67', ['{n} pa'], ['pb {n}']);", dart)
+        self.assertIn("  static PendingLine MP_67({required int n}) => _MP_67._fill({'{n}': '$n'});", dart)
+        self.assertIn("  static const MP_68 = PendingLine('MP" + DOT + "68', ['pa'], ['pb']);", dart)
+        self.assertIn('  static const all = <PendingLine>[_MP_67, MP_68];', dart)
+        self.assertIn('      PendingLine(handle, _fillAll(_en, slots), _fillAll(_sv, slots));', dart)
+
     def test_a_filed_handle_stops(self):
         filed = row('MP' + DOT + '60', 'written', 'w', 'v')
         e = self.refused('pending-filed', pending(pending_row('MP' + DOT + '60')), filed)
@@ -128,7 +138,9 @@ class Pending(unittest.TestCase):
         self.refused('pending-given', pending(pending_row(h, given=' ')))
         self.refused('missing-language', pending(pending_row(h, sv='')))
         self.refused('parts-differ', pending(pending_row(h, 'pa / pc', 'pb')))
-        self.refused('pending-slot', pending(pending_row(h, '{n} pa', '{n} pb')))
+        self.refused('slots-differ', pending(pending_row(h, '{n} pa', 'pb')))
+        self.refused('unknown-slot', pending(pending_row(h, '{name} pa', '{name} pb')))
+        self.refused('unknown-slot', pending(pending_row(h, 'pa }', 'pb')))
         self.refused('control-character', pending(pending_row(h, 'p\ta')))
         self.refused('bad-csv', b'handle,"place\n')
 
diff --git a/tool/checks/wordsgen.py b/tool/checks/wordsgen.py
index f85983fcbf7333be286ef304511451237725e02c..fb5214f551e26a55ac690832b86346a1bedfa86c 100644
--- a/tool/checks/wordsgen.py
+++ b/tool/checks/wordsgen.py
@@ -164,7 +164,7 @@ def parse_text(text, row, source=REGISTER):
     return parts
 
 
-def slots_of(parts, row):
+def slots_of(parts, row, source=REGISTER):
     found = set()
     for part in parts:
         rest = part
@@ -173,7 +173,7 @@ def slots_of(parts, row):
                 found.add(token)
                 rest = rest.replace(token, '')
         if '{' in rest or '}' in rest:
-            raise WordsError(REGISTER, 'unknown-slot', row)
+            raise WordsError(source, 'unknown-slot', row)
     return found
 
 
@@ -212,7 +212,8 @@ def read_pending(data, register_rows):
     # None (no file) is no pending line. Each row: a handle of the
     # register's shape that the register does not hold, the status
     # "pending", where it was given, and one plain line in each language,
-    # with the same number of parts and no slot.
+    # with the same number of parts and the same slots, the register's own
+    # (D117 Q1: the search's count, MP·67).
     if data is None:
         return []
     text = decode(data, PENDING)
@@ -249,11 +250,12 @@ def read_pending(data, register_rows):
         en, sv = parse_text(f['english'], n, PENDING), parse_text(f['swedish'], n, PENDING)
         if len(en) != len(sv):
             raise WordsError(PENDING, 'parts-differ', n)
-        if any('{' in p or '}' in p for p in en + sv):
-            raise WordsError(PENDING, 'pending-slot', n)
+        en_slots, sv_slots = slots_of(en, n, PENDING), slots_of(sv, n, PENDING)
+        if en_slots != sv_slots:
+            raise WordsError(PENDING, 'slots-differ', n)
         seen.add(handle)
         names.add(ident(handle))
-        out.append((handle, en, sv))
+        out.append((handle, en, sv, tuple(s for s in SLOTS if s[0] in en_slots)))
     return out
 
 
@@ -261,6 +263,7 @@ PENDING_HEAD = ''.join(line + '\n' for line in (
     '// GENERATED by tool/checks/wordsgen.py from the pending lines',
     '// (sha256 @SHA@). Do not edit: the owner changes pending-lines.csv.',
     '// ignore_for_file: constant_identifier_names',
+    '// ignore_for_file: non_constant_identifier_names, unused_element',
     "import 'package:flutter/services.dart' show appFlavor;",
     '',
     "import 'lines.g.dart' show Lang;",
@@ -289,6 +292,14 @@ PENDING_HEAD = ''.join(line + '\n' for line in (
     "    assert(all.length == 1, 'text() needs a line of one part');",
     '    return all.single;',
     '  }',
+    '',
+    '  PendingLine _fill(Map<String, String> slots) =>',
+    '      PendingLine(handle, _fillAll(_en, slots), _fillAll(_sv, slots));',
+    '',
+    '  static List<String> _fillAll(List<String> parts, Map<String, String> slots) =>',
+    '      parts.map((p) => p.replaceAllMapped(_slot, (m) => slots[m[0]] ?? m[0]!)).toList();',
+    '',
+    "  static final _slot = RegExp(r'\\{[a-z ]+\\}');",
     '}',
     '',
     '/// Every pending line, by handle.',
@@ -298,12 +309,17 @@ PENDING_HEAD = ''.join(line + '\n' for line in (
 
 def pending_dart(pending, digest):
     out = [PENDING_HEAD.replace('@SHA@', digest)]
-    for handle, en, sv in pending:
+    names = []
+    for handle, en, sv, slots in pending:
+        name = ident(handle)
+        const = name if not slots else '_' + name
+        names.append(const)
         out.append('  static const %s = PendingLine(%s, %s, %s);\n'
-                   % (ident(handle), dart_string(handle), dart_list(en), dart_list(sv)))
+                   % (const, dart_string(handle), dart_list(en), dart_list(sv)))
+        if slots:
+            out.append(slot_function('PendingLine', name, const, slots))
     out.append('\n  /// Every pending line above, in the file\'s order.\n')
-    out.append('  static const all = <PendingLine>[%s];\n}\n'
-               % ', '.join(ident(h) for h, _, _ in pending))
+    out.append('  static const all = <PendingLine>[%s];\n}\n' % ', '.join(names))
     return ''.join(out)
 
 
@@ -440,6 +456,15 @@ LINES_HEAD = ''.join(line + '\n' for line in (
 ))
 
 
+def slot_function(kind, name, const, slots):
+    # A line with slots: its constant is private, and a function of the
+    # handle's name fills the slots (D32 Q13: plain replacement).
+    args = ', '.join('required %s %s' % (t, a) for _, a, t in slots)
+    fills = ', '.join('%s: %s' % (dart_string(k), "'$%s'" % a if t == 'int' else a)
+                      for k, a, t in slots)
+    return '  static %s %s({%s}) => %s._fill({%s});\n' % (kind, name, args, const, fills)
+
+
 def lines_dart(places, digest):
     out = [LINES_HEAD.replace('@SHA@', digest)]
     names = []
@@ -451,10 +476,7 @@ def lines_dart(places, digest):
         out.append('  static const %s = Line(%s, %s, %s%s);\n'
                    % (const, dart_string(p.handle), dart_list(p.en), dart_list(p.sv), stand_in))
         if p.slots:
-            args = ', '.join('required %s %s' % (t, a) for _, a, t in p.slots)
-            fills = ', '.join('%s: %s' % (dart_string(k), "'$%s'" % a if t == 'int' else a)
-                              for k, a, t in p.slots)
-            out.append('  static Line %s({%s}) => %s._fill({%s});\n' % (name, args, const, fills))
+            out.append(slot_function('Line', name, const, p.slots))
     out.append('\n  /// Every place above, in the register\'s order.\n')
     out.append('  static const all = <Line>[%s];\n}\n' % ', '.join(names))
     return ''.join(out)
~~~~

### Task 2 · [OWNER] Search's three pending lines (D117)

The owner's file, MP·66, MP·67 and MP·68 (sha256 `4da66877…38ab1`), into `app/assets/words/pending-lines.csv`,
fingerprinted and generated. Paste 2 — Terminal, with the file in place:

```
cd ~/Developer/soul-dreams-app && shasum -a 256 app/assets/words/pending-lines.csv && (cd app/assets/words && shasum -a 256 pending-lines.csv > pending-fingerprint.txt) && python3 -I -B tool/checks/wordsgen.py --write | grep pending && grep -E 'static (const|PendingLine) _?MP_6' app/lib/words/pending.g.dart && git status --short
```

Expected:
- the file's sha256, beginning `4da66877` and ending `38ab1`;
- `wordsgen: pending lines 3`;
- four lines, in the file's order:
  - `static const MP_66 = PendingLine('MP·66', ['1 match'], ['1 träff']);`
  - `static const _MP_67 = PendingLine('MP·67', ['{n} matches'], ['{n} träffar']);`
  - `static PendingLine MP_67({required int n}) => _MP_67._fill({'{n}': '$n'});`
  - `static const MP_68 = PendingLine('MP·68', ['No matches'], ['Inga träffar']);`
- `M ` for `app/assets/words/pending-fingerprint.txt`, `app/assets/words/pending-lines.csv` and
  `app/lib/words/pending.g.dart`, and nothing else.

Anything else: stop. Then commit:

```
cd ~/Developer/soul-dreams-app && git add app/assets/words app/lib/words && git commit -m "Words: search's count lines and empty result, pending (MP·66 to MP·68; D110, D117)"
```

Expected: `guards (staged): all passed`. Claude Code then checks the app: `No issues found!`, `+577: All tests
passed!` (no code uses the lines yet).

### Task 3 · The matcher (plain Dart)

`lib/journal/search.dart`: `searchable`, `firstMatch`, `findIn`, `search`, `contextOf`, `cut`, `searchFrom`,
`contextWordsBefore`. Tests: `test/journal/search_test.dart` (9), and in `test/words/lines_test.dart` a pending line
with a slot, filled in Dev and its handle elsewhere (1). Rows A442 to A452.

Expected: 587 app tests; rows `A442,A443,A444,A445,A446,A447,A448,A449,A450,A451,A452`, every one caught. Commit:

> Journal: search's matcher, one function, and its context line (D116, D117 Q4, Q5, Q8)

**The block:**

~~~~diff
diff --git a/app/lib/journal/search.dart b/app/lib/journal/search.dart
new file mode 100644
index 0000000000000000000000000000000000000000..f28cad9b5b84688ee08b7296f81624ffaba278d1
--- /dev/null
+++ b/app/lib/journal/search.dart
@@ -0,0 +1,127 @@
+// Search, in plain Dart (main-path.md, Search; D110, head's message 24;
+// D116 items 1 to 3; D117 Q4, Q5, Q8). One matcher, [firstMatch], for
+// search now and for recurring images later (head's message 8), so its
+// rule can narrow in one place.
+// - From three characters (D110), the spaces around the query left out.
+// - A capital letter is not a different word (C151-I): each character is
+//   folded by itself, Unicode-aware, and a letter with a mark stays its
+//   own (D116 item 2). The span maps back to the text's own characters,
+//   whatever length a character folds to.
+// - The typed characters at the start of a word (D117 Q4): so the same
+//   word with another ending is found, and a word's middle never is.
+// - The dreams' text only, told dreams in order, never a name (D116 item 1);
+//   the first place in a night, never the best (C131-I item 3). A night is
+//   one match (D117 Q5).
+// - The context line (D116 item 3; D117 Q8): up to three words before
+//   the match, the match, then the rest, on one line. Stand-ins, TO TRY.
+// Nothing here is kept or logged: a query is the dreamer's words (R3).
+import 'night.dart';
+
+/// A stretch of a text: [start, end) in its UTF-16 code units.
+typedef Span = ({int start, int end});
+
+/// A night's first match: the night, its entry (in [Night.entries]),
+/// and the span in that dream.
+typedef Found = ({Night night, int entry, Span span});
+
+/// The context line's three parts.
+typedef Context = ({String before, String match, String after});
+
+/// A search starts from this many characters (D110).
+const int searchFrom = 3;
+
+/// The words kept before a match in its context line (D117 Q8, a stand-in).
+const int contextWordsBefore = 3;
+
+/// Marks words left off before a match (D117 Q8: punctuation, not a word).
+const String cut = '…';
+
+final _wordChar = RegExp(r'[\p{L}\p{N}\p{M}]', unicode: true);
+final _space = RegExp(r'\s+');
+final _word = RegExp(r'\S+');
+
+/// The query as searched, or null under three characters.
+String? searchable(String typed) {
+  final q = typed.trim();
+  return q.runes.length >= searchFrom ? q : null;
+}
+
+/// A text folded one character at a time, each folded code unit knowing
+/// the original character it came from.
+final class _Folded {
+  _Folded(String text) {
+    final out = StringBuffer();
+    var at = 0;
+    for (final r in text.runes) {
+      final width = r > 0xFFFF ? 2 : 1;
+      final f = String.fromCharCode(r).toLowerCase();
+      for (var k = 0; k < f.length; k++) {
+        from.add(at);
+        to.add(at + width);
+      }
+      out.write(f);
+      at += width;
+    }
+    folded = out.toString();
+  }
+
+  late final String folded;
+  final from = <int>[];
+  final to = <int>[];
+}
+
+String _fold(String s) => _Folded(s).folded;
+
+bool _wordStart(String text, int i) {
+  if (i == 0) return true;
+  var j = i - 1;
+  final unit = text.codeUnitAt(j);
+  if (j > 0 && unit >= 0xDC00 && unit <= 0xDFFF) j--;
+  return !_wordChar.hasMatch(text.substring(j, i));
+}
+
+/// The first place [query] (already [searchable]) starts a word in [text].
+Span? firstMatch(String text, String query) {
+  final q = _fold(query);
+  if (q.isEmpty) return null;
+  final t = _Folded(text);
+  var at = t.folded.indexOf(q);
+  while (at >= 0) {
+    if (_wordStart(text, t.from[at])) {
+      return (start: t.from[at], end: t.to[at + q.length - 1]);
+    }
+    at = t.folded.indexOf(q, at + 1);
+  }
+  return null;
+}
+
+/// A night's first match, its told dreams in order, or null.
+Found? findIn(Night night, String query) {
+  for (final (i, e) in night.entries.indexed) {
+    if (e case Told(:final text)) {
+      if (firstMatch(text, query) case final span?) return (night: night, entry: i, span: span);
+    }
+  }
+  return null;
+}
+
+/// Every night with a match, in the order given (newest first).
+List<Found> search(List<Night> nights, String query) => [
+  for (final n in nights) ?findIn(n, query),
+];
+
+String _oneLine(String s) => s.replaceAll(_space, ' ');
+
+/// The context line around [span] in [text].
+Context contextOf(String text, Span span) {
+  final head = text.substring(0, span.start);
+  final words = _word.allMatches(head).toList();
+  final left = words.length > contextWordsBefore;
+  final kept = left ? head.substring(words[words.length - contextWordsBefore].start) : head;
+  final before = _oneLine(kept).trimLeft();
+  return (
+    before: left ? '$cut $before' : before,
+    match: _oneLine(text.substring(span.start, span.end)),
+    after: _oneLine(text.substring(span.end)).trimRight(),
+  );
+}
diff --git a/app/test/journal/search_test.dart b/app/test/journal/search_test.dart
new file mode 100644
index 0000000000000000000000000000000000000000..ffaf194add03def2ad16d11439726fbedfb68275
--- /dev/null
+++ b/app/test/journal/search_test.dart
@@ -0,0 +1,110 @@
+// Search, in plain Dart (D110; D116 items 1 to 3; D117 Q4, Q5, Q8): from
+// three characters, case folded with marks kept, the typed characters at
+// the start of a word, the first place in a night, the dreams' text only;
+// the context line around it. Every text is an invented night (R2).
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/search.dart';
+
+import '../fixtures.dart';
+
+String dream(String key, [int i = 0]) => invented(key).dreams[i];
+
+String matched(String text, String query) {
+  final s = firstMatch(text, query)!;
+  return text.substring(s.start, s.end);
+}
+
+void main() {
+  test('a search starts from three characters, the spaces around left out', () {
+    expect(searchable(''), isNull);
+    expect(searchable('  gl  '), isNull);
+    expect(searchable(' gla '), 'gla');
+    expect(searchable('g l'), 'g l');
+    // Characters, not code units: one outside the basic plane counts once.
+    expect(searchable('\u{1F319}a'), isNull);
+    expect(searchable('\u{1F319}ab'), '\u{1F319}ab');
+  });
+
+  test('capitals fold; å, ä and ö stay apart', () {
+    final text = dream('one-dream-sv');
+    expect(matched(text, 'TÅG'), 'tåg');
+    expect(matched(text, 'Glas'), 'glas');
+    expect(firstMatch(text, 'tag'), isNull);
+    expect(firstMatch(text, 'gläs'), isNull);
+    expect(matched(dream('two-dreams-en'), 'LIGHTHOUSE'), 'lighthouse');
+  });
+
+  test('the typed characters match only at the start of a word', () {
+    final sv = dream('one-dream-sv');
+    expect(matched(sv, 'citron'), 'citron');
+    expect(firstMatch(sv, 'träd'), isNull);
+    final en = dream('two-dreams-en');
+    expect(matched(en, 'fiel'), 'fiel');
+    expect(firstMatch(en, 'ield'), isNull);
+    expect(matched(en, 'wheat fi'), 'wheat fi');
+  });
+
+  test('the first place in the text, never a later one', () {
+    final en = dream('two-dreams-en');
+    final s = firstMatch(en, 'the')!;
+    expect(s.start, en.indexOf('the'));
+    expect(en.substring(s.start, s.end), 'the');
+  });
+
+  test('the span is on the text\'s own characters', () {
+    // A capital I with a dot (U+0130) folds to a plain i.
+    expect(firstMatch('ab İz', 'iZ'), (start: 3, end: 5));
+    // U+10400 folds to U+10428, each two code units.
+    expect(firstMatch('ab \u{10400}x', '\u{10428}X'), (start: 3, end: 6));
+    // A letter outside the basic plane is a word's letter.
+    expect(firstMatch('ab \u{10428}x', 'x'), isNull);
+    // A mark that is no letter is not.
+    expect(firstMatch('ab \u{1F319}xy', 'xy'), (start: 5, end: 7));
+  });
+
+  test('a night: its told dreams in order, never its name', () {
+    final n = nightsFromFixtures().singleWhere((x) => x.name != null);
+    final key = invented('named-three-dreams-sv');
+    expect(findIn(n, 'glas')!.entry, 0);
+    expect(findIn(n, 'NYCKEL')!.entry, 2);
+    expect(findIn(n, 'nyckel')!.span, firstMatch(key.dreams[2], 'nyckel'));
+    final waiting = n.withEntries([Waiting('e' * 32, 0), ...n.entries]);
+    expect(findIn(waiting, 'nyckel')!.entry, 3);
+    expect(findIn(n, key.name!.substring(0, 6)), isNull);
+  });
+
+  test('search keeps the order and leaves out nights with no match', () {
+    final nights = nightsFromFixtures().reversed.toList();
+    final glas = search(nights, 'glas');
+    expect(glas.map((f) => f.night.id), [
+      for (final n in nights)
+        if (n.dreams.any((d) => d.contains('glas'))) n.id,
+    ]);
+    expect(glas, hasLength(2));
+    expect(search(nights, 'zzz'), isEmpty);
+  });
+
+  test('the context: three words before, the match, then the rest', () {
+    final long = dream('long-dream-en');
+    final at = firstMatch(long, 'tortoise')!;
+    final c = contextOf(long, at);
+    expect(c.before, '$cut a crowd of ');
+    expect(c.match, 'tortoise');
+    expect(c.after, long.substring(at.end));
+    final first = contextOf(dream('two-dreams-en'), firstMatch(dream('two-dreams-en'), 'lighth')!);
+    expect(first.before, 'A ');
+  });
+
+  test('the context is one line, each run of spaces one space', () {
+    final d = invented('named-three-dreams-sv').dreams;
+    final text = '${d[0]}\n\n${d[1]}  ';
+    final c = contextOf(text, firstMatch(text, 'sedan')!);
+    final words = d[0].split(' ');
+    expect(c.before, '$cut ${words.sublist(words.length - 3).join(' ')} ');
+    expect(c.match, 'Sedan');
+    expect(c.after, d[1].substring(5));
+    final across = contextOf(text, firstMatch(text, 'molnen')!);
+    expect(across.after, '. ${d[1]}');
+  });
+}
diff --git a/app/test/words/lines_test.dart b/app/test/words/lines_test.dart
index 4724f0ad888d79be96c2cfb1505086633e417b18..a6962a4b4ce95f2d9710d86ef3d8bf3d99f2989d 100644
--- a/app/test/words/lines_test.dart
+++ b/app/test/words/lines_test.dart
@@ -47,6 +47,17 @@ void main() {
     expect(line.text(Lang.sv, flavor: 'dev'), 'sv');
   });
 
+  // D117 Q1: a pending line takes the register's slots, filled as a
+  // filed line's are; outside Dev, still its handle.
+  test('a pending line with a slot, filled in Dev', () {
+    final line = PendingLines.MP_67(n: 7);
+    expect(line.handle, 'MP·67');
+    expect(line.text(Lang.en, flavor: 'dev'), contains('7'));
+    expect(line.text(Lang.en, flavor: 'dev'), isNot(contains('{')));
+    expect(line.text(Lang.sv, flavor: 'dev'), contains('7'));
+    expect(line.text(Lang.en, flavor: 'tester'), '[MP·67]');
+  });
+
   test('no line is pending and filed at once', () {
     final filed = Lines.all.map((l) => l.handle).toSet();
     expect(PendingLines.all.where((p) => filed.contains(p.handle)), isEmpty);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 489b07177e7e9c5ae60d7ce06ed91f069a0fdf90..12c915bae9ef5b263aed96bc720626edb6a4bc9a 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2018,6 +2018,51 @@ ROWS = [
      '      rowBorder: c(rowBorder, other.rowBorder),\n',
      '      rowBorder: rowBorder,\n',
      'test/design/palette_test.dart', 'the row border fades with the theme'),
+    # redesign-b (D116, D117): search's matcher and context line.
+    ('A442', 'lib/journal/search.dart',
+     '      final f = String.fromCharCode(r).toLowerCase();',
+     '      final f = String.fromCharCode(r);',
+     'test/journal/search_test.dart', 'capitals fold; å, ä and ö stay apart'),
+    ('A443', 'lib/journal/search.dart',
+     '    if (_wordStart(text, t.from[at])) {',
+     '    if (true) {',
+     'test/journal/search_test.dart', 'the typed characters match only at the start of a word'),
+    ('A444', 'lib/journal/search.dart',
+     '0xDFFF) j--;',
+     '0xDFFF) {}',
+     'test/journal/search_test.dart', 'the span is on the text\'s own characters'),
+    ('A445', 'lib/journal/search.dart',
+     '      final width = r > 0xFFFF ? 2 : 1;',
+     '      const width = 1;',
+     'test/journal/search_test.dart', 'the span is on the text\'s own characters'),
+    ('A446', 'lib/journal/search.dart',
+     '  return q.runes.length >= searchFrom ? q : null;',
+     '  return q.length >= searchFrom ? q : null;',
+     'test/journal/search_test.dart', 'a search starts from three characters, the spaces around left out'),
+    ('A447', 'lib/journal/search.dart',
+     '  final q = typed.trim();',
+     '  final q = typed;',
+     'test/journal/search_test.dart', 'a search starts from three characters, the spaces around left out'),
+    ('A448', 'lib/journal/search.dart',
+     'return (night: night, entry: i, span: span);',
+     'return (night: night, entry: i - 1, span: span);',
+     'test/journal/search_test.dart', 'a night: its told dreams in order, never its name'),
+    ('A449', 'lib/journal/search.dart',
+     'const int contextWordsBefore = 3;',
+     'const int contextWordsBefore = 4;',
+     'test/journal/search_test.dart', 'the context: three words before, the match, then the rest'),
+    ('A450', 'lib/journal/search.dart',
+     "    before: left ? '$cut $before' : before,",
+     '    before: before,',
+     'test/journal/search_test.dart', 'the context: three words before, the match, then the rest'),
+    ('A451', 'lib/journal/search.dart',
+     '    match: _oneLine(text.substring(span.start, span.end)),\n    after: _oneLine(text.substring(span.end)).trimRight(),',
+     '    match: _oneLine(text.substring(span.start, span.end)),\n    after: text.substring(span.end).trimRight(),',
+     'test/journal/search_test.dart', 'the context is one line, each run of spaces one space'),
+    ('A452', 'lib/journal/search.dart',
+     '  var at = t.folded.indexOf(q);',
+     '  var at = t.folded.lastIndexOf(q);',
+     'test/journal/search_test.dart', 'the first place in the text, never a later one'),
 ]
 
 
~~~~

### Task 4 · The journal: the field, the count, the matching rows and their context lines

`journal_page.dart`: the field (`_SearchField`, `_Magnifier`), the query (`_search`, `_query`), the count
(`_count`), the results through `listItems`, and `_Row`'s context line (`_ContextLine`). `stand_ins.dart`: the
field's and the context line's stand-ins. Tests: `test/journal/pages/journal_search_test.dart` (10); in
`journal_page_test.dart` the empty journal now has one field, search's. Rows A453 to A465 new; A322, A377 and A379
follow the code (D67: the row's builder moved).

Expected: 597 app tests; rows `A322,A377,A379,A453,A454,A455,A456,A457,A458,A459,A460,A461,A462,A463,A464,A465`,
every one caught. Commit:

> Journal: search, from three characters, with the count, the matching nights and their context (D110, D116, D117)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index bfe09e63fe929a2204ba8ba34df0bc568b8375a1..db0c1d091df4f65d8ceeca52e29d6e6f6a784fb0 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -28,6 +28,16 @@ abstract final class StandIns {
   static const rowBorderLight = Color(0xFF9E9E9E);
   static const rowBorderDark = Color(0xFF8A8A8A);
 
+  /// The search field (D116; D117 Q7): above it, inside it at the sides,
+  /// its magnifier, drawn as a ring and a handle, and the space after it;
+  /// and the space between a result's row and its context line (D117 Q8).
+  static const double searchAbove = 20;
+  static const searchPadding = EdgeInsets.symmetric(horizontal: 18);
+  static const magnifier = Size(16, 16);
+  static const double magnifierStroke = 1.5;
+  static const double searchGap = 10;
+  static const double contextGap = 6;
+
   /// The sky mark above the greeting (D112): its size, the space below it,
   /// and the colours of the sun and the moon, stand-ins drawn in code until
   /// the founder supplies the images.
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 71100da4e8245ab4fd378609bc8698488fd1f138..38566554b40fafcbc24039f2b24fdb163e2f300b 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -7,8 +7,16 @@
 // no night. Straight from onboarding, the first empty journal also shows
 // MP·9 under New Dream, with an arrow up to it, once (main-path.md,
 // Onboarding, 5); the logo waits for the founder's file. No Settings entry
-// and no search (later branches). Nothing on a row grades it: no badge,
+// (a later branch, D116 item 5). Nothing on a row grades it: no badge,
 // count or status.
+// Search (D110; D116; D117): the field at the top, as wide as a row, EM·4
+// its placeholder, a magnifier drawn in code and silent, no clear button.
+// From three characters, where the list starts: the count of nights (MP·66,
+// MP·67) or MP·68, then only the matching nights' rows, newest first, under
+// their month dividers, each with its context line under it, the match in
+// SemiBold. The query lives only while the page does: never kept, never
+// logged (R3), no recent searches. The count lines are pending (D117 Q1).
+// The sky mark stays 140 down.
 import 'dart:async';
 
 import 'package:flutter/material.dart';
@@ -20,6 +28,7 @@ import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
+import '../../words/pending.g.dart';
 import '../../recording/recording.dart';
 import '../greeting.dart';
 import '../journal.dart';
@@ -29,6 +38,7 @@ import '../night_look.dart';
 import '../night_rules.dart';
 import '../owed.dart';
 import '../row_text.dart';
+import '../search.dart';
 import '../sky.dart';
 import 'night_art.dart';
 import 'night_page.dart';
@@ -53,6 +63,12 @@ class JournalPage extends StatefulWidget {
 
   static const arrowKey = Key('first-arrow');
   static const newDreamKey = Key('new-dream');
+  static const searchKey = Key('search');
+  static const searchFieldKey = Key('search-field');
+  static const countKey = Key('search-count');
+
+  /// A result's context line.
+  static Key contextKey(String id) => ValueKey('context-$id');
 
   /// A night's row.
   static Key rowKey(String id) => ValueKey('row-$id');
@@ -77,6 +93,10 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   late Sky _sky = _skyNow();
   late final Timer _clock;
 
+  // The search as typed, and as searched (null under three characters).
+  final _search = TextEditingController();
+  String? _query;
+
   Daypart _daypartNow() => daypartAt(widget.journal.zone.wall(widget.journal.now()).hour);
   Sky _skyNow() => skyAt(widget.journal.zone.wall(widget.journal.now()).hour);
 
@@ -85,6 +105,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     super.initState();
     WidgetsBinding.instance.addObserver(this);
     _load();
+    _search.addListener(_searched);
     widget.recording?.retries?.addListener(_load);
     // The greeting and the sky mark follow the clock while the page is open.
     _clock = Timer.periodic(const Duration(minutes: 1), (_) {
@@ -102,11 +123,17 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   @override
   void dispose() {
     _clock.cancel();
+    _search.dispose();
     WidgetsBinding.instance.removeObserver(this);
     widget.recording?.retries?.removeListener(_load);
     super.dispose();
   }
 
+  void _searched() {
+    final q = searchable(_search.text);
+    if (q != _query) setState(() => _query = q);
+  }
+
   // On returning, the year may have turned: the dividers are built again.
   @override
   void didChangeAppLifecycleState(AppLifecycleState state) {
@@ -165,11 +192,36 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     final p = Palette.of(context);
     final nights = _nights;
     final year = widget.journal.zone.wall(widget.journal.now()).year;
+    final query = _query;
+    final found = nights == null || query == null ? null : search(nights, query);
+    final contexts = {
+      for (final f in found ?? const <Found>[])
+        f.night.id: contextOf((f.night.entries[f.entry] as Told).text, f.span),
+    };
+    Widget row(Night night) => _Row(
+      night,
+      look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings),
+      line: contexts[night.id],
+      onTap: () => _push(
+        NightPage(
+          journal: widget.journal,
+          id: night.id,
+          recording: widget.recording,
+          action: widget.nightAction,
+          read: widget.read,
+        ),
+      ),
+    );
     return Scaffold(
       body: SafeArea(
         child: ListView(
-          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.greetingAbove, Spacing.pageSide, StandIns.journalEnd),
+          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.searchAbove, Spacing.pageSide, StandIns.journalEnd),
           children: [
+            Padding(
+              padding: const EdgeInsets.symmetric(horizontal: StandIns.rowSide - Spacing.pageSide),
+              child: _SearchField(_search),
+            ),
+            const SizedBox(height: StandIns.greetingAbove - StandIns.searchAbove - Spacing.sizeFieldSearch),
             // The sun by day, the moon by night, then the greeting (D112).
             Center(child: SkyMark(_sky)),
             const SizedBox(height: StandIns.skyGap),
@@ -190,28 +242,29 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
               const SizedBox(height: StandIns.arrowGap),
               AppLine(Lines.MP_9.text(appLanguage), style: TypeRoles.button.style(p.text)),
             ],
-            if (nights != null && nights.isEmpty) ...[
+            if (found != null) ...[
+              const SizedBox(height: StandIns.listAbove),
+              // The count of nights, or none (D117 Q2, Q3, Q5), where the
+              // list starts, in the button type, centred.
+              KeyedSubtree(
+                key: JournalPage.countKey,
+                child: AppLine(_count(found.length), style: TypeRoles.button.style(p.text)),
+              ),
+              for (final item in listItems([for (final f in found) f.night]))
+                switch (item) {
+                  MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
+                  NightItem(:final night) => row(night),
+                },
+            ] else if (nights != null && nights.isEmpty) ...[
               const SizedBox(height: StandIns.listAbove),
               // In the button type, centred (head's message 20, item 7).
               AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text)),
-            ],
-            if (nights != null && nights.isNotEmpty) ...[
+            ] else if (nights != null) ...[
               const SizedBox(height: StandIns.listAbove - StandIns.dividerAbove),
               for (final item in listItems(nights))
                 switch (item) {
                   MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
-                  NightItem(:final night) => _Row(
-                    night,
-                    look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings),
-                    onTap: () =>
-                        _push(NightPage(
-                          journal: widget.journal,
-                          id: night.id,
-                          recording: widget.recording,
-                          action: widget.nightAction,
-                          read: widget.read,
-                        )),
-                  ),
+                  NightItem(:final night) => row(night),
                 },
             ],
           ],
@@ -221,6 +274,94 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   }
 }
 
+/// The search's count: one night, more, or none (D117 Q2, Q3, Q5).
+String _count(int nights) => switch (nights) {
+  0 => PendingLines.MP_68.text(appLanguage),
+  1 => PendingLines.MP_66.text(appLanguage),
+  _ => PendingLines.MP_67(n: nights).text(appLanguage),
+};
+
+/// The search field (D116; D117 Q7): a pill as wide as a row, 50 tall,
+/// `color.field` with its border, a magnifier, and EM·4 as its placeholder
+/// in `color.text.placeholder`; the dreamer's words in the button type. It
+/// suggests and corrects nothing (main-path.md, Search).
+class _SearchField extends StatelessWidget {
+  const _SearchField(this.controller);
+
+  final TextEditingController controller;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return ConstrainedBox(
+      key: JournalPage.searchFieldKey,
+      constraints: const BoxConstraints(minHeight: Spacing.sizeFieldSearch),
+      child: DecoratedBox(
+        decoration: BoxDecoration(
+          color: p.field,
+          borderRadius: BorderRadius.circular(Spacing.sizeFieldSearch / 2),
+          border: Border.all(color: p.fieldBorder),
+        ),
+        child: Padding(
+          padding: StandIns.searchPadding,
+          child: Row(
+            children: [
+              ExcludeSemantics(
+                child: SizedBox.fromSize(
+                  size: StandIns.magnifier,
+                  child: CustomPaint(painter: _Magnifier(p.placeholder)),
+                ),
+              ),
+              const SizedBox(width: StandIns.searchGap),
+              Expanded(
+                child: TextField(
+                  key: JournalPage.searchKey,
+                  controller: controller,
+                  autocorrect: false,
+                  enableSuggestions: false,
+                  textInputAction: TextInputAction.search,
+                  style: TypeRoles.button.style(p.fieldText),
+                  cursorColor: p.fieldText,
+                  decoration: InputDecoration.collapsed(
+                    hintText: Lines.EM_4.text(appLanguage),
+                    hintStyle: TypeRoles.button.style(p.placeholder),
+                  ),
+                ),
+              ),
+            ],
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// A magnifier: a ring and a handle to the lower right, drawn as the
+/// chevrons are. Heard as nothing.
+class _Magnifier extends CustomPainter {
+  _Magnifier(this.colour);
+
+  final Color colour;
+
+  @override
+  void paint(Canvas canvas, Size size) {
+    const inset = StandIns.magnifierStroke / 2;
+    final r = size.width * 0.35;
+    final centre = Offset(inset + r, inset + r);
+    final paint = Paint()
+      ..color = colour
+      ..style = PaintingStyle.stroke
+      ..strokeWidth = StandIns.magnifierStroke
+      ..strokeCap = StrokeCap.round;
+    canvas.drawCircle(centre, r, paint);
+    final from = centre + Offset(r, r) * 0.7071;
+    canvas.drawLine(from, Offset(size.width - inset, size.height - inset), paint);
+  }
+
+  @override
+  bool shouldRepaint(_Magnifier old) => old.colour != colour;
+}
+
 /// New Dream (D110, D112): a pill on a night sky, its words in the button
 /// type over it, opening the typing screen; heard as a button.
 class _NewDream extends StatelessWidget {
@@ -315,39 +456,53 @@ class _Divider extends StatelessWidget {
 /// h6 over the night's picture; heard as a button named by its date. A name
 /// kept from before naming was removed is not shown.
 class _Row extends StatelessWidget {
-  const _Row(this.night, {required this.look, required this.onTap});
+  const _Row(this.night, {required this.look, required this.onTap, this.line});
 
   final Night night;
   final NightLook look;
   final VoidCallback onTap;
 
+  /// A search result's context line, or null (D116 item 3).
+  final Context? line;
+
   @override
   Widget build(BuildContext context) => Padding(
     // 48 from each side of the screen, the page's own margin included (D115).
     padding: const EdgeInsets.fromLTRB(StandIns.rowSide - Spacing.pageSide, 0, StandIns.rowSide - Spacing.pageSide, Spacing.journalRow),
-    child: Semantics(
-      button: true,
-      child: GestureDetector(
-        key: JournalPage.rowKey(night.id),
-        onTap: onTap,
-        child: ClipRRect(
-          borderRadius: BorderRadius.circular(Spacing.radius),
-          child: ConstrainedBox(
-            constraints: const BoxConstraints(minHeight: StandIns.rowHeight),
-            // A thin grey border over the picture, the gradient's too (D115).
-            child: DecoratedBox(
-              position: DecorationPosition.foreground,
-              decoration: BoxDecoration(
-                borderRadius: BorderRadius.circular(Spacing.radius),
-                border: Border.all(color: Palette.of(context).rowBorder, width: StandIns.rowBorderWidth),
-              ),
-              child: NightArt(
-                look,
-                child: Center(
-                  child: Padding(
-                    padding: StandIns.labelPadding,
-                    child: DateShade.over(look, Text(shownDate(night.date), style: TypeRoles.h6.style(NightArt.over))),
-                  ),
+    child: Column(
+      crossAxisAlignment: CrossAxisAlignment.stretch,
+      children: [
+        _pill(context),
+        if (line case final c?) ...[
+          const SizedBox(height: StandIns.contextGap),
+          _ContextLine(night.id, c),
+        ],
+      ],
+    ),
+  );
+
+  Widget _pill(BuildContext context) => Semantics(
+    button: true,
+    child: GestureDetector(
+      key: JournalPage.rowKey(night.id),
+      onTap: onTap,
+      child: ClipRRect(
+        borderRadius: BorderRadius.circular(Spacing.radius),
+        child: ConstrainedBox(
+          constraints: const BoxConstraints(minHeight: StandIns.rowHeight),
+          // A thin grey border over the picture, the gradient's too (D115).
+          child: DecoratedBox(
+            position: DecorationPosition.foreground,
+            decoration: BoxDecoration(
+              borderRadius: BorderRadius.circular(Spacing.radius),
+              border: Border.all(color: Palette.of(context).rowBorder, width: StandIns.rowBorderWidth),
+            ),
+            child: NightArt(
+              look,
+              child: Center(
+                child: Padding(
+                  padding: StandIns.labelPadding,
+                  child: DateShade.over(look, Text(shownDate(night.date), style: TypeRoles.h6.style(NightArt.over))),
                 ),
               ),
             ),
@@ -357,3 +512,33 @@ class _Row extends StatelessWidget {
     ),
   );
 }
+
+/// A search result's context line (D116 item 3; D117 Q8): one line under
+/// its row, as wide as the row, centred, in the button type and
+/// `color.text.summary`, the matched characters in Inter SemiBold, cut with
+/// an ellipsis where it runs out.
+class _ContextLine extends StatelessWidget {
+  const _ContextLine(this.id, this.line);
+
+  final String id;
+  final Context line;
+
+  @override
+  Widget build(BuildContext context) {
+    final style = TypeRoles.button.style(Palette.of(context).summary);
+    return Text.rich(
+      key: JournalPage.contextKey(id),
+      TextSpan(
+        children: [
+          TextSpan(text: line.before),
+          TextSpan(text: line.match, style: const TextStyle(fontWeight: FontWeight.w600)),
+          TextSpan(text: line.after),
+        ],
+      ),
+      style: style,
+      textAlign: TextAlign.center,
+      maxLines: 1,
+      overflow: TextOverflow.ellipsis,
+    );
+  }
+}
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index c11bd16bdf28aaec3d965b77436958bd93bdc2dc..9688c4661f0d248f4bf917365d7bcf827d826298 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -72,9 +72,10 @@ void main() {
     expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
     // The round record button is gone (D110).
     expect(find.text(Lines.MP_11.text(Lang.en)), findsNothing);
-    // No Settings entry and no search: later branches.
+    // No Settings entry: a later branch (D116 item 5). One field, search's.
     expect(find.text(Lines.MP_25.text(Lang.en)), findsNothing);
-    expect(find.byType(TextField), findsNothing);
+    expect(find.byType(TextField), findsOneWidget);
+    expect(find.byKey(JournalPage.searchKey), findsOneWidget);
   });
 
   // D110: a greeting by the part of the day, centred in h2, heard as a
diff --git a/app/test/journal/pages/journal_search_test.dart b/app/test/journal/pages/journal_search_test.dart
new file mode 100644
index 0000000000000000000000000000000000000000..a65ce3fb2f66d91e8aebc1dff523d69978df13b5
--- /dev/null
+++ b/app/test/journal/pages/journal_search_test.dart
@@ -0,0 +1,179 @@
+// The journal's search (D110; D116; D117 Q2 to Q8): the field at the top
+// with EM·4, from three characters the count (MP·66, MP·67) or MP·68, only
+// the matching nights' rows, newest first, each with its context line, the
+// match in SemiBold. Pending lines show their handles outside SoulDreams
+// Dev, so the tests see the handles (R1).
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/design/palette.dart';
+import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/design/tokens.g.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/pages/journal_page.dart';
+import 'package:souldreams/journal/pages/night_page.dart';
+import 'package:souldreams/journal/pages/sky_mark.dart';
+import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/journal/search.dart';
+import 'package:souldreams/words/lines.g.dart';
+import 'package:souldreams/words/pending.g.dart';
+
+import '../zones.dart';
+import 'harness.dart';
+
+Future<List<Night>> three(Harness h) async => [
+  await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23)),
+  await keep(h, 'one-dream-sv', stockholm(2026, 6, 4, 23)),
+  await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 6, 23)),
+];
+
+Future<void> type(WidgetTester tester, String words) async {
+  await tester.enterText(find.byKey(JournalPage.searchKey), words);
+  await tester.pumpAndSettle();
+}
+
+Finder row(Night n) => find.byKey(JournalPage.rowKey(n.id));
+
+/// A phone's screen, 390 by 844, tall enough that every row is built, so a
+/// row left out is truly left out.
+void phone(WidgetTester tester) {
+  tester.view.physicalSize = const Size(1170, 2532);
+  tester.view.devicePixelRatio = 3;
+  addTearDown(tester.view.reset);
+}
+
+void main() {
+  testWidgets('the field: EM·4 at the top, as wide as a row', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    expect(find.text(Lines.EM_4.text(Lang.en)), findsOneWidget);
+    final width = tester.getSize(find.byType(JournalPage)).width;
+    final top = tester.getRect(find.byType(ListView)).top;
+    final field = tester.getRect(find.byKey(JournalPage.searchFieldKey));
+    expect(field.top - top, closeTo(StandIns.searchAbove, 1));
+    expect(field.height, closeTo(Spacing.sizeFieldSearch, 1));
+    expect(field.left, closeTo(StandIns.rowSide, 1));
+    expect(field.right, closeTo(width - StandIns.rowSide, 1));
+    // The sky mark stays where it was, below it.
+    expect(tester.getRect(find.byType(SkyMark)).top - top, closeTo(StandIns.greetingAbove, 1));
+  });
+
+  testWidgets('the field suggests and corrects nothing', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final f = tester.widget<TextField>(find.byKey(JournalPage.searchKey));
+    expect(f.autocorrect, isFalse);
+    expect(f.enableSuggestions, isFalse);
+    expect(f.textInputAction, TextInputAction.search);
+    expect(f.decoration!.hintText, Lines.EM_4.text(Lang.en));
+  });
+
+  testWidgets('under three characters, every night as before', (tester) async {
+    phone(tester);
+    final h = await Harness.make();
+    final nights = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, ' gl ');
+    for (final n in nights) {
+      expect(row(n), findsOneWidget);
+    }
+    expect(find.byKey(JournalPage.countKey), findsNothing);
+    expect(find.byKey(JournalPage.contextKey(nights.first.id)), findsNothing);
+  });
+
+  testWidgets('from three characters: the count and only the matching rows', (tester) async {
+    phone(tester);
+    final h = await Harness.make();
+    final [en, sv, named] = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'GLAS');
+    expect(find.text(PendingLines.MP_67(n: 2).text(Lang.en)), findsOneWidget);
+    expect(row(en), findsNothing);
+    expect(row(sv), findsOneWidget);
+    expect(row(named), findsOneWidget);
+    // Newest first, under the count.
+    final count = tester.getRect(find.byKey(JournalPage.countKey));
+    expect(tester.getRect(row(named)).top, greaterThan(count.bottom));
+    expect(tester.getRect(row(sv)).top, greaterThan(tester.getRect(row(named)).bottom));
+  });
+
+  testWidgets('one night: MP·66; none: MP·68 and no row', (tester) async {
+    phone(tester);
+    final h = await Harness.make();
+    final [en, sv, named] = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'lighth');
+    expect(find.text(PendingLines.MP_66.text(Lang.en)), findsOneWidget);
+    expect(row(en), findsOneWidget);
+    await type(tester, 'zzz');
+    expect(find.text(PendingLines.MP_68.text(Lang.en)), findsOneWidget);
+    for (final n in [en, sv, named]) {
+      expect(row(n), findsNothing);
+    }
+    expect(find.text(Lines.C4_P_5.text(Lang.en)), findsNothing);
+  });
+
+  testWidgets('the count: the button type, centred', (tester) async {
+    final h = await Harness.make();
+    await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'glas');
+    final count = find.byKey(JournalPage.countKey);
+    final text = tester.widget<Text>(find.descendant(of: count, matching: find.byType(Text)));
+    expect(text.style!.fontFamily, TypeRoles.button.family);
+    expect(tester.getCenter(count).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
+  });
+
+  testWidgets('back under three characters, the journal returns', (tester) async {
+    phone(tester);
+    final h = await Harness.make();
+    final nights = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'glas');
+    await type(tester, 'gl');
+    for (final n in nights) {
+      expect(row(n), findsOneWidget);
+    }
+    expect(find.byKey(JournalPage.countKey), findsNothing);
+  });
+
+  testWidgets('a context line under its row, the match in SemiBold', (tester) async {
+    final h = await Harness.make();
+    final [_, sv, _] = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'tåg');
+    final line = find.byKey(JournalPage.contextKey(sv.id));
+    expect(tester.getRect(line).top, greaterThan(tester.getRect(row(sv)).bottom));
+    final text = tester.widget<Text>(line);
+    expect(text.maxLines, 1);
+    expect(text.overflow, TextOverflow.ellipsis);
+    expect(text.style!.fontFamily, TypeRoles.button.family);
+    expect(text.style!.color, Palette.light.summary);
+    final c = contextOf(sv.dreams.first, firstMatch(sv.dreams.first, 'tåg')!);
+    final parts = (text.textSpan! as TextSpan).children!.cast<TextSpan>();
+    expect([for (final s in parts) s.text], [c.before, c.match, c.after]);
+    expect(parts[1].style!.fontWeight, FontWeight.w600);
+    expect(parts[0].style, isNull);
+    expect(parts[2].style, isNull);
+  });
+
+  testWidgets('a result opens its night', (tester) async {
+    final h = await Harness.make();
+    final [_, sv, _] = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'citron');
+    await tester.tap(find.text(shownDate(sv.date)));
+    await tester.pumpAndSettle();
+    expect(tester.widget<NightPage>(find.byType(NightPage)).id, sv.id);
+  });
+
+  testWidgets('a search at twice the size does not overflow', (tester) async {
+    final h = await Harness.make();
+    await three(h);
+    await keep(h, 'long-dream-en', stockholm(2026, 6, 8, 23));
+    tester.platformDispatcher.textScaleFactorTestValue = 2;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'the');
+    expect(tester.takeException(), isNull);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 12c915bae9ef5b263aed96bc720626edb6a4bc9a..ce544cae0b5de70734386a37be570e9d3e2b7ab6 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1512,7 +1512,7 @@ ROWS = [
      '',
      'test/journal/pages/night_page_test.dart', 'a given item runs once, with the night shown'),
     ('A322', 'lib/journal/pages/journal_page.dart',
-     '                          action: widget.nightAction,\n',
+     '          action: widget.nightAction,\n',
      '',
      'test/journal/pages/journal_page_test.dart', "a row hands its night's page the menu's item"),
     ('A323', 'lib/journal/pages/journal_home.dart',
@@ -1751,7 +1751,7 @@ ROWS = [
      'look: lookOf(night, read: false, paintings: NightArt.paintings),',
      'test/journal/pages/journal_page_test.dart', "a read night's row shows its painting"),
     ('A377', 'lib/journal/pages/journal_page.dart',
-     '                          read: widget.read,\n',
+     '          read: widget.read,\n',
      '',
      'test/journal/pages/journal_page_test.dart', "a row hands its night's page whether it is read"),
     ('A378', 'lib/journal/pages/journal_page.dart',
@@ -1759,8 +1759,8 @@ ROWS = [
      'constraints: const BoxConstraints(),',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
     ('A379', 'lib/journal/pages/journal_page.dart',
-     '      button: true,\n      child: GestureDetector(\n        key: JournalPage.rowKey(night.id),',
-     '      button: false,\n      child: GestureDetector(\n        key: JournalPage.rowKey(night.id),',
+     '    button: true,\n    child: GestureDetector(\n      key: JournalPage.rowKey(night.id),',
+     '    button: false,\n    child: GestureDetector(\n      key: JournalPage.rowKey(night.id),',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
     ('A380', 'lib/journal/pages/journal_page.dart',
      'TypeRoles.h6.style(NightArt.over)',
@@ -2063,6 +2063,59 @@ ROWS = [
      '  var at = t.folded.indexOf(q);',
      '  var at = t.folded.lastIndexOf(q);',
      'test/journal/search_test.dart', 'the first place in the text, never a later one'),
+    # redesign-b (D116, D117): the journal's search.
+    ('A453', 'lib/journal/pages/journal_page.dart',
+     '                  autocorrect: false,',
+     '                  autocorrect: true,',
+     'test/journal/pages/journal_search_test.dart', 'the field suggests and corrects nothing'),
+    ('A454', 'lib/journal/pages/journal_page.dart',
+     '                  enableSuggestions: false,',
+     '                  enableSuggestions: true,',
+     'test/journal/pages/journal_search_test.dart', 'the field suggests and corrects nothing'),
+    ('A455', 'lib/journal/pages/journal_page.dart',
+     '                  textInputAction: TextInputAction.search,',
+     '                  textInputAction: TextInputAction.done,',
+     'test/journal/pages/journal_search_test.dart', 'the field suggests and corrects nothing'),
+    ('A456', 'lib/journal/pages/journal_page.dart',
+     '    if (q != _query) setState(() => _query = q);',
+     '    if (q != _query) _query = q;',
+     'test/journal/pages/journal_search_test.dart', 'from three characters: the count and only the matching rows'),
+    ('A457', 'lib/journal/pages/journal_page.dart',
+     'listItems([for (final f in found) f.night])',
+     'listItems(nights!)',
+     'test/journal/pages/journal_search_test.dart', 'from three characters: the count and only the matching rows'),
+    ('A458', 'lib/journal/pages/journal_page.dart',
+     '  1 => PendingLines.MP_66.text(appLanguage),\n',
+     '',
+     'test/journal/pages/journal_search_test.dart', 'one night: MP·66; none: MP·68 and no row'),
+    ('A459', 'lib/journal/pages/journal_page.dart',
+     '  0 => PendingLines.MP_68.text(appLanguage),\n',
+     '',
+     'test/journal/pages/journal_search_test.dart', 'one night: MP·66; none: MP·68 and no row'),
+    ('A460', 'lib/journal/pages/journal_page.dart',
+     'fontWeight: FontWeight.w600',
+     'fontWeight: FontWeight.w400',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in SemiBold'),
+    ('A461', 'lib/journal/pages/journal_page.dart',
+     '      maxLines: 1,\n      overflow: TextOverflow.ellipsis,\n    );',
+     '      maxLines: 2,\n      overflow: TextOverflow.ellipsis,\n    );',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in SemiBold'),
+    ('A462', 'lib/journal/pages/journal_page.dart',
+     '    final style = TypeRoles.button.style(Palette.of(context).summary);',
+     '    final style = TypeRoles.button.style(Palette.of(context).text);',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in SemiBold'),
+    ('A463', 'lib/journal/pages/journal_page.dart',
+     '          _ContextLine(night.id, c),',
+     '          const SizedBox(),',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in SemiBold'),
+    ('A464', 'lib/journal/pages/journal_page.dart',
+     'StandIns.greetingAbove - StandIns.searchAbove - Spacing.sizeFieldSearch',
+     'StandIns.greetingAbove - StandIns.searchAbove',
+     'test/journal/pages/journal_search_test.dart', 'the field: EM·4 at the top, as wide as a row'),
+    ('A465', 'lib/journal/pages/journal_page.dart',
+     '              padding: const EdgeInsets.symmetric(horizontal: StandIns.rowSide - Spacing.pageSide),',
+     '              padding: EdgeInsets.zero,',
+     'test/journal/pages/journal_search_test.dart', 'the field: EM·4 at the top, as wide as a row'),
 ]
 
 
~~~~

### Task 5 · The opened night: its match in SemiBold (D117 Q6)

`NightPage.query`; `DreamBubble.bold`; the journal hands the query on from a result. Tests: in
`night_page_test.dart` (3) and `journal_search_test.dart` (1, and the result's test widened). Rows A466 to A470.

Expected: 601 app tests; rows `A466,A467,A468,A469,A470`, every one caught. Commit:

> Night page: opened from a search, the first match in SemiBold in its dream (D117 Q6)

**The block:**

~~~~diff
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 38566554b40fafcbc24039f2b24fdb163e2f300b..d228b72572f2946c68ce84818d7cbda357f09605 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -209,6 +209,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
           recording: widget.recording,
           action: widget.nightAction,
           read: widget.read,
+          query: query,
         ),
       ),
     );
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index b29b8ef7a66b4c41972548fd22c7c33ed611440a..8f06dc35b449a31b4c799006933884dea869b868 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -25,7 +25,9 @@
 // words owed, shown as handles); Dreams brings "Dreams" into view, the
 // other three do nothing until their sections come with the readings. No
 // night is read yet. Not built: reading, and the space below the dreams
-// with its field.
+// with its field. Opened from a search, the night's first match shows in
+// SemiBold in its dream, found again on each read; gone when the page goes
+// (main-path.md, Search; D117 Q6).
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter/services.dart';
@@ -46,12 +48,21 @@ import '../night_look.dart';
 import '../night_rules.dart';
 import '../owed.dart';
 import '../row_text.dart';
+import '../search.dart';
 import 'night_art.dart';
 import 'parts.dart';
 import 'typing_page.dart';
 
 class NightPage extends StatefulWidget {
-  const NightPage({super.key, required this.journal, required this.id, this.recording, this.action, this.read = noneRead});
+  const NightPage({
+    super.key,
+    required this.journal,
+    required this.id,
+    this.recording,
+    this.action,
+    this.read = noneRead,
+    this.query,
+  });
 
   static const menuKey = Key('night-menu');
   static const deleteKey = Key('night-delete');
@@ -76,6 +87,9 @@ class NightPage extends StatefulWidget {
   /// Whether a night has been read: none is yet (the readings come later).
   final ReadCheck read;
 
+  /// The search this night was opened from, as searched, or null.
+  final String? query;
+
   @override
   State<NightPage> createState() => _NightPageState();
 }
@@ -304,6 +318,8 @@ class _NightPageState extends State<NightPage> {
     final top = MediaQuery.paddingOf(context).top;
     final read = n != null && widget.read(n);
     final look = n == null ? null : lookOf(n, read: read, paintings: NightArt.paintings);
+    final query = widget.query;
+    final found = n == null || query == null ? null : findIn(n, query);
     // Light time and battery over the header's picture, in both themes (D113);
     // while the page is blank, the app's own theme (D114).
     final overlay = look != null ? SystemUiOverlayStyle.light : statusBarFor(Theme.of(context).brightness);
@@ -386,7 +402,11 @@ class _NightPageState extends State<NightPage> {
                     const SizedBox(height: StandIns.gap),
                     for (final (i, d) in n.entries.indexed)
                       if (d case Told(:final text)) ...[
-                        DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
+                        DreamBubble(
+                          text,
+                          bold: found?.entry == i ? found!.span : null,
+                          onTap: () => _type((id: n.id, index: i, text: text)),
+                        ),
                         const SizedBox(height: StandIns.bubbleGap),
                       ] else if (d case Waiting(:final audio) when _transcribing == audio) ...[
                         Padding(
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
index b2d083449b50cdcd42ca196797b77a3562093ef8..98a5bb3512a9c62214e5bf638c5705a8b9340512 100644
--- a/app/lib/journal/pages/parts.dart
+++ b/app/lib/journal/pages/parts.dart
@@ -7,6 +7,7 @@ import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
+import '../search.dart';
 
 BoxDecoration _pill(Color top, Color bottom, [Color? border]) => BoxDecoration(
   gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]),
@@ -107,12 +108,14 @@ BoxDecoration surface(Palette p) => BoxDecoration(
   border: Border.all(color: p.surfaceBorder),
 );
 
-/// A dream in the dreamer's bubble, from the right (Spacing.bubbleDreamer).
+/// A dream in the dreamer's bubble, from the right (Spacing.bubbleDreamer);
+/// opened from a search, its [bold] characters in SemiBold (D117 Q6).
 class DreamBubble extends StatelessWidget {
-  const DreamBubble(this.text, {super.key, required this.onTap});
+  const DreamBubble(this.text, {super.key, required this.onTap, this.bold});
 
   final String text;
   final VoidCallback onTap;
+  final Span? bold;
 
   @override
   Widget build(BuildContext context) {
@@ -129,7 +132,22 @@ class DreamBubble extends StatelessWidget {
               decoration: surface(p),
               child: Padding(
                 padding: StandIns.bubblePadding,
-                child: Text(text, style: TypeRoles.voiceDreamer.style(p.text)),
+                child: switch (bold) {
+                  null => Text(text, style: TypeRoles.voiceDreamer.style(p.text)),
+                  final b => Text.rich(
+                    TextSpan(
+                      children: [
+                        TextSpan(text: text.substring(0, b.start)),
+                        TextSpan(
+                          text: text.substring(b.start, b.end),
+                          style: const TextStyle(fontWeight: FontWeight.w600),
+                        ),
+                        TextSpan(text: text.substring(b.end)),
+                      ],
+                    ),
+                    style: TypeRoles.voiceDreamer.style(p.text),
+                  ),
+                },
               ),
             ),
           ),
diff --git a/app/test/journal/pages/journal_search_test.dart b/app/test/journal/pages/journal_search_test.dart
index a65ce3fb2f66d91e8aebc1dff523d69978df13b5..e0f26cf4aab3a675442004403121ae516e4e31dc 100644
--- a/app/test/journal/pages/journal_search_test.dart
+++ b/app/test/journal/pages/journal_search_test.dart
@@ -160,10 +160,23 @@ void main() {
     final h = await Harness.make();
     final [_, sv, _] = await three(h);
     await h.pump(tester, JournalPage(journal: h.journal));
-    await type(tester, 'citron');
+    await type(tester, ' citron ');
     await tester.tap(find.text(shownDate(sv.date)));
     await tester.pumpAndSettle();
-    expect(tester.widget<NightPage>(find.byType(NightPage)).id, sv.id);
+    final page = tester.widget<NightPage>(find.byType(NightPage));
+    expect(page.id, sv.id);
+    // The query as searched, for the match in bold (D117 Q6).
+    expect(page.query, 'citron');
+  });
+
+  testWidgets('a row opened with no search hands no query', (tester) async {
+    final h = await Harness.make();
+    final [_, sv, _] = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'ci');
+    await tester.tap(find.text(shownDate(sv.date)));
+    await tester.pumpAndSettle();
+    expect(tester.widget<NightPage>(find.byType(NightPage)).query, isNull);
   });
 
   testWidgets('a search at twice the size does not overflow', (tester) async {
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index 423c77b4a2ec65d7466afbad01861d475907344e..5d07ae3619769a570eeb137bc8aa5abb87818e1e 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -26,6 +26,7 @@ import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/journal/search.dart';
 import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/words/lines.g.dart';
 
@@ -84,6 +85,7 @@ void main() {
     bool wide = false,
     int hour = 12,
     bool unread = false,
+    String? query,
   }) async {
     // The test's own 800 by 600, where the foot's two buttons do not fill
     // the row, or a phone.
@@ -105,12 +107,48 @@ void main() {
     }
     // A first read that fails leaves the page blank, with no picture.
     if (unread) files!.failReads = true;
-    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action, read: read)),
+    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action, read: read, query: query)),
         hour: hour);
     await tester.tap(find.byKey(Opener.openKey));
     await tester.pumpAndSettle();
   }
 
+  // D117 Q6: opened from a search, the night shows its first match in
+  // SemiBold, in its dream; every other dream, and every opening without a
+  // search, as before.
+  List<TextSpan>? boldParts(WidgetTester tester, String dream) {
+    final text = tester.widget<Text>(find.text(dream));
+    if (text.data != null) return null;
+    return (text.textSpan! as TextSpan).children!.cast<TextSpan>();
+  }
+
+  testWidgets('from a search: the first match in its dream, in SemiBold', (tester) async {
+    await open(tester, key: 'named-three-dreams-sv', query: 'NYCKEL');
+    final d = n.dreams[2];
+    final at = firstMatch(d, 'NYCKEL')!;
+    final parts = boldParts(tester, d)!;
+    expect([for (final s in parts) s.text], [d.substring(0, at.start), d.substring(at.start, at.end), d.substring(at.end)]);
+    expect(parts[1].style!.fontWeight, FontWeight.w600);
+    expect(parts[0].style, isNull);
+    expect(parts[2].style, isNull);
+    expect(boldParts(tester, n.dreams[0]), isNull);
+    expect(boldParts(tester, n.dreams[1]), isNull);
+  });
+
+  testWidgets('without a search, or with no match, nothing is bold', (tester) async {
+    await open(tester, key: 'named-three-dreams-sv');
+    for (final d in n.dreams) {
+      expect(boldParts(tester, d), isNull);
+    }
+  });
+
+  testWidgets('a match no longer there leaves nothing bold', (tester) async {
+    await open(tester, key: 'named-three-dreams-sv', query: 'zzz');
+    for (final d in n.dreams) {
+      expect(boldParts(tester, d), isNull);
+    }
+  });
+
   Future<void> openMenu(WidgetTester tester) async {
     await tester.tap(find.byKey(NightPage.menuKey));
     await tester.pumpAndSettle();
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index ce544cae0b5de70734386a37be570e9d3e2b7ab6..49432702b9f34730eadfac5caf052928c013a55d 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2116,6 +2116,27 @@ ROWS = [
      '              padding: const EdgeInsets.symmetric(horizontal: StandIns.rowSide - Spacing.pageSide),',
      '              padding: EdgeInsets.zero,',
      'test/journal/pages/journal_search_test.dart', 'the field: EM·4 at the top, as wide as a row'),
+    # redesign-b (D117 Q6): the opened night's match in SemiBold.
+    ('A466', 'lib/journal/pages/night_page.dart',
+     '                          bold: found?.entry == i ? found!.span : null,',
+     '                          bold: null,',
+     'test/journal/pages/night_page_test.dart', 'from a search: the first match in its dream, in SemiBold'),
+    ('A467', 'lib/journal/pages/night_page.dart',
+     '                          bold: found?.entry == i ? found!.span : null,',
+     '                          bold: found?.span,',
+     'test/journal/pages/night_page_test.dart', 'from a search: the first match in its dream, in SemiBold'),
+    ('A468', 'lib/journal/pages/parts.dart',
+     '                          style: const TextStyle(fontWeight: FontWeight.w600),',
+     '                          style: const TextStyle(fontWeight: FontWeight.w400),',
+     'test/journal/pages/night_page_test.dart', 'from a search: the first match in its dream, in SemiBold'),
+    ('A469', 'lib/journal/pages/journal_page.dart',
+     '          query: query,\n',
+     '',
+     'test/journal/pages/journal_search_test.dart', 'a result opens its night'),
+    ('A470', 'lib/journal/pages/journal_page.dart',
+     '          query: query,\n',
+     '          query: _search.text,\n',
+     'test/journal/pages/journal_search_test.dart', 'a row opened with no search hands no query'),
 ]
 
 
~~~~

### Task 6 · Docs: Status.md, the runner's count, the Dev-only test's note

Status.md: "Last updated", the current branch, the road ahead, the pending lines, search, the counts (601 tests,
489 rows; 250 guard tests and 96 guard mutations), banked items 145 to 149, the pending lines' section, and
"Rulings during redesign-b": the redesign-a merge, D116 and D117. The runner's header: A1 to A470, 489.
`dev_only_test.dart`: SoulDreams Dev reaches `search.dart` and `pending.g.dart`. Then the full run (D95), once,
before the final review: `python3 -I -B tool/app_mutations.py` → `app mutations: 489 run, 489 caught`.

Expected: 601 app tests. Commit:

> Docs: Status.md for redesign-b (D116, D117); 489 mutation rows

**The block:**

~~~~diff
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
index 04d9aa8c39d425375a9a1f7daf473aa1cbb4f59e..857494bca69a66d3c2eb9282b79563391ec32841 100644
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -73,10 +73,12 @@ void main() {
     });
   }
 
-  // C17-P filed every pending line, so nothing reaches pending.g.dart
-  // until the owner gives the next one.
+  // Search's count lines are pending (D117 Q1): SoulDreams Dev reaches
+  // pending.g.dart through the journal, and the other two never do (above).
   test('SoulDreams Dev reaches the journal pages', () {
     final files = reached('lib/main_dev.dart');
+    expect(files, contains('lib/journal/search.dart'));
+    expect(files, contains('lib/words/pending.g.dart'));
     expect(files, contains('lib/journal/pages/journal_page.dart'));
     expect(files, contains('lib/journal/pages/night_page.dart'));
     expect(files, contains('lib/recording/record_microphone.dart'));
diff --git a/docs/Status.md b/docs/Status.md
index f56c178888daf3530f884859e0e1441a56616a48..cc75e944bbd63323dcb1e5054808527da58ba812 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-21, in branch `redesign-a` (the journal and a night's page to the new design, D110, D112 to D115; the owner's by-eye review, then the merge, next), by Claude Code.
+Last updated: 2026-11-21, in branch `redesign-b` (search, D110, D116, D117; the owner's by-eye review, then the merge, next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,13 +14,14 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`redesign-a`: the journal and a night's page to the new design (D110, head's message 24; plan
-`docs/plans/redesign-a.md`). `c17p-import` is merged (`a2580db`).
+`redesign-b`: search (D110, head's message 24; D116, D117; plan `docs/plans/redesign-b.md`). `redesign-a` is merged
+(`e81f29c`).
 
 ## Road ahead
 
-- `redesign-a`: the owner's by-eye review (the plan's Task 9), then the merge.
-- Redesign B and C (D110): search, Settings (with Word Animation's setting) and the consent's controls; then Life
+- `redesign-b`: the owner's by-eye review (the plan's Task 7), then the merge.
+- Redesign B's rest and C (D110): Settings (with Word Animation's setting, and the gear, D116 item 5) and the
+  consent's controls; then Life
   Context, with C159-I's import, and "Made by AI". The curated set of night paintings (about 60, the founder's)
   replaces the placeholders, fingerprinted as the fonts are (a G0 and G2 change, the owner's).
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1); the pending lines are filed at
@@ -225,8 +226,9 @@ rulings given during each branch are listed in this file, one line each, under "
 - The pending lines (D57 Q11; D58 Q11): `app/assets/words/pending-lines.csv` and its fingerprint, the owner's;
   `wordsgen.py` makes `app/lib/words/pending.g.dart`, whose `PendingLine` is not a `Line` and shows its words in
   SoulDreams Dev only (any other flavour gets its handle), and G1 proves both. A row whose handle the register holds
-  stops the generator (`pending-filed`). Since C17-P none is pending: the file holds its header only, and nothing in
-  `lib/` imports `pending.g.dart` (a test in `test/words/` keeps the Dev-only rule proved on a line built there).
+  stops the generator (`pending-filed`). A pending line takes the register's slots under the register's rules, and
+  one with a slot is a function, as a filed one is (D117 Q1). Pending now: MP·66, MP·67 and MP·68, search's (D117);
+  `lib/journal/` imports `pending.g.dart`, which SoulDreams Dev alone reaches (`dev_only_test.dart`).
 - Waiting statuses (D109): "English written, Swedish to write" (W12, W13) has no line, as "to write"; the readings
   branch revisits them.
 - Design values: `Spacing.pageSide` (30) and `Spacing.journalRow` (12) are filed at C17-P and replace the stand-ins
@@ -234,11 +236,22 @@ rulings given during each branch are listed in this file, one line each, under "
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 577 tests, and 460 mutation checks (A1 to A441; A24ah,
+- Search (D110; D116; D117; `redesign-b`; TO TRY where a stand-in): the journal's field at the top (20 down, 50 tall,
+  as wide as a row; `color.field` with its border; EM·4 its placeholder; a magnifier drawn in code, silent; no clear
+  button; no autocorrect or suggestions), the sky mark still 140 down. From three characters (code points, the
+  spaces around left out): where the list starts, the count of nights (MP·66, MP·67) or MP·68, then only the
+  matching nights' rows, newest first, under their month dividers, each with a context line under it: up to three
+  words before the match (an ellipsis when words were left off), the match in Inter SemiBold, then the rest, one
+  line, the button type in `color.text.summary`. The matcher (`journal/search.dart`, `firstMatch`, one function for
+  recurring images later): each character folded by itself (Dart's own folding), marks kept, the typed characters
+  at the start of a word (D117 Q4), the told dreams in order, never a name, the first place. A result opens its
+  night with the match in SemiBold in its dream (D117 Q6), found again on each read, gone when the page goes. The
+  query is never kept or logged (R3).
+- The app's analyzer baseline: `No issues found!`. The app has 601 tests, and 489 mutation checks (A1 to A470; A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
   A313 and A375 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 460 run, 460 caught`); `check_all.sh` does not call it (D55). During a task only the
+  (expected: `app mutations: 489 run, 489 caught`); `check_all.sh` does not call it (D55). During a task only the
   rows that target the files changed are run, with `--rows A1,A7` or `--files lib/a.dart` (D95).
 
 ## The server
@@ -324,7 +337,8 @@ The owner's, in this order (D42 Q10, Q12, Q16; D44 d; D45; D71). The plan's Task
 - G1 also proves the pending lines against `pending-fingerprint.txt` and `pending.g.dart` against the generator; G2
   also proves every file in `docs/reference/screens/` against its `fingerprints.txt`; G0 knows those two
   fingerprint files by exact path (D57 Q11, D58).
-- Totals: 241 guard tests and 87 mutation checks.
+- Totals: 250 guard tests and 96 mutation checks (measured at redesign-b's start: 249 and 92; the earlier figure had
+  not followed the branches since).
 
 ## Banked
 
@@ -819,6 +833,20 @@ Banked in redesign-a (D91; none changes what the dreamer sees beyond D110; the p
 144. Shown dates now have a two-digit year (D112). MP·27 and `main-path.md` (Every Screen) say `dd/mm/yyyy`, and the
      C17-P copies stay as filed: for Product's next filing, with Part 4 item 12's list. The export is unchanged.
 
+Banked in redesign-b (D91; none changes what the dreamer sees beyond D116 and D117):
+
+145. For Product's next filing, through the head: MP·66, MP·67 and MP·68 (pending, D117); W25 unused while MP·68
+     stands (D117 Q2); "1 match" shown against C134-I item 6's "by itself, with no line" (D117 Q3); names no longer
+     searched (D116 item 1, against `main-path.md`'s "night names included"). For Interpretation, through the head:
+     the matcher's rule, the typed characters at the start of a word, against C140-I item 6's plain forms (D117 Q4).
+146. Text and query are not normalised (NFC would need a package): a letter typed composed does not match the same
+     letter stored as a letter and a mark. Keyboards and Soniox give composed letters.
+147. Dart folds each character to one (a capital I with a dot to a plain i); a folding that changed a character's
+     length would still map back to whole characters. Greek's final sigma folds as Dart folds it.
+148. Nunito has no SemiBold file: the match in a dream bubble is the phone's drawn bold of Nunito Regular (by eye in
+     the owner's review). The context line's Inter SemiBold is bundled.
+149. `opening()` (`row_text.dart`) stays unused: D116 item 3's context replaced it for search (banked item 136).
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
@@ -858,8 +886,8 @@ message 20 and built in `journal-design`, except the night's page's field in 10,
 
 Lines given and approved, shown in SoulDreams Dev only until Product registers them (D58 Q11):
 
-- None. MP·60 to MP·65 were filed at C17-P, word for word as pending (checked in `c17p-import`), and
-  `pending-lines.csv` emptied to its header.
+- MP·66, MP·67 and MP·68, search's count lines and its empty result (D110's words; D117), added by the owner in
+  `redesign-b`. MP·60 to MP·65 were filed at C17-P.
 
 ## Rulings during branch 2
 
@@ -1148,6 +1176,19 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   the light theme, `#8A8A8A` in the dark, TO TRY); 100 pt more empty space above the sky mark and the greeting (140,
   was 40).
 
+## Rulings during redesign-b
+
+- `redesign-a` merged by the owner (`e81f29c`).
+- D116 (owner, the brainstorm): (1) search covers the dreams' text in every night (no readings or Life Context
+  yet); (2) matching ignores case, Unicode-aware, and keeps letters with marks distinct; (3) the context line is a
+  short stretch around the first match, the matched characters in bold; (4) the count lines and "No matches" as
+  pending lines where the register has no place; (5) the settings gear stays out until redesign C.
+- D117 (owner, on the stop of 2026-11-21): Q1 a pending line takes the register's slots (a checks change the owner
+  applies, D60), then the owner's three pending lines; Q2 D110 governs (MP·68; W25 to Product); Q3 D110 governs
+  ("1 match" shown; C134-I item 6 to the head); Q4 the typed characters at the start of a word, one reusable
+  function, flagged to the head for Interpretation; Q5 nights are counted; Q6 the opened night's match in bold;
+  Q7 the journal while searching as leaned, no clear button; Q8 the context line as leaned.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C17-P state (`d8d71c3`), in branch `c17p-import`; the nine
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 49432702b9f34730eadfac5caf052928c013a55d..1ec801f11d936d059e2b9eac80fe80a48580a322 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A441, A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A470, A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 460 run, 460 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 489 run, 489 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
~~~~

### Task 7 · [OWNER] The by-eye review, SoulDreams Dev, invented nights only

By eye only, in SoulDreams Dev built from this branch, with invented nights typed from
`fixtures/invented-nights.json` (save at least `two-dreams-en`, `one-dream-sv` and `named-three-dreams-sv`, each
as its own night). Check each step in the light theme and, where it says so, in the dark one (after 21:00 or before
08:00). If any result differs, stop and bring it to the Build chat; nothing is fixed on the phone. The count lines
show their words in SoulDreams Dev.

1. **The field (light and dark).** At the top, a white pill (in the dark theme, a beige one with no edge) as wide as
   the rows, with a thin magnifier at its left and "Search your journal" in grey. The sun or moon, the greeting
   and New Dream are where they were. No settings gear and no clear button.
2. **Typing.** Tap the field: the keyboard's key reads Search; no word suggestions above the keys; nothing typed is
   corrected.
3. **Under three characters** (type `gl`): the journal is unchanged, with every row.
4. **From three characters** (type `glas`): under New Dream, "2 matches", then only the two Swedish nights' rows,
   newest first, under their month's divider. Under each row, one grey line: a few words, "glas" in bold, then the
   rest, cut with "…" where it runs out.
5. **Capitals and marks.** `GLAS` gives the same as `glas`. `tåg` finds the night with "tågen"; `tag` finds nothing.
6. **Start of a word only.** `citron` finds the night with "citronträd"; `träd` finds nothing.
7. **One and none.** `lighth` shows "1 match" and one row; `zzz` shows "No matches" and no row (and not the empty
   journal's line).
8. **A result opens its night.** With `nyckel` typed, tap the row: the night opens, and in its third dream "nyckel"
   is in bold (Nunito has no bold file, so the phone draws it; check it looks bold and calm). Back: the search is
   still there. Open the same night from the plain journal (clear the field): nothing is bold.
9. **Back under three characters** (delete to `ny`): the whole journal returns.
10. **Large text** (the phone's largest): the field grows to fit, and the results and context lines show no cut-off
    or overlap beyond the line's own "…".
11. **The founder's verdict, TO TRY** (P13): the field's place (20 from the top), the context line (three words
    before, its grey, 6 below the row), the count's place. Keep, or the values he wants.

## Part 4 · Questions (numbered; a blank is not a yes)

None open. D117 answered the stop's eight questions, and each is built as answered. Carried upward by the Build chat
(banked item 145): for Product, MP·66 to MP·68 to file, W25 unused, "1 match" against C134-I item 6, and names no
longer searched; for Interpretation, the matcher's start-of-word rule against C140-I item 6's plain forms.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/rb/build`, from `git archive` of `e81f29c`, each
   task's state kept as a snapshot (`./.scratch/rb/snaps/<task>`). Each block in Part 3 is `git diff --no-index`
   between two snapshots. Harness files (`.claude/`), `.dart_tool`, the app's `build/` and Python's `__pycache__` are
   left out of every snapshot.
2. **Task 2 in the build** used a stand-in pending file with the same three handles and words (sha256 `64938d82…`),
   since the owner's file is his. No block touches `pending.g.dart` after Task 1, so the owner's file changes only
   the hash in that file's header.
3. **The counts measured on the build**: app tests 577 (baseline), 577, 577, 587, 597, 601, 601, with
   `No issues found!` at each.
4. **Test first**: Tasks 3 to 5's new tests were run on the code before them and failed to load. Task 1's tests
   were run on the old generator: one failure (`test_each_row_rule_stops`) and one error (the new test). During the
   build: a test of a folding that changes length was replaced (Dart folds the capital I with a dot to one plain i,
   so the length never changes; the bookkeeping for partial characters was then dropped as dead); G4 refused several
   test names and row patterns of twelve words or more, each shortened; A451 first survived (the test had no break after
   the match; one added), and A457 first survived (the default view did not build the row that should be absent;
   those tests now run on a phone-sized view).
5. **Mutations on the build** (D95, every row of the files changed): Task 1, the generator's guard rows
   `21 run, all caught`; Task 3 `11 run, 11 caught`; Task 4 every row of `journal_page.dart` and `stand_ins.dart`
   `45 run, 45 caught` (after A322, A377, A379 followed the code); Task 5 every row of `night_page.dart`,
   `parts.dart` and `journal_page.dart` `93 run, 93 caught`; Task 6 the rows naming `dev_only_test.dart`
   `5 run, 5 caught`.
6. **The guards** on each snapshot: `guards (walk): all passed`.
7. **Replayed on a fresh copy**, `./.scratch/rb/replay`, from `git archive` of `e81f29c`: every block applied with
   `git apply` in order (with `GIT_CEILING_DIRECTORIES` set, so `git apply` is not silently skipped inside the
   repository), Task 2 done as the owner would (the stand-in file, its fingerprint, `wordsgen.py --write`), and
   after each step the tree compared with its snapshot: no difference. On the replayed tree: `guards (walk): all
   passed`, `No issues found!`, `+601: All tests passed!`, the generator's tests `Ran 39 tests`, `OK`; the 29 new and
   3 followed rows `app mutations: 32 run, 32 caught`; every guard mutation `mutations: 96 run, all caught`.
8. **Not run in the sandbox**: the full app mutation run (D95, Task 6); the guard test suite whole on a copy, where
   `test_check_all` needs the repository's own git (it passed in the repository at the start: `Ran 249 tests`,
   `OK`); `tool/check_all.sh` whole (the owner's).
9. **Not provable in the sandbox, so the owner's** (Task 7): the look on the phone in both themes; the keyboard's
   Search key and no suggestions; the drawn bold of Nunito; large text on a real phone.
10. The scratch copies (`./.scratch/rb/`) are deleted after this plan is committed.

*No matter where you are on your journey, the steps you take are equally important.*
