// The invented nights (R2): every test night comes from
// fixtures/invented-nights.json, read here. `flutter test` runs in app/.
import 'dart:convert';
import 'dart:io';

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
