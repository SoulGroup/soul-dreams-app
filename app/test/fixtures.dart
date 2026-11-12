// The invented nights (R2): every test night comes from
// fixtures/invented-nights.json, read here. `flutter test` runs in app/.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:souldreams/journal/night.dart';
import 'package:souldreams/words/lines.g.dart' show Lang;

/// One invented night, as the fixture file holds it.
final class InventedNight {
  const InventedNight(this.key, this.lang, this.name, this.dreams);

  final String key;
  final String lang;
  final String? name;
  final List<String> dreams;
}

/// Every invented night, in the file's order.
List<InventedNight> inventedNights() {
  final json = jsonDecode(File('../fixtures/invented-nights.json').readAsStringSync());
  return [
    for (final n in (json as Map<String, Object?>)['nights'] as List<Object?>)
      if (n case {'key': String key, 'lang': String lang, 'dreams': List<Object?> dreams})
        InventedNight(key, lang, (n as Map)['name'] as String?, dreams.cast<String>()),
  ];
}

/// The invented night named [key].
InventedNight invented(String key) => inventedNights().singleWhere((n) => n.key == key);

/// Each invented night as a Night, with ids from a seeded source and
/// first recordings an hour apart.
List<Night> nightsFromFixtures([int seed = 1]) {
  final random = Random(seed);
  var at = DateTime.utc(2026, 10, 12, 5, 40);
  return [
    for (final n in inventedNights())
      Night(
        id: newNightId(random),
        firstRecorded: at = at.add(const Duration(hours: 1)),
        date: (year: at.year, month: at.month, day: at.day),
        closes: at.add(const Duration(hours: 14)),
        lang: Lang.values.byName(n.lang),
        name: n.name,
        dreams: n.dreams,
      ),
  ];
}
