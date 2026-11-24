# Plan: the curated set of night paintings (curated-set)

Branch `curated-set`, from `main` at `a8d0099`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and
6), under D91 and D126. Written by Claude Code (Opus) on 2026-11-23. Governs: the owner's D147 (the brainstorm), with
D145 (Black Forest Labs' `flux-2-klein-4b` on the EU endpoint), D146 (the original style, `STYLE` in
`server/trial/measure.ts`, the one constant), D123 (no visible AI mark; the invisible machine-readable tag on every
shipped image), D110 and D121 item 3 (a read night's painting from the set, chosen from its id alone), D112 (New
Dream's night sky) and D113 (the date's soft shade). The owner's checks are by eye only.

Status.md's first line still names `image-trial` ("the owner's AWS tasks next"): it was not updated after D142 to
D146, though its rulings list holds them up to D146, the last the owner names, and `main` is this branch's start.
Explained, so not a stop; Task 7 corrects the line.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

The five placeholder paintings drawn in code give way to the real set: sixty paintings of invented scenery and a
night-sky strip for New Dream, made once on the owner's Mac with the model the founder chose, in the style he kept,
looked at by the owner on one contact sheet, any he rejects painted again, then shipped inside the app. Nothing is
generated on a phone and nothing is fetched: the app talks to nothing new.

What changes for the dreamer, in SoulDreams Dev built with `PREVIEW_READ=true` (no night is read yet anywhere else):
- **A read night's row and header** show one of the sixty paintings instead of a placeholder, chosen from the
  night's id exactly as now (`paintingFor`, the id's first 32 bits modulo 60). A row shows a thin band through the
  painting's middle; the header a wide crop of it. The date keeps its soft shade (D113).
- **New Dream** stands on the set's night-sky strip instead of the code-drawn stars. The sun and the moon above the
  greeting stay drawn in code (D147 item 3).
- **New Dream's words** stand on the same soft shade as a date over a painting (D113), a stand-in, so they read at
  4.5 to 1 over the stars (Part 4, question 3).
- **An unread night** keeps the painted gradient, and so does every night while Night images is Off (D121 item 3).
- The gradient lies beneath each painting, so a row never flashes empty while its painting loads.

What the owner does (Tasks 3, 4, 5 and 8): a free proof of the JPEG step, the painting run (about six minutes, about
USD 0.85 to 0.92), the contact sheet and any repaints (each about 1.5 US cents, under the USD 3 cap), the copy into the app,
and the by-eye check in SoulDreams Dev.

### What this branch builds

1. **G0 and G2 know the paintings** (Task 1): every file in `app/assets/paintings/` is listed in its
   `fingerprints.txt` with its sha256, which G2 proves, armed or not, as it does the fonts and the screenshots; G0
   knows that one `.txt` by exact path. A painting is binary, which G0 already knows.
2. **The painter** (Task 2), `server/trial/curated.ts`, beside the BFL test it reuses, on the owner's Mac only:
   - `paint <folder>`: the sixty scenes and the sky, in order, one request each to `flux-2-klein-4b` on
     `api.eu.bfl.ai`: 1280 x 960 (D148; the sky 1200 x 336), a seed of its own, PNG. A stopped run goes on from where
     it stopped.
   - Each PNG is made a JPEG of quality 75 (D148) with the sRGB profile (embedded by our own code, Part 6 A1) by
     macOS's own `sips`, given the AI tag by our own
     code (`server/trial/jpeg.ts`: an XMP packet naming the IPTC digital source type
     `trainedAlgorithmicMedia`, in an APP1 segment), and checked: its size, the sRGB profile and the tag. Saved as
     `NN-<attempt>.jpg`.
   - `repaint <folder> <n or sky>...`: those painted again from the same scene with the next seed; the earlier
     image is kept.
   - **The cap**: before each request 3 credits (USD 0.03, twice the expected price) are counted, and the request is
     not sent if that could pass 300 credits (USD 3); after it, the credits BFL's own reply names replace them. A
     reply naming no cost, or more than 3, stops. A request that fails keeps its 3 counted. All of it in `set.json`.
   - After every run: `set.md` (painted, painted again, credits counted) and `sheet.html`, the contact sheet: each
     item's last attempt whole, with its row crop (330 x 64) and header crop (390 x 287) beneath, and the sky in a
     pill.
   - `proof <folder> <png>`: one PNG through the same JPEG, tag and check, with no request (Task 3).
   - `ship <folder> <app/assets/paintings>`: each item's last attempt, checked again, copied as `01.jpg` to `60.jpg`
     and `sky.jpg`, and `fingerprints.txt` written as `shasum -a 256` writes it. Refused unless every item is
     painted, and unless the folder holds nothing else.
   - The sixty scenes (`server/trial/scenes.ts`), written by Claude Code under D147 item 1: landscape, sky, weather,
     season, light and mood only, no person, no text, nothing from any dream, each under twelve words (G4). Each
     prompt is the scene, then `wide view, the subject across the middle band, no text`, then the style (D146).
     The sky's: `a deep blue night sky of small soft stars, no moon`, then the style. They are listed in Part 3,
     Task 2's block (`scenes.ts`), for the owner to read before Task 4.
3. **The app uses the set** (Task 6, after the owner's Tasks 3 to 5 have put the set in `app/assets/paintings/`):
   `NightArt` shows painting *n* from `assets/paintings/NN.jpg`, covering its box from the middle, decoded no wider
   than the box on that screen, silent to screen readers, over the gradient; `NightSky` shows `sky.jpg` the same way;
   New Dream's words on the date's shade; the pubspec bundles the folder. The count is 60.
4. **Status.md** (Task 7).

### What it does not build

- No painting made on the phone or by the server, and no per-night personal painting (a later branch; D121 item 3).
- No sun or moon image (D147 item 3).
- No visible AI mark (D123).
- No change to how a painting is chosen (`night_look.dart` unchanged), to storage, to Settings, or to the server's
  own stack. No new package, app or server.

### The decisions, by number

- D147 (1): sixty scenes written here; the owner rejects any on the contact sheet; a rejected one is painted again
  with a new seed (`repaint`).
- D147 (2): JPEG, sRGB; the framing words ask for the subject in the middle band, and the app crops from the middle.
  D148 sets the size and quality: 1280 x 960 at quality 75, over D147's 1600 x 1200 at 82 (Task 3's first proof put
  that at about 81 MB). The count stays 60.
- D147 (3): the sky strip at 1200 x 336 (question 2); the sun and moon stay in code.
- D147 (4): the USD 3 cap, repaints included, counted from BFL's replies, enforced by the script before each request.
- D123: every shipped image carries the tag, written by our own code; `ship` and the app's test both check it.
- G2 like the fonts: Task 1. The picture choice: `paintingFor` over 60. The app size: below.

### The app's size

