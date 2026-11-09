# Plan: scaffold-2-app (Scaffolding, branch 2 of 4)

*No matter where you are on your journey, the steps you take are equally important.*

Spec and plan in one file, as `docs/workflow.md` step 5 allows. Written by Claude Code (Opus) on 2026-11-09, from the
investigation `.scratch/for-build-chat/scaffold-2-investigation.md` and the owner's ruling D20 on its 18 questions.
**Nothing here is implemented yet.** Part 4 says how it was proven, and which tasks only the owner can run.

---

## Part 1 · Spec

### What branch 2 builds

The empty Flutter app in `app/`, iOS only, iPhone only, in three flavours, each with its own entry point:

| Flavour | Xcode scheme | Bundle identifier | Home-screen name | Entry point | Signed now |
|---|---|---|---|---|---|
| dev | `dev` | `app.souldreams.dev` | SoulDreams Dev | `lib/main_dev.dart` | yes, Personal Team |
| founder | `founder` | `app.souldreams.founder` | `[MP·55]` | `lib/main_founder.dart` | no (D20 Q9b) |
| tester | `tester` | `app.souldreams` | `[MP·55]` | `lib/main.dart` | no (D20 Q10) |

- **A blank screen with no text** (`MaterialApp`, an empty `Scaffold`, no debug banner).
- **Flutter 3.47.9, pinned** in `app/.fvmrc` by the owner (D14). Swift Package Manager, as Flutter 3.47.9 defaults
  to. Dart package `souldreams`.
- **The two files the guards name:**
  - `app/lib/core/safe_log.dart`: an event code from an enum and numbers, never a String. Release builds log
    nothing (D20 Q17).
  - `app/lib/core/hosts.dart`: empty, as no host is used yet.
- **Each entry point refuses another flavour.** `requireFlavour` stops the app unless `appFlavor` is its own flavour
  (D20 Q8).
- **iOS:**
  - one settings file per flavour (`app/ios/Flutter/<flavour>.xcconfig`) sets the bundle identifier, the
    home-screen name, `FLUTTER_TARGET` and `FLAVOR`;
  - nine configurations (`Debug-dev` … `Release-tester`) are based on those files;
  - the `Runner` scheme is removed;
  - iPhone only (`TARGETED_DEVICE_FAMILY = 1`; no iPad orientations), iOS 15.0.
- **Guards:**
  - G0 knows `.xcworkspacedata`, `.xcsettings`, `.storyboard`, `.h` (config by extension) and `.fvmrc`, `.metadata`
    (config by name).
  - G5 refuses `NSLog(`, `os_log(` and `Logger(` in Swift and in headers.
  - A test and a mutation for each (D20 Q13).
- **`check_all.sh`:** its app step checks the pinned Flutter, then runs `fvm flutter pub get --offline
  --enforce-lockfile`, the analyzer and the tests (D20 Q15).
- **`docs/Status.md`** is brought up to date.

### What branch 2 does not build

- **Nothing dreamer-facing.** No word, line or screen beyond the blank one.
  - The founder and tester home-screen name is register place MP·55, which branch 3's generator writes. Until then
    the visible placeholder `[MP·55]` stands (R1; D20 Q2).
  - "SoulDreams Dev" is the owner's own label (D20 Q2).
- **No microphone setting or permission text** (banked item 1), and **no privacy manifest** (D20 Q11).
- **No signing for founder or tester:** they wait for the paid membership (D20 Q9b, Q10).
- **No Android, no server, no `lib/founder/`,** and no package besides the template's dev-only `flutter_lints`
  (D20 Q14).
- **The storyboard gap:** G3 does not read storyboard `text=` or `title=`. It is banked (D20 Q13).

### Placeholders listed (R1)

| Place | Where | Placeholder |
|---|---|---|
| MP·55 | `app/ios/Flutter/founder.xcconfig`, `app/ios/Flutter/tester.xcconfig`, `APP_DISPLAY_NAME` | `[MP·55]` |

### The decisions, by number (D20, the owner, 2026-11-09)

| Q | Ruling | Where it lands |
|---|---|---|
| 1 | `flutter create --empty` | Task 1 |
| 2 | Founder and tester home-screen name: MP·55, placeholder `[MP·55]` until branch 3; "SoulDreams Dev" set directly | Task 8 |
| 3 | iPhone only | Task 8 (script) |
| 4 | iOS 15.0, Flutter's default | Task 1 (template; unchanged) |
| 5 | Lowercase scheme and configuration names; `Runner` scheme removed | Task 8 |
| 6 | Per-flavour settings in xcconfig files | Task 8 |
| 7 | Claude Code edits `project.pbxproj` as text; proven by the owner's `xcodebuild -list` and `-showBuildSettings` | Tasks 8, 9 |
| 8 | `FLUTTER_TARGET` and `FLAVOR` per flavour xcconfig; each `main_*.dart` refuses a wrong `appFlavor`; founder installs always by the CLI command | Tasks 7, 8 |
| 9a | Team ID in the untracked `ios/Flutter/Signing.xcconfig` | Tasks 5 (ignored), 8 (included by dev only), 9 |
| 9b | Founder never installed under the Personal Team; it waits for the paid membership | Task 8 (founder includes no signing) |
| 10 | Only dev is ever signed or installed under the Personal Team | Task 8 |
| 11 | No privacy manifest yet | — |
| 12 | Owner has run `flutter`/`dart --disable-analytics`. Task 0 proves `fvm flutter test --no-pub` and `analyze` in the sandbox; on failure, stop and report the exact error; Claude Code never runs `pub get` | Tasks 0, 2 |
| 13 | G0 additions with a test and a mutation each; `.vscode/` ignored; G5 adds `NSLog(`, `os_log(`, `Logger(` for Swift and `.h`, with tests and a mutation; bank only the storyboard gap | Tasks 3, 4, 5, 12 |
| 14 | `flutter_lints`, dev only; nothing else | Task 1 (template) |
| 15 | `check_all.sh`: the Flutter version check and `fvm flutter pub get --offline --enforce-lockfile` | Task 10 |
| 16 | `--description "SoulDreams app."` | Task 1 |
| 17 | Release builds log nothing | Task 6 |
| 18 | `app/README.md` replaced by one line pointing to `CLAUDE.md` | Task 5 |

### Facts the plan rests on (verified 2026-11-09)

- **Flavour mapping.** `--flavor X` selects the scheme `X` (case-insensitively) and the configuration `<Mode>-X`.
  Once custom schemes exist and `Runner` is gone, a build without `--flavor` is refused (`flutter_tools`
  `ios/xcodeproj.dart:672-737`).
- **An Xcode-started build** reads `FLUTTER_TARGET` and the dart-defines from the build settings
  (`bin/xcode_backend.dart:580-583`). It sets `appFlavor` from the Xcode configuration
  (`build_system/targets/common.dart:335-355`). Its build mode comes from the configuration name, since nothing
  writes `FLUTTER_BUILD_MODE` (`xcode_backend.dart:224-245`).
  - So the flavour xcconfigs, which include `Generated.xcconfig` first and set `FLUTTER_TARGET` after it, decide the
    entry point.
  - The dart-defines (the build-time keys) still come from the last CLI command. That is why founder installs are
    always built by the CLI command (D20 Q8).
- **`Debug.xcconfig` and `Release.xcconfig` each hold only `#include "Generated.xcconfig"`** (template). So one
  xcconfig per flavour, including `Generated.xcconfig` itself, serves all three modes.
- **Flutter in the sandbox (Q12).** Analytics are now off, and `flutter --version` runs.
  - `flutter analyze` and `flutter create` still stop with exit 1: `Flutter failed to write to a file at
    "~/.config/flutter/tool_state"`.
  - The cause: the sandbox refuses `sysctl hw.optional.arm64`, so Flutter takes this Mac for an Intel one
    (`base/os.dart:385-392`). It then records that it showed the Intel warning (`runner/flutter_command.dart:1959-1966`;
    key `displayed-intel-warning-message`), and that write is refused.
  - Task 0 will meet this unless the owner changes something first (Part 3, Q1).
