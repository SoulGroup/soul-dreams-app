# G5 logging: none of the writers below in code (strings and comments
# are not code) or in config, outside the two safe loggers and the
# checks' own writer. Math.log( computes a logarithm and is allowed.
import re

from guardlib import Finding

CODE = 'G5'
NAME = 'logging'
EXEMPT = ('app/lib/core/safe_log.dart', 'server/src/safe-log.ts',
          'tool/checks/guardlib.py')
B = r'(?<![\w$])'
WRITERS = [
    ('print', re.compile(B + r'print\s*\(')),
    ('debugPrint', re.compile(B + r'debugPrint\s*\(')),
    ('log', re.compile(B + r'log\s*\(')),
    ('console', re.compile(B + r'console\s*\.')),
    ('stdout.write', re.compile(B + r'stdout\s*\.\s*write')),
    ('stderr.write', re.compile(B + r'stderr\s*\.\s*write')),
    ('dumpErrorToConsole', re.compile(B + r'FlutterError\s*\.\s*dumpErrorToConsole')),
]
MATH = re.compile(r'(?<![\w$])Math\s*\.\s*$')


def scan(path, text, findings):
    for name, rx in WRITERS:
        for m in rx.finditer(text):
            if name == 'log' and MATH.search(text, 0, m.start()):
                continue
            line = text.count('\n', 0, m.start()) + 1
            findings.append(Finding(path, line, 'writer-' + name))


def check(src):
    findings = []
    for path in src.paths:
        kind = src.kind(path)
        if kind is None or path in EXEMPT:
            continue
        if kind == 'config':
            scan(path, src.text(path) or '', findings)
            continue
        lx = src.lexed(path)
        if lx is None:
            findings.append(Finding(path, 0, 'unlexable'))
            continue
        scan(path, lx.code, findings)
    return findings, []
