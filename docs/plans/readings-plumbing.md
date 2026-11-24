# Plan: the readings with a stand-in model, part one: the reading (readings-plumbing)

Branch `readings-plumbing`, from `main` at `de0a315`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5
and 6), under D91 and D126. Written by Claude Code (Opus) on 2026-11-24; **amended the same day** for the owner's D157
(Part 4's questions take their leans) and the head's message 34 (one interface for every model call, token counts and
cost, caching, the founder's blind comparison planned), and re-proven (Part 5). Governs: the head's message 33 (GO on the
readings' plumbing with a stand-in model, in SoulDreams Dev only, with invented nights only), as the owner relayed
it; C3-T 2e (Claude Opus 5.5 runs the readings, later); C4-T item 4 (no provisional instructions); D134 (Life Context
Off: nothing kept is sent); D128 (the popup before "I agree"); the owner's D155 (the brainstorm) and D156 (banked item
173 (c)); D157; the head's message 34 (2026-11-24, from Organisation's business-model.md); R1, R3, R4, R7, R10, R11.
The owner's checks are by eye only.

`feedback` is merged (`main` at `de0a315`); Status.md's first line still names it ("the owner's deploy, by-eye check
and first reading next"), and its Task 9 is recorded as passed: it was not updated at the merge. This is not a stop;
Task 7 records the merge.

**The split (D155 item 1).** The whole flow is large, so it is split, as D155 item 1 asks. **This plan is part one,
the reading:** Start Interpretation, the request through our server, the stand-in's answer appearing in the night, and
the night becoming read, with Life Context honouring Off, and the night's file gaining its readings as a storage
change (D155 item 2). **Part two, the painting** (the neutral scenery description, from a placeholder, handed to
BFL's `flux-2-klein-4b` on `api.eu.bfl.ai` with the style constant, and the invisible AI tag on the image: D143, D145,
D146, D123), and the owner's BFL key move (D155 item 3), get their own plan after this part is merged; what it will
ask is listed in Part 6.

**Imports first: C19-P.** The owner's read-only check of the documents repository (at its `8a92a57`) shows three
documents changed at C19-P since this repository's copies: `product/design-system.md` (`1a07ffc3c3fb`; here C18-P,
`1c41ff6b3b92`), `product/product-change-record.md` (`505abf1c8ae1`; here C18-P, `2ff467173047`) and
`product/places-register.csv` (`01328992898907cb`; here C18-P, `cd523e7d6959`). The other eleven are unchanged. Task 0a
is the owner's one import paste, the register last; Task 0b is Claude Code's reading of what C19-P changed against the
places this plan uses (Part 1, "The places this branch uses"). **If C19-P changes or adds any of them, the plan is
amended before Task 6, and nothing is guessed meanwhile.** C19-P could not be read before its import: Claude Code
never reads the documents repository (R6), so this plan is written and proven on C18-P.

**Part 4 is answered (D157): every question takes its lean.** The amendment's own questions are Part 4's 21 to 28;
until they are answered they too take their leans only if the owner says so. No new package, app or server (R10).

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

In SoulDreams Dev, a night's page gains its reading, with a stand-in where the model will be.

- **Start Interpretation** (EM·1, bottom right of a night's page), after "I agree", sends the night to our server: its
  language, its dreams as told in words (a recording still waiting for its words is not sent) and, only while Life
  Context is On, the sentences Life Context keeps in its Recent window, word for word. While Life Context is Off,
  nothing it keeps is sent at all (D134). No id, date, name or anything of the phone goes (R4).
- **While it waits**, AI·3 ("Preparing the readings...") shows under the dreams, where the readings will be, and the
  page jumps to it (no motion). A second tap does nothing.
- **Our server** checks the beta key, reads the night, and hands it to the model. In this branch the model is the
  **stand-in**: it reads nothing of the night and answers the same three readings every time, each a placeholder
  marked `[STAND-IN · 1]`, `[STAND-IN · 2]`, `[STAND-IN · 3]`, under the first three traditions' places. Nothing in
  it imitates a reading (C4-T item 4). The server keeps nothing and logs only `readingGiven 3`.
- **The answer appears in the night.** AI·3 goes; under the dreams stand MP·20 (the line before the readings), "The
  Readings" (MP·36, the green section pill) and the three readings, each in the readings' bubble from the left (white
  in the light theme, the bubble gradient in the dark), its tradition's terracotta pill on top, `[W13]` until W13 has
  a line in both languages (R1), then the placeholder in the readings' voice.
- **The night is read.** The readings are kept in the night's file on the phone (version 3). The night's header and
  its row in the journal show its painting from the curated set; the four jump buttons show, and Readings now brings
  "The Readings" to the top. Start Interpretation is gone from a read night; Add dreams stays.
- **A failed reading** (no connection, the server or the model failing, an answer that is not one to three whole
  readings): AI·3 goes and C4-P·6 ("This reading didn't go through. A problem within the app occurred.") stands
  alone where the readings would be. Nothing is kept; the night stays unread; Start Interpretation reads again.
