# Plan: search (redesign-b)

Branch `redesign-b`, from `main` at `e81f29c`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D95. Written by Claude Code (Opus) on 2026-11-21. The investigation stopped once (D116 item 4: the
register had no place for the count lines); D117 answered it.

**Amended to C18-P** (the owner's task of 2026-11-21, head's message 29). The import is committed (`3e95600`).
Product filed search's lines: the count is MP·76 ("1 match", "{n} matches"; a slot), the empty result W25 ("No
matches"). The handles MP·66 to MP·68 the first plan gave the pending lines are now C18-P's consents. So the first
plan's Tasks 1 and 2 (a pending line with slots, and the owner's pending lines) are dropped, and no line is pending.
D119 item 4 adds a first task: the filed lines for the handles still on screen (the greeting, New Dream, the jump
buttons). The match is Inter Bold, now bundled (D118's import), where the first plan had SemiBold. Every block is
rebuilt on the import's commit and proven again (Part 5). The owner's checks are by eye only.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

First, the journal and a night's page take the lines Product has now filed for the places that still showed
handles: the greeting by the part of the day (MP·72 to MP·75, one of each part's four lines a day, in turn), New
Dream (MP·11) and a read night's four jump buttons (MP·77).

Then search. The journal gets a search field at the top, as in the founder's screenshot. Once the dreamer has typed
three characters, the journal shows only the nights whose dreams contain what they typed. Above those rows it shows a
count ("1 match", "{n} matches") or, when nothing is found, "No matches". Under each row is one line of context: a few
words before the match, the match in bold, and what follows. Tapping a result opens the night with the match in bold
in its dream. Back under three characters, the journal is as before.

Matching ignores capital letters, keeps å, ä, ö and other letters with marks distinct, and finds the typed characters
only at the start of a word. "hus" finds "huset" but never the "hus" inside a longer word. It searches the told dreams
of every night, not names, readings or Life Context. Each night counts as one match, at its first place. The matcher
is one function, which recurring images will reuse later.

### What this branch builds

1. **The filed lines on screen** (D119 item 4; C18-P):
   - **The greeting** (`greeting.dart`): the part of the day from 05:00, 11:00, 17:00 and 21:00, start-inclusive
     (C18-P; the app had 12:00 where the filing has 11:00), each with its place (MP·72 morning, MP·73 day, MP·74
     evening, MP·75 night). Each place holds four lines; one shows a day, the four in turn, by the calendar day
     counted from 1970. A night after midnight keeps the line of the evening it began on, so the greeting never
     changes inside a part (decided under D91, banked item 145). The page holds `(part, day)` and redraws when
     either changes.
   - **New Dream** shows MP·11. **The jump buttons** are a `Jump` enum, each showing MP·77's part at its place,
     keyed by its name.
   - `owed.dart` and its test go: no owed handle is left. Row A363 (owed.dart) is dropped.
2. **The matcher** (`app/lib/journal/search.dart`, plain Dart):
   - `searchable(typed)`: the query trimmed, or null under three characters (code points, so one character
     outside the basic plane counts once).
   - `firstMatch(text, query)`: each character folded by itself with Dart's Unicode-aware `toLowerCase`, so a letter
     with a mark stays its own; the first place where the folded query occurs and the character before it is no
     letter, digit or mark; the span in the text's own code units.
   - `findIn(night, query)`: the told dreams in order (a waiting recording has no text), the first match, with its
     entry. `search(nights, query)`: the nights with a match, in the order given.
   - `contextOf(text, span)`: up to three words before the match (`cut`, an ellipsis, before them when words were
     left off), the match, the rest; each run of spaces or breaks one space.
3. **The journal** (`journal_page.dart`):
   - **The field:** first in the list, 20 down, 50 tall (`size.field.search`), as wide as a row (48 from each
     side), a pill in `color.field` with `color.field.border` (none in the dark theme). It has a magnifier drawn in
     code, which a screen reader does not hear, and EM·4 as its placeholder in `color.text.placeholder`. The typed
     words are in the button type, with no autocorrect and no suggestions; the keyboard's key is Search. There is no
     clear button. The space below it keeps the sky mark 140 down, where it was.
   - **From three characters:** where the list starts, the count (MP·76's first part for one night, its second,
     filled, for more; W25 for none) in the button type, centred. Then only the matching nights' rows, newest first,
     under their month dividers, each with its context line under it, 6 below the row. The line is as wide as the
     row, centred, one line cut with an ellipsis, in the button type and `color.text.summary`, with the match in
     Inter Bold. W25 replaces C4-P·5 while searching. Under three characters, the journal is as before.
   - **The query:** held only while the page lives, never kept or logged (R3), so there are no recent searches.
4. **The opened night** (`night_page.dart`, `parts.dart`): `NightPage` takes the query a result was opened from.
   Its first match shows in Inter Bold in its dream's bubble (the dreamer's voice is Inter since C18-P, D118), found
   again on each read, so an edit that removes the word removes the bold. When the page goes, the bold goes. A row
   opened with no search hands no query.

### What it does not build

- The settings gear (D116 item 5), Settings, the consent's controls (with C18-P's three consents), Life Context,
  "Made by AI" (MP·71) and the image controls (MP·78 to MP·82).
- A list of each word's forms (C140-I item 6's plain forms): D117 Q4 chose the start-of-word rule for now.
- Normalising text (NFC), which would need a package (banked item 146).
- Any change to the store, the typing screen, recording, onboarding, the export, the guards, Swift or the server.

### The decisions, by number

