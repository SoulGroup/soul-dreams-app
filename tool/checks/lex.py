# Small lexers for the guards: string literals, comments, and the code
# with both blanked out. Standard library only. Dart, TypeScript or
# JavaScript, Swift, Python and POSIX shell. Unclear input raises
# LexError, which the guards turn into a finding (they fail closed).
import bisect
import io
import tokenize


class LexError(Exception):
    pass


# How deep strings may nest inside interpolations or substitutions.
# Deeper input is refused, well before Python's own recursion limit.
MAX_NESTING = 100


class Lit:
    # One string literal. text is the source between the quotes,
    # interpolations included. frame is the call (or bracket) it sits
    # directly inside; named is the named argument it is the value of.
    def __init__(self, text, pos, line, end_line, frame='', named=''):
        self.text = text
        self.pos = pos
        self.line = line
        self.end_line = end_line
        self.frame = frame
        self.named = named


class Comment:
    def __init__(self, text, start, end, line, end_line):
        self.text = text
        self.start = start
        self.end = end
        self.line = line
        self.end_line = end_line


class Lexed:
    def __init__(self, src, lits, comments, code):
        self.src = src
        self.lits = sorted(lits, key=lambda x: x.pos)
        self.comments = comments
        self.code = code  # strings and comments blanked

    def without_comments(self):
        out = list(self.src)
        for c in self.comments:
            _blank(out, c.start, c.end)
        return ''.join(out)


def _blank(out, a, b):
    for k in range(a, b):
        if out[k] != '\n':
            out[k] = ' '


class _Lines:
    def __init__(self, src):
        self.starts = [0]
        for i, ch in enumerate(src):
            if ch == '\n':
                self.starts.append(i + 1)

    def line(self, pos):
        return bisect.bisect_right(self.starts, pos)


IDENT_START = set('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$')
IDENT = IDENT_START | set('0123456789')
REGEX_KEYWORDS = {
    'return', 'typeof', 'instanceof', 'in', 'of', 'new', 'delete', 'void',
    'throw', 'case', 'do', 'else', 'yield', 'await',
}
# A '/' after the ')' of one of these starts a regex: if (a) /x/.test(b)
PAREN_KEYWORDS = {'if', 'while', 'for', 'with'}
# Swift only: a '/' after one of these can start a regex, as in
# try /x/.wholeMatch(in: s). TypeScript is unchanged.
SWIFT_REGEX_KEYWORDS = {'try'}
NO_FRAME = ('', '', False)


