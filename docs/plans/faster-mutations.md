# Plan: a faster full app mutation run (faster-mutations)

Branch `faster-mutations`, from `main` at `cc2ea8c`. Investigation, spec and plan in one (docs/workflow.md steps 3, 5
and 6), under D91, D126 and the owner's leans D129. Written by Claude Code (Opus) on 2026-11-22. No implementation
here: this file is the only thing committed.

`redesign-c` is merged (`main` at `cc2ea8c`); its Status was not updated at the merge (Task 3 records it).

*No matter where you are on your journey, the steps you take are equally important.*

## Part 1 · Spec

### In plain words

`tool/app_mutations.py` runs every row one at a time, today about an hour for 624 rows. After this branch it runs
them in parallel by default. Each worker has its own copy of `app/` in `$TMPDIR`, so no row ever sees another row's
broken file, and the real `app/` is only read. Every row gets the same verdict the old runner gives it, by the same
check, the same test and the same name. The old way stays as `--serial`. A new script,
`tool/app_mutations_compare.py`, runs rows both ways and fails on any row whose verdict differs, including rows built
to survive. Measured on the owner's Mac: the full table in parallel took 409 s (under 7 minutes, 624 run, 624 caught), where the serial way took 3.1 s a row on the same Mac (about 33 minutes for 624 rows; the owner's last full run took about an hour). Task 4 measures both on the full table.

### What the investigation found (verified unless marked)

1. **A row does not run the whole suite.** It runs one named test of one file, twice:
   `fvm flutter test --no-pub <file> --plain-name <name>` in `app/` (`tool/app_mutations.py:2705-2708`). First the
   pattern check (the text found exactly once), then the test unbroken (it must pass), then broken (it must fail),
   then the file is put back byte for byte (`:2711-2727`). D129's premise ("each row runs the whole app suite") does
   not hold.
2. **Each name matches exactly one test.** The table has 624 rows, 428 distinct (test file, name) pairs, 48 test
   files and 56 broken files. A JSON report of the whole suite (`flutter test -r silent --file-reporter json:...`)
   matched every one of the 428 pairs to exactly one test.
3. **The hour is fixed cost, not test time.** One invocation takes 1.3 s (`journal_store_test.dart`) to 2.5 s (the
   page tests), cold or broken alike. Nearly all of it is starting the Flutter tool, compiling and starting the test
   process. The whole suite, 690 tests, takes 13 s with Flutter's own parallelism. The serial way measured 3.1 s a row
   here (two invocations), about 33 minutes for 624 rows; the owner's last full run took about an hour.
4. **`fvm` costs nothing worth saving** (1.34 s through `fvm`, 1.30 s through `app/.fvm/flutter_sdk/bin/flutter`). It
   stays.
5. **A copy of `app/` is cheap.** Without `build/` (1.2 GB) and `.dart_tool/flutter_build`, it is 3.3 MB. Its first
   run took 5.4 s (Flutter rebuilds its caches in the copy), then 2.0 s each. Switching test files between runs costs
   nothing extra (2.0 to 2.1 s either way).
6. **What the tests read from disk.** Inside `app/`: `lib/`, `ios/Runner/AppDelegate.swift`, `assets/fonts`,
   relative to the working folder (`test/recording/no_storage_test.dart`, `connection_test.dart`,
   `journal/pages/journal_home_test.dart`, `design/fonts_test.dart`). Outside it, only
   `../fixtures/invented-nights.json` (`test/fixtures.dart:26`, `test/fixtures_test.dart:11`). So each copy is
   `wK/app` with `wK/fixtures` beside it. 24 rows break `ios/Runner/AppDelegate.swift` and 9 break test files, so
   the copy takes all of `app/` but the caches.
7. **Load cannot fail a test that would pass.** The tests that look at real time check lower bounds only:
   `test/recording/retries_test.dart:582-587` (at least 280 ms) and `recording_test.dart:274-276` (at least 200 ms).
   Under load they can only pass more easily, which can hide a break (the safe way: a survivor) but never invent a
   catch. The three `runAsync` uses (`journal_page_test.dart:360`, `date_shade_test.dart:64` and `:217`) render
   images and time nothing.
8. **Flutter has `--fail-fast`** (`flutter test -h`), but with one test per name there is nothing after the first
   failure to skip.

### D129's leans, one by one

1. **Parallel rows, each worker in its own copy of `app/`:** built. Copies in `$TMPDIR`, one per worker, made at the
   start and removed at the end, whatever happens. Each copy makes its own Flutter caches.
2. **Only the tests that can reach the mutated file:** not built. Each row already runs fewer tests than that: one,
   the named test. Running every reaching test would be slower. Worse, a row could then be caught by a test other
   than its named one, so it would be reported caught where the old runner reports survived. That is exactly what
   the hard rule forbids. The equivalence proof holds a row for this case: E2 is A664's real break, caught by its own
   test, paired with a test that never reaches the file. It must survive both ways (Part 4, question 1).
3. **Fail fast:** not built, as there is nothing to stop early (finding 8). The broken run's command stays
   byte-identical to the serial one, which keeps the proof simple (Part 4, question 1).
4. **Added: one unbroken run per test and name.** The serial runner runs the unbroken test before every row, but the
   tree it runs on is the same each time, because every row puts its file back byte for byte. Running each of the
   428 pairs once unbroken, instead of 624 times, is therefore the same check. It saves 196 invocations.

### What the new runner does (`tool/app_mutations.py`)

- **Rows, verdicts, output and exit codes are unchanged.** The same `ROWS` table, the same four verdicts
  (`caught`, `SURVIVED`, `SETUP FAILED (pattern not found once)`, `SETUP FAILED (the test fails unbroken)`), the
  same summary line and exit codes 0, 1 and 2. `--rows` and `--files` work as before.
- **Parallel, the default:**
  1. The pattern check on the real `app/`, as before. A row that fails it runs nothing.
  2. One copy per worker, `$TMPDIR/app-mutations-XXXX/wK/app` and `wK/fixtures`: no more workers than rows to run.
  3. Each distinct test and name runs once unbroken, in whichever copy is free.
  4. Each row whose test passed runs broken, in whichever copy is free. Its file is put back byte for byte,
     whatever happens.
  5. The copies are removed. Then the verdicts are printed **in the table's order**, in the serial runner's format,
     so the outputs of both ways can be compared with `diff`.