- D110 (founder, 2026-11-20; head's message 24): search from three characters, each match with context under its
  row, the count lines and "No matches". Head's message 10: capital letters ignored. Head's message 8: recurring
  images later use search's matcher.
- D116 (owner, the brainstorm), items 1 to 5. D117 (owner, on the stop): Q1 to Q8, each built as leaned in the stop's
  report (`.scratch/for-build-chat/redesign-b-stop.md`); Q1 and Q2 are superseded by C18-P's filing (MP·76, W25).
- D118 (founder): "Inter Display" is built in Inter. D119 (owner, on C18-P's import stop): item 4, the filed lines
  for the handles on screen, as this branch's first task.
- D91, D95, D67 (a row whose code moved follows it).

### Decided under D91 (how to build only)

1. **The greeting's day:** the calendar day counted from 1970, so the four lines turn once a day; a night after
   midnight counts from the evening it began on, so the greeting stays the same through the night part. Banked for
   Product (item 145).
2. **The jump buttons are an enum** (`Jump`), each its MP·77 part by its place; their keys are by name. MP·77's
   "Dreams" is MP·38's word too, so the tests find a jump button by its key.
3. **The magnifier and the field's pill are drawn** (no icon font needed, as the chevrons). The field is a
   `TextField` with a collapsed decoration inside our own pill, so its height is 50 at the usual size and grows at
   large text.
4. **Dart folds one character to one.** The fold map is kept per code unit, so a folding that changed a length
   would still map back to whole characters (banked item 147).
5. **The context line's colour is `color.text.summary`** (the dark theme's text), unused since redesign-a.
6. **The search tests run on a phone-sized view (390 by 844)** where a row must be absent, since the default view
   builds only what is near the screen (a row left out of the build would pass for absent).
7. **`dev_only_test.dart`** now also checks that SoulDreams Dev reaches `search.dart`.

### The places this branch uses

All filed (C18-P): MP·72 to MP·75 (the greeting), MP·11 (New Dream), MP·77 (the jump buttons), EM·4 (the field's
placeholder), MP·76 (the count), W25 (no matches), C4-P·5 (as before), and the rows' and pages' places as before. No
pending line.

### The tests (test-first, on the Mac)

Every task adds its tests before its code. Each task's new and changed tests were run on the code before it and
failed to load. Each assertion is shown to bite by its row (Part 5). App tests: 577 at the start, 603 at the end. App
mutation rows: 36 new (A444 to A479), 1 dropped (A363), and 11 follow the code (D67: A322, A361, A362, A373, A374,
A377, A379, A385, A386, A394, A405), 462 to 497. No guard change. The
by-eye review on the phone is the owner's (Task 6).

## Part 2 · Settings and packages

No new package, no change to settings, Swift, the server, AWS or Soniox, and no storage change. No guard-tool
change. The fonts this branch uses (Bellefair, Inter Bold) came with the import.

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
  count given;
- the task's rows (D95): `python3 -I -B tool/app_mutations.py --rows <the task's rows>`, every one caught;
- the hook: `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `redesign-b`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected: nothing from `git status`; this plan's commit; `guards (tracked): all passed`; `No issues found!`;
`+577: All tests passed!`. Anything else: stop (R14).

### Task 1 · The filed greeting, New Dream and jump buttons (D119 item 4)

`greeting.dart`: `daypartAt` (05, 11, 17, 21), `greetingPlace`, `greetingAt`, `greetingText`. `journal_page.dart`:
the greeting by `(part, day)`, New Dream MP·11. `night_page.dart`: `Jump`, the jump buttons MP·77. `owed.dart` and
`owed_test.dart` deleted. Tests: `greeting_test.dart` (5; was 2); in `journal_page_test.dart` one new (the next day,
the next line) and the greeting's and New Dream's words from the register; in `night_page_test.dart` one new
(MP·77's words) and the jumps found by key. Rows A444 to A450 new; A361, A362, A373, A374, A385, A386, A394 and
A405 follow the code; A363 dropped.

Expected: 580 app tests; rows `A361,A362,A373,A374,A385,A386,A394,A405,A444,A445,A446,A447,A448,A449,A450`, every
one caught. Commit:

> Journal and night page: the filed greeting, New Dream and jump buttons (C18-P; D119 item 4)

**The block:**

~~~~diff
diff --git a/app/lib/journal/greeting.dart b/app/lib/journal/greeting.dart
index 227790a..004b7e3 100644
--- a/app/lib/journal/greeting.dart
+++ b/app/lib/journal/greeting.dart
@@ -1,23 +1,43 @@
-// The journal's greeting by time of day (D110, head's message 24), in plain
-// Dart: the part of the day by the phone's wall clock, and its greeting. The
-// four parts and their hours are the plan's stand-ins until Product files
-// the greetings; night begins at 21:00, as the dark theme does.
-import 'owed.dart';
+// The journal's greeting by time of day (D110; C18-P, MP·72 to MP·75), in
+// plain Dart: the part of the day by the phone's wall clock, from 05:00,
+// 11:00, 17:00 and 21:00 (start-inclusive), and one line of that part's four
+// a day, the four in turn. A night after midnight keeps the line of the
+// evening it began on, so the greeting never changes inside a part (D119
+// item 4; the day counted under D91).
+import '../words/lines.g.dart';
+import 'night_rules.dart';
 
-enum Daypart { morning, afternoon, evening, night }
+enum Daypart { morning, day, evening, night }
 
 /// The part of the day at the wall clock's [hour].
 Daypart daypartAt(int hour) => switch (hour) {
-  >= 5 && < 12 => Daypart.morning,
-  >= 12 && < 17 => Daypart.afternoon,
+  >= 5 && < 11 => Daypart.morning,
+  >= 11 && < 17 => Daypart.day,
   >= 17 && < 21 => Daypart.evening,
   _ => Daypart.night,
 };
 
-/// The greeting for [part]: owed by Product, shown as its handle (R1).
-Owed greetingFor(Daypart part) => switch (part) {
-  Daypart.morning => OwedLines.greetingMorning,
-  Daypart.afternoon => OwedLines.greetingAfternoon,
-  Daypart.evening => OwedLines.greetingEvening,
-  Daypart.night => OwedLines.greetingNight,
+/// The register's place for [part]'s greeting.
+Line greetingPlace(Daypart part) => switch (part) {
+  Daypart.morning => Lines.MP_72,
+  Daypart.day => Lines.MP_73,
+  Daypart.evening => Lines.MP_74,
+  Daypart.night => Lines.MP_75,
 };
+
+/// Which greeting stands at the wall clock's [wall]: its part, and the day
+/// that part began on (days since 1970-01-01 by the calendar).
+typedef Greeting = ({Daypart part, int day});
+
+Greeting greetingAt(Wall wall) {
+  final part = daypartAt(wall.hour);
+  final back = wall.hour < 5 ? 1 : 0;
+  final began = DateTime.utc(wall.year, wall.month, wall.day - back);
+  return (part: part, day: began.difference(DateTime.utc(1970)).inDays);
+}
+
+/// The words of [g]: one of its place's four lines, the four in turn by day.
+String greetingText(Greeting g, Lang lang) {
+  final lines = greetingPlace(g.part).parts(lang);
+  return lines[g.day % lines.length];
+}
diff --git a/app/lib/journal/owed.dart b/app/lib/journal/owed.dart
deleted file mode 100644
index 369e8d0..0000000
--- a/app/lib/journal/owed.dart
+++ /dev/null
@@ -1,44 +0,0 @@
-// The places Product still owes (D110, head's message 24): no line and no
-// handle in the register yet. Each shows a provisional handle in square
-// brackets, as a place with no line shows its own (R1), until Product files
-// it; then the page takes the register's line and its entry here goes. Each
-// is listed in docs/plans/redesign-a.md.
-
-/// A place Product owes, by its provisional handle.
-final class Owed {
-  const Owed(this.handle);
-
-  final String handle;
-
-  /// The visible placeholder (R1).
-  String get text => '[$handle]';
-}
-
-abstract final class OwedLines {
-  /// The journal's greeting, by the part of the day.
-  static const greetingMorning = Owed('owed·greeting-morning');
-  static const greetingAfternoon = Owed('owed·greeting-afternoon');
-  static const greetingEvening = Owed('owed·greeting-evening');
-  static const greetingNight = Owed('owed·greeting-night');
-
-  /// The journal's button that opens the typing screen.
-  static const newDream = Owed('owed·new-dream');
-
-  /// A read night's jump buttons.
-  static const jumpDreams = Owed('owed·jump-dreams');
-  static const jumpQuestions = Owed('owed·jump-questions');
-  static const jumpReadings = Owed('owed·jump-readings');
-  static const jumpReflection = Owed('owed·jump-reflection');
-
-  static const all = <Owed>[
-    greetingMorning,
-    greetingAfternoon,
-    greetingEvening,
-    greetingNight,
-    newDream,
-    jumpDreams,
-    jumpQuestions,
-    jumpReadings,
-    jumpReflection,
-  ];
-}
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 42507cf..ca9b5f5 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -1,6 +1,7 @@
 // The journal list, the app's home (main-path.md, The Journal; C131-I
 // items 1, 2; S5; D110, head's message 24; D112): a sun or a moon above a
-// greeting by the part of the day; New Dream, opening the typing screen (the round record button is
+// greeting by the part of the day (MP·72 to MP·75, one line a day; D119);
+// New Dream (MP·11), opening the typing screen (the round record button is
 // gone); one rounded row per night, newest first, carrying only its date
 // over the night's picture (an unread night's the painted gradient), never
 // a time; a month divider over each month with nights; C4-P·5 when there is
@@ -27,7 +28,6 @@ import '../night.dart';
 import '../night_action.dart';
 import '../night_look.dart';
 import '../night_rules.dart';
-import '../owed.dart';
 import '../row_text.dart';
 import '../sky.dart';
 import 'night_art.dart';
@@ -73,11 +73,11 @@ class JournalPage extends StatefulWidget {
 class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   List<Night>? _nights;
   late bool _first = widget.firstTime;
-  late Daypart _daypart = _daypartNow();
+  late Greeting _greeting = _greetingNow();
   late Sky _sky = _skyNow();
   late final Timer _clock;
 
-  Daypart _daypartNow() => daypartAt(widget.journal.zone.wall(widget.journal.now()).hour);
+  Greeting _greetingNow() => greetingAt(widget.journal.zone.wall(widget.journal.now()));
   Sky _skyNow() => skyAt(widget.journal.zone.wall(widget.journal.now()).hour);
 
   @override
@@ -88,11 +88,11 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     widget.recording?.retries?.addListener(_load);
     // The greeting and the sky mark follow the clock while the page is open.
     _clock = Timer.periodic(const Duration(minutes: 1), (_) {
-      final now = _daypartNow();
+      final now = _greetingNow();
       final sky = _skyNow();
-      if (now != _daypart || sky != _sky) {
+      if (now != _greeting || sky != _sky) {
         setState(() {
-          _daypart = now;
+          _greeting = now;
           _sky = sky;
         });
       }
@@ -125,7 +125,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     if (!mounted) return;
     setState(() {
       _nights = nights;
-      _daypart = _daypartNow();
+      _greeting = _greetingNow();
       _sky = _skyNow();
       // Shown once: a night there ends it, even one deleted later.
       if (nights.isNotEmpty) _first = false;
@@ -177,7 +177,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
             Semantics(
               header: true,
               child: Text(
-                greetingFor(_daypart).text,
+                greetingText(_greeting, appLanguage),
                 textAlign: TextAlign.center,
                 style: TypeRoles.h2.style(p.text),
               ),
@@ -239,7 +239,7 @@ class _NewDream extends StatelessWidget {
         child: NightSky(
           child: Padding(
             padding: StandIns.buttonPadding,
-            child: Text(OwedLines.newDream.text, style: TypeRoles.button.style(NightArt.over)),
+            child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),
           ),
         ),
       ),
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index b29b8ef..a19f305 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -21,8 +21,8 @@
 // tapped; while it is being turned into text, AI·6 shows in its place,
 // heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
 // When its words come, the page shows them. On a read night, under the
-// header, four jump buttons (Dreams, Questions, Readings, Reflection; their
-// words owed, shown as handles); Dreams brings "Dreams" into view, the
+// header, four jump buttons (MP·77: Dreams, Questions, Readings,
+// Reflection; D119 item 4); Dreams brings "Dreams" into view, the
 // other three do nothing until their sections come with the readings. No
 // night is read yet. Not built: reading, and the space below the dreams
 // with its field.
@@ -44,12 +44,22 @@ import '../night.dart';
 import '../night_action.dart';
 import '../night_look.dart';
 import '../night_rules.dart';
-import '../owed.dart';
 import '../row_text.dart';
 import 'night_art.dart';
 import 'parts.dart';
 import 'typing_page.dart';
 
+/// A read night's jump buttons, in MP·77's order (C18-P; D119 item 4).
+enum Jump {
+  dreams,
+  questions,
+  readings,
+  reflection;
+
+  /// Its words: MP·77's part at this button's place.
+  String text(Lang lang) => Lines.MP_77.parts(lang)[index];
+}
+
 class NightPage extends StatefulWidget {
   const NightPage({super.key, required this.journal, required this.id, this.recording, this.action, this.read = noneRead});
 
@@ -62,7 +72,7 @@ class NightPage extends StatefulWidget {
   static const dreamsKey = Key('night-dreams');
 
   /// A read night's jump button.
-  static Key jumpKey(Owed label) => ValueKey('jump-${label.handle}');
+  static Key jumpKey(Jump jump) => ValueKey('jump-${jump.name}');
 
   final Journal journal;
   final String id;
@@ -261,7 +271,7 @@ class _NightPageState extends State<NightPage> {
 
   // A read night's four jump buttons, centred, wrapping at large text.
   Widget _jumps(Palette p) {
-    Widget jump(Owed label, List<Color> colours, GlobalKey? section) => Semantics(
+    Widget jump(Jump label, List<Color> colours, GlobalKey? section) => Semantics(
       button: true,
       child: GestureDetector(
         key: NightPage.jumpKey(label),
@@ -273,7 +283,7 @@ class _NightPageState extends State<NightPage> {
           ),
           child: Padding(
             padding: StandIns.labelPadding,
-            child: Text(label.text, style: TypeRoles.button.style(p.sectionText)),
+            child: Text(label.text(appLanguage), style: TypeRoles.button.style(p.sectionText)),
           ),
         ),
       ),
@@ -287,10 +297,10 @@ class _NightPageState extends State<NightPage> {
         spacing: StandIns.jumpGap,
         runSpacing: StandIns.jumpGap,
         children: [
-          jump(OwedLines.jumpDreams, [p.sectionTop, p.sectionBottom], _dreamsLabel),
-          jump(OwedLines.jumpQuestions, StandIns.jumpQuestions, null),
-          jump(OwedLines.jumpReadings, [tradition.colour!, tradition.colourEnd!], null),
-          jump(OwedLines.jumpReflection, [tag.colour!, tag.colourEnd!], null),
+          jump(Jump.dreams, [p.sectionTop, p.sectionBottom], _dreamsLabel),
+          jump(Jump.questions, StandIns.jumpQuestions, null),
+          jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], null),
+          jump(Jump.reflection, [tag.colour!, tag.colourEnd!], null),
         ],
       ),
     );
diff --git a/app/test/journal/greeting_test.dart b/app/test/journal/greeting_test.dart
index 70dcb6c..aa26b5e 100644
--- a/app/test/journal/greeting_test.dart
+++ b/app/test/journal/greeting_test.dart
@@ -1,25 +1,65 @@
-// The journal's greeting by time of day (D110): four parts of the day by the
-// phone's wall clock, each with its owed greeting.
+// The journal's greeting by time of day (D110; C18-P, MP·72 to MP·75): four
+// parts of the day by the phone's wall clock, each with its filed place, and
+// one line of its four a day, the four in turn (D119 item 4).
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/journal/greeting.dart';
-import 'package:souldreams/journal/owed.dart';
+import 'package:souldreams/journal/night_rules.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+Wall at(int year, int month, int day, int hour) => (year: year, month: month, day: day, hour: hour);
 
 void main() {
-  test('the parts of the day: from 05, 12, 17, 21', () {
+  test('the parts of the day: from 05, 11, 17, 21', () {
     final parts = [for (var h = 0; h < 24; h++) daypartAt(h)];
     expect(parts, [
       for (var h = 0; h < 5; h++) Daypart.night,
-      for (var h = 5; h < 12; h++) Daypart.morning,
-      for (var h = 12; h < 17; h++) Daypart.afternoon,
+      for (var h = 5; h < 11; h++) Daypart.morning,
+      for (var h = 11; h < 17; h++) Daypart.day,
       for (var h = 17; h < 21; h++) Daypart.evening,
       for (var h = 21; h < 24; h++) Daypart.night,
     ]);
   });
 
-  test('each part of the day has its own greeting', () {
-    expect(greetingFor(Daypart.morning), OwedLines.greetingMorning);
-    expect(greetingFor(Daypart.afternoon), OwedLines.greetingAfternoon);
-    expect(greetingFor(Daypart.evening), OwedLines.greetingEvening);
-    expect(greetingFor(Daypart.night), OwedLines.greetingNight);
+  test('each part has its filed place, four lines each', () {
+    expect(greetingPlace(Daypart.morning), Lines.MP_72);
+    expect(greetingPlace(Daypart.day), Lines.MP_73);
+    expect(greetingPlace(Daypart.evening), Lines.MP_74);
+    expect(greetingPlace(Daypart.night), Lines.MP_75);
+    for (final part in Daypart.values) {
+      for (final lang in Lang.values) {
+        expect(greetingPlace(part).parts(lang), hasLength(4), reason: '$part $lang');
+      }
+    }
+  });
+
+  test('one line a day, the four in turn', () {
+    for (final lang in Lang.values) {
+      final seen = [
+        for (var d = 0; d < 8; d++) greetingText(greetingAt(at(2026, 6, 10 + d, 12)), lang),
+      ];
+      final lines = Lines.MP_73.parts(lang);
+      final first = lines.indexOf(seen.first);
+      expect(first, isNot(-1));
+      expect(seen, [for (var d = 0; d < 8; d++) lines[(first + d) % 4]]);
+    }
+  });
+
+  test('one line all day; the day turns at a month end', () {
+    final morning = greetingAt(at(2026, 6, 10, 5));
+    expect(greetingAt(at(2026, 6, 10, 10)), morning);
+    final june30 = greetingAt(at(2026, 6, 30, 12)).day;
+    expect(greetingAt(at(2026, 7, 1, 12)).day, june30 + 1);
+    final dec31 = greetingAt(at(2026, 12, 31, 12)).day;
+    expect(greetingAt(at(2027, 1, 1, 12)).day, dec31 + 1);
+  });
+
+  test('after midnight, the line of the evening it began on', () {
+    final late = greetingAt(at(2026, 6, 10, 23));
+    expect(greetingAt(at(2026, 6, 11, 0)), late);
+    expect(greetingAt(at(2026, 6, 11, 4)), late);
+    expect(greetingAt(at(2026, 6, 11, 5)).day, late.day + 1);
+    expect(greetingAt(at(2026, 6, 11, 5)).part, Daypart.morning);
+    // On the first of a month, after midnight: the last day of the one before.
+    expect(greetingAt(at(2026, 7, 1, 2)), greetingAt(at(2026, 6, 30, 22)));
   });
 }
diff --git a/app/test/journal/owed_test.dart b/app/test/journal/owed_test.dart
deleted file mode 100644
index 9e4d1d5..0000000
--- a/app/test/journal/owed_test.dart
+++ /dev/null
@@ -1,21 +0,0 @@
-// The places Product still owes (D110): each shows its provisional handle in
-// square brackets (R1), no two alike, none a register handle.
-import 'package:flutter_test/flutter_test.dart';
-import 'package:souldreams/journal/owed.dart';
-import 'package:souldreams/words/lines.g.dart';
-
-void main() {
-  test('an owed place shows its handle in square brackets', () {
-    for (final o in OwedLines.all) {
-      expect(o.text, '[${o.handle}]');
-    }
-  });
-
-  test('nine owed places, each handle once, none in the register', () {
-    final handles = [for (final o in OwedLines.all) o.handle];
-    expect(handles, hasLength(9));
-    expect(handles.toSet(), hasLength(9));
-    final filed = {for (final l in Lines.all) l.handle};
-    expect(handles.where(filed.contains), isEmpty);
-  });
-}
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index 8349a87..d150843 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -17,7 +17,6 @@ import 'package:souldreams/journal/greeting.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_action.dart';
 import 'package:souldreams/journal/night_look.dart';
-import 'package:souldreams/journal/owed.dart';
 import 'package:souldreams/journal/pages/night_art.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
@@ -63,15 +62,19 @@ final class BrokenFiles extends MemoryJournalFiles {
   }
 }
 
+/// The greeting's words at Stockholm's wall [hour] on [day] June 2026.
+String greeted(int hour, {int day = 10}) =>
+    greetingText(greetingAt((year: 2026, month: 6, day: day, hour: hour)), Lang.en);
+
 void main() {
   testWidgets('the empty journal: the greeting, New Dream and C4-P·5', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal));
-    expect(find.text(OwedLines.greetingAfternoon.text), findsOneWidget);
-    expect(find.text(OwedLines.newDream.text), findsOneWidget);
+    expect(find.text(greeted(12)), findsOneWidget);
+    // MP·11 is New Dream's (C18-P), shown once: the round record button is
+    // gone (D110).
+    expect(find.text(Lines.MP_11.text(Lang.en)), findsOneWidget);
     expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
-    // The round record button is gone (D110).
-    expect(find.text(Lines.MP_11.text(Lang.en)), findsNothing);
     // No Settings entry and no search: later branches.
     expect(find.text(Lines.MP_25.text(Lang.en)), findsNothing);
     expect(find.byType(TextField), findsNothing);
@@ -82,7 +85,7 @@ void main() {
   testWidgets('the greeting: by the clock, centred, a heading, above New Dream', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal));
-    final greeting = find.text(OwedLines.greetingAfternoon.text);
+    final greeting = find.text(greeted(12));
     final text = tester.widget<Text>(greeting);
     expect(text.style!.fontFamily, TypeRoles.h2.family);
     expect(text.style!.fontSize, TypeRoles.h2.size);
@@ -90,12 +93,24 @@ void main() {
     expect(tester.getCenter(greeting).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
     expect(tester.getRect(greeting).bottom, lessThan(tester.getRect(find.byKey(JournalPage.newDreamKey)).top));
     final handle = tester.ensureSemantics();
-    expect(tester.getSemantics(greeting), matchesSemantics(label: OwedLines.greetingAfternoon.text, isHeader: true));
+    expect(tester.getSemantics(greeting), matchesSemantics(label: greeted(12), isHeader: true));
     handle.dispose();
     Harness.clock = stockholm(2026, 6, 10, 17);
     await tester.pump(const Duration(minutes: 1));
-    expect(find.text(OwedLines.greetingEvening.text), findsOneWidget);
-    expect(greetingFor(Daypart.evening), OwedLines.greetingEvening);
+    expect(find.text(greeted(17)), findsOneWidget);
+  });
+
+  // D119 item 4: one line a day, the four in turn; the next day at the same
+  // hour, the next line of the same place.
+  testWidgets('the greeting: the next day, the next line', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    expect(find.text(greeted(12)), findsOneWidget);
+    Harness.clock = stockholm(2026, 6, 11, 12);
+    await tester.pump(const Duration(minutes: 1));
+    expect(greeted(12, day: 11), isNot(greeted(12)));
+    expect(find.text(greeted(12, day: 11)), findsOneWidget);
+    expect(Lines.MP_73.parts(Lang.en), contains(greeted(12, day: 11)));
   });
 
   // D110: on returning, the greeting follows the clock at once, without
@@ -103,14 +118,14 @@ void main() {
   testWidgets('the greeting follows the clock on returning', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal));
-    expect(find.text(OwedLines.greetingAfternoon.text), findsOneWidget);
+    expect(find.text(greeted(12)), findsOneWidget);
     Harness.clock = stockholm(2026, 6, 10, 17);
     tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
     tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
     await tester.pump();
     await tester.pump(const Duration(seconds: 1));
-    expect(find.text(OwedLines.greetingEvening.text), findsOneWidget);
-    expect(find.text(OwedLines.greetingAfternoon.text), findsNothing);
+    expect(find.text(greeted(17)), findsOneWidget);
+    expect(find.text(greeted(12)), findsNothing);
   });
 
   // D112: above the greeting, a sun from 08:00 to 21:00 and a moon from 21:00
@@ -123,7 +138,7 @@ void main() {
     expect(tester.widget<SkyMark>(mark).sky, Sky.sun);
     expect(tester.getSize(mark), StandIns.skyMark);
     expect(tester.getCenter(mark).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
-    final greeting = tester.getRect(find.text(OwedLines.greetingAfternoon.text));
+    final greeting = tester.getRect(find.text(greeted(12)));
     expect(greeting.top - tester.getRect(mark).bottom, closeTo(StandIns.skyGap, 1));
   });
 
@@ -135,7 +150,7 @@ void main() {
     expect(tester.widget<SkyMark>(find.byType(SkyMark)).sky, Sky.moon);
     Harness.clock = stockholm(2026, 6, 10, 8);
     await tester.pump(const Duration(minutes: 1));
-    expect(find.text(OwedLines.greetingMorning.text), findsOneWidget);
+    expect(find.text(greeted(8)), findsOneWidget);
     expect(tester.widget<SkyMark>(find.byType(SkyMark)).sky, Sky.sun);
     Harness.clock = stockholm(2026, 6, 10, 21);
     await tester.pump(const Duration(minutes: 1));
@@ -161,11 +176,11 @@ void main() {
     expect(tester.getCenter(button).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
     expect(find.descendant(of: button, matching: find.byType(NightSky)), findsOneWidget);
     expect(find.descendant(of: button, matching: find.byType(NightArt)), findsNothing);
-    final words = tester.widget<Text>(find.text(OwedLines.newDream.text));
+    final words = tester.widget<Text>(find.text(Lines.MP_11.text(Lang.en)));
     expect(words.style!.color, NightArt.over);
     expect(words.style!.fontFamily, TypeRoles.button.family);
     final handle = tester.ensureSemantics();
-    expect(tester.getSemantics(button), matchesSemantics(label: OwedLines.newDream.text, isButton: true, hasTapAction: true));
+    expect(tester.getSemantics(button), matchesSemantics(label: Lines.MP_11.text(Lang.en), isButton: true, hasTapAction: true));
     handle.dispose();
   });
 
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index 3ea68f2..4af4c4c 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -20,7 +20,6 @@ import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_action.dart';
 import 'package:souldreams/journal/night_look.dart';
-import 'package:souldreams/journal/owed.dart';
 import 'package:souldreams/journal/pages/night_art.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
@@ -500,8 +499,22 @@ void main() {
 
   testWidgets('an unread night has no jump buttons', (tester) async {
     await open(tester);
-    for (final o in [OwedLines.jumpDreams, OwedLines.jumpQuestions, OwedLines.jumpReadings, OwedLines.jumpReflection]) {
-      expect(find.text(o.text), findsNothing);
+    // By key: MP·77's "Dreams" is MP·38's word too, which stands.
+    for (final o in Jump.values) {
+      expect(find.byKey(NightPage.jumpKey(o)), findsNothing);
+    }
+    expect(find.text(Lines.MP_77.parts(Lang.en)[1]), findsNothing);
+  });
+
+  // C18-P (D119 item 4): the jump buttons' words are MP·77's four parts, in
+  // order, each on its own button.
+  testWidgets("the jump buttons' words: MP·77, in order", (tester) async {
+    await open(tester, read: (_) => true);
+    expect([for (final o in Jump.values) o.text(Lang.en)], Lines.MP_77.parts(Lang.en));
+    expect([for (final o in Jump.values) o.text(Lang.sv)], Lines.MP_77.parts(Lang.sv));
+    for (final o in Jump.values) {
+      final words = find.descendant(of: find.byKey(NightPage.jumpKey(o)), matching: find.byType(Text));
+      expect(tester.widget<Text>(words).data, Lines.MP_77.parts(Lang.en)[o.index]);
     }
   });
 
@@ -513,13 +526,13 @@ void main() {
     final art = tester.widget<NightArt>(find.byType(NightArt));
     expect(art.look, Painting(paintingFor(n.id, NightArt.paintings)));
     final header = tester.getRect(find.byType(NightArt));
-    final jumps = [OwedLines.jumpDreams, OwedLines.jumpQuestions, OwedLines.jumpReadings, OwedLines.jumpReflection];
+    final jumps = Jump.values;
     final boxes = [for (final o in jumps) tester.getRect(find.byKey(NightPage.jumpKey(o)))];
     for (final (i, b) in boxes.indexed) {
       expect(b.top, greaterThan(header.bottom));
-      expect(b.bottom, lessThan(tester.getTopLeft(find.text(Lines.MP_38.text(Lang.en))).dy));
+      expect(b.bottom, lessThan(tester.getTopLeft(find.byKey(NightPage.dreamsKey)).dy));
       expect(tester.getSemantics(find.byKey(NightPage.jumpKey(jumps[i]))), matchesSemantics(
-        label: jumps[i].text, isButton: true, hasTapAction: true));
+        label: jumps[i].text(Lang.en), isButton: true, hasTapAction: true));
       if (i > 0) expect(b.left > boxes[i - 1].right || b.top > boxes[i - 1].bottom, isTrue);
     }
     // Each row of them centred.
@@ -535,17 +548,17 @@ void main() {
   // brown, the tradition label's terracotta and the dream tag's blue.
   testWidgets('the jump buttons: green, brown, terracotta, blue', (tester) async {
     await open(tester, read: (_) => true);
-    List<Color> colours(Owed o) {
+    List<Color> colours(Jump o) {
       final box = tester.widget<DecoratedBox>(
         find.descendant(of: find.byKey(NightPage.jumpKey(o)), matching: find.byType(DecoratedBox)),
       );
       return ((box.decoration as BoxDecoration).gradient! as LinearGradient).colors;
     }
 
-    expect(colours(OwedLines.jumpDreams), [LightColours.labelSection.colour, LightColours.labelSection.colourEnd]);
-    expect(colours(OwedLines.jumpQuestions), StandIns.jumpQuestions);
-    expect(colours(OwedLines.jumpReadings), [LightColours.labelTradition.colour, LightColours.labelTradition.colourEnd]);
-    expect(colours(OwedLines.jumpReflection), [LightColours.tagDream.colour, LightColours.tagDream.colourEnd]);
+    expect(colours(Jump.dreams), [LightColours.labelSection.colour, LightColours.labelSection.colourEnd]);
+    expect(colours(Jump.questions), StandIns.jumpQuestions);
+    expect(colours(Jump.readings), [LightColours.labelTradition.colour, LightColours.labelTradition.colourEnd]);
+    expect(colours(Jump.reflection), [LightColours.tagDream.colour, LightColours.tagDream.colourEnd]);
   });
 
   // The jump buttons stand at the top of the scrolling part, so they scroll
@@ -553,9 +566,9 @@ void main() {
   testWidgets('the Dreams jump brings "Dreams" to the top', (tester) async {
     await open(tester, read: (_) => true, key: 'long-dream-en');
     final list = tester.getRect(find.byType(ListView));
-    final jump = find.byKey(NightPage.jumpKey(OwedLines.jumpDreams));
+    final jump = find.byKey(NightPage.jumpKey(Jump.dreams));
     expect(find.descendant(of: find.byType(ListView), matching: jump), findsOneWidget);
-    final label = find.text(Lines.MP_38.text(Lang.en));
+    final label = find.descendant(of: find.byKey(NightPage.dreamsKey), matching: find.text(Lines.MP_38.text(Lang.en)));
     expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, greaterThan(list.top + 10));
     await tester.tap(jump);
     await tester.pump();
@@ -579,7 +592,7 @@ void main() {
   testWidgets('the three other jumps do nothing yet', (tester) async {
     await open(tester, read: (_) => true, key: 'long-dream-en');
     final at = tester.getRect(find.byKey(NightPage.dreamsKey));
-    for (final o in [OwedLines.jumpQuestions, OwedLines.jumpReadings, OwedLines.jumpReflection]) {
+    for (final o in [Jump.questions, Jump.readings, Jump.reflection]) {
       await tester.tap(find.byKey(NightPage.jumpKey(o)));
       await tester.pumpAndSettle();
       expect(tester.getRect(find.byKey(NightPage.dreamsKey)), at);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 69e7f80..b449bb9 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A443, A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A450, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 462 run, 462 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 468 run, 468 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -1691,15 +1691,11 @@ ROWS = [
     ('A361', 'lib/journal/greeting.dart',
      '>= 17 && < 21 => Daypart.evening',
      '>= 17 && < 22 => Daypart.evening',
-     'test/journal/greeting_test.dart', 'the parts of the day: from 05, 12, 17, 21'),
+     'test/journal/greeting_test.dart', 'the parts of the day: from 05, 11, 17, 21'),
     ('A362', 'lib/journal/greeting.dart',
-     'Daypart.night => OwedLines.greetingNight,',
-     'Daypart.night => OwedLines.greetingEvening,',
-     'test/journal/greeting_test.dart', 'each part of the day has its own greeting'),
-    ('A363', 'lib/journal/owed.dart',
-     "String get text => '[$handle]';",
-     'String get text => handle;',
-     'test/journal/owed_test.dart', 'an owed place shows its handle in square brackets'),
+     'Daypart.night => Lines.MP_75,',
+     'Daypart.night => Lines.MP_74,',
+     'test/journal/greeting_test.dart', 'each part has its filed place, four lines each'),
     ('A364', 'lib/journal/night_look.dart',
      'read && paintings > 0 ?',
      'paintings > 0 ?',
@@ -1739,11 +1735,11 @@ ROWS = [
      'test/journal/pages/night_art_test.dart', 'a few placeholder paintings stand in the set'),
     # D110: the journal's greeting, New Dream and rows.
     ('A373', 'lib/journal/pages/journal_page.dart',
-     '              header: true,\n              child: Text(\n                greetingFor(_daypart).text,',
-     '              header: false,\n              child: Text(\n                greetingFor(_daypart).text,',
+     '              header: true,\n              child: Text(\n                greetingText(_greeting, appLanguage),',
+     '              header: false,\n              child: Text(\n                greetingText(_greeting, appLanguage),',
      'test/journal/pages/journal_page_test.dart', 'the greeting: by the clock, centred, a heading, above New Dream'),
     ('A374', 'lib/journal/pages/journal_page.dart',
-     '          _daypart = now;\n          _sky = sky;\n',
+     '          _greeting = now;\n          _sky = sky;\n',
      '          _sky = sky;\n',
      'test/journal/pages/journal_page_test.dart', 'the greeting: by the clock, centred, a heading, above New Dream'),
     ('A376', 'lib/journal/pages/journal_page.dart',
@@ -1784,12 +1780,12 @@ ROWS = [
      '',
      'test/journal/pages/night_page_test.dart', 'the Dreams jump brings "Dreams" to the top'),
     ('A385', 'lib/journal/pages/night_page.dart',
-     'jump(OwedLines.jumpReadings, [tradition.colour!, tradition.colourEnd!], null),',
-     'jump(OwedLines.jumpReadings, [tradition.colour!, tradition.colourEnd!], _dreamsLabel),',
+     'jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], null),',
+     'jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], _dreamsLabel),',
      'test/journal/pages/night_page_test.dart', 'the three other jumps do nothing yet'),
     ('A386', 'lib/journal/pages/night_page.dart',
-     'jump(OwedLines.jumpReflection, [tag.colour!, tag.colourEnd!], null),',
-     'jump(OwedLines.jumpReflection, [tag.colourEnd!, tag.colour!], null),',
+     'jump(Jump.reflection, [tag.colour!, tag.colourEnd!], null),',
+     'jump(Jump.reflection, [tag.colourEnd!, tag.colour!], null),',
      'test/journal/pages/night_page_test.dart', 'the jump buttons: green, brown, terracotta, blue'),
     ('A387', 'lib/journal/pages/night_page.dart',
      'style: TypeRoles.h2.style(NightArt.over),',
@@ -1822,7 +1818,7 @@ ROWS = [
      'test/journal/pages/journal_home_test.dart', 'by default no night is read'),
     # redesign-a's final review (D91): the greeting on returning, the status bar's room, the jump's time.
     ('A394', 'lib/journal/pages/journal_page.dart',
-     '      _nights = nights;\n      _daypart = _daypartNow();\n',
+     '      _nights = nights;\n      _greeting = _greetingNow();\n',
      '      _nights = nights;\n',
      'test/journal/pages/journal_page_test.dart', 'the greeting follows the clock on returning'),
     ('A395', 'lib/journal/pages/night_page.dart',
@@ -1867,8 +1863,8 @@ ROWS = [
      '      // Shown once',
      'test/journal/pages/journal_page_test.dart', 'the mark follows the clock on returning'),
     ('A405', 'lib/journal/pages/journal_page.dart',
-     'if (now != _daypart || sky != _sky) {',
-     'if (now != _daypart) {',
+     'if (now != _greeting || sky != _sky) {',
+     'if (now != _greeting) {',
      'test/journal/pages/journal_page_test.dart', 'the moon at night, and the mark follows the clock'),
     ('A406', 'lib/journal/pages/journal_page.dart',
      'Center(child: SkyMark(_sky)),',
@@ -2028,6 +2024,36 @@ ROWS = [
      'PlainButton(Lines.MP_67.parts(appLanguage).first, onPressed: widget.onAgreed)',
      'PlainButton(Lines.MP_67.parts(appLanguage).last, onPressed: widget.onAgreed)',
      'test/onboarding/onboarding_test.dart', '18 or over: the disclosure first page, then the consent'),
+    # redesign-b, Task 1 (D119 item 4): the greeting, New Dream and the jump
+    # buttons take their filed lines.
+    ('A444', 'lib/journal/greeting.dart',
+     '  >= 5 && < 11 => Daypart.morning,',
+     '  >= 5 && < 12 => Daypart.morning,',
+     'test/journal/greeting_test.dart', 'the parts of the day: from 05, 11, 17, 21'),
+    ('A445', 'lib/journal/greeting.dart',
+     '  return lines[g.day % lines.length];',
+     '  return lines[0];',
+     'test/journal/greeting_test.dart', 'one line a day, the four in turn'),
+    ('A446', 'lib/journal/greeting.dart',
+     '  final back = wall.hour < 5 ? 1 : 0;',
+     '  final back = 0;',
+     'test/journal/greeting_test.dart', 'after midnight, the line of the evening it began on'),
+    ('A447', 'lib/journal/pages/journal_page.dart',
+     '                greetingText(_greeting, appLanguage),',
+     '                greetingText((part: _greeting.part, day: 0), appLanguage),',
+     'test/journal/pages/journal_page_test.dart', 'the greeting: the next day, the next line'),
+    ('A448', 'lib/journal/pages/journal_page.dart',
+     'child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),',
+     'child: Text(Lines.MP_9.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),',
+     'test/journal/pages/journal_page_test.dart', 'the empty journal: the greeting, New Dream and C4-P·5'),
+    ('A449', 'lib/journal/pages/night_page.dart',
+     '  String text(Lang lang) => Lines.MP_77.parts(lang)[index];',
+     '  String text(Lang lang) => Lines.MP_77.parts(lang)[0];',
+     'test/journal/pages/night_page_test.dart', "the jump buttons' words: MP·77, in order"),
+    ('A450', 'lib/journal/pages/night_page.dart',
+     "  static Key jumpKey(Jump jump) => ValueKey('jump-${jump.name}');",
+     "  static Key jumpKey(Jump jump) => const ValueKey('jump');",
+     'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
 ]
 
 
~~~~

### Task 2 · The matcher (plain Dart)

`lib/journal/search.dart`: `searchable`, `firstMatch`, `findIn`, `search`, `contextOf`, `cut`, `searchFrom`,
`contextWordsBefore`. Tests: `test/journal/search_test.dart` (9). Rows A451 to A461.

Expected: 589 app tests; rows `A451,A452,A453,A454,A455,A456,A457,A458,A459,A460,A461`, every one caught. Commit:

> Journal: search's matcher, one function, and its context line (D116, D117 Q4, Q5, Q8)

**The block:**

~~~~diff
diff --git a/app/lib/journal/search.dart b/app/lib/journal/search.dart
new file mode 100644
index 0000000..f28cad9
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
index 0000000..ffaf194
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
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index b449bb9..807bd9e 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A450, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A461, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 468 run, 468 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 479 run, 479 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -2054,6 +2054,51 @@ ROWS = [
      "  static Key jumpKey(Jump jump) => ValueKey('jump-${jump.name}');",
      "  static Key jumpKey(Jump jump) => const ValueKey('jump');",
      'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
+    # redesign-b (D116, D117): search's matcher and context line.
+    ('A451', 'lib/journal/search.dart',
+     '      final f = String.fromCharCode(r).toLowerCase();',
+     '      final f = String.fromCharCode(r);',
+     'test/journal/search_test.dart', 'capitals fold; å, ä and ö stay apart'),
+    ('A452', 'lib/journal/search.dart',
+     '    if (_wordStart(text, t.from[at])) {',
+     '    if (true) {',
+     'test/journal/search_test.dart', 'the typed characters match only at the start of a word'),
+    ('A453', 'lib/journal/search.dart',
+     '0xDFFF) j--;',
+     '0xDFFF) {}',
+     'test/journal/search_test.dart', 'the span is on the text\'s own characters'),
+    ('A454', 'lib/journal/search.dart',
+     '      final width = r > 0xFFFF ? 2 : 1;',
+     '      const width = 1;',
+     'test/journal/search_test.dart', 'the span is on the text\'s own characters'),
+    ('A455', 'lib/journal/search.dart',
+     '  return q.runes.length >= searchFrom ? q : null;',
+     '  return q.length >= searchFrom ? q : null;',
+     'test/journal/search_test.dart', 'a search starts from three characters, the spaces around left out'),
+    ('A456', 'lib/journal/search.dart',
+     '  final q = typed.trim();',
+     '  final q = typed;',
+     'test/journal/search_test.dart', 'a search starts from three characters, the spaces around left out'),
+    ('A457', 'lib/journal/search.dart',
+     'return (night: night, entry: i, span: span);',
+     'return (night: night, entry: i - 1, span: span);',
+     'test/journal/search_test.dart', 'a night: its told dreams in order, never its name'),
+    ('A458', 'lib/journal/search.dart',
+     'const int contextWordsBefore = 3;',
+     'const int contextWordsBefore = 4;',
+     'test/journal/search_test.dart', 'the context: three words before, the match, then the rest'),
+    ('A459', 'lib/journal/search.dart',
+     "    before: left ? '$cut $before' : before,",
+     '    before: before,',
+     'test/journal/search_test.dart', 'the context: three words before, the match, then the rest'),
+    ('A460', 'lib/journal/search.dart',
+     '    match: _oneLine(text.substring(span.start, span.end)),\n    after: _oneLine(text.substring(span.end)).trimRight(),',
+     '    match: _oneLine(text.substring(span.start, span.end)),\n    after: text.substring(span.end).trimRight(),',
+     'test/journal/search_test.dart', 'the context is one line, each run of spaces one space'),
+    ('A461', 'lib/journal/search.dart',
+     '  var at = t.folded.indexOf(q);',
+     '  var at = t.folded.lastIndexOf(q);',
+     'test/journal/search_test.dart', 'the first place in the text, never a later one'),
 ]
 
 
~~~~

### Task 3 · The journal: the field, the count, the matching rows and their context lines

`journal_page.dart`: the field (`_SearchField`, `_Magnifier`), the query (`_search`, `_query`), the count
(`_count`: MP·76, W25), the results through `listItems`, and `_Row`'s context line (`_ContextLine`).
`stand_ins.dart`: the field's and the context line's stand-ins. Tests: `test/journal/pages/journal_search_test.dart`
(10); in `journal_page_test.dart` the empty journal now has one field, search's. Rows A462 to A474 new; A322, A377
and A379 follow the code (D67: the row's builder moved).

Expected: 599 app tests; rows `A322,A377,A379,A462,A463,A464,A465,A466,A467,A468,A469,A470,A471,A472,A473,A474`,
every one caught. Commit:

> Journal: search, from three characters, with the count, the matching nights and their context (D110, D116, D117)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index bfe09e6..db0c1d0 100644
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
index ca9b5f5..e9d654d 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -8,8 +8,16 @@
 // no night. Straight from onboarding, the first empty journal also shows
 // MP·9 under New Dream, with an arrow up to it, once (main-path.md,
 // Onboarding, 5); the logo waits for the founder's file. No Settings entry
-// and no search (later branches). Nothing on a row grades it: no badge,
+// (a later branch, D116 item 5). Nothing on a row grades it: no badge,
 // count or status.
+// Search (D110; D116; D117): the field at the top, as wide as a row, EM·4
+// its placeholder, a magnifier drawn in code and silent, no clear button.
+// From three characters, where the list starts: the count of nights (MP·76)
+// or W25, then only the matching nights' rows, newest first, under their
+// month dividers, each with its context line under it, the match in Inter
+// Bold. The query lives only while the page does: never kept, never logged
+// (R3), no recent searches.
+// The sky mark stays 140 down.
 import 'dart:async';
 
 import 'package:flutter/material.dart';
@@ -29,6 +37,7 @@ import '../night_action.dart';
 import '../night_look.dart';
 import '../night_rules.dart';
 import '../row_text.dart';
+import '../search.dart';
 import '../sky.dart';
 import 'night_art.dart';
 import 'night_page.dart';
@@ -53,6 +62,12 @@ class JournalPage extends StatefulWidget {
 
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
@@ -77,6 +92,10 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   late Sky _sky = _skyNow();
   late final Timer _clock;
 
+  // The search as typed, and as searched (null under three characters).
+  final _search = TextEditingController();
+  String? _query;
+
   Greeting _greetingNow() => greetingAt(widget.journal.zone.wall(widget.journal.now()));
   Sky _skyNow() => skyAt(widget.journal.zone.wall(widget.journal.now()).hour);
 
@@ -85,6 +104,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     super.initState();
     WidgetsBinding.instance.addObserver(this);
     _load();
+    _search.addListener(_searched);
     widget.recording?.retries?.addListener(_load);
     // The greeting and the sky mark follow the clock while the page is open.
     _clock = Timer.periodic(const Duration(minutes: 1), (_) {
@@ -102,11 +122,17 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
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
@@ -165,11 +191,36 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
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
@@ -190,28 +241,29 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
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
@@ -221,6 +273,94 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   }
 }
 
+/// The search's count: one night, more, or none (D117 Q2, Q3, Q5).
+String _count(int nights) => switch (nights) {
+  0 => Lines.W25.text(appLanguage),
+  1 => Lines.MP_76(n: 1).parts(appLanguage).first,
+  _ => Lines.MP_76(n: nights).parts(appLanguage).last,
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
@@ -312,42 +452,56 @@ class _Divider extends StatelessWidget {
 
 /// A night's row (D110, D115): a rounded row, 48 from each side of the
 /// screen and edged by a thin grey border, carrying only its date, centred in
-/// h6 over the night's picture; heard as a button named by its date. A name
+/// type.row.date over the night's picture (C18-P); heard as a button named by its date. A name
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
-                    child: DateShade.over(look, Text(shownDate(night.date), style: TypeRoles.rowDate.style(NightArt.over))),
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
+                  child: DateShade.over(look, Text(shownDate(night.date), style: TypeRoles.rowDate.style(NightArt.over))),
                 ),
               ),
             ),
@@ -357,3 +511,33 @@ class _Row extends StatelessWidget {
     ),
   );
 }
+
+/// A search result's context line (D116 item 3; D117 Q8): one line under
+/// its row, as wide as the row, centred, in the button type and
+/// `color.text.summary`, the matched characters in Inter Bold, cut with
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
+          TextSpan(text: line.match, style: const TextStyle(fontWeight: FontWeight.w700)),
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
index d150843..1e61a8a 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -75,9 +75,10 @@ void main() {
     // gone (D110).
     expect(find.text(Lines.MP_11.text(Lang.en)), findsOneWidget);
     expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
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
index 0000000..fe6218d
--- /dev/null
+++ b/app/test/journal/pages/journal_search_test.dart
@@ -0,0 +1,177 @@
+// The journal's search (D110; D116; D117 Q2 to Q8): the field at the top
+// with EM·4, from three characters the count (MP·76) or W25, only the
+// matching nights' rows, newest first, each with its context line, the match
+// in Inter Bold.
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
+    expect(find.text(Lines.MP_76(n: 2).parts(Lang.en).last), findsOneWidget);
+    expect(row(en), findsNothing);
+    expect(row(sv), findsOneWidget);
+    expect(row(named), findsOneWidget);
+    // Newest first, under the count.
+    final count = tester.getRect(find.byKey(JournalPage.countKey));
+    expect(tester.getRect(row(named)).top, greaterThan(count.bottom));
+    expect(tester.getRect(row(sv)).top, greaterThan(tester.getRect(row(named)).bottom));
+  });
+
+  testWidgets('one night: MP·76; none: W25 and no row', (tester) async {
+    phone(tester);
+    final h = await Harness.make();
+    final [en, sv, named] = await three(h);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    await type(tester, 'lighth');
+    expect(find.text(Lines.MP_76(n: 1).parts(Lang.en).first), findsOneWidget);
+    expect(row(en), findsOneWidget);
+    await type(tester, 'zzz');
+    expect(find.text(Lines.W25.text(Lang.en)), findsOneWidget);
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
+  testWidgets('a context line under its row, the match in Bold', (tester) async {
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
+    expect(parts[1].style!.fontWeight, FontWeight.w700);
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
index 807bd9e..bf49683 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A461, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A474, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 479 run, 479 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 492 run, 492 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -1512,7 +1512,7 @@ ROWS = [
      '',
      'test/journal/pages/night_page_test.dart', 'a given item runs once, with the night shown'),
     ('A322', 'lib/journal/pages/journal_page.dart',
-     '                          action: widget.nightAction,\n',
+     '          action: widget.nightAction,\n',
      '',
      'test/journal/pages/journal_page_test.dart', "a row hands its night's page the menu's item"),
     ('A323', 'lib/journal/pages/journal_home.dart',
@@ -1747,7 +1747,7 @@ ROWS = [
      'look: lookOf(night, read: false, paintings: NightArt.paintings),',
      'test/journal/pages/journal_page_test.dart', "a read night's row shows its painting"),
     ('A377', 'lib/journal/pages/journal_page.dart',
-     '                          read: widget.read,\n',
+     '          read: widget.read,\n',
      '',
      'test/journal/pages/journal_page_test.dart', "a row hands its night's page whether it is read"),
     ('A378', 'lib/journal/pages/journal_page.dart',
@@ -1755,8 +1755,8 @@ ROWS = [
      'constraints: const BoxConstraints(),',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
     ('A379', 'lib/journal/pages/journal_page.dart',
-     '      button: true,\n      child: GestureDetector(\n        key: JournalPage.rowKey(night.id),',
-     '      button: false,\n      child: GestureDetector(\n        key: JournalPage.rowKey(night.id),',
+     '    button: true,\n    child: GestureDetector(\n      key: JournalPage.rowKey(night.id),',
+     '    button: false,\n    child: GestureDetector(\n      key: JournalPage.rowKey(night.id),',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
     ('A380', 'lib/journal/pages/journal_page.dart',
      'TypeRoles.rowDate.style(NightArt.over)',
@@ -2099,6 +2099,59 @@ ROWS = [
      '  var at = t.folded.indexOf(q);',
      '  var at = t.folded.lastIndexOf(q);',
      'test/journal/search_test.dart', 'the first place in the text, never a later one'),
+    # redesign-b (D116, D117): the journal's search.
+    ('A462', 'lib/journal/pages/journal_page.dart',
+     '                  autocorrect: false,',
+     '                  autocorrect: true,',
+     'test/journal/pages/journal_search_test.dart', 'the field suggests and corrects nothing'),
+    ('A463', 'lib/journal/pages/journal_page.dart',
+     '                  enableSuggestions: false,',
+     '                  enableSuggestions: true,',
+     'test/journal/pages/journal_search_test.dart', 'the field suggests and corrects nothing'),
+    ('A464', 'lib/journal/pages/journal_page.dart',
+     '                  textInputAction: TextInputAction.search,',
+     '                  textInputAction: TextInputAction.done,',
+     'test/journal/pages/journal_search_test.dart', 'the field suggests and corrects nothing'),
+    ('A465', 'lib/journal/pages/journal_page.dart',
+     '    if (q != _query) setState(() => _query = q);',
+     '    if (q != _query) _query = q;',
+     'test/journal/pages/journal_search_test.dart', 'from three characters: the count and only the matching rows'),
+    ('A466', 'lib/journal/pages/journal_page.dart',
+     'listItems([for (final f in found) f.night])',
+     'listItems(nights!)',
+     'test/journal/pages/journal_search_test.dart', 'from three characters: the count and only the matching rows'),
+    ('A467', 'lib/journal/pages/journal_page.dart',
+     '  1 => Lines.MP_76(n: 1).parts(appLanguage).first,\n',
+     '',
+     'test/journal/pages/journal_search_test.dart', 'one night: MP·76; none: W25 and no row'),
+    ('A468', 'lib/journal/pages/journal_page.dart',
+     '  0 => Lines.W25.text(appLanguage),\n',
+     '',
+     'test/journal/pages/journal_search_test.dart', 'one night: MP·76; none: W25 and no row'),
+    ('A469', 'lib/journal/pages/journal_page.dart',
+     'fontWeight: FontWeight.w700',
+     'fontWeight: FontWeight.w400',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in Bold'),
+    ('A470', 'lib/journal/pages/journal_page.dart',
+     '      maxLines: 1,\n      overflow: TextOverflow.ellipsis,\n    );',
+     '      maxLines: 2,\n      overflow: TextOverflow.ellipsis,\n    );',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in Bold'),
+    ('A471', 'lib/journal/pages/journal_page.dart',
+     '    final style = TypeRoles.button.style(Palette.of(context).summary);',
+     '    final style = TypeRoles.button.style(Palette.of(context).text);',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in Bold'),
+    ('A472', 'lib/journal/pages/journal_page.dart',
+     '          _ContextLine(night.id, c),',
+     '          const SizedBox(),',
+     'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in Bold'),
+    ('A473', 'lib/journal/pages/journal_page.dart',
+     'StandIns.greetingAbove - StandIns.searchAbove - Spacing.sizeFieldSearch',
+     'StandIns.greetingAbove - StandIns.searchAbove',
+     'test/journal/pages/journal_search_test.dart', 'the field: EM·4 at the top, as wide as a row'),
+    ('A474', 'lib/journal/pages/journal_page.dart',
+     '              padding: const EdgeInsets.symmetric(horizontal: StandIns.rowSide - Spacing.pageSide),',
+     '              padding: EdgeInsets.zero,',
+     'test/journal/pages/journal_search_test.dart', 'the field: EM·4 at the top, as wide as a row'),
 ]
 
 
~~~~

### Task 4 · The opened night: its match in Inter Bold (D117 Q6)

`NightPage.query`; `DreamBubble.bold`; the journal hands the query on from a result. Tests: in
`night_page_test.dart` (3) and `journal_search_test.dart` (1, and the result's test widened). Rows A475 to A479.

Expected: 603 app tests; rows `A475,A476,A477,A478,A479`, every one caught. Commit:

> Night page: opened from a search, the first match in Inter Bold in its dream (D117 Q6)

**The block:**

~~~~diff
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index e9d654d..c852395 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -208,6 +208,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
           recording: widget.recording,
           action: widget.nightAction,
           read: widget.read,
+          query: query,
         ),
       ),
     );
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index a19f305..12768e9 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -25,7 +25,9 @@
 // Reflection; D119 item 4); Dreams brings "Dreams" into view, the
 // other three do nothing until their sections come with the readings. No
 // night is read yet. Not built: reading, and the space below the dreams
-// with its field.
+// with its field. Opened from a search, the night's first match shows in
+// Bold in its dream, found again on each read; gone when the page goes
+// (main-path.md, Search; D117 Q6).
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter/services.dart';
@@ -45,6 +47,7 @@ import '../night_action.dart';
 import '../night_look.dart';
 import '../night_rules.dart';
 import '../row_text.dart';
+import '../search.dart';
 import 'night_art.dart';
 import 'parts.dart';
 import 'typing_page.dart';
@@ -61,7 +64,15 @@ enum Jump {
 }
 
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
@@ -86,6 +97,9 @@ class NightPage extends StatefulWidget {
   /// Whether a night has been read: none is yet (the readings come later).
   final ReadCheck read;
 
+  /// The search this night was opened from, as searched, or null.
+  final String? query;
+
   @override
   State<NightPage> createState() => _NightPageState();
 }
@@ -314,6 +328,8 @@ class _NightPageState extends State<NightPage> {
     final top = MediaQuery.paddingOf(context).top;
     final read = n != null && widget.read(n);
     final look = n == null ? null : lookOf(n, read: read, paintings: NightArt.paintings);
+    final query = widget.query;
+    final found = n == null || query == null ? null : findIn(n, query);
     // Light time and battery over the header's picture, in both themes (D113);
     // while the page is blank, the app's own theme (D114).
     final overlay = look != null ? SystemUiOverlayStyle.light : statusBarFor(Theme.of(context).brightness);
@@ -396,7 +412,11 @@ class _NightPageState extends State<NightPage> {
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
index b2d0834..4db2a57 100644
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
+/// opened from a search, its [bold] characters in Bold (D117 Q6).
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
+                          style: const TextStyle(fontWeight: FontWeight.w700),
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
index fe6218d..e4b4772 100644
--- a/app/test/journal/pages/journal_search_test.dart
+++ b/app/test/journal/pages/journal_search_test.dart
@@ -158,10 +158,23 @@ void main() {
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
index 4af4c4c..7e3bc4b 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -25,6 +25,7 @@ import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/journal/search.dart';
 import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/words/lines.g.dart';
 
@@ -83,6 +84,7 @@ void main() {
     bool wide = false,
     int hour = 12,
     bool unread = false,
+    String? query,
   }) async {
     // The test's own 800 by 600, where the foot's two buttons do not fill
     // the row, or a phone.
@@ -104,12 +106,48 @@ void main() {
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
+  // Bold, in its dream; every other dream, and every opening without a
+  // search, as before.
+  List<TextSpan>? boldParts(WidgetTester tester, String dream) {
+    final text = tester.widget<Text>(find.text(dream));
+    if (text.data != null) return null;
+    return (text.textSpan! as TextSpan).children!.cast<TextSpan>();
+  }
+
+  testWidgets('from a search: the first match in its dream, in Bold', (tester) async {
+    await open(tester, key: 'named-three-dreams-sv', query: 'NYCKEL');
+    final d = n.dreams[2];
+    final at = firstMatch(d, 'NYCKEL')!;
+    final parts = boldParts(tester, d)!;
+    expect([for (final s in parts) s.text], [d.substring(0, at.start), d.substring(at.start, at.end), d.substring(at.end)]);
+    expect(parts[1].style!.fontWeight, FontWeight.w700);
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
index bf49683..af32b89 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A474, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A479, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 492 run, 492 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 497 run, 497 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -2152,6 +2152,27 @@ ROWS = [
      '              padding: const EdgeInsets.symmetric(horizontal: StandIns.rowSide - Spacing.pageSide),',
      '              padding: EdgeInsets.zero,',
      'test/journal/pages/journal_search_test.dart', 'the field: EM·4 at the top, as wide as a row'),
+    # redesign-b (D117 Q6): the opened night's match in Bold.
+    ('A475', 'lib/journal/pages/night_page.dart',
+     '                          bold: found?.entry == i ? found!.span : null,',
+     '                          bold: null,',
+     'test/journal/pages/night_page_test.dart', 'from a search: the first match in its dream, in Bold'),
+    ('A476', 'lib/journal/pages/night_page.dart',
+     '                          bold: found?.entry == i ? found!.span : null,',
+     '                          bold: found?.span,',
+     'test/journal/pages/night_page_test.dart', 'from a search: the first match in its dream, in Bold'),
+    ('A477', 'lib/journal/pages/parts.dart',
+     '                          style: const TextStyle(fontWeight: FontWeight.w700),',
+     '                          style: const TextStyle(fontWeight: FontWeight.w400),',
+     'test/journal/pages/night_page_test.dart', 'from a search: the first match in its dream, in Bold'),
+    ('A478', 'lib/journal/pages/journal_page.dart',
+     '          query: query,\n',
+     '',
+     'test/journal/pages/journal_search_test.dart', 'a result opens its night'),
+    ('A479', 'lib/journal/pages/journal_page.dart',
+     '          query: query,\n',
+     '          query: _search.text,\n',
+     'test/journal/pages/journal_search_test.dart', 'a row opened with no search hands no query'),
 ]
 
 
~~~~

### Task 5 · Docs: Status.md and the Dev-only test

Status.md: "Last updated", the road ahead, the greeting and search, the counts (603 tests, 497 rows), banked items
145 to 149 (and 144's note), and "Rulings during redesign-b": the redesign-a merge, D116 and D117 written out.
`dev_only_test.dart`: SoulDreams Dev reaches `search.dart`. Then the full run (D95), once, before the final review:
`python3 -I -B tool/app_mutations.py` → `app mutations: 497 run, 497 caught`.

Expected: 603 app tests; the rows naming `dev_only_test.dart`, every one caught. Commit:

> Docs: Status.md for redesign-b (D116 to D119); 497 mutation rows

**The block:**

~~~~diff
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
index 04d9aa8..0b3db8b 100644
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -77,6 +77,7 @@ void main() {
   // until the owner gives the next one.
   test('SoulDreams Dev reaches the journal pages', () {
     final files = reached('lib/main_dev.dart');
+    expect(files, contains('lib/journal/search.dart'));
     expect(files, contains('lib/journal/pages/journal_page.dart'));
     expect(files, contains('lib/journal/pages/night_page.dart'));
     expect(files, contains('lib/recording/record_microphone.dart'));
diff --git a/docs/Status.md b/docs/Status.md
index 317f577..1629588 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-21, in branch `redesign-b` (C18-P imported, D118 and D119; the search plan amended to it; the owner's by-eye checks of the fonts next), by Claude Code.
+Last updated: 2026-11-21, in branch `redesign-b` (C18-P imported, D118 and D119; the filed greeting, New Dream and jump buttons; search, D110, D116, D117; the owner's by-eye review, then the merge, next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -19,9 +19,9 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Road ahead
 
-- `redesign-a`: the owner's by-eye review (the plan's Task 9), then the merge.
-- Redesign B and C (D110): search, Settings (with Word Animation's setting) and the consent's controls; then Life
-  Context, with C159-I's import, and "Made by AI". The curated set of night paintings (about 60, the founder's)
+- `redesign-b`: the owner's by-eye review (the plan's Task 6), then the merge.
+- Redesign B's rest and C (D110): Settings (with Word Animation's setting, and the gear, D116 item 5) and the
+  consent's controls, with C18-P's three consents (MP·66 to MP·70, D119 item 1); then Life Context, with C159-I's import, and "Made by AI". The curated set of night paintings (about 60, the founder's)
   replaces the placeholders, fingerprinted as the fonts are (a G0 and G2 change, the owner's).
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1); the pending lines are filed at
   C17-P (and, for the founder app, with his export).
@@ -239,14 +239,29 @@ rulings given during each branch are listed in this file, one line each, under "
   At C18-P (D118): `TypeRoles.rowDate` (Inter SemiBold 20) carries a row's date; a line or letter "[to set in
   Framer]" is null, the font's own; a colour "[to try ...]" or "[proposed ...]" has no constant
   (`color.label.questions`, the dark `color.lifecontext.delete`), one "[owed: ...]" keeps its value.
+- The journal's greeting (C18-P; D119 item 4): MP·72 to MP·75 by the part of the day, from 05:00, 11:00, 17:00
+  and 21:00, one line of the part's four a day, in turn; a night after midnight keeps the line of the evening it
+  began on (the day counted under D91). New Dream is MP·11; a read night's jump buttons are MP·77's four parts.
+  `owed.dart` is gone: no owed handle is left on a screen.
+- Search (D110; D116; D117; `redesign-b`; TO TRY where a stand-in): the journal's field at the top (20 down, 50 tall,
+  as wide as a row; `color.field` with its border; EM·4 its placeholder; a magnifier drawn in code, silent; no clear
+  button; no autocorrect or suggestions), the sky mark still 140 down. From three characters (code points, the
+  spaces around left out): where the list starts, the count of nights (MP·76, "1 match" or "{n} matches") or W25,
+  then only the matching nights' rows, newest first, under their month dividers, each with a context line under it:
+  up to three words before the match (an ellipsis when words were left off), the match in Inter Bold, then the
+  rest, one line, the button type in `color.text.summary`. The matcher (`journal/search.dart`, `firstMatch`, one
+  function for recurring images later): each character folded by itself (Dart's own folding), marks kept, the typed
+  characters at the start of a word (D117 Q4), the told dreams in order, never a name, the first place. A result
+  opens its night with the match in Inter Bold in its dream (D117 Q6), found again on each read, gone when the page
+  goes. The query is never kept or logged (R3).
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 577 tests, and 462 mutation checks (A1 to A443; A24ah,
+- The app's analyzer baseline: `No issues found!`. The app has 603 tests, and 497 mutation checks (A1 to A479; A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
-  A313 and A375 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
+  A313, A363 and A375 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 462 run, 462 caught`); `check_all.sh` does not call it (D55). During a task only the
+  (expected: `app mutations: 497 run, 497 caught`); `check_all.sh` does not call it (D55). During a task only the
   rows that target the files changed are run, with `--rows A1,A7` or `--files lib/a.dart` (D95).
 
 ## The server
@@ -826,6 +841,23 @@ Banked in redesign-a (D91; none changes what the dreamer sees beyond D110; the p
      it).
 144. Shown dates now have a two-digit year (D112). MP·27 and `main-path.md` (Every Screen) say `dd/mm/yyyy`, and the
      C17-P copies stay as filed: for Product's next filing, with Part 4 item 12's list. The export is unchanged.
+     (C18-P files MP·27 as dd/mm/yy; `main-path.md` waits for Product's next pass.)
+
+Banked in redesign-b (D91; none changes what the dreamer sees beyond D116 to D119 and the filed lines and values):
+
+145. For Product's next filing, through the head: names no longer searched (D116 item 1, against `main-path.md`'s
+     "night names included"); "1 match" shown against C134-I item 6's "by itself, with no line" (D117 Q3); the
+     microphone's spoken name still MP·11, now "New Dream" (D119 item 3); a night greeting after midnight keeps the
+     evening's line (the day counted under D91). For Interpretation, through the head: the matcher's rule, the typed
+     characters at the start of a word, against C140-I item 6's plain forms (D117 Q4).
+146. Text and query are not normalised (NFC would need a package): a letter typed composed does not match the same
+     letter stored as a letter and a mark. Keyboards and Soniox give composed letters.
+147. Dart folds each character to one (a capital I with a dot to a plain i); a folding that changed a character's
+     length would still map back to whole characters. Greek's final sigma folds as Dart folds it.
+148. Since C18-P no type role names Nunito or Habibi; both stay declared until a ruling removes them. The dreamer's
+     words quoted in a reflection take "Inter Display Italic" (§1), which the app does not have (no Inter Italic
+     file): for the readings' branch.
+149. `opening()` (`row_text.dart`) stays unused: D116 item 3's context replaced it for search (banked item 136).
 
 ## Before Cohort 1
 
@@ -1158,7 +1190,18 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 
 ## Rulings during redesign-b
 
-- D116 and D117 (owner): the search plan's brainstorm and its stop, listed in `docs/plans/redesign-b.md`.
+- `redesign-a` merged by the owner (`e81f29c`).
+- D116 (owner, the brainstorm): (1) search covers the dreams' text in every night (no readings or Life Context
+  yet); (2) matching ignores case, Unicode-aware, and keeps letters with marks distinct; (3) the context line is a
+  short stretch around the first match, the matched characters in bold; (4) the count lines and "No matches" as
+  pending lines where the register has no place (C18-P has since filed them: MP·76 and W25); (5) the settings gear
+  stays out until redesign C.
+- D117 (owner, on the stop of 2026-11-21): Q1 a pending line takes the register's slots, and Q2 MP·68 for "No
+  matches" (both superseded by C18-P's filing: the count is MP·76, the empty result W25, no pending line); Q3 D110
+  governs ("1 match" shown; C134-I item 6 to the head); Q4 the typed characters at the start of a word, one
+  reusable function, flagged to the head for Interpretation; Q5 nights are counted; Q6 the opened night's match in
+  bold (Inter Bold since C18-P, D118); Q7 the journal while searching as leaned, no clear button; Q8 the context
+  line as leaned.
 - D118 (founder): where the Design System names "Inter Display", the app uses Inter (already installed), at the same
   sizes and spacing; the Build chat tells Product.
 - D119 (owner, on C18-P's import stop, `.scratch/for-build-chat/c18p-import-stop.md`), as leaned: (1) until the three
~~~~

### Task 6 · [OWNER] The by-eye review, SoulDreams Dev, invented nights only

By eye only, in SoulDreams Dev built from this branch, with invented nights typed from
`fixtures/invented-nights.json` (save at least `two-dreams-en`, `one-dream-sv` and `named-three-dreams-sv`, each
as its own night). Check each step in the light theme and, where it says so, in the dark one (after 21:00 or before
08:00). If any result differs, stop and bring it to the Build chat; nothing is fixed on the phone.

**The fonts and lines from C18-P** (the import, D118, D119):

1. **The row's date** (light and dark): each row's date in Inter SemiBold, white, a little larger than before (20,
   was 18), centred over its picture or gradient, with the soft shade behind it on a painting.
2. **The dreamer's words** (a night's dream bubbles, and the typing screen as you type): Inter, slightly spaced
   (0.02em), where it was Nunito. Line height as before.
3. **The app's voice** (onboarding's lines, and "Read everything", the full disclosure page): Bellefair at 22, with
   tight letter spacing (−0.04em), where it was Sorts Mill Goudy at 18. Check it reads calmly at the usual text size
   and at the largest.
4. **Onboarding's consent step** (D119 1): the right button reads "I consent"; "I don't agree" (EM·6) is still the
   left one; the line "By clicking I agree…" is gone, with no gap where it stood.
5. **The greeting**: by the clock (morning from 05:00, day from 11:00, evening from 17:00, night from 21:00); the
   next day, at the same time, a different line of the same part. New Dream reads "New Dream". On a read night
   (`PREVIEW_READ`), the jump buttons read Dreams, Questions, Readings, Reflection.
6. **The first empty journal** (a fresh install): "Tap here to record your first dream" under New Dream.

**Search:**

7. **The field (light and dark).** At the top, a white pill (in the dark theme, a beige one with no edge) as wide as
   the rows, with a thin magnifier at its left and "Search your journal" in grey. The sun or moon, the greeting
   and New Dream are where they were. No settings gear and no clear button.
8. **Typing.** Tap the field: the keyboard's key reads Search; no word suggestions above the keys; nothing typed is
   corrected.
9. **Under three characters** (type `gl`): the journal is unchanged, with every row.
10. **From three characters** (type `glas`): under New Dream, "2 matches", then only the two Swedish nights' rows,
    newest first, under their month's divider. Under each row, one grey line: a few words, "glas" in bold, then the
    rest, cut with "…" where it runs out.
11. **Capitals and marks.** `GLAS` gives the same as `glas`. `tåg` finds the night with "tågen"; `tag` finds nothing.
12. **Start of a word only.** `citron` finds the night with "citronträd"; `träd` finds nothing.
13. **One and none.** `lighth` shows "1 match" and one row; `zzz` shows "No matches" and no row (and not the empty
    journal's line).
14. **A result opens its night.** With `nyckel` typed, tap the row: the night opens, and in its third dream "nyckel"
    is in bold (Inter Bold, a true bold). Back: the search is still there. Open the same night from the plain
    journal (clear the field): nothing is bold.
15. **Back under three characters** (delete to `ny`): the whole journal returns.
16. **Large text** (the phone's largest): the field grows to fit, and the results and context lines show no cut-off
    or overlap beyond the line's own "…".

**The founder's verdict, TO TRY** (P13; design-system.md §8, C18-P):

17. The journal rows' height, edge and width (now 48 from each side, 1 pt grey border, the stand-in height).
18. The night's header (about 240 tall in §8; check how it scrolls away as the night is read).
19. The jump buttons' colours, read from his screens: Dreams green, Questions brown (a stand-in until
    `color.label.questions` is set), Readings terracotta, Reflection blue, in both themes.
20. Search's places: the field (20 from the top), the context line (three words before, its grey, 6 below the row),
    the count's place. Keep, or the values he wants.

## Part 4 · Questions (numbered; a blank is not a yes)

None open. D117 answered the first stop, and D119 the import's; each is built as answered. Carried upward by the
Build chat (banked item 145): for Product, names no longer searched, "1 match" against C134-I item 6, the
microphone's spoken name (MP·11, D119 item 3), and the greeting's day after midnight; for Interpretation, the
matcher's start-of-word rule against C140-I item 6's plain forms.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/rb2/build`, from `git archive` of `3e95600` (the
   import), each task's state kept as a snapshot (`./.scratch/rb2/snaps/s<task>`). Each block in Part 3 is
   `git diff --no-index` between two snapshots. Harness files (`.claude/`), `.dart_tool`, the app's `build/`, the
   generated iOS files (`Generated.xcconfig`, `flutter_export_environment.sh`, `GeneratedPluginRegistrant.*`,
   `ephemeral`) and Python's `__pycache__` are left out of every snapshot.
2. **Tasks 2 to 4 began from the first plan's blocks**, ported: MP·66 and MP·67 to MP·76's parts, MP·68 to W25, the
   pending import and the pending-line test removed, SemiBold to Bold (`FontWeight.w700`), the rows renumbered from
   A442 to A451. Three hunks no longer applied after Task 1 (their context had `_daypart` and the row date's `h6`);
   each was applied by hand to the new context, then the whole task proven as below.
3. **The counts measured on the build**: app tests 577 (baseline), 580, 589, 599, 603, 603, with `No issues
   found!` at each.
4. **Test first**: each task's new and changed test files, put on the snapshot before the task, failed to load.
   During the build: G4 refused three test names of twelve words or more (Task 1), each shortened; two Task 1 tests
   found the jump buttons by their words, which MP·38's "Dreams" now shares, so they find them by key; rows A394 and
   A405 named `_daypart` and followed the code (D67).
5. **Mutations on the build** (D95, every row of the files changed): Task 1, `greeting.dart`, `journal_page.dart`,
   `night_page.dart` `74 run, 74 caught` (after A394 and A405 followed); Task 2, `search.dart` `11 run, 11 caught`;
   Task 3, `journal_page.dart` and `stand_ins.dart` `48 run, 48 caught`; Task 4, `night_page.dart`, `parts.dart` and
   `journal_page.dart` `98 run, 98 caught`; Task 5, the rows naming `dev_only_test.dart` `5 run, 5 caught`.
6. **The guards** on each snapshot: `guards (walk): all passed`.
7. **Replayed on a fresh copy**, `./.scratch/rb2/replay`, from `git archive` of `3e95600`: every block applied with
   `git apply` in order (with `GIT_CEILING_DIRECTORIES` set, so `git apply` is not silently skipped inside the
   repository), and after each the tree compared with its snapshot: no difference. On the replayed tree:
   `guards (walk): all passed`, `No issues found!`, `+603: All tests passed!`; the 36 new and 11 followed rows, with A380 and A425 (the row date's, from the import),
   `app mutations: 49 run, 49 caught`.
8. **Not run in the sandbox**: the full app mutation run (D95, Task 5); `tool/check_all.sh` whole (the owner's).
9. **Not provable in the sandbox, so the owner's** (Task 6): the look on the phone in both themes, the fonts
   included; the keyboard's Search key and no suggestions; large text on a real phone.
10. The scratch copies (`./.scratch/rb2/`) are deleted after this plan is committed.

*No matter where you are on your journey, the steps you take are equally important.*
