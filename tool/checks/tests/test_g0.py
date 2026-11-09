# Task 2b (D17): G0 file kinds.
import unittest

from helpers import GuardTest
import g0_kinds


class G0(GuardTest):
    guard = g0_kinds

    def test_known_kinds_pass(self):
        self.passed({'app/lib/a.dart': '', 'server/src/a.ts': '', 'app/ios/a.swift': '',
                     'tool/a.py': '', 'tool/a.sh': '', '.githooks/pre-commit': '#!/bin/sh\n',
                     'app/pubspec.yaml': '', '.claude/settings.json': '{}\n',
                     'docs/a.md': '', 'app/assets/words/places-register.csv': '',
                     '.gitignore': '', 'docs/source/SOURCES': '',
                     'tool/checks/awaiting-import': '', 'server/package-lock.json': '',
                     'app/pubspec.lock': '', 'app/icon.png': b'\x89PNG\r\n\x1a\n\0\0'})

    def test_unknown_kinds_refused(self):
        for path in ('a.tsx', 'a.jsx', 'a.mts', 'a.m', 'a.h', 'a.kt', 'a.txt', 'Makefile',
                     'docs/SOURCES', 'app/awaiting-import'):
            found = self.refused({path: 'x\n'})
            self.assertEqual(found, [(path, 0, 'unknown-kind')])

    def test_unknown_shebang_refused(self):
        for body in ('#!/usr/bin/perl\n', '#!/usr/bin/env deno\n',
                     '#!/usr/bin/env -u HOME python3\n'):
            self.refused({'tool/run': body}, 'unknown-kind')
        self.refused({'tool/checks/awaiting-import': '#!/usr/bin/perl\n'}, 'unknown-kind')

    def test_binary_needs_a_nul_byte(self):
        self.passed({'a.bin': b'\0\xff'})
        self.refused({'a.bin': b'\xff\xfe'}, 'unknown-kind')

    def test_undecodable_unscanned_refused(self):
        # Task 2c (C1): a listed kind is known only as UTF-8 text with no
        # NUL byte. The euro sign has no Latin-1 byte: the CSV is cp1252.
        self.refused({'docs/a.md': 'word é\n'.encode('latin-1')}, 'unknown-kind')
        self.refused({'app/assets/words/places-register.csv': 'word,€\n'.encode('cp1252')},
                     'unknown-kind')
        for path in ('docs/a.md', 'a.CSV', '.gitignore', 'server/package-lock.json',
                     'docs/source/SOURCES', 'tool/checks/awaiting-import'):
            for body in (b'word\0\n', b'word \xff\n', 'word\n'.encode('utf-16')):
                found = self.refused({path: body})
                self.assertEqual(found, [(path, 0, 'unknown-kind')])

    def test_utf8_unscanned_pass(self):
        self.passed({'docs/a.md': 'word é\n',
                     'app/assets/words/places-register.csv': 'word,€\n'})


if __name__ == '__main__':
    unittest.main()
