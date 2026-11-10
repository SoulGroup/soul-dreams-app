# The words generator on invented registers and lists, built here from
# placeholder words. No register line appears in this file (R1, R2).
import csv
import io
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

import helpers  # noqa: F401  (puts tool/checks on the path)
import wordsgen
from guardlib import CSV, GENERATED, LINES, LIST_WORDS, LISTS, STRINGS_EN, STRINGS_SV
from guardlib import WORDS_XCCONFIG

DOT = '·'
PILCROW = '¶'


def row(handle, status, en='', sv=''):
    f = dict.fromkeys(wordsgen.HEADER, '')
    f.update(handle=handle, status=status, english=en, swedish=sv, flag='a note')
    return [f[h] for h in wordsgen.HEADER]


def table(rows):
    out = io.StringIO(newline='')
    w = csv.writer(out, lineterminator='\n')
    w.writerow(wordsgen.HEADER)
    for r in rows:
        w.writerow(r)
    return out.getvalue().encode('utf-8')


def ios_register(name_en, name_sv, mic_en, mic_sv):
    return table([row('MP' + DOT + '55', 'written', name_en, name_sv),
                  row('EM' + DOT + '3', 'written', mic_en, mic_sv)])


def register(*rows):
    return table([row('MP' + DOT + '55', 'written', 'Name', 'Name'),
                  row('EM' + DOT + '3', 'written', 'mic word', 'mik ord')] + list(rows))


def sect(n, en=None, sv=None, title=' — Title'):
    # One invented section of the lists, in the real file's shape (D36 Q3):
    # a heading, prose, then a marker line and its items for each language.
    en = ['word%d' % n, 'other'] if en is None else en
    sv = ['ord%d' % n, 'annat'] if sv is None else sv
    return ('## TECH%s%d%s\n\n**Checks.** note\n\n**English** here\n\n%s\n**Swedish** here\n\n%s\n---\n\n'
            % (DOT, n, title, ''.join('- %s\n' % w for w in en), ''.join('- %s\n' % w for w in sv)))


def five(custom=None):
    custom = custom or {}
    return ''.join(custom.get(n) or sect(n) for n in range(1, 6))


def lists(body=None):
    return ('# Lists\n\nintro text\n\n' + (five() if body is None else body)).encode('utf-8')


def gen(*rows):
    return wordsgen.generate(register(*rows), lists())


def lines(*rows):
    return gen(*rows)[LINES].decode('utf-8')


