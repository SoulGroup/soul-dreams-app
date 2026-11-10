# tool/check_all.sh, end to end, on a throwaway copy of the repository
# in $TMPDIR (never the real tree): a failing guard must end it with
# exit 1 and "check_all: FAILED". The copy leaves out this file (or it
# would run itself again) and app/ and server/ (their analyzers and
# tests are not what this checks). It is a tree before any import: no
# docs/source/, and the awaiting-import marker (branch 3 deletes the
# repository's own; D32).
import os
import shutil
import subprocess
import tempfile
import unittest

from helpers import CHECKS

ROOT = os.path.dirname(os.path.dirname(CHECKS))
SELF = 'tool/checks/tests/test_check_all.py'
LEFT_OUT = ('app/', 'server/', 'docs/source/')
MARKER = 'tool/checks/awaiting-import'


def clean_env():
    env = {k: v for k, v in os.environ.items() if not k.startswith('GIT_')}
    env.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1', GIT_CONFIG_COUNT='1',
               GIT_CONFIG_KEY_0='core.hooksPath', GIT_CONFIG_VALUE_0='.githooks')
    return env


def failing_copy(env):
    # A copy of the tracked files, modes kept, plus one file of a kind
    # G0 does not know.
    tmp = tempfile.mkdtemp(prefix='check-all-')
    listed = subprocess.run(['git', 'ls-files', '-z'], cwd=ROOT, env=env, check=True,
                            capture_output=True).stdout.decode('utf-8').split('\0')
    for path in listed:
        if not path or path == SELF or path.startswith(LEFT_OUT):
            continue
        full = os.path.join(tmp, path)
        os.makedirs(os.path.dirname(full), exist_ok=True)
        shutil.copy2(os.path.join(ROOT, path), full)
    with open(os.path.join(tmp, 'notes.txt'), 'w') as f:
        f.write('x\n')
    with open(os.path.join(tmp, MARKER), 'w') as f:
        f.write('x\n')
    for args in (['init', '-q'], ['add', '-A']):
        subprocess.run(['git'] + args, cwd=tmp, env=env, check=True, capture_output=True)
    return tmp


def check_all(tmp, env):
    return subprocess.run(['sh', 'tool/check_all.sh'], cwd=tmp, env=env,
                          capture_output=True, text=True, timeout=600)


class CheckAll(unittest.TestCase):
    def test_failing_guard_fails_the_run(self):
        env = clean_env()
        tmp = failing_copy(env)
        self.addCleanup(shutil.rmtree, tmp)
        r = check_all(tmp, env)
        self.assertIn('G0 notes.txt:0 unknown-kind\n', r.stdout)
        self.assertEqual(r.stdout.splitlines()[-1], 'check_all: FAILED: guards')
        self.assertEqual(r.returncode, 1)


if __name__ == '__main__':
    unittest.main()
