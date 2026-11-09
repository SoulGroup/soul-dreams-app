# G3 no literal words (app/lib/ only). A literal passed directly to
# Text, Text.rich or TextSpan, or as one of the named arguments below,
# is dreamer-facing and refused outside app/lib/words/. Any other
# literal of more than two words needs the not-dreamer-facing marker
# in a comment on a line the literal occupies.
import re

from guardlib import Finding, words

CODE = 'G3'
NAME = 'no literal words'
CALLS = ('Text', 'TextSpan')
NAMED = ('semanticsLabel', 'semanticLabel', 'tooltip', 'label', 'title', 'hintText')
MARK = re.compile(r'^//\s*not-dreamer-facing:\s*\S')


def in_scope(path):
    return (path.startswith('app/lib/') and path.endswith('.dart')
            and not path.startswith('app/lib/words/'))


def dreamer_facing(lit):
    last = lit.frame.rsplit('.', 1)[-1]
    return last in CALLS or lit.frame.endswith('Text.rich') or lit.named in NAMED


def check(src):
    findings = []
    for path in src.paths:
        if not in_scope(path):
            continue
        lx = src.lexed(path)
        if lx is None:
            findings.append(Finding(path, 0, 'unlexable'))
            continue
        marked = {c.line for c in lx.comments if MARK.match(c.text)}
        for lit in lx.lits:
            if dreamer_facing(lit):
                findings.append(Finding(path, lit.line, 'dreamer-literal'))
            elif words(lit.text) > 2 and not marked.intersection(
                    range(lit.line, lit.end_line + 1)):
                findings.append(Finding(path, lit.line, 'unmarked-literal'))
    return findings, []
