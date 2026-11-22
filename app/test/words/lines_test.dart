// The generated words (D32): read by handle only, never quoted (R1).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

void main() {
  test('the home-screen name is one line, the same in both languages', () {
    expect(Lines.MP_55.written, isTrue);
    expect(Lines.MP_55.parts(Lang.en), hasLength(1));
    expect(Lines.MP_55.text(Lang.sv), Lines.MP_55.text(Lang.en));
  });

  test('the microphone text is written in both languages', () {
    expect(Lines.EM_3.written, isTrue);
    expect(Lines.EM_3.text(Lang.en), isNotEmpty);
    expect(Lines.EM_3.text(Lang.sv), isNotEmpty);
  });

  test('a place with no line yet shows its handle', () {
    for (final line in Lines.all.where((l) => !l.written)) {
      expect(line.parts(Lang.en), ['[${line.handle}]']);
      expect(line.parts(Lang.sv), ['[${line.handle}]']);
    }
  });

  test('every written line has its parts in both languages', () {
    for (final line in Lines.all.where((l) => l.written)) {
      expect(line.parts(Lang.sv), hasLength(line.parts(Lang.en).length));
      expect(line.parts(Lang.en).every((p) => p.isNotEmpty), isTrue);
      expect(line.parts(Lang.sv).every((p) => p.isNotEmpty), isTrue);
    }
  });

  test('handles are unique', () {
    final handles = Lines.all.map((l) => l.handle).toList();
    expect(handles.toSet(), hasLength(handles.length));
  });

  // D57 Q11: a pending line's words show in SoulDreams Dev only. Pinned on
  // a line built here, so the rule stays proved while none is pending.
  test('a pending line: its handle outside Dev, words in Dev', () {
    const line = PendingLine('X·1', ['en'], ['sv']);
    expect(line.text(Lang.en, flavor: null), '[X·1]');
    expect(line.text(Lang.en, flavor: 'tester'), '[X·1]');
    expect(line.text(Lang.en, flavor: 'founder'), '[X·1]');
    expect(line.text(Lang.en, flavor: 'dev'), 'en');
    expect(line.text(Lang.sv, flavor: 'dev'), 'sv');
  });

  test('no line is pending and filed at once', () {
    final filed = Lines.all.map((l) => l.handle).toSet();
    expect(PendingLines.all.where((p) => filed.contains(p.handle)), isEmpty);
  });

  // D128 item 5: the popup names the Settings row and the agree button as
  // filed, in both languages: MP·48's own words, and MP·100's.
  test('MP·101 names MP·48 and MP·100 exactly', () {
    for (final lang in Lang.values) {
      final popup = PendingLines.MP_101.text(lang, flavor: 'dev');
      expect(popup, contains(Lines.MP_48.text(lang)), reason: lang.name);
      expect(popup, contains(PendingLines.MP_100.text(lang, flavor: 'dev')), reason: lang.name);
    }
  });
}
