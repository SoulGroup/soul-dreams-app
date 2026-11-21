# Plan: Settings and the three consents (redesign-c)

Branch `redesign-c`, from `main` at `8243128`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D95. Written by Claude Code (Opus) on 2026-11-22. The investigation stopped once
(`.scratch/for-build-chat/redesign-c-stop.md`): the consent screen shows MP·68 and MP·70, whose owed sentences are
in braces. D122 answered: every lean of the stop's report. The owner's checks are by eye only.

`redesign-b` is merged (`main` at `8243128`); its Status was not updated at the merge (Task 6 records it).

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

The journal gets a gear, top left. It opens Settings: Language (English only), Word Animation, Night images, Night/Day
mode, Life Context and Life Context length, then "Read disclosure & privacy", "Withdraw consent" (or "Give consent")
and "Delete journal". The settings are kept on the phone, in the journal's folder, and go with the journal when it is
deleted.

Onboarding's single "I consent" becomes the three consents, each separate: the readings (a), Life Context (b) and
the night images (c), each with "I consent" and "I don't consent", equally prominent, neither chosen beforehand. Next
waits until all three are answered. Saying no to any of them still opens the journal.

The consents decide what may happen:
- **(a) the readings.** Not given, nothing leaves the phone: no microphone, no retries of recordings still waiting,
  every night kept. Withdrawn in Settings, it pauses; given again, it resumes.
- **(b) Life Context.** It is the Life Context setting, On or Off. Nothing is kept yet: Life Context comes later
  (D121 item 2).
- **(c) the night images.** Not given, Night images is Off and every night shows the gradient.

Turning a setting on that needs a consent first shows that consent. Turning it off asks only where the register has a
confirmation (MP·93 for Life Context, MP·96 for the readings).

Delete journal asks once (C4-P·4) and deletes everything: nights, recordings, consents and settings. Then the app
starts again at the welcome.

### What this branch builds

