// The curated set as shipped (D147): sixty paintings and New Dream's sky in
// assets/paintings/, each a JPEG of its size with an sRGB profile and the
// invisible AI tag (D123), bundled by the pubspec; each one drawn, not the
// gradient; and New Dream's words readable over the sky, on real pixels.
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/language.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/pages/night_art.dart';
import 'package:souldreams/words/lines.g.dart';

const _folder = 'assets/paintings/';
const _tag = 'Iptc4xmpExt:DigitalSourceType="http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia"';

/// A JPEG's segments up to its scan: marker and data.
List<(int, Uint8List)> _segments(Uint8List b) {
  expect(b.length > 4 && b[0] == 0xff && b[1] == 0xd8, isTrue, reason: 'a JPEG starts so');
  final found = <(int, Uint8List)>[];
  var at = 2;
  while (true) {
    expect(b[at], 0xff);
    final marker = b[at + 1];
    final length = (b[at + 2] << 8) | b[at + 3];
    found.add((marker, Uint8List.sublistView(b, at + 4, at + 2 + length)));
    if (marker == 0xda) return found;
    at += 2 + length;
  }
}

bool _has(Uint8List data, List<int> part) {
  for (var i = 0; i + part.length <= data.length; i++) {
    var all = true;
    for (var j = 0; j < part.length && all; j++) {
      all = data[i + j] == part[j];
    }
    if (all) return true;
  }
  return false;
}

({int width, int height, bool srgb, bool tagged}) _read(String file) {
  final segments = _segments(File(file).readAsBytesSync());
  const frames = {0xc0, 0xc1, 0xc2, 0xc3, 0xc5, 0xc6, 0xc7, 0xc9, 0xca, 0xcb, 0xcd, 0xce, 0xcf};
  final frame = segments.firstWhere((s) => frames.contains(s.$1)).$2;
  final icc = segments.where((s) => s.$1 == 0xe2 && _has(s.$2.sublist(0, 12), 'ICC_PROFILE\u0000'.codeUnits));
  final srgb = icc.any((s) => _has(s.$2, 'sRGB'.codeUnits) || _has(s.$2, [0, 0x73, 0, 0x52, 0, 0x47, 0, 0x42]));
  final xmp = segments.where((s) => s.$1 == 0xe1 && _has(s.$2.sublist(0, 29), 'http://ns.adobe.com/xap/1.0/\u0000'.codeUnits));
  return (
    width: (frame[3] << 8) | frame[4],
    height: (frame[1] << 8) | frame[2],
    srgb: srgb,
    tagged: xmp.any((s) => _has(s.$2, _tag.codeUnits)),
  );
}

double _linear(int c) {
  final v = c / 255;
  return v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
}

double _luminance(int r, int g, int b) => 0.2126 * _linear(r) + 0.7152 * _linear(g) + 0.0722 * _linear(b);

void main() {
  final names = [for (var i = 0; i < NightArt.paintings; i++) NightArt.asset(i).substring(_folder.length)];

  test('the folder holds the set, the sky and the fingerprints', () {
    final files = Directory(_folder).listSync().map((e) => e.path.substring(_folder.length)).toSet();
    expect(files, {...names, 'sky.jpg', 'fingerprints.txt'});
    expect(names, hasLength(60));
  });

  test('each painting: 1280 x 960, sRGB, the AI tag', () {
    for (final name in names) {
      final r = _read(_folder + name);
      expect((r.width, r.height, r.srgb, r.tagged), (1280, 960, true, true), reason: name);
    }
  });

  test("New Dream's sky: 1200 x 336, sRGB, the AI tag", () {
    final r = _read(NightSky.asset);
    expect((r.width, r.height, r.srgb, r.tagged), (1200, 336, true, true));
  });

  test('the pubspec bundles the folder', () {
    expect(File('pubspec.yaml').readAsStringSync(), contains('\n  assets:\n    - assets/paintings/\n'));
  });

  const key = Key('picture');

  /// [widget] in a [size] box, its images decoded, drawn to pixels.
  Future<({ByteData data, int width})> draw(WidgetTester tester, Widget widget, Size size) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(key: key, child: SizedBox.fromSize(size: size, child: widget)),
        ),
      ),
    );
    await tester.runAsync(() async {
      for (final e in find.byType(Image).evaluate()) {
        await precacheImage((e.widget as Image).image, e);
      }
    });
    await tester.pump();
    late ByteData data;
    late int width;
    await tester.runAsync(() async {
      final image = await tester.renderObject<RenderRepaintBoundary>(find.byKey(key)).toImage();
      width = image.width;
      data = (await image.toByteData())!;
    });
    return (data: data, width: width);
  }

  testWidgets('each painting is drawn, not the gradient alone', (tester) async {
    const size = Size(330, 64);
    final bare = await draw(tester, const NightArt(PaintedGradient()), size);
    for (var i = 0; i < NightArt.paintings; i++) {
      final art = await draw(tester, NightArt(Painting(i)), size);
      var differ = 0;
      for (var p = 0; p < art.data.lengthInBytes; p += 4) {
        differ += art.data.getUint32(p) == bare.data.getUint32(p) ? 0 : 1;
      }
      expect(differ, greaterThan(art.data.lengthInBytes ~/ 4 ~/ 2), reason: 'painting $i');
    }
  });

  // The pill as the journal builds it: as wide as its words and its padding,
  // the words on the date's shade (D113). Every pixel where the words stand
  // against their colour, with a box of their size in their place.
  Future<double> wordsOverSky(WidgetTester tester, {required bool shade}) async {
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over))),
    ));
    final words = tester.getSize(find.byType(Text));
    final pad = StandIns.buttonPadding;
    final size = Size(words.width + pad.horizontal, words.height + pad.vertical);
    final box = SizedBox.fromSize(size: words);
    final sky = await draw(
      tester,
      NightSky(child: Padding(padding: pad, child: shade ? DateShade(child: box) : box)),
      size,
    );
    final over = NightArt.over;
    final colour = _luminance((over.r * 255).round(), (over.g * 255).round(), (over.b * 255).round());
    var lowest = double.infinity;
    for (var y = pad.top.floor(); y < (pad.top + words.height).ceil(); y++) {
      for (var x = pad.left.floor(); x < (pad.left + words.width).ceil(); x++) {
        final i = (y * sky.width + x) * 4;
        final l = _luminance(sky.data.getUint8(i), sky.data.getUint8(i + 1), sky.data.getUint8(i + 2));
        lowest = min(lowest, (max(colour, l) + 0.05) / (min(colour, l) + 0.05));
      }
    }
    return lowest;
  }

  testWidgets("New Dream's words read at 4.5 to 1 over the sky", (tester) async {
    expect(await wordsOverSky(tester, shade: true), greaterThanOrEqualTo(4.5));
  });

}
