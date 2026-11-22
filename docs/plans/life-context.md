# Plan: Life Context, the mechanical part (life-context)

Branch `life-context`, from `main` at `79fbf6a`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D126. Written by Claude Code (Opus) on 2026-11-22. Governs: D110 (head's message 24 item 2), C159-I
item 1 and C160-I as imported, C18-P's places MP·66 to MP·97 (MP·83, MP·86 to MP·94 used here), D127 and D128 (Life
Context On after "I agree"; Off deletes; On shows MP·98 and MP·99), and the owner's D131 (the brainstorm). The
founder's screen `docs/reference/screens/life-context.png` is a reference for the look only (R1). The owner's checks
are by eye only.

`faster-mutations` is merged (`main` at `79fbf6a`); its Status was not updated at the merge (Task 6 records it).
Status.md said "The app has 690 tests"; the tree has 691, the one added by `cc2ea8c` (D126's fix of A480 and A545)
after that line was written. Explained, so not a stop; Task 6 corrects the line.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

Life Context keeps the dreamer's own sentences from everything said in a night except the dream, word for word, each
with its date and its night, on the phone only. Today a night holds only dreams, so nothing is kept from a real night
yet: this branch builds the machinery and the page, and the real sources (the opening's answers, what is said after
it, the reflection, Waking Life) plug into it when Questions and Reflection are built.

What the dreamer will see, in SoulDreams Dev:
- **Settings** gains one row under "Life Context length": "What you've told Soul Dreams" (MP·86), with a chevron.
  Before the dreamer has agreed, a tap shows the popup (MP·101), as the Life Context row does (D128 item 3).
- **The page** "What you've told Soul Dreams": back top left, "⋯" top right, the title. Then "Kept longer" (empty: its
  rule does not exist yet, D131 item 5) and "Recent – the last 2 weeks" (or the window chosen), each sentence in
  quotation marks in a white box with its date beneath in small grey, a pencil at its left and a terracotta bin at its
  right. "Delete all" at the foot. When nothing is kept, only "What you share about your waking life will appear here."
- **Edit** turns the box into a field; Done keeps the change, to the kept copy only (D131 item 2).
- **Delete**, of one sentence, of a list, of the selected or of all, asks "Are you sure…" once.
- **Tapping a sentence** opens its night.
- **Life Context Off** deletes everything kept (as D127 and D128 rule; it was built with nothing to delete).
- **Sentences older than the window** are deleted when the journal opens, when the app comes back, and at midnight
  while it is open (D131 item 4).
- **SoulDreams Dev** built with a preview file seeds invented nights and their kept sentences once, so the page can be
  seen (D131 item 1).

### What this branch builds

1. **What counts as a sentence** (`life_context/sentences.dart`, Task 1): `sentencesOf(text)`. A sentence ends at a
   run of `.`, `!`, `?` or `…`, with any closing quotes or brackets after it, followed by a space or the end; a line
   break ends one too. Each is the text between those ends exactly as written, spaces at either end left off; a piece
   with no letter or digit is no sentence. Nothing else is changed. Tested on invented passages added to
   `fixtures/invented-nights.json` (a `waking` list on five nights, each passage with the sentences it must give).
2. **Storage** (`life_context/kept.dart`, `journal/journal_store.dart`, `journal/journal.dart`, Task 2; R11;
   docs/workflow.md (c)): one new file in the journal's folder, `kept.json`, version 1: each sentence's id (128 random
   bits, on the phone only), its night's id, its day (`YYYY-MM-DD`, the phone's date when said) and its words. Written
   whole and renamed, as every file there; nothing kept means no file. Kept only into a night whose file is there.
   Deleting a night deletes its sentences first, then the night (X11: "everything made from it"); at open, sentences
   whose night's file is gone are removed (`keptOrphansSwept`). A file that does not read shows nothing kept
   (`keptFileSkipped`) and the next change replaces it. The Journal gains `keep`, `kept`, `editKept`, `deleteKept`,
   `deleteAllKept` and `sweepKept`.
