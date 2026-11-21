// The journal list (main-path.md, The Journal; S5; D58 Q7; P5; D110): the
// greeting by time of day, New Dream opening the typing screen, no record
// button, the empty journal, rows newest first carrying only the date over
// the night's picture, dividers, a row opening its night.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/greeting.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_action.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/owed.dart';
import 'package:souldreams/journal/pages/night_art.dart';
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
  testWidgets('the empty journal: the greeting, New Dream and C4-P·5', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.text(OwedLines.greetingAfternoon.text), findsOneWidget);
    expect(find.text(OwedLines.newDream.text), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
    // The round record button is gone (D110).
    expect(find.text(Lines.MP_11.text(Lang.en)), findsNothing);
    // No Settings entry and no search: later branches.
    expect(find.text(Lines.MP_25.text(Lang.en)), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });

  // D110: a greeting by the part of the day, centred in h2, heard as a
  // heading, above New Dream; it follows the clock while the page is open.
  testWidgets('the greeting: by the clock, centred, a heading, above New Dream', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final greeting = find.text(OwedLines.greetingAfternoon.text);
    final text = tester.widget<Text>(greeting);
    expect(text.style!.fontFamily, TypeRoles.h2.family);
    expect(text.style!.fontSize, TypeRoles.h2.size);
    expect(text.textAlign, TextAlign.center);
    expect(tester.getCenter(greeting).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
    expect(tester.getRect(greeting).bottom, lessThan(tester.getRect(find.byKey(JournalPage.newDreamKey)).top));
    final handle = tester.ensureSemantics();
    expect(tester.getSemantics(greeting), matchesSemantics(label: OwedLines.greetingAfternoon.text, isHeader: true));
    handle.dispose();
    Harness.clock = stockholm(2026, 6, 10, 17);
    await tester.pump(const Duration(minutes: 1));
    expect(find.text(OwedLines.greetingEvening.text), findsOneWidget);
    expect(greetingFor(Daypart.evening), OwedLines.greetingEvening);
  });

  // D110: New Dream, centred, the painted gradient behind its words, heard
  // as a button.
  testWidgets('New Dream: centred, on the painted gradient, a button', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final button = find.byKey(JournalPage.newDreamKey);
    expect(tester.getCenter(button).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
    final art = tester.widget<NightArt>(find.descendant(of: button, matching: find.byType(NightArt)));
    expect(art.look, const PaintedGradient());
    final words = tester.widget<Text>(find.text(OwedLines.newDream.text));
    expect(words.style!.color, NightArt.over);
    expect(words.style!.fontFamily, TypeRoles.button.family);
    final handle = tester.ensureSemantics();
    expect(tester.getSemantics(button), matchesSemantics(label: OwedLines.newDream.text, isButton: true, hasTapAction: true));
    handle.dispose();
  });

  // Onboarding's last step (main-path.md, Onboarding, 5): the first empty
  // journal adds MP·9 with an arrow up to New Dream, shown once: gone when a
  // night is there, and never on a later empty journal.
  testWidgets('the first empty journal: MP·9 under New Dream, once', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal, firstTime: true));
    final pointer = find.bySemanticsLabel(Lines.MP_9.text(Lang.en));
    expect(pointer, findsOneWidget);
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
    expect(find.byKey(JournalPage.arrowKey), findsOneWidget);
    final arrow = tester.getRect(find.byKey(JournalPage.arrowKey));
    final button = tester.getRect(find.byKey(JournalPage.newDreamKey));
    expect(arrow.top, greaterThanOrEqualTo(button.bottom));
    expect(arrow.center.dx, closeTo(button.center.dx, 1));
    final mp9 = tester.getRect(find.byWidgetPredicate((w) => w is AppLine && w.text == Lines.MP_9.text(Lang.en)));
    expect(mp9.top, greaterThanOrEqualTo(arrow.bottom));
    // A night comes, then goes, on the same visit: MP·9 does not return.
    final night = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 7));
    Future<void> back() async {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
    }

    await back();
    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
    await h.journal.delete(night.id);
    await back();
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
    expect(find.byKey(JournalPage.arrowKey), findsNothing);
  });

  testWidgets('a later empty journal has no MP·9', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
    expect(find.byKey(JournalPage.arrowKey), findsNothing);
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

  testWidgets('rows newest first, carrying only the date', (tester) async {
    final h = await Harness.make();
    final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    final newer = await keep(h, 'framed-opening-en', stockholm(2026, 6, 9, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final newDate = tester.getTopLeft(find.text(dayDigits(newer.date)));
    final oldDate = tester.getTopLeft(find.text(dayDigits(older.date)));
    expect(newDate.dy, lessThan(oldDate.dy));
    // No opening, no chevron (D110).
    expect(find.text(opening(newer)), findsNothing);
    expect(find.textContaining(newer.dreams.first.substring(0, 12)), findsNothing);
    expect(find.byType(Chevron), findsNothing);
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

  // D110: a rounded row, the date centred over the night's picture: an
  // unread night's the painted gradient; 30 from the screen's sides, 12
  // apart; heard as a button named by its date.
  testWidgets("a row: the date over an unread night's gradient", (tester) async {
    final h = await Harness.make();
    final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    final newer = await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final arts = find.descendant(of: find.byType(ListView), matching: find.byType(NightArt));
    // New Dream's, and one per row.
    expect(arts, findsNWidgets(3));
    for (final n in [older, newer]) {
      final date = find.text(dayDigits(n.date));
      final row = find.ancestor(of: date, matching: find.byKey(JournalPage.rowKey(n.id)));
      final art = find.descendant(of: row, matching: find.byType(NightArt));
      expect(tester.widget<NightArt>(art).look, const PaintedGradient());
      expect(tester.getRect(art), tester.getRect(row));
      expect(tester.getCenter(date).dx, closeTo(tester.getCenter(row).dx, 1));
      expect(tester.getCenter(date).dy, closeTo(tester.getCenter(row).dy, 1));
      final style = tester.widget<Text>(date).style!;
      expect(style.color, NightArt.over);
      expect(style.fontFamily, TypeRoles.h6.family);
      expect(style.fontSize, TypeRoles.h6.size);
      expect(tester.getSize(row).height, StandIns.rowHeight);
      final clip = tester.widget<ClipRRect>(find.descendant(of: row, matching: find.byType(ClipRRect)));
      expect(clip.borderRadius, BorderRadius.circular(Spacing.radius));
    }
    final width = tester.getSize(find.byType(JournalPage)).width;
    final first = tester.getRect(find.byKey(JournalPage.rowKey(newer.id)));
    final second = tester.getRect(find.byKey(JournalPage.rowKey(older.id)));
    expect(first.left, closeTo(Spacing.pageSide, 1));
    expect(first.right, closeTo(width - Spacing.pageSide, 1));
    expect(second.top - first.bottom, closeTo(Spacing.journalRow, 1));
    final handle = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.byKey(JournalPage.rowKey(older.id))),
      matchesSemantics(label: dayDigits(older.date), isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets("a read night's row shows its painting", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal, read: (_) => true));
    final row = find.byKey(JournalPage.rowKey(n.id));
    final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
    expect(art.look, Painting(paintingFor(n.id, NightArt.paintings)));
    expect(find.text(dayDigits(n.date)), findsOneWidget);
  });

  // D110: naming a night is removed; a name kept from before is not shown.
  testWidgets('a named night shows only its date', (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 2, 23));
    final name = invented('named-three-dreams-sv').name!;
    // A name reaches the store only directly.
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
    expect(find.text(name), findsNothing);
    expect(find.text(dayDigits(n.date)), findsOneWidget);
  });

  testWidgets('New Dream opens typing; a Save adds a row', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    await tester.tap(find.byKey(JournalPage.newDreamKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    final dream = invented('one-dream-sv').dreams.single;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dream);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    final n = (await h.nights()).single;
    expect(find.text(dayDigits(n.date)), findsOneWidget);
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

  testWidgets("a row hands its night's page whether it is read", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    bool read(Night night) => night.id == n.id;
    await h.pump(tester, JournalPage(journal: h.journal, read: read));
    await tester.tap(find.text(dayDigits(n.date)));
    await tester.pumpAndSettle();
    expect(tester.widget<NightPage>(find.byType(NightPage)).read, same(read));
  });

  testWidgets("a row hands its night's page the menu's item", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    final action = NightAction(label: Lines.MP_65.text(Lang.en), run: (_) async {});
    await h.pump(tester, JournalPage(journal: h.journal, nightAction: action));
    await tester.tap(find.text(dayDigits(n.date)));
    await tester.pumpAndSettle();
    expect(tester.widget<NightPage>(find.byType(NightPage)).action, same(action));
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

  // The final review of journal-screens: New Dream reads the journal before
  // the typing screen opens, so a second tap in that time must open nothing,
  // or one evening's dreams could be split into two nights.
  testWidgets('two quick taps on New Dream open one typing screen', (tester) async {
    final files = SlowFiles();
    final h = await Harness.make(files: files);
    await h.pump(tester, JournalPage(journal: h.journal));
    files.hold = Completer<void>();
    await tester.tap(find.byKey(JournalPage.newDreamKey));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tap(find.byKey(JournalPage.newDreamKey));
    await tester.pump(const Duration(milliseconds: 80));
    files.hold!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage, skipOffstage: false), findsOneWidget);
    // Once the screen is closed, the button opens it again.
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage, skipOffstage: false), findsNothing);
    await tester.tap(find.byKey(JournalPage.newDreamKey));
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

  testWidgets('a failed read at New Dream opens nothing', (tester) async {
    final lines = await logged();
    final files = BrokenFiles();
    final h = await Harness.make(files: files);
    await h.pump(tester, JournalPage(journal: h.journal));
    files.broken = true;
    await tester.tap(find.byKey(JournalPage.newDreamKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect(lines, ['journalListFailed']);
    // The button works again once the folder reads.
    files.broken = false;
    await tester.tap(find.byKey(JournalPage.newDreamKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
  });
}
