import hashlib
import unittest

from helpers import GuardTest
import g1_words
import g2_copies
import designgen
import test_designgen as invented_design
import test_wordsgen as invented
import wordsgen
from guardlib import (DESIGN, GENERATED, LINES, PENDING_CSV, PENDING_DART, PENDING_FINGERPRINT,
                      TOKENS, WORDS_XCCONFIG)

MARKER = 'tool/checks/awaiting-import'
SOURCES = 'docs/source/SOURCES'
CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'
COPY = 'docs/source/handover.md'
FONTS_LIST = 'app/assets/fonts/fingerprints.txt'


def line(path, body, ordinal='C0-T item 1'):
    if isinstance(body, str):
        body = body.encode('utf-8')
    return hashlib.sha256(body).hexdigest() + '  ' + path + '  ' + ordinal + '\n'


def armed(csv_bytes=None, lists_bytes=None, generated=True, design=None):
    # An armed tree from an invented register and lists, with SOURCES
    # matching them and, when it can be made, the generated words; and an
    # invented Design System with its tokens (D49 a).
    c = csv_bytes if csv_bytes is not None else invented.register()
    l = lists_bytes if lists_bytes is not None else invented.lists()
    d = design if design is not None else invented_design.doc()
    files = {CSV: c, LISTS: l, DESIGN: d, SOURCES: line(CSV, c) + line(LISTS, l) + line(DESIGN, d)}
    if generated:
        files.update(wordsgen.generate(c, l))
    if design is None:
        files.update(designgen.generate(d))
    return files


