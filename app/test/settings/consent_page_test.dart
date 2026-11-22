// One consent on its own page, from Settings (D122, the stop's questions 6
// and 10; D125 item 8: two consents): its text, then MP·67's two choices; only "I consent" gives it,
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
import 'package:souldreams/words/pending.g.dart';

/// Opens [consent]'s page from a button, and says what it answered.
Future<bool? Function()> openPage(WidgetTester tester, Consent consent) async {
  bool? answer;
  await tester.pumpWidget(
    SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 12),
      home: Builder(
        builder: (context) => Center(
          child: GestureDetector(
            key: const Key('ask'),
            behavior: HitTestBehavior.opaque,
            onTap: () async => answer = await ConsentPage.ask(context, consent),
            child: const SizedBox.square(dimension: 40),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(const Key('ask')));
  await tester.pumpAndSettle();
  return () => answer;
}

void main() {
  test('each consent has its text', () {
    expect([for (final c in Consent.values) consentText(c).handle], ['MP·68', 'MP·69']);
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

  // D125 item 9: Life Context's consent page has two buttons, Back on the left
  // and Turn on on the right, in place of MP·67's pair: MP·98 and MP·99 (pending
  // lines: their words show in SoulDreams Dev only, a handle elsewhere, and in
  // these tests). Equally prominent, neither chosen beforehand.
  testWidgets('Life Context: Back left, Turn on right, equally prominent', (tester) async {
    await openPage(tester, Consent.lifeContext);
    final back = find.byKey(ConsentChoice.keyOf(Consent.lifeContext, false));
    final turnOn = find.byKey(ConsentChoice.keyOf(Consent.lifeContext, true));
    expect(find.descendant(of: back, matching: find.text(PendingLines.MP_98.text(appLanguage))), findsOneWidget);
    expect(find.descendant(of: turnOn, matching: find.text(PendingLines.MP_99.text(appLanguage))), findsOneWidget);
    expect(tester.getCenter(back).dy, tester.getCenter(turnOn).dy);
    expect(tester.getCenter(back).dx, lessThan(tester.getCenter(turnOn).dx));
    // Neither is filled beforehand: the same look, one size each.
    expect(tester.getSemantics(back).flagsCollection.isSelected, Tristate.isFalse);
    expect(tester.getSemantics(turnOn).flagsCollection.isSelected, Tristate.isFalse);
    // MP·67's words are not on this page.
    for (final part in Lines.MP_67.parts(appLanguage)) {
      expect(find.text(part), findsNothing);
    }
  });

  test('the two buttons: their words in Dev, handles elsewhere', () {
    expect(PendingLines.MP_98.text(Lang.en, flavor: 'dev'), 'Back');
    expect(PendingLines.MP_98.text(Lang.sv, flavor: 'dev'), 'Tillbaka');
    expect(PendingLines.MP_99.text(Lang.en, flavor: 'dev'), 'Turn on');
    expect(PendingLines.MP_99.text(Lang.sv, flavor: 'dev'), 'Slå på');
    expect(PendingLines.MP_98.text(Lang.en, flavor: 'tester'), '[MP·98]');
    expect(PendingLines.MP_99.text(Lang.en, flavor: 'founder'), '[MP·99]');
  });

  // The readings consent keeps MP·67's pair: only Life Context changed.
  testWidgets('the readings consent keeps I consent and I don\'t consent', (tester) async {
    final answer = await openPage(tester, Consent.readings);
    final yes = find.byKey(ConsentChoice.keyOf(Consent.readings, true));
    final no = find.byKey(ConsentChoice.keyOf(Consent.readings, false));
    expect(find.descendant(of: yes, matching: find.text(Lines.MP_67.parts(appLanguage)[0])), findsOneWidget);
    expect(find.descendant(of: no, matching: find.text(Lines.MP_67.parts(appLanguage)[1])), findsOneWidget);
    expect(tester.getCenter(yes).dx, lessThan(tester.getCenter(no).dx));
    expect(find.textContaining('[MP·98]'), findsNothing);
    await tester.tap(yes);
    await tester.pumpAndSettle();
    expect(answer(), isTrue);
  });
}
