// A night and its file format: version 3 written, versions 1 and 2 still
// read (D49 b; D92, D93 Q2; D155 item 2; docs/workflow.md (c)).
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';

import '../fixtures.dart';

Map<String, Object?> fields(Night n) =>
    jsonDecode(utf8.decode(encodeNight(n))) as Map<String, Object?>;

Uint8List bytesOf(Map<String, Object?> json) => utf8.encode(jsonEncode(json));

/// The night as a version-1 file held it: the same fields, version 1, the
/// dreams as words only, no readings or usage.
Uint8List versionOne(Night n) => bytesOf({...fields(n), 'version': 1}..remove('readings')..remove('usage'));

/// The night as a version-2 file held it: version 2, no readings or usage.
Uint8List versionTwo(Night n) => bytesOf({...fields(n), 'version': 2}..remove('readings')..remove('usage'));

/// One model call's counts, made up for the tests.
ModelUsage call([int input = 1200]) => ModelUsage(
  step: 'readings',
  model: 'stand-in',
  input: input,
  output: 300,
  cacheRead: 1000,
  cacheWrite: 0,
  cost: 9100,
);

/// Readings made up for the tests: no tradition's words, placeholders.
final readings = [Reading(0, '[one]'), Reading(4, '[two]'), Reading(1, '[three]')];

/// Two waiting recordings' ids, made up for the tests.
final audioA = 'a' * 32;
final audioB = '0123456789abcdef' * 2;

