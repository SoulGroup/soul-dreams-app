# tool/server_mutations.py, on a stand-in server in $TMPDIR with a
# stand-in npm first on PATH (never the real server, never the real
# npm): a row counts as caught only when the unbroken server passes its
# check and tests first.
import contextlib
import io
import os
import shutil
import sys
import tempfile
import unittest

from helpers import CHECKS

sys.path.insert(0, os.path.dirname(CHECKS))

import server_mutations  # noqa: E402

# The stand-in npm fails, naming the test, when the file is broken;
# with BROKEN_FROM_START set it fails that way even unbroken.
NPM = '\n'.join([
    '#!/bin/sh',
    'if [ -n "${BROKEN_FROM_START:-}" ] ||',
    '  grep -q new a.txt; then',
    "  echo '✖ named (1ms)'",
    '  exit 1',
    'fi',
    'exit 0',
    '',
])


class ServerMutations(unittest.TestCase):
    def setUp(self):
        self.server = tempfile.mkdtemp(prefix='server-')
        self.addCleanup(shutil.rmtree, self.server)
        os.makedirs(os.path.join(self.server, 'node_modules'))
        with open(os.path.join(self.server, 'a.txt'), 'w') as f:
            f.write('old\n')
        bin_dir = tempfile.mkdtemp(prefix='server-bin-')
        self.addCleanup(shutil.rmtree, bin_dir)
        npm = os.path.join(bin_dir, 'npm')
        with open(npm, 'w', encoding='utf-8') as f:
            f.write(NPM)
        os.chmod(npm, 0o755)
        saved = dict(os.environ)
        self.addCleanup(lambda: (os.environ.clear(), os.environ.update(saved)))
        os.environ['PATH'] = bin_dir + os.pathsep + os.environ.get('PATH', '')
        os.environ.pop('BROKEN_FROM_START', None)
        for name, value in (('SERVER', self.server),
                            ('ROWS', [('X1', 'a.txt', 'old', 'new', 'test', 'named')])):
            self.addCleanup(setattr, server_mutations, name, getattr(server_mutations, name))
            setattr(server_mutations, name, value)

    def main(self):
        out = io.StringIO()
        with contextlib.redirect_stdout(out):
            code = server_mutations.main()
        return code, out.getvalue().splitlines()

    def test_caught_when_unbroken_passes(self):
        code, lines = self.main()
        self.assertEqual(lines[-1], 'server mutations: 1 run, 1 caught')
        self.assertEqual(code, 0)

    def test_failing_unbroken_server_fails_the_run(self):
        os.environ['BROKEN_FROM_START'] = '1'
        code, lines = self.main()
        self.assertEqual(lines, ['server mutations: FAILED (the unbroken server fails)'])
        self.assertEqual(code, 1)


if __name__ == '__main__':
    unittest.main()
