// The journal list (main-path.md, The Journal; S5; D58 Q7; P5, P8): the
// empty journal, rows newest first with no time and no count, dividers,
// the record button opening the typing screen, a row opening its night.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/words/lines.g.dart';

import '../../fixtures.dart';
import '../zones.dart';
import 'harness.dart';

void main() {
  testWidgets('the empty journal: C4-P·5 and the record button, nothing else', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
    expect(find.text(Lines.MP_11.text(Lang.en)), findsOneWidget);
    // No Settings entry and no search (P8).
    expect(find.text(Lines.MP_25.text(Lang.en)), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('rows newest first: the date, then the trimmed opening', (tester) async {
    final h = await Harness.make();
    final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    final newer = await keep(h, 'framed-opening-en', stockholm(2026, 6, 9, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final newDate = tester.getTopLeft(find.text(dayDigits(newer.date)));
    final oldDate = tester.getTopLeft(find.text(dayDigits(older.date)));
    expect(newDate.dy, lessThan(oldDate.dy));
    expect(find.text(opening(newer)), findsOneWidget);
    expect(find.text(newer.dreams.first), findsNothing);
    // A row shows no time, and no count of dreams.
    expect(find.textContaining(':'), findsNothing);
    expect(find.textContaining('2 '), findsNothing);
  });

  testWidgets('a divider over each month with nights; years before this', (tester) async {
    final h = await Harness.make();
    await keep(h, 'two-dreams-en', stockholm(2025, 10, 4, 23));
    await keep(h, 'framed-opening-en', stockholm(2026, 5, 4, 23));
    await keep(h, 'one-dream-sv', stockholm(2026, 5, 8, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.text(monthDivider(2026, 5, 2026, Lang.en)), findsOneWidget);
    expect(find.text(monthDivider(2025, 10, 2026, Lang.en)), findsOneWidget);
    expect(find.text(monthDivider(2026, 6, 2026, Lang.en)), findsNothing);
    expect(monthDivider(2025, 10, 2026, Lang.en), endsWith(' 2025'));
  });

  testWidgets('a named night shows its name, then its date', (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 2, 23));
    final name = invented('named-three-dreams-sv').name!;
    // Naming is not built (P7); a name reaches the store only directly.
    await h.store.save(
      Night(
        id: n.id,
        firstRecorded: n.firstRecorded,
        date: n.date,
        closes: n.closes,
        lang: n.lang,
        name: name,
        dreams: n.dreams,
      ),
    );
    await h.pump(tester, JournalPage(journal: h.journal));
    final nameAt = tester.getTopLeft(find.text(name));
    final dateAt = tester.getTopLeft(find.text(dayDigits(n.date)));
    expect(nameAt.dy, lessThan(dateAt.dy));
  });

  testWidgets('the summary is always three lines', (tester) async {
    final h = await Harness.make();
    await keep(h, 'long-dream-en', stockholm(2026, 6, 2, 23));
    await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final long = find.textContaining(invented('long-dream-en').dreams.single.substring(0, 20));
    final text = tester.widget<Text>(long);
    expect(text.maxLines, 3);
    expect(text.overflow, TextOverflow.ellipsis);
    final short = find.text(invented('one-dream-sv').dreams.single);
    expect(tester.getSize(short).height, closeTo(tester.getSize(long).height, 1));
  });

  testWidgets('the record button opens typing; a Save adds a row', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    await tester.tap(find.byKey(RecordButton.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    final dream = invented('one-dream-sv').dreams.single;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dream);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text(dream), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsNothing);
  });

  testWidgets("a row opens its night's page", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    await tester.tap(find.text(dayDigits(n.date)));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsOneWidget);
    expect(find.text(n.dreams[1]), findsOneWidget);
  });

  testWidgets('text at twice the size does not overflow', (tester) async {
    final h = await Harness.make();
    await keep(h, 'long-dream-en', stockholm(2026, 6, 2, 23));
    await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 3, 23));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(tester.takeException(), isNull);
  });

  // 15a (the owner's correction, P13): the record button is a circle.
  testWidgets('the record button is a circle, radius half its height', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final button = find.byKey(RecordButton.buttonKey);
    final size = tester.getSize(button);
    expect(size.width, size.height);
    expect(size.height, StandIns.recordHeight);
    final box = tester.widget<DecoratedBox>(find.descendant(of: button, matching: find.byType(DecoratedBox)).first);
    expect((box.decoration as BoxDecoration).borderRadius, BorderRadius.circular(size.height / 2));
  });

  testWidgets('large text cannot stretch the record button', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(tester.takeException(), isNull);
    final size = tester.getSize(find.byKey(RecordButton.buttonKey));
    expect(size, Size(StandIns.recordHeight, StandIns.recordHeight));
  });
}
