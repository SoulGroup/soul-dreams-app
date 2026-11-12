# The design values generator (D49 a) on invented Design Systems, built
# here in the real file's shape: its four headings, its table headers
# and each value form it uses.
import os
import shutil
import subprocess
import sys
import tempfile
import unittest

import helpers  # noqa: F401  (puts tool/checks on the path)
import designgen
from guardlib import DESIGN, TOKENS

MINUS = '−'
ARROW = '→'


def r(*cells):
    # One table row, built from its cells (no long literal here, G4).
    return '| ' + ' | '.join(cells) + ' |'


TYPE_ROWS = [
    r('type.h2', 'Sorts Mill Goudy', 'Regular', '33px', '1.2', '%s0.02em' % MINUS, 'Titles'),
    r('type.button', 'Inter', 'Semibold', '14px', '1.4', '0', 'Buttons'),
]
LIGHT_ROWS = [
    r('color.page', '#F5F5EC'),
    r('color.surface (rows)', '#FFFFFF'),
    r('color.surface.border', '1px #CCCCCC'),
    r('color.text.summary (a summary)', '#767676, only ever on white'),
    r('color.button', '#FFFFFF, border 1px #CCCCCC, text #333333'),
    r('color.record', 'gradient #8F3D24 %s #6B2B18, text #FFFFFF' % ARROW),
]
DARK_ROWS = [
    r('color.page', '#0F0D29'),
    r('color.surface', 'gradient #3D376E %s #26214F, border #26214F' % ARROW),
    r('color.field', '#CFCDC1, no border'),
    r('color.button.filled', 'as color.button: gradient #F5F5EC %s #ABAB93, text #333333' % ARROW),
    r('color.record', 'as in the light theme'),
]
SPACING_ROWS = [
    r('radius', '30, in both themes'),
    r('space.box', '50px above and below, 30px left and right'),
    r('size.field.search', '50px tall'),
    r('space.bubble', '30px from the left edge, 10px from the right'),
    r('space.turn', '20px more space after the last reply, before each new turn'),
    r('space.label', '20px after "A" label, before the next line'),
    r('space.night.header', '20px above the header, 10px below, in both themes'),
    r('space.end', 'Space below the list: [to set in Framer]'),
    r('Everything else', '[to set in Framer]'),
]


def doc(type_rows=None, light=None, dark=None, spacing=None, extra=''):
    def section(heading, header, rule, rows):
        return '%s\n\nProse.\n\n%s\n%s\n%s\n\n' % (heading, header, rule, '\n'.join(rows))
    return ('# The Design System\n\n'
            + section(designgen.TYPE, r('Role', 'Face', 'Weight', 'Size', 'Line', 'Letter', 'Used for'),
                      r('---', '---', '---', '---', '---', '---', '---'), TYPE_ROWS if type_rows is None else type_rows)
            + section(designgen.LIGHT, r('Role', 'Value'), r('---', '---'),
                      LIGHT_ROWS if light is None else light)
            + section(designgen.DARK, r('Role', 'Value'), r('---', '---'),
                      DARK_ROWS if dark is None else dark)
            + '## 4. Contrast\n\nProse.\n\n'
            + section(designgen.SPACING, r('Role', 'Value'), r('---', '---'),
                      SPACING_ROWS if spacing is None else spacing)
            + extra).encode('utf-8')


def text(data):
    return designgen.generate(data)[TOKENS].decode('utf-8')


