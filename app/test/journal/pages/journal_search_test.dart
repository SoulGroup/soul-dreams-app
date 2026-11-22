// The journal's search (D110; D116; D117 Q2 to Q8): the field at the top
// with EM·4, from three characters the count (MP·76) or W25, only the
// matching nights' rows, newest first, each with its context line, the match
// in Inter Bold.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_rules.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/sky_mark.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/journal/search.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings_controller.dart';
import 'package:souldreams/settings/settings_page.dart';
import 'package:souldreams/words/lines.g.dart';

import '../../fixtures.dart';
import '../zones.dart';
import 'harness.dart';

Future<List<Night>> three(Harness h) async => [
  await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23)),
  await keep(h, 'one-dream-sv', stockholm(2026, 6, 4, 23)),
  await keep(h, 'named-three-dreams-sv', stockholm(2026, 6, 6, 23)),
];

Future<void> type(WidgetTester tester, String words) async {
  await tester.enterText(find.byKey(JournalPage.searchKey), words);
  await tester.pumpAndSettle();
}

Finder row(Night n) => find.byKey(JournalPage.rowKey(n.id));

/// The invented night 'two-dreams-en' with three marks written into its
/// first dream: a straight apostrophe, curly double quotes and an en dash
/// (D120). Its words are the fixture's, a few of them changed.
Future<Night> keepMarked(Harness h, DateTime at) async {
  final text = invented('two-dreams-en').dreams.first
      .replaceFirst('lighthouse', "lighthouse's")
      .replaceFirst('wheat', '\u201cwheat\u201d')
      .replaceFirst('even though', 'even \u2013 though');
  await h.journal.addDream(NewNight(at), text, Lang.en);
  return (await h.nights()).firstWhere((x) => x.firstRecorded == at);
}

