# SoulDreams app — standing rules for Claude Code

Read this first, every session. Then read `docs/Status.md` and `docs/workflow.md`. If Status.md's "Last updated" line
does not match what the owner describes, ask before doing anything.

**What this repository is.** The SoulDreams app (Flutter, `app/`) and its server (TypeScript on AWS Lambda in
eu-north-1, `server/`). iPhone only for Cohorts 0 and 1. The owner, Ludvig, decides, runs every manual test and is the
only one who pushes, merges, installs, deploys or touches AWS.

**Where the design lives.** Only in the checked copies under `docs/source/`, each listed with its sha256 in
`docs/source/SOURCES`. These copies are the only documents you read. Where they differ from each other,
`docs/source/technology-handover.md` §1 says which governs. **Any difference, gap or doubt goes to the owner as a
numbered question. Never settle it in code.** Never edit a copy: copies change only by the owner's import.

## The rules. Each one is checked; breaking one stops the task.

**R1 · Words.** You never write, translate, reword or invent a dreamer-facing line, nor a word on any check list. Every
dreamer-facing line comes from `app/lib/words/lines.g.dart`, generated from `app/assets/words/places-register.csv`.
Lines given and approved but not yet filed are pending lines: the owner writes them in
`app/assets/words/pending-lines.csv`, fingerprinted, the generator makes `app/lib/words/pending.g.dart`, and their words
show in SoulDreams Dev only (D57 Q11). Every
list word comes from `app/assets/words/founder-lists-for-technology.md`. Both are copied by the owner's import after a
hash check. A place whose status is not "written", "written, in its parts" or "composed (stand-in written)" has no line;
an unknown status stops the generator. Where a line is missing, use the place's handle as a visible placeholder (e.g.
`[MP·10]`) and list it in the plan. The readings, the mirror and every composed line are written at run time by the
model, under the checks. That is not you writing words.

**R2 · Dreams.** Every dream, night, transcript, reading or account in code, tests, examples, comments, commit messages
and plans is **invented**, and lives in one file: `fixtures/invented-nights.json`. Never use, ask for, accept or
reproduce a real dream, the owner's included. If anything that looks like a real night reaches you (a pasted log, a
screenshot, a crash report), stop and say so; do not quote it. Test audio is made by macOS speech from that file, never
recorded.

**R3 · Nothing a dreamer said in any log, error or report.** Production code logs only through `SafeLog` (app) and
`safeLog` (server). They take an event code and numbers, never a string from a night. No `print`, `debugPrint`,
`console.*` or exception message carries a night's text. Errors carry codes. Server logs hold no network address.

**R4 · No identifier on any request.** No device ID, install ID, vendor or advertising identifier, cookie or account.
**Never set Soniox's `client_reference_id`**: Soniox records it in its usage logs. A request carries only the shared beta
key.

**R5 · Secrets.** No key, token, password or certificate in code, tests, comments or commits. Build-time keys come from
`~/.soul-dreams/` through `--dart-define-from-file`, outside the repository. Server secrets live in AWS. You cannot read
either, by design.

**R6 · Places you never go.** Never read, open, list or reference `~/Developer/soul-dreams` (the old build) or
`~/Developer/soul-dreams-docs` (the documents repository, which holds `restricted/`). Your settings refuse them. If a
task seems to need them, it doesn't: ask.

**R7 · The model's instructions are not written yet.** They wait for Interpretation's four redrafts. Build the plumbing
with an empty, clearly named placeholder. Draft no prompt text, no example readings and no check rules beyond the
list words in R1.

**R8 · The founder's export.** Its code lives only in `app/lib/founder/`. Only `app/lib/main_founder.dart` (his Cohort 0
build) and `app/lib/main_dev.dart` (SoulDreams Dev, invented nights) may import it. `app/lib/main.dart` (testers) never
does: in a tester build it is not hidden, it is not built in. It shares one night by AirDrop and goes through no server
or service.

**R9 · No crisis material, crisis check or Help.** All three are scrapped indefinitely (owner, 2026-11-07). There is no
screen, placeholder, stub, flag, setting or name for any of them anywhere in `app/` or `server/`.

**R10 · What the app talks to.** Our server and Soniox's EU domain (`stt-rt.eu.soniox.com`), and nothing else. All hosts
live in one file, `app/lib/core/hosts.dart`; the server's live in `server/src/hosts.ts`. No package that sends data
anywhere: no analytics, crash reporting,
advertising or Firebase. Every new dependency, app or server, is listed in the plan as a question for the owner.

