# The pre-commit hook, end to end, in a throwaway git repository:
# it checks the index, not the working tree.
import os
import shutil
import subprocess
import tempfile
import unittest

from helpers import CHECKS

ROOT = os.path.dirname(os.path.dirname(CHECKS))
HOOK = os.path.join(ROOT, '.githooks', 'pre-commit')
BAD = 'f() { ' + 'pri' + 'nt(1); }\n'
GOOD = 'f() {}\n'


class Hook(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp(prefix='hook-')
        self.env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1')
        self.git('init', '-q')
        shutil.copytree(CHECKS, os.path.join(self.tmp, 'tool', 'checks'),
                        ignore=shutil.ignore_patterns('__pycache__'))
        os.makedirs(os.path.join(self.tmp, '.githooks'))
        shutil.copy(HOOK, os.path.join(self.tmp, '.githooks', 'pre-commit'))
        self.git('add', '.')

    def tearDown(self):
        shutil.rmtree(self.tmp)

    def git(self, *args):
        subprocess.run(('git',) + args, cwd=self.tmp, env=self.env, check=True,
                       capture_output=True)

    def write(self, body):
        os.makedirs(os.path.join(self.tmp, 'app', 'lib'), exist_ok=True)
        with open(os.path.join(self.tmp, 'app', 'lib', 'a.dart'), 'w') as f:
            f.write(body)

    def hook(self):
        return subprocess.run(['sh', '.githooks/pre-commit'], cwd=self.tmp, env=self.env,
                              capture_output=True, text=True)

    def test_clean_index_passes(self):
        r = self.hook()
        self.assertEqual(r.returncode, 0, r.stdout)
        self.assertIn('G1 words: NOT ARMED', r.stdout)

    def test_staged_writer_refused(self):
        self.write(BAD)
        self.git('add', 'app/lib/a.dart')
        r = self.hook()
        self.assertEqual(r.returncode, 1)
        self.assertIn('G5 app/lib/a.dart:1 writer-print', r.stdout)

    def test_unstaged_change_is_not_checked(self):
        self.write(GOOD)
        self.git('add', 'app/lib/a.dart')
        self.write(BAD)
        self.assertEqual(self.hook().returncode, 0)

    def test_staged_bad_fixed_only_in_worktree_refused(self):
        self.write(BAD)
        self.git('add', 'app/lib/a.dart')
        self.write(GOOD)
        self.assertEqual(self.hook().returncode, 1)

    def test_undecodable_path_refused(self):
        blob = subprocess.run(('git', 'hash-object', '-w', '--stdin'), cwd=self.tmp, env=self.env,
                              input=b'x\n', check=True, capture_output=True).stdout.strip()
        self.git('update-index', '--add', '--cacheinfo', b'100644,' + blob + b',app/a\xff.txt')
        r = self.hook()
        self.assertEqual(r.returncode, 1)
        self.assertIn('source app/a\\xff.txt:0 bad-path', r.stdout)



if __name__ == '__main__':
    unittest.main()
