# Plan: the Feedback section of Settings (feedback)

Branch `feedback`, from `main` at `4a22d1a`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5 and 6),
under D91 and D126. Written by Claude Code (Opus) on 2026-11-24. Governs: D110 and C18-P's Feedback places in the
register (MP·49, C4-P·8, MP·46, MP·47), the owner's D152 (the brainstorm), D128 (the popup before "I agree", MP·101
and MP·102), R3, R4, R10 and R11. The founder's screen `docs/reference/screens/feedback.png` is a reference for the
look only (R1); its Withdraw consent row is gone (D128) and Help is ignored (R9). The owner's checks are by eye only.

`curated-set` is merged (`main` at `4a22d1a`); Status.md's first line still names it ("the owner's by-eye check
next"): it was not updated at the merge. Status's road ahead names Feedback next, so this is not a stop; Task 7
records the merge.

**Nothing here can be built before Part 4's question 1 is answered:** the server needs a new package (R10; D91's stop
case), and only the owner installs packages (D41). Question 2 asks the Build chat for two lines; until they are
filed, their handles show (R1), and nothing waits on them.

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

In SoulDreams Dev, Settings gains its Feedback section, as on the founder's screen: under "What you've told Soul
Dreams", the title "Feedback", then a white card with the paragraph on why feedback matters, a grey box to write in
("Your feedback is never linked to your journal…" until something is typed), and a dark Submit button.

- **Submit with nothing written** (or only spaces) does nothing.
- **Before the dreamer has agreed**, Submit shows the same popup as the microphone (MP·101, "To use this, go to
  Settings…", with OK) and sends nothing; the words stay in the box.
- **Otherwise** the words go to our server, once. While they are on their way the box cannot be changed and a second
  tap does nothing.
- **Sent:** the box empties and a short line shows under Submit: `[MP·106]` until the Build chat gives its words.
- **Not sent** (no connection, the server down, anything): the words stay in the box and `[MP·105]` shows, the
  "couldn't send" line D152 item 4 asks for. Submit again tries again.
- Typing takes either line away. At 2,000 characters the box takes no more (a pasted text is cut there); there is no
  counter.
- Leaving Settings drops what is in the box: it is never kept on the phone.

On the server, our one Lambda gains a second door, `POST /feedback`, behind the same beta key. It puts the text, and
nothing else, into a new private bucket in eu-north-1, as one small text file named by its UTC day and a random name
(`2026-11-24/…32 hex….txt`). No name, phone, journal, network address or time of day goes in. The bucket is
encrypted, closed to the public, reachable only over TLS, unversioned, and deletes every file 90 days after it
arrived. The Lambda may only put files there: it cannot read, list or delete them. Its log says `feedbackKept`,
`feedbackRefused 400` or `413`, or `feedbackFailed`: never a word of the text.

The owner reads it with one command on his Mac, `tool/read_feedback.sh <profile>`: it moves every file from the
bucket into `~/SoulDreams-feedback/<day>/` (each deleted from the bucket only once it is safely on the Mac), dates
each file to its day's start, and prints only how many are new.

### What this branch builds

1. **The server's door for feedback** (Task 2; D152 items 1 and 3): `server/src/feedback.ts` (what a request may
   hold: a JSON body of exactly one field, `text`, a string that is not blank, at most 2,000 characters counted as a
   person counts them, by `Intl.Segmenter`'s graphemes; a body over 65,536 characters is refused unread; the UTC day;
   the object's name), `server/src/feedback-store.ts` (one `PutObject`: `Bucket`, `Key`, `Body` the text,
   `ContentType` `text/plain; charset=utf-8`, nothing else; an empty bucket name fails before anything is sent),
   `door.ts` (the route; the beta key checked first, the body read only after it), `handler.ts` (the wiring; the
   bucket from the Lambda's one variable, `FEEDBACK_BUCKET`), `safe-log.ts` (three codes). Replies carry no body:
   204 kept, 400 not one text, 413 too long, 401 the key, 500 Parameter Store or anything unforeseen, 502 the bucket.
2. **The bucket** (Task 3; D152 item 1), in the existing stack `SoulDreamsServer`: SSE-S3 encryption, every public
   access blocked, ACLs off (bucket owner enforced), a bucket policy refusing anything not over TLS, no versioning,
   a lifecycle rule expiring objects after 90 days, no access logs, inventory, replication or notification; kept if
   the stack is ever removed (its 90 days still run). The Lambda's role gains `s3:PutObject` on the bucket's objects
   and nothing more. A second output, `FeedbackBucket`, names it. The function URL and its address do not change.
3. **The reading command** (Task 4; D152 item 2): `tool/read_feedback.sh <profile>`, as above. It finds the bucket
   from the stack's output, makes the folder readable by the owner alone (700), uses `aws s3 mv --recursive` (each
   object deleted only after its own download), then `touch -t` dates every file to its day's start, so the Mac keeps
   no time of day. It prints `read-feedback: <new> new, <all> in <folder>`, never a word of feedback. Tested with a
   stand-in `aws` on `PATH` (`tool/checks/tests/test_read_feedback.py`): no AWS is reached.
4. **The app's sending and Submit** (Task 5): `app/lib/feedback/feedback.dart`: `postFeedback` (one POST to
   `Hosts.server` + `feedback`, the beta key as bearer, `application/json; charset=utf-8`, `{"text": …}`, no user
   agent, nothing else; anything but 204 is a `FeedbackFailure` with the status, no answer 0), `liveFeedback`
   (SoulDreams Dev's: our server and the build's beta key; without either, every send fails at once, -2), and
   `FeedbackForm`, Submit's logic in plain Dart as above. Two log codes, `feedbackSent` and `feedbackFailed` with
   the status (-1 for any other failure).
