# The words generator (R1; D32, D36). From the places register and the
# founder's lists to the app's words: lines.g.dart, lists.g.dart, and
# the iOS home-screen name and microphone text. A pure function of the
# two files' bytes, so G1 can run it again and compare. It stops on
# anything it does not expect, with a reason code and a row number,
# never a file's content.
# Usage: wordsgen.py --write           write the five files (the owner)
#        wordsgen.py --check           exit 1 if any file differs
#        add --root DIR to read the inputs, --out DIR to write or compare
#        elsewhere (the tests and the plan's proof).
# Exit 0 done, 1 refused or different, 2 internal error.
import csv
import io
import os
import re
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
TOP = os.path.dirname(os.path.dirname(HERE))
sys.path.insert(0, HERE)

from guardlib import (CSV, GENERATED, LINES, LIST_WORDS, LISTS, STRINGS_EN,  # noqa: E402
                      STRINGS_SV, WORDS_XCCONFIG, report, sha256)

HEADER = ('handle', 'place', 'source', 'screen', 'also_on', 'moment', 'must', 'never',
          'length', 'status', 'draft', 'english', 'swedish', 'flag')
# The statuses with a line, and whether the line is a stand-in (R1).
LINE = {'written': False, 'written, in its parts': False,
        'composed (stand-in written)': True}
# D36 Q2: this status may have both fields empty; its parts carry the text.
IN_PARTS = 'written, in its parts'
# Known statuses with no line. Waiting places show their handle; the
# others have no constant at all (D32 Q6, Q7).
WAITING = ('to rewrite', 'to write', 'composed, no stand-in')
WAITING_PREFIXES = ('paused:', 'blocked:')
NO_LINE = ('retired', 'no line: by decision', 'no line: prohibition')
MERGED = 'merged into '
# Each slot: its token in the register, its Dart argument and type.
SLOTS = (('{n}', 'n', 'int'), ('{pointed image}', 'pointedImage', 'String'),
         ('{tradition}', 'tradition', 'String'), ('{read image}', 'readImage', 'String'))
# D36 Q1: the register's real forms, W3, P1, C4-P·2, C125-I·3, MP·55.
HANDLE = re.compile(r'^[A-Z][A-Z0-9]*(-[A-Z0-9]+)*(·[0-9]+)?$')
APP_NAME = 'MP·55'
MIC = 'EM·3'
# D36 Q3: "## TECH·n — <title>", n from 1 to 5, in this order.
TECH = tuple('TECH·%d' % n for n in range(1, 6))
LIST_HEADING = re.compile(r'^## (TECH·[1-5]) — \S')
REGISTER = 'register'
LIST_FILE = 'lists'


class WordsError(Exception):
    def __init__(self, source, code, row):
        Exception.__init__(self, code)
        self.source = source
        self.code = code
        self.row = row


class Place:
    def __init__(self, row, handle, en, sv, stand_in, slots):
        self.row = row
        self.handle = handle
        self.en = en
        self.sv = sv
        self.stand_in = stand_in
        self.slots = slots


def decode(data, source):
    if data is None:
        raise WordsError(source, 'missing', 0)
    try:
        text = data.decode('utf-8')
    except UnicodeDecodeError:
        raise WordsError(source, 'not-utf8', 0)
    return text[1:] if text.startswith('﻿') else text


def has_control(text):
    return any(ord(c) < 32 or ord(c) == 127 for c in text)


def ident(handle):
    # The Dart name: the handle with "·" and "-" as "_" (D36 Q1).
    return handle.replace('·', '_').replace('-', '_')


def classify(status):
    if status in LINE:
        return 'line'
    if status in WAITING or status.startswith(WAITING_PREFIXES):
        return 'waiting'
    if status in NO_LINE:
        return 'none'
    if status.startswith(MERGED):
        return 'merged'
    return None


def label(status):
    # The status as counted in the summary: free text is never shown.
    for prefix in WAITING_PREFIXES:
        if status.startswith(prefix):
            return prefix
    if status.startswith(MERGED):
        return MERGED.strip()
    return status


def read_register(data):
    text = decode(data, REGISTER)
    reader = csv.reader(io.StringIO(text, newline=''), strict=True)
    try:
        rows = list(reader)
    except csv.Error:
        raise WordsError(REGISTER, 'bad-csv', reader.line_num)
    if not rows or tuple(rows[0]) != HEADER:
        raise WordsError(REGISTER, 'bad-header', 1)
    out = []
    seen = set()
    names = set()
    for n, r in enumerate(rows[1:], 2):
        if len(r) != len(HEADER):
            raise WordsError(REGISTER, 'bad-row', n)
        f = dict(zip(HEADER, r))
        if not HANDLE.match(f['handle']):
            raise WordsError(REGISTER, 'bad-handle', n)
        if f['handle'] in seen:
            raise WordsError(REGISTER, 'repeated-handle', n)
        name = ident(f['handle'])
        if name in names:
            raise WordsError(REGISTER, 'dart-name-clash', n)
        if has_control(f['status']):
            raise WordsError(REGISTER, 'control-character', n)
        seen.add(f['handle'])
        names.add(name)
        out.append((n, f['handle'], f['status'], f['english'], f['swedish']))
    return out


