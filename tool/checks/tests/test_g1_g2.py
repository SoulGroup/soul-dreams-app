import hashlib
import unittest

from helpers import GuardTest
import g1_words
import g2_copies
import test_wordsgen as invented
import wordsgen
from guardlib import GENERATED, LINES, WORDS_XCCONFIG

MARKER = 'tool/checks/awaiting-import'
SOURCES = 'docs/source/SOURCES'
CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'
COPY = 'docs/source/handover.md'


def line(path, body, ordinal='C0-T item 1'):
    if isinstance(body, str):
        body = body.encode('utf-8')
    return hashlib.sha256(body).hexdigest() + '  ' + path + '  ' + ordinal + '\n'


def armed(csv_bytes=None, lists_bytes=None, generated=True):
    # An armed tree from an invented register and lists, with SOURCES
    # matching them and, when it can be made, the generated words.
    c = csv_bytes if csv_bytes is not None else invented.register()
    l = lists_bytes if lists_bytes is not None else invented.lists()
    files = {CSV: c, LISTS: l, SOURCES: line(CSV, c) + line(LISTS, l)}
    if generated:
        files.update(wordsgen.generate(c, l))
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

    def test_unknown_path_outside_docs_source_refuses(self):
        self.refused({'app/x.txt': 'h\n', SOURCES: line('app/x.txt', 'h\n')}, 'unknown-path')


if __name__ == '__main__':
    unittest.main()
