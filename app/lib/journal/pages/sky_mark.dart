// The sun and the moon above the journal's greeting (D112), drawn in code
// until the founder supplies the images: a disc with eight rays, and a
// crescent. No file, no package, no words; heard as nothing.
import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../design/stand_ins.dart';
import '../sky.dart';

class SkyMark extends StatelessWidget {
  const SkyMark(this.sky, {super.key, this.size = StandIns.skyMark});

  final Sky sky;

  /// Its size: the journal's, unless given (Settings' quick toggle).
  final Size size;

  /// How many rays the sun has.
  static const rays = 8;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.fromSize(size: size, child: CustomPaint(painter: _SkyPainter(sky))),
  );
}

class _SkyPainter extends CustomPainter {
  _SkyPainter(this.sky);

  final Sky sky;

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
        canvas.drawPath(Path.combine(PathOperation.difference, disc, bite), Paint()..color = StandIns.moonColour);
    }
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.sky != sky;
}
