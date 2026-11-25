// A night's picture (D110; head's messages 24 and 25): the painted gradient,
// or one painting of the curated set (D147) covering its box from the
// middle over the gradient; heard as nothing; the same in both themes. And
// New Dream's sky, the set's strip (D112; D147 item 3).
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/pages/night_art.dart';

void main() {
  Future<RenderObject> pump(WidgetTester tester, NightLook look) async {
    await tester.pumpWidget(Center(child: SizedBox(width: 300, height: 64, child: NightArt(look))));
    return tester.renderObject(find.descendant(of: find.byType(NightArt), matching: find.byType(CustomPaint)).first);
  }

  /// The one image in the tree, as drawn: its widget and its file.
  ({Image image, ResizeImage resized, String file}) shown(WidgetTester tester) {
    final image = tester.widget<Image>(find.byType(Image));
    final resized = image.image as ResizeImage;
    return (image: image, resized: resized, file: (resized.imageProvider as AssetImage).assetName);
  }

  test('sixty paintings in the set, each its own file', () {
    expect(NightArt.paintings, 60);
    expect(NightArt.asset(0), 'assets/paintings/01.jpg');
    expect(NightArt.asset(9), 'assets/paintings/10.jpg');
    expect(NightArt.asset(59), 'assets/paintings/60.jpg');
    expect({for (var i = 0; i < NightArt.paintings; i++) NightArt.asset(i)}, hasLength(60));
  });

  test("the gradient and the words over it: from the dark theme", () {
    expect(NightArt.gradient, [DarkColours.surface.colour, DarkColours.surface.colourEnd]);
    expect(NightArt.over, DarkColours.text.colour);
  });

  testWidgets('the gradient fills its box, and nothing else is drawn', (tester) async {
    final art = await pump(tester, const PaintedGradient());
    expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('each painting covers its box from the middle', (tester) async {
    final ratio = tester.view.devicePixelRatio;
    for (var i = 0; i < NightArt.paintings; i++) {
      final art = await pump(tester, Painting(i));
      expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
      final s = shown(tester);
      expect(s.file, NightArt.asset(i));
      expect(s.image.fit, BoxFit.cover);
      expect(s.image.alignment, Alignment.center);
      // Decoded no wider than the box on this screen.
      expect(s.resized.width, (300 * ratio).ceil());
      expect(s.resized.height, isNull);
      expect(tester.getRect(find.byType(Image)), tester.getRect(find.byType(NightArt)));
    }
  });

  testWidgets('the picture is silent; what stands over it is heard', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, const Painting(0));
    expect(tester.getSemantics(find.byType(NightArt)).label, isEmpty);
    expect(shown(tester).image.excludeFromSemantics, isTrue);
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: NightArt(Painting(1), child: Text('19/11/2026')),
    ));
    expect(find.bySemanticsLabel('19/11/2026'), findsOneWidget);
    handle.dispose();
  });

  // D162: a night's own painting, from its bytes, as the set's are drawn.
  testWidgets("a night's own painting covers its box, silent, from its bytes", (tester) async {
    final handle = tester.ensureSemantics();
    final own = File('assets/paintings/01.jpg').readAsBytesSync();
    final art = await pump(tester, PersonalPainting(own));
    expect(art, paints..rect(rect: const Rect.fromLTWH(0, 0, 300, 64)));
    final image = tester.widget<Image>(find.byType(Image));
    final resized = image.image as ResizeImage;
    expect(identical((resized.imageProvider as MemoryImage).bytes, own), isTrue);
    expect(image.fit, BoxFit.cover);
    expect(image.excludeFromSemantics, isTrue);
    expect(resized.width, (300 * tester.view.devicePixelRatio).ceil());
    expect(tester.getRect(find.byType(Image)), tester.getRect(find.byType(NightArt)));
    expect(tester.getSemantics(find.byType(NightArt)).label, isEmpty);
    // Darkened under a row's date as the set's paintings are (D149, D150).
    await tester.pumpWidget(Center(child: SizedBox(width: 300, height: 64, child: NightArt(PersonalPainting(own), overlay: ArtOverlay.row))));
    final dim = NightArt.overlayColour.withValues(alpha: NightArt.rowOverlayAlpha);
    expect(find.byWidgetPredicate((w) => w is ColoredBox && w.color == dim), findsOneWidget);
    handle.dispose();
  });

  // D112; D147 item 3: New Dream's night sky, the set's strip.
  group('the night sky inside New Dream', () {
    testWidgets("the sky: the set's strip, covering the pill", (tester) async {
      await tester.pumpWidget(Center(child: SizedBox(width: 200, height: 50, child: const NightSky())));
      final gradient = tester.renderObject(
        find.descendant(of: find.byType(NightSky), matching: find.byType(CustomPaint)).first,
      );
      expect(gradient, paints..rect(rect: const Rect.fromLTWH(0, 0, 200, 50)));
      final s = shown(tester);
      expect(s.file, 'assets/paintings/sky.jpg');
      expect(NightSky.asset, 'assets/paintings/sky.jpg');
      expect(s.image.fit, BoxFit.cover);
      expect(s.image.alignment, Alignment.center);
      expect(s.image.excludeFromSemantics, isTrue);
      expect(tester.getRect(find.byType(Image)), tester.getRect(find.byType(NightSky)));
    });

    testWidgets('the sky is silent; the words over it are heard', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr,
        child: NightSky(child: Text('one two')),
      ));
      expect(find.bySemanticsLabel('one two'), findsOneWidget);
      // The words alone are heard: no other labelled node in the page.
      final heard = tester.semantics.simulatedAccessibilityTraversal().map((n) => n.label).where((l) => l.isNotEmpty);
      expect(heard, ['one two']);
      handle.dispose();
    });
  });
}
