# Development workflow — SoulDreams app

*No matter where you are on your journey, the steps you take are equally important.*

The founder's workflow from his last app, adopted for this build with the changes Head of Technology set (a to f, in
its brief to the Build worker of 2026-11-06), and three more for Flutter and the server (g to i). `CLAUDE.md` holds the
rules; this file holds the method. Neither restates the other.

## Roles

- **Owner (Ludvig):** decides, runs every manual test, and is the only one who pushes, merges, installs on a phone,
  deploys, or changes anything in AWS.
- **The Build chat** (Technology's Build worker): the link between the owner and Claude Code. Explains in plain
  language, gives a lean on every decision, and reviews every spec, plan, storage change and command before the owner
  runs it. It decides nothing about the practice, the design or the build's direction.
- **Claude Code:** writes the code. Opus for investigation, specs, plans and reviews; Sonnet for implementing plans.

**Leans are bundled and numbered, and a blank is not a yes (b).** Every lean comes as a numbered question stating what
the Build chat believes and what changes if the owner disagrees. "All fine" is an answer. A blank means ask again.

## Where things live

- **`CLAUDE.md`:** the standing rules. They rarely change, and only by the owner.
- **`docs/Status.md`:** the build's living state: current branch, the road ahead, banked items, the documents' hashes
  as last imported. Every branch's final docs task updates it. **Status is not the record (f):** rulings live in
  `technology/technology-change-record.md` in the documents repository. Status.md points to them by ordinal (e.g.
  "C4-T item 10") and never restates them. The owner attaches Status.md to his messages to the Build chat after each
  merge. It is never added to the Technology project's files, which mirror the documents repository.
- **`docs/specs/`, `docs/plans/`:** the repository copy is the source of truth.
- **`docs/source/`:** checked copies of the documents the build reads, imported by the owner (see "Imports").

## The task cycle

1. **Brainstorm** in the Build chat.
2. **New branch** from an up-to-date main. One branch per task; a big task is several branches under one spec.
3. **Read-only investigation** (Opus): maps the code with file:line references, marks what is verified and what is
   assumed, lists open questions with leans. No edits.
4. **Decisions** in the Build chat, **on how to build only (a).** Anything that would change a screen, a flow, a word
   or the disclosure goes to Product & Design as a numbered question, through the head, **before it is built**. Anything
   about the practice goes to Interpretation, the same way. The task waits; it does not guess.
5. **Spec** (Opus): plain-language summary, decisions, worked examples (from `fixtures/invented-nights.json` only),
   test plan. The Build chat reviews it. Small tasks fold a short spec into the plan.
6. **Plan** (Opus): small, ordered, test-first tasks with exact code. **Proven before committing:** every task built in
   a scratch worktree, the plan replayed on a clean worktree, and only then committed.
7. **Implement** (Sonnet, subagent-driven): code typed from the plan; each task's committed result confirmed identical to
   the plan; Opus reviewers on the riskiest tasks.
8. **`/simplify`:** a cleanup review; sound edits committed as one commit.
9. **Final whole-branch review** (Opus): fixes only real defects and lists the rest; the Build chat triages them (fix
   now or bank).
10. **The owner tests**, in SoulDreams Dev, on the simulator or his phone, with a plain checklist and expected results,
    and invented nights only.
11. **Merge** with the guarded command below, then attach the changed docs and delete scratch branches.

## Where tests run (g)

- **Logic first, on the Mac.** Everything that decides goes in plain Dart (app) or TypeScript (server) with no screen,
  and is tested there. `fvm flutter test` runs unit and widget tests on the Mac in Flutter's headless test mode, with no
  simulator. `npm test` runs the server's tests. These are Claude Code's tests, and every task ends green.
- **On a simulator or a phone, only the owner.** Integration checks and anything that needs a real screen are run by
  the owner, from a checklist, in SoulDreams Dev. Claude Code never starts a simulator or installs on a device.
- **The Dart and Flutter MCP server** (Flutter's official plugin) may look at the running SoulDreams Dev while the owner
  has it open: widget tree, runtime errors, hot reload, and screenshots after asking. Never on a real night (CLAUDE.md
  R12).

## Rules for Claude Code

`CLAUDE.md` holds them. Three from the original stay here because they are method:
- **Test-first.** Every task ends green with its own commit.
- **Mutation checks** on key guards: break the code on purpose, show the named test fails, restore. A test that
  tolerates a bug counts as weakened. Never weaken a test.
- **Analyzer gate:** `fvm flutter analyze` and the server's `npm run check` show no errors, no warnings and no new issues
  against a baseline saved at the start, proved by comparing content, not counts.

## How commands are given

- Every command is a labelled copy-paste block: "Paste 1 — Terminal", "Paste 2 — Claude Code", "Paste 3 — CloudShell".
  Terminal commands start with `cd ~/Developer/soul-dreams-app`.
- Anything longer than a few lines is a downloadable script, never pasted by hand.
- Reports for the Build chat (investigations, plan summaries, reviews, long outputs) are
  written by Claude Code to `.scratch/for-build-chat/`, which git ignores; the owner attaches
  the file to the Build chat. Plans and specs are still committed under `docs/`.
- Opening a Claude Code session:
  `cd ~/Developer/soul-dreams-app && git branch --show-current && git status --short && PATH="$PWD/app/.fvm/flutter_sdk/bin:$PATH" claude --model opus`
  (or `sonnet`). The `PATH` part makes the session, and the Dart and Flutter plugin, use the app's pinned Flutter rather
  than the Mac's other one. Never open Claude Code in `~/Developer` or any folder above the repository. End with `/exit`.
- Every command says what output to expect, and what to do if it differs. Verify, don't trust "done": ask for the real
  output.

## Merge (refuses to start on a dirty tree)

    cd ~/Developer/soul-dreams-app && test -z "$(git status --porcelain)" && git checkout main && git pull && git merge <branch> && tool/check_all.sh && git push origin main && git rev-parse main origin/main && git branch -d <branch>

Confirm: every check passes, the push shows `<old>..<new> main -> main`, both hashes match, the branch is deleted.
Nothing printed at all means uncommitted changes. `tool/check_all.sh` re-runs every guard, so a commit that slipped past
the hook is caught here.

## Imports: documents and words (h)

Claude Code never reads the documents repository. When Product or Interpretation files a document the build reads,
the owner runs the import script with the hash that filing recorded:

    cd ~/Developer/soul-dreams-app && tool/import.sh <file> <expected-sha256>

It refuses on a mismatch. On a match it copies the file into `docs/source/` (or `app/assets/words/` for the register and
the lists), records its hash and the filing's ordinal in `docs/source/SOURCES`, regenerates `lines.g.dart`, and stops
for the owner to commit. A copy is never edited; a difference found in it goes upward as a question.

## Installing on the owner's phone (i)

- **SoulDreams Dev** (`app.souldreams.dev`): every test. Invented nights only. Debug builds, so the Flutter tools can
  look at it.
- **SoulDreams** (`app.souldreams.founder`), the owner's Cohort 0 app: **release builds only**, built from
  `main_founder.dart`, installed from the Mac by the CLI command only (never Xcode's Run button, never TestFlight).
  Release mode has debugging and service extensions turned off, so no tool can attach to it.
- **Never delete the Cohort 0 app**, not even to fix a signing problem: the journal has no backup (C2-T). If an install
  fails, stop and bring the error to the Build chat.
- **Never install the TestFlight build on the owner's phone.** It is the testers' app (`app.souldreams`), built
  without the export; the owner's two apps stay the only SoulDreams apps on his phone.
- **Nothing from the Cohort 0 app is ever pasted into a Product or Technology chat or into Claude Code**: no screenshot,
  screen recording, console output or crash log (head's message 2, item 10).

## On-phone storage changes (c) — instead of database migrations

The journal lives only on the phone, with no backup (C2-T). Any change to how it is stored:
1. Claude Code writes the change with tests that load the old format from invented nights and prove the new one loses
   nothing: every night, dream, mark and field accounted for, counted before and after.
2. It is rehearsed in SoulDreams Dev, on the simulator and on the owner's phone, holding invented nights in the old
   format, then updated. The owner checks by eye against the checklist.
3. A storage change ships alone, in a build that changes nothing else.
4. Before it reaches the Cohort 0 app, the owner exports each night as C142-I item 3 rules the export (AirDrop to his
   Mac, into restricted/), as a safety copy, and deletes that copy once the updated app is checked.
5. Only then does it reach the Cohort 0 app, and only then any tester.

The server's small storage (feedback and combined totals) keeps the original method: written and rehearsed locally, read
together, a dry run, then applied by the owner, with checks before and after. An applied change is never edited; a fix
is a new change.

## Deletion is the feature (d)

The original's "Deleting live data" does not apply to a dreamer's data. When a dreamer deletes a night or the journal,
it is gone, with no copy kept anywhere. Tests prove it: after deletion, nothing of that night remains in storage, in any
cache or temporary file, or in anything the app can open. At a cohort's review, the server's feedback is deleted with
no backup or copy kept; only the combined totals are kept. The original's method (back up first, list exactly what
goes, delete by exact ID, check every count moved as expected) applies to the totals only.

## Invented dreams only (e)

Every example and test night is in `fixtures/invented-nights.json`, written to cover the cases (several dreams in one
night, a late telling, a split, a merge, both languages, an empty night) without being anyone's. The standing guards in
`CLAUDE.md` run on every commit: file kinds (G0), words (G1), copies (G2), no literal words (G3), invented only (G4),
logging (G5), no identifier (G6), no secrets (G7), the export (G8), hosts (G9).

*No matter where you are on your journey, the steps you take are equally important.*