class Generator(unittest.TestCase):
    def refused(self, code, csv_bytes=None, lists_bytes=None):
        with self.assertRaises(wordsgen.WordsError) as cm:
            wordsgen.generate(csv_bytes if csv_bytes is not None else register(),
                              lists_bytes if lists_bytes is not None else lists())
        self.assertEqual(cm.exception.code, code)
        return cm.exception

    def test_every_path_generated(self):
        self.assertEqual(sorted(gen()), sorted(GENERATED))

    def test_same_input_same_bytes(self):
        a = gen(row('A' + DOT + '1', 'written', 'x / y', 'x / y'))
        b = gen(row('A' + DOT + '1', 'written', 'x / y', 'x / y'))
        self.assertEqual(a, b)

    def test_line_statuses_make_lines(self):
        out = lines(row('A' + DOT + '1', 'written', 'en', 'sv'),
                    row('A' + DOT + '2', 'written, in its parts', 'a / b', 'c / d'),
                    row('A' + DOT + '3', 'composed (stand-in written)', 'e', 'f'))
        self.assertIn("static const A_1 = Line('A·1', ['en'], ['sv']);", out)
        self.assertIn("static const A_2 = Line('A·2', ['a', 'b'], ['c', 'd']);", out)
        self.assertIn("static const A_3 = Line('A·3', ['e'], ['f'], standIn: true);", out)

    def test_waiting_statuses_make_placeholders(self):
        for n, status in enumerate(('to rewrite', 'to write', 'composed, no stand-in',
                                    'paused: some reason', 'blocked: other reason'), 1):
            out = lines(row('W' + DOT + str(n), status, 'draft', 'draft'))
            self.assertIn("static const W_%d = Line('W·%d', null, null);" % (n, n), out)
            self.assertNotIn('draft', out)
            self.assertNotIn('reason', out)

    def test_statuses_without_constant(self):
        for status in ('retired', 'no line: by decision', 'no line: prohibition',
                       'merged into EM' + DOT + '3'):
            out = lines(row('N' + DOT + '1', status, 'en', 'sv'))
            self.assertNotIn('N_1', out)

    def test_unknown_status_stops(self):
        e = self.refused('unknown-status', register(row('A' + DOT + '1', 'Written', 'x', 'y')))
        self.assertEqual(e.row, 4)
        self.refused('unknown-status', register(row('A' + DOT + '1', 'pause: x', 'x', 'y')))
        self.refused('unknown-status', register(row('A' + DOT + '1', '', 'x', 'y')))

    def test_merged_into_unknown_handle_stops(self):
        self.refused('merged-unknown', register(row('A' + DOT + '1', 'merged into Z' + DOT + '9')))

    def test_missing_language_stops(self):
        self.refused('missing-language', register(row('A' + DOT + '1', 'written', 'x', '')))
        self.refused('missing-language', register(row('A' + DOT + '1', 'written', ' ', 'y')))

    def test_in_its_parts_may_be_empty_and_has_no_constant(self):
        # D36 Q2: its parts carry the text. Only that status, only both empty.
        out = lines(row('A' + DOT + '1', 'written, in its parts', '', ''),
                    row('A' + DOT + '2', 'written, in its parts', ' ', ' '))
        self.assertNotIn('A_1', out)
        self.assertNotIn('A_2', out)
        self.refused('missing-language', register(row('A' + DOT + '1', 'written, in its parts',
                                                      'x', '')))
        self.refused('missing-language', register(row('A' + DOT + '1', 'written', '', '')))
        self.refused('missing-language', register(row('A' + DOT + '1',
                                                      'composed (stand-in written)', '', '')))

    def test_parts_and_paragraphs(self):
        out = lines(row('A' + DOT + '1', 'written', 'a ' + PILCROW + ' b / c', 'd' + PILCROW + 'e / f'))
        self.assertIn("['a\\n\\nb', 'c'], ['d\\n\\ne', 'f']", out)
        self.refused('parts-differ', register(row('A' + DOT + '1', 'written', 'a / b', 'c')))
        self.refused('empty-part', register(row('A' + DOT + '1', 'written', 'a /  / b', 'c')))
        self.refused('empty-part', register(row('A' + DOT + '1', 'written', PILCROW + ' a', 'c')))

    def test_slash_without_spaces_is_text(self):
        out = lines(row('A' + DOT + '1', 'written', 'a/b', 'c/d'))
        self.assertIn("['a/b'], ['c/d']", out)

    def test_slots(self):
        out = lines(row('S' + DOT + '1', 'written', '{n} x {tradition}', '{tradition} y {n}'),
                    row('S' + DOT + '2', 'written', '{pointed image} / {read image}',
                        '{read image} / {pointed image}'))
        self.assertIn("static const _S_1 = Line(", out)
        self.assertIn("static Line S_1({required int n, required String tradition}) => "
                      "_S_1._fill({'{n}': '$n', '{tradition}': tradition});", out)
        self.assertIn("static Line S_2({required String pointedImage, "
                      "required String readImage})", out)
        self.assertIn('static const all = <Line>[MP_55, EM_3, _S_1, _S_2];', out)

    def test_slot_errors_stop(self):
        self.refused('unknown-slot', register(row('A' + DOT + '1', 'written', '{name}', '{name}')))
        self.refused('unknown-slot', register(row('A' + DOT + '1', 'written', 'a } b', 'c')))
        self.refused('slots-differ', register(row('A' + DOT + '1', 'written', '{n}', 'x')))

    def test_dart_escaping(self):
        out = lines(row('A' + DOT + '1', 'written', "it's $5 \\ ok", 'x'))
        self.assertIn("['it\\'s \\$5 \\\\ ok']", out)

    def test_handle_forms(self):
        # D36 Q1: the register's real forms. Dart name: "·" and "-" as "_".
        out = lines(row('W3', 'written', 'a', 'b'),
                    row('P1', 'written', 'c', 'd'),
                    row('C4-P' + DOT + '2', 'written', 'e', 'f'),
                    row('C125-I' + DOT + '3', 'composed (stand-in written)', 'g', 'h'),
                    row('W3' + DOT + '1', 'to write'))
        for name, handle in (('W3', 'W3'), ('P1', 'P1'), ('C4_P_2', 'C4-P·2'),
                             ('C125_I_3', 'C125-I·3'), ('W3_1', 'W3·1')):
            self.assertIn("static const %s = Line('%s'," % (name, handle), out)

    def test_dart_name_clash_stops(self):
        e = self.refused('dart-name-clash', register(row('A-1', 'written', 'x', 'y'),
                                                     row('A' + DOT + '1', 'written', 'x', 'y')))
        self.assertEqual(e.row, 5)

    def test_register_shape_stops(self):
        self.refused('bad-header', b'handle,status\n')
        bad = register().replace(b'Name,Name,a note', b'Name,Name')
        self.refused('bad-row', bad)
        for handle in ('a' + DOT + '1', 'A--1', 'A-', 'A' + DOT, DOT + '1', 'A' + DOT + '1' + DOT + '2',
                       'A' + DOT + '1-B', 'A 1', ''):
            self.refused('bad-handle', register(row(handle, 'written', 'x', 'y')))
        self.refused('repeated-handle', register(row('EM' + DOT + '3', 'retired')))
        self.refused('control-character', register(row('A' + DOT + '1', 'written', 'a\nb', 'c')))
        self.refused('not-utf8', b'\xff\xfe')

    def test_bom_accepted(self):
        self.assertEqual(wordsgen.generate(b'\xef\xbb\xbf' + register(), lists())[LINES],
                         gen()[LINES].replace(
                             wordsgen.sha256(register()).encode(),
                             wordsgen.sha256(b'\xef\xbb\xbf' + register()).encode()))

    def test_flag_is_ignored(self):
        out = lines(row('A' + DOT + '1', 'written', 'x', 'y'))
        self.assertNotIn('a note', out)

    def test_ios_files(self):
        out = gen()
        xc = out[WORDS_XCCONFIG].decode('utf-8')
        self.assertIn('\nWORDS_APP_NAME = Name\nWORDS_MIC_USAGE = mic word\n', xc)
        self.assertTrue(out[STRINGS_EN].decode('utf-8').endswith(
            '"NSMicrophoneUsageDescription" = "mic word";\n'))
        self.assertTrue(out[STRINGS_SV].decode('utf-8').endswith(
            '"NSMicrophoneUsageDescription" = "mik ord";\n'))

    def test_strings_escaping(self):
        out = wordsgen.generate(ios_register('Name', 'Name', 'a "b" \\ c', 'd'), lists())
        self.assertTrue(out[STRINGS_EN].decode('utf-8').endswith('= "a \\"b\\" \\\\ c";\n'))

    def ios(self, name_en, name_sv, mic):
        return ios_register(name_en, name_sv, mic, mic)

    def test_ios_lines_checked(self):
        self.refused('name-languages-differ', self.ios('Name', 'Namn', 'mic'))
        self.refused('ios-line-parts', self.ios('Name', 'Name', 'a / b'))
        self.refused('ios-line-parts', self.ios('Name', 'Name', '{n} x'))
        self.refused('ios-line-paragraphs', self.ios('Name', 'Name', 'a ' + PILCROW + ' b'))
        self.refused('xcconfig-unsafe', self.ios('Name', 'Name', 'a // b'))
        self.refused('xcconfig-unsafe', self.ios('Na$(X)', 'Na$(X)', 'mic'))
        missing = ios_register('Name', 'Name', 'mic', 'mic').replace(b'written,,Name,Name',
                                                                     b'to write,,,')
        self.refused('ios-line-missing', missing)

    def test_lists(self):
        # D36 Q3: ten constants, one per section and language.
        out = gen()[LIST_WORDS].decode('utf-8')
        self.assertIn("  static const tech1En = <String>['word1', 'other'];\n", out)
        self.assertIn("  static const tech1Sv = <String>['ord1', 'annat'];\n", out)
        self.assertIn("  static const tech5En = <String>['word5', 'other'];\n", out)
        self.assertIn("  static const tech5Sv = <String>['ord5', 'annat'];\n", out)
        self.assertEqual(out.count('static const'), 10)

    def test_lists_ignore_other_lines(self):
        body = five() + 'trailing prose\n*italic note*\n---\n'
        out = wordsgen.generate(register(), lists(body))[LIST_WORDS].decode('utf-8')
        for hidden in ('prose', 'italic', 'Title', 'note', 'here'):
            self.assertNotIn(hidden, out)
        self.assertEqual(out.count('static const'), 10)

    def test_lists_shape_stops(self):
        def shape(body):
            return self.refused('lists-shape', lists_bytes=lists(body))
        shape(''.join(sect(n) for n in range(1, 5)))                      # four sections
        shape(''.join(sect(n) for n in (2, 1, 3, 4, 5)))                  # out of order
        shape(five() + '## Notes\n')                                      # a sixth, other section
        shape(five({3: '## TECH' + DOT + '3\n**English**\n- a\n**Swedish**\n- b\n'}))  # no title
        shape(five({3: sect(3, title=' - Title')}))                       # hyphen for the dash
        shape(five({3: sect(3) + '### sub\n'}))                           # a deeper heading
        shape(five() + '# Again\n')                                       # a second level-1 title
        shape(five({3: '## TECH' + DOT + '3 — T\n- a\n**English**\n- b\n**Swedish**\n- c\n'}))
        shape('- stray\n' + five())                                       # an item in the intro
        shape('**English** x\n- a\n' + five())                            # a marker in the intro
        shape(five({3: sect(3) + '**English**\n- x\n'}))                  # a second marker
        shape(five({3: '## TECH' + DOT + '3 — T\n**English**\n- a\n'}))   # no Swedish
        shape(five({3: sect(3, en=[])}))                                  # an empty list
        shape(five({3: sect(3, en=[''])}))                                # an empty item
        shape(five({3: sect(3, sv=['a\x01b'])}))                          # a control character
        e = shape(five({3: sect(3) + '### sub\n'}))
        self.assertGreater(e.row, 0)


