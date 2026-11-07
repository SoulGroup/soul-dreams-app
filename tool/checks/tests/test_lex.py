import unittest

import helpers  # noqa: F401
import lex


def texts(lx):
    return [l.text for l in lx.lits]


class Dart(unittest.TestCase):
    def test_quotes_raw_and_triple(self):
        lx = lex.lex_dart("a('x'); b(\"y\"); c(r'\\d'); d('''p\nq''');")
        self.assertEqual(texts(lx), ['x', 'y', '\\d', 'p\nq'])
        self.assertEqual(lx.lits[3].line, 1)
        self.assertEqual(lx.lits[3].end_line, 2)

    def test_escaped_quote(self):
        self.assertEqual(texts(lex.lex_dart("f('it\\'s');")), ["it\\'s"])

    def test_interpolation_keeps_code(self):
        lx = lex.lex_dart("f('a ${g('b')} c');")
        self.assertEqual(texts(lx), ["a ${g('b')} c", 'b'])
        self.assertIn('g(', lx.code)
        self.assertNotIn('a ', lx.code)

    def test_nested_block_comment(self):
        lx = lex.lex_dart("/* a /* b */ 'c' */ f('d');")
        self.assertEqual(texts(lx), ['d'])
        self.assertEqual(len(lx.comments), 1)

    def test_line_comment_is_not_code(self):
        lx = lex.lex_dart("x(); // p('q')\ny();")
        self.assertEqual(texts(lx), [])
        self.assertNotIn('p(', lx.code)
        self.assertEqual(lx.comments[0].line, 1)

    def test_frames_and_named(self):
        lx = lex.lex_dart("Text('a'); f(title: 'b'); "
                         "Text(m['k']); Text.rich(TextSpan(text: 'c'));")
        got = [(l.text, l.frame, l.named) for l in lx.lits]
        self.assertEqual(got, [('a', 'Text', ''), ('b', 'f', 'title'), ('k', '[', ''),
                               ('c', 'TextSpan', 'text')])

    def test_unterminated_raises(self):
        with self.assertRaises(lex.LexError):
            lex.lex_dart("f('a);\ng(1);'")


class TypeScript(unittest.TestCase):
    def test_template_and_interpolation(self):
        lx = lex.lex_ts("f(`a ${g('b')}`);")
        self.assertEqual(texts(lx), ["a ${g('b')}", 'b'])

    def test_regex_is_not_a_string(self):
        lx = lex.lex_ts("const r = /it's/g; f('x'); "
                       "const d = a / b / c;")
        self.assertEqual(texts(lx), ['x'])

    def test_block_comment(self):
        lx = lex.lex_ts("/* 'a' */ f('b');")
        self.assertEqual(texts(lx), ['b'])


class Python(unittest.TestCase):
    def test_strings_fstrings_comments(self):
        lx = lex.lex_python("a = 'x'\nb = f'y{a}z'  # c('d')\n"
                            "c = '''p\nq'''\n")
        self.assertEqual(texts(lx), ['x', 'y{a}z', 'p\nq'])
        self.assertEqual(len(lx.comments), 1)
        self.assertNotIn('c(', lx.code)


class Shell(unittest.TestCase):
    def test_quotes_comments_substitution(self):
        lx = lex.lex_shell("a='x y'\nb=\"p $(c 'q') r\" # s('t')\necho $#\n")
        self.assertEqual(texts(lx), ['x y', "p $(c 'q') r", 'q'])
        self.assertEqual(len(lx.comments), 1)
        self.assertIn('c ', lx.code)

    def test_heredoc_body_is_a_literal(self):
        lx = lex.lex_shell("cat <<'EOT'\none two\nEOT\necho done\n")
        self.assertEqual(texts(lx), ['one two\n'])
        self.assertIn('echo', lx.code)

    def test_unclosed_heredoc_raises(self):
        with self.assertRaises(lex.LexError):
            lex.lex_shell('cat <<EOT\nnever closed\n')


if __name__ == '__main__':
    unittest.main()
