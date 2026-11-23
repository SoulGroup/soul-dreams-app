// The journal list (main-path.md, The Journal; S5; D58 Q7; P5; D110): the
// greeting by time of day, New Dream opening the typing screen, no record
// button, the empty journal, rows newest first carrying only the date over
// the night's picture, dividers, a row opening its night.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/greeting.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_action.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/pages/night_art.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/sky_mark.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/journal/sky.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

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

/// The greeting's words at Stockholm's wall [hour] on [day] June 2026.
String greeted(int hour, {int day = 10}) =>
    greetingText(greetingAt((year: 2026, month: 6, day: day, hour: hour)), Lang.en);

void main() {
  testWidgets('the empty journal: the greeting, New Dream and C4-P·5', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.text(greeted(12)), findsOneWidget);
    // MP·11 is New Dream's (C18-P), shown once: the round record button is
    // gone (D110).
    expect(find.text(Lines.MP_11.text(Lang.en)), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
    // No Settings entry: a later branch (D116 item 5). One field, search's.
    expect(find.text(Lines.MP_25.text(Lang.en)), findsNothing);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byKey(JournalPage.searchKey), findsOneWidget);
  });

  // D110: a greeting by the part of the day, centred in h2, heard as a
  // heading, above New Dream; it follows the clock while the page is open.
  testWidgets('the greeting: by the clock, centred, a heading, above New Dream', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final greeting = find.text(greeted(12));
    final text = tester.widget<Text>(greeting);
    expect(text.style!.fontFamily, TypeRoles.h2.family);
    expect(text.style!.fontSize, TypeRoles.h2.size);
    expect(text.textAlign, TextAlign.center);
    expect(tester.getCenter(greeting).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
    expect(tester.getRect(greeting).bottom, lessThan(tester.getRect(find.byKey(JournalPage.newDreamKey)).top));
    final handle = tester.ensureSemantics();
    expect(tester.getSemantics(greeting), matchesSemantics(label: greeted(12), isHeader: true));
    handle.dispose();
    Harness.clock = stockholm(2026, 6, 10, 17);
    await tester.pump(const Duration(minutes: 1));
    expect(find.text(greeted(17)), findsOneWidget);
  });

  // D119 item 4: one line a day, the four in turn; the next day at the same
  // hour, the next line of the same place.
  testWidgets('the greeting: the next day, the next line', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.text(greeted(12)), findsOneWidget);
    Harness.clock = stockholm(2026, 6, 11, 12);
    await tester.pump(const Duration(minutes: 1));
    expect(greeted(12, day: 11), isNot(greeted(12)));
    expect(find.text(greeted(12, day: 11)), findsOneWidget);
    expect(Lines.MP_73.parts(Lang.en), contains(greeted(12, day: 11)));
  });

  // D110: on returning, the greeting follows the clock at once, without
  // waiting for the minute's check (the final review).
  testWidgets('the greeting follows the clock on returning', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.text(greeted(12)), findsOneWidget);
    Harness.clock = stockholm(2026, 6, 10, 17);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text(greeted(17)), findsOneWidget);
    expect(find.text(greeted(12)), findsNothing);
  });

  // D112: above the greeting, a sun from 08:00 to 21:00 and a moon from 21:00
  // to 08:00, drawn in code, heard as nothing; it follows the clock as the
  // greeting does.
  testWidgets('the sun above the greeting by day, centred', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final mark = find.byType(SkyMark);
    expect(tester.widget<SkyMark>(mark).sky, Sky.sun);
    expect(tester.getSize(mark), StandIns.skyMark);
    expect(tester.getCenter(mark).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
    final greeting = tester.getRect(find.text(greeted(12)));
    expect(greeting.top - tester.getRect(mark).bottom, closeTo(StandIns.skyGap, 1));
  });

  testWidgets('the moon at night, and the mark follows the clock', (tester) async {
    final h = await Harness.make();
    // 07:00 and 08:00 are both morning to the greeting: the mark alone moves.
    Harness.clock = stockholm(2026, 6, 10, 7);
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(tester.widget<SkyMark>(find.byType(SkyMark)).sky, Sky.moon);
    Harness.clock = stockholm(2026, 6, 10, 8);
    await tester.pump(const Duration(minutes: 1));
    expect(find.text(greeted(8)), findsOneWidget);
    expect(tester.widget<SkyMark>(find.byType(SkyMark)).sky, Sky.sun);
    Harness.clock = stockholm(2026, 6, 10, 21);
    await tester.pump(const Duration(minutes: 1));
    expect(tester.widget<SkyMark>(find.byType(SkyMark)).sky, Sky.moon);
  });

  testWidgets('the mark follows the clock on returning', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    Harness.clock = stockholm(2026, 6, 10, 21);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(tester.widget<SkyMark>(find.byType(SkyMark)).sky, Sky.moon);
  });

  // D112: a night sky inside the pill, the set's strip (D147 item 3), the
  // words on the date's shade (D113; proved on pixels in paintings_test).
  testWidgets('New Dream: centred, on a night sky, a button', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final button = find.byKey(JournalPage.newDreamKey);
    expect(tester.getCenter(button).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
    expect(find.descendant(of: button, matching: find.byType(NightSky)), findsOneWidget);
    expect(find.descendant(of: button, matching: find.byType(NightArt)), findsNothing);
    final words = tester.widget<Text>(find.text(Lines.MP_11.text(Lang.en)));
    expect(
      find.ancestor(of: find.text(Lines.MP_11.text(Lang.en)), matching: find.byType(DateShade)),
      findsOneWidget,
    );
    expect(words.style!.color, NightArt.over);
    expect(words.style!.fontFamily, TypeRoles.button.family);
    final handle = tester.ensureSemantics();
    expect(tester.getSemantics(button), matchesSemantics(label: Lines.MP_11.text(Lang.en), isButton: true, hasTapAction: true));
    handle.dispose();
  });

  // D125 item 3: the first empty journal shows C4-P·5 and nothing more: no
  // MP·9 under New Dream, and no arrow up to it.
  testWidgets('the first empty journal: no MP·9, no arrow', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
    expect(find.byWidgetPredicate((w) => w is CustomPaint && w.size == const Size(12, 32)), findsNothing);
  });

  // D128 item 3: before the dreamer has agreed, the journal hands that on:
  // the typing screen shows the microphone with its popup, and a night's
  // Start Interpretation shows it too.
  testWidgets('before agreeing: the typing screen and a night are told', (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal, agreed: false));
    await tester.tap(find.byKey(JournalPage.newDreamKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pumpAndSettle();
    expect(find.text(PendingLines.MP_101.text(Lang.en)), findsOneWidget);
    await tester.tap(find.text(PendingLines.MP_102.text(Lang.en)));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackControl).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(JournalPage.rowKey(n.id)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(NightPage.startKey));
    await tester.pumpAndSettle();
    expect(find.text(PendingLines.MP_101.text(Lang.en)), findsOneWidget);
  });

  testWidgets('a later empty journal has no MP·9', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
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
    final newDate = tester.getTopLeft(find.text(shownDate(newer.date)));
    final oldDate = tester.getTopLeft(find.text(shownDate(older.date)));
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
  // D113: a soft dark shade behind the date over a painting, none over the
  // painted gradient.
  testWidgets("a read row shades its date; an unread one does not", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal, read: allRead));
    final row = find.byKey(JournalPage.rowKey(n.id));
    expect(find.descendant(of: row, matching: find.byType(DateShade)), findsOneWidget);
    expect(find.descendant(of: find.byType(DateShade), matching: find.text(shownDate(n.date))), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await h.pump(tester, JournalPage(journal: h.journal));
    // New Dream's words keep theirs (D147 item 3); the row has none.
    expect(find.descendant(of: find.byKey(JournalPage.rowKey(n.id)), matching: find.byType(DateShade)), findsNothing);
    expect(find.byType(DateShade), findsOneWidget);
  });

  testWidgets("a row: the date over an unread night's gradient", (tester) async {
    final h = await Harness.make();
    final older = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    final newer = await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final arts = find.descendant(of: find.byType(ListView), matching: find.byType(NightArt));
    // One per row; New Dream's is the night sky.
    expect(arts, findsNWidgets(2));
    for (final n in [older, newer]) {
      final date = find.text(shownDate(n.date));
      final row = find.ancestor(of: date, matching: find.byKey(JournalPage.rowKey(n.id)));
      final art = find.descendant(of: row, matching: find.byType(NightArt));
      expect(tester.widget<NightArt>(art).look, const PaintedGradient());
      expect(tester.getRect(art), tester.getRect(row));
      expect(tester.getCenter(date).dx, closeTo(tester.getCenter(row).dx, 1));
      expect(tester.getCenter(date).dy, closeTo(tester.getCenter(row).dy, 1));
      final style = tester.widget<Text>(date).style!;
      expect(style.color, NightArt.over);
      // type.row.date (C18-P; D118: Inter, 20, semibold).
      expect(style.fontFamily, 'Inter');
      expect(style.fontWeight, FontWeight.w600);
      expect(style.fontSize, 20);
      expect(tester.getSize(row).height, StandIns.rowHeight);
      final clip = tester.widget<ClipRRect>(find.descendant(of: row, matching: find.byType(ClipRRect)));
      expect(clip.borderRadius, BorderRadius.circular(Spacing.radius));
    }
    final width = tester.getSize(find.byType(JournalPage)).width;
    final first = tester.getRect(find.byKey(JournalPage.rowKey(newer.id)));
    final second = tester.getRect(find.byKey(JournalPage.rowKey(older.id)));
    expect(first.left, closeTo(48, 1));
    expect(first.right, closeTo(width - 48, 1));
    expect(second.top - first.bottom, closeTo(Spacing.journalRow, 1));
    final handle = tester.ensureSemantics();
    expect(
      tester.getSemantics(find.byKey(JournalPage.rowKey(older.id))),
      matchesSemantics(label: shownDate(older.date), isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  // D115 (P13): rows 48 across from each side, 100 more above the greeting.
  testWidgets('rows 48 from each side, 140 above the greeting', (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(StandIns.rowSide, 48);
    expect(StandIns.greetingAbove, 140);
    final width = tester.getSize(find.byType(JournalPage)).width;
    final row = tester.getRect(find.byKey(JournalPage.rowKey(n.id)));
    expect(row.left, closeTo(48, 1));
    expect(row.right, closeTo(width - 48, 1));
    // New Dream and the greeting keep the page's own margin and centre.
    expect(tester.getCenter(find.byKey(JournalPage.newDreamKey)).dx, closeTo(width / 2, 1));
    final top = tester.getRect(find.byType(ListView)).top;
    expect(tester.getRect(find.byType(SkyMark)).top - top, closeTo(140, 1));
  });

  // D115: a thin grey border round every row, the gradient's too, in both
  // themes: #9E9E9E in the light theme, #8A8A8A in the dark one. Proved on
  // pixels: the row's own edge is the border, one point wide.
  Future<ByteData> picture(WidgetTester tester, Finder boundary) async {
    late ByteData data;
    await tester.runAsync(() async {
      final render = tester.renderObject<RenderRepaintBoundary>(boundary);
      final image = await render.toImage(pixelRatio: 1);
      data = (await image.toByteData())!;
    });
    return data;
  }

  int rgb(ByteData data, int width, int x, int y) => data.getUint32((y * width + x) * 4) >> 8;

  for (final theme in [(hour: 12, grey: 0x9E9E9E), (hour: 22, grey: 0x8A8A8A)]) {
    testWidgets('every row has a 1 pt grey border, hour ${theme.hour}', (tester) async {
      final h = await Harness.make();
      final unread = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
      final read = await keep(h, 'one-dream-sv', stockholm(2026, 6, 3, 23));
      await h.pump(tester, JournalPage(journal: h.journal, read: (n) => n.id == read.id), hour: theme.hour);
      expect(StandIns.rowBorderWidth, 1);
      for (final n in [unread, read]) {
        final row = find.byKey(JournalPage.rowKey(n.id));
        final box = find.ancestor(of: row, matching: find.byType(RepaintBoundary)).first;
        final rect = tester.getRect(row);
        final data = await picture(tester, box);
        final width = tester.getSize(box).width.round();
        final left = (rect.left - tester.getRect(box).left).round();
        final top = (rect.top - tester.getRect(box).top).round();
        final mid = top + (rect.height / 2).round();
        final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
        expect(art.look, n.id == read.id ? isA<Painting>() : const PaintedGradient());
        // The edge, left and right, and the middle of the top: the grey.
        expect(rgb(data, width, left, mid), theme.grey, reason: 'left edge');
        expect(rgb(data, width, left + rect.width.round() - 1, mid), theme.grey, reason: 'right edge');
        expect(rgb(data, width, left + rect.width ~/ 2, top), theme.grey, reason: 'top edge');
        // One point wide: the next pixel in is the picture.
        expect(rgb(data, width, left + 1, mid), isNot(theme.grey), reason: 'one wide');
        expect(tester.getSize(row).height, StandIns.rowHeight);
      }
    });
  }

  testWidgets("a read night's row shows its painting", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal, read: (_) => true));
    final row = find.byKey(JournalPage.rowKey(n.id));
    final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
    expect(art.look, Painting(paintingFor(n.id, NightArt.paintings)));
    expect(find.text(shownDate(n.date)), findsOneWidget);
  });

  // D121 item 3: Night images Off, a read night's row shows the gradient,
  // and its page is handed the same.
  testWidgets("with Night images Off, a read row shows the gradient", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal, read: (_) => true, images: false));
    final row = find.byKey(JournalPage.rowKey(n.id));
    final art = tester.widget<NightArt>(find.descendant(of: row, matching: find.byType(NightArt)));
    expect(art.look, const PaintedGradient());
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(tester.widget<NightPage>(find.byType(NightPage)).images, isFalse);
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
    expect(find.text(shownDate(n.date)), findsOneWidget);
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
    expect(find.text(shownDate(n.date)), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.C4_P_5.text(Lang.en)), findsNothing);
  });

  testWidgets("a row opens its night's page", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    await tester.tap(find.text(shownDate(n.date)));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsOneWidget);
    expect(find.text(n.dreams[1]), findsOneWidget);
  });

  testWidgets("a row hands its night's page whether it is read", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    bool read(Night night) => night.id == n.id;
    await h.pump(tester, JournalPage(journal: h.journal, read: read));
    await tester.tap(find.text(shownDate(n.date)));
    await tester.pumpAndSettle();
    expect(tester.widget<NightPage>(find.byType(NightPage)).read, same(read));
  });

  testWidgets("a row hands its night's page the menu's item", (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    final action = NightAction(label: Lines.MP_65.text(Lang.en), run: (_) async {});
    await h.pump(tester, JournalPage(journal: h.journal, nightAction: action));
    await tester.tap(find.text(shownDate(n.date)));
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
    expect(find.text(shownDate(n.date)), findsOneWidget);
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