- **Before "I agree"**, Start Interpretation shows the popup (MP·101) and sends nothing, as now.
- **Every model call goes through one interface** (head's message 34 item 1): one setting on the server names the
  model for each step (the opening's steps, the readings, the checks, the painting's scenery description, recurrence);
  changing a step's model is one line there. Today every step names the stand-in, and only the readings step has code.
- **Each call is counted** (item 2): its input, output, cache-read and cache-written tokens, and its cost in millionths
  of a US dollar, per step. The server logs these as numbers only (`modelUsage`), never a word; the reading's answer
  carries them, and SoulDreams Dev keeps them in the night's file beside its readings. The stand-in counts zero. The
  testers' app will not keep them; the founder's will, when it reads.
- **Prompts put fixed text first** (item 3): the instructions, in their order, then the night last, so only fixed text
  could ever be cached. Caching itself is built switched off: AWS's own pages do not say it fits retention mode none
  (Part 2, "AWS").
- **The model's instructions** (R7): our server reads them, once, from the files in `server/instructions/`, copied
  beside its code, and hands them to the model. The folder holds one empty file, `AWAITING-INSTRUCTIONS.md`, which is
  not an instruction. When Interpretation's redrafts come, the owner's import drops them in as files and nothing in
  the plumbing changes; the stand-in is then replaced by Claude Opus 5.5 in its own branch.
- **D156**: a feedback of invisible characters only (zero-width spaces, U+0000, the joiners, the byte-order mark and
  the like) counts as blank: Submit does nothing, as for an empty box.

The tester and founder apps reach none of it (`dev_only_test.dart`). The founder's app reads the new night format,
since it shares the journal's code: its nights are never read there, and every night of his still reads (Task 2's
tests and Task 3's rehearsal).

### What this branch builds

1. **D156** (Task 1): `app/lib/feedback/feedback.dart`: blank is a text of nothing but `White_Space`, `Cc` (control
   characters, U+0000 among them) and `Default_Ignorable_Code_Point` (U+200B to U+200F, U+2060 to U+206F, U+FEFF,
   U+00AD, U+034F, the Hangul fillers, the variation selectors, the tags). One test, one row (A838).
2. **The night's file, version 3** (Task 2; D155 item 2; docs/workflow.md (c)): `app/lib/journal/night.dart`: a
   `Reading` (`lens`, its place among W13's labels, 0 or more; `text`, not empty); a night holds `readings`, null
   while unread, else one to three, in order, never changed in place; a night's dreams changing keeps it read. The
   file gains `"readings": null` or `[{"lens", "text"}]`. Versions 1 and 2 read as before, unread, and save as
   version 3; a `readings` field in a version 1 or 2 file, or a misshapen one in version 3, makes the file not a
   night (skipped, never touched, as today). Tests load every invented night as version 1 and as version 2 (waiting
   recordings among them), count nights, dreams told and waiting and every field before and after, and prove a save
   rewrites only the night saved. Beside the readings, `usage` (head's message 34 item 2): null, or each model call's
   `{"step", "model", "input", "output", "cacheRead", "cacheWrite", "cost"}` (`ModelUsage`; names not empty, counts
   whole and not negative), only on a read night. Nothing else changes in this task's build, so it can ship alone
   (Task 3).
3. **The server's reading and the one model interface** (Task 4): `server/src/models.ts` (head's message 34: the
   steps; `SETUP`, the one setting naming each step's model, with an optional reasoning cap; one `Caller` per model,
   the stand-in's included; `PRICES` in millionths of a dollar per token; `callModel`, which asks the step's model,
   costs the call and logs `modelUsage` with the step, the model, the four token counts and the cost, numbers only;
   `PROMPT_CACHING`, false; a `Prompt` is fixed text first and the dreamer's words last), `server/src/reading.ts`
   (what a request may hold: exactly `lang`, `en` or `sv`; `dreams`, one or more strings, none blank; `kept`,
   optional, strings; nothing else; at most 262,144 characters, longer refused unread; the readings' prompt, the
   instructions first and the night last; the model's text parsed as one to three whole readings, else the night
   fails; the stand-in's three readings), `server/src/
   instructions.ts` (the folder beside the code; every `.md` file but the placeholder, in name order, word for word;
   no folder is an error, never an empty set), `door.ts` (`POST /reading`, after the beta key; 200
   `{"readings": [...], "usage": [...]}`; 400 or 413 `readingRefused`; the model failing, or its text not readings,
   502 `readingFailed`; `readingGiven` with the count), `handler.ts` (each step through `callModel` with `SETUP`, the
   stand-in's caller by default, caching off; the instructions read once, at the first reading), `safe-log.ts` (four
   codes), `infra/dist.ts` (copies `server/instructions/` into the code folder),
   `server/instructions/AWAITING-INSTRUCTIONS.md` (empty). The stack, its role and its timeout do not change.
4. **The app's reading** (Task 5): `app/lib/readings/readings.dart`: `requestOf`, `postReading` (one POST to
   `Hosts.server` + `reading`, the beta key, `application/json`, no user agent; 30 seconds; anything but 200 with one
   to three whole readings and a list of whole calls is a `ReadingFailure`: the status, 0 no answer, -1 unreadable,
   -2 no server or key in this build), `liveReading` (SoulDreams Dev's; the calls' counts kept only with `keepUsage`,
   which only `main_dev.dart` sets), `keptFor` (Life Context's Recent list while On, null while Off or
   absent), `Reader` (the request made at the moment of reading), `interpret` (not sent when already read or with no
   dream in words; the readings kept with `Journal.keepReadings`, with their counts where kept, which keeps a night's
   first readings and reports a night gone). Codes: `readingRead` (count), `readingFailed` (status; -3 anything else), `readingKeepFailed`.
5. **The night's page and the wiring** (Task 6): `night_page.dart` (Start Interpretation reads with the page's
   `Reader`, or does nothing without one; AI·3 and C4-P·6 as live regions; a read night's readings; no Start
   Interpretation once read; the Readings jump; the list lays out every part, so a jump reaches a section below the
   screen), `parts.dart` (`ReadingBubble`), `night_look.dart` (`isRead`), `journal_page.dart` and
   `journal_home.dart` (`readNight`, the `Reader` made with Life Context), `main_dev.dart` (`liveReading` with the
   build's beta key, keeping the counts; `isRead` unless `PREVIEW_READ`). `main.dart` and `main_founder.dart` are unchanged and reach no
   `lib/readings/` (`dev_only_test.dart`).
6. **Status.md** (Task 7).

### What it does not build

- The mirror, the opening, the questions, Interpret Now, the image line (W8, W9), the arc, the press, the series
  question, the close, the reflection, marking, the cap note, the decline: each comes with its instructions.
- Any call to Bedrock, any permission for it, or the spending counter (D69): they come with Claude Opus 5.5, after
  the account checks of C3-T 2d and 2e (question 11). EM·8 (the spending limit) is not shown. Claude's callers and
  prices join `models.ts` then; caching is switched on only after question 25.
- Any screen for the counts or the cost, or any way out of the phone for them: the founder's comparison export (Part
  7) is the first.
- The founder's blind comparison (head's message 34 item 4): planned in Part 7, built later.
- The shimmer (AI·3 stands still, as AI·6 does: the shimmer is not built yet).
- Readings in the tester or founder app; the founder's export carrying readings (question 18).
- Words: none written (R1). The handle `[W13]` shows for every tradition's label (Part 1, "The places").
- The painting: part two.

### The decisions, by number

- The head's message 33 (relayed by the owner): the readings' plumbing with a stand-in model, SoulDreams Dev only,
  invented nights only; fixed placeholder text marked as such, nothing imitating the practice (C4-T item 4); the whole
  flow; Life Context honouring Off (D134); the instructions dropped in by file into `server/instructions/` (G4's
  exemption and G10 come with the importer's later branch); the screens from what is filed, with handles for words
  owed.
- D155 (owner, the brainstorm): (1) split, the reading first; (2) the night file's storage change under (c), with
  the owner's rehearsal on the phone; (3) the BFL key's permanent name (part two); (4) owed words as handles, listed
  for the head.
- D156 (owner, banked item 173 (c)): invisible characters only count as blank; not sent; test-first; one row.
- D157 (owner): Part 4's twenty questions take their leans.
- The head's message 34 (from Organisation's business-model.md): (1) one interface for every model call, the model
  named per step in one setting, the stand-in behind it; (2) token counts per call (input, output, cached) and the
  cost, per step; the server keeps counts only, never text; the app keeps each night's counts and cost beside the
  night (Dev and the founder's build only); the stand-in reports zero counts the same way; (3) prompts fixed text
  first, the dreamer's words last, only fixed text cached; caching checked on AWS's own pages, built off until
  confirmed; (4) the founder's blind comparison planned now, built later, with the seams ready.
- D128 item 3: the popup before "I agree". D134: Off pauses, and nothing kept is sent while Off.
- D91, D126 (targeted rows during the tasks; the full runs once, before the merge), D67 (a row whose code or test
  name moved follows it).

### Decided under D91 (how to build only)

1. **One more route on the same Lambda and function URL**, `POST /reading`, behind the same beta-key check, as
   feedback did: no new address in `hosts.dart`, no new permission.
2. **The tradition travels as a number** (its place among W13's labels), never as a name: the label a dreamer sees is
   the register's line, chosen on the phone, so the server and the model never write a label (R1).
3. **The model is a function the door is handed** (`Model`): the stand-in now; the branch that brings Claude Opus 5.5
   adds its own and changes `handler.ts`'s default only.
4. **The instructions are read once per Lambda instance**, at its first reading, and a missing folder is an error
   (502), never a silent empty set of instructions.
5. **The night is read once.** A night already read is not sent again, and `keepReadings` keeps a night's first
   readings if two answers ever race.
6. **"Read" is decided by the night itself** in SoulDreams Dev (`isRead`: it holds readings); the tester and founder
   apps keep `noneRead`.
7. **The night page's list lays out every part** (`scrollCacheExtent` of 100,000 pixels): without it the Readings
   jump could not reach "The Readings" when it is below the screen (found by its test). A night's page is short.
8. **Existing tests renamed or extended, none weakened**: `night_test.dart`'s three version tests (version 2 becomes
   3; the version-1 test now also proves the `readings` field added; "anything not a night" now also refuses version
   4 and a version-3 file without `readings`); `journal_store_test.dart`'s version-1 journal test now runs for
   versions 1 and 2; `night_page_test.dart`'s "three other jumps" becomes "the Questions and Reflection jumps" (the
   Readings jump has its own test); the door's 404 test gains three paths; `dist.test.ts` lists the new files and
   `node:fs`; `safe-log.test.ts` the three codes; `journal_home_test.dart`'s text of `main_dev.dart` gains the
   reader and `isRead`; `dev_only_test.dart` gains `lib/readings/`. Rows A7, A148, A150, A264, A385, A391, A656,
   A752, A815, A816, A835 and S123 follow (D67): their old text moved, and each was caught again.
9. **The waiting line is brought into view with a jump**, not an animation (Word Animation and Reduce motion have
   nothing to stop); question 7 asks.
10. **A row that survived was a redundant line**, removed (Part 5): a second jump to the end after a failure, which
    the failure sentence never needed, since it takes AI·3's place.
11. **The model is a `Caller` per model, chosen per step by `SETUP`** (head's message 34 item 1): a step never names a
    model in its own code. A choice may carry a reasoning cap, unused by the stand-in, there for setup B (Part 7).
12. **Costs are whole millionths of a dollar** (`PRICES` per token, integers), so a night's cost adds exactly.
13. **The counts travel in the reading's answer and live in the night's file**, beside the readings, in the same
    version-3 storage change, deleted with the night (question 21). The server's only record is its log line.
14. **The stand-in is a `Caller` like any model**: it answers the readings' text whatever step asks, and counts zero.
15. **The readings step parses the model's text** (one to three `{lens, text}`), so a model that answers otherwise
    fails the night (502) rather than reaching the phone.
16. **Existing rows renumbered in task order**: the branch's app rows are A838 to A913, task by task (the amendment
    added rows inside Tasks 2 and 5).

### The places this branch uses

- Filed (C18-P), as written: EM·1 (Start Interpretation), AI·3 (the waiting label), MP·20 (the line before the
  readings), MP·36 ("The Readings"), C4-P·6 (the failure sentence), MP·77 (the jump buttons, as built), MP·101 and
  MP·102 (pending, the popup).
- **Owed, its handle shown** (R1; D155 item 4; for the head): **W13**, the lens labels: "English written, Swedish to
  write", a status the generator builds no line for, so every reading's label shows `[W13]`. When W13 is written in
  both languages, the label is its part at the reading's place, with no change to the code (tested with a filed
  stand-in line).
- **Not shown in this branch, for the head**: W8 and W9 (the image line, composed; its stand-in W8 ends in a colon
  that awaits the image, so it is not shown alone), W7 (the cap note), W12 (the why-line prefix), W14 (the decline),
  AI·11, MP·52, EM·8.
- The placeholder text `[STAND-IN · n]` is not a line: it is the stand-in's marked output, written by the server, as
  the model's will be (R1's "written at run time"), and the owner sees it only in SoulDreams Dev (question 3).

### The tests (test-first, on the Mac)

Each task's tests were put on the tree before its code and failed (loading, type-checking or asserting); then the
code made them pass (Part 5).

- App tests: 790 at the start, then 791 (Task 1), 802 (Task 2), 820 (Task 5) and
  832 (Task 6). `No issues found!` at each.
- Server tests: 156 at the start, then 183 (Task 4). `npm run check` clean.
- Guard tests: unchanged (287); `guards.py --walk` passes on every task's tree.
- App mutation rows: **new** A838 (Task 1), A839 to A865 (Task 2), A866 to A890 (Task 5), A891 to A913 (Task 6): 76;
  **following** A7, A148, A150, A264, A385, A391, A656, A752, A815, A816, A835. 776 → 852.
- Server mutation rows: **new** S139 to S178 (40); **following** S123. 133 → 173.
- None dropped.
- **What the amendment changed** (head's message 34): app tests 828 → 832, server tests 172 → 183; app rows 837 → 852,
  server rows 156 → 173; Tasks 2, 4, 5 and 6 grew (the counts in the night's file; `models.ts` and the readings
  step; the answer's counts and Dev's keeping; Dev's `keepUsage`); Tasks 1, 3, 7 to 10 kept their scope; Part 7 is
  new.

## Part 2 · Settings, packages, AWS and storage

- **Packages:** none, app or server.
- **AWS** (the owner's, Task 8): one stack update of `SoulDreamsServer`: the Lambda's code (the new route and the
  instructions folder). No new resource, permission, variable, output or timeout. Nothing reaches Bedrock or BFL.
- **Prompt caching and retention mode none** (head's message 34 item 3), read on AWS's own pages on 2026-11-24:
  - [READ, Bedrock User Guide, "Prompt caching for faster model inference"]: "A cache entry is stored on the server
    that processed the request, and a later request can read it only if that server handles it before the entry
    expires"; Claude models' supported time to live: "5 minutes, 1 hour". The page does not mention retention.
  - [READ, Bedrock User Guide, "Data retention"]: mode `none` is "Zero data retention. No request or response data is
    written to durable storage by AWS or shared with the model provider." The page does not mention caching.
  - [NOT READ: the AWS Security Blog post on enforcing zero data retention; its text did not come through.]
  - **Not confirmed**: no AWS page read says whether a cache entry is "durable storage" under `none`, or whether
    caching is allowed, blocked or changed under it. So `PROMPT_CACHING` is false, and the prompts are ordered so it
    could be switched on with nothing else changing (question 25).
- **Settings, guards, Swift:** none. `server/instructions/` holds one empty `.md` file, a kind G0 already knows.
- **Storage on the phone** (R11; docs/workflow.md (c); D155 item 2): the night's file, version 2 to version 3 (Task
  2): tests first (Task 2), then the owner's rehearsal on the simulator and the phone in SoulDreams Dev, holding
  invented nights in version 2, with the build of Task 2 alone (Task 3). It reaches the Cohort 0 app only after the
  merge, and only after the owner's safety export of each night (docs/workflow.md (c) item 4; Task 10's note).
  A deleted night still leaves nothing: its readings are in its own file, which deletion removes (the existing
  deletion tests cover the file whole).
- **Storage on the server:** none. The server keeps nothing of a night.

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, made from the build that proved it (Part 5). Apply it from
the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. A block that touches `tool/checks/` is not
here (none does). Then run the task's checks and commit through the hook with the message given.

Every task ends green:
- App tasks: `cd app && fvm flutter analyze --no-pub` prints `No issues found!`, and `fvm flutter test --no-pub`
  passes at the count given; the task's rows (D126): `python3 -I -B tool/app_mutations.py --rows <the task's rows>`,
  every one caught.
- Server tasks: `cd server && npm run check && npm test` prints only the check's header, then `ℹ fail 0` at the count
  given; the task's rows by importing `tool/server_mutations.py` and calling `run_row` on them (it has no row
  selection), every one caught.
- The hook prints `guards (staged): all passed`.

### Task 0a · [OWNER] The C19-P import (the register last)

On `readings-plumbing`, before anything else. One paste:

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app && git branch --show-current && git status --short && export SOUL_DREAMS_DOCS=~/Developer/soul-dreams-docs && tool/import.sh product/design-system.md 1a07ffc3c3fbc48a1c9abfba7b5fa1074da4f53b6eda2a74ccc3e89cdebfd4e6 "C19-P" && tool/import.sh product/product-change-record.md 505abf1c8ae14dddb120bf8786b058e5f19f73975fafd143c4111e184d6793a3 "C19-P" && tool/import.sh product/places-register.csv 01328992898907cb8c40cae1b12a5293657ce8c1143676f73e2de90ff7d4071a "C19-P" && python3 -I -B tool/checks/designgen.py --write && git status --short && python3 -I -B tool/checks/guards.py | tail -4
```

Expected: `readings-plumbing`; nothing from the first `git status`; each import reports its copy and the register's
regenerates the words; `designgen.py` writes `app/lib/design/tokens.g.dart` (banked item 61: the importer does not);
the second `git status` lists `docs/source/SOURCES`, `docs/source/design-system.md`,
`docs/source/product-change-record.md`, `app/assets/words/places-register.csv`, the generated words that changed
(`app/lib/words/lines.g.dart` at least) and `tokens.g.dart` if the design values changed; the guards end `guards
(tracked): all passed`. Any refusal (the importer's, `designgen.py`'s new form, `wordsgen.py`'s unknown status, or G1
on the pending lines): stop and send the whole output; nothing is committed. Otherwise do not commit yet: send the
output, and Task 0b follows.

### Task 0b · Claude Code: what C19-P changed, against this plan

Claude Code reads the diff of the import (`git diff`: the register's rows, the design system, the product change
record) for the places Part 1 lists (EM·1, AI·3, MP·20, MP·36, C4-P·6, W13, MP·77, MP·101, MP·102) and for any new
place on the readings' screen, a pending line now filed (MP·98 to MP·106), or a design value the readings use
(`color.label.tradition`, `color.surface`, `type.voice.readings`, `space.bubble.tradition`, `space.label.readings`,
`space.turn.app`). It runs the app's analyzer and tests on the import. Then either: no change touches this plan, and
the owner commits the import alone (`Import: C19-P, the design system, the product change record and the register`),
or the plan is amended (and re-proven) before Task 6, and the owner commits the import with that amendment's
answers. A test failing on the import alone is a stop (R14).

### Task 0 · Baselines

From the repository root, on `readings-plumbing`:

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 ; (cd app && fvm flutter analyze --no-pub | tail -1 && fvm flutter test --no-pub | tail -1) ; (cd server && npm run check | tail -1 && npm test 2>&1 | grep -E '^ℹ (tests|fail)')
```

Run after Task 0b's commit. Expected: nothing from `git status`; Task 0b's commit; `guards (tracked): all passed`;
`No issues found!`;
`+790: All tests passed!`; `> tsc -p tsconfig.json`; `ℹ tests 156`, `ℹ fail 0`. Anything else: stop (R14).

### Task 1 · App: a feedback of invisible characters only is blank (D156)

Changed: `app/lib/feedback/feedback.dart`, `app/test/feedback/feedback_test.dart`, `tool/app_mutations.py`. Row A838
new; A815 and A816 follow (the blank check's text moved).

Checks: `No issues found!`; `+791`; `--rows A815,A816,A838`: `3 run, 3 caught`.

Commit:

> App: a feedback of invisible characters only is blank, not sent (D156)

**The block:**

~~~~diff
diff --git a/app/lib/feedback/feedback.dart b/app/lib/feedback/feedback.dart
--- a/app/lib/feedback/feedback.dart
+++ b/app/lib/feedback/feedback.dart
@@ -3,9 +3,10 @@
 // alone, nothing that names the phone (R4); and what Submit does. Empty or
 // blank, or while a send is under way, it does nothing; before the dreamer
 // has agreed it asks for the popup (MP·101, D128 item 3) and sends nothing;
-// otherwise it sends once. The text is never kept on the phone (R11) and
-// never logged: a failure logs its status alone (R3). SoulDreams Dev only
-// (D152 item 5).
+// otherwise it sends once. A text of invisible characters only (zero-width
+// spaces, U+0000 and the like) is blank too (D156). The text is never kept
+// on the phone (R11) and never logged: a failure logs its status alone
+// (R3). SoulDreams Dev only (D152 item 5).
 import 'dart:convert';
 import 'dart:io';
 
@@ -30,6 +31,11 @@ typedef SendFeedback = Future<void> Function(String text);
 const _wait = Duration(seconds: 15);
 final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
 
+// Nothing a person can see: whitespace, control characters such as U+0000,
+// and the characters Unicode marks as default-ignorable, such as the
+// zero-width space and the joiners (D156).
+final _invisible = RegExp(r'^[\p{White_Space}\p{Cc}\p{Default_Ignorable_Code_Point}]*$', unicode: true);
+
 /// Sends [text] to [server]'s /feedback; completes when it is kept (204).
 Future<void> postFeedback(Uri server, String betaKey, String text) async {
   final client = HttpClient()
@@ -80,7 +86,7 @@ final class FeedbackForm extends ChangeNotifier {
 
   /// Submit with [text] in the box.
   Future<Submitted> submit(String text, {required bool agreed}) async {
-    if (_state == FeedbackState.sending || text.trim().isEmpty) return Submitted.nothing;
+    if (_state == FeedbackState.sending || _invisible.hasMatch(text)) return Submitted.nothing;
     if (!agreed) return Submitted.popup;
     _set(FeedbackState.sending);
     try {
diff --git a/app/test/feedback/feedback_test.dart b/app/test/feedback/feedback_test.dart
--- a/app/test/feedback/feedback_test.dart
+++ b/app/test/feedback/feedback_test.dart
@@ -127,6 +127,16 @@ void main() {
       expect(lines, isEmpty);
     });
 
+    test('invisible characters only count as blank: nothing, nothing sent (D156)', () async {
+      final f = form();
+      for (final text in ['\u200B', '\u0000', '\u200B\u0000 \uFEFF\u2060', '\u00AD\u3164\u{E0001}']) {
+        expect(await f.submit(text, agreed: true), Submitted.nothing);
+      }
+      expect(sent, isEmpty);
+      expect(await f.submit('\u200Ba', agreed: true), Submitted.sent);
+      expect(sent, ['\u200Ba']);
+    });
+
     test('before agreeing: the popup, nothing sent', () async {
       final f = form();
       expect(await f.submit('The app opens slowly.', agreed: false), Submitted.popup);
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A836, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A838, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -3307,11 +3307,11 @@ ROWS = [
      'final on = server.isNotEmpty || _betaShape.hasMatch(betaKey);',
      'test/feedback/feedback_test.dart', "Dev's own: our server, with a well-shaped beta key"),
     ('A815', 'lib/feedback/feedback.dart',
-     'if (_state == FeedbackState.sending || text.trim().isEmpty)',
-     'if (text.trim().isEmpty)',
+     'if (_state == FeedbackState.sending || _invisible.hasMatch(text))',
+     'if (_invisible.hasMatch(text))',
      'test/feedback/feedback_test.dart', 'Submit while sending, Submit does nothing'),
     ('A816', 'lib/feedback/feedback.dart',
-     'text.trim().isEmpty) return Submitted.nothing;',
+     '_invisible.hasMatch(text)) return Submitted.nothing;',
      'text.isEmpty) return Submitted.nothing;',
      'test/feedback/feedback_test.dart', 'Submit empty or blank: nothing, nothing sent'),
     ('A817', 'lib/feedback/feedback.dart',
@@ -3398,6 +3398,11 @@ ROWS = [
      '      borderSide: BorderSide(color: p.surfaceBorder),',
      '      borderSide: BorderSide(color: p.fieldBorder),',
      'test/feedback/feedback_section_test.dart', "the box's border is the Settings pills' colour in each theme"),
+    # Feedback of invisible characters only is blank (D156).
+    ('A838', 'lib/feedback/feedback.dart',
+     '|| _invisible.hasMatch(text)) return Submitted.nothing;',
+     '|| text.trim().isEmpty) return Submitted.nothing;',
+     'test/feedback/feedback_test.dart', 'invisible characters only count as blank: nothing, nothing sent (D156)'),
 ]
 
 
~~~~

### Task 2 · App: the night's file, version 3, holds its readings (D155 item 2; storage change)

Changed: `app/lib/journal/night.dart`, `app/test/journal/night_test.dart`, `app/test/journal/journal_store_test.dart`,
`tool/app_mutations.py`. Rows A839 to A865 new; A7, A148 and A150 follow (D67). Nothing else changes in this task's
build: it is the build Task 3 rehearses, and the storage change ships alone (docs/workflow.md (c) item 3).

Checks: `No issues found!`; `+802`; `--rows A7,A148,A150,A839,…,A865`: `30 run, 30 caught`; and every row of
the file, `--files lib/journal/night.dart`.

Commit:

> App: the night's file is version 3, its readings and their calls' counts; versions 1 and 2 read unread (D155)

**The block:**

~~~~diff
diff --git a/app/lib/journal/night.dart b/app/lib/journal/night.dart
--- a/app/lib/journal/night.dart
+++ b/app/lib/journal/night.dart
@@ -4,8 +4,11 @@
 // freely (D49, O5). After that, any change is a storage change
 // (docs/workflow.md, "On-phone storage changes"). Version 2 (D92, D93
 // Q2): a dream may be a recording that waits on the phone to be turned
-// into text; version 1 files still read, and are written as version 2
-// when next saved.
+// into text. Version 3 (D155 item 2): a read night holds its readings,
+// an unread one null; and, beside them, each model call's counts and cost
+// (head's message 34), in the builds that keep them, else null. Version 1
+// and 2 files still read, unread, and are written as version 3 when next
+// saved.
 import 'dart:convert';
 import 'dart:math';
 
@@ -14,15 +17,22 @@ import 'package:flutter/foundation.dart';
 import '../words/lines.g.dart' show Lang;
 
 /// The file format's version, written in every night's file.
-const formatVersion = 2;
+const formatVersion = 3;
 
-/// The version before it, still read (docs/workflow.md (c)).
+/// The versions before it, still read (docs/workflow.md (c)).
 const _firstVersion = 1;
+const _secondVersion = 2;
+
+/// At most three readings a night (L3).
+const maxReadings = 3;
 
 final _id = RegExp(r'^[0-9a-f]{32}$');
 const _waitingKeys = {'waiting', 'from'};
 final _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
 const _keys = {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'};
+const _readKeys = {..._keys, 'readings', 'usage'};
+const _readingKeys = {'lens', 'text'};
+const _usageKeys = {'step', 'model', 'input', 'output', 'cacheRead', 'cacheWrite', 'cost'};
 
 /// A new night's id: 128 bits from the system's secure source, as 32 hex
 /// digits. It names a file on the phone and is never sent anywhere (R4).
@@ -86,9 +96,103 @@ final class Waiting extends Dream {
   int get hashCode => Object.hash(audio, from);
 }
 
+/// One of a read night's readings, as our server gave it (head's message
+/// 33): its tradition, as its place among the lens labels (W13), and its
+/// words.
+final class Reading {
+  Reading(this.lens, this.text) {
+    if (lens < 0) throw ArgumentError('lens');
+    if (text.isEmpty) throw ArgumentError('text');
+  }
+
+  final int lens;
+  final String text;
+
+  @override
+  bool operator ==(Object other) => other is Reading && other.lens == lens && other.text == text;
+
+  @override
+  int get hashCode => Object.hash(lens, text);
+}
+
+/// One model call's counts, as our server gave them (head's message 34): its
+/// step and model by name, its input, output, cache-read and cache-written
+/// tokens, and its cost in millionths of a US dollar. Never a word.
+final class ModelUsage {
+  ModelUsage({
+    required this.step,
+    required this.model,
+    required this.input,
+    required this.output,
+    required this.cacheRead,
+    required this.cacheWrite,
+    required this.cost,
+  }) {
+    if (step.isEmpty) throw ArgumentError('step');
+    if (model.isEmpty) throw ArgumentError('model');
+    if ([input, output, cacheRead, cacheWrite, cost].any((n) => n < 0)) throw ArgumentError('count');
+  }
+
+  final String step;
+  final String model;
+  final int input;
+  final int output;
+  final int cacheRead;
+  final int cacheWrite;
+  final int cost;
+
+  /// As its file and our server's answer hold it.
+  Map<String, Object> toJson() => {
+    'step': step,
+    'model': model,
+    'input': input,
+    'output': output,
+    'cacheRead': cacheRead,
+    'cacheWrite': cacheWrite,
+    'cost': cost,
+  };
+
+  /// The call in [json], or null when it is not one whole call.
+  static ModelUsage? fromJson(Object? json) {
+    if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _usageKeys)) return null;
+    if (json
+        case {
+          'step': final String step,
+          'model': final String model,
+          'input': final int input,
+          'output': final int output,
+          'cacheRead': final int cacheRead,
+          'cacheWrite': final int cacheWrite,
+          'cost': final int cost,
+        }) {
+      if (step.isEmpty || model.isEmpty || [input, output, cacheRead, cacheWrite, cost].any((n) => n < 0)) {
+        return null;
+      }
+      return ModelUsage(
+        step: step,
+        model: model,
+        input: input,
+        output: output,
+        cacheRead: cacheRead,
+        cacheWrite: cacheWrite,
+        cost: cost,
+      );
+    }
+    return null;
+  }
+
+  @override
+  bool operator ==(Object other) =>
+      other is ModelUsage && mapEquals(other.toJson(), toJson());
+
+  @override
+  int get hashCode => Object.hashAll(toJson().values);
+}
+
 final class Night {
   /// A night of [dreams] told in words, or of [entries] (told or waiting);
-  /// never both.
+  /// never both. Read when it holds [readings], one to three; [usage] only
+  /// beside them.
   Night({
     required this.id,
     required this.firstRecorded,
@@ -98,8 +202,14 @@ final class Night {
     this.name,
     List<String> dreams = const [],
     List<Dream>? entries,
-  }) : entries = List.unmodifiable(entries ?? [for (final d in dreams) Told(d)]) {
+    List<Reading>? readings,
+    List<ModelUsage>? usage,
+  }) : entries = List.unmodifiable(entries ?? [for (final d in dreams) Told(d)]),
+       readings = readings == null ? null : List.unmodifiable(readings),
+       usage = usage == null ? null : List.unmodifiable(usage) {
+    if (usage != null && readings == null) throw ArgumentError('usage');
     if (entries != null && dreams.isNotEmpty) throw ArgumentError('dreams');
+    if (readings != null && (readings.isEmpty || readings.length > maxReadings)) throw ArgumentError('readings');
     final audio = [for (final e in this.entries) if (e is Waiting) e.audio];
     if (audio.toSet().length != audio.length) throw ArgumentError('entries');
     if (!_id.hasMatch(id)) throw ArgumentError('id');
@@ -132,12 +242,39 @@ final class Night {
   /// The dreams, in order: told, or waiting to be turned into text.
   final List<Dream> entries;
 
+  /// Its readings, in the order given, once read; null while unread.
+  final List<Reading>? readings;
+
+  /// The model calls that made its readings, where the build keeps them
+  /// (SoulDreams Dev, the founder's); else null.
+  final List<ModelUsage>? usage;
+
   /// The dreams told in words, in order.
   List<String> get dreams => List.unmodifiable([for (final e in entries) if (e is Told) e.text]);
 
-  /// The same night holding [entries] instead.
+  /// The same night holding [entries] instead; read or not as it was.
   Night withEntries(List<Dream> entries) => Night(
-      id: id, firstRecorded: firstRecorded, date: date, closes: closes, lang: lang, name: name, entries: entries);
+      id: id,
+      firstRecorded: firstRecorded,
+      date: date,
+      closes: closes,
+      lang: lang,
+      name: name,
+      entries: entries,
+      readings: readings,
+      usage: usage);
+
+  /// The same night, read: holding [readings], and [usage] if kept.
+  Night withReadings(List<Reading> readings, {List<ModelUsage>? usage}) => Night(
+      id: id,
+      firstRecorded: firstRecorded,
+      date: date,
+      closes: closes,
+      lang: lang,
+      name: name,
+      entries: entries,
+      readings: readings,
+      usage: usage);
 
   /// The same night holding [dreams], all told, instead.
   Night withDreams(List<String> dreams) => withEntries([for (final d in dreams) Told(d)]);
@@ -151,10 +288,14 @@ final class Night {
       other.closes == closes &&
       other.lang == lang &&
       other.name == name &&
-      listEquals(other.entries, entries);
+      listEquals(other.entries, entries) &&
+      listEquals(other.readings, readings) &&
+      listEquals(other.usage, usage);
 
   @override
-  int get hashCode => Object.hash(id, firstRecorded, date, closes, lang, name, Object.hashAll(entries));
+  int get hashCode => Object.hash(id, firstRecorded, date, closes, lang, name, Object.hashAll(entries),
+      switch (readings) { null => null, final r => Object.hashAll(r) },
+      switch (usage) { null => null, final u => Object.hashAll(u) });
 }
 
 String _two(int n) => n.toString().padLeft(2, '0');
@@ -175,6 +316,11 @@ Uint8List encodeNight(Night n) => utf8.encode(jsonEncode({
             Waiting(:final audio, :final from) => {'waiting': audio, 'from': from},
           },
       ],
+      'readings': switch (n.readings) {
+        null => null,
+        final readings => [for (final r in readings) {'lens': r.lens, 'text': r.text}],
+      },
+      'usage': n.usage?.map((u) => u.toJson()).toList(),
     }));
 
 // One dream as its file holds it: words, or (from version 2) a waiting
@@ -190,8 +336,33 @@ Dream? _dreamOf(Object? x, int version) {
   return Waiting(audio, from);
 }
 
+// A version-3 file's readings: (null,) for an unread night; null when they
+// are not one to three whole readings.
+(List<Reading>?,)? _readingsOf(Object? x) {
+  if (x == null) return (null,);
+  if (x is! List<Object?> || x.isEmpty || x.length > maxReadings) return null;
+  final readings = <Reading>[];
+  for (final r in x) {
+    if (r is! Map<String, Object?> || !setEquals(r.keys.toSet(), _readingKeys)) return null;
+    final lens = r['lens'];
+    final text = r['text'];
+    if (lens is! int || lens < 0 || text is! String || text.isEmpty) return null;
+    readings.add(Reading(lens, text));
+  }
+  return (readings,);
+}
+
+// A version-3 file's usage: (null,) for none; null when it is not a list of
+// whole calls, or held by an unread night.
+(List<ModelUsage>?,)? _usageOf(Object? x, bool read) {
+  if (x == null) return (null,);
+  if (x is! List<Object?> || !read) return null;
+  final usage = [for (final u in x) ModelUsage.fromJson(u)];
+  return usage.contains(null) ? null : (usage.cast<ModelUsage>(),);
+}
+
 /// The night in [bytes], or null when they are not a whole night of
-/// version 1 or 2. Nothing is guessed or repaired.
+/// version 1, 2 or 3. Nothing is guessed or repaired.
 Night? decodeNight(Uint8List bytes) {
   final Object? json;
   try {
@@ -199,7 +370,9 @@ Night? decodeNight(Uint8List bytes) {
   } on FormatException {
     return null;
   }
-  if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _keys)) return null;
+  if (json is! Map<String, Object?>) return null;
+  // Only version 3 holds the readings' field (D155 item 2).
+  if (!setEquals(json.keys.toSet(), json['version'] == formatVersion ? _readKeys : _keys)) return null;
   if (json
       case {
         'version': final int version,
@@ -215,7 +388,7 @@ Night? decodeNight(Uint8List bytes) {
     final shut = DateTime.tryParse(closes);
     final d = _date.firstMatch(date);
     final language = Lang.values.where((l) => l.name == lang).firstOrNull;
-    if (version != formatVersion && version != _firstVersion) return null;
+    if (version != formatVersion && version != _secondVersion && version != _firstVersion) return null;
     if (!_id.hasMatch(id) || at == null || !at.isUtc || d == null || language == null) return null;
     if (shut == null || !shut.isUtc || !shut.isAfter(at) || shut.difference(at) > maxOpen) return null;
     final (y, m, day) = (int.parse(d[1]!), int.parse(d[2]!), int.parse(d[3]!));
@@ -224,6 +397,10 @@ Night? decodeNight(Uint8List bytes) {
     if (entries.contains(null)) return null;
     final audio = [for (final e in entries) if (e is Waiting) e.audio];
     if (audio.toSet().length != audio.length) return null;
+    final read = version == formatVersion ? _readingsOf(json['readings']) : (null,);
+    if (read == null) return null;
+    final used = version == formatVersion ? _usageOf(json['usage'], read.$1 != null) : (null,);
+    if (used == null) return null;
     return Night(
       id: id,
       firstRecorded: at,
@@ -232,6 +409,8 @@ Night? decodeNight(Uint8List bytes) {
       lang: language,
       name: name,
       entries: entries.cast<Dream>(),
+      readings: read.$1,
+      usage: used.$1,
     );
   }
   return null;
diff --git a/app/test/journal/journal_store_test.dart b/app/test/journal/journal_store_test.dart
--- a/app/test/journal/journal_store_test.dart
+++ b/app/test/journal/journal_store_test.dart
@@ -121,35 +121,38 @@ void main() {
 
   // docs/workflow.md (c): a journal written in version 1 reads whole; a save
   // rewrites only its own night, as version 2, and loses nothing.
-  test('a version-1 journal reads whole; a save rewrites one night', () async {
-    final nights = nightsFromFixtures();
-    await files.open();
-    for (final n in nights) {
-      await files.write(
-        JournalStore.fileOf(n.id),
-        utf8.encode(jsonEncode({...jsonDecode(utf8.decode(encodeNight(n))) as Map<String, Object?>, 'version': 1})),
-      );
-    }
-    final before = files.everything();
-    final store = await JournalStore.open(files);
-    final read = await store.nights();
-    expect(read, nights);
-    expect(read.fold<int>(0, (sum, n) => sum + n.dreams.length), nights.fold<int>(0, (s, n) => s + n.dreams.length));
-    final changed = nights[1].withDreams([...nights[1].dreams, 'x']);
-    await store.save(changed);
-    final after = files.everything();
-    expect(after.keys.toSet(), before.keys.toSet());
-    for (final n in nights) {
-      final name = JournalStore.fileOf(n.id);
-      if (n == nights[1]) {
-        expect(jsonDecode(utf8.decode(after[name]!))['version'], 2);
-      } else {
-        expect(listEquals(after[name], before[name]), isTrue, reason: name);
+  // docs/workflow.md (c); D155 item 2: a journal of an older version reads
+  // whole and unread; a save rewrites only the night saved, as version 3.
+  for (final version in [1, 2]) {
+    test('a version-$version journal reads whole; one save rewrites one night', () async {
+      final nights = nightsFromFixtures();
+      await files.open();
+      for (final n in nights) {
+        final json = {...jsonDecode(utf8.decode(encodeNight(n))) as Map<String, Object?>, 'version': version};
+        await files.write(JournalStore.fileOf(n.id), utf8.encode(jsonEncode(json..remove('readings')..remove('usage'))));
       }
-    }
-    expect(await store.nights(), [for (final n in nights) n == nights[1] ? changed : n]);
-    expect(lines, isEmpty);
-  });
+      final before = files.everything();
+      final store = await JournalStore.open(files);
+      final read = await store.nights();
+      expect(read, nights);
+      expect(read.where((n) => n.readings != null), isEmpty);
+      expect(read.fold<int>(0, (sum, n) => sum + n.dreams.length), nights.fold<int>(0, (s, n) => s + n.dreams.length));
+      final changed = nights[1].withDreams([...nights[1].dreams, 'x']);
+      await store.save(changed);
+      final after = files.everything();
+      expect(after.keys.toSet(), before.keys.toSet());
+      for (final n in nights) {
+        final name = JournalStore.fileOf(n.id);
+        if (n == nights[1]) {
+          expect(jsonDecode(utf8.decode(after[name]!))['version'], 3);
+        } else {
+          expect(listEquals(after[name], before[name]), isTrue, reason: name);
+        }
+      }
+      expect(await store.nights(), [for (final n in nights) n == nights[1] ? changed : n]);
+      expect(lines, isEmpty);
+    });
+  }
 
   // D92 item 1: a recording's audio is kept in the journal's folder,
   // appended as it comes, read back in ranges.
diff --git a/app/test/journal/night_test.dart b/app/test/journal/night_test.dart
--- a/app/test/journal/night_test.dart
+++ b/app/test/journal/night_test.dart
@@ -1,5 +1,5 @@
-// A night and its file format: version 2 written, version 1 still read
-// (D49 b; D92, D93 Q2; docs/workflow.md (c)).
+// A night and its file format: version 3 written, versions 1 and 2 still
+// read (D49 b; D92, D93 Q2; D155 item 2; docs/workflow.md (c)).
 import 'dart:convert';
 import 'dart:math';
 import 'dart:typed_data';
@@ -15,8 +15,25 @@ Map<String, Object?> fields(Night n) =>
 Uint8List bytesOf(Map<String, Object?> json) => utf8.encode(jsonEncode(json));
 
 /// The night as a version-1 file held it: the same fields, version 1, the
-/// dreams as words only.
-Uint8List versionOne(Night n) => bytesOf({...fields(n), 'version': 1});
+/// dreams as words only, no readings or usage.
+Uint8List versionOne(Night n) => bytesOf({...fields(n), 'version': 1}..remove('readings')..remove('usage'));
+
+/// The night as a version-2 file held it: version 2, no readings or usage.
+Uint8List versionTwo(Night n) => bytesOf({...fields(n), 'version': 2}..remove('readings')..remove('usage'));
+
+/// One model call's counts, made up for the tests.
+ModelUsage call([int input = 1200]) => ModelUsage(
+  step: 'readings',
+  model: 'stand-in',
+  input: input,
+  output: 300,
+  cacheRead: 1000,
+  cacheWrite: 0,
+  cost: 9100,
+);
+
+/// Readings made up for the tests: no tradition's words, placeholders.
+final readings = [Reading(0, '[one]'), Reading(4, '[two]'), Reading(1, '[three]')];
 
 /// Two waiting recordings' ids, made up for the tests.
 final audioA = 'a' * 32;
@@ -29,12 +46,14 @@ void main() {
     }
   });
 
-  test('the file holds exactly the version-2 fields', () {
+  test('the file holds exactly the version-3 fields', () {
     final n = nightsFromFixtures().first;
     final json = fields(n);
     expect(json.keys.toSet(),
-        {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'});
-    expect(json['version'], 2);
+        {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams', 'readings', 'usage'});
+    expect(json['version'], 3);
+    expect(json['readings'], isNull);
+    expect(json['usage'], isNull);
     expect(json['id'], n.id);
     expect(json['firstRecorded'], '2026-10-12T06:40:00.000Z');
     expect(json['date'], '2026-10-12');
@@ -45,16 +64,19 @@ void main() {
 
   // docs/workflow.md (c): the old format loads, and the new one loses
   // nothing; every night, dream and field counted before and after.
-  test('every version-1 night reads whole and saves as version 2', () {
+  test('every version-1 night reads whole and saves as version 3', () {
     final nights = nightsFromFixtures();
     var dreams = 0;
     for (final n in nights) {
       final old = jsonDecode(utf8.decode(versionOne(n))) as Map<String, Object?>;
       final read = decodeNight(versionOne(n));
       expect(read, n);
-      final saved = fields(read!);
-      expect(saved['version'], 2);
-      expect(saved.keys.toSet(), old.keys.toSet());
+      expect(read!.readings, isNull);
+      final saved = fields(read);
+      expect(saved['version'], 3);
+      expect(saved.keys.toSet(), {...old.keys, 'readings', 'usage'});
+      expect(saved['readings'], isNull);
+      expect(saved['usage'], isNull);
       for (final key in old.keys.where((k) => k != 'version')) {
         expect(saved[key], old[key], reason: '${n.id} $key');
       }
@@ -65,6 +87,148 @@ void main() {
     expect(dreams, inventedNights().fold<int>(0, (sum, n) => sum + n.dreams.length));
   });
 
+  // docs/workflow.md (c), D155 item 2: every version-2 night, waiting
+  // recordings among its dreams, reads whole and unread, and saves as
+  // version 3 losing nothing; every night, dream and field counted.
+  test('every version-2 night reads whole, unread, and saves as version 3', () {
+    final nights = [
+      for (final (i, n) in nightsFromFixtures().indexed)
+        i.isEven ? n : n.withEntries([...n.entries, Waiting(audioA, 2 * i)]),
+    ];
+    var told = 0;
+    var waiting = 0;
+    for (final n in nights) {
+      final old = jsonDecode(utf8.decode(versionTwo(n))) as Map<String, Object?>;
+      expect(old['version'], 2);
+      final read = decodeNight(versionTwo(n));
+      expect(read, n);
+      expect(read!.readings, isNull);
+      final saved = fields(read);
+      expect(saved['version'], 3);
+      expect(saved.keys.toSet(), {...old.keys, 'readings', 'usage'});
+      for (final key in old.keys.where((k) => k != 'version')) {
+        expect(saved[key], old[key], reason: '${n.id} $key');
+      }
+      told += read.dreams.length;
+      waiting += read.entries.whereType<Waiting>().length;
+    }
+    expect(nights.length, inventedNights().length);
+    expect(told, inventedNights().fold<int>(0, (sum, n) => sum + n.dreams.length));
+    expect(waiting, nights.length ~/ 2);
+  });
+
+  test('a read night keeps its readings, in order, through its file', () {
+    final n = nightsFromFixtures().first.withReadings(readings);
+    expect(fields(n)['readings'], [
+      {'lens': 0, 'text': '[one]'},
+      {'lens': 4, 'text': '[two]'},
+      {'lens': 1, 'text': '[three]'},
+    ]);
+    final read = decodeNight(encodeNight(n))!;
+    expect(read, n);
+    expect(read.readings, readings);
+    expect(read.dreams, n.dreams);
+    expect(read == n.withReadings(readings.reversed.toList()), isFalse);
+    expect(read == nightsFromFixtures().first, isFalse);
+  });
+
+  test("a read night keeps its calls' counts beside its readings", () {
+    final n = nightsFromFixtures().first.withReadings(readings, usage: [call(), call(5)]);
+    expect(fields(n)['usage'], [
+      {'step': 'readings', 'model': 'stand-in', 'input': 1200, 'output': 300, 'cacheRead': 1000, 'cacheWrite': 0, 'cost': 9100},
+      {'step': 'readings', 'model': 'stand-in', 'input': 5, 'output': 300, 'cacheRead': 1000, 'cacheWrite': 0, 'cost': 9100},
+    ]);
+    final read = decodeNight(encodeNight(n))!;
+    expect(read.usage, [call(), call(5)]);
+    expect(read, n);
+    expect(read == n.withReadings(readings, usage: [call(5), call()]), isFalse);
+    expect(read == n.withReadings(readings), isFalse);
+    expect(n.withDreams(['y']).usage, [call(), call(5)]);
+    expect(nightsFromFixtures().first.withReadings(readings, usage: []).usage, isEmpty);
+  });
+
+  test('usage misshapen, or on an unread night, decodes to null', () {
+    final good = fields(nightsFromFixtures().first.withReadings(readings));
+    final whole = call().toJson();
+    for (final (i, u) in <Object?>[
+      {...whole},
+      ['x'],
+      [{...whole, 'input': -1}],
+      [{...whole, 'cost': 1.5}],
+      [{...whole, 'step': ''}],
+      [{...whole, 'model': 7}],
+      [{...whole, 'extra': 1}],
+      [{...whole}..remove('cacheWrite')],
+    ].indexed) {
+      expect(decodeNight(bytesOf({...good, 'usage': u})), isNull, reason: 'case $i');
+    }
+    expect(decodeNight(bytesOf({...good, 'usage': [whole]}))!.usage, [call()]);
+    final unread = fields(nightsFromFixtures().first);
+    expect(decodeNight(bytesOf({...unread, 'usage': [whole]})), isNull);
+  });
+
+  test('usage without readings, or a bad count, is refused', () {
+    final n = nightsFromFixtures().first;
+    expect(
+      () => Night(id: n.id, firstRecorded: n.firstRecorded, date: n.date, closes: n.closes, lang: n.lang, usage: [call()]),
+      throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'usage')),
+    );
+    expect(() => call(-1), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'count')));
+    expect(() => ModelUsage(step: '', model: 'm', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0),
+        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'step')));
+    expect(() => ModelUsage(step: 's', model: '', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0),
+        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'model')));
+  });
+
+  test('a read night stays read when its dreams change', () {
+    final n = nightsFromFixtures().first.withReadings(readings);
+    expect(n.withEntries([Told('x'), Waiting(audioA)]).readings, readings);
+    expect(n.withDreams(['y']).readings, readings);
+  });
+
+  test('readings in a version-1 or version-2 file are refused', () {
+    final read = fields(nightsFromFixtures().first.withReadings(readings));
+    expect(decodeNight(bytesOf({...read, 'version': 1})), isNull);
+    expect(decodeNight(bytesOf({...read, 'version': 2})), isNull);
+    expect(decodeNight(bytesOf({...read, 'version': 2, 'readings': null})), isNull);
+    expect(decodeNight(bytesOf({...read, 'version': 3})), isNotNull);
+  });
+
+  test('misshapen readings decode to null', () {
+    final good = fields(nightsFromFixtures().first);
+    for (final (i, r) in <Object?>[
+      <Object?>[],
+      [for (var k = 0; k < 4; k++) {'lens': k, 'text': '[x]'}],
+      [{'lens': -1, 'text': '[x]'}],
+      [{'lens': 1.0, 'text': '[x]'}],
+      [{'lens': '1', 'text': '[x]'}],
+      [{'lens': 1, 'text': ''}],
+      [{'lens': 1, 'text': 7}],
+      [{'lens': 1}],
+      [{'lens': 1, 'text': '[x]', 'extra': 1}],
+      ['[x]'],
+      {'lens': 1, 'text': '[x]'},
+      '[x]',
+    ].indexed) {
+      expect(decodeNight(bytesOf({...good, 'readings': r})), isNull, reason: 'case $i');
+    }
+    expect(decodeNight(bytesOf({...good, 'readings': [{'lens': 1, 'text': '[x]'}]}))!.readings, [Reading(1, '[x]')]);
+  });
+
+  test('a bad lens, no words, or not one to three: refused', () {
+    expect(() => Reading(-1, '[x]'), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'lens')));
+    expect(() => Reading(0, ''), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'text')));
+    final n = nightsFromFixtures().first;
+    expect(() => n.withReadings([]), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'readings')));
+    expect(() => n.withReadings([...readings, Reading(2, '[four]')]), throwsArgumentError);
+    expect(n.withReadings(readings.take(1).toList()).readings, hasLength(1));
+  });
+
+  test("a night's readings cannot be changed in place", () {
+    final n = nightsFromFixtures().first.withReadings(readings);
+    expect(() => n.readings!.add(Reading(2, '[four]')), throwsUnsupportedError);
+  });
+
   test('a waiting recording keeps its place among the told dreams', () {
     final n = nightsFromFixtures().first;
     final night = n.withEntries([Told(n.dreams.first), Waiting(audioA, 64000), Told('x'), Waiting(audioB)]);
@@ -81,7 +245,8 @@ void main() {
 
   test('a waiting recording is refused in a version-1 file', () {
     final n = nightsFromFixtures().first.withEntries([Waiting(audioA)]);
-    expect(decodeNight(bytesOf({...fields(n), 'version': 1})), isNull);
+    expect(decodeNight(versionTwo(n)), n);
+    expect(decodeNight(versionOne(n)), isNull);
   });
 
   test('a misshapen waiting recording, or one twice, decodes to null', () {
@@ -121,7 +286,7 @@ void main() {
     );
   });
 
-  test('anything not a version-1 or version-2 night decodes to null', () {
+  test('not a night of version 1, 2 or 3: null', () {
     final good = fields(nightsFromFixtures().first);
     Map<String, Object?> without(String key) => {...good}..remove(key);
     Map<String, Object?> with_(String key, Object? value) => {...good, key: value};
@@ -132,7 +297,9 @@ void main() {
       bytesOf(without('dreams')),
       bytesOf(with_('extra', 1)),
       bytesOf(with_('version', 0)),
-      bytesOf(with_('version', 3)),
+      bytesOf(with_('version', 4)),
+      bytesOf(without('readings')),
+      bytesOf(without('usage')),
       bytesOf(with_('version', '2')),
       bytesOf(with_('id', 'ABC')),
       bytesOf(with_('firstRecorded', '2026-10-12T06:40:00.000')),
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A838, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A865, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -62,9 +62,9 @@ ROWS = [
      'if (night == null) {',
      'test/journal/journal_store_test.dart', 'an unreadable file is skipped with a code, never touched'),
     ('A7', 'lib/journal/night.dart',
-     ' || !setEquals(json.keys.toSet(), _keys)',
-     '',
-     'test/journal/night_test.dart', 'anything not a version-1 or version-2 night decodes to null'),
+     '? _readKeys : _keys)) return null;',
+     '? _readKeys : _keys)) {}',
+     'test/journal/night_test.dart', 'not a night of version 1, 2 or 3: null'),
     ('A8', 'lib/journal/self_check.dart',
      '    if (!p.excluded || !p.folderComplete || !p.fileComplete) return _failed(step);\n',
      '',
@@ -833,9 +833,9 @@ ROWS = [
      '',
      'test/journal/pages/typing_page_test.dart', 'a refused microphone shows MP·63, logs a code'),
     ('A148', 'lib/journal/night.dart',
-     '    if (version != formatVersion && version != _firstVersion) return null;\n',
-     '    if (version != formatVersion) return null;\n',
-     'test/journal/night_test.dart', 'every version-1 night reads whole and saves as version 2'),
+     ' && version != _secondVersion && version != _firstVersion) return null;\n',
+     ' && version != _secondVersion) return null;\n',
+     'test/journal/night_test.dart', 'every version-1 night reads whole and saves as version 3'),
     ('A149', 'lib/journal/night.dart',
      'if (version == _firstVersion || x is! Map',
      'if (x is! Map',
@@ -843,7 +843,7 @@ ROWS = [
     ('A150', 'lib/journal/night.dart',
      "      'version': formatVersion,",
      "      'version': 1,",
-     'test/journal/night_test.dart', 'the file holds exactly the version-2 fields'),
+     'test/journal/night_test.dart', 'the file holds exactly the version-3 fields'),
     ('A151', 'lib/journal/night.dart',
      '    if (audio.toSet().length != audio.length) return null;\n',
      '',
@@ -3403,6 +3403,116 @@ ROWS = [
      '|| _invisible.hasMatch(text)) return Submitted.nothing;',
      '|| text.trim().isEmpty) return Submitted.nothing;',
      'test/feedback/feedback_test.dart', 'invisible characters only count as blank: nothing, nothing sent (D156)'),
+    # The night's file, version 3: its readings (D155 item 2).
+    ('A839', 'lib/journal/night.dart',
+     ' && version != _secondVersion && version != _firstVersion) return null;\n',
+     ' && version != _firstVersion) return null;\n',
+     'test/journal/night_test.dart', 'every version-2 night reads whole, unread, and saves as version 3'),
+    ('A840', 'lib/journal/night.dart',
+     "json['version'] == formatVersion ? _readKeys : _keys)) return null;",
+     "(json.containsKey('readings') ? _readKeys : _keys))) return null;",
+     'test/journal/night_test.dart', 'readings in a version-1 or version-2 file are refused'),
+    ('A841', 'lib/journal/night.dart',
+     "json['version'] == formatVersion ? _readKeys : _keys)) return null;",
+     "json['version'] == formatVersion ? _readKeys : _readKeys)) return null;",
+     'test/journal/night_test.dart', 'every version-2 night reads whole, unread, and saves as version 3'),
+    ('A842', 'lib/journal/night.dart',
+     'x.isEmpty || x.length > maxReadings',
+     'x.length > maxReadings',
+     'test/journal/night_test.dart', 'misshapen readings decode to null'),
+    ('A843', 'lib/journal/night.dart',
+     'x.isEmpty || x.length > maxReadings',
+     'x.isEmpty',
+     'test/journal/night_test.dart', 'misshapen readings decode to null'),
+    ('A844', 'lib/journal/night.dart',
+     '    if (r is! Map<String, Object?> || !setEquals(r.keys.toSet(), _readingKeys)) return null;',
+     '    if (r is! Map<String, Object?>) return null;',
+     'test/journal/night_test.dart', 'misshapen readings decode to null'),
+    ('A845', 'lib/journal/night.dart',
+     '|| lens < 0 || text is! String',
+     '|| text is! String',
+     'test/journal/night_test.dart', 'misshapen readings decode to null'),
+    ('A846', 'lib/journal/night.dart',
+     'text is! String || text.isEmpty) return null;',
+     'text is! String) return null;',
+     'test/journal/night_test.dart', 'misshapen readings decode to null'),
+    ('A847', 'lib/journal/night.dart',
+     '      readings: read.$1,',
+     '      readings: null,',
+     'test/journal/night_test.dart', 'a read night keeps its readings, in order, through its file'),
+    ('A848', 'lib/journal/night.dart',
+     'for (final r in readings) {',
+     'for (final r in readings.reversed) {',
+     'test/journal/night_test.dart', 'a read night keeps its readings, in order, through its file'),
+    ('A849', 'lib/journal/night.dart',
+     '      listEquals(other.readings, readings) &&\n',
+     '',
+     'test/journal/night_test.dart', 'a read night keeps its readings, in order, through its file'),
+    ('A850', 'lib/journal/night.dart',
+     '      entries: entries,\n      readings: readings,\n      usage: usage);\n\n  /// The same night, read',
+     '      entries: entries,\n      usage: usage);\n\n  /// The same night, read',
+     'test/journal/night_test.dart', 'a read night stays read when its dreams change'),
+    ('A851', 'lib/journal/night.dart',
+     'readings = readings == null ? null : List.unmodifiable(readings),',
+     'readings = readings,',
+     'test/journal/night_test.dart', "a night's readings cannot be changed in place"),
+    ('A852', 'lib/journal/night.dart',
+     '(readings.isEmpty || readings.length > maxReadings)) throw',
+     '(readings.length > maxReadings)) throw',
+     'test/journal/night_test.dart', 'a bad lens, no words, or not one to three: refused'),
+    ('A853', 'lib/journal/night.dart',
+     '(readings.isEmpty || readings.length > maxReadings)) throw',
+     '(readings.isEmpty)) throw',
+     'test/journal/night_test.dart', 'a bad lens, no words, or not one to three: refused'),
+    ('A854', 'lib/journal/night.dart',
+     "    if (lens < 0) throw ArgumentError('lens');\n",
+     '',
+     'test/journal/night_test.dart', 'a bad lens, no words, or not one to three: refused'),
+    ('A855', 'lib/journal/night.dart',
+     "    if (text.isEmpty) throw ArgumentError('text');\n",
+     '',
+     'test/journal/night_test.dart', 'a bad lens, no words, or not one to three: refused'),
+    # The night's file, version 3: each call's counts beside its readings (head's message 34).
+    ('A856', 'lib/journal/night.dart',
+     "    if (usage != null && readings == null) throw ArgumentError('usage');\n",
+     '',
+     'test/journal/night_test.dart', 'usage without readings, or a bad count, is refused'),
+    ('A857', 'lib/journal/night.dart',
+     "    if (step.isEmpty) throw ArgumentError('step');\n",
+     '',
+     'test/journal/night_test.dart', 'usage without readings, or a bad count, is refused'),
+    ('A858', 'lib/journal/night.dart',
+     "    if (model.isEmpty) throw ArgumentError('model');\n",
+     '',
+     'test/journal/night_test.dart', 'usage without readings, or a bad count, is refused'),
+    ('A859', 'lib/journal/night.dart',
+     ".any((n) => n < 0)) throw ArgumentError('count');",
+     ".any((n) => n < -1)) throw ArgumentError('count');",
+     'test/journal/night_test.dart', 'usage without readings, or a bad count, is refused'),
+    ('A860', 'lib/journal/night.dart',
+     '!setEquals(json.keys.toSet(), _usageKeys)',
+     'json.isEmpty',
+     'test/journal/night_test.dart', 'usage misshapen, or on an unread night, decodes to null'),
+    ('A861', 'lib/journal/night.dart',
+     '  if (x is! List<Object?> || !read) return null;',
+     '  if (x is! List<Object?>) return null;',
+     'test/journal/night_test.dart', 'usage misshapen, or on an unread night, decodes to null'),
+    ('A862', 'lib/journal/night.dart',
+     "      'usage': n.usage?.map((u) => u.toJson()).toList(),",
+     "      'usage': null,",
+     'test/journal/night_test.dart', "a read night keeps its calls' counts beside its readings"),
+    ('A863', 'lib/journal/night.dart',
+     '      usage: used.$1,',
+     '      usage: null,',
+     'test/journal/night_test.dart', "a read night keeps its calls' counts beside its readings"),
+    ('A864', 'lib/journal/night.dart',
+     ' &&\n      listEquals(other.usage, usage);',
+     ';',
+     'test/journal/night_test.dart', "a read night keeps its calls' counts beside its readings"),
+    ('A865', 'lib/journal/night.dart',
+     '      readings: readings,\n      usage: usage);\n\n  /// The same night, read',
+     '      readings: readings);\n\n  /// The same night, read',
+     'test/journal/night_test.dart', "a read night keeps its calls' counts beside its readings"),
 ]
 
 
~~~~

### Task 3 · [OWNER] The storage rehearsal, SoulDreams Dev, invented nights only (docs/workflow.md (c) item 2)

On the simulator, then on the phone, in SoulDreams Dev only (never the Cohort 0 app). Invented nights only: type
them from `fixtures/invented-nights.json` (R2).

1. Build SoulDreams Dev from `main` (version 2) and install it as you always do. Type three invented nights: one of
   one dream, one of three dreams, and one with a recording that waits (record with Wi-Fi and mobile data off, so
   it stays waiting). Note, for each night, its date and its dreams' first words.
2. Check out the commit of Task 2 (`git log --oneline -1` shows its message), build and install SoulDreams Dev the
   same way, over the old one (never delete the app).
3. Expected, by eye: the journal shows the same three nights, in the same order, with the same dates and the
   unread gradient; each night's page shows every dream, in order, word for word; the waiting recording still waits
   (turn the network back on: it is turned into words as before); editing a dream and adding one work as before.
4. Anything different: stop, and bring what you saw (no screenshot of anything but invented nights) to the Build
   chat.
5. Then check out `readings-plumbing` again. The rehearsal on the phone is repeated at Task 9 with the whole build.

### Task 4 · Server: one interface for every model call; POST /reading with the stand-in; the instructions' folder

New: `src/models.ts`, `src/reading.ts`, `src/instructions.ts`, `instructions/AWAITING-INSTRUCTIONS.md` (empty),
`test/models.test.ts`, `test/reading.test.ts`, `test/instructions.test.ts`. Changed: `door.ts`, `handler.ts`,
`safe-log.ts`, `infra/dist.ts`, and the tests of the door, the handler, the logger and the code folder;
`tool/server_mutations.py`. Rows S139 to S178 new; S123 follows.

Checks: `npm run check` clean; `ℹ tests 183`, `ℹ fail 0`; rows S119 to S124 and S139 to S178: `46 run, 46
caught`; every row of the seven changed files: `55 run, 55 caught`. `git status` shows the empty
`server/instructions/AWAITING-INSTRUCTIONS.md` as new (an empty file in a patch is a header with no hunk; if `git
apply` leaves it out, stop, R14).

Commit:

> Server: one interface for every model call, each step's model in one setting, its counts and cost; POST /reading with the stand-in (head's messages 33, 34)

**The block:**

~~~~diff
diff --git a/server/infra/dist.ts b/server/infra/dist.ts
--- a/server/infra/dist.ts
+++ b/server/infra/dist.ts
@@ -1,8 +1,9 @@
 // The Lambda's code folder, dist/src (D42 Q5). `clean` empties dist/
 // before tsc writes it, so no stale file reaches the asset. `mark`
 // writes the module marker beside the compiled files: without it,
-// Lambda reads them as CommonJS and the first import fails.
-import { mkdirSync, rmSync, writeFileSync } from 'node:fs';
+// Lambda reads them as CommonJS and the first import fails; and copies
+// the model's instructions folder beside them (head's message 33).
+import { cpSync, mkdirSync, rmSync, writeFileSync } from 'node:fs';
 
 const DIST = new URL('../dist/', import.meta.url);
 const CODE = new URL('src/', DIST);
@@ -13,6 +14,7 @@ if (step === 'clean') {
 } else if (step === 'mark') {
   mkdirSync(CODE, { recursive: true });
   writeFileSync(new URL('package.json', CODE), '{"type":"module"}\n');
+  cpSync(new URL('../instructions/', import.meta.url), new URL('instructions/', CODE), { recursive: true });
 } else {
   process.exitCode = 2;
 }
diff --git a/server/instructions/AWAITING-INSTRUCTIONS.md b/server/instructions/AWAITING-INSTRUCTIONS.md
new file mode 100644
diff --git a/server/src/door.ts b/server/src/door.ts
--- a/server/src/door.ts
+++ b/server/src/door.ts
@@ -1,13 +1,16 @@
-// The front door (head's message 14; D71; D152): a Lambda function URL with
-// no authentication of its own, and the beta key checked here. POST / with
-// the beta key as a bearer token gets a short-lived Soniox key; POST
-// /feedback with it keeps one feedback (feedback.ts); anything else gets
-// nothing. It reads the method, the path and one header, and the body only
-// for feedback, after the key: never the caller's network address or any
-// other header. It logs codes and numbers only (R3, R4).
+// The front door (head's message 14; D71; D152; head's message 33): a
+// Lambda function URL with no authentication of its own, and the beta key
+// checked here. POST / with the beta key as a bearer token gets a
+// short-lived Soniox key; POST /feedback with it keeps one feedback
+// (feedback.ts); POST /reading with it reads one night (reading.ts);
+// anything else gets nothing. It reads the method, the path and one header,
+// and the body only for feedback and a reading, after the key: never the
+// caller's network address or any other header. It logs codes and numbers
+// only (R3, R4).
 import { isBetaKeyShape, sameKey } from './beta-key.ts';
 import { parseFeedback, utcDay } from './feedback.ts';
 import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from './parameter-names.ts';
+import { parseReading, type Read, type ReadingRequest } from './reading.ts';
 import { safeLog } from './safe-log.ts';
 import { SonioxFailure, type TemporaryKey } from './soniox.ts';
 
@@ -31,10 +34,13 @@ export interface DoorDeps {
   readonly temporaryKey: (projectKey: string) => Promise<TemporaryKey>;
   /** Keeps one feedback's text under its UTC day (D152). */
   readonly keepFeedback: (day: string, text: string) => Promise<void>;
+  /** One night's readings and the calls that made them (head's messages 33, 34). */
+  readonly readNight: (request: ReadingRequest) => Promise<Read>;
   readonly now: () => Date;
 }
 
 const BEARER = 'Bearer ';
+const PATHS = new Set(['/', '/feedback', '/reading']);
 
 export function makeDoor(deps: DoorDeps): (event: DoorEvent) => Promise<Reply> {
   return async (event) => {
@@ -50,13 +56,20 @@ export function makeDoor(deps: DoorDeps): (event: DoorEvent) => Promise<Reply> {
 async function answer(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
   const post = event.requestContext?.http?.method === 'POST';
   const path = event.rawPath;
-  if (!post || (path !== '/' && path !== '/feedback')) {
+  if (!post || path === undefined || !PATHS.has(path)) {
     safeLog('notFound');
     return { statusCode: 404 };
   }
   const refused = await checkBetaKey(event, deps);
   if (refused !== undefined) return refused;
-  return path === '/' ? issueKey(deps) : takeFeedback(event, deps);
+  if (path === '/') return issueKey(deps);
+  return path === '/feedback' ? takeFeedback(event, deps) : giveReading(event, deps);
+}
+
+// The request's body, as text.
+function bodyOf(event: DoorEvent): string {
+  const raw = event.body ?? '';
+  return event.isBase64Encoded === true ? Buffer.from(raw, 'base64').toString('utf8') : raw;
 }
 
 // The beta key, by its shape and then by the kept one; undefined when right.
@@ -107,9 +120,7 @@ async function issueKey(deps: DoorDeps): Promise<Reply> {
 // One feedback (D152): its text alone, under the server's UTC day; 204 when
 // kept, nothing in the reply.
 async function takeFeedback(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
-  const raw = event.body ?? '';
-  const body = event.isBase64Encoded === true ? Buffer.from(raw, 'base64').toString('utf8') : raw;
-  const parsed = parseFeedback(body);
+  const parsed = parseFeedback(bodyOf(event));
   if ('refused' in parsed) {
     safeLog('feedbackRefused', [parsed.refused]);
     return { statusCode: parsed.refused };
@@ -123,3 +134,27 @@ async function takeFeedback(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
   safeLog('feedbackKept');
   return { statusCode: 204 };
 }
+
+// One night's readings (head's messages 33, 34): the night as sent, to the
+// readings step; 200 with the readings and each call's counts and cost,
+// nothing else in the reply. Numbers alone are logged, never a word (R3).
+async function giveReading(event: DoorEvent, deps: DoorDeps): Promise<Reply> {
+  const parsed = parseReading(bodyOf(event));
+  if ('refused' in parsed) {
+    safeLog('readingRefused', [parsed.refused]);
+    return { statusCode: parsed.refused };
+  }
+  let read: Read;
+  try {
+    read = await deps.readNight(parsed.request);
+  } catch {
+    safeLog('readingFailed');
+    return { statusCode: 502 };
+  }
+  safeLog('readingGiven', [read.readings.length]);
+  return {
+    statusCode: 200,
+    headers: { 'content-type': 'application/json' },
+    body: JSON.stringify({ readings: read.readings, usage: read.usage }),
+  };
+}
diff --git a/server/src/handler.ts b/server/src/handler.ts
--- a/server/src/handler.ts
+++ b/server/src/handler.ts
@@ -1,11 +1,17 @@
 // The server's one entry point, behind its function URL (head's message
-// 14; D71; D152): the front door (door.ts), wired to Parameter Store, to
-// Soniox and to the feedback bucket. Everything it decides is in door.ts
-// and feedback.ts and tested there.
+// 14; D71; D152; head's messages 33 and 34): the front door (door.ts),
+// wired to Parameter Store, to Soniox, to the feedback bucket and to the
+// models through their one interface (models.ts): each step's model from
+// SETUP, its caller from [callers] (the stand-in's until Claude's come),
+// handed the instructions read once from the folder beside the code. What
+// it decides is in door.ts, feedback.ts, reading.ts and models.ts.
 import { makeDoor } from './door.ts';
 import { FEEDBACK_BUCKET_VARIABLE } from './feedback.ts';
 import { makeFeedbackStore, putToS3, type Put } from './feedback-store.ts';
+import { type Instruction, INSTRUCTIONS, readInstructions } from './instructions.ts';
 import { readParameter } from './parameters.ts';
+import { type Caller, callModel, type ModelName, PROMPT_CACHING, SETUP, standInCaller } from './models.ts';
+import { readNight } from './reading.ts';
 import { requestTemporaryKey } from './soniox.ts';
 
 /** The door, wired: [env] names the feedback bucket, [put] sends to it. */
@@ -13,11 +19,18 @@ export function wire(
   env: Readonly<Record<string, string | undefined>>,
   put: Put,
   read: (name: string) => Promise<string>,
+  callers: Readonly<Record<ModelName, Caller>> = { 'stand-in': standInCaller },
+  instructions: () => readonly Instruction[] = () => readInstructions(INSTRUCTIONS),
 ) {
+  let held: readonly Instruction[] | undefined;
   return makeDoor({
     readParameter: read,
     temporaryKey: (projectKey) => requestTemporaryKey(projectKey),
     keepFeedback: makeFeedbackStore(env[FEEDBACK_BUCKET_VARIABLE] ?? '', put),
+    readNight: (request) =>
+      readNight((held ??= instructions()), request, (step, prompt) =>
+        callModel(step, prompt, { setup: SETUP, callers, caching: PROMPT_CACHING }),
+      ),
     now: () => new Date(),
   });
 }
diff --git a/server/src/instructions.ts b/server/src/instructions.ts
new file mode 100644
--- /dev/null
+++ b/server/src/instructions.ts
@@ -0,0 +1,26 @@
+// The model's instructions (R7; head's message 33). They are not written
+// yet: they wait for Interpretation's redrafts, and reach the build as files
+// the owner's import copies into server/instructions/, which the build
+// copies into the Lambda's code folder beside the compiled code. Until then
+// the folder holds only the placeholder, empty, which is not an instruction.
+import { readdirSync, readFileSync } from 'node:fs';
+
+/** The empty file that keeps the folder until the instructions come. */
+export const PLACEHOLDER = 'AWAITING-INSTRUCTIONS.md';
+
+/** The folder beside the compiled code (dist/src/instructions). */
+export const INSTRUCTIONS = new URL('instructions/', import.meta.url);
+
+export interface Instruction {
+  readonly name: string;
+  readonly text: string;
+}
+
+/** Every instruction file in [dir], word for word, in name order. */
+export function readInstructions(dir: URL): Instruction[] {
+  return readdirSync(dir, { withFileTypes: true })
+    .filter((f) => f.isFile() && f.name.endsWith('.md') && f.name !== PLACEHOLDER)
+    .map((f) => f.name)
+    .sort()
+    .map((name) => ({ name, text: readFileSync(new URL(name, dir), 'utf8') }));
+}
diff --git a/server/src/models.ts b/server/src/models.ts
new file mode 100644
--- /dev/null
+++ b/server/src/models.ts
@@ -0,0 +1,113 @@
+// Every model call goes through one interface (head's message 34): the
+// step names its model in one setting, so swapping a step's model is one
+// line in SETUP; each model has one caller, the stand-in's included. Every
+// call's tokens (input, output, read from and written to the cache) and its
+// cost are counted and logged as numbers only, never a word (R3). A prompt is
+// fixed text first (the instructions) and the dreamer's words last, so only
+// fixed text could ever be cached; prompt caching stays off until AWS's own
+// pages say it fits retention mode none (C3-T 2d).
+import { safeLog } from './safe-log.ts';
+
+/** The steps that call a model. Only the readings' is built. */
+export const STEPS = ['opening', 'readings', 'checks', 'scenery', 'recurrence'] as const;
+export type Step = (typeof STEPS)[number];
+
+/** The models with a caller. Claude's are added with their caller. */
+export const MODELS = ['stand-in'] as const;
+export type ModelName = (typeof MODELS)[number];
+
+/** A step's model, with its reasoning capped in tokens where it has one. */
+export interface ModelChoice {
+  readonly model: ModelName;
+  readonly reasoningCap?: number;
+}
+
+export type Setup = Readonly<Record<Step, ModelChoice>>;
+
+/** The one setting: the model for each step. */
+export const SETUP: Setup = Object.freeze({
+  opening: { model: 'stand-in' },
+  readings: { model: 'stand-in' },
+  checks: { model: 'stand-in' },
+  scenery: { model: 'stand-in' },
+  recurrence: { model: 'stand-in' },
+});
+
+/** Off until AWS's pages confirm caching fits retention mode none. */
+export const PROMPT_CACHING = false;
+
+/** Fixed text first, in order (the cacheable part); the dreamer's words last. */
+export interface Prompt {
+  readonly fixed: readonly string[];
+  readonly words: string;
+}
+
+export interface Usage {
+  readonly input: number;
+  readonly output: number;
+  readonly cacheRead: number;
+  readonly cacheWrite: number;
+}
+
+/** A model's answer: its text and what it counted. */
+export interface Answer {
+  readonly text: string;
+  readonly usage: Usage;
+}
+
+/** One model's way of answering a prompt. */
+export type Caller = (choice: ModelChoice, prompt: Prompt, cache: boolean) => Promise<Answer>;
+
+/** Millionths of a US dollar per token. */
+export type Price = Usage;
+
+export const PRICES: Readonly<Record<ModelName, Price>> = Object.freeze({
+  'stand-in': { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
+});
+
+/** One call's counts and cost (millionths of a dollar), as the phone keeps them. */
+export interface Call extends Usage {
+  readonly step: Step;
+  readonly model: ModelName;
+  readonly cost: number;
+}
+
+export function costOf(price: Price, usage: Usage): number {
+  return (
+    usage.input * price.input +
+    usage.output * price.output +
+    usage.cacheRead * price.cacheRead +
+    usage.cacheWrite * price.cacheWrite
+  );
+}
+
+export interface CallDeps {
+  readonly setup: Setup;
+  readonly callers: Readonly<Record<ModelName, Caller>>;
+  readonly caching: boolean;
+}
+
+/** Asks [step]'s model; logs the call's counts and cost, numbers only. */
+export async function callModel(step: Step, prompt: Prompt, deps: CallDeps): Promise<{ text: string; call: Call }> {
+  const choice = deps.setup[step];
+  const answer = await deps.callers[choice.model](choice, prompt, deps.caching);
+  const { input, output, cacheRead, cacheWrite } = answer.usage;
+  const cost = costOf(PRICES[choice.model], answer.usage);
+  safeLog('modelUsage', [STEPS.indexOf(step), MODELS.indexOf(choice.model), input, output, cacheRead, cacheWrite, cost]);
+  return { text: answer.text, call: { step, model: choice.model, input, output, cacheRead, cacheWrite, cost } };
+}
+
+/**
+ * The stand-in (head's message 33): fixed placeholder readings, marked as
+ * such, the same whatever it is asked; it reads nothing of the prompt, writes
+ * nothing that imitates the practice (C4-T item 4) and counts no tokens.
+ */
+export const STAND_IN_READINGS = Object.freeze(
+  [1, 2, 3].map((n) => Object.freeze({ lens: n - 1, text: `[STAND-IN · ${n}]` })),
+);
+export const STAND_IN_TEXT = JSON.stringify({ readings: STAND_IN_READINGS });
+
+export const standInCaller: Caller = async () => ({
+  text: STAND_IN_TEXT,
+  usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
+});
diff --git a/server/src/reading.ts b/server/src/reading.ts
new file mode 100644
--- /dev/null
+++ b/server/src/reading.ts
@@ -0,0 +1,98 @@
+// The readings (head's message 33; C3-T 2e): what a request may hold, and
+// the model behind them. A request holds the night's language, its dreams
+// in the dreamer's words and, only while Life Context is on, the sentences
+// it keeps (D134): never an id, a date or anything of the phone (R4).
+// Nothing here logs or keeps anything (R3).
+import type { Instruction } from './instructions.ts';
+import { type Call, type Prompt, STAND_IN_READINGS as MODEL_STAND_IN, type Step } from './models.ts';
+
+/** A body longer than this is refused before it is read. */
+export const READING_BODY_LIMIT = 262144;
+
+export type Lang = 'en' | 'sv';
+
+export interface ReadingRequest {
+  readonly lang: Lang;
+  readonly dreams: readonly string[];
+  /** Empty while Life Context is off: nothing kept was sent. */
+  readonly kept: readonly string[];
+}
+
+/** One reading: its tradition, as its place among the lens labels (W13), and its words. */
+export interface Reading {
+  readonly lens: number;
+  readonly text: string;
+}
+
+export type ParsedReading = { readonly request: ReadingRequest } | { readonly refused: 400 | 413 };
+
+const KEYS = new Set(['lang', 'dreams', 'kept']);
+
+const strings = (x: unknown): x is string[] => Array.isArray(x) && x.every((s) => typeof s === 'string');
+
+/** One night's request, as sent; or the status that refuses it. */
+export function parseReading(body: string): ParsedReading {
+  if (body.length > READING_BODY_LIMIT) return { refused: 413 };
+  let parsed: unknown;
+  try {
+    parsed = JSON.parse(body);
+  } catch {
+    return { refused: 400 };
+  }
+  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) return { refused: 400 };
+  const json = parsed as Record<string, unknown>;
+  if (!Object.keys(json).every((k) => KEYS.has(k))) return { refused: 400 };
+  const { lang, dreams, kept = [] } = json;
+  if (lang !== 'en' && lang !== 'sv') return { refused: 400 };
+  if (!strings(dreams) || dreams.length === 0 || dreams.some((d) => d.trim() === '')) return { refused: 400 };
+  if (!strings(kept)) return { refused: 400 };
+  return { request: { lang, dreams, kept } };
+}
+
+/** The readings' prompt: the instructions first, in their order; the night last. */
+export function promptFor(instructions: readonly Instruction[], request: ReadingRequest): Prompt {
+  return { fixed: instructions.map((i) => i.text), words: JSON.stringify(request) };
+}
+
+const READING_KEYS = ['lens', 'text'];
+
+/** The model's text as one to three whole readings, or null. */
+export function parseReadings(text: string): Reading[] | null {
+  let parsed: unknown;
+  try {
+    parsed = JSON.parse(text);
+  } catch {
+    return null;
+  }
+  if (typeof parsed !== 'object' || parsed === null || Array.isArray(parsed)) return null;
+  const json = parsed as Record<string, unknown>;
+  const list = json['readings'];
+  if (Object.keys(json).length !== 1 || !Array.isArray(list) || list.length === 0 || list.length > 3) return null;
+  const readings: Reading[] = [];
+  for (const r of list as unknown[]) {
+    if (typeof r !== 'object' || r === null || Object.keys(r).sort().join() !== READING_KEYS.join()) return null;
+    const { lens, text: words } = r as Record<string, unknown>;
+    if (!Number.isInteger(lens) || (lens as number) < 0 || typeof words !== 'string' || words === '') return null;
+    readings.push({ lens: lens as number, text: words });
+  }
+  return readings;
+}
+
+/** A night's readings, and the calls that made them. */
+export interface Read {
+  readonly readings: readonly Reading[];
+  readonly usage: readonly Call[];
+}
+
+export type Ask = (step: Step, prompt: Prompt) => Promise<{ text: string; call: Call }>;
+
+/** Reads one night: the readings step, through [ask]; an answer that is not readings fails. */
+export async function readNight(instructions: readonly Instruction[], request: ReadingRequest, ask: Ask): Promise<Read> {
+  const { text, call } = await ask('readings', promptFor(instructions, request));
+  const readings = parseReadings(text);
+  if (readings === null) throw new Error('reading-unreadable');
+  return { readings, usage: [call] };
+}
+
+/** The stand-in's readings (models.ts), as a night's readings. */
+export const STAND_IN_READINGS: readonly Reading[] = MODEL_STAND_IN;
diff --git a/server/src/safe-log.ts b/server/src/safe-log.ts
--- a/server/src/safe-log.ts
+++ b/server/src/safe-log.ts
@@ -17,6 +17,15 @@ export const LOG_EVENTS = [
   'feedbackKept',
   'feedbackRefused',
   'feedbackFailed',
+  // A night's readings (head's message 33): given (with their count);
+  // refused (with its status, 400 or 413); the model failing. Never a word.
+  'readingGiven',
+  'readingRefused',
+  'readingFailed',
+  // Every model call (head's message 34): its step and model (their places
+  // in STEPS and MODELS), its input, output, cache-read and cache-written
+  // tokens, and its cost in millionths of a dollar. Numbers only.
+  'modelUsage',
 ] as const;
 export type LogEvent = (typeof LOG_EVENTS)[number];
 
diff --git a/server/test/dist.test.ts b/server/test/dist.test.ts
--- a/server/test/dist.test.ts
+++ b/server/test/dist.test.ts
@@ -1,12 +1,13 @@
-// The Lambda's code folder (D42 Q5): the compiled code alone, with the
-// module marker beside it. `npm test` builds it first.
+// The Lambda's code folder (D42 Q5): the compiled code, with the module
+// marker and the model's instructions folder beside it (head's message 33).
+// `npm test` builds it first.
 import assert from 'node:assert/strict';
 import { readdirSync, readFileSync } from 'node:fs';
 import { test } from 'node:test';
 
 const CODE = new URL('../dist/src/', import.meta.url);
 
-test('the compiled files and the marker, nothing else', () => {
+test('the compiled files, the marker and the instructions, nothing else', () => {
   const files = readdirSync(CODE, { recursive: true }).map(String).sort();
   assert.deepEqual(files, [
     'beta-key.js',
@@ -15,9 +16,14 @@ test('the compiled files and the marker, nothing else', () => {
     'feedback.js',
     'handler.js',
     'hosts.js',
+    'instructions',
+    'instructions.js',
+    'instructions/AWAITING-INSTRUCTIONS.md',
+    'models.js',
     'package.json',
     'parameter-names.js',
     'parameters.js',
+    'reading.js',
     'safe-log.js',
     'soniox.js',
   ]);
@@ -41,5 +47,9 @@ test("imports: its own, Node's, and the two AWS clients", () => {
       if (!from.startsWith('./')) outside.add(from);
     }
   }
-  assert.deepEqual([...outside].sort(), ['@aws-sdk/client-s3', '@aws-sdk/client-ssm', 'node:crypto']);
+  assert.deepEqual([...outside].sort(), ['@aws-sdk/client-s3', '@aws-sdk/client-ssm', 'node:crypto', 'node:fs']);
+});
+
+test('the instructions folder is copied whole, the placeholder empty', () => {
+  assert.equal(readFileSync(new URL('instructions/AWAITING-INSTRUCTIONS.md', CODE), 'utf8'), '');
 });
diff --git a/server/test/door.test.ts b/server/test/door.test.ts
--- a/server/test/door.test.ts
+++ b/server/test/door.test.ts
@@ -1,12 +1,17 @@
-// The front door (head's message 14; D71; D152): POST / with the beta key
-// gets a short-lived Soniox key; POST /feedback with it keeps one feedback;
-// anything else gets nothing, with one code. It never touches the caller's
-// address or another header, and reads a body only for feedback, after the
-// key (R3, R4).
+// The front door (head's message 14; D71; D152; head's message 33): POST /
+// with the beta key gets a short-lived Soniox key; POST /feedback with it
+// keeps one feedback; POST /reading with it reads one night; anything else
+// gets nothing, with one code. It never touches the caller's address or
+// another header, and reads a body only for feedback and a reading, after
+// the key (R3, R4).
 import assert from 'node:assert/strict';
 import { afterEach, beforeEach, test } from 'node:test';
 import { type DoorDeps, type DoorEvent, makeDoor } from '../src/door.ts';
 import { BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER } from '../src/parameter-names.ts';
+import { type ReadingRequest, STAND_IN_READINGS } from '../src/reading.ts';
+
+// The stand-in's one call, as the readings step reports it.
+const USAGE = [{ step: 'readings', model: 'stand-in', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 }] as const;
 import { setSink } from '../src/safe-log.ts';
 import { SonioxFailure } from '../src/soniox.ts';
 
@@ -33,10 +38,11 @@ interface Calls {
   read: string[];
   soniox: string[];
   kept: [string, string][];
+  nights: ReadingRequest[];
 }
 
 function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
-  const calls: Calls = { read: [], soniox: [], kept: [] };
+  const calls: Calls = { read: [], soniox: [], kept: [], nights: [] };
   return {
     calls,
     deps: {
@@ -51,6 +57,10 @@ function deps(over: Partial<DoorDeps> = {}): { deps: DoorDeps; calls: Calls } {
       keepFeedback: async (day, text) => {
         calls.kept.push([day, text]);
       },
+      readNight: async (request) => {
+        calls.nights.push(request);
+        return { readings: STAND_IN_READINGS, usage: USAGE };
+      },
       now: () => NOW,
       ...over,
     },
@@ -133,6 +143,9 @@ test('another method or path: 404, nothing read', async () => {
     ['GET', '/feedback'],
     ['POST', '/feedback/'],
     ['POST', '/Feedback'],
+    ['GET', '/reading'],
+    ['POST', '/reading/'],
+    ['POST', '/readings'],
   ] as const) {
     const d = deps();
     lines = [];
@@ -259,3 +272,73 @@ test('feedback: Parameter Store failing: 500, nothing kept', async () => {
   assert.deepEqual(d.calls.kept, []);
   assert.deepEqual(lines, ['parameterFailed']);
 });
+
+const night = JSON.stringify({ lang: 'sv', dreams: ['Ett hus vid vattnet.'], kept: [] });
+
+test('a reading: 200, the readings, the night as sent, its count', async () => {
+  const d = deps();
+  const reply = await makeDoor(d.deps)(event('POST', '/reading', `Bearer ${KEY}`, night));
+  assert.deepEqual(reply, {
+    statusCode: 200,
+    headers: { 'content-type': 'application/json' },
+    body: JSON.stringify({ readings: STAND_IN_READINGS, usage: USAGE }),
+  });
+  assert.deepEqual(d.calls.nights, [{ lang: 'sv', dreams: ['Ett hus vid vattnet.'], kept: [] }]);
+  assert.deepEqual(d.calls.read, [BETA_KEY_PARAMETER]);
+  assert.deepEqual(d.calls.soniox, []);
+  assert.deepEqual(d.calls.kept, []);
+  assert.deepEqual(lines, ['readingGiven 3']);
+});
+
+test('a reading: a base64 body is read as its text', async () => {
+  const d = deps();
+  const body = Buffer.from(night, 'utf8').toString('base64');
+  assert.equal((await makeDoor(d.deps)(event('POST', '/reading', `Bearer ${KEY}`, body, true))).statusCode, 200);
+  assert.deepEqual(d.calls.nights[0]?.dreams, ['Ett hus vid vattnet.']);
+});
+
+test('a reading: a bad key refused before the body is read', async () => {
+  for (const authorization of [`Bearer ${KEY.slice(0, 47)}1`, undefined, 'Bearer short']) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/reading', authorization)), { statusCode: 401 });
+    assert.deepEqual(d.calls.nights, []);
+    assert.deepEqual(lines, ['keyRefused']);
+  }
+});
+
+test('a reading: refused, nothing read, its status logged', async () => {
+  for (const [body, status] of [
+    ['', 400],
+    [JSON.stringify({ lang: 'en', dreams: [] }), 400],
+    [JSON.stringify({ lang: 'en', dreams: ['a'], id: 'x' }), 400],
+    [JSON.stringify({ lang: 'en', dreams: ['a'.repeat(262144)] }), 413],
+  ] as const) {
+    const d = deps();
+    lines = [];
+    assert.deepEqual(await makeDoor(d.deps)(event('POST', '/reading', `Bearer ${KEY}`, body)), { statusCode: status });
+    assert.deepEqual(d.calls.nights, []);
+    assert.deepEqual(lines, [`readingRefused ${status}`]);
+  }
+});
+
+test('a reading: the model failing: 502 and a code', async () => {
+  const d = deps({
+    readNight: async () => {
+      throw new Error('invented failure text');
+    },
+  });
+  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/reading', `Bearer ${KEY}`, night)), { statusCode: 502 });
+  assert.deepEqual(lines, ['readingFailed']);
+});
+
+test('a reading: Parameter Store failing: 500, nothing read', async () => {
+  const d = deps({
+    readParameter: async () => {
+      throw new Error('invented failure text');
+    },
+  });
+  assert.deepEqual(await makeDoor(d.deps)(event('POST', '/reading', `Bearer ${KEY}`, night)), { statusCode: 500 });
+  assert.deepEqual(d.calls.nights, []);
+  assert.deepEqual(lines, ['parameterFailed']);
+});
diff --git a/server/test/handler.test.ts b/server/test/handler.test.ts
--- a/server/test/handler.test.ts
+++ b/server/test/handler.test.ts
@@ -5,6 +5,8 @@ import assert from 'node:assert/strict';
 import { afterEach, beforeEach, test } from 'node:test';
 import type { PutInput } from '../src/feedback-store.ts';
 import { handler, wire } from '../src/handler.ts';
+import { type Caller, STAND_IN_TEXT } from '../src/models.ts';
+import { STAND_IN_READINGS } from '../src/reading.ts';
 import { setSink } from '../src/safe-log.ts';
 
 const KEY = 'Ab0'.repeat(16);
@@ -87,3 +89,49 @@ test('no bucket named: feedback fails with 502 and nothing is sent', async () =>
   assert.deepEqual(puts, []);
   assert.deepEqual(lines, ['feedbackFailed']);
 });
+
+// The wiring of a reading (head's messages 33 and 34): the readings step's
+// model, through the one interface, handed the instructions read from the
+// folder beside the code, first, and the night last.
+test("a reading goes to its step's model with the folder's instructions", async () => {
+  const seen: unknown[] = [];
+  const caller: Caller = async (choice, prompt, cache) => {
+    seen.push([choice, prompt, cache]);
+    return { text: JSON.stringify({ readings: [{ lens: 1, text: '[x]' }] }), usage: { input: 3, output: 2, cacheRead: 0, cacheWrite: 0 } };
+  };
+  const door = wire({}, async () => {}, async () => KEY, { 'stand-in': caller }, () => [{ name: 'a.md', text: 'b' }]);
+  const reply = await door({
+    rawPath: '/reading',
+    headers: { authorization: `Bearer ${KEY}` },
+    body: JSON.stringify({ lang: 'en', dreams: ['A red door.'] }),
+    requestContext: { http: { method: 'POST' } },
+  });
+  assert.deepEqual(reply.statusCode, 200);
+  assert.deepEqual(JSON.parse(reply.body ?? ''), {
+    readings: [{ lens: 1, text: '[x]' }],
+    usage: [{ step: 'readings', model: 'stand-in', input: 3, output: 2, cacheRead: 0, cacheWrite: 0, cost: 0 }],
+  });
+  const night = JSON.stringify({ lang: 'en', dreams: ['A red door.'], kept: [] });
+  assert.deepEqual(seen, [[{ model: 'stand-in' }, { fixed: ['b'], words: night }, false]]);
+  assert.deepEqual(lines, ['modelUsage 1 0 3 2 0 0 0', 'readingGiven 1']);
+});
+
+test('the handler reads with the stand-in, and the instructions once', async () => {
+  let reads = 0;
+  const door = wire({}, async () => {}, async () => KEY, undefined, () => {
+    reads++;
+    return [];
+  });
+  const send = () =>
+    door({
+      rawPath: '/reading',
+      headers: { authorization: `Bearer ${KEY}` },
+      body: JSON.stringify({ lang: 'sv', dreams: ['x'] }),
+      requestContext: { http: { method: 'POST' } },
+    });
+  const first = await send();
+  await send();
+  assert.equal(reads, 1);
+  assert.deepEqual(JSON.parse(first.body ?? '').readings, STAND_IN_READINGS);
+  assert.equal(JSON.parse(STAND_IN_TEXT).readings.length, 3);
+});
diff --git a/server/test/instructions.test.ts b/server/test/instructions.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/instructions.test.ts
@@ -0,0 +1,37 @@
+// The model's instructions (R7; head's message 33): files dropped into
+// server/instructions/, read in name order; the placeholder is not one.
+import assert from 'node:assert/strict';
+import { mkdtempSync, readdirSync, readFileSync, writeFileSync, mkdirSync } from 'node:fs';
+import { tmpdir } from 'node:os';
+import { join } from 'node:path';
+import { pathToFileURL } from 'node:url';
+import { test } from 'node:test';
+import { PLACEHOLDER, readInstructions } from '../src/instructions.ts';
+
+const folder = (files: Record<string, string>): URL => {
+  const dir = mkdtempSync(join(tmpdir(), 'instructions-'));
+  for (const [name, text] of Object.entries(files)) {
+    if (name.endsWith('/')) mkdirSync(join(dir, name));
+    else writeFileSync(join(dir, name), text);
+  }
+  return pathToFileURL(`${dir}/`);
+};
+
+test('the folder holds only the placeholder, and it is empty', () => {
+  const here = new URL('../instructions/', import.meta.url);
+  assert.deepEqual(readdirSync(here), [PLACEHOLDER]);
+  assert.equal(readFileSync(new URL(PLACEHOLDER, here), 'utf8'), '');
+  assert.deepEqual(readInstructions(here), []);
+});
+
+test('every .md file but the placeholder, in name order, unchanged', () => {
+  const dir = folder({ [PLACEHOLDER]: '', 'b.md': 'two\n', 'a.md': 'one', 'c.txt': 'no', 'e.md/': '' });
+  assert.deepEqual(readInstructions(dir), [
+    { name: 'a.md', text: 'one' },
+    { name: 'b.md', text: 'two\n' },
+  ]);
+});
+
+test('no folder: an error, never an empty set of instructions', () => {
+  assert.throws(() => readInstructions(new URL('gone/', folder({ 'a.md': 'x' }))));
+});
diff --git a/server/test/models.test.ts b/server/test/models.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/models.test.ts
@@ -0,0 +1,87 @@
+// Every model call through one interface (head's message 34): the model
+// named per step in one setting; each call's tokens and cost counted and
+// logged as numbers only; prompt caching off until AWS's pages say it fits
+// retention mode none; the stand-in behind it like any model.
+import assert from 'node:assert/strict';
+import { afterEach, beforeEach, test } from 'node:test';
+import {
+  type Caller,
+  MODELS,
+  PRICES,
+  PROMPT_CACHING,
+  SETUP,
+  STAND_IN_TEXT,
+  STEPS,
+  callModel,
+  costOf,
+  standInCaller,
+} from '../src/models.ts';
+import { setSink } from '../src/safe-log.ts';
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
+const prompt = { fixed: ['instructions'], words: '{"dreams":["a"]}' };
+
+test('the steps, and one setting naming each step its model', () => {
+  assert.deepEqual(STEPS, ['opening', 'readings', 'checks', 'scenery', 'recurrence']);
+  assert.deepEqual(MODELS, ['stand-in']);
+  assert.deepEqual(Object.keys(SETUP), [...STEPS]);
+  for (const step of STEPS) assert.deepEqual(SETUP[step], { model: 'stand-in' });
+  assert.ok(Object.isFrozen(SETUP));
+});
+
+test('prompt caching is off until confirmed', () => {
+  assert.equal(PROMPT_CACHING, false);
+});
+
+test("a call goes to its step's model, prompt and caching switch", async () => {
+  const seen: unknown[] = [];
+  const caller: Caller = async (choice, p, cache) => {
+    seen.push([choice, p, cache]);
+    return { text: 'x', usage: { input: 10, output: 2, cacheRead: 3, cacheWrite: 4 } };
+  };
+  const setup = { ...SETUP, readings: { model: 'stand-in' as const, reasoningCap: 64 } };
+  const answer = await callModel('readings', prompt, { setup, callers: { 'stand-in': caller }, caching: false });
+  assert.deepEqual(seen, [[{ model: 'stand-in', reasoningCap: 64 }, prompt, false]]);
+  assert.deepEqual(answer, {
+    text: 'x',
+    call: { step: 'readings', model: 'stand-in', input: 10, output: 2, cacheRead: 3, cacheWrite: 4, cost: 0 },
+  });
+});
+
+test('each call logs its step, model, tokens and cost, numbers only', async () => {
+  const caller: Caller = async () => ({ text: 'never logged', usage: { input: 7, output: 5, cacheRead: 1, cacheWrite: 2 } });
+  await callModel('scenery', prompt, { setup: SETUP, callers: { 'stand-in': caller }, caching: false });
+  assert.deepEqual(lines, ['modelUsage 3 0 7 5 1 2 0']);
+});
+
+test('the cost: each count at its price, in millionths', () => {
+  assert.deepEqual(PRICES['stand-in'], { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 });
+  const price = { input: 4, output: 20, cacheRead: 1, cacheWrite: 5 };
+  assert.equal(costOf(price, { input: 1000, output: 100, cacheRead: 10, cacheWrite: 2 }), 4000 + 2000 + 10 + 10);
+});
+
+test("a model failing: the call fails, nothing logged", async () => {
+  const caller: Caller = async () => {
+    throw new Error('invented failure text');
+  };
+  await assert.rejects(callModel('readings', prompt, { setup: SETUP, callers: { 'stand-in': caller }, caching: false }));
+  assert.deepEqual(lines, []);
+});
+
+test('the stand-in: the same placeholder, zero tokens, whatever asked', async () => {
+  const one = await standInCaller({ model: 'stand-in' }, prompt, false);
+  const two = await standInCaller({ model: 'stand-in' }, { fixed: [], words: 'other' }, true);
+  assert.deepEqual(one, { text: STAND_IN_TEXT, usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 } });
+  assert.deepEqual(two, one);
+});
diff --git a/server/test/reading.test.ts b/server/test/reading.test.ts
new file mode 100644
--- /dev/null
+++ b/server/test/reading.test.ts
@@ -0,0 +1,115 @@
+// The readings' request and the stand-in model (head's message 33; D134):
+// what a request may hold, and the fixed placeholder readings the stand-in
+// gives for every night, reading nothing of it.
+import assert from 'node:assert/strict';
+import { test } from 'node:test';
+import { STAND_IN_TEXT } from '../src/models.ts';
+import {
+  READING_BODY_LIMIT,
+  STAND_IN_READINGS,
+  parseReading,
+  parseReadings,
+  promptFor,
+  readNight,
+} from '../src/reading.ts';
+
+const night = (over: Record<string, unknown> = {}): string => JSON.stringify({ lang: 'en', dreams: ['a', 'b'], ...over });
+
+test('a night: its language, dreams, and kept sentences when sent', () => {
+  assert.deepEqual(parseReading(night()), { request: { lang: 'en', dreams: ['a', 'b'], kept: [] } });
+  assert.deepEqual(parseReading(night({ lang: 'sv', kept: ['c'] })), {
+    request: { lang: 'sv', dreams: ['a', 'b'], kept: ['c'] },
+  });
+  assert.deepEqual(parseReading(night({ kept: [] })), { request: { lang: 'en', dreams: ['a', 'b'], kept: [] } });
+});
+
+test('anything else: 400', () => {
+  for (const body of [
+    '',
+    'not json',
+    '[]',
+    'null',
+    JSON.stringify({ dreams: ['a'] }),
+    JSON.stringify({ lang: 'en' }),
+    night({ lang: 'de' }),
+    night({ dreams: [] }),
+    night({ dreams: 'a' }),
+    night({ dreams: ['a', 1] }),
+    night({ dreams: ['a', ' \n '] }),
+    night({ kept: 'c' }),
+    night({ kept: ['c', 2] }),
+    night({ kept: null }),
+    night({ id: 'x' }),
+  ]) {
+    assert.deepEqual(parseReading(body), { refused: 400 }, body);
+  }
+});
+
+test('a body over the limit: 413, unread', () => {
+  const at = night({ dreams: ['a'.repeat(READING_BODY_LIMIT - night({ dreams: [''] }).length)] });
+  assert.equal(at.length, READING_BODY_LIMIT);
+  assert.ok('request' in parseReading(at));
+  assert.deepEqual(parseReading(`${at} `), { refused: 413 });
+});
+
+test("the prompt: the instructions first, in their order; the night last", () => {
+  const request = { lang: 'sv' as const, dreams: ['Ett hus.'], kept: ['En mening.'] };
+  const p = promptFor([{ name: 'a.md', text: 'one' }, { name: 'b.md', text: 'two' }], request);
+  assert.deepEqual(p.fixed, ['one', 'two']);
+  assert.equal(p.words, JSON.stringify(request));
+  // Nothing of the night in the fixed, cacheable part.
+  assert.ok(p.fixed.every((f) => !f.includes('Ett hus') && !f.includes('En mening')));
+});
+
+test("the model's answer: one to three whole readings, or null", () => {
+  const r = (n: number) => Array.from({ length: n }, (_, i) => ({ lens: i, text: '[x]' }));
+  assert.deepEqual(parseReadings(JSON.stringify({ readings: r(1) })), r(1));
+  assert.deepEqual(parseReadings(JSON.stringify({ readings: r(3) })), r(3));
+  for (const text of [
+    'not json',
+    '[]',
+    JSON.stringify({ readings: [] }),
+    JSON.stringify({ readings: r(4) }),
+    JSON.stringify({ readings: [{ lens: -1, text: '[x]' }] }),
+    JSON.stringify({ readings: [{ lens: 1.5, text: '[x]' }] }),
+    JSON.stringify({ readings: [{ lens: 1, text: '' }] }),
+    JSON.stringify({ readings: [{ lens: 1, text: '[x]', more: 1 }] }),
+    JSON.stringify({ readings: r(1), more: 1 }),
+  ]) {
+    assert.equal(parseReadings(text), null, text);
+  }
+});
+
+test('the stand-in: three placeholder readings, marked, the same for every night', async () => {
+  assert.deepEqual(STAND_IN_READINGS, [
+    { lens: 0, text: '[STAND-IN · 1]' },
+    { lens: 1, text: '[STAND-IN · 2]' },
+    { lens: 2, text: '[STAND-IN · 3]' },
+  ]);
+  assert.equal(STAND_IN_TEXT, JSON.stringify({ readings: STAND_IN_READINGS }));
+  assert.deepEqual(parseReadings(STAND_IN_TEXT), STAND_IN_READINGS);
+  assert.ok(Object.isFrozen(STAND_IN_READINGS) && STAND_IN_READINGS.every((r) => Object.isFrozen(r)));
+});
+
+test('a night read: the readings step, prompt, readings, one call', async () => {
+  const request = { lang: 'en' as const, dreams: ['A red door.'], kept: [] };
+  const seen: unknown[] = [];
+  const read = await readNight([{ name: 'a.md', text: 'one' }], request, async (step, p) => {
+    seen.push([step, p]);
+    return { text: STAND_IN_TEXT, call: { step, model: 'stand-in', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 } };
+  });
+  assert.deepEqual(seen, [['readings', { fixed: ['one'], words: JSON.stringify(request) }]]);
+  assert.deepEqual(read, {
+    readings: STAND_IN_READINGS,
+    usage: [{ step: 'readings', model: 'stand-in', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 }],
+  });
+});
+
+test('an answer that is not readings fails the night', async () => {
+  await assert.rejects(
+    readNight([], { lang: 'en', dreams: ['a'], kept: [] }, async (step) => ({
+      text: 'not readings',
+      call: { step, model: 'stand-in', input: 1, output: 1, cacheRead: 0, cacheWrite: 0, cost: 0 },
+    })),
+  );
+});
diff --git a/server/test/safe-log.test.ts b/server/test/safe-log.test.ts
--- a/server/test/safe-log.test.ts
+++ b/server/test/safe-log.test.ts
@@ -27,6 +27,10 @@ test('the events are these', () => {
     'feedbackKept',
     'feedbackRefused',
     'feedbackFailed',
+    'readingGiven',
+    'readingRefused',
+    'readingFailed',
+    'modelUsage',
   ]);
 });
 
diff --git a/tool/server_mutations.py b/tool/server_mutations.py
--- a/tool/server_mutations.py
+++ b/tool/server_mutations.py
@@ -1,4 +1,4 @@
-# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147; S110 to S135, D152), run by hand from the repository
+# The server's mutation checks (D43 Q3; S17 to S30, D71; S31 to S85, D135, D138, D139, D141, D144; S86 to S109, D147; S110 to S138, D152; S139 to S161, head's message 33; S162 to S178, head's message 34), run by hand from the repository
 # root: python3 -I -B tool/server_mutations.py
 # First the unbroken server, copied, must pass its type check and tests.
 # Then each row breaks one thing in a copy of server/ in the temporary
@@ -363,7 +363,7 @@ ROWS = [
      'test', 'feedback: the store failing: 502 and a code'),
     ('S122', 'src/door.ts', "safeLog('feedbackRefused', [parsed.refused]);", "safeLog('feedbackRefused');",
      'test', 'feedback: refused, nothing kept, its status logged'),
-    ('S123', 'src/door.ts', "path !== '/feedback')", "!(path ?? '').startsWith('/feedback'))",
+    ('S123', 'src/door.ts', '!PATHS.has(path)', '!PATHS.has(path.toLowerCase())',
      'test', 'another method or path: 404, nothing read'),
     ('S124', 'src/door.ts', 'utcDay(deps.now())', 'utcDay(new Date())',
      'test', 'feedback: kept under its UTC day, 204, one code'),
@@ -397,6 +397,128 @@ ROWS = [
      'test', 'feedback goes to the bucket the variable names'),
     ('S138', 'src/handler.ts', "?? ''", "?? 'a-bucket'",
      'test', 'no bucket named: feedback fails with 502 and nothing is sent'),
+    # The readings with the stand-in model, and the instructions' folder (head's message 33).
+    ('S139', 'src/reading.ts', 'if (body.length > READING_BODY_LIMIT)',
+     'if (body.length >= READING_BODY_LIMIT)',
+     'test', 'a body over the limit: 413, unread'),
+    ('S140', 'src/reading.ts', '(k) => KEYS.has(k))',
+     "(k) => KEYS.has(k) || k === 'id')",
+     'test', 'anything else: 400'),
+    ('S141', 'src/reading.ts', 'return { request: { lang, dreams, kept } };',
+     "return { request: { lang: 'en', dreams, kept } };",
+     'test', 'a night: its language, dreams, and kept sentences when sent'),
+    ('S142', 'src/reading.ts', 'dreams.length === 0 || ',
+     '',
+     'test', 'anything else: 400'),
+    ('S143', 'src/reading.ts', " || dreams.some((d) => d.trim() === '')",
+     '',
+     'test', 'anything else: 400'),
+    ('S144', 'src/reading.ts', "Array.isArray(x) && x.every((s) => typeof s === 'string')",
+     'Array.isArray(x)',
+     'test', 'anything else: 400'),
+    ('S145', 'src/reading.ts', 'kept = [] }',
+     "kept = ['x'] }",
+     'test', 'a night: its language, dreams, and kept sentences when sent'),
+    ('S146', 'src/models.ts', 'Caller = async () => ({\n  text: STAND_IN_TEXT,',
+     'Caller = async (_, p) => ({\n  text: p.words,',
+     'test', 'the stand-in: the same placeholder, zero tokens, whatever asked'),
+    ('S147', 'src/models.ts', 'Object.freeze({ lens',
+     '({ lens',
+     'test', 'the stand-in: three placeholder readings, marked, the same for every night'),
+    ('S148', 'src/instructions.ts', ' && f.name !== PLACEHOLDER)',
+     ')',
+     'test', 'the folder holds only the placeholder, and it is empty'),
+    ('S149', 'src/instructions.ts', '    .sort()\n',
+     '    .sort()\n    .reverse()\n',
+     'test', 'every .md file but the placeholder, in name order, unchanged'),
+    ('S150', 'src/instructions.ts', "f.name.endsWith('.md') && ",
+     '',
+     'test', 'every .md file but the placeholder, in name order, unchanged'),
+    ('S151', 'src/instructions.ts', 'f.isFile() && ',
+     '',
+     'test', 'every .md file but the placeholder, in name order, unchanged'),
+    ('S152', 'src/door.ts', "'/feedback', '/reading']",
+     "'/feedback']",
+     'test', 'a reading: 200, the readings, the night as sent, its count'),
+    ('S153', 'src/door.ts', "safeLog('readingGiven', [read.readings.length]);",
+     "safeLog('readingGiven');",
+     'test', 'a reading: 200, the readings, the night as sent, its count'),
+    ('S154', 'src/door.ts', "safeLog('readingRefused', [parsed.refused]);",
+     "safeLog('readingRefused');",
+     'test', 'a reading: refused, nothing read, its status logged'),
+    ('S155', 'src/door.ts', "    safeLog('readingFailed');\n    return { statusCode: 502 };",
+     "    safeLog('readingFailed');\n    return { statusCode: 500 };",
+     'test', 'a reading: the model failing: 502 and a code'),
+    ('S156', 'src/door.ts', "return path === '/feedback' ?",
+     "return path !== '/feedback' ?",
+     'test', 'a reading: 200, the readings, the night as sent, its count'),
+    ('S157', 'src/door.ts', 'body: JSON.stringify({ readings: read.readings, usage: read.usage }),',
+     'body: JSON.stringify({ readings: read.readings }),',
+     'test', 'a reading: 200, the readings, the night as sent, its count'),
+    ('S158', 'src/handler.ts', '(held ??= instructions())',
+     '(held ?? instructions())',
+     'test', 'the handler reads with the stand-in, and the instructions once'),
+    ('S159', 'src/door.ts', 'readings: read.readings, usage',
+     'readings: read.readings.slice(1), usage',
+     'test', 'a reading: 200, the readings, the night as sent, its count'),
+    ('S160', 'src/handler.ts', 'readNight((held ??= instructions()), request,',
+     'readNight((held ??= instructions()).slice(1), request,',
+     'test', "a reading goes to its step's model with the folder's instructions"),
+    ('S161', 'infra/dist.ts', "  cpSync(new URL('../instructions/', import.meta.url), new URL('instructions/', CODE), { recursive: true });\n",
+     '',
+     'test', 'the compiled files, the marker and the instructions, nothing else'),
+    # One interface for every model call: the setting, the counts and cost, the prompt's order (head's message 34).
+    ('S162', 'src/models.ts', '(choice, prompt, deps.caching)',
+     '(choice, prompt, true)',
+     'test', "a call goes to its step's model, prompt and caching switch"),
+    ('S163', 'src/models.ts', 'const choice = deps.setup[step];',
+     'const choice = deps.setup.opening;',
+     'test', "a call goes to its step's model, prompt and caching switch"),
+    ('S164', 'src/models.ts', '[STEPS.indexOf(step), MODELS',
+     '[0, MODELS',
+     'test', 'each call logs its step, model, tokens and cost, numbers only'),
+    ('S165', 'src/models.ts', 'usage.output * price.output +',
+     'usage.output * price.input +',
+     'test', 'the cost: each count at its price, in millionths'),
+    ('S166', 'src/models.ts', 'usage.cacheRead * price.cacheRead +',
+     'usage.cacheRead * price.cacheWrite +',
+     'test', 'the cost: each count at its price, in millionths'),
+    ('S167', 'src/models.ts', 'export const PROMPT_CACHING = false;',
+     'export const PROMPT_CACHING = true;',
+     'test', 'prompt caching is off until confirmed'),
+    ('S168', 'src/handler.ts', 'caching: PROMPT_CACHING',
+     'caching: !PROMPT_CACHING',
+     'test', "a reading goes to its step's model with the folder's instructions"),
+    ('S169', 'src/reading.ts', 'fixed: instructions.map((i) => i.text)',
+     'fixed: [...instructions].reverse().map((i) => i.text)',
+     'test', 'the prompt: the instructions first, in their order; the night last'),
+    ('S170', 'src/reading.ts', 'words: JSON.stringify(request) }',
+     'words: JSON.stringify(request.dreams) }',
+     'test', 'the prompt: the instructions first, in their order; the night last'),
+    ('S171', 'src/reading.ts', 'Object.keys(json).length !== 1 || ',
+     '',
+     'test', "the model's answer: one to three whole readings, or null"),
+    ('S172', 'src/reading.ts', 'list.length > 3) return null;',
+     'list.length > 4) return null;',
+     'test', "the model's answer: one to three whole readings, or null"),
+    ('S173', 'src/reading.ts', '!Number.isInteger(lens)',
+     "typeof lens !== 'number'",
+     'test', "the model's answer: one to three whole readings, or null"),
+    ('S174', 'src/reading.ts', '(lens as number) < 0 || ',
+     '',
+     'test', "the model's answer: one to three whole readings, or null"),
+    ('S175', 'src/reading.ts', " || words === '') return null;",
+     ') return null;',
+     'test', "the model's answer: one to three whole readings, or null"),
+    ('S176', 'src/reading.ts', 'Object.keys(r).sort().join() !== READING_KEYS.join()',
+     '!READING_KEYS.length',
+     'test', "the model's answer: one to three whole readings, or null"),
+    ('S177', 'src/reading.ts', "throw new Error('reading-unreadable');",
+     'return { readings: [], usage: [call] };',
+     'test', 'an answer that is not readings fails the night'),
+    ('S178', 'src/reading.ts', "ask('readings',",
+     "ask('opening',",
+     'test', 'a night read: the readings step, prompt, readings, one call'),
 ]
 
 
~~~~

### Task 5 · App: a reading's request, its answer, Life Context Off, and Start Interpretation's logic

New: `app/lib/readings/readings.dart`, `app/test/readings/readings_test.dart`. Changed: `journal.dart`
(`keepReadings`), `safe_log.dart` (three codes), `tool/app_mutations.py`. Rows A866 to A890.

Checks: `No issues found!`; `+820`; `--rows A866,…,A890`: `25 run, 25 caught`.

Commit:

> App: a night's reading through our server; Life Context Off sends nothing kept; the readings and their counts kept (head's messages 33, 34; D134)

**The block:**

~~~~diff
diff --git a/app/lib/core/safe_log.dart b/app/lib/core/safe_log.dart
--- a/app/lib/core/safe_log.dart
+++ b/app/lib/core/safe_log.dart
@@ -125,6 +125,14 @@ enum LogEvent {
   /// this build). Never a word of it (R3).
   feedbackSent,
   feedbackFailed,
+
+  /// A night read (head's message 33), with its readings' count; a reading
+  /// that failed, with the server's status (0 no answer, -1 an unreadable
+  /// answer, -2 no server or key, -3 anything else); its readings that could
+  /// not be kept in the night.
+  readingRead,
+  readingFailed,
+  readingKeepFailed,
 }
 
 abstract final class SafeLog {
diff --git a/app/lib/journal/journal.dart b/app/lib/journal/journal.dart
--- a/app/lib/journal/journal.dart
+++ b/app/lib/journal/journal.dart
@@ -123,6 +123,12 @@ final class Journal {
     return best;
   }
 
+  /// Keeps [readings] in night [id], which is then read (D155 item 2), with
+  /// their calls' [usage] where kept (head's message 34); a night already
+  /// read keeps its first. Returns whether the night was there.
+  Future<bool> keepReadings(String id, List<Reading> readings, {List<ModelUsage>? usage}) =>
+      _store.update(id, (n) => n.readings == null ? n.withReadings(readings, usage: usage) : n);
+
   /// Deletes the night, and everything of it (X11).
   Future<void> delete(String id) => _store.delete(id);
 
diff --git a/app/lib/readings/readings.dart b/app/lib/readings/readings.dart
new file mode 100644
--- /dev/null
+++ b/app/lib/readings/readings.dart
@@ -0,0 +1,158 @@
+// The readings, in plain Dart (head's message 33; D155 item 1): one POST to
+// our server's /reading with the beta key and the night: its language, its
+// dreams told in words and, only while Life Context is on, the sentences it
+// keeps (D134; Off sends nothing kept); nothing that names the phone (R4).
+// The answer is one to three readings, each a tradition (its place among
+// the lens labels, W13) and its words, and each model call's counts and cost
+// (head's message 34), kept beside the readings only in the builds that keep
+// them (SoulDreams Dev; the founder's, later). What Start Interpretation does: the
+// readings kept in the night, which is then read; a failure keeps nothing,
+// and the night stays unread (handover §5). Nothing of a night is ever
+// logged: a failure logs its status alone (R3). SoulDreams Dev only; until
+// the instructions come, our server answers with its stand-in.
+import 'dart:convert';
+import 'dart:io';
+
+import 'package:flutter/foundation.dart';
+
+import '../core/hosts.dart';
+import '../core/safe_log.dart';
+import '../journal/journal.dart';
+import '../journal/night.dart';
+import '../life_context/life_context.dart';
+
+/// The server gave no readings: its HTTP status, 0 for no answer, -1 for an
+/// answer that is not one to three whole readings, -2 for no server or beta
+/// key in this build.
+final class ReadingFailure implements Exception {
+  const ReadingFailure(this.status);
+
+  final int status;
+}
+
+/// A night's answer: its readings, and its calls' counts where kept.
+typedef NightAnswer = ({List<Reading> readings, List<ModelUsage>? usage});
+
+/// Sends one night's request; completes with its answer.
+typedef SendNight = Future<NightAnswer> Function(Map<String, Object?> body);
+
+const _wait = Duration(seconds: 30);
+final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
+const _readingKeys = {'lens', 'text'};
+const _answerKeys = {'readings', 'usage'};
+
+/// The request for [night]: its language and its dreams in words, and
+/// [kept] only when given (Life Context on).
+Map<String, Object?> requestOf(Night night, List<String>? kept) => {
+  'lang': night.lang.name,
+  'dreams': night.dreams,
+  'kept': ?kept,
+};
+
+// The answer in [json], or null when it is not one to three whole readings
+// and a list of whole calls.
+NightAnswer? _answerOf(Object? json) {
+  if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _answerKeys)) return null;
+  final calls = json['usage'];
+  if (calls is! List<Object?>) return null;
+  final usage = [for (final c in calls) ModelUsage.fromJson(c)];
+  if (usage.contains(null)) return null;
+  final list = json['readings'];
+  if (list is! List<Object?> || list.isEmpty || list.length > maxReadings) return null;
+  final readings = <Reading>[];
+  for (final r in list) {
+    if (r is! Map<String, Object?> || !setEquals(r.keys.toSet(), _readingKeys)) return null;
+    final lens = r['lens'];
+    final text = r['text'];
+    if (lens is! int || lens < 0 || text is! String || text.isEmpty) return null;
+    readings.add(Reading(lens, text));
+  }
+  return (readings: readings, usage: usage.cast<ModelUsage>());
+}
+
+/// Sends [body] to [server]'s /reading; completes with the answer (200).
+Future<NightAnswer> postReading(Uri server, String betaKey, Map<String, Object?> body) async {
+  final client = HttpClient()
+    ..userAgent = null
+    ..connectionTimeout = _wait;
+  final String answer;
+  try {
+    final bytes = utf8.encode(jsonEncode(body));
+    final request = await client.postUrl(server.resolve('reading')).timeout(_wait);
+    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
+    request.headers.contentType = ContentType.json;
+    request.contentLength = bytes.length;
+    request.add(bytes);
+    final reply = await request.close().timeout(_wait);
+    answer = await utf8.decodeStream(reply).timeout(_wait);
+    if (reply.statusCode != 200) throw ReadingFailure(reply.statusCode);
+  } on ReadingFailure {
+    rethrow;
+  } on Object {
+    throw const ReadingFailure(0);
+  } finally {
+    client.close(force: true);
+  }
+  final Object? json;
+  try {
+    json = jsonDecode(answer);
+  } on FormatException {
+    throw const ReadingFailure(-1);
+  }
+  return _answerOf(json) ?? (throw const ReadingFailure(-1));
+}
+
+/// SoulDreams Dev's own: our server, with the build's beta key; with no
+/// server or a beta key not of its shape, every reading fails (-2). The
+/// calls' counts are kept only when [keepUsage] (head's message 34).
+SendNight liveReading({required String betaKey, String server = Hosts.server, bool keepUsage = false}) {
+  final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);
+  return (body) async {
+    if (!on) throw const ReadingFailure(-2);
+    final answer = await postReading(Uri.parse(server), betaKey, body);
+    return keepUsage ? answer : (readings: answer.readings, usage: null);
+  };
+}
+
+/// What Life Context gives a reading (D134): while on, the sentences in
+/// the Recent window, word for word; while off, or with none, nothing.
+Future<List<String>?> keptFor(LifeContext? life) async {
+  if (life == null || !life.on) return null;
+  return [for (final k in await life.recent()) k.text];
+}
+
+/// Reads a night: its request made at the moment of reading.
+final class Reader {
+  Reader(this._send, this._kept);
+
+  final SendNight _send;
+  final Future<List<String>?> Function() _kept;
+
+  Future<NightAnswer> read(Night night) async => _send(requestOf(night, await _kept()));
+}
+
+/// What one Start Interpretation did.
+enum Interpreted { nothing, read, failed, gone }
+
+/// Reads [night] with [reader] and keeps its readings in [journal]. A night
+/// already read, or with no dream in words yet, is not sent.
+Future<Interpreted> interpret(Journal journal, Reader reader, Night night) async {
+  if (night.readings != null || night.dreams.isEmpty) return Interpreted.nothing;
+  final NightAnswer answer;
+  try {
+    answer = await reader.read(night);
+  } on Object catch (e) {
+    SafeLog.event(LogEvent.readingFailed, [e is ReadingFailure ? e.status : -3]);
+    return Interpreted.failed;
+  }
+  final bool kept;
+  try {
+    kept = await journal.keepReadings(night.id, answer.readings, usage: answer.usage);
+  } on Object {
+    SafeLog.event(LogEvent.readingKeepFailed);
+    return Interpreted.failed;
+  }
+  if (!kept) return Interpreted.gone;
+  SafeLog.event(LogEvent.readingRead, [answer.readings.length]);
+  return Interpreted.read;
+}
diff --git a/app/test/readings/readings_test.dart b/app/test/readings/readings_test.dart
new file mode 100644
--- /dev/null
+++ b/app/test/readings/readings_test.dart
@@ -0,0 +1,334 @@
+// The readings, in plain Dart (head's message 33; D134; D155 item 1): one
+// POST to our server's /reading with the beta key and the night (its
+// language and its dreams in words) and, only while Life Context is on, the
+// sentences it keeps; nothing that names the phone (R4). What Start
+// Interpretation does: the readings kept in the night, which is then read;
+// a failure keeps nothing and logs a code (R3).
+import 'dart:convert';
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
+import 'package:souldreams/life_context/life_context.dart';
+import 'package:souldreams/readings/readings.dart';
+import 'package:souldreams/settings/consents.dart';
+import 'package:souldreams/settings/settings.dart';
+import 'package:souldreams/settings/settings_controller.dart';
+
+import '../fixtures.dart';
+import '../journal/memory_journal_files.dart';
+import '../journal/zones.dart';
+
+/// Our server's door, on this Mac: what each request held, and the answer.
+final class FakeServer {
+  FakeServer._(this._server);
+
+  final HttpServer _server;
+  final requests = <({String method, String path, Map<String, List<String>> headers, String body})>[];
+  int status = 200;
+  String reply = jsonEncode({
+    'readings': [
+      {'lens': 0, 'text': '[one]'},
+      {'lens': 2, 'text': '[two]'},
+    ],
+    'usage': [call],
+  });
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
+    request.response.statusCode = status;
+    request.response.write(reply);
+    await request.response.close();
+  }
+
+  Future<void> stop() => _server.close(force: true);
+}
+
+/// One model call's counts, as our server gives them.
+const call = {'step': 'readings', 'model': 'stand-in', 'input': 40, 'output': 9, 'cacheRead': 30, 'cacheWrite': 0, 'cost': 290};
+
+void main() {
+  final beta = 'Ab0' * 16;
+  final readings = [Reading(0, '[one]'), Reading(2, '[two]')];
+  final usage = [ModelUsage.fromJson(call)!];
+  final answer = (readings: readings, usage: usage);
+  final unkept = (readings: readings, usage: null);
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
+  // Two answers alike: the same readings and the same counts, or none.
+  void same(NightAnswer a, NightAnswer b) {
+    expect(a.readings, b.readings);
+    expect(a.usage, b.usage);
+  }
+
+  Future<int> failure(Future<void> f) async {
+    try {
+      await f;
+    } on ReadingFailure catch (e) {
+      return e.status;
+    }
+    fail('no failure');
+  }
+
+  group('the request', () {
+    test("the night's language and dreams in words; kept only when given", () {
+      final n = nightsFromFixtures()[1];
+      final night = n.withEntries([...n.entries, Waiting('e' * 32)]);
+      expect(requestOf(night, null), {'lang': n.lang.name, 'dreams': n.dreams});
+      expect(requestOf(night, []), {'lang': n.lang.name, 'dreams': n.dreams, 'kept': <String>[]});
+      expect(requestOf(night, ['a', 'b']), {'lang': n.lang.name, 'dreams': n.dreams, 'kept': ['a', 'b']});
+    });
+
+    test('one POST to /reading: beta key and the night alone', () async {
+      final server = await FakeServer.start();
+      addTearDown(server.stop);
+      final body = {'lang': 'sv', 'dreams': ['Ett hus.']};
+      same(await postReading(server.url, beta, body), answer);
+      final r = server.requests.single;
+      expect(r.method, 'POST');
+      expect(r.path, '/reading');
+      expect(jsonDecode(r.body), body);
+      expect(r.headers['authorization'], ['Bearer $beta']);
+      expect(r.headers['content-type'], ['application/json; charset=utf-8']);
+      expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'content-type', 'accept-encoding'});
+    });
+
+    test("not 200: the server's status; no answer: 0", () async {
+      final server = await FakeServer.start();
+      for (final status in [204, 400, 401, 413, 500, 502]) {
+        server.status = status;
+        expect(await failure(postReading(server.url, beta, {})), status);
+      }
+      final gone = server.url;
+      await server.stop();
+      expect(await failure(postReading(gone, beta, {})), 0);
+    });
+
+    test('an answer that is not one to three whole readings: -1', () async {
+      final server = await FakeServer.start();
+      addTearDown(server.stop);
+      for (final reply in [
+        'not json',
+        '[]',
+        jsonEncode({'readings': [], 'usage': []}),
+        jsonEncode({'readings': 'x', 'usage': []}),
+        jsonEncode({'readings': [for (var i = 0; i < 4; i++) {'lens': i, 'text': '[x]'}], 'usage': []}),
+        jsonEncode({'readings': [{'lens': -1, 'text': '[x]'}], 'usage': []}),
+        jsonEncode({'readings': [{'lens': 1, 'text': ''}], 'usage': []}),
+        jsonEncode({'readings': [{'lens': '1', 'text': '[x]'}], 'usage': []}),
+        jsonEncode({'readings': [{'lens': 1, 'text': '[x]', 'extra': 1}], 'usage': []}),
+        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}], 'usage': [], 'extra': 1}),
+        // The calls' counts: missing, or not whole.
+        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}]}),
+        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}], 'usage': 'x'}),
+        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}], 'usage': [{...call, 'input': -1}]}),
+      ]) {
+        server.reply = reply;
+        expect(await failure(postReading(server.url, beta, {})), -1, reason: reply);
+      }
+    });
+
+    test("Dev's own: our server, with a well-shaped beta key", () async {
+      final server = await FakeServer.start();
+      addTearDown(server.stop);
+      // The calls' counts kept only when asked (head's message 34).
+      same(await liveReading(betaKey: beta, server: '${server.url}')({}), unkept);
+      same(await liveReading(betaKey: beta, server: '${server.url}', keepUsage: true)({}), answer);
+      expect(await failure(liveReading(betaKey: 'short', server: '${server.url}')({})), -2);
+      expect(await failure(liveReading(betaKey: beta, server: '')({})), -2);
+      expect(server.requests, hasLength(2));
+      expect(Hosts.server, isNotEmpty);
+    });
+  });
+
+  group('Life Context (D134)', () {
+    late DateTime now;
+    final passages = [for (final n in inventedNights()) ...n.waking];
+
+    Future<(Journal, SettingsController, LifeContext, List<Night>)> open({bool on = true}) async {
+      now = DateTime.utc(2026, 11, 22, 9);
+      final store = await JournalStore.open(MemoryJournalFiles());
+      final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(4));
+      final nights = nightsFromFixtures();
+      for (final n in nights) {
+        await store.save(n);
+      }
+      final settings = SettingsController(
+        journal,
+        consents: Consents.answered({Consent.readings: true, Consent.lifeContext: on}, now),
+        settings: Settings(),
+      );
+      return (journal, settings, LifeContext(journal, settings), nights);
+    }
+
+    test('On: the Recent list, in its order, word for word', () async {
+      final (_, _, life, nights) = await open();
+      await life.capture(nights.first.id, passages.first.text);
+      await life.capture(nights[1].id, passages[1].text);
+      final recent = [for (final k in await life.recent()) k.text];
+      expect(recent.toSet(), {...passages.first.sentences, ...passages[1].sentences});
+      expect(await keptFor(life), recent);
+    });
+
+    test('On with nothing kept: an empty list, still sent', () async {
+      final (_, _, life, _) = await open();
+      expect(await keptFor(life), <String>[]);
+    });
+
+    test('Off: nothing kept is sent, and it comes back On', () async {
+      final (_, settings, life, nights) = await open();
+      await life.capture(nights.first.id, passages.first.text);
+      await settings.answer(Consent.lifeContext, false);
+      expect(await keptFor(life), isNull);
+      await settings.answer(Consent.lifeContext, true);
+      expect(await keptFor(life), passages.first.sentences);
+    });
+
+    test('no Life Context: nothing kept is sent', () async {
+      expect(await keptFor(null), isNull);
+    });
+
+    test("the Reader sends what Life Context gives when it reads", () async {
+      final (_, settings, life, nights) = await open();
+      await life.capture(nights.first.id, passages.first.text);
+      final sent = <Map<String, Object?>>[];
+      final reader = Reader((body) async {
+        sent.add(body);
+        return answer;
+      }, () => keptFor(life));
+      same(await reader.read(nights[1]), answer);
+      await settings.answer(Consent.lifeContext, false);
+      await reader.read(nights[1]);
+      expect(sent, [requestOf(nights[1], passages.first.sentences), requestOf(nights[1], null)]);
+      expect(sent.last.containsKey('kept'), isFalse);
+    });
+  });
+
+  group('Start Interpretation', () {
+    late Journal journal;
+    late List<Night> nights;
+    late List<Map<String, Object?>> sent;
+    late Object? fails;
+
+    setUp(() async {
+      final store = await JournalStore.open(MemoryJournalFiles());
+      journal = Journal(store, zone: const FixedZone(1), random: Random(4));
+      nights = nightsFromFixtures();
+      for (final n in nights) {
+        await store.save(n);
+      }
+      sent = [];
+      fails = null;
+    });
+
+    Reader reader() => Reader((body) async {
+      sent.add(body);
+      if (fails case final f?) throw f;
+      return answer;
+    }, () async => null);
+
+    test('the readings kept in the night, which is read; one code', () async {
+      expect(await interpret(journal, reader(), nights[2]), Interpreted.read);
+      final read = await journal.night(nights[2].id);
+      expect(read!.readings, readings);
+      expect(read.usage, usage);
+      expect(read.withEntries(nights[2].entries), nights[2].withReadings(readings, usage: usage));
+      expect(sent, [requestOf(nights[2], null)]);
+      expect(lines, ['readingRead 2']);
+    });
+
+    test('a failure keeps nothing, the night unread; its status logged', () async {
+      for (final (f, line) in [
+        (const ReadingFailure(502), 'readingFailed 502'),
+        (const ReadingFailure(0), 'readingFailed 0'),
+        (StateError('invented failure text'), 'readingFailed -3'),
+      ]) {
+        lines.clear();
+        fails = f;
+        expect(await interpret(journal, reader(), nights[0]), Interpreted.failed);
+        expect((await journal.night(nights[0].id))!.readings, isNull);
+        expect(lines, [line]);
+      }
+    });
+
+    test('a night already read is not read again', () async {
+      await journal.keepReadings(nights[0].id, readings);
+      expect(await interpret(journal, reader(), (await journal.night(nights[0].id))!), Interpreted.nothing);
+      expect(sent, isEmpty);
+    });
+
+    test('a night with no dream in words yet is not sent', () async {
+      final waiting = nights[0].withEntries([Waiting('e' * 32)]);
+      expect(await interpret(journal, reader(), waiting), Interpreted.nothing);
+      expect(sent, isEmpty);
+    });
+
+    test('a night deleted while read keeps nothing, not made again', () async {
+      final r = Reader((body) async {
+        await journal.delete(nights[1].id);
+        return answer;
+      }, () async => null);
+      expect(await interpret(journal, r, nights[1]), Interpreted.gone);
+      expect(await journal.night(nights[1].id), isNull);
+      expect(lines, isEmpty);
+    });
+
+    test('the readings that cannot be kept: failed, a code', () async {
+      final r = Reader((body) async => answer, () async => null);
+      final files = BrokenFiles();
+      final broken = Journal(await JournalStore.open(files), random: Random(4));
+      files.failing = true;
+      expect(await interpret(broken, r, nights[1]), Interpreted.failed);
+      expect(lines, ['readingKeepFailed']);
+    });
+
+    test("a build that keeps no counts: the readings kept, no usage", () async {
+      final r = Reader((body) async => unkept, () async => null);
+      expect(await interpret(journal, r, nights[2]), Interpreted.read);
+      final read = await journal.night(nights[2].id);
+      expect(read!.readings, readings);
+      expect(read.usage, isNull);
+    });
+
+    test('keepReadings: a night read keeps its first readings', () async {
+      expect(await journal.keepReadings(nights[0].id, readings), isTrue);
+      expect(await journal.keepReadings(nights[0].id, [Reading(1, '[x]')]), isTrue);
+      expect((await journal.night(nights[0].id))!.readings, readings);
+      expect(await journal.keepReadings('f' * 32, readings), isFalse);
+    });
+  });
+}
+
+/// A folder that cannot be read once [failing] is set.
+final class BrokenFiles extends MemoryJournalFiles {
+  bool failing = false;
+
+  @override
+  Future<Uint8List?> read(String name) async => failing ? throw StateError('journal-io') : super.read(name);
+}
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A865, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A890, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -3513,6 +3513,108 @@ ROWS = [
      '      readings: readings,\n      usage: usage);\n\n  /// The same night, read',
      '      readings: readings);\n\n  /// The same night, read',
      'test/journal/night_test.dart', "a read night keeps its calls' counts beside its readings"),
+    # A reading: the request, the answer, Life Context Off and Start Interpretation's logic (head's message 33; D134).
+    ('A866', 'lib/readings/readings.dart',
+     "  'kept': ?kept,",
+     "  'kept': kept ?? [],",
+     'test/readings/readings_test.dart', "the night's language and dreams in words; kept only when given"),
+    ('A867', 'lib/readings/readings.dart',
+     "  'dreams': night.dreams,",
+     "  'dreams': [...night.dreams, ''],",
+     'test/readings/readings_test.dart', "the night's language and dreams in words; kept only when given"),
+    ('A868', 'lib/readings/readings.dart',
+     "server.resolve('reading')",
+     "server.resolve('readings')",
+     'test/readings/readings_test.dart', 'one POST to /reading: beta key and the night alone'),
+    ('A869', 'lib/readings/readings.dart',
+     '    ..userAgent = null\n',
+     '',
+     'test/readings/readings_test.dart', 'one POST to /reading: beta key and the night alone'),
+    ('A870', 'lib/readings/readings.dart',
+     'if (reply.statusCode != 200) throw',
+     'if (reply.statusCode != 200 && reply.statusCode != 204) throw',
+     'test/readings/readings_test.dart', "not 200: the server's status; no answer: 0"),
+    ('A871', 'lib/readings/readings.dart',
+     '!setEquals(json.keys.toSet(), _answerKeys)',
+     'json.isEmpty',
+     'test/readings/readings_test.dart', 'an answer that is not one to three whole readings: -1'),
+    ('A872', 'lib/readings/readings.dart',
+     'list.isEmpty || list.length > maxReadings',
+     'list.length > maxReadings',
+     'test/readings/readings_test.dart', 'an answer that is not one to three whole readings: -1'),
+    ('A873', 'lib/readings/readings.dart',
+     'list.isEmpty || list.length > maxReadings',
+     'list.isEmpty',
+     'test/readings/readings_test.dart', 'an answer that is not one to three whole readings: -1'),
+    ('A874', 'lib/readings/readings.dart',
+     ' || lens < 0 || text is! String',
+     ' || text is! String',
+     'test/readings/readings_test.dart', 'an answer that is not one to three whole readings: -1'),
+    ('A875', 'lib/readings/readings.dart',
+     '!setEquals(r.keys.toSet(), _readingKeys)',
+     'r.isEmpty',
+     'test/readings/readings_test.dart', 'an answer that is not one to three whole readings: -1'),
+    ('A876', 'lib/readings/readings.dart',
+     '  final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);',
+     '  final on = server.isNotEmpty;',
+     'test/readings/readings_test.dart', "Dev's own: our server, with a well-shaped beta key"),
+    ('A877', 'lib/readings/readings.dart',
+     '  if (life == null || !life.on) return null;',
+     '  if (life == null) return null;',
+     'test/readings/readings_test.dart', 'Off: nothing kept is sent, and it comes back On'),
+    ('A878', 'lib/readings/readings.dart',
+     '_send(requestOf(night, await _kept()))',
+     '_send(requestOf(night, null))',
+     'test/readings/readings_test.dart', 'the Reader sends what Life Context gives when it reads'),
+    ('A879', 'lib/readings/readings.dart',
+     'if (night.readings != null || night.dreams.isEmpty)',
+     'if (night.dreams.isEmpty)',
+     'test/readings/readings_test.dart', 'a night already read is not read again'),
+    ('A880', 'lib/readings/readings.dart',
+     'if (night.readings != null || night.dreams.isEmpty)',
+     'if (night.readings != null)',
+     'test/readings/readings_test.dart', 'a night with no dream in words yet is not sent'),
+    ('A881', 'lib/readings/readings.dart',
+     '[e is ReadingFailure ? e.status : -3]',
+     '[-3]',
+     'test/readings/readings_test.dart', 'a failure keeps nothing, the night unread; its status logged'),
+    ('A882', 'lib/readings/readings.dart',
+     '  if (!kept) return Interpreted.gone;\n',
+     '',
+     'test/readings/readings_test.dart', 'a night deleted while read keeps nothing, not made again'),
+    ('A883', 'lib/readings/readings.dart',
+     '    SafeLog.event(LogEvent.readingKeepFailed);',
+     '    SafeLog.event(LogEvent.readingFailed);',
+     'test/readings/readings_test.dart', 'the readings that cannot be kept: failed, a code'),
+    ('A884', 'lib/readings/readings.dart',
+     'SafeLog.event(LogEvent.readingRead, [answer.readings.length]);',
+     'SafeLog.event(LogEvent.readingRead);',
+     'test/readings/readings_test.dart', 'the readings kept in the night, which is read; one code'),
+    ('A885', 'lib/journal/journal.dart',
+     'n.readings == null ? n.withReadings(readings, usage: usage) : n',
+     'n.withReadings(readings, usage: usage)',
+     'test/readings/readings_test.dart', 'keepReadings: a night read keeps its first readings'),
+    # A reading's calls' counts, kept only where the build keeps them (head's message 34).
+    ('A886', 'lib/readings/readings.dart',
+     'keepUsage ? answer : (readings: answer.readings, usage: null)',
+     'answer',
+     'test/readings/readings_test.dart', "Dev's own: our server, with a well-shaped beta key"),
+    ('A887', 'lib/readings/readings.dart',
+     '  if (usage.contains(null)) return null;\n',
+     '',
+     'test/readings/readings_test.dart', 'an answer that is not one to three whole readings: -1'),
+    ('A888', 'lib/readings/readings.dart',
+     'usage: answer.usage)',
+     'usage: null)',
+     'test/readings/readings_test.dart', 'the readings kept in the night, which is read; one code'),
+    ('A889', 'lib/journal/journal.dart',
+     'n.withReadings(readings, usage: usage)',
+     'n.withReadings(readings)',
+     'test/readings/readings_test.dart', 'the readings kept in the night, which is read; one code'),
+    ('A890', 'lib/main_dev.dart',
+     'keepUsage: true',
+     'keepUsage: false',
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
 ]
 
 
~~~~

### Task 6 · App: the readings on a night's page; SoulDreams Dev's reader

Only after Task 0b. If C19-P changed any place this task uses, the plan was amended there first.

Changed: `night_page.dart`, `parts.dart`, `night_look.dart`, `journal_page.dart`, `journal_home.dart`,
`main_dev.dart`, and the tests of the night's page, the journal list, the home and `dev_only_test.dart`;
`tool/app_mutations.py`. Rows A891 to A913 new; A264, A385, A391, A656, A752 and A835 follow.

Checks: `No issues found!`; `+832`; `--rows A264,A385,A391,A656,A752,A835,A891,…,A913`: `29 run, 29 caught`;
and every row of the
eleven app files this branch changes (`--files lib/feedback/feedback.dart,lib/journal/night.dart,
lib/journal/journal.dart,lib/core/safe_log.dart,lib/readings/readings.dart,lib/journal/pages/night_page.dart,
lib/journal/pages/parts.dart,lib/journal/night_look.dart,lib/journal/pages/journal_page.dart,
lib/journal/pages/journal_home.dart,lib/main_dev.dart`): `app mutations: 291 run, 291 caught`.

Commit:

> App: Start Interpretation reads a night in SoulDreams Dev; its readings on the night's page (head's message 33)

**The block:**

~~~~diff
diff --git a/app/lib/journal/night_look.dart b/app/lib/journal/night_look.dart
--- a/app/lib/journal/night_look.dart
+++ b/app/lib/journal/night_look.dart
@@ -51,6 +51,9 @@ typedef ReadCheck = bool Function(Night night);
 /// The readings come later, so no night is read yet.
 bool noneRead(Night night) => false;
 
+/// Whether [night] holds its readings (D155 item 2): SoulDreams Dev's.
+bool isRead(Night night) => night.readings != null;
+
 /// Every night read: SoulDreams Dev's by-eye preview of a read night's look
 /// only, in a build made with --dart-define=PREVIEW_READ=true (D110).
 bool allRead(Night night) => true;
diff --git a/app/lib/journal/pages/journal_home.dart b/app/lib/journal/pages/journal_home.dart
--- a/app/lib/journal/pages/journal_home.dart
+++ b/app/lib/journal/pages/journal_home.dart
@@ -32,6 +32,7 @@ import '../../core/app_line.dart' show wordAnimation;
 import '../../core/night_day.dart';
 import '../../core/safe_log.dart';
 import '../../feedback/feedback.dart';
+import '../../readings/readings.dart';
 import '../../life_context/life_context.dart';
 import '../../life_context/preview.dart';
 import '../../onboarding/onboarding.dart';
@@ -57,6 +58,7 @@ class JournalHome extends StatefulWidget {
     this.read = noneRead,
     this.preview = '',
     this.feedback,
+    this.readNight,
   });
 
   final JournalFiles files;
@@ -81,6 +83,9 @@ class JournalHome extends StatefulWidget {
   /// Sends feedback from Settings (D152), or null: no Feedback section.
   final SendFeedback? feedback;
 
+  /// Reads a night through our server (head's message 33), or null.
+  final SendNight? readNight;
+
   @override
   State<JournalHome> createState() => _JournalHomeState();
 }
@@ -269,6 +274,7 @@ class _JournalHomeState extends State<JournalHome> with WidgetsBindingObserver {
         images: _settings?.settings.images != NightImages.off,
         agreed: _settings?.agreed ?? true,
         feedback: widget.feedback,
+        readNight: widget.readNight,
       ),
     };
   }
