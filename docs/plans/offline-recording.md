# Plan: offline recording (the audio waits on the phone until it is turned into text)

*No matter where you are on your journey, the steps you take are equally important.*

Written by Claude Code (Opus) on 2026-11-18 from the investigation (`.scratch/for-build-chat/offline-recording-plan.md`,
rounds 1 and 2) and the owner's rulings D92, D93 and D94 (D94 replaces D93's Q1 B). **Proven before committing as far
as the sandbox allows** (Part 5). This commit holds this file only; nothing else is implemented yet.

## Part 1 · Spec

### In plain words

Today a recording needs a connection: with none, or when the stream breaks, the microphone stops and whatever was not
yet heard is gone. After this branch, in SoulDreams Dev, nothing said is lost that way. Every recording's sound is
also written, as it is made, into the journal's own protected folder on the phone (backup-excluded, complete file
protection, plain 16 kHz PCM). When every word of it has come back final, that sound is deleted at once.

With no connection at the tap, the recording simply goes on: the level line and the timer run, MP·15 shows (and is
what a screen reader hears, instead of MP·33), and Save keeps the night with the recording waiting in it. When the
connection, our server's key or Soniox (its budget included) fails while a recording runs, MP·54 shows and the
recording goes on just the same: the words already final stay in the field, the ones not yet settled leave it (they
will come back), and everything after the last final word waits. A refused microphone shows MP·63 instead of nothing,
and while it records the microphone is named MP·64. Every recording stops itself at ten minutes, as Stop does.

A recording that waits is a dream of its own, in its place among the night's dreams. On the night's page it shows
nothing until it is being turned into text; then AI·6 shows in its place; then its words, as its own dream. The
journal's row is never marked; a night holding only a waiting recording shows its date alone.

The waiting sound is replayed through Soniox's real-time stream, with a fresh short-lived key, at the speed it was
spoken (Soniox asks for real-time pace), never through Soniox's file service, so Soniox stores nothing and the sound
never touches our server. Only while the app is open: when the journal opens, when the app comes back, and when the
connection returns; never while a typing screen is open; no background task. Progress is kept: if the app closes or
the connection breaks partway, the words already final go into the night at once, the sound they cover is deleted,
and the next try starts from there, so a recording's words may appear in parts. With the ten-minute cap, a retry needs
at most ten minutes of the app open in total.

Deleting a night deletes any sound still waiting for it. The night's file changes format (version 2, which still reads
version 1); that is an on-phone storage change under `docs/workflow.md` (c), so it is its own task, rehearsed by the
owner on the phone before anything else lands.

### What this branch builds

