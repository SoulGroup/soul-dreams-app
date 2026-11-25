# Plan: the readings' plumbing, part two: the night's personal painting (painting)

Branch `painting`, from `main` at `399a199`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and 6),
under D91 and D126. Written by Claude Code (Opus) on 2026-11-25. Governs: the head's message 33 item 1 (the
painting's neutral scenery prompt handed to BFL, from a placeholder description); D143 (only a neutral scenery
description leaves for BFL, written inside our chain by the readings' model; for now a fixed placeholder scene that
reads nothing of the night); D145 (`flux-2-klein-4b` on `api.eu.bfl.ai`); D146 (the style constant); D123 (the
invisible AI tag on every image); D160 (Night images defaults to Personal); the readings-plumbing plan's Part 6 (the
painting's questions); the one model interface and per-step counts (the head's message 34); the owner's D162 (the
brainstorm); R3, R4, R10, R11. The server calls BFL; the phone never does. BFL's training opt-out was requested by
email (2026-11-23). The owner's checks are by eye only.

`c19p-import` is merged (`main` at `399a199`): Status.md's first line still names it ("the owner's by-eye check, then
the full mutation run"), as its own last commit wrote it. This is not a stop; Task 6 records the merge.

**Nothing in this plan is a stop under D91.** One difference is a question for the head and Product, not for this
branch's code (Part 4, question 1): the filed MP·70 says a Personal painting's words go to Google, which keeps and
trains on none of them, and that the app adds no mark; the rulings say Black Forest Labs (D145) and our own
invisible tag (D123). This branch sends nothing of a night (D143's placeholder), in SoulDreams Dev only, with
invented nights only, so nothing the dreamer is told is yet made untrue by it; the question must be settled before
any build that a real dreamer uses paints.

No new package, app or server (R10). No new setting, guard or Swift.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

In SoulDreams Dev, a read night gets a painting of its own.

- **When.** While Night images is Personal (the default, D160), a read night with no painting of its own asks for
  one: when its page opens, and right after Start Interpretation reads it. Once each time the page opens; never for
  an unread night, or while Random or Off.
- **What leaves the phone.** Nothing of the night: one POST to our server's `/painting` with the beta key and the
  body `{}` (D143; R4).
- **On our server.** The beta key is checked. The scenery step goes through the one model interface (head's message
  34): its stand-in, `stand-in-scenery`, names one fixed placeholder scene, the curated set's first ("a wheat field
  at dawn under a pale gold sky"), reading nothing; its call is counted (zero tokens) and logged like every call.
  Then BFL's key is read from Parameter Store (`/souldreams/bfl-key`, D162 item 4), and Black Forest Labs'
  `flux-2-klein-4b` on `api.eu.bfl.ai` (D145) paints the scene, the curated set's framing and the one style (D146),
  at 1280 x 960, as a JPEG. Our own code writes the invisible AI tag into it (D123), the same tag the curated set
  carries, and the JPEG goes back to the phone. The server keeps nothing; it logs the painting's cost in millionths
  of a dollar (`paintingGiven 14000` for 1.4 credits), never a word (R3).
- **While it is made** (D162 item 1), the night's header shows its curated painting with MP·81, "New painting on the
  way", over it; a screen reader hears it as it comes.
- **When it comes**, the night's own painting replaces the curated one, on its page and on its row in the journal.
  It is kept on the phone beside the night, in the journal's folder (protected, backup-excluded), and deleted with
  the night or with the journal (D162 item 3; R11). Nothing of it is kept on our server.
- **A failure** (no connection, the server or BFL failing, BFL moderating, an image not as asked) leaves the curated
  painting, silently (D162 item 2). It is counted on the phone; the next opening of the night tries again; after
  three failed tries, no more are asked for.
- **Random** shows a curated painting (even where a night has its own); **Off** the gradient.
- The night's image controls in its menu (MP·78 to MP·80: a new random painting, painting from a description,
  removing the image) are a later branch (D162 item 5).

The tester and founder apps reach none of it (`dev_only_test.dart`): only SoulDreams Dev reads nights, and only
`main_dev.dart` hands the journal a painter. The founder's build shares the journal's code, so its folder learns
the two new file names (and sweeps a stray one), but nothing in it ever writes one.

### What this branch builds

1. **The server's painting** (Task 1): `server/src/painting.ts` (new: the model, `STYLE` and `FRAME`, moved here from
   `trial/` so the Lambda carries them; the size, 1280 x 960; `paintingRefused`, a body of `{}` only, at most 64
   characters; `sceneOf`, one line of at most 500 characters; `promptOf`, scene, framing, style; `paint`, the
   request with `output_format: 'jpeg'` and no seed, the polling every 500 ms for 30 seconds at most, each request
   10 seconds at most, BFL's key sent only to its own hosts over https, the image checked as a JPEG of the size
   asked and given the AI tag, at most 4 MiB; `paintNight`, the scenery step through `ask`, then the painting, and
   the cost in millionths; `PaintingFailure` with a code), `server/src/jpeg.ts` (moved from `trial/jpeg.ts`
   unchanged but its import and first comment), `door.ts` (`POST /painting` after the beta key; 200 with the JPEG
   as base64 and `isBase64Encoded`; 400 or 413 `paintingRefused`; BFL's key failing 500 `parameterFailed`; the
   painting failing 502 `paintingFailed` with its code, -7 anything else; given `paintingGiven` with its cost),
   `handler.ts` (one `ask` for every step; the painting wired to Node's fetch and the clock), `models.ts` (the
   model `stand-in-scenery`, the scenery step's in `SETUP`, its zero prices, `STAND_IN_SCENERY` and its caller),
   `parameter-names.ts` (`BFL_KEY_PARAMETER`, `/souldreams/bfl-key`, the third the role may read), `hosts.ts`
   (`api.eu.bfl.ai` joins `HOSTS`), `safe-log.ts` (three codes), `infra/stack.ts` (the timeout, 60 seconds),
   `trial/measure.ts`, `trial/scenes.ts` and `trial/curated.ts` (importing `STYLE`, `FRAME` and `jpeg.ts` from
   `src/`). No new resource, variable or output; the role gains one parameter.
2. **The night's painting on the phone, the storage** (Task 2; D162 item 3; docs/workflow.md (c)):
   `app/lib/journal/journal_store.dart` (`painting-<id>.jpg`, written whole and renamed, only while the night's file
   is there; `painting-<id>.tries`, the count of failed tries, removed when a painting is kept; both deleted first
   when the night is; either one swept at open when its night's file is gone, `paintingSwept`; `painting`,
   `paintings`, `keepPainting`, `paintTries`, `countPaintTry`), `journal.dart` (the same, for the pages),
   `safe_log.dart`. The night's file does not change. Nothing else changes in this task's build, so it can ship
   alone (Task 3).
3. **The owner's storage rehearsal** (Task 3).
4. **The painting's request and its rules** (Task 4): `app/lib/readings/painting.dart` (`postPainting`, one POST of
   `{}` to `Hosts.server` + `painting`, the beta key, no user agent, 75 seconds, a whole JPEG of at most 4 MiB or a
   `PaintingFailure`; `livePainting`, SoulDreams Dev's; `paintNight`, Personal, read, none yet, fewer than three
   failed tries, `sending` told just before the request, a failure counted, a night deleted meanwhile keeps
   nothing, never throws; `Painter`, one request per night at a time), `safe_log.dart` (three codes).
5. **The painting on the page and the row** (Task 5): `night_look.dart` (`PersonalPainting`; `lookOf`'s
   `personal`), `pages/night_art.dart` (a painting from its bytes, under the same overlays), `pages/night_page.dart`
   (`personal` and `painter`; the painting asked for once per opening; MP·81 in the header while it is made),
   `pages/journal_page.dart` (each row's own painting while Personal; Personal and the painter handed to the
   night's page), `pages/journal_home.dart` (Personal from the settings; the painter handed on), `main_dev.dart`
   (the painter, with the build's beta key). `main.dart` and `main_founder.dart` are unchanged.
6. **Status.md** (Task 6).

### What it does not build

- The scenery written by the readings' model (D143): it comes with the instructions (R7). The placeholder reads
  nothing of the night, and the request carries nothing of it.
- The image controls in the night's menu (MP·78 to MP·80; D162 item 5).
- MP·82, the picture's spoken name: the picture stays silent, as now (question 13).
- Any count or cost of the painting kept on the phone (question 9), or a spending stop (question 10).
- A painting in the tester or founder app.
- Words: none written (R1). MP·81 is filed (C18-P), as written.

### The decisions, by number

- The head's message 33 item 1: the painting's neutral scenery prompt handed to BFL, from a placeholder description.
- D143: only a neutral scenery description leaves for BFL, written inside our chain; now a fixed placeholder scene
  that reads nothing of the night.
- D145: `flux-2-klein-4b`, `api.eu.bfl.ai`. D146: the one style (`STYLE`). D123: the invisible AI tag on every
  image. D160: Night images is Personal by default.
- The head's message 34: the scenery step through the one model interface, its model named in `SETUP`, its call
  counted and logged.
- D162 (owner, the brainstorm): (1) MP·81 over the curated painting while it is made, the personal one replacing it;
  (2) a failure leaves the curated one, silently, retried on the next opening, up to 3 tries; (3) kept on the phone
  in the journal's folder, deleted with its night, nothing on our server, a storage change under (c); (4) the BFL
  key's permanent name (owner task); (5) the image controls later. Personal shows the painting, Random a curated
  one, Off the gradient.
- D91, D126 (targeted rows during the tasks; the full runs once, before the merge), D67 (a row whose code, file or
  test name moved follows it).

### Decided under D91 (how to build only)

1. **One more route on the same Lambda and function URL**, `POST /painting`, behind the same beta-key check: no new
   address in `hosts.dart`.
2. **The request holds nothing** (`{}` exactly): any field refuses it, so a later client can never send a night's
   words to this route by mistake. The scene, when the readings' model writes it, will change the request with its
   own question.
3. **The scenery step's stand-in is a second stand-in model**, `stand-in-scenery`, named in `SETUP` for the scenery
   step, rather than the one stand-in answering by step: the `Caller` interface does not change, and swapping the
   scenery step's model stays one line. The readings step's stand-in is unchanged.
4. **BFL's JPEG, not a PNG made a JPEG**: the Lambda has no `sips` and no image package, so BFL is asked for a JPEG
   (`output_format: 'jpeg'`, its default [READ, docs.bfl.ai, the klein 4B reference, 2026-11-25]) and our code only
   checks its size and writes the tag. No sRGB profile is checked (question 7).
5. **The image travels as the reply's body**, base64 under `isBase64Encoded`, which the function URL turns into
   bytes: the phone gets a plain `image/jpeg`. At most 4 MiB on both sides, well under the function URL's 6 MB.
6. **`jpeg.ts`, `STYLE` and `FRAME` move into `server/src/`** so the Lambda's code folder carries them; the trial's
   files import them back, so the curated set's painter is unchanged in what it does. Rows S86 to S90 and S103 to
   S107 follow the file (D67); S86, S89 and S104 were rewritten, since in `src/` a break that leaves a name unused
   stops the build before any test runs.
7. **The Lambda's timeout is 60 seconds** for every route: BFL is given 30 seconds of polling, and each request 10.
   The phone waits 75.
8. **A painting is asked for once each time its page opens**, and right after the night is read there: a failure is
   not retried while the page stays open, as D162 item 2 says ("on the next opening"). Two openings at once share one
   request (`Painter`).
9. **The tries are counted in a file of their own**, `painting-<id>.tries`, not in the night's file: the night's
   format (version 3) does not change, so the storage change is new files beside the nights, not a new version.
   A count that does not read counts as none (the painting is tried again).
10. **A night's own painting is shown only while Personal.** Under Random the file stays (it is the night's), and the
    curated painting shows; under Off the gradient. Switching back to Personal shows it again.
11. **The painting's request is never made for an unread night**: `paintNight` checks the night's readings, and the
    page asks only once the night is read, so Start Interpretation's reading is followed by the painting in the
    same opening.
12. **MP·81 stands in the header between the controls and the date**, centred, in `type.button` and the date's
    colour, scaled down to its room (a stand-in, question 5).
13. **Existing tests changed, none weakened**: `journal_store_test.dart`'s "a delete between a save write and rename
    waits" now expects six deletes, not two (the painting, its count and their temporary files, then the night's
    two), its order still checked; `stack.test.ts`'s timeout (60), the role's three keys and their test names;
    `models.test.ts` (the second stand-in in `MODELS` and `SETUP`; the callers given for both; the scenery call's log
    names model 1); `handler.test.ts` (the readings' callers given for both); `hosts.test.ts` (BFL's host now the
    server's); `dist.test.ts` (`jpeg.js`, `painting.js`); `safe-log.test.ts` (three codes); `door.test.ts` (the
    painting in its fakes, three more 404 paths); `journal_home_test.dart` (the text of `main_dev.dart`); the curated
    tests import `jpeg.ts` from `src/`. Rows S8, S14, S19 to S21, S131, S132, S152 and S156 follow (D67), and so do
   fifteen app rows on the pages' moved lines (Part 1, "The tests").
14. **One literal rewritten for G3**: the count's text is written from a variable, not an interpolated literal.

### The places this branch uses