class Command(unittest.TestCase):
    def setUp(self):
        self.root = tempfile.mkdtemp(prefix='wordsgen-')
        for path, data in ((CSV, register()), (LISTS, lists())):
            os.makedirs(os.path.join(self.root, os.path.dirname(path)), exist_ok=True)
            with open(os.path.join(self.root, path), 'wb') as f:
                f.write(data)

    def tearDown(self):
        shutil.rmtree(self.root)

    def run_gen(self, *args):
        script = os.path.join(helpers.CHECKS, 'wordsgen.py')
        r = subprocess.run([sys.executable, '-I', '-B', script, '--root', self.root] + list(args),
                           capture_output=True)
        return r.returncode, r.stdout.decode()

    def test_write_then_check(self):
        self.assertEqual(self.run_gen('--check')[0], 1)
        rc, out = self.run_gen('--write')
        self.assertEqual(rc, 0, out)
        for path in GENERATED:
            self.assertIn('wordsgen: wrote ' + path, out)
        self.assertIn('wordsgen: status "written" 2', out)
        self.assertEqual(self.run_gen('--check'), (0, 'wordsgen: up to date\n'))
        with open(os.path.join(self.root, STRINGS_SV), 'ab') as f:
            f.write(b'\n')
        rc, out = self.run_gen('--check')
        self.assertEqual(rc, 1)
        self.assertIn('wordsgen: differs ' + STRINGS_SV, out)

    def test_summary_hides_free_text(self):
        with open(os.path.join(self.root, CSV), 'wb') as f:
            f.write(register(row('A' + DOT + '1', 'paused: hidden reason')))
        rc, out = self.run_gen('--write')
        self.assertEqual(rc, 0, out)
        self.assertIn('wordsgen: status "paused:" 1', out)
        self.assertIn('wordsgen: list words 20', out)
        self.assertNotIn('hidden', out)

    def test_refusal_names_code_and_row_only(self):
        with open(os.path.join(self.root, CSV), 'wb') as f:
            f.write(register(row('A' + DOT + '1', 'secret status')))
        rc, out = self.run_gen('--write')
        self.assertEqual((rc, out), (1, 'wordsgen: refused register unknown-status row 4\n'))
        self.assertFalse(os.path.exists(os.path.join(self.root, LINES)))

    def test_usage(self):
        self.assertEqual(self.run_gen()[0], 1)
        self.assertEqual(self.run_gen('--write', '--check')[0], 1)


if __name__ == '__main__':
    unittest.main()
