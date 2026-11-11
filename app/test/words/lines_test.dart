// The generated words (D32): read by handle only, never quoted (R1).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/words/lines.g.dart';

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
}
