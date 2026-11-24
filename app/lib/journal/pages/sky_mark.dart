// The sun and the moon above the journal's greeting (D112), drawn in code
// until the founder supplies the images: a disc with eight rays, and a
// crescent. No file, no package, no words; heard as nothing.
import 'dart:math';

import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../sky.dart';

class SkyMark extends StatelessWidget {
  const SkyMark(this.sky, {super.key, this.size = StandIns.skyMark, this.moon});

  final Sky sky;

  /// Its size: the journal's, unless given (Settings' quick toggle).
  final Size size;

  /// The moon's colour, unless given (the quick toggle's, D125 item 7).
  /// Unless given, it is the light colour over the dark theme, and over the
  /// light theme the dark theme's page colour (dark blue, D151), which a
  /// light colour would not show against.
  final Color? moon;

  /// How many rays the sun has.
  static const rays = 8;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final colour = moon ?? (light ? DarkColours.page.colour! : StandIns.moonColour);
    return ExcludeSemantics(child: SizedBox.fromSize(size: size, child: CustomPaint(painter: _SkyPainter(sky, colour))));
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter(this.sky, this.moon);

  final Sky sky;
  final Color moon;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final u = min(size.width, size.height);
    switch (sky) {
      case Sky.sun:
        final paint = Paint()
          ..color = StandIns.sunColour
          ..style = PaintingStyle.stroke
          ..strokeWidth = u * 0.06
          ..strokeCap = StrokeCap.round;
        canvas.drawCircle(c, u * 0.24, Paint()..color = StandIns.sunColour);
        for (var i = 0; i < SkyMark.rays; i++) {
          final a = i * 2 * pi / SkyMark.rays;
          final d = Offset(cos(a), sin(a));
          canvas.drawLine(c + d * (u * 0.34), c + d * (u * 0.48), paint);
        }
      case Sky.moon:
        // A disc with a second one taken from it, leaving a crescent.
        final disc = Path()..addOval(Rect.fromCircle(center: c, radius: u * 0.42));
        final bite = Path()..addOval(Rect.fromCircle(center: c + Offset(u * 0.2, -u * 0.08), radius: u * 0.36));
        canvas.drawPath(Path.combine(PathOperation.difference, disc, bite), Paint()..color = moon);
    }
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.sky != sky || old.moon != moon;
}
