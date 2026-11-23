// A night's picture (D110; head's messages 24 and 25): the painted gradient
// for an unread night, or one painting of the curated set shipped in the
// app for a read one (D147): sixty paintings in `assets/paintings/`, each
// fingerprinted (G2) and carrying the invisible AI tag (D123), shown to
// cover its box from the middle, so a row shows a thin band and the header a
// wide crop. The gradient lies beneath, so nothing flashes while a painting
// loads. The gradient's colours and the text over a picture are stand-ins
// until Product sets them (P13): the dark theme's bubble gradient and text,
// in both themes. Heard as nothing: decoration. Also here: the night sky
// inside New Dream (D112; D147 item 3, the set's strip) and the soft shade
// behind a date over a painting (D113), a stand-in.
import 'package:flutter/widgets.dart';

import '../../design/tokens.g.dart';
import '../night_look.dart';

class NightArt extends StatelessWidget {
  const NightArt(this.look, {super.key, this.child});

  final NightLook look;

  /// What stands over the picture (the date), if anything.
  final Widget? child;

  /// How many paintings the set holds (D147).
  static const paintings = 60;

  /// Painting [index]'s file: `01.jpg` to `60.jpg`.
  static String asset(int index) {
    final number = (index + 1).toString().padLeft(2, '0');
    return 'assets/paintings/$number.jpg';
  }

  /// The painted gradient, top to foot.
  static final gradient = [DarkColours.surface.colour!, DarkColours.surface.colourEnd!];

  /// The colour of words over a picture.
  static final over = DarkColours.text.colour!;

  // The gradient and the painting add nothing a screen reader hears; what
  // stands over them is heard as itself. What stands over the picture is
  // clipped to it, so a soft edge (the date's shade) never runs past the
  // picture's own.
  @override
  Widget build(BuildContext context) {
    final look = this.look;
    return ClipRect(
      // The box's own constraints pass to what stands over it, as before
      // the set: a row keeps its least height.
      child: Stack(
        alignment: Alignment.topLeft,
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(child: CustomPaint(painter: _GradientPainter())),
          if (look is Painting) Positioned.fill(child: _Cover(asset(look.index))),
          child ?? const SizedBox.expand(),
        ],
      ),
    );
  }
}

/// An image of the set covering its box from the middle, decoded no larger
/// than the box needs on this screen, and silent.
class _Cover extends StatelessWidget {
  const _Cover(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final width = (box.maxWidth * MediaQuery.devicePixelRatioOf(context)).ceil();
      return Image(
        image: ResizeImage.resizeIfNeeded(width > 0 ? width : null, null, AssetImage(asset)),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        excludeFromSemantics: true,
        gaplessPlayback: true,
      );
    },
  );
}

/// A soft dark shade behind a night's date over a painting (D113), so the
/// date reads at 4.5 to 1 or better over any of them: a blurred rounded
/// shape a little larger than the date, painted around it and adding no
/// room. The painted gradient needs none. A stand-in until the founder's set
/// is in, and re-proved with it (the test measures real pixels).
class DateShade extends StatelessWidget {
  const DateShade({super.key, required this.child});

  final Widget child;

  /// The date with its shade over a painting, or the date alone over the
  /// painted gradient.
  static Widget over(NightLook look, Widget date) => look is Painting ? DateShade(child: date) : date;

  /// The shade's colour and strength, how far its centre extends past the
  /// date, and how soft its edge is (the shade is full where the date stands
  /// when the reach is at least two and a half times the softness).
  static const colour = Color(0xFF0B0820);
  static const double alpha = 0.66;
  static const double reach = 22;
  static const double softness = 8;

  // Heard as nothing; the date is.
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _ShadePainter(), child: child);
}

class _ShadePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shade = RRect.fromRectAndRadius(
      (Offset.zero & size).inflate(DateShade.reach),
      const Radius.circular(DateShade.reach),
    );
    canvas.drawRRect(
      shade,
      Paint()
        ..color = DateShade.colour.withValues(alpha: DateShade.alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, DateShade.softness),
    );
  }

  @override
  bool shouldRepaint(_ShadePainter old) => false;
}

/// New Dream's night sky (D112; D147 item 3): the set's strip covering the
/// pill from the middle, over the painted gradient. Heard as nothing, like
/// the picture.
class NightSky extends StatelessWidget {
  const NightSky({super.key, this.child});

  /// What stands over the sky (New Dream's words).
  final Widget? child;

  /// The strip's file.
  static const asset = 'assets/paintings/sky.jpg';

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.topLeft,
    fit: StackFit.passthrough,
    children: [
      Positioned.fill(child: CustomPaint(painter: _GradientPainter())),
      const Positioned.fill(child: _Cover(asset)),
      child ?? const SizedBox.expand(),
    ],
  );
}

/// The painted gradient, top to foot.
class _GradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final box = Offset.zero & size;
    canvas.drawRect(
      box,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: NightArt.gradient,
        ).createShader(box),
    );
  }

  @override
  bool shouldRepaint(_GradientPainter old) => false;
}
