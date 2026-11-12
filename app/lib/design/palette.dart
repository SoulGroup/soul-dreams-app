// The two themes' colours as one theme extension, built from the
// generated design values (design-system.md §2, §3), so that every page
// fades with the theme when Night/Day mode changes it (§6). No value is
// typed here except the dark field's absent border ("no border", §3).
import 'package:flutter/material.dart';

import 'tokens.g.dart';

@immutable
final class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.page,
    required this.text,
    required this.surfaceTop,
    required this.surfaceBottom,
    required this.surfaceBorder,
    required this.summary,
    required this.field,
    required this.fieldBorder,
    required this.fieldText,
    required this.placeholder,
    required this.buttonTop,
    required this.buttonBottom,
    required this.buttonBorder,
    required this.buttonText,
    required this.recordTop,
    required this.recordBottom,
    required this.recordText,
    required this.sectionTop,
    required this.sectionBottom,
    required this.sectionText,
  });

  final Color page;
  final Color text;
  final Color surfaceTop;
  final Color surfaceBottom;
  final Color surfaceBorder;
  final Color summary;
  final Color field;
  final Color fieldBorder;
  final Color fieldText;
  final Color placeholder;
  final Color buttonTop;
  final Color buttonBottom;
  final Color buttonBorder;
  final Color buttonText;
  final Color recordTop;
  final Color recordBottom;
  final Color recordText;
  final Color sectionTop;
  final Color sectionBottom;
  final Color sectionText;

  static final light = Palette(
    page: LightColours.page.colour!,
    text: LightColours.text.colour!,
    surfaceTop: LightColours.surface.colour!,
    surfaceBottom: LightColours.surface.colour!,
    surfaceBorder: LightColours.surfaceBorder.border!,
    summary: LightColours.textSummary.colour!,
    field: LightColours.field.colour!,
    fieldBorder: LightColours.fieldBorder.border!,
    fieldText: LightColours.text.colour!,
    placeholder: LightColours.textPlaceholder.colour!,
    buttonTop: LightColours.button.colour!,
    buttonBottom: LightColours.button.colour!,
    buttonBorder: LightColours.button.border!,
    buttonText: LightColours.button.text!,
    recordTop: LightColours.record.colour!,
    recordBottom: LightColours.record.colourEnd!,
    recordText: LightColours.record.text!,
    sectionTop: LightColours.labelSection.colour!,
    sectionBottom: LightColours.labelSection.colourEnd!,
    sectionText: LightColours.labelSection.text!,
  );

  static final dark = Palette(
    page: DarkColours.page.colour!,
    text: DarkColours.text.colour!,
    surfaceTop: DarkColours.surface.colour!,
    surfaceBottom: DarkColours.surface.colourEnd!,
    surfaceBorder: DarkColours.surface.border!,
    summary: DarkColours.text.colour!,
    field: DarkColours.field.colour!,
    fieldBorder: const Color(0x00000000),
    fieldText: DarkColours.fieldText.colour!,
    placeholder: DarkColours.textPlaceholder.colour!,
    buttonTop: DarkColours.button.colour!,
    buttonBottom: DarkColours.button.colourEnd!,
    buttonBorder: DarkColours.button.border!,
    buttonText: DarkColours.button.text!,
    recordTop: DarkColours.record.colour!,
    recordBottom: DarkColours.record.colourEnd!,
    recordText: DarkColours.record.text!,
    sectionTop: DarkColours.labelSection.colour!,
    sectionBottom: DarkColours.labelSection.colourEnd!,
    sectionText: DarkColours.labelSection.text!,
  );

  static Palette of(BuildContext context) => Theme.of(context).extension<Palette>()!;

  @override
  Palette copyWith() => this;

  @override
  Palette lerp(Palette? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return Palette(
      page: c(page, other.page),
      text: c(text, other.text),
      surfaceTop: c(surfaceTop, other.surfaceTop),
      surfaceBottom: c(surfaceBottom, other.surfaceBottom),
      surfaceBorder: c(surfaceBorder, other.surfaceBorder),
      summary: c(summary, other.summary),
      field: c(field, other.field),
      fieldBorder: c(fieldBorder, other.fieldBorder),
      fieldText: c(fieldText, other.fieldText),
      placeholder: c(placeholder, other.placeholder),
      buttonTop: c(buttonTop, other.buttonTop),
      buttonBottom: c(buttonBottom, other.buttonBottom),
      buttonBorder: c(buttonBorder, other.buttonBorder),
      buttonText: c(buttonText, other.buttonText),
      recordTop: c(recordTop, other.recordTop),
      recordBottom: c(recordBottom, other.recordBottom),
      recordText: c(recordText, other.recordText),
      sectionTop: c(sectionTop, other.sectionTop),
      sectionBottom: c(sectionBottom, other.sectionBottom),
      sectionText: c(sectionText, other.sectionText),
    );
  }
}

/// The theme for [brightness]: the page colour and the palette.
ThemeData themeFor(Brightness brightness) {
  final p = brightness == Brightness.dark ? Palette.dark : Palette.light;
  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: p.page,
    canvasColor: p.page,
    extensions: [p],
  );
}
