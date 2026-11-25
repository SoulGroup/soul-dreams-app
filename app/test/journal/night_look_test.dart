// A night's look (D110; head's message 25): a read night shows one painting
// of the set, chosen from its id alone; an unread night, or no set, the
// painted gradient.
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/words/lines.g.dart' show Lang;

import '../fixtures.dart';
import 'zones.dart';

Night nightWith(String id, {String key = 'two-dreams-en', String? name}) {
  final n = invented(key);
  final at = stockholm(2026, 6, 2, 23);
  return Night(
    id: id,
    firstRecorded: at,
    date: (year: 2026, month: 6, day: 2),
    closes: at.add(const Duration(hours: 22)),
    lang: Lang.en,
    name: name,
    dreams: n.dreams,
  );
}

void main() {
  const a = '0000000a00000000000000000000000f';
  const b = 'ffffffff00000000000000000000000f';

  test('the painting: first 32 bits of the id, modulo count', () {
    expect(paintingFor(a, 4), 2);
    expect(paintingFor(b, 4), 3);
    expect(paintingFor(b, 1), 0);
  });

  test('an unread night shows the painted gradient', () {
    expect(lookOf(nightWith(a), read: false, paintings: 4), const PaintedGradient());
  });

  test('a read night shows its painting', () {
    expect(lookOf(nightWith(a), read: true, paintings: 4), const Painting(2));
  });

  // D121 item 3: Night images Off, every night the gradient.
  test('with Night images Off, a read night shows the gradient', () {
    expect(lookOf(nightWith(a), read: true, paintings: 4, images: false), const PaintedGradient());
  });

  test('with no paintings, a read night shows the gradient', () {
    expect(lookOf(nightWith(a), read: true, paintings: 0), const PaintedGradient());
  });

  test("none of the night's words choose it", () {
    final one = lookOf(nightWith(b), read: true, paintings: 5);
    final other = lookOf(nightWith(b, key: 'one-dream-sv', name: 'x'), read: true, paintings: 5);
    expect(one, other);
  });

  test('no night is read before the readings', () {
    expect(noneRead(nightWith(a)), isFalse);
  });

  test("the preview's check calls every night read", () {
    expect(allRead(nightWith(a)), isTrue);
  });

  // D162: while Personal, a read night's own painting, once it has come.
  test("a read night's own painting, given: shown instead of the set's", () {
    final own = Uint8List.fromList([1, 2, 3]);
    expect(lookOf(nightWith(a), read: true, paintings: 4, personal: own), PersonalPainting(own));
    expect(lookOf(nightWith(a), read: true, paintings: 0, personal: own), PersonalPainting(own));
    expect(PersonalPainting(own) == PersonalPainting(Uint8List.fromList([1, 2, 3])), isFalse);
  });

  test('its own painting: never on an unread night, nor while Off', () {
    final own = Uint8List.fromList([1, 2, 3]);
    expect(lookOf(nightWith(a), read: false, paintings: 4, personal: own), const PaintedGradient());
    expect(lookOf(nightWith(a), read: true, paintings: 4, images: false, personal: own), const PaintedGradient());
  });
}
