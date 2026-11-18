// Onboarding (main-path.md, Onboarding; D103): the welcome, the note, the
// age question, the under-18 card, and the disclosure's first layer on two
// pages with one consent; MP·58 opens every part, and back returns to the
// consent. Every word is the register's; a part to rewrite shows its handle.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/language.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/onboarding/age.dart';
import 'package:souldreams/onboarding/disclosure_page.dart';
import 'package:souldreams/onboarding/onboarding.dart';
import 'package:souldreams/words/lines.g.dart';

String w(Line line) => line.parts(appLanguage).join('\n');

Finder said(Line line) => find.text(w(line));

void main() {
  late int agreed;

  Future<void> start(WidgetTester tester) async {
    agreed = 0;
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 12),
      home: Onboarding(onAgreed: () => agreed++),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Line line) async {
    await tester.ensureVisible(said(line).last);
    await tester.tap(said(line).last);
    await tester.pumpAndSettle();
  }

  Future<void> pick(WidgetTester tester, int band) async {
    await tester.tap(find.byKey(Onboarding.ageKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(ageBands(appLanguage)[band]).last);
    await tester.pumpAndSettle();
  }

  Future<void> toDisclosure(WidgetTester tester) async {
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_30);
    await pick(tester, 1);
    await tap(tester, Lines.MP_30);
  }

  testWidgets('the welcome: the line into the wordmark, the second line, Next', (tester) async {
    await start(tester);
    final (lead, mark) = welcome(w(Lines.MP_2));
    expect(find.text(lead), findsOneWidget);
    expect(mark, isNotNull);
    final wordmark = tester.widget<Text>(find.text(mark!));
    expect(wordmark.style!.fontFamily, 'Tangerine');
    expect(said(Lines.MP_3), findsOneWidget);
    expect(said(Lines.MP_30), findsOneWidget);
    expect(said(Lines.MP_4), findsNothing);
  });

  test('the welcome line parts at its last paragraph break', () {
    expect(welcome('a\n\nb'), ('a', 'b'));
    expect(welcome('a b'), ('a b', null));
  });

  testWidgets('the note, signed, then the age question with its placeholder', (tester) async {
    await start(tester);
    await tap(tester, Lines.MP_30);
    expect(said(Lines.MP_4), findsOneWidget);
    expect(said(Lines.MP_5), findsOneWidget);
    await tap(tester, Lines.MP_30);
    expect(said(Lines.C4_P_2), findsOneWidget);
    expect(said(Lines.MP_50), findsOneWidget);
  });

  testWidgets('Next does nothing until a band is chosen', (tester) async {
    await start(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_30);
    expect(said(Lines.C4_P_2), findsOneWidget);
    expect(said(Lines.W27_1), findsNothing);
    expect(said(Lines.EM_5), findsNothing);
  });

  testWidgets('every band is offered; under 18 shows the card, which stays', (tester) async {
    await start(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_30);
    await tester.tap(find.byKey(Onboarding.ageKey));
    await tester.pumpAndSettle();
    for (final band in ageBands(appLanguage)) {
      expect(find.text(band), findsWidgets, reason: band);
    }
    await tester.tap(find.text(ageBands(appLanguage).first).last);
    await tester.pumpAndSettle();
    await tap(tester, Lines.MP_30);
    expect(said(Lines.EM_5), findsOneWidget);
    expect(said(Lines.MP_30), findsNothing);
    await tap(tester, Lines.MP_31);
    await tap(tester, Lines.MP_31);
    expect(said(Lines.EM_5), findsOneWidget);
    expect(said(Lines.MP_31), findsOneWidget);
    expect(said(Lines.C4_P_2), findsNothing);
    expect(agreed, 0);
  });

  testWidgets('18 or over: the disclosure first page, then the consent', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    for (final line in [Lines.W27_1, Lines.W27_2, Lines.W27_5, Lines.W27_13]) {
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    expect(said(Lines.MP_8), findsNothing);
    await tap(tester, Lines.MP_30);
    for (final line in [Lines.W27_14, Lines.W27_15, Lines.W27_17, Lines.MP_57, Lines.MP_58, Lines.MP_59]) {
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    expect(said(Lines.W27_1), findsNothing);
    expect(find.byType(ButtonRow), findsOneWidget);
    expect(said(Lines.MP_8), findsOneWidget);
    expect(said(Lines.EM_6), findsOneWidget);
    // EM·6 left, MP·8 right (the plan's question 6).
    expect(tester.getCenter(said(Lines.EM_6)).dx, lessThan(tester.getCenter(said(Lines.MP_8)).dx));
  });

  testWidgets('the first layer only: no part of the full page alone', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    for (final line in [Lines.W27_3, Lines.W27_4, Lines.W27_6, Lines.W27_8, Lines.W27_9, Lines.W27_10,
        Lines.W27_11, Lines.W27_12]) {
      expect(said(line), findsNothing, reason: line.handle);
    }
  });

  testWidgets('a part to rewrite shows its handle (R1)', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    expect(find.text('[W27·2]'), findsOneWidget);
    await tap(tester, Lines.MP_30);
    expect(find.text('[W27·17]'), findsOneWidget);
  });

  testWidgets("I don't agree returns to the first page; nothing agreed", (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.EM_6);
    expect(said(Lines.W27_1), findsOneWidget);
    expect(said(Lines.MP_8), findsNothing);
    expect(agreed, 0);
  });

  testWidgets('I agree is told once', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_8);
    expect(agreed, 1);
  });

  testWidgets('Read everything opens every part; back returns to the consent', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_58);
    expect(find.byType(DisclosurePage), findsOneWidget);
    for (final line in DisclosurePage.parts) {
      await tester.scrollUntilVisible(said(line), 200);
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    expect(DisclosurePage.parts.map((l) => l.handle), [
      for (final n in [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 17]) 'W27·$n',
    ]);
    await tester.tap(find.byType(BackControl));
    await tester.pumpAndSettle();
    expect(find.byType(DisclosurePage), findsNothing);
    expect(said(Lines.MP_8), findsOneWidget);
  });

  testWidgets('at the largest text, every step scrolls and nothing overflows', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_58);
    expect(tester.takeException(), isNull);
  });
}
