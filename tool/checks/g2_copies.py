# G2 copies: every file in docs/source/ is listed in SOURCES with its
# sha256 and matches it. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside any file in docs/source/. Armed or
# not, no tracked path anywhere may be privacy-ethics-safety.md or sit in
# a folder named restricted (D32 Q18): those never leave the documents.
# The fonts (D49 a), armed or not: every file in the fonts folder is
# listed in its fingerprints file with its sha256, and matches it.
import re

from guardlib import (CSV, FINGERPRINTS, FONTS, LISTS, MARKER, SOURCES, Finding, parse_sources,
                      sha256)

CODE = 'G2'
NAME = 'copies'
DIR = 'docs/source/'
REFUSED_NAMES = ('privacy-ethics-safety.md',)
# shasum -a 256's own line: the digest, two spaces, a plain file name.
FINGERPRINT = re.compile(r'^([0-9a-f]{64})  ([A-Za-z0-9._-]+)$')


def refused_document(path):
    parts = path.split('/')
    return parts[-1] in REFUSED_NAMES or 'restricted' in parts[:-1]


def font_findings(src):
    fonts = [p for p in src.paths if p.startswith(FONTS) and p != FINGERPRINTS]
    if not src.has(FINGERPRINTS):
        return [Finding(FINGERPRINTS, 0, 'no-fingerprints')] if fonts else []
    listed = {}
    findings = []
    for n, line in enumerate((src.text(FINGERPRINTS) or '').split('\n'), 1):
        if not line:
            continue
        m = FINGERPRINT.match(line)
        if not m or FONTS + m.group(2) in listed:
            findings.append(Finding(FINGERPRINTS, n, 'fingerprints-malformed'))
            continue
        listed[FONTS + m.group(2)] = m.group(1)
    for path in fonts:
        if path not in listed:
            findings.append(Finding(path, 0, 'font-unlisted'))
        elif sha256(src.read(path) or b'') != listed[path]:
            findings.append(Finding(path, 0, 'font-hash-mismatch'))
    for path in sorted(listed):
        if not src.has(path):
            findings.append(Finding(path, 0, 'font-missing'))
    return findings


def check(src):
    refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
    refused += font_findings(src)
    in_dir = [p for p in src.paths if p.startswith(DIR)]
    if src.has(MARKER):
        if in_dir:
            return refused + [Finding(p, 0, 'marker-with-sources') for p in in_dir], []
        if refused:
            return refused, []
        return [], ['NOT ARMED (awaiting import)']
    if not src.has(SOURCES):
        return refused + [Finding(SOURCES, 0, 'no-sources')], []
    entries, findings = parse_sources(src)
    findings = refused + findings
    for path, (digest, line) in sorted(entries.items()):
        if path.startswith(DIR):
            if not src.has(path):
                findings.append(Finding(path, 0, 'missing'))
            elif sha256(src.read(path)) != digest:
                findings.append(Finding(path, 0, 'hash-mismatch'))
        elif path not in (CSV, LISTS):
            findings.append(Finding(SOURCES, line, 'unknown-path'))
    for path in in_dir:
        if path != SOURCES and path not in entries:
            findings.append(Finding(path, 0, 'unlisted'))
    return findings, []
