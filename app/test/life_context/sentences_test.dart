// What counts as a sentence (C159-I item 1; D110; D131): each invented
// passage's sentences, word for word (fixtures/invented-nights.json, R2).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/life_context/sentences.dart';

import '../fixtures.dart';

void main() {
  final waking = [for (final n in inventedNights()) ...n.waking];

  test('each invented passage gives exactly its sentences, in order', () {
    for (final w in waking) {
      expect(sentencesOf(w.text), w.sentences, reason: w.text);
    }
  });

  test("every sentence is the passage's own text, word for word", () {
    for (final w in waking) {
      var from = 0;
      for (final s in sentencesOf(w.text)) {
        final at = w.text.indexOf(s, from);
        expect(at, greaterThanOrEqualTo(0), reason: s);
        from = at + s.length;
      }
    }
  });

  test('a line break ends a sentence; spaces at either end go', () {
    final w = invented('framed-opening-en').waking.single;
    expect(w.text, contains('\n'));
    expect(sentencesOf(w.text), hasLength(2));
    expect(sentencesOf(w.text).every((s) => s == s.trim()), isTrue);
  });

  test('nothing, spaces or marks alone hold no sentence', () {
    expect(sentencesOf(''), isEmpty);
    expect(sentencesOf('  \n \t '), isEmpty);
    expect(sentencesOf('... ?! …'), isEmpty);
    expect(sentencesOf('​'), isEmpty);
  });

  test('a mark with no space after it ends nothing', () {
    expect(sentencesOf('2.5'), ['2.5']);
    expect(sentencesOf('a.b c'), ['a.b c']);
  });
}
