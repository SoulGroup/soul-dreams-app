// Life Context's own page, from Settings (D110; D122; D125 item 9; D128):
// MP·69 over two buttons, Back on the left and Turn on on the right (MP·98
// and MP·99, pending lines: their words show in SoulDreams Dev only, R1),
// equally prominent, neither chosen beforehand, a tap answering at once. Back
// and the back control give nothing; Turn on gives Life Context. It is the
// only page of its kind: there is no consent to give or withdraw anywhere
// else (D128 item 2), and onboarding asks none of its own (D127 item 1).
import 'package:flutter/material.dart';

import '../core/app_line.dart';
import '../core/language.dart';
import '../design/palette.dart';
import '../design/stand_ins.dart';
import '../design/tokens.g.dart';
import '../journal/pages/parts.dart';
import '../words/lines.g.dart';
import '../words/pending.g.dart';

/// Life Context's two buttons: Back on the left, which answers false, and
/// Turn on on the right, which answers true; neither is chosen beforehand.
class TurnOnChoice extends StatelessWidget {
  const TurnOnChoice({super.key, required this.onChoose});

  final ValueChanged<bool> onChoose;

  /// A button's key: [given] true for Turn on.
  static Key keyOf(bool given) => ValueKey('life-context-$given');

  @override
  Widget build(BuildContext context) {
    Widget one(bool given, String text) => _Choice(key: keyOf(given), text: text, onTap: () => onChoose(given));
    return ButtonRow(
      left: one(false, PendingLines.MP_98.text(appLanguage)),
      right: one(true, PendingLines.MP_99.text(appLanguage)),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({super.key, required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      button: true,
      // Neither is chosen beforehand, and a tap answers at once.
      selected: false,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [p.buttonTop, p.buttonBottom],
            ),
            borderRadius: BorderRadius.circular(Spacing.radius),
            border: Border.all(color: p.buttonBorder),
          ),
          child: Padding(
            padding: StandIns.buttonPadding,
            child: Text(text, style: TypeRoles.button.style(p.buttonText)),
          ),
        ),
      ),
    );
  }
}

/// Life Context's page: its text, then Back and Turn on. Pops true for Turn
/// on, false for Back, null for the back control.
class ConsentPage extends StatelessWidget {
  const ConsentPage({super.key});

  /// Shows the page; true only when the dreamer turns Life Context on.
  static Future<bool> ask(BuildContext context) async =>
      await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => const ConsentPage())) == true;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.gap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: BackControl(onPressed: () => Navigator.of(context).pop()),
              ),
              const SizedBox(height: StandIns.gap),
              DecoratedBox(
                decoration: surface(p),
                child: Padding(
                  padding: Spacing.onboardingBox,
                  child: AppLine(Lines.MP_69.text(appLanguage), style: StandIns.voiceApp(p.text)),
                ),
              ),
              const SizedBox(height: StandIns.gap),
              TurnOnChoice(onChoose: (given) => Navigator.of(context).pop(given)),
            ],
          ),
        ),
      ),
    );
  }
}
