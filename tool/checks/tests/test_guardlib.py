# Task 2a (D16): the library fixes.
import os
import shutil
import subprocess
import tempfile
import unittest
from unittest import mock

from helpers import make_tree, sentence
import guardlib
import lex


def kinds(files):
    root = make_tree(files)
    try:
        src = guardlib.Source(root, 'walk')
        return {p: src.kind(p) for p in src.paths}
    finally:
        shutil.rmtree(root)


class Library(unittest.TestCase):
    def test_secret_names_ignore_case(self):
        for name in ('.ENV', '.Env.Local', 'x.PEM', 'AuthKey.P8', 'k.P12', 'a.MobileProvision'):
            self.assertTrue(guardlib.is_secret_name('app/' + name), name)
        root = make_tree({'app/x.PEM': 'canary\n'})
        try:
            os.chmod(os.path.join(root, 'app', 'x.PEM'), 0)
            src = guardlib.Source(root, 'walk')
            self.assertEqual(src.paths, ['app/x.PEM'])
            self.assertIsNone(src.read('app/x.PEM'))
        finally:
            shutil.rmtree(root)

    def test_kind_by_extension(self):
        got = kinds({'a.mjs': '', 'a.cjs': '', 'a.tsx': '', 'a.jsx': '', 'a.swift': '',
                     'a.json': '', 'a.yaml': '', 'a.yml': '',
                     'package-lock.json': '', 'pnpm-lock.yaml': '',
                     'docs/tool.py': '', 'docs/a.dart': '', 'docs/a.md': ''})
        self.assertEqual(got, {'a.mjs': 'ts', 'a.cjs': 'ts', 'a.tsx': 'ts', 'a.jsx': 'ts',
                               'a.swift': 'swift', 'a.json': 'config', 'a.yaml': 'config',
                               'a.yml': 'config', 'package-lock.json': None,
                               'pnpm-lock.yaml': None, 'docs/tool.py': 'py',
                               'docs/a.dart': 'dart', 'docs/a.md': None})

    def test_kind_by_shebang(self):
        got = kinds({'a': '#!/bin/sh -eu\n', 'b': '#!/usr/bin/env bash\n', 'c': '#!/bin/dash\n',
                     'd': '#!/bin/zsh\n', 'e': '#!/usr/bin/env -S python3 -u\n',
                     'f': '#!/usr/bin/python3.12\n', 'g': '#!/usr/bin/env node\n',
                     'h': '#!/usr/bin/perl\n', 'i': 'no shebang\n'})
        self.assertEqual(got, {'a': 'sh', 'b': 'sh', 'c': 'sh', 'd': 'sh', 'e': 'py',
                               'f': 'py', 'g': 'ts', 'h': None, 'i': None})

    def test_yaml_block_scalars_joined(self):
        half = sentence(6)
        for mark in ('|', '>-', '|2'):
            text = 'description: ' + mark + '\n  ' + half + '\n\n  ' + half + '\nname: x\n'
            got = guardlib.config_strings('app/pubspec.yaml', text)
            self.assertIn((1, sentence(12)), got)
            self.assertIn((5, 'x'), got)
            self.assertEqual(max(guardlib.words(t) for _, t in got), 12)
        got = guardlib.config_strings('a.yml', '- |\n  ' + half + '\n  ' + half + '\n')
        self.assertIn((1, sentence(12)), got)

    def test_yaml_comment_only_outside_quotes(self):
        text = '\n'.join(['a: "p # q r"', 'b: s # t u', "c: 'v # w'", '# x y', ''])
        got = guardlib.config_strings('app/pubspec.yaml', text)
        self.assertEqual(got[:4], [(1, '"p # q r"'), (2, 's'), (3, "'v # w'"), (4, '')])

    def test_any_lexer_exception_is_unlexable(self):
        root = make_tree({'app/lib/a.dart': 'f() {}\n'})
        try:
            src = guardlib.Source(root, 'walk')
            with mock.patch.object(lex, 'lex_dart', side_effect=RecursionError):
                self.assertIsNone(src.lexed('app/lib/a.dart'))
        finally:
            shutil.rmtree(root)

    def test_undecodable_path_is_a_finding(self):
        root = tempfile.mkdtemp(prefix='guards-')
        env = dict(os.environ, GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM='1')

        def git(*args, data=None):
            return subprocess.run(('git',) + args, cwd=root, env=env, input=data,
                                  check=True, capture_output=True).stdout

        try:
            git('init', '-q')
            blob = git('hash-object', '-w', '--stdin', data=b'x\n').strip()
            for name in (b'app/a\xff.txt', b'app/b.txt'):
                git('update-index', '--add', '--cacheinfo', b'100644,' + blob + b',' + name)
            for mode in ('tracked', 'staged'):
                src = guardlib.Source(root, mode)
                self.assertEqual(src.paths, ['app/b.txt'])
                self.assertEqual([f.key() for f in src.findings],
                                 [('app/a\\xff.txt', 0, 'bad-path')])
        finally:
            shutil.rmtree(root)


if __name__ == '__main__':
    unittest.main()
