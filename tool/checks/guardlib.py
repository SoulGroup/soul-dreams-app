# Shared by the guards: which files to read, what kind each one is,
# and the one place the checks write their results.
import hashlib
import os
import posixpath
import re
import subprocess
import sys

import lex

MARKER = 'tool/checks/awaiting-import'
SOURCES = 'docs/source/SOURCES'
CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'

CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.py': 'py', '.sh': 'sh'}
CONFIG_NAMES = ('pubspec.yaml', 'package.json')
CONFIG_EXT = ('.plist', '.entitlements', '.pbxproj', '.xcconfig', '.xcscheme')
LOCKFILES = ('pubspec.lock', 'package-lock.json', 'npm-shrinkwrap.json',
             'Podfile.lock', 'yarn.lock', 'pnpm-lock.yaml')
SKIP_DIRS = ('.git', '.scratch')


def report(line):
    # The checks' only writer (G5 exempts this file). It is given guard
    # codes, repository paths, line numbers and reason codes, never the
    # content of a file.
    sys.stdout.write(line + '\n')
    sys.stdout.flush()


class Finding:
    def __init__(self, path, line, reason):
        self.path = path
        self.line = line
        self.reason = reason

    def key(self):
        return (self.path, self.line, self.reason)


def is_secret_name(path):
    b = posixpath.basename(path)
    return (b == '.env' or b.startswith('.env.')
            or b.endswith(('.p8', '.pem', '.p12', '.mobileprovision')))


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def _git(root, *args):
    r = subprocess.run(('git',) + args, cwd=root, capture_output=True)
    if r.returncode != 0:
        raise RuntimeError('git')
    return r.stdout


class Source:
    # mode 'walk': every file under root (the guard tests use this).
    # mode 'tracked': the files git tracks, read from the working tree.
    # mode 'staged': the index, the snapshot a commit would record.
    def __init__(self, root, mode):
        self.root = root
        self.mode = mode
        self._blobs = {}
        self._cache = {}
        self._lexed = {}
        if mode == 'walk':
            paths = []
            for d, dirs, files in os.walk(root):
                dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS)
                for f in files:
                    full = os.path.join(d, f)
                    rel = os.path.relpath(full, root).replace(os.sep, '/')
                    if not os.path.islink(full):
                        paths.append(rel)
        elif mode == 'tracked':
            out = _git(root, 'ls-files', '-z').decode('utf-8')
            paths = [p for p in out.split('\0') if p]
        elif mode == 'staged':
            out = _git(root, 'ls-files', '-s', '-z').decode('utf-8')
            paths = []
            for entry in out.split('\0'):
                if not entry:
                    continue
                meta, path = entry.split('\t', 1)
                fmode, blob, _ = meta.split(' ')
                if fmode in ('120000', '160000'):
                    continue
                self._blobs[path] = blob
                paths.append(path)
        else:
            raise ValueError(mode)
        self.paths = sorted(set(paths))
        self._set = set(self.paths)

    def has(self, path):
        return path in self._set

    def read(self, path):
        if path not in self._set or is_secret_name(path):
            return None
        if path not in self._cache:
            if self.mode == 'staged':
                data = _git(self.root, 'cat-file', 'blob', self._blobs[path])
            else:
                full = os.path.join(self.root, path)
                if os.path.islink(full) or not os.path.isfile(full):
                    data = None
                else:
                    with open(full, 'rb') as f:
                        data = f.read()
            self._cache[path] = data
        return self._cache[path]

    def text(self, path):
        data = self.read(path)
        if data is None or b'\0' in data:
            return None
        try:
            return data.decode('utf-8')
        except UnicodeDecodeError:
            return None

    def kind(self, path):
        # 'dart', 'ts', 'py', 'sh', 'config' or None (not scanned by
        # G3 to G6, G8 and G9). Markdown, docs/ and lockfiles are None.
        b = posixpath.basename(path)
        if path.endswith('.md') or path.startswith('docs/') or b in LOCKFILES:
            return None
        ext = posixpath.splitext(b)[1]
        if ext in CODE_EXT:
            return CODE_EXT[ext]
        if b in CONFIG_NAMES or ext in CONFIG_EXT:
            return 'config'
        if ext == '':
            text = self.text(path)
            first = text.split('\n', 1)[0] if text else ''
            if first.startswith('#!'):
                if 'python' in first:
                    return 'py'
                if first.rstrip().endswith(('sh', 'bash')):
                    return 'sh'
        return None

    def lexed(self, path):
        # A Lexed, or None when the file cannot be lexed (fail closed).
        if path not in self._lexed:
            text = self.text(path)
            fn = {'dart': lex.lex_dart, 'ts': lex.lex_ts,
                  'py': lex.lex_python, 'sh': lex.lex_shell}[self.kind(path)]
            try:
                self._lexed[path] = None if text is None else fn(text)
            except lex.LexError:
                self._lexed[path] = None
        return self._lexed[path]


def words(text):
    return len(text.replace('\\n', ' ').replace('\\t', ' ').split())


QUOTED = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
PLIST_STRING = re.compile(r'<string>(.*?)</string>', re.S)


def _line_at(text, pos):
    return text.count('\n', 0, pos) + 1


def config_strings(path, text):
    # (line, string) pairs: what counts as a string literal in config.
    b = posixpath.basename(path)
    out = []
    if b.endswith(('.plist', '.entitlements')):
        for m in PLIST_STRING.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    elif b.endswith(('.yaml', '.yml')):
        for n, line in enumerate(text.split('\n'), 1):
            body = re.sub(r'(^|\s)#.*$', '', line).strip()
            if body.startswith('- '):
                body = body[2:]
            key, sep, value = body.partition(': ')
            out.append((n, value if sep else body))
    elif b.endswith('.xcconfig'):
        for n, line in enumerate(text.split('\n'), 1):
            body = line.split('//', 1)[0]
            out.append((n, body.partition('=')[2]))
    else:
        for m in QUOTED.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    return out


SOURCES_LINE = re.compile(r'^([0-9a-f]{64})  (\S+)  (\S.*)$')


def parse_sources(src):
    # {path: (sha256, line)} and findings for malformed or repeated lines.
    entries = {}
    findings = []
    text = src.text(SOURCES) or ''
    for n, line in enumerate(text.split('\n'), 1):
        if not line.strip() or line.startswith('#'):
            continue
        m = SOURCES_LINE.match(line)
        if not m:
            findings.append(Finding(SOURCES, n, 'sources-malformed'))
        elif m.group(2) in entries:
            findings.append(Finding(SOURCES, n, 'sources-repeated'))
        else:
            entries[m.group(2)] = (m.group(1), n)
    return entries, findings
