// The journal pages' shared parts, from the palette, the type roles and
// the named stand-ins. No words here: each part is given its line.
import 'package:flutter/material.dart';

import '../../core/language.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../search.dart';

BoxDecoration _pill(Color top, Color bottom, [Color? border]) => BoxDecoration(
  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]),
  borderRadius: BorderRadius.circular(Spacing.radius),
  border: border == null ? null : Border.all(color: border),
);

/// A section label: a pill in the green gradient, white text, heard as a
/// heading (How the AI Appears §2.6, §8).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      header: true,
      child: DecoratedBox(
        decoration: _pill(p.sectionTop, p.sectionBottom),
        child: Padding(
          padding: StandIns.labelPadding,
          child: Text(text, style: TypeRoles.button.style(p.sectionText)),
        ),
      ),
    );
  }
}

/// A plain button (color.button).
class PlainButton extends StatelessWidget {
  const PlainButton(this.label, {super.key, required this.onPressed, this.icon});

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final style = TypeRoles.button.style(p.buttonText);
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: _pill(p.buttonTop, p.buttonBottom, p.buttonBorder),
          child: Padding(
            padding: StandIns.buttonPadding,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  ExcludeSemantics(
                    child: Icon(icon, size: style.fontSize! * 1.4, color: p.buttonText),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(label, style: style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Two pills at the foot of a page, one at each side; at large text each
/// shrinks its words to stay on one row: Save and Start Interpretation, or Add dreams and Start
/// Interpretation (D70 8; head's message 20, item 10).
class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key, required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: left)),
      const SizedBox(width: StandIns.gap),
      Flexible(child: FittedBox(fit: BoxFit.scaleDown, child: right)),
    ],
  );
}

/// A destructive pill in color.destructive, white words (the Design System
/// §2): Delete journal, Life Context's Delete all and Delete selected; told
/// apart by its place and its word as well (§3). Without [onPressed] it is
/// shown and does nothing.
class DestructivePill extends StatelessWidget {
  const DestructivePill(this.text, {super.key, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const role = LightColours.destructive;
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: _pill(role.colour!, role.colourEnd!),
          child: Padding(
            padding: StandIns.buttonPadding,
            child: Text(text, textAlign: TextAlign.center, style: TypeRoles.button.style(role.text!)),
          ),
        ),
      ),
    );
  }
}

/// A surface: a dreamer's bubble (color.surface, radius).
BoxDecoration surface(Palette p) => BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [p.surfaceTop, p.surfaceBottom],
  ),
  borderRadius: BorderRadius.circular(Spacing.radius),
  border: Border.all(color: p.surfaceBorder),
);

/// A dream in the dreamer's bubble, from the right (Spacing.bubbleDreamer);
/// opened from a search, its [bold] characters in Bold (D117 Q6).
class DreamBubble extends StatelessWidget {
  const DreamBubble(this.text, {super.key, required this.onTap, this.bold});

  final String text;
  final VoidCallback onTap;
  final Span? bold;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Padding(
      padding: Spacing.bubbleDreamer,
      child: Align(
        alignment: Alignment.centerRight,
        child: Semantics(
          button: true,
          child: GestureDetector(
            onTap: onTap,
            child: DecoratedBox(
              decoration: surface(p),
              child: Padding(
                padding: StandIns.bubblePadding,
                child: switch (bold) {
                  null => Text(text, style: TypeRoles.voiceDreamer.style(p.text)),
                  final b => Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: text.substring(0, b.start)),
                        TextSpan(
                          text: text.substring(b.start, b.end),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: text.substring(b.end)),
                      ],
                    ),
                    style: TypeRoles.voiceDreamer.style(p.text),
                  ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A thin chevron, drawn as two strokes, pointing right, or left when
/// [left] (head's message 20, items 4 and 9). Heard as nothing.
class Chevron extends StatelessWidget {
  const Chevron({super.key, required this.colour, this.size = StandIns.rowChevron, this.left = false});

  final Color colour;
  final Size size;
  final bool left;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.fromSize(
      size: size,
      child: CustomPaint(painter: _ChevronLine(colour, left)),
    ),
  );
}

class _ChevronLine extends CustomPainter {
  _ChevronLine(this.colour, this.left);

  final Color colour;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = StandIns.chevronStroke / 2;
    final back = left ? size.width - inset : inset;
    final tip = left ? inset : size.width - inset;
    final path = Path()
      ..moveTo(back, inset)
      ..lineTo(tip, size.height / 2)
      ..lineTo(back, size.height - inset);
    canvas.drawPath(
      path,
      Paint()
        ..color = colour
        ..style = PaintingStyle.stroke
        ..strokeWidth = StandIns.chevronStroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ChevronLine old) => old.colour != colour || old.left != left;
}

/// The back control, top left: a thin chevron in a round bordered button
/// (color.button), about 41 across (head's message 20, item 9), in a tap
/// box of at least 44 that shows nothing (D102); its spoken name is MP·14.
/// The look is anchored to the box's top left, so it stays on the page's
/// margin and the row's top, as reviewed.
class BackControl extends StatelessWidget {
  const BackControl({super.key, required this.onPressed});

  static const buttonKey = Key('back');

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Tooltip(
      message: Lines.MP_14.text(appLanguage),
      child: Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: SizedBox.square(
            dimension: StandIns.hitMin,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox.square(
                key: buttonKey,
                dimension: StandIns.backSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [p.buttonTop, p.buttonBottom],
                    ),
                    border: Border.all(color: p.buttonBorder),
                  ),
                  child: Center(child: Chevron(colour: p.buttonText, size: StandIns.backChevron, left: true)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// What stands below a row whose tap boxes are taller than its looks (the
/// back control and the menu's pill, D102): it starts where the looks end,
/// as before the boxes grew, and overlaps the boxes' empty foot.
class BelowTapBox extends StatelessWidget {
  const BelowTapBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const extra = StandIns.hitMin - StandIns.backSize;
    return LayoutBuilder(
      builder: (context, box) => OverflowBox(
        alignment: Alignment.bottomCenter,
        minHeight: box.maxHeight + extra,
        maxHeight: box.maxHeight + extra,
        child: child,
      ),
    );
  }
}
