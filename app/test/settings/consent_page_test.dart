// Life Context's own page, from Settings (D122; D125 item 9; D128): MP·69 over
// Back on the left and Turn on on the right (MP·107, MP·108, pending lines);
// only Turn on gives Life Context; Back and the back control give nothing.
import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/language.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/settings/consent_page.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

void main() {
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
                onTap: () async => answer = await ConsentPage.ask(context),
                child: const SizedBox.square(dimension: 40),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('ask')));
      await tester.pumpAndSettle();
      expect(find.text(Lines.MP_69.text(appLanguage)), findsOneWidget);
      final yes = find.byKey(TurnOnChoice.keyOf(true));
      final no = find.byKey(TurnOnChoice.keyOf(false));
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

  // D125 item 9: Back on the left and Turn on on the right (MP·107 and MP·108:
  // pending lines, their words show in SoulDreams Dev only, a handle elsewhere
  // and in these tests). Equally prominent, neither chosen beforehand.
  testWidgets('Life Context: Back left, Turn on right, equally prominent', (tester) async {
    await tester.pumpWidget(
      SoulDreamsApp(
        clock: () => DateTime(2026, 6, 10, 12),
        home: const ConsentPage(),
      ),
    );
    await tester.pumpAndSettle();
    final back = find.byKey(TurnOnChoice.keyOf(false));
    final turnOn = find.byKey(TurnOnChoice.keyOf(true));
    expect(find.descendant(of: back, matching: find.text(PendingLines.MP_107.text(appLanguage))), findsOneWidget);
    expect(find.descendant(of: turnOn, matching: find.text(PendingLines.MP_108.text(appLanguage))), findsOneWidget);
    expect(tester.getCenter(back).dy, tester.getCenter(turnOn).dy);
    expect(tester.getCenter(back).dx, lessThan(tester.getCenter(turnOn).dx));
    // Neither is filled beforehand: the same look, one size each.
    expect(tester.getSemantics(back).flagsCollection.isSelected, Tristate.isFalse);
    expect(tester.getSemantics(turnOn).flagsCollection.isSelected, Tristate.isFalse);
    // MP·67's pair is not on this page, and nothing is called a consent (D128 item 4).
    for (final part in Lines.MP_67.parts(appLanguage)) {
      expect(find.text(part), findsNothing);
    }
  });

  test('the two buttons: their words in Dev, handles elsewhere', () {
    expect(PendingLines.MP_107.text(Lang.en, flavor: 'dev'), 'Back');
    expect(PendingLines.MP_107.text(Lang.sv, flavor: 'dev'), 'Tillbaka');
    expect(PendingLines.MP_108.text(Lang.en, flavor: 'dev'), 'Turn on');
    expect(PendingLines.MP_108.text(Lang.sv, flavor: 'dev'), 'Slå på');
    expect(PendingLines.MP_107.text(Lang.en, flavor: 'tester'), '[MP·107]');
    expect(PendingLines.MP_108.text(Lang.en, flavor: 'founder'), '[MP·108]');
  });
}
