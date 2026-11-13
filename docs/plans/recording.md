# Plan: recording (recording by voice, in SoulDreams Dev only, and the first deploy)

*No matter where you are on your journey, the steps you take are equally important.*

Written by Claude Code (Opus) on 2026-11-13 from the investigation
(`.scratch/for-build-chat/recording-investigation.md`) and the owner's rulings D69, D70 and D71 (D71 corrects D69).
**Proven before committing as far as the sandbox allows** (Part 5). This commit holds this file only; nothing else is
implemented yet.

## Part 1 · Spec

### In plain words

In SoulDreams Dev, the typing screen gets a microphone inside its field. Tap it, and the words appear as you speak.
Tap it again, or press Save or Back, and the last words arrive before the screen saves them as a dream, exactly as
typed words are saved. The sound goes from the phone straight to Soniox in the EU and nowhere else, and nothing of it
is kept: not on our server, and in this slice not on the phone either, because recording needs a connection. With no
connection, or if anything on the way fails, the microphone simply does not start, a code is logged, and nothing new
appears on the screen. Offline recording, where the sound waits on the phone until it can be transcribed, is the next
slice (D71).

To let the phone talk to Soniox without ever holding Soniox's own key, our server gets its first feature: one front
door, a Lambda function URL. The phone knocks with the shared beta key; the server checks it, asks Soniox for a key
that opens one stream within a minute and lasts at most thirty minutes, and hands it back. The server never sees the
sound, never reads the caller's address, and logs codes only.

The typing screen also takes its current design (D70): the instruction centred in the button type, the field a pill
that grows as you type up to most of the screen, Save at the bottom left and Start Interpretation at the bottom right.
Start Interpretation does nothing yet. And two banked read failures are fixed first.

Then the owner makes the keys, deploys, commits the server's address, and checks it all on the phone.

### What this branch builds

1. **The read failures** (D71 Q18): the journal list keeps its rows and logs `journalListFailed` when its read fails;
   the record button opens nothing then; the typing screen's failed first-use read shows MP·32, marks nothing and logs
   `firstUseReadFailed`; a failed mark still shows MP·10 and logs the same code.
2. **The front door** (`server/src/door.ts`; head's message 14; D71 Q11, Q19):
   - `POST /` with `Authorization: Bearer <beta key>`. Only the method, the path and that header are ever read.
   - A key not 48 characters of A-Z, a-z, 0-9: **401**, no body, before anything is read.
   - A key that is not the beta key: **401**. The comparison hashes both and takes the same time (`beta-key.ts`).
   - The right key: Soniox's project key is read, a temporary key asked for, and **200** `{"key": ..., "expiresAt":
     ...}` returned.
   - Another method or path: **404**. Parameter Store failing: **500**. Soniox failing: **502**, its status logged.
   - Codes: `notFound`, `keyRefused`, `keyIssued`, `parameterFailed`, `sonioxKeyFailed <status>`, `handlerFailed`.
3. **The temporary key's request** (`server/src/soniox.ts`; D71 Q10): `POST
   https://api.eu.soniox.com/v1/auth/temporary-api-key`, the project key as bearer, the body exactly
   `{"usage_type":"transcribe_websocket","expires_in_seconds":60,"single_use":true,"max_session_duration_seconds":1800}`.
   No other field, ever (R4).
4. **Parameter Store** (`server/src/parameters.ts`; D71 Q13 a): `GetParameter` with decryption, through the AWS SDK
   v3 that the Lambda runtime carries. `@aws-sdk/client-ssm` is a devDependency for its types only; the Lambda's code
   folder holds our compiled files alone, and a test pins its imports.
5. **The stack** (`server/infra/stack.ts`; D71 Q12, Q20): the HTTP API goes; a function URL (auth `NONE`, no CORS)
   with the two permissions a public URL needs, which CDK 2.275.0 makes; a 10-second timeout; the role may read the
   two parameters only and decrypt only through Parameter Store; one output, the URL; **no reserved concurrency yet**.
6. **Recording's core** (`app/lib/recording/`; D69; D71 Q6, Q8, Q9, Q17):
   - `Hosts.soniox` = `wss://stt-rt.eu.soniox.com/transcribe-websocket`; `Hosts.server` empty until Task 15.
   - `fetchKey`: one POST, no body, the beta key as bearer, no user agent.
   - `SocketLink`: `dart:io`'s WebSocket, the temporary key in the handshake's `Authorization` header, no user agent,
     no compression; the first message exactly `{"model":"stt-rt-v6","audio_format":"pcm_s16le","sample_rate":16000,
     "num_channels":1,"language_hints":["en"],"language_hints_strict":true}`; frames as binary; an empty text frame
     to finish.
   - `readReply`: final and provisional words, Soniox's `<fin>` and `<end>` markers dropped, an error's code.
   - `withHeard`: words joined at the end of the field, never at the caret; provisional words replaced, never doubled.
   - `RecordingSession`: off → `recordingOff`; refused → `recordingRefused`; no key → `recordingKeyFailed <status>`;
     no stream → `recordingStreamFailed 0`; the microphone failing → `recordingMicFailed`; a break →
     `recordingStreamFailed <code>`; then `recordingStarted` and `recordingEnded`. A stop waits five seconds at most for
     the last words; a cancel waits for nothing.
7. **The typing screen** (D70 items 2, 7, 8; D71 Q3, Q5, Q7): as "The typing screen" below.
8. **The microphone and SoulDreams Dev's wiring** (D71 Q14 to Q16): `RecordMicrophone` over `record` 7.1.2 in stream
   mode, 16 kHz mono PCM16, `categoryOptions: []` (the built-in microphone only); `main_dev.dart` builds
   `Recording.live` with the beta key from `--dart-define-from-file` and hands it down to every typing screen.
   `main.dart` and `main_founder.dart` reach none of it, and nothing in `lib/recording/` can name a file.
9. **The mutation rows**: S17 to S30 (server) and A40 to A67 (app); ten older rows follow the code they break.
10. **Status.md** (D71 Q21).

### The typing screen (D70, TO TRY)

- Top left: Back (MP·14), as before.
- In the middle, in its own scroll area: MP·10 on first use, MP·32 after, centred, in `TypeRoles.button`; MP·62 under
  it after a failed save (D63), in the same type.
