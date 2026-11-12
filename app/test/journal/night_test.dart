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
        {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'});
    expect(json['version'], 1);
    expect(json['id'], n.id);
    expect(json['firstRecorded'], '2026-10-12T06:40:00.000Z');
    expect(json['date'], '2026-10-12');
    expect(json['closes'], '2026-10-12T20:40:00.000Z');
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
      bytesOf(without('closes')),
      bytesOf(with_('closes', '2026-10-12T20:40:00.000')),
      bytesOf(with_('closes', good['firstRecorded'])),
      bytesOf(with_('closes', '2026-10-12T06:39:00.000Z')),
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
        () => Night(
            id: 'x', firstRecorded: n.firstRecorded, date: n.date, closes: n.closes, lang: n.lang, dreams: n.dreams),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'id')));
    expect(
        () => Night(
            id: n.id, firstRecorded: DateTime(2026), date: n.date, closes: n.closes, lang: n.lang, dreams: n.dreams),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'firstRecorded')));
  });

  test('a local or too early closing instant is refused', () {
    final n = nightsFromFixtures().first;
    for (final closes in [n.firstRecorded, n.firstRecorded.subtract(const Duration(minutes: 1)), DateTime(2027)]) {
      expect(
          () => Night(
              id: n.id, firstRecorded: n.firstRecorded, date: n.date, closes: closes, lang: n.lang, dreams: n.dreams),
          throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'closes')),
          reason: '$closes');
    }
    expect(n.withDreams(const ['x']).closes, n.closes);
  });

  test('a date its file could not hold is refused', () {
    final n = nightsFromFixtures().first;
    Night on(NightDate date) =>
        Night(id: n.id, firstRecorded: n.firstRecorded, date: date, closes: n.closes, lang: n.lang, dreams: n.dreams);
    for (final date in [
      (year: 2026, month: 2, day: 30),
      (year: 2026, month: 13, day: 1),
      (year: 2026, month: 0, day: 1),
      (year: 2026, month: 1, day: 0),
      (year: 10000, month: 1, day: 1),
      (year: -1, month: 1, day: 1),
    ]) {
      expect(() => on(date), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'date')),
          reason: '$date');
    }
    final leap = on((year: 2028, month: 2, day: 29));
    expect(decodeNight(encodeNight(leap)), leap);
  });

  test("a night's dreams cannot be changed in place", () {
    final n = nightsFromFixtures().first;
    expect(() => n.dreams.add('x'), throwsUnsupportedError);
  });

  test('a closing instant over 26 hours on is refused as damaged', () {
    final n = nightsFromFixtures().first;
    Night closing(DateTime closes) =>
        Night(id: n.id, firstRecorded: n.firstRecorded, date: n.date, closes: closes, lang: n.lang, dreams: n.dreams);
    final limit = n.firstRecorded.add(const Duration(hours: 26));
    expect(decodeNight(encodeNight(closing(limit))), closing(limit));
    final late = limit.add(const Duration(minutes: 1));
    expect(() => closing(late), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'closes')));
    expect(decodeNight(bytesOf({...fields(n), 'closes': late.toIso8601String()})), isNull);
  });

  test('a night at the far end of time reads without throwing', () {
    final n = nightsFromFixtures().first;
    final json = {
      ...fields(n),
      'firstRecorded': '+275760-09-12T23:00:00.000Z',
      'closes': '+275760-09-13T00:00:00.000Z',
    };
    // A whole night, however far off: read as one, and never thrown at.
    expect(() => decodeNight(bytesOf(json)), returnsNormally);
    final end = DateTime.utc(275760, 9, 12, 23);
    expect(
        () => Night(
            id: n.id,
            firstRecorded: end,
            date: n.date,
            closes: DateTime.utc(275760, 9, 13),
            lang: n.lang,
            dreams: n.dreams),
        returnsNormally);
  });
}
