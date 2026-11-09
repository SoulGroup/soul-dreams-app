# G0 file kinds: every file must be of a kind the guards know, so that
# nothing goes unread by mistake. Known: guardlib's code kinds and
# config, binary files (a NUL byte), and the unscanned types, names and
# paths below when they read as UTF-8 text. A file with an
# unknown '#!' interpreter, or of any other kind, is refused as
# unknown-kind. A branch that brings a new kind of file extends these
# lists, and the owner approves the change at the prompt.
import posixpath

from guardlib import LOCKFILES, MARKER, SOURCES, Finding

CODE = 'G0'
NAME = 'file kinds'
UNSCANNED_EXT = ('.md', '.csv')
UNSCANNED_NAMES = ('.gitignore',) + LOCKFILES
UNSCANNED_PATHS = (SOURCES, MARKER)


def known(src, path):
    if src.kind(path) is not None:
        return True
    b = posixpath.basename(path)
    ext = posixpath.splitext(b)[1].lower()
    data = src.read(path)
    if ext == '' and data is not None and data.startswith(b'#!'):
        return False
    if ext in UNSCANNED_EXT or b in UNSCANNED_NAMES or path in UNSCANNED_PATHS:
        # Known only as UTF-8 text with no NUL byte. Otherwise no guard
        # can read it (G7 skips it), so it is refused (fail closed).
        return src.text(path) is not None
    # A binary file: one with a NUL byte. Other text is not known.
    return data is not None and b'\0' in data


def check(src):
    return [Finding(p, 0, 'unknown-kind') for p in src.paths if not known(src, p)], []
