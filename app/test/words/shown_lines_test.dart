// No tester or founder build may show an unfilled braced sentence
// (docs/Status.md, "Before Cohort 1" item 4; D119 item 2; D122, Q1 (B)). A
// place "to rewrite" is built as written, and a sentence still owed in it
// stays whole in braces (none since C19-P). SoulDreams Dev shows them as filed
// (D122): this test fails the moment any file that main.dart or
// main_founder.dart reaches (following imports, as dev_only_test.dart does)
// names a place whose line holds a brace that is not one of the generator's
// four slots. `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

import '../dev_only_test.dart' show reached;

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

/// The names of the places [files] name: every `Lines.<name>` in them
/// outside lib/words/, comments left out.
Set<String> named(Iterable<String> files) {
  final out = <String>{};
  final ref = RegExp(r'\bLines\.([A-Za-z_][A-Za-z0-9_]*)');
  for (final path in files) {
    if (!path.endsWith('.dart') || path.contains('lib/words/')) continue;
    for (final line in File(path).readAsLinesSync()) {
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

  /// The places [names] holds whose line, in either language, has a brace
  /// outside the slots, looked for in [lines], every filed line unless given.
  List<String> bracedIn(Set<String> names, [Iterable<Line> lines = Lines.all]) => [
    for (final l in lines.where((l) => names.contains(dartName(l))))
      if (Lang.values.any((lang) => l.parts(lang).any(braced))) l.handle,
  ];

  // D128 item 4: the word "consent" is on no screen. No filed line shown
  // holds it since C19-P retired EM·6; its words stand as the pending MP·109
  // (D161 item 2), whose Swedish "Jag samtycker inte" holds it, for Product
  // to reword. MP·67, MP·95 and MP·96 hold it too and are shown nowhere now,
  // nor is C19-P's MP·98, the voice paused (D161 item 3).
  test('no shown line says consent, but the one named for Product', () {
    final word = RegExp('consent|samtycke', caseSensitive: false);
    final seen = named(reached('lib/main_dev.dart'));
    final shown = [
      for (final l in Lines.all)
        if (seen.contains(dartName(l)) && Lang.values.any((lang) => l.parts(lang).any(word.hasMatch))) l.handle,
    ];
    expect(shown, isEmpty);
    expect(word.hasMatch(PendingLines.MP_109.text(Lang.sv, flavor: 'dev')), isTrue);
    expect(word.hasMatch(PendingLines.MP_109.text(Lang.en, flavor: 'dev')), isFalse);
    for (final unshown in ['MP_67', 'MP_95', 'MP_96', 'MP_98']) {
      expect(seen, isNot(contains(unshown)));
    }
  });

  test('the scan sees the places the screens use', () {
    final seen = named(reached('lib/main_dev.dart'));
    // One plain place and one with a slot, so a scan that finds nothing, or
    // misses the places with a slot, fails here and not silently; and the
    // Life Context's page (MP·69); the readings and night images consents
    // are shown nowhere now (D125 item 8; D128 item 2).
    expect(seen, containsAll(['MP_11', 'MP_76', 'MP_69']));
    expect(seen, isNot(contains('MP_68')));
    expect(seen, isNot(contains('MP_70')));
    expect(seen, isNot(contains('all')), reason: 'a screen reaching Lines.all would hide what it shows');
    expect(bracedIn(seen), isEmpty);
    // No braced sentence is shown on any screen, and none is filed since
    // C19-P; the helper itself is proved on two made-up lines, by name.
    const owed = Line('X·1', ['a {b}'], ['c']);
    const slot = Line('X·2', ['a {n}'], ['c {n}']);
    expect(bracedIn({'X_1', 'X_2'}, [owed, slot]), ['X·1']);
    expect(bracedIn({'X_2'}, [owed, slot]), isEmpty);
    expect(bracedIn({'MP_11', 'MP_76'}), isEmpty);
  });

  test('every place the screens name is in the register', () {
    final known = {for (final l in Lines.all) dartName(l)};
    expect(named(reached('lib/main_dev.dart')).where((n) => !known.contains(n)), isEmpty);
  });

  test('no tester or founder build shows a braced sentence', () {
    for (final entry in ['lib/main.dart', 'lib/main_founder.dart']) {
      expect(bracedIn(named(reached(entry))), isEmpty, reason: entry);
    }
  });
}
