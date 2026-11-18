# Plan: onboarding, in SoulDreams Dev (onboarding)

Branch `onboarding`, from `main` at `71e0dac`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and 6),
under D91 and D95, for the owner's ruling D103. Written by Claude Code (Opus) on 2026-11-19. The owner's checks are
by eye only, with no DevTools (D99). Nothing is implemented by this plan's commit.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

The first time SoulDreams Dev opens, and every time until the dreamer agrees, it shows onboarding instead of the
journal, always in the light theme. Five steps, in the founder's order (main-path.md, Onboarding): the welcome
running into the wordmark; the founder's note, signed; the age question, a dropdown of seven bands; the disclosure's
first layer on two pages, ending in one consent; then the journal. A person under 18 sees one card with one sentence
and "I understand", which changes nothing; the card stays until the app is closed, nothing is kept, and the question
is asked again at the next opening. "I don't agree" goes back to the disclosure's first page and asks nothing.
"Read everything" opens the disclosure and privacy page, every part in order, and its back control returns to the
consent.

"I agree" keeps one small file in the journal's folder on the phone, saying only that the dreamer agreed and is 18 or
over; the age band itself is never kept and never sent. The journal then opens; the first time, its empty state also
shows "Click here to record your first dream" with an arrow to the record button, once. Nothing leaves the phone
before the consent: a recording waiting from before is not retried until then.

When the consent goes, withdrawn or deleted with the journal, the app closes every page and starts onboarding again
(D103 item 4). Deleting the journal already empties the whole folder (D54), so the consent goes with it. Neither has a
control on screen yet: Delete journal lives in Settings (P8), and no place for a withdrawal exists in any document
(question 3).

### What this branch builds

1. **The consent, kept** (`journal_store.dart`, `journal.dart`): `consent.json` in the journal's folder, beside the
   nights: `{"version":1,"over18":true}`, written whole to a temporary file and renamed, as a night is. Anything else
   in that file is no consent, and onboarding asks again. Withdrawn by deleting it (the nights stay); deleted with the
   journal by the folder's own delete-all. `Journal.consentGone` tells the app each time it goes.
2. **Always light** (`core/always_light.dart`, `app.dart`): a page can hold the whole app in the light theme, at once,
   so the cover over onboarding (P11) is light too; letting go returns to Night/Day's theme, at once.
3. **Onboarding's steps** (`lib/onboarding/onboarding.dart`, `age.dart`): as above; each step's words in one white box
   (`color.surface`, `Spacing.onboardingBox` inside it), its Next at the foot; the app's own lines word by word
   (`AppLine`), the disclosure's parts whole.
4. **The disclosure and privacy page** (`lib/onboarding/disclosure_page.dart`): W27·1 to W27·17, W27·7 (merged) and
   W27·16 (retired) left out, the back control (MP·14) top left.
5. **SoulDreams Dev's first page** (`journal_home.dart`): the folder opened, the consent read, then onboarding or the
   journal; the recording and its retries made only with the journal; back to the start when the consent goes.
6. **The first empty journal** (`journal_page.dart`): MP·9 and a drawn arrow above the record button, while the
   journal is empty, until a night is there.

### What it does not build

- Onboarding in the founder and tester apps (D103 item 1): `lib/onboarding/` is reached from `main_dev.dart` only,
  and `dev_only_test.dart` proves it.
- Settings, its "Read disclosure & privacy" and its Delete journal (P8); a control that withdraws the consent
  (question 3).
- The founder's logo and his drawn signature and smiley: no file is filed (the handover §11; question 11).
- Swedish shown (D57 Q12): it is built through the same lines.

### The decisions, by number

- D103 (owner, the brainstorm): (1) SoulDreams Dev only; (2) the age band on the phone only, never sent, under 18
  refused with EM·5; (3) the disclosure as filed at C16-P, W27·5's rewrite to Product; (4) the consent kept on the
  phone, and its going, or the journal's deletion, returns to the start.
- D91 and D95 (standing); D67 (a row whose code moved follows it: A2); D57 Q12 (English shown); D31 and R1 (a place
  to rewrite has no line, and shows its handle).
- C127-I I6 and I7, C146-I item 1, C144-I and C14-P item 1 (the two layers), C152-I item 1 (W27·15), main-path.md's
  Onboarding and Every Screen pages.

### What the investigation found

1. **The places** (the register at C16-P, `lines.g.dart`). Written: MP·2, MP·3, MP·4, MP·5, C4-P·2, MP·50, MP·6, EM·5,
   MP·31, W27·1, W27·4, W27·5, W27·8, W27·9, W27·11 to W27·15, MP·57, MP·58, MP·59, MP·8, EM·6, MP·30, C4-P·5, MP·9,
   MP·14. **To rewrite, so no line (R1, D31): W27·2 and W27·17 in the first layer; W27·3, W27·6 and W27·10 on the
   page.** Each shows its handle, `[W27·2]` and so on. The handover §4 says a part to rewrite "stands, and is built as
   it is"; R1 and D31 govern here, and the founder's rewrites are owed before Cohort 1 anyway (question 14). W27·7 is
   merged and W27·16 retired: neither has a constant. No pending line is used or added.
2. **The two layers.** The first: W27·1, W27·2, W27·5, W27·13, W27·14, W27·15, W27·17, then MP·57, MP·58, MP·59, MP·8
   and EM·6 (main-path.md; C14-P item 1, whose "W27·13 to W27·17" includes the retired W27·16). W27's flag says
   "across two pages"; MP·30's says it is also the first page's Next; EM·6's that it stands on the last page and
   leads to the first. Which part stands on which page is not written anywhere (question 2).
3. **What is kept of the age.** main-path.md: "The phone keeps only '18 or over'"; the Principles: "kept only as its
   result"; C146-I item 1: the band never leaves the phone. D103 item 2 says "the age band is kept on the phone
   only". Built: only the result, 18 or over, inside the consent's file, and only once the consent is given; the
   band lives in the screen's memory until Next (question 12, for the owner).
4. **Where the consent lives (R11, workflow (c)).** In the journal's folder: on the phone only, excluded from backup,
   complete file protection, all from the folder (`AppDelegate.swift`, unchanged); deleted with the journal by the
   native delete-all that ignores names (D54), as the first-use flag is. No package and no `UserDefaults`, which the
   phone backs up. The nights' format does not change. Workflow (c) is met as far as it reaches a Dev-only file: the
   store's test counts every night, the audio and the first-use flag before and after the consent is kept and
   withdrawn, byte for byte, and through the sweep at open; the owner's check 1 installs this build over a Dev journal
   holding invented nights and counts them after "I agree". Steps 3 to 5 (alone in a build; the founder's safety
   copy) apply when onboarding reaches the founder app (D103 item 1; D49 O5).
5. **What deleting the journal must also remove.** Every file in the folder: the nights, their waiting audio, any
   temporary file, the first-use flag, and now the consent (`deleteAll`, D54; its test). Then the app returns to the
   start (D103 item 4). Nothing of the consent sits anywhere else: no cache, no setting, no log (the two new codes
   carry no value).
6. **Nothing leaves before the consent.** Today `JournalHome` makes the retries at open, and they listen to the
   connection; a recording left waiting by an older Dev build would be sent to Soniox before onboarding. Built: the
   recording and its retries are made only when the journal opens, after the consent.
7. **Always light.** A theme set only around onboarding's pages would leave the cover (P11) dark at night, since the
   cover reads the app's theme (banked item 72). So the whole app is held light while onboarding shows.
