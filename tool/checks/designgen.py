# The design values generator (D49 a). From the Design System's tables
# (docs/source/design-system.md: §1 type, §2 and §3 colour, §5 spacing)
# to app/lib/design/tokens.g.dart, every value named by its role. A pure
# function of the file's bytes, so G1 can run it again and compare. It
# knows each value form the tables use and stops on any other, with a
# reason code and a line number, never a file's content. No prose of the
# Design System reaches the output: a comment carries the role name only
# (D52).
# Usage: designgen.py --write           write tokens.g.dart
#        designgen.py --check           exit 1 if it differs
#        add --root DIR to read the input, --out DIR to write or compare
#        elsewhere (the tests and the plan's proof).
# Exit 0 done, 1 refused or different, 2 internal error.
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TOP = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)

from guardlib import DESIGN, TOKENS, report, sha256  # noqa: E402
from wordsgen import read, write_atomic  # noqa: E402

TYPE = '## 1. Type'
LIGHT = '## 2. Colour: the light theme'
DARK = '## 3. Colour: the dark theme'
SPACING = '## 5. Spacing and radius'
TYPE_HEADER = ('Role', 'Face', 'Weight', 'Size', 'Line', 'Letter', 'Used for')
VALUE_HEADER = ('Role', 'Value')
# Each face the system names, and its font family in pubspec.yaml. A new
# face needs its font files first, so it stops the generator.
FACES = {'Tangerine': 'Tangerine', 'Sorts Mill Goudy': 'SortsMillGoudy', 'Inter': 'Inter',
         'Nunito': 'Nunito', 'Habibi': 'Habibi'}
WEIGHTS = {'Regular': 'FontWeight.w400', 'Semibold': 'FontWeight.w600'}
# The notes a colour value may carry after its colours; kept as comments.
NOTES = ('only ever on white', 'and on the bubble gradient everywhere',
         "a row's summary included", 'no border')
UNSET = '[to set in Framer]'
EVERYTHING_ELSE = 'Everything else'
MINUS = '−'
ARROW = '→'
HEXC = r'#([0-9A-F]{6})'
ROLE = re.compile(r'^([a-z][a-z0-9]*(?:\.[a-z0-9]+)*)(?: \((.+)\))?$')
NUMBER = re.compile(r'^\d+(?:\.\d+)?$')
SIZE = re.compile(r'^(\d+)px$')
LETTER = re.compile(r'^(-?\d+(?:\.\d+)?)em$')
SOLID = re.compile('^' + HEXC + '$')
GRADIENT = re.compile('^gradient ' + HEXC + ' ' + ARROW + ' ' + HEXC + '$')
LINE_ONLY = re.compile(r'^(\d+)px ' + HEXC + '$')
BORDER = re.compile(r'^border (?:(\d+)px )?' + HEXC + '$')
TEXT = re.compile('^text ' + HEXC + '$')
AS_ROLE = re.compile(r'^as color\.[a-z.]+: (.+)$')
AS_LIGHT = 'as in the light theme'
SCALAR = re.compile(r'^(\d+)(?:, in both themes)?$')
BOX = re.compile(r'^(\d+)px above and below, (\d+)px left and right$')
SIDES = re.compile(r'^(\d+)px from the left edge, (\d+)px from the right$')
HEADER_GAP = re.compile(r'^(\d+)px above the header, (\d+)px below(?:, in both themes)?$')
TALL = re.compile(r'^(\d+)px tall$')
# D52: "N px after A, before B": A and B are prose the generator does not
# use, and hold no digit or comma, so no second value or part is dropped.
AFTER = re.compile(r'^(\d+)px (?:more space )?after [^\d,]+, before [^\d,]+$')


class DesignError(Exception):
    def __init__(self, code, line):
        Exception.__init__(self, code)
        self.code = code
        self.line = line