- **`--jobs N`** (N from 1) sets the number of workers. The default is the Mac's cores less two, at most 8 (8 on the owner's 10-core Mac).
- **`--serial`:** the old runner, row by row in `app/` itself, unbroken run included. It takes no `--jobs`.
- **No new package:** `queue`, `shutil`, `tempfile` and `threading` from Python's standard library.

### The equivalence proof (`tool/app_mutations_compare.py`)

Run by hand: `python3 -I -B tool/app_mutations_compare.py [--all] [--jobs N]`.

- **What it runs.** The sample, or every row with `--all`. Each row runs both ways: serial first (in `app/` itself,
  exactly the old runner), then parallel.
- **When it fails.** It prints every row whose verdicts differ, and every built row that misses its verdict. Exit 1
  if any; else 0.
- **The sample:** every tenth row, every row that breaks a file in `ios/` or `test/`, A1, A13, A481 and A664
  (each must be caught), and eight built rows, each with the verdict it must get both ways:
  - **E1:** a comment changed in `journal_store.dart`. Must be SURVIVED.
  - **E2:** A664's real break of `disclosure_page.dart` (its own test catches it), paired with A1's test, which never
    reaches that file. Must be SURVIVED: only the named test counts.
  - **E3:** `disclosure_page.dart` made uncompilable, paired with A1's test. Must be SURVIVED.
  - **E4:** A13's break of `AppDelegate.swift`, paired with A1's test. Must be SURVIVED.
  - **E5:** A481's break of a test file, paired with A1's test. Must be SURVIVED.
  - **E6:** no such text. **E7:** the text found twice. Both must be SETUP FAILED (pattern not found once).
  - **E8:** no such test name. Must be SETUP FAILED (the test fails unbroken).
- **The proof here:** `serial 317 s, parallel 77 s, 8 jobs` and `app mutations compare: 101 rows, 101 the same`, exit 0. The eight built rows got their verdicts both ways, and A1, A13, A481 and A664 were caught both ways.
- **The proof for the owner:** `--all` at this branch's full run, before the merge (D126; Task 4).

### Decided under D91 (how to build only)

1. Copies in `$TMPDIR` through `tempfile.mkdtemp`, not `.scratch/`: removed at the end, never inside the repository.
2. Verdicts printed at the end, in the table's order, not as rows finish: the output is the serial runner's, line for
   line.
3. Threads, not processes. Each worker waits on its own `flutter test`, so Python's lock does not slow it. An error
   in any worker stops every worker, the copies are removed and the error is raised.
4. The broken run's command is the serial one, unchanged: no `--fail-fast`, no reporter flag.
5. The runner's new tests and the comparison's tests go in `tool/checks/tests/test_app_mutations.py`, beside the old
   ones, so `check_all.sh` runs them. That file is in `tool/checks/`, so the owner applies it (D60; Task 1).
6. The comparison script is committed (`tool/`, not `tool/checks/`), run by hand like the runner. `check_all.sh` calls
   neither (D55).

### What it does not build

- Nothing in `app/`, `server/`, `.claude/`, `.githooks/`, `CLAUDE.md` or `check_all.sh`. No storage change, no
  words, no new package.
- No change to `tool/server_mutations.py` (30 rows, fast enough).
- No standing mutation rows for the runner itself: `tool/checks/tests/mutations.py` breaks `tool/checks/` only. The
  runner's tests are proven by hand mutation (Part 5), as `app_mutations.py`'s own tests were in journal-core
  (banked as item 165).

## Part 2 · Settings, packages and storage

None. No package, app or server. No settings. No storage. One file in `tool/checks/` changes, the runner's tests,
applied by the owner (D60).

## Part 3 · The tasks

**How the blocks work.** Each task's code is one patch, generated from the build that proved it (Part 5). Apply it
from the repository root:

```
git apply --whitespace=nowarn <<'PATCH'
...the block...
PATCH
```

`git apply` refuses if any line differs, which is the stop R14 asks for. Then run the task's checks and commit through
the hook with the message given. Task 1's block is the owner's (D60), and is also written to
`.scratch/for-build-chat/faster-mutations-task1.patch`, sha256 `63995823546e678ae59af6d0dbb030f793747de251bdefbd2e47f913afc0865f`, so it need not be pasted by hand.

### Task 0 · Baselines

```
git status --short && git log --oneline -1 && python3 -I -B tool/checks/guards.py | tail -1 && python3 -I -B tool/checks/tests/run_tests.py 2>&1 | tail -1
```

Expected: nothing changed, `cc2ea8c` or this plan's commit, `guards: all passed`, `OK` (255 guard tests: `Ran 255
tests`). Any other result: stop (R14).

**Timing before** (the owner's, at his next full run; the old way):
`cd ~/Developer/soul-dreams-app && time python3 -I -B tool/app_mutations.py`. Expected
`app mutations: 624 run, 624 caught`, between half an hour and an hour (`real`).

### Task 1 · [OWNER] The runner's tests (D60)

The test-first step. It adds 19 tests to `tool/checks/tests/test_app_mutations.py`: 13 for the parallel runner
(`Parallel`) and 6 for the comparison (`Compare`). Claude Code stops here and gives the owner:

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app && shasum -a 256 .scratch/for-build-chat/faster-mutations-task1.patch && git apply --whitespace=nowarn .scratch/for-build-chat/faster-mutations-task1.patch && python3 -I -B tool/checks/tests/run_tests.py 2>&1 | tail -3
```

Expected: the hash `63995823546e678ae59af6d0dbb030f793747de251bdefbd2e47f913afc0865f`, then `Ran 274 tests` and `FAILED (failures=10, errors=8)`. Against the old runner,
12 of the 13 `Parallel` tests fail and all 6 `Compare` tests fail to import. The one that passes,
`test_bad_jobs_or_serial_arguments_run_nothing_and_fail`, already passes because the old runner refuses those
arguments too: it holds the new parsing. A different hash or count: stop.

The owner commits it: `git add tool/checks/tests/test_app_mutations.py && git commit -m "The parallel runner's tests,
failing until Task 2 (D129, test first); the owner's (D60)"`. The hook runs the guards only, so the failing tests do
not stop the commit.