class Generate(unittest.TestCase):
    def refused(self, data, code, line=None):
        with self.assertRaises(designgen.DesignError) as ctx:
            designgen.generate(data)
        self.assertEqual(ctx.exception.code, code)
        if line is not None:
            self.assertEqual(ctx.exception.line, line)

    def test_type_roles(self):
        t = text(doc())
        self.assertIn("static const h2 = TypeRole('SortsMillGoudy', FontWeight.w400, 33, 1.2, -0.02);", t)
        self.assertIn("static const button = TypeRole('Inter', FontWeight.w600, 14, 1.4, 0);", t)

    def test_colour_forms(self):
        t = text(doc())
        self.assertIn('static const page = ColourRole(colour: Color(0xFFF5F5EC));', t)
        self.assertIn('static const surfaceBorder = ColourRole(border: Color(0xFFCCCCCC), borderWidth: 1);', t)
        self.assertIn('static const button = ColourRole(colour: Color(0xFFFFFFFF), border: Color(0xFFCCCCCC), '
                      'text: Color(0xFF333333), borderWidth: 1);', t)
        self.assertIn('static const record = ColourRole(colour: Color(0xFF8F3D24), colourEnd: Color(0xFF6B2B18), '
                      'text: Color(0xFFFFFFFF));', t)
        self.assertIn('static const surface = ColourRole(colour: Color(0xFF3D376E), colourEnd: Color(0xFF26214F), '
                      'border: Color(0xFF26214F));', t)
        self.assertIn('static const buttonFilled = ColourRole(colour: Color(0xFFF5F5EC), '
                      'colourEnd: Color(0xFFABAB93), text: Color(0xFF333333));', t)

    def test_as_in_the_light_theme_copies_the_light_value(self):
        t = text(doc())
        dark = t[t.index('abstract final class DarkColours'):]
        self.assertIn('static const record = ColourRole(colour: Color(0xFF8F3D24), colourEnd: Color(0xFF6B2B18), '
                      'text: Color(0xFFFFFFFF));', dark)

    def test_each_theme_has_only_its_own_roles(self):
        t = text(doc())
        light = t[t.index('abstract final class LightColours'):t.index('abstract final class DarkColours')]
        dark = t[t.index('abstract final class DarkColours'):t.index('abstract final class Spacing')]
        self.assertIn('textSummary', light)
        self.assertNotIn('textSummary', dark)
        self.assertIn(' field =', dark)
        self.assertNotIn(' field =', light)

    def test_spacing_forms(self):
        t = text(doc())
        self.assertIn('static const double radius = 30;', t)
        self.assertIn('static const box = EdgeInsets.symmetric(vertical: 50, horizontal: 30);', t)
        self.assertIn('static const double sizeFieldSearch = 50;', t)
        self.assertIn('static const bubble = EdgeInsets.only(left: 30, right: 10);', t)
        self.assertIn('static const double turn = 20;', t)
        self.assertIn('static const nightHeader = EdgeInsets.only(top: 20, bottom: 10);', t)

    def test_an_unset_value_has_no_constant(self):
        t = text(doc())
        self.assertNotIn(' end ', t)
        self.assertIn('  // `space.end`\n', t)
        self.assertEqual(designgen.summary(doc())[-1], 'designgen: unset 1')

    def test_pure_and_carries_the_hash(self):
        data = doc()
        self.assertEqual(designgen.generate(data), designgen.generate(data))
        self.assertIn(designgen.sha256(data), text(data))

    def test_refusals(self):
        self.refused(None, 'missing', 0)
        self.refused(b'\xff', 'not-utf8', 0)
        self.refused(doc().replace(designgen.DARK.encode('utf-8'), b'## 3. Gone'), 'section-missing')
        self.refused(doc(extra=designgen.TYPE + '\n'), 'section-repeated')
        self.refused(doc().replace(b'| Role |', b'| Name |', 1), 'table-header')
        self.refused(doc(light=[r('color.page', '#F5F5EC', 'extra')]), 'table-cells')
        self.refused(doc(type_rows=[r('type.h1', 'Comic', 'Regular', '9px', '1', '0', 'x')]), 'face-unknown')
        self.refused(doc(type_rows=[r('type.h1', 'Inter', 'Bold', '9px', '1', '0', 'x')]), 'weight-unknown')
        self.refused(doc(type_rows=[r('type.h1', 'Inter', 'Regular', '9pt', '1', '0', 'x')]), 'type-form')
        self.refused(doc(light=[r('color.page', '#F5F5EC, almost always')]), 'colour-form')
        self.refused(doc(light=[r('color.page', '#f5f5ec')]), 'colour-form')
        self.refused(doc(light=[r('color.page', '#F5F5EC'), r('color.page', '#FFFFFF')]), 'role-repeated')
        self.refused(doc(dark=[r('color.other', 'as in the light theme')]), 'as-unknown')
        self.refused(doc(spacing=[r('space.x', 'about 20px')]), 'spacing-form')
        self.refused(doc(spacing=[r('Everything else', '10px')]), 'spacing-form')
        self.refused(doc(light=[r('Page colour', '#F5F5EC')]), 'role-form')

    def test_no_prose_reaches_the_tokens(self):
        # D52: comments carry the role name only. Marker words are put in
        # every descriptive place: a type row's "Used for", a role's
        # parenthetical, and a spacing value's text.
        t = text(doc(
            type_rows=[r('type.h6', 'Inter', 'Regular', '9px', '1', '0', 'zebra marker')],
            light=[r('color.page (quagga marker)', '#F5F5EC')],
            dark=[r('color.page', '#0F0D29')],
            spacing=[r('space.turn', '20px after the okapi marker, before the gnu marker')]))
        for word in ('zebra', 'quagga', 'okapi', 'gnu'):
            self.assertNotIn(word, t)
        self.assertIn('/// `type.h6`\n', t)
        self.assertIn('/// `color.page`\n', t)
        self.assertIn('/// `space.turn`\n', t)

    def test_every_role_comment_is_a_role_name_only(self):
        # D52: the invented tables carry every kind of note and "as"
        # form; none reaches a comment. Each role's comment is its name.
        t = text(doc())
        body = t[t.index('abstract final class TypeRoles'):]
        comments = [line for line in body.split('\n') if line.lstrip().startswith('///')]
        self.assertGreaterEqual(len(comments), 20)
        for line in comments:
            if line.startswith('/// Design System'):
                continue
            self.assertRegex(line, r'^  /// `[a-z][a-z0-9.]*`$')
        self.assertNotIn('Noted', t)

    def test_an_after_value_with_other_text_stops(self):
        # D52: trailing text the generator does not fully parse is never
        # dropped silently.
        for value in ('20px after the label, 30px before the image line',
                      '20px after the label',
                      '20px after the label, before the line, and more',
                      '20px more space after the label, before the line, 30px'):
            self.refused(doc(spacing=[r('space.x', value)]), 'spacing-form')

    def test_refusal_names_the_line(self):
        data = doc(light=[r('color.page', '#F5F5EC'), r('color.odd', '#12')])
        line = data.decode('utf-8').split('\n').index(r('color.odd', '#12')) + 1
        self.refused(data, 'colour-form', line)