- **`xcodebuild` cannot run in the sandbox.** It is refused writes to DerivedData and to the package cache. Task 9
  is the owner's.
- **What the replay can't run.** `flutter create`'s template downloads and `pub get` cannot run in the sandbox
  (TLS through the proxy). So the replay stood in for the owner's skeleton with a rendering of the same template
  (Part 4).

### Test plan

| What | Refused (control) | Passed (clean case) | Mutation that must be caught |
|---|---|---|---|
| G0 (Task 3) | `a.c` takes `a.h`'s place among the unknown kinds | `.fvmrc`, `.metadata`, `.xcworkspacedata`, `.xcsettings`, `.storyboard`, `.h` | 26–31: drop each of the six from `guardlib.py` |
| Library (Task 3) | `x.fvmrc` and `metadata` stay unknown | the six read as config; `.xcsettings` strings read as a plist, `.metadata` as YAML | (as above) |
| G5 (Task 4) | `NSLog(`, `os_log(`, `Logger(` in Swift; `NSLog(` in a header | `Logger(` in Dart; the three in Swift comments and strings; `MyLogger(` | 32: drop `NSLog` |
| `SafeLog` (Task 6) | — | `appStarted 1 2.5`; `wrongFlavour` alone | M-b: join with `,` |
| `requireFlavour` (Task 7) | `founder` built as `dev`; `tester` with no flavour; each logs `wrongFlavour` | each flavour under its own name; names equal the schemes | M-c: never refuse |
| Blank screen (Task 5) | — | one `Scaffold`, no `RichText` | M-a: a `Text` on the screen |
| iOS project (Tasks 8, 9) | the script stops if any edit applies other than as counted, or on a second run | `plutil -lint`, `xmllint`; the owner's `xcodebuild -list` and `-showBuildSettings` | — |

Totals once built: **117 guard tests and 32 mutation checks** (5 tests and 7 mutations added), plus **6 app tests**
and 3 hand-run Dart mutations. Every control is invented: placeholder words and stand-in values only. No dream,
night or dreamer line appears anywhere (R1, R2).

---

## Part 2 · The tasks

**Who runs what.** Tasks marked **[OWNER]** are the owner's pastes. Claude Code stops before each, gives the paste,
and waits for the output. Everything else is Claude Code's.

**How files are written.**
- The sandbox refuses shell writes to `tool/checks/` and `tool/check_all.sh`. Files there go in through the
  Edit tool, and the owner approves each at the prompt.
- Files under `app/` use the Write and Edit tools too.
- A **File** block is written whole. An **Edit** block replaces its first fence with its second, and the first must
  occur exactly once.