def decode(data):
    if data is None:
        raise DesignError('missing', 0)
    try:
        return data.decode('utf-8')
    except UnicodeDecodeError:
        raise DesignError('not-utf8', 0)


def table(lines, heading, header):
    # [(line number, cells)] of the first table under heading, which must
    # stand exactly once.
    at = [n for n, line in enumerate(lines) if line == heading]
    if len(at) != 1:
        raise DesignError('section-missing' if not at else 'section-repeated', 0)
    n = at[0] + 1
    while n < len(lines) and not lines[n].startswith('|'):
        if lines[n].startswith('## '):
            raise DesignError('table-missing', at[0] + 1)
        n += 1
    rows = []
    while n < len(lines) and lines[n].startswith('|'):
        cells = tuple(c.strip() for c in lines[n].strip().strip('|').split('|'))
        rows.append((n + 1, cells))
        n += 1
    if len(rows) < 2 or rows[0][1] != header or set(''.join(rows[1][1])) - set('-: '):
        raise DesignError('table-header', at[0] + 1)
    for line, cells in rows[2:]:
        if len(cells) != len(header):
            raise DesignError('table-cells', line)
    return rows[2:]


def role_of(cell, line):
    m = ROLE.match(cell)
    if not m:
        raise DesignError('role-form', line)
    return m.group(1), m.group(2)


def ident(role, line):
    parts = role.split('.')
    if parts[0] in ('type', 'color', 'space') and len(parts) > 1:
        parts = parts[1:]
    name = parts[0] + ''.join(p[:1].upper() + p[1:] for p in parts[1:])
    if not re.match(r'^[a-z][A-Za-z0-9]*$', name):
        raise DesignError('role-form', line)
    return name


def number(text):
    return text.replace(MINUS, '-')


def read_type(lines):
    out = []
    for line, (role, face, weight, size, height, letter, used) in table(lines, TYPE, TYPE_HEADER):
        role, _ = role_of(role, line)
        if not role.startswith('type.'):
            raise DesignError('role-form', line)
        if face not in FACES:
            raise DesignError('face-unknown', line)
        if weight not in WEIGHTS:
            raise DesignError('weight-unknown', line)
        m = SIZE.match(size)
        e = LETTER.match(number(letter))
        if not m or not NUMBER.match(height) or not (letter == '0' or e):
            raise DesignError('type-form', line)
        out.append((line, role, used, (FACES[face], WEIGHTS[weight], m.group(1), height,
                                       e.group(1) if e else '0')))
    return out


def colour_value(value, line):
    # {'colour', 'end', 'border', 'width', 'text'} and the notes.
    v = {}
    notes = []
    m = AS_ROLE.match(value)
    if m:
        notes.append(value.split(':', 1)[0])
        value = m.group(1)
    parts = value.split(', ')
    first = parts[0]
    if SOLID.match(first):
        v['colour'] = SOLID.match(first).group(1)
    elif GRADIENT.match(first):
        v['colour'], v['end'] = GRADIENT.match(first).groups()
    elif LINE_ONLY.match(first):
        v['width'], v['border'] = LINE_ONLY.match(first).groups()
    else:
        raise DesignError('colour-form', line)
    for part in parts[1:]:
        if BORDER.match(part) and 'border' not in v:
            v['width'], v['border'] = BORDER.match(part).groups()
        elif TEXT.match(part) and 'text' not in v:
            v['text'] = TEXT.match(part).group(1)
        elif part in NOTES:
            notes.append(part)
        else:
            raise DesignError('colour-form', line)
    return v, notes


def read_colours(lines, heading, light=None):
    out = []
    seen = {}
    for line, (role, value) in table(lines, heading, VALUE_HEADER):
        role, note = role_of(role, line)
        if not role.startswith('color.'):
            raise DesignError('role-form', line)
        if role in seen:
            raise DesignError('role-repeated', line)
        if value == AS_LIGHT:
            if light is None or role not in light:
                raise DesignError('as-unknown', line)
            v, notes = light[role][0], [AS_LIGHT]
        else:
            v, notes = colour_value(value, line)
        seen[role] = (v, notes)
        out.append((line, role, note, v, notes))
    return out, seen


