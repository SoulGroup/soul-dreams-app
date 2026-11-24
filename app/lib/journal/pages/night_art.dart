// A night's picture (D110; head's messages 24 and 25): the painted gradient
// for an unread night, or one painting of the curated set shipped in the
// app for a read one (D147): sixty paintings in `assets/paintings/`, each
// fingerprinted (G2) and carrying the invisible AI tag (D123), shown to
// cover its box from the middle, so a row shows a thin band and the header a
// wide crop. The gradient lies beneath, so nothing flashes while a painting
// loads. The gradient's colours and the text over a picture are stand-ins
// until Product sets them (P13): the dark theme's bubble gradient and text,
// in both themes. Heard as nothing: decoration. Also here: what darkens a
// painting under a night's date (D149, in place of D113's soft shade): a
// row's whole picture under #000000 at 30%, a header's bottom half fading to
// #000000, and the night sky inside New Dream (D112; D147 item 3, the set's
// strip) under the row's 30%.
import 'package:flutter/widgets.dart';

import '../../design/tokens.g.dart';
import '../night_look.dart';

/// What darkens a painting under a night's date (D149): a row's whole
/// picture, or a header's bottom half. The painted gradient has neither.
enum ArtOverlay { row, header }

class NightArt extends StatelessWidget {
  const NightArt(this.look, {super.key, this.overlay, this.child});

  final NightLook look;

  /// What darkens the picture under [child], if it is a painting.
  final ArtOverlay? overlay;

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

  /// The overlays' colour (D149): #000000. A row's, and New Dream's sky's,
  /// is this at 30% over the whole picture.
  static const overlayColour = Color(0xFF000000);
  static const double rowOverlayAlpha = 0.3;

  /// A header's: this fading over the picture's bottom half, from the bottom
  /// edge up: 100% there, 70% at the fade's middle, 0% at its top.
  static const headerFadeAlphas = <double>[1.0, 0.7, 0.0];
  static const headerFadeStops = <double>[0.0, 0.5, 1.0];
  static const double headerFadeShare = 0.5;

  // The gradient and the painting add nothing a screen reader hears; what
  // stands over them is heard as itself. What stands over the picture is
  // clipped to it, so nothing runs past the picture's own edge.
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
          if (look is Painting && overlay != null)
            Positioned.fill(
              child: switch (overlay!) {
                ArtOverlay.row => const _Dim(),
                ArtOverlay.header => const _Fade(),
              },
            ),
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

/// #000000 at 30% over the whole picture (D149): a row's, and New Dream's
/// sky's. Heard as nothing.
class _Dim extends StatelessWidget {
  const _Dim();

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: NightArt.overlayColour.withValues(alpha: NightArt.rowOverlayAlpha));
}

/// A header's fade (D149): #000000 over the bottom half of the picture,
/// 100% at the very bottom, 70% at the fade's middle, 0% at its top. Heard
/// as nothing.
class _Fade extends StatelessWidget {
  const _Fade();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: FractionallySizedBox(
      widthFactor: 1,
      heightFactor: NightArt.headerFadeShare,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [for (final a in NightArt.headerFadeAlphas) NightArt.overlayColour.withValues(alpha: a)],
            stops: NightArt.headerFadeStops,
          ),
        ),
      ),
    ),
  );
}

/// New Dream's night sky (D112; D147 item 3): the set's strip covering the
/// pill from the middle, over the painted gradient, under the row's 30%
/// overlay (D149). Heard as nothing, like the picture.
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
      const Positioned.fill(child: _Dim()),
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