**Commits.** Each task ends green with its own commit, through the hook (never `--no-verify`). Every commit message
ends with the line `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, shown below as `<trailer>`.

**Red, then green.** Each task first writes its test and runs it, and the run must fail as stated. Then it writes the
code and runs again, and the run must pass with the stated count. Any other result stops the task (R14).

**Flutter commands.** Claude Code runs them always from `app/`, always with `--no-pub`:
- `fvm flutter analyze --no-pub` must print `No issues found!`;
- `fvm flutter test --no-pub` must end `All tests passed!`.

Claude Code never runs `pub get` (D20 Q12), and never runs `tool/check_all.sh` in this branch (Part 3, Q2).

### Task 0 · Settings and sandbox proofs (before the skeleton)

Write nothing in the repository, commit nothing. Report each exact result. Any FAIL stops the task (R14).

| # | Proof | Probe | Expected |
|---|---|---|---|
| P1 | D14: FVM's pinning commands are the owner's | `fvm use --help`; `fvm install --help`; `fvm global --help`; `fvm flutter run --help`; `fvm flutter install --help` | Each refused by the permission system |
| P2 | The words folders refuse the Write tool | Write tool on `app/lib/words/__canary` and on `app/assets/words/__canary`, each holding `canary` | Both refused |
| P3 | `app/` is the owner's to create (branch 1, Task 13's note) | `p=app; mkdir "$p"` | `Operation not permitted`. If it is created instead: report it, run `rmdir app`, and go on (the owner's `flutter create` accepts an empty folder) |
| P4 | Flutter starts in the sandbox (analytics off) | `~/fvm/versions/stable/bin/flutter --version` (`stable` is 3.47.9, the same revision, `c197ca5199`; the pin is installed only in Task 1) | `Flutter 3.47.9 • channel stable`, no crash |
| P5 | `flutter analyze` runs in the sandbox (D20 Q12) | the commands below | `No issues found!`. **Anything else: stop and report the exact output** (D20 Q12). The owner decides the settings |

P5 analyzes a throwaway package in `$TMPDIR`. It has no dependencies and a hand-written package list, so no
`pub get` and no network:

    d="$TMPDIR/p5" && rm -rf "$d" && mkdir -p "$d/lib" "$d/.dart_tool" && cd "$d" \
      && printf 'name: p5\nenvironment:\n  sdk: ^3.13.0\n' > pubspec.yaml \
      && printf 'int f() => 1;\n' > lib/a.dart \
      && printf '{"configVersion":2,"packages":[{"name":"p5","rootUri":"../","packageUri":"lib/","languageVersion":"3.13"}]}' > .dart_tool/package_config.json \
      && ~/fvm/versions/stable/bin/flutter analyze --no-pub; echo "exit=$?"; cd /; rm -rf "$d"

`fvm flutter test --no-pub` needs the skeleton and the owner's `pub get`. It is proven in Task 2.

### Task 1 · [OWNER] The skeleton: Flutter 3.47.9, `flutter create`, `fvm use`

Claude Code stops and gives the owner three pastes, one at a time.

    Paste 1 — Terminal
    cd ~/Developer/soul-dreams-app && git status --short && test ! -e app && fvm install 3.47.9 && fvm spawn 3.47.9 create --empty --platforms=ios --org app.souldreams --project-name souldreams --description "SoulDreams app." --no-pub app; echo "exit=$?"

Expected, in order:
1. `git status --short` prints nothing.
2. `fvm install` clones 3.47.9 from its cache, then downloads the engine; it ends with Flutter SDK 3.47.9 being set
   up.
3. `flutter create` prints `Creating project app...`, possibly a line naming a signing identity, then `Wrote N
   files.`, `All done!` and `exit=0`.

If `fvm spawn` is refused as an unknown command, replace `fvm spawn 3.47.9` with `~/fvm/versions/3.47.9/bin/flutter`
and run the paste again from `fvm install`. Then say so.

    Paste 2 — Terminal
    cd ~/Developer/soul-dreams-app/app && fvm use 3.47.9; echo "exit=$?"; cat .fvmrc; echo; ls -a .fvm; test ! -e ../.fvmrc && echo "pin in app/ only"

Expected:
- FVM may ask whether to add `.fvm/` to `.gitignore`: answer **yes**. To any question about VS Code: answer **no**.
  It may also run `flutter pub get`.
- Then `exit=0`, then `.fvmrc` showing `"flutter": "3.47.9"`.
- Then `.fvm` listing `flutter_sdk`, and `pin in app/ only`.

    Paste 3 — Terminal (the owner's pub get)
    cd ~/Developer/soul-dreams-app/app && fvm flutter pub get && fvm flutter precache --ios && fvm flutter --version && grep -c DEVELOPMENT_TEAM ios/Runner.xcodeproj/project.pbxproj; cd .. && git status --short --untracked-files=all | grep -v '^?? app/'; git status --short

Expected:
- `Got dependencies!`;
- the precache finishing with no error (it downloads what `flutter test` needs);
- `Flutter 3.47.9 • channel stable` and `Dart 3.13.7`;
- a count of `0` or `3` (the Team ID lines `flutter create` may have written; the count only, never the ID);
- nothing from the filtered status;
- the last status shows only `?? app/`.

**Send back** all three outputs. If `flutter create` printed a line naming a signing identity, replace the name and
email in it with `[identity]` first. Anything not as expected: nothing goes further.

### Task 2 · Sandbox proofs on the skeleton, and the baselines

Write nothing tracked; commit nothing.

1. `git status --short` shows only `?? app/`.
2. In `app/`, `fvm flutter --version` prints `Flutter 3.47.9`.
3. In `app/`, `fvm flutter analyze --no-pub > ../.scratch/for-build-chat/scaffold-2-analyzer-baseline.txt 2>&1;
   echo "exit=$?"`. Expected: `exit=0`, and the file holds `Analyzing app...` and `No issues found! (ran in …)`.
   This is the analyzer baseline (workflow, "Analyzer gate").
4. The Write tool writes this file. It proves writing under `app/`, making a folder there, and `flutter test` in the
   sandbox:

   **File `app/test/sandbox_canary_test.dart`**

   ~~~~dart
   import 'package:flutter_test/flutter_test.dart';

   void main() {
     test('the sandbox runs flutter test', () => expect(1 + 1, 2));
   }
   ~~~~

   In `app/`, run `fvm flutter test --no-pub`. Expected: `All tests passed!`. Then `rm app/test/sandbox_canary_test.dart
   && rmdir app/test`, and `git status --short` shows only `?? app/` again.
5. The guards on the untouched skeleton:
   `git add app ':!app/.fvm' && python3 -I -B tool/checks/guards.py --staged; git rm -r -q --cached app`.
   Expected: exactly these findings, and no other:

       G0 app/.fvmrc:0 unknown-kind
       G0 app/.metadata:0 unknown-kind
       G0 app/ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata:0 unknown-kind
       G0 app/ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings:0 unknown-kind
       G0 app/ios/Runner.xcworkspace/contents.xcworkspacedata:0 unknown-kind
       G0 app/ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings:0 unknown-kind
       G0 app/ios/Runner/Base.lproj/LaunchScreen.storyboard:0 unknown-kind
       G0 app/ios/Runner/Base.lproj/Main.storyboard:0 unknown-kind
       G0 app/ios/Runner/Runner-Bridging-Header.h:0 unknown-kind
       G3 app/lib/main.dart:13 dreamer-literal

   Then `git status --short` shows only `?? app/`.

If step 2, 3 or 4 fails, stop and report the exact output (D20 Q12).

### Task 3 · G0: the kinds FVM and Flutter's iOS project bring (D20 Q13)

**Red.**

**Edit `tool/checks/tests/test_g0.py`.** Replace:

~~~~python
        for path in ('a.tsx', 'a.jsx', 'a.mts', 'a.m', 'a.h', 'a.kt', 'a.txt', 'Makefile',
~~~~

with:

~~~~python
        for path in ('a.tsx', 'a.jsx', 'a.mts', 'a.m', 'a.c', 'a.kt', 'a.txt', 'Makefile',
~~~~

(`.h` becomes known in this task; `a.c` keeps the control's count. The test is not weakened: `a.h` moves into the
next test, as a kind that must pass.)

**Edit `tool/checks/tests/test_g0.py`.** Replace:

~~~~python
    def test_unknown_shebang_refused(self):
~~~~

with:

~~~~python
    def test_flutter_kinds_pass(self):
        # scaffold-2-app (D20 Q13): the kinds FVM and Flutter's iOS
        # project bring are config.
        self.passed({'app/.fvmrc': '{\n  "flutter": "3.47.9"\n}',
                     'app/.metadata': 'version:\n  channel: "stable"\n',
                     'app/ios/Runner.xcworkspace/contents.xcworkspacedata':
                         '<?xml version="1.0" encoding="UTF-8"?>\n<Workspace>\n</Workspace>\n',
                     'app/ios/Runner.xcworkspace/WorkspaceSettings.xcsettings':
                         plistlib.dumps({'k': False}),
                     'app/ios/Runner/Base.lproj/Main.storyboard': '<?xml version="1.0"?>\n<document/>\n',
                     'app/ios/Runner/Runner-Bridging-Header.h': '#import "a.h"\n'})

    def test_unknown_shebang_refused(self):
~~~~

**Edit `tool/checks/tests/test_guardlib.py`.** Replace:

~~~~python
    def test_kind_by_shebang(self):
~~~~

with:

~~~~python
    def test_flutter_kinds_are_config(self):
        # scaffold-2-app (D20 Q13): by extension, and two by whole name.
        got = kinds({'a.xcworkspacedata': '', 'a.xcsettings': '', 'a.storyboard': '',
                     'a.h': '', 'app/.fvmrc': '', 'app/.metadata': '',
                     'app/x.fvmrc': '', 'app/metadata': ''})
        self.assertEqual(got, {'a.xcworkspacedata': 'config', 'a.xcsettings': 'config',
                               'a.storyboard': 'config', 'a.h': 'config',
                               'app/.fvmrc': 'config', 'app/.metadata': 'config',
                               'app/x.fvmrc': None, 'app/metadata': None})

    def test_flutter_config_strings(self):
        # .xcsettings reads as a plist, .metadata as YAML (D20 Q13).
        self.assertEqual(guardlib.config_strings(
            'a.xcsettings', '<dict>\n<key>k</key>\n<string>word word</string>\n</dict>\n'),
            [(3, 'word word')])
        self.assertEqual(guardlib.config_strings(
            'app/.metadata', '# word word\nversion:\n  channel: "stable"\n'),
            [(1, ''), (2, 'version:'), (3, '"stable"'), (4, '')])

    def test_kind_by_shebang(self):
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_g0 test_guardlib`. Expected: `FAILED (failures=3)`, namely
`test_flutter_kinds_pass`, `test_flutter_kinds_are_config` and `test_flutter_config_strings`.

**Green.**

**Edit `tool/checks/guardlib.py`.** Replace:

~~~~python
CONFIG_EXT = ('.json', '.yaml', '.yml', '.plist', '.entitlements', '.pbxproj',
              '.xcconfig', '.xcscheme')
~~~~

with:

~~~~python
CONFIG_EXT = ('.json', '.yaml', '.yml', '.plist', '.entitlements', '.pbxproj',
              '.xcconfig', '.xcscheme',
              # Flutter's iOS project (scaffold-2-app, D20 Q13). XML, an
              # XML plist, and a header with no lexer: read whole.
              '.xcworkspacedata', '.xcsettings', '.storyboard', '.h')
# Config known by its whole name: FVM's pin (JSON) and Flutter's
# project record (YAML). Neither has an extension (D20 Q13).
CONFIG_NAMES = ('.fvmrc', '.metadata')
~~~~

**Edit `tool/checks/guardlib.py`.** Replace:

~~~~python
        if ext in CONFIG_EXT:
            return 'config'
~~~~

with:

~~~~python
        if ext in CONFIG_EXT or b in CONFIG_NAMES:
            return 'config'
~~~~

**Edit `tool/checks/guardlib.py`.** Replace:

~~~~python
    if b.endswith(('.plist', '.entitlements')):
        for m in PLIST_STRING.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    elif b.endswith(('.yaml', '.yml')):
~~~~

with:

~~~~python
    if b.endswith(('.plist', '.entitlements', '.xcsettings')):
        for m in PLIST_STRING.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    elif b.endswith(('.yaml', '.yml')) or b == '.metadata':
~~~~

**Edit `tool/checks/tests/mutations.py`.** Replace:

~~~~python
    ('lex.py', "self.lang == 'swift' and value in", "value in",
     ['test_fail_closed.Swift.test_division_near_try_still_lexes']),
]
~~~~

with:

