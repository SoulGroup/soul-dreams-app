# G1 words: the register's and the lists' hashes match SOURCES, and the
# generated words (guardlib.GENERATED) are exactly what wordsgen makes
# from them. Nothing else may sit in the two words folders. The design
# values (D49 a): TOKENS is exactly what designgen makes from DESIGN,
# whose hash G2 proves. The pending lines (D57 Q11), when the owner has
# written them: the file matches its fingerprint, and pending.g.dart is
# made from it. NOT ARMED while the awaiting-import marker exists;
# refuses the marker beside SOURCES.
import designgen
import wordsgen
from guardlib import (CSV, DESIGN, FINGERPRINT, GENERATED, LISTS, MARKER, PENDING_CSV,
                      PENDING_FINGERPRINT, SOURCES, TOKENS, WORDS_ASSETS, WORDS_LIB, Finding,
                      parse_sources, sha256)

CODE = 'G1'
NAME = 'words'
KNOWN = (CSV, LISTS, PENDING_CSV, PENDING_FINGERPRINT) + GENERATED
WHERE = {wordsgen.REGISTER: CSV, wordsgen.LIST_FILE: LISTS, wordsgen.PENDING: PENDING_CSV}


def pending_findings(src):
    # The pending file and its fingerprint come together or not at all.
    # The fingerprint is one shasum line naming the file.
    has_csv, has_print = src.has(PENDING_CSV), src.has(PENDING_FINGERPRINT)
    if not has_csv and not has_print:
        return []
    if not has_print:
        return [Finding(PENDING_CSV, 0, 'pending-unfingerprinted')]
    if not has_csv:
        return [Finding(PENDING_FINGERPRINT, 0, 'pending-missing')]
    text = src.text(PENDING_FINGERPRINT) or ''
    m = FINGERPRINT.match(text[:-1]) if text.endswith('\n') else None
    if not m or m.group(2) != PENDING_CSV.rsplit('/', 1)[1]:
        return [Finding(PENDING_FINGERPRINT, 1, 'fingerprint-malformed')]
    if sha256(src.read(PENDING_CSV)) != m.group(1):
        return [Finding(PENDING_CSV, 0, 'hash-mismatch')]
    return []


def design_findings(src):
    if not src.has(DESIGN):
        return [Finding(DESIGN, 0, 'missing')]
    try:
        outputs = designgen.generate(src.read(DESIGN))
    except designgen.DesignError as e:
        return [Finding(DESIGN, e.line, 'generator-refused:' + e.code)]
    if not src.has(TOKENS):
        return [Finding(TOKENS, 0, 'generated-missing')]
    if src.read(TOKENS) != outputs[TOKENS]:
        return [Finding(TOKENS, 0, 'generated-differs')]
    return []


def check(src):
    marker = src.has(MARKER)
    if marker and src.has(SOURCES):
        return [Finding(MARKER, 0, 'marker-with-sources')], []
    if marker:
        return [], ['NOT ARMED (awaiting import)']
    if not src.has(SOURCES):
        return [Finding(SOURCES, 0, 'no-sources')], []
    design = design_findings(src)
    entries, findings = parse_sources(src)
    for path in (CSV, LISTS):
        if path not in entries:
            findings.append(Finding(path, 0, 'unlisted'))
        elif not src.has(path):
            findings.append(Finding(path, 0, 'missing'))
        elif sha256(src.read(path)) != entries[path][0]:
            findings.append(Finding(path, 0, 'hash-mismatch'))
    findings += pending_findings(src)
    unknown = [Finding(p, 0, 'words-unknown-file') for p in src.paths
               if p.startswith((WORDS_ASSETS, WORDS_LIB)) and p not in KNOWN]
    if findings:
        return findings + unknown + design, []
    try:
        pending = src.read(PENDING_CSV) if src.has(PENDING_CSV) else None
        outputs = wordsgen.generate(src.read(CSV), src.read(LISTS), pending)
    except wordsgen.WordsError as e:
        return [Finding(WHERE[e.source], e.row, 'generator-refused:' + e.code)] + unknown + design, []
    for path in GENERATED:
        if not src.has(path):
            findings.append(Finding(path, 0, 'generated-missing'))
        elif src.read(path) != outputs[path]:
            findings.append(Finding(path, 0, 'generated-differs'))
    return findings + unknown + design, []
