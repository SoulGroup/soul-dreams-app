# tool/app_mutations.py, on a stand-in app in $TMPDIR with a stand-in
# fvm first on PATH (never the real app, never the real Flutter): a row
# counts as caught only when its test passes unbroken and fails broken,
# and the broken file is put back byte for byte every time.
import contextlib
import io
import os
import shutil
import sys
import tempfile
import unittest

from helpers import CHECKS

sys.path.insert(0, os.path.dirname(CHECKS))

import app_mutations  # noqa: E402

# The stand-in fvm fails when the file is broken; with BROKEN_FROM_START
# set it fails even unbroken; with TOLERANT set it never fails.
FVM = '\n'.join([
    '#!/bin/sh',
    'if [ -n "${TOLERANT:-}" ]; then exit 0; fi',
    'if [ -n "${BROKEN_FROM_START:-}" ] ||',
    '  grep -q new lib/a.dart lib/b.dart 2>/dev/null; then',
    '  exit 1',
    'fi',
    'exit 0',
    '',
])

ORIGINAL = b'old\r\nkept \xc3\xa5\n'


class StandIn(unittest.TestCase):
    def setUp(self):
        self.app = tempfile.mkdtemp(prefix='app-')
        self.addCleanup(shutil.rmtree, self.app)
        os.makedirs(os.path.join(self.app, 'lib'))
        self.target = os.path.join(self.app, 'lib', 'a.dart')
        with open(self.target, 'wb') as f:
            f.write(ORIGINAL)
        bin_dir = tempfile.mkdtemp(prefix='app-bin-')
        self.addCleanup(shutil.rmtree, bin_dir)
        fvm = os.path.join(bin_dir, 'fvm')
        with open(fvm, 'w', encoding='utf-8') as f:
            f.write(FVM)
        os.chmod(fvm, 0o755)
        saved = dict(os.environ)
        self.addCleanup(lambda: (os.environ.clear(), os.environ.update(saved)))
        os.environ['PATH'] = bin_dir + os.pathsep + os.environ.get('PATH', '')
        os.environ.pop('BROKEN_FROM_START', None)
        os.environ.pop('TOLERANT', None)
        for name, value in (('APP', self.app),
                            ('ROWS', [('X1', 'lib/a.dart', 'old', 'new',
                                       'test/a_test.dart', 'named')])):
            self.addCleanup(setattr, app_mutations, name, getattr(app_mutations, name))
            setattr(app_mutations, name, value)

    def main(self):
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = app_mutations.main()
        with open(self.target, 'rb') as f:
            self.assertEqual(f.read(), ORIGINAL)
        return code, out.getvalue().splitlines()


class AppMutations(StandIn):
    def test_caught_when_unbroken_passes(self):
        code, lines = self.main()
        self.assertEqual(lines, ['X1: caught', 'app mutations: 1 run, 1 caught'])
        self.assertEqual(code, 0)

    def test_failing_unbroken_test_fails_the_run(self):
        os.environ['BROKEN_FROM_START'] = '1'
        code, lines = self.main()
        self.assertEqual(lines, ['X1: SETUP FAILED (the test fails unbroken)',
                                 'app mutations: 1 run, 0 caught'])
        self.assertEqual(code, 1)

    def test_a_tolerant_test_fails_the_run(self):
        os.environ['TOLERANT'] = '1'
        code, lines = self.main()
        self.assertEqual(lines, ['X1: SURVIVED', 'app mutations: 1 run, 0 caught'])
        self.assertEqual(code, 1)


