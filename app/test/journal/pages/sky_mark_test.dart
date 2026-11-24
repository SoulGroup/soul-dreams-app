// The sun and the moon above the greeting (D112), drawn in code until the
// founder supplies the images; heard as nothing.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/pages/sky_mark.dart';
import 'package:souldreams/journal/sky.dart';

void main() {
  Future<void> pump(WidgetTester tester, Sky sky, {Brightness theme = Brightness.dark}) => tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Theme(data: themeFor(theme), child: Center(child: SkyMark(sky))),
    ),
  );

  RenderObject painted(WidgetTester tester) =>
      tester.renderObject(find.descendant(of: find.byType(SkyMark), matching: find.byType(CustomPaint)).last);

  PaintPattern rays(int n) {
    final pattern = paints..circle(color: StandIns.sunColour);
    for (var i = 0; i < n; i++) {
      pattern.line(color: StandIns.sunColour);
    }
    return pattern;
  }

  testWidgets('the sun: a disc and eight rays, in its colour', (tester) async {
    await pump(tester, Sky.sun);
    expect(tester.getSize(find.byType(SkyMark)), StandIns.skyMark);
    expect(painted(tester), rays(8));
    expect(painted(tester), isNot(rays(9)));
  });

  testWidgets('the moon: a crescent, no disc and no rays', (tester) async {
    await pump(tester, Sky.moon);
    expect(painted(tester), paints..path(color: StandIns.moonColour));
    expect(painted(tester), isNot(paints..circle()));
    expect(painted(tester), isNot(paints..line()));
  });

  // D151 item 2: over a light background the moon is the dark theme's page
  // colour; over the dark theme it is as before. The sun is the same in both.
  testWidgets('the moon over the light theme is dark blue', (tester) async {
    await pump(tester, Sky.moon, theme: Brightness.light);
    expect(painted(tester), paints..path(color: DarkColours.page.colour));
    expect(painted(tester), isNot(paints..path(color: StandIns.moonColour)));
    await pump(tester, Sky.sun, theme: Brightness.light);
    expect(painted(tester), rays(8));
  });

  testWidgets('a moon given its colour keeps it, in either theme', (tester) async {
    for (final theme in Brightness.values) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: themeFor(theme),
            child: const Center(child: SkyMark(Sky.moon, moon: Color(0xFF123456))),
          ),
        ),
      );
      expect(painted(tester), paints..path(color: const Color(0xFF123456)), reason: '$theme');
    }
  });

  testWidgets('either mark is heard as nothing', (tester) async {
    final handle = tester.ensureSemantics();
    for (final sky in Sky.values) {
      await pump(tester, sky);
      final excluded = find.descendant(of: find.byType(SkyMark), matching: find.byType(ExcludeSemantics));
      expect(excluded, findsOneWidget);
      expect(tester.widget<ExcludeSemantics>(excluded).excluding, isTrue);
    }
    handle.dispose();
  });
}
