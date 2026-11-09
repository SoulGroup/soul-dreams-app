import unittest

from helpers import GuardTest, sentence
import g3_literals

A = 'app/lib/a.dart'
MARK = '// not-dreamer-' + 'facing: a test id'


class G3(GuardTest):
    guard = g3_literals

    def test_text_literal_refused(self):
        self.refused({A: "w() => Text('Hi');\n"}, 'dreamer-literal')

    def test_textspan_and_rich_refused(self):
        found = self.refused({A: "w() => Text.rich(TextSpan(text: 'a'));\n"})
        self.assertEqual(found, [(A, 1, 'dreamer-literal')])

    def test_named_arguments_refused(self):
        for name in ('semanticsLabel', 'semanticLabel', 'tooltip', 'label', 'title', 'hintText'):
            self.refused({A: 'w() => f(%s: "x");\n' % name}, 'dreamer-literal')

    def test_parenthesised_named_argument_refused(self):
        self.refused({A: "w() => f(tooltip: ('x'));\n"}, 'dreamer-literal')

    def test_prefixed_text_refused(self):
        self.refused({A: "w() => m.Text('x');\n"}, 'dreamer-literal')

    def test_marker_does_not_excuse_dreamer_literal(self):
        self.refused({A: "w() => Text('a b c'); " + MARK + '\n'}, 'dreamer-literal')

    def test_inside_words_passes(self):
        self.passed({'app/lib/words/lines.g.dart': "w() => Text('Hi'); const s = 'a b c';\n"})

    def test_three_words_unmarked_refused(self):
        self.refused({A: "const s = 'one two three';\n"}, 'unmarked-literal')

    def test_two_words_pass(self):
        self.passed({A: "const s = 'one two';\n"})

    def test_three_words_marked_pass(self):
        self.passed({A: "const s = 'one two three'; " + MARK + '\n'})

    def test_marker_needs_a_reason(self):
        self.refused({A: "const s = 'one two three'; // not-dreamer-facing:\n"}, 'unmarked-literal')

    def test_marker_on_another_line_refused(self):
        self.refused({A: MARK + "\nconst s = 'one two three';\n"}, 'unmarked-literal')

    def test_lookup_inside_text_passes(self):
        self.passed({A: "w() => Text(lines['k']);\n"})

    def test_outside_app_lib_not_scanned(self):
        self.passed({'app/test/a_test.dart': "w() => Text('Hi');\n",
                     'server/src/a.ts': "const s = '%s';\n" % sentence(5)})

    def test_unlexable_refused(self):
        self.refused({A: "const s = 'open;\n"}, 'unlexable')


if __name__ == '__main__':
    unittest.main()