class _CLike:
    # Dart, TypeScript and JavaScript ('ts'), or Swift. A frame is
    # (name, named, bare): the call or bracket a literal sits in, the
    # named argument a bare parenthesis stands for, and whether the
    # '(' was bare rather than a call.
    def __init__(self, src, lang):
        self.s = src
        self.n = len(src)
        self.i = 0
        self.lang = lang
        self.out = list(src)
        self.lines = _Lines(src)
        self.lits = []
        self.comments = []
        self.frames = []
        self.prev = []
        self.chain = ''
        self.nesting = 0

    def run(self):
        self.code(None)
        return Lexed(self.s, self.lits, self.comments, ''.join(self.out))

    def push(self, kind, value):
        self.prev.append((kind, value))
        del self.prev[:-3]

    def comment(self, a, b):
        ln = self.lines.line
        self.comments.append(Comment(self.s[a:b], a, b, ln(a), ln(max(a, b - 1))))
        _blank(self.out, a, b)
        self.i = b

    def block_end(self, a):
        s = self.s
        if self.lang == 'ts':
            j = s.find('*/', a + 2)
            if j < 0:
                raise LexError('comment')
            return j + 2
        depth = 0
        j = a
        while j < self.n:
            if s.startswith('/*', j):
                depth += 1
                j += 2
            elif s.startswith('*/', j):
                depth -= 1
                j += 2
                if depth == 0:
                    return j
            else:
                j += 1
        raise LexError('comment')

    def regex_allowed(self):
        # A '/' starts a regex where an operand may begin, and divides
        # where one has just ended.
        if not self.prev:
            return True
        kind, value = self.prev[-1]
        if kind == 'close':
            return value in PAREN_KEYWORDS
        if kind == 'p':
            return value not in (']', '++', '--')
        if kind == 'id':
            return value in REGEX_KEYWORDS or (
                self.lang == 'swift' and value in SWIFT_REGEX_KEYWORDS)
        return False

    def regex(self):
        s = self.s
        a = self.i
        j = a + 1
        in_class = False
        closed = False
        while j < self.n:
            c = s[j]
            if c == '\\':
                j += 2
                continue
            if c == '\n':
                raise LexError('regex')
            if c == '[':
                in_class = True
            elif c == ']':
                in_class = False
            elif c == '/' and not in_class:
                j += 1
                closed = True
                break
            j += 1
        if not closed:
            raise LexError('regex')
        while j < self.n and s[j] in IDENT:
            j += 1
        _blank(self.out, a, j)
        self.i = j
        self.push('re', '')

    def named_here(self):
        if (len(self.prev) >= 2 and self.prev[-1] == ('p', ':')
                and self.prev[-2][0] == 'id'):
            return self.prev[-2][1]
        return ''

    def where(self):
        # (frame, named) for a literal or a bare '(' at this point.
        top = self.frames[-1] if self.frames else NO_FRAME
        return top[0], self.named_here() or (top[1] if top[2] else '')

    def paren(self):
        # A call's '(' takes the call's name. A bare '(' keeps the
        # enclosing call and named argument: f(tooltip: ('x')) is
        # still f's tooltip.
        if self.prev and self.prev[-1][0] == 'id':
            return (self.chain, '', False)
        name, named = self.where()
        return (name or '(', named, True)

    def swift_string_at(self, i):
        j = i
        while j < self.n and self.s[j] == '#':
            j += 1
        return j < self.n and self.s[j] == '"'

    def code(self, close):
        # close is None at the top level, or the character that ends
        # the interpolation being read: '}' after '${', ')' after '\('.
        s = self.s
        opener = {'}': '{', ')': '('}.get(close)
        depth = 0
        while self.i < self.n:
            i = self.i
            c = s[i]
            if c in ' \t\r\n':
                self.i += 1
                continue
            if s.startswith('//', i):
                j = s.find('\n', i)
                self.comment(i, self.n if j < 0 else j)
                continue
            if s.startswith('/*', i):
                self.comment(i, self.block_end(i))
                continue
            if self.lang == 'ts' and c == '/' and self.regex_allowed():
                self.regex()
                continue
            if self.lang == 'swift':
                # Swift's regex literals are not read: a '/' where one
                # could start makes the file unlexable (fail closed).
                if c == '/' and self.regex_allowed():
                    raise LexError('regex')
                if c in '"#' and self.swift_string_at(i):
                    self.swift_string(i)
                    continue
                if c == "'":
                    raise LexError('quote')
            elif c in '\'"' or (self.lang == 'ts' and c == '`'):
                self.dart_ts_string(i, i, False)
                continue
            if (self.lang == 'dart' and c == 'r' and i + 1 < self.n and s[i + 1] in '\'"'
                    and (i == 0 or s[i - 1] not in IDENT)):
                self.dart_ts_string(i, i + 1, True)
                continue
            if c in IDENT_START:
                j = i
                while j < self.n and s[j] in IDENT:
                    j += 1
                word = s[i:j]
                if (len(self.prev) >= 2 and self.prev[-1] == ('p', '.')
                        and self.prev[-2][0] == 'id'):
                    self.chain = self.chain + '.' + word
                else:
                    self.chain = word
                self.push('id', word)
                self.i = j
                continue
            if c.isdigit():
                j = i
                while j < self.n and (s[j] in IDENT or s[j] == '.'):
                    j += 1
                self.push('num', s[i:j])
                self.i = j
                continue
            if c in '+-' and s.startswith(c * 2, i):
                self.push('p', c * 2)
                self.i += 2
                continue
            if c == close and depth == 0:
                self.i += 1
                return
            if c == opener:
                depth += 1
            elif c == close:
                depth -= 1
            if c == '(':
                self.frames.append(self.paren())
            elif c in '[{':
                self.frames.append((c, '', False))
            elif c in ')]}':
                top = self.frames.pop() if self.frames else NO_FRAME
                if c == ')':
                    self.push('close', '' if top[2] else top[0])
                    self.i += 1
                    continue
            self.push('p', c)
            self.i += 1
        if close:
            raise LexError('interpolation')

    def dart_ts_string(self, start, q_pos, raw):
        s = self.s
        q = s[q_pos]
        triple = self.lang == 'dart' and s.startswith(q * 3, q_pos)
        delim = q * 3 if triple else q
        self.string(start, q_pos + len(delim), delim, triple or q == '`',
                    None if raw else '\\', None if raw else '${', '}')

    def swift_string(self, start):
        s = self.s
        j = start
        while s[j] == '#':
            j += 1
        hashes = s[start:j]
        q = '"""' if s.startswith('"""', j) else '"'
        self.string(start, j + len(q), q + hashes, q == '"""',
                    '\\' + hashes, '\\' + hashes + '(', ')')

    def string(self, start, content, delim, multiline, escape, interp, close):
        s = self.s
        frame, named = self.where()
        j = content
        mark = start
        end = None
        while j < self.n:
            if s.startswith(delim, j):
                end = j
                j += len(delim)
                break
            c = s[j]
            if c == '\n' and not multiline:
                raise LexError('string')
            if interp and s.startswith(interp, j):
                _blank(self.out, mark, j + len(interp))
                self.i = j + len(interp)
                self.nesting += 1
                if self.nesting > MAX_NESTING:
                    raise LexError('nesting')
                saved = self.prev
                self.prev = []
                self.frames.append((interp, '', False))
                self.code(close)
                self.frames.pop()
                self.prev = saved
                self.nesting -= 1
                j = self.i
                mark = j - 1
                continue
            if escape and s.startswith(escape, j):
                j += len(escape) + 1
                continue
            j += 1
        if end is None:
            raise LexError('string')
        _blank(self.out, mark, j)
        ln = self.lines.line
        self.lits.append(Lit(s[content:end], start, ln(start), ln(end), frame, named))
        self.i = j
        self.push('s', '')


