# G1 words: the register's and the lists' hashes match SOURCES, and the
# generated words (guardlib.GENERATED) are exactly what wordsgen makes
# from them. Nothing else may sit in the two words folders. The design
# values (D49 a): TOKENS is exactly what designgen makes from DESIGN,
# whose hash G2 proves. NOT ARMED while the awaiting-import marker
# exists; refuses the marker beside SOURCES.
import designgen
import wordsgen
from guardlib import (CSV, DESIGN, GENERATED, LISTS, MARKER, SOURCES, TOKENS, WORDS_ASSETS,
                      WORDS_LIB, Finding, parse_sources, sha256)

CODE = 'G1'
NAME = 'words'
KNOWN = (CSV, LISTS) + GENERATED


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
    unknown = [Finding(p, 0, 'words-unknown-file') for p in src.paths
               if p.startswith((WORDS_ASSETS, WORDS_LIB)) and p not in KNOWN]
    if findings:
        return findings + unknown + design, []
    try:
        outputs = wordsgen.generate(src.read(CSV), src.read(LISTS))
    except wordsgen.WordsError as e:
        where = CSV if e.source == wordsgen.REGISTER else LISTS
        return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown + design, []
    for path in GENERATED:
        if not src.has(path):
            findings.append(Finding(path, 0, 'generated-missing'))
        elif src.read(path) != outputs[path]:
            findings.append(Finding(path, 0, 'generated-differs'))
    return findings + unknown + design, []
