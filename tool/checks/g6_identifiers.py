# G6 identifiers: none of the four names below, in any spelling that
# differs only by case, underscores or hyphens. Built from pieces so
# this file does not refuse itself.
from guardlib import Finding

CODE = 'G6'
NAME = 'identifiers'
NAMES = ['client_' + 'reference_id', 'identifier' + 'ForVendor',
         'advertising' + 'Identifier', 'device' + '_info']


def norm(s):
    return s.replace('_', '').replace('-', '').lower()


NEEDLES = [norm(n) for n in NAMES]


def check(src):
    findings = []
    for path in src.paths:
        if src.kind(path) is None:
            continue
        text = src.text(path)
        if text is None:
            continue
        for n, line in enumerate(text.split('\n'), 1):
            flat = norm(line)
            for needle in NEEDLES:
                if needle in flat:
                    findings.append(Finding(path, n, 'identifier'))
    return findings, []