1. **Storage** (R11; docs/workflow.md (c); D122, the stop's question 12):
   - **The consents file** goes from version 1 to 2: `consent.json`, holding "18 or over" and the three answers, each
     with the UTC day of its last change (`settings/consents.dart`). Version 1 still reads, as (a) given and (b) and
     (c) not given, with no day.
   - **The settings file** is new: `settings.json`, version 1 (`settings/settings.dart`), holding Word Animation (on),
     Night/Day mode (Automatic), the painting kept for while (c) is given (Personal) and Life Context length (2 weeks).
     Both files are written whole and renamed, in the journal's folder, with the folder's complete protection and its
     exclusion from backup.
   - **A file that does not read** exactly: no consents, so onboarding asks again; or no settings, so the defaults
     stand.
   - **What goes:** `withdrawConsent` is gone. A withdrawal is an answer, kept. `consentGone` now moves only when
     the journal is deleted.
2. **The settings while the journal is open** (`settings/settings_controller.dart`):
   - **A change** shows at once and is then kept. One that cannot be kept logs `consentKeepFailed` or
     `settingsKeepFailed` and holds until the app closes.
   - **The journal's home follows it:**
     - Word Animation goes into `AppLine` and the theme's fade.
     - Night/Day mode goes into `NightDay`, through `NightDayChoice` above the app.
     - Night images is handed to the pages: Off means the gradient for every night (`lookOf`'s `images`).
     - The recording and its retries exist only while (a) is given.
   - **Night/Day Manual** holds Day or Night whatever the hour. A change while the app is open fades over five
     seconds. With Word Animation off, as with Reduce Motion, it is instant (Design System §6).
3. **The setting lines read by form** (`settings/setting_line.dart`; D122, the stop's question 13): "Name (A / B
   ...)" gives the name and the choices. Any other form gives none, and the row shows the place's handle.
4. **The three consents** (MP·66 to MP·70; D110; D122):
   - **Onboarding's second page:** the disclosure's parts and "Read everything" as before, then MP·66, then MP·68,
     MP·69 and MP·70, each with MP·67's pair (`ConsentChoice`). The chosen one is filled, in `color.button.filled`.
   - **The foot:** EM·6 on the left, back to the first page as before, and Next (MP·30) on the right, inert until all
     three are answered.
   - **`ConsentPage`:** one consent's text with the same pair. It is Settings' way to give a consent, and its back
     control gives nothing.
   - **The shown-lines test** now covers what the tester and founder apps reach, following imports as
     `dev_only_test.dart` does. SoulDreams Dev shows MP·68 and MP·70 as filed, braces included (D122, Q1 (B)).
5. **Settings** (`settings/settings_page.dart`; main-path.md, Settings; D110; D121; D122):
   - **The page:** the back control top left; the quick toggle top centre (the sun or the moon drawn in code,
     spoken as MP·45), which switches the theme and sets Manual; MP·25 in h2.
   - **Six rows,** each a white rounded row with its name and a value pill opening the phone's menu:
     - Language: EM·9, `[owed·language]`, one choice.
     - Word Animation (MP·26).
     - Night images (MP·85).
     - Night/Day mode (MP·44).
     - Life Context (MP·83).
     - Life Context length (MP·84).
   - **Below the rows:** MP·48 (the full disclosure page), MP·95 (Withdraw consent, or Give consent), and EM·11's
     first part (Delete journal) in `color.destructive`.
   - **The confirmations:** the phone's standard dialog, Cancel first: MP·96 with MP·97; MP·93 with MP·94; C4-P·4
     with MP·60.
   - **The gear** (`journal_page.dart`): top left above the search field. It is drawn in code in a 41 bordered
     circle with a 44 tap box, spoken as MP·25. The search field moves down under it, and the sky mark stays 140
     down.

### What it does not build

- Feedback (D121 item 4: a later branch, with a server change), Region (none, main-path.md), Help (R9).
- "What you've told Soul Dreams" (MP·86 to MP·92) and anything kept by Life Context (D121 item 2).
- A Personal painting, or anything sent for an image; the readings.
- Onboarding in the founder or tester apps (D103 item 1). Every file of this branch is reached from SoulDreams Dev
  only (`dev_only_test.dart`).
- No new package, no Swift, server, guard or settings change.

### The decisions, by number

- D110 (head's message 24): Settings' rows, the three consents, "Withdraw consent" as a private journal, Delete
  journal (one confirmation, everything goes, back to the welcome).
- D121 (owner, the brainstorm): (1) Language shown, English only; (2) the Life Context rows shown and remembered now;
  (3) Night images: Off the gradient, Personal and Random the curated set; (4) Feedback later; (5) withdrawn: nothing
  leaves the phone, recording paused, nights kept.
- D122 (owner, "all fine"): the stop's every lean. Q1 (B): the shown-lines test covers what the tester and founder
  apps reach, and Dev shows MP·68 and MP·70 with their braces. Q2 to Q11: built as leaned and sent to Product
  (`.scratch/for-build-chat/redesign-c-product-questions.md`). Q12 to Q14: storage, the lines' reader, the look as
  stand-ins.
- D91, D95, D67 (a row whose code moved follows it).

### Decided under D91 (how to build only)

1. **The consents' record keeps a day, not an instant**: the UTC day of each answer's last change, so nothing finer
   than a day is kept about when the dreamer used the app. Version 1 has no day; the record keeps none until that
   answer changes.
2. **Night images' choice is kept apart from consent (c)**: Off is (c) not given; Personal or Random is the
   choice kept for when it is. Choosing Off keeps the choice, so giving (c) again returns it.
3. **The mode lives above the app** (`NightDayChoice`, beside `AlwaysLight`), since the theme is chosen above every
   page. The journal's home sets it from the settings, and back to Automatic when the journal is deleted.
4. **Word Animation stays a global** (`wordAnimation`, `app_line.dart`), which the journal's home sets from the
   settings, and back to on when the journal is deleted.
5. **The quick toggle shows the sun in the light theme and the moon in the dark** (the sky mark's own drawing), in a
   41 bordered circle.
6. **A second "I consent" after the journal opened** keeps one journal with its one settings (the review of D103's
   guard, carried: row A303's test now also checks the settings are the same).
7. **No row for `JournalPage.didUpdateWidget`** moving the list's listener to a new recording's retries: proving it
   needs a retry finishing after a consent given again, a constructed sequence (D17). Banked.

### The places this branch uses

All filed (C18-P), and none new:
- **Settings:** MP·25 (the gear's spoken name, and the title), EM·9, MP·26, MP·85, MP·44, MP·83, MP·84, MP·45,
  MP·48, MP·95, EM·11.
- **The confirmations:** MP·96 with MP·97; MP·93 with MP·94; C4-P·4 with MP·60; MP·61 in each.
- **The consents:** MP·66, MP·67, MP·68, MP·69, MP·70; Next (MP·30) and EM·6 as before.

MP·68 and MP·70 are "to rewrite", shown as filed, braces included, in SoulDreams Dev only (D122).

Owed, shown as a visible placeholder (R1): the language's name, `[owed·language]` (Product, item 4 of
`.scratch/for-build-chat/redesign-c-product-questions.md`).

### The tests (test-first, on the Mac)

Every task adds its tests before its code. Each task's new and changed tests were put on the tree before it and
failed, except Task 6's Dev-only assertions, which pin what Tasks 2 to 5 built; its rows show they bite (Part 5).
Each assertion is shown to bite by its row.

App tests: 613 at the start, then 614, 629, 631, 637, 649, 649.

App mutation rows (514 to 583):
- **New:** 74, A497 to A570.
- **Dropped:** 5, A277, A278, A281, A300, A507, each with its reason in the file.
- **Following their code** (D67): 20, A34, A275, A276, A279, A280, A291, A293, A296, A298, A299, A303, A304, A376,
  A382, A443, A473, A480, A508, A539, A542. The tests of A297 and A303 also gained a check.

No guard change. The by-eye review on the phone is the owner's (Task 7).

## Part 2 · Settings, packages and storage

- **Packages and settings:** no new package, and no change to settings, Swift, the server, AWS, Soniox or the guards.
- **Storage** (R11; docs/workflow.md (c)): `consent.json` goes to version 2, and `settings.json` is new.
  - **Step 1 is Task 1's tests:** a folder holding invented nights, a waiting recording's audio, the first-use flag
    and a version 1 consent reads as before, and keeps every other file byte for byte when version 2 is written. The
    settings file is the same.
  - **Step 2** is the owner's rehearsal in SoulDreams Dev (Task 7, item 1).
  - **Steps 3 to 5** apply when the founder app gains onboarding and Settings (D103 item 1). Until then, nothing of
    this reaches the Cohort 0 app (`dev_only_test.dart`).

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
- The task's rows (D95): `python3 -I -B tool/app_mutations.py <the task's selection>`, every one caught.
- The hook prints `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `redesign-c`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- nothing from `git status`;
- this plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+613: All tests passed!`.

Anything else: stop (R14).

### Task 1 · Storage: the three consents and the settings file (D122; docs/workflow.md (c))

`settings/consents.dart`:
- `Consent` (readings, lifeContext, images), `Answer` (given, and the UTC day of its last change), `Consents`.
- The file's version 2. Version 1 reads as (a) given and (b) and (c) not, with no day. Anything else is none.

`settings/settings.dart`: `Settings` (Word Animation, Night/Day mode, Night images' choice, Life Context length),
version 1. `NightDayMode` goes in `core/night_day.dart`.

`journal_store.dart`: `consents`, `keepConsents`, `settings`, `keepSettings`, each written whole and renamed.
`consented`, `keepConsent` and `withdrawConsent` are gone.

`journal.dart`: the same four. `consentGone` moves only on deletion.

`journal_home.dart`: reads the consents. Onboarding's single "I consent" keeps (a) given and (b) and (c) not given,
until Task 4.

Tests:
- `journal_store_test.dart`: version 1 reads and version 2 replaces it with no night changed; files that do not read
  exactly; a keep cut short, for both files; the deletion takes both.
- `journal_test.dart`: a withdrawal is an answer kept, with nothing told.
- `journal_home_test.dart`: the version 2 file written. The withdrawal tests go to the deletion: D110 now returns to
  the start only then.

Rows:
- New: A497 to A506 and A508.
- Following their code into `consents.dart`, or their renamed tests: A275, A276, A279, A280, A296, A299, A304.
- Dropped: A277, A278 and A281 (the withdrawal that removed the file), and A300 (the deletion takes the audio too, so
  no retry can follow; Task 2's A518 holds the cut).

Expected: 614 app tests; `python3 -I -B tool/app_mutations.py --files lib/settings/consents.dart,lib/settings/settings.dart,lib/journal/journal_store.dart,lib/journal/journal.dart,lib/journal/pages/journal_home.dart`, every one caught. Commit:

> Storage: the three consents (version 2, version 1 still read) and the settings file (D122; workflow (c))

**The block:**

~~~~diff
diff --git a/app/lib/core/night_day.dart b/app/lib/core/night_day.dart
index 6caa264..b84a16f 100644
--- a/app/lib/core/night_day.dart
+++ b/app/lib/core/night_day.dart
@@ -11,6 +11,10 @@ import 'dart:async';
 
 import 'package:flutter/material.dart';
 
+/// Night/Day mode (MP·44): Automatic, or Manual, Day or Night
+/// (main-path.md, Settings).
+enum NightDayMode { automatic, day, night }
+
 /// Dark from 21:00 to 08:00, by the wall clock.
 bool isNightAt(DateTime local) => local.hour >= 21 || local.hour < 8;
 
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
index 266d839..05c5312 100644
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -6,9 +6,10 @@
 // - An edit replaces a dream's text. An emptied dream disappears and the
 //   night's other dreams remain (D58 Q3); a night left with no dream is
 //   deleted, as a deletion deletes it (P10).
-// - The consent (D103) is kept, read and withdrawn here; when it goes,
-//   withdrawn or deleted with the journal, `consentGone` tells the app,
-//   which returns to its start (D103 item 4).
+// - The three consents and the settings (D103; D122) are kept and read
+//   here. When the journal is deleted, they go with it, and `consentGone`
+//   tells the app, which returns to its start (D110). A consent withdrawn
+//   is an answer kept, and the app stays (D121 item 5).
 // - A dream is told in words or waits as a recording (D93 Q2); a dream's
 //   index counts both, and a waiting one is never edited. A Save puts the
 //   recordings its screen left waiting after its words, in order; a Save
@@ -17,6 +18,8 @@ import 'dart:math';
 
 import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier, listEquals;
 
+import '../settings/consents.dart';
+import '../settings/settings.dart';
 import '../words/lines.g.dart' show Lang;
 import 'journal_store.dart';
 import 'night.dart';
@@ -121,26 +124,25 @@ final class Journal {
 
   Future<void> markFirstUseSeen() => _store.markFirstUseSeen();
 
-  /// Whether the dreamer has agreed to the disclosure, as one 18 or over.
-  Future<bool> consented() => _store.consented();
+  /// The consents answered in onboarding, or null when none is kept.
+  Future<Consents?> consents() => _store.consents();
 
-  /// Keeps the consent given in onboarding (D103).
-  Future<void> keepConsent() => _store.keepConsent();
+  /// Keeps the consents (D122).
+  Future<void> keepConsents(Consents consents) => _store.keepConsents(consents);
 
-  /// Moves on each time the consent goes, withdrawn or deleted with the
-  /// journal: the app returns to its start (D103 item 4).
+  /// The settings kept, or null when none is.
+  Future<Settings?> settings() => _store.settings();
+
+  /// Keeps the settings (D122).
+  Future<void> keepSettings(Settings settings) => _store.keepSettings(settings);
+
+  /// Moves on each time the journal is deleted, the consents with it: the
+  /// app returns to its start (D110).
   ValueListenable<int> get consentGone => _consentGone;
   final _consentGone = ValueNotifier<int>(0);
 
-  /// Withdraws the consent; the nights stay. Then the app returns to its
-  /// start (D103 item 4).
-  Future<void> withdrawConsent() async {
-    await _store.withdrawConsent();
-    _consentGone.value++;
-  }
-
-  /// Deletes the whole journal, the consent and the first-use flag with it
-  /// (X11; D54). Then the app returns to its start (D103 item 4).
+  /// Deletes the whole journal, the consents, the settings and the first-use
+  /// flag with it (X11; D54). Then the app returns to its start (D110).
   Future<void> deleteAll() async {
     await _store.deleteAll();
     _consentGone.value++;
diff --git a/app/lib/journal/journal_store.dart b/app/lib/journal/journal_store.dart
index 03c9add..15e3830 100644
--- a/app/lib/journal/journal_store.dart
+++ b/app/lib/journal/journal_store.dart
@@ -20,16 +20,20 @@
 // open, audio no night names is deleted, and so is an older copy left by
 // a cut that did not finish.
 //
-// The dreamer's consent (D103) is kept here too, once given in onboarding:
-// one small file saying only that the dreamer agreed and is 18 or over,
-// never the age band (C146-I item 1). Deleting the journal takes it, and
-// so does a withdrawal, and either returns the app to its start.
+// The dreamer's three consents (D103; C159-I item 5; D122) are kept here
+// too, once answered in onboarding: one small file holding each answer and
+// the day it last changed, and that the dreamer is 18 or over, never the
+// age band (C146-I item 1) (`settings/consents.dart`). So are the settings
+// (`settings/settings.dart`). Deleting the journal takes both, and returns
+// the app to its start; a consent withdrawn is an answer, kept (D121 item 5).
 import 'dart:convert';
 import 'dart:typed_data';
 
 import 'package:flutter/foundation.dart' show visibleForTesting;
 
 import '../core/safe_log.dart';
+import '../settings/consents.dart';
+import '../settings/settings.dart';
 import 'journal_files.dart';
 import 'night.dart';
 
@@ -55,10 +59,13 @@ final class JournalStore {
   /// (MP·10, then MP·32); removed with the journal (D49 c, O6).
   static const firstUseFlag = 'first-use-seen';
 
-  /// Kept once the dreamer has agreed to the disclosure, as one 18 or over
-  /// (D103); removed with the journal, or by a withdrawal (D103 item 4).
+  /// Kept once the dreamer has answered the three consents, as one 18 or
+  /// over (D103; D122); removed with the journal.
   static const consentFile = 'consent.json';
 
+  /// The settings, once one is changed (D122); removed with the journal.
+  static const settingsFile = 'settings.json';
+
   // The one queue (D54): each operation starts when the one before it,
   // whether it succeeded or failed, has finished. No operation calls
   // another queued one.
@@ -283,27 +290,23 @@ final class JournalStore {
 
   Future<void> markFirstUseSeen() => _run(() => _files.write(firstUseFlag, Uint8List(0)));
 
-  /// Whether the dreamer has agreed, as one 18 or over: the file holds
-  /// exactly that, or it is no consent and onboarding asks again.
-  Future<bool> consented() => _run(() async {
+  /// The consents, or null when none is kept or the file does not read as
+  /// version 1 or 2 exactly: onboarding then asks again.
+  Future<Consents?> consents() => _run(() async {
     final bytes = await _files.read(consentFile);
-    if (bytes == null) return false;
-    try {
-      final json = jsonDecode(utf8.decode(bytes));
-      return json is Map<String, dynamic> && json.length == 2 && json['version'] == 1 && json['over18'] == true;
-    } on FormatException {
-      return false;
-    }
+    return bytes == null ? null : decodeConsents(bytes);
   });
 
-  /// Keeps the consent: that the dreamer agreed, and is 18 or over.
-  Future<void> keepConsent() =>
-      _run(() => _whole(consentFile, utf8.encode(jsonEncode(const {'version': 1, 'over18': true}))));
+  /// Keeps the consents whole (version 2), replacing any before.
+  Future<void> keepConsents(Consents consents) => _run(() => _whole(consentFile, encodeConsents(consents)));
 
-  /// Removes the consent, and any temporary file of its keeping; the
-  /// nights stay (D103 item 4).
-  Future<void> withdrawConsent() => _run(() async {
-    await _files.delete(consentFile);
-    await _files.delete(tempPrefix + consentFile);
+  /// The settings, or null when none is kept or the file does not read as
+  /// version 1 exactly: the defaults then stand.
+  Future<Settings?> settings() => _run(() async {
+    final bytes = await _files.read(settingsFile);
+    return bytes == null ? null : decodeSettings(bytes);
   });
+
+  /// Keeps the settings whole, replacing any before.
+  Future<void> keepSettings(Settings settings) => _run(() => _whole(settingsFile, encodeSettings(settings)));
 }
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index 17722eb..0e05bf3 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -3,9 +3,9 @@
 // (D103), held in the light theme, and then the journal list; the first
 // time, the journal list's first empty state (main-path.md, Onboarding, 5).
 // Nothing leaves the phone before the consent: the recording and its
-// retries start only with the journal. When the consent goes, withdrawn or
-// deleted with the journal, it returns to onboarding's start, closing every
-// page above it (D103 item 4). Until the folder is
+// retries start only with the journal. When the journal is deleted, the
+// consents with it, it returns to onboarding's start, closing every page
+// above it (D110). Until the folder is
 // open the page is blank; if it cannot be opened it stays blank and logs
 // a code, never a night's words (R3). A phone check it is handed (D65)
 // finishes first, so its probe never shows as a row. The recording it is
@@ -21,6 +21,7 @@ import '../../core/always_light.dart';
 import '../../core/safe_log.dart';
 import '../../onboarding/onboarding.dart';
 import '../../recording/recording.dart';
+import '../../settings/consents.dart';
 import '../journal.dart';
 import '../journal_audio.dart';
 import '../journal_files.dart';
@@ -109,7 +110,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     final journal = Journal(store)..consentGone.addListener(_restart);
     bool agreed;
     try {
-      agreed = await journal.consented();
+      agreed = await journal.consents() != null;
     } on Object {
       // Asked again: nothing is shown as agreed that is not kept.
       SafeLog.event(LogEvent.consentReadFailed);
@@ -144,13 +145,16 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     _recording?.retries?.kick();
   }
 
-  // "I agree": the consent kept, then the journal. A consent that cannot be
-  // kept logs a code; the journal opens, and the next opening asks again.
+  // "I consent": the consents kept, then the journal. Until onboarding asks
+  // the three (D119 item 1), it gives (a) and leaves (b) and (c) not given
+  // (D122). Consents that cannot be kept log a code; the journal opens, and
+  // the next opening asks again.
   Future<void> _agree() async {
     if (_agreeing) return;
     _agreeing = true;
     try {
-      await _journal!.keepConsent();
+      final journal = _journal!;
+      await journal.keepConsents(Consents.answered({Consent.readings: true}, journal.now()));
     } on Object {
       SafeLog.event(LogEvent.consentKeepFailed);
     }
@@ -159,8 +163,8 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     if (mounted) _enter(first: true);
   }
 
-  // The consent gone (D103 item 4): every page above closes, the retries
-  // stop, and onboarding starts again.
+  // The journal deleted, the consents with it (D110): every page above
+  // closes, the retries stop, and onboarding starts again.
   void _restart() {
     if (!mounted) return;
     _recording?.retries?.dispose();
diff --git a/app/lib/settings/consents.dart b/app/lib/settings/consents.dart
new file mode 100644
index 0000000..5e26014
--- /dev/null
+++ b/app/lib/settings/consents.dart
@@ -0,0 +1,105 @@
+// The three consents (C159-I item 5; C18-P, MP·66 to MP·70; D122), in
+// plain Dart: the readings (a), Life Context (b) and the night images (c),
+// each given or not, none given beforehand. The record kept on the phone
+// (D122, the stop's question 10): each consent's answer and the UTC day it
+// last changed, and that the dreamer is 18 or over (D103); no identifier
+// and never the age band (C146-I item 1). Version 1, D103's one consent,
+// still reads: as (a) given and (b) and (c) not given, with no day (D122,
+// the stop's question 12).
+import 'dart:convert';
+import 'dart:typed_data';
+
+enum Consent { readings, lifeContext, images }
+
+/// One consent's answer, and the UTC day of its last change
+/// (`YYYY-MM-DD`), or null when that is not known (read from version 1).
+final class Answer {
+  const Answer(this.given, [this.day]);
+
+  final bool given;
+  final String? day;
+
+  @override
+  bool operator ==(Object other) => other is Answer && other.given == given && other.day == day;
+
+  @override
+  int get hashCode => Object.hash(given, day);
+}
+
+/// The UTC day of [instant], as the record keeps it.
+String dayOf(DateTime instant) {
+  final u = instant.toUtc();
+  String two(int n) => n.toString().padLeft(2, '0');
+  return '${u.year.toString().padLeft(4, '0')}-${two(u.month)}-${two(u.day)}';
+}
+
+/// The three answers, every consent answered.
+final class Consents {
+  Consents(Map<Consent, Answer> answers) : answers = Map.unmodifiable(answers) {
+    if (answers.length != Consent.values.length) throw ArgumentError('answers');
+  }
+
+  /// Each consent [given] or not, all on the day of [now].
+  factory Consents.answered(Map<Consent, bool> given, DateTime now) =>
+      Consents({for (final c in Consent.values) c: Answer(given[c] ?? false, dayOf(now))});
+
+  final Map<Consent, Answer> answers;
+
+  bool given(Consent consent) => answers[consent]!.given;
+
+  /// The same, with [consent] [given] or not on the day of [now]; the others
+  /// as they were.
+  Consents withAnswer(Consent consent, bool given, DateTime now) =>
+      Consents({...answers, consent: Answer(given, dayOf(now))});
+
+  @override
+  bool operator ==(Object other) =>
+      other is Consents && Consent.values.every((c) => other.answers[c] == answers[c]);
+
+  @override
+  int get hashCode => Object.hashAll([for (final c in Consent.values) answers[c]]);
+}
+
+final _day = RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
+
+/// The file's bytes: version 2.
+Uint8List encodeConsents(Consents consents) => utf8.encode(
+  jsonEncode({
+    'version': 2,
+    'over18': true,
+    for (final c in Consent.values)
+      c.name: {'given': consents.answers[c]!.given, 'day': ?consents.answers[c]!.day},
+  }),
+);
+
+/// The consents [bytes] hold, or null when they hold none: version 2
+/// exactly, or version 1 exactly (D103), else nothing, and onboarding asks
+/// again.
+Consents? decodeConsents(Uint8List bytes) {
+  final Object? json;
+  try {
+    json = jsonDecode(utf8.decode(bytes));
+  } on FormatException {
+    return null;
+  }
+  if (json is! Map<String, dynamic> || json['over18'] != true) return null;
+  if (json['version'] == 1 && json.length == 2) {
+    return Consents({
+      Consent.readings: const Answer(true),
+      Consent.lifeContext: const Answer(false),
+      Consent.images: const Answer(false),
+    });
+  }
+  if (json['version'] != 2 || json.length != 2 + Consent.values.length) return null;
+  final answers = <Consent, Answer>{};
+  for (final c in Consent.values) {
+    final a = json[c.name];
+    if (a is! Map<String, dynamic>) return null;
+    final given = a['given'];
+    final day = a['day'];
+    if (given is! bool || a.length != (a.containsKey('day') ? 2 : 1)) return null;
+    if (a.containsKey('day') && (day is! String || !_day.hasMatch(day))) return null;
+    answers[c] = Answer(given, day as String?);
+  }
+  return Consents(answers);
+}
diff --git a/app/lib/settings/settings.dart b/app/lib/settings/settings.dart
new file mode 100644
index 0000000..1e7f565
--- /dev/null
+++ b/app/lib/settings/settings.dart
@@ -0,0 +1,94 @@
+// What the dreamer sets for themselves (main-path.md, Settings; C18-P,
+// MP·26, MP·44, MP·84, MP·85; D110; D121; D122), in plain Dart, kept on the
+// phone in the journal's folder (R11; docs/workflow.md (c)): Word Animation,
+// on by default (D110); Night/Day mode, Automatic by default, or Manual,
+// Day or Night; which painting Night images shows while consent (c) is
+// given, Personal by default (D122, the stop's question 7); Life Context's
+// length, 2 weeks by default (C159-I item 1), remembered now and used once
+// Life Context is built (D121 item 2). Whether Life Context is on, and
+// whether Night images is Off, are consents (b) and (c), kept with the
+// consents (`consents.dart`), never here.
+import 'dart:convert';
+import 'dart:typed_data';
+
+import '../core/night_day.dart';
+
+/// Night images (MP·85): Off is consent (c) not given.
+enum NightImages { personal, random, off }
+
+/// Life Context length (MP·84), in its order.
+enum LifeContextLength { oneWeek, twoWeeks, oneMonth, threeMonths }
+
+final class Settings {
+  const Settings({
+    this.wordAnimation = true,
+    this.nightDay = NightDayMode.automatic,
+    this.images = NightImages.personal,
+    this.length = LifeContextLength.twoWeeks,
+  }) : assert(images != NightImages.off);
+
+  final bool wordAnimation;
+  final NightDayMode nightDay;
+
+  /// The painting chosen for while consent (c) is given: never Off.
+  final NightImages images;
+
+  final LifeContextLength length;
+
+  Settings copyWith({bool? wordAnimation, NightDayMode? nightDay, NightImages? images, LifeContextLength? length}) =>
+      Settings(
+        wordAnimation: wordAnimation ?? this.wordAnimation,
+        nightDay: nightDay ?? this.nightDay,
+        images: images ?? this.images,
+        length: length ?? this.length,
+      );
+
+  @override
+  bool operator ==(Object other) =>
+      other is Settings &&
+      other.wordAnimation == wordAnimation &&
+      other.nightDay == nightDay &&
+      other.images == images &&
+      other.length == length;
+
+  @override
+  int get hashCode => Object.hash(wordAnimation, nightDay, images, length);
+}
+
+/// The file's bytes: version 1.
+Uint8List encodeSettings(Settings s) => utf8.encode(
+  jsonEncode({
+    'version': 1,
+    'wordAnimation': s.wordAnimation,
+    'nightDay': s.nightDay.name,
+    'images': s.images.name,
+    'length': s.length.name,
+  }),
+);
+
+T? _named<T extends Enum>(List<T> values, Object? name) {
+  for (final v in values) {
+    if (v.name == name) return v;
+  }
+  return null;
+}
+
+/// The settings [bytes] hold, or null when they do not read as version 1
+/// exactly.
+Settings? decodeSettings(Uint8List bytes) {
+  final Object? json;
+  try {
+    json = jsonDecode(utf8.decode(bytes));
+  } on FormatException {
+    return null;
+  }
+  if (json is! Map<String, dynamic> || json.length != 5 || json['version'] != 1) return null;
+  final animation = json['wordAnimation'];
+  final nightDay = _named(NightDayMode.values, json['nightDay']);
+  final images = _named(NightImages.values, json['images']);
+  final length = _named(LifeContextLength.values, json['length']);
+  if (animation is! bool || nightDay == null || images == null || images == NightImages.off || length == null) {
+    return null;
+  }
+  return Settings(wordAnimation: animation, nightDay: nightDay, images: images, length: length);
+}
diff --git a/app/test/journal/journal_store_test.dart b/app/test/journal/journal_store_test.dart
index 870c00f..8a15236 100644
--- a/app/test/journal/journal_store_test.dart
+++ b/app/test/journal/journal_store_test.dart
@@ -9,9 +9,12 @@ import 'dart:io';
 
 import 'package:flutter/foundation.dart';
 import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/night_day.dart';
 import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/journal/journal_store.dart';
 import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
 
 import '../fixtures.dart';
 import 'io_journal_files.dart';
@@ -421,10 +424,12 @@ void main() {
     expect(await store.firstUseSeen(), isFalse);
   });
 
-  // D103; docs/workflow.md (c): the consent sits beside the nights, holds
-  // only that the dreamer is 18 or over (C146-I item 1), changes no night,
-  // the first-use flag or any audio, and survives the sweep at open.
-  test('the consent is kept beside the nights, changing none of them', () async {
+  // D103; D122; docs/workflow.md (c): the consents sit beside the nights,
+  // hold only that the dreamer is 18 or over (C146-I item 1) and the three
+  // answers, change no night, the first-use flag or any audio, and survive
+  // the sweep at open. The version 1 file (D103) reads as (a) given, (b) and
+  // (c) not given; keeping version 2 over it loses no night.
+  test('version 1 reads; version 2 replaces it, changing no night', () async {
     final store = await JournalStore.open(files);
     final nights = nightsFromFixtures();
     for (final n in nights) {
@@ -434,22 +439,38 @@ void main() {
     await store.save(nights.first.withEntries([...nights.first.entries, Waiting(x)]));
     await store.appendAudio(x, sound(64));
     await store.markFirstUseSeen();
+    expect(await store.consents(), isNull);
+    await files.write(JournalStore.consentFile, utf8.encode('{"version":1,"over18":true}'));
     final before = files.everything();
-    expect(await store.consented(), isFalse);
-    await store.keepConsent();
-    expect(await store.consented(), isTrue);
+    final old = await store.consents();
+    expect(old!.given(Consent.readings), isTrue);
+    expect(old.given(Consent.lifeContext), isFalse);
+    expect(old.given(Consent.images), isFalse);
+    expect(old.answers[Consent.readings]!.day, isNull);
+    final now = DateTime.utc(2026, 11, 21, 22, 30);
+    final next = old.withAnswer(Consent.images, true, now);
+    await store.keepConsents(next);
     final reopened = await JournalStore.open(files);
-    expect(await reopened.consented(), isTrue);
+    expect(await reopened.consents(), next);
     final after = files.everything();
-    expect(after.keys.toSet(), {...before.keys, JournalStore.consentFile});
-    before.forEach((name, bytes) => expect(listEquals(after[name], bytes), isTrue, reason: name));
-    expect(jsonDecode(utf8.decode(after[JournalStore.consentFile]!)), {'version': 1, 'over18': true});
+    expect(after.keys.toSet(), before.keys.toSet());
+    for (final name in before.keys.where((n) => n != JournalStore.consentFile)) {
+      expect(listEquals(after[name], before[name]), isTrue, reason: name);
+    }
+    expect(jsonDecode(utf8.decode(after[JournalStore.consentFile]!)), {
+      'version': 2,
+      'over18': true,
+      'readings': {'given': true},
+      'lifeContext': {'given': false},
+      'images': {'given': true, 'day': '2026-11-21'},
+    });
     expect((await reopened.nights()).length, nights.length);
     expect(lines, isEmpty);
   });
 
-  test('an unreadable consent file is no consent; agreeing replaces it', () async {
+  test('a consents file that does not read exactly is none', () async {
     final store = await JournalStore.open(files);
+    const a = '"readings":{"given":true},"lifeContext":{"given":false},"images":{"given":false}';
     for (final bad in [
       '',
       'x',
@@ -458,49 +479,105 @@ void main() {
       '{"version":1}',
       '{"over18":true}',
       '{"version":1,"over18":false}',
-      '{"version":2,"over18":true}',
+      '{"version":3,"over18":true}',
       '{"version":1,"over18":true,"x":1}',
+      '{"version":2,"over18":true}',
+      '{"version":2,"over18":false,$a}',
+      '{"version":2,$a}',
+      '{"version":2,"over18":true,$a,"x":1}',
+      '{"version":2,"over18":true,"readings":{"given":true},"lifeContext":{"given":false}}',
+      '{"version":2,"over18":true,"readings":{"given":1},"lifeContext":{"given":false},"images":{"given":false}}',
+      '{"version":2,"over18":true,"readings":{},"lifeContext":{"given":false},"images":{"given":false}}',
+      '{"version":2,"over18":true,"readings":{"given":true,"x":1},"lifeContext":{"given":false},"images":{"given":false}}',
+      '{"version":2,"over18":true,"readings":{"given":true,"day":"21/11/26"},"lifeContext":{"given":false},"images":{"given":false}}',
+      '{"version":2,"over18":true,"readings":{"given":true,"day":7},"lifeContext":{"given":false},"images":{"given":false}}',
     ]) {
       await files.write(JournalStore.consentFile, utf8.encode(bad));
-      expect(await store.consented(), isFalse, reason: bad);
+      expect(await store.consents(), isNull, reason: bad);
     }
     await files.write(JournalStore.consentFile, Uint8List.fromList([0xff, 0xfe]));
-    expect(await store.consented(), isFalse);
-    await store.keepConsent();
-    expect(await store.consented(), isTrue);
+    expect(await store.consents(), isNull);
+    await files.write(JournalStore.consentFile, utf8.encode('{"version":2,"over18":true,$a}'));
+    expect((await store.consents())!.given(Consent.readings), isTrue);
+    final c = Consents.answered({Consent.lifeContext: true}, DateTime.utc(2026, 1, 2));
+    await store.keepConsents(c);
+    expect(await store.consents(), c);
   });
 
-  test('a consent cut short leaves no consent and no temporary file', () async {
+  test('consents cut short leave none and no temporary file', () async {
     final store = await JournalStore.open(BrokenRename(files.dir));
-    await expectLater(store.keepConsent(), throwsA(isA<FileSystemException>()));
+    await expectLater(
+      store.keepConsents(Consents.answered({}, DateTime.utc(2026))),
+      throwsA(isA<FileSystemException>()),
+    );
     expect(files.everything(), isEmpty);
-    expect(await store.consented(), isFalse);
+    expect(await store.consents(), isNull);
   });
 
-  // D103 item 4: withdrawing removes the consent alone; deleting the journal
-  // takes it with everything else.
-  test('withdrawing the consent removes it alone', () async {
+  // D122; docs/workflow.md (c): the settings sit beside the nights, change
+  // none of them, and read back exactly; a file that does not read is none,
+  // and the defaults stand.
+  test('the settings are kept beside the nights, changing none of them', () async {
     final store = await JournalStore.open(files);
     for (final n in nightsFromFixtures()) {
       await store.save(n);
     }
-    await store.markFirstUseSeen();
+    await store.keepConsents(Consents.answered({Consent.readings: true}, DateTime.utc(2026)));
     final before = files.everything();
-    await store.keepConsent();
-    await files.write('${JournalStore.tempPrefix}${JournalStore.consentFile}', utf8.encode('x'));
-    await store.withdrawConsent();
-    expect(await store.consented(), isFalse);
+    expect(await store.settings(), isNull);
+    const s = Settings(wordAnimation: false, nightDay: NightDayMode.night, images: NightImages.random, length: LifeContextLength.threeMonths);
+    await store.keepSettings(s);
+    expect(await (await JournalStore.open(files)).settings(), s);
     final after = files.everything();
-    expect(after.keys.toSet(), before.keys.toSet());
+    expect(after.keys.toSet(), {...before.keys, JournalStore.settingsFile});
     before.forEach((name, bytes) => expect(listEquals(after[name], bytes), isTrue, reason: name));
+    expect(jsonDecode(utf8.decode(after[JournalStore.settingsFile]!)), {
+      'version': 1,
+      'wordAnimation': false,
+      'nightDay': 'night',
+      'images': 'random',
+      'length': 'threeMonths',
+    });
+    expect(lines, isEmpty);
+  });
+
+  test('a settings file that does not read exactly is none', () async {
+    final store = await JournalStore.open(files);
+    const good = '"wordAnimation":true,"nightDay":"automatic","images":"personal","length":"twoWeeks"';
+    for (final bad in [
+      '',
+      '[]',
+      '{"version":1}',
+      '{"version":2,$good}',
+      '{"version":1,$good,"x":1}',
+      '{"version":1,"wordAnimation":1,"nightDay":"automatic","images":"personal","length":"twoWeeks"}',
+      '{"version":1,"wordAnimation":true,"nightDay":"manual","images":"personal","length":"twoWeeks"}',
+      '{"version":1,"wordAnimation":true,"nightDay":"automatic","images":"off","length":"twoWeeks"}',
+      '{"version":1,"wordAnimation":true,"nightDay":"automatic","images":"personal","length":"forever"}',
+    ]) {
+      await files.write(JournalStore.settingsFile, utf8.encode(bad));
+      expect(await store.settings(), isNull, reason: bad);
+    }
+    await files.write(JournalStore.settingsFile, utf8.encode('{"version":1,$good}'));
+    expect(await store.settings(), const Settings());
+  });
+
+  test('settings cut short leave none and no temporary file', () async {
+    final store = await JournalStore.open(BrokenRename(files.dir));
+    await expectLater(store.keepSettings(const Settings()), throwsA(isA<FileSystemException>()));
+    expect(files.everything(), isEmpty);
   });
 
-  test('deleting the journal takes the consent', () async {
+  // X11; D54; D110: deleting the journal takes the consents and the
+  // settings with everything else.
+  test('deleting the journal takes the consents and the settings', () async {
     final store = await JournalStore.open(files);
     await store.save(nightsFromFixtures().first);
-    await store.keepConsent();
+    await store.keepConsents(Consents.answered({Consent.readings: true}, DateTime.utc(2026)));
+    await store.keepSettings(const Settings(wordAnimation: false));
     await store.deleteAll();
-    expect(await store.consented(), isFalse);
+    expect(await store.consents(), isNull);
+    expect(await store.settings(), isNull);
     expect(files.everything(), isEmpty);
   });
 
diff --git a/app/test/journal/journal_test.dart b/app/test/journal/journal_test.dart
index 96ba51e..06e2ddf 100644
--- a/app/test/journal/journal_test.dart
+++ b/app/test/journal/journal_test.dart
@@ -10,6 +10,8 @@ import 'package:souldreams/journal/journal.dart';
 import 'package:souldreams/journal/journal_store.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_rules.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
 import 'package:souldreams/words/lines.g.dart' show Lang;
 
 import '../fixtures.dart';
@@ -34,31 +36,38 @@ void main() {
 
   tearDown(() => dir.deleteSync(recursive: true));
 
-  // D103 item 4: the consent kept, withdrawn or deleted with the journal;
-  // each going is told once, so the app returns to its start.
-  test('withdrawing the consent keeps every night, and is told', () async {
+  // D121 item 5; D122: a consent withdrawn is an answer kept, every night
+  // stays, and nothing is told; the app stays where it is.
+  test('a consent withdrawn keeps every night, and tells nothing', () async {
     await journal.addDream(await journal.targetNow(), a[0], Lang.en);
     var told = 0;
     journal.consentGone.addListener(() => told++);
-    expect(await journal.consented(), isFalse);
-    await journal.keepConsent();
-    expect(await journal.consented(), isTrue);
+    expect(await journal.consents(), isNull);
+    final given = Consents.answered({Consent.readings: true}, journal.now());
+    await journal.keepConsents(given);
+    expect(await journal.consents(), given);
+    final withdrawn = given.withAnswer(Consent.readings, false, journal.now());
+    await journal.keepConsents(withdrawn);
+    expect(await journal.consents(), withdrawn);
+    await journal.keepSettings(const Settings(wordAnimation: false));
+    expect(await journal.settings(), const Settings(wordAnimation: false));
     expect(told, 0);
-    await journal.withdrawConsent();
-    expect(await journal.consented(), isFalse);
-    expect(told, 1);
     expect((await journal.newestFirst()).single.dreams, [a[0]]);
   });
 
-  test('deleting the journal takes the consent and every night, told', () async {
+  // D110: deleting the journal takes the consents, the settings and every
+  // night, and is told once, so the app returns to its start.
+  test('deleting the journal takes the consents and every night, told', () async {
     await journal.addDream(await journal.targetNow(), a[0], Lang.en);
-    await journal.keepConsent();
+    await journal.keepConsents(Consents.answered({Consent.readings: true}, journal.now()));
+    await journal.keepSettings(const Settings(wordAnimation: false));
     await journal.markFirstUseSeen();
     var told = 0;
     journal.consentGone.addListener(() => told++);
     await journal.deleteAll();
     expect(told, 1);
-    expect(await journal.consented(), isFalse);
+    expect(await journal.consents(), isNull);
+    expect(await journal.settings(), isNull);
     expect(await journal.firstUseSeen(), isFalse);
     expect(await journal.newestFirst(), isEmpty);
     expect(files.everything(), isEmpty);
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index cc370f4..1a5a629 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -19,6 +19,7 @@ import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/onboarding/onboarding.dart';
 import 'package:souldreams/recording/recording.dart';
+import 'package:souldreams/settings/consents.dart';
 import 'package:souldreams/words/lines.g.dart';
 
 import '../../fixtures.dart';
@@ -52,7 +53,8 @@ final class NoConsentRead extends MemoryJournalFiles {
       name == JournalStore.consentFile ? throw StateError('journal-io') : super.read(name);
 }
 
-/// [files] holding the consent, as "I agree" keeps it (D103).
+/// [files] holding D103's one consent, version 1, which still reads as (a)
+/// given (D122).
 T agreed<T extends MemoryJournalFiles>(T files) {
   files.files[JournalStore.consentFile] = Uint8List.fromList(utf8.encode('{"version":1,"over18":true}'));
   return files;
@@ -266,7 +268,8 @@ void main() {
     expect(files.files.keys, isNot(contains(JournalStore.consentFile)));
   });
 
-  // D103 items 2 and 4: "I agree" keeps the consent, lets the theme go and
+  // D103 item 2; D122: "I consent" keeps the consents, (a) given and (b)
+  // and (c) not (until onboarding asks the three), lets the theme go and
   // opens the first empty journal (main-path.md, Onboarding, 5); only then
   // may a recording waiting be retried.
   testWidgets('I agree keeps the consent, then the journal and its retries', (tester) async {
@@ -286,7 +289,11 @@ void main() {
     expect(find.byType(JournalPage), findsOneWidget);
     expect(tester.widget<JournalPage>(find.byType(JournalPage)).firstTime, isTrue);
     expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
-    expect(utf8.decode(files.files[JournalStore.consentFile]!), '{"version":1,"over18":true}');
+    final kept = jsonDecode(utf8.decode(files.files[JournalStore.consentFile]!)) as Map<String, dynamic>;
+    expect(kept.keys, ['version', 'over18', 'readings', 'lifeContext', 'images']);
+    expect([kept['version'], kept['over18']], [2, true]);
+    expect([for (final c in ['readings', 'lifeContext', 'images']) kept[c]['given']], [true, false, false]);
+    expect(kept['readings']['day'], dayOf(DateTime.now()));
     expect(links, hasLength(1));
     await tester.pumpWidget(const SizedBox());
     await tester.pump(const Duration(seconds: 11));
@@ -319,7 +326,7 @@ void main() {
 
   // The fix above keeps the guard set once agreed; the start-over resets it,
   // so the next onboarding can agree again.
-  testWidgets('after the consent goes, a new I agree opens the journal', (tester) async {
+  testWidgets('after the journal is deleted, a new I consent opens it', (tester) async {
     JournalStore.newQueueForTests();
     final files = MemoryJournalFiles();
     await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
@@ -327,7 +334,7 @@ void main() {
     tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
     await tester.pumpAndSettle();
     expect(find.byType(JournalPage), findsOneWidget);
-    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.withdrawConsent();
+    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.deleteAll();
     await tester.pumpAndSettle();
     expect(find.byType(Onboarding), findsOneWidget);
     tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
@@ -364,10 +371,9 @@ void main() {
     expect(lines, ['consentReadFailed']);
   });
 
-  // D103 item 4: the consent gone, withdrawn or deleted with the journal,
-  // returns the app to its start, whatever page is open, held light again.
+  // D110: the journal deleted, the consents with it, returns the app to its
+  // start, whatever page is open, held light again.
   for (final (how, go) in <(String, Future<void> Function(Journal))>[
-    ('withdrawn', (j) => j.withdrawConsent()),
     ('deleted with the journal', (j) => j.deleteAll()),
   ]) {
     testWidgets('the consent $how: back to the start', (tester) async {
@@ -393,9 +399,9 @@ void main() {
     });
   }
 
-  // D103 item 4: back at the start, nothing is retried until the consent
-  // is given again.
-  testWidgets('the consent withdrawn: the retry cut, none after', (tester) async {
+  // D110: back at the start, nothing is retried until the consent is given
+  // again.
+  testWidgets('the journal deleted: the retry cut, none after', (tester) async {
     JournalStore.newQueueForTests();
     final files = agreed(MemoryJournalFiles());
     await waiting(files);
@@ -404,7 +410,7 @@ void main() {
     await tester.pump();
     await tester.pump();
     expect(links, hasLength(1));
-    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.withdrawConsent();
+    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.deleteAll();
     await tester.pump(const Duration(milliseconds: 150));
     expect(find.byType(Onboarding), findsOneWidget);
     expect(links.single.closed, isTrue);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 35d0b1b..d316099 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1318,34 +1318,22 @@ ROWS = [
      'Offset(StandIns.menuWidth, StandIns.backSize + 8)',
      'Offset(StandIns.menuWidth, StandIns.hitMin + 8)',
      'test/journal/pages/night_page_test.dart', 'the menu opens 8 below the look, on its right edge'),
-    ('A275', 'lib/journal/journal_store.dart',
-     " && json['over18'] == true;",
-     ';',
-     'test/journal/journal_store_test.dart', 'an unreadable consent file is no consent; agreeing replaces it'),
-    ('A276', 'lib/journal/journal_store.dart',
-     ' && json.length == 2',
-     '',
-     'test/journal/journal_store_test.dart', 'an unreadable consent file is no consent; agreeing replaces it'),
-    ('A277', 'lib/journal/journal_store.dart',
-     '    await _files.delete(consentFile);\n',
-     '',
-     'test/journal/journal_store_test.dart', 'withdrawing the consent removes it alone'),
-    ('A278', 'lib/journal/journal_store.dart',
-     '    await _files.delete(tempPrefix + consentFile);\n',
-     '',
-     'test/journal/journal_store_test.dart', 'withdrawing the consent removes it alone'),
-    ('A279', 'lib/journal/journal_store.dart',
-     "const {'version': 1, 'over18': true}",
-     "const {'version': 1, 'over18': true, 'band': 1}",
-     'test/journal/journal_store_test.dart', 'the consent is kept beside the nights, changing none of them'),
+    ('A275', 'lib/settings/consents.dart',
+     " || json['over18'] != true) return null;",
+     ') return null;',
+     'test/journal/journal_store_test.dart', 'a consents file that does not read exactly is none'),
+    ('A276', 'lib/settings/consents.dart',
+     "    'over18': true,\n",
+     "    'over18': false,\n",
+     'test/journal/journal_store_test.dart', 'version 1 reads; version 2 replaces it, changing no night'),
+    ('A279', 'lib/settings/consents.dart',
+     "    'over18': true,\n",
+     "    'over18': true,\n    'band': 1,\n",
+     'test/journal/journal_store_test.dart', 'version 1 reads; version 2 replaces it, changing no night'),
     ('A280', 'lib/journal/journal_store.dart',
      '_run(() => _whole(consentFile, ',
      '_run(() => _files.write(consentFile, ',
-     'test/journal/journal_store_test.dart', 'a consent cut short leaves no consent and no temporary file'),
-    ('A281', 'lib/journal/journal.dart',
-     '    await _store.withdrawConsent();\n    _consentGone.value++;',
-     '    await _store.withdrawConsent();',
-     'test/journal/journal_test.dart', 'withdrawing the consent keeps every night, and is told'),
+     'test/journal/journal_store_test.dart', 'consents cut short leave none and no temporary file'),
     ('A282', 'lib/journal/journal.dart',
      '    await _store.deleteAll();\n    _consentGone.value++;',
      '    await _store.deleteAll();',
@@ -1403,7 +1391,7 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
     ('A296', 'lib/journal/pages/journal_home.dart',
-     '      await _journal!.keepConsent();\n',
+     '      await journal.keepConsents(Consents.answered({Consent.readings: true}, journal.now()));\n',
      '',
      'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
     ('A297', 'lib/journal/pages/journal_home.dart',
@@ -1417,11 +1405,7 @@ ROWS = [
     ('A299', 'lib/journal/pages/journal_home.dart',
      '    Navigator.of(context).popUntil((route) => route.isFirst);\n',
      '',
-     'test/journal/pages/journal_home_test.dart', 'the consent withdrawn: back to the start'),
-    ('A300', 'lib/journal/pages/journal_home.dart',
-     '    _recording?.retries?.dispose();\n    _recording = null;\n',
-     '',
-     'test/journal/pages/journal_home_test.dart', 'the consent withdrawn: the retry cut, none after'),
+     'test/journal/pages/journal_home_test.dart', 'the consent deleted with the journal: back to the start'),
     ('A301', 'lib/journal/pages/journal_page.dart',
      '      if (nights.isNotEmpty) _first = false;\n',
      '',
@@ -1437,7 +1421,7 @@ ROWS = [
     ('A304', 'lib/journal/pages/journal_home.dart',
      '    _agreeing = false;\n    AlwaysLight.hold(context, true);',
      '    AlwaysLight.hold(context, true);',
-     'test/journal/pages/journal_home_test.dart', 'after the consent goes, a new I agree opens the journal'),
+     'test/journal/pages/journal_home_test.dart', 'after the journal is deleted, a new I consent opens it'),
     ('A305', 'lib/main.dart',
      "import 'core/safe_log.dart';\n",
      "import 'core/safe_log.dart';\nimport 'onboarding/age.dart';\n",
@@ -2243,6 +2227,54 @@ ROWS = [
      '    match: _oneLine(text.substring(span.start, span.end)),',
      '    match: _oneLine(text.substring(span.start, span.end)).replaceAll(\'\\u201c\', \'"\'),',
      'test/journal/pages/journal_search_test.dart', 'a typed curly mark finds a straight one, and the reverse'),
+    ('A497', 'lib/settings/consents.dart',
+     "if (json['version'] == 1 && json.length == 2) {",
+     "if (json['version'] == 1) {",
+     'test/journal/journal_store_test.dart', 'a consents file that does not read exactly is none'),
+    ('A498', 'lib/settings/consents.dart',
+     '      Consent.lifeContext: const Answer(false),',
+     '      Consent.lifeContext: const Answer(true),',
+     'test/journal/journal_store_test.dart', 'version 1 reads; version 2 replaces it, changing no night'),
+    ('A499', 'lib/settings/consents.dart',
+     "given is! bool || a.length != (a.containsKey('day') ? 2 : 1)",
+     'given is! bool',
+     'test/journal/journal_store_test.dart', 'a consents file that does not read exactly is none'),
+    ('A500', 'lib/settings/consents.dart',
+     '(day is! String || !_day.hasMatch(day))',
+     '(day is! String)',
+     'test/journal/journal_store_test.dart', 'a consents file that does not read exactly is none'),
+    ('A501', 'lib/settings/consents.dart',
+     ' || json.length != 2 + Consent.values.length) return null;',
+     ') return null;',
+     'test/journal/journal_store_test.dart', 'a consents file that does not read exactly is none'),
+    ('A502', 'lib/settings/consents.dart',
+     "'day': ?consents.answers[c]!.day",
+     "'day': consents.answers[c]!.day",
+     'test/journal/journal_store_test.dart', 'version 1 reads; version 2 replaces it, changing no night'),
+    ('A503', 'lib/settings/consents.dart',
+     '-${two(u.month)}-',
+     '-${two(u.day)}-',
+     'test/journal/journal_store_test.dart', 'version 1 reads; version 2 replaces it, changing no night'),
+    ('A504', 'lib/settings/settings.dart',
+     " || json.length != 5 || json['version'] != 1",
+     " || json['version'] != 1",
+     'test/journal/journal_store_test.dart', 'a settings file that does not read exactly is none'),
+    ('A505', 'lib/settings/settings.dart',
+     ' || images == NightImages.off || ',
+     ' || ',
+     'test/journal/journal_store_test.dart', 'a settings file that does not read exactly is none'),
+    ('A506', 'lib/journal/journal_store.dart',
+     '_run(() => _whole(settingsFile, ',
+     '_run(() => _files.write(settingsFile, ',
+     'test/journal/journal_store_test.dart', 'settings cut short leave none and no temporary file'),
+    ('A507', 'lib/journal/pages/journal_home.dart',
+     'Consents.answered({Consent.readings: true}, journal.now())',
+     'Consents.answered({Consent.readings: false}, journal.now())',
+     'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
+    ('A508', 'lib/settings/consents.dart',
+     'Answer(given[c] ?? false, dayOf(now))',
+     'Answer(given[c] ?? true, dayOf(now))',
+     'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
 ]
 
 
~~~~

### Task 2 · The settings while the journal is open: consent (a), Night images, Word Animation, Night/Day (D121; D122)

`settings/settings_controller.dart`: a change shows at once, then is kept; one not kept logs a code and holds.

`journal_home.dart`:
- Reads the settings, or logs `settingsReadFailed` and keeps the defaults.
- Holds the controller and follows it: Word Animation, `NightDayChoice`, and the recording only while (a) is given.
  Withdrawn, the retry running is cut; given again, the retries resume.
- Deleting the journal resets Word Animation and the mode.

`core/night_day.dart`: `isNight`, `NightDayChoice`, the mode's listener, and Word Animation off making the change
instant. `app.dart` holds the mode.

`night_look.dart`, `journal_page.dart`, `night_page.dart`: `images`. `JournalPage` takes `settings` and moves its
listener to a new recording's retries. `safe_log.dart`: `settingsReadFailed` and `settingsKeepFailed`.

Tests:
- `settings_controller_test.dart` (new): 4 tests.
- `night_day_test.dart`: 3 new; `night_look_test.dart`: 1 new.
- `journal_page_test.dart` and `night_page_test.dart`: 1 new each.
- `journal_home_test.dart`: 5 new, and the second "I consent" test also checks the settings are the same ones.

Rows:
- New: A509 to A531.
- Following their code: A34, A293, A296, A298, A303, A376, A382.

Expected: 629 app tests; `python3 -I -B tool/app_mutations.py --files lib/app.dart,lib/core/night_day.dart,lib/journal/night_look.dart,lib/journal/pages/journal_home.dart,lib/journal/pages/journal_page.dart,lib/journal/pages/night_page.dart,lib/settings/settings_controller.dart,lib/settings/consents.dart,lib/settings/settings.dart,lib/journal/journal_store.dart,lib/journal/journal.dart,lib/core/safe_log.dart`, every one caught. Commit:

> Settings while the journal is open: consent (a) gates recording; Night images, Word Animation, Night/Day Manual (D121, D122)

**The block:**

~~~~diff
diff --git a/app/lib/app.dart b/app/lib/app.dart
index 62e55e2..6a26168 100644
--- a/app/lib/app.dart
+++ b/app/lib/app.dart
@@ -30,27 +30,34 @@ class SoulDreamsApp extends StatefulWidget {
 class _SoulDreamsAppState extends State<SoulDreamsApp> {
   final _light = ValueNotifier<bool>(false);
   bool _wasLight = false;
+  // Night/Day mode, set from the settings (D122); Automatic until then.
+  final _mode = ValueNotifier<NightDayMode>(NightDayMode.automatic);
 
   @override
   void dispose() {
     _light.dispose();
+    _mode.dispose();
     super.dispose();
   }
 
   @override
   Widget build(BuildContext context) {
-    return AlwaysLight(
-      light: _light,
-      child: NightDay(
-        now: widget.clock ?? DateTime.now,
-        builder: (context, mode, fade) => ValueListenableBuilder<bool>(
-          valueListenable: _light,
-          builder: (context, light, _) {
-            // Held light, or let go: at once, never a fade.
-            final held = light != _wasLight;
-            _wasLight = light;
-            return _app(light ? ThemeMode.light : mode, held ? Duration.zero : fade);
-          },
+    return NightDayChoice(
+      mode: _mode,
+      child: AlwaysLight(
+        light: _light,
+        child: NightDay(
+          now: widget.clock ?? DateTime.now,
+          mode: _mode,
+          builder: (context, mode, fade) => ValueListenableBuilder<bool>(
+            valueListenable: _light,
+            builder: (context, light, _) {
+              // Held light, or let go: at once, never a fade.
+              final held = light != _wasLight;
+              _wasLight = light;
+              return _app(light ? ThemeMode.light : mode, held ? Duration.zero : fade);
+            },
+          ),
         ),
       ),
     );
diff --git a/app/lib/core/night_day.dart b/app/lib/core/night_day.dart
index b84a16f..cfb6c4c 100644
--- a/app/lib/core/night_day.dart
+++ b/app/lib/core/night_day.dart
@@ -1,16 +1,20 @@
-// Night/Day mode, Automatic (design-system.md §6; main-path.md, Settings;
-// P14; D56): dark from 21:00, light from 08:00, by the phone's local time
-// now. A change found while the app is open fades over five seconds,
-// easing in and out (head's message 20, item 13); with the phone's Reduce
-// Motion on, or animations disabled, it is instant. A
-// change found at start or on returning to the app is instant (D57 Q15).
-// On iOS, Reduce Motion is its own flag, which MediaQuery does not carry,
-// so it is read from the platform's accessibility features. There is no
-// Settings page yet, so no Manual mode and no Word Animation (P8).
+// Night/Day mode (design-system.md §6; main-path.md, Settings; P14; D56;
+// D122): Automatic, dark from 21:00 and light from 08:00 by the phone's
+// local time now; or Manual, Day or Night, as the dreamer set it. A change
+// found while the app is open fades over five seconds, easing in and out
+// (head's message 20, item 13); with Word Animation off, or the phone's
+// Reduce Motion on, or animations disabled, it is instant. A change found
+// at start or on returning to the app is instant (D57 Q15). On iOS, Reduce
+// Motion is its own flag, which MediaQuery does not carry, so it is read
+// from the platform's accessibility features. The mode lives above the app
+// (`NightDayChoice`), so a page under it can set it.
 import 'dart:async';
 
+import 'package:flutter/foundation.dart' show ValueListenable;
 import 'package:flutter/material.dart';
 
+import 'app_line.dart' show wordAnimation;
+
 /// Night/Day mode (MP·44): Automatic, or Manual, Day or Night
 /// (main-path.md, Settings).
 enum NightDayMode { automatic, day, night }
@@ -18,12 +22,36 @@ enum NightDayMode { automatic, day, night }
 /// Dark from 21:00 to 08:00, by the wall clock.
 bool isNightAt(DateTime local) => local.hour >= 21 || local.hour < 8;
 
+/// Whether [mode] at the wall clock's [local] is dark.
+bool isNight(NightDayMode mode, DateTime local) => switch (mode) {
+  NightDayMode.automatic => isNightAt(local),
+  NightDayMode.day => false,
+  NightDayMode.night => true,
+};
+
+/// The mode, held above the app so a page under it can set it (D122).
+class NightDayChoice extends InheritedWidget {
+  const NightDayChoice({super.key, required this.mode, required super.child});
+
+  final ValueNotifier<NightDayMode> mode;
+
+  /// Sets the mode from a page under it.
+  static void set(BuildContext context, NightDayMode mode) =>
+      context.getInheritedWidgetOfExactType<NightDayChoice>()?.mode.value = mode;
+
+  @override
+  bool updateShouldNotify(NightDayChoice old) => old.mode != mode;
+}
+
 class NightDay extends StatefulWidget {
-  const NightDay({super.key, required this.now, required this.builder});
+  const NightDay({super.key, required this.now, required this.builder, this.mode});
 
   /// The phone's local time now.
   final DateTime Function() now;
 
+  /// The mode; Automatic when null.
+  final ValueListenable<NightDayMode>? mode;
+
   final Widget Function(BuildContext context, ThemeMode mode, Duration fade) builder;
 
   /// The fade while the app is open (§6).
@@ -37,7 +65,9 @@ class NightDay extends StatefulWidget {
 }
 
 class _NightDayState extends State<NightDay> with WidgetsBindingObserver {
-  late bool _night = isNightAt(widget.now());
+  late bool _night = _nightNow();
+
+  bool _nightNow() => isNight(widget.mode?.value ?? NightDayMode.automatic, widget.now());
   Duration _fade = Duration.zero;
   late final Timer _timer;
 
@@ -45,11 +75,13 @@ class _NightDayState extends State<NightDay> with WidgetsBindingObserver {
   void initState() {
     super.initState();
     WidgetsBinding.instance.addObserver(this);
+    widget.mode?.addListener(_check);
     _timer = Timer.periodic(NightDay.tick, (_) => _check());
   }
 
   @override
   void dispose() {
+    widget.mode?.removeListener(_check);
     _timer.cancel();
     WidgetsBinding.instance.removeObserver(this);
     super.dispose();
@@ -62,7 +94,7 @@ class _NightDayState extends State<NightDay> with WidgetsBindingObserver {
 
   bool get _still {
     final f = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
-    return f.reduceMotion || f.disableAnimations;
+    return !wordAnimation || f.reduceMotion || f.disableAnimations;
   }
 
   bool get _open {
@@ -71,7 +103,7 @@ class _NightDayState extends State<NightDay> with WidgetsBindingObserver {
   }
 
   void _check({bool returning = false}) {
-    final night = isNightAt(widget.now());
+    final night = _nightNow();
     if (night == _night) return;
     setState(() {
       _night = night;
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index a14a953..911926a 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -50,6 +50,11 @@ enum LogEvent {
   consentReadFailed,
   consentKeepFailed,
 
+  /// Settings (D122): the settings could not be read, so the defaults stand;
+  /// or a change could not be kept, so it holds until the app closes.
+  settingsReadFailed,
+  settingsKeepFailed,
+
   /// Recording by voice (D69, D71). Off in this build; the microphone
   /// refused; no key from our server (its status); Soniox's stream refused
   /// or broken (its code); the microphone failing; a recording started,
diff --git a/app/lib/journal/night_look.dart b/app/lib/journal/night_look.dart
index 3dcf617..4536f6a 100644
--- a/app/lib/journal/night_look.dart
+++ b/app/lib/journal/night_look.dart
@@ -2,7 +2,9 @@
 // night shows one painting of the set shipped in the app, chosen from the
 // night's id alone, so from none of its words, and the same every time; an
 // unread night shows the painted gradient, and so does any night while the
-// app holds no painting. Nothing is stored: the id is already random (128
+// app holds no painting, and every night while Night images is Off (D121
+// item 3). Personal and Random both show the set until the personal
+// painting exists (D121 item 3; D122, the stop's question 9). Nothing is stored: the id is already random (128
 // bits from the phone's secure source, newNightId).
 import 'night.dart';
 
@@ -38,9 +40,10 @@ final class Painting extends NightLook {
 /// bits, modulo the count.
 int paintingFor(String id, int count) => int.parse(id.substring(0, 8), radix: 16) % count;
 
-/// The look of [night], [read] or not, with [paintings] in the set.
-NightLook lookOf(Night night, {required bool read, required int paintings}) =>
-    read && paintings > 0 ? Painting(paintingFor(night.id, paintings)) : const PaintedGradient();
+/// The look of [night], [read] or not, with [paintings] in the set, and
+/// [images] false while Night images is Off.
+NightLook lookOf(Night night, {required bool read, required int paintings, bool images = true}) =>
+    images && read && paintings > 0 ? Painting(paintingFor(night.id, paintings)) : const PaintedGradient();
 
 /// Whether a night has been read.
 typedef ReadCheck = bool Function(Night night);
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index 0e05bf3..3344e26 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -12,16 +12,24 @@
 // handed keeps its audio in the journal's folder (D92), and retries the
 // recordings waiting there while the app is open: when the journal opens,
 // when the app comes back, and when the connection returns; leaving the
-// app cuts a retry short (D92 item 3, D94).
+// app cuts a retry short (D92 item 3, D94). Once the journal opens, it
+// holds the settings and the consents (`SettingsController`, D122) and
+// follows them: Word Animation, Night/Day mode, Night images, and recording
+// by voice with its retries only while consent (a) is given; withdrawn,
+// they pause and every night stays (D121 item 5).
 import 'dart:async';
 
 import 'package:flutter/material.dart';
 
 import '../../core/always_light.dart';
+import '../../core/app_line.dart' show wordAnimation;
+import '../../core/night_day.dart';
 import '../../core/safe_log.dart';
 import '../../onboarding/onboarding.dart';
 import '../../recording/recording.dart';
 import '../../settings/consents.dart';
+import '../../settings/settings.dart';
+import '../../settings/settings_controller.dart';
 import '../journal.dart';
 import '../journal_audio.dart';
 import '../journal_files.dart';
@@ -62,6 +70,8 @@ class JournalHome extends StatefulWidget {
 class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   JournalStore? _store;
   Journal? _journal;
+  JournalAudio? _audio;
+  SettingsController? _settings;
   Recording? _recording;
   // Null until the consent is read; then whether it is given.
   bool? _agreed;
@@ -80,6 +90,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   void dispose() {
     WidgetsBinding.instance.removeObserver(this);
     _journal?.consentGone.removeListener(_restart);
+    _settings?.dispose();
     _recording?.retries?.dispose();
     super.dispose();
   }
@@ -108,18 +119,26 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
       return;
     }
     final journal = Journal(store)..consentGone.addListener(_restart);
-    bool agreed;
+    Consents? consents;
     try {
-      agreed = await journal.consents() != null;
+      consents = await journal.consents();
     } on Object {
       // Asked again: nothing is shown as agreed that is not kept.
       SafeLog.event(LogEvent.consentReadFailed);
-      agreed = false;
+    }
+    Settings? settings;
+    if (consents != null) {
+      try {
+        settings = await journal.settings();
+      } on Object {
+        // The defaults stand (D122).
+        SafeLog.event(LogEvent.settingsReadFailed);
+      }
     }
     if (!mounted) return;
     _store = store;
     _journal = journal;
-    agreed ? _enter() : _onboard();
+    consents == null ? _onboard() : _enter(consents, settings ?? const Settings());
   }
 
   // Onboarding, always in the light theme (main-path.md, Every Screen).
@@ -129,20 +148,41 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     setState(() => _agreed = false);
   }
 
-  // The journal, once the dreamer has agreed: only now may anything leave
-  // the phone, so the recording and its retries begin here (D103).
-  void _enter({bool first = false}) {
+  // The journal, once the dreamer has answered the consents, with the
+  // settings kept (D122). Only now may anything leave the phone (D103).
+  void _enter(Consents consents, Settings settings, {bool first = false}) {
     AlwaysLight.hold(context, false);
-    final audio = JournalAudio(_store!);
+    final audio = _audio = JournalAudio(_store!);
+    final controller = SettingsController(_journal!, consents: consents, settings: settings)..addListener(_follow);
     setState(() {
       _agreed = true;
       _first = first;
-      _recording = widget.recording?.keeping(audio, waiting: audio);
+      _settings = controller;
     });
     // D98: the counts at launch and after each retry, for DevTools.
     unawaited(audio.logCounts());
-    _recording?.retries?.afterRetry = audio.logCounts;
-    _recording?.retries?.kick();
+    _follow();
+  }
+
+  // The settings followed (D122): Word Animation, Night/Day mode, and
+  // recording by voice with its retries only while consent (a) is given;
+  // withdrawn, a retry running is cut and none starts (D121 item 5).
+  void _follow() {
+    final controller = _settings;
+    if (controller == null || !mounted) return;
+    wordAnimation = controller.settings.wordAnimation;
+    NightDayChoice.set(context, controller.settings.nightDay);
+    final readings = controller.consents.given(Consent.readings);
+    if (readings && _recording == null) {
+      final audio = _audio!;
+      _recording = widget.recording?.keeping(audio, waiting: audio);
+      _recording?.retries?.afterRetry = audio.logCounts;
+      _recording?.retries?.kick();
+    } else if (!readings && _recording != null) {
+      _recording?.retries?.dispose();
+      _recording = null;
+    }
+    setState(() {});
   }
 
   // "I consent": the consents kept, then the journal. Until onboarding asks
@@ -152,23 +192,29 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   Future<void> _agree() async {
     if (_agreeing) return;
     _agreeing = true;
+    final journal = _journal!;
+    final consents = Consents.answered({Consent.readings: true}, journal.now());
     try {
-      final journal = _journal!;
-      await journal.keepConsents(Consents.answered({Consent.readings: true}, journal.now()));
+      await journal.keepConsents(consents);
     } on Object {
       SafeLog.event(LogEvent.consentKeepFailed);
     }
     // Not reset here: a tap that lands before onboarding has left the tree
     // must not open the journal twice. `_onboard` resets it.
-    if (mounted) _enter(first: true);
+    if (mounted) _enter(consents, const Settings(), first: true);
   }
 
-  // The journal deleted, the consents with it (D110): every page above
-  // closes, the retries stop, and onboarding starts again.
+  // The journal deleted, the consents and settings with it (D110): every
+  // page above closes, the retries stop, the settings return to their
+  // defaults, and onboarding starts again.
   void _restart() {
     if (!mounted) return;
     _recording?.retries?.dispose();
     _recording = null;
+    _settings?.dispose();
+    _settings = null;
+    wordAnimation = true;
+    NightDayChoice.set(context, NightDayMode.automatic);
     Navigator.of(context).popUntil((route) => route.isFirst);
     _onboard();
   }
@@ -184,6 +230,8 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
         firstTime: _first,
         nightAction: widget.nightAction,
         read: widget.read,
+        settings: _settings,
+        images: _settings?.nightImages != NightImages.off,
       ),
     };
   }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index c852395..af73c0a 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -30,6 +30,7 @@ import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
+import '../../settings/settings_controller.dart';
 import '../greeting.dart';
 import '../journal.dart';
 import '../night.dart';
@@ -52,6 +53,8 @@ class JournalPage extends StatefulWidget {
     this.firstTime = false,
     this.nightAction,
     this.read = noneRead,
+    this.settings,
+    this.images = true,
   });
 
   final Journal journal;
@@ -81,6 +84,13 @@ class JournalPage extends StatefulWidget {
   /// Whether a night has been read: none is yet (the readings come later).
   final ReadCheck read;
 
+  /// The settings and the consents, which the gear opens (D122), or null.
+  final SettingsController? settings;
+
+  /// False while Night images is Off: every night shows the gradient
+  /// (D121 item 3).
+  final bool images;
+
   @override
   State<JournalPage> createState() => _JournalPageState();
 }
@@ -119,6 +129,17 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     });
   }
 
+  // Consent (a) withdrawn or given again hands a new recording, or none
+  // (D121 item 5): the list follows the new one's retries.
+  @override
+  void didUpdateWidget(JournalPage old) {
+    super.didUpdateWidget(old);
+    if (old.recording?.retries != widget.recording?.retries) {
+      old.recording?.retries?.removeListener(_load);
+      widget.recording?.retries?.addListener(_load);
+    }
+  }
+
   @override
   void dispose() {
     _clock.cancel();
@@ -199,7 +220,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     };
     Widget row(Night night) => _Row(
       night,
-      look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings),
+      look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings, images: widget.images),
       line: contexts[night.id],
       onTap: () => _push(
         NightPage(
@@ -208,6 +229,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
           recording: widget.recording,
           action: widget.nightAction,
           read: widget.read,
+          images: widget.images,
           query: query,
         ),
       ),
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
index 12768e9..755d494 100644
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -71,6 +71,7 @@ class NightPage extends StatefulWidget {
     this.recording,
     this.action,
     this.read = noneRead,
+    this.images = true,
     this.query,
   });
 
@@ -97,6 +98,9 @@ class NightPage extends StatefulWidget {
   /// Whether a night has been read: none is yet (the readings come later).
   final ReadCheck read;
 
+  /// False while Night images is Off: the gradient (D121 item 3).
+  final bool images;
+
   /// The search this night was opened from, as searched, or null.
   final String? query;
 
@@ -327,7 +331,7 @@ class _NightPageState extends State<NightPage> {
     const side = EdgeInsets.symmetric(horizontal: Spacing.pageSide);
     final top = MediaQuery.paddingOf(context).top;
     final read = n != null && widget.read(n);
-    final look = n == null ? null : lookOf(n, read: read, paintings: NightArt.paintings);
+    final look = n == null ? null : lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images);
     final query = widget.query;
     final found = n == null || query == null ? null : findIn(n, query);
     // Light time and battery over the header's picture, in both themes (D113);
diff --git a/app/lib/settings/settings_controller.dart b/app/lib/settings/settings_controller.dart
new file mode 100644
index 0000000..d0c34fb
--- /dev/null
+++ b/app/lib/settings/settings_controller.dart
@@ -0,0 +1,66 @@
+// The settings and the consents while the journal is open (D110; D121;
+// D122), in plain Dart: what the Settings page shows and changes, and what
+// the journal's home follows. A change shows at once and is then kept in
+// the journal's folder; one that cannot be kept logs a code and holds until
+// the app closes, and the next opening shows what was kept before.
+//
+// - Consent (a), the readings: withdrawn, nothing leaves the phone, so
+//   recording by voice and its retries pause, and every night stays (D121
+//   item 5). Given again, they resume.
+// - Consent (b), Life Context: its setting, On or Off, is the consent
+//   (C159-I item 5; MP·83). Nothing is kept yet (D121 item 2).
+// - Consent (c), the night images: Night images is Off while it is not
+//   given (MP·85); Personal or Random is the choice kept for while it is.
+import 'package:flutter/foundation.dart';
+
+import '../core/safe_log.dart';
+import '../journal/journal.dart';
+import 'consents.dart';
+import 'settings.dart';
+
+final class SettingsController extends ChangeNotifier {
+  SettingsController(this._journal, {required this._consents, this._settings = const Settings()});
+
+  final Journal _journal;
+  Consents _consents;
+  Settings _settings;
+
+  Consents get consents => _consents;
+  Settings get settings => _settings;
+
+  /// Night images as shown: Off while consent (c) is not given.
+  NightImages get nightImages => _consents.given(Consent.images) ? _settings.images : NightImages.off;
+
+  /// Changes the settings, then keeps them.
+  Future<void> change(Settings next) async {
+    if (next == _settings) return;
+    _settings = next;
+    notifyListeners();
+    try {
+      await _journal.keepSettings(next);
+    } on Object {
+      SafeLog.event(LogEvent.settingsKeepFailed);
+    }
+  }
+
+  /// Gives [consent], or withdraws it, then keeps the consents with the day.
+  Future<void> answer(Consent consent, bool given) async {
+    if (_consents.given(consent) == given) return;
+    _consents = _consents.withAnswer(consent, given, _journal.now());
+    notifyListeners();
+    try {
+      await _journal.keepConsents(_consents);
+    } on Object {
+      SafeLog.event(LogEvent.consentKeepFailed);
+    }
+  }
+
+  /// Night images set to [choice]: Off withdraws consent (c); Personal or
+  /// Random is kept, and gives (c) when it is not given. The page asks
+  /// for (c) first (D122, the stop's question 7).
+  Future<void> setImages(NightImages choice) async {
+    if (choice == NightImages.off) return answer(Consent.images, false);
+    await change(_settings.copyWith(images: choice));
+    await answer(Consent.images, true);
+  }
+}
diff --git a/app/test/core/night_day_test.dart b/app/test/core/night_day_test.dart
index 1801ee0..d7eb5cb 100644
--- a/app/test/core/night_day_test.dart
+++ b/app/test/core/night_day_test.dart
@@ -4,6 +4,7 @@
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/app.dart';
+import 'package:souldreams/core/app_line.dart';
 import 'package:souldreams/core/night_day.dart';
 import 'package:souldreams/core/privacy_cover.dart';
 import 'package:souldreams/design/palette.dart';
@@ -94,4 +95,44 @@ void main() {
     tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
     await tester.pump();
   });
+
+  // D122: Manual, Day or Night, whatever the hour; set from a page under the
+  // app, it fades over five seconds while the app is open.
+  test('Manual holds its theme whatever the hour', () {
+    expect(isNight(NightDayMode.day, DateTime(2026, 6, 10, 23)), isFalse);
+    expect(isNight(NightDayMode.night, DateTime(2026, 6, 10, 12)), isTrue);
+    expect(isNight(NightDayMode.automatic, DateTime(2026, 6, 10, 23)), isTrue);
+    expect(isNight(NightDayMode.automatic, DateTime(2026, 6, 10, 12)), isFalse);
+  });
+
+  testWidgets('Manual set while open fades, and holds through the hours', (tester) async {
+    var now = DateTime(2026, 6, 10, 12);
+    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
+    expect(pageOf(tester), light);
+    NightDayChoice.set(tester.element(find.byType(Scaffold)), NightDayMode.night);
+    await tester.pump();
+    await tester.pump(const Duration(milliseconds: 2500));
+    expect(pageOf(tester), Color.lerp(light, dark, 0.5));
+    await tester.pump(const Duration(milliseconds: 2600));
+    expect(pageOf(tester), dark);
+    now = DateTime(2026, 6, 11, 9);
+    await tester.pump(NightDay.tick);
+    await tester.pump(NightDay.fade);
+    expect(pageOf(tester), dark);
+    NightDayChoice.set(tester.element(find.byType(Scaffold)), NightDayMode.automatic);
+    await tester.pump();
+    await tester.pump(NightDay.fade);
+    expect(pageOf(tester), light);
+  });
+
+  // Design System §6: with Word Animation off, the change is at once.
+  testWidgets('with Word Animation off, a change is instant', (tester) async {
+    wordAnimation = false;
+    addTearDown(() => wordAnimation = true);
+    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 12)));
+    NightDayChoice.set(tester.element(find.byType(Scaffold)), NightDayMode.night);
+    await tester.pump();
+    await tester.pump();
+    expect(pageOf(tester), dark);
+  });
 }
diff --git a/app/test/journal/night_look_test.dart b/app/test/journal/night_look_test.dart
index 9caa692..d230f25 100644
--- a/app/test/journal/night_look_test.dart
+++ b/app/test/journal/night_look_test.dart
@@ -41,6 +41,11 @@ void main() {
     expect(lookOf(nightWith(a), read: true, paintings: 4), const Painting(2));
   });
 
+  // D121 item 3: Night images Off, every night the gradient.
+  test('with Night images Off, a read night shows the gradient', () {
+    expect(lookOf(nightWith(a), read: true, paintings: 4, images: false), const PaintedGradient());
+  });
+
   test('with no paintings, a read night shows the gradient', () {
     expect(lookOf(nightWith(a), read: true, paintings: 0), const PaintedGradient());
   });
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index 1a5a629..b0fcd21 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -7,6 +7,8 @@ import 'dart:typed_data';
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/app.dart';
+import 'package:souldreams/core/app_line.dart';
+import 'package:souldreams/core/night_day.dart';
 import 'package:souldreams/core/safe_log.dart';
 import 'package:souldreams/journal/journal.dart';
 import 'package:souldreams/journal/journal_audio.dart';
@@ -20,6 +22,7 @@ import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/onboarding/onboarding.dart';
 import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
 import 'package:souldreams/words/lines.g.dart';
 
 import '../../fixtures.dart';
@@ -60,6 +63,19 @@ T agreed<T extends MemoryJournalFiles>(T files) {
   return files;
 }
 
+/// A folder whose read of the settings fails.
+final class NoSettingsRead extends MemoryJournalFiles {
+  @override
+  Future<Uint8List?> read(String name) async =>
+      name == JournalStore.settingsFile ? throw StateError('journal-io') : super.read(name);
+}
+
+/// [files] holding the three consents as [given] (D122), version 2.
+T answered<T extends MemoryJournalFiles>(T files, Map<Consent, bool> given) {
+  files.files[JournalStore.consentFile] = encodeConsents(Consents.answered(given, DateTime.utc(2026)));
+  return files;
+}
+
 /// A night with a recording waiting, its audio kept, in [files].
 Future<void> waiting(MemoryJournalFiles files) async {
   final store = await JournalStore.open(files);
@@ -277,6 +293,10 @@ void main() {
     final files = MemoryJournalFiles();
     await waiting(files);
     final links = <MemoryLink>[];
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
     await tester.pumpWidget(SoulDreamsApp(
       clock: () => DateTime(2026, 6, 10, 23),
       home: JournalHome(files: files, recording: counted(links)),
@@ -295,6 +315,8 @@ void main() {
     expect([for (final c in ['readings', 'lifeContext', 'images']) kept[c]['given']], [true, false, false]);
     expect(kept['readings']['day'], dayOf(DateTime.now()));
     expect(links, hasLength(1));
+    // The journal opened once: its counts logged once (D98).
+    expect(lines.where((l) => l.startsWith('journalAudio')), hasLength(1));
     await tester.pumpWidget(const SizedBox());
     await tester.pump(const Duration(seconds: 11));
   });
@@ -316,10 +338,13 @@ void main() {
     await tester.pump();
     expect(find.byType(JournalPage), findsOneWidget);
     expect(links, hasLength(1));
+    final settings = tester.widget<JournalPage>(find.byType(JournalPage)).settings;
     agree();
     await tester.pump();
     await tester.pump();
     expect(links, hasLength(1));
+    // One journal, with its one settings (D122).
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).settings, same(settings));
     await tester.pumpWidget(const SizedBox());
     await tester.pump(const Duration(seconds: 11));
   });
@@ -422,4 +447,105 @@ void main() {
     await tester.pumpWidget(const SizedBox());
     await tester.pump(const Duration(seconds: 11));
   });
+
+  // D121 item 5; D122: consent (a) not given, the journal opens as a private
+  // journal: no recording by voice, nothing retried, every night there.
+  testWidgets('consent (a) not given: the journal, no recording, no retry', (tester) async {
+    JournalStore.newQueueForTests();
+    final files = answered(MemoryJournalFiles(), {Consent.lifeContext: true});
+    await waiting(files);
+    final links = <MemoryLink>[];
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links))));
+    await tester.pumpAndSettle();
+    expect(find.byType(JournalPage), findsOneWidget);
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).recording, isNull);
+    expect(find.byKey(JournalPage.rowKey(nightsFromFixtures().first.id)), findsOneWidget);
+    for (final state in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.inactive]) {
+      tester.binding.handleAppLifecycleStateChanged(state);
+    }
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pumpAndSettle();
+    expect(links, isEmpty);
+  });
+
+  // D121 item 5: withdrawn, the retry running is cut and none follows, the
+  // journal stays with every night; given again, the retries resume.
+  testWidgets('consent (a) withdrawn: the retry cut; given again: resumed', (tester) async {
+    JournalStore.newQueueForTests();
+    final files = agreed(MemoryJournalFiles());
+    await waiting(files);
+    final links = <MemoryLink>[];
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links))));
+    await tester.pump();
+    await tester.pump();
+    expect(links, hasLength(1));
+    final settings = tester.widget<JournalPage>(find.byType(JournalPage)).settings!;
+    await settings.answer(Consent.readings, false);
+    await tester.pump(const Duration(milliseconds: 150));
+    expect(find.byType(JournalPage), findsOneWidget);
+    expect(find.byType(Onboarding), findsNothing);
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).recording, isNull);
+    expect(links.single.closed, isTrue);
+    expect(files.files.keys.where((n) => n.startsWith('night-')), hasLength(1));
+    expect(decodeConsents(files.files[JournalStore.consentFile]!)!.given(Consent.readings), isFalse);
+    for (final state in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.inactive]) {
+      tester.binding.handleAppLifecycleStateChanged(state);
+    }
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pump();
+    await tester.pump();
+    expect(links, hasLength(1));
+    await settings.answer(Consent.readings, true);
+    await tester.pump();
+    await tester.pump();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).recording, isNotNull);
+    expect(links, hasLength(2));
+    await tester.pumpWidget(const SizedBox());
+    await tester.pump(const Duration(seconds: 11));
+  });
+
+  // D122: the settings kept are followed when the journal opens: Word
+  // Animation, Night/Day mode and Night images (consent (c) given); deleting
+  // the journal returns them to their defaults.
+  testWidgets('the settings kept are followed; the deletion resets them', (tester) async {
+    JournalStore.newQueueForTests();
+    addTearDown(() => wordAnimation = true);
+    final files = answered(MemoryJournalFiles(), {Consent.readings: true, Consent.images: true});
+    files.files[JournalStore.settingsFile] = encodeSettings(
+      const Settings(wordAnimation: false, nightDay: NightDayMode.night, images: NightImages.random),
+    );
+    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 12), home: JournalHome(files: files)));
+    await tester.pumpAndSettle();
+    final page = tester.widget<JournalPage>(find.byType(JournalPage));
+    expect(page.images, isTrue);
+    expect(page.settings!.nightImages, NightImages.random);
+    expect(wordAnimation, isFalse);
+    expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
+    await page.journal.deleteAll();
+    await tester.pumpAndSettle();
+    expect(find.byType(Onboarding), findsOneWidget);
+    expect(wordAnimation, isTrue);
+    expect(tester.widget<NightDayChoice>(find.byType(NightDayChoice)).mode.value, NightDayMode.automatic);
+  });
+
+  // MP·85: consent (c) not given, Night images is Off: every night the
+  // gradient.
+  testWidgets('consent (c) not given: Night images Off', (tester) async {
+    JournalStore.newQueueForTests();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
+    await tester.pumpAndSettle();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).images, isFalse);
+  });
+
+  testWidgets('settings that cannot be read: the defaults, a code', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(NoSettingsRead()))));
+    await tester.pumpAndSettle();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).settings!.settings, const Settings());
+    expect(lines, ['settingsReadFailed', 'journalAudio 0 0']);
+  });
 }
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index 1e61a8a..bb4e30e 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -405,6 +405,20 @@ void main() {
     expect(find.text(shownDate(n.date)), findsOneWidget);
   });
 
+  // D121 item 3: Night images Off, a read night's row shows the gradient,
+  // and its page is handed the same.
+  testWidgets("with Night images Off, a read row shows the gradient", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    await h.pump(tester, JournalPage(journal: h.journal, read: (_) => true, images: false));
+    final row = find.byKey(JournalPage.rowKey(n.id));
+    final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
+    expect(art.look, const PaintedGradient());
+    await tester.tap(row);
+    await tester.pumpAndSettle();
+    expect(tester.widget<NightPage>(find.byType(NightPage)).images, isFalse);
+  });
+
   // D110: naming a night is removed; a name kept from before is not shown.
   testWidgets('a named night shows only its date', (tester) async {
     final h = await Harness.make();
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
index 7e3bc4b..a9a3241 100644
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -85,6 +85,7 @@ void main() {
     int hour = 12,
     bool unread = false,
     String? query,
+    bool images = true,
   }) async {
     // The test's own 800 by 600, where the foot's two buttons do not fill
     // the row, or a phone.
@@ -106,7 +107,7 @@ void main() {
     }
     // A first read that fails leaves the page blank, with no picture.
     if (unread) files!.failReads = true;
-    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action, read: read, query: query)),
+    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action, read: read, images: images, query: query)),
         hour: hour);
     await tester.tap(find.byKey(Opener.openKey));
     await tester.pumpAndSettle();
@@ -556,6 +557,14 @@ void main() {
     }
   });
 
+  // D121 item 3: Night images Off, a read night's header shows the
+  // gradient; its jump buttons stay.
+  testWidgets('with Night images Off, a read night: the gradient', (tester) async {
+    await open(tester, read: (_) => true, images: false);
+    expect(tester.widget<NightArt>(find.byType(NightArt)).look, const PaintedGradient());
+    expect(find.byKey(NightPage.jumpKey(Jump.dreams)), findsOneWidget);
+  });
+
   // D110: a read night shows its painting, and the four jump buttons in
   // order, centred under the header, each heard as a button.
   testWidgets('a read night: its painting, then four jump buttons', (tester) async {
diff --git a/app/test/settings/settings_controller_test.dart b/app/test/settings/settings_controller_test.dart
new file mode 100644
index 0000000..632d290
--- /dev/null
+++ b/app/test/settings/settings_controller_test.dart
@@ -0,0 +1,99 @@
+// The settings and the consents while the journal is open (D121; D122): a
+// change shows at once and is kept; one that cannot be kept logs a code and
+// holds; Night images is Off while consent (c) is not given.
+import 'dart:convert';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/night_day.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
+import 'package:souldreams/settings/settings_controller.dart';
+
+import '../journal/memory_journal_files.dart';
+
+/// A folder whose rename fails: nothing can be kept.
+final class NoRename extends MemoryJournalFiles {
+  @override
+  Future<void> rename(String from, String to) async => throw StateError('journal-io');
+}
+
+final now = DateTime.utc(2026, 11, 21, 12);
+
+Future<(SettingsController, MemoryJournalFiles)> make({
+  Map<Consent, bool> given = const {Consent.readings: true},
+  MemoryJournalFiles? files,
+}) async {
+  final f = files ?? MemoryJournalFiles();
+  final journal = Journal(await JournalStore.open(f), now: () => now);
+  return (SettingsController(journal, consents: Consents.answered(given, DateTime.utc(2026))), f);
+}
+
+Map<String, dynamic> kept(MemoryJournalFiles f, String name) =>
+    jsonDecode(utf8.decode(f.files[name]!)) as Map<String, dynamic>;
+
+void main() {
+  late List<String> lines;
+  final sink = SafeLog.sink;
+  setUp(() {
+    JournalStore.newQueueForTests();
+    lines = [];
+    SafeLog.sink = lines.add;
+  });
+  tearDown(() => SafeLog.sink = sink);
+
+  test('a consent answered shows at once, then is kept', () async {
+    final (c, f) = await make();
+    var told = 0;
+    c.addListener(() => told++);
+    final done = c.answer(Consent.readings, false);
+    expect(c.consents.given(Consent.readings), isFalse);
+    expect(told, 1);
+    await done;
+    expect(kept(f, JournalStore.consentFile)['readings'], {'given': false, 'day': '2026-11-21'});
+    expect(kept(f, JournalStore.consentFile)['lifeContext'], {'given': false, 'day': '2026-01-01'});
+    await c.answer(Consent.readings, false);
+    expect(told, 1);
+    expect(lines, isEmpty);
+  });
+
+  test('a setting changed shows at once, then is kept', () async {
+    final (c, f) = await make();
+    var told = 0;
+    c.addListener(() => told++);
+    const next = Settings(nightDay: NightDayMode.night);
+    final done = c.change(next);
+    expect(c.settings, next);
+    expect(told, 1);
+    await done;
+    expect(kept(f, JournalStore.settingsFile)['nightDay'], 'night');
+    await c.change(next);
+    expect(told, 1);
+  });
+
+  test('Night images is Off while consent (c) is not given', () async {
+    final (c, _) = await make();
+    expect(c.settings.images, NightImages.personal);
+    expect(c.nightImages, NightImages.off);
+    await c.setImages(NightImages.random);
+    expect(c.consents.given(Consent.images), isTrue);
+    expect(c.nightImages, NightImages.random);
+    await c.setImages(NightImages.off);
+    expect(c.consents.given(Consent.images), isFalse);
+    expect(c.nightImages, NightImages.off);
+    // The choice is kept for when (c) is given again.
+    expect(c.settings.images, NightImages.random);
+  });
+
+  test('a change that cannot be kept logs a code and holds', () async {
+    final (c, f) = await make(files: NoRename());
+    await c.answer(Consent.lifeContext, true);
+    await c.change(const Settings(wordAnimation: false));
+    expect(c.consents.given(Consent.lifeContext), isTrue);
+    expect(c.settings.wordAnimation, isFalse);
+    expect(lines, ['consentKeepFailed', 'settingsKeepFailed']);
+    expect(f.files, isEmpty);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index d316099..1f6ee9a 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -386,8 +386,8 @@ ROWS = [
      'test/journal/row_text_test.dart', 'a divider: the month alone this year, month and year before'),
     # motion
     ('A34', 'lib/core/night_day.dart',
-     'return f.reduceMotion || f.disableAnimations;',
-     'return f.disableAnimations;',
+     'return !wordAnimation || f.reduceMotion || f.disableAnimations;',
+     'return !wordAnimation;',
      'test/core/night_day_test.dart', 'with Reduce Motion the change is instant'),
     ('A35', 'lib/core/night_day.dart',
      '? NightDay.fade : Duration.zero',
@@ -1379,8 +1379,8 @@ ROWS = [
      '',
      'test/onboarding/onboarding_test.dart', 'Read everything opens every part; back returns to the consent'),
     ('A293', 'lib/journal/pages/journal_home.dart',
-     'agreed ? _enter() : _onboard();',
-     '_enter();',
+     'consents == null ? _onboard() : _enter(consents, settings ?? const Settings());',
+     '_enter(consents ?? Consents.answered({}, DateTime.utc(2026)), settings ?? const Settings());',
      'test/journal/pages/journal_home_test.dart', 'no consent: onboarding, light at night, nothing retried'),
     ('A294', 'lib/journal/pages/journal_home.dart',
      '    AlwaysLight.hold(context, true);\n    setState(() => _agreed = false);',
@@ -1391,7 +1391,7 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
     ('A296', 'lib/journal/pages/journal_home.dart',
-     '      await journal.keepConsents(Consents.answered({Consent.readings: true}, journal.now()));\n',
+     '      await journal.keepConsents(consents);\n',
      '',
      'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
     ('A297', 'lib/journal/pages/journal_home.dart',
@@ -1399,8 +1399,8 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
     ('A298', 'lib/journal/pages/journal_home.dart',
-     '      SafeLog.event(LogEvent.consentReadFailed);\n      agreed = false;',
-     '      SafeLog.event(LogEvent.consentReadFailed);\n      agreed = true;',
+     '      SafeLog.event(LogEvent.consentReadFailed);\n',
+     '      SafeLog.event(LogEvent.consentReadFailed);\n      consents = Consents.answered({}, DateTime.utc(2026));\n',
      'test/journal/pages/journal_home_test.dart', 'a consent that cannot be read: onboarding, a code'),
     ('A299', 'lib/journal/pages/journal_home.dart',
      '    Navigator.of(context).popUntil((route) => route.isFirst);\n',
@@ -1415,8 +1415,8 @@ ROWS = [
      'nights.isEmpty)',
      'test/journal/pages/journal_page_test.dart', 'a later empty journal has no MP·9'),
     ('A303', 'lib/journal/pages/journal_home.dart',
-     '    if (mounted) _enter(first: true);',
-     '    _agreeing = false;\n    if (mounted) _enter(first: true);',
+     '    if (mounted) _enter(consents, const Settings(), first: true);',
+     '    _agreeing = false;\n    if (mounted) _enter(consents, const Settings(), first: true);',
      'test/journal/pages/journal_home_test.dart', 'a second I agree after the journal opened starts nothing more'),
     ('A304', 'lib/journal/pages/journal_home.dart',
      '    _agreeing = false;\n    AlwaysLight.hold(context, true);',
@@ -1727,8 +1727,8 @@ ROWS = [
      '          _sky = sky;\n',
      'test/journal/pages/journal_page_test.dart', 'the greeting: by the clock, centred, a heading, above New Dream'),
     ('A376', 'lib/journal/pages/journal_page.dart',
-     'look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings),',
-     'look: lookOf(night, read: false, paintings: NightArt.paintings),',
+     'look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings, images: widget.images),',
+     'look: lookOf(night, read: false, paintings: NightArt.paintings, images: widget.images),',
      'test/journal/pages/journal_page_test.dart', "a read night's row shows its painting"),
     ('A377', 'lib/journal/pages/journal_page.dart',
      '          read: widget.read,\n',
@@ -1752,8 +1752,8 @@ ROWS = [
      'if (false) ...[_jumps(p), const SizedBox(height: StandIns.gap)],',
      'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
     ('A382', 'lib/journal/pages/night_page.dart',
-     'lookOf(n, read: read, paintings: NightArt.paintings);',
-     'lookOf(n, read: false, paintings: NightArt.paintings);',
+     'lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images);',
+     'lookOf(n, read: false, paintings: NightArt.paintings, images: widget.images);',
      'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
     ('A383', 'lib/journal/pages/night_page.dart',
      'final read = n != null && widget.read(n);',
@@ -2275,6 +2275,98 @@ ROWS = [
      'Answer(given[c] ?? false, dayOf(now))',
      'Answer(given[c] ?? true, dayOf(now))',
      'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
+    ('A509', 'lib/journal/night_look.dart',
+     'images && read && paintings > 0',
+     'read && paintings > 0',
+     'test/journal/night_look_test.dart', 'with Night images Off, a read night shows the gradient'),
+    ('A510', 'lib/journal/pages/journal_page.dart',
+     'paintings: NightArt.paintings, images: widget.images),',
+     'paintings: NightArt.paintings),',
+     'test/journal/pages/journal_page_test.dart', 'with Night images Off, a read row shows the gradient'),
+    ('A511', 'lib/journal/pages/journal_page.dart',
+     '          images: widget.images,\n',
+     '',
+     'test/journal/pages/journal_page_test.dart', 'with Night images Off, a read row shows the gradient'),
+    ('A512', 'lib/journal/pages/night_page.dart',
+     'paintings: NightArt.paintings, images: widget.images);',
+     'paintings: NightArt.paintings);',
+     'test/journal/pages/night_page_test.dart', 'with Night images Off, a read night: the gradient'),
+    ('A513', 'lib/journal/pages/journal_home.dart',
+     'images: _settings?.nightImages != NightImages.off,',
+     'images: true,',
+     'test/journal/pages/journal_home_test.dart', 'consent (c) not given: Night images Off'),
+    ('A514', 'lib/journal/pages/journal_home.dart',
+     '    wordAnimation = controller.settings.wordAnimation;\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the settings kept are followed; the deletion resets them'),
+    ('A515', 'lib/journal/pages/journal_home.dart',
+     '    NightDayChoice.set(context, controller.settings.nightDay);\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the settings kept are followed; the deletion resets them'),
+    ('A516', 'lib/journal/pages/journal_home.dart',
+     '    wordAnimation = true;\n    NightDayChoice.set(context, NightDayMode.automatic);\n',
+     '    NightDayChoice.set(context, NightDayMode.automatic);\n',
+     'test/journal/pages/journal_home_test.dart', 'the settings kept are followed; the deletion resets them'),
+    ('A517', 'lib/journal/pages/journal_home.dart',
+     '    wordAnimation = true;\n    NightDayChoice.set(context, NightDayMode.automatic);\n',
+     '    wordAnimation = true;\n',
+     'test/journal/pages/journal_home_test.dart', 'the settings kept are followed; the deletion resets them'),
+    ('A518', 'lib/journal/pages/journal_home.dart',
+     '    } else if (!readings && _recording != null) {\n      _recording?.retries?.dispose();\n',
+     '    } else if (!readings && _recording != null) {\n',
+     'test/journal/pages/journal_home_test.dart', 'consent (a) withdrawn: the retry cut; given again: resumed'),
+    ('A519', 'lib/journal/pages/journal_home.dart',
+     '    if (readings && _recording == null) {',
+     '    if (_recording == null) {',
+     'test/journal/pages/journal_home_test.dart', 'consent (a) not given: the journal, no recording, no retry'),
+    ('A520', 'lib/journal/pages/journal_home.dart',
+     '        SafeLog.event(LogEvent.settingsReadFailed);\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'settings that cannot be read: the defaults, a code'),
+    ('A521', 'lib/journal/pages/journal_home.dart',
+     '      _recording?.retries?.kick();\n    } else if',
+     '    } else if',
+     'test/journal/pages/journal_home_test.dart', 'consent (a) withdrawn: the retry cut; given again: resumed'),
+    ('A522', 'lib/core/night_day.dart',
+     '    widget.mode?.addListener(_check);\n',
+     '',
+     'test/core/night_day_test.dart', 'Manual set while open fades, and holds through the hours'),
+    ('A523', 'lib/core/night_day.dart',
+     'return !wordAnimation || f.reduceMotion',
+     'return f.reduceMotion',
+     'test/core/night_day_test.dart', 'with Word Animation off, a change is instant'),
+    ('A524', 'lib/core/night_day.dart',
+     '  NightDayMode.day => false,',
+     '  NightDayMode.day => isNightAt(local),',
+     'test/core/night_day_test.dart', 'Manual holds its theme whatever the hour'),
+    ('A525', 'lib/app.dart',
+     '          mode: _mode,\n',
+     '',
+     'test/core/night_day_test.dart', 'Manual set while open fades, and holds through the hours'),
+    ('A526', 'lib/settings/settings_controller.dart',
+     'if (choice == NightImages.off) return answer(Consent.images, false);',
+     'if (choice == NightImages.off) return;',
+     'test/settings/settings_controller_test.dart', 'Night images is Off while consent (c) is not given'),
+    ('A527', 'lib/settings/settings_controller.dart',
+     '    await answer(Consent.images, true);\n',
+     '',
+     'test/settings/settings_controller_test.dart', 'Night images is Off while consent (c) is not given'),
+    ('A528', 'lib/settings/settings_controller.dart',
+     '      SafeLog.event(LogEvent.settingsKeepFailed);\n',
+     '',
+     'test/settings/settings_controller_test.dart', 'a change that cannot be kept logs a code and holds'),
+    ('A529', 'lib/settings/settings_controller.dart',
+     '    if (next == _settings) return;\n',
+     '',
+     'test/settings/settings_controller_test.dart', 'a setting changed shows at once, then is kept'),
+    ('A530', 'lib/settings/settings_controller.dart',
+     '_consents.given(Consent.images) ? _settings.images : NightImages.off',
+     '_settings.images',
+     'test/settings/settings_controller_test.dart', 'Night images is Off while consent (c) is not given'),
+    ('A531', 'lib/settings/settings_controller.dart',
+     '    if (_consents.given(consent) == given) return;\n',
+     '',
+     'test/settings/settings_controller_test.dart', 'a consent answered shows at once, then is kept'),
 ]
 
 
~~~~

### Task 3 · The setting lines read by form (D122, the stop's question 13)

`settings/setting_line.dart`: `settingWords(line, lang)` reads "Name (A / B ...)" into a name and its choices, or
gives null.

Tests: `setting_line_test.dart` (new): MP·26, MP·44, MP·83, MP·84 and MP·85 in both languages, the words put back
being the line; and every other form giving none.

Rows: A532 to A536.

Expected: 631 app tests; `python3 -I -B tool/app_mutations.py --rows A532,A533,A534,A535,A536`, every one caught. Commit:

> Settings: the setting lines read by form, name and choices (D122 Q13)

**The block:**

~~~~diff
diff --git a/app/lib/settings/setting_line.dart b/app/lib/settings/setting_line.dart
new file mode 100644
index 0000000..19439b4
--- /dev/null
+++ b/app/lib/settings/setting_line.dart
@@ -0,0 +1,26 @@
+// A setting's line as the register writes it: its name, then its choices in
+// brackets, split at " / " ("Word Animation (On / Off)"; MP·26, MP·44,
+// MP·83, MP·84, MP·85). The generator splits every line at " / ", so the
+// name and the choices are read back here, in Dart (D122, the stop's
+// question 13). A line not in that exact form gives null, and its row shows
+// the place's handle (R1).
+import '../words/lines.g.dart';
+
+/// A setting's name and its choices, in the register's order.
+typedef SettingWords = ({String name, List<String> choices});
+
+/// [line]'s name and choices in [lang], or null when it is not exactly
+/// "Name (A / B ...)".
+SettingWords? settingWords(Line line, Lang lang) {
+  final parts = line.parts(lang);
+  if (parts.length < 2) return null;
+  final first = parts.first;
+  final last = parts.last;
+  final open = first.indexOf(' (');
+  if (open <= 0 || !last.endsWith(')')) return null;
+  final name = first.substring(0, open);
+  final choices = [first.substring(open + 2), ...parts.sublist(1, parts.length - 1), last.substring(0, last.length - 1)];
+  bool bare(String w) => w.trim() == w && w.isNotEmpty && !w.contains('(') && !w.contains(')');
+  if (!bare(name) || !choices.every(bare)) return null;
+  return (name: name, choices: choices);
+}
diff --git a/app/test/settings/setting_line_test.dart b/app/test/settings/setting_line_test.dart
new file mode 100644
index 0000000..acd4652
--- /dev/null
+++ b/app/test/settings/setting_line_test.dart
@@ -0,0 +1,46 @@
+// The settings' lines read by form (D122, the stop's question 13): the name
+// and the choices, exactly the register's words, in both languages; any
+// other form gives none.
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/settings/setting_line.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+void main() {
+  test('each setting line gives its name and choices, both languages', () {
+    for (final (line, count) in [
+      (Lines.MP_26, 2),
+      (Lines.MP_44, 2),
+      (Lines.MP_83, 2),
+      (Lines.MP_84, 4),
+      (Lines.MP_85, 3),
+    ]) {
+      for (final lang in Lang.values) {
+        final w = settingWords(line, lang)!;
+        expect(w.choices, hasLength(count), reason: '${line.handle} $lang');
+        // Nothing added, nothing lost: the words put back are the line.
+        expect('${w.name} (${w.choices.join(' / ')})', line.parts(lang).join(' / '), reason: line.handle);
+      }
+    }
+    final w = settingWords(Lines.MP_26, Lang.en)!;
+    expect([w.name, ...w.choices], ['Word Animation', 'On', 'Off']);
+  });
+
+  test('a line in any other form gives none', () {
+    for (final parts in [
+      ['Word Animation'],
+      ['A (B)'],
+      ['Word Animation (On', 'Off'],
+      ['Word Animation On', 'Off)'],
+      [' (On', 'Off)'],
+      ['A (B (C', 'D)'],
+      ['A (B', 'C))'],
+      ['A (B', ' C)'],
+      ['A (', 'C)'],
+    ]) {
+      expect(settingWords(Line('X·1', parts, parts), Lang.en), isNull, reason: '$parts');
+    }
+    expect(settingWords(const Line('X·1', null, null), Lang.en), isNull);
+    final w = settingWords(Line('X·1', ['A (B', 'C)'], ['A (B', 'C)']), Lang.en)!;
+    expect([w.name, ...w.choices], ['A', 'B', 'C']);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 1f6ee9a..a80f411 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2367,6 +2367,26 @@ ROWS = [
      '    if (_consents.given(consent) == given) return;\n',
      '',
      'test/settings/settings_controller_test.dart', 'a consent answered shows at once, then is kept'),
+    ('A532', 'lib/settings/setting_line.dart',
+     "if (open <= 0 || !last.endsWith(')')) return null;",
+     'if (open < 0) return null;',
+     'test/settings/setting_line_test.dart', 'a line in any other form gives none'),
+    ('A533', 'lib/settings/setting_line.dart',
+     '  if (!bare(name) || !choices.every(bare)) return null;\n',
+     '',
+     'test/settings/setting_line_test.dart', 'a line in any other form gives none'),
+    ('A534', 'lib/settings/setting_line.dart',
+     '  if (parts.length < 2) return null;\n',
+     '',
+     'test/settings/setting_line_test.dart', 'a line in any other form gives none'),
+    ('A535', 'lib/settings/setting_line.dart',
+     'w.trim() == w && w.isNotEmpty && ',
+     'w.isNotEmpty && ',
+     'test/settings/setting_line_test.dart', 'a line in any other form gives none'),
+    ('A536', 'lib/settings/setting_line.dart',
+     'last.substring(0, last.length - 1)]',
+     'last]',
+     'test/settings/setting_line_test.dart', 'each setting line gives its name and choices, both languages'),
 ]
 
 
~~~~

### Task 4 · The three consents in onboarding; the shown-lines test's scope (D110; D122)

`settings/consent_page.dart`:
- `consentText`.
- `ConsentChoice`: MP·67's pair side by side, the chosen one filled and heard as selected.
- `ConsentPage` and `ConsentPage.ask`: true only for "I consent".

`onboarding.dart`:
- The second page ends with MP·66 and the three consents.
- Its foot: EM·6, then Next (MP·30), which waits for all three answers.
- `onAgreed` hands the answers on.

`journal_home.dart`: keeps them as given.

`shown_lines_test.dart`: the scan follows what `main.dart` and `main_founder.dart` reach (`reached`, from
`dev_only_test.dart`). Dev is seen to show MP·68 and MP·70 with their braces.

Tests:
- `onboarding_test.dart`: the consent page's layout, the lines as filed, and Next waiting then telling the answers
  once (2 new).
- `consent_page_test.dart` (new): 4 tests.
- `journal_home_test.dart`: 1 new.

Rows:
- New: A537 to A546.
- Following their code: A291, A443, A480 (now: `main.dart` reaching a braced line), A508.
- Dropped: A507 (A544 holds the answers kept).

Expected: 637 app tests; `python3 -I -B tool/app_mutations.py --files lib/onboarding/onboarding.dart,lib/settings/consent_page.dart,lib/journal/pages/journal_home.dart,test/words/shown_lines_test.dart,lib/main.dart,lib/main_founder.dart --rows A508`, every one caught. Commit:

> Onboarding: the three consents, MP·66 to MP·70; the shown-lines test covers the tester and founder apps (D122 Q1)

**The block:**

~~~~diff
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index 3344e26..6ca3a6b 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -185,15 +185,14 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     setState(() {});
   }
 
-  // "I consent": the consents kept, then the journal. Until onboarding asks
-  // the three (D119 item 1), it gives (a) and leaves (b) and (c) not given
-  // (D122). Consents that cannot be kept log a code; the journal opens, and
-  // the next opening asks again.
-  Future<void> _agree() async {
+  // Next, the three consents answered: kept, then the journal (D122).
+  // Consents that cannot be kept log a code; the journal opens, and the
+  // next opening asks again.
+  Future<void> _agree(Map<Consent, bool> given) async {
     if (_agreeing) return;
     _agreeing = true;
     final journal = _journal!;
-    final consents = Consents.answered({Consent.readings: true}, journal.now());
+    final consents = Consents.answered(given, journal.now());
     try {
       await journal.keepConsents(consents);
     } on Object {
diff --git a/app/lib/onboarding/onboarding.dart b/app/lib/onboarding/onboarding.dart
index b75ff37..f7c5358 100644
--- a/app/lib/onboarding/onboarding.dart
+++ b/app/lib/onboarding/onboarding.dart
@@ -1,14 +1,17 @@
 // Onboarding (main-path.md, Onboarding; D103), SoulDreams Dev only: the
 // welcome, the founder's note, the age question, then the disclosure's
-// first layer on two pages with one consent (C14-P item 1; the plan's
-// question 2 for which part stands on which page). The page that shows it
-// holds the app light (AlwaysLight). Every word is the register's; a part
-// with no line yet shows nothing in its place (D106 3; R1). Every box is
-// centred between the top and the foot (D106 1), and the words appear whole
-// (D106 2). Nothing is kept here: "I consent" (MP·67's first part, in
-// place of the retired MP·8 until the three consents are built; D119) is
-// told to the page that shows this, which keeps only that the dreamer
-// agreed and is 18 or over (D103 items 2 and 4). Under 18: EM·5 and
+// first layer on two pages (C14-P item 1; the plan's question 2 for which
+// part stands on which page), the second ending in the three consents
+// (C18-P, MP·66 to MP·70; C159-I item 5; D110; D122): MP·66, then each
+// consent's text with MP·67's two choices, equally prominent, neither
+// chosen beforehand. Next (MP·30) waits until all three are answered; any
+// answer opens the journal. The page that shows it holds the app light
+// (AlwaysLight). Every word is the register's; a part with no line yet
+// shows nothing in its place (D106 3; R1). Every box is centred between the
+// top and the foot (D106 1), and the words appear whole (D106 2). Nothing
+// is kept here: the three answers are told to the page that shows this,
+// which keeps them and that the dreamer is 18 or over (D103 item 2;
+// D122). Under 18: EM·5 and
 // "I understand", which changes nothing; the card stays until the app
 // closes, and the question is asked again at the next opening, since
 // nothing was kept (C127-I I6). "I don't agree" goes back to the
@@ -24,6 +27,8 @@ import '../design/palette.dart';
 import '../design/stand_ins.dart';
 import '../design/tokens.g.dart';
 import '../journal/pages/parts.dart';
+import '../settings/consent_page.dart';
+import '../settings/consents.dart';
 import '../words/lines.g.dart';
 import 'age.dart';
 import 'disclosure_page.dart';
@@ -46,8 +51,9 @@ class Onboarding extends StatefulWidget {
     this.full = DisclosurePage.parts,
   });
 
-  /// "I consent" (MP·67's first part; D119).
-  final VoidCallback onAgreed;
+  /// Next, once the three consents are answered: each consent, true when
+  /// given (D122).
+  final ValueChanged<Map<Consent, bool>> onAgreed;
 
   /// The parts each page shows: [firstPage], [secondPage] and the full
   /// page's, unless a test hands in others (D106 3).
@@ -82,6 +88,8 @@ class _OnboardingState extends State<Onboarding> {
   _Step _step = _Step.welcome;
   // The band chosen, held only on this screen until Next (D103 item 2).
   int? _band;
+  // The consents answered so far, held only on this screen until Next.
+  final _answers = <Consent, bool>{};
 
   void _to(_Step step) => setState(() => _step = step);
 
@@ -98,7 +106,10 @@ class _OnboardingState extends State<Onboarding> {
         _to(underAge(band) ? _Step.underAge : _Step.disclosure);
       case _Step.disclosure:
         _to(_Step.consent);
-      case _Step.underAge || _Step.consent:
+      case _Step.consent:
+        if (_answers.length < Consent.values.length) return;
+        widget.onAgreed(Map.of(_answers));
+      case _Step.underAge:
         return;
     }
   }
@@ -190,6 +201,15 @@ class _OnboardingState extends State<Onboarding> {
                   .push(MaterialPageRoute<void>(builder: (_) => DisclosurePage(shown: widget.full))),
             ),
           ),
+          reads(Lines.MP_66),
+          for (final consent in Consent.values) ...[
+            reads(consentText(consent)),
+            ConsentChoice(
+              consent: consent,
+              chosen: _answers[consent],
+              onChoose: (given) => setState(() => _answers[consent] = given),
+            ),
+          ],
         ];
     }
   }
@@ -198,7 +218,7 @@ class _OnboardingState extends State<Onboarding> {
     _Step.underAge => null,
     _Step.consent => ButtonRow(
       left: PlainButton(Lines.EM_6.text(appLanguage), onPressed: () => _to(_Step.disclosure)),
-      right: PlainButton(Lines.MP_67.parts(appLanguage).first, onPressed: widget.onAgreed),
+      right: PlainButton(Lines.MP_30.text(appLanguage), onPressed: _next),
     ),
     _ => _one(PlainButton(Lines.MP_30.text(appLanguage), onPressed: _next)),
   };
diff --git a/app/lib/settings/consent_page.dart b/app/lib/settings/consent_page.dart
new file mode 100644
index 0000000..67a25c6
--- /dev/null
+++ b/app/lib/settings/consent_page.dart
@@ -0,0 +1,124 @@
+// The three consents' words and their choice (C18-P, MP·66 to MP·70;
+// C159-I item 5; D110; D122): each consent's text, then MP·67's two choices,
+// "I consent" and "I don't consent", side by side, equally prominent,
+// neither chosen beforehand; the chosen one filled (color.button.filled, a
+// stand-in). Onboarding shows all three (MP·66 above them); Settings shows
+// one on its own page when a setting needs it (the stop's questions 6, 7
+// and 10), whose back control gives nothing. MP·68 and MP·70 are "to
+// rewrite" and show their owed sentences in braces, as filed, in SoulDreams
+// Dev only (D119 item 2; D122, Q1 (B)).
+import 'package:flutter/material.dart';
+
+import '../core/app_line.dart';
+import '../core/language.dart';
+import '../design/palette.dart';
+import '../design/stand_ins.dart';
+import '../design/tokens.g.dart';
+import '../journal/pages/parts.dart';
+import '../words/lines.g.dart';
+import 'consents.dart';
+
+/// The consent's text: MP·68 (a), MP·69 (b), MP·70 (c).
+Line consentText(Consent consent) => switch (consent) {
+  Consent.readings => Lines.MP_68,
+  Consent.lifeContext => Lines.MP_69,
+  Consent.images => Lines.MP_70,
+};
+
+/// MP·67's two choices under one consent: [chosen] is null until one is
+/// tapped. Each tap tells [onChoose] true for "I consent".
+class ConsentChoice extends StatelessWidget {
+  const ConsentChoice({super.key, required this.consent, required this.chosen, required this.onChoose});
+
+  final Consent consent;
+  final bool? chosen;
+  final ValueChanged<bool> onChoose;
+
+  /// A choice's key: [given] true for "I consent".
+  static Key keyOf(Consent consent, bool given) => ValueKey('consent-${consent.name}-$given');
+
+  @override
+  Widget build(BuildContext context) {
+    final words = Lines.MP_67.parts(appLanguage);
+    Widget one(bool given, String text) => _Choice(
+      key: keyOf(consent, given),
+      text: text,
+      chosen: chosen == given,
+      onTap: () => onChoose(given),
+    );
+    return ButtonRow(left: one(true, words.first), right: one(false, words.last));
+  }
+}
+
+class _Choice extends StatelessWidget {
+  const _Choice({super.key, required this.text, required this.chosen, required this.onTap});
+
+  final String text;
+  final bool chosen;
+  final VoidCallback onTap;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final filled = Theme.of(context).brightness == Brightness.dark ? DarkColours.buttonFilled : LightColours.buttonFilled;
+    final top = chosen ? filled.colour! : p.buttonTop;
+    final bottom = chosen ? (filled.colourEnd ?? filled.colour!) : p.buttonBottom;
+    return Semantics(
+      button: true,
+      selected: chosen,
+      child: GestureDetector(
+        onTap: onTap,
+        child: DecoratedBox(
+          decoration: BoxDecoration(
+            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]),
+            borderRadius: BorderRadius.circular(Spacing.radius),
+            border: Border.all(color: p.buttonBorder),
+          ),
+          child: Padding(
+            padding: StandIns.buttonPadding,
+            child: Text(text, style: TypeRoles.button.style(chosen ? filled.text! : p.buttonText)),
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// One consent on its own page, from Settings: its text, then the two
+/// choices. Pops true for "I consent", false for "I don't consent", null
+/// for the back control.
+class ConsentPage extends StatelessWidget {
+  const ConsentPage({super.key, required this.consent});
+
+  final Consent consent;
+
+  /// Shows [consent]'s page; true only when the dreamer consents.
+  static Future<bool> ask(BuildContext context, Consent consent) async =>
+      await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => ConsentPage(consent: consent))) ==
+      true;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Scaffold(
+      body: SafeArea(
+        child: ListView(
+          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.gap),
+          children: [
+            Align(alignment: Alignment.topLeft, child: BackControl(onPressed: () => Navigator.of(context).pop())),
+            const SizedBox(height: StandIns.gap),
+            DecoratedBox(
+              decoration: surface(p),
+              child: Padding(
+                padding: Spacing.onboardingBox,
+                child: AppLine(consentText(consent).text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+              ),
+            ),
+            const SizedBox(height: StandIns.gap),
+            ConsentChoice(consent: consent, chosen: null, onChoose: (given) => Navigator.of(context).pop(given)),
+          ],
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index b0fcd21..e5a3c73 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -76,6 +76,9 @@ T answered<T extends MemoryJournalFiles>(T files, Map<Consent, bool> given) {
   return files;
 }
 
+/// Onboarding's answers: (a) given, (b) and (c) not (D122).
+const readingsOnly = {Consent.readings: true, Consent.lifeContext: false, Consent.images: false};
+
 /// A night with a recording waiting, its audio kept, in [files].
 Future<void> waiting(MemoryJournalFiles files) async {
   final store = await JournalStore.open(files);
@@ -302,8 +305,8 @@ void main() {
       home: JournalHome(files: files, recording: counted(links)),
     ));
     await tester.pumpAndSettle();
-    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
-    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
     await tester.pump();
     await tester.pump();
     expect(find.byType(JournalPage), findsOneWidget);
@@ -333,13 +336,13 @@ void main() {
     await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links))));
     await tester.pumpAndSettle();
     final agree = tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed;
-    agree();
+    agree(readingsOnly);
     await tester.pump();
     await tester.pump();
     expect(find.byType(JournalPage), findsOneWidget);
     expect(links, hasLength(1));
     final settings = tester.widget<JournalPage>(find.byType(JournalPage)).settings;
-    agree();
+    agree(readingsOnly);
     await tester.pump();
     await tester.pump();
     expect(links, hasLength(1));
@@ -356,13 +359,13 @@ void main() {
     final files = MemoryJournalFiles();
     await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
     await tester.pumpAndSettle();
-    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
     await tester.pumpAndSettle();
     expect(find.byType(JournalPage), findsOneWidget);
     await tester.widget<JournalPage>(find.byType(JournalPage)).journal.deleteAll();
     await tester.pumpAndSettle();
     expect(find.byType(Onboarding), findsOneWidget);
-    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
     await tester.pumpAndSettle();
     expect(find.byType(JournalPage), findsOneWidget);
     expect(files.files.keys, contains(JournalStore.consentFile));
@@ -377,7 +380,7 @@ void main() {
     final files = NoRename();
     await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
     await tester.pumpAndSettle();
-    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
     await tester.pumpAndSettle();
     expect(find.byType(JournalPage), findsOneWidget);
     expect(lines, ['consentKeepFailed', 'journalAudio 0 0']);
@@ -548,4 +551,23 @@ void main() {
     expect(tester.widget<JournalPage>(find.byType(JournalPage)).settings!.settings, const Settings());
     expect(lines, ['settingsReadFailed', 'journalAudio 0 0']);
   });
+
+  // D122: the three answers from onboarding are kept as given, with the
+  // day; (c) given, Night images is Personal (the stop's question 6).
+  testWidgets('the three answers are kept as given', (tester) async {
+    JournalStore.newQueueForTests();
+    final files = MemoryJournalFiles();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
+    await tester.pumpAndSettle();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(
+      const {Consent.readings: false, Consent.lifeContext: true, Consent.images: true},
+    );
+    await tester.pumpAndSettle();
+    final page = tester.widget<JournalPage>(find.byType(JournalPage));
+    expect(page.recording, isNull);
+    expect(page.images, isTrue);
+    expect(page.settings!.nightImages, NightImages.personal);
+    final kept = decodeConsents(files.files[JournalStore.consentFile]!)!;
+    expect([for (final c in Consent.values) kept.given(c)], [false, true, true]);
+  });
 }
diff --git a/app/test/onboarding/onboarding_test.dart b/app/test/onboarding/onboarding_test.dart
index 9205f4c..4e456ac 100644
--- a/app/test/onboarding/onboarding_test.dart
+++ b/app/test/onboarding/onboarding_test.dart
@@ -1,8 +1,10 @@
 // Onboarding (main-path.md, Onboarding; D103): the welcome, the note, the
 // age question, the under-18 card, and the disclosure's first layer on two
-// pages with one consent; MP·58 opens every part, and back returns to the
-// consent. Every word is the register's; a part with no line shows nothing
-// in its place (D106 3).
+// pages, the second ending in the three consents (MP·66 to MP·70; D122);
+// MP·58 opens every part, and back returns to the consents. Every word is
+// the register's; a part with no line shows nothing in its place (D106 3).
+import 'dart:ui' show Tristate;
+
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/app.dart';
@@ -13,24 +15,31 @@ import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/onboarding/age.dart';
 import 'package:souldreams/onboarding/disclosure_page.dart';
 import 'package:souldreams/onboarding/onboarding.dart';
+import 'package:souldreams/settings/consent_page.dart';
+import 'package:souldreams/settings/consents.dart';
 import 'package:souldreams/words/lines.g.dart';
 
 String w(Line line) => line.parts(appLanguage).join('\n');
 
 Finder said(Line line) => find.text(w(line));
 
-/// The consent button: MP·67's first part, in place of the retired MP·8
-/// (D119).
-Finder consent() => find.text(Lines.MP_67.parts(appLanguage).first);
+/// The readings consent's "I consent" (MP·67's first part; D122).
+Finder consent() => find.byKey(ConsentChoice.keyOf(Consent.readings, true));
 
 void main() {
   late int agreed;
+  Map<Consent, bool>? answers;
+
+  void told(Map<Consent, bool> given) {
+    agreed++;
+    answers = given;
+  }
 
   Future<void> start(WidgetTester tester) async {
     agreed = 0;
     await tester.pumpWidget(SoulDreamsApp(
       clock: () => DateTime(2026, 6, 10, 12),
-      home: Onboarding(onAgreed: () => agreed++),
+      home: Onboarding(onAgreed: told),
     ));
     await tester.pumpAndSettle();
   }
@@ -126,12 +135,37 @@ void main() {
       expect(said(line), findsOneWidget, reason: line.handle);
     }
     expect(said(Lines.W27_1), findsNothing);
-    expect(find.byType(ButtonRow), findsOneWidget);
-    expect(consent(), findsOneWidget);
-    expect(find.text(Lines.MP_67.parts(appLanguage)[1]), findsNothing);
-    expect(said(Lines.EM_6), findsOneWidget);
-    // EM·6 left, the consent right (the plan's question 6; D119).
-    expect(tester.getCenter(said(Lines.EM_6)).dx, lessThan(tester.getCenter(consent()).dx));
+    // MP·66, then each consent's text over its two choices, in order (D122).
+    final order = [Lines.MP_57, Lines.MP_66, Lines.MP_68, Lines.MP_69, Lines.MP_70];
+    final ys = [for (final line in order) tester.getTopLeft(said(line)).dy];
+    expect(ys, [...ys]..sort());
+    expect(find.byType(ConsentChoice), findsNWidgets(3));
+    for (final (i, c) in Consent.values.indexed) {
+      final yes = find.byKey(ConsentChoice.keyOf(c, true));
+      final no = find.byKey(ConsentChoice.keyOf(c, false));
+      expect(find.descendant(of: yes, matching: find.text(Lines.MP_67.parts(appLanguage)[0])), findsOneWidget);
+      expect(find.descendant(of: no, matching: find.text(Lines.MP_67.parts(appLanguage)[1])), findsOneWidget);
+      // Side by side, under its own text.
+      expect(tester.getCenter(yes).dy, tester.getCenter(no).dy);
+      expect(tester.getTopLeft(yes).dy, greaterThan(ys[i + 2]));
+      // Neither chosen beforehand.
+      expect(tester.getSemantics(yes).flagsCollection.isSelected, Tristate.isFalse);
+      expect(tester.getSemantics(no).flagsCollection.isSelected, Tristate.isFalse);
+    }
+    // EM·6 left, Next right (the stop's question 3; D122).
+    expect(tester.getCenter(said(Lines.EM_6)).dx, lessThan(tester.getCenter(said(Lines.MP_30)).dx));
+  });
+
+  // D122: MP·68 and MP·70 show as filed, their owed sentences in braces
+  // (Dev only), and MP·69 whole.
+  testWidgets('the three consents show their lines as filed', (tester) async {
+    await start(tester);
+    await toDisclosure(tester);
+    await tap(tester, Lines.MP_30);
+    for (final line in [Lines.MP_66, Lines.MP_68, Lines.MP_69, Lines.MP_70]) {
+      expect(said(line), findsOneWidget, reason: line.handle);
+    }
+    expect(w(Lines.MP_68), contains('{'));
   });
 
   testWidgets('the first layer only: no part of the full page alone', (tester) async {
@@ -170,7 +204,7 @@ void main() {
     await tester.pumpWidget(SoulDreamsApp(
       clock: () => DateTime(2026, 6, 10, 12),
       home: Onboarding(
-        onAgreed: () => agreed++,
+        onAgreed: told,
         first: const [Lines.W27_1, none],
         second: const [none, Lines.W27_14],
         full: const [none, Lines.W27_3],
@@ -191,7 +225,7 @@ void main() {
   });
 
   test('the pages default to their parts', () {
-    final o = Onboarding(onAgreed: () {});
+    final o = Onboarding(onAgreed: (_) {});
     expect(o.first, Onboarding.firstPage);
     expect(o.second, Onboarding.secondPage);
     expect(o.full, DisclosurePage.parts);
@@ -226,7 +260,7 @@ void main() {
   testWidgets('the words appear all at once, not word by word', (tester) async {
     await tester.pumpWidget(SoulDreamsApp(
       clock: () => DateTime(2026, 6, 10, 12),
-      home: Onboarding(onAgreed: () => agreed++),
+      home: Onboarding(onAgreed: told),
     ));
     await tester.pump();
     final rich = tester.widgetList<RichText>(find.descendant(of: find.byType(AppLine), matching: find.byType(RichText)));
@@ -297,13 +331,32 @@ void main() {
     expect(agreed, 0);
   });
 
-  testWidgets('I agree is told once', (tester) async {
+  Future<void> answer(WidgetTester tester, Consent c, bool given) async {
+    final f = find.byKey(ConsentChoice.keyOf(c, given));
+    await tester.ensureVisible(f);
+    await tester.tap(f);
+    await tester.pumpAndSettle();
+  }
+
+  // D122: Next waits until all three are answered; then the answers are
+  // told once, and any answers open the journal, all three refused too.
+  testWidgets('Next waits for all three answers, then tells them once', (tester) async {
     await start(tester);
     await toDisclosure(tester);
     await tap(tester, Lines.MP_30);
-    await tester.tap(consent());
-    await tester.pumpAndSettle();
+    await answer(tester, Consent.readings, true);
+    await answer(tester, Consent.images, false);
+    await tap(tester, Lines.MP_30);
+    expect(agreed, 0);
+    await answer(tester, Consent.lifeContext, false);
+    // A choice can be changed before Next; the chosen one is marked.
+    await answer(tester, Consent.readings, false);
+    final no = find.byKey(ConsentChoice.keyOf(Consent.readings, false));
+    expect(tester.getSemantics(no).flagsCollection.isSelected, Tristate.isTrue);
+    expect(tester.getSemantics(consent()).flagsCollection.isSelected, Tristate.isFalse);
+    await tap(tester, Lines.MP_30);
     expect(agreed, 1);
+    expect(answers, {Consent.readings: false, Consent.lifeContext: false, Consent.images: false});
   });
 
   testWidgets('Read everything opens every part; back returns to the consent', (tester) async {
diff --git a/app/test/settings/consent_page_test.dart b/app/test/settings/consent_page_test.dart
new file mode 100644
index 0000000..72c0b68
--- /dev/null
+++ b/app/test/settings/consent_page_test.dart
@@ -0,0 +1,55 @@
+// One consent on its own page, from Settings (D122, the stop's questions 6,
+// 7 and 10): its text, then MP·67's two choices; only "I consent" gives it,
+// and the back control gives nothing.
+import 'dart:ui' show Tristate;
+
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/core/language.dart';
+import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/settings/consent_page.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+void main() {
+  test('each consent has its text', () {
+    expect([for (final c in Consent.values) consentText(c).handle], ['MP·68', 'MP·69', 'MP·70']);
+  });
+
+  for (final (how, expected) in [('yes', true), ('no', false), ('back', false)]) {
+    testWidgets('the page answers $expected for $how', (tester) async {
+      bool? answer;
+      await tester.pumpWidget(
+        SoulDreamsApp(
+          clock: () => DateTime(2026, 6, 10, 12),
+          home: Builder(
+            builder: (context) => Center(
+              child: GestureDetector(
+                key: const Key('ask'),
+                behavior: HitTestBehavior.opaque,
+                onTap: () async => answer = await ConsentPage.ask(context, Consent.lifeContext),
+                child: const SizedBox.square(dimension: 40),
+              ),
+            ),
+          ),
+        ),
+      );
+      await tester.tap(find.byKey(const Key('ask')));
+      await tester.pumpAndSettle();
+      expect(find.text(Lines.MP_69.text(appLanguage)), findsOneWidget);
+      final yes = find.byKey(ConsentChoice.keyOf(Consent.lifeContext, true));
+      final no = find.byKey(ConsentChoice.keyOf(Consent.lifeContext, false));
+      expect(tester.getSemantics(yes).flagsCollection.isSelected, Tristate.isFalse);
+      expect(tester.getSemantics(no).flagsCollection.isSelected, Tristate.isFalse);
+      await tester.tap(switch (how) {
+        'yes' => yes,
+        'no' => no,
+        _ => find.byType(BackControl),
+      });
+      await tester.pumpAndSettle();
+      expect(find.byType(ConsentPage), findsNothing);
+      expect(answer, expected);
+    });
+  }
+}
diff --git a/app/test/words/shown_lines_test.dart b/app/test/words/shown_lines_test.dart
index c5c5f67..c53a3aa 100644
--- a/app/test/words/shown_lines_test.dart
+++ b/app/test/words/shown_lines_test.dart
@@ -1,15 +1,18 @@
-// No shown line may carry an unfilled braced sentence (docs/Status.md,
-// "Before Cohort 1"; D119 item 2). A place "to rewrite" is built as written,
-// and a sentence still owed in it stays whole in braces (MP·68, MP·70).
-// That is fine while no screen shows the place: this test fails the moment
-// any file in lib/ (outside lib/words/) names a place whose line holds a
-// brace that is not one of the generator's four slots. `flutter test` runs
-// in app/.
+// No tester or founder build may show an unfilled braced sentence
+// (docs/Status.md, "Before Cohort 1" item 4; D119 item 2; D122, Q1 (B)). A
+// place "to rewrite" is built as written, and a sentence still owed in it
+// stays whole in braces (MP·68, MP·70). SoulDreams Dev shows them as filed
+// (D122): this test fails the moment any file that main.dart or
+// main_founder.dart reaches (following imports, as dev_only_test.dart does)
+// names a place whose line holds a brace that is not one of the generator's
+// four slots. `flutter test` runs in app/.
 import 'dart:io';
 
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/words/lines.g.dart';
 
+import '../dev_only_test.dart' show reached;
+
 /// The generator's slots (tool/checks/wordsgen.py, SLOTS): the only braces a
 /// shown line may hold, and only because the screen fills them.
 const slots = ['{n}', '{pointed image}', '{tradition}', '{read image}'];
@@ -23,15 +26,14 @@ bool braced(String part) {
   return rest.contains('{') || rest.contains('}');
 }
 
-/// The names of the places the screens' code names: every `Lines.<name>` in
-/// lib/ outside lib/words/, comments left out.
-Set<String> named() {
+/// The names of the places [files] name: every `Lines.<name>` in them
+/// outside lib/words/, comments left out.
+Set<String> named(Iterable<String> files) {
   final out = <String>{};
   final ref = RegExp(r'\bLines\.([A-Za-z_][A-Za-z0-9_]*)');
-  for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
-    final path = f.path.replaceAll('\\', '/');
+  for (final path in files) {
     if (!path.endsWith('.dart') || path.contains('lib/words/')) continue;
-    for (final line in f.readAsLinesSync()) {
+    for (final line in File(path).readAsLinesSync()) {
       for (final m in ref.allMatches(line.replaceFirst(RegExp(r'//.*$'), ''))) {
         out.add(m[1]!);
       }
@@ -54,27 +56,31 @@ void main() {
     expect(braced('{what it keeps}'), isTrue);
   });
 
+  /// The places [names] holds whose line, in either language, has a brace
+  /// outside the slots.
+  List<String> bracedIn(Set<String> names) => [
+    for (final l in Lines.all.where((l) => names.contains(dartName(l))))
+      if (Lang.values.any((lang) => l.parts(lang).any(braced))) l.handle,
+  ];
+
   test('the scan sees the places the screens use', () {
-    final seen = named();
+    final seen = named(reached('lib/main_dev.dart'));
     // One plain place and one with a slot, so a scan that finds nothing, or
-    // misses the places with a slot, fails here and not silently.
-    expect(seen, containsAll(['MP_11', 'MP_76']));
+    // misses the places with a slot, fails here and not silently; and the
+    // two consents Dev shows with their braces (D122).
+    expect(seen, containsAll(['MP_11', 'MP_76', 'MP_68', 'MP_70']));
     expect(seen, isNot(contains('all')), reason: 'a screen reaching Lines.all would hide what it shows');
+    expect(bracedIn(seen), containsAll(['MP·68', 'MP·70']));
   });
 
   test('every place the screens name is in the register', () {
     final known = {for (final l in Lines.all) dartName(l)};
-    expect(named().where((n) => !known.contains(n)), isEmpty);
+    expect(named(reached('lib/main_dev.dart')).where((n) => !known.contains(n)), isEmpty);
   });
 
-  test('no shown place has a braced sentence, in either language', () {
-    final shown = named();
-    for (final l in Lines.all.where((l) => shown.contains(dartName(l)))) {
-      for (final lang in Lang.values) {
-        for (final part in l.parts(lang)) {
-          expect(braced(part), isFalse, reason: '${l.handle} $lang');
-        }
-      }
+  test('no tester or founder build shows a braced sentence', () {
+    for (final entry in ['lib/main.dart', 'lib/main_founder.dart']) {
+      expect(bracedIn(named(reached(entry))), isEmpty, reason: entry);
     }
   });
 }
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index a80f411..28af98f 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1371,9 +1371,9 @@ ROWS = [
      '[Lines.W27_14, Lines.W27_15, Lines.MP_57]',
      'test/onboarding/onboarding_test.dart', 'the two pages hold these parts, in order'),
     ('A291', 'lib/onboarding/onboarding.dart',
-     'right: PlainButton(Lines.MP_67.parts(appLanguage).first, onPressed: widget.onAgreed),',
-     'right: PlainButton(Lines.MP_67.parts(appLanguage).first, onPressed: () {}),',
-     'test/onboarding/onboarding_test.dart', 'I agree is told once'),
+     'right: PlainButton(Lines.MP_30.text(appLanguage), onPressed: _next),',
+     'right: PlainButton(Lines.MP_30.text(appLanguage), onPressed: () {}),',
+     'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
     ('A292', 'lib/onboarding/disclosure_page.dart',
      '    Lines.W27_6,\n',
      '',
@@ -2005,8 +2005,8 @@ ROWS = [
      'style: TypeRoles.h6.style(NightArt.over))),',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
     ('A443', 'lib/onboarding/onboarding.dart',
-     'PlainButton(Lines.MP_67.parts(appLanguage).first, onPressed: widget.onAgreed)',
-     'PlainButton(Lines.MP_67.parts(appLanguage).last, onPressed: widget.onAgreed)',
+     'right: PlainButton(Lines.MP_30.text(appLanguage), onPressed: _next),',
+     'right: PlainButton(Lines.EM_6.text(appLanguage), onPressed: _next),',
      'test/onboarding/onboarding_test.dart', '18 or over: the disclosure first page, then the consent'),
     # redesign-b, Task 1 (D119 item 4): the greeting, New Dream and the jump
     # buttons take their filed lines.
@@ -2158,10 +2158,10 @@ ROWS = [
      '          query: _search.text,\n',
      'test/journal/pages/journal_search_test.dart', 'a row opened with no search hands no query'),
     # D119 item 2 (the owner's addition): no shown line holds an unfilled braced sentence
-    ('A480', 'lib/onboarding/disclosure_page.dart',
-     '    Lines.W27_6,\n',
-     '    Lines.MP_68,\n',
-     'test/words/shown_lines_test.dart', 'no shown place has a braced sentence, in either language'),
+    ('A480', 'lib/main.dart',
+     "import 'core/safe_log.dart';\n",
+     "import 'core/safe_log.dart';\nimport 'settings/consent_page.dart';\n",
+     'test/words/shown_lines_test.dart', 'no tester or founder build shows a braced sentence'),
     ('A481', 'test/words/shown_lines_test.dart',
      "    rest = rest.replaceAll(slot, '');\n",
      '',
@@ -2267,14 +2267,10 @@ ROWS = [
      '_run(() => _whole(settingsFile, ',
      '_run(() => _files.write(settingsFile, ',
      'test/journal/journal_store_test.dart', 'settings cut short leave none and no temporary file'),
-    ('A507', 'lib/journal/pages/journal_home.dart',
-     'Consents.answered({Consent.readings: true}, journal.now())',
-     'Consents.answered({Consent.readings: false}, journal.now())',
-     'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
     ('A508', 'lib/settings/consents.dart',
      'Answer(given[c] ?? false, dayOf(now))',
      'Answer(given[c] ?? true, dayOf(now))',
-     'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
+     'test/settings/settings_controller_test.dart', 'a consent answered shows at once, then is kept'),
     ('A509', 'lib/journal/night_look.dart',
      'images && read && paintings > 0',
      'read && paintings > 0',
@@ -2387,6 +2383,46 @@ ROWS = [
      'last.substring(0, last.length - 1)]',
      'last]',
      'test/settings/setting_line_test.dart', 'each setting line gives its name and choices, both languages'),
+    ('A537', 'lib/onboarding/onboarding.dart',
+     '        if (_answers.length < Consent.values.length) return;\n',
+     '',
+     'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
+    ('A538', 'lib/onboarding/onboarding.dart',
+     'setState(() => _answers[consent] = given)',
+     'setState(() => _answers[consent] = true)',
+     'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
+    ('A539', 'lib/settings/consent_page.dart',
+     '      chosen: chosen == given,\n',
+     '      chosen: false,\n',
+     'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
+    ('A540', 'lib/settings/consent_page.dart',
+     'right: one(false, words.last)',
+     'right: one(false, words.first)',
+     'test/onboarding/onboarding_test.dart', '18 or over: the disclosure first page, then the consent'),
+    ('A541', 'lib/settings/consent_page.dart',
+     '  Consent.images => Lines.MP_70,',
+     '  Consent.images => Lines.MP_69,',
+     'test/settings/consent_page_test.dart', 'each consent has its text'),
+    ('A542', 'lib/settings/consent_page.dart',
+     '      true;\n',
+     '      false;\n',
+     'test/settings/consent_page_test.dart', 'the page answers true for yes'),
+    ('A543', 'lib/onboarding/onboarding.dart',
+     '          reads(Lines.MP_66),\n',
+     '',
+     'test/onboarding/onboarding_test.dart', 'the three consents show their lines as filed'),
+    ('A544', 'lib/journal/pages/journal_home.dart',
+     'Consents.answered(given, journal.now())',
+     'Consents.answered({...given, Consent.images: false}, journal.now())',
+     'test/journal/pages/journal_home_test.dart', 'the three answers are kept as given'),
+    ('A545', 'test/words/shown_lines_test.dart',
+     '      if (Lang.values.any((lang) => l.parts(lang).any(braced))) l.handle,',
+     '      if (false) l.handle,',
+     'test/words/shown_lines_test.dart', 'the scan sees the places the screens use'),
+    ('A546', 'lib/settings/consent_page.dart',
+     '      selected: chosen,\n',
+     '      selected: false,\n',
+     'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
 ]
 
 
~~~~

### Task 5 · Settings and the gear (main-path.md, Settings; D110; D121; D122)

`settings/settings_page.dart`:
- The back control and the quick toggle.
- MP·25.
- The six rows, each pill heard as the row's name and its value.
- The three actions and the confirmations.

`journal_page.dart`: the gear (`_Gear`, drawn), top left with a field under it; the sky mark at 140.
`sky_mark.dart`: a size. `stand_ins.dart`: the gear's, the rows', the pill's and the toggle's values (TO TRY).
`consent_page.dart`: a scrolling column, so a long consent's choices are always built.

Tests:
- `settings_page_test.dart` (new): 10 tests, on a phone-sized view (390 by 844), with large text included.
- `journal_search_test.dart`: the gear, and no gear without settings (2 new).

Rows:
- New: A547 to A570.
- Following their code: A473, and A539 and A542, whose lines the formatter rejoined.

Expected: 649 app tests; `python3 -I -B tool/app_mutations.py --files lib/journal/pages/journal_page.dart,lib/journal/pages/sky_mark.dart,lib/design/stand_ins.dart,lib/settings/settings_page.dart`, every one caught. Commit:

> Settings page and the journal's gear (D110, D121, D122)

**The block:**

~~~~diff
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index db0c1d0..cec3c65 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -32,6 +32,17 @@ abstract final class StandIns {
   /// its magnifier, drawn as a ring and a handle, and the space after it;
   /// and the space between a result's row and its context line (D117 Q8).
   static const double searchAbove = 20;
+
+  /// Settings (D122; TO TRY): the gear's drawing inside its 41 circle, and
+  /// the space under its tap box, above the search field; a row's padding,
+  /// its value pill's, the pill's small chevron (pointing down); the quick
+  /// toggle's sun or moon inside its circle.
+  static const gear = Size(22, 22);
+  static const double gearBelow = 8;
+  static const settingPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 10);
+  static const settingValuePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 10);
+  static const settingChevron = Size(7, 12);
+  static const toggleMark = Size(26, 26);
   static const searchPadding = EdgeInsets.symmetric(horizontal: 18);
   static const magnifier = Size(16, 16);
   static const double magnifierStroke = 1.5;
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index af73c0a..82ce835 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -7,9 +7,10 @@
 // a time; a month divider over each month with nights; C4-P·5 when there is
 // no night. Straight from onboarding, the first empty journal also shows
 // MP·9 under New Dream, with an arrow up to it, once (main-path.md,
-// Onboarding, 5); the logo waits for the founder's file. No Settings entry
-// (a later branch, D116 item 5). Nothing on a row grades it: no badge,
-// count or status.
+// Onboarding, 5); the logo waits for the founder's file. The gear, top
+// left above the search field, opens Settings (main-path.md, Settings;
+// D110; D122): drawn in code in a 41 bordered circle in a 44 tap box, spoken
+// as MP·25. Nothing on a row grades it: no badge, count or status.
 // Search (D110; D116; D117): the field at the top, as wide as a row, EM·4
 // its placeholder, a magnifier drawn in code and silent, no clear button.
 // From three characters, where the list starts: the count of nights (MP·76)
@@ -17,8 +18,9 @@
 // month dividers, each with its context line under it, the match in Inter
 // Bold. The query lives only while the page does: never kept, never logged
 // (R3), no recent searches.
-// The sky mark stays 140 down.
+// The search field sits under the gear; the sky mark stays 140 down.
 import 'dart:async';
+import 'dart:math';
 
 import 'package:flutter/material.dart';
 
@@ -31,6 +33,7 @@ import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
 import '../../settings/settings_controller.dart';
+import '../../settings/settings_page.dart';
 import '../greeting.dart';
 import '../journal.dart';
 import '../night.dart';
@@ -64,6 +67,7 @@ class JournalPage extends StatefulWidget {
   final bool firstTime;
 
   static const arrowKey = Key('first-arrow');
+  static const gearKey = Key('gear');
   static const newDreamKey = Key('new-dream');
   static const searchKey = Key('search');
   static const searchFieldKey = Key('search-field');
@@ -239,11 +243,26 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
         child: ListView(
           padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.searchAbove, Spacing.pageSide, StandIns.journalEnd),
           children: [
+            if (widget.settings case final settings?) ...[
+              Align(
+                alignment: Alignment.topLeft,
+                child: _Gear(
+                  onPressed: () => _push(SettingsPage(journal: widget.journal, settings: settings)),
+                ),
+              ),
+              const SizedBox(height: StandIns.gearBelow),
+            ],
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: StandIns.rowSide - Spacing.pageSide),
               child: _SearchField(_search),
             ),
-            const SizedBox(height: StandIns.greetingAbove - StandIns.searchAbove - Spacing.sizeFieldSearch),
+            SizedBox(
+              height:
+                  StandIns.greetingAbove -
+                  StandIns.searchAbove -
+                  Spacing.sizeFieldSearch -
+                  (widget.settings == null ? 0 : StandIns.hitMin + StandIns.gearBelow),
+            ),
             // The sun by day, the moon by night, then the greeting (D112).
             Center(child: SkyMark(_sky)),
             const SizedBox(height: StandIns.skyGap),
@@ -296,6 +315,84 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   }
 }
 
+/// The gear (D122; TO TRY): a thin gear drawn in code in a round bordered
+/// button of 41 (color.button), in a tap box of 44, as the back control;
+/// spoken as MP·25.
+class _Gear extends StatelessWidget {
+  const _Gear({required this.onPressed});
+
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Semantics(
+      button: true,
+      label: Lines.MP_25.text(appLanguage),
+      excludeSemantics: true,
+      child: GestureDetector(
+        key: JournalPage.gearKey,
+        behavior: HitTestBehavior.opaque,
+        onTap: onPressed,
+        child: SizedBox.square(
+          dimension: StandIns.hitMin,
+          child: Align(
+            alignment: Alignment.topLeft,
+            child: SizedBox.square(
+              dimension: StandIns.backSize,
+              child: DecoratedBox(
+                decoration: BoxDecoration(
+                  shape: BoxShape.circle,
+                  gradient: LinearGradient(
+                    begin: Alignment.topCenter,
+                    end: Alignment.bottomCenter,
+                    colors: [p.buttonTop, p.buttonBottom],
+                  ),
+                  border: Border.all(color: p.buttonBorder),
+                ),
+                child: Center(
+                  child: SizedBox.fromSize(size: StandIns.gear, child: CustomPaint(painter: _GearLine(p.buttonText))),
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
+class _GearLine extends CustomPainter {
+  _GearLine(this.colour);
+
+  final Color colour;
+
+  /// How many teeth the gear has.
+  static const teeth = 8;
+
+  @override
+  void paint(Canvas canvas, Size size) {
+    final c = size.center(Offset.zero);
+    final r = size.shortestSide / 2;
+    final line = Paint()
+      ..color = colour
+      ..style = PaintingStyle.stroke
+      ..strokeWidth = StandIns.chevronStroke * 0.75
+      ..strokeCap = StrokeCap.round;
+    canvas.drawCircle(c, r * 0.62, line);
+    canvas.drawCircle(c, r * 0.25, line);
+    for (var i = 0; i < teeth; i++) {
+      final a = i * 2 * pi / teeth;
+      final d = Offset(cos(a), sin(a));
+      canvas.drawLine(c + d * (r * 0.66), c + d * (r * 0.95), line..strokeWidth = StandIns.chevronStroke * 1.4);
+      line.strokeWidth = StandIns.chevronStroke * 0.75;
+    }
+  }
+
+  @override
+  bool shouldRepaint(_GearLine old) => old.colour != colour;
+}
+
 /// The search's count: one night, more, or none (D117 Q2, Q3, Q5).
 String _count(int nights) => switch (nights) {
   0 => Lines.W25.text(appLanguage),
diff --git a/app/lib/journal/pages/sky_mark.dart b/app/lib/journal/pages/sky_mark.dart
index 0c85cff..e1539d4 100644
--- a/app/lib/journal/pages/sky_mark.dart
+++ b/app/lib/journal/pages/sky_mark.dart
@@ -9,16 +9,19 @@ import '../../design/stand_ins.dart';
 import '../sky.dart';
 
 class SkyMark extends StatelessWidget {
-  const SkyMark(this.sky, {super.key});
+  const SkyMark(this.sky, {super.key, this.size = StandIns.skyMark});
 
   final Sky sky;
 
+  /// Its size: the journal's, unless given (Settings' quick toggle).
+  final Size size;
+
   /// How many rays the sun has.
   static const rays = 8;
 
   @override
   Widget build(BuildContext context) => ExcludeSemantics(
-    child: SizedBox.fromSize(size: StandIns.skyMark, child: CustomPaint(painter: _SkyPainter(sky))),
+    child: SizedBox.fromSize(size: size, child: CustomPaint(painter: _SkyPainter(sky))),
   );
 }
 
diff --git a/app/lib/settings/consent_page.dart b/app/lib/settings/consent_page.dart
index 67a25c6..536f377 100644
--- a/app/lib/settings/consent_page.dart
+++ b/app/lib/settings/consent_page.dart
@@ -40,12 +40,8 @@ class ConsentChoice extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     final words = Lines.MP_67.parts(appLanguage);
-    Widget one(bool given, String text) => _Choice(
-      key: keyOf(consent, given),
-      text: text,
-      chosen: chosen == given,
-      onTap: () => onChoose(given),
-    );
+    Widget one(bool given, String text) =>
+        _Choice(key: keyOf(consent, given), text: text, chosen: chosen == given, onTap: () => onChoose(given));
     return ButtonRow(left: one(true, words.first), right: one(false, words.last));
   }
 }
@@ -60,7 +56,9 @@ class _Choice extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     final p = Palette.of(context);
-    final filled = Theme.of(context).brightness == Brightness.dark ? DarkColours.buttonFilled : LightColours.buttonFilled;
+    final filled = Theme.of(context).brightness == Brightness.dark
+        ? DarkColours.buttonFilled
+        : LightColours.buttonFilled;
     final top = chosen ? filled.colour! : p.buttonTop;
     final bottom = chosen ? (filled.colourEnd ?? filled.colour!) : p.buttonBottom;
     return Semantics(
@@ -94,29 +92,34 @@ class ConsentPage extends StatelessWidget {
 
   /// Shows [consent]'s page; true only when the dreamer consents.
   static Future<bool> ask(BuildContext context, Consent consent) async =>
-      await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => ConsentPage(consent: consent))) ==
-      true;
+      await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => ConsentPage(consent: consent))) == true;
 
   @override
   Widget build(BuildContext context) {
     final p = Palette.of(context);
     return Scaffold(
       body: SafeArea(
-        child: ListView(
+        child: SingleChildScrollView(
           padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.gap),
-          children: [
-            Align(alignment: Alignment.topLeft, child: BackControl(onPressed: () => Navigator.of(context).pop())),
-            const SizedBox(height: StandIns.gap),
-            DecoratedBox(
-              decoration: surface(p),
-              child: Padding(
-                padding: Spacing.onboardingBox,
-                child: AppLine(consentText(consent).text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+          child: Column(
+            crossAxisAlignment: CrossAxisAlignment.stretch,
+            children: [
+              Align(
+                alignment: Alignment.topLeft,
+                child: BackControl(onPressed: () => Navigator.of(context).pop()),
+              ),
+              const SizedBox(height: StandIns.gap),
+              DecoratedBox(
+                decoration: surface(p),
+                child: Padding(
+                  padding: Spacing.onboardingBox,
+                  child: AppLine(consentText(consent).text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
+                ),
               ),
-            ),
-            const SizedBox(height: StandIns.gap),
-            ConsentChoice(consent: consent, chosen: null, onChoose: (given) => Navigator.of(context).pop(given)),
-          ],
+              const SizedBox(height: StandIns.gap),
+              ConsentChoice(consent: consent, chosen: null, onChoose: (given) => Navigator.of(context).pop(given)),
+            ],
+          ),
         ),
       ),
     );
diff --git a/app/lib/settings/settings_page.dart b/app/lib/settings/settings_page.dart
new file mode 100644
index 0000000..f5e7d12
--- /dev/null
+++ b/app/lib/settings/settings_page.dart
@@ -0,0 +1,421 @@
+// Settings (main-path.md, Settings; Design System §6; C18-P; D110; D121;
+// D122), reached from the journal's gear, in SoulDreams Dev only: the back
+// control top left; the quick toggle top centre (MP·45), the sun in the
+// light theme and the moon in the dark, which switches the theme and sets
+// Night/Day mode to Manual; MP·25 in h2; then six rows, each its name and a
+// value pill opening the phone's menu: Language (EM·9; English only, its
+// name owed, D121 item 1), Word Animation (MP·26), Night images (MP·85),
+// Night/Day mode (MP·44), Life Context (MP·83) and Life Context length
+// (MP·84); then "Read disclosure & privacy" (MP·48), "Withdraw consent" or
+// "Give consent" (MP·95), and "Delete journal" (EM·11) in the destructive
+// style. No feedback (D121 item 4), no region, nothing of Help (R9).
+//
+// What needs a consent asks for it first (ConsentPage): Personal or Random
+// while (c) is not given, Life Context On while (b) is not, Give consent
+// for (a). Turning off asks only where the register has a confirmation:
+// MP·93 for Life Context, MP·96 for the readings; Night images Off withdraws
+// (c) with nothing lost. Delete journal asks once (C4-P·4), then everything
+// goes and the app starts again (D110). Each confirmation is the phone's
+// standard dialog, Cancel first (as a night's delete). The rows, the pills
+// and the toggle are stand-ins (TO TRY, P13).
+import 'package:flutter/cupertino.dart';
+import 'package:flutter/material.dart';
+
+import '../core/language.dart';
+import '../core/night_day.dart';
+import '../core/safe_log.dart';
+import '../design/palette.dart';
+import '../design/stand_ins.dart';
+import '../design/tokens.g.dart';
+import '../journal/journal.dart';
+import '../journal/pages/parts.dart';
+import '../journal/pages/sky_mark.dart';
+import '../journal/sky.dart';
+import '../onboarding/disclosure_page.dart';
+import '../words/lines.g.dart';
+import 'consent_page.dart';
+import 'consents.dart';
+import 'setting_line.dart';
+import 'settings.dart';
+import 'settings_controller.dart';
+
+/// The language's name, owed by Product: a visible placeholder (R1; the
+/// stop's question 4).
+const owedLanguage = '[owed·language]';
+
+/// Which row a key names.
+enum SettingRow { language, wordAnimation, nightImages, nightDay, lifeContext, length }
+
+class SettingsPage extends StatefulWidget {
+  const SettingsPage({super.key, required this.journal, required this.settings});
+
+  final Journal journal;
+  final SettingsController settings;
+
+  static const toggleKey = Key('settings-toggle');
+  static const disclosureKey = Key('settings-disclosure');
+  static const consentKey = Key('settings-consent');
+  static const deleteKey = Key('settings-delete');
+
+  /// A row's value pill.
+  static Key valueKey(SettingRow row) => ValueKey('setting-${row.name}');
+
+  /// A choice in a row's menu.
+  static Key choiceKey(SettingRow row, int index) => ValueKey('setting-${row.name}-$index');
+
+  @override
+  State<SettingsPage> createState() => _SettingsPageState();
+}
+
+class _SettingsPageState extends State<SettingsPage> {
+  SettingsController get _c => widget.settings;
+
+  @override
+  void initState() {
+    super.initState();
+    _c.addListener(_changed);
+  }
+
+  @override
+  void dispose() {
+    _c.removeListener(_changed);
+    super.dispose();
+  }
+
+  void _changed() {
+    if (mounted) setState(() {});
+  }
+
+  bool get _dark => Theme.of(context).brightness == Brightness.dark;
+
+  // The phone's standard dialog, Cancel (MP·61) first, [yes] destructive.
+  Future<bool> _confirm(Line text, Line yes) async =>
+      await showCupertinoDialog<bool>(
+        context: context,
+        builder: (context) => CupertinoAlertDialog(
+          content: Text(text.text(appLanguage)),
+          actions: [
+            CupertinoDialogAction(
+              onPressed: () => Navigator.of(context).pop(false),
+              child: Text(Lines.MP_61.text(appLanguage)),
+            ),
+            CupertinoDialogAction(
+              isDestructiveAction: true,
+              onPressed: () => Navigator.of(context).pop(true),
+              child: Text(yes.text(appLanguage)),
+            ),
+          ],
+        ),
+      ) ==
+      true;
+
+  // The quick toggle: the other theme, Manual (Design System §6).
+  void _toggle() => _c.change(_c.settings.copyWith(nightDay: _dark ? NightDayMode.day : NightDayMode.night));
+
+  void _wordAnimation(int i) => _c.change(_c.settings.copyWith(wordAnimation: i == 0));
+
+  Future<void> _nightImages(int i) async {
+    final choice = NightImages.values[i];
+    if (choice != NightImages.off && !_c.consents.given(Consent.images)) {
+      if (!await ConsentPage.ask(context, Consent.images)) return;
+    }
+    await _c.setImages(choice);
+  }
+
+  // Manual keeps the theme on screen (the stop's question 5).
+  void _nightDay(int i) => _c.change(
+    _c.settings.copyWith(nightDay: i == 0 ? NightDayMode.automatic : (_dark ? NightDayMode.night : NightDayMode.day)),
+  );
+
+  Future<void> _lifeContext(int i) async {
+    final on = i == 0;
+    if (on == _c.consents.given(Consent.lifeContext)) return;
+    final yes = on ? await ConsentPage.ask(context, Consent.lifeContext) : await _confirm(Lines.MP_93, Lines.MP_94);
+    if (yes) await _c.answer(Consent.lifeContext, on);
+  }
+
+  void _length(int i) => _c.change(_c.settings.copyWith(length: LifeContextLength.values[i]));
+
+  // Withdraw consent (a), behind MP·96; or give it, behind its text.
+  Future<void> _readings() async {
+    final given = _c.consents.given(Consent.readings);
+    final yes = given ? await _confirm(Lines.MP_96, Lines.MP_97) : await ConsentPage.ask(context, Consent.readings);
+    if (yes) await _c.answer(Consent.readings, !given);
+  }
+
+  // Delete journal (D110): one confirmation; then everything goes, and the
+  // journal's home returns to the start, closing this page.
+  Future<void> _delete() async {
+    if (!await _confirm(Lines.C4_P_4, Lines.MP_60)) return;
+    try {
+      await widget.journal.deleteAll();
+    } on Object {
+      SafeLog.event(LogEvent.journalDeleteFailed);
+    }
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final s = _c.settings;
+    final c = _c.consents;
+    Widget row(SettingRow key, Line line, int chosen, ValueChanged<int> onChoose) {
+      final words = settingWords(line, appLanguage);
+      return _Row(
+        row: key,
+        name: words?.name ?? '[${line.handle}]',
+        choices: words?.choices ?? const [],
+        chosen: chosen,
+        onChoose: onChoose,
+      );
+    }
+
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
+                      child: BackControl(onPressed: () => Navigator.of(context).pop()),
+                    ),
+                    Align(
+                      alignment: Alignment.topCenter,
+                      child: _Toggle(dark: _dark, onPressed: _toggle),
+                    ),
+                  ],
+                ),
+              ),
+              const SizedBox(height: StandIns.gap),
+              Semantics(
+                header: true,
+                child: Text(
+                  Lines.MP_25.text(appLanguage),
+                  textAlign: TextAlign.center,
+                  style: TypeRoles.h2.style(p.text),
+                ),
+              ),
+              const SizedBox(height: StandIns.gap),
+              _Row(
+                row: SettingRow.language,
+                name: Lines.EM_9.text(appLanguage),
+                choices: const [owedLanguage],
+                chosen: 0,
+                onChoose: (_) {},
+              ),
+              row(SettingRow.wordAnimation, Lines.MP_26, s.wordAnimation ? 0 : 1, _wordAnimation),
+              row(SettingRow.nightImages, Lines.MP_85, _c.nightImages.index, _nightImages),
+              row(SettingRow.nightDay, Lines.MP_44, s.nightDay == NightDayMode.automatic ? 0 : 1, _nightDay),
+              row(SettingRow.lifeContext, Lines.MP_83, c.given(Consent.lifeContext) ? 0 : 1, _lifeContext),
+              row(SettingRow.length, Lines.MP_84, s.length.index, _length),
+              const SizedBox(height: StandIns.listAbove),
+              _action(
+                PlainButton(
+                  key: SettingsPage.disclosureKey,
+                  Lines.MP_48.text(appLanguage),
+                  onPressed: () =>
+                      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DisclosurePage())),
+                ),
+              ),
+              const SizedBox(height: Spacing.journalRow),
+              _action(
+                PlainButton(
+                  key: SettingsPage.consentKey,
+                  Lines.MP_95.parts(appLanguage)[c.given(Consent.readings) ? 0 : 1],
+                  onPressed: _readings,
+                ),
+              ),
+              const SizedBox(height: Spacing.journalRow),
+              _action(_Destructive(Lines.EM_11.parts(appLanguage).first, onPressed: _delete)),
+            ],
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// An action below the rows, centred; at large text it shrinks its words to
+/// stay on one row, as the foot's pairs do (ButtonRow).
+Widget _action(Widget button) => Center(
+  child: FittedBox(fit: BoxFit.scaleDown, child: button),
+);
+
+/// A setting's row: a white rounded row, its name, then a value pill with
+/// a small chevron, opening the phone's menu of its choices.
+class _Row extends StatelessWidget {
+  const _Row({
+    required this.row,
+    required this.name,
+    required this.choices,
+    required this.chosen,
+    required this.onChoose,
+  });
+
+  final SettingRow row;
+  final String name;
+  final List<String> choices;
+  final int chosen;
+  final ValueChanged<int> onChoose;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final style = TypeRoles.button.style(p.text);
+    return Padding(
+      padding: const EdgeInsets.only(bottom: Spacing.journalRow),
+      child: DecoratedBox(
+        decoration: surface(p),
+        child: Padding(
+          padding: StandIns.settingPadding,
+          child: Row(
+            children: [
+              Expanded(child: Text(name, style: style)),
+              const SizedBox(width: StandIns.gap),
+              // At large text the pill shrinks its words to fit the row.
+              if (choices.isNotEmpty)
+                Flexible(
+                  child: FittedBox(
+                    fit: BoxFit.scaleDown,
+                    child: CupertinoMenuAnchor(
+                      consumeOutsideTaps: true,
+                      menuChildren: [
+                        for (final (i, choice) in choices.indexed)
+                          CupertinoMenuItem(
+                            key: SettingsPage.choiceKey(row, i),
+                            onPressed: () => onChoose(i),
+                            child: Text(choice),
+                          ),
+                      ],
+                      builder: (context, controller, _) => Semantics(
+                        button: true,
+                        label: name,
+                        value: choices[chosen],
+                        excludeSemantics: true,
+                        child: GestureDetector(
+                          key: SettingsPage.valueKey(row),
+                          behavior: HitTestBehavior.opaque,
+                          onTap: () => controller.isOpen ? controller.close() : controller.open(),
+                          child: ConstrainedBox(
+                            constraints: const BoxConstraints(minHeight: StandIns.hitMin),
+                            child: DecoratedBox(
+                              decoration: BoxDecoration(
+                                color: p.field,
+                                borderRadius: BorderRadius.circular(Spacing.radius),
+                                border: Border.all(color: p.fieldBorder),
+                              ),
+                              child: Padding(
+                                padding: StandIns.settingValuePadding,
+                                child: Row(
+                                  mainAxisSize: MainAxisSize.min,
+                                  children: [
+                                    Text(choices[chosen], style: TypeRoles.button.style(p.fieldText)),
+                                    const SizedBox(width: StandIns.searchGap),
+                                    RotatedBox(
+                                      quarterTurns: 1,
+                                      child: Chevron(colour: p.fieldText, size: StandIns.settingChevron),
+                                    ),
+                                  ],
+                                ),
+                              ),
+                            ),
+                          ),
+                        ),
+                      ),
+                    ),
+                  ),
+                ),
+            ],
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// The quick toggle (MP·45): a 41 bordered circle in a 44 tap box, the sun
+/// in the light theme and the moon in the dark (the sky mark's drawing).
+class _Toggle extends StatelessWidget {
+  const _Toggle({required this.dark, required this.onPressed});
+
+  final bool dark;
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Semantics(
+      button: true,
+      toggled: dark,
+      label: Lines.MP_45.text(appLanguage),
+      excludeSemantics: true,
+      child: GestureDetector(
+        key: SettingsPage.toggleKey,
+        behavior: HitTestBehavior.opaque,
+        onTap: onPressed,
+        child: SizedBox.square(
+          dimension: StandIns.hitMin,
+          child: Align(
+            alignment: Alignment.topCenter,
+            child: SizedBox.square(
+              dimension: StandIns.backSize,
+              child: DecoratedBox(
+                decoration: BoxDecoration(
+                  shape: BoxShape.circle,
+                  gradient: LinearGradient(
+                    begin: Alignment.topCenter,
+                    end: Alignment.bottomCenter,
+                    colors: [p.buttonTop, p.buttonBottom],
+                  ),
+                  border: Border.all(color: p.buttonBorder),
+                ),
+                child: Center(child: SkyMark(dark ? Sky.moon : Sky.sun, size: StandIns.toggleMark)),
+              ),
+            ),
+          ),
+        ),
+      ),
+    );
+  }
+}
+
+/// Delete journal: a pill in color.destructive, white words (the Design
+/// System §2), told apart by its place and its word as well (§3).
+class _Destructive extends StatelessWidget {
+  const _Destructive(this.text, {required this.onPressed});
+
+  final String text;
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) {
+    const role = LightColours.destructive;
+    return Semantics(
+      button: true,
+      child: GestureDetector(
+        key: SettingsPage.deleteKey,
+        onTap: onPressed,
+        child: DecoratedBox(
+          decoration: BoxDecoration(
+            gradient: LinearGradient(
+              begin: Alignment.topCenter,
+              end: Alignment.bottomCenter,
+              colors: [role.colour!, role.colourEnd!],
+            ),
+            borderRadius: BorderRadius.circular(Spacing.radius),
+          ),
+          child: Padding(
+            padding: StandIns.buttonPadding,
+            child: Text(text, style: TypeRoles.button.style(role.text!)),
+          ),
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/test/journal/pages/journal_search_test.dart b/app/test/journal/pages/journal_search_test.dart
index a6f4c73..fd81a35 100644
--- a/app/test/journal/pages/journal_search_test.dart
+++ b/app/test/journal/pages/journal_search_test.dart
@@ -14,6 +14,9 @@ import 'package:souldreams/journal/pages/night_page.dart';
 import 'package:souldreams/journal/pages/sky_mark.dart';
 import 'package:souldreams/journal/row_text.dart';
 import 'package:souldreams/journal/search.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings_controller.dart';
+import 'package:souldreams/settings/settings_page.dart';
 import 'package:souldreams/words/lines.g.dart';
 
 import '../../fixtures.dart';
@@ -69,6 +72,33 @@ void main() {
     expect(tester.getRect(find.byType(SkyMark)).top - top, closeTo(StandIns.greetingAbove, 1));
   });
 
+  // D122: with the settings, the gear stands top left, the field under it,
+  // and the sky mark stays 140 down; the gear opens Settings, spoken MP·25.
+  testWidgets('the gear: top left, the field under it', (tester) async {
+    final h = await Harness.make();
+    final settings = SettingsController(h.journal, consents: Consents.answered({}, DateTime.utc(2026)));
+    await h.pump(tester, JournalPage(journal: h.journal, settings: settings));
+    final top = tester.getRect(find.byType(ListView)).top;
+    final gear = tester.getRect(find.byKey(JournalPage.gearKey));
+    final field = tester.getRect(find.byKey(JournalPage.searchFieldKey));
+    expect(gear.top - top, closeTo(StandIns.searchAbove, 1));
+    expect(gear.left, closeTo(Spacing.pageSide, 1));
+    expect(gear.size, const Size.square(StandIns.hitMin));
+    expect(field.top - gear.bottom, closeTo(StandIns.gearBelow, 1));
+    expect(tester.getRect(find.byType(SkyMark)).top - top, closeTo(StandIns.greetingAbove, 1));
+    expect(tester.getSemantics(find.byKey(JournalPage.gearKey)).label, Lines.MP_25.text(Lang.en));
+    await tester.tap(find.byKey(JournalPage.gearKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(SettingsPage), findsOneWidget);
+    expect(tester.widget<SettingsPage>(find.byType(SettingsPage)).settings, same(settings));
+  });
+
+  testWidgets('with no settings, no gear', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    expect(find.byKey(JournalPage.gearKey), findsNothing);
+  });
+
   testWidgets('the field suggests and corrects nothing', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal));
diff --git a/app/test/settings/settings_page_test.dart b/app/test/settings/settings_page_test.dart
new file mode 100644
index 0000000..4fe3d2b
--- /dev/null
+++ b/app/test/settings/settings_page_test.dart
@@ -0,0 +1,292 @@
+// Settings (main-path.md, Settings; D110; D121; D122): the rows, their
+// choices and what each needs; the quick toggle; Withdraw and Give consent;
+// Delete journal. Invented nights only.
+import 'dart:convert';
+
+import 'package:flutter/cupertino.dart';
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/core/app_line.dart';
+import 'package:souldreams/core/night_day.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/pages/journal_home.dart';
+import 'package:souldreams/journal/pages/journal_page.dart';
+import 'package:souldreams/onboarding/disclosure_page.dart';
+import 'package:souldreams/onboarding/onboarding.dart';
+import 'package:souldreams/settings/consent_page.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/journal/pages/sky_mark.dart';
+import 'package:souldreams/journal/sky.dart';
+import 'package:souldreams/settings/settings.dart';
+import 'package:souldreams/settings/settings_controller.dart';
+import 'package:souldreams/settings/settings_page.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+
+String en(Line line, [int part = 0]) => line.parts(Lang.en)[part];
+
+/// A phone-sized view, so the page lays out as on the phone.
+void phone(WidgetTester tester) {
+  tester.view.physicalSize = const Size(390, 844);
+  tester.view.devicePixelRatio = 1;
+  addTearDown(tester.view.reset);
+}
+
+void main() {
+  late MemoryJournalFiles files;
+
+  // The journal's home with [given] consents, at [hour], then Settings
+  // opened from the gear.
+  Future<SettingsController> open(
+    WidgetTester tester, {
+    Map<Consent, bool> given = const {Consent.readings: true},
+    int hour = 12,
+  }) async {
+    phone(tester);
+    JournalStore.newQueueForTests();
+    addTearDown(() => wordAnimation = true);
+    files = MemoryJournalFiles();
+    files.files[JournalStore.consentFile] = encodeConsents(Consents.answered(given, DateTime.utc(2026)));
+    final store = await JournalStore.open(files);
+    await store.save(nightsFromFixtures().first);
+    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, hour), home: JournalHome(files: files)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(JournalPage.gearKey));
+    await tester.pumpAndSettle();
+    expect(find.byType(SettingsPage), findsOneWidget);
+    return tester.widget<SettingsPage>(find.byType(SettingsPage)).settings;
+  }
+
+  Future<void> choose(WidgetTester tester, SettingRow row, int index) async {
+    await tester.ensureVisible(find.byKey(SettingsPage.valueKey(row)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(SettingsPage.valueKey(row)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(SettingsPage.choiceKey(row, index)));
+    await tester.pumpAndSettle();
+  }
+
+  Future<void> hit(WidgetTester tester, Finder f) async {
+    await tester.ensureVisible(f);
+    await tester.pumpAndSettle();
+    await tester.tap(f);
+  }
+
+  String shown(WidgetTester tester, SettingRow row) =>
+      tester.widget<Text>(find.descendant(of: find.byKey(SettingsPage.valueKey(row)), matching: find.byType(Text))).data!;
+
+  Map<String, dynamic> kept(String name) => jsonDecode(utf8.decode(files.files[name]!)) as Map<String, dynamic>;
+
+  testWidgets('the page: its title, six rows, then three actions', (tester) async {
+    await open(tester);
+    expect(find.text(en(Lines.MP_25)), findsOneWidget);
+    final names = [
+      en(Lines.EM_9),
+      'Word Animation',
+      'Night images',
+      'Night/Day mode',
+      'Life Context',
+      'Life Context length',
+    ];
+    final ys = [for (final n in names) tester.getCenter(find.text(n)).dy];
+    expect(ys, [...ys]..sort());
+    expect(shown(tester, SettingRow.language), owedLanguage);
+    // Each pill is heard as its row's name, then its value.
+    final pill = tester.getSemantics(find.byKey(SettingsPage.valueKey(SettingRow.wordAnimation)));
+    expect([pill.label, pill.value], ['Word Animation', 'On']);
+    expect(shown(tester, SettingRow.wordAnimation), 'On');
+    expect(shown(tester, SettingRow.nightImages), 'Off');
+    expect(shown(tester, SettingRow.nightDay), 'Automatic');
+    expect(shown(tester, SettingRow.lifeContext), 'Off');
+    expect(shown(tester, SettingRow.length), '2 weeks');
+    expect(find.text(en(Lines.MP_48)), findsOneWidget);
+    expect(find.text(en(Lines.MP_95)), findsOneWidget);
+    expect(find.text(en(Lines.EM_11)), findsOneWidget);
+    // Nothing of Feedback (D121 item 4) or of what Life Context keeps.
+    expect(find.text(en(Lines.MP_49)), findsNothing);
+    expect(find.text(en(Lines.MP_86)), findsNothing);
+    final delete = tester.getCenter(find.byKey(SettingsPage.deleteKey)).dy;
+    expect(tester.getCenter(find.byKey(SettingsPage.consentKey)).dy, lessThan(delete));
+    expect(tester.getCenter(find.byKey(SettingsPage.disclosureKey)).dy, lessThan(delete));
+  });
+
+  testWidgets('each row offers its line\'s choices; Language only English', (tester) async {
+    await open(tester);
+    await tester.tap(find.byKey(SettingsPage.valueKey(SettingRow.length)));
+    await tester.pumpAndSettle();
+    for (final (i, w) in ['1 week', '2 weeks', '1 month', '3 months'].indexed) {
+      expect(find.descendant(of: find.byKey(SettingsPage.choiceKey(SettingRow.length, i)), matching: find.text(w)),
+          findsOneWidget);
+    }
+    await tester.tapAt(const Offset(5, 400));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(SettingsPage.valueKey(SettingRow.language)));
+    await tester.pumpAndSettle();
+    expect(find.byKey(SettingsPage.choiceKey(SettingRow.language, 0)), findsOneWidget);
+    expect(find.byKey(SettingsPage.choiceKey(SettingRow.language, 1)), findsNothing);
+  });
+
+  testWidgets('Word Animation and Life Context length are kept', (tester) async {
+    await open(tester);
+    await choose(tester, SettingRow.wordAnimation, 1);
+    expect(shown(tester, SettingRow.wordAnimation), 'Off');
+    expect(wordAnimation, isFalse);
+    await choose(tester, SettingRow.length, 3);
+    expect(shown(tester, SettingRow.length), '3 months');
+    expect(kept(JournalStore.settingsFile)['wordAnimation'], isFalse);
+    expect(kept(JournalStore.settingsFile)['length'], 'threeMonths');
+  });
+
+  // The stop's question 5: Manual keeps the theme on screen; the toggle
+  // switches it and sets Manual (Design System §6).
+  testWidgets('Night/Day: Manual keeps the theme; the toggle switches it', (tester) async {
+    final c = await open(tester, hour: 12);
+    Brightness now() => Theme.of(tester.element(find.byType(SettingsPage))).brightness;
+    await choose(tester, SettingRow.nightDay, 1);
+    expect(c.settings.nightDay, NightDayMode.day);
+    expect(shown(tester, SettingRow.nightDay), 'Manual');
+    await hit(tester, find.byKey(SettingsPage.toggleKey));
+    await tester.pumpAndSettle();
+    expect(c.settings.nightDay, NightDayMode.night);
+    expect(now(), Brightness.dark);
+    await choose(tester, SettingRow.nightDay, 0);
+    expect(c.settings.nightDay, NightDayMode.automatic);
+    expect(now(), Brightness.light);
+    // Tapped while Automatic: Manual, the other theme.
+    await hit(tester, find.byKey(SettingsPage.toggleKey));
+    await tester.pumpAndSettle();
+    expect(c.settings.nightDay, NightDayMode.night);
+    expect(shown(tester, SettingRow.nightDay), 'Manual');
+    expect(tester.getSemantics(find.byKey(SettingsPage.toggleKey)).label, en(Lines.MP_45));
+    // The moon in the dark theme, at the toggle's size; tapped, the day.
+    final mark = find.descendant(of: find.byKey(SettingsPage.toggleKey), matching: find.byType(SkyMark));
+    expect(tester.widget<SkyMark>(mark).sky, Sky.moon);
+    expect(tester.getSize(mark), StandIns.toggleMark);
+    await hit(tester, find.byKey(SettingsPage.toggleKey));
+    await tester.pumpAndSettle();
+    expect(c.settings.nightDay, NightDayMode.day);
+    expect(now(), Brightness.light);
+    expect(tester.widget<SkyMark>(mark).sky, Sky.sun);
+  });
+
+  // The stop's question 6: Personal or Random needs consent (c) first; Off
+  // withdraws it.
+  testWidgets('Night images: the consent first; I don\'t consent changes nothing', (tester) async {
+    final c = await open(tester);
+    await choose(tester, SettingRow.nightImages, 1);
+    expect(find.byType(ConsentPage), findsOneWidget);
+    expect(find.text(en(Lines.MP_70)), findsOneWidget);
+    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.images, false)));
+    await tester.pumpAndSettle();
+    expect(find.byType(ConsentPage), findsNothing);
+    expect(c.nightImages, NightImages.off);
+    await choose(tester, SettingRow.nightImages, 1);
+    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.images, true)));
+    await tester.pumpAndSettle();
+    expect(c.nightImages, NightImages.random);
+    expect(shown(tester, SettingRow.nightImages), 'Random');
+    expect(kept(JournalStore.consentFile)['images']['given'], isTrue);
+    // Given now: Personal needs no page.
+    await choose(tester, SettingRow.nightImages, 0);
+    expect(find.byType(ConsentPage), findsNothing);
+    expect(c.nightImages, NightImages.personal);
+    await choose(tester, SettingRow.nightImages, 2);
+    expect(find.byType(CupertinoAlertDialog), findsNothing);
+    expect(c.consents.given(Consent.images), isFalse);
+    expect(shown(tester, SettingRow.nightImages), 'Off');
+  });
+
+  // The stop's question 7: Life Context On needs consent (b); Off asks MP·93.
+  testWidgets('Life Context: On asks its consent; Off asks MP·93', (tester) async {
+    final c = await open(tester);
+    await choose(tester, SettingRow.lifeContext, 0);
+    expect(find.text(en(Lines.MP_69)), findsOneWidget);
+    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.lifeContext, true)));
+    await tester.pumpAndSettle();
+    expect(c.consents.given(Consent.lifeContext), isTrue);
+    expect(shown(tester, SettingRow.lifeContext), 'On');
+    await choose(tester, SettingRow.lifeContext, 1);
+    expect(find.text(en(Lines.MP_93)), findsOneWidget);
+    await tester.tap(find.text(en(Lines.MP_61)));
+    await tester.pumpAndSettle();
+    expect(c.consents.given(Consent.lifeContext), isTrue);
+    await choose(tester, SettingRow.lifeContext, 1);
+    await tester.tap(find.text(en(Lines.MP_94)));
+    await tester.pumpAndSettle();
+    expect(c.consents.given(Consent.lifeContext), isFalse);
+    expect(shown(tester, SettingRow.lifeContext), 'Off');
+  });
+
+  // D121 item 5; the stop's question 10: Withdraw behind MP·96, the journal
+  // stays; Give consent behind MP·68.
+  testWidgets('Withdraw consent behind MP·96; Give consent behind MP·68', (tester) async {
+    final c = await open(tester);
+    await hit(tester, find.byKey(SettingsPage.consentKey));
+    await tester.pumpAndSettle();
+    expect(find.text(en(Lines.MP_96)), findsOneWidget);
+    await tester.tap(find.text(en(Lines.MP_61)));
+    await tester.pumpAndSettle();
+    expect(c.consents.given(Consent.readings), isTrue);
+    await hit(tester, find.byKey(SettingsPage.consentKey));
+    await tester.pumpAndSettle();
+    await tester.tap(find.text(en(Lines.MP_97)));
+    await tester.pumpAndSettle();
+    expect(c.consents.given(Consent.readings), isFalse);
+    expect(find.byType(SettingsPage), findsOneWidget);
+    expect(find.text(en(Lines.MP_95, 1)), findsOneWidget);
+    await hit(tester, find.byKey(SettingsPage.consentKey));
+    await tester.pumpAndSettle();
+    expect(find.text(en(Lines.MP_68)), findsOneWidget);
+    // The back control gives nothing.
+    await tester.tap(find.descendant(of: find.byType(ConsentPage), matching: find.byType(BackControl)));
+    await tester.pumpAndSettle();
+    expect(c.consents.given(Consent.readings), isFalse);
+    await hit(tester, find.byKey(SettingsPage.consentKey));
+    await tester.pumpAndSettle();
+    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.readings, true)));
+    await tester.pumpAndSettle();
+    expect(c.consents.given(Consent.readings), isTrue);
+    expect(find.text(en(Lines.MP_95, 0)), findsOneWidget);
+  });
+
+  testWidgets('Read disclosure & privacy opens every part', (tester) async {
+    await open(tester);
+    await hit(tester, find.byKey(SettingsPage.disclosureKey));
+    await tester.pumpAndSettle();
+    expect(tester.widget<DisclosurePage>(find.byType(DisclosurePage)).shown, DisclosurePage.parts);
+  });
+
+  // D110: one confirmation; then everything goes, back to the welcome.
+  testWidgets('Delete journal: C4-P·4 once, then everything goes', (tester) async {
+    await open(tester);
+    await hit(tester, find.byKey(SettingsPage.deleteKey));
+    await tester.pumpAndSettle();
+    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
+    await tester.tap(find.text(en(Lines.MP_61)));
+    await tester.pumpAndSettle();
+    expect(files.files.keys.where((n) => n.startsWith('night-')), hasLength(1));
+    await hit(tester, find.byKey(SettingsPage.deleteKey));
+    await tester.pumpAndSettle();
+    await tester.tap(find.text(en(Lines.MP_60)));
+    await tester.pumpAndSettle();
+    expect(files.files, isEmpty);
+    expect(find.byType(SettingsPage), findsNothing);
+    expect(find.byType(Onboarding), findsOneWidget);
+    expect(find.text(en(Lines.MP_3)), findsOneWidget);
+  });
+
+  testWidgets('at the largest text, nothing overflows', (tester) async {
+    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await open(tester);
+    expect(tester.takeException(), isNull);
+    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -3000));
+    await tester.pumpAndSettle();
+    expect(tester.takeException(), isNull);
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 28af98f..88c1075 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -2129,8 +2129,8 @@ ROWS = [
      '          const SizedBox(),',
      'test/journal/pages/journal_search_test.dart', 'a context line under its row, the match in Bold'),
     ('A473', 'lib/journal/pages/journal_page.dart',
-     'StandIns.greetingAbove - StandIns.searchAbove - Spacing.sizeFieldSearch',
-     'StandIns.greetingAbove - StandIns.searchAbove',
+     '                  StandIns.searchAbove -\n                  Spacing.sizeFieldSearch -\n',
+     '                  StandIns.searchAbove -\n',
      'test/journal/pages/journal_search_test.dart', 'the field: EM·4 at the top, as wide as a row'),
     ('A474', 'lib/journal/pages/journal_page.dart',
      '              padding: const EdgeInsets.symmetric(horizontal: StandIns.rowSide - Spacing.pageSide),',
@@ -2392,8 +2392,8 @@ ROWS = [
      'setState(() => _answers[consent] = true)',
      'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
     ('A539', 'lib/settings/consent_page.dart',
-     '      chosen: chosen == given,\n',
-     '      chosen: false,\n',
+     'chosen: chosen == given,',
+     'chosen: false,',
      'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
     ('A540', 'lib/settings/consent_page.dart',
      'right: one(false, words.last)',
@@ -2404,8 +2404,8 @@ ROWS = [
      '  Consent.images => Lines.MP_69,',
      'test/settings/consent_page_test.dart', 'each consent has its text'),
     ('A542', 'lib/settings/consent_page.dart',
-     '      true;\n',
-     '      false;\n',
+     ') == true;',
+     ') == false;',
      'test/settings/consent_page_test.dart', 'the page answers true for yes'),
     ('A543', 'lib/onboarding/onboarding.dart',
      '          reads(Lines.MP_66),\n',
@@ -2423,6 +2423,102 @@ ROWS = [
      '      selected: chosen,\n',
      '      selected: false,\n',
      'test/onboarding/onboarding_test.dart', 'Next waits for all three answers, then tells them once'),
+    ('A547', 'lib/settings/settings_page.dart',
+     '_dark ? NightDayMode.day : NightDayMode.night',
+     'NightDayMode.night',
+     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+    ('A548', 'lib/settings/settings_page.dart',
+     '(_dark ? NightDayMode.night : NightDayMode.day)',
+     'NightDayMode.night',
+     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+    ('A549', 'lib/settings/settings_page.dart',
+     'if (choice != NightImages.off && !_c.consents.given(Consent.images)) {',
+     'if (false) {',
+     'test/settings/settings_page_test.dart', "Night images: the consent first; I don't consent changes nothing"),
+    ('A550', 'lib/settings/settings_page.dart',
+     'if (!await ConsentPage.ask(context, Consent.images)) return;',
+     'await ConsentPage.ask(context, Consent.images);',
+     'test/settings/settings_page_test.dart', "Night images: the consent first; I don't consent changes nothing"),
+    ('A551', 'lib/settings/settings_page.dart',
+     ': await _confirm(Lines.MP_93, Lines.MP_94);',
+     ': true;',
+     'test/settings/settings_page_test.dart', 'Life Context: On asks its consent; Off asks MP·93'),
+    ('A552', 'lib/settings/settings_page.dart',
+     'if (yes) await _c.answer(Consent.lifeContext, on);',
+     'await _c.answer(Consent.lifeContext, on);',
+     'test/settings/settings_page_test.dart', 'Life Context: On asks its consent; Off asks MP·93'),
+    ('A553', 'lib/settings/settings_page.dart',
+     '? await _confirm(Lines.MP_96, Lines.MP_97)',
+     '? true',
+     'test/settings/settings_page_test.dart', 'Withdraw consent behind MP·96; Give consent behind MP·68'),
+    ('A554', 'lib/settings/settings_page.dart',
+     'if (yes) await _c.answer(Consent.readings, !given);',
+     'await _c.answer(Consent.readings, !given);',
+     'test/settings/settings_page_test.dart', 'Withdraw consent behind MP·96; Give consent behind MP·68'),
+    ('A555', 'lib/settings/settings_page.dart',
+     'if (!await _confirm(Lines.C4_P_4, Lines.MP_60)) return;',
+     '',
+     'test/settings/settings_page_test.dart', 'Delete journal: C4-P·4 once, then everything goes'),
+    ('A556', 'lib/settings/settings_page.dart',
+     'await widget.journal.deleteAll();',
+     '',
+     'test/settings/settings_page_test.dart', 'Delete journal: C4-P·4 once, then everything goes'),
+    ('A557', 'lib/settings/settings_page.dart',
+     '_c.nightImages.index',
+     '_c.settings.images.index',
+     'test/settings/settings_page_test.dart', 'the page: its title, six rows, then three actions'),
+    ('A558', 'lib/settings/settings_page.dart',
+     '[c.given(Consent.readings) ? 0 : 1]',
+     '[0]',
+     'test/settings/settings_page_test.dart', 'Withdraw consent behind MP·96; Give consent behind MP·68'),
+    ('A559', 'lib/settings/settings_page.dart',
+     'choices: const [owedLanguage],',
+     'choices: const [owedLanguage, owedLanguage],',
+     'test/settings/settings_page_test.dart', "each row offers its line's choices; Language only English"),
+    ('A560', 'lib/settings/settings_page.dart',
+     'wordAnimation: i == 0',
+     'wordAnimation: i != 0',
+     'test/settings/settings_page_test.dart', 'Word Animation and Life Context length are kept'),
+    ('A561', 'lib/settings/settings_page.dart',
+     'LifeContextLength.values[i]',
+     'LifeContextLength.values[0]',
+     'test/settings/settings_page_test.dart', 'Word Animation and Life Context length are kept'),
+    ('A562', 'lib/settings/settings_page.dart',
+     'label: Lines.MP_45.text(appLanguage),',
+     '',
+     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+    ('A563', 'lib/settings/settings_page.dart',
+     'const DisclosurePage()',
+     'const DisclosurePage(shown: [])',
+     'test/settings/settings_page_test.dart', 'Read disclosure & privacy opens every part'),
+    ('A564', 'lib/settings/settings_page.dart',
+     '                Flexible(\n                  child: FittedBox(\n',
+     '                SizedBox(\n                  child: FittedBox(\n',
+     'test/settings/settings_page_test.dart', 'at the largest text, nothing overflows'),
+    ('A565', 'lib/journal/pages/journal_page.dart',
+     'if (widget.settings case final settings?) ...[',
+     'if (widget.settings case final settings? when settings.hashCode < 0) ...[',
+     'test/journal/pages/journal_search_test.dart', 'the gear: top left, the field under it'),
+    ('A566', 'lib/journal/pages/journal_page.dart',
+     '(widget.settings == null ? 0 : StandIns.hitMin + StandIns.gearBelow)',
+     '0',
+     'test/journal/pages/journal_search_test.dart', 'the gear: top left, the field under it'),
+    ('A567', 'lib/journal/pages/journal_page.dart',
+     '      label: Lines.MP_25.text(appLanguage),\n',
+     '',
+     'test/journal/pages/journal_search_test.dart', 'the gear: top left, the field under it'),
+    ('A568', 'lib/journal/pages/journal_page.dart',
+     'onPressed: () => _push(SettingsPage(journal: widget.journal, settings: settings)),',
+     'onPressed: () {},',
+     'test/journal/pages/journal_search_test.dart', 'the gear: top left, the field under it'),
+    ('A569', 'lib/journal/pages/sky_mark.dart',
+     'SizedBox.fromSize(size: size,',
+     'SizedBox.fromSize(size: StandIns.skyMark,',
+     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+    ('A570', 'lib/settings/settings_page.dart',
+     '                        value: choices[chosen],\n',
+     '',
+     'test/settings/settings_page_test.dart', 'the page: its title, six rows, then three actions'),
 ]
 
 
~~~~

### Task 6 · Docs: Status.md and the Dev-only test

Status.md:
- "Last updated", the current branch (`redesign-b`'s merge recorded), the road ahead.
- The onboarding entry; the three consents and Settings.
- The counts: 649 tests and 583 rows.
- "Before Cohort 1" item 4, as D122 rules it.
- Banked items 152 to 154.
- "Rulings during redesign-c".

`dev_only_test.dart`: `main.dart` and `main_founder.dart` reach nothing in `lib/settings/`, and SoulDreams Dev reaches
the Settings page and the consent page. The header of `tool/app_mutations.py` is updated.

Then the full run (D95), once, before the final review: `python3 -I -B tool/app_mutations.py` should print
`app mutations: 583 run, 583 caught`.

Expected: 649 app tests; `python3 -I -B tool/app_mutations.py --files test/dev_only_test.dart`, every one caught. Commit:

> Docs: Status.md for redesign-c (D121, D122); 583 mutation rows

**The block:**

~~~~diff
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
index 0b3db8b..a78751e 100644
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -69,6 +69,8 @@ void main() {
       expect(files.where((f) => f.startsWith('lib/journal/')), isEmpty);
       expect(files.where((f) => f.startsWith('lib/recording/')), isEmpty);
       expect(files.where((f) => f.startsWith('lib/onboarding/')), isEmpty);
+      // Settings and the consents (D122): SoulDreams Dev only.
+      expect(files.where((f) => f.startsWith('lib/settings/')), isEmpty);
       expect(files, isNot(contains(pending)));
     });
   }
@@ -78,6 +80,7 @@ void main() {
   test('SoulDreams Dev reaches the journal pages', () {
     final files = reached('lib/main_dev.dart');
     expect(files, contains('lib/journal/search.dart'));
+    expect(files, containsAll(['lib/settings/settings_page.dart', 'lib/settings/consent_page.dart']));
     expect(files, contains('lib/journal/pages/journal_page.dart'));
     expect(files, contains('lib/journal/pages/night_page.dart'));
     expect(files, contains('lib/recording/record_microphone.dart'));
diff --git a/docs/Status.md b/docs/Status.md
index dec35a8..aea1979 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-21, in branch `redesign-b` (C18-P imported, D118 and D119; the filed greeting, New Dream and jump buttons; search, D110, D116, D117; the owner's by-eye review, then the merge, next), by Claude Code.
+Last updated: 2026-11-22, in branch `redesign-c` (Settings, the gear and the three consents, D110, D121, D122; the owner's by-eye review, then the merge, next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,14 +14,14 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`redesign-b`: C18-P's import (D118, D119), then search (D110, D116, D117; plan `docs/plans/redesign-b.md`).
-`redesign-a` is merged (`e81f29c`); its Status was not updated at the merge (this entry records it).
+`redesign-c`: Settings, the gear and the three consents (D110, D121, D122; plan `docs/plans/redesign-c.md`).
+`redesign-b` is merged (`8243128`); its Status was not updated at the merge (this entry records it).
 
 ## Road ahead
 
-- `redesign-b`: the owner's by-eye review (the plan's Task 6), then the merge.
-- Redesign B's rest and C (D110): Settings (with Word Animation's setting, and the gear, D116 item 5) and the
-  consent's controls, with C18-P's three consents (MP·66 to MP·70, D119 item 1); then Life Context, with C159-I's import, and "Made by AI". The curated set of night paintings (about 60, the founder's)
+- `redesign-c`: the owner's by-eye review (the plan's Task 7), then the merge.
+- Then Life Context (its page, MP·86 to MP·92, and what is kept), with C159-I's import, and "Made by AI"; Feedback, with
+  its server change (D121 item 4). The curated set of night paintings (about 60, the founder's)
   replaces the placeholders, fingerprinted as the fonts are (a G0 and G2 change, the owner's).
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1); the pending lines are filed at
   C17-P (and, for the founder app, with his export).
@@ -169,9 +169,9 @@ rulings given during each branch are listed in this file, one line each, under "
   control returns to the consent. "I agree" keeps `consent.json` in the journal's folder (`{"version":1,"over18":true}`,
   written whole and renamed; never the band), then the journal opens: the first time, its empty state adds MP·9 and a
   drawn arrow to the record button, once. The recording and its retries start only then. A consent that cannot be
-  read or kept logs `consentReadFailed` or `consentKeepFailed`; onboarding asks again at the next opening. When the
-  consent goes (`Journal.withdrawConsent`, or `Journal.deleteAll`, which takes it with every file), every page closes
-  and onboarding starts again; no control calls either yet (Settings, P8; the plan's question 3). A part with no line
+  read or kept logs `consentReadFailed` or `consentKeepFailed`; onboarding asks again at the next opening. Since
+  `redesign-c` the consent step holds the three consents (below), and only Delete journal (`Journal.deleteAll`, which
+  takes every file) closes every page and starts onboarding again; a consent withdrawn is an answer kept (D121 item 5). A part with no line
   would show nothing in its place, not its handle (D106 3); since C17-P every part shown has its line. Every step's box is centred between the top and the foot, and scrolls from the top when taller (D106 1), and
   its words appear whole (D106 2). The stand-ins: the box (`Spacing.onboardingBox` inside `color.surface`), the arrow (`StandIns.firstArrow`,
   `arrowGap`); no logo and no drawn signature (none filed).
@@ -255,14 +255,40 @@ rulings given during each branch are listed in this file, one line each, under "
   (D117 Q4), the told dreams in order, never a name, the first place. A result
   opens its night with the match in Inter Bold in its dream (D117 Q6), found again on each read, gone when the page
   goes. The query is never kept or logged (R3).
+- The three consents (C18-P, MP·66 to MP·70; C159-I item 5; D110; D121; D122; `redesign-c`; `app/lib/settings/`,
+  SoulDreams Dev only): onboarding's second page ends with MP·66, then the readings (a, MP·68), Life Context (b, MP·69)
+  and the night images (c, MP·70), each with MP·67's two choices side by side, equally prominent, neither chosen
+  beforehand, the chosen one filled (`color.button.filled`, a stand-in); EM·6 left as before, Next (MP·30) right,
+  inert until all three are answered; any answers open the journal. MP·68 and MP·70 show their owed sentences in
+  braces (Dev only, D122). Kept in `consent.json`, version 2: "18 or over" and each answer with the UTC day of its last
+  change; version 1 still reads as (a) given, (b) and (c) not (`consents.dart`). (a) not given: nothing leaves the
+  phone, so no microphone and no retries; every night kept; given again, they resume. (b) is the Life Context
+  setting (nothing is kept yet, D121 item 2). (c) not given: Night images is Off, every night the gradient (`lookOf`'s
+  `images`); Personal and Random keep D110's look until the personal painting exists (D121 item 3).
+- Settings (main-path.md, Settings; D110; D121; D122; `settings_page.dart`; TO TRY where a stand-in): the gear top
+  left on the journal, above the search field (drawn, 41 in a 44 tap box, spoken MP·25; the field moves under it and
+  the sky mark stays 140 down). The page: the back control, the quick toggle top centre (the sun or the moon, MP·45),
+  which switches the theme and sets Manual; MP·25 in h2; six rows, each a white rounded row with a value pill opening
+  the phone's menu: Language (EM·9, `[owed·language]`, one choice), Word Animation (MP·26), Night images (MP·85),
+  Night/Day mode (MP·44; Manual keeps the theme shown), Life Context (MP·83), Life Context length (MP·84); then MP·48
+  (the full disclosure), MP·95 (Withdraw or Give consent) and Delete journal (EM·11, `color.destructive`). Turning
+  on what a consent covers shows that consent first (`ConsentPage`); Withdraw asks MP·96 (MP·97), Life Context Off
+  MP·93 (MP·94), Night images Off nothing; Delete journal asks C4-P·4 once, then everything goes and onboarding starts
+  again. The setting lines are read by form ("Name (A / B)", `setting_line.dart`). Kept in `settings.json` (version
+  1; Word Animation, Night/Day mode, the painting kept for while (c) is given, Life Context length), followed by the
+  journal's home (`SettingsController`): Word Animation into `AppLine` and the theme's fade (off, instant, as with
+  Reduce Motion), Night/Day mode through `NightDayChoice` above the app. A change that cannot be kept logs
+  `settingsKeepFailed` or `consentKeepFailed` and holds until the app closes; a read that fails, `settingsReadFailed`,
+  and the defaults stand. No feedback (D121 item 4), no region, no Help (R9).
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 613 tests, and 514 mutation checks (A1 to A496; A24ah,
+- The app's analyzer baseline: `No issues found!`. The app has 649 tests, and 583 mutation checks (A1 to A570; A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
-  A313, A363 and A375 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
+  A277, A278, A281, A300, A313, A363, A375 and A507 dropped, each with its reason in the file; with the rows A24a to
+  A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 514 run, 514 caught`); `check_all.sh` does not call it (D55). During a task only the
+  (expected: `app mutations: 583 run, 583 caught`); `check_all.sh` does not call it (D55). During a task only the
   rows that target the files changed are run, with `--rows A1,A7` or `--files lib/a.dart` (D95).
 
 ## The server
@@ -870,6 +896,18 @@ Banked in redesign-b (D91; none changes what the dreamer sees beyond D116 to D11
      (item 147). `recording_test.dart`, "a stream not open in time: the stop ends, holding nothing", failed once in
      a full run under load and passed on every rerun, alone and with the whole suite: a timing flake, not looked into.
 
+Banked in redesign-c (D91; none changes what the dreamer sees beyond D110, D121 and D122):
+
+152. For Product, through the head (D122): the ten questions in `.scratch/for-build-chat/redesign-c-product-questions.md`,
+     each built as leaned: (a) refused pauses voice too; "recording paused" shows no line; the consent page's layout
+     and Next; the language's name (`[owed·language]`); Manual's "Day" and "Night"; Night images and Life Context
+     after their consent was refused; what Personal and Random show; the consent record; "Give consent" behind
+     MP·68. Also: `main-path.md`, the handover and X2 still describe one consent (C159-I item 5 governs, C18-P).
+153. `JournalPage.didUpdateWidget` moves the list's listener to a new recording's retries when consent (a) is given
+     again; no row proves it (a retry finishing after the consent is given again is a constructed sequence, D17).
+154. The consent record keeps the UTC day, not the instant (decided under D91); Interpretation may want the
+     consent text's version as well (item 152).
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
@@ -878,12 +916,12 @@ Banked in redesign-b (D91; none changes what the dreamer sees beyond D116 to D11
 3. No tester or founder build while any disclosure part shown in onboarding or on the full disclosure page lacks a
    line: none since C17-P (D106 3). `Onboarding.missing` lists them (every part shown, MP·57 included), and a test in
    `dev_only_test.dart` fails if either entry point reaches `lib/onboarding/` while it is not empty.
-4. No shown line may contain an unfilled braced sentence (D119 item 2: a place "to rewrite" is built as written, and
-   a sentence still owed in it stays whole in braces, as MP·68 and MP·70 do; neither is shown by any screen yet).
-   `test/words/shown_lines_test.dart` fails if any file in `lib/` outside `lib/words/` names a place whose line, in
-   either language, holds a `{` or `}` that is not one of the four slots (`{n}`, `{pointed image}`, `{tradition}`,
-   `{read image}`). The branch that first shows MP·68 or MP·70 (the consents' controls) meets this test: it passes
-   only once Product has filed the sentence.
+4. No tester or founder build may show an unfilled braced sentence (D119 item 2: a place "to rewrite" is built as
+   written, and a sentence still owed in it stays whole in braces, as MP·68 and MP·70 do). SoulDreams Dev shows both
+   in the three consents, as filed (D122, Q1 (B)). `test/words/shown_lines_test.dart` fails if any file that
+   `main.dart` or `main_founder.dart` reaches (following imports, as `dev_only_test.dart` does) names a place whose
+   line, in either language, holds a `{` or `}` that is not one of the four slots (`{n}`, `{pointed image}`,
+   `{tradition}`, `{read image}`). Onboarding reaches neither app until a later ruling (D103 item 1).
 
 Task 14's questions for Product (D68), from the founder's screenshots; none built, each more than a number
 (questions 2, 7 and 8 were answered by D70 and built in `recording`, TO TRY; questions 1, 3, 4, 5, 7, 9 to 13 by head's
@@ -1236,6 +1274,21 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   derives its night from `two-dreams-en` with a few words changed, since `fixtures/invented-nights.json` could not
   be written to in this session.
 
+## Rulings during redesign-c
+
+- `redesign-b` merged by the owner (`8243128`).
+- D121 (owner, the brainstorm): (1) Language shown, English only selectable (D57); (2) the Life Context rows shown and
+  remembered now, taking effect when Life Context is built; "What you've told Soul Dreams" arrives with Life Context;
+  (3) Night images: Off shows the gradient for every night; Personal and Random both show the curated set until the
+  personal painting exists; (4) Feedback is a later branch (a server change); (5) withdrawn consent: nothing leaves
+  the phone, recording paused, nights kept; which consent gates what mapped from the documents, and asked where they
+  leave it open.
+- D122 (owner, "all fine", on the stop `.scratch/for-build-chat/redesign-c-stop.md`): every lean. Q1 (B): the
+  shown-lines test covers only what the tester and founder apps reach; SoulDreams Dev shows MP·68 and MP·70 as filed,
+  braces included; "Before Cohort 1" item 4 still blocks any tester or founder build. Q2 to Q11 as leaned, sent to
+  Product (banked item 152). Q12 to Q14: consent version 2 and `settings.json` under docs/workflow.md (c), version 1
+  read as (a) given and (b) and (c) not; the setting lines split in Dart; the look as stand-ins.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 88c1075..7af5559 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,12 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A479, A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A570, A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
+# takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
+# answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 497 run, 497 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 583 run, 583 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
~~~~

### Task 7 · [OWNER] The by-eye review, SoulDreams Dev, invented nights only

By eye only, in SoulDreams Dev built from this branch, with invented nights typed from
`fixtures/invented-nights.json` (save at least `two-dreams-en` and `one-dream-sv`, each as its own night).

**Before you start:** delete the journal first, from Settings or by deleting the app, so onboarding runs. An install
that already has the old consent file is checked in item 1.

Check each step in the light theme and, where it says so, in the dark one. If any result differs, stop and bring it
to the Build chat. Nothing is fixed on the phone.

**The storage rehearsal** (docs/workflow.md (c), step 2):

1. **The update.** Install this build over an earlier SoulDreams Dev that has the invented nights and was agreed to.
   - The journal opens with no onboarding, and every night is there.
   - In Settings: Night images reads Off, Life Context reads Off, the readings consent reads "Withdraw consent", and
     Word Animation reads On.

**Onboarding's three consents:**

2. **The second disclosure page.** After the parts and "Read everything":
   - MP·66, then the three consents, each its text with "I consent" and "I don't consent" side by side, the same size,
     neither filled.
   - The readings and night images texts show their braces ("{What it keeps, and for how long.}", "{What it keeps.}"),
     as filed.
   - At the foot: "I don't agree" on the left, Next on the right.
3. **Choosing.**
   - A tap fills the chosen one; another tap on its pair moves the fill.
   - Next does nothing until all three are answered.
   - Answer the readings "I don't consent", Life Context "I don't consent", night images "I consent", then Next: the
     journal opens.
4. **A private journal** ((a) not given).
   - New Dream's typing screen has no microphone.
   - The rows show their gradient (no night is read yet).
   - Typing and saving work as before.

**Settings:**

5. **The gear** (light and dark): a small round bordered button top left with a thin gear. The search field sits
   under it, and the sun or moon and the greeting are where they were.
6. **The page.**
   - Back top left, the sun (light) or moon (dark) in a circle top centre, "Settings" large.
   - Six white rounded rows: Language `[owed·language]`, Word Animation, Night images, Night/Day mode, Life Context,
     Life Context length (2 weeks).
   - Below the rows: "Read disclosure & privacy", "Give consent", and "Delete journal" in the terracotta style.
7. **The menus.** Each value pill opens the phone's menu with its choices; Language has one.
8. **Night/Day.**
   - Choose Manual: the theme stays as it is.
   - Tap the toggle: the theme fades to the other one over five seconds, and the mode reads Manual.
   - Choose Automatic: it fades back to the hour's theme.
   - With Word Animation Off, the change is at once.
9. **Night images.**
   - Choose Off: no question, it reads Off.
   - Choose Random: the night images consent shows on its own page. "I don't consent" returns with Off; "I consent"
     returns with Random.
   - Back on its page gives nothing.
10. **Life Context.**
    - On: its consent page first.
    - Off: "Turning Life Context off deletes everything…" with "Cancel" and "Turn off".
    - The length's four choices.
11. **Give and withdraw consent.**
    - "Give consent" shows the readings consent; "I consent" gives it, and the button reads "Withdraw consent". The
      typing screen has its microphone again.
    - "Withdraw consent" shows "Withdrawing consent stops all readings…" with "Cancel" and "Withdraw". Withdraw: the
      page stays, the button reads "Give consent", and the microphone is gone.
12. **Read disclosure & privacy:** the full disclosure page, with no consent asked; back returns to Settings.
13. **Delete journal.**
    - "Are you sure you want to delete this?…" with "Cancel" and "Delete". Cancel keeps everything.
    - Delete: the welcome, light. Onboarding again, and Settings back to its defaults afterwards.
14. **Large text** (the phone's largest): the rows, the pills and the buttons fit, shrinking their words, with no
    overlap.

**The founder's verdict, TO TRY** (P13):

15. The gear's look and place (the screenshot has it nearer the corner), the rows' padding, the pills' look, the
    toggle's drawing, and the chosen consent's fill (`color.button.filled`).

## Part 4 · Questions (numbered; a blank is not a yes)

None open for this plan. D122 answered the stop. Carried upward by the Build chat: Product's ten questions
(`.scratch/for-build-chat/redesign-c-product-questions.md`, banked item 152), each built as leaned until answered.

## Part 5 · How this plan was proven

1. **The build.** Built task by task in a copy of the tracked tree, `./.scratch/rc/build`, from `git archive` of
   `8243128`, each task's state kept as a snapshot (`./.scratch/rc/snaps/s<task>`).
   - Each block in Part 3 is `git diff --no-index` between two snapshots, its `a/s<n>/` and `b/s<n>/` prefixes
     rewritten.
   - Left out of every snapshot: harness files (`.claude/`), `.fvm`, `.dart_tool`, the app's `build/`, the generated
     iOS files and Python's `__pycache__`.
2. **The counts measured on each snapshot:** app tests 613 (the baseline), 614, 629, 631, 637, 649, 649, with
   `No issues found!` at each.
3. **Test first.**
   - Each task's new and changed test files, put on the snapshot before it, failed: every file in Tasks 1 to 5,
     loading or asserting.
   - Task 6's `dev_only_test.dart` passed on Task 5's tree: it pins what Tasks 2 to 5 built, and its rows bite.
4. **Mutations on the build** (D95, every row of the files changed):
   - Task 1: its selection, re-run on its own snapshot, `66 run, 66 caught`. Three Task 1 rows (A275, A276, A279) were found still aimed at the
     store's old code during Task 2's run, and were made to follow their code into `consents.dart`, in Task 1's
     block. A300 survived once the withdrawal became the deletion, and was dropped (Part 3, Task 1).
   - Task 2: 193 rows run. After A34 and A297 followed (A297's test gained a check, since a second `_enter` no
     longer starts a second retry and is seen instead in the counts logged twice), all caught.
   - Task 3: `5 run, 5 caught`.
   - Task 4: `65 run, 65 caught`.
   - Task 5: 84 rows, all caught after A473 followed and A564 was aimed at the `Flexible` (`BoxFit.none` was
     invisible to the overflow test).
   - Task 6: `5 run, 5 caught`.
5. **The guards** on each snapshot: `guards (walk): all passed`.
   - During the build, G4 refused five test names of twelve words or more, each shortened.
   - G3 refused one spoken label built by joining two register words with a literal ", ". The pill now carries the
     row's name as its label and the choice as its value (row A570).
6. **Replayed on a fresh copy**, `./.scratch/rc/replay`, from `git archive` of `8243128`.
   - Every block applied with `git apply` in order, with `GIT_CEILING_DIRECTORIES` set so `git apply` is not
     silently skipped inside the repository.
   - After each block the tree was compared with its snapshot: no difference.
   - On the replayed tree: `No issues found!` and `+649: All tests passed!`, and its 93 new and followed rows
     (A497 to A570 but A507, and the 20 following their code) were all caught. Two of them, A539 and A542, first
     failed setup there: Task 5 had reformatted `consent_page.dart`, so they now follow it in Task 5's block. The
     blocks were made again and replayed on a second fresh copy, `./.scratch/rc/replay2`, identical at every step;
     both rows were then caught.
   - Guards: `guards (walk): all passed` on that copy and on every snapshot. On the first copy the walk also saw the
     toolchain's own files (`.fvm`, `.dart_tool`, `build/`), which the snapshots leave out.
7. **Not run in the sandbox:** the full app mutation run (D95, Task 6), and `tool/check_all.sh` whole (the owner's).
8. **Not provable in the sandbox, so the owner's** (Task 7): the look on the phone in both themes, the fades, the
   phone's menus and dialogs, large text on a real phone, and the update over an existing install.
9. The scratch copies (`./.scratch/rc/`) are deleted after this plan is committed.

*No matter where you are on your journey, the steps you take are equally important.*