```diff
diff --git a/tool/checks/tests/test_app_mutations.py b/tool/checks/tests/test_app_mutations.py
index b2ac626..08691c2 100644
--- a/tool/checks/tests/test_app_mutations.py
+++ b/tool/checks/tests/test_app_mutations.py
@@ -145,5 +145,266 @@ class AppMutationsSelected(StandIn):
         self.assertEqual(code, 1)
 
 
+
+# D129: parallel by default, each worker in its own copy of app/; the
+# old way behind --serial. The stand-in fvm here also writes one line
+# per run to $RUNS: the folder it ran in, then "broken" or "unbroken".
+LOGGING_FVM = '\n'.join([
+    '#!/bin/sh',
+    'if grep -q new lib/a.dart lib/b.dart 2>/dev/null; then',
+    '  echo "$PWD broken" >> "$RUNS"',
+    '  if [ -n "${SLOW_A:-}" ] && grep -q new lib/a.dart; then',
+    '    sleep 0.5',
+    '  fi',
+    '  [ -n "${TOLERANT:-}" ] && exit 0',
+    '  exit 1',
+    'fi',
+    'echo "$PWD unbroken" >> "$RUNS"',
+    '[ -e build ] && echo "$PWD has-build" >> "$RUNS"',
+    '[ -e .dart_tool/flutter_build ] && echo "$PWD has-flutter-build" >> "$RUNS"',
+    '[ -e .dart_tool/package_config.json ] || exit 1',
+    'if [ -n "${NEED_FIXTURES:-}" ]; then',
+    '  [ -f ../fixtures/n.json ] || exit 1',
+    'fi',
+    'exit 0',
+    '',
+])
+
+
+class Parallel(unittest.TestCase):
+    def setUp(self):
+        # top/app and top/fixtures, as in the repository; temporary
+        # folders go under top/tmp, so the copies can be counted.
+        self.top = os.path.realpath(tempfile.mkdtemp(prefix='app-top-'))
+        self.addCleanup(shutil.rmtree, self.top)
+        self.app = os.path.join(self.top, 'app')
+        for folder in ('lib', 'test', 'build', os.path.join('.dart_tool', 'flutter_build')):
+            os.makedirs(os.path.join(self.app, folder))
+        with open(os.path.join(self.app, '.dart_tool', 'package_config.json'), 'w') as f:
+            f.write('{}')
+        for name in ('a.dart', 'b.dart'):
+            with open(os.path.join(self.app, 'lib', name), 'wb') as f:
+                f.write(ORIGINAL)
+        os.makedirs(os.path.join(self.top, 'fixtures'))
+        with open(os.path.join(self.top, 'fixtures', 'n.json'), 'w') as f:
+            f.write('{}')
+        self.tmp = os.path.join(self.top, 'tmp')
+        os.makedirs(self.tmp)
+        self.addCleanup(setattr, tempfile, 'tempdir', tempfile.tempdir)
+        tempfile.tempdir = self.tmp
+        bin_dir = os.path.join(self.top, 'bin')
+        os.makedirs(bin_dir)
+        fvm = os.path.join(bin_dir, 'fvm')
+        with open(fvm, 'w', encoding='utf-8') as f:
+            f.write(LOGGING_FVM)
+        os.chmod(fvm, 0o755)
+        self.runs = os.path.join(self.top, 'runs')
+        saved = dict(os.environ)
+        self.addCleanup(lambda: (os.environ.clear(), os.environ.update(saved)))
+        os.environ['PATH'] = bin_dir + os.pathsep + os.environ.get('PATH', '')
+        os.environ['RUNS'] = self.runs
+        for name in ('TOLERANT', 'SLOW_A', 'NEED_FIXTURES'):
+            os.environ.pop(name, None)
+        rows = [('X1', 'lib/a.dart', 'old', 'new', 'test/a_test.dart', 'named'),
+                ('X2', 'lib/b.dart', 'old', 'new', 'test/b_test.dart', 'named'),
+                ('X3', 'lib/a.dart', 'kept', 'new', 'test/a_test.dart', 'named')]
+        for name, value in (('APP', self.app), ('ROWS', rows)):
+            self.addCleanup(setattr, app_mutations, name, getattr(app_mutations, name))
+            setattr(app_mutations, name, value)
+
+    def main(self, *argv):
+        out = io.StringIO()
+        with contextlib.redirect_stdout(out):
+            code = app_mutations.main(list(argv))
+        for name in ('a.dart', 'b.dart'):
+            with open(os.path.join(self.app, 'lib', name), 'rb') as f:
+                self.assertEqual(f.read(), ORIGINAL)
+        return code, out.getvalue().splitlines()
+
+    def logged(self):
+        if not os.path.exists(self.runs):
+            return []
+        with open(self.runs, encoding='utf-8') as f:
+            return [line.rsplit(' ', 1) for line in f.read().splitlines()]
+
+    def test_parallel_runs_only_in_copies_and_removes_them(self):
+        code, lines = self.main('--jobs', '2')
+        self.assertEqual(lines, ['X1: caught', 'X2: caught', 'X3: caught',
+                                 'app mutations: 3 run, 3 caught'])
+        self.assertEqual(code, 0)
+        folders = {folder for folder, _ in self.logged()}
+        self.assertTrue(folders)
+        self.assertNotIn(self.app, folders)
+        for folder in folders:
+            self.assertTrue(folder.startswith(self.tmp + os.sep), folder)
+            self.assertEqual(os.path.basename(folder), 'app')
+        self.assertEqual(os.listdir(self.tmp), [])
+
+    def test_serial_runs_in_app_itself_as_before(self):
+        code, lines = self.main('--serial')
+        self.assertEqual(lines, ['X1: caught', 'X2: caught', 'X3: caught',
+                                 'app mutations: 3 run, 3 caught'])
+        self.assertEqual(code, 0)
+        self.assertEqual({folder for folder, _ in self.logged()}, {self.app})
+        self.assertEqual([kind for _, kind in self.logged()].count('unbroken'), 3)
+
+    def test_each_test_and_name_runs_unbroken_once(self):
+        self.main('--jobs', '3')
+        kinds = [kind for _, kind in self.logged()]
+        self.assertEqual(sorted(kinds), ['broken'] * 3 + ['unbroken'] * 2)
+
+    def test_jobs_sets_the_number_of_copies(self):
+        for jobs, most in (('1', 1), ('2', 2)):
+            if os.path.exists(self.runs):
+                os.remove(self.runs)
+            self.main('--jobs', jobs)
+            folders = {folder for folder, _ in self.logged()}
+            self.assertLessEqual(len(folders), most, jobs)
+            self.assertGreaterEqual(len(folders), 1)
+
+    def test_no_more_copies_than_rows_to_run(self):
+        made = []
+        real = app_mutations.copy_app
+        self.addCleanup(setattr, app_mutations, 'copy_app', real)
+        app_mutations.copy_app = lambda root, k: made.append(k) or real(root, k)
+        self.main('--rows', 'X2', '--jobs', '4')
+        self.assertEqual(made, [0])
+
+    def test_caches_are_not_copied_and_fixtures_are(self):
+        os.environ['NEED_FIXTURES'] = '1'
+        code, lines = self.main('--jobs', '2')
+        self.assertEqual(lines[-1], 'app mutations: 3 run, 3 caught')
+        kinds = {kind for _, kind in self.logged()}
+        self.assertNotIn('has-build', kinds)
+        self.assertNotIn('has-flutter-build', kinds)
+
+    def test_verdicts_come_in_the_rows_order(self):
+        # X1 and X3 are slow and caught; X2 changes nothing, so it
+        # survives, and finishes first.
+        os.environ['SLOW_A'] = '1'
+        rows = [('X1', 'lib/a.dart', 'old', 'new', 'test/a_test.dart', 'named'),
+                ('X2', 'lib/b.dart', 'kept', 'kept', 'test/b_test.dart', 'named'),
+                ('X3', 'lib/a.dart', 'kept', 'new', 'test/a_test.dart', 'named')]
+        setattr(app_mutations, 'ROWS', rows)
+        code, lines = self.main('--jobs', '3')
+        self.assertEqual(lines, ['X1: caught', 'X2: SURVIVED', 'X3: caught',
+                                 'app mutations: 3 run, 2 caught'])
+
+    def test_a_survivor_is_a_survivor_in_both_ways(self):
+        os.environ['TOLERANT'] = '1'
+        for argv in (('--serial',), ('--jobs', '2')):
+            code, lines = self.main(*argv)
+            self.assertEqual(lines, ['X1: SURVIVED', 'X2: SURVIVED', 'X3: SURVIVED',
+                                     'app mutations: 3 run, 0 caught'], argv)
+            self.assertEqual(code, 1)
+
+    def test_a_missing_pattern_runs_nothing_in_both_ways(self):
+        rows = [('X4', 'lib/a.dart', 'absent', 'new', 'test/a_test.dart', 'named')]
+        setattr(app_mutations, 'ROWS', rows)
+        for argv in (('--serial',), ()):
+            code, lines = self.main(*argv)
+            self.assertEqual(lines, ['X4: SETUP FAILED (pattern not found once)',
+                                     'app mutations: 1 run, 0 caught'], argv)
+            self.assertEqual(code, 1)
+        self.assertEqual(self.logged(), [])
+
+    def test_each_row_puts_its_copy_back(self):
+        # X6 changes nothing, so it survives, unless X1's break is
+        # still in the one copy when X6 runs there.
+        rows = [('X1', 'lib/a.dart', 'old', 'new', 'test/a_test.dart', 'named'),
+                ('X6', 'lib/b.dart', 'kept', 'kept', 'test/b_test.dart', 'named')]
+        setattr(app_mutations, 'ROWS', rows)
+        code, lines = self.main('--jobs', '1')
+        self.assertEqual(lines, ['X1: caught', 'X6: SURVIVED', 'app mutations: 2 run, 1 caught'])
+
+    def test_the_copies_go_when_a_run_fails(self):
+        def broken_run(test, name, app=None):
+            raise OSError('stand-in')
+        self.addCleanup(setattr, app_mutations, 'run', app_mutations.run)
+        app_mutations.run = broken_run
+        with self.assertRaises(OSError):
+            self.main('--jobs', '2')
+        self.assertEqual(os.listdir(self.tmp), [])
+
+    def test_bad_jobs_or_serial_arguments_run_nothing_and_fail(self):
+        for argv in (('--jobs', '0'), ('--jobs', 'x'), ('--jobs',), ('--jobs', '2', '--jobs', '3'),
+                     ('--serial', '--jobs', '2'), ('--serial', '--serial'), ('--jobs', '-1')):
+            code, lines = self.main(*argv)
+            self.assertEqual(lines, ['app mutations: bad arguments'], argv)
+            self.assertEqual(code, 2)
+        self.assertEqual(self.logged(), [])
+
+    def test_default_jobs_leaves_two_cores_and_stops_at_eight(self):
+        self.addCleanup(setattr, os, 'cpu_count', os.cpu_count)
+        for cores, jobs in ((10, 8), (12, 8), (6, 4), (2, 1), (1, 1), (None, 1)):
+            os.cpu_count = lambda: cores
+            self.assertEqual(app_mutations.default_jobs(), jobs, cores)
+
+
+
+# The equivalence proof (D129), with both ways stood in: it passes only
+# when every row is the same both ways and the built rows get their
+# verdicts.
+class Compare(unittest.TestCase):
+    def setUp(self):
+        import app_mutations_compare
+        self.compare = app_mutations_compare
+        self.expected = {r[0]: v for r, v in self.compare.OWN + self.compare.BUILT}
+        for name in ('run_row', 'run_parallel'):
+            self.addCleanup(setattr, app_mutations, name, getattr(app_mutations, name))
+        self.serial = lambda *row: self.expected.get(row[0], 'caught')
+        app_mutations.run_row = lambda *row: self.serial(*row)
+        app_mutations.run_parallel = lambda rows, jobs: [self.serial(*r) for r in rows]
+
+    def main(self, *argv):
+        out = io.StringIO()
+        with contextlib.redirect_stdout(out):
+            code = self.compare.main(list(argv))
+        return code, out.getvalue().splitlines()
+
+    def test_the_same_both_ways_passes(self):
+        code, lines = self.main('--jobs', '2')
+        rows = len(self.compare.sample(False))
+        self.assertEqual(lines[-1], 'app mutations compare: %d rows, %d the same' % (rows, rows))
+        self.assertEqual(code, 0)
+
+    def test_the_sample_holds_the_built_rows_and_every_tenth(self):
+        codes = [r[0] for r in self.compare.sample(False)]
+        for r, _ in self.compare.OWN + self.compare.BUILT:
+            self.assertIn(r[0], codes)
+        for r in app_mutations.ROWS[::10]:
+            self.assertIn(r[0], codes)
+        every = self.compare.sample(True)
+        self.assertEqual(len(every), len(app_mutations.ROWS) + len(self.compare.BUILT))
+
+    def test_a_row_caught_only_in_parallel_fails(self):
+        serial = self.serial
+        app_mutations.run_parallel = lambda rows, jobs: [
+            'caught' if r[0] == 'E2' else serial(*r) for r in rows]
+        code, lines = self.main()
+        self.assertIn('E2: serial SURVIVED, parallel caught, expected SURVIVED', lines)
+        self.assertEqual(code, 1)
+
+    def test_a_real_row_that_differs_fails(self):
+        serial = self.serial
+        app_mutations.run_parallel = lambda rows, jobs: [
+            'SURVIVED' if r[0] == 'A11' else serial(*r) for r in rows]
+        code, lines = self.main()
+        self.assertIn('A11: serial caught, parallel SURVIVED, expected the same', lines)
+        self.assertEqual(code, 1)
+
+    def test_a_built_row_that_misses_its_verdict_both_ways_fails(self):
+        self.expected['E1'] = 'caught'
+        code, lines = self.main()
+        self.assertIn('E1: serial caught, parallel caught, expected SURVIVED', lines)
+        self.assertEqual(code, 1)
+
+    def test_bad_arguments_run_nothing_and_fail(self):
+        for argv in (('--jobs',), ('--jobs', '0'), ('--rows', 'A1'), ('--jobs', '2', '--jobs', '3')):
+            code, lines = self.main(*argv)
+            self.assertEqual(lines, ['app mutations compare: bad arguments'], argv)
+            self.assertEqual(code, 2)
+
+
 if __name__ == '__main__':
     unittest.main()
```