- While recording, just above the field: a level line (one bar a frame, from the frame's loudness) and a timer,
  minutes and seconds, both hidden from a screen reader; MP·33 is announced once when recording starts.
- The field: a pill, its corners half one line's height; MP·12 its placeholder; never focused by itself (D63). It
  grows with its words up to `StandIns.fieldCap` = **0.7** of the space between Back and the buttons, then scrolls
  inside. In a build that records, the microphone sits at its trailing end, its spoken name and long-press tip MP·11,
  showing a stop square while recording (Material's `mic_none` and `stop_rounded`, stand-ins).
- At the bottom: Save (MP·13, with its sleeping-person icon) on the left, Start Interpretation (EM·1) on the right.
  Start Interpretation does nothing yet. At large text both pills shrink their words to stay on one row.
- Save, Back, the system back, the edge swipe and leaving the app all save through one `_save` (D62, D63). While
  recording, Save and Back first wait for the last words (five seconds at most); leaving the app ends the recording at
  once, then saves.

### What it does not build

- Offline recording, MP·15, MP·54 and AI·6: the next slice (D71).
- The four missing places (the microphone refused, the stop control's own name, a stream cut off, Soniox's budget
  reached): asked of Product (D71 Q4). Until then nothing new shows and a code is logged.
- Reserved concurrency (D71 Q12): a checklist line returns it.
- Start Interpretation's action, the readings, and our server's spending counter.
- Any other item of the head's message 20.
- Anything in `main.dart` or `main_founder.dart`.

### The decisions, by number

| Ruling | What it settles |
|---|---|
| D69, as D71 corrects it | The scope; the audio never stored on our server, on the phone only until transcribed (the documents govern); this slice needs a connection; keys in Parameter Store; the beta key; one microphone package; `dart:io`'s WebSocket; English only |
| D70 | The typing screen's items 2, 7 and 8 |
| D71 Q2 | Save left, Start Interpretation right; Product refiles main-path |
| D71 Q3 | Start Interpretation shown, inert |
| D71 Q4 | The four missing places to Product; nothing new and a code until then |
| D71 Q5 | MP·11 names the microphone |
| D71 Q6 | Heard words at the end, never at the caret |
| D71 Q7 | The level line, the timer and the 0.7 cap, as stand-ins |
| D71 Q8 | The temporary key in the handshake's `Authorization` header |
| D71 Q9 | `stt-rt-v6`, in one constant |
| D71 Q10 | 60 s to open, single use, 1800 s at most |
| D71 Q11 | 200, 401 with no body, 404, 500, 502 |
| D71 Q12 | No reserved concurrency now |
| D71 Q13 | (a): the SSM client a devDependency for types, the runtime's SDK at run time |
| D71 Q14 | `record` 7.1.2 exactly |
| D71 Q15 | The built-in microphone only |
| D71 Q16 | The plugin's native code in all three apps, accepted |
| D71 Q17 | `Hosts.server` empty until the deploy, then committed |
| D71 Q18 | The read failures, as above |
| D71 Q19 | The constant-time comparison pinned by a structural test and a mutation row |
| D71 Q20 | A 10-second timeout |
| D71 Q21 | Status.md in the branch |

### The places this branch uses

MP·10, MP·32, MP·11, MP·12, MP·13, MP·14, EM·1 and MP·33 from `lines.g.dart`; MP·62 from `pending.g.dart`; EM·3
through the phone's own alert (already in all three `InfoPlist.strings`). No new line, no placeholder. MP·15, MP·54,
AI·6 and EM·8 are not used.

### The named stand-ins (P13)

New in `app/lib/design/stand_ins.dart`: `fieldCap` (0.7), `levelHeight` (24) and `levelFrames` (48). Changed:
`fieldPadding` is 20 across and 14 down (was 20 all round), so one line makes a pill. Removed: `fieldMinLines` (D63's
five lines, replaced by D70's growing field).

### The tests (test-first, on the Mac)

- **The front door**: every refusal, before or after a read; the event in which everything but the method, the path
  and the one header throws when touched, so a read of the caller's address fails the test; the logs, codes only.
- **The temporary key**: the address, the four fields exactly, the project key as bearer, every failure's number.
- **The template**: seven resources, the URL's auth and no CORS, both permissions and their conditions, the role's
  three statements exactly, 10 seconds, no reserved concurrency, one output.
- **The Lambda's code folder**: our files, and imports of our own files, `node:crypto` and `@aws-sdk/client-ssm`
  only.
- **Soniox**: a stand-in endpoint on loopback, which records the handshake's headers (the bearer key, no user agent,
  nothing else), the first message (the exact settings, no key in it), every frame byte for byte, and the empty text
  frame at the end.
- **The key**: a stand-in front door on loopback: one POST, no body, the bearer beta key, exactly the headers
  `dart:io` must send, and every refusal's status.
- **The session**: on a microphone of silence and a link held in memory: each refusal, the frames and their level,
  the words, the stop that waits, the break that keeps the words, the cancel that opens nothing; and once end to end
  on loopback through both stand-ins.
- **The words**: the tokens are the invented night `two-dreams-en`'s first dream, split at its spaces (R2). No audio is
  made: the microphone in the tests sends silence.
- **The screen**: D70's layout; growing to 0.7; no overflow on an iPhone SE with the keyboard up at 1x, 2x and 3.1x;
  the words appearing, at the end, never at the caret; MP·33 told once; the level line and the timer; refusal, off and
  break showing nothing new; Back and Save waiting for the last words; leaving ending it at once.
- **Dev only**: `main.dart` and `main_founder.dart` reach nothing in `lib/recording/`; nothing there names a file; only
  `record_microphone.dart` uses `record`, and only `startStream`.

## Part 2 · Settings

None change. Every edit is to a path Claude Code may already write. `tool/app_mutations.py` and
`tool/server_mutations.py` are not under `tool/checks/` and are edited by their blocks (as in journal-screens).

Two new packages, both ruled (R10; D71 Q13, Q14) and installed by the owner, since the sandbox reaches no registry
(D47, D42): `record` 7.1.2 in the app, and `@aws-sdk/client-ssm` as an exact devDependency in the server. Neither sends
anything anywhere of its own: `record`'s privacy manifest declares no collected data, and its sources hold no network
code (the investigation, §4.1); the SSM client is AWS's own SDK, used only to read our two parameters.

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, generated from the build that proved it (Part 5). Apply it
from the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit through
the hook with the message given. A block never holds an owner's file: the package files are changed by the owner's own
commands, given in full.

Every Claude Code task ends green:
- app: `fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub` passes at the count
  given;
- server: `npm run check` prints only its header, and `npm test` ends `fail 0` at the count given;
- the hook: `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `recording`, with a clean tree:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 && (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1) && (cd server && npm run check | tail -1 && npm test 2>&1 | grep -E '^ℹ (tests|fail)')
```

Expected:
- nothing from `git status`;
- the plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+188: All tests passed!`;
- `tsc -p tsconfig.json`;
- `ℹ tests 28` and `ℹ fail 0`.

Anything else: stop (R14).

### Task 1 · The two banked read failures (D71 Q18)

`journal_page.dart` and `typing_page.dart` catch, log one code each, and keep what is shown. Two new codes in
`SafeLog`. Tests: `journal_page_test.dart` (2), `typing_page_test.dart` (2).

Expected: 192 app tests. Commit:

> Journal: a failed read keeps the list and the typing screen, with a code (D71 Q18)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index a44fcab..0c55041 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -27,6 +27,13 @@ enum LogEvent {
   /// The page stays as it was.
   journalDeleteFailed,
   journalReadFailed,
+
+  /// The journal list's read of the nights failed, on loading the list or
+  /// at the record button; the list stays as it was (D71 Q18).
+  journalListFailed,
+
+  /// The typing screen's read or mark of first use failed (D71 Q18).
+  firstUseReadFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 9e601ed..35be63a 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -7,12 +7,14 @@ import 'package:flutter/material.dart';
 
 import '../../core/app_line.dart';
 import '../../core/language.dart';
+import '../../core/safe_log.dart';
 import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
 import '../journal.dart';
 import '../night.dart';
+import '../night_rules.dart';
 import '../row_text.dart';
 import 'night_page.dart';
 import 'parts.dart';
@@ -49,8 +51,15 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     if (state == AppLifecycleState.resumed) _load();
   }
 
+  // A failed read keeps what is shown and logs a code (D71 Q18, as D64).
   Future<void> _load() async {
-    final nights = await widget.journal.newestFirst();
+    final List<Night> nights;
+    try {
+      nights = await widget.journal.newestFirst();
+    } on Object {
+      SafeLog.event(LogEvent.journalListFailed);
+      return;
+    }
     if (mounted) setState(() => _nights = nights);
   }
 
@@ -68,7 +77,14 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     if (_recording) return;
     _recording = true;
     try {
-      final target = await widget.journal.targetNow();
+      final Target target;
+      try {
+        target = await widget.journal.targetNow();
+      } on Object {
+        // Nothing opens; a code is logged (D71 Q18).
+        SafeLog.event(LogEvent.journalListFailed);
+        return;
+      }
       if (mounted) await _push(TypingPage(journal: widget.journal, target: target));
     } finally {
       _recording = false;
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
index 3f88f33..7970591 100644
--- a/app/lib/journal/pages/typing_page.dart
+++ b/app/lib/journal/pages/typing_page.dart
@@ -67,10 +67,24 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   void initState() {
     super.initState();
     WidgetsBinding.instance.addObserver(this);
-    widget.journal.firstUseSeen().then((seen) async {
-      if (!seen) await widget.journal.markFirstUseSeen();
-      if (mounted) setState(() => _firstUse = !seen);
-    });
+    // A failed read shows the short line and marks nothing; a failed mark
+    // still shows MP·10. Each logs a code (D71 Q18).
+    widget.journal.firstUseSeen().then(
+      (seen) async {
+        if (!seen) {
+          try {
+            await widget.journal.markFirstUseSeen();
+          } on Object {
+            SafeLog.event(LogEvent.firstUseReadFailed);
+          }
+        }
+        if (mounted) setState(() => _firstUse = !seen);
+      },
+      onError: (Object _) {
+        SafeLog.event(LogEvent.firstUseReadFailed);
+        if (mounted) setState(() => _firstUse = false);
+      },
+    );
   }
 
   @override
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index dc8675d..707a729 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -2,10 +2,12 @@
 // empty journal, rows newest first with no time and no count, dividers,
 // the record button opening the typing screen, a row opening its night.
 import 'dart:async';
+import 'dart:io';
 import 'dart:typed_data';
 
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/design/stand_ins.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
@@ -38,6 +40,18 @@ final class SlowFiles extends MemoryJournalFiles {
   }
 }
 
+/// A folder whose listing throws while [broken] is set, as a phone's
+/// failed read of the journal's folder would.
+final class BrokenFiles extends MemoryJournalFiles {
+  bool broken = false;
+
+  @override
+  Future<List<String>> list() async {
+    if (broken) throw const FileSystemException('list');
+    return super.list();
+  }
+}
+
 void main() {
   testWidgets('the empty journal: C4-P·5 and the record button, nothing else', (tester) async {
     final h = await Harness.make();
@@ -190,4 +204,43 @@ void main() {
     await tester.pumpAndSettle();
     expect(find.byType(TypingPage), findsOneWidget);
   });
+
+  // D71 Q18 (the final review of journal-screens, banked items 1 and 2).
+  Future<List<String>> logged() async {
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    return lines;
+  }
+
+  testWidgets('a failed load keeps the rows shown and logs a code', (tester) async {
+    final lines = await logged();
+    final files = BrokenFiles();
+    final h = await Harness.make(files: files);
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 9, 23));
+    await h.pump(tester, JournalPage(journal: h.journal));
+    files.broken = true;
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pumpAndSettle();
+    expect(find.text(dayDigits(n.date)), findsOneWidget);
+    expect(lines, ['journalListFailed']);
+  });
+
+  testWidgets('a failed read at the record button opens nothing', (tester) async {
+    final lines = await logged();
+    final files = BrokenFiles();
+    final h = await Harness.make(files: files);
+    await h.pump(tester, JournalPage(journal: h.journal));
+    files.broken = true;
+    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsNothing);
+    expect(lines, ['journalListFailed']);
+    // The button works again once the folder reads.
+    files.broken = false;
+    await tester.tap(find.byKey(RecordButton.buttonKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsOneWidget);
+  });
 }
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index 526dde3..781a68a 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -10,6 +10,7 @@ import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/core/app_line.dart';
 import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/journal/night_rules.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/words/lines.g.dart';
 import 'package:souldreams/words/pending.g.dart';
@@ -36,6 +37,24 @@ final class FlakyFiles extends MemoryJournalFiles {
   }
 }
 
+/// A folder whose listing, or whose write of the first-use flag, throws.
+final class FirstUseFiles extends MemoryJournalFiles {
+  bool listFails = false;
+  bool markFails = false;
+
+  @override
+  Future<List<String>> list() async {
+    if (listFails) throw const FileSystemException('list');
+    return super.list();
+  }
+
+  @override
+  Future<void> write(String name, Uint8List bytes) async {
+    if (markFails && name == 'first-use-seen') throw const FileSystemException('write');
+    return super.write(name, bytes);
+  }
+}
+
 void main() {
   final dreams = invented('two-dreams-en').dreams;
 
@@ -539,4 +558,35 @@ void main() {
     final area = tester.getRect(find.byType(SingleChildScrollView));
     expect(tester.getRect(find.byKey(TypingPage.fieldKey)).bottom, closeTo(area.bottom, 1));
   });
+
+  // D71 Q18: the first-use read or mark failing.
+  Future<Harness> firstUse(WidgetTester tester, FirstUseFiles files) async {
+    final h = await Harness.make(files: files);
+    final target = NewNight(Harness.clock);
+    await h.pump(tester, Opener(() async => TypingPage(journal: h.journal, target: target)));
+    return h;
+  }
+
+  testWidgets('a failed first-use read shows MP·32, marks nothing, logs a code', (tester) async {
+    final lines = await logged();
+    final files = FirstUseFiles();
+    await firstUse(tester, files);
+    files.listFails = true;
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    expect(find.bySemanticsLabel(Lines.MP_32.text(Lang.en)), findsOneWidget);
+    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsNothing);
+    expect(lines, ['firstUseReadFailed']);
+    expect(files.files.containsKey('first-use-seen'), isFalse);
+  });
+
+  testWidgets('a failed first-use mark still shows MP·10, logs a code', (tester) async {
+    final lines = await logged();
+    final files = FirstUseFiles()..markFails = true;
+    await firstUse(tester, files);
+    await tester.tap(find.byKey(Opener.openKey));
+    await tester.pumpAndSettle();
+    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsOneWidget);
+    expect(lines, ['firstUseReadFailed']);
+  });
 }
~~~~

### Task 2 · Server: the front door, the beta key's check, Soniox's temporary key (D71)

New: `door.ts`, `beta-key.ts`, `soniox.ts`, `parameter-names.ts`. `hosts.ts` gains Soniox's EU REST host; `safe-log.ts`
four codes. `handler.ts` is untouched until Task 5. Tests: `door.test.ts` (7), `beta-key.test.ts` (3),
`soniox.test.ts` (4), `hosts.test.ts` (2, rewritten), `safe-log.test.ts` and `dist.test.ts` (their lists).

Expected: 43 server tests. Commit:

> Server: the front door, the beta key's check and Soniox's temporary key, not wired yet (D71)

**The block:**

~~~~diff
diff --git a/server/src/beta-key.ts b/server/src/beta-key.ts
new file mode 100644
index 0000000..8db8ece
--- /dev/null
+++ b/server/src/beta-key.ts
@@ -0,0 +1,16 @@
+// The beta key's check (D18; D71 Q19): its shape, then a comparison
+// that takes the same time whatever the keys hold. Both keys are
+// hashed first, so even their lengths never change the time taken.
+import { createHash, timingSafeEqual } from 'node:crypto';
+
+const SHAPE = /^[A-Za-z0-9]{48}$/;
+
+export function isBetaKeyShape(key: string): boolean {
+  return SHAPE.test(key);
+}
+
+export function sameKey(given: string, kept: string): boolean {
+  const a = createHash('sha256').update(given, 'utf8').digest();
+  const b = createHash('sha256').update(kept, 'utf8').digest();
+  return timingSafeEqual(a, b);
+}
diff --git a/server/src/door.ts b/server/src/door.ts
new file mode 100644
index 0000000..df60089
--- /dev/null
+++ b/server/src/door.ts
@@ -0,0 +1,85 @@
+// The front door (head's message 14; D71): a Lambda function URL with no
+// authentication of its own, and the beta key checked here. POST / with
+// the beta key as a bearer token gets a short-lived Soniox key; anything
+// else gets nothing. It reads the method, the path and one header only:
+// never the caller's network address, the body or any other header. It
+// logs codes and numbers only (R3, R4).
+import { isBetaKeyShape, sameKey } from './beta-key.ts';
+import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from './parameter-names.ts';
+import { safeLog } from './safe-log.ts';
+import { SonioxFailure, type TemporaryKey } from './soniox.ts';
+
+export interface DoorEvent {
+  readonly rawPath?: string;
+  readonly headers?: Readonly<Record<string, string | undefined>>;
+  readonly requestContext?: { readonly http?: { readonly method?: string } };
+}
+
+export interface Reply {
+  readonly statusCode: number;
+  readonly headers?: Readonly<Record<string, string>>;
+  readonly body?: string;
+}
+
+export interface DoorDeps {
+  /** A SecureString's value, decrypted. */
+  readonly readParameter: (name: string) => Promise<string>;
+  readonly temporaryKey: (projectKey: string) => Promise<TemporaryKey>;
+}
+
+const BEARER = 'Bearer ';
+
+export function makeDoor(deps: DoorDeps): (event: DoorEvent) => Promise<Reply> {
+  return async (event) => {
+    try {
+      return await answer(event, deps);
+    } catch {
+      safeLog('handlerFailed');
+      return { statusCode: 500 };
+    }
+  };
+}
+
+async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
+  if (event.requestContext?.http?.method !== 'POST' || event.rawPath !== '/') {
+    safeLog('notFound');
+    return { statusCode: 404 };
+  }
+  const header = event.headers?.['authorization'];
+  const given = header !== undefined && header.startsWith(BEARER) ? header.slice(BEARER.length) : '';
+  if (!isBetaKeyShape(given)) {
+    safeLog('keyRefused');
+    return { statusCode: 401 };
+  }
+  let betaKey: string;
+  let projectKey: string;
+  try {
+    betaKey = await deps.readParameter(BETA_KEY_PARAMETER);
+  } catch {
+    safeLog('parameterFailed');
+    return { statusCode: 500 };
+  }
+  if (!sameKey(given, betaKey)) {
+    safeLog('keyRefused');
+    return { statusCode: 401 };
+  }
+  try {
+    projectKey = await deps.readParameter(SONIOX_KEY_PARAMETER);
+  } catch {
+    safeLog('parameterFailed');
+    return { statusCode: 500 };
+  }
+  let key: TemporaryKey;
+  try {
+    key = await deps.temporaryKey(projectKey);
+  } catch (failure) {
+    safeLog('sonioxKeyFailed', [failure instanceof SonioxFailure ? failure.status : 0]);
+    return { statusCode: 502 };
+  }
+  safeLog('keyIssued');
+  return {
+    statusCode: 200,
+    headers: { 'content-type': 'application/json' },
+    body: JSON.stringify({ key: key.key, expiresAt: key.expiresAt }),
+  };
+}
diff --git a/server/src/hosts.ts b/server/src/hosts.ts
index 944e671..b770c6a 100644
--- a/server/src/hosts.ts
+++ b/server/src/hosts.ts
@@ -1,5 +1,8 @@
 // Every host the server talks to lives here, and nowhere else
-// (CLAUDE.md R10, G9). None yet: Bedrock is reached through the AWS SDK
-// by Region, and Soniox's key endpoint arrives with the branch that
-// uses it.
-export const HOSTS: readonly string[] = Object.freeze([]);
+// (CLAUDE.md R10, G9). Parameter Store, like Bedrock later, is reached
+// through the AWS SDK by Region, not by a host of ours.
+
+/** Soniox's EU REST host, which issues the short-lived keys (D69). */
+export const SONIOX_TEMPORARY_KEY_URL = 'https://api.eu.soniox.com/v1/auth/temporary-api-key';
+
+export const HOSTS: readonly string[] = Object.freeze(['api.eu.soniox.com']);
diff --git a/server/src/parameter-names.ts b/server/src/parameter-names.ts
new file mode 100644
index 0000000..96df8af
--- /dev/null
+++ b/server/src/parameter-names.ts
@@ -0,0 +1,11 @@
+// The two keys the server reads from Parameter Store, as SecureStrings
+// the owner makes outside the stack (CloudFormation cannot make one).
+// The stack grants reading these two and no other (D69).
+
+/** The shared beta key: 48 characters of A-Z, a-z and 0-9 (D18). */
+export const BETA_KEY_PARAMETER = '/souldreams/beta-key';
+
+/** Soniox's project key, which may create temporary keys. */
+export const SONIOX_KEY_PARAMETER = '/souldreams/soniox-key';
+
+export const PARAMETERS: readonly string[] = Object.freeze([BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER]);
diff --git a/server/src/safe-log.ts b/server/src/safe-log.ts
index 574bad9..dd14b43 100644
--- a/server/src/safe-log.ts
+++ b/server/src/safe-log.ts
@@ -3,7 +3,16 @@
 // can reach a log. Lambda sends each line to CloudWatch, kept 7 days.
 
 /** Every event the server may log. A new event is a new value here. */
-export const LOG_EVENTS = ['notFound', 'handlerFailed'] as const;
+export const LOG_EVENTS = [
+  'notFound',
+  'handlerFailed',
+  // The front door (D71): a key given, a beta key refused, Soniox's
+  // answer not a key (with its status), Parameter Store failing.
+  'keyIssued',
+  'keyRefused',
+  'sonioxKeyFailed',
+  'parameterFailed',
+] as const;
 export type LogEvent = (typeof LOG_EVENTS)[number];
 
 type Sink = (line: string) => void;
diff --git a/server/src/soniox.ts b/server/src/soniox.ts
new file mode 100644
index 0000000..882077b
--- /dev/null
+++ b/server/src/soniox.ts
@@ -0,0 +1,59 @@
+// A short-lived Soniox key for one recording (technical-answers a; D71
+// Q10): a minute to open, one stream only, thirty minutes at most. The
+// request is exactly these four fields: never a reference of ours,
+// which Soniox would record in its usage logs (R4).
+import { SONIOX_TEMPORARY_KEY_URL } from './hosts.ts';
+
+export const TEMPORARY_KEY_REQUEST = Object.freeze({
+  usage_type: 'transcribe_websocket',
+  expires_in_seconds: 60,
+  single_use: true,
+  max_session_duration_seconds: 1800,
+});
+
+export interface TemporaryKey {
+  readonly key: string;
+  readonly expiresAt: string;
+}
+
+/** Soniox did not give a key: its HTTP status, 0 for no answer, -1 for an unreadable one. */
+export class SonioxFailure extends Error {
+  readonly status: number;
+
+  constructor(status: number) {
+    super('soniox-key');
+    this.status = status;
+  }
+}
+
+export type Fetch = (url: string, init: RequestInit) => Promise<Response>;
+
+export async function requestTemporaryKey(projectKey: string, fetchFn: Fetch = fetch): Promise<TemporaryKey> {
+  let reply: Response;
+  try {
+    reply = await fetchFn(SONIOX_TEMPORARY_KEY_URL, {
+      method: 'POST',
+      headers: { authorization: `Bearer ${projectKey}`, 'content-type': 'application/json' },
+      body: JSON.stringify(TEMPORARY_KEY_REQUEST),
+      signal: AbortSignal.timeout(5000),
+    });
+  } catch {
+    throw new SonioxFailure(0);
+  }
+  if (reply.status !== 201) {
+    throw new SonioxFailure(reply.status);
+  }
+  let parsed: unknown;
+  try {
+    parsed = await reply.json();
+  } catch {
+    throw new SonioxFailure(-1);
+  }
+  const fields = typeof parsed === 'object' && parsed !== null ? (parsed as Record<string, unknown>) : {};
+  const key = fields['api_key'];
+  const expiresAt = fields['expires_at'];
+  if (typeof key !== 'string' || key === '' || typeof expiresAt !== 'string') {
+    throw new SonioxFailure(-1);
+  }
+  return { key, expiresAt };
+}
diff --git a/server/test/beta-key.test.ts b/server/test/beta-key.test.ts
new file mode 100644
index 0000000..a1f841d
--- /dev/null
+++ b/server/test/beta-key.test.ts
@@ -0,0 +1,33 @@
+// The beta key's check (D18; D71 Q19). The keys here are plain repeats,
+// never key-shaped secrets (R5, G7).
+import assert from 'node:assert/strict';
+import { readFileSync } from 'node:fs';
+import { test } from 'node:test';
+import { isBetaKeyShape, sameKey } from '../src/beta-key.ts';
+
+const KEY = 'Ab0'.repeat(16);
+
+test('the shape: 48 characters of A-Z, a-z and 0-9', () => {
+  assert.equal(isBetaKeyShape(KEY), true);
+  assert.equal(isBetaKeyShape(KEY.slice(1)), false);
+  assert.equal(isBetaKeyShape(`${KEY}A`), false);
+  assert.equal(isBetaKeyShape(`${KEY.slice(1)}-`), false);
+  assert.equal(isBetaKeyShape(`${KEY.slice(1)}\n`), false);
+  assert.equal(isBetaKeyShape(''), false);
+});
+
+test('the same key matches; one character off does not', () => {
+  assert.equal(sameKey(KEY, KEY), true);
+  assert.equal(sameKey(`${KEY.slice(0, 47)}1`, KEY), false);
+  assert.equal(sameKey(KEY.slice(1), KEY), false);
+});
+
+test('the comparison hashes both keys and takes the same time', () => {
+  // A test cannot see time, so this pins the method (D71 Q19).
+  const text = readFileSync(new URL('../src/beta-key.ts', import.meta.url), 'utf8');
+  assert.match(text, /return timingSafeEqual\(a, b\);/);
+  assert.equal(text.match(/createHash\('sha256'\)/g)?.length, 2);
+  const door = readFileSync(new URL('../src/door.ts', import.meta.url), 'utf8');
+  assert.match(door, /!sameKey\(given, betaKey\)/);
+  assert.doesNotMatch(door, /betaKey\s*[!=]==|[!=]==\s*betaKey/);
+});
diff --git a/server/test/dist.test.ts b/server/test/dist.test.ts
index e38e3cd..e3d23be 100644
--- a/server/test/dist.test.ts
+++ b/server/test/dist.test.ts
@@ -8,7 +8,16 @@ const CODE = new URL('../dist/src/', import.meta.url);
 
 test('the compiled files and the marker, nothing else', () => {
   const files = readdirSync(CODE, { recursive: true }).map(String).sort();
-  assert.deepEqual(files, ['handler.js', 'hosts.js', 'package.json', 'safe-log.js']);
+  assert.deepEqual(files, [
+    'beta-key.js',
+    'door.js',
+    'handler.js',
+    'hosts.js',
+    'package.json',
+    'parameter-names.js',
+    'safe-log.js',
+    'soniox.js',
+  ]);
 });
 
 test('the marker makes the code a module', () => {
diff --git a/server/test/door.test.ts b/server/test/door.test.ts
new file mode 100644
index 0000000..b8849d2
--- /dev/null
+++ b/server/test/door.test.ts
@@ -0,0 +1,176 @@
+// The front door (head's message 14; D71): POST / with the beta key gets a
+// short-lived Soniox key; anything else gets nothing, with one code. It
+// never touches the caller's address, the body or another header (R3, R4).
+import assert from 'node:assert/strict';
+import { afterEach, beforeEach, test } from 'node:test';
+import { type DoorDeps, type DoorEvent, makeDoor } from '../src/door.ts';
+import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from '../src/parameter-names.ts';
+import { setSink } from '../src/safe-log.ts';
+import { SonioxFailure } from '../src/soniox.ts';
+
+const KEY = 'Ab0'.repeat(16);
+const PROJECT = 'project-key-in-a-test';
+const ISSUED = { key: 'snx_temp_test', expiresAt: '2026-11-13T12:00:00Z' };
+
+let lines: string[] = [];
+let restore = (): void => {};
+beforeEach(() => {
+  lines = [];
+  restore = setSink((line) => {
+    lines.push(line);
+  });
+});
+afterEach(() => {
+  restore();
+});
+
+interface Calls {
+  read: string[];
+  soniox: string[];
+}
+
+function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
+  const calls: Calls = { read: [], soniox: [] };
+  return {
+    calls,
+    deps: {
+      readParameter: async (name) => {
+        calls.read.push(name);
+        return name === BETA_KEY_PARAMETER ? KEY : PROJECT;
+      },
+      temporaryKey: async (project) => {
+        calls.soniox.push(project);
+        return ISSUED;
+      },
+      ...over,
+    },
+  };
+}
+
+// A function URL's event in which everything but the method, the path
+// and the authorization header throws when touched.
+function event(method: string, path: string, authorization?: string): DoorEvent {
+  const guard = <T extends object>(target: T, allowed: string[]): T =>
+    new Proxy(target, {
+      get(t, p) {
+        if (typeof p === 'string' && !allowed.includes(p)) throw new Error(`touched ${p}`);
+        return Reflect.get(t, p);
+      },
+    });
+  const headers: Record<string, string> = { 'user-agent': 'x', 'x-forwarded-for': '192.0.2.1' };
+  if (authorization !== undefined) headers['authorization'] = authorization;
+  return guard(
+    {
+      rawPath: path,
+      headers: guard(headers, ['authorization']),
+      body: 'a body',
+      requestContext: guard({ http: guard({ method, sourceIp: '192.0.2.1' }, ['method']) }, ['http']),
+    },
+    ['rawPath', 'headers', 'requestContext'],
+  );
+}
+
+test('the right key: 200 and a short-lived key, one code', async () => {
+  const d = deps();
+  const reply = await makeDoor(d.deps)(event('POST', '/', `Bearer ${KEY}`));
+  assert.deepEqual(reply, {
+    statusCode: 200,
+    headers: { 'content-type': 'application/json' },
+    body: JSON.stringify(ISSUED),
+  });
+  assert.deepEqual(d.calls.read, [BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER]);
+  assert.deepEqual(d.calls.soniox, [PROJECT]);
+  assert.deepEqual(lines, ['keyIssued']);
+});
+
+test('a wrong, missing or misshapen key: 401, Soniox never asked', async () => {
+  for (const authorization of [
+    `Bearer ${KEY.slice(0, 47)}1`,
+    undefined,
+    KEY,
+    `bearer ${KEY}`,
+    `Bearer ${KEY} `,
+    'Bearer ',
+  ]) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', authorization)), { statusCode: 401 });
+    assert.deepEqual(d.calls.soniox, []);
+    assert.deepEqual(lines, ['keyRefused']);
+  }
+});
+
+test('a misshapen key is refused before anything is read', async () => {
+  for (const authorization of [undefined, 'Bearer short', `Bearer ${KEY}-`, KEY]) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', authorization)), { statusCode: 401 });
+    assert.deepEqual(d.calls.read, []);
+    assert.deepEqual(lines, ['keyRefused']);
+  }
+});
+
+test('another method or path: 404, nothing read', async () => {
+  for (const [method, path] of [
+    ['GET', '/'],
+    ['POST', '/x'],
+    ['PUT', '/'],
+    ['POST', ''],
+  ] as const) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event(method, path, `Bearer ${KEY}`)), { statusCode: 404 });
+    assert.deepEqual(d.calls.read, []);
+    assert.deepEqual(lines, ['notFound']);
+  }
+});
+
+test('Parameter Store failing: 500 and a code', async () => {
+  const d = deps({
+    readParameter: async () => {
+      throw new Error('invented failure text');
+    },
+  });
+  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 500 });
+  assert.deepEqual(lines, ['parameterFailed']);
+  const later = deps({
+    readParameter: async (name) => {
+      if (name === SONIOX_KEY_PARAMETER) throw new Error('invented failure text');
+      return KEY;
+    },
+  });
+  lines = [];
+  assert.deepEqual(await makeDoor(later.deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 500 });
+  assert.deepEqual(lines, ['parameterFailed']);
+});
+
+test("Soniox failing: 502 and its status, never its message", async () => {
+  for (const [thrown, logged] of [
+    [new SonioxFailure(402), 'sonioxKeyFailed 402'],
+    [new SonioxFailure(-1), 'sonioxKeyFailed -1'],
+    [new Error('invented failure text'), 'sonioxKeyFailed 0'],
+  ] as const) {
+    const d = deps({
+      temporaryKey: async () => {
+        throw thrown;
+      },
+    });
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 502 });
+    assert.deepEqual(lines, [logged]);
+  }
+});
+
+test('a failure anywhere else: 500 and a code', async () => {
+  let first = true;
+  restore();
+  restore = setSink((line) => {
+    if (first) {
+      first = false;
+      throw new Error('invented failure text');
+    }
+    lines.push(line);
+  });
+  assert.deepEqual(await makeDoor(deps().deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 500 });
+  assert.deepEqual(lines, ['handlerFailed']);
+});
diff --git a/server/test/hosts.test.ts b/server/test/hosts.test.ts
index 0a3bd69..d25ef22 100644
--- a/server/test/hosts.test.ts
+++ b/server/test/hosts.test.ts
@@ -3,8 +3,15 @@ import assert from 'node:assert/strict';
 import { test } from 'node:test';
 import * as hosts from '../src/hosts.ts';
 
-test('no host yet', () => {
-  assert.deepEqual(Object.keys(hosts), ['HOSTS']);
-  assert.deepEqual(hosts.HOSTS, []);
+test("Soniox's EU REST host only", () => {
+  assert.deepEqual(Object.keys(hosts).sort(), ['HOSTS', 'SONIOX_TEMPORARY_KEY_URL']);
+  assert.deepEqual(hosts.HOSTS, ['api.eu.soniox.com']);
   assert.ok(Object.isFrozen(hosts.HOSTS));
 });
+
+test('the temporary-key address is on that host, over https', () => {
+  const url = new URL(hosts.SONIOX_TEMPORARY_KEY_URL);
+  assert.equal(url.protocol, 'https:');
+  assert.ok(hosts.HOSTS.includes(url.host));
+  assert.equal(url.pathname, '/v1/auth/temporary-api-key');
+});
diff --git a/server/test/safe-log.test.ts b/server/test/safe-log.test.ts
index 9a48f85..91d791a 100644
--- a/server/test/safe-log.test.ts
+++ b/server/test/safe-log.test.ts
@@ -17,7 +17,14 @@ afterEach(() => {
 });
 
 test('the events are these', () => {
-  assert.deepEqual(LOG_EVENTS, ['notFound', 'handlerFailed']);
+  assert.deepEqual(LOG_EVENTS, [
+    'notFound',
+    'handlerFailed',
+    'keyIssued',
+    'keyRefused',
+    'sonioxKeyFailed',
+    'parameterFailed',
+  ]);
 });
 
 test('a code alone', () => {
diff --git a/server/test/soniox.test.ts b/server/test/soniox.test.ts
new file mode 100644
index 0000000..e03d3d6
--- /dev/null
+++ b/server/test/soniox.test.ts
@@ -0,0 +1,79 @@
+// The request for a short-lived Soniox key (D71 Q10; R4): its address,
+// its four fields exactly, and every way the answer can fail.
+import assert from 'node:assert/strict';
+import { test } from 'node:test';
+import { SONIOX_TEMPORARY_KEY_URL } from '../src/hosts.ts';
+import { type Fetch, requestTemporaryKey, SonioxFailure, TEMPORARY_KEY_REQUEST } from '../src/soniox.ts';
+
+const PROJECT = 'project-key-in-a-test';
+
+function answering(status: number, body: string, seen: { url?: string; init?: RequestInit }[] = []): Fetch {
+  return async (url, init) => {
+    seen.push({ url, init });
+    return new Response(body, { status });
+  };
+}
+
+async function failure(fetchFn: Fetch): Promise<number> {
+  try {
+    await requestTemporaryKey(PROJECT, fetchFn);
+  } catch (e) {
+    assert.ok(e instanceof SonioxFailure);
+    return e.status;
+  }
+  assert.fail('no failure');
+}
+
+test('exactly these four fields and no other (R4)', () => {
+  assert.deepEqual(Object.keys(TEMPORARY_KEY_REQUEST).sort(), [
+    'expires_in_seconds',
+    'max_session_duration_seconds',
+    'single_use',
+    'usage_type',
+  ]);
+  assert.deepEqual(TEMPORARY_KEY_REQUEST, {
+    usage_type: 'transcribe_websocket',
+    expires_in_seconds: 60,
+    single_use: true,
+    max_session_duration_seconds: 1800,
+  });
+  assert.ok(Object.isFrozen(TEMPORARY_KEY_REQUEST));
+});
+
+test('one POST to the EU host, the project key as bearer', async () => {
+  const seen: { url?: string; init?: RequestInit }[] = [];
+  const key = await requestTemporaryKey(
+    PROJECT,
+    answering(201, JSON.stringify({ api_key: 'snx_temp_test', expires_at: '2026-11-13T12:00:00Z' }), seen),
+  );
+  assert.deepEqual(key, { key: 'snx_temp_test', expiresAt: '2026-11-13T12:00:00Z' });
+  assert.equal(seen.length, 1);
+  assert.equal(seen[0]?.url, SONIOX_TEMPORARY_KEY_URL);
+  assert.equal(seen[0]?.init?.method, 'POST');
+  assert.deepEqual(seen[0]?.init?.headers, {
+    authorization: `Bearer ${PROJECT}`,
+    'content-type': 'application/json',
+  });
+  assert.deepEqual(JSON.parse(String(seen[0]?.init?.body)), TEMPORARY_KEY_REQUEST);
+  assert.ok(seen[0]?.init?.signal instanceof AbortSignal);
+});
+
+test("Soniox's refusal carries its status", async () => {
+  assert.equal(await failure(answering(402, '{}')), 402);
+  assert.equal(await failure(answering(429, '{}')), 429);
+  assert.equal(await failure(answering(200, '{}')), 200);
+});
+
+test('no answer is 0; an unreadable answer is -1', async () => {
+  assert.equal(
+    await failure(async () => {
+      throw new TypeError('fetch failed');
+    }),
+    0,
+  );
+  assert.equal(await failure(answering(201, 'not json')), -1);
+  assert.equal(await failure(answering(201, '{"expires_at":"x"}')), -1);
+  assert.equal(await failure(answering(201, '{"api_key":"","expires_at":"x"}')), -1);
+  assert.equal(await failure(answering(201, '{"api_key":"k"}')), -1);
+  assert.equal(await failure(answering(201, 'null')), -1);
+});
~~~~

### Task 3 · Server: a function URL in place of the HTTP API (head's message 14; D71 Q12, Q20)

`infra/stack.ts` and `test/stack.test.ts`. Read in the proof: CDK 2.275.0 makes both `AWS::Lambda::Permission`
resources a public function URL needs.

Expected: 46 server tests. Commit:

> Server: one Lambda behind its own function URL, reading two parameters, no reserved concurrency yet (D71)

**The block:**

~~~~diff
diff --git a/server/infra/stack.ts b/server/infra/stack.ts
index 1fa11a2..d31549f 100644
--- a/server/infra/stack.ts
+++ b/server/infra/stack.ts
@@ -1,14 +1,16 @@
-// The server's AWS infrastructure (D41, D42): one Lambda behind an HTTP
-// API in eu-north-1, its logs kept 7 days, with no access logs, no
-// tracing, no environment and no identifier. Nothing is deployed in
-// branch 4; test/stack.test.ts proves the template.
-import { RemovalPolicy, Stack } from 'aws-cdk-lib';
-import { HttpApi } from 'aws-cdk-lib/aws-apigatewayv2';
-import { HttpLambdaIntegration } from 'aws-cdk-lib/aws-apigatewayv2-integrations';
+// The server's AWS infrastructure (D41, D42; head's message 14; D71): one
+// Lambda in eu-north-1 behind its own function URL, with no
+// authentication of the URL's own (the beta key is checked in the code),
+// its logs kept 7 days, with no access logs, no tracing, no environment
+// and no identifier. It reads two SecureStrings the owner makes, and
+// nothing else. No reserved concurrency yet (D71 Q12: the account's
+// quota must allow it first; a first-deploy checklist line returns it).
+import { CfnOutput, Duration, RemovalPolicy, Stack } from 'aws-cdk-lib';
 import * as iam from 'aws-cdk-lib/aws-iam';
 import * as lambda from 'aws-cdk-lib/aws-lambda';
 import * as logs from 'aws-cdk-lib/aws-logs';
 import type { Construct } from 'constructs';
+import { PARAMETERS } from '../src/parameter-names.ts';
 
 export const REGION = 'eu-north-1';
 
@@ -36,6 +38,23 @@ export class ServerStack extends Stack {
       assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),
     });
     logGroup.grantWrite(role);
+    // The two keys, by name, and their decryption through Parameter Store
+    // only (D69).
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({
+        actions: ['ssm:GetParameter'],
+        resources: PARAMETERS.map((name) =>
+          this.formatArn({ service: 'ssm', resource: 'parameter', resourceName: name.slice(1) }),
+        ),
+      }),
+    );
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({
+        actions: ['kms:Decrypt'],
+        resources: [this.formatArn({ service: 'kms', resource: 'key', resourceName: '*' })],
+        conditions: { StringEquals: { 'kms:ViaService': `ssm.${REGION}.amazonaws.com` } },
+      }),
+    );
     const fn = new lambda.Function(this, 'Handler', {
       runtime: lambda.Runtime.NODEJS_24_X,
       architecture: lambda.Architecture.ARM_64,
@@ -46,9 +65,11 @@ export class ServerStack extends Stack {
       loggingFormat: lambda.LoggingFormat.JSON,
       applicationLogLevelV2: lambda.ApplicationLogLevel.INFO,
       systemLogLevelV2: lambda.SystemLogLevel.WARN,
+      // A cold start, then Parameter Store, then Soniox (D71 Q20).
+      timeout: Duration.seconds(10),
     });
-    new HttpApi(this, 'Api', {
-      defaultIntegration: new HttpLambdaIntegration('Handler', fn),
-    });
+    const url = fn.addFunctionUrl({ authType: lambda.FunctionUrlAuthType.NONE });
+    // The owner reads the address after the deploy, for app/lib/core/hosts.dart.
+    new CfnOutput(this, 'Url', { value: url.url });
   }
 }
diff --git a/server/test/stack.test.ts b/server/test/stack.test.ts
index c92487f..3556788 100644
--- a/server/test/stack.test.ts
+++ b/server/test/stack.test.ts
@@ -1,4 +1,4 @@
-// The template (D41, D42), synthesized in-process: no AWS credentials, no
+// The template (D41, D42; head's message 14; D71), synthesized in-process: no AWS credentials, no
 // CLI and no network. The App carries the CLI's own context, version
 // reporting on, so the stack's opt-out is what keeps the metadata out.
 import assert from 'node:assert/strict';
@@ -27,14 +27,12 @@ function only(type: string): Resource {
 
 test('these resources and no others', () => {
   assert.deepEqual(resources.map((r) => r.Type).sort(), [
-    'AWS::ApiGatewayV2::Api',
-    'AWS::ApiGatewayV2::Integration',
-    'AWS::ApiGatewayV2::Route',
-    'AWS::ApiGatewayV2::Stage',
     'AWS::IAM::Policy',
     'AWS::IAM::Role',
     'AWS::Lambda::Function',
     'AWS::Lambda::Permission',
+    'AWS::Lambda::Permission',
+    'AWS::Lambda::Url',
     'AWS::Logs::LogGroup',
   ]);
 });
@@ -44,14 +42,19 @@ test('eu-north-1, termination protection on', () => {
   assert.equal(stack.terminationProtection, true);
 });
 
-test('Node 24 on arm64, its own handler', () => {
+test('Node 24 on arm64, its own handler, 10 seconds', () => {
   template.hasResourceProperties('AWS::Lambda::Function', {
     Runtime: 'nodejs24.x',
     Architectures: ['arm64'],
     Handler: 'handler.handler',
+    Timeout: 10,
   });
 });
 
+test('no reserved concurrency yet (D71 Q12)', () => {
+  assert.equal(only('AWS::Lambda::Function').Properties?.['ReservedConcurrentExecutions'], undefined);
+});
+
 test('logs: 7 days, JSON, application INFO, system WARN', () => {
   // The group is kept 7 days and goes with the stack (D44 c).
   template.hasResource('AWS::Logs::LogGroup', {
@@ -78,13 +81,44 @@ test('no environment, no tracing', () => {
   assert.equal(props['TracingConfig'], undefined);
 });
 
-test('no access logs, no CORS, no authorizer', () => {
-  assert.equal(only('AWS::ApiGatewayV2::Stage').Properties?.['AccessLogSettings'], undefined);
-  assert.equal(only('AWS::ApiGatewayV2::Api').Properties?.['CorsConfiguration'], undefined);
-  assert.equal(only('AWS::ApiGatewayV2::Route').Properties?.['AuthorizerId'], undefined);
+test('one function URL: no authentication of its own, no CORS', () => {
+  const url = only('AWS::Lambda::Url').Properties ?? {};
+  assert.deepEqual(Object.keys(url).sort(), ['AuthType', 'TargetFunctionArn']);
+  assert.equal(url['AuthType'], 'NONE');
+  assert.equal(resources.filter((r) => r.Type.startsWith('AWS::ApiGatewayV2::')).length, 0);
+});
+
+test('anyone may call it, through the URL only', () => {
+  const permissions = resources.filter((r) => r.Type === 'AWS::Lambda::Permission').map((r) => r.Properties ?? {});
+  const fn = { 'Fn::GetAtt': [Match.stringLikeRegexp('^Handler'), 'Arn'] };
+  assert.deepEqual(
+    permissions.map((p) => Object.keys(p).sort()),
+    [
+      ['Action', 'FunctionName', 'FunctionUrlAuthType', 'Principal'],
+      ['Action', 'FunctionName', 'InvokedViaFunctionUrl', 'Principal'],
+    ],
+  );
+  template.hasResourceProperties('AWS::Lambda::Permission', {
+    Action: 'lambda:InvokeFunctionUrl',
+    FunctionName: fn,
+    FunctionUrlAuthType: 'NONE',
+    Principal: '*',
+  });
+  template.hasResourceProperties('AWS::Lambda::Permission', {
+    Action: 'lambda:InvokeFunction',
+    FunctionName: fn,
+    InvokedViaFunctionUrl: true,
+    Principal: '*',
+  });
 });
 
-test('the role writes to its own log group only', () => {
+test("one output, the URL's address", () => {
+  const outputs = template.toJSON()['Outputs'] as Record<string, unknown>;
+  assert.deepEqual(Object.keys(outputs), ['Url']);
+  template.hasOutput('Url', { Value: { 'Fn::GetAtt': [Match.stringLikeRegexp('^HandlerFunctionUrl'), 'FunctionUrl'] } });
+});
+
+test('the role: its own log group, and the two keys only', () => {
   assert.equal(only('AWS::IAM::Role').Properties?.['ManagedPolicyArns'], undefined);
   // No inline policy on the role either (D44 a).
   assert.equal(only('AWS::IAM::Role').Properties?.['Policies'], undefined);
@@ -96,6 +130,24 @@ test('the role writes to its own log group only', () => {
           Effect: 'Allow',
           Resource: { 'Fn::GetAtt': [Match.stringLikeRegexp('^Logs'), 'Arn'] },
         },
+        {
+          Action: 'ssm:GetParameter',
+          Effect: 'Allow',
+          Resource: ['beta-key', 'soniox-key'].map((name) => ({
+            'Fn::Join': [
+              '',
+              ['arn:', { Ref: 'AWS::Partition' }, ':ssm:eu-north-1:', { Ref: 'AWS::AccountId' }, `:parameter/souldreams/${name}`],
+            ],
+          })),
+        },
+        {
+          Action: 'kms:Decrypt',
+          Condition: { StringEquals: { 'kms:ViaService': 'ssm.eu-north-1.amazonaws.com' } },
+          Effect: 'Allow',
+          Resource: {
+            'Fn::Join': ['', ['arn:', { Ref: 'AWS::Partition' }, ':kms:eu-north-1:', { Ref: 'AWS::AccountId' }, ':key/*']],
+          },
+        },
       ],
     },
   });
~~~~

### Task 4 · [OWNER] `@aws-sdk/client-ssm`, for its types (D71 Q13 a)

The sandbox reaches no registry, so the install is the owner's (D42).

Paste 1 — Terminal (choose the version: the newest published at least two weeks ago)
```
cd ~/Developer/soul-dreams-app/server && npm view @aws-sdk/client-ssm time --json | tail -20
```

Paste 2 — Terminal (with that version in place of `<version>`)
```
cd ~/Developer/soul-dreams-app/server && npm install --save-dev --save-exact '@aws-sdk/client-ssm@<version>' && git diff --stat package.json && npm audit
```

Expected:
- `package.json | 1 +`, the line `"@aws-sdk/client-ssm": "<version>",` first under `devDependencies`;
- `package-lock.json` gains the client and its own packages (`@smithy/…`, `@aws-crypto/…`, `@aws-sdk/…`);
- `npm audit`: the two moderate `minimatch` findings of banked item 45, and anything new brought to the Build chat
  before going on.

Then bring the version to Claude Code. Do not commit yet: Task 5 commits the package files with its code.

### Task 5 · Server: Parameter Store and the handler's wiring (D71 Q13)

New: `parameters.ts`. `handler.ts` becomes the front door, wired. Tests: `handler.test.ts` (2, rewritten),
`dist.test.ts` (the folder's files and its imports), `package.test.ts` (six packages).

After the block, Claude Code puts the owner's version into the package test:

```
sed -i '' "s/SSM-VERSION-FROM-TASK-4/<version>/" server/test/package.test.ts && grep -c "'@aws-sdk/client-ssm': '<version>'" server/test/package.test.ts
```

Expected: `1`. Then 47 server tests and `npm run check` clean.

- If `npm run check` fails inside the SDK's own types (the server checks every library's types, `skipLibCheck:
  false`): stop and bring the error (R14). The proof used a stand-in of the two classes (Part 5).
- If the lockfile test finds an install script among the new packages: stop.

Commit, with the owner's `package.json` and `package-lock.json`:

> Server: the two keys from Parameter Store, the handler wired; the SSM client for its types (D71 Q13)

**The block:**

~~~~diff
diff --git a/server/src/handler.ts b/server/src/handler.ts
index 224431c..1469d60 100644
--- a/server/src/handler.ts
+++ b/server/src/handler.ts
@@ -1,19 +1,11 @@
-// The server's one entry point, behind the HTTP API (D42 Q4). No feature
-// yet: every request is answered 404 with no body, and one code is
-// logged (D42 Q15). It never reads the event, which carries the
-// caller's network address, and never logs an error's message (R3).
-import { safeLog } from './safe-log.ts';
+// The server's one entry point, behind its function URL (head's message
+// 14; D71): the front door (door.ts), wired to Parameter Store and to
+// Soniox. Everything it decides is in door.ts and tested there.
+import { makeDoor } from './door.ts';
+import { readParameter } from './parameters.ts';
+import { requestTemporaryKey } from './soniox.ts';
 
-export interface Reply {
-  readonly statusCode: number;
-}
-
-export async function handler(): Promise<Reply> {
-  try {
-    safeLog('notFound');
-    return { statusCode: 404 };
-  } catch {
-    safeLog('handlerFailed');
-    return { statusCode: 500 };
-  }
-}
+export const handler = makeDoor({
+  readParameter,
+  temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
+});
diff --git a/server/src/parameters.ts b/server/src/parameters.ts
new file mode 100644
index 0000000..976246d
--- /dev/null
+++ b/server/src/parameters.ts
@@ -0,0 +1,16 @@
+// Reads one SecureString, decrypted (D69; D71 Q13 a). The code runs on
+// the AWS SDK for JavaScript v3 that the Lambda runtime carries; the
+// package is a devDependency for its types only, and is never in the
+// Lambda's code folder. A failure carries no message of ours.
+import { GetParameterCommand, SSMClient } from '@aws-sdk/client-ssm';
+
+const client = new SSMClient({ region: 'eu-north-1' });
+
+export async function readParameter(name: string): Promise<string> {
+  const reply = await client.send(new GetParameterCommand({ Name: name, WithDecryption: true }));
+  const value = reply.Parameter?.Value;
+  if (value === undefined || value === '') {
+    throw new Error('parameter-empty');
+  }
+  return value;
+}
diff --git a/server/test/dist.test.ts b/server/test/dist.test.ts
index e3d23be..f152f18 100644
--- a/server/test/dist.test.ts
+++ b/server/test/dist.test.ts
@@ -15,6 +15,7 @@ test('the compiled files and the marker, nothing else', () => {
     'hosts.js',
     'package.json',
     'parameter-names.js',
+    'parameters.js',
     'safe-log.js',
     'soniox.js',
   ]);
@@ -25,5 +26,18 @@ test('the marker makes the code a module', () => {
 });
 
 test('imports end in .js', () => {
-  assert.match(readFileSync(new URL('handler.js', CODE), 'utf8'), /from "\.\/safe-log\.js";/);
+  assert.match(readFileSync(new URL('handler.js', CODE), 'utf8'), /from "\.\/door\.js";/);
+});
+
+test("imports: its own files, Node's, and the SSM client only", () => {
+  const files = readdirSync(CODE).filter((f) => f.endsWith('.js'));
+  const outside = new Set<string>();
+  for (const file of files) {
+    const text = readFileSync(new URL(file, CODE), 'utf8');
+    for (const m of text.matchAll(/from ["']([^"']+)["']/g)) {
+      const from = m[1] ?? '';
+      if (!from.startsWith('./')) outside.add(from);
+    }
+  }
+  assert.deepEqual([...outside].sort(), ['@aws-sdk/client-ssm', 'node:crypto']);
 });
diff --git a/server/test/handler.test.ts b/server/test/handler.test.ts
index f458454..dcdde46 100644
--- a/server/test/handler.test.ts
+++ b/server/test/handler.test.ts
@@ -1,5 +1,6 @@
-// The handler (D42 Q15): 404 with no body and one logged code; on a
-// failure, 500 and a code, never the error's message (R3).
+// The handler is the front door, wired (D71). What it decides is tested
+// in door.test.ts; here, a request it must refuse reaches neither
+// Parameter Store nor Soniox, and logs its one code.
 import assert from 'node:assert/strict';
 import { afterEach, beforeEach, test } from 'node:test';
 import { handler } from '../src/handler.ts';
@@ -9,28 +10,26 @@ let lines: string[] = [];
 let restore = (): void => {};
 beforeEach(() => {
   lines = [];
+  restore = setSink((line) => {
+    lines.push(line);
+  });
 });
 afterEach(() => {
   restore();
 });
 
-test('every request: 404, no body, one code', async () => {
-  restore = setSink((line) => {
-    lines.push(line);
-  });
-  assert.deepEqual(await handler(), { statusCode: 404 });
+test('another method: 404, no body, one code', async () => {
+  const reply = await handler({ rawPath: '/', requestContext: { http: { method: 'GET' } } });
+  assert.deepEqual(reply, { statusCode: 404 });
   assert.deepEqual(lines, ['notFound']);
 });
 
-test('a failure: 500 and a code, never its message', async () => {
-  let first = true;
-  restore = setSink((line) => {
-    if (first) {
-      first = false;
-      throw new Error('invented failure text');
-    }
-    lines.push(line);
+test('a misshapen key: 401 before anything is read', async () => {
+  const reply = await handler({
+    rawPath: '/',
+    headers: { authorization: 'Bearer short' },
+    requestContext: { http: { method: 'POST' } },
   });
-  assert.deepEqual(await handler(), { statusCode: 500 });
-  assert.deepEqual(lines, ['handlerFailed']);
+  assert.deepEqual(reply, { statusCode: 401 });
+  assert.deepEqual(lines, ['keyRefused']);
 });
diff --git a/server/test/package.test.ts b/server/test/package.test.ts
index d4eccd4..30699a8 100644
--- a/server/test/package.test.ts
+++ b/server/test/package.test.ts
@@ -1,5 +1,6 @@
-// The server's packages (D41; D42 Q1, Q14): the five named, at exact
-// versions, for development only, none running a script when installed,
+// The server's packages (D41; D42 Q1, Q14; D71 Q13): the six named, at
+// exact versions, for development only (the SSM client for its types:
+// the Lambda runtime carries its own), none running a script when installed,
 // on Node 24. The owner installs them (D41); the lockfile records it.
 import assert from 'node:assert/strict';
 import { readFileSync } from 'node:fs';
@@ -12,6 +13,7 @@ function read(name: string): Json {
 }
 
 const PACKAGES = {
+  '@aws-sdk/client-ssm': 'SSM-VERSION-FROM-TASK-4',
   '@types/node': '24.19.2',
   'aws-cdk': '2.1147.0',
   'aws-cdk-lib': '2.275.0',
@@ -19,7 +21,7 @@ const PACKAGES = {
   typescript: '6.0.3',
 };
 
-test('the five packages, exact, for development only', () => {
+test('the six packages, exact, for development only', () => {
   const pkg = read('package.json');
   assert.deepEqual(pkg['devDependencies'], PACKAGES);
   assert.equal(pkg['dependencies'], undefined);
~~~~

### Task 6 · Server: the mutation rows S17 to S30

`tool/server_mutations.py`: S4, S8, S12, S13 and S14 follow the code and names they break; S17 to S30 are new.

Run from the repository root: `python3 -I -B tool/server_mutations.py`. Expected: `server mutations: 30 run, 30
caught`. Commit:

> Tools: the server's mutation rows for the front door and its stack (S17 to S30)

**The block:**

~~~~diff
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
index 7f859f5..3292981 100644
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -28,9 +28,9 @@ ROWS = [
      'test', 'a number that is not finite is refused'),
     ('S3', 'src/safe-log.ts', 'numbers: readonly number[] = []',
      'numbers: readonly unknown[] = []', 'check', 'test/safe-log.test.ts'),
-    ('S4', 'src/handler.ts', "    safeLog('handlerFailed');\n    return { statusCode: 500 };",
-     '    return { statusCode: 404 };',
-     'test', 'a failure: 500 and a code, never its message'),
+    ('S4', 'src/door.ts', "      safeLog('handlerFailed');\n      return { statusCode: 500 };",
+     '      return { statusCode: 404 };',
+     'test', 'a failure anywhere else: 500 and a code'),
     ('S5', 'package.json', ' && node infra/dist.ts mark', '',
      'test', 'the marker makes the code a module'),
     ('S6', 'infra/stack.ts', '      analyticsReporting: false,\n', '',
@@ -38,7 +38,7 @@ ROWS = [
     ('S7', 'infra/stack.ts', 'RetentionDays.ONE_WEEK', 'RetentionDays.ONE_MONTH',
      'test', 'logs: 7 days, JSON, application INFO, system WARN'),
     ('S8', 'infra/stack.ts', '      role,\n', '',
-     'test', 'the role writes to its own log group only'),
+     'test', 'the role: its own log group, and the two keys only'),
     ('S9', 'infra/account.ts', '  if (wanted !== resolved) {',
      '  if (wanted !== resolved && wanted !== undefined) {',
      'test', 'none passed, or another: refused'),
@@ -47,21 +47,55 @@ ROWS = [
     ('S11', 'cdk.json', '"notices": false', '"notices": true',
      'test', 'cdk.json switches off the three reports'),
     ('S12', 'package.json', '"aws-cdk-lib": "2.275.0"', '"aws-cdk-lib": "^2.275.0"',
-     'test', 'the five packages, exact, for development only'),
-    ('S13', 'infra/stack.ts', "    new HttpApi(this, 'Api', {",
-     "    new logs.LogGroup(this, 'Extra');\n    new HttpApi(this, 'Api', {",
+     'test', 'the six packages, exact, for development only'),
+    ('S13', 'infra/stack.ts', '    const url = fn.addFunctionUrl(',
+     "    new logs.LogGroup(this, 'Extra');\n    const url = fn.addFunctionUrl(",
      'test', 'these resources and no others'),
     ('S14', 'infra/stack.ts',
      "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n",
      "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n"
      "      inlinePolicies: { x: new iam.PolicyDocument({ statements: ["
      "new iam.PolicyStatement({ actions: ['logs:*'], resources: ['*'] })] }) },\n",
-     'test', 'the role writes to its own log group only'),
+     'test', 'the role: its own log group, and the two keys only'),
     ('S15', 'infra/stack.ts', '      logGroup,\n',
      "      logGroup: logs.LogGroup.fromLogGroupName(this, 'Old', 'kept'),\n",
      'test', 'logs: 7 days, JSON, application INFO, system WARN'),
     ('S16', 'infra/stack.ts', 'RemovalPolicy.DESTROY', 'RemovalPolicy.RETAIN',
      'test', 'logs: 7 days, JSON, application INFO, system WARN'),
+    # The recording branch (D71): the front door and its stack.
+    ('S17', 'infra/stack.ts', 'FunctionUrlAuthType.NONE', 'FunctionUrlAuthType.AWS_IAM',
+     'test', 'one function URL: no authentication of its own, no CORS'),
+    ('S18', 'infra/stack.ts', 'authType: lambda.FunctionUrlAuthType.NONE }',
+     "authType: lambda.FunctionUrlAuthType.NONE, cors: { allowedOrigins: ['*'] } }",
+     'test', 'one function URL: no authentication of its own, no CORS'),
+    ('S19', 'infra/stack.ts', '      timeout: Duration.seconds(10),\n',
+     '      timeout: Duration.seconds(10),\n      reservedConcurrentExecutions: 5,\n',
+     'test', 'no reserved concurrency yet (D71 Q12)'),
+    ('S20', 'infra/stack.ts', 'Duration.seconds(10)', 'Duration.seconds(30)',
+     'test', 'Node 24 on arm64, its own handler, 10 seconds'),
+    ('S21', 'infra/stack.ts',
+     "        conditions: { StringEquals: { 'kms:ViaService': `ssm.${REGION}.amazonaws.com` } },\n", '',
+     'test', 'the role: its own log group, and the two keys only'),
+    ('S22', 'infra/stack.ts', "    new CfnOutput(this, 'Url', { value: url.url });", '    void url;',
+     'test', "one output, the URL's address"),
+    ('S23', 'src/soniox.ts', '  max_session_duration_seconds: 1800,\n',
+     "  max_session_duration_seconds: 1800,\n  context: 'x',\n",
+     'test', 'exactly these four fields and no other (R4)'),
+    ('S24', 'src/soniox.ts', '  if (reply.status !== 201) {', '  if (reply.status >= 500) {',
+     'test', "Soniox's refusal carries its status"),
+    ('S25', 'src/beta-key.ts', '  return timingSafeEqual(a, b);', '  return timingSafeEqual(a, b) && given === kept;',
+     'test', 'the comparison hashes both keys and takes the same time'),
+    ('S26', 'src/door.ts', '  if (!isBetaKeyShape(given)) {', "  if (!isBetaKeyShape(given) && given === '') {",
+     'test', 'a misshapen key is refused before anything is read'),
+    ('S27', 'src/door.ts', "  if (event.requestContext?.http?.method !== 'POST'",
+     "  if (JSON.stringify(event) === '' || event.requestContext?.http?.method !== 'POST'",
+     'test', 'the right key: 200 and a short-lived key, one code'),
+    ('S28', 'src/door.ts', '  if (!sameKey(given, betaKey)) {', '  if (!sameKey(given, betaKey) && false) {',
+     'test', 'a wrong, missing or misshapen key: 401, Soniox never asked'),
+    ('S29', 'src/hosts.ts', 'api.eu.soniox.com/v1', 'api.soniox.com/v1',
+     'test', 'the temporary-key address is on that host, over https'),
+    ('S30', 'src/soniox.ts', "  if (typeof key !== 'string' || key === '' ||", "  if (typeof key !== 'string' ||",
+     'test', 'no answer is 0; an unreadable answer is -1'),
 ]
 
 
~~~~

### Task 7 · App: recording's core (D69; D71 Q6, Q8, Q9, Q17)

`hosts.dart` gains Soniox's EU endpoint and an empty `server`. New in `lib/recording/`: `microphone.dart` (the
interface and a frame's level), `soniox.dart`, `key_client.dart`, `heard_text.dart`, `recording.dart`. Seven codes in
`SafeLog`. Tests in `test/recording/`, with `fakes.dart` (the loopback stand-ins, a silent microphone, a link in
memory): `heard_text_test.dart` (5), `soniox_test.dart` (6), `key_client_test.dart` (3), `recording_test.dart` (13);
and `test/core/hosts_test.dart` (2).

Two things the proof found, now in the code:
- A file that makes real requests on loopback holds no widget test: Flutter's test binding answers every HTTP request
  with 400 once one runs.
- Recording never awaits a stream subscription's `cancel()`: under the widget tests' fake clock it never resumes.

Expected: 221 app tests. Commit:

> Recording: Soniox's stream, the key from our server, the words heard, one recording's life (D69, D71)

**The block:**

~~~~diff
diff --git a/app/lib/core/hosts.dart b/app/lib/core/hosts.dart
index e117291..3c690c7 100644
--- a/app/lib/core/hosts.dart
+++ b/app/lib/core/hosts.dart
@@ -1,4 +1,10 @@
 // Every host the app talks to lives here, and nowhere else (CLAUDE.md
-// R10, G9). None yet: the server and Soniox's EU endpoint arrive with
-// the branches that use them.
-abstract final class Hosts {}
+// R10, G9): our server's front door and Soniox's EU real-time endpoint.
+abstract final class Hosts {
+  /// Soniox's EU real-time transcription (technical-answers a; D69).
+  static const soniox = 'wss://stt-rt.eu.soniox.com/transcribe-websocket';
+
+  /// Our server's function URL, set after the owner's first deploy (D71
+  /// Q17). While it is empty, recording is off.
+  static const server = '';
+}
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index 0c55041..4cd2608 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -34,6 +34,18 @@ enum LogEvent {
 
   /// The typing screen's read or mark of first use failed (D71 Q18).
   firstUseReadFailed,
+
+  /// Recording by voice (D69, D71). Off in this build; the microphone
+  /// refused; no key from our server (its status); Soniox's stream refused
+  /// or broken (its code); the microphone failing; a recording started,
+  /// and ended.
+  recordingOff,
+  recordingRefused,
+  recordingKeyFailed,
+  recordingStreamFailed,
+  recordingMicFailed,
+  recordingStarted,
+  recordingEnded,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/recording/heard_text.dart b/app/lib/recording/heard_text.dart
new file mode 100644
index 0000000..02f7d3c
--- /dev/null
+++ b/app/lib/recording/heard_text.dart
@@ -0,0 +1,20 @@
+// Words heard, joined to the field's text (D71 Q6): always at the end,
+// never at the caret. The provisional words are shown after the final
+// ones and replaced by the next reply; [shown] is the provisional piece
+// put there last time, taken off again first if it is still at the end.
+final _space = RegExp(r'\s');
+
+String _join(String base, String add) {
+  if (add.isEmpty) return base;
+  if (base.isEmpty || _space.hasMatch(base[base.length - 1])) return base + add.trimLeft();
+  if (_space.hasMatch(add[0])) return base + add;
+  return '$base $add';
+}
+
+/// The field's new text, and the provisional piece now at its end.
+({String text, String shown}) withHeard(String text, String shown, String finalText, String provisional) {
+  final base = shown.isNotEmpty && text.endsWith(shown) ? text.substring(0, text.length - shown.length) : text;
+  final withFinal = _join(base, finalText);
+  final all = _join(withFinal, provisional);
+  return (text: all, shown: all.substring(withFinal.length));
+}
diff --git a/app/lib/recording/key_client.dart b/app/lib/recording/key_client.dart
new file mode 100644
index 0000000..fa1484b
--- /dev/null
+++ b/app/lib/recording/key_client.dart
@@ -0,0 +1,44 @@
+// Asks our server for a short-lived Soniox key (D69; D71 Q11): one POST
+// with no body, the beta key as a bearer token, and no other header that
+// could name the phone (R4).
+import 'dart:convert';
+import 'dart:io';
+
+/// The server gave no key: its HTTP status, 0 for no answer, -1 for an
+/// unreadable one.
+final class KeyFailure implements Exception {
+  const KeyFailure(this.status);
+
+  final int status;
+}
+
+const _wait = Duration(seconds: 10);
+
+Future<String> fetchKey(Uri server, String betaKey) async {
+  final client = HttpClient()
+    ..userAgent = null
+    ..connectionTimeout = _wait;
+  try {
+    final request = await client.postUrl(server).timeout(_wait);
+    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
+    request.contentLength = 0;
+    final reply = await request.close().timeout(_wait);
+    final body = await utf8.decodeStream(reply).timeout(_wait);
+    if (reply.statusCode != 200) throw KeyFailure(reply.statusCode);
+    final Object? parsed;
+    try {
+      parsed = jsonDecode(body);
+    } on FormatException {
+      throw const KeyFailure(-1);
+    }
+    final key = parsed is Map<String, Object?> ? parsed['key'] : null;
+    if (key is! String || key.isEmpty) throw const KeyFailure(-1);
+    return key;
+  } on KeyFailure {
+    rethrow;
+  } on Object {
+    throw const KeyFailure(0);
+  } finally {
+    client.close(force: true);
+  }
+}
diff --git a/app/lib/recording/microphone.dart b/app/lib/recording/microphone.dart
new file mode 100644
index 0000000..ea825c3
--- /dev/null
+++ b/app/lib/recording/microphone.dart
@@ -0,0 +1,34 @@
+// The phone's microphone, as recording needs it (D69): sixteen-bit
+// little-endian PCM, 16 kHz, one channel, handed on as it comes and never
+// written anywhere. One implementation uses the `record` package
+// (D71 Q14, Q15); tests use their own.
+import 'dart:math' as math;
+import 'dart:typed_data';
+
+/// The audio's rate, as Soniox is told it.
+const sampleRate = 16000;
+
+abstract interface class Microphone {
+  /// Whether the microphone may be used; the first time, the phone asks
+  /// the dreamer, with EM·3.
+  Future<bool> allowed();
+
+  /// Starts the microphone: its frames, as they come.
+  Future<Stream<Uint8List>> start();
+
+  Future<void> stop();
+}
+
+/// How loud a frame of PCM is, from 0 to 1 (its root mean square), for
+/// the level line.
+double level(Uint8List frame) {
+  final samples = frame.length ~/ 2;
+  if (samples == 0) return 0;
+  final data = ByteData.sublistView(frame);
+  var sum = 0.0;
+  for (var i = 0; i < samples; i++) {
+    final s = data.getInt16(i * 2, Endian.little) / 32768;
+    sum += s * s;
+  }
+  return math.min(1, math.sqrt(sum / samples));
+}
diff --git a/app/lib/recording/recording.dart b/app/lib/recording/recording.dart
new file mode 100644
index 0000000..a11ba9a
--- /dev/null
+++ b/app/lib/recording/recording.dart
@@ -0,0 +1,202 @@
+// Recording by voice, in SoulDreams Dev (D69, as D71 corrects it): the
+// words appear as the dreamer speaks, and the audio goes from the
+// microphone to Soniox and nowhere else; nothing of it is kept on the
+// phone. This slice needs a connection: with none, or with the key or
+// the stream failing, the microphone does not start; a stream that breaks
+// stops, keeping the words shown. Each logs a code and shows nothing new
+// (D71). Offline recording is the next slice.
+import 'dart:async';
+import 'dart:typed_data';
+
+import '../core/hosts.dart';
+import '../core/safe_log.dart';
+import 'key_client.dart';
+import 'microphone.dart';
+import 'soniox.dart';
+
+/// What a typing screen needs to record.
+final class Recording {
+  const Recording({required this.on, required this.microphone, required this.key, required this.connect});
+
+  /// SoulDreams Dev's own: our server for the key, Soniox's EU endpoint for
+  /// the words. Off while the server's address is empty, or the build's
+  /// beta key is not 48 characters of A-Z, a-z and 0-9 (D18; D71 Q17).
+  factory Recording.live({required Microphone microphone, required String betaKey, String server = Hosts.server}) =>
+      Recording(
+        on: server.isNotEmpty && _betaShape.hasMatch(betaKey),
+        microphone: microphone,
+        key: () => fetchKey(Uri.parse(server), betaKey),
+        connect: (key) => SocketLink.open(Hosts.soniox, key),
+      );
+
+  final bool on;
+  final Microphone microphone;
+  final Future<String> Function() key;
+  final Future<SonioxLink> Function(String key) connect;
+}
+
+final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
+
+/// How long a stop waits for Soniox's last words.
+const lastWords = Duration(seconds: 5);
+
+/// One recording, from the microphone's tap to its end.
+final class RecordingSession {
+  RecordingSession(
+    this._recording, {
+    required this.onHeard,
+    required this.onLevel,
+    required this.onEnded,
+    this.wait = lastWords,
+  });
+
+  final Recording _recording;
+
+  /// How long a stop waits for the last words.
+  final Duration wait;
+
+  /// Words heard: the newly final ones, and the provisional ones.
+  final void Function(String finalText, String provisional) onHeard;
+
+  /// Each frame's loudness, 0 to 1.
+  final void Function(double level) onLevel;
+
+  /// The recording ended, by a stop or by itself.
+  final void Function() onEnded;
+
+  SonioxLink? _link;
+  StreamSubscription<String>? _replies;
+  StreamSubscription<Uint8List>? _frames;
+  final _finished = Completer<void>();
+  bool _cancelled = false;
+  bool _ended = false;
+
+  /// Starts recording; false when it did not start (a code is logged).
+  Future<bool> start() async {
+    if (!_recording.on) return _fail(LogEvent.recordingOff);
+    final bool allowed;
+    try {
+      allowed = await _recording.microphone.allowed();
+    } on Object {
+      return _fail(LogEvent.recordingRefused);
+    }
+    if (!allowed) return _fail(LogEvent.recordingRefused);
+    if (_cancelled) return false;
+    final String key;
+    try {
+      key = await _recording.key();
+    } on KeyFailure catch (e) {
+      return _fail(LogEvent.recordingKeyFailed, [e.status]);
+    } on Object {
+      return _fail(LogEvent.recordingKeyFailed, [0]);
+    }
+    if (_cancelled) return false;
+    final SonioxLink link;
+    try {
+      link = await _recording.connect(key);
+    } on Object {
+      return _fail(LogEvent.recordingStreamFailed, [0]);
+    }
+    if (_cancelled) {
+      await link.close();
+      return false;
+    }
+    _link = link;
+    _replies = link.replies.listen(_reply, onError: (Object _) => _broke(0), onDone: () => _broke(link.closeCode ?? 0));
+    final Stream<Uint8List> frames;
+    try {
+      frames = await _recording.microphone.start();
+    } on Object {
+      SafeLog.event(LogEvent.recordingMicFailed);
+      await _shut();
+      return false;
+    }
+    if (_cancelled || _ended) {
+      await _shut();
+      return false;
+    }
+    _frames = frames.listen((frame) {
+      _link?.add(frame);
+      onLevel(level(frame));
+    });
+    SafeLog.event(LogEvent.recordingStarted);
+    return true;
+  }
+
+  bool _fail(LogEvent code, [List<num> numbers = const []]) {
+    SafeLog.event(code, numbers);
+    return false;
+  }
+
+  void _reply(String text) {
+    if (_ended) return;
+    switch (readReply(text)) {
+      case Heard(:final finalText, :final provisional, :final finished):
+        if (finalText.isNotEmpty || provisional.isNotEmpty || finished) onHeard(finalText, provisional);
+        if (finished && !_finished.isCompleted) _finished.complete();
+      case Refused(:final code):
+        _broke(code);
+    }
+  }
+
+  // The stream broke off before its end: the words shown stay.
+  void _broke(int code) {
+    if (_ended || _finished.isCompleted) return;
+    SafeLog.event(LogEvent.recordingStreamFailed, [code]);
+    unawaited(_shut());
+  }
+
+  /// Stops: the microphone off, then Soniox's last words, waited for up to
+  /// [wait].
+  Future<void> stop() async {
+    if (_ended) return;
+    await _micOff();
+    final link = _link;
+    if (link != null) {
+      link.finish();
+      await _finished.future.timeout(wait, onTimeout: () {});
+    }
+    await _shut();
+  }
+
+  /// Ends at once, waiting for nothing (leaving the screen or the app).
+  Future<void> cancel() async {
+    _cancelled = true;
+    await _shut();
+  }
+
+  Future<void> _micOff() async {
+    final frames = _frames;
+    _frames = null;
+    if (frames != null) {
+      // Not waited for: its future may belong to another zone, and
+      // nothing needs it.
+      unawaited(frames.cancel());
+      try {
+        await _recording.microphone.stop();
+      } on Object {
+        SafeLog.event(LogEvent.recordingMicFailed);
+      }
+    }
+  }
+
+  Future<void> _shut() async {
+    if (_ended) return;
+    _ended = true;
+    await _micOff();
+    final replies = _replies;
+    _replies = null;
+    final link = _link;
+    _link = null;
+    unawaited(replies?.cancel());
+    if (link != null) {
+      try {
+        await link.close();
+      } on Object {
+        // Already closed: nothing to do.
+      }
+    }
+    SafeLog.event(LogEvent.recordingEnded);
+    onEnded();
+  }
+}
diff --git a/app/lib/recording/soniox.dart b/app/lib/recording/soniox.dart
new file mode 100644
index 0000000..93d4d2b
--- /dev/null
+++ b/app/lib/recording/soniox.dart
@@ -0,0 +1,125 @@
+// Soniox's real-time stream, as the app speaks it (technical-answers a;
+// D69; D71 Q8, Q9). The short-lived key goes in the handshake's
+// Authorization header, never in the first message; the first message
+// is exactly the settings below, English only; then the audio as binary
+// frames; an empty text frame ends it. No header names the phone (R4).
+import 'dart:async';
+import 'dart:convert';
+import 'dart:io';
+import 'dart:typed_data';
+
+import 'microphone.dart';
+
+/// The model, named once (D71 Q9).
+const sonioxModel = 'stt-rt-v6';
+
+/// The first message: exactly these settings.
+Map<String, Object> sonioxSettings() => {
+  'model': sonioxModel,
+  'audio_format': 'pcm_s16le',
+  'sample_rate': sampleRate,
+  'num_channels': 1,
+  'language_hints': ['en'],
+  'language_hints_strict': true,
+};
+
+sealed class SonioxReply {
+  const SonioxReply();
+}
+
+/// Words heard: the newly final ones, and the provisional ones now shown
+/// in place of the last.
+final class Heard extends SonioxReply {
+  const Heard(this.finalText, this.provisional, {required this.finished});
+
+  final String finalText;
+  final String provisional;
+
+  /// Soniox has sent everything and will close.
+  final bool finished;
+}
+
+/// Soniox refused or broke off: its error code, or -1 for a reply the app
+/// cannot read.
+final class Refused extends SonioxReply {
+  const Refused(this.code);
+
+  final int code;
+}
+
+// Markers Soniox may put among the words: never shown.
+const _markers = {'<fin>', '<end>'};
+
+SonioxReply readReply(String text) {
+  final Object? parsed;
+  try {
+    parsed = jsonDecode(text);
+  } on FormatException {
+    return const Refused(-1);
+  }
+  if (parsed is! Map<String, Object?>) return const Refused(-1);
+  final code = parsed['error_code'];
+  if (code != null) return Refused(code is int ? code : -1);
+  final tokens = parsed['tokens'];
+  if (tokens is! List<Object?>) return const Refused(-1);
+  final done = StringBuffer();
+  final shown = StringBuffer();
+  for (final t in tokens) {
+    if (t is! Map<String, Object?>) return const Refused(-1);
+    final word = t['text'];
+    if (word is! String) return const Refused(-1);
+    if (_markers.contains(word.trim())) continue;
+    (t['is_final'] == true ? done : shown).write(word);
+  }
+  return Heard(done.toString(), shown.toString(), finished: parsed['finished'] == true);
+}
+
+/// A stream to Soniox.
+abstract interface class SonioxLink {
+  /// Soniox's replies, as text; done when the stream closes.
+  Stream<String> get replies;
+
+  /// The close code once closed, if any.
+  int? get closeCode;
+
+  void add(Uint8List frame);
+
+  /// Asks Soniox to finish: it sends the last words, then closes.
+  void finish();
+
+  Future<void> close();
+}
+
+final class SocketLink implements SonioxLink {
+  SocketLink._(this._socket) : replies = _socket.where((m) => m is String).cast<String>();
+
+  final WebSocket _socket;
+
+  @override
+  final Stream<String> replies;
+
+  /// Opens [url] with the short-lived [key], and sends the settings.
+  static Future<SocketLink> open(String url, String key) async {
+    final client = HttpClient()..userAgent = null;
+    final socket = await WebSocket.connect(
+      url,
+      headers: {HttpHeaders.authorizationHeader: 'Bearer $key'},
+      customClient: client,
+      compression: CompressionOptions.compressionOff,
+    ).timeout(const Duration(seconds: 10));
+    socket.add(jsonEncode(sonioxSettings()));
+    return SocketLink._(socket);
+  }
+
+  @override
+  int? get closeCode => _socket.closeCode;
+
+  @override
+  void add(Uint8List frame) => _socket.add(frame);
+
+  @override
+  void finish() => _socket.add('');
+
+  @override
+  Future<void> close() => _socket.close();
+}
diff --git a/app/test/core/hosts_test.dart b/app/test/core/hosts_test.dart
new file mode 100644
index 0000000..14993bc
--- /dev/null
+++ b/app/test/core/hosts_test.dart
@@ -0,0 +1,18 @@
+// Every host the app talks to lives in lib/core/hosts.dart (R10, G9).
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/hosts.dart';
+
+final _functionUrl = RegExp(r'^https://[a-z0-9]+\.lambda-url\.eu-north-1\.on\.aws/$');
+
+void main() {
+  test("Soniox's EU real-time endpoint", () {
+    expect(Hosts.soniox, startsWith('wss://stt-rt.eu.soniox.com/'));
+  });
+
+  test('our server: empty until the first deploy, then its function URL', () {
+    expect(Hosts.server.isEmpty || _functionUrl.hasMatch(Hosts.server), isTrue);
+    expect(_functionUrl.hasMatch('https://abc123.lambda-url.eu-north-1.on.aws/'), isTrue);
+    expect(_functionUrl.hasMatch('https://abc123.lambda-url.us-east-1.on.aws/'), isFalse);
+    expect(_functionUrl.hasMatch('http://abc123.lambda-url.eu-north-1.on.aws/'), isFalse);
+  });
+}
diff --git a/app/test/recording/fakes.dart b/app/test/recording/fakes.dart
new file mode 100644
index 0000000..1c9f8be
--- /dev/null
+++ b/app/test/recording/fakes.dart
@@ -0,0 +1,188 @@
+// Stand-ins for recording's tests: Soniox's real-time endpoint and our
+// server's front door on this Mac's loopback, a microphone that sends
+// silence, and Soniox's replies built from the invented nights (R2).
+import 'dart:async';
+import 'dart:convert';
+import 'dart:io';
+import 'dart:typed_data';
+
+import 'package:souldreams/recording/microphone.dart';
+import 'package:souldreams/recording/soniox.dart';
+
+import '../fixtures.dart';
+
+/// A dream's words as Soniox's tokens: each word after the first with
+/// its space in front, as Soniox sends them.
+List<String> tokensOf(String dream) {
+  final words = dream.split(' ');
+  return [words.first, for (final w in words.skip(1)) ' $w'];
+}
+
+/// The first invented dream's tokens.
+List<String> inventedTokens() => tokensOf(invented('two-dreams-en').dreams[0]);
+
+String reply({List<String> done = const [], List<String> shown = const [], bool finished = false}) => jsonEncode({
+  'tokens': [
+    for (final t in done) {'text': t, 'is_final': true},
+    for (final t in shown) {'text': t, 'is_final': false},
+  ],
+  'final_audio_proc_ms': 0,
+  'total_audio_proc_ms': 0,
+  if (finished) 'finished': true,
+});
+
+/// Soniox's endpoint, played on loopback: it records the handshake's
+/// headers, the first message and every frame, and answers by [script].
+final class FakeSoniox {
+  FakeSoniox._(this._server);
+
+  final HttpServer _server;
+  final headers = <String, List<String>>{};
+  final texts = <String>[];
+  final frames = <Uint8List>[];
+  WebSocket? socket;
+
+  /// Called on each message after the first; may answer.
+  void Function(FakeSoniox soniox, Object message)? script;
+
+  /// Refuse the handshake with this status, if set.
+  int? refuse;
+
+  String get url => 'ws://127.0.0.1:${_server.port}/transcribe-websocket';
+
+  static Future<FakeSoniox> start() async {
+    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
+    final fake = FakeSoniox._(server);
+    server.listen(fake._handle);
+    return fake;
+  }
+
+  Future<void> _handle(HttpRequest request) async {
+    request.headers.forEach((name, values) => headers[name] = values);
+    final status = refuse;
+    if (status != null) {
+      request.response.statusCode = status;
+      await request.response.close();
+      return;
+    }
+    final ws = await WebSocketTransformer.upgrade(request);
+    socket = ws;
+    ws.listen((message) {
+      if (message is String) {
+        texts.add(message);
+      } else {
+        frames.add(Uint8List.fromList(message as List<int>));
+      }
+      if (texts.length > 1 || message is! String) script?.call(this, message);
+    });
+  }
+
+  void send(String text) => socket!.add(text);
+
+  Future<void> stop() => _server.close(force: true);
+}
+
+/// Our server's front door, played on loopback.
+final class FakeDoor {
+  FakeDoor._(this._server);
+
+  final HttpServer _server;
+  final requests = <({String method, Map<String, List<String>> headers, int bodyLength})>[];
+  int status = 200;
+  String body = jsonEncode({'key': 'temporary-key-in-a-test', 'expiresAt': '2026-11-13T12:00:00Z'});
+  Completer<void>? hold;
+
+  Uri get url => Uri.parse('http://127.0.0.1:${_server.port}/');
+
+  static Future<FakeDoor> start() async {
+    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
+    final fake = FakeDoor._(server);
+    server.listen(fake._handle);
+    return fake;
+  }
+
+  Future<void> _handle(HttpRequest request) async {
+    final headers = <String, List<String>>{};
+    request.headers.forEach((name, values) => headers[name] = values);
+    final bytes = await request.fold<int>(0, (n, chunk) => n + chunk.length);
+    requests.add((method: request.method, headers: headers, bodyLength: bytes));
+    await hold?.future;
+    request.response.statusCode = status;
+    request.response.write(body);
+    await request.response.close();
+  }
+
+  Future<void> stop() => _server.close(force: true);
+}
+
+/// A microphone that sends silence, one frame of 3200 bytes (a tenth of a
+/// second) each time [frame] is called.
+final class SilentMicrophone implements Microphone {
+  bool allow = true;
+  bool fails = false;
+  int stops = 0;
+  StreamController<Uint8List>? _frames;
+
+  bool get running => _frames != null;
+
+  @override
+  Future<bool> allowed() async => allow;
+
+  @override
+  Future<Stream<Uint8List>> start() async {
+    if (fails) throw StateError('microphone');
+    final frames = StreamController<Uint8List>();
+    _frames = frames;
+    return frames.stream;
+  }
+
+  void frame([int value = 0]) {
+    final bytes = Uint8List(3200);
+    final data = ByteData.sublistView(bytes);
+    for (var i = 0; i < 1600; i++) {
+      data.setInt16(i * 2, value, Endian.little);
+    }
+    _frames!.add(bytes);
+  }
+
+  @override
+  Future<void> stop() async {
+    stops++;
+    final frames = _frames;
+    _frames = null;
+    unawaited(frames?.close());
+  }
+}
+
+/// A link held in memory: what was sent, and replies the test pushes.
+final class MemoryLink implements SonioxLink {
+  final _replies = StreamController<String>();
+  final sent = <Object>[];
+  bool closed = false;
+
+  @override
+  int? closeCode;
+
+  @override
+  Stream<String> get replies => _replies.stream;
+
+  void reply(String text) => _replies.add(text);
+
+  /// Soniox closes its end.
+  Future<void> drop([int? code]) async {
+    closeCode = code;
+    await _replies.close();
+  }
+
+  @override
+  void add(Uint8List frame) => sent.add(frame);
+
+  @override
+  void finish() => sent.add('');
+
+  @override
+  Future<void> close() async {
+    closed = true;
+    if (!_replies.isClosed) unawaited(_replies.close());
+  }
+}
diff --git a/app/test/recording/heard_text_test.dart b/app/test/recording/heard_text_test.dart
new file mode 100644
index 0000000..1fe5959
--- /dev/null
+++ b/app/test/recording/heard_text_test.dart
@@ -0,0 +1,48 @@
+// Words heard, joined at the end of the field's text (D71 Q6).
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/recording/heard_text.dart';
+
+import 'fakes.dart';
+
+void main() {
+  final tokens = inventedTokens();
+
+  test('into an empty field: no space in front', () {
+    final r = withHeard('', '', tokens[0], tokens[1]);
+    expect(r.text, tokens[0] + tokens[1]);
+    expect(r.shown, tokens[1]);
+  });
+
+  test('provisional words are replaced, never doubled', () {
+    var r = withHeard('', '', '', tokens[0]);
+    r = withHeard(r.text, r.shown, '', tokens[0] + tokens[1]);
+    expect(r.text, tokens[0] + tokens[1]);
+    r = withHeard(r.text, r.shown, tokens[0] + tokens[1], '');
+    expect(r.text, tokens[0] + tokens[1]);
+    expect(r.shown, '');
+  });
+
+  test('after typed words, one space joins them', () {
+    final word = tokens[0];
+    expect(withHeard(word, '', word, '').text, '$word $word');
+    expect(withHeard('$word ', '', word, '').text, '$word $word');
+    expect(withHeard('$word\n', '', ' $word', '').text, '$word\n$word');
+    expect(withHeard(word, '', ' $word', '').text, '$word $word');
+  });
+
+  test('a provisional piece edited away is left alone', () {
+    var r = withHeard('', '', tokens[0], tokens[1]);
+    final edited = r.text.substring(0, r.text.length - 1);
+    r = withHeard(edited, r.shown, tokens[1], '');
+    expect(r.text, edited + tokens[1]);
+  });
+
+  test('the whole invented dream, heard in pieces, reads as written', () {
+    var r = (text: '', shown: '');
+    for (var i = 0; i < tokens.length; i++) {
+      r = withHeard(r.text, r.shown, tokens[i], i + 1 < tokens.length ? tokens[i + 1] : '');
+    }
+    expect(r.text, tokens.join());
+    expect(r.shown, '');
+  });
+}
diff --git a/app/test/recording/key_client_test.dart b/app/test/recording/key_client_test.dart
new file mode 100644
index 0000000..67a24ad
--- /dev/null
+++ b/app/test/recording/key_client_test.dart
@@ -0,0 +1,51 @@
+// The request for a short-lived key (D69; D71 Q11): one POST, no body,
+// the beta key as bearer, nothing that names the phone (R4).
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/recording/key_client.dart';
+
+import 'fakes.dart';
+
+void main() {
+  final beta = 'Ab0' * 16;
+
+  Future<int> failure(Future<String> f) async {
+    try {
+      await f;
+    } on KeyFailure catch (e) {
+      return e.status;
+    }
+    fail('no failure');
+  }
+
+  test('one POST, no body, the beta key, no user agent', () async {
+    final door = await FakeDoor.start();
+    addTearDown(door.stop);
+    expect(await fetchKey(door.url, beta), 'temporary-key-in-a-test');
+    expect(door.requests, hasLength(1));
+    final r = door.requests.single;
+    expect(r.method, 'POST');
+    expect(r.bodyLength, 0);
+    expect(r.headers['authorization'], ['Bearer $beta']);
+    expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'accept-encoding'});
+  });
+
+  test("the door's refusal carries its status", () async {
+    final door = await FakeDoor.start();
+    addTearDown(door.stop);
+    for (final status in [401, 404, 500, 502]) {
+      door.status = status;
+      expect(await failure(fetchKey(door.url, beta)), status);
+    }
+  });
+
+  test('an unreadable answer is -1; no answer is 0', () async {
+    final door = await FakeDoor.start();
+    for (final body in ['not json', '{}', '{"key":""}', '{"key":3}', '[]']) {
+      door.body = body;
+      expect(await failure(fetchKey(door.url, beta)), -1);
+    }
+    final gone = door.url;
+    await door.stop();
+    expect(await failure(fetchKey(gone, beta)), 0);
+  });
+}
diff --git a/app/test/recording/recording_test.dart b/app/test/recording/recording_test.dart
new file mode 100644
index 0000000..793710b
--- /dev/null
+++ b/app/test/recording/recording_test.dart
@@ -0,0 +1,227 @@
+// One recording (D69, as D71 corrects it): it starts only with the
+// microphone allowed, a key and a stream; the frames go to Soniox as they
+// come and nowhere else; the words come back; a stop waits for the last
+// words; a break keeps the words shown; each failure logs a code.
+import 'dart:async';
+import 'dart:typed_data';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/recording/key_client.dart';
+import 'package:souldreams/recording/recording.dart';
+import 'package:souldreams/recording/soniox.dart';
+
+import 'fakes.dart';
+
+void main() {
+  final tokens = inventedTokens();
+  final beta = 'Ab0' * 16;
+  late List<String> lines;
+  late void Function(String) sink;
+  setUp(() {
+    lines = [];
+    sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+  });
+  tearDown(() => SafeLog.sink = sink);
+
+  ({RecordingSession session, List<(String, String)> heard, List<double> levels, List<int> ended}) make(
+    Recording recording,
+  ) {
+    final heard = <(String, String)>[];
+    final levels = <double>[];
+    final ended = <int>[];
+    final session = RecordingSession(
+      recording,
+      onHeard: (f, p) => heard.add((f, p)),
+      onLevel: levels.add,
+      onEnded: () => ended.add(1),
+    );
+    return (session: session, heard: heard, levels: levels, ended: ended);
+  }
+
+  Recording memory(SilentMicrophone mic, MemoryLink link, {bool on = true, Future<String> Function()? key}) =>
+      Recording(on: on, microphone: mic, key: key ?? () async => 'temporary-key-in-a-test', connect: (_) async => link);
+
+  test('off: nothing asked, a code', () async {
+    final mic = SilentMicrophone();
+    final r = make(memory(mic, MemoryLink(), on: false));
+    expect(await r.session.start(), isFalse);
+    expect(lines, ['recordingOff']);
+    expect(mic.running, isFalse);
+  });
+
+  test('live: off with no server address, or a misshapen beta key', () {
+    final mic = SilentMicrophone();
+    expect(Recording.live(microphone: mic, betaKey: beta, server: '').on, isFalse);
+    expect(Recording.live(microphone: mic, betaKey: beta.substring(1), server: 'x').on, isFalse);
+    expect(Recording.live(microphone: mic, betaKey: '$beta-'.substring(1), server: 'x').on, isFalse);
+    expect(Recording.live(microphone: mic, betaKey: beta, server: 'x').on, isTrue);
+  });
+
+  test('the microphone refused: no key asked, a code', () async {
+    var asked = 0;
+    final mic = SilentMicrophone()..allow = false;
+    final r = make(memory(mic, MemoryLink(), key: () async => '${asked++}'));
+    expect(await r.session.start(), isFalse);
+    expect(asked, 0);
+    expect(lines, ['recordingRefused']);
+  });
+
+  test('no key: the microphone does not start, the status logged', () async {
+    final mic = SilentMicrophone();
+    final r = make(memory(mic, MemoryLink(), key: () async => throw const KeyFailure(401)));
+    expect(await r.session.start(), isFalse);
+    expect(mic.running, isFalse);
+    expect(lines, ['recordingKeyFailed 401']);
+  });
+
+  test('no stream: the microphone does not start, a code', () async {
+    final mic = SilentMicrophone();
+    final r = make(
+      Recording(on: true, microphone: mic, key: () async => 'k', connect: (_) async => throw StateError('x')),
+    );
+    expect(await r.session.start(), isFalse);
+    expect(mic.running, isFalse);
+    expect(lines, ['recordingStreamFailed 0']);
+  });
+
+  test('the microphone failing: the stream closed, a code', () async {
+    final mic = SilentMicrophone()..fails = true;
+    final link = MemoryLink();
+    final r = make(memory(mic, link));
+    expect(await r.session.start(), isFalse);
+    expect(link.closed, isTrue);
+    expect(lines, ['recordingMicFailed', 'recordingEnded']);
+  });
+
+  test('frames go to Soniox as they come; their level shown', () async {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    final r = make(memory(mic, link));
+    expect(await r.session.start(), isTrue);
+    mic.frame();
+    mic.frame(16384);
+    await pumpEventQueue();
+    expect(link.sent, hasLength(2));
+    expect((link.sent[1] as Uint8List).length, 3200);
+    expect(r.levels, [0, 0.5]);
+    expect(lines, ['recordingStarted']);
+  });
+
+  test('words come back; a stop waits for the last ones', () async {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    final r = make(memory(mic, link));
+    await r.session.start();
+    link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
+    await pumpEventQueue();
+    expect(r.heard, [(tokens[0], tokens[1])]);
+    final stopping = r.session.stop();
+    await pumpEventQueue();
+    expect(mic.running, isFalse);
+    expect(link.sent.last, '');
+    expect(r.ended, isEmpty);
+    link.reply(reply(done: [tokens[1]]));
+    link.reply(reply(finished: true));
+    await stopping;
+    expect(r.heard, [(tokens[0], tokens[1]), (tokens[1], ''), ('', '')]);
+    expect(link.closed, isTrue);
+    expect(r.ended, [1]);
+    expect(lines, ['recordingStarted', 'recordingEnded']);
+  });
+
+  test('a stop waits for the last words five seconds at most', () async {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    final r = make(memory(mic, link));
+    expect(r.session.wait, const Duration(seconds: 5));
+    final quick = RecordingSession(
+      memory(mic, link),
+      onHeard: (_, _) {},
+      onLevel: (_) {},
+      onEnded: () {},
+      wait: const Duration(milliseconds: 200),
+    );
+    await quick.start();
+    final clock = Stopwatch()..start();
+    await quick.stop();
+    expect(clock.elapsedMilliseconds, greaterThanOrEqualTo(200));
+    expect(link.closed, isTrue);
+  });
+
+  test("Soniox's error: the microphone stops, the words stay, its code", () async {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    final r = make(memory(mic, link));
+    await r.session.start();
+    link.reply(reply(done: [tokens[0]]));
+    link.reply('{"error_code":402,"error_message":"x"}');
+    await pumpEventQueue();
+    expect(mic.running, isFalse);
+    expect(r.heard, [(tokens[0], '')]);
+    expect(r.ended, [1]);
+    expect(lines, ['recordingStarted', 'recordingStreamFailed 402', 'recordingEnded']);
+  });
+
+  test('the stream closing early: the microphone stops, its close code', () async {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    final r = make(memory(mic, link));
+    await r.session.start();
+    await link.drop(1011);
+    await pumpEventQueue();
+    expect(mic.running, isFalse);
+    expect(r.ended, [1]);
+    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
+  });
+
+  test('cancel ends at once; a cancel while starting opens nothing', () async {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    final key = Completer<String>();
+    final r = make(memory(mic, link, key: () => key.future));
+    final started = r.session.start();
+    await r.session.cancel();
+    key.complete('k');
+    expect(await started, isFalse);
+    expect(mic.running, isFalse);
+    final r2 = make(memory(SilentMicrophone(), MemoryLink()));
+    await r2.session.start();
+    await r2.session.cancel();
+    expect(r2.ended, [1]);
+  });
+
+  test('end to end on loopback: the door, Soniox, the words', () async {
+    final door = await FakeDoor.start();
+    final soniox = await FakeSoniox.start();
+    addTearDown(door.stop);
+    addTearDown(soniox.stop);
+    soniox.script = (s, message) {
+      if (message is List<int>) s.send(reply(done: [tokens[s.frames.length - 1]]));
+      if (message == '') {
+        s.send(reply(finished: true));
+        s.socket!.close();
+      }
+    };
+    final mic = SilentMicrophone();
+    final r = make(
+      Recording(
+        on: true,
+        microphone: mic,
+        key: () => fetchKey(door.url, beta),
+        connect: (key) => SocketLink.open(soniox.url, key),
+      ),
+    );
+    expect(await r.session.start(), isTrue);
+    for (var i = 0; i < 3; i++) {
+      mic.frame();
+      await Future<void>.delayed(const Duration(milliseconds: 50));
+    }
+    await r.session.stop();
+    expect(soniox.headers['authorization'], ['Bearer temporary-key-in-a-test']);
+    expect(soniox.frames, hasLength(3));
+    expect([for (final h in r.heard) h.$1].join(), tokens.take(3).join());
+    expect(lines, ['recordingStarted', 'recordingEnded']);
+  });
+}
diff --git a/app/test/recording/soniox_test.dart b/app/test/recording/soniox_test.dart
new file mode 100644
index 0000000..0df85e6
--- /dev/null
+++ b/app/test/recording/soniox_test.dart
@@ -0,0 +1,96 @@
+// Soniox's real-time stream (D69; D71 Q8, Q9): the settings exactly, the
+// key in the handshake only, the frames as sent, an empty text frame to
+// finish, and the replies read.
+import 'dart:convert';
+import 'dart:typed_data';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/hosts.dart';
+import 'package:souldreams/recording/soniox.dart';
+
+import 'fakes.dart';
+
+void main() {
+  final tokens = inventedTokens();
+
+  test("the settings: exactly these, English only, stt-rt-v6, no key in them", () {
+    expect(sonioxSettings(), {
+      'model': 'stt-rt-v6',
+      'audio_format': 'pcm_s16le',
+      'sample_rate': 16000,
+      'num_channels': 1,
+      'language_hints': ['en'],
+      'language_hints_strict': true,
+    });
+  });
+
+  test("Soniox's EU real-time endpoint", () {
+    final url = Uri.parse(Hosts.soniox);
+    expect(url.scheme, 'wss');
+    expect(url.host, 'stt-rt.eu.soniox.com');
+    expect(url.path, '/transcribe-websocket');
+  });
+
+  test('final and provisional words, markers dropped', () {
+    final r = readReply(reply(done: [tokens[0], '<fin>'], shown: [tokens[1], tokens[2]]));
+    expect(r, isA<Heard>());
+    r as Heard;
+    expect(r.finalText, tokens[0]);
+    expect(r.provisional, tokens[1] + tokens[2]);
+    expect(r.finished, isFalse);
+    expect((readReply(reply(finished: true)) as Heard).finished, isTrue);
+  });
+
+  test("Soniox's error is its code; an unreadable reply is -1", () {
+    expect((readReply(jsonEncode({'error_code': 402, 'error_message': 'x'})) as Refused).code, 402);
+    expect((readReply('not json') as Refused).code, -1);
+    expect((readReply('[]') as Refused).code, -1);
+    expect((readReply(jsonEncode({'tokens': 'x'})) as Refused).code, -1);
+    expect((readReply(jsonEncode({'tokens': [{'is_final': true}]})) as Refused).code, -1);
+    expect((readReply(jsonEncode({'error_code': 'x'})) as Refused).code, -1);
+  });
+
+  test('the handshake carries the key and names nothing else', () async {
+    final soniox = await FakeSoniox.start();
+    addTearDown(soniox.stop);
+    final link = await SocketLink.open(soniox.url, 'temporary-key-in-a-test');
+    final frame = Uint8List.fromList(List.generate(320, (i) => i % 256));
+    link.add(frame);
+    link.finish();
+    await Future<void>.delayed(const Duration(milliseconds: 200));
+    await link.close();
+    expect(soniox.headers['authorization'], ['Bearer temporary-key-in-a-test']);
+    // As dart:io sends them, with no user agent (R4).
+    expect(soniox.headers.keys.toSet(), {
+      'accept-encoding',
+      'authorization',
+      'cache-control',
+      'connection',
+      'host',
+      'sec-websocket-key',
+      'sec-websocket-version',
+      'upgrade',
+    });
+    expect(soniox.texts.first, jsonEncode(sonioxSettings()));
+    expect(jsonDecode(soniox.texts.first), isNot(contains('api_key')));
+    expect(soniox.frames, [frame]);
+    expect(soniox.texts.last, '');
+    expect(soniox.texts.length, 2);
+  });
+
+  test('replies arrive as text, until Soniox closes', () async {
+    final soniox = await FakeSoniox.start();
+    addTearDown(soniox.stop);
+    soniox.script = (s, message) {
+      if (message == '') {
+        s.send(reply(done: [tokens[0]]));
+        s.send(reply(finished: true));
+        s.socket!.close();
+      }
+    };
+    final link = await SocketLink.open(soniox.url, 'temporary-key-in-a-test');
+    final got = link.replies.toList();
+    link.finish();
+    expect(await got, [reply(done: [tokens[0]]), reply(finished: true)]);
+  });
+}
~~~~

### Task 8 · App: the typing screen as D70 draws it, with the microphone (D70; D71 Q3, Q5, Q7)

`typing_page.dart` rewritten to "The typing screen" (Part 1); `stand_ins.dart` as "The named stand-ins";
`journal_home.dart`, `journal_page.dart` and `night_page.dart` hand an optional `Recording` down. Tests:
`typing_page_test.dart`: D63's layout tests rewritten for the growing field (the three iPhone SE sizes, the scroll,
the failure at the largest text), "the field fills the page" removed, and 13 new.

Expected: 233 app tests. Commit:

> Journal: the typing screen as D70 draws it, and the microphone inside its field (D70; D71)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index 8506da9..cf7c8cc 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -40,12 +40,17 @@ abstract final class StandIns {
   static const double bubbleGap = 12;
 
   /// Inside the typing field, and around the typing screen's parts.
-  static const fieldPadding = EdgeInsets.all(20);
+  static const fieldPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);
   static const double gap = 20;
 
-  /// The least height of the typing field, in lines of the dreamer's text
-  /// at the phone's text size, so it stays usable with the keyboard up (D63).
-  static const int fieldMinLines = 5;
+  /// The typing field grows with its words up to this share of the space
+  /// between Back and the buttons ("most of the screen", D70 2; D71 Q7).
+  static const double fieldCap = 0.7;
+
+  /// While recording: the level line's height, and how many recent
+  /// frames it draws (main-path.md, Recording; D71 Q7).
+  static const double levelHeight = 24;
+  static const int levelFrames = 48;
 
   /// A row's summary: the dreamer's words (type role unset).
   static const summary = TypeRoles.voiceDreamer;
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index f9f7f6e..17a3a8a 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -6,13 +6,14 @@
 import 'package:flutter/material.dart';
 
 import '../../core/safe_log.dart';
+import '../../recording/recording.dart';
 import '../journal.dart';
 import '../journal_files.dart';
 import '../journal_store.dart';
 import 'journal_page.dart';
 
 class JournalHome extends StatefulWidget {
-  const JournalHome({super.key, required this.files, this.after});
+  const JournalHome({super.key, required this.files, this.after, this.recording});
 
   final JournalFiles files;
 
@@ -20,6 +21,9 @@ class JournalHome extends StatefulWidget {
   /// list loaded. Whether it passed or threw, the list follows.
   final Future<Object?>? after;
 
+  /// How to record by voice, or null (D69).
+  final Recording? recording;
+
   @override
   State<JournalHome> createState() => _JournalHomeState();
 }
@@ -47,6 +51,6 @@ class _JournalHomeState extends State<JournalHome> {
   @override
   Widget build(BuildContext context) {
     final journal = _journal;
-    return journal == null ? const Scaffold() : JournalPage(journal: journal);
+    return journal == null ? const Scaffold() : JournalPage(journal: journal, recording: widget.recording);
   }
 }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 35be63a..68179f7 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -12,6 +12,7 @@ import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
+import '../../recording/recording.dart';
 import '../journal.dart';
 import '../night.dart';
 import '../night_rules.dart';
@@ -21,10 +22,13 @@ import 'parts.dart';
 import 'typing_page.dart';
 
 class JournalPage extends StatefulWidget {
-  const JournalPage({super.key, required this.journal});
+  const JournalPage({super.key, required this.journal, this.recording});
 
   final Journal journal;
 
+  /// How to record by voice in the typing screen, or null (D69).
+  final Recording? recording;
+
   @override
   State<JournalPage> createState() => _JournalPageState();
 }
@@ -85,7 +89,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
         SafeLog.event(LogEvent.journalListFailed);
         return;
       }
-      if (mounted) await _push(TypingPage(journal: widget.journal, target: target));
+      if (mounted) await _push(TypingPage(journal: widget.journal, target: target, recording: widget.recording));
     } finally {
       _recording = false;
     }
@@ -98,34 +102,43 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     final year = widget.journal.zone.wall(widget.journal.now()).year;
     return Scaffold(
       body: SafeArea(
-        child: Stack(children: [
-          if (nights != null && nights.isEmpty)
-            Center(
-              child: Padding(
-                padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
-                child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+        child: Stack(
+          children: [
+            if (nights != null && nights.isEmpty)
+              Center(
+                child: Padding(
+                  padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
+                  child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                ),
               ),
+            if (nights != null && nights.isNotEmpty)
+              ListView(
+                padding: const EdgeInsets.fromLTRB(
+                  StandIns.pageSide,
+                  0,
+                  StandIns.pageSide,
+                  StandIns.journalEnd + StandIns.recordHeight + StandIns.recordBelow,
+                ),
+                children: [
+                  for (final item in listItems(nights))
+                    switch (item) {
+                      MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
+                      NightItem(:final night) => _Row(
+                        night,
+                        onTap: () =>
+                            _push(NightPage(journal: widget.journal, id: night.id, recording: widget.recording)),
+                      ),
+                    },
+                ],
+              ),
+            Positioned(
+              left: 0,
+              right: 0,
+              bottom: StandIns.recordBelow,
+              child: Center(child: RecordButton(onPressed: _record)),
             ),
-          if (nights != null && nights.isNotEmpty)
-            ListView(
-              padding: const EdgeInsets.fromLTRB(StandIns.pageSide, 0, StandIns.pageSide,
-                  StandIns.journalEnd + StandIns.recordHeight + StandIns.recordBelow),
-              children: [
-                for (final item in listItems(nights))
-                  switch (item) {
-                    MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
-                    NightItem(:final night) =>
-                      _Row(night, onTap: () => _push(NightPage(journal: widget.journal, id: night.id))),
-                  },
-              ],
-            ),
-          Positioned(
-            left: 0,
-            right: 0,
-            bottom: StandIns.recordBelow,
-            child: Center(child: RecordButton(onPressed: _record)),
-          ),
-        ]),
+          ],
+        ),
       ),
     );
   }
@@ -138,12 +151,9 @@ class _Divider extends StatelessWidget {
 
   @override
   Widget build(BuildContext context) => Padding(
-        padding: const EdgeInsets.only(top: StandIns.dividerAbove, bottom: StandIns.dividerBelow),
-        child: Semantics(
-          header: true,
-          child: Text(text, style: TypeRoles.h4.style(Palette.of(context).text)),
-        ),
-      );
+    padding: const EdgeInsets.only(top: StandIns.dividerAbove, bottom: StandIns.dividerBelow),
+    child: Semantics(header: true, child: Text(text, style: TypeRoles.h4.style(Palette.of(context).text))),
+  );
 }
 
 /// A night's row: an unnamed night's date (h3), or a named night's name
@@ -168,19 +178,22 @@ class _Row extends StatelessWidget {
         child: Container(
           decoration: surface(p),
           padding: StandIns.rowPadding,
-          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
-            if (name == null)
-              Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
-            else ...[
-              Text(name, style: TypeRoles.h5.style(p.text)),
-              Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
+          child: Column(
+            crossAxisAlignment: CrossAxisAlignment.start,
+            children: [
+              if (name == null)
+                Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
+              else ...[
+                Text(name, style: TypeRoles.h5.style(p.text)),
+                Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
+              ],
+              const SizedBox(height: 8),
+              ConstrainedBox(
+                constraints: BoxConstraints(minHeight: lines),
+                child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
+              ),
             ],
-            const SizedBox(height: 8),
-            ConstrainedBox(
-              constraints: BoxConstraints(minHeight: lines),
-              child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
-            ),
-          ]),
+          ),
         ),
       ),
     );
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index 693bab6..e9cce8c 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -16,6 +16,7 @@ import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
 import '../../words/pending.g.dart';
+import '../../recording/recording.dart';
 import '../journal.dart';
 import '../night.dart';
 import '../night_rules.dart';
@@ -24,7 +25,7 @@ import 'parts.dart';
 import 'typing_page.dart';
 
 class NightPage extends StatefulWidget {
-  const NightPage({super.key, required this.journal, required this.id});
+  const NightPage({super.key, required this.journal, required this.id, this.recording});
 
   static const menuKey = Key('night-menu');
   static const deleteKey = Key('night-delete');
@@ -33,6 +34,9 @@ class NightPage extends StatefulWidget {
   final Journal journal;
   final String id;
 
+  /// How to record by voice in the typing screen, or null (D69).
+  final Recording? recording;
+
   @override
   State<NightPage> createState() => _NightPageState();
 }
@@ -68,7 +72,12 @@ class _NightPageState extends State<NightPage> {
 
   Future<void> _type(DreamEdit? edit) async {
     if (_busy) return;
-    final page = TypingPage(journal: widget.journal, target: IntoNight(widget.id), edit: edit);
+    final page = TypingPage(
+      journal: widget.journal,
+      target: IntoNight(widget.id),
+      edit: edit,
+      recording: widget.recording,
+    );
     await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
     await _load();
   }
diff --git a/app/lib/journal/pages/typing_page.dart b/app/lib/journal/pages/typing_page.dart
index 7970591..3de78e3 100644
--- a/app/lib/journal/pages/typing_page.dart
+++ b/app/lib/journal/pages/typing_page.dart
@@ -1,17 +1,26 @@
-// The typing screen (main-path.md, Recording, as P2 to P4, P12 and D58
-// shape it): the top line (MP·10 on first use, MP·32 after), the field
-// only, never tonight's earlier dreams, with MP·12 as its placeholder;
-// Save (MP·13) bottom right; Back (MP·14) top left, which saves just like
-// Save; Save carries a sleeping-person icon (Material's "hotel", a
-// stand-in until the founder's own). The same screen, filled with a dream, edits it (D58 Q4). The
-// keyboard follows the phone's own settings (P12; D57 Q10). Not built:
-// the record button and Start Interpretation. D62: Save, Back, the
-// system's back and the iPhone's edge swipe all go through one _save;
-// when it fails the words and the screen stay, one code is logged, and
-// each of them tries again. D63: the field takes no focus by itself, the
-// page scrolls with the keyboard up, a failed save shows MP·62, and
-// leaving the app (hidden or paused, not inactive) saves what is typed.
+// The typing screen (main-path.md, Recording, as P2 to P4, P12, D58 and
+// D70 shape it): Back (MP·14) top left, which saves just like Save; the
+// instruction (MP·10 on first use, MP·32 after) centred in the button
+// type; the field, a pill with MP·12 as its placeholder and, in a build
+// that records, the microphone inside it (MP·11), growing with its words
+// up to StandIns.fieldCap of the space; then Save (MP·13, with its
+// sleeping-person icon, a stand-in) on the left and Start Interpretation
+// (EM·1) on the right, which does nothing yet (D71 Q3). Never tonight's
+// earlier dreams; the same screen, filled with a dream, edits it (D58
+// Q4). The keyboard follows the phone's own settings (P12; D57 Q10).
+// D62: Save, Back, the system's back and the iPhone's edge swipe all go
+// through one _save; when it fails the words and the screen stay, one
+// code is logged, and each of them tries again. D63: the field takes no
+// focus by itself, a failed save shows MP·62, and leaving the app
+// (hidden or paused, not inactive) saves what is typed. Recording (D69,
+// D71): the words heard are added at the end, never at the caret; while
+// it runs, a level line and a timer show and a screen reader is told
+// MP·33; a stop, Save or Back waits for the last words; leaving the app
+// ends it at once. A failure to start or a break shows nothing new.
+import 'dart:async';
+
 import 'package:flutter/material.dart';
+import 'package:flutter/semantics.dart';
 
 import '../../core/app_line.dart';
 import '../../core/language.dart';
@@ -19,6 +28,8 @@ import '../../core/safe_log.dart';
 import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
+import '../../recording/heard_text.dart';
+import '../../recording/recording.dart';
 import '../../words/lines.g.dart';
 import '../../words/pending.g.dart';
 import '../journal.dart';
@@ -29,10 +40,13 @@ import 'parts.dart';
 typedef DreamEdit = ({String id, int index, String text});
 
 class TypingPage extends StatefulWidget {
-  const TypingPage({super.key, required this.journal, required this.target, this.edit});
+  const TypingPage({super.key, required this.journal, required this.target, this.edit, this.recording});
 
   static const fieldKey = Key('typing-field');
   static const saveKey = Key('typing-save');
+  static const startKey = Key('typing-start');
+  static const micKey = Key('typing-mic');
+  static const levelKey = Key('typing-level');
 
   final Journal journal;
 
@@ -42,17 +56,22 @@ class TypingPage extends StatefulWidget {
   /// The dream being edited, or null for a new one.
   final DreamEdit? edit;
 
+  /// How to record by voice, or null for no microphone.
+  final Recording? recording;
+
   @override
   State<TypingPage> createState() => _TypingPageState();
 }
 
+enum _Mic { idle, starting, recording, stopping }
+
 class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   late final _text = TextEditingController(text: widget.edit?.text);
   bool? _firstUse;
   bool _saving = false;
   bool _failed = false;
-  // MP·62 sits in the scroll area, below the field, so it can never squeeze
-  // the field's window away; a failure scrolls it into view (9c).
+  // MP·62 sits in the instruction's scroll area, so it can never squeeze
+  // the field away; a failure scrolls it into view (9c).
   final _failure = GlobalKey();
 
   // Flutter's own edge swipe is off while this screen's PopScope refuses
@@ -63,6 +82,15 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   static const _swipeFast = 300.0;
   double _swiped = 0;
 
+  // Recording: its state, the provisional words now at the field's end,
+  // the recent levels, and the time it has run.
+  _Mic _mic = _Mic.idle;
+  RecordingSession? _session;
+  String _shown = '';
+  final _levels = <double>[];
+  int _seconds = 0;
+  Timer? _ticker;
+
   @override
   void initState() {
     super.initState();
@@ -90,6 +118,10 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
   @override
   void dispose() {
     WidgetsBinding.instance.removeObserver(this);
+    _ticker?.cancel();
+    final session = _session;
+    _session = null;
+    if (session != null) unawaited(session.cancel());
     _text.dispose();
     super.dispose();
   }
@@ -109,6 +141,14 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
 
   Future<void> _save({bool leaving = false}) async {
     if (_saving) return;
+    // A recording ends first: at once when leaving the app, else with its
+    // last words.
+    final session = _session;
+    if (session != null) {
+      _saving = true;
+      await (leaving ? session.cancel() : session.stop());
+      _saving = false;
+    }
     // Leaving with nothing typed keeps nothing and stays, so an emptied
     // edit never deletes a dream behind the dreamer's back.
     if (leaving && isEmptyText(_text.text)) return;
@@ -134,18 +174,96 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
     if (mounted) Navigator.of(context).pop();
   }
 
+  void _toggleMic() {
+    switch (_mic) {
+      case _Mic.idle:
+        _startRecording();
+      case _Mic.recording:
+        setState(() => _mic = _Mic.stopping);
+        _session?.stop();
+      case _Mic.starting || _Mic.stopping:
+        break;
+    }
+  }
+
+  Future<void> _startRecording() async {
+    final recording = widget.recording;
+    if (recording == null) return;
+    setState(() => _mic = _Mic.starting);
+    final session = RecordingSession(recording, onHeard: _heard, onLevel: _level, onEnded: _ended);
+    _session = session;
+    final started = await session.start();
+    if (!mounted) return;
+    if (!started) {
+      // Nothing new is shown (D71); the session logged its code.
+      _session = null;
+      setState(() => _mic = _Mic.idle);
+      return;
+    }
+    setState(() {
+      _mic = _Mic.recording;
+      _levels.clear();
+      _seconds = 0;
+    });
+    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
+      if (mounted) setState(() => _seconds++);
+    });
+    SemanticsService.sendAnnouncement(View.of(context), Lines.MP_33.text(appLanguage), TextDirection.ltr);
+  }
+
+  // Heard words go at the end of the text, never at the caret (D71 Q6);
+  // a caret at the end stays at the end.
+  void _heard(String finalText, String provisional) {
+    if (!mounted) return;
+    final before = _text.value;
+    final next = withHeard(before.text, _shown, finalText, provisional);
+    _shown = next.shown;
+    final atEnd = !before.selection.isValid ||
+        (before.selection.isCollapsed && before.selection.baseOffset == before.text.length);
+    final selection = atEnd
+        ? TextSelection.collapsed(offset: next.text.length)
+        : TextSelection(
+            baseOffset: before.selection.baseOffset.clamp(0, next.text.length),
+            extentOffset: before.selection.extentOffset.clamp(0, next.text.length),
+          );
+    _text.value = TextEditingValue(text: next.text, selection: selection);
+  }
+
+  void _level(double level) {
+    if (!mounted) return;
+    setState(() {
+      _levels.add(level);
+      if (_levels.length > StandIns.levelFrames) _levels.removeAt(0);
+    });
+  }
+
+  // The recording ended, by a stop or by itself: the words shown stay.
+  void _ended() {
+    _ticker?.cancel();
+    _ticker = null;
+    _session = null;
+    _shown = '';
+    if (mounted) setState(() => _mic = _Mic.idle);
+  }
+
+  String _elapsed() {
+    // Minutes and seconds: digits only, no words.
+    return [(_seconds ~/ 60).toString(), (_seconds % 60).toString().padLeft(2, '0')].join(':');
+  }
+
   @override
   Widget build(BuildContext context) {
     final p = Palette.of(context);
+    final first = _firstUse;
+    final dreamer = TypeRoles.voiceDreamer;
+    // A pill: the corners half the height of one line of the field.
+    final oneLine =
+        MediaQuery.textScalerOf(context).scale(dreamer.size) * dreamer.height + StandIns.fieldPadding.vertical;
     final edge = OutlineInputBorder(
-      borderRadius: BorderRadius.circular(Spacing.radius),
+      borderRadius: BorderRadius.circular(oneLine / 2),
       borderSide: BorderSide(color: p.fieldBorder),
     );
-    final first = _firstUse;
-    final dreamer = TypeRoles.voiceDreamer;
-    final minField =
-        MediaQuery.textScalerOf(context).scale(dreamer.size) * dreamer.height * StandIns.fieldMinLines +
-        StandIns.fieldPadding.vertical;
+    final live = _mic == _Mic.recording || _mic == _Mic.stopping;
     return PopScope(
       canPop: false,
       onPopInvokedWithResult: (didPop, _) {
@@ -165,75 +283,123 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
                       child: BackControl(onPressed: _save),
                     ),
                     Expanded(
-                      // One column, so the field is always built and keeps its
-                      // focus; it fills the page, and no less than its least
-                      // height, and the page scrolls when that does not fit.
                       child: LayoutBuilder(
-                        builder: (context, box) => SingleChildScrollView(
-                          child: ConstrainedBox(
-                            constraints: BoxConstraints(minHeight: box.maxHeight),
-                            child: IntrinsicHeight(
-                              child: Column(
-                                crossAxisAlignment: CrossAxisAlignment.stretch,
-                                children: [
-                                  if (first != null)
-                                    AppLine(
-                                      (first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),
-                                      style: TypeRoles.voiceApp.style(p.text),
-                                    ),
-                                  const SizedBox(height: StandIns.gap),
-                                  Expanded(
-                                    child: ConstrainedBox(
-                                      constraints: BoxConstraints(minHeight: minField),
-                                      child: TextField(
-                                        key: TypingPage.fieldKey,
-                                        controller: _text,
-                                        expands: true,
-                                        maxLines: null,
-                                        keyboardType: TextInputType.multiline,
-                                        textCapitalization: TextCapitalization.sentences,
-                                        textAlignVertical: TextAlignVertical.top,
-                                        style: TypeRoles.voiceDreamer.style(p.fieldText),
-                                        cursorColor: p.fieldText,
-                                        decoration: InputDecoration(
-                                          hintText: Lines.MP_12.text(appLanguage),
-                                          hintStyle: TypeRoles.button.style(p.placeholder),
-                                          filled: true,
-                                          fillColor: p.field,
-                                          contentPadding: StandIns.fieldPadding,
-                                          border: edge,
-                                          enabledBorder: edge,
-                                          focusedBorder: edge,
+                        builder: (context, box) => Column(
+                          crossAxisAlignment: CrossAxisAlignment.stretch,
+                          children: [
+                            Expanded(
+                              child: Center(
+                                child: SingleChildScrollView(
+                                  child: Column(
+                                    mainAxisSize: MainAxisSize.min,
+                                    crossAxisAlignment: CrossAxisAlignment.stretch,
+                                    children: [
+                                      if (first != null)
+                                        AppLine(
+                                          (first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),
+                                          style: TypeRoles.button.style(p.text),
                                         ),
-                                      ),
-                                    ),
+                                      if (_failed)
+                                        Padding(
+                                          key: _failure,
+                                          padding: const EdgeInsets.only(top: StandIns.gap),
+                                          child: Semantics(
+                                            liveRegion: true,
+                                            child: AppLine(
+                                              PendingLines.MP_62.text(appLanguage),
+                                              style: TypeRoles.button.style(p.text),
+                                            ),
+                                          ),
+                                        ),
+                                    ],
                                   ),
-                                  if (_failed)
-                                    Padding(
-                                      key: _failure,
-                                      padding: const EdgeInsets.only(top: StandIns.gap),
-                                      child: Semantics(
-                                        liveRegion: true,
-                                        child: AppLine(
-                                          PendingLines.MP_62.text(appLanguage),
-                                          style: TypeRoles.voiceApp.style(p.text),
+                                ),
+                              ),
+                            ),
+                            if (live)
+                              ExcludeSemantics(
+                                child: Padding(
+                                  padding: const EdgeInsets.only(top: StandIns.gap),
+                                  child: Row(
+                                    key: TypingPage.levelKey,
+                                    children: [
+                                      Expanded(
+                                        child: SizedBox(
+                                          height: StandIns.levelHeight,
+                                          child: CustomPaint(painter: _LevelLine(List.of(_levels), p.text)),
                                         ),
                                       ),
-                                    ),
-                                ],
+                                      const SizedBox(width: 12),
+                                      Text(_elapsed(), style: TypeRoles.button.style(p.text)),
+                                    ],
+                                  ),
+                                ),
+                              ),
+                            const SizedBox(height: StandIns.gap),
+                            ConstrainedBox(
+                              constraints: BoxConstraints(maxHeight: box.maxHeight * StandIns.fieldCap),
+                              child: TextField(
+                                key: TypingPage.fieldKey,
+                                controller: _text,
+                                minLines: 1,
+                                maxLines: null,
+                                keyboardType: TextInputType.multiline,
+                                textCapitalization: TextCapitalization.sentences,
+                                style: TypeRoles.voiceDreamer.style(p.fieldText),
+                                cursorColor: p.fieldText,
+                                decoration: InputDecoration(
+                                  hintText: Lines.MP_12.text(appLanguage),
+                                  hintStyle: TypeRoles.button.style(p.placeholder),
+                                  filled: true,
+                                  fillColor: p.field,
+                                  contentPadding: StandIns.fieldPadding,
+                                  border: edge,
+                                  enabledBorder: edge,
+                                  focusedBorder: edge,
+                                  suffixIcon: widget.recording == null
+                                      ? null
+                                      : IconButton(
+                                          key: TypingPage.micKey,
+                                          tooltip: Lines.MP_11.text(appLanguage),
+                                          isSelected: live,
+                                          onPressed: _toggleMic,
+                                          icon: Icon(Icons.mic_none, color: p.placeholder),
+                                          selectedIcon: Icon(Icons.stop_rounded, color: p.fieldText),
+                                        ),
+                                ),
                               ),
                             ),
-                          ),
+                          ],
                         ),
                       ),
                     ),
                     const SizedBox(height: StandIns.gap),
-                    Align(
-                      alignment: Alignment.centerRight,
-                      child: KeyedSubtree(
-                        key: TypingPage.saveKey,
-                        child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
-                      ),
+                    // At large text the two pills shrink their words to stay on
+                    // one row, as the record button does (Task 15a).
+                    Row(
+                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
+                      children: [
+                        Flexible(
+                          child: FittedBox(
+                            fit: BoxFit.scaleDown,
+                            child: KeyedSubtree(
+                              key: TypingPage.saveKey,
+                              child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
+                            ),
+                          ),
+                        ),
+                        const SizedBox(width: StandIns.gap),
+                        Flexible(
+                          child: FittedBox(
+                            fit: BoxFit.scaleDown,
+                            child: KeyedSubtree(
+                              key: TypingPage.startKey,
+                              // Nothing to start yet: the readings come later (D71 Q3).
+                              child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),
+                            ),
+                          ),
+                        ),
+                      ],
                     ),
                     const SizedBox(height: StandIns.gap),
                   ],
@@ -260,3 +426,30 @@ class _TypingPageState extends State<TypingPage> with WidgetsBindingObserver {
     );
   }
 }
+
+/// The level line: one bar a frame, newest on the right, as loud as the
+/// frame was (a stand-in, D71 Q7).
+class _LevelLine extends CustomPainter {
+  _LevelLine(this.levels, this.colour);
+
+  final List<double> levels;
+  final Color colour;
+
+  @override
+  void paint(Canvas canvas, Size size) {
+    final paint = Paint()
+      ..color = colour
+      ..strokeWidth = 2
+      ..strokeCap = StrokeCap.round;
+    final step = size.width / StandIns.levelFrames;
+    final middle = size.height / 2;
+    for (var i = 0; i < levels.length; i++) {
+      final x = size.width - (levels.length - i - 0.5) * step;
+      final half = (levels[i] * size.height / 2).clamp(1.0, middle);
+      canvas.drawLine(Offset(x, middle - half), Offset(x, middle + half), paint);
+    }
+  }
+
+  @override
+  bool shouldRepaint(_LevelLine old) => true;
+}
diff --git a/app/test/journal/pages/typing_page_test.dart b/app/test/journal/pages/typing_page_test.dart
index 781a68a..1fa85b4 100644
--- a/app/test/journal/pages/typing_page_test.dart
+++ b/app/test/journal/pages/typing_page_test.dart
@@ -1,6 +1,7 @@
-// The typing screen (P2 to P4, P10, P12; D58 Q4): the field only, MP·12
-// as its placeholder, MP·10 once then MP·32; Save and Back keep the text
-// as a new dream; an empty Save keeps nothing; an edit replaces.
+// The typing screen (P2 to P4, P10, P12; D58 Q4; D70; D71): the field
+// only, MP·12 as its placeholder, MP·10 once then MP·32; Save and Back
+// keep the text as a new dream; an empty Save keeps nothing; an edit
+// replaces; recording adds the words heard at the end.
 import 'dart:async';
 import 'dart:io';
 import 'dart:typed_data';
@@ -10,13 +11,17 @@ import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/core/app_line.dart';
 import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/design/tokens.g.dart';
 import 'package:souldreams/journal/night_rules.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
+import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/words/lines.g.dart';
 import 'package:souldreams/words/pending.g.dart';
 
 import '../../fixtures.dart';
 import '../memory_journal_files.dart';
+import '../../recording/fakes.dart';
 import '../zones.dart';
 import 'harness.dart';
 
@@ -387,14 +392,16 @@ void main() {
       await se(tester, scale: scale);
       final h = await open(tester);
       expect(tester.takeException(), isNull);
-      expect(tester.getSize(find.byKey(TypingPage.fieldKey)).height, greaterThanOrEqualTo(100 * scale));
-      // The window the field shows in stays usable, not only the field's own height.
-      expect(tester.getSize(find.byType(SingleChildScrollView)).height, greaterThanOrEqualTo(100));
+      expect(find.byKey(TypingPage.fieldKey).hitTestable(), findsOneWidget);
+      expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
+      expect(find.byKey(TypingPage.startKey).hitTestable(), findsOneWidget);
+      await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0] * 6);
+      await tester.pumpAndSettle();
+      expect(tester.takeException(), isNull);
       expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
-      await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
       await tester.tap(find.byKey(TypingPage.saveKey));
       await tester.pumpAndSettle();
-      expect((await h.nights()).single.dreams, [dreams[0]]);
+      expect((await h.nights()).single.dreams, [dreams[0] * 6]);
     });
   }
 
@@ -405,8 +412,8 @@ void main() {
     expect(tester.getRect(find.byType(AppLine)).top, greaterThanOrEqualTo(tester.getRect(area).top));
     await tester.drag(area, const Offset(0, -6000));
     await tester.pumpAndSettle();
-    expect(tester.getRect(find.byType(AppLine)).bottom, lessThanOrEqualTo(tester.getRect(area).top));
-    expect(tester.getRect(find.byKey(TypingPage.fieldKey)).bottom, lessThanOrEqualTo(tester.getRect(area).bottom + 1));
+    expect(tester.getRect(find.byType(AppLine)).top, lessThan(tester.getRect(area).top - 100));
+    expect(find.byKey(TypingPage.fieldKey).hitTestable(), findsOneWidget);
     expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
   });
 
@@ -503,9 +510,9 @@ void main() {
     expect(await h.nights(), isEmpty);
   });
 
-  // 9c (the review of 9b): MP·62 sits in the scroll area, so it can never
-  // squeeze the field's window away.
-  testWidgets('a failure at largest text keeps a window, shows MP·62', (tester) async {
+  // 9c (the review of 9b): MP·62 sits in the instruction's scroll area,
+  // so it can never squeeze the field away.
+  testWidgets('a failure at largest text keeps the field, shows MP·62', (tester) async {
     await se(tester, scale: 3.1);
     final files = FlakyFiles();
     await open(tester, files: files);
@@ -515,11 +522,10 @@ void main() {
     await tester.pumpAndSettle();
     expect(tester.takeException(), isNull);
     final area = tester.getRect(find.byType(SingleChildScrollView));
-    expect(area.height, greaterThanOrEqualTo(100));
-    final line = tester.getRect(find.byType(AppLine).last);
-    expect(line.top, greaterThanOrEqualTo(area.top));
-    expect(line.bottom, lessThanOrEqualTo(area.bottom));
+    // Scrolled to its top (its padding first), the instruction above it out of sight.
+    expect(tester.getRect(find.byType(AppLine).last).top, closeTo(area.top + StandIns.gap, 1));
     expect(find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en)), findsOneWidget);
+    expect(find.byKey(TypingPage.fieldKey).hitTestable(), findsOneWidget);
     expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
   });
 
@@ -546,17 +552,207 @@ void main() {
     expect((await h.nights()).single.dreams, [dreams[0]]);
   });
 
-  testWidgets('the field fills the page when there is room', (tester) async {
+  // D70 (head's message 20, Product message 19; D71).
+  Future<Harness> tall(WidgetTester tester, {Recording? recording}) async {
     tester.view.devicePixelRatio = 2;
     tester.view.physicalSize = const Size(786, 1704);
     addTearDown(tester.view.reset);
     final h = await Harness.make();
     await h.journal.markFirstUseSeen();
-    await h.pump(tester, Opener(() async => TypingPage(journal: h.journal, target: await h.journal.targetNow())));
+    await h.pump(
+      tester,
+      Opener(() async => TypingPage(journal: h.journal, target: await h.journal.targetNow(), recording: recording)),
+    );
     await tester.tap(find.byKey(Opener.openKey));
     await tester.pumpAndSettle();
-    final area = tester.getRect(find.byType(SingleChildScrollView));
-    expect(tester.getRect(find.byKey(TypingPage.fieldKey)).bottom, closeTo(area.bottom, 1));
+    return h;
+  }
+
+  testWidgets('one line, growing with its words to 0.7 at most', (tester) async {
+    await tall(tester);
+    final field = find.byKey(TypingPage.fieldKey);
+    final one = tester.getSize(field).height;
+    expect(one, lessThan(80));
+    final space = tester.getRect(find.byKey(TypingPage.saveKey)).top - StandIns.gap -
+        tester.getRect(find.byKey(BackControl.buttonKey)).bottom;
+    await tester.enterText(field, '${dreams[0]}\n${dreams[1]}');
+    await tester.pumpAndSettle();
+    expect(tester.getSize(field).height, greaterThan(one));
+    expect(tester.getSize(field).height, lessThan(space * StandIns.fieldCap));
+    await tester.enterText(field, List.filled(12, dreams[0]).join('\n'));
+    await tester.pumpAndSettle();
+    expect(tester.getSize(field).height, closeTo(space * StandIns.fieldCap, 1));
+    expect(tester.takeException(), isNull);
+  });
+
+  testWidgets('the instruction is centred, in the button type', (tester) async {
+    await tall(tester);
+    final line = tester.widget<AppLine>(find.byType(AppLine));
+    expect(line.textAlign, TextAlign.center);
+    expect(line.style.fontFamily, TypeRoles.button.style(Colors.black).fontFamily);
+    expect(line.style.fontSize, TypeRoles.button.size);
+  });
+
+  testWidgets('Save on the left, Start Interpretation on the right', (tester) async {
+    await tall(tester);
+    final save = tester.getRect(find.byKey(TypingPage.saveKey));
+    final start = tester.getRect(find.byKey(TypingPage.startKey));
+    expect(find.text(Lines.EM_1.text(Lang.en)), findsOneWidget);
+    expect(save.left, closeTo(StandIns.pageSide, 1));
+    expect(start.right, closeTo(393 - StandIns.pageSide, 1));
+    expect(save.center.dy, closeTo(start.center.dy, 1));
+  });
+
+  testWidgets('Start Interpretation does nothing yet (D71 Q3)', (tester) async {
+    final h = await tall(tester);
+    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
+    await tester.tap(find.byKey(TypingPage.startKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsOneWidget);
+    expect(await h.nights(), isEmpty);
+  });
+
+  testWidgets('no microphone in a build that does not record', (tester) async {
+    await tall(tester);
+    expect(find.byKey(TypingPage.micKey), findsNothing);
+  });
+
+  // Recording (D69, as D71 corrects it), on a microphone of silence and a
+  // stream held in memory.
+  ({SilentMicrophone mic, MemoryLink link, Recording recording}) voice({bool on = true}) {
+    final mic = SilentMicrophone();
+    final link = MemoryLink();
+    return (
+      mic: mic,
+      link: link,
+      recording: Recording(on: on, microphone: mic, key: () async => 'k', connect: (_) async => link),
+    );
+  }
+
+  Future<void> record(WidgetTester tester) async {
+    await tester.tap(find.byKey(TypingPage.micKey));
+    await tester.pump();
+    await tester.pump();
+  }
+
+  final tokens = inventedTokens();
+
+  testWidgets('words appear as they are heard; Save keeps them', (tester) async {
+    final lines = await logged();
+    final v = voice();
+    final h = await tall(tester, recording: v.recording);
+    await record(tester);
+    expect(v.mic.running, isTrue);
+    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
+    await tester.pump();
+    expect(find.text(tokens[0] + tokens[1]), findsOneWidget);
+    v.link.reply(reply(done: [tokens[1], tokens[2]]));
+    await tester.pump();
+    expect(find.text(tokens.take(3).join()), findsOneWidget);
+    await tester.tap(find.byKey(TypingPage.saveKey));
+    await tester.pump();
+    expect(v.mic.running, isFalse);
+    expect(v.link.sent.last, '');
+    v.link.reply(reply(done: [tokens[3]]));
+    v.link.reply(reply(finished: true));
+    await tester.pumpAndSettle();
+    expect(find.byType(TypingPage), findsNothing);
+    expect((await h.nights()).single.dreams, [tokens.take(4).join()]);
+    expect(lines, ['recordingStarted', 'recordingEnded']);
+  });
+
+  testWidgets('heard words go at the end, never at the caret', (tester) async {
+    final v = voice();
+    await tall(tester, recording: v.recording);
+    final typed = dreams[1];
+    await tester.enterText(find.byKey(TypingPage.fieldKey), typed);
+    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
+    field.controller!.selection = const TextSelection.collapsed(offset: 4);
+    await record(tester);
+    v.link.reply(reply(done: [tokens[0]]));
+    await tester.pump();
+    expect(field.controller!.text, '$typed ${tokens[0]}');
+    expect(field.controller!.selection, const TextSelection.collapsed(offset: 4));
+  });
+
+  testWidgets('MP·33 is told once; the level line and the timer show', (tester) async {
+    final v = voice();
+    await tall(tester, recording: v.recording);
+    tester.takeAnnouncements();
+    expect(find.byKey(TypingPage.levelKey), findsNothing);
+    await record(tester);
+    expect([for (final a in tester.takeAnnouncements()) a.message], [Lines.MP_33.text(Lang.en)]);
+    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
+    v.mic.frame(16384);
+    await tester.pump(const Duration(seconds: 2));
+    expect(find.text('0:02'), findsOneWidget);
+    await tester.tap(find.byKey(TypingPage.micKey));
+    await tester.pump();
+    v.link.reply(reply(finished: true));
+    await tester.pumpAndSettle();
+    expect(find.byKey(TypingPage.levelKey), findsNothing);
+    expect(v.mic.running, isFalse);
+    expect(tester.takeAnnouncements(), isEmpty);
+  });
+
+  testWidgets('a refused microphone shows nothing new, logs a code', (tester) async {
+    final lines = await logged();
+    final v = voice();
+    v.mic.allow = false;
+    await tall(tester, recording: v.recording);
+    await record(tester);
+    await tester.pumpAndSettle();
+    expect(find.byKey(TypingPage.levelKey), findsNothing);
+    expect(tester.takeAnnouncements(), isEmpty);
+    expect(lines, ['recordingRefused']);
+  });
+
+  testWidgets('recording off: the microphone starts nothing', (tester) async {
+    final lines = await logged();
+    final v = voice(on: false);
+    await tall(tester, recording: v.recording);
+    await record(tester);
+    expect(v.mic.running, isFalse);
+    expect(lines, ['recordingOff']);
+  });
+
+  testWidgets('a broken stream stops, keeping the words shown', (tester) async {
+    final lines = await logged();
+    final v = voice();
+    await tall(tester, recording: v.recording);
+    await record(tester);
+    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
+    await tester.pump();
+    await v.link.drop(1011);
+    await tester.pumpAndSettle();
+    expect(v.mic.running, isFalse);
+    expect(find.byKey(TypingPage.levelKey), findsNothing);
+    expect(find.text(tokens[0] + tokens[1]), findsOneWidget);
+    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
+  });
+
+  testWidgets('leaving the app while recording ends it and saves the words', (tester) async {
+    final v = voice();
+    final h = await tall(tester, recording: v.recording);
+    await record(tester);
+    v.link.reply(reply(done: [tokens[0]]));
+    await tester.pump();
+    await leave(tester, AppLifecycleState.hidden);
+    expect(v.mic.running, isFalse);
+    expect(v.link.closed, isTrue);
+    expect(find.byType(TypingPage), findsNothing);
+    expect((await h.nights()).single.dreams, [tokens[0]]);
+  });
+
+  testWidgets('Back while recording waits for the last words, then saves', (tester) async {
+    final v = voice();
+    final h = await tall(tester, recording: v.recording);
+    await record(tester);
+    await tester.tap(find.byKey(BackControl.buttonKey));
+    await tester.pump();
+    v.link.reply(reply(done: [tokens[0]], finished: true));
+    await tester.pumpAndSettle();
+    expect((await h.nights()).single.dreams, [tokens[0]]);
   });
 
   // D71 Q18: the first-use read or mark failing.
~~~~

### Task 9 · [OWNER] `record` 7.1.2 (D71 Q14)

Paste 1 — Terminal
```
cd ~/Developer/soul-dreams-app/app && fvm flutter pub add record:7.1.2 && git diff --stat pubspec.yaml pubspec.lock && grep -A3 -E '^  record' pubspec.lock
```

Expected:
- `pubspec.yaml | 1 +`: `record: 7.1.2` under `dependencies`;
- `pubspec.lock` gains `record` 7.1.2 (`direct main`) and its platform packages: `record_platform_interface`,
  `record_darwin` and the Android, Linux, web and Windows ones, which build nothing for iOS;
- any other changed package, or a `record` other than 7.1.2: stop and bring the output.

Then Claude Code reads the installed `record_darwin`'s stream path in the pub cache before Task 10:
- in stream mode no file is written;
- `IosRecordConfig(categoryOptions: [])` is accepted;
- `hasPermission()` asks the first time.

Anything else: stop. The proof used a stand-in of `record`'s API (Part 5).

### Task 10 · App: the microphone, and SoulDreams Dev's wiring (D71 Q14 to Q16)

New: `lib/recording/record_microphone.dart`. `main_dev.dart` builds `Recording.live(microphone: RecordMicrophone(),
betaKey: const String.fromEnvironment('BETA_KEY'))` and hands it to `JournalHome`. Tests:
- `dev_only_test.dart`: `main.dart` and `main_founder.dart` reach no file in `lib/recording/`;
- `no_storage_test.dart` (3, new);
- `journal_home_test.dart` (the wiring).

Expected: 236 app tests. Commit, with the owner's `pubspec.yaml` and `pubspec.lock`:

> Recording: the microphone through record 7.1.2, in SoulDreams Dev only (D71 Q14 to Q16)

**The block:**

~~~~diff
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
index f0846e5..85951e0 100644
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -11,6 +11,8 @@ import 'core/safe_log.dart';
 import 'journal/channel_journal_files.dart';
 import 'journal/pages/journal_home.dart';
 import 'journal/self_check.dart';
+import 'recording/record_microphone.dart';
+import 'recording/recording.dart';
 
 void main() {
   requireFlavour(Flavour.dev);
@@ -20,13 +22,16 @@ void main() {
   // (D65), so its probe never shows as a row.
   const files = ChannelJournalFiles();
   final check = const bool.fromEnvironment('JOURNAL_SELF_CHECK') ? journalSelfCheck(files, files) : null;
+  // Recording by voice (D69, D71): the beta key comes from the owner's
+  // file through --dart-define-from-file (R5); with none, recording is off.
+  final recording = Recording.live(microphone: RecordMicrophone(), betaKey: const String.fromEnvironment('BETA_KEY'));
   // The keyboard check (D50 1): only in a build made with
   // --dart-define=KEYBOARD_CHECK=true.
   runApp(
     SoulDreamsApp(
       home: const bool.fromEnvironment('KEYBOARD_CHECK')
           ? const KeyboardCheck()
-          : JournalHome(files: files, after: check),
+          : JournalHome(files: files, after: check, recording: recording),
     ),
   );
   if (check != null) unawaited(check);
diff --git a/app/lib/recording/record_microphone.dart b/app/lib/recording/record_microphone.dart
new file mode 100644
index 0000000..dfb4547
--- /dev/null
+++ b/app/lib/recording/record_microphone.dart
@@ -0,0 +1,32 @@
+// The phone's microphone through the `record` package (D71 Q14, exactly
+// 7.1.2): its stream of sixteen-bit PCM at 16 kHz, one channel, handed on
+// as it comes. In stream mode the package writes no file. The built-in
+// microphone only: no Bluetooth route and no speaker setting (D71 Q15).
+// The phone asks the dreamer the first time, with EM·3.
+import 'dart:typed_data';
+
+import 'package:record/record.dart';
+
+import 'microphone.dart';
+
+final class RecordMicrophone implements Microphone {
+  final _recorder = AudioRecorder();
+
+  @override
+  Future<bool> allowed() => _recorder.hasPermission();
+
+  @override
+  Future<Stream<Uint8List>> start() => _recorder.startStream(
+    const RecordConfig(
+      encoder: AudioEncoder.pcm16bits,
+      sampleRate: sampleRate,
+      numChannels: 1,
+      iosConfig: IosRecordConfig(categoryOptions: []),
+    ),
+  );
+
+  @override
+  Future<void> stop() async {
+    await _recorder.stop();
+  }
+}
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
index 6649941..3ca16fb 100644
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -59,10 +59,11 @@ void main() {
   const pending = 'lib/words/pending.g.dart';
 
   for (final entry in ['lib/main.dart', 'lib/main_founder.dart']) {
-    test('$entry reaches no journal code and no pending line', () {
+    test('$entry reaches no journal or recording code, no pending line', () {
       final files = reached(entry);
       expect(files, contains('lib/app.dart'));
       expect(files.where((f) => f.startsWith('lib/journal/')), isEmpty);
+      expect(files.where((f) => f.startsWith('lib/recording/')), isEmpty);
       expect(files, isNot(contains(pending)));
     });
   }
@@ -72,6 +73,7 @@ void main() {
     expect(files, contains('lib/journal/pages/journal_page.dart'));
     expect(files, contains('lib/journal/pages/night_page.dart'));
     expect(files, contains(pending));
+    expect(files, contains('lib/recording/record_microphone.dart'));
   });
 
   test('the walk follows relative and package imports', () {
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index f2c1af4..83c0738 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -75,9 +75,10 @@ void main() {
     expect(find.byType(JournalPage), findsOneWidget);
   });
 
-  test('SoulDreams Dev hands its phone check to the list', () {
+  test('SoulDreams Dev hands its phone check and recording to the list', () {
     final text = File('lib/main_dev.dart').readAsStringSync();
-    expect(text, contains('JournalHome(files: files, after: check)'));
+    expect(text, contains('JournalHome(files: files, after: check, recording: recording)'));
+    expect(text, contains("betaKey: const String.fromEnvironment('BETA_KEY')"));
   });
 
   testWidgets('a folder that cannot open: a blank page, a code', (tester) async {
diff --git a/app/test/recording/no_storage_test.dart b/app/test/recording/no_storage_test.dart
new file mode 100644
index 0000000..8eb025c
--- /dev/null
+++ b/app/test/recording/no_storage_test.dart
@@ -0,0 +1,46 @@
+// The audio is never kept on the phone (D69, as D71 corrects it, for this
+// slice): nothing in lib/recording/ can write a file, and only the
+// microphone's own file reaches the `record` package. A floor, read from
+// the source; the owner's phone check looks in the app's container.
+import 'dart:io';
+
+import 'package:flutter_test/flutter_test.dart';
+
+final _storage = RegExp(
+  r'\b(File|Directory|RandomAccessFile|IOSink|Link)\b|path_provider|getTemporaryDirectory|writeAs|openWrite|startFile|RecordConfig\(\s*\)',
+);
+
+void main() {
+  final files = Directory('lib/recording').listSync().whereType<File>().where((f) => f.path.endsWith('.dart')).toList();
+
+  test('the recording files are these', () {
+    expect(files.map((f) => f.uri.pathSegments.last).toSet(), {
+      'heard_text.dart',
+      'key_client.dart',
+      'microphone.dart',
+      'record_microphone.dart',
+      'recording.dart',
+      'soniox.dart',
+    });
+  });
+
+  test('nothing in lib/recording/ names a file or a folder', () {
+    for (final f in files) {
+      expect(_storage.hasMatch(f.readAsStringSync()), isFalse, reason: f.path);
+    }
+  });
+
+  test('only the microphone file uses the record package, in stream mode', () {
+    for (final f in Directory(
+      'lib',
+    ).listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'))) {
+      final text = f.readAsStringSync();
+      final uses = text.contains('package:record/');
+      expect(uses, f.path.endsWith('lib/recording/record_microphone.dart'), reason: f.path);
+    }
+    final mic = File('lib/recording/record_microphone.dart').readAsStringSync();
+    expect(mic, contains('startStream('));
+    expect(mic, isNot(contains('.start(')));
+    expect(mic, contains('categoryOptions: []'));
+  });
+}
~~~~

### Task 11 · App: the mutation rows A40 to A67

`tool/app_mutations.py`: rows A24g, A24h, A24p, A24q, A24r, A24y, A24z, A24an, A24ap and A39 follow the code and
names they break; A40 to A67 are new.

Run from the repository root: `python3 -I -B tool/app_mutations.py`. Expected: `app mutations: 114 run, 114 caught`.
It takes about half an hour. Commit:

> Tools: the app's mutation rows for recording and the typing screen (A40 to A67)

**The block:**

~~~~diff
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index d73576e..de646c2 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,8 +1,8 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
-# Expected: every row "caught" (A1 to A39, with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A67, with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 86 run, 86 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 114 run, 114 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -181,12 +181,12 @@ ROWS = [
     # Task 9a (D62): a failed save, the edge swipe, the double tap, the
     # keyboard, the edit's place
     ('A24g', 'lib/journal/pages/typing_page.dart',
-     '      _saving = false;\n',
-     '',
+     '      SafeLog.event(LogEvent.journalSaveFailed);\n      _saving = false;\n',
+     '      SafeLog.event(LogEvent.journalSaveFailed);\n',
      'test/journal/pages/typing_page_test.dart', 'a failed Save stays on the screen; Save again keeps it'),
     ('A24h', 'lib/journal/pages/typing_page.dart',
-     '} on Object {',
-     '} on StateError {',
+     '    } on Object {\n      SafeLog.event(LogEvent.journalSaveFailed);',
+     '    } on StateError {\n      SafeLog.event(LogEvent.journalSaveFailed);',
      'test/journal/pages/typing_page_test.dart', 'a failed Save stays on the screen; Save again keeps it'),
     ('A24i', 'lib/journal/pages/typing_page.dart',
      '      SafeLog.event(LogEvent.journalSaveFailed);\n',
@@ -219,16 +219,16 @@ ROWS = [
     # Task 9b (D63): no automatic focus, a page that scrolls, MP·62, and a
     # save when the app is left
     ('A24p', 'lib/journal/pages/typing_page.dart',
-     'expands: true,',
-     'expands: true, autofocus: true,',
+     'minLines: 1,',
+     'minLines: 1, autofocus: true,',
      'test/journal/pages/typing_page_test.dart', 'the field takes no focus; a tap brings the keyboard'),
     ('A24q', 'lib/journal/pages/typing_page.dart',
-     'constraints: BoxConstraints(minHeight: minField),',
+     'constraints: BoxConstraints(maxHeight: box.maxHeight * StandIns.fieldCap),',
      'constraints: const BoxConstraints(),',
-     'test/journal/pages/typing_page_test.dart', 'an iPhone SE, keyboard up at 1.0x: no overflow, Save reachable'),
+     'test/journal/pages/typing_page_test.dart', 'an iPhone SE, keyboard up at 3.1x: no overflow, Save reachable'),
     ('A24r', 'lib/journal/pages/typing_page.dart',
-     'builder: (context, box) => SingleChildScrollView(',
-     'builder: (context, box) => SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),',
+     'child: SingleChildScrollView(',
+     'child: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),',
      'test/journal/pages/typing_page_test.dart', 'with the keyboard up, MP·10 scrolls away and the field stays'),
     ('A24s', 'lib/journal/pages/typing_page.dart',
      'PendingLines.MP_62.text(appLanguage)',
@@ -256,13 +256,13 @@ ROWS = [
      '',
      'test/journal/pages/typing_page_test.dart', 'MP·62 goes during a retry and stays if it fails'),
     ('A24y', 'lib/journal/pages/typing_page.dart',
-     'constraints: BoxConstraints(minHeight: box.maxHeight),',
-     'constraints: const BoxConstraints(),',
-     'test/journal/pages/typing_page_test.dart', 'the field fills the page when there is room'),
+     'box.maxHeight * StandIns.fieldCap',
+     'box.maxHeight * 0.9',
+     'test/journal/pages/typing_page_test.dart', 'one line, growing with its words to 0.7 at most'),
     ('A24z', 'lib/journal/pages/typing_page.dart',
      'if (mounted && line != null) Scrollable.ensureVisible(line);',
      '',
-     'test/journal/pages/typing_page_test.dart', 'a failure at largest text keeps a window, shows MP·62'),
+     'test/journal/pages/typing_page_test.dart', 'a failure at largest text keeps the field, shows MP·62'),
     # Task 10a (D64): a failed delete or read, a delete in flight, semantics
     ('A24aa', 'lib/journal/pages/night_page.dart',
      '    } on Object {\n      SafeLog.event(LogEvent.journalDeleteFailed);',
@@ -320,15 +320,15 @@ ROWS = [
     ('A24an', 'lib/core/night_day.dart',
      "import 'package:flutter/material.dart';",
      "import 'package:flutter/material.dart';\nimport \"../journal/journal.dart\";",
-     'test/dev_only_test.dart', 'lib/main.dart reaches no journal code and no pending line'),
+     'test/dev_only_test.dart', 'lib/main.dart reaches no journal or recording code, no pending line'),
     ('A24ao', 'lib/journal/pages/journal_home.dart',
      '      await widget.after;\n',
      '',
      'test/journal/pages/journal_home_test.dart', 'the list waits for the phone check, then shows'),
     ('A24ap', 'lib/main_dev.dart',
-     'JournalHome(files: files, after: check)',
-     'JournalHome(files: files)',
-     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check to the list'),
+     'JournalHome(files: files, after: check, recording: recording)',
+     'JournalHome(files: files, recording: recording)',
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A24aq', 'lib/journal/pages/journal_home.dart',
      '      await widget.after;\n    } on Object {',
      '      await widget.after;\n    } on ArgumentError {',
@@ -419,7 +419,121 @@ ROWS = [
     ('A39', 'lib/main.dart',
      "import 'core/safe_log.dart';\n",
      "import 'core/safe_log.dart';\nimport 'journal/journal.dart';\n",
-     'test/dev_only_test.dart', 'lib/main.dart reaches no journal code and no pending line'),
+     'test/dev_only_test.dart', 'lib/main.dart reaches no journal or recording code, no pending line'),
+    # The recording branch (D69 to D71): the read failures, recording's
+    # core, the typing screen under D70, the microphone and Dev's wiring.
+    ('A40', 'lib/journal/pages/journal_page.dart',
+     '      nights = await widget.journal.newestFirst();\n    } on Object {\n      SafeLog.event(LogEvent.journalListFailed);\n',
+     '      nights = await widget.journal.newestFirst();\n    } on Object {\n',
+     'test/journal/pages/journal_page_test.dart', 'a failed load keeps the rows shown and logs a code'),
+    ('A41', 'lib/journal/pages/journal_page.dart',
+     '        // Nothing opens; a code is logged (D71 Q18).\n        SafeLog.event(LogEvent.journalListFailed);\n',
+     '',
+     'test/journal/pages/journal_page_test.dart', 'a failed read at the record button opens nothing'),
+    ('A42', 'lib/journal/pages/typing_page.dart',
+     '        if (mounted) setState(() => _firstUse = false);',
+     '        if (mounted) setState(() => _firstUse = true);',
+     'test/journal/pages/typing_page_test.dart', 'a failed first-use read shows MP·32, marks nothing, logs a code'),
+    ('A43', 'lib/journal/pages/typing_page.dart',
+     '          } on Object {\n            SafeLog.event(LogEvent.firstUseReadFailed);\n',
+     '          } on Object {\n',
+     'test/journal/pages/typing_page_test.dart', 'a failed first-use mark still shows MP·10, logs a code'),
+    ('A44', 'lib/recording/key_client.dart',
+     '    ..userAgent = null\n',
+     '',
+     'test/recording/key_client_test.dart', 'one POST, no body, the beta key, no user agent'),
+    ('A45', 'lib/recording/soniox.dart',
+     'final client = HttpClient()..userAgent = null;',
+     'final client = HttpClient();',
+     'test/recording/soniox_test.dart', 'the handshake carries the key and names nothing else'),
+    ('A46', 'lib/recording/soniox.dart',
+     "  'language_hints_strict': true,\n",
+     '',
+     'test/recording/soniox_test.dart', 'the settings: exactly these, English only, stt-rt-v6, no key in them'),
+    ('A47', 'lib/recording/soniox.dart',
+     "void finish() => _socket.add('');",
+     'void finish() => _socket.add(Uint8List(0));',
+     'test/recording/soniox_test.dart', 'the handshake carries the key and names nothing else'),
+    ('A48', 'lib/recording/soniox.dart',
+     '    if (_markers.contains(word.trim())) continue;\n',
+     '',
+     'test/recording/soniox_test.dart', 'final and provisional words, markers dropped'),
+    ('A49', 'lib/recording/heard_text.dart',
+     '? text.substring(0, text.length - shown.length) : text;',
+     '? text : text;',
+     'test/recording/heard_text_test.dart', 'provisional words are replaced, never doubled'),
+    ('A50', 'lib/recording/heard_text.dart',
+     "  return '$base $add';",
+     '  return base + add;',
+     'test/recording/heard_text_test.dart', 'after typed words, one space joins them'),
+    ('A51', 'lib/recording/recording.dart',
+     '    if (!allowed) return _fail(LogEvent.recordingRefused);\n',
+     '',
+     'test/recording/recording_test.dart', 'the microphone refused: no key asked, a code'),
+    ('A52', 'lib/recording/recording.dart',
+     '      await _finished.future.timeout(wait, onTimeout: () {});\n',
+     '',
+     'test/recording/recording_test.dart', 'words come back; a stop waits for the last ones'),
+    ('A53', 'lib/recording/recording.dart',
+     'SafeLog.event(LogEvent.recordingStreamFailed, [code]);',
+     'SafeLog.event(LogEvent.recordingStreamFailed);',
+     'test/recording/recording_test.dart', "Soniox's error: the microphone stops, the words stay, its code"),
+    ('A54', 'lib/recording/recording.dart',
+     'on: server.isNotEmpty && _betaShape.hasMatch(betaKey),',
+     'on: server.isNotEmpty,',
+     'test/recording/recording_test.dart', 'live: off with no server address, or a misshapen beta key'),
+    ('A55', 'lib/recording/recording.dart',
+     '    _cancelled = true;\n',
+     '',
+     'test/recording/recording_test.dart', 'cancel ends at once; a cancel while starting opens nothing'),
+    ('A56', 'lib/recording/microphone.dart',
+     '  return math.min(1, math.sqrt(sum / samples));',
+     '  return math.min(1, sum / samples);',
+     'test/recording/recording_test.dart', 'frames go to Soniox as they come; their level shown'),
+    ('A57', 'lib/journal/pages/typing_page.dart',
+     '    final atEnd = !before.selection.isValid ||',
+     '    final atEnd = true ||',
+     'test/journal/pages/typing_page_test.dart', 'heard words go at the end, never at the caret'),
+    ('A58', 'lib/journal/pages/typing_page.dart',
+     '    SemanticsService.sendAnnouncement(View.of(context), Lines.MP_33.text(appLanguage), TextDirection.ltr);\n',
+     '',
+     'test/journal/pages/typing_page_test.dart', 'MP·33 is told once; the level line and the timer show'),
+    ('A59', 'lib/journal/pages/typing_page.dart',
+     '      await (leaving ? session.cancel() : session.stop());',
+     '      await session.cancel();',
+     'test/journal/pages/typing_page_test.dart', 'Back while recording waits for the last words, then saves'),
+    ('A60', 'lib/journal/pages/typing_page.dart',
+     'child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),',
+     'child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: _save),',
+     'test/journal/pages/typing_page_test.dart', 'Start Interpretation does nothing yet (D71 Q3)'),
+    ('A61', 'lib/journal/pages/typing_page.dart',
+     'mainAxisAlignment: MainAxisAlignment.spaceBetween,',
+     'mainAxisAlignment: MainAxisAlignment.start,',
+     'test/journal/pages/typing_page_test.dart', 'Save on the left, Start Interpretation on the right'),
+    ('A62', 'lib/journal/pages/typing_page.dart',
+     '(first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),\n                                          style: TypeRoles.button.style(p.text),',
+     '(first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),\n                                          style: TypeRoles.voiceApp.style(p.text),',
+     'test/journal/pages/typing_page_test.dart', 'the instruction is centred, in the button type'),
+    ('A63', 'lib/journal/pages/typing_page.dart',
+     '                            if (live)\n',
+     '                            if (_mic == _Mic.starting)\n',
+     'test/journal/pages/typing_page_test.dart', 'MP·33 is told once; the level line and the timer show'),
+    ('A64', 'lib/journal/pages/typing_page.dart',
+     '      await (leaving ? session.cancel() : session.stop());',
+     '      await session.stop();',
+     'test/journal/pages/typing_page_test.dart', 'leaving the app while recording ends it and saves the words'),
+    ('A65', 'lib/recording/record_microphone.dart',
+     '      iosConfig: IosRecordConfig(categoryOptions: []),\n',
+     '',
+     'test/recording/no_storage_test.dart', 'only the microphone file uses the record package, in stream mode'),
+    ('A66', 'lib/main.dart',
+     "import 'core/safe_log.dart';\n",
+     "import 'core/safe_log.dart';\nimport 'recording/recording.dart';\n",
+     'test/dev_only_test.dart', 'lib/main.dart reaches no journal or recording code, no pending line'),
+    ('A67', 'lib/recording/heard_text.dart',
+     "final _space = RegExp(r'\\s');",
+     "final _space = RegExp(r'\\s'); // a File is never named here",
+     'test/recording/no_storage_test.dart', 'nothing in lib/recording/ names a file or a folder'),
 ]
 
 
~~~~

### Task 12 · Status.md (D71 Q21)

The changes:
- the current branch;
- the road ahead, with offline recording the next slice;
- the app's and the server's state and counts;
- "Before the first deploy" rewritten;
- banked item 44 closed, and items 92 to 98 new;
- D70's answers to Task 14's questions;
- "Rulings during recording".

Commit:

> Docs: Status.md for recording, before the first deploy (D69 to D71)

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
index 1000f76..6efa982 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-13, at the final review of branch `journal-screens`, by Claude Code.
+Last updated: 2026-11-13, in branch `recording` (its plan's Task 12), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,14 +14,21 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`journal-screens`: the journal's pages in SoulDreams Dev only (D49 O1; D56): the journal list with month dividers,
-the typing screen, a night's page with editing and deleting the night, the 21:00 rule, and Night/Day automatic, built
-to Product's answers P1 to P14 and the answers of D58. Plan: `docs/plans/journal-screens.md`.
+`recording`: recording by voice in SoulDreams Dev only, and the server's first feature (D69, as D71 corrects it; D70;
+D71): the microphone permission (EM·3), the words shown as the dreamer speaks, Save keeping them as a dream; the
+audio never stored on the server, and in this slice not on the phone either, since it needs a connection; the
+typing screen's current design (D70 items 2, 7 and 8); the two banked read failures; one front door, a Lambda
+function URL authorised by the beta key, issuing short-lived Soniox keys. Plan: `docs/plans/recording.md`.
 
 ## Road ahead
 
-- The first server feature, and before it the front door (banked item 44); then the first deploy, after "Before
-  the first deploy" below.
+- The first deploy, after "Before the first deploy" below; then the server's address into `hosts.dart` and the
+  phone checks (the plan's Tasks 13 to 16).
+- The next slice: offline recording, the audio held on the phone only until it is transcribed (main-path.md,
+  Recording; D71). It is an on-phone storage change, under `docs/workflow.md`, "On-phone storage changes", and it
+  brings MP·15 and MP·54.
+- The readings: our server's own spending counter comes with them (D69), and response streaming on the function
+  URL (head's message 14; whether eu-north-1 has it is checked first).
 - A later branch, by the Head of Technology's direction (with D32): the import gains a kind for lens sections 3, 4, 5,
   6 and 11 only, with a guard G10 refusing any other `## ` heading in them, and a kind for
   `lens-register-waking-material-pass.md`, imported whole into `server/instructions/`. The importer's `KINDS` table
@@ -80,10 +87,28 @@ to Product's answers P1 to P14 and the answers of D58. Plan: `docs/plans/journal
 - The typing screen, as ruled during the build (D62, D63): a failed save keeps the screen and the words, logs
   `journalSaveFailed` and shows MP·62 in the scroll area below the field, cleared when Save is tried again; Save,
   Back, the system back and the iPhone edge swipe (a 20 px strip, a rightward drag of 60 px or a flick of 300 px/s)
-  each save, and each retries after a failure. The field takes no focus by itself; the page scrolls, MP·10 or MP·32
-  with it, and the field fills the page, never less than `StandIns.fieldMinLines` lines. Leaving the app (hidden or
+  each save, and each retries after a failure. The field takes no focus by itself. Leaving the app (hidden or
   paused) saves once per trip away and leaves the screen; `inactive` saves nothing; whitespace alone keeps nothing
   and stays.
+- The typing screen's design (D70, TO TRY; D71): MP·10 or MP·32 centred in the button type, in its own scroll area,
+  with MP·62 under it; the field a pill (corners half one line's height) that grows with its words up to
+  `StandIns.fieldCap` (0.7) of the space between Back and the buttons; Save (MP·13) bottom left and Start
+  Interpretation (EM·1) bottom right, which does nothing yet (D71 Q3); at large text the two pills shrink their
+  words to stay on one row.
+- Recording (D69, as D71 corrects it; `app/lib/recording/`, SoulDreams Dev only): the microphone inside the field,
+  named MP·11, asks for the microphone the first time (EM·3, the phone's alert). A tap asks our server for a
+  short-lived key (one POST, the beta key as bearer, no user agent), opens Soniox's EU real-time stream with the key
+  in the handshake's header, sends exactly the settings (`stt-rt-v6`, `pcm_s16le`, 16 kHz, mono, English only), then
+  the microphone's frames as they come; an empty text frame ends it. Words heard go at the end of the field, never at
+  the caret; provisional words are replaced by the next reply. While it runs: a level line and a timer (stand-ins),
+  and MP·33 told once to a screen reader. A tap, Save or Back waits up to five seconds for the last words; leaving
+  the app ends it at once. No connection, no key, a refused microphone or a failed stream: the microphone does not
+  start; a stream that breaks stops, keeping the words shown; each logs a code and shows nothing new; MP·15 and
+  MP·54 are not shown (D71). Nothing in `lib/recording/` can write a file, and the `record` package is used in
+  stream mode only (`no_storage_test.dart`). Off while `Hosts.server` is empty or the build has no beta key.
+- The journal list's read failures and the typing screen's first-use read (D71 Q18): a failed list read keeps
+  the rows shown and logs `journalListFailed`; at the record button it opens nothing; a failed first-use read
+  shows MP·32, marks nothing and logs `firstUseReadFailed`; a failed mark still shows MP·10.
 - A night's page (D64): a failed delete or read logs `journalDeleteFailed` or `journalReadFailed`, keeps the page and
   shows nothing new; while a delete runs, the menu, Add dreams and the dreams ignore taps; each dream is announced as
   a button. SoulDreams Dev's list waits for the phone check before it opens the folder (D65).
@@ -99,7 +124,9 @@ to Product's answers P1 to P14 and the answers of D58. Plan: `docs/plans/journal
   Reduce Motion (`app/lib/core/app_line.dart`; D58 Q17). The palette (`app/lib/design/palette.dart`) fades with the
   theme. The app shows English only (D57 Q12; `app/lib/core/language.dart`).
 - Packages: `flutter_localizations` (SDK) and `intl` 0.20.3, the owner's pub add (D57 Q9): the month names, and
-  Flutter's own framework words, which are not ours under R1.
+  Flutter's own framework words, which are not ours under R1. `record` 7.1.2, exactly, the owner's pub add (D71
+  Q14): the microphone, in stream mode, the built-in microphone only (D71 Q15). Its native code is registered in all
+  three apps and reached from SoulDreams Dev only (D71 Q16).
 - The pending lines (D57 Q11; D58 Q11): `app/assets/words/pending-lines.csv` and its fingerprint, the owner's;
   `wordsgen.py` makes `app/lib/words/pending.g.dart`, whose `PendingLine` is not a `Line` and shows its words in
   SoulDreams Dev only (any other flavour gets its handle), and G1 proves both. A row whose handle the register holds
@@ -107,51 +134,72 @@ to Product's answers P1 to P14 and the answers of D58. Plan: `docs/plans/journal
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 188 tests, and 86 mutation checks (A1 to A39, with the rows A24a to A24au among them) in
+- The app's analyzer baseline: `No issues found!`. The app has 236 tests, and 114 mutation checks (A1 to A67, with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 86 run, 86 caught`); `check_all.sh` does not call it (D55).
+  (expected: `app mutations: 114 run, 114 caught`); `check_all.sh` does not call it (D55).
 
 ## The server
 
 - Node 24, pinned by `engines` in `server/package.json`; `check_all.sh` checks the running major. TypeScript, strict
-  (`server/tsconfig.json`; no `exactOptionalPropertyTypes`, D42 Q6). Five packages, for development only, at exact
+  (`server/tsconfig.json`; no `exactOptionalPropertyTypes`, D42 Q6). Six packages, for development only, at exact
   versions: `typescript` 6.0.3, `@types/node` 24.19.2, `aws-cdk-lib` 2.275.0, `constructs` 10.8.1, `aws-cdk`
-  2.1147.0 (D42 Q1, Q14). The owner installs them; Claude Code's settings deny every install, and it runs `npm ci
+  2.1147.0 (D42 Q1, Q14), and `@aws-sdk/client-ssm` at the owner's version, for its types only: the Lambda runtime
+  carries its own SDK, and the Lambda's code folder holds no package (D71 Q13 a). The owner installs them; Claude Code's settings deny every install, and it runs `npm ci
   --offline` only through `check_all.sh` (D42 Q13).
-- `server/src/`: the handler (every request 404 with no body, one logged code; D42 Q15), `safe-log.ts` (codes and
-  numbers only) and `hosts.ts` (no host yet). `server/infra/`: the CDK app, its account refusal and the stack.
+- `server/src/`: the front door (`door.ts`, head's message 14; D71): POST `/` with the beta key as a bearer token gets
+  a short-lived Soniox key (200, `{key, expiresAt}`); a missing, wrong or misshapen key 401 with no body, before
+  anything is read when misshapen; another method or path 404; Parameter Store failing 500; Soniox failing 502
+  with its status logged. It reads the method, the path and the authorization header only, never the caller's
+  address, the body or another header. The beta key's check hashes both keys and compares them in constant time
+  (`beta-key.ts`). The temporary key's request is exactly four fields: `transcribe_websocket`, 60 seconds to open,
+  single use, 1800 seconds at most (`soniox.ts`, D71 Q10), sent to `api.eu.soniox.com` (`hosts.ts`). The two keys
+  are read from Parameter Store as SecureStrings (`parameters.ts`, `parameter-names.ts`); `handler.ts` wires them.
+  `safe-log.ts` (codes and numbers only). `server/infra/`: the CDK app, its account refusal and the stack.
   `npm run build` writes `dist/src` with the module marker beside the compiled files (D42 Q5).
-- The stack: one Lambda (`nodejs24.x`, arm64, CDK's default memory and timeout) behind an HTTP API in eu-north-1;
-  logs kept 7 days, JSON, application INFO, system WARN; a role that writes only to its own log group; no access
-  logs, tracing, environment, CORS or authorizer; termination protection on (D42 Q4, Q7 to Q9). The CDK CLI's
-  telemetry, notices and version reporting are off (D42 Q3). **Nothing is deployed.**
+- The stack: one Lambda (`nodejs24.x`, arm64, CDK's default memory, a 10-second timeout, D71 Q20) behind its own
+  function URL in eu-north-1, with no authentication of the URL's own (the beta key is checked in the code), no CORS,
+  and the two permissions a public function URL needs (`InvokeFunctionUrl` and `InvokeFunction` through the URL;
+  CDK 2.275.0 makes both); one output, the URL's address; logs kept 7 days, JSON, application INFO, system WARN; a
+  role that writes only to its own log group, reads the two parameters only, and decrypts only through Parameter
+  Store; no access logs, tracing or environment; no reserved concurrency yet (D71 Q12); termination protection on
+  (D42 Q4, Q7 to Q9). The CDK CLI's telemetry, notices and version reporting are off (D42 Q3). **Nothing is
+  deployed.**
 - `npm test` proves the template in-process, with no AWS credentials, CLI or network (D42 Q16). The account is never
   in the repository: with credentials, the app refuses unless the resolved account equals `-c account=<id>` (D42 Q9).
   The template tests also pin that the role has no inline policy, that the Lambda logs to the stack's own log group,
   and that the log group is deleted with the stack (D44 a, b, c).
 - The CDK CLI's own synth was run once, with no credentials (Task 8, D45): the `Resources` section holds the nine
   types of `test/stack.test.ts` and no `AWS::CDK::Metadata`; `Parameters` holds only `BootstrapVersion`.
-- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 28 tests, and
-  16 mutation checks (S1 to S16) in `tool/server_mutations.py`, run by hand from the repository root with
-  `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 16 run, 16 caught`); `check_all.sh` does not
+- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 47 tests, and
+  30 mutation checks (S1 to S30) in `tool/server_mutations.py`, run by hand from the repository root with
+  `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 30 run, 30 caught`); `check_all.sh` does not
   call it (D43 Q3). It first runs the type check and the tests on the unbroken server, and stops with
   `server mutations: FAILED (the unbroken server fails)`, exit 1, if either fails (the final review, `2fbaad6`).
 
 ## Before the first deploy
 
-The owner's, in this order (D42 Q10, Q12, Q16; D44 d; D45):
-
-1. The front door is settled (banked item 44).
-2. The beta key (48 characters, D18) and the spending stop are built, in a branch of their own.
-3. The workload account is bootstrapped for the CDK in eu-north-1 (never the management account; C4-T item 15).
-4. In the workload account: Bedrock model invocation logging is off, and the retention mode is `none` under the
+The owner's, in this order (D42 Q10, Q12, Q16; D44 d; D45; D71). The plan's Tasks 13 and 14 give the commands.
+
+1. DONE (head's message 14): the front door is a Lambda function URL, authorised by the beta key.
+2. DONE in `recording` (D69, D71): the beta key's check is built; the spending stop for transcription is Soniox's
+   own $20 monthly budget; our server's counter comes with the readings.
+3. In Soniox's Console: EU region access approved; an EU project; a project key with the temporary-key and
+   transcription permissions; a $20 monthly budget; the DPA countersigned (technical-answers a).
+4. The beta key generated (48 characters of A-Z, a-z, 0-9, D18) into `~/.soul-dreams/`; the two SecureStrings,
+   `/souldreams/beta-key` and `/souldreams/soniox-key`, made in the workload account in eu-north-1 on the `aws/ssm`
+   key, standard tier, never typed on a command line.
+5. The workload account is bootstrapped for the CDK in eu-north-1 (never the management account; C4-T item 15).
+6. In the workload account: Bedrock model invocation logging is off, and the retention mode is `none` under the
    service control policy (technical-answers b).
-5. The deploy runs from the workload account's profile with `-c account=<workload id>`; the app refuses any other.
+7. The deploy runs from the workload account's profile with `-c account=<workload id>`; the app refuses any other.
    Always deploy through the app, never `cdk deploy --app cdk.out` (banked item 49).
-6. After one request: CloudWatch holds codes and numbers only; no `/aws/lambda/...` log group exists; the stage has
-   no access logs (technical-answers e and p, "[ASSUMED until built and shown]").
-7. The head has ruled on the CLI's two notices (banked item 53).
-8. Optional: `npx cdk synth`, its `Resources` compared with `server/test/stack.test.ts` (run once in Task 8, D45).
+8. After the first requests (a 404, a 401 and a 200): CloudWatch holds codes and numbers only; no `/aws/lambda/...`
+   log group exists; CloudTrail records no Lambda data events; Soniox's usage log shows the stream with no reference
+   of ours (technical-answers e and p, "[ASSUMED until built and shown]").
+9. The head has ruled on the CLI's two notices (banked item 53).
+10. Reserved concurrency returns once the workload account's Lambda concurrency quota is above 100 plus the
+    reservation (D71 Q12): a branch adds it, with its template test.
+11. Optional: `npx cdk synth`, its `Resources` compared with `server/test/stack.test.ts`.
 
 ## The guards
 
@@ -257,8 +305,8 @@ Banked in branch 3 (reviewers' notes, banked by D17 under D35, D37 and the later
 
 Banked in branch 4:
 
-44. D42 Q4: the 30-second limit goes to the head and the Architecture worker before the first server feature (front
-    door for the reading call).
+44. CLOSED in `recording` (head's message 14): the front door is a function URL; a function's limit is 15 minutes,
+    against the HTTP API's 30 seconds [READ, AWS's Lambda and API Gateway quotas pages].
 45. D42 Q11: `npm audit` reports 2 moderate findings, in the `minimatch` that `aws-cdk-lib` bundles
     (GHSA-g3hv-75wg-m249). It runs at build time on the Mac and is not in the Lambda's code. No downgrade (the fix
     offered is `aws-cdk-lib` 2.239.0); recheck at each dependency change, never `npm audit fix --force`.
@@ -420,13 +468,34 @@ Banked by D68 (the reviewers' notes in journal-screens; the detail is in
     and the padding the words have 80 by 90 pt, and the circle or the padding is the lever if the founder wants them
     larger.
 
+Banked in recording:
+
+92. The `record` plugin's native code is in all three apps, unused outside SoulDreams Dev (D71 Q16, as D65). It
+    snaps the asked rate to the nearest the hardware offers, and the app always tells Soniox 16 kHz: a snapped rate
+    would show as wrong words in the phone check, and the fix is sending the rate in use.
+93. At large text the typing screen's two pills shrink their words to stay on one row (as the record button does,
+    banked item 91); the founder may prefer them to wrap (P13).
+94. Not testable on the Mac, shown at the first deploy: `parameters.ts` (the SDK call, `WithDecryption`), the
+    handler's wiring to it and to Soniox, the role's `kms:Decrypt` condition, and the runtime's own SDK resolving
+    `@aws-sdk/client-ssm`.
+95. Soniox's budget reached (402), the key's session ending (403 at 1800 s) and every other break show nothing new
+    and log a code (D71); Product's places for them are asked (D71 Q4).
+96. A test that makes real requests on loopback must sit in a file with no widget test: Flutter's test binding
+    answers every HTTP request with 400 once a widget test has run in the file. Awaiting a stream subscription's
+    `cancel()` never resumes under the widget tests' fake clock, so recording does not await it.
+97. Lambda Web Functions (AWS, 2026-10-12) are not offered in eu-north-1 [READ, AWS News Blog]; whether response
+    streaming is offered there is checked before the readings.
+98. The journal-screens final review's item 3 stays open: a row tapped while the record button's read is in flight
+    opens that night, then the typing screen over it.
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
    note 1; D68).
 2. Product gives exact values for Task 14's thirteen questions below (P13).
 
-Task 14's questions for Product (D68), from the founder's screenshots; none built, each more than a number:
+Task 14's questions for Product (D68), from the founder's screenshots; none built, each more than a number
+(questions 2, 7 and 8 were answered by D70 and built in `recording`, TO TRY):
 
 1. The summary's type role: the screenshots show `TypeRoles.button` (Inter 14); switching needs the row's minimum
    height changed.
@@ -578,6 +647,26 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   code is pinned by 84 mutation rows; revisit at the next feature branch); the final review fixes real defects only,
   test-first, in their own commits.
 
+## Rulings during recording
+
+- D69 (owner, 2026-11-13), as D71 corrects it: the scope (recording on the typing screen, Dev only: EM·3, live text,
+  Save keeps it as a dream; the audio never stored on our server, and on the phone kept only until transcribed, the
+  documents governing); the first task fixes the two banked read failures; the spending stop for transcription is
+  Soniox's $20 monthly budget; keys in Parameter Store (SecureString); the beta key 48 characters, in
+  `~/.soul-dreams` and Parameter Store, compiled into Dev through `--dart-define-from-file`; one microphone package;
+  Soniox over `dart:io`'s WebSocket; English only for Cohort 0.
+- D70 (head's message 20, Product message 19): the typing screen's items 2 (the pill field with the microphone,
+  growing, never focused by itself; TO TRY), 7 (the instruction in the button type, centred) and 8 (Save left, Start
+  Interpretation right, as built so far). The other ten items are a later journal design pass.
+- D71 (owner, 2026-11-13): the investigation's 21 questions. This slice needs a connection (no connection, key or
+  stream: the microphone does not start; a break keeps the words shown; a code, nothing new; MP·15 and MP·54 not
+  shown); offline recording is the next slice. Q2 D70's order (Product refiles main-path); Q3 Start Interpretation
+  shown, inert; Q4 the four missing places to Product; Q5 MP·11; Q6 at the end, never at the caret; Q7 the level
+  line, the timer and the 0.7 cap as stand-ins; Q8 the Authorization header; Q9 `stt-rt-v6` in one constant; Q10 60
+  s, single use, 1800 s; Q11 200, 401, 502, 500; Q12 no reserved concurrency now; Q13 (a); Q14 `record` 7.1.2
+  exactly; Q15 the built-in microphone only; Q16 accepted; Q17 the server's address committed after the deploy; Q18
+  the read failures as leaned; Q19 the structural test; Q20 10 s; Q21 Status.md in the branch.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C16-P state (`ff3b229`), in commit `ca29414` (Task 6). The ordinal
~~~~

### Task 13 · [OWNER] The keys: the beta key, Soniox, Parameter Store

Claude Code never sees any of these values (R5). Nothing here is typed on a command line or pasted into a chat.

**1. The beta key** (D18: 48 characters of A-Z, a-z, 0-9).

Paste 1 — Terminal
```
cd ~/.soul-dreams && umask 077 && LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 48 > beta-key.txt && printf '{"BETA_KEY":"%s"}\n' "$(cat beta-key.txt)" > recording-dev.json && wc -c < beta-key.txt && ls -l beta-key.txt recording-dev.json
```

Expected: `48`, and both files `-rw-------`.

**2. Soniox's Console** (technical-answers a):
- Region access: the EU region requested and approved.
- A project created in the EU region.
- A project API key with the permission to create temporary keys and to transcribe in real time.
- The project's (and the organisation's) monthly budget set to $20.
- The DPA countersigned.

Save the project key without a newline: copy it, then

Paste 2 — Terminal
```
cd ~/.soul-dreams && umask 077 && pbpaste | tr -d '\n' > soniox-project-key.txt && wc -c < soniox-project-key.txt && pbcopy < /dev/null
```

**3. Parameter Store**, in the workload account, eu-north-1. Each value is read from its file, never typed. AWS CLI v2
reads a `file://` value; if it does not, use the console (Systems Manager → Parameter Store → Create: SecureString, the
`aws/ssm` key, standard tier).

Paste 3 — Terminal (with the workload account's profile in place of `<workload>`)
```
cd ~/.soul-dreams && aws ssm put-parameter --profile <workload> --region eu-north-1 --name /souldreams/beta-key --type SecureString --value "file://$HOME/.soul-dreams/beta-key.txt" && aws ssm put-parameter --profile <workload> --region eu-north-1 --name /souldreams/soniox-key --type SecureString --value "file://$HOME/.soul-dreams/soniox-project-key.txt" && aws ssm describe-parameters --profile <workload> --region eu-north-1 --parameter-filters 'Key=Name,Values=/souldreams/beta-key,/souldreams/soniox-key' --query 'Parameters[].[Name,Type,Tier,KeyId]' --output text
```

Expected: two lines, each `SecureString`, `Standard` and `alias/aws/ssm`.

### Task 14 · [OWNER] The first deploy, with its checklist

Status.md, "Before the first deploy", items 3 to 9, in order. Items 3 and 4 are Task 13; 5 is the bootstrap; 6 the
Bedrock settings; 9 the head's ruling on the two notices.

Paste 1 — Terminal (once, item 5)
```
cd ~/Developer/soul-dreams-app/server && npx cdk bootstrap aws://<workload id>/eu-north-1 --profile <workload>
```

Paste 2 — Terminal (item 7: always through the app)
```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk deploy -c account=<workload id> --profile <workload>
```

Expected: the stack `SoulDreamsServer` created, and one output:
`SoulDreamsServer.Url = https://<id>.lambda-url.eu-north-1.on.aws/`.

Paste 3 — Terminal (item 8: a 404, a 401 and a 200; the key is never printed)
```
URL='<the output>' && curl -s -o /dev/null -w '%{http_code}\n' "$URL" && curl -s -o /dev/null -w '%{http_code}\n' -X POST "$URL" && curl -s -o /dev/null -w '%{http_code}\n' -X POST -H "Authorization: Bearer $(cat ~/.soul-dreams/beta-key.txt)" "$URL"
```

Expected: `404`, `401`, `200`.

Then, item 8's looks, in the console:
- the stack's log group holds `notFound`, `keyRefused` and `keyIssued`, and nothing else: no address, no key;
- no `/aws/lambda/...` log group;
- CloudTrail has no data-event selector for Lambda;
- Soniox's usage log shows one key and no stream yet, with no reference of ours.

Item 10: read the workload account's Lambda concurrency quota (Service Quotas → AWS Lambda → Concurrent executions)
and bring the number. Reserved concurrency waits until it is above 100 plus the reservation.

Bring the results to the Build chat as a checklist, and the URL to Claude Code.

### Task 15 · The server's address into `hosts.dart` (D71 Q17)

Claude Code edits one line of `app/lib/core/hosts.dart`:

```
  static const server = '<the output, ending in .on.aws/>';
```

`test/core/hosts_test.dart` already accepts only `https://<id>.lambda-url.eu-north-1.on.aws/`. Expected: 236 app
tests. Commit, alone:

> Hosts: our server's function URL, after the first deploy (D71 Q17)

### Task 16 · [OWNER] The phone checks, SoulDreams Dev, invented nights only

Build and install SoulDreams Dev as usual, adding `--dart-define-from-file=$HOME/.soul-dreams/recording-dev.json`.
Speak only invented nights: the lean (Part 4, Q6) is the Mac reading one aloud by the phone,

```
say -f /dev/stdin <<< "$(python3 -c 'import json;print(json.load(open("fixtures/invented-nights.json"))["nights"][0]["dreams"][0])')"
```

run from the repository root, so that no one's voice is recorded (R2).

**The microphone**
- The typing screen: MP·32 (or MP·10) centred; the pill field with the microphone; Save bottom left, Start
  Interpretation bottom right; Start Interpretation does nothing.
- The first tap on the microphone: the phone's alert with EM·3. Don't Allow: nothing new, the microphone idle. Allow
  it in Settings → SoulDreams Dev, then tap again.

**Recording**
- Words appear while the night is read aloud; the level line moves; the timer counts. VoiceOver says MP·33 once.
- Tap the microphone: the last words arrive, the line and the timer go. Save: the row shows the dream.
- Type a word, put the caret at its start, record: the heard words go after the typed one; the caret stays.
- Back while recording: the last words, then the dream is saved. Leaving the app while recording: it stops at once,
  and the words are saved.
- Airplane mode, then the microphone: nothing starts, nothing new shows.

**Nothing kept**
- Xcode → Devices → SoulDreams Dev → Download Container; in the container:
  `find . -type f \( -name '*.caf' -o -name '*.m4a' -o -name '*.wav' -o -name '*.pcm' -o -name '*.aac' \) | wc -l`.
  Expected `0`.
- CloudWatch: one `keyIssued` per recording, nothing else new. Soniox's usage log: the streams, with no reference of
  ours.

**Large text and the keyboard**
- The largest text size, with the keyboard up, recording: nothing cut off; Save and Start Interpretation reachable.
- The field grows with a long invented dream to about two thirds of the screen, then scrolls inside.

Bring the results as a checklist (passed, or what was seen), never a screenshot or a recording of a night.

## Part 4 · Questions (numbered; a blank is not a yes)

1. **MP·62 in the button type.** It sits under the instruction, in the same scroll area. Lean: the same type, as built.
   If not, it goes back to `voiceApp`, one line.
2. **The pills shrink their words at large text** (banked item 93), as the record button does. Lean: accept as a
   stand-in for the founder's look (P13). If they should wrap instead, the screen needs a scrolling layout at large
   text, a larger change.
3. **The microphone's icons**: Material's `mic_none`, and `stop_rounded` while recording, with MP·11 as the
   long-press tip and the spoken name. Lean: stand-ins (P13). If MP·11 should not appear as a tip, the tip goes and a
   `Semantics` label carries it.
4. **The rate `record` uses.** It snaps 16 kHz to the nearest rate the hardware offers, and no API was found to read
   the rate in use; the app always tells Soniox 16 kHz. Lean: the phone check (Task 16) shows it, as words that come
   out right or wrong; if wrong, a task sends the rate in use. If the owner wants it pinned first, Task 9's reading of
   `record_darwin` looks for that API.
5. **The files in `~/.soul-dreams/`**: `beta-key.txt`, `recording-dev.json` and `soniox-project-key.txt`. Lean: those
   names. The owner may keep `soniox-project-key.txt` elsewhere, or delete it once Parameter Store holds it (Soniox's
   Console can make a new one).
6. **Test speech for the phone check** (R2): the Mac reads an invented night aloud with `say`, by the phone. Lean: as
   in Task 16. If the owner prefers to read the invented night himself, it is still an invented night; his voice goes
   to Soniox, which keeps nothing.
7. **Leaving the app while recording saves the provisional words too** (they are on the screen). Lean: keep them, as
   "a stream that breaks keeps the words shown" (D71). If not, they are dropped before saving.
8. **`@aws-sdk/client-ssm`'s many packages** in the lockfile (development only, never in the Lambda's folder). Lean:
   accept, with `npm audit` checked at Task 4. If the owner prefers none, Q13's (c), the extension layer, comes back.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/build-rec`, from `git archive` of `d02af1b`. The
   sandbox refuses a git clone or worktree there (it blocks writing a `.git/config`), so each task's state was kept as
   a snapshot (`./.scratch/snaps/<task>`), and each block in Part 3 is `git diff --no-index` between two snapshots,
   with the owner's package files left out. The guards ran on every snapshot with `guards.py --walk`: `all passed`.
2. **The owner's steps, simulated, never with real keys or packages.**
   - Task 4: a stand-in `@aws-sdk/client-ssm` (the two classes and their types, version `0.0.0-stub`) in a scratch
     `node_modules` that links the real ones, and a stand-in line in `package.json` and the lockfile.
   - Task 9: a stand-in `record` 7.1.2 (its API as the plan uses it) by a path override in a scratch `pubspec.yaml`.
   - Neither stand-in is in a block. Both packages are checked for real at Tasks 5 and 10, and a mismatch there is a
     stop.
3. **The counts measured on the snapshots**:
   - app tests: 192 (Task 1), 221 (Task 7), 233 (Task 8), 236 (Task 10), `No issues found!` at each;
   - server tests: 43 (Task 2), 46 (Task 3), 47 (Task 5), `npm run check` clean at each.
4. **Mutations on the build**:
   - `server mutations: 30 run, 30 caught`.
   - `app mutations: 114 run, 113 caught` on the first run. A64 survived because leaving the screen ends the recording
     anyway; it was replaced by the row in Task 11 (leaving waits for nothing) and caught. A49's pattern was
     shortened for G4 and caught.
5. **Replayed on a fresh copy**, `./.scratch/replay-rec`, from `git archive` of `d02af1b`, with git kept out of the
   parent repository:
   - every block applied with `git apply`, in order, with the owner's steps simulated as in 2;
   - the replayed tree against the build's last snapshot: no difference at all;
   - on the replayed tree: `guards.py --walk` before any tool ran: `all passed` (the tree is identical to the guarded snapshot); `No issues found!`; `+236: All tests passed!`; the server's `npm run check` clean and `ℹ tests 47`, `ℹ fail 0`; `server mutations: 30 run, 30 caught`; `app mutations: 114 run, 114 caught`, every file put back.
6. **Not provable in the sandbox, so the owner's**: the real packages and their types, the iOS build, Parameter
   Store, the deploy, Soniox, and every phone check. These are listed in Status.md as banked item 94.
7. `tool/checks/tests/run_tests.py` in the copy: 239 tests run, one error, `test_check_all`, which needs a git
   repository. No guard or check changed in this branch, and the real tree's run is `OK`, 241 tests.
8. The scratch copies (`build-rec`, `replay-rec`, `snaps`, `stub-record`) are deleted after this plan is committed.