def read_spacing(lines):
    out = []
    unset = []
    seen = set()
    for line, (role, value) in table(lines, SPACING, VALUE_HEADER):
        if role == EVERYTHING_ELSE:
            if value != UNSET:
                raise DesignError('spacing-form', line)
            continue
        role, _ = role_of(role, line)
        if role in seen:
            raise DesignError('role-repeated', line)
        seen.add(role)
        if value.endswith(UNSET):
            unset.append(role)
            continue
        for rx, kind in ((SCALAR, 'scalar'), (BOX, 'box'), (SIDES, 'sides'),
                         (HEADER_GAP, 'gap'), (TALL, 'scalar'), (AFTER, 'scalar')):
            m = rx.match(value)
            if m:
                out.append((line, role, value, kind, m.groups()))
                break
        else:
            raise DesignError('spacing-form', line)
    return out, unset


def comment(text):
    return '  /// ' + ' '.join(text.split())


def colour(hexa):
    return 'Color(0xFF%s)' % hexa


def colour_const(role, note, v, notes, line):
    args = []
    for key, name in (('colour', 'colour'), ('end', 'colourEnd'), ('border', 'border'),
                      ('text', 'text')):
        if key in v:
            args.append('%s: %s' % (name, colour(v[key])))
    if v.get('width'):
        args.append('borderWidth: %s' % v['width'])
    doc = [comment('`%s`' % role)]
    if notes:
        doc.append(comment('Noted: ' + '; '.join(notes) + '.'))
    return doc + ['  static const %s = ColourRole(%s);' % (ident(role, line), ', '.join(args))]


HEAD = ''.join(line + '\n' for line in (
    '// GENERATED by tool/checks/designgen.py from docs/source/design-system.md',
    '// (sha256 @SHA@). Do not edit: import the Design System again.',
    '',
    "import 'package:flutter/painting.dart';",
    '',
    '/// A type role (Design System §1). Sizes are logical',
    "/// pixels and grow with the phone's text size; [height]",
    '/// is a multiple of the size.',
    'final class TypeRole {',
    '  const TypeRole(this.family, this.weight, this.size, this.height, this.letterEm);',
    '',
    '  /// The font family, as pubspec.yaml declares it.',
    '  final String family;',
    '  final FontWeight weight;',
    '  final double size;',
    '  final double height;',
    '',
    '  /// Letter spacing in em.',
    '  final double letterEm;',
    '',
    '  /// Letter spacing in logical pixels.',
    '  double get letterSpacing => letterEm * size;',
    '',
    '  TextStyle style(Color colour) => TextStyle(',
    '        fontFamily: family,',
    '        fontWeight: weight,',
    '        fontSize: size,',
    '        height: height,',
    '        letterSpacing: letterSpacing,',
    '        color: colour,',
    '      );',
    '}',
    '',
    '/// A colour role (Design System §2, §3): a colour, or',
    '/// a gradient from [colour] to [colourEnd], with the',
    '/// border and text colour the role names. A part the',
    '/// role does not name is null.',
    'final class ColourRole {',
    '  const ColourRole({this.colour, this.colourEnd, this.border, this.borderWidth, this.text});',
    '',
    '  final Color? colour;',
    '  final Color? colourEnd;',
    '  final Color? border;',
    '  final double? borderWidth;',
    '  final Color? text;',
    '',
    '  bool get isGradient => colourEnd != null;',
    '}',
    '',
))


