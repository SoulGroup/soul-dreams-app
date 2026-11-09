# guards.py's arguments: an --only value that is not a guard code is
# refused with exit 2, naming only the code given.
import os
import shutil
import subprocess
import sys
import unittest

from helpers import CHECKS, make_tree

GUARDS = os.path.join(CHECKS, 'guards.py')


class Only(unittest.TestCase):
    def setUp(self):
        self.root = make_tree({'a.py': 'x = 1\n'})
        self.addCleanup(shutil.rmtree, self.root)

    def guards(self, *args):
        return subprocess.run([sys.executable, '-I', '-B', GUARDS, '--walk', self.root] + list(args),
                              capture_output=True, text=True)

    def test_known_code_runs_only_that_guard(self):
        r = self.guards('--only', 'G5')
        self.assertEqual(r.returncode, 0, r.stdout)
        self.assertEqual(r.stdout, 'G5 logging: ok\nguards (walk): all passed\n')

    def test_unknown_code_refused(self):
        for code in ('G99', 'g5', '--staged'):
            r = self.guards('--only', 'G5', '--only', code)
            self.assertEqual(r.returncode, 2, code)
            self.assertEqual(r.stdout, 'guards: unknown guard ' + code + '\n')


if __name__ == '__main__':
    unittest.main()
