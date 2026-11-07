# Task 2a (D16): the lexer fixes, each with its exact input.
import unittest

import helpers  # noqa: F401
import lex


def texts(lx):
    return [l.text for l in lx.lits]


def nested(n):
    # n Dart strings, each inside the last one's interpolation.
    return "'${" * n + '1' + "}'" * n


def nested_shell(n):
    # n shell strings, each inside the last one's substitution.
    return 'echo ' + '"$(' * n + 'x' + ')"' * n + '\n'


class TypeScript(unittest.TestCase):
    def test_slash_after_postfix_is_division(self):
        lx = lex.lex_ts('a = x++ / 2; console.log(y); z = w / 3;')
        self.assertEqual(texts(lx), [])
        self.assertIn('console.log(y)', lx.code)

    def test_slash_after_condition_is_regex(self):
        lx = lex.lex_ts('if (a) /"/.test(b); console.log(x);')
        self.assertEqual(texts(lx), [])
        self.assertIn('console.log(x)', lx.code)
        self.assertEqual(texts(lex.lex_ts("f(a) / 2; g('x') / h(1) / 3;")), ['x'])

    def test_unterminated_regex_raises(self):
        with self.assertRaises(lex.LexError):
            lex.lex_ts('f(); /console.log(1)')


class Python(unittest.TestCase):
    def test_no_trailing_newline(self):
        src = "a = 'x'  # c"
        lx = lex.lex_python(src)
        self.assertEqual(texts(lx), ['x'])
        self.assertEqual(lx.lits[0].pos, 4)
        self.assertEqual(len(lx.comments), 1)
        self.assertEqual(len(lx.code), len(src))


class Nesting(unittest.TestCase):
    def test_deep_nesting_raises_lex_error(self):
        for n in (150, 600):
            with self.assertRaises(lex.LexError):
                lex.lex_dart(nested(n))
            with self.assertRaises(lex.LexError):
                lex.lex_ts(nested(n))
            with self.assertRaises(lex.LexError):
                lex.lex_shell(nested_shell(n))
        self.assertEqual(len(lex.lex_dart(nested(20)).lits), 20)


class Swift(unittest.TestCase):
    def test_multiline_string(self):
        lx = lex.lex_swift('let a = """\none "two"\n"""\nf("b")\n')
        self.assertEqual(texts(lx), ['\none "two"\n', 'b'])
        self.assertEqual(lx.lits[0].end_line, 3)

    def test_interpolation_keeps_code(self):
        lx = lex.lex_swift('f("a \\(g("b")) c")\n')
        self.assertEqual(texts(lx), ['a \\(g("b")) c', 'b'])
        self.assertIn('g(', lx.code)
        self.assertNotIn('a ', lx.code)

    def test_nested_block_comment(self):
        lx = lex.lex_swift('/* a /* b */ "c" */ f("d")\n')
        self.assertEqual(texts(lx), ['d'])
        self.assertEqual(len(lx.comments), 1)


class Frames(unittest.TestCase):
    def test_bare_parenthesis_keeps_call_and_named(self):
        lx = lex.lex_dart("f(tooltip: ('x')); Text(('y')); if (a) g('z');")
        got = [(l.text, l.frame, l.named) for l in lx.lits]
        self.assertEqual(got, [('x', 'f', 'tooltip'), ('y', 'Text', ''), ('z', 'g', '')])


class Shell(unittest.TestCase):
    def test_arithmetic_is_code(self):
        lx = lex.lex_shell('x=$((1 << 2))\necho "$((3<<1))"\n')
        self.assertEqual(texts(lx), ['$((3<<1))'])
        self.assertIn('x=$((1 << 2))', lx.code)

    def test_heredoc_word_with_hyphen(self):
        lx = lex.lex_shell('cat <<END-OF\nbody\nEND-OF\necho done\n')
        self.assertEqual(texts(lx), ['body\n'])
        self.assertIn('echo done', lx.code)


if __name__ == '__main__':
    unittest.main()
