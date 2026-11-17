// Words heard, put in at the insertion point (D87): where the caret was when
// the recording started. Soniox's tokens are sub-word pieces with their
// spaces inside them, so their text is joined exactly as sent (D73); the
// one thing trimmed is a space at the very start of an empty field. One
// space joins the typed words before to the first piece, when neither side
// has a whitespace at the join (D74), and one space joins the last piece to
// the text after, if that text does not start with whitespace (D87). The
// dreamer's one edit made while the recording stops applies to the settled
// text (D87 2). The pieces below are Soniox's own documented examples, not a
// night.
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

  // D87 2: the dreamer's edit, held while the last words came, applied to
  // the settled text. The kept text before and after is 1 and 3 long here.
  test('a key press at the words lands after the settled words', () {
    final r = editSettled('a xyw bc', 'a xy bc', 'a xyz bc', keepStart: 1, keepEnd: 3)!;
    expect(r.text, 'a xywz bc');
    expect(r.caret, 6);
  });

  test('a backspace at the words: the last settled character goes', () {
    final r = editSettled('a xyw bc', 'a xy bc', 'a x bc', keepStart: 1, keepEnd: 3)!;
    expect(r.text, 'a xy bc');
    expect(r.caret, 4);
  });

  test('an edit before or after the words stays in place', () {
    expect(editSettled('a xyw bc', 'a xy bc', 'Qa xy bc', keepStart: 1, keepEnd: 3)!.text, 'Qa xyw bc');
    expect(editSettled('a xyw bc', 'a xy bc', 'a xy bQc', keepStart: 1, keepEnd: 3)!.text, 'a xyw bQc');
    expect(editSettled('a xyw bc', 'a xy bc', 'a xy b', keepStart: 1, keepEnd: 3)!.text, 'a xyw b');
  });

  test('a cut across all of it takes the settled words', () {
    final r = editSettled('a xyw bc', 'a xy bc', '', selected: 7, keepStart: 1, keepEnd: 3)!;
    expect(r.text, '');
    expect(r.caret, 0);
  });

  // Task 16g: one edit attempt never removes more than the dreamer's own
  // selection or one character; a value that would is refused (null).
  test('an edit that would remove more is refused', () {
    expect(editSettled('a xyw bc', 'a xy bc', '', keepStart: 1, keepEnd: 3), isNull);
    expect(editSettled('a xyw bc', 'a xy bc', 'a bc', keepStart: 1, keepEnd: 3), isNull);
    expect(editSettled('a xyw bc', 'a xy bc', 'a xQ bc', keepStart: 1, keepEnd: 3), isNotNull);
    expect(editSettled('a xyw bc', 'a xy bc', 'a  bc', selected: 1, keepStart: 1, keepEnd: 3), isNull);
    expect(editSettled('a xyw bc', 'a xy bc', 'a  bc', selected: 2, keepStart: 1, keepEnd: 3), isNotNull);
  });

  test('a caret moved, nothing typed: the caret moves, the text settles', () {
    final r = editSettled('a xyw bc', 'a xy bc', 'a xy bc', caret: 0, keepStart: 1, keepEnd: 3)!;
    expect(r.text, 'a xyw bc');
    expect(r.caret, 0);
    expect(editSettled('a xyw bc', 'a xy bc', 'a xy bc', caret: 7, keepStart: 1, keepEnd: 3)!.caret, 8);
    expect(editSettled('a xyw bc', 'a xy bc', 'a xy bc', caret: 3, keepStart: 1, keepEnd: 3)!.caret, 4);
  });

  test('a letter typed beside its twin: start and end never overlap', () {
    expect(editSettled('a xyyw bc', 'a xyy bc', 'a xyyy bc', keepStart: 1, keepEnd: 3)!.text, 'a xyywy bc');
  });
}
