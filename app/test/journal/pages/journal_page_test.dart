// The journal list (main-path.md, The Journal; S5; D58 Q7; P5, P8): the
// empty journal, rows newest first with no time and no count, dividers,
// the record button opening the typing screen, a row opening its night.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/words/lines.g.dart';

import '../../fixtures.dart';
import '../memory_journal_files.dart';
import '../zones.dart';
import 'harness.dart';

/// A folder whose reads wait while [hold] is open, as a phone's slow
/// read of every night would.
final class SlowFiles extends MemoryJournalFiles {
  Completer<void>? hold;

  @override
  Future<List<String>> list() async {
    await hold?.future;
    return super.list();
  }

  @override
  Future<Uint8List?> read(String name) async {
    await hold?.future;
    return super.read(name);
  }
}

/// A folder whose listing throws while [broken] is set, as a phone's
/// failed read of the journal's folder would.
final class BrokenFiles extends MemoryJournalFiles {
  bool broken = false;

  @override
  Future<List<String>> list() async {
    if (broken) throw const FileSystemException('list');
    return super.list();
  }
}

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

  // Head's message 20, item 7: the empty journal's line in the button type,
  // centred.
  testWidgets("the empty journal's line: the button type, centred", (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final line = tester.widget<AppLine>(find.byType(AppLine));
    expect(line.style.fontFamily, TypeRoles.button.family);
    expect(line.style.fontSize, TypeRoles.button.size);
    expect(line.textAlign, TextAlign.center);
    final at = tester.getCenter(find.byType(AppLine));
    expect(at.dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
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

  // Head's message 20, item 5: the divider centred.
  testWidgets('the month divider is centred', (tester) async {
    final h = await Harness.make();
    await keep(h, 'two-dreams-en', stockholm(2026, 5, 4, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final divider = find.text(monthDivider(2026, 5, 2026, Lang.en));
    expect(tester.widget<Text>(divider).textAlign, TextAlign.center);
    expect(tester.getCenter(divider).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
  });

  // Item 1: the summary in the button type, #767676 on the white row; in
  // the dark theme, color.text on the bubble gradient (design-system.md §3).
  testWidgets("the summary: the button type, the summary's colour", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final light = tester.widget<Text>(find.text(opening(n)));
    expect(light.style!.fontFamily, TypeRoles.button.family);
    expect(light.style!.fontSize, TypeRoles.button.size);
    expect(light.style!.color, LightColours.textSummary.colour);
    await tester.pumpWidget(
      SoulDreamsApp(key: UniqueKey(), home: JournalPage(journal: h.journal), clock: () => DateTime(2026, 6, 10, 22)),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text(opening(n))).style!.color, DarkColours.text.colour);
  });

  // Item 4: a chevron at each row's trailing edge, in the text's colour,
  // centred on the row's height, heard as nothing; item 12: rows 30 from
  // the screen's sides, 12 apart (TO TRY).
  testWidgets("a chevron at each row's trailing edge", (tester) async {
    final h = await Harness.make();
    final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final chevrons = find.byType(Chevron);
    expect(chevrons, findsNWidgets(2));
    final row = find.ancestor(of: find.text(dayDigits(older.date)), matching: find.byType(Container)).first;
    final chevron = find.descendant(of: row, matching: find.byType(Chevron));
    final rowBox = tester.getRect(row);
    final mark = tester.getRect(chevron);
    expect(rowBox.right - mark.right, closeTo(StandIns.rowPadding.right, 1));
    expect(mark.center.dy, closeTo(rowBox.center.dy, 1));
    expect(mark.left, greaterThan(tester.getRect(find.text(opening(older))).right));
    expect(tester.widget<Chevron>(chevron).colour, LightColours.text.colour);
    final width = tester.getSize(find.byType(JournalPage)).width;
    expect(rowBox.left, closeTo(StandIns.pageSide, 1));
    expect(rowBox.right, closeTo(width - StandIns.pageSide, 1));
    final rows = tester.widgetList<Container>(find.ancestor(of: find.byType(Chevron), matching: find.byType(Container)));
    expect(rows, hasLength(2));
    final tops = [for (final c in chevrons.evaluate()) tester.getRect(find.ancestor(of: find.byWidget(c.widget), matching: find.byType(Container)).first)];
    expect(tops[1].top - tops[0].bottom, closeTo(StandIns.rowGap, 1));
    final handle = tester.ensureSemantics();
    expect(find.descendant(of: chevron, matching: find.byType(ExcludeSemantics)), findsOneWidget);
    handle.dispose();
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

  // The final review: the record button reads the journal before the
  // typing screen opens, so a second tap in that time must open nothing,
  // or one evening's dreams could be split into two nights.
  testWidgets('two quick taps on the record button open one typing screen', (tester) async {
    final files = SlowFiles();
    final h = await Harness.make(files: files);
    await h.pump(tester, JournalPage(journal: h.journal));
    files.hold = Completer<void>();
    await tester.tap(find.byKey(RecordButton.buttonKey));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tap(find.byKey(RecordButton.buttonKey));
    await tester.pump(const Duration(milliseconds: 80));
    files.hold!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage, skipOffstage: false), findsOneWidget);
    // Once the screen is closed, the button opens it again.
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage, skipOffstage: false), findsNothing);
    await tester.tap(find.byKey(RecordButton.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
  });

  // D71 Q18 (the final review of journal-screens, banked items 1 and 2).
  Future<List<String>> logged() async {
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    return lines;
  }

  testWidgets('a failed load keeps the rows shown and logs a code', (tester) async {
    final lines = await logged();
    final files = BrokenFiles();
    final h = await Harness.make(files: files);
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 9, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    files.broken = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.text(dayDigits(n.date)), findsOneWidget);
    expect(lines, ['journalListFailed']);
  });

  testWidgets('a failed read at the record button opens nothing', (tester) async {
    final lines = await logged();
    final files = BrokenFiles();
    final h = await Harness.make(files: files);
    await h.pump(tester, JournalPage(journal: h.journal));
    files.broken = true;
    await tester.tap(find.byKey(RecordButton.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect(lines, ['journalListFailed']);
    // The button works again once the folder reads.
    files.broken = false;
    await tester.tap(find.byKey(RecordButton.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
  });
}
