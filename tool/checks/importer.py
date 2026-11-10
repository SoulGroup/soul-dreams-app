# The import (docs/workflow.md, "Imports"; D32). Copies one file the
# owner names, at the sha256 its filing recorded, from the documents
# repository into this one, and records it in docs/source/SOURCES.
# Only the owner runs it, through tool/import.sh: Claude Code cannot
# read the documents repository (R6). On any doubt it refuses and
# writes nothing. It prints codes and paths, never a file's content.
# Usage: importer.py --docs DIR <documents path> <sha256> <ordinal>
# Exit 0 done (or unchanged), 1 refused, 2 internal error.
import os
import posixpath
import re
import subprocess
import sys
import tempfile
import unicodedata

HERE = os.path.dirname(os.path.abspath(__file__))
TOP = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)

from guardlib import CSV, LISTS, SOURCES, report, sha256  # noqa: E402
import import_rows  # noqa: E402

# Each kind says where its files may land. Later kinds (the model's
# instructions in server/instructions/, the lens sections with their
# own guard) are new rows here and in import_rows.py (D32).
KINDS = {
    'copy': lambda dest: dest.startswith('docs/source/') and dest.endswith('.md')
    and dest.count('/') == 2 and dest != SOURCES,
    'words': lambda dest: dest == CSV,
    'lists': lambda dest: dest == LISTS,
}
REFUSED_NAMES = ('privacy-ethics-safety.md',)
HEX = re.compile(r'^[0-9a-f]{64}$')
SOURCES_LINE = re.compile(r'^([0-9a-f]{64})  (\S+)  (\S.*)$')
HEADER = ('# Every imported file: its sha256, path here and filing.\n'
          '# Written by tool/import.sh only. Never edited by hand.\n')


class Refused(Exception):
    def __init__(self, code):
        Exception.__init__(self, code)
        self.code = code


def git(where, *args):
    # No GIT_* variable: GIT_DIR and its kin would point the checks at
    # another repository than the one named (Task 1a, review note 2).
    env = {k: v for k, v in os.environ.items() if not k.startswith('GIT_')}
    r = subprocess.run(('git', '-C', where) + args, capture_output=True, env=env)
    if r.returncode != 0:
        return None
    return r.stdout


def on_main():
    # Compared as the full ref, so a tag named main cannot hide it; a
    # detached HEAD at main's own commit counts as main (Task 1a, note 1).
    ref = git(TOP, 'symbolic-ref', '-q', 'HEAD')
    if ref == b'refs/heads/main\n':
        return True
    if ref is None:
        head = git(TOP, 'rev-parse', '--verify', '-q', 'HEAD')
        return head is not None and head == git(TOP, 'rev-parse', '--verify', '-q',
                                                'refs/heads/main')
    return False


def check_args(path, digest, ordinal):
    if not HEX.match(digest):
        raise Refused('bad-hash')
    # Controls (C0, DEL, C1) and the Unicode line and paragraph separators.
    if (not ordinal or ordinal != ordinal.strip()
            or any(unicodedata.category(c) in ('Cc', 'Zl', 'Zp') for c in ordinal)):
        raise Refused('bad-ordinal')
    parts = path.split('/')
    if path.startswith('/') or '\\' in path or any(p in ('', '.', '..') for p in parts):
        raise Refused('bad-path')
    if 'restricted' in parts or parts[-1] in REFUSED_NAMES:
        raise Refused('refused-document')


def row_for(path):
    for docs_path, dest, kind in import_rows.ROWS:
        if docs_path == path:
            if kind not in KINDS or not KINDS[kind](dest):
                raise Refused('bad-row')
            return dest, kind
    raise Refused('not-allowed')


def check_docs(docs):
    top = git(docs, 'rev-parse', '--show-toplevel')
    if top is None or os.path.realpath(top.decode().strip()) != os.path.realpath(docs):
        raise Refused('docs-not-a-repository')
    if git(docs, 'status', '--porcelain', '--untracked-files=all') != b'':
        raise Refused('docs-dirty')
    if git(docs, 'fetch', '--quiet') is None:
        raise Refused('docs-fetch-failed')
    head = git(docs, 'rev-parse', 'HEAD')
    upstream = git(docs, 'rev-parse', '@{u}')
    if upstream is None:
        raise Refused('docs-no-upstream')
    if head != upstream:
        raise Refused('docs-unsynced')


def read_committed(docs, path):
    # The bytes of the file as committed at HEAD, never the working file.
    tree = git(docs, 'ls-tree', 'HEAD', '--', path)
    if not tree:
        raise Refused('not-tracked')
    mode = tree.split(b' ', 1)[0]
    if mode not in (b'100644', b'100755'):
        raise Refused('not-a-file')
    data = git(docs, 'cat-file', 'blob', 'HEAD:' + path)
    if data is None:
        raise Refused('not-tracked')
    return data


def read_sources():
    full = os.path.join(TOP, SOURCES)
    entries = {}
    if not os.path.exists(full):
        return entries
    with open(full, 'rb') as f:
        text = f.read().decode('utf-8')
    for line in text.split('\n'):
        if not line.strip() or line.startswith('#'):
            continue
        m = SOURCES_LINE.match(line)
        if not m or m.group(2) in entries:
            raise Refused('sources-malformed')
        entries[m.group(2)] = (m.group(1), m.group(3))
    return entries


def write_atomic(rel, data):
    full = os.path.join(TOP, rel)
    folder = os.path.dirname(full)
    os.makedirs(folder, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=folder, prefix='.import-')
    try:
        with os.fdopen(fd, 'wb') as f:
            f.write(data)
        os.replace(tmp, full)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def sources_text(entries):
    lines = [HEADER]
    for path in sorted(entries):
        digest, ordinal = entries[path]
        lines.append('%s  %s  %s\n' % (digest, path, ordinal))
    return ''.join(lines).encode('utf-8')


def run(docs, path, digest, ordinal):
    check_args(path, digest, ordinal)
    dest, kind = row_for(path)
    if git(TOP, 'rev-parse', '--git-dir') is None:
        raise Refused('app-not-a-repository')
    if on_main():
        raise Refused('on-main')
    check_docs(docs)
    data = read_committed(docs, path)
    if sha256(data) != digest:
        raise Refused('hash-mismatch')
    if b'\0' in data:
        raise Refused('not-text')
    try:
        data.decode('utf-8')
    except UnicodeDecodeError:
        raise Refused('not-text')
    entries = read_sources()
    full = os.path.join(TOP, dest)
    if entries.get(dest) == (digest, ordinal) and os.path.isfile(full):
        with open(full, 'rb') as f:
            if f.read() == data:
                report('import: unchanged ' + dest)
                return kind
    entries[dest] = (digest, ordinal)
    write_atomic(dest, data)
    write_atomic(SOURCES, sources_text(entries))
    report('import: hash ok, copied ' + dest)
    report('import: recorded in ' + SOURCES)
    return kind


def main(argv):
    if len(argv) != 5 or argv[0] != '--docs':
        report('import: refused usage')
        return 1
    try:
        run(argv[1], argv[2], argv[3], argv[4])
    except Refused as e:
        report('import: refused ' + e.code)
        return 1
    report('import: review git status, then commit')
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception as e:  # never print a message: it could quote a file
        report('import: internal error ' + type(e).__name__)
        sys.exit(2)
