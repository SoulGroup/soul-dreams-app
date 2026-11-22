// Settings (main-path.md, Settings; D110; D121; D122): the rows, their
// choices and what each needs; the quick toggle; Withdraw and Give consent;
// Delete journal. Invented nights only.
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/night_day.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/pages/journal_home.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/onboarding/disclosure_page.dart';
import 'package:souldreams/onboarding/onboarding.dart';
import 'package:souldreams/settings/consent_page.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/sky_mark.dart';
import 'package:souldreams/journal/sky.dart';
import 'package:souldreams/settings/settings.dart';
import 'package:souldreams/settings/settings_controller.dart';
import 'package:souldreams/settings/settings_page.dart';
import 'package:souldreams/words/lines.g.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';

String en(Line line, [int part = 0]) => line.parts(Lang.en)[part];

/// A phone-sized view, so the page lays out as on the phone.
void phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// A folder whose rename fails while [failing].
final class Flaky extends MemoryJournalFiles {
  bool failing = false;

  @override
  Future<void> rename(String from, String to) async =>
      failing ? throw StateError('journal-io') : super.rename(from, to);
}

void main() {
  late MemoryJournalFiles files;

  // The journal's home with [given] consents, at [hour], then Settings
  // opened from the gear.
  Future<SettingsController> open(
    WidgetTester tester, {
    Map<Consent, bool> given = const {Consent.readings: true},
    int hour = 12,
    MemoryJournalFiles? folder,
  }) async {
    phone(tester);
    JournalStore.newQueueForTests();
    addTearDown(() => wordAnimation = true);
    files = folder ?? MemoryJournalFiles();
    files.files[JournalStore.consentFile] = encodeConsents(Consents.answered(given, DateTime.utc(2026)));
    final store = await JournalStore.open(files);
    await store.save(nightsFromFixtures().first);
    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, hour), home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(JournalPage.gearKey));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsPage), findsOneWidget);
    return tester.widget<SettingsPage>(find.byType(SettingsPage)).settings;
  }

  Future<void> choose(WidgetTester tester, SettingRow row, int index) async {
    await tester.ensureVisible(find.byKey(SettingsPage.valueKey(row)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SettingsPage.valueKey(row)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SettingsPage.choiceKey(row, index)));
    await tester.pumpAndSettle();
  }

  Future<void> hit(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
  }

  String shown(WidgetTester tester, SettingRow row) =>
      tester.widget<Text>(find.descendant(of: find.byKey(SettingsPage.valueKey(row)), matching: find.byType(Text))).data!;

  Map<String, dynamic> kept(String name) => jsonDecode(utf8.decode(files.files[name]!)) as Map<String, dynamic>;

  // A confirmation: Cancel (MP·61) before [yes], which is the destructive one.
  void cancelFirst(WidgetTester tester, Line yes) {
    final cancel = tester.getCenter(find.text(en(Lines.MP_61)));
    final go = tester.getCenter(find.text(en(yes)));
    expect(cancel.dy < go.dy || (cancel.dy == go.dy && cancel.dx < go.dx), isTrue);
    final action = find.ancestor(of: find.text(en(yes)), matching: find.byType(CupertinoDialogAction));
    expect(tester.widget<CupertinoDialogAction>(action).isDestructiveAction, isTrue);
    final back = find.ancestor(of: find.text(en(Lines.MP_61)), matching: find.byType(CupertinoDialogAction));
    expect(tester.widget<CupertinoDialogAction>(back).isDestructiveAction, isFalse);
  }

  testWidgets('the page: its title, six rows, then three actions', (tester) async {
    await open(tester);
    expect(find.text(en(Lines.MP_25)), findsOneWidget);
    final names = [
      en(Lines.EM_9),
      'Word Animation',
      'Night images',
      'Night/Day mode',
      'Life Context',
      'Life Context length',
    ];
    final ys = [for (final n in names) tester.getCenter(find.text(n)).dy];
    expect(ys, [...ys]..sort());
    expect(shown(tester, SettingRow.language), owedLanguage);
    // Each pill is heard as its row's name, then its value.
    final pill = tester.getSemantics(find.byKey(SettingsPage.valueKey(SettingRow.wordAnimation)));
    expect([pill.label, pill.value], ['Word Animation', 'On']);
    expect(shown(tester, SettingRow.wordAnimation), 'On');
    expect(shown(tester, SettingRow.nightImages), 'Off');
    expect(shown(tester, SettingRow.nightDay), 'Automatic');
    expect(shown(tester, SettingRow.lifeContext), 'Off');
    expect(shown(tester, SettingRow.length), '2 weeks');
    expect(find.text(en(Lines.MP_48)), findsOneWidget);
    expect(find.text(en(Lines.MP_95)), findsOneWidget);
    expect(find.text(en(Lines.EM_11)), findsOneWidget);
    // Nothing of Feedback (D121 item 4) or of what Life Context keeps.
    expect(find.text(en(Lines.MP_49)), findsNothing);
    expect(find.text(en(Lines.MP_86)), findsNothing);
    final delete = tester.getCenter(find.byKey(SettingsPage.deleteKey)).dy;
    expect(tester.getCenter(find.byKey(SettingsPage.consentKey)).dy, lessThan(delete));
    expect(tester.getCenter(find.byKey(SettingsPage.disclosureKey)).dy, lessThan(delete));
  });

  testWidgets('each row offers its line\'s choices; Language only English', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(SettingsPage.valueKey(SettingRow.length)));
    await tester.pumpAndSettle();
    for (final (i, w) in ['1 week', '2 weeks', '1 month', '3 months'].indexed) {
      expect(find.descendant(of: find.byKey(SettingsPage.choiceKey(SettingRow.length, i)), matching: find.text(w)),
          findsOneWidget);
    }
    await tester.tapAt(const Offset(5, 400));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SettingsPage.valueKey(SettingRow.language)));
    await tester.pumpAndSettle();
    expect(find.byKey(SettingsPage.choiceKey(SettingRow.language, 0)), findsOneWidget);
    expect(find.byKey(SettingsPage.choiceKey(SettingRow.language, 1)), findsNothing);
  });

  testWidgets('Word Animation and Life Context length are kept', (tester) async {
    await open(tester);
    await choose(tester, SettingRow.wordAnimation, 1);
    expect(shown(tester, SettingRow.wordAnimation), 'Off');
    expect(wordAnimation, isFalse);
    await choose(tester, SettingRow.length, 3);
    expect(shown(tester, SettingRow.length), '3 months');
    expect(kept(JournalStore.settingsFile)['wordAnimation'], isFalse);
    expect(kept(JournalStore.settingsFile)['length'], 'threeMonths');
  });

  // The stop's question 5: Manual keeps the theme on screen; the toggle
  // switches it and sets Manual (Design System §6).
  testWidgets('Night/Day: Manual keeps the theme; the toggle switches it', (tester) async {
    final c = await open(tester, hour: 12);
    Brightness now() => Theme.of(tester.element(find.byType(SettingsPage))).brightness;
    await choose(tester, SettingRow.nightDay, 1);
    expect(c.settings.nightDay, NightDayMode.day);
    expect(shown(tester, SettingRow.nightDay), 'Manual');
    await hit(tester, find.byKey(SettingsPage.toggleKey));
    await tester.pumpAndSettle();
    expect(c.settings.nightDay, NightDayMode.night);
    expect(now(), Brightness.dark);
    await choose(tester, SettingRow.nightDay, 0);
    expect(c.settings.nightDay, NightDayMode.automatic);
    expect(now(), Brightness.light);
    // Tapped while Automatic: Manual, the other theme.
    await hit(tester, find.byKey(SettingsPage.toggleKey));
    await tester.pumpAndSettle();
    expect(c.settings.nightDay, NightDayMode.night);
    expect(shown(tester, SettingRow.nightDay), 'Manual');
    expect(tester.getSemantics(find.byKey(SettingsPage.toggleKey)).label, en(Lines.MP_45));
    // The moon in the dark theme, at the toggle's size; tapped, the day.
    final mark = find.descendant(of: find.byKey(SettingsPage.toggleKey), matching: find.byType(SkyMark));
    expect(tester.widget<SkyMark>(mark).sky, Sky.moon);
    expect(tester.getSize(mark), StandIns.toggleMark);
    await hit(tester, find.byKey(SettingsPage.toggleKey));
    await tester.pumpAndSettle();
    expect(c.settings.nightDay, NightDayMode.day);
    expect(now(), Brightness.light);
    expect(tester.widget<SkyMark>(mark).sky, Sky.sun);
  });

  // The toggle heads for the other theme from where it is going, not from
  // the theme on screen, which lags a fade: a second tap within the fade
  // undoes the first.
  testWidgets('the toggle tapped twice within the fade undoes the first', (tester) async {
    final c = await open(tester, hour: 12);
    await hit(tester, find.byKey(SettingsPage.toggleKey));
    await tester.pump(const Duration(seconds: 1));
    expect(c.settings.nightDay, NightDayMode.night);
    await tester.tap(find.byKey(SettingsPage.toggleKey));
    await tester.pump(const Duration(seconds: 1));
    expect(c.settings.nightDay, NightDayMode.day);
    expect(kept(JournalStore.settingsFile)['nightDay'], 'day');
    await tester.pumpAndSettle();
    expect(Theme.of(tester.element(find.byType(SettingsPage))).brightness, Brightness.light);
  });

  // Manual keeps the theme on screen, the dark one too.
  testWidgets('Manual chosen in the dark theme keeps the dark', (tester) async {
    final c = await open(tester, hour: 23);
    await choose(tester, SettingRow.nightDay, 1);
    expect(c.settings.nightDay, NightDayMode.night);
    expect(kept(JournalStore.settingsFile)['nightDay'], 'night');
    expect(Theme.of(tester.element(find.byType(SettingsPage))).brightness, Brightness.dark);
  });

  // The stop's question 6: Personal or Random needs consent (c) first; Off
  // withdraws it.
  testWidgets('Night images: the consent first; I don\'t consent changes nothing', (tester) async {
    final c = await open(tester);
    await choose(tester, SettingRow.nightImages, 1);
    expect(find.byType(ConsentPage), findsOneWidget);
    expect(find.text(en(Lines.MP_70)), findsOneWidget);
    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.images, false)));
    await tester.pumpAndSettle();
    expect(find.byType(ConsentPage), findsNothing);
    expect(c.nightImages, NightImages.off);
    // Nothing chosen is kept before the answer: the painting stays as it was.
    expect(c.settings.images, const Settings().images);
    expect(files.files.keys, isNot(contains(JournalStore.settingsFile)));
    await choose(tester, SettingRow.nightImages, 1);
    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.images, true)));
    await tester.pumpAndSettle();
    expect(c.nightImages, NightImages.random);
    expect(shown(tester, SettingRow.nightImages), 'Random');
    expect(kept(JournalStore.consentFile)['images']['given'], isTrue);
    // Given now: Personal needs no page.
    await choose(tester, SettingRow.nightImages, 0);
    expect(find.byType(ConsentPage), findsNothing);
    expect(c.nightImages, NightImages.personal);
    await choose(tester, SettingRow.nightImages, 2);
    expect(find.byType(CupertinoAlertDialog), findsNothing);
    expect(c.consents.given(Consent.images), isFalse);
    expect(shown(tester, SettingRow.nightImages), 'Off');
  });

  // The stop's question 7: Life Context On needs consent (b); Off asks MP·93.
  testWidgets('Life Context: On asks its consent; Off asks MP·93', (tester) async {
    final c = await open(tester);
    await choose(tester, SettingRow.lifeContext, 0);
    expect(find.text(en(Lines.MP_69)), findsOneWidget);
    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.lifeContext, true)));
    await tester.pumpAndSettle();
    expect(c.consents.given(Consent.lifeContext), isTrue);
    expect(shown(tester, SettingRow.lifeContext), 'On');
    await choose(tester, SettingRow.lifeContext, 1);
    expect(find.text(en(Lines.MP_93)), findsOneWidget);
    cancelFirst(tester, Lines.MP_94);
    await tester.tap(find.text(en(Lines.MP_61)));
    await tester.pumpAndSettle();
    expect(c.consents.given(Consent.lifeContext), isTrue);
    await choose(tester, SettingRow.lifeContext, 1);
    await tester.tap(find.text(en(Lines.MP_94)));
    await tester.pumpAndSettle();
    expect(c.consents.given(Consent.lifeContext), isFalse);
    expect(shown(tester, SettingRow.lifeContext), 'Off');
  });

  // D121 item 5; the stop's question 10: Withdraw behind MP·96, the journal
  // stays; Give consent behind MP·68.
  testWidgets('Withdraw consent behind MP·96; Give consent behind MP·68', (tester) async {
    final c = await open(tester);
    await hit(tester, find.byKey(SettingsPage.consentKey));
    await tester.pumpAndSettle();
    expect(find.text(en(Lines.MP_96)), findsOneWidget);
    cancelFirst(tester, Lines.MP_97);
    await tester.tap(find.text(en(Lines.MP_61)));
    await tester.pumpAndSettle();
    expect(c.consents.given(Consent.readings), isTrue);
    await hit(tester, find.byKey(SettingsPage.consentKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en(Lines.MP_97)));
    await tester.pumpAndSettle();
    expect(c.consents.given(Consent.readings), isFalse);
    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text(en(Lines.MP_95, 1)), findsOneWidget);
    await hit(tester, find.byKey(SettingsPage.consentKey));
    await tester.pumpAndSettle();
    expect(find.text(en(Lines.MP_68)), findsOneWidget);
    // The back control gives nothing.
    await tester.tap(find.descendant(of: find.byType(ConsentPage), matching: find.byType(BackControl)));
    await tester.pumpAndSettle();
    expect(c.consents.given(Consent.readings), isFalse);
    await hit(tester, find.byKey(SettingsPage.consentKey));
    await tester.pumpAndSettle();
    await hit(tester, find.byKey(ConsentChoice.keyOf(Consent.readings, true)));
    await tester.pumpAndSettle();
    expect(c.consents.given(Consent.readings), isTrue);
    expect(find.text(en(Lines.MP_95, 0)), findsOneWidget);
  });

  // D124 item 2: a withdrawal that cannot be written: MP·62 shows, the button
  // stays "Withdraw consent", and a second try is kept.
  testWidgets('a withdrawal not kept: MP·62, the button stays; tried again, kept', (tester) async {
    final folder = Flaky();
    final c = await open(tester, folder: folder);
    folder.failing = true;
    expect(find.byKey(SettingsPage.notKeptKey), findsNothing);
    await hit(tester, find.byKey(SettingsPage.consentKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en(Lines.MP_97)));
    await tester.pumpAndSettle();
    expect(c.sending, isFalse);
    expect(c.consents.given(Consent.readings), isTrue);
    await tester.ensureVisible(find.byKey(SettingsPage.notKeptKey));
    expect(find.text(en(Lines.MP_62)), findsOneWidget);
    expect(find.text(en(Lines.MP_95, 0)), findsOneWidget);
    expect(find.text(en(Lines.MP_95, 1)), findsNothing);
    folder.failing = false;
    await hit(tester, find.byKey(SettingsPage.consentKey));
    await tester.pumpAndSettle();
    expect(find.text(en(Lines.MP_96)), findsOneWidget);
    await tester.tap(find.text(en(Lines.MP_97)));
    await tester.pumpAndSettle();
    expect(find.byKey(SettingsPage.notKeptKey), findsNothing);
    expect(find.text(en(Lines.MP_62)), findsNothing);
    expect(find.text(en(Lines.MP_95, 1)), findsOneWidget);
    expect(c.consents.given(Consent.readings), isFalse);
  });

  testWidgets('Read disclosure & privacy opens every part', (tester) async {
    await open(tester);
    await hit(tester, find.byKey(SettingsPage.disclosureKey));
    await tester.pumpAndSettle();
    expect(tester.widget<DisclosurePage>(find.byType(DisclosurePage)).shown, DisclosurePage.parts);
  });

  // D110: one confirmation; then everything goes, back to the welcome.
  testWidgets('Delete journal: C4-P·4 once, then everything goes', (tester) async {
    await open(tester);
    await hit(tester, find.byKey(SettingsPage.deleteKey));
    await tester.pumpAndSettle();
    expect(find.text(en(Lines.C4_P_4)), findsOneWidget);
    cancelFirst(tester, Lines.MP_60);
    await tester.tap(find.text(en(Lines.MP_61)));
    await tester.pumpAndSettle();
    expect(files.files.keys.where((n) => n.startsWith('night-')), hasLength(1));
    await hit(tester, find.byKey(SettingsPage.deleteKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(en(Lines.MP_60)));
    await tester.pumpAndSettle();
    expect(files.files, isEmpty);
    expect(find.byType(SettingsPage), findsNothing);
    expect(find.byType(Onboarding), findsOneWidget);
    expect(find.text(en(Lines.MP_3)), findsOneWidget);
  });

  testWidgets('at the largest text, nothing overflows', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester);
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
