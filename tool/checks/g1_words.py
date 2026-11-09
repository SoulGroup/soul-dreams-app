# G1 words: the register's and the lists' hashes match SOURCES, and
# lines.g.dart is what the generator makes. NOT ARMED while the
# awaiting-import marker exists; refuses the marker beside SOURCES.
from guardlib import CSV, LISTS, MARKER, SOURCES, Finding, parse_sources, sha256

CODE = 'G1'
NAME = 'words'
LINES = 'app/lib/words/lines.g.dart'


def check(src):
    marker = src.has(MARKER)
    if marker and src.has(SOURCES):
        return [Finding(MARKER, 0, 'marker-with-sources')], []
    if marker:
        return [], ['NOT ARMED (awaiting import)']
    if not src.has(SOURCES):
        return [Finding(SOURCES, 0, 'no-sources')], []
    entries, findings = parse_sources(src)
    for path in (CSV, LISTS):
        if path not in entries:
            findings.append(Finding(path, 0, 'unlisted'))
        elif not src.has(path):
            findings.append(Finding(path, 0, 'missing'))
        elif sha256(src.read(path)) != entries[path][0]:
            findings.append(Finding(path, 0, 'hash-mismatch'))
    # Branch 3 builds the generator and replaces this line with the
    # comparison of LINES against the generator's output.
    findings.append(Finding(LINES, 0, 'generator-not-built'))
    return findings, []
