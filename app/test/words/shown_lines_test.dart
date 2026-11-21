// No shown line may carry an unfilled braced sentence (docs/Status.md,
// "Before Cohort 1"; D119 item 2). A place "to rewrite" is built as written,
// and a sentence still owed in it stays whole in braces (MP·68, MP·70).
// That is fine while no screen shows the place: this test fails the moment
// any file in lib/ (outside lib/words/) names a place whose line holds a
// brace that is not one of the generator's four slots. `flutter test` runs
// in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/words/lines.g.dart';

/// The generator's slots (tool/checks/wordsgen.py, SLOTS): the only braces a
/// shown line may hold, and only because the screen fills them.
const slots = ['{n}', '{pointed image}', '{tradition}', '{read image}'];

/// True when [part] holds a brace that is not one of the [slots].
bool braced(String part) {
  var rest = part;
  for (final slot in slots) {
    rest = rest.replaceAll(slot, '');
  }
  return rest.contains('{') || rest.contains('}');
}

/// The names of the places the screens' code names: every `Lines.<name>` in
/// lib/ outside lib/words/, comments left out.
Set<String> named() {
  final out = <String>{};
  final ref = RegExp(r'\bLines\.([A-Za-z_][A-Za-z0-9_]*)');
  for (final f in Directory('lib').listSync(recursive: true).whereType<File>()) {
    final path = f.path.replaceAll('\\', '/');
    if (!path.endsWith('.dart') || path.contains('lib/words/')) continue;
    for (final line in f.readAsLinesSync()) {
      for (final m in ref.allMatches(line.replaceFirst(RegExp(r'//.*$'), ''))) {
        out.add(m[1]!);
      }
    }
  }
  return out;
}

/// A place's name in Dart: its handle with "·" and "-" as "_".
String dartName(Line l) => l.handle.replaceAll('·', '_').replaceAll('-', '_');

void main() {
  test('a brace outside the slots is caught, a slot is not', () {
    expect(braced('A line. {What it keeps.} More.'), isTrue);
    expect(braced('{What it keeps, and for how long.}'), isTrue);
    expect(braced('Dream {n}'), isFalse);
    expect(braced('No tradition reads {pointed image}, they read {read image}.'), isFalse);
    expect(braced('The Series Question: {tradition} asks'), isFalse);
    expect(braced('A stray } brace'), isTrue);
    expect(braced('{what it keeps}'), isTrue);
  });

  test('the scan sees the places the screens use', () {
    final seen = named();
    // One plain place and one with a slot, so a scan that finds nothing, or
    // misses the places with a slot, fails here and not silently.
    expect(seen, containsAll(['MP_11', 'MP_76']));
    expect(seen, isNot(contains('all')), reason: 'a screen reaching Lines.all would hide what it shows');
  });

  test('every place the screens name is in the register', () {
    final known = {for (final l in Lines.all) dartName(l)};
    expect(named().where((n) => !known.contains(n)), isEmpty);
  });

  test('no shown place has a braced sentence, in either language', () {
    final shown = named();
    for (final l in Lines.all.where((l) => shown.contains(dartName(l)))) {
      for (final lang in Lang.values) {
        for (final part in l.parts(lang)) {
          expect(braced(part), isFalse, reason: '${l.handle} $lang');
        }
      }
    }
  });
}
