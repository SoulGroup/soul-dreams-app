# G2 copies: every file in docs/source/ is listed in SOURCES with its
# sha256 and matches it. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside any file in docs/source/. Armed or
# not, no tracked path anywhere may be privacy-ethics-safety.md or sit in
# a folder named restricted (D32 Q18): those never leave the documents.
from guardlib import CSV, LISTS, MARKER, SOURCES, Finding, parse_sources, sha256

CODE = 'G2'
NAME = 'copies'
DIR = 'docs/source/'
REFUSED_NAMES = ('privacy-ethics-safety.md',)


def refused_document(path):
    parts = path.split('/')
    return parts[-1] in REFUSED_NAMES or 'restricted' in parts[:-1]


def check(src):
    refused = [Finding(p, 0, 'refused-document') for p in src.paths if refused_document(p)]
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
