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
# The words the generator makes (R1; D32). G1 proves each one is exactly
# the generator's output; G0 and G4 read this list too.
WORDS_ASSETS = 'app/assets/words/'
WORDS_LIB = 'app/lib/words/'
LINES = 'app/lib/words/lines.g.dart'
LIST_WORDS = 'app/lib/words/lists.g.dart'
WORDS_XCCONFIG = 'app/ios/Flutter/words.g.xcconfig'
STRINGS_EN = 'app/ios/Runner/en.lproj/InfoPlist.strings'
STRINGS_SV = 'app/ios/Runner/sv.lproj/InfoPlist.strings'
# The pending lines (D57 Q11, D58 Q11): given and approved, not yet filed.
# The owner writes the file and its fingerprint; never Claude Code.
PENDING_CSV = 'app/assets/words/pending-lines.csv'
PENDING_FINGERPRINT = 'app/assets/words/pending-fingerprint.txt'
PENDING_DART = 'app/lib/words/pending.g.dart'
GENERATED = (LINES, LIST_WORDS, WORDS_XCCONFIG, STRINGS_EN, STRINGS_SV, PENDING_DART)
# shasum -a 256's own line: the digest, two spaces, a plain file name.
FINGERPRINT = re.compile(r'^([0-9a-f]{64})  ([A-Za-z0-9._-]+)$')
# The design values (D49 a): designgen makes TOKENS from DESIGN, and G1
# proves it.
DESIGN = 'docs/source/design-system.md'
TOKENS = 'app/lib/design/tokens.g.dart'
# The fonts (D49 a): every file here is listed in FINGERPRINTS with its
# sha256, which G2 proves; G0 knows .txt files here only.
FONTS = 'app/assets/fonts/'
FINGERPRINTS = 'app/assets/fonts/fingerprints.txt'

CODE_EXT = {'.dart': 'dart', '.ts': 'ts', '.js': 'ts', '.mjs': 'ts', '.cjs': 'ts',
            '.swift': 'swift', '.py': 'py', '.sh': 'sh'}
CONFIG_EXT = ('.json', '.yaml', '.yml', '.plist', '.entitlements', '.pbxproj',
              '.xcconfig', '.xcscheme',
              # Flutter's iOS project (scaffold-2-app, D20 Q13). XML, an
              # XML plist, and a header with no lexer: read whole.
              '.xcworkspacedata', '.xcsettings', '.storyboard', '.h')
# Config known by its whole name: FVM's pin (JSON) and Flutter's
# project record (YAML). Neither has an extension (D20 Q13).
CONFIG_NAMES = ('.fvmrc', '.metadata')
SHELLS = ('sh', 'bash', 'dash', 'zsh')
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
    b = posixpath.basename(path).lower()
    return (b == '.env' or b.startswith('.env.')
            or b.endswith(('.p8', '.pem', '.p12', '.mobileprovision')))


def sha256(data):
    return hashlib.sha256(data).hexdigest()


def _git(root, *args):
    r = subprocess.run(('git',) + args, cwd=root, capture_output=True)
    if r.returncode != 0:
        raise RuntimeError('git')
    return r.stdout


def interpreter(first):
    # The program a '#!' line names: env, its flags and its VAR=value
    # settings are skipped, and a path is read by its last part.
    words = first[2:].split()
    if words and posixpath.basename(words[0]) == 'env':
        words = [w for w in words[1:] if not w.startswith('-') and '=' not in w]
    return posixpath.basename(words[0]) if words else ''


