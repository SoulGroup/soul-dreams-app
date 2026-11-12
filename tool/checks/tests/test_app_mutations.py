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
    '  grep -q new lib/a.dart; then',
    '  exit 1',
    'fi',
    'exit 0',
    '',
])

ORIGINAL = b'old\r\nkept \xc3\xa5\n'


class AppMutations(unittest.TestCase):
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


if __name__ == '__main__':
    unittest.main()
