# G8 export: only main_founder.dart and main_dev.dart, files inside
# app/lib/founder/ and tests in app/test/founder/ may import, export or
# take part of a file in app/lib/founder/.
import posixpath
import re

from guardlib import Finding

CODE = 'G8'
NAME = 'export'
FOUNDER = 'app/lib/founder/'
ALLOWED = ('app/lib/main_founder.dart', 'app/lib/main_dev.dart')
ALLOWED_DIRS = (FOUNDER, 'app/test/founder/')
DIRECTIVE = re.compile(r'(?<![\w$.])(?:import|export|part)\b')


def into_founder(importer, uri):
    if uri.startswith('package:'):
        return uri[len('package:'):].partition('/')[2].startswith('founder/')
    if ':' in uri.split('/', 1)[0]:
        return False
    target = posixpath.normpath(posixpath.join(posixpath.dirname(importer), uri))
    return (target + '/').startswith(FOUNDER)


def check(src):
    findings = []
    for path in src.paths:
        if src.kind(path) != 'dart':
            continue
        if path in ALLOWED or path.startswith(ALLOWED_DIRS):
            continue
        lx = src.lexed(path)
        if lx is None:
            findings.append(Finding(path, 0, 'unlexable'))
            continue
        for m in DIRECTIVE.finditer(lx.code):
            end = lx.code.find(';', m.end())
            end = len(lx.code) if end < 0 else end
            for lit in lx.lits:
                if m.start() <= lit.pos < end and into_founder(path, lit.text):
                    findings.append(Finding(path, lit.line, 'founder-import'))
    return findings, []
