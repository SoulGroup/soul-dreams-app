// The two consents' words and their choice (C18-P, MP·66 to MP·69; C159-I
// item 5; D110; D122; D125 item 8): each consent's text, then MP·67's two
// choices, "I consent" and "I don't consent", side by side, equally
// prominent, neither chosen beforehand; the chosen one filled
// (color.button.filled, a stand-in). Onboarding shows both at the end of the
// full disclosure page (MP·66 above them); Settings shows one on its own page
// when a setting needs it (the stop's questions 6 and 10), whose back control
// gives nothing. MP·68 is "to rewrite" and shows its owed sentence in braces,
// as filed, in SoulDreams Dev only (D119 item 2; D122, Q1 (B)). Life Context's
// own page, from Settings, has two buttons of its own in place of MP·67's
// pair: Back on the left, Turn on on the right, MP·98 and MP·99, pending
// lines (D125 item 9), the same two keys, the same look, neither filled.
import 'package:flutter/material.dart';

import '../core/app_line.dart';
import '../core/language.dart';
import '../design/palette.dart';
import '../design/stand_ins.dart';
import '../design/tokens.g.dart';
import '../journal/pages/parts.dart';
import '../words/lines.g.dart';
import '../words/pending.g.dart';
import 'consents.dart';

/// The consent's text: MP·68 (a), MP·69 (b).
Line consentText(Consent consent) => switch (consent) {
  Consent.readings => Lines.MP_68,
  Consent.lifeContext => Lines.MP_69,
};

/// MP·67's two choices under one consent: [chosen] is null until one is
/// tapped. Each tap tells [onChoose] true for "I consent".
class ConsentChoice extends StatelessWidget {
  const ConsentChoice({super.key, required this.consent, required this.chosen, required this.onChoose});

  final Consent consent;
  final bool? chosen;
  final ValueChanged<bool> onChoose;

  /// A choice's key: [given] true for "I consent".
  static Key keyOf(Consent consent, bool given) => ValueKey('consent-${consent.name}-$given');

  @override
  Widget build(BuildContext context) {
    final words = Lines.MP_67.parts(appLanguage);
    Widget one(bool given, String text) =>
        _Choice(key: keyOf(consent, given), text: text, chosen: chosen == given, onTap: () => onChoose(given));
    return ButtonRow(left: one(true, words.first), right: one(false, words.last));
  }
}

class _Choice extends StatelessWidget {
  const _Choice({super.key, required this.text, required this.chosen, required this.onTap});

  final String text;
  final bool chosen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final filled = Theme.of(context).brightness == Brightness.dark
        ? DarkColours.buttonFilled
        : LightColours.buttonFilled;
    final top = chosen ? filled.colour! : p.buttonTop;
    final bottom = chosen ? (filled.colourEnd ?? filled.colour!) : p.buttonBottom;
    return Semantics(
      button: true,
      selected: chosen,
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [top, bottom]),
            borderRadius: BorderRadius.circular(Spacing.radius),
            border: Border.all(color: p.buttonBorder),
          ),
          child: Padding(
            padding: StandIns.buttonPadding,
            child: Text(text, style: TypeRoles.button.style(chosen ? filled.text! : p.buttonText)),
          ),
        ),
      ),
    );
  }
}

/// Life Context's two buttons, on its page from Settings (D125 item 9): Back
/// on the left, which answers false, and Turn on on the right, which answers
/// true, each under its [ConsentChoice] key, neither filled beforehand.
class TurnOnChoice extends StatelessWidget {
  const TurnOnChoice({super.key, required this.onChoose});

  final ValueChanged<bool> onChoose;

  @override
  Widget build(BuildContext context) {
    Widget one(bool given, String text) => _Choice(
      key: ConsentChoice.keyOf(Consent.lifeContext, given),
      text: text,
      chosen: false,
      onTap: () => onChoose(given),
    );
    return ButtonRow(
      left: one(false, PendingLines.MP_98.text(appLanguage)),
      right: one(true, PendingLines.MP_99.text(appLanguage)),
    );
  }
}

/// One consent on its own page, from Settings: its text, then the two
/// choices (Life Context: Back and Turn on). Pops true for "I consent" or
/// "Turn on", false for "I don't consent" or "Back", null for the back
/// control.
class ConsentPage extends StatelessWidget {
  const ConsentPage({super.key, required this.consent});

  final Consent consent;

  /// Shows [consent]'s page; true only when the dreamer consents.
  static Future<bool> ask(BuildContext context, Consent consent) async =>
      await Navigator.of(context).push<bool>(MaterialPageRoute(builder: (_) => ConsentPage(consent: consent))) == true;

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
                  child: AppLine(consentText(consent).text(appLanguage), style: StandIns.voiceApp(p.text)),
                ),
              ),
              const SizedBox(height: StandIns.gap),
              if (consent == Consent.lifeContext)
                TurnOnChoice(onChoose: (given) => Navigator.of(context).pop(given))
              else
                ConsentChoice(consent: consent, chosen: null, onChoose: (given) => Navigator.of(context).pop(given)),
            ],
          ),
        ),
      ),
    );
  }
}
