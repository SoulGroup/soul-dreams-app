// The journal pages' shared parts, from the palette, the type roles and
// the named stand-ins. No words here: each part is given its line.
import 'package:flutter/material.dart';

import '../../core/language.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';

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

/// The record button: the biggest thing on the journal's screen, the
/// terracotta gradient, its words in white (main-path.md, The Journal).
class RecordButton extends StatelessWidget {
  const RecordButton({super.key, required this.onPressed});

  static const buttonKey = Key('record-button');

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      button: true,
      child: GestureDetector(
        key: buttonKey,
        onTap: onPressed,
        child: Container(
          constraints: const BoxConstraints(minHeight: StandIns.recordHeight, minWidth: StandIns.recordWidth),
          decoration: _pill(p.recordTop, p.recordBottom),
          padding: StandIns.buttonPadding,
          alignment: Alignment.center,
          child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(p.recordText)),
        ),
      ),
    );
  }
}

/// A surface: a journal row or a dreamer's bubble (color.surface, radius).
BoxDecoration surface(Palette p) => BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [p.surfaceTop, p.surfaceBottom],
  ),
  borderRadius: BorderRadius.circular(Spacing.radius),
  border: Border.all(color: p.surfaceBorder),
);

/// A dream in the dreamer's bubble, from the right (Spacing.bubbleDreamer).
class DreamBubble extends StatelessWidget {
  const DreamBubble(this.text, {super.key, required this.onTap});

  final String text;
  final VoidCallback onTap;

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
                child: Text(text, style: TypeRoles.voiceDreamer.style(p.text)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The back control, top left: an arrow whose spoken name is MP·14.
class BackControl extends StatelessWidget {
  const BackControl({super.key, required this.onPressed});

  static const buttonKey = Key('back');

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    key: buttonKey,
    onPressed: onPressed,
    tooltip: Lines.MP_14.text(appLanguage),
    icon: Icon(Icons.arrow_back_ios_new, color: Palette.of(context).text),
  );
}
