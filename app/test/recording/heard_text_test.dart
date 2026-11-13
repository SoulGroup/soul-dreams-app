// Words heard, joined at the end of the field's text (D71 Q6; D73). Soniox's
// tokens are sub-word pieces with their spaces inside them, so their text
// is joined exactly as sent; the one thing trimmed is a space at the very
// start of an empty field. At the start of a recording session only (D74),
// one space joins the typed words to the first piece heard. The pieces
// below are Soniox's own documented examples, not a night.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/recording/heard_text.dart';

import 'fakes.dart';

void main() {
  final tokens = inventedTokens();

  test('into an empty field: no space in front', () {
    final r = withHeard('', '', tokens[0], tokens[1], at: 0);
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, tokens[1]);
    expect(withHeard('', '', ' How', '', at: 0).text, 'How');
    expect(withHeard('', '', '', ' How', at: 0).text, 'How');
  });

  test('provisional words are replaced, never doubled', () {
    var r = withHeard('', '', '', tokens[0], at: 0);
    r = withHeard(r.text, r.shown, '', tokens[0] + tokens[1], at: r.at);
    expect(r.text, tokens[0] + tokens[1]);
    r = withHeard(r.text, r.shown, tokens[0] + tokens[1], '', at: r.at);
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, '');
  });

  test('pieces joined exactly as sent: How are you doing?', () {
    const pieces = ['How', ' are', ' you', ' do', 'ing', '?'];
    var r = (text: '', shown: '', at: 0);
    for (final piece in pieces) {
      r = withHeard(r.text, r.shown, piece, '', at: r.at);
    }
    expect(r.text, 'How are you doing?');
  });

  test('a word split across replies gets no space inside', () {
    var r = withHeard('', '', ' San', ' Franc', at: 0);
    expect(r.text, 'San Franc');
    r = withHeard(r.text, r.shown, ' Franc', 'isc', at: r.at);
    expect(r.text, 'San Francisc');
    r = withHeard(r.text, r.shown, 'isc', 'o,', at: r.at);
    expect(r.text, 'San Francisco,');
    r = withHeard(r.text, r.shown, 'o,', '', at: r.at);
    expect(r.text, 'San Francisco,');
    expect(r.shown, '');
  });

  test('after typed words, the heard text is added exactly as sent', () {
    expect(withHeard('word', '', ' and', ' more', at: 0).text, 'word and more');
    expect(withHeard('word ', '', 'and', '', at: 0).text, 'word and');
    expect(withHeard('word\n', '', 'and', '', at: 0).text, 'word\nand');
    expect(withHeard('word ', '', ' ', '', at: 0).text, 'word  ');
    expect(withHeard('word', '', 'The', '', at: 0).text, 'wordThe');
  });

  test('a provisional-only first message, then the same piece final: no doubling', () {
    var r = withHeard('', '', '', ' How', at: 0);
    expect(r.text, 'How');
    r = withHeard(r.text, r.shown, ' How', '', at: r.at);
    expect(r.text, 'How');
    expect(r.shown, '');
  });

  // D74: the start of a session.
  test('a session starts after typed words with one space', () {
    expect(withHeard('word', '', 'The', '', first: true, at: 0).text, 'word The');
    expect(withHeard('dream.', '', 'I', '', first: true, at: 0).text, 'dream. I');
    expect(withHeard('word', '', '', 'The', first: true, at: 0).text, 'word The');
  });

  test('a session starts with no space where none is wanted', () {
    expect(withHeard('', '', 'The', '', first: true, at: 0).text, 'The');
    expect(withHeard('', '', ' The', '', first: true, at: 0).text, 'The');
    expect(withHeard('word ', '', 'The', '', first: true, at: 0).text, 'word The');
    expect(withHeard('word\n', '', 'The', '', first: true, at: 0).text, 'word\nThe');
    expect(withHeard('word', '', ' The', '', first: true, at: 0).text, 'word The');
  });

  test('inside a session everything is joined exactly as sent', () {
    expect(withHeard('word The', '', 'dr', 'eam', first: false, at: 0).text, 'word Thedream');
    var r = withHeard('word', '', '', 'The', first: true, at: 0);
    expect(r.text, 'word The');
    r = withHeard(r.text, r.shown, 'The', 'dr', first: true, at: r.at);
    expect(r.text, 'word Thedr');
    r = withHeard(r.text, r.shown, 'dr', 'eam', first: false, at: r.at);
    expect(r.text, 'word Thedream');
  });

  // D75: the dreamer types while a provisional piece is shown: the stale
  // piece is dropped, the typed words stay, finals still append.
  test('typed words after a provisional piece: it is dropped, never doubled', () {
    var r = withHeard('', '', '', tokens[0] + tokens[1], first: true, at: 0);
    expect(r.text, tokens[0] + tokens[1]);
    final typed = '${r.text}x';
    r = withHeard(typed, r.shown, tokens[0] + tokens[1], '', first: true, at: r.at);
    expect(r.text, 'x ${tokens[0]}${tokens[1]}');
    expect(r.shown, '');
  });

  test('typed words before a provisional piece: it is still replaced', () {
    final r = withHeard('word', '', '', ' and', first: true, at: 0);
    expect(r.text, 'word and');
    final typed = 'typed ${r.text}';
    expect(withHeard(typed, r.shown, ' and', '', at: r.at).text, 'typed word and');
  });

  // D76: the provisional piece is dropped only where it was put.
  test('a short piece typed around: the one put there is dropped', () {
    final heard = withHeard('w', '', '', '.', at: 0);
    expect(heard.text, 'w.');
    expect(heard.at, 1);
    final typed = '${heard.text} q. r';
    expect(withHeard(typed, heard.shown, '.', '', at: heard.at).text, 'w q. r.');
  });

  test('a piece repeated in typed words: first copy goes', () {
    final heard = withHeard('w', '', '', ' a', at: 0);
    expect(heard.text, 'w a');
    expect(heard.at, 1);
    final typed = '${heard.text} b a c';
    final next = withHeard(typed, heard.shown, ' a', '', at: heard.at);
    expect(next.text, 'w b a c a');
    expect(next.shown, '');
  });

  test('typed onto a piece: it goes, typed stays', () {
    final heard = withHeard('w', '', '', ' a', at: 0);
    final next = withHeard('${heard.text}nd', heard.shown, ' a', '', at: heard.at);
    expect(next.text, 'wnd a');
  });

  test('typed before the piece: it is still found at the end', () {
    final heard = withHeard('w', '', '', ' a', at: 0);
    final typed = 'x ${heard.text}';
    expect(withHeard(typed, heard.shown, ' a', '', at: heard.at).text, 'x w a');
  });

  test('typed before and after the piece: it is left alone', () {
    final heard = withHeard('w', '', '', ' a', at: 0);
    final typed = 'x ${heard.text} b';
    expect(withHeard(typed, heard.shown, ' b', '', at: heard.at).text, 'x w a b b');
  });

  test('the offset of a new piece is where it starts', () {
    var r = withHeard('', '', ' How', ' are', at: 0);
    expect(r.text, 'How are');
    expect(r.shown, ' are');
    expect(r.at, 3);
    r = withHeard(r.text, r.shown, ' are', '', at: r.at);
    expect(r.shown, '');
    expect(r.text, 'How are');
  });

  // D77: the text got shorter than the offset; no crash, the heard words stay.
  test('the field emptied or shortened past the piece: no crash', () {
    final heard = withHeard('w', '', '', ' a', at: 0);
    expect(heard.text, 'w a');
    expect(withHeard('', heard.shown, ' a', '', at: heard.at).text, 'a');
    expect(withHeard('w', heard.shown, ' a', '', at: heard.at).text, 'w a');
    expect(withHeard('', heard.shown, '', ' b', at: heard.at).text, 'b');
    expect(withHeard('w a', heard.shown, '', '', at: 99).text, 'w');
    expect(withHeard('w a', heard.shown, '', '', at: -1).text, 'w');
  });

  // D77: an edit wholly before the piece moves the offset with it.
  test('typed at the start: the offset moves, the right copy goes', () {
    final heard = withHeard('a.b', '', '', '.', at: 0);
    expect(heard.text, 'a.b.');
    expect(heard.at, 3);
    final typed = 'XY${heard.text}';
    final at = movedTo(heard.text, typed, heard.at);
    expect(at, 5);
    expect(withHeard(typed, heard.shown, '', '', at: at).text, 'XYa.b');
  });

  test('an edit before the piece shifts the offset', () {
    expect(movedTo('abc.', 'XYabc.', 3), 5);
    expect(movedTo('abc.', 'bc.', 3), 2);
    expect(movedTo('abc.', 'abXc.', 3), 4);
    expect(movedTo('abc.', 'abc.', 3), 3);
    expect(movedTo('abc.', 'abcXY.', 3), 5);
    expect(movedTo('', 'abc', 0), 3);
    expect(movedTo('abc.', 'aXc.', 3), 3);
  });

  test('an edit at or after it leaves the offset', () {
    expect(movedTo('abc.', 'abc.XY', 3), 3);
    expect(movedTo('abc.', 'ab', 3), 3);
    expect(movedTo('abc.', 'abc', 3), 3);
    expect(movedTo('abc.', 'X', 3), 3);
  });

  test('a copy at the old offset is left alone', () {
    final heard = withHeard('I', '', '', ' was', at: 0);
    final typed = 'Q was ${heard.text}';
    expect(typed.startsWith(' was', heard.at), isTrue);
    final at = movedTo(heard.text, typed, heard.at);
    expect(withHeard(typed, heard.shown, ' was', '', at: at).text, 'Q was I was');
  });

  test('a provisional piece edited away is left alone', () {
    var r = withHeard('', '', tokens[0], tokens[1], at: 0);
    final edited = r.text.substring(0, r.text.length - 1);
    r = withHeard(edited, r.shown, tokens[1], '', at: r.at);
    expect(r.text, edited + tokens[1]);
  });

  test('the whole invented dream, heard in pieces, reads as written', () {
    var r = (text: '', shown: '', at: 0);
    for (var i = 0; i < tokens.length; i++) {
      r = withHeard(r.text, r.shown, tokens[i], i + 1 < tokens.length ? tokens[i + 1] : '', at: r.at);
    }
    expect(r.text, tokens.join());
    expect(r.shown, '');
  });
}
