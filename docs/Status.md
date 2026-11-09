# Status — SoulDreams app

Last updated: 2026-11-09, at the end of branch `scaffold-1-guards`, by Claude Code.

*No matter where you are on your journey, the steps you take are equally important.*

Status is not the record. Rulings live in `technology/technology-change-record.md` in the documents repository; this
file points to them and never restates them. The rulings for branch 1 (D1 to D14, D16 and D17) were given in the Build
chat and are listed in `docs/plans/scaffold-1-guards.md`, Part 1, and the answers to its questions in Part 4. The
owner's rulings of 2026-11-07 on the third amendment's questions are listed in its Part 5, fourth amendment, the
ruling on the review of Task 2b in its sixth, and the ruling on the review of Task 2c in its seventh.

## Current branch

`scaffold-1-guards`: Scaffolding, branch 1 of 4. Plan: `docs/plans/scaffold-1-guards.md`.

## Road ahead

- Branch 2, `scaffold-2-app`: the empty Flutter app in three flavours, each with its entry point: the testers'
  SoulDreams (`app.souldreams`, `main.dart`), the owner's Cohort 0 SoulDreams (`app.souldreams.founder`,
  `main_founder.dart`, release builds only, installed from Xcode), and SoulDreams Dev (`app.souldreams.dev`,
  `main_dev.dart`); Flutter pinned through FVM. Confirm that an Xcode-installed release build needs no App Store
  Connect record.
- Branch 3, `scaffold-3-import`: the import script, the words generator (`lines.g.dart` and the iOS permission-text
  files from EM·3), the docs copies, and arming G1 and G2 by deleting `tool/checks/awaiting-import`. The docs copies
  are the handover, main path, how the AI appears, design system, experience map, product principles, requirements
  list and tester disclosure specification, plus read-only copies of `interpretation/change-record.md`,
  `product/product-change-record.md`, `technology/technology-change-record.md` and
  `technology/technical-answers.md` once filed. Claude Code reads only the entries a spec cites, by ordinal.
  `privacy-ethics-safety.md` stays out.
- Branch 4, `scaffold-4-server`: the empty TypeScript server for Lambda, with its tests; nothing deployed.

## The guards

- G1 words and G2 copies: **NOT ARMED** until the first import (`tool/checks/awaiting-import`).
- G0 and G3 to G9: armed, on every commit (`.githooks/pre-commit`) and in `tool/check_all.sh`.
- The hook runs once `core.hooksPath` is `.githooks`, which the owner sets on each clone. `check_all.sh` fails loudly
  if it is not.
- Totals: 112 guard tests and 25 mutation checks.

## Banked

1. The microphone permission text is place EM·3 in the register (status "written", English and Swedish). Branch 3's
   generator writes the iOS permission-text files from EM·3 (`InfoPlist.strings`, en and sv, and the base value),
   and G1 then checks them as it checks `lines.g.dart`. Branch 2 adds no microphone setting (plan Part 4, Q3).
2. The safe loggers named in G5 (`app/lib/core/safe_log.dart`, `server/src/safe-log.ts`) and the hosts files named
   in G9 (`app/lib/core/hosts.dart`, `server/src/hosts.ts`) do not exist yet; they arrive with `app/` and `server/`.
3. The analyzer baseline the workflow asks for is saved by the branch that creates `app/` or `server/`.
4. In tracked mode (`check_all.sh`), a tracked symlink, or a tracked file deleted from the working tree, is refused
   by G0 as `unknown-kind` whatever its kind (fails closed; the reason code is misleading for a missing file), and no
   other guard reads it. The hook reads the index, but skips staged symlinks and gitlinks with no finding; tracked
   mode refuses them before a merge (D16).
5. Replace the hand-written lexers in `tool/checks/lex.py` with the official Dart analyzer and TypeScript scanner,
   once branches 2 and 4 bring them (D16).
6. YAML: G4 reads multi-line plain and quoted scalars line by line, so a long one can pass (D17; `scaffold-1-review-2a.md`, finding 5, B4).
7. Python: the code in an f-string's `{}` is blanked as string, so G5 can miss a writer there (D17; `scaffold-1-review-2a.md`, finding 7, B6).
8. Shell: backticks inside double quotes are blanked as string, so the guards can miss code there (D17; `scaffold-1-review-2a.md`, finding 7, B6).
9. Shell: substitutions in an unquoted heredoc's body are blanked as string, so the guards can miss them (D17; `scaffold-1-review-2a.md`, finding 7, B6).
10. The reviewer's seven minor notes on Task 2a, C1 to C7 in `scaffold-1-review-2a.md` (D17).
11. Shell: inside double quotes, `$(( ))` is blanked as string, so a command substitution in it, as in `"$(( $(cmd) + 1 ))"`, is hidden from the guards (D17; `scaffold-1-review-2a.md`, A/B-1).
12. The model's instructions need their own home, exempt from G4; defined when they arrive.
13. Plan Part 2 S1/S2 expectations amended by D15 during implementation (S1 proved by the sandbox on a real canary; S2's shell results on missing files are not evidence).
14. Banked by D17 at Task 2b's review: K1 (two Swift regexes after try with quotes on one line; closed by Task 2c's C2), K2 (shell <<< read as a heredoc), K3 (shift by a variable name in (( )) read as a heredoc), K4 (a NUL-byte file with an unlisted extension counts as binary). See scaffold-1-review-2b.md.
15. G0 refuses .gitkeep and .fvmrc: branch 2 extends g0_kinds.py when it adds app/. These fail closed as unlexable (false findings, safe): Swift 'x! / y' and '} / n'; shell '<<=' and '<<\EOF'.
16. G1/G2 stop with an internal error (exit 2, no file named) when a file they hash cannot be read: fails closed, banked.
17. D18: G7's assigned-secret rule knows only the names in g7_secrets.py; the beta key will be 48 characters of A-Z, a-z and 0-9 so the high-entropy rule catches it.
18. D19: /simplify skipped for branch 1.

## Documents as last imported

None yet. `docs/source/SOURCES` does not exist.
