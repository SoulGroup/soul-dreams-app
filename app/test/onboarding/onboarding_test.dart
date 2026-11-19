// Onboarding (main-path.md, Onboarding; D103): the welcome, the note, the
// age question, the under-18 card, and the disclosure's first layer on two
// pages with one consent; MP·58 opens every part, and back returns to the
// consent. Every word is the register's; a part with no line shows nothing
// in its place (D106 3).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/language.dart';
import 'package:souldreams/design/stand_ins.dart';
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
    for (final line in written(Onboarding.firstPage)) {
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    expect(said(Lines.MP_8), findsNothing);
    await tap(tester, Lines.MP_30);
    for (final line in written([Lines.W27_14, Lines.W27_15, Lines.W27_17, Lines.MP_57, Lines.MP_58, Lines.MP_59])) {
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

  // D106 3: a part with no line would show nothing in its place (proved on
  // `written` and `lacking` below). C17-P filed every part: each page shows
  // each of its parts' words, and no handle.
  testWidgets('every part shows its words, on either page', (tester) async {
    expect(Onboarding.missing, isEmpty);
    await start(tester);
    await toDisclosure(tester);
    expect(find.textContaining('[W27'), findsNothing);
    for (final line in Onboarding.firstPage) {
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    await tap(tester, Lines.MP_30);
    expect(find.textContaining('[W27'), findsNothing);
    for (final line in Onboarding.secondPage) {
      expect(said(line), findsOneWidget, reason: line.handle);
    }
  });

  // The plan's question 2: a part with no line keeps its place.
  test('the two pages hold these parts, in order', () {
    expect(Onboarding.firstPage.map((l) => l.handle), ['W27·1', 'W27·2', 'W27·5', 'W27·13']);
    expect(Onboarding.secondPage.map((l) => l.handle), ['W27·14', 'W27·15', 'W27·17', 'MP·57']);
  });

  // D106 3 (review): the guard looks at every part shown, on either page of
  // onboarding and on the full page, MP·57 included.
  test('every part shown is looked at for a missing line', () {
    for (final line in [...Onboarding.firstPage, ...Onboarding.secondPage, ...DisclosurePage.parts]) {
      expect(Onboarding.shown, contains(line), reason: line.handle);
    }
    expect(Onboarding.shown.toSet().length, Onboarding.shown.length);
  });

  test('parts with no line are told apart from the written ones', () {
    const none = Line('X·1', null, null);
    const some = Line('X·2', ['a'], ['b']);
    expect(written([none, some, none, some]), [some, some]);
    expect(lacking([none, some, none]), [none, none]);
    // C17-P filed W27·2, W27·3, W27·6, W27·10 and W27·17.
    expect(Onboarding.missing, isEmpty);
  });

  // D106 2: onboarding's text appears all at once, whatever the time passed.
  testWidgets('the words appear all at once, not word by word', (tester) async {
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 12),
      home: Onboarding(onAgreed: () => agreed++),
    ));
    await tester.pump();
    final rich = tester.widgetList<RichText>(find.descendant(of: find.byType(AppLine), matching: find.byType(RichText)));
    expect(rich, isNotEmpty);
    for (final r in rich) {
      (r.text as TextSpan).visitChildren((span) {
        expect(span is TextSpan && span.style?.color == const Color(0x00000000), isFalse);
        return true;
      });
    }
  });

  // D106 1: every box is centred, between the top and the foot.
  testWidgets('each step\'s box is centred between the top and the foot', (tester) async {
    // A window tall enough that every step's box is shorter than its room.
    tester.view.physicalSize = const Size(1000, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await start(tester);
    final area = find.byType(SingleChildScrollView);
    void centred() {
      final box = tester.getRect(find.byKey(Onboarding.boxKey));
      final room = tester.getRect(area);
      expect(box.center.dy, closeTo(room.center.dy, 1));
      expect(box.center.dx, closeTo(room.center.dx, 1));
    }
    centred();
    await tap(tester, Lines.MP_30);
    centred();
    await tap(tester, Lines.MP_30);
    centred();
    await pick(tester, 0);
    await tap(tester, Lines.MP_30);
    centred();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a tall box starts at the top and scrolls', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await start(tester);
    await toDisclosure(tester);
    final room = tester.getRect(find.byType(SingleChildScrollView));
    final box = tester.getRect(find.byKey(Onboarding.boxKey));
    expect(box.top, closeTo(room.top + StandIns.gap, 1));
    // Taller than its room, so it scrolls rather than centring.
    expect(box.height, greaterThan(room.height));
    expect(tester.takeException(), isNull);
  });

  // A room under 2 gaps high must not trip the layout (review of D106).
  testWidgets('a room too short for its margins does not break', (tester) async {
    tester.view.physicalSize = const Size(400, 100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await start(tester);
    expect(tester.takeException(), isNull);
    expect(find.byKey(Onboarding.boxKey), findsOneWidget);
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
    for (final line in written(DisclosurePage.parts)) {
      await tester.scrollUntilVisible(said(line), 200);
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    expect(find.textContaining('[W27'), findsNothing);
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