class Cli(unittest.TestCase):
    def setUp(self):
        self.root = tempfile.mkdtemp(prefix='designgen-')
        os.makedirs(os.path.join(self.root, os.path.dirname(DESIGN)))
        with open(os.path.join(self.root, DESIGN), 'wb') as f:
            f.write(doc())

    def tearDown(self):
        shutil.rmtree(self.root)

    def run_gen(self, *args):
        script = os.path.join(os.path.dirname(designgen.__file__), 'designgen.py')
        r = subprocess.run([sys.executable, '-I', '-B', script] + list(args) + ['--root', self.root],
                           capture_output=True, text=True)
        return r.returncode, r.stdout

    def test_write_then_check(self):
        self.assertEqual(self.run_gen('--check')[0], 1)
        code, out = self.run_gen('--write')
        self.assertEqual(code, 0)
        self.assertIn('designgen: wrote ' + TOKENS, out)
        self.assertEqual(self.run_gen('--check'), (0, 'designgen: up to date\n'))

    def test_hand_edit_differs(self):
        self.run_gen('--write')
        with open(os.path.join(self.root, TOKENS), 'ab') as f:
            f.write(b'// x\n')
        self.assertEqual(self.run_gen('--check'),
                         (1, 'designgen: differs %s\ndesigngen: different\n' % TOKENS))

    def test_refusal_prints_code_and_line_only(self):
        with open(os.path.join(self.root, DESIGN), 'wb') as f:
            f.write(doc(light=[r('color.page', 'secret words')]))
        code, out = self.run_gen('--write')
        self.assertEqual(code, 1)
        self.assertRegex(out, r'^designgen: refused colour-form line \d+\n$')


if __name__ == '__main__':
    unittest.main()