def parse_text(text, row):
    # " / " separates parts; a pilcrow separates paragraphs (D32 Q11, Q12).
    if has_control(text):
        raise WordsError(REGISTER, 'control-character', row)
    parts = []
    for part in text.strip().split(' / '):
        paragraphs = [p.strip() for p in part.split('¶')]
        if not all(paragraphs):
            raise WordsError(REGISTER, 'empty-part', row)
        parts.append('\n\n'.join(paragraphs))
    return parts


def slots_of(parts, row):
    found = set()
    for part in parts:
        rest = part
        for token, _, _ in SLOTS:
            if token in rest:
                found.add(token)
                rest = rest.replace(token, '')
        if '{' in rest or '}' in rest:
            raise WordsError(REGISTER, 'unknown-slot', row)
    return found


def places_of(rows):
    handles = set(r[1] for r in rows)
    out = []
    for row, handle, status, en, sv in rows:
        kind = classify(status)
        if kind is None:
            raise WordsError(REGISTER, 'unknown-status', row)
        if kind == 'merged':
            if status[len(MERGED):] not in handles:
                raise WordsError(REGISTER, 'merged-unknown', row)
            continue
        if kind == 'none':
            continue
        if kind == 'waiting':
            out.append(Place(row, handle, None, None, False, ()))
            continue
        if status == IN_PARTS and not en.strip() and not sv.strip():
            continue
        if not en.strip() or not sv.strip():
            raise WordsError(REGISTER, 'missing-language', row)
        en_parts, sv_parts = parse_text(en, row), parse_text(sv, row)
        if len(en_parts) != len(sv_parts):
            raise WordsError(REGISTER, 'parts-differ', row)
        en_slots, sv_slots = slots_of(en_parts, row), slots_of(sv_parts, row)
        if en_slots != sv_slots:
            raise WordsError(REGISTER, 'slots-differ', row)
        slots = tuple(s for s in SLOTS if s[0] in en_slots)
        out.append(Place(row, handle, en_parts, sv_parts, LINE[status], slots))
    return out


def item_like(line):
    # D38: a line that looks like a list item. A dash-led line is one
    # unless it is a rule of three dashes or more; "*" and "+" count only
    # as bullets, so bold and italic lines are prose.
    s = line.lstrip()
    if s[:1] == '-':
        return not (s.count('-') >= 3 and set(s) <= {'-', ' '})
    return s[:2] in ('* ', '+ ')


def read_lists(data):
    # D36 Q3: a level-1 title, then the five "## TECH·n — <title>"
    # sections in order. In each, the "**English**" and "**Swedish**"
    # marker lines, and the "- " items under each as that language's
    # list. Every other line is ignored, except that a non-blank line
    # that is not an item closes the list (D37); a line that looks like an
    # item but is not one stops (D38); anything unexpected stops.
    text = decode(data, LIST_FILE)
    found = {}
    order = []
    title = False
    section = None
    items = None
    for n, line in enumerate(text.split('\n'), 1):
        line = line.rstrip('\r')
        if line.startswith('## '):
            m = LIST_HEADING.match(line)
            if not m or m.group(1) in found:
                raise WordsError(LIST_FILE, 'lists-shape', n)
            section = found[m.group(1)] = {'en': None, 'sv': None}
            order.append(m.group(1))
            items = None
        elif line.startswith('# ') and not title and section is None:
            title = True
        elif line.startswith('#'):
            raise WordsError(LIST_FILE, 'lists-shape', n)
        elif line.startswith('**English**') or line.startswith('**Swedish**'):
            key = 'en' if line.startswith('**English**') else 'sv'
            if section is None or section[key] is not None:
                raise WordsError(LIST_FILE, 'lists-shape', n)
            section[key] = items = []
        elif line.startswith('- '):
            word = line[2:].strip()
            if items is None or not word or has_control(word):
                raise WordsError(LIST_FILE, 'lists-shape', n)
            items.append(word)
        elif item_like(line):
            raise WordsError(LIST_FILE, 'lists-shape', n)  # D38: never dropped
        elif line.strip():
            items = None  # D37: prose closes the list; a later item stops
    if tuple(order) != TECH:
        raise WordsError(LIST_FILE, 'lists-shape', 0)
    for name in TECH:
        if not found[name]['en'] or not found[name]['sv']:
            raise WordsError(LIST_FILE, 'lists-shape', 0)
    return [(name, found[name]['en'], found[name]['sv']) for name in TECH]


