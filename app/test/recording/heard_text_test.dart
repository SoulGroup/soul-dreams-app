// Words heard, put in at the insertion point (D87): where the caret was when
// the recording started. Soniox's tokens are sub-word pieces with their
// spaces inside them, so their text is joined exactly as sent (D73); the
// one thing trimmed is a space at the very start of an empty field. One
// space joins the typed words before to the first piece, when neither side
// has a whitespace at the join (D74), and one space joins the last piece to
// the text after, if that text does not start with whitespace (D87). An
// edit attempt while recording only stops it; a caret the dreamer placed is
// moved with the words once they land (D90). The pieces below are Soniox's
// own documented examples, not a night.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/recording/heard_text.dart';

import 'fakes.dart';

void main() {
  final tokens = inventedTokens();

  String into(String before, String words, [String after = '']) => dictatedInto(before, words, after).text;

  test('into an empty field: no space in front', () {
    expect(into('', tokens[0] + tokens[1]), tokens[0] + tokens[1]);
    expect(into('', ' How'), 'How');
    expect(into('', ''), '');
  });

  test('pieces joined exactly as sent: How are you doing?', () {
    expect(into('', ['How', ' are', ' you', ' do', 'ing', '?'].join()), 'How are you doing?');
    expect(into('', [' San', ' Franc', 'isc', 'o,'].join()), 'San Francisco,');
  });

  test('after typed words: one space where neither side has one', () {
    expect(into('word', 'The'), 'word The');
    expect(into('dream.', 'I'), 'dream. I');
    expect(into('word', ' The'), 'word The');
    expect(into('word ', 'The'), 'word The');
    expect(into('word\n', 'The'), 'word\nThe');
    expect(into('word ', ' '), 'word  ');
  });

  test('before typed words: one space where the text after has none', () {
    expect(into('', 'The', 'word'), 'The word');
    expect(into('', 'The', ' word'), 'The word');
    expect(into('', 'The', '\nword'), 'The\nword');
    expect(into('a', 'The', 'b'), 'a The b');
    expect(into('a ', 'The', ' b'), 'a The b');
    expect(into('a', '', 'b'), 'ab');
    expect(into('a', ' ', 'b'), 'a b');
  });

  test('the inserted words end before the space that follows them', () {
    final r = dictatedInto('a', 'The', 'b');
    expect(r.text, 'a The b');
    expect(r.end, 5);
    expect(dictatedInto('', ' How', '').end, 3);
    expect(dictatedInto('a', '', 'b').end, 1);
  });

  test('the whole invented dream, heard in pieces, reads as written', () {
    expect(into('', tokens.join()), tokens.join());
  });

  // D90: a caret the dreamer placed while recording, once the last words
  // have landed: before the insertion point it stays; at or after it, it
  // moves with the words. Shown 'a xy bc' (the words ' xy' put in at 1),
  // settled 'a xyw bc'.
  test('a caret before the insertion point stays', () {
    expect(caretSettled(0, insertAt: 1, shownLength: 7, settledLength: 8), 0);
  });

  test('a caret at or after the insertion moves with the words', () {
    expect(caretSettled(1, insertAt: 1, shownLength: 7, settledLength: 8), 2);
    expect(caretSettled(3, insertAt: 1, shownLength: 7, settledLength: 8), 4);
    expect(caretSettled(7, insertAt: 1, shownLength: 7, settledLength: 8), 8);
  });

  test('settled words shorter than the guesses: caret stays in text', () {
    expect(caretSettled(7, insertAt: 1, shownLength: 7, settledLength: 3), 3);
    expect(caretSettled(2, insertAt: 1, shownLength: 7, settledLength: 3), 1);
  });
}
