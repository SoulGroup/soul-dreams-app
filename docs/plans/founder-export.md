# Plan: the founder's export, in SoulDreams Dev (founder-export)

Branch `founder-export`, from `main` at `ae23e94`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D95, for the owner's rulings D107 and D108. Written by Claude Code (Opus) on 2026-11-19. The owner's
checks are by eye only. Nothing is implemented by this plan's commit, which also corrects Status.md's "waiting for the
merge" line (D108).

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

In SoulDreams Dev, each night's "⋯" menu gains one item above "delete this night": "Export night" (MP·65, the founder's
pending line). Tapping it opens the phone's share sheet with one small text file: the night's name if it has one, its
date as the night's page shows it, then each dream in its words, in order, a blank line between. A recording still
waiting has no words and is left out. The file is named by the night's date in digits, `2026-06-02.txt`.

iOS cannot show AirDrop alone (D108): the share hides every target Apple names (Messages, Mail, Copy, Print, Save to
Photos and the rest) and, on iOS 18 and later, the row of people; the targets it cannot hide (other apps, Save to
Files, Notes, Reminders and the like) still show, but the file is handed to AirDrop alone: any other target receives
nothing. The file lives in the app's temporary folder only while the share is open, and is deleted when it closes,
sent or not; the folder is also emptied before each share and every time the app starts. Nothing goes through a
server or any service. A failed export shows nothing and logs a code.

The founder's app has no journal yet, so the export reaches SoulDreams Dev only in this branch; the founder's app gains
it with its journal, by a later ruling. The testers' app never has it: its Dart never imports it, and its Swift is not
compiled into it.

### What this branch builds

1. `lib/journal/night_action.dart`: `NightAction`, the hook (its words and what it does with the night). `NightPage`
   shows it above delete; `JournalHome` and `JournalPage` pass it on. Nothing in `lib/journal/` reaches
   `lib/founder/`.
2. `lib/founder/export_text.dart`: the file's text, bytes and name.
3. `lib/founder/founder_export.dart`: `FounderExport`, the menu's item (MP·65) and the channel's one message, `share`
   with the name and the bytes; `LogEvent.exportFailed`.
4. `AppDelegate.swift`: `FounderExport` and `OnlyAirDrop`, inside `#if SOULDREAMS_EXPORT`; the condition in
   `dev.xcconfig` and `founder.xcconfig` only.
5. `main_dev.dart` gives the item to `JournalHome`.

### What it does not build

The export in the founder's app (it has no journal yet; D108). Any other way out (no Copy, no Files, no Messages).
Any import back into the app (C153-I item 3: none is built). Any undocumented hiding of targets by their internal
identifiers (D108). Any new line: MP·65 is the founder's pending line, committed in Task 1.

### The decisions (D107, D108)

- One night at a time, from its "⋯" menu (D107 1). Plain text, the date and each dream in order (D107 2; no document
  rules a format). AirDrop alone is handed the file (D107 3; D108 (a)). The file only for the share, deleted after,
  nothing through a server (D107 4; R11).
- MP·65 "Export night", a pending line (D108 Q1). MP·39 unchanged; a waiting recording left out; a failed export shows
  nothing and logs `exportFailed`; SoulDreams Dev only; our own Swift channel, compiled only into dev and founder, the
  xcconfig change approved (D108 Q2 to Q6). No internal-identifier hiding (D108 Q7). AirDrop's "Use Cellular Data"
  off, the Mac close (D108; Task 9).

### What the investigation found

