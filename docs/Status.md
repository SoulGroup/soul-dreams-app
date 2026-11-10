# Status — SoulDreams app

Last updated: 2026-11-10, at the end of branch `scaffold-2-app`, by Claude Code.

*No matter where you are on your journey, the steps you take are equally important.*

Status is not the record. Rulings live in `technology/technology-change-record.md` in the documents repository; this
file points to them and never restates them. The rulings for branch 1 (D1 to D14, D16 and D17) were given in the Build
chat and are listed in `docs/plans/scaffold-1-guards.md`, Part 1, and the answers to its questions in Part 4. The
owner's rulings of 2026-11-07 on the third amendment's questions are listed in its Part 5, fourth amendment, the
ruling on the review of Task 2b in its sixth, and the ruling on the review of Task 2c in its seventh. The owner's
ruling D20 of 2026-11-09 for branch 2 is listed in `docs/plans/scaffold-2-app.md`, Part 1. From branch 2 on, the
rulings given during each branch are listed in this file, one line each, under "Rulings during branch N".

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
21. B1 (D17, D26): no test checks the debug banner is off; fix if wanted: `expect(find.byType(CheckedModeBanner), findsNothing);` in `app/test/app_test.dart`.
22. B2 (D17): `app/test/app_test.dart`'s `find.byType(RichText)` cannot see text drawn by `EditableText` or `CustomPaint`; add a check if such a widget arrives.
23. B3 (D17): `if (kReleaseMode) return;` in `app/lib/core/safe_log.dart` cannot be tested under `flutter test`; release `developer.log` is a no-op anyway.
24. B4 (D17): profile builds log, to the VM service only; the founder app is installed as release, never profile.
25. B5 (D17): G8 checks direct imports only; a shared file importing `main_dev.dart` or `main_founder.dart` could reach `lib/founder/` transitively (with banked item 5).
26. B6 (D17): `app/test/entry_points_test.dart` reads text by regex: a `*main` function holding the check, or a string or block comment, can fake "first statement"; parse with the Dart analyzer.
27. B7 (D17): the same test: a `//` inside a string hides the rest of its line, a check in a never-called function passes, and `requireFlavour (` with a space is missed.
28. B8 (D17): the same test's line 30 is 86 columns, so `dart format` would rewrap it; nothing checks formatting.
29. B9 (D17, D28): `CFBundleName` in `app/ios/Runner/Info.plist` is still the template's `souldreams`; branch 3 sets it to `$(APP_DISPLAY_NAME)` when the generator writes MP·55.
30. B10 (D17): `Runner`'s plain `Debug`, `Release` and `Profile` configurations have no bundle identifier or display name; no scheme uses them.
31. B11 (D17): no test runs `check_all.sh`'s Flutter version and offline `pub get` step; only the owner's run (Task 11) proved it.
32. D30: /simplify skipped for the scaffolding branches.
33. `requireFlavour`'s `flavor:` parameter (for tests) is public, so app code could pass any name; only `app/test/entry_points_test.dart` pins the three calls; mark it `@visibleForTesting` if wanted.

## Rulings during branch 2

- D21: answers Q1 to Q7 before Task 0: Flutter may write `~/.config/flutter` (`flutter config` and analytics denied); only the owner runs `check_all.sh` in this branch; CLAUDE.md's G5 line names Apple's loggers; a debug `--no-codesign` build per flavour; RunnerTests kept; founder scheme Run is `Release-founder`; the template's orientations kept.
- D22: Task 0's P5 skipped on the unpinned `stable` SDK; run on the pinned 3.47.9 in Task 2 instead.
- D23: the sandbox allows local port binding, so `flutter test` runs; the outbound allowlist is unchanged.
- D24: Task 2 step 5 runs without the `':!app/.fvm'` exclusion; the duplicate `.fvm/` and missing final newline in `app/.gitignore` come from `fvm use`, not the plan.
- D25: Task 5's ignore check runs without `-q`; a plan command that fails only on a tool's syntax may be replaced by the smallest equivalent command, recorded, and the build stops if any file's text or expected result would change.
- D26: Task 5 reviewer's finding 1 (the debug banner is untested) is banked (item 21).
- D27: the founder app is built and installed only by the CLI command (`docs/workflow.md` §i); Task 7a adds the entry-point test.
- D27a: the entry-point test also requires the check to be the first statement of `main`.
- D28: Task 9's `xcodebuild -list` runs on `-project Runner.xcodeproj`, generated package schemes allowed; the compile checks use `-t` per flavour; `CFBundleName` banked for branch 3 (item 29).
- D29: banked item 20's sentence approved; the implementation report's D17 items reach Status.md as one-line banked items in the final review's docs pass.
- D30: /simplify skipped for the scaffolding branches; the CLAUDE.md Commands line stays as it is.

## Documents as last imported

None yet. `docs/source/SOURCES` does not exist.