### Task 2 · The parallel runner and the comparison (D129)

Claude Code applies the block, then:

```
python3 -I -B tool/checks/tests/run_tests.py 2>&1 | tail -1 && python3 -I -B tool/checks/guards.py | tail -1 && python3 -I -B tool/app_mutations.py --rows A1,A13,A481,A664 && python3 -I -B tool/app_mutations.py --serial --rows A1,A13,A481,A664
```

Expected: `OK` (274 tests), `guards: all passed`, then twice `A1: caught` … `app mutations: 4 run, 4 caught`.

Then the hand mutation proof (Part 5, item 3), M1 to M14 and C1 to C6, each caught. A survivor is a weak test:
strengthen it (D91), never weaken it. Then the sample, timed:

```
time python3 -I -B tool/app_mutations_compare.py
```

Expected: `app mutations compare: 101 rows, 101 the same`, exit 0, with its two times. Any row listed: stop (R14).

Commit: `The full app mutation run in parallel, each worker in its own copy of app/; --serial keeps the old way; the
equivalence script (D129)`.

```diff
diff --git a/tool/app_mutations.py b/tool/app_mutations.py
index 3cebacb..b7e3303 100644
--- a/tool/app_mutations.py
+++ b/tool/app_mutations.py
@@ -1,20 +1,27 @@
 # The app's mutation checks (D49 c), run by hand from the repository
 # root: python3 -I -B tool/app_mutations.py
 # During a task, only chosen rows (D95): --rows A1,A7 or --files lib/a.dart,lib/b.dart
+# Parallel by default (D129), each worker in its own copy of app/ in
+# $TMPDIR: --jobs N sets the workers; --serial runs as before D129.
 # Expected: every row "caught" (A1 to A664, A610 dropped (an equivalent change: a row's least height is the pill's own 44 and its padding), A518, A521, A540, A553, A554, A558, A574, A575, A583, A585 to A600, A629, A635, A645 and A646 dropped (redesign-c, D128: there is no withdrawing, no consent row or readings page, no idle wait; D127's pill inside is gone), A288, A291, A537, A538, A539, A543, A546, A623, A624, A626, A627, A633 and A634 dropped (redesign-c, D127: the consents left onboarding and its full page, "I don't agree" no longer goes back, Next is gone), A301, A302, A526, A527, A530, A541, A549, A550, A566 and A578 dropped (redesign-c, D125: the first empty journal's pointer and arrow, the night images consent and the gear's spacing are gone), A277, A278, A281, A300 and A507 dropped (redesign-c, D121 item 5,
 # D122: withdrawing no longer removes the consent or returns to the start, so its rows went; the journal's deletion
 # takes the audio, so A300's retry cannot follow, and A518 holds the cut on a withdrawal; A544 holds A507's
 # answers), A363 dropped (redesign-b, D119: the owed handles are filed, owed.dart is gone), A24ah, A24ar, A24as, A252 to A255 and A270 dropped (redesign-a, D110: naming, the record button, the row's summary and chevron are gone, and the night's page no longer stands under BelowTapBox, which A271 still covers), A375 dropped (D112: New Dream stands on a night sky, not the painted gradient; A408 holds it), A313 dropped (c17p-import: every part shown is filed, so an empty `missing` is the real one; back when a part loses its line), A207 and A223 dropped (D97), A213 dropped (the kick's offline check went; the loop's is A219), A55 dropped (D74.3), A73, A83 and A142 dropped (D88), A80 and A81 dropped (Task 16e), A86 to A88 and A99 dropped (D87), A94 dropped (D86), A82 and A128 to A130 dropped (D90), with the rows A24a to A24au of
 # the later rulings and the final review among them), then "app
-# mutations: 624 run, 624 caught", exit 0. Each row breaks one thing in app/, in place, runs the
+# mutations: 624 run, 624 caught", exit 0. Each row breaks one thing in app/ (with --serial, in
+# place; else in a worker's copy), runs the
 # named test with the pinned Flutter (fvm), which must pass unbroken
 # and fail broken, and puts the file back byte for byte, whatever
 # happens. check_all.sh does not call it. It reports row codes only,
 # through the checks' own writer. Exit 0 when every row is caught, 1
 # otherwise.
 import os
+import queue
+import shutil
 import subprocess
 import sys
+import tempfile
+import threading
 
 TOOL = os.path.dirname(os.path.abspath(__file__))
 sys.path.insert(0, os.path.join(TOOL, 'checks'))
@@ -2702,65 +2709,192 @@ ROWS = [
 ]
 
 
-def run(test, name):
+def run(test, name, app=None):
     r = subprocess.run(['fvm', 'flutter', 'test', '--no-pub', test, '--plain-name', name],
-                       cwd=APP, capture_output=True)
+                       cwd=app or APP, capture_output=True)
     return r.returncode
 
 
-def run_row(code, path, old, new, test, name):
-    full = os.path.join(APP, path)
+PATTERN = 'SETUP FAILED (pattern not found once)'
+UNBROKEN = 'SETUP FAILED (the test fails unbroken)'
+
+
+# Breaks the file in `app`, runs the test, and puts the file back byte
+# for byte, whatever happens. True when the broken test fails.
+def run_broken(app, path, old, new, test, name):
+    full = os.path.join(app, path)
     with open(full, 'rb') as f:
         original = f.read()
-    text = original.decode('utf-8')
-    if text.count(old) != 1:
-        return 'SETUP FAILED (pattern not found once)'
-    if run(test, name) != 0:
-        return 'SETUP FAILED (the test fails unbroken)'
     try:
         with open(full, 'wb') as f:
-            f.write(text.replace(old, new).encode('utf-8'))
-        caught = run(test, name) != 0
+            f.write(original.decode('utf-8').replace(old, new).encode('utf-8'))
+        return run(test, name, app) != 0
     finally:
         with open(full, 'wb') as f:
             f.write(original)
-    return 'caught' if caught else 'SURVIVED'
 
 
-# The rows to run, in order, or None for bad arguments (D95). No argument:
-# every row. `--rows A1,A7` names rows by code; `--files lib/a.dart,lib/b.dart`
-# takes every row that breaks one of those files (a path may start with
-# `app/`). Both together: the rows either asks for.
+def found_once(app, path, old):
+    with open(os.path.join(app, path), 'rb') as f:
+        return f.read().decode('utf-8').count(old) == 1
+
+
+# --serial: one row at a time in app/ itself, as before D129.
+def run_row(code, path, old, new, test, name):
+    if not found_once(APP, path, old):
+        return PATTERN
+    if run(test, name) != 0:
+        return UNBROKEN
+    return 'caught' if run_broken(APP, path, old, new, test, name) else 'SURVIVED'
+
+
+# Not copied: Flutter's caches (each copy makes its own) and the
+# editors' folders.
+SKIP = {'build', '.claude', '.idea', os.path.join('.dart_tool', 'flutter_build')}
+
+
+# A worker's copy: root/wK/app, with root/wK/fixtures beside it, as
+# the tests read ../fixtures/invented-nights.json.
+def copy_app(root, k):
+    top = os.path.join(root, 'w%d' % k)
+
+    def skip(folder, names):
+        here = os.path.relpath(folder, APP)
+        return [n for n in names if os.path.normpath(os.path.join(here, n)) in SKIP]
+
+    shutil.copytree(APP, os.path.join(top, 'app'), symlinks=True, ignore=skip)
+    fixtures = os.path.join(os.path.dirname(APP), 'fixtures')
+    if os.path.isdir(fixtures):
+        shutil.copytree(fixtures, os.path.join(top, 'fixtures'), symlinks=True)
+    return os.path.join(top, 'app')
+
+
+# Each worker owns one copy and takes the next item until none is left.
+# The results come back in the items' order; an error in any worker
+# stops every worker and is raised here.
+def pool(copies, items, work):
+    results = [None] * len(items)
+    todo = queue.Queue()
+    for i in range(len(items)):
+        todo.put(i)
+    errors = []
+    stop = threading.Event()
+
+    def worker(app):
+        while not stop.is_set():
+            try:
+                i = todo.get_nowait()
+            except queue.Empty:
+                return
+            try:
+                results[i] = work(app, items[i])
+            except BaseException as e:  # noqa: B036 (raised again below)
+                errors.append(e)
+                stop.set()
+
+    threads = [threading.Thread(target=worker, args=(app,), daemon=True) for app in copies]
+    for t in threads:
+        t.start()
+    try:
+        for t in threads:
+            t.join()
+    finally:
+        stop.set()
+    if errors:
+        raise errors[0]
+    return results
+
+
+# Parallel (D129), the default: the serial verdicts, faster. The same
+# pattern check, on app/; then each test and name runs once unbroken
+# (nothing in a copy changes between rows, as every row puts its file
+# back), and each row whose test passes runs broken in one copy. The
+# real app/ is only read; the copies go at the end, whatever happens.
+def run_parallel(rows, jobs):
+    results = [PATTERN] * len(rows)
+    ready = [i for i, row in enumerate(rows) if found_once(APP, row[1], row[2])]
+    if not ready:
+        return results
+    root = tempfile.mkdtemp(prefix='app-mutations-')
+    try:
+        copies = [copy_app(root, k) for k in range(min(jobs, len(ready)))]
+        pairs = sorted({(rows[i][4], rows[i][5]) for i in ready})
+        passing = pool(copies, pairs, lambda app, pair: run(pair[0], pair[1], app) == 0)
+        passes = dict(zip(pairs, passing))
+        breaking = [i for i in ready if passes[(rows[i][4], rows[i][5])]]
+        caught = pool(copies, breaking, lambda app, i: run_broken(app, *rows[i][1:]))
+    finally:
+        shutil.rmtree(root, ignore_errors=True)
+    for i in ready:
+        results[i] = UNBROKEN
+    for i, c in zip(breaking, caught):
+        results[i] = 'caught' if c else 'SURVIVED'
+    return results
+
+
+# Two fewer than the Mac's cores, at most JOBS_MAX (D129); --jobs N
+# overrides it.
+JOBS_MAX = 8
+
+
+def default_jobs():
+    return max(1, min(JOBS_MAX, (os.cpu_count() or 1) - 2))
+
+
+# The rows to run, in order, and how, or None for bad arguments (D95,
+# D129). No row argument: every row. `--rows A1,A7` names rows by code;
+# `--files lib/a.dart,lib/b.dart` takes every row that breaks one of
+# those files (a path may start with `app/`). Both together: the rows
+# either asks for. `--jobs N` (N from 1) sets the workers; `--serial`
+# runs as before D129, and takes no --jobs.
 def select(argv):
-    codes, files = None, None
+    codes, files, jobs, serial = None, None, None, False
     i = 0
     while i < len(argv):
         flag = argv[i]
-        if flag not in ('--rows', '--files') or i + 1 >= len(argv) or not argv[i + 1]:
+        if flag == '--serial' and not serial:
+            serial = True
+            i += 1
+            continue
+        if flag not in ('--rows', '--files', '--jobs') or i + 1 >= len(argv) or not argv[i + 1]:
             return None
         values = argv[i + 1].split(',')
         if flag == '--rows':
             codes = (codes or []) + values
-        else:
+        elif flag == '--files':
             files = (files or []) + [v[4:] if v.startswith('app/') else v for v in values]
+        elif jobs is not None or not argv[i + 1].isdigit() or int(argv[i + 1]) < 1:
+            return None
+        else:
+            jobs = int(argv[i + 1])
         i += 2
-    if codes is None and files is None:
-        return list(ROWS)
+    if serial and jobs is not None:
+        return None
     if codes is not None and not set(codes) <= {row[0] for row in ROWS}:
         return None
-    return [row for row in ROWS if row[0] in (codes or []) or row[1] in (files or [])]
+    if codes is None and files is None:
+        rows = list(ROWS)
+    else:
+        rows = [row for row in ROWS if row[0] in (codes or []) or row[1] in (files or [])]
+    return rows, serial, jobs or default_jobs()
 
 
 def main(argv=()):
-    rows = select(list(argv))
-    if rows is None:
+    chosen = select(list(argv))
+    if chosen is None:
         report('app mutations: bad arguments')
         return 2
-    caught = 0
-    for row in rows:
-        result = run_row(*row)
-        caught += result == 'caught'
-        report('%s: %s' % (row[0], result))
+    rows, serial, jobs = chosen
+    if serial:
+        results = []
+        for row in rows:
+            results.append(run_row(*row))
+            report('%s: %s' % (row[0], results[-1]))
+    else:
+        results = run_parallel(rows, jobs)
+        for row, result in zip(rows, results):
+            report('%s: %s' % (row[0], result))
+    caught = results.count('caught')
     report('app mutations: %d run, %d caught' % (len(rows), caught))
     return 0 if caught == len(rows) else 1
 
diff --git a/tool/app_mutations_compare.py b/tool/app_mutations_compare.py
new file mode 100644
index 0000000..cfac9f3
--- /dev/null
+++ b/tool/app_mutations_compare.py
@@ -0,0 +1,87 @@
+# The equivalence proof of D129, run by hand from the repository root:
+# python3 -I -B tool/app_mutations_compare.py [--all] [--jobs N]
+# Runs rows both ways, --serial (one at a time in app/ itself, as before
+# D129) and parallel (each worker in its own copy), and compares every
+# row's verdict. The sample: every tenth row, every row that breaks a
+# file in ios/ or test/, and the rows below, built to survive or to fail
+# their setup, each with the verdict it must get both ways. --all: every
+# row, then the rows below. It prints each row that differs or misses
+# its verdict, then the totals and each way's seconds. Exit 0 when every
+# row is the same both ways and every verdict below is met, 1 otherwise.
+import os
+import sys
+import time
+
+TOOL = os.path.dirname(os.path.abspath(__file__))
+sys.path.insert(0, TOOL)
+
+import app_mutations as m  # noqa: E402
+from app_mutations import PATTERN, UNBROKEN, report  # noqa: E402
+
+
+def row(code):
+    return next(r for r in m.ROWS if r[0] == code)
+
+
+# A1's test reads the journal's store and nothing below.
+STORE = ('test/journal/journal_store_test.dart', 'deleting a night leaves nothing of it anywhere')
+
+# (row, the verdict it must get both ways)
+OWN = [(row(code), 'caught') for code in ('A1', 'A13', 'A481', 'A664')]
+BUILT = [
+    # A comment changed: nothing can fail.
+    (('E1', 'lib/journal/journal_store.dart', '// The journal on the phone',
+      '// The journal, on the phone') + STORE, 'SURVIVED'),
+    # A real break, caught by its own test (A664) but not by this one,
+    # which never reaches the file: only the named test counts.
+    (('E2',) + row('A664')[1:4] + STORE, 'SURVIVED'),
+    # A file that no longer compiles, which this test never imports.
+    (('E3', row('A664')[1], row('A664')[2], '((((\n') + STORE, 'SURVIVED'),
+    # The Swift file and a test file, broken as A13 and A481 break them.
+    (('E4',) + row('A13')[1:4] + STORE, 'SURVIVED'),
+    (('E5',) + row('A481')[1:4] + STORE, 'SURVIVED'),
+    # The setup failures: no such text, the text twice, no such test.
+    (('E6', 'lib/journal/journal_store.dart', 'no such text', 'x') + STORE, PATTERN),
+    (('E7', 'lib/journal/journal_store.dart', "import '", "import  '") + STORE, PATTERN),
+    (('E8', 'lib/journal/journal_store.dart', '// The journal on the phone', '// x',
+      STORE[0], 'no test has this name'), UNBROKEN),
+]
+
+
+def sample(every):
+    chosen = {r[0] for r, _ in OWN}
+    rows = [r for i, r in enumerate(m.ROWS)
+            if every or i % 10 == 0 or r[1].split('/')[0] in ('ios', 'test') or r[0] in chosen]
+    return rows + [r for r, _ in BUILT]
+
+
+def main(argv=()):
+    argv = list(argv)
+    every = '--all' in argv
+    rest = [a for a in argv if a != '--all']
+    if rest and not (len(rest) == 2 and rest[0] == '--jobs' and rest[1].isdigit()
+                     and int(rest[1]) >= 1):
+        report('app mutations compare: bad arguments')
+        return 2
+    jobs = int(rest[1]) if rest else m.default_jobs()
+    rows = sample(every)
+    expected = {r[0]: v for r, v in OWN + BUILT}
+    start = time.monotonic()
+    serial = [m.run_row(*r) for r in rows]
+    middle = time.monotonic()
+    parallel = m.run_parallel(rows, jobs)
+    end = time.monotonic()
+    same = 0
+    for r, s, p in zip(rows, serial, parallel):
+        want = expected.get(r[0])
+        if s == p and want in (None, s):
+            same += 1
+        else:
+            report('%s: serial %s, parallel %s, expected %s' % (r[0], s, p, want or 'the same'))
+    report('serial %d s, parallel %d s, %d jobs' % (middle - start, end - middle, jobs))
+    report('app mutations compare: %d rows, %d the same' % (len(rows), same))
+    return 0 if same == len(rows) else 1
+
+
+if __name__ == '__main__':
+    sys.exit(main(sys.argv[1:]))
```

