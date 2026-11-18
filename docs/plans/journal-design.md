# Plan: the journal design pass, and MP·54 at once (journal-design)

Branch `journal-design`, from `main` at `536d916`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5
and 6), under D91 and D95. Written by Claude Code (Opus) on 2026-11-18. The owner's checks are by eye only, with no
DevTools (D99).

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

The journal's three pages get the look the founder drew (his dark-theme screens of 2026-10-29 and their light
versions), as Product ruled it item by item in the head's message 20 (Product message 19), read with every ruling
since. The rows' summary takes the button type in its grey, each row gets a thin chevron at its right, the month
divider is centred, the empty journal's line takes the button type, and the back control becomes a thin chevron in a
round bordered button. A night's page centres its date, puts its "⋯" menu in a bordered pill that opens the phone's
own kind of menu, places the dreamer's bubbles where the Design System says, and gets two buttons at its foot: Add
dreams on the left, Start Interpretation on the right (which, as on the typing screen, does nothing yet). The page
margins become 30 and the rows 12 apart, to try. The theme's five-second change at 21:00 and 08:00 eases in and out.

One thing changes in recording (D100): when the phone says its connection has gone during a recording, MP·54 shows at
once, not only after Stop. The words stop coming, the recording goes on, and its audio is kept to be turned into
words later, exactly as at any other break. MP·54 stays until the next tap of the microphone or until the screen
closes.

One part of item 10 is not built: the floating field on a night's page. What it does, and its words, are a question
for Product (Part 4, Q1); it gets its own task once answered.

### What this branch builds

1. **The row's summary** (item 1): `TypeRoles.button` (Inter 14) in `color.text.summary` (#767676 on the white row;
   in the dark theme `color.text`, on the bubble gradient, as design-system.md §3). The stand-in `StandIns.summary`
   goes: the role is ruled.
2. **The record button** (item 3): already as ruled (a 120 pt circle, MP·11 in white inside it; Task 15a of
   journal-screens). No change.
3. **A chevron at each row's trailing edge** (item 4): a thin chevron drawn in `color.text`, centred on the row's
   height, heard as nothing (the row is what is tapped).
4. **The month divider centred** (item 5). The month alone in the current year and month and year before it, and the
   rows' day/month/year with a four-digit year, are already built (`row_text.dart`); one more test pins the year.
5. **The empty journal's line** (item 7): C4-P·5 in the button type, centred.
6. **The back control** (item 9): a thin chevron in a round button of 41, `color.button` (white with a #CCCCCC
   border; in the dark theme its gradient and border), its chevron in the button's text colour; still heard as a
   button named MP·14. On the typing screen and on a night's page.
7. **A night's page** (item 10, without the field): the date, or the name and the date, centred in h2; the "⋯" menu a
   bordered pill (`color.button`) as tall as the back control, top right, opening the phone's pull-down menu
   (`CupertinoMenuAnchor`), still holding only "Delete this" and spoken as MP·39; at the foot, Add dreams (MP·29) left
   and Start Interpretation (EM·1) right, inert (P3, as D71 Q3).
8. **The bubbles** (item 11): the dreamer's bubbles 30 from the screen's left edge and 10 from its right
   (`Spacing.bubbleDreamer`, design-system.md §5), no longer inside the page's margin. The readings' bubbles are not
   built yet; their value (`Spacing.bubbleTradition`) is in the tokens for when they are.
9. **The spacings, TO TRY** (item 12): side margins 30 (`StandIns.pageSide`, was 18), 20 between groups
   (`StandIns.gap`, already 20: before each new turn of the app's, after a section label), 12 between journal rows
   (`StandIns.rowGap`, was 10).
10. **The fade** (item 13): `Curves.easeInOut` over the five seconds (was linear).
11. **D100**: the recording session watches the phone's connection while its stream is open or opening; a loss is a
    break at once (`recordingConnectionLost`): the words not yet final leave the field, MP·54 shows, the recording
    goes on into the phone's keep, and what is not in final words waits to be retried, as built for a break (D92,
    D93 Q4, Q5). MP·54 stays until the next tap or the screen closes, as built (phone check 6).

### What it does not build