void main() {
  test('every invented night survives encoding and decoding', () {
    for (final n in nightsFromFixtures()) {
      expect(decodeNight(encodeNight(n)), n);
    }
  });

  test('the file holds exactly the version-3 fields', () {
    final n = nightsFromFixtures().first;
    final json = fields(n);
    expect(json.keys.toSet(),
        {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams', 'readings', 'usage'});
    expect(json['version'], 3);
    expect(json['readings'], isNull);
    expect(json['usage'], isNull);
    expect(json['id'], n.id);
    expect(json['firstRecorded'], '2026-10-12T06:40:00.000Z');
    expect(json['date'], '2026-10-12');
    expect(json['closes'], '2026-10-12T20:40:00.000Z');
    expect(json['lang'], 'en');
    expect(json['dreams'], n.dreams);
  });

  // docs/workflow.md (c): the old format loads, and the new one loses
  // nothing; every night, dream and field counted before and after.
  test('every version-1 night reads whole and saves as version 3', () {
    final nights = nightsFromFixtures();
    var dreams = 0;
    for (final n in nights) {
      final old = jsonDecode(utf8.decode(versionOne(n))) as Map<String, Object?>;
      final read = decodeNight(versionOne(n));
      expect(read, n);
      expect(read!.readings, isNull);
      final saved = fields(read);
      expect(saved['version'], 3);
      expect(saved.keys.toSet(), {...old.keys, 'readings', 'usage'});
      expect(saved['readings'], isNull);
      expect(saved['usage'], isNull);
      for (final key in old.keys.where((k) => k != 'version')) {
        expect(saved[key], old[key], reason: '${n.id} $key');
      }
      expect(read.entries, [for (final d in old['dreams'] as List<Object?>) Told(d as String)]);
      dreams += read.dreams.length;
    }
    expect(nights.length, inventedNights().length);
    expect(dreams, inventedNights().fold<int>(0, (sum, n) => sum + n.dreams.length));
  });

  // docs/workflow.md (c), D155 item 2: every version-2 night, waiting
  // recordings among its dreams, reads whole and unread, and saves as
  // version 3 losing nothing; every night, dream and field counted.
  test('every version-2 night reads whole, unread, and saves as version 3', () {
    final nights = [
      for (final (i, n) in nightsFromFixtures().indexed)
        i.isEven ? n : n.withEntries([...n.entries, Waiting(audioA, 2 * i)]),
    ];
    var told = 0;
    var waiting = 0;
    for (final n in nights) {
      final old = jsonDecode(utf8.decode(versionTwo(n))) as Map<String, Object?>;
      expect(old['version'], 2);
      final read = decodeNight(versionTwo(n));
      expect(read, n);
      expect(read!.readings, isNull);
      final saved = fields(read);
      expect(saved['version'], 3);
      expect(saved.keys.toSet(), {...old.keys, 'readings', 'usage'});
      for (final key in old.keys.where((k) => k != 'version')) {
        expect(saved[key], old[key], reason: '${n.id} $key');
      }
      told += read.dreams.length;
      waiting += read.entries.whereType<Waiting>().length;
    }
    expect(nights.length, inventedNights().length);
    expect(told, inventedNights().fold<int>(0, (sum, n) => sum + n.dreams.length));
    expect(waiting, nights.length ~/ 2);
  });

  test('a read night keeps its readings, in order, through its file', () {
    final n = nightsFromFixtures().first.withReadings(readings);
    expect(fields(n)['readings'], [
      {'lens': 0, 'text': '[one]'},
      {'lens': 4, 'text': '[two]'},
      {'lens': 1, 'text': '[three]'},
    ]);
    final read = decodeNight(encodeNight(n))!;
    expect(read, n);
    expect(read.readings, readings);
    expect(read.dreams, n.dreams);
    expect(read == n.withReadings(readings.reversed.toList()), isFalse);
    expect(read == nightsFromFixtures().first, isFalse);
  });

  test("a read night keeps its calls' counts beside its readings", () {
    final n = nightsFromFixtures().first.withReadings(readings, usage: [call(), call(5)]);
    expect(fields(n)['usage'], [
      {'step': 'readings', 'model': 'stand-in', 'input': 1200, 'output': 300, 'cacheRead': 1000, 'cacheWrite': 0, 'cost': 9100},
      {'step': 'readings', 'model': 'stand-in', 'input': 5, 'output': 300, 'cacheRead': 1000, 'cacheWrite': 0, 'cost': 9100},
    ]);
    final read = decodeNight(encodeNight(n))!;
    expect(read.usage, [call(), call(5)]);
    expect(read, n);
    expect(read == n.withReadings(readings, usage: [call(5), call()]), isFalse);
    expect(read == n.withReadings(readings), isFalse);
    expect(n.withDreams(['y']).usage, [call(), call(5)]);
    expect(nightsFromFixtures().first.withReadings(readings, usage: []).usage, isEmpty);
  });

  test('usage misshapen, or on an unread night, decodes to null', () {
    final good = fields(nightsFromFixtures().first.withReadings(readings));
    final whole = call().toJson();
    for (final (i, u) in <Object?>[
      {...whole},
      ['x'],
      [{...whole, 'input': -1}],
      [{...whole, 'cost': 1.5}],
      [{...whole, 'step': ''}],
      [{...whole, 'model': 7}],
      [{...whole, 'extra': 1}],
      [{...whole}..remove('cacheWrite')],
    ].indexed) {
      expect(decodeNight(bytesOf({...good, 'usage': u})), isNull, reason: 'case $i');
    }
    expect(decodeNight(bytesOf({...good, 'usage': [whole]}))!.usage, [call()]);
    final unread = fields(nightsFromFixtures().first);
    expect(decodeNight(bytesOf({...unread, 'usage': [whole]})), isNull);
  });

  test('usage without readings, or a bad count, is refused', () {
    final n = nightsFromFixtures().first;
    expect(
      () => Night(id: n.id, firstRecorded: n.firstRecorded, date: n.date, closes: n.closes, lang: n.lang, usage: [call()]),
      throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'usage')),
    );
    expect(() => call(-1), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'count')));
    expect(() => ModelUsage(step: '', model: 'm', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'step')));
    expect(() => ModelUsage(step: 's', model: '', input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0),
        throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'model')));
  });

  test('a read night stays read when its dreams change', () {
    final n = nightsFromFixtures().first.withReadings(readings);
    expect(n.withEntries([Told('x'), Waiting(audioA)]).readings, readings);
    expect(n.withDreams(['y']).readings, readings);
  });

  test('readings in a version-1 or version-2 file are refused', () {
    final read = fields(nightsFromFixtures().first.withReadings(readings));
    expect(decodeNight(bytesOf({...read, 'version': 1})), isNull);
    expect(decodeNight(bytesOf({...read, 'version': 2})), isNull);
    expect(decodeNight(bytesOf({...read, 'version': 2, 'readings': null})), isNull);
    expect(decodeNight(bytesOf({...read, 'version': 3})), isNotNull);
  });

  test('misshapen readings decode to null', () {
    final good = fields(nightsFromFixtures().first);
    for (final (i, r) in <Object?>[
      <Object?>[],
      [for (var k = 0; k < 4; k++) {'lens': k, 'text': '[x]'}],
      [{'lens': -1, 'text': '[x]'}],
      [{'lens': 1.0, 'text': '[x]'}],
      [{'lens': '1', 'text': '[x]'}],
      [{'lens': 1, 'text': ''}],
      [{'lens': 1, 'text': 7}],
      [{'lens': 1}],
      [{'lens': 1, 'text': '[x]', 'extra': 1}],
      ['[x]'],
      {'lens': 1, 'text': '[x]'},
      '[x]',
    ].indexed) {
      expect(decodeNight(bytesOf({...good, 'readings': r})), isNull, reason: 'case $i');
    }
    expect(decodeNight(bytesOf({...good, 'readings': [{'lens': 1, 'text': '[x]'}]}))!.readings, [Reading(1, '[x]')]);
  });

  test('a bad lens, no words, or not one to three: refused', () {
    expect(() => Reading(-1, '[x]'), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'lens')));
    expect(() => Reading(0, ''), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'text')));
    final n = nightsFromFixtures().first;
    expect(() => n.withReadings([]), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'readings')));
    expect(() => n.withReadings([...readings, Reading(2, '[four]')]), throwsArgumentError);
    expect(n.withReadings(readings.take(1).toList()).readings, hasLength(1));
  });

  test("a night's readings cannot be changed in place", () {
    final n = nightsFromFixtures().first.withReadings(readings);
    expect(() => n.readings!.add(Reading(2, '[four]')), throwsUnsupportedError);
  });

  test('a waiting recording keeps its place among the told dreams', () {
    final n = nightsFromFixtures().first;
    final night = n.withEntries([Told(n.dreams.first), Waiting(audioA, 64000), Told('x'), Waiting(audioB)]);
    expect(fields(night)['dreams'], [
      n.dreams.first,
      {'waiting': audioA, 'from': 64000},
      'x',
      {'waiting': audioB, 'from': 0},
    ]);
    expect(decodeNight(encodeNight(night)), night);
    expect(night.dreams, [n.dreams.first, 'x']);
    expect(decodeNight(encodeNight(n.withEntries([Waiting(audioA)])))!.dreams, isEmpty);
  });

  test('a waiting recording is refused in a version-1 file', () {
    final n = nightsFromFixtures().first.withEntries([Waiting(audioA)]);
    expect(decodeNight(versionTwo(n)), n);
    expect(decodeNight(versionOne(n)), isNull);
  });

  test('a misshapen waiting recording, or one twice, decodes to null', () {
    final good = fields(nightsFromFixtures().first);
    for (final (i, dreams) in [
      [{'waiting': audioA}],
      [{'waiting': audioA, 'from': 0, 'extra': 1}],
      [{'waiting': 'A' * 32, 'from': 0}],
      [{'waiting': audioA, 'from': -2}],
      [{'waiting': audioA, 'from': 3}],
      [{'waiting': audioA, 'from': 2.0}],
      [{'waiting': audioA, 'from': '0'}],
      [{'waiting': audioA, 'from': 0}, {'waiting': audioA, 'from': 2}],
      [<Object?>[]],
    ].indexed) {
      expect(decodeNight(bytesOf({...good, 'dreams': dreams})), isNull, reason: 'case $i');
    }
  });

  test('a waiting recording with a bad id or from is refused', () {
    expect(() => Waiting('x'), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'audio')));
    expect(() => Waiting(audioA, -2), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'from')));
    expect(() => Waiting(audioA, 1), throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'from')));
    final n = nightsFromFixtures().first;
    expect(() => n.withEntries([Waiting(audioA), Waiting(audioA, 2)]), throwsArgumentError);
    expect(
      () => Night(
        id: n.id,
        firstRecorded: n.firstRecorded,
        date: n.date,
        closes: n.closes,
        lang: n.lang,
        dreams: n.dreams,
        entries: [Waiting(audioA)],
      ),
      throwsA(isA<ArgumentError>().having((e) => e.message, 'message', 'dreams')),
    );
  });

  test('not a night of version 1, 2 or 3: null', () {
    final good = fields(nightsFromFixtures().first);
    Map<String, Object?> without(String key) => {...good}..remove(key);
    Map<String, Object?> with_(String key, Object? value) => {...good, key: value};
    final bad = <Uint8List>[
      Uint8List.fromList([0xff, 0xfe]),
      utf8.encode('not json'),
      utf8.encode('[]'),
      bytesOf(without('dreams')),
      bytesOf(with_('extra', 1)),
      bytesOf(with_('version', 0)),
      bytesOf(with_('version', 4)),
      bytesOf(without('readings')),
      bytesOf(without('usage')),
      bytesOf(with_('version', '2')),
      // The version check itself: the version-2 keys, so only an unknown
      // version can refuse them (the cases above fail the key set first).
      bytesOf({...without('readings')..remove('usage'), 'version': 0}),
      bytesOf({...without('readings')..remove('usage'), 'version': 4}),
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
    expect(() => n.entries.add(const Told('x')), throwsUnsupportedError);
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
