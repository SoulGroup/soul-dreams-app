// A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8): header, "Dreams",
// the dreams; editing through the typing screen; Add dreams; the menu
// holding only delete, spoken as MP·39; one confirmation, Cancel first,
// Delete destructive; deleting leaves nothing.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

import '../../fixtures.dart';
import '../zones.dart';
import 'harness.dart';

void main() {
  late Harness h;
  late Night n;

  Future<void> open(WidgetTester tester) async {
    h = await Harness.make();
    n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id)));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byKey(NightPage.menuKey));
    await tester.pumpAndSettle();
  }

  testWidgets('the header, the label "Dreams", the dreams in order', (tester) async {
    await open(tester);
    expect(find.text(dayDigits(n.date)), findsOneWidget);
    expect(find.text(Lines.MP_38.text(Lang.en)), findsOneWidget);
    final first = tester.getTopLeft(find.text(n.dreams[0]));
    final second = tester.getTopLeft(find.text(n.dreams[1]));
    expect(first.dy, lessThan(second.dy));
    expect(find.text(Lines.MP_29.text(Lang.en)), findsOneWidget);
  });

  testWidgets('"Dreams" is heard as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester);
    expect(tester.getSemantics(find.text(Lines.MP_38.text(Lang.en))).flagsCollection.isHeader, isTrue);
    handle.dispose();
  });

  testWidgets('tapping a dream opens it filled; Save replaces it', (tester) async {
    await open(tester);
    await tester.tap(find.text(n.dreams[1]));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    final other = invented('one-dream-sv').dreams.single;
    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text(other), findsOneWidget);
    expect((await h.journal.night(n.id))!.dreams, [n.dreams[0], other]);
  });

  testWidgets('an emptied dream disappears; the others remain', (tester) async {
    await open(tester);
    await tester.tap(find.text(n.dreams[0]));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(TypingPage.fieldKey), '  ');
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsOneWidget);
    expect(find.text(n.dreams[0]), findsNothing);
    expect((await h.journal.night(n.id))!.dreams, [n.dreams[1]]);
  });

  testWidgets('a night emptied of every dream leaves, deleted', (tester) async {
    await open(tester);
    for (final d in n.dreams) {
      await tester.tap(find.text(d));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(TypingPage.fieldKey), '');
      await tester.tap(find.byKey(TypingPage.saveKey));
      await tester.pumpAndSettle();
    }
    expect(find.byType(NightPage), findsNothing);
    expect(await h.nights(), isEmpty);
    expect(h.files.files.keys.where((k) => k.contains(n.id)), isEmpty);
  });

  testWidgets('Add dreams adds to this night, even after its 21:00', (tester) async {
    await open(tester);
    Harness.clock = stockholm(2026, 6, 9, 12);
    await tester.tap(find.byKey(NightPage.addKey));
    await tester.pumpAndSettle();
    final added = invented('one-dream-sv').dreams.single;
    await tester.enterText(find.byKey(TypingPage.fieldKey), added);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.journal.night(n.id))!.dreams, [...n.dreams, added]);
    expect(await h.nights(), hasLength(1));
  });

  testWidgets('the menu: spoken as MP·39, holding only delete, plain', (tester) async {
    await open(tester);
    expect(find.byTooltip(Lines.MP_39.text(Lang.en)), findsOneWidget);
    await openMenu(tester);
    expect(find.byType(PopupMenuItem<int>), findsOneWidget);
    expect(find.text(Lines.EM_11.parts(Lang.en)[1]), findsOneWidget);
    expect(find.text(Lines.MP_28.text(Lang.en)), findsNothing);
  });

  testWidgets('one confirmation: Cancel first keeps the night', (tester) async {
    await open(tester);
    await openMenu(tester);
    await tester.tap(find.byKey(NightPage.deleteKey));
    await tester.pumpAndSettle();
    expect(find.text(Lines.C4_P_4.text(Lang.en)), findsOneWidget);
    final actions = tester.widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction)).toList();
    expect(actions, hasLength(2));
    expect(actions[0].isDestructiveAction, isFalse);
    expect(actions[1].isDestructiveAction, isTrue);
    expect((actions[0].child as Text).data, PendingLines.MP_61.text(Lang.en));
    expect((actions[1].child as Text).data, PendingLines.MP_60.text(Lang.en));
    await tester.tap(find.byWidget(actions[0]));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsOneWidget);
    expect(await h.nights(), hasLength(1));
  });

  testWidgets('Delete removes the night, leaving nothing, and goes back', (tester) async {
    await open(tester);
    await openMenu(tester);
    await tester.tap(find.byKey(NightPage.deleteKey));
    await tester.pumpAndSettle();
    final delete = tester.widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction)).last;
    await tester.tap(find.byWidget(delete));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsNothing);
    expect(await h.nights(), isEmpty);
    expect(h.files.files.keys.where((k) => k.contains(n.id)), isEmpty);
  });

  testWidgets('pending lines are placeholders outside Dev, words in Dev', (tester) async {
    expect(PendingLines.MP_60.text(Lang.en), '[MP·60]');
    expect(PendingLines.MP_60.text(Lang.en, flavor: 'tester'), '[MP·60]');
    expect(PendingLines.MP_60.text(Lang.en, flavor: 'founder'), '[MP·60]');
    expect(PendingLines.MP_60.text(Lang.en, flavor: 'dev'), isNot('[MP·60]'));
    expect(PendingLines.MP_61.text(Lang.sv, flavor: 'dev'), isNot(PendingLines.MP_61.text(Lang.en, flavor: 'dev')));
  });

  testWidgets('text at twice the size does not overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester);
    expect(tester.takeException(), isNull);
  });
}