def dart_string(s):
    out = []
    for c in s:
        if c == '\\':
            out.append('\\\\')
        elif c == "'":
            out.append("\\'")
        elif c == '$':
            out.append('\\$')
        elif c == '\n':
            out.append('\\n')
        else:
            out.append(c)
    return "'" + ''.join(out) + "'"


def dart_list(parts):
    return 'null' if parts is None else '[' + ', '.join(dart_string(p) for p in parts) + ']'


LINES_HEAD = ''.join(line + '\n' for line in (
    '// GENERATED by tool/checks/wordsgen.py from the places register',
    '// (sha256 @SHA@). Do not edit: import the register again.',
    '// ignore_for_file: constant_identifier_names',
    '// ignore_for_file: non_constant_identifier_names, unused_element',
    '',
    '/// The two languages every line is written in.',
    'enum Lang { en, sv }',
    '',
    '/// One place in the register: its line in both languages,',
    '/// or none yet.',
    'final class Line {',
    '  const Line(this.handle, this._en, this._sv, {this.standIn = false});',
    '',
    "  /// The place's handle in the register.",
    '  final String handle;',
    '',
    '  /// True when this is the stand-in for a line',
    '  /// composed at run time.',
    '  final bool standIn;',
    '',
    '  final List<String>? _en;',
    '  final List<String>? _sv;',
    '',
    '  /// True when the register has a line for this place.',
    '  bool get written => _en != null;',
    '',
    '  /// The parts, split at " / " in the register.',
    '  /// A place with no line yet shows its handle',
    '  /// as a visible placeholder (R1).',
    '  List<String> parts(Lang lang) =>',
    "      (lang == Lang.en ? _en : _sv) ?? ['[$handle]'];",
    '',
    '  /// A line of one part.',
    '  String text(Lang lang) {',
    '    final all = parts(lang);',
    "    assert(all.length == 1, 'text() needs a line of one part');",
    '    return all.single;',
    '  }',
    '',
    '  Line _fill(Map<String, String> slots) =>',
    '      Line(handle, _fillAll(_en, slots), _fillAll(_sv, slots), standIn: standIn);',
    '',
    '  static List<String>? _fillAll(List<String>? parts, Map<String, String> slots) =>',
    '      parts?.map((p) => p.replaceAllMapped(_slot, (m) => slots[m[0]] ?? m[0]!)).toList();',
    '',
    "  static final _slot = RegExp(r'\\{[a-z ]+\\}');",
    '}',
    '',
    '/// Every place with a line, or waiting for one,',
    '/// by handle (D32 Q14).',
    'abstract final class Lines {',
))


def lines_dart(places, digest):
    out = [LINES_HEAD.replace('@SHA@', digest)]
    names = []
    for p in places:
        name = ident(p.handle)
        const = name if not p.slots else '_' + name
        names.append(const)
        stand_in = ', standIn: true' if p.stand_in else ''
        out.append('  static const %s = Line(%s, %s, %s%s);\n'
                   % (const, dart_string(p.handle), dart_list(p.en), dart_list(p.sv), stand_in))
        if p.slots:
            args = ', '.join('required %s %s' % (t, a) for _, a, t in p.slots)
            fills = ', '.join('%s: %s' % (dart_string(k), "'$%s'" % a if t == 'int' else a)
                              for k, a, t in p.slots)
            out.append('  static Line %s({%s}) => %s._fill({%s});\n' % (name, args, const, fills))
    out.append('\n  /// Every place above, in the register\'s order.\n')
    out.append('  static const all = <Line>[%s];\n}\n' % ', '.join(names))
    return ''.join(out)


def lists_dart(sections, digest):
    # Ten constants: tech1En, tech1Sv, ... tech5Sv (D36 Q3).
    out = ['// GENERATED by tool/checks/wordsgen.py from the founder\'s lists\n',
           '// (sha256 %s). Do not edit: import the lists again.\n\n' % digest,
           '/// The founder\'s list words, by section and language (R1).\n',
           'abstract final class ListWords {\n']
    for name, en, sv in sections:
        number = name[len('TECH·'):]
        for suffix, words in (('En', en), ('Sv', sv)):
            out.append('  static const tech%s%s = <String>[%s];\n'
                       % (number, suffix, ', '.join(dart_string(w) for w in words)))
    out.append('}\n')
    return ''.join(out)