# D95: during a task only the rows that target the files changed are run.
class AppMutationsSelected(StandIn):
    def setUp(self):
        super().setUp()
        self.other = os.path.join(self.app, 'lib', 'b.dart')
        with open(self.other, 'wb') as f:
            f.write(ORIGINAL)
        rows = [('X1', 'lib/a.dart', 'old', 'new', 'test/a_test.dart', 'named'),
                ('X2', 'lib/b.dart', 'old', 'new', 'test/b_test.dart', 'named'),
                ('X3', 'lib/a.dart', 'kept', 'new', 'test/a_test.dart', 'named')]
        setattr(app_mutations, 'ROWS', rows)

    def select(self, *argv):
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = app_mutations.main(list(argv))
        for path in (self.target, self.other):
            with open(path, 'rb') as f:
                self.assertEqual(f.read(), ORIGINAL)
        return code, out.getvalue().splitlines()

    def test_no_argument_runs_every_row(self):
        code, lines = self.select()
        self.assertEqual(lines[-1], 'app mutations: 3 run, 3 caught')
        self.assertEqual(code, 0)

    def test_rows_runs_only_the_named_rows(self):
        code, lines = self.select('--rows', 'X3,X2')
        self.assertEqual(lines, ['X2: caught', 'X3: caught', 'app mutations: 2 run, 2 caught'])
        self.assertEqual(code, 0)

    def test_files_runs_only_the_rows_of_those_files(self):
        code, lines = self.select('--files', 'lib/a.dart')
        self.assertEqual(lines, ['X1: caught', 'X3: caught', 'app mutations: 2 run, 2 caught'])
        self.assertEqual(code, 0)

    def test_a_path_may_start_with_app(self):
        code, lines = self.select('--files', 'app/lib/b.dart')
        self.assertEqual(lines, ['X2: caught', 'app mutations: 1 run, 1 caught'])
        self.assertEqual(code, 0)

    def test_a_file_with_no_row_runs_nothing_and_says_so(self):
        code, lines = self.select('--files', 'lib/none.dart')
        self.assertEqual(lines, ['app mutations: 0 run, 0 caught'])
        self.assertEqual(code, 0)

    def test_an_unknown_row_or_argument_runs_nothing_and_fails(self):
        for argv in (('--rows', 'X1,X9'), ('--rows',), ('--files',), ('--all',), ('X1',)):
            code, lines = self.select(*argv)
            self.assertEqual(lines, ['app mutations: bad arguments'], argv)
            self.assertEqual(code, 2)

    def test_a_selected_row_that_survives_fails_the_run(self):
        os.environ['TOLERANT'] = '1'
        code, lines = self.select('--rows', 'X2')
        self.assertEqual(lines, ['X2: SURVIVED', 'app mutations: 1 run, 0 caught'])
        self.assertEqual(code, 1)



# D129: parallel by default, each worker in its own copy of app/; the
# old way behind --serial. The stand-in fvm here also writes one line
# per run to $RUNS: the folder it ran in, then "broken" or "unbroken".
LOGGING_FVM = '\n'.join([
    '#!/bin/sh',
    'if grep -q new lib/a.dart lib/b.dart 2>/dev/null; then',
    '  echo "$PWD broken" >> "$RUNS"',
    '  if [ -n "${SLOW_A:-}" ] && grep -q new lib/a.dart; then',
    '    sleep 0.5',
    '  fi',
    '  [ -n "${TOLERANT:-}" ] && exit 0',
    '  exit 1',
    'fi',
    'echo "$PWD unbroken" >> "$RUNS"',
    '[ -e build ] && echo "$PWD has-build" >> "$RUNS"',
    '[ -e .dart_tool/flutter_build ] && echo "$PWD has-flutter-build" >> "$RUNS"',
    '[ -e .dart_tool/package_config.json ] || exit 1',
    'if [ -n "${NEED_FIXTURES:-}" ]; then',
    '  [ -f ../fixtures/n.json ] || exit 1',
    'fi',
    'exit 0',
    '',
])


