// The generated design values (D49 a). G1 proves the file is the
// generator's output; these tests prove what its two classes compute.
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/tokens.g.dart';

void main() {
  test('letter spacing is the em value times the size', () {
    const role = TypeRole('Inter', FontWeight.w600, 20, 1.4, -0.02);
    expect(role.letterSpacing, closeTo(-0.4, 1e-9));
  });

  test('a type role makes its text style', () {
    const colour = Color(0xFF333333);
    final style = TypeRoles.h2.style(colour);
    expect(style.fontFamily, TypeRoles.h2.family);
    expect(style.fontWeight, TypeRoles.h2.weight);
    expect(style.fontSize, TypeRoles.h2.size);
    expect(style.height, TypeRoles.h2.height);
    expect(style.letterSpacing, TypeRoles.h2.letterSpacing);
    expect(style.color, colour);
  });

  test('a gradient has an end colour; a plain colour has none', () {
    expect(LightColours.record.isGradient, isTrue);
    expect(LightColours.page.isGradient, isFalse);
  });
}
