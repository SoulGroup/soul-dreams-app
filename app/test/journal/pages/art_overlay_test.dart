// What darkens a painting under a night's date (D149, replacing D113's soft
// shade): a row's whole picture under #000000 at 30%, a night's header with
// its bottom half fading from #000000 at 100% at its foot through 70% at the
// fade's middle to 0% at its top, New Dream's sky under the row's 30%; the
// painted gradient has none. The date reads at 4.5 to 1 or better over every
// painting, proved on real pixels (the set, D147): each painting is drawn
// with its overlay and every pixel where the date stands is measured against
// the date's colour. A painting under 4.5 is listed with its contrast; the
// overlay and this measure are never changed for it.
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

/// Where a date stands in a picture: the picture's size, the date's box, and
/// where its box is.
typedef _Spot = ({Size size, Size date, Offset at});

// A row: 330 by 64, the date centred. The header: 390 by 287 (the status
// bar's 47 and the 240), the date at the foot. The boxes are the date's
// text with room to spare.
const _Spot _row = (size: Size(330, 64), date: Size(80, 24), at: Offset(125, 20));
const _Spot _header = (size: Size(390, 287), date: Size(150, 46), at: Offset(120, 211));

const _key = Key('picture');

/// [widget] in a [size] box, its images decoded, drawn to pixels.
Future<({ByteData data, int width})> _draw(WidgetTester tester, Widget widget, Size size) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: RepaintBoundary(key: _key, child: SizedBox.fromSize(size: size, child: widget)),
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
    final image = await tester.renderObject<RenderRepaintBoundary>(find.byKey(_key)).toImage();
    width = image.width;
    data = (await image.toByteData())!;
  });
  return (data: data, width: width);
}

