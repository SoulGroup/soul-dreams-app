# Plan: Product's C19-P imported and reconciled with the founder's rulings (c19p-import)

Branch `c19p-import`, from `main` at `c72fca2`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D126. Written by Claude Code (Opus) on 2026-11-25. Governs: C19-P (Product's record, the register,
the Design System, imported by the owner on this branch, not yet committed), the founder's D161 (items 1 to 5, the
owner's brief), D121 item 1, D125, D127, D128 and R1. The owner checks by eye only.

The owner's import ran before this plan: `docs/source/SOURCES`, `docs/source/design-system.md`,
`docs/source/product-change-record.md` and `app/assets/words/places-register.csv` changed, and the words generator
refused `pending-filed` at the pending lines' row 2, as expected. The import's Terminal output did not reach this
session (the brief's placeholder was left empty); the plan works from the working tree, where the three hashes C19-P
item 11 states match `SOURCES` (the register `01328992…`, the Design System `1a07ffc3…`) and G2 passes on the
proven copy. Status.md's first line still names `readings-plumbing`'s merge as next; `main` is at `c72fca2`, which
holds it, so this is not a stop: Task 4 records it.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

C19-P fills the consents' owed sentences, adds two places (MP·98, the voice paused without consent (a); MP·99, the
language names), gives Night/Day mode three values, retires EM·6, puts "I agree" in the consent pair, marks MP·66 to
rewrite, keeps "Made by AI" under readings only, names Inter for Inter Display, and rules the dark delete icon
#8F3D24. Two of its new handles, MP·98 and MP·99, are the handles our pending Back and Turn on held, which is why
the generator refused.

After this branch, in SoulDreams Dev:
- Life Context's page still reads Back / Turn on, now the pending MP·107 and MP·108 (D161 item 1).
- Onboarding's foot still reads "I don't agree" / "I agree": the decline is the pending MP·109, EM·6's last filed
  words, English and Swedish (D161 item 2).
- Nothing shows C19-P's MP·98: before "I agree" the microphone stays and a tap shows the popup MP·101 (D128; D161
  item 3).
- Settings' Night/Day mode offers Automatic, Day and Night; Day and Night hold whatever the hour; the quick toggle
  still switches the theme in half a second, now setting Day or Night (D161 item 4). Storage is unchanged:
  `settings.json` already holds `automatic`, `day` or `night`.
- Settings' Language pill shows "English" (MP·99's name for English) where it showed `[owed·language]`; English is
  still the only choice (D121 item 1).
- The disclosure shows W27·2 and W27·6 as C19-P wrote them.
- The dark delete icon on Life Context's page stays #D0775A (D161 item 5), though the design values now carry the
  filed #8F3D24 as `DarkColours.lifecontextDelete`.

### Every C19-P change, and what the app does with it

| C19-P | In the app | Why |
|---|---|---|
| MP·98 "Recording by voice is paused…" (new) | generated, shown nowhere; a test holds it off every screen | D161 item 3; D128 |
| MP·99 "English / Svenska" (new) | Language shows the app language's own name, one choice | adopted; D121 item 1 |
| MP·44 Automatic / Day / Night | three choices; the toggle sets Day or Night | adopted, D161 item 4 |
| EM·6 retired; the consent page "Next alone" | the pending MP·109 holds EM·6's words; the foot is unchanged | D161 item 2; D127; D128 |
| MP·67's English "I agree / I don't agree" | generated; shown nowhere (D128) | adopted |
| MP·66 "to rewrite" | generated as a stand-in (D119); shown nowhere | adopted |
| MP·68, MP·70 written | generated; shown nowhere (D125 item 8; D128) | adopted |
| W27·2, W27·6 written | shown in the disclosure, as filed | adopted |
| MP·71 under readings only, never on a painting | already so (D123; `night_page.dart`) | adopted, no change |
| Inter for Inter Display | already so (D118; `designgen.py`'s `FACES`) | adopted, no change |
| dark `color.lifecontext.delete` #8F3D24 | generated; the app keeps #D0775A | D161 item 5 |
| the Personal gap (MP·70's flag) | already so: Personal shows the curated set (D121 item 3) | adopted, no change |

**Why the dark delete icon keeps #D0775A (D161 item 5).** On Life Context's dark surface (its gradient's two ends)
#8F3D24 is 1.45:1 and 2.02:1, below the 3:1 a meaningful icon needs (WCAG 2.2 SC 1.4.11; the Principles' AA floor,
§3); #D0775A is 3.28:1 and 4.58:1 (design-system.md §4, C19-P's own figures). C19-P records #8F3D24 as a founder-ruled
departure for him to judge in Cohort 0; the founder has now judged it. The reason sits beside the value
(`StandIns.keptDeleteDark`, `palette.dart`), in Status.md, and in the list for Product (Part 6).

### Decided under D91 (how to build only)

1. **The new handles** are the first free ones above C19-P's highest (MP·99) and the pending MP·100 to MP·106:
   MP·107 (Back), MP·108 (Turn on), MP·109 (I don't agree). The generator itself proves no clash (`pending-filed`,
   `repeated-handle`, `dart-name-clash`), and did so on the proven copy.
2. **The owner's paste takes EM·6's words from git**, from the register as filed at C18-P (`c72fca2`), and checks
   EM·6's status there was "written", so no word is typed by anyone (R1). The renamed rows keep their words and
   their "given" note, with "renumbered from MP·98 (or MP·99) at C19-P (D161 item 1)" added, and move after MP·106 so
   the file stays in handle order. Their place, status, words and given are otherwise unchanged.
3. **The design generator learns C19-P's form** "#hex, as in the light theme (a ruling): prose": the hex is taken,
   the prose is not written out (D52), and the generator stops (`as-differs`) if the hex is not the light theme's own
   value for that role, or (`as-unknown`) if the light theme has no such role. A bracket or a parenthesis in the prose
   still stops it (`colour-form`). Four guard mutation rows.
4. **The Language pill** reads MP·99's parts in `Lang`'s order (English, Svenska): a test pins that the names come
   back in that order, and that English shows "English".
5. **The braced-sentence check** (Before Cohort 1 item 4) stays: no tester or founder build may reach a braced line.
   Since C19-P none is filed, so its helper is proved on two made-up lines instead of MP·68 and MP·70; row A480 (a
   tester build reaching MP·68) can no longer be built and is dropped; A545 still breaks the helper and is caught.
6. **Four tests named for "Manual"** are renamed for Day and Night (their rows follow, by name); "Manual chosen in
   the dark theme keeps the dark" becomes "Day chosen in the dark theme turns it light", which also checks Night.

### The places this branch uses

EM·9, MP·44, MP·99 (filed); MP·100, MP·107, MP·108, MP·109 (pending: their words in SoulDreams Dev only, their
handles elsewhere, R1). No place is missing a line.

### The tests (test-first, on the Mac)

Task 1's tests alone fail (the renamed pending lines and MP·44's three choices); whole, 837 pass. Task 2's test alone
fails on the Language pill; whole, 837. Task 3's test passes alone by design: it pins a value already kept (#D0775A)
against the newly generated filed one, and its code change is comments; rows A733 to A735 and A925 prove it.

## Part 2 · Settings, packages, AWS and storage

- **Packages, settings, AWS, the server:** none. No server file changes, so no server run.
- **Storage on the phone** (R11): none. `settings.json` keeps `automatic` / `day` / `night` as before.
- **Protected paths:** `tool/checks/designgen.py`, `tool/checks/tests/test_designgen.py` and
  `tool/checks/tests/mutations.py` change in Task 1. The sandbox refuses shell writes under `tool/checks/`, so Claude
  Code applies the rest of the block with `git apply --exclude='tool/checks/*'`, writes those three files with the
  Write tool from the block's own lines, and proves each with `cmp` against a copy built from the block.
- **New file kinds (G0):** none.

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, made from the build that proved it (Part 5). Apply it from
the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Every app task ends green:
`cd app && fvm flutter analyze --no-pub` prints `No issues found!`, `fvm flutter test --no-pub` prints
`+837: All tests passed!`, the task's rows (D126) are all caught, and the hook prints `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `c19p-import`, after Task 1a:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/wordsgen.py --check ; python3 -I -B tool/checks/designgen.py --check
```

Expected: the import's four files and Task 1a's seven modified (the pending lines, their fingerprint, the five
generated files); this plan's commit;
`wordsgen: up to date`; `designgen: refused colour-form line 110` (Task 1 teaches it). Anything else: stop (R14).

### Task 1a · [OWNER] The pending lines renamed, MP·109 added, re-fingerprinted and regenerated (D161 items 1 and 2)

One paste. It reads EM·6's words from the register as filed at C18-P (`c72fca2`), refuses unless the file is
exactly as expected (the handles MP·98 to MP·106, in order, and a form it can write back unchanged), renames MP·98
and MP·99 to MP·107 and MP·108, moves them after MP·106, adds MP·109, then fingerprints the file and runs the words
generator.

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app && python3 -I -B - <<'PY' && cd app/assets/words && shasum -a 256 pending-lines.csv > pending-fingerprint.txt && cat pending-fingerprint.txt && cd ~/Developer/soul-dreams-app && python3 -I -B tool/checks/wordsgen.py --write | grep -E 'wrote|pending' && grep -c 'PendingLine(' app/lib/words/pending.g.dart && tail -3 app/assets/words/pending-lines.csv
import csv, io, subprocess
P = 'app/assets/words/pending-lines.csv'
FILED = subprocess.run(['git', 'show', 'c72fca2:app/assets/words/places-register.csv'],
                       capture_output=True, text=True, check=True).stdout
em6 = [r for r in csv.reader(io.StringIO(FILED)) if r and r[0] == 'EM·6']
assert len(em6) == 1 and em6[0][9] == 'written', 'EM·6 not as filed at C18-P'
text = open(P, encoding='utf-8', newline='').read()
rows = list(csv.reader(io.StringIO(text)))


def out(rs):
    s = io.StringIO()
    csv.writer(s, lineterminator='\n').writerows(rs)
    return s.getvalue()


assert out(rows) == text, 'the file is not in the form expected'
assert [r[0] for r in rows[1:]] == ['MP·%d' % n for n in range(98, 107)], 'handles not as expected'
keep = [r for r in rows[1:] if r[0] not in ('MP·98', 'MP·99')]
moved = []
for r, new in zip(rows[1:3], ('MP·107', 'MP·108')):
    moved.append([new, r[1], r[2], r[3], r[4], r[5] + '; renumbered from %s at C19-P (D161 item 1)' % r[0]])
decline = ['MP·109',
           "Onboarding's second disclosure page: the button that declines (beside MP·100)",
           'pending', em6[0][11], em6[0][12],
           "the founder (D161 item 2; D127; D128): EM·6's last filed words (C18-P), EM·6 retired at C19-P; "
           'handle proposed to Product']
open(P, 'w', encoding='utf-8', newline='').write(out([rows[0]] + keep + moved + [decline]))
print('pending:', ' '.join(r[0] for r in keep + moved + [decline]))
PY
```