def lex_dart(src):
    return _CLike(src, 'dart').run()


def lex_ts(src):
    return _CLike(src, 'ts').run()


def lex_swift(src):
    return _CLike(src, 'swift').run()


def _py_body(tok):
    k = 0
    while k < len(tok) and tok[k] not in '\'"':
        k += 1
    body = tok[k:]
    q = body[:3] if body[:3] in ('"""', "'''") else body[:1]
    return body[len(q):len(body) - len(q)]


def lex_python(src):
    # tokenize wants a final newline. One is added after the last
    # character, so no position moves, and it is dropped again.
    padded = src if src.endswith('\n') else src + '\n'
    lines = _Lines(padded)
    out = list(padded)
    lits = []
    comments = []
    open_strings = []

    def pos(rc):
        return lines.starts[rc[0] - 1] + rc[1]

    try:
        for tok in tokenize.generate_tokens(io.StringIO(padded).readline):
            name = tokenize.tok_name[tok.type]
            a, b = pos(tok.start), pos(tok.end)
            if name == 'COMMENT':
                comments.append(Comment(tok.string, a, b, tok.start[0], tok.end[0]))
                _blank(out, a, b)
            elif name == 'STRING':
                lits.append(Lit(_py_body(tok.string), a, tok.start[0], tok.end[0]))
                _blank(out, a, b)
            elif name.endswith('STRING_START'):
                open_strings.append((a, tok.start[0]))
            elif name.endswith('STRING_END'):
                a0, l0 = open_strings.pop()
                lits.append(Lit(_py_body(padded[a0:b]), a0, l0, tok.end[0]))
                _blank(out, a0, b)
            elif name == 'ERRORTOKEN' and tok.string.strip():
                raise LexError('python')
    except (tokenize.TokenError, SyntaxError, IndexError):
        raise LexError('python')
    return Lexed(src, lits, comments, ''.join(out[:len(src)]))


