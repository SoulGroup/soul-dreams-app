// Onboarding (main-path.md, Onboarding; D103), SoulDreams Dev only: the
// welcome, the founder's note, the age question, then the disclosure's
// first layer on two pages (C14-P item 1; the plan's question 2 for which
// part stands on which page), the second ending at MP·58, which opens the
// full disclosure page. At the end of that page stand the two consents
// (C18-P, MP·66 to MP·69; C159-I item 5; D110; D122; D125 items 2 and 8):
// MP·66, then each consent's text with MP·67's two choices, equally
// prominent, neither chosen beforehand, then Next (MP·30), which waits until
// both are answered; any answer opens the journal. Night images has no
// consent (D125 item 8). The page that shows it holds the app light
// (AlwaysLight). Every word is the register's; a part with no line yet
// shows nothing in its place (D106 3; R1). Every box is centred between the
// top and the foot (D106 1), and the words appear whole (D106 2). Nothing
// is kept here: the three answers are told to the page that shows this,
// which keeps them and that the dreamer is 18 or over (D103 item 2;
// D122). Under 18: EM·5 and
// "I understand", which changes nothing; the card stays until the app
// closes, and the question is asked again at the next opening, since
// nothing was kept (C127-I I6). "I don't agree" goes back to the
// disclosure's first page and asks nothing (C127-I I7); it stands alone at
// the second page's foot, which has no Next (D125 item 2). There is no back
// control on a step: each goes forward only (the plan's question 8); the full
// page has its own back control, to the second page.
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_line.dart';
import '../core/language.dart';
import '../design/palette.dart';
import '../design/stand_ins.dart';
import '../design/tokens.g.dart';
import '../journal/pages/parts.dart';
import '../settings/consent_page.dart';
import '../settings/consents.dart';
import '../words/lines.g.dart';
import 'age.dart';
import 'disclosure_page.dart';

/// MP·2's line into the wordmark: the words before its last paragraph
/// break, then the wordmark after it; with no break, the line alone.
(String, String?) welcome(String line) {
  final at = line.lastIndexOf('\n\n');
  return at < 0 ? (line, null) : (line.substring(0, at), line.substring(at + 2));
}

enum _Step { welcome, note, age, underAge, disclosure, more }

class Onboarding extends StatefulWidget {
  const Onboarding({
    super.key,
    required this.onAgreed,
    this.first = Onboarding.firstPage,
    this.second = Onboarding.secondPage,
    this.full = DisclosurePage.parts,
  });

  /// Next, once both consents are answered: each consent, true when given
  /// (D122; D125 item 8).
  final ValueChanged<Map<Consent, bool>> onAgreed;

  /// The parts each page shows: [firstPage], [secondPage] and the full
  /// page's, unless a test hands in others (D106 3).
  final List<Line> first;
  final List<Line> second;
  final List<Line> full;

  static const ageKey = Key('age');

  /// The white box holding a step's words.
  static const boxKey = Key('onboarding-box');

  /// The disclosure's first page, then its consent page, by part (the
  /// plan's question 2). A part with no line shows nothing yet, but keeps
  /// its place here for when its line is filed.
  static const firstPage = [Lines.W27_1, Lines.W27_2, Lines.W27_5, Lines.W27_13];
  static const secondPage = [Lines.W27_14, Lines.W27_15, Lines.W27_17, Lines.MP_57];

  /// Every part shown, on either page here or on the full page, once each.
  static List<Line> get shown => {...firstPage, ...secondPage, ...DisclosurePage.parts}.toList();

  /// The parts shown that have no line yet. No tester or founder build while
  /// any is missing (D106 3; Status, "Before Cohort 1"; the guard in
  /// `dev_only_test.dart`).
  static List<Line> get missing => lacking(shown);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  _Step _step = _Step.welcome;
  // The band chosen, held only on this screen until Next (D103 item 2).
  int? _band;
  // The consents answered so far, held only on this screen until Next.
  final _answers = <Consent, bool>{};

  void _to(_Step step) => setState(() => _step = step);

