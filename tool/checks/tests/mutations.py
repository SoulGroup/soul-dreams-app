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
    ('g0_kinds.py', "if src.kind(path) is not None and src.text(path) is None:", "if False:",
     ['test_g0.G0.test_undecodable_config_refused']),
    ('lex.py', "self.lang == 'swift' and value in", "value in",
     ['test_fail_closed.Swift.test_division_near_try_still_lexes']),
    ('guardlib.py', "'.xcworkspacedata', ", "",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', "'.xcsettings', ", "",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', "'.storyboard', ", "",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', ", '.h')", ")",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', "('.fvmrc', ", "(",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('guardlib.py', ", '.metadata')", ")",
     ['test_g0.G0.test_flutter_kinds_pass']),
    ('g5_logging.py', "    ('NSLog', re.compile(B + r'NSLog\\s*\\(')),\n", "",
     ['test_g5.G5.test_apple_writers_refused_in_swift_and_headers']),
    # Branch 3, Task 1 (D32): the import.
    ('importer.py', "if sha256(data) != digest:", "if False:",
     ['test_import.Import.test_hash_mismatch_refused']),
    ('importer.py', "if git(docs, 'status', '--porcelain', '--untracked-files=all') != b'':",
     "if False:",
     ['test_import.Import.test_dirty_docs_refused']),
    ('importer.py', "if head != upstream:", "if False:",
     ['test_import.Import.test_unsynced_docs_refused']),
    ('importer.py', "data = git(docs, 'cat-file', 'blob', 'HEAD:' + path)",
     "data = open(os.path.join(docs, path), 'rb').read()",
     ['test_import.Import.test_reads_the_committed_bytes']),
    ('importer.py', "    raise Refused('not-allowed')", "    return 'docs/source/x.md', 'copy'",
     ['test_import.Import.test_paths_refused']),
    # Branch 3, Task 1a (D35): the review's fixes and test gaps.
    ('importer.py', "if ref == b'refs/heads/main\\n':", "if False:",
     ['test_import.Import.test_on_main_refused_though_a_tag_is_named_main']),
    ('importer.py', "    if ref is None:", "    if False:",
     ['test_import.Import.test_detached_head_at_main_refused_elsewhere_allowed']),
    ('importer.py', "if not k.startswith('GIT_')}", "if True}",
     ['test_import.Import.test_git_environment_does_not_steer_the_checks']),
    ('importer.py', "unicodedata.category(c) in ('Cc', 'Zl', 'Zp')", "ord(c) < 32",
     ['test_import.Import.test_control_characters_in_the_ordinal_refused']),
    ('importer.py', "if git(TOP, 'rev-parse', '--git-dir') is None:", "if False:",
     ['test_import.Import.test_app_not_a_repository_refused']),
    ('importer.py', "if git(docs, 'fetch', '--quiet') is None:", "if False:",
     ['test_import.Import.test_fetch_failure_refused']),
    ('importer.py', "    if b'\\0' in data:", "    if False:",
     ['test_import.Import.test_not_text_refused']),
    ('importer.py', "data.decode('utf-8')", "data.decode('latin-1')",
     ['test_import.Import.test_not_text_refused']),
    # Branch 3, Task 4 (D32, D36): the words generator.
    ('wordsgen.py', "    return None\n\n\ndef label", "    return 'line'\n\n\ndef label",
     ['test_wordsgen.Generator.test_unknown_status_stops']),
    ('wordsgen.py', "text.strip().split(' / ')", "[text.strip()]",
     ['test_wordsgen.Generator.test_parts_and_paragraphs']),
    ('wordsgen.py', "out.append('\\\\$')", "out.append('$')",
     ['test_wordsgen.Generator.test_dart_escaping']),
    ('wordsgen.py', "NO_LINE = ('retired', ", "NO_LINE = (",
     ['test_wordsgen.Generator.test_statuses_without_constant']),
    ('wordsgen.py', "    if name_en != name_sv:", "    if False:",
     ['test_wordsgen.Generator.test_ios_lines_checked']),
    ('wordsgen.py', "        if name in names:", "        if False:",
     ['test_wordsgen.Generator.test_dart_name_clash_stops']),
    ('wordsgen.py', "if status == IN_PARTS and not", "if False and not",
     ['test_wordsgen.Generator.test_in_its_parts_may_be_empty_and_has_no_constant']),
    ('wordsgen.py', "if section is None or section[key] is not None:", "if section is None:",
     ['test_wordsgen.Generator.test_lists_shape_stops']),
    ('wordsgen.py', "            items = None\n        elif line.startswith('# ')",
     "            items = []\n        elif line.startswith('# ')",
     ['test_wordsgen.Generator.test_lists_shape_stops']),
    # Branch 3, Task 4a (D37): prose closes a list.
    ('wordsgen.py', "        elif line.strip():", "        elif False:",
     ['test_wordsgen.Generator.test_prose_closes_a_list_and_a_later_item_stops']),
    # Branch 3, Task 5 (D32): G1 armed, G0, G2 and G4.
    ('g1_words.py', "elif src.read(path) != outputs[path]:", "elif False:",
     ['test_g1_g2.G1.test_generated_differs_refuses']),
    ('g1_words.py', "and p not in KNOWN]", "and False]",
     ['test_g1_g2.G1.test_unknown_words_file_refuses']),
    ('g1_words.py', "return [Finding(where, e.row, 'generator-refused:' + e.code)] + unknown, []",
     "outputs = {}",
     ['test_g1_g2.G1.test_generator_refusal_refuses']),
    ('g2_copies.py', "REFUSED_NAMES = ('privacy-ethics-safety.md',)", "REFUSED_NAMES = ()",
     ['test_g1_g2.G2.test_refused_documents_refused']),
    ('g0_kinds.py', ", STRINGS_EN, STRINGS_SV)\n", ")\n",
     ['test_g0.G0.test_generated_strings_pass']),
    ('g4_invented.py', "\n            or path in GENERATED)", ")",
     ['test_g4.G4.test_generated_words_pass']),
    # Branch 3, Task 5a (D38): an item-like line stops, never dropped.
    ('wordsgen.py', "        elif item_like(line):", "        elif False:",
     ['test_wordsgen.Generator.test_item_like_lines_stop_never_dropped']),
    # Branch 3, Task 5b (D39): no high-entropy rule under docs/source/.
    ('g7_secrets.py', "if not copy and any(", "if any(",
     ['test_g7.G7.test_high_entropy_not_applied_under_docs_source']),
    # Branch 3, D40: the final review's test gaps.
    ('importer.py', "and dest.count('/') == 2", "and True",
     ['test_import.Import.test_copy_destinations_must_fit_their_kind']),
    ('importer.py', "sys.exit(2)", "sys.exit(1)",
     ['test_import.Import.test_internal_error_exits_two_and_prints_no_content']),
    ('wordsgen.py', "    except csv.Error:", "    except KeyError:",
     ['test_wordsgen.Generator.test_bad_csv_and_missing_inputs_stop']),
    ('wordsgen.py', "    if data is None:", "    if False:",
     ['test_wordsgen.Generator.test_bad_csv_and_missing_inputs_stop']),
    ('wordsgen.py', "or os.path.islink(full):", "or False:",
     ['test_wordsgen.Command.test_symlinked_input_is_treated_as_missing']),
    # journal-core (D49 a): the design values and the fonts.
    ('designgen.py', "        elif part in NOTES:", "        elif True:",
     ['test_designgen.Generate.test_refusals']),
    ('designgen.py', "return text.replace(MINUS, '-')", "return text",
     ['test_designgen.Generate.test_type_roles']),
    ('designgen.py', "        if value.endswith(UNSET):", "        if False:",
     ['test_designgen.Generate.test_an_unset_value_has_no_constant']),
    # journal-core, Task 2a (D52): no prose in the output; an "after" value
    # is fully parsed.
    ('designgen.py', "[comment('`%s`' % role),", "[comment('`%s`: %s' % (role, used)),",
     ['test_designgen.Generate.test_no_prose_reaches_the_tokens']),
    ('designgen.py', "    doc = [comment('`%s`' % role)]",
     "    doc = [comment('`%s` (%s)' % (role, note))]",
     ['test_designgen.Generate.test_no_prose_reaches_the_tokens']),
    ('designgen.py', "body.append(comment('`%s`' % role) + '\\n' + code)",
     "body.append(comment('`%s`: %s' % (role, value)) + '\\n' + code)",
     ['test_designgen.Generate.test_no_prose_reaches_the_tokens']),
    ('designgen.py', "after [^\\d,]+, before [^\\d,]+$')", "after \\S.*$')",
     ['test_designgen.Generate.test_an_after_value_with_other_text_stops']),
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