def tokens_dart(type_rows, light, dark, spacing, unset, digest):
    out = [HEAD.replace('@SHA@', digest)]
    out.append('/// Design System §1.\nabstract final class TypeRoles {\n')
    body = []
    for line, role, used, (family, weight, size, height, letter) in type_rows:
        body.append('\n'.join([comment('`%s`' % role),
                               "  static const %s = TypeRole('%s', %s, %s, %s, %s);"
                               % (ident(role, line), family, weight, size, height, letter)]))
    out.append('\n\n'.join(body) + '\n}\n\n')
    for name, section, rows in (('LightColours', '§2, the light theme', light),
                                ('DarkColours', '§3, the dark theme', dark)):
        out.append('/// Design System %s.\nabstract final class %s {\n' % (section, name))
        out.append('\n\n'.join('\n'.join(colour_const(role, note, v, notes, line))
                               for line, role, note, v, notes in rows) + '\n}\n\n')
    out.append('/// Design System §5, in logical pixels.\n')
    out.append('abstract final class Spacing {\n')
    body = []
    for line, role, value, kind, g in spacing:
        if kind == 'scalar':
            code = '  static const double %s = %s;' % (ident(role, line), g[0])
        elif kind == 'box':
            code = ('  static const %s = EdgeInsets.symmetric(vertical: %s, horizontal: %s);'
                    % (ident(role, line), g[0], g[1]))
        elif kind == 'sides':
            code = ('  static const %s = EdgeInsets.only(left: %s, right: %s);'
                    % (ident(role, line), g[0], g[1]))
        else:
            code = ('  static const %s = EdgeInsets.only(top: %s, bottom: %s);'
                    % (ident(role, line), g[0], g[1]))
        body.append(comment('`%s`' % role) + '\n' + code)
    out.append('\n\n'.join(body) + '\n')
    if unset:
        out.append('\n  // Not set in the source yet ([to set in Framer]),\n')
        out.append('  // so no constant:\n')
        out.append(''.join('  // `%s`\n' % role for role in unset))
    out.append('}\n')
    return ''.join(out)


def parse(data):
    lines = decode(data).split('\n')
    type_rows = read_type(lines)
    light, light_roles = read_colours(lines, LIGHT)
    dark, _ = read_colours(lines, DARK, light_roles)
    spacing, unset = read_spacing(lines)
    return type_rows, light, dark, spacing, unset


def generate(data):
    # {repository path: bytes}: the one generated file.
    type_rows, light, dark, spacing, unset = parse(data)
    text = tokens_dart(type_rows, light, dark, spacing, unset, sha256(data))
    return {TOKENS: text.encode('utf-8')}


def summary(data):
    type_rows, light, dark, spacing, unset = parse(data)
    return ['designgen: type %d' % len(type_rows), 'designgen: light %d' % len(light),
            'designgen: dark %d' % len(dark), 'designgen: spacing %d' % len(spacing),
            'designgen: unset %d' % len(unset)]


def main(argv):
    mode, root, out = None, TOP, None
    args = list(argv)
    while args:
        a = args.pop(0)
        if a in ('--write', '--check') and mode is None:
            mode = a
        elif a in ('--root', '--out') and args:
            if a == '--root':
                root = args.pop(0)
            else:
                out = args.pop(0)
        else:
            mode = None
            break
    if mode is None:
        report('designgen: usage: --write | --check, with --root DIR, --out DIR')
        return 1
    out = out or root
    try:
        data = read(root, DESIGN)
        outputs = generate(data)
        lines = summary(data)
    except DesignError as e:
        report('designgen: refused %s line %d' % (e.code, e.line))
        return 1
    if mode == '--write':
        if read(out, TOKENS) != outputs[TOKENS]:
            write_atomic(out, TOKENS, outputs[TOKENS])
            report('designgen: wrote ' + TOKENS)
        for line in lines:
            report(line)
        return 0
    differs = read(out, TOKENS) != outputs[TOKENS]
    if differs:
        report('designgen: differs ' + TOKENS)
    report('designgen: %s' % ('different' if differs else 'up to date'))
    return 1 if differs else 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception as e:  # never print a message: it could quote a file
        report('designgen: internal error ' + type(e).__name__)
        sys.exit(2)
