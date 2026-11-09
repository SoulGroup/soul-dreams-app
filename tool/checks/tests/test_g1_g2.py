import hashlib
import unittest

from helpers import GuardTest
import g1_words
import g2_copies

MARKER = 'tool/checks/awaiting-import'
SOURCES = 'docs/source/SOURCES'
CSV = 'app/assets/words/places-register.csv'
LISTS = 'app/assets/words/founder-lists-for-technology.md'
COPY = 'docs/source/handover.md'


def line(path, body, ordinal='C0-T item 1'):
    return hashlib.sha256(body.encode('utf-8')).hexdigest() + '  ' + path + '  ' + ordinal + '\n'


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

    def test_armed_refuses_until_generator_is_built(self):
        files = {CSV: 'a\n', LISTS: 'l\n', SOURCES: line(CSV, 'a\n') + line(LISTS, 'l\n')}
        found = self.refused(files)
        self.assertEqual([f[2] for f in found], ['generator-not-built'])


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

    def test_unknown_path_outside_docs_source_refuses(self):
        self.refused({'app/x.txt': 'h\n', SOURCES: line('app/x.txt', 'h\n')}, 'unknown-path')


if __name__ == '__main__':
    unittest.main()
