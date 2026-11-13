// The invented nights file (R2) has the shape the tests rely on.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'fixtures.dart';

void main() {
  test('every entry reads as a night', () {
    final json = jsonDecode(File('../fixtures/invented-nights.json').readAsStringSync());
    final raw = (json as Map<String, Object?>)['nights'] as List<Object?>;
    expect(inventedNights(), hasLength(raw.length));
  });

  test('keys are unique; both languages; every dream has words', () {
    final nights = inventedNights();
    expect(nights.map((n) => n.key).toSet(), hasLength(nights.length));
    expect(nights.map((n) => n.lang).toSet(), {'en', 'sv'});
    for (final n in nights) {
      expect(n.dreams, isNotEmpty, reason: n.key);
      expect(n.dreams.every((d) => d.trim().isNotEmpty), isTrue, reason: n.key);
    }
  });

  test('the cases the journal tests need are there', () {
    expect(inventedNights().any((n) => n.dreams.length > 1), isTrue);
    expect(inventedNights().any((n) => n.name != null), isTrue);
    // journal-screens: a dream long enough to be cut at three lines.
    expect(invented('long-dream-en').dreams.single.split(' ').length, greaterThan(60));
  });

  test('the recordings heard are pieces: none empty, each reads as words', () {
    final heard = invented('two-dreams-en').heard;
    expect(heard, hasLength(2));
    for (final session in heard) {
      expect(session, isNotEmpty);
      expect(session.every((p) => p.isNotEmpty), isTrue);
      expect(session.join().trim(), isNotEmpty);
    }
    // The second recording has a piece with no space in front, after others.
    expect(heard[1].skip(1).any((p) => !p.startsWith(' ')), isTrue);
  });
}