diff --git a/app/lib/journal/pages/journal_page.dart b/app/lib/journal/pages/journal_page.dart
--- a/app/lib/journal/pages/journal_page.dart
+++ b/app/lib/journal/pages/journal_page.dart
@@ -32,6 +32,7 @@ import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../feedback/feedback.dart';
+import '../../readings/readings.dart';
 import '../../words/lines.g.dart';
 import '../../recording/recording.dart';
 import '../../life_context/life_context.dart';
@@ -63,6 +64,7 @@ class JournalPage extends StatefulWidget {
     this.images = true,
     this.agreed = true,
     this.feedback,
+    this.readNight,
   });
 
   final Journal journal;
@@ -106,6 +108,10 @@ class JournalPage extends StatefulWidget {
   /// Sends feedback from Settings (D152), or null: no Feedback section.
   final SendFeedback? feedback;
 
+  /// Reads a night through our server (head's message 33), or null: Start
+  /// Interpretation does nothing. SoulDreams Dev's only.
+  final SendNight? readNight;
+
   @override
   State<JournalPage> createState() => _JournalPageState();
 }
@@ -192,6 +198,13 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
     });
   }
 
+  // A night's reader: the night with what Life Context gives at that
+  // moment, nothing kept while it is off (D134).
+  Reader? get _reader => switch (widget.readNight) {
+    null => null,
+    final send => Reader(send, () => keptFor(widget.lifeContext)),
+  };
+
   Future<void> _push(Widget page) async {
     await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
     await _load();
@@ -207,6 +220,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
       read: widget.read,
       images: widget.images,
       agreed: widget.agreed,
+      reader: _reader,
     ),
   );
 