1. **The documents.** C142-I item 3, C146-I item 2 (reversed by C147-I: no distress results exist), C153-I item 3 (the
   safety copy), C4-T item 8, technical-answers ("The founder's export, as built"), the handover §9, main-path.md ("The
   founder's own export"; "Inside any night": the menu "also holds his export"). None rules a format or a label ("Its
   label is his, seen only by him").
2. **The share.** iOS has no AirDrop-only API; `UIActivityViewController` excludes only the types Apple names
   (`UIActivity.h`, the iOS 26.5 SDK on this Mac: nineteen, besides AirDrop), and on iOS 18 the people row
   (`excludedActivitySectionTypes`). An item source may answer nothing for a type ("you can return nil",
   `UIActivityItemProvider.h`): `OnlyAirDrop` answers the file for `.airDrop` only. Flutter's own text share
   (`Share.invoke`) has neither, and is not used.
3. **The founder's app** (`main_founder.dart`) shows the blank app: the journal is Dev only (D49 O1, D56).
4. **The menu** (`night_page.dart`, `_menu`): a `CupertinoMenuAnchor` holding delete; the journal's pages must never
   import `lib/founder/` (G8, R8), so the item comes in as a hook from the entry point.
5. **Compiled out of the tester app.** The flavour xcconfigs are the Runner target's base configurations, and no
   Runner configuration sets `SWIFT_ACTIVE_COMPILATION_CONDITIONS` itself (`project.pbxproj`), so the xcconfig's line,
   with `$(inherited)`, is what the flavour's Swift sees. `xcodebuild -showBuildSettings` cannot run in the sandbox
   (DerivedData); the owner's Task 9 checks the built binaries.
6. **The name and date.** The night's page shows `dayDigits` (`row_text.dart`), `dd/mm/yyyy`; the file's text uses it.
   The file's name uses digits only, so no night's words reach a file name.

### Decided under D91 (how to build only)

1. The item sits above delete, plain (delete stays last, as the phone's menus put the destructive choice).
2. `NightAction` holds a `String` label, read once at start (English only, D57 Q12).
3. The share answers the Dart side when it closes; a second share while one is open is refused with a code (the sheet
   covers the page, so it cannot be reached).
4. The file is written to `tmp/Export/<date>.txt`; a failure before the share opens deletes it.

### The places this branch uses

MP·65 (pending, new: the founder's, D108), EM·11's second part, MP·39 (unchanged). No other line.

### The tests (test-first, on the Mac)

Every task adds its tests before its code. Tasks 2 to 4's new tests name what the task adds, so on the code before it
they fail to load; Tasks 5 and 6's were run on the code before them and failed (Part 5). Each assertion is then shown
to bite by its mutation row. 22 new tests (480 to 502); 24 new mutation rows (A320 to A343); A24ap follows the code
(D67). The phone's side, by the owner (Task 9).

## Part 2 · Settings and packages

No package. Two build settings, approved by D108: `SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited)
SOULDREAMS_EXPORT` in `app/ios/Flutter/dev.xcconfig` and `founder.xcconfig`. No change to `.claude` settings, the
guards, `tool/checks/`, the register, the server, AWS or Soniox. The words: the owner's three pending-line files
(Task 1). The journal's storage is unchanged; the export reads a night and writes only a temporary file outside the
journal's folder.

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, generated from the build that proved it (Part 5). Apply it
from the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit through
the hook with the message given.

Every Claude Code task ends green:
- `cd app && fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub` passes at the
  count given;
- the hook: `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `founder-export`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 && (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- from `git status`, only the owner's three files: ` M app/assets/words/pending-fingerprint.txt`,
  ` M app/assets/words/pending-lines.csv`, ` M app/lib/words/pending.g.dart`;
- the plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+480: All tests passed!`.

Anything else: stop (R14).

### Task 1 · The owner's pending line MP·65 (D108)

No block: the owner's three files, as he wrote them ("pending lines 6"; sha256 of `pending-lines.csv`
`eea09c6ef3cb5c83dae1f4babe6e37667ab43265479bc01389a29cc0e0ed3e1c`, as its fingerprint says). Check, then commit them
alone:

```
python3 -I -B tool/checks/wordsgen.py --check && shasum -a 256 app/assets/words/pending-lines.csv && git add app/assets/words/pending-fingerprint.txt app/assets/words/pending-lines.csv app/lib/words/pending.g.dart
```

Expected: `wordsgen: up to date`; the hash above. 480 app tests. Commit:

> Pending line MP·65, the founder's export in a night's menu (the owner's, D108)

### Task 2 · The night's menu takes one more item, from the entry point (D107 item 1)

`NightAction` (`lib/journal/night_action.dart`): words and what to do with the night. `NightPage` shows it above
delete, plain, and runs it with the night shown; `JournalPage` and `JournalHome` pass it on. Tests:
`night_page_test.dart` (2), `journal_page_test.dart` (1), `journal_home_test.dart` (1).

Expected: 484 app tests. Commit:

> The night's menu takes one more item from the entry point, above delete (D107)

**The block:**

~~~~diff
diff --git a/app/lib/journal/night_action.dart b/app/lib/journal/night_action.dart
new file mode 100644
index 0000000..c1bd6f5
--- /dev/null
+++ b/app/lib/journal/night_action.dart
@@ -0,0 +1,15 @@
+// One more item for a night's "⋯" menu, given by the entry point (D107
+// item 1). The journal knows only its words and that it takes the night:
+// what it does lives with whoever gives it, so nothing of it is built into
+// an app that gives none (R8).
+import 'night.dart';
+
+final class NightAction {
+  const NightAction({required this.label, required this.run});
+
+  /// The item's words, from the register or a pending line (R1).
+  final String label;
+
+  /// What the item does with the night shown.
+  final Future<void> Function(Night night) run;
+}
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index f83356c..95b04b1 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -25,10 +25,11 @@ import '../journal.dart';
 import '../journal_audio.dart';
 import '../journal_files.dart';
 import '../journal_store.dart';
+import '../night_action.dart';
 import 'journal_page.dart';
 
 class JournalHome extends StatefulWidget {
-  const JournalHome({super.key, required this.files, this.after, this.recording});
+  const JournalHome({super.key, required this.files, this.after, this.recording, this.nightAction});
 
   final JournalFiles files;
 
@@ -39,6 +40,9 @@ class JournalHome extends StatefulWidget {
   /// How to record by voice, or null (D69).
   final Recording? recording;
 
+  /// The item each night's menu gains, or null (D107 item 1).
+  final NightAction? nightAction;
+
   @override
   State<JournalHome> createState() => _JournalHomeState();
 }
@@ -159,7 +163,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     return switch (_agreed) {
       null => const Scaffold(),
       false => Onboarding(onAgreed: _agree),
-      true => JournalPage(journal: _journal!, recording: _recording, firstTime: _first),
+      true => JournalPage(journal: _journal!, recording: _recording, firstTime: _first, nightAction: widget.nightAction),
     };
   }
 }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 77595b8..5c05aac 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -18,6 +18,7 @@ import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
 import '../journal.dart';
 import '../night.dart';
+import '../night_action.dart';
 import '../night_rules.dart';
 import '../row_text.dart';
 import 'night_page.dart';
@@ -25,7 +26,7 @@ import 'parts.dart';
 import 'typing_page.dart';
 
 class JournalPage extends StatefulWidget {
-  const JournalPage({super.key, required this.journal, this.recording, this.firstTime = false});
+  const JournalPage({super.key, required this.journal, this.recording, this.firstTime = false, this.nightAction});
 
   final Journal journal;
 
@@ -38,6 +39,9 @@ class JournalPage extends StatefulWidget {
   /// How to record by voice in the typing screen, or null (D69).
   final Recording? recording;
 
+  /// The item each night's menu gains, or null (D107 item 1).
+  final NightAction? nightAction;
+
   @override
   State<JournalPage> createState() => _JournalPageState();
 }
@@ -144,7 +148,12 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
                       NightItem(:final night) => _Row(
                         night,
                         onTap: () =>
-                            _push(NightPage(journal: widget.journal, id: night.id, recording: widget.recording)),
+                            _push(NightPage(
+                              journal: widget.journal,
+                              id: night.id,
+                              recording: widget.recording,
+                              action: widget.nightAction,
+                            )),
                       ),
                     },
                 ],
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index c9647e8..7c594bd 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -2,7 +2,9 @@
 // 3; P1, P6, P7; D58 Q1, Q4, Q8; head's message 20, items 10 to 12): the
 // header centred (the date, or the name and the date); the "⋯" menu top
 // right, a bordered pill opening the phone's menu, spoken as MP·39,
-// holding only "delete this night" (EM·11's second part), plain; one
+// holding "delete this night" (EM·11's second part), plain, and above it
+// the item the entry point gives, if any (D107 item 1: the founder's
+// export, in SoulDreams Dev; R8); one
 // confirmation, the phone's standard dialog, Cancel first and Delete
 // destructive (MP·61, MP·60, pending lines); the dreams under "Dreams"
 // (MP·38), in bubbles 30 from the screen's left edge and 10 from its
@@ -28,16 +30,18 @@ import '../../words/pending.g.dart';
 import '../../recording/recording.dart';
 import '../journal.dart';
 import '../night.dart';
+import '../night_action.dart';
 import '../night_rules.dart';
 import '../row_text.dart';
 import 'parts.dart';
 import 'typing_page.dart';
 
 class NightPage extends StatefulWidget {
-  const NightPage({super.key, required this.journal, required this.id, this.recording});
+  const NightPage({super.key, required this.journal, required this.id, this.recording, this.action});
 
   static const menuKey = Key('night-menu');
   static const deleteKey = Key('night-delete');
+  static const actionKey = Key('night-action');
   static const addKey = Key('night-add');
   static const startKey = Key('night-start');
   static const transcribingKey = Key('night-transcribing');
@@ -48,6 +52,9 @@ class NightPage extends StatefulWidget {
   /// How to record by voice in the typing screen, or null (D69).
   final Recording? recording;
 
+  /// The menu's item above delete, or null (D107 item 1).
+  final NightAction? action;
+
   @override
   State<NightPage> createState() => _NightPageState();
 }
@@ -151,12 +158,25 @@ class _NightPageState extends State<NightPage> {
     if (mounted) Navigator.of(context).pop();
   }
 
+  // The entry point's item, with the night shown; not while a delete runs.
+  Future<void> _act() async {
+    final night = _night;
+    if (_busy || night == null) return;
+    await widget.action?.run(night);
+  }
+
   // The "⋯" menu: a bordered pill (color.button) opening the phone's menu;
   // while a delete runs, a tap opens nothing (D64).
   Widget _menu(Palette p) => CupertinoMenuAnchor(
     // A tap outside the open menu only closes it (D102).
     consumeOutsideTaps: true,
     menuChildren: [
+      if (widget.action case final action?)
+        CupertinoMenuItem(
+          key: NightPage.actionKey,
+          onPressed: _act,
+          child: Text(action.label),
+        ),
       CupertinoMenuItem(
         key: NightPage.deleteKey,
         onPressed: _delete,
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index 436ba11..b7a4aad 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -12,12 +12,14 @@ import 'package:souldreams/journal/journal.dart';
 import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/journal_store.dart';
 import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/night_action.dart';
 import 'package:souldreams/journal/pages/journal_home.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/onboarding/onboarding.dart';
 import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/words/lines.g.dart';
+import 'package:souldreams/words/pending.g.dart';
 
 import '../../fixtures.dart';
 import '../../recording/fakes.dart';
@@ -110,6 +112,14 @@ void main() {
     expect(handed.microphone, same(recording.microphone));
   });
 
+  testWidgets("the night's menu item is handed to the journal", (tester) async {
+    JournalStore.newQueueForTests();
+    final action = NightAction(label: PendingLines.MP_65.text(Lang.en), run: (_) async {});
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), nightAction: action)));
+    await tester.pumpAndSettle();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).nightAction, same(action));
+  });
+
   // D92 item 3: a recording waiting is retried only while the app is open:
   // when the journal opens and when the app comes back; leaving cuts it.
   testWidgets('the journal opening retries; leaving cuts it; back resumes', (tester) async {
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index 178425a..a285be0 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -13,12 +13,14 @@ import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/design/stand_ins.dart';
 import 'package:souldreams/design/tokens.g.dart';
 import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/night_action.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
 import 'package:souldreams/words/lines.g.dart';
+import 'package:souldreams/words/pending.g.dart';
 
 import '../../fixtures.dart';
 import '../memory_journal_files.dart';
@@ -261,6 +263,16 @@ void main() {
     expect(find.text(n.dreams[1]), findsOneWidget);
   });
 
+  testWidgets("a row hands its night's page the menu's item", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    final action = NightAction(label: PendingLines.MP_65.text(Lang.en), run: (_) async {});
+    await h.pump(tester, JournalPage(journal: h.journal, nightAction: action));
+    await tester.tap(find.text(dayDigits(n.date)));
+    await tester.pumpAndSettle();
+    expect(tester.widget<NightPage>(find.byType(NightPage)).action, same(action));
+  });
+
   testWidgets('text at twice the size does not overflow', (tester) async {
     final h = await Harness.make();
     await keep(h, 'long-dream-en', stockholm(2026, 6, 2, 23));
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index 224f6f4..6e94b4a 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -1,8 +1,8 @@
 // A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8; head's message 20,
 // items 10 to 12): header, "Dreams", the dreams; editing through the
 // typing screen; Add dreams and Start Interpretation at the foot; the menu,
-// a bordered pill opening the phone's menu, holding only delete, spoken as
-// MP·39; one confirmation, Cancel first, Delete destructive; deleting
+// a bordered pill opening the phone's menu, holding delete, spoken as
+// MP·39, and above it the item an entry point gives (D107 item 1); one confirmation, Cancel first, Delete destructive; deleting
 // leaves nothing.
 import 'dart:async';
 import 'dart:typed_data';
@@ -15,6 +15,7 @@ import 'package:souldreams/design/stand_ins.dart';
 import 'package:souldreams/design/tokens.g.dart';
 import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/night_action.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
@@ -60,7 +61,7 @@ void main() {
   late Harness h;
   late Night n;
 
-  Future<void> open(WidgetTester tester, {UnsteadyFiles? files, String? name}) async {
+  Future<void> open(WidgetTester tester, {UnsteadyFiles? files, String? name, NightAction? action}) async {
     h = await Harness.make(files: files);
     n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
     if (name != null) {
@@ -76,7 +77,7 @@ void main() {
       );
       await h.store.save(n);
     }
-    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id)));
+    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action)));
     await tester.tap(find.byKey(Opener.openKey));
     await tester.pumpAndSettle();
   }