class _Shell:
    def __init__(self, src):
        self.s = src
        self.n = len(src)
        self.i = 0
        self.out = list(src)
        self.lines = _Lines(src)
        self.lits = []
        self.comments = []
        self.heredocs = []
        self.nesting = 0

    def run(self):
        self.code(False)
        if self.heredocs:
            raise LexError('heredoc')
        return Lexed(self.s, self.lits, self.comments, ''.join(self.out))

    def lit(self, a, content, end):
        ln = self.lines.line
        self.lits.append(Lit(self.s[content:end], a, ln(a), ln(max(a, end))))

    def arithmetic_end(self, a):
        # $(( ... )) is arithmetic, which is code: '<<' in it is a
        # shift, not a heredoc. Returns the position after the '))'.
        s = self.s
        depth = 0
        j = a + 3
        while j < self.n:
            if s[j] == '(':
                depth += 1
            elif s[j] == ')':
                if depth == 0:
                    if s.startswith('))', j):
                        return j + 2
                    raise LexError('arithmetic')
                depth -= 1
            j += 1
        raise LexError('arithmetic')

    def code(self, until_paren):
        s = self.s
        depth = 0
        while self.i < self.n:
            i = self.i
            c = s[i]
            if c == '\\':
                self.i += 2
                continue
            if c == '\n':
                self.i += 1
                if self.heredocs:
                    self.read_heredocs()
                continue
            if c == '#' and (i == 0 or s[i - 1] in ' \t\n;&|()'):
                j = s.find('\n', i)
                j = self.n if j < 0 else j
                ln = self.lines.line
                self.comments.append(Comment(s[i:j], i, j, ln(i), ln(i)))
                _blank(self.out, i, j)
                self.i = j
                continue
            if c == "'":
                j = s.find("'", i + 1)
                if j < 0:
                    raise LexError('quote')
                self.lit(i, i + 1, j)
                _blank(self.out, i, j + 1)
                self.i = j + 1
                continue
            if s.startswith("$'", i):
                self.double(i, i + 1, "'")
                continue
            if c == '"':
                self.double(i, i, '"')
                continue
            if s.startswith('$((', i):
                self.i = self.arithmetic_end(i)
                continue
            if s.startswith('<<', i) and not s.startswith('<<<', i):
                self.heredoc_start()
                continue
            if until_paren:
                if c == '(':
                    depth += 1
                elif c == ')':
                    if depth == 0:
                        self.i += 1
                        return
                    depth -= 1
            self.i += 1
        if until_paren:
            raise LexError('paren')

    def double(self, a, q_pos, q):
        s = self.s
        j = q_pos + 1
        mark = a
        while j < self.n:
            c = s[j]
            if c == '\\':
                j += 2
                continue
            if c == q:
                self.lit(a, q_pos + 1, j)
                _blank(self.out, mark, j + 1)
                self.i = j + 1
                return
            if q == '"' and s.startswith('$((', j):
                j = self.arithmetic_end(j)
                continue
            if q == '"' and s.startswith('$(', j):
                _blank(self.out, mark, j + 2)
                self.i = j + 2
                self.nesting += 1
                if self.nesting > MAX_NESTING:
                    raise LexError('nesting')
                self.code(True)
                self.nesting -= 1
                j = self.i
                mark = j - 1
                continue
            j += 1
        raise LexError('quote')

    def heredoc_start(self):
        s = self.s
        j = self.i + 2
        strip = False
        if j < self.n and s[j] == '-':
            strip = True
            j += 1
        while j < self.n and s[j] in ' \t':
            j += 1
        if j < self.n and s[j] in '\'"':
            q = s[j]
            k = s.find(q, j + 1)
            if k < 0:
                raise LexError('heredoc')
            word = s[j + 1:k]
            j = k + 1
        else:
            k = j
            while k < self.n and (s[k].isalnum() or s[k] in '_-'):
                k += 1
            word = s[j:k]
            j = k
        # A word that starts with a digit is a shift in arithmetic, as
        # in (( 1 << 3 )), let x=1<<2 or $[1<<2]. Refused (fail closed).
        if not word or word[0].isdigit():
            raise LexError('heredoc')
        self.heredocs.append((word, strip))
        self.i = j

    def read_heredocs(self):
        s = self.s
        for word, strip in self.heredocs:
            a = self.i
            j = a
            while True:
                if j >= self.n:
                    raise LexError('heredoc')
                k = s.find('\n', j)
                k = self.n if k < 0 else k
                line = s[j:k]
                if (line.lstrip('\t') if strip else line) == word:
                    ln = self.lines.line
                    self.lits.append(Lit(s[a:j], a, ln(a), ln(max(a, j - 1))))
                    _blank(self.out, a, j)
                    self.i = min(k + 1, self.n)
                    break
                j = k + 1
        self.heredocs = []


def lex_shell(src):
    return _Shell(src).run()
