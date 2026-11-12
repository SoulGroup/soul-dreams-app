# G2 copies: every file in docs/source/ is listed in SOURCES with its
# sha256 and matches it. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside any file in docs/source/. Armed or
# not, no tracked path anywhere may be privacy-ethics-safety.md or sit in
# a folder named restricted (D32 Q18): those never leave the documents.
# The fonts (D49 a) and the screenshots (D58), armed or not: every file
# in each folder is listed in its fingerprints file with its sha256, and
# matches it.
from guardlib import (CSV, FINGERPRINT, FINGERPRINTS, FONTS, LISTS, MARKER, SCREEN_PRINTS,
                      SCREENS, SOURCES, Finding, parse_sources, sha256)

CODE = 'G2'
NAME = 'copies'
DIR = 'docs/source/'
REFUSED_NAMES = ('privacy-ethics-safety.md',)


def refused_document(path):
    parts = path.split('/')
    return parts[-1] in REFUSED_NAMES or 'restricted' in parts[:-1]


def fingerprint_findings(src, folder, prints, what):
    files = [p for p in src.paths if p.startswith(folder) and p != prints]
    if not src.has(prints):
        return [Finding(prints, 0, 'no-fingerprints')] if files else []
    listed = {}
    findings = []
    for n, line in enumerate((src.text(prints) or '').split('\n'), 1):
        if not line:
            continue
        m = FINGERPRINT.match(line)
        if not m or folder + m.group(2) in listed:
            findings.append(Finding(prints, n, 'fingerprints-malformed'))
            continue
        listed[folder + m.group(2)] = m.group(1)
    for path in files:
        if path not in listed:
            findings.append(Finding(path, 0, what + '-unlisted'))
        elif sha256(src.read(path) or b'') != listed[path]:
            findings.append(Finding(path, 0, what + '-hash-mismatch'))
    for path in sorted(listed):
        if not src.has(path):
            findings.append(Finding(path, 0, what + '-missing'))
    return findings


def font_findings(src):
    return fingerprint_findings(src, FONTS, FINGERPRINTS, 'font')


def check(src):
    refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
    refused += font_findings(src)
    refused += fingerprint_findings(src, SCREENS, SCREEN_PRINTS, 'screen')
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