class Source:
    # mode 'walk': every file under root (the guard tests use this).
    # mode 'tracked': the files git tracks, read from the working tree.
    # mode 'staged': the index, the snapshot a commit would record.
    # A path that is not valid UTF-8 cannot be checked: it is left out
    # of paths and becomes the finding 'bad-path' in findings.
    def __init__(self, root, mode):
        self.root = root
        self.mode = mode
        self.findings = []
        self._blobs = {}
        self._cache = {}
        self._lexed = {}
        paths = []
        if mode == 'walk':
            for d, dirs, files in os.walk(root):
                dirs[:] = sorted(x for x in dirs if x not in SKIP_DIRS)
                for f in files:
                    full = os.path.join(d, f)
                    rel = os.path.relpath(full, root).replace(os.sep, '/')
                    rel = self._name(rel.encode('utf-8', 'surrogateescape'))
                    if rel is not None and not os.path.islink(full):
                        paths.append(rel)
        elif mode == 'tracked':
            for raw in _git(root, 'ls-files', '-z').split(b'\0'):
                path = self._name(raw) if raw else None
                if path is not None:
                    paths.append(path)
        elif mode == 'staged':
            for entry in _git(root, 'ls-files', '-s', '-z').split(b'\0'):
                if not entry:
                    continue
                meta, raw = entry.split(b'\t', 1)
                fmode, blob, _ = meta.decode('ascii').split(' ')
                path = self._name(raw)
                if path is None or fmode in ('120000', '160000'):
                    continue
                self._blobs[path] = blob
                paths.append(path)
        else:
            raise ValueError(mode)
        self.paths = sorted(set(paths))
        self._set = set(self.paths)

    def _name(self, raw):
        try:
            return raw.decode('utf-8')
        except UnicodeDecodeError:
            shown = raw.decode('utf-8', 'backslashreplace')
            self.findings.append(Finding(shown, 0, 'bad-path'))
            return None

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
        # 'dart', 'ts', 'swift', 'py', 'sh', 'config' or None (not
        # scanned by G3 to G6, G8 and G9). Markdown and lockfiles are
        # None; code under docs/ is scanned like code anywhere else.
        # G0 refuses a None file unless its kind is listed as unscanned.
        b = posixpath.basename(path)
        ext = posixpath.splitext(b)[1].lower()
        if ext == '.md' or b in LOCKFILES:
            return None
        if ext in CODE_EXT:
            return CODE_EXT[ext]
        if ext in CONFIG_EXT or b in CONFIG_NAMES:
            return 'config'
        if ext == '':
            text = self.text(path)
            first = text.split('\n', 1)[0] if text else ''
            if first.startswith('#!'):
                prog = interpreter(first)
                if prog in SHELLS:
                    return 'sh'
                if prog.startswith('python'):
                    return 'py'
                if prog == 'node':
                    return 'ts'
        return None

    def lexed(self, path):
        # A Lexed, or None when the file cannot be lexed (fail closed).
        # Any exception from a lexer, RecursionError included, is None.
        if path not in self._lexed:
            text = self.text(path)
            fn = {'dart': lex.lex_dart, 'ts': lex.lex_ts, 'swift': lex.lex_swift,
                  'py': lex.lex_python, 'sh': lex.lex_shell}[self.kind(path)]
            try:
                self._lexed[path] = None if text is None else fn(text)
            except Exception:
                self._lexed[path] = None
        return self._lexed[path]


def words(text):
    return len(text.replace('\\n', ' ').replace('\\t', ' ').split())


QUOTED = re.compile(r'"((?:[^"\\\n]|\\.)*)"')
PLIST_STRING = re.compile(r'<string>(.*?)</string>', re.S)
YAML_BLOCK = re.compile(r'[|>][-+0-9]*')


def _line_at(text, pos):
    return text.count('\n', 0, pos) + 1


def _indent(line):
    return len(line) - len(line.lstrip(' '))


def yaml_uncomment(line):
    # The line less its comment. '#' starts a comment at the start of
    # the line or after a space or tab, and only outside quotes.
    quote = ''
    for k, ch in enumerate(line):
        if quote:
            if ch == quote:
                quote = ''
        elif ch in '\'"':
            quote = ch
        elif ch == '#' and (k == 0 or line[k - 1] in ' \t'):
            return line[:k]
    return line


def yaml_strings(text):
    # (line, string) pairs. A block scalar (| or >) is joined into one
    # string, given the line of its key; its lines hold no comments.
    out = []
    lines = text.split('\n')
    k = 0
    while k < len(lines):
        body = yaml_uncomment(lines[k]).strip()
        if body.startswith('- '):
            body = body[2:]
        key, sep, value = body.partition(': ')
        value = value.strip() if sep else body
        if YAML_BLOCK.fullmatch(value):
            parts = []
            j = k + 1
            while j < len(lines) and (not lines[j].strip()
                                      or _indent(lines[j]) > _indent(lines[k])):
                parts.append(lines[j].strip())
                j += 1
            out.append((k + 1, ' '.join(p for p in parts if p)))
            k = j
            continue
        out.append((k + 1, value))
        k += 1
    return out


def config_strings(path, text):
    # (line, string) pairs: what counts as a string literal in config.
    b = posixpath.basename(path)
    out = []
    if b.endswith(('.plist', '.entitlements', '.xcsettings')):
        for m in PLIST_STRING.finditer(text):
            out.append((_line_at(text, m.start()), m.group(1)))
    elif b.endswith(('.yaml', '.yml')) or b == '.metadata':
        out = yaml_strings(text)
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
