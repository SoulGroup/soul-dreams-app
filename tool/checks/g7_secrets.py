# G7 secrets: no secret-named file anywhere, and no key-shaped string
# in any tracked text file, Markdown included. Exempt: docs/source/SOURCES,
# and lines naming an integrity field in a lockfile.
import math
import posixpath
import re

from guardlib import LOCKFILES, SOURCES, Finding, is_secret_name

CODE = 'G7'
NAME = 'secrets'
DASHES = '-' * 5
SHAPES = [
    ('aws-key', re.compile(r'\b(?:AKIA|ASIA)[0-9A-Z]{16}\b')),
    ('pem-block', re.compile(DASHES + r'BEGIN [A-Z0-9 ]+' + DASHES)),
    ('sk-token', re.compile(r'\bsk[-_](?:live[-_]|test[-_]|ant[-_])?[A-Za-z0-9_-]{20,}')),
    ('github-token', re.compile(r'\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,})')),
    ('slack-token', re.compile(r'\bxox[abprs]-[A-Za-z0-9-]{10,}')),
    ('google-key', re.compile(r'\bAIza[0-9A-Za-z_-]{35}')),
    ('jwt', re.compile(r'\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}')),
    ('assigned-secret', re.compile(
        r'(?i)(?:api[_-]?key|secret|token|passw(?:or)?d)[A-Za-z0-9_-]*["\']?\s*[:=]\s*'
        r'["\']?(?=[A-Za-z0-9+/_=-]*[0-9])(?=[A-Za-z0-9+/_=-]*[A-Za-z])[A-Za-z0-9+/_=-]{16,}')),
]
RUN = re.compile(r'[A-Za-z0-9+_=-]{32,}')
HEX = re.compile(r'[0-9a-fA-F]+')


def entropy(s):
    counts = {}
    for c in s:
        counts[c] = counts.get(c, 0) + 1
    return -sum(k / len(s) * math.log2(k / len(s)) for k in counts.values())


def high_entropy(run):
    return (not HEX.fullmatch(run)
            and any(c.isupper() for c in run) and any(c.islower() for c in run)
            and any(c.isdigit() for c in run) and entropy(run) >= 4.2)


def check(src):
    findings = []
    for path in src.paths:
        if is_secret_name(path):
            findings.append(Finding(path, 0, 'secret-file'))
            continue
        if path == SOURCES:
            continue
        text = src.text(path)
        if text is None:
            continue
        lock = posixpath.basename(path) in LOCKFILES
        for n, line in enumerate(text.split('\n'), 1):
            if lock and 'integrity' in line:
                continue
            for name, rx in SHAPES:
                if rx.search(line):
                    findings.append(Finding(path, n, name))
            if any(high_entropy(m.group(0)) for m in RUN.finditer(line)):
                findings.append(Finding(path, n, 'high-entropy'))
    return findings, []