3. **Life Context while the journal is open** (`life_context/life_context.dart`, Task 3): `LifeContext`, held by the
   journal's home. On is consent (b). Off: a capture keeps nothing, the page shows nothing, and the sweep deletes
   everything kept. `SettingsController.answer(lifeContext, false)` deletes what is kept (a failure logs
   `keptDeleteFailed`; the next opening's sweep deletes it). The Recent list is every kept sentence inside the window
   today, newest day first, in the order kept within a day; Kept longer is always empty. The sweep runs when the
   journal opens, on every return to the app, and at each local midnight while it is open (`keptExpired` with the
   count).
4. **The page** (`life_context/life_context_page.dart`, Settings' row, Task 4): as in plain words; the look is
   stand-ins (TO TRY): the box `color.lifecontext.box` edged with the surface's grey, words in `type.voice.dreamer`
   (`color.lifecontext.text` in the dark), date dd/mm/yy (`shownDate`) in `type.button.small` and
   `color.lifecontext.date`, delete `#8F3D24` (in the dark `#D0775A`, C18-P's proposal, `StandIns.keptDeleteDark`), the
   labels in `color.tag.dream`, the icons Flutter's own (bundled, nothing fetched). The palette gains these colours, so
   they fade with the theme. Settings' destructive pill moves to `parts.dart` (`DestructivePill`), shared with the
   page's foot.
5. **SoulDreams Dev's invented kept sentences** (D131 item 1, Task 5): `tool/preview_kept.py <file>` writes a
   `--dart-define-from-file` file carrying the invented nights that have waking passages, read from
   `fixtures/invented-nights.json`, the one place they live (R2); nothing invented is copied into the repository. A Dev
   build with it seeds the journal once (`life_context/preview.dart`; the flag file `preview-kept-seeded`), before the
   journal opens: those nights, dated 0, 5, 12, 25 and 70 days back, and their passages kept as Life Context keeps
   them, only while it is on. Deleting the journal takes the flag; the next agreement seeds again.
6. **Docs** (Task 6): Status.md; the Dev-only test covers `lib/life_context/`.

### What it does not build

- Any real source of kept words (Questions, Reflection, Waking Life), the kept-longer choice, and the readings' use of
  kept words: they wait on the Model Work worker's instructions and Interpretation's review (D110 item 2; R7).
- The mark on a tapped sentence's night (D131 item 3): a night's page shows only its dreams, and nothing kept is ever
  from a dream, so there is nothing to put in Bold yet. It comes with the part of the page that shows the sentence.
- Anything sent anywhere: no server, Soniox, AWS, package, Swift, settings or guard change. Every file of this branch
  is reached from SoulDreams Dev only (`dev_only_test.dart`).

### The decisions, by number

- D110 (head's message 24 item 2), C159-I item 1, C18-P: the page, its lists, controls and empty line; Off keeps
  nothing and deletes what is kept.
- D127, D128: Life Context On after "I agree"; Off deletes (MP·93); On shows MP·98 and MP·99 (as built in
  `redesign-c`); before agreeing, the popup.
- D131 (owner, the brainstorm): (1) a Dev-only set of invented kept sentences; (2) editing changes only the kept copy;
  (3) the marked sentence in Bold, as search's; (4) expiry at launch and once a day while open; (5) "Kept longer"
  shows its heading and stays empty.
- D91, D126 (targeted rows only during the tasks; the full run once, before the merge), D67 (a row whose code moved
  follows it).

### Decided under D91 (how to build only)

1. **One file, `kept.json`**, rather than one per night: the page, edits, the sweep and Off each read or write it
   whole, in one turn of the store's queue.
2. **A sentence's date is the day it was said** (the phone's date then), stored with it; the window counts by it. A
   reflection said the morning after keeps that morning's date.
3. **Deleting a night deletes its kept sentences** (X11; docs/workflow.md (d)), first, so a delete cut short leaves no
   sentence of a deleted night; and the next opening removes any it did leave.
4. **An unreadable `kept.json`** is shown as nothing kept, logged, and replaced by the next change; a sweep that
   removes nothing leaves it as it is.
5. **No abbreviation list** in what counts as a sentence ("Dr." ends one): any list would be words on a check list
   (R1) and language-bound; banked (item 168).
6. **The window by the calendar**: today less 7 or 14 days, or 1 or 3 months (the day held to the month's end); a
   sentence is in it while its date is later. The page shows only what is in the window, so a shorter length shows at
   once, and the sweep deletes the rest at its next run.
7. **The sweep also runs on every return to the app** (D131 item 4's "once a day while open": an app away for days
   cannot know a day passed otherwise; a sweep deletes only what is already past the window).
8. **"Delete the Recent list"** deletes the sentences on that list; "Delete all" deletes everything kept.
9. **No field for Kept longer in the file**: the format may change freely until it reaches the founder app (D49, O5),
   and Life Context is Dev only; the kept-longer branch adds what its rule needs.
10. **The Dev seed** comes through `--dart-define-from-file`, written from the fixture by `tool/preview_kept.py`,
    because an app cannot read `fixtures/` and R2 keeps every invented line in that one file.
11. **One existing assertion changed** to follow D121 item 2 ("What you've told Soul Dreams" arrives with Life
    Context): `settings_page_test.dart` expected MP·86 absent; it now expects its row between the six and the actions
    (and the test's name says so; A570 follows). `journal_home_test.dart`'s entry-point text test follows
    `main_dev.dart`'s new argument (A341 follows).
12. **A row dropped before it was added**: the seed's own Life Context gate seen from the journal's home survives any
    test there, since the opening's sweep deletes everything kept while Off (banked item 168). `preview_test.dart`'s
    A744 holds the gate itself.

### The places this branch uses

All filed (C18-P), none new, no pending line: MP·86 (the row and the title), MP·87 (the labels: its first part, and
the part for the window), MP·88 (the menu), MP·89 (the icons' spoken names), MP·90, MP·91, MP·92; C4-P·4 with MP·60
and MP·61; MP·93 and MP·94 as built; MP·101 and MP·102 (pending lines, as built). No word is owed: Done is the phone
keyboard's own, and the selection's way out is the back control.

The founder's screen shows sample sentences; none is quoted or used here (R2). Every sentence in the code, tests and
this plan comes from `fixtures/invented-nights.json`.

### The tests (test-first, on the Mac)

Each task's new and changed test files were put on the tree before it and failed (loading or asserting), but two
that pin what their own block brings: Task 1's fixture check (the fixture is in the block) and Task 6's Dev-only
assertions; their rows bite (Part 5).

App tests: 691 at the start, then 697, 719, 729, 744, 749, 749.

App mutation rows (624 to 713):
- **New:** 89, A665 to A753.
- **Following their code** (D67): A341, A568, A570, A658.
- **None dropped.**

One guard test added, `tool/checks/tests/test_preview_kept.py`. No guard changed. The by-eye review is the owner's
(Task 7).

## Part 2 · Settings, packages and storage

- **Packages and settings:** none. No Swift, server, AWS, Soniox or guard change. Two new files in `tool/`:
  `tool/preview_kept.py` (Python, a kind G0 knows) and its test.
- **Storage** (R11; docs/workflow.md (c)): one new file in the journal's folder, `kept.json`, and in a Dev build made
  with the preview the empty flag `preview-kept-seeded`. No existing file's format changes.
  - **Step 1 is Task 2's test** "keeping and deleting sentences leaves every other file byte for byte": a folder
    holding the invented nights, a waiting recording's audio, the first-use flag, the consents and the settings keeps
    every one of them byte for byte while sentences are kept, edited, deleted and swept, and loses nothing when they
    all go.
  - **Step 2** is the owner's rehearsal in SoulDreams Dev (Task 7, item 1).
  - **Steps 3 to 5** apply when the founder app gains Life Context. Until then nothing of this reaches the Cohort 0
    app (`dev_only_test.dart`).
- **Deletion is the feature** (docs/workflow.md (d)): Off, Delete all, a list, the selected, one sentence, a night
  and the journal each leave nothing of what they delete (Tasks 2 to 4 test each).

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, generated from the build that proved it (Part 5). Apply it
from the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit
through the hook with the message given.

Every task ends green:
- `cd app && fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub` passes at the
  count given.
- The task's rows (D126): `python3 -I -B tool/app_mutations.py --rows <the task's rows>`, every one caught.
- The hook prints `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `life-context`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- nothing from `git status`;
- this plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+691: All tests passed!`.

Anything else: stop (R14).

### Task 1 · What counts as a sentence (C159-I item 1; D131)

`sentencesOf` in `life_context/sentences.dart`, nothing calling it yet; the invented passages (`waking`) on five
nights in `fixtures/invented-nights.json`, each with the sentences it must give; `test/fixtures.dart` reads them.

Tests: `test/life_context/sentences_test.dart` (5, new: each passage gives exactly its sentences; each sentence is the
passage's own text in order; a line break ends one, spaces go; nothing, spaces or marks alone hold none; a mark with no
space after it ends nothing), `test/fixtures_test.dart` (1 new). 691 → 697.

Rows: A665 to A671.

```
diff --git a/app/lib/life_context/sentences.dart b/app/lib/life_context/sentences.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/life_context/sentences.dart
@@ -0,0 +1,35 @@
+// What Life Context keeps from the dreamer's own words (C159-I item 1;
+// D110; D131): the sentences of a piece of text, word for word. Plain Dart,
+// no screen. Nothing calls it yet: a night holds only dreams, and nothing
+// from a dream is ever kept; its sources come with Questions and Reflection.
+//
+// A sentence ends at a run of `.`, `!`, `?` or `…`, with any closing quotes
+// or brackets after it, followed by a space or the text's end; a line break
+// ends one too. Each sentence is the text between those ends exactly as
+// written, its spaces at either end left off; a piece with no letter or
+// digit in it (a lone ellipsis) is no sentence. Nothing else changes: no
+// case, spelling or punctuation, and no list of abbreviations, so "Dr."
+// ends one (decided under D91; Part 1).
+
+final _end = RegExp(r'''[.!?…]+[”’"')\]»]*(?=\s|$)''');
+final _break = RegExp('\r\n|[\n\r\u0085\u2028\u2029]'); // not-dreamer-facing: the line breaks
+final _letter = RegExp(r'[\p{L}\p{N}]', unicode: true);
+
+/// The sentences of [text], in order, each word for word.
+List<String> sentencesOf(String text) {
+  final out = <String>[];
+  void add(String piece) {
+    final s = piece.trim();
+    if (_letter.hasMatch(s)) out.add(s);
+  }
+
+  for (final line in text.split(_break)) {
+    var start = 0;
+    for (final m in _end.allMatches(line)) {
+      add(line.substring(start, m.end));
+      start = m.end;
+    }
+    add(line.substring(start));
+  }
+  return out;
+}
diff --git a/app/test/fixtures.dart b/app/test/fixtures.dart
--- a/app/test/fixtures.dart
+++ b/app/test/fixtures.dart
@@ -9,7 +9,7 @@ import 'package:souldreams/words/lines.g.dart' show Lang;
 
 /// One invented night, as the fixture file holds it.
 final class InventedNight {
-  const InventedNight(this.key, this.lang, this.name, this.dreams, [this.heard = const []]);
+  const InventedNight(this.key, this.lang, this.name, this.dreams, [this.heard = const [], this.waking = const []]);
 
   final String key;
   final String lang;
@@ -19,8 +19,16 @@ final class InventedNight {
   /// Recordings of this night as Soniox sends them: each a list of
   /// sub-word pieces, spaces inside them (D73). Only some nights have them.
   final List<List<String>> heard;
+
+  /// What the dreamer wrote or said in this night outside the dream (Life
+  /// Context, C159-I item 1): each passage, and the sentences it holds, word
+  /// for word. Only some nights have them.
+  final List<Waking> waking;
 }
 
+/// One passage of a night outside the dream, and its sentences.
+typedef Waking = ({String text, List<String> sentences});
+
 /// Every invented night, in the file's order.
 List<InventedNight> inventedNights() {
   final json = jsonDecode(File('../fixtures/invented-nights.json').readAsStringSync());
@@ -29,6 +37,10 @@ List<InventedNight> inventedNights() {
       if (n case {'key': String key, 'lang': String lang, 'dreams': List<Object?> dreams})
         InventedNight(key, lang, (n as Map)['name'] as String?, dreams.cast<String>(), [
           for (final h in (n['heard'] as List<Object?>?) ?? const []) (h as List<Object?>).cast<String>(),
+        ], [
+          for (final w in (n['waking'] as List<Object?>?) ?? const [])
+            if (w case {'text': String text, 'sentences': List<Object?> sentences})
+              (text: text, sentences: sentences.cast<String>()),
         ]),
   ];
 }
diff --git a/app/test/fixtures_test.dart b/app/test/fixtures_test.dart
--- a/app/test/fixtures_test.dart
+++ b/app/test/fixtures_test.dart
@@ -41,4 +41,20 @@ void main() {
     // The second recording has a piece with no space in front, after others.
     expect(heard[1].skip(1).any((p) => !p.startsWith(' ')), isTrue);
   });
+
+  test('the waking passages: both languages, each with its sentences', () {
+    final json = jsonDecode(File('../fixtures/invented-nights.json').readAsStringSync());
+    final raw = [
+      for (final n in (json as Map<String, Object?>)['nights'] as List<Object?>)
+        ...((n as Map<String, Object?>)['waking'] as List<Object?>? ?? const []),
+    ];
+    final waking = [for (final n in inventedNights()) ...n.waking];
+    expect(waking, hasLength(raw.length));
+    expect(waking, isNotEmpty);
+    expect({for (final n in inventedNights()) if (n.waking.isNotEmpty) n.lang}, {'en', 'sv'});
+    for (final w in waking) {
+      expect(w.text.trim(), isNotEmpty);
+      expect(w.sentences, isNotEmpty);
+    }
+  });
 }
diff --git a/app/test/life_context/sentences_test.dart b/app/test/life_context/sentences_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/life_context/sentences_test.dart
@@ -0,0 +1,46 @@
+// What counts as a sentence (C159-I item 1; D110; D131): each invented
+// passage's sentences, word for word (fixtures/invented-nights.json, R2).
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/life_context/sentences.dart';
+
+import '../fixtures.dart';
+
+void main() {
+  final waking = [for (final n in inventedNights()) ...n.waking];
+
+  test('each invented passage gives exactly its sentences, in order', () {
+    for (final w in waking) {
+      expect(sentencesOf(w.text), w.sentences, reason: w.text);
+    }
+  });
+
+  test("every sentence is the passage's own text, word for word", () {
+    for (final w in waking) {
+      var from = 0;
+      for (final s in sentencesOf(w.text)) {
+        final at = w.text.indexOf(s, from);
+        expect(at, greaterThanOrEqualTo(0), reason: s);
+        from = at + s.length;
+      }
+    }
+  });
+
+  test('a line break ends a sentence; spaces at either end go', () {
+    final w = invented('framed-opening-en').waking.single;
+    expect(w.text, contains('\n'));
+    expect(sentencesOf(w.text), hasLength(2));
+    expect(sentencesOf(w.text).every((s) => s == s.trim()), isTrue);
+  });
+
+  test('nothing, spaces or marks alone hold no sentence', () {
+    expect(sentencesOf(''), isEmpty);
+    expect(sentencesOf('  \n \t '), isEmpty);
+    expect(sentencesOf('... ?! …'), isEmpty);
+    expect(sentencesOf('​'), isEmpty);
+  });
+
+  test('a mark with no space after it ends nothing', () {
+    expect(sentencesOf('2.5'), ['2.5']);
+    expect(sentencesOf('a.b c'), ['a.b c']);
+  });
+}
diff --git a/fixtures/invented-nights.json b/fixtures/invented-nights.json
--- a/fixtures/invented-nights.json
+++ b/fixtures/invented-nights.json
@@ -4,6 +4,22 @@
     {
       "key": "two-dreams-en",
       "lang": "en",
+      "waking": [
+        {
+          "text": "I started a new job at the library this week. My sister moved to Lisbon in October!",
+          "sentences": [
+            "I started a new job at the library this week.",
+            "My sister moved to Lisbon in October!"
+          ]
+        },
+        {
+          "text": "We painted the kitchen green last weekend... It still smells of paint.",
+          "sentences": [
+            "We painted the kitchen green last weekend...",
+            "It still smells of paint."
+          ]
+        }
+      ],
       "heard": [
         ["The", " light", "house", " was", " dark", "."],
         ["I", " was", " there", " a", "gain", "."]
@@ -16,6 +32,15 @@
     {
       "key": "framed-opening-en",
       "lang": "en",
+      "waking": [
+        {
+          "text": "I have been walking to work since the bus route changed\nThe mornings are colder now.  ",
+          "sentences": [
+            "I have been walking to work since the bus route changed",
+            "The mornings are colder now."
+          ]
+        }
+      ],
       "dreams": [
         "I had a dream that a paper boat carried me down a staircase of water inside an old library."
       ]
@@ -23,6 +48,15 @@
     {
       "key": "one-dream-sv",
       "lang": "sv",
+      "waking": [
+        {
+          "text": "Vi flyttade till en ny lägenhet i september. Jag har börjat sjunga i en kör!",
+          "sentences": [
+            "Vi flyttade till en ny lägenhet i september.",
+            "Jag har börjat sjunga i en kör!"
+          ]
+        }
+      ],
       "dreams": [
         "Jag stod på en perrong där tågen var gjorda av glas, och varje vagn var full av små citronträd."
       ]
@@ -30,6 +64,15 @@
     {
       "key": "named-three-dreams-sv",
       "lang": "sv",
+      "waking": [
+        {
+          "text": "Har jag berättat att vi fick en hund? Hon heter Selma.",
+          "sentences": [
+            "Har jag berättat att vi fick en hund?",
+            "Hon heter Selma."
+          ]
+        }
+      ],
       "name": "Glastrappan",
       "dreams": [
         "En trappa av glas gick upp genom molnen.",
@@ -40,6 +83,20 @@
     {
       "key": "long-dream-en",
       "lang": "en",
+      "waking": [
+        {
+          "text": "The exam is on Friday. Dr. Lind said it would be short. “It is only an hour.” she told us. Prices went up 2.5 percent?! ... I keep forgetting my keys",
+          "sentences": [
+            "The exam is on Friday.",
+            "Dr.",
+            "Lind said it would be short.",
+            "“It is only an hour.”",
+            "she told us.",
+            "Prices went up 2.5 percent?!",
+            "I keep forgetting my keys"
+          ]
+        }
+      ],
       "dreams": [
         "A copper bell hung from the branch of an orange tree, and every time the wind moved it the oranges changed colour, first to blue, then to grey, then back again. I climbed the tree to stop the bell, but the branches kept growing longer under my hands, so the bell was always one arm away. Below me a crowd of tortoises carried lanterns across a frozen river, and none of them looked up."
       ]
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2706,6 +2706,34 @@ ROWS = [
      '                    ...end,\n',
      '',
      'test/settings/settings_page_test.dart', 'before agreeing: the disclosure ends with I agree'),
+    ('A665', 'lib/life_context/sentences.dart',
+     '    if (_letter.hasMatch(s)) out.add(s);',
+     '    if (s.isNotEmpty) out.add(s);',
+     'test/life_context/sentences_test.dart', 'nothing, spaces or marks alone hold no sentence'),
+    ('A666', 'lib/life_context/sentences.dart',
+     '    final s = piece.trim();',
+     '    final s = piece;',
+     'test/life_context/sentences_test.dart', 'each invented passage gives exactly its sentences, in order'),
+    ('A667', 'lib/life_context/sentences.dart',
+     '  for (final line in text.split(_break)) {',
+     '  for (final line in [text]) {',
+     'test/life_context/sentences_test.dart', 'a line break ends a sentence; spaces at either end go'),
+    ('A668', 'lib/life_context/sentences.dart',
+     "*(?=\\s|$)''');",
+     "*''');",
+     'test/life_context/sentences_test.dart', 'a mark with no space after it ends nothing'),
+    ('A669', 'lib/life_context/sentences.dart',
+     '[.!?…]+[”’"\')\\]»]*',
+     '[.!?…]+',
+     'test/life_context/sentences_test.dart', 'each invented passage gives exactly its sentences, in order'),
+    ('A670', 'lib/life_context/sentences.dart',
+     "r'''[.!?…]+",
+     "r'''[.]+",
+     'test/life_context/sentences_test.dart', 'each invented passage gives exactly its sentences, in order'),
+    ('A671', 'lib/life_context/sentences.dart',
+     '      start = m.end;\n',
+     '',
+     'test/life_context/sentences_test.dart', "every sentence is the passage's own text, word for word"),
 ]
 
 
```

Commit message:

```
Life Context: what counts as a sentence, kept word for word, on invented passages (C159-I item 1; D131)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
```

### Task 2 · Storage: the kept sentences in the journal's folder (R11; docs/workflow.md (c); X11)

`life_context/kept.dart` (the sentence, its file version 1, the window, newest first); `JournalStore`: `keptFile`,
`kept`, `addKept`, `changeKept`, `deleteKept`, a night's delete taking its sentences first, the sweep of orphans at
open; `Journal`: `keep`, `kept`, `editKept`, `deleteKept`, `deleteAllKept`, `sweepKept`; five codes in `SafeLog`.

Tests: `test/life_context/kept_test.dart` (7, new), `test/life_context/kept_store_test.dart` (15, new; among them
workflow (c)'s step 1, "keeping and deleting sentences leaves every other file byte for byte"). 697 → 719.

Rows: A672 to A695. Then every row of the changed files: `--files lib/journal/journal_store.dart,lib/journal/journal.dart,lib/core/safe_log.dart,lib/life_context/kept.dart,lib/life_context/sentences.dart`
(70 run, 70 caught on the build).

```
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -100,6 +100,17 @@ enum LogEvent {
   retryDone,
   retryCut,
   retryFailed,
+
+  /// Life Context (C159-I item 1; D131): the kept file did not read, so
+  /// nothing kept is shown and the next change replaces it; at open,
+  /// sentences whose night is gone removed (X11), with how many; at the
+  /// Recent window's sweep, sentences past it removed, with how many; a
+  /// change to what is kept, or its deletion, that could not be done.
+  keptFileSkipped,
+  keptOrphansSwept,
+  keptExpired,
+  keptKeepFailed,
+  keptDeleteFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -13,10 +13,17 @@
 //   index counts both, and a waiting one is never edited. A Save puts the
 //   recordings its screen left waiting after its words, in order; a Save
 //   with nothing typed but a recording waiting keeps it (D93 Q7).
+// - Life Context's kept sentences (C159-I item 1; D131): kept from a piece
+//   of the dreamer's words said in a night, sentence by sentence, each with
+//   the day it was said; edited (only the kept copy, D131 item 2), deleted
+//   one by one, several, or all; and swept when past the Recent window.
+//   Whether Life Context is on is decided above (`LifeContext`), not here.
 import 'dart:math';
 
 import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier, listEquals;
 
+import '../life_context/kept.dart';
+import '../life_context/sentences.dart';
 import '../settings/consents.dart';
 import '../settings/settings.dart';
 import '../words/lines.g.dart' show Lang;
@@ -135,6 +142,46 @@ final class Journal {
   /// Keeps the settings (D122).
   Future<void> keepSettings(Settings settings) => _store.keepSettings(settings);
 
+  /// The kept sentences, in the order kept.
+  Future<List<Kept>> kept() => _store.kept();
+
+  /// Keeps the sentences of [text], said now in night [night], word for
+  /// word. Returns how many were kept: none when that night is gone.
+  Future<int> keep(String night, String text) async {
+    final day = dateOf(_now(), zone);
+    final add = [for (final s in sentencesOf(text)) Kept(id: newKeptId(random), night: night, day: day, text: s)];
+    return await _store.addKept(night, add) ? add.length : 0;
+  }
+
+  /// Replaces kept sentence [id]'s words with [text]; nothing but spaces
+  /// deletes it. The night's own text never changes (D131 item 2).
+  Future<void> editKept(String id, String text) => _store.changeKept(
+    (kept) => [
+      for (final k in kept)
+        if (k.id != id) k else if (!isEmptyText(text)) k.withText(text.trim()),
+    ],
+  );
+
+  /// Deletes the kept sentences [ids].
+  Future<void> deleteKept(Set<String> ids) =>
+      _store.changeKept((kept) => [for (final k in kept) if (!ids.contains(k.id)) k]);
+
+  /// Deletes every kept sentence.
+  Future<void> deleteAllKept() => _store.deleteKept();
+
+  /// Deletes the kept sentences past the Recent window of [length] today.
+  /// Returns how many went.
+  Future<int> sweepKept(LifeContextLength length) async {
+    final today = dateOf(_now(), zone);
+    var gone = 0;
+    await _store.changeKept((kept) {
+      final rest = [for (final k in kept) if (inWindow(k, today, length)) k];
+      gone = kept.length - rest.length;
+      return rest;
+    });
+    return gone;
+  }
+
   /// Moves on each time the journal is deleted, the consents with it: the
   /// app returns to its start (D110).
   ValueListenable<int> get consentGone => _consentGone;
diff --git a/app/lib/journal/journal_store.dart b/app/lib/journal/journal_store.dart
--- a/app/lib/journal/journal_store.dart
+++ b/app/lib/journal/journal_store.dart
@@ -26,12 +26,21 @@
 // age band (C146-I item 1) (`settings/consents.dart`). So are the settings
 // (`settings/settings.dart`). Deleting the journal takes both, and returns
 // the app to its start; there is no withdrawing (D128).
+//
+// Life Context's kept sentences (C159-I item 1; D131) are one more file
+// here, written whole and renamed (`life_context/kept.dart`); keeping
+// nothing removes it. A sentence is kept only into a night whose file is
+// here. Deleting a night deletes its sentences first, then the night (X11:
+// everything made from it); at open, sentences whose night's file is gone
+// are removed. A kept file that does not read is shown as nothing kept and
+// replaced by the next change.
 import 'dart:convert';
 import 'dart:typed_data';
 
-import 'package:flutter/foundation.dart' show visibleForTesting;
+import 'package:flutter/foundation.dart' show listEquals, visibleForTesting;
 
 import '../core/safe_log.dart';
+import '../life_context/kept.dart';
 import '../settings/consents.dart';
 import '../settings/settings.dart';
 import 'journal_files.dart';
@@ -66,6 +75,10 @@ final class JournalStore {
   /// The settings, once one is changed (D122); removed with the journal.
   static const settingsFile = 'settings.json';
 
+  /// Life Context's kept sentences, while any is kept (C159-I item 1);
+  /// removed with the journal.
+  static const keptFile = 'kept.json';
+
   // The one queue (D54): each operation starts when the one before it,
   // whether it succeeded or failed, has finished. No operation calls
   // another queued one.
@@ -123,9 +136,23 @@ final class JournalStore {
         SafeLog.event(LogEvent.audioSwept);
       }
     }
-    return JournalStore._(files);
+    final store = JournalStore._(files);
+    await store._sweepKept({for (final name in names) ?_nightFile.firstMatch(name)?[1]});
+    return store;
   });
 
+  // Removes the kept sentences of nights whose file is gone (X11), as a
+  // night's delete cut short would leave them.
+  Future<void> _sweepKept(Set<String> nights) async {
+    final bytes = await _files.read(keptFile);
+    final kept = bytes == null ? null : decodeKept(bytes);
+    if (kept == null) return;
+    final rest = [for (final k in kept) if (nights.contains(k.night)) k];
+    if (rest.length == kept.length) return;
+    await _writeKept(rest);
+    SafeLog.event(LogEvent.keptOrphansSwept, [kept.length - rest.length]);
+  }
+
   // The recordings a night's file names, read from its bytes whether or
   // not it reads as a night, so a damaged night's audio is never swept.
   static Set<String> _namedIn(Uint8List bytes) =>
@@ -208,6 +235,9 @@ final class JournalStore {
 
   Future<void> _delete(String id) async {
     final name = fileOf(id);
+    final kept = await _readKept();
+    final rest = [for (final k in kept) if (k.night != id) k];
+    if (rest.length != kept.length) await _writeKept(rest);
     final bytes = await _files.read(name);
     await _files.delete(name);
     await _files.delete(tempPrefix + name);
@@ -338,4 +368,44 @@ final class JournalStore {
 
   /// Keeps the settings whole, replacing any before.
   Future<void> keepSettings(Settings settings) => _run(() => _whole(settingsFile, encodeSettings(settings)));
+
+  // The kept sentences: none when there is no file; one that does not read
+  // logs a code and reads as none.
+  Future<List<Kept>> _readKept() async {
+    final bytes = await _files.read(keptFile);
+    if (bytes == null) return const [];
+    final kept = decodeKept(bytes);
+    if (kept == null) SafeLog.event(LogEvent.keptFileSkipped);
+    return kept ?? const [];
+  }
+
+  // Keeps [kept] whole; nothing kept removes the file.
+  Future<void> _writeKept(List<Kept> kept) async {
+    if (kept.isNotEmpty) return _whole(keptFile, encodeKept(kept));
+    await _files.delete(keptFile);
+    await _files.delete(tempPrefix + keptFile);
+  }
+
+  /// The kept sentences, in the order kept.
+  Future<List<Kept>> kept() => _run(_readKept);
+
+  /// Adds [kept], said in night [night], when that night's file is here.
+  /// Returns whether it was.
+  Future<bool> addKept(String night, List<Kept> kept) => _run(() async {
+    if (await _files.size(fileOf(night)) == null) return false;
+    if (kept.isNotEmpty) await _writeKept([...await _readKept(), ...kept]);
+    return true;
+  });
+
+  /// Reads the kept sentences and writes back what [change] makes of them,
+  /// all in one turn of the queue; no change writes nothing. [change] must
+  /// not wait.
+  Future<void> changeKept(List<Kept> Function(List<Kept> kept) change) => _run(() async {
+    final before = await _readKept();
+    final after = change(before);
+    if (!listEquals(after, before)) await _writeKept(after);
+  });
+
+  /// Deletes every kept sentence: the file, and any temporary file of it.
+  Future<void> deleteKept() => _run(() => _writeKept(const []));
 }
diff --git a/app/lib/life_context/kept.dart b/app/lib/life_context/kept.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/life_context/kept.dart
@@ -0,0 +1,164 @@
+// What Life Context keeps (C159-I item 1; D110; D131), in plain Dart, and
+// its file format: each kept sentence word for word, with the day it was
+// said (the phone's date then) and the night it was said in, under an id of
+// its own that names it on the phone only and is never sent (R4). The app
+// writes nothing else into it: no summary, theme, label or flag. Kept on the
+// phone only, in the journal's folder (R11; docs/workflow.md (c)), as one
+// file, version 1 (`JournalStore.keptFile`).
+//
+// The Recent window (MP·84, 2 weeks by default): a sentence is in it while
+// its day is later than the cutoff, today less the length (a week, two
+// weeks, or one or three months by the calendar, the day held to the
+// month's end). Older ones go at launch and once a day while the app is
+// open (D131 item 4). The Kept longer list has no rule yet and stays empty
+// (D131 item 5), so nothing here marks a sentence for it.
+import 'dart:convert';
+import 'dart:math';
+import 'dart:typed_data';
+
+import '../journal/night.dart';
+import '../journal/night_rules.dart' show isEmptyText;
+import '../settings/settings.dart';
+
+final _id = RegExp(r'^[0-9a-f]{32}$');
+final _day = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
+
+/// The file format's version.
+const keptVersion = 1;
+
+bool _isDay(NightDate d) {
+  if (d.year < 0 || d.year > 9999) return false;
+  final c = DateTime.utc(d.year, d.month, d.day);
+  return c.year == d.year && c.month == d.month && c.day == d.day;
+}
+
+/// One kept sentence.
+final class Kept {
+  Kept({required this.id, required this.night, required this.day, required this.text}) {
+    if (!_id.hasMatch(id)) throw ArgumentError('id');
+    if (!_id.hasMatch(night)) throw ArgumentError('night');
+    if (!_isDay(day)) throw ArgumentError('day');
+    if (isEmptyText(text)) throw ArgumentError('text');
+  }
+
+  final String id;
+
+  /// The id of the night it was said in.
+  final String night;
+
+  /// The phone's date when it was said.
+  final NightDate day;
+
+  /// The dreamer's own words.
+  final String text;
+
+  /// The same sentence with the dreamer's edit: only this copy changes,
+  /// never the night's text (D131 item 2).
+  Kept withText(String text) => Kept(id: id, night: night, day: day, text: text);
+
+  @override
+  bool operator ==(Object other) =>
+      other is Kept && other.id == id && other.night == night && other.day == day && other.text == text;
+
+  @override
+  int get hashCode => Object.hash(id, night, day, text);
+}
+
+/// A new kept sentence's id: 128 bits from the system's secure source.
+String newKeptId([Random? random]) => newNightId(random);
+
+String _two(int n) => n.toString().padLeft(2, '0');
+
+String _dayText(NightDate d) => '${d.year.toString().padLeft(4, '0')}-${_two(d.month)}-${_two(d.day)}';
+
+/// The file's bytes: version 1, the sentences in the order they were kept.
+Uint8List encodeKept(List<Kept> kept) => utf8.encode(
+  jsonEncode({
+    'version': keptVersion,
+    'sentences': [
+      for (final k in kept) {'id': k.id, 'night': k.night, 'day': _dayText(k.day), 'text': k.text},
+    ],
+  }),
+);
+
+/// The sentences [bytes] hold, or null when they do not read as version 1
+/// exactly.
+List<Kept>? decodeKept(Uint8List bytes) {
+  final Object? json;
+  try {
+    json = jsonDecode(utf8.decode(bytes));
+  } on FormatException {
+    return null;
+  }
+  if (json is! Map<String, dynamic> || json.length != 2 || json['version'] != keptVersion) return null;
+  final list = json['sentences'];
+  if (list is! List) return null;
+  final out = <Kept>[];
+  final ids = <String>{};
+  for (final s in list) {
+    if (s is! Map<String, dynamic> || s.length != 4) return null;
+    final id = s['id'];
+    final night = s['night'];
+    final day = s['day'];
+    final text = s['text'];
+    if (id is! String || night is! String || day is! String || text is! String) return null;
+    final m = _day.firstMatch(day);
+    if (m == null) return null;
+    try {
+      out.add(
+        Kept(
+          id: id,
+          night: night,
+          day: (year: int.parse(m[1]!), month: int.parse(m[2]!), day: int.parse(m[3]!)),
+          text: text,
+        ),
+      );
+    } on ArgumentError {
+      return null;
+    }
+    if (!ids.add(id)) return null;
+  }
+  return out;
+}
+
+/// The last day outside the Recent window of [length] on [today].
+NightDate cutoffOf(NightDate today, LifeContextLength length) {
+  NightDate days(int n) {
+    final d = DateTime.utc(today.year, today.month, today.day - n);
+    return (year: d.year, month: d.month, day: d.day);
+  }
+
+  NightDate months(int n) {
+    var y = today.year;
+    var m = today.month - n;
+    while (m < 1) {
+      m += 12;
+      y--;
+    }
+    final last = DateTime.utc(y, m + 1, 0).day;
+    return (year: y, month: m, day: min(today.day, last));
+  }
+
+  return switch (length) {
+    LifeContextLength.oneWeek => days(7),
+    LifeContextLength.twoWeeks => days(14),
+    LifeContextLength.oneMonth => months(1),
+    LifeContextLength.threeMonths => months(3),
+  };
+}
+
+int _compare(NightDate a, NightDate b) =>
+    a.year != b.year ? a.year - b.year : (a.month != b.month ? a.month - b.month : a.day - b.day);
+
+/// Whether [kept] is inside the Recent window of [length] on [today].
+bool inWindow(Kept kept, NightDate today, LifeContextLength length) => _compare(kept.day, cutoffOf(today, length)) > 0;
+
+/// Newest day first; within a day, in the order kept.
+List<Kept> newestFirst(List<Kept> kept) {
+  final indexed = [for (final (i, k) in kept.indexed) (i, k)];
+  indexed.sort((a, b) {
+    final c = _compare(b.$2.day, a.$2.day);
+    return c != 0 ? c : a.$1 - b.$1;
+  });
+  return [for (final (_, k) in indexed) k];
+}
diff --git a/app/test/life_context/kept_store_test.dart b/app/test/life_context/kept_store_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/life_context/kept_store_test.dart
@@ -0,0 +1,223 @@
+// Life Context's kept sentences in the journal's folder (C159-I item 1;
+// D131; R11; docs/workflow.md (c)): one file, written whole; kept only into
+// a night that is there; deleted with their night (X11) and with the
+// journal; an unreadable file shown as nothing and replaced; every other
+// file of the folder untouched, byte for byte.
+import 'dart:convert';
+import 'dart:math';
+import 'dart:typed_data';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/night_day.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+import '../journal/zones.dart';
+
+void main() {
+  late MemoryJournalFiles files;
+  late DateTime now;
+  final lines = <String>[];
+  final sink = SafeLog.sink;
+  final passages = [for (final n in inventedNights()) ...n.waking];
+
+  setUp(() {
+    files = MemoryJournalFiles();
+    now = DateTime.utc(2026, 11, 22, 9);
+    lines.clear();
+    SafeLog.sink = lines.add;
+  });
+
+  tearDown(() => SafeLog.sink = sink);
+
+  Future<(JournalStore, Journal, List<Night>)> open() async {
+    final store = await JournalStore.open(files);
+    final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(7));
+    final nights = nightsFromFixtures();
+    for (final n in nights) {
+      await store.save(n);
+    }
+    return (store, journal, nights);
+  }
+
+  test("each sentence kept word for word, with its date and night", () async {
+    final (_, journal, nights) = await open();
+    final w = passages.first;
+    expect(await journal.keep(nights.first.id, w.text), w.sentences.length);
+    final kept = await journal.kept();
+    expect([for (final k in kept) k.text], w.sentences);
+    expect(kept.every((k) => k.night == nights.first.id), isTrue);
+    expect(kept.every((k) => k.day == (year: 2026, month: 11, day: 22)), isTrue);
+    expect(kept.map((k) => k.id).toSet(), hasLength(kept.length));
+    expect(files.files.keys.where((n) => n.startsWith('kept')), [JournalStore.keptFile]);
+  });
+
+  test("the day is the phone's date when it was said", () async {
+    final (_, journal, nights) = await open();
+    now = DateTime.utc(2026, 11, 22, 23, 30);
+    await journal.keep(nights.first.id, passages.first.text);
+    expect((await journal.kept()).first.day, (year: 2026, month: 11, day: 23));
+  });
+
+  test('more sentences follow those kept before, in order', () async {
+    final (_, journal, nights) = await open();
+    await journal.keep(nights.first.id, passages[0].text);
+    await journal.keep(nights[1].id, passages[1].text);
+    expect([for (final k in await journal.kept()) k.text], [...passages[0].sentences, ...passages[1].sentences]);
+  });
+
+  test('nothing is kept into a night that is not there', () async {
+    final (_, journal, _) = await open();
+    expect(await journal.keep(newNightId(Random(99)), passages.first.text), 0);
+    expect(await journal.kept(), isEmpty);
+    expect(files.files.containsKey(JournalStore.keptFile), isFalse);
+  });
+
+  test('deleting every kept sentence leaves no file of them', () async {
+    final (_, journal, nights) = await open();
+    await journal.keep(nights.first.id, passages.first.text);
+    files.files['${JournalStore.tempPrefix}${JournalStore.keptFile}'] = Uint8List(1);
+    await journal.deleteAllKept();
+    expect(files.files.keys.where((n) => n.contains('kept')), isEmpty);
+    expect(await journal.kept(), isEmpty);
+  });
+
+  test("deleting a night deletes its sentences, no other night's", () async {
+    final (_, journal, nights) = await open();
+    await journal.keep(nights[0].id, passages[0].text);
+    await journal.keep(nights[1].id, passages[1].text);
+    await journal.delete(nights[0].id);
+    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
+    await journal.delete(nights[1].id);
+    expect(files.files.containsKey(JournalStore.keptFile), isFalse);
+  });
+
+  test("a night deleted with its last dream takes its sentences", () async {
+    final (_, journal, nights) = await open();
+    final one = nights.firstWhere((n) => n.entries.length == 1);
+    await journal.keep(one.id, passages.first.text);
+    await journal.editDream(one.id, 0, ' ');
+    expect(await journal.night(one.id), isNull);
+    expect(await journal.kept(), isEmpty);
+  });
+
+  test('deleting the journal takes the kept sentences', () async {
+    final (_, journal, nights) = await open();
+    await journal.keep(nights.first.id, passages.first.text);
+    await journal.deleteAll();
+    expect(files.files, isEmpty);
+  });
+
+  test('at open, sentences whose night is gone go, with a code', () async {
+    final (_, journal, nights) = await open();
+    await journal.keep(nights[0].id, passages[0].text);
+    await journal.keep(nights[1].id, passages[1].text);
+    files.files.remove(JournalStore.fileOf(nights[0].id));
+    lines.clear();
+    final again = Journal(await JournalStore.open(files));
+    expect([for (final k in await again.kept()) k.text], passages[1].sentences);
+    expect(lines, ['keptOrphansSwept ${passages[0].sentences.length}']);
+  });
+
+  test('an unreadable kept file shows nothing, is logged, then replaced', () async {
+    final (_, journal, nights) = await open();
+    files.files[JournalStore.keptFile] = utf8.encode('{"version":9}');
+    lines.clear();
+    final reopened = Journal(await JournalStore.open(files), zone: const FixedZone(1), now: () => now);
+    expect(files.files[JournalStore.keptFile], utf8.encode('{"version":9}'));
+    expect(await reopened.kept(), isEmpty);
+    expect(lines, ['keptFileSkipped']);
+    await reopened.sweepKept(LifeContextLength.oneWeek);
+    expect(files.files[JournalStore.keptFile], utf8.encode('{"version":9}'));
+    await reopened.keep(nights.first.id, passages.first.text);
+    expect([for (final k in await reopened.kept()) k.text], passages.first.sentences);
+  });
+
+  test('an edit changes only the kept copy, never the night', () async {
+    final (_, journal, nights) = await open();
+    final night = nights.first;
+    await journal.keep(night.id, passages[0].text);
+    final [first, second, ...] = await journal.kept();
+    await journal.editKept(first.id, '  ${passages[1].sentences.first} ');
+    final kept = await journal.kept();
+    expect(kept.first.text, passages[1].sentences.first);
+    expect((kept.first.id, kept.first.night, kept.first.day), (first.id, first.night, first.day));
+    expect(kept[1], second);
+    expect(await journal.night(night.id), night);
+  });
+
+  test('an edit to nothing but spaces deletes the sentence', () async {
+    final (_, journal, nights) = await open();
+    await journal.keep(nights.first.id, passages[0].text);
+    final [first, second, ...] = await journal.kept();
+    await journal.editKept(first.id, ' \n ');
+    expect(await journal.kept(), [second]);
+  });
+
+  test('deleting chosen sentences leaves the rest, in order', () async {
+    final (_, journal, nights) = await open();
+    await journal.keep(nights.first.id, passages[0].text);
+    await journal.keep(nights.first.id, passages[1].text);
+    final kept = await journal.kept();
+    await journal.deleteKept({kept[0].id, kept[2].id});
+    expect(await journal.kept(), [kept[1], ...kept.skip(3)]);
+  });
+
+  test('the sweep takes only what is past the window, counted', () async {
+    final (_, journal, nights) = await open();
+    for (final (i, at) in [
+      DateTime.utc(2026, 11, 22, 9),
+      DateTime.utc(2026, 11, 14, 9),
+      DateTime.utc(2026, 11, 2, 9),
+    ].indexed) {
+      now = at;
+      await journal.keep(nights[i].id, passages[i].text);
+    }
+    now = DateTime.utc(2026, 11, 22, 9);
+    final before = await journal.kept();
+    expect(await journal.sweepKept(LifeContextLength.threeMonths), 0);
+    expect(await journal.kept(), before);
+    expect(await journal.sweepKept(LifeContextLength.twoWeeks), passages[2].sentences.length);
+    expect(await journal.sweepKept(LifeContextLength.oneWeek), passages[1].sentences.length);
+    expect([for (final k in await journal.kept()) k.text], passages[0].sentences);
+  });
+
+  test('keeping and deleting sentences leaves every other file byte for byte', () async {
+    final store = await JournalStore.open(files);
+    final nights = nightsFromFixtures();
+    for (final n in nights) {
+      await store.save(n);
+    }
+    final waiting = newNightId(Random(5));
+    await store.update(nights.first.id, (n) => n.withEntries([...n.entries, Waiting(waiting)]));
+    await store.appendAudio(waiting, Uint8List.fromList(List.filled(64, 3)));
+    await store.markFirstUseSeen();
+    await store.keepConsents(Consents.answered({Consent.readings: true, Consent.lifeContext: true}, now));
+    await store.keepSettings(const Settings(nightDay: NightDayMode.night, length: LifeContextLength.oneMonth));
+    final before = {for (final e in files.files.entries) e.key: Uint8List.fromList(e.value)};
+    final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(3));
+    for (final (i, w) in passages.indexed) {
+      await journal.keep(nights[i % nights.length].id, w.text);
+    }
+    final kept = await journal.kept();
+    await journal.editKept(kept.first.id, kept.last.text);
+    await journal.deleteKept({kept[1].id});
+    await journal.sweepKept(LifeContextLength.oneWeek);
+    expect(files.files.keys.toSet(), {...before.keys, JournalStore.keptFile});
+    for (final name in before.keys) {
+      expect(files.files[name], before[name], reason: name);
+    }
+    await journal.deleteAllKept();
+    expect(files.files.keys.toSet(), before.keys.toSet());
+    expect(await store.nights(), hasLength(nights.length));
+    expect(await store.audioPart(waiting), (start: 0, size: 64));
+    expect((await store.consents())!.given(Consent.lifeContext), isTrue);
+    expect((await store.settings())!.length, LifeContextLength.oneMonth);
+  });
+}
diff --git a/app/test/life_context/kept_test.dart b/app/test/life_context/kept_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/life_context/kept_test.dart
@@ -0,0 +1,146 @@
+// What Life Context keeps, and its file (C159-I item 1; D131): each kept
+// sentence word for word with its day and its night, version 1 exactly;
+// the Recent window by the calendar (MP·84); newest first.
+import 'dart:convert';
+import 'dart:math';
+import 'dart:typed_data';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/life_context/kept.dart';
+import 'package:souldreams/settings/settings.dart';
+
+import '../fixtures.dart';
+
+NightDate day(int y, int m, int d) => (year: y, month: m, day: d);
+
+/// The invented sentences, kept one a day back from 22 November 2026.
+List<Kept> keptFromFixtures([int seed = 2]) {
+  final random = Random(seed);
+  final night = newNightId(random);
+  final sentences = [
+    for (final n in inventedNights())
+      for (final w in n.waking) ...w.sentences,
+  ];
+  return [
+    for (final (i, s) in sentences.indexed)
+      Kept(id: newKeptId(random), night: night, day: day(2026, 11, 22 - i), text: s),
+  ];
+}
+
+Uint8List bytesOf(Object json) => utf8.encode(jsonEncode(json));
+
+void main() {
+  test('kept sentences read back from their file, word for word', () {
+    final kept = keptFromFixtures();
+    expect(kept, isNotEmpty);
+    expect(decodeKept(encodeKept(kept)), kept);
+    expect(decodeKept(encodeKept(const [])), isEmpty);
+    final json = jsonDecode(utf8.decode(encodeKept(kept))) as Map<String, dynamic>;
+    expect(json['version'], 1);
+    expect((json['sentences'] as List).first, {
+      'id': kept.first.id,
+      'night': kept.first.night,
+      'day': '2026-11-22',
+      'text': kept.first.text,
+    });
+  });
+
+  test('anything not version 1 exactly reads as nothing', () {
+    final k = keptFromFixtures().first;
+    Map<String, Object?> one([Map<String, Object?> change = const {}]) => {
+      'id': k.id,
+      'night': k.night,
+      'day': '2026-11-22',
+      'text': k.text,
+      ...change,
+    };
+    Object file(List<Object?> s, [int version = 1]) => {'version': version, 'sentences': s};
+    expect(decodeKept(bytesOf(file([one()]))), [k]);
+    for (final bad in [
+      file([one()], 2),
+      {
+        'version': 1,
+        'sentences': [one()],
+        'more': 1,
+      },
+      {'version': 1},
+      file([
+        one({'id': 'x'}),
+      ]),
+      file([
+        one({'night': 'x'}),
+      ]),
+      file([
+        one({'day': '2026-02-30'}),
+      ]),
+      file([
+        one({'day': '22/11/2026'}),
+      ]),
+      file([
+        one({'text': '  '}),
+      ]),
+      file([
+        one({'text': 3}),
+      ]),
+      file([
+        one({'more': 1}),
+      ]),
+      file([one(), one()]),
+      file(['x']),
+      [one()],
+    ]) {
+      expect(decodeKept(bytesOf(bad)), isNull, reason: '$bad');
+    }
+    expect(decodeKept(Uint8List.fromList([0xff, 0xfe])), isNull);
+    expect(decodeKept(utf8.encode('{')), isNull);
+  });
+
+  test('a kept sentence refuses what its file could not hold', () {
+    final k = keptFromFixtures().first;
+    expect(() => Kept(id: 'x', night: k.night, day: k.day, text: k.text), throwsArgumentError);
+    expect(() => Kept(id: k.id, night: 'x', day: k.day, text: k.text), throwsArgumentError);
+    expect(() => Kept(id: k.id, night: k.night, day: day(2026, 2, 30), text: k.text), throwsArgumentError);
+    expect(() => Kept(id: k.id, night: k.night, day: k.day, text: ' \n'), throwsArgumentError);
+  });
+
+  test('an edit changes only the words', () {
+    final [a, b, ...] = keptFromFixtures();
+    final edited = a.withText(b.text);
+    expect((edited.id, edited.night, edited.day, edited.text), (a.id, a.night, a.day, b.text));
+  });
+
+  test('the window: a week, two weeks, a month, three months', () {
+    final today = day(2026, 11, 22);
+    expect(cutoffOf(today, LifeContextLength.oneWeek), day(2026, 11, 15));
+    expect(cutoffOf(today, LifeContextLength.twoWeeks), day(2026, 11, 8));
+    expect(cutoffOf(today, LifeContextLength.oneMonth), day(2026, 10, 22));
+    expect(cutoffOf(today, LifeContextLength.threeMonths), day(2026, 8, 22));
+    expect(cutoffOf(day(2026, 3, 31), LifeContextLength.oneMonth), day(2026, 2, 28));
+    expect(cutoffOf(day(2028, 5, 31), LifeContextLength.threeMonths), day(2028, 2, 29));
+    expect(cutoffOf(day(2026, 1, 15), LifeContextLength.threeMonths), day(2025, 10, 15));
+    expect(cutoffOf(day(2026, 1, 3), LifeContextLength.oneWeek), day(2025, 12, 27));
+  });
+
+  test('in the window after the cutoff, out on it', () {
+    final k = keptFromFixtures().first;
+    Kept on(NightDate d) => Kept(id: k.id, night: k.night, day: d, text: k.text);
+    final today = day(2026, 11, 22);
+    expect(inWindow(on(day(2026, 11, 16)), today, LifeContextLength.oneWeek), isTrue);
+    expect(inWindow(on(day(2026, 11, 15)), today, LifeContextLength.oneWeek), isFalse);
+    expect(inWindow(on(day(2026, 10, 23)), today, LifeContextLength.oneMonth), isTrue);
+    expect(inWindow(on(day(2026, 10, 22)), today, LifeContextLength.oneMonth), isFalse);
+    expect(inWindow(on(day(2025, 11, 30)), today, LifeContextLength.threeMonths), isFalse);
+    expect(inWindow(on(today), today, LifeContextLength.oneWeek), isTrue);
+  });
+
+  test('newest day first; within a day, in the order kept', () {
+    final [a, b, c, ...] = keptFromFixtures();
+    Kept on(Kept k, NightDate d) => Kept(id: k.id, night: k.night, day: d, text: k.text);
+    final older = on(a, day(2026, 11, 1));
+    final first = on(b, day(2026, 11, 20));
+    final second = on(c, day(2026, 11, 20));
+    expect(newestFirst([older, first, second]), [first, second, older]);
+    expect(newestFirst([second, older, first]), [second, first, older]);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2734,6 +2734,102 @@ ROWS = [
      '      start = m.end;\n',
      '',
      'test/life_context/sentences_test.dart', "every sentence is the passage's own text, word for word"),
+    ('A672', 'lib/life_context/kept.dart',
+     '    if (!ids.add(id)) return null;\n',
+     '',
+     'test/life_context/kept_test.dart', 'anything not version 1 exactly reads as nothing'),
+    ('A673', 'lib/life_context/kept.dart',
+     'json.length != 2 || ',
+     '',
+     'test/life_context/kept_test.dart', 'anything not version 1 exactly reads as nothing'),
+    ('A674', 'lib/life_context/kept.dart',
+     's.length != 4',
+     's.length < 4',
+     'test/life_context/kept_test.dart', 'anything not version 1 exactly reads as nothing'),
+    ('A675', 'lib/life_context/kept.dart',
+     'LifeContextLength.oneWeek => days(7),',
+     'LifeContextLength.oneWeek => days(6),',
+     'test/life_context/kept_test.dart', 'the window: a week, two weeks, a month, three months'),
+    ('A676', 'lib/life_context/kept.dart',
+     'min(today.day, last)',
+     'today.day',
+     'test/life_context/kept_test.dart', 'the window: a week, two weeks, a month, three months'),
+    ('A677', 'lib/life_context/kept.dart',
+     'cutoffOf(today, length)) > 0;',
+     'cutoffOf(today, length)) >= 0;',
+     'test/life_context/kept_test.dart', 'in the window after the cutoff, out on it'),
+    ('A678', 'lib/life_context/kept.dart',
+     'return c != 0 ? c : a.$1 - b.$1;',
+     'return c != 0 ? c : b.$1 - a.$1;',
+     'test/life_context/kept_test.dart', 'newest day first; within a day, in the order kept'),
+    ('A679', 'lib/life_context/kept.dart',
+     "    if (isEmptyText(text)) throw ArgumentError('text');\n",
+     '',
+     'test/life_context/kept_test.dart', 'a kept sentence refuses what its file could not hold'),
+    ('A680', 'lib/journal/journal_store.dart',
+     '    if (rest.length != kept.length) await _writeKept(rest);\n',
+     '',
+     'test/life_context/kept_store_test.dart', "deleting a night deletes its sentences, no other night's"),
+    ('A681', 'lib/journal/journal_store.dart',
+     '    if (await _files.size(fileOf(night)) == null) return false;\n',
+     '',
+     'test/life_context/kept_store_test.dart', 'nothing is kept into a night that is not there'),
+    ('A682', 'lib/journal/journal_store.dart',
+     '    await _files.delete(tempPrefix + keptFile);\n',
+     '',
+     'test/life_context/kept_store_test.dart', 'deleting every kept sentence leaves no file of them'),
+    ('A683', 'lib/journal/journal_store.dart',
+     '    if (kept.isNotEmpty) return _whole(keptFile, encodeKept(kept));',
+     '    if (true) return _whole(keptFile, encodeKept(kept));',
+     'test/life_context/kept_store_test.dart', 'deleting every kept sentence leaves no file of them'),
+    ('A684', 'lib/journal/journal_store.dart',
+     '    await store._sweepKept(',
+     '    if (false) await store._sweepKept(',
+     'test/life_context/kept_store_test.dart', 'at open, sentences whose night is gone go, with a code'),
+    ('A685', 'lib/journal/journal_store.dart',
+     '    SafeLog.event(LogEvent.keptOrphansSwept, [kept.length - rest.length]);\n',
+     '',
+     'test/life_context/kept_store_test.dart', 'at open, sentences whose night is gone go, with a code'),
+    ('A686', 'lib/journal/journal_store.dart',
+     '    final rest = [for (final k in kept) if (nights.contains(k.night)) k];',
+     '    final rest = [for (final k in kept) k];',
+     'test/life_context/kept_store_test.dart', 'at open, sentences whose night is gone go, with a code'),
+    ('A687', 'lib/journal/journal_store.dart',
+     '    if (kept == null) SafeLog.event(LogEvent.keptFileSkipped);\n',
+     '',
+     'test/life_context/kept_store_test.dart', 'an unreadable kept file shows nothing, is logged, then replaced'),
+    ('A688', 'lib/journal/journal_store.dart',
+     '    if (!listEquals(after, before)) await _writeKept(after);',
+     '    await _writeKept(after);',
+     'test/life_context/kept_store_test.dart', 'an unreadable kept file shows nothing, is logged, then replaced'),
+    ('A689', 'lib/journal/journal.dart',
+     '    final day = dateOf(_now(), zone);\n    final add',
+     '    final day = dateOf(_now().subtract(const Duration(hours: 12)), zone);\n    final add',
+     'test/life_context/kept_store_test.dart', "the day is the phone's date when it was said"),
+    ('A690', 'lib/journal/journal.dart',
+     'k.withText(text.trim())',
+     'k.withText(text)',
+     'test/life_context/kept_store_test.dart', 'an edit changes only the kept copy, never the night'),
+    ('A691', 'lib/journal/journal.dart',
+     'if (k.id != id) k else if (!isEmptyText(text)) k.withText',
+     'if (k.id != id) k else k.withText',
+     'test/life_context/kept_store_test.dart', 'an edit to nothing but spaces deletes the sentence'),
+    ('A692', 'lib/journal/journal.dart',
+     'if (!ids.contains(k.id)) k]',
+     'if (ids.contains(k.id)) k]',
+     'test/life_context/kept_store_test.dart', 'deleting chosen sentences leaves the rest, in order'),
+    ('A693', 'lib/journal/journal.dart',
+     '      gone = kept.length - rest.length;\n',
+     '',
+     'test/life_context/kept_store_test.dart', 'the sweep takes only what is past the window, counted'),
+    ('A694', 'lib/journal/journal.dart',
+     'if (inWindow(k, today, length)) k]',
+     'k]',
+     'test/life_context/kept_store_test.dart', 'the sweep takes only what is past the window, counted'),
+    ('A695', 'lib/journal/journal.dart',
+     '    return await _store.addKept(night, add) ? add.length : 0;',
+     '    await _store.addKept(night, add);\n    return add.length;',
+     'test/life_context/kept_store_test.dart', 'nothing is kept into a night that is not there'),
 ]
 
 
```

Commit message:

```
Life Context: the kept sentences on the phone, one file, deleted with their night and the journal (R11; X11; workflow (c))

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
```

### Task 3 · Life Context while the journal is open: On, Off, the window and the sweep (D127; D128; D131 item 4)

`life_context/life_context.dart` (`LifeContext`); `SettingsController.answer` deletes what is kept at Off; the
journal's home holds `LifeContext`, starts it when the journal opens (a sweep, then one at each local midnight), sweeps
on each return, and disposes it at a restart.

Tests: `test/life_context/life_context_test.dart` (9, new), `test/journal/pages/journal_home_test.dart` (1 new: the
opening and the return sweep). 719 → 729.

Rows: A696 to A714. Then `--files lib/settings/settings_controller.dart,lib/journal/pages/journal_home.dart,lib/life_context/life_context.dart`
(53 run, 53 caught on the build).

```
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -18,7 +18,9 @@
 // consent behind it, D125 item 8), and recording by voice with its retries
 // only once the dreamer has agreed (D128): until then every night stays, the
 // microphone and Start Interpretation show a popup when tapped, and nothing is
-// sent.
+// sent. It holds Life Context too (`LifeContext`, D131 item 4): what is past
+// its window is deleted when the journal opens, when the app comes back, and
+// at each local midnight while it is open.
 import 'dart:async';
 
 import 'package:flutter/material.dart';
@@ -27,6 +29,7 @@ import '../../core/always_light.dart';
 import '../../core/app_line.dart' show wordAnimation;
 import '../../core/night_day.dart';
 import '../../core/safe_log.dart';
+import '../../life_context/life_context.dart';
 import '../../onboarding/onboarding.dart';
 import '../../recording/recording.dart';
 import '../../settings/consents.dart';
@@ -74,6 +77,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   Journal? _journal;
   JournalAudio? _audio;
   SettingsController? _settings;
+  LifeContext? _lifeContext;
   Recording? _recording;
   // Null until the consents are read; then whether onboarding has been
   // answered (agreeing or not; `SettingsController.agreed` is the readings'
@@ -92,6 +96,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   void dispose() {
     WidgetsBinding.instance.removeObserver(this);
     _journal?.consentGone.removeListener(_restart);
+    _lifeContext?.dispose();
     _settings?.dispose();
     _recording?.retries?.dispose();
     super.dispose();
@@ -101,6 +106,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   // item 3). `inactive` changes nothing.
   @override
   void didChangeAppLifecycleState(AppLifecycleState state) {
+    if (state == AppLifecycleState.resumed) _lifeContext?.resumed();
     final retries = _recording?.retries;
     if (retries == null) return;
     if (state == AppLifecycleState.resumed) retries.back();
@@ -156,9 +162,12 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     AlwaysLight.hold(context, false);
     final audio = _audio = JournalAudio(_store!);
     final controller = SettingsController(_journal!, consents: consents, settings: settings)..addListener(_follow);
+    _lifeContext?.dispose();
+    final lifeContext = LifeContext(_journal!, controller)..start();
     setState(() {
       _agreed = true;
       _settings = controller;
+      _lifeContext = lifeContext;
     });
     // D98: the counts at launch and after each retry, for DevTools.
     unawaited(audio.logCounts());
@@ -210,6 +219,8 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     if (!mounted) return;
     _recording?.retries?.dispose();
     _recording = null;
+    _lifeContext?.dispose();
+    _lifeContext = null;
     _settings?.dispose();
     _settings = null;
     wordAnimation = true;
diff --git a/app/lib/life_context/life_context.dart b/app/lib/life_context/life_context.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/life_context/life_context.dart
@@ -0,0 +1,120 @@
+// Life Context while the journal is open (C159-I item 1; D110; D127; D128;
+// D131), in plain Dart: whether it is on, what its page shows, and what the
+// dreamer does there. On is consent (b), the Life Context row (MP·83): Off
+// keeps nothing (a capture keeps nothing) and deletes what is kept (the
+// sweep finds nothing kept while Off, and turning it off deletes it,
+// `SettingsController.answer`).
+//
+// - The page shows exactly what readings could see now: the Recent list,
+//   every kept sentence inside the window (MP·84), newest first, and the
+//   Kept longer list, empty until its rule exists (D131 item 5).
+// - The sweep (D131 item 4): sentences past the window are deleted when the
+//   journal opens, when the app comes back, and at each local midnight
+//   while it is open.
+// - A change that cannot be done logs a code and the page shows what is
+//   kept; nothing here carries a sentence into a log (R3).
+import 'dart:async';
+
+import 'package:flutter/foundation.dart';
+
+import '../core/safe_log.dart';
+import '../journal/journal.dart';
+import '../journal/night_rules.dart';
+import '../settings/consents.dart';
+import '../settings/settings_controller.dart';
+import 'kept.dart';
+
+final class LifeContext extends ChangeNotifier {
+  LifeContext(this._journal, this._settings);
+
+  final Journal _journal;
+  final SettingsController _settings;
+  Timer? _midnight;
+
+  /// Whether Life Context is on: consent (b) is given.
+  bool get on => _settings.consents.given(Consent.lifeContext);
+
+  /// Keeps the sentences of [text], said now in night [night], when Life
+  /// Context is on. Returns how many were kept. Nothing calls it yet: its
+  /// sources come with Questions and Reflection.
+  Future<int> capture(String night, String text) async {
+    if (!on) return 0;
+    try {
+      final n = await _journal.keep(night, text);
+      if (n > 0) notifyListeners();
+      return n;
+    } on Object {
+      SafeLog.event(LogEvent.keptKeepFailed);
+      return 0;
+    }
+  }
+
+  /// The Recent list: every kept sentence inside the window today, newest
+  /// first; nothing while Off.
+  Future<List<Kept>> recent() async {
+    if (!on) return const [];
+    final today = dateOf(_journal.now(), _journal.zone);
+    final length = _settings.settings.length;
+    return newestFirst([for (final k in await _journal.kept()) if (inWindow(k, today, length)) k]);
+  }
+
+  /// The Kept longer list: empty until its rule exists (D131 item 5).
+  List<Kept> get longer => const [];
+
+  /// Deletes what is past the window, or everything while Off.
+  Future<void> sweep() async {
+    try {
+      if (!on) return await _journal.deleteAllKept();
+      final gone = await _journal.sweepKept(_settings.settings.length);
+      if (gone > 0) SafeLog.event(LogEvent.keptExpired, [gone]);
+    } on Object {
+      SafeLog.event(LogEvent.keptDeleteFailed);
+    }
+  }
+
+  /// Sweeps now, and again at each local midnight while the journal is open.
+  void start() {
+    unawaited(sweep());
+    _schedule();
+  }
+
+  void _schedule() {
+    _midnight?.cancel();
+    final now = _journal.now();
+    final w = _journal.zone.wall(now);
+    final next = _journal.zone.instantAt(w.year, w.month, w.day + 1, 0);
+    _midnight = Timer(next.difference(now), () {
+      unawaited(sweep());
+      _schedule();
+    });
+  }
+
+  /// The app came back: a day may have passed.
+  void resumed() => unawaited(sweep());
+
+  /// Replaces sentence [id]'s words with [text]: the kept copy only (D131
+  /// item 2); nothing but spaces deletes it.
+  Future<void> edit(String id, String text) => _change(() => _journal.editKept(id, text), LogEvent.keptKeepFailed);
+
+  /// Deletes the sentences [ids].
+  Future<void> delete(Set<String> ids) => _change(() => _journal.deleteKept(ids), LogEvent.keptDeleteFailed);
+
+  /// Deletes every kept sentence: Delete all, and the Recent list while the
+  /// Kept longer list is empty.
+  Future<void> deleteAll() => _change(_journal.deleteAllKept, LogEvent.keptDeleteFailed);
+
+  Future<void> _change(Future<void> Function() change, LogEvent failed) async {
+    try {
+      await change();
+    } on Object {
+      SafeLog.event(failed);
+    }
+    notifyListeners();
+  }
+
+  @override
+  void dispose() {
+    _midnight?.cancel();
+    super.dispose();
+  }
+}
diff --git a/app/lib/settings/settings_controller.dart b/app/lib/settings/settings_controller.dart
--- a/app/lib/settings/settings_controller.dart
+++ b/app/lib/settings/settings_controller.dart
@@ -10,8 +10,9 @@
 //   phone, so no recording by voice and no retries, every night kept, and a
 //   feature tapped shows the popup instead (MP·101).
 // - Life Context (b): its setting, On or Off, is the consent (C159-I item 5;
-//   MP·83): Off deletes what is kept, On shows its page. Nothing is kept yet
-//   (D121 item 2).
+//   MP·83): Off deletes what is kept (C159-I item 1; D127), On shows its
+//   page. A deletion that cannot be done logs a code; the next sweep, at the
+//   next opening, deletes it (`LifeContext.sweep`).
 // - Night images (MP·85) is a setting, Off, Personal or Random, with no
 //   consent behind it (D125 item 8).
 import 'package:flutter/foundation.dart';
@@ -48,11 +49,18 @@ final class SettingsController extends ChangeNotifier {
   }
 
   /// Gives or turns off [consent] (Life Context's On and Off), then keeps the
-  /// consents with the day.
+  /// consents with the day. Life Context Off deletes what is kept.
   Future<void> answer(Consent consent, bool given) async {
     if (_consents.given(consent) == given) return;
     _consents = _consents.withAnswer(consent, given, _journal.now());
     notifyListeners();
+    if (consent == Consent.lifeContext && !given) {
+      try {
+        await _journal.deleteAllKept();
+      } on Object {
+        SafeLog.event(LogEvent.keptDeleteFailed);
+      }
+    }
     await _keep();
   }
 
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -662,4 +662,42 @@ void main() {
       expect(decodeSettings(files.files[JournalStore.settingsFile]!)!.images, images);
     });
   }
+
+  // D131 item 4: what is past Life Context's window goes when the journal
+  // opens, and when the app comes back; nothing of it is logged but a count.
+  testWidgets('the journal opening sweeps Life Context; coming back too', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    final files = answered(MemoryJournalFiles(), const {Consent.readings: true, Consent.lifeContext: true});
+    files.files[JournalStore.settingsFile] = encodeSettings(const Settings(length: LifeContextLength.oneWeek));
+    final night = nightsFromFixtures().first;
+    final passages = [for (final n in inventedNights()) ...n.waking];
+    var now = DateTime.now().toUtc().subtract(const Duration(days: 30));
+    final store = await JournalStore.open(files);
+    await store.save(night);
+    final journal = Journal(store, now: () => now);
+    await journal.keep(night.id, passages[0].text);
+    now = DateTime.now().toUtc().subtract(const Duration(days: 1));
+    await journal.keep(night.id, passages[1].text);
+    lines.clear();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
+    await tester.pumpAndSettle();
+    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
+    expect(lines, contains('keptExpired ${passages[0].sentences.length}'));
+    lines.clear();
+    // Six more days pass while the app is away (the phone's clock, moved).
+    now = DateTime.now().toUtc().subtract(const Duration(days: 8));
+    await journal.keep(night.id, passages[2].text);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pumpAndSettle();
+    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
+    expect(lines, contains('keptExpired ${passages[2].sentences.length}'));
+    await tester.pumpWidget(const SizedBox());
+  });
 }
diff --git a/app/test/life_context/life_context_test.dart b/app/test/life_context/life_context_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/life_context/life_context_test.dart
@@ -0,0 +1,203 @@
+// Life Context while the journal is open (C159-I item 1; D127; D128;
+// D131): Off keeps nothing and deletes what is kept; the page's lists; the
+// sweep when the journal opens, when the app comes back and at each local
+// midnight; a change that cannot be done logs a code, never a sentence.
+import 'dart:math';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/life_context/life_context.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
+import 'package:souldreams/settings/settings_controller.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+import '../journal/zones.dart';
+
+/// A folder whose deletes of the kept file fail.
+final class NoKeptDelete extends MemoryJournalFiles {
+  @override
+  Future<void> delete(String name) async =>
+      name == JournalStore.keptFile ? throw StateError('journal-io') : super.delete(name);
+}
+
+void main() {
+  late DateTime now;
+  final lines = <String>[];
+  final sink = SafeLog.sink;
+  final passages = [for (final n in inventedNights()) ...n.waking];
+
+  setUp(() {
+    JournalStore.newQueueForTests();
+    now = DateTime.utc(2026, 11, 22, 9);
+    lines.clear();
+    SafeLog.sink = lines.add;
+  });
+
+  tearDown(() => SafeLog.sink = sink);
+
+  Future<(Journal, SettingsController, LifeContext, List<Night>)> open({
+    bool on = true,
+    LifeContextLength length = LifeContextLength.twoWeeks,
+    MemoryJournalFiles? files,
+  }) async {
+    final store = await JournalStore.open(files ?? MemoryJournalFiles());
+    final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(4));
+    final nights = nightsFromFixtures();
+    for (final n in nights) {
+      await store.save(n);
+    }
+    final settings = SettingsController(
+      journal,
+      consents: Consents.answered({Consent.readings: true, Consent.lifeContext: on}, now),
+      settings: Settings(length: length),
+    );
+    return (journal, settings, LifeContext(journal, settings), nights);
+  }
+
+  test('Off, a capture keeps nothing', () async {
+    final (journal, _, life, nights) = await open(on: false);
+    expect(life.on, isFalse);
+    expect(await life.capture(nights.first.id, passages.first.text), 0);
+    expect(await journal.kept(), isEmpty);
+    expect(await life.recent(), isEmpty);
+  });
+
+  test('On, a capture keeps each sentence word for word', () async {
+    final (journal, _, life, nights) = await open();
+    var told = 0;
+    life.addListener(() => told++);
+    expect(await life.capture(nights.first.id, passages.first.text), passages.first.sentences.length);
+    expect([for (final k in await journal.kept()) k.text], passages.first.sentences);
+    expect(told, 1);
+  });
+
+  test('Recent: only the window, newest first; Kept longer is empty', () async {
+    final (_, _, life, nights) = await open();
+    for (final (i, at) in [
+      DateTime.utc(2026, 11, 2, 9),
+      DateTime.utc(2026, 11, 9, 9),
+      DateTime.utc(2026, 11, 20, 9),
+    ].indexed) {
+      now = at;
+      await life.capture(nights[i].id, passages[i].text);
+    }
+    now = DateTime.utc(2026, 11, 22, 9);
+    expect([for (final k in await life.recent()) k.text], [...passages[2].sentences, ...passages[1].sentences]);
+    expect(life.longer, isEmpty);
+  });
+
+  test('turning Life Context off deletes everything kept', () async {
+    final (journal, settings, life, nights) = await open();
+    await life.capture(nights.first.id, passages.first.text);
+    await settings.answer(Consent.lifeContext, false);
+    expect(await journal.kept(), isEmpty);
+    expect(settings.consents.given(Consent.lifeContext), isFalse);
+    expect(lines, isEmpty);
+  });
+
+  test('a failed deletion at Off: still Off, a code, swept again', () async {
+    final files = NoKeptDelete();
+    final (journal, settings, life, nights) = await open(files: files);
+    await life.capture(nights.first.id, passages.first.text);
+    await settings.answer(Consent.lifeContext, false);
+    expect(settings.consents.given(Consent.lifeContext), isFalse);
+    expect(lines, ['keptDeleteFailed']);
+    expect(await life.recent(), isEmpty);
+    lines.clear();
+    await life.sweep();
+    expect(lines, ['keptDeleteFailed']);
+  });
+
+  test('the sweep: past the window goes, counted; while Off, everything', () async {
+    final (journal, settings, life, nights) = await open(length: LifeContextLength.oneWeek);
+    now = DateTime.utc(2026, 11, 10, 9);
+    await life.capture(nights[0].id, passages[0].text);
+    now = DateTime.utc(2026, 11, 21, 9);
+    await life.capture(nights[1].id, passages[1].text);
+    now = DateTime.utc(2026, 11, 22, 9);
+    await life.sweep();
+    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
+    expect(lines, ['keptExpired ${passages[0].sentences.length}']);
+    lines.clear();
+    await life.sweep();
+    expect(lines, isEmpty);
+    await journal.keep(nights[2].id, passages[2].text);
+    final off = LifeContext(
+      journal,
+      SettingsController(journal, consents: settings.consents.withAnswer(Consent.lifeContext, false, now)),
+    );
+    await off.sweep();
+    expect(await journal.kept(), isEmpty);
+  });
+
+  test('edit, delete and delete all change the kept copies only', () async {
+    final (journal, _, life, nights) = await open();
+    await life.capture(nights.first.id, passages[0].text);
+    await life.capture(nights[1].id, passages[1].text);
+    var told = 0;
+    life.addListener(() => told++);
+    final kept = await journal.kept();
+    await life.edit(kept[0].id, passages[2].sentences.first);
+    await life.delete({kept[1].id});
+    expect(
+      [for (final k in await journal.kept()) k.text],
+      [
+        passages[2].sentences.first,
+        ...[for (final k in kept.skip(2)) k.text],
+      ],
+    );
+    expect(await journal.night(nights.first.id), nights.first);
+    await life.deleteAll();
+    expect(await journal.kept(), isEmpty);
+    expect(told, 3);
+  });
+
+  testWidgets('start sweeps now, then at each local midnight', (tester) async {
+    JournalStore.newQueueForTests();
+    final start = DateTime.utc(2026, 11, 22, 21, 30);
+    final (journal, _, life, nights) = await open(length: LifeContextLength.oneWeek);
+    // Kept on 15 November, local: past the week once 22 November has begun.
+    now = DateTime.utc(2026, 11, 15, 9);
+    await journal.keep(nights.first.id, passages.first.text);
+    now = start;
+    life.start();
+    await tester.pump();
+    expect(lines, ['keptExpired ${passages.first.sentences.length}']);
+    lines.clear();
+    now = DateTime.utc(2026, 11, 16, 9);
+    await journal.keep(nights.first.id, passages[1].text);
+    // 23 November begins at 23:00 UTC (UTC+1); a minute before, nothing.
+    now = start.add(const Duration(minutes: 89));
+    await tester.pump(const Duration(minutes: 89));
+    expect(lines, isEmpty);
+    now = start.add(const Duration(minutes: 90));
+    await tester.pump(const Duration(minutes: 1));
+    await tester.pump();
+    expect(lines, ['keptExpired ${passages[1].sentences.length}']);
+    lines.clear();
+    // And again at the next midnight.
+    now = DateTime.utc(2026, 11, 17, 9);
+    await journal.keep(nights.first.id, passages[2].text);
+    now = DateTime.utc(2026, 11, 23, 23);
+    await tester.pump(const Duration(hours: 24));
+    await tester.pump();
+    expect(lines, ['keptExpired ${passages[2].sentences.length}']);
+    life.dispose();
+  });
+
+  test('coming back sweeps', () async {
+    final (journal, _, life, nights) = await open(length: LifeContextLength.oneWeek);
+    now = DateTime.utc(2026, 11, 1, 9);
+    await life.capture(nights.first.id, passages.first.text);
+    now = DateTime.utc(2026, 11, 22, 9);
+    life.resumed();
+    await Future<void>.delayed(Duration.zero);
+    await journal.kept();
+    expect(lines, ['keptExpired ${passages.first.sentences.length}']);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2830,6 +2830,82 @@ ROWS = [
      '    return await _store.addKept(night, add) ? add.length : 0;',
      '    await _store.addKept(night, add);\n    return add.length;',
      'test/life_context/kept_store_test.dart', 'nothing is kept into a night that is not there'),
+    ('A696', 'lib/life_context/life_context.dart',
+     '    if (!on) return 0;\n',
+     '',
+     'test/life_context/life_context_test.dart', 'Off, a capture keeps nothing'),
+    ('A697', 'lib/life_context/life_context.dart',
+     '    if (!on) return const [];\n',
+     '',
+     'test/life_context/life_context_test.dart', 'a failed deletion at Off: still Off, a code, swept again'),
+    ('A698', 'lib/life_context/life_context.dart',
+     'in await _journal.kept()) if (inWindow(k, today, length)) k]',
+     'in await _journal.kept()) k]',
+     'test/life_context/life_context_test.dart', 'Recent: only the window, newest first; Kept longer is empty'),
+    ('A699', 'lib/life_context/life_context.dart',
+     '    return newestFirst([',
+     '    return ([',
+     'test/life_context/life_context_test.dart', 'Recent: only the window, newest first; Kept longer is empty'),
+    ('A700', 'lib/life_context/life_context.dart',
+     '      if (!on) return await _journal.deleteAllKept();\n',
+     '',
+     'test/life_context/life_context_test.dart', 'the sweep: past the window goes, counted; while Off, everything'),
+    ('A701', 'lib/life_context/life_context.dart',
+     '      if (gone > 0) SafeLog.event',
+     '      SafeLog.event',
+     'test/life_context/life_context_test.dart', 'the sweep: past the window goes, counted; while Off, everything'),
+    ('A702', 'lib/life_context/life_context.dart',
+     '      SafeLog.event(LogEvent.keptDeleteFailed);\n    }\n  }\n\n  /// Sweeps now',
+     '    }\n  }\n\n  /// Sweeps now',
+     'test/life_context/life_context_test.dart', 'a failed deletion at Off: still Off, a code, swept again'),
+    ('A703', 'lib/life_context/life_context.dart',
+     '    unawaited(sweep());\n    _schedule();',
+     '    _schedule();',
+     'test/life_context/life_context_test.dart', 'start sweeps now, then at each local midnight'),
+    ('A704', 'lib/life_context/life_context.dart',
+     'w.day + 1, 0);',
+     'w.day + 1, 1);',
+     'test/life_context/life_context_test.dart', 'start sweeps now, then at each local midnight'),
+    ('A705', 'lib/life_context/life_context.dart',
+     '      unawaited(sweep());\n      _schedule();\n    });',
+     '      unawaited(sweep());\n    });',
+     'test/life_context/life_context_test.dart', 'start sweeps now, then at each local midnight'),
+    ('A706', 'lib/life_context/life_context.dart',
+     '  void resumed() => unawaited(sweep());',
+     '  void resumed() {}',
+     'test/life_context/life_context_test.dart', 'coming back sweeps'),
+    ('A707', 'lib/life_context/life_context.dart',
+     '      SafeLog.event(failed);\n    }\n    notifyListeners();',
+     '      SafeLog.event(failed);\n    }',
+     'test/life_context/life_context_test.dart', 'edit, delete and delete all change the kept copies only'),
+    ('A708', 'lib/life_context/life_context.dart',
+     '      if (n > 0) notifyListeners();\n',
+     '',
+     'test/life_context/life_context_test.dart', 'On, a capture keeps each sentence word for word'),
+    ('A709', 'lib/life_context/life_context.dart',
+     '    _midnight?.cancel();\n    super.dispose();',
+     '    super.dispose();',
+     'test/life_context/life_context_test.dart', 'start sweeps now, then at each local midnight'),
+    ('A710', 'lib/settings/settings_controller.dart',
+     '    if (consent == Consent.lifeContext && !given) {',
+     '    if (false) {',
+     'test/life_context/life_context_test.dart', 'turning Life Context off deletes everything kept'),
+    ('A711', 'lib/settings/settings_controller.dart',
+     '        SafeLog.event(LogEvent.keptDeleteFailed);\n',
+     '',
+     'test/life_context/life_context_test.dart', 'a failed deletion at Off: still Off, a code, swept again'),
+    ('A712', 'lib/journal/pages/journal_home.dart',
+     'LifeContext(_journal!, controller)..start();',
+     'LifeContext(_journal!, controller);',
+     'test/journal/pages/journal_home_test.dart', 'the journal opening sweeps Life Context; coming back too'),
+    ('A713', 'lib/journal/pages/journal_home.dart',
+     '    if (state == AppLifecycleState.resumed) _lifeContext?.resumed();\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the journal opening sweeps Life Context; coming back too'),
+    ('A714', 'lib/journal/pages/journal_home.dart',
+     '    _lifeContext?.dispose();\n    _lifeContext = null;\n',
+     '    _lifeContext = null;\n',
+     'test/journal/pages/journal_home_test.dart', 'after the journal is deleted, a new I consent opens it'),
 ]
 
 
```

Commit message:

```
Life Context: Off keeps nothing and deletes what is kept; the Recent window swept at launch, on return and at midnight (D127; D128; D131)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
```

### Task 4 · The page "What you've told Soul Dreams" and its row in Settings (MP·86 to MP·92; D110; D131)

`life_context/life_context_page.dart`; Settings' row MP·86 (`SettingsPage.keptKey`) and `openNight`; the journal
page hands Life Context and a night's opening to Settings; the home hands Life Context to the journal page; the
palette's Life Context colours and the list label's; `StandIns` for the box, the icons and the dark delete;
`DestructivePill` in `parts.dart`, Settings' Delete journal using it; `LifeContext.length`.

Tests: `test/life_context/life_context_page_test.dart` (15, new), `test/settings/settings_page_test.dart` (one test
follows D121 item 2, renamed). 729 → 744.

Rows: A715 to A741; A568, A570 and A658 follow their code (D67). Then `--files lib/design/palette.dart,lib/design/stand_ins.dart,lib/journal/pages/parts.dart,lib/settings/settings_page.dart,lib/journal/pages/journal_page.dart,lib/journal/pages/journal_home.dart,lib/life_context/life_context.dart,lib/life_context/life_context_page.dart`
(177 run, 177 caught on the build, after A568 and A658 followed).

```
diff --git a/app/lib/design/palette.dart b/app/lib/design/palette.dart
--- a/app/lib/design/palette.dart
+++ b/app/lib/design/palette.dart
@@ -2,7 +2,12 @@
 // generated design values (design-system.md §2, §3), so that every page
 // fades with the theme when Night/Day mode changes it (§6). No value is
 // typed here except the dark field's absent border ("no border", §3); the
-// journal row's grey border is a stand-in from stand_ins.dart (D115).
+// journal row's grey border is a stand-in from stand_ins.dart (D115). Life
+// Context's page (§2, §3, color.lifecontext.*): a kept sentence's box, its
+// words and its date; the light box's edge is the surface's (the founder's
+// screen), and the dark delete icon a stand-in, #D0775A, proposed by C18-P
+// and not yet approved; its list labels take color.tag.dream (a stand-in
+// read from the founder's screen).
 import 'package:flutter/material.dart';
 
 import 'stand_ins.dart';
@@ -32,6 +37,15 @@ final class Palette extends ThemeExtension<Palette> {
     required this.sectionBottom,
     required this.sectionText,
     required this.rowBorder,
+    required this.keptTop,
+    required this.keptBottom,
+    required this.keptBorder,
+    required this.keptText,
+    required this.keptDate,
+    required this.keptDelete,
+    required this.tagTop,
+    required this.tagBottom,
+    required this.tagText,
   });
 
   final Color page;
@@ -55,6 +69,15 @@ final class Palette extends ThemeExtension<Palette> {
   final Color sectionBottom;
   final Color sectionText;
   final Color rowBorder;
+  final Color keptTop;
+  final Color keptBottom;
+  final Color keptBorder;
+  final Color keptText;
+  final Color keptDate;
+  final Color keptDelete;
+  final Color tagTop;
+  final Color tagBottom;
+  final Color tagText;
 
   static final light = Palette(
     page: LightColours.page.colour!,
@@ -78,6 +101,15 @@ final class Palette extends ThemeExtension<Palette> {
     sectionBottom: LightColours.labelSection.colourEnd!,
     sectionText: LightColours.labelSection.text!,
     rowBorder: StandIns.rowBorderLight,
+    keptTop: LightColours.lifecontextBox.colour!,
+    keptBottom: LightColours.lifecontextBox.colour!,
+    keptBorder: LightColours.surfaceBorder.border!,
+    keptText: LightColours.text.colour!,
+    keptDate: LightColours.lifecontextDate.colour!,
+    keptDelete: LightColours.lifecontextDelete.colour!,
+    tagTop: LightColours.tagDream.colour!,
+    tagBottom: LightColours.tagDream.colourEnd!,
+    tagText: LightColours.tagDream.text!,
   );
 
   static final dark = Palette(
@@ -102,6 +134,15 @@ final class Palette extends ThemeExtension<Palette> {
     sectionBottom: DarkColours.labelSection.colourEnd!,
     sectionText: DarkColours.labelSection.text!,
     rowBorder: StandIns.rowBorderDark,
+    keptTop: DarkColours.lifecontextBox.colour!,
+    keptBottom: DarkColours.lifecontextBox.colourEnd!,
+    keptBorder: DarkColours.lifecontextBox.border!,
+    keptText: DarkColours.lifecontextText.colour!,
+    keptDate: DarkColours.lifecontextDate.colour!,
+    keptDelete: StandIns.keptDeleteDark,
+    tagTop: DarkColours.tagDream.colour!,
+    tagBottom: DarkColours.tagDream.colourEnd!,
+    tagText: DarkColours.tagDream.text!,
   );
 
   static Palette of(BuildContext context) => Theme.of(context).extension<Palette>()!;
@@ -135,6 +176,15 @@ final class Palette extends ThemeExtension<Palette> {
       sectionBottom: c(sectionBottom, other.sectionBottom),
       sectionText: c(sectionText, other.sectionText),
       rowBorder: c(rowBorder, other.rowBorder),
+      keptTop: c(keptTop, other.keptTop),
+      keptBottom: c(keptBottom, other.keptBottom),
+      keptBorder: c(keptBorder, other.keptBorder),
+      keptText: c(keptText, other.keptText),
+      keptDate: c(keptDate, other.keptDate),
+      keptDelete: c(keptDelete, other.keptDelete),
+      tagTop: c(tagTop, other.tagTop),
+      tagBottom: c(tagBottom, other.tagBottom),
+      tagText: c(tagText, other.tagText),
     );
   }
 }
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -121,4 +121,14 @@ abstract final class StandIns {
   /// frames it draws (main-path.md, Recording; D71 Q7).
   static const double levelHeight = 24;
   static const int levelFrames = 48;
+
+  /// Life Context's page (D110; D131; the founder's screen, TO TRY): inside
+  /// a kept sentence's box, the space between its words and its date, the
+  /// edit and delete icons and their tap boxes, and the dark theme's delete
+  /// icon, #D0775A, proposed by C18-P for the founder to approve (#8F3D24
+  /// fails on the dark box).
+  static const keptPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 14);
+  static const double keptDateGap = 4;
+  static const double keptIcon = 20;
+  static const keptDeleteDark = Color(0xFFD0775A);
 }
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -240,6 +240,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
         nightAction: widget.nightAction,
         read: widget.read,
         settings: _settings,
+        lifeContext: _lifeContext,
         images: _settings?.settings.images != NightImages.off,
         agreed: _settings?.agreed ?? true,
       ),
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -19,7 +19,8 @@
 // Bold. The query lives only while the page does: never kept, never logged
 // (R3), no recent searches.
 // The search field sits to the right of the settings button, on its row; the
-// sky mark stays 140 down.
+// sky mark stays 140 down. Settings is handed Life Context, whose page opens
+// a night here as a row does (D131).
 import 'dart:async';
 
 import 'package:flutter/material.dart';
@@ -32,6 +33,7 @@ import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
+import '../../life_context/life_context.dart';
 import '../../settings/settings_controller.dart';
 import '../../settings/settings_page.dart';
 import '../greeting.dart';
@@ -56,6 +58,7 @@ class JournalPage extends StatefulWidget {
     this.nightAction,
     this.read = noneRead,
     this.settings,
+    this.lifeContext,
     this.images = true,
     this.agreed = true,
   });
@@ -86,6 +89,9 @@ class JournalPage extends StatefulWidget {
   /// The settings and the consents, which the gear opens (D122), or null.
   final SettingsController? settings;
 
+  /// Life Context, handed to Settings (D131), or null.
+  final LifeContext? lifeContext;
+
   /// False while Night images is Off: every night shows the gradient
   /// (D121 item 3).
   final bool images;
@@ -186,6 +192,19 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     await _load();
   }
 
+  // A night, as its row opens it, with no search (Life Context's page, D131).
+  Future<void> _openNight(String id) => _push(
+    NightPage(
+      journal: widget.journal,
+      id: id,
+      recording: widget.recording,
+      action: widget.nightAction,
+      read: widget.read,
+      images: widget.images,
+      agreed: widget.agreed,
+    ),
+  );
+
   // A typing screen is opening or open: another tap opens nothing, so one
   // evening's dreams never go to two nights (the final review).
   bool _recording = false;
@@ -251,7 +270,16 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
             Row(
               children: [
                 if (widget.settings case final settings?) ...[
-                  _Gear(onPressed: () => _push(SettingsPage(journal: widget.journal, settings: settings))),
+                  _Gear(
+                    onPressed: () => _push(
+                      SettingsPage(
+                        journal: widget.journal,
+                        settings: settings,
+                        lifeContext: widget.lifeContext,
+                        openNight: _openNight,
+                      ),
+                    ),
+                  ),
                   const SizedBox(width: StandIns.searchGap),
                 ],
                 Expanded(
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
--- a/app/lib/journal/pages/parts.dart
+++ b/app/lib/journal/pages/parts.dart
@@ -97,6 +97,36 @@ class ButtonRow extends StatelessWidget {
   );
 }
 
+/// A destructive pill in color.destructive, white words (the Design System
+/// §2): Delete journal, Life Context's Delete all and Delete selected; told
+/// apart by its place and its word as well (§3). Without [onPressed] it is
+/// shown and does nothing.
+class DestructivePill extends StatelessWidget {
+  const DestructivePill(this.text, {super.key, required this.onPressed});
+
+  final String text;
+  final VoidCallback? onPressed;
+
+  @override
+  Widget build(BuildContext context) {
+    const role = LightColours.destructive;
+    return Semantics(
+      button: true,
+      enabled: onPressed != null,
+      child: GestureDetector(
+        onTap: onPressed,
+        child: DecoratedBox(
+          decoration: _pill(role.colour!, role.colourEnd!),
+          child: Padding(
+            padding: StandIns.buttonPadding,
+            child: Text(text, textAlign: TextAlign.center, style: TypeRoles.button.style(role.text!)),
+          ),
+        ),
+      ),
+    );
+  }
+}
+
 /// A surface: a dreamer's bubble (color.surface, radius).
 BoxDecoration surface(Palette p) => BoxDecoration(
   gradient: LinearGradient(
diff --git a/app/lib/life_context/life_context.dart b/app/lib/life_context/life_context.dart
--- a/app/lib/life_context/life_context.dart
+++ b/app/lib/life_context/life_context.dart
@@ -21,6 +21,7 @@ import '../core/safe_log.dart';
 import '../journal/journal.dart';
 import '../journal/night_rules.dart';
 import '../settings/consents.dart';
+import '../settings/settings.dart';
 import '../settings/settings_controller.dart';
 import 'kept.dart';
 
@@ -34,6 +35,9 @@ final class LifeContext extends ChangeNotifier {
   /// Whether Life Context is on: consent (b) is given.
   bool get on => _settings.consents.given(Consent.lifeContext);
 
+  /// The Recent window as set (MP·84).
+  LifeContextLength get length => _settings.settings.length;
+
   /// Keeps the sentences of [text], said now in night [night], when Life
   /// Context is on. Returns how many were kept. Nothing calls it yet: its
   /// sources come with Questions and Reflection.
@@ -54,7 +58,6 @@ final class LifeContext extends ChangeNotifier {
   Future<List<Kept>> recent() async {
     if (!on) return const [];
     final today = dateOf(_journal.now(), _journal.zone);
-    final length = _settings.settings.length;
     return newestFirst([for (final k in await _journal.kept()) if (inWindow(k, today, length)) k]);
   }
 
@@ -65,7 +68,7 @@ final class LifeContext extends ChangeNotifier {
   Future<void> sweep() async {
     try {
       if (!on) return await _journal.deleteAllKept();
-      final gone = await _journal.sweepKept(_settings.settings.length);
+      final gone = await _journal.sweepKept(length);
       if (gone > 0) SafeLog.event(LogEvent.keptExpired, [gone]);
     } on Object {
       SafeLog.event(LogEvent.keptDeleteFailed);
diff --git a/app/lib/life_context/life_context_page.dart b/app/lib/life_context/life_context_page.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/life_context/life_context_page.dart
@@ -0,0 +1,447 @@
+// "What you've told Soul Dreams" (MP·86; C159-I item 1; D110, head's message
+// 24 item 2; D131; Design System §2, §3, §5, lifecontext.sentence), opened
+// from Settings, in SoulDreams Dev only: the back control top left and the
+// "⋯" menu top right (MP·88); the title in h2; then, when anything is kept,
+// two lists under their labels (MP·87): Kept longer, empty until its rule
+// exists (D131 item 5), and Recent with the window as set; each sentence in
+// quotation marks in its box, its date beneath in small grey, edit (MP·89)
+// at its left and delete in terracotta at its right; Delete all (MP·91) at
+// the foot. When nothing is kept, MP·92 alone.
+//
+// - Tapping a sentence opens its night. A night shows only its dreams for
+//   now, and nothing kept is ever from a dream, so nothing is marked there
+//   yet: the mark (in Bold, as search's, D131 item 3) comes with the part
+//   of a night that shows the sentence (Questions, Reflection).
+// - Edit turns the sentence's box into a field holding its words; Done on
+//   the keyboard, or leaving the field, keeps the edit, which changes only
+//   the kept copy (D131 item 2). Emptied, it is a deletion, and asks C4-P·4;
+//   Cancel keeps the sentence as it was.
+// - Select sentences: each box toggles its selection, a mark at its left;
+//   the foot shows Delete selected ({n}) (MP·90), which does nothing at 0;
+//   the back control leaves the selection first.
+// - Every deletion asks C4-P·4 once, the phone's standard dialog, Cancel
+//   (MP·61) first and Delete (MP·60) destructive (C4-P·4's flag).
+// The boxes, labels, icons and spacing are stand-ins (TO TRY, P13).
+import 'package:flutter/cupertino.dart';
+import 'package:flutter/material.dart';
+
+import '../core/app_line.dart';
+import '../core/language.dart';
+import '../design/palette.dart';
+import '../design/stand_ins.dart';
+import '../design/tokens.g.dart';
+import '../journal/night_rules.dart' show isEmptyText;
+import '../journal/pages/parts.dart';
+import '../journal/row_text.dart';
+import '../words/lines.g.dart';
+import 'kept.dart';
+import 'life_context.dart';
+
+/// A kept sentence as the page shows it: in quotation marks.
+String quoted(String text) => '“$text”';
+
+class LifeContextPage extends StatefulWidget {
+  const LifeContextPage({super.key, required this.lifeContext, this.openNight});
+
+  final LifeContext lifeContext;
+
+  /// Opens night [id], or null.
+  final Future<void> Function(String id)? openNight;
+
+  static const menuKey = Key('kept-menu');
+  static const selectKey = Key('kept-select');
+  static const deleteLongerKey = Key('kept-delete-longer');
+  static const deleteRecentKey = Key('kept-delete-recent');
+  static const deleteAllKey = Key('kept-delete-all');
+  static const deleteSelectedKey = Key('kept-delete-selected');
+  static const emptyKey = Key('kept-empty');
+  static const fieldKey = Key('kept-field');
+
+  /// A kept sentence's box, its words, edit and delete.
+  static Key sentenceKey(String id) => ValueKey('kept-$id');
+  static Key wordsKey(String id) => ValueKey('kept-words-$id');
+  static Key editKey(String id) => ValueKey('kept-edit-$id');
+  static Key deleteKey(String id) => ValueKey('kept-delete-$id');
+
+  @override
+  State<LifeContextPage> createState() => _LifeContextPageState();
+}
+
+class _LifeContextPageState extends State<LifeContextPage> {
+  LifeContext get _life => widget.lifeContext;
+
+  List<Kept> _recent = const [];
+  bool _loaded = false;
+  bool _selecting = false;
+  final _selected = <String>{};
+  String? _editing;
+  final _field = TextEditingController();
+  final _focus = FocusNode();
+
+  @override
+  void initState() {
+    super.initState();
+    _life.addListener(_load);
+    _focus.addListener(() {
+      if (!_focus.hasFocus) _finishEdit();
+    });
+    _load();
+  }
+
+  @override
+  void dispose() {
+    _life.removeListener(_load);
+    _field.dispose();
+    _focus.dispose();
+    super.dispose();
+  }
+
+  Future<void> _load() async {
+    final recent = await _life.recent();
+    if (!mounted) return;
+    setState(() {
+      _recent = recent;
+      _loaded = true;
+      _selected.retainAll({for (final k in recent) k.id});
+      if (recent.isEmpty) _selecting = false;
+    });
+  }
+
+  // C4-P·4, once: Cancel first, Delete destructive.
+  Future<bool> _confirm() async =>
+      await showCupertinoDialog<bool>(
+        context: context,
+        builder: (context) => CupertinoAlertDialog(
+          content: Text(Lines.C4_P_4.text(appLanguage)),
+          actions: [
+            CupertinoDialogAction(
+              onPressed: () => Navigator.of(context).pop(false),
+              child: Text(Lines.MP_61.text(appLanguage)),
+            ),
+            CupertinoDialogAction(
+              isDestructiveAction: true,
+              onPressed: () => Navigator.of(context).pop(true),
+              child: Text(Lines.MP_60.text(appLanguage)),
+            ),
+          ],
+        ),
+      ) ==
+      true;
+
+  Future<void> _delete(Set<String> ids) async {
+    if (!await _confirm()) return;
+    await _life.delete(ids);
+  }
+
+  Future<void> _deleteAll() async {
+    if (!await _confirm()) return;
+    await _life.deleteAll();
+  }
+
+  Future<void> _deleteSelected() async {
+    await _delete({..._selected});
+    if (mounted) setState(() => _selecting = _recent.isNotEmpty && _selecting);
+  }
+
+  void _startEdit(Kept k) {
+    setState(() {
+      _editing = k.id;
+      _field.text = k.text;
+    });
+    _focus.requestFocus();
+  }
+
+  // Keeps the edit; emptied, asks C4-P·4 first; Cancel keeps it as it was.
+  Future<void> _finishEdit() async {
+    final id = _editing;
+    if (id == null) return;
+    final text = _field.text;
+    setState(() => _editing = null);
+    final was = [
+      for (final k in _recent)
+        if (k.id == id) k.text,
+    ].firstOrNull;
+    if (was == null || text.trim() == was) return;
+    if (isEmptyText(text) && !await _confirm()) return;
+    await _life.edit(id, text);
+  }
+
+  void _tap(Kept k) {
+    if (_selecting) {
+      setState(() => _selected.contains(k.id) ? _selected.remove(k.id) : _selected.add(k.id));
+      return;
+    }
+    if (_editing != null) return;
+    final open = widget.openNight;
+    if (open != null) open(k.night).then((_) => _load());
+  }
+
+  void _back() {
+    if (_selecting) {
+      setState(() {
+        _selecting = false;
+        _selected.clear();
+      });
+      return;
+    }
+    Navigator.of(context).pop();
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final longer = _life.longer;
+    final empty = _recent.isEmpty && longer.isEmpty;
+    final labels = Lines.MP_87.parts(appLanguage);
+    return Scaffold(
+      body: SafeArea(
+        child: SingleChildScrollView(
+          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.journalEnd),
+          child: Column(
+            crossAxisAlignment: CrossAxisAlignment.stretch,
+            children: [
+              SizedBox(
+                height: StandIns.hitMin,
+                child: Stack(
+                  children: [
+                    Align(
+                      alignment: Alignment.topLeft,
+                      child: BackControl(onPressed: _back),
+                    ),
+                    if (!_selecting && !empty) Align(alignment: Alignment.topRight, child: _menu(p, longer)),
+                  ],
+                ),
+              ),
+              const SizedBox(height: StandIns.gap),
+              Semantics(
+                header: true,
+                child: Text(
+                  Lines.MP_86.text(appLanguage),
+                  textAlign: TextAlign.center,
+                  style: TypeRoles.h2.style(p.text),
+                ),
+              ),
+              const SizedBox(height: StandIns.gap),
+              if (!_loaded)
+                const SizedBox.shrink()
+              else if (empty)
+                AppLine(key: LifeContextPage.emptyKey, Lines.MP_92.text(appLanguage), style: StandIns.voiceApp(p.text))
+              else ...[
+                Center(child: _Label(labels.first)),
+                for (final k in longer) _sentence(p, k),
+                const SizedBox(height: StandIns.gap),
+                Center(child: _Label(labels[1 + _life.length.index])),
+                const SizedBox(height: Spacing.journalRow),
+                for (final k in _recent) _sentence(p, k),
+                const SizedBox(height: StandIns.listAbove),
+                SizedBox(
+                  width: double.infinity,
+                  child: _selecting
+                      ? DestructivePill(
+                          key: LifeContextPage.deleteSelectedKey,
+                          Lines.MP_90(n: _selected.length).text(appLanguage),
+                          onPressed: _selected.isEmpty ? null : _deleteSelected,
+                        )
+                      : DestructivePill(
+                          key: LifeContextPage.deleteAllKey,
+                          Lines.MP_91.text(appLanguage),
+                          onPressed: _deleteAll,
+                        ),
+                ),
+              ],
+            ],
+          ),
+        ),
+      ),
+    );
+  }
+
+  // The "⋯" menu (MP·88): Select sentences, and each list's deletion, for
+  // a list that holds anything.
+  Widget _menu(Palette p, List<Kept> longer) {
+    final words = Lines.MP_88.parts(appLanguage);
+    return CupertinoMenuAnchor(
+      consumeOutsideTaps: true,
+      menuChildren: [
+        CupertinoMenuItem(
+          key: LifeContextPage.selectKey,
+          onPressed: () => setState(() => _selecting = true),
+          child: Text(words[0]),
+        ),
+        if (longer.isNotEmpty)
+          CupertinoMenuItem(
+            key: LifeContextPage.deleteLongerKey,
+            onPressed: () => _delete({for (final k in longer) k.id}),
+            child: Text(words[1]),
+          ),
+        if (_recent.isNotEmpty)
+          CupertinoMenuItem(
+            key: LifeContextPage.deleteRecentKey,
+            onPressed: () => _delete({for (final k in _recent) k.id}),
+            child: Text(words[2]),
+          ),
+      ],
+      builder: (context, controller, _) => Semantics(
+        button: true,
+        child: GestureDetector(
+          key: LifeContextPage.menuKey,
+          behavior: HitTestBehavior.opaque,
+          onTap: () => controller.isOpen
+              ? controller.close()
+              : controller.open(position: const Offset(StandIns.menuWidth, StandIns.backSize + 8)),
+          child: SizedBox(
+            width: StandIns.menuWidth,
+            height: StandIns.hitMin,
+            child: Align(
+              alignment: Alignment.topCenter,
+              child: SizedBox(
+                width: StandIns.menuWidth,
+                height: StandIns.backSize,
+                child: DecoratedBox(
+                  decoration: BoxDecoration(
+                    gradient: LinearGradient(
+                      begin: Alignment.topCenter,
+                      end: Alignment.bottomCenter,
+                      colors: [p.buttonTop, p.buttonBottom],
+                    ),
+                    borderRadius: BorderRadius.circular(StandIns.backSize / 2),
+                    border: Border.all(color: p.buttonBorder),
+                  ),
+                  child: Icon(Icons.more_horiz, color: p.buttonText),
+                ),
+              ),
+            ),
+          ),
+        ),
+      ),
+    );
+  }
+
+  // A kept sentence: its box, edit at its left and delete at its right, or
+  // its selection mark while selecting.
+  Widget _sentence(Palette p, Kept k) {
+    final words = Lines.MP_89.parts(appLanguage);
+    final editing = _editing == k.id;
+    Widget icon(Key key, IconData data, Color colour, String label, VoidCallback onTap) => Semantics(
+      button: true,
+      label: label,
+      excludeSemantics: true,
+      child: GestureDetector(
+        key: key,
+        behavior: HitTestBehavior.opaque,
+        onTap: onTap,
+        child: SizedBox.square(
+          dimension: StandIns.hitMin,
+          child: Icon(data, size: StandIns.keptIcon, color: colour),
+        ),
+      ),
+    );
+    final selected = _selected.contains(k.id);
+    return Padding(
+      padding: const EdgeInsets.only(bottom: Spacing.journalRow),
+      child: DecoratedBox(
+        key: LifeContextPage.sentenceKey(k.id),
+        decoration: BoxDecoration(
+          gradient: LinearGradient(
+            begin: Alignment.topCenter,
+            end: Alignment.bottomCenter,
+            colors: [p.keptTop, p.keptBottom],
+          ),
+          borderRadius: BorderRadius.circular(Spacing.radius),
+          border: Border.all(color: p.keptBorder),
+        ),
+        child: Padding(
+          padding: StandIns.keptPadding,
+          child: Row(
+            children: [
+              if (_selecting)
+                Semantics(
+                  checked: selected,
+                  child: SizedBox.square(
+                    dimension: StandIns.hitMin,
+                    child: Icon(
+                      selected ? Icons.check_circle : Icons.radio_button_unchecked,
+                      size: StandIns.keptIcon,
+                      color: p.keptText,
+                    ),
+                  ),
+                )
+              else
+                icon(LifeContextPage.editKey(k.id), Icons.edit_outlined, p.keptText, words[0], () => _startEdit(k)),
+              Expanded(
+                child: editing
+                    ? TextField(
+                        key: LifeContextPage.fieldKey,
+                        controller: _field,
+                        focusNode: _focus,
+                        maxLines: null,
+                        textAlign: TextAlign.center,
+                        textInputAction: TextInputAction.done,
+                        onSubmitted: (_) => _focus.unfocus(),
+                        style: TypeRoles.voiceDreamer.style(p.keptText),
+                        decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true),
+                      )
+                    : GestureDetector(
+                        key: LifeContextPage.wordsKey(k.id),
+                        behavior: HitTestBehavior.opaque,
+                        onTap: () => _tap(k),
+                        child: Column(
+                          children: [
+                            Text(
+                              quoted(k.text),
+                              textAlign: TextAlign.center,
+                              style: TypeRoles.voiceDreamer.style(p.keptText),
+                            ),
+                            const SizedBox(height: StandIns.keptDateGap),
+                            Text(shownDate(k.day), style: TypeRoles.buttonSmall.style(p.keptDate)),
+                          ],
+                        ),
+                      ),
+              ),
+              if (!_selecting)
+                icon(
+                  LifeContextPage.deleteKey(k.id),
+                  Icons.delete_outline,
+                  p.keptDelete,
+                  words[1],
+                  () => _delete({k.id}),
+                )
+              else
+                const SizedBox(width: StandIns.hitMin),
+            ],
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// A list's label: a pill in color.tag.dream (a stand-in), heard as a
+/// heading.
+class _Label extends StatelessWidget {
+  const _Label(this.text);
+
+  final String text;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Semantics(
+      header: true,
+      child: DecoratedBox(
+        decoration: BoxDecoration(
+          gradient: LinearGradient(
+            begin: Alignment.topCenter,
+            end: Alignment.bottomCenter,
+            colors: [p.tagTop, p.tagBottom],
+          ),
+          borderRadius: BorderRadius.circular(Spacing.radius),
+        ),
+        child: Padding(
+          padding: StandIns.labelPadding,
+          child: Text(text, style: TypeRoles.button.style(p.tagText)),
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/lib/settings/settings_page.dart b/app/lib/settings/settings_page.dart
--- a/app/lib/settings/settings_page.dart
+++ b/app/lib/settings/settings_page.dart
@@ -9,14 +9,16 @@
 // below it (D128 item 6), opening the phone's menu: Language (EM·9; English
 // only, its name owed, D121 item 1), Word Animation (MP·26), Night images
 // (MP·85), Night/Day mode (MP·44), Life Context (MP·83) and Life Context
-// length (MP·84); then "Read disclosure & privacy" (MP·48) and "Delete
-// journal" (EM·11) in the destructive style. No feedback (D121 item 4), no
+// length (MP·84); then the row opening "What you've told Soul Dreams"
+// (MP·86, its flag; D121 item 2; D131), its name and a chevron; then "Read
+// disclosure & privacy" (MP·48) and "Delete journal" (EM·11) in the
+// destructive style. No feedback (D121 item 4), no
 // region, and no way to give or withdraw consent: each feature is the
 // dreamer's own act (D128 item 2).
 //
 // Life Context On shows its page (ConsentPage: Back, Turn on); Off asks MP·93
-// (what is kept goes). Before the dreamer has agreed, a tap on that row shows
-// the popup (MP·101, MP·102) and changes nothing; the Disclosure & privacy
+// (what is kept goes). Before the dreamer has agreed, a tap on that row, or
+// on MP·86's, shows the popup (MP·101, MP·102) and changes nothing; the Disclosure & privacy
 // page then ends with one button, MP·100, which agrees (D128 item 3). Night
 // images asks nothing (D125 item 8). Delete journal asks once (C4-P·4), then
 // everything goes and the app starts again (D110). Each confirmation is the
@@ -35,6 +37,8 @@ import '../journal/journal.dart';
 import '../journal/pages/parts.dart';
 import '../journal/pages/sky_mark.dart';
 import '../journal/sky.dart';
+import '../life_context/life_context.dart';
+import '../life_context/life_context_page.dart';
 import '../onboarding/disclosure_page.dart';
 import '../words/lines.g.dart';
 import '../words/pending.g.dart';
@@ -53,15 +57,22 @@ const owedLanguage = '[owed·language]';
 enum SettingRow { language, wordAnimation, nightImages, nightDay, lifeContext, length }
 
 class SettingsPage extends StatefulWidget {
-  const SettingsPage({super.key, required this.journal, required this.settings});
+  const SettingsPage({super.key, required this.journal, required this.settings, this.lifeContext, this.openNight});
 
   final Journal journal;
   final SettingsController settings;
 
+  /// Life Context, whose page MP·86's row opens, or null (no row).
+  final LifeContext? lifeContext;
+
+  /// Opens a night from Life Context's page, or null.
+  final Future<void> Function(String id)? openNight;
+
   static const toggleKey = Key('settings-toggle');
   static const disclosureKey = Key('settings-disclosure');
   static const agreeKey = Key('settings-agree');
   static const deleteKey = Key('settings-delete');
+  static const keptKey = Key('settings-kept');
 
   /// A row, whole.
   static Key rowKey(SettingRow row) => ValueKey('setting-row-${row.name}');
@@ -175,6 +186,15 @@ class _SettingsPageState extends State<SettingsPage> {
     ),
   );
 
+  // What you've told Soul Dreams (MP·86); before the dreamer has agreed, the
+  // popup, as for the Life Context row (D128 item 3).
+  Future<void> _openKept(LifeContext life) async {
+    if (!_c.agreed) return showAgreementPopup(context);
+    await Navigator.of(context).push(
+      MaterialPageRoute<void>(builder: (_) => LifeContextPage(lifeContext: life, openNight: widget.openNight)),
+    );
+  }
+
   void _length(int i) => _c.change(_c.settings.copyWith(length: LifeContextLength.values[i]));
 
   // Delete journal (D110): one confirmation; then everything goes, and the
@@ -248,6 +268,8 @@ class _SettingsPageState extends State<SettingsPage> {
               row(SettingRow.nightDay, Lines.MP_44, s.nightDay == NightDayMode.automatic ? 0 : 1, _nightDay),
               row(SettingRow.lifeContext, Lines.MP_83, c.given(Consent.lifeContext) ? 0 : 1, _lifeContext),
               row(SettingRow.length, Lines.MP_84, s.length.index, _length),
+              if (widget.lifeContext case final life?)
+                _PageRow(name: Lines.MP_86.text(appLanguage), onTap: () => _openKept(life)),
               const SizedBox(height: StandIns.listAbove),
               _action(
                 PlainButton(
@@ -257,7 +279,9 @@ class _SettingsPageState extends State<SettingsPage> {
                 ),
               ),
               const SizedBox(height: Spacing.journalRow),
-              _action(_Destructive(Lines.EM_11.parts(appLanguage).first, onPressed: _delete)),
+              _action(
+                DestructivePill(key: SettingsPage.deleteKey, Lines.EM_11.parts(appLanguage).first, onPressed: _delete),
+              ),
             ],
           ),
         ),
@@ -365,6 +389,50 @@ class _Row extends StatelessWidget {
   );
 }
 
+/// A row opening a page: a white rounded row as the settings' rows, its
+/// name and a chevron (a stand-in, TO TRY).
+class _PageRow extends StatelessWidget {
+  const _PageRow({required this.name, required this.onTap});
+
+  final String name;
+  final VoidCallback onTap;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Padding(
+      padding: const EdgeInsets.only(bottom: Spacing.journalRow),
+      child: Semantics(
+        button: true,
+        child: GestureDetector(
+          key: SettingsPage.keptKey,
+          behavior: HitTestBehavior.opaque,
+          onTap: onTap,
+          child: DecoratedBox(
+            decoration: surface(p),
+            child: ConstrainedBox(
+              constraints: const BoxConstraints(minHeight: StandIns.settingRowHeight),
+              child: Padding(
+                padding: StandIns.settingPadding,
+                child: Row(
+                  children: [
+                    Expanded(child: Text(name, style: TypeRoles.button.style(p.text))),
+                    const SizedBox(width: StandIns.searchGap),
+                    Padding(
+                      padding: const EdgeInsets.only(right: StandIns.searchGap),
+                      child: Chevron(colour: p.text, size: StandIns.settingChevron),
+                    ),
+                  ],
+                ),
+              ),
+            ),
+          ),
+        ),
+      ),
+    );
+  }
+}
+
 /// The quick toggle (MP·45): a 41 bordered circle in a 44 tap box, showing
 /// what it switches to: a moon in the light theme, drawn in the dark theme's
 /// page colour, and a sun in the dark (the sky mark's drawing; D125 item 7).
@@ -413,38 +481,3 @@ class _Toggle extends StatelessWidget {
     );
   }
 }
-
-/// Delete journal: a pill in color.destructive, white words (the Design
-/// System §2), told apart by its place and its word as well (§3).
-class _Destructive extends StatelessWidget {
-  const _Destructive(this.text, {required this.onPressed});
-
-  final String text;
-  final VoidCallback onPressed;
-
-  @override
-  Widget build(BuildContext context) {
-    const role = LightColours.destructive;
-    return Semantics(
-      button: true,
-      child: GestureDetector(
-        key: SettingsPage.deleteKey,
-        onTap: onPressed,
-        child: DecoratedBox(
-          decoration: BoxDecoration(
-            gradient: LinearGradient(
-              begin: Alignment.topCenter,
-              end: Alignment.bottomCenter,
-              colors: [role.colour!, role.colourEnd!],
-            ),
-            borderRadius: BorderRadius.circular(Spacing.radius),
-          ),
-          child: Padding(
-            padding: StandIns.buttonPadding,
-            child: Text(text, style: TypeRoles.button.style(role.text!)),
-          ),
-        ),
-      ),
-    );
-  }
-}
diff --git a/app/test/life_context/life_context_page_test.dart b/app/test/life_context/life_context_page_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/life_context/life_context_page_test.dart
@@ -0,0 +1,343 @@
+// "What you've told Soul Dreams" (MP·86 to MP·92; C159-I item 1; D110,
+// head's message 24 item 2; D131), opened from Settings: the two lists,
+// each sentence quoted and dated, edit and delete, the menu, selecting,
+// Delete all, the empty line; every deletion behind C4-P·4. The sentences
+// are the invented passages' (fixtures/invented-nights.json, R2).
+import 'package:flutter/cupertino.dart';
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/core/app_line.dart';
+import 'package:souldreams/design/palette.dart';
+import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/design/tokens.g.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/pages/journal_home.dart';
+import 'package:souldreams/journal/pages/journal_page.dart';
+import 'package:souldreams/journal/pages/night_page.dart';
+import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/life_context/kept.dart';
+import 'package:souldreams/life_context/life_context_page.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
+import 'package:souldreams/settings/settings_page.dart';
+import 'package:souldreams/words/lines.g.dart';
+import 'package:souldreams/words/pending.g.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+
+String en(Line line, [int part = 0]) => line.parts(Lang.en)[part];
+
+void main() {
+  late MemoryJournalFiles files;
+  late Journal journal;
+  late List<Night> nights;
+  final passages = [for (final n in inventedNights()) ...n.waking];
+
+  // The journal's home, Life Context [on], the window [length]; the
+  // passages [days] back kept into the first nights; then Settings, then
+  // the page.
+  Future<void> open(
+    WidgetTester tester, {
+    bool on = true,
+    bool agreed = true,
+    LifeContextLength length = LifeContextLength.twoWeeks,
+    List<int> days = const [1, 3],
+    bool page = true,
+    bool dark = false,
+  }) async {
+    tester.view.physicalSize = const Size(390, 844);
+    tester.view.devicePixelRatio = 1;
+    addTearDown(tester.view.reset);
+    JournalStore.newQueueForTests();
+    files = MemoryJournalFiles();
+    files.files[JournalStore.consentFile] = encodeConsents(
+      Consents.answered({Consent.readings: agreed, Consent.lifeContext: on}, DateTime.utc(2026)),
+    );
+    files.files[JournalStore.settingsFile] = encodeSettings(Settings(length: length));
+    final store = await JournalStore.open(files);
+    nights = nightsFromFixtures();
+    for (final n in nights) {
+      await store.save(n);
+    }
+    for (final (i, d) in days.indexed) {
+      final at = DateTime.now().toUtc().subtract(Duration(days: d));
+      await Journal(store, now: () => at).keep(nights[i].id, passages[i].text);
+    }
+    journal = Journal(store);
+    await tester.pumpWidget(
+      SoulDreamsApp(
+        clock: () => dark ? DateTime(2026, 6, 10, 23) : DateTime(2026, 6, 10, 12),
+        home: JournalHome(files: files),
+      ),
+    );
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(JournalPage.gearKey));
+    await tester.pumpAndSettle();
+    if (!page) return;
+    await tester.ensureVisible(find.byKey(SettingsPage.keptKey));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(SettingsPage.keptKey));
+    await tester.pumpAndSettle();
+  }
+
+  Future<void> tap(WidgetTester tester, Finder f) async {
+    await tester.ensureVisible(f);
+    await tester.pumpAndSettle();
+    await tester.tap(f);
+    await tester.pumpAndSettle();
+  }
+
+  Future<List<Kept>> kept() async => newestFirst(await journal.kept());
+
+  testWidgets('from Settings, the kept row opens the page, titled in h2', (tester) async {
+    await open(tester);
+    expect(find.byType(LifeContextPage), findsOneWidget);
+    final title = tester.widget<Text>(find.text(en(Lines.MP_86)));
+    expect(title.style!.fontFamily, TypeRoles.h2.family);
+    expect(title.style!.fontSize, TypeRoles.h2.size);
+  });
+
+  testWidgets('before agreeing, the kept row shows the popup, opens nothing', (tester) async {
+    await open(tester, agreed: false, on: false, days: const [], page: false);
+    await tap(tester, find.byKey(SettingsPage.keptKey));
+    expect(find.byType(LifeContextPage), findsNothing);
+    expect(find.text(PendingLines.MP_101.text(Lang.en)), findsOneWidget);
+  });
+
+  testWidgets('nothing kept: MP·92 alone, no lists, menu or Delete all', (tester) async {
+    await open(tester, days: const []);
+    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
+    expect(tester.widget<AppLine>(find.byKey(LifeContextPage.emptyKey)).text, en(Lines.MP_92));
+    expect(find.text(en(Lines.MP_87)), findsNothing);
+    expect(find.byKey(LifeContextPage.menuKey), findsNothing);
+    expect(find.byKey(LifeContextPage.deleteAllKey), findsNothing);
+  });
+
+  testWidgets('the lists: Kept longer empty; Recent newest first, quoted, dated', (tester) async {
+    await open(tester, length: LifeContextLength.oneMonth, days: const [3, 1, 40]);
+    final longer = tester.getCenter(find.text(en(Lines.MP_87, 0))).dy;
+    final recent = tester.getCenter(find.text(en(Lines.MP_87, 3))).dy;
+    expect(longer, lessThan(recent));
+    for (final i in [1, 2, 4]) {
+      expect(find.text(en(Lines.MP_87, i)), findsNothing);
+    }
+    final shown = (await kept()).where((k) => passages[2].sentences.every((s) => s != k.text)).toList();
+    expect(shown, hasLength(passages[0].sentences.length + passages[1].sentences.length));
+    final ys = <double>[];
+    for (final k in shown) {
+      final words = find.text(quoted(k.text));
+      expect(words, findsOneWidget);
+      expect(tester.getCenter(words).dy, greaterThan(recent));
+      ys.add(tester.getCenter(words).dy);
+      final date = find.descendant(
+        of: find.byKey(LifeContextPage.sentenceKey(k.id)),
+        matching: find.text(shownDate(k.day)),
+      );
+      expect(date, findsOneWidget);
+      expect(tester.getCenter(date).dy, greaterThan(tester.getCenter(words).dy));
+      expect(tester.widget<Text>(date).style!.color, LightColours.lifecontextDate.colour);
+      expect(tester.widget<Text>(date).style!.fontSize, TypeRoles.buttonSmall.size);
+    }
+    expect(ys, [...ys]..sort());
+    expect(shown.first.text, passages[1].sentences.first);
+    for (final s in passages[2].sentences) {
+      expect(find.text(quoted(s)), findsNothing);
+    }
+    expect(quoted(passages[0].sentences.first), '“${passages[0].sentences.first}”');
+  });
+
+  testWidgets('each sentence: edit left, delete right in terracotta, heard', (tester) async {
+    await open(tester);
+    final k = (await kept()).first;
+    final box = tester.getRect(find.byKey(LifeContextPage.sentenceKey(k.id)));
+    final edit = tester.getCenter(find.byKey(LifeContextPage.editKey(k.id)));
+    final delete = tester.getCenter(find.byKey(LifeContextPage.deleteKey(k.id)));
+    final words = tester.getCenter(find.text(quoted(k.text)));
+    expect(edit.dx, lessThan(words.dx));
+    expect(delete.dx, greaterThan(words.dx));
+    expect(box.contains(edit) && box.contains(delete), isTrue);
+    expect(tester.getSemantics(find.byKey(LifeContextPage.editKey(k.id))).label, en(Lines.MP_89, 0));
+    expect(tester.getSemantics(find.byKey(LifeContextPage.deleteKey(k.id))).label, en(Lines.MP_89, 1));
+    final icon = tester.widget<Icon>(
+      find.descendant(of: find.byKey(LifeContextPage.deleteKey(k.id)), matching: find.byType(Icon)),
+    );
+    expect(icon.color, LightColours.lifecontextDelete.colour);
+    final decoration =
+        tester.widget<DecoratedBox>(find.byKey(LifeContextPage.sentenceKey(k.id))).decoration as BoxDecoration;
+    expect((decoration.gradient! as LinearGradient).colors, [Palette.light.keptTop, Palette.light.keptBottom]);
+    expect(Palette.light.keptTop, LightColours.lifecontextBox.colour);
+  });
+
+  testWidgets('the dark theme: the dark box, its date, the proposed delete', (tester) async {
+    await open(tester, dark: true);
+    final k = (await kept()).first;
+    final icon = tester.widget<Icon>(
+      find.descendant(of: find.byKey(LifeContextPage.deleteKey(k.id)), matching: find.byType(Icon)),
+    );
+    expect(icon.color, StandIns.keptDeleteDark);
+    expect(StandIns.keptDeleteDark, const Color(0xFFD0775A));
+    final date = find.descendant(
+      of: find.byKey(LifeContextPage.sentenceKey(k.id)),
+      matching: find.text(shownDate(k.day)),
+    );
+    expect(tester.widget<Text>(date).style!.color, DarkColours.lifecontextDate.colour);
+    expect(tester.widget<Text>(find.text(quoted(k.text))).style!.color, DarkColours.lifecontextText.colour);
+    expect(Palette.dark.keptBottom, DarkColours.lifecontextBox.colourEnd);
+  });
+
+  testWidgets('delete one: C4-P·4 once; Cancel keeps it, Delete takes it', (tester) async {
+    await open(tester);
+    final [k, ...rest] = await kept();
+    await tap(tester, find.byKey(LifeContextPage.deleteKey(k.id)));
+    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
+    final cancel = find.ancestor(of: find.text(en(Lines.MP_61)), matching: find.byType(CupertinoDialogAction));
+    final go = find.ancestor(of: find.text(en(Lines.MP_60)), matching: find.byType(CupertinoDialogAction));
+    expect(tester.widget<CupertinoDialogAction>(go).isDestructiveAction, isTrue);
+    expect(tester.widget<CupertinoDialogAction>(cancel).isDestructiveAction, isFalse);
+    await tester.tap(find.text(en(Lines.MP_61)));
+    await tester.pumpAndSettle();
+    expect((await kept()).first, k);
+    await tap(tester, find.byKey(LifeContextPage.deleteKey(k.id)));
+    await tester.tap(find.text(en(Lines.MP_60)));
+    await tester.pumpAndSettle();
+    expect(await kept(), rest);
+    expect(find.text(quoted(k.text)), findsNothing);
+  });
+
+  testWidgets('Delete all asks once, then MP·92', (tester) async {
+    await open(tester);
+    final all = find.byKey(LifeContextPage.deleteAllKey);
+    expect(find.descendant(of: all, matching: find.text(en(Lines.MP_91))), findsOneWidget);
+    await tap(tester, all);
+    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
+    await tester.tap(find.text(en(Lines.MP_60)));
+    await tester.pumpAndSettle();
+    expect(await journal.kept(), isEmpty);
+    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
+  });
+
+  testWidgets('the menu: Select sentences and Delete the Recent list only', (tester) async {
+    await open(tester);
+    await tap(tester, find.byKey(LifeContextPage.menuKey));
+    expect(
+      find.descendant(of: find.byKey(LifeContextPage.selectKey), matching: find.text(en(Lines.MP_88, 0))),
+      findsOneWidget,
+    );
+    expect(
+      find.descendant(of: find.byKey(LifeContextPage.deleteRecentKey), matching: find.text(en(Lines.MP_88, 2))),
+      findsOneWidget,
+    );
+    // Kept longer holds nothing (D131 item 5): no deletion of it.
+    expect(find.byKey(LifeContextPage.deleteLongerKey), findsNothing);
+    await tester.tap(find.byKey(LifeContextPage.deleteRecentKey));
+    await tester.pumpAndSettle();
+    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
+    await tester.tap(find.text(en(Lines.MP_60)));
+    await tester.pumpAndSettle();
+    expect(await journal.kept(), isEmpty);
+    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
+  });
+
+  testWidgets('selecting: each box toggles; Delete selected (n); back leaves', (tester) async {
+    await open(tester);
+    final [a, b, ...rest] = await kept();
+    await tap(tester, find.byKey(LifeContextPage.menuKey));
+    await tester.tap(find.byKey(LifeContextPage.selectKey));
+    await tester.pumpAndSettle();
+    expect(find.byKey(LifeContextPage.editKey(a.id)), findsNothing);
+    expect(find.byKey(LifeContextPage.deleteKey(a.id)), findsNothing);
+    expect(find.byKey(LifeContextPage.menuKey), findsNothing);
+    final selected = find.byKey(LifeContextPage.deleteSelectedKey);
+    expect(find.descendant(of: selected, matching: find.text(en(Lines.MP_90(n: 0)))), findsOneWidget);
+    await tap(tester, selected);
+    expect(find.text(en(Lines.C4_P_4)), findsNothing);
+    await tap(tester, find.byKey(LifeContextPage.wordsKey(a.id)));
+    await tap(tester, find.byKey(LifeContextPage.wordsKey(b.id)));
+    await tap(tester, find.byKey(LifeContextPage.wordsKey(b.id)));
+    await tap(tester, find.byKey(LifeContextPage.wordsKey(rest.first.id)));
+    expect(find.descendant(of: selected, matching: find.text(en(Lines.MP_90(n: 2)))), findsOneWidget);
+    expect(find.byType(NightPage), findsNothing);
+    await tap(tester, selected);
+    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
+    await tester.tap(find.text(en(Lines.MP_60)));
+    await tester.pumpAndSettle();
+    expect(await kept(), [b, ...rest.skip(1)]);
+    // The back control leaves selecting first, then the page.
+    await tap(tester, find.descendant(of: find.byType(LifeContextPage), matching: find.byType(BackControl)));
+    expect(find.byKey(LifeContextPage.deleteAllKey), findsOneWidget);
+    expect(find.byType(LifeContextPage), findsOneWidget);
+  });
+
+  testWidgets('edit: the field holds the words; Done keeps only the copy', (tester) async {
+    await open(tester);
+    final k = (await kept()).first;
+    await tap(tester, find.byKey(LifeContextPage.editKey(k.id)));
+    expect(tester.widget<TextField>(find.byKey(LifeContextPage.fieldKey)).controller!.text, k.text);
+    await tester.enterText(find.byKey(LifeContextPage.fieldKey), passages[2].sentences.first);
+    await tester.testTextInput.receiveAction(TextInputAction.done);
+    await tester.pumpAndSettle();
+    expect(find.byKey(LifeContextPage.fieldKey), findsNothing);
+    final edited = (await kept()).firstWhere((e) => e.id == k.id);
+    expect(edited.text, passages[2].sentences.first);
+    expect(find.text(quoted(passages[2].sentences.first)), findsOneWidget);
+    expect(await journal.night(k.night), nights.firstWhere((n) => n.id == k.night));
+  });
+
+  testWidgets('an edit emptied asks C4-P·4; Cancel keeps the sentence', (tester) async {
+    await open(tester);
+    final [k, ...rest] = await kept();
+    await tap(tester, find.byKey(LifeContextPage.editKey(k.id)));
+    await tester.enterText(find.byKey(LifeContextPage.fieldKey), '  ');
+    await tester.testTextInput.receiveAction(TextInputAction.done);
+    await tester.pumpAndSettle();
+    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
+    await tester.tap(find.text(en(Lines.MP_61)));
+    await tester.pumpAndSettle();
+    expect((await kept()).first, k);
+    await tap(tester, find.byKey(LifeContextPage.editKey(k.id)));
+    await tester.enterText(find.byKey(LifeContextPage.fieldKey), '');
+    await tester.testTextInput.receiveAction(TextInputAction.done);
+    await tester.pumpAndSettle();
+    await tester.tap(find.text(en(Lines.MP_60)));
+    await tester.pumpAndSettle();
+    expect(await kept(), rest);
+  });
+
+  testWidgets('tapping a sentence opens its night', (tester) async {
+    await open(tester);
+    final k = (await kept()).first;
+    await tap(tester, find.byKey(LifeContextPage.wordsKey(k.id)));
+    expect(find.byType(NightPage), findsOneWidget);
+    expect(tester.widget<NightPage>(find.byType(NightPage)).id, k.night);
+    expect(tester.widget<NightPage>(find.byType(NightPage)).query, isNull);
+  });
+
+  testWidgets('Life Context turned off in Settings: the page shows MP·92', (tester) async {
+    await open(tester, page: false);
+    await tester.ensureVisible(find.byKey(SettingsPage.valueKey(SettingRow.lifeContext)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(SettingsPage.valueKey(SettingRow.lifeContext)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(SettingsPage.choiceKey(SettingRow.lifeContext, 1)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.text(en(Lines.MP_94)));
+    await tester.pumpAndSettle();
+    expect(await journal.kept(), isEmpty);
+    await tap(tester, find.byKey(SettingsPage.keptKey));
+    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
+  });
+
+  testWidgets('at the largest text, nothing overflows', (tester) async {
+    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await open(tester);
+    expect(tester.takeException(), isNull);
+    await tap(tester, find.byKey(LifeContextPage.deleteAllKey));
+    expect(tester.takeException(), isNull);
+  });
+}
diff --git a/app/test/settings/settings_page_test.dart b/app/test/settings/settings_page_test.dart
--- a/app/test/settings/settings_page_test.dart
+++ b/app/test/settings/settings_page_test.dart
@@ -102,7 +102,7 @@ void main() {
     expect(tester.widget<CupertinoDialogAction>(back).isDestructiveAction, isFalse);
   }
 
-  testWidgets('the page: its title, six rows, then three actions', (tester) async {
+  testWidgets('the page: its title, six rows, the kept row, the actions', (tester) async {
     await open(tester);
     expect(find.text(en(Lines.MP_25)), findsOneWidget);
     final names = [
@@ -112,6 +112,7 @@ void main() {
       'Night/Day mode',
       'Life Context',
       'Life Context length',
+      en(Lines.MP_86),
     ];
     final ys = [for (final n in names) tester.getCenter(find.text(n)).dy];
     expect(ys, [...ys]..sort());
@@ -129,9 +130,11 @@ void main() {
     // D128 item 2: no Give or Withdraw consent, no row for it.
     expect(find.text(en(Lines.MP_95, 0)), findsNothing);
     expect(find.text(en(Lines.MP_95, 1)), findsNothing);
-    // Nothing of Feedback (D121 item 4) or of what Life Context keeps.
+    // Nothing of Feedback (D121 item 4); What you've told Soul Dreams is the
+    // row after the six (MP·86's flag; D131), above the actions.
     expect(find.text(en(Lines.MP_49)), findsNothing);
-    expect(find.text(en(Lines.MP_86)), findsNothing);
+    final page = tester.getCenter(find.byKey(SettingsPage.keptKey)).dy;
+    expect(tester.getCenter(find.byKey(SettingsPage.disclosureKey)).dy, greaterThan(page));
     final delete = tester.getCenter(find.byKey(SettingsPage.deleteKey)).dy;
     expect(tester.getCenter(find.byKey(SettingsPage.disclosureKey)).dy, lessThan(delete));
   });
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2430,8 +2430,8 @@ ROWS = [
      '',
      'test/journal/pages/journal_search_test.dart', 'the settings button: the field beside it'),
     ('A568', 'lib/journal/pages/journal_page.dart',
-     '_Gear(onPressed: () => _push(SettingsPage(journal: widget.journal, settings: settings))),',
-     '_Gear(onPressed: () {}),',
+     '                    onPressed: () => _push(\n                      SettingsPage(',
+     '                    onPressed: () => (\n                      SettingsPage(',
      'test/journal/pages/journal_search_test.dart', 'the settings button: the field beside it'),
     ('A569', 'lib/journal/pages/sky_mark.dart',
      'SizedBox.fromSize(size: size,',
@@ -2440,7 +2440,7 @@ ROWS = [
     ('A570', 'lib/settings/settings_page.dart',
      '      value: choices[chosen],\n',
      '',
-     'test/settings/settings_page_test.dart', 'the page: its title, six rows, then three actions'),
+     'test/settings/settings_page_test.dart', 'the page: its title, six rows, the kept row, the actions'),
     ('A571', 'lib/journal/pages/journal_home.dart',
      'instant: opening);',
      'instant: false);',
@@ -2679,8 +2679,8 @@ ROWS = [
      '      recording: widget.recording,\n    );',
      'test/journal/pages/night_page_test.dart', 'before agreeing: Add dreams opens a typing screen with the microphone'),
     ('A658', 'lib/settings/settings_page.dart',
-     '    if (!_c.agreed) return showAgreementPopup(context);\n',
-     '',
+     '    if (!_c.agreed) return showAgreementPopup(context);\n    final on = i == 0;',
+     '    final on = i == 0;',
      'test/settings/settings_page_test.dart', 'before agreeing: Life Context shows the popup, changes nothing'),
     ('A659', 'lib/settings/settings_page.dart',
      'builder: (context, _) => _c.agreed\n',
@@ -2906,6 +2906,114 @@ ROWS = [
      '    _lifeContext?.dispose();\n    _lifeContext = null;\n',
      '    _lifeContext = null;\n',
      'test/journal/pages/journal_home_test.dart', 'after the journal is deleted, a new I consent opens it'),
+    ('A715', 'lib/life_context/life_context_page.dart',
+     "String quoted(String text) => '“$text”';",
+     'String quoted(String text) => text;',
+     'test/life_context/life_context_page_test.dart', 'the lists: Kept longer empty; Recent newest first, quoted, dated'),
+    ('A716', 'lib/life_context/life_context_page.dart',
+     '              else if (empty)',
+     '              else if (false)',
+     'test/life_context/life_context_page_test.dart', 'nothing kept: MP·92 alone, no lists, menu or Delete all'),
+    ('A717', 'lib/life_context/life_context_page.dart',
+     'if (!_selecting && !empty) Align(',
+     'if (!_selecting) Align(',
+     'test/life_context/life_context_page_test.dart', 'nothing kept: MP·92 alone, no lists, menu or Delete all'),
+    ('A718', 'lib/life_context/life_context_page.dart',
+     'labels[1 + _life.length.index]',
+     'labels[2]',
+     'test/life_context/life_context_page_test.dart', 'the lists: Kept longer empty; Recent newest first, quoted, dated'),
+    ('A719', 'lib/life_context/life_context_page.dart',
+     'onPressed: _selected.isEmpty ? null : _deleteSelected,',
+     'onPressed: _deleteSelected,',
+     'test/life_context/life_context_page_test.dart', 'selecting: each box toggles; Delete selected (n); back leaves'),
+    ('A720', 'lib/life_context/life_context_page.dart',
+     '    if (!await _confirm()) return;\n    await _life.delete(ids);',
+     '    await _life.delete(ids);',
+     'test/life_context/life_context_page_test.dart', 'delete one: C4-P·4 once; Cancel keeps it, Delete takes it'),
+    ('A721', 'lib/life_context/life_context_page.dart',
+     '    if (!await _confirm()) return;\n    await _life.deleteAll();',
+     '    await _life.deleteAll();',
+     'test/life_context/life_context_page_test.dart', 'Delete all asks once, then MP·92'),
+    ('A722', 'lib/life_context/life_context_page.dart',
+     '        if (longer.isNotEmpty)\n',
+     '        if (true)\n',
+     'test/life_context/life_context_page_test.dart', 'the menu: Select sentences and Delete the Recent list only'),
+    ('A723', 'lib/life_context/life_context_page.dart',
+     '        if (_recent.isNotEmpty)\n          CupertinoMenuItem(',
+     '        if (false)\n          CupertinoMenuItem(',
+     'test/life_context/life_context_page_test.dart', 'the menu: Select sentences and Delete the Recent list only'),
+    ('A724', 'lib/life_context/life_context_page.dart',
+     '    if (isEmptyText(text) && !await _confirm()) return;',
+     '    if (isEmptyText(text)) return;',
+     'test/life_context/life_context_page_test.dart', 'an edit emptied asks C4-P·4; Cancel keeps the sentence'),
+    ('A725', 'lib/life_context/life_context_page.dart',
+     '      if (!_focus.hasFocus) _finishEdit();\n',
+     '',
+     'test/life_context/life_context_page_test.dart', 'edit: the field holds the words; Done keeps only the copy'),
+    ('A726', 'lib/life_context/life_context_page.dart',
+     'setState(() => _selected.contains(k.id) ? _selected.remove(k.id) : _selected.add(k.id));',
+     'setState(() => _selected.add(k.id));',
+     'test/life_context/life_context_page_test.dart', 'selecting: each box toggles; Delete selected (n); back leaves'),
+    ('A727', 'lib/life_context/life_context_page.dart',
+     '  void _back() {\n    if (_selecting) {',
+     '  void _back() {\n    if (false) {',
+     'test/life_context/life_context_page_test.dart', 'selecting: each box toggles; Delete selected (n); back leaves'),
+    ('A728', 'lib/life_context/life_context_page.dart',
+     '    if (open != null) open(k.night).then((_) => _load());\n',
+     '',
+     'test/life_context/life_context_page_test.dart', 'tapping a sentence opens its night'),
+    ('A729', 'lib/life_context/life_context_page.dart',
+     '                  Icons.delete_outline,\n                  p.keptDelete,',
+     '                  Icons.delete_outline,\n                  p.keptText,',
+     'test/life_context/life_context_page_test.dart', 'each sentence: edit left, delete right in terracotta, heard'),
+    ('A730', 'lib/life_context/life_context_page.dart',
+     'TypeRoles.buttonSmall.style(p.keptDate)',
+     'TypeRoles.buttonSmall.style(p.keptText)',
+     'test/life_context/life_context_page_test.dart', 'the lists: Kept longer empty; Recent newest first, quoted, dated'),
+    ('A731', 'lib/life_context/life_context_page.dart',
+     '      label: label,\n',
+     '',
+     'test/life_context/life_context_page_test.dart', 'each sentence: edit left, delete right in terracotta, heard'),
+    ('A732', 'lib/life_context/life_context_page.dart',
+     '    _life.addListener(_load);\n',
+     '',
+     'test/life_context/life_context_page_test.dart', 'Delete all asks once, then MP·92'),
+    ('A733', 'lib/design/palette.dart',
+     '    keptDelete: StandIns.keptDeleteDark,',
+     '    keptDelete: DarkColours.lifecontextDate.colour!,',
+     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the proposed delete'),
+    ('A734', 'lib/design/palette.dart',
+     '    keptDate: DarkColours.lifecontextDate.colour!,',
+     '    keptDate: DarkColours.lifecontextText.colour!,',
+     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the proposed delete'),
+    ('A735', 'lib/design/stand_ins.dart',
+     'keptDeleteDark = Color(0xFFD0775A);',
+     'keptDeleteDark = Color(0xFF8F3D24);',
+     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the proposed delete'),
+    ('A736', 'lib/settings/settings_page.dart',
+     '    if (!_c.agreed) return showAgreementPopup(context);\n    await Navigator',
+     '    await Navigator',
+     'test/life_context/life_context_page_test.dart', 'before agreeing, the kept row shows the popup, opens nothing'),
+    ('A737', 'lib/settings/settings_page.dart',
+     'onTap: () => _openKept(life)),',
+     'onTap: () {}),',
+     'test/life_context/life_context_page_test.dart', 'from Settings, the kept row opens the page, titled in h2'),
+    ('A738', 'lib/journal/pages/journal_page.dart',
+     '                        lifeContext: widget.lifeContext,\n',
+     '',
+     'test/settings/settings_page_test.dart', 'the page: its title, six rows, the kept row, the actions'),
+    ('A739', 'lib/journal/pages/journal_page.dart',
+     '                        openNight: _openNight,\n',
+     '',
+     'test/life_context/life_context_page_test.dart', 'tapping a sentence opens its night'),
+    ('A740', 'lib/journal/pages/journal_home.dart',
+     '        lifeContext: _lifeContext,\n',
+     '',
+     'test/settings/settings_page_test.dart', 'the page: its title, six rows, the kept row, the actions'),
+    ('A741', 'lib/design/palette.dart',
+     '    keptTop: LightColours.lifecontextBox.colour!,',
+     '    keptTop: LightColours.page.colour!,',
+     'test/life_context/life_context_page_test.dart', 'each sentence: edit left, delete right in terracotta, heard'),
 ]
 
 
```

Commit message:

```
Life Context's page, What you've told Soul Dreams, from Settings: the two lists, edit, delete, select, Delete all (MP·86 to MP·92; D110; D131)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
```

### Task 5 · SoulDreams Dev's invented kept sentences (D131 item 1)

`tool/preview_kept.py` and its test; `life_context/preview.dart`; `JournalStore.flagged` and `flag`; the home
seeds before the journal opens (at launch and after "I agree"); `main_dev.dart` passes `PREVIEW_KEPT`;
`previewSeedFailed` in `SafeLog`.

Tests: `test/life_context/preview_test.dart` (4, new), `test/journal/pages/journal_home_test.dart` (1 new; the
entry-point text test follows `main_dev.dart`), `tool/checks/tests/test_preview_kept.py` (2, new: run
`python3 -I -B tool/checks/tests/run_tests.py test_preview_kept`, expected `OK`). 744 → 749.

Rows: A742 to A752; A341 follows its code. Then `--files lib/main_dev.dart,lib/life_context/preview.dart,lib/journal/journal_store.dart,lib/journal/pages/journal_home.dart,lib/core/safe_log.dart`
(81 run, 81 caught on the build).

```
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -111,6 +111,10 @@ enum LogEvent {
   keptExpired,
   keptKeepFailed,
   keptDeleteFailed,
+
+  /// SoulDreams Dev's invented kept sentences (D131 item 1) could not be
+  /// seeded.
+  previewSeedFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/journal_store.dart b/app/lib/journal/journal_store.dart
--- a/app/lib/journal/journal_store.dart
+++ b/app/lib/journal/journal_store.dart
@@ -320,6 +320,13 @@ final class JournalStore {
 
   Future<void> markFirstUseSeen() => _run(() => _files.write(firstUseFlag, Uint8List(0)));
 
+  /// Whether the empty flag file [name] is here (SoulDreams Dev's preview,
+  /// `life_context/preview.dart`); removed with the journal.
+  Future<bool> flagged(String name) => _run(() async => (await _files.list()).contains(name));
+
+  /// Keeps the empty flag file [name].
+  Future<void> flag(String name) => _run(() => _files.write(name, Uint8List(0)));
+
   /// The consents, or null when none is kept or the file does not read as
   /// version 1 or 2 exactly: onboarding then asks again.
   Future<Consents?> consents() => _run(() async {
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -20,7 +20,9 @@
 // microphone and Start Interpretation show a popup when tapped, and nothing is
 // sent. It holds Life Context too (`LifeContext`, D131 item 4): what is past
 // its window is deleted when the journal opens, when the app comes back, and
-// at each local midnight while it is open.
+// at each local midnight while it is open. Built with tool/preview_kept.py's
+// file, it seeds the invented kept sentences once, before the journal opens
+// (`preview`, D131 item 1).
 import 'dart:async';
 
 import 'package:flutter/material.dart';
@@ -30,6 +32,7 @@ import '../../core/app_line.dart' show wordAnimation;
 import '../../core/night_day.dart';
 import '../../core/safe_log.dart';
 import '../../life_context/life_context.dart';
+import '../../life_context/preview.dart';
 import '../../onboarding/onboarding.dart';
 import '../../recording/recording.dart';
 import '../../settings/consents.dart';
@@ -51,6 +54,7 @@ class JournalHome extends StatefulWidget {
     this.recording,
     this.nightAction,
     this.read = noneRead,
+    this.preview = '',
   });
 
   final JournalFiles files;
@@ -68,6 +72,10 @@ class JournalHome extends StatefulWidget {
   /// Whether a night has been read (D110): none is yet.
   final ReadCheck read;
 
+  /// SoulDreams Dev's invented kept sentences, as tool/preview_kept.py
+  /// writes them, or empty (D131 item 1).
+  final String preview;
+
   @override
   State<JournalHome> createState() => _JournalHomeState();
 }
@@ -143,6 +151,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
         SafeLog.event(LogEvent.settingsReadFailed);
       }
     }
+    if (consents != null) await _seed(store, consents);
     if (!mounted) return;
     _store = store;
     _journal = journal;
@@ -207,11 +216,22 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     } on Object {
       SafeLog.event(LogEvent.consentKeepFailed);
     }
+    await _seed(_store!, consents);
     // Not reset here: a tap that lands before onboarding has left the tree
     // must not open the journal twice. `_onboard` resets it.
     if (mounted) _enter(consents, const Settings());
   }
 
+  // The invented kept sentences, once, before the journal opens (D131 item
+  // 1); a seed that fails logs a code and the journal opens as it is.
+  Future<void> _seed(JournalStore store, Consents consents) async {
+    try {
+      await seedPreview(store, widget.preview, lifeContext: consents.given(Consent.lifeContext));
+    } on Object {
+      SafeLog.event(LogEvent.previewSeedFailed);
+    }
+  }
+
   // The journal deleted, the consents and settings with it (D110): every
   // page above closes, the retries stop, the settings return to their
   // defaults, and onboarding starts again.
diff --git a/app/lib/life_context/preview.dart b/app/lib/life_context/preview.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/life_context/preview.dart
@@ -0,0 +1,65 @@
+// SoulDreams Dev's invented kept sentences (D131 item 1), for the owner's
+// by-eye review of Life Context's page. Built with the file
+// tool/preview_kept.py writes (--dart-define-from-file), SoulDreams Dev
+// seeds its journal once: the invented nights that have waking passages
+// (fixtures/invented-nights.json, R2), dated from today to ten weeks back so
+// each window shows a different list, and their passages kept as Life
+// Context keeps them, only while it is on. A flag file marks it done;
+// deleting the journal takes it, and the next agreement seeds again. Only
+// JournalHome reaches it, so no tester or founder build does.
+import 'dart:convert';
+import 'dart:math';
+
+import '../journal/journal.dart';
+import '../journal/journal_store.dart';
+import '../journal/night.dart';
+import '../journal/night_rules.dart';
+import '../words/lines.g.dart' show Lang;
+
+/// How many days back each invented night is dated, in turn.
+const previewDaysBack = [0, 5, 12, 25, 70];
+
+/// The flag file that marks the seed done.
+const previewFlag = 'preview-kept-seeded';
+
+/// Seeds [store] from [define] once, keeping the passages only when
+/// [lifeContext] is on. Nothing without [define]; a [define] that does not
+/// read throws a [FormatException] and seeds nothing.
+Future<void> seedPreview(
+  JournalStore store,
+  String define, {
+  required bool lifeContext,
+  DateTime Function()? now,
+  Zone zone = const PhoneZone(),
+  Random? random,
+}) async {
+  if (define.isEmpty || await store.flagged(previewFlag)) return;
+  final nights = jsonDecode(define);
+  if (nights is! List) throw const FormatException('preview');
+  final read = [
+    for (final n in nights)
+      if (n case {'lang': String lang, 'dreams': List<Object?> dreams, 'waking': List<Object?> waking})
+        (Lang.values.byName(lang), dreams.cast<String>(), waking.cast<String>())
+      else
+        throw const FormatException('preview'),
+  ];
+  final today = (now ?? () => DateTime.now().toUtc())();
+  for (final (i, (lang, dreams, waking)) in read.indexed) {
+    final at = today.subtract(Duration(days: previewDaysBack[i % previewDaysBack.length]));
+    final night = Night(
+      id: newNightId(random),
+      firstRecorded: at,
+      date: dateOf(at, zone),
+      closes: closesAfter(at, zone),
+      lang: lang,
+      dreams: dreams,
+    );
+    await store.save(night);
+    if (!lifeContext) continue;
+    final journal = Journal(store, zone: zone, now: () => at, random: random);
+    for (final w in waking) {
+      await journal.keep(night.id, w);
+    }
+  }
+  await store.flag(previewFlag);
+}
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -4,6 +4,8 @@
 // (D107; D108; R8 lets this file and main_founder.dart import it). Built
 // with --dart-define=PREVIEW_READ=true, every night shows as read, for the
 // owner's by-eye review of a read night's look (D110); nothing is stored.
+// Built with tool/preview_kept.py's file, it seeds the invented kept
+// sentences once, for the review of Life Context's page (D131 item 1).
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -44,7 +46,7 @@ void main() {
     SoulDreamsApp(
       home: const bool.fromEnvironment('KEYBOARD_CHECK')
           ? const KeyboardCheck()
-          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read),
+          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT')),
     ),
   );
   if (check != null) unawaited(check);
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -249,10 +249,14 @@ void main() {
 
   test('SoulDreams Dev hands its phone check and recording to the list', () {
     final text = File('lib/main_dev.dart').readAsStringSync();
-    // With each night's export (D108).
+    // With each night's export (D108), and the invented kept sentences of a
+    // build made for the by-eye review (D131 item 1).
     expect(
       text,
-      contains('JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read)'),
+      contains(
+        'JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, '
+        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'))",
+      ),
     );
     // Every night read only in a build made for the by-eye preview (D110).
     expect(text, contains("bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead"));
@@ -700,4 +704,44 @@ void main() {
     expect(lines, contains('keptExpired ${passages[2].sentences.length}'));
     await tester.pumpWidget(const SizedBox());
   });
+
+  // D131 item 1: SoulDreams Dev built with the preview seeds the invented
+  // kept sentences before the journal opens, from onboarding's "I agree"
+  // too; a seed that fails logs a code and the journal opens.
+  testWidgets('the preview seeds before the journal opens; a failure, a code', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    final define = jsonEncode([
+      for (final n in inventedNights())
+        if (n.waking.isNotEmpty) {'lang': n.lang, 'dreams': n.dreams, 'waking': [for (final w in n.waking) w.text]},
+    ]);
+    final files = MemoryJournalFiles();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, preview: define)));
+    await tester.pumpAndSettle();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(
+      const {Consent.readings: true, Consent.lifeContext: true},
+    );
+    await tester.pumpAndSettle();
+    final journal = Journal(await JournalStore.open(files));
+    expect(await journal.kept(), isNotEmpty);
+    expect(find.byType(JournalPage), findsOneWidget);
+    expect(lines.where((l) => l.startsWith('preview')), isEmpty);
+    await tester.pumpWidget(const SizedBox());
+    // Life Context off: the nights, no sentence.
+    final off = answered(MemoryJournalFiles(), const {Consent.readings: true, Consent.lifeContext: false});
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: off, preview: define)));
+    await tester.pumpAndSettle();
+    final offJournal = Journal(await JournalStore.open(off));
+    expect(await offJournal.newestFirst(), isNotEmpty);
+    expect(await offJournal.kept(), isEmpty);
+    await tester.pumpWidget(const SizedBox());
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), preview: '[1]')));
+    await tester.pumpAndSettle();
+    expect(lines, contains('previewSeedFailed'));
+    expect(find.byType(JournalPage), findsOneWidget);
+    await tester.pumpWidget(const SizedBox());
+  });
 }
diff --git a/app/test/life_context/preview_test.dart b/app/test/life_context/preview_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/life_context/preview_test.dart
@@ -0,0 +1,88 @@
+// SoulDreams Dev's invented kept sentences (D131 item 1): seeded once from
+// what tool/preview_kept.py writes (the invented nights with waking
+// passages, fixtures/invented-nights.json, R2), dated back, kept only while
+// Life Context is on.
+import 'dart:convert';
+import 'dart:math';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/life_context/preview.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+import '../journal/zones.dart';
+
+/// What tool/preview_kept.py carries into a Dev build.
+String previewDefine() => jsonEncode([
+  for (final n in inventedNights())
+    if (n.waking.isNotEmpty)
+      {
+        'lang': n.lang,
+        'dreams': n.dreams,
+        'waking': [for (final w in n.waking) w.text],
+      },
+]);
+
+void main() {
+  late MemoryJournalFiles files;
+  late JournalStore store;
+  final now = DateTime.utc(2026, 11, 22, 9);
+  final withWaking = [
+    for (final n in inventedNights())
+      if (n.waking.isNotEmpty) n,
+  ];
+
+  setUp(() async {
+    JournalStore.newQueueForTests();
+    files = MemoryJournalFiles();
+    store = await JournalStore.open(files);
+  });
+
+  Future<void> seed(String define, {bool on = true}) =>
+      seedPreview(store, define, lifeContext: on, now: () => now, zone: const FixedZone(1), random: Random(8));
+
+  test('without the define, nothing is seeded', () async {
+    await seed('');
+    expect(files.files, isEmpty);
+  });
+
+  test('each invented night, dated back, its passages kept; once', () async {
+    await seed(previewDefine());
+    final nights = await store.nights();
+    expect(nights, hasLength(withWaking.length));
+    final back = [for (final n in nights) now.difference(n.firstRecorded).inDays]..sort();
+    expect(back, [for (var i = 0; i < withWaking.length; i++) previewDaysBack[i % previewDaysBack.length]]..sort());
+    expect({for (final n in nights) n.entries.length}, {for (final n in withWaking) n.dreams.length});
+    final journal = Journal(store);
+    final kept = await journal.kept();
+    expect(
+      [for (final k in kept) k.text],
+      [
+        for (final n in withWaking)
+          for (final w in n.waking) ...w.sentences,
+      ],
+    );
+    for (final k in kept) {
+      expect(nights.firstWhere((n) => n.id == k.night).date, k.day);
+    }
+    expect(files.files.containsKey(previewFlag), isTrue);
+    await seed(previewDefine());
+    expect(await store.nights(), hasLength(nights.length));
+    expect(await journal.kept(), kept);
+  });
+
+  test('Life Context off: the nights, and no sentence', () async {
+    await seed(previewDefine(), on: false);
+    expect(await store.nights(), hasLength(withWaking.length));
+    expect(await Journal(store).kept(), isEmpty);
+  });
+
+  test('a define that does not read seeds nothing', () async {
+    for (final bad in ['{', '{"a":1}', '[{"lang":"en"}]', '[1]']) {
+      await expectLater(seed(bad), throwsFormatException, reason: bad);
+    }
+    expect(files.files, isEmpty);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1572,8 +1572,8 @@ ROWS = [
      'try bytes.data.write(to: url, options: [])\n      let sheet',
      'test/founder/native_test.dart', 'the file is written with complete protection, in tmp'),
     ('A341', 'lib/main_dev.dart',
-     ', nightAction: const FounderExport().action, read: read)',
-     ', read: read)',
+     ', nightAction: const FounderExport().action, read: read, preview:',
+     ', read: read, preview:',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A342', 'lib/main.dart',
      "import 'core/safe_log.dart';\n",
@@ -3014,6 +3014,50 @@ ROWS = [
      '    keptTop: LightColours.lifecontextBox.colour!,',
      '    keptTop: LightColours.page.colour!,',
      'test/life_context/life_context_page_test.dart', 'each sentence: edit left, delete right in terracotta, heard'),
+    ('A742', 'lib/life_context/preview.dart',
+     '  if (define.isEmpty || await store.flagged(previewFlag)) return;',
+     '  if (define.isEmpty) return;',
+     'test/life_context/preview_test.dart', 'each invented night, dated back, its passages kept; once'),
+    ('A743', 'lib/life_context/preview.dart',
+     '  await store.flag(previewFlag);\n',
+     '',
+     'test/life_context/preview_test.dart', 'each invented night, dated back, its passages kept; once'),
+    ('A744', 'lib/life_context/preview.dart',
+     '    if (!lifeContext) continue;\n',
+     '',
+     'test/life_context/preview_test.dart', 'Life Context off: the nights, and no sentence'),
+    ('A745', 'lib/life_context/preview.dart',
+     'previewDaysBack[i % previewDaysBack.length]',
+     'previewDaysBack[0]',
+     'test/life_context/preview_test.dart', 'each invented night, dated back, its passages kept; once'),
+    ('A746', 'lib/life_context/preview.dart',
+     "  if (nights is! List) throw const FormatException('preview');\n",
+     '',
+     'test/life_context/preview_test.dart', 'a define that does not read seeds nothing'),
+    ('A747', 'lib/life_context/preview.dart',
+     "      else\n        throw const FormatException('preview'),\n",
+     '',
+     'test/life_context/preview_test.dart', 'a define that does not read seeds nothing'),
+    ('A748', 'lib/journal/journal_store.dart',
+     '(await _files.list()).contains(name));',
+     '(await _files.list()).contains(firstUseFlag));',
+     'test/life_context/preview_test.dart', 'each invented night, dated back, its passages kept; once'),
+    ('A749', 'lib/journal/pages/journal_home.dart',
+     '    if (consents != null) await _seed(store, consents);\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the preview seeds before the journal opens; a failure, a code'),
+    ('A750', 'lib/journal/pages/journal_home.dart',
+     '    await _seed(_store!, consents);\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the preview seeds before the journal opens; a failure, a code'),
+    ('A751', 'lib/journal/pages/journal_home.dart',
+     '      SafeLog.event(LogEvent.previewSeedFailed);\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the preview seeds before the journal opens; a failure, a code'),
+    ('A752', 'lib/main_dev.dart',
+     ", preview: const String.fromEnvironment('PREVIEW_KEPT'))",
+     ')',
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
 ]
 
 
diff --git a/tool/checks/tests/test_preview_kept.py b/tool/checks/tests/test_preview_kept.py
new file mode 100644
--- /dev/null
+++ b/tool/checks/tests/test_preview_kept.py
@@ -0,0 +1,42 @@
+# tool/preview_kept.py: the Dev build's invented kept sentences (D131 item
+# 1) come whole from fixtures/invented-nights.json, and nothing else.
+import json
+import os
+import sys
+import tempfile
+import unittest
+
+from helpers import CHECKS
+
+sys.path.insert(0, os.path.dirname(CHECKS))
+
+import preview_kept  # noqa: E402
+
+
+class PreviewKept(unittest.TestCase):
+    def test_every_night_with_waking_passages_whole(self):
+        with open(preview_kept.FIXTURES, encoding='utf-8') as f:
+            nights = json.load(f)['nights']
+        out = preview_kept.preview()
+        self.assertEqual(list(out), ['PREVIEW_KEPT'])
+        chosen = json.loads(out['PREVIEW_KEPT'])
+        want = [n for n in nights if n.get('waking')]
+        self.assertTrue(want)
+        self.assertEqual(len(chosen), len(want))
+        for c, n in zip(chosen, want):
+            self.assertEqual(c, {'lang': n['lang'], 'dreams': n['dreams'],
+                                 'waking': [w['text'] for w in n['waking']]})
+
+    def test_writes_the_define_file_only_with_one_path(self):
+        d = tempfile.mkdtemp(prefix='preview-')
+        path = os.path.join(d, 'preview-kept.json')
+        self.assertEqual(preview_kept.main([]), 2)
+        self.assertEqual(preview_kept.main([path]), 0)
+        with open(path, encoding='utf-8') as f:
+            self.assertEqual(json.load(f), preview_kept.preview())
+        os.remove(path)
+        os.rmdir(d)
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tool/preview_kept.py b/tool/preview_kept.py
new file mode 100644
--- /dev/null
+++ b/tool/preview_kept.py
@@ -0,0 +1,37 @@
+# SoulDreams Dev's invented kept sentences (D131 item 1), for the owner's
+# by-eye review of Life Context's page. Writes the file a Dev build reads
+# through --dart-define-from-file: the invented nights that have waking
+# passages, read from fixtures/invented-nights.json (R2), the one place they
+# live, so nothing invented is copied into the repository. Run from the
+# repository root, then build SoulDreams Dev as usual adding
+# --dart-define-from-file="$TMPDIR/preview-kept.json":
+#   python3 -I -B tool/preview_kept.py "$TMPDIR/preview-kept.json"
+# It writes only that file, prints nothing, and exits 0; 2 without a path.
+import json
+import os
+import sys
+
+TOP = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
+FIXTURES = os.path.join(TOP, 'fixtures', 'invented-nights.json')
+
+
+def preview(fixtures=FIXTURES):
+    with open(fixtures, encoding='utf-8') as f:
+        nights = json.load(f)['nights']
+    chosen = [
+        {'lang': n['lang'], 'dreams': n['dreams'], 'waking': [w['text'] for w in n['waking']]}
+        for n in nights if n.get('waking')
+    ]
+    return {'PREVIEW_KEPT': json.dumps(chosen, ensure_ascii=False, separators=(',', ':'))}
+
+
+def main(argv):
+    if len(argv) != 1:
+        return 2
+    with open(argv[0], 'w', encoding='utf-8') as f:
+        json.dump(preview(), f, ensure_ascii=False)
+    return 0
+
+
+if __name__ == '__main__':
+    sys.exit(main(sys.argv[1:]))
```

Commit message:

```
SoulDreams Dev: the invented kept sentences, seeded once from the fixture through tool/preview_kept.py (D131 item 1)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
```

### Task 6 · Docs: Status.md, the Dev-only test and the table's header

Status.md (the branch, the road ahead, Life Context under "The app", the counts, banked items 167 and 168, "Rulings
during life-context" with D131 and `faster-mutations`' merge); `dev_only_test.dart` covers `lib/life_context/`;
`tool/app_mutations.py`'s header: `A1 to A753`, `713 run, 713 caught`.

Tests: 749 (no new test; two assertions). Rows: A753.

```
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -71,6 +71,8 @@ void main() {
       expect(files.where((f) => f.startsWith('lib/onboarding/')), isEmpty);
       // Settings and the consents (D122): SoulDreams Dev only.
       expect(files.where((f) => f.startsWith('lib/settings/')), isEmpty);
+      // Life Context, its page and Dev's invented sentences (D131): Dev only.
+      expect(files.where((f) => f.startsWith('lib/life_context/')), isEmpty);
       expect(files, isNot(contains(pending)));
     });
   }
@@ -87,6 +89,16 @@ void main() {
     expect(files, contains('lib/recording/record_microphone.dart'));
     expect(files, containsAll(['lib/onboarding/onboarding.dart', 'lib/onboarding/disclosure_page.dart']));
     expect(files, containsAll(['lib/founder/founder_export.dart', 'lib/founder/export_text.dart']));
+    expect(
+      files,
+      containsAll([
+        'lib/life_context/sentences.dart',
+        'lib/life_context/kept.dart',
+        'lib/life_context/life_context.dart',
+        'lib/life_context/life_context_page.dart',
+        'lib/life_context/preview.dart',
+      ]),
+    );
   });
 
   // R8, D108: the journal's pages, which testers will get, carry only the
diff --git a/docs/Status.md b/docs/Status.md
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-22, in branch `faster-mutations` (the full app mutation run in parallel, D129 and D130; the merge next), by Claude Code.
+Last updated: 2026-11-22, in branch `life-context` (Life Context, the mechanical part, D110 item 2 and D131; the owner's by-eye review next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,16 +14,21 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`faster-mutations`: the full app mutation run in parallel, each worker in its own copy of `app/` (D129, D130; plan
-`docs/plans/faster-mutations.md`). A tooling change only: nothing in `app/` or `server/`.
-`redesign-c` (Settings, the settings button and the agreement, D110, D121 to D128) is merged (`cc2ea8c`); its Status was
-not updated at the merge (this entry records it). `redesign-b` is merged (`8243128`), likewise.
+`life-context`: Life Context, the mechanical part (D110, head's message 24 item 2; C159-I item 1; D127; D128; D131; plan
+`docs/plans/life-context.md`): what counts as a sentence, the kept sentences on the phone, the Recent window's sweep,
+Off deleting what is kept, the page "What you've told Soul Dreams" from Settings, and SoulDreams Dev's invented kept
+sentences. Nothing calls the capture yet: a night holds only dreams, and its real sources come with Questions and
+Reflection. The kept-longer choice and the readings' use of kept words wait (D110 item 2).
+`faster-mutations` (the parallel mutation run, D129, D130) is merged (`79fbf6a`); its Status was not updated at the
+merge (this entry records it).
 
 ## Road ahead
 
-- `faster-mutations`: the merge (its full parallel run is done, see "The app" and "Rulings during faster-mutations").
-- Then Life Context (its page, MP·86 to MP·92, and what is kept), with C159-I's import, and "Made by AI"; Feedback, with
-  its server change (D121 item 4). The curated set of night paintings (about 60, the founder's)
+- `life-context`: the owner's by-eye review (plan Task 7), the Product questions (banked item 167), then the full
+  mutation run before the merge (D126).
+- Then "Made by AI"; Feedback, with its server change (D121 item 4). Life Context's sources (the opening's answers,
+  what is said after it, the reflection, Waking Life) come with Questions and Reflection, and with them the mark on a
+  tapped sentence's night (D131 item 3). The curated set of night paintings (about 60, the founder's)
   replaces the placeholders, fingerprinted as the fonts are (a G0 and G2 change, the owner's).
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1); the pending lines are filed at
   C17-P (and, for the founder app, with his export).
@@ -299,12 +304,37 @@ not updated at the merge (this entry records it). `redesign-b` is merged (`82431
   fade (off, instant, as with Reduce Motion), Night/Day mode through `NightDayChoice` above the app. A change that
   cannot be kept logs `settingsKeepFailed` or `consentKeepFailed` and holds until the app closes; a read that fails, `settingsReadFailed`, and the defaults stand. No
   feedback (D121 item 4), no region, no Help (R9).
+- Life Context (C159-I item 1; D110, head's message 24 item 2; D127; D128; D131; `app/lib/life_context/`, SoulDreams
+  Dev only; TO TRY where a stand-in): what is kept is each sentence of the dreamer's words said in a night outside the
+  dream, word for word (`sentences.dart`: a sentence ends at `.`, `!`, `?` or `…` with any closing quotes, then a space
+  or the end, and at a line break; no abbreviation list), each with the phone's date when it was said and its night.
+  Nothing calls the capture yet (`LifeContext.capture`): a night holds only dreams. Kept in `kept.json` in the
+  journal's folder (version 1, written whole and renamed; nothing kept, no file), only into a night whose file is
+  there; deleting a night deletes its sentences first (X11), and at open sentences whose night is gone go
+  (`keptOrphansSwept`); a file that does not read shows nothing (`keptFileSkipped`) and the next change replaces it.
+  On is consent (b): Off keeps nothing and deletes what is kept (a failed deletion logs `keptDeleteFailed`; the next
+  opening's sweep deletes it). The Recent window (MP·84) by the calendar: a sentence is in it while its date is later
+  than today less the length; older ones go when the journal opens, when the app comes back and at each local
+  midnight while it is open (D131 item 4; `keptExpired` with the count). The page (`life_context_page.dart`), from
+  Settings' row MP·86 under Life Context length (before agreeing, the popup): the back control, the "⋯" menu (MP·88:
+  Select sentences, and a list's deletion only for a list holding anything), MP·86 in h2, then Kept longer (MP·87,
+  empty until its rule exists, D131 item 5) and Recent with the window as set, each sentence in “ ” in its box
+  (color.lifecontext.*; the light box edged with the surface's grey), its date (dd/mm/yy) beneath in
+  type.button.small, edit (MP·89) at its left and delete at its right (#8F3D24; in the dark #D0775A, proposed by C18-P,
+  a stand-in); Delete all (MP·91) at the foot; MP·92 alone when nothing is kept. Edit makes the box a field: Done or
+  leaving keeps the edit, the kept copy only (D131 item 2); emptied, it asks C4-P·4. Selecting: each box toggles,
+  Delete selected ({n}) (MP·90) at the foot, the back control leaves the selection. Every deletion asks C4-P·4 once.
+  Tapping a sentence opens its night, nothing marked yet (D131 item 3 waits for the parts that show it). The labels
+  take color.tag.dream (a stand-in). SoulDreams Dev built with the file `tool/preview_kept.py` writes
+  (`--dart-define-from-file`) seeds, once (the flag file `preview-kept-seeded`), the invented nights that have waking
+  passages, dated 0, 5, 12, 25 and 70 days back, their passages kept only while Life Context is on (D131 item 1).
 - `type.voice.app` is read at line height 1.3, the founder's override of the filed 1.5 (`StandIns.voiceApp`; the
   generated token keeps 1.5; D125 item 1; for Product's next filing).
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 690 tests, and 624 mutation checks (A1 to A664; A24ah,
+- The app's analyzer baseline: `No issues found!`. The app has 749 tests (691 at the branch's start: `cc2ea8c` added
+  one after the 690 written here), and 713 mutation checks (A1 to A753; A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
   A277, A278, A281, A288, A291, A300, A301, A302, A313, A363, A375, A507, A518, A521, A526, A527, A530, A537, A538, A539, A540, A541, A543, A546, A549, A550, A553, A554, A558, A566, A574, A575, A578, A583, A585 to A600, A610, A623, A624, A626, A627, A629, A633, A634, A635, A645 and A646
   dropped, each with its reason in the file; with the rows A24a to
@@ -1015,6 +1045,14 @@ Banked in redesign-c (D91; none changes what the dreamer sees beyond D110, D121
      where the serial way shows it differently; the tests that look at real time check lower bounds only (plan Part 1,
      finding 7); (c) the comparison script does not itself prove a copy is put back between rows; the unit test
      `test_each_row_puts_its_copy_back` does (M8).
+167. For Product, through the head (`life-context`, D91; plan Part 4): the questions on Life Context's page, built as
+     leaned and shown as stand-ins: the quotation marks, the labels' colour, the dark delete icon, the page with nothing
+     kept and while Off, the menu's items, leaving a selection, editing without words, MP·86's row, the date's form,
+     the order, and the tapped sentence's mark.
+168. Life Context notes (`life-context`, D91): what counts as a sentence has no abbreviation list ("Dr." ends one); a
+     sentence's date is the day it was said, and the window counts by it; the sweep also runs when the app comes back
+     (a day may have passed away from it); the seed's own Life Context gate (`lifeContext:`) is not seen from the
+     journal's home, whose opening sweep deletes everything kept while Off (a row for it would survive, so none).
 
 ## Before Cohort 1
 
@@ -1465,6 +1503,14 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   same both ways) and on those two rows being the only difference between the two full runs, explained by their
   changed tests. D91 and D126 apply.
 
+## Rulings during life-context
+
+- `faster-mutations` merged by the owner (`79fbf6a`).
+- D131 (owner, the brainstorm): (1) a Dev-only set of invented kept sentences (fixtures) so the page can be seen; (2)
+  editing changes only the kept copy, never the night's text; (3) the marked sentence on its night in Bold, as
+  search's; (4) expiry: sentences older than the chosen length are deleted at launch and once a day while open; (5)
+  "Kept longer" shows its heading and stays empty until its rule exists. D91 and D126 apply.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,12 +3,12 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A664, A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A753, A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 624 run, 624 caught", exit 0. Each row breaks one thing in app/ (with --serial, in
+# mutations: 713 run, 713 caught", exit 0. Each row breaks one thing in app/ (with --serial, in
 # place; else in a worker's copy), runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
@@ -3058,6 +3058,10 @@ ROWS = [
      ", preview: const String.fromEnvironment('PREVIEW_KEPT'))",
      ')',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
+    ('A753', 'lib/main.dart',
+     "import 'core/safe_log.dart';\n",
+     "import 'core/safe_log.dart';\n// ignore: unused_import\nimport 'life_context/sentences.dart';\n",
+     'test/dev_only_test.dart', 'lib/main.dart reaches no journal, onboarding or recording code, no pending line'),
 ]
 
 
```

Commit message:

```
Status.md and the Dev-only test for Life Context (D131)

Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>
```

### Task 7 · [OWNER] The by-eye review, SoulDreams Dev, invented nights only

By eye only, in SoulDreams Dev built from this branch. No real night anywhere near it.

**The build.** From the repository root, write the preview file (it reads only `fixtures/invented-nights.json` and
prints nothing):

```
cd ~/Developer/soul-dreams-app && python3 -I -B tool/preview_kept.py "$TMPDIR/preview-kept.json" && echo written
```

Expected: `written`. Then build and install SoulDreams Dev as usual, adding
`--dart-define-from-file="$TMPDIR/preview-kept.json"` beside your usual `--dart-define-from-file` for the key.

Check each step in the light theme and, where it says so, in the dark one. If any result differs, stop and bring it to
the Build chat. Nothing is fixed on the phone.

**The storage rehearsal** (docs/workflow.md (c), step 2):

1. **The update.** Install over the SoulDreams Dev you have now, which holds invented nights and was agreed to.
   - The journal opens with no onboarding, every night you had is there, and five more invented nights appear: today,
     5, 12, 25 and 70 days ago.
   - Settings reads as before. With Life Context Off, the nights come without sentences: turn it On, delete the
     journal and agree again, and both are seeded.

**The page:**

2. **The row.** Settings: under "Life Context length", a white row "What you've told Soul Dreams" with a small
   chevron. A tap opens the page.
3. **The page** (Life Context On, length 2 weeks).
   - Back top left, "⋯" top right, "What you've told Soul Dreams" large.
   - The label "Kept longer", with nothing under it.
   - The label "Recent – the last 2 weeks", then the sentences of the nights of today, 5 and 12 days ago (not 25 or 70),
     newest first, each in “ ” in a white rounded box, its date beneath (dd/mm/yy) in small grey, a pencil at its left
     and a terracotta bin at its right.
   - "Delete all" at the foot, in the terracotta style.
4. **The window.** Back to Settings; length 1 month: the page also shows the night of 25 days ago. 3 months: also 70.
   Then 1 week: only today's and 5 days ago.
5. **Tapping a sentence** opens its night (its dreams; nothing marked yet). Back returns to the page.
6. **Edit.** The pencil: the box becomes a field with the words. Change a word, then Done on the keyboard: the box shows
   the change. Open its night: its dreams are unchanged.
7. **Edit to nothing.** The pencil, clear the words, Done: "Are you sure you want to delete this?…" with Cancel and
   Delete. Cancel: the sentence is back as it was. Again, Delete: it is gone.
8. **Delete one.** A bin: the same question; Cancel keeps it; Delete removes it.
9. **The menu.** "⋯": "Select sentences" and "Delete the Recent list" (no "Delete the Kept longer list" while it is
   empty).
10. **Selecting.** "Select sentences": the pencils and bins go, each box has a round mark at its left, the foot reads
    "Delete selected (0)" and does nothing. Tap two boxes: "Delete selected (2)"; tap one again: (1). Back leaves the
    selection (the pencils and bins return); back again leaves the page. Select two and delete them: the question
    once, then they are gone.
11. **Delete the Recent list.** The question once; then only "What you share about your waking life will appear here."
12. **The window's sweep.** Delete the journal (Settings), agree again: the invented nights and sentences are seeded
    again. Set length to 1 week, close the app fully and open it: the sentences older than a week are gone for good
    (back to 3 months: they do not return).
13. **Off.** Life Context Off: "Turning Life Context off deletes everything…" with Cancel and Turn off. Turn off; the
    page shows only the empty line. Turn it On again (its page, Back / Turn on): still nothing kept.
14. **Delete all.** With sentences again (delete the journal and agree, as in 12): Delete all, the question once, then
    the empty line.
15. **Deleting a night.** With sentences again: delete the night of today from its "⋯" menu; on the page its
    sentences are gone, the others stay.
16. **Before agreeing.** Delete the journal and choose "I don't agree": Settings' row shows the popup and opens
    nothing.
17. **The dark theme** (the toggle): the boxes take the dark surface, the words light, the date a lighter grey, the
    bin a lighter terracotta (#D0775A, proposed).
18. **Large text** (the phone's largest): the page scrolls, nothing overlaps or is cut.

**The founder's verdict, TO TRY** (P13):

19. The boxes' edge and padding, the labels' blue (from the screen), the icons, the date's size, the row in Settings,
    and the dark bin's colour.

## Part 4 · Questions (numbered; a blank is not a yes)

None stops this plan: each is built as leaned, as a stand-in where it is a look, and none changes what D110, D127,
D128 or D131 rule. Q1 to Q11 go to Product through the head (banked item 167); Q12 to Q14 are the owner's.

For Product:
1. **The quotation marks.** Built: “…” in both languages (the app shows English only, D57). Lean: Product names the
   Swedish marks (”…”) for when Swedish is shown. If otherwise: one helper, `quoted`, changes.
2. **The list labels' colour.** No role is filed for them; built in `color.tag.dream` (the blue read from the founder's
   screen). Lean: Product files a role. If otherwise: one palette pair.
3. **The dark theme's delete icon.** C18-P proposed #D0775A for the founder to approve (#8F3D24 fails, 1.45:1). Built
   with #D0775A as a stand-in. Lean: approve it.
4. **The page with nothing kept.** Built: MP·92 alone, no labels, no menu, no Delete all; with anything kept, both
   labels, Kept longer empty under its heading (D131 item 5). Lean: as built. If Product wants the headings always,
   the empty line sits under Recent.
5. **The page while Off.** Off keeps nothing, so the page shows MP·92, "What you share about your waking life will
   appear here.", which is not true while Off. Lean: Product writes a line for Off, or rules that MP·92 stands. Until
   then MP·92.
6. **The menu's items.** Built: Select sentences, and a list's deletion only while that list holds anything; no menu
   when nothing is kept, nor while selecting. Lean: as built.
7. **Leaving a selection.** No line exists for it (MP·61 "Cancel" belongs to the confirmation only, its never). Built:
   the back control leaves the selection first. Lean: as built, or Product files a word.
8. **Editing without words.** The box becomes a field; Done (the keyboard's own word) or leaving it keeps the edit;
   emptied, it is a deletion behind C4-P·4. Lean: as built.
9. **MP·86's row in Settings.** Its flag says "the Settings row that opens it"; main-path.md does not place it. Built:
   right under Life Context length, a row with a chevron. Lean: as built, for main-path.md's next pass.
10. **The date's form and order.** Built: dd/mm/yy as a night's date (D112), in type.button.small; newest day first,
    in the order said within a day. Lean: as built.
11. **The tapped sentence's mark.** Nothing kept is from a dream, and a night's page shows only dreams, so the mark
    (D131 item 3) waits for Questions and Reflection; the night opens unmarked. Lean: as built.

For the owner:
12. **The sweep on return** (decided under D91, item 7): also on every return to the app, beyond D131 item 4's "at
    launch and once a day while open". Lean: keep it. If not: one line in the journal's home.
13. **What counts as a sentence** (D91 item 5): no abbreviation list, so "Dr." ends a sentence. Lean: keep, and the
    Build chat names it to Interpretation when the sources arrive.
14. **The sentence's date is the day it was said**, not its night's date (D91 item 2), and the window counts by it.
    Lean: keep.

## Part 5 · How this plan was proven

1. **The build.** Built task by task in a copy of the tracked tree, `./.scratch/lc/build`, from `git archive` of
   `79fbf6a`, each task's state kept as a snapshot (`./.scratch/lc/snaps/s<task>`).
   - Each block in Part 3 is `git diff --no-index` between two snapshots, its `a/s<n>/` and `b/s<n>/` prefixes
     rewritten and its `index` lines left out.
   - Left out of every snapshot: harness files (`.claude/`), `.fvm`, `.dart_tool`, the app's `build/`, the generated
     iOS files and Python's `__pycache__`.
2. **The counts measured on each snapshot:** app tests 691 (the baseline), 697, 719, 729, 744, 749, 749, with
   `No issues found!` at each.
3. **Test first.** Each task's new and changed test files, put on the snapshot before it, failed: every one in Tasks
   1 to 5 at loading, but `journal_home_test.dart` in Task 3, which loaded and failed its new test, and
   `fixtures_test.dart` in Task 1, which passed, since it pins the fixture its own block brings (as Task 6's Dev-only
   assertions pin Tasks 1 to 5; their rows bite: A753).
4. **Mutations on the build** (D126, every row of the files changed):
   - Task 1: `7 run, 7 caught` (A666 first survived on the line-break test and was aimed at the exact one).
   - Task 2: the new rows, `24 run, 24 caught`; the changed files, `70 run, 70 caught`.
   - Task 3: the changed files, `53 run, 52 caught`, then all caught once the Recent test's dates were put out of
     order (A699 first survived: the kept order happened to be newest first).
   - Task 4: the new rows, `27 run, 27 caught`; the changed files, `177 run, 175 caught`, then all caught once A568
     and A658 followed their code.
   - Task 5: the new rows, all caught but the seed's gate seen from the home, dropped before it was added (Part 1,
     D91 item 12); the changed files, `81 run, 81 caught`.
   - Task 6: `1 run, 1 caught`.
5. **The guards** on each snapshot: `guards (walk): all passed`. During the build G4 refused five test names of
   twelve words or more, each shortened, and G3 one unmarked pattern literal, now marked.
6. **Replayed on a fresh copy**, `./.scratch/lc/replay`, from `git archive` of `79fbf6a`.
   - Every block applied with `git apply` in order, with `GIT_CEILING_DIRECTORIES` set so `git apply` is not
     silently skipped inside the repository.
   - After each block the tree was compared with its snapshot: no difference.
   - On the replayed tree: `guards (walk): all passed`, `No issues found!`, `+749: All tests passed!`, and its 93 new
     and followed rows (A665 to A753, A341, A568, A570, A658) `93 run, 93 caught`.
   - The guard tests: all pass on the build but `test_check_all`, which copies the tracked tree with git and cannot
     in a copy with no repository; it passes in the repository itself (`Ran 2 tests … OK`). `test_preview_kept`:
     `OK`.
7. **Not run in the sandbox:** the full app mutation run (D126: once, after the owner's look, before the merge), and
   `tool/check_all.sh` whole (the owner's).

*No matter where you are on your journey, the steps you take are equally important.*