@@ -262,6 +276,7 @@ class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
           images: widget.images,
           agreed: widget.agreed,
           query: query,
+          reader: _reader,
         ),
       ),
     );
diff --git a/app/lib/journal/pages/night_page.dart b/app/lib/journal/pages/night_page.dart
--- a/app/lib/journal/pages/night_page.dart
+++ b/app/lib/journal/pages/night_page.dart
@@ -16,20 +16,28 @@
 // (MP·38, centred, D112), in bubbles 30 from the screen's left edge and 10 from its
 // right (Spacing.bubbleDreamer), each opening the typing screen to edit
 // it; at the foot, "Add dreams" (MP·29) left and Start Interpretation
-// (EM·1) right, which does nothing yet (P3, as D71 Q3). A recording that
+// (EM·1) right, which reads the night with the page's reader, SoulDreams
+// Dev's only (head's message 33), and does nothing without one (P3, as D71
+// Q3); it is gone once the night is read. While the night is read, AI·3
+// shows under the dreams; a reading that fails shows the failure sentence
+// (C4-P·6) alone there, and the night stays unread (handover §5). A read
+// night shows, under its dreams, MP·20, "The Readings" (MP·36) and its
+// readings, each in the readings' bubble under its tradition's label (W13,
+// its handle until it has a line). A recording that
 // waits to be turned into text shows nothing in its place and cannot be
 // tapped; while it is being turned into text, AI·6 shows in its place,
 // heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
 // When its words come, the page shows them. On a read night, under the
 // header, four jump buttons (MP·77: Dreams, Questions, Readings,
