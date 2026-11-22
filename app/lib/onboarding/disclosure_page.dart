// The disclosure and privacy page (MP·48; C14-P item 1): every part of the
// disclosure, W27·1 to W27·17 (W27·7 is merged into W27·6, W27·16 retired),
// in order, opened from onboarding's consent by MP·58 and closed by the
// back control, back to the consent. No consent is asked here. A part with
// no line yet (to rewrite) shows nothing in its place (D106 3; R1). No
// title: none is given (the plan's question 4).
import 'package:flutter/material.dart';

import '../core/language.dart';
import '../design/palette.dart';
import '../design/stand_ins.dart';
import '../design/tokens.g.dart';
import '../journal/pages/parts.dart';
import '../words/lines.g.dart';

/// Of [lines], those the register has written: a part with no line shows
/// nothing in its place, not its handle (D106 3).
List<Line> written(List<Line> lines) => [for (final line in lines) if (line.written) line];

/// Of [lines], those with no line yet.
List<Line> lacking(List<Line> lines) => [for (final line in lines) if (!line.written) line];

class DisclosurePage extends StatelessWidget {
  const DisclosurePage({super.key, this.shown = DisclosurePage.parts});

  /// The parts shown: [parts], unless a test hands in others (D106 3).
  final List<Line> shown;

  /// Every part, in the register's order.
  static const parts = [
    Lines.W27_1,
    Lines.W27_2,
    Lines.W27_3,
    Lines.W27_4,
    Lines.W27_5,
    Lines.W27_6,
    Lines.W27_8,
    Lines.W27_9,
    Lines.W27_10,
    Lines.W27_11,
    Lines.W27_12,
    Lines.W27_13,
    Lines.W27_14,
    Lines.W27_15,
    Lines.W27_17,
  ];

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    const side = EdgeInsets.symmetric(horizontal: Spacing.pageSide);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: side,
              child: Row(children: [BackControl(onPressed: () => Navigator.of(context).pop())]),
            ),
            Expanded(
              child: BelowTapBox(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.gap),
                  children: [
                    for (final line in written(shown))
                      Padding(
                        padding: const EdgeInsets.only(bottom: StandIns.gap),
                        child: Text(
                          line.parts(appLanguage).join('\n'),
                          textAlign: TextAlign.center,
                          style: StandIns.voiceApp(p.text),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
