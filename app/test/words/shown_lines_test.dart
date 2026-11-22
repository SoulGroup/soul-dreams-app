// No tester or founder build may show an unfilled braced sentence
// (docs/Status.md, "Before Cohort 1" item 4; D119 item 2; D122, Q1 (B)). A
// place "to rewrite" is built as written, and a sentence still owed in it
// stays whole in braces (MP·68, MP·70). SoulDreams Dev shows them as filed
// (D122): this test fails the moment any file that main.dart or
// main_founder.dart reaches (following imports, as dev_only_test.dart does)
// names a place whose line holds a brace that is not one of the generator's
// four slots. `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/words/lines.g.dart';

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
  /// outside the slots.
  List<String> bracedIn(Set<String> names) => [
    for (final l in Lines.all.where((l) => names.contains(dartName(l))))
      if (Lang.values.any((lang) => l.parts(lang).any(braced))) l.handle,
  ];

  test('the scan sees the places the screens use', () {
    final seen = named(reached('lib/main_dev.dart'));
    // One plain place and one with a slot, so a scan that finds nothing, or
    // misses the places with a slot, fails here and not silently; and the
    // two consents Dev shows with their braces (D122).
    expect(seen, containsAll(['MP_11', 'MP_76', 'MP_68', 'MP_70']));
    expect(seen, isNot(contains('all')), reason: 'a screen reaching Lines.all would hide what it shows');
    expect(bracedIn(seen), containsAll(['MP·68', 'MP·70']));
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