-// Reflection; D119 item 4); Dreams brings "Dreams" into view, the
-// other three do nothing until their sections come with the readings. No
-// night is read yet. Not built: reading, and the space below the dreams
+// Reflection; D119 item 4); Dreams brings "Dreams" into view and Readings
+// "The Readings"; the other two do nothing until their sections come. Not
+// built: the mirror, the opening, the close, and the space below the dreams
 // with its field. Opened from a search, the night's first match shows in
 // Bold in its dream, found again on each read; gone when the page goes
 // (main-path.md, Search; D117 Q6).
 import 'package:flutter/cupertino.dart';
 import 'package:flutter/material.dart';
+import 'package:flutter/rendering.dart' show ScrollCacheExtent;
 import 'package:flutter/services.dart';
 
 import '../../core/app_line.dart';
@@ -40,6 +48,7 @@ import '../../design/palette.dart';
 import '../../design/stand_ins.dart';
 import '../../design/tokens.g.dart';
 import '../../words/lines.g.dart';
+import '../../readings/readings.dart';
 import '../../recording/recording.dart';
 import '../journal.dart';
 import '../night.dart';
@@ -53,6 +62,13 @@ import 'night_art.dart';
 import 'parts.dart';
 import 'typing_page.dart';
 
+/// A tradition's label: [line]'s part at [lens] (W13), or its handle while
+/// it has no line or no part there (R1).
+String lensLabel(Line line, int lens, Lang lang) {
+  final parts = line.parts(lang);
+  return line.written && lens < parts.length ? parts[lens] : '[${line.handle}]';
+}
+
 /// A read night's jump buttons, in MP·77's order (C18-P; D119 item 4).
 enum Jump {
   dreams,
@@ -75,6 +91,7 @@ class NightPage extends StatefulWidget {
     this.images = true,
     this.agreed = true,
     this.query,
+    this.reader,
   });
 
   static const menuKey = Key('night-menu');
