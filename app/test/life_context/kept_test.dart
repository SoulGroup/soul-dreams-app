// What Life Context keeps, and its file (C159-I item 1; D131): each kept
// sentence word for word with its day and its night, version 1 exactly;
// the Recent window by the calendar (MP·84); newest first.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/life_context/kept.dart';
import 'package:souldreams/settings/settings.dart';

import '../fixtures.dart';

NightDate day(int y, int m, int d) => (year: y, month: m, day: d);

/// The invented sentences, kept one a day back from 22 November 2026.
List<Kept> keptFromFixtures([int seed = 2]) {
  final random = Random(seed);
  final night = newNightId(random);
  final sentences = [
    for (final n in inventedNights())
      for (final w in n.waking) ...w.sentences,
  ];
  return [
    for (final (i, s) in sentences.indexed)
      Kept(id: newKeptId(random), night: night, day: day(2026, 11, 22 - i), text: s),
  ];
}

Uint8List bytesOf(Object json) => utf8.encode(jsonEncode(json));

void main() {
  test('kept sentences read back from their file, word for word', () {
    final kept = keptFromFixtures();
    expect(kept, isNotEmpty);
    expect(decodeKept(encodeKept(kept)), kept);
    expect(decodeKept(encodeKept(const [])), isEmpty);
    final json = jsonDecode(utf8.decode(encodeKept(kept))) as Map<String, dynamic>;
    expect(json['version'], 1);
    expect((json['sentences'] as List).first, {
      'id': kept.first.id,
      'night': kept.first.night,
      'day': '2026-11-22',
      'text': kept.first.text,
    });
  });

  test('anything not version 1 exactly reads as nothing', () {
    final k = keptFromFixtures().first;
    Map<String, Object?> one([Map<String, Object?> change = const {}]) => {
      'id': k.id,
      'night': k.night,
      'day': '2026-11-22',
      'text': k.text,
      ...change,
    };
    Object file(List<Object?> s, [int version = 1]) => {'version': version, 'sentences': s};
    expect(decodeKept(bytesOf(file([one()]))), [k]);
    for (final bad in [
      file([one()], 2),
      {
        'version': 1,
        'sentences': [one()],
        'more': 1,
      },
      {'version': 1},
      file([
        one({'id': 'x'}),
      ]),
      file([
        one({'night': 'x'}),
      ]),
      file([
        one({'day': '2026-02-30'}),
      ]),
      file([
        one({'day': '22/11/2026'}),
      ]),
      file([
        one({'text': '  '}),
      ]),
      file([
        one({'text': 3}),
      ]),
      file([
        one({'more': 1}),
      ]),
      file([one(), one()]),
      file(['x']),
      [one()],
    ]) {
      expect(decodeKept(bytesOf(bad)), isNull, reason: '$bad');
    }
    expect(decodeKept(Uint8List.fromList([0xff, 0xfe])), isNull);
    expect(decodeKept(utf8.encode('{')), isNull);
  });

  test('a kept sentence refuses what its file could not hold', () {
    final k = keptFromFixtures().first;
    expect(() => Kept(id: 'x', night: k.night, day: k.day, text: k.text), throwsArgumentError);
    expect(() => Kept(id: k.id, night: 'x', day: k.day, text: k.text), throwsArgumentError);
    expect(() => Kept(id: k.id, night: k.night, day: day(2026, 2, 30), text: k.text), throwsArgumentError);
    expect(() => Kept(id: k.id, night: k.night, day: k.day, text: ' \n'), throwsArgumentError);
  });

  test('an edit changes only the words', () {
    final [a, b, ...] = keptFromFixtures();
    final edited = a.withText(b.text);
    expect((edited.id, edited.night, edited.day, edited.text), (a.id, a.night, a.day, b.text));
  });

  test('the window: a week, two weeks, a month, three months', () {
    final today = day(2026, 11, 22);
    expect(cutoffOf(today, LifeContextLength.oneWeek), day(2026, 11, 15));
    expect(cutoffOf(today, LifeContextLength.twoWeeks), day(2026, 11, 8));
    expect(cutoffOf(today, LifeContextLength.oneMonth), day(2026, 10, 22));
    expect(cutoffOf(today, LifeContextLength.threeMonths), day(2026, 8, 22));
    expect(cutoffOf(day(2026, 3, 31), LifeContextLength.oneMonth), day(2026, 2, 28));
    expect(cutoffOf(day(2028, 5, 31), LifeContextLength.threeMonths), day(2028, 2, 29));
    expect(cutoffOf(day(2026, 1, 15), LifeContextLength.threeMonths), day(2025, 10, 15));
    expect(cutoffOf(day(2026, 1, 3), LifeContextLength.oneWeek), day(2025, 12, 27));
  });

  test('in the window after the cutoff, out on it', () {
    final k = keptFromFixtures().first;
    Kept on(NightDate d) => Kept(id: k.id, night: k.night, day: d, text: k.text);
    final today = day(2026, 11, 22);
    expect(inWindow(on(day(2026, 11, 16)), today, LifeContextLength.oneWeek), isTrue);
    expect(inWindow(on(day(2026, 11, 15)), today, LifeContextLength.oneWeek), isFalse);
    expect(inWindow(on(day(2026, 10, 23)), today, LifeContextLength.oneMonth), isTrue);
    expect(inWindow(on(day(2026, 10, 22)), today, LifeContextLength.oneMonth), isFalse);
    expect(inWindow(on(day(2025, 11, 30)), today, LifeContextLength.threeMonths), isFalse);
    expect(inWindow(on(today), today, LifeContextLength.oneWeek), isTrue);
  });

  test('newest day first; within a day, in the order kept', () {
    final [a, b, c, ...] = keptFromFixtures();
    Kept on(Kept k, NightDate d) => Kept(id: k.id, night: k.night, day: d, text: k.text);
    final older = on(a, day(2026, 11, 1));
    final first = on(b, day(2026, 11, 20));
    final second = on(c, day(2026, 11, 20));
    expect(newestFirst([older, first, second]), [first, second, older]);
    expect(newestFirst([second, older, first]), [second, first, older]);
  });
}
