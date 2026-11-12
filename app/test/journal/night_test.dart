// A night and its file format, version 1 (D49 b).
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';

import '../fixtures.dart';

Map<String, Object?> fields(Night n) =>
    jsonDecode(utf8.decode(encodeNight(n))) as Map<String, Object?>;

Uint8List bytesOf(Map<String, Object?> json) => utf8.encode(jsonEncode(json));

void main() {
  test('every invented night survives encoding and decoding', () {
    for (final n in nightsFromFixtures()) {
      expect(decodeNight(encodeNight(n)), n);
    }
  });

  test('the file holds exactly the version-1 fields', () {
    final n = nightsFromFixtures().first;
    final json = fields(n);
    expect(json.keys.toSet(),
        {'version', 'id', 'firstRecorded', 'date', 'lang', 'name', 'dreams'});
    expect(json['version'], 1);
    expect(json['id'], n.id);
    expect(json['firstRecorded'], '2026-10-12T06:40:00.000Z');
    expect(json['date'], '2026-10-12');
    expect(json['lang'], 'en');
    expect(json['dreams'], n.dreams);
  });

  test('anything not a version-1 night decodes to null', () {
    final good = fields(nightsFromFixtures().first);
    Map<String, Object?> without(String key) => {...good}..remove(key);
    Map<String, Object?> with_(String key, Object? value) => {...good, key: value};
    final bad = <Uint8List>[
      Uint8List.fromList([0xff, 0xfe]),
      utf8.encode('not json'),
      utf8.encode('[]'),
      bytesOf(without('dreams')),
      bytesOf(with_('extra', 1)),
      bytesOf(with_('version', 2)),
      bytesOf(with_('id', 'ABC')),
      bytesOf(with_('firstRecorded', '2026-10-12T06:40:00.000')),
      bytesOf(with_('firstRecorded', 'tomorrow')),
      bytesOf(with_('date', '2026-02-30')),
      bytesOf(with_('date', '12/10/2026')),
      bytesOf(with_('lang', 'de')),
      bytesOf(with_('name', 7)),
      bytesOf(with_('dreams', [1])),
      bytesOf(with_('dreams', 'one')),
    ];
    for (final (i, b) in bad.indexed) {
      expect(decodeNight(b), isNull, reason: 'case $i');
    }
  });

  test('a new id is 32 hex digits, and two differ', () {
    final a = newNightId();
    final b = newNightId();
    expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(a, isNot(b));
    expect(newNightId(Random(7)), newNightId(Random(7)));
  });

  test('a bad id or a local time is refused', () {
    final n = nightsFromFixtures().first;
    expect(
        () => Night(id: 'x', firstRecorded: n.firstRecorded, date: n.date, lang: n.lang, dreams: n.dreams),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'id')));
    expect(
        () => Night(id: n.id, firstRecorded: DateTime(2026), date: n.date, lang: n.lang, dreams: n.dreams),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'firstRecorded')));
  });

  test("a night's dreams cannot be changed in place", () {
    final n = nightsFromFixtures().first;
    expect(() => n.dreams.add('x'), throwsUnsupportedError);
  });
}
