// Onboarding (main-path.md, Onboarding; D103): the welcome, the note, the
// age question, the under-18 card, and the disclosure's first layer on two
// pages. The second ends with MP·58, which opens the full page, the text
// only, with back; then MP·109 "I don't agree" left (EM·6's words, D161 item 2) and MP·100 "I agree" right,
// equal, neither chosen beforehand (D127 item 1): "I agree" gives the readings
// and Life Context consents, "I don't agree" gives neither, a private journal.
// Every word is the register's, or a pending line's; a part with no line shows
// nothing in its place (D106 3).
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
import 'package:souldreams/settings/consent_page.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

String w(Line line) => line.parts(appLanguage).join('\n');

Finder said(Line line) => find.text(w(line));

/// MP·100, a pending line: its handle here, its words in SoulDreams Dev only.
Finder iAgree() => find.text(PendingLines.MP_100.text(appLanguage));

/// MP·109, a pending line since C19-P retired EM·6 (D161 item 2).
Finder iDont() => find.text(PendingLines.MP_109.text(appLanguage));

/// The full page's own scrolling list.
Finder full() => find.descendant(of: find.byType(DisclosurePage), matching: find.byType(Scrollable)).first;

void main() {
  late int agreed;
  Map<Consent, bool>? answers;

  void told(Map<Consent, bool> given) {
    agreed++;
    answers = given;
  }

  Future<void> start(WidgetTester tester) async {
    agreed = 0;
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 12),
      home: Onboarding(onAgreed: told),
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

  // Onto the full page, from the second page's MP·58.
  Future<void> toFull(WidgetTester tester) async {
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_58);
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

  testWidgets('the second page ends with I don\'t agree and I agree', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    for (final line in written(Onboarding.firstPage)) {
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    await tap(tester, Lines.MP_30);
    for (final line in written([Lines.W27_14, Lines.W27_15, Lines.W27_17, Lines.MP_57, Lines.MP_58])) {
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    expect(said(Lines.W27_1), findsNothing);
    // D127 item 1: no consent anywhere in onboarding, and no Next.
    expect(find.byType(TurnOnChoice), findsNothing);
    for (final line in [Lines.MP_66, Lines.MP_67, Lines.MP_68, Lines.MP_69, Lines.MP_70, Lines.MP_30]) {
      expect(said(line), findsNothing, reason: line.handle);
    }
    // The foot: MP·109 left, MP·100 right, side by side, below the page's words.
    expect(iDont(), findsOneWidget);
    expect(iAgree(), findsOneWidget);
    expect(tester.getCenter(iDont()).dy, closeTo(tester.getCenter(iAgree()).dy, 1));
    expect(tester.getCenter(iDont()).dx, lessThan(tester.getCenter(iAgree()).dx));
    final ys = [for (final line in [Lines.MP_57, Lines.MP_58]) tester.getTopLeft(said(line)).dy];
    expect(ys, [...ys]..sort());
    expect(tester.getTopLeft(iDont()).dy, greaterThan(ys.last));
    // Equal, neither chosen beforehand: the same kind of button, the same look.
    final no = find.ancestor(of: iDont(), matching: find.byType(PlainButton)).first;
    final yes = find.ancestor(of: iAgree(), matching: find.byType(PlainButton)).first;
    expect(tester.getSize(no).height, tester.getSize(yes).height);
    expect(tester.getSemantics(no).flagsCollection.isSelected, tester.getSemantics(yes).flagsCollection.isSelected);
    expect(agreed, 0);
  });

  // D127 item 1: the full page is the text only, with back: no consent, no
  // Next, no I agree.
  testWidgets('the full page is the text only', (tester) async {
    await start(tester);
    await toFull(tester);
    expect(find.byType(TurnOnChoice), findsNothing);
    for (final line in [Lines.MP_66, Lines.MP_68, Lines.MP_69, Lines.MP_30]) {
      expect(said(line), findsNothing, reason: line.handle);
    }
    expect(iDont(), findsNothing);
    expect(iAgree(), findsNothing);
    expect(find.byType(BackControl), findsOneWidget);
    expect(agreed, 0);
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

  // D106 3, kept proved now that every real part is filed: a part with no
  // line, handed in here, shows nothing on either page or on the full page.
  testWidgets('a part with no line shows nothing, on any page', (tester) async {
    const none = Line('X·1', null, null);
    agreed = 0;
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 12),
      home: Onboarding(
        onAgreed: told,
        first: const [Lines.W27_1, none],
        second: const [none, Lines.W27_14],
        full: const [none, Lines.W27_3],
      ),
    ));
    await tester.pumpAndSettle();
    await toDisclosure(tester);
    expect(find.textContaining('[X·1]'), findsNothing);
    expect(said(Lines.W27_1), findsOneWidget);
    await tap(tester, Lines.MP_30);
    expect(find.textContaining('[X·1]'), findsNothing);
    expect(said(Lines.W27_14), findsOneWidget);
    await tap(tester, Lines.MP_58);
    expect(find.byType(DisclosurePage), findsOneWidget);
    expect(find.textContaining('[X·1]'), findsNothing);
    expect(said(Lines.W27_3), findsOneWidget);
    expect(said(Lines.W27_1), findsNothing);
    expect(find.byType(TurnOnChoice), findsNothing);
  });

  test('the pages default to their parts', () {
    final o = Onboarding(onAgreed: (_) {});
    expect(o.first, Onboarding.firstPage);
    expect(o.second, Onboarding.secondPage);
    expect(o.full, DisclosurePage.parts);
    expect(const DisclosurePage().shown, DisclosurePage.parts);
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
      home: Onboarding(onAgreed: told),
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

  // D127 item 1: "I agree" accepts the disclosure and gives the readings and
  // Life Context consents, told once; any further tap does nothing.
  testWidgets('I agree gives both consents, told once', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tester.tap(iAgree());
    await tester.tap(iAgree());
    await tester.pumpAndSettle();
    expect(agreed, 1);
    expect(answers, {Consent.readings: true, Consent.lifeContext: true});
  });

  // "I don't agree" leaves both not given: the journal opens as a private
  // journal, asked nothing more.
  testWidgets("I don't agree gives neither, told once", (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tester.tap(iDont());
    await tester.tap(iDont());
    await tester.pumpAndSettle();
    expect(agreed, 1);
    expect(answers, {Consent.readings: false, Consent.lifeContext: false});
  });

  // Review (D125): once a decision is taken the journal is opening and the
  // second page is uncovered; MP·58 must not push the full page over a journal
  // that then replaces onboarding below it.
  testWidgets('after I agree, Read everything opens nothing more', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tester.tap(iAgree());
    await tester.pumpAndSettle();
    expect(agreed, 1);
    await tap(tester, Lines.MP_58);
    expect(find.byType(DisclosurePage), findsNothing);
    expect(agreed, 1);
  });

  testWidgets('Read everything opens every part; back returns to the second page', (tester) async {
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    await tap(tester, Lines.MP_58);
    expect(find.byType(DisclosurePage), findsOneWidget);
    for (final line in written(DisclosurePage.parts)) {
      await tester.scrollUntilVisible(said(line), 200, scrollable: full());
      expect(said(line), findsOneWidget, reason: line.handle);
    }
    expect(find.textContaining('[W27'), findsNothing);
    expect(DisclosurePage.parts.map((l) => l.handle), [
      for (final n in [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 17]) 'W27·$n',
    ]);
    await tester.tap(find.byType(BackControl));
    await tester.pumpAndSettle();
    expect(find.byType(DisclosurePage), findsNothing);
    expect(said(Lines.MP_58), findsOneWidget);
    expect(find.byType(TurnOnChoice), findsNothing);
    expect(iAgree(), findsOneWidget);
    expect(agreed, 0);
  });

  testWidgets('at the largest text, every step scrolls and nothing overflows', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await start(tester);
    await toDisclosure(tester);
    await tap(tester, Lines.MP_30);
    expect(tester.takeException(), isNull);
    // The foot's two buttons shrink their words to stay on one row.
    expect(iAgree(), findsOneWidget);
    expect(iDont(), findsOneWidget);
    await tap(tester, Lines.MP_58);
    expect(tester.takeException(), isNull);
  });
}