@@ -280,6 +281,30 @@ void main() {
     handle.dispose();
   });
 
+  // D107 item 1: the entry point's item, above delete, plain, its words given.
+  NightAction given(List<Night> ran) =>
+      NightAction(label: PendingLines.MP_65.text(Lang.en), run: (night) async => ran.add(night));
+
+  testWidgets('a given item shows above delete, plain', (tester) async {
+    await open(tester, action: given([]));
+    await openMenu(tester);
+    final items = tester.widgetList<CupertinoMenuItem>(find.byType(CupertinoMenuItem)).toList();
+    expect([for (final i in items) i.key], [NightPage.actionKey, NightPage.deleteKey]);
+    expect(items.first.isDestructiveAction, isFalse);
+    expect(find.text(PendingLines.MP_65.text(Lang.en)), findsOneWidget);
+  });
+
+  testWidgets('a given item runs once, with the night shown', (tester) async {
+    final ran = <Night>[];
+    await open(tester, action: given(ran));
+    await openMenu(tester);
+    await tester.tap(find.byKey(NightPage.actionKey));
+    await tester.pumpAndSettle();
+    expect(ran, [n]);
+    expect(find.byType(NightPage), findsOneWidget);
+    expect(await h.nights(), [n]);
+  });
+
   testWidgets('one confirmation: Cancel first keeps the night', (tester) async {
     await open(tester);
     await openMenu(tester);
~~~~

### Task 3 · The export's text and name (D107 item 2)

`lib/founder/export_text.dart`: the text (name, date, dreams told, a blank line between; a waiting recording left
out), its UTF-8 bytes, and the name `YYYY-MM-DD.txt`. Tests: `test/founder/export_text_test.dart` (5), from the
invented nights.

Expected: 489 app tests. Commit:

> The founder's export: its text and its name (D107, D108)

**The block:**

~~~~diff
diff --git a/app/lib/founder/export_text.dart b/app/lib/founder/export_text.dart
new file mode 100644
index 0000000..41726f4
--- /dev/null
+++ b/app/lib/founder/export_text.dart
@@ -0,0 +1,29 @@
+// The founder's export (C142-I item 3; D107; D108): what the file holds.
+// No document rules a format, so D107 item 2's: plain text, UTF-8, with
+// the night's date as its page shows it (its name above, if it has one),
+// then each dream told in words, in order, a blank line between. No label
+// or number is added (R1). A recording still waiting has no words and is
+// left out (D108). The file's name is the night's date in digits only.
+import 'dart:convert';
+import 'dart:typed_data';
+
+import '../journal/night.dart';
+import '../journal/row_text.dart';
+
+const _line = '\n';
+
+/// The file's text.
+String exportText(Night night) {
+  final head = [?night.name, dayDigits(night.date)].join(_line);
+  return [head, ...night.dreams].join(_line + _line) + _line;
+}
+
+/// The file's bytes: the text in UTF-8.
+Uint8List exportBytes(Night night) => utf8.encode(exportText(night));
+
+/// The file's name: the night's date, `YYYY-MM-DD.txt`.
+String exportFileName(Night night) {
+  final d = night.date;
+  String two(int n) => n.toString().padLeft(2, '0');
+  return '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}.txt';
+}
diff --git a/app/test/founder/export_text_test.dart b/app/test/founder/export_text_test.dart
new file mode 100644
index 0000000..f9fbbf6
--- /dev/null
+++ b/app/test/founder/export_text_test.dart
@@ -0,0 +1,55 @@
+// The founder's export, its text and name (D107 item 2; D108), from the
+// invented nights only (R2).
+import 'dart:convert';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/founder/export_text.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/journal/row_text.dart';
+
+import '../fixtures.dart';
+
+Night _night(String key) => nightsFromFixtures().singleWhere((n) => n.dreams.first == invented(key).dreams.first);
+
+void main() {
+  test('the date, then each dream in order, a blank line between', () {
+    final n = _night('two-dreams-en');
+    expect(exportText(n), '${dayDigits(n.date)}\n\n${n.dreams[0]}\n\n${n.dreams[1]}\n');
+  });
+
+  test('a named night: the name above the date', () {
+    final n = _night('named-three-dreams-sv');
+    expect(n.name, isNotNull);
+    expect(
+      exportText(n),
+      '${n.name}\n${dayDigits(n.date)}\n\n${n.dreams[0]}\n\n${n.dreams[1]}\n\n${n.dreams[2]}\n',
+    );
+  });
+
+  test('a waiting recording is left out; the others keep their order', () {
+    final n = _night('named-three-dreams-sv');
+    final mixed = n.withEntries([Told(n.dreams[0]), Waiting('0' * 32), Told(n.dreams[2])]);
+    expect(exportText(mixed), '${n.name}\n${dayDigits(n.date)}\n\n${n.dreams[0]}\n\n${n.dreams[2]}\n');
+  });
+
+  test('the bytes are the text in UTF-8, Swedish letters whole', () {
+    final n = _night('one-dream-sv');
+    expect(utf8.decode(exportBytes(n)), exportText(n));
+    // Å, ä and ö take two bytes each: the text has some.
+    expect(exportBytes(n).length, greaterThan(exportText(n).length));
+  });
+
+  test("the file's name: the night's date in digits, padded", () {
+    final n = _night('two-dreams-en');
+    final march = Night(
+      id: n.id,
+      firstRecorded: n.firstRecorded,
+      date: (year: 2026, month: 3, day: 7),
+      closes: n.closes,
+      lang: n.lang,
+      dreams: n.dreams,
+    );
+    expect(exportFileName(march), '2026-03-07.txt');
+    expect(exportFileName(n), matches(RegExp(r'^\d{4}-\d{2}-\d{2}\.txt$')));
+  });
+}
~~~~

### Task 4 · The export's Dart side: MP·65 and one message (D108)

`lib/founder/founder_export.dart`: `FounderExport`, its `action` labelled MP·65, and `share`, which sends the file's
name and bytes on `souldreams/founder_export` and logs `exportFailed` on any failure (`LogEvent.exportFailed`).
Tests: `test/founder/founder_export_test.dart` (5).

Expected: 494 app tests. Commit:

> The founder's export: MP·65, one message to the phone, a failure a code (D108)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index 9162259..e7f142d 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -81,6 +81,10 @@ enum LogEvent {
   /// milliseconds recorded.
   recordingSettled,
 
+  /// The founder's export (D108): the phone could not write the file or
+  /// open the share; nothing is shown.
+  exportFailed,
+
   /// A waiting recording replayed to Soniox (D94): begun; all of it in
   /// words; cut short, its progress kept (with the bytes of audio now in
   /// words and the milliseconds Soniox said it had made final); failed (Soniox's code, our
diff --git a/app/lib/founder/founder_export.dart b/app/lib/founder/founder_export.dart
new file mode 100644
index 0000000..4691e71
--- /dev/null
+++ b/app/lib/founder/founder_export.dart
@@ -0,0 +1,36 @@
+// The founder's export (C142-I item 3; C153-I item 3; D107; D108): one
+// night at a time, from its "⋯" menu, labelled MP·65 (a pending line). The
+// file's name and bytes go to the phone's own share, through our channel
+// in AppDelegate.swift, which is compiled into SoulDreams Dev and the
+// founder's app only: it writes the file, hands it to AirDrop alone (every
+// other target receives nothing), and deletes it when the share closes.
+// Nothing goes through a server or any service (R8). A failure shows
+// nothing and logs a code (D108; R3).
+import 'package:flutter/services.dart';
+
+import '../core/language.dart';
+import '../core/safe_log.dart';
+import '../journal/night.dart';
+import '../journal/night_action.dart';
+import '../words/pending.g.dart';
+import 'export_text.dart';
+
+final class FounderExport {
+  const FounderExport({this.channel = const MethodChannel(channelName)});
+
+  static const channelName = 'souldreams/founder_export';
+
+  final MethodChannel channel;
+
+  /// The night's menu item.
+  NightAction get action => NightAction(label: PendingLines.MP_65.text(appLanguage), run: share);
+
+  /// Shares [night]'s file; answers when the share has closed.
+  Future<void> share(Night night) async {
+    try {
+      await channel.invokeMethod<void>('share', {'name': exportFileName(night), 'bytes': exportBytes(night)});
+    } on Object {
+      SafeLog.event(LogEvent.exportFailed);
+    }
+  }
+}
diff --git a/app/test/founder/founder_export_test.dart b/app/test/founder/founder_export_test.dart
new file mode 100644
index 0000000..0711c67
--- /dev/null
+++ b/app/test/founder/founder_export_test.dart
@@ -0,0 +1,66 @@
+// The founder's export, its Dart side (D107; D108): MP·65 its label, the
+// file's name and bytes its only message, a failure a code and nothing
+// else. The phone's side is in native_test.dart and the owner's check.
+import 'package:flutter/services.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/founder/export_text.dart';
+import 'package:souldreams/founder/founder_export.dart';
+import 'package:souldreams/words/lines.g.dart' show Lang;
+import 'package:souldreams/words/pending.g.dart';
+
+import '../fixtures.dart';
+
+void main() {
+  TestWidgetsFlutterBinding.ensureInitialized();
+  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
+  const channel = MethodChannel(FounderExport.channelName);
+  final night = nightsFromFixtures().first;
+  late List<String> lines;
+
+  setUp(() {
+    lines = [];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
+  });
+
+  test('its label is MP·65, a pending line', () {
+    expect(const FounderExport().action.label, PendingLines.MP_65.text(Lang.en));
+  });
+
+  test('the action shares the night it is given', () async {
+    final calls = <MethodCall>[];
+    messenger.setMockMethodCallHandler(channel, (call) async => calls.add(call));
+    await const FounderExport().action.run(night);
+    expect([for (final c in calls) (c.arguments as Map<Object?, Object?>)['bytes']], [exportBytes(night)]);
+  });
+
+  test("one message: the file's name and bytes, nothing else", () async {
+    final calls = <MethodCall>[];
+    messenger.setMockMethodCallHandler(channel, (call) async {
+      calls.add(call);
+      return null;
+    });
+    await const FounderExport().share(night);
+    expect(calls.single.method, 'share');
+    final args = calls.single.arguments as Map<Object?, Object?>;
+    expect(args.keys.toSet(), {'name', 'bytes'});
+    expect(args['name'], exportFileName(night));
+    expect(args['bytes'], isA<Uint8List>());
+    expect(args['bytes'], exportBytes(night));
+    expect(lines, isEmpty);
+  });
+
+  test('a refused share logs a code and nothing else', () async {
+    messenger.setMockMethodCallHandler(channel, (call) async => throw PlatformException(code: 'export'));
+    await const FounderExport().share(night);
+    expect(lines, ['exportFailed']);
+  });
+
+  test('no channel at all logs the same code', () async {
+    await const FounderExport().share(night);
+    expect(lines, ['exportFailed']);
+  });
+}
~~~~

### Task 5 · The phone's side, compiled into dev and founder only (D107 items 3 and 4; D108)

`AppDelegate.swift`: `FounderExport` and `OnlyAirDrop`, all inside `#if SOULDREAMS_EXPORT`; the sweep at launch;
the channel registered. `dev.xcconfig` and `founder.xcconfig` set the condition (D108's approval); `tester.xcconfig`
is unchanged. Tests: `test/founder/native_test.dart` (7), reading the source. The Swift is not compiled by
`flutter test`; the owner's Task 9 builds it.

Expected: 501 app tests. Commit:

> The founder's export on the phone: AirDrop alone, the file deleted after; compiled into dev and founder only (D108)

**The block:**

~~~~diff
diff --git a/app/ios/Flutter/dev.xcconfig b/app/ios/Flutter/dev.xcconfig
index ad260b4..f7fdca1 100644
--- a/app/ios/Flutter/dev.xcconfig
+++ b/app/ios/Flutter/dev.xcconfig
@@ -10,6 +10,8 @@ PRODUCT_BUNDLE_IDENTIFIER = app.souldreams.dev
 APP_DISPLAY_NAME = SoulDreams Dev
 FLUTTER_TARGET = lib/main_dev.dart
 FLAVOR = dev
+// The founder's export, compiled in (D108; R8): dev and founder only.
+SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) SOULDREAMS_EXPORT
 // The owner's Team ID, in an untracked file (D20 Q9a). Only this flavour
 // is ever signed under the Personal Team (D20 Q10).
 #include? "Signing.xcconfig"
diff --git a/app/ios/Flutter/founder.xcconfig b/app/ios/Flutter/founder.xcconfig
index a47889b..fbb6521 100644
--- a/app/ios/Flutter/founder.xcconfig
+++ b/app/ios/Flutter/founder.xcconfig
@@ -8,3 +8,5 @@ PRODUCT_BUNDLE_IDENTIFIER = app.souldreams.founder
 APP_DISPLAY_NAME = $(WORDS_APP_NAME)
 FLUTTER_TARGET = lib/main_founder.dart
 FLAVOR = founder
+// The founder's export, compiled in (D108; R8): dev and founder only.
+SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) SOULDREAMS_EXPORT
diff --git a/app/ios/Runner/AppDelegate.swift b/app/ios/Runner/AppDelegate.swift
index f9834d7..89b6380 100644
--- a/app/ios/Runner/AppDelegate.swift
+++ b/app/ios/Runner/AppDelegate.swift
@@ -9,11 +9,18 @@ import UIKit
   private var audioChannel: FlutterMethodChannel?
   private var networkChannel: FlutterEventChannel?
   private let networkWatch = NetworkWatch()
+  #if SOULDREAMS_EXPORT
+    private var exportChannel: FlutterMethodChannel?
+  #endif
 
   override func application(
     _ application: UIApplication,
     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
   ) -> Bool {
+    #if SOULDREAMS_EXPORT
+      // A file left by a share the app did not see close (D108).
+      FounderExport.sweep()
+    #endif
     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
   }
 
@@ -40,9 +47,131 @@ import UIKit
       channel.setStreamHandler(networkWatch)
       networkChannel = channel
     }
