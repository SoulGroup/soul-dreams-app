// The journal row's grey border (D115) is one more colour of the palette, so
// it fades with the theme as the others do (design-system.md §6).
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';

void main() {
  test('the row border: a grey for each theme', () {
    expect(Palette.light.rowBorder, StandIns.rowBorderLight);
    expect(Palette.dark.rowBorder, StandIns.rowBorderDark);
    expect(StandIns.rowBorderLight, const Color(0xFF9E9E9E));
    expect(StandIns.rowBorderDark, const Color(0xFF8A8A8A));
  });

  test('Submit: color.button.filled in each theme, fading with it', () {
    expect(Palette.light.filledTop, LightColours.buttonFilled.colour);
    expect(Palette.light.filledBottom, LightColours.buttonFilled.colour);
    expect(Palette.light.filledText, LightColours.buttonFilled.text);
    expect(Palette.dark.filledTop, DarkColours.buttonFilled.colour);
    expect(Palette.dark.filledBottom, DarkColours.buttonFilled.colourEnd);
    expect(Palette.dark.filledText, DarkColours.buttonFilled.text);
    final mid = Palette.light.lerp(Palette.dark, 0.5);
    expect(mid.filledTop, Color.lerp(Palette.light.filledTop, Palette.dark.filledTop, 0.5));
    expect(mid.filledBottom, Color.lerp(Palette.light.filledBottom, Palette.dark.filledBottom, 0.5));
    expect(mid.filledText, Color.lerp(Palette.light.filledText, Palette.dark.filledText, 0.5));
  });

  test('the row border fades with the theme', () {
    final mid = Palette.light.lerp(Palette.dark, 0.25).rowBorder;
    expect(mid, Color.lerp(StandIns.rowBorderLight, StandIns.rowBorderDark, 0.25));
    expect(mid, isNot(Palette.light.rowBorder));
    expect(mid, isNot(Palette.dark.rowBorder));
  });
}