  void _next() {
    switch (_step) {
      case _Step.welcome:
        _to(_Step.note);
      case _Step.note:
        _to(_Step.age);
      case _Step.age:
        final band = _band;
        if (band == null) return;
        _band = null;
        _to(underAge(band) ? _Step.underAge : _Step.disclosure);
      case _Step.disclosure:
        _to(_Step.more);
      case _Step.more:
      case _Step.underAge:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              // The box sits in the middle of the room between the top and
              // the foot; one taller than the room starts at the top and
              // scrolls (D106 1).
              child: LayoutBuilder(
                builder: (context, room) => SingleChildScrollView(
                  // Each step starts at its top.
                  key: ValueKey(_step),
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.pageSide, vertical: StandIns.gap),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: max(0.0, room.maxHeight - 2 * StandIns.gap)),
                    child: Center(
                      child: DecoratedBox(
                        key: Onboarding.boxKey,
                        decoration: surface(p),
                        child: Padding(
                          padding: Spacing.onboardingBox,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final (i, part) in _words(p).indexed) ...[
                                if (i > 0) const SizedBox(height: StandIns.gap),
                                part,
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_foot() case final foot?)
              Padding(
                padding: const EdgeInsets.fromLTRB(Spacing.pageSide, 0, Spacing.pageSide, StandIns.gap),
                child: foot,
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _words(Palette p) {
    final voice = StandIns.voiceApp(p.text);
    Widget says(Line line) => AppLine(line.parts(appLanguage).join('\n'), style: voice);
    Widget reads(Line line) => Text(line.parts(appLanguage).join('\n'), textAlign: TextAlign.center, style: voice);
    switch (_step) {
      case _Step.welcome:
        final (lead, mark) = welcome(Lines.MP_2.text(appLanguage));
        return [
          AppLine(lead, style: voice),
          if (mark != null) Text(mark, textAlign: TextAlign.center, style: TypeRoles.h1.style(p.text)),
          says(Lines.MP_3),
        ];
      case _Step.note:
        return [says(Lines.MP_4), says(Lines.MP_5)];
      case _Step.age:
        return [says(Lines.C4_P_2), _ageField(p)];
      case _Step.underAge:
        return [
          says(Lines.EM_5),
          // It changes nothing: the card stays until the app closes (C127-I I6).
          _one(PlainButton(Lines.MP_31.text(appLanguage), onPressed: () {})),
        ];
      case _Step.disclosure:
        return [for (final line in written(widget.first)) reads(line)];
      case _Step.more:
        return [
          for (final line in written(widget.second)) reads(line),
          _one(PlainButton(Lines.MP_58.text(appLanguage), onPressed: _openFull)),
        ];
    }
  }

  // The full disclosure page, ending in MP·66, the two consents and Next
  // (D125 item 2). The answers are held here, so that back keeps them.
  void _openFull() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (route) => StatefulBuilder(
          builder: (route, setRoute) {
            final p = Palette.of(route);
            final voice = StandIns.voiceApp(p.text);
            Widget reads(Line line) => Text(
              line.parts(appLanguage).join('\n'),
              textAlign: TextAlign.center,
              style: voice,
            );
            return DisclosurePage(
              shown: widget.full,
              end: [
                reads(Lines.MP_66),
                for (final consent in Consent.values) ...[
                  const SizedBox(height: StandIns.gap),
                  reads(consentText(consent)),
                  const SizedBox(height: StandIns.gap),
                  ConsentChoice(
                    consent: consent,
                    chosen: _answers[consent],
                    onChoose: (given) {
                      setState(() => _answers[consent] = given);
                      setRoute(() {});
                    },
                  ),
                ],
                const SizedBox(height: StandIns.gap),
                _one(PlainButton(Lines.MP_30.text(appLanguage), onPressed: () => _agree(route))),
              ],
            );
          },
        ),
      ),
    );
  }

  // Next at the end of the full page: both answered, the page closes and the
  // answers are told once (D122).
  void _agree(BuildContext route) {
    if (_answers.length < Consent.values.length) return;
    Navigator.of(route).pop();
    widget.onAgreed(Map.of(_answers));
  }

  Widget? _foot() => switch (_step) {
    _Step.underAge => null,
    _Step.more => _one(PlainButton(Lines.EM_6.text(appLanguage), onPressed: () => _to(_Step.disclosure))),
    _ => _one(PlainButton(Lines.MP_30.text(appLanguage), onPressed: _next)),
  };

  // One button, centred; at large text it shrinks its words to stay on one
  // row, as the pairs do (ButtonRow).
  static Widget _one(Widget button) => Center(child: FittedBox(fit: BoxFit.scaleDown, child: button));

  // The dropdown of the seven bands, MP·50 its placeholder (main-path.md,
  // Onboarding, 3): a pill in the field's colours.
  Widget _ageField(Palette p) {
    final style = TypeRoles.button.style(p.fieldText);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: p.field,
        borderRadius: BorderRadius.circular(Spacing.radius),
        border: Border.all(color: p.fieldBorder),
      ),
      child: Padding(
        padding: StandIns.fieldPadding,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            key: Onboarding.ageKey,
            isExpanded: true,
            value: _band,
            dropdownColor: p.field,
            style: style,
            hint: Text(Lines.MP_50.text(appLanguage), style: TypeRoles.button.style(p.placeholder)),
            items: [
              for (final (i, band) in ageBands(appLanguage).indexed)
                DropdownMenuItem(value: i, child: Text(band, style: style)),
            ],
            onChanged: (band) => setState(() => _band = band),
          ),
        ),
      ),
    );
  }
}
