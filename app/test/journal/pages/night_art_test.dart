// A night's picture (D110; head's messages 24 and 25): the painted gradient,
// or one of the placeholder paintings in the curated set's place; heard as
// nothing; the same in both themes.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/pages/night_art.dart';

void main() {
  Future<RenderObject> pump(WidgetTester tester, NightLook look) async {
    await tester.pumpWidget(Center(child: SizedBox(width: 300, height: 64, child: NightArt(look))));
    return tester.renderObject(find.descendant(of: find.byType(NightArt), matching: find.byType(CustomPaint)));
  }

  test('a few placeholder paintings stand in the set', () {
    expect(NightArt.paintings, 5);
  });

  test("the gradient and the words over it: from the dark theme", () {
    expect(NightArt.gradient, [DarkColours.surface.colour, DarkColours.surface.colourEnd]);
    expect(NightArt.over, DarkColours.text.colour);
  });

  testWidgets('the gradient fills its box, and nothing else is drawn', (tester) async {
    final art = await pump(tester, const PaintedGradient());
    expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
    expect(art, isNot(paints..circle()));
  });

  testWidgets('each painting fills its box and draws its own light', (tester) async {
    for (var i = 0; i < NightArt.paintings; i++) {
      final art = await pump(tester, Painting(i));
      expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64))..circle());
    }
  });

  testWidgets('no two paintings alike', (tester) async {
    final skies = {for (var i = 0; i < NightArt.paintings; i++) NightArt.sky(i)};
    expect(skies, hasLength(NightArt.paintings));
  });

  testWidgets('the picture is silent; what stands over it is heard', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const Painting(0));
    expect(tester.getSemantics(find.byType(NightArt)).label, isEmpty);
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: NightArt(Painting(1), child: Text('19/11/2026')),
    ));
    expect(find.bySemanticsLabel('19/11/2026'), findsOneWidget);
    handle.dispose();
  });
}
