// The journal row's grey border (D115) is one more colour of the palette, so
// it fades with the theme as the others do (design-system.md §6).
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/design/stand_ins.dart';

void main() {
  test('the row border: a grey for each theme', () {
    expect(Palette.light.rowBorder, StandIns.rowBorderLight);
    expect(Palette.dark.rowBorder, StandIns.rowBorderDark);
    expect(StandIns.rowBorderLight, const Color(0xFF9E9E9E));
    expect(StandIns.rowBorderDark, const Color(0xFF8A8A8A));
  });

  test('the row border fades with the theme', () {
    final mid = Palette.light.lerp(Palette.dark, 0.25).rowBorder;
    expect(mid, Color.lerp(StandIns.rowBorderLight, StandIns.rowBorderDark, 0.25));
    expect(mid, isNot(Palette.light.rowBorder));
    expect(mid, isNot(Palette.dark.rowBorder));
  });
}
