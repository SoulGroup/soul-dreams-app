# Plan: the journal and a night's page, to the new design (redesign-a)

Branch `redesign-a`, from `main` at `a2580db`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D95. Written by Claude Code (Opus) on 2026-11-21. The owner's checks are by eye only (D99).

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

The journal and a night's page take the new design the founder ruled on 2026-11-20 (D110: head's message 24, with
message 25 on the night's image). The journal opens on a greeting that changes with the time of day, and under it a
"New Dream" button that opens the typing screen. The round record button goes. Each night is a rounded row carrying
only its date, laid over the night's picture. A night that has not been read shows a painted gradient rather than a
picture. Naming a night is gone. A night's page opens on a header with the night's picture and its date, with the back
control and the menu over it. A read night also gets four jump buttons: Dreams, Questions, Readings and Reflection.
Word Animation is on by default, but only for the app's responses.

Nothing can be read yet, since the readings come later, so every night shows the gradient and no jump buttons. To let
the owner see a read night's look, SoulDreams Dev built with one extra switch shows every night as read. The curated
set of night paintings is not filed, so five placeholder paintings, drawn in code, stand in its place. Product still
owes the words: the four greetings, New Dream and the four jump buttons. Until they are filed, each shows a provisional
handle in square brackets, as R1 has every missing line do.

### What this branch builds

1. **Word by word only for the app's responses, on by default** (D110, superseding D106 2's "off everywhere").
   `wordAnimation` becomes `true`. `AppLine` gains `response` (default `false`), and only a response appears word by
   word. No response is built yet, so nothing on screen changes: every line shown today stays whole. Reduce Motion
   and a screen reader behave as before. The theme's fade is unchanged.
2. **The greeting** (`journal/greeting.dart`, plain Dart). The part of the day comes from the phone's wall clock:
   morning from 05:00, afternoon from 12:00, evening from 17:00, night from 21:00 (the dark theme's hour). Each part
   has its owed greeting. It is shown centred in h2 and heard as a heading, and it follows the clock while the page is
   open (checked each minute) and on returning.
3. **New Dream.** A pill on the painted gradient (radius 30), its words in the button type in the gradient's text
   colour, centred under the greeting and heard as a button. It opens the typing screen exactly as the record button
   did: one screen at a time, and nothing opens on a failed read.
4. **The record button is removed** (`RecordButton`, `StandIns.recordWidth`, `recordHeight` and `recordBelow` go).
5. **A row** carries only its date, centred in h6 in the gradient's text colour, over the night's picture. The row is
   clipped to radius 30, at least 64 tall, 30 from the screen's sides and 12 apart, and heard as a button named by its
   date. The summary, its three-line measure and the chevron go. The month dividers and C4-P·5 stay as built.
6. **The first empty journal**: MP·9 under New Dream, with the drawn arrow between them now pointing up to it. Still
   shown once.
7. **A night's look** (`journal/night_look.dart`, plain Dart). A read night shows painting `paintingFor(id, count)`,
   which is the id's first 32 bits modulo the set's size: chosen from the id alone, so from none of the night's words,
   always the same, and nothing stored. An unread night shows the painted gradient, as does any night while the set is
   empty. `ReadCheck`: `noneRead` everywhere, and `allRead` only for SoulDreams Dev's preview.
8. **The picture** (`journal/pages/night_art.dart`). The painted gradient is the dark theme's bubble gradient
   (#3D376E → #26214F) in both themes, with words over a picture in the dark theme's text colour (#F5F5EC). Both are
   stand-ins. Five placeholder paintings (dusk, dawn, the sea, the forest, the night) are drawn as a sky gradient, a
   soft light and two ridges: no file, no package, no words. The picture adds nothing a screen reader hears.
9. **A night's page.** The header is 240 tall below the status bar, with the picture from the screen's top. The back
   control and the "⋯" pill sit over it, in their usual places and with their D102 tap boxes. The date is centred in h2
   at the header's foot, still heard as a heading. The header does not scroll. A name kept in a file is not shown.
   Below the header everything is as built: "Dreams", the bubbles, AI·6, Add dreams and Start Interpretation, the menu
   and delete.
10. **A read night's jump buttons**, at the top of the scrolling part, centred and wrapping at large text. They are
    Dreams in the section label's green, Questions in a stand-in brown, Readings in the tradition label's terracotta
    and Reflection in the dream tag's blue (the light theme's, in both themes), each heard as a button. Dreams brings
    "Dreams" to the top over 300 ms. The other three do nothing until their sections come with the readings.
11. **Naming removed** (D110): no name is shown on a row or a page. Nothing could set a name before either (banked
    item 78). The store's `name` field stays, unchanged, so there is no storage change, and the founder's export
    still writes a name if a file holds one.
12. **SoulDreams Dev's preview** (Part 4, Q15). Built with `--dart-define=PREVIEW_READ=true`, every night shows as
    read, for the owner's review only. Nothing is stored. The tester and founder apps never reach the journal (D49 O1;
    `dev_only_test.dart`).