5. **The section on Settings** (Task 6): `app/lib/feedback/feedback_section.dart`; the palette gains
   `color.button.filled` (`filledTop`, `filledBottom`, `filledText`, fading with the theme); four named stand-ins
   (the card's padding, the field's 4 to 10 lines, Submit's inset); Settings shows the section only when handed a
   sender, which only `main_dev.dart` gives (`JournalHome` → `JournalPage` → `SettingsPage`). `dev_only_test.dart`
   proves no tester or founder build reaches `lib/feedback/`.
6. **Docs** (Task 7): Status.md.

### What it does not build

- Feedback in the tester or founder app (D152 item 5).
- Any reply to the dreamer from the founders, any record on the phone of what was sent, or any count of feedback.
- The words for MP·105 and MP·106 (R1): the Build chat's, through the owner's pending lines (Part 4, question 2).
- Any limit on how often feedback may be sent (Part 4, question 10).

### The decisions, by number

- D110, C18-P: the Feedback section and its four places (MP·49, C4-P·8, MP·46, MP·47).
- D152 (owner, the brainstorm): (1) through our server to a private S3 bucket in the workload account, eu-north-1,
  encrypted, blocked from public access, only the text and the UTC day, codes only in the Lambda's log, deleted after
  90 days; (2) one command on the owner's Mac that downloads the new feedback to a folder and then deletes it from
  the bucket; (3) at most 2,000 characters; an empty Submit does nothing; before "I agree" the D128 popup; (4) a
  failed send keeps the text and shows a "couldn't send" line; (5) SoulDreams Dev only.
- D128 item 3: the popup (MP·101, MP·102), as built in `agreement_popup.dart`.
- D91, D126 (targeted rows during the tasks; the full runs once, before the merge), D67 (a row whose code or test
  name moved follows it).

### Decided under D91 (how to build only)

1. **One more route on the same Lambda and function URL**, not a second function: one beta-key check, one log group,
   no new address in `hosts.dart`.
2. **The day is the server's**, in UTC, so the phone sends only the text.
3. **"Characters" counted as a person counts them** (grapheme clusters): Flutter's length limit counts them so, and
   the server counts the same way with `Intl.Segmenter` (an emoji family is one character, not eight).
4. **The object's name is its day and 128 random bits**: unique, and naming nothing.
5. **The text exactly as typed** (spaces kept); "empty" means nothing but spaces.
6. **The bucket's name reaches the Lambda in one environment variable**; the stack's test that said "no
   environment" now says one variable, the bucket's name (the test's name changes; rows follow).
7. **SSE-S3, not KMS** (question 4), and **kept with the stack** (question 5): leans the code is written with.
8. **The S3 client from the Lambda runtime**, the package a devDependency for its types only, exactly as the SSM
   client (D71 Q13 a); same version as the SSM client (question 1).
9. **The box is closed while sending**, so what is cleared on success is exactly what was sent.
10. **No new mutation tool for the reading script**: `tool/checks/tests/mutations.py` covers `tool/checks/` only;
    nine hand-run breaks of the script were each caught by its test (Part 5).
11. **Existing tests renamed, none weakened**: `stack.test.ts`'s "no environment, no tracing" becomes "one variable,
    the feedback bucket's name; no tracing", its role test and output test gain the bucket; `package.test.ts` counts
    seven packages; `dist.test.ts` the two new files and the S3 client; `door.test.ts`'s event helper may now allow
    the body (only when a test hands one); `journal_home_test.dart`'s text of `main_dev.dart` gains the sender. Rows
    S8, S12, S14, S21, S22, S27 and A752 follow (D67).

### The places this branch uses

- Filed (C18-P), as written: MP·49 (the title), C4-P·8 (the paragraph), MP·46 (the field's hint), MP·47 (Submit).
- Pending, as built: MP·101 and MP·102 (the popup).
- **Owed, their handles shown** (R1): `[MP·105]`, the line after a send that failed (D152 item 4), and `[MP·106]`,
  the line after a send that worked. The register has neither. Proposed handles, words asked of the Build chat
  (question 2).

### The tests (test-first, on the Mac)

Each task's tests were put on the tree before its code and failed (loading, type-checking or asserting); then the
code made them pass (Part 5).

- Server tests: 134 at the start, then 152 (Task 2) and 154 (Task 3). `npm run check` clean at each.
- App tests: 765 at the start, then 776 (Task 5) and 789 (Task 6). `No issues found!` at each.
- Guard tests: one new file, `test_read_feedback.py` (8 tests).
- Server mutation rows: **new** S110 to S135 (26); **following** S8, S12, S14, S21, S22, S27. 104 → 130.
- App mutation rows: **new** A809 to A836 (28); **following** A752. 747 → 775.
- None dropped. The by-eye check and the first reading are the owner's (Task 9).

## Part 2 · Settings, packages, AWS and storage

- **Package** (question 1): `@aws-sdk/client-s3` 3.1161.0, a devDependency for its types only, installed by the
  owner (Task 1). Nothing in the app.
- **AWS** (the owner's, Task 8): one stack update of `SoulDreamsServer`: a bucket, its policy, one IAM statement, the
  Lambda's code and variable, one output. No new stack, no new account setting.
- **Settings, guards, Swift:** none. `tool/read_feedback.sh` is a `#!/bin/bash` script, a kind G0 already knows.
- **Storage on the phone** (R11): none. The text lives in the field only, and goes when Settings closes.
- **Storage on the server** (docs/workflow.md, "the server's small storage"): one new bucket, empty when made; nothing
  existing changes. The rehearsal is Task 8's checks (before) and Task 9 (a feedback sent, read, gone from the
  bucket). Deletion is the feature (docs/workflow.md (d)): the reading deletes each file from the bucket; the
  lifecycle deletes any unread after 90 days; the owner's copies on his Mac are his to delete at the cohort's review.

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, made from the build that proved it (Part 5). Apply it from
the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit
through the hook with the message given.

Every task ends green:
- Server tasks: `cd server && npm run check && npm test` prints only the check's header, then `ℹ fail 0` at the count
  given; the task's rows: `python3 -I -B tool/server_mutations.py` runs every row (no row selection exists): run it
  once at Task 3's end, expecting `server mutations: 130 run, 130 caught` (about 25 minutes, serial).
- App tasks: `cd app && fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub`
  passes at the count given; the task's rows (D126): `python3 -I -B tool/app_mutations.py --rows <the task's rows>`,
  every one caught.
- The hook prints `guards (staged): all passed`.

### Task 0 · Baselines

From the repository root, on `feedback`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1) ; (cd server && npm run check | tail -1 && npm test 2>&1 | grep -E '^ℹ (tests|fail)')
```

Expected: nothing from `git status`; this plan's commit; `guards (tracked): all passed`; `No issues found!`;
`+765: All tests passed!`; `> tsc -p tsconfig.json`; `ℹ tests 134`, `ℹ fail 0`. Anything else: stop (R14).

### Task 1 · [OWNER] The S3 client, for its types (question 1)

Only after question 1 is answered yes. The sandbox may not install packages (D42 Q13).

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app/server && npm install --save-dev --save-exact --ignore-scripts '@aws-sdk/client-s3@3.1161.0' --no-fund && git diff --stat package.json && npm ls --depth=0 && npm audit
```

Expected:
- `package.json | 1 +`: the line `"@aws-sdk/client-s3": "3.1161.0",` first under `devDependencies`;
- `package-lock.json` gains the client and its own packages (`@aws-sdk/…`, `@smithy/…`, `@aws-crypto/…`); many are
  already there for the SSM client, at the same version;
- `npm ls`: the seven: `@aws-sdk/client-s3@3.1161.0`, `@aws-sdk/client-ssm@3.1161.0`, `@types/node@24.19.2`,
  `aws-cdk-lib@2.275.0`, `aws-cdk@2.1147.0`, `constructs@10.8.1`, `typescript@6.0.3`;
- `npm audit`: the two moderate `minimatch` findings of banked item 45 only. Anything new: stop and bring it to the
  Build chat. Do **not** run `npm audit fix`.

Do not commit: Task 2 commits the two package files with its code. Send back the whole output.

### Task 2 · Server: the door for feedback (D152 items 1 and 3)

New: `src/feedback.ts`, `src/feedback-store.ts`, `test/feedback.test.ts`. Changed: `door.ts`, `handler.ts`,
`safe-log.ts`, and the tests of the door, the handler, the logger, the code folder and the packages. Rows S110 to
S124 new; S12 and S27 follow.

Checks: `npm run check` clean; `ℹ tests 152`, `ℹ fail 0`.

- If `npm run check` fails inside the SDK's own types (`skipLibCheck: false`): stop and bring the error (R14). The
  proof used a stand-in of the two classes (Part 5).
- If the lockfile test finds an install script among the new packages: stop.

Commit, with the owner's `server/package.json` and `server/package-lock.json`:

> Server: POST /feedback keeps the text alone under its UTC day; the S3 client for its types (D152)

**The block:**

~~~~diff
diff --git a/server/src/door.ts b/server/src/door.ts
--- a/server/src/door.ts
+++ b/server/src/door.ts
@@ -1,10 +1,12 @@
-// The front door (head's message 14; D71): a Lambda function URL with no
-// authentication of its own, and the beta key checked here. POST / with
-// the beta key as a bearer token gets a short-lived Soniox key; anything
-// else gets nothing. It reads the method, the path and one header only:
-// never the caller's network address, the body or any other header. It
-// logs codes and numbers only (R3, R4).
+// The front door (head's message 14; D71; D152): a Lambda function URL with
+// no authentication of its own, and the beta key checked here. POST / with
+// the beta key as a bearer token gets a short-lived Soniox key; POST
+// /feedback with it keeps one feedback (feedback.ts); anything else gets
+// nothing. It reads the method, the path and one header, and the body only
+// for feedback, after the key: never the caller's network address or any
+// other header. It logs codes and numbers only (R3, R4).
 import { isBetaKeyShape, sameKey } from './beta-key.ts';
+import { parseFeedback, utcDay } from './feedback.ts';
 import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from './parameter-names.ts';
 import { safeLog } from './safe-log.ts';
 import { SonioxFailure, type TemporaryKey } from './soniox.ts';
@@ -13,6 +15,8 @@ export interface DoorEvent {
   readonly rawPath?: string;
   readonly headers?: Readonly<Record<string, string | undefined>>;
   readonly requestContext?: { readonly http?: { readonly method?: string } };
+  readonly body?: string;
+  readonly isBase64Encoded?: boolean;
 }
 
 export interface Reply {
@@ -25,6 +29,9 @@ export interface DoorDeps {
   /** A SecureString's value, decrypted. */
   readonly readParameter: (name: string) => Promise<string>;
   readonly temporaryKey: (projectKey: string) => Promise<TemporaryKey>;
+  /** Keeps one feedback's text under its UTC day (D152). */
+  readonly keepFeedback: (day: string, text: string) => Promise<void>;
+  readonly now: () => Date;
 }
 
 const BEARER = 'Bearer ';
@@ -41,10 +48,19 @@ export function makeDoor(deps: DoorDeps): (event: DoorEvent) => Promise<Reply> {
 }
 
 async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
-  if (event.requestContext?.http?.method !== 'POST' || event.rawPath !== '/') {
+  const post = event.requestContext?.http?.method === 'POST';
+  const path = event.rawPath;
+  if (!post || (path !== '/' && path !== '/feedback')) {
     safeLog('notFound');
     return { statusCode: 404 };
   }
+  const refused = await checkBetaKey(event, deps);
+  if (refused !== undefined) return refused;
+  return path === '/' ? issueKey(deps) : takeFeedback(event, deps);
+}
+
+// The beta key, by its shape and then by the kept one; undefined when right.
+async function checkBetaKey(event: DoorEvent, deps: DoorDeps): Promise<Reply | undefined> {
   const header = event.headers?.['authorization'];
   const given = header !== undefined && header.startsWith(BEARER) ? header.slice(BEARER.length) : '';
   if (!isBetaKeyShape(given)) {
@@ -52,7 +68,6 @@ async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
     return { statusCode: 401 };
   }
   let betaKey: string;
-  let projectKey: string;
   try {
     betaKey = await deps.readParameter(BETA_KEY_PARAMETER);
   } catch {
@@ -63,6 +78,11 @@ async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
     safeLog('keyRefused');
     return { statusCode: 401 };
   }
+  return undefined;
+}
+
+async function issueKey(deps: DoorDeps): Promise<Reply> {
+  let projectKey: string;
   try {
     projectKey = await deps.readParameter(SONIOX_KEY_PARAMETER);
   } catch {
@@ -83,3 +103,23 @@ async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
     body: JSON.stringify({ key: key.key, expiresAt: key.expiresAt }),
   };
 }
+
+// One feedback (D152): its text alone, under the server's UTC day; 204 when
+// kept, nothing in the reply.
+async function takeFeedback(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
+  const raw = event.body ?? '';
+  const body = event.isBase64Encoded === true ? Buffer.from(raw, 'base64').toString('utf8') : raw;
+  const parsed = parseFeedback(body);
+  if ('refused' in parsed) {
+    safeLog('feedbackRefused', [parsed.refused]);
+    return { statusCode: parsed.refused };
+  }
+  try {
+    await deps.keepFeedback(utcDay(deps.now()), parsed.text);
+  } catch {
+    safeLog('feedbackFailed');
+    return { statusCode: 502 };
+  }
+  safeLog('feedbackKept');
+  return { statusCode: 204 };
+}
diff --git a/server/src/feedback-store.ts b/server/src/feedback-store.ts
new file mode 100644
--- /dev/null
+++ b/server/src/feedback-store.ts
@@ -0,0 +1,38 @@
+// Where feedback is kept (D152 item 1): one object per feedback in the
+// private bucket, named by its UTC day and 128 random bits, holding the
+// text alone: no name, phone, journal, network address or time of day
+// (R3, R4). The S3 client is the one the Lambda runtime carries; the package
+// is a devDependency for its types only, as the SSM client is. A failure
+// carries no message of ours.
+import { randomBytes } from 'node:crypto';
+import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
+import { feedbackKey } from './feedback.ts';
+
+export interface PutInput {
+  readonly Bucket: string;
+  readonly Key: string;
+  readonly Body: string;
+  readonly ContentType: string;
+}
+
+export type Put = (input: PutInput) => Promise<unknown>;
+
+/** Keeps one feedback's text under its day in [bucket], through [put]. */
+export function makeFeedbackStore(
+  bucket: string,
+  put: Put,
+  random: () => Buffer = () => randomBytes(16),
+): (day: string, text: string) => Promise<void> {
+  return async (day, text) => {
+    if (bucket === '') throw new Error('feedback-bucket');
+    await put({ Bucket: bucket, Key: feedbackKey(day, random()), Body: text, ContentType: 'text/plain; charset=utf-8' });
+  };
+}
+
+let client: S3Client | undefined;
+
+/** One object put, in eu-north-1. */
+export const putToS3: Put = (input) => {
+  client ??= new S3Client({ region: 'eu-north-1' });
+  return client.send(new PutObjectCommand({ ...input }));
+};
diff --git a/server/src/feedback.ts b/server/src/feedback.ts
new file mode 100644
--- /dev/null
+++ b/server/src/feedback.ts
@@ -0,0 +1,49 @@
+// Feedback (D110; C18-P's MP·46 to MP·49; D152): what a dreamer sends from
+// Settings, about the app. A request holds one text and nothing else; the
+// day is the server's, in UTC. Nothing here logs or keeps anything.
+
+/** At most this many characters, as a person counts them (D152 item 3). */
+export const FEEDBACK_LIMIT = 2000;
+
+/** A body longer than this is refused before it is read. */
+export const BODY_LIMIT = 65536;
+
+/** The Lambda's one variable: the feedback bucket's name (D152 item 1). */
+export const FEEDBACK_BUCKET_VARIABLE = 'FEEDBACK_BUCKET';
+
+const graphemes = new Intl.Segmenter('en', { granularity: 'grapheme' });
+
+/** The characters in [text] as a person counts them: a family emoji is one. */
+export function characters(text: string): number {
+  let n = 0;
+  for (const _ of graphemes.segment(text)) n++;
+  return n;
+}
+
+export type Parsed = { readonly text: string } | { readonly refused: 400 | 413 };
+
+/** One feedback's text, as sent; or the status that refuses it. */
+export function parseFeedback(body: string): Parsed {
+  if (body.length > BODY_LIMIT) return { refused: 413 };
+  let parsed: unknown;
+  try {
+    parsed = JSON.parse(body);
+  } catch {
+    return { refused: 400 };
+  }
+  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) return { refused: 400 };
+  const text = (parsed as Record<string, unknown>)['text'];
+  if (Object.keys(parsed).length !== 1 || typeof text !== 'string' || text.trim() === '') return { refused: 400 };
+  if (characters(text) > FEEDBACK_LIMIT) return { refused: 413 };
+  return { text };
+}
+
+/** The UTC day of [now], YYYY-MM-DD: all a feedback keeps of when. */
+export function utcDay(now: Date): string {
+  return now.toISOString().slice(0, 10);
+}
+
+/** An object's name: its day, then 128 random bits that name nothing. */
+export function feedbackKey(day: string, random: Buffer): string {
+  return `${day}/${random.toString('hex')}.txt`;
+}
diff --git a/server/src/handler.ts b/server/src/handler.ts
--- a/server/src/handler.ts
+++ b/server/src/handler.ts
@@ -1,11 +1,16 @@
 // The server's one entry point, behind its function URL (head's message
-// 14; D71): the front door (door.ts), wired to Parameter Store and to
-// Soniox. Everything it decides is in door.ts and tested there.
+// 14; D71; D152): the front door (door.ts), wired to Parameter Store, to
+// Soniox and to the feedback bucket. Everything it decides is in door.ts
+// and feedback.ts and tested there.
 import { makeDoor } from './door.ts';
+import { FEEDBACK_BUCKET_VARIABLE } from './feedback.ts';
+import { makeFeedbackStore, putToS3 } from './feedback-store.ts';
 import { readParameter } from './parameters.ts';
 import { requestTemporaryKey } from './soniox.ts';
 
 export const handler = makeDoor({
   readParameter,
   temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
+  keepFeedback: makeFeedbackStore(process.env[FEEDBACK_BUCKET_VARIABLE] ?? '', putToS3),
+  now: () => new Date(),
 });
diff --git a/server/src/safe-log.ts b/server/src/safe-log.ts
--- a/server/src/safe-log.ts
+++ b/server/src/safe-log.ts
@@ -12,6 +12,11 @@ export const LOG_EVENTS = [
   'keyRefused',
   'sonioxKeyFailed',
   'parameterFailed',
+  // Feedback (D152): one kept; one refused (with its status, 400 or 413);
+  // the bucket failing. Never a word of it (R3).
+  'feedbackKept',
+  'feedbackRefused',
+  'feedbackFailed',
 ] as const;
 export type LogEvent = (typeof LOG_EVENTS)[number];
 
diff --git a/server/test/dist.test.ts b/server/test/dist.test.ts
--- a/server/test/dist.test.ts
+++ b/server/test/dist.test.ts
@@ -11,6 +11,8 @@ test('the compiled files and the marker, nothing else', () => {
   assert.deepEqual(files, [
     'beta-key.js',
     'door.js',
+    'feedback-store.js',
+    'feedback.js',
     'handler.js',
     'hosts.js',
     'package.json',
@@ -29,7 +31,7 @@ test('imports end in .js', () => {
   assert.match(readFileSync(new URL('handler.js', CODE), 'utf8'), /from "\.\/door\.js";/);
 });
 
-test("imports: its own files, Node's, and the SSM client only", () => {
+test("imports: its own, Node's, and the two AWS clients", () => {
   const files = readdirSync(CODE).filter((f) => f.endsWith('.js'));
   const outside = new Set<string>();
   for (const file of files) {
@@ -39,5 +41,5 @@ test("imports: its own files, Node's, and the SSM client only", () => {
       if (!from.startsWith('./')) outside.add(from);
     }
   }
-  assert.deepEqual([...outside].sort(), ['@aws-sdk/client-ssm', 'node:crypto']);
+  assert.deepEqual([...outside].sort(), ['@aws-sdk/client-s3', '@aws-sdk/client-ssm', 'node:crypto']);
 });
diff --git a/server/test/door.test.ts b/server/test/door.test.ts
--- a/server/test/door.test.ts
+++ b/server/test/door.test.ts
@@ -1,6 +1,8 @@
-// The front door (head's message 14; D71): POST / with the beta key gets a
-// short-lived Soniox key; anything else gets nothing, with one code. It
-// never touches the caller's address, the body or another header (R3, R4).
+// The front door (head's message 14; D71; D152): POST / with the beta key
+// gets a short-lived Soniox key; POST /feedback with it keeps one feedback;
+// anything else gets nothing, with one code. It never touches the caller's
+// address or another header, and reads a body only for feedback, after the
+// key (R3, R4).
 import assert from 'node:assert/strict';
 import { afterEach, beforeEach, test } from 'node:test';
 import { type DoorDeps, type DoorEvent, makeDoor } from '../src/door.ts';
@@ -24,13 +26,17 @@ afterEach(() => {
   restore();
 });
 
+// Not today's date, so a door that took the clock's own day is caught.
+const NOW = new Date('2025-12-31T23:30:00Z');
+
 interface Calls {
   read: string[];
   soniox: string[];
+  kept: [string, string][];
 }
 
 function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
-  const calls: Calls = { read: [], soniox: [] };
+  const calls: Calls = { read: [], soniox: [], kept: [] };
   return {
     calls,
     deps: {
@@ -42,14 +48,19 @@ function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
         calls.soniox.push(project);
         return ISSUED;
       },
+      keepFeedback: async (day, text) => {
+        calls.kept.push([day, text]);
+      },
+      now: () => NOW,
       ...over,
     },
   };
 }
 
 // A function URL's event in which everything but the method, the path
-// and the authorization header throws when touched.
-function event(method: string, path: string, authorization?: string): DoorEvent {
+// and the authorization header throws when touched; with [body], the body
+// and whether it is base64 may be read too.
+function event(method: string, path: string, authorization?: string, body?: string, base64 = false): DoorEvent {
   const guard = <T extends object>(target: T, allowed: string[]): T =>
     new Proxy(target, {
       get(t, p) {
@@ -63,13 +74,16 @@ function event(method: string, path: string, authorization?: string): DoorEvent
     {
       rawPath: path,
       headers: guard(headers, ['authorization']),
-      body: 'a body',
+      body: body ?? 'a body',
+      isBase64Encoded: base64,
       requestContext: guard({ http: guard({ method, sourceIp: '192.0.2.1' }, ['method']) }, ['http']),
     },
-    ['rawPath', 'headers', 'requestContext'],
+    body === undefined ? ['rawPath', 'headers', 'requestContext'] : ['rawPath', 'headers', 'requestContext', 'body', 'isBase64Encoded'],
   );
 }
 
+const feedback = (text: unknown): string => JSON.stringify({ text });
+
 test('the right key: 200 and a short-lived key, one code', async () => {
   const d = deps();
   const reply = await makeDoor(d.deps)(event('POST', '/', `Bearer ${KEY}`));
@@ -116,6 +130,9 @@ test('another method or path: 404, nothing read', async () => {
     ['POST', '/x'],
     ['PUT', '/'],
     ['POST', ''],
+    ['GET', '/feedback'],
+    ['POST', '/feedback/'],
+    ['POST', '/Feedback'],
   ] as const) {
     const d = deps();
     lines = [];
@@ -174,3 +191,71 @@ test('a failure anywhere else: 500 and a code', async () => {
   assert.deepEqual(await makeDoor(deps().deps)(event('POST', '/', `Bearer ${KEY}`)), { statusCode: 500 });
   assert.deepEqual(lines, ['handlerFailed']);
 });
+
+test('feedback: kept under its UTC day, 204, one code', async () => {
+  const d = deps();
+  const reply = await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, feedback('The app opens slowly.')));
+  assert.deepEqual(reply, { statusCode: 204 });
+  assert.deepEqual(d.calls.kept, [['2025-12-31', 'The app opens slowly.']]);
+  assert.deepEqual(d.calls.read, [BETA_KEY_PARAMETER]);
+  assert.deepEqual(d.calls.soniox, []);
+  assert.deepEqual(lines, ['feedbackKept']);
+});
+
+test('feedback: a base64 body is read as its text', async () => {
+  const d = deps();
+  const body = Buffer.from(feedback('Två rader.'), 'utf8').toString('base64');
+  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, body, true)), { statusCode: 204 });
+  assert.deepEqual(d.calls.kept, [['2025-12-31', 'Två rader.']]);
+});
+
+test('feedback: a bad key refused before the body is read', async () => {
+  for (const authorization of [`Bearer ${KEY.slice(0, 47)}1`, undefined, 'Bearer short']) {
+    const d = deps();
+    lines = [];
+    // A body that throws when read: the key is checked first.
+    const e = event('POST', '/feedback', authorization);
+    assert.deepEqual(await makeDoor(d.deps)(e), { statusCode: 401 });
+    assert.deepEqual(d.calls.kept, []);
+    assert.deepEqual(lines, ['keyRefused']);
+  }
+});
+
+test('feedback: refused, nothing kept, its status logged', async () => {
+  for (const [body, status] of [
+    ['', 400],
+    [feedback(' \n '), 400],
+    ['not json', 400],
+    [JSON.stringify({ text: 'a', day: '2026-11-24' }), 400],
+    [feedback('a'.repeat(2001)), 413],
+  ] as const) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, body)), { statusCode: status });
+    assert.deepEqual(d.calls.kept, []);
+    assert.deepEqual(lines, [`feedbackRefused ${status}`]);
+  }
+});
+
+test('feedback: the store failing: 502 and a code', async () => {
+  const d = deps({
+    keepFeedback: async () => {
+      throw new Error('invented failure text');
+    },
+  });
+  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, feedback('The app opens slowly.'))), {
+    statusCode: 502,
+  });
+  assert.deepEqual(lines, ['feedbackFailed']);
+});
+
+test('feedback: Parameter Store failing: 500, nothing kept', async () => {
+  const d = deps({
+    readParameter: async () => {
+      throw new Error('invented failure text');
+    },
+  });
+  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/feedback', `Bearer ${KEY}`, feedback('a'))), { statusCode: 500 });
+  assert.deepEqual(d.calls.kept, []);
+  assert.deepEqual(lines, ['parameterFailed']);
+});
diff --git a/server/test/feedback.test.ts b/server/test/feedback.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/feedback.test.ts
@@ -0,0 +1,118 @@
+// Feedback (D152): what a request may hold, the UTC day, an object's name,
+// and what is put in the bucket: the text alone, nothing else (R3, R4).
+import assert from 'node:assert/strict';
+import { test } from 'node:test';
+import {
+  BODY_LIMIT,
+  FEEDBACK_BUCKET_VARIABLE,
+  FEEDBACK_LIMIT,
+  characters,
+  feedbackKey,
+  parseFeedback,
+  utcDay,
+} from '../src/feedback.ts';
+import { makeFeedbackStore, type PutInput } from '../src/feedback-store.ts';
+
+const body = (text: unknown): string => JSON.stringify({ text });
+
+test('at most 2,000 characters, as a person counts them', () => {
+  assert.equal(FEEDBACK_LIMIT, 2000);
+  assert.equal(characters('abc'), 3);
+  // One family emoji is one character, though eight UTF-16 units.
+  assert.equal(characters('👨‍👩‍👧'), 1);
+  assert.equal(characters('é'), 1);
+  assert.equal(characters(''), 0);
+});
+
+test('one text: kept as sent, spaces and all', () => {
+  assert.deepEqual(parseFeedback(body('The app opens slowly.')), { text: 'The app opens slowly.' });
+  assert.deepEqual(parseFeedback(body('  Two\nlines  ')), { text: '  Two\nlines  ' });
+});
+
+test('exactly 2,000 characters kept; one more refused', () => {
+  assert.deepEqual(parseFeedback(body('a'.repeat(2000))), { text: 'a'.repeat(2000) });
+  assert.deepEqual(parseFeedback(body('a'.repeat(2001))), { refused: 413 });
+  const family = '👨‍👩‍👧'.repeat(2000);
+  assert.deepEqual(parseFeedback(body(family)), { text: family });
+  assert.deepEqual(parseFeedback(body(`${family}a`)), { refused: 413 });
+});
+
+test('a body too long is refused before it is read', () => {
+  assert.equal(BODY_LIMIT, 65536);
+  assert.deepEqual(parseFeedback(`${body('a')}${' '.repeat(BODY_LIMIT)}`), { refused: 413 });
+  assert.deepEqual(parseFeedback(`{${' '.repeat(BODY_LIMIT)}`), { refused: 413 });
+});
+
+test('empty, blank, not JSON or not one text: refused', () => {
+  for (const given of [
+    '',
+    'text',
+    '[]',
+    'null',
+    '"a text"',
+    body(''),
+    body(' \n\t '),
+    body(3),
+    body(null),
+    JSON.stringify({}),
+    JSON.stringify({ text: 'a', day: '2026-11-24' }),
+    JSON.stringify({ words: 'a' }),
+  ]) {
+    assert.deepEqual(parseFeedback(given), { refused: 400 }, given);
+  }
+});
+
+test('the UTC day, whatever the hour', () => {
+  assert.equal(utcDay(new Date('2026-11-24T00:00:00Z')), '2026-11-24');
+  assert.equal(utcDay(new Date('2026-11-24T23:59:59.999Z')), '2026-11-24');
+  assert.equal(utcDay(new Date('2026-11-25T00:30:00+01:00')), '2026-11-24');
+});
+
+test("an object's name: its day, then 128 random bits, nothing else", () => {
+  assert.equal(feedbackKey('2026-11-24', Buffer.alloc(16, 0xab)), `2026-11-24/${'ab'.repeat(16)}.txt`);
+});
+
+test('the store puts the text alone, as text, under its day', async () => {
+  const puts: PutInput[] = [];
+  const keep = makeFeedbackStore(
+    'a-bucket',
+    async (input) => {
+      puts.push(input);
+    },
+    () => Buffer.alloc(16, 1),
+  );
+  await keep('2026-11-24', 'The app opens slowly.');
+  assert.deepEqual(puts, [
+    {
+      Bucket: 'a-bucket',
+      Key: `2026-11-24/${'01'.repeat(16)}.txt`,
+      Body: 'The app opens slowly.',
+      ContentType: 'text/plain; charset=utf-8',
+    },
+  ]);
+});
+
+test('each feedback its own random name', async () => {
+  const keys: string[] = [];
+  const keep = makeFeedbackStore('a-bucket', async (input) => {
+    keys.push(input.Key);
+  });
+  await keep('2026-11-24', 'one');
+  await keep('2026-11-24', 'two');
+  assert.equal(keys.length, 2);
+  assert.notEqual(keys[0], keys[1]);
+  for (const key of keys) assert.match(key, /^2026-11-24\/[0-9a-f]{32}\.txt$/);
+});
+
+test('no bucket named: nothing put, a bare failure', async () => {
+  let called = false;
+  const keep = makeFeedbackStore('', async () => {
+    called = true;
+  });
+  await assert.rejects(keep('2026-11-24', 'The app opens slowly.'), { message: 'feedback-bucket' });
+  assert.equal(called, false);
+});
+
+test("the bucket's name reaches the Lambda in one variable", () => {
+  assert.equal(FEEDBACK_BUCKET_VARIABLE, 'FEEDBACK_BUCKET');
+});
diff --git a/server/test/handler.test.ts b/server/test/handler.test.ts
--- a/server/test/handler.test.ts
+++ b/server/test/handler.test.ts
@@ -33,3 +33,14 @@ test('a misshapen key: 401 before anything is read', async () => {
   assert.deepEqual(reply, { statusCode: 401 });
   assert.deepEqual(lines, ['keyRefused']);
 });
+
+test('feedback with a misshapen key: 401, nothing read or kept', async () => {
+  const reply = await handler({
+    rawPath: '/feedback',
+    headers: { authorization: 'Bearer short' },
+    body: JSON.stringify({ text: 'a' }),
+    requestContext: { http: { method: 'POST' } },
+  });
+  assert.deepEqual(reply, { statusCode: 401 });
+  assert.deepEqual(lines, ['keyRefused']);
+});
diff --git a/server/test/package.test.ts b/server/test/package.test.ts
--- a/server/test/package.test.ts
+++ b/server/test/package.test.ts
@@ -1,6 +1,6 @@
-// The server's packages (D41; D42 Q1, Q14; D71 Q13): the six named, at
-// exact versions, for development only (the SSM client for its types:
-// the Lambda runtime carries its own), none running a script when installed,
+// The server's packages (D41; D42 Q1, Q14; D71 Q13; D152): the seven named,
+// at exact versions, for development only (the S3 and SSM clients for their
+// types: the Lambda runtime carries its own), none running a script when installed,
 // on Node 24. The owner installs them (D41); the lockfile records it.
 import assert from 'node:assert/strict';
 import { readFileSync } from 'node:fs';
@@ -13,6 +13,7 @@ function read(name: string): Json {
 }
 
 const PACKAGES = {
+  '@aws-sdk/client-s3': '3.1161.0',
   '@aws-sdk/client-ssm': '3.1161.0',
   '@types/node': '24.19.2',
   'aws-cdk': '2.1147.0',
@@ -21,7 +22,7 @@ const PACKAGES = {
   typescript: '6.0.3',
 };
 
-test('the six packages, exact, for development only', () => {
+test('the seven packages, exact, for development only', () => {
   const pkg = read('package.json');
   assert.deepEqual(pkg['devDependencies'], PACKAGES);
   assert.equal(pkg['dependencies'], undefined);
diff --git a/server/test/safe-log.test.ts b/server/test/safe-log.test.ts
--- a/server/test/safe-log.test.ts
+++ b/server/test/safe-log.test.ts
@@ -24,6 +24,9 @@ test('the events are these', () => {
     'keyRefused',
     'sonioxKeyFailed',
     'parameterFailed',
+    'feedbackKept',
+    'feedbackRefused',
+    'feedbackFailed',
   ]);
 });
 
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147; S110 to S124, D152), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -47,7 +47,7 @@ ROWS = [
     ('S11', 'cdk.json', '"notices": false', '"notices": true',
      'test', 'cdk.json switches off the three reports'),
     ('S12', 'package.json', '"aws-cdk-lib": "2.275.0"', '"aws-cdk-lib": "^2.275.0"',
-     'test', 'the six packages, exact, for development only'),
+     'test', 'the seven packages, exact, for development only'),
     ('S13', 'infra/stack.ts', '    const url = fn.addFunctionUrl(',
      "    new logs.LogGroup(this, 'Extra');\n    const url = fn.addFunctionUrl(",
      'test', 'these resources and no others'),
@@ -87,8 +87,8 @@ ROWS = [
      'test', 'the comparison hashes both keys and takes the same time'),
     ('S26', 'src/door.ts', '  if (!isBetaKeyShape(given)) {', "  if (!isBetaKeyShape(given) && given === '') {",
      'test', 'a misshapen key is refused before anything is read'),
-    ('S27', 'src/door.ts', "  if (event.requestContext?.http?.method !== 'POST'",
-     "  if (JSON.stringify(event) === '' || event.requestContext?.http?.method !== 'POST'",
+    ('S27', 'src/door.ts', "  const post = event.requestContext?.http?.method === 'POST';",
+     "  const post = JSON.stringify(event) !== '' && event.requestContext?.http?.method === 'POST';",
      'test', 'the right key: 200 and a short-lived key, one code'),
     ('S28', 'src/door.ts', '  if (!sameKey(given, betaKey)) {', '  if (!sameKey(given, betaKey) && false) {',
      'test', 'a wrong, missing or misshapen key: 401, Soniox never asked'),
@@ -334,6 +334,39 @@ ROWS = [
     ('S109', 'trial/curated.ts',
      "  } catch {\n    throw new Error('curated-profile');\n  }\n  await run(", '  } catch {\n    icc = Buffer.alloc(0);\n  }\n  await run(',
      'test', 'sipsConvert: a missing or false profile stops early'),
+    # Feedback (D152): what a request may hold, the day, the object, the door.
+    ('S110', 'src/feedback.ts', 'export const FEEDBACK_LIMIT = 2000;', 'export const FEEDBACK_LIMIT = 2001;',
+     'test', 'exactly 2,000 characters kept; one more refused'),
+    ('S111', 'src/feedback.ts', "granularity: 'grapheme'", "granularity: 'word'",
+     'test', 'at most 2,000 characters, as a person counts them'),
+    ('S112', 'src/feedback.ts', "text.trim() === ''", "text === ''",
+     'test', 'empty, blank, not JSON or not one text: refused'),
+    ('S113', 'src/feedback.ts', 'Object.keys(parsed).length !== 1 || ', '',
+     'test', 'empty, blank, not JSON or not one text: refused'),
+    ('S114', 'src/feedback.ts', '  if (body.length > BODY_LIMIT) return { refused: 413 };\n', '',
+     'test', 'a body too long is refused before it is read'),
+    ('S115', 'src/feedback.ts', 'now.toISOString().slice(0, 10)', 'now.toISOString().slice(0, 13)',
+     'test', 'the UTC day, whatever the hour'),
+    ('S116', 'src/feedback-store.ts', "    if (bucket === '') throw new Error('feedback-bucket');\n", '',
+     'test', 'no bucket named: nothing put, a bare failure'),
+    ('S117', 'src/feedback-store.ts', 'Body: text,', 'Body: `${day} ${text}`,',
+     'test', 'the store puts the text alone, as text, under its day'),
+    ('S118', 'src/feedback-store.ts', 'randomBytes(16)', 'randomBytes(4)',
+     'test', 'each feedback its own random name'),
+    ('S119', 'src/door.ts', 'if (refused !== undefined) return refused;',
+     "if (refused && path === '/') return refused;",
+     'test', 'feedback: a bad key refused before the body is read'),
+    ('S120', 'src/door.ts', 'event.isBase64Encoded === true ?', 'false ?',
+     'test', 'feedback: a base64 body is read as its text'),
+    ('S121', 'src/door.ts', "    safeLog('feedbackFailed');\n    return { statusCode: 502 };",
+     "    safeLog('feedbackKept');\n    return { statusCode: 204 };",
+     'test', 'feedback: the store failing: 502 and a code'),
+    ('S122', 'src/door.ts', "safeLog('feedbackRefused', [parsed.refused]);", "safeLog('feedbackRefused');",
+     'test', 'feedback: refused, nothing kept, its status logged'),
+    ('S123', 'src/door.ts', "path !== '/feedback')", "!(path ?? '').startsWith('/feedback'))",
+     'test', 'another method or path: 404, nothing read'),
+    ('S124', 'src/door.ts', 'utcDay(deps.now())', 'utcDay(new Date())',
+     'test', 'feedback: kept under its UTC day, 204, one code'),
 ]
 
 
~~~~

### Task 3 · Server: the feedback bucket in the stack (D152 item 1)

Changed: `infra/stack.ts`, `test/stack.test.ts`. Rows S125 to S135 new; S8, S14, S21 and S22 follow the renamed tests.

Checks: `npm run check` clean; `ℹ tests 154`, `ℹ fail 0`; then the server's rows, all of them (the tool has no
selection): `python3 -I -B tool/server_mutations.py | tail -1` prints `server mutations: 130 run, 130 caught`.

Commit:

> Server: the private feedback bucket, put-only for the Lambda, 90 days, TLS only (D152)

**The block:**

~~~~diff
diff --git a/server/infra/stack.ts b/server/infra/stack.ts
--- a/server/infra/stack.ts
+++ b/server/infra/stack.ts
@@ -1,15 +1,25 @@
-// The server's AWS infrastructure (D41, D42; head's message 14; D71): one
-// Lambda in eu-north-1 behind its own function URL, with no
+// The server's AWS infrastructure (D41, D42; head's message 14; D71; D152):
+// one Lambda in eu-north-1 behind its own function URL, with no
 // authentication of the URL's own (the beta key is checked in the code),
-// its logs kept 7 days, with no access logs, no tracing, no environment
-// and no identifier. It reads two SecureStrings the owner makes, and
-// nothing else. No reserved concurrency yet (D71 Q12: the account's
-// quota must allow it first; a first-deploy checklist line returns it).
+// its logs kept 7 days, with no access logs, no tracing and no identifier;
+// its one variable is the feedback bucket's name. It reads two SecureStrings
+// the owner makes, and puts feedback in its bucket, and nothing else. No
+// reserved concurrency yet (D71 Q12: the account's quota must allow it
+// first; a first-deploy checklist line returns it).
+//
+// The feedback bucket (D152 item 1): private (every public access blocked,
+// no ACLs, TLS only), encrypted by S3 (SSE-S3), unversioned so a deletion is
+// whole, each object deleted 90 days after it was put, with no access logs,
+// inventory, replication or notification. The Lambda may only put objects;
+// the owner reads and deletes them with tool/read_feedback.sh. The bucket is
+// kept if the stack is ever removed, its 90 days still running.
 import { CfnOutput, Duration, RemovalPolicy, Stack } from 'aws-cdk-lib';
 import * as iam from 'aws-cdk-lib/aws-iam';
 import * as lambda from 'aws-cdk-lib/aws-lambda';
 import * as logs from 'aws-cdk-lib/aws-logs';
+import * as s3 from 'aws-cdk-lib/aws-s3';
 import type { Construct } from 'constructs';
+import { FEEDBACK_BUCKET_VARIABLE } from '../src/feedback.ts';
 import { PARAMETERS } from '../src/parameter-names.ts';
 
 export const REGION = 'eu-north-1';
@@ -55,6 +65,19 @@ export class ServerStack extends Stack {
         conditions: { StringEquals: { 'kms:ViaService': `ssm.${REGION}.amazonaws.com` } },
       }),
     );
+    const feedback = new s3.Bucket(this, 'Feedback', {
+      encryption: s3.BucketEncryption.S3_MANAGED,
+      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
+      objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_ENFORCED,
+      enforceSSL: true,
+      versioned: false,
+      lifecycleRules: [{ expiration: Duration.days(90) }],
+      removalPolicy: RemovalPolicy.RETAIN,
+    });
+    // Putting feedback, and nothing else: no read, list or delete.
+    role.addToPrincipalPolicy(
+      new iam.PolicyStatement({ actions: ['s3:PutObject'], resources: [feedback.arnForObjects('*')] }),
+    );
     const fn = new lambda.Function(this, 'Handler', {
       runtime: lambda.Runtime.NODEJS_24_X,
       architecture: lambda.Architecture.ARM_64,
@@ -65,11 +88,14 @@ export class ServerStack extends Stack {
       loggingFormat: lambda.LoggingFormat.JSON,
       applicationLogLevelV2: lambda.ApplicationLogLevel.INFO,
       systemLogLevelV2: lambda.SystemLogLevel.WARN,
-      // A cold start, then Parameter Store, then Soniox (D71 Q20).
+      // A cold start, then Parameter Store, then Soniox or S3 (D71 Q20).
       timeout: Duration.seconds(10),
+      environment: { [FEEDBACK_BUCKET_VARIABLE]: feedback.bucketName },
     });
     const url = fn.addFunctionUrl({ authType: lambda.FunctionUrlAuthType.NONE });
     // The owner reads the address after the deploy, for app/lib/core/hosts.dart.
     new CfnOutput(this, 'Url', { value: url.url });
+    // The owner's reading command finds the bucket by this (tool/read_feedback.sh).
+    new CfnOutput(this, 'FeedbackBucket', { value: feedback.bucketName });
   }
 }
diff --git a/server/test/stack.test.ts b/server/test/stack.test.ts
--- a/server/test/stack.test.ts
+++ b/server/test/stack.test.ts
@@ -34,6 +34,8 @@ test('these resources and no others', () => {
     'AWS::Lambda::Permission',
     'AWS::Lambda::Url',
     'AWS::Logs::LogGroup',
+    'AWS::S3::Bucket',
+    'AWS::S3::BucketPolicy',
   ]);
 });
 
@@ -75,12 +77,53 @@ test('logs: 7 days, JSON, application INFO, system WARN', () => {
   });
 });
 
-test('no environment, no tracing', () => {
+test("one variable, the feedback bucket's name; no tracing", () => {
   const props = only('AWS::Lambda::Function').Properties ?? {};
-  assert.equal(props['Environment'], undefined);
+  assert.deepEqual(props['Environment'], {
+    Variables: { FEEDBACK_BUCKET: { Ref: Object.keys(template.findResources('AWS::S3::Bucket'))[0] } },
+  });
   assert.equal(props['TracingConfig'], undefined);
 });
 
+test('the feedback bucket: private, encrypted, unversioned, 90 days, kept', () => {
+  const [bucket] = Object.values(template.findResources('AWS::S3::Bucket')) as Resource[];
+  assert.deepEqual(bucket, {
+    Type: 'AWS::S3::Bucket',
+    Properties: {
+      BucketEncryption: { ServerSideEncryptionConfiguration: [{ ServerSideEncryptionByDefault: { SSEAlgorithm: 'AES256' } }] },
+      LifecycleConfiguration: { Rules: [{ ExpirationInDays: 90, Status: 'Enabled' }] },
+      OwnershipControls: { Rules: [{ ObjectOwnership: 'BucketOwnerEnforced' }] },
+      PublicAccessBlockConfiguration: {
+        BlockPublicAcls: true,
+        BlockPublicPolicy: true,
+        IgnorePublicAcls: true,
+        RestrictPublicBuckets: true,
+      },
+    },
+    UpdateReplacePolicy: 'Retain',
+    DeletionPolicy: 'Retain',
+  });
+});
+
+test('the feedback bucket refuses any request not over TLS', () => {
+  const name = Object.keys(template.findResources('AWS::S3::Bucket'))[0] ?? '';
+  const ref = { 'Fn::GetAtt': [name, 'Arn'] };
+  template.hasResourceProperties('AWS::S3::BucketPolicy', {
+    Bucket: { Ref: name },
+    PolicyDocument: {
+      Statement: [
+        {
+          Action: 's3:*',
+          Condition: { Bool: { 'aws:SecureTransport': 'false' } },
+          Effect: 'Deny',
+          Principal: { AWS: '*' },
+          Resource: [ref, { 'Fn::Join': ['', [ref, '/*']] }],
+        },
+      ],
+    },
+  });
+});
+
 test('one function URL: no authentication of its own, no CORS', () => {
   const url = only('AWS::Lambda::Url').Properties ?? {};
   assert.deepEqual(Object.keys(url).sort(), ['AuthType', 'TargetFunctionArn']);
@@ -112,13 +155,14 @@ test('anyone may call it, through the URL only', () => {
   });
 });
 
-test("one output, the URL's address", () => {
+test("two outputs: the URL and the feedback bucket", () => {
   const outputs = template.toJSON()['Outputs'] as Record<string, unknown>;
-  assert.deepEqual(Object.keys(outputs), ['Url']);
+  assert.deepEqual(Object.keys(outputs), ['Url', 'FeedbackBucket']);
+  template.hasOutput('FeedbackBucket', { Value: { Ref: Match.stringLikeRegexp('^Feedback') } });
   template.hasOutput('Url', { Value: { 'Fn::GetAtt': [Match.stringLikeRegexp('^HandlerFunctionUrl'), 'FunctionUrl'] } });
 });
 
-test('the role: its own log group, and the two keys only', () => {
+test('the role: its log group, the two keys, putting feedback', () => {
   assert.equal(only('AWS::IAM::Role').Properties?.['ManagedPolicyArns'], undefined);
   // No inline policy on the role either (D44 a).
   assert.equal(only('AWS::IAM::Role').Properties?.['Policies'], undefined);
@@ -148,6 +192,13 @@ test('the role: its own log group, and the two keys only', () => {
             'Fn::Join': ['', ['arn:', { Ref: 'AWS::Partition' }, ':kms:eu-north-1:', { Ref: 'AWS::AccountId' }, ':key/*']],
           },
         },
+        {
+          Action: 's3:PutObject',
+          Effect: 'Allow',
+          Resource: {
+            'Fn::Join': ['', [{ 'Fn::GetAtt': [Match.stringLikeRegexp('^Feedback'), 'Arn'] }, '/*']],
+          },
+        },
       ],
     },
   });
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147; S110 to S124, D152), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147; S110 to S135, D152), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -38,7 +38,7 @@ ROWS = [
     ('S7', 'infra/stack.ts', 'RetentionDays.ONE_WEEK', 'RetentionDays.ONE_MONTH',
      'test', 'logs: 7 days, JSON, application INFO, system WARN'),
     ('S8', 'infra/stack.ts', '      role,\n', '',
-     'test', 'the role: its own log group, and the two keys only'),
+     'test', 'the role: its log group, the two keys, putting feedback'),
     ('S9', 'infra/account.ts', '  if (wanted !== resolved) {',
      '  if (wanted !== resolved && wanted !== undefined) {',
      'test', 'none passed, or another: refused'),
@@ -56,7 +56,7 @@ ROWS = [
      "      assumedBy: new iam.ServicePrincipal('lambda.amazonaws.com'),\n"
      "      inlinePolicies: { x: new iam.PolicyDocument({ statements: ["
      "new iam.PolicyStatement({ actions: ['logs:*'], resources: ['*'] })] }) },\n",
-     'test', 'the role: its own log group, and the two keys only'),
+     'test', 'the role: its log group, the two keys, putting feedback'),
     ('S15', 'infra/stack.ts', '      logGroup,\n',
      "      logGroup: logs.LogGroup.fromLogGroupName(this, 'Old', 'kept'),\n",
      'test', 'logs: 7 days, JSON, application INFO, system WARN'),
@@ -75,9 +75,9 @@ ROWS = [
      'test', 'Node 24 on arm64, its own handler, 10 seconds'),
     ('S21', 'infra/stack.ts',
      "        conditions: { StringEquals: { 'kms:ViaService': `ssm.${REGION}.amazonaws.com` } },\n", '',
-     'test', 'the role: its own log group, and the two keys only'),
+     'test', 'the role: its log group, the two keys, putting feedback'),
     ('S22', 'infra/stack.ts', "    new CfnOutput(this, 'Url', { value: url.url });", '    void url;',
-     'test', "one output, the URL's address"),
+     'test', "two outputs: the URL and the feedback bucket"),
     ('S23', 'src/soniox.ts', '  max_session_duration_seconds: 1800,\n',
      "  max_session_duration_seconds: 1800,\n  context: 'x',\n",
      'test', 'exactly these four fields and no other (R4)'),
@@ -367,6 +367,30 @@ ROWS = [
      'test', 'another method or path: 404, nothing read'),
     ('S124', 'src/door.ts', 'utcDay(deps.now())', 'utcDay(new Date())',
      'test', 'feedback: kept under its UTC day, 204, one code'),
+    # The feedback bucket in the stack (D152 item 1).
+    ('S125', 'infra/stack.ts', 'expiration: Duration.days(90)', 'expiration: Duration.days(30)',
+     'test', 'the feedback bucket: private, encrypted, unversioned, 90 days, kept'),
+    ('S126', 'infra/stack.ts', '      versioned: false,', '      versioned: true,',
+     'test', 'the feedback bucket: private, encrypted, unversioned, 90 days, kept'),
+    ('S127', 'infra/stack.ts', '      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,\n', '',
+     'test', 'the feedback bucket: private, encrypted, unversioned, 90 days, kept'),
+    ('S128', 'infra/stack.ts', '      removalPolicy: RemovalPolicy.RETAIN,', '      removalPolicy: RemovalPolicy.DESTROY,',
+     'test', 'the feedback bucket: private, encrypted, unversioned, 90 days, kept'),
+    ('S129', 'infra/stack.ts', 's3.BucketEncryption.S3_MANAGED', 's3.BucketEncryption.KMS_MANAGED',
+     'test', 'the feedback bucket: private, encrypted, unversioned, 90 days, kept'),
+    ('S130', 'infra/stack.ts', '      enforceSSL: true,\n', '',
+     'test', 'the feedback bucket refuses any request not over TLS'),
+    ('S131', 'infra/stack.ts', "actions: ['s3:PutObject']", "actions: ['s3:PutObject', 's3:GetObject']",
+     'test', 'the role: its log group, the two keys, putting feedback'),
+    ('S132', 'infra/stack.ts', "resources: [feedback.arnForObjects('*')]",
+     "resources: [feedback.bucketArn, feedback.arnForObjects('*')]",
+     'test', 'the role: its log group, the two keys, putting feedback'),
+    ('S133', 'infra/stack.ts', '      environment: { [FEEDBACK_BUCKET_VARIABLE]: feedback.bucketName },\n', '',
+     'test', "one variable, the feedback bucket's name; no tracing"),
+    ('S134', 'infra/stack.ts', "    new CfnOutput(this, 'FeedbackBucket', { value: feedback.bucketName });\n", '',
+     'test', 'two outputs: the URL and the feedback bucket'),
+    ('S135', 'infra/stack.ts', '      objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_ENFORCED,\n', '',
+     'test', 'the feedback bucket: private, encrypted, unversioned, 90 days, kept'),
 ]
 
 
~~~~

### Task 4 · The reading command (D152 item 2)

New: `tool/read_feedback.sh` (executable) and its test.

Checks: `python3 -I -B tool/checks/tests/run_tests.py test_read_feedback | tail -1` prints `OK` (8 tests); then
`python3 -I -B tool/checks/tests/run_tests.py | tail -1` prints `OK`.

Commit:

> tool/read_feedback.sh: the owner's reading moves feedback to his Mac, dated to its day (D152)

**The block:**

~~~~diff
diff --git a/tool/checks/tests/test_read_feedback.py b/tool/checks/tests/test_read_feedback.py
new file mode 100644
--- /dev/null
+++ b/tool/checks/tests/test_read_feedback.py
@@ -0,0 +1,116 @@
+# tool/read_feedback.sh, the owner's reading of the feedback (D152 item 2),
+# run against a stand-in `aws` that records what it is asked and plays the
+# bucket: the stack's output names the bucket, `s3 mv` moves every object
+# into the folder by its day, each file then dated to its day's start, and
+# only counts are printed. No real AWS is reached.
+import os
+import stat
+import subprocess
+import tempfile
+import time
+import unittest
+
+from helpers import CHECKS
+
+SCRIPT = os.path.join(os.path.dirname(os.path.dirname(CHECKS)), 'tool', 'read_feedback.sh')
+
+FAKE = '\n'.join((
+    '#!/bin/bash',
+    'printf \'%s\\n\' "$*" >> "$CALLS"',
+    'case "$1" in',
+    '  cloudformation) printf \'%s\\n\' "$BUCKET"; exit "${CF_EXIT:-0}" ;;',
+    '  s3)',
+    '    [ -n "${MV_EXIT:-}" ] && exit "$MV_EXIT"',
+    '    dest="$4"',
+    '    mkdir -p "$dest/2026-11-24" "$dest/2026-11-25"',
+    '    printf \'one\' > "$dest/2026-11-24/$(printf \'a%.0s\' {1..32}).txt"',
+    '    printf \'two\' > "$dest/2026-11-25/$(printf \'b%.0s\' {1..32}).txt"',
+    '    exit 0 ;;',
+    'esac',
+    'exit 9',
+    '',
+))
+
+
+class ReadFeedback(unittest.TestCase):
+    def run_script(self, args, bucket='souldreamsserver-feedbacka1b2-c3d4', earlier=False, **env):
+        root = tempfile.mkdtemp(prefix='read-feedback-')
+        bin_dir = os.path.join(root, 'bin')
+        os.mkdir(bin_dir)
+        fake = os.path.join(bin_dir, 'aws')
+        with open(fake, 'w', encoding='utf-8') as f:
+            f.write(FAKE)
+        os.chmod(fake, stat.S_IRWXU)
+        calls = os.path.join(root, 'calls')
+        dest = os.path.join(root, 'feedback')
+        if earlier:
+            os.makedirs(os.path.join(dest, '2026-11-01'))
+            with open(os.path.join(dest, '2026-11-01', 'c' * 32 + '.txt'), 'w', encoding='utf-8') as f:
+                f.write('read before')
+        full = {'PATH': bin_dir + os.pathsep + '/usr/bin:/bin', 'HOME': root, 'CALLS': calls,
+                'BUCKET': bucket, 'SOULDREAMS_FEEDBACK': dest}
+        full.update(env)
+        out = subprocess.run(['/bin/bash', SCRIPT] + args, env=full, capture_output=True, text=True)
+        lines = open(calls, encoding='utf-8').read().splitlines() if os.path.exists(calls) else []
+        return out, lines, dest
+
+    def test_moves_every_feedback_to_the_folder_by_its_day(self):
+        out, calls, dest = self.run_script(['workload'])
+        self.assertEqual(out.returncode, 0, out.stderr)
+        self.assertEqual(calls, [
+            'cloudformation describe-stacks --stack-name SoulDreamsServer --region eu-north-1 --profile workload '
+            "--query Stacks[0].Outputs[?OutputKey=='FeedbackBucket'].OutputValue --output text",
+            's3 mv s3://souldreamsserver-feedbacka1b2-c3d4/ ' + dest + '/ --recursive --region eu-north-1 '
+            '--profile workload --only-show-errors',
+        ])
+        self.assertEqual(out.stdout, 'read-feedback: 2 new, 2 in ' + dest + '\n')
+        self.assertEqual(out.stderr, '')
+
+    def test_feedback_read_before_stays_and_is_not_counted_new(self):
+        out, _, dest = self.run_script(['workload'], earlier=True)
+        self.assertEqual(out.returncode, 0, out.stderr)
+        self.assertEqual(out.stdout, 'read-feedback: 2 new, 3 in ' + dest + '\n')
+
+    def test_the_folder_is_the_owners_alone(self):
+        _, _, dest = self.run_script(['workload'])
+        self.assertEqual(stat.S_IMODE(os.stat(dest).st_mode), 0o700)
+
+    def test_each_file_dated_to_its_days_start(self):
+        _, _, dest = self.run_script(['workload'])
+        for day in ('2026-11-24', '2026-11-25'):
+            folder = os.path.join(dest, day)
+            (name,) = os.listdir(folder)
+            want = time.mktime(time.strptime(day, '%Y-%m-%d'))
+            self.assertEqual(os.stat(os.path.join(folder, name)).st_mtime, want, day)
+
+    def test_the_default_folder_is_in_home_outside_the_repository(self):
+        out, calls, dest = self.run_script(['workload'], SOULDREAMS_FEEDBACK='')
+        self.assertEqual(out.returncode, 0, out.stderr)
+        home = os.path.dirname(dest)
+        self.assertIn(' ' + os.path.join(home, 'SoulDreams-feedback') + '/ --recursive', calls[1])
+        self.assertTrue(os.path.isdir(os.path.join(home, 'SoulDreams-feedback', '2026-11-24')))
+
+    def test_no_profile_named_nothing_asked(self):
+        out, calls, _ = self.run_script([])
+        self.assertEqual(out.returncode, 2)
+        self.assertEqual(calls, [])
+
+    def test_no_bucket_found_nothing_moved(self):
+        for bucket in ('None', ''):
+            out, calls, dest = self.run_script(['workload'], bucket=bucket)
+            self.assertEqual(out.returncode, 1, bucket)
+            self.assertEqual(len(calls), 1, bucket)
+            self.assertFalse(os.path.exists(dest), bucket)
+
+    def test_a_failure_stops_with_its_status(self):
+        out, calls, _ = self.run_script(['workload'], CF_EXIT='254')
+        self.assertNotEqual(out.returncode, 0)
+        self.assertEqual(len(calls), 1)
+        out, calls, _ = self.run_script(['workload'], MV_EXIT='1')
+        self.assertEqual(out.returncode, 1)
+        self.assertEqual(len(calls), 2)
+        self.assertNotIn('read-feedback:', out.stdout)
+
+
+if __name__ == '__main__':
+    unittest.main()
diff --git a/tool/read_feedback.sh b/tool/read_feedback.sh
new file mode 100755
--- /dev/null
+++ b/tool/read_feedback.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+# The owner's reading of the feedback (D152 item 2), on his Mac with his AWS
+# profile: every feedback in the bucket is moved into a folder of his own,
+# ~/SoulDreams-feedback/<UTC day>/ (outside the repository and any synced
+# folder), each object deleted from the bucket only after its own download
+# (`aws s3 mv`), and each file then dated to its day's start, so the Mac keeps
+# no time of day for it. It prints counts only, never a word of feedback.
+# Usage: tool/read_feedback.sh <profile>
+set -euo pipefail
+profile=${1:-}
+if [ -z "$profile" ]; then
+  echo 'usage: tool/read_feedback.sh <profile>' >&2
+  exit 2
+fi
+dest=${SOULDREAMS_FEEDBACK:-$HOME/SoulDreams-feedback}
+region=eu-north-1
+bucket=$(aws cloudformation describe-stacks --stack-name SoulDreamsServer --region "$region" --profile "$profile" \
+  --query "Stacks[0].Outputs[?OutputKey=='FeedbackBucket'].OutputValue" --output text)
+if [ -z "$bucket" ] || [ "$bucket" = None ]; then
+  echo 'read-feedback: no FeedbackBucket output on SoulDreamsServer' >&2
+  exit 1
+fi
+count() { find "$dest" -type f -name '*.txt' | wc -l | tr -d ' '; }
+mkdir -p "$dest"
+chmod 700 "$dest"
+before=$(count)
+aws s3 mv "s3://$bucket/" "$dest/" --recursive --region "$region" --profile "$profile" --only-show-errors
+for folder in "$dest"/*/; do
+  day=$(basename "$folder")
+  if [[ $day =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
+    find "$folder" -type f -name '*.txt' -exec touch -t "${day//-/}0000" {} +
+  fi
+done
+after=$(count)
+echo "read-feedback: $((after - before)) new, $after in $dest"
~~~~

### Task 5 · App: sending, and what Submit does (D152 items 3 and 4)

New: `lib/feedback/feedback.dart`, `test/feedback/feedback_test.dart`. Changed: `lib/core/safe_log.dart` (two codes).
Rows A809 to A821.

Checks: `No issues found!`; `+776: All tests passed!`; rows
`python3 -I -B tool/app_mutations.py --rows A809,A810,A811,A812,A813,A814,A815,A816,A817,A818,A819,A820,A821`:
`app mutations: 13 run, 13 caught`.

Commit:

> App: feedback's request and Submit's logic, the text sent once and never kept (D152)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -119,6 +119,12 @@ enum LogEvent {
   /// The invented kept sentences were seeded (D134 item 5): the nights, then
   /// the sentences, as counts.
   previewSeeded,
+
+  /// Feedback (D152): kept by our server; not kept (the server's status, 0
+  /// for no answer, -1 for another failure, -2 for no server or beta key in
+  /// this build). Never a word of it (R3).
+  feedbackSent,
+  feedbackFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/feedback/feedback.dart b/app/lib/feedback/feedback.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/feedback/feedback.dart
@@ -0,0 +1,107 @@
+// Feedback (D110; C18-P's MP·49, C4-P·8, MP·46 and MP·47; D152), in plain
+// Dart: one POST to our server's /feedback with the beta key and the text
+// alone, nothing that names the phone (R4); and what Submit does. Empty or
+// blank, or while a send is under way, it does nothing; before the dreamer
+// has agreed it asks for the popup (MP·101, D128 item 3) and sends nothing;
+// otherwise it sends once. The text is never kept on the phone (R11) and
+// never logged: a failure logs its status alone (R3). SoulDreams Dev only
+// (D152 item 5).
+import 'dart:convert';
+import 'dart:io';
+
+import 'package:flutter/foundation.dart';
+
+import '../core/hosts.dart';
+import '../core/safe_log.dart';
+
+/// At most this many characters, as a person counts them (D152 item 3).
+const feedbackLimit = 2000;
+
+/// The server did not keep it: its HTTP status, 0 for no answer, -2 for no
+/// server or beta key in this build.
+final class FeedbackFailure implements Exception {
+  const FeedbackFailure(this.status);
+
+  final int status;
+}
+
+typedef SendFeedback = Future<void> Function(String text);
+
+const _wait = Duration(seconds: 15);
+final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
+
+/// Sends [text] to [server]'s /feedback; completes when it is kept (204).
+Future<void> postFeedback(Uri server, String betaKey, String text) async {
+  final client = HttpClient()
+    ..userAgent = null
+    ..connectionTimeout = _wait;
+  try {
+    final body = utf8.encode(jsonEncode({'text': text}));
+    final request = await client.postUrl(server.resolve('feedback')).timeout(_wait);
+    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
+    request.headers.contentType = ContentType.json;
+    request.contentLength = body.length;
+    request.add(body);
+    final reply = await request.close().timeout(_wait);
+    await reply.drain<void>().timeout(_wait);
+    if (reply.statusCode != 204) throw FeedbackFailure(reply.statusCode);
+  } on FeedbackFailure {
+    rethrow;
+  } on Object {
+    throw const FeedbackFailure(0);
+  } finally {
+    client.close(force: true);
+  }
+}
+
+/// SoulDreams Dev's own: our server, with the build's beta key; with no
+/// server or a beta key not of its shape, every send fails (-2).
+SendFeedback liveFeedback({required String betaKey, String server = Hosts.server}) {
+  final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);
+  return (text) async {
+    if (!on) throw const FeedbackFailure(-2);
+    await postFeedback(Uri.parse(server), betaKey, text);
+  };
+}
+
+/// Where the section stands: nothing yet, sending, sent, or not sent.
+enum FeedbackState { idle, sending, sent, unsent }
+
+/// What one Submit did.
+enum Submitted { nothing, popup, sent, unsent }
+
+final class FeedbackForm extends ChangeNotifier {
+  FeedbackForm(this._send);
+
+  final SendFeedback _send;
+
+  FeedbackState get state => _state;
+  FeedbackState _state = FeedbackState.idle;
+
+  /// Submit with [text] in the box.
+  Future<Submitted> submit(String text, {required bool agreed}) async {
+    if (_state == FeedbackState.sending || text.trim().isEmpty) return Submitted.nothing;
+    if (!agreed) return Submitted.popup;
+    _set(FeedbackState.sending);
+    try {
+      await _send(text);
+    } on Object catch (e) {
+      SafeLog.event(LogEvent.feedbackFailed, [e is FeedbackFailure ? e.status : -1]);
+      _set(FeedbackState.unsent);
+      return Submitted.unsent;
+    }
+    SafeLog.event(LogEvent.feedbackSent);
+    _set(FeedbackState.sent);
+    return Submitted.sent;
+  }
+
+  /// The box's text changed: a line from the last Submit goes.
+  void edited() {
+    if (_state == FeedbackState.sent || _state == FeedbackState.unsent) _set(FeedbackState.idle);
+  }
+
+  void _set(FeedbackState next) {
+    _state = next;
+    notifyListeners();
+  }
+}
diff --git a/app/test/feedback/feedback_test.dart b/app/test/feedback/feedback_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/feedback/feedback_test.dart
@@ -0,0 +1,202 @@
+// Feedback (D152): one POST to our server's /feedback with the beta key and
+// the text alone, nothing that names the phone (R4); and what Submit does:
+// nothing when empty or while sending, the popup before "I agree", else one
+// send, its result kept for the section, its failure a code (R3).
+import 'dart:async';
+import 'dart:convert';
+import 'dart:io';
+
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/hosts.dart';
+import 'package:souldreams/core/safe_log.dart';
+import 'package:souldreams/feedback/feedback.dart';
+
+/// Our server's door, on this Mac: what each request held, and the answer.
+final class FakeServer {
+  FakeServer._(this._server);
+
+  final HttpServer _server;
+  final requests = <({String method, String path, Map<String, List<String>> headers, String body})>[];
+  int status = 204;
+  Completer<void>? hold;
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
+    final body = await utf8.decodeStream(request);
+    requests.add((method: request.method, path: request.uri.path, headers: headers, body: body));
+    await hold?.future;
+    request.response.statusCode = status;
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
+    lines = [];
+    final sink = SafeLog.sink;
+    SafeLog.sink = lines.add;
+    addTearDown(() => SafeLog.sink = sink);
+  });
+
+  Future<int> failure(Future<void> f) async {
+    try {
+      await f;
+    } on FeedbackFailure catch (e) {
+      return e.status;
+    }
+    fail('no failure');
+  }
+
+  test('at most 2,000 characters', () {
+    expect(feedbackLimit, 2000);
+  });
+
+  test('one POST to /feedback: beta key and text alone', () async {
+    final server = await FakeServer.start();
+    addTearDown(server.stop);
+    await postFeedback(server.url, beta, 'Två rader,\nen app.');
+    final r = server.requests.single;
+    expect(r.method, 'POST');
+    expect(r.path, '/feedback');
+    expect(jsonDecode(r.body), {'text': 'Två rader,\nen app.'});
+    expect(r.headers['authorization'], ['Bearer $beta']);
+    expect(r.headers['content-type'], ['application/json; charset=utf-8']);
+    expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'content-type', 'accept-encoding'});
+  });
+
+  test("not 204: the server's status; no answer: 0", () async {
+    final server = await FakeServer.start();
+    for (final status in [200, 400, 401, 413, 500, 502]) {
+      server.status = status;
+      expect(await failure(postFeedback(server.url, beta, 'a')), status);
+    }
+    final gone = server.url;
+    await server.stop();
+    expect(await failure(postFeedback(gone, beta, 'a')), 0);
+  });
+
+  test("Dev's own: our server, with a well-shaped beta key", () async {
+    final server = await FakeServer.start();
+    addTearDown(server.stop);
+    await liveFeedback(betaKey: beta, server: '${server.url}')('a');
+    expect(server.requests, hasLength(1));
+    expect(await failure(liveFeedback(betaKey: 'short', server: '${server.url}')('a')), -2);
+    expect(await failure(liveFeedback(betaKey: beta, server: '')('a')), -2);
+    expect(server.requests, hasLength(1));
+    expect(Hosts.server, isNotEmpty);
+  });
+
+  group('Submit', () {
+    late List<String> sent;
+    late Completer<void>? hold;
+    late Object? fails;
+    FeedbackForm form() => FeedbackForm((text) async {
+      sent.add(text);
+      await hold?.future;
+      if (fails case final f?) throw f;
+    });
+
+    setUp(() {
+      sent = [];
+      hold = null;
+      fails = null;
+    });
+
+    test('empty or blank: nothing, nothing sent', () async {
+      final f = form();
+      for (final text in ['', ' ', '\n\t ']) {
+        expect(await f.submit(text, agreed: true), Submitted.nothing);
+      }
+      expect(sent, isEmpty);
+      expect(f.state, FeedbackState.idle);
+      expect(lines, isEmpty);
+    });
+
+    test('before agreeing: the popup, nothing sent', () async {
+      final f = form();
+      expect(await f.submit('The app opens slowly.', agreed: false), Submitted.popup);
+      expect(sent, isEmpty);
+      expect(f.state, FeedbackState.idle);
+    });
+
+    test('sent as typed: sending, then sent, one code', () async {
+      final f = form();
+      hold = Completer<void>();
+      final states = <FeedbackState>[];
+      f.addListener(() => states.add(f.state));
+      final done = f.submit('  The app opens slowly.  ', agreed: true);
+      expect(f.state, FeedbackState.sending);
+      hold!.complete();
+      expect(await done, Submitted.sent);
+      expect(sent, ['  The app opens slowly.  ']);
+      expect(states, [FeedbackState.sending, FeedbackState.sent]);
+      expect(lines, ['feedbackSent']);
+    });
+
+    test('while sending, Submit does nothing', () async {
+      final f = form();
+      hold = Completer<void>();
+      final first = f.submit('one', agreed: true);
+      expect(await f.submit('two', agreed: true), Submitted.nothing);
+      hold!.complete();
+      await first;
+      expect(sent, ['one']);
+    });
+
+    test("a failure: unsent, the server's status logged, never the text", () async {
+      for (final (thrown, logged) in [
+        (const FeedbackFailure(413), 'feedbackFailed 413'),
+        (const FeedbackFailure(0), 'feedbackFailed 0'),
+        (StateError('invented failure text'), 'feedbackFailed -1'),
+      ]) {
+        lines.clear();
+        fails = thrown;
+        final f = form();
+        expect(await f.submit('The app opens slowly.', agreed: true), Submitted.unsent);
+        expect(f.state, FeedbackState.unsent);
+        expect(lines, [logged]);
+      }
+    });
+
+    test('a failure, then a send that works', () async {
+      final f = form();
+      fails = const FeedbackFailure(502);
+      expect(await f.submit('a', agreed: true), Submitted.unsent);
+      fails = null;
+      expect(await f.submit('a', agreed: true), Submitted.sent);
+      expect(f.state, FeedbackState.sent);
+    });
+
+    test('typing after sent or unsent returns to idle; otherwise nothing', () async {
+      final f = form();
+      var heard = 0;
+      f.addListener(() => heard++);
+      f.edited();
+      expect(heard, 0);
+      await f.submit('a', agreed: true);
+      heard = 0;
+      f.edited();
+      expect(f.state, FeedbackState.idle);
+      expect(heard, 1);
+      fails = const FeedbackFailure(500);
+      await f.submit('a', agreed: true);
+      f.edited();
+      expect(f.state, FeedbackState.idle);
+    });
+  });
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A808, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A821, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -3281,6 +3281,59 @@ ROWS = [
      '(light ? DarkColours.page.colour! : StandIns.moonColour)',
      '(light ? StandIns.moonColour : DarkColours.page.colour!)',
      'test/journal/pages/sky_mark_test.dart', 'the moon: a crescent, no disc and no rays'),
+    # Feedback (D152): the request, Submit, the section, and its wiring.
+    ('A809', 'lib/feedback/feedback.dart',
+     'const feedbackLimit = 2000;',
+     'const feedbackLimit = 2001;',
+     'test/feedback/feedback_test.dart', 'at most 2,000 characters'),
+    ('A810', 'lib/feedback/feedback.dart',
+     '    ..userAgent = null\n',
+     '',
+     'test/feedback/feedback_test.dart', 'one POST to /feedback: beta key and text alone'),
+    ('A811', 'lib/feedback/feedback.dart',
+     "server.resolve('feedback')",
+     'server',
+     'test/feedback/feedback_test.dart', 'one POST to /feedback: beta key and text alone'),
+    ('A812', 'lib/feedback/feedback.dart',
+     "jsonEncode({'text': text})",
+     "jsonEncode({'text': text, 'day': ''})",
+     'test/feedback/feedback_test.dart', 'one POST to /feedback: beta key and text alone'),
+    ('A813', 'lib/feedback/feedback.dart',
+     'if (reply.statusCode != 204) throw',
+     'if (reply.statusCode >= 300) throw',
+     'test/feedback/feedback_test.dart', "not 204: the server's status; no answer: 0"),
+    ('A814', 'lib/feedback/feedback.dart',
+     'final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);',
+     'final on = server.isNotEmpty || _betaShape.hasMatch(betaKey);',
+     'test/feedback/feedback_test.dart', "Dev's own: our server, with a well-shaped beta key"),
+    ('A815', 'lib/feedback/feedback.dart',
+     'if (_state == FeedbackState.sending || text.trim().isEmpty)',
+     'if (text.trim().isEmpty)',
+     'test/feedback/feedback_test.dart', 'Submit while sending, Submit does nothing'),
+    ('A816', 'lib/feedback/feedback.dart',
+     'text.trim().isEmpty) return Submitted.nothing;',
+     'text.isEmpty) return Submitted.nothing;',
+     'test/feedback/feedback_test.dart', 'Submit empty or blank: nothing, nothing sent'),
+    ('A817', 'lib/feedback/feedback.dart',
+     '    if (!agreed) return Submitted.popup;\n',
+     '',
+     'test/feedback/feedback_test.dart', 'Submit before agreeing: the popup, nothing sent'),
+    ('A818', 'lib/feedback/feedback.dart',
+     '[e is FeedbackFailure ? e.status : -1]',
+     '[-1]',
+     'test/feedback/feedback_test.dart', "Submit a failure: unsent, the server's status logged, never the text"),
+    ('A819', 'lib/feedback/feedback.dart',
+     '    SafeLog.event(LogEvent.feedbackSent);\n',
+     '',
+     'test/feedback/feedback_test.dart', 'Submit sent as typed: sending, then sent, one code'),
+    ('A820', 'lib/feedback/feedback.dart',
+     'if (_state == FeedbackState.sent || _state == FeedbackState.unsent) _set(FeedbackState.idle);',
+     '_set(FeedbackState.idle);',
+     'test/feedback/feedback_test.dart', 'Submit typing after sent or unsent returns to idle; otherwise nothing'),
+    ('A821', 'lib/feedback/feedback.dart',
+     '      await _send(text);',
+     '      await _send(text.trim());',
+     'test/feedback/feedback_test.dart', 'Submit sent as typed: sending, then sent, one code'),
 ]
 
 
~~~~

### Task 6 · App: the Feedback section on Settings (D110; C18-P; D152)

New: `lib/feedback/feedback_section.dart`, `test/feedback/feedback_section_test.dart`. Changed: the palette (Submit's
colour), the stand-ins, Settings, the journal's page and home (the sender, passed down), `main_dev.dart`, and the
tests of the palette, Settings, the home and the Dev-only walk. Rows A822 to A836 new; A752 follows.

Checks: `No issues found!`; `+789: All tests passed!`; rows
`python3 -I -B tool/app_mutations.py --rows A822,A823,A824,A825,A826,A827,A828,A829,A830,A831,A832,A833,A834,A835,A836,A752`:
`app mutations: 16 run, 16 caught`; then the rows of every app file this branch changed (D126):
`python3 -I -B tool/app_mutations.py --files lib/settings/settings_page.dart,lib/journal/pages/journal_page.dart,lib/journal/pages/journal_home.dart,lib/design/palette.dart,lib/core/safe_log.dart,lib/main_dev.dart,lib/design/stand_ins.dart`:
`app mutations: 151 run, 151 caught`.

Commit:

> App: Settings' Feedback section in SoulDreams Dev; [MP·105] and [MP·106] owed (D152)

**The block:**

~~~~diff
diff --git a/app/lib/design/palette.dart b/app/lib/design/palette.dart
--- a/app/lib/design/palette.dart
+++ b/app/lib/design/palette.dart
@@ -7,7 +7,8 @@
 // words and its date; the light box's edge is the surface's (the founder's
 // screen), and the dark delete icon a stand-in, #D0775A, proposed by C18-P
 // and not yet approved; its list labels take color.tag.dream (a stand-in
-// read from the founder's screen).
+// read from the founder's screen). Feedback's Submit takes
+// color.button.filled (C11-P; D152).
 import 'package:flutter/material.dart';
 
 import 'stand_ins.dart';
@@ -46,6 +47,9 @@ final class Palette extends ThemeExtension<Palette> {
     required this.tagTop,
     required this.tagBottom,
     required this.tagText,
+    required this.filledTop,
+    required this.filledBottom,
+    required this.filledText,
   });
 
   final Color page;
@@ -78,6 +82,9 @@ final class Palette extends ThemeExtension<Palette> {
   final Color tagTop;
   final Color tagBottom;
   final Color tagText;
+  final Color filledTop;
+  final Color filledBottom;
+  final Color filledText;
 
   static final light = Palette(
     page: LightColours.page.colour!,
@@ -110,6 +117,9 @@ final class Palette extends ThemeExtension<Palette> {
     tagTop: LightColours.tagDream.colour!,
     tagBottom: LightColours.tagDream.colourEnd!,
     tagText: LightColours.tagDream.text!,
+    filledTop: LightColours.buttonFilled.colour!,
+    filledBottom: LightColours.buttonFilled.colour!,
+    filledText: LightColours.buttonFilled.text!,
   );
 
   static final dark = Palette(
@@ -143,6 +153,9 @@ final class Palette extends ThemeExtension<Palette> {
     tagTop: DarkColours.tagDream.colour!,
     tagBottom: DarkColours.tagDream.colourEnd!,
     tagText: DarkColours.tagDream.text!,
+    filledTop: DarkColours.buttonFilled.colour!,
+    filledBottom: DarkColours.buttonFilled.colourEnd!,
+    filledText: DarkColours.buttonFilled.text!,
   );
 
   static Palette of(BuildContext context) => Theme.of(context).extension<Palette>()!;
@@ -185,6 +198,9 @@ final class Palette extends ThemeExtension<Palette> {
       tagTop: c(tagTop, other.tagTop),
       tagBottom: c(tagBottom, other.tagBottom),
       tagText: c(tagText, other.tagText),
+      filledTop: c(filledTop, other.filledTop),
+      filledBottom: c(filledBottom, other.filledBottom),
+      filledText: c(filledText, other.filledText),
     );
   }
 }
diff --git a/app/lib/design/stand_ins.dart b/app/lib/design/stand_ins.dart
--- a/app/lib/design/stand_ins.dart
+++ b/app/lib/design/stand_ins.dart
@@ -146,4 +146,12 @@ abstract final class StandIns {
   static const double keptDateGap = 4;
   static const double keptIcon = 20;
   static const keptDeleteDark = Color(0xFFD0775A);
+
+  /// Feedback (D152; the founder's screen, docs/reference/screens/feedback.png):
+  /// the card's inside, the field's least and most lines, Submit's side
+  /// inset, and the gap above the line after a Submit.
+  static const feedbackPadding = EdgeInsets.fromLTRB(24, 30, 24, 30);
+  static const int feedbackLines = 4;
+  static const int feedbackMaxLines = 10;
+  static const double feedbackSubmitInset = 24;
 }
diff --git a/app/lib/feedback/feedback_section.dart b/app/lib/feedback/feedback_section.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/feedback/feedback_section.dart
@@ -0,0 +1,188 @@
+// The Feedback section of Settings (D110; main-path.md, Settings; C18-P;
+// D152), SoulDreams Dev only: MP·49 in h2, heard as a heading; then a white
+// card holding C4-P·8 in the app's voice, the field (MP·46 as its hint, the
+// dreamer's voice, at most 2,000 characters, no counter) and Submit (MP·47,
+// color.button.filled). Submit with an empty or blank box does nothing;
+// before the dreamer has agreed it shows the popup (MP·101) and sends
+// nothing (D128 item 3); otherwise it sends once, the box closed to typing
+// until the answer. Sent: the box empties and MP·106 shows; not sent: the
+// text stays and MP·105 shows. Either line goes when the dreamer types. The
+// text lives in the box only, never kept on the phone (R11). MP·105 and
+// MP·106 have no line yet: their handles show (R1). The card, field and
+// button sizes are stand-ins (TO TRY).
+import 'package:flutter/material.dart';
+import 'package:flutter/services.dart';
+
+import '../core/app_line.dart';
+import '../core/language.dart';
+import '../design/palette.dart';
+import '../design/stand_ins.dart';
+import '../design/tokens.g.dart';
+import '../journal/pages/parts.dart';
+import '../settings/agreement_popup.dart';
+import '../words/lines.g.dart';
+import 'feedback.dart';
+
+/// The line after a send that failed: owed (R1).
+const unsentLine = '[MP·105]';
+
+/// The line after a send that worked: owed (R1).
+const sentLine = '[MP·106]';
+
+class FeedbackSection extends StatefulWidget {
+  const FeedbackSection({super.key, required this.send, required this.agreed});
+
+  final SendFeedback send;
+
+  /// Whether the dreamer has agreed, asked at each Submit.
+  final bool Function() agreed;
+
+  static const fieldKey = Key('feedback-field');
+  static const submitKey = Key('feedback-submit');
+  static const lineKey = Key('feedback-line');
+
+  @override
+  State<FeedbackSection> createState() => _FeedbackSectionState();
+}
+
+class _FeedbackSectionState extends State<FeedbackSection> {
+  late final _form = FeedbackForm(widget.send)..addListener(_changed);
+  final _text = TextEditingController();
+
+  @override
+  void dispose() {
+    _form.dispose();
+    _text.dispose();
+    super.dispose();
+  }
+
+  void _changed() {
+    if (mounted) setState(() {});
+  }
+
+  Future<void> _submit() async {
+    final result = await _form.submit(_text.text, agreed: widget.agreed());
+    if (!mounted) return;
+    switch (result) {
+      case Submitted.popup:
+        await showAgreementPopup(context);
+      case Submitted.sent:
+        _text.clear();
+      case Submitted.nothing || Submitted.unsent:
+        break;
+    }
+  }
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    final line = switch (_form.state) {
+      FeedbackState.sent => sentLine,
+      FeedbackState.unsent => unsentLine,
+      FeedbackState.idle || FeedbackState.sending => null,
+    };
+    final edge = OutlineInputBorder(
+      borderRadius: BorderRadius.circular(Spacing.radius),
+      borderSide: BorderSide(color: p.fieldBorder),
+    );
+    return Column(
+      crossAxisAlignment: CrossAxisAlignment.stretch,
+      children: [
+        Semantics(
+          header: true,
+          child: Text(Lines.MP_49.text(appLanguage), textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text)),
+        ),
+        const SizedBox(height: StandIns.gap),
+        DecoratedBox(
+          decoration: surface(p),
+          child: Padding(
+            padding: StandIns.feedbackPadding,
+            child: Column(
+              crossAxisAlignment: CrossAxisAlignment.stretch,
+              children: [
+                AppLine(Lines.C4_P_8.text(appLanguage), style: StandIns.voiceApp(p.text)),
+                const SizedBox(height: StandIns.gap),
+                TextField(
+                  key: FeedbackSection.fieldKey,
+                  controller: _text,
+                  readOnly: _form.state == FeedbackState.sending,
+                  minLines: StandIns.feedbackLines,
+                  maxLines: StandIns.feedbackMaxLines,
+                  keyboardType: TextInputType.multiline,
+                  textCapitalization: TextCapitalization.sentences,
+                  inputFormatters: [LengthLimitingTextInputFormatter(feedbackLimit)],
+                  onChanged: (_) => _form.edited(),
+                  style: TypeRoles.voiceDreamer.style(p.fieldText),
+                  cursorColor: p.fieldText,
+                  decoration: InputDecoration(
+                    hintText: Lines.MP_46.text(appLanguage),
+                    hintMaxLines: StandIns.feedbackLines,
+                    hintStyle: TypeRoles.button.style(p.placeholder),
+                    filled: true,
+                    fillColor: p.field,
+                    contentPadding: StandIns.fieldPadding,
+                    border: edge,
+                    enabledBorder: edge,
+                    focusedBorder: edge,
+                  ),
+                ),
+                const SizedBox(height: StandIns.gap),
+                Padding(
+                  padding: const EdgeInsets.symmetric(horizontal: StandIns.feedbackSubmitInset),
+                  child: _Submit(Lines.MP_47.text(appLanguage), onPressed: _submit),
+                ),
+                if (line != null) ...[
+                  const SizedBox(height: StandIns.gap),
+                  Semantics(
+                    key: FeedbackSection.lineKey,
+                    liveRegion: true,
+                    child: Text(line, textAlign: TextAlign.center, style: TypeRoles.button.style(p.text)),
+                  ),
+                ],
+              ],
+            ),
+          ),
+        ),
+      ],
+    );
+  }
+}
+
+/// Submit: a full pill in color.button.filled (C11-P), its words centred; at
+/// large text they shrink to stay on one row.
+class _Submit extends StatelessWidget {
+  const _Submit(this.label, {required this.onPressed});
+
+  final String label;
+  final VoidCallback onPressed;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    return Semantics(
+      button: true,
+      child: GestureDetector(
+        key: FeedbackSection.submitKey,
+        behavior: HitTestBehavior.opaque,
+        onTap: onPressed,
+        child: DecoratedBox(
+          decoration: BoxDecoration(
+            gradient: LinearGradient(
+              begin: Alignment.topCenter,
+              end: Alignment.bottomCenter,
+              colors: [p.filledTop, p.filledBottom],
+            ),
+            borderRadius: BorderRadius.circular(Spacing.radius),
+          ),
+          child: Padding(
+            padding: StandIns.buttonPadding,
+            child: FittedBox(
+              fit: BoxFit.scaleDown,
+              child: Text(label, textAlign: TextAlign.center, style: TypeRoles.button.style(p.filledText)),
+            ),
+          ),
+        ),
+      ),
+    );
+  }
+}
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -31,6 +31,7 @@ import '../../core/always_light.dart';
 import '../../core/app_line.dart' show wordAnimation;
 import '../../core/night_day.dart';
 import '../../core/safe_log.dart';
+import '../../feedback/feedback.dart';
 import '../../life_context/life_context.dart';
 import '../../life_context/preview.dart';
 import '../../onboarding/onboarding.dart';
@@ -55,6 +56,7 @@ class JournalHome extends StatefulWidget {
     this.nightAction,
     this.read = noneRead,
     this.preview = '',
+    this.feedback,
   });
 
   final JournalFiles files;
@@ -76,6 +78,9 @@ class JournalHome extends StatefulWidget {
   /// writes them, or empty (D131 item 1).
   final String preview;
 
+  /// Sends feedback from Settings (D152), or null: no Feedback section.
+  final SendFeedback? feedback;
+
   @override
   State<JournalHome> createState() => _JournalHomeState();
 }
@@ -263,6 +268,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
         lifeContext: _lifeContext,
         images: _settings?.settings.images != NightImages.off,
         agreed: _settings?.agreed ?? true,
+        feedback: widget.feedback,
       ),
     };
   }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -31,6 +31,7 @@ import '../../core/safe_log.dart';
 import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
+import '../../feedback/feedback.dart';
 import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
 import '../../life_context/life_context.dart';
@@ -61,6 +62,7 @@ class JournalPage extends StatefulWidget {
     this.lifeContext,
     this.images = true,
     this.agreed = true,
+    this.feedback,
   });
 
   final Journal journal;
@@ -101,6 +103,9 @@ class JournalPage extends StatefulWidget {
   /// popup.
   final bool agreed;
 
+  /// Sends feedback from Settings (D152), or null: no Feedback section.
+  final SendFeedback? feedback;
+
   @override
   State<JournalPage> createState() => _JournalPageState();
 }
@@ -277,6 +282,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
                         settings: settings,
                         lifeContext: widget.lifeContext,
                         openNight: _openNight,
+                        feedback: widget.feedback,
                       ),
                     ),
                   ),
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -6,6 +6,8 @@
 // owner's by-eye review of a read night's look (D110); nothing is stored.
 // Built with tool/preview_kept.py's file, it seeds the invented kept
 // sentences once, for the review of Life Context's page (D131 item 1).
+// Settings' Feedback section sends to our server with the same beta key
+// (D152 item 5: SoulDreams Dev only for now).
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -14,6 +16,7 @@ import 'app.dart';
 import 'core/flavour.dart';
 import 'core/keyboard_check.dart';
 import 'core/safe_log.dart';
+import 'feedback/feedback.dart';
 import 'founder/founder_export.dart';
 import 'journal/channel_journal_files.dart';
 import 'journal/night_look.dart';
@@ -39,6 +42,7 @@ void main() {
     betaKey: const String.fromEnvironment('BETA_KEY'),
     connection: ChannelConnection(),
   );
+  final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));
   const read = bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead;
   // The keyboard check (D50 1): only in a build made with
   // --dart-define=KEYBOARD_CHECK=true.
@@ -46,7 +50,7 @@ void main() {
     SoulDreamsApp(
       home: const bool.fromEnvironment('KEYBOARD_CHECK')
           ? const KeyboardCheck()
-          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT')),
+          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback),
     ),
   );
   if (check != null) unawaited(check);
diff --git a/app/lib/settings/settings_page.dart b/app/lib/settings/settings_page.dart
--- a/app/lib/settings/settings_page.dart
+++ b/app/lib/settings/settings_page.dart
@@ -12,7 +12,8 @@
 // length (MP·84); then the row opening "What you've told Soul Dreams"
 // (MP·86, its flag; D121 item 2; D131), its name and a chevron; then "Read
 // disclosure & privacy" (MP·48) and "Delete journal" (EM·11) in the
-// destructive style. No feedback (D121 item 4), no
+// destructive style. Between them and the rows, given a sender (SoulDreams
+// Dev's), the Feedback section (D152; `FeedbackSection`). No
 // region, and no way to give or withdraw consent: each feature is the
 // dreamer's own act (D128 item 2).
 //
@@ -33,6 +34,8 @@ import '../core/safe_log.dart';
 import '../design/palette.dart';
 import '../design/stand_ins.dart';
 import '../design/tokens.g.dart';
+import '../feedback/feedback.dart';
+import '../feedback/feedback_section.dart';
 import '../journal/journal.dart';
 import '../journal/pages/parts.dart';
 import '../journal/pages/sky_mark.dart';
@@ -57,7 +60,14 @@ const owedLanguage = '[owed·language]';
 enum SettingRow { language, wordAnimation, nightImages, nightDay, lifeContext, length }
 
 class SettingsPage extends StatefulWidget {
-  const SettingsPage({super.key, required this.journal, required this.settings, this.lifeContext, this.openNight});
+  const SettingsPage({
+    super.key,
+    required this.journal,
+    required this.settings,
+    this.lifeContext,
+    this.openNight,
+    this.feedback,
+  });
 
   final Journal journal;
   final SettingsController settings;
@@ -68,6 +78,9 @@ class SettingsPage extends StatefulWidget {
   /// Opens a night from Life Context's page, or null.
   final Future<void> Function(String id)? openNight;
 
+  /// Sends feedback (D152), or null: no Feedback section.
+  final SendFeedback? feedback;
+
   static const toggleKey = Key('settings-toggle');
   static const disclosureKey = Key('settings-disclosure');
   static const agreeKey = Key('settings-agree');
@@ -271,6 +284,10 @@ class _SettingsPageState extends State<SettingsPage> {
               row(SettingRow.length, Lines.MP_84, s.length.index, _length),
               if (widget.lifeContext case final life?)
                 _PageRow(name: Lines.MP_86.text(appLanguage), onTap: () => _openKept(life)),
+              if (widget.feedback case final send?) ...[
+                const SizedBox(height: StandIns.listAbove),
+                FeedbackSection(send: send, agreed: () => _c.agreed),
+              ],
               const SizedBox(height: StandIns.listAbove),
               _action(
                 PlainButton(
diff --git a/app/test/design/palette_test.dart b/app/test/design/palette_test.dart
--- a/app/test/design/palette_test.dart
+++ b/app/test/design/palette_test.dart
@@ -4,6 +4,7 @@ import 'package:flutter/painting.dart';
 import 'package:flutter_test/flutter_test.dart';
 import 'package:souldreams/design/palette.dart';
 import 'package:souldreams/design/stand_ins.dart';
+import 'package:souldreams/design/tokens.g.dart';
 
 void main() {
   test('the row border: a grey for each theme', () {
@@ -13,6 +14,19 @@ void main() {
     expect(StandIns.rowBorderDark, const Color(0xFF8A8A8A));
   });
 
+  test('Submit: color.button.filled in each theme, fading with it', () {
+    expect(Palette.light.filledTop, LightColours.buttonFilled.colour);
+    expect(Palette.light.filledBottom, LightColours.buttonFilled.colour);
+    expect(Palette.light.filledText, LightColours.buttonFilled.text);
+    expect(Palette.dark.filledTop, DarkColours.buttonFilled.colour);
+    expect(Palette.dark.filledBottom, DarkColours.buttonFilled.colourEnd);
+    expect(Palette.dark.filledText, DarkColours.buttonFilled.text);
+    final mid = Palette.light.lerp(Palette.dark, 0.5);
+    expect(mid.filledTop, Color.lerp(Palette.light.filledTop, Palette.dark.filledTop, 0.5));
+    expect(mid.filledBottom, Color.lerp(Palette.light.filledBottom, Palette.dark.filledBottom, 0.5));
+    expect(mid.filledText, Color.lerp(Palette.light.filledText, Palette.dark.filledText, 0.5));
+  });
+
   test('the row border fades with the theme', () {
     final mid = Palette.light.lerp(Palette.dark, 0.25).rowBorder;
     expect(mid, Color.lerp(StandIns.rowBorderLight, StandIns.rowBorderDark, 0.25));
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -73,6 +73,8 @@ void main() {
       expect(files.where((f) => f.startsWith('lib/settings/')), isEmpty);
       // Life Context, its page and Dev's invented sentences (D131): Dev only.
       expect(files.where((f) => f.startsWith('lib/life_context/')), isEmpty);
+      // Feedback (D152 item 5): Dev only for now.
+      expect(files.where((f) => f.startsWith('lib/feedback/')), isEmpty);
       expect(files, isNot(contains(pending)));
     });
   }
@@ -99,6 +101,7 @@ void main() {
         'lib/life_context/preview.dart',
       ]),
     );
+    expect(files, containsAll(['lib/feedback/feedback.dart', 'lib/feedback/feedback_section.dart']));
   });
 
   // R8, D108: the journal's pages, which testers will get, carry only the
diff --git a/app/test/feedback/feedback_section_test.dart b/app/test/feedback/feedback_section_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/feedback/feedback_section_test.dart
@@ -0,0 +1,192 @@
+// The Feedback section of Settings (D110; C18-P; D152): MP·49 over a card
+// holding C4-P·8, the field (MP·46 as its hint, at most 2,000 characters)
+// and Submit (MP·47, color.button.filled). Empty does nothing; before "I
+// agree", the popup; a send that fails keeps the text and shows [MP·105]; one
+// that works empties the box and shows [MP·106]; typing again takes the line
+// away. The two lines are owed: their handles show until the owner files
+// them (R1).
+import 'dart:async';
+
+import 'package:flutter/cupertino.dart';
+import 'package:flutter/material.dart';
+import 'package:flutter/services.dart';
+import 'package:flutter_test/flutter_test.dart';
+import 'package:souldreams/core/app_line.dart';
+import 'package:souldreams/core/language.dart';
+import 'package:souldreams/design/palette.dart';
+import 'package:souldreams/feedback/feedback.dart';
+import 'package:souldreams/feedback/feedback_section.dart';
+import 'package:souldreams/words/lines.g.dart';
+import 'package:souldreams/words/pending.g.dart';
+
+String en(Line line) => line.text(Lang.en);
+
+void main() {
+  late List<String> sent;
+  late Completer<void>? hold;
+  late Object? fails;
+  late bool agreed;
+
+  setUp(() {
+    sent = [];
+    hold = null;
+    fails = null;
+    agreed = true;
+  });
+
+  Future<void> show(WidgetTester tester, {Brightness brightness = Brightness.light}) async {
+    tester.view.physicalSize = const Size(390, 844);
+    tester.view.devicePixelRatio = 1;
+    addTearDown(tester.view.reset);
+    wordAnimation = false;
+    addTearDown(() => wordAnimation = true);
+    await tester.pumpWidget(
+      MaterialApp(
+        theme: themeFor(brightness),
+        home: Scaffold(
+          body: SingleChildScrollView(
+            child: FeedbackSection(
+              send: (text) async {
+                sent.add(text);
+                await hold?.future;
+                if (fails case final f?) throw f;
+              },
+              agreed: () => agreed,
+            ),
+          ),
+        ),
+      ),
+    );
+    await tester.pumpAndSettle();
+  }
+
+  Future<void> type(WidgetTester tester, String text) async {
+    await tester.enterText(find.byKey(FeedbackSection.fieldKey), text);
+    await tester.pump();
+  }
+
+  Future<void> submit(WidgetTester tester) async {
+    await tester.ensureVisible(find.byKey(FeedbackSection.submitKey));
+    await tester.tap(find.byKey(FeedbackSection.submitKey));
+    await tester.pumpAndSettle();
+  }
+
+  String boxText(WidgetTester tester) =>
+      tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey)).controller!.text;
+
+  testWidgets('its title, its words, the field and Submit, in that order', (tester) async {
+    await show(tester);
+    final title = find.text(en(Lines.MP_49));
+    expect(title, findsOneWidget);
+    expect(tester.getSemantics(title).flagsCollection.isHeader, isTrue);
+    expect(find.text(en(Lines.C4_P_8)), findsOneWidget);
+    expect(find.text(en(Lines.MP_46)), findsOneWidget);
+    expect(find.text(en(Lines.MP_47)), findsOneWidget);
+    final ys = [
+      title,
+      find.text(en(Lines.C4_P_8)),
+      find.byKey(FeedbackSection.fieldKey),
+      find.byKey(FeedbackSection.submitKey),
+    ].map((f) => tester.getCenter(f).dy).toList();
+    expect(ys, orderedEquals([...ys]..sort()));
+    expect(find.byKey(FeedbackSection.lineKey), findsNothing);
+  });
+
+  testWidgets('Submit is color.button.filled in each theme', (tester) async {
+    for (final (brightness, p) in [(Brightness.light, Palette.light), (Brightness.dark, Palette.dark)]) {
+      await show(tester, brightness: brightness);
+      final box = tester.widget<DecoratedBox>(
+        find.descendant(of: find.byKey(FeedbackSection.submitKey), matching: find.byType(DecoratedBox)).first,
+      );
+      final gradient = (box.decoration as BoxDecoration).gradient! as LinearGradient;
+      expect(gradient.colors, [p.filledTop, p.filledBottom], reason: '$brightness');
+      final words = tester.widget<Text>(find.text(en(Lines.MP_47)));
+      expect(words.style!.color, p.filledText, reason: '$brightness');
+    }
+  });
+
+  testWidgets('the field takes at most 2,000 characters, as counted', (tester) async {
+    await show(tester);
+    final field = tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey));
+    final limit = field.inputFormatters!.whereType<LengthLimitingTextInputFormatter>().single;
+    expect(limit.maxLength, feedbackLimit);
+    await type(tester, '👨‍👩‍👧' * 2001);
+    expect(boxText(tester).characters.length, 2000);
+    expect(field.maxLength, isNull, reason: 'no counter is shown');
+  });
+
+  testWidgets('empty or blank: Submit does nothing', (tester) async {
+    await show(tester);
+    await submit(tester);
+    await type(tester, '   \n ');
+    await submit(tester);
+    expect(sent, isEmpty);
+    expect(find.byType(CupertinoAlertDialog), findsNothing);
+    expect(find.byKey(FeedbackSection.lineKey), findsNothing);
+  });
+
+  testWidgets('before I agree: the popup, nothing sent, the text kept', (tester) async {
+    agreed = false;
+    await show(tester);
+    await type(tester, 'The app opens slowly.');
+    await submit(tester);
+    expect(find.text(PendingLines.MP_101.text(appLanguage)), findsOneWidget);
+    expect(sent, isEmpty);
+    await tester.tap(find.text(PendingLines.MP_102.text(appLanguage)));
+    await tester.pumpAndSettle();
+    expect(boxText(tester), 'The app opens slowly.');
+  });
+
+  testWidgets('sent: the box empties, [MP·106] shows, typing clears it', (tester) async {
+    await show(tester);
+    await type(tester, 'The app opens slowly.');
+    await submit(tester);
+    expect(sent, ['The app opens slowly.']);
+    expect(boxText(tester), '');
+    expect(find.text('[MP·106]'), findsOneWidget);
+    expect(tester.getSemantics(find.byKey(FeedbackSection.lineKey)).flagsCollection.isLiveRegion, isTrue);
+    await type(tester, 'A');
+    expect(find.byKey(FeedbackSection.lineKey), findsNothing);
+  });
+
+  testWidgets("not sent: the text stays, [MP·105] shows; Submit again sends it", (tester) async {
+    fails = const FeedbackFailure(502);
+    await show(tester);
+    await type(tester, 'The app opens slowly.');
+    await submit(tester);
+    expect(boxText(tester), 'The app opens slowly.');
+    expect(find.text('[MP·105]'), findsOneWidget);
+    fails = null;
+    await submit(tester);
+    expect(sent, ['The app opens slowly.', 'The app opens slowly.']);
+    expect(find.text('[MP·105]'), findsNothing);
+    expect(find.text('[MP·106]'), findsOneWidget);
+  });
+
+  testWidgets('while sending: the box cannot change, a second Submit does nothing', (tester) async {
+    hold = Completer<void>();
+    await show(tester);
+    await type(tester, 'The app opens slowly.');
+    await tester.ensureVisible(find.byKey(FeedbackSection.submitKey));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(FeedbackSection.submitKey));
+    await tester.pump();
+    expect(tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey)).readOnly, isTrue);
+    await tester.tap(find.byKey(FeedbackSection.submitKey));
+    await tester.pump();
+    expect(sent, ['The app opens slowly.']);
+    hold!.complete();
+    await tester.pumpAndSettle();
+    expect(tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey)).readOnly, isFalse);
+  });
+
+  testWidgets('at the largest text, nothing overflows', (tester) async {
+    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    fails = const FeedbackFailure(0);
+    await show(tester);
+    await type(tester, 'The app opens slowly.');
+    await submit(tester);
+    expect(tester.takeException(), isNull);
+  });
+}
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -255,12 +255,14 @@ void main() {
       text,
       contains(
         'JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, '
-        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'))",
+        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback)",
       ),
     );
     // Every night read only in a build made for the by-eye preview (D110).
     expect(text, contains("bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead"));
     expect(text, contains("betaKey: const String.fromEnvironment('BETA_KEY')"));
+    // Feedback, to our server with the same beta key (D152 item 5).
+    expect(text, contains("final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));"));
   });
 
   testWidgets('a folder that cannot open: a blank page, a code', (tester) async {
diff --git a/app/test/settings/settings_page_test.dart b/app/test/settings/settings_page_test.dart
--- a/app/test/settings/settings_page_test.dart
+++ b/app/test/settings/settings_page_test.dart
@@ -12,6 +12,8 @@ import 'package:souldreams/core/language.dart';
 import 'package:souldreams/core/night_day.dart';
 import 'package:souldreams/design/palette.dart';
 import 'package:souldreams/design/tokens.g.dart';
+import 'package:souldreams/feedback/feedback.dart';
+import 'package:souldreams/feedback/feedback_section.dart';
 import 'package:souldreams/journal/journal_store.dart';
 import 'package:souldreams/journal/pages/journal_home.dart';
 import 'package:souldreams/journal/pages/journal_page.dart';
@@ -51,6 +53,7 @@ void main() {
     Map<Consent, bool> given = const {Consent.readings: true},
     int hour = 12,
     MemoryJournalFiles? folder,
+    SendFeedback? feedback,
   }) async {
     phone(tester);
     JournalStore.newQueueForTests();
@@ -59,7 +62,7 @@ void main() {
     files.files[JournalStore.consentFile] = encodeConsents(Consents.answered(given, DateTime.utc(2026)));
     final store = await JournalStore.open(files);
     await store.save(nightsFromFixtures().first);
-    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, hour), home: JournalHome(files: files)));
+    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, hour), home: JournalHome(files: files, feedback: feedback)));
     await tester.pumpAndSettle();
     await tester.tap(find.byKey(JournalPage.gearKey));
     await tester.pumpAndSettle();
@@ -139,6 +142,38 @@ void main() {
     expect(tester.getCenter(find.byKey(SettingsPage.disclosureKey)).dy, lessThan(delete));
   });
 
+  // D152 item 5: SoulDreams Dev hands the page its sender; with none, there
+  // is no Feedback section.
+  testWidgets('Feedback: after the kept row, before the actions, given a sender', (tester) async {
+    await open(tester, feedback: (_) async {});
+    expect(find.byType(FeedbackSection), findsOneWidget);
+    final y = tester.getTopLeft(find.text(en(Lines.MP_49))).dy;
+    expect(tester.getBottomLeft(find.byKey(SettingsPage.keptKey)).dy, lessThan(y));
+    expect(tester.getBottomLeft(find.byType(FeedbackSection)).dy, lessThan(tester.getTopLeft(find.byKey(SettingsPage.disclosureKey)).dy));
+  });
+
+  testWidgets('no sender, no Feedback section', (tester) async {
+    await open(tester);
+    expect(find.byType(FeedbackSection), findsNothing);
+    expect(find.text(en(Lines.MP_49)), findsNothing);
+  });
+
+  testWidgets('Feedback before agreeing: the popup, nothing sent; after I agree, sent', (tester) async {
+    final sent = <String>[];
+    await open(tester, given: const {}, feedback: (text) async => sent.add(text));
+    await tester.enterText(find.byKey(FeedbackSection.fieldKey), 'The app opens slowly.');
+    await hit(tester, find.byKey(FeedbackSection.submitKey));
+    await tester.pumpAndSettle();
+    expect(find.text(PendingLines.MP_101.text(appLanguage)), findsOneWidget);
+    expect(sent, isEmpty);
+    await tester.tap(find.text(PendingLines.MP_102.text(appLanguage)));
+    await tester.pumpAndSettle();
+    await tester.widget<SettingsPage>(find.byType(SettingsPage)).settings.agree();
+    await hit(tester, find.byKey(FeedbackSection.submitKey));
+    await tester.pumpAndSettle();
+    expect(sent, ['The app opens slowly.']);
+  });
+
   testWidgets('each row offers its line\'s choices; Language only English', (tester) async {
     await open(tester);
     await tester.tap(find.byKey(SettingsPage.valueKey(SettingRow.length)));
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A821, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A836, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -3038,8 +3038,8 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'the preview seeds before the journal opens; a failure, a code'),
     ('A752', 'lib/main_dev.dart',
-     ", preview: const String.fromEnvironment('PREVIEW_KEPT'))",
-     ')',
+     ", preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback)",
+     ', feedback: feedback)',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A753', 'lib/main.dart',
      "import 'core/safe_log.dart';\n",
@@ -3334,6 +3334,66 @@ ROWS = [
      '      await _send(text);',
      '      await _send(text.trim());',
      'test/feedback/feedback_test.dart', 'Submit sent as typed: sending, then sent, one code'),
+    ('A822', 'lib/design/palette.dart',
+     'filledBottom: DarkColours.buttonFilled.colourEnd!,',
+     'filledBottom: DarkColours.buttonFilled.colour!,',
+     'test/design/palette_test.dart', 'Submit: color.button.filled in each theme, fading with it'),
+    ('A823', 'lib/design/palette.dart',
+     'filledText: c(filledText, other.filledText),',
+     'filledText: filledText,',
+     'test/design/palette_test.dart', 'Submit: color.button.filled in each theme, fading with it'),
+    ('A824', 'lib/feedback/feedback_section.dart',
+     'LengthLimitingTextInputFormatter(feedbackLimit)',
+     'LengthLimitingTextInputFormatter(feedbackLimit + 1)',
+     'test/feedback/feedback_section_test.dart', 'the field takes at most 2,000 characters, as counted'),
+    ('A825', 'lib/feedback/feedback_section.dart',
+     'readOnly: _form.state == FeedbackState.sending,',
+     'readOnly: false,',
+     'test/feedback/feedback_section_test.dart', 'while sending: the box cannot change, a second Submit does nothing'),
+    ('A826', 'lib/feedback/feedback_section.dart',
+     '        await showAgreementPopup(context);',
+     '        break;',
+     'test/feedback/feedback_section_test.dart', 'before I agree: the popup, nothing sent, the text kept'),
+    ('A827', 'lib/feedback/feedback_section.dart',
+     '        _text.clear();',
+     '        break;',
+     'test/feedback/feedback_section_test.dart', 'sent: the box empties, [MP·106] shows, typing clears it'),
+    ('A828', 'lib/feedback/feedback_section.dart',
+     'onChanged: (_) => _form.edited(),',
+     'onChanged: (_) {},',
+     'test/feedback/feedback_section_test.dart', 'sent: the box empties, [MP·106] shows, typing clears it'),
+    ('A829', 'lib/feedback/feedback_section.dart',
+     'FeedbackState.unsent => unsentLine,',
+     'FeedbackState.unsent => sentLine,',
+     'test/feedback/feedback_section_test.dart', 'not sent: the text stays, [MP·105] shows; Submit again sends it'),
+    ('A830', 'lib/feedback/feedback_section.dart',
+     'liveRegion: true,',
+     'liveRegion: false,',
+     'test/feedback/feedback_section_test.dart', 'sent: the box empties, [MP·106] shows, typing clears it'),
+    ('A831', 'lib/feedback/feedback_section.dart',
+     'colors: [p.filledTop, p.filledBottom],',
+     'colors: [p.buttonTop, p.buttonBottom],',
+     'test/feedback/feedback_section_test.dart', 'Submit is color.button.filled in each theme'),
+    ('A832', 'lib/feedback/feedback_section.dart',
+     '        Semantics(\n          header: true,',
+     '        Semantics(\n          header: false,',
+     'test/feedback/feedback_section_test.dart', 'its title, its words, the field and Submit, in that order'),
+    ('A833', 'lib/settings/settings_page.dart',
+     'FeedbackSection(send: send, agreed: () => _c.agreed),',
+     'FeedbackSection(send: send, agreed: () => true),',
+     'test/settings/settings_page_test.dart', 'Feedback before agreeing: the popup, nothing sent; after I agree, sent'),
+    ('A834', 'lib/journal/pages/journal_page.dart',
+     '                        feedback: widget.feedback,\n',
+     '',
+     'test/settings/settings_page_test.dart', 'Feedback: after the kept row, before the actions, given a sender'),
+    ('A835', 'lib/journal/pages/journal_home.dart',
+     '        feedback: widget.feedback,\n      ),\n    };',
+     '      ),\n    };',
+     'test/settings/settings_page_test.dart', 'Feedback: after the kept row, before the actions, given a sender'),
+    ('A836', 'lib/main_dev.dart',
+     "  final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));",
+     "  final feedback = liveFeedback(betaKey: '');",
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
 ]
 
 
~~~~

### Task 7 · Docs: Status.md

Commit:

> Status.md: feedback (D152); curated-set's merge recorded

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-24, in branch `curated-set` (the curated set of night paintings shipped in the app, D147, with D149's and D150's overlays and sizes; the owner's by-eye check next), by Claude Code.
+Last updated: 2026-11-24, in branch `feedback` (the Feedback section of Settings and its server change, D152; the plan's questions and the owner's tasks next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,16 +14,16 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`curated-set`: the curated set of night paintings (D147; plan `docs/plans/curated-set.md`): sixty paintings of
-invented scenery and New Dream's night sky, painted on the owner's Mac with Black Forest Labs' `flux-2-klein-4b` on
-the EU endpoint (D145) in the one style (D146) by `server/trial/curated.ts`, chosen by the owner on a contact sheet,
-shipped in `app/assets/paintings/` as JPEGs (1280 x 960, quality 75, sRGB; the sky 1200 x 336), each carrying the
-invisible AI tag (D123) and fingerprinted under G2. The app's picture choice moves from the placeholders to the set;
-Over a painting a row has #000000 at 40% over its whole picture (the founder's ceiling, never darker), a night's header
-fades its bottom half to #000000, and New Dream's sky has the row's 40% (D149 and D150, the founder's by-eye
-corrections, replacing D113's date shade); a row is 74 high and a header's date 55 pt; the rows' and New Dream's
-contrast is measured and reported, not gated, and the header's is a 4.5 to 1 gate (the rulings below). The sun and the
-moon stay drawn in code.
+`feedback`: the Feedback section of Settings and its server change (D110; C18-P; D152; plan `docs/plans/feedback.md`).
+Settings in SoulDreams Dev gains MP·49, a card with C4-P·8, a field (MP·46 as its hint, at most 2,000 characters)
+and Submit (MP·47). A feedback goes to our server's `POST /feedback` with the beta key and the text alone; the
+server puts the text in a private, encrypted bucket in eu-north-1 under its UTC day, deleted after 90 days; the owner
+reads it with `tool/read_feedback.sh`, which moves it to his Mac and deletes it from the bucket. Before "I agree",
+Submit shows the popup (MP·101); a failed send keeps the text and shows MP·105, a sent one empties the box and shows
+MP·106, both owed (handles shown). The plan's questions are its Part 4.
+
+`curated-set` is merged (`4a22d1a`): the curated set of night paintings (D147, with D149 to D151). Its Status was not
+updated at the merge (this entry records it).
 
 `image-trial` is merged (`a8d0099`): the open-model trial in AWS (D135 to D141, torn down), the Nebius test (D142,
 D143, set aside) and the Black Forest Labs test (D144 to D146), whose model and style the set uses.
@@ -38,11 +38,12 @@ merge (this entry records it).
 
 ## Road ahead
 
-- `curated-set`: the owner's by-eye check in SoulDreams Dev (plan Task 8, with D149 and D150's changes), the full mutation runs once (D126), then the merge, which is the owner's. The plan's questions are its Part 4.
+- `feedback`: the owner's answers to the plan's Part 4, the package (Task 1), the build, the deploy (Task 8), the by-eye
+  check and the first reading (Task 9), the full mutation runs once (D126), then the merge, which is the owner's.
 - `life-context` (merged): the owner's by-eye review passed (plan Task 7, with D133 and D134; VoiceOver waits for
   the full pass, D98) and the full mutation run was done: `app mutations: 726 run, 726 caught` at `46d5ebd` (9 min
   1 s on the owner's Mac, parallel). The Product questions are banked (items 167 and 169).
-- Then "Made by AI"; Feedback, with its server change (D121 item 4). Life Context's sources (the opening's answers,
+- Then "Made by AI". Life Context's sources (the opening's answers,
   what is said after it, the reflection, Waking Life) come with Questions and Reflection, and with them the mark on a
   tapped sentence's night (D131 item 3).
 - Onboarding in the founder and tester apps: a later, separate ruling (D103 item 1); the pending lines are filed at
@@ -321,7 +322,17 @@ merge (this entry records it).
   version 2), followed by the journal's home (`SettingsController`): Word Animation into `AppLine` and the theme's
   fade (off, instant, as with Reduce Motion), Night/Day mode through `NightDayChoice` above the app. A change that
   cannot be kept logs `settingsKeepFailed` or `consentKeepFailed` and holds until the app closes; a read that fails, `settingsReadFailed`, and the defaults stand. No
-  feedback (D121 item 4), no region, no Help (R9).
+  region, no Help (R9). Feedback: below.
+- Feedback (D110; C18-P; D152; `app/lib/feedback/`, SoulDreams Dev only, built in `feedback`; TO TRY where a stand-in):
+  on Settings after "What you've told Soul Dreams" and before MP·48, MP·49 in h2, then a white card with C4-P·8 in
+  the app's voice, the field (MP·46 its hint, the dreamer's voice, at most 2,000 characters as a person counts them,
+  no counter) and Submit (MP·47, `color.button.filled`, in the palette as `filledTop`, `filledBottom`, `filledText`).
+  Empty or blank does nothing; before "I agree", the popup (MP·101) and nothing sent; while sending, the box is
+  closed and a second Submit does nothing; sent, the box empties and `[MP·106]` shows; not sent, the text stays and
+  `[MP·105]` shows; typing takes either line away. The text is in the box only, never kept on the phone. One POST to
+  `Hosts.server` + `feedback`, the beta key and `{"text": ...}`, no user agent; anything but 204 fails. Logs
+  `feedbackSent`, `feedbackFailed` with the status (0 no answer, -1 other, -2 no server or beta key). The section
+  shows only when SoulDreams Dev hands Settings its sender (`main_dev.dart`, `liveFeedback`).
 - Life Context (C159-I item 1; D110, head's message 24 item 2; D127; D128; D131; `app/lib/life_context/`, SoulDreams
   Dev only; TO TRY where a stand-in): what is kept is each sentence of the dreamer's words said in a night outside the
   dream, word for word (`sentences.dart`: a sentence ends at `.`, `!`, `?` or `…` with any closing quotes, then a space
@@ -357,7 +368,7 @@ merge (this entry records it).
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 765 tests, and 747 mutation checks (A1 to A808; A418 to A422, A424 to A426, A429, A781 (D149), A24ah,
+- The app's analyzer baseline: `No issues found!`. The app has 789 tests, and 775 mutation checks (A1 to A836; A418 to A422, A424 to A426, A429, A781 (D149), A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
   A277, A278, A281, A288, A291, A300, A301, A302, A313, A363, A375, A507, A518, A521, A526, A527, A530, A537, A538, A539, A540, A541, A543, A546, A549, A550, A553, A554, A558, A566, A574, A575, A578, A583, A585 to A600, A610, A623, A624, A626, A627, A629, A633, A634, A635, A645, A646, A369 and A409 to A411
   dropped, each with its reason in the file; with the rows A24a to
@@ -378,16 +389,23 @@ merge (this entry records it).
 ## The server
 
 - Node 24, pinned by `engines` in `server/package.json`; `check_all.sh` checks the running major. TypeScript, strict
-  (`server/tsconfig.json`; no `exactOptionalPropertyTypes`, D42 Q6). Six packages, for development only, at exact
+  (`server/tsconfig.json`; no `exactOptionalPropertyTypes`, D42 Q6). Seven packages, for development only, at exact
   versions: `typescript` 6.0.3, `@types/node` 24.19.2, `aws-cdk-lib` 2.275.0, `constructs` 10.8.1, `aws-cdk`
-  2.1147.0 (D42 Q1, Q14), and `@aws-sdk/client-ssm` at the owner's version, for its types only: the Lambda runtime
+  2.1147.0 (D42 Q1, Q14), and `@aws-sdk/client-ssm` and `@aws-sdk/client-s3` at the owner's version, for their types only: the Lambda runtime
   carries its own SDK, and the Lambda's code folder holds no package (D71 Q13 a). The owner installs them; Claude Code's settings deny every install, and it runs `npm ci
   --offline` only through `check_all.sh` (D42 Q13).
 - `server/src/`: the front door (`door.ts`, head's message 14; D71): POST `/` with the beta key as a bearer token gets
   a short-lived Soniox key (200, `{key, expiresAt}`); a missing, wrong or misshapen key 401 with no body, before
   anything is read when misshapen; another method or path 404; Parameter Store failing 500; Soniox failing 502
-  with its status logged. It reads the method, the path and the authorization header only, never the caller's
-  address, the body or another header. The beta key's check hashes both keys and compares them in constant time
+  with its status logged. POST `/feedback` with the beta key and a JSON body of one non-blank `text` of at most 2,000
+  characters (graphemes) keeps it (`feedback.ts`, `feedback-store.ts`, D152): 204; a body that is not that 400, too
+  long 413 (`feedbackRefused` with the status), the bucket failing 502 (`feedbackFailed`), kept `feedbackKept`. The
+  object is `<UTC day>/<32 random hex>.txt`, the text alone, `text/plain; charset=utf-8`, in the bucket the
+  Lambda's one variable `FEEDBACK_BUCKET` names. It reads the method, the path and the authorization header, and the
+  body only for feedback after the key, never the caller's address or another header. The stack's bucket
+  (`infra/stack.ts`): SSE-S3, every public access blocked, no ACLs, TLS only, unversioned, objects deleted after 90
+  days, kept if the stack goes; the Lambda may only put objects; output `FeedbackBucket`. The owner reads with
+  `tool/read_feedback.sh <profile>` (`aws s3 mv` into `~/SoulDreams-feedback/<day>/`, each file dated to its day). The beta key's check hashes both keys and compares them in constant time
   (`beta-key.ts`). The temporary key's request is exactly four fields: `transcribe_websocket`, 60 seconds to open,
   single use, 1800 seconds at most (`soniox.ts`, D71 Q10), sent to `api.eu.soniox.com` (`hosts.ts`). The two keys
   are read from Parameter Store as SecureStrings (`parameters.ts`, `parameter-names.ts`); `handler.ts` wires them.
@@ -418,11 +436,11 @@ merge (this entry records it).
   scenes and the sky) and `server/trial/jpeg.ts` (sizes, the sRGB profile and the AI tag, written by our own code;
   its names in `server/src/hosts.ts`, never fetched). macOS's `sips` makes each JPEG, and our code embeds the OS's own
   sRGB profile in it, since `sips` on macOS 26 writes none. Tested against fakes.
-- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 134 tests, and
-  104 mutation checks (S1 to S109, S42 retired with the budget resource, D138, S82 to S85 with the style test, D146)
+- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 154 tests, and
+  130 mutation checks (S1 to S135, S42 retired with the budget resource, D138, S82 to S85 with the style test, D146)
   in `tool/server_mutations.py`, run by
-  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 104 run,
-  104 caught`); `check_all.sh` does not
+  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 130 run,
+  130 caught`); `check_all.sh` does not
   call it (D43 Q3). It first runs the type check and the tests on the unbroken server, and stops with
   `server mutations: FAILED (the unbroken server fails)`, exit 1, if either fails (the final review, `2fbaad6`).
 
@@ -1167,7 +1185,7 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 
 - MP·98 "Back" / "Tillbaka" and MP·99 "Turn on" / "Slå på", on Life Context's consent page in Settings (the
   founder, 2026-11-22, D125 item 9; the owner wrote them in `pending-lines.csv`; handles proposed to Product, banked
-  item 162); MP·100 "I agree" / "Jag godkänner", on onboarding's second page and at the end of Settings' Disclosure & privacy page (D127 item 1; D128 item 3; banked item 163); MP·101 (the popup's words) and MP·102 "OK" / "OK" (D128 item 3; banked item 164); MP·103 "Done" / "Klar" (the tick that ends selecting on Life Context's page) and MP·104 (the line shown there while Life Context is Off) (the founder, D133; handles proposed to Product). MP·60 to MP·65 were filed at C17-P, word for word as pending (checked in `c17p-import`).
+  item 162); MP·100 "I agree" / "Jag godkänner", on onboarding's second page and at the end of Settings' Disclosure & privacy page (D127 item 1; D128 item 3; banked item 163); MP·101 (the popup's words) and MP·102 "OK" / "OK" (D128 item 3; banked item 164); MP·103 "Done" / "Klar" (the tick that ends selecting on Life Context's page) and MP·104 (the line shown there while Life Context is Off) (the founder, D133; handles proposed to Product). Owed, their handles shown until the owner adds them: MP·105 (Feedback, a send that failed) and MP·106 (Feedback, a send that worked) (D152 item 4; plan `docs/plans/feedback.md`, Part 4). MP·60 to MP·65 were filed at C17-P, word for word as pending (checked in `c17p-import`).
 
 ## Rulings during branch 2
 
@@ -1731,6 +1749,17 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
   (values: #000000 at 65%, blur radius 6, offset 0 and 1 down; over a painting only), for the founder to try if dates
   read poorly.
 
+## Rulings during feedback
+
+- `curated-set` merged by the owner (`4a22d1a`).
+- D152 (owner, the brainstorm): (1) feedback goes through our server to a private S3 bucket in the workload account,
+  eu-north-1, encrypted, blocked from public access, holding only the text and the UTC day (no install ID, device,
+  journal or IP; the Lambda logs codes only), deleted by its lifecycle after 90 days; (2) the owner reads it with
+  one command on his Mac that downloads the new feedback to a folder and then deletes it from the bucket; (3) at
+  most 2,000 characters; an empty Submit does nothing; before "I agree" the D128 popup (MP·101) instead of sending;
+  (4) a failed send keeps the text in the box and shows a "couldn't send" line (a pending line if the register has
+  none); (5) SoulDreams Dev only for now. D91 and D126 apply.
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
~~~~

### Task 8 · [OWNER] The deploy (D152 item 1)

After Task 7, from the branch. `<workload>` is the workload account's profile and `<workload id>` its number, as in
the image trial's tasks. Claude Code never runs `aws` (R13).

Paste 1 — Terminal (build, then what would change; nothing is changed yet)

```
cd ~/Developer/soul-dreams-app/server && npm ci --no-audit --no-fund && npm run build && npx cdk diff SoulDreamsServer -c account=<workload id> --profile <workload>
```

Expected, and nothing else:
- `[+] AWS::S3::Bucket Feedback…` and `[+] AWS::S3::BucketPolicy Feedback…Policy…`;
- `[~] AWS::IAM::Policy Role…DefaultPolicy…`: one statement added, `s3:PutObject` on the bucket's `/*`;
- `[~] AWS::Lambda::Function Handler…`: `Code` and `Environment` (the variable `FEEDBACK_BUCKET`);
- Outputs: `[+] FeedbackBucket`.
- **Stop** if the function URL (`AWS::Lambda::Url`), its permissions or the log group show `[-]` or a replacement:
  the app's address would change.

Paste 2 — Terminal (the deploy)

```
cd ~/Developer/soul-dreams-app/server && npx cdk deploy SoulDreamsServer -c account=<workload id> --profile <workload>
```

Expected: CDK asks to approve the IAM change; it lists only `s3:PutObject` on the feedback bucket's objects for the
Lambda's role. Answer `y` only if so. Then `UPDATE_COMPLETE` and the outputs `SoulDreamsServer.Url` (the same address
as in `app/lib/core/hosts.dart`) and `SoulDreamsServer.FeedbackBucket` (a name starting `souldreamsserver-feedback`).

Paste 3 — Terminal (the bucket, as D152 says; read-only)

```
cd ~/Developer/soul-dreams-app && B=$(aws cloudformation describe-stacks --stack-name SoulDreamsServer --region eu-north-1 --profile <workload> --query "Stacks[0].Outputs[?OutputKey=='FeedbackBucket'].OutputValue" --output text) && echo "$B" && aws s3api get-public-access-block --bucket "$B" --region eu-north-1 --profile <workload> --output text && aws s3api get-bucket-encryption --bucket "$B" --region eu-north-1 --profile <workload> --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault.SSEAlgorithm' --output text && aws s3api get-bucket-lifecycle-configuration --bucket "$B" --region eu-north-1 --profile <workload> --query 'Rules[].[Status,Expiration.Days]' --output text && aws s3api get-bucket-versioning --bucket "$B" --region eu-north-1 --profile <workload> --output text; aws s3api get-bucket-logging --bucket "$B" --region eu-north-1 --profile <workload> --output text; aws s3api get-bucket-location --bucket "$B" --profile <workload> --output text && aws s3 ls "s3://$B" --recursive --region eu-north-1 --profile <workload> | wc -l && grep -c "$(aws cloudformation describe-stacks --stack-name SoulDreamsServer --region eu-north-1 --profile <workload> --query "Stacks[0].Outputs[?OutputKey=='Url'].OutputValue" --output text)" app/lib/core/hosts.dart
```

Expected, line by line: the bucket's name; `PUBLICACCESSBLOCKCONFIGURATION True True True True`; `AES256`;
`Enabled 90`; nothing for versioning (never enabled); nothing for logging; `eu-north-1`; `0` (empty); `1` (the URL
unchanged in `hosts.dart`).

Paste 4 — Terminal (the door: no key, refused; read-only)

```
cd ~/Developer/soul-dreams-app && U=$(aws cloudformation describe-stacks --stack-name SoulDreamsServer --region eu-north-1 --profile <workload> --query "Stacks[0].Outputs[?OutputKey=='Url'].OutputValue" --output text) && curl -s -o /dev/null -w '%{http_code}\n' -X POST "${U}feedback" && curl -s -o /dev/null -w '%{http_code}\n' -X GET "${U}feedback"
```

Expected: `401`, then `404`.

Paste 5 — Terminal (whether any trail records S3 objects; read-only, question 14)

```
for t in $(aws cloudtrail describe-trails --region eu-north-1 --profile <workload> --query 'trailList[].TrailARN' --output text); do echo "$t"; aws cloudtrail get-event-selectors --trail-name "$t" --region eu-north-1 --profile <workload> --query '[EventSelectors[].DataResources[].Type, AdvancedEventSelectors[].FieldSelectors[?Field==`resources.type`].Equals[]]' --output text; done; echo done
```

Expected: each trail's name with nothing after it, or no trail at all, then `done`. A line holding `AWS::S3::Object`
means a trail records every put (with the Lambda's role, never a dreamer's address): bring it to the Build chat.

Send back the whole output of all five.

### Task 9 · [OWNER] The by-eye check and the first reading, SoulDreams Dev, invented text only

By eye only, in SoulDreams Dev built from this branch, after Task 8. Type only short invented lines about the app,
never a dream or anything from a night (R2). Build and install SoulDreams Dev as usual, with your
`--dart-define-from-file` for the key.

Check each step in the light theme and, where it says so, in the dark one. If any result differs, stop and bring it to
the Build chat. Nothing is fixed on the phone.

1. **The section.** Settings, scrolled down: under "What you've told Soul Dreams", "Feedback" large; a white card
   with the three short paragraphs ("Our mission is…", "In order to improve…", "Whatever thoughts…"), the grey box
   showing "Your feedback is never linked to your journal. It's read by our team and then deleted." in grey, and a
   dark "Submit". Then "Read disclosure & privacy" and "Delete journal", as before.
2. **Empty.** Submit with nothing typed: nothing happens. Type only spaces: nothing happens.
3. **Before agreeing.** Delete the journal and choose "I don't agree". Settings → type `test one` → Submit: the popup
   (MP·101) with OK; OK closes it; `test one` is still in the box.
4. **Agree** (Settings → Read disclosure & privacy → I agree). Back in Settings, type `test two` → Submit: the box
   empties and `[MP·106]` shows under Submit. Type a letter: `[MP·106]` goes.
5. **Not sent.** Airplane mode on. Type `test three` → Submit: after a moment `[MP·105]` shows, `test three` stays.
   Airplane mode off, Submit again: the box empties and `[MP·106]` shows.
6. **The limit.** Paste a long text (over 2,000 characters, for example a paragraph of the disclosure copied many
   times): the box holds the first 2,000 characters and takes no more; no counter shows. Clear it.
7. **Leaving.** Type `test four`, leave Settings and come back: the box is empty.
8. **The dark theme** (the toggle): the card dark, the box its dark grey, Submit light with dark words.
9. **Large text** (the phone's largest): the section scrolls, nothing overlaps or is cut.

Then the reading (D152 item 2):

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app && tool/read_feedback.sh <workload> && ls -lR ~/SoulDreams-feedback && cat ~/SoulDreams-feedback/*/*.txt && echo && B=$(aws cloudformation describe-stacks --stack-name SoulDreamsServer --region eu-north-1 --profile <workload> --query "Stacks[0].Outputs[?OutputKey=='FeedbackBucket'].OutputValue" --output text) && aws s3 ls "s3://$B" --recursive --region eu-north-1 --profile <workload> | wc -l
```

Expected: `read-feedback: 2 new, 2 in /Users/…/SoulDreams-feedback`; one folder named today's UTC date holding two
files of 32 hex characters each, dated today at 00:00; `test two` and `test three` (and nothing else); `0` (the
bucket empty). `test one` never left the phone.

Paste 2 — Terminal (the Lambda's log holds codes only)

```
aws logs tail "$(aws lambda get-function-configuration --function-name "$(aws cloudformation describe-stack-resources --stack-name SoulDreamsServer --region eu-north-1 --profile <workload> --query "StackResources[?ResourceType=='AWS::Lambda::Function'].PhysicalResourceId" --output text)" --region eu-north-1 --profile <workload> --query LoggingConfig.LogGroup --output text)" --since 2h --region eu-north-1 --profile <workload> --format short | grep -c -i -E 'test (one|two|three)|feedbackKept'
```

Expected: `2` (the two `feedbackKept` lines, and no line holding the typed words). Run it again with only
`'test (one|two|three)'` in the pattern: expected `0`.

Bring the results (not the feedback files) to the Build chat. Feedback from testers, later, is never pasted into
Claude Code or a chat: it may hold anything a tester typed (R2).

### Task 10 · The full mutation runs (D126)

After the by-eye check and any correction rounds, immediately before the merge, when the Build chat asks:
`python3 -I -B tool/app_mutations.py | tail -1` (expected `app mutations: 775 run, 775 caught`) and
`python3 -I -B tool/server_mutations.py | tail -1` (expected `server mutations: 130 run, 130 caught`). Then the merge,
which is the owner's.

## Part 4 · Questions (numbered; a blank is not a yes)

1. **The new package** (R10; D91's stop case): `@aws-sdk/client-s3` 3.1161.0 (published 2026-10-30), a
   devDependency for its types only; the Lambda runtime carries its own copy, and nothing of it is in the Lambda's
   code folder. Same version as the SSM client, so most of its own packages are already in the lockfile. Lean: yes.
   If no: the server cannot write to S3 without hand-signing AWS requests, which this plan does not do; D152 item 1
   would need another store.
2. **Two owed lines** (R1; for the Build chat, then the owner's `pending-lines.csv`):
   - **MP·105**, place: "Feedback: the line shown under Submit when a send fails; the text stays in the box". Its job
     (D152 item 4): say the feedback could not be sent just now and that the words are still there; never blame the
     dreamer or say they are offline. (MP·62, "Couldn't save just now. Your words are still here.", is the nearest
     filed line, for the Build chat's reference only.)
   - **MP·106**, place: "Feedback: the line shown under Submit when a send worked; the box empties". Its job: say it
     was sent. Lean: a line, since an emptied box alone can read as lost. If no line is wanted, the box only empties
     (rows A827 and A830 change; the section's test follows).
   Until filed, `[MP·105]` and `[MP·106]` show in SoulDreams Dev. Filing them is a two-line change (the placeholders
   become `PendingLines.MP_105` and `PendingLines.MP_106`), done when they arrive.
3. **S3's own clock.** S3 records every object's upload time to the second (its `LastModified`), which cannot be
   turned off, and the Lambda's log line `feedbackKept` carries the time it was logged (kept 7 days). Neither is in
   what we keep, but both are more than "the UTC day" while they last. Lean: accept: the object lives in the bucket
   only until read (or 90 days), the reading dates the Mac's copy to its day's start, and the log holds a code only.
   If not: drop the `feedbackKept` log line (the S3 time stays; only batching sends once a day would hide it).
4. **Encryption**: SSE-S3 (AES-256, keys held by S3, no cost) rather than SSE-KMS with a key of our own (about USD 1
   a month, its own key policy). Lean: SSE-S3. If KMS: one more resource, the Lambda's role and the owner's reading
   need `kms` rights.
5. **The bucket if the stack is ever removed**: kept, its lifecycle still deleting after 90 days. Lean: kept, so a
   stack mistake never deletes unread feedback silently. If deleted with the stack: CDK must empty it first, which
   adds a helper Lambda to the stack.
6. **The folder** `~/SoulDreams-feedback/`, in the home folder, not in Documents or Desktop (often synced to iCloud).
   Lean: yes. If another: give its path.
7. **What is in the box is not kept** when Settings closes (R11; nothing on the phone). Lean: yes.
8. **At 2,000 characters** the box takes no more, with no counter and no line. Lean: yes. If a counter is wanted, it
   is new words for Product.
9. **The day is the server's**, in UTC. Lean: yes.
10. **No limit on how often**: anyone holding the beta key can send many feedbacks; each is at most 2,000 characters
    and lives at most 90 days. Lean: bank it (a later branch, with the readings' spending counter, D69).
11. **The look, stand-ins** (TO TRY, P13): C4-P·8 in `type.voice.app` (the Design System's role for the app's own
    lines; the founder's screen shows it in Inter), the box in `type.voice.dreamer`, its hint and the line under
    Submit in `type.button`, Submit filled and wide inside the card. Lean: as built, for the founder's eye.
12. **The section's place**: after "What you've told Soul Dreams", before "Read disclosure & privacy", as on the
    founder's screen. Lean: yes.
13. **For Product, through the head** (nothing waits on it): W27·9 says feedback is "read by the founders as it
    arrives, and then deleted after the cohort's review", and MP·46 "read by our team and then deleted". With D152
    the bucket deletes each feedback when read or after 90 days, and the owner's copies are deleted at the cohort's
    review (docs/workflow.md (d)). Lean: true as written; the Build chat confirms with Product.
14. **CloudTrail**: if the workload account has a trail recording S3 data events, each put is recorded (with the
    Lambda's role, never a dreamer's address). Task 8's Paste 5 shows whether one does. Lean: none expected; if one
    does, the Build chat decides whether to exclude the bucket.

## Part 5 · How this plan was proven

1. **Built task by task in a copy of the tracked tree**, `.scratch/fb/build`, from `git archive` of `4a22d1a`; each
   task's state kept as a snapshot (`.scratch/fb/snaps/t2` to `t7`), and each block in Part 3 is `git diff --no-index`
   between two snapshots, with the owner's package files left out.
2. **The owner's package, simulated.** `npm install` is refused to Claude Code (D42 Q13). Task 1 was stood in for by
   a stand-in `@aws-sdk/client-s3` (the two classes `S3Client` and `PutObjectCommand` and their types, as this code
   uses them) in the scratch `node_modules`, and a stand-in line in the scratch `package.json` and lockfile. None of
   it is in a block. The real package is checked at Task 2 by `npm run check` (the SDK's own types) and the lockfile
   test; a mismatch there is a stop.
3. **Replayed on a clean copy** (`.scratch/fb/replay`, from `git archive` of `4a22d1a`, the stand-in package added):
   for each task, its test files applied alone first, then the rest (`GIT_CEILING_DIRECTORIES` set, so `git apply`
   applies in a folder inside the repository). Measured:
   - Task 2, tests alone: `npm run check` fails, `ℹ tests 142`, `ℹ fail 11`; whole: clean, 152, 0.
   - Task 3, tests alone: 154, 6 fail; whole: 154, 0.
   - Task 4, tests alone: `FAILED (failures=6, errors=2)`; whole: `OK`, and the script is `-rwxr-xr-x`.
   - Task 5, tests alone: 32 analyzer issues, the new test fails to load; whole: `No issues found!`, `+776`.
   - Task 6, tests alone: 45 analyzer issues, the Settings test fails to load; whole: `No issues found!`, `+789`.
   - Task 7 applied. The replay's final tree is identical, file for file, to the build's, and
     `guards.py --walk` on it prints `guards (walk): all passed`.
4. **Mutations on the build**:
   - Server, first the new rows and those following renamed tests (S8, S12, S14, S21, S22, S110 to S135): 31 run,
     29 caught. S123 did not type-check (its replacement read a possibly undefined path) and S124 survived because the
     door test's clock was today's date; S123 was rewritten and the test's clock moved to 2025-12-31 23:30 UTC; both
     then caught. Then the rows of every changed server file (S1 to S8, S12 to S22, S26 to S28, S110 to S135): 48
     run, 47 caught, S27 not applied (the door's method check was rewritten); S27 followed it (D67) and was caught.
     S119 was then shortened to pass G4 (its replacement had twelve words) and caught again.
   - App: `--rows A809 … A836, A752, A24ap, A341, A391`: `32 run, 32 caught`; `--files` of the seven changed app
     files: `151 run, 151 caught`.
   - The reading script, by hand (no tool covers `tool/`): nine breaks (no `chmod 700`; no dating; no
     `--only-show-errors`; `None` taken as a bucket; the folder in Documents; no profile accepted; no `-e`; no
     region; the new count wrong), each caught by `test_read_feedback.py`. The last survived the first version of the
     test, which gained "feedback read before stays and is not counted new".
5. **Not proven here**: the real S3 client's types and lockfile (Task 2, on the owner's install); the CDK diff and
   deploy against the account (Task 8); the script against the real `aws` CLI (Task 9); the look (Task 9). The full
   mutation runs are Task 10 (D126). `test_check_all.py` cannot run in a scratch copy with no `.git` (it copies the
   tracked files through git) and was not run there; every other guard test passed (284 run, that one erroring).