class G1(GuardTest):
    guard = g1_words

    def test_marker_alone_is_not_armed(self):
        notes = self.passed({MARKER: 'x\n'})
        self.assertEqual(notes, ['NOT ARMED (awaiting import)'])

    def test_marker_with_sources_refuses(self):
        self.refused({MARKER: 'x\n', SOURCES: '# empty\n'}, 'marker-with-sources')

    def test_no_marker_no_sources_refuses(self):
        self.refused({}, 'no-sources')

    def test_words_hash_mismatch_refuses(self):
        files = {CSV: 'a,b\n', LISTS: 'l\n', SOURCES: line(CSV, 'changed\n') + line(LISTS, 'l\n')}
        found = self.refused(files, 'hash-mismatch')
        self.assertIn((CSV, 0, 'hash-mismatch'), found)
        self.assertNotIn((LISTS, 0, 'hash-mismatch'), found)

    def test_words_unlisted_refuses(self):
        self.refused({CSV: 'a\n', SOURCES: line(LISTS, 'l\n'), LISTS: 'l\n'}, 'unlisted')

    # Branch 3 (D32): the generator comparison replaces generator-not-built.
    def test_armed_with_generated_words_passes(self):
        self.passed(armed())

    def test_armed_without_generated_files_refuses(self):
        found = self.refused(armed(generated=False))
        self.assertEqual(found, sorted((p, 0, 'generated-missing') for p in GENERATED))

    def test_generated_differs_refuses(self):
        files = armed()
        files[LINES] = files[LINES] + b'// x\n'
        self.assertEqual(self.refused(files), [(LINES, 0, 'generated-differs')])

    def test_hand_edited_xcconfig_refuses(self):
        files = armed()
        files[WORDS_XCCONFIG] = files[WORDS_XCCONFIG].replace(b'= Name', b'= Other')
        self.assertEqual(self.refused(files), [(WORDS_XCCONFIG, 0, 'generated-differs')])

    def test_unknown_words_file_refuses(self):
        files = armed()
        files['app/lib/words/extra.dart'] = 'const s = 1;\n'
        files['app/assets/words/old.csv'] = 'a\n'
        self.assertEqual(self.refused(files),
                         [('app/assets/words/old.csv', 0, 'words-unknown-file'),
                          ('app/lib/words/extra.dart', 0, 'words-unknown-file')])

    def test_generator_refusal_refuses(self):
        bad = invented.register(invented.row('A' + invented.DOT + '1', 'unheard of'))
        self.assertEqual(self.refused(armed(bad, generated=False)),
                         [(CSV, 4, 'generator-refused:unknown-status')])
        # D36 Q3: a lists file of the wrong shape (no title after the
        # heading) stops with lists-shape, at its row.
        four = invented.lists('## TECH' + invented.DOT + '1\n- w\n')
        self.assertEqual(self.refused(armed(lists_bytes=four, generated=False)),
                         [(LISTS, 5, 'generator-refused:lists-shape')])

    # D49 a: the design values.
    def test_design_missing_refuses(self):
        files = armed()
        del files[DESIGN]
        self.assertEqual(self.refused(files), [(DESIGN, 0, 'missing')])

    def test_tokens_missing_refuses(self):
        files = armed()
        del files[TOKENS]
        self.assertEqual(self.refused(files), [(TOKENS, 0, 'generated-missing')])

    def test_tokens_hand_edited_refuses(self):
        files = armed()
        files[TOKENS] = files[TOKENS].replace(b'0xFFF5F5EC', b'0xFFF5F5ED')
        self.assertEqual(self.refused(files), [(TOKENS, 0, 'generated-differs')])

    def test_design_refused_by_its_generator_refuses(self):
        bad = invented_design.doc(light=['| color.page | #F5F5EC, almost always |'])
        files = armed(design=bad)
        row = bad.decode('utf-8').split('\n').index('| color.page | #F5F5EC, almost always |') + 1
        self.assertEqual(self.refused(files), [(DESIGN, row, 'generator-refused:colour-form')])

    def test_design_checked_beside_a_words_refusal(self):
        files = armed()
        del files[TOKENS]
        files[CSV] = b'changed\n'
        found = self.refused(files)
        self.assertIn((CSV, 0, 'hash-mismatch'), found)
        self.assertIn((TOKENS, 0, 'generated-missing'), found)


    # D57 Q11: the pending lines and their fingerprint.
    def pending_tree(self, body=None, fingerprint=None, made=True):
        files = armed()
        body = body if body is not None else invented.pending(invented.pending_row('MP' + invented.DOT + '60'))
        files[PENDING_CSV] = body
        files[PENDING_FINGERPRINT] = (fingerprint if fingerprint is not None else
                                      hashlib.sha256(body).hexdigest() + '  pending-lines.csv\n')
        if made:
            files[PENDING_DART] = wordsgen.generate(files[CSV], files[LISTS], body)[PENDING_DART]
        return files

    def test_pending_lines_with_their_fingerprint_pass(self):
        self.passed(self.pending_tree())

    def test_pending_lines_need_their_fingerprint(self):
        files = self.pending_tree()
        del files[PENDING_FINGERPRINT]
        self.assertEqual(self.refused(files), [(PENDING_CSV, 0, 'pending-unfingerprinted')])
        files = self.pending_tree()
        del files[PENDING_CSV]
        self.assertEqual(self.refused(files), [(PENDING_FINGERPRINT, 0, 'pending-missing')])

    def test_pending_fingerprint_must_match(self):
        files = self.pending_tree()
        files[PENDING_CSV] = files[PENDING_CSV] + b'MP' + invented.DOT.encode() + b'61,p,pending,a,b,c\n'
        self.assertEqual(self.refused(files), [(PENDING_CSV, 0, 'hash-mismatch')])
        for bad in ('', 'x\n', '0' * 64 + '  other.csv\n', '0' * 64 + '  pending-lines.csv'):
            self.assertEqual(self.refused(self.pending_tree(fingerprint=bad)),
                             [(PENDING_FINGERPRINT, 1, 'fingerprint-malformed')])

    def test_pending_dart_must_be_generated(self):
        files = self.pending_tree()
        files[PENDING_DART] = wordsgen.generate(files[CSV], files[LISTS])[PENDING_DART]
        self.assertEqual(self.refused(files), [(PENDING_DART, 0, 'generated-differs')])

    def test_pending_refusal_names_the_pending_file(self):
        body = invented.pending(invented.pending_row('MP' + invented.DOT + '55'))
        files = self.pending_tree(body, made=False)
        self.assertEqual(self.refused(files), [(PENDING_CSV, 2, 'generator-refused:pending-filed')])