@@ -84,6 +101,12 @@ class NightPage extends StatefulWidget {
   static const startKey = Key('night-start');
   static const transcribingKey = Key('night-transcribing');
   static const dreamsKey = Key('night-dreams');
+  static const readingsKey = Key('night-readings');
+  static const waitingKey = Key('night-reading-waits');
+  static const failedKey = Key('night-reading-failed');
+
+  /// The night's reading at [index].
+  static Key readingKey(int index) => ValueKey('reading-$index');
 
   /// A read night's jump button.
   static Key jumpKey(Jump jump) => ValueKey('jump-${jump.name}');
@@ -110,6 +133,10 @@ class NightPage extends StatefulWidget {
   /// The search this night was opened from, as searched, or null.
   final String? query;
 
+  /// How Start Interpretation reads the night: SoulDreams Dev's only (head's
+  /// message 33); null, and it does nothing.
+  final Reader? reader;
+
   @override
   State<NightPage> createState() => _NightPageState();
 }
@@ -123,6 +150,21 @@ class _NightPageState extends State<NightPage> {
   // The "Dreams" label, which its jump button brings into view.
   final _dreamsLabel = GlobalKey();
 
+  // "The Readings" label, which its jump button brings into view.
+  final _readingsLabel = GlobalKey();
+
+  // A reading under way, or the last one failed (handover §5).
+  bool _reading = false;
+  bool _failed = false;
+
+  // The part that scrolls: brought to its end, at once, when AI·3 comes, so
+  // it shows where the readings, or the failure sentence, will.
+  final _scroll = ScrollController();
+
+  void _toEnd() => WidgetsBinding.instance.addPostFrameCallback((_) {
+    if (mounted && _scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
+  });
+
   @override
   void initState() {
     super.initState();
@@ -133,6 +175,7 @@ class _NightPageState extends State<NightPage> {
   @override
   void dispose() {
     widget.recording?.retries?.removeListener(_retried);
+    _scroll.dispose();
     super.dispose();
   }
 
@@ -217,6 +260,30 @@ class _NightPageState extends State<NightPage> {
     if (mounted) Navigator.of(context).pop();
   }
 
+  // Start Interpretation: the popup before agreeing (D128); else, with a
+  // reader, the night read once at a time (head's message 33).
+  Future<void> _start() async {
+    if (!widget.agreed) {
+      showAgreementPopup(context);
+      return;
+    }
+    final reader = widget.reader;
+    final night = _night;
+    if (reader == null || night == null || _busy || _reading) return;
+    setState(() {
+      _reading = true;
+      _failed = false;
+    });
+    _toEnd();
+    final done = await interpret(widget.journal, reader, night);
+    if (!mounted) return;
+    setState(() {
+      _reading = false;
+      _failed = done == Interpreted.failed;
+    });
+    await _load();
+  }
+
   // The entry point's item, with the night shown; not while a delete runs.
   Future<void> _act() async {
     final night = _night;
@@ -324,7 +391,7 @@ class _NightPageState extends State<NightPage> {
         children: [
           jump(Jump.dreams, [p.sectionTop, p.sectionBottom], _dreamsLabel),
           jump(Jump.questions, StandIns.jumpQuestions, null),
-          jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], null),
+          jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], _readingsLabel),
           jump(Jump.reflection, [tag.colour!, tag.colourEnd!], null),
         ],
       ),
@@ -411,6 +478,10 @@ class _NightPageState extends State<NightPage> {
                 // The bubbles keep their own margins from the screen's edges
                 // (design-system.md §5); everything else keeps the page's.
                 child: ListView(
+                  controller: _scroll,
+                  // Every part laid out, so a jump reaches a section below
+                  // the screen (a night's page is short).
+                  scrollCacheExtent: const ScrollCacheExtent.pixels(100000),
                   padding: EdgeInsets.only(top: Spacing.nightHeader.top),
                   children: [
                     // A read night's jump buttons head the part that scrolls.
@@ -443,6 +514,7 @@ class _NightPageState extends State<NightPage> {
                         ),
                         const SizedBox(height: StandIns.bubbleGap),
                       ],
+                    ..._readings(n, p, side),
                   ],
                 ),
               ),
@@ -455,17 +527,13 @@ class _NightPageState extends State<NightPage> {
                       key: NightPage.addKey,
                       child: PlainButton(Lines.MP_29.text(appLanguage), onPressed: () => _type(null)),
                     ),
-                    right: KeyedSubtree(
-                      key: NightPage.startKey,
-                      // Nothing to start yet: the readings come later (P3, as D71
-                      // Q3); before agreeing, the popup (D128).
-                      child: PlainButton(
-                        Lines.EM_1.text(appLanguage),
-                        onPressed: () {
-                          if (!widget.agreed) showAgreementPopup(context);
-                        },
-                      ),
-                    ),
+                    // Gone once the night is read.
+                    right: n.readings != null
+                        ? const SizedBox.shrink()
+                        : KeyedSubtree(
+                            key: NightPage.startKey,
+                            child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: _start),
+                          ),
                   ),
                 ),
               ),
@@ -475,4 +543,40 @@ class _NightPageState extends State<NightPage> {
       ),
     );
   }
+
+  // Under the dreams: a read night's readings (MP·20, "The Readings", each
+  // reading); while one is read, AI·3; when it failed, C4-P·6 alone.
+  List<Widget> _readings(Night n, Palette p, EdgeInsets side) {
+    Widget line(Key key, Line said) => Padding(
+      padding: side,
+      child: Semantics(
+        key: key,
+        liveRegion: true,
+        child: AppLine(said.text(appLanguage), style: StandIns.voiceApp(p.text)),
+      ),
+    );
+    if (n.readings case final readings?) {
+      return [
+        const SizedBox(height: Spacing.turnApp),
+        Padding(padding: side, child: AppLine(Lines.MP_20.text(appLanguage), style: StandIns.voiceApp(p.text))),
+        const SizedBox(height: StandIns.gap),
+        Padding(
+          key: NightPage.readingsKey,
+          padding: side,
+          child: Align(
+            alignment: Alignment.center,
+            child: SectionLabel(key: _readingsLabel, Lines.MP_36.text(appLanguage)),
+          ),
+        ),
+        const SizedBox(height: Spacing.labelReadings),
+        for (final (i, r) in readings.indexed) ...[
+          ReadingBubble(key: NightPage.readingKey(i), label: lensLabel(Lines.W13, r.lens, appLanguage), text: r.text),
+          const SizedBox(height: StandIns.bubbleGap),
+        ],
+      ];
+    }
+    if (_reading) return [const SizedBox(height: Spacing.turnApp), line(NightPage.waitingKey, Lines.AI_3)];
+    if (_failed) return [const SizedBox(height: Spacing.turnApp), line(NightPage.failedKey, Lines.C4_P_6)];
+    return const [];
+  }
 }
diff --git a/app/lib/journal/pages/parts.dart b/app/lib/journal/pages/parts.dart
--- a/app/lib/journal/pages/parts.dart
+++ b/app/lib/journal/pages/parts.dart
@@ -188,6 +188,53 @@ class DreamBubble extends StatelessWidget {
   }
 }
 
+/// A reading in the readings' bubble, from the left (Spacing.bubbleTradition;
+/// How the AI Appears §2, §3): white with the surface's edge in the light
+/// theme, the bubble gradient in the dark; its tradition's [label] on a pill
+/// in the tradition gradient, white words, above its [text] in the readings'
+/// voice. The space under the label is a stand-in (StandIns.gap).
+class ReadingBubble extends StatelessWidget {
+  const ReadingBubble({super.key, required this.label, required this.text});
+
+  static const labelKey = Key('reading-label');
+
+  final String label;
+  final String text;
+
+  @override
+  Widget build(BuildContext context) {
+    final p = Palette.of(context);
+    const role = LightColours.labelTradition;
+    return Padding(
+      padding: Spacing.bubbleTradition,
+      child: Align(
+        alignment: Alignment.centerLeft,
+        child: DecoratedBox(
+          decoration: surface(p),
+          child: Padding(
+            padding: StandIns.bubblePadding,
+            child: Column(
+              crossAxisAlignment: CrossAxisAlignment.start,
+              children: [
+                DecoratedBox(
+                  key: labelKey,
+                  decoration: _pill(role.colour!, role.colourEnd!),
+                  child: Padding(
+                    padding: StandIns.labelPadding,
+                    child: Text(label, style: TypeRoles.button.style(role.text!)),
+                  ),
+                ),
+                const SizedBox(height: StandIns.gap),
+                Text(text, style: TypeRoles.voiceReadings.style(p.text)),
+              ],
+            ),
+          ),
+        ),
+      ),
+    );
+  }
+}
+
 /// A thin chevron, drawn as two strokes, pointing right, or left when
 /// [left] (head's message 20, items 4 and 9). Heard as nothing.
 class Chevron extends StatelessWidget {
diff --git a/app/lib/main_dev.dart b/app/lib/main_dev.dart
--- a/app/lib/main_dev.dart
+++ b/app/lib/main_dev.dart
@@ -7,7 +7,9 @@
 // Built with tool/preview_kept.py's file, it seeds the invented kept
 // sentences once, for the review of Life Context's page (D131 item 1).
 // Settings' Feedback section sends to our server with the same beta key
-// (D152 item 5: SoulDreams Dev only for now).
+// (D152 item 5: SoulDreams Dev only for now). Start Interpretation reads a
+// night through our server with it too (head's message 33: SoulDreams Dev
+// only, invented nights only); a night is read when it holds its readings.
 import 'dart:async';
 
 import 'package:flutter/widgets.dart';
@@ -22,6 +24,7 @@ import 'journal/channel_journal_files.dart';
 import 'journal/night_look.dart';
 import 'journal/pages/journal_home.dart';
 import 'journal/self_check.dart';
+import 'readings/readings.dart';
 import 'recording/connection.dart';
 import 'recording/record_microphone.dart';
 import 'recording/recording.dart';
@@ -43,14 +46,16 @@ void main() {
     connection: ChannelConnection(),
   );
   final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));
-  const read = bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead;
+  // Each night's calls' counts and cost kept beside it (head's message 34).
+  final readNight = liveReading(betaKey: const String.fromEnvironment('BETA_KEY'), keepUsage: true);
+  const read = bool.fromEnvironment('PREVIEW_READ') ? allRead : isRead;
   // The keyboard check (D50 1): only in a build made with
   // --dart-define=KEYBOARD_CHECK=true.
   runApp(
     SoulDreamsApp(
       home: const bool.fromEnvironment('KEYBOARD_CHECK')
           ? const KeyboardCheck()
-          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback),
+          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight),
     ),
   );
   if (check != null) unawaited(check);
diff --git a/app/test/dev_only_test.dart b/app/test/dev_only_test.dart
--- a/app/test/dev_only_test.dart
+++ b/app/test/dev_only_test.dart
@@ -75,6 +75,8 @@ void main() {
       expect(files.where((f) => f.startsWith('lib/life_context/')), isEmpty);
       // Feedback (D152 item 5): Dev only for now.
       expect(files.where((f) => f.startsWith('lib/feedback/')), isEmpty);
+      // The readings (head's message 33): SoulDreams Dev only.
+      expect(files.where((f) => f.startsWith('lib/readings/')), isEmpty);
       expect(files, isNot(contains(pending)));
     });
   }
@@ -102,6 +104,7 @@ void main() {
       ]),
     );
     expect(files, containsAll(['lib/feedback/feedback.dart', 'lib/feedback/feedback_section.dart']));
+    expect(files, contains('lib/readings/readings.dart'));
   });
 
   // R8, D108: the journal's pages, which testers will get, carry only the
diff --git a/app/test/journal/pages/journal_home_test.dart b/app/test/journal/pages/journal_home_test.dart
--- a/app/test/journal/pages/journal_home_test.dart
+++ b/app/test/journal/pages/journal_home_test.dart
@@ -161,6 +161,18 @@ void main() {
     expect(tester.widget<JournalPage>(find.byType(JournalPage)).read, same(allRead));
   });
 
+  testWidgets("SoulDreams Dev's reading is handed to the journal; by default none", (tester) async {
+    JournalStore.newQueueForTests();
+    Future<({List<Reading> readings, List<ModelUsage>? usage})> send(Map<String, Object?> body) async =>
+        (readings: <Reading>[], usage: null);
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), readNight: send)));
+    await tester.pumpAndSettle();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).readNight, same(send));
+    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(key: UniqueKey(), files: agreed(MemoryJournalFiles()))));
+    await tester.pumpAndSettle();
+    expect(tester.widget<JournalPage>(find.byType(JournalPage)).readNight, isNull);
+  });
+
   testWidgets('by default no night is read', (tester) async {
     JournalStore.newQueueForTests();
     await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
@@ -255,14 +267,19 @@ void main() {
       text,
       contains(
         'JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, '
-        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback)",
+        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight)",
       ),
     );
     // Every night read only in a build made for the by-eye preview (D110).
-    expect(text, contains("bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead"));
+    // Otherwise a night is read when it holds its readings (D155 item 2).
+    expect(text, contains("bool.fromEnvironment('PREVIEW_READ') ? allRead : isRead"));
     expect(text, contains("betaKey: const String.fromEnvironment('BETA_KEY')"));
     // Feedback, to our server with the same beta key (D152 item 5).
     expect(text, contains("final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));"));