**R11 · The journal.** On the phone only, excluded from the phone's backups, and deleted completely when the dreamer
deletes it. Any change to how it is stored follows `docs/workflow.md`, "On-phone storage changes".

**R12 · Running apps and the Flutter tools.** You never run the app on a simulator or a device. The Dart and Flutter MCP
server's tools that look at a running app (screenshot, widget tree, runtime errors, hot reload) are used only on
**SoulDreams Dev**, and **never while a real night is on screen**. Ask the owner before every screenshot. His Cohort 0
app is a release build, which debugging tools cannot attach to.

**R13 · What is the owner's.** Never `git push`, `merge`, `rebase`, `reset --hard`, `branch -D` or `config`; never
`--no-verify`. Never deploy, never run `aws`, never touch the live server or its data. Your settings refuse these.

**R14 · Stop on any mismatch.** A plan block that won't apply, an off count, a test failing for an unexpected reason, a
check refusing: stop and report. Never improvise around it, never weaken a test or a check.

**R15 · No connectors.** Never sign in to, connect or use any claude.ai connector (email,
drive, calendar or any other) in a session in this repository.

## The checks

`tool/check_all.sh` runs every guard, the analyzers and the tests. The pre-commit hook runs the guards; the owner's
merge command runs all of it. The guards (built in the first task, each with a mutation check):

- **G0 file kinds** — every tracked file is a kind the guards know: code, config, or an unscanned type, name or path
  listed in `tool/checks/g0_kinds.py`. Anything else, an unknown `#!` interpreter included, is refused. A branch that
  brings a new kind of file extends the list, and the owner approves it; and `.txt` in `app/assets/fonts/` only; and the
  pending lines' and the screenshots' fingerprints by exact path.
- **G1 words** — the generated words (`lines.g.dart`, `lists.g.dart`, `words.g.xcconfig` and the two
  `InfoPlist.strings`) are exactly what the generator makes from the CSV and the lists, nothing else sits in
  `app/lib/words/` or `app/assets/words/`, and the CSV's and lists' hashes match `docs/source/SOURCES`; and
  `app/lib/design/tokens.g.dart` is exactly what `designgen.py` makes from `design-system.md`; and the pending lines
  match `pending-fingerprint.txt`, and `pending.g.dart` is what the generator makes from them.
- **G2 copies** — every file in `docs/source/` matches its listed hash; no tracked `privacy-ethics-safety.md`, and
  nothing in a folder named `restricted`; and every file in `app/assets/fonts/` matches `fingerprints.txt`; and every
  file in `docs/reference/screens/` matches its `fingerprints.txt`.
- **G3 no literal words** — no string literal shown to a dreamer outside `app/lib/words/`; any other literal of more
  than two words needs `// not-dreamer-facing: <reason>` on its line.
- **G4 invented only** — no string literal of twelve words or more outside `fixtures/invented-nights.json`,
  `app/lib/words/` and the generated iOS words.
- **G5 logging** — no `print(`, `debugPrint(`, `log(` (`Math.log(` allowed), `console.`, `stdout.write`, `stderr.write`
  or `FlutterError.dumpErrorToConsole` outside the two safe loggers (`app/lib/core/safe_log.dart`,
  `server/src/safe-log.ts`) and the checks' own writer (`tool/checks/guardlib.py`); in Swift and headers also `NSLog(`, `os_log(` and `Logger(`.
- **G6 identifiers** — none of `client_reference_id`, `identifierForVendor`, `advertisingIdentifier`, `device_info`.
- **G7 secrets** — no key-shaped string, no `.env`, `.p8`, `.pem`, `.p12` or `.mobileprovision` file. Under
  `docs/source/` only the high-entropy rule is off (the copies are proven byte-identical by G2); every key-shape rule
  still applies there.
- **G8 export** — nothing but `main_founder.dart` and `main_dev.dart` imports `lib/founder/`, besides files inside it
  and tests in `app/test/founder/`.
- **G9 hosts** — no `http://`, `https://`, `ws://` or `wss://` literal outside `app/lib/core/hosts.dart`,
  `server/src/hosts.ts` and tests.

A check is a floor, not the rule. What it cannot see, the rule still forbids.

## Commands

- App: `cd app && fvm flutter analyze && fvm flutter test` (runs on the Mac, no simulator). The app's Flutter version is
  pinned in `app/.fvmrc` through FVM; never use the Mac's other Flutter, and never change the pin without a question.
- Server: `cd server && npm run check && npm test`
- Everything: `tool/check_all.sh`

*No matter where you are on your journey, the steps you take are equally important.*
