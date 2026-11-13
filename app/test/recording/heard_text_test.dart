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
    final r = withHeard('', '', tokens[0], tokens[1]);
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, tokens[1]);
    expect(withHeard('', '', ' How', '').text, 'How');
    expect(withHeard('', '', '', ' How').text, 'How');
  });

  test('provisional words are replaced, never doubled', () {
    var r = withHeard('', '', '', tokens[0]);
    r = withHeard(r.text, r.shown, '', tokens[0] + tokens[1]);
    expect(r.text, tokens[0] + tokens[1]);
    r = withHeard(r.text, r.shown, tokens[0] + tokens[1], '');
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, '');
  });

  test('pieces joined exactly as sent: How are you doing?', () {
    const pieces = ['How', ' are', ' you', ' do', 'ing', '?'];
    var r = (text: '', shown: '', at: 0);
    for (final piece in pieces) {
      r = withHeard(r.text, r.shown, piece, '');
    }
    expect(r.text, 'How are you doing?');
  });

  test('a word split across replies gets no space inside', () {
    var r = withHeard('', '', ' San', ' Franc');
    expect(r.text, 'San Franc');
    r = withHeard(r.text, r.shown, ' Franc', 'isc');
    expect(r.text, 'San Francisc');
    r = withHeard(r.text, r.shown, 'isc', 'o,');
    expect(r.text, 'San Francisco,');
    r = withHeard(r.text, r.shown, 'o,', '');
    expect(r.text, 'San Francisco,');
    expect(r.shown, '');
  });

  test('after typed words, the heard text is added exactly as sent', () {
    expect(withHeard('word', '', ' and', ' more').text, 'word and more');
    expect(withHeard('word ', '', 'and', '').text, 'word and');
    expect(withHeard('word\n', '', 'and', '').text, 'word\nand');
    expect(withHeard('word ', '', ' ', '').text, 'word  ');
    expect(withHeard('word', '', 'The', '').text, 'wordThe');
  });

  test('a provisional-only first message, then the same piece final: no doubling', () {
    var r = withHeard('', '', '', ' How');
    expect(r.text, 'How');
    r = withHeard(r.text, r.shown, ' How', '');
    expect(r.text, 'How');
    expect(r.shown, '');
  });

  // D74: the start of a session.
  test('a session starts after typed words with one space', () {
    expect(withHeard('word', '', 'The', '', first: true).text, 'word The');
    expect(withHeard('dream.', '', 'I', '', first: true).text, 'dream. I');
    expect(withHeard('word', '', '', 'The', first: true).text, 'word The');
  });

  test('a session starts with no space where none is wanted', () {
    expect(withHeard('', '', 'The', '', first: true).text, 'The');
    expect(withHeard('', '', ' The', '', first: true).text, 'The');
    expect(withHeard('word ', '', 'The', '', first: true).text, 'word The');
    expect(withHeard('word\n', '', 'The', '', first: true).text, 'word\nThe');
    expect(withHeard('word', '', ' The', '', first: true).text, 'word The');
  });

  test('inside a session everything is joined exactly as sent', () {
    expect(withHeard('word The', '', 'dr', 'eam', first: false).text, 'word Thedream');
    var r = withHeard('word', '', '', 'The', first: true);
    expect(r.text, 'word The');
    r = withHeard(r.text, r.shown, 'The', 'dr', first: true);
    expect(r.text, 'word Thedr');
    r = withHeard(r.text, r.shown, 'dr', 'eam', first: false);
    expect(r.text, 'word Thedream');
  });

  // D75: the dreamer types while a provisional piece is shown: the stale
  // piece is dropped, the typed words stay, finals still append.
  test('typed words after a provisional piece: it is dropped, never doubled', () {
    var r = withHeard('', '', '', tokens[0] + tokens[1], first: true);
    expect(r.text, tokens[0] + tokens[1]);
    final typed = '${r.text}x';
    r = withHeard(typed, r.shown, tokens[0] + tokens[1], '', first: true, at: r.at);
    expect(r.text, 'x ${tokens[0]}${tokens[1]}');
    expect(r.shown, '');
  });

  test('typed words before a provisional piece: it is still replaced', () {
    final r = withHeard('word', '', '', ' and', first: true);
    expect(r.text, 'word and');
    final typed = 'typed ${r.text}';
    expect(withHeard(typed, r.shown, ' and', '').text, 'typed word and');
  });

  // D76: the provisional piece is dropped only where it was put.
  test('a short piece typed around: the one put there is dropped', () {
    final heard = withHeard('w', '', '', '.');
    expect(heard.text, 'w.');
    expect(heard.at, 1);
    final typed = '${heard.text} q. r';
    expect(withHeard(typed, heard.shown, '.', '', at: heard.at).text, 'w q. r.');
  });

  test('a piece repeated in typed words: first copy goes', () {
    final heard = withHeard('w', '', '', ' a');
    expect(heard.text, 'w a');
    expect(heard.at, 1);
    final typed = '${heard.text} b a c';
    final next = withHeard(typed, heard.shown, ' a', '', at: heard.at);
    expect(next.text, 'w b a c a');
    expect(next.shown, '');
  });

  test('typed onto a piece: it goes, typed stays', () {
    final heard = withHeard('w', '', '', ' a');
    final next = withHeard('${heard.text}nd', heard.shown, ' a', '', at: heard.at);
    expect(next.text, 'wnd a');
  });

  test('typed before the piece: it is still found at the end', () {
    final heard = withHeard('w', '', '', ' a');
    final typed = 'x ${heard.text}';
    expect(withHeard(typed, heard.shown, ' a', '', at: heard.at).text, 'x w a');
  });

  test('typed before and after the piece: it is left alone', () {
    final heard = withHeard('w', '', '', ' a');
    final typed = 'x ${heard.text} b';
    expect(withHeard(typed, heard.shown, ' b', '', at: heard.at).text, 'x w a b b');
  });

  test('the offset of a new piece is where it starts', () {
    var r = withHeard('', '', ' How', ' are');
    expect(r.text, 'How are');
    expect(r.shown, ' are');
    expect(r.at, 3);
    r = withHeard(r.text, r.shown, ' are', '', at: r.at);
    expect(r.shown, '');
    expect(r.text, 'How are');
  });

  test('a provisional piece edited away is left alone', () {
    var r = withHeard('', '', tokens[0], tokens[1]);
    final edited = r.text.substring(0, r.text.length - 1);
    r = withHeard(edited, r.shown, tokens[1], '');
    expect(r.text, edited + tokens[1]);
  });

  test('the whole invented dream, heard in pieces, reads as written', () {
    var r = (text: '', shown: '', at: 0);
    for (var i = 0; i < tokens.length; i++) {
      r = withHeard(r.text, r.shown, tokens[i], i + 1 < tokens.length ? tokens[i + 1] : '');
    }
    expect(r.text, tokens.join());
    expect(r.shown, '');
  });
}
