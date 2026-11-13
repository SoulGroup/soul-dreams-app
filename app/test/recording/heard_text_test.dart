// Words heard, joined at the end of the field's text (D71 Q6; D73). Soniox's
// tokens are sub-word pieces with their spaces inside them, so their text
// is joined exactly as sent; the one thing trimmed is a space at the very
// start of an empty field. The pieces below are Soniox's own documented
// examples, not a night.
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
    var r = (text: '', shown: '');
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
  });

  test('a provisional piece edited away is left alone', () {
    var r = withHeard('', '', tokens[0], tokens[1]);
    final edited = r.text.substring(0, r.text.length - 1);
    r = withHeard(edited, r.shown, tokens[1], '');
    expect(r.text, edited + tokens[1]);
  });

  test('the whole invented dream, heard in pieces, reads as written', () {
    var r = (text: '', shown: '');
    for (var i = 0; i < tokens.length; i++) {
      r = withHeard(r.text, r.shown, tokens[i], i + 1 < tokens.length ? tokens[i + 1] : '');
    }
    expect(r.text, tokens.join());
    expect(r.shown, '');
  });
}
