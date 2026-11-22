// One consent on its own page, from Settings (D122, the stop's questions 6,
// 7 and 10): its text, then MP·67's two choices; only "I consent" gives it,
// and the back control gives nothing.
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/language.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/settings/consent_page.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/words/lines.g.dart';

void main() {
  test('each consent has its text', () {
    expect([for (final c in Consent.values) consentText(c).handle], ['MP·68', 'MP·69', 'MP·70']);
  });

  for (final (how, expected) in [('yes', true), ('no', false), ('back', false)]) {
    testWidgets('the page answers $expected for $how', (tester) async {
      bool? answer;
      await tester.pumpWidget(
        SoulDreamsApp(
          clock: () => DateTime(2026, 6, 10, 12),
          home: Builder(
            builder: (context) => Center(
              child: GestureDetector(
                key: const Key('ask'),
                behavior: HitTestBehavior.opaque,
                onTap: () async => answer = await ConsentPage.ask(context, Consent.lifeContext),
                child: const SizedBox.square(dimension: 40),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('ask')));
      await tester.pumpAndSettle();
      expect(find.text(Lines.MP_69.text(appLanguage)), findsOneWidget);
      final yes = find.byKey(ConsentChoice.keyOf(Consent.lifeContext, true));
      final no = find.byKey(ConsentChoice.keyOf(Consent.lifeContext, false));
      expect(tester.getSemantics(yes).flagsCollection.isSelected, Tristate.isFalse);
      expect(tester.getSemantics(no).flagsCollection.isSelected, Tristate.isFalse);
      await tester.tap(switch (how) {
        'yes' => yes,
        'no' => no,
        _ => find.byType(BackControl),
      });
      await tester.pumpAndSettle();
      expect(find.byType(ConsentPage), findsNothing);
      expect(answer, expected);
    });
  }
}
