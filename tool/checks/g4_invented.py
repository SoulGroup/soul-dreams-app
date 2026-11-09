# G4 invented only: no string literal of twelve words or more outside
# fixtures/invented-nights.json and app/lib/words/.
from guardlib import Finding, config_strings, words

CODE = 'G4'
NAME = 'invented only'
LIMIT = 12


def exempt(path):
    return path == 'fixtures/invented-nights.json' or path.startswith('app/lib/words/')


def check(src):
    findings = []
    for path in src.paths:
        kind = src.kind(path)
        if kind is None or exempt(path):
            continue
        if kind == 'config':
            pairs = config_strings(path, src.text(path) or '')
        else:
            lx = src.lexed(path)
            if lx is None:
                findings.append(Finding(path, 0, 'unlexable'))
                continue
            pairs = [(lit.line, lit.text) for lit in lx.lits]
        for line, text in pairs:
            if words(text) >= LIMIT:
                findings.append(Finding(path, line, 'long-literal'))
    return findings, []
