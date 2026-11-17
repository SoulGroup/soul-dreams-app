// Words heard, joined at the end of the field's text (D71 Q6; D73). Soniox's
// tokens are sub-word pieces with their spaces inside them, so their text
// is joined exactly as sent; the one thing trimmed is a space at the very
// start of an empty field. At the start of a recording session only (D74),
// one space joins the typed words to the first piece heard. The field never
// holds more than one provisional piece, and never a stale one after a newer
// reply, whatever the dreamer edits (Task 16e): what the edit left of the
// piece goes, the dreamer's own characters stay. The pieces below are
// Soniox's own documented examples, not a night.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/recording/heard_text.dart';

import 'fakes.dart';

typedef Heard = ({String text, String shown, int at});

void main() {
  final tokens = inventedTokens();
  const none = (text: '', shown: '', at: 0);

  // The next reply, the field's text being [now] (the dreamer's edit, if
  // any, made since [r] was set).
  Heard next(Heard r, String finalText, String provisional, {String? now, bool first = false}) => withHeard(
    withoutPiece(r.text, now ?? r.text, r.at, r.shown.length),
    finalText,
    provisional,
    first: first,
  );

  test('into an empty field: no space in front', () {
    final r = withHeard('', tokens[0], tokens[1]);
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, tokens[1]);
    expect(withHeard('', ' How', '').text, 'How');
    expect(withHeard('', '', ' How').text, 'How');
  });

  test('provisional words are replaced, never doubled', () {
    var r = next(none, '', tokens[0]);
    r = next(r, '', tokens[0] + tokens[1]);
    expect(r.text, tokens[0] + tokens[1]);
    r = next(r, tokens[0] + tokens[1], '');
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, '');
  });

  test('pieces joined exactly as sent: How are you doing?', () {
    var r = none;
    for (final piece in ['How', ' are', ' you', ' do', 'ing', '?']) {
      r = next(r, piece, '');
    }
    expect(r.text, 'How are you doing?');
  });

  test('a word split across replies gets no space inside', () {
    var r = next(none, ' San', ' Franc');
    expect(r.text, 'San Franc');
    r = next(r, ' Franc', 'isc');
    expect(r.text, 'San Francisc');
    r = next(r, 'isc', 'o,');
    expect(r.text, 'San Francisco,');
    r = next(r, 'o,', '');
    expect(r.text, 'San Francisco,');
    expect(r.shown, '');
  });

  test('after typed words, the heard text is added exactly as sent', () {
    expect(withHeard('word', ' and', ' more').text, 'word and more');
    expect(withHeard('word ', 'and', '').text, 'word and');
    expect(withHeard('word\n', 'and', '').text, 'word\nand');
    expect(withHeard('word ', ' ', '').text, 'word  ');
    expect(withHeard('word', 'The', '').text, 'wordThe');
  });

  test('a provisional-only first message, then the same piece final: no doubling', () {
    var r = next(none, '', ' How');
    expect(r.text, 'How');
    r = next(r, ' How', '');
    expect(r.text, 'How');
    expect(r.shown, '');
  });

  // D74: the start of a session.
  test('a session starts after typed words with one space', () {
    expect(withHeard('word', 'The', '', first: true).text, 'word The');
    expect(withHeard('dream.', 'I', '', first: true).text, 'dream. I');
    expect(withHeard('word', '', 'The', first: true).text, 'word The');
  });

  test('a session starts with no space where none is wanted', () {
    expect(withHeard('', 'The', '', first: true).text, 'The');
    expect(withHeard('', ' The', '', first: true).text, 'The');
    expect(withHeard('word ', 'The', '', first: true).text, 'word The');
    expect(withHeard('word\n', 'The', '', first: true).text, 'word\nThe');
    expect(withHeard('word', ' The', '', first: true).text, 'word The');
  });

  test('inside a session everything is joined exactly as sent', () {
    expect(withHeard('word The', 'dr', 'eam').text, 'word Thedream');
    var r = withHeard('word', '', 'The', first: true);
    expect(r.text, 'word The');
    r = next(r, 'The', 'dr', first: true);
    expect(r.text, 'word Thedr');
    r = next(r, 'dr', 'eam');
    expect(r.text, 'word Thedream');
  });

  test('the offset of a new piece is where it starts', () {
    var r = withHeard('', ' How', ' are');
    expect(r.text, 'How are');
    expect(r.shown, ' are');
    expect(r.at, 3);
    r = next(r, ' are', '');
    expect(r.shown, '');
    expect(r.text, 'How are');
  });

  // D75: typed after a provisional piece: it goes, the typed words stay,
  // finals still append.
  test('typed words after a provisional piece: it is dropped, never doubled', () {
    var r = withHeard('', '', tokens[0] + tokens[1], first: true);
    r = next(r, tokens[0] + tokens[1], '', now: '${r.text}x', first: true);
    expect(r.text, 'x ${tokens[0]}${tokens[1]}');
    expect(r.shown, '');
  });

  test('typed onto a piece: it goes, typed stays', () {
    final r = withHeard('w', '', ' a');
    expect(next(r, ' a', '', now: '${r.text}nd').text, 'wnd a');
  });

  // D76: the dreamer's own copies of the piece are never taken.
  test('a short piece typed around: the one put there is dropped', () {
    final r = withHeard('w', '', '.');
    expect(r.at, 1);
    expect(next(r, '.', '', now: '${r.text} q. r').text, 'w q. r.');
  });

  test('a piece repeated in typed words: the one put there goes', () {
    final r = withHeard('w', '', ' a');
    final n = next(r, ' a', '', now: '${r.text} b a c');
    expect(n.text, 'w b a c a');
    expect(n.shown, '');
  });

  // D77: an edit wholly before the piece moves it.
  test('typed before the piece: it goes from where it moved', () {
    final r = withHeard('w', '', ' a');
    expect(next(r, ' a', '', now: 'x ${r.text}').text, 'x w a');
    final dot = withHeard('a.b', '', '.');
    expect(next(dot, '', '', now: 'XY${dot.text}').text, 'XYa.b');
  });

  test('a copy at the old offset is left alone', () {
    final r = withHeard('I', '', ' was');
    expect(next(r, ' was', '', now: 'Q was ${r.text}').text, 'Q was I was');
  });

  test('the field emptied: the heard words arrive into it', () {
    final r = withHeard('w', '', ' a');
    expect(next(r, ' a', '', now: '').text, 'a');
    expect(next(r, '', ' b', now: '').text, 'b');
  });

  // Task 16e: backspace into, through and past the piece.
  test('backspace into the piece: what is left of it goes', () {
    var r = withHeard(tokens[0], '', tokens[1] + tokens[2]);
    for (var cut = 1; cut < (tokens[1] + tokens[2]).length; cut++) {
      final edited = r.text.substring(0, r.text.length - 1);
      r = next(r, '', tokens[1] + tokens[2], now: edited);
      expect(r.text, tokens[0] + tokens[1] + tokens[2]);
    }
    r = next(r, tokens[1] + tokens[2], '', now: r.text.substring(0, r.text.length - 3));
    expect(r.text, tokens[0] + tokens[1] + tokens[2]);
  });

  test('backspace through the piece and past it: the cut stays', () {
    final heard = tokens[0] + tokens[1];
    final r = withHeard(heard, '', tokens[2]);
    final edited = heard.substring(0, heard.length - 2);
    expect(next(r, '', tokens[3], now: edited).text, edited + tokens[3]);
  });

  test('typed inside the piece: typed characters stay, piece goes', () {
    expect(withoutPiece('w abc', 'w aXbc', 1, 4), 'wX');
    // A letter typed beside its own twin: the common start and end never overlap.
    expect(withoutPiece('w abc', 'w abbc', 1, 4), 'wb');
    expect(withoutPiece('w abc', 'w ab', 1, 4), 'w');
    expect(withoutPiece('w abc', 'w', 1, 4), 'w');
    expect(withoutPiece('w abc', '', 1, 4), '');
    expect(withoutPiece('w abc', 'Yw abc', 1, 4), 'Yw');
    expect(withoutPiece('w abc', 'w abcZ', 1, 4), 'wZ');
    expect(withoutPiece('w abc', 'w abc', 1, 4), 'w');
    expect(withoutPiece('w abc', 'w abc', 1, 0), 'w abc');
  });

  test('the whole invented dream, heard in pieces, reads as written', () {
    var r = none;
    for (var i = 0; i < tokens.length; i++) {
      r = next(r, tokens[i], i + 1 < tokens.length ? tokens[i + 1] : '');
    }
    expect(r.text, tokens.join());
    expect(r.shown, '');
  });
}