+    // The readings, through our server with the same beta key (head's
+    // message 33: SoulDreams Dev only).
+    // Each night's calls' counts kept beside it (head's message 34).
+    expect(text, contains("liveReading(betaKey: const String.fromEnvironment('BETA_KEY'), keepUsage: true);"));
   });
 
   testWidgets('a folder that cannot open: a blank page, a code', (tester) async {
diff --git a/app/test/journal/pages/journal_page_test.dart b/app/test/journal/pages/journal_page_test.dart
--- a/app/test/journal/pages/journal_page_test.dart
+++ b/app/test/journal/pages/journal_page_test.dart
@@ -25,6 +25,7 @@ import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/sky_mark.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
+import 'package:souldreams/readings/readings.dart';
 import 'package:souldreams/journal/sky.dart';
 import 'package:souldreams/words/lines.g.dart';
 import 'package:souldreams/words/pending.g.dart';
@@ -637,4 +638,50 @@ void main() {
     await tester.pumpAndSettle();
     expect(find.byType(TypingPage), findsOneWidget);
   });
+
+  // The readings (head's message 33): given SoulDreams Dev's reading, a
+  // night opened from its row reads with Start Interpretation; back on the
+  // list, its row shows it read (its painting).
+  testWidgets("with a reading, Start Interpretation reads; the row shows it read", (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    final sent = <Map<String, Object?>>[];
+    await h.pump(
+      tester,
+      JournalPage(
+        journal: h.journal,
+        read: isRead,
+        readNight: (body) async {
+          sent.add(body);
+          return (readings: [Reading(0, '[STAND-IN · 1]')], usage: null);
+        },
+      ),
+    );
+    final look = lookOf(n, read: true, paintings: NightArt.paintings);
+    expect(tester.widget<NightArt>(find.descendant(of: find.byKey(JournalPage.rowKey(n.id)), matching: find.byType(NightArt))).look,
+        const PaintedGradient());
+    await tester.tap(find.byKey(JournalPage.rowKey(n.id)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pumpAndSettle();
+    // Life Context absent: nothing kept is sent.
+    expect(sent, [requestOf(n, null)]);
+    expect((await h.journal.night(n.id))!.readings, [Reading(0, '[STAND-IN · 1]')]);
+    await tester.tap(find.byKey(BackControl.buttonKey));
+    await tester.pumpAndSettle();
+    expect(tester.widget<NightArt>(find.descendant(of: find.byKey(JournalPage.rowKey(n.id)), matching: find.byType(NightArt))).look,
+        look);
+  });
+
+  testWidgets('without a reading, Start Interpretation sends nothing', (tester) async {
+    final h = await Harness.make();
+    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
+    await h.pump(tester, JournalPage(journal: h.journal, read: isRead));
+    await tester.tap(find.byKey(JournalPage.rowKey(n.id)));
+    await tester.pumpAndSettle();
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pumpAndSettle();
+    expect((await h.journal.night(n.id))!.readings, isNull);
+    expect(find.byKey(NightPage.waitingKey, skipOffstage: false), findsNothing);
+  });
 }
diff --git a/app/test/journal/pages/night_page_test.dart b/app/test/journal/pages/night_page_test.dart
--- a/app/test/journal/pages/night_page_test.dart
+++ b/app/test/journal/pages/night_page_test.dart
@@ -5,7 +5,10 @@
 // typing screen; Add dreams and Start Interpretation at the foot; the menu,
 // a bordered pill opening the phone's menu, holding delete, spoken as
 // MP·39, and above it the item an entry point gives (D107 item 1); one confirmation, Cancel first, Delete destructive; deleting
-// leaves nothing.
+// leaves nothing. The readings (head's message 33): Start Interpretation
+// reads the night with the page's reader (SoulDreams Dev's), AI·3 while it
+// waits, C4-P·6 alone when it fails; a read night shows MP·20, "The
+// Readings" (MP·36) and its readings, each under its tradition's label.
 import 'dart:async';
 
 import 'package:flutter/cupertino.dart';
@@ -26,6 +29,7 @@ import 'package:souldreams/journal/pages/parts.dart';
 import 'package:souldreams/journal/pages/typing_page.dart';
 import 'package:souldreams/journal/row_text.dart';
 import 'package:souldreams/journal/search.dart';
+import 'package:souldreams/readings/readings.dart';
 import 'package:souldreams/recording/recording.dart';
 import 'package:souldreams/words/lines.g.dart';
 import 'package:souldreams/words/pending.g.dart';
@@ -88,6 +92,8 @@ void main() {
     String? query,
     bool images = true,
     bool agreed = true,
+    Reader? reader,
+    List<Reading>? readings,
   }) async {
     // The test's own 800 by 600, where the foot's two buttons do not fill
     // the row, or a phone.
@@ -107,6 +113,10 @@ void main() {
       );
       await h.store.save(n);
     }
+    if (readings != null) {
+      n = n.withReadings(readings);
+      await h.store.save(n);
+    }
     // A first read that fails leaves the page blank, with no picture.
     if (unread) files!.failReads = true;
     await h.pump(
@@ -120,6 +130,7 @@ void main() {
           images: images,
           query: query,
           agreed: agreed,
+          reader: reader,
         ),
       ),
       hour: hour,
@@ -690,10 +701,10 @@ void main() {
     expect(tester.getCenter(find.text(Lines.MP_38.text(Lang.en))).dx, closeTo(width / 2, 1));
   });
 
