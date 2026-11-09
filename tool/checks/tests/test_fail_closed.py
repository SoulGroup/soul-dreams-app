# Task 2b (D17): fail closed where the lexers cannot tell.
import unittest

import helpers  # noqa: F401
import lex


class Swift(unittest.TestCase):
    def test_slash_where_regex_could_start_raises(self):
        for src in ('let r = /"/; print(x); let t = /"/\n',
                    'let r = #/"/#; print(x); let t = #/"/#\n',
                    'let r = /https?:\\/\\//; print(x)\n',
                    'let r = /[/*]/; print(x); let q = /[*/]/\n'):
            with self.assertRaises(lex.LexError):
                lex.lex_swift(src)

    def test_division_still_lexes(self):
        for src in ('let a = b / 2\n', 'let c = (a + 1) / x[0] / f(2)\n'):
            lx = lex.lex_swift(src)
            self.assertEqual(lx.lits, [])
            self.assertEqual(lx.code, src)

    def test_slash_after_try_raises(self):
        # Task 2c (C2): Apple's own form puts a regex after try.
        with self.assertRaises(lex.LexError):
            lex.lex_swift('if let m = try /(\\d+)x/.wholeMatch(in: s) {}\n')

    def test_division_near_try_still_lexes(self):
        for src in ('let a = try f(x) / 2\n', 'let b = retry / 2\n',
                    'let c = tryCount / 2\n'):
            lx = lex.lex_swift(src)
            self.assertEqual(lx.lits, [])
            self.assertEqual(lx.code, src)
        # TypeScript is unchanged: there, a '/' after try divides.
        src = 'let d = o.try / 2 / 3\n'
        lx = lex.lex_ts(src)
        self.assertEqual(lx.lits, [])
        self.assertEqual(lx.code, src)


class Shell(unittest.TestCase):
    def test_heredoc_word_starting_with_digit_raises(self):
        for src in ('(( y = 1 << 3 ))\nlog_it\n3\n', 'let x=1<<2\n2\n',
                    'echo $[1<<2]\n2\n', "cat <<'2'\nx\n2\n"):
            with self.assertRaises(lex.LexError):
                lex.lex_shell(src)
        lx = lex.lex_shell('cat <<EOF2\nbody\nEOF2\necho done\n')
        self.assertEqual([l.text for l in lx.lits], ['body\n'])


if __name__ == '__main__':
    unittest.main()