- The night's page's floating field with its microphone (Part 4, Q1).
- Item 6 (settings and search, P8), and anything Product has not ruled. Seen in the founder's screens and not ruled,
  so left as built: the "Dreams" label's place (left on our page, centred in the drawing); the menu's own words (the
  phone's text style).
- Item 115 (b) of the last branch: stays as built (D100).

### The decisions, by number

- Head's message 20 (Product message 19), items 1, 3 to 5, 7 and 9 to 13; item 12 TO TRY; item 6 not in scope.
- D100 (founder): MP·54 at once when the phone reports its connection lost during a recording; it stays until the
  next tap or the screen closes.
- D91 (standing): what is decided here and what is asked. D95: during a task, only the rows of the files changed.
- D67 (standing): a mutation row whose code moved follows the code, recorded, not a stop.
- P13: values the Design System leaves unset are named stand-ins, matched by eye to the founder's screenshots.

### Decided under D91 (how to build only)

1. **The phone's standard menu** is Flutter's `CupertinoMenuAnchor` with one `CupertinoMenuItem`: Flutter's own
   rendering of iOS's pull-down menu, in the pinned SDK (3.47.9), no package. A truly native `UIMenu` would need a
   platform view and Swift; not worth it for one item. Its item keeps the phone's text style (the drawing's menu is
   the phone's), and stays plain (Part 4, Q3).
2. **The chevrons are drawn** (a `CustomPainter`, two round-capped strokes), not taken from an icon font: Flutter's
   `CupertinoIcons` need the `cupertino_icons` package (a new dependency, R10), and Material's are not thin.
3. **The stand-ins' new values**, from the founder's screenshots (P13), all in `stand_ins.dart`: the row's chevron 10
   by 18 with a 2 pt line and 16 before it; the back control 41 (Product's figure), its chevron 9 by 16; the menu
   pill 55 wide and as tall as the back control. The chevrons take `color.text` (rows) and the button's text colour
   (back control), as the drawings show.
4. **The summary's three lines** are measured as laid out (a `TextPainter` of three empty lines), not computed: Inter
   14 at 1.4 makes 19.6 pt lines, which the layout rounds, so a short summary would stand 1.2 pt lower than a long one.
5. **A night's page's layout**: the top row (back control and menu) and everything but the bubbles keep the page's
   30 margins; the list scrolls between the top row and the two buttons, which stand at its foot with 20 above and
   below, as on the typing screen. The typing screen's pair of buttons becomes a shared `ButtonRow`, unchanged to the
   eye.
6. **The back control** keeps its tap area the 41 circle itself: WCAG 2.2 AA's target size (24) is met; Apple's 44 is
   a guideline the drawing does not follow.
7. **D100's edges**: the loss is watched from the tap until the session ends, the wait for the last words included
   (a loss during Stop's wait ends it at once with MP·54); a loss while the key or the stream is still coming opens
   no stream, and one that arrives is closed; after a break, a failed key or no connection at the tap (MP·15), a loss
   changes nothing more; the connection coming back during the same recording changes nothing (the retries take the
   rest when the app has a connection); with no keep (not SoulDreams Dev's case), a loss stops the recording as a
   break does (D71). A consequence of D100 as ruled, to watch on the phone: if iOS reports the connection gone for a
   moment while moving between Wi-Fi and mobile data, that cut stands; the recording's rest waits and is retried.
8. **Item 3** (the record button) and item 5's dates are already as ruled: tests only.

### The places this branch uses

MP·11, MP·14, MP·15, MP·27, MP·29, MP·38, MP·39, MP·54, EM·1, EM·11 (its second part), C4-P·5, MP·60 and MP·61
(pending). No new line, and no handle placeholder: the field that would need one waits (Q1).

### The tests (test-first, on the Mac)

Every task adds its tests before its code. Tasks 1 and 2's new tests were seen failing on the code before them;
Tasks 3 to 5's need their task's new names to compile, and each is shown failing by the mutation row that breaks
its code (Part 5). 22 new
tests (410 to 432) and 24 new mutation rows (270 to 294); five rows follow the code (D67): A24ae, A24ah, A61, A68,
A136. The by-eye review on the phone is the owner's (Task 8).

## Part 2 · Settings and packages

None. No new package (the menu is in Flutter's SDK, the chevrons are drawn); no change to settings, the guards,
`tool/checks/`, the words, Swift, the server, AWS or Soniox; no storage change.

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

**Implementation waits for Part 4's answers.** Q2 to Q6 are built here as their leans say; an answer that differs is
an amendment to the task named before it is applied. Q1 gets its own task once answered.

### Task 0 · Baselines

From the repository root, on `journal-design`, with a clean tree:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 && (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- nothing from `git status`;
- the plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+410: All tests passed!`.

Anything else: stop (R14).

### Task 1 · MP·54 at once when the connection goes (D100)

The session watches the phone's connection from the tap until it ends, while its stream is open or opening; a loss
is a break at once, with its own code (`recordingConnectionLost`), through the break's own path (`_cutOff`, shared
with `_broke`). The stream's opening stops if the session was cut meanwhile (no stream asked for; one that arrives is
closed), and a failed key after a cut says nothing more. Tests: `recording_test.dart` (8), `typing_page_test.dart`
(2).

Expected: 420 app tests. Commit:

> Recording: when the phone says the connection has gone, MP·54 shows at once and the recording goes on (D100)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index 8ab15be..437c3c2 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -64,6 +64,10 @@ enum LogEvent {
   /// could not be kept on the phone (D92).
   recordingOffline,
   recordingCapped,
+
+  /// The phone reported its connection gone during a recording whose
+  /// stream was open or opening (D100).
+  recordingConnectionLost,
   audioKeepFailed,
 
   /// A recording that leaves audio waiting, as it ends (D98's diagnostic),
diff --git a/app/lib/recording/recording.dart b/app/lib/recording/recording.dart
index 340e8d5..5e52421 100644
--- a/app/lib/recording/recording.dart
+++ b/app/lib/recording/recording.dart
@@ -13,6 +13,8 @@
 // waits, from Soniox's `final_audio_proc_ms` on, and the words not yet
 // final leave the field, since they come back with the rest (D93 Q4, Q5).
 // Every recording stops itself at ten minutes, as Stop does (D93 Q6).
+// When the phone reports its connection gone while the stream is open or
+// opening, that is a break at once, not only at Stop (D100).
 // Without a keep, or once it fails, a key or a stream that fails stops the
 // recording as a broken stream does, keeping the words shown (D71).
 import 'dart:async';
@@ -200,6 +202,9 @@ final class RecordingSession {
   StreamSubscription<String>? _replies;
   StreamSubscription<Uint8List>? _frames;
   StreamSubscription<void>? _interruptions;
+  // The phone's connection, watched while the stream is open or opening
+  // (D100).
+  StreamSubscription<bool>? _connection;
   // Done when the wait for the last words can end: Soniox finished, the
   // stream went while a stop waits, or the session ended.
   final _finished = Completer<void>();
@@ -298,6 +303,10 @@ final class RecordingSession {
       SafeLog.event(LogEvent.recordingOffline);
       onTrouble(Trouble.offline);
     } else {
+      // The phone says its connection went: a break, now (D100).
+      _connection = _recording.connection?.changes.listen((online) {
+        if (!online) _lost();
+      });
       _opening = _open();
     }
     return true;
@@ -365,15 +374,17 @@ final class RecordingSession {
     } on Object {
       return _brokeOff(LogEvent.recordingKeyFailed, 0);
     }
-    if (_ended) return;
+    // Ended, or cut while the key came (D100): no stream is opened.
+    if (_ended || _cut) return;
     final SonioxLink link;
     try {
       link = await _recording.connect(key);
     } on Object {
       return _brokeOff(LogEvent.recordingStreamFailed, 0);
     }
-    if (_ended) {
-      // The session ended while the stream opened: close it, wait for nothing.
+    if (_ended || _cut) {
+      // The session ended, or was cut (D100), while the stream opened:
+      // close it, wait for nothing.
       _closeQuietly(link);
       return;
     }
@@ -389,7 +400,8 @@ final class RecordingSession {
   // No key or no stream: as a break, holding nothing (D88); with the audio
   // kept, the recording goes on (D92).
   void _brokeOff(LogEvent code, int number) {
-    if (_ended) return;
+    // Already cut (D100): the dreamer was told; nothing more.
+    if (_ended || _cut) return;
     SafeLog.event(code, [number]);
     if (_keeping) {
       _goOn();
@@ -421,11 +433,25 @@ final class RecordingSession {
     }
   }
 
-  // The stream broke off before its end: the words shown stay; with the
-  // audio kept, the recording goes on and the rest waits (D92, D93 Q5).
+  // The stream broke off before its end.
   void _broke(int code) {
     if (_ended || _finished.isCompleted || _cut) return;
     SafeLog.event(LogEvent.recordingStreamFailed, [code]);
+    _cutOff();
+  }
+
+  // The phone reports no connection while the stream is open or opening
+  // (D100): the same as a break, at once.
+  void _lost() {
+    if (_ended || _finished.isCompleted || _cut) return;
+    SafeLog.event(LogEvent.recordingConnectionLost);
+    _cutOff();
+  }
+
+  // The stream is gone: the words shown stay; with the audio kept, the
+  // recording goes on and the rest waits (D92, D93 Q5); without, it stops
+  // as a broken stream does (D71).
+  void _cutOff() {
     if (!_keeping) {
       unawaited(_shut());
       return;
@@ -510,6 +536,9 @@ final class RecordingSession {
     _ended = true;
     if (!_finished.isCompleted) _finished.complete();
     _held.clear();
+    // Watched until the end, the wait for the last words included (D100).
+    unawaited(_connection?.cancel());
+    _connection = null;
     await _micOff();
     final replies = _replies;
     _replies = null;
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index 8aebbcf..3eeeaed 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -1870,6 +1870,58 @@ void main() {
     expect((await h.nights()).single.entries, [Told(tokens[0].trimLeft()), Waiting(id, 3200)]);
   });
 
+  // D100: the phone reporting its connection gone shows MP·54 at once, not
+  // only at Stop; the words not yet final leave, the recording goes on, and
+  // MP·54 stays until the next tap.
+  testWidgets('the connection lost: MP·54 at once, until the next tap', (tester) async {
+    final v = offline(online: true);
+    final h = await tall(tester, recording: v.recording);
+    await record(tester);
+    await frames(tester, v.mic, 3);
+    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 100));
+    await tester.pump();
+    expect(find.byKey(TypingPage.noticeKey), findsNothing);
+    v.connection.set(false);
+    await tester.pump();
+    await tester.pump();
+    expect(find.bySemanticsLabel(Lines.MP_54.text(Lang.en)), findsOneWidget);
+    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
+    expect(v.mic.running, isTrue);
+    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
+    expect(field.controller!.text, tokens[0].trimLeft());
+    await frames(tester, v.mic, 2);
+    // Stop: it ends at once, and MP·54 stays.
+    await tester.tap(find.byKey(TypingPage.micKey));
+    await tester.pumpAndSettle();
+    expect(find.byKey(TypingPage.levelKey), findsNothing);
+    expect(find.bySemanticsLabel(Lines.MP_54.text(Lang.en)), findsOneWidget);
+    await tester.pump(const Duration(seconds: 30));
+    expect(find.bySemanticsLabel(Lines.MP_54.text(Lang.en)), findsOneWidget);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    final id = v.keep.audio.keys.single;
+    expect((await h.nights()).single.entries, [Told(tokens[0].trimLeft()), Waiting(id, 3200)]);
+  });
+
+  testWidgets('MP·54 from a lost connection goes at the next tap', (tester) async {
+    final v = offline(online: true);
+    await tall(tester, recording: v.recording);
+    await record(tester);
+    await frames(tester, v.mic, 2);
+    v.connection.set(false);
+    await tester.pump();
+    await tester.pump();
+    await tester.tap(find.byKey(TypingPage.micKey));
+    await tester.pumpAndSettle();
+    expect(find.bySemanticsLabel(Lines.MP_54.text(Lang.en)), findsOneWidget);
+    // The next tap: still offline, so MP·15 now, and MP·54 is gone.
+    await record(tester);
+    expect(find.bySemanticsLabel(Lines.MP_54.text(Lang.en)), findsNothing);
+    expect(find.bySemanticsLabel(Lines.MP_15.text(Lang.en)), findsOneWidget);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+  });
+
   // D96 Q1: a keep that fails once the recording is cut stops it, and the
   // notice that the audio stays on the phone goes.
   testWidgets('keep fails offline: recording stops, the notice goes', (tester) async {
diff --git a/app/test/recording/recording_test.dart b/app/test/recording/recording_test.dart
index 9a45c40..3b43b48 100644
--- a/app/test/recording/recording_test.dart
+++ b/app/test/recording/recording_test.dart
@@ -797,6 +797,226 @@ void main() {
     expect(lines, ['recordingStarted', 'recordingEnded']);
   });
 
+  // D100: the phone reporting its connection gone is a break at once, not
+  // only at Stop: MP·54 now, the words not yet final leave, the recording
+  // goes on into the keep, the stream is closed and sent nothing more.
+  test('the connection lost mid-stream: MP·54 at once, it goes on', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final link = MemoryLink();
+    final connection = FakeConnection();
+    final r = kept(mic, keep, link: link, connection: connection);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 4);
+    link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 200));
+    await pumpEventQueue();
+    connection.set(false);
+    await pumpEventQueue();
+    expect(r.troubles, [Trouble.broke]);
+    expect(r.heard, [(tokens[0], tokens[1]), ('', '')]);
+    expect(mic.running, isTrue);
+    expect(r.ended, isEmpty);
+    expect(link.closed, isTrue);
+    final sent = link.sent.length;
+    await frames(mic, 2, 5);
+    expect(link.sent, hasLength(sent));
+    // The connection coming back changes nothing in this recording.
+    connection.set(true);
+    connection.set(false);
+    await pumpEventQueue();
+    expect(r.troubles, [Trouble.broke]);
+    await r.session.stop();
+    final id = keep.audio.keys.single;
+    expect(keep.audio[id], hasLength(19200));
+    expect(r.session.left, (audio: id, from: 6400));
+    expect(lines, ['recordingStarted', 'recordingConnectionLost', 'recordingSettled 200 600', 'recordingEnded']);
+  });
+
+  test('the connection lost while the stream opens: it never opens', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final connection = FakeConnection();
+    final key = Completer<String>();
+    final link = MemoryLink();
+    final troubles = <Trouble>[];
+    var connects = 0;
+    final session = RecordingSession(
+      Recording(
+        on: true,
+        microphone: mic,
+        key: () => key.future,
+        connect: (_) async {
+          connects++;
+          return link;
+        },
+        keep: keep,
+        connection: connection,
+      ),
+      onHeard: (_, _) {},
+      onLevel: (_) {},
+      onStopping: () {},
+      onEnded: () {},
+      onTrouble: troubles.add,
+      wait: const Duration(milliseconds: 200),
+    );
+    expect(await session.start(), isTrue);
+    await frames(mic, 3);
+    connection.set(false);
+    await pumpEventQueue();
+    expect(troubles, [Trouble.broke]);
+    // The key comes after the cut: no stream is opened, nothing is sent.
+    key.complete('k');
+    await pumpEventQueue();
+    expect(connects, 0);
+    expect(link.sent, isEmpty);
+    await frames(mic, 2, 4);
+    await session.stop();
+    expect(troubles, [Trouble.broke]);
+    expect(session.left, (audio: keep.audio.keys.single, from: 0));
+    expect(lines, ['recordingStarted', 'recordingConnectionLost', 'recordingSettled 0 500', 'recordingEnded']);
+  });
+
+  test('the connection lost while opening: a stream that comes is closed', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final connection = FakeConnection();
+    final opened = Completer<SonioxLink>();
+    final link = MemoryLink();
+    final troubles = <Trouble>[];
+    final session = RecordingSession(
+      Recording(
+        on: true,
+        microphone: mic,
+        key: () async => 'k',
+        connect: (_) => opened.future,
+        keep: keep,
+        connection: connection,
+      ),
+      onHeard: (_, _) {},
+      onLevel: (_) {},
+      onStopping: () {},
+      onEnded: () {},
+      onTrouble: troubles.add,
+      wait: const Duration(milliseconds: 200),
+    );
+    expect(await session.start(), isTrue);
+    await frames(mic, 2);
+    connection.set(false);
+    await pumpEventQueue();
+    opened.complete(link);
+    await pumpEventQueue();
+    expect(link.closed, isTrue);
+    expect(link.sent, isEmpty);
+    expect(troubles, [Trouble.broke]);
+    await session.stop();
+  });
+
+  test('the connection lost after the key failed: told once', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final connection = FakeConnection();
+    final r = kept(mic, keep, connection: connection, key: () async => throw const KeyFailure(502));
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 2);
+    connection.set(false);
+    await pumpEventQueue();
+    expect(r.troubles, [Trouble.broke]);
+    await r.session.stop();
+    expect(lines, ['recordingStarted', 'recordingKeyFailed 502', 'recordingSettled 0 200', 'recordingEnded']);
+  });
+
+  test('the connection lost during a stop: it ends at once, MP·54', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final connection = FakeConnection();
+    final troubles = <Trouble>[];
+    final session = RecordingSession(
+      Recording(
+        on: true,
+        microphone: mic,
+        key: () async => 'k',
+        connect: (_) async => MemoryLink(),
+        keep: keep,
+        connection: connection,
+      ),
+      onHeard: (_, _) {},
+      onLevel: (_) {},
+      onStopping: () {},
+      onEnded: () {},
+      onTrouble: troubles.add,
+      wait: const Duration(seconds: 30),
+    );
+    expect(await session.start(), isTrue);
+    await frames(mic, 3);
+    var done = false;
+    unawaited(session.stop().then((_) => done = true));
+    await pumpEventQueue();
+    expect(done, isFalse);
+    connection.set(false);
+    await pumpEventQueue();
+    expect(done, isTrue);
+    expect(troubles, [Trouble.broke]);
+    expect(session.left, (audio: keep.audio.keys.single, from: 0));
+  });
+
+  test('offline at the tap: a later loss changes nothing', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final connection = FakeConnection()..online = false;
+    final r = kept(mic, keep, connection: connection);
+    expect(await r.session.start(), isTrue);
+    connection.set(true);
+    connection.set(false);
+    await pumpEventQueue();
+    expect(r.troubles, [Trouble.offline]);
+    await r.session.stop();
+    expect(lines, isNot(contains('recordingConnectionLost')));
+  });
+
+  // With no audio kept (D71), a lost connection stops it as a break does.
+  test('no keep: the connection lost stops it, the words kept', () async {
+    final mic = SilentMicrophone();
+    final connection = FakeConnection();
+    final ended = <int>[];
+    final heard = <(String, String)>[];
+    final link = MemoryLink();
+    final session = RecordingSession(
+      Recording(on: true, microphone: mic, key: () async => 'k', connect: (_) async => link, connection: connection),
+      onHeard: (f, p) => heard.add((f, p)),
+      onLevel: (_) {},
+      onStopping: () {},
+      onEnded: () => ended.add(1),
+    );
+    expect(await session.start(), isTrue);
+    await pumpEventQueue();
+    link.reply(reply(done: [tokens[0]]));
+    await pumpEventQueue();
+    connection.set(false);
+    await pumpEventQueue();
+    expect(ended, [1]);
+    expect(mic.running, isFalse);
+    expect(heard, [(tokens[0], '')]);
+    expect(lines, ['recordingStarted', 'recordingConnectionLost', 'recordingEnded']);
+  });
+
+  test('a recording that has ended stops watching the connection', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final connection = FakeConnection();
+    final link = MemoryLink();
+    final r = kept(mic, keep, link: link, connection: connection);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 2);
+    final stopped = r.session.stop();
+    await pumpEventQueue();
+    link.reply(reply(done: [tokens[0]], finalMs: 200, finished: true));
+    await stopped;
+    connection.set(false);
+    await pumpEventQueue();
+    expect(r.troubles, isEmpty);
+    expect(lines, isNot(contains('recordingConnectionLost')));
+  });
+
   test('stop while still opening, in vain: MP·54, all waits', () async {
     final mic = SilentMicrophone();
     final keep = MemoryKeep();
~~~~

### Task 2 · The fade eases in and out (head's message 20, item 13)

`themeAnimationCurve: Curves.easeInOut`. Test: `night_day_test.dart` (1); the existing midpoint check holds, the
curve being symmetric.

Expected: 421 app tests. Commit:

> Night/Day: the five-second fade eases in and out (head's message 20, item 13)

**The block:**

~~~~diff
diff --git a/app/lib/app.dart b/app/lib/app.dart
index f3050c1..c0d5191 100644
--- a/app/lib/app.dart
+++ b/app/lib/app.dart
@@ -29,7 +29,9 @@ class SoulDreamsApp extends StatelessWidget {
         darkTheme: themeFor(Brightness.dark),
         themeMode: mode,
         themeAnimationDuration: fade,
-        themeAnimationCurve: Curves.linear,
+        // A gentle ease-in-out over the five seconds (head's message 20,
+        // item 13).
+        themeAnimationCurve: Curves.easeInOut,
         locale: Locale(appLanguage.name),
         supportedLocales: const [Locale('en'), Locale('sv')],
         localizationsDelegates: GlobalMaterialLocalizations.delegates,
diff --git a/app/lib/core/night_day.dart b/app/lib/core/night_day.dart
index 9a19771..6caa264 100644
--- a/app/lib/core/night_day.dart
+++ b/app/lib/core/night_day.dart
@@ -1,7 +1,8 @@
 // Night/Day mode, Automatic (design-system.md §6; main-path.md, Settings;
 // P14; D56): dark from 21:00, light from 08:00, by the phone's local time
-// now. A change found while the app is open fades over five seconds; with
-// the phone's Reduce Motion on, or animations disabled, it is instant. A
+// now. A change found while the app is open fades over five seconds,
+// easing in and out (head's message 20, item 13); with the phone's Reduce
+// Motion on, or animations disabled, it is instant. A
 // change found at start or on returning to the app is instant (D57 Q15).
 // On iOS, Reduce Motion is its own flag, which MediaQuery does not carry,
 // so it is read from the platform's accessibility features. There is no
diff --git a/app/test/core/night_day_test.dart b/app/test/core/night_day_test.dart
index 1cf0722..1801ee0 100644
--- a/app/test/core/night_day_test.dart
+++ b/app/test/core/night_day_test.dart
@@ -50,6 +50,20 @@ void main() {
     expect(pageOf(tester), light);
   });
 
+  // Head's message 20, item 13: the fade eases in and out.
+  testWidgets('the fade eases in and out', (tester) async {
+    var now = DateTime(2026, 6, 10, 20, 59, 30);
+    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
+    now = DateTime(2026, 6, 10, 21, 0, 30);
+    await tester.pump(NightDay.tick);
+    await tester.pump(const Duration(seconds: 1));
+    expect(pageOf(tester), Color.lerp(light, dark, Curves.easeInOut.transform(0.2)));
+    await tester.pump(const Duration(seconds: 3));
+    expect(pageOf(tester), Color.lerp(light, dark, Curves.easeInOut.transform(0.8)));
+    await tester.pump(const Duration(seconds: 2));
+    expect(pageOf(tester), dark);
+  });
+
   testWidgets('with Reduce Motion the change is instant', (tester) async {
     tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(reduceMotion: true);
     addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
~~~~

### Task 3 · The journal list (head's message 20, items 1, 4, 5, 7, 12)

The summary in the button type and `color.text.summary`, its three lines measured as laid out; a drawn `Chevron`
at each row's trailing edge; the divider centred; C4-P·5 in the button type; `pageSide` 30 and `rowGap` 12 (TO TRY);
`StandIns.summary` removed. Tests: `journal_page_test.dart` (4), `row_text_test.dart` (one more expectation).

Expected: 425 app tests. Commit:

> Journal list: the summary in the button type, a chevron on each row, the divider centred, margins 30 (head's message 20)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index cf7c8cc..b4a594c 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -4,14 +4,18 @@
 // Cohort 0. Every one is listed in docs/plans/journal-screens.md.
 import 'package:flutter/painting.dart';
 
-import 'tokens.g.dart';
-
 abstract final class StandIns {
-  /// The page's side margin.
-  static const double pageSide = 18;
+  /// The page's side margin (about 30, TO TRY: head's message 20, item 12).
+  static const double pageSide = 30;
+
+  /// The space between two journal rows (about 12, TO TRY: item 12).
+  static const double rowGap = 12;
 
-  /// The space between two journal rows.
-  static const double rowGap = 10;
+  /// The chevron at a row's trailing edge (item 4): its size, its line, and
+  /// the space before it.
+  static const rowChevron = Size(10, 18);
+  static const double chevronStroke = 2;
+  static const double chevronGap = 16;
 
   /// Inside a journal row.
   static const rowPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 20);
@@ -51,7 +55,4 @@ abstract final class StandIns {
   /// frames it draws (main-path.md, Recording; D71 Q7).
   static const double levelHeight = 24;
   static const int levelFrames = 48;
-
-  /// A row's summary: the dreamer's words (type role unset).
-  static const summary = TypeRoles.voiceDreamer;
 }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index bbc77e7..767c39c 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -110,7 +110,8 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
               Center(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
-                  child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                  // In the button type, centred (head's message 20, item 7).
+                  child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text)),
                 ),
               ),
             if (nights != null && nights.isNotEmpty)
@@ -146,6 +147,9 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   }
 }
 
+// Three empty lines: the summary's least height, as laid out.
+const _threeLines = '\n\n';
+
 class _Divider extends StatelessWidget {
   const _Divider(this.text);
 
@@ -154,13 +158,19 @@ class _Divider extends StatelessWidget {
   @override
   Widget build(BuildContext context) => Padding(
     padding: const EdgeInsets.only(top: StandIns.dividerAbove, bottom: StandIns.dividerBelow),
-    child: Semantics(header: true, child: Text(text, style: TypeRoles.h4.style(Palette.of(context).text))),
+    // Centred (head's message 20, item 5).
+    child: Semantics(
+      header: true,
+      child: Text(text, textAlign: TextAlign.center, style: TypeRoles.h4.style(Palette.of(context).text)),
+    ),
   );
 }
 
 /// A night's row: an unnamed night's date (h3), or a named night's name
 /// (h5) with its date under it in the button style; then the opening,
-/// always three lines (C10-P; D58 Q7).
+/// always three lines, in the button type in color.text.summary (C10-P;
+/// D58 Q7; head's message 20, item 1); a chevron at its trailing edge
+/// (item 4).
 class _Row extends StatelessWidget {
   const _Row(this.night, {required this.onTap});
 
@@ -170,9 +180,16 @@ class _Row extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     final p = Palette.of(context);
-    final summary = StandIns.summary.style(p.summary);
+    final summary = TypeRoles.button.style(p.summary);
     final name = night.name;
-    final lines = MediaQuery.textScalerOf(context).scale(summary.fontSize!) * summary.height! * 3;
+    // Three lines as laid out, which rounds each line's height.
+    final three = TextPainter(
+      text: TextSpan(text: _threeLines, style: summary),
+      textDirection: TextDirection.ltr,
+      textScaler: MediaQuery.textScalerOf(context),
+    )..layout();
+    final lines = three.height;
+    three.dispose();
     return Padding(
       padding: const EdgeInsets.only(bottom: StandIns.rowGap),
       child: GestureDetector(
@@ -180,20 +197,28 @@ class _Row extends StatelessWidget {
         child: Container(
           decoration: surface(p),
           padding: StandIns.rowPadding,
-          child: Column(
-            crossAxisAlignment: CrossAxisAlignment.start,
+          child: Row(
             children: [
-              if (name == null)
-                Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
-              else ...[
-                Text(name, style: TypeRoles.h5.style(p.text)),
-                Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
-              ],
-              const SizedBox(height: 8),
-              ConstrainedBox(
-                constraints: BoxConstraints(minHeight: lines),
-                child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
+              Expanded(
+                child: Column(
+                  crossAxisAlignment: CrossAxisAlignment.start,
+                  children: [
+                    if (name == null)
+                      Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
+                    else ...[
+                      Text(name, style: TypeRoles.h5.style(p.text)),
+                      Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
+                    ],
+                    const SizedBox(height: 8),
+                    ConstrainedBox(
+                      constraints: BoxConstraints(minHeight: lines),
+                      child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
+                    ),
+                  ],
+                ),
               ),
+              const SizedBox(width: StandIns.chevronGap),
+              Chevron(colour: p.text),
             ],
           ),
         ),
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
index 7847075..da301ae 100644
--- a/app/lib/journal/pages/parts.dart
+++ b/app/lib/journal/pages/parts.dart
@@ -170,6 +170,54 @@ class DreamBubble extends StatelessWidget {
   }
 }
 
+/// A thin chevron, drawn as two strokes, pointing right, or left when
+/// [left] (head's message 20, items 4 and 9). Heard as nothing.
+class Chevron extends StatelessWidget {
+  const Chevron({super.key, required this.colour, this.size = StandIns.rowChevron, this.left = false});
+
+  final Color colour;
+  final Size size;
+  final bool left;
+
+  @override
+  Widget build(BuildContext context) => ExcludeSemantics(
+    child: SizedBox.fromSize(
+      size: size,
+      child: CustomPaint(painter: _ChevronLine(colour, left)),
+    ),
+  );
+}
+
+class _ChevronLine extends CustomPainter {
+  _ChevronLine(this.colour, this.left);
+
+  final Color colour;
+  final bool left;
+
+  @override
+  void paint(Canvas canvas, Size size) {
+    final inset = StandIns.chevronStroke / 2;
+    final back = left ? size.width - inset : inset;
+    final tip = left ? inset : size.width - inset;
+    final path = Path()
+      ..moveTo(back, inset)
+      ..lineTo(tip, size.height / 2)
+      ..lineTo(back, size.height - inset);
+    canvas.drawPath(
+      path,
+      Paint()
+        ..color = colour
+        ..style = PaintingStyle.stroke
+        ..strokeWidth = StandIns.chevronStroke
+        ..strokeCap = StrokeCap.round
+        ..strokeJoin = StrokeJoin.round,
+    );
+  }
+
+  @override
+  bool shouldRepaint(_ChevronLine old) => old.colour != colour || old.left != left;
+}
+
 /// The back control, top left: an arrow whose spoken name is MP·14.
 class BackControl extends StatelessWidget {
   const BackControl({super.key, required this.onPressed});
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index 707a729..3e4013c 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -7,8 +7,11 @@ import 'dart:typed_data';
 
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/core/app_line.dart';
 import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/design/tokens.g.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
@@ -63,6 +66,19 @@ void main() {
     expect(find.byType(TextField), findsNothing);
   });
 
+  // Head's message 20, item 7: the empty journal's line in the button type,
+  // centred.
+  testWidgets("the empty journal's line: the button type, centred", (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final line = tester.widget<AppLine>(find.byType(AppLine));
+    expect(line.style.fontFamily, TypeRoles.button.family);
+    expect(line.style.fontSize, TypeRoles.button.size);
+    expect(line.textAlign, TextAlign.center);
+    final at = tester.getCenter(find.byType(AppLine));
+    expect(at.dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
+  });
+
   testWidgets('rows newest first: the date, then the trimmed opening', (tester) async {
     final h = await Harness.make();
     final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
@@ -90,6 +106,63 @@ void main() {
     expect(monthDivider(2025, 10, 2026, Lang.en), endsWith(' 2025'));
   });
 
+  // Head's message 20, item 5: the divider centred.
+  testWidgets('the month divider is centred', (tester) async {
+    final h = await Harness.make();
+    await keep(h, 'two-dreams-en', stockholm(2026, 5, 4, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final divider = find.text(monthDivider(2026, 5, 2026, Lang.en));
+    expect(tester.widget<Text>(divider).textAlign, TextAlign.center);
+    expect(tester.getCenter(divider).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
+  });
+
+  // Item 1: the summary in the button type, #767676 on the white row; in
+  // the dark theme, color.text on the bubble gradient (design-system.md §3).
+  testWidgets("the summary: the button type, the summary's colour", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final light = tester.widget<Text>(find.text(opening(n)));
+    expect(light.style!.fontFamily, TypeRoles.button.family);
+    expect(light.style!.fontSize, TypeRoles.button.size);
+    expect(light.style!.color, LightColours.textSummary.colour);
+    await tester.pumpWidget(
+      SoulDreamsApp(key: UniqueKey(), home: JournalPage(journal: h.journal), clock: () => DateTime(2026, 6, 10, 22)),
+    );
+    await tester.pumpAndSettle();
+    expect(tester.widget<Text>(find.text(opening(n))).style!.color, DarkColours.text.colour);
+  });
+
+  // Item 4: a chevron at each row's trailing edge, in the text's colour,
+  // centred on the row's height, heard as nothing; item 12: rows 30 from
+  // the screen's sides, 12 apart (TO TRY).
+  testWidgets("a chevron at each row's trailing edge", (tester) async {
+    final h = await Harness.make();
+    final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    final chevrons = find.byType(Chevron);
+    expect(chevrons, findsNWidgets(2));
+    final row = find.ancestor(of: find.text(dayDigits(older.date)), matching: find.byType(Container)).first;
+    final chevron = find.descendant(of: row, matching: find.byType(Chevron));
+    final rowBox = tester.getRect(row);
+    final mark = tester.getRect(chevron);
+    expect(rowBox.right - mark.right, closeTo(StandIns.rowPadding.right, 1));
+    expect(mark.center.dy, closeTo(rowBox.center.dy, 1));
+    expect(mark.left, greaterThan(tester.getRect(find.text(opening(older))).right));
+    expect(tester.widget<Chevron>(chevron).colour, LightColours.text.colour);
+    final width = tester.getSize(find.byType(JournalPage)).width;
+    expect(rowBox.left, closeTo(StandIns.pageSide, 1));
+    expect(rowBox.right, closeTo(width - StandIns.pageSide, 1));
+    final rows = tester.widgetList<Container>(find.ancestor(of: find.byType(Chevron), matching: find.byType(Container)));
+    expect(rows, hasLength(2));
+    final tops = [for (final c in chevrons.evaluate()) tester.getRect(find.ancestor(of: find.byWidget(c.widget), matching: find.byType(Container)).first)];
+    expect(tops[1].top - tops[0].bottom, closeTo(StandIns.rowGap, 1));
+    final handle = tester.ensureSemantics();
+    expect(find.descendant(of: chevron, matching: find.byType(ExcludeSemantics)), findsOneWidget);
+    handle.dispose();
+  });
+
   testWidgets('a named night shows its name, then its date', (tester) async {
     final h = await Harness.make();
     final n = await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 2, 23));
diff --git a/app/test/journal/row_text_test.dart b/app/test/journal/row_text_test.dart
index 7542054..36f6b5e 100644
--- a/app/test/journal/row_text_test.dart
+++ b/app/test/journal/row_text_test.dart
@@ -78,6 +78,8 @@ void main() {
   test('the date is day/month/year, with no time', () {
     expect(dayDigits((year: 2026, month: 3, day: 5)), '05/03/2026');
     expect(dayDigits((year: 2026, month: 12, day: 31)), '31/12/2026');
+    // Always the four-digit year (head's message 20, item 5).
+    expect(dayDigits((year: 2009, month: 1, day: 2)), '02/01/2009');
   });
 
   test('a divider: the month alone this year, month and year before', () {
~~~~

### Task 4 · The back control (head's message 20, item 9)

A thin left chevron in a round bordered button of 41 (`color.button`), still a button named MP·14; the night's
page's top row on the page's margins. Test: `typing_page_test.dart` (1).

Expected: 426 app tests. Commit:

> Back control: a thin chevron in a round bordered button (head's message 20, item 9)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index b4a594c..d3315c4 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -30,6 +30,11 @@ abstract final class StandIns {
   /// Below a month divider.
   static const double dividerBelow = 12;
 
+  /// The back control: a round button about 41 across (head's message 20,
+  /// item 9), and its chevron.
+  static const double backSize = 41;
+  static const backChevron = Size(9, 16);
+
   /// The record button.
   static const double recordHeight = 120;
   static const double recordWidth = 120;
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index 56934e9..e2de131 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -155,7 +155,9 @@ class _NightPageState extends State<NightPage> {
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
-            Row(
+            Padding(
+              padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
+              child: Row(
               children: [
                 BackControl(onPressed: () => Navigator.of(context).pop()),
                 const Spacer(),
@@ -175,6 +177,7 @@ class _NightPageState extends State<NightPage> {
                 ),
               ],
             ),
+            ),
             if (n != null)
               Expanded(
                 child: ListView(
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
index da301ae..5165e47 100644
--- a/app/lib/journal/pages/parts.dart
+++ b/app/lib/journal/pages/parts.dart
@@ -218,7 +218,9 @@ class _ChevronLine extends CustomPainter {
   bool shouldRepaint(_ChevronLine old) => old.colour != colour || old.left != left;
 }
 
-/// The back control, top left: an arrow whose spoken name is MP·14.
+/// The back control, top left: a thin chevron in a round bordered button
+/// (color.button), about 41 across (head's message 20, item 9); its spoken
+/// name is MP·14.
 class BackControl extends StatelessWidget {
   const BackControl({super.key, required this.onPressed});
 
@@ -227,10 +229,33 @@ class BackControl extends StatelessWidget {
   final VoidCallback onPressed;
 
   @override
-  Widget build(BuildContext context) => IconButton(
-    key: buttonKey,
-    onPressed: onPressed,
-    tooltip: Lines.MP_14.text(appLanguage),
-    icon: Icon(Icons.arrow_back_ios_new, color: Palette.of(context).text),
-  );
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Tooltip(
+      message: Lines.MP_14.text(appLanguage),
+      child: Semantics(
+        button: true,
+        child: GestureDetector(
+          key: buttonKey,
+          behavior: HitTestBehavior.opaque,
+          onTap: onPressed,
+          child: SizedBox.square(
+            dimension: StandIns.backSize,
+            child: DecoratedBox(
+              decoration: BoxDecoration(
+                shape: BoxShape.circle,
+                gradient: LinearGradient(
+                  begin: Alignment.topCenter,
+                  end: Alignment.bottomCenter,
+                  colors: [p.buttonTop, p.buttonBottom],
+                ),
+                border: Border.all(color: p.buttonBorder),
+              ),
+              child: Center(child: Chevron(colour: p.buttonText, size: StandIns.backChevron, left: true)),
+            ),
+          ),
+        ),
+      ),
+    );
+  }
 }
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index 3eeeaed..28e232b 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -618,6 +618,27 @@ void main() {
     expect(tester.takeException(), isNull);
   });
 
+  // Head's message 20, item 9: a thin chevron in a round bordered button
+  // of about 41, on the page's margin, heard as a button named MP·14.
+  testWidgets('the back control: a round bordered button, a chevron', (tester) async {
+    await tall(tester);
+    final back = find.byKey(BackControl.buttonKey);
+    expect(tester.getSize(back), const Size(StandIns.backSize, StandIns.backSize));
+    expect(tester.getTopLeft(back).dx, closeTo(StandIns.pageSide, 1));
+    final box = tester.widget<DecoratedBox>(find.descendant(of: back, matching: find.byType(DecoratedBox)));
+    final look = box.decoration as BoxDecoration;
+    expect(look.shape, BoxShape.circle);
+    expect(look.border, Border.all(color: LightColours.button.border!));
+    expect((look.gradient! as LinearGradient).colors, [LightColours.button.colour, LightColours.button.colour]);
+    final chevron = tester.widget<Chevron>(find.descendant(of: back, matching: find.byType(Chevron)));
+    expect(chevron.left, isTrue);
+    expect(chevron.colour, LightColours.button.text);
+    expect(find.byTooltip(Lines.MP_14.text(Lang.en)), findsOneWidget);
+    final handle = tester.ensureSemantics();
+    expect(tester.getSemantics(back).flagsCollection.isButton, isTrue);
+    handle.dispose();
+  });
+
   testWidgets('the instruction is centred, in the button type', (tester) async {
     await tall(tester);
     final line = tester.widget<AppLine>(find.byType(AppLine));
~~~~

### Task 5 · A night's page (head's message 20, items 10 and 11)

The header centred; the "⋯" menu a bordered pill opening `CupertinoMenuAnchor`; the bubbles on the screen's edges
(`Spacing.bubbleDreamer`); Add dreams left and Start Interpretation right, inert, in the shared `ButtonRow` (the
typing screen's pair moves into it, unchanged to the eye). The floating field is not here (Part 4, Q1). Tests:
`night_page_test.dart` (5 new; the menu's two checks follow `CupertinoMenuItem`).

Expected: 431 app tests. Commit:

> Night's page: the header centred, the menu a pill, the bubbles on the edges, Add dreams and Start Interpretation at the foot (head's message 20)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index d3315c4..2d92067 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -35,6 +35,10 @@ abstract final class StandIns {
   static const double backSize = 41;
   static const backChevron = Size(9, 16);
 
+  /// The night's "⋯" menu: a bordered pill as tall as the back control
+  /// (head's message 20, item 10).
+  static const double menuWidth = 55;
+
   /// The record button.
   static const double recordHeight = 120;
   static const double recordWidth = 120;
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index e2de131..19f0360 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -1,15 +1,19 @@
 // Inside a night, not yet read (main-path.md, The Journal, designs 2 and
-// 3; P1, P6, P7; D58 Q1, Q4, Q8): the header (the date, or the name and
-// the date); the "⋯" menu top right, spoken as MP·39, holding only
-// "delete this night" (EM·11's second part), plain; one confirmation, the
-// phone's standard dialog, Cancel first and Delete destructive (MP·61,
-// MP·60, pending lines); the dreams under "Dreams" (MP·38), each opening
-// the typing screen to edit it; "Add dreams" (MP·29). A recording that
+// 3; P1, P6, P7; D58 Q1, Q4, Q8; head's message 20, items 10 to 12): the
+// header centred (the date, or the name and the date); the "⋯" menu top
+// right, a bordered pill opening the phone's menu, spoken as MP·39,
+// holding only "delete this night" (EM·11's second part), plain; one
+// confirmation, the phone's standard dialog, Cancel first and Delete
+// destructive (MP·61, MP·60, pending lines); the dreams under "Dreams"
+// (MP·38), in bubbles 30 from the screen's left edge and 10 from its
+// right (Spacing.bubbleDreamer), each opening the typing screen to edit
+// it; at the foot, "Add dreams" (MP·29) left and Start Interpretation
+// (EM·1) right, which does nothing yet (P3, as D71 Q3). A recording that
 // waits to be turned into text shows nothing in its place and cannot be
 // tapped; while it is being turned into text, AI·6 shows in its place,
 // heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
-// When its words come, the page shows them. Not built: naming, Start
-// Interpretation, and the space below the dreams.
+// When its words come, the page shows them. Not built: naming, reading,
+// and the space below the dreams with its field.
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 
@@ -35,6 +39,7 @@ class NightPage extends StatefulWidget {
   static const menuKey = Key('night-menu');
   static const deleteKey = Key('night-delete');
   static const addKey = Key('night-add');
+  static const startKey = Key('night-start');
   static const transcribingKey = Key('night-transcribing');
 
   final Journal journal;
@@ -146,83 +151,131 @@ class _NightPageState extends State<NightPage> {
     if (mounted) Navigator.of(context).pop();
   }
 
+  // The "⋯" menu: a bordered pill (color.button) opening the phone's menu;
+  // while a delete runs, a tap opens nothing (D64).
+  Widget _menu(Palette p) => CupertinoMenuAnchor(
+    menuChildren: [
+      CupertinoMenuItem(
+        key: NightPage.deleteKey,
+        onPressed: _delete,
+        child: Text(Lines.EM_11.parts(appLanguage)[1]),
+      ),
+    ],
+    builder: (context, controller, _) => Tooltip(
+      message: Lines.MP_39.text(appLanguage),
+      child: Semantics(
+        button: true,
+        child: GestureDetector(
+          key: NightPage.menuKey,
+          behavior: HitTestBehavior.opaque,
+          onTap: () {
+            if (_busy) return;
+            controller.isOpen ? controller.close() : controller.open();
+          },
+          child: SizedBox(
+            width: StandIns.menuWidth,
+            height: StandIns.backSize,
+            child: DecoratedBox(
+              decoration: BoxDecoration(
+                gradient: LinearGradient(
+                  begin: Alignment.topCenter,
+                  end: Alignment.bottomCenter,
+                  colors: [p.buttonTop, p.buttonBottom],
+                ),
+                borderRadius: BorderRadius.circular(StandIns.backSize / 2),
+                border: Border.all(color: p.buttonBorder),
+              ),
+              child: Icon(Icons.more_horiz, color: p.buttonText),
+            ),
+          ),
+        ),
+      ),
+    ),
+  );
+
   @override
   Widget build(BuildContext context) {
     final p = Palette.of(context);
     final n = _night;
+    const side = EdgeInsets.symmetric(horizontal: StandIns.pageSide);
     return Scaffold(
       body: SafeArea(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             Padding(
-              padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
+              padding: side,
               child: Row(
-              children: [
-                BackControl(onPressed: () => Navigator.of(context).pop()),
-                const Spacer(),
-                PopupMenuButton<int>(
-                  key: NightPage.menuKey,
-                  enabled: !_busy,
-                  tooltip: Lines.MP_39.text(appLanguage),
-                  icon: Icon(Icons.more_horiz, color: p.text),
-                  onSelected: (_) => _delete(),
-                  itemBuilder: (context) => [
-                    PopupMenuItem<int>(
-                      key: NightPage.deleteKey,
-                      value: 0,
-                      child: Text(Lines.EM_11.parts(appLanguage)[1], style: TypeRoles.button.style(p.text)),
-                    ),
-                  ],
-                ),
-              ],
-            ),
+                children: [
+                  BackControl(onPressed: () => Navigator.of(context).pop()),
+                  const Spacer(),
+                  _menu(p),
+                ],
+              ),
             ),
-            if (n != null)
+            if (n != null) ...[
               Expanded(
+                // The bubbles keep their own margins from the screen's edges
+                // (design-system.md §5); everything else keeps the page's.
                 child: ListView(
-                  padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
                   children: [
                     Padding(
-                      padding: Spacing.nightHeader,
+                      padding: Spacing.nightHeader.add(side),
                       child: Semantics(
                         header: true,
                         child: n.name == null
-                            ? Text(dayDigits(n.date), style: TypeRoles.h2.style(p.text))
+                            ? Text(dayDigits(n.date), textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text))
                             : Column(
-                                crossAxisAlignment: CrossAxisAlignment.start,
+                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                 children: [
-                                  Text(n.name!, style: TypeRoles.h2.style(p.text)),
-                                  Text(dayDigits(n.date), style: TypeRoles.button.style(p.text)),
+                                  Text(n.name!, textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text)),
+                                  Text(
+                                    dayDigits(n.date),
+                                    textAlign: TextAlign.center,
+                                    style: TypeRoles.button.style(p.text),
+                                  ),
                                 ],
                               ),
                       ),
                     ),
-                    Align(alignment: Alignment.centerLeft, child: SectionLabel(Lines.MP_38.text(appLanguage))),
+                    Padding(
+                      padding: side,
+                      child: Align(alignment: Alignment.centerLeft, child: SectionLabel(Lines.MP_38.text(appLanguage))),
+                    ),
                     const SizedBox(height: StandIns.gap),
                     for (final (i, d) in n.entries.indexed)
                       if (d case Told(:final text)) ...[
                         DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
                         const SizedBox(height: StandIns.bubbleGap),
                       ] else if (d case Waiting(:final audio) when _transcribing == audio) ...[
-                        Semantics(
-                          key: NightPage.transcribingKey,
-                          liveRegion: true,
-                          child: AppLine(Lines.AI_6.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                        Padding(
+                          padding: side,
+                          child: Semantics(
+                            key: NightPage.transcribingKey,
+                            liveRegion: true,
+                            child: AppLine(Lines.AI_6.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                          ),
                         ),
                         const SizedBox(height: StandIns.bubbleGap),
                       ],
-                    const SizedBox(height: StandIns.gap),
-                    Center(
-                      child: KeyedSubtree(
-                        key: NightPage.addKey,
-                        child: PlainButton(Lines.MP_29.text(appLanguage), onPressed: () => _type(null)),
-                      ),
-                    ),
-                    const SizedBox(height: StandIns.gap),
                   ],
                 ),
               ),
+              Padding(
+                padding: const EdgeInsets.fromLTRB(StandIns.pageSide, StandIns.gap, StandIns.pageSide, StandIns.gap),
+                child: ButtonRow(
+                  left: KeyedSubtree(
+                    key: NightPage.addKey,
+                    child: PlainButton(Lines.MP_29.text(appLanguage), onPressed: () => _type(null)),
+                  ),
+                  right: KeyedSubtree(
+                    key: NightPage.startKey,
+                    // Nothing to start yet: the readings come later (P3, as D71 Q3).
+                    child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),
+                  ),
+                ),
+              ),
+            ],
           ],
         ),
       ),
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
index 5165e47..f8d0b25 100644
--- a/app/lib/journal/pages/parts.dart
+++ b/app/lib/journal/pages/parts.dart
@@ -76,6 +76,27 @@ class PlainButton extends StatelessWidget {
   }
 }
 
+/// Two pills at the foot of a page, one at each side; at large text each
+/// shrinks its words to stay on one row, as the record button does (Task
+/// 15a): Save and Start Interpretation, or Add dreams and Start
+/// Interpretation (D70 8; head's message 20, item 10).
+class ButtonRow extends StatelessWidget {
+  const ButtonRow({super.key, required this.left, required this.right});
+
+  final Widget left;
+  final Widget right;
+
+  @override
+  Widget build(BuildContext context) => Row(
+    mainAxisAlignment: MainAxisAlignment.spaceBetween,
+    children: [
+      Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: left)),
+      const SizedBox(width: StandIns.gap),
+      Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: right)),
+    ],
+  );
+}
+
 /// The record button: the biggest thing on the journal's screen, the
 /// terracotta gradient, its words in white (main-path.md, The Journal).
 class RecordButton extends StatelessWidget {
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
index 2a2a805..52858ef 100644
--- a/app/lib/journal/pages/typing_page.dart
+++ b/app/lib/journal/pages/typing_page.dart
@@ -642,32 +642,16 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
                       ),
                     ),
                     const SizedBox(height: StandIns.gap),
-                    // At large text the two pills shrink their words to stay on
-                    // one row, as the record button does (Task 15a).
-                    Row(
-                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
-                      children: [
-                        Flexible(
-                          child: FittedBox(
-                            fit: BoxFit.scaleDown,
-                            child: KeyedSubtree(
-                              key: TypingPage.saveKey,
-                              child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
-                            ),
-                          ),
-                        ),
-                        const SizedBox(width: StandIns.gap),
-                        Flexible(
-                          child: FittedBox(
-                            fit: BoxFit.scaleDown,
-                            child: KeyedSubtree(
-                              key: TypingPage.startKey,
-                              // Nothing to start yet: the readings come later (D71 Q3).
-                              child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),
-                            ),
-                          ),
-                        ),
-                      ],
+                    ButtonRow(
+                      left: KeyedSubtree(
+                        key: TypingPage.saveKey,
+                        child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
+                      ),
+                      right: KeyedSubtree(
+                        key: TypingPage.startKey,
+                        // Nothing to start yet: the readings come later (D71 Q3).
+                        child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),
+                      ),
                     ),
                     const SizedBox(height: StandIns.gap),
                   ],
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index f676723..ddec79b 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -1,15 +1,18 @@
-// A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8): header, "Dreams",
-// the dreams; editing through the typing screen; Add dreams; the menu
-// holding only delete, spoken as MP·39; one confirmation, Cancel first,
-// Delete destructive; deleting leaves nothing.
+// A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8; head's message 20,
+// items 10 to 12): header, "Dreams", the dreams; editing through the
+// typing screen; Add dreams and Start Interpretation at the foot; the menu,
+// a bordered pill opening the phone's menu, holding only delete, spoken as
+// MP·39; one confirmation, Cancel first, Delete destructive; deleting
+// leaves nothing.
 import 'dart:async';
 import 'dart:typed_data';
 
 import 'package:flutter/cupertino.dart';
-import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/core/app_line.dart';
 import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/design/tokens.g.dart';
 import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
@@ -265,7 +268,9 @@ void main() {
     await open(tester);
     expect(find.byTooltip(Lines.MP_39.text(Lang.en)), findsOneWidget);
     await openMenu(tester);
-    expect(find.byType(PopupMenuItem<int>), findsOneWidget);
+    final items = tester.widgetList<CupertinoMenuItem>(find.byType(CupertinoMenuItem));
+    expect(items, hasLength(1));
+    expect(items.single.isDestructiveAction, isFalse);
     expect(find.text(Lines.EM_11.parts(Lang.en)[1]), findsOneWidget);
     expect(find.text(Lines.MP_28.text(Lang.en)), findsNothing);
   });
@@ -373,7 +378,7 @@ void main() {
     await confirmDelete(tester);
     await tester.tap(find.byKey(NightPage.menuKey), warnIfMissed: false);
     await tester.pumpAndSettle();
-    expect(find.byType(PopupMenuItem<int>), findsNothing);
+    expect(find.byType(CupertinoMenuItem), findsNothing);
     await tester.tap(find.byKey(NightPage.addKey));
     await tester.pumpAndSettle();
     await tester.tap(find.text(n.dreams[0]));
@@ -395,6 +400,66 @@ void main() {
     handle.dispose();
   });
 
+  // Head's message 20, item 10: the date or the name centred.
+  testWidgets('the header is centred, the date or the name and date', (tester) async {
+    await open(tester);
+    expect(tester.widget<Text>(find.text(dayDigits(n.date))).textAlign, TextAlign.center);
+    final width = tester.getSize(find.byType(NightPage)).width;
+    expect(tester.getCenter(find.text(dayDigits(n.date))).dx, closeTo(width / 2, 1));
+  });
+
+  testWidgets('a named night: the name and the date both centred', (tester) async {
+    await open(tester, name: 'Night by the harbour');
+    expect(tester.widget<Text>(find.text('Night by the harbour')).textAlign, TextAlign.center);
+    expect(tester.widget<Text>(find.text(dayDigits(n.date))).textAlign, TextAlign.center);
+  });
+
+  // Item 10: the menu a bordered pill top right, on the page's margin.
+  testWidgets('the menu: a bordered pill, top right', (tester) async {
+    await open(tester);
+    final menu = find.byKey(NightPage.menuKey);
+    expect(tester.getSize(menu), const Size(StandIns.menuWidth, StandIns.backSize));
+    final width = tester.getSize(find.byType(NightPage)).width;
+    expect(tester.getTopRight(menu).dx, closeTo(width - StandIns.pageSide, 1));
+    expect(tester.getCenter(menu).dy, closeTo(tester.getCenter(find.byKey(BackControl.buttonKey)).dy, 1));
+    expect(tester.getTopLeft(find.byKey(BackControl.buttonKey)).dx, closeTo(StandIns.pageSide, 1));
+    final look = tester.widget<DecoratedBox>(find.descendant(of: menu, matching: find.byType(DecoratedBox))).decoration
+        as BoxDecoration;
+    expect(look.border, Border.all(color: LightColours.button.border!));
+    expect(look.borderRadius, BorderRadius.circular(StandIns.backSize / 2));
+  });
+
+  // Item 11: the dreamer's bubbles 30 from the screen's left edge and 10
+  // from its right (design-system.md §5).
+  testWidgets("the bubbles: 30 from the left edge, 10 from the right", (tester) async {
+    await open(tester);
+    final width = tester.getSize(find.byType(NightPage)).width;
+    for (final d in n.dreams) {
+      final bubble = tester.getRect(find.ancestor(of: find.text(d), matching: find.byType(DecoratedBox)).first);
+      expect(bubble.right, closeTo(width - Spacing.bubbleDreamer.right, 1), reason: d);
+      expect(bubble.left, greaterThanOrEqualTo(Spacing.bubbleDreamer.left - 1), reason: d);
+    }
+  });
+
+  // Item 10: at the foot, Add dreams on the left and Start Interpretation on
+  // the right, which does nothing yet (P3, as D71 Q3).
+  testWidgets('Add dreams bottom left, Start Interpretation bottom right', (tester) async {
+    await open(tester);
+    final size = tester.getSize(find.byType(NightPage));
+    final add = tester.getRect(find.byKey(NightPage.addKey));
+    final start = tester.getRect(find.byKey(NightPage.startKey));
+    expect(find.text(Lines.EM_1.text(Lang.en)), findsOneWidget);
+    expect(add.left, closeTo(StandIns.pageSide, 1));
+    expect(start.right, closeTo(size.width - StandIns.pageSide, 1));
+    expect(add.center.dy, closeTo(start.center.dy, 1));
+    expect(add.bottom, closeTo(size.height - StandIns.gap, 1));
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(NightPage), findsOneWidget);
+    expect(find.byType(TypingPage), findsNothing);
+    expect((await h.journal.night(n.id))!.dreams, n.dreams);
+  });
+
   testWidgets('the date is heard as a heading', (tester) async {
     final handle = tester.ensureSemantics();
     await open(tester);
~~~~

### Task 6 · The mutation rows A242 to A265

24 new rows; A24ae, A24ah, A61, A68 and A136 follow the code (D67). Two test gaps the rows showed: the fake
connection says whether it is listened to (A247), and a loss followed by a failing key (A245). Run, from the
repository root: `python3 -I -B tool/app_mutations.py --files lib/recording/recording.dart,lib/core/safe_log.dart,lib/app.dart,lib/core/night_day.dart,lib/design/stand_ins.dart,lib/journal/pages/parts.dart,lib/journal/pages/journal_page.dart,lib/journal/pages/night_page.dart,lib/journal/pages/typing_page.dart`
(D95). Expected: `app mutations: 169 run, 169 caught`.

Expected: 432 app tests. Commit:

> Mutation rows: A242 to A265 for journal-design and D100; five rows follow the code (D67)

**The block:**

~~~~diff
diff --git a/app/test/recording/fakes.dart b/app/test/recording/fakes.dart
index dfd8a57..2886bdb 100644
--- a/app/test/recording/fakes.dart
+++ b/app/test/recording/fakes.dart
@@ -229,6 +229,9 @@ final class FakeConnection implements Connection {
     online = value;
     _changes.add(value);
   }
+
+  /// Whether anything watches the changes now.
+  bool get listened => _changes.hasListener;
 }
 
 /// A link held in memory: what was sent, and replies the test pushes.
diff --git a/app/test/recording/recording_test.dart b/app/test/recording/recording_test.dart
index 3b43b48..5c9a8ff 100644
--- a/app/test/recording/recording_test.dart
+++ b/app/test/recording/recording_test.dart
@@ -925,6 +925,24 @@ void main() {
     expect(lines, ['recordingStarted', 'recordingKeyFailed 502', 'recordingSettled 0 200', 'recordingEnded']);
   });
 
+  test('the connection lost, then the key fails: told once', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final connection = FakeConnection();
+    final key = Completer<String>();
+    final r = kept(mic, keep, connection: connection, key: () => key.future);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 2);
+    connection.set(false);
+    await pumpEventQueue();
+    key.completeError(const KeyFailure(0));
+    await pumpEventQueue();
+    expect(r.troubles, [Trouble.broke]);
+    expect(r.heard, [('', '')]);
+    await r.session.stop();
+    expect(lines, ['recordingStarted', 'recordingConnectionLost', 'recordingSettled 0 200', 'recordingEnded']);
+  });
+
   test('the connection lost during a stop: it ends at once, MP·54', () async {
     final mic = SilentMicrophone();
     final keep = MemoryKeep();
@@ -1007,10 +1025,12 @@ void main() {
     final r = kept(mic, keep, link: link, connection: connection);
     expect(await r.session.start(), isTrue);
     await frames(mic, 2);
+    expect(connection.listened, isTrue);
     final stopped = r.session.stop();
     await pumpEventQueue();
     link.reply(reply(done: [tokens[0]], finalMs: 200, finished: true));
     await stopped;
+    expect(connection.listened, isFalse);
     connection.set(false);
     await pumpEventQueue();
     expect(r.troubles, isEmpty);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 9032c52..d4e5172 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A241, A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A265, A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 270 run, 270 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 294 run, 294 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -283,8 +283,8 @@ ROWS = [
      '    final page',
      'test/journal/pages/night_page_test.dart', 'the menu, Add and a dream wait while a delete runs'),
     ('A24ae', 'lib/journal/pages/night_page.dart',
-     'enabled: !_busy,',
-     'enabled: true,',
+     '            if (_busy) return;\n            controller.isOpen',
+     '            controller.isOpen',
      'test/journal/pages/night_page_test.dart', 'the menu, Add and a dream wait while a delete runs'),
     ('A24af', 'lib/journal/pages/parts.dart',
      '          button: true,\n          child: GestureDetector(',
@@ -295,7 +295,7 @@ ROWS = [
      'header: false,',
      'test/journal/pages/night_page_test.dart', 'the date is heard as a heading'),
     ('A24ah', 'lib/journal/pages/night_page.dart',
-     'Text(n.name!, style: TypeRoles.h2.style(p.text)),',
+     'Text(n.name!, textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text)),',
      'const SizedBox.shrink(),',
      'test/journal/pages/night_page_test.dart', 'a named night shows name over date, as a heading'),
     # Task 12a (D65): the import walk, and the journal list after the phone check
@@ -504,7 +504,7 @@ ROWS = [
      'child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),',
      'child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: _save),',
      'test/journal/pages/typing_page_test.dart', 'Start Interpretation does nothing yet (D71 Q3)'),
-    ('A61', 'lib/journal/pages/typing_page.dart',
+    ('A61', 'lib/journal/pages/parts.dart',
      'mainAxisAlignment: MainAxisAlignment.spaceBetween,',
      'mainAxisAlignment: MainAxisAlignment.start,',
      'test/journal/pages/typing_page_test.dart', 'Save on the left, Start Interpretation on the right'),
@@ -537,8 +537,8 @@ ROWS = [
     # which sets _ended before it awaits anything, so _cancelled is never the
     # only thing that stops a late start.
     ('A68', 'lib/recording/recording.dart',
-     '    if (_ended) {\n      // The session ended while the stream opened',
-     '    if (false) {\n      // The session ended while the stream opened',
+     '    if (_ended || _cut) {\n      // The session ended, or',
+     '    if (false || _cut) {\n      // The session ended, or',
      'test/recording/recording_test.dart', 'a cancel while the stream opens closes it on arrival'),
     ('A69', 'lib/recording/recording.dart',
      '      _closeQuietly(link);\n      return;\n',
@@ -786,8 +786,8 @@ ROWS = [
      '    unawaited(_open());\n',
      'test/recording/recording_test.dart', 'a stop while the key comes: held audio, then the end'),
     ('A136', 'lib/recording/recording.dart',
-     '      return _brokeOff(LogEvent.recordingKeyFailed, 0);\n    }\n    if (_ended) return;\n',
-     '      return _brokeOff(LogEvent.recordingKeyFailed, 0);\n    }\n',
+     '(D100): no stream is opened.\n    if (_ended || _cut) return;\n',
+     '(D100): no stream is opened.\n',
      'test/recording/recording_test.dart', 'a cancel before the stream opens sends nothing'),
     ('A137', 'lib/recording/recording.dart',
      '    SafeLog.event(code, [number]);\n    if (_keeping) {\n      _goOn();\n    } else {\n      unawaited(_shut());\n    }\n',
@@ -1216,6 +1216,104 @@ ROWS = [
      'if (landed || !await _store.hasNightFile(pending.night)) await',
      'if (landed) await',
      'test/journal/journal_audio_test.dart', 'unreadable night keeps its audio; a gone night loses it'),
+    # journal-design (D100; head's message 20, items 1, 4, 5, 7, 9 to 13). A24ae, A24ah, A61,
+    # A68 and A136 follow the code (D67).
+    ('A242', 'lib/recording/recording.dart',
+     '        if (!online) _lost();\n',
+     '',
+     'test/recording/recording_test.dart', 'the connection lost mid-stream: MP·54 at once, it goes on'),
+    ('A243', 'lib/recording/recording.dart',
+     '(D100): no stream is opened.\n    if (_ended || _cut) return;\n',
+     '(D100): no stream is opened.\n    if (_ended) return;\n',
+     'test/recording/recording_test.dart', 'the connection lost while the stream opens: it never opens'),
+    ('A244', 'lib/recording/recording.dart',
+     '    if (_ended || _cut) {\n      // The session ended, or',
+     '    if (_ended) {\n      // The session ended, or',
+     'test/recording/recording_test.dart', 'the connection lost while opening: a stream that comes is closed'),
+    ('A245', 'lib/recording/recording.dart',
+     'nothing more.\n    if (_ended || _cut) return;',
+     'nothing more.\n    if (_ended) return;',
+     'test/recording/recording_test.dart', 'the connection lost, then the key fails: told once'),
+    ('A246', 'lib/recording/recording.dart',
+     '    if (_ended || _finished.isCompleted || _cut) return;\n    SafeLog.event(LogEvent.recordingConnectionLost);',
+     '    if (_ended || _finished.isCompleted) return;\n    SafeLog.event(LogEvent.recordingConnectionLost);',
+     'test/recording/recording_test.dart', 'the connection lost after the key failed: told once'),
+    ('A247', 'lib/recording/recording.dart',
+     '    unawaited(_connection?.cancel());\n    _connection = null;\n',
+     '',
+     'test/recording/recording_test.dart', 'a recording that has ended stops watching the connection'),
+    ('A248', 'lib/recording/recording.dart',
+     '    SafeLog.event(LogEvent.recordingConnectionLost);\n    _cutOff();',
+     '    SafeLog.event(LogEvent.recordingConnectionLost);\n    unawaited(_shut());',
+     'test/journal/pages/typing_page_test.dart', 'the connection lost: MP·54 at once, until the next tap'),
+    ('A249', 'lib/app.dart',
+     'themeAnimationCurve: Curves.easeInOut,',
+     'themeAnimationCurve: Curves.linear,',
+     'test/core/night_day_test.dart', 'the fade eases in and out'),
+    ('A250', 'lib/journal/pages/journal_page.dart',
+     'AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text))',
+     'AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.voiceApp.style(p.text))',
+     'test/journal/pages/journal_page_test.dart', "the empty journal's line: the button type, centred"),
+    ('A251', 'lib/journal/pages/journal_page.dart',
+     'Text(text, textAlign: TextAlign.center, style: TypeRoles.h4',
+     'Text(text, style: TypeRoles.h4',
+     'test/journal/pages/journal_page_test.dart', 'the month divider is centred'),
+    ('A252', 'lib/journal/pages/journal_page.dart',
+     'final summary = TypeRoles.button.style(p.summary);',
+     'final summary = TypeRoles.voiceDreamer.style(p.summary);',
+     'test/journal/pages/journal_page_test.dart', "the summary: the button type, the summary's colour"),
+    ('A253', 'lib/journal/pages/journal_page.dart',
+     'final summary = TypeRoles.button.style(p.summary);',
+     'final summary = TypeRoles.button.style(p.text);',
+     'test/journal/pages/journal_page_test.dart', "the summary: the button type, the summary's colour"),
+    ('A254', 'lib/journal/pages/journal_page.dart',
+     "const _threeLines = '\\n\\n';",
+     "const _threeLines = '\\n';",
+     'test/journal/pages/journal_page_test.dart', 'the summary is always three lines'),
+    ('A255', 'lib/journal/pages/journal_page.dart',
+     '              Chevron(colour: p.text),\n',
+     '',
+     'test/journal/pages/journal_page_test.dart', "a chevron at each row's trailing edge"),
+    ('A256', 'lib/journal/pages/parts.dart',
+     'Widget build(BuildContext context) => ExcludeSemantics(\n    child: SizedBox.fromSize(',
+     'Widget build(BuildContext context) => Semantics(\n    child: SizedBox.fromSize(',
+     'test/journal/pages/journal_page_test.dart', "a chevron at each row's trailing edge"),
+    ('A257', 'lib/journal/pages/parts.dart',
+     '                shape: BoxShape.circle,\n',
+     '',
+     'test/journal/pages/typing_page_test.dart', 'the back control: a round bordered button, a chevron'),
+    ('A258', 'lib/journal/pages/parts.dart',
+     'size: StandIns.backChevron, left: true)',
+     'size: StandIns.backChevron)',
+     'test/journal/pages/typing_page_test.dart', 'the back control: a round bordered button, a chevron'),
+    ('A259', 'lib/journal/pages/parts.dart',
+     'message: Lines.MP_14.text(appLanguage),',
+     'message: Lines.MP_38.text(appLanguage),',
+     'test/journal/pages/typing_page_test.dart', 'the back control: a round bordered button, a chevron'),
+    ('A260', 'lib/journal/pages/parts.dart',
+     '        button: true,\n        child: GestureDetector(\n          key: buttonKey,\n          behavior',
+     '        button: false,\n        child: GestureDetector(\n          key: buttonKey,\n          behavior',
+     'test/journal/pages/typing_page_test.dart', 'the back control: a round bordered button, a chevron'),
+    ('A261', 'lib/journal/pages/night_page.dart',
+     '? Text(dayDigits(n.date), textAlign: TextAlign.center,',
+     '? Text(dayDigits(n.date),',
+     'test/journal/pages/night_page_test.dart', 'the header is centred, the date or the name and date'),
+    ('A262', 'lib/journal/pages/night_page.dart',
+     '                border: Border.all(color: p.buttonBorder),\n              ),\n              child: Icon(',
+     '              ),\n              child: Icon(',
+     'test/journal/pages/night_page_test.dart', 'the menu: a bordered pill, top right'),
+    ('A263', 'lib/journal/pages/night_page.dart',
+     '                child: ListView(\n                  children: [',
+     '                child: ListView(\n                  padding: side,\n                  children: [',
+     'test/journal/pages/night_page_test.dart', "the bubbles: 30 from the left edge, 10 from the right"),
+    ('A264', 'lib/journal/pages/night_page.dart',
+     'child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),',
+     'child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () => _type(null)),',
+     'test/journal/pages/night_page_test.dart', 'Add dreams bottom left, Start Interpretation bottom right'),
+    ('A265', 'lib/journal/pages/parts.dart',
+     'mainAxisAlignment: MainAxisAlignment.spaceBetween,',
+     'mainAxisAlignment: MainAxisAlignment.center,',
+     'test/journal/pages/night_page_test.dart', 'Add dreams bottom left, Start Interpretation bottom right'),
 ]
 
 
~~~~

### Task 7 · Status.md

Status.md for the branch. Replace `<the day of this task>` with the date. If Product has answered Part 4 by then, add
one line for each answer under "Rulings during journal-design", as given.

Expected: 432 app tests. Commit:

> Docs: Status.md for journal-design (head's message 20, D100)

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
index f70c4a2..7364123 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-18, in branch `offline-recording` (the plan's Tasks 1 to 9, the phone checks' fixes D97 to D99, and the final review's fixes; waiting for the owner's last by-eye checks and the merge), by Claude Code.
+Last updated: <the day of this task>, in branch `journal-design` (the plan's Tasks 1 to 6; waiting for the owner's by-eye review, Task 8, and the merge), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,16 +14,14 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`offline-recording`: offline recording in SoulDreams Dev only (D92 to D94): every recording's audio kept in the
-journal's folder until its words are final; no connection, or a failure, and the recording goes on and waits;
-retries through Soniox's real-time stream only while the app is open, progress kept; MP·15, MP·54, MP·63, MP·64 and
-AI·6; the night's file at version 2 (an on-phone storage change, `docs/workflow.md` (c)). Plan:
-`docs/plans/offline-recording.md`.
+`journal-design`: the journal design pass in SoulDreams Dev (head's message 20, Product message 19, items 1, 3 to 5, 7
+and 9 to 13; the spacings TO TRY), and D100 (a connection lost during a recording shows MP·54 at once). Plan:
+`docs/plans/journal-design.md`. The night's page's floating field waits for Product (the plan's Part 4, Q1).
 
 ## Road ahead
 
-- The owner's rehearsal of the night file's version 2 passed (the plan's Task 3, 2026-11-18, on the phone, with
-  invented nights written by `main`). The owner runs the phone checks (Task 10), and merges `offline-recording`.
+- The owner's by-eye review of `journal-design` (the plan's Task 8, with the founder's verdict on the growing pill
+  and the spacings), and the merge. The night's page's floating field, once Product answers the plan's Part 4 Q1.
 - The readings: our server's own spending counter comes with them (D69), and response streaming on the function
   URL (head's message 14; whether eu-north-1 has it is checked first).
 - A later branch, by the Head of Technology's direction (with D32): the import gains a kind for lens sections 3, 4, 5,
@@ -142,6 +140,15 @@ AI·6; the night's file at version 2 (an on-phone storage change, `docs/workflow
 - A night's page (D64): a failed delete or read logs `journalDeleteFailed` or `journalReadFailed`, keeps the page and
   shows nothing new; while a delete runs, the menu, Add dreams and the dreams ignore taps; each dream is announced as
   a button. SoulDreams Dev's list waits for the phone check before it opens the folder (D65).
+- The journal design pass (head's message 20, Product message 19; `journal-design`; TO TRY where marked): a row's
+  summary in the button type, `color.text.summary` (#767676 on white; the dark theme's text on the gradient), a thin
+  drawn chevron at its trailing edge (`Chevron`, no icon font); the month divider centred; the empty journal's line
+  in the button type, centred; the back control a thin chevron in a round bordered button of 41 (`color.button`); a
+  night's page with its header centred, the "⋯" menu a bordered pill opening `CupertinoMenuAnchor` (Flutter's
+  rendering of the phone's pull-down menu), the dreamer's bubbles 30 from the screen's left edge and 10 from its
+  right (`Spacing.bubbleDreamer`), and at its foot Add dreams (MP·29) left and Start Interpretation (EM·1) right,
+  inert (P3, as D71 Q3), the same `ButtonRow` as the typing screen's; the side margins 30 and the rows 12 apart
+  (TO TRY). Not built: the night's page's floating field (the plan's Part 4, Q1).
 - The record button is a circle (Task 15a, the owner's correction, P13): `StandIns.recordWidth` and `recordHeight`
   both 120, the radius half the height; large text shrinks its words, never the circle.
 - The night rules (`app/lib/journal/night_rules.dart`, `journal.dart`): a night stores its closing instant, the
@@ -149,7 +156,7 @@ AI·6; the night's file at version 2 (an on-phone storage change, `docs/workflow
   target is fixed when it opens; an empty Save keeps nothing; an emptied dream disappears; a night with no dream left
   is deleted (D58 Q2, Q3; P9, P10).
 - Night/Day automatic (`app/lib/core/night_day.dart`): dark 21:00 to 08:00 by the phone's clock, a five-second
-  fade while the app is open, instant with Reduce Motion (read from the platform's own flag, which iOS does not put
+  ease-in-out fade while the app is open (head's message 20, item 13), instant with Reduce Motion (read from the platform's own flag, which iOS does not put
   in `MediaQuery`), at start and on returning (D57 Q15). The app's own lines appear a word every 60 ms, whole with
   Reduce Motion (`app/lib/core/app_line.dart`; D58 Q17). The palette (`app/lib/design/palette.dart`) fades with the
   theme. The app shows English only (D57 Q12; `app/lib/core/language.dart`).
@@ -167,10 +174,10 @@ AI·6; the night's file at version 2 (an on-phone storage change, `docs/workflow
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 410 tests, and 270 mutation checks (A1 to A241; A55, A73, A80 to A83, A86 to A88, A94, A99,
+- The app's analyzer baseline: `No issues found!`. The app has 432 tests, and 294 mutation checks (A1 to A265; A55, A73, A80 to A83, A86 to A88, A94, A99,
   A128 to A130, A142, A207, A213 and A223 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 270 run, 270 caught`); `check_all.sh` does not call it (D55). During a task only the
+  (expected: `app mutations: 294 run, 294 caught`); `check_all.sh` does not call it (D55). During a task only the
   rows that target the files changed are run, with `--rows A1,A7` or `--files lib/a.dart` (D95).
 
 ## The server
@@ -455,9 +462,10 @@ Banked in journal-screens:
 75. `JournalStore.newQueueForTests()`: the store's one queue (D54) is static, and a widget test's fake-async zone
     strands it for the next test; each widget test starts a new queue inside its own zone. App code never calls it.
 76. MP·39, the menu's spoken name, names naming, which is not built (D58 Q1): as written, Dev only, until naming.
-77. The stand-ins (`stand_ins.dart`) and these choices await the founder's look in Cohort 0 (P13): the summary's type
-    role (the dreamer's voice), Material's "hotel" icon for Save's sleeping person, the back arrow, the menu's form,
-    the linear fade curve, and the dark field's absent border drawn as a transparent one.
+77. The stand-ins (`stand_ins.dart`) and these choices await the founder's look in Cohort 0 (P13): Material's
+    "hotel" icon for Save's sleeping person and the dark field's absent border drawn as a transparent one. (The
+    summary's type role, the back control, the menu's form and the fade's curve were ruled by head's message 20 and
+    built in `journal-design`.)
 78. A named night's row is built (D57 Q6) but nothing in the app can name a night yet (P7).
 79. Word Animation, the setting, is not built (P8): only Reduce Motion stops word by word and the fade.
 80. The month names come from `intl`'s CLDR data, assumed to match iOS's own for English and Swedish (D56).
@@ -625,7 +633,8 @@ Banked in recording:
      for the night page's and the journal page's reload on words, `release()`, `copyTail`, `rename` and `_part`
      (their tests catch each); the D99 re-review's notes (a reply of markers alone leaves the shown
      words as they were; the first word after a pause is assumed to carry its own space).
-115. Open questions for the owner from the final review (the leans in brackets): (a) a connection that drops during a
+115. CLOSED: (a) by D100 (MP·54 at once, built in `journal-design`); (b) stays as built (head's message 20).
+     Open questions for the owner from the final review (the leans in brackets): (a) a connection that drops during a
      live recording is shown as MP·54 only at Stop, after the five-second wait, since the stream gives no sign
      (the lean: leave it; the phone's own connection state could show it at once, a change to what the dreamer
      sees); (b) D97's "new night" is built as wherever a new Save would go, which is the open night if there is
@@ -638,7 +647,8 @@ Banked in recording:
 2. Product gives exact values for Task 14's thirteen questions below (P13).
 
 Task 14's questions for Product (D68), from the founder's screenshots; none built, each more than a number
-(questions 2, 7 and 8 were answered by D70 and built in `recording`, TO TRY):
+(questions 2, 7 and 8 were answered by D70 and built in `recording`, TO TRY; questions 1, 3, 4, 5, 7, 9 to 13 by head's
+message 20 and built in `journal-design`, except the night's page's field in 10; 6 waits for P8):
 
 1. The summary's type role: the screenshots show `TypeRoles.button` (Inter 14); switching needs the row's minimum
    height changed.
@@ -881,6 +891,15 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 - D99 (owner, 2026-11-18): Soniox's endpoint detection on, with Soniox's defaults for its delay, sensitivity and
   latency; `<end>` tokens never shown (as D73). From then on the owner's checks are by eye only, with no DevTools.
 
+## Rulings during journal-design
+
+- Head's message 20 (Product message 19): the journal design pass, items 1, 3 to 5, 7 and 9 to 13 (the "current
+  design" the founder's dark-theme screens of 2026-10-29 and their light versions, read with every ruling since); item
+  6 waits for P8; the spacings TO TRY.
+- D100 (founder): during a recording, when the phone reports it has lost its connection, MP·54 shows at once (the
+  words stop; the audio is kept, as built), not only at Stop; it stays until the next tap or the screen closes. The
+  offline-recording final review's Q2 (item 115 b) stays as built.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C16-P state (`ff3b229`), in commit `ca29414` (Task 6). The ordinal
~~~~

### Task 8 · [OWNER] The by-eye review, SoulDreams Dev, invented nights only

By eye only, no DevTools (D99), in SoulDreams Dev built from this branch, with invented nights. Check each in the
light theme and, where it says so, in the dark one (after 21:00, or before 08:00). Any result that differs: stop and
bring it to the Build chat; nothing is fixed on the phone.

1. **The journal list** (light and dark). Each row: the date (or name and date), then three lines of summary in a
   plain sans-serif face, grey on the white row (light), light text on the purple row (dark); a thin chevron at the
   right, centred on the row's height. Rows about 30 from the screen's sides and about 12 apart. Dates as
   `dd/mm/yyyy`, four-digit year. The month divider centred, the month alone (this year).
2. **The empty journal** (after deleting every night): "This is where your journal entries will appear." in the same
   plain face as the buttons, centred. The record button: a 120 pt circle, "Record dream" in white inside it.
3. **The back control** (typing screen and a night's page): a round button about 41 across, with a thin border and a
   thin left chevron; white in light, the pale gradient in dark. Tapping it on the typing screen saves and goes back,
   as before.
4. **A night's page.** The date centred, large. Top right a bordered pill with "⋯"; tapping it opens the phone's
   pull-down menu with "Delete this"; tapping that opens the confirmation (Cancel first, Delete in red), as before.
   The dreams' bubbles reach to about 10 from the screen's right edge and start no nearer than about 30 from its left.
   At the foot: "Add dreams" left (opens the typing screen into this night, as before) and "Start Interpretation"
   right, which does nothing.
5. **The typing screen.** "Save" bottom left, "Start Interpretation" bottom right, each about 30 from the sides.
   **The founder's verdict** on the growing pill field (D70 2, TO TRY): it starts one line high and grows with its
   words; keep, or what to change.
6. **The spacings, TO TRY: the founder's verdict** on the 30 side margins, the 20 between groups and the 12 between
   rows, on all three pages: keep, or the numbers he wants.
7. **The fade** (with the app open across 21:00 or 08:00, Reduce Motion off): the colours change over about five
   seconds, starting and ending gently rather than at an even pace.
8. **D100.** With a connection, open the typing screen and record an invented night aloud (read from
   `fixtures/invented-nights.json`); after a few words turn on Airplane Mode. Expected: MP·54 appears at once; the
   words stop; the level line and the timer go on. Speak a little more, then tap Stop: it stops at once and MP·54
   stays. Tap Save: the night holds the words that came and a dream waiting. Turn Airplane Mode off and come back to
   the journal: the waiting dream is turned into words (AI·6 while it runs, on the night's page).
9. **D100, the next tap.** Again with a connection, record, turn on Airplane Mode (MP·54 shows), tap Stop, then tap
   the microphone again while still offline: MP·54 goes and MP·15 shows. Save; turn Airplane Mode off.
10. **Large text** (the phone's text size at its largest): the three pages show no cut-off or overlap; the two
    buttons at the foot of a night's page and of the typing screen shrink their words to stay on one row.

## Part 4 · Questions (numbered; a blank is not a yes)

For Product, through the Build chat. Only Q1 holds back work (its own task, written once it is answered); the others
are built as their lean says, and a different answer is a small change before the merge.

1. **The floating field on a night's page** (item 10). In the founder's drawing it floats above the two buttons with
   a microphone, and its placeholder invites the dreamer to type or record to reflect: that is the space below the
   dreams (main-path.md, The Journal, design 3), where the app answers with a reflection. The space is not built: it
   needs the model's instructions (R7, still waiting) and a change to how a night is stored (a storage change ships
   alone, docs/workflow.md (c)). Which, for this branch? (a) Not built until the space is built. (b) Shown as drawn but
   inert, like Start Interpretation (P3): it takes no typing and its microphone does nothing; its placeholder needs a
   place and a line in the register (or a pending line), since the drawing's words are not filed (R1). (c) Something
   else. **Lean: (b), with the line from Product**, so the founder can judge the page whole; (a) if a field that does
   nothing would mislead in Cohort 0.
2. **The left button's words** (item 10 says "Record More"). The register's line for adding a dream to a night is
   MP·29, "Add dreams", which is what the page shows; under R1 we cannot write "Record More". **Lean: MP·29 as it
   stands**; if Product wants "Record More", it is refiled in the register and comes in by the owner's import.
3. **"Delete this" in the menu**: plain, as built (D58 put the red on the confirmation's Delete), or red, as iOS
   shows a destructive item in a pull-down menu? **Lean: plain, as built.**
4. **"About 30 pt outer margins"** (item 12): the sides only, or also above the top controls and below the bottom
   ones? **Lean: the sides only**; above and below keep what is built (the phone's safe area, and 20 below the bottom
   buttons, 40 below the record button).
5. **A named night's header** (item 10 says "date or name centred"): the date under a name is centred too. **Lean:
   yes, both centred** (built; no night can be named yet, P7).
6. **The bubbles' margins** (item 11): design-system.md's "30px from the left edge, 10px from the right" read as the
   screen's edges, so a bubble reaches past the page's 30 margin on the right. **Lean: the screen's edges, as
   written** (built). The other reading puts them inside the page's margins (60 and 40 from the screen).

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/jd/build`, from `git archive` of `536d916`, each
   task's state kept as a snapshot (`./.scratch/jd/snaps/<task>`); each block in Part 3 is `git diff --no-index`
   between two snapshots.
2. **The counts measured on the build**: app tests 410 (baseline), 420, 421, 425, 426, 431, 432, 432; `No issues
   found!` at each.
3. **Test first**: Task 1's new tests on the old session: 7 failed, and the 3 that passed pin guards the rows break
   (A245 to A247). Task 2's on the linear curve: failed. Tasks 3 to 5's tests use names their tasks add, so each was
   shown failing by its mutation row instead (A250 to A265).
4. **Mutations on the build** (D95: every row of the files changed): `app mutations: 169 run, 168 caught`; A243
   survived (its test checked only that nothing was sent, which the second guard also ensures). Folded into Task 1:
   the test now counts the streams asked for. Then the 29 new and followed rows again: `29 run, 29 caught`.
5. **The guards** on the replayed tree first refused four things, each fixed in its task: G3, the summary's measure
   passed `'\n\n'` straight to `TextSpan` (now the constant `_threeLines`); G4, two test names and five row patterns
   of twelve words or more (shortened, each still found once). Then `guards (walk): all passed`.
6. **Replayed on a fresh copy**, `./.scratch/jd/replay`, from `git archive` of `536d916`: every block applied with
   `git apply` in order, and after each the replayed tree against its snapshot: no difference. On the replayed tree:
   `guards (walk): all passed`, `No issues found!`, `+432: All tests passed!`.
7. **Not provable in the sandbox, so the owner's** (Task 8): how each page looks on the phone in both themes; the
   phone's pull-down menu as `CupertinoMenuAnchor` draws it; iOS reporting a lost connection (Airplane Mode) to the
   recording at once; the fade's feel.
8. The guards and their tests, the server, Swift and the words are unchanged (241 guard tests, 47 server tests).
9. The scratch copies (`./.scratch/jd/`) are deleted after this plan is committed.

*No matter where you are on your journey, the steps you take are equally important.*