+    #if SOULDREAMS_EXPORT
+      if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FounderExport") {
+        exportChannel = FounderExport.channel(messenger: registrar.messenger())
+      }
+    #endif
   }
 }
 
+#if SOULDREAMS_EXPORT
+  // The founder's export (C142-I item 3; D107; D108), compiled only where
+  // SOULDREAMS_EXPORT is set: dev.xcconfig and founder.xcconfig, never
+  // tester.xcconfig (R8; native_test.dart). One night's file, written to
+  // tmp/Export with complete protection, handed to the phone's share with
+  // every type Apple names excluded but AirDrop, and the people row too on
+  // iOS 18 and later. Other targets cannot be removed, so the file is given
+  // to AirDrop alone: any other target receives nothing (OnlyAirDrop). The
+  // file is deleted when the share closes, sent or not, and the folder is
+  // emptied before each share and at launch. tmp is never backed up (R11).
+  // A failure answers with a code only (R3).
+  enum FounderExport {
+    static let channelName = "souldreams/founder_export"
+    private static var sharing = false
+
+    enum Failure: Error { case arguments, busy, presenter }
+
+    // Every activity type Apple names, but AirDrop (UIActivity.h), each
+    // from the iOS that has it.
+    static var excluded: [UIActivity.ActivityType] {
+      var types: [UIActivity.ActivityType] = [
+        .postToFacebook, .postToTwitter, .postToWeibo, .message, .mail, .print, .copyToPasteboard,
+        .assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo,
+        .postToTencentWeibo, .openInIBooks, .markupAsPDF,
+      ]
+      if #available(iOS 15.4, *) { types.append(.sharePlay) }
+      if #available(iOS 16.0, *) { types += [.collaborationInviteWithLink, .collaborationCopyLink] }
+      if #available(iOS 16.4, *) { types.append(.addToHomeScreen) }
+      return types
+    }
+
+    static func folder() -> URL {
+      return FileManager.default.temporaryDirectory.appendingPathComponent("Export", isDirectory: true)
+    }
+
+    static func sweep() {
+      try? FileManager.default.removeItem(at: folder())
+    }
+
+    static func channel(messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
+      let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
+      channel.setMethodCallHandler { call, result in
+        guard call.method == "share" else {
+          result(FlutterMethodNotImplemented)
+          return
+        }
+        do {
+          try share(call, result)
+        } catch {
+          if !sharing { sweep() }
+          result(FlutterError(code: "export", message: nil, details: nil))
+        }
+      }
+      return channel
+    }
+
+    // The file's name is the night's date in digits (export_text.dart).
+    static func valid(_ name: String) -> Bool {
+      return name.range(of: "^[0-9]{4}-[0-9]{2}-[0-9]{2}[.]txt$", options: .regularExpression) != nil
+    }
+
+    static func presenter() -> UIViewController? {
+      let windows = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }
+      var top = windows.first { $0.isKeyWindow }?.rootViewController
+      while let next = top?.presentedViewController { top = next }
+      return top
+    }
+
+    static func share(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) throws {
+      guard !sharing else { throw Failure.busy }
+      guard let a = call.arguments as? [String: Any], let name = a["name"] as? String, valid(name),
+        let bytes = a["bytes"] as? FlutterStandardTypedData
+      else { throw Failure.arguments }
+      guard let top = presenter() else { throw Failure.presenter }
+      sweep()
+      let fm = FileManager.default
+      let complete: [FileAttributeKey: Any] = [.protectionKey: FileProtectionType.complete]
+      try fm.createDirectory(at: folder(), withIntermediateDirectories: true, attributes: complete)
+      let url = folder().appendingPathComponent(name, isDirectory: false)
+      try bytes.data.write(to: url, options: [.completeFileProtection])
+      let sheet = UIActivityViewController(activityItems: [OnlyAirDrop(url)], applicationActivities: nil)
+      sheet.excludedActivityTypes = excluded
+      if #available(iOS 18.0, *) { sheet.excludedActivitySectionTypes = .peopleSuggestions }
+      sharing = true
+      sheet.completionWithItemsHandler = { _, _, _, _ in
+        guard sharing else { return }
+        sharing = false
+        sweep()
+        result(nil)
+      }
+      top.present(sheet, animated: true)
+    }
+  }
+
+  // The file, given to AirDrop alone: for any other activity the share
+  // asks for the item and gets nothing ("you can return nil",
+  // UIActivityItemProvider.h).
+  final class OnlyAirDrop: NSObject, UIActivityItemSource {
+    let url: URL
+
+    init(_ url: URL) {
+      self.url = url
+    }
+
+    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
+      return url
+    }
+
+    func activityViewController(
+      _ activityViewController: UIActivityViewController,
+      itemForActivityType activityType: UIActivity.ActivityType?
+    ) -> Any? {
+      return activityType == .airDrop ? url : nil
+    }
+  }
+#endif
+
 // Whether the phone has a connection, as the phone knows it (D92 item 3;
 // D93 Q4): Apple's path monitor, one true or false at each change, on the
 // main thread. It sends nothing anywhere (R10). Reached from SoulDreams Dev