class Parallel(unittest.TestCase):
    def setUp(self):
        # top/app and top/fixtures, as in the repository; temporary
        # folders go under top/tmp, so the copies can be counted.
        self.top = os.path.realpath(tempfile.mkdtemp(prefix='app-top-'))
        self.addCleanup(shutil.rmtree, self.top)
        self.app = os.path.join(self.top, 'app')
        for folder in ('lib', 'test', 'build', os.path.join('.dart_tool', 'flutter_build')):
            os.makedirs(os.path.join(self.app, folder))
        with open(os.path.join(self.app, '.dart_tool', 'package_config.json'), 'w') as f:
            f.write('{}')
        for name in ('a.dart', 'b.dart'):
            with open(os.path.join(self.app, 'lib', name), 'wb') as f:
                f.write(ORIGINAL)
        os.makedirs(os.path.join(self.top, 'fixtures'))
        with open(os.path.join(self.top, 'fixtures', 'n.json'), 'w') as f:
            f.write('{}')
        self.tmp = os.path.join(self.top, 'tmp')
        os.makedirs(self.tmp)
        self.addCleanup(setattr, tempfile, 'tempdir', tempfile.tempdir)
        tempfile.tempdir = self.tmp
        bin_dir = os.path.join(self.top, 'bin')
        os.makedirs(bin_dir)
        fvm = os.path.join(bin_dir, 'fvm')
        with open(fvm, 'w', encoding='utf-8') as f:
            f.write(LOGGING_FVM)
        os.chmod(fvm, 0o755)
        self.runs = os.path.join(self.top, 'runs')
        saved = dict(os.environ)
        self.addCleanup(lambda: (os.environ.clear(), os.environ.update(saved)))
        os.environ['PATH'] = bin_dir + os.pathsep + os.environ.get('PATH', '')
        os.environ['RUNS'] = self.runs
        for name in ('TOLERANT', 'SLOW_A', 'NEED_FIXTURES'):
            os.environ.pop(name, None)
        rows = [('X1', 'lib/a.dart', 'old', 'new', 'test/a_test.dart', 'named'),
                ('X2', 'lib/b.dart', 'old', 'new', 'test/b_test.dart', 'named'),
                ('X3', 'lib/a.dart', 'kept', 'new', 'test/a_test.dart', 'named')]
        for name, value in (('APP', self.app), ('ROWS', rows)):
            self.addCleanup(setattr, app_mutations, name, getattr(app_mutations, name))
            setattr(app_mutations, name, value)

    def main(self, *argv):
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = app_mutations.main(list(argv))
        for name in ('a.dart', 'b.dart'):
            with open(os.path.join(self.app, 'lib', name), 'rb') as f:
                self.assertEqual(f.read(), ORIGINAL)
        return code, out.getvalue().splitlines()

    def logged(self):
        if not os.path.exists(self.runs):
            return []
        with open(self.runs, encoding='utf-8') as f:
            return [line.rsplit(' ', 1) for line in f.read().splitlines()]

    def test_parallel_runs_only_in_copies_and_removes_them(self):
        code, lines = self.main('--jobs', '2')
        self.assertEqual(lines, ['X1: caught', 'X2: caught', 'X3: caught',
                                 'app mutations: 3 run, 3 caught'])
        self.assertEqual(code, 0)
        folders = {folder for folder, _ in self.logged()}
        self.assertTrue(folders)
        self.assertNotIn(self.app, folders)
        for folder in folders:
            self.assertTrue(folder.startswith(self.tmp + os.sep), folder)
            self.assertEqual(os.path.basename(folder), 'app')
        self.assertEqual(os.listdir(self.tmp), [])

    def test_serial_runs_in_app_itself_as_before(self):
        code, lines = self.main('--serial')
        self.assertEqual(lines, ['X1: caught', 'X2: caught', 'X3: caught',
                                 'app mutations: 3 run, 3 caught'])
        self.assertEqual(code, 0)
        self.assertEqual({folder for folder, _ in self.logged()}, {self.app})
        self.assertEqual([kind for _, kind in self.logged()].count('unbroken'), 3)

    def test_each_test_and_name_runs_unbroken_once(self):
        self.main('--jobs', '3')
        kinds = [kind for _, kind in self.logged()]
        self.assertEqual(sorted(kinds), ['broken'] * 3 + ['unbroken'] * 2)

    def test_jobs_sets_the_number_of_copies(self):
        for jobs, most in (('1', 1), ('2', 2)):
            if os.path.exists(self.runs):
                os.remove(self.runs)
            self.main('--jobs', jobs)
            folders = {folder for folder, _ in self.logged()}
            self.assertLessEqual(len(folders), most, jobs)
            self.assertGreaterEqual(len(folders), 1)

    def test_no_more_copies_than_rows_to_run(self):
        made = []
        real = app_mutations.copy_app
        self.addCleanup(setattr, app_mutations, 'copy_app', real)
        app_mutations.copy_app = lambda root, k: made.append(k) or real(root, k)
        self.main('--rows', 'X2', '--jobs', '4')
        self.assertEqual(made, [0])

    def test_caches_are_not_copied_and_fixtures_are(self):
        os.environ['NEED_FIXTURES'] = '1'
        code, lines = self.main('--jobs', '2')
        self.assertEqual(lines[-1], 'app mutations: 3 run, 3 caught')
        kinds = {kind for _, kind in self.logged()}
        self.assertNotIn('has-build', kinds)
        self.assertNotIn('has-flutter-build', kinds)

    def test_verdicts_come_in_the_rows_order(self):
        # X1 and X3 are slow and caught; X2 changes nothing, so it
        # survives, and finishes first.
        os.environ['SLOW_A'] = '1'
        rows = [('X1', 'lib/a.dart', 'old', 'new', 'test/a_test.dart', 'named'),
                ('X2', 'lib/b.dart', 'kept', 'kept', 'test/b_test.dart', 'named'),
                ('X3', 'lib/a.dart', 'kept', 'new', 'test/a_test.dart', 'named')]
        setattr(app_mutations, 'ROWS', rows)
        code, lines = self.main('--jobs', '3')
        self.assertEqual(lines, ['X1: caught', 'X2: SURVIVED', 'X3: caught',
                                 'app mutations: 3 run, 2 caught'])

    def test_a_survivor_is_a_survivor_in_both_ways(self):
        os.environ['TOLERANT'] = '1'
        for argv in (('--serial',), ('--jobs', '2')):
            code, lines = self.main(*argv)
            self.assertEqual(lines, ['X1: SURVIVED', 'X2: SURVIVED', 'X3: SURVIVED',
                                     'app mutations: 3 run, 0 caught'], argv)
            self.assertEqual(code, 1)

    def test_a_missing_pattern_runs_nothing_in_both_ways(self):
        rows = [('X4', 'lib/a.dart', 'absent', 'new', 'test/a_test.dart', 'named')]
        setattr(app_mutations, 'ROWS', rows)
        for argv in (('--serial',), ()):
            code, lines = self.main(*argv)
            self.assertEqual(lines, ['X4: SETUP FAILED (pattern not found once)',
                                     'app mutations: 1 run, 0 caught'], argv)
            self.assertEqual(code, 1)
        self.assertEqual(self.logged(), [])

    def test_each_row_puts_its_copy_back(self):
        # X6 changes nothing, so it survives, unless X1's break is
        # still in the one copy when X6 runs there.
        rows = [('X1', 'lib/a.dart', 'old', 'new', 'test/a_test.dart', 'named'),
                ('X6', 'lib/b.dart', 'kept', 'kept', 'test/b_test.dart', 'named')]
        setattr(app_mutations, 'ROWS', rows)
        code, lines = self.main('--jobs', '1')
        self.assertEqual(lines, ['X1: caught', 'X6: SURVIVED', 'app mutations: 2 run, 1 caught'])

    def test_the_copies_go_when_a_run_fails(self):
        def broken_run(test, name, app=None):
            raise OSError('stand-in')
        self.addCleanup(setattr, app_mutations, 'run', app_mutations.run)
        app_mutations.run = broken_run
        with self.assertRaises(OSError):
            self.main('--jobs', '2')
        self.assertEqual(os.listdir(self.tmp), [])

    def test_bad_jobs_or_serial_arguments_run_nothing_and_fail(self):
        for argv in (('--jobs', '0'), ('--jobs', 'x'), ('--jobs',), ('--jobs', '2', '--jobs', '3'),
                     ('--serial', '--jobs', '2'), ('--serial', '--serial'), ('--jobs', '-1')):
            code, lines = self.main(*argv)
            self.assertEqual(lines, ['app mutations: bad arguments'], argv)
            self.assertEqual(code, 2)
        self.assertEqual(self.logged(), [])

    def test_default_jobs_leaves_two_cores_and_stops_at_eight(self):
        self.addCleanup(setattr, os, 'cpu_count', os.cpu_count)
        for cores, jobs in ((10, 8), (12, 8), (6, 4), (2, 1), (1, 1), (None, 1)):
            os.cpu_count = lambda: cores
            self.assertEqual(app_mutations.default_jobs(), jobs, cores)