~~~~python
    ('lex.py', "self.lang == 'swift' and value in", "value in",
     ['test_fail_closed.Swift.test_division_near_try_still_lexes']),
    ('guardlib.py', "'.xcworkspacedata', ", "",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', "'.xcsettings', ", "",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', "'.storyboard', ", "",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', ", '.h')", ")",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', "('.fvmrc', ", "(",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', ", '.metadata')", ")",
     ['test_g0.G0.test_flutter_kinds_pass']),
]
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py`. Expected: `Ran 115 tests`, `OK`.
**Mutations:** `python3 -I -B tool/checks/tests/mutations.py guardlib.py`. Expected: `mutations: 7 run, all caught`.

    git add tool/checks && git commit -m "G0: the kinds FVM and Flutter's iOS project bring (D20 Q13)" -m "<trailer>"

### Task 4 · G5: Apple's loggers in Swift and headers (D20 Q13)

**Red.**

**Edit `tool/checks/tests/test_g5.py`.** Replace:

~~~~python
                     'server/src/a.ts': 'const y = Math.log(2);\n'})
~~~~

with:

~~~~python
                     'server/src/a.ts': 'const y = Math.log(2);\n'})

    def test_apple_writers_refused_in_swift_and_headers(self):
        # D20 Q13: Apple's loggers, in Swift code and in headers.
        cases = [
            ('app/ios/Runner/a.swift', 'NSLog("%d", 1)\n', 'writer-NSLog'),
            ('app/ios/Runner/a.swift', 'os_log("%d", 1)\n', 'writer-os_log'),
            ('app/ios/Runner/a.swift', 'let l = Logger(subsystem: "a", category: "b")\n',
             'writer-Logger'),
            ('app/ios/Runner/a.h', 'void f(void) { NSLog(@"x"); }\n', 'writer-NSLog'),
        ]
        for path, body, reason in cases:
            self.refused({path: body}, reason)

    def test_apple_writers_only_in_apple_code(self):
        self.passed({'app/lib/a.dart': 'final l = Logger();\n',
                     'app/ios/Runner/a.swift': '// NSLog(1)\nlet s = "os_log(1)"\nlet m = MyLogger(1)\n'})
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py test_g5`. Expected: `FAILED (failures=1)`,
`test_apple_writers_refused_in_swift_and_headers`.

**Green.**

**Edit `tool/checks/g5_logging.py`.** Replace:

~~~~python
# checks' own writer. Math.log( computes a logarithm and is allowed.
~~~~

with:

~~~~python
# checks' own writer. Math.log( computes a logarithm and is allowed.
# Apple's loggers are refused in Swift and in headers (D20 Q13).
~~~~

**Edit `tool/checks/g5_logging.py`.** Replace:

~~~~python
MATH = re.compile(
~~~~

with:

~~~~python
APPLE = [
    ('NSLog', re.compile(B + r'NSLog\s*\(')),
    ('os_log', re.compile(B + r'os_log\s*\(')),
    ('Logger', re.compile(B + r'Logger\s*\(')),
]
MATH = re.compile(
~~~~

**Edit `tool/checks/g5_logging.py`.** Replace:

~~~~python
def scan(path, text, findings):
    for name, rx in WRITERS:
~~~~

with:

~~~~python
def scan(path, text, findings, writers):
    for name, rx in writers:
~~~~

**Edit `tool/checks/g5_logging.py`.** Replace:

~~~~python
        if kind is None or path in EXEMPT:
            continue
        if kind == 'config':
            scan(path, src.text(path) or '', findings)
~~~~

with:

~~~~python
        if kind is None or path in EXEMPT:
            continue
        apple = kind == 'swift' or path.lower().endswith('.h')
        writers = WRITERS + APPLE if apple else WRITERS
        if kind == 'config':
            scan(path, src.text(path) or '', findings, writers)
~~~~

**Edit `tool/checks/g5_logging.py`.** Replace:

~~~~python
        scan(path, lx.code, findings)
~~~~

with:

~~~~python
        scan(path, lx.code, findings, writers)
~~~~

**Edit `tool/checks/tests/mutations.py`.** Replace:

~~~~python
    ('guardlib.py', ", '.metadata')", ")",
     ['test_g0.G0.test_flutter_kinds_pass']),
]
~~~~

with:

~~~~python
    ('guardlib.py', ", '.metadata')", ")",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('g5_logging.py', "    ('NSLog', re.compile(B + r'NSLog\\s*\\(')),\n", "",
     ['test_g5.G5.test_apple_writers_refused_in_swift_and_headers']),
]
~~~~

Run `python3 -I -B tool/checks/tests/run_tests.py`. Expected: `Ran 117 tests`, `OK`.
**Mutations:** `python3 -I -B tool/checks/tests/mutations.py g5_logging.py`. Expected: `mutations: 3 run, all caught`.
Then `python3 -I -B tool/checks/tests/mutations.py`. Expected: `mutations: 32 run, all caught`.

    git add tool/checks && git commit -m "G5: Apple's loggers in Swift and headers (D20 Q13)" -m "<trailer>"

### Task 5 · The skeleton's root files and a blank screen (D20 Q1, Q9a, Q13, Q16, Q18)

**Red.**

**File `app/test/app_test.dart`**

~~~~dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';

void main() {
  testWidgets('the app shows a blank screen with no text', (tester) async {
    await tester.pumpWidget(const SoulDreamsApp());
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(RichText), findsNothing);
  });
}
~~~~

In `app/`: `fvm flutter test --no-pub test/app_test.dart`. Expected: it fails to compile, naming
`package:souldreams/app.dart`.

**Green.**

**File `app/lib/app.dart`**

~~~~dart
import 'package:flutter/material.dart';

/// The app. For now a blank screen with no text (scaffold-2-app).
class SoulDreamsApp extends StatelessWidget {
  const SoulDreamsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Scaffold());
  }
}
~~~~

