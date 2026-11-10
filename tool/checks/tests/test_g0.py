# Task 2b (D17): G0 file kinds.
import plistlib
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

    def test_generated_strings_pass(self):
        # D32: the two InfoPlist.strings the generator writes, by path.
        self.passed({'app/ios/Runner/en.lproj/InfoPlist.strings': '"k" = "v";\n',
                     'app/ios/Runner/sv.lproj/InfoPlist.strings': '"k" = "v";\n'})

    def test_other_strings_refused(self):
        for path in ('app/ios/Runner/de.lproj/InfoPlist.strings', 'app/ios/Runner/a.strings'):
            self.assertEqual(self.refused({path: '"k" = "v";\n'}), [(path, 0, 'unknown-kind')])

    def test_unknown_kinds_refused(self):
        for path in ('a.tsx', 'a.jsx', 'a.mts', 'a.m', 'a.c', 'a.kt', 'a.txt', 'Makefile',
                     'docs/SOURCES', 'app/awaiting-import'):
            found = self.refused({path: 'x\n'})
            self.assertEqual(found, [(path, 0, 'unknown-kind')])

    def test_flutter_kinds_pass(self):
        # scaffold-2-app (D20 Q13): the kinds FVM and Flutter's iOS
        # project bring are config.
        self.passed({'app/.fvmrc': '{\n  "flutter": "3.47.9"\n}',
                     'app/.metadata': 'version:\n  channel: "stable"\n',
                     'app/ios/Runner.xcworkspace/contents.xcworkspacedata':
                         '<?xml version="1.0" encoding="UTF-8"?>\n<Workspace>\n</Workspace>\n',
                     'app/ios/Runner.xcworkspace/WorkspaceSettings.xcsettings':
                         plistlib.dumps({'k': False}),
                     'app/ios/Runner/Base.lproj/Main.storyboard': '<?xml version="1.0"?>\n<document/>\n',
                     'app/ios/Runner/Runner-Bridging-Header.h': '#import "a.h"\n'})

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

    def test_undecodable_config_refused(self):
        # Task 2d (D1): config is known only as UTF-8 text with no NUL
        # byte. G4, G5 and G9 would read it as empty; G6 and G7 skip it.
        cases = {'server/package.json': '{"name": "word"}\n'.encode('utf-16'),
                 'app/pubspec.yaml': 'name: word é\n'.encode('latin-1'),
                 'app/ios/Runner/Info.plist': plistlib.dumps({'k': 'word'},
                                                             fmt=plistlib.FMT_BINARY)}
        for path, body in cases.items():
            found = self.refused({path: body})
            self.assertEqual(found, [(path, 0, 'unknown-kind')])

    def test_utf8_config_passes(self):
        self.passed({'server/package.json': '{"name": "word"}\n',
                     'app/pubspec.yaml': 'name: word é\n',
                     'app/ios/Runner/Info.plist': plistlib.dumps({'k': 'word'})})

    def test_undecodable_code_refused(self):
        # Task 2d (D3): code too. G4 and G5 call it unlexable, but G6 and
        # G7 skip a file that does not decode.
        cases = {'app/lib/a.dart': "const s = 'é';\n".encode('latin-1'),
                 'server/src/a.ts': 'let a = 1;\n'.encode('utf-16'),
                 'app/ios/a.swift': b'let a = 1\0\n',
                 'tool/a.py': b'a = 1 \xff\n',
                 'tool/a.sh': b'a=1\0\n'}
        for path, body in cases.items():
            found = self.refused({path: body})
            self.assertEqual(found, [(path, 0, 'unknown-kind')])


if __name__ == '__main__':
    unittest.main()