### Task 3 · Docs: Status.md

Status.md:
- **The "Last updated" line and "Current branch":** `faster-mutations`. Also record that `redesign-c` was merged at
  `cc2ea8c` without a Status update.
- **The app's mutation paragraph** (now lines 305 to 312):
  - The full run is `python3 -I -B tool/app_mutations.py`, parallel, the Mac's cores less two, at most 8 (8 on the owner's 10-core Mac), `--jobs N` to change it.
  - `--serial` is the old way.
  - `tool/app_mutations_compare.py` is the equivalence proof: the sample by default, `--all` for every row.
  - The times measured: before and after.
- **D129, one line under the rulings:** the leans, and that (2) and (3) are not built (Part 1), with the owner's
  answer to Part 4.
- **Banked:** item 165, the runner has no standing mutation rows.

Commit: `Status.md: the parallel mutation runner and its proof (D129)`.

### Task 4 · [OWNER] The full proof and the times, at the branch's full run (D126)

Paste 1 — Terminal

```
cd ~/Developer/soul-dreams-app && time python3 -I -B tool/app_mutations_compare.py --all
```

Expected: about 40 minutes (serial about 33, parallel about 7, as measured in the sandbox). It prints `app mutations compare: 632 rows, 632 the same`, then each way's seconds
(`serial … s, parallel … s, N jobs`), exit 0. Those two numbers are the before and after times for Status.md. Any
row listed above the totals: stop and bring the lines to the Build chat.