8. **C158-I** (the brief's law notes) is not in `docs/source/`: the copy of the Interpretation record is at C154-I. D103
   carries what the plan needs (adults only; the band never leaves the phone). The owner may import the newer record.

### Decided under D91 (how to build only)

1. The consent's file sits in the journal's folder, `consent.json`, JSON with a version, written whole and renamed.
2. "I agree" twice in a row agrees once. A consent that cannot be kept logs `consentKeepFailed` and the journal opens
   (the dreamer agreed; the next opening asks again). A consent that cannot be read logs `consentReadFailed` and
   onboarding shows.
3. The age dropdown is Flutter's `DropdownButton` in a pill in the field's colours, MP·50 its hint; its labels are
   MP·6 parted at "; " (seven, both languages, a test). Next with no band chosen does nothing.
4. Single buttons are centred at the foot and, at large text, shrink their words to one row, as the pairs do.
5. The arrow is drawn, as the chevrons are: a 2 pt line, 12 by 32 (`StandIns.firstArrow`), centred over the record
   button, 8 above it and 8 below MP·9 (`StandIns.arrowGap`). MP·9 in the button type.
6. Returning to the start pops every page above the first, disposes the retries and shows onboarding's welcome.

### The places this branch uses

MP·2, MP·3, MP·4, MP·5, C4-P·2, MP·50, MP·6, EM·5, MP·31, MP·30, W27·1, W27·2, W27·3, W27·4, W27·5, W27·6, W27·8 to
W27·15, W27·17, MP·57, MP·58, MP·59, MP·8, EM·6, MP·14, C4-P·5, MP·9, MP·11. Handles shown as placeholders (R1):
W27·2, W27·17 (onboarding and the page), W27·3, W27·6, W27·10 (the page). No new line and no pending line.

### The tests (test-first, on the Mac)

Every task adds its tests before its code; each was run on the code before it and failed (Tasks 1 to 4 by compile,
since they name what the task adds, and each assertion then by its mutation row, Part 5). 31 new tests (438 to 469),
28 new mutation rows (A275 to A302); A2, A190, A226 and A227 follow the code (D67). The by-eye review on the phone is the owner's
(Task 7).

## Part 2 · Settings and packages

None. No new package (the dropdown and the drawing are Flutter's own); no change to settings, the guards,
`tool/checks/`, the words, the pending lines, Swift, the server, AWS or Soniox. The one change to what the phone stores
is the consent's file (Part 1, finding 4).

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

**Part 4 waits.** The blocks build the leans. An answer that differs amends the plan before Task 1 (as D101 did).

### Task 0 · Baselines

From the repository root, on `onboarding`, with a clean tree:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 && (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1)
```

Expected:
- nothing from `git status`;
- the plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+438: All tests passed!`.

Anything else: stop (R14).

### Task 1 · The consent, kept on the phone (D103 items 2 and 4)

`JournalStore` keeps, reads and withdraws `consent.json`; a save and the consent share one write-then-rename
(`_whole`). `Journal` passes them on, and its `withdrawConsent` and `deleteAll` tell `consentGone`. Tests:
`journal_store_test.dart` (5, workflow (c) among them), `journal_test.dart` (2).

Expected: 445 app tests. Commit:

> Onboarding: the consent kept in the journal's folder, only that the dreamer agreed and is 18 or over (D103)

**The block:**

~~~~diff
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
index 1ace18c..266d839 100644
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -6,13 +6,16 @@
 // - An edit replaces a dream's text. An emptied dream disappears and the
 //   night's other dreams remain (D58 Q3); a night left with no dream is
 //   deleted, as a deletion deletes it (P10).
+// - The consent (D103) is kept, read and withdrawn here; when it goes,
+//   withdrawn or deleted with the journal, `consentGone` tells the app,
+//   which returns to its start (D103 item 4).
 // - A dream is told in words or waits as a recording (D93 Q2); a dream's
 //   index counts both, and a waiting one is never edited. A Save puts the
 //   recordings its screen left waiting after its words, in order; a Save
 //   with nothing typed but a recording waiting keeps it (D93 Q7).
 import 'dart:math';
 
-import 'package:flutter/foundation.dart' show listEquals;
+import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier, listEquals;
 
 import '../words/lines.g.dart' show Lang;
 import 'journal_store.dart';
@@ -117,4 +120,29 @@ final class Journal {
   Future<bool> firstUseSeen() => _store.firstUseSeen();
 
   Future<void> markFirstUseSeen() => _store.markFirstUseSeen();
+
+  /// Whether the dreamer has agreed to the disclosure, as one 18 or over.
+  Future<bool> consented() => _store.consented();
+
+  /// Keeps the consent given in onboarding (D103).
+  Future<void> keepConsent() => _store.keepConsent();
+
+  /// Moves on each time the consent goes, withdrawn or deleted with the
+  /// journal: the app returns to its start (D103 item 4).
+  ValueListenable<int> get consentGone => _consentGone;
+  final _consentGone = ValueNotifier<int>(0);
+
+  /// Withdraws the consent; the nights stay. Then the app returns to its
+  /// start (D103 item 4).
+  Future<void> withdrawConsent() async {
+    await _store.withdrawConsent();
+    _consentGone.value++;
+  }
+
+  /// Deletes the whole journal, the consent and the first-use flag with it
+  /// (X11; D54). Then the app returns to its start (D103 item 4).
+  Future<void> deleteAll() async {
+    await _store.deleteAll();
+    _consentGone.value++;
+  }
 }
diff --git a/app/lib/journal/journal_store.dart b/app/lib/journal/journal_store.dart
index 8ff2f0d..03c9add 100644
--- a/app/lib/journal/journal_store.dart
+++ b/app/lib/journal/journal_store.dart
@@ -19,6 +19,11 @@
 // is copied to a file with the later start, which then replaces it. At
 // open, audio no night names is deleted, and so is an older copy left by
 // a cut that did not finish.
+//
+// The dreamer's consent (D103) is kept here too, once given in onboarding:
+// one small file saying only that the dreamer agreed and is 18 or over,
+// never the age band (C146-I item 1). Deleting the journal takes it, and
+// so does a withdrawal, and either returns the app to its start.
 import 'dart:convert';
 import 'dart:typed_data';
 
@@ -50,6 +55,10 @@ final class JournalStore {
   /// (MP·10, then MP·32); removed with the journal (D49 c, O6).
   static const firstUseFlag = 'first-use-seen';
 
+  /// Kept once the dreamer has agreed to the disclosure, as one 18 or over
+  /// (D103); removed with the journal, or by a withdrawal (D103 item 4).
+  static const consentFile = 'consent.json';
+
   // The one queue (D54): each operation starts when the one before it,
   // whether it succeeded or failed, has finished. No operation calls
   // another queued one.
@@ -148,10 +157,13 @@ final class JournalStore {
   /// fails, its temporary file is removed before the failure is passed on.
   Future<void> save(Night night) => _run(() => _save(night));
 
-  Future<void> _save(Night night) async {
-    final name = fileOf(night.id);
+  Future<void> _save(Night night) => _whole(fileOf(night.id), encodeNight(night));
+
+  // Writes [bytes] to a temporary file and renames it to [name], so the
+  // folder holds one whole version or the one before.
+  Future<void> _whole(String name, Uint8List bytes) async {
     try {
-      await _files.write(tempPrefix + name, encodeNight(night));
+      await _files.write(tempPrefix + name, bytes);
       await _files.rename(tempPrefix + name, name);
     } on Object {
       try {
@@ -270,4 +282,28 @@ final class JournalStore {
   Future<bool> firstUseSeen() => _run(() async => (await _files.list()).contains(firstUseFlag));
 
   Future<void> markFirstUseSeen() => _run(() => _files.write(firstUseFlag, Uint8List(0)));
+
+  /// Whether the dreamer has agreed, as one 18 or over: the file holds
+  /// exactly that, or it is no consent and onboarding asks again.
+  Future<bool> consented() => _run(() async {
+    final bytes = await _files.read(consentFile);
+    if (bytes == null) return false;
+    try {
+      final json = jsonDecode(utf8.decode(bytes));
+      return json is Map<String, dynamic> && json.length == 2 && json['version'] == 1 && json['over18'] == true;
+    } on FormatException {
+      return false;
+    }
+  });
+
+  /// Keeps the consent: that the dreamer agreed, and is 18 or over.
+  Future<void> keepConsent() =>
+      _run(() => _whole(consentFile, utf8.encode(jsonEncode(const {'version': 1, 'over18': true}))));
+
+  /// Removes the consent, and any temporary file of its keeping; the
+  /// nights stay (D103 item 4).
+  Future<void> withdrawConsent() => _run(() async {
+    await _files.delete(consentFile);
+    await _files.delete(tempPrefix + consentFile);
+  });
 }
diff --git a/app/test/journal/journal_store_test.dart b/app/test/journal/journal_store_test.dart
index d411e83..870c00f 100644
--- a/app/test/journal/journal_store_test.dart
+++ b/app/test/journal/journal_store_test.dart
@@ -421,6 +421,89 @@ void main() {
     expect(await store.firstUseSeen(), isFalse);
   });
 
+  // D103; docs/workflow.md (c): the consent sits beside the nights, holds
+  // only that the dreamer is 18 or over (C146-I item 1), changes no night,
+  // the first-use flag or any audio, and survives the sweep at open.
+  test('the consent is kept beside the nights, changing none of them', () async {
+    final store = await JournalStore.open(files);
+    final nights = nightsFromFixtures();
+    for (final n in nights) {
+      await store.save(n);
+    }
+    final x = '1' * 32;
+    await store.save(nights.first.withEntries([...nights.first.entries, Waiting(x)]));
+    await store.appendAudio(x, sound(64));
+    await store.markFirstUseSeen();
+    final before = files.everything();
+    expect(await store.consented(), isFalse);
+    await store.keepConsent();
+    expect(await store.consented(), isTrue);
+    final reopened = await JournalStore.open(files);
+    expect(await reopened.consented(), isTrue);
+    final after = files.everything();
+    expect(after.keys.toSet(), {...before.keys, JournalStore.consentFile});
+    before.forEach((name, bytes) => expect(listEquals(after[name], bytes), isTrue, reason: name));
+    expect(jsonDecode(utf8.decode(after[JournalStore.consentFile]!)), {'version': 1, 'over18': true});
+    expect((await reopened.nights()).length, nights.length);
+    expect(lines, isEmpty);
+  });
+
+  test('an unreadable consent file is no consent; agreeing replaces it', () async {
+    final store = await JournalStore.open(files);
+    for (final bad in [
+      '',
+      'x',
+      '[]',
+      '{}',
+      '{"version":1}',
+      '{"over18":true}',
+      '{"version":1,"over18":false}',
+      '{"version":2,"over18":true}',
+      '{"version":1,"over18":true,"x":1}',
+    ]) {
+      await files.write(JournalStore.consentFile, utf8.encode(bad));
+      expect(await store.consented(), isFalse, reason: bad);
+    }
+    await files.write(JournalStore.consentFile, Uint8List.fromList([0xff, 0xfe]));
+    expect(await store.consented(), isFalse);
+    await store.keepConsent();
+    expect(await store.consented(), isTrue);
+  });
+
+  test('a consent cut short leaves no consent and no temporary file', () async {
+    final store = await JournalStore.open(BrokenRename(files.dir));
+    await expectLater(store.keepConsent(), throwsA(isA<FileSystemException>()));
+    expect(files.everything(), isEmpty);
+    expect(await store.consented(), isFalse);
+  });
+
+  // D103 item 4: withdrawing removes the consent alone; deleting the journal
+  // takes it with everything else.
+  test('withdrawing the consent removes it alone', () async {
+    final store = await JournalStore.open(files);
+    for (final n in nightsFromFixtures()) {
+      await store.save(n);
+    }
+    await store.markFirstUseSeen();
+    final before = files.everything();
+    await store.keepConsent();
+    await files.write('${JournalStore.tempPrefix}${JournalStore.consentFile}', utf8.encode('x'));
+    await store.withdrawConsent();
+    expect(await store.consented(), isFalse);
+    final after = files.everything();
+    expect(after.keys.toSet(), before.keys.toSet());
+    before.forEach((name, bytes) => expect(listEquals(after[name], bytes), isTrue, reason: name));
+  });
+
+  test('deleting the journal takes the consent', () async {
+    final store = await JournalStore.open(files);
+    await store.save(nightsFromFixtures().first);
+    await store.keepConsent();
+    await store.deleteAll();
+    expect(await store.consented(), isFalse);
+    expect(files.everything(), isEmpty);
+  });
+
   test('a malformed id is refused before any file is named', () {
     expect(() => JournalStore.fileOf('../x'), throwsArgumentError);
     expect(() => IoJournalFiles(dir).read('../x'), throwsArgumentError);
diff --git a/app/test/journal/journal_test.dart b/app/test/journal/journal_test.dart
index 4d412de..96ba51e 100644
--- a/app/test/journal/journal_test.dart
+++ b/app/test/journal/journal_test.dart
@@ -34,6 +34,36 @@ void main() {
 
   tearDown(() => dir.deleteSync(recursive: true));
 
+  // D103 item 4: the consent kept, withdrawn or deleted with the journal;
+  // each going is told once, so the app returns to its start.
+  test('withdrawing the consent keeps every night, and is told', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    var told = 0;
+    journal.consentGone.addListener(() => told++);
+    expect(await journal.consented(), isFalse);
+    await journal.keepConsent();
+    expect(await journal.consented(), isTrue);
+    expect(told, 0);
+    await journal.withdrawConsent();
+    expect(await journal.consented(), isFalse);
+    expect(told, 1);
+    expect((await journal.newestFirst()).single.dreams, [a[0]]);
+  });
+
+  test('deleting the journal takes the consent and every night, told', () async {
+    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
+    await journal.keepConsent();
+    await journal.markFirstUseSeen();
+    var told = 0;
+    journal.consentGone.addListener(() => told++);
+    await journal.deleteAll();
+    expect(told, 1);
+    expect(await journal.consented(), isFalse);
+    expect(await journal.firstUseSeen(), isFalse);
+    expect(await journal.newestFirst(), isEmpty);
+    expect(files.everything(), isEmpty);
+  });
+
   // D93 Q2: a dream's index counts waiting recordings too, and a waiting
   // one is never edited; a night left with only one stays.
   test('an edit counts waiting dreams, and never replaces one', () async {
~~~~

### Task 2 · Onboarding is always light, the cover included

`AlwaysLight` lets a page hold the whole app in the light theme, at once, and let it go. Test: `app_test.dart` (1).

Expected: 446 app tests. Commit:

> Onboarding: a page may hold the app in the light theme, the cover included (main-path.md, Every Screen)

**The block:**

~~~~diff
diff --git a/app/lib/app.dart b/app/lib/app.dart
index c0d5191..2c54462 100644
--- a/app/lib/app.dart
+++ b/app/lib/app.dart
@@ -1,6 +1,7 @@
 import 'package:flutter/material.dart';
 import 'package:flutter_localizations/flutter_localizations.dart';
 
+import 'core/always_light.dart';
 import 'core/language.dart';
 import 'core/night_day.dart';
 import 'core/privacy_cover.dart';
@@ -9,8 +10,9 @@ import 'design/palette.dart';
 /// The app, under the cover (D50 2) on every page, in the theme Night/Day
 /// mode sets (D56; P14), in the language it shows (D57 Q12). Flutter's
 /// own localizations give the month names (P5) and the framework's own
-/// words, which are not ours under R1 (D57 Q9).
-class SoulDreamsApp extends StatelessWidget {
+/// words, which are not ours under R1 (D57 Q9). A page may hold it in the
+/// light theme, at once: onboarding (`AlwaysLight`).
+class SoulDreamsApp extends StatefulWidget {
   const SoulDreamsApp({super.key, this.home, this.clock});
 
   /// The first page; a blank one when null. Only SoulDreams Dev sets it.
@@ -19,25 +21,52 @@ class SoulDreamsApp extends StatelessWidget {
   /// The phone's local time now; tests pass their own.
   final DateTime Function()? clock;
 
+  @override
+  State<SoulDreamsApp> createState() => _SoulDreamsAppState();
+}
+
+class _SoulDreamsAppState extends State<SoulDreamsApp> {
+  final _light = ValueNotifier<bool>(false);
+  bool _wasLight = false;
+
+  @override
+  void dispose() {
+    _light.dispose();
+    super.dispose();
+  }
+
   @override
   Widget build(BuildContext context) {
-    return NightDay(
-      now: clock ?? DateTime.now,
-      builder: (context, mode, fade) => MaterialApp(
-        debugShowCheckedModeBanner: false,
-        theme: themeFor(Brightness.light),
-        darkTheme: themeFor(Brightness.dark),
-        themeMode: mode,
-        themeAnimationDuration: fade,
-        // A gentle ease-in-out over the five seconds (head's message 20,
-        // item 13).
-        themeAnimationCurve: Curves.easeInOut,
-        locale: Locale(appLanguage.name),
-        supportedLocales: const [Locale('en'), Locale('sv')],
-        localizationsDelegates: GlobalMaterialLocalizations.delegates,
-        builder: (context, child) => PrivacyCover(child: child!),
-        home: home ?? const Scaffold(),
+    return AlwaysLight(
+      light: _light,
+      child: NightDay(
+        now: widget.clock ?? DateTime.now,
+        builder: (context, mode, fade) => ValueListenableBuilder<bool>(
+          valueListenable: _light,
+          builder: (context, light, _) {
+            // Held light, or let go: at once, never a fade.
+            final held = light != _wasLight;
+            _wasLight = light;
+            return _app(light ? ThemeMode.light : mode, held ? Duration.zero : fade);
+          },
+        ),
       ),
     );
   }
+
+  Widget _app(ThemeMode mode, Duration fade) => MaterialApp(
+    debugShowCheckedModeBanner: false,
+    theme: themeFor(Brightness.light),
+    darkTheme: themeFor(Brightness.dark),
+    themeMode: mode,
+    themeAnimationDuration: fade,
+    // A gentle ease-in-out over the five seconds (head's message 20,
+    // item 13).
+    themeAnimationCurve: Curves.easeInOut,
+    locale: Locale(appLanguage.name),
+    supportedLocales: const [Locale('en'), Locale('sv')],
+    localizationsDelegates: GlobalMaterialLocalizations.delegates,
+    builder: (context, child) => PrivacyCover(child: child!),
+    home: widget.home ?? const Scaffold(),
+  );
 }
diff --git a/app/lib/core/always_light.dart b/app/lib/core/always_light.dart
new file mode 100644
index 0000000..c04c9d4
--- /dev/null
+++ b/app/lib/core/always_light.dart
@@ -0,0 +1,19 @@
+// Onboarding is always in the light theme, whatever the time
+// (main-path.md, Every Screen and Onboarding; design-system.md §6). A page
+// holds the whole app light, not only itself, so the cover over it (P11)
+// is light too; the change is at once, never a fade.
+import 'package:flutter/widgets.dart';
+
+class AlwaysLight extends InheritedWidget {
+  const AlwaysLight({super.key, required this.light, required super.child});
+
+  /// True while a page holds the app light.
+  final ValueNotifier<bool> light;
+
+  /// Holds the app light, or lets it go, from a page under it.
+  static void hold(BuildContext context, bool on) =>
+      context.getInheritedWidgetOfExactType<AlwaysLight>()?.light.value = on;
+
+  @override
+  bool updateShouldNotify(AlwaysLight old) => old.light != light;
+}
diff --git a/app/test/app_test.dart b/app/test/app_test.dart
index eaa4e91..55ef015 100644
--- a/app/test/app_test.dart
+++ b/app/test/app_test.dart
@@ -1,7 +1,9 @@
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/app.dart';
+import 'package:souldreams/core/always_light.dart';
 import 'package:souldreams/core/privacy_cover.dart';
+import 'package:souldreams/design/tokens.g.dart';
 
 void main() {
   testWidgets('the app shows a blank screen with no text', (tester) async {
@@ -18,4 +20,31 @@ void main() {
     await tester.pump();
     expect(find.byKey(PrivacyCover.coverKey), findsOneWidget);
   });
+
+  // Onboarding is always in the light theme (main-path.md, Every Screen;
+  // design-system.md §6), and so is the cover over it (P11): a page may hold
+  // the whole app light, at once, whatever the time, and let it go.
+  testWidgets('a page may hold the app light, cover included', (tester) async {
+    late BuildContext page;
+    await tester.pumpWidget(SoulDreamsApp(
+      clock: () => DateTime(2026, 6, 10, 23),
+      home: Builder(builder: (context) {
+        page = context;
+        return const Scaffold();
+      }),
+    ));
+    expect(Theme.of(page).brightness, Brightness.dark);
+    AlwaysLight.hold(page, true);
+    await tester.pump();
+    await tester.pump();
+    expect(Theme.of(page).brightness, Brightness.light);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
+    await tester.pump();
+    expect(tester.widget<ColoredBox>(find.byKey(PrivacyCover.coverKey)).color, LightColours.page.colour);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    AlwaysLight.hold(page, false);
+    await tester.pump();
+    await tester.pump();
+    expect(Theme.of(page).brightness, Brightness.dark);
+  });
 }
~~~~

### Task 3 · Onboarding's steps and the disclosure and privacy page

`lib/onboarding/`: the age bands, the five steps, the two layers and the page. Tests: `test/onboarding/age_test.dart`
(2), `test/onboarding/onboarding_test.dart` (12).

Expected: 460 app tests. Commit:

> Onboarding: the welcome, the note, the age question, the disclosure in two layers with one consent (D103)

**The block:**

~~~~diff
diff --git a/app/lib/onboarding/age.dart b/app/lib/onboarding/age.dart
new file mode 100644
index 0000000..2922f1d
--- /dev/null
+++ b/app/lib/onboarding/age.dart
@@ -0,0 +1,13 @@
+// The age question's bands (main-path.md, Onboarding; C7-P item 4): MP·6's
+// one line, parted where the register parts it, into seven labels in the
+// register's order, the first under 18. The band chosen is never kept or
+// sent: only the consent's one result, 18 or over, is kept, and only with
+// the consent (C146-I item 1; D103 item 2).
+import '../words/lines.g.dart';
+
+/// The seven bands' labels in [lang].
+List<String> ageBands(Lang lang) => Lines.MP_6.text(lang).split('; ');
+
+/// Whether the band at [index] is under 18: the app is for adults (C127-I
+/// I6).
+bool underAge(int index) => index == 0;
diff --git a/app/lib/onboarding/disclosure_page.dart b/app/lib/onboarding/disclosure_page.dart
new file mode 100644
index 0000000..eaa6054
--- /dev/null
+++ b/app/lib/onboarding/disclosure_page.dart
@@ -0,0 +1,74 @@
+// The disclosure and privacy page (MP·48; C14-P item 1): every part of the
+// disclosure, W27·1 to W27·17 (W27·7 is merged into W27·6, W27·16 retired),
+// in order, opened from onboarding's consent by MP·58 and closed by the
+// back control, back to the consent. No consent is asked here. A part to
+// rewrite shows its handle (R1). No title: none is given (the plan's
+// question 4).
+import 'package:flutter/material.dart';
+
+import '../core/language.dart';
+import '../design/palette.dart';
+import '../design/stand_ins.dart';
+import '../design/tokens.g.dart';
+import '../journal/pages/parts.dart';
+import '../words/lines.g.dart';
+
+class DisclosurePage extends StatelessWidget {
+  const DisclosurePage({super.key});
+
+  /// Every part, in the register's order.
+  static const parts = [
+    Lines.W27_1,
+    Lines.W27_2,
+    Lines.W27_3,
+    Lines.W27_4,
+    Lines.W27_5,
+    Lines.W27_6,
+    Lines.W27_8,
+    Lines.W27_9,
+    Lines.W27_10,
+    Lines.W27_11,
+    Lines.W27_12,
+    Lines.W27_13,
+    Lines.W27_14,
+    Lines.W27_15,
+    Lines.W27_17,
+  ];
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    const side = EdgeInsets.symmetric(horizontal: StandIns.pageSide);
+    return Scaffold(
+      body: SafeArea(
+        child: Column(
+          crossAxisAlignment: CrossAxisAlignment.stretch,
+          children: [
+            Padding(
+              padding: side,
+              child: Row(children: [BackControl(onPressed: () => Navigator.of(context).pop())]),
+            ),
+            Expanded(
+              child: BelowTapBox(
+                child: ListView(
+                  padding: const EdgeInsets.fromLTRB(StandIns.pageSide, StandIns.gap, StandIns.pageSide, StandIns.gap),
+                  children: [
+                    for (final line in parts)
+                      Padding(
+                        padding: const EdgeInsets.only(bottom: StandIns.gap),
+                        child: Text(
+                          line.parts(appLanguage).join('\n'),
+                          textAlign: TextAlign.center,
+                          style: TypeRoles.voiceApp.style(p.text),
+                        ),
+                      ),
+                  ],
+                ),
+              ),
+            ),
+          ],
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/lib/onboarding/onboarding.dart b/app/lib/onboarding/onboarding.dart
new file mode 100644
index 0000000..594bce9
--- /dev/null
+++ b/app/lib/onboarding/onboarding.dart
@@ -0,0 +1,195 @@
+// Onboarding (main-path.md, Onboarding; D103), SoulDreams Dev only: the
+// welcome, the founder's note, the age question, then the disclosure's
+// first layer on two pages with one consent (C14-P item 1; the plan's
+// question 2 for which part stands on which page). The page that shows it
+// holds the app light (AlwaysLight). Every word is the register's; a part
+// to rewrite shows its handle (R1). Nothing is kept here: "I agree" is
+// told to the page that shows this, which keeps only that the dreamer
+// agreed and is 18 or over (D103 items 2 and 4). Under 18: EM·5 and
+// "I understand", which changes nothing; the card stays until the app
+// closes, and the question is asked again at the next opening, since
+// nothing was kept (C127-I I6). "I don't agree" goes back to the
+// disclosure's first page and asks nothing (C127-I I7). There is no back
+// control: each step goes forward only (the plan's question 8).
+import 'package:flutter/material.dart';
+
+import '../core/app_line.dart';
+import '../core/language.dart';
+import '../design/palette.dart';
+import '../design/stand_ins.dart';
+import '../design/tokens.g.dart';
+import '../journal/pages/parts.dart';
+import '../words/lines.g.dart';
+import 'age.dart';
+import 'disclosure_page.dart';
+
+/// MP·2's line into the wordmark: the words before its last paragraph
+/// break, then the wordmark after it; with no break, the line alone.
+(String, String?) welcome(String line) {
+  final at = line.lastIndexOf('\n\n');
+  return at < 0 ? (line, null) : (line.substring(0, at), line.substring(at + 2));
+}
+
+enum _Step { welcome, note, age, underAge, disclosure, consent }
+
+class Onboarding extends StatefulWidget {
+  const Onboarding({super.key, required this.onAgreed});
+
+  /// "I agree" (MP·8).
+  final VoidCallback onAgreed;
+
+  static const ageKey = Key('age');
+
+  @override
+  State<Onboarding> createState() => _OnboardingState();
+}
+
+class _OnboardingState extends State<Onboarding> {
+  _Step _step = _Step.welcome;
+  // The band chosen, held only on this screen until Next (D103 item 2).
+  int? _band;
+
+  void _to(_Step step) => setState(() => _step = step);
+
+  void _next() {
+    switch (_step) {
+      case _Step.welcome:
+        _to(_Step.note);
+      case _Step.note:
+        _to(_Step.age);
+      case _Step.age:
+        final band = _band;
+        if (band == null) return;
+        _band = null;
+        _to(underAge(band) ? _Step.underAge : _Step.disclosure);
+      case _Step.disclosure:
+        _to(_Step.consent);
+      case _Step.underAge || _Step.consent:
+        return;
+    }
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Scaffold(
+      body: SafeArea(
+        child: Column(
+          crossAxisAlignment: CrossAxisAlignment.stretch,
+          children: [
+            Expanded(
+              child: SingleChildScrollView(
+                // Each step starts at its top.
+                key: ValueKey(_step),
+                padding: const EdgeInsets.fromLTRB(StandIns.pageSide, StandIns.gap, StandIns.pageSide, StandIns.gap),
+                child: DecoratedBox(
+                  decoration: surface(p),
+                  child: Padding(
+                    padding: Spacing.onboardingBox,
+                    child: Column(
+                      crossAxisAlignment: CrossAxisAlignment.stretch,
+                      children: [
+                        for (final (i, part) in _words(p).indexed) ...[
+                          if (i > 0) const SizedBox(height: StandIns.gap),
+                          part,
+                        ],
+                      ],
+                    ),
+                  ),
+                ),
+              ),
+            ),
+            if (_foot() case final foot?)
+              Padding(
+                padding: const EdgeInsets.fromLTRB(StandIns.pageSide, 0, StandIns.pageSide, StandIns.gap),
+                child: foot,
+              ),
+          ],
+        ),
+      ),
+    );
+  }
+
+  List<Widget> _words(Palette p) {
+    final voice = TypeRoles.voiceApp.style(p.text);
+    Widget says(Line line) => AppLine(line.parts(appLanguage).join('\n'), style: voice);
+    Widget reads(Line line) => Text(line.parts(appLanguage).join('\n'), textAlign: TextAlign.center, style: voice);
+    switch (_step) {
+      case _Step.welcome:
+        final (lead, mark) = welcome(Lines.MP_2.text(appLanguage));
+        return [
+          AppLine(lead, style: voice),
+          if (mark != null) Text(mark, textAlign: TextAlign.center, style: TypeRoles.h1.style(p.text)),
+          says(Lines.MP_3),
+        ];
+      case _Step.note:
+        return [says(Lines.MP_4), says(Lines.MP_5)];
+      case _Step.age:
+        return [says(Lines.C4_P_2), _ageField(p)];
+      case _Step.underAge:
+        return [
+          says(Lines.EM_5),
+          // It changes nothing: the card stays until the app closes (C127-I I6).
+          _one(PlainButton(Lines.MP_31.text(appLanguage), onPressed: () {})),
+        ];
+      case _Step.disclosure:
+        return [for (final line in [Lines.W27_1, Lines.W27_2, Lines.W27_5, Lines.W27_13]) reads(line)];
+      case _Step.consent:
+        return [
+          for (final line in [Lines.W27_14, Lines.W27_15, Lines.W27_17, Lines.MP_57]) reads(line),
+          _one(
+            PlainButton(
+              Lines.MP_58.text(appLanguage),
+              onPressed: () =>
+                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DisclosurePage())),
+            ),
+          ),
+          reads(Lines.MP_59),
+        ];
+    }
+  }
+
+  Widget? _foot() => switch (_step) {
+    _Step.underAge => null,
+    _Step.consent => ButtonRow(
+      left: PlainButton(Lines.EM_6.text(appLanguage), onPressed: () => _to(_Step.disclosure)),
+      right: PlainButton(Lines.MP_8.text(appLanguage), onPressed: widget.onAgreed),
+    ),
+    _ => _one(PlainButton(Lines.MP_30.text(appLanguage), onPressed: _next)),
+  };
+
+  // One button, centred; at large text it shrinks its words to stay on one
+  // row, as the pairs do (ButtonRow).
+  static Widget _one(Widget button) => Center(child: FittedBox(fit: BoxFit.scaleDown, child: button));
+
+  // The dropdown of the seven bands, MP·50 its placeholder (main-path.md,
+  // Onboarding, 3): a pill in the field's colours.
+  Widget _ageField(Palette p) {
+    final style = TypeRoles.button.style(p.fieldText);
+    return DecoratedBox(
+      decoration: BoxDecoration(
+        color: p.field,
+        borderRadius: BorderRadius.circular(Spacing.radius),
+        border: Border.all(color: p.fieldBorder),
+      ),
+      child: Padding(
+        padding: StandIns.fieldPadding,
+        child: DropdownButtonHideUnderline(
+          child: DropdownButton<int>(
+            key: Onboarding.ageKey,
+            isExpanded: true,
+            value: _band,
+            dropdownColor: p.field,
+            style: style,
+            hint: Text(Lines.MP_50.text(appLanguage), style: TypeRoles.button.style(p.placeholder)),
+            items: [
+              for (final (i, band) in ageBands(appLanguage).indexed)
+                DropdownMenuItem(value: i, child: Text(band, style: style)),
+            ],
+            onChanged: (band) => setState(() => _band = band),
+          ),
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/test/onboarding/age_test.dart b/app/test/onboarding/age_test.dart
new file mode 100644
index 0000000..b9afcc6
--- /dev/null
+++ b/app/test/onboarding/age_test.dart
@@ -0,0 +1,23 @@
+// The age question's bands (main-path.md, Onboarding; C7-P item 4): MP·6's
+// seven labels, the first under 18, the only one the app refuses.
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/onboarding/age.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+void main() {
+  test('seven bands in each language, in the register\'s order', () {
+    for (final lang in Lang.values) {
+      final bands = ageBands(lang);
+      expect(bands, hasLength(7), reason: lang.name);
+      expect(bands.join('; '), Lines.MP_6.text(lang));
+      expect(bands.every((b) => b.trim() == b && b.isNotEmpty), isTrue);
+    }
+  });
+
+  test('only the first band, under 18, is refused', () {
+    expect(underAge(0), isTrue);
+    for (var i = 1; i < 7; i++) {
+      expect(underAge(i), isFalse, reason: '$i');
+    }
+  });
+}
diff --git a/app/test/onboarding/onboarding_test.dart b/app/test/onboarding/onboarding_test.dart
new file mode 100644
index 0000000..d13046c
--- /dev/null
+++ b/app/test/onboarding/onboarding_test.dart
@@ -0,0 +1,193 @@
+// Onboarding (main-path.md, Onboarding; D103): the welcome, the note, the
+// age question, the under-18 card, and the disclosure's first layer on two
+// pages with one consent; MP·58 opens every part, and back returns to the
+// consent. Every word is the register's; a part to rewrite shows its handle.
+import 'package:flutter/material.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/app.dart';
+import 'package:souldreams/core/language.dart';
+import 'package:souldreams/journal/pages/parts.dart';
+import 'package:souldreams/onboarding/age.dart';
+import 'package:souldreams/onboarding/disclosure_page.dart';
+import 'package:souldreams/onboarding/onboarding.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+String w(Line line) => line.parts(appLanguage).join('\n');
+
+Finder said(Line line) => find.text(w(line));
+
+void main() {
+  late int agreed;
+
+  Future<void> start(WidgetTester tester) async {
+    agreed = 0;
+    await tester.pumpWidget(SoulDreamsApp(
+      clock: () => DateTime(2026, 6, 10, 12),
+      home: Onboarding(onAgreed: () => agreed++),
+    ));
+    await tester.pumpAndSettle();
+  }
+
+  Future<void> tap(WidgetTester tester, Line line) async {
+    await tester.ensureVisible(said(line).last);
+    await tester.tap(said(line).last);
+    await tester.pumpAndSettle();
+  }
+
+  Future<void> pick(WidgetTester tester, int band) async {
+    await tester.tap(find.byKey(Onboarding.ageKey));
+    await tester.pumpAndSettle();
+    await tester.tap(find.text(ageBands(appLanguage)[band]).last);
+    await tester.pumpAndSettle();
+  }
+
+  Future<void> toDisclosure(WidgetTester tester) async {
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.MP_30);
+    await pick(tester, 1);
+    await tap(tester, Lines.MP_30);
+  }
+
+  testWidgets('the welcome: the line into the wordmark, the second line, Next', (tester) async {
+    await start(tester);
+    final (lead, mark) = welcome(w(Lines.MP_2));
+    expect(find.text(lead), findsOneWidget);
+    expect(mark, isNotNull);
+    final wordmark = tester.widget<Text>(find.text(mark!));
+    expect(wordmark.style!.fontFamily, 'Tangerine');
+    expect(said(Lines.MP_3), findsOneWidget);
+    expect(said(Lines.MP_30), findsOneWidget);
+    expect(said(Lines.MP_4), findsNothing);
+  });
+
+  test('the welcome line parts at its last paragraph break', () {
+    expect(welcome('a\n\nb'), ('a', 'b'));
+    expect(welcome('a b'), ('a b', null));
+  });
+
+  testWidgets('the note, signed, then the age question with its placeholder', (tester) async {
+    await start(tester);
+    await tap(tester, Lines.MP_30);
+    expect(said(Lines.MP_4), findsOneWidget);
+    expect(said(Lines.MP_5), findsOneWidget);
+    await tap(tester, Lines.MP_30);
+    expect(said(Lines.C4_P_2), findsOneWidget);
+    expect(said(Lines.MP_50), findsOneWidget);
+  });
+
+  testWidgets('Next does nothing until a band is chosen', (tester) async {
+    await start(tester);
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.MP_30);
+    expect(said(Lines.C4_P_2), findsOneWidget);
+    expect(said(Lines.W27_1), findsNothing);
+    expect(said(Lines.EM_5), findsNothing);
+  });
+
+  testWidgets('every band is offered; under 18 shows the card, which stays', (tester) async {
+    await start(tester);
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.MP_30);
+    await tester.tap(find.byKey(Onboarding.ageKey));
+    await tester.pumpAndSettle();
+    for (final band in ageBands(appLanguage)) {
+      expect(find.text(band), findsWidgets, reason: band);
+    }
+    await tester.tap(find.text(ageBands(appLanguage).first).last);
+    await tester.pumpAndSettle();
+    await tap(tester, Lines.MP_30);
+    expect(said(Lines.EM_5), findsOneWidget);
+    expect(said(Lines.MP_30), findsNothing);
+    await tap(tester, Lines.MP_31);
+    await tap(tester, Lines.MP_31);
+    expect(said(Lines.EM_5), findsOneWidget);
+    expect(said(Lines.MP_31), findsOneWidget);
+    expect(said(Lines.C4_P_2), findsNothing);
+    expect(agreed, 0);
+  });
+
+  testWidgets('18 or over: the disclosure first page, then the consent', (tester) async {
+    await start(tester);
+    await toDisclosure(tester);
+    for (final line in [Lines.W27_1, Lines.W27_2, Lines.W27_5, Lines.W27_13]) {
+      expect(said(line), findsOneWidget, reason: line.handle);
+    }
+    expect(said(Lines.MP_8), findsNothing);
+    await tap(tester, Lines.MP_30);
+    for (final line in [Lines.W27_14, Lines.W27_15, Lines.W27_17, Lines.MP_57, Lines.MP_58, Lines.MP_59]) {
+      expect(said(line), findsOneWidget, reason: line.handle);
+    }
+    expect(said(Lines.W27_1), findsNothing);
+    expect(find.byType(ButtonRow), findsOneWidget);
+    expect(said(Lines.MP_8), findsOneWidget);
+    expect(said(Lines.EM_6), findsOneWidget);
+    // EM·6 left, MP·8 right (the plan's question 6).
+    expect(tester.getCenter(said(Lines.EM_6)).dx, lessThan(tester.getCenter(said(Lines.MP_8)).dx));
+  });
+
+  testWidgets('the first layer only: no part of the full page alone', (tester) async {
+    await start(tester);
+    await toDisclosure(tester);
+    await tap(tester, Lines.MP_30);
+    for (final line in [Lines.W27_3, Lines.W27_4, Lines.W27_6, Lines.W27_8, Lines.W27_9, Lines.W27_10,
+        Lines.W27_11, Lines.W27_12]) {
+      expect(said(line), findsNothing, reason: line.handle);
+    }
+  });
+
+  testWidgets('a part to rewrite shows its handle (R1)', (tester) async {
+    await start(tester);
+    await toDisclosure(tester);
+    expect(find.text('[W27·2]'), findsOneWidget);
+    await tap(tester, Lines.MP_30);
+    expect(find.text('[W27·17]'), findsOneWidget);
+  });
+
+  testWidgets("I don't agree returns to the first page; nothing agreed", (tester) async {
+    await start(tester);
+    await toDisclosure(tester);
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.EM_6);
+    expect(said(Lines.W27_1), findsOneWidget);
+    expect(said(Lines.MP_8), findsNothing);
+    expect(agreed, 0);
+  });
+
+  testWidgets('I agree is told once', (tester) async {
+    await start(tester);
+    await toDisclosure(tester);
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.MP_8);
+    expect(agreed, 1);
+  });
+
+  testWidgets('Read everything opens every part; back returns to the consent', (tester) async {
+    await start(tester);
+    await toDisclosure(tester);
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.MP_58);
+    expect(find.byType(DisclosurePage), findsOneWidget);
+    for (final line in DisclosurePage.parts) {
+      await tester.scrollUntilVisible(said(line), 200);
+      expect(said(line), findsOneWidget, reason: line.handle);
+    }
+    expect(DisclosurePage.parts.map((l) => l.handle), [
+      for (final n in [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 17]) 'W27·$n',
+    ]);
+    await tester.tap(find.byType(BackControl));
+    await tester.pumpAndSettle();
+    expect(find.byType(DisclosurePage), findsNothing);
+    expect(said(Lines.MP_8), findsOneWidget);
+  });
+
+  testWidgets('at the largest text, every step scrolls and nothing overflows', (tester) async {
+    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await start(tester);
+    await toDisclosure(tester);
+    await tap(tester, Lines.MP_30);
+    await tap(tester, Lines.MP_58);
+    expect(tester.takeException(), isNull);
+  });
+}
~~~~

### Task 4 · SoulDreams Dev opens on onboarding until the consent

`JournalHome` reads the consent; onboarding (held light) until it is given, then the journal, the first time with
MP·9 and its arrow; the recording and its retries only then; back to the start when the consent goes. Two codes,
`consentReadFailed` and `consentKeepFailed`; two stand-ins. Tests: `journal_home_test.dart` (7 new; its existing tests
start with the consent kept), `journal_page_test.dart` (2), `dev_only_test.dart` (the onboarding folder in each
entry point's walk).

Expected: 469 app tests. Commit:

> Onboarding: SoulDreams Dev opens on onboarding until the consent, then the first empty journal (D103)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
index 437c3c2..9162259 100644
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -44,6 +44,12 @@ enum LogEvent {
   /// The typing screen's read or mark of first use failed (D71 Q18).
   firstUseReadFailed,
 
+  /// Onboarding (D103): the consent could not be read, so onboarding asks
+  /// again; or it could not be kept, so the journal opens and the next
+  /// opening asks again.
+  consentReadFailed,
+  consentKeepFailed,
+
   /// Recording by voice (D69, D71). Off in this build; the microphone
   /// refused; no key from our server (its status); Soniox's stream refused
   /// or broken (its code); the microphone failing; a recording started,
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
index 91b8591..b0b3be5 100644
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -44,6 +44,11 @@ abstract final class StandIns {
   /// (head's message 20, item 10).
   static const double menuWidth = 55;
 
+  /// The first empty journal's arrow to the record button (main-path.md,
+  /// Onboarding, 5): its size, and the space above and below it.
+  static const firstArrow = Size(12, 32);
+  static const double arrowGap = 8;
+
   /// The record button.
   static const double recordHeight = 120;
   static const double recordWidth = 120;
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
index 2efc978..baaddbd 100644
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -1,5 +1,11 @@
 // SoulDreams Dev's first page (D49 O1; D56): it opens the journal's
-// folder on the phone, then shows the journal list. Until the folder is
+// folder on the phone, then shows onboarding until the dreamer has agreed
+// (D103), held in the light theme, and then the journal list; the first
+// time, the journal list's first empty state (main-path.md, Onboarding, 5).
+// Nothing leaves the phone before the consent: the recording and its
+// retries start only with the journal. When the consent goes, withdrawn or
+// deleted with the journal, it returns to onboarding's start, closing every
+// page above it (D103 item 4). Until the folder is
 // open the page is blank; if it cannot be opened it stays blank and logs
 // a code, never a night's words (R3). A phone check it is handed (D65)
 // finishes first, so its probe never shows as a row. The recording it is
@@ -11,7 +17,9 @@ import 'dart:async';
 
 import 'package:flutter/material.dart';
 
+import '../../core/always_light.dart';
 import '../../core/safe_log.dart';
+import '../../onboarding/onboarding.dart';
 import '../../recording/recording.dart';
 import '../journal.dart';
 import '../journal_audio.dart';
@@ -36,8 +44,14 @@ class JournalHome extends StatefulWidget {
 }
 
 class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
+  JournalStore? _store;
   Journal? _journal;
   Recording? _recording;
+  // Null until the consent is read; then whether it is given.
+  bool? _agreed;
+  // The journal's first showing, straight from "I agree".
+  bool _first = false;
+  bool _agreeing = false;
 
   @override
   void initState() {
@@ -49,6 +63,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
   @override
   void dispose() {
     WidgetsBinding.instance.removeObserver(this);
+    _journal?.consentGone.removeListener(_restart);
     _recording?.retries?.dispose();
     super.dispose();
   }
@@ -69,23 +84,80 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
     } on Object {
       // The check logs its own result; the list does not depend on it.
     }
-    JournalStore.open(widget.files).then((store) {
-      if (!mounted) return;
-      final audio = JournalAudio(store);
-      setState(() {
-        _journal = Journal(store);
-        _recording = widget.recording?.keeping(audio, waiting: audio);
-      });
-      // D98: the counts at launch and after each retry, for DevTools.
-      unawaited(audio.logCounts());
-      _recording?.retries?.afterRetry = audio.logCounts;
-      _recording?.retries?.kick();
-    }, onError: (Object _) => SafeLog.event(LogEvent.journalOpenFailed));
+    final JournalStore store;
+    try {
+      store = await JournalStore.open(widget.files);
+    } on Object {
+      SafeLog.event(LogEvent.journalOpenFailed);
+      return;
+    }
+    final journal = Journal(store)..consentGone.addListener(_restart);
+    bool agreed;
+    try {
+      agreed = await journal.consented();
+    } on Object {
+      // Asked again: nothing is shown as agreed that is not kept.
+      SafeLog.event(LogEvent.consentReadFailed);
+      agreed = false;
+    }
+    if (!mounted) return;
+    _store = store;
+    _journal = journal;
+    agreed ? _enter() : _onboard();
+  }
+
+  // Onboarding, always in the light theme (main-path.md, Every Screen).
+  void _onboard() {
+    AlwaysLight.hold(context, true);
+    setState(() => _agreed = false);
+  }
+
+  // The journal, once the dreamer has agreed: only now may anything leave
+  // the phone, so the recording and its retries begin here (D103).
+  void _enter({bool first = false}) {
+    AlwaysLight.hold(context, false);
+    final audio = JournalAudio(_store!);
+    setState(() {
+      _agreed = true;
+      _first = first;
+      _recording = widget.recording?.keeping(audio, waiting: audio);
+    });
+    // D98: the counts at launch and after each retry, for DevTools.
+    unawaited(audio.logCounts());
+    _recording?.retries?.afterRetry = audio.logCounts;
+    _recording?.retries?.kick();
+  }
+
+  // "I agree": the consent kept, then the journal. A consent that cannot be
+  // kept logs a code; the journal opens, and the next opening asks again.
+  Future<void> _agree() async {
+    if (_agreeing) return;
+    _agreeing = true;
+    try {
+      await _journal!.keepConsent();
+    } on Object {
+      SafeLog.event(LogEvent.consentKeepFailed);
+    }
+    _agreeing = false;
+    if (mounted) _enter(first: true);
+  }
+
+  // The consent gone (D103 item 4): every page above closes, the retries
+  // stop, and onboarding starts again.
+  void _restart() {
+    if (!mounted) return;
+    _recording?.retries?.dispose();
+    _recording = null;
+    Navigator.of(context).popUntil((route) => route.isFirst);
+    _onboard();
   }
 
   @override
   Widget build(BuildContext context) {
-    final journal = _journal;
-    return journal == null ? const Scaffold() : JournalPage(journal: journal, recording: _recording);
+    return switch (_agreed) {
+      null => const Scaffold(),
+      false => Onboarding(onAgreed: _agree),
+      true => JournalPage(journal: _journal!, recording: _recording, firstTime: _first),
+    };
   }
 }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
index 767c39c..77595b8 100644
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -1,8 +1,11 @@
 // The journal list, the app's home (main-path.md, The Journal, design 1;
 // C131-I items 1, 2; S5): one row per night, newest first, never a time;
 // a month divider over each month with nights; the record button bottom
-// centre; C4-P·5 when there is no night. No Settings entry and no search
-// (P8). Nothing on a row grades it: no badge, count or status.
+// centre; C4-P·5 when there is no night. Straight from onboarding, the
+// first empty journal also shows MP·9 with an arrow to the record button,
+// once (main-path.md, Onboarding, 5); the logo above it waits for the
+// founder's file. No Settings entry and no search (P8). Nothing on a row
+// grades it: no badge, count or status.
 import 'package:flutter/material.dart';
 
 import '../../core/app_line.dart';
@@ -22,10 +25,16 @@ import 'parts.dart';
 import 'typing_page.dart';
 
 class JournalPage extends StatefulWidget {
-  const JournalPage({super.key, required this.journal, this.recording});
+  const JournalPage({super.key, required this.journal, this.recording, this.firstTime = false});
 
   final Journal journal;
 
+  /// Straight from onboarding: while the journal is empty, MP·9 and its
+  /// arrow, until a night is there.
+  final bool firstTime;
+
+  static const arrowKey = Key('first-arrow');
+
   /// How to record by voice in the typing screen, or null (D69).
   final Recording? recording;
 
@@ -35,6 +44,7 @@ class JournalPage extends StatefulWidget {
 
 class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   List<Night>? _nights;
+  late bool _first = widget.firstTime;
 
   @override
   void initState() {
@@ -66,7 +76,12 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
       SafeLog.event(LogEvent.journalListFailed);
       return;
     }
-    if (mounted) setState(() => _nights = nights);
+    if (!mounted) return;
+    setState(() {
+      _nights = nights;
+      // Shown once: a night there ends it, even one deleted later.
+      if (nights.isNotEmpty) _first = false;
+    });
   }
 
   Future<void> _push(Widget page) async {
@@ -134,6 +149,20 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
                     },
                 ],
               ),
+            if (nights != null && nights.isEmpty && _first)
+              Positioned(
+                left: StandIns.pageSide,
+                right: StandIns.pageSide,
+                bottom: StandIns.recordBelow + StandIns.recordHeight + StandIns.arrowGap,
+                child: Column(
+                  mainAxisSize: MainAxisSize.min,
+                  children: [
+                    AppLine(Lines.MP_9.text(appLanguage), style: TypeRoles.button.style(p.text)),
+                    const SizedBox(height: StandIns.arrowGap),
+                    _Arrow(key: JournalPage.arrowKey, colour: p.text),
+                  ],
+                ),
+              ),
             Positioned(
               left: 0,
               right: 0,
@@ -147,6 +176,53 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   }
 }
 
+/// The first empty journal's arrow, down to the record button: a thin line
+/// with a thin head, drawn as the chevrons are. Heard as nothing.
+class _Arrow extends StatelessWidget {
+  const _Arrow({super.key, required this.colour});
+
+  final Color colour;
+
+  @override
+  Widget build(BuildContext context) => ExcludeSemantics(
+    child: SizedBox.fromSize(
+      size: StandIns.firstArrow,
+      child: CustomPaint(painter: _ArrowLine(colour)),
+    ),
+  );
+}
+
+class _ArrowLine extends CustomPainter {
+  _ArrowLine(this.colour);
+
+  final Color colour;
+
+  @override
+  void paint(Canvas canvas, Size size) {
+    const inset = StandIns.chevronStroke / 2;
+    final mid = size.width / 2;
+    final tip = size.height - inset;
+    final path = Path()
+      ..moveTo(mid, inset)
+      ..lineTo(mid, tip)
+      ..moveTo(inset, tip - mid)
+      ..lineTo(mid, tip)
+      ..lineTo(size.width - inset, tip - mid);
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
+  bool shouldRepaint(_ArrowLine old) => old.colour != colour;
+}
+
 // Three empty lines: the summary's least height, as laid out.
 const _threeLines = '\n\n';
 
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
index 3ca16fb..a11ff1f 100644
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -59,11 +59,12 @@ void main() {
   const pending = 'lib/words/pending.g.dart';
 
   for (final entry in ['lib/main.dart', 'lib/main_founder.dart']) {
-    test('$entry reaches no journal or recording code, no pending line', () {
+    test('$entry reaches no journal, onboarding or recording code, no pending line', () {
       final files = reached(entry);
       expect(files, contains('lib/app.dart'));
       expect(files.where((f) => f.startsWith('lib/journal/')), isEmpty);
       expect(files.where((f) => f.startsWith('lib/recording/')), isEmpty);
+      expect(files.where((f) => f.startsWith('lib/onboarding/')), isEmpty);
       expect(files, isNot(contains(pending)));
     });
   }
@@ -74,6 +75,7 @@ void main() {
     expect(files, contains('lib/journal/pages/night_page.dart'));
     expect(files, contains(pending));
     expect(files, contains('lib/recording/record_microphone.dart'));
+    expect(files, containsAll(['lib/onboarding/onboarding.dart', 'lib/onboarding/disclosure_page.dart']));
   });
 
   test('the walk follows relative and package imports', () {
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
index d57c3ff..995a367 100644
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -1,5 +1,6 @@
 // SoulDreams Dev's first page: the journal, once its folder is open.
 import 'dart:async';
+import 'dart:convert';
 import 'dart:io';
 import 'dart:typed_data';
 
@@ -7,12 +8,16 @@ import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/app.dart';
 import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal.dart';
 import 'package:souldreams/journal/journal_audio.dart';
 import 'package:souldreams/journal/journal_store.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/pages/journal_home.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
+import 'package:souldreams/journal/pages/typing_page.dart';
+import 'package:souldreams/onboarding/onboarding.dart';
 import 'package:souldreams/recording/recording.dart';
+import 'package:souldreams/words/lines.g.dart';
 
 import '../../fixtures.dart';
 import '../../recording/fakes.dart';
@@ -32,6 +37,45 @@ final class Unopenable extends MemoryJournalFiles {
   Future<void> open() async => throw StateError('journal-io');
 }
 
+/// A folder whose rename fails: the consent cannot be kept.
+final class NoRename extends MemoryJournalFiles {
+  @override
+  Future<void> rename(String from, String to) async => throw StateError('journal-io');
+}
+
+/// A folder whose read of the consent fails.
+final class NoConsentRead extends MemoryJournalFiles {
+  @override
+  Future<Uint8List?> read(String name) async =>
+      name == JournalStore.consentFile ? throw StateError('journal-io') : super.read(name);
+}
+
+/// [files] holding the consent, as "I agree" keeps it (D103).
+T agreed<T extends MemoryJournalFiles>(T files) {
+  files.files[JournalStore.consentFile] = Uint8List.fromList(utf8.encode('{"version":1,"over18":true}'));
+  return files;
+}
+
+/// A night with a recording waiting, its audio kept, in [files].
+Future<void> waiting(MemoryJournalFiles files) async {
+  final store = await JournalStore.open(files);
+  final x = '1' * 32;
+  await store.save(nightsFromFixtures().first.withEntries([Waiting(x)]));
+  await store.appendAudio(x, Uint8List(32000));
+}
+
+/// A recording whose streams are counted in [links].
+Recording counted(List<MemoryLink> links) => Recording(
+  on: true,
+  microphone: SilentMicrophone(),
+  key: () async => 'k',
+  connect: (_) async {
+    final link = MemoryLink();
+    links.add(link);
+    return link;
+  },
+);
+
 void main() {
   // The queue is renewed inside each test's own zone (journal_store.dart).
   testWidgets('it opens the folder, then shows the journal', (tester) async {
@@ -40,9 +84,12 @@ void main() {
     final sink = SafeLog.sink;
     SafeLog.sink = lines.add;
     addTearDown(() => SafeLog.sink = sink);
-    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: MemoryJournalFiles())));
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
     await tester.pumpAndSettle();
     expect(find.byType(JournalPage), findsOneWidget);
+    // With the consent kept, no onboarding, and no MP·9 (shown once).
+    expect(find.byType(Onboarding), findsNothing);
+    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
     // The diagnostic at launch (D98), numbers only; nothing else.
     expect(lines, ['journalAudio 0 0']);
   });
@@ -56,7 +103,7 @@ void main() {
       key: () async => 'k',
       connect: (_) async => MemoryLink(),
     );
-    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: MemoryJournalFiles(), recording: recording)));
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), recording: recording)));
     await tester.pumpAndSettle();
     final handed = tester.widget<JournalPage>(find.byType(JournalPage)).recording!;
     expect(handed.keep, isA<JournalAudio>());
@@ -71,7 +118,7 @@ void main() {
     final sink = SafeLog.sink;
     SafeLog.sink = lines.add;
     addTearDown(() => SafeLog.sink = sink);
-    final files = MemoryJournalFiles();
+    final files = agreed(MemoryJournalFiles());
     final store = await JournalStore.open(files);
     final x = '1' * 32;
     await store.save(nightsFromFixtures().first.withEntries([Waiting(x)]));
@@ -111,7 +158,7 @@ void main() {
   // list is not loaded until the check has finished.
   testWidgets('the list waits for the phone check, then shows', (tester) async {
     JournalStore.newQueueForTests();
-    final files = Watched();
+    final files = agreed(Watched());
     final check = Completer<bool>();
     await tester.pumpWidget(
       SoulDreamsApp(
@@ -132,7 +179,7 @@ void main() {
     final check = Completer<bool>();
     await tester.pumpWidget(
       SoulDreamsApp(
-        home: JournalHome(files: MemoryJournalFiles(), after: check.future),
+        home: JournalHome(files: agreed(MemoryJournalFiles()), after: check.future),
       ),
     );
     await tester.pumpAndSettle();
@@ -160,4 +207,139 @@ void main() {
     expect(find.byType(Scaffold), findsOneWidget);
     expect(lines, ['journalOpenFailed']);
   });
+
+  // D103: before the consent, onboarding, held light whatever the time
+  // (main-path.md, Every Screen), and nothing leaves the phone: no retry,
+  // no stream, and nothing logged.
+  testWidgets('no consent: onboarding, light at night, nothing retried', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    final files = MemoryJournalFiles();
+    await waiting(files);
+    final links = <MemoryLink>[];
+    await tester.pumpWidget(SoulDreamsApp(
+      clock: () => DateTime(2026, 6, 10, 23),
+      home: JournalHome(files: files, recording: counted(links)),
+    ));
+    await tester.pumpAndSettle();
+    expect(find.byType(Onboarding), findsOneWidget);
+    expect(find.byType(JournalPage), findsNothing);
+    expect(Theme.of(tester.element(find.byType(Onboarding))).brightness, Brightness.light);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pumpAndSettle();
+    expect(links, isEmpty);
+    expect(lines, isEmpty);
+    expect(files.files.keys, isNot(contains(JournalStore.consentFile)));
+  });
+
+  // D103 items 2 and 4: "I agree" keeps the consent, lets the theme go and
+  // opens the first empty journal (main-path.md, Onboarding, 5); only then
+  // may a recording waiting be retried.
+  testWidgets('I agree keeps the consent, then the journal and its retries', (tester) async {
+    JournalStore.newQueueForTests();
+    final files = MemoryJournalFiles();
+    await waiting(files);
+    final links = <MemoryLink>[];
+    await tester.pumpWidget(SoulDreamsApp(
+      clock: () => DateTime(2026, 6, 10, 23),
+      home: JournalHome(files: files, recording: counted(links)),
+    ));
+    await tester.pumpAndSettle();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
+    await tester.pump();
+    await tester.pump();
+    expect(find.byType(JournalPage), findsOneWidget);
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).firstTime, isTrue);
+    expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
+    expect(utf8.decode(files.files[JournalStore.consentFile]!), '{"version":1,"over18":true}');
+    expect(links, hasLength(1));
+    await tester.pumpWidget(const SizedBox());
+    await tester.pump(const Duration(seconds: 11));
+  });
+
+  testWidgets('a consent that cannot be kept: the journal, a code', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    final files = NoRename();
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
+    await tester.pumpAndSettle();
+    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
+    await tester.pumpAndSettle();
+    expect(find.byType(JournalPage), findsOneWidget);
+    expect(lines, ['consentKeepFailed', 'journalAudio 0 0']);
+    expect(files.files, isEmpty);
+  });
+
+  testWidgets('a consent that cannot be read: onboarding, a code', (tester) async {
+    JournalStore.newQueueForTests();
+    final lines = <String>[];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(NoConsentRead()))));
+    await tester.pumpAndSettle();
+    expect(find.byType(Onboarding), findsOneWidget);
+    expect(lines, ['consentReadFailed']);
+  });
+
+  // D103 item 4: the consent gone, withdrawn or deleted with the journal,
+  // returns the app to its start, whatever page is open, held light again.
+  for (final (how, go) in <(String, Future<void> Function(Journal))>[
+    ('withdrawn', (j) => j.withdrawConsent()),
+    ('deleted with the journal', (j) => j.deleteAll()),
+  ]) {
+    testWidgets('the consent $how: back to the start', (tester) async {
+      JournalStore.newQueueForTests();
+      final files = agreed(MemoryJournalFiles());
+      await tester.pumpWidget(SoulDreamsApp(
+        clock: () => DateTime(2026, 6, 10, 23),
+        home: JournalHome(files: files),
+      ));
+      await tester.pumpAndSettle();
+      final journal = tester.widget<JournalPage>(find.byType(JournalPage)).journal;
+      await tester.tap(find.text(Lines.MP_11.text(Lang.en)));
+      await tester.pumpAndSettle();
+      expect(find.byType(TypingPage), findsOneWidget);
+      await go(journal);
+      await tester.pumpAndSettle();
+      expect(find.byType(TypingPage), findsNothing);
+      expect(find.byType(JournalPage), findsNothing);
+      expect(find.byType(Onboarding), findsOneWidget);
+      expect(find.text(Lines.MP_3.text(Lang.en)), findsOneWidget);
+      expect(Theme.of(tester.element(find.byType(Onboarding))).brightness, Brightness.light);
+      expect(files.files.keys, isNot(contains(JournalStore.consentFile)));
+    });
+  }
+
+  // D103 item 4: back at the start, nothing is retried until the consent
+  // is given again.
+  testWidgets('the consent withdrawn: the retry cut, none after', (tester) async {
+    JournalStore.newQueueForTests();
+    final files = agreed(MemoryJournalFiles());
+    await waiting(files);
+    final links = <MemoryLink>[];
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links))));
+    await tester.pump();
+    await tester.pump();
+    expect(links, hasLength(1));
+    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.withdrawConsent();
+    await tester.pump(const Duration(milliseconds: 150));
+    expect(find.byType(Onboarding), findsOneWidget);
+    expect(links.single.closed, isTrue);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
+    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+    await tester.pump();
+    await tester.pump();
+    expect(links, hasLength(1));
+    await tester.pumpWidget(const SizedBox());
+    await tester.pump(const Duration(seconds: 11));
+  });
 }
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
index b44173e..178425a 100644
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -66,6 +66,45 @@ void main() {
     expect(find.byType(TextField), findsNothing);
   });
 
+  // Onboarding's last step (main-path.md, Onboarding, 5): the first empty
+  // journal adds MP·9 with an arrow to the record button, shown once: gone
+  // when a night is there, and never on a later empty journal.
+  testWidgets('the first empty journal: MP·9 above the record button, once', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal, firstTime: true));
+    final pointer = find.bySemanticsLabel(Lines.MP_9.text(Lang.en));
+    expect(pointer, findsOneWidget);
+    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
+    expect(find.byKey(JournalPage.arrowKey), findsOneWidget);
+    final arrow = tester.getRect(find.byKey(JournalPage.arrowKey));
+    final record = tester.getRect(find.byKey(RecordButton.buttonKey));
+    expect(arrow.bottom, lessThanOrEqualTo(record.top));
+    expect(arrow.center.dx, closeTo(record.center.dx, 1));
+    expect(tester.getRect(find.byType(AppLine).last).bottom, lessThanOrEqualTo(arrow.top));
+    // A night comes, then goes, on the same visit: MP·9 does not return.
+    final night = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 7));
+    Future<void> back() async {
+      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
+      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
+      await tester.pumpAndSettle();
+    }
+
+    await back();
+    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
+    await h.journal.delete(night.id);
+    await back();
+    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
+    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
+    expect(find.byKey(JournalPage.arrowKey), findsNothing);
+  });
+
+  testWidgets('a later empty journal has no MP·9', (tester) async {
+    final h = await Harness.make();
+    await h.pump(tester, JournalPage(journal: h.journal));
+    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
+    expect(find.byKey(JournalPage.arrowKey), findsNothing);
+  });
+
   // Head's message 20, item 7: the empty journal's line in the button type,
   // centred.
   testWidgets("the empty journal's line: the button type, centred", (tester) async {
~~~~

### Task 5 · The mutation rows A275 to A302

28 new rows; A2, A190, A226 and A227 follow the code (D67): `_save` now writes through `_whole`, and the journal's
start moved into `_enter`, one indent less. Run, from the repository root (D95):

```
python3 -I -B tool/app_mutations.py --rows A2,A190,A226,A227,A275,A276,A277,A278,A279,A280,A281,A282,A283,A284,A285,A286,A287,A288,A289,A290,A291,A292,A293,A294,A295,A296,A297,A298,A299,A300,A301,A302
```

Expected: `app mutations: 32 run, 32 caught`. Commit:

> Mutation rows A275 to A302 for onboarding; A2, A190, A226 and A227 follow the code (D67)

**The block:**

~~~~diff
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 52fbbad..feab703 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,9 +1,9 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
-# Expected: every row "caught" (A1 to A274, A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
+# Expected: every row "caught" (A1 to A302, A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 303 run, 303 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 331 run, 331 caught", exit 0. Each row breaks one thing in app/, in place, runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
@@ -27,9 +27,9 @@ ROWS = [
      '    final bytes = await _files.read(name);\n',
      'test/journal/journal_store_test.dart', 'deleting a night leaves nothing of it anywhere'),
     ('A2', 'lib/journal/journal_store.dart',
-     '      await _files.write(tempPrefix + name, encodeNight(night));\n'
+     '      await _files.write(tempPrefix + name, bytes);\n'
      '      await _files.rename(tempPrefix + name, name);',
-     '      await _files.write(name, encodeNight(night));',
+     '      await _files.write(name, bytes);',
      'test/journal/journal_store_test.dart', 'a save cut short leaves the last whole version'),
     ('A3', 'lib/journal/journal_store.dart',
      '      if (name.startsWith(tempPrefix)) {',
@@ -1007,7 +1007,7 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'the journal opening retries; leaving cuts it; back resumes'),
     ('A190', 'lib/journal/pages/journal_home.dart',
-     '      _recording?.retries?.kick();\n',
+     '    _recording?.retries?.kick();\n',
      '',
      'test/journal/pages/journal_home_test.dart', 'the journal opening retries; leaving cuts it; back resumes'),
     ('A191', 'lib/journal/pages/typing_page.dart',
@@ -1149,11 +1149,11 @@ ROWS = [
      'waiting += 0;',
      'test/journal/journal_audio_test.dart', 'the counts line: audio files, then waiting recordings'),
     ('A226', 'lib/journal/pages/journal_home.dart',
-     '      unawaited(audio.logCounts());\n',
+     '    unawaited(audio.logCounts());\n',
      '',
      'test/journal/pages/journal_home_test.dart', 'it opens the folder, then shows the journal'),
     ('A227', 'lib/journal/pages/journal_home.dart',
-     '      _recording?.retries?.afterRetry = audio.logCounts;\n',
+     '    _recording?.retries?.afterRetry = audio.logCounts;\n',
      '',
      'test/journal/pages/journal_home_test.dart', 'the journal opening retries; leaving cuts it; back resumes'),
     ('A228', 'lib/recording/retries.dart',
@@ -1350,6 +1350,118 @@ ROWS = [
      'Offset(StandIns.menuWidth, StandIns.backSize + 8)',
      'Offset(StandIns.menuWidth, StandIns.hitMin + 8)',
      'test/journal/pages/night_page_test.dart', 'the menu opens 8 below the look, on its right edge'),
+    ('A275', 'lib/journal/journal_store.dart',
+     " && json['over18'] == true;",
+     ';',
+     'test/journal/journal_store_test.dart', 'an unreadable consent file is no consent; agreeing replaces it'),
+    ('A276', 'lib/journal/journal_store.dart',
+     ' && json.length == 2',
+     '',
+     'test/journal/journal_store_test.dart', 'an unreadable consent file is no consent; agreeing replaces it'),
+    ('A277', 'lib/journal/journal_store.dart',
+     '    await _files.delete(consentFile);\n',
+     '',
+     'test/journal/journal_store_test.dart', 'withdrawing the consent removes it alone'),
+    ('A278', 'lib/journal/journal_store.dart',
+     '    await _files.delete(tempPrefix + consentFile);\n',
+     '',
+     'test/journal/journal_store_test.dart', 'withdrawing the consent removes it alone'),
+    ('A279', 'lib/journal/journal_store.dart',
+     "const {'version': 1, 'over18': true}",
+     "const {'version': 1, 'over18': true, 'band': 1}",
+     'test/journal/journal_store_test.dart', 'the consent is kept beside the nights, changing none of them'),
+    ('A280', 'lib/journal/journal_store.dart',
+     '_run(() => _whole(consentFile, ',
+     '_run(() => _files.write(consentFile, ',
+     'test/journal/journal_store_test.dart', 'a consent cut short leaves no consent and no temporary file'),
+    ('A281', 'lib/journal/journal.dart',
+     '    await _store.withdrawConsent();\n    _consentGone.value++;',
+     '    await _store.withdrawConsent();',
+     'test/journal/journal_test.dart', 'withdrawing the consent keeps every night, and is told'),
+    ('A282', 'lib/journal/journal.dart',
+     '    await _store.deleteAll();\n    _consentGone.value++;',
+     '    await _store.deleteAll();',
+     'test/journal/pages/journal_home_test.dart', 'the consent deleted with the journal: back to the start'),
+    ('A283', 'lib/app.dart',
+     'light ? ThemeMode.light : mode',
+     'mode',
+     'test/app_test.dart', 'a page may hold the app light, cover included'),
+    ('A284', 'lib/onboarding/age.dart',
+     'index == 0;',
+     'index == 1;',
+     'test/onboarding/age_test.dart', 'only the first band, under 18, is refused'),
+    ('A285', 'lib/onboarding/onboarding.dart',
+     'if (band == null) return;',
+     'if (band == null) return _to(_Step.disclosure);',
+     'test/onboarding/onboarding_test.dart', 'Next does nothing until a band is chosen'),
+    ('A286', 'lib/onboarding/onboarding.dart',
+     '_to(underAge(band) ? _Step.underAge : _Step.disclosure);',
+     '_to(_Step.disclosure);',
+     'test/onboarding/onboarding_test.dart', 'every band is offered; under 18 shows the card, which stays'),
+    ('A287', 'lib/onboarding/onboarding.dart',
+     'PlainButton(Lines.MP_31.text(appLanguage), onPressed: () {})',
+     'PlainButton(Lines.MP_31.text(appLanguage), onPressed: () => _to(_Step.age))',
+     'test/onboarding/onboarding_test.dart', 'every band is offered; under 18 shows the card, which stays'),
+    ('A288', 'lib/onboarding/onboarding.dart',
+     'onPressed: () => _to(_Step.disclosure)),',
+     'onPressed: () => _to(_Step.welcome)),',
+     'test/onboarding/onboarding_test.dart', "I don't agree returns to the first page; nothing agreed"),
+    ('A289', 'lib/onboarding/onboarding.dart',
+     '[Lines.W27_1, Lines.W27_2, Lines.W27_5, Lines.W27_13]',
+     '[Lines.W27_1, Lines.W27_5, Lines.W27_13]',
+     'test/onboarding/onboarding_test.dart', '18 or over: the disclosure first page, then the consent'),
+    ('A290', 'lib/onboarding/onboarding.dart',
+     '[Lines.W27_14, Lines.W27_15, Lines.W27_17, Lines.MP_57]',
+     '[Lines.W27_14, Lines.W27_15, Lines.MP_57]',
+     'test/onboarding/onboarding_test.dart', '18 or over: the disclosure first page, then the consent'),
+    ('A291', 'lib/onboarding/onboarding.dart',
+     'right: PlainButton(Lines.MP_8.text(appLanguage), onPressed: widget.onAgreed),',
+     'right: PlainButton(Lines.MP_8.text(appLanguage), onPressed: () {}),',
+     'test/onboarding/onboarding_test.dart', 'I agree is told once'),
+    ('A292', 'lib/onboarding/disclosure_page.dart',
+     '    Lines.W27_6,\n',
+     '',
+     'test/onboarding/onboarding_test.dart', 'Read everything opens every part; back returns to the consent'),
+    ('A293', 'lib/journal/pages/journal_home.dart',
+     'agreed ? _enter() : _onboard();',
+     '_enter();',
+     'test/journal/pages/journal_home_test.dart', 'no consent: onboarding, light at night, nothing retried'),
+    ('A294', 'lib/journal/pages/journal_home.dart',
+     '    AlwaysLight.hold(context, true);\n    setState(() => _agreed = false);',
+     '    setState(() => _agreed = false);',
+     'test/journal/pages/journal_home_test.dart', 'no consent: onboarding, light at night, nothing retried'),
+    ('A295', 'lib/journal/pages/journal_home.dart',
+     '    AlwaysLight.hold(context, false);\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
+    ('A296', 'lib/journal/pages/journal_home.dart',
+     '      await _journal!.keepConsent();\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
+    ('A297', 'lib/journal/pages/journal_home.dart',
+     '    if (_agreeing) return;\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'I agree keeps the consent, then the journal and its retries'),
+    ('A298', 'lib/journal/pages/journal_home.dart',
+     '      SafeLog.event(LogEvent.consentReadFailed);\n      agreed = false;',
+     '      SafeLog.event(LogEvent.consentReadFailed);\n      agreed = true;',
+     'test/journal/pages/journal_home_test.dart', 'a consent that cannot be read: onboarding, a code'),
+    ('A299', 'lib/journal/pages/journal_home.dart',
+     '    Navigator.of(context).popUntil((route) => route.isFirst);\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the consent withdrawn: back to the start'),
+    ('A300', 'lib/journal/pages/journal_home.dart',
+     '    _recording?.retries?.dispose();\n    _recording = null;\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', 'the consent withdrawn: the retry cut, none after'),
+    ('A301', 'lib/journal/pages/journal_page.dart',
+     '      if (nights.isNotEmpty) _first = false;\n',
+     '',
+     'test/journal/pages/journal_page_test.dart', 'the first empty journal: MP·9 above the record button, once'),
+    ('A302', 'lib/journal/pages/journal_page.dart',
+     'nights.isEmpty && _first)',
+     'nights.isEmpty)',
+     'test/journal/pages/journal_page_test.dart', 'a later empty journal has no MP·9'),
 ]
 
 
~~~~

### Task 6 · Status.md

Status.md for the branch, with D103 under "Rulings during onboarding" and banked items 117 to 120. Replace
`<the day of this task>` with the date.

Expected: 469 app tests. Commit:

> Docs: Status.md for onboarding (D103)

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
index 6c5fc43..4c1915e 100644
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-18, in branch `journal-design` (the plan's Tasks 1 to 7, the review fixes and D102; the owner's by-eye review passed; waiting for the merge), by Claude Code.
+Last updated: <the day of this task>, in branch `onboarding` (the plan's Tasks 1 to 6; the owner's by-eye review, Task 7, next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,15 +14,16 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`journal-design`: the journal design pass in SoulDreams Dev (head's message 20, Product message 19, items 1, 3 to 5, 7
-and 9 to 13; the spacings TO TRY), and D100 (a connection lost during a recording shows MP·54 at once). Plan:
-`docs/plans/journal-design.md`. The night's page's floating field comes with the readings (D101).
+`onboarding`: onboarding in SoulDreams Dev (D103): the welcome, the founder's note, the age question, the disclosure's
+first layer with one consent, the disclosure and privacy page, and the first empty journal; the consent kept on the
+phone, and the app back at its start when it goes. Plan: `docs/plans/onboarding.md`.
 
 ## Road ahead
 
-- The merge of `journal-design`. The owner's by-eye review (the plan's Task 8) passed; his verdicts for Product: the
-  growing pill field is good as built, and so are the spacings (30, 20, 12). The night's page's floating field comes
-  with the readings (D101).
+- The owner's by-eye review of `onboarding` (the plan's Task 7), then its merge. Product's answers to the plan's Part 4
+  come back through the head.
+- Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1), once the pending lines are filed
+  (and, for the founder app, with his export).
 - The readings: our server's own spending counter comes with them (D69), and response streaming on the function
   URL (head's message 14; whether eu-north-1 has it is checked first).
 - A later branch, by the Head of Technology's direction (with D32): the import gains a kind for lens sections 3, 4, 5,
@@ -153,6 +154,22 @@ and 9 to 13; the spacings TO TRY), and D100 (a connection lost during a recordin
   the menu's pill look 41 and take a tap in a box of 44 (`StandIns.hitMin`, D102), their looks anchored to the row's top
   and the page's margin; what stands below starts where the looks end (`BelowTapBox`), so nothing moved. A tap outside
   the open menu only closes it (D102).
+- Onboarding (D103; `app/lib/onboarding/`, SoulDreams Dev only): `JournalHome` opens the folder, reads the consent,
+  and shows onboarding until it is given, holding the whole app in the light theme, the cover included
+  (`core/always_light.dart`). The steps: MP·2 into the wordmark (h1) and MP·3; MP·4 and MP·5; C4-P·2 with MP·6's seven
+  bands in a dropdown (MP·50), Next inert until one is chosen; under 18, EM·5 and MP·31 on one card, which stays
+  (MP·31 changes nothing) and nothing is kept; the disclosure's first page (W27·1, W27·2, W27·5, W27·13, then MP·30)
+  and its consent page (W27·14, W27·15, W27·17, MP·57, MP·58, MP·59, then EM·6 left and MP·8 right); EM·6 back to
+  the first page; MP·58 opens the disclosure and privacy page (every part, W27·1 to W27·17, in order), whose back
+  control returns to the consent. "I agree" keeps `consent.json` in the journal's folder (`{"version":1,"over18":true}`,
+  written whole and renamed; never the band), then the journal opens: the first time, its empty state adds MP·9 and a
+  drawn arrow to the record button, once. The recording and its retries start only then. A consent that cannot be
+  read or kept logs `consentReadFailed` or `consentKeepFailed`; onboarding asks again at the next opening. When the
+  consent goes (`Journal.withdrawConsent`, or `Journal.deleteAll`, which takes it with every file), every page closes
+  and onboarding starts again; no control calls either yet (Settings, P8; the plan's question 3). Parts to rewrite
+  show their handles: `[W27·2]` and `[W27·17]` in onboarding, also `[W27·3]`, `[W27·6]` and `[W27·10]` on the page.
+  The stand-ins: the box (`Spacing.onboardingBox` inside `color.surface`), the arrow (`StandIns.firstArrow`,
+  `arrowGap`); no logo and no drawn signature (none filed).
 - The record button is a circle (Task 15a, the owner's correction, P13): `StandIns.recordWidth` and `recordHeight`
   both 120, the radius half the height; large text shrinks its words, never the circle.
 - The night rules (`app/lib/journal/night_rules.dart`, `journal.dart`): a night stores its closing instant, the
@@ -178,10 +195,10 @@ and 9 to 13; the spacings TO TRY), and D100 (a connection lost during a recordin
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 438 tests, and 303 mutation checks (A1 to A274; A55, A73, A80 to A83, A86 to A88, A94, A99,
+- The app's analyzer baseline: `No issues found!`. The app has 469 tests, and 331 mutation checks (A1 to A302; A55, A73, A80 to A83, A86 to A88, A94, A99,
   A128 to A130, A142, A207, A213 and A223 dropped, each with its reason in the file; with the rows A24a to A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
-  (expected: `app mutations: 303 run, 303 caught`); `check_all.sh` does not call it (D55). During a task only the
+  (expected: `app mutations: 331 run, 331 caught`); `check_all.sh` does not call it (D55). During a task only the
   rows that target the files changed are run, with `--rows A1,A7` or `--files lib/a.dart` (D95).
 
 ## The server
@@ -651,6 +668,18 @@ Banked in recording:
      right edge (it opens at the look's attachment point by `controller.open(position:)`), not at its middle; on a
      very short body (keyboard up with the largest text) the typing page overflows 3 pt sooner than before.
 
+Banked in onboarding (the plan's decisions; none changes what the dreamer sees beyond D103):
+
+117. The consent is not asked again when the disclosure changes (the W27 rewrites before Cohort 1): the plan's question
+     7. The file's format may change freely until it reaches the founder app (D49 O5).
+118. Nothing on screen withdraws the consent or deletes the journal yet: both wait for Settings (P8) and, for the
+     withdrawal, a place from Product (the plan's question 3). Their effect is built and tested.
+119. The founder's logo (onboarding's first step and the first empty journal) and his drawn signature and smiley
+     (the note) are not built: no file is filed (the handover §11). The note's signature is MP·5's words.
+120. MP·6's seven labels are parted at "; ", a separator the handover §4 does not name; MP·2's Swedish has no
+     paragraph break, so in Swedish it shows whole with no wordmark; MP·4's Swedish is shorter than its English (the
+     plan's question 9). English only is shown (D57 Q12).
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
@@ -692,8 +721,9 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   owner in Task 9b.
 - MP·63 (the microphone refused) and MP·64 (the stop control's spoken name), head's message 21 (Product message 20),
   founder-approved; built in `offline-recording`.
-- W27·5's privacy-page text (head's message 16) waits for the disclosure and privacy page, under Settings; it is not
-  in the pending file.
+- W27·5's privacy-page text (head's message 16) shares the filed handle W27·5, so it cannot be a pending line under
+  it: Product files it, or gives it a new handle (D103 item 3; the plan's question 1). Until then the page shows
+  W27·5 as filed at C16-P.
 
 ## Rulings during branch 2
 
@@ -920,6 +950,13 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   by-eye review of the branch passed, and matches his design; his verdicts for Product: the growing pill field and the
   spacings (30 / 20 / 12) are good as built.
 
+## Rulings during onboarding
+
+- D103 (owner, the brainstorm): (1) SoulDreams Dev only; the founder and tester apps a later, separate ruling;
+  (2) the age band kept on the phone only and never sent, under 18 refused with EM·5; (3) the disclosure as filed at
+  C16-P, W27·5's rewrite to Product; (4) the consent kept on the phone; withdrawing it, or deleting the journal,
+  returns to the start.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's C16-P state (`ff3b229`), in commit `ca29414` (Task 6). The ordinal
~~~~

### Task 7 · [OWNER] The by-eye review, SoulDreams Dev, invented nights only

By eye only, no DevTools (D99), in SoulDreams Dev built from this branch, with invented nights only (R2). Any result
that differs: stop and bring it to the Build chat; nothing is fixed on the phone.

1. **The rehearsal (workflow (c)).** Before installing, count the rows in SoulDreams Dev's journal. Install this
   build over it. Expected: the app opens on onboarding, not the journal. Go through to "I agree" (steps 3 to 9):
   the journal shows the same rows, the same count, each opening as before.
2. **Light at night.** After 21:00 (or before 08:00), open onboarding: every step is in the light theme. Swipe up to
   the app switcher: the card is the plain light page colour, no words.
3. **The welcome.** "Welcome to", then "SoulDreams" in the large script face, then the second line, appearing word by
   word; Next at the foot. No logo (none filed).
4. **The note.** The founder's note and "With Love, -Ludvig, Founder", word by word; Next.
5. **The age.** "How old are you?" and a field showing "Select..."; Next before choosing does nothing. The field
   opens a list of the seven bands.
6. **Under 18.** Choose the first band, Next: one card, the sentence and "I understand"; tapping it changes nothing,
   and there is no Next. Close the app fully (swipe it away in the app switcher) and open it: the welcome again.
7. **The disclosure's first page** (choose an adult band, Next): four parts, the second shown as `[W27·2]`; Next.
8. **The consent page.** Three parts, the third shown as `[W27·17]`; the pointer; "Read everything"; the consent line;
   "I don't agree" left and "I agree" right. "I don't agree" returns to the first page (step 7).
9. **Read everything.** A page of every part in order, `[W27·2]`, `[W27·3]`, `[W27·6]`, `[W27·10]` and `[W27·17]`
   among them; the round back control top left returns to the consent page, and so does the edge swipe.
10. **I agree** (by day): the journal, in the day theme. Close and open the app: the journal at once, no onboarding.
11. **The first empty journal.** Delete SoulDreams Dev (its invented nights go with it) and install it again; go
    through to "I agree". Expected: "This is where your journal entries will appear.", and above the record button
    "Click here to record your first dream" with a thin arrow pointing down to it. Record or type a dream and Save:
    the row shows, the pointer is gone. Delete that night: the empty journal shows its line only, no pointer.
12. **Large text** (the phone's largest): every step scrolls, nothing is cut off, the buttons shrink their words to
    stay on one row; the page of every part scrolls.
13. **For Product, the founder's verdict (TO TRY):** the white box around each step's words; the welcome, note and
    under-18 line word by word and the disclosure's parts whole; Next centred at the foot; "I don't agree" left,
    "I agree" right; the arrow. Keep, or what to change.

## Part 4 · Questions (numbered; a blank is not a yes)

**For Product, through the head** (each changes a screen, a flow or a word, so it waits for Product; the blocks build
the lean):

1. **W27·5's rewrite** (head's message 16) shares the filed handle W27·5, so it cannot be a pending line under it
   (D103 item 3). *Lean:* Product files it as W27·5's next text, in both layers as now; until then W27·5 shows as
   filed at C16-P. If Product gives it a new handle, the page gains a part.
2. **Which part on which of the disclosure's two pages.** No document says. *Lean, as built:* the first page W27·1,
   W27·2, W27·5, W27·13 and Next (MP·30); the second W27·14, W27·15, W27·17, MP·57, MP·58, MP·59, then EM·6 and MP·8.
3. **Withdrawing the consent** (D103 item 4) has no place, control or words in any document. *Lean:* a new place on
   the disclosure and privacy page in Settings, founder words, one confirmation; the nights stay (only the consent
   goes, and onboarding asks again). Built: its effect, with no control.
4. **The disclosure and privacy page's title.** None is given (MP·48 is the way in from Settings). *Lean:* no title,
   as built; or MP·48 as the title, if Product says so.
5. **Motion.** *Lean, as built:* the welcome, the note, the age question, EM·5 and MP·9 word by word (the app's own
   lines, How the AI Appears §4); the disclosure's parts and MP·57 to MP·59 whole, as a text to read.
6. **The buttons' places.** *Lean, as built:* a single button (Next) centred at the foot; "I don't agree" left and
   "I agree" right, as Cancel comes first; "Read everything" a plain pill under MP·57; "I understand" inside the
   under-18 card.
7. **A changed disclosure.** When W27·2, W27·3, W27·6, W27·10 and W27·17 are rewritten before Cohort 1, is consent
   asked again of a dreamer who agreed to the earlier text? *Lean:* yes; the consent's file then records which filing
   was agreed to (a later branch; the format may change freely until it reaches the founder app, D49 O5).
8. **No back control in onboarding.** *Lean, as built:* each step goes forward only; only the page "Read everything"
   opens has one.
9. **Words to check before Swedish is shown** (R1: never settled in code). MP·6's seven labels are parted at "; ", a
   separator the handover §4 does not name; MP·2's Swedish has no paragraph break, so it shows whole with no
   wordmark; MP·4's Swedish is shorter than its English (no greeting, no fourth and fifth paragraphs). *Lean:*
   Product checks the three; English only is shown meanwhile (D57 Q12).
10. **"I understand" changes nothing** (C127-I I6, "the card stays; nothing more happens until the app closes").
    *Lean, as built:* as written.
11. **The look, TO TRY.** `space.onboarding.box` read as the inside of one white box (`color.surface`, its border,
    radius 30) holding each step's words, 30 from the screen's sides and 20 from its top; the founder's logo and his
    drawn signature and smiley wait for their files (the handover §11), which would come fingerprinted, as the fonts
    did (a G0 and G2 change, the owner's). *Lean:* as built until the founder's verdict (Task 7, check 13).

**For the owner (how to build)**:

12. **What is kept of the age.** D103 item 2 says "the age band is kept on the phone"; main-path.md says the phone
    keeps only "18 or over", and the Principles "kept only as its result". *Lean, as built:* only the result, inside
    the consent's file; the band never written anywhere.
13. **Before a later age answer.** Under 18 keeps nothing, so the next opening starts at the welcome, not at the age
    question (C127-I I6, "asked again the next time the app opens"). *Lean:* as built.
14. **The parts to rewrite** show their handles (R1, D31), against the handover §4 ("the line stands, and is built as
    it is"). *Lean:* R1 stands; the founder's rewrites of W27·2 and W27·17 are owed before onboarding can reach the
    founder or tester app (D103 item 1), and the owner's later ruling names them.
15. **C158-I** is not in `docs/source/` (the Interpretation record there is at C154-I). *Lean:* nothing waits on it;
    the owner imports the newer record when convenient.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `./.scratch/ob/build`, from `git archive` of `71e0dac`, each
   task's state kept as a snapshot (`./.scratch/ob/snaps/<task>`); each block in Part 3 is `git diff --no-index`
   between two snapshots.
2. **The counts measured on the build**: app tests 438 (baseline), 445, 446, 460, 469, 469, 469; `No issues found!`
   at each.
3. **Test first**: each task's new tests were run on the code before it and failed to load (they name what the task
   adds); each assertion was then shown to bite by its mutation row (item 4). Two tests were added or widened during the build,
   each so a row can bite: the first empty journal's test now adds and deletes a night on the same visit (its
   first form could not see A301; changed before the run), and `the consent withdrawn: the retry cut, none after`
   (A300 survived the first run).
4. **Mutations on the build** (D95: every row of the files changed): on the build, `app mutations: 77 run, 73 caught`: A190, A226 and A227
   no longer found their pattern (the journal's start moved into `_enter`, one indent less; they follow the code,
   D67), and A300 survived (nothing noticed the retries left running after the start; a test added in Task 4). Then
   the 32 new and followed rows on the replayed tree: `app mutations: 32 run, 32 caught`.
5. **The guards** on each snapshot: G4 first refused four test names of twelve words or more, each shortened in its
   task; then `guards (walk): all passed` on every snapshot.
6. **Replayed on a fresh copy**, `./.scratch/ob/replay`, from `git archive` of `71e0dac`: every block applied with
   `git apply` in order, and after each the replayed tree against its snapshot: no difference. On the replayed tree:
   `guards (walk): all passed`, `No issues found!`, `+469: All tests passed!`.
7. **Not provable in the sandbox, so the owner's** (Task 7): the look on the phone; the light theme and the cover at
   night; the dropdown as iOS shows it; the rehearsal over an existing Dev journal; closing the app after the
   under-18 card.
8. The guards and their tests, the server, Swift and the words are unchanged (241 guard tests, 47 server tests).
9. The scratch copies (`./.scratch/ob/`) are deleted after this plan is committed.

*No matter where you are on your journey, the steps you take are equally important.*