diff --git a/app/test/founder/native_test.dart b/app/test/founder/native_test.dart
new file mode 100644
index 0000000..d43d4a0
--- /dev/null
+++ b/app/test/founder/native_test.dart
@@ -0,0 +1,105 @@
+// The founder's export, the phone's side (D107; D108; R8), read from the
+// source, since `flutter test` runs no Swift: every line of it compiled
+// only under SOULDREAMS_EXPORT, which dev.xcconfig and founder.xcconfig set
+// and tester.xcconfig never does; the file given to AirDrop alone; every
+// type Apple names excluded but AirDrop; the file deleted when the share
+// closes and swept at launch. A floor: the owner's checks prove the rest
+// (the tester app's binary holds none of it; each other target opens
+// empty). `flutter test` runs in app/.
+import 'dart:io';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/founder/founder_export.dart';
+
+const _swift = 'ios/Runner/AppDelegate.swift';
+const _condition = 'SOULDREAMS_EXPORT';
+const _setting = 'SWIFT_ACTIVE_COMPILATION_CONDITIONS = \$(inherited) $_condition';
+
+String _read(String path) => File(path).readAsStringSync();
+
+// The text between [from] and the first [to] after it.
+String _between(String text, String from, String to) {
+  final start = text.indexOf(from);
+  expect(start, isNot(-1), reason: from);
+  final end = text.indexOf(to, start);
+  expect(end, isNot(-1), reason: to);
+  return text.substring(start, end);
+}
+
+void main() {
+  final swift = _read(_swift);
+
+  test('every line of the export is inside #if $_condition', () {
+    const marks = ['FounderExport', 'founder_export', 'OnlyAirDrop', 'exportChannel', 'UIActivity', 'airDrop'];
+    var inside = false;
+    var blocks = 0;
+    final outside = <int>[];
+    final lines = swift.split('\n');
+    for (var i = 0; i < lines.length; i++) {
+      final t = lines[i].trim();
+      if (t.startsWith('#if')) {
+        expect(t, '#if $_condition', reason: 'line ${i + 1}');
+        expect(inside, isFalse, reason: 'line ${i + 1}');
+        inside = true;
+        blocks++;
+      } else if (t == '#endif') {
+        inside = false;
+      } else if (!inside && marks.any(lines[i].contains)) {
+        outside.add(i + 1);
+      }
+    }
+    expect(inside, isFalse);
+    expect(outside, isEmpty);
+    expect(blocks, 4);
+  });
+
+  test('the condition: dev and founder set it, tester never', () {
+    for (final flavour in ['dev', 'founder']) {
+      expect(_read('ios/Flutter/$flavour.xcconfig').split('\n'), contains(_setting), reason: flavour);
+    }
+    for (final other in ['tester', 'Debug', 'Release']) {
+      expect(_read('ios/Flutter/$other.xcconfig'), isNot(contains(_condition)), reason: other);
+    }
+  });
+
+  test("the channel's name is the same on both sides", () {
+    expect(swift, contains('static let channelName = "${FounderExport.channelName}"'));
+  });
+
+  test('the file is given to AirDrop alone', () {
+    expect(swift, contains('activityItems: [OnlyAirDrop(url)]'));
+    final item = _between(swift, 'itemForActivityType activityType', '#endif');
+    expect(item, contains('return activityType == .airDrop ? url : nil'));
+    expect(RegExp(r'\breturn\b').allMatches(item), hasLength(1));
+  });
+
+  test('every type Apple names is excluded, but AirDrop', () {
+    // UIActivity.h, iOS 26.5 SDK: every UIActivityType constant.
+    const named = [
+      'postToFacebook', 'postToTwitter', 'postToWeibo', 'message', 'mail', 'print', 'copyToPasteboard',
+      'assignToContact', 'saveToCameraRoll', 'addToReadingList', 'postToFlickr', 'postToVimeo',
+      'postToTencentWeibo', 'openInIBooks', 'markupAsPDF', 'sharePlay', 'collaborationInviteWithLink',
+      'collaborationCopyLink', 'addToHomeScreen',
+    ];
+    final excluded = _between(swift, 'static var excluded', 'return types');
+    final listed = RegExp(r'(?<=[\s\[,(])\.([a-zA-Z]+)').allMatches(excluded).map((m) => m[1]!).toSet();
+    expect(listed, named.toSet());
+    expect(swift, contains('sheet.excludedActivityTypes = excluded'));
+    expect(swift, contains('sheet.excludedActivitySectionTypes = .peopleSuggestions'));
+  });
+
+  test('the file goes when the share closes, and at launch', () {
+    final closed = _between(swift, 'sheet.completionWithItemsHandler', 'top.present');
+    expect(closed, contains('sweep()'));
+    final launch = _between(swift, 'didFinishLaunchingWithOptions launchOptions', 'return super.application');
+    expect(launch, contains('FounderExport.sweep()'));
+    expect(_between(swift, 'static func share(', 'let sheet'), contains('sweep()'));
+  });
+
+  test('the file is written with complete protection, in tmp', () {
+    final share = _between(swift, 'static func share(', 'let sheet');
+    expect(share, contains('bytes.data.write(to: url, options: [.completeFileProtection])'));
+    expect(share, contains('attributes: complete'));
+    expect(swift, contains('FileManager.default.temporaryDirectory.appendingPathComponent("Export"'));
+  });
+}
~~~~

