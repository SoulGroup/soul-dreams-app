import unittest

from helpers import GuardTest, run
import g7_secrets

D = '-' * 5
AWS = 'AK' + 'IA' + 'Q3EXAMPLE7KEY2ZX'
PEM = D + 'BEGIN ' + 'PRIVATE KEY' + D
SK = 's' + 'k-' + 'proj' + 'Xq3vB8mN2pL5tR9wY4zC'
GH = 'gh' + 'p_' + 'A1b2C3d4E5f6G7h8I9' + 'j0K1l2M3n4O5p6Q7r8'
RANDOM = 'Zq8' + 'Lm3vT9xQ2pW7kR4n' + 'B6yH1cJ5dF0gS8aE'


class G7(GuardTest):
    guard = g7_secrets

    def test_secret_file_names_refused(self):
        for name in ('.env', '.env.local', 'k.p8', 'k.pem', 'k.p12', 'x.mobileprovision',
                     '.ENV', 'x.PEM', 'AuthKey.P8'):
            self.refused({'app/' + name: b''}, 'secret-file')

    def test_key_shapes_refused_markdown_included(self):
        cases = [(AWS, 'aws-key'), (PEM, 'pem-block'), (SK, 'sk-token'),
                 (GH, 'github-token'), ('api' + 'Key = "a1B2c3D4e5F6g7H8"', 'assigned-secret'),
                 (RANDOM, 'high-entropy')]
        for text, reason in cases:
            self.refused({'docs/notes.md': 'see ' + text + '\n'}, reason)

    def test_hex_hashes_pass(self):
        self.passed({'docs/Status.md': ('ab12' * 16) + '\n' + ('9f' * 20) + '\n'})

    def test_sources_and_lockfile_integrity_exempt(self):
        self.passed({'docs/source/SOURCES': RANDOM + '\n',
                     'server/package-lock.json': '"integrity": "sha512-' + RANDOM + '"\n'})

    def test_high_entropy_not_applied_under_docs_source(self):
        # D39: the copies are byte-identical to filings (G2) and
        # write-protected, and carry archive names that look like keys.
        self.passed({'docs/source/a.md': 'file ' + RANDOM + '\n'})
        self.refused({'docs/a.md': 'file ' + RANDOM + '\n'}, 'high-entropy')

    def test_key_shapes_still_refused_under_docs_source(self):
        for text, reason in ((AWS, 'aws-key'), (PEM, 'pem-block'), (SK, 'sk-token'),
                             (GH, 'github-token'),
                             ('api' + 'Key = "a1B2c3D4e5F6g7H8"', 'assigned-secret')):
            self.refused({'docs/source/a.md': 'see ' + text + '\n'}, reason)

    def test_docs_source_lookalike_paths_still_scanned(self):
        for path in ('app/docs/source/a.md', 'docs/sources/a.md', 'docs/source.md'):
            self.refused({path: 'file ' + RANDOM + '\n'}, 'high-entropy')

    def test_lockfile_other_lines_still_scanned(self):
        self.refused({'server/package-lock.json': '"x": "' + RANDOM + '"\n'}, 'high-entropy')

    def test_integrity_outside_lockfile_refused(self):
        self.refused({'server/a.json': '"integrity": "' + RANDOM + '"\n'}, 'high-entropy')

    def test_plain_code_passes(self):
        self.passed({'tool/a.py': 'tokens = tokenize.generate_tokens(read)\n'
                                  'secret_name = is_secret_name(path)\n'})

    def test_binary_file_skipped(self):
        findings, _ = run(self.guard, {'a.bin': b'\0' + RANDOM.encode()})
        self.assertEqual(findings, [])


if __name__ == '__main__':
    unittest.main()
