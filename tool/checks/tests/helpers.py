# Test helpers: build a throwaway tree in $TMPDIR and run one guard on it.
import os
import shutil
import sys
import tempfile
import unittest

HERE = os.path.dirname(os.path.abspath(__file__))
CHECKS = os.path.dirname(HERE)
if CHECKS not in sys.path:
    sys.path.insert(0, CHECKS)

import guardlib  # noqa: E402


def make_tree(files):
    root = tempfile.mkdtemp(prefix='guards-')
    for path, body in files.items():
        full = os.path.join(root, path)
        os.makedirs(os.path.dirname(full), exist_ok=True)
        with open(full, 'wb') as f:
            f.write(body if isinstance(body, bytes) else body.encode('utf-8'))
    return root


def run(guard, files):
    root = make_tree(files)
    try:
        findings, notes = guard.check(guardlib.Source(root, 'walk'))
        return sorted(f.key() for f in findings), notes
    finally:
        shutil.rmtree(root)


def sentence(n):
    # n words, built at run time so no long literal sits in this source.
    return ' '.join(['word'] * n)


class GuardTest(unittest.TestCase):
    guard = None

    def refused(self, files, reason=None):
        findings, _ = run(self.guard, files)
        self.assertTrue(findings, 'expected a refusal')
        if reason:
            self.assertIn(reason, [f[2] for f in findings])
        return findings

    def passed(self, files):
        findings, notes = run(self.guard, files)
        self.assertEqual(findings, [])
        return notes
