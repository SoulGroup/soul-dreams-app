// The settings' lines read by form (D122, the stop's question 13): the name
// and the choices, exactly the register's words, in both languages; any
// other form gives none.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/settings/setting_line.dart';
import 'package:souldreams/words/lines.g.dart';

void main() {
  test('each setting line gives its name and choices, both languages', () {
    for (final (line, count) in [
      (Lines.MP_26, 2),
      (Lines.MP_44, 2),
      (Lines.MP_83, 2),
      (Lines.MP_84, 4),
      (Lines.MP_85, 3),
    ]) {
      for (final lang in Lang.values) {
        final w = settingWords(line, lang)!;
        expect(w.choices, hasLength(count), reason: '${line.handle} $lang');
        // Nothing added, nothing lost: the words put back are the line.
        expect('${w.name} (${w.choices.join(' / ')})', line.parts(lang).join(' / '), reason: line.handle);
      }
    }
    final w = settingWords(Lines.MP_26, Lang.en)!;
    expect([w.name, ...w.choices], ['Word Animation', 'On', 'Off']);
  });

  test('a line in any other form gives none', () {
    for (final parts in [
      ['Word Animation'],
      ['A (B)'],
      ['Word Animation (On', 'Off'],
      ['Word Animation On', 'Off)'],
      [' (On', 'Off)'],
      ['A (B (C', 'D)'],
      ['A (B', 'C))'],
      ['A (B', ' C)'],
      ['A (', 'C)'],
    ]) {
      expect(settingWords(Line('X·1', parts, parts), Lang.en), isNull, reason: '$parts');
    }
    expect(settingWords(const Line('X·1', null, null), Lang.en), isNull);
    final w = settingWords(Line('X·1', ['A (B', 'C)'], ['A (B', 'C)']), Lang.en)!;
    expect([w.name, ...w.choices], ['A', 'B', 'C']);
  });
}
