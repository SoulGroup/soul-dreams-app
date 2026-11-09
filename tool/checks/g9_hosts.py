# G9 hosts: no web address scheme (http, https, ws, wss; any case)
# outside the two hosts files and tests. Code is read without its
# comments; config is read whole, less XML DOCTYPE lines.
import re

from guardlib import Finding

CODE = 'G9'
NAME = 'hosts'
EXEMPT = ('app/lib/core/hosts.dart', 'server/src/hosts.ts')
TESTS = ('app/test/', 'app/integration_test/', 'server/test/', 'tool/checks/tests/')
SCHEME = re.compile('(?i)(?<![a-z])(?:https?|wss?)' + ':' + '//')


def check(src):
    findings = []
    for path in src.paths:
        kind = src.kind(path)
        if kind is None or path in EXEMPT or path.startswith(TESTS):
            continue
        if kind == 'config':
            text = src.text(path) or ''
            lines = ['' if l.lstrip().startswith('<!DOCTYPE') else l
                     for l in text.split('\n')]
            text = '\n'.join(lines)
        else:
            lx = src.lexed(path)
            if lx is None:
                findings.append(Finding(path, 0, 'unlexable'))
                continue
            text = lx.without_comments()
        for m in SCHEME.finditer(text):
            findings.append(Finding(path, text.count('\n', 0, m.start()) + 1, 'host-literal'))
    return findings, []