Expected:
- `pending: MP·100 MP·101 MP·102 MP·103 MP·104 MP·105 MP·106 MP·107 MP·108 MP·109`;
- `b93f255bd1bfe385006f0fd44878b91cc896afe33518780ff921a959d88ce627  pending-lines.csv`;
- `wordsgen: wrote` five times: `lines.g.dart`, `words.g.xcconfig`, the two `InfoPlist.strings`, `pending.g.dart`;
- `wordsgen: pending lines 10`;
- `11` (the class's constructor and the ten lines);
- the three last rows: MP·107 "Back" / "Tillbaka", MP·108 "Turn on" / "Slå på", MP·109 "I don't agree" /
  "Jag samtycker inte".

An `AssertionError` changes nothing (the file is written only after every check): bring it to the Build chat. A
refusal prints `wordsgen: refused …`: stop. Do not commit: Task 1 commits it with the code. The app does not build
between this paste and Task 1 (it still names `EM_6`, `MP_98` and `MP_99`).

### Task 1 · The import: the design generator, the renamed lines, MP·44's three choices (C19-P; D161 items 1 to 4)

Changed: `designgen.py` and its tests and rows; `tokens.g.dart` (regenerated, the block holds it); onboarding's
decline, Life Context's buttons, Settings' Night/Day row; the tests and rows that name them. Rows A921 and A922
new; A443, A548, A636, A639 and every row naming a renamed test follow; A480 dropped (Part 1, item 5).

Checks, after applying:

```
python3 -I -B tool/checks/designgen.py --check && python3 -I -B tool/checks/wordsgen.py --check && python3 -I -B tool/checks/tests/run_tests.py 2>&1 | tail -1 && python3 -I -B tool/checks/tests/mutations.py designgen.py | tail -1
```

Expected: `designgen: up to date`, `wordsgen: up to date`, `OK` (287 tests), `mutations: 22 run, all caught`.
Then the app (837), and the rows:

```
python3 -I -B tool/app_mutations.py --files lib/settings/settings_page.dart,lib/settings/consent_page.dart,lib/onboarding/onboarding.dart,lib/core/night_day.dart,lib/settings/settings.dart,test/words/shown_lines_test.dart,lib/app.dart | tail -1
```

Expected: `app mutations: 83 run, 83 caught`.

Commit, with the owner's import (the four files) and Task 1a's seven:

> Import C19-P: the pending Back and Turn on as MP·107 and MP·108, "I don't agree" as MP·109, Night/Day's three choices (D161)

**The block:**

~~~~diff
diff --git a/app/lib/core/night_day.dart b/app/lib/core/night_day.dart
--- a/app/lib/core/night_day.dart
+++ b/app/lib/core/night_day.dart
@@ -1,6 +1,6 @@
 // Night/Day mode (design-system.md §6; main-path.md, Settings; P14; D56;
 // D122): Automatic, dark from 21:00 and light from 08:00 by the phone's
-// local time now; or Manual, Day or Night, as the dreamer set it. The clock
+// local time now; or Day, or Night, as the dreamer set it (MP·44, C19-P). The clock
 // turning the hour while the app is open fades over five seconds, easing in
 // and out (head's message 20, item 13); a change the dreamer makes, the
 // quick toggle or the mode, takes half a second (D125 item 6); with Word
@@ -17,8 +17,8 @@ import 'package:flutter/material.dart';
 
 import 'app_line.dart' show wordAnimation;
 
-/// Night/Day mode (MP·44): Automatic, or Manual, Day or Night
-/// (main-path.md, Settings).
+/// Night/Day mode (MP·44): Automatic, Day or Night, in the line's
+/// order (C19-P; D161 item 4).
 enum NightDayMode { automatic, day, night }
 
 /// Dark from 21:00 to 08:00, by the wall clock.
diff --git a/app/lib/design/tokens.g.dart b/app/lib/design/tokens.g.dart
--- a/app/lib/design/tokens.g.dart
+++ b/app/lib/design/tokens.g.dart
@@ -1,5 +1,5 @@
 // GENERATED by tool/checks/designgen.py from docs/source/design-system.md
-// (sha256 1c41ff6b3b920af7afb7413200f8c1d5a2b9d131d9eb0efe8140ce4309780b61). Do not edit: import the Design System again.
+// (sha256 1a07ffc3c3fbc48a1c9abfba7b5fa1074da4f53b6eda2a74ccc3e89cdebfd4e6). Do not edit: import the Design System again.
 
 import 'package:flutter/painting.dart';
 
@@ -205,9 +205,11 @@ abstract final class DarkColours {
   /// `color.lifecontext.date`
   static const lifecontextDate = ColourRole(colour: Color(0xFFABAB93));
 
+  /// `color.lifecontext.delete`
+  static const lifecontextDelete = ColourRole(colour: Color(0xFF8F3D24));
+
   // Not ruled in the source yet
   // (to try, or proposed), so no constant:
-  // `color.lifecontext.delete`
   // `color.label.questions`
 }
 
diff --git a/app/lib/onboarding/onboarding.dart b/app/lib/onboarding/onboarding.dart
--- a/app/lib/onboarding/onboarding.dart
+++ b/app/lib/onboarding/onboarding.dart
@@ -3,7 +3,7 @@
 // first layer on two pages (C14-P item 1; the plan's question 2 for which
 // part stands on which page). The second ends with MP·58, which opens the
 // full disclosure page, the text only, with its own back control (D127 item
-// 1); then, at the foot, EM·6 "I don't agree" left and MP·100 "I agree"
+// 1); then, at the foot, MP·109 "I don't agree" (EM·6's words, a pending line since C19-P retired EM·6, D161 item 2) left and MP·100 "I agree"
 // right, a pending line, equal, neither chosen beforehand. "I agree"
 // accepts the disclosure and gives the readings (a) and Life Context (b)
 // consents (C159-I item 5; D127 amends MP·83's "never on before consent");
@@ -216,7 +216,7 @@ class _OnboardingState extends State<Onboarding> {
   Widget? _foot() => switch (_step) {
     _Step.underAge => null,
     _Step.more => ButtonRow(
-      left: PlainButton(Lines.EM_6.text(appLanguage), onPressed: () => _decide(false)),
+      left: PlainButton(PendingLines.MP_109.text(appLanguage), onPressed: () => _decide(false)),
       right: PlainButton(PendingLines.MP_100.text(appLanguage), onPressed: () => _decide(true)),
     ),
     _ => _one(PlainButton(Lines.MP_30.text(appLanguage), onPressed: _next)),
diff --git a/app/lib/settings/consent_page.dart b/app/lib/settings/consent_page.dart
--- a/app/lib/settings/consent_page.dart
+++ b/app/lib/settings/consent_page.dart
@@ -1,6 +1,6 @@
 // Life Context's own page, from Settings (D110; D122; D125 item 9; D128):
-// MP·69 over two buttons, Back on the left and Turn on on the right (MP·98
-// and MP·99, pending lines: their words show in SoulDreams Dev only, R1),
+// MP·69 over two buttons, Back on the left and Turn on on the right (MP·107
+// and MP·108, pending lines, renumbered at C19-P, D161 item 1: their words show in SoulDreams Dev only, R1),
 // equally prominent, neither chosen beforehand, a tap answering at once. Back
 // and the back control give nothing; Turn on gives Life Context. It is the
 // only page of its kind: there is no consent to give or withdraw anywhere
@@ -30,8 +30,8 @@ class TurnOnChoice extends StatelessWidget {
   Widget build(BuildContext context) {
     Widget one(bool given, String text) => _Choice(key: keyOf(given), text: text, onTap: () => onChoose(given));
     return ButtonRow(
-      left: one(false, PendingLines.MP_98.text(appLanguage)),
-      right: one(true, PendingLines.MP_99.text(appLanguage)),
+      left: one(false, PendingLines.MP_107.text(appLanguage)),
+      right: one(true, PendingLines.MP_108.text(appLanguage)),
     );
   }
 }
diff --git a/app/lib/settings/settings.dart b/app/lib/settings/settings.dart
--- a/app/lib/settings/settings.dart
+++ b/app/lib/settings/settings.dart
@@ -2,7 +2,7 @@
 // MP·26, MP·44, MP·84, MP·85; D110; D121; D122; D125 item 8), in plain Dart,
 // kept on the phone in the journal's folder (R11; docs/workflow.md (c)):
 // Word Animation, on by default (D110); Night/Day mode, Automatic by
-// default, or Manual, Day or Night; Night images, Personal by default
+// default, or Day, or Night (MP·44, C19-P); Night images, Personal by default
 // (D160), or Random or Off, with no consent behind it (D125 item 8); Life
 // Context's length, 2 weeks by default (C159-I item 1), remembered now and
 // used once Life Context is built (D121 item 2). Whether Life Context is on
diff --git a/app/lib/settings/settings_page.dart b/app/lib/settings/settings_page.dart
--- a/app/lib/settings/settings_page.dart
+++ b/app/lib/settings/settings_page.dart
@@ -2,13 +2,13 @@
 // D122; D128), reached from the journal's gear, in SoulDreams Dev only: the
 // back control top left; the quick toggle top centre (MP·45), showing what it
 // switches to, a moon in the light theme and a sun in the dark, which
-// switches the theme in half a second and sets Night/Day mode to Manual
-// (D125 items 6 and 7); MP·25 in h2; then six rows, each its name and a
+// switches the theme in half a second and sets Night/Day mode to Day or
+// Night (D125 items 6 and 7; D161 item 4); MP·25 in h2; then six rows, each its name and a
 // value pill, every pill one size and every row one height (D125 item 4),
 // the gap from a pill's right edge to its row's equal to the gap above and
 // below it (D128 item 6), opening the phone's menu: Language (EM·9; English
 // only, its name owed, D121 item 1), Word Animation (MP·26), Night images
-// (MP·85), Night/Day mode (MP·44), Life Context (MP·83) and Life Context
+// (MP·85), Night/Day mode (MP·44: Automatic, Day or Night, C19-P), Life Context (MP·83) and Life Context
 // length (MP·84); then the row opening "What you've told Soul Dreams"
 // (MP·86, its flag; D121 item 2; D131), its name and a chevron; then "Read
 // disclosure & privacy" (MP·48) and "Delete journal" (EM·11) in the
@@ -119,7 +119,7 @@ class _SettingsPageState extends State<SettingsPage> {
     if (mounted) setState(() {});
   }
 
-  // The theme the dreamer is heading for: Manual's own, since the theme on
+  // The theme the dreamer is heading for: Day's or Night's own, since the theme on
   // screen lags a fade by half its length and a second tap would undo
   // nothing; Automatic's is the one shown.
   bool get _dark => switch (_c.settings.nightDay) {
@@ -149,7 +149,8 @@ class _SettingsPageState extends State<SettingsPage> {
       ) ==
       true;
 
-  // The quick toggle: the other theme, Manual (Design System §6).
+  // The quick toggle: the other theme, as Day or Night (Design System §6;
+  // D161 item 4).
   void _toggle() => _c.change(_c.settings.copyWith(nightDay: _dark ? NightDayMode.day : NightDayMode.night));
 
   void _wordAnimation(int i) => _c.change(_c.settings.copyWith(wordAnimation: i == 0));
@@ -157,10 +158,8 @@ class _SettingsPageState extends State<SettingsPage> {
   // Night images asks nothing: it is a setting, with no consent (D125 item 8).
   void _nightImages(int i) => _c.change(_c.settings.copyWith(images: NightImages.values[i]));
 
-  // Manual keeps the theme on screen (the stop's question 5).
-  void _nightDay(int i) => _c.change(
-    _c.settings.copyWith(nightDay: i == 0 ? NightDayMode.automatic : (_dark ? NightDayMode.night : NightDayMode.day)),
-  );
+  // Automatic, Day or Night, in MP·44's order (C19-P; D161 item 4).
+  void _nightDay(int i) => _c.change(_c.settings.copyWith(nightDay: NightDayMode.values[i]));
 
   // Before the dreamer has agreed, the popup, nothing changed (D128 item 3);
   // On shows Life Context's page; Off asks nothing: it pauses, and nothing is
@@ -279,7 +278,7 @@ class _SettingsPageState extends State<SettingsPage> {
               ),
               row(SettingRow.wordAnimation, Lines.MP_26, s.wordAnimation ? 0 : 1, _wordAnimation),
               row(SettingRow.nightImages, Lines.MP_85, s.images.index, _nightImages),
-              row(SettingRow.nightDay, Lines.MP_44, s.nightDay == NightDayMode.automatic ? 0 : 1, _nightDay),
+              row(SettingRow.nightDay, Lines.MP_44, s.nightDay.index, _nightDay),
               row(SettingRow.lifeContext, Lines.MP_83, c.given(Consent.lifeContext) ? 0 : 1, _lifeContext),
               row(SettingRow.length, Lines.MP_84, s.length.index, _length),
               if (widget.lifeContext case final life?)
diff --git a/app/test/core/night_day_test.dart b/app/test/core/night_day_test.dart
--- a/app/test/core/night_day_test.dart
+++ b/app/test/core/night_day_test.dart
@@ -96,16 +96,16 @@ void main() {
     await tester.pump();
   });
 
-  // D122: Manual, Day or Night, whatever the hour; set from a page under the
+  // D122; MP·44 (C19-P): Day or Night, whatever the hour; set from a page under the
   // app, it fades over five seconds while the app is open.
-  test('Manual holds its theme whatever the hour', () {
+  test('Day or Night holds its theme whatever the hour', () {
     expect(isNight(NightDayMode.day, DateTime(2026, 6, 10, 23)), isFalse);
     expect(isNight(NightDayMode.night, DateTime(2026, 6, 10, 12)), isTrue);
     expect(isNight(NightDayMode.automatic, DateTime(2026, 6, 10, 23)), isTrue);
     expect(isNight(NightDayMode.automatic, DateTime(2026, 6, 10, 12)), isFalse);
   });
 
-  testWidgets('Manual set while open fades, and holds through the hours', (tester) async {
+  testWidgets('Night set while open fades, and holds through the hours', (tester) async {
     var now = DateTime(2026, 6, 10, 12);
     await tester.pumpWidget(SoulDreamsApp(clock: () => now));
     expect(pageOf(tester), light);
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -81,7 +81,7 @@ void main() {
     });
   }
 
-  // C17-P filed every pending line; MP·98 and MP·99 (D125 item 9) are pending
+  // C17-P filed every pending line; MP·107 and MP·108 (D125 item 9; D161 item 1) are pending
   // again, on Life Context's consent page: SoulDreams Dev reaches them.
   test('SoulDreams Dev reaches the journal pages', () {
     final files = reached('lib/main_dev.dart');
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -579,10 +579,10 @@ void main() {
     expect(tester.widget<NightDayChoice>(find.byType(NightDayChoice)).mode.value, NightDayMode.automatic);
   });
 
-  // D57 Q15: a mode found at start is instant. Manual Night kept, Word
+  // D57 Q15: a mode found at start is instant. Night kept, Word
   // Animation on (the default), the hour's own theme light: the journal
   // opens dark with no five-second fade.
-  testWidgets('a Manual mode kept shows at once when the journal opens', (tester) async {
+  testWidgets('a Night mode kept shows at once when the journal opens', (tester) async {
     JournalStore.newQueueForTests();
     final files = answered(MemoryJournalFiles(), {Consent.readings: true});
     files.files[JournalStore.settingsFile] = encodeSettings(const Settings(nightDay: NightDayMode.night));
diff --git a/app/test/onboarding/onboarding_test.dart b/app/test/onboarding/onboarding_test.dart
--- a/app/test/onboarding/onboarding_test.dart
+++ b/app/test/onboarding/onboarding_test.dart
@@ -1,7 +1,7 @@
 // Onboarding (main-path.md, Onboarding; D103): the welcome, the note, the
 // age question, the under-18 card, and the disclosure's first layer on two
 // pages. The second ends with MP·58, which opens the full page, the text
-// only, with back; then EM·6 "I don't agree" left and MP·100 "I agree" right,
+// only, with back; then MP·109 "I don't agree" left (EM·6's words, D161 item 2) and MP·100 "I agree" right,
 // equal, neither chosen beforehand (D127 item 1): "I agree" gives the readings
 // and Life Context consents, "I don't agree" gives neither, a private journal.
 // Every word is the register's, or a pending line's; a part with no line shows
@@ -28,6 +28,9 @@ Finder said(Line line) => find.text(w(line));
 /// MP·100, a pending line: its handle here, its words in SoulDreams Dev only.
 Finder iAgree() => find.text(PendingLines.MP_100.text(appLanguage));
 
+/// MP·109, a pending line since C19-P retired EM·6 (D161 item 2).
+Finder iDont() => find.text(PendingLines.MP_109.text(appLanguage));
+
 /// The full page's own scrolling list.
 Finder full() => find.descendant(of: find.byType(DisclosurePage), matching: find.byType(Scrollable)).first;
 
@@ -151,16 +154,16 @@ void main() {
     for (final line in [Lines.MP_66, Lines.MP_67, Lines.MP_68, Lines.MP_69, Lines.MP_70, Lines.MP_30]) {
       expect(said(line), findsNothing, reason: line.handle);
     }
-    // The foot: EM·6 left, MP·100 right, side by side, below the page's words.
-    expect(said(Lines.EM_6), findsOneWidget);
+    // The foot: MP·109 left, MP·100 right, side by side, below the page's words.
+    expect(iDont(), findsOneWidget);
     expect(iAgree(), findsOneWidget);
-    expect(tester.getCenter(said(Lines.EM_6)).dy, closeTo(tester.getCenter(iAgree()).dy, 1));
-    expect(tester.getCenter(said(Lines.EM_6)).dx, lessThan(tester.getCenter(iAgree()).dx));
+    expect(tester.getCenter(iDont()).dy, closeTo(tester.getCenter(iAgree()).dy, 1));
+    expect(tester.getCenter(iDont()).dx, lessThan(tester.getCenter(iAgree()).dx));
     final ys = [for (final line in [Lines.MP_57, Lines.MP_58]) tester.getTopLeft(said(line)).dy];
     expect(ys, [...ys]..sort());
-    expect(tester.getTopLeft(said(Lines.EM_6)).dy, greaterThan(ys.last));
+    expect(tester.getTopLeft(iDont()).dy, greaterThan(ys.last));
     // Equal, neither chosen beforehand: the same kind of button, the same look.
-    final no = find.ancestor(of: said(Lines.EM_6), matching: find.byType(PlainButton)).first;
+    final no = find.ancestor(of: iDont(), matching: find.byType(PlainButton)).first;
     final yes = find.ancestor(of: iAgree(), matching: find.byType(PlainButton)).first;
     expect(tester.getSize(no).height, tester.getSize(yes).height);
     expect(tester.getSemantics(no).flagsCollection.isSelected, tester.getSemantics(yes).flagsCollection.isSelected);
@@ -173,9 +176,10 @@ void main() {
     await start(tester);
     await toFull(tester);
     expect(find.byType(TurnOnChoice), findsNothing);
-    for (final line in [Lines.MP_66, Lines.MP_68, Lines.MP_69, Lines.MP_30, Lines.EM_6]) {
+    for (final line in [Lines.MP_66, Lines.MP_68, Lines.MP_69, Lines.MP_30]) {
       expect(said(line), findsNothing, reason: line.handle);
     }
+    expect(iDont(), findsNothing);
     expect(iAgree(), findsNothing);
     expect(find.byType(BackControl), findsOneWidget);
     expect(agreed, 0);
@@ -354,8 +358,8 @@ void main() {
     await start(tester);
     await toDisclosure(tester);
     await tap(tester, Lines.MP_30);
-    await tester.tap(said(Lines.EM_6));
-    await tester.tap(said(Lines.EM_6));
+    await tester.tap(iDont());
+    await tester.tap(iDont());
     await tester.pumpAndSettle();
     expect(agreed, 1);
     expect(answers, {Consent.readings: false, Consent.lifeContext: false});
@@ -408,7 +412,7 @@ void main() {
     expect(tester.takeException(), isNull);
     // The foot's two buttons shrink their words to stay on one row.
     expect(iAgree(), findsOneWidget);
-    expect(said(Lines.EM_6), findsOneWidget);
+    expect(iDont(), findsOneWidget);
     await tap(tester, Lines.MP_58);
     expect(tester.takeException(), isNull);
   });
diff --git a/app/test/settings/consent_page_test.dart b/app/test/settings/consent_page_test.dart
--- a/app/test/settings/consent_page_test.dart
+++ b/app/test/settings/consent_page_test.dart
@@ -1,5 +1,5 @@
 // Life Context's own page, from Settings (D122; D125 item 9; D128): MP·69 over
-// Back on the left and Turn on on the right (MP·98, MP·99, pending lines);
+// Back on the left and Turn on on the right (MP·107, MP·108, pending lines);
 // only Turn on gives Life Context; Back and the back control give nothing.
 import 'dart:ui' show Tristate;
 
@@ -49,7 +49,7 @@ void main() {
     });
   }
 
-  // D125 item 9: Back on the left and Turn on on the right (MP·98 and MP·99:
+  // D125 item 9: Back on the left and Turn on on the right (MP·107 and MP·108:
   // pending lines, their words show in SoulDreams Dev only, a handle elsewhere
   // and in these tests). Equally prominent, neither chosen beforehand.
   testWidgets('Life Context: Back left, Turn on right, equally prominent', (tester) async {
@@ -62,8 +62,8 @@ void main() {
     await tester.pumpAndSettle();
     final back = find.byKey(TurnOnChoice.keyOf(false));
     final turnOn = find.byKey(TurnOnChoice.keyOf(true));
-    expect(find.descendant(of: back, matching: find.text(PendingLines.MP_98.text(appLanguage))), findsOneWidget);
-    expect(find.descendant(of: turnOn, matching: find.text(PendingLines.MP_99.text(appLanguage))), findsOneWidget);
+    expect(find.descendant(of: back, matching: find.text(PendingLines.MP_107.text(appLanguage))), findsOneWidget);
+    expect(find.descendant(of: turnOn, matching: find.text(PendingLines.MP_108.text(appLanguage))), findsOneWidget);
     expect(tester.getCenter(back).dy, tester.getCenter(turnOn).dy);
     expect(tester.getCenter(back).dx, lessThan(tester.getCenter(turnOn).dx));
     // Neither is filled beforehand: the same look, one size each.
@@ -76,11 +76,11 @@ void main() {
   });
 
   test('the two buttons: their words in Dev, handles elsewhere', () {
-    expect(PendingLines.MP_98.text(Lang.en, flavor: 'dev'), 'Back');
-    expect(PendingLines.MP_98.text(Lang.sv, flavor: 'dev'), 'Tillbaka');
-    expect(PendingLines.MP_99.text(Lang.en, flavor: 'dev'), 'Turn on');
-    expect(PendingLines.MP_99.text(Lang.sv, flavor: 'dev'), 'Slå på');
-    expect(PendingLines.MP_98.text(Lang.en, flavor: 'tester'), '[MP·98]');
-    expect(PendingLines.MP_99.text(Lang.en, flavor: 'founder'), '[MP·99]');
+    expect(PendingLines.MP_107.text(Lang.en, flavor: 'dev'), 'Back');
+    expect(PendingLines.MP_107.text(Lang.sv, flavor: 'dev'), 'Tillbaka');
+    expect(PendingLines.MP_108.text(Lang.en, flavor: 'dev'), 'Turn on');
+    expect(PendingLines.MP_108.text(Lang.sv, flavor: 'dev'), 'Slå på');
+    expect(PendingLines.MP_107.text(Lang.en, flavor: 'tester'), '[MP·107]');
+    expect(PendingLines.MP_108.text(Lang.en, flavor: 'founder'), '[MP·108]');
   });
 }
diff --git a/app/test/settings/setting_line_test.dart b/app/test/settings/setting_line_test.dart
--- a/app/test/settings/setting_line_test.dart
+++ b/app/test/settings/setting_line_test.dart
@@ -9,7 +9,7 @@ void main() {
   test('each setting line gives its name and choices, both languages', () {
     for (final (line, count) in [
       (Lines.MP_26, 2),
-      (Lines.MP_44, 2),
+      (Lines.MP_44, 3),
       (Lines.MP_83, 2),
       (Lines.MP_84, 4),
       (Lines.MP_85, 3),
diff --git a/app/test/settings/settings_page_test.dart b/app/test/settings/settings_page_test.dart
--- a/app/test/settings/settings_page_test.dart
+++ b/app/test/settings/settings_page_test.dart
@@ -201,26 +201,33 @@ void main() {
     expect(kept(JournalStore.settingsFile)['length'], 'threeMonths');
   });
 
-  // The stop's question 5: Manual keeps the theme on screen; the toggle
-  // switches it and sets Manual (Design System §6).
-  testWidgets('Night/Day: Manual keeps the theme; the toggle switches it', (tester) async {
+  // C19-P's MP·44 (D161 item 4): Automatic, Day or Night, three choices;
+  // the toggle switches the theme and sets Day or Night (Design System §6).
+  testWidgets('Night/Day: Day and Night set the theme; the toggle switches it', (tester) async {
     final c = await open(tester, hour: 12);
     Brightness now() => Theme.of(tester.element(find.byType(SettingsPage))).brightness;
+    await choose(tester, SettingRow.nightDay, 2);
+    expect(c.settings.nightDay, NightDayMode.night);
+    expect(shown(tester, SettingRow.nightDay), 'Night');
+    expect(now(), Brightness.dark);
     await choose(tester, SettingRow.nightDay, 1);
     expect(c.settings.nightDay, NightDayMode.day);
-    expect(shown(tester, SettingRow.nightDay), 'Manual');
+    expect(shown(tester, SettingRow.nightDay), 'Day');
+    expect(now(), Brightness.light);
     await hit(tester, find.byKey(SettingsPage.toggleKey));
     await tester.pumpAndSettle();
     expect(c.settings.nightDay, NightDayMode.night);
+    expect(shown(tester, SettingRow.nightDay), 'Night');
     expect(now(), Brightness.dark);
     await choose(tester, SettingRow.nightDay, 0);
     expect(c.settings.nightDay, NightDayMode.automatic);
+    expect(shown(tester, SettingRow.nightDay), 'Automatic');
     expect(now(), Brightness.light);
-    // Tapped while Automatic: Manual, the other theme.
+    // Tapped while Automatic: the other theme, as Night.
     await hit(tester, find.byKey(SettingsPage.toggleKey));
     await tester.pumpAndSettle();
     expect(c.settings.nightDay, NightDayMode.night);
-    expect(shown(tester, SettingRow.nightDay), 'Manual');
+    expect(shown(tester, SettingRow.nightDay), 'Night');
     expect(tester.getSemantics(find.byKey(SettingsPage.toggleKey)).label, en(Lines.MP_45));
     // It shows what it switches to (D125 item 7): the sun in the dark theme,
     // at the toggle's size; tapped, the day.
@@ -267,13 +274,20 @@ void main() {
     expect(Theme.of(tester.element(find.byType(SettingsPage))).brightness, Brightness.light);
   });
 
-  // Manual keeps the theme on screen, the dark one too.
-  testWidgets('Manual chosen in the dark theme keeps the dark', (tester) async {
+  // Day chosen at night turns the theme light, whatever the hour, and is
+  // kept; Night keeps the dark (D161 item 4).
+  testWidgets('Day chosen in the dark theme turns it light', (tester) async {
     final c = await open(tester, hour: 23);
+    Brightness now() => Theme.of(tester.element(find.byType(SettingsPage))).brightness;
+    expect(now(), Brightness.dark);
     await choose(tester, SettingRow.nightDay, 1);
+    expect(c.settings.nightDay, NightDayMode.day);
+    expect(kept(JournalStore.settingsFile)['nightDay'], 'day');
+    expect(now(), Brightness.light);
+    await choose(tester, SettingRow.nightDay, 2);
     expect(c.settings.nightDay, NightDayMode.night);
     expect(kept(JournalStore.settingsFile)['nightDay'], 'night');
-    expect(Theme.of(tester.element(find.byType(SettingsPage))).brightness, Brightness.dark);
+    expect(now(), Brightness.dark);
   });
 
   // D125 item 8: Night images asks nothing: any choice is a setting, kept as
@@ -320,7 +334,7 @@ void main() {
 
   // D127 item 1: after "I agree" both consents are given, so Life Context is
   // On; turning it Off asks nothing (D134), and turning it On again shows its
-  // page, Back and Turn on (MP·98, MP·99).
+  // page, Back and Turn on (MP·107, MP·108).
   testWidgets('Life Context On after I agree; Off, then On again', (tester) async {
     final c = await open(tester, given: const {Consent.readings: true, Consent.lifeContext: true});
     expect(shown(tester, SettingRow.lifeContext), 'On');
@@ -330,8 +344,8 @@ void main() {
     expect(shown(tester, SettingRow.lifeContext), 'Off');
     await choose(tester, SettingRow.lifeContext, 0);
     expect(find.byType(ConsentPage), findsOneWidget);
-    expect(find.text(PendingLines.MP_98.text(appLanguage)), findsOneWidget);
-    expect(find.text(PendingLines.MP_99.text(appLanguage)), findsOneWidget);
+    expect(find.text(PendingLines.MP_107.text(appLanguage)), findsOneWidget);
+    expect(find.text(PendingLines.MP_108.text(appLanguage)), findsOneWidget);
     await hit(tester, find.byKey(TurnOnChoice.keyOf(false)));
     await tester.pumpAndSettle();
     expect(c.consents.given(Consent.lifeContext), isFalse);
@@ -404,7 +418,7 @@ void main() {
     expect(find.byKey(SettingsPage.agreeKey), findsNothing);
     expect(find.text(en(Lines.MP_66)), findsNothing);
     expect(find.text(en(Lines.MP_30)), findsNothing);
-    expect(find.text(en(Lines.EM_6)), findsNothing);
+    expect(find.text(PendingLines.MP_109.text(appLanguage)), findsNothing);
   });
 
   // D110: one confirmation; then everything goes, back to the welcome.
diff --git a/app/test/words/shown_lines_test.dart b/app/test/words/shown_lines_test.dart
--- a/app/test/words/shown_lines_test.dart
+++ b/app/test/words/shown_lines_test.dart
@@ -1,7 +1,7 @@
 // No tester or founder build may show an unfilled braced sentence
 // (docs/Status.md, "Before Cohort 1" item 4; D119 item 2; D122, Q1 (B)). A
 // place "to rewrite" is built as written, and a sentence still owed in it
-// stays whole in braces (MP·68, MP·70). SoulDreams Dev shows them as filed
+// stays whole in braces (none since C19-P). SoulDreams Dev shows them as filed
 // (D122): this test fails the moment any file that main.dart or
 // main_founder.dart reaches (following imports, as dev_only_test.dart does)
 // names a place whose line holds a brace that is not one of the generator's
@@ -10,6 +10,7 @@ import 'dart:io';
 
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/words/lines.g.dart';
+import 'package:souldreams/words/pending.g.dart';
 
 import '../dev_only_test.dart' show reached;
 
@@ -57,16 +58,17 @@ void main() {
   });
 
   /// The places [names] holds whose line, in either language, has a brace
-  /// outside the slots.
-  List<String> bracedIn(Set<String> names) => [
-    for (final l in Lines.all.where((l) => names.contains(dartName(l))))
+  /// outside the slots, looked for in [lines], every filed line unless given.
+  List<String> bracedIn(Set<String> names, [Iterable<Line> lines = Lines.all]) => [
+    for (final l in lines.where((l) => names.contains(dartName(l))))
       if (Lang.values.any((lang) => l.parts(lang).any(braced))) l.handle,
   ];
 
-  // D128 item 4: the word "consent" is on no screen. One filed line still
-  // shown holds it, in Swedish only: EM·6 "Jag samtycker inte" (onboarding's
-  // "I don't agree"), for Product to reword (filed lines are not changed
-  // here). MP·67, MP·95 and MP·96 hold it too and are shown nowhere now.
+  // D128 item 4: the word "consent" is on no screen. No filed line shown
+  // holds it since C19-P retired EM·6; its words stand as the pending MP·109
+  // (D161 item 2), whose Swedish "Jag samtycker inte" holds it, for Product
+  // to reword. MP·67, MP·95 and MP·96 hold it too and are shown nowhere now,
+  // nor is C19-P's MP·98, the voice paused (D161 item 3).
   test('no shown line says consent, but the one named for Product', () {
     final word = RegExp('consent|samtycke', caseSensitive: false);
     final seen = named(reached('lib/main_dev.dart'));
@@ -74,9 +76,10 @@ void main() {
       for (final l in Lines.all)
         if (seen.contains(dartName(l)) && Lang.values.any((lang) => l.parts(lang).any(word.hasMatch))) l.handle,
     ];
-    expect(shown, ['EM·6']);
-    expect(Lines.EM_6.parts(Lang.en).any(word.hasMatch), isFalse);
-    for (final unshown in ['MP_67', 'MP_95', 'MP_96']) {
+    expect(shown, isEmpty);
+    expect(word.hasMatch(PendingLines.MP_109.text(Lang.sv, flavor: 'dev')), isTrue);
+    expect(word.hasMatch(PendingLines.MP_109.text(Lang.en, flavor: 'dev')), isFalse);
+    for (final unshown in ['MP_67', 'MP_95', 'MP_96', 'MP_98']) {
       expect(seen, isNot(contains(unshown)));
     }
   });
@@ -92,9 +95,12 @@ void main() {
     expect(seen, isNot(contains('MP_70')));
     expect(seen, isNot(contains('all')), reason: 'a screen reaching Lines.all would hide what it shows');
     expect(bracedIn(seen), isEmpty);
-    // No braced sentence is shown on any screen now; the helper itself is
-    // proved on the filed ones, MP·68 and MP·70 ("to rewrite"), by name.
-    expect(bracedIn({'MP_68', 'MP_70'}), ['MP·68', 'MP·70']);
+    // No braced sentence is shown on any screen, and none is filed since
+    // C19-P; the helper itself is proved on two made-up lines, by name.
+    const owed = Line('X·1', ['a {b}'], ['c']);
+    const slot = Line('X·2', ['a {n}'], ['c {n}']);
+    expect(bracedIn({'X_1', 'X_2'}, [owed, slot]), ['X·1']);
+    expect(bracedIn({'X_2'}, [owed, slot]), isEmpty);
     expect(bracedIn({'MP_11', 'MP_76'}), isEmpty);
   });
 
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A920, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A922, A480 dropped (c19p-import: no filed line holds a braced sentence since C19-P, so no build can reach one; the helper is proved on made-up lines, A545), A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -1998,7 +1998,7 @@ ROWS = [
      'style: TypeRoles.h6.style(NightArt.over)),',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
     ('A443', 'lib/onboarding/onboarding.dart',
-     'left: PlainButton(Lines.EM_6.text(appLanguage), onPressed: () => _decide(false)),',
+     'left: PlainButton(PendingLines.MP_109.text(appLanguage), onPressed: () => _decide(false)),',
      'left: PlainButton(Lines.MP_30.text(appLanguage), onPressed: () => _decide(false)),',
      'test/onboarding/onboarding_test.dart', "the second page ends with I don't agree and I agree"),
     ('A444', 'lib/journal/greeting.dart',
@@ -2148,10 +2148,6 @@ ROWS = [
      '          query: _search.text,\n',
      'test/journal/pages/journal_search_test.dart', 'a row opened with no search hands no query'),
     # D119 item 2 (the owner's addition): no shown line holds an unfilled braced sentence
-    ('A480', 'lib/main.dart',
-     "import 'core/safe_log.dart';\n",
-     "import 'core/safe_log.dart';\nconst _owed = Lines.MP_68;\n",
-     'test/words/shown_lines_test.dart', 'no tester or founder build shows a braced sentence'),
     ('A481', 'test/words/shown_lines_test.dart',
      "    rest = rest.replaceAll(slot, '');\n",
      '',
@@ -2311,7 +2307,7 @@ ROWS = [
     ('A522', 'lib/core/night_day.dart',
      '    widget.mode?.addListener(_modeChanged);\n',
      '',
-     'test/core/night_day_test.dart', 'Manual set while open fades, and holds through the hours'),
+     'test/core/night_day_test.dart', 'Night set while open fades, and holds through the hours'),
     ('A523', 'lib/core/night_day.dart',
      'return !wordAnimation || f.reduceMotion',
      'return f.reduceMotion',
@@ -2319,11 +2315,11 @@ ROWS = [
     ('A524', 'lib/core/night_day.dart',
      '  NightDayMode.day => false,',
      '  NightDayMode.day => isNightAt(local),',
-     'test/core/night_day_test.dart', 'Manual holds its theme whatever the hour'),
+     'test/core/night_day_test.dart', 'Day or Night holds its theme whatever the hour'),
     ('A525', 'lib/app.dart',
      '          mode: _mode,\n',
      '',
-     'test/core/night_day_test.dart', 'Manual set while open fades, and holds through the hours'),
+     'test/core/night_day_test.dart', 'Night set while open fades, and holds through the hours'),
     ('A528', 'lib/settings/settings_controller.dart',
      '      SafeLog.event(LogEvent.settingsKeepFailed);\n',
      '',
@@ -2371,11 +2367,11 @@ ROWS = [
     ('A547', 'lib/settings/settings_page.dart',
      '_dark ? NightDayMode.day : NightDayMode.night',
      'NightDayMode.night',
-     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
     ('A548', 'lib/settings/settings_page.dart',
-     '(_dark ? NightDayMode.night : NightDayMode.day)',
-     'NightDayMode.night',
-     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+     'nightDay: NightDayMode.values[i]',
+     'nightDay: NightDayMode.values[i == 1 ? 2 : i]',
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
     ('A555', 'lib/settings/settings_page.dart',
      'if (!await _confirm(Lines.C4_P_4, Lines.MP_60)) return;',
      '',
@@ -2403,7 +2399,7 @@ ROWS = [
     ('A562', 'lib/settings/settings_page.dart',
      'label: Lines.MP_45.text(appLanguage),',
      '',
-     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
     ('A563', 'lib/settings/settings_page.dart',
      '      builder: (_) => DisclosurePage(\n        end: [',
      '      builder: (_) => DisclosurePage(\n        shown: const [],\n        end: [',
@@ -2427,7 +2423,7 @@ ROWS = [
     ('A569', 'lib/journal/pages/sky_mark.dart',
      'SizedBox.fromSize(size: size,',
      'SizedBox.fromSize(size: StandIns.skyMark,',
-     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
     ('A570', 'lib/settings/settings_page.dart',
      '      value: choices[chosen],\n',
      '',
@@ -2435,15 +2431,15 @@ ROWS = [
     ('A571', 'lib/journal/pages/journal_home.dart',
      'instant: opening);',
      'instant: false);',
-     'test/journal/pages/journal_home_test.dart', 'a Manual mode kept shows at once when the journal opens'),
+     'test/journal/pages/journal_home_test.dart', 'a Night mode kept shows at once when the journal opens'),
     ('A572', 'lib/core/night_day.dart',
      'returning || (mode is NightDayModeNotifier && mode.instant)',
      'returning',
-     'test/journal/pages/journal_home_test.dart', 'a Manual mode kept shows at once when the journal opens'),
+     'test/journal/pages/journal_home_test.dart', 'a Night mode kept shows at once when the journal opens'),
     ('A573', 'lib/core/night_day.dart',
      '    } finally {\n      _instant = false;\n    }',
      '    } finally {\n    }',
-     'test/journal/pages/journal_home_test.dart', 'a Manual mode kept shows at once when the journal opens'),
+     'test/journal/pages/journal_home_test.dart', 'a Night mode kept shows at once when the journal opens'),
     ('A576', 'lib/settings/settings_page.dart',
      '    NightDayMode.night => true,\n',
      '    NightDayMode.night => false,\n',
@@ -2451,7 +2447,7 @@ ROWS = [
     ('A577', 'lib/settings/settings_page.dart',
      '    NightDayMode.day => false,\n',
      '    NightDayMode.day => true,\n',
-     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
     ('A579', 'lib/settings/settings_page.dart',
      '              isDestructiveAction: true,\n',
      '              isDestructiveAction: false,\n',
@@ -2492,19 +2488,19 @@ ROWS = [
     ('A603', 'lib/core/night_day.dart',
      '(chosen ? NightDay.quickFade : NightDay.fade)',
      '(chosen ? NightDay.fade : NightDay.quickFade)',
-     'test/core/night_day_test.dart', 'Manual set while open fades, and holds through the hours'),
+     'test/core/night_day_test.dart', 'Night set while open fades, and holds through the hours'),
     ('A604', 'lib/core/night_day.dart',
      '    widget.mode?.addListener(_modeChanged);\n',
      '    widget.mode?.addListener(_check);\n',
-     'test/core/night_day_test.dart', 'Manual set while open fades, and holds through the hours'),
+     'test/core/night_day_test.dart', 'Night set while open fades, and holds through the hours'),
     ('A605', 'lib/settings/settings_page.dart',
      'SkyMark(dark ? Sky.sun : Sky.moon,',
      'SkyMark(dark ? Sky.moon : Sky.sun,',
-     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
     ('A606', 'lib/settings/settings_page.dart',
      ', moon: DarkColours.page.colour',
      '',
-     'test/settings/settings_page_test.dart', 'Night/Day: Manual keeps the theme; the toggle switches it'),
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
     ('A607', 'lib/journal/pages/sky_mark.dart',
      'moon ?? (light ? DarkColours.page.colour! : StandIns.moonColour)',
      '(light ? DarkColours.page.colour! : StandIns.moonColour)',
@@ -2589,8 +2585,8 @@ ROWS = [
      '      const settings = Settings(images: NightImages.personal);\n      try {\n',
      'test/journal/journal_store_test.dart', 'no settings file beside version 2 with (c) given'),
     ('A636', 'lib/settings/consent_page.dart',
-     '      left: one(false, PendingLines.MP_98.text(appLanguage)),',
-     '      left: one(false, PendingLines.MP_99.text(appLanguage)),',
+     '      left: one(false, PendingLines.MP_107.text(appLanguage)),',
+     '      left: one(false, PendingLines.MP_108.text(appLanguage)),',
      'test/settings/consent_page_test.dart', 'Life Context: Back left, Turn on right, equally prominent'),
     ('A637', 'lib/settings/consent_page.dart',
      '_Choice(key: keyOf(given), text: text,',
@@ -2601,8 +2597,8 @@ ROWS = [
      'onTap: () => onChoose(!given));',
      'test/settings/consent_page_test.dart', 'the page answers true for yes'),
     ('A639', 'lib/onboarding/onboarding.dart',
-     'left: PlainButton(Lines.EM_6.text(appLanguage), onPressed: () => _decide(false)),',
-     'left: PlainButton(Lines.EM_6.text(appLanguage), onPressed: () => _decide(true)),',
+     'left: PlainButton(PendingLines.MP_109.text(appLanguage), onPressed: () => _decide(false)),',
+     'left: PlainButton(PendingLines.MP_109.text(appLanguage), onPressed: () => _decide(true)),',
      'test/onboarding/onboarding_test.dart', "I don't agree gives neither, told once"),
     ('A640', 'lib/onboarding/onboarding.dart',
      'onPressed: () => _decide(true)),\n    ),',
@@ -3746,6 +3742,15 @@ ROWS = [
      'settings ?? const Settings());',
      'settings ?? const Settings(images: NightImages.off));',
      'test/journal/pages/journal_home_test.dart', 'Night images is Personal by default'),
+    # c19p-import: MP·44's three choices, Automatic, Day and Night (C19-P; D161 item 4)
+    ('A921', 'lib/settings/settings_page.dart',
+     'Lines.MP_44, s.nightDay.index,',
+     'Lines.MP_44, s.nightDay == NightDayMode.day ? 2 : s.nightDay.index,',
+     'test/settings/settings_page_test.dart', 'Night/Day: Day and Night set the theme; the toggle switches it'),
+    ('A922', 'lib/settings/settings_page.dart',
+     'nightDay: NightDayMode.values[i]',
+     'nightDay: NightDayMode.values[i == 1 ? 0 : i]',
+     'test/settings/settings_page_test.dart', 'Day chosen in the dark theme turns it light'),
 ]
 
 
diff --git a/tool/checks/designgen.py b/tool/checks/designgen.py
--- a/tool/checks/designgen.py
+++ b/tool/checks/designgen.py
@@ -65,6 +65,10 @@ AS_ROLE = re.compile(r'^as color\.[a-z.]+: (.+)$')
 # C18-P: "as color.x", the value of a role above it in the same theme.
 AS_SAME = re.compile(r'^as (color\.[a-z.]+)$')
 AS_LIGHT = 'as in the light theme'
+# C19-P: "#hex, as in the light theme (a ruling): prose", a solid colour
+# that must be the light theme's own for the role; the rest is prose the
+# generator does not use, and holds no bracket.
+AS_LIGHT_SAID = re.compile('^' + HEXC + ', ' + AS_LIGHT + r' \([^()\[\]]+\): [^()\[\]]+$')
 SCALAR = re.compile(r'^(\d+)(?:, in both themes)?$')
 BOX = re.compile(r'^(\d+)px above and below, (\d+)px left and right$')
 SIDES = re.compile(r'^(\d+)px from the left edge, (\d+)px from the right$')
@@ -218,6 +222,12 @@ def read_colours(lines, heading, light=None):
             if light is None or role not in light:
                 raise DesignError('as-unknown', line)
             v, notes = light[role][0], [AS_LIGHT]
+        elif AS_LIGHT_SAID.match(value):
+            if light is None or role not in light:
+                raise DesignError('as-unknown', line)
+            v, notes = {'colour': AS_LIGHT_SAID.match(value).group(1)}, [AS_LIGHT]
+            if light[role][0] != v:
+                raise DesignError('as-differs', line)
         else:
             v, notes = colour_value(value, line)
         seen[role] = (v, notes)
diff --git a/tool/checks/tests/mutations.py b/tool/checks/tests/mutations.py
--- a/tool/checks/tests/mutations.py
+++ b/tool/checks/tests/mutations.py
@@ -254,6 +254,15 @@ MUTATIONS = [
      ['test_designgen.Generate.test_a_bracket_or_as_form_it_does_not_know_stops']),
     ('designgen.py', "        out.append(unset_comment(not_set))\n", "",
      ['test_designgen.Generate.test_a_bracketed_note']),
+    ('designgen.py', "            if light[role][0] != v:", "            if False:",
+     ['test_designgen.Generate.test_c19p_a_colour_said_as_light_must_be_it']),
+    ('designgen.py', "raise DesignError('as-unknown', line)\n            v, notes = {",
+     "pass\n            v, notes = {",
+     ['test_designgen.Generate.test_c19p_a_colour_said_as_light_must_be_it']),
+    ('designgen.py', "r' \\([^()\\[\\]]+\\): [^()\\[\\]]+$')", "r' \\(.+\\): .+$')",
+     ['test_designgen.Generate.test_c19p_a_colour_said_as_light_must_be_it']),
+    ('designgen.py', "        elif AS_LIGHT_SAID.match(value):", "        elif False:",
+     ['test_designgen.Generate.test_c19p_a_colour_said_as_in_the_light_theme']),
     ('wordsgen.py', "'composed (stand-in written)': True, 'to rewrite': True}",
      "'composed (stand-in written)': True}",
      ['test_wordsgen.Generator.test_to_rewrite_is_built_as_written']),
diff --git a/tool/checks/tests/test_designgen.py b/tool/checks/tests/test_designgen.py
--- a/tool/checks/tests/test_designgen.py
+++ b/tool/checks/tests/test_designgen.py
@@ -262,6 +262,27 @@ class Generate(unittest.TestCase):
         self.refused(doc(dark=[r('color.page', '#0F0D29'), r('color.box', 'as color.surface')]), 'as-unknown')
         self.refused(doc(light=LIGHT_ROWS + [r('color.page', '[to try: again]')]), 'role-repeated')
 
+    def test_c19p_a_colour_said_as_in_the_light_theme(self):
+        said = '%s, %s (ruled by a zebra): below the floor'
+        light = LIGHT_ROWS + [r('color.lc.delete', '#8F3D24')]
+        dark = DARK_ROWS + [r('color.lc.delete', said % ('#8F3D24', designgen.AS_LIGHT))]
+        t = text(doc(light=light, dark=dark))
+        dk = t[t.index('abstract final class DarkColours'):t.index('abstract final class Spacing')]
+        self.assertIn('static const lcDelete = ColourRole(colour: Color(0xFF8F3D24));', dk)
+        for word in ('zebra', 'floor'):
+            self.assertNotIn(word, t)
+
+    def test_c19p_a_colour_said_as_light_must_be_it(self):
+        said = '%s, %s (ruled by a zebra): below the floor'
+        light = LIGHT_ROWS + [r('color.lc.delete', '#8F3D24')]
+        other = [r('color.lc.delete', said % ('#D0775A', designgen.AS_LIGHT))]
+        self.refused(doc(light=light, dark=other), 'as-differs')
+        alone = [r('color.lc.delete', said % ('#8F3D24', designgen.AS_LIGHT))]
+        self.refused(doc(dark=alone), 'as-unknown')
+        for odd in ('%s, %s: below the floor', '%s, %s (a [zebra]): below', '%s, %s (ruled): below (it)'):
+            row = [r('color.lc.delete', odd % ('#8F3D24', designgen.AS_LIGHT))]
+            self.refused(doc(light=light, dark=row), 'colour-form')
+
     def test_refusal_names_the_line(self):
         data = doc(light=[r('color.page', '#F5F5EC'), r('color.odd', '#12')])
         line = data.decode('utf-8').split('\n').index(r('color.odd', '#12')) + 1
~~~~

### Task 2 · Settings: Language named in its own words (MP·99, C19-P)

Changed: `settings_page.dart` (`owedLanguage` gone, `languageName`), its test; rows A923 and A924 new, A559 follows.

Rows: `python3 -I -B tool/app_mutations.py --rows A559,A923,A924 | tail -1`, expected `app mutations: 3 run, 3 caught`.

Commit:

> Settings: Language shows MP·99's name for the app's language, English only (C19-P; D121 item 1)

~~~~diff
diff --git a/app/lib/settings/settings_page.dart b/app/lib/settings/settings_page.dart
--- a/app/lib/settings/settings_page.dart
+++ b/app/lib/settings/settings_page.dart
@@ -7,7 +7,7 @@
 // value pill, every pill one size and every row one height (D125 item 4),
 // the gap from a pill's right edge to its row's equal to the gap above and
 // below it (D128 item 6), opening the phone's menu: Language (EM·9; English
-// only, its name owed, D121 item 1), Word Animation (MP·26), Night images
+// only, D121 item 1, named in its own words, MP·99, C19-P), Word Animation (MP·26), Night images
 // (MP·85), Night/Day mode (MP·44: Automatic, Day or Night, C19-P), Life Context (MP·83) and Life Context
 // length (MP·84); then the row opening "What you've told Soul Dreams"
 // (MP·86, its flag; D121 item 2; D131), its name and a chevron; then "Read
@@ -52,9 +52,9 @@ import 'setting_line.dart';
 import 'settings.dart';
 import 'settings_controller.dart';
 
-/// The language's name, owed by Product: a visible placeholder (R1; the
-/// stop's question 4).
-const owedLanguage = '[owed·language]';
+/// [lang]'s name in its own language: MP·99 names them in [Lang]'s order,
+/// "English / Svenska", the same in both (C19-P).
+String languageName(Lang lang) => Lines.MP_99.parts(appLanguage)[lang.index];
 
 /// Which row a key names.
 enum SettingRow { language, wordAnimation, nightImages, nightDay, lifeContext, length }
@@ -272,7 +272,7 @@ class _SettingsPageState extends State<SettingsPage> {
               _Row(
                 row: SettingRow.language,
                 name: Lines.EM_9.text(appLanguage),
-                choices: const [owedLanguage],
+                choices: [languageName(appLanguage)],
                 chosen: 0,
                 onChoose: (_) {},
               ),
diff --git a/app/test/settings/settings_page_test.dart b/app/test/settings/settings_page_test.dart
--- a/app/test/settings/settings_page_test.dart
+++ b/app/test/settings/settings_page_test.dart
@@ -119,7 +119,9 @@ void main() {
     ];
     final ys = [for (final n in names) tester.getCenter(find.text(n)).dy];
     expect(ys, [...ys]..sort());
-    expect(shown(tester, SettingRow.language), owedLanguage);
+    // MP·99 names the language in its own words; English only (D121 item 1).
+    expect(shown(tester, SettingRow.language), 'English');
+    expect([for (final l in Lang.values) languageName(l)], Lines.MP_99.parts(Lang.sv));
     // Each pill is heard as its row's name, then its value.
     final pill = tester.getSemantics(find.byKey(SettingsPage.valueKey(SettingRow.wordAnimation)));
     expect([pill.label, pill.value], ['Word Animation', 'On']);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A922, A480 dropped (c19p-import: no filed line holds a braced sentence since C19-P, so no build can reach one; the helper is proved on made-up lines, A545), A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A924, A480 dropped (c19p-import: no filed line holds a braced sentence since C19-P, so no build can reach one; the helper is proved on made-up lines, A545), A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -2385,8 +2385,8 @@ ROWS = [
      'Lines.MP_85, 0, _nightImages),',
      'test/settings/settings_page_test.dart', 'Night images asks nothing: Personal by default, any choice at once'),
     ('A559', 'lib/settings/settings_page.dart',
-     'choices: const [owedLanguage],',
-     'choices: const [owedLanguage, owedLanguage],',
+     'choices: [languageName(appLanguage)],',
+     'choices: [languageName(appLanguage), languageName(appLanguage)],',
      'test/settings/settings_page_test.dart', "each row offers its line's choices; Language only English"),
     ('A560', 'lib/settings/settings_page.dart',
      'wordAnimation: i == 0',
@@ -3751,6 +3751,15 @@ ROWS = [
      'nightDay: NightDayMode.values[i]',
      'nightDay: NightDayMode.values[i == 1 ? 0 : i]',
      'test/settings/settings_page_test.dart', 'Day chosen in the dark theme turns it light'),
+    # c19p-import: the language named in its own words, MP·99 (C19-P)
+    ('A923', 'lib/settings/settings_page.dart',
+     'choices: [languageName(appLanguage)],',
+     'choices: [languageName(Lang.sv)],',
+     'test/settings/settings_page_test.dart', 'the page: its title, six rows, the kept row, the actions'),
+    ('A924', 'lib/settings/settings_page.dart',
+     'Lines.MP_99.parts(appLanguage)[lang.index]',
+     'Lines.MP_99.parts(appLanguage)[0]',
+     'test/settings/settings_page_test.dart', 'the page: its title, six rows, the kept row, the actions'),
 ]
 
 
~~~~

### Task 3 · The dark delete icon keeps #D0775A (D161 item 5)

Changed: the comments in `stand_ins.dart` and `palette.dart` say why; the test pins the kept value against the filed
one and is renamed (rows A733 to A735 follow); row A925 new.

Rows: `python3 -I -B tool/app_mutations.py --rows A733,A734,A735,A925 | tail -1`, expected `app mutations: 4 run,
4 caught`.

Commit:

> Life Context: the dark delete icon keeps #D0775A, not C19-P's #8F3D24 (1.45:1 on the dark box; D161 item 5)

~~~~diff
diff --git a/app/lib/design/palette.dart b/app/lib/design/palette.dart
--- a/app/lib/design/palette.dart
+++ b/app/lib/design/palette.dart
@@ -5,8 +5,8 @@
 // journal row's grey border is a stand-in from stand_ins.dart (D115). Life
 // Context's page (§2, §3, color.lifecontext.*): a kept sentence's box, its
 // words and its date; the light box's edge is the surface's (the founder's
-// screen), and the dark delete icon a stand-in, #D0775A, proposed by C18-P
-// and not yet approved; its list labels take color.tag.dream (a stand-in
+// screen), and the dark delete icon #D0775A, the founder's ruling against
+// C19-P's #8F3D24, which fails 3:1 on the dark box (D161 item 5; StandIns); its list labels take color.tag.dream (a stand-in
 // read from the founder's screen). Feedback's Submit takes
 // color.button.filled (C11-P; D152).
 import 'package:flutter/material.dart';
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -142,9 +142,11 @@ abstract final class StandIns {
 
   /// Life Context's page (D110; D131; the founder's screen, TO TRY): inside
   /// a kept sentence's box, the space between its words and its date, the
-  /// edit and delete icons and their tap boxes, and the dark theme's delete
-  /// icon, #D0775A, proposed by C18-P for the founder to approve (#8F3D24
-  /// fails on the dark box).
+  /// edit and delete icons and their tap boxes. The dark theme's delete icon
+  /// is #D0775A, the founder's ruling (D161 item 5), not C19-P's filed
+  /// #8F3D24 (`DarkColours.lifecontextDelete`): on the dark box #8F3D24 is
+  /// 1.45:1 and 2.02:1, below the 3:1 an icon needs (WCAG 2.2 SC 1.4.11);
+  /// #D0775A is 3.28:1 and 4.58:1 (design-system.md, §4). For Product.
   static const keptPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 14);
   static const double keptDateGap = 4;
   static const double keptIcon = 20;
diff --git a/app/test/life_context/life_context_page_test.dart b/app/test/life_context/life_context_page_test.dart
--- a/app/test/life_context/life_context_page_test.dart
+++ b/app/test/life_context/life_context_page_test.dart
@@ -176,14 +176,16 @@ void main() {
     expect(Palette.light.keptTop, LightColours.lifecontextBox.colour);
   });
 
-  testWidgets('the dark theme: the dark box, its date, the proposed delete', (tester) async {
+  testWidgets('the dark theme: the dark box, its date, the founder\'s delete', (tester) async {
     await open(tester, dark: true);
     final k = (await kept()).first;
     final icon = tester.widget<Icon>(
       find.descendant(of: find.byKey(LifeContextPage.deleteKey(k.id)), matching: find.byType(Icon)),
     );
+    // D161 item 5: the founder keeps #D0775A, not C19-P's filed #8F3D24.
     expect(icon.color, StandIns.keptDeleteDark);
     expect(StandIns.keptDeleteDark, const Color(0xFFD0775A));
+    expect(DarkColours.lifecontextDelete.colour, const Color(0xFF8F3D24));
     final date = find.descendant(
       of: find.byKey(LifeContextPage.sentenceKey(k.id)),
       matching: find.text(shownDate(k.day)),
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A924, A480 dropped (c19p-import: no filed line holds a braced sentence since C19-P, so no build can reach one; the helper is proved on made-up lines, A545), A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A925, A480 dropped (c19p-import: no filed line holds a braced sentence since C19-P, so no build can reach one; the helper is proved on made-up lines, A545), A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -2964,15 +2964,15 @@ ROWS = [
     ('A733', 'lib/design/palette.dart',
      '    keptDelete: StandIns.keptDeleteDark,',
      '    keptDelete: DarkColours.lifecontextDate.colour!,',
-     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the proposed delete'),
+     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the founder\'s delete'),
     ('A734', 'lib/design/palette.dart',
      '    keptDate: DarkColours.lifecontextDate.colour!,',
      '    keptDate: DarkColours.lifecontextText.colour!,',
-     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the proposed delete'),
+     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the founder\'s delete'),
     ('A735', 'lib/design/stand_ins.dart',
      'keptDeleteDark = Color(0xFFD0775A);',
      'keptDeleteDark = Color(0xFF8F3D24);',
-     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the proposed delete'),
+     'test/life_context/life_context_page_test.dart', 'the dark theme: the dark box, its date, the founder\'s delete'),
     ('A736', 'lib/settings/settings_page.dart',
      '    if (!_c.agreed) return showAgreementPopup(context);\n    await Navigator',
      '    await Navigator',
@@ -3760,6 +3760,11 @@ ROWS = [
      'Lines.MP_99.parts(appLanguage)[lang.index]',
      'Lines.MP_99.parts(appLanguage)[0]',
      'test/settings/settings_page_test.dart', 'the page: its title, six rows, the kept row, the actions'),
+    # c19p-import: the dark delete icon keeps #D0775A, not the filed #8F3D24 (D161 item 5)
+    ('A925', 'lib/design/palette.dart',
+     '    keptDelete: StandIns.keptDeleteDark,',
+     '    keptDelete: DarkColours.lifecontextDelete.colour!,',
+     'test/life_context/life_context_page_test.dart', "the dark theme: the dark box, its date, the founder's delete"),
 ]
 
 
~~~~

### Task 4 · Docs: Status.md

The current branch, the road ahead, the agreement and Settings entries, the waiting statuses, the design values,
Before Cohort 1 item 4, the pending lines, banked item 175 (for Product), the rulings (D161) and the documents as
last imported. Commit:

> Status.md: C19-P imported and reconciled (D161); readings-plumbing's merge recorded

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-25, in branch `readings-plumbing` (the readings with a stand-in model, part one: the reading, D155 to D160, head's message 34; built, deployed and checked by eye, both full mutation runs done; the merge, which is the owner's, next), by Claude Code.
+Last updated: 2026-11-25, in branch `c19p-import` (Product's C19-P imported and reconciled with the founder's D161; built; the owner's by-eye check, then the full mutation run, D126), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,6 +14,16 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
+`c19p-import` (D161; plan `docs/plans/c19p-import.md`): Product's C19-P (the register, the Design System, Product's
+record) imported and reconciled with the founder's rulings. The pending Back and Turn on are MP·107 and MP·108, and
+"I don't agree" is the pending MP·109, EM·6's last filed words, EM·6 being retired at C19-P (D161 items 1 and 2);
+C19-P's MP·98 (the voice paused) is shown nowhere (D161 item 3); Night/Day mode offers Automatic, Day and Night,
+the quick toggle setting Day or Night (D161 item 4); Language shows MP·99's "English"; the dark delete icon keeps
+#D0775A against the filed #8F3D24 (D161 item 5). The rest of C19-P is words only: W27·2, W27·6 (shown in the
+disclosure), MP·66 to rewrite, MP·67, MP·68, MP·70 (shown nowhere) and MP·71 (as shown); the design values add
+the dark `color.lifecontext.delete`, which nothing shows. `readings-plumbing` part one is merged (`main` at
+`c72fca2`).
+
 `readings-plumbing`, part one: the reading (head's message 33; D155; plan `docs/plans/readings-plumbing.md`). In
 SoulDreams Dev, Start Interpretation on a night's page sends the night (its language, its dreams in words and, only
 while Life Context is On, the sentences it keeps, D134) to our server's `POST /reading` with the beta key; the server
@@ -49,11 +59,9 @@ merge (this entry records it).
 
 ## Road ahead
 
-- `readings-plumbing`, part one: the storage rehearsal (Task 3), the deploy (Task 8) and the by-eye check (Task 9)
-  passed (owner, 2026-11-25) and the full mutation runs are done (D126); the merge is the owner's. The C19-P import
-  (the design system, the product change record, the register) is not on this branch (D159): it waits for its own
-  branch. Before the merged build reaches the Cohort 0 app, the owner's safety export (docs/workflow.md (c) item 4).
-  Before the merged build reaches the Cohort 0 app, the owner's safety export (docs/workflow.md (c) item 4).
+- `c19p-import`: the owner's by-eye check (plan Task 5), the full mutation run (D126), then the merge, the owner's.
+  It changes no storage. Before `readings-plumbing`'s merged build reaches the Cohort 0 app, the owner's safety
+  export (docs/workflow.md (c) item 4).
 - `readings-plumbing`, part two: the painting (D143, D145, D146, D123; D155 items 1 and 3): its plan after part one's
   merge.
 - `life-context` (merged): the owner's by-eye review passed (plan Task 7, with D133 and D134; VoiceOver waits for
@@ -289,13 +297,15 @@ merge (this entry records it).
   stops the generator (`pending-filed`). Since C17-P none is pending: the file holds its header only, and nothing in
   `lib/` imports `pending.g.dart` (a test in `test/words/` keeps the Dev-only rule proved on a line built there).
 - Waiting statuses (D109): "English written, Swedish to write" (W12, W13) has no line, as "to write"; the readings
-  branch revisits them. "to rewrite" (D119) is built as written, a stand-in, until rewritten (W27·2, W27·6, MP·68,
-  MP·70, C125-I·3); a sentence still owed, whole in braces with a capital (MP·68, MP·70), shows as written.
+  branch revisits them. "to rewrite" (D119) is built as written, a stand-in, until rewritten (MP·66 and C125-I·3
+  since C19-P); a sentence still owed, whole in braces, would show as written: none is filed since C19-P.
 - Design values: `Spacing.pageSide` (30) and `Spacing.journalRow` (12) are filed at C17-P and replace the stand-ins
   `StandIns.pageSide` and `rowGap` (the same values). §5's second table, the controls, is prose and not generated.
   At C18-P (D118): `TypeRoles.rowDate` (Inter SemiBold 20) carries a row's date; a line or letter "[to set in
   Framer]" is null, the font's own; a colour "[to try ...]" or "[proposed ...]" has no constant
-  (`color.label.questions`, the dark `color.lifecontext.delete`), one "[owed: ...]" keeps its value.
+  (`color.label.questions`), one "[owed: ...]" keeps its value. At C19-P: "#hex, as in the light theme (a ruling):
+  prose" is read as the light value, and stops the generator if it differs (`as-differs`); the dark
+  `color.lifecontext.delete` is #8F3D24 there, and the app keeps #D0775A (D161 item 5; `StandIns.keptDeleteDark`).
 - The journal's greeting (C18-P; D119 item 4): MP·72 to MP·75 by the part of the day, from 05:00, 11:00, 17:00
   and 21:00, one line of the part's four a day, in turn; a night after midnight keeps the line of the evening it
   began on (the day counted under D91). New Dream is MP·11; a read night's jump buttons are MP·77's four parts.
@@ -314,8 +324,8 @@ merge (this entry records it).
   goes. The query is never kept or logged (R3).
 - The agreement (C159-I item 5; D110; D121; D122; D125 items 2 and 8; D127 item 1; D128; `redesign-c`;
   `app/lib/settings/`, SoulDreams Dev only). Onboarding's second page ends with the disclosure parts, MP·58
-  ("Read everything", optional, opening the full disclosure page, the text only, with back), then at the foot EM·6
-  "I don't agree" left and MP·100 "I agree" right (a pending line), equal, neither chosen beforehand. "I agree"
+  ("Read everything", optional, opening the full disclosure page, the text only, with back), then at the foot MP·109
+  "I don't agree" left (a pending line, EM·6's last filed words, D161 item 2) and MP·100 "I agree" right (a pending line), equal, neither chosen beforehand. "I agree"
   accepts the disclosure and gives the readings (a) and Life Context (b) together, so Life Context is On from
   then; "I don't agree" gives neither and the journal opens as a private journal. D127 amends MP·83's "never on
   before consent" and C159-I's separate consents; the Build chat carries it to the head. There is no withdrawing
@@ -331,7 +341,8 @@ merge (this entry records it).
   Disclosure & privacy page from Settings is then the text with one button at its end, MP·100, which gives both
   consents (`SettingsController.agree`), starts the recording and the retries, and goes; once agreed the page has
   no button. MP·66, MP·67, MP·68, MP·70, MP·95 to MP·97 and MP·9 are shown nowhere now. The word "consent" is on no
-  screen but one line: EM·6's Swedish, "Jag samtycker inte" (banked item 164). Night images has no consent: Personal
+  screen but one line: the pending MP·109's Swedish, "Jag samtycker inte" (banked item 164; D161 item 2).
+  C19-P's MP·98 (the voice paused until consent) is shown nowhere: the microphone stays, with the popup (D161 item 3). Night images has no consent: Personal
   by default (D160: in a fresh journal and after Delete journal, with "I agree" or not), a read night its painting;
   Off, one tap away in Settings, shows every night the gradient (`lookOf`'s `images`); Personal and Random keep
   D110's look until the personal painting exists (D121 item 3).
@@ -340,12 +351,12 @@ merge (this entry records it).
   rows end (three drawn sliders in place of the gear, 41 in a 44 tap box, its own semantics node, spoken MP·25; the
   sky mark stays 140 down). The page: the back control, the quick toggle top centre (MP·45), which shows what it
   switches to, a moon in the light theme drawn in the dark page colour and a sun in the dark, switches the theme in
-  half a second and sets Manual (the 5 s fade stays for the clock's 21:00 and 08:00, `NightDay.fade`; a change the
+  half a second and sets Day or Night (D161 item 4; the 5 s fade stays for the clock's 21:00 and 08:00, `NightDay.fade`; a change the
   dreamer makes takes `NightDay.quickFade`); MP·25 in h2; six rows of one height, each a white rounded row with a
   value pill, all one width, its border the row's grey, the gap from its right edge to the row's equal to the gap above
   and below it (D128 item 6; inside it the value and its chevron are centred, as before D127), opening the phone's
-  menu: Language (EM·9, `[owed·language]`, one choice), Word Animation (MP·26), Night images (MP·85), Night/Day mode (MP·44; Manual keeps
-  the theme shown), Life Context (MP·83), Life Context length (MP·84); then MP·48 (the full disclosure) and
+  menu: Language (EM·9, MP·99's "English", one choice), Word Animation (MP·26), Night images (MP·85), Night/Day mode (MP·44:
+  Automatic, Day or Night, C19-P; D161 item 4), Life Context (MP·83), Life Context length (MP·84); then MP·48 (the full disclosure) and
   Delete journal (EM·11, `color.destructive`); no Give or Withdraw row (D128 item 2). Life Context On shows its
   page (`ConsentPage`), Off asks nothing (D134), and before the dreamer has agreed either shows the popup instead;
   Night images asks nothing; Delete journal asks C4-P·4 once, then everything goes and onboarding starts again. The setting lines are read by
@@ -1207,6 +1218,20 @@ Banked in image-trial (D91; nothing a dreamer sees changes):
      and the store-level version 2 test holds no waiting recording; (l) a lone surrogate in a reading's text comes
      back as U+FFFD, as dreams' do.
 
+Banked in c19p-import (D91; for Product, through the head; nothing a dreamer sees changes beyond D161):
+
+175. For Product (D161): (a) the pending handles: C19-P filed MP·98 and MP·99 over the two the pending lines held,
+     so Back and Turn on are now MP·107 and MP·108, and the founder keeps EM·6's "I don't agree" as MP·109; Product
+     to file all ten pending lines (MP·100 to MP·109) under handles it confirms; (b) EM·6's retirement and the
+     consent page's "Next alone" do not stand in the app: onboarding's foot is "I don't agree" / "I agree" (D127,
+     D128; D161 item 2); (c) C19-P's MP·98 is not shown: the microphone stays, a tap before "I agree" shows the
+     popup MP·101 (D128; D161 item 3), so MP·66 and MP·68's flags (refusing (a) pauses the voice) describe a screen
+     the app does not have; (d) the dark delete icon stays #D0775A, against C19-P item 6's #8F3D24, which is 1.45:1
+     and 2.02:1 on the dark surface where an icon needs 3:1 (D161 item 5): a filing to match, or the founder's look
+     on his phone; (e) MP·99 is read as one name per language, in the order English, Svenska, and Language shows
+     the app's own (English only, D121 item 1); (f) the word "consent" is still on one screen, MP·109's Swedish
+     (banked item 164).
+
 ## Before Cohort 1
 
 1. No tester build while `app/assets/words/pending-lines.csv` holds any line (the owner's ruling on Task 2's review,
@@ -1216,8 +1241,8 @@ Banked in image-trial (D91; nothing a dreamer sees changes):
    line: none since C17-P (D106 3). `Onboarding.missing` lists them (every part shown, MP·57 included), and a test in
    `dev_only_test.dart` fails if either entry point reaches `lib/onboarding/` while it is not empty.
 4. No tester or founder build may show an unfilled braced sentence (D119 item 2: a place "to rewrite" is built as
-   written, and a sentence still owed in it stays whole in braces, as MP·68 and MP·70 do). SoulDreams Dev shows both
-   in the three consents, as filed (D122, Q1 (B)). `test/words/shown_lines_test.dart` fails if any file that
+   written, and a sentence still owed in it stays whole in braces, as MP·68 and MP·70 did until C19-P). None is filed since C19-P
+   (D122, Q1 (B)). `test/words/shown_lines_test.dart` fails if any file that
    `main.dart` or `main_founder.dart` reaches (following imports, as `dev_only_test.dart` does) names a place whose
    line, in either language, holds a `{` or `}` that is not one of the four slots (`{n}`, `{pointed image}`,
    `{tradition}`, `{read image}`). Onboarding reaches neither app until a later ruling (D103 item 1).
@@ -1252,9 +1277,10 @@ message 20 and built in `journal-design`, except the night's page's field in 10,
 
 Lines given and approved, shown in SoulDreams Dev only until Product registers them (D58 Q11):
 
-- MP·98 "Back" / "Tillbaka" and MP·99 "Turn on" / "Slå på", on Life Context's consent page in Settings (the
+- MP·107 "Back" / "Tillbaka" and MP·108 "Turn on" / "Slå på", on Life Context's consent page in Settings (the
   founder, 2026-11-22, D125 item 9; the owner wrote them in `pending-lines.csv`; handles proposed to Product, banked
-  item 162); MP·100 "I agree" / "Jag godkänner", on onboarding's second page and at the end of Settings' Disclosure & privacy page (D127 item 1; D128 item 3; banked item 163); MP·101 (the popup's words) and MP·102 "OK" / "OK" (D128 item 3; banked item 164); MP·103 "Done" / "Klar" (the tick that ends selecting on Life Context's page) and MP·104 (the line shown there while Life Context is Off) (the founder, D133; handles proposed to Product). MP·105 (Feedback, a send that failed) and MP·106 (Feedback, a send that worked), added to `pending-lines.csv` by the owner (D153; D152 item 4; plan `docs/plans/feedback.md`, Part 4; handles proposed to Product). MP·60 to MP·65 were filed at C17-P, word for word as pending (checked in `c17p-import`).
+  item 162; first MP·98 and MP·99, renumbered when C19-P filed those handles, D161 item 1); MP·109 "I don't
+  agree" / "Jag samtycker inte", onboarding's decline, EM·6's last filed words (D161 item 2; banked item 175); MP·100 "I agree" / "Jag godkänner", on onboarding's second page and at the end of Settings' Disclosure & privacy page (D127 item 1; D128 item 3; banked item 163); MP·101 (the popup's words) and MP·102 "OK" / "OK" (D128 item 3; banked item 164); MP·103 "Done" / "Klar" (the tick that ends selecting on Life Context's page) and MP·104 (the line shown there while Life Context is Off) (the founder, D133; handles proposed to Product). MP·105 (Feedback, a send that failed) and MP·106 (Feedback, a send that worked), added to `pending-lines.csv` by the owner (D153; D152 item 4; plan `docs/plans/feedback.md`, Part 4; handles proposed to Product). MP·60 to MP·65 were filed at C17-P, word for word as pending (checked in `c17p-import`).
 
 ## Rulings during branch 2
 
@@ -1888,21 +1914,36 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   A916 to A918, A877 repointed; `3cc84a1`); the server's limit in characters and a reading's text a string (rows S179,
   S180; `ac5a949`). Row A890 sits in Task 5's block but breaks Task 6's code, so it is caught only from Task 6 on.
 
+## Rulings during c19p-import
+
+- D161 (founder; the owner's brief for this branch): (1) the pending MP·98 "Back" and MP·99 "Turn on" move to the
+  next handles above C19-P's highest, MP·107 and MP·108, by one owner's paste that renames, re-fingerprints and
+  regenerates; MP·100 to MP·106 do not clash; (2) EM·6, retired at C19-P, keeps its last filed words as the pending
+  MP·109 (D127, D128); (3) C19-P's MP·98 (the voice paused "until you give consent") is not shown: D128 keeps the
+  microphone and the MP·101 popup; (4) Night/Day mode adopts MP·44's Automatic, Day and Night as three choices;
+  the quick toggle stays; (5) the dark delete icon keeps #D0775A: C19-P's #8F3D24 is 1.45:1 on the dark surface;
+  every other change adopted, or a question where it contradicts a founder ruling. D91 and D126 apply; the owner
+  checks by eye only.
+- The design generator reads C19-P's "#hex, as in the light theme (...): ..." (rows in `tool/checks/tests/
+  mutations.py`, 108 now; 287 guard tests). Row A480 dropped (no filed braced line to reach; the helper is proved on
+  made-up lines, A545); rows A921 to A925 new; four tests renamed from "Manual" (their rows follow). App 837 tests.
+
 ## Documents as last imported
 
-Imported by the owner at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
+Imported by the owner in branch `c19p-import` (C19-P: the register, the Design System and Product's record);
+before it, at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
 others unchanged since C17-P's import (`d8d71c3`, branch `c17p-import`). The ordinal
 is the owning department's filing. Each line: path, ordinal, first 12 hex digits of the sha256, as in
 `docs/source/SOURCES`.
 
 - `app/assets/words/founder-lists-for-technology.md`, C13-P, `4326cfcc5cb8`
-- `app/assets/words/places-register.csv`, C18-P, `cd523e7d6959`
-- `docs/source/design-system.md`, C18-P, `1c41ff6b3b92`
+- `app/assets/words/places-register.csv`, C19-P, `013289928989`
+- `docs/source/design-system.md`, C19-P, `1a07ffc3c3fb`
 - `docs/source/experience-map.md`, C16-P, `3c8878f6f03b`
 - `docs/source/how-the-ai-appears.md`, C17-P, `80618ad95378`
 - `docs/source/interpretation-change-record.md`, C160-I, `57644c167efb`
 - `docs/source/main-path.md`, C16-P, `6d503665ef9e`
-- `docs/source/product-change-record.md`, C18-P, `2ff467173047`
+- `docs/source/product-change-record.md`, C19-P, `505abf1c8ae1`
 - `docs/source/product-principles.md`, C16-P, `1f8992a7ec51`
 - `docs/source/requirements-list.md`, C11-P, `22f742c740ab`
 - `docs/source/technical-answers.md`, C5-T, `c6b1d05a56a0`
~~~~

### Task 5 · [OWNER] The by-eye check, SoulDreams Dev, invented nights only

On the simulator or the owner's phone, a fresh SoulDreams Dev (Delete journal first if it holds anything). Not the
Cohort 0 app.

1. Onboarding to its second page: at the foot, "I don't agree" left and "I agree" right, equal, as before.
   Tap "I don't agree": the journal opens.
2. Tap the microphone: the popup ("To use this, go to Settings…") with OK; no line saying recording by voice is
   paused, there or anywhere.
3. Settings → Read disclosure & privacy: the page ends with "I agree"; tap it. Reading the page, W27·2 begins
   "A night's words leave your phone only to be read or, if you choose, to paint its image." and W27·6 begins
   "Apart from what is read, painted and recorded".
4. Settings: Language's pill reads "English"; its menu offers English only.
5. Night/Day mode: the menu offers Automatic, Day, Night. Night: the theme goes dark and the pill says Night. Day:
   light, Day. Automatic: the theme follows the clock (dark from 21:00 to 08:00). With Automatic on, tap the sun/moon
   toggle: the theme switches in half a second and the pill reads Day or Night accordingly. Close and reopen the app:
   the choice is kept.
6. Life Context row: Off, then On: its page with Back and Turn on; Back changes nothing; Turn on turns it on.
7. In Night: What you've told Soul Dreams: each kept sentence's delete icon is the light terracotta, as before.
8. A read night (any invented one): "Made by AI" under each reading, nothing on the painting.

Bring back: each item passed, or what differs.

### Task 6 · The full mutation run (D126), after Task 5 passes

```
python3 -I -B tool/app_mutations.py | tail -1
```

Expected: `app mutations: 863 run, 863 caught` (859 at `d6f6861`, with A921 to A925 new and A480 dropped). No server
file changed, so no server run. Then the merge, the owner's.

## Part 4 · Questions (numbered; a blank is not a yes)

None blocks a task. D161 settles every C19-P change that contradicts an earlier founder ruling, and the rest is
adopted.

1. Status.md records the import without the documents repository's commit (the import's output did not reach this
   session). Lean: give the commit from the import's output and Task 4's Status line names it; or leave it out.

## Part 5 · How this plan was proven

In `.scratch/c19/`: the owner's working tree copied (tracked files and the import), snapshot `s0`; Task 1a's paste
run there (`s1`: ten pending lines, fingerprint `b93f255b…`, the generator's five files); each task built in turn
(`s3` to `s6`), the blocks made from the snapshots with `git diff --no-index`. The blocks were replayed on a clean
copy of `s1`, each task's tests applied first: Task 1 alone, 3 analyzer issues and 9 failing tests; whole, `No
issues found!`, `+837`; Task 2 alone, 1 failing; whole, `+837`; Task 3 alone and whole, `+837`; Task 4 applied. The
replay matched the build byte for byte (only the harness's `.claude` folder differs). On it: `designgen: up to
date`, `wordsgen: up to date`, `guards (walk): all passed` (on the snapshot without build output), the guard tests
287 run (one, `test_check_all.CheckAll`, cannot start outside a git repository, as on the untouched copy: the
owner's `check_all.sh` runs it), the designgen rows `22 run, all caught`, and the app rows of every changed file
`104 run, 104 caught`. The baseline before any change was `+837` and 285 guard tests.

What the sandbox cannot prove: the hook and `check_all.sh` in the real repository (the owner's merge command runs
them), and the screens (Task 5).

## Part 6 · For the head: what goes to Product

1. **The pending handles.** C19-P filed MP·98 and MP·99 over the two the pending lines held (proposed to Product,
   banked item 162). Back and Turn on are now MP·107 and MP·108 (D161 item 1). Ten pending lines wait for filing,
   MP·100 to MP·109, under handles Product confirms.
2. **EM·6.** The founder keeps "I don't agree" (D127, D128): EM·6's last filed words stand as the pending MP·109
   (D161 item 2). C19-P item 5's consent page ("Next alone, centred") does not exist in the app: onboarding asks no
   separate consents and ends with "I don't agree" / "I agree".
3. **MP·98, the voice paused.** Not shown (D161 item 3): the microphone stays visible and a tap before "I agree"
   shows the popup MP·101. MP·66's and MP·68's flags (refusing (a) pauses the voice) describe a screen the app does
   not have. The main-path and handover passes C19-P lists should name D128's flow instead.
4. **The dark delete icon.** #D0775A, not #8F3D24 (D161 item 5): #8F3D24 is 1.45:1 and 2.02:1 on the dark surface,
   under the 3:1 an icon needs. The Design System's dark `color.lifecontext.delete` should be filed as #D0775A, or
   the founder's ruling recorded there.
5. **MP·99.** Read as one name per language in the order English, Svenska; Language shows the app's own, English
   only (D121 item 1). If Product means otherwise (both names in the menu, Svenska unselectable), it says so.
6. **MP·44.** Adopted: Automatic, Day, Night. The quick toggle sets Day or Night (D161 item 4); main-path.md's
   Settings still names Manual (C19-P item 4 already lists it).
7. **The word "consent"** is still on one screen: MP·109's Swedish, "Jag samtycker inte" (banked item 164).