- Filed (C18-P; C19-P keeps them), as written: **MP·81** ("New painting on the way", shown while a painting is made,
  in the image's place), Night images' three choices (MP·85, as built).
- **Not shown**: MP·82 (the picture's spoken name; question 13), MP·78 to MP·80 (D162 item 5), MP·70 (question 1).
- The placeholder scene is not a line: it is a prompt the server sends to BFL, never shown, one of the sixty scenes
  the owner read for the curated set (D147).

### The tests (test-first, on the Mac)

Each task's tests were put on the tree before its code and failed (loading, type-checking or asserting); then the
code made them pass (Part 5).

- Server tests: 184 at the start, then 203 (Task 1). `npm run check` clean.
- App tests: 837 at the start, then 845 (Task 2), 858 (Task 4) and 873 (Task 5). `No issues found!` at each.
- Guard tests: unchanged; `guards.py --walk` passes on every task's tree.
- Server mutation rows: **new** S181 to S206 (26); **following** S8, S14, S19, S20, S21, S86, S89, S104, S131, S132,
  S152, S156, and S87, S88, S90, S103, S105 to S107 by their file. 175 → 201.
- App mutation rows: **new** A926 to A936 (Task 2), A937 to A953 (Task 4), A954 to A975 (Task 5): 50; **following**
  (Task 5, D67: their text moved) A40, A364, A365, A376, A382, A394, A509, A510, A512, A752, A777, A780, A790, A801
  and A835. 863 → 913.
- None dropped.

## Part 2 · Settings, packages, AWS and storage

- **Packages:** none, app or server.
- **AWS** (the owner's): the BFL key copied to its permanent name, `/souldreams/bfl-key`, a SecureString (Task 7;
  D162 item 4); then one stack update of `SoulDreamsServer` (Task 8): the Lambda's code, its timeout (10 to 60
  seconds) and its role's `ssm:GetParameter` gaining that one parameter. No new resource, variable or output. The old
  `/souldreams/trial/bfl-key` is deleted after the by-eye check (Task 9, its last step).
- **Black Forest Labs**, read on its own pages on 2026-11-25 [READ, docs.bfl.ai: the klein 4B reference, the
  integration guidelines, generating images]: the klein 4B request takes `prompt`, `width`, `height`, `seed`,
  `output_format` (`jpeg`, `png` or `webp`, default `jpeg`), `safety_tolerance` and others; results are "served from
  region-specific delivery endpoints under delivery.*.bfl.ai", whose signed addresses last 10 minutes; at most 24
  tasks at once. **[NOT READ: any statement on metadata (C2PA, XMP) in BFL's outputs; the pages read say nothing]**
  (question 8). **[NOT READ: retention or training on BFL's docs pages]**; the bfl-test plan read its terms (they
  allow training on inputs and outputs; the opt-out was requested by email on 2026-11-23).
- **Settings, guards, Swift:** none.
- **Storage on the phone** (R11; docs/workflow.md (c); D162 item 3): the journal's folder gains two kinds of file
  beside the nights, `painting-<id>.jpg` and `painting-<id>.tries`, with the folder's protection and backup
  exclusion (the folder's own, D49 b). The night's file does not change. Tests first (Task 2: every invented night
  read back unchanged beside its painting, counted before and after); then the owner's rehearsal on the simulator
  and the phone in SoulDreams Dev, holding invented nights from the build before, with the build of Task 2 alone
  (Task 3). It reaches the Cohort 0 app only after the merge and the owner's safety export (Task 10's note). A
  deleted night leaves nothing: its painting and count go first (Task 2's tests).
- **Storage on the server:** none. The server keeps nothing of a painting.

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, made from the build that proved it (Part 5). Apply it from
the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

Task 1's block renames `server/trial/jpeg.ts` to `server/src/jpeg.ts` (`git apply` handles the rename). `git apply`
refuses if any line differs, which is the stop R14 asks for. No block touches `tool/checks/`. Then run the task's
checks and commit through the hook with the message given.

Every task ends green:
- Server tasks: `cd server && npm run check && npm test` prints only the check's header, then `ℹ fail 0` at the count
  given; the task's rows by importing `tool/server_mutations.py` and calling `run_row` on them (it has no row
  selection), every one caught.
- App tasks: `cd app && fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub`
  passes at the count given; the task's rows (D126): `python3 -I -B tool/app_mutations.py --rows <the task's rows>`,
  every one caught.
- The hook prints `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `painting`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1) ; (cd server && npm run check | tail -1 && npm test 2>&1 | grep -E '^ℹ (tests|fail)')
```

Expected: nothing from `git status`; this plan's commit; `guards (tracked): all passed`; `No issues found!`;
`+837: All tests passed!`; `> tsc -p tsconfig.json`; `ℹ tests 184`, `ℹ fail 0`. Anything else: stop (R14).

### Task 1 · Server: POST /painting; the scenery stand-in; BFL's painting with the AI tag

Changed: `server/src/painting.ts` (new), `server/src/jpeg.ts` (moved from `server/trial/jpeg.ts`), `door.ts`,
`handler.ts`, `models.ts`, `hosts.ts`, `parameter-names.ts`, `safe-log.ts`, `infra/stack.ts`, `trial/curated.ts`,
`trial/measure.ts`, `trial/scenes.ts`; tests `painting.test.ts` (new), `door.test.ts`, `handler.test.ts`,
`models.test.ts`, `hosts.test.ts`, `dist.test.ts`, `safe-log.test.ts`, `stack.test.ts`, `curated.test.ts`,
`curated-jpeg.test.ts`, `curated-fakes.ts`; `tool/server_mutations.py` (S181 to S206 new; S8, S14, S19, S20, S21,
S86, S89, S104, S131, S132, S152, S156 follow; S86 to S90 and S103 to S107 follow the file).

Checks: `npm run check` clean; `ℹ tests 203`, `ℹ fail 0`. Rows: S181 to S206, S8, S14, S19 to S21, S86 to S90,
S103 to S107, S131, S132, S152, S156, every one caught.

Commit:

> Server: POST /painting paints a fixed placeholder scene with BFL, tagged as AI, from nothing of the night (D162, D143, D145, D146, D123)

**The block:**

~~~~diff
diff --git a/server/infra/stack.ts b/server/infra/stack.ts
--- a/server/infra/stack.ts
+++ b/server/infra/stack.ts
@@ -2,8 +2,9 @@
 // one Lambda in eu-north-1 behind its own function URL, with no
 // authentication of the URL's own (the beta key is checked in the code),
 // its logs kept 7 days, with no access logs, no tracing and no identifier;
-// its one variable is the feedback bucket's name. It reads two SecureStrings
-// the owner makes, and puts feedback in its bucket, and nothing else. No
+// its one variable is the feedback bucket's name. It reads three
+// SecureStrings the owner makes, and puts feedback in its bucket, and
+// nothing else. No
 // reserved concurrency yet (D71 Q12: the account's quota must allow it
 // first; a first-deploy checklist line returns it).
 //
@@ -48,7 +49,7 @@ export class ServerStack extends Stack {
       assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),
     });
     logGroup.grantWrite(role);
-    // The two keys, by name, and their decryption through Parameter Store
+    // The three keys, by name, and their decryption through Parameter Store
     // only (D69).
     role.addToPrincipalPolicy(
       new iam.PolicyStatement({
@@ -88,8 +89,9 @@ export class ServerStack extends Stack {
       loggingFormat: lambda.LoggingFormat.JSON,
       applicationLogLevelV2: lambda.ApplicationLogLevel.INFO,
       systemLogLevelV2: lambda.SystemLogLevel.WARN,
-      // A cold start, then Parameter Store, then Soniox or S3 (D71 Q20).
-      timeout: Duration.seconds(10),
+      // A cold start, then Parameter Store, then Soniox or S3 (D71 Q20); a
+      // painting waits for BFL up to 30 seconds, each request up to 10 (D162).
+      timeout: Duration.seconds(60),
       environment: { [FEEDBACK_BUCKET_VARIABLE]: feedback.bucketName },
     });
     const url = fn.addFunctionUrl({ authType: lambda.FunctionUrlAuthType.NONE });
diff --git a/server/src/door.ts b/server/src/door.ts
--- a/server/src/door.ts
+++ b/server/src/door.ts
@@ -2,14 +2,16 @@
 // Lambda function URL with no authentication of its own, and the beta key
 // checked here. POST / with the beta key as a bearer token gets a
 // short-lived Soniox key; POST /feedback with it keeps one feedback
-// (feedback.ts); POST /reading with it reads one night (reading.ts);
-// anything else gets nothing. It reads the method, the path and one header,
-// and the body only for feedback and a reading, after the key: never the
-// caller's network address or any other header. It logs codes and numbers
-// only (R3, R4).
+// (feedback.ts); POST /reading with it reads one night (reading.ts); POST
+// /painting with it paints one night's picture from nothing of the night
+// (painting.ts, D162); anything else gets nothing. It reads the method, the
+// path and one header, and the body only for feedback, a reading and a
+// painting, after the key: never the caller's network address or any other
+// header. It logs codes and numbers only (R3, R4).
 import { isBetaKeyShape, sameKey } from './beta-key.ts';
 import { parseFeedback, utcDay } from './feedback.ts';
-import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from './parameter-names.ts';
+import { PaintingFailure, paintingRefused, type Painted } from './painting.ts';
+import { BETA_KEY_PARAMETER, BFL_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from './parameter-names.ts';
 import { parseReading, type Read, type ReadingRequest } from './reading.ts';
 import { safeLog } from './safe-log.ts';
 import { SonioxFailure, type TemporaryKey } from './soniox.ts';
@@ -26,6 +28,8 @@ export interface Reply {
   readonly statusCode: number;
   readonly headers?: Readonly<Record<string, string>>;
   readonly body?: string;
+  /** The body is an image's bytes, as base64 (the painting). */
+  readonly isBase64Encoded?: boolean;
 }
 
 export interface DoorDeps {
@@ -36,11 +40,13 @@ export interface DoorDeps {
   readonly keepFeedback: (day: string, text: string) => Promise<void>;
   /** One night's readings and the calls that made them (head's messages 33, 34). */
   readonly readNight: (request: ReadingRequest) => Promise<Read>;
+  /** One night's painting, with BFL's key (D162). */
+  readonly paintNight: (bflKey: string) => Promise<Painted>;
   readonly now: () => Date;
 }
 
 const BEARER = 'Bearer ';
-const PATHS = new Set(['/', '/feedback', '/reading']);
+const PATHS = new Set(['/', '/feedback', '/reading', '/painting']);
 
 export function makeDoor(deps: DoorDeps): (event: DoorEvent) => Promise<Reply> {
   return async (event) => {
@@ -63,7 +69,8 @@ async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
   const refused = await checkBetaKey(event, deps);
   if (refused !== undefined) return refused;
   if (path === '/') return issueKey(deps);
-  return path === '/feedback' ? takeFeedback(event, deps) : giveReading(event, deps);
+  if (path === '/feedback') return takeFeedback(event, deps);
+  return path === '/reading' ? giveReading(event, deps) : givePainting(event, deps);
 }
 
 // The request's body, as text.
@@ -158,3 +165,34 @@ async function giveReading(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
     body: JSON.stringify({ readings: read.readings, usage: read.usage }),
   };
 }
+
+// One night's painting (D162): a request holding nothing, BFL's key, the
+// painting; 200 with the JPEG alone. Its cost alone is logged (R3).
+async function givePainting(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
+  const refused = paintingRefused(bodyOf(event));
+  if (refused !== null) {
+    safeLog('paintingRefused', [refused]);
+    return { statusCode: refused };
+  }
+  let bflKey: string;
+  try {
+    bflKey = await deps.readParameter(BFL_KEY_PARAMETER);
+  } catch {
+    safeLog('parameterFailed');
+    return { statusCode: 500 };
+  }
+  let painted: Painted;
+  try {
+    painted = await deps.paintNight(bflKey);
+  } catch (failure) {
+    safeLog('paintingFailed', [failure instanceof PaintingFailure ? failure.code : -7]);
+    return { statusCode: 502 };
+  }
+  safeLog('paintingGiven', [painted.cost]);
+  return {
+    statusCode: 200,
+    headers: { 'content-type': 'image/jpeg' },
+    body: painted.jpeg.toString('base64'),
+    isBase64Encoded: true,
+  };
+}
diff --git a/server/src/handler.ts b/server/src/handler.ts
--- a/server/src/handler.ts
+++ b/server/src/handler.ts
@@ -1,17 +1,27 @@
 // The server's one entry point, behind its function URL (head's message
-// 14; D71; D152; head's messages 33 and 34): the front door (door.ts),
-// wired to Parameter Store, to Soniox, to the feedback bucket and to the
-// models through their one interface (models.ts): each step's model from
-// SETUP, its caller from [callers] (the stand-in's until Claude's come),
-// handed the instructions read once from the folder beside the code. What
-// it decides is in door.ts, feedback.ts, reading.ts and models.ts.
+// 14; D71; D152; head's messages 33 and 34; D162): the front door
+// (door.ts), wired to Parameter Store, to Soniox, to the feedback bucket,
+// to the models through their one interface (models.ts): each step's model
+// from SETUP, its caller from [callers] (the stand-ins' until Claude's
+// come), handed the instructions read once from the folder beside the code;
+// and to Black Forest Labs for the painting ([send], [clock]). What it
+// decides is in door.ts, feedback.ts, reading.ts, painting.ts and models.ts.
 import { makeDoor } from './door.ts';
 import { FEEDBACK_BUCKET_VARIABLE } from './feedback.ts';
 import { makeFeedbackStore, putToS3, type Put } from './feedback-store.ts';
 import { type Instruction, INSTRUCTIONS, readInstructions } from './instructions.ts';
 import { readParameter } from './parameters.ts';
-import { type Caller, callModel, type ModelName, PROMPT_CACHING, SETUP, standInCaller } from './models.ts';
-import { readNight } from './reading.ts';
+import {
+  type Caller,
+  callModel,
+  type ModelName,
+  PROMPT_CACHING,
+  SETUP,
+  standInCaller,
+  standInSceneryCaller,
+} from './models.ts';
+import { type BflSend, type Clock, fetchSend, paint, paintNight, realClock } from './painting.ts';
+import { type Ask, readNight } from './reading.ts';
 import { requestTemporaryKey } from './soniox.ts';
 
 /** The door, wired: [env] names the feedback bucket, [put] sends to it. */
@@ -19,18 +29,19 @@ export function wire(
   env: Readonly<Record<string, string | undefined>>,
   put: Put,
   read: (name: string) => Promise<string>,
-  callers: Readonly<Record<ModelName, Caller>> = { 'stand-in': standInCaller },
+  callers: Readonly<Record<ModelName, Caller>> = { 'stand-in': standInCaller, 'stand-in-scenery': standInSceneryCaller },
   instructions: () => readonly Instruction[] = () => readInstructions(INSTRUCTIONS),
+  send: BflSend = fetchSend,
+  clock: Clock = realClock,
 ) {
   let held: readonly Instruction[] | undefined;
+  const ask: Ask = (step, prompt) => callModel(step, prompt, { setup: SETUP, callers, caching: PROMPT_CACHING });
   return makeDoor({
     readParameter: read,
     temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
     keepFeedback: makeFeedbackStore(env[FEEDBACK_BUCKET_VARIABLE] ?? '', put),
-    readNight: (request) =>
-      readNight((held ??= instructions()), request, (step, prompt) =>
-        callModel(step, prompt, { setup: SETUP, callers, caching: PROMPT_CACHING }),
-      ),
+    readNight: (request) => readNight((held ??= instructions()), request, ask),
+    paintNight: (bflKey) => paintNight(ask, (scene) => paint(send, bflKey, clock, scene)),
     now: () => new Date(),
   });
 }
diff --git a/server/src/hosts.ts b/server/src/hosts.ts
--- a/server/src/hosts.ts
+++ b/server/src/hosts.ts
@@ -1,22 +1,24 @@
 // Every host the server talks to lives here, and nowhere else
-// (CLAUDE.md R10, G9). Parameter Store, like Bedrock later, is reached
+// (CLAUDE.md R10, G9): Soniox's and Black Forest Labs' EU hosts. Parameter
+// Store, like Bedrock later, is reached
 // through the AWS SDK by Region, not by a host of ours.
 
 /** Soniox's EU REST host, which issues the short-lived keys (D69). */
 export const SONIOX_TEMPORARY_KEY_URL = 'https://api.eu.soniox.com/v1/auth/temporary-api-key';
 
 /**
- * Black Forest Labs' EU image API, and the end of the hosts it answers from:
- * for the image trial's test script (`trial/bfl.ts`, D144) and the curated
- * set's painter (`trial/curated.ts`, D147), on the owner's Mac only. Not a
- * host of the server, so not in HOSTS.
+ * Black Forest Labs' EU image API (D145), and the end of the hosts it
+ * answers from (its polling and delivery hosts, which it names in each
+ * reply): the night's personal painting (`painting.ts`, D162), and on the
+ * owner's Mac the image trial's test script (`trial/bfl.ts`, D144) and the
+ * curated set's painter (`trial/curated.ts`, D147).
  */
 export const BFL_API_URL = 'https://api.eu.bfl.ai/v1';
 export const BFL_HOST_SUFFIX = '.bfl.ai';
 
 /**
  * Not hosts, and never fetched: the names inside the invisible AI tag that
- * the curated set's painter writes into every shipped painting (D123, D147),
+ * our own code writes into every painting (D123, D147, D162),
  * the IPTC digital source type in an XMP packet. Here because every such
  * literal lives in this file (G9).
  */
@@ -25,4 +27,4 @@ export const XMP_RDF = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
 export const XMP_IPTC_EXT = 'http://iptc.org/std/Iptc4xmpExt/2008-02-29/';
 export const AI_SOURCE_TYPE = 'http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia';
 
-export const HOSTS: readonly string[] = Object.freeze(['api.eu.soniox.com']);
+export const HOSTS: readonly string[] = Object.freeze(['api.eu.soniox.com', 'api.eu.bfl.ai']);
diff --git a/server/trial/jpeg.ts b/server/src/jpeg.ts
similarity index 96%
rename from server/trial/jpeg.ts
rename to server/src/jpeg.ts
--- a/server/trial/jpeg.ts
+++ b/server/src/jpeg.ts
@@ -1,9 +1,9 @@
-// What the curated set's painter reads and writes inside its images
-// (D147), in plain bytes, with no package: a PNG's size; a JPEG's size,
+// What the curated set's painter (D147) and the server's personal painting
+// (D162) read and write inside their images, in plain bytes, with no package: a PNG's size; a JPEG's size,
 // its colour profile and its AI tag; and the tag itself, written by our
 // own code (D123): an XMP packet naming the IPTC digital source type
 // "trainedAlgorithmicMedia", in an APP1 segment after the JPEG's start.
-import { AI_SOURCE_TYPE, XMP_HEADER, XMP_IPTC_EXT, XMP_RDF } from '../src/hosts.ts';
+import { AI_SOURCE_TYPE, XMP_HEADER, XMP_IPTC_EXT, XMP_RDF } from './hosts.ts';
 
 export interface Size {
   readonly width: number;
diff --git a/server/src/models.ts b/server/src/models.ts
--- a/server/src/models.ts
+++ b/server/src/models.ts
@@ -12,8 +12,8 @@ import { safeLog } from './safe-log.ts';
 export const STEPS = ['opening', 'readings', 'checks', 'scenery', 'recurrence'] as const;
 export type Step = (typeof STEPS)[number];
 
-/** The models with a caller. Claude's are added with their caller. */
-export const MODELS = ['stand-in'] as const;
+/** The models with a caller: the stand-ins'. Claude's are added with their caller. */
+export const MODELS = ['stand-in', 'stand-in-scenery'] as const;
 export type ModelName = (typeof MODELS)[number];
 
 /** A step's model, with its reasoning capped in tokens where it has one. */
@@ -29,7 +29,7 @@ export const SETUP: Setup = Object.freeze({
   opening: { model: 'stand-in' },
   readings: { model: 'stand-in' },
   checks: { model: 'stand-in' },
-  scenery: { model: 'stand-in' },
+  scenery: { model: 'stand-in-scenery' },
   recurrence: { model: 'stand-in' },
 });
 
@@ -63,6 +63,7 @@ export type Price = Usage;
 
 export const PRICES: Readonly<Record<ModelName, Price>> = Object.freeze({
   'stand-in': { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
+  'stand-in-scenery': { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
 });
 
 /** One call's counts and cost (millionths of a dollar), as the phone keeps them. */
@@ -111,3 +112,16 @@ export const standInCaller: Caller = async () => ({
   text: STAND_IN_TEXT,
   usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
 });
+
+/**
+ * The scenery step's stand-in (D143; D162): one fixed placeholder scene,
+ * the curated set's first (`trial/scenes.ts`, read by the owner), the same
+ * whatever it is asked; it reads nothing of the prompt and counts no tokens.
+ */
+// not-dreamer-facing: a scenery prompt for the image model, never shown.
+export const STAND_IN_SCENERY = 'a wheat field at dawn under a pale gold sky';
+
+export const standInSceneryCaller: Caller = async () => ({
+  text: STAND_IN_SCENERY,
+  usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
+});
diff --git a/server/src/painting.ts b/server/src/painting.ts
new file mode 100644
--- /dev/null
+++ b/server/src/painting.ts
@@ -0,0 +1,226 @@
+// The night's personal painting (D143, D145, D146, D123; D162): the scenery
+// step names a neutral scene through the one model interface (models.ts),
+// and Black Forest Labs' flux-2-klein-4b on its EU endpoint paints it in the
+// one style. Until the readings' model writes the scene inside our chain,
+// the scenery step's stand-in names one fixed placeholder scene and reads
+// nothing of the night: the request holds nothing at all (D143). The image
+// comes back as a JPEG, gets the invisible AI tag written by our own code
+// (D123) and goes to the phone; nothing is kept here, and only numbers are
+// logged (R3). The key is the owner's, from Parameter Store, sent to BFL's
+// own hosts only, over https.
+import { BFL_API_URL, BFL_HOST_SUFFIX } from './hosts.ts';
+import { aiTagged, jpegSize, withAiTag } from './jpeg.ts';
+import type { Prompt } from './models.ts';
+import type { Ask } from './reading.ts';
+
+/** The model (D145). */
+export const PAINTING_MODEL = 'flux-2-klein-4b';
+
+/** The one style (D146), first written for the image trial. */
+// not-dreamer-facing: the painting style sent to the image model (D146).
+export const STYLE = 'Van Gogh style oil painting, thick impasto brushstrokes, no people';
+
+/** The framing every painting shares: the subject in the middle band (D147 item 2). */
+// not-dreamer-facing: the framing sent to the image model (D147).
+export const FRAME = 'wide view, the subject across the middle band, no text';
+
+/** The curated set's size (D148), so a night's picture is cut the same way. */
+export const PAINTING_SIZE = Object.freeze({ width: 1280, height: 960 });
+
+/** The most a painting may weigh, on its way to the phone. */
+export const PAINTING_BYTES_LIMIT = 4194304;
+
+/** The longest scene the scenery step may name. */
+export const SCENE_LIMIT = 500;
+
+/** A request's body may be this long at most: it holds nothing (`{}`). */
+export const PAINTING_BODY_LIMIT = 64;
+
+/** How long BFL may take, from the request to its last poll, and between polls. */
+export const GIVE_UP_MS = 30000;
+export const POLL_MS = 500;
+
+/** Each request to BFL waits this long at most. */
+export const REQUEST_MS = 10000;
+
+/** One credit is USD 0.01 [READ, docs.bfl.ai, 2026-11-23]: in millionths of a dollar. */
+export const MILLIONTHS_PER_CREDIT = 10000;
+
+/**
+ * No painting: BFL's HTTP status; 0 no answer; -1 an answer not as its
+ * pages give it; -2 moderated; -3 failed; -4 no image in time; -5 an image
+ * not as asked (not a JPEG of the size, too big, or holding a packet of
+ * its own where the AI tag goes); -6 a scene that is none.
+ */
+export class PaintingFailure extends Error {
+  readonly code: number;
+
+  constructor(code: number) {
+    super('painting');
+    this.code = code;
+  }
+}
+
+export interface BflReply {
+  readonly status: number;
+  json(): Promise<unknown>;
+  bytes(): Promise<Buffer>;
+}
+
+export type BflSend = (
+  url: string,
+  init: { method: 'POST' | 'GET'; headers: Record<string, string>; body?: string },
+) => Promise<BflReply>;
+
+export interface Clock {
+  now(): number;
+  sleep(ms: number): Promise<void>;
+}
+
+/** The scenery step's prompt: nothing of the night (D143). */
+export const SCENERY_PROMPT: Prompt = Object.freeze({ fixed: Object.freeze([]), words: '' });
+
+/** Why a painting's request is refused (400 or 413), or null: it must hold nothing. */
+export function paintingRefused(body: string): 400 | 413 | null {
+  if (body.length > PAINTING_BODY_LIMIT) return 413;
+  let parsed: unknown;
+  try {
+    parsed = JSON.parse(body);
+  } catch {
+    return 400;
+  }
+  const empty = typeof parsed === 'object' && parsed !== null && !Array.isArray(parsed) && Object.keys(parsed).length === 0;
+  return empty ? null : 400;
+}
+
+/** The scenery step's text as a scene: one line, not blank, not too long; else null. */
+export function sceneOf(text: string): string | null {
+  const scene = text.trim();
+  return scene === '' || scene.length > SCENE_LIMIT || /[\r\n]/.test(scene) ? null : scene;
+}
+
+/** What BFL is asked to paint: the scene, the framing and the style, in that order. */
+export function promptOf(scene: string): string {
+  return `${scene}, ${FRAME}, ${STYLE}`;
+}
+
+const WAITING = ['Pending', 'Reasoning', 'Generating'];
+const MODERATED = ['Request Moderated', 'Content Moderated'];
+
+async function call(send: BflSend, url: string, init: Parameters<BflSend>[1]): Promise<BflReply> {
+  try {
+    return await send(url, init);
+  } catch {
+    throw new PaintingFailure(0);
+  }
+}
+
+async function jsonOf(reply: BflReply): Promise<Record<string, unknown>> {
+  let parsed: unknown;
+  try {
+    parsed = await reply.json();
+  } catch {
+    throw new PaintingFailure(-1);
+  }
+  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) throw new PaintingFailure(-1);
+  return parsed as Record<string, unknown>;
+}
+
+// An address BFL names: only its own hosts, over https, ever get a request.
+function bflUrl(value: unknown): string {
+  if (typeof value !== 'string') throw new PaintingFailure(-1);
+  let url: URL;
+  try {
+    url = new URL(value);
+  } catch {
+    throw new PaintingFailure(-1);
+  }
+  if (url.protocol !== 'https:' || !url.hostname.endsWith(BFL_HOST_SUFFIX)) throw new PaintingFailure(-1);
+  return url.href;
+}
+
+/** The image as the phone gets it: a JPEG of the size asked, under the limit, with the AI tag (D123). */
+export function finished(jpeg: Buffer): Buffer {
+  let tagged: Buffer;
+  try {
+    const size = jpegSize(jpeg);
+    if (size.width !== PAINTING_SIZE.width || size.height !== PAINTING_SIZE.height) throw new PaintingFailure(-5);
+    tagged = withAiTag(jpeg);
+  } catch {
+    throw new PaintingFailure(-5);
+  }
+  if (!aiTagged(tagged) || tagged.length > PAINTING_BYTES_LIMIT) throw new PaintingFailure(-5);
+  return tagged;
+}
+
+/** One painting of [scene]: the request, the polling, the image and the credits BFL's reply names. */
+export async function paint(
+  send: BflSend,
+  key: string,
+  clock: Clock,
+  scene: string,
+): Promise<{ jpeg: Buffer; credits: number }> {
+  const until = clock.now() + GIVE_UP_MS;
+  const made = await call(send, `${BFL_API_URL}/${PAINTING_MODEL}`, {
+    method: 'POST',
+    headers: { 'x-key': key, 'Content-Type': 'application/json' },
+    body: JSON.stringify({ prompt: promptOf(scene), ...PAINTING_SIZE, output_format: 'jpeg' }),
+  });
+  if (made.status !== 200) throw new PaintingFailure(made.status);
+  const task = await jsonOf(made);
+  const polling = bflUrl(task['polling_url']);
+  const credits = task['cost'];
+  if (typeof credits !== 'number' || !Number.isFinite(credits) || credits < 0) throw new PaintingFailure(-1);
+  for (;;) {
+    const polled = await call(send, polling, { method: 'GET', headers: { 'x-key': key } });
+    if (polled.status !== 200) throw new PaintingFailure(polled.status);
+    const state = await jsonOf(polled);
+    const status = state['status'];
+    if (status === 'Ready') {
+      const result = state['result'];
+      const sample = typeof result === 'object' && result !== null ? (result as Record<string, unknown>)['sample'] : undefined;
+      const got = await call(send, bflUrl(sample), { method: 'GET', headers: {} });
+      if (got.status !== 200) throw new PaintingFailure(got.status);
+      let bytes: Buffer;
+      try {
+        bytes = await got.bytes();
+      } catch {
+        throw new PaintingFailure(0);
+      }
+      return { jpeg: finished(bytes), credits };
+    }
+    if (typeof status === 'string' && MODERATED.includes(status)) throw new PaintingFailure(-2);
+    if (typeof status !== 'string' || !WAITING.includes(status)) throw new PaintingFailure(-3);
+    if (clock.now() >= until) throw new PaintingFailure(-4);
+    await clock.sleep(POLL_MS);
+  }
+}
+
+/** A night's painting, as the phone gets it, and what it cost in millionths of a dollar. */
+export interface Painted {
+  readonly jpeg: Buffer;
+  readonly cost: number;
+}
+
+/** The scenery step through [ask], then [paintScene]; a scene that is none fails (-6). */
+export async function paintNight(
+  ask: Ask,
+  paintScene: (scene: string) => Promise<{ jpeg: Buffer; credits: number }>,
+): Promise<Painted> {
+  const { text } = await ask('scenery', SCENERY_PROMPT);
+  const scene = sceneOf(text);
+  if (scene === null) throw new PaintingFailure(-6);
+  const made = await paintScene(scene);
+  return { jpeg: made.jpeg, cost: Math.round(made.credits * MILLIONTHS_PER_CREDIT) };
+}
+
+/** Node's fetch, each request waiting [REQUEST_MS] at most. */
+export const fetchSend: BflSend = async (url, init) => {
+  const r = await fetch(url, { ...init, signal: AbortSignal.timeout(REQUEST_MS) });
+  return { status: r.status, json: () => r.json(), bytes: async () => Buffer.from(await r.arrayBuffer()) };
+};
+
+export const realClock: Clock = {
+  now: () => Date.now(),
+  sleep: (ms) => new Promise((done) => setTimeout(done, ms)),
+};
diff --git a/server/src/parameter-names.ts b/server/src/parameter-names.ts
--- a/server/src/parameter-names.ts
+++ b/server/src/parameter-names.ts
@@ -1,6 +1,6 @@
-// The two keys the server reads from Parameter Store, as SecureStrings
+// The three keys the server reads from Parameter Store, as SecureStrings
 // the owner makes outside the stack (CloudFormation cannot make one).
-// The stack grants reading these two and no other (D69).
+// The stack grants reading these three and no other (D69).
 
 /** The shared beta key: 48 characters of A-Z, a-z and 0-9 (D18). */
 export const BETA_KEY_PARAMETER = '/souldreams/beta-key';
@@ -8,4 +8,7 @@ export const BETA_KEY_PARAMETER = '/souldreams/beta-key';
 /** Soniox's project key, which may create temporary keys. */
 export const SONIOX_KEY_PARAMETER = '/souldreams/soniox-key';
 
-export const PARAMETERS: readonly string[] = Object.freeze([BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER]);
+/** Black Forest Labs' key, for the night's painting (D162 item 4: its permanent name). */
+export const BFL_KEY_PARAMETER = '/souldreams/bfl-key';
+
+export const PARAMETERS: readonly string[] = Object.freeze([BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER, BFL_KEY_PARAMETER]);
diff --git a/server/src/safe-log.ts b/server/src/safe-log.ts
--- a/server/src/safe-log.ts
+++ b/server/src/safe-log.ts
@@ -26,6 +26,12 @@ export const LOG_EVENTS = [
   // in STEPS and MODELS), its input, output, cache-read and cache-written
   // tokens, and its cost in millionths of a dollar. Numbers only.
   'modelUsage',
+  // A night's painting (D162): given (with its cost in millionths of a
+  // dollar); refused (with its status, 400 or 413); failed (with its code,
+  // painting.ts's PaintingFailure, -7 anything else). Never a word.
+  'paintingGiven',
+  'paintingRefused',
+  'paintingFailed',
 ] as const;
 export type LogEvent = (typeof LOG_EVENTS)[number];
 
diff --git a/server/test/curated-fakes.ts b/server/test/curated-fakes.ts
--- a/server/test/curated-fakes.ts
+++ b/server/test/curated-fakes.ts
@@ -3,7 +3,7 @@
 import { readFileSync, writeFileSync } from 'node:fs';
 import type { Clock, Reply, Send } from '../trial/bfl.ts';
 import type { Convert } from '../trial/curated.ts';
-import { pngSize } from '../trial/jpeg.ts';
+import { pngSize } from '../src/jpeg.ts';
 
 export const KEY = 'invented-key-0123456789';
 const POLLING = 'https://api.eu.bfl.ai/v1/get_result?id=';
diff --git a/server/test/curated-jpeg.test.ts b/server/test/curated-jpeg.test.ts
--- a/server/test/curated-jpeg.test.ts
+++ b/server/test/curated-jpeg.test.ts
@@ -5,7 +5,7 @@ import { existsSync, readFileSync } from 'node:fs';
 import { test } from 'node:test';
 import { AI_SOURCE_TYPE } from '../src/hosts.ts';
 import { SRGB_PROFILE } from '../trial/curated.ts';
-import { aiPacket, aiTagged, hasSrgb, jpegSize, pngSize, withAiTag, withProfile } from '../trial/jpeg.ts';
+import { aiPacket, aiTagged, hasSrgb, jpegSize, pngSize, withAiTag, withProfile } from '../src/jpeg.ts';
 import { fakeJpeg, fakePng, fakeProfile, segment } from './curated-fakes.ts';
 
 test("a PNG's size from its header; anything else is none", () => {
diff --git a/server/test/curated.test.ts b/server/test/curated.test.ts
--- a/server/test/curated.test.ts
+++ b/server/test/curated.test.ts
@@ -27,7 +27,7 @@ import {
   sipsConvert,
   type SetState,
 } from '../trial/curated.ts';
-import { aiTagged, hasSrgb, jpegSize, withAiTag } from '../trial/jpeg.ts';
+import { aiTagged, hasSrgb, jpegSize, withAiTag } from '../src/jpeg.ts';
 import { STYLE } from '../trial/measure.ts';
 import { FRAME, SCENES, SKY_SCENE, scenePrompt, skyPrompt } from '../trial/scenes.ts';
 import { KEY, fakeApi, fakeConvert, fakeJpeg, fakePng, fakeProfile } from './curated-fakes.ts';
diff --git a/server/test/dist.test.ts b/server/test/dist.test.ts
--- a/server/test/dist.test.ts
+++ b/server/test/dist.test.ts
@@ -19,8 +19,10 @@ test('the compiled files, the marker and the instructions, nothing else', () =>
     'instructions',
     'instructions.js',
     'instructions/AWAITING-INSTRUCTIONS.md',
+    'jpeg.js',
     'models.js',
     'package.json',
+    'painting.js',
     'parameter-names.js',
     'parameters.js',
     'reading.js',
diff --git a/server/test/door.test.ts b/server/test/door.test.ts
--- a/server/test/door.test.ts
+++ b/server/test/door.test.ts
@@ -1,13 +1,15 @@
 // The front door (head's message 14; D71; D152; head's message 33): POST /
 // with the beta key gets a short-lived Soniox key; POST /feedback with it
-// keeps one feedback; POST /reading with it reads one night; anything else
-// gets nothing, with one code. It never touches the caller's address or
-// another header, and reads a body only for feedback and a reading, after
-// the key (R3, R4).
+// keeps one feedback; POST /reading with it reads one night; POST /painting
+// with it paints one night's picture from nothing of the night (D162);
+// anything else gets nothing, with one code. It never touches the caller's
+// address or another header, and reads a body only for feedback, a reading
+// and a painting, after the key (R3, R4).
 import assert from 'node:assert/strict';
 import { afterEach, beforeEach, test } from 'node:test';
 import { type DoorDeps, type DoorEvent, makeDoor } from '../src/door.ts';
-import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from '../src/parameter-names.ts';
+import { PaintingFailure } from '../src/painting.ts';
+import { BETA_KEY_PARAMETER, BFL_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from '../src/parameter-names.ts';
 import { type ReadingRequest, STAND_IN_READINGS } from '../src/reading.ts';
 
 // The stand-in's one call, as the readings step reports it.
@@ -17,6 +19,8 @@ import { SonioxFailure } from '../src/soniox.ts';
 
 const KEY = 'Ab0'.repeat(16);
 const PROJECT = 'project-key-in-a-test';
+const PAINTED = Buffer.from([0xff, 0xd8, 1, 2, 0xff, 0xd9]);
+const BFL = 'invented-bfl-key';
 const ISSUED = { key: 'snx_temp_test', expiresAt: '2026-11-13T12:00:00Z' };
 
 let lines: string[] = [];
@@ -39,16 +43,17 @@ interface Calls {
   soniox: string[];
   kept: [string, string][];
   nights: ReadingRequest[];
+  painted: string[];
 }
 
 function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
-  const calls: Calls = { read: [], soniox: [], kept: [], nights: [] };
+  const calls: Calls = { read: [], soniox: [], kept: [], nights: [], painted: [] };
   return {
     calls,
     deps: {
       readParameter: async (name) => {
         calls.read.push(name);
-        return name === BETA_KEY_PARAMETER ? KEY : PROJECT;
+        return name === BETA_KEY_PARAMETER ? KEY : name === BFL_KEY_PARAMETER ? BFL : PROJECT;
       },
       temporaryKey: async (project) => {
         calls.soniox.push(project);
@@ -61,6 +66,10 @@ function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
         calls.nights.push(request);
         return { readings: STAND_IN_READINGS, usage: USAGE };
       },
+      paintNight: async (bflKey) => {
+        calls.painted.push(bflKey);
+        return { jpeg: PAINTED, cost: 14000 };
+      },
       now: () => NOW,
       ...over,
     },
@@ -146,6 +155,9 @@ test('another method or path: 404, nothing read', async () => {
     ['GET', '/reading'],
     ['POST', '/reading/'],
     ['POST', '/readings'],
+    ['GET', '/painting'],
+    ['POST', '/painting/'],
+    ['POST', '/paintings'],
   ] as const) {
     const d = deps();
     lines = [];
@@ -342,3 +354,70 @@ test('a reading: Parameter Store failing: 500, nothing read', async () => {
   assert.deepEqual(d.calls.nights, []);
   assert.deepEqual(lines, ['parameterFailed']);
 });
+
+test('a painting: 200, the JPEG as base64, its cost, nothing sent', async () => {
+  const d = deps();
+  const reply = await makeDoor(d.deps)(event('POST', '/painting', `Bearer ${KEY}`, '{}'));
+  assert.deepEqual(reply, {
+    statusCode: 200,
+    headers: { 'content-type': 'image/jpeg' },
+    body: PAINTED.toString('base64'),
+    isBase64Encoded: true,
+  });
+  assert.deepEqual(d.calls.read, [BETA_KEY_PARAMETER, BFL_KEY_PARAMETER]);
+  assert.deepEqual(d.calls.painted, [BFL]);
+  assert.deepEqual(lines, ['paintingGiven 14000']);
+});
+
+test('a painting: a bad key refused before the body is read', async () => {
+  for (const authorization of [undefined, `Bearer ${KEY.slice(0, 47)}1`]) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/painting', authorization)), { statusCode: 401 });
+    assert.deepEqual(d.calls.painted, []);
+  }
+});
+
+test('a painting: a body that holds anything is refused', async () => {
+  for (const [body, status] of [
+    ['{"dreams":["a"]}', 400],
+    ['', 400],
+    [`{${' '.repeat(80)}}`, 413],
+  ] as const) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/painting', `Bearer ${KEY}`, body)), { statusCode: status });
+    assert.deepEqual(d.calls.painted, []);
+    assert.deepEqual(d.calls.read, [BETA_KEY_PARAMETER]);
+    assert.deepEqual(lines, [`paintingRefused ${status}`]);
+  }
+});
+
+test('a painting failing: 502 and its code, never its message', async () => {
+  for (const [failure, code] of [
+    [new PaintingFailure(-2), -2],
+    [new PaintingFailure(402), 402],
+    [new Error('invented failure text'), -7],
+  ] as const) {
+    const d = deps({
+      paintNight: async () => {
+        throw failure;
+      },
+    });
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/painting', `Bearer ${KEY}`, '{}')), { statusCode: 502 });
+    assert.deepEqual(lines, [`paintingFailed ${code}`]);
+  }
+});
+
+test("a painting: Parameter Store failing: 500, nothing painted", async () => {
+  const d = deps({
+    readParameter: async (name) => {
+      if (name === BFL_KEY_PARAMETER) throw new Error('invented failure text');
+      return KEY;
+    },
+  });
+  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/painting', `Bearer ${KEY}`, '{}')), { statusCode: 500 });
+  assert.deepEqual(d.calls.painted, []);
+  assert.deepEqual(lines, ['parameterFailed']);
+});
diff --git a/server/test/handler.test.ts b/server/test/handler.test.ts
--- a/server/test/handler.test.ts
+++ b/server/test/handler.test.ts
@@ -5,7 +5,11 @@ import assert from 'node:assert/strict';
 import { afterEach, beforeEach, test } from 'node:test';
 import type { PutInput } from '../src/feedback-store.ts';
 import { handler, wire } from '../src/handler.ts';
-import { type Caller, STAND_IN_TEXT } from '../src/models.ts';
+import { type Caller, STAND_IN_SCENERY, STAND_IN_TEXT, standInSceneryCaller } from '../src/models.ts';
+import { type BflSend, type Clock, promptOf } from '../src/painting.ts';
+import { BFL_KEY_PARAMETER } from '../src/parameter-names.ts';
+import { aiTagged } from '../src/jpeg.ts';
+import { fakeJpeg } from './curated-fakes.ts';
 import { STAND_IN_READINGS } from '../src/reading.ts';
 import { setSink } from '../src/safe-log.ts';
 
@@ -99,7 +103,9 @@ test("a reading goes to its step's model with the folder's instructions", async
     seen.push([choice, prompt, cache]);
     return { text: JSON.stringify({ readings: [{ lens: 1, text: '[x]' }] }), usage: { input: 3, output: 2, cacheRead: 0, cacheWrite: 0 } };
   };
-  const door = wire({}, async () => {}, async () => KEY, { 'stand-in': caller }, () => [{ name: 'a.md', text: 'b' }]);
+  const door = wire({}, async () => {}, async () => KEY, { 'stand-in': caller, 'stand-in-scenery': standInSceneryCaller }, () => [
+    { name: 'a.md', text: 'b' },
+  ]);
   const reply = await door({
     rawPath: '/reading',
     headers: { authorization: `Bearer ${KEY}` },
@@ -135,3 +141,35 @@ test('the handler reads with the stand-in, and the instructions once', async ()
   assert.deepEqual(JSON.parse(first.body ?? '').readings, STAND_IN_READINGS);
   assert.equal(JSON.parse(STAND_IN_TEXT).readings.length, 3);
 });
+
+// The wiring of a painting (D162): the scenery step's stand-in, its scene
+// painted with BFL's key from Parameter Store, the JPEG tagged, as base64.
+test("a painting: the scenery stand-in's scene, BFL's key, the tagged JPEG", async () => {
+  const read: string[] = [];
+  const posted: { url: string; key: string | undefined; prompt: unknown }[] = [];
+  const send: BflSend = async (url, init) => {
+    posted.push({ url, key: init.headers['x-key'], prompt: init.body === undefined ? undefined : JSON.parse(init.body).prompt });
+    const json = url.includes('get_result')
+      ? { status: 'Ready', result: { sample: 'https://delivery-eu1.bfl.ai/n.jpeg' } }
+      : { polling_url: 'https://api.eu.bfl.ai/v1/get_result?id=n', cost: 1.4 };
+    return { status: 200, json: async () => json, bytes: async () => fakeJpeg(1280, 960) };
+  };
+  const clock: Clock = { now: () => 0, sleep: async () => {} };
+  const door = wire({}, async () => {}, async (name) => {
+    read.push(name);
+    return name === BFL_KEY_PARAMETER ? 'invented-bfl-key' : KEY;
+  }, undefined, () => [], send, clock);
+  const reply = await door({
+    rawPath: '/painting',
+    headers: { authorization: `Bearer ${KEY}` },
+    body: '{}',
+    requestContext: { http: { method: 'POST' } },
+  });
+  assert.equal(reply.statusCode, 200);
+  assert.equal(reply.isBase64Encoded, true);
+  assert.ok(aiTagged(Buffer.from(reply.body ?? '', 'base64')));
+  assert.deepEqual(read, ['/souldreams/beta-key', BFL_KEY_PARAMETER]);
+  assert.equal(posted[0]?.prompt, promptOf(STAND_IN_SCENERY));
+  assert.deepEqual(posted.map((p) => p.key), ['invented-bfl-key', 'invented-bfl-key', undefined]);
+  assert.deepEqual(lines, ['modelUsage 3 1 0 0 0 0 0', 'paintingGiven 14000']);
+});
diff --git a/server/test/hosts.test.ts b/server/test/hosts.test.ts
--- a/server/test/hosts.test.ts
+++ b/server/test/hosts.test.ts
@@ -3,7 +3,7 @@ import assert from 'node:assert/strict';
 import { test } from 'node:test';
 import * as hosts from '../src/hosts.ts';
 
-test("Soniox's EU REST host only", () => {
+test("Soniox's and Black Forest Labs' EU hosts only", () => {
   assert.deepEqual(Object.keys(hosts).sort(), [
     'AI_SOURCE_TYPE',
     'BFL_API_URL',
@@ -14,7 +14,7 @@ test("Soniox's EU REST host only", () => {
     'XMP_IPTC_EXT',
     'XMP_RDF',
   ]);
-  assert.deepEqual(hosts.HOSTS, ['api.eu.soniox.com']);
+  assert.deepEqual(hosts.HOSTS, ['api.eu.soniox.com', 'api.eu.bfl.ai']);
   assert.ok(Object.isFrozen(hosts.HOSTS));
 });
 
@@ -25,13 +25,13 @@ test('the temporary-key address is on that host, over https', () => {
   assert.equal(url.pathname, '/v1/auth/temporary-api-key');
 });
 
-test("the image test's address is the EU endpoint's, not the server's", () => {
+test("BFL's address is the EU endpoint's, a host of the server", () => {
   const url = new URL(hosts.BFL_API_URL);
   assert.equal(url.protocol, 'https:');
   assert.equal(url.host, 'api.eu.bfl.ai');
   assert.equal(url.pathname, '/v1');
   assert.ok(url.host.endsWith(hosts.BFL_HOST_SUFFIX));
-  assert.equal(hosts.HOSTS.includes(url.host), false);
+  assert.ok(hosts.HOSTS.includes(url.host));
 });
 
 test("the AI tag's names: IPTC's and Adobe's, no server host", () => {
diff --git a/server/test/models.test.ts b/server/test/models.test.ts
--- a/server/test/models.test.ts
+++ b/server/test/models.test.ts
@@ -10,11 +10,13 @@ import {
   PRICES,
   PROMPT_CACHING,
   SETUP,
+  STAND_IN_SCENERY,
   STAND_IN_TEXT,
   STEPS,
   callModel,
   costOf,
   standInCaller,
+  standInSceneryCaller,
 } from '../src/models.ts';
 import { setSink } from '../src/safe-log.ts';
 
@@ -34,9 +36,11 @@ const prompt = { fixed: ['instructions'], words: '{"dreams":["a"]}' };
 
 test('the steps, and one setting naming each step its model', () => {
   assert.deepEqual(STEPS, ['opening', 'readings', 'checks', 'scenery', 'recurrence']);
-  assert.deepEqual(MODELS, ['stand-in']);
+  assert.deepEqual(MODELS, ['stand-in', 'stand-in-scenery']);
   assert.deepEqual(Object.keys(SETUP), [...STEPS]);
-  for (const step of STEPS) assert.deepEqual(SETUP[step], { model: 'stand-in' });
+  for (const step of STEPS) {
+    assert.deepEqual(SETUP[step], { model: step === 'scenery' ? 'stand-in-scenery' : 'stand-in' });
+  }
   assert.ok(Object.isFrozen(SETUP));
 });
 
@@ -51,7 +55,7 @@ test("a call goes to its step's model, prompt and caching switch", async () => {
     return { text: 'x', usage: { input: 10, output: 2, cacheRead: 3, cacheWrite: 4 } };
   };
   const setup = { ...SETUP, readings: { model: 'stand-in' as const, reasoningCap: 64 } };
-  const answer = await callModel('readings', prompt, { setup, callers: { 'stand-in': caller }, caching: false });
+  const answer = await callModel('readings', prompt, { setup, callers: { 'stand-in': caller, 'stand-in-scenery': standInSceneryCaller }, caching: false });
   assert.deepEqual(seen, [[{ model: 'stand-in', reasoningCap: 64 }, prompt, false]]);
   assert.deepEqual(answer, {
     text: 'x',
@@ -61,12 +65,13 @@ test("a call goes to its step's model, prompt and caching switch", async () => {
 
 test('each call logs its step, model, tokens and cost, numbers only', async () => {
   const caller: Caller = async () => ({ text: 'never logged', usage: { input: 7, output: 5, cacheRead: 1, cacheWrite: 2 } });
-  await callModel('scenery', prompt, { setup: SETUP, callers: { 'stand-in': caller }, caching: false });
-  assert.deepEqual(lines, ['modelUsage 3 0 7 5 1 2 0']);
+  await callModel('scenery', prompt, { setup: SETUP, callers: { 'stand-in': standInCaller, 'stand-in-scenery': caller }, caching: false });
+  assert.deepEqual(lines, ['modelUsage 3 1 7 5 1 2 0']);
 });
 
 test('the cost: each count at its price, in millionths', () => {
   assert.deepEqual(PRICES['stand-in'], { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 });
+  assert.deepEqual(PRICES['stand-in-scenery'], { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 });
   const price = { input: 4, output: 20, cacheRead: 1, cacheWrite: 5 };
   assert.equal(costOf(price, { input: 1000, output: 100, cacheRead: 10, cacheWrite: 2 }), 4000 + 2000 + 10 + 10);
 });
@@ -75,7 +80,9 @@ test("a model failing: the call fails, nothing logged", async () => {
   const caller: Caller = async () => {
     throw new Error('invented failure text');
   };
-  await assert.rejects(callModel('readings', prompt, { setup: SETUP, callers: { 'stand-in': caller }, caching: false }));
+  await assert.rejects(
+    callModel('readings', prompt, { setup: SETUP, callers: { 'stand-in': caller, 'stand-in-scenery': caller }, caching: false }),
+  );
   assert.deepEqual(lines, []);
 });
 
@@ -85,3 +92,10 @@ test('the stand-in: the same placeholder, zero tokens, whatever asked', async ()
   assert.deepEqual(one, { text: STAND_IN_TEXT, usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 } });
   assert.deepEqual(two, one);
 });
+
+test("the scenery stand-in: one fixed scene, zero tokens, whatever asked", async () => {
+  const one = await standInSceneryCaller({ model: 'stand-in-scenery' }, prompt, false);
+  const two = await standInSceneryCaller({ model: 'stand-in-scenery' }, { fixed: [], words: '' }, true);
+  assert.deepEqual(one, { text: STAND_IN_SCENERY, usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 } });
+  assert.deepEqual(two, one);
+});
diff --git a/server/test/painting.test.ts b/server/test/painting.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/painting.test.ts
@@ -0,0 +1,257 @@
+// The night's personal painting (D143, D145, D146, D123; D162), against a
+// fake of BFL's API: no key, no network. The key and every address are
+// invented; the scene is the stand-in's placeholder.
+import assert from 'node:assert/strict';
+import { test } from 'node:test';
+import { BFL_API_URL } from '../src/hosts.ts';
+import { aiTagged, jpegSize } from '../src/jpeg.ts';
+import { STAND_IN_SCENERY } from '../src/models.ts';
+import {
+  type BflReply,
+  type BflSend,
+  type Clock,
+  FRAME,
+  GIVE_UP_MS,
+  MILLIONTHS_PER_CREDIT,
+  PAINTING_BYTES_LIMIT,
+  PAINTING_MODEL,
+  PAINTING_SIZE,
+  PaintingFailure,
+  paint,
+  paintingRefused,
+  paintNight,
+  promptOf,
+  SCENE_LIMIT,
+  SCENERY_PROMPT,
+  sceneOf,
+  STYLE,
+} from '../src/painting.ts';
+import { STYLE as TRIAL_STYLE } from '../trial/measure.ts';
+import { FRAME as TRIAL_FRAME, SCENES } from '../trial/scenes.ts';
+import { fakeJpeg, segment } from './curated-fakes.ts';
+
+const KEY = 'invented-key-0123456789';
+const POLLING = 'https://api.eu.bfl.ai/v1/get_result?id=n';
+const IMAGE = 'https://delivery-eu1.bfl.ai/n.jpeg';
+const JPEG = fakeJpeg(PAINTING_SIZE.width, PAINTING_SIZE.height);
+
+interface Seen {
+  method: string;
+  url: string;
+  headers: Record<string, string>;
+  body: Record<string, unknown> | undefined;
+}
+
+interface Options {
+  post?: number;
+  statuses?: readonly string[];
+  polling?: unknown;
+  sample?: unknown;
+  cost?: unknown;
+  image?: Buffer;
+  imageStatus?: number;
+  throws?: 'post' | 'poll' | 'image';
+  pollStatus?: number;
+}
+
+// Every request takes 500 ms; each poll answers the next status, the last
+// one again and again.
+function fake(options: Options = {}): { send: BflSend; seen: Seen[]; clock: Clock } {
+  let t = 0;
+  let polls = 0;
+  const seen: Seen[] = [];
+  const reply = (status: number, json: unknown, bytes?: Buffer): BflReply => ({
+    status,
+    json: async () => json,
+    bytes: async () => bytes ?? Buffer.alloc(0),
+  });
+  const statuses = options.statuses ?? ['Pending', 'Ready'];
+  const send: BflSend = async (url, init) => {
+    t += 500;
+    seen.push({
+      method: init.method,
+      url,
+      headers: init.headers,
+      body: init.body === undefined ? undefined : (JSON.parse(init.body) as Record<string, unknown>),
+    });
+    if (url.startsWith(BFL_API_URL) && init.method === 'POST') {
+      if (options.throws === 'post') throw new Error('invented network failure');
+      return reply(options.post ?? 200, {
+        id: 'n',
+        polling_url: 'polling' in options ? options.polling : POLLING,
+        cost: 'cost' in options ? options.cost : 1.5,
+      });
+    }
+    if (url === POLLING) {
+      if (options.throws === 'poll') throw new Error('invented network failure');
+      const status = statuses[Math.min(polls, statuses.length - 1)];
+      polls += 1;
+      return reply(options.pollStatus ?? 200, { status, result: { sample: 'sample' in options ? options.sample : IMAGE } });
+    }
+    if (options.throws === 'image') throw new Error('invented network failure');
+    return reply(options.imageStatus ?? 200, null, options.image ?? JPEG);
+  };
+  return {
+    send,
+    seen,
+    clock: {
+      now: () => t,
+      sleep: async (ms) => {
+        t += ms;
+      },
+    },
+  };
+}
+
+async function failsWith(promise: Promise<unknown>, code: number): Promise<void> {
+  await assert.rejects(promise, (e) => e instanceof PaintingFailure && e.code === code);
+}
+
+test("style and framing are the set's, the placeholder its first scene", () => {
+  assert.equal(PAINTING_MODEL, 'flux-2-klein-4b');
+  assert.equal(STYLE, TRIAL_STYLE);
+  assert.equal(FRAME, TRIAL_FRAME);
+  assert.equal(STAND_IN_SCENERY, SCENES[0]);
+  assert.equal(promptOf('a calm sea'), `a calm sea, ${FRAME}, ${STYLE}`);
+  assert.deepEqual(PAINTING_SIZE, { width: 1280, height: 960 });
+});
+
+test('a request holds nothing: only {} is taken', () => {
+  assert.equal(paintingRefused('{}'), null);
+  assert.equal(paintingRefused(' { } '), null);
+  for (const body of ['', 'x', '[]', 'null', '1', '{"dreams":["a"]}', '{"a":1}']) {
+    assert.equal(paintingRefused(body), 400, body);
+  }
+  assert.equal(paintingRefused(`{${' '.repeat(63)}}`), 413);
+});
+
+test('the scenery step reads nothing of the night', () => {
+  assert.deepEqual(SCENERY_PROMPT, { fixed: [], words: '' });
+  assert.ok(Object.isFrozen(SCENERY_PROMPT));
+});
+
+test("a scene: one line, not blank, within its limit", () => {
+  assert.equal(sceneOf('  a calm sea '), 'a calm sea');
+  assert.equal(sceneOf('x'.repeat(SCENE_LIMIT)), 'x'.repeat(SCENE_LIMIT));
+  for (const text of ['', '   ', 'a\nb', 'a\rb', 'x'.repeat(SCENE_LIMIT + 1)]) {
+    assert.equal(sceneOf(text), null);
+  }
+});
+
+test('a painting: the request, the polling, the tagged JPEG, the credits', async () => {
+  const f = fake();
+  const made = await paint(f.send, KEY, f.clock, 'a calm sea');
+  assert.equal(made.credits, 1.5);
+  assert.deepEqual(jpegSize(made.jpeg), PAINTING_SIZE);
+  assert.ok(aiTagged(made.jpeg));
+  assert.equal(aiTagged(JPEG), false);
+  assert.deepEqual(f.seen, [
+    {
+      method: 'POST',
+      url: `${BFL_API_URL}/flux-2-klein-4b`,
+      headers: { 'x-key': KEY, 'Content-Type': 'application/json' },
+      body: { prompt: promptOf('a calm sea'), width: 1280, height: 960, output_format: 'jpeg' },
+    },
+    { method: 'GET', url: POLLING, headers: { 'x-key': KEY }, body: undefined },
+    { method: 'GET', url: POLLING, headers: { 'x-key': KEY }, body: undefined },
+    { method: 'GET', url: IMAGE, headers: {}, body: undefined },
+  ]);
+});
+
+test("BFL's statuses: refused, moderated, failed, no answer", async () => {
+  let f = fake({ post: 402 });
+  await failsWith(paint(f.send, KEY, f.clock, 'a'), 402);
+  f = fake({ pollStatus: 500 });
+  await failsWith(paint(f.send, KEY, f.clock, 'a'), 500);
+  f = fake({ imageStatus: 404 });
+  await failsWith(paint(f.send, KEY, f.clock, 'a'), 404);
+  for (const status of ['Request Moderated', 'Content Moderated']) {
+    f = fake({ statuses: [status] });
+    await failsWith(paint(f.send, KEY, f.clock, 'a'), -2);
+  }
+  for (const status of ['Error', 'Task not found', undefined]) {
+    f = fake({ statuses: [status as string] });
+    await failsWith(paint(f.send, KEY, f.clock, 'a'), -3);
+  }
+  for (const where of ['post', 'poll', 'image'] as const) {
+    f = fake({ throws: where });
+    await failsWith(paint(f.send, KEY, f.clock, 'a'), 0);
+  }
+});
+
+test('no image within its time: it gives up, and stops polling', async () => {
+  const f = fake({ statuses: ['Pending'] });
+  await failsWith(paint(f.send, KEY, f.clock, 'a'), -4);
+  assert.ok(f.clock.now() <= GIVE_UP_MS + 1500);
+  assert.ok(f.seen.length > 10);
+});
+
+test("the key goes only to BFL's hosts, over https", async () => {
+  for (const polling of ['http://api.eu.bfl.ai/x', 'https://bfl.ai.example/x', 'not a url', 7, undefined]) {
+    const f = fake({ polling });
+    await failsWith(paint(f.send, KEY, f.clock, 'a'), -1);
+    assert.equal(f.seen.length, 1);
+  }
+  for (const sample of ['http://delivery-eu1.bfl.ai/n', 'https://example.com/n', 7]) {
+    const f = fake({ sample });
+    await failsWith(paint(f.send, KEY, f.clock, 'a'), -1);
+    assert.equal(f.seen.at(-1)?.url, POLLING);
+  }
+});
+
+test("a cost that is no number: fails before polling", async () => {
+  for (const cost of ['1.5', -1, Number.NaN, undefined]) {
+    const f = fake({ cost });
+    await failsWith(paint(f.send, KEY, f.clock, 'a'), -1);
+    assert.equal(f.seen.length, 1);
+  }
+});
+
+test('an image not as asked fails: size, kind, weight, a packet', async () => {
+  const xmp = segment(0xe1, Buffer.from('http://ns.adobe.com/xap/1.0/\0<x/>', 'latin1'));
+  const heavy = Buffer.concat([JPEG.subarray(0, JPEG.length - 2), Buffer.alloc(PAINTING_BYTES_LIMIT), JPEG.subarray(-2)]);
+  for (const image of [
+    fakeJpeg(1024, 1024),
+    Buffer.from([0x89, 0x50, 0x4e, 0x47]),
+    heavy,
+    fakeJpeg(1280, 960, { extra: [xmp] }),
+  ]) {
+    const f = fake({ image });
+    await failsWith(paint(f.send, KEY, f.clock, 'a'), -5);
+  }
+});
+
+test('a night: the scenery step, its scene painted, the cost', async () => {
+  const asked: unknown[] = [];
+  const painted: string[] = [];
+  const made = await paintNight(
+    async (step, prompt) => {
+      asked.push([step, prompt]);
+      return { text: ` ${STAND_IN_SCENERY}\n`, call: { step, model: 'stand-in-scenery', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 } };
+    },
+    async (scene) => {
+      painted.push(scene);
+      return { jpeg: JPEG, credits: 1.4 };
+    },
+  );
+  assert.deepEqual(asked, [['scenery', SCENERY_PROMPT]]);
+  assert.deepEqual(painted, [STAND_IN_SCENERY]);
+  assert.deepEqual(made, { jpeg: JPEG, cost: 14000 });
+  assert.equal(MILLIONTHS_PER_CREDIT, 10000);
+});
+
+test('a night whose scene is none: nothing painted', async () => {
+  let painted = 0;
+  const call = { step: 'scenery', model: 'stand-in-scenery', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 } as const;
+  await failsWith(
+    paintNight(
+      async () => ({ text: 'a\nb', call }),
+      async () => {
+        painted += 1;
+        return { jpeg: JPEG, credits: 1 };
+      },
+    ),
+    -6,
+  );
+  assert.equal(painted, 0);
+});
diff --git a/server/test/safe-log.test.ts b/server/test/safe-log.test.ts
--- a/server/test/safe-log.test.ts
+++ b/server/test/safe-log.test.ts
@@ -31,6 +31,9 @@ test('the events are these', () => {
     'readingRefused',
     'readingFailed',
     'modelUsage',
+    'paintingGiven',
+    'paintingRefused',
+    'paintingFailed',
   ]);
 });
 
diff --git a/server/test/stack.test.ts b/server/test/stack.test.ts
--- a/server/test/stack.test.ts
+++ b/server/test/stack.test.ts
@@ -44,12 +44,12 @@ test('eu-north-1, termination protection on', () => {
   assert.equal(stack.terminationProtection, true);
 });
 
-test('Node 24 on arm64, its own handler, 10 seconds', () => {
+test('Node 24 on arm64, its own handler, 60 seconds', () => {
   template.hasResourceProperties('AWS::Lambda::Function', {
     Runtime: 'nodejs24.x',
     Architectures: ['arm64'],
     Handler: 'handler.handler',
-    Timeout: 10,
+    Timeout: 60,
   });
 });
 
@@ -162,7 +162,7 @@ test("two outputs: the URL and the feedback bucket", () => {
   template.hasOutput('Url', { Value: { 'Fn::GetAtt': [Match.stringLikeRegexp('^HandlerFunctionUrl'), 'FunctionUrl'] } });
 });
 
-test('the role: its log group, the two keys, putting feedback', () => {
+test('the role: its log group, the three keys, putting feedback', () => {
   assert.equal(only('AWS::IAM::Role').Properties?.['ManagedPolicyArns'], undefined);
   // No inline policy on the role either (D44 a).
   assert.equal(only('AWS::IAM::Role').Properties?.['Policies'], undefined);
@@ -177,7 +177,7 @@ test('the role: its log group, the two keys, putting feedback', () => {
         {
           Action: 'ssm:GetParameter',
           Effect: 'Allow',
-          Resource: ['beta-key', 'soniox-key'].map((name) => ({
+          Resource: ['beta-key', 'soniox-key', 'bfl-key'].map((name) => ({
             'Fn::Join': [
               '',
               ['arn:', { Ref: 'AWS::Partition' }, ':ssm:eu-north-1:', { Ref: 'AWS::AccountId' }, `:parameter/souldreams/${name}`],
diff --git a/server/trial/curated.ts b/server/trial/curated.ts
--- a/server/trial/curated.ts
+++ b/server/trial/curated.ts
@@ -20,7 +20,7 @@ import { copyFileSync, existsSync, mkdirSync, readdirSync, readFileSync, rmSync,
 import { join } from 'node:path';
 import { pathToFileURL } from 'node:url';
 import { paintOnce, type Clock, type Send } from './bfl.ts';
-import { aiTagged, hasSrgb, jpegSize, pngSize, withAiTag, withProfile, type Size } from './jpeg.ts';
+import { aiTagged, hasSrgb, jpegSize, pngSize, withAiTag, withProfile, type Size } from '../src/jpeg.ts';
 import { SCENES, scenePrompt, skyPrompt } from './scenes.ts';
 
 export const MODEL = 'flux-2-klein-4b';
diff --git a/server/trial/measure.ts b/server/trial/measure.ts
--- a/server/trial/measure.ts
+++ b/server/trial/measure.ts
@@ -1,6 +1,8 @@
 // The image trial's requests and its arithmetic (D135, D136). The six
 // prompts are invented scenery, with no person and nothing from any
 // dream (R2). Every price is read from AWS's Price List (see PRICES).
+import { STYLE } from '../src/painting.ts';
+
 export type ModelKey = 'flux' | 'sdxl';
 
 // not-dreamer-facing: the trial's invented scenery, one per painting.
@@ -12,7 +14,8 @@ export const SCENES = [
   'an olive grove on rolling hills under a yellow sun',
   'a stone bridge over a calm canal at night',
 ] as const;
-export const STYLE = 'Van Gogh style oil painting, thick impasto brushstrokes, no people';
+// The one style (D146) lives with the server's painting now.
+export { STYLE };
 
 export function prompt(index: number): string {
   const scene = SCENES[index];
diff --git a/server/trial/scenes.ts b/server/trial/scenes.ts
--- a/server/trial/scenes.ts
+++ b/server/trial/scenes.ts
@@ -4,10 +4,10 @@
 // rejects any on the contact sheet; a rejected one is painted again from
 // the same scene with a new seed. Each prompt is its scene, the framing and
 // the one style (STYLE, D146), in that order.
-import { STYLE } from './measure.ts';
+import { FRAME, STYLE } from '../src/painting.ts';
 
-/** The framing every painting shares: the subject in the middle band (D147 item 2). */
-export const FRAME = 'wide view, the subject across the middle band, no text';
+// The framing every painting shares (D147 item 2) lives with the server's painting now.
+export { FRAME };
 
 /** New Dream's night sky (D112; D147 item 3): no moon, which is drawn in code. */
 export const SKY_SCENE = 'a deep blue night sky of small soft stars, no moon';
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147; S110 to S138, D152; S139 to S161, head's message 33; S162 to S178, head's message 34; S179 and S180, the review, D91), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147; S110 to S138, D152; S139 to S161, head's message 33; S162 to S178, head's message 34; S179 and S180, the review, D91; S181 to S206, D162), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -38,7 +38,7 @@ ROWS = [
     ('S7', 'infra/stack.ts', 'RetentionDays.ONE_WEEK', 'RetentionDays.ONE_MONTH',
      'test', 'logs: 7 days, JSON, application INFO, system WARN'),
     ('S8', 'infra/stack.ts', '      role,\n', '',
-     'test', 'the role: its log group, the two keys, putting feedback'),
+     'test', 'the role: its log group, the three keys, putting feedback'),
     ('S9', 'infra/account.ts', '  if (wanted !== resolved) {',
      '  if (wanted !== resolved && wanted !== undefined) {',
      'test', 'none passed, or another: refused'),
@@ -56,7 +56,7 @@ ROWS = [
      "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n"
      "      inlinePolicies: { x: new iam.PolicyDocument({ statements: ["
      "new iam.PolicyStatement({ actions: ['logs:*'], resources: ['*'] })] }) },\n",
-     'test', 'the role: its log group, the two keys, putting feedback'),
+     'test', 'the role: its log group, the three keys, putting feedback'),
     ('S15', 'infra/stack.ts', '      logGroup,\n',
      "      logGroup: logs.LogGroup.fromLogGroupName(this, 'Old', 'kept'),\n",
      'test', 'logs: 7 days, JSON, application INFO, system WARN'),
@@ -68,14 +68,14 @@ ROWS = [
     ('S18', 'infra/stack.ts', 'authType: lambda.FunctionUrlAuthType.NONE }',
      "authType: lambda.FunctionUrlAuthType.NONE, cors: { allowedOrigins: ['*'] } }",
      'test', 'one function URL: no authentication of its own, no CORS'),
-    ('S19', 'infra/stack.ts', '      timeout: Duration.seconds(10),\n',
-     '      timeout: Duration.seconds(10),\n      reservedConcurrentExecutions: 5,\n',
+    ('S19', 'infra/stack.ts', '      timeout: Duration.seconds(60),\n',
+     '      timeout: Duration.seconds(60),\n      reservedConcurrentExecutions: 5,\n',
      'test', 'no reserved concurrency yet (D71 Q12)'),
-    ('S20', 'infra/stack.ts', 'Duration.seconds(10)', 'Duration.seconds(30)',
-     'test', 'Node 24 on arm64, its own handler, 10 seconds'),
+    ('S20', 'infra/stack.ts', 'Duration.seconds(60)', 'Duration.seconds(30)',
+     'test', 'Node 24 on arm64, its own handler, 60 seconds'),
     ('S21', 'infra/stack.ts',
      "        conditions: { StringEquals: { 'kms:ViaService': `ssm.${REGION}.amazonaws.com` } },\n", '',
-     'test', 'the role: its log group, the two keys, putting feedback'),
+     'test', 'the role: its log group, the three keys, putting feedback'),
     ('S22', 'infra/stack.ts', "    new CfnOutput(this, 'Url', { value: url.url });", '    void url;',
      'test', "two outputs: the URL and the feedback bucket"),
     ('S23', 'src/soniox.ts', '  max_session_duration_seconds: 1800,\n',
@@ -259,19 +259,19 @@ ROWS = [
      "const GIVE_UP_MS = 120000;", "const GIVE_UP_MS = 1200000;",
      'test', 'a result not in two minutes stops the test'),
     # curated-set, Task 2 (D147): the curated set's painter and its AI tag.
-    ('S86', 'trial/jpeg.ts',
-     '(s.data.includes(SRGB_ASCII) || s.data.includes(SRGB_UTF16))', 's.data.includes(SRGB_UTF16)',
+    ('S86', 'src/jpeg.ts',
+     '(s.data.includes(SRGB_ASCII) || s.data.includes(SRGB_UTF16))', '(s.data.includes(SRGB_ASCII) && s.data.includes(SRGB_UTF16))',
      'test', 'sRGB: an ICC profile naming it, in either encoding'),
-    ('S87', 'trial/jpeg.ts',
+    ('S87', 'src/jpeg.ts',
      'if (xmpSegments(jpeg).length > 0) {', 'if (false) {',
      'test', 'a JPEG already holding XMP is refused'),
-    ('S88', 'trial/jpeg.ts',
+    ('S88', 'src/jpeg.ts',
      'first.marker === 0xe0 ? first.at + 4 + first.data.length : 2', 'false ? 0 : 2',
      'test', 'the tag goes in after JFIF and is read back'),
-    ('S89', 'trial/jpeg.ts',
-     '.toString(\'utf8\', XMP_ID.length).includes(named))', '.length > 0)',
+    ('S89', 'src/jpeg.ts',
+     '.toString(\'utf8\', XMP_ID.length).includes(named))', '.toString(\'utf8\', XMP_ID.length).includes(named) || s.data.length > 0)',
      'test', 'an untagged JPEG, or another packet, is not tagged'),
-    ('S90', 'trial/jpeg.ts',
+    ('S90', 'src/jpeg.ts',
      '{ width: frame.data.readUInt16BE(3), height: frame.data.readUInt16BE(1) }',
      '{ width: frame.data.readUInt16BE(1), height: frame.data.readUInt16BE(3) }',
      'test', "a JPEG's size from its frame header"),
@@ -313,19 +313,19 @@ ROWS = [
      'test', 'ship: the last attempts, renamed, with their fingerprints'),
     # curated-set, Task 3 fix (D147): sips on macOS 26 writes no ICC profile,
     # so our code embeds the OS's own sRGB profile.
-    ('S103', 'trial/jpeg.ts',
+    ('S103', 'src/jpeg.ts',
      " || profile.toString('latin1', 36, 40) !== 'acsp'", '',
      'test', 'a false or too big profile is refused with a code'),
-    ('S104', 'trial/jpeg.ts',
-     'profile.length > MAX_PROFILE', 'profile.length > 0xffffff',
+    ('S104', 'src/jpeg.ts',
+     'profile.length > MAX_PROFILE', 'profile.length > MAX_PROFILE * 256',
      'test', 'a false or too big profile is refused with a code'),
-    ('S105', 'trial/jpeg.ts',
+    ('S105', 'src/jpeg.ts',
      'if (!(s.marker === 0xe2 && s.data.subarray(0, ICC.length).equals(ICC))) {', 'if (true) {',
      'test', 'another profile is replaced, never doubled'),
-    ('S106', 'trial/jpeg.ts',
+    ('S106', 'src/jpeg.ts',
      'if (leading && s.marker !== 0xe0 && s.marker !== 0xe1) {', 'if (leading && s.marker !== 0xe0) {',
      'test', 'a profile is embedded after the leading APP0 and APP1'),
-    ('S107', 'trial/jpeg.ts',
+    ('S107', 'src/jpeg.ts',
      '  pieces.push(jpeg.subarray(end));\n', '',
      'test', 'a profile is embedded after the leading APP0 and APP1'),
     ('S108', 'trial/curated.ts',
@@ -381,10 +381,10 @@ ROWS = [
     ('S130', 'infra/stack.ts', '      enforceSSL: true,\n', '',
      'test', 'the feedback bucket refuses any request not over TLS'),
     ('S131', 'infra/stack.ts', "actions: ['s3:PutObject']", "actions: ['s3:PutObject', 's3:GetObject']",
-     'test', 'the role: its log group, the two keys, putting feedback'),
+     'test', 'the role: its log group, the three keys, putting feedback'),
     ('S132', 'infra/stack.ts', "resources: [feedback.arnForObjects('*')]",
      "resources: [feedback.bucketArn, feedback.arnForObjects('*')]",
-     'test', 'the role: its log group, the two keys, putting feedback'),
+     'test', 'the role: its log group, the three keys, putting feedback'),
     ('S133', 'infra/stack.ts', '      environment: { [FEEDBACK_BUCKET_VARIABLE]: feedback.bucketName },\n', '',
      'test', "one variable, the feedback bucket's name; no tracing"),
     ('S134', 'infra/stack.ts', "    new CfnOutput(this, 'FeedbackBucket', { value: feedback.bucketName });\n", '',
@@ -437,8 +437,8 @@ ROWS = [
     ('S151', 'src/instructions.ts', 'f.isFile() && ',
      '',
      'test', 'every .md file but the placeholder, in name order, unchanged'),
-    ('S152', 'src/door.ts', "'/feedback', '/reading']",
-     "'/feedback']",
+    ('S152', 'src/door.ts', "'/feedback', '/reading', '/painting']",
+     "'/feedback', '/painting']",
      'test', 'a reading: 200, the readings, the night as sent, its count'),
     ('S153', 'src/door.ts', "safeLog('readingGiven', [read.readings.length]);",
      "safeLog('readingGiven');",
@@ -449,8 +449,8 @@ ROWS = [
     ('S155', 'src/door.ts', "    safeLog('readingFailed');\n    return { statusCode: 502 };",
      "    safeLog('readingFailed');\n    return { statusCode: 500 };",
      'test', 'a reading: the model failing: 502 and a code'),
-    ('S156', 'src/door.ts', "return path === '/feedback' ?",
-     "return path !== '/feedback' ?",
+    ('S156', 'src/door.ts', "return path === '/reading' ? giveReading",
+     "return path === '/painting' ? giveReading",
      'test', 'a reading: 200, the readings, the night as sent, its count'),
     ('S157', 'src/door.ts', 'body: JSON.stringify({ readings: read.readings, usage: read.usage }),',
      'body: JSON.stringify({ readings: read.readings }),',
@@ -529,6 +529,63 @@ ROWS = [
      "words === '') return null;\n"
      '    readings.push({ lens: lens as number, text: words as string });',
      'test', "the model's answer: one to three whole readings, or null"),
+    # The night's personal painting (D162; D143, D145, D146, D123).
+    ('S181', 'src/painting.ts', 'return empty ? null : 400;', 'return empty || body.length > 0 ? null : 400;',
+     'test', 'a request holds nothing: only {} is taken'),
+    ('S182', 'src/painting.ts', 'if (body.length > PAINTING_BODY_LIMIT) return 413;', '',
+     'test', 'a request holds nothing: only {} is taken'),
+    ('S183', 'src/painting.ts', r'|| /[\r\n]/.test(scene)', '',
+     'test', 'a scene: one line, not blank, within its limit'),
+    ('S184', 'src/painting.ts', '`${scene}, ${FRAME}, ${STYLE}`', '`${scene}, ${STYLE}`',
+     'test', "style and framing are the set's, the placeholder its first scene"),
+    ('S185', 'src/painting.ts', "if (url.protocol !== 'https:' || ", 'if (',
+     'test', "the key goes only to BFL's hosts, over https"),
+    ('S186', 'src/painting.ts', '!url.hostname.endsWith(BFL_HOST_SUFFIX)', '!url.hostname.endsWith(BFL_HOST_SUFFIX.slice(BFL_HOST_SUFFIX.length))',
+     'test', "the key goes only to BFL's hosts, over https"),
+    ('S187', 'src/painting.ts', 'credits < 0) throw', 'credits < -2) throw',
+     'test', 'a cost that is no number: fails before polling'),
+    ('S188', 'src/painting.ts', 'if (clock.now() >= until)', 'if (clock.now() >= until + GIVE_UP_MS)',
+     'test', 'no image within its time: it gives up, and stops polling'),
+    ('S189', 'src/painting.ts', 'MODERATED.includes(status)) throw new PaintingFailure(-2);',
+     'MODERATED.includes(status)) throw new PaintingFailure(-3);',
+     'test', "BFL's statuses: refused, moderated, failed, no answer"),
+    ('S190', 'src/painting.ts',
+     'if (size.width !== PAINTING_SIZE.width || size.height !== PAINTING_SIZE.height)', 'if (size.width < 0)',
+     'test', 'an image not as asked fails: size, kind, weight, a packet'),
+    ('S191', 'src/painting.ts', ' || tagged.length > PAINTING_BYTES_LIMIT', '',
+     'test', 'an image not as asked fails: size, kind, weight, a packet'),
+    ('S192', 'src/painting.ts', 'tagged = withAiTag(jpeg);', 'tagged = jpeg.length > 0 ? jpeg : withAiTag(jpeg);',
+     'test', 'a painting: the request, the polling, the tagged JPEG, the credits'),
+    ('S193', 'src/painting.ts', "output_format: 'jpeg'", "output_format: 'png'",
+     'test', 'a painting: the request, the polling, the tagged JPEG, the credits'),
+    ('S194', 'src/painting.ts', 'if (scene === null) throw new PaintingFailure(-6);',
+     'if (scene === null) return { jpeg: Buffer.alloc(0), cost: 0 };',
+     'test', 'a night whose scene is none: nothing painted'),
+    ('S195', 'src/painting.ts', 'cost: Math.round(made.credits * MILLIONTHS_PER_CREDIT)', 'cost: made.credits',
+     'test', 'a night: the scenery step, its scene painted, the cost'),
+    ('S196', 'src/door.ts', 'paintingRefused(bodyOf(event));\n  if (refused !== null) {',
+     'paintingRefused(bodyOf(event));\n  if (refused === 413) {',
+     'test', 'a painting: a body that holds anything is refused'),
+    ('S197', 'src/door.ts', 'isBase64Encoded: true,', 'isBase64Encoded: false,',
+     'test', 'a painting: 200, the JPEG as base64, its cost, nothing sent'),
+    ('S198', 'src/door.ts', 'failure instanceof PaintingFailure ? failure.code : -7', 'failure instanceof PaintingFailure ? -7 : -7',
+     'test', 'a painting failing: 502 and its code, never its message'),
+    ('S199', 'src/door.ts', "'/reading', '/painting']", "'/reading']",
+     'test', 'a painting: 200, the JPEG as base64, its cost, nothing sent'),
+    ('S200', 'src/door.ts', 'deps.readParameter(BFL_KEY_PARAMETER)', 'deps.readParameter(BFL_KEY_PARAMETER.slice(1))',
+     'test', 'a painting: 200, the JPEG as base64, its cost, nothing sent'),
+    ('S201', 'src/handler.ts', 'paint(send, bflKey, clock, scene)', 'paint(send, bflKey.slice(1), clock, scene)',
+     'test', "a painting: the scenery stand-in's scene, BFL's key, the tagged JPEG"),
+    ('S202', 'src/models.ts', "scenery: { model: 'stand-in-scenery' },", "scenery: { model: 'stand-in' },",
+     'test', 'the steps, and one setting naming each step its model'),
+    ('S203', 'src/models.ts', 'text: STAND_IN_SCENERY,', 'text: STAND_IN_TEXT,',
+     'test', 'the scenery stand-in: one fixed scene, zero tokens, whatever asked'),
+    ('S204', 'src/hosts.ts', "'api.eu.soniox.com', 'api.eu.bfl.ai']", "'api.eu.soniox.com']",
+     'test', "Soniox's and Black Forest Labs' EU hosts only"),
+    ('S205', 'src/parameter-names.ts', ', BFL_KEY_PARAMETER]);', ']);',
+     'test', 'the role: its log group, the three keys, putting feedback'),
+    ('S206', 'src/parameter-names.ts', "'/souldreams/bfl-key'", "'/souldreams/trial/bfl-key'",
+     'test', 'the role: its log group, the three keys, putting feedback'),
 ]
 
 
~~~~

### Task 2 · App: a night's painting kept beside it (D162 item 3; storage change)

Changed: `app/lib/journal/journal_store.dart`, `app/lib/journal/journal.dart`, `app/lib/core/safe_log.dart`
(`paintingSwept`); `app/test/journal/journal_store_test.dart` (the group "paintings", eight tests; one test's
count of deletes); `tool/app_mutations.py` (A926 to A936).

Checks: `No issues found!`; `+845: All tests passed!`. Rows: A926 to A936, A1, A2, every one caught.

Commit:

> App: a read night's painting and its failed tries kept beside it, deleted with it, swept when orphaned (D162 item 3; storage change)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -133,6 +133,10 @@ enum LogEvent {
   readingRead,
   readingFailed,
   readingKeepFailed,
+
+  /// A night's personal painting or its count of failed tries, left by a
+  /// night whose file is gone, removed when the journal opens (D162 item 3).
+  paintingSwept,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -18,7 +18,10 @@
 //   the day it was said; edited (only the kept copy, D131 item 2), deleted
 //   one by one, several, or all; and swept when past the Recent window.
 //   Whether Life Context is on is decided above (`LifeContext`), not here.
+// - A read night's personal painting (D162 item 3), and how many of its
+//   tries failed, kept beside it and deleted with it.
 import 'dart:math';
+import 'dart:typed_data';
 
 import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier, listEquals;
 
@@ -129,6 +132,22 @@ final class Journal {
   Future<bool> keepReadings(String id, List<Reading> readings, {List<ModelUsage>? usage}) =>
       _store.update(id, (n) => n.readings == null ? n.withReadings(readings, usage: usage) : n);
 
+  /// Night [id]'s personal painting, or null while it has none (D162).
+  Future<Uint8List?> painting(String id) => _store.painting(id);
+
+  /// Every night's personal painting, by the night's id.
+  Future<Map<String, Uint8List>> paintings() => _store.paintings();
+
+  /// Keeps night [id]'s personal painting. Returns whether the night was
+  /// there: a night deleted meanwhile keeps nothing.
+  Future<bool> keepPainting(String id, Uint8List jpeg) => _store.keepPainting(id, jpeg);
+
+  /// How many of night [id]'s paintings failed (D162 item 2).
+  Future<int> paintTries(String id) => _store.paintTries(id);
+
+  /// Counts one more failed painting of night [id].
+  Future<bool> countPaintTry(String id) => _store.countPaintTry(id);
+
   /// Deletes the night, and everything of it (X11).
   Future<void> delete(String id) => _store.delete(id);
 
diff --git a/app/lib/journal/journal_store.dart b/app/lib/journal/journal_store.dart
--- a/app/lib/journal/journal_store.dart
+++ b/app/lib/journal/journal_store.dart
@@ -34,6 +34,14 @@
 // everything made from it); at open, sentences whose night's file is gone
 // are removed. A kept file that does not read is shown as nothing kept and
 // replaced by the next change.
+//
+// A read night's personal painting (D162 item 3) is kept here too, beside
+// its night: `painting-<id>.jpg`, the JPEG our server sent, written whole
+// and renamed, and only while the night's file is here; and, while none has
+// come, `painting-<id>.tries`, how many tries failed. Deleting the night
+// deletes both first, then the night (X11); at open, either one whose
+// night's file is gone is deleted. Nothing of a painting is kept anywhere
+// else, on the phone or on our server.
 import 'dart:convert';
 import 'dart:typed_data';
 
@@ -49,6 +57,8 @@ import 'night.dart';
 final _nightFile = RegExp(r'^night-([0-9a-f]{32})\.json$');
 final _id = RegExp(r'^[0-9a-f]{32}$');
 final _audioFile = RegExp(r'^audio-([0-9a-f]{32})-(0|[1-9][0-9]{0,9})\.pcm$');
+final _paintingFile = RegExp(r'^painting-([0-9a-f]{32})\.(jpg|tries)$');
+final _triesText = RegExp(r'^[1-9][0-9]{0,3}$');
 // How a night's file names a waiting recording (encodeNight's own form).
 final _named = RegExp(r'"waiting":"([0-9a-f]{32})"');
 
@@ -109,9 +119,22 @@ final class JournalStore {
     return 'audio-$id-$start.pcm';
   }
 
-  /// Opens the folder, and removes what an interrupted save left, and any
+  /// The name of night [id]'s personal painting (D162 item 3).
+  static String paintingOf(String id) {
+    if (!_id.hasMatch(id)) throw ArgumentError('id');
+    return 'painting-$id.jpg';
+  }
+
+  /// The name of the file counting night [id]'s failed paintings.
+  static String triesOf(String id) {
+    if (!_id.hasMatch(id)) throw ArgumentError('id');
+    return 'painting-$id.tries';
+  }
+
+  /// Opens the folder, and removes what an interrupted save left, any
   /// audio no night names (an interrupted recording, or a night deleted
-  /// before its audio was).
+  /// before its audio was), and any painting or count of tries whose
+  /// night's file is gone.
   static Future<JournalStore> open(JournalFiles files) => _run(() async {
     await files.open();
     for (final name in await files.list()) {
@@ -136,9 +159,17 @@ final class JournalStore {
         SafeLog.event(LogEvent.audioSwept);
       }
     }
+    final nights = {for (final name in names) ?_nightFile.firstMatch(name)?[1]};
+    for (final name in names) {
+      final m = _paintingFile.firstMatch(name);
+      if (m != null && !nights.contains(m[1])) {
+        await files.delete(name);
+        SafeLog.event(LogEvent.paintingSwept);
+      }
+    }
     final store = JournalStore._(files);
     try {
-      await store._sweepKept({for (final name in names) ?_nightFile.firstMatch(name)?[1]});
+      await store._sweepKept(nights);
     } on Object {
       // Swept again at the next opening.
       SafeLog.event(LogEvent.keptDeleteFailed);
@@ -234,8 +265,9 @@ final class JournalStore {
     return true;
   });
 
-  /// Deletes the night's file, the temporary file of a save of it, and the
-  /// audio of every recording of it still waiting (D92 item 4).
+  /// Deletes the night's file, the temporary file of a save of it, the
+  /// audio of every recording of it still waiting (D92 item 4), and its
+  /// painting and count of tries (D162 item 3), these first.
   Future<void> delete(String id) => _run(() => _delete(id));
 
   Future<void> _delete(String id) async {
@@ -243,6 +275,10 @@ final class JournalStore {
     final kept = await _readKept();
     final rest = [for (final k in kept) if (k.night != id) k];
     if (rest.length != kept.length) await _writeKept(rest);
+    for (final made in [paintingOf(id), triesOf(id)]) {
+      await _files.delete(made);
+      await _files.delete(tempPrefix + made);
+    }
     final bytes = await _files.read(name);
     await _files.delete(name);
     await _files.delete(tempPrefix + name);
@@ -318,6 +354,52 @@ final class JournalStore {
     }
   }
 
+  /// Night [id]'s personal painting, or null when none has come (D162).
+  Future<Uint8List?> painting(String id) => _run(() => _files.read(paintingOf(id)));
+
+  /// Every night's personal painting, by the night's id, for the nights
+  /// whose file is here.
+  Future<Map<String, Uint8List>> paintings() => _run(() async {
+    final names = await _files.list();
+    final out = <String, Uint8List>{};
+    for (final name in names) {
+      final m = _paintingFile.firstMatch(name);
+      if (m == null || m[2] != 'jpg' || !names.contains(fileOf(m[1]!))) continue;
+      final bytes = await _files.read(name);
+      if (bytes != null) out[m[1]!] = bytes;
+    }
+    return out;
+  });
+
+  /// Keeps [jpeg] as night [id]'s painting, written whole, and forgets its
+  /// failed tries, when that night's file is here. Returns whether it was.
+  Future<bool> keepPainting(String id, Uint8List jpeg) => _run(() async {
+    if (await _files.size(fileOf(id)) == null) return false;
+    await _whole(paintingOf(id), jpeg);
+    await _files.delete(triesOf(id));
+    return true;
+  });
+
+  /// How many of night [id]'s paintings failed: 0 with no count, or one
+  /// that does not read.
+  Future<int> paintTries(String id) => _run(() => _tries(id));
+
+  Future<int> _tries(String id) async {
+    final bytes = await _files.read(triesOf(id));
+    if (bytes == null) return 0;
+    final text = utf8.decode(bytes, allowMalformed: true);
+    return _triesText.hasMatch(text) ? int.parse(text) : 0;
+  }
+
+  /// Counts one more failed painting of night [id], when that night's file
+  /// is here. Returns whether it was.
+  Future<bool> countPaintTry(String id) => _run(() async {
+    if (await _files.size(fileOf(id)) == null) return false;
+    final tries = await _tries(id) + 1;
+    await _whole(triesOf(id), utf8.encode(tries.toString()));
+    return true;
+  });
+
   /// Deletes every entry in the journal's folder, whatever its name.
   Future<void> deleteAll() => _run(() => _files.deleteAll());
 
diff --git a/app/test/journal/journal_store_test.dart b/app/test/journal/journal_store_test.dart
--- a/app/test/journal/journal_store_test.dart
+++ b/app/test/journal/journal_store_test.dart
@@ -380,7 +380,8 @@ void main() {
     await pumpEventQueue();
     gated.hold.complete();
     await Future.wait([saving, deleting]);
-    expect(gated.log, ['rename:start', 'rename:end', 'delete:start', 'delete:start']);
+    // The painting, its count, their temporary files, then the night's two.
+    expect(gated.log, ['rename:start', 'rename:end', for (var i = 0; i < 6; i++) 'delete:start']);
     expect(files.everything(), isEmpty);
     expect(await store.nights(), isEmpty);
   });
@@ -774,4 +775,125 @@ void main() {
     expect(called, isFalse);
     expect(files.everything()[JournalStore.fileOf(a.id)], encodeNight(b));
   });
+
+  // A read night's personal painting (D162 item 3): beside its night,
+  // written whole, deleted with it, swept when its night is gone.
+  group('paintings', () {
+    final jpeg = Uint8List.fromList([0xff, 0xd8, 1, 2, 3, 0xff, 0xd9]);
+
+    test('a painting is kept whole beside its night, its tries forgotten', () async {
+      final store = await JournalStore.open(files);
+      final [first, second, ...] = nightsFromFixtures();
+      await store.save(first);
+      await store.save(second);
+      await store.countPaintTry(first.id);
+      expect(await store.keepPainting(first.id, jpeg), isTrue);
+      expect(await store.painting(first.id), jpeg);
+      expect(await store.painting(second.id), isNull);
+      expect(await store.paintTries(first.id), 0);
+      expect(files.everything().keys.toSet(), {
+        JournalStore.fileOf(first.id),
+        JournalStore.fileOf(second.id),
+        JournalStore.paintingOf(first.id),
+      });
+      expect(await store.paintings(), {first.id: jpeg});
+    });
+
+    test('a night that is gone keeps no painting and no tries', () async {
+      final store = await JournalStore.open(files);
+      final id = nightsFromFixtures().first.id;
+      expect(await store.keepPainting(id, jpeg), isFalse);
+      expect(await store.countPaintTry(id), isFalse);
+      expect(files.everything(), isEmpty);
+    });
+
+    test('failed tries counted one by one; a damaged count is none', () async {
+      final store = await JournalStore.open(files);
+      final first = nightsFromFixtures().first;
+      await store.save(first);
+      expect(await store.paintTries(first.id), 0);
+      for (final n in [1, 2, 3]) {
+        expect(await store.countPaintTry(first.id), isTrue);
+        expect(await store.paintTries(first.id), n);
+      }
+      for (final damaged in ['', '0', 'x', '-1', '12345']) {
+        await files.write(JournalStore.triesOf(first.id), utf8.encode(damaged));
+        expect(await store.paintTries(first.id), 0, reason: damaged);
+      }
+    });
+
+    test("deleting a night deletes its painting and tries, no other's", () async {
+      final store = await JournalStore.open(files);
+      final [first, second, ...] = nightsFromFixtures();
+      await store.save(first);
+      await store.save(second);
+      await store.keepPainting(first.id, jpeg);
+      await store.keepPainting(second.id, jpeg);
+      await store.countPaintTry(first.id);
+      await files.write(JournalStore.tempPrefix + JournalStore.paintingOf(first.id), jpeg);
+      await store.delete(first.id);
+      expect(files.everything().keys.toSet(), {JournalStore.fileOf(second.id), JournalStore.paintingOf(second.id)});
+      expect(await store.painting(first.id), isNull);
+    });
+
+    test('at open, paintings and counts of gone nights are swept', () async {
+      await files.open();
+      final first = nightsFromFixtures().first;
+      final loose = '4' * 32;
+      await files.write(JournalStore.fileOf(first.id), encodeNight(first));
+      for (final id in [first.id, loose]) {
+        await files.write(JournalStore.paintingOf(id), jpeg);
+        await files.write(JournalStore.triesOf(id), utf8.encode('1'));
+      }
+      final store = await JournalStore.open(files);
+      expect(files.everything().keys.toSet(), {
+        JournalStore.fileOf(first.id),
+        JournalStore.paintingOf(first.id),
+        JournalStore.triesOf(first.id),
+      });
+      expect(lines, ['paintingSwept', 'paintingSwept']);
+      await files.write(JournalStore.paintingOf(loose), jpeg);
+      expect(await store.paintings(), {first.id: jpeg});
+    });
+
+    test('a painting cut short leaves none and no temporary file', () async {
+      final broken = BrokenRename(Directory('${dir.path}/Journal'));
+      final store = await JournalStore.open(broken);
+      final first = nightsFromFixtures().first;
+      await broken.write(JournalStore.fileOf(first.id), encodeNight(first));
+      await broken.write(JournalStore.triesOf(first.id), utf8.encode('2'));
+      await expectLater(store.keepPainting(first.id, jpeg), throwsA(isA<FileSystemException>()));
+      expect(broken.everything().keys.toSet(), {JournalStore.fileOf(first.id), JournalStore.triesOf(first.id)});
+      expect(await store.paintTries(first.id), 2);
+    });
+
+    test('deleting the journal takes the paintings and the tries', () async {
+      final store = await JournalStore.open(files);
+      final first = nightsFromFixtures().first;
+      await store.save(first);
+      await store.keepPainting(first.id, jpeg);
+      await store.countPaintTry(first.id);
+      await store.deleteAll();
+      expect(files.everything(), isEmpty);
+    });
+
+    // docs/workflow.md (c) item 1: every invented night, counted before
+    // and after, reads back the same beside its painting.
+    test('paintings beside every invented night change no night', () async {
+      final store = await JournalStore.open(files);
+      final nights = nightsFromFixtures();
+      for (final n in nights) {
+        await store.save(n);
+      }
+      final before = files.everything();
+      for (final n in nights) {
+        await store.keepPainting(n.id, jpeg);
+      }
+      expect(await store.nights(), hasLength(nights.length));
+      expect((await store.nights()).toSet(), nights.toSet());
+      final after = files.everything();
+      expect(after.length, before.length * 2);
+      before.forEach((name, bytes) => expect(listEquals(after[name], bytes), isTrue, reason: name));
+    });
+  });
 }
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3765,6 +3765,35 @@ ROWS = [
      '    keptDelete: StandIns.keptDeleteDark,',
      '    keptDelete: DarkColours.lifecontextDelete.colour!,',
      'test/life_context/life_context_page_test.dart', "the dark theme: the dark box, its date, the founder's delete"),
+    # A read night's personal painting, kept beside it (D162 item 3).
+    ('A926', 'lib/journal/journal_store.dart', 'if (m != null && !nights.contains(m[1])) {',
+     'if (m != null && nights.isEmpty) {',
+     'test/journal/journal_store_test.dart', 'at open, paintings and counts of gone nights are swept'),
+    ('A927', 'lib/journal/journal_store.dart', 'for (final made in [paintingOf(id), triesOf(id)]) {',
+     'for (final made in [triesOf(id)]) {',
+     'test/journal/journal_store_test.dart', "deleting a night deletes its painting and tries, no other's"),
+    ('A928', 'lib/journal/journal_store.dart', '      await _files.delete(tempPrefix + made);\n', '',
+     'test/journal/journal_store_test.dart', "deleting a night deletes its painting and tries, no other's"),
+    ('A929', 'lib/journal/journal_store.dart', " || m[2] != 'jpg'", '',
+     'test/journal/journal_store_test.dart', 'at open, paintings and counts of gone nights are swept'),
+    ('A930', 'lib/journal/journal_store.dart', ' || !names.contains(fileOf(m[1]!))', '',
+     'test/journal/journal_store_test.dart', 'at open, paintings and counts of gone nights are swept'),
+    ('A931', 'lib/journal/journal_store.dart',
+     '    if (await _files.size(fileOf(id)) == null) return false;\n    await _whole(paintingOf(id), jpeg);',
+     '    await _whole(paintingOf(id), jpeg);',
+     'test/journal/journal_store_test.dart', 'a night that is gone keeps no painting and no tries'),
+    ('A932', 'lib/journal/journal_store.dart', '    await _files.delete(triesOf(id));\n    return true;', '    return true;',
+     'test/journal/journal_store_test.dart', 'a painting is kept whole beside its night, its tries forgotten'),
+    ('A933', 'lib/journal/journal_store.dart', 'await _whole(paintingOf(id), jpeg);', 'await _files.write(paintingOf(id), jpeg);',
+     'test/journal/journal_store_test.dart', 'a painting cut short leaves none and no temporary file'),
+    ('A934', 'lib/journal/journal_store.dart',
+     '    if (await _files.size(fileOf(id)) == null) return false;\n    await _whole(triesOf(id)',
+     '    await _whole(triesOf(id)',
+     'test/journal/journal_store_test.dart', 'a night that is gone keeps no painting and no tries'),
+    ('A935', 'lib/journal/journal_store.dart', 'final tries = await _tries(id) + 1;', 'final tries = await _tries(id) + 2;',
+     'test/journal/journal_store_test.dart', 'failed tries counted one by one; a damaged count is none'),
+    ('A936', 'lib/journal/journal_store.dart', '_triesText.hasMatch(text) ? int.parse(text) : 0', 'int.tryParse(text) ?? 0',
+     'test/journal/journal_store_test.dart', 'failed tries counted one by one; a damaged count is none'),
 ]
 
 
~~~~

### Task 3 · [OWNER] The storage rehearsal, SoulDreams Dev, invented nights only (docs/workflow.md (c) item 2)

The build of Task 2 alone changes nothing a dreamer sees: it only learns the new files' names, and nothing in it
writes one yet. What it proves is that every night kept before it is still whole beside it.

1. On the simulator, and then on the phone: SoulDreams Dev as it is now (from `main`), with at least five invented
   nights typed from `fixtures/invented-nights.json` (two dreams in one night, a Swedish night, a night read with
   Start Interpretation, a night with a recording still waiting if the beta key is in the build). Note each night's
   date and its first words.
2. Build SoulDreams Dev from this branch at Task 2's commit, and install it over the old one (never delete the app).
3. Expected: every night is there, with the same dates, the same dreams in the same order, the read night still
   read (its readings, its painting from the set), the waiting recording still waiting. Delete one night: it goes,
   the others stay. Anything else: stop and bring what you saw.

### Task 4 · App: the painting's request, its tries and the Painter (D162 items 1 and 2)

Changed: `app/lib/readings/painting.dart` (new), `app/lib/core/safe_log.dart` (`paintingMade`, `paintingFailed`,
`paintingKeepFailed`); `app/test/readings/painting_test.dart` (new, thirteen tests); `tool/app_mutations.py` (A937
to A953).

Checks: `No issues found!`; `+858: All tests passed!`. Rows: A937 to A953, every one caught.

Commit:

> App: the night's painting asked of our server with nothing of the night, kept, failures counted, three tries (D162)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -137,6 +137,14 @@ enum LogEvent {
   /// A night's personal painting or its count of failed tries, left by a
   /// night whose file is gone, removed when the journal opens (D162 item 3).
   paintingSwept,
+
+  /// A night's personal painting (D162): made, with its size in bytes; a
+  /// painting that failed, with the server's status (0 no answer, -1 not a
+  /// JPEG, -2 no server or key, -3 anything else); the journal failing to
+  /// read or keep it or its count.
+  paintingMade,
+  paintingFailed,
+  paintingKeepFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/readings/painting.dart b/app/lib/readings/painting.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/readings/painting.dart
@@ -0,0 +1,164 @@
+// A read night's personal painting, in plain Dart (D162; D143; D145): one
+// POST to our server's /painting with the beta key and nothing of the night
+// (`{}`), and the answer is the JPEG our server had Black Forest Labs paint,
+// with the invisible AI tag in it (D123). Only while Night images is
+// Personal, only for a read night with no painting yet, and only while
+// fewer than three tries have failed (D162 item 2): a failure is counted,
+// silently, and tried again the next time the night is opened. The painting
+// is kept beside its night on the phone and deleted with it (D162 item 3).
+// Nothing of a night is ever logged: a failure logs its status alone (R3).
+// SoulDreams Dev only, as the readings are.
+import 'dart:io';
+import 'dart:typed_data';
+
+import '../core/hosts.dart';
+import '../core/safe_log.dart';
+import '../journal/journal.dart';
+import '../journal/night.dart';
+import '../settings/settings.dart';
+
+/// The server gave no painting: its HTTP status, 0 for no answer, -1 for an
+/// answer that is not a JPEG within its limit, -2 for no server or beta key
+/// in this build.
+final class PaintingFailure implements Exception {
+  const PaintingFailure(this.status);
+
+  final int status;
+}
+
+/// Asks our server for a painting; completes with its JPEG.
+typedef SendPainting = Future<Uint8List> Function();
+
+/// How many tries of a night's painting may fail before none is asked for
+/// again (D162 item 2).
+const maxPaintTries = 3;
+
+/// The most a painting may weigh: our server's own limit.
+const maxPaintingBytes = 4194304;
+
+// Our server waits up to a minute for Black Forest Labs.
+const _wait = Duration(seconds: 75);
+final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
+
+/// Whether [bytes] are a whole JPEG: its start and its end.
+bool isJpeg(Uint8List bytes) =>
+    bytes.length >= 4 &&
+    bytes[0] == 0xff &&
+    bytes[1] == 0xd8 &&
+    bytes[bytes.length - 2] == 0xff &&
+    bytes[bytes.length - 1] == 0xd9;
+
+/// Sends one painting's request to [server]'s /painting: nothing of the
+/// night, `{}`; completes with the JPEG (200).
+Future<Uint8List> postPainting(Uri server, String betaKey) async {
+  final client = HttpClient()
+    ..userAgent = null
+    ..connectionTimeout = _wait;
+  final bytes = BytesBuilder(copy: false);
+  try {
+    final request = await client.postUrl(server.resolve('painting')).timeout(_wait);
+    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
+    request.headers.contentType = ContentType.json;
+    request.contentLength = 2;
+    request.write('{}');
+    final reply = await request.close().timeout(_wait);
+    if (reply.statusCode != 200) throw PaintingFailure(reply.statusCode);
+    await for (final chunk in reply.timeout(_wait)) {
+      bytes.add(chunk);
+      if (bytes.length > maxPaintingBytes) throw const PaintingFailure(-1);
+    }
+  } on PaintingFailure {
+    rethrow;
+  } on Object {
+    throw const PaintingFailure(0);
+  } finally {
+    client.close(force: true);
+  }
+  final jpeg = bytes.takeBytes();
+  if (!isJpeg(jpeg)) throw const PaintingFailure(-1);
+  return jpeg;
+}
+
+/// SoulDreams Dev's own: our server, with the build's beta key; with no
+/// server or a beta key not of its shape, every painting fails (-2).
+SendPainting livePainting({required String betaKey, String server = Hosts.server}) {
+  final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);
+  return () async {
+    if (!on) throw const PaintingFailure(-2);
+    return postPainting(Uri.parse(server), betaKey);
+  };
+}
+
+/// What one painting did.
+enum Painted { nothing, made, failed, gone }
+
+/// Paints [night] with [send] and keeps it in [journal], when Night images
+/// is Personal ([images]), the night is read, it has no painting yet and
+/// fewer than [maxPaintTries] tries have failed; [sending] is told just
+/// before the request goes. A failure is counted, and shows nothing. Never
+/// throws.
+Future<Painted> paintNight(
+  Journal journal,
+  SendPainting send,
+  Night night,
+  NightImages images, {
+  void Function()? sending,
+}) async {
+  if (images != NightImages.personal || night.readings == null) return Painted.nothing;
+  try {
+    if (await journal.painting(night.id) != null) return Painted.nothing;
+    if (await journal.paintTries(night.id) >= maxPaintTries) return Painted.nothing;
+  } on Object {
+    SafeLog.event(LogEvent.paintingKeepFailed);
+    return Painted.nothing;
+  }
+  sending?.call();
+  final Uint8List jpeg;
+  try {
+    jpeg = await send();
+  } on Object catch (e) {
+    SafeLog.event(LogEvent.paintingFailed, [e is PaintingFailure ? e.status : -3]);
+    try {
+      await journal.countPaintTry(night.id);
+    } on Object {
+      SafeLog.event(LogEvent.paintingKeepFailed);
+    }
+    return Painted.failed;
+  }
+  final bool kept;
+  try {
+    kept = await journal.keepPainting(night.id, jpeg);
+  } on Object {
+    SafeLog.event(LogEvent.paintingKeepFailed);
+    return Painted.failed;
+  }
+  if (!kept) return Painted.gone;
+  SafeLog.event(LogEvent.paintingMade, [jpeg.length]);
+  return Painted.made;
+}
+
+/// Paints nights, one request at a time for each night: a night already
+/// being painted is not asked for again, and whoever asks waits for the one
+/// under way.
+final class Painter {
+  Painter(this._send);
+
+  final SendPainting _send;
+  final _under = <String, Future<Painted>>{};
+
+  /// Whether night [id] is being painted now.
+  bool busy(String id) => _under.containsKey(id);
+
+  /// As [paintNight]; [sending] is told at once when the night is already
+  /// being painted.
+  Future<Painted> paint(Journal journal, Night night, NightImages images, {void Function()? sending}) {
+    final under = _under[night.id];
+    if (under != null) {
+      sending?.call();
+      return under;
+    }
+    final run = paintNight(journal, _send, night, images, sending: sending);
+    _under[night.id] = run;
+    return run.whenComplete(() => _under.remove(night.id));
+  }
+}
diff --git a/app/test/readings/painting_test.dart b/app/test/readings/painting_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/readings/painting_test.dart
@@ -0,0 +1,249 @@
+// A read night's personal painting, in plain Dart (D162; D143): one POST
+// to our server's /painting with the beta key and nothing of the night;
+// kept beside the night only while Night images is Personal, the night is
+// read and has none yet; a failure counted silently, three at most; nothing
+// of a night logged (R3).
+import 'dart:async';
+import 'dart:io';
+import 'dart:math';
+import 'dart:typed_data';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/hosts.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/journal/journal.dart';
+import 'package:souldreams/journal/journal_store.dart';
+import 'package:souldreams/journal/night.dart';
+import 'package:souldreams/readings/painting.dart';
+import 'package:souldreams/settings/settings.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+import '../journal/zones.dart';
+
+/// A JPEG's start, a few bytes and its end.
+final jpeg = Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3, 0xff, 0xd9]);
+
+/// Our server's door, on this Mac: what each request held, and the answer.
+final class FakeServer {
+  FakeServer._(this._server);
+
+  final HttpServer _server;
+  final requests = <({String method, String path, Map<String, List<String>> headers, List<int> body})>[];
+  int status = 200;
+  List<int> reply = jpeg;
+
+  Uri get url => Uri.parse('http://127.0.0.1:${_server.port}/');
+
+  static Future<FakeServer> start() async {
+    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
+    final fake = FakeServer._(server);
+    server.listen(fake._handle);
+    return fake;
+  }
+
+  Future<void> _handle(HttpRequest request) async {
+    final headers = <String, List<String>>{};
+    request.headers.forEach((name, values) => headers[name] = values);
+    final body = [for (final chunk in await request.toList()) ...chunk];
+    requests.add((method: request.method, path: request.uri.path, headers: headers, body: body));
+    request.response.statusCode = status;
+    request.response.add(reply);
+    await request.response.close();
+  }
+
+  Future<void> stop() => _server.close(force: true);
+}
+
+void main() {
+  final beta = 'Ab0' * 16;
+
+  late List<String> lines;
+  setUp(() {
+    JournalStore.newQueueForTests();
+    lines = [];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+  });
+
+  Future<int> failure(Future<void> f) async {
+    try {
+      await f;
+    } on PaintingFailure catch (e) {
+      return e.status;
+    }
+    fail('no failure');
+  }
+
+  group('the request', () {
+    test('one POST to /painting: the beta key and nothing else', () async {
+      final server = await FakeServer.start();
+      addTearDown(server.stop);
+      expect(await postPainting(server.url, beta), jpeg);
+      final r = server.requests.single;
+      expect(r.method, 'POST');
+      expect(r.path, '/painting');
+      expect(String.fromCharCodes(r.body), '{}');
+      expect(r.headers['authorization'], ['Bearer $beta']);
+      expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'content-type', 'accept-encoding'});
+    });
+
+    test("not 200: the server's status; no answer: 0", () async {
+      final server = await FakeServer.start();
+      for (final status in [204, 400, 401, 413, 500, 502]) {
+        server.status = status;
+        expect(await failure(postPainting(server.url, beta)), status);
+      }
+      final gone = server.url;
+      await server.stop();
+      expect(await failure(postPainting(gone, beta)), 0);
+    });
+
+    test('an answer that is no whole JPEG, or too big: -1', () async {
+      final server = await FakeServer.start();
+      addTearDown(server.stop);
+      for (final reply in [
+        <int>[],
+        [0xff, 0xd8],
+        [0xff, 0xd8, 1, 2],
+        [0xff, 0xd8, 0xff, 0],
+        [1, 2, 0xff, 0xd9],
+        [0x89, 0x50, 0x4e, 0x47, 0xff, 0xd9],
+        [...jpeg.sublist(0, 4), ...List.filled(maxPaintingBytes, 0), 0xff, 0xd9],
+      ]) {
+        server.reply = reply;
+        expect(await failure(postPainting(server.url, beta)), -1, reason: '${reply.length}');
+      }
+    });
+
+    test("Dev's own: our server, with a well-shaped beta key", () async {
+      final server = await FakeServer.start();
+      addTearDown(server.stop);
+      expect(await livePainting(betaKey: beta, server: server.url.toString())(), jpeg);
+      for (final (key, url) in [('short', server.url.toString()), (beta, ''), ('${beta}x', server.url.toString())]) {
+        expect(await failure(livePainting(betaKey: key, server: url)()), -2);
+      }
+      expect(server.requests, hasLength(1));
+      expect(Hosts.server, isNotEmpty);
+    });
+  });
+
+  group('a night painted', () {
+    late Journal journal;
+    late Night read;
+    late Night unread;
+    setUp(() async {
+      final store = await JournalStore.open(MemoryJournalFiles());
+      journal = Journal(store, zone: const FixedZone(1), random: Random(4));
+      final [first, second, ...] = nightsFromFixtures();
+      read = first.withReadings([Reading(0, '[one]')]);
+      unread = second;
+      await store.save(read);
+      await store.save(unread);
+    });
+
+    // A send that answers [answers] in turn (a JPEG, or a failure to throw),
+    // counting its calls.
+    ({SendPainting send, List<int> calls}) sender(List<Object> answers) {
+      final calls = <int>[];
+      return (
+        calls: calls,
+        send: () async {
+          calls.add(calls.length);
+          final answer = answers[min(calls.length - 1, answers.length - 1)];
+          if (answer is Uint8List) return answer;
+          throw answer;
+        },
+      );
+    }
+
+    test('Personal, read, none yet: painted, kept, one code', () async {
+      final s = sender([jpeg]);
+      var told = 0;
+      expect(await paintNight(journal, s.send, read, NightImages.personal, sending: () => told++), Painted.made);
+      expect(await journal.painting(read.id), jpeg);
+      expect(told, 1);
+      expect(lines, ['paintingMade ${jpeg.length}']);
+    });
+
+    test('Random, Off, or an unread night: nothing asked', () async {
+      final s = sender([jpeg]);
+      for (final images in [NightImages.random, NightImages.off]) {
+        expect(await paintNight(journal, s.send, read, images), Painted.nothing);
+      }
+      expect(await paintNight(journal, s.send, unread, NightImages.personal), Painted.nothing);
+      expect(s.calls, isEmpty);
+      expect(await journal.paintings(), isEmpty);
+    });
+
+    test('a night with its painting is not painted again', () async {
+      final s = sender([jpeg]);
+      await paintNight(journal, s.send, read, NightImages.personal);
+      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.nothing);
+      expect(s.calls, hasLength(1));
+    });
+
+    test('a failure keeps nothing, counts a try, logs its status', () async {
+      final s = sender([const PaintingFailure(502)]);
+      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
+      expect(await journal.painting(read.id), isNull);
+      expect(await journal.paintTries(read.id), 1);
+      expect(lines, ['paintingFailed 502']);
+    });
+
+    test('anything else failing logs -3, never its words', () async {
+      final s = sender([StateError('invented failure text')]);
+      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
+      expect(lines, ['paintingFailed -3']);
+    });
+
+    test('three tries at most; then nothing is asked again', () async {
+      final s = sender([const PaintingFailure(0)]);
+      for (var i = 0; i < maxPaintTries; i++) {
+        expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
+      }
+      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.nothing);
+      expect(s.calls, hasLength(3));
+      expect(maxPaintTries, 3);
+    });
+
+    test('a failure, then a painting on the next try', () async {
+      final s = sender([const PaintingFailure(0), jpeg]);
+      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
+      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.made);
+      expect(await journal.painting(read.id), jpeg);
+      expect(await journal.paintTries(read.id), 0);
+    });
+
+    test('a night deleted while painted keeps nothing', () async {
+      final gate = Completer<Uint8List>();
+      final painting = paintNight(journal, () => gate.future, read, NightImages.personal);
+      await pumpEventQueue();
+      await journal.delete(read.id);
+      gate.complete(jpeg);
+      expect(await painting, Painted.gone);
+      expect(await journal.paintings(), isEmpty);
+    });
+
+    test('the Painter asks once for a night being painted', () async {
+      final gate = Completer<Uint8List>();
+      var asked = 0;
+      final painter = Painter(() {
+        asked++;
+        return gate.future;
+      });
+      var told = 0;
+      final one = painter.paint(journal, read, NightImages.personal, sending: () => told++);
+      await pumpEventQueue();
+      expect(painter.busy(read.id), isTrue);
+      final two = painter.paint(journal, read, NightImages.personal, sending: () => told++);
+      gate.complete(jpeg);
+      expect(await one, Painted.made);
+      expect(await two, Painted.made);
+      expect(asked, 1);
+      expect(told, 2);
+      expect(painter.busy(read.id), isFalse);
+    });
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3794,6 +3794,75 @@ ROWS = [
      'test/journal/journal_store_test.dart', 'failed tries counted one by one; a damaged count is none'),
     ('A936', 'lib/journal/journal_store.dart', '_triesText.hasMatch(text) ? int.parse(text) : 0', 'int.tryParse(text) ?? 0',
      'test/journal/journal_store_test.dart', 'failed tries counted one by one; a damaged count is none'),
+    # A read night's personal painting, asked of our server (D162 items 1 and 2).
+    ('A937', 'lib/readings/painting.dart',
+     'bytes[bytes.length - 1] == 0xd9;',
+     'true;',
+     'test/readings/painting_test.dart', 'an answer that is no whole JPEG, or too big: -1'),
+    ('A938', 'lib/readings/painting.dart',
+     '    bytes[0] == 0xff &&\n    bytes[1] == 0xd8 &&\n',
+     '',
+     'test/readings/painting_test.dart', 'an answer that is no whole JPEG, or too big: -1'),
+    ('A939', 'lib/readings/painting.dart',
+     '      if (bytes.length > maxPaintingBytes) throw const PaintingFailure(-1);\n',
+     '',
+     'test/readings/painting_test.dart', 'an answer that is no whole JPEG, or too big: -1'),
+    ('A940', 'lib/readings/painting.dart',
+     "request.write('{}');",
+     "request.write('[]');",
+     'test/readings/painting_test.dart', 'one POST to /painting: the beta key and nothing else'),
+    ('A941', 'lib/readings/painting.dart',
+     'if (reply.statusCode != 200) throw',
+     'if (reply.statusCode >= 500) throw',
+     'test/readings/painting_test.dart', "not 200: the server's status; no answer: 0"),
+    ('A942', 'lib/readings/painting.dart',
+     'server.isNotEmpty && _betaShape.hasMatch(betaKey)',
+     'server.isNotEmpty',
+     'test/readings/painting_test.dart', "Dev's own: our server, with a well-shaped beta key"),
+    ('A943', 'lib/readings/painting.dart',
+     'if (images != NightImages.personal || night.readings == null)',
+     'if (night.readings == null)',
+     'test/readings/painting_test.dart', 'Random, Off, or an unread night: nothing asked'),
+    ('A944', 'lib/readings/painting.dart',
+     'images != NightImages.personal || night.readings == null)',
+     'images != NightImages.personal)',
+     'test/readings/painting_test.dart', 'Random, Off, or an unread night: nothing asked'),
+    ('A945', 'lib/readings/painting.dart',
+     '    if (await journal.painting(night.id) != null) return Painted.nothing;\n',
+     '',
+     'test/readings/painting_test.dart', 'a night with its painting is not painted again'),
+    ('A946', 'lib/readings/painting.dart',
+     '>= maxPaintTries)',
+     '>= maxPaintTries + 1)',
+     'test/readings/painting_test.dart', 'three tries at most; then nothing is asked again'),
+    ('A947', 'lib/readings/painting.dart',
+     'await journal.countPaintTry(night.id);',
+     'await journal.paintTries(night.id);',
+     'test/readings/painting_test.dart', 'a failure keeps nothing, counts a try, logs its status'),
+    ('A948', 'lib/readings/painting.dart',
+     'e is PaintingFailure ? e.status : -3',
+     '-3',
+     'test/readings/painting_test.dart', 'a failure keeps nothing, counts a try, logs its status'),
+    ('A949', 'lib/readings/painting.dart',
+     '  if (!kept) return Painted.gone;\n',
+     '',
+     'test/readings/painting_test.dart', 'a night deleted while painted keeps nothing'),
+    ('A950', 'lib/readings/painting.dart',
+     '  sending?.call();\n  final Uint8List jpeg;',
+     '  final Uint8List jpeg;',
+     'test/readings/painting_test.dart', 'Personal, read, none yet: painted, kept, one code'),
+    ('A951', 'lib/readings/painting.dart',
+     '    if (under != null) {\n      sending?.call();\n      return under;\n    }\n',
+     '',
+     'test/readings/painting_test.dart', 'the Painter asks once for a night being painted'),
+    ('A952', 'lib/readings/painting.dart',
+     'return run.whenComplete(() => _under.remove(night.id));',
+     'return run;',
+     'test/readings/painting_test.dart', 'the Painter asks once for a night being painted'),
+    ('A953', 'lib/readings/painting.dart',
+     'const maxPaintTries = 3;',
+     'const maxPaintTries = 4;',
+     'test/readings/painting_test.dart', 'three tries at most; then nothing is asked again'),
 ]
 
 
~~~~

### Task 5 · App: the painting on the night's page and its row; MP·81 while it is made; SoulDreams Dev's painter

Changed: `app/lib/journal/night_look.dart`, `pages/night_art.dart`, `pages/night_page.dart`, `pages/journal_page.dart`,
`pages/journal_home.dart`, `app/lib/main_dev.dart`; tests `night_look_test.dart`, `pages/night_art_test.dart`,
`pages/night_page_test.dart` (the group "a read night's own painting", nine tests), `pages/journal_page_test.dart`,
`pages/journal_home_test.dart`, `dev_only_test.dart`; `tool/app_mutations.py` (A954 to A975 new; A40, A364, A365,
A376, A382, A394, A509, A510, A512, A752, A777, A780, A790, A801, A835 follow).

Checks: `No issues found!`; `+873: All tests passed!`. Rows: A954 to A975 and the fifteen that follow, every one
caught.

Commit:

> App: a read night shows its own painting while Personal, MP·81 while it is made, the curated one on failure (D162)

**The block:**

~~~~diff
diff --git a/app/lib/journal/night_look.dart b/app/lib/journal/night_look.dart
--- a/app/lib/journal/night_look.dart
+++ b/app/lib/journal/night_look.dart
@@ -3,9 +3,13 @@
 // night's id alone, so from none of its words, and the same every time; an
 // unread night shows the painted gradient, and so does any night while the
 // app holds no painting, and every night while Night images is Off (D121
-// item 3). Personal and Random both show the set until the personal
-// painting exists (D121 item 3; D122, the stop's question 9). Nothing is stored: the id is already random (128
-// bits from the phone's secure source, newNightId).
+// item 3). While Night images is Personal, a read night whose own painting
+// has come shows it (D162); until then, and always while Random, it shows
+// the set's (D121 item 3; D122, the stop's question 9). The choice from the
+// set stores nothing: the id is already random (128 bits from the phone's
+// secure source, newNightId).
+import 'dart:typed_data';
+
 import 'night.dart';
 
 sealed class NightLook {
@@ -36,14 +40,31 @@ final class Painting extends NightLook {
   int get hashCode => index;
 }
 
+/// The night's own painting, from our server (D162): its JPEG.
+final class PersonalPainting extends NightLook {
+  const PersonalPainting(this.jpeg);
+
+  final Uint8List jpeg;
+
+  @override
+  bool operator ==(Object other) => other is PersonalPainting && identical(other.jpeg, jpeg);
+
+  @override
+  int get hashCode => identityHashCode(jpeg);
+}
+
 /// Which of [count] paintings the night with [id] shows: its id's first 32
 /// bits, modulo the count.
 int paintingFor(String id, int count) => int.parse(id.substring(0, 8), radix: 16) % count;
 
-/// The look of [night], [read] or not, with [paintings] in the set, and
-/// [images] false while Night images is Off.
-NightLook lookOf(Night night, {required bool read, required int paintings, bool images = true}) =>
-    images && read && paintings > 0 ? Painting(paintingFor(night.id, paintings)) : const PaintedGradient();
+/// The look of [night], [read] or not, with [paintings] in the set,
+/// [images] false while Night images is Off, and [personal] its own
+/// painting, given only while Night images is Personal.
+NightLook lookOf(Night night, {required bool read, required int paintings, bool images = true, Uint8List? personal}) {
+  if (!images || !read) return const PaintedGradient();
+  if (personal != null) return PersonalPainting(personal);
+  return paintings > 0 ? Painting(paintingFor(night.id, paintings)) : const PaintedGradient();
+}
 
 /// Whether a night has been read.
 typedef ReadCheck = bool Function(Night night);
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -32,6 +32,7 @@ import '../../core/app_line.dart' show wordAnimation;
 import '../../core/night_day.dart';
 import '../../core/safe_log.dart';
 import '../../feedback/feedback.dart';
+import '../../readings/painting.dart';
 import '../../readings/readings.dart';
 import '../../life_context/life_context.dart';
 import '../../life_context/preview.dart';
@@ -59,6 +60,7 @@ class JournalHome extends StatefulWidget {
     this.preview = '',
     this.feedback,
     this.readNight,
+    this.painter,
   });
 
   final JournalFiles files;
@@ -86,6 +88,9 @@ class JournalHome extends StatefulWidget {
   /// Reads a night through our server (head's message 33), or null.
   final SendNight? readNight;
 
+  /// Asks for a read night's own painting (D162), or null.
+  final Painter? painter;
+
   @override
   State<JournalHome> createState() => _JournalHomeState();
 }
@@ -275,6 +280,8 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
         agreed: _settings?.agreed ?? true,
         feedback: widget.feedback,
         readNight: widget.readNight,
+        personal: _settings?.settings.images == NightImages.personal,
+        painter: widget.painter,
       ),
     };
   }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -22,6 +22,7 @@
 // sky mark stays 140 down. Settings is handed Life Context, whose page opens
 // a night here as a row does (D131).
 import 'dart:async';
+import 'dart:typed_data';
 
 import 'package:flutter/material.dart';
 
@@ -32,6 +33,7 @@ import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../feedback/feedback.dart';
+import '../../readings/painting.dart';
 import '../../readings/readings.dart';
 import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
@@ -65,6 +67,8 @@ class JournalPage extends StatefulWidget {
     this.agreed = true,
     this.feedback,
     this.readNight,
+    this.personal = false,
+    this.painter,
   });
 
   final Journal journal;
@@ -112,12 +116,21 @@ class JournalPage extends StatefulWidget {
   /// Interpretation does nothing. SoulDreams Dev's only.
   final SendNight? readNight;
 
+  /// Whether Night images is Personal (D162): a read night's row shows its
+  /// own painting once it has come.
+  final bool personal;
+
+  /// Asks for a read night's own painting, or null. SoulDreams Dev's only.
+  final Painter? painter;
+
   @override
   State<JournalPage> createState() => _JournalPageState();
 }
 
 class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   List<Night>? _nights;
+  // Each night's own painting, by its id, while Personal (D162).
+  Map<String, Uint8List> _paintings = const {};
   late Greeting _greeting = _greetingNow();
   late Sky _sky = _skyNow();
   late final Timer _clock;
@@ -183,8 +196,10 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
   // A failed read keeps what is shown and logs a code (D71 Q18, as D64).
   Future<void> _load() async {
     final List<Night> nights;
+    final Map<String, Uint8List> paintings;
     try {
       nights = await widget.journal.newestFirst();
+      paintings = widget.personal ? await widget.journal.paintings() : const {};
     } on Object {
       SafeLog.event(LogEvent.journalListFailed);
       return;
@@ -192,6 +207,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     if (!mounted) return;
     setState(() {
       _nights = nights;
+      _paintings = paintings;
       _greeting = _greetingNow();
       _sky = _skyNow();
       // Shown once: a night there ends it, even one deleted later.
@@ -221,6 +237,8 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
       images: widget.images,
       agreed: widget.agreed,
       reader: _reader,
+      personal: widget.personal,
+      painter: widget.painter,
     ),
   );
 
@@ -264,7 +282,13 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     };
     Widget row(Night night) => _Row(
       night,
-      look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings, images: widget.images),
+      look: lookOf(
+        night,
+        read: widget.read(night),
+        paintings: NightArt.paintings,
+        images: widget.images,
+        personal: _paintings[night.id],
+      ),
       line: contexts[night.id],
       onTap: () => _push(
         NightPage(
@@ -277,6 +301,8 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
           agreed: widget.agreed,
           query: query,
           reader: _reader,
+          personal: widget.personal,
+          painter: widget.painter,
         ),
       ),
     );
diff --git a/app/lib/journal/pages/night_art.dart b/app/lib/journal/pages/night_art.dart
--- a/app/lib/journal/pages/night_art.dart
+++ b/app/lib/journal/pages/night_art.dart
@@ -1,6 +1,7 @@
 // A night's picture (D110; head's messages 24 and 25): the painted gradient
-// for an unread night, or one painting of the curated set shipped in the
-// app for a read one (D147): sixty paintings in `assets/paintings/`, each
+// for an unread night, or for a read one its own painting from our server
+// (D162), kept on the phone, or one painting of the curated set shipped in
+// the app (D147): sixty paintings in `assets/paintings/`, each
 // fingerprinted (G2) and carrying the invisible AI tag (D123), shown to
 // cover its box from the middle, so a row shows a thin band and the header a
 // wide crop. The gradient lies beneath, so nothing flashes while a painting
@@ -72,8 +73,9 @@ class NightArt extends StatelessWidget {
         fit: StackFit.passthrough,
         children: [
           Positioned.fill(child: CustomPaint(painter: _GradientPainter())),
-          if (look is Painting) Positioned.fill(child: _Cover(asset(look.index))),
-          if (look is Painting && overlay != null)
+          if (look is Painting) Positioned.fill(child: _Cover(AssetImage(asset(look.index)))),
+          if (look is PersonalPainting) Positioned.fill(child: _Cover(MemoryImage(look.jpeg))),
+          if (look is! PaintedGradient && overlay != null)
             Positioned.fill(
               child: switch (overlay!) {
                 ArtOverlay.row => const _Dim(),
@@ -87,19 +89,19 @@ class NightArt extends StatelessWidget {
   }
 }
 
-/// An image of the set covering its box from the middle, decoded no larger
-/// than the box needs on this screen, and silent.
+/// A painting covering its box from the middle, decoded no larger than the
+/// box needs on this screen, and silent.
 class _Cover extends StatelessWidget {
-  const _Cover(this.asset);
+  const _Cover(this.image);
 
-  final String asset;
+  final ImageProvider image;
 
   @override
   Widget build(BuildContext context) => LayoutBuilder(
     builder: (context, box) {
       final width = (box.maxWidth * MediaQuery.devicePixelRatioOf(context)).ceil();
       return Image(
-        image: ResizeImage.resizeIfNeeded(width > 0 ? width : null, null, AssetImage(asset)),
+        image: ResizeImage.resizeIfNeeded(width > 0 ? width : null, null, image),
         fit: BoxFit.cover,
         alignment: Alignment.center,
         excludeFromSemantics: true,
@@ -163,7 +165,7 @@ class NightSky extends StatelessWidget {
     fit: StackFit.passthrough,
     children: [
       Positioned.fill(child: CustomPaint(painter: _GradientPainter())),
-      const Positioned.fill(child: _Cover(asset)),
+      const Positioned.fill(child: _Cover(AssetImage(asset))),
       const Positioned.fill(child: _Dim()),
       child ?? const SizedBox.expand(),
     ],
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -35,7 +35,15 @@
 // built: the mirror, the opening, the close, and the space below the dreams
 // with its field. Opened from a search, the night's first match shows in
 // Bold in its dream, found again on each read; gone when the page goes
-// (main-path.md, Search; D117 Q6).
+// (main-path.md, Search; D117 Q6). While Night images is Personal, a read
+// night with no painting of its own yet asks our server for one, once each
+// time its page opens and only with the page's painter (SoulDreams Dev's);
+// while it is made, the header shows the set's painting with "New painting
+// on the way" (MP·81) over it, heard as it comes; the night's own painting
+// replaces it when it arrives; a failure leaves the set's, silently (D162
+// items 1 and 2).
+import 'dart:async';
+
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter/rendering.dart' show ScrollCacheExtent;
@@ -49,6 +57,7 @@ import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
+import '../../readings/painting.dart';
 import '../../readings/readings.dart';
 import '../../recording/recording.dart';
 import '../journal.dart';
@@ -58,6 +67,7 @@ import '../night_look.dart';
 import '../night_rules.dart';
 import '../row_text.dart';
 import '../../settings/agreement_popup.dart';
+import '../../settings/settings.dart';
 import '../search.dart';
 import 'night_art.dart';
 import 'parts.dart';
@@ -93,6 +103,8 @@ class NightPage extends StatefulWidget {
     this.agreed = true,
     this.query,
     this.reader,
+    this.personal = false,
+    this.painter,
   });
 
   static const menuKey = Key('night-menu');
@@ -105,6 +117,7 @@ class NightPage extends StatefulWidget {
   static const readingsKey = Key('night-readings');
   static const waitingKey = Key('night-reading-waits');
   static const failedKey = Key('night-reading-failed');
+  static const paintingKey = Key('night-painting-made');
 
   /// The night's reading at [index].
   static Key readingKey(int index) => ValueKey('reading-$index');
@@ -138,6 +151,14 @@ class NightPage extends StatefulWidget {
   /// message 33); null, and it does nothing.
   final Reader? reader;
 
+  /// Whether Night images is Personal (D162): the night's own painting is
+  /// shown, and asked for while it has none.
+  final bool personal;
+
+  /// How a read night's own painting is asked for: SoulDreams Dev's only;
+  /// null, and none is.
+  final Painter? painter;
+
   @override
   State<NightPage> createState() => _NightPageState();
 }
@@ -158,6 +179,12 @@ class _NightPageState extends State<NightPage> {
   bool _reading = false;
   bool _failed = false;
 
+  // The night's own painting, while Personal (D162); whether it is being
+  // made; whether it was asked for since the page opened.
+  Uint8List? _own;
+  bool _making = false;
+  bool _asked = false;
+
   // The part that scrolls: brought to its end, at once, when AI·3 comes, so
   // it shows where the readings, or the failure sentence, will.
   final _scroll = ScrollController();
@@ -203,7 +230,37 @@ class _NightPageState extends State<NightPage> {
       _leave();
       return;
     }
-    setState(() => _night = n);
+    Uint8List? own;
+    if (widget.personal) {
+      try {
+        own = await widget.journal.painting(widget.id);
+      } on Object {
+        SafeLog.event(LogEvent.paintingKeepFailed);
+      }
+      if (!mounted) return;
+    }
+    setState(() {
+      _night = n;
+      _own = own;
+    });
+    _paint(n);
+  }
+
+  // A read night's own painting, asked for once each time the page opens,
+  // while Personal and while it has none (D162 items 1 and 2): MP·81 shows
+  // while it is made; when it comes, the page shows it.
+  void _paint(Night n) {
+    final painter = widget.painter;
+    if (painter == null || !widget.images || !widget.personal || _asked || !widget.read(n)) return;
+    _asked = true;
+    final made = painter.paint(widget.journal, n, NightImages.personal, sending: () {
+      if (mounted) setState(() => _making = true);
+    });
+    unawaited(made.then((done) async {
+      if (!mounted) return;
+      setState(() => _making = false);
+      if (done == Painted.made) await _load();
+    }));
   }
 
   // The page leaves by its own route: with a question or a typing screen
@@ -406,7 +463,9 @@ class _NightPageState extends State<NightPage> {
     const side = EdgeInsets.symmetric(horizontal: Spacing.pageSide);
     final top = MediaQuery.paddingOf(context).top;
     final read = n != null && widget.read(n);
-    final look = n == null ? null : lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images);
+    final look = n == null
+        ? null
+        : lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images, personal: _own);
     final query = widget.query;
     final found = n == null || query == null ? null : findIn(n, query);
     // Light time and battery over the header's picture, in both themes (D113);
@@ -446,6 +505,26 @@ class _NightPageState extends State<NightPage> {
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                           children: [
                             controls,
+                            // MP·81 while the night's own painting is made
+                            // (D162 item 1), scaled down to its room.
+                            if (_making)
+                              Flexible(
+                                child: Padding(
+                                  padding: side,
+                                  child: Semantics(
+                                    key: NightPage.paintingKey,
+                                    liveRegion: true,
+                                    child: FittedBox(
+                                      fit: BoxFit.scaleDown,
+                                      child: Text(
+                                        Lines.MP_81.text(appLanguage),
+                                        textAlign: TextAlign.center,
+                                        style: TypeRoles.button.style(NightArt.over),
+                                      ),
+                                    ),
+                                  ),
+                                ),
+                              ),
                             // The date takes the room under the controls and
                             // scales down to it, so a very large text size
                             // never overflows the header (D150: it is 55 pt).
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -10,6 +10,8 @@
 // (D152 item 5: SoulDreams Dev only for now). Start Interpretation reads a
 // night through our server with it too (head's message 33: SoulDreams Dev
 // only, invented nights only); a night is read when it holds its readings.
+// A read night's own painting comes from our server too, while Night images
+// is Personal (D162).
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -24,6 +26,7 @@ import 'journal/channel_journal_files.dart';
 import 'journal/night_look.dart';
 import 'journal/pages/journal_home.dart';
 import 'journal/self_check.dart';
+import 'readings/painting.dart';
 import 'readings/readings.dart';
 import 'recording/connection.dart';
 import 'recording/record_microphone.dart';
@@ -49,13 +52,14 @@ void main() {
   // Each night's calls' counts and cost kept beside it (head's message 34).
   final readNight = liveReading(betaKey: const String.fromEnvironment('BETA_KEY'), keepUsage: true);
   const read = bool.fromEnvironment('PREVIEW_READ') ? allRead : isRead;
+  final painter = Painter(livePainting(betaKey: const String.fromEnvironment('BETA_KEY')));
   // The keyboard check (D50 1): only in a build made with
   // --dart-define=KEYBOARD_CHECK=true.
   runApp(
     SoulDreamsApp(
       home: const bool.fromEnvironment('KEYBOARD_CHECK')
           ? const KeyboardCheck()
-          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight),
+          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight, painter: painter),
     ),
   );
   if (check != null) unawaited(check);
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -104,7 +104,7 @@ void main() {
       ]),
     );
     expect(files, containsAll(['lib/feedback/feedback.dart', 'lib/feedback/feedback_section.dart']));
-    expect(files, contains('lib/readings/readings.dart'));
+    expect(files, containsAll(['lib/readings/readings.dart', 'lib/readings/painting.dart']));
   });
 
   // R8, D108: the journal's pages, which testers will get, carry only the
diff --git a/app/test/journal/night_look_test.dart b/app/test/journal/night_look_test.dart
--- a/app/test/journal/night_look_test.dart
+++ b/app/test/journal/night_look_test.dart
@@ -1,6 +1,8 @@
 // A night's look (D110; head's message 25): a read night shows one painting
 // of the set, chosen from its id alone; an unread night, or no set, the
 // painted gradient.
+import 'dart:typed_data';
+
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/journal/night.dart';
 import 'package:souldreams/journal/night_look.dart';
@@ -63,4 +65,18 @@ void main() {
   test("the preview's check calls every night read", () {
     expect(allRead(nightWith(a)), isTrue);
   });
+
+  // D162: while Personal, a read night's own painting, once it has come.
+  test("a read night's own painting, given: shown instead of the set's", () {
+    final own = Uint8List.fromList([1, 2, 3]);
+    expect(lookOf(nightWith(a), read: true, paintings: 4, personal: own), PersonalPainting(own));
+    expect(lookOf(nightWith(a), read: true, paintings: 0, personal: own), PersonalPainting(own));
+    expect(PersonalPainting(own) == PersonalPainting(Uint8List.fromList([1, 2, 3])), isFalse);
+  });
+
+  test('its own painting: never on an unread night, nor while Off', () {
+    final own = Uint8List.fromList([1, 2, 3]);
+    expect(lookOf(nightWith(a), read: false, paintings: 4, personal: own), const PaintedGradient());
+    expect(lookOf(nightWith(a), read: true, paintings: 4, images: false, personal: own), const PaintedGradient());
+  });
 }
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -20,6 +20,7 @@ import 'package:souldreams/journal/pages/journal_home.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/onboarding/onboarding.dart';
+import 'package:souldreams/readings/painting.dart';
 import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/settings/consents.dart';
 import 'package:souldreams/settings/settings.dart';
@@ -173,6 +174,18 @@ void main() {
     expect(tester.widget<JournalPage>(find.byType(JournalPage)).readNight, isNull);
   });
 
+  // D162; D160: Night images starts as Personal; the page is told so, and
+  // is handed SoulDreams Dev's painter.
+  testWidgets("Personal is handed to the journal, with Dev's painter", (tester) async {
+    JournalStore.newQueueForTests();
+    final painter = Painter(() async => throw const PaintingFailure(0));
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), painter: painter)));
+    await tester.pumpAndSettle();
+    final page = tester.widget<JournalPage>(find.byType(JournalPage));
+    expect(page.personal, isTrue);
+    expect(page.painter, same(painter));
+  });
+
   testWidgets('by default no night is read', (tester) async {
     JournalStore.newQueueForTests();
     await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
@@ -267,7 +280,8 @@ void main() {
       text,
       contains(
         'JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, '
-        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight)",
+        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight, "
+        'painter: painter)',
       ),
     );
     // Every night read only in a build made for the by-eye preview (D110).
@@ -280,6 +294,8 @@ void main() {
     // message 33: SoulDreams Dev only).
     // Each night's calls' counts kept beside it (head's message 34).
     expect(text, contains("liveReading(betaKey: const String.fromEnvironment('BETA_KEY'), keepUsage: true);"));
+    // A read night's own painting, through our server with the same key (D162).
+    expect(text, contains("final painter = Painter(livePainting(betaKey: const String.fromEnvironment('BETA_KEY')));"));
   });
 
   testWidgets('a folder that cannot open: a blank page, a code', (tester) async {
@@ -569,6 +585,7 @@ void main() {
     await tester.pumpAndSettle();
     final page = tester.widget<JournalPage>(find.byType(JournalPage));
     expect(page.images, isTrue);
+    expect(page.personal, isFalse);
     expect(page.settings!.settings.images, NightImages.random);
     expect(wordAnimation, isFalse);
     expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -25,6 +25,7 @@ import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/sky_mark.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/readings/painting.dart';
 import 'package:souldreams/readings/readings.dart';
 import 'package:souldreams/journal/sky.dart';
 import 'package:souldreams/words/lines.g.dart';
@@ -499,6 +500,36 @@ void main() {
     expect(tester.widget<NightPage>(find.byType(NightPage)).images, isFalse);
   });
 
+  // D162: while Personal, a read night's row shows its own painting once
+  // it has come, and its page is handed Personal and the painter; while
+  // Random, the set's.
+  testWidgets("Personal: a read row shows the night's own painting", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    final own = File('assets/paintings/02.jpg').readAsBytesSync();
+    await h.journal.keepPainting(n.id, own);
+    final painter = Painter(() async => throw const PaintingFailure(0));
+    await h.pump(tester, JournalPage(journal: h.journal, read: (_) => true, personal: true, painter: painter));
+    final row = find.byKey(JournalPage.rowKey(n.id));
+    final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
+    expect((art.look as PersonalPainting).jpeg, own);
+    await tester.tap(row);
+    await tester.pumpAndSettle();
+    final page = tester.widget<NightPage>(find.byType(NightPage));
+    expect(page.personal, isTrue);
+    expect(page.painter, same(painter));
+  });
+
+  testWidgets("Random: a read row shows the set's painting, not its own", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    await h.journal.keepPainting(n.id, File('assets/paintings/02.jpg').readAsBytesSync());
+    await h.pump(tester, JournalPage(journal: h.journal, read: (_) => true));
+    final row = find.byKey(JournalPage.rowKey(n.id));
+    final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
+    expect(art.look, Painting(paintingFor(n.id, NightArt.paintings)));
+  });
+
   // D110: naming a night is removed; a name kept from before is not shown.
   testWidgets('a named night shows only its date', (tester) async {
     final h = await Harness.make();
diff --git a/app/test/journal/pages/night_art_test.dart b/app/test/journal/pages/night_art_test.dart
--- a/app/test/journal/pages/night_art_test.dart
+++ b/app/test/journal/pages/night_art_test.dart
@@ -2,6 +2,8 @@
 // or one painting of the curated set (D147) covering its box from the
 // middle over the gradient; heard as nothing; the same in both themes. And
 // New Dream's sky, the set's strip (D112; D147 item 3).
+import 'dart:io';
+
 import 'package:flutter/material.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/design/tokens.g.dart';
@@ -69,6 +71,27 @@ void main() {
     handle.dispose();
   });
 
+  // D162: a night's own painting, from its bytes, as the set's are drawn.
+  testWidgets("a night's own painting covers its box, silent, from its bytes", (tester) async {
+    final handle = tester.ensureSemantics();
+    final own = File('assets/paintings/01.jpg').readAsBytesSync();
+    final art = await pump(tester, PersonalPainting(own));
+    expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
+    final image = tester.widget<Image>(find.byType(Image));
+    final resized = image.image as ResizeImage;
+    expect(identical((resized.imageProvider as MemoryImage).bytes, own), isTrue);
+    expect(image.fit, BoxFit.cover);
+    expect(image.excludeFromSemantics, isTrue);
+    expect(resized.width, (300 * tester.view.devicePixelRatio).ceil());
+    expect(tester.getRect(find.byType(Image)), tester.getRect(find.byType(NightArt)));
+    expect(tester.getSemantics(find.byType(NightArt)).label, isEmpty);
+    // Darkened under a row's date as the set's paintings are (D149, D150).
+    await tester.pumpWidget(Center(child: SizedBox(width: 300, height: 64, child: NightArt(PersonalPainting(own), overlay: ArtOverlay.row))));
+    final dim = NightArt.overlayColour.withValues(alpha: NightArt.rowOverlayAlpha);
+    expect(find.byWidgetPredicate((w) => w is ColoredBox && w.color == dim), findsOneWidget);
+    handle.dispose();
+  });
+
   // D112; D147 item 3: New Dream's night sky, the set's strip.
   group('the night sky inside New Dream', () {
     testWidgets("the sky: the set's strip, covering the pill", (tester) async {
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -10,6 +10,7 @@
 // waits, C4-P·6 alone when it fails; a read night shows MP·20, "The
 // Readings" (MP·36) and its readings, each under its tradition's label.
 import 'dart:async';
+import 'dart:io';
 
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart' show Theme;
@@ -29,6 +30,7 @@ import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
 import 'package:souldreams/journal/search.dart';
+import 'package:souldreams/readings/painting.dart';
 import 'package:souldreams/readings/readings.dart';
 import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/words/lines.g.dart';
@@ -94,6 +96,8 @@ void main() {
     bool agreed = true,
     Reader? reader,
     List<Reading>? readings,
+    bool personal = false,
+    Painter? painter,
   }) async {
     // The test's own 800 by 600, where the foot's two buttons do not fill
     // the row, or a phone.
@@ -131,6 +135,8 @@ void main() {
           query: query,
           agreed: agreed,
           reader: reader,
+          personal: personal,
+          painter: painter,
         ),
       ),
       hour: hour,
@@ -1152,4 +1158,153 @@ void main() {
     expect(find.byKey(NightPage.readingKey(2), skipOffstage: false), findsOneWidget);
     expect(tester.takeException(), isNull);
   });
+
+  // D162: a read night's own painting, while Personal. Its JPEG is one of
+  // the set's files, as bytes, standing in for the server's.
+  group("a read night's own painting", () {
+    final own = File('assets/paintings/03.jpg').readAsBytesSync();
+    final one = [Reading(0, '[STAND-IN · 1]')];
+
+    // A painter whose answers wait for the test; each request counted.
+    ({Painter painter, List<Completer<Uint8List>> asked}) painting() {
+      final asked = <Completer<Uint8List>>[];
+      return (
+        asked: asked,
+        painter: Painter(() {
+          final c = Completer<Uint8List>();
+          asked.add(c);
+          return c.future;
+        }),
+      );
+    }
+
+    NightLook look(WidgetTester tester) => tester.widget<NightArt>(find.byType(NightArt)).look;
+
+    testWidgets("MP·81 over the set's painting, then its own painting", (tester) async {
+      final p = painting();
+      await open(tester, readings: one, read: isRead, personal: true, painter: p.painter);
+      expect(p.asked, hasLength(1));
+      expect(look(tester), Painting(paintingFor(n.id, NightArt.paintings)));
+      expect(find.text(Lines.MP_81.text(Lang.en)), findsOneWidget);
+      final line = tester.getRect(find.text(Lines.MP_81.text(Lang.en)));
+      expect(tester.getRect(find.byType(NightArt)).contains(line.center), isTrue);
+      p.asked.single.complete(own);
+      await tester.pumpAndSettle();
+      expect(find.text(Lines.MP_81.text(Lang.en)), findsNothing);
+      expect((look(tester) as PersonalPainting).jpeg, own);
+      expect(await h.journal.painting(n.id), own);
+    });
+
+    testWidgets('MP·81 is heard as it comes', (tester) async {
+      final handle = tester.ensureSemantics();
+      final p = painting();
+      await open(tester, readings: one, read: isRead, personal: true, painter: p.painter);
+      expect(tester.getSemantics(find.byKey(NightPage.paintingKey)), matchesSemantics(isLiveRegion: true, label: Lines.MP_81.text(Lang.en)));
+      p.asked.single.complete(own);
+      await tester.pumpAndSettle();
+      handle.dispose();
+    });
+
+    testWidgets("a failure: the set's painting stays, silently; one try", (tester) async {
+      final p = painting();
+      await open(tester, readings: one, read: isRead, personal: true, painter: p.painter);
+      p.asked.single.completeError(const PaintingFailure(502));
+      await tester.pumpAndSettle();
+      expect(find.text(Lines.MP_81.text(Lang.en)), findsNothing);
+      expect(look(tester), Painting(paintingFor(n.id, NightArt.paintings)));
+      expect(await h.journal.paintTries(n.id), 1);
+      // Asked once while the page is open, though it loads again.
+      await tester.tap(find.text(n.dreams.first));
+      await tester.pumpAndSettle();
+      await tester.pageBack();
+      await tester.pumpAndSettle();
+      expect(p.asked, hasLength(1));
+    });
+
+    testWidgets('the next opening of the night tries again', (tester) async {
+      final p = painting();
+      await open(tester, readings: one, read: isRead, personal: true, painter: p.painter);
+      p.asked.single.completeError(const PaintingFailure(0));
+      await tester.pumpAndSettle();
+      await tester.pageBack();
+      await tester.pumpAndSettle();
+      await tester.tap(find.byKey(Opener.openKey));
+      await tester.pumpAndSettle();
+      expect(p.asked, hasLength(2));
+      p.asked.last.complete(own);
+      await tester.pumpAndSettle();
+      expect((look(tester) as PersonalPainting).jpeg, own);
+    });
+
+    testWidgets('a night with its own painting: shown, nothing asked', (tester) async {
+      final p = painting();
+      await open(tester, readings: one, read: isRead, personal: true, painter: p.painter);
+      p.asked.single.complete(own);
+      await tester.pumpAndSettle();
+      await tester.pageBack();
+      await tester.pumpAndSettle();
+      await tester.tap(find.byKey(Opener.openKey));
+      await tester.pumpAndSettle();
+      expect(p.asked, hasLength(1));
+      expect((look(tester) as PersonalPainting).jpeg, own);
+      expect(find.text(Lines.MP_81.text(Lang.en)), findsNothing);
+    });
+
+    testWidgets("Random, Off, unread or no painter: nothing asked", (tester) async {
+      final p = painting();
+      for (final (readings, images, personal, painter) in [
+        (one, true, false, p.painter),
+        (one, false, true, p.painter),
+        (null, true, true, p.painter),
+        (one, true, true, null),
+      ]) {
+        await open(tester, readings: readings, read: isRead, images: images, personal: personal, painter: painter);
+        expect(find.text(Lines.MP_81.text(Lang.en)), findsNothing);
+        await tester.pumpWidget(const SizedBox());
+      }
+      expect(p.asked, isEmpty);
+    });
+
+    testWidgets('Random: its own painting is kept, the set shown', (tester) async {
+      await open(tester, readings: one, read: isRead);
+      await h.journal.keepPainting(n.id, own);
+      await tester.pageBack();
+      await tester.pumpAndSettle();
+      await tester.tap(find.byKey(Opener.openKey));
+      await tester.pumpAndSettle();
+      expect(look(tester), Painting(paintingFor(n.id, NightArt.paintings)));
+    });
+
+    testWidgets('read by Start Interpretation, then painted', (tester) async {
+      final r = held();
+      final answer = r.next();
+      final p = painting();
+      await open(tester, read: isRead, reader: r.reader, personal: true, painter: p.painter);
+      expect(p.asked, isEmpty);
+      await tester.tap(find.byKey(NightPage.startKey));
+      await tester.pump();
+      answer.complete(three);
+      await tester.pumpAndSettle();
+      expect(p.asked, hasLength(1));
+      expect(find.text(Lines.MP_81.text(Lang.en)), findsOneWidget);
+      p.asked.single.complete(own);
+      await tester.pumpAndSettle();
+      expect((look(tester) as PersonalPainting).jpeg, own);
+    });
+
+    testWidgets('MP·81 at three times the text size: inside the header', (tester) async {
+      tester.platformDispatcher.textScaleFactorTestValue = 3;
+      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+      final p = painting();
+      await open(tester, readings: one, read: isRead, personal: true, painter: p.painter);
+      expect(tester.takeException(), isNull);
+      final header = tester.getRect(find.byType(NightArt));
+      for (final line in [find.byKey(NightPage.paintingKey), find.text(Lines.MP_81.text(Lang.en))]) {
+        final r = tester.getRect(line);
+        expect(header.contains(r.topLeft) && header.contains(r.bottomRight - const Offset(1, 1)), isTrue);
+      }
+      p.asked.single.complete(own);
+      await tester.pumpAndSettle();
+    });
+  });
 }
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -423,8 +423,8 @@ ROWS = [
     # The recording branch (D69 to D71): the read failures, recording's
     # core, the typing screen under D70, the microphone and Dev's wiring.
     ('A40', 'lib/journal/pages/journal_page.dart',
-     '      nights = await widget.journal.newestFirst();\n    } on Object {\n      SafeLog.event(LogEvent.journalListFailed);\n',
-     '      nights = await widget.journal.newestFirst();\n    } on Object {\n',
+     '      paintings = widget.personal ? await widget.journal.paintings() : const {};\n    } on Object {\n      SafeLog.event(LogEvent.journalListFailed);\n',
+     '      paintings = widget.personal ? await widget.journal.paintings() : const {};\n    } on Object {\n',
      'test/journal/pages/journal_page_test.dart', 'a failed load keeps the rows shown and logs a code'),
     ('A41', 'lib/journal/pages/journal_page.dart',
      '        // Nothing opens; a code is logged (D71 Q18).\n        SafeLog.event(LogEvent.journalListFailed);\n',
@@ -1726,12 +1726,12 @@ ROWS = [
      'Daypart.night => Lines.MP_74,',
      'test/journal/greeting_test.dart', 'each part has its filed place, four lines each'),
     ('A364', 'lib/journal/night_look.dart',
-     'read && paintings > 0 ?',
-     'paintings > 0 ?',
+     'if (!images || !read) return',
+     'if (!images) return',
      'test/journal/night_look_test.dart', 'an unread night shows the painted gradient'),
     ('A365', 'lib/journal/night_look.dart',
-     'read && paintings > 0 ?',
-     'read ?',
+     'return paintings > 0 ? Painting(',
+     'return paintings >= 0 ? Painting(',
      'test/journal/night_look_test.dart', 'with no paintings, a read night shows the gradient'),
     ('A366', 'lib/journal/night_look.dart',
      'id.substring(0, 8)',
@@ -1768,8 +1768,8 @@ ROWS = [
      '          _sky = sky;\n',
      'test/journal/pages/journal_page_test.dart', 'the greeting: by the clock, centred, a heading, above New Dream'),
     ('A376', 'lib/journal/pages/journal_page.dart',
-     'look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings, images: widget.images),',
-     'look: lookOf(night, read: false, paintings: NightArt.paintings, images: widget.images),',
+     '        read: widget.read(night),\n        paintings: NightArt.paintings,',
+     '        read: false,\n        paintings: NightArt.paintings,',
      'test/journal/pages/journal_page_test.dart', "a read night's row shows its painting"),
     ('A377', 'lib/journal/pages/journal_page.dart',
      '          read: widget.read,\n',
@@ -1793,8 +1793,8 @@ ROWS = [
      'if (false) ...[_jumps(p), const SizedBox(height: StandIns.gap)],',
      'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
     ('A382', 'lib/journal/pages/night_page.dart',
-     'lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images);',
-     'lookOf(n, read: false, paintings: NightArt.paintings, images: widget.images);',
+     'lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images, personal: _own);',
+     'lookOf(n, read: false, paintings: NightArt.paintings, images: widget.images, personal: _own);',
      'test/journal/pages/night_page_test.dart', 'a read night: its painting, then four jump buttons'),
     ('A383', 'lib/journal/pages/night_page.dart',
      'final read = n != null && widget.read(n);',
@@ -1843,8 +1843,8 @@ ROWS = [
      'test/journal/pages/journal_home_test.dart', 'by default no night is read'),
     # redesign-a's final review (D91): the greeting on returning, the status bar's room, the jump's time.
     ('A394', 'lib/journal/pages/journal_page.dart',
-     '      _nights = nights;\n      _greeting = _greetingNow();\n',
-     '      _nights = nights;\n',
+     '      _paintings = paintings;\n      _greeting = _greetingNow();\n',
+     '      _paintings = paintings;\n',
      'test/journal/pages/journal_page_test.dart', 'the greeting follows the clock on returning'),
     ('A395', 'lib/journal/pages/night_page.dart',
      'height: top + StandIns.headerHeight,',
@@ -2261,20 +2261,20 @@ ROWS = [
      'Answer(given[c] ?? true, dayOf(now))',
      'test/settings/settings_controller_test.dart', 'a consent answered shows at once, then is kept'),
     ('A509', 'lib/journal/night_look.dart',
-     'images && read && paintings > 0',
-     'read && paintings > 0',
+     'if (!images || !read) return',
+     'if (!read) return',
      'test/journal/night_look_test.dart', 'with Night images Off, a read night shows the gradient'),
     ('A510', 'lib/journal/pages/journal_page.dart',
-     'paintings: NightArt.paintings, images: widget.images),',
-     'paintings: NightArt.paintings),',
+     '        images: widget.images,\n        personal: _paintings[night.id],',
+     '        personal: _paintings[night.id],',
      'test/journal/pages/journal_page_test.dart', 'with Night images Off, a read row shows the gradient'),
     ('A511', 'lib/journal/pages/journal_page.dart',
      '          images: widget.images,\n',
      '',
      'test/journal/pages/journal_page_test.dart', 'with Night images Off, a read row shows the gradient'),
     ('A512', 'lib/journal/pages/night_page.dart',
-     'paintings: NightArt.paintings, images: widget.images);',
-     'paintings: NightArt.paintings);',
+     'paintings: NightArt.paintings, images: widget.images, personal: _own);',
+     'paintings: NightArt.paintings, personal: _own);',
      'test/journal/pages/night_page_test.dart', 'with Night images Off, a read night: the gradient'),
     ('A513', 'lib/journal/pages/journal_home.dart',
      'images: _settings?.settings.images != NightImages.off,',
@@ -3034,8 +3034,8 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'the preview seeds before the journal opens; a failure, a code'),
     ('A752', 'lib/main_dev.dart',
-     ", preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight)",
-     ', feedback: feedback, readNight: readNight)',
+     ", preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight, painter: painter)",
+     ', feedback: feedback, readNight: readNight, painter: painter)',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A753', 'lib/main.dart',
      "import 'core/safe_log.dart';\n",
@@ -3159,8 +3159,8 @@ ROWS = [
      '        alignment: Alignment.topLeft,\n',
      'test/journal/pages/journal_page_test.dart', "a row: the date over an unread night's gradient"),
     ('A777', 'lib/journal/pages/night_art.dart',
-     'Positioned.fill(child: _Cover(asset(look.index))),',
-     'Positioned.fill(child: _Cover(asset(0))),',
+     'Positioned.fill(child: _Cover(AssetImage(asset(look.index)))),',
+     'Positioned.fill(child: _Cover(AssetImage(asset(0)))),',
      'test/journal/pages/night_art_test.dart', 'each painting covers its box from the middle'),
     ('A778', 'lib/journal/pages/night_art.dart',
      '          Positioned.fill(child: CustomPaint(painter: _GradientPainter())),\n          if (look',
@@ -3171,7 +3171,7 @@ ROWS = [
      "static const asset = 'assets/paintings/01.jpg';",
      'test/journal/pages/night_art_test.dart', "the sky: the set's strip, covering the pill"),
     ('A780', 'lib/journal/pages/night_art.dart',
-     '      const Positioned.fill(child: _Cover(asset)),\n',
+     '      const Positioned.fill(child: _Cover(AssetImage(asset))),\n',
      '',
      'test/journal/pages/night_art_test.dart', "the sky: the set's strip, covering the pill"),
     ('A782', 'pubspec.yaml',
@@ -3208,7 +3208,7 @@ ROWS = [
      '    alignment: Alignment.topCenter,\n    child: FractionallySizedBox(',
      'test/journal/pages/art_overlay_test.dart', 'a header: its bottom half fades to black'),
     ('A790', 'lib/journal/pages/night_art.dart',
-     'if (look is Painting && overlay != null)',
+     'if (look is! PaintedGradient && overlay != null)',
      'if (overlay != null)',
      'test/journal/pages/art_overlay_test.dart', 'the gradient has no overlay, in a row or a header'),
     ('A791', 'lib/journal/pages/night_art.dart',
@@ -3253,8 +3253,8 @@ ROWS = [
      'style: TypeRoles.h2.style(NightArt.over),',
      'test/journal/pages/night_page_test.dart', "the header's date is 55 pt, centred at the foot"),
     ('A801', 'lib/journal/pages/night_page.dart',
-     'fit: BoxFit.scaleDown,',
-     'fit: BoxFit.none,',
+     'fit: BoxFit.scaleDown,\n                                    child: Text(\n                                      shownDate',
+     'fit: BoxFit.none,\n                                    child: Text(\n                                      shownDate',
      'test/journal/pages/night_page_test.dart', 'at twice the size the date is drawn inside the header'),
     ('A802', 'lib/journal/pages/night_page.dart',
      'mainAxisAlignment: MainAxisAlignment.spaceBetween,',
@@ -3383,8 +3383,8 @@ ROWS = [
      '',
      'test/settings/settings_page_test.dart', 'Feedback: after the kept row, before the actions, given a sender'),
     ('A835', 'lib/journal/pages/journal_home.dart',
-     '        feedback: widget.feedback,\n        readNight: widget.readNight,\n      ),\n    };',
-     '        readNight: widget.readNight,\n      ),\n    };',
+     '        feedback: widget.feedback,\n        readNight: widget.readNight,\n        personal:',
+     '        readNight: widget.readNight,\n        personal:',
      'test/settings/settings_page_test.dart', 'Feedback: after the kept row, before the actions, given a sender'),
     ('A836', 'lib/main_dev.dart',
      "  final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));",
@@ -3863,6 +3863,95 @@ ROWS = [
      'const maxPaintTries = 3;',
      'const maxPaintTries = 4;',
      'test/readings/painting_test.dart', 'three tries at most; then nothing is asked again'),
+    # A read night's own painting on its page and its row (D162 item 1).
+    ('A954', 'lib/journal/night_look.dart',
+     '  if (personal != null) return PersonalPainting(personal);\n',
+     '',
+     'test/journal/night_look_test.dart', "a read night's own painting, given: shown instead of the set's"),
+    ('A955', 'lib/journal/night_look.dart',
+     '  if (!images || !read) return const PaintedGradient();\n  if (personal != null) return PersonalPainting(personal);\n',
+     '  if (personal != null) return PersonalPainting(personal);\n  if (!images || !read) return const PaintedGradient();\n',
+     'test/journal/night_look_test.dart', 'its own painting: never on an unread night, nor while Off'),
+    ('A956', 'lib/journal/night_look.dart',
+     'identical(other.jpeg, jpeg)',
+     'other.jpeg.length == jpeg.length',
+     'test/journal/night_look_test.dart', "a read night's own painting, given: shown instead of the set's"),
+    ('A957', 'lib/journal/pages/night_art.dart',
+     '          if (look is PersonalPainting) Positioned.fill(child: _Cover(MemoryImage(look.jpeg))),\n',
+     '',
+     'test/journal/pages/night_art_test.dart', "a night's own painting covers its box, silent, from its bytes"),
+    ('A958', 'lib/journal/pages/night_art.dart',
+     'if (look is! PaintedGradient && overlay != null)',
+     'if (look is Painting && overlay != null)',
+     'test/journal/pages/night_art_test.dart', "a night's own painting covers its box, silent, from its bytes"),
+    ('A959', 'lib/journal/pages/night_page.dart',
+     '      _own = own;\n    });\n    _paint(n);\n',
+     '      _own = own;\n    });\n',
+     'test/journal/pages/night_page_test.dart', "MP·81 over the set's painting, then its own painting"),
+    ('A960', 'lib/journal/pages/night_page.dart',
+     '|| _asked ',
+     '',
+     'test/journal/pages/night_page_test.dart', "a failure: the set's painting stays, silently; one try"),
+    ('A961', 'lib/journal/pages/night_page.dart',
+     ' || !widget.read(n)) return;',
+     ') return;',
+     'test/journal/pages/night_page_test.dart', 'read by Start Interpretation, then painted'),
+    ('A962', 'lib/journal/pages/night_page.dart',
+     '|| !widget.images ',
+     '',
+     'test/journal/pages/night_page_test.dart', 'Random, Off, unread or no painter: nothing asked'),
+    ('A963', 'lib/journal/pages/night_page.dart',
+     '|| !widget.personal ',
+     '',
+     'test/journal/pages/night_page_test.dart', 'Random, Off, unread or no painter: nothing asked'),
+    ('A964', 'lib/journal/pages/night_page.dart',
+     '      if (done == Painted.made) await _load();\n',
+     '',
+     'test/journal/pages/night_page_test.dart', "MP·81 over the set's painting, then its own painting"),
+    ('A965', 'lib/journal/pages/night_page.dart',
+     'setState(() => _making = false);',
+     'setState(() {});',
+     'test/journal/pages/night_page_test.dart', "a failure: the set's painting stays, silently; one try"),
+    ('A966', 'lib/journal/pages/night_page.dart',
+     '                            if (_making)\n',
+     '                            if (_making || _own == null)\n',
+     'test/journal/pages/night_page_test.dart', 'Random, Off, unread or no painter: nothing asked'),
+    ('A967', 'lib/journal/pages/night_page.dart',
+     '                                    liveRegion: true,\n                                    child: FittedBox(',
+     '                                    liveRegion: false,\n                                    child: FittedBox(',
+     'test/journal/pages/night_page_test.dart', 'MP·81 is heard as it comes'),
+    ('A968', 'lib/journal/pages/night_page.dart',
+     'own = await widget.journal.painting(widget.id);',
+     'own = await widget.journal.painting(widget.id) == null ? null : null;',
+     'test/journal/pages/night_page_test.dart', 'a night with its own painting: shown, nothing asked'),
+    ('A969', 'lib/journal/pages/night_page.dart',
+     '                                    child: FittedBox(\n                                      fit: BoxFit.scaleDown,\n                                      child: Text(\n                                        Lines.MP_81',
+     '                                    child: FittedBox(\n                                      fit: BoxFit.none,\n                                      child: Text(\n                                        Lines.MP_81',
+     'test/journal/pages/night_page_test.dart', 'MP·81 at three times the text size: inside the header'),
+    ('A970', 'lib/journal/pages/journal_page.dart',
+     'widget.personal ? await widget.journal.paintings() : const {}',
+     'await widget.journal.paintings()',
+     'test/journal/pages/journal_page_test.dart', "Random: a read row shows the set's painting, not its own"),
+    ('A971', 'lib/journal/pages/journal_page.dart',
+     'personal: _paintings[night.id],',
+     'personal: null,',
+     'test/journal/pages/journal_page_test.dart', "Personal: a read row shows the night's own painting"),
+    ('A972', 'lib/journal/pages/journal_page.dart',
+     '          personal: widget.personal,\n          painter: widget.painter,\n        ),',
+     '        ),',
+     'test/journal/pages/journal_page_test.dart', "Personal: a read row shows the night's own painting"),
+    ('A973', 'lib/journal/pages/journal_home.dart',
+     'personal: _settings?.settings.images == NightImages.personal,',
+     'personal: _settings != null,',
+     'test/journal/pages/journal_home_test.dart', 'the settings kept are followed; the deletion resets them'),
+    ('A974', 'lib/journal/pages/journal_home.dart',
+     '        painter: widget.painter,\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', "Personal is handed to the journal, with Dev's painter"),
+    ('A975', 'lib/main_dev.dart',
+     'readNight: readNight, painter: painter)',
+     'readNight: readNight)',
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
 ]
 
 
~~~~

### Task 6 · Docs: Status.md

Changed: `docs/Status.md`: the first line, the current branch (and `c19p-import`'s merge), the road ahead, the
night's look, the night's own painting in the app, the server's painting, its key, timeout and role, the totals,
and "Rulings during painting" (D162; the answers to Part 4 when given).

Commit:

> Status.md: painting (D162); c19p-import's merge recorded

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-25, in branch `c19p-import` (Product's C19-P imported and reconciled with the founder's D161; built; the owner's by-eye check, then the full mutation run, D126), by Claude Code.
+Last updated: 2026-11-25, in branch `painting` (the readings' plumbing, part two: the night's personal painting, D162; built and tested, the owner's storage rehearsal, key move, deploy and by-eye check next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,6 +14,20 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
+`painting` (D162; plan `docs/plans/painting.md`): the readings' plumbing, part two, the night's personal painting
+(D143, D145, D146, D123). In SoulDreams Dev, while Night images is Personal, a read night with no painting of its own
+asks our server's `POST /painting` with the beta key and nothing of the night (`{}`); the server's scenery step
+(the one model interface, its stand-in `stand-in-scenery`) names one fixed placeholder scene, the curated set's
+first, and Black Forest Labs' `flux-2-klein-4b` on `api.eu.bfl.ai` paints it in the one style at 1280 x 960 as a
+JPEG, which our code tags with the invisible AI tag (D123) and sends back; nothing is kept on the server, which logs
+the cost alone. While it is made, the night's header shows its curated painting with MP·81 ("New painting on the
+way"); the night's own painting replaces it when it comes, and is kept beside the night in the journal's folder
+(`painting-<id>.jpg`, written whole, deleted with the night; a storage change, docs/workflow.md (c)). A failure
+leaves the curated painting, silently, and is counted (`painting-<id>.tries`): the next opening of the night tries
+again, three tries at most. Random shows a curated painting, Off the gradient. The BFL key's permanent name is
+`/souldreams/bfl-key` (the owner's move); the Lambda's timeout is 60 seconds. `c19p-import` is merged (`main` at
+`399a199`).
+
 `c19p-import` (D161; plan `docs/plans/c19p-import.md`): Product's C19-P (the register, the Design System, Product's
 record) imported and reconciled with the founder's rulings. The pending Back and Turn on are MP·107 and MP·108, and
 "I don't agree" is the pending MP·109, EM·6's last filed words, EM·6 being retired at C19-P (D161 items 1 and 2);
@@ -59,11 +73,12 @@ merge (this entry records it).
 
 ## Road ahead
 
-- `c19p-import`: the owner's by-eye check (plan Task 5), the full mutation run (D126), then the merge, the owner's.
-  It changes no storage. Before `readings-plumbing`'s merged build reaches the Cohort 0 app, the owner's safety
-  export (docs/workflow.md (c) item 4).
-- `readings-plumbing`, part two: the painting (D143, D145, D146, D123; D155 items 1 and 3): its plan after part one's
-  merge.
+- `c19p-import` (merged): it changes no storage. Before `readings-plumbing`'s merged build, and `painting`'s, reach
+  the Cohort 0 app, the owner's safety export (docs/workflow.md (c) item 4).
+- `painting`: the owner's storage rehearsal (plan Task 3), the key move and the deploy (Tasks 7 and 8), the by-eye
+  check (Task 9), the full mutation runs (D126), then the merge, the owner's. The night's image controls in its menu
+  (MP·78 to MP·80) are a later branch (D162 item 5); the scenery written by the readings' model comes with its
+  instructions (D143, R7).
 - `life-context` (merged): the owner's by-eye review passed (plan Task 7, with D133 and D134; VoiceOver waits for
   the full pass, D98) and the full mutation run was done: `app mutations: 726 run, 726 caught` at `46d5ebd` (9 min
   1 s on the owner's Mac, parallel). The Product questions are banked (items 167 and 169).
@@ -257,6 +272,17 @@ merge (this entry records it).
   painted gradient (the dark theme's bubble gradient, both themes); in SoulDreams Dev a night is read when it holds
   its readings (`isRead`), in the other builds none is (`noneRead`), and SoulDreams Dev built with
   `--dart-define=PREVIEW_READ=true` shows every night as read, for the owner's review.
+- The night's own painting (D162; `app/lib/readings/painting.dart`; SoulDreams Dev only, `dev_only_test.dart`): while
+  Night images is Personal, a read night with no painting of its own and fewer than three failed tries is painted
+  once each time its page opens (`Painter`, one request per night at a time): one POST to our server's `painting`
+  with the beta key and `{}`, no user agent, 75 seconds; anything but 200 with a whole JPEG of at most 4 MiB is a
+  `PaintingFailure` (the status; 0 no answer; -1 not a JPEG; -2 no server or key). While it is made the header shows
+  MP·81 over the curated painting, as a live region, scaled down to its room; when it comes, the page and the row
+  show it (`PersonalPainting`, from its bytes, under the same overlays); a failure is counted and shows nothing.
+  The journal keeps it as `painting-<id>.jpg` beside the night (written whole, only while the night's file is
+  there), and the count as `painting-<id>.tries`, removed when a painting comes; deleting the night deletes both
+  first; at open, either one whose night is gone is swept (`paintingSwept`). Codes: `paintingMade` (bytes),
+  `paintingFailed` (status; -3 anything else), `paintingKeepFailed`.
 - The readings (head's message 33; `app/lib/readings/readings.dart`; SoulDreams Dev only, `dev_only_test.dart`):
   `postReading` (one POST to `Hosts.server` + `reading`, the beta key, `{"lang", "dreams", "kept"?}`, 30 seconds;
   anything but 200 with one to three whole readings fails: the status, 0 no answer, -1 unreadable, -2 no server or
@@ -345,8 +371,8 @@ merge (this entry records it).
   164 closed; D161 item 2).
   C19-P's MP·98 (the voice paused until consent) is shown nowhere: the microphone stays, with the popup (D161 item 3). Night images has no consent: Personal
   by default (D160: in a fresh journal and after Delete journal, with "I agree" or not), a read night its painting;
-  Off, one tap away in Settings, shows every night the gradient (`lookOf`'s `images`); Personal and Random keep
-  D110's look until the personal painting exists (D121 item 3).
+  Off, one tap away in Settings, shows every night the gradient (`lookOf`'s `images`); Random shows the curated
+  painting; Personal shows a read night's own painting once it has come (D162), the curated one until then.
 - Settings (main-path.md, Settings; D110; D121; D122; D125; D128; `settings_page.dart`; TO TRY where a stand-in): the
   settings button top left on the journal, on the search field's row, the field to its right and ending where the
   rows end (three drawn sliders in place of the gear, 41 in a 44 tap box, its own semantics node, spoken MP·25; the
@@ -413,7 +439,7 @@ merge (this entry records it).
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 837 tests, and 859 mutation checks (A1 to A920; A418 to A422, A424 to A426, A429, A781 (D149), A24ah,
+- The app's analyzer baseline: `No issues found!`. The app has 873 tests, and 913 mutation checks (A1 to A975; A418 to A422, A424 to A426, A429, A781 (D149), A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
   A277, A278, A281, A288, A291, A300, A301, A302, A313, A363, A375, A507, A518, A521, A526, A527, A530, A537, A538, A539, A540, A541, A543, A546, A549, A550, A553, A554, A558, A566, A574, A575, A578, A583, A585 to A600, A610, A623, A624, A626, A627, A629, A633, A634, A635, A645, A646, A369 and A409 to A411
   dropped, each with its reason in the file; with the rows A24a to
@@ -451,7 +477,16 @@ merge (this entry records it).
   are handed the instructions read once from `dist/src/instructions/` (`instructions.ts`; every `.md` but the
   placeholder, in name order), which `infra/dist.ts`
   copies from `server/instructions/` (R7: only the empty `AWAITING-INSTRUCTIONS.md`). No Bedrock call, no new
-  permission, the 10-second timeout unchanged.
+  permission.
+- `server/src/`: the night's painting (D162; `painting.ts`): POST `/painting` with the beta key and a body of `{}`
+  exactly (anything else 400, over 64 characters 413, `paintingRefused`) reads BFL's key (`/souldreams/bfl-key`),
+  asks the scenery step (`SCENERY_PROMPT`, nothing of the night; its stand-in names the curated set's first scene),
+  and paints `<scene>, <FRAME>, <STYLE>` with `flux-2-klein-4b` at 1280 x 960 as a JPEG on `api.eu.bfl.ai`, polling
+  every half second for 30 seconds at most, each request 10 seconds at most, the key sent only to BFL's own hosts
+  over https; the image must be a JPEG of that size, at most 4 MiB, holding no XMP packet of its own, and gets the AI
+  tag (`jpeg.ts`, moved from `trial/`). 200 with the JPEG as base64 (`isBase64Encoded`), `paintingGiven` with its
+  cost in millionths of a dollar; BFL or the scene failing 502, `paintingFailed` with its code. `STYLE` and `FRAME`
+  live in `painting.ts`; the trial's files import them.
 - `server/src/`: the front door (`door.ts`, head's message 14; D71): POST `/` with the beta key as a bearer token gets
   a short-lived Soniox key (200, `{key, expiresAt}`); a missing, wrong or misshapen key 401 with no body, before
   anything is read when misshapen; another method or path 404; Parameter Store failing 500; Soniox failing 502
@@ -466,14 +501,14 @@ merge (this entry records it).
   `tool/read_feedback.sh <profile>` (`aws s3 mv` into `~/SoulDreams-feedback/<day>/`, each file dated to its day). The beta key's check hashes both keys and compares them in constant time
   (`beta-key.ts`). The temporary key's request is exactly four fields: `transcribe_websocket`, 60 seconds to open,
   single use, 1800 seconds at most (`soniox.ts`, D71 Q10), sent to `api.eu.soniox.com` (`hosts.ts`). The two keys
-  are read from Parameter Store as SecureStrings (`parameters.ts`, `parameter-names.ts`); `handler.ts` wires them.
+  are read from Parameter Store as SecureStrings, with BFL's for the painting (`parameters.ts`, `parameter-names.ts`); `handler.ts` wires them.
   `safe-log.ts` (codes and numbers only). `server/infra/`: the CDK app, its account refusal and the stack.
   `npm run build` writes `dist/src` with the module marker beside the compiled files (D42 Q5).
-- The stack: one Lambda (`nodejs24.x`, arm64, CDK's default memory, a 10-second timeout, D71 Q20) behind its own
+- The stack: one Lambda (`nodejs24.x`, arm64, CDK's default memory, a 60-second timeout, D71 Q20, D162) behind its own
   function URL in eu-north-1, with no authentication of the URL's own (the beta key is checked in the code), no CORS,
   and the two permissions a public function URL needs (`InvokeFunctionUrl` and `InvokeFunction` through the URL;
   CDK 2.275.0 makes both); one output, the URL's address; logs kept 7 days, JSON, application INFO, system WARN; a
-  role that writes only to its own log group, reads the two parameters only, and decrypts only through Parameter
+  role that writes only to its own log group, reads the three parameters only, and decrypts only through Parameter
   Store; no access logs, tracing or environment; no reserved concurrency yet (D71 Q12); termination protection on
   (D42 Q4, Q7 to Q9). The CDK CLI's telemetry, notices and version reporting are off (D42 Q3). **Deployed once**, on
   2026-11-13 by the owner, to the workload account (stack `SoulDreamsServer`); its address is in `hosts.dart`.
@@ -491,14 +526,14 @@ merge (this entry records it).
   tests run with the server's, against fakes: no AWS, no network.
 - The curated set's painter (D147; `docs/plans/curated-set.md`), on the owner's Mac only: `server/trial/curated.ts`
   (paint, repaint, proof, ship; the USD 3 cap from BFL's own replies), `server/trial/scenes.ts` (the sixty invented
-  scenes and the sky) and `server/trial/jpeg.ts` (sizes, the sRGB profile and the AI tag, written by our own code;
+  scenes and the sky) and `server/src/jpeg.ts` (sizes, the sRGB profile and the AI tag, written by our own code;
   its names in `server/src/hosts.ts`, never fetched). macOS's `sips` makes each JPEG, and our code embeds the OS's own
   sRGB profile in it, since `sips` on macOS 26 writes none. Tested against fakes.
-- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 184 tests, and
-  175 mutation checks (S1 to S180, S42 retired with the budget resource, D138, S82 to S85 with the style test, D146)
+- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 203 tests, and
+  201 mutation checks (S1 to S206, S42 retired with the budget resource, D138, S82 to S85 with the style test, D146)
   in `tool/server_mutations.py`, run by
-  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 175 run,
-  175 caught`); `check_all.sh` does not
+  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 201 run,
+  201 caught`); `check_all.sh` does not
   call it (D43 Q3). It first runs the type check and the tests on the unbroken server, and stops with
   `server mutations: FAILED (the unbroken server fails)`, exit 1, if either fails (the final review, `2fbaad6`).
 
@@ -1933,6 +1968,20 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 - The founder accepts MP·109's Swedish, "Jag samtycker inte" (owner's brief, 2026-11-25): banked item 164 is closed.
   The documents repository was at `8a92a57` for the import.
 
+## Rulings during painting
+
+- `c19p-import` merged by the owner (`399a199`).
+- D162 (owner, the brainstorm): (1) while the painting is made, the night shows its curated painting with "New
+  painting on the way" (MP·81); the personal painting replaces it when it arrives; (2) a failed painting leaves the
+  curated one, silently, retried on the next opening of that night, up to 3 tries; (3) the painting is kept on the
+  phone in the journal's folder (protected, backup-excluded), deleted with its night (R11), nothing kept on our
+  server; a storage change under docs/workflow.md (c); (4) the BFL key moves from `/souldreams/trial/bfl-key` to a
+  permanent name (owner task); (5) the image controls in the night's menu are a later branch. Personal shows the
+  painting, Random a curated one, Off the gradient. D91 and D126 apply; the owner checks by eye only. BFL's training
+  opt-out was requested by email (2026-11-23).
+- Built as planned (`docs/plans/painting.md`, Part 1, "Decided under D91"); Part 4's questions and their answers
+  are listed there.
+
 ## Documents as last imported
 
 Imported by the owner in branch `c19p-import` (C19-P: the register, the Design System and Product's record), at the
~~~~

### Task 7 · [OWNER] The BFL key's permanent name (D162 item 4)

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app && BFL_KEY=$(aws ssm get-parameter --name /souldreams/trial/bfl-key --with-decryption --query Parameter.Value --output text --profile soul-dreams-workload --region eu-north-1) && aws ssm put-parameter --name /souldreams/bfl-key --type SecureString --value "$BFL_KEY" --profile soul-dreams-workload --region eu-north-1 --query Version --output text; unset BFL_KEY; aws ssm get-parameter --name /souldreams/bfl-key --with-decryption --profile soul-dreams-workload --region eu-north-1 --query 'length(Parameter.Value)' --output text
```

