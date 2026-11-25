// The two themes' colours as one theme extension, built from the
// generated design values (design-system.md §2, §3), so that every page
// fades with the theme when Night/Day mode changes it (§6). No value is
// typed here except the dark field's absent border ("no border", §3); the
// journal row's grey border is a stand-in from stand_ins.dart (D115). Life
// Context's page (§2, §3, color.lifecontext.*): a kept sentence's box, its
// words and its date; the light box's edge is the surface's (the founder's
// screen), and the dark delete icon #D0775A, the founder's ruling against
// C19-P's #8F3D24, which fails 3:1 on the dark box (D161 item 5; StandIns); its list labels take color.tag.dream (a stand-in
// read from the founder's screen). Feedback's Submit takes
// color.button.filled (C11-P; D152).
import 'package:flutter/material.dart';

import 'stand_ins.dart';
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
    required this.rowBorder,
    required this.keptTop,
    required this.keptBottom,
    required this.keptBorder,
    required this.keptText,
    required this.keptDate,
    required this.keptDelete,
    required this.tagTop,
    required this.tagBottom,
    required this.tagText,
    required this.filledTop,
    required this.filledBottom,
    required this.filledText,
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
  final Color rowBorder;
  final Color keptTop;
  final Color keptBottom;
  final Color keptBorder;
  final Color keptText;
  final Color keptDate;
  final Color keptDelete;
  final Color tagTop;
  final Color tagBottom;
  final Color tagText;
  final Color filledTop;
  final Color filledBottom;
  final Color filledText;

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
    rowBorder: StandIns.rowBorderLight,
    keptTop: LightColours.lifecontextBox.colour!,
    keptBottom: LightColours.lifecontextBox.colour!,
    keptBorder: LightColours.surfaceBorder.border!,
    keptText: LightColours.text.colour!,
    keptDate: LightColours.lifecontextDate.colour!,
    keptDelete: LightColours.lifecontextDelete.colour!,
    tagTop: LightColours.tagDream.colour!,
    tagBottom: LightColours.tagDream.colourEnd!,
    tagText: LightColours.tagDream.text!,
    filledTop: LightColours.buttonFilled.colour!,
    filledBottom: LightColours.buttonFilled.colour!,
    filledText: LightColours.buttonFilled.text!,
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
    rowBorder: StandIns.rowBorderDark,
    keptTop: DarkColours.lifecontextBox.colour!,
    keptBottom: DarkColours.lifecontextBox.colourEnd!,
    keptBorder: DarkColours.lifecontextBox.border!,
    keptText: DarkColours.lifecontextText.colour!,
    keptDate: DarkColours.lifecontextDate.colour!,
    keptDelete: StandIns.keptDeleteDark,
    tagTop: DarkColours.tagDream.colour!,
    tagBottom: DarkColours.tagDream.colourEnd!,
    tagText: DarkColours.tagDream.text!,
    filledTop: DarkColours.buttonFilled.colour!,
    filledBottom: DarkColours.buttonFilled.colourEnd!,
    filledText: DarkColours.buttonFilled.text!,
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
      rowBorder: c(rowBorder, other.rowBorder),
      keptTop: c(keptTop, other.keptTop),
      keptBottom: c(keptBottom, other.keptBottom),
      keptBorder: c(keptBorder, other.keptBorder),
      keptText: c(keptText, other.keptText),
      keptDate: c(keptDate, other.keptDate),
      keptDelete: c(keptDelete, other.keptDelete),
      tagTop: c(tagTop, other.tagTop),
      tagBottom: c(tagBottom, other.tagBottom),
      tagText: c(tagText, other.tagText),
      filledTop: c(filledTop, other.filledTop),
      filledBottom: c(filledBottom, other.filledBottom),
      filledText: c(filledText, other.filledText),
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