/// A phone's screen, 390 by 844, tall enough that every row is built, so a
/// row left out is truly left out.
void phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('the field: EM·4 at the top, as wide as a row', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.text(Lines.EM_4.text(Lang.en)), findsOneWidget);
    final width = tester.getSize(find.byType(JournalPage)).width;
    final top = tester.getRect(find.byType(ListView)).top;
    final field = tester.getRect(find.byKey(JournalPage.searchFieldKey));
    expect(field.top - top, closeTo(StandIns.searchAbove, 1));
    expect(field.height, closeTo(Spacing.sizeFieldSearch, 1));
    expect(field.left, closeTo(StandIns.rowSide, 1));
    expect(field.right, closeTo(width - StandIns.rowSide, 1));
    // The sky mark stays where it was, below it.
    expect(tester.getRect(find.byType(SkyMark)).top - top, closeTo(StandIns.greetingAbove, 1));
  });

  // D122: with the settings, the gear stands top left, the field under it,
  // and the sky mark stays 140 down; the gear opens Settings, spoken MP·25.
  testWidgets('the gear: top left, the field under it', (tester) async {
    final h = await Harness.make();
    final settings = SettingsController(h.journal, consents: Consents.answered({}, DateTime.utc(2026)));
    await h.pump(tester, JournalPage(journal: h.journal, settings: settings));
    final top = tester.getRect(find.byType(ListView)).top;
    final gear = tester.getRect(find.byKey(JournalPage.gearKey));
    final field = tester.getRect(find.byKey(JournalPage.searchFieldKey));
    expect(gear.top - top, closeTo(StandIns.searchAbove, 1));
    expect(gear.left, closeTo(Spacing.pageSide, 1));
    expect(gear.size, const Size.square(StandIns.hitMin));
    expect(field.top - gear.bottom, closeTo(StandIns.gearBelow, 1));
    expect(tester.getRect(find.byType(SkyMark)).top - top, closeTo(StandIns.greetingAbove, 1));
    expect(tester.getSemantics(find.byKey(JournalPage.gearKey)).label, Lines.MP_25.text(Lang.en));
    await tester.tap(find.byKey(JournalPage.gearKey));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(tester.widget<SettingsPage>(find.byType(SettingsPage)).settings, same(settings));
  });

  testWidgets('with no settings, no gear', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    expect(find.byKey(JournalPage.gearKey), findsNothing);
  });

  testWidgets('the field suggests and corrects nothing', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final f = tester.widget<TextField>(find.byKey(JournalPage.searchKey));
    expect(f.autocorrect, isFalse);
    expect(f.enableSuggestions, isFalse);
    expect(f.textInputAction, TextInputAction.search);
    expect(f.decoration!.hintText, Lines.EM_4.text(Lang.en));
  });

  testWidgets('smart quotes and dashes stay on; the matcher folds them (D120)', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final f = tester.widget<TextField>(find.byKey(JournalPage.searchKey));
    expect(f.smartQuotesType, isNot(SmartQuotesType.disabled));
    expect(f.smartDashesType, isNot(SmartDashesType.disabled));
  });

  testWidgets('the magnifier is heard as nothing', (tester) async {
    final h = await Harness.make();
    await h.pump(tester, JournalPage(journal: h.journal));
    final magnifier = find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter.runtimeType.toString() == '_Magnifier',
    );
    expect(magnifier, findsOneWidget);
    final silent = find.byWidgetPredicate((w) => w is ExcludeSemantics && w.excluding && w.child is SizedBox);
    expect(find.descendant(of: silent, matching: magnifier), findsOneWidget);
  });

  testWidgets('a typed curly mark finds a straight one, and the reverse', (tester) async {
    phone(tester);
    final h = await Harness.make();
    final marked = await keepMarked(h, stockholm(2026, 6, 2, 23));
    final sv = await keep(h, 'one-dream-sv', stockholm(2026, 6, 4, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    // Typed curly, written straight.
    await type(tester, 'lighthouse\u2019s');
    expect(row(marked), findsOneWidget);
    expect(row(sv), findsNothing);
    final line = tester.widget<Text>(find.byKey(JournalPage.contextKey(marked.id)));
    final parts = (line.textSpan! as TextSpan).children!.cast<TextSpan>();
    expect(parts[1].text, "lighthouse's");
    // Typed straight, written curly: the bold is the text's own marks.
    await type(tester, '"wheat"');
    expect(row(marked), findsOneWidget);
    final curly = tester.widget<Text>(find.byKey(JournalPage.contextKey(marked.id)));
    expect(((curly.textSpan! as TextSpan).children!.cast<TextSpan>())[1].text, '\u201cwheat\u201d');
    // Typed straight, written as an en dash.
    await type(tester, 'even - though');
    expect(row(marked), findsOneWidget);
    // A different mark is a different word.
    await type(tester, 'lighthouse\u201cs');
    expect(row(marked), findsNothing);
    expect(find.text(Lines.W25.text(Lang.en)), findsOneWidget);
  });

  testWidgets('only the months with a match keep their divider', (tester) async {
    phone(tester);
    final h = await Harness.make();
    final en = await keep(h, 'two-dreams-en', stockholm(2026, 5, 20, 23));
    final sv = await keep(h, 'one-dream-sv', stockholm(2026, 6, 4, 23));
    final named = await keep(h, 'named-three-dreams-sv', stockholm(2026, 7, 6, 23));
    await h.pump(tester, JournalPage(journal: h.journal));
    final year = h.journal.zone.wall(h.journal.now()).year;
    Finder month(int m) => find.text(monthDivider(2026, m, year, Lang.en));
    for (final m in [5, 6, 7]) {
      expect(month(m), findsOneWidget);
    }
    await type(tester, 'glas');
    expect(month(5), findsNothing);
    expect(month(6), findsOneWidget);
    expect(month(7), findsOneWidget);
    expect(row(en), findsNothing);
    expect(row(sv), findsOneWidget);
    expect(row(named), findsOneWidget);
    await type(tester, 'lighth');
    expect(month(5), findsOneWidget);
    expect(month(6), findsNothing);
    expect(month(7), findsNothing);
  });

  testWidgets('under three characters, every night as before', (tester) async {
    phone(tester);
    final h = await Harness.make();
    final nights = await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, ' gl ');
    for (final n in nights) {
      expect(row(n), findsOneWidget);
    }
    expect(find.byKey(JournalPage.countKey), findsNothing);
    expect(find.byKey(JournalPage.contextKey(nights.first.id)), findsNothing);
  });

  testWidgets('from three characters: the count and only the matching rows', (tester) async {
    phone(tester);
    final h = await Harness.make();
    final [en, sv, named] = await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, 'GLAS');
    expect(find.text(Lines.MP_76(n: 2).parts(Lang.en).last), findsOneWidget);
    expect(row(en), findsNothing);
    expect(row(sv), findsOneWidget);
    expect(row(named), findsOneWidget);
    // Newest first, under the count.
    final count = tester.getRect(find.byKey(JournalPage.countKey));
    expect(tester.getRect(row(named)).top, greaterThan(count.bottom));
    expect(tester.getRect(row(sv)).top, greaterThan(tester.getRect(row(named)).bottom));
  });

  testWidgets('one night: MP·76; none: W25 and no row', (tester) async {
    phone(tester);
    final h = await Harness.make();
    final [en, sv, named] = await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, 'lighth');
    expect(find.text(Lines.MP_76(n: 1).parts(Lang.en).first), findsOneWidget);
    expect(row(en), findsOneWidget);
    await type(tester, 'zzz');
    expect(find.text(Lines.W25.text(Lang.en)), findsOneWidget);
    for (final n in [en, sv, named]) {
      expect(row(n), findsNothing);
    }
    expect(find.text(Lines.C4_P_5.text(Lang.en)), findsNothing);
  });

  testWidgets('the count: the button type, centred', (tester) async {
    final h = await Harness.make();
    await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, 'glas');
    final count = find.byKey(JournalPage.countKey);
    final text = tester.widget<Text>(find.descendant(of: count, matching: find.byType(Text)));
    expect(text.style!.fontFamily, TypeRoles.button.family);
    expect(tester.getCenter(count).dx, closeTo(tester.getSize(find.byType(JournalPage)).width / 2, 1));
  });

  testWidgets('back under three characters, the journal returns', (tester) async {
    phone(tester);
    final h = await Harness.make();
    final nights = await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, 'glas');
    await type(tester, 'gl');
    for (final n in nights) {
      expect(row(n), findsOneWidget);
    }
    expect(find.byKey(JournalPage.countKey), findsNothing);
  });

  testWidgets('a context line under its row, the match in Bold', (tester) async {
    final h = await Harness.make();
    final [_, sv, _] = await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, 'tåg');
    final line = find.byKey(JournalPage.contextKey(sv.id));
    expect(tester.getRect(line).top, greaterThan(tester.getRect(row(sv)).bottom));
    final text = tester.widget<Text>(line);
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.style!.fontFamily, TypeRoles.button.family);
    expect(text.style!.color, Palette.light.summary);
    final c = contextOf(sv.dreams.first, firstMatch(sv.dreams.first, 'tåg')!);
    final parts = (text.textSpan! as TextSpan).children!.cast<TextSpan>();
    expect([for (final s in parts) s.text], [c.before, c.match, c.after]);
    expect(parts[1].style!.fontWeight, FontWeight.w700);
    expect(parts[0].style, isNull);
    expect(parts[2].style, isNull);
  });

  testWidgets('a result opens its night', (tester) async {
    final h = await Harness.make();
    final [_, sv, _] = await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, ' citron ');
    await tester.tap(find.text(shownDate(sv.date)));
    await tester.pumpAndSettle();
    final page = tester.widget<NightPage>(find.byType(NightPage));
    expect(page.id, sv.id);
    // The query as searched, for the match in bold (D117 Q6).
    expect(page.query, 'citron');
  });

  testWidgets('a row opened with no search hands no query', (tester) async {
    final h = await Harness.make();
    final [_, sv, _] = await three(h);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, 'ci');
    await tester.tap(find.text(shownDate(sv.date)));
    await tester.pumpAndSettle();
    expect(tester.widget<NightPage>(find.byType(NightPage)).query, isNull);
  });

  testWidgets('a search at twice the size does not overflow', (tester) async {
    final h = await Harness.make();
    await three(h);
    await keep(h, 'long-dream-en', stockholm(2026, 6, 8, 23));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await h.pump(tester, JournalPage(journal: h.journal));
    await type(tester, 'the');
    expect(tester.takeException(), isNull);
  });
}
