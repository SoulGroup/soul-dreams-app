// The soft dark shade behind a night's date over any painting (D113), so the
// date reads at 4.5 to 1 or better over every painting, in a row and in the
// header; the painted gradient has none. Proved on real pixels: each
// painting of the set (D147) is drawn with the shade, and every pixel where
// the date stands is measured against the date's colour.
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/pages/night_art.dart';

double _linear(int c) {
  final v = c / 255;
  return v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
}

double _luminance(int r, int g, int b) => 0.2126 * _linear(r) + 0.7152 * _linear(g) + 0.0722 * _linear(b);

double _contrast(double a, double b) => (max(a, b) + 0.05) / (min(a, b) + 0.05);

void main() {
  final over = NightArt.over;
  final overLuminance = _luminance((over.r * 255).round(), (over.g * 255).round(), (over.b * 255).round());
  const key = Key('picture');

  /// A picture [w] by [h] with a date's box [dw] by [dh] at [at], shade or
  /// not, drawn to pixels; the lowest contrast in the date's box, and the
  /// pixel at [probe].
  Future<({double lowest, int probe, double Function(int, int) light})> measure(
    WidgetTester tester,
    NightLook look, {
    required Size size,
    required Size date,
    required Offset at,
    required Offset probe,
    bool shade = true,
  }) async {
    final box = SizedBox(width: date.width, height: date.height);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            key: key,
            child: SizedBox.fromSize(
              size: size,
              child: NightArt(
                look,
                child: Stack(
                  children: [Positioned(left: at.dx, top: at.dy, child: shade ? DateShade.over(look, box) : box)],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // The painting's file decoded before the pixels are read.
    await tester.runAsync(() async {
      for (final e in find.byType(Image).evaluate()) {
        await precacheImage((e.widget as Image).image, e);
      }
    });
    await tester.pump();
    late ByteData data;
    late int width;
    await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
      final image = await boundary.toImage();
      width = image.width;
      data = (await image.toByteData())!;
    });
    int at4(int x, int y) => (y * width + x) * 4;
    var lowest = double.infinity;
    for (var y = at.dy.floor(); y < (at.dy + date.height).ceil(); y++) {
      for (var x = at.dx.floor(); x < (at.dx + date.width).ceil(); x++) {
        final i = at4(x, y);
        final l = _luminance(data.getUint8(i), data.getUint8(i + 1), data.getUint8(i + 2));
        lowest = min(lowest, _contrast(overLuminance, l));
      }
    }
    final p = at4(probe.dx.round(), probe.dy.round());
    double light(int x, int y) {
      final i = at4(x, y);
      return _luminance(data.getUint8(i), data.getUint8(i + 1), data.getUint8(i + 2));
    }

    return (lowest: lowest, probe: data.getUint32(p), light: light);
  }

  // A row: 330 by 64, the date centred. The header: 390 by 287 (the status
  // bar's 47 and the 240), the date at the foot. The boxes are the date's
  // text with room to spare.
  const row = (size: Size(330, 64), date: Size(80, 24), at: Offset(125, 20), probe: Offset(3, 32));
  const header = (size: Size(390, 287), date: Size(150, 46), at: Offset(120, 211), probe: Offset(3, 150));

  testWidgets('row: every painting, the date reads at 4.5 to 1', (tester) async {
    for (var i = 0; i < NightArt.paintings; i++) {
      final m = await measure(tester, Painting(i), size: row.size, date: row.date, at: row.at, probe: row.probe);
      expect(m.lowest, greaterThanOrEqualTo(4.5), reason: 'painting $i');
    }
  });

  testWidgets('header: every painting, the date reads at 4.5 to 1', (tester) async {
    for (var i = 0; i < NightArt.paintings; i++) {
      final m = await measure(tester, Painting(i), size: header.size, date: header.date, at: header.at, probe: header.probe);
      expect(m.lowest, greaterThanOrEqualTo(4.5), reason: 'painting $i');
    }
  });

  testWidgets('the shade is soft and local, far from the date', (tester) async {
    for (var i = 0; i < NightArt.paintings; i++) {
      final shaded = await measure(tester, Painting(i), size: row.size, date: row.date, at: row.at, probe: row.probe);
      final bare =
          await measure(tester, Painting(i), size: row.size, date: row.date, at: row.at, probe: row.probe, shade: false);
      expect(shaded.probe, bare.probe, reason: 'painting $i');
    }
  });

  // Soft: from far outside to the date's edge the painting darkens
  // gradually, through several steps, not at one hard edge.
  testWidgets('the shade fades in towards the date, in steps', (tester) async {
    // Over the lightest painting where the date stands, so the shade shows.
    var look = const Painting(0);
    var light = 0.0;
    for (var i = 0; i < NightArt.paintings; i++) {
      final m =
          await measure(tester, Painting(i), size: row.size, date: row.date, at: row.at, probe: row.probe, shade: false);
      final y = (row.at.dy + row.date.height / 2).round();
      final l = m.light(row.at.dx.round(), y);
      if (l > light) {
        light = l;
        look = Painting(i);
      }
    }
    final shaded = await measure(tester, look, size: row.size, date: row.date, at: row.at, probe: row.probe);
    final bare = await measure(tester, look, size: row.size, date: row.date, at: row.at, probe: row.probe, shade: false);
    final y = (row.at.dy + row.date.height / 2).round();
    double dark(int x) => 1 - shaded.light(x, y) / bare.light(x, y);
    final from = (row.at.dx - DateShade.reach - 2 * DateShade.softness).round();
    final levels = [for (var x = from; x <= row.at.dx.round(); x += 2) dark(x)];
    expect(levels.first, lessThan(0.05));
    expect(levels.last, greaterThan(0.5));
    // Never darker as it goes in, and with several steps between the ends.
    for (var i = 1; i < levels.length; i++) {
      expect(levels[i], greaterThanOrEqualTo(levels[i - 1] - 0.01));
    }
    expect(levels.where((d) => d > 0.1 && d < 0.9).length, greaterThanOrEqualTo(4));
  });

  testWidgets('without the shade, a light painting would fail the same test', (tester) async {
    // The measure bites: the lightest painting's date, bare, is under 4.5 to 1.
    var worst = double.infinity;
    for (var i = 0; i < NightArt.paintings; i++) {
      final m =
          await measure(tester, Painting(i), size: row.size, date: row.date, at: row.at, probe: row.probe, shade: false);
      worst = min(worst, m.lowest);
    }
    expect(worst, lessThan(4.5));
  });

  testWidgets('a painting is shaded; the painted gradient is not', (tester) async {
    const text = SizedBox(width: 10, height: 10);
    for (var i = 0; i < NightArt.paintings; i++) {
      await tester.pumpWidget(DateShade.over(Painting(i), text));
      expect(find.byType(DateShade), findsOneWidget);
    }
    await tester.pumpWidget(DateShade.over(const PaintedGradient(), text));
    expect(find.byType(DateShade), findsNothing);
  });

  testWidgets('the shade adds no room: it takes its child\'s size', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: DateShade(child: SizedBox(width: 80, height: 24))),
      ),
    );
    expect(tester.getSize(find.byType(DateShade)), const Size(80, 24));
  });

  testWidgets('the shade is heard as nothing', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: DateShade(child: Text('26/06/09'))),
      ),
    );
    final heard = tester.semantics.simulatedAccessibilityTraversal().map((n) => n.label).where((l) => l.isNotEmpty);
    expect(heard, ['26/06/09']);
    handle.dispose();
  });

  // What stands over a picture never paints outside it: the shade's soft
  // edge ends at the picture's.
  testWidgets('the picture clips what stands over it', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: 100,
              height: 100,
              child: ColoredBox(
                color: const Color(0xFFFFFFFF),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: NightArt(
                      const PaintedGradient(),
                      child: OverflowBox(
                        alignment: Alignment.topLeft,
                        maxHeight: 100,
                        child: ColoredBox(color: Color(0xFFFF0000), child: SizedBox(width: 100, height: 100)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    late ByteData data;
    await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
      final image = await boundary.toImage();
      data = (await image.toByteData())!;
    });
    int pixel(int x, int y) => data.getUint32((y * 100 + x) * 4);
    expect(pixel(50, 70), 0xFFFFFFFF);
  });
}
