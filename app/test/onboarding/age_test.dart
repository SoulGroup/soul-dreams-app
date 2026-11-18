// The age question's bands (main-path.md, Onboarding; C7-P item 4): MP·6's
// seven labels, the first under 18, the only one the app refuses.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/onboarding/age.dart';
import 'package:souldreams/words/lines.g.dart';

void main() {
  test('seven bands in each language, in the register\'s order', () {
    for (final lang in Lang.values) {
      final bands = ageBands(lang);
      expect(bands, hasLength(7), reason: lang.name);
      expect(bands.join('; '), Lines.MP_6.text(lang));
      expect(bands.every((b) => b.trim() == b && b.isNotEmpty), isTrue);
    }
  });

  test('only the first band, under 18, is refused', () {
    expect(underAge(0), isTrue);
    for (var i = 1; i < 7; i++) {
      expect(underAge(i), isFalse, reason: '$i');
    }
  });
}
