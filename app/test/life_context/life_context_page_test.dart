// "What you've told Soul Dreams" (MP·86 to MP·92; C159-I item 1; D110,
// head's message 24 item 2; D131), opened from Settings: the two lists,
// each sentence quoted and dated, edit and delete, the menu, selecting,
// Delete all, the empty line; every deletion behind C4-P·4. The sentences
// are the invented passages' (fixtures/invented-nights.json, R2).
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/pages/journal_home.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/life_context/kept.dart';
import 'package:souldreams/life_context/life_context_page.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';
import 'package:souldreams/settings/settings_page.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';

String en(Line line, [int part = 0]) => line.parts(Lang.en)[part];

void main() {
  late MemoryJournalFiles files;
  late Journal journal;
  late List<Night> nights;
  final passages = [for (final n in inventedNights()) ...n.waking];

  // The journal's home, Life Context [on], the window [length]; the
  // passages [days] back kept into the first nights; then Settings, then
  // the page.
  Future<void> open(
    WidgetTester tester, {
    bool on = true,
    bool agreed = true,
    LifeContextLength length = LifeContextLength.twoWeeks,
    List<int> days = const [1, 3],
    bool page = true,
    bool dark = false,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    JournalStore.newQueueForTests();
    files = MemoryJournalFiles();
    files.files[JournalStore.consentFile] = encodeConsents(
      Consents.answered({Consent.readings: agreed, Consent.lifeContext: on}, DateTime.utc(2026)),
    );
    files.files[JournalStore.settingsFile] = encodeSettings(Settings(length: length));
    final store = await JournalStore.open(files);
    nights = nightsFromFixtures();
    for (final n in nights) {
      await store.save(n);
    }
    for (final (i, d) in days.indexed) {
      final at = DateTime.now().toUtc().subtract(Duration(days: d));
      await Journal(store, now: () => at).keep(nights[i].id, passages[i].text);
    }
    journal = Journal(store);
    await tester.pumpWidget(
      SoulDreamsApp(
        clock: () => dark ? DateTime(2026, 6, 10, 23) : DateTime(2026, 6, 10, 12),
        home: JournalHome(files: files),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(JournalPage.gearKey));
    await tester.pumpAndSettle();
    if (!page) return;
    await tester.ensureVisible(find.byKey(SettingsPage.keptKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SettingsPage.keptKey));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  Future<List<Kept>> kept() async => newestFirst(await journal.kept());

  testWidgets('from Settings, the kept row opens the page, titled in h2', (tester) async {
    await open(tester);
    expect(find.byType(LifeContextPage), findsOneWidget);
    final title = tester.widget<Text>(find.text(en(Lines.MP_86)));
    expect(title.style!.fontFamily, TypeRoles.h2.family);
    expect(title.style!.fontSize, TypeRoles.h2.size);
  });

  testWidgets('before agreeing, the kept row shows the popup, opens nothing', (tester) async {
    await open(tester, agreed: false, on: false, days: const [], page: false);
    await tap(tester, find.byKey(SettingsPage.keptKey));
    expect(find.byType(LifeContextPage), findsNothing);
    expect(find.text(PendingLines.MP_101.text(Lang.en)), findsOneWidget);
  });

  testWidgets('nothing kept: MP·92 alone, no lists, menu or Delete all', (tester) async {
    await open(tester, days: const []);
    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
    expect(tester.widget<AppLine>(find.byKey(LifeContextPage.emptyKey)).text, en(Lines.MP_92));
    expect(find.text(en(Lines.MP_87)), findsNothing);
    expect(find.byKey(LifeContextPage.menuKey), findsNothing);
    expect(find.byKey(LifeContextPage.deleteAllKey), findsNothing);
  });

  testWidgets('the lists: Kept longer empty; Recent newest first, quoted, dated', (tester) async {
    await open(tester, length: LifeContextLength.oneMonth, days: const [3, 1, 40]);
    final longer = tester.getCenter(find.text(en(Lines.MP_87, 0))).dy;
    final recent = tester.getCenter(find.text(en(Lines.MP_87, 3))).dy;
    expect(longer, lessThan(recent));
    for (final i in [1, 2, 4]) {
      expect(find.text(en(Lines.MP_87, i)), findsNothing);
    }
    final shown = (await kept()).where((k) => passages[2].sentences.every((s) => s != k.text)).toList();
    expect(shown, hasLength(passages[0].sentences.length + passages[1].sentences.length));
    final ys = <double>[];
    for (final k in shown) {
      final words = find.text(quoted(k.text));
      expect(words, findsOneWidget);
      expect(tester.getCenter(words).dy, greaterThan(recent));
      ys.add(tester.getCenter(words).dy);
      final date = find.descendant(
        of: find.byKey(LifeContextPage.sentenceKey(k.id)),
        matching: find.text(shownDate(k.day)),
      );
      expect(date, findsOneWidget);
      expect(tester.getCenter(date).dy, greaterThan(tester.getCenter(words).dy));
      expect(tester.widget<Text>(date).style!.color, LightColours.lifecontextDate.colour);
      expect(tester.widget<Text>(date).style!.fontSize, TypeRoles.buttonSmall.size);
    }
    expect(ys, [...ys]..sort());
    expect(shown.first.text, passages[1].sentences.first);
    for (final s in passages[2].sentences) {
      expect(find.text(quoted(s)), findsNothing);
    }
    expect(quoted(passages[0].sentences.first), '“${passages[0].sentences.first}”');
  });

  testWidgets('each sentence: edit left, delete right in terracotta, heard', (tester) async {
    await open(tester);
    final k = (await kept()).first;
    final box = tester.getRect(find.byKey(LifeContextPage.sentenceKey(k.id)));
    final edit = tester.getCenter(find.byKey(LifeContextPage.editKey(k.id)));
    final delete = tester.getCenter(find.byKey(LifeContextPage.deleteKey(k.id)));
    final words = tester.getCenter(find.text(quoted(k.text)));
    expect(edit.dx, lessThan(words.dx));
    expect(delete.dx, greaterThan(words.dx));
    expect(box.contains(edit) && box.contains(delete), isTrue);
    expect(tester.getSemantics(find.byKey(LifeContextPage.editKey(k.id))).label, en(Lines.MP_89, 0));
    expect(tester.getSemantics(find.byKey(LifeContextPage.deleteKey(k.id))).label, en(Lines.MP_89, 1));
    final icon = tester.widget<Icon>(
      find.descendant(of: find.byKey(LifeContextPage.deleteKey(k.id)), matching: find.byType(Icon)),
    );
    expect(icon.color, LightColours.lifecontextDelete.colour);
    final decoration =
        tester.widget<DecoratedBox>(find.byKey(LifeContextPage.sentenceKey(k.id))).decoration as BoxDecoration;
    expect((decoration.gradient! as LinearGradient).colors, [Palette.light.keptTop, Palette.light.keptBottom]);
    expect(Palette.light.keptTop, LightColours.lifecontextBox.colour);
  });

  testWidgets('the dark theme: the dark box, its date, the proposed delete', (tester) async {
    await open(tester, dark: true);
    final k = (await kept()).first;
    final icon = tester.widget<Icon>(
      find.descendant(of: find.byKey(LifeContextPage.deleteKey(k.id)), matching: find.byType(Icon)),
    );
    expect(icon.color, StandIns.keptDeleteDark);
    expect(StandIns.keptDeleteDark, const Color(0xFFD0775A));
    final date = find.descendant(
      of: find.byKey(LifeContextPage.sentenceKey(k.id)),
      matching: find.text(shownDate(k.day)),
    );
    expect(tester.widget<Text>(date).style!.color, DarkColours.lifecontextDate.colour);
    expect(tester.widget<Text>(find.text(quoted(k.text))).style!.color, DarkColours.lifecontextText.colour);
    expect(Palette.dark.keptBottom, DarkColours.lifecontextBox.colourEnd);
  });

  testWidgets('delete one: C4-P·4 once; Cancel keeps it, Delete takes it', (tester) async {
    await open(tester);
    final [k, ...rest] = await kept();
    await tap(tester, find.byKey(LifeContextPage.deleteKey(k.id)));
    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
    final cancel = find.ancestor(of: find.text(en(Lines.MP_61)), matching: find.byType(CupertinoDialogAction));
    final go = find.ancestor(of: find.text(en(Lines.MP_60)), matching: find.byType(CupertinoDialogAction));
    expect(tester.widget<CupertinoDialogAction>(go).isDestructiveAction, isTrue);
    expect(tester.widget<CupertinoDialogAction>(cancel).isDestructiveAction, isFalse);
    await tester.tap(find.text(en(Lines.MP_61)));
    await tester.pumpAndSettle();
    expect((await kept()).first, k);
    await tap(tester, find.byKey(LifeContextPage.deleteKey(k.id)));
    await tester.tap(find.text(en(Lines.MP_60)));
    await tester.pumpAndSettle();
    expect(await kept(), rest);
    expect(find.text(quoted(k.text)), findsNothing);
  });

  testWidgets('Delete all asks once, then MP·92', (tester) async {
    await open(tester);
    final all = find.byKey(LifeContextPage.deleteAllKey);
    expect(find.descendant(of: all, matching: find.text(en(Lines.MP_91))), findsOneWidget);
    await tap(tester, all);
    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
    await tester.tap(find.text(en(Lines.MP_60)));
    await tester.pumpAndSettle();
    expect(await journal.kept(), isEmpty);
    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
  });

  testWidgets('the menu: Select sentences and Delete the Recent list only', (tester) async {
    await open(tester);
    await tap(tester, find.byKey(LifeContextPage.menuKey));
    expect(
      find.descendant(of: find.byKey(LifeContextPage.selectKey), matching: find.text(en(Lines.MP_88, 0))),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byKey(LifeContextPage.deleteRecentKey), matching: find.text(en(Lines.MP_88, 2))),
      findsOneWidget,
    );
    // Kept longer holds nothing (D131 item 5): no deletion of it.
    expect(find.byKey(LifeContextPage.deleteLongerKey), findsNothing);
    await tester.tap(find.byKey(LifeContextPage.deleteRecentKey));
    await tester.pumpAndSettle();
    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
    await tester.tap(find.text(en(Lines.MP_60)));
    await tester.pumpAndSettle();
    expect(await journal.kept(), isEmpty);
    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
  });

  testWidgets('selecting: each box toggles; Delete selected (n); back leaves', (tester) async {
    await open(tester);
    final [a, b, ...rest] = await kept();
    await tap(tester, find.byKey(LifeContextPage.menuKey));
    await tester.tap(find.byKey(LifeContextPage.selectKey));
    await tester.pumpAndSettle();
    expect(find.byKey(LifeContextPage.editKey(a.id)), findsNothing);
    expect(find.byKey(LifeContextPage.deleteKey(a.id)), findsNothing);
    expect(find.byKey(LifeContextPage.menuKey), findsNothing);
    final selected = find.byKey(LifeContextPage.deleteSelectedKey);
    expect(find.descendant(of: selected, matching: find.text(en(Lines.MP_90(n: 0)))), findsOneWidget);
    await tap(tester, selected);
    expect(find.text(en(Lines.C4_P_4)), findsNothing);
    await tap(tester, find.byKey(LifeContextPage.wordsKey(a.id)));
    await tap(tester, find.byKey(LifeContextPage.wordsKey(b.id)));
    await tap(tester, find.byKey(LifeContextPage.wordsKey(b.id)));
    await tap(tester, find.byKey(LifeContextPage.wordsKey(rest.first.id)));
    expect(find.descendant(of: selected, matching: find.text(en(Lines.MP_90(n: 2)))), findsOneWidget);
    expect(find.byType(NightPage), findsNothing);
    await tap(tester, selected);
    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
    await tester.tap(find.text(en(Lines.MP_60)));
    await tester.pumpAndSettle();
    expect(await kept(), [b, ...rest.skip(1)]);
    // The back control leaves selecting first, then the page.
    await tap(tester, find.descendant(of: find.byType(LifeContextPage), matching: find.byType(BackControl)));
    expect(find.byKey(LifeContextPage.deleteAllKey), findsOneWidget);
    expect(find.byType(LifeContextPage), findsOneWidget);
  });

  testWidgets('edit: the field holds the words; Done keeps only the copy', (tester) async {
    await open(tester);
    final k = (await kept()).first;
    await tap(tester, find.byKey(LifeContextPage.editKey(k.id)));
    expect(tester.widget<TextField>(find.byKey(LifeContextPage.fieldKey)).controller!.text, k.text);
    await tester.enterText(find.byKey(LifeContextPage.fieldKey), passages[2].sentences.first);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byKey(LifeContextPage.fieldKey), findsNothing);
    final edited = (await kept()).firstWhere((e) => e.id == k.id);
    expect(edited.text, passages[2].sentences.first);
    expect(find.text(quoted(passages[2].sentences.first)), findsOneWidget);
    expect(await journal.night(k.night), nights.firstWhere((n) => n.id == k.night));
  });

  testWidgets('an edit emptied asks C4-P·4; Cancel keeps the sentence', (tester) async {
    await open(tester);
    final [k, ...rest] = await kept();
    await tap(tester, find.byKey(LifeContextPage.editKey(k.id)));
    await tester.enterText(find.byKey(LifeContextPage.fieldKey), '  ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
    await tester.tap(find.text(en(Lines.MP_61)));
    await tester.pumpAndSettle();
    expect((await kept()).first, k);
    await tap(tester, find.byKey(LifeContextPage.editKey(k.id)));
    await tester.enterText(find.byKey(LifeContextPage.fieldKey), '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.text(en(Lines.MP_60)));
    await tester.pumpAndSettle();
    expect(await kept(), rest);
  });

  testWidgets('tapping a sentence opens its night', (tester) async {
    await open(tester);
    final k = (await kept()).first;
    await tap(tester, find.byKey(LifeContextPage.wordsKey(k.id)));
    expect(find.byType(NightPage), findsOneWidget);
    expect(tester.widget<NightPage>(find.byType(NightPage)).id, k.night);
    expect(tester.widget<NightPage>(find.byType(NightPage)).query, isNull);
  });

  testWidgets('Life Context turned off in Settings: the page shows MP·92', (tester) async {
    await open(tester, page: false);
    await tester.ensureVisible(find.byKey(SettingsPage.valueKey(SettingRow.lifeContext)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SettingsPage.valueKey(SettingRow.lifeContext)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SettingsPage.choiceKey(SettingRow.lifeContext, 1)));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en(Lines.MP_94)));
    await tester.pumpAndSettle();
    expect(await journal.kept(), isEmpty);
    await tap(tester, find.byKey(SettingsPage.keptKey));
    expect(find.byKey(LifeContextPage.emptyKey), findsOneWidget);
  });

  testWidgets('at the largest text, nothing overflows', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester);
    expect(tester.takeException(), isNull);
    await tap(tester, find.byKey(LifeContextPage.deleteAllKey));
    expect(tester.takeException(), isNull);
  });
}