# The equivalence proof (D129), with both ways stood in: it passes only
# when every row is the same both ways and the built rows get their
# verdicts.
class Compare(unittest.TestCase):
    def setUp(self):
        import app_mutations_compare
        self.compare = app_mutations_compare
        self.expected = {r[0]: v for r, v in self.compare.OWN + self.compare.BUILT}
        for name in ('run_row', 'run_parallel'):
            self.addCleanup(setattr, app_mutations, name, getattr(app_mutations, name))
        self.serial = lambda *row: self.expected.get(row[0], 'caught')
        app_mutations.run_row = lambda *row: self.serial(*row)
        app_mutations.run_parallel = lambda rows, jobs: [self.serial(*r) for r in rows]

    def main(self, *argv):
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = self.compare.main(list(argv))
        return code, out.getvalue().splitlines()

    def test_the_same_both_ways_passes(self):
        code, lines = self.main('--jobs', '2')
        rows = len(self.compare.sample(False))
        self.assertEqual(lines[-1], 'app mutations compare: %d rows, %d the same' % (rows, rows))
        self.assertEqual(code, 0)

    def test_the_sample_holds_the_built_rows_and_every_tenth(self):
        codes = [r[0] for r in self.compare.sample(False)]
        for r, _ in self.compare.OWN + self.compare.BUILT:
            self.assertIn(r[0], codes)
        for r in app_mutations.ROWS[::10]:
            self.assertIn(r[0], codes)
        every = self.compare.sample(True)
        self.assertEqual(len(every), len(app_mutations.ROWS) + len(self.compare.BUILT))

    def test_a_row_caught_only_in_parallel_fails(self):
        serial = self.serial
        app_mutations.run_parallel = lambda rows, jobs: [
            'caught' if r[0] == 'E2' else serial(*r) for r in rows]
        code, lines = self.main()
        self.assertIn('E2: serial SURVIVED, parallel caught, expected SURVIVED', lines)
        self.assertEqual(code, 1)

    def test_a_real_row_that_differs_fails(self):
        serial = self.serial
        app_mutations.run_parallel = lambda rows, jobs: [
            'SURVIVED' if r[0] == 'A11' else serial(*r) for r in rows]
        code, lines = self.main()
        self.assertIn('A11: serial caught, parallel SURVIVED, expected the same', lines)
        self.assertEqual(code, 1)

    def test_a_built_row_that_misses_its_verdict_both_ways_fails(self):
        self.expected['E1'] = 'caught'
        code, lines = self.main()
        self.assertIn('E1: serial caught, parallel caught, expected SURVIVED', lines)
        self.assertEqual(code, 1)

    def test_bad_arguments_run_nothing_and_fail(self):
        for argv in (('--jobs',), ('--jobs', '0'), ('--rows', 'A1'), ('--jobs', '2', '--jobs', '3')):
            code, lines = self.main(*argv)
            self.assertEqual(lines, ['app mutations compare: bad arguments'], argv)
            self.assertEqual(code, 2)


if __name__ == '__main__':
    unittest.main()
