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


if __name__ == '__main__':
    unittest.main()