Afterwards, the runner's normal full run: `time python3 -I -B tool/app_mutations.py`. Expected
`app mutations: 624 run, 624 caught`.

## Part 4 · Questions (numbered; a blank is not a yes)

1. **D129's leans (2) and (3) are not built.**
   - **Why:** a row already runs only its one named test, so there is nothing narrower to run, and nothing to stop
     early. Lean (2) as written would let other tests catch a row, against the hard rule.
   - **Lean:** confirm both dropped.
   - **If not:** a different measure of a row, which is a ruling on what "caught" means, not a speed change.
2. **The default worker count:** the Mac's cores less two, at most 8 (8 on the owner's 10-core Mac).
   - **Measured:** the 101-row sample in parallel took 91 s with 4 workers, 75 s with 6, 70 s with 8 and 75 s with 10, the same verdicts every time.
   - **Lean:** keep it.
   - **If not:** any number, through `--jobs`, or a new default; the verdicts do not depend on it.
3. **Parallel as the default, old way behind `--serial`.**
   - **Lean:** yes, as D129 asks.
   - **If not:** parallel behind a flag instead, and `--serial` dropped.

## Part 5 · How this plan was proven

1. **The build.** Built in `./.scratch/fm/repo`, a copy of `tool/`, `fixtures/` and `app/` (without its caches),
   laid out as the repository so `APP` and `../fixtures` resolve as they do there. The blocks are
   `git diff --no-index` against the tracked files, prefixes rewritten.