void main() {
  final over = NightArt.over;
  final overLuminance = _luminance((over.r * 255).round(), (over.g * 255).round(), (over.b * 255).round());
  const folder = 'assets/paintings/';

  /// The lowest contrast of the date's colour against any pixel in the date's
  /// box, over [look] with [overlay].
  Future<double> lowest(WidgetTester tester, NightLook look, _Spot spot, ArtOverlay? overlay) async {
    final box = SizedBox(width: spot.date.width, height: spot.date.height);
    final art = await _draw(
      tester,
      NightArt(
        look,
        overlay: overlay,
        child: Stack(children: [Positioned(left: spot.at.dx, top: spot.at.dy, child: box)]),
      ),
      spot.size,
    );
    var worst = double.infinity;
    for (var y = spot.at.dy.floor(); y < (spot.at.dy + spot.date.height).ceil(); y++) {
      for (var x = spot.at.dx.floor(); x < (spot.at.dx + spot.date.width).ceil(); x++) {
        final i = (y * art.width + x) * 4;
        final l = _luminance(art.data.getUint8(i), art.data.getUint8(i + 1), art.data.getUint8(i + 2));
        worst = min(worst, _contrast(overLuminance, l));
      }
    }
    return worst;
  }

  /// Each painting under 4.5 to 1, with its file and its contrast.
  Future<List<String>> under(WidgetTester tester, _Spot spot, ArtOverlay? overlay) async {
    final listed = <String>[];
    for (var i = 0; i < NightArt.paintings; i++) {
      final c = await lowest(tester, Painting(i), spot, overlay);
      if (c < 4.5) {
        listed.add('${NightArt.asset(i).substring(folder.length)}: ${c.toStringAsFixed(2)}');
      }
    }
    return listed;
  }

  testWidgets('row: every painting, the date reads at 4.5 to 1', (tester) async {
    expect(await under(tester, _row, ArtOverlay.row), isEmpty);
  });

  testWidgets('header: every painting, the date reads at 4.5 to 1', (tester) async {
    expect(await under(tester, _header, ArtOverlay.header), isEmpty);
  });

  testWidgets('without the overlay, a light painting would fail the same test', (tester) async {
    // The measure bites: some painting's date, bare, is under 4.5 to 1.
    expect(await under(tester, _row, null), isNotEmpty);
  });

  // Every channel of every pixel under the overlay, against the picture
  // without it: [bare] times [keep] (what the overlay leaves), within [slack].
  int off(ByteData bare, ByteData dim, int width, {required double Function(int y) keep, int slack = 2, int step = 1}) {
    var wrong = 0;
    final rows = bare.lengthInBytes ~/ 4 ~/ width;
    for (var y = 0; y < rows; y++) {
      for (var x = 0; x < width; x += step) {
        final i = (y * width + x) * 4;
        for (var c = 0; c < 3; c++) {
          final want = bare.getUint8(i + c) * keep(y);
          wrong += (dim.getUint8(i + c) - want).abs() > slack ? 1 : 0;
        }
        wrong += dim.getUint8(i + 3) == 255 ? 0 : 1;
      }
    }
    return wrong;
  }

  testWidgets('a row: every painting under #000000 at 30%', (tester) async {
    for (var i = 0; i < NightArt.paintings; i++) {
      final bare = await _draw(tester, NightArt(Painting(i)), _row.size);
      final dim = await _draw(tester, NightArt(Painting(i), overlay: ArtOverlay.row), _row.size);
      expect(off(bare.data, dim.data, bare.width, keep: (_) => 0.7), 0, reason: 'painting $i');
    }
  });

  // Stops from the bottom edge: 100% there, 70% at the fade's middle, 0% at
  // its top, which is the header's middle. [keep] is what is left at row y.
  double headerKeep(int y) {
    final d = (_header.size.height - (y + 0.5)) / (_header.size.height / 2);
    if (d >= 1) return 1;
    final alpha = d <= 0.5 ? 1 - 0.6 * d : 0.7 - 1.4 * (d - 0.5);
    return 1 - alpha;
  }

  testWidgets('a header: its bottom half fades to black', (tester) async {
    for (final i in [0, 9, 19, 29, 44, 59]) {
      final bare = await _draw(tester, NightArt(Painting(i)), _header.size);
      final fade = await _draw(tester, NightArt(Painting(i), overlay: ArtOverlay.header), _header.size);
      expect(off(bare.data, fade.data, bare.width, keep: headerKeep, slack: 3, step: 7), 0, reason: 'painting $i');
    }
  });

  testWidgets('the gradient has no overlay, in a row or a header', (tester) async {
    for (final spot in [_row, _header]) {
      final bare = await _draw(tester, const NightArt(PaintedGradient()), spot.size);
      for (final overlay in ArtOverlay.values) {
        final art = await _draw(tester, NightArt(const PaintedGradient(), overlay: overlay), spot.size);
        expect(art.data.buffer.asUint8List(), bare.data.buffer.asUint8List(), reason: '$overlay');
      }
    }
  });

  testWidgets("New Dream's sky: under the row's 30%", (tester) async {
    const size = Size(200, 50);
    final width = (size.width * tester.view.devicePixelRatio).ceil();
    // The strip as NightSky shows it, without the overlay.
    final bare = await _draw(
      tester,
      Image(
        image: ResizeImage.resizeIfNeeded(width, null, const AssetImage(NightSky.asset)),
        fit: BoxFit.cover,
        alignment: Alignment.center,
      ),
      size,
    );
    final dim = await _draw(tester, const NightSky(), size);
    expect(off(bare.data, dim.data, bare.width, keep: (_) => 0.7), 0);
  });

  testWidgets('the overlays are heard as nothing; the date is', (tester) async {
    final handle = tester.ensureSemantics();
    for (final overlay in ArtOverlay.values) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: NightArt(const Painting(2), overlay: overlay, child: const Text('26/06/09')),
        ),
      );
      final heard = tester.semantics.simulatedAccessibilityTraversal().map((n) => n.label).where((l) => l.isNotEmpty);
      expect(heard, ['26/06/09'], reason: '$overlay');
    }
    handle.dispose();
  });

  // What stands over a picture never paints outside it.
  testWidgets('the picture clips what stands over it', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            key: _key,
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
      final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(_key));
      final image = await boundary.toImage();
      data = (await image.toByteData())!;
    });
    int pixel(int x, int y) => data.getUint32((y * 100 + x) * 4);
    expect(pixel(50, 70), 0xFFFFFFFF);
  });
}
