# tool/check_all.sh, end to end, on a throwaway copy of the repository
# in $TMPDIR (never the real tree): a failing guard must end it with
# exit 1 and "check_all: FAILED". The copy leaves out this file (or it
# would run itself again) and app/ and server/ (their analyzers and
# tests are not what this checks). It is a tree before any import: no
# docs/source/, and the awaiting-import marker (branch 3 deletes the
# repository's own; D32). In place of server/ it holds a package.json
# pinning the running Node, and a stand-in npm, first on PATH, records
# each call and whether npm's update check was off (D46).
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
NOTIFIER = 'NPM_CONFIG_UPDATE_NOTIFIER'


def clean_env():
    env = {k: v for k, v in os.environ.items()
           if not k.startswith('GIT_') and k.upper() != NOTIFIER}
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


def stand_in_server(tmp, env):
    # server/package.json pinning the running Node's major, and a
    # stand-in npm in a folder of its own, put first on PATH. Returns
    # the file the stand-in writes: one line per call, the notifier's
    # value (or "unset"), then the arguments.
    major = subprocess.run(['node', '--version'], env=env, check=True, capture_output=True,
                           text=True).stdout.strip().lstrip('v').split('.')[0]
    os.makedirs(os.path.join(tmp, 'server'))
    with open(os.path.join(tmp, 'server', 'package.json'), 'w') as f:
        f.write('{"engines": {"node": ">=%s <%d"}}\n' % (major, int(major) + 1))
    bin_dir = tempfile.mkdtemp(prefix='check-all-bin-')
    calls = os.path.join(bin_dir, 'calls')
    npm = os.path.join(bin_dir, 'npm')
    with open(npm, 'w') as f:
        f.write('#!/bin/sh\necho "${%s:-unset} $*" >> "%s"\n' % (NOTIFIER, calls))
    os.chmod(npm, 0o755)
    env['PATH'] = bin_dir + os.pathsep + env.get('PATH', '')
    return bin_dir, calls


def check_all(tmp, env):
    return subprocess.run(['sh', 'tool/check_all.sh'], cwd=tmp, env=env,
                          capture_output=True, text=True, timeout=600)


class CheckAll(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        env = clean_env()
        cls.tmp = failing_copy(env)
        cls.bin_dir, cls.calls = stand_in_server(cls.tmp, env)
        cls.r = check_all(cls.tmp, env)

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.tmp)
        shutil.rmtree(cls.bin_dir)

    def test_failing_guard_fails_the_run(self):
        r = self.r
        self.assertIn('G0 notes.txt:0 unknown-kind\n', r.stdout)
        self.assertEqual(r.stdout.splitlines()[-1], 'check_all: FAILED: guards')
        self.assertEqual(r.returncode, 1)

    def test_npm_update_check_off(self):
        # Every npm call in the server step runs with the update check
        # off, so npm contacts no registry of its own accord (D46).
        with open(self.calls) as f:
            calls = f.read().splitlines()
        self.assertEqual(calls, ['false ci --offline --no-audit --no-fund',
                                 'false run check', 'false test'])


if __name__ == '__main__':
    unittest.main()