-  testWidgets('the three other jumps do nothing yet', (tester) async {
+  testWidgets('the Questions and Reflection jumps do nothing yet', (tester) async {
     await open(tester, read: (_) => true, key: 'long-dream-en');
     final at = tester.getRect(find.byKey(NightPage.dreamsKey));
-    for (final o in [Jump.questions, Jump.readings, Jump.reflection]) {
+    for (final o in [Jump.questions, Jump.reflection]) {
       await tester.tap(find.byKey(NightPage.jumpKey(o)));
       await tester.pumpAndSettle();
       expect(tester.getRect(find.byKey(NightPage.dreamsKey)), at);
@@ -948,4 +959,176 @@ void main() {
     expect(actions.first.hitTestable(), findsOneWidget);
     expect(actions.last.hitTestable(), findsOneWidget);
   });
+
+  // The readings (head's message 33; D155 item 1). Placeholder readings, as
+  // the server's stand-in gives them: no tradition's words.
+  final three = [Reading(0, '[STAND-IN · 1]'), Reading(1, '[STAND-IN · 2]'), Reading(2, '[STAND-IN · 3]')];
+
+  // A reader whose answer waits for [answer]; each request kept.
+  ({Reader reader, List<Map<String, Object?>> sent, Completer<List<Reading>> Function() next}) held() {
+    final sent = <Map<String, Object?>>[];
+    var answer = Completer<List<Reading>>();
+    final reader = Reader((body) {
+      sent.add(body);
+      return answer.future.then((r) => (readings: r, usage: null));
+    }, () async => null);
+    return (
+      reader: reader,
+      sent: sent,
+      next: () => answer = Completer<List<Reading>>(),
+    );
+  }
+
+  testWidgets('Start Interpretation: AI·3 while it reads, then the readings, kept', (tester) async {
+    final r = held();
+    final answer = r.next();
+    await open(tester, reader: r.reader);
+    expect(find.byKey(NightPage.readingsKey, skipOffstage: false), findsNothing);
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pump();
+    await tester.pump();
+    expect(find.descendant(of: find.byKey(NightPage.waitingKey), matching: find.byType(AppLine)), findsOneWidget);
+    expect(tester.widget<AppLine>(find.byType(AppLine).last).text, Lines.AI_3.text(Lang.en));
+    expect(r.sent, [requestOf(n, null)]);
+    // A second tap while it reads sends nothing more.
+    await tester.tap(find.byKey(NightPage.startKey), warnIfMissed: false);
+    await tester.pump();
+    expect(r.sent, hasLength(1));
+    answer.complete(three);
+    await tester.pumpAndSettle();
+    expect(find.byKey(NightPage.waitingKey, skipOffstage: false), findsNothing);
+    expect(find.byKey(NightPage.readingsKey, skipOffstage: false), findsOneWidget);
+    for (final x in three) {
+      expect(find.text(x.text, skipOffstage: false), findsOneWidget);
+    }
+    expect((await h.journal.night(n.id))!.readings, three);
+    // Read: Start Interpretation is gone; Add dreams stays.
+    expect(find.byKey(NightPage.startKey), findsNothing);
+    expect(find.byKey(NightPage.addKey), findsOneWidget);
+  });
+
+  testWidgets('a failed reading: C4-P·6 alone, unread; Start Interpretation again', (tester) async {
+    final r = held();
+    final first = r.next();
+    await open(tester, reader: r.reader);
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pump();
+    first.completeError(const ReadingFailure(502));
+    await tester.pumpAndSettle();
+    expect(find.descendant(of: find.byKey(NightPage.failedKey), matching: find.byType(AppLine)), findsOneWidget);
+    expect(tester.widget<AppLine>(find.byType(AppLine).last).text, Lines.C4_P_6.text(Lang.en));
+    expect(find.byKey(NightPage.waitingKey, skipOffstage: false), findsNothing);
+    expect(find.byKey(NightPage.readingsKey, skipOffstage: false), findsNothing);
+    expect(find.text(Lines.MP_20.text(Lang.en), skipOffstage: false), findsNothing);
+    expect((await h.journal.night(n.id))!.readings, isNull);
+    final second = r.next();
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pump();
+    await tester.pump();
+    expect(find.byKey(NightPage.failedKey), findsNothing);
+    expect(find.byKey(NightPage.waitingKey), findsOneWidget);
+    second.complete(three.take(1).toList());
+    await tester.pumpAndSettle();
+    expect(find.byKey(NightPage.readingKey(0), skipOffstage: false), findsOneWidget);
+    expect(find.byKey(NightPage.readingKey(1), skipOffstage: false), findsNothing);
+  });
+
+  testWidgets('the waiting and failure lines are heard as they come', (tester) async {
+    final r = held();
+    final answer = r.next();
+    await open(tester, reader: r.reader);
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pump();
+    await tester.pump();
+    expect(tester.widget<Semantics>(find.byKey(NightPage.waitingKey)).properties.liveRegion, isTrue);
+    answer.completeError(const ReadingFailure(0));
+    await tester.pumpAndSettle();
+    expect(tester.widget<Semantics>(find.byKey(NightPage.failedKey)).properties.liveRegion, isTrue);
+  });
+
+  testWidgets('before agreeing, with a reader: the popup, nothing sent', (tester) async {
+    final r = held();
+    r.next();
+    await open(tester, wide: true, agreed: false, reader: r.reader);
+    await tester.tap(find.byKey(NightPage.startKey));
+    await tester.pumpAndSettle();
+    expect(find.text(PendingLines.MP_101.text(Lang.en)), findsOneWidget);
+    expect(r.sent, isEmpty);
+    expect(find.byKey(NightPage.waitingKey), findsNothing);
+  });
+
+  // A window tall enough to hold the whole night, so every part is built.
+  Future<void> tall(WidgetTester tester) async {
+    tester.view.physicalSize = const Size(1170, 9000);
+    await tester.pumpAndSettle();
+  }
+
+  testWidgets('a read night: MP·20, "The Readings", the readings in order, left', (tester) async {
+    await open(tester, readings: three, read: isRead);
+    await tall(tester);
+    final width = tester.getSize(find.byType(NightPage)).width;
+    final intro = find.text(Lines.MP_20.text(Lang.en));
+    final label = find.descendant(of: find.byKey(NightPage.readingsKey), matching: find.text(Lines.MP_36.text(Lang.en)));
+    expect(intro, findsOneWidget);
+    expect(label, findsOneWidget);
+    expect(tester.getCenter(label).dx, closeTo(width / 2, 1));
+    final tops = [
+      tester.getRect(find.text(n.dreams.last)).bottom,
+      tester.getRect(intro).top,
+      tester.getRect(label).top,
+      for (var i = 0; i < 3; i++) tester.getRect(find.byKey(NightPage.readingKey(i))).top,
+    ];
+    for (var i = 1; i < tops.length; i++) {
+      expect(tops[i], greaterThan(tops[i - 1]), reason: 'at $i');
+    }
+    for (var i = 0; i < 3; i++) {
+      final bubble = find.byKey(NightPage.readingKey(i));
+      final box = find.descendant(of: bubble, matching: find.byType(DecoratedBox)).first;
+      expect(tester.getRect(box).left, closeTo(Spacing.bubbleTradition.left, 1));
+      expect(tester.getRect(box).right, lessThanOrEqualTo(width - Spacing.bubbleTradition.right + 1));
+      expect(find.descendant(of: bubble, matching: find.text(three[i].text)), findsOneWidget);
+      expect(find.descendant(of: bubble, matching: find.text(lensLabel(Lines.W13, three[i].lens, Lang.en))), findsOneWidget);
+    }
+    // A reading's words in the readings' voice.
+    expect(tester.widget<Text>(find.text(three[0].text)).style!.fontFamily, TypeRoles.voiceReadings.family);
+    expect(find.byKey(NightPage.startKey), findsNothing);
+  });
+
+  testWidgets("a reading's label: the tradition's pill, in its gradient, white words", (tester) async {
+    await open(tester, readings: three.take(1).toList(), read: isRead);
+    await tall(tester);
+    final pill = find.descendant(of: find.byKey(NightPage.readingKey(0)), matching: find.byKey(ReadingBubble.labelKey));
+    final look = tester.widget<DecoratedBox>(pill).decoration as BoxDecoration;
+    expect((look.gradient! as LinearGradient).colors,
+        [LightColours.labelTradition.colour, LightColours.labelTradition.colourEnd]);
+    final words = tester.widget<Text>(find.descendant(of: pill, matching: find.byType(Text)));
+    expect(words.style!.color, LightColours.labelTradition.text);
+  });
+
+  test("a tradition's label: W13's part at its place, else its handle", () {
+    expect(Lines.W13.written, isFalse);
+    expect(lensLabel(Lines.W13, 0, Lang.en), '[W13]');
+    expect(lensLabel(Lines.W13, 2, Lang.sv), '[W13]');
+    const filed = Line('W13', ['A', 'B'], ['C', 'D']);
+    expect(lensLabel(filed, 1, Lang.en), 'B');
+    expect(lensLabel(filed, 0, Lang.sv), 'C');
+    expect(lensLabel(filed, 2, Lang.en), '[W13]');
+  });
+
+  testWidgets('the Readings jump brings "The Readings" to the top', (tester) async {
+    await open(tester, read: isRead, readings: three, key: 'long-dream-en');
+    final list = tester.getRect(find.byType(ListView));
+    await tester.tap(find.byKey(NightPage.jumpKey(Jump.readings)));
+    await tester.pumpAndSettle();
+    expect(tester.getRect(find.byKey(NightPage.readingsKey)).top, closeTo(list.top, 1));
+  });
+
+  testWidgets('a read night at twice the text size: no overflow', (tester) async {
+    tester.platformDispatcher.textScaleFactorTestValue = 2;
+    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
+    await open(tester, read: isRead, readings: three);
+    await tall(tester);
+    expect(find.byKey(NightPage.readingKey(2), skipOffstage: false), findsOneWidget);
+    expect(tester.takeException(), isNull);
+  });
 }
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -3,7 +3,7 @@
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
 # Parallel by default (D129), each worker in its own copy of app/ in
 # $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
-# Expected: every row "caught" (A1 to A890, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
+# Expected: every row "caught" (A1 to A913, A418 to A422, A424 to A426, A429 and A781 dropped (curated-set, D149: the date's shade is gone), A369 and A409 to A411 dropped (curated-set, D147: the placeholder paintings and the code-drawn stars are gone), A551, A552, A710 and A711 dropped (life-context, D134: Off pauses, so Settings asks nothing at Off and deletes nothing), A744 dropped (D134 item 5: the seed no longer depends on Life Context being on), A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
@@ -1308,8 +1308,8 @@ ROWS = [
      'padding: EdgeInsets.only(top: Spacing.nightHeader.top) + side,',
      'test/journal/pages/night_page_test.dart', "the bubbles: 30 from the left edge, 10 from the right"),
     ('A264', 'lib/journal/pages/night_page.dart',
-     'onPressed: () {\n                          if (!widget.agreed) showAgreementPopup(context);\n                        },',
-     'onPressed: () => _type(null),',
+     'PlainButton(Lines.EM_1.text(appLanguage), onPressed: _start)',
+     'PlainButton(Lines.EM_1.text(appLanguage), onPressed: () => _type(null))',
      'test/journal/pages/night_page_test.dart', 'Add dreams bottom left, Start Interpretation bottom right'),
     ('A265', 'lib/journal/pages/parts.dart',
      'mainAxisAlignment: MainAxisAlignment.spaceBetween,',
@@ -1805,9 +1805,9 @@ ROWS = [
      '',
      'test/journal/pages/night_page_test.dart', 'the Dreams jump brings "Dreams" to the top'),
     ('A385', 'lib/journal/pages/night_page.dart',
-     'jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], null),',
+     'jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], _readingsLabel),',
      'jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], _dreamsLabel),',
-     'test/journal/pages/night_page_test.dart', 'the three other jumps do nothing yet'),
+     'test/journal/pages/night_page_test.dart', 'the Readings jump brings "The Readings" to the top'),
     ('A386', 'lib/journal/pages/night_page.dart',
      'jump(Jump.reflection, [tag.colour!, tag.colourEnd!], null),',
      'jump(Jump.reflection, [tag.colourEnd!, tag.colour!], null),',
@@ -1830,7 +1830,7 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'whether a night is read is handed to the journal'),
     ('A391', 'lib/main_dev.dart',
-     "bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead",
+     "bool.fromEnvironment('PREVIEW_READ') ? allRead : isRead",
      "bool.fromEnvironment('PREVIEW_READ') ? allRead : allRead",
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A392', 'lib/journal/night_look.dart',
@@ -2662,8 +2662,8 @@ ROWS = [
      '                            if (false) showAgreementPopup(context);',
      'test/journal/pages/typing_page_test.dart', 'before agreeing: Start Interpretation shows the popup'),
     ('A656', 'lib/journal/pages/night_page.dart',
-     '                          if (!widget.agreed) showAgreementPopup(context);',
-     '                          if (false) showAgreementPopup(context);',
+     '    if (!widget.agreed) {\n      showAgreementPopup(context);',
+     '    if (false) {\n      showAgreementPopup(context);',
      'test/journal/pages/night_page_test.dart', 'before agreeing: Start Interpretation shows the popup'),
     ('A657', 'lib/journal/pages/night_page.dart',
      '      recording: widget.recording,\n      agreed: widget.agreed,\n    );',
@@ -3038,8 +3038,8 @@ ROWS = [
      '',
      'test/journal/pages/journal_home_test.dart', 'the preview seeds before the journal opens; a failure, a code'),
     ('A752', 'lib/main_dev.dart',
-     ", preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback)",
-     ', feedback: feedback)',
+     ", preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight)",
+     ', feedback: feedback, readNight: readNight)',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
     ('A753', 'lib/main.dart',
      "import 'core/safe_log.dart';\n",
@@ -3387,8 +3387,8 @@ ROWS = [
      '',
      'test/settings/settings_page_test.dart', 'Feedback: after the kept row, before the actions, given a sender'),
     ('A835', 'lib/journal/pages/journal_home.dart',
-     '        feedback: widget.feedback,\n      ),\n    };',
-     '      ),\n    };',
+     '        feedback: widget.feedback,\n        readNight: widget.readNight,\n      ),\n    };',
+     '        readNight: widget.readNight,\n      ),\n    };',
      'test/settings/settings_page_test.dart', 'Feedback: after the kept row, before the actions, given a sender'),
     ('A836', 'lib/main_dev.dart',
      "  final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));",
@@ -3615,6 +3615,99 @@ ROWS = [
      'keepUsage: true',
      'keepUsage: false',
      'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
+    # The readings on a night's page, and SoulDreams Dev's reader (head's message 33).
+    ('A891', 'lib/journal/pages/night_page.dart',
+     '      return;\n    }\n    final reader = widget.reader;',
+     '    }\n    final reader = widget.reader;',
+     'test/journal/pages/night_page_test.dart', 'before agreeing, with a reader: the popup, nothing sent'),
+    ('A892', 'lib/journal/pages/night_page.dart',
+     ' || _busy || _reading) return;',
+     ' || _busy) return;',
+     'test/journal/pages/night_page_test.dart', 'Start Interpretation: AI·3 while it reads, then the readings, kept'),
+    ('A893', 'lib/journal/pages/night_page.dart',
+     '      _failed = done == Interpreted.failed;',
+     '      _failed = false;',
+     'test/journal/pages/night_page_test.dart', 'a failed reading: C4-P·6 alone, unread; Start Interpretation again'),
+    ('A894', 'lib/journal/pages/night_page.dart',
+     '    _toEnd();\n    final done',
+     '    final done',
+     'test/journal/pages/night_page_test.dart', 'Start Interpretation: AI·3 while it reads, then the readings, kept'),
+    ('A895', 'lib/journal/pages/night_page.dart',
+     '      _reading = false;\n      _failed = done',
+     '      _reading = true;\n      _failed = done',
+     'test/journal/pages/night_page_test.dart', 'a failed reading: C4-P·6 alone, unread; Start Interpretation again'),
+    ('A896', 'lib/journal/pages/night_page.dart',
+     'right: n.readings != null',
+     'right: n.readings != null && n.dreams.isEmpty',
+     'test/journal/pages/night_page_test.dart', 'a read night: MP·20, "The Readings", the readings in order, left'),
+    ('A897', 'lib/journal/pages/night_page.dart',
+     '                  scrollCacheExtent: const ScrollCacheExtent.pixels(100000),\n',
+     '',
+     'test/journal/pages/night_page_test.dart', 'the Readings jump brings "The Readings" to the top'),
+    ('A898', 'lib/journal/pages/night_page.dart',
+     'lens < parts.length ? parts[lens]',
+     'lens <= parts.length ? parts[lens]',
+     'test/journal/pages/night_page_test.dart', "a tradition's label: W13's part at its place, else its handle"),
+    ('A899', 'lib/journal/pages/night_page.dart',
+     'line(NightPage.waitingKey, Lines.AI_3)',
+     'line(NightPage.waitingKey, Lines.AI_4)',
+     'test/journal/pages/night_page_test.dart', 'Start Interpretation: AI·3 while it reads, then the readings, kept'),
+    ('A900', 'lib/journal/pages/night_page.dart',
+     'line(NightPage.failedKey, Lines.C4_P_6)',
+     'line(NightPage.failedKey, Lines.EM_8)',
+     'test/journal/pages/night_page_test.dart', 'a failed reading: C4-P·6 alone, unread; Start Interpretation again'),
+    ('A901', 'lib/journal/pages/night_page.dart',
+     '        key: key,\n        liveRegion: true,',
+     '        key: key,\n        liveRegion: false,',
+     'test/journal/pages/night_page_test.dart', 'the waiting and failure lines are heard as they come'),
+    ('A902', 'lib/journal/pages/night_page.dart',
+     'child: AppLine(Lines.MP_20.text(appLanguage)',
+     'child: AppLine(Lines.MP_38.text(appLanguage)',
+     'test/journal/pages/night_page_test.dart', 'a read night: MP·20, "The Readings", the readings in order, left'),
+    ('A903', 'lib/journal/pages/night_page.dart',
+     'for (final (i, r) in readings.indexed)',
+     'for (final (i, r) in readings.take(1).indexed)',
+     'test/journal/pages/night_page_test.dart', 'a read night: MP·20, "The Readings", the readings in order, left'),
+    ('A904', 'lib/journal/pages/parts.dart',
+     '      padding: Spacing.bubbleTradition,',
+     '      padding: Spacing.bubbleDreamer,',
+     'test/journal/pages/night_page_test.dart', 'a read night: MP·20, "The Readings", the readings in order, left'),
+    ('A905', 'lib/journal/pages/parts.dart',
+     '        alignment: Alignment.centerLeft,\n        child: DecoratedBox(\n          decoration: surface(p),',
+     '        alignment: Alignment.centerRight,\n        child: DecoratedBox(\n          decoration: surface(p),',
+     'test/journal/pages/night_page_test.dart', 'a read night: MP·20, "The Readings", the readings in order, left'),
+    ('A906', 'lib/journal/pages/parts.dart',
+     'Text(text, style: TypeRoles.voiceReadings.style(p.text))',
+     'Text(text, style: TypeRoles.voiceApp.style(p.text))',
+     'test/journal/pages/night_page_test.dart', 'a read night: MP·20, "The Readings", the readings in order, left'),
+    ('A907', 'lib/journal/pages/parts.dart',
+     'key: labelKey,\n                  decoration: _pill(role.colour!, role.colourEnd!),',
+     'key: labelKey,\n                  decoration: _pill(role.colourEnd!, role.colour!),',
+     'test/journal/pages/night_page_test.dart', "a reading's label: the tradition's pill, in its gradient, white words"),
+    ('A908', 'lib/journal/pages/parts.dart',
+     'child: Text(label, style: TypeRoles.button.style(role.text!)),',
+     'child: Text(label, style: TypeRoles.button.style(p.text)),',
+     'test/journal/pages/night_page_test.dart', "a reading's label: the tradition's pill, in its gradient, white words"),
+    ('A909', 'lib/journal/night_look.dart',
+     'bool isRead(Night night) => night.readings != null;',
+     'bool isRead(Night night) => false;',
+     'test/journal/pages/journal_page_test.dart', "with a reading, Start Interpretation reads; the row shows it read"),
+    ('A910', 'lib/journal/pages/journal_page.dart',
+     'Reader(send, () => keptFor(widget.lifeContext))',
+     'Reader(send, () async => <String>[])',
+     'test/journal/pages/journal_page_test.dart', "with a reading, Start Interpretation reads; the row shows it read"),
+    ('A911', 'lib/journal/pages/journal_page.dart',
+     '          query: query,\n          reader: _reader,',
+     '          query: query,',
+     'test/journal/pages/journal_page_test.dart', "with a reading, Start Interpretation reads; the row shows it read"),
+    ('A912', 'lib/journal/pages/journal_home.dart',
+     '        readNight: widget.readNight,\n',
+     '',
+     'test/journal/pages/journal_home_test.dart', "SoulDreams Dev's reading is handed to the journal; by default none"),
+    ('A913', 'lib/main_dev.dart',
+     "liveReading(betaKey: const String.fromEnvironment('BETA_KEY'), keepUsage",
+     "liveReading(betaKey: '', keepUsage",
+     'test/journal/pages/journal_home_test.dart', 'SoulDreams Dev hands its phone check and recording to the list'),
 ]
 
 
~~~~

### Task 7 · Docs: Status.md

Changed: `docs/Status.md`: the first line, the current branch (and `feedback`'s merge), the road ahead, the night's
format, the read look, the readings in the app and on the server, banked item 173 (c), the totals, and "Rulings
during readings-plumbing" (D155 to D157 and the head's message 34, and the answers to questions 21 to 28 when
given).

Commit:

> Status.md: readings-plumbing part one (D155 to D157, head's message 34); feedback's merge recorded

**The block:**

~~~~diff
diff --git a/docs/Status.md b/docs/Status.md
--- a/docs/Status.md
+++ b/docs/Status.md
@@ -1,6 +1,6 @@
 # Status — SoulDreams app
 
-Last updated: 2026-11-24, in branch `feedback` (the Feedback section of Settings and its server change, D152, D153; built and tested, the owner's deploy, by-eye check and first reading next), by Claude Code.
+Last updated: 2026-11-24, in branch `readings-plumbing` (the readings with a stand-in model, part one: the reading, D155 to D157, head's message 34; built and tested, the owner's storage rehearsal, deploy and by-eye check next), by Claude Code.
 
 *No matter where you are on your journey, the steps you take are equally important.*
 
@@ -14,13 +14,23 @@ rulings given during each branch are listed in this file, one line each, under "
 
 ## Current branch
 
-`feedback`: the Feedback section of Settings and its server change (D110; C18-P; D152; plan `docs/plans/feedback.md`).
-Settings in SoulDreams Dev gains MP·49, a card with C4-P·8, a field (MP·46 as its hint, at most 2,000 characters)
-and Submit (MP·47). A feedback goes to our server's `POST /feedback` with the beta key and the text alone; the
-server puts the text in a private, encrypted bucket in eu-north-1 under its UTC day, deleted after 90 days; the owner
-reads it with `tool/read_feedback.sh`, which moves it to his Mac and deletes it from the bucket. Before "I agree",
-Submit shows the popup (MP·101); a failed send keeps the text and shows MP·105, a sent one empties the box and shows
-MP·106, the owner's pending lines (D153). The plan's questions are its Part 4.
+`readings-plumbing`, part one: the reading (head's message 33; D155; plan `docs/plans/readings-plumbing.md`). In
+SoulDreams Dev, Start Interpretation on a night's page sends the night (its language, its dreams in words and, only
+while Life Context is On, the sentences it keeps, D134) to our server's `POST /reading` with the beta key; the server
+hands it to its stand-in model, which answers three fixed placeholder readings marked `[STAND-IN · n]`, the same for
+every night, reading nothing of it. AI·3 shows while it waits; the readings are kept in the night, which is then
+read (its painting, its jump buttons); a failure shows C4-P·6 alone and the night stays unread. A read night shows
+MP·20, "The Readings" (MP·36) and its readings, each under its tradition's label, `[W13]` until W13 has a line. The
+night's file is version 3 (D155 item 2, docs/workflow.md (c)). The model's instructions drop in as files in
+`server/instructions/`, which holds only the empty placeholder `AWAITING-INSTRUCTIONS.md` (R7). Every model call goes
+through one interface, each step's model named in one setting (`server/src/models.ts`, `SETUP`), its tokens and cost
+counted and logged as numbers, and kept beside the night's readings in SoulDreams Dev (head's message 34); prompts put
+fixed text first and the dreamer's words last, and prompt caching is off until AWS's pages say it fits retention mode
+none. Part two, the painting (D143, D145, D146, D123), is planned after this part's merge; the founder's blind
+comparison (head's message 34 item 4) is planned, not built. Also D156: a feedback of invisible characters only is
+blank.
+
+`feedback` is merged (`de0a315`), its by-eye check and first reading passed (Task 9).
 
 `curated-set` is merged (`4a22d1a`): the curated set of night paintings (D147, with D149 to D151). Its Status was not
 updated at the merge (this entry records it).
@@ -38,8 +48,12 @@ merge (this entry records it).
 
 ## Road ahead
 
-- `feedback`: the owner's answers to the plan's Part 4, the package (Task 1), the build, the deploy (Task 8), the by-eye
-  check and the first reading (Task 9), the full mutation runs once (D126), then the merge, which is the owner's.
+- `readings-plumbing`, part one: the owner's answers to the plan's Part 4, the storage rehearsal on the phone (Task 3),
+  the deploy (Task 8), the by-eye check (Task 9), the full mutation runs once (D126), then the merge, which is the
+  owner's. The C19-P import (the design system, the product change record, the register) comes before Task 6.
+  Before the merged build reaches the Cohort 0 app, the owner's safety export (docs/workflow.md (c) item 4).
+- `readings-plumbing`, part two: the painting (D143, D145, D146, D123; D155 items 1 and 3): its plan after part one's
+  merge.
 - `life-context` (merged): the owner's by-eye review passed (plan Task 7, with D133 and D134; VoiceOver waits for
   the full pass, D98) and the full mutation run was done: `app mutations: 726 run, 726 caught` at `46d5ebd` (9 min
   1 s on the owner's Mac, parallel). The Product questions are banked (items 167 and 169).
@@ -81,8 +95,11 @@ merge (this entry records it).
 - The fonts (D49 a): Tangerine, Sorts Mill Goudy, Inter (Regular and SemiBold, the 18pt statics), Nunito (Regular,
   Italic) and Habibi, static TTFs with their OFL licences in `app/assets/fonts/`, each listed in `fingerprints.txt`
   (G2), declared in `pubspec.yaml`. The owner's download; never fetched at run time (R10).
-- The journal's store (D49 b, c), with no screen yet: `app/lib/journal/`. One JSON file per night, format version 2
-  (version 1 still read; D93 Q2: a dream is told in words or a recording waiting, `{"waiting", "from"}`),
+- The journal's store (D49 b, c), with no screen yet: `app/lib/journal/`. One JSON file per night, format version 3
+  (versions 1 and 2 still read; D93 Q2: a dream is told in words or a recording waiting, `{"waiting", "from"}`;
+  D155 item 2: `readings`, null while unread, else one to three `{"lens", "text"}`; head's message 34: `usage`,
+  each model call's `{"step", "model", "input", "output", "cacheRead", "cacheWrite", "cost"}`, beside the readings
+  only, where the build keeps them),
   in `Library/Application Support/Journal`; the folder excluded from backup; the folder and every file with complete
   file protection, through the Swift channel in `AppDelegate.swift`. A save writes a temporary file, flushes it to the
   disk (F_FULLFSYNC, else fsync) and renames it; a failed save removes its own temporary file. Every store operation
@@ -227,8 +244,20 @@ merge (this entry records it).
   other three do nothing until the readings); everything below as before. Naming is removed: a name kept in a file
   is not shown (the store's field stays; the export still writes it). A night's picture (`journal/night_look.dart`,
   `pages/night_art.dart`): a read night's painting chosen from its id alone, nothing stored; an unread night's the
-  painted gradient (the dark theme's bubble gradient, both themes); no night is read yet (`noneRead`), and
-  SoulDreams Dev built with `--dart-define=PREVIEW_READ=true` shows every night as read, for the owner's review.
+  painted gradient (the dark theme's bubble gradient, both themes); in SoulDreams Dev a night is read when it holds
+  its readings (`isRead`), in the other builds none is (`noneRead`), and SoulDreams Dev built with
+  `--dart-define=PREVIEW_READ=true` shows every night as read, for the owner's review.
+- The readings (head's message 33; `app/lib/readings/readings.dart`; SoulDreams Dev only, `dev_only_test.dart`):
+  `postReading` (one POST to `Hosts.server` + `reading`, the beta key, `{"lang", "dreams", "kept"?}`, 30 seconds;
+  anything but 200 with one to three whole readings fails: the status, 0 no answer, -1 unreadable, -2 no server or
+  key; the answer's `usage` kept only by `liveReading(keepUsage: true)`, SoulDreams Dev's), `keptFor` (Life
+  Context's Recent list while On, nothing while Off, D134), `interpret` (a night already read
+  or with no dream in words is not sent; the readings kept with `Journal.keepReadings`, a night's first kept; codes
+  `readingRead`, `readingFailed`, `readingKeepFailed`). On the night's page: Start Interpretation (EM·1) reads with
+  the page's reader, AI·3 (`waitingKey`, brought into view) while it waits, C4-P·6 (`failedKey`) alone on a
+  failure; a read night shows MP·20, MP·36 and each reading in `ReadingBubble` (`parts.dart`: the readings'
+  bubble from the left, its tradition's pill, the readings' voice), and no Start Interpretation; the Readings jump
+  brings "The Readings" to the top; the list lays out every part (`scrollCacheExtent`).
   The curated set (D147): sixty paintings in `app/assets/paintings/`, each covering its box from the middle over
   the gradient, decoded no larger than the box needs; New Dream's sky is the set's strip, under the row's
   40% (D150). The words Product owes show as provisional
@@ -368,7 +397,7 @@ merge (this entry records it).
 - Values the Design System leaves unset are named stand-ins in `app/lib/design/stand_ins.dart`, matched by eye to the
   founder's screenshots (`docs/reference/screens/`, fingerprinted, G2) and corrected by the founder in Cohort 0
   (P13).
-- The app's analyzer baseline: `No issues found!`. The app has 790 tests, and 776 mutation checks (A1 to A837; A418 to A422, A424 to A426, A429, A781 (D149), A24ah,
+- The app's analyzer baseline: `No issues found!`. The app has 832 tests, and 852 mutation checks (A1 to A913; A418 to A422, A424 to A426, A429, A781 (D149), A24ah,
   A24ar, A24as, A55, A73, A80 to A83, A86 to A88, A94, A99, A128 to A130, A142, A207, A213, A223, A252 to A255, A270,
   A277, A278, A281, A288, A291, A300, A301, A302, A313, A363, A375, A507, A518, A521, A526, A527, A530, A537, A538, A539, A540, A541, A543, A546, A549, A550, A553, A554, A558, A566, A574, A575, A578, A583, A585 to A600, A610, A623, A624, A626, A627, A629, A633, A634, A635, A645, A646, A369 and A409 to A411
   dropped, each with its reason in the file; with the rows A24a to
@@ -394,6 +423,19 @@ merge (this entry records it).
   2.1147.0 (D42 Q1, Q14), and `@aws-sdk/client-ssm` and `@aws-sdk/client-s3` at the owner's version, for their types only: the Lambda runtime
   carries its own SDK, and the Lambda's code folder holds no package (D71 Q13 a). The owner installs them; Claude Code's settings deny every install, and it runs `npm ci
   --offline` only through `check_all.sh` (D42 Q13).
+- `server/src/`: the readings (head's message 33): POST `/reading` with the beta key and a JSON body of `lang`
+  (`en` or `sv`), `dreams` (one or more non-blank strings) and, optionally, `kept` (strings), at most 262,144
+  characters, gets 200 `{readings, usage}` from the readings step (`reading.ts`): its prompt the instructions first
+  and the night last, its model's text parsed as one to three readings, its call's counts and cost; with the
+  stand-in, three fixed `[STAND-IN · n]` readings and zero tokens; a body that is not that 400, too long 413
+  (`readingRefused` with the status), the model failing or its text not readings 502 (`readingFailed`), given
+  `readingGiven` with the count. Every model call goes through `callModel` (`models.ts`, head's message 34): the step's
+  model from `SETUP` (opening, readings, checks, scenery, recurrence; each the stand-in now), its caller, its tokens
+  and cost (`PRICES`, millionths of a dollar) logged as `modelUsage` numbers; `PROMPT_CACHING` false. The steps
+  are handed the instructions read once from `dist/src/instructions/` (`instructions.ts`; every `.md` but the
+  placeholder, in name order), which `infra/dist.ts`
+  copies from `server/instructions/` (R7: only the empty `AWAITING-INSTRUCTIONS.md`). No Bedrock call, no new
+  permission, the 10-second timeout unchanged.
 - `server/src/`: the front door (`door.ts`, head's message 14; D71): POST `/` with the beta key as a bearer token gets
   a short-lived Soniox key (200, `{key, expiresAt}`); a missing, wrong or misshapen key 401 with no body, before
   anything is read when misshapen; another method or path 404; Parameter Store failing 500; Soniox failing 502
@@ -436,11 +478,11 @@ merge (this entry records it).
   scenes and the sky) and `server/trial/jpeg.ts` (sizes, the sRGB profile and the AI tag, written by our own code;
   its names in `server/src/hosts.ts`, never fetched). macOS's `sips` makes each JPEG, and our code embeds the OS's own
   sRGB profile in it, since `sips` on macOS 26 writes none. Tested against fakes.
-- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 156 tests, and
-  133 mutation checks (S1 to S138, S42 retired with the budget resource, D138, S82 to S85 with the style test, D146)
+- The server's analyzer baseline: `npm run check` prints only its header and exits 0. The server has 183 tests, and
+  173 mutation checks (S1 to S178, S42 retired with the budget resource, D138, S82 to S85 with the style test, D146)
   in `tool/server_mutations.py`, run by
-  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 133 run,
-  133 caught`); `check_all.sh` does not
+  hand from the repository root with `python3 -I -B tool/server_mutations.py` (expected: `server mutations: 173 run,
+  173 caught`); `check_all.sh` does not
   call it (D43 Q3). It first runs the type check and the tests on the unbroken server, and stops with
   `server mutations: FAILED (the unbroken server fails)`, exit 1, if either fails (the final review, `2fbaad6`).
 
@@ -1142,7 +1184,7 @@ Banked in image-trial (D91; nothing a dreamer sees changes):
      policy (termination protection is on; the other protections and the 90 days stay); (b) the lifecycle has no
      rule aborting incomplete multipart uploads (our code only puts whole objects); (c) a text of only U+200B or
      U+0000 is not "blank" (`trim` as Dart's does; the app and the server agree), a question for the owner if it
-     matters; (d) a base64 body is decoded before the 65,536 check, which Lambda's own 6 MB limit bounds; (e) a
+     matters (closed for the app by D156: such a text is blank and not sent; the server still keeps it); (d) a base64 body is decoded before the 65,536 check, which Lambda's own 6 MB limit bounds; (e) a
      body with a repeated `text` key keeps the last (still one field).
 
 ## Before Cohort 1
@@ -1778,6 +1820,24 @@ Lines given and approved, shown in SoulDreams Dev only until Product registers t
 - D154 (the founder's by-eye correction): the Feedback box's border is the colour of the Settings value pills' border
   (`surfaceBorder`), light and dark (it was `fieldBorder`, which is clear in the dark theme). App tests 790, rows 776.
 
+## Rulings during readings-plumbing
+
+- `feedback` merged by the owner (`de0a315`).
+- D155 (owner, the brainstorm): (1) a large plan is split, first the reading (request, answer, night read), then the
+  painting; (2) the night file gains its readings as a storage change under docs/workflow.md (c), with the owner's
+  rehearsal on the phone; (3) the BFL key moves to a permanent Parameter Store name (owner task); (4) owed words
+  show as handles, listed for the head. D91 and D126 apply.
+- D156 (owner, on banked item 173 (c)): a feedback text of invisible characters only (zero-width spaces, U+0000 and
+  the like) counts as blank and is not sent (`feedback.dart`: whitespace, `Cc` and `Default_Ignorable_Code_Point`;
+  row A838).
+- D157 (owner): the plan's Part 4 questions take their leans (Q2 straight to the readings for now; Q8 the Recent
+  window sent while On; Q15 D156 on the app only; Q19 the storage change ships alone, with the safety export before
+  the founder's app). Added from the head's message 34 (2026-11-24, from Organisation's business-model.md): one
+  interface for every model call, the model per step in one setting; token counts and cost per call, the server
+  logging numbers only and the app keeping each night's beside it (Dev, and the founder's build later); prompts with
+  fixed text first and the dreamer's words last, caching off until AWS's pages confirm it fits retention mode none;
+  the founder's blind comparison planned, not built (plan Part 7).
+
 ## Documents as last imported
 
 Imported by the owner at the documents repository's `ac3a013`, in branch `redesign-b` (C18-P and C160-I); the
~~~~

### Task 8 · [OWNER] The deploy

The server's code changes (the new route and the instructions folder); nothing else in the stack does.

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app/server && npm run build && npx cdk diff -c account=<workload id> --profile <workload profile>
```

Expected: the diff shows only `AWS::Lambda::Function` `SoulDreamsServer…` with its `Code` changed (the asset's hash);
no IAM, bucket, URL, output or log group change. Anything else: stop and bring the diff.

Paste 2 — Terminal (only if Paste 1 was as expected)

```
cd ~/Developer/soul-dreams-app/server && npx cdk deploy -c account=<workload id> --profile <workload profile>
```

Expected: `SoulDreamsServer` updated, the same `FunctionUrl` output as before. The address in `hosts.dart` does not
change.

### Task 9 · [OWNER] The by-eye check, SoulDreams Dev, invented nights only

SoulDreams Dev built from `readings-plumbing` with the beta key, as for feedback, installed over the Task 3 build.
Invented nights only (R2): type them from `fixtures/invented-nights.json`.

1. **Not agreed** (only on an install that has not agreed; skip otherwise): Start Interpretation shows the popup
   (MP·101) and nothing else.
2. **A night of two dreams, Life Context Off** (Settings): open it, tap Start Interpretation. Expected: "Preparing
   the readings..." under the dreams, then, within a few seconds: the line before the readings (MP·20), the green
   "The Readings" pill, and three bubbles from the left, each with a terracotta `[W13]` pill and the words
   `[STAND-IN · 1]`, `· 2`, `· 3`. The header now shows a painting; Start Interpretation is gone; Add dreams stays.
3. **The jump buttons**: Readings brings "The Readings" to the top; Dreams brings "Dreams".
4. **Back to the journal**: the night's row shows its painting. Open it again: the same readings, the same order.
5. **The dark theme** (Night/Day mode, Night): the readings' bubbles in the bubble gradient, the words light.
6. **A failed reading**: turn Wi-Fi and mobile data off, open another night, tap Start Interpretation. Expected:
   "Preparing the readings...", then "This reading didn't go through. A problem within the app occurred." alone; the
   night stays unread (gradient). Turn the network on, tap Start Interpretation again: the readings come.
7. **Life Context On** with kept sentences (the invented ones, `tool/preview_kept.py`'s build, or none): a reading
   works the same (the stand-in ignores what is sent). What is sent is proven by the tests, not by eye.
8. **The storage**: every night typed before this build still shows whole (Task 3's check again).
9. **Large text** (Settings → Accessibility → Larger Text, the largest): a read night scrolls through its readings;
   nothing is cut.
10. **The server's log** (CloudWatch, the Lambda's log group): each reading shows as `modelUsage 1 0 0 0 0 0 0` (the
    readings step, the stand-in, zero tokens, zero cost) then `readingGiven 3`; for the failure, nothing (it never
    reached the server); no word of any night.

Expected everywhere: nothing else changed. Anything different: stop, and bring what you saw.

### Task 10 · The full mutation runs (D126)

Once, after Task 9 and before the merge: `python3 -I -B tool/app_mutations.py` (expected `app mutations: 852 run,
852 caught`) and `python3 -I -B tool/server_mutations.py` (expected `server mutations: 173 run, 173 caught`, about
35 minutes, serial).

Then, before the merged build reaches the Cohort 0 app (docs/workflow.md (c) items 4 and 5): the owner exports each
night as C142-I item 3 rules (AirDrop to the Mac, into `restricted/`), installs, checks every night by eye, and deletes
the safety copy. The founder's build changes only in its night format: its readings, its page and its reader are
SoulDreams Dev's alone.

## Part 4 · Questions (numbered; a blank is not a yes)

Questions 1 to 20: **answered by D157, each its lean** (Q1 as Tasks 0a and 0b). Questions 21 to 28 come with the
head's message 34 and are open.

1. **The C19-P import.** Answered (D157): before the tasks, now Tasks 0a and 0b (three documents, the register last).
2. **Scope: Start Interpretation goes straight to the readings** in this branch, on the night's page, with no
   mirror, opening, close or reflection, and in SoulDreams Dev only. main-path.md says it "goes to the mirror": the
   mirror and the opening come with their instructions. Lean: yes; the typing screen's Start Interpretation stays as
   it is (the popup before "I agree", else nothing).
3. **The stand-in's answer**: three readings, at W13's places 0, 1 and 2, each `[STAND-IN · n]`, the same for every
   night. Lean: yes. Another marked form is a one-line change.
4. **The answer's shape**: a reading is `{lens, text}`, the tradition as its place among W13's labels, the label the
   register's line chosen on the phone (R1). The image line, the arc, the press, the series question, the decline and
   the why-line are not in it; each, when its instructions come, extends the answer and the night's file, so each is
   another storage change. Lean: yes, as the smallest shape that runs the flow.
5. **W13 shown as `[W13]`** on every label until W13 is written in both languages (its status now: "English written,
   Swedish to write"). Lean: yes (D155 item 4; for the head).
6. **Start Interpretation is gone from a read night**; Add dreams stays. Lean: yes (a night is read once; the late
   telling and what it means for a read night wait for the practice).
7. **AI·3 brought into view at once** (a jump to the list's end, no motion) when Start Interpretation is tapped,
   since on a long night it would stand below the screen. Lean: yes.
8. **What Life Context sends while On**: every sentence in the Recent window (all nights', newest first, word for
   word), even when none (an empty list is sent); while Off, nothing at all (the field is left out). The stand-in
   ignores both; D110 item 2's "the readings' use of kept words" stays for the instructions. Lean: yes.
9. **A night with a recording still waiting**: only the dreams in words are sent; a night with no dream in words yet
   is not sent at all (Start Interpretation does nothing). Lean: yes; EM·8's offline line is not built.
10. **A failed reading** shows C4-P·6 until Start Interpretation is tapped again or the page is left; nothing retries
    by itself. Lean: yes (handover §5).
11. **No Bedrock in this branch**: no call, no permission, no spending counter (D69), no EM·8. They come with Claude
    Opus 5.5, after C3-T 2d's and 2e's account checks (C3-T item 9: before any dreamer's words pass through). Lean:
    yes.
12. **The Lambda's 10-second timeout and no streaming** stay for the stand-in, which answers at once; the branch
    that brings Opus 5.5 sets them (head's message 14; Road ahead). Lean: yes.
13. **Limits**: a request body of at most 262,144 characters on the server; the app waits 30 seconds for an answer.
    Lean: yes, revisited with the real model.
14. **The readings travel in plain JSON in the function URL's reply**, through our server only (R10), and the server
    logs only their count. Lean: yes.
15. **D156 on the server**: the app no longer sends a text of invisible characters only; the server still accepts
    one (its `trim`). Lean: leave the server as it is (D156 asked for one row; the app never sends it).
16. **D156's set**: whitespace, `Cc` and `Default_Ignorable_Code_Point`; the braille blank U+2800 is not counted
    (it is a visible-width character). Lean: yes.
17. **The journal's own empty check** (`isEmptyText`, five invisible characters) is not widened by D156. Lean: bank
    it for the owner (a night of only U+0000 is still saved).
18. **The founder's export** does not carry readings (the founder's app never reads a night). Lean: yes, unchanged.
19. **The storage change ships alone**: Task 2's build changes nothing else, and is the one rehearsed (Task 3). The
    merged branch reaches the founder's app with Dev-only code besides, which his build does not reach. Lean: yes,
    with the safety export before (Task 10's note).
20. **A reading's label inside its bubble**, above the words, with `StandIns.gap` between, is a stand-in: main-path.md
    says "each with its tradition's label" without placing it. Lean: as built, for the founder's by-eye check.
21. **Where a night's counts live**: inside the night's file, `usage` beside `readings`, in the same version-3
    storage change (one rehearsal, deleted with the night, never exported), rather than a second file beside it.
    Lean: in the file.
22. **Which builds keep the counts**: SoulDreams Dev now (`keepUsage: true`); the founder's build when it reads (its
    entry point sets the same flag); the testers' app never (the answer's counts dropped on the phone; the server's log
    still has them). Lean: yes.
23. **The cost's unit**: whole millionths of a US dollar per call, from a price per token per model in `PRICES`
    (`models.ts`), each model's prices [READ] from its own pricing page when its caller is built; the stand-in's are
    zero. Lean: yes.
24. **What the server keeps**: its log line per call (`modelUsage`: step, model, four token counts, cost; CloudWatch,
    7 days) and nothing else; the spending counter (D69) comes with Bedrock and may read the same numbers. Lean: yes.
25. **Prompt caching**: AWS's pages (Part 2) do not say whether a cache entry fits retention mode `none`. Lean: off,
    and the question goes to AWS in writing (a support case from the workload account, by the owner) or to the head;
    switching it on is one line (`PROMPT_CACHING`) with a test changed and the answer recorded.
26. **The steps named now**: opening, readings, checks, scenery, recurrence, each the stand-in; only the readings step
    has code. The opening's own steps (the framing lines, the questions) may each want their own model later; they
    then become steps of their own. Lean: one `opening` step until the opening's instructions say otherwise.
27. **A step's reasoning cap** lives in its setting (`reasoningCap`, tokens), unused until Claude's callers, there for
    setup B (Part 7). Lean: yes.
28. **No screen for the counts or the cost** in this branch; the founder's comparison export (Part 7) is the first
    place they leave the phone. Lean: yes.

## Part 5 · How this plan was proven

The plan was proven twice: first as written (part one, head's message 33), then again whole after the amendment
(D157 and the head's message 34). The blocks in Part 3 are the second proof's.

1. **Built task by task in a copy of the tracked tree**, `.scratch/rp/build`, from `git archive` of `de0a315`, with
   the pinned Flutter (`app/.fvm`) and the server's installed packages. The amendment was built on the first
   proof's final tree; then each task's snapshot was made again (`.scratch/rp/snaps2/t1` to `t6`, by
   `mksnaps2.py`): each task's files at their final content, and `tool/app_mutations.py` cut to the rows each task
   has, with the rows a later task makes follow kept at their earlier text. The last snapshot is identical to the
   build. Each block is `git diff --no-index` between two snapshots. Blocks 1 to 6 are Tasks 1, 2, 4, 5, 6 and 7.
2. **Test first.** Each task's tests were written before its code and failed: Task 1's new test asserted wrong;
   Task 2's did not load (`Reading`, `withReadings`, then `ModelUsage`); Task 4's did not type-check (`reading.ts`,
   `instructions.ts`, then `models.ts`, missing); Task 5's did not load (`readings.dart`; then the answer's shape);
   Task 6's did not load (the page's new keys, `ReadingBubble`, `isRead`, `lensLabel`, `readNight`).
3. **Replayed on a clean copy** (`.scratch/rp/replay2`, from `git archive` of `de0a315`; `GIT_CEILING_DIRECTORIES`
   set, so `git apply` applies in a folder inside the repository): for each task, its test files applied alone
   first (`--include='*/test/*'`), then the rest. Measured:
   - Task 1, tests alone: `No issues found!`, `+790 -1`; whole: `No issues found!`, `+791`.
   - Task 2, tests alone: the two changed test files fail to load, `+736 -2`; whole: `No issues found!`, `+802`.
   - Task 4, tests alone: `npm run check` fails, `ℹ tests 144`, `ℹ fail 9`; whole: clean, `ℹ tests 183`,
     `ℹ fail 0`; the empty `server/instructions/AWAITING-INSTRUCTIONS.md` is made by `git apply` (0 bytes).
   - Task 5, tests alone: the new test file does not load, `+802 -1`; whole: `No issues found!`, `+820`.
   - Task 6, tests alone: `+702 -4`; whole: `No issues found!`, `+832`.
   - Task 7 applied. The replay's final tree is identical, file for file, to the build's, and `guards.py --walk` on
     it, and on every task's snapshot, prints `guards (walk): all passed`.
4. **Mutations.**
   - First proof (part one): every task's rows caught once rewritten where needed: A880 survived (a redundant second
     jump after a failure, removed from the code; the row repointed); six server rows were "missed" because the break
     left something unused, which the type check refuses before any test runs, or because `readdir` already returns
     names in order on the Mac's disk; each was rewritten to break behaviour and caught. Six existing app rows whose
     text this branch moved (A391, A656, A752, A815, A816, A835) follow it (D67).
   - The amendment: server rows S146, S147, S153, S157, S159, S160 followed the code that moved into `models.ts` and
     the door's reply, and S162 to S178 are new; two "missed" at first for the same type-check reason (S159 was
     repointed at the reply's readings, S168 became `!PROMPT_CACHING`). App rows A849, A850, A851, A861, A873 to A875
     and A898 (first numbering) followed the moved code; ten new rows for the counts in the night's file and five for
     the answer, Dev's keeping and the journal; then every app row of this branch was renumbered in task order
     (A838 to A913).
   - G4 refused, twice, test names and row fragments of twelve words or more; each was shortened, test and row
     together, in every snapshot.
   - **On the replay of the amended plan**: the app's `--files` of the eleven changed files: `app mutations: 291 run, 291 caught`; the server's rows
     of the seven changed files: `55 run, 55 caught`.
5. **Not proven here**: the C19-P import and what it changes (Tasks 0a, 0b); the deploy (Task 8; `cdk diff` against
   the account); the look on a phone, the dark theme and VoiceOver (Task 9); the storage rehearsal on a phone holding
   version 2 nights (Task 3). The full mutation runs are Task 10 (D126). `test_check_all.py` cannot run in a copy
   with no `.git` and was not run there; no guard or guard test changed. Nothing here reached our server, AWS,
   Soniox or BFL; AWS's two documentation pages were read on the web (Part 2).

## Part 6 · Part two, the painting: what its plan will ask

Not planned here (D155 item 1). Its plan comes after this part's merge, and will ask, with leans:

0. The scenery description is the `scenery` step of the one model interface (head's message 34): its model named in
   `SETUP`, its counts and cost kept like the readings'.
1. Where the painting is made: our server calls BFL's EU API (`api.eu.bfl.ai`, `flux-2-klein-4b`, D145) with the
   style constant (D146) and the neutral scenery description, never the night's words (D143). In this part the
   description is a placeholder: lean, one of the sixty invented scenes the owner read (`server/trial/scenes.ts`),
   chosen by the stand-in, never from the night.
2. The BFL key's permanent Parameter Store name (D155 item 3; owner task), read by the Lambda like the other two, its
   role gaining that one parameter; `BFL_API_URL` moving into `HOSTS` (R10).
3. The image's way to the phone (through our server only, R10), its size and its JPEG, and the invisible AI tag
   (D123) written by our own code, as the curated set's painter does.
4. The night's file holding its painting (another storage change under (c), D155 item 2), or a file beside it
   deleted with the night (docs/workflow.md (d)); what a failed painting shows (the curated painting, lean).
5. The Lambda's timeout for BFL's polling, and BFL's cost per painting against our spending stop.
6. Night images Off (D121 item 3): no painting is asked for.

## Part 7 · The founder's blind comparison: planned now, built later (head's message 34 item 4)

Not built in this branch; a later Part with its own plan and proof. What it is: in the founder's Cohort 0 app only, two
setups per night. **A**: every step on Claude Opus 5.5. **B**: Claude Sonnet 5.5 with its reasoning capped, and Claude
Haiku 5.5 for the simple steps. The opening is asked by one setup chosen at random; both setups then make the readings
from his answers, shown as "first" and "second" in random order. He scores the questions, each reading and each
close from 1 to 10, editable until he exports. The export holds no dream text: the date, which setup asked, which
made each reading and in what order, the first and final scores, and each reading's cost; by AirDrop, as his night
export goes (R8).

**The seams this branch leaves ready:**
- `SETUP` (`models.ts`) is a value of type `Setup`, a model choice per step with an optional reasoning cap; setups A
  and B are two such values, and a request may later name which to use, with nothing in the steps changing.
- Every call's counts and cost come back with the answer, step and model named, and SoulDreams Dev already keeps
  them beside the night: the comparison's cost per reading is a sum over them.
- The night's file has a version and a storage-change method: the comparison's second readings, their order, the
  setup that asked and the scores are one more storage change.

**Its tasks, outlined** (each test-first, under D91 and D126, after the instructions and Claude's callers exist):
1. Server: setups A and B as two `Setup` values; the request names `A` or `B` (nothing else of the phone); the
   reasoning cap passed to Claude's callers; the counts as now.
2. App: the night's file gains the comparison (setup that asked, the two readings sets with their setups and the
   order shown, the scores and their first values), a storage change under (c) with its rehearsal.
3. App: the random choices (which setup asks; the order "first"/"second"), from the system's secure source, kept with
   the night so the order never changes on reopening.
4. App: the scoring (1 to 10 per question, per reading, per close), editable until exported; words for its places
   asked of Product (R1).
5. App: the comparison's export, by AirDrop, in the founder's app only (R8; G8), with no dream text, tested to hold
   exactly the listed fields.
6. Owner: the founder's by-eye check on invented nights in SoulDreams Dev first, then his Cohort 0 app.

Questions it will ask: Product's words for "first", "second" and the scoring; which steps are "simple" for Haiku;
B's reasoning cap; whether the close is scored once or per invitation; whether a night's second readings are ever
shown again after scoring.

*No matter where you are on your journey, the steps you take are equally important.*