### Task 6 · SoulDreams Dev gives each night the export (R8)

`main_dev.dart` gives `FounderExport().action` to `JournalHome`. `dev_only_test.dart`: `main.dart` and
`main_founder.dart` reach nothing in `lib/founder/`; Dev reaches it; nothing in `lib/journal/` does (1 new test).
`journal_home_test.dart`'s source test follows `main_dev.dart`.

Expected: 502 app tests. Commit:

> SoulDreams Dev: each night's menu holds the founder's export; the tester and founder apps reach none of it (R8)

**The block:**

~~~~diff
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
index 7a7e298..0c59c04 100644
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -1,6 +1,7 @@
 // SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
 // nights only. It opens on onboarding until the dreamer agrees, then on the
-// journal (D49 O1; D56; D103).
+// journal (D49 O1; D56; D103). Each night's menu holds the founder's export
+// (D107; D108; R8 lets this file and main_founder.dart import it).
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -9,6 +10,7 @@ import 'app.dart';
 import 'core/flavour.dart';
 import 'core/keyboard_check.dart';
 import 'core/safe_log.dart';
+import 'founder/founder_export.dart';
 import 'journal/channel_journal_files.dart';
 import 'journal/pages/journal_home.dart';
 import 'journal/self_check.dart';
@@ -38,7 +40,7 @@ void main() {
     SoulDreamsApp(
       home: const bool.fromEnvironment('KEYBOARD_CHECK')
           ? const KeyboardCheck()
-          : JournalHome(files: files, after: check, recording: recording),
+          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action),
     ),
   );
   if (check != null) unawaited(check);
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
index ae70a90..18c9177 100644
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -60,9 +60,12 @@ void main() {
   const pending = 'lib/words/pending.g.dart';
 
   for (final entry in ['lib/main.dart', 'lib/main_founder.dart']) {
+    // Nor the founder's export (R8): the founder's app gains it with its
+    // journal, by a later ruling (D108); the testers' app never.
     test('$entry reaches no journal, onboarding or recording code, no pending line', () {
       final files = reached(entry);
       expect(files, contains('lib/app.dart'));
+      expect(files.where((f) => f.startsWith('lib/founder/')), isEmpty);
       expect(files.where((f) => f.startsWith('lib/journal/')), isEmpty);
       expect(files.where((f) => f.startsWith('lib/recording/')), isEmpty);
       expect(files.where((f) => f.startsWith('lib/onboarding/')), isEmpty);
@@ -77,6 +80,20 @@ void main() {
     expect(files, contains(pending));
     expect(files, contains('lib/recording/record_microphone.dart'));
     expect(files, containsAll(['lib/onboarding/onboarding.dart', 'lib/onboarding/disclosure_page.dart']));
+    expect(files, containsAll(['lib/founder/founder_export.dart', 'lib/founder/export_text.dart']));
+  });
+
+  // R8, D108: the journal's pages, which testers will get, carry only the
+  // hook; nothing in lib/journal/ reaches the export.
+  test('nothing in lib/journal/ reaches lib/founder/', () {
+    final journal = [
+      for (final f in Directory('lib/journal').listSync(recursive: true))
+        if (f is File && f.path.endsWith('.dart')) f.path,
+    ];
+    expect(journal, contains('lib/journal/pages/night_page.dart'));
+    for (final f in journal) {
+      expect(reached(f).where((r) => r.startsWith('lib/founder/')), isEmpty, reason: f);
+    }
   });
 
   // D106 3: no tester or founder build shows onboarding or the full disclosure
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index b7a4aad..0c1f886 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -201,7 +201,11 @@ void main() {
 
   test('SoulDreams Dev hands its phone check and recording to the list', () {
     final text = File('lib/main_dev.dart').readAsStringSync();
-    expect(text, contains('JournalHome(files: files, after: check, recording: recording)'));
+    // With each night's export (D108).
+    expect(
+      text,
+      contains('JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action)'),
+    );
     expect(text, contains("betaKey: const String.fromEnvironment('BETA_KEY')"));
   });
 
~~~~

### Task 7 · The mutation rows A320 to A343

24 new rows; A24ap follows the code (D67). Run, from the repository root (D95):

```
python3 -I -B tool/app_mutations.py --rows A24ap,A24an,A39,A66,A305,A320,A321,A322,A323,A324,A325,A326,A327,A328,A329,A330,A331,A332,A333,A334,A335,A336,A337,A338,A339,A340,A341,A342,A343
```

Expected: `app mutations: 29 run, 29 caught`. Commit:

> Mutation rows A320 to A343 for the founder's export; A24ap follows the code (D67)

**The block:**

~~~~diff
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 19333b9..f2a0136 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A319, A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A343, A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 348 run, 348 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 372 run, 372 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -328,8 +328,8 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'the list waits for the phone check, then shows'),
     ('A24ap', 'lib/main_dev.dart',
-     'JournalHome(files: files, after: check, recording: recording)',
-     'JournalHome(files: files, recording: recording)',
+     'JournalHome(files: files, after: check, recording: recording, nightAction',
+     'JournalHome(files: files, recording: recording, nightAction',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A24aq', 'lib/journal/pages/journal_home.dart',
      '      await widget.after;\n    } on Object {',
@@ -1531,6 +1531,114 @@ ROWS = [
      "import 'core/safe_log.dart';\n",
      "import 'core/safe_log.dart';\nimport 'onboarding/age.dart';\n",
      'test/dev_only_test.dart', 'no tester or founder build while a part lacks a line'),
+    # The founder's export (D107; D108).
+    ('A320', 'lib/journal/pages/night_page.dart',
+     '      if (widget.action case final action?)\n'
+     '        CupertinoMenuItem(\n'
+     '          key: NightPage.actionKey,\n'
+     '          onPressed: _act,\n'
+     '          child: Text(action.label),\n'
+     '        ),\n',
+     '',
+     'test/journal/pages/night_page_test.dart', 'a given item shows above delete, plain'),
+    ('A321', 'lib/journal/pages/night_page.dart',
+     '    await widget.action?.run(night);\n',
+     '',
+     'test/journal/pages/night_page_test.dart', 'a given item runs once, with the night shown'),
+    ('A322', 'lib/journal/pages/journal_page.dart',
+     '                              action: widget.nightAction,\n',
+     '',
+     'test/journal/pages/journal_page_test.dart', "a row hands its night's page the menu's item"),
+    ('A323', 'lib/journal/pages/journal_home.dart',
+     ', nightAction: widget.nightAction)',
+     ')',
+     'test/journal/pages/journal_home_test.dart', "the night's menu item is handed to the journal"),
+    ('A324', 'lib/founder/export_text.dart',
+     '[?night.name, dayDigits(night.date)]',
+     '[dayDigits(night.date)]',
+     'test/founder/export_text_test.dart', 'a named night: the name above the date'),
+    ('A325', 'lib/founder/export_text.dart',
+     '.join(_line + _line)',
+     '.join(_line)',
+     'test/founder/export_text_test.dart', 'the date, then each dream in order, a blank line between'),
+    ('A326', 'lib/founder/export_text.dart',
+     '...night.dreams]',
+     "...night.entries.map((e) => e is Told ? e.text : '')]",
+     'test/founder/export_text_test.dart', 'a waiting recording is left out; the others keep their order'),
+    ('A327', 'lib/founder/export_text.dart',
+     '-${two(d.month)}-',
+     '-${d.month}-',
+     'test/founder/export_text_test.dart', "the file's name: the night's date in digits, padded"),
+    ('A328', 'lib/founder/export_text.dart',
+     'utf8.encode(exportText(night))',
+     'latin1.encode(exportText(night))',
+     'test/founder/export_text_test.dart', 'the bytes are the text in UTF-8, Swedish letters whole'),
+    ('A329', 'lib/founder/founder_export.dart',
+     'PendingLines.MP_65',
+     'PendingLines.MP_64',
+     'test/founder/founder_export_test.dart', 'its label is MP·65, a pending line'),
+    ('A330', 'lib/founder/founder_export.dart',
+     "{'name': exportFileName(night), 'bytes'",
+     "{'bytes'",
+     'test/founder/founder_export_test.dart', "one message: the file's name and bytes, nothing else"),
+    ('A331', 'lib/founder/founder_export.dart',
+     "invokeMethod<void>('share'",
+     "invokeMethod<void>('send'",
+     'test/founder/founder_export_test.dart', "one message: the file's name and bytes, nothing else"),
+    ('A332', 'lib/founder/founder_export.dart',
+     '      SafeLog.event(LogEvent.exportFailed);\n',
+     '',
+     'test/founder/founder_export_test.dart', 'a refused share logs a code and nothing else'),
+    ('A333', 'lib/founder/founder_export.dart',
+     'run: share)',
+     'run: (_) async {})',
+     'test/founder/founder_export_test.dart', 'the action shares the night it is given'),
+    ('A334', 'ios/Runner/AppDelegate.swift',
+     'return activityType == .airDrop ? url : nil',
+     'return url',
+     'test/founder/native_test.dart', 'the file is given to AirDrop alone'),
+    ('A335', 'ios/Runner/AppDelegate.swift',
+     ' .copyToPasteboard,',
+     '',
+     'test/founder/native_test.dart', 'every type Apple names is excluded, but AirDrop'),
+    ('A336', 'ios/Runner/AppDelegate.swift',
+     '        sweep()\n        result(nil)\n',
+     '        result(nil)\n',
+     'test/founder/native_test.dart', 'the file goes when the share closes, and at launch'),
+    ('A337', 'ios/Runner/AppDelegate.swift',
+     '    #if SOULDREAMS_EXPORT\n'
+     '      if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FounderExport") {\n'
+     '        exportChannel = FounderExport.channel(messenger: registrar.messenger())\n'
+     '      }\n'
+     '    #endif\n',
+     '    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "FounderExport") {\n'
+     '      exportChannel = FounderExport.channel(messenger: registrar.messenger())\n'
+     '    }\n',
+     'test/founder/native_test.dart', 'every line of the export is inside #if SOULDREAMS_EXPORT'),
+    ('A338', 'ios/Flutter/tester.xcconfig',
+     'FLAVOR = tester\n',
+     'FLAVOR = tester\nSWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) SOULDREAMS_EXPORT\n',
+     'test/founder/native_test.dart', 'the condition: dev and founder set it, tester never'),
+    ('A339', 'ios/Flutter/founder.xcconfig',
+     'SWIFT_ACTIVE_COMPILATION_CONDITIONS = $(inherited) SOULDREAMS_EXPORT\n',
+     '',
+     'test/founder/native_test.dart', 'the condition: dev and founder set it, tester never'),
+    ('A340', 'ios/Runner/AppDelegate.swift',
+     'try bytes.data.write(to: url, options: [.completeFileProtection])\n      let sheet',
+     'try bytes.data.write(to: url, options: [])\n      let sheet',
+     'test/founder/native_test.dart', 'the file is written with complete protection, in tmp'),
+    ('A341', 'lib/main_dev.dart',
+     ', nightAction: const FounderExport().action)',
+     ')',
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
+    ('A342', 'lib/main.dart',
+     "import 'core/safe_log.dart';\n",
+     "import 'core/safe_log.dart';\nimport 'founder/founder_export.dart';\n",
+     'test/dev_only_test.dart', 'lib/main.dart reaches no journal, onboarding or recording code, no pending line'),
+    ('A343', 'lib/journal/night_action.dart',
+     "import 'night.dart';\n",
+     "import 'night.dart';\nimport '../founder/export_text.dart';\n",
+     'test/dev_only_test.dart', 'nothing in lib/journal/ reaches lib/founder/'),
 ]
 
 
~~~~

### Task 8 · Status.md

Status.md for the branch: the export under "The app", the counts, banked items 124 to 127, MP·65 among the pending
lines, D107 and D108 under "Rulings during founder-export". Replace `<the day of this task>` with the date.

Expected: 502 app tests. Commit:

> Docs: Status.md for the founder's export (D107, D108)

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
index fe0f08d..8fdc1ab 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-19, in branch `founder-export` (the plan written and proven, D107 and D108; nothing implemented yet). `onboarding` is merged into `main` (`ae23e94`). By Claude Code.
+Last updated: <the day of this task>, in branch `founder-export` (the plan's Tasks 1 to 8; the owner's checks, Task 9, next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -19,7 +19,7 @@ text file handed to AirDrop alone and deleted once the share closes. Plan: `docs
 
 ## Road ahead
 
-- `founder-export`: the plan's Tasks 1 to 8, then the owner's checks (Task 9) and the merge.
+- `founder-export`: the owner's checks (the plan's Task 9), then the merge.
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1), once the pending lines are filed
   (and, for the founder app, with his export).
 - The readings: our server's own spending counter comes with them (D69), and response streaming on the function
@@ -170,6 +170,17 @@ text file handed to AirDrop alone and deleted once the share closes. Plan: `docs
   filed. Every step's box is centred between the top and the foot, and scrolls from the top when taller (D106 1), and
   its words appear whole (D106 2). The stand-ins: the box (`Spacing.onboardingBox` inside `color.surface`), the arrow (`StandIns.firstArrow`,
   `arrowGap`); no logo and no drawn signature (none filed).
+- The founder's export (D107, D108; C142-I item 3; `app/lib/founder/`, SoulDreams Dev only in this branch; the founder
+  app gains it with its journal, by a later ruling): each night's "⋯" menu holds MP·65 (a pending line) above delete,
+  given by `main_dev.dart` through `JournalHome`, `JournalPage` and `NightPage` as a `NightAction` (`lib/journal/`
+  holds only the hook, and reaches nothing in `lib/founder/`, a test). The file: plain UTF-8 text, the night's name if
+  it has one, its date as its page shows it, then each dream told in words, in order, a blank line between; a
+  recording still waiting is left out; named `YYYY-MM-DD.txt`. Our Swift channel `souldreams/founder_export` in
+  `AppDelegate.swift`, compiled only under `SOULDREAMS_EXPORT`, which `dev.xcconfig` and `founder.xcconfig` set and
+  `tester.xcconfig` never does: it writes the file to `tmp/Export` with complete protection, opens the phone's share
+  with every type Apple names excluded but AirDrop (and the people row on iOS 18 and later), gives the file to AirDrop
+  alone (any other target receives nothing), and deletes it when the share closes; the folder is also emptied before
+  each share and at launch. A failure shows nothing and logs `exportFailed`. No package.
 - The record button is a circle (Task 15a, the owner's correction, P13): `StandIns.recordWidth` and `recordHeight`
   both 120, the radius half the height; large text shrinks its words, never the circle.
 - The night rules (`app/lib/journal/night_rules.dart`, `journal.dart`): a night stores its closing instant, the
@@ -196,10 +207,10 @@ text file handed to AirDrop alone and deleted once the share closes. Plan: `docs
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 480 tests, and 348 mutation checks (A1 to A319; A55, A73, A80 to A83, A86 to A88, A94, A99,
+- The app's analyzer baseline: `No issues found!`. The app has 502 tests, and 372 mutation checks (A1 to A343; A55, A73, A80 to A83, A86 to A88, A94, A99,
   A128 to A130, A142, A207, A213 and A223 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 348 run, 348 caught`); `check_all.sh` does not call it (D55). During a task only the
+  (expected: `app mutations: 372 run, 372 caught`); `check_all.sh` does not call it (D55). During a task only the
   rows that target the files changed are run, with `--rows A1,A7` or `--files lib/a.dart` (D95).
 
 ## The server
@@ -705,6 +716,17 @@ Banked in onboarding (the plan's decisions; none changes what the dreamer sees b
      is in Night/Day's dark theme, so a dreamer sees a dark blank, then the light onboarding. Whether it should be
      held light, as onboarding is, changes what is seen, so it is asked and not built.
 
+Banked in founder-export (none changes what the dreamer sees beyond D107 and D108):
+
+124. The phone's side of the export is proven from its source (`test/founder/native_test.dart`, which reads
+     `AppDelegate.swift` and the xcconfigs) and by the owner's checks: `flutter test` runs no Swift. Both forms of
+     `AppDelegate.swift` were type-checked with the iOS SDK while the plan was proven.
+125. A share the app never sees close (the app ended while the share shows) leaves its file in `tmp/Export` until the
+     next export or the next launch, which empty the folder, or until iOS clears `tmp`.
+126. The menu item ignores a tap while a delete runs (D64), unreachable: the menu does not open then; no test.
+127. AirDrop cannot be limited to the founder's Mac, nor the share to AirDrop: the other targets stay in the share and
+     receive nothing (D108). That each one opens empty, Apple's own included, is the owner's check (Task 9).
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
@@ -749,6 +771,8 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   owner in Task 9b.
 - MP·63 (the microphone refused) and MP·64 (the stop control's spoken name), head's message 21 (Product message 20),
   founder-approved; built in `offline-recording`.
+- MP·65 (the founder's export, in a night's menu), the founder's (D108); the handle proposed to Product, renamed if
+  it registers another.
 - W27·5's privacy-page text (head's message 16) shares the filed handle W27·5, so it cannot be a pending line under
   it: Product files it, or gives it a new handle (D103 item 3; the plan's question 1). Until then the page shows
   W27·5 as filed at C16-P.
@@ -995,6 +1019,18 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   line shows nothing in its place, not its handle, in Dev; a guard on the pre-Cohort-1 list and a test: no tester or
   founder build while any disclosure part shown lacks a line.
 
+## Rulings during founder-export
+
+- D107 (owner, the brainstorm): (1) one night at a time, from the night's "⋯" menu; (2) the format the documents
+  rule, and as they rule none, plain text with the night's date and each dream in order; (3) AirDrop only, as far as
+  iOS allows, every other target that can be excluded excluded; (4) the file exists only for the share and is deleted
+  at once after (R11); nothing through any server.
+- D108 (founder): AirDrop alone is handed the night, every other target receiving no file (the owner's check); no
+  undocumented hiding by internal identifiers; the owner turns off AirDrop's "Use Cellular Data" and keeps the Mac
+  close. MP·65, "Export night", a pending line, the founder's. A waiting recording is left out; a failed export shows
+  nothing and logs a code; MP·39 unchanged; SoulDreams Dev only in this branch; our own Swift channel, compiled only
+  into the dev and founder apps (the xcconfig change approved).
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C16-P state (`ff3b229`), in commit `ca29414` (Task 6). The ordinal
~~~~

### Task 9 · [OWNER] The checks: by eye in SoulDreams Dev, the AirDrop to the Mac, the binaries

By eye only, in SoulDreams Dev built from this branch, with invented nights only (R2). Any result that differs: stop
and bring it to the Build chat; nothing is fixed on the phone.

**Before:** on the phone, Settings → General → AirDrop: "Use Cellular Data" off (D108). AirDrop on, the Mac near, its
AirDrop set to receive. Type one invented night from `fixtures/invented-nights.json` with two dreams
(`two-dreams-en`), each dream typed or pasted as the fixture has it.

1. **The menu.** Open the night, tap "⋯": "Export night" above the delete item (EM·11's second part), both plain (not red).
2. **The share.** Tap "Export night": the phone's share sheet opens, showing one file. Expected absent: Messages,
   Mail, Copy, Print, Save to Photos (Save Image), Add to Reading List, Assign to Contact, Books, Markup, and on iOS 18
   or later the row of people at the top. AirDrop is there. Write down every other target the sheet shows.
3. **Each other target opens empty.** For each target written down in step 2 (Save to Files, Notes, Reminders, any
   app): tap it, and see that the night's words and file do not arrive (an empty compose, an empty note, nothing
   saved); cancel or close it. Open "Export night" again for the next one. Delete anything a target made.
4. **AirDrop to the Mac.** Tap AirDrop, then the Mac. On the Mac, the file arrives in Downloads named by the night's
   date, `YYYY-MM-DD.txt`. Open it in TextEdit: the date as the night's page shows it, a blank line, the first dream,
   a blank line, the second dream, nothing else. Delete it from the Mac (an invented night; no restricted/ step for
   this check).
5. **Cancel.** Open "Export night" and close the sheet without choosing: back on the night's page, unchanged.
6. **The file is gone.** In Xcode → Window → Devices and Simulators, SoulDreams Dev → Download Container. In the
   container, `AppData/tmp/` holds no `Export` folder, or an empty one.
7. **A named night and a waiting recording** (optional): a night with a recording made offline, still waiting,
   exports without it.
8. **The tester app holds none of it.** From the repository root:

   ```
   cd ~/Developer/soul-dreams-app/app && fvm flutter build ios --flavor tester -t lib/main.dart --release --no-codesign && strings -a build/ios/iphoneos/Runner.app/Runner | grep -c -e founder_export -e OnlyAirDrop
   ```

   Expected: `0`. Then the founder's app, which holds the channel (compiled in, unused until its journal):

   ```
   cd ~/Developer/soul-dreams-app/app && fvm flutter build ios --flavor founder -t lib/main_founder.dart --release --no-codesign && strings -a build/ios/iphoneos/Runner.app/Runner | grep -c -e founder_export -e OnlyAirDrop
   ```

   Expected: a number above `0`. Neither is installed. (`build/` is ignored by git.)
9. **For Product, the founder's verdict:** the item above delete; the label. Keep, or what to change.

## Part 4 · Questions (numbered; a blank is not a yes)

None is open: D107 and D108 settle every question the investigation raised. Recorded, for the head:

1. **For Product:** MP·65 is proposed as the handle for the founder's export (D108); if Product registers another, the
   pending line is renamed then, and the code follows (`PendingLines.MP_65` in `founder_export.dart` and its test).
2. **The documents' assumption** that AirDrop uses no server stays open for the Build worker's reading of Apple's page
   (C4-T item 8; technical-answers); D108 turns off the one route known to leave the devices ("Use Cellular Data").

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/fe/build`, from `git archive` of `ae23e94`, with
   Status.md's correction and the owner's three files (Task 1) laid in; each task's state kept as a snapshot
   (`./.scratch/fe/snaps/t<n>`); each block in Part 3 is `git diff --no-index` between two snapshots.
2. **The counts measured on the build:** app tests 480 (Task 1), 484, 489, 494, 501, 502, 502, 502; `No issues found!`
   at each.
3. **Test first:** Tasks 2, 3 and 4's new tests name `NightAction`, `export_text.dart` and `FounderExport`, so on the
   code before them they fail to load. Task 5's `native_test.dart` was run on Task 4's code: all seven of its tests failed (the
   "every line" test by its count of four blocks). Task 6's `dev_only_test.dart` was run on Task 5's code: "SoulDreams Dev
   reaches the journal pages and the pending lines" failed. Each assertion was then shown to bite by its mutation row
   (item 4).
4. **Mutations on the build** (D95: every row of every file changed, and the rows naming the tests Task 6 widened):
   on the build, `app mutations: 81 run, 80 caught`: A340 found its pattern twice (`JournalFiles` writes the same
   line), so it names the line after it, and its test now reads the share's own function (it could not tell the two
   writes apart); then A340 and A326 (shortened for G4, item 6) `1 run, 1 caught` each. On the replayed tree, the
   new and followed rows: `app mutations: 29 run, 29 caught`.
5. **The Swift, type-checked** with the iOS 26.5 SDK and Flutter 3.47.9's `Flutter.xcframework` (`swiftc -typecheck`,
   iOS 15.0, Swift 5), `AppDelegate.swift` with `SceneDelegate.swift` and the bridging header: with
   `-D SOULDREAMS_EXPORT` and without, both clean, no warning. The first form found four types newer than iOS 15.0
   (`sharePlay`, the two collaboration types, `addToHomeScreen`); they are added under `#available`.
6. **The guards** on each snapshot: G3 first refused the text's interpolated join in `export_text.dart`, rewritten
   with a constant, and G4 a mutation row's replacement of twelve words, shortened; then `guards (walk): all passed` on every snapshot.
7. **Replayed on a fresh copy**, `./.scratch/fe/replay`, from `git archive` of the plan's commit with the owner's three
   files: every block applied with `git apply` in order, and after each the replayed tree against its snapshot: no
   difference. On the replayed tree: `guards (walk): all passed`, `No issues found!`, `+502: All tests passed!`.
8. **Not provable in the sandbox, so the owner's** (Task 9): the share as iOS shows it; each other target opening
   empty; the AirDrop to the Mac; the file gone afterwards; the tester binary without the channel
   (`xcodebuild` cannot run in the sandbox).
9. The guards and their tests, the server and the words' generator are unchanged (241 guard tests, 47 server tests).
10. The scratch copies (`./.scratch/fe/`) are deleted after this plan is committed.

*No matter where you are on your journey, the steps you take are equally important.*