13. **The screenshots** (the owner's files, Task 1): the five redesign screens replace the seven, re-fingerprinted.
    They are a design reference only: no word is taken from them (R1). Help, Region and the night page's old
    disclosure text in them are ignored.

### What it does not build

- Search, Settings (and Word Animation's setting), consent controls, Life Context and "Made by AI": later branches
  (D110).
- The settings gear, the search field and the sun above the greeting, all seen in `journal.png` (Part 4, Q2).
- The curated set of paintings (the founder's, about 60), and the Questions, Readings and Reflection sections that
  their jump buttons will reach.
- Any change to the store, the typing screen, recording, onboarding, the export, the guards, the words, Swift or the
  server.

### The decisions, by number

- D110 (founder, 2026-11-20): head's message 24 (with message 25), as quoted in the owner's answers of 2026-11-21.
  Where it differs from the C17-P copies, D110 governs, and each difference is listed for Product (Part 4, Q12).
- D91 (standing): what is decided here and what is asked. D95: during a task, only the rows of the files changed; the
  full run once at the end of the branch, before the final review.
- D67 (standing): a mutation row whose code moved follows the code, recorded.
- P13: values the Design System leaves unset are named stand-ins, matched by eye to the founder's screenshots.

### Decided under D91 (how to build only)

1. **Owed words as provisional handles.** `lib/journal/owed.dart` holds an `Owed` per place Product owes, with a
   handle `owed·…`, shown as `[owed·…]`. No register line exists to show, and nothing may sit in `app/lib/words/` but
   the generated files (G1). The handles are not words for a dreamer. Each is listed under "The places" below. The
   file sits in `lib/journal/`, which only SoulDreams Dev reaches.
2. **The picture is chosen from the id** (Part 4, Q13). The id is already 128 random bits from the phone's secure
   source, so no field and no storage change are needed.
3. **The placeholders are drawn in code** (Part 4, Q14): no new file kind, no fingerprint folder, no guard change.
4. **The header stays put; the jump buttons scroll.** A fixed header keeps the back control and the menu where they
   have always been. The jump buttons head the scrolling part, as a contents line does, so at large text the page
   never runs out of room. The night page's tests run on a phone-sized view (390 by 844), as the typing screen's do.
   The foot-buttons test keeps the wider default view, where "one at each side" can be seen.
5. **The night page no longer uses `BelowTapBox`**: the top row now lives inside the header. Row A270 is dropped
   (A271 still covers `BelowTapBox` on the typing screen).
6. **Test gap closed** (D91): the back control's chevron is heard as nothing, now asserted in the typing screen's
   back-control test (row A256 follows it there, since the row chevron it checked is gone).
7. **`opening()` stays**, tested but no longer shown, for search (banked item 136).

### The places this branch uses

Filed, as before: C4-P·5, MP·9, MP·14, MP·29, MP·38, MP·39, EM·1, EM·11 (its second part), C4-P·4, MP·60, MP·61,
AI·6, MP·27's form (`dd/mm/yyyy`). No longer used on these pages: MP·11 (the record button's words; still the
microphone's name on the typing screen). MP·28 was never built.

**Owed by Product, shown as provisional handles** (R1; `lib/journal/owed.dart`):

| Handle shown | Place |
|---|---|
| `[owed·greeting-morning]` | the greeting, 05:00 to 12:00 |
| `[owed·greeting-afternoon]` | the greeting, 12:00 to 17:00 |
| `[owed·greeting-evening]` | the greeting, 17:00 to 21:00 |
| `[owed·greeting-night]` | the greeting, 21:00 to 05:00 |
| `[owed·new-dream]` | the New Dream button (its words and spoken name) |
| `[owed·jump-dreams]` | a read night's jump button to Dreams |
| `[owed·jump-questions]` | to Questions |
| `[owed·jump-readings]` | to Readings |
| `[owed·jump-reflection]` | to Reflection |

### The tests (test-first, on the Mac)

Every task adds its tests before its code. Tasks 2 to 4's new tests were run on the code before them and failed to
load. Tasks 5 to 7's tests name what their task adds (`newDreamKey`, `jumpKey`, `JournalHome.read`), so they cannot
load before it. Each assertion is shown to bite by its mutation row (Part 5). There are 513 app tests at the start and
539 at the end. Mutation rows: 35 new (A359 to A393), 15 follow the code (D67: A36, A37, A306, A307, A24at, A24au,
A41, A256, A261, A263, A273, A301, A322, A323, A341), and 8 are dropped with their reasons (A24ah, A24ar, A24as, A252
to A255, A270), taking the total from 386 to 413. The by-eye review on the phone is the owner's (Task 9).

## Part 2 · Settings and packages

None. No new package, no change to settings, the guards, `tool/checks/`, the words, Swift, the server, AWS or Soniox,
and no storage change. Task 1 commits the owner's screenshots, which G2 already proves (`docs/reference/screens/`).

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

Every Claude Code task ends green:
- `cd app && fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub` passes at the
  count given;
- the task's rows (D95): `python3 -I -B tool/app_mutations.py --rows <the task's rows>`, every one caught;
- the hook: `guards (staged): all passed`.

**Part 4's questions** do not hold the build: the blocks build every lean, and a different answer becomes a later
change.

### Task 0 · Baselines

From the repository root, on `redesign-a`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | grep -v ': ok' ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- `git status` shows only the owner's screenshots: ` M docs/reference/screens/fingerprints.txt`, seven
  `D  docs/reference/screens/journal-*.png`, five `?? docs/reference/screens/<name>.png` (`feedback`, `journal`,
  `life-context`, `night-page`, `settings`), and `?? docs/reference/.DS_Store` (Finder's, never added);
- the plan's commit;
- from the guards, exactly five `G2 docs/reference/screens/<name>.png:0 screen-missing` (the five new screenshots,
  listed in the fingerprints but not yet tracked), `G2 copies: FAIL` and `guards (tracked): FAILED`, and nothing
  else (seen while this plan was written; Task 1 clears it);
- `No issues found!`;
- `+513: All tests passed!`.

Anything else: stop (R14).

### Task 1 · The owner's screenshots (D110)

The five redesign screens replace the seven old ones, as the owner placed and fingerprinted them. Each file's sha256
was checked against `fingerprints.txt` while this plan was written (all five match). Add the folder only, never the
`.DS_Store` beside it:

```
git add docs/reference/screens && git status --short && python3 -I -B tool/checks/guards.py | tail -1
```

Expected: `M `, seven `D `, five `A ` under `docs/reference/screens/`, `?? docs/reference/.DS_Store`, then
`guards (tracked): all passed`. Anything else: stop. Commit:

> Docs: the five redesign screenshots replace the journal's seven, fingerprinted (D110; design reference only, R1)

The hook's G2 proves each file against `fingerprints.txt`. No app test changes (513).

### Task 2 · Word by word only for the app's responses, on by default (D110)

`wordAnimation` becomes `true`, and `AppLine` gains `response` (default `false`): only a response appears word by word. No response is built yet, so every line shown stays whole. Tests: `app_line_test.dart` (6, replacing 4). Rows: A36, A37, A306 and A307 follow the code (D67); A359 and A360 new.

Expected: 515 app tests; rows `A36,A37,A306,A307,A359,A360`, every one caught. Commit:

> Word Animation on by default, word by word only for the app's responses (D110; supersedes D106 2's default)

**The block:**

~~~~diff
diff --git a/app/lib/core/app_line.dart b/app/lib/core/app_line.dart
index d1468cbbd3da5b390fc4c61fce043bbf1bf1b20a..1f661cc198a67794c236a360d5ddac18da8909a9 100644
--- a/app/lib/core/app_line.dart
+++ b/app/lib/core/app_line.dart
@@ -1,10 +1,11 @@
 // A line in the app's own voice (How the AI Appears §4). Word Animation is
-// off everywhere by default (D106 2), so a line stands whole. With it on,
-// the line appears word by word, one word about every 60 ms, the founder's
-// pace to judge in Cohort 0 (D58 Q17); with the phone's Reduce Motion on, or
-// animations disabled, it stands whole all the same. A screen reader always
-// gets the line whole (§8). Words not yet shown keep their place, so the
-// line never reflows as it appears.
+// on by default, and only the app's responses appear word by word (D110,
+// head's message 24, which supersedes D106 2's "off everywhere"): one word
+// about every 60 ms, the founder's pace to judge in Cohort 0 (D58 Q17).
+// Every other line stands whole (D106 2), and so does a response with the
+// setting off, or with the phone's Reduce Motion on or animations disabled.
+// A screen reader always gets the line whole (§8). Words not yet shown keep
+// their place, so the line never reflows as it appears.
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -12,17 +13,21 @@ import 'package:flutter/widgets.dart';
 /// The pace of the app's own words (D58 Q17).
 const wordPace = Duration(milliseconds: 60);
 
-/// Word Animation: off everywhere (D106 2). The setting itself comes with
-/// Settings (P8); until then only a test turns it on.
-bool wordAnimation = false;
+/// Word Animation: on by default (D110). The setting itself comes with
+/// Settings; until then only a test turns it off.
+bool wordAnimation = true;
 
 class AppLine extends StatefulWidget {
-  const AppLine(this.text, {super.key, required this.style, this.textAlign = TextAlign.center});
+  const AppLine(this.text, {super.key, required this.style, this.textAlign = TextAlign.center, this.response = false});
 
   final String text;
   final TextStyle style;
   final TextAlign textAlign;
 
+  /// One of the app's responses (a reading, the mirror, a composed line),
+  /// which alone appears word by word (D110). None is built yet.
+  final bool response;
+
   @override
   State<AppLine> createState() => _AppLineState();
 }
@@ -57,7 +62,7 @@ class _AppLineState extends State<AppLine> {
     // Each word with the space after it, so the parts join to the line.
     _words = widget.text.split(_afterSpace);
     final f = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
-    if (!wordAnimation || f.reduceMotion || f.disableAnimations) {
+    if (!widget.response || !wordAnimation || f.reduceMotion || f.disableAnimations) {
       _shown = _words.length;
       return;
     }
diff --git a/app/test/core/app_line_test.dart b/app/test/core/app_line_test.dart
index 745913fe502bdd015da9dfc4e167e72e000d2d64..b0d6e49d1934feb13ccca295a77d763ebbd01490 100644
--- a/app/test/core/app_line_test.dart
+++ b/app/test/core/app_line_test.dart
@@ -1,6 +1,7 @@
-// The app's own words: whole by default, Word Animation being off everywhere
-// (D106 2); with it on, word by word at about 60 ms a word (D58 Q17), whole
-// with Reduce Motion; always whole to a screen reader.
+// The app's own words: Word Animation is on by default, and only the app's
+// responses appear word by word, at about 60 ms a word (D110; D58 Q17); every
+// other line stands whole (D106 2), and so does a response with the setting
+// off or Reduce Motion on; always whole to a screen reader.
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/core/app_line.dart';
@@ -23,25 +24,33 @@ void main() {
   final line = Lines.C4_P_5.text(Lang.en);
   final words = line.split(' ').length;
 
-  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
-      Directionality(textDirection: TextDirection.ltr, child: Center(child: AppLine(line, style: style))));
+  Future<void> pump(WidgetTester tester, {bool response = false}) => tester.pumpWidget(Directionality(
+      textDirection: TextDirection.ltr, child: Center(child: AppLine(line, style: style, response: response))));
 
-  // The setting itself comes with Settings (P8); until then only a test turns
-  // it on.
-  void animate(WidgetTester tester) {
-    wordAnimation = true;
-    addTearDown(() => wordAnimation = false);
+  // The setting itself comes with Settings; until then only a test turns it
+  // off.
+  void still(WidgetTester tester) {
+    wordAnimation = false;
+    addTearDown(() => wordAnimation = true);
   }
 
-  testWidgets('with Word Animation off, the default, the line stands whole', (tester) async {
-    expect(wordAnimation, isFalse);
+  testWidgets('Word Animation is on by default (D110)', (tester) async {
+    expect(wordAnimation, isTrue);
+  });
+
+  testWidgets('a line that is not a response stands whole', (tester) async {
     await pump(tester);
     expect(shown(tester), words);
   });
 
-  testWidgets('with it on: one word, then one more every 60 ms', (tester) async {
-    animate(tester);
-    await pump(tester);
+  testWidgets('with Word Animation off, a response stands whole', (tester) async {
+    still(tester);
+    await pump(tester, response: true);
+    expect(shown(tester), words);
+  });
+
+  testWidgets('a response: one word, then one more every 60 ms', (tester) async {
+    await pump(tester, response: true);
     expect(shown(tester), 1);
     await tester.pump(wordPace);
     expect(shown(tester), 2);
@@ -51,18 +60,19 @@ void main() {
     expect(shown(tester), words);
   });
 
-  testWidgets('with it on, Reduce Motion still stands whole', (tester) async {
-    animate(tester);
+  testWidgets('with Reduce Motion, a response stands whole', (tester) async {
     tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(reduceMotion: true);
     addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
-    await pump(tester);
+    await pump(tester, response: true);
     expect(shown(tester), words);
   });
 
-  testWidgets('a screen reader hears the whole line at once', (tester) async {
+  testWidgets('a screen reader hears a response whole at once', (tester) async {
     final handle = tester.ensureSemantics();
-    await pump(tester);
+    await pump(tester, response: true);
+    expect(shown(tester), 1);
     expect(find.bySemanticsLabel(line), findsOneWidget);
     handle.dispose();
+    await tester.pump(wordPace * words);
   });
 }
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index ab0ea7d8ea9354f4b3a99874bb7930df130fbac8..e61e5c50ffe4165592046f21b5fb304e2f0ca899 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -406,13 +406,13 @@ ROWS = [
      '? Duration.zero : Duration.zero',
      'test/core/night_day_test.dart', 'at 21:00 the open app fades to dark over five seconds'),
     ('A36', 'lib/core/app_line.dart',
-     'if (!wordAnimation || f.reduceMotion || f.disableAnimations) {',
-     'if (!wordAnimation || f.disableAnimations) {',
-     'test/core/app_line_test.dart', 'with it on, Reduce Motion still stands whole'),
+     '!wordAnimation || f.reduceMotion || f.disableAnimations) {',
+     '!wordAnimation || f.disableAnimations) {',
+     'test/core/app_line_test.dart', 'with Reduce Motion, a response stands whole'),
     ('A37', 'lib/core/app_line.dart',
      '    _shown = 1;\n',
      '    _shown = _words.length;\n',
-     'test/core/app_line_test.dart', 'with it on: one word, then one more every 60 ms'),
+     'test/core/app_line_test.dart', 'a response: one word, then one more every 60 ms'),
     # deleting, and Dev only
     ('A38', 'lib/journal/pages/night_page.dart',
      '    if (yes != true || !mounted) return;\n',
@@ -1476,13 +1476,13 @@ ROWS = [
      'test/dev_only_test.dart', 'lib/main.dart reaches no journal, onboarding or recording code, no pending line'),
     # D106: every box centred; no word-by-word; a part with no line shows nothing.
     ('A306', 'lib/core/app_line.dart',
-     'if (!wordAnimation || f.reduceMotion',
-     'if (f.reduceMotion',
-     'test/core/app_line_test.dart', 'with Word Animation off, the default, the line stands whole'),
+     '!widget.response || !wordAnimation || f.reduceMotion',
+     '!widget.response || f.reduceMotion',
+     'test/core/app_line_test.dart', 'with Word Animation off, a response stands whole'),
     ('A307', 'lib/core/app_line.dart',
-     'bool wordAnimation = false;',
      'bool wordAnimation = true;',
-     'test/onboarding/onboarding_test.dart', 'the words appear all at once, not word by word'),
+     'bool wordAnimation = false;',
+     'test/core/app_line_test.dart', 'Word Animation is on by default (D110)'),
     ('A308', 'lib/onboarding/onboarding.dart',
      'for (final line in written(widget.first)) reads(line)',
      'for (final line in widget.first) reads(line)',
@@ -1710,6 +1710,15 @@ ROWS = [
      'this.shown = DisclosurePage.parts',
      'this.shown = const []',
      'test/onboarding/onboarding_test.dart', 'the pages default to their parts'),
+    # D110 (head's message 24): word by word only for the app's responses, on by default.
+    ('A359', 'lib/core/app_line.dart',
+     'if (!widget.response || !wordAnimation',
+     'if (!wordAnimation',
+     'test/core/app_line_test.dart', 'a line that is not a response stands whole'),
+    ('A360', 'lib/core/app_line.dart',
+     'if (!widget.response || !wordAnimation',
+     'if (!wordAnimation',
+     'test/onboarding/onboarding_test.dart', 'the words appear all at once, not word by word'),
 ]
 
 
~~~~

### Task 3 · The owed handles, the greeting's parts of the day, a night's look (plain Dart)

`lib/journal/owed.dart` (the nine provisional handles), `lib/journal/greeting.dart` (the parts of the day and their greetings), `lib/journal/night_look.dart` (a night's look from its id; `ReadCheck`, `noneRead`). Tests: `owed_test.dart` (2), `greeting_test.dart` (2), `night_look_test.dart` (6). Rows A361 to A367.

Expected: 525 app tests; rows `A361,A362,A363,A364,A365,A366,A367`, every one caught. Commit:

> Journal: the greeting's parts of the day, the owed handles, and a night's look chosen from its id alone (D110)

**The block:**

~~~~diff
diff --git a/app/lib/journal/greeting.dart b/app/lib/journal/greeting.dart
new file mode 100644
index 0000000000000000000000000000000000000000..227790a1722fcf88d57f2d8c714ca8fb715da932
--- /dev/null
+++ b/app/lib/journal/greeting.dart
@@ -0,0 +1,23 @@
+// The journal's greeting by time of day (D110, head's message 24), in plain
+// Dart: the part of the day by the phone's wall clock, and its greeting. The
+// four parts and their hours are the plan's stand-ins until Product files
+// the greetings; night begins at 21:00, as the dark theme does.
+import 'owed.dart';
+
+enum Daypart { morning, afternoon, evening, night }
+
+/// The part of the day at the wall clock's [hour].
+Daypart daypartAt(int hour) => switch (hour) {
+  >= 5 && < 12 => Daypart.morning,
+  >= 12 && < 17 => Daypart.afternoon,
+  >= 17 && < 21 => Daypart.evening,
+  _ => Daypart.night,
+};
+
+/// The greeting for [part]: owed by Product, shown as its handle (R1).
+Owed greetingFor(Daypart part) => switch (part) {
+  Daypart.morning => OwedLines.greetingMorning,
+  Daypart.afternoon => OwedLines.greetingAfternoon,
+  Daypart.evening => OwedLines.greetingEvening,
+  Daypart.night => OwedLines.greetingNight,
+};
diff --git a/app/lib/journal/night_look.dart b/app/lib/journal/night_look.dart
new file mode 100644
index 0000000000000000000000000000000000000000..17bdd4adcc933efcbaeaa3d11ead4ba11532a0fa
--- /dev/null
+++ b/app/lib/journal/night_look.dart
@@ -0,0 +1,49 @@
+// A night's look (D110, head's messages 24 and 25), in plain Dart: a read
+// night shows one painting of the set shipped in the app, chosen from the
+// night's id alone, so from none of its words, and the same every time; an
+// unread night shows the painted gradient, and so does any night while the
+// app holds no painting. Nothing is stored: the id is already random (128
+// bits from the phone's secure source, newNightId).
+import 'night.dart';
+
+sealed class NightLook {
+  const NightLook();
+}
+
+/// The painted gradient: an unread night, or no painting to show.
+final class PaintedGradient extends NightLook {
+  const PaintedGradient();
+
+  @override
+  bool operator ==(Object other) => other is PaintedGradient;
+
+  @override
+  int get hashCode => 0;
+}
+
+/// The painting at [index] in the set.
+final class Painting extends NightLook {
+  const Painting(this.index);
+
+  final int index;
+
+  @override
+  bool operator ==(Object other) => other is Painting && other.index == index;
+
+  @override
+  int get hashCode => index;
+}
+
+/// Which of [count] paintings the night with [id] shows: its id's first 32
+/// bits, modulo the count.
+int paintingFor(String id, int count) => int.parse(id.substring(0, 8), radix: 16) % count;
+
+/// The look of [night], [read] or not, with [paintings] in the set.
+NightLook lookOf(Night night, {required bool read, required int paintings}) =>
+    read && paintings > 0 ? Painting(paintingFor(night.id, paintings)) : const PaintedGradient();
+
+/// Whether a night has been read.
+typedef ReadCheck = bool Function(Night night);
+
+/// The readings come later, so no night is read yet.
+bool noneRead(Night night) => false;
diff --git a/app/lib/journal/owed.dart b/app/lib/journal/owed.dart
new file mode 100644
index 0000000000000000000000000000000000000000..369e8d0d16f50351185f444c4629a3a6f54a08b2
--- /dev/null
+++ b/app/lib/journal/owed.dart
@@ -0,0 +1,44 @@
+// The places Product still owes (D110, head's message 24): no line and no
+// handle in the register yet. Each shows a provisional handle in square
+// brackets, as a place with no line shows its own (R1), until Product files
+// it; then the page takes the register's line and its entry here goes. Each
+// is listed in docs/plans/redesign-a.md.
+
+/// A place Product owes, by its provisional handle.
+final class Owed {
+  const Owed(this.handle);
+
+  final String handle;
+
+  /// The visible placeholder (R1).
+  String get text => '[$handle]';
+}
+
+abstract final class OwedLines {
+  /// The journal's greeting, by the part of the day.
+  static const greetingMorning = Owed('owed·greeting-morning');
+  static const greetingAfternoon = Owed('owed·greeting-afternoon');
+  static const greetingEvening = Owed('owed·greeting-evening');
+  static const greetingNight = Owed('owed·greeting-night');
+
+  /// The journal's button that opens the typing screen.
+  static const newDream = Owed('owed·new-dream');
+
+  /// A read night's jump buttons.
+  static const jumpDreams = Owed('owed·jump-dreams');
+  static const jumpQuestions = Owed('owed·jump-questions');
+  static const jumpReadings = Owed('owed·jump-readings');
+  static const jumpReflection = Owed('owed·jump-reflection');
+
+  static const all = <Owed>[
+    greetingMorning,
+    greetingAfternoon,
+    greetingEvening,
+    greetingNight,
+    newDream,
+    jumpDreams,
+    jumpQuestions,
+    jumpReadings,
+    jumpReflection,
+  ];
+}
diff --git a/app/test/journal/greeting_test.dart b/app/test/journal/greeting_test.dart
new file mode 100644
index 0000000000000000000000000000000000000000..70dcb6c4c3cbfc461fa9f03749ea73e7e622bc77
--- /dev/null
+++ b/app/test/journal/greeting_test.dart
@@ -0,0 +1,25 @@
+// The journal's greeting by time of day (D110): four parts of the day by the
+// phone's wall clock, each with its owed greeting.
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/greeting.dart';
+import 'package:souldreams/journal/owed.dart';
+
+void main() {
+  test('the parts of the day: from 05, 12, 17, 21', () {
+    final parts = [for (var h = 0; h < 24; h++) daypartAt(h)];
+    expect(parts, [
+      for (var h = 0; h < 5; h++) Daypart.night,
+      for (var h = 5; h < 12; h++) Daypart.morning,
+      for (var h = 12; h < 17; h++) Daypart.afternoon,
+      for (var h = 17; h < 21; h++) Daypart.evening,
+      for (var h = 21; h < 24; h++) Daypart.night,
+    ]);
+  });
+
+  test('each part of the day has its own greeting', () {
+    expect(greetingFor(Daypart.morning), OwedLines.greetingMorning);
+    expect(greetingFor(Daypart.afternoon), OwedLines.greetingAfternoon);
+    expect(greetingFor(Daypart.evening), OwedLines.greetingEvening);
+    expect(greetingFor(Daypart.night), OwedLines.greetingNight);
+  });
+}
diff --git a/app/test/journal/night_look_test.dart b/app/test/journal/night_look_test.dart
new file mode 100644
index 0000000000000000000000000000000000000000..30a6982b0b4f2e13225e4147c780b87c61b49851
--- /dev/null
+++ b/app/test/journal/night_look_test.dart
@@ -0,0 +1,57 @@
+// A night's look (D110; head's message 25): a read night shows one painting
+// of the set, chosen from its id alone; an unread night, or no set, the
+// painted gradient.
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/night_look.dart';
+import 'package:souldreams/words/lines.g.dart' show Lang;
+
+import '../fixtures.dart';
+import 'zones.dart';
+
+Night nightWith(String id, {String key = 'two-dreams-en', String? name}) {
+  final n = invented(key);
+  final at = stockholm(2026, 6, 2, 23);
+  return Night(
+    id: id,
+    firstRecorded: at,
+    date: (year: 2026, month: 6, day: 2),
+    closes: at.add(const Duration(hours: 22)),
+    lang: Lang.en,
+    name: name,
+    dreams: n.dreams,
+  );
+}
+
+void main() {
+  const a = '0000000a00000000000000000000000f';
+  const b = 'ffffffff00000000000000000000000f';
+
+  test('the painting: first 32 bits of the id, modulo count', () {
+    expect(paintingFor(a, 4), 2);
+    expect(paintingFor(b, 4), 3);
+    expect(paintingFor(b, 1), 0);
+  });
+
+  test('an unread night shows the painted gradient', () {
+    expect(lookOf(nightWith(a), read: false, paintings: 4), const PaintedGradient());
+  });
+
+  test('a read night shows its painting', () {
+    expect(lookOf(nightWith(a), read: true, paintings: 4), const Painting(2));
+  });
+
+  test('with no paintings, a read night shows the gradient', () {
+    expect(lookOf(nightWith(a), read: true, paintings: 0), const PaintedGradient());
+  });
+
+  test("none of the night's words choose it", () {
+    final one = lookOf(nightWith(b), read: true, paintings: 5);
+    final other = lookOf(nightWith(b, key: 'one-dream-sv', name: 'x'), read: true, paintings: 5);
+    expect(one, other);
+  });
+
+  test('no night is read before the readings', () {
+    expect(noneRead(nightWith(a)), isFalse);
+  });
+}
diff --git a/app/test/journal/owed_test.dart b/app/test/journal/owed_test.dart
new file mode 100644
index 0000000000000000000000000000000000000000..9e4d1d5f5576cd091ab15d182139d20daa2bd88a
--- /dev/null
+++ b/app/test/journal/owed_test.dart
@@ -0,0 +1,21 @@
+// The places Product still owes (D110): each shows its provisional handle in
+// square brackets (R1), no two alike, none a register handle.
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/owed.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+void main() {
+  test('an owed place shows its handle in square brackets', () {
+    for (final o in OwedLines.all) {
+      expect(o.text, '[${o.handle}]');
+    }
+  });
+
+  test('nine owed places, each handle once, none in the register', () {
+    final handles = [for (final o in OwedLines.all) o.handle];
+    expect(handles, hasLength(9));
+    expect(handles.toSet(), hasLength(9));
+    final filed = {for (final l in Lines.all) l.handle};
+    expect(handles.where(filed.contains), isEmpty);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index e61e5c50ffe4165592046f21b5fb304e2f0ca899..c045ecab6ac8cb2141f2b5873113b9b4cc797ff0 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1719,6 +1719,35 @@ ROWS = [
      'if (!widget.response || !wordAnimation',
      'if (!wordAnimation',
      'test/onboarding/onboarding_test.dart', 'the words appear all at once, not word by word'),
+    # D110: the greeting, the owed handles, a night's look.
+    ('A361', 'lib/journal/greeting.dart',
+     '>= 17 && < 21 => Daypart.evening',
+     '>= 17 && < 22 => Daypart.evening',
+     'test/journal/greeting_test.dart', 'the parts of the day: from 05, 12, 17, 21'),
+    ('A362', 'lib/journal/greeting.dart',
+     'Daypart.night => OwedLines.greetingNight,',
+     'Daypart.night => OwedLines.greetingEvening,',
+     'test/journal/greeting_test.dart', 'each part of the day has its own greeting'),
+    ('A363', 'lib/journal/owed.dart',
+     "String get text => '[$handle]';",
+     'String get text => handle;',
+     'test/journal/owed_test.dart', 'an owed place shows its handle in square brackets'),
+    ('A364', 'lib/journal/night_look.dart',
+     'read && paintings > 0 ?',
+     'paintings > 0 ?',
+     'test/journal/night_look_test.dart', 'an unread night shows the painted gradient'),
+    ('A365', 'lib/journal/night_look.dart',
+     'read && paintings > 0 ?',
+     'read ?',
+     'test/journal/night_look_test.dart', 'with no paintings, a read night shows the gradient'),
+    ('A366', 'lib/journal/night_look.dart',
+     'id.substring(0, 8)',
+     'id.substring(24)',
+     'test/journal/night_look_test.dart', 'the painting: first 32 bits of the id, modulo count'),
+    ('A367', 'lib/journal/night_look.dart',
+     'bool noneRead(Night night) => false;',
+     'bool noneRead(Night night) => true;',
+     'test/journal/night_look_test.dart', 'no night is read before the readings'),
 ]
 
 
~~~~

### Task 4 · A night's picture: the painted gradient and the placeholder paintings

`lib/journal/pages/night_art.dart`: the painted gradient and five placeholder paintings drawn in code, standing in the curated set; silent to a screen reader, what stands over it heard. Tests: `night_art_test.dart` (6). Rows A368 to A372.

Expected: 531 app tests; rows `A368,A369,A370,A371,A372`, every one caught. Commit:

> Journal: a night's picture, the painted gradient or a placeholder painting in the curated set's place (D110)

**The block:**

~~~~diff
diff --git a/app/lib/journal/pages/night_art.dart b/app/lib/journal/pages/night_art.dart
new file mode 100644
index 0000000000000000000000000000000000000000..aafba062a6c4636cdc9520a50565c6c04fff8284
--- /dev/null
+++ b/app/lib/journal/pages/night_art.dart
@@ -0,0 +1,111 @@
+// A night's picture (D110; head's messages 24 and 25): the painted gradient
+// for an unread night, or one painting of the set shipped in the app for a
+// read one. The curated set (about 60, the founder's) is not filed yet, so a
+// few placeholder paintings stand in its place, drawn here in plain layered
+// colour: no file, no package, no words. When the set comes, it replaces
+// `paintings` and the placeholders; nothing else changes. The gradient's
+// colours and the text over a picture are stand-ins until Product sets them
+// (P13): the dark theme's bubble gradient and text, in both themes. Heard
+// as nothing: decoration.
+import 'dart:math';
+
+import 'package:flutter/widgets.dart';
+
+import '../../design/tokens.g.dart';
+import '../night_look.dart';
+
+/// One placeholder painting: a sky from top to foot, a soft light in it at
+/// [lightX] across, a far ridge and a near one.
+typedef _Placeholder = ({Color top, Color foot, Color light, double lightX, Color far, Color near});
+
+const _placeholders = <_Placeholder>[
+  // Dusk.
+  (top: Color(0xFF2E2A5C), foot: Color(0xFF8C6A9E), light: Color(0xFFF2D8A7), lightX: 0.72, far: Color(0xFF4A3F6B), near: Color(0xFF231E3D)),
+  // Dawn.
+  (top: Color(0xFF6E7FA8), foot: Color(0xFFE9B9A0), light: Color(0xFFFFF1D6), lightX: 0.28, far: Color(0xFF8A7F9C), near: Color(0xFF4F4866)),
+  // The sea.
+  (top: Color(0xFF1F4E5F), foot: Color(0xFF7FB3B0), light: Color(0xFFE8F1E4), lightX: 0.6, far: Color(0xFF2F6B6E), near: Color(0xFF173B45)),
+  // The forest.
+  (top: Color(0xFF34503A), foot: Color(0xFFB7B98A), light: Color(0xFFF4E9C1), lightX: 0.4, far: Color(0xFF3F5E3F), near: Color(0xFF1E3322)),
+  // The night.
+  (top: Color(0xFF0E1433), foot: Color(0xFF3B4A7A), light: Color(0xFFDCE3F2), lightX: 0.8, far: Color(0xFF26305A), near: Color(0xFF111833)),
+];
+
+class NightArt extends StatelessWidget {
+  const NightArt(this.look, {super.key, this.child});
+
+  final NightLook look;
+
+  /// What stands over the picture (the date), if anything.
+  final Widget? child;
+
+  /// How many paintings the set holds: the placeholders, for now.
+  static const paintings = 5;
+
+  /// The painted gradient, top to foot.
+  static final gradient = [DarkColours.surface.colour!, DarkColours.surface.colourEnd!];
+
+  /// The colour of words over a picture.
+  static final over = DarkColours.text.colour!;
+
+  /// The top of painting [index]'s sky (each painting's own).
+  static Color sky(int index) => _placeholders[index].top;
+
+  // A painter adds nothing a screen reader hears; what stands over it is
+  // heard as itself.
+  @override
+  Widget build(BuildContext context) =>
+      CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand());
+}
+
+class _ArtPainter extends CustomPainter {
+  _ArtPainter(this.look);
+
+  final NightLook look;
+
+  @override
+  void paint(Canvas canvas, Size size) {
+    final box = Offset.zero & size;
+    canvas.save();
+    canvas.clipRect(box);
+    switch (look) {
+      case PaintedGradient():
+        canvas.drawRect(box, Paint()..shader = _vertical(box, NightArt.gradient));
+      case Painting(:final index):
+        final p = _placeholders[index];
+        canvas.drawRect(box, Paint()..shader = _vertical(box, [p.top, p.foot]));
+        final r = min(size.width, size.height) * 0.22;
+        canvas.drawCircle(
+          Offset(size.width * p.lightX, size.height * 0.38),
+          r,
+          Paint()
+            ..color = p.light.withValues(alpha: 0.85)
+            ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.35),
+        );
+        canvas.drawPath(_ridge(size, 0.66, 0.06, 1.3), Paint()..color = p.far);
+        canvas.drawPath(_ridge(size, 0.8, 0.05, 2.1), Paint()..color = p.near);
+    }
+    canvas.restore();
+  }
+
+  static Shader _vertical(Rect box, List<Color> colours) =>
+      LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colours).createShader(box);
+
+  // A gentle ridge across the width at [at] of the height, rising and
+  // falling by [swell] of the height, [waves] times.
+  static Path _ridge(Size size, double at, double swell, double waves) {
+    final path = Path()..moveTo(0, size.height);
+    const steps = 24;
+    for (var i = 0; i <= steps; i++) {
+      final x = size.width * i / steps;
+      final y = size.height * (at + swell * sin(i / steps * waves * pi));
+      path.lineTo(x, y);
+    }
+    return path
+      ..lineTo(size.width, size.height)
+      ..close();
+  }
+
+  @override
+  bool shouldRepaint(_ArtPainter old) => old.look != look;
+}
diff --git a/app/test/journal/pages/night_art_test.dart b/app/test/journal/pages/night_art_test.dart
new file mode 100644
index 0000000000000000000000000000000000000000..0d02588506ab843445e9233f0f2335d4be89d9e8
--- /dev/null
+++ b/app/test/journal/pages/night_art_test.dart
@@ -0,0 +1,54 @@
+// A night's picture (D110; head's messages 24 and 25): the painted gradient,
+// or one of the placeholder paintings in the curated set's place; heard as
+// nothing; the same in both themes.
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/design/tokens.g.dart';
+import 'package:souldreams/journal/night_look.dart';
+import 'package:souldreams/journal/pages/night_art.dart';
+
+void main() {
+  Future<RenderObject> pump(WidgetTester tester, NightLook look) async {
+    await tester.pumpWidget(Center(child: SizedBox(width: 300, height: 64, child: NightArt(look))));
+    return tester.renderObject(find.descendant(of: find.byType(NightArt), matching: find.byType(CustomPaint)));
+  }
+
+  test('a few placeholder paintings stand in the set', () {
+    expect(NightArt.paintings, 5);
+  });
+
+  test("the gradient and the words over it: from the dark theme", () {
+    expect(NightArt.gradient, [DarkColours.surface.colour, DarkColours.surface.colourEnd]);
+    expect(NightArt.over, DarkColours.text.colour);
+  });
+
+  testWidgets('the gradient fills its box, and nothing else is drawn', (tester) async {
+    final art = await pump(tester, const PaintedGradient());
+    expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
+    expect(art, isNot(paints..circle()));
+  });
+
+  testWidgets('each painting fills its box and draws its own light', (tester) async {
+    for (var i = 0; i < NightArt.paintings; i++) {
+      final art = await pump(tester, Painting(i));
+      expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64))..circle());
+    }
+  });
+
+  testWidgets('no two paintings alike', (tester) async {
+    final skies = {for (var i = 0; i < NightArt.paintings; i++) NightArt.sky(i)};
+    expect(skies, hasLength(NightArt.paintings));
+  });
+
+  testWidgets('the picture is silent; what stands over it is heard', (tester) async {
+    final handle = tester.ensureSemantics();
+    await pump(tester, const Painting(0));
+    expect(tester.getSemantics(find.byType(NightArt)).label, isEmpty);
+    await tester.pumpWidget(const Directionality(
+      textDirection: TextDirection.ltr,
+      child: NightArt(Painting(1), child: Text('19/11/2026')),
+    ));
+    expect(find.bySemanticsLabel('19/11/2026'), findsOneWidget);
+    handle.dispose();
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index c045ecab6ac8cb2141f2b5873113b9b4cc797ff0..aecd4784e1adc4f65480a4e65ce74df3a7330d05 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1748,6 +1748,27 @@ ROWS = [
      'bool noneRead(Night night) => false;',
      'bool noneRead(Night night) => true;',
      'test/journal/night_look_test.dart', 'no night is read before the readings'),
+    # D110: a night's picture (the painted gradient, the placeholder paintings).
+    ('A368', 'lib/journal/pages/night_art.dart',
+     '        canvas.drawRect(box, Paint()..shader = _vertical(box, NightArt.gradient));\n',
+     '',
+     'test/journal/pages/night_art_test.dart', 'the gradient fills its box, and nothing else is drawn'),
+    ('A369', 'lib/journal/pages/night_art.dart',
+     '        canvas.drawRect(box, Paint()..shader = _vertical(box, [p.top, p.foot]));\n',
+     '',
+     'test/journal/pages/night_art_test.dart', 'each painting fills its box and draws its own light'),
+    ('A370', 'lib/journal/pages/night_art.dart',
+     'static final gradient = [DarkColours.surface.colour!, DarkColours.surface.colourEnd!];',
+     'static final gradient = [DarkColours.surface.colourEnd!, DarkColours.surface.colour!];',
+     'test/journal/pages/night_art_test.dart', "the gradient and the words over it: from the dark theme"),
+    ('A371', 'lib/journal/pages/night_art.dart',
+     '      CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand());',
+     '      ExcludeSemantics(child: CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand()));',
+     'test/journal/pages/night_art_test.dart', 'the picture is silent; what stands over it is heard'),
+    ('A372', 'lib/journal/pages/night_art.dart',
+     '  static const paintings = 5;',
+     '  static const paintings = 4;',
+     'test/journal/pages/night_art_test.dart', 'a few placeholder paintings stand in the set'),
 ]
 
 
~~~~

### Task 5 · The journal: the greeting, New Dream, rows carrying only the date; the record button removed

`journal_page.dart` rebuilt as Part 1 items 2 to 6 and 11; `NightPage` gains `read` (used in Task 6); `RecordButton` and its stand-ins go; new stand-ins `greetingAbove`, `listAbove`, `rowHeight`, `journalEnd` 40. Tests: `journal_page_test.dart` (the summary, chevron, name and circle tests give way to the greeting, New Dream, the row's look, a read row, the date alone and the read hand-off: 20 tests), `journal_home_test.dart` (two taps move from MP·11's words to New Dream), `typing_page_test.dart` (the back control's chevron heard as nothing). Rows: A24ar, A24as, A252 to A255 dropped (the record button, the summary, the row's chevron); A24at, A24au, A41, A301, A322 follow the code; A256 follows to the back control's test; A373 to A380 new.

Expected: 531 app tests; rows `A24at,A24au,A41,A250,A251,A256,A301,A302,A322,A373,A374,A375,A376,A377,A378,A379,A380`, every one caught. Commit:

> Journal: a greeting, New Dream, rows carrying only the date over the night's picture; the record button and naming go (D110)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index a6b3a08a84a683cc8e9b324f83ca27af48f54612..d4bdec175074d38435e2c2bb42becd8f651b2b9c 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -9,18 +9,18 @@ abstract final class StandIns {
   // The page's side margin and the space between two journal rows, once
   // here, are filed at C17-P: `Spacing.pageSide` and `Spacing.journalRow`.
 
-  /// The chevron at a row's trailing edge (item 4): its size, its line, and
-  /// the space before it.
+  /// A chevron (head's message 20, items 4 and 9): its size, and its line.
   static const rowChevron = Size(10, 18);
   static const double chevronStroke = 2;
-  static const double chevronGap = 16;
 
-  /// Inside a journal row.
-  static const rowPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 20);
+  /// The journal (D110): above the greeting; between New Dream and the
+  /// first row or the empty journal's line; a row's least height.
+  static const double greetingAbove = 40;
+  static const double listAbove = 40;
+  static const double rowHeight = 64;
 
-  /// space.journal.end: below the last row, so the list scrolls clear of
-  /// the record button.
-  static const double journalEnd = 120;
+  /// space.journal.end: below the last row.
+  static const double journalEnd = 40;
 
   /// Above a month divider.
   static const double dividerAbove = 24;
@@ -41,16 +41,11 @@ abstract final class StandIns {
   /// (head's message 20, item 10).
   static const double menuWidth = 55;
 
-  /// The first empty journal's arrow to the record button (main-path.md,
+  /// The first empty journal's arrow up to New Dream (main-path.md,
   /// Onboarding, 5): its size, and the space above and below it.
   static const firstArrow = Size(12, 32);
   static const double arrowGap = 8;
 
-  /// The record button.
-  static const double recordHeight = 120;
-  static const double recordWidth = 120;
-  static const double recordBelow = 40;
-
   /// Inside a button, and a section label.
   static const buttonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
   static const labelPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index e7bbbb48df4eba03e45e8e86a8cefe0c1414064d..bd69e69384ee5c1ecfebab5f1d9278b8d9add35c 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -1,11 +1,16 @@
-// The journal list, the app's home (main-path.md, The Journal, design 1;
-// C131-I items 1, 2; S5): one row per night, newest first, never a time;
-// a month divider over each month with nights; the record button bottom
-// centre; C4-P·5 when there is no night. Straight from onboarding, the
-// first empty journal also shows MP·9 with an arrow to the record button,
-// once (main-path.md, Onboarding, 5); the logo above it waits for the
-// founder's file. No Settings entry and no search (P8). Nothing on a row
-// grades it: no badge, count or status.
+// The journal list, the app's home (main-path.md, The Journal; C131-I
+// items 1, 2; S5; D110, head's message 24): a greeting by the part of the
+// day; New Dream, opening the typing screen (the round record button is
+// gone); one rounded row per night, newest first, carrying only its date
+// over the night's picture (an unread night's the painted gradient), never
+// a time; a month divider over each month with nights; C4-P·5 when there is
+// no night. Straight from onboarding, the first empty journal also shows
+// MP·9 under New Dream, with an arrow up to it, once (main-path.md,
+// Onboarding, 5); the logo waits for the founder's file. No Settings entry
+// and no search (later branches). Nothing on a row grades it: no badge,
+// count or status.
+import 'dart:async';
+
 import 'package:flutter/material.dart';
 
 import '../../core/app_line.dart';
@@ -16,17 +21,27 @@ import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
+import '../greeting.dart';
 import '../journal.dart';
 import '../night.dart';
 import '../night_action.dart';
+import '../night_look.dart';
 import '../night_rules.dart';
+import '../owed.dart';
 import '../row_text.dart';
+import 'night_art.dart';
 import 'night_page.dart';
-import 'parts.dart';
 import 'typing_page.dart';
 
 class JournalPage extends StatefulWidget {
-  const JournalPage({super.key, required this.journal, this.recording, this.firstTime = false, this.nightAction});
+  const JournalPage({
+    super.key,
+    required this.journal,
+    this.recording,
+    this.firstTime = false,
+    this.nightAction,
+    this.read = noneRead,
+  });
 
   final Journal journal;
 
@@ -35,6 +50,10 @@ class JournalPage extends StatefulWidget {
   final bool firstTime;
 
   static const arrowKey = Key('first-arrow');
+  static const newDreamKey = Key('new-dream');
+
+  /// A night's row.
+  static Key rowKey(String id) => ValueKey('row-$id');
 
   /// How to record by voice in the typing screen, or null (D69).
   final Recording? recording;
@@ -42,6 +61,9 @@ class JournalPage extends StatefulWidget {
   /// The item each night's menu gains, or null (D107 item 1).
   final NightAction? nightAction;
 
+  /// Whether a night has been read: none is yet (the readings come later).
+  final ReadCheck read;
+
   @override
   State<JournalPage> createState() => _JournalPageState();
 }
@@ -49,6 +71,10 @@ class JournalPage extends StatefulWidget {
 class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   List<Night>? _nights;
   late bool _first = widget.firstTime;
+  late Daypart _daypart = _daypartNow();
+  late final Timer _clock;
+
+  Daypart _daypartNow() => daypartAt(widget.journal.zone.wall(widget.journal.now()).hour);
 
   @override
   void initState() {
@@ -56,10 +82,16 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     WidgetsBinding.instance.addObserver(this);
     _load();
     widget.recording?.retries?.addListener(_load);
+    // The greeting follows the clock while the page is open.
+    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
+      final now = _daypartNow();
+      if (now != _daypart) setState(() => _daypart = now);
+    });
   }
 
   @override
   void dispose() {
+    _clock.cancel();
     WidgetsBinding.instance.removeObserver(this);
     widget.recording?.retries?.removeListener(_load);
     super.dispose();
@@ -83,6 +115,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     if (!mounted) return;
     setState(() {
       _nights = nights;
+      _daypart = _daypartNow();
       // Shown once: a night there ends it, even one deleted later.
       if (nights.isNotEmpty) _first = false;
     });
@@ -123,61 +156,50 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     final year = widget.journal.zone.wall(widget.journal.now()).year;
     return Scaffold(
       body: SafeArea(
-        child: Stack(
+        child: ListView(
+          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.greetingAbove, Spacing.pageSide, StandIns.journalEnd),
           children: [
-            if (nights != null && nights.isEmpty)
-              Center(
-                child: Padding(
-                  padding: const EdgeInsets.symmetric(horizontal: Spacing.pageSide),
-                  // In the button type, centred (head's message 20, item 7).
-                  child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text)),
-                ),
-              ),
-            if (nights != null && nights.isNotEmpty)
-              ListView(
-                padding: const EdgeInsets.fromLTRB(
-                  Spacing.pageSide,
-                  0,
-                  Spacing.pageSide,
-                  StandIns.journalEnd + StandIns.recordHeight + StandIns.recordBelow,
-                ),
-                children: [
-                  for (final item in listItems(nights))
-                    switch (item) {
-                      MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
-                      NightItem(:final night) => _Row(
-                        night,
-                        onTap: () =>
-                            _push(NightPage(
-                              journal: widget.journal,
-                              id: night.id,
-                              recording: widget.recording,
-                              action: widget.nightAction,
-                            )),
-                      ),
-                    },
-                ],
+            // Centred in h2, heard as a heading (D110).
+            Semantics(
+              header: true,
+              child: Text(
+                greetingFor(_daypart).text,
+                textAlign: TextAlign.center,
+                style: TypeRoles.h2.style(p.text),
               ),
-            if (nights != null && nights.isEmpty && _first)
-              Positioned(
-                left: Spacing.pageSide,
-                right: Spacing.pageSide,
-                bottom: StandIns.recordBelow + StandIns.recordHeight + StandIns.arrowGap,
-                child: Column(
-                  mainAxisSize: MainAxisSize.min,
-                  children: [
-                    AppLine(Lines.MP_9.text(appLanguage), style: TypeRoles.button.style(p.text)),
-                    const SizedBox(height: StandIns.arrowGap),
-                    _Arrow(key: JournalPage.arrowKey, colour: p.text),
-                  ],
-                ),
-              ),
-            Positioned(
-              left: 0,
-              right: 0,
-              bottom: StandIns.recordBelow,
-              child: Center(child: RecordButton(onPressed: _record)),
             ),
+            const SizedBox(height: StandIns.gap),
+            Center(child: _NewDream(onPressed: _record)),
+            if (nights != null && nights.isEmpty && _first) ...[
+              const SizedBox(height: StandIns.arrowGap),
+              Center(child: _Arrow(key: JournalPage.arrowKey, colour: p.text)),
+              const SizedBox(height: StandIns.arrowGap),
+              AppLine(Lines.MP_9.text(appLanguage), style: TypeRoles.button.style(p.text)),
+            ],
+            if (nights != null && nights.isEmpty) ...[
+              const SizedBox(height: StandIns.listAbove),
+              // In the button type, centred (head's message 20, item 7).
+              AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text)),
+            ],
+            if (nights != null && nights.isNotEmpty) ...[
+              const SizedBox(height: StandIns.listAbove - StandIns.dividerAbove),
+              for (final item in listItems(nights))
+                switch (item) {
+                  MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
+                  NightItem(:final night) => _Row(
+                    night,
+                    look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings),
+                    onTap: () =>
+                        _push(NightPage(
+                          journal: widget.journal,
+                          id: night.id,
+                          recording: widget.recording,
+                          action: widget.nightAction,
+                          read: widget.read,
+                        )),
+                  ),
+                },
+            ],
           ],
         ),
       ),
@@ -185,8 +207,35 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   }
 }
 
-/// The first empty journal's arrow, down to the record button: a thin line
-/// with a thin head, drawn as the chevrons are. Heard as nothing.
+/// New Dream (D110): a pill on the painted gradient, its words in the button
+/// type over it, opening the typing screen; heard as a button.
+class _NewDream extends StatelessWidget {
+  const _NewDream({required this.onPressed});
+
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) => Semantics(
+    button: true,
+    child: GestureDetector(
+      key: JournalPage.newDreamKey,
+      onTap: onPressed,
+      child: ClipRRect(
+        borderRadius: BorderRadius.circular(Spacing.radius),
+        child: NightArt(
+          const PaintedGradient(),
+          child: Padding(
+            padding: StandIns.buttonPadding,
+            child: Text(OwedLines.newDream.text, style: TypeRoles.button.style(NightArt.over)),
+          ),
+        ),
+      ),
+    ),
+  );
+}
+
+/// The first empty journal's arrow, up to New Dream: a thin line with a
+/// thin head, drawn as the chevrons are. Heard as nothing.
 class _Arrow extends StatelessWidget {
   const _Arrow({super.key, required this.colour});
 
@@ -210,13 +259,13 @@ class _ArrowLine extends CustomPainter {
   void paint(Canvas canvas, Size size) {
     const inset = StandIns.chevronStroke / 2;
     final mid = size.width / 2;
-    final tip = size.height - inset;
+    const tip = inset;
     final path = Path()
-      ..moveTo(mid, inset)
+      ..moveTo(mid, size.height - inset)
       ..lineTo(mid, tip)
-      ..moveTo(inset, tip - mid)
+      ..moveTo(inset, tip + mid)
       ..lineTo(mid, tip)
-      ..lineTo(size.width - inset, tip - mid);
+      ..lineTo(size.width - inset, tip + mid);
     canvas.drawPath(
       path,
       Paint()
@@ -232,9 +281,6 @@ class _ArrowLine extends CustomPainter {
   bool shouldRepaint(_ArrowLine old) => old.colour != colour;
 }
 
-// Three empty lines: the summary's least height, as laid out.
-const _threeLines = '\n\n';
-
 class _Divider extends StatelessWidget {
   const _Divider(this.text);
 
@@ -251,63 +297,40 @@ class _Divider extends StatelessWidget {
   );
 }
 
-/// A night's row: an unnamed night's date (h3), or a named night's name
-/// (h5) with its date under it in the button style; then the opening,
-/// always three lines, in the button type in color.text.summary (C10-P;
-/// D58 Q7; head's message 20, item 1); a chevron at its trailing edge
-/// (item 4).
+/// A night's row (D110): a rounded row carrying only its date, centred in
+/// h6 over the night's picture; heard as a button named by its date. A name
+/// kept from before naming was removed is not shown.
 class _Row extends StatelessWidget {
-  const _Row(this.night, {required this.onTap});
+  const _Row(this.night, {required this.look, required this.onTap});
 
   final Night night;
+  final NightLook look;
   final VoidCallback onTap;
 
   @override
-  Widget build(BuildContext context) {
-    final p = Palette.of(context);
-    final summary = TypeRoles.button.style(p.summary);
-    final name = night.name;
-    // Three lines as laid out, which rounds each line's height.
-    final three = TextPainter(
-      text: TextSpan(text: _threeLines, style: summary),
-      textDirection: TextDirection.ltr,
-      textScaler: MediaQuery.textScalerOf(context),
-    )..layout();
-    final lines = three.height;
-    three.dispose();
-    return Padding(
-      padding: const EdgeInsets.only(bottom: Spacing.journalRow),
+  Widget build(BuildContext context) => Padding(
+    padding: const EdgeInsets.only(bottom: Spacing.journalRow),
+    child: Semantics(
+      button: true,
       child: GestureDetector(
+        key: JournalPage.rowKey(night.id),
         onTap: onTap,
-        child: Container(
-          decoration: surface(p),
-          padding: StandIns.rowPadding,
-          child: Row(
-            children: [
-              Expanded(
-                child: Column(
-                  crossAxisAlignment: CrossAxisAlignment.start,
-                  children: [
-                    if (name == null)
-                      Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
-                    else ...[
-                      Text(name, style: TypeRoles.h5.style(p.text)),
-                      Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
-                    ],
-                    const SizedBox(height: 8),
-                    ConstrainedBox(
-                      constraints: BoxConstraints(minHeight: lines),
-                      child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
-                    ),
-                  ],
+        child: ClipRRect(
+          borderRadius: BorderRadius.circular(Spacing.radius),
+          child: ConstrainedBox(
+            constraints: const BoxConstraints(minHeight: StandIns.rowHeight),
+            child: NightArt(
+              look,
+              child: Center(
+                child: Padding(
+                  padding: StandIns.labelPadding,
+                  child: Text(dayDigits(night.date), style: TypeRoles.h6.style(NightArt.over)),
                 ),
               ),
-              const SizedBox(width: StandIns.chevronGap),
-              Chevron(colour: p.text),
-            ],
+            ),
           ),
         ),
       ),
-    );
-  }
+    ),
+  );
 }
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index b5c302c1e39ca39b917b8f85753359fe90de7acc..4e8323f5005c1d42cc6df83fe174bf09c44db145 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -30,13 +30,14 @@ import '../../recording/recording.dart';
 import '../journal.dart';
 import '../night.dart';
 import '../night_action.dart';
+import '../night_look.dart';
 import '../night_rules.dart';
 import '../row_text.dart';
 import 'parts.dart';
 import 'typing_page.dart';
 
 class NightPage extends StatefulWidget {
-  const NightPage({super.key, required this.journal, required this.id, this.recording, this.action});
+  const NightPage({super.key, required this.journal, required this.id, this.recording, this.action, this.read = noneRead});
 
   static const menuKey = Key('night-menu');
   static const deleteKey = Key('night-delete');
@@ -54,6 +55,9 @@ class NightPage extends StatefulWidget {
   /// The menu's item above delete, or null (D107 item 1).
   final NightAction? action;
 
+  /// Whether a night has been read: none is yet (the readings come later).
+  final ReadCheck read;
+
   @override
   State<NightPage> createState() => _NightPageState();
 }
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
index 65fadad57af5a7fdb27931c4b97681b3792f10a2..b2d083449b50cdcd42ca196797b77a3562093ef8 100644
--- a/app/lib/journal/pages/parts.dart
+++ b/app/lib/journal/pages/parts.dart
@@ -77,8 +77,7 @@ class PlainButton extends StatelessWidget {
 }
 
 /// Two pills at the foot of a page, one at each side; at large text each
-/// shrinks its words to stay on one row, as the record button does (Task
-/// 15a): Save and Start Interpretation, or Add dreams and Start
+/// shrinks its words to stay on one row: Save and Start Interpretation, or Add dreams and Start
 /// Interpretation (D70 8; head's message 20, item 10).
 class ButtonRow extends StatelessWidget {
   const ButtonRow({super.key, required this.left, required this.right});
@@ -97,58 +96,7 @@ class ButtonRow extends StatelessWidget {
   );
 }
 
-/// The record button: the biggest thing on the journal's screen, the
-/// terracotta gradient, its words in white (main-path.md, The Journal).
-class RecordButton extends StatelessWidget {
-  const RecordButton({super.key, required this.onPressed});
-
-  static const buttonKey = Key('record-button');
-
-  final VoidCallback onPressed;
-
-  @override
-  Widget build(BuildContext context) {
-    final p = Palette.of(context);
-    return Semantics(
-      button: true,
-      child: GestureDetector(
-        key: buttonKey,
-        onTap: onPressed,
-        // A circle (the owner's correction, P13): as wide as tall, its corner
-        // radius half of that. Its words shrink to fit, never stretch it.
-        child: SizedBox(
-          width: StandIns.recordWidth,
-          height: StandIns.recordHeight,
-          child: DecoratedBox(
-            decoration: BoxDecoration(
-              gradient: LinearGradient(
-                begin: Alignment.topCenter,
-                end: Alignment.bottomCenter,
-                colors: [p.recordTop, p.recordBottom],
-              ),
-              borderRadius: BorderRadius.circular(StandIns.recordHeight / 2),
-            ),
-            child: Padding(
-              padding: StandIns.buttonPadding,
-              child: Center(
-                child: FittedBox(
-                  fit: BoxFit.scaleDown,
-                  child: Text(
-                    Lines.MP_11.text(appLanguage),
-                    textAlign: TextAlign.center,
-                    style: TypeRoles.button.style(p.recordText),
-                  ),
-                ),
-              ),
-            ),
-          ),
-        ),
-      ),
-    );
-  }
-}
-
-/// A surface: a journal row or a dreamer's bubble (color.surface, radius).
+/// A surface: a dreamer's bubble (color.surface, radius).
 BoxDecoration surface(Palette p) => BoxDecoration(
   gradient: LinearGradient(
     begin: Alignment.topCenter,
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index 70e7054580b339230ecfc4bdd7357f57c8e42493..114f880084b7074b0c92b1108c2de0c6879585ed 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -362,7 +362,7 @@ void main() {
       ));
       await tester.pumpAndSettle();
       final journal = tester.widget<JournalPage>(find.byType(JournalPage)).journal;
-      await tester.tap(find.text(Lines.MP_11.text(Lang.en)));
+      await tester.tap(find.byKey(JournalPage.newDreamKey));
       await tester.pumpAndSettle();
       expect(find.byType(TypingPage), findsOneWidget);
       await go(journal);
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index 59e52a1b59ad32ababeaf32f985ef181c3b72315..92f1b7e04f393d206f6980cb647001710d7bb800 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -1,19 +1,23 @@
-// The journal list (main-path.md, The Journal; S5; D58 Q7; P5, P8): the
-// empty journal, rows newest first with no time and no count, dividers,
-// the record button opening the typing screen, a row opening its night.
+// The journal list (main-path.md, The Journal; S5; D58 Q7; P5; D110): the
+// greeting by time of day, New Dream opening the typing screen, no record
+// button, the empty journal, rows newest first carrying only the date over
+// the night's picture, dividers, a row opening its night.
 import 'dart:async';
 import 'dart:io';
 import 'dart:typed_data';
 
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
-import 'package:souldreams/app.dart';
 import 'package:souldreams/core/app_line.dart';
 import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/design/stand_ins.dart';
 import 'package:souldreams/design/tokens.g.dart';
+import 'package:souldreams/journal/greeting.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_action.dart';
+import 'package:souldreams/journal/night_look.dart';
+import 'package:souldreams/journal/owed.dart';
+import 'package:souldreams/journal/pages/night_art.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
@@ -57,20 +61,61 @@ final class BrokenFiles extends MemoryJournalFiles {
 }
 
 void main() {
-  testWidgets('the empty journal: C4-P·5 and the record button, nothing else', (tester) async {
+  testWidgets('the empty journal: the greeting, New Dream and C4-P·5', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal));
+    expect(find.text(OwedLines.greetingAfternoon.text), findsOneWidget);
+    expect(find.text(OwedLines.newDream.text), findsOneWidget);
     expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
-    expect(find.text(Lines.MP_11.text(Lang.en)), findsOneWidget);
-    // No Settings entry and no search (P8).
+    // The round record button is gone (D110).
+    expect(find.text(Lines.MP_11.text(Lang.en)), findsNothing);
+    // No Settings entry and no search: later branches.
     expect(find.text(Lines.MP_25.text(Lang.en)), findsNothing);
     expect(find.byType(TextField), findsNothing);
   });
 
+  // D110: a greeting by the part of the day, centred in h2, heard as a
+  // heading, above New Dream; it follows the clock while the page is open.
+  testWidgets('the greeting: by the clock, centred, a heading, above New Dream', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final greeting = find.text(OwedLines.greetingAfternoon.text);
+    final text = tester.widget<Text>(greeting);
+    expect(text.style!.fontFamily, TypeRoles.h2.family);
+    expect(text.style!.fontSize, TypeRoles.h2.size);
+    expect(text.textAlign, TextAlign.center);
+    expect(tester.getCenter(greeting).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
+    expect(tester.getRect(greeting).bottom, lessThan(tester.getRect(find.byKey(JournalPage.newDreamKey)).top));
+    final handle = tester.ensureSemantics();
+    expect(tester.getSemantics(greeting), matchesSemantics(label: OwedLines.greetingAfternoon.text, isHeader: true));
+    handle.dispose();
+    Harness.clock = stockholm(2026, 6, 10, 17);
+    await tester.pump(const Duration(minutes: 1));
+    expect(find.text(OwedLines.greetingEvening.text), findsOneWidget);
+    expect(greetingFor(Daypart.evening), OwedLines.greetingEvening);
+  });
+
+  // D110: New Dream, centred, the painted gradient behind its words, heard
+  // as a button.
+  testWidgets('New Dream: centred, on the painted gradient, a button', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final button = find.byKey(JournalPage.newDreamKey);
+    expect(tester.getCenter(button).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
+    final art = tester.widget<NightArt>(find.descendant(of: button, matching: find.byType(NightArt)));
+    expect(art.look, const PaintedGradient());
+    final words = tester.widget<Text>(find.text(OwedLines.newDream.text));
+    expect(words.style!.color, NightArt.over);
+    expect(words.style!.fontFamily, TypeRoles.button.family);
+    final handle = tester.ensureSemantics();
+    expect(tester.getSemantics(button), matchesSemantics(label: OwedLines.newDream.text, isButton: true, hasTapAction: true));
+    handle.dispose();
+  });
+
   // Onboarding's last step (main-path.md, Onboarding, 5): the first empty
-  // journal adds MP·9 with an arrow to the record button, shown once: gone
-  // when a night is there, and never on a later empty journal.
-  testWidgets('the first empty journal: MP·9 above the record button, once', (tester) async {
+  // journal adds MP·9 with an arrow up to New Dream, shown once: gone when a
+  // night is there, and never on a later empty journal.
+  testWidgets('the first empty journal: MP·9 under New Dream, once', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal, firstTime: true));
     final pointer = find.bySemanticsLabel(Lines.MP_9.text(Lang.en));
@@ -78,10 +123,11 @@ void main() {
     expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
     expect(find.byKey(JournalPage.arrowKey), findsOneWidget);
     final arrow = tester.getRect(find.byKey(JournalPage.arrowKey));
-    final record = tester.getRect(find.byKey(RecordButton.buttonKey));
-    expect(arrow.bottom, lessThanOrEqualTo(record.top));
-    expect(arrow.center.dx, closeTo(record.center.dx, 1));
-    expect(tester.getRect(find.byType(AppLine).last).bottom, lessThanOrEqualTo(arrow.top));
+    final button = tester.getRect(find.byKey(JournalPage.newDreamKey));
+    expect(arrow.top, greaterThanOrEqualTo(button.bottom));
+    expect(arrow.center.dx, closeTo(button.center.dx, 1));
+    final mp9 = tester.getRect(find.byWidgetPredicate((w) => w is AppLine && w.text == Lines.MP_9.text(Lang.en)));
+    expect(mp9.top, greaterThanOrEqualTo(arrow.bottom));
     // A night comes, then goes, on the same visit: MP·9 does not return.
     final night = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 7));
     Future<void> back() async {
@@ -119,7 +165,7 @@ void main() {
     expect(at.dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
   });
 
-  testWidgets('rows newest first: the date, then the trimmed opening', (tester) async {
+  testWidgets('rows newest first, carrying only the date', (tester) async {
     final h = await Harness.make();
     final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
     final newer = await keep(h, 'framed-opening-en', stockholm(2026, 6, 9, 23));
@@ -127,8 +173,10 @@ void main() {
     final newDate = tester.getTopLeft(find.text(dayDigits(newer.date)));
     final oldDate = tester.getTopLeft(find.text(dayDigits(older.date)));
     expect(newDate.dy, lessThan(oldDate.dy));
-    expect(find.text(opening(newer)), findsOneWidget);
-    expect(find.text(newer.dreams.first), findsNothing);
+    // No opening, no chevron (D110).
+    expect(find.text(opening(newer)), findsNothing);
+    expect(find.textContaining(newer.dreams.first.substring(0, 12)), findsNothing);
+    expect(find.byType(Chevron), findsNothing);
     // A row shows no time, and no count of dreams.
     expect(find.textContaining(':'), findsNothing);
     expect(find.textContaining('2 '), findsNothing);
@@ -156,58 +204,63 @@ void main() {
     expect(tester.getCenter(divider).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
   });
 
-  // Item 1: the summary in the button type, #767676 on the white row; in
-  // the dark theme, color.text on the bubble gradient (design-system.md §3).
-  testWidgets("the summary: the button type, the summary's colour", (tester) async {
-    final h = await Harness.make();
-    final n = await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
-    await h.pump(tester, JournalPage(journal: h.journal));
-    final light = tester.widget<Text>(find.text(opening(n)));
-    expect(light.style!.fontFamily, TypeRoles.button.family);
-    expect(light.style!.fontSize, TypeRoles.button.size);
-    expect(light.style!.color, LightColours.textSummary.colour);
-    await tester.pumpWidget(
-      SoulDreamsApp(key: UniqueKey(), home: JournalPage(journal: h.journal), clock: () => DateTime(2026, 6, 10, 22)),
-    );
-    await tester.pumpAndSettle();
-    expect(tester.widget<Text>(find.text(opening(n))).style!.color, DarkColours.text.colour);
-  });
-
-  // Item 4: a chevron at each row's trailing edge, in the text's colour,
-  // centred on the row's height, heard as nothing; item 12: rows 30 from
-  // the screen's sides, 12 apart (TO TRY).
-  testWidgets("a chevron at each row's trailing edge", (tester) async {
+  // D110: a rounded row, the date centred over the night's picture: an
+  // unread night's the painted gradient; 30 from the screen's sides, 12
+  // apart; heard as a button named by its date.
+  testWidgets("a row: the date over an unread night's gradient", (tester) async {
     final h = await Harness.make();
     final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
-    await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
+    final newer = await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
     await h.pump(tester, JournalPage(journal: h.journal));
-    final chevrons = find.byType(Chevron);
-    expect(chevrons, findsNWidgets(2));
-    final row = find.ancestor(of: find.text(dayDigits(older.date)), matching: find.byType(Container)).first;
-    final chevron = find.descendant(of: row, matching: find.byType(Chevron));
-    final rowBox = tester.getRect(row);
-    final mark = tester.getRect(chevron);
-    expect(rowBox.right - mark.right, closeTo(StandIns.rowPadding.right, 1));
-    expect(mark.center.dy, closeTo(rowBox.center.dy, 1));
-    expect(mark.left, greaterThan(tester.getRect(find.text(opening(older))).right));
-    expect(tester.widget<Chevron>(chevron).colour, LightColours.text.colour);
+    final arts = find.descendant(of: find.byType(ListView), matching: find.byType(NightArt));
+    // New Dream's, and one per row.
+    expect(arts, findsNWidgets(3));
+    for (final n in [older, newer]) {
+      final date = find.text(dayDigits(n.date));
+      final row = find.ancestor(of: date, matching: find.byKey(JournalPage.rowKey(n.id)));
+      final art = find.descendant(of: row, matching: find.byType(NightArt));
+      expect(tester.widget<NightArt>(art).look, const PaintedGradient());
+      expect(tester.getRect(art), tester.getRect(row));
+      expect(tester.getCenter(date).dx, closeTo(tester.getCenter(row).dx, 1));
+      expect(tester.getCenter(date).dy, closeTo(tester.getCenter(row).dy, 1));
+      final style = tester.widget<Text>(date).style!;
+      expect(style.color, NightArt.over);
+      expect(style.fontFamily, TypeRoles.h6.family);
+      expect(style.fontSize, TypeRoles.h6.size);
+      expect(tester.getSize(row).height, StandIns.rowHeight);
+      final clip = tester.widget<ClipRRect>(find.descendant(of: row, matching: find.byType(ClipRRect)));
+      expect(clip.borderRadius, BorderRadius.circular(Spacing.radius));
+    }
     final width = tester.getSize(find.byType(JournalPage)).width;
-    expect(rowBox.left, closeTo(Spacing.pageSide, 1));
-    expect(rowBox.right, closeTo(width - Spacing.pageSide, 1));
-    final rows = tester.widgetList<Container>(find.ancestor(of: find.byType(Chevron), matching: find.byType(Container)));
-    expect(rows, hasLength(2));
-    final tops = [for (final c in chevrons.evaluate()) tester.getRect(find.ancestor(of: find.byWidget(c.widget), matching: find.byType(Container)).first)];
-    expect(tops[1].top - tops[0].bottom, closeTo(Spacing.journalRow, 1));
+    final first = tester.getRect(find.byKey(JournalPage.rowKey(newer.id)));
+    final second = tester.getRect(find.byKey(JournalPage.rowKey(older.id)));
+    expect(first.left, closeTo(Spacing.pageSide, 1));
+    expect(first.right, closeTo(width - Spacing.pageSide, 1));
+    expect(second.top - first.bottom, closeTo(Spacing.journalRow, 1));
     final handle = tester.ensureSemantics();
-    expect(find.descendant(of: chevron, matching: find.byType(ExcludeSemantics)), findsOneWidget);
+    expect(
+      tester.getSemantics(find.byKey(JournalPage.rowKey(older.id))),
+      matchesSemantics(label: dayDigits(older.date), isButton: true, hasTapAction: true),
+    );
     handle.dispose();
   });
 
-  testWidgets('a named night shows its name, then its date', (tester) async {
+  testWidgets("a read night's row shows its painting", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    await h.pump(tester, JournalPage(journal: h.journal, read: (_) => true));
+    final row = find.byKey(JournalPage.rowKey(n.id));
+    final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
+    expect(art.look, Painting(paintingFor(n.id, NightArt.paintings)));
+    expect(find.text(dayDigits(n.date)), findsOneWidget);
+  });
+
+  // D110: naming a night is removed; a name kept from before is not shown.
+  testWidgets('a named night shows only its date', (tester) async {
     final h = await Harness.make();
     final n = await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 2, 23));
     final name = invented('named-three-dreams-sv').name!;
-    // Naming is not built (P7); a name reaches the store only directly.
+    // A name reaches the store only directly.
     await h.store.save(
       Night(
         id: n.id,
@@ -220,35 +273,22 @@ void main() {
       ),
     );
     await h.pump(tester, JournalPage(journal: h.journal));
-    final nameAt = tester.getTopLeft(find.text(name));
-    final dateAt = tester.getTopLeft(find.text(dayDigits(n.date)));
-    expect(nameAt.dy, lessThan(dateAt.dy));
-  });
-
-  testWidgets('the summary is always three lines', (tester) async {
-    final h = await Harness.make();
-    await keep(h, 'long-dream-en', stockholm(2026, 6, 2, 23));
-    await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
-    await h.pump(tester, JournalPage(journal: h.journal));
-    final long = find.textContaining(invented('long-dream-en').dreams.single.substring(0, 20));
-    final text = tester.widget<Text>(long);
-    expect(text.maxLines, 3);
-    expect(text.overflow, TextOverflow.ellipsis);
-    final short = find.text(invented('one-dream-sv').dreams.single);
-    expect(tester.getSize(short).height, closeTo(tester.getSize(long).height, 0.5));
+    expect(find.text(name), findsNothing);
+    expect(find.text(dayDigits(n.date)), findsOneWidget);
   });
 
-  testWidgets('the record button opens typing; a Save adds a row', (tester) async {
+  testWidgets('New Dream opens typing; a Save adds a row', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal));
-    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.tap(find.byKey(JournalPage.newDreamKey));
     await tester.pumpAndSettle();
     expect(find.byType(TypingPage), findsOneWidget);
     final dream = invented('one-dream-sv').dreams.single;
     await tester.enterText(find.byKey(TypingPage.fieldKey), dream);
     await tester.tap(find.byKey(TypingPage.saveKey));
     await tester.pumpAndSettle();
-    expect(find.text(dream), findsOneWidget);
+    final n = (await h.nights()).single;
+    expect(find.text(dayDigits(n.date)), findsOneWidget);
     expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsNothing);
   });
 
@@ -262,6 +302,16 @@ void main() {
     expect(find.text(n.dreams[1]), findsOneWidget);
   });
 
+  testWidgets("a row hands its night's page whether it is read", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    bool read(Night night) => night.id == n.id;
+    await h.pump(tester, JournalPage(journal: h.journal, read: read));
+    await tester.tap(find.text(dayDigits(n.date)));
+    await tester.pumpAndSettle();
+    expect(tester.widget<NightPage>(find.byType(NightPage)).read, same(read));
+  });
+
   testWidgets("a row hands its night's page the menu's item", (tester) async {
     final h = await Harness.make();
     final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
@@ -282,39 +332,17 @@ void main() {
     expect(tester.takeException(), isNull);
   });
 
-  // 15a (the owner's correction, P13): the record button is a circle.
-  testWidgets('the record button is a circle, radius half its height', (tester) async {
-    final h = await Harness.make();
-    await h.pump(tester, JournalPage(journal: h.journal));
-    final button = find.byKey(RecordButton.buttonKey);
-    final size = tester.getSize(button);
-    expect(size.width, size.height);
-    expect(size.height, StandIns.recordHeight);
-    final box = tester.widget<DecoratedBox>(find.descendant(of: button, matching: find.byType(DecoratedBox)).first);
-    expect((box.decoration as BoxDecoration).borderRadius, BorderRadius.circular(size.height / 2));
-  });
-
-  testWidgets('large text cannot stretch the record button', (tester) async {
-    tester.platformDispatcher.textScaleFactorTestValue = 3;
-    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
-    final h = await Harness.make();
-    await h.pump(tester, JournalPage(journal: h.journal));
-    expect(tester.takeException(), isNull);
-    final size = tester.getSize(find.byKey(RecordButton.buttonKey));
-    expect(size, Size(StandIns.recordHeight, StandIns.recordHeight));
-  });
-
-  // The final review: the record button reads the journal before the
-  // typing screen opens, so a second tap in that time must open nothing,
+  // The final review of journal-screens: New Dream reads the journal before
+  // the typing screen opens, so a second tap in that time must open nothing,
   // or one evening's dreams could be split into two nights.
-  testWidgets('two quick taps on the record button open one typing screen', (tester) async {
+  testWidgets('two quick taps on New Dream open one typing screen', (tester) async {
     final files = SlowFiles();
     final h = await Harness.make(files: files);
     await h.pump(tester, JournalPage(journal: h.journal));
     files.hold = Completer<void>();
-    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.tap(find.byKey(JournalPage.newDreamKey));
     await tester.pump(const Duration(milliseconds: 80));
-    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.tap(find.byKey(JournalPage.newDreamKey));
     await tester.pump(const Duration(milliseconds: 80));
     files.hold!.complete();
     await tester.pumpAndSettle();
@@ -323,7 +351,7 @@ void main() {
     await tester.tap(find.byKey(BackControl.buttonKey));
     await tester.pumpAndSettle();
     expect(find.byType(TypingPage, skipOffstage: false), findsNothing);
-    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.tap(find.byKey(JournalPage.newDreamKey));
     await tester.pumpAndSettle();
     expect(find.byType(TypingPage), findsOneWidget);
   });
@@ -350,19 +378,19 @@ void main() {
     expect(lines, ['journalListFailed']);
   });
 
-  testWidgets('a failed read at the record button opens nothing', (tester) async {
+  testWidgets('a failed read at New Dream opens nothing', (tester) async {
     final lines = await logged();
     final files = BrokenFiles();
     final h = await Harness.make(files: files);
     await h.pump(tester, JournalPage(journal: h.journal));
     files.broken = true;
-    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.tap(find.byKey(JournalPage.newDreamKey));
     await tester.pumpAndSettle();
     expect(find.byType(TypingPage), findsNothing);
     expect(lines, ['journalListFailed']);
     // The button works again once the folder reads.
     files.broken = false;
-    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.tap(find.byKey(JournalPage.newDreamKey));
     await tester.pumpAndSettle();
     expect(find.byType(TypingPage), findsOneWidget);
   });
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index faa2b003368b0bd0bbf312694a27d884ada91581..5ed806046691c7e0e0538cd96f42d5db3ded48b9 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -646,6 +646,8 @@ void main() {
     final chevron = tester.widget<Chevron>(find.descendant(of: back, matching: find.byType(Chevron)));
     expect(chevron.left, isTrue);
     expect(chevron.colour, LightColours.button.text);
+    final mark = find.descendant(of: back, matching: find.byType(Chevron));
+    expect(find.descendant(of: mark, matching: find.byType(ExcludeSemantics)), findsOneWidget);
     expect(find.byTooltip(Lines.MP_14.text(Lang.en)), findsOneWidget);
     final handle = tester.ensureSemantics();
     expect(tester.getSemantics(back).flagsCollection.isButton, isTrue);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index aecd4784e1adc4f65480a4e65ce74df3a7330d05..3f5bbc936074ff8e4b4ff9d5314c83420b326dc3 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -336,23 +336,15 @@ ROWS = [
      '      await widget.after;\n    } on ArgumentError {',
      'test/journal/pages/journal_home_test.dart', 'a phone check that throws does not keep the list away'),
     # Task 15a (P13, the owner's correction): the record button is a circle
-    ('A24ar', 'lib/journal/pages/parts.dart',
-     'borderRadius: BorderRadius.circular(StandIns.recordHeight / 2),',
-     'borderRadius: BorderRadius.circular(Spacing.radius),',
-     'test/journal/pages/journal_page_test.dart', 'the record button is a circle, radius half its height'),
-    ('A24as', 'lib/journal/pages/parts.dart',
-     '          width: StandIns.recordWidth,\n',
-     '',
-     'test/journal/pages/journal_page_test.dart', 'large text cannot stretch the record button'),
     # The journal-screens final review: one tap, one typing screen
     ('A24at', 'lib/journal/pages/journal_page.dart',
      '    if (_recording) return;\n',
      '',
-     'test/journal/pages/journal_page_test.dart', 'two quick taps on the record button open one typing screen'),
+     'test/journal/pages/journal_page_test.dart', 'two quick taps on New Dream open one typing screen'),
     ('A24au', 'lib/journal/pages/journal_page.dart',
      '    } finally {\n      _recording = false;\n    }\n',
      '    } finally {}\n',
-     'test/journal/pages/journal_page_test.dart', 'two quick taps on the record button open one typing screen'),
+     'test/journal/pages/journal_page_test.dart', 'two quick taps on New Dream open one typing screen'),
     # The final review: a night that is made always reads back
     ('A24', 'lib/journal/night.dart',
      "    if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');\n",
@@ -431,7 +423,7 @@ ROWS = [
     ('A41', 'lib/journal/pages/journal_page.dart',
      '        // Nothing opens; a code is logged (D71 Q18).\n        SafeLog.event(LogEvent.journalListFailed);\n',
      '',
-     'test/journal/pages/journal_page_test.dart', 'a failed read at the record button opens nothing'),
+     'test/journal/pages/journal_page_test.dart', 'a failed read at New Dream opens nothing'),
     ('A42', 'lib/journal/pages/typing_page.dart',
      '        if (mounted) setState(() => _firstUse = false);',
      '        if (mounted) setState(() => _firstUse = true);',
@@ -1258,26 +1250,10 @@ ROWS = [
      'Text(text, textAlign: TextAlign.center, style: TypeRoles.h4',
      'Text(text, style: TypeRoles.h4',
      'test/journal/pages/journal_page_test.dart', 'the month divider is centred'),
-    ('A252', 'lib/journal/pages/journal_page.dart',
-     'final summary = TypeRoles.button.style(p.summary);',
-     'final summary = TypeRoles.voiceDreamer.style(p.summary);',
-     'test/journal/pages/journal_page_test.dart', "the summary: the button type, the summary's colour"),
-    ('A253', 'lib/journal/pages/journal_page.dart',
-     'final summary = TypeRoles.button.style(p.summary);',
-     'final summary = TypeRoles.button.style(p.text);',
-     'test/journal/pages/journal_page_test.dart', "the summary: the button type, the summary's colour"),
-    ('A254', 'lib/journal/pages/journal_page.dart',
-     "const _threeLines = '\\n\\n';",
-     "const _threeLines = '\\n';",
-     'test/journal/pages/journal_page_test.dart', 'the summary is always three lines'),
-    ('A255', 'lib/journal/pages/journal_page.dart',
-     '              Chevron(colour: p.text),\n',
-     '',
-     'test/journal/pages/journal_page_test.dart', "a chevron at each row's trailing edge"),
     ('A256', 'lib/journal/pages/parts.dart',
      'Widget build(BuildContext context) => ExcludeSemantics(\n    child: SizedBox.fromSize(',
      'Widget build(BuildContext context) => Semantics(\n    child: SizedBox.fromSize(',
-     'test/journal/pages/journal_page_test.dart', "a chevron at each row's trailing edge"),
+     'test/journal/pages/typing_page_test.dart', 'the back control: a round bordered button, a chevron'),
     ('A257', 'lib/journal/pages/parts.dart',
      '                shape: BoxShape.circle,\n',
      '',
@@ -1457,7 +1433,7 @@ ROWS = [
     ('A301', 'lib/journal/pages/journal_page.dart',
      '      if (nights.isNotEmpty) _first = false;\n',
      '',
-     'test/journal/pages/journal_page_test.dart', 'the first empty journal: MP·9 above the record button, once'),
+     'test/journal/pages/journal_page_test.dart', 'the first empty journal: MP·9 under New Dream, once'),
     ('A302', 'lib/journal/pages/journal_page.dart',
      'nights.isEmpty && _first)',
      'nights.isEmpty)',
@@ -1544,7 +1520,7 @@ ROWS = [
      '',
      'test/journal/pages/night_page_test.dart', 'a given item runs once, with the night shown'),
     ('A322', 'lib/journal/pages/journal_page.dart',
-     '                              action: widget.nightAction,\n',
+     '                          action: widget.nightAction,\n',
      '',
      'test/journal/pages/journal_page_test.dart', "a row hands its night's page the menu's item"),
     ('A323', 'lib/journal/pages/journal_home.dart',
@@ -1769,6 +1745,39 @@ ROWS = [
      '  static const paintings = 5;',
      '  static const paintings = 4;',
      'test/journal/pages/night_art_test.dart', 'a few placeholder paintings stand in the set'),
+    # D110: the journal's greeting, New Dream and rows.
+    ('A373', 'lib/journal/pages/journal_page.dart',
+     '              header: true,\n              child: Text(\n                greetingFor(_daypart).text,',
+     '              header: false,\n              child: Text(\n                greetingFor(_daypart).text,',
+     'test/journal/pages/journal_page_test.dart', 'the greeting: by the clock, centred, a heading, above New Dream'),
+    ('A374', 'lib/journal/pages/journal_page.dart',
+     '      if (now != _daypart) setState(() => _daypart = now);\n',
+     '',
+     'test/journal/pages/journal_page_test.dart', 'the greeting: by the clock, centred, a heading, above New Dream'),
+    ('A375', 'lib/journal/pages/journal_page.dart',
+     '          const PaintedGradient(),\n          child: Padding(',
+     '          const Painting(0),\n          child: Padding(',
+     'test/journal/pages/journal_page_test.dart', 'New Dream: centred, on the painted gradient, a button'),
+    ('A376', 'lib/journal/pages/journal_page.dart',
+     'look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings),',
+     'look: lookOf(night, read: false, paintings: NightArt.paintings),',
+     'test/journal/pages/journal_page_test.dart', "a read night's row shows its painting"),
+    ('A377', 'lib/journal/pages/journal_page.dart',
+     '                          read: widget.read,\n',
+     '',
+     'test/journal/pages/journal_page_test.dart', "a row hands its night's page whether it is read"),
+    ('A378', 'lib/journal/pages/journal_page.dart',
+     'constraints: const BoxConstraints(minHeight: StandIns.rowHeight),',
+     'constraints: const BoxConstraints(),',
+     'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
+    ('A379', 'lib/journal/pages/journal_page.dart',
+     '      button: true,\n      child: GestureDetector(\n        key: JournalPage.rowKey(night.id),',
+     '      button: false,\n      child: GestureDetector(\n        key: JournalPage.rowKey(night.id),',
+     'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
+    ('A380', 'lib/journal/pages/journal_page.dart',
+     'TypeRoles.h6.style(NightArt.over)',
+     'TypeRoles.h6.style(Palette.of(context).text)',
+     'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
 ]
 
 
~~~~

### Task 6 · A night's page: the header with its picture and date; a read night's jump buttons

`night_page.dart`: the header (240 below the status bar, the picture from the screen's top, the back control and the menu over it, the date at its foot), no name, the jump buttons at the top of the scrolling part on a read night; stand-ins `headerHeight`, `jumpGap`, `jumpTime`, `jumpQuestions`. Tests: `night_page_test.dart` runs on a phone-sized view (the foot-buttons test on the wide default); the two named-night tests give way to one, the header and "nothing moved" tests to the header's own, and six new tests for the jump buttons and a read night at large text. Rows: A24ah and A270 dropped (naming; the page no longer uses `BelowTapBox`); A261, A263, A273 follow the code; A381 to A389 new.

Expected: 536 app tests; rows `A24ad,A24ae,A24ag,A261,A262,A263,A264,A265,A267,A268,A269,A273,A274,A381,A382,A383,A384,A385,A386,A387,A388,A389`, every one caught. Commit:

> A night's page: the header with its picture and date; a read night's jump buttons; no name (D110)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index d4bdec175074d38435e2c2bb42becd8f651b2b9c..d7770f6a6fdbed955b643999faf5cb139a261d36 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -41,6 +41,17 @@ abstract final class StandIns {
   /// (head's message 20, item 10).
   static const double menuWidth = 55;
 
+  /// A night's header, below the status bar (D110).
+  static const double headerHeight = 240;
+
+  /// A read night's jump buttons (D110): the space between two, how long a
+  /// jump scrolls, and the Questions button's gradient (no role is filed
+  /// for it; the others take the section label's, the tradition label's and
+  /// the dream tag's).
+  static const double jumpGap = 8;
+  static const jumpTime = Duration(milliseconds: 300);
+  static const jumpQuestions = [Color(0xFF8A5A1E), Color(0xFF5E3C12)];
+
   /// The first empty journal's arrow up to New Dream (main-path.md,
   /// Onboarding, 5): its size, and the space above and below it.
   static const firstArrow = Size(12, 32);
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index 4e8323f5005c1d42cc6df83fe174bf09c44db145..e9cb78d19684a6c92157cac50de653d0ec98e633 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -1,7 +1,11 @@
-// Inside a night, not yet read (main-path.md, The Journal, designs 2 and
-// 3; P1, P6, P7; D58 Q1, Q4, Q8; head's message 20, items 10 to 12): the
-// header centred (the date, or the name and the date); the "⋯" menu top
-// right, a bordered pill opening the phone's menu, spoken as MP·39,
+// Inside a night (main-path.md, The Journal, designs 2 and 3; P1, P6, P7;
+// D58 Q1, Q4, Q8; head's message 20, items 10 to 12; D110, head's message
+// 24): the header, the screen's width from its top, the night's picture (an
+// unread night's the painted gradient, a read night's its painting) with
+// its date centred over its foot; a name kept from before naming was
+// removed is not shown. Over the header, the back control top left and the
+// "⋯" menu top right, a bordered pill opening the phone's menu, spoken as
+// MP·39,
 // holding "delete this night" (EM·11's second part), plain, and above it
 // the item the entry point gives, if any (D107 item 1: the founder's
 // export, in SoulDreams Dev; R8); one
@@ -14,8 +18,12 @@
 // waits to be turned into text shows nothing in its place and cannot be
 // tapped; while it is being turned into text, AI·6 shows in its place,
 // heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
-// When its words come, the page shows them. Not built: naming, reading,
-// and the space below the dreams with its field.
+// When its words come, the page shows them. On a read night, under the
+// header, four jump buttons (Dreams, Questions, Readings, Reflection; their
+// words owed, shown as handles); Dreams brings "Dreams" into view, the
+// other three do nothing until their sections come with the readings. No
+// night is read yet. Not built: reading, and the space below the dreams
+// with its field.
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 
@@ -32,7 +40,9 @@ import '../night.dart';
 import '../night_action.dart';
 import '../night_look.dart';
 import '../night_rules.dart';
+import '../owed.dart';
 import '../row_text.dart';
+import 'night_art.dart';
 import 'parts.dart';
 import 'typing_page.dart';
 
@@ -45,6 +55,10 @@ class NightPage extends StatefulWidget {
   static const addKey = Key('night-add');
   static const startKey = Key('night-start');
   static const transcribingKey = Key('night-transcribing');
+  static const dreamsKey = Key('night-dreams');
+
+  /// A read night's jump button.
+  static Key jumpKey(Owed label) => ValueKey('jump-${label.handle}');
 
   final Journal journal;
   final String id;
@@ -68,6 +82,9 @@ class _NightPageState extends State<NightPage> {
   // A delete is in flight: the menu, Add dreams and the dreams wait (D64).
   bool _busy = false;
 
+  // The "Dreams" label, which its jump button brings into view.
+  final _dreamsLabel = GlobalKey();
+
   @override
   void initState() {
     super.initState();
@@ -231,77 +248,146 @@ class _NightPageState extends State<NightPage> {
     ),
   );
 
+  // Brings a section into view: only "Dreams" is built (D110).
+  void _jump(GlobalKey? section) {
+    final at = section?.currentContext;
+    if (at == null) return;
+    Scrollable.ensureVisible(at, duration: StandIns.jumpTime, curve: Curves.easeInOut);
+  }
+
+  // A read night's four jump buttons, centred, wrapping at large text.
+  Widget _jumps(Palette p) {
+    Widget jump(Owed label, List<Color> colours, GlobalKey? section) => Semantics(
+      button: true,
+      child: GestureDetector(
+        key: NightPage.jumpKey(label),
+        onTap: () => _jump(section),
+        child: DecoratedBox(
+          decoration: BoxDecoration(
+            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colours),
+            borderRadius: BorderRadius.circular(Spacing.radius),
+          ),
+          child: Padding(
+            padding: StandIns.labelPadding,
+            child: Text(label.text, style: TypeRoles.button.style(p.sectionText)),
+          ),
+        ),
+      ),
+    );
+    final tradition = LightColours.labelTradition;
+    final tag = LightColours.tagDream;
+    return Padding(
+      padding: const EdgeInsets.symmetric(horizontal: Spacing.pageSide),
+      child: Wrap(
+        alignment: WrapAlignment.center,
+        spacing: StandIns.jumpGap,
+        runSpacing: StandIns.jumpGap,
+        children: [
+          jump(OwedLines.jumpDreams, [p.sectionTop, p.sectionBottom], _dreamsLabel),
+          jump(OwedLines.jumpQuestions, StandIns.jumpQuestions, null),
+          jump(OwedLines.jumpReadings, [tradition.colour!, tradition.colourEnd!], null),
+          jump(OwedLines.jumpReflection, [tag.colour!, tag.colourEnd!], null),
+        ],
+      ),
+    );
+  }
+
   @override
   Widget build(BuildContext context) {
     final p = Palette.of(context);
     final n = _night;
     const side = EdgeInsets.symmetric(horizontal: Spacing.pageSide);
+    final top = MediaQuery.paddingOf(context).top;
+    final read = n != null && widget.read(n);
+    final controls = Padding(
+      padding: side,
+      child: Row(
+        crossAxisAlignment: CrossAxisAlignment.start,
+        children: [
+          BackControl(onPressed: () => Navigator.of(context).pop()),
+          const Spacer(),
+          _menu(p),
+        ],
+      ),
+    );
     return Scaffold(
-      body: SafeArea(
-        child: Column(
-          crossAxisAlignment: CrossAxisAlignment.stretch,
-          children: [
-            Padding(
-              padding: side,
-              child: Row(
-                children: [
-                  BackControl(onPressed: () => Navigator.of(context).pop()),
-                  const Spacer(),
-                  _menu(p),
-                ],
-              ),
-            ),
-            if (n != null) ...[
-              Expanded(
-                // The bubbles keep their own margins from the screen's edges
-                // (design-system.md §5); everything else keeps the page's.
-                child: BelowTapBox(
-                  child: ListView(
-                    children: [
-                      Padding(
-                        padding: Spacing.nightHeader.add(side),
-                        child: Semantics(
-                          header: true,
-                          child: n.name == null
-                              ? Text(dayDigits(n.date), textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text))
-                              : Column(
-                                  crossAxisAlignment: CrossAxisAlignment.stretch,
-                                  children: [
-                                    Text(n.name!, textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text)),
-                                    Text(
-                                      dayDigits(n.date),
-                                      textAlign: TextAlign.center,
-                                      style: TypeRoles.button.style(p.text),
-                                    ),
-                                  ],
-                                ),
-                        ),
-                      ),
-                      Padding(
-                        padding: side,
-                        child: Align(alignment: Alignment.centerLeft, child: SectionLabel(Lines.MP_38.text(appLanguage))),
-                      ),
-                      const SizedBox(height: StandIns.gap),
-                      for (final (i, d) in n.entries.indexed)
-                        if (d case Told(:final text)) ...[
-                          DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
-                          const SizedBox(height: StandIns.bubbleGap),
-                        ] else if (d case Waiting(:final audio) when _transcribing == audio) ...[
+      body: Column(
+        crossAxisAlignment: CrossAxisAlignment.stretch,
+        children: [
+          // The header: the picture from the screen's top, the controls
+          // under the status bar, the date at its foot (D110).
+          SizedBox(
+            height: top + StandIns.headerHeight,
+            child: n == null
+                ? Padding(padding: EdgeInsets.only(top: top), child: Align(alignment: Alignment.topCenter, child: controls))
+                : NightArt(
+                    lookOf(n, read: read, paintings: NightArt.paintings),
+                    child: Padding(
+                      padding: EdgeInsets.only(top: top),
+                      child: Column(
+                        crossAxisAlignment: CrossAxisAlignment.stretch,
+                        children: [
+                          controls,
+                          const Spacer(),
                           Padding(
-                            padding: side,
+                            padding: EdgeInsets.only(
+                              left: Spacing.pageSide,
+                              right: Spacing.pageSide,
+                              bottom: Spacing.nightHeader.bottom,
+                            ),
                             child: Semantics(
-                              key: NightPage.transcribingKey,
-                              liveRegion: true,
-                              child: AppLine(Lines.AI_6.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                              header: true,
+                              child: Text(
+                                dayDigits(n.date),
+                                textAlign: TextAlign.center,
+                                style: TypeRoles.h2.style(NightArt.over),
+                              ),
                             ),
                           ),
-                          const SizedBox(height: StandIns.bubbleGap),
                         ],
-                    ],
+                      ),
+                    ),
                   ),
-                ),
+          ),
+          if (n != null) ...[
+            Expanded(
+              // The bubbles keep their own margins from the screen's edges
+              // (design-system.md §5); everything else keeps the page's.
+              child: ListView(
+                padding: EdgeInsets.only(top: Spacing.nightHeader.top),
+                children: [
+                  // A read night's jump buttons head the part that scrolls.
+                  if (read) ...[_jumps(p), const SizedBox(height: StandIns.gap)],
+                  Padding(
+                    key: NightPage.dreamsKey,
+                    padding: side,
+                    child: Align(
+                      alignment: Alignment.centerLeft,
+                      child: SectionLabel(key: _dreamsLabel, Lines.MP_38.text(appLanguage)),
+                    ),
+                  ),
+                  const SizedBox(height: StandIns.gap),
+                  for (final (i, d) in n.entries.indexed)
+                    if (d case Told(:final text)) ...[
+                      DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
+                      const SizedBox(height: StandIns.bubbleGap),
+                    ] else if (d case Waiting(:final audio) when _transcribing == audio) ...[
+                      Padding(
+                        padding: side,
+                        child: Semantics(
+                          key: NightPage.transcribingKey,
+                          liveRegion: true,
+                          child: AppLine(Lines.AI_6.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                        ),
+                      ),
+                      const SizedBox(height: StandIns.bubbleGap),
+                    ],
+                ],
               ),
-              Padding(
+            ),
+            SafeArea(
+              top: false,
+              child: Padding(
                 padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.gap),
                 child: ButtonRow(
                   left: KeyedSubtree(
@@ -315,9 +401,9 @@ class _NightPageState extends State<NightPage> {
                   ),
                 ),
               ),
-            ],
+            ),
           ],
-        ),
+        ],
       ),
     );
   }
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index 82bd2f669f9cd8037003b2d088c159c80a3555e1..4bce9adde4b81a83a6963170644cefd85ddaa240 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -1,5 +1,7 @@
 // A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8; head's message 20,
-// items 10 to 12): header, "Dreams", the dreams; editing through the
+// items 10 to 12; D110): the header, its picture and date, the back control
+// and the menu over it; on a read night, the jump buttons; "Dreams", the
+// dreams; editing through the
 // typing screen; Add dreams and Start Interpretation at the foot; the menu,
 // a bordered pill opening the phone's menu, holding delete, spoken as
 // MP·39, and above it the item an entry point gives (D107 item 1); one confirmation, Cancel first, Delete destructive; deleting
@@ -16,6 +18,9 @@ import 'package:souldreams/design/tokens.g.dart';
 import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_action.dart';
+import 'package:souldreams/journal/night_look.dart';
+import 'package:souldreams/journal/owed.dart';
+import 'package:souldreams/journal/pages/night_art.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
@@ -56,13 +61,31 @@ final class UnsteadyFiles extends MemoryJournalFiles {
   }
 }
 
+/// A phone's screen, 390 by 844 (D110: the header takes 240 of it).
+void phone(WidgetTester tester) {
+  tester.view.physicalSize = const Size(1170, 2532);
+  tester.view.devicePixelRatio = 3;
+  addTearDown(tester.view.reset);
+}
+
 void main() {
   late Harness h;
   late Night n;
 
-  Future<void> open(WidgetTester tester, {UnsteadyFiles? files, String? name, NightAction? action}) async {
+  Future<void> open(
+    WidgetTester tester, {
+    UnsteadyFiles? files,
+    String? name,
+    NightAction? action,
+    ReadCheck read = noneRead,
+    String key = 'two-dreams-en',
+    bool wide = false,
+  }) async {
+    // The test's own 800 by 600, where the foot's two buttons do not fill
+    // the row, or a phone.
+    if (!wide) phone(tester);
     h = await Harness.make(files: files);
-    n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    n = await keep(h, key, stockholm(2026, 6, 2, 23));
     if (name != null) {
       // An invented name, added here and not in the fixture (D64).
       n = Night(
@@ -76,7 +99,7 @@ void main() {
       );
       await h.store.save(n);
     }
-    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action)));
+    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action, read: read)));
     await tester.tap(find.byKey(Opener.openKey));
     await tester.pumpAndSettle();
   }
@@ -141,6 +164,7 @@ void main() {
   // D93 Q3: while a waiting recording is turned into words, AI·6 shows in
   // its place, heard by a screen reader; then its words, as its own dream.
   testWidgets('AI·6 shows in its place while it is transcribed', (tester) async {
+    phone(tester);
     h = await Harness.make();
     n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
     final x = '1' * 32;
@@ -351,6 +375,13 @@ void main() {
     expect(tester.takeException(), isNull);
   });
 
+  testWidgets('a read night, text at twice the size: no overflow', (tester) async {
+    tester.platformDispatcher.textScaleFactorTestValue = 2;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await open(tester, read: (_) => true);
+    expect(tester.takeException(), isNull);
+  });
+
   // D64 (the review of Task 10): failures, a delete in flight, semantics.
   Future<List<String>> logged() async {
     final lines = <String>[];
@@ -430,18 +461,111 @@ void main() {
     handle.dispose();
   });
 
-  // Head's message 20, item 10: the date or the name centred.
-  testWidgets('the header is centred, the date or the name and date', (tester) async {
+  // D110: the header, the screen's width from its top, an unread night's
+  // painted gradient; the date centred over its foot in h2.
+  testWidgets("the header: the date centred over an unread night's gradient", (tester) async {
     await open(tester);
-    expect(tester.widget<Text>(find.text(dayDigits(n.date))).textAlign, TextAlign.center);
+    final date = find.text(dayDigits(n.date));
+    expect(tester.widget<Text>(date).textAlign, TextAlign.center);
     final width = tester.getSize(find.byType(NightPage)).width;
-    expect(tester.getCenter(find.text(dayDigits(n.date))).dx, closeTo(width / 2, 1));
+    expect(tester.getCenter(date).dx, closeTo(width / 2, 1));
+    final style = tester.widget<Text>(date).style!;
+    expect(style.color, NightArt.over);
+    expect(style.fontFamily, TypeRoles.h2.family);
+    final art = find.byType(NightArt);
+    expect(tester.widget<NightArt>(art).look, const PaintedGradient());
+    final box = tester.getRect(art);
+    expect(box, Rect.fromLTWH(0, 0, width, StandIns.headerHeight));
+    expect(box.bottom - tester.getRect(date).bottom, closeTo(Spacing.nightHeader.bottom, 1));
+    expect(tester.getTopLeft(find.text(Lines.MP_38.text(Lang.en))).dy, greaterThan(box.bottom));
+  });
+
+  // D110: naming is removed; a name kept from before is not shown.
+  testWidgets('a named night shows only its date', (tester) async {
+    await open(tester, name: 'Night by the harbour');
+    expect(find.text('Night by the harbour'), findsNothing);
+    expect(find.text(dayDigits(n.date)), findsOneWidget);
   });
 
-  testWidgets('a named night: the name and the date both centred', (tester) async {
-    await open(tester, name: 'Night by the harbour');
-    expect(tester.widget<Text>(find.text('Night by the harbour')).textAlign, TextAlign.center);
-    expect(tester.widget<Text>(find.text(dayDigits(n.date))).textAlign, TextAlign.center);
+  testWidgets('an unread night has no jump buttons', (tester) async {
+    await open(tester);
+    for (final o in [OwedLines.jumpDreams, OwedLines.jumpQuestions, OwedLines.jumpReadings, OwedLines.jumpReflection]) {
+      expect(find.text(o.text), findsNothing);
+    }
+  });
+
+  // D110: a read night shows its painting, and the four jump buttons in
+  // order, centred under the header, each heard as a button.
+  testWidgets('a read night: its painting, then four jump buttons', (tester) async {
+    final handle = tester.ensureSemantics();
+    await open(tester, read: (_) => true);
+    final art = tester.widget<NightArt>(find.byType(NightArt));
+    expect(art.look, Painting(paintingFor(n.id, NightArt.paintings)));
+    final header = tester.getRect(find.byType(NightArt));
+    final jumps = [OwedLines.jumpDreams, OwedLines.jumpQuestions, OwedLines.jumpReadings, OwedLines.jumpReflection];
+    final boxes = [for (final o in jumps) tester.getRect(find.byKey(NightPage.jumpKey(o)))];
+    for (final (i, b) in boxes.indexed) {
+      expect(b.top, greaterThan(header.bottom));
+      expect(b.bottom, lessThan(tester.getTopLeft(find.text(Lines.MP_38.text(Lang.en))).dy));
+      expect(tester.getSemantics(find.byKey(NightPage.jumpKey(jumps[i]))), matchesSemantics(
+        label: jumps[i].text, isButton: true, hasTapAction: true));
+      if (i > 0) expect(b.left > boxes[i - 1].right || b.top > boxes[i - 1].bottom, isTrue);
+    }
+    // Each row of them centred.
+    final width = tester.getSize(find.byType(NightPage)).width;
+    for (final top in {for (final b in boxes) b.top}) {
+      final row = boxes.where((b) => b.top == top);
+      expect((row.first.left + row.last.right) / 2, closeTo(width / 2, 1));
+    }
+    handle.dispose();
+  });
+
+  // The jump buttons' gradients: the section label's green, a stand-in
+  // brown, the tradition label's terracotta and the dream tag's blue.
+  testWidgets('the jump buttons: green, brown, terracotta, blue', (tester) async {
+    await open(tester, read: (_) => true);
+    List<Color> colours(Owed o) {
+      final box = tester.widget<DecoratedBox>(
+        find.descendant(of: find.byKey(NightPage.jumpKey(o)), matching: find.byType(DecoratedBox)),
+      );
+      return ((box.decoration as BoxDecoration).gradient! as LinearGradient).colors;
+    }
+
+    expect(colours(OwedLines.jumpDreams), [LightColours.labelSection.colour, LightColours.labelSection.colourEnd]);
+    expect(colours(OwedLines.jumpQuestions), StandIns.jumpQuestions);
+    expect(colours(OwedLines.jumpReadings), [LightColours.labelTradition.colour, LightColours.labelTradition.colourEnd]);
+    expect(colours(OwedLines.jumpReflection), [LightColours.tagDream.colour, LightColours.tagDream.colourEnd]);
+  });
+
+  // The jump buttons stand at the top of the scrolling part, so they scroll
+  // away with it; Dreams brings its label to the top of that part.
+  testWidgets('the Dreams jump brings "Dreams" to the top', (tester) async {
+    await open(tester, read: (_) => true, key: 'long-dream-en');
+    final list = tester.getRect(find.byType(ListView));
+    final jump = find.byKey(NightPage.jumpKey(OwedLines.jumpDreams));
+    expect(find.descendant(of: find.byType(ListView), matching: jump), findsOneWidget);
+    final label = find.text(Lines.MP_38.text(Lang.en));
+    expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, greaterThan(list.top + 10));
+    await tester.tap(jump);
+    await tester.pump();
+    await tester.pump(StandIns.jumpTime ~/ 2);
+    expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, greaterThan(list.top));
+    await tester.pumpAndSettle();
+    expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, closeTo(list.top, 1));
+    expect(label, findsOneWidget);
+  });
+
+  testWidgets('the three other jumps do nothing yet', (tester) async {
+    await open(tester, read: (_) => true, key: 'long-dream-en');
+    final at = tester.getRect(find.byKey(NightPage.dreamsKey));
+    for (final o in [OwedLines.jumpQuestions, OwedLines.jumpReadings, OwedLines.jumpReflection]) {
+      await tester.tap(find.byKey(NightPage.jumpKey(o)));
+      await tester.pumpAndSettle();
+      expect(tester.getRect(find.byKey(NightPage.dreamsKey)), at);
+      expect(find.byType(NightPage), findsOneWidget);
+      expect(find.byType(TypingPage), findsNothing);
+    }
+    expect(tester.takeException(), isNull);
   });
 
   // Item 10: the menu a bordered pill top right, on the page's margin.
@@ -500,14 +624,17 @@ void main() {
     expect(look.right - item.right, closeTo(0, 0.5));
   });
 
-  testWidgets('the back control and the pill: nothing moved', (tester) async {
+  // D110: the back control and the pill stand over the header, at its top.
+  testWidgets('the back control and the pill over the header', (tester) async {
     await open(tester);
     final back = find.byKey(BackControl.buttonKey);
     expect(tester.getSize(back), const Size(StandIns.backSize, StandIns.backSize));
     expect(tester.getSize(find.byKey(NightPage.menuKey)).height, StandIns.backSize);
     final top = tester.getTopLeft(back).dy;
+    expect(top, 0);
     expect(tester.getTopLeft(find.byKey(NightPage.menuKey)).dy, top);
-    expect(tester.getTopLeft(find.text(dayDigits(n.date))).dy, closeTo(top + StandIns.backSize + Spacing.nightHeader.top, 1));
+    expect(find.descendant(of: find.byType(NightArt), matching: back), findsOneWidget);
+    expect(find.descendant(of: find.byType(NightArt), matching: find.byKey(NightPage.menuKey)), findsOneWidget);
     await tester.tapAt(tester.getTopLeft(back) + const Offset(20, StandIns.hitMin - 1));
     await tester.pumpAndSettle();
     expect(find.byType(NightPage), findsNothing);
@@ -529,7 +656,7 @@ void main() {
   // the right, which does nothing yet (P3, as D71 Q3).
   testWidgets('Add dreams bottom left, Start Interpretation bottom right', (tester) async {
     final handle = tester.ensureSemantics();
-    await open(tester);
+    await open(tester, wide: true);
     expect(tester.getSemantics(find.byKey(NightPage.startKey)).flagsCollection.isButton, isTrue);
     final size = tester.getSize(find.byType(NightPage));
     final add = tester.getRect(find.byKey(NightPage.addKey));
@@ -554,19 +681,6 @@ void main() {
     handle.dispose();
   });
 
-  testWidgets('a named night shows name over date, as a heading', (tester) async {
-    final handle = tester.ensureSemantics();
-    await open(tester, name: 'Night by the harbour');
-    expect(find.text('Night by the harbour'), findsOneWidget);
-    expect(find.text(dayDigits(n.date)), findsOneWidget);
-    expect(
-      tester.getTopLeft(find.text('Night by the harbour')).dy,
-      lessThan(tester.getTopLeft(find.text(dayDigits(n.date))).dy),
-    );
-    expect(tester.getSemantics(find.text('Night by the harbour')).flagsCollection.isHeader, isTrue);
-    handle.dispose();
-  });
-
   testWidgets('text at twice the size, menu open: no overflow, delete reachable', (tester) async {
     tester.platformDispatcher.textScaleFactorTestValue = 2;
     addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 3f5bbc936074ff8e4b4ff9d5314c83420b326dc3..4b66db5d5a7b25fa6053171d50240b76c92ed9cd 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -294,10 +294,6 @@ ROWS = [
      'header: true,',
      'header: false,',
      'test/journal/pages/night_page_test.dart', 'the date is heard as a heading'),
-    ('A24ah', 'lib/journal/pages/night_page.dart',
-     'Text(n.name!, textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text)),',
-     'const SizedBox.shrink(),',
-     'test/journal/pages/night_page_test.dart', 'a named night shows name over date, as a heading'),
     # Task 12a (D65): the import walk, and the journal list after the phone check
     ('A24ai', 'test/dev_only_test.dart',
      '''(['"])(.+?)''',
@@ -1271,16 +1267,16 @@ ROWS = [
      '        button: false,\n        child: GestureDetector(\n          behavior',
      'test/journal/pages/typing_page_test.dart', 'the back control: a round bordered button, a chevron'),
     ('A261', 'lib/journal/pages/night_page.dart',
-     '? Text(dayDigits(n.date), textAlign: TextAlign.center,',
-     '? Text(dayDigits(n.date),',
-     'test/journal/pages/night_page_test.dart', 'the header is centred, the date or the name and date'),
+     '                                textAlign: TextAlign.center,\n                                style: TypeRoles.h2.style(NightArt.over),',
+     '                                style: TypeRoles.h2.style(NightArt.over),',
+     'test/journal/pages/night_page_test.dart', "the header: the date centred over an unread night's gradient"),
     ('A262', 'lib/journal/pages/night_page.dart',
      '                    border: Border.all(color: p.buttonBorder),\n                  ),\n                  child: Icon(',
      '                  ),\n                  child: Icon(',
      'test/journal/pages/night_page_test.dart', 'the menu: a bordered pill, top right'),
     ('A263', 'lib/journal/pages/night_page.dart',
-     '                  child: ListView(\n                    children: [',
-     '                  child: ListView(\n                    padding: side,\n                    children: [',
+     'padding: EdgeInsets.only(top: Spacing.nightHeader.top),',
+     'padding: EdgeInsets.only(top: Spacing.nightHeader.top) + side,',
      'test/journal/pages/night_page_test.dart', "the bubbles: 30 from the left edge, 10 from the right"),
     ('A264', 'lib/journal/pages/night_page.dart',
      'child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),',
@@ -1306,10 +1302,6 @@ ROWS = [
      'height: StandIns.hitMin,',
      'height: StandIns.backSize,',
      'test/journal/pages/night_page_test.dart', 'the back control and the pill take a tap in 44'),
-    ('A270', 'lib/journal/pages/parts.dart',
-     'minHeight: box.maxHeight + extra,\n        maxHeight: box.maxHeight + extra,',
-     'minHeight: box.maxHeight,\n        maxHeight: box.maxHeight,',
-     'test/journal/pages/night_page_test.dart', 'the back control and the pill: nothing moved'),
     ('A271', 'lib/journal/pages/parts.dart',
      'minHeight: box.maxHeight + extra,\n        maxHeight: box.maxHeight + extra,',
      'minHeight: box.maxHeight,\n        maxHeight: box.maxHeight,',
@@ -1319,8 +1311,8 @@ ROWS = [
      'alignment: Alignment.center,',
      'test/journal/pages/typing_page_test.dart', 'the back control: a round bordered button, a chevron'),
     ('A273', 'lib/journal/pages/night_page.dart',
-     'alignment: Alignment.topCenter,',
-     'alignment: Alignment.center,',
+     '              alignment: Alignment.topCenter,\n              child: SizedBox(\n                key: NightPage.menuKey,',
+     '              alignment: Alignment.center,\n              child: SizedBox(\n                key: NightPage.menuKey,',
      'test/journal/pages/night_page_test.dart', 'the menu: a bordered pill, top right'),
     ('A274', 'lib/journal/pages/night_page.dart',
      'Offset(StandIns.menuWidth, StandIns.backSize + 8)',
@@ -1778,6 +1770,43 @@ ROWS = [
      'TypeRoles.h6.style(NightArt.over)',
      'TypeRoles.h6.style(Palette.of(context).text)',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
+    # D110: a night's header, its picture and date; a read night's jump buttons.
+    ('A381', 'lib/journal/pages/night_page.dart',
+     'if (read) ...[_jumps(p), const SizedBox(height: StandIns.gap)],',
+     'if (false) ...[_jumps(p), const SizedBox(height: StandIns.gap)],',
+     'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
+    ('A382', 'lib/journal/pages/night_page.dart',
+     'lookOf(n, read: read, paintings: NightArt.paintings),',
+     'lookOf(n, read: false, paintings: NightArt.paintings),',
+     'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
+    ('A383', 'lib/journal/pages/night_page.dart',
+     'final read = n != null && widget.read(n);',
+     'final read = n != null;',
+     'test/journal/pages/night_page_test.dart', 'an unread night has no jump buttons'),
+    ('A384', 'lib/journal/pages/night_page.dart',
+     '    Scrollable.ensureVisible(at, duration: StandIns.jumpTime, curve: Curves.easeInOut);\n',
+     '',
+     'test/journal/pages/night_page_test.dart', 'the Dreams jump brings "Dreams" to the top'),
+    ('A385', 'lib/journal/pages/night_page.dart',
+     'jump(OwedLines.jumpReadings, [tradition.colour!, tradition.colourEnd!], null),',
+     'jump(OwedLines.jumpReadings, [tradition.colour!, tradition.colourEnd!], _dreamsLabel),',
+     'test/journal/pages/night_page_test.dart', 'the three other jumps do nothing yet'),
+    ('A386', 'lib/journal/pages/night_page.dart',
+     'jump(OwedLines.jumpReflection, [tag.colour!, tag.colourEnd!], null),',
+     'jump(OwedLines.jumpReflection, [tag.colourEnd!, tag.colour!], null),',
+     'test/journal/pages/night_page_test.dart', 'the jump buttons: green, brown, terracotta, blue'),
+    ('A387', 'lib/journal/pages/night_page.dart',
+     'style: TypeRoles.h2.style(NightArt.over),',
+     'style: TypeRoles.h2.style(p.text),',
+     'test/journal/pages/night_page_test.dart', "the header: the date centred over an unread night's gradient"),
+    ('A388', 'lib/journal/pages/night_page.dart',
+     'height: top + StandIns.headerHeight,',
+     'height: top + StandIns.headerHeight + 10,',
+     'test/journal/pages/night_page_test.dart', "the header: the date centred over an unread night's gradient"),
+    ('A389', 'lib/journal/pages/night_page.dart',
+     '      button: true,\n      child: GestureDetector(\n        key: NightPage.jumpKey(label),',
+     '      button: false,\n      child: GestureDetector(\n        key: NightPage.jumpKey(label),',
+     'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
 ]
 
 
~~~~

### Task 7 · Whether a night is read, handed down; SoulDreams Dev's preview

`JournalHome` takes `read` (default `noneRead`) and hands it to the journal; `main_dev.dart` passes `allRead` only when built with `--dart-define=PREVIEW_READ=true` (Part 4, Q15). Tests: `journal_home_test.dart` (2 new; the entry point's text test), `night_look_test.dart` (1). Rows: A323 and A341 follow the code; A390 to A393 new.

Expected: 539 app tests; rows `A24ap,A323,A341,A390,A391,A392,A393`, every one caught. Commit:

> SoulDreams Dev: whether a night is read reaches the pages; PREVIEW_READ shows every night as read, for the review (D110)

**The block:**

~~~~diff
diff --git a/app/lib/journal/night_look.dart b/app/lib/journal/night_look.dart
index 17bdd4adcc933efcbaeaa3d11ead4ba11532a0fa..3dcf617d9f15819b5230375352536c81759c7b09 100644
--- a/app/lib/journal/night_look.dart
+++ b/app/lib/journal/night_look.dart
@@ -47,3 +47,7 @@ typedef ReadCheck = bool Function(Night night);
 
 /// The readings come later, so no night is read yet.
 bool noneRead(Night night) => false;
+
+/// Every night read: SoulDreams Dev's by-eye preview of a read night's look
+/// only, in a build made with --dart-define=PREVIEW_READ=true (D110).
+bool allRead(Night night) => true;
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index 95b04b1d797875b8cb419358c45f45c8502edab3..17722ebf9485872f14224c49176ebc1f614830c4 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -26,10 +26,18 @@ import '../journal_audio.dart';
 import '../journal_files.dart';
 import '../journal_store.dart';
 import '../night_action.dart';
+import '../night_look.dart';
 import 'journal_page.dart';
 
 class JournalHome extends StatefulWidget {
-  const JournalHome({super.key, required this.files, this.after, this.recording, this.nightAction});
+  const JournalHome({
+    super.key,
+    required this.files,
+    this.after,
+    this.recording,
+    this.nightAction,
+    this.read = noneRead,
+  });
 
   final JournalFiles files;
 
@@ -43,6 +51,9 @@ class JournalHome extends StatefulWidget {
   /// The item each night's menu gains, or null (D107 item 1).
   final NightAction? nightAction;
 
+  /// Whether a night has been read (D110): none is yet.
+  final ReadCheck read;
+
   @override
   State<JournalHome> createState() => _JournalHomeState();
 }
@@ -163,7 +174,13 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     return switch (_agreed) {
       null => const Scaffold(),
       false => Onboarding(onAgreed: _agree),
-      true => JournalPage(journal: _journal!, recording: _recording, firstTime: _first, nightAction: widget.nightAction),
+      true => JournalPage(
+        journal: _journal!,
+        recording: _recording,
+        firstTime: _first,
+        nightAction: widget.nightAction,
+        read: widget.read,
+      ),
     };
   }
 }
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
index 0c59c048e000d06f3b547ebd0eceabb1398a3498..3dae903e8dfb9ac8f4dbb750dd813c52ed0b6656 100644
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -1,7 +1,9 @@
 // SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
 // nights only. It opens on onboarding until the dreamer agrees, then on the
 // journal (D49 O1; D56; D103). Each night's menu holds the founder's export
-// (D107; D108; R8 lets this file and main_founder.dart import it).
+// (D107; D108; R8 lets this file and main_founder.dart import it). Built
+// with --dart-define=PREVIEW_READ=true, every night shows as read, for the
+// owner's by-eye review of a read night's look (D110); nothing is stored.
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -12,6 +14,7 @@ import 'core/keyboard_check.dart';
 import 'core/safe_log.dart';
 import 'founder/founder_export.dart';
 import 'journal/channel_journal_files.dart';
+import 'journal/night_look.dart';
 import 'journal/pages/journal_home.dart';
 import 'journal/self_check.dart';
 import 'recording/connection.dart';
@@ -34,13 +37,14 @@ void main() {
     betaKey: const String.fromEnvironment('BETA_KEY'),
     connection: ChannelConnection(),
   );
+  const read = bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead;
   // The keyboard check (D50 1): only in a build made with
   // --dart-define=KEYBOARD_CHECK=true.
   runApp(
     SoulDreamsApp(
       home: const bool.fromEnvironment('KEYBOARD_CHECK')
           ? const KeyboardCheck()
-          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action),
+          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read),
     ),
   );
   if (check != null) unawaited(check);
diff --git a/app/test/journal/night_look_test.dart b/app/test/journal/night_look_test.dart
index 30a6982b0b4f2e13225e4147c780b87c61b49851..9caa6920d7dedd37ac48165a04cc44d41c0c076d 100644
--- a/app/test/journal/night_look_test.dart
+++ b/app/test/journal/night_look_test.dart
@@ -54,4 +54,8 @@ void main() {
   test('no night is read before the readings', () {
     expect(noneRead(nightWith(a)), isFalse);
   });
+
+  test("the preview's check calls every night read", () {
+    expect(allRead(nightWith(a)), isTrue);
+  });
 }
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index 114f880084b7074b0c92b1108c2de0c6879585ed..cc370f4e340bfb40840ee09969d0f4a958a69421 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -13,6 +13,7 @@ import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/journal_store.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_action.dart';
+import 'package:souldreams/journal/night_look.dart';
 import 'package:souldreams/journal/pages/journal_home.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
@@ -119,6 +120,20 @@ void main() {
     expect(tester.widget<JournalPage>(find.byType(JournalPage)).nightAction, same(action));
   });
 
+  testWidgets('whether a night is read is handed to the journal', (tester) async {
+    JournalStore.newQueueForTests();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), read: allRead)));
+    await tester.pumpAndSettle();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).read, same(allRead));
+  });
+
+  testWidgets('by default no night is read', (tester) async {
+    JournalStore.newQueueForTests();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
+    await tester.pumpAndSettle();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).read, same(noneRead));
+  });
+
   // D92 item 3: a recording waiting is retried only while the app is open:
   // when the journal opens and when the app comes back; leaving cuts it.
   testWidgets('the journal opening retries; leaving cuts it; back resumes', (tester) async {
@@ -203,8 +218,10 @@ void main() {
     // With each night's export (D108).
     expect(
       text,
-      contains('JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action)'),
+      contains('JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read)'),
     );
+    // Every night read only in a build made for the by-eye preview (D110).
+    expect(text, contains("bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead"));
     expect(text, contains("betaKey: const String.fromEnvironment('BETA_KEY')"));
   });
 
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 4b66db5d5a7b25fa6053171d50240b76c92ed9cd..677e0b6dc3a375a18a3e0a9f20d537369bb2ccf4 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1516,8 +1516,8 @@ ROWS = [
      '',
      'test/journal/pages/journal_page_test.dart', "a row hands its night's page the menu's item"),
     ('A323', 'lib/journal/pages/journal_home.dart',
-     ', nightAction: widget.nightAction)',
-     ')',
+     '        nightAction: widget.nightAction,\n',
+     '',
      'test/journal/pages/journal_home_test.dart', "the night's menu item is handed to the journal"),
     ('A324', 'lib/founder/export_text.dart',
      '[?night.name, dayDigits(night.date)]',
@@ -1594,8 +1594,8 @@ ROWS = [
      'try bytes.data.write(to: url, options: [])\n      let sheet',
      'test/founder/native_test.dart', 'the file is written with complete protection, in tmp'),
     ('A341', 'lib/main_dev.dart',
-     ', nightAction: const FounderExport().action)',
-     ')',
+     ', nightAction: const FounderExport().action, read: read)',
+     ', read: read)',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A342', 'lib/main.dart',
      "import 'core/safe_log.dart';\n",
@@ -1807,6 +1807,23 @@ ROWS = [
      '      button: true,\n      child: GestureDetector(\n        key: NightPage.jumpKey(label),',
      '      button: false,\n      child: GestureDetector(\n        key: NightPage.jumpKey(label),',
      'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
+    # D110: whether a night is read, handed down; SoulDreams Dev's preview.
+    ('A390', 'lib/journal/pages/journal_home.dart',
+     '        read: widget.read,\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'whether a night is read is handed to the journal'),
+    ('A391', 'lib/main_dev.dart',
+     "bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead",
+     "bool.fromEnvironment('PREVIEW_READ') ? allRead : allRead",
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
+    ('A392', 'lib/journal/night_look.dart',
+     'bool allRead(Night night) => true;',
+     'bool allRead(Night night) => false;',
+     'test/journal/night_look_test.dart', "the preview's check calls every night read"),
+    ('A393', 'lib/journal/pages/journal_home.dart',
+     '    this.read = noneRead,\n',
+     '    this.read = allRead,\n',
+     'test/journal/pages/journal_home_test.dart', 'by default no night is read'),
 ]
 
 
~~~~

### Task 8 · Docs: Status.md and the mutation runner's count

Status.md: "Last updated", the current branch, the road ahead, the app's redesign A and Word Animation, the counts (539 tests, 413 rows), banked items 136 to 139, and "Rulings during redesign-a": the c17p-import merge and D110. The runner's header: A1 to A393, the dropped rows and why, 413. Then the full run (D95), once, before the final review: `python3 -I -B tool/app_mutations.py` → `app mutations: 413 run, 413 caught`.

Expected: 539 app tests. Commit:

> Docs: Status.md for redesign-a (D110; the c17p-import merge recorded); 413 mutation rows

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
index 267aa30db5289ff4520a7c24b02ea2393be066f3..c3d34ff9cb5d40b3534b386bfd505acfa1e4badc 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-19, in branch `c17p-import` (the import and its follow-through; the owner's checks, then the merge, next), by Claude Code.
+Last updated: 2026-11-21, in branch `redesign-a` (the journal and a night's page to the new design, D110; the owner's by-eye review, then the merge, next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,12 +14,15 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`c17p-import`: Product's C17-P filing and Interpretation's record at C158-I (head's message 23), imported; the words,
-the pending lines (now none) and the design values follow it (D109). No plan: the head's task list.
+`redesign-a`: the journal and a night's page to the new design (D110, head's message 24; plan
+`docs/plans/redesign-a.md`). `c17p-import` is merged (`a2580db`).
 
 ## Road ahead
 
-- `c17p-import`: the owner's checks, then the merge.
+- `redesign-a`: the owner's by-eye review (the plan's Task 9), then the merge.
+- Redesign B and C (D110): search, Settings (with Word Animation's setting) and the consent's controls; then Life
+  Context, with C159-I's import, and "Made by AI". The curated set of night paintings (about 60, the founder's)
+  replaces the placeholders, fingerprinted as the fonts are (a G0 and G2 change, the owner's).
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1); the pending lines are filed at
   C17-P (and, for the founder app, with his export).
 - The readings: our server's own spending counter comes with them (D69), and response streaming on the function
@@ -179,17 +182,30 @@ the pending lines (now none) and the design values follow it (D109). No plan: th
   with every type Apple names excluded but AirDrop (and the people row on iOS 18 and later), gives the file to AirDrop
   alone (any other target receives nothing), and deletes it when the share closes; the folder is also emptied before
   each share and at launch. A failure shows nothing and logs `exportFailed`. No package.
-- The record button is a circle (Task 15a, the owner's correction, P13): `StandIns.recordWidth` and `recordHeight`
-  both 120, the radius half the height; large text shrinks its words, never the circle.
+- The redesign A (D110; `redesign-a`; TO TRY where a stand-in): the journal opens on a greeting by the part of the
+  day (05, 12, 17, 21 by the wall clock; `journal/greeting.dart`), centred in h2, then New Dream (a pill on the
+  painted gradient) opening the typing screen as the record button did, which is gone; each night a rounded row of
+  at least 64 carrying only its date (h6) over the night's picture; month dividers and C4-P·5 as before; the first
+  empty journal's MP·9 under New Dream, its arrow pointing up. A night's page: a header 240 below the status bar,
+  the night's picture from the screen's top with the back control and the menu over it and the date (h2) at its
+  foot; on a read night, four jump buttons at the top of the scrolling part (Dreams brings "Dreams" to the top; the
+  other three do nothing until the readings); everything below as before. Naming is removed: a name kept in a file
+  is not shown (the store's field stays; the export still writes it). A night's picture (`journal/night_look.dart`,
+  `pages/night_art.dart`): a read night's painting chosen from its id alone, nothing stored; an unread night's the
+  painted gradient (the dark theme's bubble gradient, both themes); no night is read yet (`noneRead`), and
+  SoulDreams Dev built with `--dart-define=PREVIEW_READ=true` shows every night as read, for the owner's review.
+  Five placeholder paintings, drawn in code, stand in the curated set. The words Product owes show as provisional
+  handles, `[owed·…]` (`journal/owed.dart`): four greetings, New Dream, the four jump buttons.
 - The night rules (`app/lib/journal/night_rules.dart`, `journal.dart`): a night stores its closing instant, the
   first 21:00 after its first recording in the zone then in force (format version 1, D57 Q14); the typing screen's
   target is fixed when it opens; an empty Save keeps nothing; an emptied dream disappears; a night with no dream left
   is deleted (D58 Q2, Q3; P9, P10).
 - Night/Day automatic (`app/lib/core/night_day.dart`): dark 21:00 to 08:00 by the phone's clock, a five-second
   ease-in-out fade while the app is open (head's message 20, item 13), instant with Reduce Motion (read from the platform's own flag, which iOS does not put
-  in `MediaQuery`), at start and on returning (D57 Q15). The app's own lines appear whole: Word Animation is off
-  everywhere by default (D106 2; `wordAnimation` in `app/lib/core/app_line.dart`, which a test alone turns on until
-  Settings; with it on, a word every 60 ms, D58 Q17, and whole with Reduce Motion). The palette (`app/lib/design/palette.dart`) fades with the
+  in `MediaQuery`), at start and on returning (D57 Q15). Word Animation is on by default, and only the app's
+  responses appear word by word (D110, superseding D106 2's "off everywhere"; `AppLine(response: true)`, used by none
+  yet); every other line appears whole, and a response too with the setting off or Reduce Motion on (a word every
+  60 ms, D58 Q17; the setting comes with Settings). The palette (`app/lib/design/palette.dart`) fades with the
   theme. The app shows English only (D57 Q12; `app/lib/core/language.dart`).
 - Packages: `flutter_localizations` (SDK) and `intl` 0.20.3, the owner's pub add (D57 Q9): the month names, and
   Flutter's own framework words, which are not ours under R1. `record` 7.1.2, exactly, the owner's pub add (D71
@@ -210,10 +226,11 @@ the pending lines (now none) and the design values follow it (D109). No plan: th
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 509 tests, and 383 mutation checks (A1 to A354; A55, A73, A80 to A83, A86 to A88, A94, A99,
-  A128 to A130, A142, A207, A213 and A223 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
+- The app's analyzer baseline: `No issues found!`. The app has 539 tests, and 413 mutation checks (A1 to A393; A24ah,
+  A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270
+  and A313 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 383 run, 383 caught`); `check_all.sh` does not call it (D55). During a task only the
+  (expected: `app mutations: 413 run, 413 caught`); `check_all.sh` does not call it (D55). During a task only the
   rows that target the files changed are run, with `--rows A1,A7` or `--files lib/a.dart` (D95).
 
 ## The server
@@ -761,6 +778,18 @@ Banked in c17p-import (D91; none changes what the dreamer sees beyond D109 and t
 135. §6 at C17-P (Word Animation off by default, about one word every 60 ms when on, the theme's fade ease-in-out
      over five seconds) was already built as filed; no value moved.
 
+Banked in redesign-a (D91; none changes what the dreamer sees beyond D110; the plan's Part 4 holds the questions):
+
+136. `opening()` in `row_text.dart` (the first dream with TECH·1's framing trimmed) is no longer shown; it stays,
+     tested, for search (a later branch). `Palette.summary` and the record colours are unused; `color.record` stays
+     in the tokens as filed.
+137. MP·39, the menu's spoken name, still names naming (as banked item 76); its words are Product's.
+138. The jump buttons' colours: the section label's green, the tradition label's terracotta, the light theme's dream
+     tag's blue (in both themes) and a stand-in brown for Questions, after the founder's screen; the header's height,
+     the rows' height and the greeting's places are stand-ins (`stand_ins.dart`), for the founder's look.
+139. A night's header does not scroll; on a short phone at large text the dreams have less room (the tests' phone,
+     390 by 844, has room at twice the size).
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
@@ -1062,6 +1091,20 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 - D109 (owner): "English written, Swedish to write" is a waiting status with no line, as "to write" (W12, W13); the
   readings branch revisits them (Cohort 0 is English only). C125-I·3 to rewrite: noted, unused, nothing to do.
 
+## Rulings during redesign-a
+
+- `c17p-import` merged by the owner (`a2580db`); its Status was not updated at the merge (this entry records it).
+- D110 (founder, 2026-11-20; head's message 24, with message 25 on the night's image): the redesign. The journal: a
+  greeting by time of day; New Dream opening the typing screen; the round record button removed; rounded rows
+  carrying only the date over the night's image, an unread night's the painted gradient; naming a night removed
+  (MP·28 and the menu's naming). A night's page: a header with its image and date; on read nights, jump buttons to
+  Dreams, Questions, Readings and Reflection; an unread night, the gradient header and no jump buttons. Word by word
+  only for the app's responses, on by default (supersedes D106 2's "off everywhere"). The night's image: a curated
+  set shipped in the app, placeholders until the founder's (about 60); the gradient where there is no image. Owed
+  words show as handles. Where it differs from the C17-P copies (the record button, naming, Word Animation's
+  default), D110 governs, listed for Product's next filing. Search, Settings, consent, Life Context and "Made by
+  AI" are later branches. D91 and D95 apply.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C17-P state (`d8d71c3`), in branch `c17p-import`; the nine
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 677e0b6dc3a375a18a3e0a9f20d537369bb2ccf4..a1f32c39d23b3307dbac579346ff1afb2ca57bb4 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A358, A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A393, A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 386 run, 386 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 413 run, 413 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
~~~~

### Task 9 · [OWNER] The by-eye review, SoulDreams Dev, invented nights only

By eye only, with no DevTools (D99), in SoulDreams Dev built from this branch, with invented nights (typed from
`fixtures/invented-nights.json`). Build it twice: as usual, and then with `--dart-define=PREVIEW_READ=true` added to
the usual build command, for steps 6 and 7. Check each step in the light theme and, where it says so, in the dark one
(after 21:00 or before 08:00). If any result differs, stop and bring it to the Build chat; nothing is fixed on the
phone. Owed words show as `[owed·…]`: that is expected.

1. **The journal (light and dark).** At the top, centred, a large serif `[owed·greeting-…]` for the time of day:
   `morning` from 05:00, `afternoon` from 12:00, `evening` from 17:00, `night` from 21:00. Under it, a pill on a
   deep purple gradient with `[owed·new-dream]` in light text. No round record button anywhere. No settings gear,
   search field or sun.
2. **The greeting follows the clock.** With the app open across one of those hours (or after changing the hour in
   Settings and coming back), the greeting changes within a minute.
3. **New Dream** opens the typing screen. Save an invented night, and the journal shows its row. A second quick tap
   opens no second screen.
4. **A row (unread, so every row today).** A rounded row, about 64 tall, on the same purple gradient, carrying only
   its date (`dd/mm/yyyy`) centred in light text: no summary and no chevron. Rows about 30 from the sides and about
   12 apart, with the month dividers as before. Tapping a row opens its night.
5. **The first empty journal** (only if convenient: a fresh install of SoulDreams Dev, through onboarding, which
   loses its invented nights; otherwise skip, as the tests cover it): MP·9 under New Dream, with a thin arrow between
   them pointing up to the button; "This is where your journal entries will appear." further down. Once a night is
   saved, MP·9 and the arrow do not come back.
6. **A night's page (unread, the usual build; light and dark).** At the top, the purple gradient from the screen's
   top edge, about 240 below the status bar, with the back control top left and the "⋯" pill top right over it, and
   the date large and centred at its foot in light text. No jump buttons. Below it, as before: "Dreams", the bubbles,
   Add dreams and Start Interpretation, the menu with the export and "Delete this", and the confirmation.
7. **A read night (the `PREVIEW_READ=true` build).** Each row shows a calm painting (sky, a soft light, two ridges)
   in place of the gradient, the same one every time for the same night, with different nights showing different
   ones among five. A night's page shows the same painting in its header. Under the header, four pills, centred and
   wrapping if they must: `[owed·jump-dreams]` green, `[owed·jump-questions]` brown, `[owed·jump-readings]`
   terracotta, `[owed·jump-reflection]` blue. With a long invented night, tapping the green one scrolls "Dreams" to
   the top. The other three do nothing.
8. **Words appear whole.** Onboarding, the journal, the typing screen's lines and AI·6 all appear at once, never
   word by word (no response is built yet).
9. **Large text** (the phone's text size at its largest): the journal and a night's page (also in the preview build)
   show no cut-off or overlap; the jump pills wrap.
10. **The founder's verdict, TO TRY** (P13): the header's height (240), the rows' height (64), the greeting's place,
    the painted gradient's colours and the jump pills' colours. Keep, or the values he wants.

## Part 4 · Questions (numbered; a blank is not a yes)

**For Product, through the head.** Each changes a screen or a word, so Product decides it. The blocks build the lean,
and the owner's look (Task 9) can inform each answer.

1. **The greetings' parts of the day.** No document gives them. *Lean, as built:* four, with morning from 05:00,
   afternoon from 12:00, evening from 17:00 and night from 21:00 (the dark theme's hour); Product files four lines.
   Fewer or other hours change one table in `greeting.dart`.
2. **The sun above the greeting** (in `journal.png`) is not named in D110. *Lean:* not built until Product says
   whether there is one and what it is (a drawn mark, one per part of the day, or none). An emoji would be a word
   under R1.
3. **New Dream's look.** *Lean, as built:* a pill on the painted gradient, its words in the button type in light
   text (the screenshot shows a night-sky image inside it). Product files the words.
4. **"The painted gradient".** D110 gives no colours. *Lean, as built (stand-in):* the dark theme's bubble gradient
   (#3D376E → #26214F) in both themes, with words over it in #F5F5EC (contrast well above 4.5:1). Product sets the
   gradient and the colour of words over a picture.
5. **The rows.** *Lean, as built:* the month dividers stay, since D110 does not remove them (the screenshot shows
   none). The date stays MP·27's `dd/mm/yyyy` (the screenshot shows `dd/mm/yy`). The date is in h6, rows at least 64
   tall at radius 30, with no border (the screenshot shows a thin dark edge), 30 from the sides (the screenshot's
   rows look narrower) and 12 apart (filed).
6. **The first empty journal.** With the record button gone, MP·9 ("Click here to record your first dream") and its
   arrow point up to New Dream from under it. *Lean, as built;* Product checks that MP·9's words still fit, or files
   new ones.
7. **A night's header.** *Lean, as built (stand-in):* 240 below the status bar, fixed (it does not scroll), with the
   date in h2 in light text at its foot.
8. **The jump buttons.** *Lean, as built:* at the top of the part that scrolls, under the header and above "Dreams",
   which stays as its own label. Colours: the section label's green, a stand-in brown, the tradition label's
   terracotta, and the light theme's dream-tag blue (in both themes). Questions, Readings and Reflection do nothing
   until their sections come with the readings. Product files the four words and the brown.
9. **"Dreams" stays left**, as built (the screenshot centres it; never ruled, as in journal-design).
10. **MP·39, the menu's spoken name, says "Name or delete this"**, and naming is gone (D110). *Lean:* MP·39 stays as
    filed until Product refiles it; a screen reader hears the old words meanwhile.
11. **The night's picture is silent to a screen reader.** *Lean, as built:* decoration, with the date heard as the
    page's heading. If Product wants it described, that is a new place.
12. **For Product's next filing: where D110 differs from the C17-P copies** (D110 governs, as built):
    a. `main-path.md`, The Journal (line 577 and around it): the record button, "the biggest thing on the screen", and
       the journal's list with summaries; now New Dream, the greeting, and rows with the date alone.
    b. Naming a night: MP·28 (register), MP·39's words, and the menu's naming in `main-path.md`.
    c. `design-system.md` §3, `color.record` (the record button's gradient), now unused; §5's controls table (the
       record button a 120 circle, the row's chevron).
    d. `design-system.md` §6 and How the AI Appears §4 and §5: Word Animation "Off by default, everywhere"; now on
       by default, word by word only for the app's responses.
    e. Places not yet in the register: the four greetings, New Dream, the four jump buttons, the painted gradient,
       the night's picture (a curated set), and read versus unread nights.

**For the owner (how to build).**

13. **How a night's picture is chosen.** *Lean, as built:* from its id alone (128 random bits already), so nothing is
    stored and there is no storage change. When the set grows from 5 to about 60, each read night's picture changes
    once; no read night exists yet. The alternative, a picture index stored in each night's file, is a storage change
    (docs/workflow.md (c)).
14. **The placeholder paintings.** *Lean, as built:* five drawn in code, with no file, package or guard change; the
    founder's set replaces them in a later branch, fingerprinted as the fonts are (a G0 and G2 change, the owner's).
    The alternative is a few placeholder image files supplied by the owner now, with that same guard change made
    here.
15. **SoulDreams Dev's `PREVIEW_READ` switch** (every night shown as read, nothing stored), so the owner can see a
    read night before the readings exist. *Lean:* yes, Dev only, as `JOURNAL_SELF_CHECK` and `KEYBOARD_CHECK` are;
    it goes when the readings make nights read.
16. **The provisional handles `[owed·…]`** in `lib/journal/owed.dart`, for places with no register handle yet.
    *Lean:* yes, listed in Part 1 and in Status.md; each goes when Product files its line.
17. **"On by default" with nothing that animates.** *Lean, as built:* the default is on and only `AppLine(response:
    true)` animates; none exists until the readings, so the owner sees no change. The theme's fade stays as built.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/ra/build`, from `git archive` of `a2580db`, each
   task's state kept as a snapshot (`./.scratch/ra/snaps/<task>`). Each block in Part 3 is `git diff --no-index`
   between two snapshots. Harness files (`.claude/`) and Python's `__pycache__` are left out of every snapshot, on
   every side.
2. **The counts measured on the build**: app tests 513 (baseline), 515, 525, 531, 531, 536, 539, 539, with
   `No issues found!` at each.
3. **Test first**: Tasks 2 to 4's new tests were run on the code before them and failed to load. Tasks 5 to 7's tests
   name what their task adds, so they cannot load before it. Each assertion was then shown to bite by its row (item
   4). Four tests changed during the build so that a row could bite or a tap could land: the picture's silence test
   (its first form checked only that an `ExcludeSemantics` existed, and the first code had `excluding: false`; both
   fixed before the rows ran); "the three other jumps do nothing yet" (a long night and the label's place, so A385
   bites); the foot-buttons test back on the wide view (A265 survived on the phone view); and the night page's
   tests on a phone-sized view (on 800 by 600, the 240 header left the second dream under the foot).
4. **Mutations on the build** (D95: every row of the files changed, at each task's state): Task 2 `6 run, 6 caught`;
   Task 3 `7 run, 7 caught`; Task 4 `5 run, 5 caught`; Task 5 `29 run, 29 caught` (journal page, parts, stand-ins)
   plus A299; Task 6 `28 run, 28 caught` (night page) and parts `11 run, 10 caught`, where A265 survived, fixed as in
   item 3 and then caught; every row naming the four page test files `73 run, 73 caught`; Task 7 `27 run, 27
   caught`.
5. **The guards** on each snapshot: G4 first refused four test names of twelve words or more (Tasks 3 and 4), each
   shortened in its task. Then `guards (walk): all passed` on every snapshot. The screenshots: HEAD's tree with the
   owner's five in place of the seven passes the guards (`guards (walk): all passed`), and each file's sha256 matches
   `fingerprints.txt`.
6. **Replayed on a fresh copy**, `./.scratch/ra/replay`, from `git archive` of `a2580db`: every block applied with
   `git apply` in order (with `GIT_CEILING_DIRECTORIES` set, so `git apply` is not silently skipped inside the
   repository), and after each, the replayed tree compared with its snapshot: no difference. On the replayed tree:
   `guards (walk): all passed`, `No issues found!`, `+539: All tests passed!`, and the 35 new and 15 followed rows
   `app mutations: 50 run, 50 caught`.
7. **Not run in the sandbox (D95)**: the full mutation run, which belongs at the end of the branch (Task 8);
   `tool/check_all.sh` whole (banked item 74; the owner's).
8. **Not provable in the sandbox, so the owner's** (Task 9): the look on the phone in both themes; the placeholder
   paintings' calm; the header under the status bar and the notch; the greeting changing with the clock; the jump's
   scroll; large text on a real phone.
9. The guards and their tests, the server, Swift and the words are unchanged (241 guard tests, 47 server tests).
10. The scratch copies (`./.scratch/ra/`) are deleted after this plan is committed.

*No matter where you are on your journey, the steps you take are equally important.*
