# G0 file kinds: every file must be of a kind the guards know, so that
# nothing goes unread by mistake. Known: guardlib's code kinds, config,
# and the unscanned types, names and paths below, each only when it
# reads as UTF-8 text; and binary files (a NUL byte). A file with an
# unknown '#!' interpreter, or of any other kind, is refused as
# unknown-kind. A branch that brings a new kind of file extends these
# lists, and the owner approves the change at the prompt. D49 a: .txt is
# known in the fonts folder only (the licences and the fingerprints).
import posixpath

from guardlib import FONTS, LOCKFILES, MARKER, SOURCES, STRINGS_EN, STRINGS_SV, Finding

CODE = 'G0'
NAME = 'file kinds'
UNSCANNED_EXT = ('.md', '.csv')
UNSCANNED_NAMES = ('.gitignore',) + LOCKFILES
# The two generated InfoPlist.strings, by exact path: G1 proves them (D32).
UNSCANNED_PATHS = (SOURCES, MARKER, STRINGS_EN, STRINGS_SV)


def known(src, path):
    if src.kind(path) is not None and src.text(path) is None:
        # Code and config are read as text. One that is not UTF-8 with no
        # NUL byte is skipped by G6 and G7, and config is read as empty by
        # G4, G5 and G9: refused (fail closed; Task 2d, D1 and D3).
        return False
    if src.kind(path) is not None:
        return True
    b = posixpath.basename(path)
    ext = posixpath.splitext(b)[1].lower()
    data = src.read(path)
    if ext == '' and data is not None and data.startswith(b'#!'):
        return False
    fonts_txt = ext == '.txt' and posixpath.dirname(path) + '/' == FONTS
    if fonts_txt or ext in UNSCANNED_EXT or b in UNSCANNED_NAMES or path in UNSCANNED_PATHS:
        # Known only as UTF-8 text with no NUL byte. Otherwise no guard
        # can read it (G7 skips it), so it is refused (fail closed).
        return src.text(path) is not None
    # A binary file: one with a NUL byte. Other text is not known.
    return data is not None and b'\0' in data


def check(src):
    return [Finding(p, 0, 'unknown-kind') for p in src.paths if not known(src, p)], []
