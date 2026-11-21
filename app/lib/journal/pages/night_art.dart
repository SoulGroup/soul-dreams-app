// A night's picture (D110; head's messages 24 and 25): the painted gradient
// for an unread night, or one painting of the set shipped in the app for a
// read one. The curated set (about 60, the founder's) is not filed yet, so a
// few placeholder paintings stand in its place, drawn here in plain layered
// colour: no file, no package, no words. When the set comes, it replaces
// `paintings` and the placeholders; nothing else changes. The gradient's
// colours and the text over a picture are stand-ins until Product sets them
// (P13): the dark theme's bubble gradient and text, in both themes. Heard
// as nothing: decoration.
import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../design/tokens.g.dart';
import '../night_look.dart';

/// One placeholder painting: a sky from top to foot, a soft light in it at
/// [lightX] across, a far ridge and a near one.
typedef _Placeholder = ({Color top, Color foot, Color light, double lightX, Color far, Color near});

const _placeholders = <_Placeholder>[
  // Dusk.
  (top: Color(0xFF2E2A5C), foot: Color(0xFF8C6A9E), light: Color(0xFFF2D8A7), lightX: 0.72, far: Color(0xFF4A3F6B), near: Color(0xFF231E3D)),
  // Dawn.
  (top: Color(0xFF6E7FA8), foot: Color(0xFFE9B9A0), light: Color(0xFFFFF1D6), lightX: 0.28, far: Color(0xFF8A7F9C), near: Color(0xFF4F4866)),
  // The sea.
  (top: Color(0xFF1F4E5F), foot: Color(0xFF7FB3B0), light: Color(0xFFE8F1E4), lightX: 0.6, far: Color(0xFF2F6B6E), near: Color(0xFF173B45)),
  // The forest.
  (top: Color(0xFF34503A), foot: Color(0xFFB7B98A), light: Color(0xFFF4E9C1), lightX: 0.4, far: Color(0xFF3F5E3F), near: Color(0xFF1E3322)),
  // The night.
  (top: Color(0xFF0E1433), foot: Color(0xFF3B4A7A), light: Color(0xFFDCE3F2), lightX: 0.8, far: Color(0xFF26305A), near: Color(0xFF111833)),
];

class NightArt extends StatelessWidget {
  const NightArt(this.look, {super.key, this.child});

  final NightLook look;

  /// What stands over the picture (the date), if anything.
  final Widget? child;

  /// How many paintings the set holds: the placeholders, for now.
  static const paintings = 5;

  /// The painted gradient, top to foot.
  static final gradient = [DarkColours.surface.colour!, DarkColours.surface.colourEnd!];

  /// The colour of words over a picture.
  static final over = DarkColours.text.colour!;

  /// The top of painting [index]'s sky (each painting's own).
  static Color sky(int index) => _placeholders[index].top;

  // A painter adds nothing a screen reader hears; what stands over it is
  // heard as itself.
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ArtPainter(look), child: child ?? const SizedBox.expand());
}

class _ArtPainter extends CustomPainter {
  _ArtPainter(this.look);

  final NightLook look;

  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    canvas.save();
    canvas.clipRect(box);
    switch (look) {
      case PaintedGradient():
        canvas.drawRect(box, Paint()..shader = _vertical(box, NightArt.gradient));
      case Painting(:final index):
        final p = _placeholders[index];
        canvas.drawRect(box, Paint()..shader = _vertical(box, [p.top, p.foot]));
        final r = min(size.width, size.height) * 0.22;
        canvas.drawCircle(
          Offset(size.width * p.lightX, size.height * 0.38),
          r,
          Paint()
            ..color = p.light.withValues(alpha: 0.85)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.35),
        );
        canvas.drawPath(_ridge(size, 0.66, 0.06, 1.3), Paint()..color = p.far);
        canvas.drawPath(_ridge(size, 0.8, 0.05, 2.1), Paint()..color = p.near);
    }
    canvas.restore();
  }

  static Shader _vertical(Rect box, List<Color> colours) =>
      LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colours).createShader(box);

  // A gentle ridge across the width at [at] of the height, rising and
  // falling by [swell] of the height, [waves] times.
  static Path _ridge(Size size, double at, double swell, double waves) {
    final path = Path()..moveTo(0, size.height);
    const steps = 24;
    for (var i = 0; i <= steps; i++) {
      final x = size.width * i / steps;
      final y = size.height * (at + swell * sin(i / steps * waves * pi));
      path.lineTo(x, y);
    }
    return path
      ..lineTo(size.width, size.height)
      ..close();
  }

  @override
  bool shouldRepaint(_ArtPainter old) => old.look != look;
}