2. **Test first.**
   - The 10 old runner tests pass unchanged on the new runner.
   - The 19 new tests, run against the old runner, fail as Task 1 says (`FAILED (failures=10, errors=8)` of 29 in
     the file).
   - On the new runner, all 29 pass.
3. **Hand mutation** (scripts in the session's scratchpad), each break run against its named test, unbroken first:
   - **The runner, M1 to M14, all caught:**
     - M1: unbroken run per row (the test: each pair runs unbroken once).
     - M2 and M3: `build/` or `.dart_tool/flutter_build` copied. M4: no fixtures beside the copy.
     - M5: the broken run in the real `app/`. M6: the copies kept.
     - M7: verdicts in the order rows finish. M8: a copy not put back after its row.
     - M9: a default of cores − 1. M10: `--serial` ignored. M11: the pattern check skipped.
     - M12: a copy per job rather than per row to run. M13: a survivor reported caught. M14: `--jobs 0` allowed.
   - **The comparison, C1 to C6, all caught:**
     - C1: serial compared with itself. C2: the built rows' verdicts ignored.
     - C3: every twentieth row. C4: the built rows left out.
     - C5: always exit 0. C6: `--jobs 0` allowed.
   - **Two first survived:** M7, because all three rows had the same verdict, and M12, because the copies used
     rather than made were counted. Both tests were strengthened before the blocks were cut.
4. **The equivalence on real Flutter**, in the build copy, with the pinned Flutter: `serial 317 s, parallel 77 s, 8 jobs` and `app mutations compare: 101 rows, 101 the same`, exit 0. The eight built rows got their verdicts both ways, and A1, A13, A481 and A664 were caught both ways.
5. **Timing:** in the build copy, with the pinned Flutter. One invocation: `/usr/bin/time -p fvm flutter test --no-pub <file> --plain-name <name>` (1.3 to 2.5 s). The sample: `time python3 -I -B tool/app_mutations_compare.py`, 395 s in all (serial 317 s, parallel 77 s). Scaling: `run_parallel` on the sample at 4, 6, 10 and 8 workers (91, 75, 75, 70 s). The full table in parallel at 8 workers: 409 s, `624 caught of 624`. No copy was left in `$TMPDIR` after any run.
6. **Guards** on the build: `guards (walk): all passed` on the replayed tree. G4 first refused two stand-in shell lines in the new tests (twelve words or more), each split before the blocks were cut.
7. **Replayed on a fresh copy**: `./.scratch/fm/replay2`, from `git archive` of `cc2ea8c`, both blocks applied with `git apply` and `GIT_CEILING_DIRECTORIES` set, each file then byte-identical (`cmp`) to the build. Guard tests after Task 1: `FAILED (failures=10, errors=9)`; after Task 2: `Ran 272`, `FAILED (errors=1)`. The one error, `test_check_all.CheckAll` setUpClass, needs a git repository and errs the same way on an untouched archive of `cc2ea8c` (`Ran 253`); the copy has no `.git`, so its two tests do not run, hence 272 and not 274, and 9 errors and not 8.
8. **Not run in the sandbox:** the full `--all` proof (Task 4, the owner's: about 40 minutes, most of it the serial way), and
   `tool/check_all.sh` whole.