class G2(GuardTest):
    guard = g2_copies

    def test_marker_alone_is_not_armed(self):
        notes = self.passed({MARKER: 'x\n'})
        self.assertEqual(notes, ['NOT ARMED (awaiting import)'])

    def test_marker_with_sources_refuses(self):
        self.refused({MARKER: 'x\n', SOURCES: '# empty\n'}, 'marker-with-sources')

    def test_marker_with_any_copy_refuses(self):
        self.refused({MARKER: 'x\n', COPY: 'h\n'}, 'marker-with-sources')

    def test_no_marker_no_sources_refuses(self):
        self.refused({}, 'no-sources')

    def test_matching_copy_passes(self):
        self.passed({COPY: 'h\n', SOURCES: line(COPY, 'h\n')})

    def test_hash_mismatch_refuses(self):
        self.refused({COPY: 'h\n', SOURCES: line(COPY, 'other\n')}, 'hash-mismatch')

    def test_unlisted_copy_refuses(self):
        self.refused({COPY: 'h\n', 'docs/source/extra.md': 'e\n', SOURCES: line(COPY, 'h\n')},
                     'unlisted')

    def test_listed_but_missing_refuses(self):
        self.refused({SOURCES: line(COPY, 'h\n')}, 'missing')

    def test_malformed_line_refuses(self):
        self.refused({SOURCES: 'not a line\n'}, 'sources-malformed')

    def test_refused_documents_refused(self):
        # D32 Q18: armed or not, these never leave the documents.
        pes = 'docs/source/privacy-ethics-safety.md'
        found = self.refused({pes: 'h\n', SOURCES: line(pes, 'h\n')}, 'refused-document')
        self.assertEqual(found, [(pes, 0, 'refused-document')])
        self.refused({MARKER: 'x\n', 'notes/restricted/a.md': 'h\n'}, 'refused-document')
        self.refused({MARKER: 'x\n', 'app/privacy-ethics-safety.md': 'h\n'}, 'refused-document')

    def test_lookalike_names_pass(self):
        self.passed({MARKER: 'x\n', 'docs/restricted.md': 'h\n', 'docs/restricted-x/a.md': 'h\n'})

    # D49 a: the fonts and their fingerprints.
    def fonts(self, listed=None, files=None):
        files = {'A-Regular.ttf': b'\x00a', 'OFL-A.txt': b'licence\n'} if files is None else files
        listed = files if listed is None else listed
        tree = {'app/assets/fonts/' + name: body for name, body in files.items()}
        tree[FONTS_LIST] = ''.join(hashlib.sha256(body).hexdigest() + '  ' + name + '\n'
                                   for name, body in listed.items())
        tree.update({COPY: 'h\n', SOURCES: line(COPY, 'h\n')})
        return tree

    def test_fonts_listed_pass(self):
        self.passed(self.fonts())

    def test_font_unlisted_refuses(self):
        tree = self.fonts(listed={'A-Regular.ttf': b'\x00a'})
        self.assertEqual(self.refused(tree), [('app/assets/fonts/OFL-A.txt', 0, 'font-unlisted')])

    def test_font_hash_mismatch_refuses(self):
        tree = self.fonts()
        tree['app/assets/fonts/A-Regular.ttf'] = b'\x00b'
        self.assertEqual(self.refused(tree),
                         [('app/assets/fonts/A-Regular.ttf', 0, 'font-hash-mismatch')])

    def test_font_listed_but_missing_refuses(self):
        tree = self.fonts(listed={'A-Regular.ttf': b'\x00a', 'B.ttf': b'\x00b'},
                          files={'A-Regular.ttf': b'\x00a'})
        self.assertEqual(self.refused(tree), [('app/assets/fonts/B.ttf', 0, 'font-missing')])

    def test_fingerprints_malformed_refuses(self):
        tree = self.fonts()
        tree[FONTS_LIST] += 'abc  A-Regular.ttf\n'
        self.assertIn((FONTS_LIST, 3, 'fingerprints-malformed'), self.refused(tree))

    def test_fonts_without_fingerprints_refuse(self):
        tree = self.fonts()
        del tree[FONTS_LIST]
        self.assertEqual(self.refused(tree), [(FONTS_LIST, 0, 'no-fingerprints')])

    def test_fonts_checked_when_not_armed(self):
        tree = self.fonts()
        tree['app/assets/fonts/A-Regular.ttf'] = b'\x00b'
        del tree[COPY], tree[SOURCES]
        tree[MARKER] = 'x\n'
        self.refused(tree, 'font-hash-mismatch')

    def test_unknown_path_outside_docs_source_refuses(self):
        self.refused({'app/x.txt': 'h\n', SOURCES: line('app/x.txt', 'h\n')}, 'unknown-path')


if __name__ == '__main__':
    unittest.main()
