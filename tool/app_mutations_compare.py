# The equivalence proof of D129, run by hand from the repository root:
# python3 -I -B tool/app_mutations_compare.py [--all] [--jobs N]
# Runs rows both ways, --serial (one at a time in app/ itself, as before
# D129) and parallel (each worker in its own copy), and compares every
# row's verdict. The sample: every tenth row, every row that breaks a
# file in ios/ or test/, and the rows below, built to survive or to fail
# their setup, each with the verdict it must get both ways. --all: every
# row, then the rows below. It prints each row that differs or misses
# its verdict, then the totals and each way's seconds. Exit 0 when every
# row is the same both ways and every verdict below is met, 1 otherwise.
import os
import sys
import time

TOOL = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, TOOL)

import app_mutations as m  # noqa: E402
from app_mutations import PATTERN, UNBROKEN, report  # noqa: E402


def row(code):
    return next(r for r in m.ROWS if r[0] == code)


# A1's test reads the journal's store and nothing below.
STORE = ('test/journal/journal_store_test.dart', 'deleting a night leaves nothing of it anywhere')

# (row, the verdict it must get both ways)
OWN = [(row(code), 'caught') for code in ('A1', 'A13', 'A481', 'A664')]
BUILT = [
    # A comment changed: nothing can fail.
    (('E1', 'lib/journal/journal_store.dart', '// The journal on the phone',
      '// The journal, on the phone') + STORE, 'SURVIVED'),
    # A real break, caught by its own test (A664) but not by this one,
    # which never reaches the file: only the named test counts.
    (('E2',) + row('A664')[1:4] + STORE, 'SURVIVED'),
    # A file that no longer compiles, which this test never imports.
    (('E3', row('A664')[1], row('A664')[2], '((((\n') + STORE, 'SURVIVED'),
    # The Swift file and a test file, broken as A13 and A481 break them.
    (('E4',) + row('A13')[1:4] + STORE, 'SURVIVED'),
    (('E5',) + row('A481')[1:4] + STORE, 'SURVIVED'),
    # The setup failures: no such text, the text twice, no such test.
    (('E6', 'lib/journal/journal_store.dart', 'no such text', 'x') + STORE, PATTERN),
    (('E7', 'lib/journal/journal_store.dart', "import '", "import  '") + STORE, PATTERN),
    (('E8', 'lib/journal/journal_store.dart', '// The journal on the phone', '// x',
      STORE[0], 'no test has this name'), UNBROKEN),
]


def sample(every):
    chosen = {r[0] for r, _ in OWN}
    rows = [r for i, r in enumerate(m.ROWS)
            if every or i % 10 == 0 or r[1].split('/')[0] in ('ios', 'test') or r[0] in chosen]
    return rows + [r for r, _ in BUILT]


def main(argv=()):
    argv = list(argv)
    every = '--all' in argv
    rest = [a for a in argv if a != '--all']
    if rest and not (len(rest) == 2 and rest[0] == '--jobs' and rest[1].isdigit()
                     and int(rest[1]) >= 1):
        report('app mutations compare: bad arguments')
        return 2
    jobs = int(rest[1]) if rest else m.default_jobs()
    rows = sample(every)
    expected = {r[0]: v for r, v in OWN + BUILT}
    start = time.monotonic()
    serial = [m.run_row(*r) for r in rows]
    middle = time.monotonic()
    parallel = m.run_parallel(rows, jobs)
    end = time.monotonic()
    same = 0
    for r, s, p in zip(rows, serial, parallel):
        want = expected.get(r[0])
        if s == p and want in (None, s):
            same += 1
        else:
            report('%s: serial %s, parallel %s, expected %s' % (r[0], s, p, want or 'the same'))
    report('serial %d s, parallel %d s, %d jobs' % (middle - start, end - middle, jobs))
    report('app mutations compare: %d rows, %d the same' % (len(rows), same))
    return 0 if same == len(rows) else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