1. **The pending lines** MP·63 and MP·64 (head's message 21, Product message 20): MP·63 where MP·62 shows, a live
   region, until the next tap of the microphone; MP·64 the microphone's tooltip (its spoken name and long-press tip)
   while it records, MP·11 otherwise.
2. **The night's file, version 2** (D93 Q2; workflow (c)): a night's dreams in order, each told in words (a string, as
   in version 1) or a recording waiting (`{"waiting": "<32 hex>", "from": <bytes already in words>}`). Version 1 still
   reads and is written as version 2 at its next save; a waiting recording in a version-1 file is refused. A dream's
   index counts both kinds; a waiting one is never edited and never tapped. A night with no told dream shows its date
   alone.
3. **The audio in the journal's folder** (D92 items 1, 4, 5): `audio-<id>-<start>.pcm`, the recording's bytes from
   `start` on, created with complete protection; the Swift channel gains `append`, `size`, `readRange` and `copyTail`.
   Deleting a night deletes its waiting audio (and a cut's temporary file) in the same turn of the store's queue; at
   open, audio no night names is swept (`audioSwept`), and so is an older copy left by an unfinished cut. The phone
   check gains steps 6 and 7 for a probe of silence.
4. **Recording keeps its audio** (D92, D93 Q4 to Q6): a keep (`AudioKeep`), handed about a second at a time and
   forced to the disk at the end; deleted at once when every word is final; otherwise what waits starts at Soniox's
   `final_audio_proc_ms`. No connection at the tap (our own Swift channel over Apple's path monitor): no key asked,
   `recordingOffline`, MP·15. A key, a stream or the budget failing with a connection: the recording goes on, MP·54.
   The ten-minute cap: `recordingCapped`. A keep that fails (`audioKeepFailed`) falls back to D71's behaviour.
5. **The typing screen and SoulDreams Dev's wiring**: the screen saves each recording it left waiting after its words
   (D93 Q2), and keeps a night with nothing typed but a recording waiting (D93 Q7); MP·33 is not announced with no
   connection. `JournalHome` hands the pages a recording that keeps its audio in the journal (`JournalAudio`);
   `main_dev.dart` gives it the phone's connection.
6. **The retries** (D92 items 2, 3; D94; D93 Q3): `Retries`, one at a time, oldest night first, paced at real time;
   progress kept on any cut; held while a typing screen is open; started when the journal opens, the app comes back,
   a typing screen closes or the connection returns; cut when the app leaves. AI·6 on the night's page while it runs.
   The pages reload when words come.
7. **The mutation rows**: 14 older rows follow the code; A144 to A197 new (54 rows).
8. **Status.md**.

### What it does not build

- Any background task, notification, or retry while the app is closed (D92 item 3).
- Soniox's file API, a webhook, or anything on the server, in AWS or in Soniox's settings (D94).
- The shimmer of the waiting labels (How the AI Appears §5): AI·6 shows as a plain app line, a stand-in (banked).
- Keeping the screen awake during a retry: the dreamer's lock pauses it, and the progress is kept.
- Anything in `main.dart` or `main_founder.dart`; the founder app holds no journal yet (D49 O5).

### The decisions, by number

| Ruling | What it settles |
|---|---|
| D92 1 | Every recording's audio kept in the journal's folder until its text is final, then deleted at once |
| D92 2 (restored by D94) | Retries replay the saved audio through the real-time stream, a fresh temporary key each time |
| D92 3 | Retries only while the app is open: launch, foreground, connection back; no background task |
| D92 4 | Deleting a night deletes any audio still waiting for it |
| D92 5 | Plain 16 kHz mono PCM, complete file protection, no codec |
| D93 Q2 | A retried recording's words are a dream of their own, in its place; after a break, the rest is the next dream |
| D93 Q3 | Waiting: nothing in its place; AI·6 while transcribed; the row unchanged; not tappable |
| D93 Q4 | MP·15, MP·54, MP·63 where MP·62 shows, until the next tap; MP·15 heard instead of MP·33 |
| D93 Q5 | At a break, the words not yet final leave the field |
| D93 Q6 | Every recording stops itself at ten minutes |
| D93 Q7 | Nothing typed but a recording waiting keeps the night; empty words remove it; an emptied night is deleted |
| D94 | Route D: real-time replay, progress kept across openings, words may appear in parts |
| Head's message 21 | MP·54 for a cut connection and a reached budget, MP·15 with no connection at the tap; MP·63, MP·64 |

### Decided under D91 (how to build only)

1. **The format.** Version 2 keeps every version-1 key; `dreams` mixes strings and `{"waiting", "from"}` objects.
   `from` is even (whole samples). Two waiting entries with one audio id are refused.
2. **The audio's files.** `audio-<id>-<start>.pcm`; a cut copies the tail to `.tmp-audio-<id>-<from>.pcm`, renames it,
   then deletes the older part, so every step leaves a whole copy. The id is 128 bits from the secure source, never
   sent (R4).
3. **The commit point is the night's file.** Words go into the night in one turn of the queue, and only then is the
   audio cut or deleted: a crash between them leaves audio the night no longer needs, which the next open sweeps, and
   never hears the same words twice (the night's `from` says where to start). The sweep reads every night file's raw
   bytes for `"waiting":"<id>"`, so audio named by a damaged night is never swept (D49 c).
4. **A retry cut short** by a typing screen opening keeps its progress too, as D94 does for the app closing or the
   connection breaking. Its final words become a dream before the waiting one, as D93 Q2 rules for a live break.
5. **An edit finds its dream by its words** when words that came for a recording moved it while its screen was open.
6. **The connection** is our own Swift event channel over `NWPathMonitor` (`souldreams/network`), no package (R10),
   taken as online until the phone says otherwise. MP·15 shows only when the phone says there is no connection at the
   tap; every other failure shows MP·54, which never claims "offline".
7. **A keep that fails** (a full phone) logs `audioKeepFailed` once and falls back to D71: a later break stops the
   recording and shows nothing new, since MP·54 ("it stays on your phone") would be untrue.
8. **The retries**: one at a time, the oldest night first; frames of a tenth of a second paced against a clock; the
   end waits ten seconds for the last words; Soniox's error code, our server's status or 0 is logged
   (`retryFailed`); tried again at the next chance, with no cap on attempts. A recording whose audio is gone is
   simply removed.
9. **AI·6** is an app line (`voiceApp`), a live region, in the waiting dream's place; no shimmer (a stand-in).
10. **A crash during a recording** loses that recording's audio (swept at the next open), as it loses unsaved typing.
11. **The recording plan's Part 4 Q7** (leaving keeps the provisional words) holds only without a keep; with one, D93
    Q5 governs.
12. **A recording heard whole that the journal does not take** (its words never land) stops the retries with
    `retryFailed -3` rather than going round. This check has no mutation row: removing it makes the run hang instead
    of failing a test (it was found that way, by row A179 before the check existed).

### The places this branch uses

MP·15, MP·54 and AI·6 from `lines.g.dart`; MP·63 and MP·64 from `pending.g.dart` (SoulDreams Dev shows their words, any
other flavour their handles); MP·11, MP·33 and MP·62 as before. No new line, no placeholder.

### The tests (test-first, on the Mac)

- **The format** (workflow (c)): every invented night written as version 1 reads whole and saves as version 2, every
  key and dream counted before and after; a journal of version-1 files reads whole and a save rewrites only its own
  night; waiting entries keep their place; every misshapen form refused.
- **The audio files**: appended and read in ranges; a cut keeps only the rest; deleting a night deletes its waiting
  audio and no other's, and its words and ids are nowhere in what remains (workflow (d)); the sweep at open; Delete
  journal takes the audio; the channel's calls and the Swift side's protection.
- **The session**: every frame kept in order; all final, deleted; no connection; a key that fails; a break; a stop
  whose last words never all come; a cancel; nothing past the final words; the cap; a keep that fails.
- **The screen**: MP·63, MP·15, MP·54 and when they go; MP·64; MP·33 withheld offline; Save, leaving and an edit with
  recordings waiting; a failed Save keeps them; the screen holds the retries.
- **The retries**: whole; progress kept on leaving and resumed at the cut; a break; no key; Soniox's error; silence; a
  missing audio; oldest first; holds; away and back; recording off; a night deleted mid-replay; real-time pace.
- **The pages**: AI·6 in its place and then the words; the journal opening retries, leaving cuts, coming back resumes.

## Part 2 · Settings and packages

None change. Every edit is to a path Claude Code may already write; `tool/app_mutations.py` is not under `tool/checks/`
and is edited by its block. **No new package** (R10): the connection comes from our own Swift event channel over
Apple's `Network` framework, which is part of iOS. No new kind of file (G0): Dart, Swift, Python and Markdown only. The
server, AWS and Soniox's settings are untouched (D94).

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

The server is not touched; its checks stay as they are.

### Task 0 · Baselines

From the repository root, on `offline-recording`, with a clean tree:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 && (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- nothing from `git status`;
- the plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+307: All tests passed!`.

Anything else: stop (R14).

### Task 1 · The pending lines MP·63 and MP·64 (head's message 21)

The session tells the screen why a start failed (`Trouble.refused`); the typing screen shows MP·63 where MP·62 shows,
a live region in the button type, cleared at the next tap of the microphone; the microphone's tooltip is MP·64 while
it records. Tests: `typing_page_test.dart` (the old "shows nothing new" test becomes MP·63's; 3 in all).

Expected: 309 app tests. Commit:

> Recording: MP·63 when the microphone is refused, MP·64 names the stop control (head's message 21)

**The block:**

~~~~diff
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
index 09bc227..82bcc8d 100644
--- a/app/lib/journal/pages/typing_page.dart
+++ b/app/lib/journal/pages/typing_page.dart
@@ -17,7 +17,10 @@
 // edit attempt only stops it (D90); while it runs, a level line and a
 // timer show and a screen reader is told
 // MP·33; a stop, Save or Back waits for the last words; leaving the app
-// ends it at once. A failure to start or a break shows nothing new.
+// ends it at once. A refused microphone shows MP·63 where MP·62 shows,
+// until the next tap of the microphone (D93 Q4); while it records, the
+// microphone's spoken name is MP·64. Another failure to start or a break
+// shows nothing new.
 import 'dart:async';
 import 'dart:math';
 
@@ -49,6 +52,7 @@ class TypingPage extends StatefulWidget {
   static const startKey = Key('typing-start');
   static const micKey = Key('typing-mic');
   static const levelKey = Key('typing-level');
+  static const noticeKey = Key('typing-notice');
 
   final Journal journal;
 
@@ -110,6 +114,9 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   ({int caret, int shownLength})? _caret;
   final _levels = <double>[];
   int _seconds = 0;
+  // What the dreamer is told about the recording, until the next tap of the
+  // microphone or the screen closes (D93 Q4).
+  Trouble? _trouble;
   Timer? _ticker;
 
   @override
@@ -209,6 +216,7 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
     if (_saving) return;
     switch (_mic) {
       case _Mic.idle:
+        if (_trouble != null) setState(() => _trouble = null);
         _startRecording();
       case _Mic.recording:
         setState(() => _mic = _Mic.stopping);
@@ -239,6 +247,7 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
       onLevel: _level,
       onStopping: _stopClock,
       onEnded: _ended,
+      onTrouble: _troubled,
     );
     _session = session;
     final started = await session.start();
@@ -367,6 +376,15 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
     });
   }
 
+  void _troubled(Trouble trouble) {
+    if (mounted) setState(() => _trouble = trouble);
+  }
+
+  // What the dreamer is told, by the trouble.
+  String _troubleText(Trouble trouble) => switch (trouble) {
+    Trouble.refused => PendingLines.MP_63.text(appLanguage),
+  };
+
   // A stop began, the dreamer's or a call's: the clock stops at once, while
   // the last words may still come (D83).
   void _stopClock() {
@@ -440,6 +458,7 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
       borderSide: BorderSide(color: p.fieldBorder),
     );
     final live = _live;
+    final trouble = _trouble;
     return PopScope(
       canPop: false,
       onPopInvokedWithResult: (didPop, _) {
@@ -475,6 +494,18 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
                                           (first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),
                                           style: TypeRoles.button.style(p.text),
                                         ),
+                                      if (trouble != null)
+                                        Padding(
+                                          key: TypingPage.noticeKey,
+                                          padding: const EdgeInsets.only(top: StandIns.gap),
+                                          child: Semantics(
+                                            liveRegion: true,
+                                            child: AppLine(
+                                              _troubleText(trouble),
+                                              style: TypeRoles.button.style(p.text),
+                                            ),
+                                          ),
+                                        ),
                                       if (_failed)
                                         Padding(
                                           key: _failure,
@@ -539,7 +570,11 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
                                         ? null
                                         : IconButton(
                                             key: TypingPage.micKey,
-                                            tooltip: Lines.MP_11.text(appLanguage),
+                                            // The stop control's own name while it
+                                            // records (D93; MP·64 replaces MP·11).
+                                            tooltip: live
+                                                ? PendingLines.MP_64.text(appLanguage)
+                                                : Lines.MP_11.text(appLanguage),
                                             isSelected: live,
                                             onPressed: _toggleMic,
                                             icon: Icon(Icons.mic_none, color: p.placeholder),
diff --git a/app/lib/recording/recording.dart b/app/lib/recording/recording.dart
index 12cb811..bb019f3 100644
--- a/app/lib/recording/recording.dart
+++ b/app/lib/recording/recording.dart
@@ -84,6 +84,12 @@ final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
 /// How long a stop waits for Soniox's last words.
 const lastWords = Duration(seconds: 5);
 
+/// What went wrong, for the typing screen to say (D93 Q4): the microphone
+/// refused (MP·63).
+enum Trouble { refused }
+
+void _noTrouble(Trouble _) {}
+
 /// One recording, from the microphone's tap to its end.
 final class RecordingSession {
   RecordingSession(
@@ -92,6 +98,7 @@ final class RecordingSession {
     required this.onLevel,
     required this.onStopping,
     required this.onEnded,
+    this.onTrouble = _noTrouble,
     this.wait = lastWords,
   });
 
@@ -113,6 +120,9 @@ final class RecordingSession {
   /// The recording ended, by a stop or by itself.
   final void Function() onEnded;
 
+  /// Something the dreamer is told (D93 Q4).
+  final void Function(Trouble trouble) onTrouble;
+
   SonioxLink? _link;
   // The audio heard before the stream opened, in memory only (D88).
   final _held = <Uint8List>[];
@@ -142,9 +152,9 @@ final class RecordingSession {
     try {
       allowed = await _recording.microphone.allowed();
     } on Object {
-      return _fail(LogEvent.recordingRefused);
+      return _refused();
     }
-    if (!allowed) return _fail(LogEvent.recordingRefused);
+    if (!allowed) return _refused();
     if (_cancelled || _ended) return false;
     final Stream<Uint8List> frames;
     try {
@@ -219,6 +229,11 @@ final class RecordingSession {
     unawaited(_shut());
   }
 
+  bool _refused() {
+    onTrouble(Trouble.refused);
+    return _fail(LogEvent.recordingRefused);
+  }
+
   bool _fail(LogEvent code, [List<num> numbers = const []]) {
     SafeLog.event(code, numbers);
     return false;
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index 1a9f051..39a4b13 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -733,16 +733,62 @@ void main() {
     expect(find.byKey(TypingPage.levelKey), findsNothing);
   });
 
-  testWidgets('a refused microphone shows nothing new, logs a code', (tester) async {
+  // D93 Q4: a refused microphone shows MP·63 where MP·62 shows, in place of
+  // nothing, until the next tap of the microphone.
+  testWidgets('a refused microphone shows MP·63, logs a code', (tester) async {
     final lines = await logged();
     final v = voice();
     v.mic.allow = false;
     await tall(tester, recording: v.recording);
+    expect(find.byKey(TypingPage.noticeKey), findsNothing);
     await record(tester);
     await tester.pumpAndSettle();
     expect(find.byKey(TypingPage.levelKey), findsNothing);
     expect(tester.takeAnnouncements(), isEmpty);
     expect(lines, ['recordingRefused']);
+    final shown = find.bySemanticsLabel(PendingLines.MP_63.text(Lang.en));
+    expect(shown, findsOneWidget);
+    final live = find.byWidgetPredicate((w) => w is Semantics && w.properties.liveRegion == true);
+    expect(find.descendant(of: find.byKey(TypingPage.noticeKey), matching: live), findsOneWidget);
+    final line = tester.widget<AppLine>(
+      find.descendant(of: find.byKey(TypingPage.noticeKey), matching: find.byType(AppLine)),
+    );
+    expect(line.style.fontSize, TypeRoles.button.size);
+  });
+
+  testWidgets('MP·63 goes at the next tap, and returns on a refusal', (tester) async {
+    final v = voice();
+    v.mic.allow = false;
+    await tall(tester, recording: v.recording);
+    await record(tester);
+    await tester.pumpAndSettle();
+    expect(find.byKey(TypingPage.noticeKey), findsOneWidget);
+    v.mic.allow = true;
+    await record(tester);
+    expect(find.byKey(TypingPage.noticeKey), findsNothing);
+    await tester.tap(find.byKey(TypingPage.micKey));
+    await tester.pump();
+    v.link.reply(reply(finished: true));
+    await tester.pumpAndSettle();
+    v.mic.allow = false;
+    await record(tester);
+    await tester.pumpAndSettle();
+    expect(find.byKey(TypingPage.noticeKey), findsOneWidget);
+  });
+
+  testWidgets('the microphone is named MP·11, and MP·64 while it records', (tester) async {
+    final v = voice();
+    await tall(tester, recording: v.recording);
+    String name() => tester.widget<IconButton>(find.byKey(TypingPage.micKey)).tooltip!;
+    expect(name(), Lines.MP_11.text(Lang.en));
+    await record(tester);
+    expect(name(), PendingLines.MP_64.text(Lang.en));
+    await tester.tap(find.byKey(TypingPage.micKey));
+    await tester.pump();
+    expect(name(), PendingLines.MP_64.text(Lang.en));
+    v.link.reply(reply(finished: true));
+    await tester.pumpAndSettle();
+    expect(name(), Lines.MP_11.text(Lang.en));
   });
 
   // Task 16f-1: after a start that fails, the field is the dreamer's again
~~~~

### Task 2 · The night's file, version 2 (D93 Q2; docs/workflow.md (c))

`Dream` (`Told`, `Waiting`) and `Night.entries`; `Night.dreams` now the told words only; version 2 written, version 1
read; a dream's index counts both kinds; the night's page shows nothing for a waiting dream; the row's opening is
empty when no dream is told. Tests: every version-1 night read and counted (`night_test.dart`), a version-1 journal
read whole and one save rewriting only its night (`journal_store_test.dart`), waiting dreams in place
(`journal_test.dart`, `row_text_test.dart`, `night_page_test.dart`). This task is the storage change and ships alone:
Task 3 rehearses it before Task 4 is applied.

Expected: 318 app tests. Commit:

> Journal: the night's file at version 2, a dream told or waiting; version 1 still read (D93 Q2; workflow (c))

**The block:**

~~~~diff
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
index 54cfd44..565bc4a 100644
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -6,6 +6,8 @@
 // - An edit replaces a dream's text. An emptied dream disappears and the
 //   night's other dreams remain (D58 Q3); a night left with no dream is
 //   deleted, as a deletion deletes it (P10).
+// - A dream is told in words or waits as a recording (D93 Q2); a dream's
+//   index counts both, and a waiting one is never edited.
 import 'dart:math';
 
 import '../words/lines.g.dart' show Lang;
@@ -59,21 +61,22 @@ final class Journal {
       case IntoNight(:final id):
         // One turn of the store's queue: a delete cannot fall between
         // the read and the write, nor another Save lose this one (D61).
-        return _store.update(id, (n) => n.withDreams([...n.dreams, text]));
+        return _store.update(id, (n) => n.withEntries([...n.entries, Told(text)]));
     }
   }
 
-  /// Replaces dream [index] of night [id] with [text].
+  /// Replaces dream [index] of night [id] with [text]. The index counts
+  /// every dream, told or waiting; a waiting one is never replaced.
   Future<void> editDream(String id, int index, String text) async {
     await _store.update(id, (n) {
-      if (index < 0 || index >= n.dreams.length) return n;
-      final dreams = [...n.dreams];
+      if (index < 0 || index >= n.entries.length || n.entries[index] is! Told) return n;
+      final entries = [...n.entries];
       if (isEmptyText(text)) {
-        dreams.removeAt(index);
+        entries.removeAt(index);
       } else {
-        dreams[index] = text;
+        entries[index] = Told(text);
       }
-      return dreams.isEmpty ? null : n.withDreams(dreams);
+      return entries.isEmpty ? null : n.withEntries(entries);
     });
   }
 
diff --git a/app/lib/journal/night.dart b/app/lib/journal/night.dart
index f70b328..d07f5d4 100644
--- a/app/lib/journal/night.dart
+++ b/app/lib/journal/night.dart
@@ -2,7 +2,10 @@
 // file format. Which fields a night holds is settled with Product's
 // answers; until the format first reaches the founder app it may change
 // freely (D49, O5). After that, any change is a storage change
-// (docs/workflow.md, "On-phone storage changes").
+// (docs/workflow.md, "On-phone storage changes"). Version 2 (D92, D93
+// Q2): a dream may be a recording that waits on the phone to be turned
+// into text; version 1 files still read, and are written as version 2
+// when next saved.
 import 'dart:convert';
 import 'dart:math';
 
@@ -11,9 +14,13 @@ import 'package:flutter/foundation.dart';
 import '../words/lines.g.dart' show Lang;
 
 /// The file format's version, written in every night's file.
-const formatVersion = 1;
+const formatVersion = 2;
+
+/// The version before it, still read (docs/workflow.md (c)).
+const _firstVersion = 1;
 
 final _id = RegExp(r'^[0-9a-f]{32}$');
+const _waitingKeys = {'waiting', 'from'};
 final _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
 const _keys = {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'};
 
@@ -41,7 +48,47 @@ bool _isDay(int y, int m, int d) {
   return check.year == y && check.month == m && check.day == d;
 }
 
+/// One of a night's dreams, in order: told in words, or a recording that
+/// waits to be turned into text (D93 Q2).
+sealed class Dream {
+  const Dream();
+}
+
+/// A dream in the dreamer's words.
+final class Told extends Dream {
+  const Told(this.text);
+
+  final String text;
+
+  @override
+  bool operator ==(Object other) => other is Told && other.text == text;
+
+  @override
+  int get hashCode => text.hashCode;
+}
+
+/// A recording kept on the phone until its words come (D92, D94): its
+/// audio's id, and how many bytes from its start are already in words
+/// (always whole samples, so even).
+final class Waiting extends Dream {
+  Waiting(this.audio, [this.from = 0]) {
+    if (!_id.hasMatch(audio)) throw ArgumentError('audio');
+    if (from < 0 || from.isOdd) throw ArgumentError('from');
+  }
+
+  final String audio;
+  final int from;
+
+  @override
+  bool operator ==(Object other) => other is Waiting && other.audio == audio && other.from == from;
+
+  @override
+  int get hashCode => Object.hash(audio, from);
+}
+
 final class Night {
+  /// A night of [dreams] told in words, or of [entries] (told or waiting);
+  /// never both.
   Night({
     required this.id,
     required this.firstRecorded,
@@ -49,8 +96,12 @@ final class Night {
     required this.closes,
     required this.lang,
     this.name,
-    required List<String> dreams,
-  }) : dreams = List.unmodifiable(dreams) {
+    List<String> dreams = const [],
+    List<Dream>? entries,
+  }) : entries = List.unmodifiable(entries ?? [for (final d in dreams) Told(d)]) {
+    if (entries != null && dreams.isNotEmpty) throw ArgumentError('dreams');
+    final audio = [for (final e in this.entries) if (e is Waiting) e.audio];
+    if (audio.toSet().length != audio.length) throw ArgumentError('entries');
     if (!_id.hasMatch(id)) throw ArgumentError('id');
     if (!firstRecorded.isUtc) throw ArgumentError('firstRecorded');
     if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');
@@ -78,12 +129,18 @@ final class Night {
   /// The dreamer's name for the night, if they gave one.
   final String? name;
 
-  /// The dreams, in the dreamer's words, in order.
-  final List<String> dreams;
+  /// The dreams, in order: told, or waiting to be turned into text.
+  final List<Dream> entries;
 
-  /// The same night holding [dreams] instead.
-  Night withDreams(List<String> dreams) => Night(
-      id: id, firstRecorded: firstRecorded, date: date, closes: closes, lang: lang, name: name, dreams: dreams);
+  /// The dreams told in words, in order.
+  List<String> get dreams => List.unmodifiable([for (final e in entries) if (e is Told) e.text]);
+
+  /// The same night holding [entries] instead.
+  Night withEntries(List<Dream> entries) => Night(
+      id: id, firstRecorded: firstRecorded, date: date, closes: closes, lang: lang, name: name, entries: entries);
+
+  /// The same night holding [dreams], all told, instead.
+  Night withDreams(List<String> dreams) => withEntries([for (final d in dreams) Told(d)]);
 
   @override
   bool operator ==(Object other) =>
@@ -94,10 +151,10 @@ final class Night {
       other.closes == closes &&
       other.lang == lang &&
       other.name == name &&
-      listEquals(other.dreams, dreams);
+      listEquals(other.entries, entries);
 
   @override
-  int get hashCode => Object.hash(id, firstRecorded, date, closes, lang, name, Object.hashAll(dreams));
+  int get hashCode => Object.hash(id, firstRecorded, date, closes, lang, name, Object.hashAll(entries));
 }
 
 String _two(int n) => n.toString().padLeft(2, '0');
@@ -111,11 +168,30 @@ Uint8List encodeNight(Night n) => utf8.encode(jsonEncode({
       'closes': n.closes.toIso8601String(),
       'lang': n.lang.name,
       'name': n.name,
-      'dreams': n.dreams,
+      'dreams': [
+        for (final e in n.entries)
+          switch (e) {
+            Told(:final text) => text,
+            Waiting(:final audio, :final from) => {'waiting': audio, 'from': from},
+          },
+      ],
     }));
 
-/// The night in [bytes], or null when they are not a whole night of this
-/// format. Nothing is guessed or repaired.
+// One dream as its file holds it: words, or (from version 2) a waiting
+// recording; null when it is neither.
+Dream? _dreamOf(Object? x, int version) {
+  if (x is String) return Told(x);
+  if (version == _firstVersion || x is! Map<String, Object?> || !setEquals(x.keys.toSet(), _waitingKeys)) {
+    return null;
+  }
+  final audio = x['waiting'];
+  final from = x['from'];
+  if (audio is! String || !_id.hasMatch(audio) || from is! int || from < 0 || from.isOdd) return null;
+  return Waiting(audio, from);
+}
+
+/// The night in [bytes], or null when they are not a whole night of
+/// version 1 or 2. Nothing is guessed or repaired.
 Night? decodeNight(Uint8List bytes) {
   final Object? json;
   try {
@@ -126,7 +202,7 @@ Night? decodeNight(Uint8List bytes) {
   if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _keys)) return null;
   if (json
       case {
-        'version': formatVersion,
+        'version': final int version,
         'id': final String id,
         'firstRecorded': final String recorded,
         'date': final String date,
@@ -139,11 +215,15 @@ Night? decodeNight(Uint8List bytes) {
     final shut = DateTime.tryParse(closes);
     final d = _date.firstMatch(date);
     final language = Lang.values.where((l) => l.name == lang).firstOrNull;
+    if (version != formatVersion && version != _firstVersion) return null;
     if (!_id.hasMatch(id) || at == null || !at.isUtc || d == null || language == null) return null;
     if (shut == null || !shut.isUtc || !shut.isAfter(at) || shut.difference(at) > maxOpen) return null;
     final (y, m, day) = (int.parse(d[1]!), int.parse(d[2]!), int.parse(d[3]!));
     if (!_isDay(y, m, day)) return null;
-    if (dreams.any((x) => x is! String)) return null;
+    final entries = [for (final x in dreams) _dreamOf(x, version)];
+    if (entries.contains(null)) return null;
+    final audio = [for (final e in entries) if (e is Waiting) e.audio];
+    if (audio.toSet().length != audio.length) return null;
     return Night(
       id: id,
       firstRecorded: at,
@@ -151,7 +231,7 @@ Night? decodeNight(Uint8List bytes) {
       closes: shut,
       lang: language,
       name: name,
-      dreams: dreams.cast<String>(),
+      entries: entries.cast<Dream>(),
     );
   }
   return null;
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index e9cce8c..9f12995 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -4,8 +4,10 @@
 // "delete this night" (EM·11's second part), plain; one confirmation, the
 // phone's standard dialog, Cancel first and Delete destructive (MP·61,
 // MP·60, pending lines); the dreams under "Dreams" (MP·38), each opening
-// the typing screen to edit it; "Add dreams" (MP·29). Not built: naming,
-// Start Interpretation, and the space below the dreams.
+// the typing screen to edit it; "Add dreams" (MP·29). A recording that
+// waits to be turned into text shows nothing in its place and cannot be
+// tapped (D93 Q3). Not built: naming, Start Interpretation, and the space
+// below the dreams.
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 
@@ -164,10 +166,11 @@ class _NightPageState extends State<NightPage> {
                     ),
                     Align(alignment: Alignment.centerLeft, child: SectionLabel(Lines.MP_38.text(appLanguage))),
                     const SizedBox(height: StandIns.gap),
-                    for (final (i, d) in n.dreams.indexed) ...[
-                      DreamBubble(d, onTap: () => _type((id: n.id, index: i, text: d))),
-                      const SizedBox(height: StandIns.bubbleGap),
-                    ],
+                    for (final (i, d) in n.entries.indexed)
+                      if (d case Told(:final text)) ...[
+                        DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
+                        const SizedBox(height: StandIns.bubbleGap),
+                      ],
                     const SizedBox(height: StandIns.gap),
                     Center(
                       child: KeyedSubtree(
diff --git a/app/lib/journal/row_text.dart b/app/lib/journal/row_text.dart
index e8561b5..42faf1a 100644
--- a/app/lib/journal/row_text.dart
+++ b/app/lib/journal/row_text.dart
@@ -15,9 +15,12 @@ import 'night.dart';
 
 final _wordChar = RegExp(r'[\p{L}\p{N}]', unicode: true);
 
-/// The first dream's opening, with its framing trimmed.
+/// The first told dream's opening, with its framing trimmed; nothing for
+/// a night whose dreams all wait (D93 Q3: the row shows its date alone).
 String opening(Night night) {
-  final dream = night.dreams.first;
+  final told = night.dreams;
+  if (told.isEmpty) return '';
+  final dream = told.first;
   final framings = [...(night.lang == Lang.en ? ListWords.tech1En : ListWords.tech1Sv)]
     ..sort((a, b) => b.length.compareTo(a.length));
   for (final f in framings) {
diff --git a/app/test/journal/journal_store_test.dart b/app/test/journal/journal_store_test.dart
index 7fef3ec..0497bec 100644
--- a/app/test/journal/journal_store_test.dart
+++ b/app/test/journal/journal_store_test.dart
@@ -113,6 +113,38 @@ void main() {
     expect(lines, isEmpty);
   });
 
+  // docs/workflow.md (c): a journal written in version 1 reads whole; a save
+  // rewrites only its own night, as version 2, and loses nothing.
+  test('a version-1 journal reads whole; a save rewrites one night', () async {
+    final nights = nightsFromFixtures();
+    await files.open();
+    for (final n in nights) {
+      await files.write(
+        JournalStore.fileOf(n.id),
+        utf8.encode(jsonEncode({...jsonDecode(utf8.decode(encodeNight(n))) as Map<String, Object?>, 'version': 1})),
+      );
+    }
+    final before = files.everything();
+    final store = await JournalStore.open(files);
+    final read = await store.nights();
+    expect(read, nights);
+    expect(read.fold<int>(0, (sum, n) => sum + n.dreams.length), nights.fold<int>(0, (s, n) => s + n.dreams.length));
+    final changed = nights[1].withDreams([...nights[1].dreams, 'x']);
+    await store.save(changed);
+    final after = files.everything();
+    expect(after.keys.toSet(), before.keys.toSet());
+    for (final n in nights) {
+      final name = JournalStore.fileOf(n.id);
+      if (n == nights[1]) {
+        expect(jsonDecode(utf8.decode(after[name]!))['version'], 2);
+      } else {
+        expect(listEquals(after[name], before[name]), isTrue, reason: name);
+      }
+    }
+    expect(await store.nights(), [for (final n in nights) n == nights[1] ? changed : n]);
+    expect(lines, isEmpty);
+  });
+
   test('deleting a night leaves nothing of it anywhere', () async {
     final store = await JournalStore.open(files);
     final nights = nightsFromFixtures();
@@ -246,7 +278,7 @@ void main() {
       'night-${'a' * 32}.json': utf8.encode('not json'),
       'night-${'b' * 32}.json': Uint8List.fromList([0xff, 0xfe, 0x00]),
       'night-${'c' * 32}.json': wrongId,
-      'night-${'d' * 32}.json': utf8.encode(utf8.decode(encodeNight(good)).replaceFirst('"version":1', '"version":2')),
+      'night-${'d' * 32}.json': utf8.encode(utf8.decode(encodeNight(good)).replaceFirst('"version":2', '"version":3')),
     };
     for (final MapEntry(:key, :value) in bad.entries) {
       await files.write(key, value);
diff --git a/app/test/journal/journal_test.dart b/app/test/journal/journal_test.dart
index a096167..c62625c 100644
--- a/app/test/journal/journal_test.dart
+++ b/app/test/journal/journal_test.dart
@@ -8,6 +8,7 @@ import 'dart:math';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/journal/journal.dart';
 import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_rules.dart';
 import 'package:souldreams/words/lines.g.dart' show Lang;
 
@@ -33,6 +34,25 @@ void main() {
 
   tearDown(() => dir.deleteSync(recursive: true));
 
+  // D93 Q2: a dream's index counts waiting recordings too, and a waiting
+  // one is never edited; a night left with only one stays.
+  test('an edit counts waiting dreams, and never replaces one', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    final n = (await journal.newestFirst()).single;
+    final w = Waiting('c' * 32);
+    await (await JournalStore.open(files)).save(n.withEntries([w, ...n.entries]));
+    Future<List<Dream>> entries() async => (await journal.night(n.id))!.entries;
+    await journal.editDream(n.id, 0, b[0]);
+    expect(await entries(), [w, Told(a[0])]);
+    await journal.editDream(n.id, 1, b[0]);
+    expect(await entries(), [w, Told(b[0])]);
+    await journal.addDream(IntoNight(n.id), a[1], Lang.en);
+    expect(await entries(), [w, Told(b[0]), Told(a[1])]);
+    await journal.editDream(n.id, 1, ' ');
+    await journal.editDream(n.id, 1, '');
+    expect(await entries(), [w]);
+  });
+
   test('an empty Save keeps nothing', () async {
     for (final text in ['', '  \n ']) {
       expect(await journal.addDream(await journal.targetNow(), text, Lang.en), isFalse);
diff --git a/app/test/journal/night_test.dart b/app/test/journal/night_test.dart
index 765e056..ed79e1d 100644
--- a/app/test/journal/night_test.dart
+++ b/app/test/journal/night_test.dart
@@ -1,4 +1,5 @@
-// A night and its file format, version 1 (D49 b).
+// A night and its file format: version 2 written, version 1 still read
+// (D49 b; D92, D93 Q2; docs/workflow.md (c)).
 import 'dart:convert';
 import 'dart:math';
 import 'dart:typed_data';
@@ -13,6 +14,14 @@ Map<String, Object?> fields(Night n) =>
 
 Uint8List bytesOf(Map<String, Object?> json) => utf8.encode(jsonEncode(json));
 
+/// The night as a version-1 file held it: the same fields, version 1, the
+/// dreams as words only.
+Uint8List versionOne(Night n) => bytesOf({...fields(n), 'version': 1});
+
+/// Two waiting recordings' ids, made up for the tests.
+final audioA = 'a' * 32;
+final audioB = '0123456789abcdef' * 2;
+
 void main() {
   test('every invented night survives encoding and decoding', () {
     for (final n in nightsFromFixtures()) {
@@ -20,12 +29,12 @@ void main() {
     }
   });
 
-  test('the file holds exactly the version-1 fields', () {
+  test('the file holds exactly the version-2 fields', () {
     final n = nightsFromFixtures().first;
     final json = fields(n);
     expect(json.keys.toSet(),
         {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'});
-    expect(json['version'], 1);
+    expect(json['version'], 2);
     expect(json['id'], n.id);
     expect(json['firstRecorded'], '2026-10-12T06:40:00.000Z');
     expect(json['date'], '2026-10-12');
@@ -34,7 +43,85 @@ void main() {
     expect(json['dreams'], n.dreams);
   });
 
-  test('anything not a version-1 night decodes to null', () {
+  // docs/workflow.md (c): the old format loads, and the new one loses
+  // nothing; every night, dream and field counted before and after.
+  test('every version-1 night reads whole and saves as version 2', () {
+    final nights = nightsFromFixtures();
+    var dreams = 0;
+    for (final n in nights) {
+      final old = jsonDecode(utf8.decode(versionOne(n))) as Map<String, Object?>;
+      final read = decodeNight(versionOne(n));
+      expect(read, n);
+      final saved = fields(read!);
+      expect(saved['version'], 2);
+      expect(saved.keys.toSet(), old.keys.toSet());
+      for (final key in old.keys.where((k) => k != 'version')) {
+        expect(saved[key], old[key], reason: '${n.id} $key');
+      }
+      expect(read.entries, [for (final d in old['dreams'] as List<Object?>) Told(d as String)]);
+      dreams += read.dreams.length;
+    }
+    expect(nights.length, inventedNights().length);
+    expect(dreams, inventedNights().fold<int>(0, (sum, n) => sum + n.dreams.length));
+  });
+
+  test('a waiting recording keeps its place among the told dreams', () {
+    final n = nightsFromFixtures().first;
+    final night = n.withEntries([Told(n.dreams.first), Waiting(audioA, 64000), Told('x'), Waiting(audioB)]);
+    expect(fields(night)['dreams'], [
+      n.dreams.first,
+      {'waiting': audioA, 'from': 64000},
+      'x',
+      {'waiting': audioB, 'from': 0},
+    ]);
+    expect(decodeNight(encodeNight(night)), night);
+    expect(night.dreams, [n.dreams.first, 'x']);
+    expect(decodeNight(encodeNight(n.withEntries([Waiting(audioA)])))!.dreams, isEmpty);
+  });
+
+  test('a waiting recording is refused in a version-1 file', () {
+    final n = nightsFromFixtures().first.withEntries([Waiting(audioA)]);
+    expect(decodeNight(bytesOf({...fields(n), 'version': 1})), isNull);
+  });
+
+  test('a misshapen waiting recording, or one twice, decodes to null', () {
+    final good = fields(nightsFromFixtures().first);
+    for (final (i, dreams) in [
+      [{'waiting': audioA}],
+      [{'waiting': audioA, 'from': 0, 'extra': 1}],
+      [{'waiting': 'A' * 32, 'from': 0}],
+      [{'waiting': audioA, 'from': -2}],
+      [{'waiting': audioA, 'from': 3}],
+      [{'waiting': audioA, 'from': 2.0}],
+      [{'waiting': audioA, 'from': '0'}],
+      [{'waiting': audioA, 'from': 0}, {'waiting': audioA, 'from': 2}],
+      [<Object?>[]],
+    ].indexed) {
+      expect(decodeNight(bytesOf({...good, 'dreams': dreams})), isNull, reason: 'case $i');
+    }
+  });
+
+  test('a waiting recording with a bad id or from is refused', () {
+    expect(() => Waiting('x'), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'audio')));
+    expect(() => Waiting(audioA, -2), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'from')));
+    expect(() => Waiting(audioA, 1), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'from')));
+    final n = nightsFromFixtures().first;
+    expect(() => n.withEntries([Waiting(audioA), Waiting(audioA, 2)]), throwsArgumentError);
+    expect(
+      () => Night(
+        id: n.id,
+        firstRecorded: n.firstRecorded,
+        date: n.date,
+        closes: n.closes,
+        lang: n.lang,
+        dreams: n.dreams,
+        entries: [Waiting(audioA)],
+      ),
+      throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'dreams')),
+    );
+  });
+
+  test('anything not a version-1 or version-2 night decodes to null', () {
     final good = fields(nightsFromFixtures().first);
     Map<String, Object?> without(String key) => {...good}..remove(key);
     Map<String, Object?> with_(String key, Object? value) => {...good, key: value};
@@ -44,7 +131,9 @@ void main() {
       utf8.encode('[]'),
       bytesOf(without('dreams')),
       bytesOf(with_('extra', 1)),
-      bytesOf(with_('version', 2)),
+      bytesOf(with_('version', 0)),
+      bytesOf(with_('version', 3)),
+      bytesOf(with_('version', '2')),
       bytesOf(with_('id', 'ABC')),
       bytesOf(with_('firstRecorded', '2026-10-12T06:40:00.000')),
       bytesOf(with_('firstRecorded', 'tomorrow')),
@@ -118,6 +207,7 @@ void main() {
   test("a night's dreams cannot be changed in place", () {
     final n = nightsFromFixtures().first;
     expect(() => n.dreams.add('x'), throwsUnsupportedError);
+    expect(() => n.entries.add(const Told('x')), throwsUnsupportedError);
   });
 
   test('a closing instant over 26 hours on is refused as damaged', () {
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index 3242e8b..c7b0d46 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -109,6 +109,28 @@ void main() {
     expect((await h.journal.night(n.id))!.dreams, [n.dreams[0], other]);
   });
 
+  // D93 Q3: a waiting recording shows nothing and cannot be tapped; the
+  // told dreams around it keep their places.
+  testWidgets('a waiting recording shows nothing; edits keep the order', (tester) async {
+    await open(tester);
+    final w1 = Waiting('1' * 32);
+    final w2 = Waiting('2' * 32);
+    await h.store.save(n.withEntries([w1, Told(n.dreams[0]), w2, Told(n.dreams[1])]));
+    await tester.tap(find.byType(BackControl));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(DreamBubble), findsNWidgets(2));
+    expect(tester.getTopLeft(find.text(n.dreams[0])).dy, lessThan(tester.getTopLeft(find.text(n.dreams[1])).dy));
+    await tester.tap(find.text(n.dreams[1]));
+    await tester.pumpAndSettle();
+    final other = invented('one-dream-sv').dreams.single;
+    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect((await h.journal.night(n.id))!.entries, [w1, Told(n.dreams[0]), w2, Told(other)]);
+  });
+
   testWidgets('an emptied dream disappears; the others remain', (tester) async {
     await open(tester);
     await tester.tap(find.text(n.dreams[0]));
diff --git a/app/test/journal/row_text_test.dart b/app/test/journal/row_text_test.dart
index 67c01aa..7542054 100644
--- a/app/test/journal/row_text_test.dart
+++ b/app/test/journal/row_text_test.dart
@@ -29,6 +29,13 @@ void main() {
   final rest = invented('two-dreams-en').dreams.first;
   final restSv = invented('one-dream-sv').dreams.first;
 
+  // D93 Q3: a night whose dreams all wait shows its date alone.
+  test('the opening is the first told dream; none when all wait', () {
+    final n = told(rest);
+    expect(opening(n.withEntries([Waiting('e' * 32), Told(restSv)])), restSv);
+    expect(opening(n.withEntries([Waiting('e' * 32)])), '');
+  });
+
   test('each framing is trimmed from the very start, ignoring case', () {
     for (final f in ListWords.tech1En) {
       expect(opening(told('$f $rest')), rest, reason: f);
~~~~

### Task 3 · [OWNER] Rehearse the night file's version 2 (docs/workflow.md (c), steps 1 to 3)

The storage change ships alone: this rehearsal runs on Task 2's commit, before Task 4 lands. Invented nights only
(R2). The Cohort 0 app holds no journal yet (D49 O5), so steps 4 and 5 of (c) do not apply now; they will when the
journal first reaches it, at version 2.

1. Build and install SoulDreams Dev from `main` (version 1), as usual.

   Paste 1 — Terminal
   ```
   cd ~/Developer/soul-dreams-app && git status --short && git checkout main && git log --oneline -1
   ```
   Expected: nothing from `git status`; `main`'s last commit.

2. In SoulDreams Dev, type three invented nights from `fixtures/invented-nights.json`, one of them with two dreams.
   Close the app. Xcode → Devices → SoulDreams Dev → Download Container, and keep it as the "before" copy, outside
   the repository.

3. Paste 3 — Terminal
   ```
   cd ~/Developer/soul-dreams-app && git checkout offline-recording && git log --oneline -1
   ```
   Expected: Task 2's commit. Build and install SoulDreams Dev from it, over the old one (never delete it).

4. Check by eye: the same nights, the same dates, every dream in its order and words; edit one dream and save; the
   others unchanged. Download the container again: the edited night's file says `"version":2`, the others still
   `"version":1`, and nothing else is new in `Library/Application Support/Journal`.

Bring the result as a checklist. Anything different: stop (R14).

### Task 4 · The audio in the journal's folder (D92 items 1, 4, 5)

`JournalFiles` gains `append`, `size`, `readRange` and `copyTail` (the Swift channel, the memory and Mac folders);
`JournalStore` gains `audioOf`, `appendAudio`, `audioPart`, `readAudio`, `cutAudio` and `discardAudio`; deleting a
night deletes its waiting audio; the sweep at open (`audioSwept`); the phone check's steps 6 and 7. Tests:
`journal_store_test.dart` (7), `channel_journal_files_test.dart` (1, and the Swift side's methods, keys and
protection), `self_check_test.dart` (1).

Expected: 327 app tests. Commit:

> Journal: a recording's audio kept in the journal's folder, deleted with its night (D92 items 1, 4, 5)

**The block:**

~~~~diff
diff --git a/app/ios/Runner/AppDelegate.swift b/app/ios/Runner/AppDelegate.swift
index 6503e2d..477470f 100644
--- a/app/ios/Runner/AppDelegate.swift
+++ b/app/ios/Runner/AppDelegate.swift
@@ -66,7 +66,10 @@ enum AudioSession {
 // Support/Journal, excluded from backup, the folder and every file with
 // complete file protection. Plain file operations; the store's rules are
 // in Dart (lib/journal/). A failure answers with a code only, never a
-// path or a message (R3).
+// path or a message (R3). A recording's audio is kept here too until its
+// words come (D92): appended as it is recorded, every file created with
+// complete protection, read back in ranges, and its front cut away by
+// copying the rest to a new file (D94).
 enum JournalFiles {
   static let channelName = "souldreams/journal_files"
   private static func allowed(_ c: Unicode.Scalar) -> Bool {
@@ -74,7 +77,7 @@ enum JournalFiles {
       || c == "." || c == "_" || c == "-"
   }
 
-  enum Failure: Error { case name, arguments, rename, flush, delete }
+  enum Failure: Error { case name, arguments, rename, flush, delete, create }
 
   static func channel(messenger: FlutterBinaryMessenger) -> FlutterMethodChannel {
     let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
@@ -153,6 +156,48 @@ enum JournalFiles {
       let url = try file(call.arguments)
       if fm.fileExists(atPath: url.path) { try fm.removeItem(at: url) }
       return nil
+    case "append":
+      let a = try arguments(call)
+      guard let bytes = a["bytes"] as? FlutterStandardTypedData, let sync = a["sync"] as? Bool else {
+        throw Failure.arguments
+      }
+      let url = try file(a["name"])
+      if !fm.fileExists(atPath: url.path) {
+        guard fm.createFile(
+          atPath: url.path, contents: nil, attributes: [.protectionKey: FileProtectionType.complete])
+        else { throw Failure.create }
+      }
+      let handle = try FileHandle(forWritingTo: url)
+      defer { try? handle.close() }
+      try handle.seekToEnd()
+      try handle.write(contentsOf: bytes.data)
+      if sync { try flush(url) }
+      return nil
+    case "size":
+      let url = try file(call.arguments)
+      guard fm.fileExists(atPath: url.path) else { return nil }
+      return (try fm.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.int64Value
+    case "readRange":
+      let a = try arguments(call)
+      guard let offset = a["offset"] as? Int, let length = a["length"] as? Int, offset >= 0, length >= 0 else {
+        throw Failure.arguments
+      }
+      let handle = try FileHandle(forReadingFrom: try file(a["name"]))
+      defer { try? handle.close() }
+      try handle.seek(toOffset: UInt64(offset))
+      return FlutterStandardTypedData(bytes: try handle.read(upToCount: length) ?? Data())
+    case "copyTail":
+      let a = try arguments(call)
+      guard let offset = a["offset"] as? Int, offset >= 0 else { throw Failure.arguments }
+      let from = try file(a["from"])
+      let to = try file(a["to"])
+      let handle = try FileHandle(forReadingFrom: from)
+      defer { try? handle.close() }
+      try handle.seek(toOffset: UInt64(offset))
+      let rest = try handle.readToEnd() ?? Data()
+      try rest.write(to: to, options: [.completeFileProtection])
+      try flush(to)
+      return nil
     case "deleteAll":
       // Every entry, whatever its name (D54): one that cannot be removed
       // does not stop the others, and the call then answers with a code.
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index 75993bc..ef297c3 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -17,6 +17,10 @@ enum LogEvent {
   journalCheckPassed,
   journalCheckFailed,
 
+  /// A recording's audio that no night names, or an older copy of it,
+  /// removed when the journal opens (D92).
+  audioSwept,
+
   /// SoulDreams Dev's journal could not open its folder (journal-screens).
   journalOpenFailed,
 
diff --git a/app/lib/journal/channel_journal_files.dart b/app/lib/journal/channel_journal_files.dart
index d606a81..a3af670 100644
--- a/app/lib/journal/channel_journal_files.dart
+++ b/app/lib/journal/channel_journal_files.dart
@@ -38,6 +38,26 @@ final class ChannelJournalFiles implements JournalFiles, JournalProtection {
   @override
   Future<void> delete(String name) => _channel.invokeMethod<void>('delete', _checked(name));
 
+  @override
+  Future<void> append(String name, Uint8List bytes, {bool sync = false}) =>
+      _channel.invokeMethod<void>('append', {'name': _checked(name), 'bytes': bytes, 'sync': sync});
+
+  @override
+  Future<int?> size(String name) => _channel.invokeMethod<int>('size', _checked(name));
+
+  @override
+  Future<Uint8List> readRange(String name, int offset, int length) async =>
+      await _channel.invokeMethod<Uint8List>('readRange', {
+        'name': _checked(name),
+        'offset': offset,
+        'length': length,
+      }) ??
+      Uint8List(0);
+
+  @override
+  Future<void> copyTail(String from, String to, int offset) =>
+      _channel.invokeMethod<void>('copyTail', {'from': _checked(from), 'to': _checked(to), 'offset': offset});
+
   @override
   Future<void> deleteAll() => _channel.invokeMethod<void>('deleteAll');
 
diff --git a/app/lib/journal/journal_files.dart b/app/lib/journal/journal_files.dart
index 2d3c30b..6c88d23 100644
--- a/app/lib/journal/journal_files.dart
+++ b/app/lib/journal/journal_files.dart
@@ -2,7 +2,9 @@
 // named files. On the phone it is Library/Application Support/Journal,
 // excluded from backup, every file with complete file protection
 // (ChannelJournalFiles and AppDelegate.swift). In tests, a folder on the
-// Mac.
+// Mac. A recording's audio is kept here too, until its words come (D92):
+// appended as it is recorded, read back in ranges, and cut from the front
+// as its words arrive (D94).
 import 'dart:typed_data';
 
 final _name = RegExp(r'^[A-Za-z0-9._-]+$');
@@ -30,6 +32,20 @@ abstract interface class JournalFiles {
   /// Deletes the file; nothing happens when there is none.
   Future<void> delete(String name);
 
+  /// Adds [bytes] at the file's end, creating it if needed; with [sync],
+  /// the file's bytes are forced to the disk.
+  Future<void> append(String name, Uint8List bytes, {bool sync = false});
+
+  /// The file's size in bytes, or null when there is no such file.
+  Future<int?> size(String name);
+
+  /// Up to [length] of the file's bytes from [offset]; fewer at its end.
+  Future<Uint8List> readRange(String name, int offset, int length);
+
+  /// Writes the bytes of [from] after its first [offset] to [to], replacing
+  /// it, forced to the disk.
+  Future<void> copyTail(String from, String to, int offset);
+
   /// Deletes every entry in the folder, whatever its name (D54): files and
   /// anything else, and it does not stop at one it cannot name.
   Future<void> deleteAll();
diff --git a/app/lib/journal/journal_store.dart b/app/lib/journal/journal_store.dart
index dd1e3c7..864063f 100644
--- a/app/lib/journal/journal_store.dart
+++ b/app/lib/journal/journal_store.dart
@@ -10,6 +10,16 @@
 // delete can never fall between a save's write and its rename, and a
 // save in flight can never bring a night back after the journal is
 // deleted. A save that fails removes its own temporary file.
+//
+// A recording's audio (D92, D94) is kept in the same folder until its
+// words come: `audio-<id>-<start>.pcm`, plain 16 kHz mono PCM, holding
+// the recording's bytes from `start` on. A night names it while it waits
+// (a Waiting dream); deleting the night deletes it (D92 item 4). When
+// part of its words have come, the part they cover is cut away: the rest
+// is copied to a file with the later start, which then replaces it. At
+// open, audio no night names is deleted, and so is an older copy left by
+// a cut that did not finish.
+import 'dart:convert';
 import 'dart:typed_data';
 
 import 'package:flutter/foundation.dart' show visibleForTesting;
@@ -20,6 +30,13 @@ import 'night.dart';
 
 final _nightFile = RegExp(r'^night-([0-9a-f]{32})\.json$');
 final _id = RegExp(r'^[0-9a-f]{32}$');
+final _audioFile = RegExp(r'^audio-([0-9a-f]{32})-(0|[1-9][0-9]{0,9})\.pcm$');
+// How a night's file names a waiting recording (encodeNight's own form).
+final _named = RegExp(r'"waiting":"([0-9a-f]{32})"');
+
+/// What is left on the phone of a recording: its bytes from [start] of
+/// the recording on, [size] of them.
+typedef AudioPart = ({int start, int size});
 
 final class JournalStore {
   JournalStore._(this._files);
@@ -56,7 +73,16 @@ final class JournalStore {
     return 'night-$id.json';
   }
 
-  /// Opens the folder, and removes what an interrupted save left.
+  /// The name of the file holding recording [id]'s bytes from [start] on.
+  static String audioOf(String id, int start) {
+    if (!_id.hasMatch(id)) throw ArgumentError('id');
+    if (start < 0 || start.isOdd) throw ArgumentError('start');
+    return 'audio-$id-$start.pcm';
+  }
+
+  /// Opens the folder, and removes what an interrupted save left, and any
+  /// audio no night names (an interrupted recording, or a night deleted
+  /// before its audio was).
   static Future<JournalStore> open(JournalFiles files) => _run(() async {
     await files.open();
     for (final name in await files.list()) {
@@ -65,9 +91,38 @@ final class JournalStore {
         SafeLog.event(LogEvent.journalTempSwept);
       }
     }
+    final names = await files.list();
+    final named = <String>{};
+    for (final name in names.where(_nightFile.hasMatch)) {
+      final bytes = await files.read(name);
+      if (bytes != null) named.addAll(_namedIn(bytes));
+    }
+    final newest = <String, int>{};
+    for (final (id, start) in _audio(names)) {
+      if (named.contains(id) && start > (newest[id] ?? -1)) newest[id] = start;
+    }
+    for (final (id, start) in _audio(names)) {
+      if (newest[id] != start) {
+        await files.delete(audioOf(id, start));
+        SafeLog.event(LogEvent.audioSwept);
+      }
+    }
     return JournalStore._(files);
   });
 
+  // The recordings a night's file names, read from its bytes whether or
+  // not it reads as a night, so a damaged night's audio is never swept.
+  static Set<String> _namedIn(Uint8List bytes) =>
+      {for (final m in _named.allMatches(utf8.decode(bytes, allowMalformed: true))) m[1]!};
+
+  // Every audio file in [names]: its recording's id and its start.
+  static Iterable<(String, int)> _audio(List<String> names) sync* {
+    for (final name in names) {
+      final m = _audioFile.firstMatch(name);
+      if (m != null) yield (m[1]!, int.parse(m[2]!));
+    }
+  }
+
   /// Every night that reads, earliest first recording first.
   Future<List<Night>> nights() => _run(() async {
     final out = <Night>[];
@@ -128,13 +183,68 @@ final class JournalStore {
     return true;
   });
 
-  /// Deletes the night's file, and the temporary file of a save of it.
+  /// Deletes the night's file, the temporary file of a save of it, and the
+  /// audio of every recording of it still waiting (D92 item 4).
   Future<void> delete(String id) => _run(() => _delete(id));
 
   Future<void> _delete(String id) async {
     final name = fileOf(id);
+    final bytes = await _files.read(name);
     await _files.delete(name);
     await _files.delete(tempPrefix + name);
+    if (bytes == null) return;
+    for (final audio in _namedIn(bytes)) {
+      await _discard(audio);
+    }
+  }
+
+  /// Adds [bytes] to recording [id]'s audio, as it is recorded; with
+  /// [sync], forced to the disk (at the recording's end).
+  Future<void> appendAudio(String id, Uint8List bytes, {bool sync = false}) =>
+      _run(() => _files.append(audioOf(id, 0), bytes, sync: sync));
+
+  /// What is left of recording [id], or null when nothing is.
+  Future<AudioPart?> audioPart(String id) => _run(() => _part(id));
+
+  Future<AudioPart?> _part(String id) async {
+    if (!_id.hasMatch(id)) throw ArgumentError('id');
+    int? start;
+    for (final (audio, s) in _audio(await _files.list())) {
+      if (audio == id && s > (start ?? -1)) start = s;
+    }
+    if (start == null) return null;
+    final size = await _files.size(audioOf(id, start));
+    return size == null ? null : (start: start, size: size);
+  }
+
+  /// Up to [length] bytes of recording [id] from [at], counted from the
+  /// recording's start, out of the part that begins at [start].
+  Future<Uint8List> readAudio(String id, int start, int at, int length) =>
+      _run(() => _files.readRange(audioOf(id, start), at - start, length));
+
+  /// Cuts away recording [id]'s bytes before [from], whose words are now
+  /// in its night (D94): the rest is copied to a part that starts at
+  /// [from], which then replaces the older one.
+  Future<void> cutAudio(String id, int from) => _run(() async {
+    final part = await _part(id);
+    if (part == null || part.start >= from) return;
+    final next = audioOf(id, from);
+    await _files.copyTail(audioOf(id, part.start), tempPrefix + next, from - part.start);
+    await _files.rename(tempPrefix + next, next);
+    await _files.delete(audioOf(id, part.start));
+  });
+
+  /// Deletes every part of recording [id] (its words are all in, or none
+  /// will come).
+  Future<void> discardAudio(String id) => _run(() => _discard(id));
+
+  // Every part, and any temporary file of a cut of it.
+  Future<void> _discard(String id) async {
+    if (!_id.hasMatch(id)) throw ArgumentError('id');
+    for (final name in await _files.list()) {
+      final bare = name.startsWith(tempPrefix) ? name.substring(tempPrefix.length) : name;
+      if (_audioFile.firstMatch(bare)?[1] == id) await _files.delete(name);
+    }
   }
 
   /// Deletes every entry in the journal's folder, whatever its name.
diff --git a/app/lib/journal/self_check.dart b/app/lib/journal/self_check.dart
index 86765ee..b73a2dd 100644
--- a/app/lib/journal/self_check.dart
+++ b/app/lib/journal/self_check.dart
@@ -1,10 +1,14 @@
 // The phone check (D49 c; the plan's Task 13): SoulDreams Dev runs it
 // once when built with --dart-define=JOURNAL_SELF_CHECK=true. It saves a
 // probe night, reads back the folder's backup flag and both protection
-// classes, reads the probe, deletes it, and checks no file names it. It
-// logs journalCheckPassed, or journalCheckFailed with the step's number.
-// The probe holds one marker word, never a dream; the owner looks for
-// it in the downloaded container, and must not find it.
+// classes, reads the probe, deletes it, and checks no file names it. Then
+// the same for a probe recording's audio (D92): a second of silence
+// appended and forced to the disk, its protection, read back, discarded.
+// It logs journalCheckPassed, or journalCheckFailed with the step's
+// number. The probe holds one marker word, never a dream; the owner looks
+// for it in the downloaded container, and must not find it.
+import 'dart:typed_data';
+
 import '../core/safe_log.dart';
 import '../words/lines.g.dart' show Lang;
 import 'journal_files.dart';
@@ -18,6 +22,7 @@ Future<bool> journalSelfCheck(JournalFiles files, JournalProtection protection,
     {DateTime? now}) async {
   var step = 1;
   String? probeId;
+  String? audioId;
   JournalStore? store;
   try {
     store = await JournalStore.open(files);
@@ -41,6 +46,18 @@ Future<bool> journalSelfCheck(JournalFiles files, JournalProtection protection,
     await store.delete(probe.id);
     probeId = null;
     if ((await files.list()).any((n) => n.contains(probe.id))) return _failed(step);
+    step = 6;
+    final silence = Uint8List(32000);
+    final audio = audioId = newNightId();
+    await store.appendAudio(audio, silence, sync: true);
+    final a = await protection.protection(JournalStore.audioOf(audio, 0));
+    if (!a.excluded || !a.folderComplete || !a.fileComplete) return _failed(step);
+    step = 7;
+    final back = await store.readAudio(audio, 0, 0, silence.length);
+    if (back.length != silence.length || back.any((b) => b != 0)) return _failed(step);
+    await store.discardAudio(audio);
+    audioId = null;
+    if ((await files.list()).any((n) => n.contains(audio))) return _failed(step);
     SafeLog.event(LogEvent.journalCheckPassed);
     return true;
   } on Object {
@@ -53,6 +70,13 @@ Future<bool> journalSelfCheck(JournalFiles files, JournalProtection protection,
         // The failure is already logged; the owner's container check finds the probe.
       }
     }
+    if (store != null && audioId != null) {
+      try {
+        await store.discardAudio(audioId);
+      } on Object {
+        // As above: the next open sweeps audio no night names.
+      }
+    }
   }
 }
 
diff --git a/app/test/journal/channel_journal_files_test.dart b/app/test/journal/channel_journal_files_test.dart
index 9a120b4..b84c7c4 100644
--- a/app/test/journal/channel_journal_files_test.dart
+++ b/app/test/journal/channel_journal_files_test.dart
@@ -44,6 +44,37 @@ void main() {
     expect(calls[6].arguments, isNull);
   });
 
+  // D92, D94: the audio's calls.
+  test("the audio's calls have their names and arguments", () async {
+    const files = ChannelJournalFiles();
+    final bytes = Uint8List.fromList([1, 2]);
+    await files.append('a.pcm', bytes);
+    await files.append('a.pcm', bytes, sync: true);
+    await files.size('a.pcm');
+    await files.readRange('a.pcm', 64, 32);
+    await files.copyTail('a.pcm', 'b.pcm', 64);
+    expect([for (final c in calls) c.method], ['append', 'append', 'size', 'readRange', 'copyTail']);
+    expect(calls[0].arguments, {'name': 'a.pcm', 'bytes': bytes, 'sync': false});
+    expect(calls[1].arguments, {'name': 'a.pcm', 'bytes': bytes, 'sync': true});
+    expect(calls[2].arguments, 'a.pcm');
+    expect(calls[3].arguments, {'name': 'a.pcm', 'offset': 64, 'length': 32});
+    expect(calls[4].arguments, {'from': 'a.pcm', 'to': 'b.pcm', 'offset': 64});
+    answer = (call) => switch (call.method) {
+          'size' => 7,
+          'readRange' => Uint8List.fromList([9]),
+          _ => null,
+        };
+    expect(await files.size('a.pcm'), 7);
+    expect(await files.readRange('a.pcm', 0, 1), [9]);
+    answer = (_) => null;
+    expect(await files.size('a.pcm'), isNull);
+    expect(await files.readRange('a.pcm', 0, 1), isEmpty);
+    calls.clear();
+    expect(() => files.append('../a', bytes), throwsArgumentError);
+    expect(() => files.copyTail('a.pcm', '..', 0), throwsArgumentError);
+    expect(calls, isEmpty);
+  });
+
   test('answers come back as the store expects', () async {
     const files = ChannelJournalFiles();
     answer = (call) => switch (call.method) {
@@ -79,10 +110,34 @@ void main() {
   test('the Swift side answers every method this side calls', () {
     final swift = File('ios/Runner/AppDelegate.swift').readAsStringSync();
     expect(swift, contains('"$journalChannel"'));
-    for (final m in ['open', 'list', 'read', 'write', 'rename', 'delete', 'deleteAll', 'protection']) {
+    for (final m in [
+      'open',
+      'list',
+      'read',
+      'write',
+      'rename',
+      'delete',
+      'deleteAll',
+      'protection',
+      'append',
+      'size',
+      'readRange',
+      'copyTail',
+    ]) {
       expect(swift, contains('case "$m":'), reason: m);
     }
-    for (final k in ['name', 'bytes', 'from', 'to', 'excluded', 'folderComplete', 'fileComplete']) {
+    for (final k in [
+      'name',
+      'bytes',
+      'from',
+      'to',
+      'excluded',
+      'folderComplete',
+      'fileComplete',
+      'sync',
+      'offset',
+      'length',
+    ]) {
       expect(swift, contains('"$k"'), reason: k);
     }
     expect(swift, contains('.completeFileProtection'));
@@ -90,7 +145,11 @@ void main() {
     // D54: the bytes are flushed to the disk before the rename that
     // publishes them, and delete-all goes through every entry.
     expect(swift, contains('F_FULLFSYNC'));
-    expect(swift, contains('try flush(url)'));
+    expect(swift, contains('try bytes.data.write(to: url, options: [.completeFileProtection])\n      try flush(url)'));
     expect(swift, contains('contentsOfDirectory(atPath: dir.path)'));
+    // D92 item 5: the audio, created and copied under complete protection.
+    expect(swift, contains('attributes: [.protectionKey: FileProtectionType.complete]'));
+    expect(swift, contains('try rest.write(to: to, options: [.completeFileProtection])'));
+    expect(swift, contains('try flush(to)'));
   });
 }
diff --git a/app/test/journal/io_journal_files.dart b/app/test/journal/io_journal_files.dart
index 69ed8dd..7569484 100644
--- a/app/test/journal/io_journal_files.dart
+++ b/app/test/journal/io_journal_files.dart
@@ -43,6 +43,33 @@ class IoJournalFiles implements JournalFiles {
     if (f.existsSync()) f.deleteSync();
   }
 
+  @override
+  Future<void> append(String name, Uint8List bytes, {bool sync = false}) async =>
+      _file(name).writeAsBytesSync(bytes, mode: FileMode.append, flush: sync);
+
+  @override
+  Future<int?> size(String name) async {
+    final f = _file(name);
+    return f.existsSync() ? f.lengthSync() : null;
+  }
+
+  @override
+  Future<Uint8List> readRange(String name, int offset, int length) async {
+    final f = _file(name).openSync();
+    try {
+      f.setPositionSync(offset);
+      return f.readSync(length);
+    } finally {
+      f.closeSync();
+    }
+  }
+
+  @override
+  Future<void> copyTail(String from, String to, int offset) async {
+    final bytes = _file(from).readAsBytesSync();
+    _file(to).writeAsBytesSync(bytes.sublist(offset.clamp(0, bytes.length)), flush: true);
+  }
+
   @override
   Future<void> deleteAll() async {
     for (final e in dir.listSync()) {
diff --git a/app/test/journal/journal_store_test.dart b/app/test/journal/journal_store_test.dart
index 0497bec..d411e83 100644
--- a/app/test/journal/journal_store_test.dart
+++ b/app/test/journal/journal_store_test.dart
@@ -36,6 +36,9 @@ List<List<int>> traces(Night n) => [
       utf8.encode(n.id),
     ];
 
+/// [n] bytes of made-up audio, every byte telling its place.
+Uint8List sound(int n, [int from = 0]) => Uint8List.fromList([for (var i = from; i < from + n; i++) i % 251]);
+
 /// The rename fails: a save interrupted between its two steps.
 final class BrokenRename extends IoJournalFiles {
   BrokenRename(super.dir);
@@ -145,6 +148,115 @@ void main() {
     expect(lines, isEmpty);
   });
 
+  // D92 item 1: a recording's audio is kept in the journal's folder,
+  // appended as it comes, read back in ranges.
+  test('audio grows as appended, and reads back in ranges', () async {
+    final store = await JournalStore.open(files);
+    final id = 'a' * 32;
+    await store.appendAudio(id, sound(6400));
+    await store.appendAudio(id, sound(3200, 6400), sync: true);
+    expect(files.everything().keys, [JournalStore.audioOf(id, 0)]);
+    expect(await store.audioPart(id), (start: 0, size: 9600));
+    expect(await store.readAudio(id, 0, 6000, 1000), sound(1000, 6000));
+    expect(await store.readAudio(id, 0, 9000, 1000), sound(600, 9000));
+    expect(await store.audioPart('b' * 32), isNull);
+  });
+
+  // D94: the part whose words are in is cut away; the rest keeps its place.
+  test('a cut keeps only the rest, under its new start', () async {
+    final store = await JournalStore.open(files);
+    final id = 'a' * 32;
+    await store.appendAudio(id, sound(64000), sync: true);
+    await store.cutAudio(id, 32000);
+    expect(files.everything().keys, [JournalStore.audioOf(id, 32000)]);
+    expect(await store.audioPart(id), (start: 32000, size: 32000));
+    expect(await store.readAudio(id, 32000, 40000, 100), sound(100, 40000));
+    await store.cutAudio(id, 32000);
+    await store.cutAudio(id, 2);
+    expect(files.everything().keys, [JournalStore.audioOf(id, 32000)]);
+    await store.cutAudio(id, 64000);
+    expect(await store.audioPart(id), (start: 64000, size: 0));
+  });
+
+  test('a misshapen audio id or start is refused before any file', () {
+    expect(() => JournalStore.audioOf('A' * 32, 0), throwsArgumentError);
+    expect(() => JournalStore.audioOf('a' * 32, 3), throwsArgumentError);
+    expect(() => JournalStore.audioOf('a' * 32, -2), throwsArgumentError);
+    expect(JournalStore.audioOf('a' * 32, 64000), 'audio-${'a' * 32}-64000.pcm');
+  });
+
+  // D92 item 4 (R11; workflow (d)): deleting a night deletes the audio of
+  // every recording of it still waiting, and nothing of another night.
+  test("deleting a night deletes its waiting audio, no other's", () async {
+    final store = await JournalStore.open(files);
+    final [first, second, ...] = nightsFromFixtures();
+    final (x, y, z) = ('1' * 32, '2' * 32, '3' * 32);
+    await store.save(first.withEntries([...first.entries, Waiting(x), Waiting(y, 32000)]));
+    await store.save(second.withEntries([Waiting(z), ...second.entries]));
+    for (final id in [x, y, z]) {
+      await store.appendAudio(id, sound(64000));
+    }
+    await store.cutAudio(y, 32000);
+    await files.write('${JournalStore.tempPrefix}${JournalStore.audioOf(x, 640)}', sound(10));
+    await store.delete(first.id);
+    final after = files.everything();
+    expect(after.keys.toSet(), {JournalStore.fileOf(second.id), JournalStore.audioOf(z, 0)});
+    for (final bytes in after.values) {
+      for (final t in [...traces(first), utf8.encode(x), utf8.encode(y)]) {
+        expect(holds(bytes, t), isFalse);
+      }
+    }
+  });
+
+  test('discarding a recording removes every part of it', () async {
+    final store = await JournalStore.open(files);
+    final id = 'a' * 32;
+    await store.appendAudio(id, sound(64000));
+    await files.write(JournalStore.audioOf(id, 32000), sound(10));
+    await store.discardAudio(id);
+    expect(files.everything(), isEmpty);
+  });
+
+  // An interrupted recording, a night deleted before its audio, or a cut
+  // that did not finish leaves audio no night needs: swept at open.
+  test('at open, audio no night names is swept with a code', () async {
+    await files.open();
+    final [first, second, ...] = nightsFromFixtures();
+    final (kept, old, damaged, loose) = ('1' * 32, '2' * 32, '3' * 32, '4' * 32);
+    await files.write(JournalStore.fileOf(first.id), encodeNight(first.withEntries([Waiting(kept), Waiting(old, 64)])));
+    final unreadable = utf8.decode(encodeNight(second.withEntries([Waiting(damaged)])));
+    final damagedBytes = utf8.encode(unreadable.replaceFirst('"version":2', '"version":3'));
+    await files.write(JournalStore.fileOf(second.id), damagedBytes);
+    for (final name in [
+      JournalStore.audioOf(kept, 0),
+      JournalStore.audioOf(old, 0),
+      JournalStore.audioOf(old, 64),
+      JournalStore.audioOf(damaged, 0),
+      JournalStore.audioOf(loose, 0),
+      JournalStore.audioOf(loose, 64),
+    ]) {
+      await files.write(name, sound(128));
+    }
+    await JournalStore.open(files);
+    expect(files.everything().keys.toSet(), {
+      JournalStore.fileOf(first.id),
+      JournalStore.fileOf(second.id),
+      JournalStore.audioOf(kept, 0),
+      JournalStore.audioOf(old, 64),
+      JournalStore.audioOf(damaged, 0),
+    });
+    expect(lines, ['audioSwept', 'audioSwept', 'audioSwept']);
+  });
+
+  test('deleting the journal takes the audio too', () async {
+    final store = await JournalStore.open(files);
+    final first = nightsFromFixtures().first;
+    await store.save(first.withEntries([Waiting('1' * 32)]));
+    await store.appendAudio('1' * 32, sound(640));
+    await store.deleteAll();
+    expect(files.everything(), isEmpty);
+  });
+
   test('deleting a night leaves nothing of it anywhere', () async {
     final store = await JournalStore.open(files);
     final nights = nightsFromFixtures();
diff --git a/app/test/journal/memory_journal_files.dart b/app/test/journal/memory_journal_files.dart
index 5241b6c..bb64078 100644
--- a/app/test/journal/memory_journal_files.dart
+++ b/app/test/journal/memory_journal_files.dart
@@ -42,6 +42,34 @@ class MemoryJournalFiles implements JournalFiles {
     files.remove(name);
   }
 
+  @override
+  Future<void> append(String name, Uint8List bytes, {bool sync = false}) async {
+    _check(name);
+    files[name] = Uint8List.fromList([...?files[name], ...bytes]);
+  }
+
+  @override
+  Future<int?> size(String name) async {
+    _check(name);
+    return files[name]?.length;
+  }
+
+  @override
+  Future<Uint8List> readRange(String name, int offset, int length) async {
+    _check(name);
+    final bytes = files[name]!;
+    final start = offset.clamp(0, bytes.length);
+    return Uint8List.fromList(bytes.sublist(start, (start + length).clamp(start, bytes.length)));
+  }
+
+  @override
+  Future<void> copyTail(String from, String to, int offset) async {
+    _check(from);
+    _check(to);
+    final bytes = files[from]!;
+    files[to] = Uint8List.fromList(bytes.sublist(offset.clamp(0, bytes.length)));
+  }
+
   @override
   Future<void> deleteAll() async => files.clear();
 }
diff --git a/app/test/journal/self_check_test.dart b/app/test/journal/self_check_test.dart
index 2ea8317..710957b 100644
--- a/app/test/journal/self_check_test.dart
+++ b/app/test/journal/self_check_test.dart
@@ -21,6 +21,13 @@ final class Says implements JournalProtection {
 
 const all = Says((excluded: true, folderComplete: true, fileComplete: true));
 
+/// Every protection in place but the audio file's.
+final class AudioUnprotected implements JournalProtection {
+  @override
+  Future<Protection> protection(String name) async =>
+      (excluded: true, folderComplete: true, fileComplete: !name.startsWith('audio-'));
+}
+
 final class NoRename extends IoJournalFiles {
   NoRename(super.dir);
 
@@ -65,6 +72,14 @@ void main() {
     }
   });
 
+  // D92 item 5: the audio's own file must have complete protection.
+  test('an unprotected audio file fails at step 6, leaving nothing', () async {
+    final files = IoJournalFiles(dir);
+    expect(await journalSelfCheck(files, AudioUnprotected()), isFalse);
+    expect(lines, ['journalCheckFailed 6']);
+    expect(files.everything(), isEmpty);
+  });
+
   test('a save that cannot finish fails at step 2', () async {
     final files = NoRename(dir);
     expect(await journalSelfCheck(files, all), isFalse);
~~~~

### Task 5 · Recording keeps its audio (D92; D93 Q4 to Q6)

`AudioKeep`, `Connection` (`ChannelConnection` over the Swift channel `souldreams/network`), `Trouble.offline` and
`Trouble.broke`; the session keeps every frame, deletes the audio when every word is final, and otherwise leaves
what waits from `final_audio_proc_ms` (`RecordingSession.left`); no connection, a key, a stream or the budget failing:
the recording goes on; the ten-minute cap. Without a keep, nothing changes (every older test passes as it was).
Tests: `recording_test.dart` (12), `soniox_test.dart` (1), `connection_test.dart` (2).

Expected: 342 app tests. Commit:

> Recording: every recording's audio kept until its words are final; no connection or a break, it goes on (D92, D93)

**The block:**

~~~~diff
diff --git a/app/ios/Runner/AppDelegate.swift b/app/ios/Runner/AppDelegate.swift
index 477470f..f9834d7 100644
--- a/app/ios/Runner/AppDelegate.swift
+++ b/app/ios/Runner/AppDelegate.swift
@@ -1,11 +1,14 @@
 import AVFoundation
 import Flutter
+import Network
 import UIKit
 
 @main
 @objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
   private var journalChannel: FlutterMethodChannel?
   private var audioChannel: FlutterMethodChannel?
+  private var networkChannel: FlutterEventChannel?
+  private let networkWatch = NetworkWatch()
 
   override func application(
     _ application: UIApplication,
@@ -32,6 +35,38 @@ import UIKit
     if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AudioSession") {
       audioChannel = AudioSession.channel(messenger: registrar.messenger())
     }
+    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "NetworkWatch") {
+      let channel = FlutterEventChannel(name: NetworkWatch.channelName, binaryMessenger: registrar.messenger())
+      channel.setStreamHandler(networkWatch)
+      networkChannel = channel
+    }
+  }
+}
+
+// Whether the phone has a connection, as the phone knows it (D92 item 3;
+// D93 Q4): Apple's path monitor, one true or false at each change, on the
+// main thread. It sends nothing anywhere (R10). Reached from SoulDreams Dev
+// only (lib/recording/connection.dart).
+final class NetworkWatch: NSObject, FlutterStreamHandler {
+  static let channelName = "souldreams/network"
+  private var monitor: NWPathMonitor?
+
+  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
+    monitor?.cancel()
+    let next = NWPathMonitor()
+    next.pathUpdateHandler = { path in
+      let online = path.status == .satisfied
+      DispatchQueue.main.async { events(online) }
+    }
+    next.start(queue: DispatchQueue(label: "souldreams.network"))
+    monitor = next
+    return nil
+  }
+
+  func onCancel(withArguments arguments: Any?) -> FlutterError? {
+    monitor?.cancel()
+    monitor = nil
+    return nil
   }
 }
 
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index ef297c3..1ce1552 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -53,6 +53,13 @@ enum LogEvent {
   recordingInterrupted,
   recordingEnded,
   recordingReleaseFailed,
+
+  /// A recording begun with no connection, its audio kept to wait (D93
+  /// Q4); one stopped by itself at ten minutes (D93 Q6); its audio that
+  /// could not be kept on the phone (D92).
+  recordingOffline,
+  recordingCapped,
+  audioKeepFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
index 82bcc8d..cd6e563 100644
--- a/app/lib/journal/pages/typing_page.dart
+++ b/app/lib/journal/pages/typing_page.dart
@@ -383,6 +383,8 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   // What the dreamer is told, by the trouble.
   String _troubleText(Trouble trouble) => switch (trouble) {
     Trouble.refused => PendingLines.MP_63.text(appLanguage),
+    Trouble.offline => Lines.MP_15.text(appLanguage),
+    Trouble.broke => Lines.MP_54.text(appLanguage),
   };
 
   // A stop began, the dreamer's or a call's: the clock stops at once, while
diff --git a/app/lib/recording/audio_keep.dart b/app/lib/recording/audio_keep.dart
new file mode 100644
index 0000000..baa9046
--- /dev/null
+++ b/app/lib/recording/audio_keep.dart
@@ -0,0 +1,19 @@
+// Where a recording's audio is kept on the phone until its words come
+// (D92 item 1): the journal's folder, backup-excluded, under complete
+// protection, reached through lib/journal/. Nothing here names a file or
+// a folder; the session only hands its audio on.
+import 'dart:typed_data';
+
+abstract interface class AudioKeep {
+  /// A new recording's id: 128 bits from the system's secure source, as
+  /// 32 hex digits. It names the audio on the phone only, never sent (R4).
+  String newId();
+
+  /// Adds [bytes] to recording [id]'s audio, in order; [last] at its end,
+  /// when the audio is forced to the disk.
+  Future<void> add(String id, Uint8List bytes, {bool last = false});
+
+  /// Deletes recording [id]'s audio: its words are all in (D92 item 1), or
+  /// none will come.
+  Future<void> discard(String id);
+}
diff --git a/app/lib/recording/connection.dart b/app/lib/recording/connection.dart
new file mode 100644
index 0000000..9841f42
--- /dev/null
+++ b/app/lib/recording/connection.dart
@@ -0,0 +1,43 @@
+// Whether the phone has a connection, as the phone itself knows it
+// (D92 item 3; D93 Q4): through Apple's network path monitor, by our own
+// Swift event channel in ios/Runner/AppDelegate.swift, which sends one
+// true or false at each change and nothing else, and sends nothing
+// anywhere (R10). Built into all three apps, reached from SoulDreams Dev
+// only.
+import 'dart:async';
+
+import 'package:flutter/services.dart';
+
+const networkChannel = 'souldreams/network';
+
+abstract interface class Connection {
+  /// Whether the phone has a way out now. True until the phone says.
+  bool get online;
+
+  /// Each change, as it comes.
+  Stream<bool> get changes;
+}
+
+final class ChannelConnection implements Connection {
+  ChannelConnection([EventChannel channel = const EventChannel(networkChannel)]) {
+    channel.receiveBroadcastStream().listen(
+      (event) {
+        if (event is! bool || event == _online) return;
+        _online = event;
+        _changes.add(event);
+      },
+      // A channel that fails says nothing: the phone is taken as online,
+      // and a failure there shows as a key or a stream that fails.
+      onError: (Object _) {},
+    );
+  }
+
+  bool _online = true;
+  final _changes = StreamController<bool>.broadcast();
+
+  @override
+  bool get online => _online;
+
+  @override
+  Stream<bool> get changes => _changes.stream;
+}
diff --git a/app/lib/recording/recording.dart b/app/lib/recording/recording.dart
index bb019f3..61fb7ba 100644
--- a/app/lib/recording/recording.dart
+++ b/app/lib/recording/recording.dart
@@ -1,17 +1,28 @@
 // Recording by voice, in SoulDreams Dev (D69, as D71 corrects it): the
 // words appear as the dreamer speaks, and the audio goes from the
-// microphone to Soniox and nowhere else; nothing of it is written on the
-// phone. A recording starts the instant the microphone is tapped (D88): the
-// microphone first, its audio held in memory until the stream opens and
-// then sent first, in order; a key may be fetched in advance. This slice
-// needs a connection: a key or a stream that fails stops the recording as a
-// broken stream does, holding nothing, keeping the words shown. Each logs a
-// code and shows nothing new (D71). Offline recording is the next slice.
+// microphone to Soniox and nowhere else off the phone. A recording starts
+// the instant the microphone is tapped (D88): the microphone first, its
+// audio held in memory until the stream opens and then sent first, in
+// order; a key may be fetched in advance.
+//
+// Offline recording (D92 to D94): with a keep, every recording's audio is
+// also kept on the phone from its first frame. When all its words are
+// final, the audio is deleted at once. With no connection at the tap
+// (MP·15), or a key, a stream or Soniox's budget that fails (MP·54), the
+// recording goes on into the keep alone; what is not yet in final words
+// waits, from Soniox's `final_audio_proc_ms` on, and the words not yet
+// final leave the field, since they come back with the rest (D93 Q4, Q5).
+// Every recording stops itself at ten minutes, as Stop does (D93 Q6).
+// Without a keep, or once it fails, a key or a stream that fails stops the
+// recording as a broken stream does, keeping the words shown (D71).
 import 'dart:async';
+import 'dart:math' as math;
 import 'dart:typed_data';
 
 import '../core/hosts.dart';
 import '../core/safe_log.dart';
+import 'audio_keep.dart';
+import 'connection.dart';
 import 'key_client.dart';
 import 'microphone.dart';
 import 'soniox.dart';
@@ -23,26 +34,56 @@ final class Recording {
     required this.microphone,
     required this.key,
     required this.connect,
+    this.keep,
+    this.connection,
+    this.cap = recordingCap,
     DateTime Function()? now,
   }) : _now = now ?? DateTime.now;
 
   /// SoulDreams Dev's own: our server for the key, Soniox's EU endpoint for
   /// the words. Off while the server's address is empty, or the build's
   /// beta key is not 48 characters of A-Z, a-z and 0-9 (D18; D71 Q17).
-  factory Recording.live({required Microphone microphone, required String betaKey, String server = Hosts.server}) =>
-      Recording(
-        on: server.isNotEmpty && _betaShape.hasMatch(betaKey),
-        microphone: microphone,
-        key: () => fetchKey(Uri.parse(server), betaKey),
-        connect: (key) => SocketLink.open(Hosts.soniox, key),
-      );
+  factory Recording.live({
+    required Microphone microphone,
+    required String betaKey,
+    String server = Hosts.server,
+    Connection? connection,
+  }) => Recording(
+    on: server.isNotEmpty && _betaShape.hasMatch(betaKey),
+    microphone: microphone,
+    key: () => fetchKey(Uri.parse(server), betaKey),
+    connect: (key) => SocketLink.open(Hosts.soniox, key),
+    connection: connection,
+  );
 
   final bool on;
   final Microphone microphone;
   final Future<String> Function() key;
   final Future<SonioxLink> Function(String key) connect;
+
+  /// Where the audio waits on the phone (D92), or null: nothing kept, and a
+  /// recording needs a connection (D71).
+  final AudioKeep? keep;
+
+  /// Whether the phone has a connection; null: taken as online.
+  final Connection? connection;
+
+  /// The bytes of audio at which a recording stops itself (D93 Q6).
+  final int cap;
   final DateTime Function() _now;
 
+  /// The same recording, keeping its audio in [keep].
+  Recording keeping(AudioKeep keep) => Recording(
+    on: on,
+    microphone: microphone,
+    key: key,
+    connect: connect,
+    keep: keep,
+    connection: connection,
+    cap: cap,
+    now: _now,
+  );
+
   // A key fetched in advance (D88): single use, and used only while fresh.
   Future<String>? _ahead;
   DateTime? _aheadAt;
@@ -84,9 +125,20 @@ final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
 /// How long a stop waits for Soniox's last words.
 const lastWords = Duration(seconds: 5);
 
+/// A second of audio: 16 kHz, sixteen bits, one channel.
+const bytesPerSecond = sampleRate * 2;
+
+/// Every recording stops itself at ten minutes (D93 Q6).
+const recordingCap = 10 * 60 * bytesPerSecond;
+
+/// What a recording leaves to wait (D94): its audio's id, and how many of
+/// its bytes are already in final words.
+typedef Left = ({String audio, int from});
+
 /// What went wrong, for the typing screen to say (D93 Q4): the microphone
-/// refused (MP·63).
-enum Trouble { refused }
+/// refused (MP·63); no connection at the tap (MP·15); a key, a stream or
+/// Soniox's budget that failed with one, the audio kept to wait (MP·54).
+enum Trouble { refused, offline, broke }
 
 void _noTrouble(Trouble _) {}
 
@@ -132,10 +184,33 @@ final class RecordingSession {
   StreamSubscription<String>? _replies;
   StreamSubscription<Uint8List>? _frames;
   StreamSubscription<void>? _interruptions;
+  // Done when the wait for the last words can end: Soniox finished, the
+  // stream went while a stop waits, or the session ended.
   final _finished = Completer<void>();
   bool _cancelled = false;
   bool _ended = false;
 
+  // The audio kept on the phone (D92): its id, what is not yet handed on,
+  // whether the keep failed; the bytes recorded, and those in final words.
+  String? _audio;
+  final _unkept = BytesBuilder(copy: false);
+  bool _keepFailed = false;
+  int _recorded = 0;
+  int _covered = 0;
+  // Every word final: Soniox finished after the end frame.
+  bool _allFinal = false;
+  // No stream any more, or none at all: the audio goes to the keep only.
+  bool _cut = false;
+  bool _capped = false;
+
+  /// What waits once the session has ended, or null: nothing kept, or every
+  /// word final (D94).
+  Left? get left => _left;
+  Left? _left;
+
+  // The audio is kept and the keep has not failed.
+  bool get _keeping => _audio != null && !_keepFailed;
+
   // The microphone has been started and not yet stopped, whether or not its
   // frames are listened to yet.
   bool _micStarted = false;
@@ -163,6 +238,7 @@ final class RecordingSession {
       return _fail(LogEvent.recordingMicFailed);
     }
     _micStarted = true;
+    _audio = _recording.keep?.newId();
     final stopping = _stopping;
     if (_cancelled || _ended || stopping != null) {
       // The session ended, or a stop came, while the microphone started: it
@@ -172,13 +248,22 @@ final class RecordingSession {
       return false;
     }
     _frames = frames.listen((frame) {
+      _keep(frame);
       final link = _link;
-      if (link != null) {
+      if (_cut) {
+        // The keep has it all.
+      } else if (link != null) {
         link.add(frame);
       } else {
         _held.add(frame);
       }
       onLevel(level(frame));
+      _recorded += frame.length;
+      if (_recorded >= _recording.cap && !_capped) {
+        _capped = true;
+        SafeLog.event(LogEvent.recordingCapped);
+        unawaited(stop());
+      }
     });
     // A call or Siri stops the recording as Stop does: the words heard
     // stay (D79 b).
@@ -187,10 +272,48 @@ final class RecordingSession {
       unawaited(stop());
     });
     SafeLog.event(LogEvent.recordingStarted);
-    _opening = _open();
+    if (_keeping && !(_recording.connection?.online ?? true)) {
+      // No connection at the tap: no key is asked for; the audio waits
+      // (D93 Q4, MP·15).
+      _cut = true;
+      SafeLog.event(LogEvent.recordingOffline);
+      onTrouble(Trouble.offline);
+    } else {
+      _opening = _open();
+    }
     return true;
   }
 
+  // A frame into the keep, handed on about once a second (D92).
+  void _keep(Uint8List frame) {
+    if (!_keeping) return;
+    _unkept.add(frame);
+    if (_unkept.length >= bytesPerSecond) _handOn();
+  }
+
+  void _handOn({bool last = false}) {
+    final audio = _audio;
+    if (audio == null || _keepFailed) return;
+    final bytes = _unkept.takeBytes();
+    if (bytes.isEmpty && !last) return;
+    _recording.keep!.add(audio, bytes, last: last).catchError((Object _) {
+      if (_keepFailed) return;
+      _keepFailed = true;
+      SafeLog.event(LogEvent.audioKeepFailed);
+    });
+  }
+
+  // The stream is gone or never came, with the audio kept: the recording
+  // goes on into the keep alone (D92); the words not yet final leave the
+  // field, since they come back with the rest (D93 Q5); MP·54 shows.
+  void _goOn() {
+    _cut = true;
+    _held.clear();
+    onHeard('', '');
+    onTrouble(Trouble.broke);
+    if (_stopping != null && !_finished.isCompleted) _finished.complete();
+  }
+
   // The key and the stream, while the microphone already streams (D88).
   Future<void> _open() async {
     final String key;
@@ -222,11 +345,16 @@ final class RecordingSession {
     _held.clear();
   }
 
-  // No key or no stream: as a break, holding nothing (D88).
+  // No key or no stream: as a break, holding nothing (D88); with the audio
+  // kept, the recording goes on (D92).
   void _brokeOff(LogEvent code, int number) {
     if (_ended) return;
     SafeLog.event(code, [number]);
-    unawaited(_shut());
+    if (_keeping) {
+      _goOn();
+    } else {
+      unawaited(_shut());
+    }
   }
 
   bool _refused() {
@@ -242,19 +370,31 @@ final class RecordingSession {
   void _reply(String text) {
     if (_ended) return;
     switch (readReply(text)) {
-      case Heard(:final finalText, :final provisional, :final finished):
+      case Heard(:final finalText, :final provisional, :final finished, :final finalMs):
+        _covered = math.max(_covered, finalMs * bytesPerSecond ~/ 1000);
         if (finalText.isNotEmpty || provisional.isNotEmpty || finished) onHeard(finalText, provisional);
+        if (finished) _allFinal = true;
         if (finished && !_finished.isCompleted) _finished.complete();
       case Refused(:final code):
         _broke(code);
     }
   }
 
-  // The stream broke off before its end: the words shown stay.
+  // The stream broke off before its end: the words shown stay; with the
+  // audio kept, the recording goes on and the rest waits (D92, D93 Q5).
   void _broke(int code) {
-    if (_ended || _finished.isCompleted) return;
+    if (_ended || _finished.isCompleted || _cut) return;
     SafeLog.event(LogEvent.recordingStreamFailed, [code]);
-    unawaited(_shut());
+    if (!_keeping) {
+      unawaited(_shut());
+      return;
+    }
+    final link = _link;
+    _link = null;
+    unawaited(_replies?.cancel());
+    _replies = null;
+    if (link != null) _closeQuietly(link);
+    _goOn();
   }
 
   /// Stops: the microphone off, then Soniox's last words, waited for up to
@@ -325,8 +465,25 @@ final class RecordingSession {
     final link = _link;
     _link = null;
     unawaited(replies?.cancel());
+    _settleAudio();
     SafeLog.event(LogEvent.recordingEnded);
     onEnded();
     if (link != null) _closeQuietly(link);
   }
+
+  // The audio, once the recording is over: deleted at once when every word
+  // is final, or nothing was recorded past the final words; else it waits
+  // from there, and the words not yet final leave the field (D93 Q5, D94).
+  void _settleAudio() {
+    final audio = _audio;
+    if (audio == null) return;
+    final from = math.min(_covered, _recorded) & ~1;
+    if (_keepFailed || _allFinal || _recorded <= from) {
+      _recording.keep!.discard(audio).catchError((Object _) {});
+      return;
+    }
+    _handOn(last: true);
+    _left = (audio: audio, from: from);
+    onHeard('', '');
+  }
 }
diff --git a/app/lib/recording/soniox.dart b/app/lib/recording/soniox.dart
index 93d4d2b..7c86366 100644
--- a/app/lib/recording/soniox.dart
+++ b/app/lib/recording/soniox.dart
@@ -30,11 +30,15 @@ sealed class SonioxReply {
 /// Words heard: the newly final ones, and the provisional ones now shown
 /// in place of the last.
 final class Heard extends SonioxReply {
-  const Heard(this.finalText, this.provisional, {required this.finished});
+  const Heard(this.finalText, this.provisional, {required this.finished, this.finalMs = 0});
 
   final String finalText;
   final String provisional;
 
+  /// How much of the audio, in milliseconds from the stream's start, is in
+  /// final words: Soniox's `final_audio_proc_ms` (D94).
+  final int finalMs;
+
   /// Soniox has sent everything and will close.
   final bool finished;
 }
@@ -71,7 +75,13 @@ SonioxReply readReply(String text) {
     if (_markers.contains(word.trim())) continue;
     (t['is_final'] == true ? done : shown).write(word);
   }
-  return Heard(done.toString(), shown.toString(), finished: parsed['finished'] == true);
+  final ms = parsed['final_audio_proc_ms'];
+  return Heard(
+    done.toString(),
+    shown.toString(),
+    finished: parsed['finished'] == true,
+    finalMs: ms is int && ms > 0 ? ms : 0,
+  );
 }
 
 /// A stream to Soniox.
diff --git a/app/test/recording/connection_test.dart b/app/test/recording/connection_test.dart
new file mode 100644
index 0000000..17cf49c
--- /dev/null
+++ b/app/test/recording/connection_test.dart
@@ -0,0 +1,53 @@
+// Whether the phone has a connection (D92 item 3; D93 Q4): our own event
+// channel, a true or false at each change, taken as online until it says.
+import 'dart:io';
+
+import 'package:flutter/services.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/recording/connection.dart';
+
+void main() {
+  TestWidgetsFlutterBinding.ensureInitialized();
+  const channel = EventChannel(networkChannel);
+  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
+  late MockStreamHandlerEventSink sink;
+
+  setUp(() {
+    messenger.setMockStreamHandler(
+      channel,
+      MockStreamHandler.inline(onListen: (arguments, events) => sink = events),
+    );
+  });
+
+  tearDown(() => messenger.setMockStreamHandler(channel, null));
+
+  test('online until the phone says; each change once', () async {
+    final connection = ChannelConnection();
+    final seen = <bool>[];
+    connection.changes.listen(seen.add);
+    await pumpEventQueue();
+    expect(connection.online, isTrue);
+    sink.success(false);
+    await pumpEventQueue();
+    expect(connection.online, isFalse);
+    sink.success(false);
+    sink.success('x');
+    sink.error(code: 'network');
+    await pumpEventQueue();
+    expect(connection.online, isFalse);
+    sink.success(true);
+    await pumpEventQueue();
+    expect(connection.online, isTrue);
+    expect(seen, [false, true]);
+  });
+
+  test('the Swift side watches the path, sending true or false', () {
+    final swift = File('ios/Runner/AppDelegate.swift').readAsStringSync();
+    expect(swift, contains('"$networkChannel"'));
+    expect(swift, contains('import Network'));
+    expect(swift, contains('NWPathMonitor()'));
+    expect(swift, contains('let online = path.status == .satisfied'));
+    expect(swift, contains('events(online)'));
+    expect(swift, contains('channel.setStreamHandler(networkWatch)'));
+  });
+}
diff --git a/app/test/recording/fakes.dart b/app/test/recording/fakes.dart
index 78f7ca9..8fdce95 100644
--- a/app/test/recording/fakes.dart
+++ b/app/test/recording/fakes.dart
@@ -6,6 +6,8 @@ import 'dart:convert';
 import 'dart:io';
 import 'dart:typed_data';
 
+import 'package:souldreams/recording/audio_keep.dart';
+import 'package:souldreams/recording/connection.dart';
 import 'package:souldreams/recording/microphone.dart';
 import 'package:souldreams/recording/soniox.dart';
 
@@ -21,12 +23,17 @@ List<String> tokensOf(String dream) {
 /// The first invented dream's tokens.
 List<String> inventedTokens() => tokensOf(invented('two-dreams-en').dreams[0]);
 
-String reply({List<String> done = const [], List<String> shown = const [], bool finished = false}) => jsonEncode({
+String reply({
+  List<String> done = const [],
+  List<String> shown = const [],
+  bool finished = false,
+  int finalMs = 0,
+}) => jsonEncode({
   'tokens': [
     for (final t in done) {'text': t, 'is_final': true},
     for (final t in shown) {'text': t, 'is_final': false},
   ],
-  'final_audio_proc_ms': 0,
+  'final_audio_proc_ms': finalMs,
   'total_audio_proc_ms': 0,
   if (finished) 'finished': true,
 });
@@ -168,6 +175,50 @@ final class SilentMicrophone implements Microphone {
   }
 }
 
+/// A keep held in memory (D92): each recording's bytes in order, which
+/// were ended, and which discarded.
+final class MemoryKeep implements AudioKeep {
+  int _next = 0;
+  final audio = <String, List<int>>{};
+  final ended = <String>[];
+  final discarded = <String>[];
+
+  /// Every add from now on fails, as a full disk would.
+  bool fails = false;
+
+  @override
+  String newId() => (++_next).toRadixString(16).padLeft(32, '0');
+
+  @override
+  Future<void> add(String id, Uint8List bytes, {bool last = false}) async {
+    if (fails) throw StateError('keep');
+    (audio[id] ??= []).addAll(bytes);
+    if (last) ended.add(id);
+  }
+
+  @override
+  Future<void> discard(String id) async {
+    discarded.add(id);
+    audio.remove(id);
+  }
+}
+
+/// A connection the test switches.
+final class FakeConnection implements Connection {
+  final _changes = StreamController<bool>.broadcast();
+
+  @override
+  bool online = true;
+
+  @override
+  Stream<bool> get changes => _changes.stream;
+
+  void set(bool value) {
+    online = value;
+    _changes.add(value);
+  }
+}
+
 /// A link held in memory: what was sent, and replies the test pushes.
 final class MemoryLink implements SonioxLink {
   final _replies = StreamController<String>();
diff --git a/app/test/recording/no_storage_test.dart b/app/test/recording/no_storage_test.dart
index 8eb025c..b10c743 100644
--- a/app/test/recording/no_storage_test.dart
+++ b/app/test/recording/no_storage_test.dart
@@ -1,7 +1,8 @@
-// The audio is never kept on the phone (D69, as D71 corrects it, for this
-// slice): nothing in lib/recording/ can write a file, and only the
-// microphone's own file reaches the `record` package. A floor, read from
-// the source; the owner's phone check looks in the app's container.
+// Nothing in lib/recording/ can write a file, and only the microphone's
+// own file reaches the `record` package. The audio kept on the phone (D92)
+// goes only through the keep, which lib/journal/ implements over the
+// journal's folder. A floor, read from the source; the owner's phone check
+// looks in the app's container.
 import 'dart:io';
 
 import 'package:flutter_test/flutter_test.dart';
@@ -15,6 +16,8 @@ void main() {
 
   test('the recording files are these', () {
     expect(files.map((f) => f.uri.pathSegments.last).toSet(), {
+      'audio_keep.dart',
+      'connection.dart',
       'heard_text.dart',
       'key_client.dart',
       'microphone.dart',
diff --git a/app/test/recording/recording_test.dart b/app/test/recording/recording_test.dart
index 3d50299..2a4f67f 100644
--- a/app/test/recording/recording_test.dart
+++ b/app/test/recording/recording_test.dart
@@ -611,4 +611,244 @@ void main() {
     await pumpEventQueue();
     expect(fetches, hasLength(1));
   });
+
+  // Offline recording (D92 to D94): every recording's audio is kept from its
+  // first frame; all final, it is deleted at once; else it waits from the
+  // last final word.
+  ({RecordingSession session, List<(String, String)> heard, List<Trouble> troubles, List<int> ended}) kept(
+    SilentMicrophone mic,
+    MemoryKeep keep, {
+    MemoryLink? link,
+    FakeConnection? connection,
+    Future<String> Function()? key,
+    int cap = recordingCap,
+  }) {
+    final heard = <(String, String)>[];
+    final troubles = <Trouble>[];
+    final ended = <int>[];
+    final recording = Recording(
+      on: true,
+      microphone: mic,
+      key: key ?? () async => 'k',
+      connect: (_) async => link ?? MemoryLink(),
+      keep: keep,
+      connection: connection,
+      cap: cap,
+    );
+    final session = RecordingSession(
+      recording,
+      onHeard: (f, p) => heard.add((f, p)),
+      onLevel: (_) {},
+      onStopping: () {},
+      onEnded: () => ended.add(1),
+      onTrouble: troubles.add,
+      wait: const Duration(milliseconds: 200),
+    );
+    return (session: session, heard: heard, troubles: troubles, ended: ended);
+  }
+
+  // [n] frames of a tenth of a second, each its own value.
+  Future<void> frames(SilentMicrophone mic, int n, [int first = 1]) async {
+    for (var i = 0; i < n; i++) {
+      mic.frame(first + i);
+    }
+    await pumpEventQueue();
+  }
+
+  int firstSample(List<int> bytes, int at) =>
+      ByteData.sublistView(Uint8List.fromList(bytes)).getInt16(at, Endian.little);
+
+  test('every frame is kept in order; all final, deleted at once', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final link = MemoryLink();
+    final r = kept(mic, keep, link: link);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 12);
+    final id = keep.audio.keys.single;
+    expect(keep.audio[id], hasLength(32000));
+    expect(firstSample(keep.audio[id]!, 0), 1);
+    expect(firstSample(keep.audio[id]!, 31998), 10);
+    final stopped = r.session.stop();
+    await pumpEventQueue();
+    // Finished means every word is final, whatever the count says.
+    link.reply(reply(done: [tokens[0]], finalMs: 1000, finished: true));
+    await stopped;
+    expect(keep.discarded, [id]);
+    expect(r.session.left, isNull);
+    expect(r.troubles, isEmpty);
+  });
+
+  test('no connection at the tap: no key, MP·15, it all waits', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    var asked = 0;
+    final r = kept(mic, keep, connection: FakeConnection()..online = false, key: () async => '${asked++}');
+    expect(await r.session.start(), isTrue);
+    expect(r.troubles, [Trouble.offline]);
+    await frames(mic, 5);
+    await r.session.stop();
+    await pumpEventQueue();
+    expect(asked, 0);
+    final id = keep.audio.keys.single;
+    expect(keep.audio[id], hasLength(16000));
+    expect(keep.ended, [id]);
+    expect(r.session.left, (audio: id, from: 0));
+    expect(lines, ['recordingStarted', 'recordingOffline', 'recordingEnded']);
+  });
+
+  test('a key that fails: it goes on, MP·54, it all waits', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final r = kept(mic, keep, key: () async => throw const KeyFailure(502));
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 3);
+    expect(mic.running, isTrue);
+    expect(r.troubles, [Trouble.broke]);
+    expect(r.ended, isEmpty);
+    await frames(mic, 3, 4);
+    await r.session.stop();
+    await pumpEventQueue();
+    final id = keep.audio.keys.single;
+    expect(keep.audio[id], hasLength(19200));
+    expect(r.session.left, (audio: id, from: 0));
+    expect(lines, ['recordingStarted', 'recordingKeyFailed 502', 'recordingEnded']);
+  });
+
+  test('a break: final words stay; the rest waits from Soniox\'s count', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final link = MemoryLink();
+    final r = kept(mic, keep, link: link);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 4);
+    link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 200));
+    await pumpEventQueue();
+    await link.drop(1011);
+    await pumpEventQueue();
+    expect(mic.running, isTrue);
+    expect(r.troubles, [Trouble.broke]);
+    expect(r.heard, [(tokens[0], tokens[1]), ('', '')]);
+    final sent = link.sent.length;
+    await frames(mic, 2, 5);
+    expect(link.sent, hasLength(sent));
+    await r.session.stop();
+    await pumpEventQueue();
+    final id = keep.audio.keys.single;
+    expect(keep.audio[id], hasLength(19200));
+    expect(r.session.left, (audio: id, from: 6400));
+    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
+  });
+
+  test('a stop whose last words never all come: the rest waits', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final link = MemoryLink();
+    final r = kept(mic, keep, link: link);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 4);
+    link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 100));
+    await r.session.stop();
+    final id = keep.audio.keys.single;
+    expect(r.session.left, (audio: id, from: 3200));
+    expect(r.heard.last, ('', ''));
+    expect(keep.discarded, isEmpty);
+  });
+
+  test('a cancel mid-stream: the rest waits; unsettled words leave', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final link = MemoryLink();
+    final r = kept(mic, keep, link: link);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 4);
+    link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 300));
+    await pumpEventQueue();
+    await r.session.cancel();
+    final id = keep.audio.keys.single;
+    expect(r.session.left, (audio: id, from: 9600));
+    expect(r.heard.last, ('', ''));
+    expect(keep.ended, [id]);
+  });
+
+  test('nothing past the final words: deleted, nothing waits', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final link = MemoryLink();
+    final r = kept(mic, keep, link: link);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 2);
+    link.reply(reply(done: [tokens[0]], finalMs: 900));
+    await pumpEventQueue();
+    await link.drop(1011);
+    await pumpEventQueue();
+    await r.session.stop();
+    expect(r.session.left, isNull);
+    expect(keep.discarded, hasLength(1));
+  });
+
+  test('at the cap it stops itself as Stop does, a code', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep();
+    final r = kept(mic, keep, connection: FakeConnection()..online = false, cap: 9600);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 2);
+    expect(mic.running, isTrue);
+    await frames(mic, 1, 3);
+    await pumpEventQueue();
+    expect(mic.running, isFalse);
+    expect(r.ended, [1]);
+    expect(r.session.left, (audio: keep.audio.keys.single, from: 0));
+    expect(lines, ['recordingStarted', 'recordingOffline', 'recordingCapped', 'recordingEnded']);
+  });
+
+  test('every recording stops at ten minutes (D93 Q6)', () {
+    expect(recordingCap, 10 * 60 * 16000 * 2);
+    expect(Recording(on: true, microphone: SilentMicrophone(), key: () async => 'k', connect: (_) async => MemoryLink())
+        .cap, recordingCap);
+  });
+
+  test('a keep that fails: a code; a break stops it', () async {
+    final mic = SilentMicrophone();
+    final keep = MemoryKeep()..fails = true;
+    final link = MemoryLink();
+    final r = kept(mic, keep, link: link);
+    expect(await r.session.start(), isTrue);
+    await frames(mic, 11);
+    await link.drop(1011);
+    await pumpEventQueue();
+    expect(mic.running, isFalse);
+    expect(r.troubles, isEmpty);
+    expect(r.session.left, isNull);
+    expect(lines, ['recordingStarted', 'audioKeepFailed', 'recordingStreamFailed 1011', 'recordingEnded']);
+  });
+
+  test('refused or off: no audio, no id', () async {
+    final keep = MemoryKeep();
+    final refused = kept(SilentMicrophone()..allow = false, keep);
+    expect(await refused.session.start(), isFalse);
+    expect(refused.troubles, [Trouble.refused]);
+    expect(keep.audio, isEmpty);
+    expect(keep.newId(), '1'.padLeft(32, '0'));
+  });
+
+  test('keeping makes the same recording, with the keep', () {
+    final mic = SilentMicrophone();
+    final connection = FakeConnection();
+    final keep = MemoryKeep();
+    final plain = Recording(
+      on: true,
+      microphone: mic,
+      key: () async => 'k',
+      connect: (_) async => MemoryLink(),
+      connection: connection,
+      cap: 64,
+    );
+    final kept = plain.keeping(keep);
+    expect(kept.keep, same(keep));
+    expect(plain.keep, isNull);
+    expect([kept.on, kept.microphone, kept.connection, kept.cap], [true, mic, connection, 64]);
+    expect(kept.key, same(plain.key));
+    expect(kept.connect, same(plain.connect));
+  });
 }
diff --git a/app/test/recording/soniox_test.dart b/app/test/recording/soniox_test.dart
index 0df85e6..fbb5c78 100644
--- a/app/test/recording/soniox_test.dart
+++ b/app/test/recording/soniox_test.dart
@@ -41,6 +41,15 @@ void main() {
     expect((readReply(reply(finished: true)) as Heard).finished, isTrue);
   });
 
+  // D94: how much of the audio is in final words, Soniox's own count.
+  test('final_audio_proc_ms is read; missing or odd, it is 0', () {
+    expect((readReply(reply(done: [tokens[0]], finalMs: 4800)) as Heard).finalMs, 4800);
+    expect((readReply(jsonEncode({'tokens': <Object?>[]})) as Heard).finalMs, 0);
+    for (final odd in [-5, 1.5, '4800', null]) {
+      expect((readReply(jsonEncode({'tokens': <Object?>[], 'final_audio_proc_ms': odd})) as Heard).finalMs, 0);
+    }
+  });
+
   test("Soniox's error is its code; an unreadable reply is -1", () {
     expect((readReply(jsonEncode({'error_code': 402, 'error_message': 'x'})) as Refused).code, 402);
     expect((readReply('not json') as Refused).code, -1);
~~~~

### Task 6 · The typing screen saves what waits; SoulDreams Dev's wiring (D93 Q2, Q4, Q7)

`Journal.addDream` and `editDream` take the recordings left waiting; the typing screen collects them and saves them
after its words, keeps a night with nothing typed but a recording waiting, and withholds MP·33 offline;
`JournalAudio`; `JournalHome` hands the pages a recording that keeps its audio; `main_dev.dart` gives it the phone's
connection. Tests: `typing_page_test.dart` (8), `journal_test.dart` (2), `journal_home_test.dart` (1),
`journal_audio_test.dart` (1).

Expected: 354 app tests. Commit:

> Recording: a Save keeps the recordings waiting, as dreams after its words; MP·15 and MP·54 (D93 Q2, Q4, Q7)

**The block:**

~~~~diff
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
index 565bc4a..c4ab456 100644
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -7,9 +7,13 @@
 //   night's other dreams remain (D58 Q3); a night left with no dream is
 //   deleted, as a deletion deletes it (P10).
 // - A dream is told in words or waits as a recording (D93 Q2); a dream's
-//   index counts both, and a waiting one is never edited.
+//   index counts both, and a waiting one is never edited. A Save puts the
+//   recordings its screen left waiting after its words, in order; a Save
+//   with nothing typed but a recording waiting keeps it (D93 Q7).
 import 'dart:math';
 
+import 'package:flutter/foundation.dart' show listEquals;
+
 import '../words/lines.g.dart' show Lang;
 import 'journal_store.dart';
 import 'night.dart';
@@ -43,10 +47,11 @@ final class Journal {
   /// Where a typing screen opened now from the journal saves.
   Future<Target> targetNow() async => targetAt(await _store.nights(), _now());
 
-  /// Saves [text] as a new dream at [target]. Returns whether anything
-  /// was kept.
-  Future<bool> addDream(Target target, String text, Lang lang) async {
-    if (isEmptyText(text)) return false;
+  /// Saves [text] as a new dream at [target], and after it the recordings
+  /// [waiting] for their words. Returns whether anything was kept.
+  Future<bool> addDream(Target target, String text, Lang lang, {List<Waiting> waiting = const []}) async {
+    final added = <Dream>[if (!isEmptyText(text)) Told(text), ...waiting];
+    if (added.isEmpty) return false;
     switch (target) {
       case NewNight(:final begun):
         await _store.save(Night(
@@ -55,28 +60,36 @@ final class Journal {
           date: dateOf(begun, zone),
           closes: closesAfter(begun, zone),
           lang: lang,
-          dreams: [text],
+          entries: added,
         ));
         return true;
       case IntoNight(:final id):
         // One turn of the store's queue: a delete cannot fall between
         // the read and the write, nor another Save lose this one (D61).
-        return _store.update(id, (n) => n.withEntries([...n.entries, Told(text)]));
+        return _store.update(id, (n) => n.withEntries([...n.entries, ...added]));
     }
   }
 
-  /// Replaces dream [index] of night [id] with [text]. The index counts
-  /// every dream, told or waiting; a waiting one is never replaced.
-  Future<void> editDream(String id, int index, String text) async {
+  /// Replaces dream [index] of night [id] with [text], and puts the
+  /// recordings [waiting] for their words after it (at the night's end if
+  /// that dream is gone). The index counts every dream, told or waiting; a
+  /// waiting one is never replaced.
+  Future<void> editDream(String id, int index, String text, {List<Waiting> waiting = const []}) async {
     await _store.update(id, (n) {
-      if (index < 0 || index >= n.entries.length || n.entries[index] is! Told) return n;
       final entries = [...n.entries];
-      if (isEmptyText(text)) {
-        entries.removeAt(index);
-      } else {
-        entries[index] = Told(text);
+      var at = entries.length;
+      if (index >= 0 && index < entries.length && entries[index] is Told) {
+        if (isEmptyText(text)) {
+          entries.removeAt(index);
+          at = index;
+        } else {
+          entries[index] = Told(text);
+          at = index + 1;
+        }
       }
-      return entries.isEmpty ? null : n.withEntries(entries);
+      entries.insertAll(at, waiting);
+      if (entries.isEmpty) return null;
+      return listEquals(entries, n.entries) ? n : n.withEntries(entries);
     });
   }
 
diff --git a/app/lib/journal/journal_audio.dart b/app/lib/journal/journal_audio.dart
new file mode 100644
index 0000000..66622c7
--- /dev/null
+++ b/app/lib/journal/journal_audio.dart
@@ -0,0 +1,26 @@
+// A recording's audio, kept in the journal's folder until its words come
+// (D92 item 1): the keep a recording hands its audio to, over the store's
+// one queue. New ids come from the system's secure source, as a night's
+// do, and name files on the phone only (R4).
+import 'dart:math';
+import 'dart:typed_data';
+
+import '../recording/audio_keep.dart';
+import 'journal_store.dart';
+import 'night.dart';
+
+final class JournalAudio implements AudioKeep {
+  JournalAudio(this._store, [this._random]);
+
+  final JournalStore _store;
+  final Random? _random;
+
+  @override
+  String newId() => newNightId(_random);
+
+  @override
+  Future<void> add(String id, Uint8List bytes, {bool last = false}) => _store.appendAudio(id, bytes, sync: last);
+
+  @override
+  Future<void> discard(String id) => _store.discardAudio(id);
+}
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index 17a3a8a..949dfca 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -2,12 +2,14 @@
 // folder on the phone, then shows the journal list. Until the folder is
 // open the page is blank; if it cannot be opened it stays blank and logs
 // a code, never a night's words (R3). A phone check it is handed (D65)
-// finishes first, so its probe never shows as a row.
+// finishes first, so its probe never shows as a row. The recording it is
+// handed keeps its audio in the journal's folder (D92).
 import 'package:flutter/material.dart';
 
 import '../../core/safe_log.dart';
 import '../../recording/recording.dart';
 import '../journal.dart';
+import '../journal_audio.dart';
 import '../journal_files.dart';
 import '../journal_store.dart';
 import 'journal_page.dart';
@@ -30,6 +32,7 @@ class JournalHome extends StatefulWidget {
 
 class _JournalHomeState extends State<JournalHome> {
   Journal? _journal;
+  Recording? _recording;
 
   @override
   void initState() {
@@ -44,13 +47,17 @@ class _JournalHomeState extends State<JournalHome> {
       // The check logs its own result; the list does not depend on it.
     }
     JournalStore.open(widget.files).then((store) {
-      if (mounted) setState(() => _journal = Journal(store));
+      if (!mounted) return;
+      setState(() {
+        _journal = Journal(store);
+        _recording = widget.recording?.keeping(JournalAudio(store));
+      });
     }, onError: (Object _) => SafeLog.event(LogEvent.journalOpenFailed));
   }
 
   @override
   Widget build(BuildContext context) {
     final journal = _journal;
-    return journal == null ? const Scaffold() : JournalPage(journal: journal, recording: widget.recording);
+    return journal == null ? const Scaffold() : JournalPage(journal: journal, recording: _recording);
   }
 }
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
index cd6e563..9bf0c59 100644
--- a/app/lib/journal/pages/typing_page.dart
+++ b/app/lib/journal/pages/typing_page.dart
@@ -19,8 +19,13 @@
 // MP·33; a stop, Save or Back waits for the last words; leaving the app
 // ends it at once. A refused microphone shows MP·63 where MP·62 shows,
 // until the next tap of the microphone (D93 Q4); while it records, the
-// microphone's spoken name is MP·64. Another failure to start or a break
-// shows nothing new.
+// microphone's spoken name is MP·64. Offline recording (D92 to D94): with
+// no connection at the tap, MP·15 shows in place of MP·33's announcement;
+// a key, a stream or Soniox's budget failing shows MP·54; either way the
+// recording goes on, and what was not turned into words waits on the phone.
+// The Save puts each waiting recording after the dream's words, and keeps
+// a night with nothing typed but a recording waiting (D93 Q2, Q7).
+// Without a keep, a failure to start or a break shows nothing new.
 import 'dart:async';
 import 'dart:math';
 
@@ -38,6 +43,7 @@ import '../../recording/recording.dart';
 import '../../words/lines.g.dart';
 import '../../words/pending.g.dart';
 import '../journal.dart';
+import '../night.dart';
 import '../night_rules.dart';
 import 'parts.dart';
 
@@ -117,6 +123,9 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   // What the dreamer is told about the recording, until the next tap of the
   // microphone or the screen closes (D93 Q4).
   Trouble? _trouble;
+  // The recordings this screen left waiting for their words, in order; the
+  // Save keeps them (D93 Q2).
+  final _waiting = <Waiting>[];
   Timer? _ticker;
 
   @override
@@ -186,18 +195,21 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
       await (leaving ? session.cancel() : session.stop());
       _saving = false;
     }
-    // Leaving with nothing typed keeps nothing and stays, so an emptied
-    // edit never deletes a dream behind the dreamer's back.
-    if (leaving && isEmptyText(_text.text)) return;
+    // Leaving with nothing typed and nothing waiting keeps nothing and
+    // stays, so an emptied edit never deletes a dream behind the dreamer's
+    // back (D93 Q7: a recording waiting is something).
+    if (leaving && isEmptyText(_text.text) && _waiting.isEmpty) return;
     _saving = true;
     if (_failed && mounted) setState(() => _failed = false);
     try {
       final e = widget.edit;
+      final waiting = List.of(_waiting);
       if (e == null) {
-        await widget.journal.addDream(widget.target, _text.text, appLanguage);
+        await widget.journal.addDream(widget.target, _text.text, appLanguage, waiting: waiting);
       } else {
-        await widget.journal.editDream(e.id, e.index, _text.text);
+        await widget.journal.editDream(e.id, e.index, _text.text, waiting: waiting);
       }
+      _waiting.clear();
     } on Object {
       SafeLog.event(LogEvent.journalSaveFailed);
       _saving = false;
@@ -273,7 +285,10 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
     _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
       if (mounted) setState(() => _seconds++);
     });
-    SemanticsService.sendAnnouncement(View.of(context), Lines.MP_33.text(appLanguage), TextDirection.ltr);
+    // With no connection, MP·15 is what a screen reader hears (D93 Q4).
+    if (_trouble != Trouble.offline) {
+      SemanticsService.sendAnnouncement(View.of(context), Lines.MP_33.text(appLanguage), TextDirection.ltr);
+    }
   }
 
   // Heard words go in at the insertion point (D87 1).
@@ -394,10 +409,13 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
     _ticker = null;
   }
 
-  // The recording ended, by a stop or by itself: the words shown stay.
+  // The recording ended, by a stop or by itself: the words shown stay, and
+  // what it left waiting is noted for the Save.
   void _ended() {
     _ticker?.cancel();
     _ticker = null;
+    final left = _session?.left;
+    if (left != null) _waiting.add(Waiting(left.audio, left.from));
     _session = null;
     if (!mounted) return;
     // The next key, fetched in advance (D88).
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
index 85951e0..8cb0d8e 100644
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -11,6 +11,7 @@ import 'core/safe_log.dart';
 import 'journal/channel_journal_files.dart';
 import 'journal/pages/journal_home.dart';
 import 'journal/self_check.dart';
+import 'recording/connection.dart';
 import 'recording/record_microphone.dart';
 import 'recording/recording.dart';
 
@@ -24,7 +25,12 @@ void main() {
   final check = const bool.fromEnvironment('JOURNAL_SELF_CHECK') ? journalSelfCheck(files, files) : null;
   // Recording by voice (D69, D71): the beta key comes from the owner's
   // file through --dart-define-from-file (R5); with none, recording is off.
-  final recording = Recording.live(microphone: RecordMicrophone(), betaKey: const String.fromEnvironment('BETA_KEY'));
+  // The phone's own connection status decides MP·15 at the tap (D93 Q4).
+  final recording = Recording.live(
+    microphone: RecordMicrophone(),
+    betaKey: const String.fromEnvironment('BETA_KEY'),
+    connection: ChannelConnection(),
+  );
   // The keyboard check (D50 1): only in a build made with
   // --dart-define=KEYBOARD_CHECK=true.
   runApp(
diff --git a/app/test/journal/journal_audio_test.dart b/app/test/journal/journal_audio_test.dart
new file mode 100644
index 0000000..bb6ec77
--- /dev/null
+++ b/app/test/journal/journal_audio_test.dart
@@ -0,0 +1,37 @@
+// The keep a recording hands its audio to (D92 item 1): the journal's
+// folder, through the store's one queue.
+import 'dart:io';
+import 'dart:math';
+import 'dart:typed_data';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/journal/journal_audio.dart';
+import 'package:souldreams/journal/journal_store.dart';
+
+import 'io_journal_files.dart';
+
+void main() {
+  late Directory dir;
+  late IoJournalFiles files;
+
+  setUp(() {
+    dir = Directory.systemTemp.createTempSync('audio-');
+    files = IoJournalFiles(Directory('${dir.path}/Journal'));
+  });
+
+  tearDown(() => dir.deleteSync(recursive: true));
+
+  test('audio goes into the journal folder, and is discarded whole', () async {
+    final store = await JournalStore.open(files);
+    final keep = JournalAudio(store, Random(4));
+    final id = keep.newId();
+    expect(id, matches(RegExp(r'^[0-9a-f]{32}$')));
+    expect(keep.newId(), isNot(id));
+    await keep.add(id, Uint8List.fromList([1, 2]));
+    await keep.add(id, Uint8List.fromList([3, 4]), last: true);
+    expect(files.everything().keys, [JournalStore.audioOf(id, 0)]);
+    expect(files.everything().values.single, [1, 2, 3, 4]);
+    await keep.discard(id);
+    expect(files.everything(), isEmpty);
+  });
+}
diff --git a/app/test/journal/journal_test.dart b/app/test/journal/journal_test.dart
index c62625c..46538ed 100644
--- a/app/test/journal/journal_test.dart
+++ b/app/test/journal/journal_test.dart
@@ -53,6 +53,31 @@ void main() {
     expect(await entries(), [w]);
   });
 
+  // D93 Q2, Q7: a Save keeps the recordings its screen left waiting, after
+  // its words; with nothing typed, the recording alone keeps the night.
+  test('a Save keeps waiting recordings after its words', () async {
+    final (x, y) = (Waiting('1' * 32), Waiting('2' * 32, 64));
+    expect(await journal.addDream(await journal.targetNow(), ' ', Lang.en, waiting: [x]), isTrue);
+    final n = (await journal.newestFirst()).single;
+    expect(n.entries, [x]);
+    expect(await journal.addDream(IntoNight(n.id), a[0], Lang.en, waiting: [y]), isTrue);
+    expect((await journal.night(n.id))!.entries, [x, Told(a[0]), y]);
+  });
+
+  test('an edit puts waiting recordings after its dream, or instead', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    final n = (await journal.newestFirst()).single;
+    await journal.addDream(IntoNight(n.id), a[1], Lang.en);
+    final (x, y, z) = (Waiting('1' * 32), Waiting('2' * 32), Waiting('3' * 32));
+    Future<List<Dream>> entries() async => (await journal.night(n.id))!.entries;
+    await journal.editDream(n.id, 0, b[0], waiting: [x]);
+    expect(await entries(), [Told(b[0]), x, Told(a[1])]);
+    await journal.editDream(n.id, 2, '', waiting: [y]);
+    expect(await entries(), [Told(b[0]), x, y]);
+    await journal.editDream(n.id, 9, b[0], waiting: [z]);
+    expect(await entries(), [Told(b[0]), x, y, z]);
+  });
+
   test('an empty Save keeps nothing', () async {
     for (final text in ['', '  \n ']) {
       expect(await journal.addDream(await journal.targetNow(), text, Lang.en), isFalse);
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index 83c0738..91efe93 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -6,10 +6,13 @@ import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/app.dart';
 import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/journal_store.dart';
 import 'package:souldreams/journal/pages/journal_home.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
+import 'package:souldreams/recording/recording.dart';
 
+import '../../recording/fakes.dart';
 import '../memory_journal_files.dart';
 
 /// A folder that says whether it was opened.
@@ -40,6 +43,22 @@ void main() {
     expect(lines, isEmpty);
   });
 
+  // D92: the recording the pages get keeps its audio in the journal's folder.
+  testWidgets('the recording handed on keeps its audio in the journal', (tester) async {
+    JournalStore.newQueueForTests();
+    final recording = Recording(
+      on: true,
+      microphone: SilentMicrophone(),
+      key: () async => 'k',
+      connect: (_) async => MemoryLink(),
+    );
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: MemoryJournalFiles(), recording: recording)));
+    await tester.pumpAndSettle();
+    final handed = tester.widget<JournalPage>(find.byType(JournalPage)).recording!;
+    expect(handed.keep, isA<JournalAudio>());
+    expect(handed.microphone, same(recording.microphone));
+  });
+
   // D65: with the phone check, its probe never shows as a row, because the
   // list is not loaded until the check has finished.
   testWidgets('the list waits for the phone check, then shows', (tester) async {
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index 39a4b13..23cd1ef 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -13,6 +13,7 @@ import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/design/stand_ins.dart';
 import 'package:souldreams/design/tokens.g.dart';
+import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_rules.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/recording/heard_text.dart';
@@ -1617,6 +1618,177 @@ void main() {
     expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsOneWidget);
     expect(lines, ['firstUseReadFailed']);
   });
+  // Offline recording (D92 to D94; D93 Q2, Q4, Q5, Q7), on a keep in memory.
+  ({SilentMicrophone mic, MemoryLink link, MemoryKeep keep, FakeConnection connection, Recording recording}) offline({
+    bool online = false,
+  }) {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    final keep = MemoryKeep();
+    final connection = FakeConnection()..online = online;
+    return (
+      mic: mic,
+      link: link,
+      keep: keep,
+      connection: connection,
+      recording: Recording(
+        on: true,
+        microphone: mic,
+        key: () async => 'k',
+        connect: (_) async => link,
+        keep: keep,
+        connection: connection,
+      ),
+    );
+  }
+
+  Future<void> frames(WidgetTester tester, SilentMicrophone mic, int n) async {
+    for (var i = 0; i < n; i++) {
+      mic.frame(i + 1);
+    }
+    await tester.pump();
+  }
+
+  testWidgets('no connection: MP·15, no MP·33, and Save keeps it waiting', (tester) async {
+    final v = offline();
+    final h = await tall(tester, recording: v.recording);
+    tester.takeAnnouncements();
+    await record(tester);
+    expect(tester.takeAnnouncements(), isEmpty);
+    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
+    expect(find.bySemanticsLabel(Lines.MP_15.text(Lang.en)), findsOneWidget);
+    await frames(tester, v.mic, 4);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsNothing);
+    final id = v.keep.audio.keys.single;
+    expect((await h.nights()).single.entries, [Waiting(id)]);
+    expect(v.keep.audio[id], hasLength(12800));
+  });
+
+  testWidgets('a break shows MP·54; final words stay, the rest waits after', (tester) async {
+    final lines = await logged();
+    final v = offline(online: true);
+    final h = await tall(tester, recording: v.recording);
+    await record(tester);
+    await frames(tester, v.mic, 3);
+    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 100));
+    await tester.pump();
+    expect(find.text(tokens[0] + tokens[1]), findsOneWidget);
+    await v.link.drop(1011);
+    await tester.pumpAndSettle();
+    expect(find.bySemanticsLabel(Lines.MP_54.text(Lang.en)), findsOneWidget);
+    expect(v.mic.running, isTrue);
+    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
+    expect(field.controller!.text, tokens[0].trimLeft());
+    await frames(tester, v.mic, 2);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    final id = v.keep.audio.keys.single;
+    expect((await h.nights()).single.entries, [Told(tokens[0].trimLeft()), Waiting(id, 3200)]);
+    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
+  });
+
+  testWidgets('MP·54 goes at the next tap of the microphone', (tester) async {
+    final links = <MemoryLink>[];
+    final recording = Recording(
+      on: true,
+      microphone: SilentMicrophone(),
+      key: () async => 'k',
+      connect: (_) async => MemoryLink().._keep(links),
+      keep: MemoryKeep(),
+    );
+    await tall(tester, recording: recording);
+    await record(tester);
+    await links.single.drop(1011);
+    await tester.pumpAndSettle();
+    expect(find.byKey(TypingPage.noticeKey), findsOneWidget);
+    await tester.tap(find.byKey(TypingPage.micKey));
+    await tester.pumpAndSettle();
+    await record(tester);
+    expect(find.byKey(TypingPage.noticeKey), findsNothing);
+  });
+
+  testWidgets('leaving with only a recording waiting keeps the night', (tester) async {
+    final v = offline();
+    final h = await tall(tester, recording: v.recording);
+    await record(tester);
+    await frames(tester, v.mic, 2);
+    await leave(tester, AppLifecycleState.hidden);
+    expect(find.byType(TypingPage), findsNothing);
+    expect((await h.nights()).single.entries, [Waiting(v.keep.audio.keys.single)]);
+  });
+
+  testWidgets('two recordings waiting go after the words, in order', (tester) async {
+    final v = offline();
+    final h = await tall(tester, recording: v.recording);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
+    for (var i = 0; i < 2; i++) {
+      await record(tester);
+      await frames(tester, v.mic, 1);
+      await tester.tap(find.byKey(TypingPage.micKey));
+      await tester.pumpAndSettle();
+    }
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    final [a, b] = v.keep.audio.keys.toList();
+    expect((await h.nights()).single.entries, [Told(dreams[0]), Waiting(a), Waiting(b)]);
+  });
+
+  testWidgets('an edit with a recording waiting puts it after the dream', (tester) async {
+    final v = offline();
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 8));
+    await h.pump(
+      tester,
+      Opener(
+        () async => TypingPage(
+          journal: h.journal,
+          target: IntoNight(n.id),
+          edit: (id: n.id, index: 0, text: n.dreams[0]),
+          recording: v.recording,
+        ),
+      ),
+    );
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    await record(tester);
+    await frames(tester, v.mic, 1);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    final id = v.keep.audio.keys.single;
+    expect((await h.journal.night(n.id))!.entries, [Told(n.dreams[0]), Waiting(id), Told(n.dreams[1])]);
+  });
+
+  testWidgets('every word final: nothing waits, the audio is deleted', (tester) async {
+    final v = offline(online: true);
+    final h = await tall(tester, recording: v.recording);
+    await record(tester);
+    await frames(tester, v.mic, 2);
+    v.link.reply(reply(done: [tokens[0]], finalMs: 200));
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pump();
+    v.link.reply(reply(finished: true));
+    await tester.pumpAndSettle();
+    expect((await h.nights()).single.entries, [Told(tokens[0].trimLeft())]);
+    expect(v.keep.discarded, hasLength(1));
+    expect(find.byKey(TypingPage.noticeKey), findsNothing);
+  });
+
+  testWidgets('a failed Save keeps the waiting recording for the next', (tester) async {
+    final v = offline();
+    final files = FlakyFiles();
+    final h = await tall(tester, recording: v.recording, files: files);
+    await record(tester);
+    await frames(tester, v.mic, 1);
+    files.failures = 1;
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsOneWidget);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect((await h.nights()).single.entries, [Waiting(v.keep.audio.keys.single)]);
+  });
 }
 
 extension on MemoryLink {
~~~~

### Task 7 · The retries, AI·6 and the night's page (D92 items 2, 3; D93 Q3; D94)

`Retries` (one at a time, oldest night first, at real-time pace, progress kept, held by a typing screen, cut when the
app leaves, kicked when the journal opens, the app comes back or the connection returns; a loop that would go round
stops with `retryFailed -3`); `JournalAudio` as `WaitingAudio`; `editDream` finds a moved dream by its words; AI·6 on
the night's page; the pages reload when words come. Tests: `retries_test.dart` (16), `night_page_test.dart` (1),
`journal_home_test.dart` (1), `typing_page_test.dart` (1), `journal_test.dart` (1), `journal_audio_test.dart` (1).

Expected: 375 app tests. Commit:

> Recording: waiting recordings retried through the real-time stream while the app is open, progress kept (D94)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index 1ce1552..0489fb1 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -60,6 +60,15 @@ enum LogEvent {
   recordingOffline,
   recordingCapped,
   audioKeepFailed,
+
+  /// A waiting recording replayed to Soniox (D94): begun; all of it in
+  /// words; cut short, its progress kept; failed (Soniox's code, our
+  /// server's status, 0 for no answer, -2 for the journal, -3 for words
+  /// the journal did not take).
+  retryStarted,
+  retryDone,
+  retryCut,
+  retryFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
index c4ab456..d81ea48 100644
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -73,11 +73,16 @@ final class Journal {
   /// Replaces dream [index] of night [id] with [text], and puts the
   /// recordings [waiting] for their words after it (at the night's end if
   /// that dream is gone). The index counts every dream, told or waiting; a
-  /// waiting one is never replaced.
-  Future<void> editDream(String id, int index, String text, {List<Waiting> waiting = const []}) async {
+  /// waiting one is never replaced. With [was], the dream's words when its
+  /// screen opened: if words that came for a recording moved it meanwhile
+  /// (D94), it is found by them.
+  Future<void> editDream(String id, int index, String text, {List<Waiting> waiting = const [], String? was}) async {
     await _store.update(id, (n) {
       final entries = [...n.entries];
       var at = entries.length;
+      if (was != null && !(index >= 0 && index < entries.length && entries[index] == Told(was))) {
+        index = entries.indexOf(Told(was));
+      }
       if (index >= 0 && index < entries.length && entries[index] is Told) {
         if (isEmptyText(text)) {
           entries.removeAt(index);
diff --git a/app/lib/journal/journal_audio.dart b/app/lib/journal/journal_audio.dart
index 66622c7..c560bde 100644
--- a/app/lib/journal/journal_audio.dart
+++ b/app/lib/journal/journal_audio.dart
@@ -1,15 +1,20 @@
 // A recording's audio, kept in the journal's folder until its words come
-// (D92 item 1): the keep a recording hands its audio to, over the store's
-// one queue. New ids come from the system's secure source, as a night's
-// do, and name files on the phone only (R4).
+// (D92 item 1): the keep a recording hands its audio to, and what the
+// retries read and write (D94), over the store's one queue. New ids come
+// from the system's secure source, as a night's do, and name files on the
+// phone only (R4). Words that come put in their night in one turn of the
+// queue, before the audio they cover is cut away or deleted, so a cut or
+// a crash between the two never hears the same words twice.
 import 'dart:math';
 import 'dart:typed_data';
 
 import '../recording/audio_keep.dart';
+import '../recording/retries.dart';
 import 'journal_store.dart';
 import 'night.dart';
+import 'night_rules.dart';
 
-final class JournalAudio implements AudioKeep {
+final class JournalAudio implements AudioKeep, WaitingAudio {
   JournalAudio(this._store, [this._random]);
 
   final JournalStore _store;
@@ -23,4 +28,40 @@ final class JournalAudio implements AudioKeep {
 
   @override
   Future<void> discard(String id) => _store.discardAudio(id);
+
+  @override
+  Future<List<Pending>> waiting() async => [
+    for (final n in await _store.nights())
+      for (final e in n.entries)
+        if (e is Waiting) (night: n.id, audio: e.audio, from: e.from),
+  ];
+
+  @override
+  Future<({int start, int size})?> part(String audio) => _store.audioPart(audio);
+
+  @override
+  Future<Uint8List> read(String audio, int start, int at, int length) => _store.readAudio(audio, start, at, length);
+
+  // The words become a dream of their own in the recording's place (D93
+  // Q2), trimmed at their start; none, and nothing is added (D93 Q7). A
+  // night left with nothing is deleted (P10). The night, the recording, or
+  // both gone: its audio goes too.
+  @override
+  Future<void> heard(Pending pending, String words, int to, {required bool done}) async {
+    final text = words.trimLeft();
+    var found = false;
+    await _store.update(pending.night, (n) {
+      final i = n.entries.indexWhere((e) => e is Waiting && e.audio == pending.audio);
+      if (i < 0) return n;
+      found = true;
+      final told = [if (!isEmptyText(text)) Told(text)];
+      final entries = [...n.entries]..replaceRange(i, i + 1, [...told, if (!done) Waiting(pending.audio, to)]);
+      return entries.isEmpty ? null : n.withEntries(entries);
+    });
+    if (done || !found) {
+      await _store.discardAudio(pending.audio);
+    } else {
+      await _store.cutAudio(pending.audio, to);
+    }
+  }
 }
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index 949dfca..6b49d17 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -3,7 +3,10 @@
 // open the page is blank; if it cannot be opened it stays blank and logs
 // a code, never a night's words (R3). A phone check it is handed (D65)
 // finishes first, so its probe never shows as a row. The recording it is
-// handed keeps its audio in the journal's folder (D92).
+// handed keeps its audio in the journal's folder (D92), and retries the
+// recordings waiting there while the app is open: when the journal opens,
+// when the app comes back, and when the connection returns; leaving the
+// app cuts a retry short (D92 item 3, D94).
 import 'package:flutter/material.dart';
 
 import '../../core/safe_log.dart';
@@ -30,16 +33,34 @@ class JournalHome extends StatefulWidget {
   State<JournalHome> createState() => _JournalHomeState();
 }
 
-class _JournalHomeState extends State<JournalHome> {
+class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   Journal? _journal;
   Recording? _recording;
 
   @override
   void initState() {
     super.initState();
+    WidgetsBinding.instance.addObserver(this);
     _open();
   }
 
+  @override
+  void dispose() {
+    WidgetsBinding.instance.removeObserver(this);
+    _recording?.retries?.dispose();
+    super.dispose();
+  }
+
+  // No background task: a retry runs only while the app is open (D92
+  // item 3). `inactive` changes nothing.
+  @override
+  void didChangeAppLifecycleState(AppLifecycleState state) {
+    final retries = _recording?.retries;
+    if (retries == null) return;
+    if (state == AppLifecycleState.resumed) retries.back();
+    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) retries.away();
+  }
+
   Future<void> _open() async {
     try {
       await widget.after;
@@ -48,10 +69,12 @@ class _JournalHomeState extends State<JournalHome> {
     }
     JournalStore.open(widget.files).then((store) {
       if (!mounted) return;
+      final audio = JournalAudio(store);
       setState(() {
         _journal = Journal(store);
-        _recording = widget.recording?.keeping(JournalAudio(store));
+        _recording = widget.recording?.keeping(audio, waiting: audio);
       });
+      _recording?.retries?.kick();
     }, onError: (Object _) => SafeLog.event(LogEvent.journalOpenFailed));
   }
 
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 68179f7..bbc77e7 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -41,11 +41,13 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     super.initState();
     WidgetsBinding.instance.addObserver(this);
     _load();
+    widget.recording?.retries?.addListener(_load);
   }
 
   @override
   void dispose() {
     WidgetsBinding.instance.removeObserver(this);
+    widget.recording?.retries?.removeListener(_load);
     super.dispose();
   }
 
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index 9f12995..08c27ad 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -6,11 +6,14 @@
 // MP·60, pending lines); the dreams under "Dreams" (MP·38), each opening
 // the typing screen to edit it; "Add dreams" (MP·29). A recording that
 // waits to be turned into text shows nothing in its place and cannot be
-// tapped (D93 Q3). Not built: naming, Start Interpretation, and the space
-// below the dreams.
+// tapped; while it is being turned into text, AI·6 shows in its place,
+// heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
+// When its words come, the page shows them. Not built: naming, Start
+// Interpretation, and the space below the dreams.
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 
+import '../../core/app_line.dart';
 import '../../core/language.dart';
 import '../../core/safe_log.dart';
 import '../../design/palette.dart';
@@ -32,6 +35,7 @@ class NightPage extends StatefulWidget {
   static const menuKey = Key('night-menu');
   static const deleteKey = Key('night-delete');
   static const addKey = Key('night-add');
+  static const transcribingKey = Key('night-transcribing');
 
   final Journal journal;
   final String id;
@@ -53,6 +57,22 @@ class _NightPageState extends State<NightPage> {
   void initState() {
     super.initState();
     _load();
+    widget.recording?.retries?.addListener(_retried);
+  }
+
+  @override
+  void dispose() {
+    widget.recording?.retries?.removeListener(_retried);
+    super.dispose();
+  }
+
+  String? get _transcribing => widget.recording?.retries?.transcribing;
+
+  // A retry began, ended, or brought words (D94): shown at once.
+  void _retried() {
+    if (!mounted) return;
+    setState(() {});
+    if (!_busy) _load();
   }
 
   // A night gone (every dream emptied) leaves its page (P10).
@@ -170,6 +190,13 @@ class _NightPageState extends State<NightPage> {
                       if (d case Told(:final text)) ...[
                         DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
                         const SizedBox(height: StandIns.bubbleGap),
+                      ] else if (d case Waiting(:final audio) when _transcribing == audio) ...[
+                        Semantics(
+                          key: NightPage.transcribingKey,
+                          liveRegion: true,
+                          child: AppLine(Lines.AI_6.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                        ),
+                        const SizedBox(height: StandIns.bubbleGap),
                       ],
                     const SizedBox(height: StandIns.gap),
                     Center(
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
index 9bf0c59..2bedbd0 100644
--- a/app/lib/journal/pages/typing_page.dart
+++ b/app/lib/journal/pages/typing_page.dart
@@ -133,6 +133,8 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
     super.initState();
     WidgetsBinding.instance.addObserver(this);
     _text.addListener(_moved);
+    // No retry while this screen is open, so no dream moves under it (D94).
+    widget.recording?.retries?.hold();
     // A key fetched in advance, so a recording starts at once (D88).
     widget.recording?.warm();
     // A failed read shows the short line and marks nothing; a failed mark
@@ -158,6 +160,7 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   @override
   void dispose() {
     WidgetsBinding.instance.removeObserver(this);
+    widget.recording?.retries?.release();
     _ticker?.cancel();
     final session = _session;
     _session = null;
@@ -207,7 +210,7 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
       if (e == null) {
         await widget.journal.addDream(widget.target, _text.text, appLanguage, waiting: waiting);
       } else {
-        await widget.journal.editDream(e.id, e.index, _text.text, waiting: waiting);
+        await widget.journal.editDream(e.id, e.index, _text.text, waiting: waiting, was: e.text);
       }
       _waiting.clear();
     } on Object {
diff --git a/app/lib/recording/recording.dart b/app/lib/recording/recording.dart
index 61fb7ba..5e11c33 100644
--- a/app/lib/recording/recording.dart
+++ b/app/lib/recording/recording.dart
@@ -25,6 +25,7 @@ import 'audio_keep.dart';
 import 'connection.dart';
 import 'key_client.dart';
 import 'microphone.dart';
+import 'retries.dart';
 import 'soniox.dart';
 
 /// What a typing screen needs to record.
@@ -72,17 +73,26 @@ final class Recording {
   final int cap;
   final DateTime Function() _now;
 
-  /// The same recording, keeping its audio in [keep].
-  Recording keeping(AudioKeep keep) => Recording(
-    on: on,
-    microphone: microphone,
-    key: key,
-    connect: connect,
-    keep: keep,
-    connection: connection,
-    cap: cap,
-    now: _now,
-  );
+  /// The same recording, keeping its audio in [keep]; with [waiting], it
+  /// also retries the recordings waiting there (D94).
+  Recording keeping(AudioKeep keep, {WaitingAudio? waiting}) {
+    final kept = Recording(
+      on: on,
+      microphone: microphone,
+      key: key,
+      connect: connect,
+      keep: keep,
+      connection: connection,
+      cap: cap,
+      now: _now,
+    );
+    if (waiting != null) kept._retries = Retries(kept, waiting);
+    return kept;
+  }
+
+  /// The retries of the recordings waiting on the phone, or null.
+  Retries? get retries => _retries;
+  Retries? _retries;
 
   // A key fetched in advance (D88): single use, and used only while fresh.
   Future<String>? _ahead;
diff --git a/app/lib/recording/retries.dart b/app/lib/recording/retries.dart
new file mode 100644
index 0000000..265aa1f
--- /dev/null
+++ b/app/lib/recording/retries.dart
@@ -0,0 +1,267 @@
+// Recordings waiting on the phone, turned into words again (D92 items 2
+// and 3; D94): each one's saved audio replayed through Soniox's real-time
+// stream with a fresh key, at real-time pace, never Soniox's file API.
+// Only while the app is open: when the journal opens, when the app comes
+// back, and when the connection returns; never while a typing screen is
+// open, so no dream moves under it. One at a time, the oldest night
+// first. Progress is kept (D94): when a retry is cut short (the app
+// leaves, the connection breaks, a typing screen opens), the words already
+// final go into the night before the recording, the audio they cover is
+// cut away, and the next retry starts from there. When all of it is in
+// words, the recording becomes its own dream in its place (D93 Q2), or
+// goes, with no words (D93 Q7), and its audio is deleted at once.
+// Nothing here names a file; each step logs a code only (R3).
+import 'dart:async';
+import 'dart:math' as math;
+
+import 'package:flutter/foundation.dart';
+
+import '../core/safe_log.dart';
+import 'key_client.dart';
+import 'recording.dart';
+import 'soniox.dart';
+
+/// A recording waiting for its words: its night, its audio's id, and how
+/// many of its bytes are already in words.
+typedef Pending = ({String night, String audio, int from});
+
+/// What the retries need of the journal; lib/journal/ implements it.
+abstract interface class WaitingAudio {
+  /// Every recording waiting, the oldest night first, in each night's
+  /// order.
+  Future<List<Pending>> waiting();
+
+  /// What is left on the phone of [audio]: its bytes from [start] of the
+  /// recording on, [size] of them; null when nothing is.
+  Future<({int start, int size})?> part(String audio);
+
+  /// Up to [length] bytes of [audio] from [at], counted from the
+  /// recording's start, out of the part that begins at [start].
+  Future<Uint8List> read(String audio, int start, int at, int length);
+
+  /// [words] heard of [pending]'s audio, up to byte [to]. With [done], the
+  /// recording becomes its words, or goes when there are none, and its
+  /// audio is deleted; else the words go in before it, and its audio
+  /// before [to] is cut away.
+  Future<void> heard(Pending pending, String words, int to, {required bool done});
+}
+
+/// How much audio goes in each frame of a retry: a tenth of a second.
+const retryFrame = bytesPerSecond ~/ 10;
+
+final class Retries extends ChangeNotifier {
+  Retries(this._recording, this._audio, {this.pace = 1, this.wait = const Duration(seconds: 10)}) {
+    _changes = _recording.connection?.changes.listen((online) {
+      if (online) kick();
+    });
+  }
+
+  final Recording _recording;
+  final WaitingAudio _audio;
+
+  /// How fast the audio goes, against real time: 1, as Soniox asks; 0 in
+  /// tests, with no wait at all.
+  final double pace;
+
+  /// How long the end waits for Soniox's last words.
+  final Duration wait;
+
+  StreamSubscription<bool>? _changes;
+  int _holds = 0;
+  bool _away = false;
+  bool _running = false;
+  // A chance came while a retry ran: look again when it ends.
+  bool _again = false;
+  bool _disposed = false;
+  Completer<void> _stop = Completer<void>();
+  String? _transcribing;
+
+  /// The recording being turned into words now, for AI·6 (D93 Q3), or null.
+  String? get transcribing => _transcribing;
+
+  bool get _stopped => _holds > 0 || _away;
+
+  // Stopped, or cut short since this run began.
+  bool get _halted => _stopped || _stop.isCompleted;
+
+  /// A chance to retry: the journal opened, the app came back, a typing
+  /// screen closed, or the connection returned.
+  void kick() {
+    if (!_recording.on || _stopped) return;
+    if (_running) {
+      _again = true;
+      return;
+    }
+    unawaited(_loop());
+  }
+
+  /// A typing screen opened: no retry until it closes.
+  void hold() {
+    _holds++;
+    _cut();
+  }
+
+  /// A typing screen closed.
+  void release() {
+    if (_holds > 0) _holds--;
+    kick();
+  }
+
+  /// The app leaves: the retry running is cut short, its progress kept.
+  void away() {
+    _away = true;
+    _cut();
+  }
+
+  /// The app is back.
+  void back() {
+    _away = false;
+    kick();
+  }
+
+  void _cut() {
+    if (!_stop.isCompleted) _stop.complete();
+  }
+
+  void _show(String? audio) {
+    _transcribing = audio;
+    _changed();
+  }
+
+  // A retry ending after the journal is gone tells no one.
+  void _changed() {
+    if (!_disposed) notifyListeners();
+  }
+
+  Future<void> _loop() async {
+    _running = true;
+    _again = false;
+    _stop = Completer<void>();
+    try {
+      Pending? done;
+      while (!_halted) {
+        final all = await _audio.waiting();
+        if (all.isEmpty || _halted) break;
+        // A recording heard whole that still waits as it was: the journal
+        // did not take its words, so stop rather than go round (a code).
+        if (all.first == done) {
+          SafeLog.event(LogEvent.retryFailed, [-3]);
+          break;
+        }
+        if (!await _one(all.first)) break;
+        done = all.first;
+      }
+    } on Object {
+      SafeLog.event(LogEvent.retryFailed, [-2]);
+    } finally {
+      _running = false;
+      if (_transcribing != null) _show(null);
+      if (_again) kick();
+    }
+  }
+
+  // One recording; true when all of it is now in words.
+  Future<bool> _one(Pending p) async {
+    final part = await _audio.part(p.audio);
+    final end = part == null ? p.from : part.start + part.size;
+    final start = part?.start ?? p.from;
+    final at = math.max(p.from, start);
+    if (part == null || at >= end) {
+      // Nothing left to hear: the recording goes, or becomes nothing more.
+      await _audio.heard(p, '', end & ~1, done: true);
+      _changed();
+      return true;
+    }
+    SafeLog.event(LogEvent.retryStarted);
+    _show(p.audio);
+    final String key;
+    try {
+      key = await _recording.key();
+    } on KeyFailure catch (e) {
+      SafeLog.event(LogEvent.retryFailed, [e.status]);
+      return false;
+    } on Object {
+      SafeLog.event(LogEvent.retryFailed, [0]);
+      return false;
+    }
+    if (_halted) return false;
+    final SonioxLink link;
+    try {
+      link = await _recording.connect(key);
+    } on Object {
+      SafeLog.event(LogEvent.retryFailed, [0]);
+      return false;
+    }
+    final words = StringBuffer();
+    var heardMs = 0;
+    final ended = Completer<bool>();
+    void over(bool finished) {
+      if (!ended.isCompleted) ended.complete(finished);
+    }
+
+    final replies = link.replies.listen(
+      (text) {
+        switch (readReply(text)) {
+          case Heard(:final finalText, :final finalMs, :final finished):
+            words.write(finalText);
+            heardMs = math.max(heardMs, finalMs);
+            if (finished) over(true);
+          case Refused(:final code):
+            SafeLog.event(LogEvent.retryFailed, [code]);
+            over(false);
+        }
+      },
+      onError: (Object _) => over(false),
+      onDone: () => over(false),
+    );
+    var sent = at;
+    try {
+      final clock = Stopwatch()..start();
+      while (sent < end && !ended.isCompleted && !_halted) {
+        final bytes = await _audio.read(p.audio, start, sent, math.min(retryFrame, end - sent));
+        if (bytes.isEmpty) break;
+        link.add(bytes);
+        sent += bytes.length;
+        final due = Duration(microseconds: ((sent - at) * 1000000 * pace) ~/ bytesPerSecond) - clock.elapsed;
+        if (due > Duration.zero) await Future.any([Future<void>.delayed(due), _stop.future, ended.future]);
+      }
+      if (sent >= end && !ended.isCompleted && !_halted) {
+        link.finish();
+        await Future.any([ended.future, _stop.future, Future<void>.delayed(wait)]);
+      }
+    } on Object {
+      over(false);
+    }
+    unawaited(replies.cancel());
+    try {
+      unawaited(link.close().then((_) {}, onError: (Object _) {}));
+    } on Object {
+      // Already closed.
+    }
+    final finished = ended.isCompleted && await ended.future;
+    if (finished && sent >= end) {
+      await _audio.heard(p, words.toString(), end, done: true);
+      SafeLog.event(LogEvent.retryDone);
+      _changed();
+      return true;
+    }
+    // Cut short: the words already final are kept, and the audio they
+    // cover is cut away (D94).
+    final to = math.min(at + heardMs * bytesPerSecond ~/ 1000, sent) & ~1;
+    if (to > at) {
+      await _audio.heard(p, words.toString(), to, done: false);
+      _changed();
+    }
+    SafeLog.event(LogEvent.retryCut);
+    return false;
+  }
+
+  @override
+  void dispose() {
+    _disposed = true;
+    _away = true;
+    unawaited(_changes?.cancel());
+    _cut();
+    super.dispose();
+  }
+}
diff --git a/app/test/journal/journal_audio_test.dart b/app/test/journal/journal_audio_test.dart
index bb6ec77..c6c40aa 100644
--- a/app/test/journal/journal_audio_test.dart
+++ b/app/test/journal/journal_audio_test.dart
@@ -8,6 +8,7 @@ import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/journal_store.dart';
 
+import '../fixtures.dart';
 import 'io_journal_files.dart';
 
 void main() {
@@ -34,4 +35,18 @@ void main() {
     await keep.discard(id);
     expect(files.everything(), isEmpty);
   });
+
+  // D92 item 4: words for a recording its night no longer names change
+  // nothing, and its audio goes.
+  test('words for a recording no night names: its audio goes', () async {
+    final store = await JournalStore.open(files);
+    final keep = JournalAudio(store);
+    final night = nightsFromFixtures().first;
+    await store.save(night);
+    final id = '1' * 32;
+    await keep.add(id, Uint8List(6400), last: true);
+    await keep.heard((night: night.id, audio: id, from: 0), 'x', 3200, done: false);
+    expect(await store.nights(), [night]);
+    expect(files.everything().keys, [JournalStore.fileOf(night.id)]);
+  });
 }
diff --git a/app/test/journal/journal_test.dart b/app/test/journal/journal_test.dart
index 46538ed..6601702 100644
--- a/app/test/journal/journal_test.dart
+++ b/app/test/journal/journal_test.dart
@@ -78,6 +78,20 @@ void main() {
     expect(await entries(), [Told(b[0]), x, y, z]);
   });
 
+  // D94: words that came for a recording may move a dream while its screen
+  // is open; the edit finds it by the words it opened with.
+  test('an edit finds its dream by its words once moved', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    final n = (await journal.newestFirst()).single;
+    await journal.addDream(IntoNight(n.id), a[1], Lang.en);
+    final w = Waiting('1' * 32);
+    await (await JournalStore.open(files)).save(n.withEntries([Told(b[0]), w, Told(a[0]), Told(a[1])]));
+    await journal.editDream(n.id, 1, 'x', was: a[1]);
+    expect((await journal.night(n.id))!.entries, [Told(b[0]), w, Told(a[0]), const Told('x')]);
+    await journal.editDream(n.id, 2, '', was: a[0]);
+    expect((await journal.night(n.id))!.entries, [Told(b[0]), w, const Told('x')]);
+  });
+
   test('an empty Save keeps nothing', () async {
     for (final text in ['', '  \n ']) {
       expect(await journal.addDream(await journal.targetNow(), text, Lang.en), isFalse);
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index 91efe93..511e251 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -1,6 +1,7 @@
 // SoulDreams Dev's first page: the journal, once its folder is open.
 import 'dart:async';
 import 'dart:io';
+import 'dart:typed_data';
 
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
@@ -8,10 +9,12 @@ import 'package:souldreams/app.dart';
 import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/pages/journal_home.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/recording/recording.dart';
 
+import '../../fixtures.dart';
 import '../../recording/fakes.dart';
 import '../memory_journal_files.dart';
 
@@ -59,6 +62,50 @@ void main() {
     expect(handed.microphone, same(recording.microphone));
   });
 
+  // D92 item 3: a recording waiting is retried only while the app is open:
+  // when the journal opens and when the app comes back; leaving cuts it.
+  testWidgets('the journal opening retries; leaving cuts it; back resumes', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    final files = MemoryJournalFiles();
+    final store = await JournalStore.open(files);
+    final x = '1' * 32;
+    await store.save(nightsFromFixtures().first.withEntries([Waiting(x)]));
+    await store.appendAudio(x, Uint8List(32000));
+    final links = <MemoryLink>[];
+    final recording = Recording(
+      on: true,
+      microphone: SilentMicrophone(),
+      key: () async => 'k',
+      connect: (_) async {
+        final link = MemoryLink();
+        links.add(link);
+        return link;
+      },
+    );
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: recording)));
+    await tester.pump();
+    await tester.pump();
+    expect(links, hasLength(1));
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
+    await tester.pump(const Duration(milliseconds: 150));
+    expect(links.single.closed, isFalse);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
+    await tester.pump(const Duration(milliseconds: 150));
+    expect(links.single.closed, isTrue);
+    expect(lines, ['retryStarted', 'retryCut']);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pump();
+    await tester.pump();
+    expect(links, hasLength(2));
+    await tester.pumpWidget(const SizedBox());
+    await tester.pump(const Duration(seconds: 11));
+  });
+
   // D65: with the phone check, its probe never shows as a row, because the
   // list is not loaded until the check has finished.
   testWidgets('the list waits for the phone check, then shows', (tester) async {
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index c7b0d46..71e94c5 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -8,16 +8,20 @@ import 'dart:typed_data';
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/app_line.dart';
 import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/words/lines.g.dart';
 import 'package:souldreams/words/pending.g.dart';
 
 import '../../fixtures.dart';
+import '../../recording/fakes.dart';
 import '../memory_journal_files.dart';
 import '../zones.dart';
 import 'harness.dart';
@@ -131,6 +135,51 @@ void main() {
     expect((await h.journal.night(n.id))!.entries, [w1, Told(n.dreams[0]), w2, Told(other)]);
   });
 
+  // D93 Q3: while a waiting recording is turned into words, AI·6 shows in
+  // its place, heard by a screen reader; then its words, as its own dream.
+  testWidgets('AI·6 shows in its place while it is transcribed', (tester) async {
+    h = await Harness.make();
+    n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    final x = '1' * 32;
+    await h.store.save(n.withEntries([Told(n.dreams[0]), Waiting(x), Told(n.dreams[1])]));
+    await h.store.appendAudio(x, Uint8List(6400));
+    final links = <MemoryLink>[];
+    final audio = JournalAudio(h.store);
+    final recording = Recording(
+      on: true,
+      microphone: SilentMicrophone(),
+      key: () async => 'k',
+      connect: (_) async {
+        final link = MemoryLink();
+        links.add(link);
+        return link;
+      },
+    ).keeping(audio, waiting: audio);
+    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, recording: recording)));
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    expect(find.byKey(NightPage.transcribingKey), findsNothing);
+    recording.retries!.kick();
+    await tester.pump();
+    await tester.pump();
+    final label = find.byKey(NightPage.transcribingKey);
+    expect(label, findsOneWidget);
+    expect(tester.widget<Semantics>(label).properties.liveRegion, isTrue);
+    final line = tester.widget<AppLine>(find.descendant(of: label, matching: find.byType(AppLine)));
+    expect(line.text, Lines.AI_6.text(Lang.en));
+    expect(tester.getTopLeft(label).dy, greaterThan(tester.getTopLeft(find.text(n.dreams[0])).dy));
+    expect(tester.getTopLeft(label).dy, lessThan(tester.getTopLeft(find.text(n.dreams[1])).dy));
+    await tester.pump(const Duration(milliseconds: 300));
+    final word = n.dreams[1].split(' ').first;
+    links.single.reply(reply(done: [word], finished: true));
+    await tester.pump();
+    await tester.pumpAndSettle();
+    expect(find.byKey(NightPage.transcribingKey), findsNothing);
+    expect(find.byType(DreamBubble), findsNWidgets(3));
+    expect((await h.journal.night(n.id))!.entries, [Told(n.dreams[0]), Told(word), Told(n.dreams[1])]);
+    await tester.pump(const Duration(seconds: 11));
+  });
+
   testWidgets('an emptied dream disappears; the others remain', (tester) async {
     await open(tester);
     await tester.tap(find.text(n.dreams[0]));
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index 23cd1ef..6bb0edf 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -18,6 +18,7 @@ import 'package:souldreams/journal/night_rules.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/recording/heard_text.dart';
 import 'package:souldreams/recording/recording.dart';
+import 'package:souldreams/recording/retries.dart';
 import 'package:souldreams/words/lines.g.dart';
 import 'package:souldreams/words/pending.g.dart';
 
@@ -44,6 +45,26 @@ final class FlakyFiles extends MemoryJournalFiles {
   }
 }
 
+/// Recordings waiting, as the retries see them: none; it counts the looks.
+final class NoneWaiting implements WaitingAudio {
+  int looks = 0;
+
+  @override
+  Future<List<Pending>> waiting() async {
+    looks++;
+    return const [];
+  }
+
+  @override
+  Future<({int start, int size})?> part(String audio) async => null;
+
+  @override
+  Future<Uint8List> read(String audio, int start, int at, int length) async => Uint8List(0);
+
+  @override
+  Future<void> heard(Pending pending, String words, int to, {required bool done}) async {}
+}
+
 /// A folder whose listing, or whose write of the first-use flag, throws.
 final class FirstUseFiles extends MemoryJournalFiles {
   bool listFails = false;
@@ -1775,6 +1796,19 @@ void main() {
     expect(find.byKey(TypingPage.noticeKey), findsNothing);
   });
 
+  // D94: no retry while a typing screen is open; its closing starts one.
+  testWidgets('the typing screen holds the retries while it is open', (tester) async {
+    final none = NoneWaiting();
+    final recording = offline().recording.keeping(MemoryKeep(), waiting: none);
+    await tall(tester, recording: recording);
+    recording.retries!.kick();
+    await tester.pump();
+    expect(none.looks, 0);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pumpAndSettle();
+    expect(none.looks, 1);
+  });
+
   testWidgets('a failed Save keeps the waiting recording for the next', (tester) async {
     final v = offline();
     final files = FlakyFiles();
diff --git a/app/test/recording/no_storage_test.dart b/app/test/recording/no_storage_test.dart
index b10c743..17b5c27 100644
--- a/app/test/recording/no_storage_test.dart
+++ b/app/test/recording/no_storage_test.dart
@@ -23,6 +23,7 @@ void main() {
       'microphone.dart',
       'record_microphone.dart',
       'recording.dart',
+      'retries.dart',
       'soniox.dart',
     });
   });
diff --git a/app/test/recording/retries_test.dart b/app/test/recording/retries_test.dart
new file mode 100644
index 0000000..67fa0aa
--- /dev/null
+++ b/app/test/recording/retries_test.dart
@@ -0,0 +1,365 @@
+// Recordings waiting on the phone, replayed through Soniox's real-time
+// stream (D92 items 2 and 3; D94): a fresh key each time, the saved audio
+// at real-time pace from where its words stopped, one at a time, the
+// oldest night first, only while the app is open and no typing screen is;
+// progress kept when a retry is cut short; the words a dream of their own
+// in the recording's place (D93 Q2), the audio deleted at once.
+import 'dart:async';
+import 'dart:typed_data';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal_audio.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/recording/key_client.dart';
+import 'package:souldreams/recording/recording.dart';
+import 'package:souldreams/recording/retries.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+import 'fakes.dart';
+
+/// [n] bytes of made-up audio, every byte telling its place.
+Uint8List sound(int n, [int from = 0]) => Uint8List.fromList([for (var i = from; i < from + n; i++) i % 251]);
+
+/// The journal's audio, whose reads wait at [gate] once [open] reads have
+/// gone through.
+class Gated implements WaitingAudio {
+  Gated(this._inner);
+
+  final WaitingAudio _inner;
+  int open = 1 << 30;
+  Completer<void>? gate;
+  int reads = 0;
+
+  @override
+  Future<List<Pending>> waiting() => _inner.waiting();
+
+  @override
+  Future<({int start, int size})?> part(String audio) => _inner.part(audio);
+
+  @override
+  Future<Uint8List> read(String audio, int start, int at, int length) async {
+    if (reads++ >= open) await gate?.future;
+    return _inner.read(audio, start, at, length);
+  }
+
+  @override
+  Future<void> heard(Pending pending, String words, int to, {required bool done}) =>
+      _inner.heard(pending, words, to, done: done);
+}
+
+/// The journal's audio, whose recording has no audio left, and which never
+/// takes what it is told.
+final class Deaf extends Gated {
+  Deaf(super.inner);
+
+  @override
+  Future<({int start, int size})?> part(String audio) async => null;
+
+  @override
+  Future<void> heard(Pending pending, String words, int to, {required bool done}) async {}
+}
+
+void main() {
+  final tokens = inventedTokens();
+  final (x, y) = ('1' * 32, '2' * 32);
+  late MemoryJournalFiles files;
+  late JournalStore store;
+  late Gated audio;
+  late List<MemoryLink> links;
+  late List<String> lines;
+  late void Function(String) sink;
+  late Future<String> Function() key;
+  late FakeConnection connection;
+  late Night first;
+  late Night second;
+
+  setUp(() async {
+    lines = [];
+    sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    JournalStore.newQueueForTests();
+    files = MemoryJournalFiles();
+    store = await JournalStore.open(files);
+    audio = Gated(JournalAudio(store));
+    links = [];
+    key = () async => 'k';
+    connection = FakeConnection();
+    [first, second, ...] = nightsFromFixtures();
+  });
+
+  tearDown(() => SafeLog.sink = sink);
+
+  Retries retries({bool on = true, double pace = 0}) => Retries(
+    Recording(
+      on: on,
+      microphone: SilentMicrophone(),
+      key: () => key(),
+      connect: (_) async {
+        final link = MemoryLink();
+        links.add(link);
+        return link;
+      },
+      connection: connection,
+    ),
+    audio,
+    pace: pace,
+    wait: const Duration(milliseconds: 100),
+  );
+
+  Future<void> waits(Night n, List<Dream> entries, Map<String, int> bytes) async {
+    await store.save(n.withEntries(entries));
+    for (final MapEntry(:key, :value) in bytes.entries) {
+      await store.appendAudio(key, sound(value));
+    }
+  }
+
+  Future<List<Dream>?> entries(Night n) async {
+    for (final m in await store.nights()) {
+      if (m.id == n.id) return m.entries;
+    }
+    return null;
+  }
+
+  List<Object> frames(MemoryLink link) => [for (final f in link.sent) if (f is Uint8List) f];
+
+  test('a recording replayed whole becomes its dream; the audio goes', () async {
+    await waits(first, [Told(first.dreams[0]), Waiting(x)], {x: 6400});
+    final r = retries();
+    final seen = <String?>[];
+    r.addListener(() => seen.add(r.transcribing));
+    r.kick();
+    await pumpEventQueue();
+    final link = links.single;
+    expect(frames(link), [sound(3200), sound(3200, 3200)]);
+    expect(link.sent.last, '');
+    link.reply(reply(done: tokens.take(3).toList(), finalMs: 200, finished: true));
+    await pumpEventQueue();
+    expect(await entries(first), [Told(first.dreams[0]), Told(tokens.take(3).join().trimLeft())]);
+    expect(files.files.keys.where((n) => n.contains(x)), isEmpty);
+    expect(link.closed, isTrue);
+    expect(r.transcribing, isNull);
+    expect(seen.first, x);
+    expect(lines, ['retryStarted', 'retryDone']);
+  });
+
+  // D94: cut short, the final words go in before the recording, the audio
+  // they cover is cut away, and the next retry starts from there.
+  test('leaving keeps the progress; back, it resumes at the cut', () async {
+    await waits(first, [Waiting(x)], {x: 32000});
+    audio
+      ..open = 4
+      ..gate = Completer<void>();
+    final r = retries();
+    r.kick();
+    await pumpEventQueue();
+    links.single.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 300));
+    await pumpEventQueue();
+    r.away();
+    audio.gate!.complete();
+    await pumpEventQueue();
+    expect(await entries(first), [Told(tokens[0].trimLeft()), Waiting(x, 9600)]);
+    expect(files.files.keys.where((n) => n.startsWith('audio-')), [JournalStore.audioOf(x, 9600)]);
+    expect(files.files[JournalStore.audioOf(x, 9600)], sound(22400, 9600));
+    expect(lines, ['retryStarted', 'retryCut']);
+    audio.open = 1 << 30;
+    r.back();
+    await pumpEventQueue();
+    final again = links.last;
+    expect(links, hasLength(2));
+    expect(frames(again).first, sound(3200, 9600));
+    expect(frames(again), hasLength(7));
+    again.reply(reply(done: [tokens[1]], finalMs: 700, finished: true));
+    await pumpEventQueue();
+    expect(await entries(first), [Told(tokens[0].trimLeft()), Told(tokens[1].trimLeft())]);
+    expect(files.files.keys.where((n) => n.startsWith('audio-')), isEmpty);
+  });
+
+  test('a broken stream keeps the progress, and waits for a chance', () async {
+    await waits(first, [Waiting(x)], {x: 32000});
+    audio
+      ..open = 3
+      ..gate = Completer<void>();
+    final r = retries();
+    r.kick();
+    await pumpEventQueue();
+    links.single.reply(reply(done: [tokens[0]], finalMs: 200));
+    await pumpEventQueue();
+    await links.single.drop(1011);
+    audio.gate!.complete();
+    await pumpEventQueue();
+    expect(await entries(first), [Told(tokens[0].trimLeft()), Waiting(x, 6400)]);
+    expect(links, hasLength(1));
+    connection.set(true);
+    await pumpEventQueue();
+    expect(links, hasLength(2));
+    expect(frames(links.last).first, sound(3200, 6400));
+  });
+
+  test('no key: nothing changes, a code; the next chance tries again', () async {
+    await waits(first, [Waiting(x)], {x: 3200});
+    key = () async => throw const KeyFailure(502);
+    final r = retries();
+    r.kick();
+    await pumpEventQueue();
+    expect(links, isEmpty);
+    expect(await entries(first), [Waiting(x)]);
+    expect(r.transcribing, isNull);
+    expect(lines, ['retryStarted', 'retryFailed 502']);
+    key = () async => 'k';
+    r.kick();
+    await pumpEventQueue();
+    links.single.reply(reply(done: [tokens[0]], finished: true));
+    await pumpEventQueue();
+    expect(await entries(first), [Told(tokens[0].trimLeft())]);
+  });
+
+  test("Soniox's error: a code, nothing lost, tried again later", () async {
+    await waits(first, [Waiting(x)], {x: 3200});
+    final r = retries();
+    r.kick();
+    await pumpEventQueue();
+    links.single.reply('{"tokens":[],"error_code":402}');
+    await pumpEventQueue();
+    expect(await entries(first), [Waiting(x)]);
+    expect(lines, ['retryStarted', 'retryFailed 402', 'retryCut']);
+  });
+
+  // D93 Q7, P10: no words, and the recording goes; a night left with
+  // nothing at all is deleted.
+  test('silence: the recording goes, and an emptied night with it', () async {
+    await waits(first, [Waiting(x)], {x: 3200});
+    final r = retries();
+    r.kick();
+    await pumpEventQueue();
+    links.single.reply(reply(finalMs: 100, finished: true));
+    await pumpEventQueue();
+    expect(await store.nights(), isEmpty);
+    expect(files.files, isEmpty);
+  });
+
+  test('a recording whose audio is gone simply goes', () async {
+    await store.save(first.withEntries([Told(first.dreams[0]), Waiting(x)]));
+    retries().kick();
+    await pumpEventQueue();
+    expect(links, isEmpty);
+    expect(await entries(first), [Told(first.dreams[0])]);
+  });
+
+  test('oldest night first, one at a time, each its own audio', () async {
+    await waits(second, [Waiting(y)], {y: 3200});
+    await waits(first, [Waiting(x)], {x: 6400});
+    final r = retries();
+    r.kick();
+    r.kick();
+    await pumpEventQueue();
+    expect(links, hasLength(1));
+    expect(frames(links.single), hasLength(2));
+    links.single.reply(reply(done: [tokens[0]], finished: true));
+    await pumpEventQueue();
+    expect(links, hasLength(2));
+    expect(frames(links.last), hasLength(1));
+    links.last.reply(reply(done: [tokens[1]], finished: true));
+    await pumpEventQueue();
+    expect(await entries(first), [Told(tokens[0].trimLeft())]);
+    expect(await entries(second), [Told(tokens[1].trimLeft())]);
+  });
+
+  test('a typing screen holds the retries; its closing starts them', () async {
+    await waits(first, [Waiting(x)], {x: 3200});
+    final r = retries();
+    r.hold();
+    r.kick();
+    connection.set(true);
+    await pumpEventQueue();
+    expect(links, isEmpty);
+    r.release();
+    await pumpEventQueue();
+    expect(links, hasLength(1));
+  });
+
+  test('away, nothing starts; the connection returning starts it', () async {
+    await waits(first, [Waiting(x)], {x: 3200});
+    final r = retries();
+    r.away();
+    r.kick();
+    await pumpEventQueue();
+    expect(links, isEmpty);
+    r.back();
+    await pumpEventQueue();
+    expect(links, hasLength(1));
+  });
+
+  test('after dispose a retry ends quietly, and none starts', () async {
+    await waits(first, [Waiting(x)], {x: 6400});
+    audio
+      ..open = 1
+      ..gate = Completer<void>();
+    final r = retries();
+    r.kick();
+    await pumpEventQueue();
+    r.dispose();
+    audio.gate!.complete();
+    await pumpEventQueue();
+    expect(links.single.closed, isTrue);
+    r.kick();
+    await pumpEventQueue();
+    expect(links, hasLength(1));
+  });
+
+  test('words the journal does not take: a code, no going round', () async {
+    await waits(first, [Waiting(x)], {x: 3200});
+    final r = Retries(
+      Recording(on: true, microphone: SilentMicrophone(), key: () async => 'k', connect: (_) async => MemoryLink()),
+      Deaf(audio),
+      pace: 0,
+    );
+    r.kick();
+    await pumpEventQueue();
+    expect(lines, ['retryFailed -3']);
+    expect(await entries(first), [Waiting(x)]);
+  });
+
+  test('recording off: no retry', () async {
+    await waits(first, [Waiting(x)], {x: 3200});
+    retries(on: false).kick();
+    await pumpEventQueue();
+    expect(links, isEmpty);
+  });
+
+  // D92 item 4: a night deleted while its recording is replayed: nothing of
+  // it comes back, and its audio is gone.
+  test('deleted while replayed: nothing comes back, no audio stays', () async {
+    await waits(first, [Waiting(x)], {x: 32000});
+    audio
+      ..open = 2
+      ..gate = Completer<void>();
+    final r = retries();
+    r.kick();
+    await pumpEventQueue();
+    links.single.reply(reply(done: [tokens[0]], finalMs: 200));
+    await store.delete(first.id);
+    r.away();
+    audio.gate!.complete();
+    await pumpEventQueue();
+    expect(await store.nights(), isEmpty);
+    expect(files.files, isEmpty);
+  });
+
+  test('the audio goes at real-time pace', () async {
+    await waits(first, [Waiting(x)], {x: 9600});
+    final clock = Stopwatch()..start();
+    retries(pace: 1).kick();
+    while (links.isEmpty || links.single.sent.isEmpty || links.single.sent.last != '') {
+      await Future<void>.delayed(const Duration(milliseconds: 10));
+    }
+    expect(clock.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 280)));
+    expect(frames(links.single), hasLength(3));
+  });
+
+  test('each frame is a tenth of a second of audio', () {
+    expect(retryFrame, 3200);
+  });
+}
~~~~

### Task 8 · The mutation rows A144 to A197

Fourteen older rows follow the code they break (A1, A7, A24a, A24b, A24n, A24o, A24w, A27, A28, A29, A51, A70, A71,
A137); 54 new rows, one for each ruling and decision above. Run by hand from the repository root:

```
python3 -I -B tool/app_mutations.py | tail -1
```

Expected: `app mutations: 229 run, 229 caught` (about an hour). Commit:

> Mutation rows: offline recording, A144 to A197; fourteen rows follow the code

**The block:**

~~~~diff
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 880c615..143deb0 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,8 +1,8 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
-# Expected: every row "caught" (A1 to A143, A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A197, A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 175 run, 175 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 229 run, 229 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -22,8 +22,8 @@ APP = os.path.join(os.path.dirname(TOOL), 'app')
 # (code, file in app/, old, new, test file, the test that must fail)
 ROWS = [
     ('A1', 'lib/journal/journal_store.dart',
-     '    final name = fileOf(id);\n    await _files.delete(name);\n',
-     '    final name = fileOf(id);\n',
+     '    final bytes = await _files.read(name);\n    await _files.delete(name);\n',
+     '    final bytes = await _files.read(name);\n',
      'test/journal/journal_store_test.dart', 'deleting a night leaves nothing of it anywhere'),
     ('A2', 'lib/journal/journal_store.dart',
      '      await _files.write(tempPrefix + name, encodeNight(night));\n'
@@ -53,7 +53,7 @@ ROWS = [
     ('A7', 'lib/journal/night.dart',
      ' || !setEquals(json.keys.toSet(), _keys)',
      '',
-     'test/journal/night_test.dart', 'anything not a version-1 night decodes to null'),
+     'test/journal/night_test.dart', 'anything not a version-1 or version-2 night decodes to null'),
     ('A8', 'lib/journal/self_check.dart',
      '    if (!p.excluded || !p.folderComplete || !p.fileComplete) return _failed(step);\n',
      '',
@@ -128,38 +128,37 @@ ROWS = [
     # Task 5a (D61): a read and its write are one turn; invisible text is empty;
     # a night open too long is damaged
     ('A24a', 'lib/journal/journal.dart',
-     '        return _store.update(id, (n) => n.withDreams([...n.dreams, text]));\n',
+     '        return _store.update(id, (n) => n.withEntries([...n.entries, ...added]));\n',
      '        final n = await night(id);\n'
      '        if (n == null) return false;\n'
-     '        await _store.save(n.withDreams([...n.dreams, text]));\n'
+     '        await _store.save(n.withEntries([...n.entries, ...added]));\n'
      '        return true;\n',
      'test/journal/journal_test.dart', 'a delete queued behind a Save keeps the night deleted'),
     ('A24b', 'lib/journal/journal.dart',
      '    await _store.update(id, (n) {\n'
-     '      if (index < 0 || index >= n.dreams.length) return n;\n'
-     '      final dreams = [...n.dreams];\n'
-     '      if (isEmptyText(text)) {\n'
-     '        dreams.removeAt(index);\n'
-     '      } else {\n'
-     '        dreams[index] = text;\n'
-     '      }\n'
-     '      return dreams.isEmpty ? null : n.withDreams(dreams);\n'
-     '    });\n',
+     '      final entries = [...n.entries];\n'
+     '      var at = entries.length;\n',
      ''.join(line + '\n' for line in [
-         '    final n = await night(id);',
-         '    if (n == null) return;',
-         '    if (index < 0 || index >= n.dreams.length) return;',
-         '    final dreams = [...n.dreams];',
-         '    if (isEmptyText(text)) {',
-         '      dreams.removeAt(index);',
-         '    } else {',
-         '      dreams[index] = text;',
+         '    final read = await night(id);',
+         '    if (read == null) return;',
+         '    final copy = [...read.entries];',
+         '    if (index >= 0 && index < copy.length '
+         '&& copy[index] is Told) {',
+         '      if (isEmptyText(text)) {',
+         '        copy.removeAt(index);',
+         '      } else {',
+         '        copy[index] = Told(text);',
+         '      }',
          '    }',
-         '    if (dreams.isEmpty) {',
+         '    if (copy.isEmpty) {',
          '      await _store.delete(id);',
          '    } else {',
-         '      await _store.save(n.withDreams(dreams));',
+         '      await _store.save(read.withEntries(copy));',
          '    }',
+         '    if (copy.isNotEmpty) return;',
+         '    await _store.update(id, (n) {',
+         '      final entries = [...n.entries];',
+         '      var at = entries.length;',
      ]),
      'test/journal/journal_test.dart', 'a delete queued right behind an edit keeps the night deleted'),
     ('A24c', 'lib/journal/night_rules.dart',
@@ -209,12 +208,12 @@ ROWS = [
      'textCapitalization: TextCapitalization.sentences, smartQuotesType: SmartQuotesType.disabled,',
      'test/journal/pages/typing_page_test.dart', 'nothing else about the keyboard is overridden (P12)'),
     ('A24n', 'lib/journal/pages/typing_page.dart',
-     'editDream(e.id, e.index, _text.text)',
-     'editDream(e.id, 0, _text.text)',
+     'editDream(e.id, e.index, _text.text, waiting: waiting, was: e.text)',
+     'editDream(e.id, 0, _text.text, waiting: waiting)',
      'test/journal/pages/typing_page_test.dart', 'an edit replaces the dream at its own place'),
     ('A24o', 'lib/journal/pages/typing_page.dart',
-     'editDream(e.id, e.index, _text.text)',
-     'editDream(e.id, e.index, _text.text.trim().isEmpty ? e.text : _text.text)',
+     'editDream(e.id, e.index, _text.text, waiting: waiting, was: e.text)',
+     'editDream(e.id, e.index, _text.text.trim().isEmpty ? e.text : _text.text, waiting: waiting, was: e.text)',
      'test/journal/pages/typing_page_test.dart', 'an edit emptied to nothing removes that dream only'),
     # Task 9b (D63): no automatic focus, a page that scrolls, MP·62, and a
     # save when the app is left
@@ -247,7 +246,7 @@ ROWS = [
      'if (_away)',
      'test/journal/pages/typing_page_test.dart', 'a failed save on leaving is not retried on return'),
     ('A24w', 'lib/journal/pages/typing_page.dart',
-     'if (leaving && isEmptyText(_text.text)) return;\n',
+     'if (leaving && isEmptyText(_text.text) && _waiting.isEmpty) return;\n',
      '',
      'test/journal/pages/typing_page_test.dart', 'leaving the app with nothing typed keeps nothing and stays'),
     # Task 9c (the review of 9b): MP·62 in the scroll area, cleared on a retry
@@ -366,16 +365,16 @@ ROWS = [
      'if (c < 0 || (c == 0',
      'test/journal/night_rules_test.dart', "tonight's night is the latest one not yet closed"),
     ('A27', 'lib/journal/journal.dart',
-     '    if (isEmptyText(text)) return false;\n',
-     '',
+     '    final added = <Dream>[if (!isEmptyText(text)) Told(text), ...waiting];\n',
+     '    final added = <Dream>[Told(text), ...waiting];\n',
      'test/journal/journal_test.dart', 'an empty Save keeps nothing'),
     ('A28', 'lib/journal/journal.dart',
-     '      dreams.removeAt(index);',
-     '      dreams[index] = text;',
+     '          entries.removeAt(index);',
+     '          entries[index] = Told(text);',
      'test/journal/journal_test.dart', 'an edit replaces the dream; an emptied dream disappears'),
     ('A29', 'lib/journal/journal.dart',
-     'return dreams.isEmpty ? null : n.withDreams(dreams);',
-     'return n.withDreams(dreams);',
+     '      if (entries.isEmpty) return null;\n',
+     '',
      'test/journal/journal_test.dart', 'a night whose every dream is emptied is deleted, nothing left'),
     ('A30', 'lib/journal/pages/typing_page.dart',
      'await widget.journal.addDream(widget.target, ',
@@ -467,7 +466,7 @@ ROWS = [
      '    middle = words;\n',
      'test/recording/heard_text_test.dart', 'after typed words: one space where neither side has one'),
     ('A51', 'lib/recording/recording.dart',
-     '    if (!allowed) return _fail(LogEvent.recordingRefused);\n',
+     '    if (!allowed) return _refused();\n',
      '',
      'test/recording/recording_test.dart', 'the microphone refused: no key asked, a code'),
     ('A52', 'lib/recording/recording.dart',
@@ -543,12 +542,12 @@ ROWS = [
      '      return;\n',
      'test/recording/recording_test.dart', 'a cancel while the stream opens closes it on arrival'),
     ('A70', 'lib/recording/recording.dart',
-     '    if (link != null) _closeQuietly(link);\n',
-     '    if (link != null) await link.close();\n',
+     '    onEnded();\n    if (link != null) _closeQuietly(link);\n',
+     '    onEnded();\n    if (link != null) await link.close();\n',
      'test/recording/recording_test.dart', 'a close that never completes holds nothing up'),
     ('A71', 'lib/recording/recording.dart',
-     '    if (link != null) _closeQuietly(link);\n',
-     '',
+     '    onEnded();\n    if (link != null) _closeQuietly(link);\n',
+     '    onEnded();\n',
      'test/recording/recording_test.dart', 'words come back; a stop waits for the last ones'),
     ('A72', 'lib/recording/recording.dart',
      '(_cancelled || _ended || stopping != null) {',
@@ -788,8 +787,8 @@ ROWS = [
      '      return _brokeOff(LogEvent.recordingKeyFailed, 0);\n    }\n',
      'test/recording/recording_test.dart', 'a cancel before the stream opens sends nothing'),
     ('A137', 'lib/recording/recording.dart',
-     '    SafeLog.event(code, [number]);\n    unawaited(_shut());\n',
-     '    SafeLog.event(code, [number]);\n',
+     '    SafeLog.event(code, [number]);\n    if (_keeping) {\n      _goOn();\n    } else {\n      unawaited(_shut());\n    }\n',
+     '    SafeLog.event(code, [number]);\n    if (_keeping) {\n      _goOn();\n    }\n',
      'test/recording/recording_test.dart', 'no key: it stops as a broken stream does, a code'),
     ('A138', 'lib/recording/recording.dart',
      '_now().difference(at) < keyFresh) {',
@@ -814,6 +813,228 @@ ROWS = [
      'await Future.any([opening, _finished.future]).timeout',
      'await opening.timeout',
      'test/recording/recording_test.dart', 'a cancel ends a stop that waits for the stream'),
+    # Offline recording (D92 to D94; branch offline-recording). Each row
+    # breaks one ruling; the named test must fail.
+    ('A144', 'lib/journal/pages/typing_page.dart',
+     'Trouble.refused => PendingLines.MP_63.text(appLanguage),',
+     'Trouble.refused => Lines.MP_11.text(appLanguage),',
+     'test/journal/pages/typing_page_test.dart', 'a refused microphone shows MP·63, logs a code'),
+    ('A145', 'lib/journal/pages/typing_page.dart',
+     '        if (_trouble != null) setState(() => _trouble = null);\n',
+     '',
+     'test/journal/pages/typing_page_test.dart', 'MP·63 goes at the next tap, and returns on a refusal'),
+    ('A146', 'lib/journal/pages/typing_page.dart',
+     '                                            tooltip: live\n',
+     '                                            tooltip: false\n',
+     'test/journal/pages/typing_page_test.dart', 'the microphone is named MP·11, and MP·64 while it records'),
+    ('A147', 'lib/recording/recording.dart',
+     '    onTrouble(Trouble.refused);\n',
+     '',
+     'test/journal/pages/typing_page_test.dart', 'a refused microphone shows MP·63, logs a code'),
+    ('A148', 'lib/journal/night.dart',
+     '    if (version != formatVersion && version != _firstVersion) return null;\n',
+     '    if (version != formatVersion) return null;\n',
+     'test/journal/night_test.dart', 'every version-1 night reads whole and saves as version 2'),
+    ('A149', 'lib/journal/night.dart',
+     'if (version == _firstVersion || x is! Map',
+     'if (x is! Map',
+     'test/journal/night_test.dart', 'a waiting recording is refused in a version-1 file'),
+    ('A150', 'lib/journal/night.dart',
+     "      'version': formatVersion,",
+     "      'version': 1,",
+     'test/journal/night_test.dart', 'the file holds exactly the version-2 fields'),
+    ('A151', 'lib/journal/night.dart',
+     '    if (audio.toSet().length != audio.length) return null;\n',
+     '',
+     'test/journal/night_test.dart', 'a misshapen waiting recording, or one twice, decodes to null'),
+    ('A152', 'lib/journal/night.dart',
+     ' || from.isOdd) return null;',
+     ') return null;',
+     'test/journal/night_test.dart', 'a misshapen waiting recording, or one twice, decodes to null'),
+    ('A153', 'lib/journal/row_text.dart',
+     "  if (told.isEmpty) return '';\n",
+     '',
+     'test/journal/row_text_test.dart', 'the opening is the first told dream; none when all wait'),
+    ('A154', 'lib/journal/journal.dart',
+     '      if (index >= 0 && index < entries.length '
+     '&& entries[index] is Told) {',
+     '      if (index >= 0 && index < entries.length) {',
+     'test/journal/journal_test.dart', 'an edit counts waiting dreams, and never replaces one'),
+    ('A155', 'lib/journal/journal_store.dart',
+     '    for (final audio in _namedIn(bytes)) {\n      await _discard(audio);\n    }\n',
+     '',
+     'test/journal/journal_store_test.dart', "deleting a night deletes its waiting audio, no other's"),
+    ('A156', 'lib/journal/journal_store.dart',
+     '      if (newest[id] != start) {',
+     '      if (false) {',
+     'test/journal/journal_store_test.dart', 'at open, audio no night names is swept with a code'),
+    ('A157', 'lib/journal/journal_store.dart',
+     '      if (bytes != null) named.addAll(_namedIn(bytes));',
+     '      final night = bytes == null ? null : decodeNight(bytes);\n'
+     '      if (night != null) named.addAll(_namedIn(bytes!));',
+     'test/journal/journal_store_test.dart', 'at open, audio no night names is swept with a code'),
+    ('A158', 'lib/journal/journal_store.dart',
+     '    await _files.delete(audioOf(id, part.start));\n  });',
+     '  });',
+     'test/journal/journal_store_test.dart', 'a cut keeps only the rest, under its new start'),
+    ('A159', 'lib/journal/journal_store.dart',
+     'if (part == null || part.start >= from) return;',
+     'if (part == null) return;',
+     'test/journal/journal_store_test.dart', 'a cut keeps only the rest, under its new start'),
+    ('A160', 'ios/Runner/AppDelegate.swift',
+     'atPath: url.path, contents: nil, attributes: [.protectionKey: FileProtectionType.complete])',
+     'atPath: url.path, contents: nil, attributes: nil)',
+     'test/journal/channel_journal_files_test.dart', 'the Swift side answers every method this side calls'),
+    ('A161', 'lib/journal/self_check.dart',
+     '    if (!a.excluded || !a.folderComplete || !a.fileComplete) return _failed(step);\n',
+     '',
+     'test/journal/self_check_test.dart', 'an unprotected audio file fails at step 6, leaving nothing'),
+    ('A162', 'lib/recording/recording.dart',
+     '    if (_keeping && !(_recording.connection?.online ?? true)) {',
+     '    if (false) {',
+     'test/recording/recording_test.dart', 'no connection at the tap: no key, MP·15, it all waits'),
+    ('A163', 'lib/recording/recording.dart',
+     "    _held.clear();\n    onHeard('', '');\n    onTrouble(Trouble.broke);",
+     '    _held.clear();\n    onTrouble(Trouble.broke);',
+     'test/recording/recording_test.dart', "a break: final words stay; the rest waits from Soniox's count"),
+    ('A164', 'lib/recording/recording.dart',
+     '    if (!_keeping) {\n      unawaited(_shut());\n      return;\n    }\n',
+     '',
+     'test/recording/recording_test.dart', 'a keep that fails: a code; a break stops it'),
+    ('A165', 'lib/recording/recording.dart',
+     'if (_keepFailed || _allFinal || _recorded <= from)',
+     'if (_keepFailed || _recorded <= from)',
+     'test/recording/recording_test.dart', 'every frame is kept in order; all final, deleted at once'),
+    ('A166', 'lib/recording/recording.dart',
+     '_covered = math.max(_covered, finalMs * bytesPerSecond ~/ 1000);',
+     '_covered = math.max(_covered, 0);',
+     'test/recording/recording_test.dart', "a break: final words stay; the rest waits from Soniox's count"),
+    ('A167', 'lib/recording/recording.dart',
+     'if (_recorded >= _recording.cap && !_capped) {',
+     'if (false) {',
+     'test/recording/recording_test.dart', 'at the cap it stops itself as Stop does, a code'),
+    ('A168', 'lib/recording/recording.dart',
+     'const recordingCap = 10 * 60 * bytesPerSecond;',
+     'const recordingCap = 30 * 60 * bytesPerSecond;',
+     'test/recording/recording_test.dart', 'every recording stops at ten minutes (D93 Q6)'),
+    ('A169', 'lib/recording/recording.dart',
+     '      _keep(frame);\n',
+     '',
+     'test/recording/recording_test.dart', 'every frame is kept in order; all final, deleted at once'),
+    ('A170', 'lib/recording/recording.dart',
+     "    _left = (audio: audio, from: from);\n    onHeard('', '');",
+     '    _left = (audio: audio, from: from);',
+     'test/recording/recording_test.dart', 'a cancel mid-stream: the rest waits; unsettled words leave'),
+    ('A171', 'lib/recording/recording.dart',
+     '    _handOn(last: true);\n    _left =',
+     '    _left =',
+     'test/recording/recording_test.dart', 'no connection at the tap: no key, MP·15, it all waits'),
+    ('A172', 'lib/recording/soniox.dart',
+     'finalMs: ms is int '
+     '&& ms > 0 ? ms : 0,',
+     'finalMs: 0,',
+     'test/recording/soniox_test.dart', 'final_audio_proc_ms is read; missing or odd, it is 0'),
+    ('A173', 'lib/recording/connection.dart',
+     'if (event is! bool || event == _online) return;',
+     'if (event is! bool) return;',
+     'test/recording/connection_test.dart', 'online until the phone says; each change once'),
+    ('A174', 'lib/journal/pages/typing_page.dart',
+     '    if (left != null) _waiting.add(Waiting(left.audio, left.from));\n',
+     '',
+     'test/journal/pages/typing_page_test.dart', 'no connection: MP·15, no MP·33, and Save keeps it waiting'),
+    ('A175', 'lib/journal/pages/typing_page.dart',
+     'if (_trouble != Trouble.offline) {',
+     'if (true) {',
+     'test/journal/pages/typing_page_test.dart', 'no connection: MP·15, no MP·33, and Save keeps it waiting'),
+    ('A176', 'lib/journal/journal.dart',
+     'n.withEntries([...n.entries, ...added])',
+     'n.withEntries([...n.entries, ...added.take(1)])',
+     'test/journal/journal_test.dart', 'a Save keeps waiting recordings after its words'),
+    ('A177', 'lib/journal/journal.dart',
+     '      entries.insertAll(at, waiting);\n',
+     '',
+     'test/journal/journal_test.dart', 'an edit puts waiting recordings after its dream, or instead'),
+    ('A178', 'lib/journal/journal.dart',
+     '        index = entries.indexOf(Told(was));\n',
+     '',
+     'test/journal/journal_test.dart', 'an edit finds its dream by its words once moved'),
+    ('A179', 'lib/journal/journal_audio.dart',
+     '[...told, if (!done) Waiting(pending.audio, to)]',
+     '[...told, Waiting(pending.audio, to)]',
+     'test/recording/retries_test.dart', 'a recording replayed whole becomes its dream; the audio goes'),
+    ('A180', 'lib/journal/journal_audio.dart',
+     '    if (done || !found) {',
+     '    if (done) {',
+     'test/journal/journal_audio_test.dart', 'words for a recording no night names: its audio goes'),
+    ('A181', 'lib/journal/journal_audio.dart',
+     '      return entries.isEmpty ? null : n.withEntries(entries);',
+     '      return n.withEntries(entries);',
+     'test/recording/retries_test.dart', 'silence: the recording goes, and an emptied night with it'),
+    ('A182', 'lib/recording/retries.dart',
+     '    _holds++;\n    _cut();',
+     '    _cut();',
+     'test/recording/retries_test.dart', 'a typing screen holds the retries; its closing starts them'),
+    ('A183', 'lib/recording/retries.dart',
+     '    if (to > at) {',
+     '    if (false) {',
+     'test/recording/retries_test.dart', 'leaving keeps the progress; back, it resumes at the cut'),
+    ('A184', 'lib/recording/retries.dart',
+     'final due = Duration(microseconds: ((sent - at) * 1000000 * pace) '
+     '~/ bytesPerSecond) - clock.elapsed;',
+     'final due = Duration.zero - clock.elapsed;',
+     'test/recording/retries_test.dart', 'the audio goes at real-time pace'),
+    ('A185', 'lib/recording/retries.dart',
+     '      if (online) kick();',
+     '      if (online) {}',
+     'test/recording/retries_test.dart', 'a broken stream keeps the progress, and waits for a chance'),
+    ('A186', 'lib/recording/retries.dart',
+     '    _away = true;\n    _cut();',
+     '    _cut();',
+     'test/recording/retries_test.dart', 'away, nothing starts; the connection returning starts it'),
+    ('A187', 'lib/recording/retries.dart',
+     'if (!await _one(all.first)) break;',
+     'if (!await _one(all.last)) break;',
+     'test/recording/retries_test.dart', 'oldest night first, one at a time, each its own audio'),
+    ('A188', 'lib/recording/retries.dart',
+     '    if (!_disposed) notifyListeners();',
+     '    notifyListeners();',
+     'test/journal/pages/journal_home_test.dart', 'the journal opening retries; leaving cuts it; back resumes'),
+    ('A189', 'lib/journal/pages/journal_home.dart',
+     '    if (state == AppLifecycleState.hidden || state == AppLifecycleState.paused) retries.away();\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the journal opening retries; leaving cuts it; back resumes'),
+    ('A190', 'lib/journal/pages/journal_home.dart',
+     '      _recording?.retries?.kick();\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the journal opening retries; leaving cuts it; back resumes'),
+    ('A191', 'lib/journal/pages/typing_page.dart',
+     '    widget.recording?.retries?.hold();\n',
+     '',
+     'test/journal/pages/typing_page_test.dart', 'the typing screen holds the retries while it is open'),
+    ('A192', 'lib/journal/pages/night_page.dart',
+     'when _transcribing == audio',
+     'when false',
+     'test/journal/pages/night_page_test.dart', 'AI·6 shows in its place while it is transcribed'),
+    ('A193', 'ios/Runner/AppDelegate.swift',
+     'let online = path.status == .satisfied',
+     'let online = true',
+     'test/recording/connection_test.dart', 'the Swift side watches the path, sending true or false'),
+    ('A194', 'ios/Runner/AppDelegate.swift',
+     'try rest.write(to: to, options: [.completeFileProtection])',
+     'try rest.write(to: to)',
+     'test/journal/channel_journal_files_test.dart', 'the Swift side answers every method this side calls'),
+    ('A195', 'lib/journal/journal_store.dart',
+     'final bare = name.startsWith(tempPrefix) ? name.substring(tempPrefix.length) : name;',
+     'final bare = name;',
+     'test/journal/journal_store_test.dart', "deleting a night deletes its waiting audio, no other's"),
+    ('A196', 'lib/recording/retries.dart',
+     '    if (finished && sent >= end) {',
+     '    if (sent >= end) {',
+     'test/recording/retries_test.dart', "Soniox's error: a code, nothing lost, tried again later"),
+    ('A197', 'lib/journal/journal_audio.dart',
+     '    final text = words.trimLeft();',
+     '    final text = words;',
+     'test/recording/retries_test.dart', 'leaving keeps the progress; back, it resumes at the cut'),
 ]
 
 
~~~~

### Task 9 · Status.md

The current branch, the road ahead, the app's store, offline recording, the counts, banked item 110, the pending
lines MP·63 and MP·64, and "Rulings during offline-recording" (D92 to D94).

Commit:

> Docs: Status.md for offline-recording (D92 to D94)

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
index 1efc205..cc6f4f8 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,7 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-17, in branch `recording` (Task 16 done: 16a to 16h, D79 to D91; the final docs task), by Claude
-Code.
+Last updated: 2026-11-18, in branch `offline-recording` (its plan's Task 9), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -15,19 +14,16 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`recording`: recording by voice in SoulDreams Dev only, and the server's first feature (D69, as D71 corrects it; D70;
-D71): the microphone permission (EM·3), the words shown as the dreamer speaks, Save keeping them as a dream; the
-audio never stored on the server, and in this slice not on the phone either, since it needs a connection; the
-typing screen's current design (D70 items 2, 7 and 8); the two banked read failures; one front door, a Lambda
-function URL authorised by the beta key, issuing short-lived Soniox keys. Plan: `docs/plans/recording.md`.
+`offline-recording`: offline recording in SoulDreams Dev only (D92 to D94): every recording's audio kept in the
+journal's folder until its words are final; no connection, or a failure, and the recording goes on and waits;
+retries through Soniox's real-time stream only while the app is open, progress kept; MP·15, MP·54, MP·63, MP·64 and
+AI·6; the night's file at version 2 (an on-phone storage change, `docs/workflow.md` (c)). Plan:
+`docs/plans/offline-recording.md`.
 
 ## Road ahead
 
-- The owner merges `recording` (every phone check of Task 16 passed, 2026-11-17). The first deploy and the server's
-  address in `hosts.dart` are done (Tasks 13 to 15).
-- The next slice: offline recording, the audio held on the phone only until it is transcribed (main-path.md,
-  Recording; D71). It is an on-phone storage change, under `docs/workflow.md`, "On-phone storage changes", and it
-  brings MP·15 and MP·54.
+- The owner rehearses the night file's version 2 (the plan's Task 3), runs the phone checks (Task 10), and merges
+  `offline-recording`.
 - The readings: our server's own spending counter comes with them (D69), and response streaming on the function
   URL (head's message 14; whether eu-north-1 has it is checked first).
 - A later branch, by the Head of Technology's direction (with D32): the import gains a kind for lens sections 3, 4, 5,
@@ -57,7 +53,8 @@ function URL authorised by the beta key, issuing short-lived Soniox keys. Plan:
 - The fonts (D49 a): Tangerine, Sorts Mill Goudy, Inter (Regular and SemiBold, the 18pt statics), Nunito (Regular,
   Italic) and Habibi, static TTFs with their OFL licences in `app/assets/fonts/`, each listed in `fingerprints.txt`
   (G2), declared in `pubspec.yaml`. The owner's download; never fetched at run time (R10).
-- The journal's store (D49 b, c), with no screen yet: `app/lib/journal/`. One JSON file per night, format version 1,
+- The journal's store (D49 b, c), with no screen yet: `app/lib/journal/`. One JSON file per night, format version 2
+  (version 1 still read; D93 Q2: a dream is told in words or a recording waiting, `{"waiting", "from"}`),
   in `Library/Application Support/Journal`; the folder excluded from backup; the folder and every file with complete
   file protection, through the Swift channel in `AppDelegate.swift`. A save writes a temporary file, flushes it to the
   disk (F_FULLFSYNC, else fsync) and renames it; a failed save removes its own temporary file. Every store operation
@@ -122,9 +119,23 @@ function URL authorised by the beta key, issuing short-lived Soniox keys. Plan:
   `AppDelegate.swift` (`souldreams/audio_session`), built into all three apps and reached from SoulDreams Dev only,
   as D65; a failed release logs `recordingReleaseFailed` (D79 c, D84, D85). Recording off, a refused microphone or
   a microphone that fails: nothing starts, a code, nothing new shown, and the field takes typing at once; a stream
-  that breaks stops, keeping the words shown; MP·15 and MP·54 are not shown (D71). Nothing in `lib/recording/` can
-  write a file, and the `record` package is used in stream mode only (`no_storage_test.dart`). Off while
-  `Hosts.server` is empty or the build has no beta key.
+  that breaks stops, keeping the words shown, when no audio is kept (D71). Nothing in `lib/recording/` can write a
+  file, and the `record` package is used in stream mode only (`no_storage_test.dart`). Off while `Hosts.server` is
+  empty or the build has no beta key. A refused microphone shows MP·63 where MP·62 shows, until the next tap; the
+  microphone is named MP·64 while it records (head's message 21).
+- Offline recording (D92 to D94; SoulDreams Dev only). Every recording's audio is kept from its first frame in the
+  journal's folder (`audio-<id>-<start>.pcm`, plain 16 kHz PCM, complete protection, `JournalAudio`), and deleted at
+  once when every word is final. No connection at the tap (our own Swift channel over Apple's path monitor,
+  `souldreams/network`): no key, MP·15, no MP·33. A key, a stream or Soniox's budget failing: MP·54, and the
+  recording goes on; the words not yet final leave the field; what is not in final words waits, from Soniox's
+  `final_audio_proc_ms`. Every recording stops itself at ten minutes. A Save puts each waiting recording after its
+  words, as a dream of its own; nothing typed but a recording waiting keeps the night. The retries
+  (`lib/recording/retries.dart`): the saved audio replayed through the real-time stream with a fresh key, at
+  real-time pace, one at a time, oldest night first, only while the app is open (when the journal opens, the app
+  comes back, a typing screen closes or the connection returns), never while a typing screen is open; progress kept
+  on any cut (the final words a dream before it, the audio they cover cut away). AI·6 in the waiting dream's place
+  on the night's page while it runs (no shimmer, a stand-in). Deleting a night deletes its waiting audio; at open,
+  audio no night names is swept (`audioSwept`). The phone check has steps 6 and 7 for a probe of silence.
 - The journal list's read failures and the typing screen's first-use read (D71 Q18): a failed list read keeps
   the rows shown and logs `journalListFailed`; at the record button it opens nothing; a failed first-use read
   shows MP·32, marks nothing and logs `firstUseReadFailed`; a failed mark still shows MP·10.
@@ -156,10 +167,10 @@ function URL authorised by the beta key, issuing short-lived Soniox keys. Plan:
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 307 tests, and 175 mutation checks (A1 to A143; A55, A73, A80 to A83, A86 to A88, A94, A99,
+- The app's analyzer baseline: `No issues found!`. The app has 375 tests, and 229 mutation checks (A1 to A197; A55, A73, A80 to A83, A86 to A88, A94, A99,
   A128 to A130 and A142 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 175 run, 175 caught`); `check_all.sh` does not call it (D55).
+  (expected: `app mutations: 229 run, 229 caught`); `check_all.sh` does not call it (D55).
 
 ## The server
 
@@ -573,6 +584,12 @@ Banked in recording:
      plugin error would be an uncaught async error with native text, no dreamer's words); a `finished` reply with no
      stop pending would leave the session open with the microphone on (Soniox sends it only after the end frame:
      D17); the five-second budget starts after the microphone's stop and the audio's release (both fast).
+110. Offline recording (the plan's decisions under D91): a crash during a recording loses that recording's audio,
+     swept at the next open, as it loses unsaved typing; a keep that fails falls back to D71 (a later break shows
+     nothing new); AI·6 has no shimmer; a retry does not keep the screen awake, so the dreamer's lock pauses it (its
+     progress kept); a recording's audio is retried with no cap on attempts until its words come or its night is
+     deleted; the Swift channel's new methods and the path monitor are proved by the owner's build and phone checks
+     only.
 
 ## Before Cohort 1
 
@@ -611,6 +628,8 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 - MP·60 (the confirmation's Delete) and MP·61 (its Cancel), head's message 16, founder-approved.
 - MP·62 (the typing screen's failed save), D63 (head's message 19, Product message 18), founder-ruled; added by the
   owner in Task 9b.
+- MP·63 (the microphone refused) and MP·64 (the stop control's spoken name), head's message 21 (Product message 20),
+  founder-approved; built in `offline-recording`.
 - W27·5's privacy-page text (head's message 16) waits for the disclosure and privacy page, under Settings; it is not
   in the pending file.
 
@@ -794,6 +813,20 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 - D91 (standing): when a review finding stops the build and when Claude Code decides and continues (ruling-restoring
   fixes, stale comments, test gaps, weak rows; D17 notes banked); reports in batches.
 
+## Rulings during offline-recording
+
+- D92 (owner, 2026-11-17): every recording's audio kept in the journal's folder until its text is final, then
+  deleted at once; retries replay it through Soniox's real-time stream with a fresh key; retries only while the app
+  is open (launch, foreground, connection back), no background task; deleting a night deletes its waiting audio;
+  plain 16 kHz mono PCM under complete protection. Product (head's message 21): MP·54 for a cut connection and a
+  reached budget, MP·15 with no connection at the tap; MP·63 and MP·64.
+- D93 (founder, 2026-11-17): the investigation's Q2 to Q7 as leaned (a retried recording's words a dream of their
+  own in its place; nothing shown while it waits, AI·6 while transcribed; the lines where MP·62 shows until the next
+  tap, MP·15 heard instead of MP·33; the words not yet final leave at a break; nothing typed but a recording waiting
+  keeps the night), except Q6: a ten-minute cap on every recording. Its Q1 B (Soniox's file API) is replaced by D94.
+- D94 (founder): route D: retries through the real-time stream (D92 item 2 restored), only while the app is open,
+  progress kept across openings, words may appear in parts; no server, AWS or Soniox change.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C16-P state (`ff3b229`), in commit `ca29414` (Task 6). The ordinal
~~~~

### Task 10 · [OWNER] The phone checks, SoulDreams Dev, invented nights only

Build and install SoulDreams Dev as usual, with `--dart-define-from-file=$HOME/.soul-dreams/recording-dev.json`, and
`--dart-define=JOURNAL_SELF_CHECK=true` for the first item. Speak only invented nights, read aloud by the Mac (R2):

```
cd ~/Developer/soul-dreams-app && say "$(python3 -c 'import json;print(json.load(open("fixtures/invented-nights.json"))["nights"][0]["dreams"][0])')"
```

**The phone check.** The log shows `journalCheckPassed` (steps 1 to 7). The container holds no probe file and no
`audio-` file.

**The two new lines.**
- Refuse the microphone (Settings → SoulDreams Dev → Microphone off), tap the microphone: MP·63 under the
  instruction, VoiceOver reads it; typing works. Tap again: it goes, then comes back. Allow the microphone again.
- While recording, VoiceOver names the microphone MP·64 ("Stop recording"); idle, MP·11.

**No connection at the tap.** Airplane mode, open the typing screen, tap the microphone while the Mac reads: the level
line and the timer run; MP·15 shows; VoiceOver reads MP·15 and not MP·33. Stop, Save. The journal row shows the date
alone; the night's page shows "Dreams" and nothing else. Download the container: one `night-…json` naming
`"waiting"`, and one `audio-<id>-0.pcm` of about 32,000 bytes a second spoken.

**The retry.** With the night's page open, turn airplane mode off: AI·6 shows in the recording's place for about as
long as the recording lasted, then the words, as a dream. The container: no `audio-` file left.

**A cut connection.** Online, record while the Mac reads; halfway, turn airplane mode on: MP·54 shows, the words
already final stay, the ones not yet settled go, the timer keeps running. Stop, Save: the words, then nothing after
them on the night's page. Airplane mode off, the app open: the rest arrives as the next dream.

**Progress kept.** Record two minutes offline and save. Turn the connection on, open the night, and after about one
minute leave the app (home). Come back: the first part's words are a dream, the rest still waiting (AI·6 again,
then the rest as the next dream). The container in between shows `audio-<id>-<start>.pcm` with a start above zero.

**Launch.** Record offline, save, quit the app from the app switcher, turn the connection on, open the app: the
retry starts by itself (open the night to see AI·6).

**No retry while typing.** With a recording waiting and the connection on, open the typing screen before the retry
starts: nothing changes while it is open; close it: the retry starts.

**The cap.** Record offline for ten minutes (the Mac reading in a loop): the recording stops by itself at 10:00, as
Stop does.

**Deleting.** Record offline, save, delete the night (⋯, Delete): the container holds no `audio-` file and no file
naming that night.

**Music.** Play music, record offline, stop: the music resumes (D79 c).

**Soniox.** Its usage log shows the retries as real-time streams, with no reference of ours; no file in its Files
list.

Bring the results as a checklist, with the log's codes only (R3). Anything different: stop (R14).

## Part 4 · Questions (numbered; a blank is not a yes)

None stop this plan. Every point the rulings leave open is about how to build, and is decided under D91 in Part 1.
One thing for the owner to know before Task 3: the rehearsal installs SoulDreams Dev from `main` first, then from
this branch over it; SoulDreams Dev holds invented nights only.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/off/build`, from `git archive` of `f8fdc43`. As
   in the recording plan, the sandbox refuses a git repository there, so each task's state was kept as a snapshot
   (`./.scratch/off/snaps/<task>`), and each block in Part 3 is `git diff --no-index` between two snapshots. The
   guards ran on every snapshot with `guards.py --walk`: `all passed`.
2. **The counts measured on the snapshots**: app tests 309 (Task 1), 318 (Task 2), 327 (Task 4), 342 (Task 5), 354
   (Task 6), 375 (Task 7, 8 and 9), `No issues found!` at each.
3. **Mutations on the build**: the first full run caught every row up to A178 but two, A19 and A165; it then hung at
   A179, whose mutation made the retry loop go round forever on microtasks. Each was handled under D91 and folded
   into its task:
   - A19 (an older row): the new `append` also holds `try flush(url)`, so the Swift check now looks for the write and
     its flush together (Task 4's test);
   - A165: its test's count covered all the audio, so it now ends short of it (Task 5's test);
   - A179: a real gap: a recording heard whole that the journal does not take now stops the retries with
     `retryFailed -3` (Task 7, with its test; decision 12);
   - A180 and A197, which then survived: A180 now names a test of `JournalAudio.heard` for a recording no night
     names (Task 7's test), and A197 the test whose words begin with a space.
   Then A19, A165 and A179 to A197 again: every row caught.
4. **Replayed on a fresh copy**, `./.scratch/off/replay`, from `git archive` of `f8fdc43`, with git kept out of the
   parent repository (`GIT_CEILING_DIRECTORIES`):
   - every block applied with `git apply`, in order;
   - after each task, the replayed tree against that task's snapshot: no difference at all, and the analyzer and
     the tests as in 2;
   - on the replayed tree: `No issues found!`; `+375: All tests passed!`; `app mutations: 229 run, 229 caught`, every
     file put back (the replayed tree against the last snapshot afterwards: no difference).
5. **Not provable in the sandbox, so the owner's** (Tasks 3 and 10): the Swift code (the new channel methods, the path
   monitor) compiling and working on the phone; complete protection and the backup exclusion on the audio files;
   Soniox accepting a replay at real-time pace with a fresh key, and its `final_audio_proc_ms`; the budget's failure
   reaching MP·54; the rehearsal of version 2; every phone check.
6. The guards and their tests, and the server, are unchanged by this branch (241 guard tests, 47 server tests, as
   before).
7. The scratch copies (`./.scratch/off/`) are deleted after this plan is committed.