def one_line(places, handle):
    # MP·55 and EM·3 go into Xcode's files: one part, one paragraph, no
    # slot, and nothing an xcconfig value cannot hold (D32 Q16, Q17).
    for p in places:
        if p.handle == handle:
            if p.en is None:
                break
            if len(p.en) != 1 or p.slots:
                raise WordsError(REGISTER, 'ios-line-parts', p.row)
            if '\n' in p.en[0] or '\n' in p.sv[0]:
                raise WordsError(REGISTER, 'ios-line-paragraphs', p.row)
            if '//' in p.en[0] or '$' in p.en[0]:
                raise WordsError(REGISTER, 'xcconfig-unsafe', p.row)
            return p.en[0], p.sv[0], p.row
    raise WordsError(REGISTER, 'ios-line-missing', 0)


def strings_file(text, digest):
    value = text.replace('\\', '\\\\').replace('"', '\\"')
    return ('/* GENERATED by tool/checks/wordsgen.py from the places register\n'
            '   (sha256 %s). Do not edit: import the register again. */\n'
            '"NSMicrophoneUsageDescription" = "%s";\n' % (digest, value))


def generate(csv_bytes, lists_bytes):
    # {repository path: bytes} for every path in guardlib.GENERATED.
    places = places_of(read_register(csv_bytes))
    sections = read_lists(lists_bytes)
    digest = sha256(csv_bytes)
    name_en, name_sv, row = one_line(places, APP_NAME)
    if name_en != name_sv:
        raise WordsError(REGISTER, 'name-languages-differ', row)
    mic_en, mic_sv, _ = one_line(places, MIC)
    xcconfig = ('// GENERATED by tool/checks/wordsgen.py from the places register\n'
                '// (sha256 %s). Do not edit: import the register again.\n'
                '// The home-screen name, MP·55, and the microphone text, EM·3\n'
                '// (the base value; InfoPlist.strings holds each language).\n'
                'WORDS_APP_NAME = %s\n'
                'WORDS_MIC_USAGE = %s\n' % (digest, name_en, mic_en))
    out = {
        LINES: lines_dart(places, digest),
        LIST_WORDS: lists_dart(sections, sha256(lists_bytes)),
        WORDS_XCCONFIG: xcconfig,
        STRINGS_EN: strings_file(mic_en, digest),
        STRINGS_SV: strings_file(mic_sv, digest),
    }
    assert tuple(sorted(out)) == tuple(sorted(GENERATED))
    return {path: text.encode('utf-8') for path, text in out.items()}


def summary(csv_bytes, lists_bytes):
    counts = {}
    for _, _, status, _, _ in read_register(csv_bytes):
        counts[label(status)] = counts.get(label(status), 0) + 1
    lines = ['wordsgen: rows %d' % sum(counts.values())]
    for name in sorted(counts):
        lines.append('wordsgen: status "%s" %d' % (name, counts[name]))
    words = sum(len(en) + len(sv) for _, en, sv in read_lists(lists_bytes))
    lines.append('wordsgen: list words %d' % words)
    return lines


def read(root, path):
    full = os.path.join(root, path)
    if not os.path.isfile(full) or os.path.islink(full):
        return None
    with open(full, 'rb') as f:
        return f.read()


def write_atomic(root, path, data):
    full = os.path.join(root, path)
    folder = os.path.dirname(full)
    os.makedirs(folder, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=folder, prefix='.wordsgen-')
    try:
        with os.fdopen(fd, 'wb') as f:
            f.write(data)
        os.replace(tmp, full)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def write_all(root, out):
    # Generates from root's inputs and writes into out. Raises WordsError.
    csv_bytes, lists_bytes = read(root, CSV), read(root, LISTS)
    outputs = generate(csv_bytes, lists_bytes)
    for path in GENERATED:
        if read(out, path) != outputs[path]:
            write_atomic(out, path, outputs[path])
            report('wordsgen: wrote ' + path)
    for line in summary(csv_bytes, lists_bytes):
        report(line)


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
        report('wordsgen: usage: --write | --check, with --root DIR, --out DIR')
        return 1
    out = out or root
    try:
        if mode == '--write':
            write_all(root, out)
            return 0
        outputs = generate(read(root, CSV), read(root, LISTS))
    except WordsError as e:
        report('wordsgen: refused %s %s row %d' % (e.source, e.code, e.row))
        return 1
    differ = [p for p in GENERATED if read(out, p) != outputs[p]]
    for path in differ:
        report('wordsgen: differs ' + path)
    report('wordsgen: %s' % ('different' if differ else 'up to date'))
    return 1 if differ else 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except Exception as e:  # never print a message: it could quote a file
        report('wordsgen: internal error ' + type(e).__name__)
        sys.exit(2)
