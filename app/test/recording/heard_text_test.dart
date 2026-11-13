// Words heard, joined at the end of the field's text (D71 Q6).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/recording/heard_text.dart';

import 'fakes.dart';

void main() {
  final tokens = inventedTokens();

  test('into an empty field: no space in front', () {
    final r = withHeard('', '', tokens[0], tokens[1]);
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, tokens[1]);
  });

  test('provisional words are replaced, never doubled', () {
    var r = withHeard('', '', '', tokens[0]);
    r = withHeard(r.text, r.shown, '', tokens[0] + tokens[1]);
    expect(r.text, tokens[0] + tokens[1]);
    r = withHeard(r.text, r.shown, tokens[0] + tokens[1], '');
    expect(r.text, tokens[0] + tokens[1]);
    expect(r.shown, '');
  });

  test('after typed words, one space joins them', () {
    final word = tokens[0];
    expect(withHeard(word, '', word, '').text, '$word $word');
    expect(withHeard('$word ', '', word, '').text, '$word $word');
    expect(withHeard('$word\n', '', ' $word', '').text, '$word\n$word');
    expect(withHeard(word, '', ' $word', '').text, '$word $word');
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