Sixty paintings are added to the app, and about as much to its download (a JPEG does not compress further in the
app's archive). The plan's first estimate, 30 to 50 MB at 1600 x 1200 and quality 82, was too low: Task 3's proof of
one invented trial painting (1024 x 1024) came to 740,928 bytes, which is about 81 MB for sixty (times 1.83 for
1600 x 1200, times 60). D148 therefore sets 1280 x 960 at quality 75, and the proof is run again at those settings
(Task 3) before Task 4: its bytes times 60 is the figure for question 1 (the line is about 50 MB; if it is above,
the next step is fewer paintings, not lower quality). The sky strip adds well under 1 MB; the fingerprints file about
5 KB (bundled with the folder).

### Decided under D91 (how to build only)

1. The painter sits in `server/trial/` beside `bfl.ts`, whose request and polling it reuses (`paintOnce`, exported;
   `bfl.ts`'s own run is unchanged), with the server's tests and type check; no configuration changes.
2. BFL is asked for a PNG and `sips` makes the one JPEG, so the quality is exactly 75 (D148; first 82): BFL's pages offer JPEG but no
   quality setting [READ, docs.bfl.ai, 2026-11-23].
3. Seeds: painting *n*, attempt *a*: 20000 + 100*n* + *a*; the sky: 29900 + *a*. Never one used twice.
4. The XMP namespace names and the source type are `http://` literals, which G9 allows only in `server/src/hosts.ts`:
   they sit there, marked as never fetched (question 4).
5. The finished JPEG's check stops a painting of another size than asked (`curated-size`); a PNG that is not a PNG
   stops (`curated-not-png`); a converter that loses the profile stops (`curated-srgb`).
6. Earlier attempts stay in the folder; the sheet and `ship` take each item's last.
7. `ship` writes the fingerprints in name order; G2 reads any order.
8. In the app, a painting is decoded at the box's width times the screen's pixel ratio, which keeps a list of rows
   light in memory; the header decodes its own.
9. The date-shade tests run on the real set; "the shade fades in" picks the lightest painting under the date, so the
   shade shows.
10. One existing test that counted every shade on the journal page counts the row's only; New Dream's words now have
    one.

### The places this branch uses

None. No dreamer-facing line is written or changed (R1); New Dream keeps MP·11.

### The tests (test-first, on the Mac)

- Guards: `test_g1_g2` (2 new), `test_g0` (1 new); 274 → 277.
- Server: `curated-jpeg.test.ts` (9, new), `curated.test.ts` (18, new), `hosts.test.ts` (1 new, 1 changed), against a
  fake of BFL's API and a stand-in for `sips`: no key, no network; 100 → 128.
- App: `paintings_test.dart` (6, new: the folder's files, each painting's and the sky's size, sRGB and tag, the
  pubspec, each painting drawn, New Dream's words at 4.5 to 1 on real pixels), `night_art_test.dart` (rewritten: 9 →
  7), `date_shade_test.dart` (on the real set), `journal_page_test.dart` (2 changed); 756 → 760.
- Mutation rows: guard rows 2 new and 1 followed; S86 to S102 (17, new); A772 to A782 (11, new), A368, A371, A372 and
  A423 followed, A369 and A409 to A411 dropped.

## Part 2 · Settings, packages and storage

- **Packages and settings:** none, app or server. No Swift, no AWS change, no Soniox.
- **New file kinds:** none beyond the paintings' `fingerprints.txt`, known by exact path (Task 1, the owner approves
  the G0 change at the prompt as the branch's rule asks). A JPEG is binary, which G0 already knows.
- **A tool the build has not used:** macOS's own `sips` (`/usr/bin/sips`, part of macOS, nothing installed), run only
  by the owner's painting run (question 5). The AI tag is written by our own code: no new tool.
- **Storage:** none (R11). No file in the journal's folder changes.
- **Hosts (R10):** the app talks to nothing new. The painter talks only to `api.eu.bfl.ai` and the delivery address
  BFL's reply names (which gets no key), as the BFL test did. No identifier is sent (R4): BFL's optional `user`
  field is never set.
- **The key (R5):** from Parameter Store into the environment of one command, on the owner's Mac; never in the
  repository, never written by the script.
- **The repository** grows by the set's size (Task 6 commits the sixty-two images).

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
  count given (Tasks 6 and 7).
- `cd server && npm run check` prints only its header, and `npm test` passes at the count given (Task 2).
- The task's rows (D126), every one caught. The server's rows, by code, from the repository root:
  `python3 -I -B -c "import sys; sys.path[:0] = ['tool', 'tool/checks']; import server_mutations as m; from guardlib import report; want = sys.argv[1].split(','); rows = [r for r in m.ROWS if r[0] in want]; assert m.unbroken_passes(); n = sum(m.run_row(*r) == 'caught' for r in rows); report('rows: %d run, %d caught' % (len(rows), n))" <codes>`
- The hook prints `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `curated-set`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1) ; (cd server && npm test 2>&1 | grep -E '^ℹ (tests|fail)')
```

Expected:
- nothing from `git status`;
- this plan's commit;
- `guards (tracked): all passed`;
- `No issues found!`;
- `+756: All tests passed!`;
- `ℹ tests 100` and `ℹ fail 0`.

Anything else: stop (R14).

### Task 1 · G0 and G2 know the paintings (D147)

`PAINTINGS` and `PAINTING_PRINTS` in `guardlib.py`; G2 proves the folder against its fingerprints, armed or not; G0
knows the fingerprints file by exact path. The owner approves the G0 change at the prompt.

Tests: `test_g1_g2.G2` (2 new: listed pass; unlisted, changed, missing or unprinted refuse), `test_g0.G0` (1 new).
`cd tool/checks/tests && python3 -I -B run_tests.py`: `Ran 277 tests`, every one passing but `test_check_all`'s
set-up, which needs the repository and passes there (as in every plan; in the repository itself it passes).

Rows: `cd tool/checks/tests && python3 -I -B mutations.py g0_kinds.py g2_copies.py` → `mutations: 15 run, all
caught` (2 new; the screenshots' G0 row followed, its pattern now spanning the new line).

```
diff --git a/tool/checks/g0_kinds.py b/tool/checks/g0_kinds.py
--- a/tool/checks/g0_kinds.py
+++ b/tool/checks/g0_kinds.py
@@ -7,11 +7,12 @@
 # lists, and the owner approves the change at the prompt. D49 a: .txt is
 # known in the fonts folder only (the licences and the fingerprints);
 # D57 Q11: and the pending lines' fingerprint, by exact path; D58: and
-# the screenshots' fingerprints, by exact path.
+# the screenshots' fingerprints, by exact path; D147: and the night
+# paintings' fingerprints, by exact path.
 import posixpath
 
-from guardlib import (FONTS, LOCKFILES, MARKER, PENDING_FINGERPRINT, SCREEN_PRINTS, SOURCES,
-                      STRINGS_EN, STRINGS_SV, Finding)
+from guardlib import (FONTS, LOCKFILES, MARKER, PAINTING_PRINTS, PENDING_FINGERPRINT, SCREEN_PRINTS,
+                      SOURCES, STRINGS_EN, STRINGS_SV, Finding)
 
 CODE = 'G0'
 NAME = 'file kinds'
@@ -20,7 +21,9 @@ UNSCANNED_NAMES = ('.gitignore',) + LOCKFILES
 # The two generated InfoPlist.strings, by exact path: G1 proves them (D32).
 # The pending lines' fingerprint, by exact path: G1 proves it (D57 Q11).
 # The screenshots' fingerprints, by exact path: G2 proves them (D58).
-UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV, PENDING_FINGERPRINT, SCREEN_PRINTS)
+# The paintings' fingerprints, by exact path: G2 proves them (D147).
+UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV, PENDING_FINGERPRINT, SCREEN_PRINTS,
+                   PAINTING_PRINTS)
 
 
 def known(src, path):
diff --git a/tool/checks/g2_copies.py b/tool/checks/g2_copies.py
--- a/tool/checks/g2_copies.py
+++ b/tool/checks/g2_copies.py
@@ -3,11 +3,12 @@
 # exists; refuses the marker beside any file in docs/source/. Armed or
 # not, no tracked path anywhere may be privacy-ethics-safety.md or sit in
 # a folder named restricted (D32 Q18): those never leave the documents.
-# The fonts (D49 a) and the screenshots (D58), armed or not: every file
+# The fonts (D49 a), the screenshots (D58) and the night paintings
+# (D147), armed or not: every file
 # in each folder is listed in its fingerprints file with its sha256, and
 # matches it.
-from guardlib import (CSV, FINGERPRINT, FINGERPRINTS, FONTS, LISTS, MARKER, SCREEN_PRINTS,
-                      SCREENS, SOURCES, Finding, parse_sources, sha256)
+from guardlib import (CSV, FINGERPRINT, FINGERPRINTS, FONTS, LISTS, MARKER, PAINTING_PRINTS,
+                      PAINTINGS, SCREEN_PRINTS, SCREENS, SOURCES, Finding, parse_sources, sha256)
 
 CODE = 'G2'
 NAME = 'copies'
@@ -53,6 +54,7 @@ def check(src):
     refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
     refused += font_findings(src)
     refused += fingerprint_findings(src, SCREENS, SCREEN_PRINTS, 'screen')
+    refused += fingerprint_findings(src, PAINTINGS, PAINTING_PRINTS, 'painting')
     in_dir = [p for p in src.paths if p.startswith(DIR)]
     if src.has(MARKER):
         if in_dir:
diff --git a/tool/checks/guardlib.py b/tool/checks/guardlib.py
--- a/tool/checks/guardlib.py
+++ b/tool/checks/guardlib.py
@@ -43,6 +43,11 @@ FINGERPRINTS = 'app/assets/fonts/fingerprints.txt'
 # G0 knows that one .txt file here. No word is ever taken from them.
 SCREENS = 'docs/reference/screens/'
 SCREEN_PRINTS = 'docs/reference/screens/fingerprints.txt'
+# The night paintings shipped in the app (D147): every file here is
+# listed in PAINTING_PRINTS with its sha256, which G2 proves; G0 knows
+# that one .txt file here, and a painting is binary.
+PAINTINGS = 'app/assets/paintings/'
+PAINTING_PRINTS = 'app/assets/paintings/fingerprints.txt'
 
 CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.mjs': 'ts', '.cjs': 'ts',
             '.swift': 'swift', '.py': 'py', '.sh': 'sh'}
diff --git a/tool/checks/tests/mutations.py b/tool/checks/tests/mutations.py
--- a/tool/checks/tests/mutations.py
+++ b/tool/checks/tests/mutations.py
@@ -215,8 +215,13 @@ MUTATIONS = [
     # journal-screens, Task 3 (D58): the screenshots.
     ('g2_copies.py', "    refused += fingerprint_findings(src, SCREENS, SCREEN_PRINTS, 'screen')\n", "",
      ['test_g1_g2.G2.test_screens_unlisted_changed_or_unprinted_refuse']),
-    ('g0_kinds.py', ", PENDING_FINGERPRINT, SCREEN_PRINTS)", ", PENDING_FINGERPRINT)",
+    ('g0_kinds.py', ", PENDING_FINGERPRINT, SCREEN_PRINTS,\n                   PAINTING", ", PENDING_FINGERPRINT,\n                   PAINTING",
      ['test_g0.G0.test_screen_fingerprints_known_by_path_only']),
+    # curated-set, Task 1 (D147): the night paintings.
+    ('g2_copies.py', "    refused += fingerprint_findings(src, PAINTINGS, PAINTING_PRINTS, 'painting')\n", "",
+     ['test_g1_g2.G2.test_paintings_unlisted_changed_missing_or_unprinted_refuse']),
+    ('g0_kinds.py', "SCREEN_PRINTS,\n                   PAINTING_PRINTS)", "SCREEN_PRINTS)",
+     ['test_g0.G0.test_painting_fingerprints_known_by_path_only']),
     # c17p-import (D109): the status that waits for its Swedish.
     ('wordsgen.py', "'composed, no stand-in',\n           'English written, Swedish to write')",
      "'composed, no stand-in')",
diff --git a/tool/checks/tests/test_g0.py b/tool/checks/tests/test_g0.py
--- a/tool/checks/tests/test_g0.py
+++ b/tool/checks/tests/test_g0.py
@@ -28,6 +28,13 @@ class G0(GuardTest):
         self.refused({'docs/reference/screens/notes.txt': 'x\n'}, 'unknown-kind')
         self.refused({'docs/reference/screens/journal.png': b'no nul byte'}, 'unknown-kind')
 
+    # D147: the paintings' fingerprints, by exact path; a painting is binary.
+    def test_painting_fingerprints_known_by_path_only(self):
+        self.passed({'app/assets/paintings/fingerprints.txt': 'x\n',
+                     'app/assets/paintings/01.jpg': b'\xff\xd8\0'})
+        self.refused({'app/assets/paintings/notes.txt': 'x\n'}, 'unknown-kind')
+        self.refused({'app/assets/paintings/01.jpg': b'no nul byte'}, 'unknown-kind')
+
     def test_a_font_is_binary(self):
         self.passed({'app/assets/fonts/A-Regular.ttf': b'\x00\x01font'})
 
diff --git a/tool/checks/tests/test_g1_g2.py b/tool/checks/tests/test_g1_g2.py
--- a/tool/checks/tests/test_g1_g2.py
+++ b/tool/checks/tests/test_g1_g2.py
@@ -277,6 +277,36 @@ class G2(GuardTest):
         self.assertEqual(self.refused(tree),
                          [('docs/reference/screens/fingerprints.txt', 0, 'no-fingerprints')])
 
+    # D147: the night paintings, fingerprinted as the fonts are.
+    def paintings(self, listed=None):
+        files = {'01.jpg': b'\xff\xd8\0a', 'sky.jpg': b'\xff\xd8\0b'}
+        listed = files if listed is None else listed
+        tree = {'app/assets/paintings/' + name: body for name, body in files.items()}
+        tree['app/assets/paintings/fingerprints.txt'] = ''.join(
+            hashlib.sha256(body).hexdigest() + '  ' + name + '\n' for name, body in listed.items())
+        tree.update({COPY: 'h\n', SOURCES: line(COPY, 'h\n')})
+        return tree
+
+    def test_paintings_listed_pass(self):
+        self.passed(self.paintings())
+
+    def test_paintings_unlisted_changed_missing_or_unprinted_refuse(self):
+        tree = self.paintings(listed={'01.jpg': b'\xff\xd8\0a'})
+        self.assertEqual(self.refused(tree),
+                         [('app/assets/paintings/sky.jpg', 0, 'painting-unlisted')])
+        tree = self.paintings()
+        tree['app/assets/paintings/01.jpg'] = b'\xff\xd8\0c'
+        self.assertEqual(self.refused(tree),
+                         [('app/assets/paintings/01.jpg', 0, 'painting-hash-mismatch')])
+        tree = self.paintings()
+        del tree['app/assets/paintings/sky.jpg']
+        self.assertEqual(self.refused(tree),
+                         [('app/assets/paintings/sky.jpg', 0, 'painting-missing')])
+        tree = self.paintings()
+        del tree['app/assets/paintings/fingerprints.txt']
+        self.assertEqual(self.refused(tree),
+                         [('app/assets/paintings/fingerprints.txt', 0, 'no-fingerprints')])
+
     def test_fonts_checked_when_not_armed(self):
         tree = self.fonts()
         tree['app/assets/fonts/A-Regular.ttf'] = b'\x00b'
```

Commit: `G0 and G2 know the night paintings' folder and its fingerprints (D147)`

### Task 2 · The painter, the scenes and the AI tag (D147; D123)

`server/trial/curated.ts`, `server/trial/scenes.ts`, `server/trial/jpeg.ts`; `paintOnce` exported from `bfl.ts`; the
AI tag's names in `server/src/hosts.ts`. Nothing runs it but the owner (Tasks 3 to 5).

Tests: `server/test/curated-jpeg.test.ts` (9), `server/test/curated.test.ts` (18), `server/test/hosts.test.ts` (1 new,
1 changed), helpers in `server/test/curated-fakes.ts`. `npm test`: `ℹ tests 128`, `ℹ fail 0`.

Rows: S86 to S102 by code (the command above), `rows: 17 run, 17 caught`; and S77 to S81 (`bfl.ts` changed),
`rows: 5 run, 5 caught`.

```
diff --git a/server/src/hosts.ts b/server/src/hosts.ts
--- a/server/src/hosts.ts
+++ b/server/src/hosts.ts
@@ -7,10 +7,22 @@ export const SONIOX_TEMPORARY_KEY_URL = 'https://api.eu.soniox.com/v1/auth/tempo
 
 /**
  * Black Forest Labs' EU image API, and the end of the hosts it answers from:
- * for the image trial's test script (`trial/bfl.ts`, D144) on the owner's
- * Mac only. Not a host of the server, so not in HOSTS.
+ * for the image trial's test script (`trial/bfl.ts`, D144) and the curated
+ * set's painter (`trial/curated.ts`, D147), on the owner's Mac only. Not a
+ * host of the server, so not in HOSTS.
  */
 export const BFL_API_URL = 'https://api.eu.bfl.ai/v1';
 export const BFL_HOST_SUFFIX = '.bfl.ai';
 
+/**
+ * Not hosts, and never fetched: the names inside the invisible AI tag that
+ * the curated set's painter writes into every shipped painting (D123, D147),
+ * the IPTC digital source type in an XMP packet. Here because every such
+ * literal lives in this file (G9).
+ */
+export const XMP_HEADER = 'http://ns.adobe.com/xap/1.0/';
+export const XMP_RDF = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
+export const XMP_IPTC_EXT = 'http://iptc.org/std/Iptc4xmpExt/2008-02-29/';
+export const AI_SOURCE_TYPE = 'http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia';
+
 export const HOSTS: readonly string[] = Object.freeze(['api.eu.soniox.com']);
diff --git a/server/test/curated-fakes.ts b/server/test/curated-fakes.ts
new file mode 100644
--- /dev/null
+++ b/server/test/curated-fakes.ts
@@ -0,0 +1,138 @@
+// Small images and a fake of BFL's API for the curated set's tests (D147):
+// no key, no network, no sips. The key and every address are invented.
+import { readFileSync, writeFileSync } from 'node:fs';
+import type { Clock, Reply, Send } from '../trial/bfl.ts';
+import type { Convert } from '../trial/curated.ts';
+import { pngSize } from '../trial/jpeg.ts';
+
+export const KEY = 'invented-key-0123456789';
+const POLLING = 'https://api.eu.bfl.ai/v1/get_result?id=';
+const IMAGE = 'https://delivery-eu1.bfl.ai/';
+
+export function segment(marker: number, data: Buffer): Buffer {
+  const head = Buffer.from([0xff, marker, 0, 0]);
+  head.writeUInt16BE(data.length + 2, 2);
+  return Buffer.concat([head, data]);
+}
+
+/** A PNG's signature and header, enough for its size. */
+export function fakePng(width: number, height: number): Buffer {
+  const png = Buffer.alloc(33);
+  Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]).copy(png, 0);
+  png.writeUInt32BE(13, 8);
+  png.write('IHDR', 12, 'latin1');
+  png.writeUInt32BE(width, 16);
+  png.writeUInt32BE(height, 20);
+  return png;
+}
+
+export interface JpegOptions {
+  jfif?: boolean;
+  icc?: 'ascii' | 'utf16' | 'p3' | 'none';
+  frame?: boolean;
+  progressive?: boolean;
+  extra?: readonly Buffer[];
+  /** A byte in the scan, so two images of one size differ. */
+  mark?: number;
+}
+
+/** A JPEG's start, its segments up to the scan, a few bytes and its end. */
+export function fakeJpeg(width: number, height: number, options: JpegOptions = {}): Buffer {
+  const parts: Buffer[] = [Buffer.from([0xff, 0xd8])];
+  if (options.jfif !== false) {
+    parts.push(segment(0xe0, Buffer.from('JFIF\0\x01\x01\0\0\x01\0\x01\0\0', 'latin1')));
+  }
+  const icc = options.icc ?? 'ascii';
+  if (icc !== 'none') {
+    const name =
+      icc === 'utf16'
+        ? Buffer.from([0, 0x73, 0, 0x52, 0, 0x47, 0, 0x42])
+        : Buffer.from(icc === 'p3' ? 'Display P3' : 'sRGB IEC61966-2.1', 'latin1');
+    parts.push(segment(0xe2, Buffer.concat([Buffer.from('ICC_PROFILE\0\x01\x01', 'latin1'), name])));
+  }
+  parts.push(...(options.extra ?? []));
+  if (options.frame !== false) {
+    const sof = Buffer.from([8, 0, 0, 0, 0, 3, 1, 0x22, 0, 2, 0x11, 1, 3, 0x11, 1]);
+    sof.writeUInt16BE(height, 1);
+    sof.writeUInt16BE(width, 3);
+    parts.push(segment(options.progressive ? 0xc2 : 0xc0, sof));
+  }
+  parts.push(segment(0xda, Buffer.from([3, 1, 0, 2, 0x11, 3, 0x11, 0, 0x3f, 0])));
+  parts.push(Buffer.from([1, 2, (options.mark ?? 3) & 0x7f, 0xff, 0xd9]));
+  return Buffer.concat(parts);
+}
+
+/** sips's stand-in: the PNG's size, as a JPEG with an sRGB profile, or as [options] says. */
+export function fakeConvert(options: JpegOptions = {}): { convert: Convert; calls: number } {
+  const state = {
+    calls: 0,
+    convert: async (png: string, jpg: string) => {
+      state.calls += 1;
+      const size = pngSize(readFileSync(png));
+      if (size === null) {
+        throw new Error('fake-convert');
+      }
+      writeFileSync(jpg, fakeJpeg(size.width, size.height, { mark: state.calls, ...options }));
+    },
+  };
+  return state;
+}
+
+export interface Seen {
+  method: string;
+  url: string;
+  headers: Record<string, string>;
+  body: Record<string, unknown> | undefined;
+}
+
+export interface ApiOptions {
+  /** The cost each POST names, in turn; the last repeats. */
+  costs?: readonly unknown[];
+  /** A size painted instead of the one asked for. */
+  size?: { width: number; height: number };
+  /** The POST that answers with a status of its own (1-based), and the status. */
+  failAt?: { post: number; status: number };
+}
+
+/** BFL's API, faked: every request 500 ms; a poll answers Ready with the image. */
+export function fakeApi(options: ApiOptions = {}): { send: Send; seen: Seen[]; clock: Clock } {
+  let t = 0;
+  let posts = 0;
+  const seen: Seen[] = [];
+  const asked = new Map<string, { width: number; height: number }>();
+  const reply = (status: number, json: unknown, bytes?: Buffer): Reply => ({
+    status,
+    json: async () => json,
+    bytes: async () => bytes ?? Buffer.alloc(0),
+  });
+  const send: Send = async (url, init) => {
+    t += 500;
+    const body = init.body === undefined ? undefined : (JSON.parse(init.body) as Record<string, unknown>);
+    seen.push({ method: init.method, url, headers: init.headers, body });
+    if (init.method === 'POST') {
+      posts += 1;
+      if (options.failAt?.post === posts) {
+        return reply(options.failAt.status, { detail: KEY });
+      }
+      const id = String(posts);
+      asked.set(id, { width: Number(body?.width), height: Number(body?.height) });
+      const costs = options.costs ?? [1.5];
+      const cost = costs[Math.min(posts - 1, costs.length - 1)];
+      return reply(200, { id, polling_url: POLLING + id, cost });
+    }
+    if (url.startsWith(POLLING)) {
+      const id = url.slice(POLLING.length);
+      return reply(200, { status: 'Ready', result: { sample: `${IMAGE}${id}.png` } });
+    }
+    const id = url.slice(IMAGE.length, -'.png'.length);
+    const size = options.size ?? asked.get(id) ?? { width: 0, height: 0 };
+    return reply(200, {}, fakePng(size.width, size.height));
+  };
+  const clock: Clock = {
+    now: () => t,
+    sleep: async (ms) => {
+      t += ms;
+    },
+  };
+  return { send, seen, clock };
+}
diff --git a/server/test/curated-jpeg.test.ts b/server/test/curated-jpeg.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/curated-jpeg.test.ts
@@ -0,0 +1,76 @@
+// The curated set's bytes (D147): sizes, the colour profile and the AI tag
+// (D123), on small JPEGs built here, segment by segment.
+import assert from 'node:assert/strict';
+import { test } from 'node:test';
+import { AI_SOURCE_TYPE } from '../src/hosts.ts';
+import { aiPacket, aiTagged, hasSrgb, jpegSize, pngSize, withAiTag } from '../trial/jpeg.ts';
+import { fakeJpeg, fakePng, segment } from './curated-fakes.ts';
+
+test("a PNG's size from its header; anything else is none", () => {
+  assert.deepEqual(pngSize(fakePng(1600, 1200)), { width: 1600, height: 1200 });
+  assert.equal(pngSize(Buffer.from('not a png at all, not at all')), null);
+  assert.equal(pngSize(fakePng(4, 4).subarray(0, 20)), null);
+});
+
+test("a JPEG's size from its frame header", () => {
+  assert.deepEqual(jpegSize(fakeJpeg(1600, 1200)), { width: 1600, height: 1200 });
+  assert.deepEqual(jpegSize(fakeJpeg(1200, 336, { progressive: true })), { width: 1200, height: 336 });
+});
+
+test('a malformed JPEG is refused with a code', () => {
+  assert.throws(() => jpegSize(Buffer.from([0x89, 0x50, 0x4e, 0x47])), /^Error: curated-jpeg$/);
+  assert.throws(() => jpegSize(fakeJpeg(8, 8).subarray(0, 30)), /^Error: curated-jpeg$/);
+  assert.throws(() => jpegSize(fakeJpeg(8, 8, { frame: false })), /^Error: curated-jpeg$/);
+});
+
+test('sRGB: an ICC profile naming it, in either encoding', () => {
+  assert.equal(hasSrgb(fakeJpeg(8, 8)), true);
+  assert.equal(hasSrgb(fakeJpeg(8, 8, { icc: 'utf16' })), true);
+  assert.equal(hasSrgb(fakeJpeg(8, 8, { icc: 'p3' })), false);
+  assert.equal(hasSrgb(fakeJpeg(8, 8, { icc: 'none' })), false);
+});
+
+test('the tag goes in after JFIF and is read back', () => {
+  const plain = fakeJpeg(16, 12);
+  assert.equal(aiTagged(plain), false);
+  const tagged = withAiTag(plain);
+  assert.equal(aiTagged(tagged), true);
+  // Start, JFIF, then the tag's APP1; the rest unchanged.
+  assert.deepEqual([...tagged.subarray(0, 4)], [0xff, 0xd8, 0xff, 0xe0]);
+  const jfifEnd = 2 + 2 + plain.readUInt16BE(4);
+  assert.deepEqual([...tagged.subarray(jfifEnd, jfifEnd + 2)], [0xff, 0xe1]);
+  const added = tagged.length - plain.length;
+  assert.ok(tagged.subarray(jfifEnd + added).equals(plain.subarray(jfifEnd)));
+  assert.deepEqual(jpegSize(tagged), { width: 16, height: 12 });
+  assert.equal(hasSrgb(tagged), true);
+});
+
+test('the tag goes in after the start when no JFIF leads', () => {
+  const plain = fakeJpeg(16, 12, { jfif: false });
+  const tagged = withAiTag(plain);
+  assert.deepEqual([...tagged.subarray(0, 4)], [0xff, 0xd8, 0xff, 0xe1]);
+  assert.equal(aiTagged(tagged), true);
+});
+
+test('a JPEG already holding XMP is refused', () => {
+  assert.throws(() => withAiTag(withAiTag(fakeJpeg(8, 8))), /^Error: curated-xmp$/);
+});
+
+test('the packet names the IPTC source type and nothing else', () => {
+  const packet = aiPacket();
+  assert.ok(packet.includes(`Iptc4xmpExt:DigitalSourceType="${AI_SOURCE_TYPE}"`));
+  assert.ok(AI_SOURCE_TYPE.endsWith('/trainedAlgorithmicMedia'));
+  assert.equal(packet.match(/<rdf:Description /g)?.length, 1);
+  assert.ok(packet.startsWith('<?xpacket begin='));
+  assert.ok(packet.endsWith('<?xpacket end="r"?>'));
+});
+
+test('an untagged JPEG, or another packet, is not tagged', () => {
+  const other = Buffer.concat([
+    Buffer.from('http://ns.adobe.com/xap/1.0/\0', 'latin1'),
+    Buffer.from('<x:xmpmeta xmlns:x="adobe:ns:meta/"></x:xmpmeta>', 'utf8'),
+  ]);
+  const jpeg = fakeJpeg(8, 8, { extra: [segment(0xe1, other)] });
+  assert.equal(aiTagged(jpeg), false);
+  assert.throws(() => withAiTag(jpeg), /^Error: curated-xmp$/);
+});
diff --git a/server/test/curated.test.ts b/server/test/curated.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/curated.test.ts
@@ -0,0 +1,382 @@
+// The curated set's painter (D147), against a fake of BFL's API and a
+// stand-in for sips: no key, no network. Every folder is a fresh one in the
+// temporary folder.
+import assert from 'node:assert/strict';
+import { existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
+import { tmpdir } from 'node:os';
+import { join } from 'node:path';
+import { test } from 'node:test';
+import { createHash } from 'node:crypto';
+import { BFL_API_URL } from '../src/hosts.ts';
+import {
+  CAP_CREDITS,
+  ITEMS,
+  MODEL,
+  PAINTING,
+  RESERVE_CREDITS,
+  SKY,
+  checkJpeg,
+  fileOf,
+  paintSet,
+  parseArgs,
+  proof,
+  repaint,
+  seedOf,
+  ship,
+  sipsArgs,
+  type SetState,
+} from '../trial/curated.ts';
+import { aiTagged, hasSrgb, jpegSize } from '../trial/jpeg.ts';
+import { STYLE } from '../trial/measure.ts';
+import { FRAME, SCENES, SKY_SCENE, scenePrompt, skyPrompt } from '../trial/scenes.ts';
+import { KEY, fakeApi, fakeConvert, fakeJpeg, fakePng } from './curated-fakes.ts';
+
+function folder(): string {
+  return mkdtempSync(join(tmpdir(), 'curated-'));
+}
+
+function state(dir: string): SetState {
+  return JSON.parse(readFileSync(join(dir, 'set.json'), 'utf8')) as SetState;
+}
+
+const words = (s: string) => s.split(/\s+/).filter(Boolean).length;
+
+test('sixty invented scenes, each short, the frame and the style', () => {
+  assert.equal(SCENES.length, 60);
+  assert.equal(new Set(SCENES).size, 60);
+  for (const scene of [...SCENES, SKY_SCENE]) {
+    assert.ok(words(scene) < 12, scene);
+    assert.doesNotMatch(scene, /\b(man|woman|child|people|person|figure|word|sign|letter)s?\b/i);
+  }
+  assert.equal(scenePrompt(1), `${SCENES[0]}, ${FRAME}, ${STYLE}`);
+  assert.equal(scenePrompt(60), `${SCENES[59]}, ${FRAME}, ${STYLE}`);
+  assert.equal(skyPrompt(), `${SKY_SCENE}, ${STYLE}`);
+  assert.throws(() => scenePrompt(0), /^Error: curated-scene$/);
+  assert.throws(() => scenePrompt(61), /^Error: curated-scene$/);
+});
+
+test('the set: sixty paintings and the sky, sizes, seeds, the model', async () => {
+  const api = fakeApi();
+  const dir = folder();
+  try {
+    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
+    const posts = api.seen.filter((s) => s.method === 'POST');
+    assert.equal(posts.length, 61);
+    assert.ok(posts.every((p) => p.url === `${BFL_API_URL}/${MODEL}`));
+    assert.deepEqual(posts[0]?.body, {
+      prompt: scenePrompt(1),
+      width: 1600,
+      height: 1200,
+      seed: seedOf(1, 1),
+      output_format: 'png',
+    });
+    assert.deepEqual(posts[60]?.body, {
+      prompt: skyPrompt(),
+      width: 1200,
+      height: 336,
+      seed: seedOf('sky', 1),
+      output_format: 'png',
+    });
+    const seeds = posts.map((p) => p.body?.seed);
+    assert.equal(new Set(seeds).size, 61);
+    assert.deepEqual(ITEMS.length, 61);
+    const s = state(dir);
+    assert.equal(s.credits, 61 * 1.5);
+    assert.deepEqual(s.items['07'], { attempt: 1, seed: seedOf(7, 1), credits: 1.5 });
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('each finished painting is a tagged sRGB JPEG of its size', async () => {
+  const api = fakeApi();
+  const dir = folder();
+  try {
+    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
+    for (const item of ITEMS) {
+      const jpeg = readFileSync(join(dir, fileOf(item, 1)));
+      assert.deepEqual(jpegSize(jpeg), item === 'sky' ? SKY : PAINTING);
+      assert.equal(hasSrgb(jpeg), true);
+      assert.equal(aiTagged(jpeg), true);
+    }
+    // Nothing of the work is left behind.
+    assert.equal(existsSync(join(dir, 'work.png')), false);
+    assert.equal(existsSync(join(dir, 'work.jpg')), false);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('a stopped run goes on from where it stopped', async () => {
+  const dir = folder();
+  try {
+    const first = fakeApi({ failAt: { post: 5, status: 500 } });
+    await assert.rejects(paintSet(first.send, KEY, first.clock, fakeConvert().convert, dir), /^Error: bfl-http-500$/);
+    assert.deepEqual(Object.keys(state(dir).items), ['01', '02', '03', '04']);
+    const again = fakeApi();
+    await paintSet(again.send, KEY, again.clock, fakeConvert().convert, dir);
+    const posts = again.seen.filter((s) => s.method === 'POST');
+    assert.equal(posts.length, 57);
+    assert.equal(posts[0]?.body?.prompt, scenePrompt(5));
+    // The failed request's reserve stays counted.
+    assert.equal(state(dir).credits, 61 * 1.5 + RESERVE_CREDITS);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('a repaint takes the next seed and keeps the earlier image', async () => {
+  const dir = folder();
+  try {
+    const api = fakeApi();
+    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
+    const more = fakeApi({ costs: [1.6] });
+    await repaint(more.send, KEY, more.clock, fakeConvert().convert, dir, [7, 'sky']);
+    const posts = more.seen.filter((s) => s.method === 'POST');
+    assert.deepEqual(
+      posts.map((p) => [p.body?.prompt, p.body?.seed]),
+      [
+        [scenePrompt(7), seedOf(7, 2)],
+        [skyPrompt(), seedOf('sky', 2)],
+      ],
+    );
+    const s = state(dir);
+    assert.deepEqual(s.items['07'], { attempt: 2, seed: seedOf(7, 2), credits: 1.6 });
+    assert.equal(s.items.sky?.attempt, 2);
+    assert.equal(s.credits, 61 * 1.5 + 2 * 1.6);
+    assert.ok(existsSync(join(dir, '07-1.jpg')) && existsSync(join(dir, '07-2.jpg')));
+    assert.deepEqual([seedOf(7, 1), seedOf(7, 2), seedOf('sky', 1), seedOf('sky', 2)], [20701, 20702, 29901, 29902]);
+    assert.notEqual(seedOf(7, 2), seedOf(8, 1));
+    assert.match(readFileSync(join(dir, 'set.md'), 'utf8'), /Painted again: 07, sky\./);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('a repaint of an item not painted yet is refused', async () => {
+  const dir = folder();
+  try {
+    const api = fakeApi();
+    await assert.rejects(repaint(api.send, KEY, api.clock, fakeConvert().convert, dir, [3]), /^Error: curated-usage$/);
+    assert.equal(api.seen.length, 0);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('the cap: no request that could pass USD 3', async () => {
+  const dir = folder();
+  try {
+    writeFileSync(join(dir, 'set.json'), JSON.stringify({ credits: CAP_CREDITS - RESERVE_CREDITS + 0.5, items: {} }));
+    const api = fakeApi();
+    await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-cap$/);
+    assert.equal(api.seen.length, 0);
+    writeFileSync(join(dir, 'set.json'), JSON.stringify({ credits: CAP_CREDITS - RESERVE_CREDITS, items: {} }));
+    await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-cap$/);
+    assert.equal(api.seen.filter((s) => s.method === 'POST').length, 1);
+    assert.equal(CAP_CREDITS, 300);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('a reply naming no cost, or too much, stops', async () => {
+  for (const [cost, counted] of [
+    [undefined, RESERVE_CREDITS],
+    ['1.5', RESERVE_CREDITS],
+    [RESERVE_CREDITS + 1, RESERVE_CREDITS + 1],
+  ] as const) {
+    const dir = folder();
+    try {
+      const api = fakeApi({ costs: [cost] });
+      await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-cost$/);
+      assert.equal(api.seen.filter((s) => s.method === 'POST').length, 1);
+      assert.equal(state(dir).credits, counted);
+      assert.deepEqual(state(dir).items, {});
+    } finally {
+      rmSync(dir, { recursive: true });
+    }
+  }
+});
+
+test('a painting of the wrong size stops', async () => {
+  const dir = folder();
+  try {
+    const api = fakeApi({ size: { width: 1600, height: 1184 } });
+    await assert.rejects(paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir), /^Error: curated-size$/);
+    assert.deepEqual(state(dir).items, {});
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('a converter that loses the profile stops', async () => {
+  const dir = folder();
+  try {
+    const api = fakeApi();
+    const convert = fakeConvert({ icc: 'none' });
+    await assert.rejects(paintSet(api.send, KEY, api.clock, convert.convert, dir), /^Error: curated-srgb$/);
+    assert.deepEqual(state(dir).items, {});
+    assert.equal(readdirSync(dir).filter((f) => f.endsWith('.jpg')).length, 0);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('a finished JPEG is checked for size, sRGB and the tag', () => {
+  assert.throws(() => checkJpeg(fakeJpeg(1600, 1200), PAINTING), /^Error: curated-tag$/);
+  assert.throws(() => checkJpeg(fakeJpeg(1600, 1199), PAINTING), /^Error: curated-size$/);
+  assert.throws(() => checkJpeg(fakeJpeg(1600, 1200, { icc: 'p3' }), PAINTING), /^Error: curated-srgb$/);
+});
+
+test('the contact sheet shows each last attempt with its crops', async () => {
+  const dir = folder();
+  try {
+    const api = fakeApi();
+    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
+    const more = fakeApi();
+    await repaint(more.send, KEY, more.clock, fakeConvert().convert, dir, [12]);
+    const sheet = readFileSync(join(dir, 'sheet.html'), 'utf8');
+    assert.equal(sheet.match(/<figure>/g)?.length, 61);
+    assert.ok(sheet.includes('<img src="12-2.jpg"'));
+    assert.equal(sheet.includes('12-1.jpg'), false);
+    assert.equal(sheet.match(/class="crop row"/g)?.length, 60);
+    assert.equal(sheet.match(/class="crop header"/g)?.length, 60);
+    assert.equal(sheet.match(/class="crop pill"/g)?.length, 1);
+    assert.ok(sheet.includes('.row{width:330px;height:64px}'));
+    assert.ok(sheet.includes('.header{width:390px;height:287px'));
+    assert.equal(sheet.includes('http'), false);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('ship: the last attempts, renamed, with their fingerprints', async () => {
+  const dir = folder();
+  const target = folder();
+  try {
+    const api = fakeApi();
+    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
+    await repaint(api.send, KEY, api.clock, fakeConvert().convert, dir, [2]);
+    ship(dir, target);
+    const files = readdirSync(target).sort();
+    assert.equal(files.length, 62);
+    assert.deepEqual(files.slice(0, 2), ['01.jpg', '02.jpg']);
+    assert.deepEqual(files.slice(-3), ['60.jpg', 'fingerprints.txt', 'sky.jpg']);
+    assert.ok(readFileSync(join(target, '02.jpg')).equals(readFileSync(join(dir, '02-2.jpg'))));
+    assert.equal(readFileSync(join(dir, '02-1.jpg')).equals(readFileSync(join(dir, '02-2.jpg'))), false);
+    const prints = readFileSync(join(target, 'fingerprints.txt'), 'utf8').trimEnd().split('\n');
+    assert.equal(prints.length, 61);
+    for (const line of prints) {
+      const m = /^([0-9a-f]{64}) {2}([A-Za-z0-9._-]+)$/.exec(line);
+      assert.ok(m, line);
+      const digest = createHash('sha256').update(readFileSync(join(target, m[2] ?? ''))).digest('hex');
+      assert.equal(m[1], digest);
+    }
+    // Again over its own result: the same.
+    ship(dir, target);
+    assert.equal(readdirSync(target).length, 62);
+  } finally {
+    rmSync(dir, { recursive: true });
+    rmSync(target, { recursive: true });
+  }
+});
+
+test('ship refuses a set not finished, or a folder holding more', async () => {
+  const dir = folder();
+  const target = folder();
+  try {
+    const first = fakeApi({ failAt: { post: 61, status: 500 } });
+    await assert.rejects(paintSet(first.send, KEY, first.clock, fakeConvert().convert, dir), /^Error: bfl-http-500$/);
+    assert.throws(() => ship(dir, target), /^Error: curated-ship-missing$/);
+    const rest = fakeApi();
+    await paintSet(rest.send, KEY, rest.clock, fakeConvert().convert, dir);
+    mkdirSync(join(target, 'more'));
+    assert.throws(() => ship(dir, target), /^Error: curated-ship-folder$/);
+    rmSync(join(target, 'more'), { recursive: true });
+    writeFileSync(join(dir, fileOf(5, 1)), fakeJpeg(1600, 1200));
+    assert.throws(() => ship(dir, target), /^Error: curated-tag$/);
+  } finally {
+    rmSync(dir, { recursive: true });
+    rmSync(target, { recursive: true });
+  }
+});
+
+test('the key goes to BFL only, and is written nowhere', async () => {
+  const api = fakeApi();
+  const dir = folder();
+  try {
+    await paintSet(api.send, KEY, api.clock, fakeConvert().convert, dir);
+    for (const s of api.seen) {
+      const keyed = s.headers['x-key'] === KEY;
+      assert.equal(keyed, !s.url.startsWith('https://delivery-eu1.bfl.ai/'), s.url);
+    }
+    for (const f of readdirSync(dir)) {
+      assert.equal(readFileSync(join(dir, f)).includes(KEY), false, f);
+    }
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
+
+test('the arguments: four modes; items 1 to 60, or sky', () => {
+  const env = { BFL_API_KEY: KEY };
+  assert.deepEqual(parseArgs(env, ['paint', 'f']), { mode: 'paint', folder: 'f', key: KEY });
+  assert.deepEqual(parseArgs(env, ['repaint', 'f', '7', 'sky', '60']), {
+    mode: 'repaint',
+    folder: 'f',
+    key: KEY,
+    items: [7, 'sky', 60],
+  });
+  assert.deepEqual(parseArgs({}, ['proof', 'f', 'a.png']), { mode: 'proof', folder: 'f', path: 'a.png' });
+  assert.deepEqual(parseArgs({}, ['ship', 'f', 't']), { mode: 'ship', folder: 'f', path: 't' });
+  for (const argv of [
+    ['paint', 'f', 'x'],
+    ['repaint', 'f'],
+    ['repaint', 'f', '0'],
+    ['repaint', 'f', '61'],
+    ['repaint', 'f', '7a'],
+    ['repaint', 'f', '7', '7'],
+    ['ship', 'f'],
+    ['other', 'f'],
+    ['paint'],
+  ]) {
+    assert.throws(() => parseArgs(env, argv), /^Error: curated-usage$/, argv.join(' '));
+  }
+  assert.throws(() => parseArgs({}, ['paint', 'f']), /^Error: curated-usage$/);
+  assert.throws(() => parseArgs({ BFL_API_KEY: '' }, ['repaint', 'f', '1']), /^Error: curated-usage$/);
+});
+
+test('sips makes quality 82 with the sRGB profile', () => {
+  assert.deepEqual(sipsArgs('in.png', 'out.jpg'), [
+    '-s',
+    'format',
+    'jpeg',
+    '-s',
+    'formatOptions',
+    '82',
+    '-E',
+    '/System/Library/ColorSync/Profiles/sRGB Profile.icc',
+    'in.png',
+    '--out',
+    'out.jpg',
+  ]);
+});
+
+test('proof: a PNG through the same steps, with no request', async () => {
+  const dir = folder();
+  try {
+    const convert = fakeConvert();
+    await proof(convert.convert, dir, fakePng(1024, 1024));
+    assert.equal(convert.calls, 1);
+    const jpeg = readFileSync(join(dir, 'proof.jpg'));
+    assert.equal(aiTagged(jpeg), true);
+    assert.match(
+      readFileSync(join(dir, 'proof.md'), 'utf8'),
+      new RegExp(`^Proof: 1024 x 1024, sRGB, tagged, ${jpeg.length} bytes, quality 82\\.\\n$`),
+    );
+    await assert.rejects(proof(convert.convert, dir, Buffer.from('no png')), /^Error: curated-not-png$/);
+  } finally {
+    rmSync(dir, { recursive: true });
+  }
+});
diff --git a/server/test/hosts.test.ts b/server/test/hosts.test.ts
--- a/server/test/hosts.test.ts
+++ b/server/test/hosts.test.ts
@@ -4,7 +4,16 @@ import { test } from 'node:test';
 import * as hosts from '../src/hosts.ts';
 
 test("Soniox's EU REST host only", () => {
-  assert.deepEqual(Object.keys(hosts).sort(), ['BFL_API_URL', 'BFL_HOST_SUFFIX', 'HOSTS', 'SONIOX_TEMPORARY_KEY_URL']);
+  assert.deepEqual(Object.keys(hosts).sort(), [
+    'AI_SOURCE_TYPE',
+    'BFL_API_URL',
+    'BFL_HOST_SUFFIX',
+    'HOSTS',
+    'SONIOX_TEMPORARY_KEY_URL',
+    'XMP_HEADER',
+    'XMP_IPTC_EXT',
+    'XMP_RDF',
+  ]);
   assert.deepEqual(hosts.HOSTS, ['api.eu.soniox.com']);
   assert.ok(Object.isFrozen(hosts.HOSTS));
 });
@@ -24,3 +33,13 @@ test("the image test's address is the EU endpoint's, not the server's", () => {
   assert.ok(url.host.endsWith(hosts.BFL_HOST_SUFFIX));
   assert.equal(hosts.HOSTS.includes(url.host), false);
 });
+
+test("the AI tag's names: IPTC's and Adobe's, no server host", () => {
+  assert.equal(hosts.AI_SOURCE_TYPE, 'http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia');
+  assert.equal(hosts.XMP_IPTC_EXT, 'http://iptc.org/std/Iptc4xmpExt/2008-02-29/');
+  assert.equal(hosts.XMP_RDF, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
+  assert.equal(hosts.XMP_HEADER, 'http://ns.adobe.com/xap/1.0/');
+  for (const name of [hosts.AI_SOURCE_TYPE, hosts.XMP_IPTC_EXT, hosts.XMP_RDF, hosts.XMP_HEADER]) {
+    assert.equal(hosts.HOSTS.includes(new URL(name).host), false);
+  }
+});
diff --git a/server/trial/bfl.ts b/server/trial/bfl.ts
--- a/server/trial/bfl.ts
+++ b/server/trial/bfl.ts
@@ -82,17 +82,21 @@ interface Variant {
   readonly text: (i: number) => string;
 }
 
-/** One painting: the request, the polling, the image's bytes and the credits. */
-async function paint(
+/**
+ * One painting: the request with [fields] to [model], the polling, the
+ * image's bytes and the credits BFL's reply names. Also the curated set's
+ * (D147, `curated.ts`).
+ */
+export async function paintOnce(
   send: Send,
   key: string,
   clock: Clock,
-  variant: Variant,
-  i: number,
+  model: string,
+  fields: Record<string, string | number>,
 ): Promise<{ png: Buffer; credits: number }> {
   const headers = { 'x-key': key };
-  const body = JSON.stringify({ prompt: variant.text(i), ...variant.size, seed: 1000 + i, output_format: 'png' });
-  const made = await call(send, `${BFL_API_URL}/${variant.model}`, {
+  const body = JSON.stringify({ ...fields, output_format: 'png' });
+  const made = await call(send, `${BFL_API_URL}/${model}`, {
     method: 'POST',
     headers: { ...headers, 'Content-Type': 'application/json' },
     body,
@@ -142,7 +146,8 @@ async function run(send: Send, key: string, folder: string, clock: Clock, varian
     const credits: number[] = [];
     for (const [i] of SCENES.entries()) {
       const start = clock.now();
-      const made = await paint(send, key, clock, variant, i);
+      const fields = { prompt: variant.text(i), ...variant.size, seed: 1000 + i };
+      const made = await paintOnce(send, key, clock, variant.model, fields);
       milliseconds.push(clock.now() - start);
       credits.push(made.credits);
       if (!made.png.subarray(0, 4).equals(PNG)) {
diff --git a/server/trial/curated.ts b/server/trial/curated.ts
new file mode 100644
--- /dev/null
+++ b/server/trial/curated.ts
@@ -0,0 +1,369 @@
+// The curated set of night paintings (D147), painted on the owner's Mac
+// with Black Forest Labs' flux-2-klein-4b on the EU endpoint (D145) in the
+// one style (D146): sixty invented scenes at 1600 x 1200 and New Dream's
+// night sky at 1200 x 336, each made a JPEG of quality 82 with an sRGB
+// profile by macOS's own sips, then given the invisible AI tag by our own
+// code (D123), and checked. Everything is kept in the folder given,
+// outside the repository: the images, `set.json` (each one's attempt, seed
+// and credits, and the credits spent), `set.md` and the contact sheet,
+// `sheet.html`. Every request is counted against a cap of USD 3, repaints
+// included, from the credits BFL's own replies name. The key comes from
+// the environment; nothing sent or received is written anywhere but the
+// images, and an error is a code.
+//   BFL_API_KEY=... node trial/curated.ts paint <folder>
+//   BFL_API_KEY=... node trial/curated.ts repaint <folder> <n or sky>...
+//   node trial/curated.ts proof <folder> <a PNG>
+//   node trial/curated.ts ship <folder> <the app's assets/paintings>
+import { execFile } from 'node:child_process';
+import { createHash } from 'node:crypto';
+import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
+import { join } from 'node:path';
+import { pathToFileURL } from 'node:url';
+import { paintOnce, type Clock, type Send } from './bfl.ts';
+import { aiTagged, hasSrgb, jpegSize, pngSize, withAiTag, type Size } from './jpeg.ts';
+import { SCENES, scenePrompt, skyPrompt } from './scenes.ts';
+
+export const MODEL = 'flux-2-klein-4b';
+export const PAINTING: Size = { width: 1600, height: 1200 };
+// About 1200 x 340 (D147 item 3), at a multiple of 16 [ASSUMED: BFL's
+// pages give no rule; a size it does not paint stops at the size check].
+export const SKY: Size = { width: 1200, height: 336 };
+export const QUALITY = 82;
+// USD 3 (D147 item 4); one credit is USD 0.01 [READ, docs.bfl.ai].
+export const CAP_CREDITS = 300;
+// What one request is counted as until BFL's reply names its cost, and
+// the most one may cost: 1600 x 1200 is about 1.5 credits [READ: 1.4 for
+// the first megapixel, 0.1 for each more]. A reply naming more stops.
+export const RESERVE_CREDITS = 3;
+export const SRGB_PROFILE = '/System/Library/ColorSync/Profiles/sRGB Profile.icc';
+
+/** One item of the set: a painting, 1 to 60, or the sky. */
+export type Item = number | 'sky';
+
+interface Painted {
+  readonly attempt: number;
+  readonly seed: number;
+  readonly credits: number;
+}
+
+export interface SetState {
+  /** Every credit counted so far, failed requests' reserves included. */
+  credits: number;
+  items: Record<string, Painted>;
+}
+
+/** PNG in, JPEG out: macOS's sips on the owner's Mac, a fake in the tests. */
+export type Convert = (png: string, jpg: string) => Promise<void>;
+
+export const ITEMS: readonly Item[] = [...SCENES.map((_, i) => i + 1), 'sky'];
+
+function itemName(item: Item): string {
+  return item === 'sky' ? 'sky' : String(item).padStart(2, '0');
+}
+
+/** A seed of its own for every item and attempt, never one used before. */
+export function seedOf(item: Item, attempt: number): number {
+  return (item === 'sky' ? 29900 : 20000 + item * 100) + attempt;
+}
+
+function sizeOf(item: Item): Size {
+  return item === 'sky' ? SKY : PAINTING;
+}
+
+function promptOf(item: Item): string {
+  return item === 'sky' ? skyPrompt() : scenePrompt(item);
+}
+
+export function fileOf(item: Item, attempt: number): string {
+  return `${itemName(item)}-${attempt}.jpg`;
+}
+
+/** Credits to a millionth, so sums of BFL's figures stay as written. */
+function counted(credits: number): number {
+  return Math.round(credits * 1e6) / 1e6;
+}
+
+function readState(folder: string): SetState {
+  const path = join(folder, 'set.json');
+  if (!existsSync(path)) {
+    return { credits: 0, items: {} };
+  }
+  const state = JSON.parse(readFileSync(path, 'utf8')) as SetState;
+  if (typeof state.credits !== 'number' || typeof state.items !== 'object' || state.items === null) {
+    throw new Error('curated-state');
+  }
+  return state;
+}
+
+function writeState(folder: string, state: SetState): void {
+  writeFileSync(join(folder, 'set.json'), `${JSON.stringify(state, null, 2)}\n`);
+}
+
+/** Whether a finished JPEG is what the set ships: its size, sRGB and the AI tag. */
+export function checkJpeg(jpeg: Buffer, size: Size): void {
+  const got = jpegSize(jpeg);
+  if (got.width !== size.width || got.height !== size.height) {
+    throw new Error('curated-size');
+  }
+  if (!hasSrgb(jpeg)) {
+    throw new Error('curated-srgb');
+  }
+  if (!aiTagged(jpeg)) {
+    throw new Error('curated-tag');
+  }
+}
+
+/** A PNG made a JPEG, tagged and checked, at [jpg]. */
+async function finish(convert: Convert, folder: string, png: Buffer, jpg: string, size: Size): Promise<void> {
+  const work = join(folder, 'work.png');
+  const raw = join(folder, 'work.jpg');
+  writeFileSync(work, png);
+  try {
+    await convert(work, raw);
+    const tagged = withAiTag(readFileSync(raw));
+    checkJpeg(tagged, size);
+    writeFileSync(jpg, tagged);
+  } finally {
+    rmSync(work, { force: true });
+    rmSync(raw, { force: true });
+  }
+}
+
+async function paintItem(
+  send: Send,
+  key: string,
+  clock: Clock,
+  convert: Convert,
+  folder: string,
+  state: SetState,
+  item: Item,
+): Promise<void> {
+  if (state.credits + RESERVE_CREDITS > CAP_CREDITS) {
+    throw new Error('curated-cap');
+  }
+  const name = itemName(item);
+  const attempt = (state.items[name]?.attempt ?? 0) + 1;
+  const seed = seedOf(item, attempt);
+  const size = sizeOf(item);
+  // Counted before the request, so a request that fails after BFL has
+  // charged it is still within the cap.
+  state.credits = counted(state.credits + RESERVE_CREDITS);
+  writeState(folder, state);
+  const made = await paintOnce(send, key, clock, MODEL, { prompt: promptOf(item), ...size, seed });
+  if (!Number.isFinite(made.credits) || made.credits < 0) {
+    throw new Error('curated-cost');
+  }
+  state.credits = counted(state.credits + made.credits - RESERVE_CREDITS);
+  writeState(folder, state);
+  if (made.credits > RESERVE_CREDITS) {
+    throw new Error('curated-cost');
+  }
+  if (pngSize(made.png) === null) {
+    throw new Error('curated-not-png');
+  }
+  // The JPEG's check stops a painting of another size than asked.
+  await finish(convert, folder, made.png, join(folder, fileOf(item, attempt)), size);
+  state.items[name] = { attempt, seed, credits: made.credits };
+  writeState(folder, state);
+}
+
+/** Every item the folder does not hold yet, in order; a stopped run goes on from where it stopped. */
+export async function paintSet(send: Send, key: string, clock: Clock, convert: Convert, folder: string): Promise<void> {
+  mkdirSync(folder, { recursive: true });
+  const state = readState(folder);
+  try {
+    for (const item of ITEMS) {
+      if (state.items[itemName(item)] === undefined) {
+        await paintItem(send, key, clock, convert, folder, state, item);
+      }
+    }
+  } finally {
+    writeReport(folder, state);
+  }
+}
+
+/** The items named, each painted again with its next seed. */
+export async function repaint(
+  send: Send,
+  key: string,
+  clock: Clock,
+  convert: Convert,
+  folder: string,
+  items: readonly Item[],
+): Promise<void> {
+  const state = readState(folder);
+  for (const item of items) {
+    if (state.items[itemName(item)] === undefined) {
+      throw new Error('curated-usage');
+    }
+  }
+  try {
+    for (const item of items) {
+      await paintItem(send, key, clock, convert, folder, state, item);
+    }
+  } finally {
+    writeReport(folder, state);
+  }
+}
+
+/** A PNG through the same steps as a painting, with no request: sips's proof. */
+export async function proof(convert: Convert, folder: string, png: Buffer): Promise<void> {
+  const size = pngSize(png);
+  if (size === null) {
+    throw new Error('curated-not-png');
+  }
+  mkdirSync(folder, { recursive: true });
+  const jpg = join(folder, 'proof.jpg');
+  await finish(convert, folder, png, jpg, size);
+  const bytes = readFileSync(jpg).length;
+  writeFileSync(
+    join(folder, 'proof.md'),
+    `Proof: ${size.width} x ${size.height}, sRGB, tagged, ${bytes} bytes, quality ${QUALITY}.\n`,
+  );
+}
+
+/**
+ * The set, each item's last attempt, copied into the app's paintings
+ * folder as `01.jpg` to `60.jpg` and `sky.jpg`, with `fingerprints.txt`
+ * as shasum writes it. Refused unless every item is painted and checks,
+ * and unless the folder holds nothing else.
+ */
+export function ship(folder: string, target: string): void {
+  const state = readState(folder);
+  const names = ITEMS.map((item) => `${itemName(item)}.jpg`);
+  const extra = readdirSync(target).filter((f) => !names.includes(f) && f !== 'fingerprints.txt');
+  if (extra.length > 0) {
+    throw new Error('curated-ship-folder');
+  }
+  const sources = ITEMS.map((item) => {
+    const painted = state.items[itemName(item)];
+    if (painted === undefined) {
+      throw new Error('curated-ship-missing');
+    }
+    const from = join(folder, fileOf(item, painted.attempt));
+    checkJpeg(readFileSync(from), sizeOf(item));
+    return from;
+  });
+  const lines = sources.map((from, i) => {
+    const name = names[i] ?? '';
+    copyFileSync(from, join(target, name));
+    return `${createHash('sha256').update(readFileSync(join(target, name))).digest('hex')}  ${name}\n`;
+  });
+  writeFileSync(join(target, 'fingerprints.txt'), lines.join(''));
+}
+
+function escape(text: string): string {
+  return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
+}
+
+/** `set.md`, what was spent, and `sheet.html`, every item's last attempt with its crops. */
+function writeReport(folder: string, state: SetState): void {
+  const painted = ITEMS.filter((item) => state.items[itemName(item)] !== undefined);
+  const repainted = painted.filter((item) => (state.items[itemName(item)]?.attempt ?? 1) > 1);
+  writeFileSync(
+    join(folder, 'set.md'),
+    [
+      '# The curated set',
+      '',
+      `Painted: ${painted.length} of ${ITEMS.length}. Painted again: ${repainted.map(itemName).join(', ') || 'none'}.`,
+      `Credits counted: ${state.credits.toFixed(2)} of ${CAP_CREDITS}, USD ${(state.credits / 100).toFixed(3)}.`,
+      '',
+    ].join('\n'),
+  );
+  const cards = painted.map((item) => {
+    const p = state.items[itemName(item)] as Painted;
+    const src = escape(fileOf(item, p.attempt));
+    const crops =
+      item === 'sky'
+        ? `<div class="crop pill" style="background-image:url('${src}')"></div>`
+        : `<div class="crop row" style="background-image:url('${src}')"></div>` +
+          `<div class="crop header" style="background-image:url('${src}')"></div>`;
+    const label = `${itemName(item)} · attempt ${p.attempt} · ${escape(promptOf(item).split(',')[0] ?? '')}`;
+    return `<figure><img src="${src}" alt=""><figcaption>${label}</figcaption>${crops}</figure>`;
+  });
+  writeFileSync(
+    join(folder, 'sheet.html'),
+    [
+      '<!doctype html><meta charset="utf-8"><title>The curated set</title>',
+      '<style>',
+      'body{font:14px system-ui;background:#222;color:#eee;margin:16px}',
+      'main{display:grid;grid-template-columns:repeat(auto-fill,minmax(400px,1fr));gap:16px}',
+      'figure{margin:0}img{width:100%;display:block}',
+      '.crop{background-size:cover;background-position:center;margin-top:6px;border-radius:12px}',
+      '.row{width:330px;height:64px}.header{width:390px;height:287px;border-radius:0}',
+      '.pill{width:330px;height:50px}',
+      '</style>',
+      `<main>${cards.join('')}</main>`,
+      '',
+    ].join('\n'),
+  );
+}
+
+export interface Args {
+  readonly mode: 'paint' | 'repaint' | 'proof' | 'ship';
+  readonly folder: string;
+  readonly key?: string;
+  readonly items?: readonly Item[];
+  readonly path?: string;
+}
+
+function item(word: string): Item {
+  if (word === 'sky') {
+    return 'sky';
+  }
+  const n = Number(word);
+  if (!/^[0-9]+$/.test(word) || n < 1 || n > SCENES.length) {
+    throw new Error('curated-usage');
+  }
+  return n;
+}
+
+export function parseArgs(env: Readonly<Record<string, string | undefined>>, argv: readonly string[]): Args {
+  const [mode, folder, ...rest] = argv;
+  if (folder === undefined || folder === '') {
+    throw new Error('curated-usage');
+  }
+  const key = env.BFL_API_KEY;
+  const keyed = key !== undefined && key !== '';
+  if (mode === 'paint' && rest.length === 0 && keyed) {
+    return { mode, folder, key };
+  }
+  if (mode === 'repaint' && rest.length > 0 && keyed) {
+    const items = rest.map(item);
+    if (new Set(items).size !== items.length) {
+      throw new Error('curated-usage');
+    }
+    return { mode, folder, key, items };
+  }
+  if ((mode === 'proof' || mode === 'ship') && rest.length === 1 && rest[0] !== '') {
+    return { mode, folder, path: rest[0] };
+  }
+  throw new Error('curated-usage');
+}
+
+/** macOS's sips: a JPEG of quality 82, with the sRGB profile when the PNG names none. */
+export function sipsArgs(png: string, jpg: string): string[] {
+  return ['-s', 'format', 'jpeg', '-s', 'formatOptions', String(QUALITY), '-E', SRGB_PROFILE, png, '--out', jpg];
+}
+
+if (process.argv[1] !== undefined && import.meta.url === pathToFileURL(process.argv[1]).href) {
+  const args = parseArgs(process.env, process.argv.slice(2));
+  const convert: Convert = (png, jpg) =>
+    new Promise((done, fail) => {
+      execFile('/usr/bin/sips', sipsArgs(png, jpg), (error) => (error ? fail(new Error('curated-sips')) : done()));
+    });
+  const send: Send = async (url, init) => {
+    const r = await fetch(url, { ...init, signal: AbortSignal.timeout(60000) });
+    return { status: r.status, json: () => r.json(), bytes: async () => Buffer.from(await r.arrayBuffer()) };
+  };
+  const clock: Clock = { now: () => Date.now(), sleep: (ms) => new Promise((r) => setTimeout(r, ms)) };
+  if (args.mode === 'paint') {
+    await paintSet(send, args.key ?? '', clock, convert, args.folder);
+  } else if (args.mode === 'repaint') {
+    await repaint(send, args.key ?? '', clock, convert, args.folder, args.items ?? []);
+  } else if (args.mode === 'proof') {
+    await proof(convert, args.folder, readFileSync(args.path ?? ''));
+  } else {
+    ship(args.folder, args.path ?? '');
+  }
+}
diff --git a/server/trial/jpeg.ts b/server/trial/jpeg.ts
new file mode 100644
--- /dev/null
+++ b/server/trial/jpeg.ts
@@ -0,0 +1,123 @@
+// What the curated set's painter reads and writes inside its images
+// (D147), in plain bytes, with no package: a PNG's size; a JPEG's size,
+// its colour profile and its AI tag; and the tag itself, written by our
+// own code (D123): an XMP packet naming the IPTC digital source type
+// "trainedAlgorithmicMedia", in an APP1 segment after the JPEG's start.
+import { AI_SOURCE_TYPE, XMP_HEADER, XMP_IPTC_EXT, XMP_RDF } from '../src/hosts.ts';
+
+export interface Size {
+  readonly width: number;
+  readonly height: number;
+}
+
+const PNG_SIGNATURE = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
+
+/** A PNG's width and height from its header, or null when it is no PNG. */
+export function pngSize(png: Buffer): Size | null {
+  if (png.length < 24 || !png.subarray(0, 8).equals(PNG_SIGNATURE) || png.toString('latin1', 12, 16) !== 'IHDR') {
+    return null;
+  }
+  return { width: png.readUInt32BE(16), height: png.readUInt32BE(20) };
+}
+
+interface Segment {
+  readonly marker: number;
+  /** Where the marker's 0xFF stands. */
+  readonly at: number;
+  /** The segment's bytes after its length. */
+  readonly data: Buffer;
+}
+
+/** The segments from the start to the scan, or 'curated-jpeg' when malformed. */
+function segments(jpeg: Buffer): Segment[] {
+  if (jpeg.length < 4 || jpeg[0] !== 0xff || jpeg[1] !== 0xd8) {
+    throw new Error('curated-jpeg');
+  }
+  const found: Segment[] = [];
+  let at = 2;
+  for (;;) {
+    if (at + 4 > jpeg.length || jpeg[at] !== 0xff) {
+      throw new Error('curated-jpeg');
+    }
+    const marker = jpeg[at + 1] ?? 0;
+    const length = jpeg.readUInt16BE(at + 2);
+    if (length < 2 || at + 2 + length > jpeg.length) {
+      throw new Error('curated-jpeg');
+    }
+    found.push({ marker, at, data: jpeg.subarray(at + 4, at + 2 + length) });
+    if (marker === 0xda) {
+      return found;
+    }
+    at += 2 + length;
+  }
+}
+
+// The frame markers that carry the size: SOF0 to SOF15 but DHT, JPG and DAC.
+const FRAMES = new Set([0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf]);
+
+/** A JPEG's width and height from its frame header. */
+export function jpegSize(jpeg: Buffer): Size {
+  const frame = segments(jpeg).find((s) => FRAMES.has(s.marker));
+  if (frame === undefined || frame.data.length < 5) {
+    throw new Error('curated-jpeg');
+  }
+  return { width: frame.data.readUInt16BE(3), height: frame.data.readUInt16BE(1) };
+}
+
+const ICC = Buffer.from('ICC_PROFILE\0', 'latin1');
+const SRGB_ASCII = Buffer.from('sRGB', 'latin1');
+const SRGB_UTF16 = Buffer.from([0, 0x73, 0, 0x52, 0, 0x47, 0, 0x42]);
+
+/** Whether the JPEG carries an sRGB colour profile (an APP2 ICC profile naming sRGB). */
+export function hasSrgb(jpeg: Buffer): boolean {
+  return segments(jpeg).some(
+    (s) =>
+      s.marker === 0xe2 &&
+      s.data.subarray(0, ICC.length).equals(ICC) &&
+      (s.data.includes(SRGB_ASCII) || s.data.includes(SRGB_UTF16)),
+  );
+}
+
+const XMP_ID = Buffer.from(`${XMP_HEADER}\0`, 'latin1');
+
+/** The AI tag's XMP packet: the IPTC digital source type, and nothing else. */
+export function aiPacket(): string {
+  return [
+    '<?xpacket begin="﻿" id="W5M0MpCehiHzreSzNTczkc9d"?>',
+    '<x:xmpmeta xmlns:x="adobe:ns:meta/">',
+    `<rdf:RDF xmlns:rdf="${XMP_RDF}">`,
+    `<rdf:Description rdf:about="" xmlns:Iptc4xmpExt="${XMP_IPTC_EXT}"`,
+    ` Iptc4xmpExt:DigitalSourceType="${AI_SOURCE_TYPE}"/>`,
+    '</rdf:RDF>',
+    '</x:xmpmeta>',
+    '<?xpacket end="r"?>',
+  ].join('');
+}
+
+function xmpSegments(jpeg: Buffer): Segment[] {
+  return segments(jpeg).filter((s) => s.marker === 0xe1 && s.data.subarray(0, XMP_ID.length).equals(XMP_ID));
+}
+
+/** Whether the JPEG carries the AI tag: an XMP packet naming the source type. */
+export function aiTagged(jpeg: Buffer): boolean {
+  const named = `Iptc4xmpExt:DigitalSourceType="${AI_SOURCE_TYPE}"`;
+  return xmpSegments(jpeg).some((s) => s.data.toString('utf8', XMP_ID.length).includes(named));
+}
+
+/**
+ * The JPEG with the AI tag written in: an APP1 segment after the start and
+ * after a JFIF APP0 if one leads. One that already holds XMP is refused
+ * ('curated-xmp'): nothing else's packet is overwritten or doubled.
+ */
+export function withAiTag(jpeg: Buffer): Buffer {
+  const found = segments(jpeg);
+  if (xmpSegments(jpeg).length > 0) {
+    throw new Error('curated-xmp');
+  }
+  const first = found[0];
+  const after = first !== undefined && first.marker === 0xe0 ? first.at + 4 + first.data.length : 2;
+  const payload = Buffer.concat([XMP_ID, Buffer.from(aiPacket(), 'utf8')]);
+  const head = Buffer.from([0xff, 0xe1, 0, 0]);
+  head.writeUInt16BE(payload.length + 2, 2);
+  return Buffer.concat([jpeg.subarray(0, after), head, payload, jpeg.subarray(after)]);
+}
diff --git a/server/trial/scenes.ts b/server/trial/scenes.ts
new file mode 100644
--- /dev/null
+++ b/server/trial/scenes.ts
@@ -0,0 +1,90 @@
+// The curated set's scenes (D147): invented scenery written by Claude Code,
+// one painting each, landscape, sky, weather, season, light and mood only,
+// with no person, no text and nothing from any dream (R2). The owner
+// rejects any on the contact sheet; a rejected one is painted again from
+// the same scene with a new seed. Each prompt is its scene, the framing and
+// the one style (STYLE, D146), in that order.
+import { STYLE } from './measure.ts';
+
+/** The framing every painting shares: the subject in the middle band (D147 item 2). */
+export const FRAME = 'wide view, the subject across the middle band, no text';
+
+/** New Dream's night sky (D112; D147 item 3): no moon, which is drawn in code. */
+export const SKY_SCENE = 'a deep blue night sky of small soft stars, no moon';
+
+export const SCENES = [
+  'a wheat field at dawn under a pale gold sky',
+  'a lavender field beneath rolling summer clouds',
+  'a lone pine on a cliff above a calm sea',
+  'a frozen lake under a pink winter sunrise',
+  'snowy hills under a quiet grey sky',
+  'an orchard in white blossom after spring rain',
+  'a mountain lake reflecting autumn birches',
+  'a misty valley at first light',
+  'a wide river bend under evening clouds',
+  'a field of red poppies under a windy sky',
+  'a birch forest in golden autumn light',
+  'soft desert dunes under a violet dusk',
+  'a rocky coast with waves under a stormy sky',
+  'a meadow of wildflowers under a bright noon sky',
+  'a moonlit bay with still dark water',
+  'cypress trees against a swirling night sky',
+  'a snowy pine forest under starlight',
+  'a green valley after a summer storm, a rainbow above',
+  'a quiet harbour of small boats at dusk',
+  'a hillside vineyard in late autumn colours',
+  'tall grass bending in a warm evening wind',
+  'a waterfall in a gorge full of ferns',
+  'a sunflower field under a deep blue sky',
+  'a pine island in a still northern lake',
+  'a canyon glowing red at sunset',
+  'a foggy marsh with reeds at dawn',
+  'a lighthouse on a headland under drifting clouds',
+  'an olive grove on a hillside in silver light',
+  'a mountain range under the northern lights',
+  'a path through a beech wood in spring green',
+  'a farmhouse among wheat fields under a summer sky',
+  'a frosty meadow under a low winter sun',
+  'a lagoon with palm trees under a peach sunset',
+  'a heather moor under a moving grey sky',
+  'a glacier valley under a clear cold sky',
+  'a field of tulips under spring clouds',
+  'willows on a riverbank on a still afternoon',
+  'terraced rice fields in soft morning mist',
+  'turquoise water below white cliffs',
+  'a pond with water lilies in a warm haze',
+  'a thunderstorm rolling over a wide plain',
+  'a crescent moon over silent snowy fields',
+  'a cherry tree in bloom beside a stream',
+  'dunes and sea grass by a grey shore',
+  'a maple forest in deep red autumn leaves',
+  'a stone bridge over a calm river at twilight',
+  'a high alpine meadow below distant peaks',
+  'a full moon rising over a dark sea',
+  'haystacks in a field in late summer light',
+  'a mountain village under fresh snow at dusk',
+  'low clouds drifting over green hills',
+  'a starry sky above a quiet wheat field',
+  'mist over a lake among dark fir trees',
+  'a sunlit almond orchard in early spring',
+  'a rainy evening over a wide plain',
+  'a sea of clouds below a mountain ridge',
+  'a barley field under a golden evening sky',
+  'a winter river winding through bare trees',
+  'the first light of dawn over a calm sea',
+  'a hill of olive trees under a turquoise sky',
+] as const;
+
+/** The prompt for painting [n], 1 to 60. */
+export function scenePrompt(n: number): string {
+  const scene = SCENES[n - 1];
+  if (scene === undefined) {
+    throw new Error('curated-scene');
+  }
+  return `${scene}, ${FRAME}, ${STYLE}`;
+}
+
+/** The prompt for New Dream's night sky. */
+export function skyPrompt(): string {
+  return `${SKY_SCENE}, ${STYLE}`;
+}
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S102, D147), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -258,6 +258,59 @@ ROWS = [
     ('S81', 'trial/bfl.ts',
      "const GIVE_UP_MS = 120000;", "const GIVE_UP_MS = 1200000;",
      'test', 'a result not in two minutes stops the test'),
+    # curated-set, Task 2 (D147): the curated set's painter and its AI tag.
+    ('S86', 'trial/jpeg.ts',
+     '(s.data.includes(SRGB_ASCII) || s.data.includes(SRGB_UTF16))', 's.data.includes(SRGB_UTF16)',
+     'test', 'sRGB: an ICC profile naming it, in either encoding'),
+    ('S87', 'trial/jpeg.ts',
+     'if (xmpSegments(jpeg).length > 0) {', 'if (false) {',
+     'test', 'a JPEG already holding XMP is refused'),
+    ('S88', 'trial/jpeg.ts',
+     'first.marker === 0xe0 ? first.at + 4 + first.data.length : 2', 'false ? 0 : 2',
+     'test', 'the tag goes in after JFIF and is read back'),
+    ('S89', 'trial/jpeg.ts',
+     '.toString(\'utf8\', XMP_ID.length).includes(named))', '.length > 0)',
+     'test', 'an untagged JPEG, or another packet, is not tagged'),
+    ('S90', 'trial/jpeg.ts',
+     '{ width: frame.data.readUInt16BE(3), height: frame.data.readUInt16BE(1) }',
+     '{ width: frame.data.readUInt16BE(1), height: frame.data.readUInt16BE(3) }',
+     'test', "a JPEG's size from its frame header"),
+    ('S91', 'trial/curated.ts',
+     'if (state.credits + RESERVE_CREDITS > CAP_CREDITS) {', 'if (state.credits > CAP_CREDITS) {',
+     'test', 'the cap: no request that could pass USD 3'),
+    ('S92', 'trial/curated.ts',
+     '  state.credits = counted(state.credits + RESERVE_CREDITS);\n', '',
+     'test', 'a stopped run goes on from where it stopped'),
+    ('S93', 'trial/curated.ts',
+     'if (made.credits > RESERVE_CREDITS) {', 'if (false) {',
+     'test', 'a reply naming no cost, or too much, stops'),
+    ('S94', 'trial/curated.ts',
+     ": 20000 + item * 100) + attempt;", ": 20000 + item * 100) + 1;",
+     'test', 'a repaint takes the next seed and keeps the earlier image'),
+    ('S95', 'trial/curated.ts',
+     'if (!aiTagged(jpeg)) {', 'if (false) {',
+     'test', 'a finished JPEG is checked for size, sRGB and the tag'),
+    ('S96', 'trial/curated.ts',
+     'const tagged = withAiTag(readFileSync(raw));', 'const tagged = readFileSync(raw);',
+     'test', 'each finished painting is a tagged sRGB JPEG of its size'),
+    ('S97', 'trial/curated.ts',
+     'if (extra.length > 0) {', 'if (false) {',
+     'test', 'ship refuses a set not finished, or a folder holding more'),
+    ('S98', 'trial/curated.ts',
+     'export const QUALITY = 82;', 'export const QUALITY = 90;',
+     'test', 'sips makes quality 82 with the sRGB profile'),
+    ('S99', 'trial/curated.ts',
+     'if (state.items[itemName(item)] === undefined) {\n        await', 'if (true) {\n        await',
+     'test', 'a stopped run goes on from where it stopped'),
+    ('S100', 'trial/bfl.ts',
+     "JSON.stringify({ ...fields, output_format: 'png' })", 'JSON.stringify({ ...fields })',
+     'test', 'the set: sixty paintings and the sky, sizes, seeds, the model'),
+    ('S101', 'trial/curated.ts',
+     'const src = escape(fileOf(item, p.attempt));', 'const src = escape(fileOf(item, 1));',
+     'test', 'the contact sheet shows each last attempt with its crops'),
+    ('S102', 'trial/curated.ts',
+     'const from = join(folder, fileOf(item, painted.attempt));', 'const from = join(folder, fileOf(item, 1));',
+     'test', 'ship: the last attempts, renamed, with their fingerprints'),
 ]
 
 
```

Commit: `The curated set's painter: sixty invented scenes, the USD 3 cap, the AI tag (D147, D123)`

### Task 3 · [OWNER] The JPEG step's proof, free (Terminal)

One of the BFL test's invented paintings through `sips`, the tag and the check; no request, no key, no cost. This
proves on your Mac what this sandbox could not run (`sips` cannot write here).

```
cd ~/Developer/soul-dreams-app/server && node trial/curated.ts proof ~/Desktop/curated-proof ~/Desktop/image-trial/bfl/flux-2-klein-4b/1.png && cat ~/Desktop/curated-proof/proof.md
```

As first run (1024 x 1024 at quality 82): `Proof: 1024 x 1024, sRGB, tagged, 740928 bytes, quality 82.`, about 81 MB for
sixty, so D148 followed. Task 3 is run again at D148's settings, by the script
`.scratch/for-build-chat/curated-d148-proof.sh`: the same image enlarged to 1280 x 960 (what D148 asked), and, as a
cross-check at the image's own detail, a 1024 x 768 crop of it (no enlargement; times 1.5625 for 1280 x 960). It
prints both proofs and the projected size for sixty; answer question 1 on the larger. A stop prints
`Error: curated-<code>` (`curated-sips`: `sips` refused; `curated-srgb`: the profile was not embedded;
`curated-profile`: the OS's profile file is missing or no ICC profile): bring the code. Then
`rm -rf ~/Desktop/curated-proof`.

### Task 4 · [OWNER] The painting, the contact sheet and the repaints (Terminal, browser)

The BFL key is already in Parameter Store (`/souldreams/trial/bfl-key`, D145). Read the sixty scenes in Task 2's
block (`server/trial/scenes.ts`) first; a scene you want changed is a word to the Build chat before this run.

```
cd ~/Developer/soul-dreams-app/server && BFL_API_KEY=$(aws ssm get-parameter --name /souldreams/trial/bfl-key --with-decryption --query Parameter.Value --output text --profile soul-dreams-workload --region eu-north-1) node trial/curated.ts paint ~/Desktop/curated-set ; cat ~/Desktop/curated-set/set.md
```

Expected after about six minutes: `Painted: 61 of 61. Painted again: none.` and `Credits counted: <85 to 92> of 300,
USD <0.85 to 0.92>.` A stop prints `Error: <code>`; run the same command again and it goes on from where it stopped
(a `bfl-http-4xx` or `curated-cost` is brought to the Build chat instead: nothing more is sent until then).

Then open the contact sheet:

```
open ~/Desktop/curated-set/sheet.html
```

Each painting whole, with its thin row band and its header crop beneath; the sky last, in a pill (the real pill is
narrower, about 135 x 50, its middle). Look for: a person or a figure, any letters or text, anything that reads as
more than scenery, a subject not in the middle band, a crop that loses it, a painting too like another. Write down
the numbers you reject, then:

```
cd ~/Developer/soul-dreams-app/server && BFL_API_KEY=$(aws ssm get-parameter --name /souldreams/trial/bfl-key --with-decryption --query Parameter.Value --output text --profile soul-dreams-workload --region eu-north-1) node trial/curated.ts repaint ~/Desktop/curated-set 7 23 sky ; cat ~/Desktop/curated-set/set.md
```

with your numbers (1 to 60, or `sky`) in place of `7 23 sky`. Reload the sheet and repeat until you accept all
sixty-one. `curated-cap` means the USD 3 is reached: bring the numbers still rejected. Bring `set.md` and your
verdict in your own words. Nothing from any night is ever shown or sent here (R2).

### Task 5 · [OWNER] The set into the app (Terminal)

```
cd ~/Developer/soul-dreams-app && mkdir -p app/assets/paintings && (cd server && node trial/curated.ts ship ~/Desktop/curated-set ../app/assets/paintings) && ls app/assets/paintings | wc -l && du -sh app/assets/paintings && git status --short
```

Expected: `62`, the folder's size (bring it: it is the app's growth), and `?? app/assets/paintings/`. A stop prints
`Error: curated-<code>`: `curated-ship-missing` (an item not painted), `curated-ship-folder` (the folder holds
something else), `curated-tag`, `curated-srgb` or `curated-size` (a file changed since it was painted): bring it.
Do not commit; Task 6 does. Keep `~/Desktop/curated-set` until the merge.

### Task 6 · The app shows the set (D147; D110; D112; D113)

Precondition: Task 5's 62 files in `app/assets/paintings/`, untracked. `NightArt` and `NightSky` show the set;
the placeholders and the code-drawn stars go; New Dream's words on the date's shade; the pubspec bundles the folder;
the count is 60.

Tests: `test/journal/pages/paintings_test.dart` (6, new), `night_art_test.dart` (rewritten, 7),
`date_shade_test.dart` (on the real set), `journal_page_test.dart` (2 changed). `fvm flutter test --no-pub`: `+760:
All tests passed!`

**The real set is a gate here.** If `row: every painting, the date reads at 4.5 to 1`, `header: every painting, the
date reads at 4.5 to 1` or `New Dream's words read at 4.5 to 1 over the sky` fails, or `each painting is drawn, not
the gradient alone`, stop (R14) and report the painting numbers in the failure's reason: the owner repaints those
(Task 4's `repaint`, then Task 5 again), and no test or value is changed. So too if `without the shade, a light
painting would fail the same test` fails: then no painting is light enough under the date to show the measure bites,
which is a question, not a fix.

Rows: `python3 -I -B tool/app_mutations.py --rows A368,A370,A371,A372,A408,A418,A419,A420,A421,A422,A423,A424,A772,A773,A774,A775,A776,A777,A778,A779,A780,A781,A782`
→ `app mutations: 23 run, 23 caught`; and the changed files',
`python3 -I -B tool/app_mutations.py --files lib/journal/pages/night_art.dart,lib/journal/pages/journal_page.dart,pubspec.yaml`
→ `app mutations: 82 run, 82 caught`.

```
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -507,7 +507,9 @@ class _Magnifier extends CustomPainter {
 }
 
 /// New Dream (D110, D112): a pill on a night sky, its words in the button
-/// type over it, opening the typing screen; heard as a button.
+/// type over it, opening the typing screen; heard as a button. Over the
+/// set's sky (D147 item 3) the words stand on the date's soft shade (D113),
+/// a stand-in, so they read at 4.5 to 1 over its stars.
 class _NewDream extends StatelessWidget {
   const _NewDream({required this.onPressed});
 
@@ -524,7 +526,9 @@ class _NewDream extends StatelessWidget {
         child: NightSky(
           child: Padding(
             padding: StandIns.buttonPadding,
-            child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),
+            child: DateShade(
+              child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),
+            ),
           ),
         ),
       ),
diff --git a/app/lib/journal/pages/night_art.dart b/app/lib/journal/pages/night_art.dart
--- a/app/lib/journal/pages/night_art.dart
+++ b/app/lib/journal/pages/night_art.dart
@@ -1,37 +1,19 @@
 // A night's picture (D110; head's messages 24 and 25): the painted gradient
-// for an unread night, or one painting of the set shipped in the app for a
-// read one. The curated set (about 60, the founder's) is not filed yet, so a
-// few placeholder paintings stand in its place, drawn here in plain layered
-// colour: no file, no package, no words. When the set comes, it replaces
-// `paintings` and the placeholders; nothing else changes. The gradient's
-// colours and the text over a picture are stand-ins until Product sets them
-// (P13): the dark theme's bubble gradient and text, in both themes. Heard
-// as nothing: decoration. Also here: the night sky inside New Dream (D112)
-// and the soft shade behind a date over a painting (D113), both stand-ins.
-import 'dart:math';
-
+// for an unread night, or one painting of the curated set shipped in the
+// app for a read one (D147): sixty paintings in `assets/paintings/`, each
+// fingerprinted (G2) and carrying the invisible AI tag (D123), shown to
+// cover its box from the middle, so a row shows a thin band and the header a
+// wide crop. The gradient lies beneath, so nothing flashes while a painting
+// loads. The gradient's colours and the text over a picture are stand-ins
+// until Product sets them (P13): the dark theme's bubble gradient and text,
+// in both themes. Heard as nothing: decoration. Also here: the night sky
+// inside New Dream (D112; D147 item 3, the set's strip) and the soft shade
+// behind a date over a painting (D113), a stand-in.
 import 'package:flutter/widgets.dart';
 
 import '../../design/tokens.g.dart';
 import '../night_look.dart';
 
-/// One placeholder painting: a sky from top to foot, a soft light in it at
-/// [lightX] across, a far ridge and a near one.
-typedef _Placeholder = ({Color top, Color foot, Color light, double lightX, Color far, Color near});
-
-const _placeholders = <_Placeholder>[
-  // Dusk.
-  (top: Color(0xFF2E2A5C), foot: Color(0xFF8C6A9E), light: Color(0xFFF2D8A7), lightX: 0.72, far: Color(0xFF4A3F6B), near: Color(0xFF231E3D)),
-  // Dawn.
-  (top: Color(0xFF6E7FA8), foot: Color(0xFFE9B9A0), light: Color(0xFFFFF1D6), lightX: 0.28, far: Color(0xFF8A7F9C), near: Color(0xFF4F4866)),
-  // The sea.
-  (top: Color(0xFF1F4E5F), foot: Color(0xFF7FB3B0), light: Color(0xFFE8F1E4), lightX: 0.6, far: Color(0xFF2F6B6E), near: Color(0xFF173B45)),
-  // The forest.
-  (top: Color(0xFF34503A), foot: Color(0xFFB7B98A), light: Color(0xFFF4E9C1), lightX: 0.4, far: Color(0xFF3F5E3F), near: Color(0xFF1E3322)),
-  // The night.
-  (top: Color(0xFF0E1433), foot: Color(0xFF3B4A7A), light: Color(0xFFDCE3F2), lightX: 0.8, far: Color(0xFF26305A), near: Color(0xFF111833)),
-];
-
 class NightArt extends StatelessWidget {
   const NightArt(this.look, {super.key, this.child});
 
@@ -40,8 +22,14 @@ class NightArt extends StatelessWidget {
   /// What stands over the picture (the date), if anything.
   final Widget? child;
 
-  /// How many paintings the set holds: the placeholders, for now.
-  static const paintings = 5;
+  /// How many paintings the set holds (D147).
+  static const paintings = 60;
+
+  /// Painting [index]'s file: `01.jpg` to `60.jpg`.
+  static String asset(int index) {
+    final number = (index + 1).toString().padLeft(2, '0');
+    return 'assets/paintings/$number.jpg';
+  }
 
   /// The painted gradient, top to foot.
   static final gradient = [DarkColours.surface.colour!, DarkColours.surface.colourEnd!];
@@ -49,16 +37,49 @@ class NightArt extends StatelessWidget {
   /// The colour of words over a picture.
   static final over = DarkColours.text.colour!;
 
-  /// The top of painting [index]'s sky (each painting's own).
-  static Color sky(int index) => _placeholders[index].top;
+  // The gradient and the painting add nothing a screen reader hears; what
+  // stands over them is heard as itself. What stands over the picture is
+  // clipped to it, so a soft edge (the date's shade) never runs past the
+  // picture's own.
+  @override
+  Widget build(BuildContext context) {
+    final look = this.look;
+    return ClipRect(
+      // The box's own constraints pass to what stands over it, as before
+      // the set: a row keeps its least height.
+      child: Stack(
+        alignment: Alignment.topLeft,
+        fit: StackFit.passthrough,
+        children: [
+          Positioned.fill(child: CustomPaint(painter: _GradientPainter())),
+          if (look is Painting) Positioned.fill(child: _Cover(asset(look.index))),
+          child ?? const SizedBox.expand(),
+        ],
+      ),
+    );
+  }
+}
+
+/// An image of the set covering its box from the middle, decoded no larger
+/// than the box needs on this screen, and silent.
+class _Cover extends StatelessWidget {
+  const _Cover(this.asset);
+
+  final String asset;
 
-  // A painter adds nothing a screen reader hears; what stands over it is
-  // heard as itself.
-  // What stands over the picture is clipped to it, so a soft edge (the
-  // date's shade) never runs past the picture's own.
   @override
-  Widget build(BuildContext context) =>
-      ClipRect(child: CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand()));
+  Widget build(BuildContext context) => LayoutBuilder(
+    builder: (context, box) {
+      final width = (box.maxWidth * MediaQuery.devicePixelRatioOf(context)).ceil();
+      return Image(
+        image: ResizeImage.resizeIfNeeded(width > 0 ? width : null, null, AssetImage(asset)),
+        fit: BoxFit.cover,
+        alignment: Alignment.center,
+        excludeFromSemantics: true,
+        gaplessPlayback: true,
+      );
+    },
+  );
 }
 
 /// A soft dark shade behind a night's date over a painting (D113), so the
@@ -107,103 +128,46 @@ class _ShadePainter extends CustomPainter {
   bool shouldRepaint(_ShadePainter old) => false;
 }
 
-/// New Dream's night sky (D112): the painted gradient with a few stars, a
-/// stand-in drawn in code until the founder supplies the image. The stars
-/// stand in the pill's own padding, above and below the words, never behind
-/// them. Heard as nothing, like the picture.
+/// New Dream's night sky (D112; D147 item 3): the set's strip covering the
+/// pill from the middle, over the painted gradient. Heard as nothing, like
+/// the picture.
 class NightSky extends StatelessWidget {
   const NightSky({super.key, this.child});
 
   /// What stands over the sky (New Dream's words).
   final Widget? child;
 
-  /// How bright a star is.
-  static const double starAlpha = 0.85;
-
-  /// A star: [x] across as a share of the width, [dy] down from the top edge
-  /// (or, when negative, up from the foot) in logical pixels, radius [r].
-  static const stars = <({double x, double dy, double r})>[
-    (x: 0.06, dy: 7, r: 1.2),
-    (x: 0.17, dy: -6, r: 1.0),
-    (x: 0.26, dy: 5, r: 0.9),
-    (x: 0.38, dy: -8, r: 1.4),
-    (x: 0.49, dy: 6, r: 1.0),
-    (x: 0.58, dy: -5, r: 0.9),
-    (x: 0.69, dy: 8, r: 1.3),
-    (x: 0.78, dy: -7, r: 1.0),
-    (x: 0.88, dy: 5, r: 1.1),
-    (x: 0.95, dy: -6, r: 1.2),
-  ];
+  /// The strip's file.
+  static const asset = 'assets/paintings/sky.jpg';
 
   @override
-  Widget build(BuildContext context) =>
-      CustomPaint(painter: _SkyPainter(), child: child ?? const SizedBox.expand());
+  Widget build(BuildContext context) => Stack(
+    alignment: Alignment.topLeft,
+    fit: StackFit.passthrough,
+    children: [
+      Positioned.fill(child: CustomPaint(painter: _GradientPainter())),
+      const Positioned.fill(child: _Cover(asset)),
+      child ?? const SizedBox.expand(),
+    ],
+  );
 }
 
-class _SkyPainter extends CustomPainter {
+/// The painted gradient, top to foot.
+class _GradientPainter extends CustomPainter {
   @override
   void paint(Canvas canvas, Size size) {
     final box = Offset.zero & size;
-    canvas.drawRect(box, Paint()..shader = _ArtPainter._vertical(box, NightArt.gradient));
-    final star = Paint()..color = NightArt.over.withValues(alpha: NightSky.starAlpha);
-    for (final s in NightSky.stars) {
-      final y = s.dy >= 0 ? s.dy : size.height + s.dy;
-      canvas.drawCircle(Offset(size.width * s.x, y), s.r, star);
-    }
-  }
-
-  @override
-  bool shouldRepaint(_SkyPainter old) => false;
-}
-
-class _ArtPainter extends CustomPainter {
-  _ArtPainter(this.look);
-
-  final NightLook look;
-
-  @override
-  void paint(Canvas canvas, Size size) {
-    final box = Offset.zero & size;
-    canvas.save();
-    canvas.clipRect(box);
-    switch (look) {
-      case PaintedGradient():
-        canvas.drawRect(box, Paint()..shader = _vertical(box, NightArt.gradient));
-      case Painting(:final index):
-        final p = _placeholders[index];
-        canvas.drawRect(box, Paint()..shader = _vertical(box, [p.top, p.foot]));
-        final r = min(size.width, size.height) * 0.22;
-        canvas.drawCircle(
-          Offset(size.width * p.lightX, size.height * 0.38),
-          r,
-          Paint()
-            ..color = p.light.withValues(alpha: 0.85)
-            ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.35),
-        );
-        canvas.drawPath(_ridge(size, 0.66, 0.06, 1.3), Paint()..color = p.far);
-        canvas.drawPath(_ridge(size, 0.8, 0.05, 2.1), Paint()..color = p.near);
-    }
-    canvas.restore();
-  }
-
-  static Shader _vertical(Rect box, List<Color> colours) =>
-      LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colours).createShader(box);
-
-  // A gentle ridge across the width at [at] of the height, rising and
-  // falling by [swell] of the height, [waves] times.
-  static Path _ridge(Size size, double at, double swell, double waves) {
-    final path = Path()..moveTo(0, size.height);
-    const steps = 24;
-    for (var i = 0; i <= steps; i++) {
-      final x = size.width * i / steps;
-      final y = size.height * (at + swell * sin(i / steps * waves * pi));
-      path.lineTo(x, y);
-    }
-    return path
-      ..lineTo(size.width, size.height)
-      ..close();
+    canvas.drawRect(
+      box,
+      Paint()
+        ..shader = LinearGradient(
+          begin: Alignment.topCenter,
+          end: Alignment.bottomCenter,
+          colors: NightArt.gradient,
+        ).createShader(box),
+    );
   }
 
   @override
-  bool shouldRepaint(_ArtPainter old) => old.look != look;
+  bool shouldRepaint(_GradientPainter old) => false;
 }
diff --git a/app/pubspec.yaml b/app/pubspec.yaml
--- a/app/pubspec.yaml
+++ b/app/pubspec.yaml
@@ -22,6 +22,12 @@ dev_dependencies:
 flutter:
   uses-material-design: true
 
+  # The curated set of night paintings and New Dream's sky (D147), bundled:
+  # never fetched at run time (R10). Each file is fingerprinted there (G2);
+  # the folder's fingerprints.txt is bundled with them.
+  assets:
+    - assets/paintings/
+
   # The faces the Design System names (D49 a), bundled: never fetched at
   # run time (R10). Each file is fingerprinted in assets/fonts/.
   fonts:
diff --git a/app/test/journal/pages/date_shade_test.dart b/app/test/journal/pages/date_shade_test.dart
--- a/app/test/journal/pages/date_shade_test.dart
+++ b/app/test/journal/pages/date_shade_test.dart
@@ -1,8 +1,8 @@
 // The soft dark shade behind a night's date over any painting (D113), so the
 // date reads at 4.5 to 1 or better over every painting, in a row and in the
 // header; the painted gradient has none. Proved on real pixels: each
-// painting is drawn with the shade, and every pixel where the date stands is
-// measured against the date's colour.
+// painting of the set (D147) is drawn with the shade, and every pixel where
+// the date stands is measured against the date's colour.
 import 'dart:math';
 import 'dart:typed_data';
 
@@ -59,6 +59,13 @@ void main() {
         ),
       ),
     );
+    // The painting's file decoded before the pixels are read.
+    await tester.runAsync(() async {
+      for (final e in find.byType(Image).evaluate()) {
+        await precacheImage((e.widget as Image).image, e);
+      }
+    });
+    await tester.pump();
     late ByteData data;
     late int width;
     await tester.runAsync(() async {
@@ -117,7 +124,19 @@ void main() {
   // Soft: from far outside to the date's edge the painting darkens
   // gradually, through several steps, not at one hard edge.
   testWidgets('the shade fades in towards the date, in steps', (tester) async {
-    const look = Painting(3);
+    // Over the lightest painting where the date stands, so the shade shows.
+    var look = const Painting(0);
+    var light = 0.0;
+    for (var i = 0; i < NightArt.paintings; i++) {
+      final m =
+          await measure(tester, Painting(i), size: row.size, date: row.date, at: row.at, probe: row.probe, shade: false);
+      final y = (row.at.dy + row.date.height / 2).round();
+      final l = m.light(row.at.dx.round(), y);
+      if (l > light) {
+        light = l;
+        look = Painting(i);
+      }
+    }
     final shaded = await measure(tester, look, size: row.size, date: row.date, at: row.at, probe: row.probe);
     final bare = await measure(tester, look, size: row.size, date: row.date, at: row.at, probe: row.probe, shade: false);
     final y = (row.at.dy + row.date.height / 2).round();
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -170,7 +170,8 @@ void main() {
     expect(tester.widget<SkyMark>(find.byType(SkyMark)).sky, Sky.moon);
   });
 
-  // D112: a night sky inside the pill, drawn in code until the founder's image.
+  // D112: a night sky inside the pill, the set's strip (D147 item 3), the
+  // words on the date's shade (D113; proved on pixels in paintings_test).
   testWidgets('New Dream: centred, on a night sky, a button', (tester) async {
     final h = await Harness.make();
     await h.pump(tester, JournalPage(journal: h.journal));
@@ -179,6 +180,10 @@ void main() {
     expect(find.descendant(of: button, matching: find.byType(NightSky)), findsOneWidget);
     expect(find.descendant(of: button, matching: find.byType(NightArt)), findsNothing);
     final words = tester.widget<Text>(find.text(Lines.MP_11.text(Lang.en)));
+    expect(
+      find.ancestor(of: find.text(Lines.MP_11.text(Lang.en)), matching: find.byType(DateShade)),
+      findsOneWidget,
+    );
     expect(words.style!.color, NightArt.over);
     expect(words.style!.fontFamily, TypeRoles.button.family);
     final handle = tester.ensureSemantics();
@@ -292,7 +297,9 @@ void main() {
     expect(find.descendant(of: find.byType(DateShade), matching: find.text(shownDate(n.date))), findsOneWidget);
     await tester.pumpWidget(const SizedBox());
     await h.pump(tester, JournalPage(journal: h.journal));
-    expect(find.byType(DateShade), findsNothing);
+    // New Dream's words keep theirs (D147 item 3); the row has none.
+    expect(find.descendant(of: find.byKey(JournalPage.rowKey(n.id)), matching: find.byType(DateShade)), findsNothing);
+    expect(find.byType(DateShade), findsOneWidget);
   });
 
   testWidgets("a row: the date over an unread night's gradient", (tester) async {
diff --git a/app/test/journal/pages/night_art_test.dart b/app/test/journal/pages/night_art_test.dart
--- a/app/test/journal/pages/night_art_test.dart
+++ b/app/test/journal/pages/night_art_test.dart
@@ -1,9 +1,9 @@
 // A night's picture (D110; head's messages 24 and 25): the painted gradient,
-// or one of the placeholder paintings in the curated set's place; heard as
-// nothing; the same in both themes.
+// or one painting of the curated set (D147) covering its box from the
+// middle over the gradient; heard as nothing; the same in both themes. And
+// New Dream's sky, the set's strip (D112; D147 item 3).
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
-import 'package:souldreams/design/stand_ins.dart';
 import 'package:souldreams/design/tokens.g.dart';
 import 'package:souldreams/journal/night_look.dart';
 import 'package:souldreams/journal/pages/night_art.dart';
@@ -11,11 +11,22 @@ import 'package:souldreams/journal/pages/night_art.dart';
 void main() {
   Future<RenderObject> pump(WidgetTester tester, NightLook look) async {
     await tester.pumpWidget(Center(child: SizedBox(width: 300, height: 64, child: NightArt(look))));
-    return tester.renderObject(find.descendant(of: find.byType(NightArt), matching: find.byType(CustomPaint)));
+    return tester.renderObject(find.descendant(of: find.byType(NightArt), matching: find.byType(CustomPaint)).first);
   }
 
-  test('a few placeholder paintings stand in the set', () {
-    expect(NightArt.paintings, 5);
+  /// The one image in the tree, as drawn: its widget and its file.
+  ({Image image, ResizeImage resized, String file}) shown(WidgetTester tester) {
+    final image = tester.widget<Image>(find.byType(Image));
+    final resized = image.image as ResizeImage;
+    return (image: image, resized: resized, file: (resized.imageProvider as AssetImage).assetName);
+  }
+
+  test('sixty paintings in the set, each its own file', () {
+    expect(NightArt.paintings, 60);
+    expect(NightArt.asset(0), 'assets/paintings/01.jpg');
+    expect(NightArt.asset(9), 'assets/paintings/10.jpg');
+    expect(NightArt.asset(59), 'assets/paintings/60.jpg');
+    expect({for (var i = 0; i < NightArt.paintings; i++) NightArt.asset(i)}, hasLength(60));
   });
 
   test("the gradient and the words over it: from the dark theme", () {
@@ -26,25 +37,30 @@ void main() {
   testWidgets('the gradient fills its box, and nothing else is drawn', (tester) async {
     final art = await pump(tester, const PaintedGradient());
     expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
-    expect(art, isNot(paints..circle()));
+    expect(find.byType(Image), findsNothing);
   });
 
-  testWidgets('each painting fills its box and draws its own light', (tester) async {
+  testWidgets('each painting covers its box from the middle', (tester) async {
+    final ratio = tester.view.devicePixelRatio;
     for (var i = 0; i < NightArt.paintings; i++) {
       final art = await pump(tester, Painting(i));
-      expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64))..circle());
+      expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
+      final s = shown(tester);
+      expect(s.file, NightArt.asset(i));
+      expect(s.image.fit, BoxFit.cover);
+      expect(s.image.alignment, Alignment.center);
+      // Decoded no wider than the box on this screen.
+      expect(s.resized.width, (300 * ratio).ceil());
+      expect(s.resized.height, isNull);
+      expect(tester.getRect(find.byType(Image)), tester.getRect(find.byType(NightArt)));
     }
   });
 
-  testWidgets('no two paintings alike', (tester) async {
-    final skies = {for (var i = 0; i < NightArt.paintings; i++) NightArt.sky(i)};
-    expect(skies, hasLength(NightArt.paintings));
-  });
-
   testWidgets('the picture is silent; what stands over it is heard', (tester) async {
     final handle = tester.ensureSemantics();
     await pump(tester, const Painting(0));
     expect(tester.getSemantics(find.byType(NightArt)).label, isEmpty);
+    expect(shown(tester).image.excludeFromSemantics, isTrue);
     await tester.pumpWidget(const Directionality(
       textDirection: TextDirection.ltr,
       child: NightArt(Painting(1), child: Text('19/11/2026')),
@@ -53,46 +69,21 @@ void main() {
     handle.dispose();
   });
 
-  // D112: New Dream's night sky, a stand-in drawn in code: the gradient and
-  // stars, kept off the middle band where the words stand.
+  // D112; D147 item 3: New Dream's night sky, the set's strip.
   group('the night sky inside New Dream', () {
-    Future<RenderObject> sky(WidgetTester tester, {double height = 50}) async {
-      await tester.pumpWidget(Center(child: SizedBox(width: 200, height: height, child: const NightSky())));
-      return tester.renderObject(find.descendant(of: find.byType(NightSky), matching: find.byType(CustomPaint)));
-    }
-
-    PaintPattern starry(int n) {
-      final pattern = paints..rect(rect: const Rect.fromLTWH(0, 0, 200, 50));
-      for (var i = 0; i < n; i++) {
-        // Stars past the list repeat the last, so a longer pattern fails.
-        final s = NightSky.stars[i < NightSky.stars.length ? i : NightSky.stars.length - 1];
-        pattern.circle(
-          x: 200 * s.x,
-          y: s.dy >= 0 ? s.dy : 50 + s.dy,
-          radius: s.r,
-          color: NightArt.over.withValues(alpha: NightSky.starAlpha),
-        );
-      }
-      return pattern;
-    }
-
-    test('stars stand in the pill\'s own padding, clear of the words', () {
-      expect(NightSky.stars.length, greaterThanOrEqualTo(8));
-      for (final s in NightSky.stars) {
-        expect(s.x, inInclusiveRange(0, 1));
-        // Within the one side's padding: the top for a star from the top.
-        final side = s.dy >= 0 ? StandIns.buttonPadding.top : StandIns.buttonPadding.bottom;
-        expect(s.dy.abs() + s.r, lessThan(side));
-      }
-      // Some at the top and some at the foot.
-      expect(NightSky.stars.any((s) => s.dy >= 0), isTrue);
-      expect(NightSky.stars.any((s) => s.dy < 0), isTrue);
-    });
-
-    testWidgets('the gradient, then one star each', (tester) async {
-      final art = await sky(tester);
-      expect(art, starry(NightSky.stars.length));
-      expect(art, isNot(starry(NightSky.stars.length + 1)));
+    testWidgets("the sky: the set's strip, covering the pill", (tester) async {
+      await tester.pumpWidget(Center(child: SizedBox(width: 200, height: 50, child: const NightSky())));
+      final gradient = tester.renderObject(
+        find.descendant(of: find.byType(NightSky), matching: find.byType(CustomPaint)).first,
+      );
+      expect(gradient, paints..rect(rect: const Rect.fromLTWH(0, 0, 200, 50)));
+      final s = shown(tester);
+      expect(s.file, 'assets/paintings/sky.jpg');
+      expect(NightSky.asset, 'assets/paintings/sky.jpg');
+      expect(s.image.fit, BoxFit.cover);
+      expect(s.image.alignment, Alignment.center);
+      expect(s.image.excludeFromSemantics, isTrue);
+      expect(tester.getRect(find.byType(Image)), tester.getRect(find.byType(NightSky)));
     });
 
     testWidgets('the sky is silent; the words over it are heard', (tester) async {
diff --git a/app/test/journal/pages/paintings_test.dart b/app/test/journal/pages/paintings_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/journal/pages/paintings_test.dart
@@ -0,0 +1,171 @@
+// The curated set as shipped (D147): sixty paintings and New Dream's sky in
+// assets/paintings/, each a JPEG of its size with an sRGB profile and the
+// invisible AI tag (D123), bundled by the pubspec; each one drawn, not the
+// gradient; and New Dream's words readable over the sky, on real pixels.
+import 'dart:io';
+import 'dart:math';
+import 'dart:typed_data';
+
+import 'package:flutter/rendering.dart';
+import 'package:flutter/widgets.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/language.dart';
+import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/design/tokens.g.dart';
+import 'package:souldreams/journal/night_look.dart';
+import 'package:souldreams/journal/pages/night_art.dart';
+import 'package:souldreams/words/lines.g.dart';
+
+const _folder = 'assets/paintings/';
+const _tag = 'Iptc4xmpExt:DigitalSourceType="http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia"';
+
+/// A JPEG's segments up to its scan: marker and data.
+List<(int, Uint8List)> _segments(Uint8List b) {
+  expect(b.length > 4 && b[0] == 0xff && b[1] == 0xd8, isTrue, reason: 'a JPEG starts so');
+  final found = <(int, Uint8List)>[];
+  var at = 2;
+  while (true) {
+    expect(b[at], 0xff);
+    final marker = b[at + 1];
+    final length = (b[at + 2] << 8) | b[at + 3];
+    found.add((marker, Uint8List.sublistView(b, at + 4, at + 2 + length)));
+    if (marker == 0xda) return found;
+    at += 2 + length;
+  }
+}
+
+bool _has(Uint8List data, List<int> part) {
+  for (var i = 0; i + part.length <= data.length; i++) {
+    var all = true;
+    for (var j = 0; j < part.length && all; j++) {
+      all = data[i + j] == part[j];
+    }
+    if (all) return true;
+  }
+  return false;
+}
+
+({int width, int height, bool srgb, bool tagged}) _read(String file) {
+  final segments = _segments(File(file).readAsBytesSync());
+  const frames = {0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf};
+  final frame = segments.firstWhere((s) => frames.contains(s.$1)).$2;
+  final icc = segments.where((s) => s.$1 == 0xe2 && _has(s.$2.sublist(0, 12), 'ICC_PROFILE\u0000'.codeUnits));
+  final srgb = icc.any((s) => _has(s.$2, 'sRGB'.codeUnits) || _has(s.$2, [0, 0x73, 0, 0x52, 0, 0x47, 0, 0x42]));
+  final xmp = segments.where((s) => s.$1 == 0xe1 && _has(s.$2.sublist(0, 29), 'http://ns.adobe.com/xap/1.0/\u0000'.codeUnits));
+  return (
+    width: (frame[3] << 8) | frame[4],
+    height: (frame[1] << 8) | frame[2],
+    srgb: srgb,
+    tagged: xmp.any((s) => _has(s.$2, _tag.codeUnits)),
+  );
+}
+
+double _linear(int c) {
+  final v = c / 255;
+  return v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
+}
+
+double _luminance(int r, int g, int b) => 0.2126 * _linear(r) + 0.7152 * _linear(g) + 0.0722 * _linear(b);
+
+void main() {
+  final names = [for (var i = 0; i < NightArt.paintings; i++) NightArt.asset(i).substring(_folder.length)];
+
+  test('the folder holds the set, the sky and the fingerprints', () {
+    final files = Directory(_folder).listSync().map((e) => e.path.substring(_folder.length)).toSet();
+    expect(files, {...names, 'sky.jpg', 'fingerprints.txt'});
+    expect(names, hasLength(60));
+  });
+
+  test('each painting: 1280 x 960, sRGB, the AI tag', () {
+    for (final name in names) {
+      final r = _read(_folder + name);
+      expect((r.width, r.height, r.srgb, r.tagged), (1280, 960, true, true), reason: name);
+    }
+  });
+
+  test("New Dream's sky: 1200 x 336, sRGB, the AI tag", () {
+    final r = _read(NightSky.asset);
+    expect((r.width, r.height, r.srgb, r.tagged), (1200, 336, true, true));
+  });
+
+  test('the pubspec bundles the folder', () {
+    expect(File('pubspec.yaml').readAsStringSync(), contains('\n  assets:\n    - assets/paintings/\n'));
+  });
+
+  const key = Key('picture');
+
+  /// [widget] in a [size] box, its images decoded, drawn to pixels.
+  Future<({ByteData data, int width})> draw(WidgetTester tester, Widget widget, Size size) async {
+    await tester.pumpWidget(
+      Directionality(
+        textDirection: TextDirection.ltr,
+        child: Align(
+          alignment: Alignment.topLeft,
+          child: RepaintBoundary(key: key, child: SizedBox.fromSize(size: size, child: widget)),
+        ),
+      ),
+    );
+    await tester.runAsync(() async {
+      for (final e in find.byType(Image).evaluate()) {
+        await precacheImage((e.widget as Image).image, e);
+      }
+    });
+    await tester.pump();
+    late ByteData data;
+    late int width;
+    await tester.runAsync(() async {
+      final image = await tester.renderObject<RenderRepaintBoundary>(find.byKey(key)).toImage();
+      width = image.width;
+      data = (await image.toByteData())!;
+    });
+    return (data: data, width: width);
+  }
+
+  testWidgets('each painting is drawn, not the gradient alone', (tester) async {
+    const size = Size(330, 64);
+    final bare = await draw(tester, const NightArt(PaintedGradient()), size);
+    for (var i = 0; i < NightArt.paintings; i++) {
+      final art = await draw(tester, NightArt(Painting(i)), size);
+      var differ = 0;
+      for (var p = 0; p < art.data.lengthInBytes; p += 4) {
+        differ += art.data.getUint32(p) == bare.data.getUint32(p) ? 0 : 1;
+      }
+      expect(differ, greaterThan(art.data.lengthInBytes ~/ 4 ~/ 2), reason: 'painting $i');
+    }
+  });
+
+  // The pill as the journal builds it: as wide as its words and its padding,
+  // the words on the date's shade (D113). Every pixel where the words stand
+  // against their colour, with a box of their size in their place.
+  Future<double> wordsOverSky(WidgetTester tester, {required bool shade}) async {
+    await tester.pumpWidget(Directionality(
+      textDirection: TextDirection.ltr,
+      child: Center(child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over))),
+    ));
+    final words = tester.getSize(find.byType(Text));
+    final pad = StandIns.buttonPadding;
+    final size = Size(words.width + pad.horizontal, words.height + pad.vertical);
+    final box = SizedBox.fromSize(size: words);
+    final sky = await draw(
+      tester,
+      NightSky(child: Padding(padding: pad, child: shade ? DateShade(child: box) : box)),
+      size,
+    );
+    final over = NightArt.over;
+    final colour = _luminance((over.r * 255).round(), (over.g * 255).round(), (over.b * 255).round());
+    var lowest = double.infinity;
+    for (var y = pad.top.floor(); y < (pad.top + words.height).ceil(); y++) {
+      for (var x = pad.left.floor(); x < (pad.left + words.width).ceil(); x++) {
+        final i = (y * sky.width + x) * 4;
+        final l = _luminance(sky.data.getUint8(i), sky.data.getUint8(i + 1), sky.data.getUint8(i + 2));
+        lowest = min(lowest, (max(colour, l) + 0.05) / (min(colour, l) + 0.05));
+      }
+    }
+    return lowest;
+  }
+
+  testWidgets("New Dream's words read at 4.5 to 1 over the sky", (tester) async {
+    expect(await wordsOverSky(tester, shade: true), greaterThanOrEqualTo(4.5));
+  });
+
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A771, A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A782, A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -1741,27 +1741,23 @@ ROWS = [
      'bool noneRead(Night night) => false;',
      'bool noneRead(Night night) => true;',
      'test/journal/night_look_test.dart', 'no night is read before the readings'),
-    # D110: a night's picture (the painted gradient, the placeholder paintings).
+    # D110: a night's picture (the painted gradient; the curated set, D147).
     ('A368', 'lib/journal/pages/night_art.dart',
-     '        canvas.drawRect(box, Paint()..shader = _vertical(box, NightArt.gradient));\n',
-     '',
+     '    canvas.drawRect(\n      box,',
+     '    if (box.isEmpty) canvas.drawRect(\n      box,',
      'test/journal/pages/night_art_test.dart', 'the gradient fills its box, and nothing else is drawn'),
-    ('A369', 'lib/journal/pages/night_art.dart',
-     '        canvas.drawRect(box, Paint()..shader = _vertical(box, [p.top, p.foot]));\n',
-     '',
-     'test/journal/pages/night_art_test.dart', 'each painting fills its box and draws its own light'),
     ('A370', 'lib/journal/pages/night_art.dart',
      'static final gradient = [DarkColours.surface.colour!, DarkColours.surface.colourEnd!];',
      'static final gradient = [DarkColours.surface.colourEnd!, DarkColours.surface.colour!];',
      'test/journal/pages/night_art_test.dart', "the gradient and the words over it: from the dark theme"),
     ('A371', 'lib/journal/pages/night_art.dart',
-     '      ClipRect(child: CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand()));',
-     '      ExcludeSemantics(child: ClipRect(child: CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand())));',
+     '        excludeFromSemantics: true,',
+     '        excludeFromSemantics: false,',
      'test/journal/pages/night_art_test.dart', 'the picture is silent; what stands over it is heard'),
     ('A372', 'lib/journal/pages/night_art.dart',
-     '  static const paintings = 5;',
-     '  static const paintings = 4;',
-     'test/journal/pages/night_art_test.dart', 'a few placeholder paintings stand in the set'),
+     '  static const paintings = 60;',
+     '  static const paintings = 59;',
+     'test/journal/pages/night_art_test.dart', 'sixty paintings in the set, each its own file'),
     # D110: the journal's greeting, New Dream and rows.
     ('A373', 'lib/journal/pages/journal_page.dart',
      '              header: true,\n              child: Text(\n                greetingText(_greeting, appLanguage),',
@@ -1907,18 +1903,6 @@ ROWS = [
      '        child: NightSky(\n          child: Padding(',
      '        child: NightArt(\n          const PaintedGradient(),\n          child: Padding(',
      'test/journal/pages/journal_page_test.dart', 'New Dream: centred, on a night sky, a button'),
-    ('A409', 'lib/journal/pages/night_art.dart',
-     '(x: 0.06, dy: 7, r: 1.2),',
-     '(x: 0.06, dy: 20, r: 1.2),',
-     'test/journal/pages/night_art_test.dart', "stars stand in the pill's own padding, clear of the words"),
-    ('A410', 'lib/journal/pages/night_art.dart',
-     '      canvas.drawCircle(Offset(size.width * s.x, y), s.r, star);\n',
-     '',
-     'test/journal/pages/night_art_test.dart', 'the gradient, then one star each'),
-    ('A411', 'lib/journal/pages/night_art.dart',
-     ' s.dy >= 0 ? s.dy : size.height + s.dy;',
-     ' s.dy.abs();',
-     'test/journal/pages/night_art_test.dart', 'the gradient, then one star each'),
     ('A412', 'lib/journal/pages/night_page.dart',
      '                                shownDate(n.date),',
      '                                dayDigits(n.date),',
@@ -1965,8 +1949,8 @@ ROWS = [
      'static const double softness = 0.1;',
      'test/journal/pages/date_shade_test.dart', 'the shade fades in towards the date, in steps'),
     ('A423', 'lib/journal/pages/night_art.dart',
-     'ClipRect(child: CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand()));',
-     'CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand());',
+     '    return ClipRect(\n',
+     '    return Container(\n',
      'test/journal/pages/date_shade_test.dart', 'the picture clips what stands over it'),
     ('A424', 'lib/journal/pages/night_art.dart',
      'Widget build(BuildContext context) => CustomPaint(painter: _ShadePainter(), child: child);',
@@ -3193,6 +3177,51 @@ ROWS = [
      '      kept += await journal.keep(night.id, w);',
      '      kept += 0; await journal.keep(night.id, w);',
      'test/life_context/preview_test.dart', 'the seed logs its counts once, and nothing the second time'),
+    # curated-set, Task 3 (D147): the set shipped in the app, New Dream's sky, its words on the shade.
+    ('A772', 'lib/journal/pages/night_art.dart',
+     ".toString().padLeft(2, '0');",
+     ".toString().padLeft(1, '0');",
+     'test/journal/pages/night_art_test.dart', 'sixty paintings in the set, each its own file'),
+    ('A773', 'lib/journal/pages/night_art.dart',
+     '        fit: BoxFit.cover,',
+     '        fit: BoxFit.contain,',
+     'test/journal/pages/night_art_test.dart', 'each painting covers its box from the middle'),
+    ('A774', 'lib/journal/pages/night_art.dart',
+     '        alignment: Alignment.center,',
+     '        alignment: Alignment.topCenter,',
+     'test/journal/pages/night_art_test.dart', 'each painting covers its box from the middle'),
+    ('A775', 'lib/journal/pages/night_art.dart',
+     'ResizeImage.resizeIfNeeded(width > 0 ? width : null, null,',
+     'ResizeImage.resizeIfNeeded(null, null,',
+     'test/journal/pages/night_art_test.dart', 'each painting covers its box from the middle'),
+    ('A776', 'lib/journal/pages/night_art.dart',
+     '        alignment: Alignment.topLeft,\n        fit: StackFit.passthrough,\n',
+     '        alignment: Alignment.topLeft,\n',
+     'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
+    ('A777', 'lib/journal/pages/night_art.dart',
+     'Positioned.fill(child: _Cover(asset(look.index))),',
+     'Positioned.fill(child: _Cover(asset(0))),',
+     'test/journal/pages/night_art_test.dart', 'each painting covers its box from the middle'),
+    ('A778', 'lib/journal/pages/night_art.dart',
+     '          Positioned.fill(child: CustomPaint(painter: _GradientPainter())),\n          if (look',
+     '          if (look',
+     'test/journal/pages/night_art_test.dart', 'each painting covers its box from the middle'),
+    ('A779', 'lib/journal/pages/night_art.dart',
+     "static const asset = 'assets/paintings/sky.jpg';",
+     "static const asset = 'assets/paintings/01.jpg';",
+     'test/journal/pages/night_art_test.dart', "the sky: the set's strip, covering the pill"),
+    ('A780', 'lib/journal/pages/night_art.dart',
+     '      const Positioned.fill(child: _Cover(asset)),\n',
+     '',
+     'test/journal/pages/night_art_test.dart', "the sky: the set's strip, covering the pill"),
+    ('A781', 'lib/journal/pages/journal_page.dart',
+     '            child: DateShade(\n              child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),\n            ),',
+     '            child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),',
+     'test/journal/pages/journal_page_test.dart', 'New Dream: centred, on a night sky, a button'),
+    ('A782', 'pubspec.yaml',
+     '  assets:\n    - assets/paintings/\n',
+     '',
+     'test/journal/pages/paintings_test.dart', 'the pubspec bundles the folder'),
 ]
 
 
```

Then stage the set with the code (`git add app/assets/paintings app tool`); the hook's G2 proves every image against
`fingerprints.txt`.

Commit: `The curated set in the app: sixty paintings and New Dream's sky, tagged and fingerprinted (D147)`

### Task 7 · Docs: Status.md

The first line, the current branch, the road ahead, the app's and the server's counts, the guards' paintings, and
"Rulings during curated-set" with D147.

```
diff --git a/docs/Status.md b/docs/Status.md
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-23, in branch `image-trial` (the trial of open image models in our own AWS account, D135, D136; the owner's AWS tasks next), by Claude Code.
+Last updated: 2026-11-23, in branch `curated-set` (the curated set of night paintings shipped in the app, D147; the owner's by-eye check next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,13 +14,15 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`image-trial`: a trial of open image models in our own AWS account, for the founder to choose (D135, D136; plan
-`docs/plans/image-trial.md`): FLUX.1 [schnell] on ml.g6e.xlarge and SDXL on ml.g6.xlarge, SageMaker asynchronous
-inference in eu-north-1, scaled to zero, a private bucket whose requests and results the run deletes when it ends
-(its lifecycle rule the backstop, D138), a USD 30 budget alarm made by the owner with the CLI (D138: the budget
-resource does not exist in eu-north-1), the same six invented prompts on each, the times and costs measured, the images on the owner's Mac,
-then a teardown that removes everything. A separate stack (`SoulDreamsImageTrial`), made only when asked; the
-server's own stack is unchanged. The app is unchanged.
+`curated-set`: the curated set of night paintings (D147; plan `docs/plans/curated-set.md`): sixty paintings of
+invented scenery and New Dream's night sky, painted on the owner's Mac with Black Forest Labs' `flux-2-klein-4b` on
+the EU endpoint (D145) in the one style (D146) by `server/trial/curated.ts`, chosen by the owner on a contact sheet,
+shipped in `app/assets/paintings/` as JPEGs (1280 x 960, quality 75, sRGB; the sky 1200 x 336), each carrying the
+invisible AI tag (D123) and fingerprinted under G2. The app's picture choice moves from the placeholders to the set;
+New Dream's words stand on the date's shade over the sky (D113, a stand-in). The sun and the moon stay drawn in code.
+
+`image-trial` is merged (`a8d0099`): the open-model trial in AWS (D135 to D141, torn down), the Nebius test (D142,
+D143, set aside) and the Black Forest Labs test (D144 to D146), whose model and style the set uses.
 
 `life-context` is merged (`eaf0da1`): Life Context, the mechanical part (D110, head's message 24 item 2; C159-I item 1; D127; D128; D131; plan
 `docs/plans/life-context.md`): what counts as a sentence, the kept sentences on the phone, the Recent window's sweep,
@@ -32,15 +34,14 @@ merge (this entry records it).
 
 ## Road ahead
 
-- `image-trial`: the owner's AWS tasks (plan Part 3, Tasks 6 to 12), the founder's choice from the images and the
-  costs, then the teardown and its proof (Task 12). The plan's questions are its Part 4.
+- `curated-set`: the owner's by-eye check in SoulDreams Dev (plan Task 8), the full mutation runs once (D126), then
+  the merge, which is the owner's. The plan's questions are its Part 4.
 - `life-context` (merged): the owner's by-eye review passed (plan Task 7, with D133 and D134; VoiceOver waits for
   the full pass, D98) and the full mutation run was done: `app mutations: 726 run, 726 caught` at `46d5ebd` (9 min
   1 s on the owner's Mac, parallel). The Product questions are banked (items 167 and 169).
 - Then "Made by AI"; Feedback, with its server change (D121 item 4). Life Context's sources (the opening's answers,
   what is said after it, the reflection, Waking Life) come with Questions and Reflection, and with them the mark on a
-  tapped sentence's night (D131 item 3). The curated set of night paintings (about 60, the founder's)
-  replaces the placeholders, fingerprinted as the fonts are (a G0 and G2 change, the owner's).
+  tapped sentence's night (D131 item 3).
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1); the pending lines are filed at
   C17-P (and, for the founder app, with his export).
 - The readings: our server's own spending counter comes with them (D69), and response streaming on the function
@@ -223,7 +224,9 @@ merge (this entry records it).
   `pages/night_art.dart`): a read night's painting chosen from its id alone, nothing stored; an unread night's the
   painted gradient (the dark theme's bubble gradient, both themes); no night is read yet (`noneRead`), and
   SoulDreams Dev built with `--dart-define=PREVIEW_READ=true` shows every night as read, for the owner's review.
-  Five placeholder paintings, drawn in code, stand in the curated set. The words Product owes show as provisional
+  The curated set (D147): sixty paintings in `app/assets/paintings/`, each covering its box from the middle over
+  the gradient, decoded no larger than the box needs; New Dream's sky is the set's strip, its words on the date's
+  shade (D113). The words Product owes show as provisional
   handles, `[owed·…]` (`journal/owed.dart`): four greetings, New Dream, the four jump buttons.
 - The night rules (`app/lib/journal/night_rules.dart`, `journal.dart`): a night stores its closing instant, the
   first 21:00 after its first recording in the zone then in force (format version 1, D57 Q14); the typing screen's
@@ -350,10 +353,9 @@ merge (this entry records it).
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 756 tests (691 at the branch's start: `cc2ea8c` added
-  one after the 690 written here), and 726 mutation checks (A1 to A771; A24ah,
+- The app's analyzer baseline: `No issues found!`. The app has 760 tests, and 733 mutation checks (A1 to A782; A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
-  A277, A278, A281, A288, A291, A300, A301, A302, A313, A363, A375, A507, A518, A521, A526, A527, A530, A537, A538, A539, A540, A541, A543, A546, A549, A550, A553, A554, A558, A566, A574, A575, A578, A583, A585 to A600, A610, A623, A624, A626, A627, A629, A633, A634, A635, A645 and A646
+  A277, A278, A281, A288, A291, A300, A301, A302, A313, A363, A375, A507, A518, A521, A526, A527, A530, A537, A538, A539, A540, A541, A543, A546, A549, A550, A553, A554, A558, A566, A574, A575, A578, A583, A585 to A600, A610, A623, A624, A626, A627, A629, A633, A634, A635, A645, A646, A369 and A409 to A411
   dropped, each with its reason in the file; with the rows A24a to
   A24au among them) in
   `tool/app_mutations.py`, run by hand from the repository root with `python3 -I -B tool/app_mutations.py`
@@ -407,10 +409,15 @@ merge (this entry records it).
   `server/trial/measure.ts` and `server/trial/run.ts` (the six invented prompts, the run on the owner's Mac and the
   costs) and `server/trial/fetch-weights.sh` (the weights, from the model hub into the bucket, in CloudShell). Its
   tests run with the server's, against fakes: no AWS, no network.
-- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 100 tests, and
-  80 mutation checks (S1 to S81, S42 retired with the budget resource, D138) in `tool/server_mutations.py`, run by
-  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 80 run,
-  80 caught`); `check_all.sh` does not
+- The curated set's painter (D147; `docs/plans/curated-set.md`), on the owner's Mac only: `server/trial/curated.ts`
+  (paint, repaint, proof, ship; the USD 3 cap from BFL's own replies), `server/trial/scenes.ts` (the sixty invented
+  scenes and the sky) and `server/trial/jpeg.ts` (sizes, the sRGB profile and the AI tag, written by our own code;
+  its names in `server/src/hosts.ts`, never fetched). macOS's `sips` makes each JPEG. Tested against fakes.
+- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 128 tests, and
+  97 mutation checks (S1 to S102, S42 retired with the budget resource, D138, S82 to S85 with the style test, D146)
+  in `tool/server_mutations.py`, run by
+  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 97 run,
+  97 caught`); `check_all.sh` does not
   call it (D43 Q3). It first runs the type check and the tests on the unbroken server, and stops with
   `server mutations: FAILED (the unbroken server fails)`, exit 1, if either fails (the final review, `2fbaad6`).
 
@@ -459,6 +466,8 @@ The owner's, in this order (D42 Q10, Q12, Q16; D44 d; D45; D71). The plan's Task
 - G1 also proves the pending lines against `pending-fingerprint.txt` and `pending.g.dart` against the generator; G2
   also proves every file in `docs/reference/screens/` against its `fingerprints.txt`; G0 knows those two
   fingerprint files by exact path (D57 Q11, D58).
+- G2 also proves every file in `app/assets/paintings/` against its `fingerprints.txt`, armed or not; G0 knows that
+  file by exact path (D147).
 - Totals: 255 guard tests and 102 mutation checks (c18p-import: the generators' new forms, D118, D119).
 
 ## Banked
@@ -1643,6 +1652,19 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   records the wording of both. The owner deletes `~/Desktop/image-trial/bfl-style`. Next: the full server mutation
   run once (D126), then the merge, which is the owner's.
 
+## Rulings during curated-set
+
+- `image-trial` merged by the owner (`a8d0099`); its Status's first line was not updated at the merge (this entry
+  records it).
+- D147 (owner, the brainstorm): (1) about sixty paintings from invented scenery prompts written by Claude Code
+  (landscape, sky, weather, season, light, mood; no people, no text, nothing from any dream); the owner reviews a
+  contact sheet and rejects any, which are painted again with new seeds; (2) JPEG, sRGB (D148 later set 1280 x 960
+  at quality 75), the subject in the middle horizontal band; (3) also New Dream's night-sky strip (about 1200 x 340, D112); the
+  sun and moon stay drawn in code; (4) a cost cap of USD 3 for everything, repaints included. Every shipped image
+  carries the invisible AI tag (IPTC digital source type "trainedAlgorithmicMedia", D123), written by our own script;
+  fingerprinted under G2 like the fonts; the picture choice (from the night's id) moves to the set; the generation
+  runs on the owner's Mac with the BFL key from Parameter Store.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
```

Commit: `Status.md: the curated set (D147)`

### Task 8 · [OWNER] The by-eye check, SoulDreams Dev, invented nights only

Build SoulDreams Dev with `--dart-define=PREVIEW_READ=true` (every night shown as read), install it as usual, with the
invented nights only (R2, R12).

1. **The journal's rows.** Each night shows a thin band of a painting under its date; different nights, different
   paintings; the date readable on every one. Scroll fast: no row flashes empty (the gradient shows until the
   painting is in).
2. **A night's header.** A wide crop of the same painting as its row, the date at its foot readable, the back control
   and the menu over it, light status-bar text.
3. **New Dream.** The pill on the night sky, its words readable, a soft shade behind them; the sun or moon above the
   greeting unchanged.
4. **Night images Off** (Settings): every night shows the gradient; On again: the paintings come back.
5. **Light and dark**: the same paintings in both.
6. **A build without `PREVIEW_READ`**: every night shows the gradient (no night is read yet).

Bring a yes or no for each, and anything that looks wrong, in words. No screenshot of a real night (there is none in
SoulDreams Dev).

After the check: the full mutation runs once (D126): `python3 -I -B tool/app_mutations.py` (expected `app mutations:
733 run, 733 caught`) and `python3 -I -B tool/server_mutations.py` (expected `server mutations: 97 run, 97 caught`),
then the merge, which is the owner's.

## Part 4 · Questions (numbered; a blank is not a yes)

None stops this plan: each is built as leaned, and a look is a stand-in. Question 1 is answered before Task 4.

For the owner:
1. **The app's size.** Answered by D148: 1600 x 1200 at quality 82 proved to be about 81 MB for sixty (Task 3's
   first proof, 740,928 bytes), so the set is painted at 1280 x 960 at quality 75, the count staying 60. Task 3 is
   run again at those settings; if its figure is still above about 50 MB, the plan stops and the owner is told (the
   next step would be 45 paintings, not lower quality). The size and quality can only change before painting: the
   PNGs are not kept.
2. **The sky's size.** 1200 x 336, not 1200 x 340: both sides a multiple of 16 [ASSUMED: BFL's pages give no rule
   for FLUX.2 [klein]; a size it rounds stops at `curated-size`]. Lean: keep.
3. **New Dream's words on the date's shade.** Over a starry sky, white words read at 4.5 to 1 only with a shade
   (the stand-in sky without one measured 1.67 to 1). Built with D113's shade, the same colour and strength, as a
   stand-in. This changes New Dream's look beyond D112, so it goes to Product through the head. Lean: as built until
   Product sets it.
4. **The AI tag's names in `server/src/hosts.ts`.** Four `http://` names (XMP's and IPTC's), never fetched, live there
   because G9 allows such literals only in that file. Lean: as built; G9 unchanged.
5. **`sips`.** macOS's own image tool makes the JPEG (quality 75, D148); the sRGB profile is embedded by our own
   code from the OS's own file (Part 6 A1); nothing is installed. Lean: approve.
6. **The fingerprints file is bundled** with the folder (about 5 KB in the app), as listing sixty-one files in the
   pubspec one by one would avoid. Lean: keep.
7. **The count stays 60.** A night's painting is its id modulo the count; changing the count later would give every
   read night a different painting. Lean: sixty, fixed; a replaced painting keeps its number.
8. **CLAUDE.md's G0 and G2 lines** do not yet name the paintings' folder and its fingerprints (CLAUDE.md is the
   owner's). Lean: the owner adds "and every file in `app/assets/paintings/` matches its `fingerprints.txt`" to G2,
   and "and the paintings' fingerprints" to G0's exact paths, when merging.
9. **Training on outputs.** BFL's terms allow it to train on inputs and outputs (bfl-test plan); here both are only
   invented scenery. Lean: no action.

## Part 5 · How this plan was proven

1. **The build.** Built task by task in a copy of the tracked tree, `./.scratch/cs/build`, from `git archive` of
   `a8d0099`, each task's state kept as a snapshot (`./.scratch/cs/snaps/s0` to `s4`: s1 Task 1, s2 Task 2, s3 Task
   6, s4 Task 7).
   - Each block in Part 3 is `git diff --no-index` between two snapshots, its prefixes rewritten and its `index`
     lines left out.
   - Left out of every snapshot: harness files, `.fvm`, `.dart_tool`, the app's `build/`, the generated iOS files,
     `node_modules`, `dist`, Python's `__pycache__`, and `app/assets/paintings/` (the owner's, Task 5).
2. **Stand-ins for the set**, in the scratch folder only, never in a block: sixty 1600 x 1200 crops of the six
   invented paintings of the BFL test (`~/Desktop/image-trial/bfl/flux-2-klein-4b/`, R2: scenery, made from the
   trial's invented prompts), varied in brightness and flipped, and a dark starry strip drawn by a small script, each
   made a JPEG by `ffmpeg` (`sips` cannot write in this sandbox), given the sRGB profile and then the AI tag by
   Task 2's own `withAiTag`. 33 MB in all.
3. **Counts on each snapshot:** guard tests 274, 277, 277, 277, 277; server tests 100, 100, 128, 128, 128; app tests
   756 (s0 to s2), 760, 760 (with the stand-ins); `No issues found!` at each.
4. **Test first.** Each task's new and changed test files, put on the snapshot before it, failed: Task 1's two new
   guard tests failed (the third, `test_paintings_listed_pass`, passes there, as nothing checked the folder); Task 2's
   two new files at loading and the hosts tests; Task 6's `night_art_test`, `journal_page_test` and
   `paintings_test` (with the stand-ins in place). `date_shade_test.dart` passed there: its change only decodes the
   images before measuring, and on the placeholders there is nothing to decode; its rows bite (A418 to A424).
5. **Mutations on the build** (D126):
   - Task 1: `mutations: 15 run, all caught` (g0 and g2 files); the screenshots' G0 row first failed to set up (its
     pattern now spans the new line) and was followed.
   - Task 2: S77 to S102, `22 run, 20 caught`, then all caught once the repaint test pinned the seeds by value (S94:
     it compared against the function it checks) and the stand-in for `sips` made different bytes for each call (S102:
     two attempts of one size were identical).
   - Task 6: the 23 rows, `23 run, 23 caught`; the changed files', `82 run, 82 caught`.
6. **The guards** on each snapshot: `guards (walk): all passed`. During the build G4 refused five test names of twelve
   words or more and the sky's scene (twelve words), each shortened, and G3 one interpolated path literal, rewritten.
7. **Replayed on a fresh copy**, `./.scratch/cs/replay`, from `git archive` of `a8d0099`.
   - Every block applied with `git apply` in order, with `GIT_CEILING_DIRECTORIES` set.
   - After each block the tree was compared with its snapshot: no difference.
   - Before Task 6's block, Task 5 was done with the replayed `curated.ts ship` itself, from a set folder of the
     stand-ins (`NN-1.jpg` and a `set.json`): it checked each and wrote the 62 files and their fingerprints.
   - On the replayed tree: `guards (walk): all passed`; the server's type check clean and `ℹ tests 128`, `ℹ fail 0`; `No issues found!`
     and `+760: All tests passed!`; the guard tests `Ran 277` (all but `test_check_all`'s set-up, which needs the
     repository); the guard rows `mutations: 15 run, all caught`; S86 to S102 `rows: 17 run, 17 caught`; and the
     23 app rows `app mutations: 23 run, 23 caught`.
8. **Not run in the sandbox:** the painting itself (no key, by design, R5), `sips` (Task 3 proves it), the full
   mutation runs (D126: once, after the owner's look), and `tool/check_all.sh` whole (the owner's).

## Part 6 · Amendments, after the plan's commit (`287f64b`)

The blocks above are as proven then; a replay applies them and then these two commits' changes. Counts in Parts 1 to
5 that these change are given here.

**A1 · Task 3 found that `sips` writes no ICC profile on macOS 26** (commit `7bb410f`). On the owner's Mac (macOS
26.5.2) every `sips` variant tried (`-E`, `-e`, `-E` with `-m`, none) exits 0 and reports the profile as sRGB
IEC61966-2.1, but the JPEG holds no ICC segment, only JFIF, Exif and Photoshop segments: the set's own check refused
it (`curated-srgb`). The check is unchanged. `withProfile` (`jpeg.ts`) embeds the OS's own
`/System/Library/ColorSync/Profiles/sRGB Profile.icc` after `sips`, replacing any profile and never doubling one, and
`sipsConvert` (`curated.ts`) reads that file first and runs `sips`. A new error code, `curated-profile`. Tests: 4 in
`curated-jpeg.test.ts` and 2 in `curated.test.ts` (server tests 128 → 134); rows S103 to S109 (S86 to S109 are 24).

**A2 · D148, the size and the quality** (owner, after Task 3's first proof of 740,928 bytes, about 81 MB for sixty):
paintings at 1280 x 960 and JPEG quality 75, the count staying 60; Task 3 is run again at those settings before
Task 4, and above about 50 MB the next step is 45 paintings, not lower quality. `PAINTING` and `QUALITY` in
`curated.ts`; the tests' sizes and the quality; row S98 (quality 75). The Task 6 block's painting test expects
1280 x 960. The sky stays 1200 x 336. One request's credits stay counted as 3 (1280 x 960 is 1.4 to 1.5 credits).

**A3 · D149, the founder's by-eye correction** (before the merge; replaces D113 item 2's date shade): a row over a
painting has #000000 at 30% over its whole picture instead of the soft shade behind the date; a night's header over a
painting fades its bottom half to #000000 (100% at the very bottom, 70% at the fade's middle, 0% at its top; stops
0.0, 0.5, 1.0 from the bottom edge) instead of the date's shade; New Dream's sky has the same 30%. The gradient rows
are unchanged. `ArtOverlay` (`night_art.dart`) replaces `DateShade`, which is gone; Parts 1 and 3 above (the plain
words, the Task 6 block, "the date's shade") describe the shade as first built. The 4.5 to 1 gate stays, and where it
fails the overlay and the test are not changed: on the real set **all 60 rows are under it** (2.01 to 4.05), **New
Dream's pill is 4.01**, and **headers pass** (7.31 at the lowest); the figures and what each row would need are in
Status.md. The tests: `date_shade_test.dart` is `art_overlay_test.dart` (the gates; the row's 30%, the header's
fade, the gradient's none, the sky's 30%, all on pixels); `paintings_test.dart`, `journal_page_test.dart` and
`night_page_test.dart` follow (app tests 760 → 759); rows A418 to A422, A424 to A426, A429 and A781 retired and A783
to A795 new (A1 to A795, 736 rows).

**A4 · D150, the founder's by-eye corrections** (replaces D149's 30%): rows 5 pt more padding above and below the date
(`StandIns.rowHeight` 74, `rowDatePadding`); the overlay on painted rows and New Dream's sky #000000 at 40% (the
founder's ceiling); the header fade as D149; the header's date 55 pt (`StandIns.headerDate`), scaled down to the room
under the controls so that twice the text size still fits; the rows' and New Dream's contrast measured and reported
(`build/contrast_rows.txt`, `build/contrast_new_dream.txt`), not gated, the header's 4.5 to 1 gate kept; a soft text
shadow for the row date prepared and not applied. Measured at 40%: the weakest row 2.70 (39), six of sixty at 4.5 or
more, New Dream 5.15; Status.md lists the ten weakest. `art_overlay_test.dart` and `paintings_test.dart` report;
`journal_page_test.dart` and `night_page_test.dart` follow (app tests 759 → 762); rows A796 to A802 new, A783, A784,
A791 and A793 repointed (A1 to A802, 743 rows).

*No matter where you are on your journey, the steps you take are equally important.*
