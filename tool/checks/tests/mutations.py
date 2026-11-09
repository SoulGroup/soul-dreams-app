# Mutation checks: each row breaks one guard in a copy of tool/checks
# in $TMPDIR, and the named tests must then fail. The named tests are
# first run on an unbroken copy and must pass. The repository itself
# is never changed. Arguments, if any, limit the run to those files
# (for example g3_literals.py).
import os
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
CHECKS = os.path.dirname(HERE)
sys.path.insert(0, CHECKS)

from guardlib import report  # noqa: E402

MUTATIONS = [
    ('g1_words.py', "if marker and src.has(SOURCES):", "if False:",
     ['test_g1_g2.G1.test_marker_with_sources_refuses']),
    ('g1_words.py', "!= entries[path][0]", "!= sha256(src.read(path))",
     ['test_g1_g2.G1.test_words_hash_mismatch_refuses']),
    ('g2_copies.py', "elif sha256(src.read(path)) != digest:", "elif False:",
     ['test_g1_g2.G2.test_hash_mismatch_refuses']),
    ('g2_copies.py', "if in_dir:", "if False:",
     ['test_g1_g2.G2.test_marker_with_sources_refuses']),
    ('g3_literals.py', "words(lit.text) > 2", "words(lit.text) > 3",
     ['test_g3.G3.test_three_words_unmarked_refused']),
    ('g3_literals.py', "and not path.startswith('app/lib/words/'))", ")",
     ['test_g3.G3.test_inside_words_passes']),
    ('g3_literals.py', "'tooltip', ", "",
     ['test_g3.G3.test_named_arguments_refused']),
    ('g4_invented.py', "LIMIT = 12", "LIMIT = 13",
     ['test_g4.G4.test_twelve_words_refused_in_each_language']),
    ('g5_logging.py', "('console', re.compile(B + r'console\\s*\\.')),", "",
     ['test_g5.G5.test_each_writer_refused']),
    ('g5_logging.py', "if name == 'log' and MATH", "if False and MATH",
     ['test_g5.G5.test_strings_comments_and_lookalikes_pass']),
    ('g6_identifiers.py', "'device' + '_info'", "'device' + '_infox'",
     ['test_g6.G6.test_each_name_refused_in_code_and_config']),
    ('g7_secrets.py', "('pem-block', re.compile(DASHES + r'BEGIN [A-Z0-9 ]+' + DASHES)),", "",
     ['test_g7.G7.test_key_shapes_refused_markdown_included']),
    ('g7_secrets.py', "if lock and 'integrity' in line:", "if 'integrity' in line:",
     ['test_g7.G7.test_integrity_outside_lockfile_refused']),
    ('g8_export.py', "ALLOWED = ('app/lib/main_founder.dart',",
     "ALLOWED = ('app/lib/main.dart', 'app/lib/main_founder.dart',",
     ['test_g8.G8.test_tester_main_refused']),
    ('g9_hosts.py', "or path.startswith(TESTS):", "or True:",
     ['test_g9.G9.test_each_scheme_refused']),
    ('lex.py', "if c == '\\n' and not multiline:\n                raise LexError('string')",
     "if c == '\\n' and not multiline:\n                pass",
     ['test_lex.Dart.test_unterminated_raises']),
    ('lex.py', "return value not in (']', '++', '--')", "return value not in (']',)",
     ['test_lex_fixes.TypeScript.test_slash_after_postfix_is_division']),
    ('lex.py', "return value in PAREN_KEYWORDS", "return False",
     ['test_lex_fixes.TypeScript.test_slash_after_condition_is_regex']),
    ('lex.py', "if not closed:\n            raise LexError('regex')",
     "if False:\n            raise LexError('regex')",
     ['test_lex_fixes.TypeScript.test_unterminated_regex_raises']),
    ('guardlib.py', "b = posixpath.basename(path).lower()", "b = posixpath.basename(path)",
     ['test_guardlib.Library.test_secret_names_ignore_case']),
    ('g0_kinds.py', "return data is not None and b'\\0' in data", "return True",
     ['test_g0.G0.test_unknown_kinds_refused']),
    ('lex.py', "if c == '/' and self.regex_allowed():\n                    raise LexError('regex')",
     "if False:\n                    raise LexError('regex')",
     ['test_fail_closed.Swift.test_slash_where_regex_could_start_raises']),
    ('g0_kinds.py', "return src.text(path) is not None", "return True",
     ['test_g0.G0.test_undecodable_unscanned_refused']),
]


def run_named(checks, tests):
    runner = os.path.join(checks, 'tests', 'run_tests.py')
    r = subprocess.run([sys.executable, '-I', '-B', runner] + tests, capture_output=True)
    return r.returncode


def main(only):
    bad = 0
    ran = 0
    for n, (name, old, new, tests) in enumerate(MUTATIONS, 1):
        if only and name not in only:
            continue
        ran += 1
        tmp = tempfile.mkdtemp(prefix='mutation-')
        try:
            copy = os.path.join(tmp, 'checks')
            shutil.copytree(CHECKS, copy, ignore=shutil.ignore_patterns('__pycache__'))
            path = os.path.join(copy, name)
            with open(path, encoding='utf-8') as f:
                text = f.read()
            if text.count(old) != 1:
                report('mutation %d %s: SETUP FAILED (pattern not found once)' % (n, name))
                bad += 1
                continue
            if run_named(copy, tests) != 0:
                report('mutation %d %s: SETUP FAILED (tests fail unbroken)' % (n, name))
                bad += 1
                continue
            with open(path, 'w', encoding='utf-8') as f:
                f.write(text.replace(old, new))
            if run_named(copy, tests) == 0:
                report('mutation %d %s: SURVIVED' % (n, name))
                bad += 1
            else:
                report('mutation %d %s: caught' % (n, name))
        finally:
            shutil.rmtree(tmp)
    if not ran:
        report('mutations: FAILED (none ran)')
        return 1
    report('mutations: %d run, %s' % (ran, 'FAILED' if bad else 'all caught'))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