Expected: `1` (the new parameter's first version), then the key's length, the same number as the old one's (the
bfl-test plan's step B1 printed it). An error that the parameter exists: stop and bring it (nothing is
overwritten). The old `/souldreams/trial/bfl-key` stays until Task 9 has passed.

### Task 8 · [OWNER] The deploy

The server's code, its timeout and its role change; nothing else in the stack does.

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk diff -c account=<workload id> --profile <workload profile>
```

Expected: the diff shows `AWS::Lambda::Function` `SoulDreamsServer…` with its `Code` (the asset's hash) and its
`Timeout` (10 to 60) changed, and the role's policy (`AWS::IAM::Policy`) gaining one `ssm:GetParameter` resource
ending `parameter/souldreams/bfl-key`; no bucket, URL, output or log group change. Anything else: stop and bring the
diff.

Paste 2 — Terminal (only if Paste 1 was as expected)

```
cd ~/Developer/soul-dreams-app/server && npx cdk deploy -c account=<workload id> --profile <workload profile>
```

Expected: `SoulDreamsServer` updated, the same `FunctionUrl` output as before. The address in `hosts.dart` does not
change.

### Task 9 · [OWNER] The by-eye check, SoulDreams Dev, invented nights only

SoulDreams Dev built from `painting` with the beta key, installed over the Task 3 build. Invented nights only (R2):
type them from `fixtures/invented-nights.json`. Settings → Night images is Personal (the default).

1. **A night read, then painted**: open an unread night, tap Start Interpretation. Expected: the readings come, the
   header shows a painting from the curated set with "New painting on the way" over it, between the controls and
   the date; within about half a minute it is replaced by a new painting, of a wheat field at dawn in the painterly
   style (each night's differs: BFL picks the seed). "New painting on the way" is gone.
2. **The row**: back in the journal, the night's row shows the new painting, darkened like the others.
3. **Opening it again**: the same painting, no "New painting on the way", nothing asked again.
4. **A night read before this build** (from Task 3): opening it shows "New painting on the way", then its painting.
5. **Random** (Settings → Night images): the painted nights show curated paintings; **Off**: the gradient;
   **Personal** again: their own paintings.
6. **A failure**: Settings → Night images → Random; read a new night with Start Interpretation (no painting is asked
   for under Random). Turn Wi-Fi and mobile data off; Night images → Personal; open that night. Expected: "New
   painting on the way", then it goes and the curated painting stays, with no message. Network on; leave the night
   and open it again: it is painted.
7. **Deleting** a painted night: it goes, and so does its painting (the tests prove the file; by eye, the night is
   gone from the journal).
8. **The dark theme and large text** (Night/Day mode, Night; Larger Text, the largest): "New painting on the way"
   stays inside the header, scaled down if needed.
9. **The server's log** (CloudWatch, the Lambda's log group): each painting shows as `modelUsage 3 1 0 0 0 0 0` (the
   scenery step, the scenery stand-in, zero tokens), then `paintingGiven` with a number near 14000 (1.4 credits);
   a failure as `paintingFailed` with its code; no word of any night. **If every painting fails with
   `paintingFailed -5`**, BFL's JPEG carries a packet of its own where our tag goes (question 8): stop and bring
   the log.
10. Then, only if 1 to 9 passed, delete the old key:

Paste 1 — Terminal

```
aws ssm delete-parameter --name /souldreams/trial/bfl-key --profile soul-dreams-workload --region eu-north-1 && echo deleted
```

Expected everywhere: nothing else changed. Anything different: stop, and bring what you saw.

### Task 10 · The full mutation runs (D126)

Once, after Task 9 and before the merge: `python3 -I -B tool/app_mutations.py` (expected `app mutations: 913 run,
913 caught`) and `python3 -I -B tool/server_mutations.py` (expected `server mutations: 201 run, 201 caught`, about
40 minutes, serial).

Then, before the merged build reaches the Cohort 0 app (docs/workflow.md (c) items 4 and 5): the owner exports each
night as C142-I item 3 rules (AirDrop to the Mac, into `restricted/`), installs, checks every night by eye, and deletes
the safety copy. The founder's build changes only in what its journal's folder knows: it never paints.

## Part 4 · Questions (numbered; a blank is not a yes)

Each with its lean. None blocks the tasks: each is built as its lean says, and a different answer is a small change.

1. **MP·70 and the rulings differ** (for the head and Product). The filed MP·70 (the night images consent, C19-P)
   says a Personal painting's words "go to Google in the EU", that "Google keeps none of them and uses none of them
   for training", and its notes say "the app adds no mark to a painting" and that until Google's approval "Personal
   shows a painting from the curated set". The rulings say Black Forest Labs' EU API (D145), whose terms allow
   training on inputs and outputs unless the opt-out (requested 2026-11-23) is confirmed, and our own invisible tag
   on every image (D123). MP·70 is shown nowhere now (D127), and this branch sends nothing of a night, in SoulDreams
   Dev only. Lean: build as the rulings say; the head carries the difference to Product, and it is settled (MP·70
   rewritten, or the rulings changed) before any build a real dreamer uses paints.
2. **"Up to 3 tries"** counts every try, the first included: three failures and no more is asked. Lean: yes.
3. **When a painting is asked for**: when a read night's page opens, and right after Start Interpretation reads it
   there; not in the background for every read night. A painting still under way when the page is left goes on and
   is kept; the row shows it the next time the journal loads (leaving a night's page reloads it). Lean: yes.
4. **A night read while Random or Off, then Personal chosen**: it is painted the next time its page opens (its tries
   permitting). Lean: yes.
5. **MP·81's look**: in the header between the back control and the date, centred, in `type.button` and the date's
   colour (`color.text`, the dark theme's), scaled down to its room, heard as a live region; all stand-ins, as the
   register says only "in the image's place". Lean: as built, for the founder's eye.
6. **The placeholder scene**: the curated set's first scene for every night, with no seed, so BFL makes each
   night's painting differently. Lean: yes, until the readings' model writes the scene (D143).
7. **The image**: 1280 x 960 (the curated set's, D148), BFL's own JPEG at its own quality; no sRGB profile is
   checked or embedded (the Lambda has no macOS profile; Flutter reads an untagged JPEG as sRGB). Lean: yes; if the
   founder sees colours off, a later change embeds a profile.
8. **BFL's own metadata**: BFL's pages say nothing of C2PA or XMP in its outputs [NOT READ]. Our tag writer refuses
   a JPEG that already holds an XMP packet, so if BFL writes one, every painting fails (`paintingFailed -5`) and the
   curated one stays: found at Task 9, step 9. Lean: as built; if it happens, the question of writing our tag beside
   BFL's comes back with the bytes.
9. **No count or cost of the painting kept on the phone**: the scenery call (`modelUsage`) and BFL's cost
   (`paintingGiven`) are in the server's log only; the night's `usage` is unchanged, so the night's file does not
   change. Lean: yes; keeping them beside the night is another storage change, with the founder's comparison (Part 7
   of the readings-plumbing plan).
10. **No spending stop for BFL** (D69 is not built): anyone with the beta key can ask for paintings, about 1.5 US
    cents each, 24 at a time at most (BFL's limit). Lean: the owner keeps the BFL account's balance small, with no
    automatic top-up, until the spending counter comes.
11. **The Lambda's timeout, 60 seconds, for every route** (10 before). Lean: yes.
12. **The key's name**: `/souldreams/bfl-key`, beside the other two. Lean: yes.
13. **MP·82** ("Painting for this night", the picture's spoken name) is not built: the picture stays silent, as
    before this branch. Lean: bank it for the accessibility pass (D98), with the curated paintings, which are silent
    too.
14. **`jpeg.ts`, `STYLE` and `FRAME` move into `server/src/`**, so the Lambda carries them; the trial's painter
    imports them and does what it did. Lean: yes.
15. **A second stand-in model**, `stand-in-scenery`, for the scenery step, rather than the `Caller` learning the
    step. Lean: yes.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `.scratch/pt/build`, from `git archive` of `399a199`, with
   the pinned Flutter (`app/.fvm`), the app's `.dart_tool` and the server's installed packages. After each task a
   snapshot (`.scratch/pt/snaps/t1` to `t5`, by `snap.sh`, without caches); Task 2's snapshot was cut back by hand to
   its own files (Task 4's log codes and file left out). Each block is `git diff --no-index -M` between two
   snapshots: blocks 1 to 5 are Tasks 1, 2, 4, 5 and 6.
2. **Test first.** Each task's tests were written before its code and failed: Task 1's did not type-check
   (`painting.ts` missing, `jpeg.ts` not yet moved); Task 2's did not load (`paintingOf`, `keepPainting`); Task 4's did
   not load (`painting.dart`); Task 5's did not load (`PersonalPainting`, `personal`, `painter`).
3. **Replayed on a clean copy** (`.scratch/pt/replay`, from `git archive` of `399a199`; `GIT_CEILING_DIRECTORIES`
   set, so `git apply` applies inside the repository's folder): for each task, its test files applied alone first
   (`--include='*/test/*'`), then the rest. Measured:
   - Task 1, tests alone: 34 type errors, `ℹ tests 124`, `ℹ fail 12`; whole: clean, `ℹ tests 203`, `ℹ fail 0`; the
     rename applied (`server/trial/jpeg.ts` gone, `server/src/jpeg.ts` there).
   - Task 2, tests alone: 33 issues, `+796 -1`; whole: `No issues found!`, `+845`.
   - Task 4, tests alone: 41 issues, `+845 -1`; whole: `No issues found!`, `+858`.
   - Task 5, tests alone: 27 issues, `+710 -6`; whole: `No issues found!`, `+873`.
   - Task 6 applied. The replay's final tree is identical, file for file, to the last snapshot, and `guards.py
     --walk` passes on every snapshot (`guards (walk): all passed`).
4. **Mutations** (on the build, identical to the replay's final tree).
   - Server: S181 to S206, then every existing row on the eleven changed files (85): nine "missed" or
     "not-applied" at first. S86, S89, S104, S181, S186, S190, S192, S198 and S200 left a name unused once in `src/`,
     which stops the build before any test runs: each was rewritten to break behaviour and caught. S8, S14, S21,
     S131 and S132 follow the role test's new name; S19 and S20 the timeout; S152 and S156 the door's new route
     (S156 first tripped TypeScript's narrowing, then was repointed at the reading/painting choice). A row on the
     timeout (60 to 10) was dropped as S20's twin before numbering. Every one caught.
   - App: A926 to A975, then `--files` of every changed app file (Task 2's three: `70 run, 70 caught`; Tasks 4 and
     5's eight: `243 run, 228 caught`, the fifteen others "pattern not found" until they followed the moved
     lines, then caught). Two new rows survived at first and were resolved in the code: the page's check for a
     painting already there duplicated `paintNight`'s, so it was removed; the MP·81 size test at twice the text
     could not see a missing `FittedBox`, so it now runs at three times and measures the words themselves. A955
     first duplicated A509's following text, and now breaks the order of `lookOf`'s two checks.
   - G3 refused the count's interpolated literal in `journal_store.dart` (rewritten from a variable, its row A935
     following, in every snapshot).
5. **Not proven here**: the key move (Task 7); the deploy (Task 8; `cdk diff` against the account); BFL's real
   reply and its JPEG's bytes, the look on a phone, the dark theme and large text (Task 9); the storage rehearsal on
   a phone (Task 3). The full mutation runs are Task 10 (D126). `test_check_all.py` cannot run in a copy with no
   `.git` and was not run there; no guard or guard test changed. Nothing here reached our server, AWS, Soniox or
   BFL; BFL's documentation pages were read on the web (Part 2).

*No matter where you are on your journey, the steps you take are equally important.*
