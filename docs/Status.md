# Status — SoulDreams app

Last updated: 2026-11-10, at the end of branch `scaffold-2-app`, by Claude Code.

*No matter where you are on your journey, the steps you take are equally important.*

Status is not the record. Rulings live in `technology/technology-change-record.md` in the documents repository; this
file points to them and never restates them. The rulings for branch 1 (D1 to D14, D16 and D17) were given in the Build
chat and are listed in `docs/plans/scaffold-1-guards.md`, Part 1, and the answers to its questions in Part 4. The
owner's rulings of 2026-11-07 on the third amendment's questions are listed in its Part 5, fourth amendment, the
ruling on the review of Task 2b in its sixth, and the ruling on the review of Task 2c in its seventh. The owner's
ruling D20 of 2026-11-09 for branch 2 is listed in `docs/plans/scaffold-2-app.md`, Part 1.

## Current branch

`scaffold-2-app`: Scaffolding, branch 2 of 4. Plan: `docs/plans/scaffold-2-app.md`.

## Road ahead

- Branch 3, `scaffold-3-import`: the import script, the words generator (`lines.g.dart`, the iOS permission-text
  files from EM·3, and the founder and tester home-screen name from MP·55 into `app/ios/Flutter/founder.xcconfig` and
  `tester.xcconfig`, where `[MP·55]` stands until then), the docs copies, and arming G1 and G2 by deleting
  `tool/checks/awaiting-import`. The docs copies are the handover, main path, how the AI appears, design system,
  experience map, product principles, requirements list and tester disclosure specification, plus read-only copies of
  `interpretation/change-record.md`, `product/product-change-record.md`, `technology/technology-change-record.md` and
  `technology/technical-answers.md` once filed. Claude Code reads only the entries a spec cites, by ordinal.
  `privacy-ethics-safety.md` stays out.
- Branch 4, `scaffold-4-server`: the empty TypeScript server for Lambda, with its tests; nothing deployed.

## The app

- Flutter 3.47.9, pinned in `app/.fvmrc` through FVM. iPhone only, iOS 15.0 and later. A blank screen, no text.
- Three flavours, each with its Xcode scheme, entry point and settings file in `app/ios/Flutter/`: `dev` (SoulDreams
  Dev, `app.souldreams.dev`, `main_dev.dart`), `founder` (`app.souldreams.founder`, `main_founder.dart`, release
  builds only) and `tester` (`app.souldreams`, `main.dart`). Each entry point refuses to start under another flavour.
- Only `dev` can be signed: it includes the owner's untracked `app/ios/Flutter/Signing.xcconfig`. `founder` and
  `tester` include no signing until the paid membership (D20 Q9b, Q10).
- The app's analyzer baseline: `No issues found!`.

## The guards

- G1 words and G2 copies: **NOT ARMED** until the first import (`tool/checks/awaiting-import`).
- G0 and G3 to G9: armed, on every commit (`.githooks/pre-commit`) and in `tool/check_all.sh`.
- The hook runs once `core.hooksPath` is `.githooks`, which the owner sets on each clone. `check_all.sh` fails loudly
  if it is not.
- `check_all.sh` also checks that the Flutter running is the one pinned, then runs `pub get` offline against the
  lockfile, the analyzer and the app's tests.
- Totals: 117 guard tests and 32 mutation checks.

## Banked

1. The microphone permission text is place EM·3 in the register (status "written", English and Swedish). Branch 3's
   generator writes the iOS permission-text files from EM·3 (`InfoPlist.strings`, en and sv, and the base value),
   and G1 then checks them as it checks `lines.g.dart`. Branch 2 adds no microphone setting (plan Part 4, Q3).
2. The server's safe logger (`server/src/safe-log.ts`) and hosts file (`server/src/hosts.ts`) arrive with branch 4.
   The app's exist since branch 2.
3. The server's analyzer baseline is saved by branch 4. The app's is above.
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
14. Banked by D17 at Task 2b's review: K2 (shell <<< read as a heredoc), K3 (shift by a variable name in (( )) read as a heredoc), K4 (a NUL-byte file with an unlisted extension counts as binary). See scaffold-1-review-2b.md.
15. G0 refuses .gitkeep. These fail closed as unlexable (false findings, safe): Swift 'x! / y' and '} / n'; shell '<<=' and '<<\EOF'.
16. G1/G2 stop with an internal error (exit 2, no file named) when a file they hash cannot be read: fails closed, banked.
17. D18: G7's assigned-secret rule knows only the names in g7_secrets.py; the beta key will be 48 characters of A-Z, a-z and 0-9 so the high-entropy rule catches it.
18. D19: /simplify skipped for branch 1.
19. G3 cannot see a dreamer-facing `text=` or `title=` attribute in a storyboard; the two template storyboards have
    none (D20 Q13).
20. Flutter in Claude Code's sandbox: `~/.config/flutter` is writable and local-port binding is allowed (D21 Q1, D23), so `fvm flutter analyze --no-pub` and `fvm flutter test --no-pub` run through the pinned 3.47.9; the unpinned `stable` SDK still tries a download there, so it is not used (D22), and `pub get` stays the owner's.

## Documents as last imported

None yet. `docs/source/SOURCES` does not exist.
