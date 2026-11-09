# Runs the standing guards. Usage:
#   python3 -I -B tool/checks/guards.py            the tracked files
#   python3 -I -B tool/checks/guards.py --staged   the index (pre-commit)
#   add --only G3 (repeatable) to run some guards; --walk DIR for a folder.
# Exit 0 when every guard passes, 1 on findings, 2 on an internal error.
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import guardlib  # noqa: E402
import g0_kinds, g1_words, g2_copies, g3_literals, g4_invented, g5_logging  # noqa: E402
import g6_identifiers, g7_secrets, g8_export, g9_hosts  # noqa: E402

GUARDS = [g0_kinds, g1_words, g2_copies, g3_literals, g4_invented, g5_logging,
          g6_identifiers, g7_secrets, g8_export, g9_hosts]
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def main(argv):
    mode, root, only = 'tracked', ROOT, set()
    args = list(argv)
    while args:
        a = args.pop(0)
        if a == '--staged':
            mode = 'staged'
        elif a == '--walk' and args:
            mode, root = 'walk', args.pop(0)
        elif a == '--only' and args:
            only.add(args.pop(0))
        else:
            guardlib.report('guards: unknown argument')
            return 2
    for code in sorted(only - {g.CODE for g in GUARDS}):
        # A typo must not run nothing and pass (final review, F1).
        guardlib.report('guards: unknown guard ' + code)
        return 2
    try:
        src = guardlib.Source(root, mode)
        failed = 0
        for f in src.findings:
            guardlib.report('source %s:%d %s' % (f.path, f.line, f.reason))
        if src.findings:
            guardlib.report('source: FAIL')
            failed += 1
        for g in GUARDS:
            if only and g.CODE not in only:
                continue
            findings, notes = g.check(src)
            for note in notes:
                guardlib.report(g.CODE + ' ' + g.NAME + ': ' + note)
            for f in sorted(findings, key=lambda f: f.key()):
                guardlib.report('%s %s:%d %s' % (g.CODE, f.path, f.line, f.reason))
            guardlib.report('%s %s: %s' % (g.CODE, g.NAME, 'FAIL' if findings else 'ok'))
            failed += 1 if findings else 0
    except Exception as e:  # never echo a message: it may quote a file
        guardlib.report('guards: internal error ' + type(e).__name__)
        return 2
    guardlib.report('guards (%s): %s' % (mode, 'FAILED' if failed else 'all passed'))
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