**File `app/lib/main.dart`** (replaces the template's; Task 7 completes it)

~~~~dart
// The testers' SoulDreams (app.souldreams). It never imports lib/founder/:
// in a tester build the export is not built in (CLAUDE.md R8, G8).
import 'package:flutter/widgets.dart';

import 'app.dart';

void main() {
  runApp(const SoulDreamsApp());
}
~~~~

**File `app/README.md`**

~~~~markdown
The SoulDreams app. Start with the repository's [CLAUDE.md](../CLAUDE.md).
~~~~

**Edit `app/.gitignore`.** Replace:

~~~~text
# Widget Preview related
.widget_preview/
~~~~

with:

~~~~text
# Widget Preview related
.widget_preview/

# FVM's link to the pinned SDK, VS Code's settings, and the owner's
# signing team (scaffold-2-app, D20 Q9a and Q13)
.fvm/
.vscode/
/ios/Flutter/Signing.xcconfig
~~~~

In `app/`: `fvm flutter test --no-pub`, expected `All tests passed!` (1 test). `fvm flutter analyze --no-pub`,
expected `No issues found!`. Then `git check-ignore -q app/.fvm/flutter_sdk app/ios/Flutter/Signing.xcconfig && echo
ignored`, expected `ignored`.

**Mutation M-a.** In `app/lib/app.dart`, change `home: Scaffold()` to `home: Scaffold(body: Text('x'))`. Run
`fvm flutter test --no-pub test/app_test.dart`: it must fail on `findsNothing`. Restore the line, and run again:
it must pass.

    git add app/.gitignore app/.metadata app/.fvmrc app/README.md app/analysis_options.yaml app/pubspec.yaml app/pubspec.lock app/lib/main.dart app/lib/app.dart app/test/app_test.dart
    git commit -m "App: the skeleton's root files and a blank screen (D20 Q1, Q16, Q18)" -m "<trailer>"

Expected: the hook prints `guards (staged): all passed`. `git status --short` then shows only `?? app/ios/`.

### Task 6 · SafeLog and the hosts file (R3, R10; D20 Q17)

**Red.**

**File `app/test/core/safe_log_test.dart`**

~~~~dart
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';

void main() {
  final lines = <String>[];
  final original = SafeLog.sink;
  setUp(() {
    lines.clear();
    SafeLog.sink = lines.add;
  });
  tearDown(() => SafeLog.sink = original);

  test('an event with numbers is its code, then the numbers', () {
    SafeLog.event(LogEvent.appStarted, [1, 2.5]);
    expect(lines, ['appStarted 1 2.5']);
  });

  test('an event alone is its code', () {
    SafeLog.event(LogEvent.wrongFlavour);
    expect(lines, ['wrongFlavour']);
  });
}
~~~~

In `app/`: `fvm flutter test --no-pub test/core/safe_log_test.dart`. Expected: it fails to compile, naming
`package:souldreams/core/safe_log.dart`.

**Green.**

**File `app/lib/core/safe_log.dart`**

~~~~dart
// The app's only logger (CLAUDE.md R3; G5 exempts this file). It takes
// an event code and numbers, never a String: nothing from a night can
// reach a log. Release builds log nothing (D20 Q17).
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Every event the app may log. A new event is a new value here.
enum LogEvent { appStarted, wrongFlavour }

abstract final class SafeLog {
  /// Where lines go. Tests replace it; the app writes to the debugger.
  @visibleForTesting
  static void Function(String line) sink = _toDebugger;

  static void event(LogEvent code, [List<num> numbers = const []]) {
    if (kReleaseMode) return;
    sink([code.name, for (final n in numbers) '$n'].join(' '));
  }

  static void _toDebugger(String line) => developer.log(line, name: 'souldreams');
}
~~~~

**File `app/lib/core/hosts.dart`**

~~~~dart
// Every host the app talks to lives here, and nowhere else (CLAUDE.md
// R10, G9). None yet: the server and Soniox's EU endpoint arrive with
// the branches that use them.
abstract final class Hosts {}
~~~~

In `app/`: `fvm flutter test --no-pub`, expected `All tests passed!` (3 tests). `fvm flutter analyze --no-pub`,
expected `No issues found!`.

**Mutation M-b.** In `safe_log.dart`, change `.join(' ')` to `.join(',')`. `fvm flutter test --no-pub
test/core/safe_log_test.dart` must fail. Restore it, and the test passes.

    git add app/lib/core/safe_log.dart app/lib/core/hosts.dart app/test/core/safe_log_test.dart
    git commit -m "App: SafeLog and the hosts file (R3, R10; D20 Q17)" -m "<trailer>"

### Task 7 · Three entry points, each refusing another flavour (D20 Q8)

**Red.**

**File `app/test/core/flavour_test.dart`**

~~~~dart
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/flavour.dart';
import 'package:souldreams/core/safe_log.dart';

void main() {
  final lines = <String>[];
  final original = SafeLog.sink;
  setUp(() {
    lines.clear();
    SafeLog.sink = lines.add;
  });
  tearDown(() => SafeLog.sink = original);

  test('each flavour starts under its own name', () {
    for (final f in Flavour.values) {
      requireFlavour(f, flavor: f.name);
    }
    expect(lines, isEmpty);
  });

  test('another flavour, or none, is refused with a code', () {
    expect(() => requireFlavour(Flavour.founder, flavor: 'dev'), throwsStateError);
    expect(() => requireFlavour(Flavour.tester, flavor: null), throwsStateError);
    expect(lines, ['wrongFlavour', 'wrongFlavour']);
  });

  test('the names are the Xcode schemes', () {
    expect([for (final f in Flavour.values) f.name], ['dev', 'founder', 'tester']);
  });
}
~~~~

In `app/`: `fvm flutter test --no-pub test/core/flavour_test.dart`. Expected: it fails to compile, naming
`package:souldreams/core/flavour.dart`.

**Green.**

**File `app/lib/core/flavour.dart`**

~~~~dart
import 'package:flutter/services.dart';

import 'safe_log.dart';

/// The three builds, named as their Xcode schemes (D20 Q5).
enum Flavour { dev, founder, tester }

/// Stops the app unless it was built as [expected]: `appFlavor` must be
/// its name. A build with another flavour, or none, never starts (D20 Q8).
void requireFlavour(Flavour expected, {String? flavor = appFlavor}) {
  if (flavor == expected.name) return;
  SafeLog.event(LogEvent.wrongFlavour);
  throw StateError('flavour');
}
~~~~

**File `app/lib/main.dart`**

~~~~dart
// The testers' SoulDreams (app.souldreams). It never imports lib/founder/:
// in a tester build the export is not built in (CLAUDE.md R8, G8).
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/safe_log.dart';

void main() {
  requireFlavour(Flavour.tester);
  SafeLog.event(LogEvent.appStarted);
  runApp(const SoulDreamsApp());
}
~~~~

**File `app/lib/main_dev.dart`**

~~~~dart
// SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
// nights only.
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/safe_log.dart';

void main() {
  requireFlavour(Flavour.dev);
  SafeLog.event(LogEvent.appStarted);
  runApp(const SoulDreamsApp());
}
~~~~

**File `app/lib/main_founder.dart`**

~~~~dart
// SoulDreams (app.souldreams.founder): the owner's Cohort 0 app. Release
// builds only, built by the CLI command (D20 Q8).
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/safe_log.dart';

void main() {
  requireFlavour(Flavour.founder);
  SafeLog.event(LogEvent.appStarted);
  runApp(const SoulDreamsApp());
}
~~~~

In `app/`: `fvm flutter test --no-pub`, expected `All tests passed!` (6 tests). `fvm flutter analyze --no-pub`,
expected `No issues found!`. G8 is proven by the hook: `main.dart` imports nothing under `lib/founder/`.

**Mutation M-c.** In `flavour.dart`, change `if (flavor == expected.name) return;` to `return;`. `fvm flutter test
--no-pub test/core/flavour_test.dart` must fail on the refusal test. Restore it, and the test passes.

    git add app/lib/core/flavour.dart app/test/core/flavour_test.dart app/lib/main.dart app/lib/main_dev.dart app/lib/main_founder.dart
    git commit -m "App: three entry points, each refusing another flavour (D20 Q8)" -m "<trailer>"

### Task 8 · iOS: three flavours, iPhone only (D20 Q2–Q10)

The script below changes `project.pbxproj`, `Info.plist` and the schemes. It lives in `.scratch/` (ignored, not
committed): its result is what is committed, and Task 9 proves it.
- It adds the three flavour files to the project, and nine configurations to each of the project, `Runner` and
  `RunnerTests`. `Runner`'s are based on the flavour files.
- It removes the `Runner` target's own bundle identifier (the xcconfigs set it) and any Team ID `flutter create`
  wrote (D20 Q9a).
- It makes the app iPhone only and points the home-screen name at `$(APP_DISPLAY_NAME)`.
- It writes the three schemes (founder's Run uses `Release-founder`: workflow §i) and removes `Runner.xcscheme`.

Each edit must apply exactly as counted, or it stops before writing anything. A second run stops with `already
applied`.

**File `.scratch/scaffold-2/ios_flavours.py`**

~~~~python
# scaffold-2-app, Task 8 (D20 Q3, Q5, Q6, Q8, Q9a). Turns the template's
# one-app iOS project into the three flavours. Run once, from app/:
#   python3 -I -B ../.scratch/scaffold-2/ios_flavours.py
# Every edit must apply exactly as often as stated, or it stops (exit 1)
# before writing anything (R14). It prints counts, never a value.
import hashlib
import os
import re
import sys

FLAVOURS = ('dev', 'founder', 'tester')
PBXPROJ = 'ios/Runner.xcodeproj/project.pbxproj'
PLIST = 'ios/Runner/Info.plist'
SCHEMES = 'ios/Runner.xcodeproj/xcshareddata/xcschemes/'


def say(line):
    sys.stdout.write('ios_flavours: ' + line + '\n')


def stop(why):
    say('STOP ' + why)
    sys.exit(1)


def once(text, old, new, what, times=1):
    n = text.count(old)
    if n != times:
        stop('%s: found %d, expected %d' % (what, n, times))
    return text.replace(old, new)


def new_id(text, *parts):
    i = hashlib.sha1('/'.join(('souldreams',) + parts).encode()).hexdigest()[:24].upper()
    if i in text:
        stop('id clash')
    return i


BLOCK = re.compile(r'\t\t([0-9A-F]{24}) /\* (\w+) \*/ = \{\n\t\t\tisa = XCBuildConfiguration;\n'
                   r'.*?\n\t\t\};\n', re.S)
LIST = re.compile(r'\t\t[0-9A-F]{24} /\* Build configuration list for (\w+) "(\w+)" \*/ = \{\n'
                  r'\t\t\tisa = XCConfigurationList;\n\t\t\tbuildConfigurations = \(\n'
                  r'((?:\t\t\t\t[0-9A-F]{24} /\* \w+ \*/,\n)+)\t\t\t\);')
ENTRY = re.compile(r'\t\t\t\t([0-9A-F]{24}) /\* (\w+) \*/,\n')
BASE = re.compile(r'baseConfigurationReference = [0-9A-F]{24} /\* (Debug|Release)\.xcconfig \*/;')


def pbxproj(text):
    if 'Debug-dev' in text:
        stop('already applied')
    team = re.compile(r'^\t+DEVELOPMENT_TEAM = [^;\n]*;\n', re.M)
    n = len(team.findall(text))
    if n not in (0, 3):
        stop('DEVELOPMENT_TEAM: found %d, expected 0 or 3' % n)
    text = team.sub('', text)
    say('DEVELOPMENT_TEAM lines removed: %d' % n)
    text = once(text, '\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = app.souldreams.souldreams;\n', '',
                'Runner bundle identifier', 3)
    text = once(text, 'TARGETED_DEVICE_FAMILY = "1,2";', 'TARGETED_DEVICE_FAMILY = 1;',
                'device family', 3)

    refs, children = '', ''
    ref_ids = {}
    for f in FLAVOURS:
        ref_ids[f] = new_id(text, 'file', f)
        refs += ('\t\t%s /* %s.xcconfig */ = {isa = PBXFileReference; lastKnownFileType = '
                 'text.xcconfig; name = %s.xcconfig; path = Flutter/%s.xcconfig; '
                 'sourceTree = "<group>"; };\n' % (ref_ids[f], f, f, f))
        children += '\t\t\t\t%s /* %s.xcconfig */,\n' % (ref_ids[f], f)
    text = once(text, '/* End PBXFileReference section */',
                refs + '/* End PBXFileReference section */', 'file reference section')
    generated = '\t\t\t\t9740EEB31CF90195004384FC /* Generated.xcconfig */,\n'
    text = once(text, generated, generated + children, 'Flutter group')

    blocks = {m.group(1): m.group(0) for m in BLOCK.finditer(text)}
    lists = LIST.findall(text)
    if len(blocks) != 9 or len(lists) != 3:
        stop('configurations: %d blocks, %d lists, expected 9 and 3' % (len(blocks), len(lists)))
    added = []
    for kind, owner, entries_text in lists:
        entries = ENTRY.findall(entries_text)
        if sorted(name for _, name in entries) != ['Debug', 'Profile', 'Release']:
            stop('list %s %s: not Debug, Release and Profile' % (kind, owner))
        new_entries = ''
        for f in FLAVOURS:
            for base_id, mode in sorted(entries, key=lambda e: ('Debug', 'Profile', 'Release').index(e[1])):
                block = blocks[base_id]
                name = '%s-%s' % (mode, f)
                i = new_id(text, kind, owner, name)
                b = once(block, '\t\t%s /* %s */ = {' % (base_id, mode),
                         '\t\t%s /* %s */ = {' % (i, name), 'block header')
                b = once(b, '\t\t\tname = %s;\n' % mode, '\t\t\tname = %s;\n' % name, 'block name')
                bases = BASE.findall(b)
                if owner == 'Runner' and kind == 'PBXNativeTarget':
                    if len(bases) != 1:
                        stop('Runner %s: found %d base references' % (mode, len(bases)))
                    b = BASE.sub('baseConfigurationReference = %s /* %s.xcconfig */;'
                                 % (ref_ids[f], f), b)
                elif bases:
                    stop('%s %s: unexpected base reference' % (owner, mode))
                added.append(b)
                new_entries += '\t\t\t\t%s /* %s */,\n' % (i, name)
        text = once(text, entries_text, entries_text + new_entries, 'list ' + owner)
    text = once(text, '/* End XCBuildConfiguration section */',
                ''.join(added) + '/* End XCBuildConfiguration section */', 'configuration section')
    say('configurations added: %d' % len(added))
    return text


IPAD = ('\t<key>UISupportedInterfaceOrientations~ipad</key>\n\t<array>\n'
        '\t\t<string>UIInterfaceOrientationPortrait</string>\n'
        '\t\t<string>UIInterfaceOrientationPortraitUpsideDown</string>\n'
        '\t\t<string>UIInterfaceOrientationLandscapeLeft</string>\n'
        '\t\t<string>UIInterfaceOrientationLandscapeRight</string>\n\t</array>\n')


def plist(text):
    text = once(text, '\t<key>CFBundleDisplayName</key>\n\t<string>Souldreams</string>\n',
                '\t<key>CFBundleDisplayName</key>\n\t<string>$(APP_DISPLAY_NAME)</string>\n',
                'display name')
    return once(text, IPAD, '', 'iPad orientations')


def scheme(text, f):
    launch = '<LaunchAction\n      buildConfiguration = "Debug"'
    if f == 'founder':
        # The Cohort 0 app runs only as a release build (workflow, section i).
        text = once(text, launch, launch.replace('"Debug"', '"Release-founder"'), 'launch')
    text = once(text, 'buildConfiguration = "Debug"', 'buildConfiguration = "Debug-%s"' % f,
                'Debug actions', 2 if f == 'founder' else 3)
    text = once(text, 'buildConfiguration = "Profile"', 'buildConfiguration = "Profile-%s"' % f,
                'Profile action')
    return once(text, 'buildConfiguration = "Release"', 'buildConfiguration = "Release-%s"' % f,
                'Release action')


def read(path):
    with open(path, encoding='utf-8') as fh:
        return fh.read()


def main():
    if not os.path.isfile('pubspec.yaml') or not os.path.isdir('ios'):
        stop('run from app/')
    out = {PBXPROJ: pbxproj(read(PBXPROJ)), PLIST: plist(read(PLIST))}
    runner = read(SCHEMES + 'Runner.xcscheme')
    for f in FLAVOURS:
        out[SCHEMES + f + '.xcscheme'] = scheme(runner, f)
    for path, text in out.items():
        with open(path, 'w', encoding='utf-8') as fh:
            fh.write(text)
    os.remove(SCHEMES + 'Runner.xcscheme')
    say('done: %d files written, Runner.xcscheme removed' % len(out))


main()
~~~~

**File `app/ios/Flutter/dev.xcconfig`**

~~~~text
// SoulDreams Dev (D20): the owner's test app, invented nights only.
// Debug.xcconfig and Release.xcconfig only include Generated.xcconfig,
// so every mode of this flavour starts from it. The lines after it win:
// an Xcode build uses this flavour's entry point, whatever the last
// flutter command wrote there (D20 Q8).
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = app.souldreams.dev
APP_DISPLAY_NAME = SoulDreams Dev
FLUTTER_TARGET = lib/main_dev.dart
FLAVOR = dev
// The owner's Team ID, in an untracked file (D20 Q9a). Only this flavour
// is ever signed under the Personal Team (D20 Q10).
#include? "Signing.xcconfig"
~~~~

**File `app/ios/Flutter/founder.xcconfig`**

~~~~text
// SoulDreams, the owner's Cohort 0 app (D20). Release builds only, built
// by the CLI command (D20 Q8). It includes no signing: it waits for the
// paid membership (D20 Q9b). See dev.xcconfig for the include order.
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = app.souldreams.founder
// Register place MP·55, until branch 3's generator writes it (D20 Q2).
APP_DISPLAY_NAME = [MP·55]
FLUTTER_TARGET = lib/main_founder.dart
FLAVOR = founder
~~~~

**File `app/ios/Flutter/tester.xcconfig`**

~~~~text
// SoulDreams for testers (D20). It includes no signing: it waits for the
// paid membership (D20 Q10). See dev.xcconfig for the include order.
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = app.souldreams
// Register place MP·55, until branch 3's generator writes it (D20 Q2).
APP_DISPLAY_NAME = [MP·55]
FLUTTER_TARGET = lib/main.dart
FLAVOR = tester
~~~~

Then, in `app/`:

    python3 -I -B ../.scratch/scaffold-2/ios_flavours.py

Expected, exactly:

    ios_flavours: DEVELOPMENT_TEAM lines removed: N
    ios_flavours: configurations added: 27
    ios_flavours: done: 5 files written, Runner.xcscheme removed

`N` is Task 1's count, `0` or `3`. Then:

    plutil -lint ios/Runner.xcodeproj/project.pbxproj ios/Runner/Info.plist
    for f in ios/Runner.xcodeproj/xcshareddata/xcschemes/*.xcscheme; do xmllint --noout "$f" && echo "$f ok"; done
    grep -c 'isa = XCBuildConfiguration' ios/Runner.xcodeproj/project.pbxproj
    grep -c 'DEVELOPMENT_TEAM' ios/Runner.xcodeproj/project.pbxproj

Expected: both `OK`; `dev.xcscheme ok`, `founder.xcscheme ok`, `tester.xcscheme ok`; `36`; `0`.

    git add app/ios && git commit -m "iOS: three flavours, iPhone only (D20 Q2-Q10)" -m "<trailer>"

Expected: the hook prints `guards (staged): all passed`, and `git status --short` prints nothing.

### Task 9 · [OWNER] Signing for dev, and the Xcode checks (D20 Q7, Q9a, Q10)

Claude Code writes this script (not committed), then stops:

**File `.scratch/scaffold-2/xcode_checks.sh`**

~~~~sh
#!/bin/sh
# scaffold-2-app, Task 9 (D20 Q7): the owner's check of the three
# flavours. It prints names and settings only: the Team ID itself is
# never printed, only whether it is set.
set -u
cd "$(git rev-parse --show-toplevel)/app" || exit 2
fvm flutter build ios --config-only --debug --flavor dev -t lib/main_dev.dart || exit 1
grep -E '^(FLUTTER_TARGET|FLAVOR)=' ios/Flutter/Generated.xcconfig
cd ios || exit 2
xcodebuild -list -workspace Runner.xcworkspace 2>/dev/null || exit 1
for s in dev founder tester; do
  for m in Debug Profile Release; do
    xcodebuild -showBuildSettings -workspace Runner.xcworkspace -scheme "$s" \
      -configuration "$m-$s" 2>/dev/null | awk -v c="$m-$s" '
      /^Build settings for action .* and target / { runner = ($NF == "Runner:") }
      runner && $1 ~ /^(APP_DISPLAY_NAME|FLAVOR|FLUTTER_TARGET|IPHONEOS_DEPLOYMENT_TARGET|PRODUCT_BUNDLE_IDENTIFIER|TARGETED_DEVICE_FAMILY)$/ {
        sub(/^ +/, ""); print c ": " $0 }
      runner && $1 == "DEVELOPMENT_TEAM" && NF >= 3 { print c ": DEVELOPMENT_TEAM is set" }'
  done
done
~~~~

    Paste 1 — Terminal (type your own Team ID, from Xcode › Settings › Accounts, in place of TEAMID; it never leaves your Mac)
    cd ~/Developer/soul-dreams-app/app && printf 'DEVELOPMENT_TEAM = %s\n' 'TEAMID' > ios/Flutter/Signing.xcconfig && git check-ignore ios/Flutter/Signing.xcconfig && git status --short

Expected: `ios/Flutter/Signing.xcconfig` printed by `check-ignore`, and nothing from `git status`.

    Paste 2 — Terminal
    cd ~/Developer/soul-dreams-app && sh .scratch/scaffold-2/xcode_checks.sh; echo "exit=$?"; git status --short

Expected:
1. **`flutter build ios --config-only`** ends without error. `Generated.xcconfig` then names `lib/main_dev.dart`
   and `FLAVOR=dev`.
2. **`xcodebuild -list`:**
   - build configurations `Debug`, `Release`, `Profile`, then `Debug-dev`, `Profile-dev`, `Release-dev`,
     `Debug-founder`, `Profile-founder`, `Release-founder`, `Debug-tester`, `Profile-tester`, `Release-tester`;
   - schemes `dev`, `founder`, `tester` and no `Runner`.
3. **Then one line per setting, for each of the nine configurations:**
   - `dev` rows: `APP_DISPLAY_NAME = SoulDreams Dev`, `DEVELOPMENT_TEAM is set`, `FLAVOR = dev`,
     `FLUTTER_TARGET = lib/main_dev.dart`, `IPHONEOS_DEPLOYMENT_TARGET = 15.0`,
     `PRODUCT_BUNDLE_IDENTIFIER = app.souldreams.dev`, `TARGETED_DEVICE_FAMILY = 1`.
   - `founder` rows: `APP_DISPLAY_NAME = [MP·55]`, `FLAVOR = founder`, `FLUTTER_TARGET = lib/main_founder.dart`
     (even though `Generated.xcconfig` names `main_dev.dart`: D20 Q8), `PRODUCT_BUNDLE_IDENTIFIER =
     app.souldreams.founder`, the same deployment target and family, and **no** `DEVELOPMENT_TEAM` line.
   - `tester` rows: the same as founder, with `tester`, `lib/main.dart` and `app.souldreams`.
4. `exit=0`.
5. `git status --short` prints nothing. Xcode may leave an empty `xcshareddata/swiftpm/` folder, which git
   ignores. If a file shows up there, report it: whether to commit it is a question.

**Send back** the output. If a row differs, nothing goes further.

### Task 10 · `check_all.sh`: the pinned Flutter, offline locked packages (D20 Q15)

**Edit `tool/check_all.sh`.** Replace:

~~~~sh
if [ -d app ]; then
  (cd app && fvm flutter analyze && fvm flutter test) || fail app
else
~~~~

with:

~~~~sh
if [ -d app ]; then
  # The pinned Flutter first, then the locked packages (offline: nothing
  # is fetched), the analyzer and the tests (D20 Q15).
  pin=$(sed -n 's/.*"flutter": *"\([^"]*\)".*/\1/p' app/.fvmrc)
  ran=$(cd app && fvm flutter --version --machine 2>/dev/null \
    | sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p')
  echo "flutter: pinned ${pin:-none}, running ${ran:-none}"
  if [ -z "$pin" ] || [ "$pin" != "$ran" ]; then
    fail flutter-version
  else
    (cd app && fvm flutter pub get --offline --enforce-lockfile \
      && fvm flutter analyze && fvm flutter test) || fail app
  fi
else
~~~~

Checks:
- `sh -n tool/check_all.sh` prints nothing.
- `sed -n 's/.*"flutter": *"\([^"]*\)".*/\1/p' app/.fvmrc` prints `3.47.9`.
- In `app/`, `fvm flutter --version --machine | sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p'` prints
  `3.47.9`.
- `python3 -I -B tool/checks/tests/run_tests.py test_check_all` gives `OK`; its copy leaves `app/` out.

The whole script runs in Task 11.

    git add tool/check_all.sh && git commit -m "check_all.sh: the pinned Flutter, offline locked packages (D20 Q15)" -m "<trailer>"

### Task 11 · [OWNER] `check_all.sh` end to end, the analyzer gate, and the MCP server

    Paste 1 — Terminal
    cd ~/Developer/soul-dreams-app && tool/check_all.sh; echo "exit=$?"

Expected:
- the guards, `Ran 117 tests`, `OK`, `mutations: 32 run, all caught`;
- `flutter: pinned 3.47.9, running 3.47.9`;
- `Got dependencies!` (offline), `No issues found!`, `All tests passed!` (6 tests);
- `check_all: all passed`, and `exit=0`.

**Send back** the output. Claude Code then compares the analyzer's lines with Task 2's baseline, less the `(ran in
…)` timing: `sed 's/ (ran in [0-9.]*s)//'` on both. They must match.

    Paste 2 — Terminal (a new session; the previous one ends with /exit)
    cd ~/Developer/soul-dreams-app && git branch --show-current && git status --short && PATH="$PWD/app/.fvm/flutter_sdk/bin:$PATH" claude --model opus

In the new session, type `/mcp`. Expected: `dart-mcp-server` connected. If not, report its error. This doesn't block
the branch, and Task 12 records the result.

### Task 12 · docs/Status.md

**File `docs/Status.md`**, written whole, with two replacements made when it is written:
- `DATE` becomes the day this task runs (`date +%F`);
- `TASK0` becomes the one sentence on Flutter in the sandbox that the owner approved after Task 0.

Banked item 14's K1 is dropped (closed by branch 1's Task 2c, C2). Item 15 loses `.fvmrc`, which G0 now knows.

**File `docs/Status.md`**

~~~~markdown
# Status — SoulDreams app

Last updated: DATE, at the end of branch `scaffold-2-app`, by Claude Code.

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
20. Flutter in Claude Code's sandbox: TASK0.

## Documents as last imported

None yet. `docs/source/SOURCES` does not exist.
~~~~

    git add docs/Status.md && git commit -m "Status.md: at the end of scaffold-2-app" -m "<trailer>"

---

## Part 3 · Questions for the owner (numbered; a blank is not a yes)

1. **Flutter in the sandbox, before Task 0.** P5 will fail as things stand (verified 2026-11-09, after analytics
   were turned off): `Flutter failed to write to a file at "~/.config/flutter/tool_state"`. The cause is in Part 1,
   "Facts".
   - *Lean:* before Task 0, the owner adds `"~/.config/flutter"` to `sandbox.filesystem.allowWrite` in
     `.claude/settings.json`, and `"Bash(fvm flutter config *)"` and `"Bash(flutter config *)"` to `permissions.deny`.
     That way Claude Code can't change Flutter's settings through the new write access.
   - *If not:* the owner adds the one key `"displayed-intel-warning-message": true` to `~/.config/flutter/tool_state`
     by hand. That's narrower, but any other write Flutter makes there later fails the same way.
   - Either way, Task 0 runs P5 and reports the exact result, and Task 12 records the outcome as banked item 20.
2. **`check_all.sh` and "Claude Code never runs `pub get`".** The new app step runs `fvm flutter pub get --offline
   --enforce-lockfile` (D20 Q15). Offline and lockfile-bound, it fetches nothing and changes nothing.
   - *Lean:* from the next branch on, Claude Code may run `tool/check_all.sh`, that one `pub get` included. In this
     branch it doesn't; the owner runs it in Task 11.
   - *If not:* `check_all.sh` stays the owner's alone, and Claude Code's task ends run the guards, guard tests,
     mutations and `fvm flutter analyze/test --no-pub` one by one.
3. **CLAUDE.md's G5 line** doesn't name the Apple loggers G5 now refuses.
   - *Lean:* Task 12 also makes one edit to `CLAUDE.md` (the owner approves it at the prompt). It appends to G5's
     line: "; in Swift and headers also `NSLog(`, `os_log(` and `Logger(`".
   - *If not:* the line stays; "a check is a floor" covers it.
4. **A compile check of each flavour in Task 9.** D20 Q7 names only `-list` and `-showBuildSettings`.
   - *Lean:* add `fvm flutter build ios --debug --no-codesign --flavor X -t <entry point>` for each flavour to
     `xcode_checks.sh`. It proves each flavour builds, with no signing and nothing installed (a few minutes).
   - *If not:* the first build is the owner's first install of SoulDreams Dev.
5. **The `RunnerTests` target** from the template stays. It gets the nine configurations (Xcode needs them in every
   target) and keeps the bundle identifier `app.souldreams.souldreams.RunnerTests`. Nothing builds it.
   - *Lean:* keep it.
   - *If not:* the script also removes the target, a larger `pbxproj` edit.
6. **The founder scheme's Run action** uses `Release-founder`, so pressing Run in Xcode on the founder scheme can
   only make a release build (workflow §i).
   - *Lean:* yes.
   - *If not:* `Debug-founder`, like the other two.
7. **iPhone orientations.** The template lets the iPhone app turn to landscape. That's a screen behaviour, so it
   isn't settled here.
   - *Lean:* the Build chat asks Product & Design through the head, and the template's setting stays until they
     answer.
   - *If they rule portrait only:* a later branch removes two lines from `Info.plist`.

---

## Part 4 · How this plan was proven

On 2026-11-09, before this file was committed:

1. **The stand-in skeleton.** The sandbox can't run `flutter create`, which needs downloads. So the owner's
   skeleton was stood in for by rendering the same template:
   - the SDK's own files (`~/fvm/versions/stable`, Flutter 3.47.9, revision `c197ca5199`),
     `packages/flutter_tools/templates/app`;
   - with `--empty`, iOS and Swift Package Manager on, the flags of Task 1, and no Team ID;
   - with the real icons from the pub cache (`flutter_template_images` 5.0.0, the version 3.47.9 requires);
   - standalone section lines removed whole, as mustache does.

   `.metadata`, `.fvmrc` and `pubspec.lock` were written to the shapes those tools write. The rendered
   `project.pbxproj`, `Info.plist` and `AppFrameworkInfo.plist` pass `plutil -lint`. The real skeleton may differ
   in detail. The script's counts and Task 2's expected findings catch any difference that matters.
2. **The build worktree** `./.scratch/s2-build` was detached at `1665fb8` and given the stand-in skeleton. Then:
   - **Tasks 3 and 4:**
     - Red: the new tests fail as stated (`FAILED (failures=3)` in Task 3, `FAILED (failures=1)` in Task 4).
     - Green: `Ran 115 tests`, `OK` and `7 run, all caught` (Task 3); `Ran 117 tests`, `OK` and `3 run, all caught`
       (Task 4); then `32 run, all caught` in all.
   - **Tasks 5 to 8 and 10:** each committed through the real hook, each with `guards (staged): all passed`.
     After Task 10: `guards (tracked): all passed`, and `test_check_all` gave `OK`.
   - **Task 8's script** printed the three expected lines on the stand-in, and `already applied` (exit 1) on a
     second run.
     - Run on a second stand-in rendered with a made-up Team ID, it printed `DEVELOPMENT_TEAM lines removed: 3`,
       and `grep -c` then found `0`.
     - Both results pass `plutil -lint`, and the three schemes pass `xmllint`.
   - **Task 9's `awk` filter** was run on sample `xcodebuild` output. It printed only `Runner`'s rows, and printed
     "is set" only for a non-empty Team ID.
   - **Task 10's two `sed` lines** read `3.47.9` from the stand-in `.fvmrc`, from one-line JSON, and from
     `flutter --version --machine`.
3. **The clean replay.** A script took every **File** and **Edit** block from this file, in task order, and applied
   them to a second clean worktree `./.scratch/s2-replay` with the same stand-in skeleton. Each Edit's first fence
   had to occur exactly once. It ran the script and committed each task through the hook; every commit printed
   `guards (staged): all passed`. `diff -r` of the two worktrees' files showed no difference, apart from `.git`, the
   session folders Claude Code keeps (`.claude/`), and an empty `xcshareddata/swiftpm/configuration` folder that a
   sandboxed `xcodebuild -list` attempt left in the first.

**Not replayed, and why:**
- **Task 0:** its proofs are run live, on the real settings.
- **Tasks 1, 9 and 11:** the owner's.
- **Task 2:** it needs the owner's skeleton and Part 3, Q1.
- **Every `fvm flutter analyze` and `fvm flutter test` run in Tasks 5 to 7, and mutations M-a to M-c:** Flutter
  can't analyze or test in the sandbox until Q1 is settled, and the packages need the owner's `pub get`. These are
  first run in the tasks themselves, and a failure there stops the task (R14).
- **Task 12's two placeholders** are filled when it runs.
