// SoulDreams Dev's first page: the journal, once its folder is open.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/night_day.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_audio.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_action.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/pages/journal_home.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/onboarding/onboarding.dart';
import 'package:souldreams/recording/recording.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';
import 'package:souldreams/words/lines.g.dart';

import '../../fixtures.dart';
import '../../recording/fakes.dart';
import '../memory_journal_files.dart';

/// A folder that says whether it was opened.
final class Watched extends MemoryJournalFiles {
  bool opened = false;

  @override
  Future<void> open() async => opened = true;
}

/// A folder that cannot be opened.
final class Unopenable extends MemoryJournalFiles {
  @override
  Future<void> open() async => throw StateError('journal-io');
}

/// A folder whose rename fails: the consent cannot be kept.
final class NoRename extends MemoryJournalFiles {
  @override
  Future<void> rename(String from, String to) async => throw StateError('journal-io');
}

/// A folder whose rename fails once [failing] is set.
final class Flaky extends MemoryJournalFiles {
  bool failing = false;

  @override
  Future<void> rename(String from, String to) async =>
      failing ? throw StateError('journal-io') : super.rename(from, to);
}

/// A folder whose read of the consent fails.
final class NoConsentRead extends MemoryJournalFiles {
  @override
  Future<Uint8List?> read(String name) async =>
      name == JournalStore.consentFile ? throw StateError('journal-io') : super.read(name);
}

/// [files] holding D103's one consent, version 1, which still reads as (a)
/// given (D122).
T agreed<T extends MemoryJournalFiles>(T files) {
  files.files[JournalStore.consentFile] = Uint8List.fromList(utf8.encode('{"version":1,"over18":true}'));
  return files;
}

/// A folder whose read of the settings fails.
final class NoSettingsRead extends MemoryJournalFiles {
  @override
  Future<Uint8List?> read(String name) async =>
      name == JournalStore.settingsFile ? throw StateError('journal-io') : super.read(name);
}

/// [files] holding the three consents as [given] (D122), version 2.
T answered<T extends MemoryJournalFiles>(T files, Map<Consent, bool> given) {
  files.files[JournalStore.consentFile] = encodeConsents(Consents.answered(given, DateTime.utc(2026)));
  return files;
}

/// Onboarding's answers: (a) given, (b) not (D122; D125 item 8).
const readingsOnly = {Consent.readings: true, Consent.lifeContext: false};

/// A night with a recording waiting, its audio kept, in [files].
Future<void> waiting(MemoryJournalFiles files) async {
  final store = await JournalStore.open(files);
  final x = '1' * 32;
  await store.save(nightsFromFixtures().first.withEntries([Waiting(x)]));
  await store.appendAudio(x, Uint8List(32000));
}

/// A recording whose streams are counted in [links], and its key fetches
/// in [keys].
Recording counted(List<MemoryLink> links, [List<void>? keys]) => Recording(
  on: true,
  microphone: SilentMicrophone(),
  key: () async {
    keys?.add(null);
    return 'k';
  },
  connect: (_) async {
    final link = MemoryLink();
    links.add(link);
    return link;
  },
);

void main() {
  // The queue is renewed inside each test's own zone (journal_store.dart).
  testWidgets('it opens the folder, then shows the journal', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
    // With the consent kept, no onboarding, and no MP·9 (shown once).
    expect(find.byType(Onboarding), findsNothing);
    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
    // The diagnostic at launch (D98), numbers only; nothing else.
    expect(lines, ['journalAudio 0 0']);
  });

  // D92: the recording the pages get keeps its audio in the journal's folder.
  testWidgets('the recording handed on keeps its audio in the journal', (tester) async {
    JournalStore.newQueueForTests();
    final recording = Recording(
      on: true,
      microphone: SilentMicrophone(),
      key: () async => 'k',
      connect: (_) async => MemoryLink(),
    );
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), recording: recording)));
    await tester.pumpAndSettle();
    final handed = tester.widget<JournalPage>(find.byType(JournalPage)).recording!;
    expect(handed.keep, isA<JournalAudio>());
    expect(handed.microphone, same(recording.microphone));
  });

  testWidgets("the night's menu item is handed to the journal", (tester) async {
    JournalStore.newQueueForTests();
    final action = NightAction(label: Lines.MP_65.text(Lang.en), run: (_) async {});
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), nightAction: action)));
    await tester.pumpAndSettle();
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).nightAction, same(action));
  });

  testWidgets('whether a night is read is handed to the journal', (tester) async {
    JournalStore.newQueueForTests();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), read: allRead)));
    await tester.pumpAndSettle();
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).read, same(allRead));
  });

  testWidgets("SoulDreams Dev's reading is handed to the journal; by default none", (tester) async {
    JournalStore.newQueueForTests();
    Future<({List<Reading> readings, List<ModelUsage>? usage})> send(Map<String, Object?> body) async =>
        (readings: <Reading>[], usage: null);
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), readNight: send)));
    await tester.pumpAndSettle();
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).readNight, same(send));
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(key: UniqueKey(), files: agreed(MemoryJournalFiles()))));
    await tester.pumpAndSettle();
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).readNight, isNull);
  });

  testWidgets('by default no night is read', (tester) async {
    JournalStore.newQueueForTests();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
    await tester.pumpAndSettle();
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).read, same(noneRead));
  });

  // D92 item 3: a recording waiting is retried only while the app is open:
  // when the journal opens and when the app comes back; leaving cuts it.
  testWidgets('the journal opening retries; leaving cuts it; back resumes', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    final files = agreed(MemoryJournalFiles());
    final store = await JournalStore.open(files);
    final x = '1' * 32;
    await store.save(nightsFromFixtures().first.withEntries([Waiting(x)]));
    await store.appendAudio(x, Uint8List(32000));
    final links = <MemoryLink>[];
    final recording = Recording(
      on: true,
      microphone: SilentMicrophone(),
      key: () async => 'k',
      connect: (_) async {
        final link = MemoryLink();
        links.add(link);
        return link;
      },
    );
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: recording)));
    await tester.pump();
    await tester.pump();
    expect(links, hasLength(1));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump(const Duration(milliseconds: 150));
    expect(links.single.closed, isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump(const Duration(milliseconds: 150));
    expect(links.single.closed, isTrue);
    expect(lines, ['journalAudio 1 1', 'retryStarted', 'retryCut 0 0', 'journalAudio 1 1']);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(links, hasLength(2));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  // D65: with the phone check, its probe never shows as a row, because the
  // list is not loaded until the check has finished.
  testWidgets('the list waits for the phone check, then shows', (tester) async {
    JournalStore.newQueueForTests();
    final files = agreed(Watched());
    final check = Completer<bool>();
    await tester.pumpWidget(
      SoulDreamsApp(
        home: JournalHome(files: files, after: check.future),
      ),
    );
    await tester.pumpAndSettle();
    expect(files.opened, isFalse);
    expect(find.byType(JournalPage), findsNothing);
    check.complete(true);
    await tester.pumpAndSettle();
    expect(files.opened, isTrue);
    expect(find.byType(JournalPage), findsOneWidget);
  });

  testWidgets('a phone check that throws does not keep the list away', (tester) async {
    JournalStore.newQueueForTests();
    final check = Completer<bool>();
    await tester.pumpWidget(
      SoulDreamsApp(
        home: JournalHome(files: agreed(MemoryJournalFiles()), after: check.future),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsNothing);
    check.completeError(StateError('x'));
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
  });

  test('SoulDreams Dev hands its phone check and recording to the list', () {
    final text = File('lib/main_dev.dart').readAsStringSync();
    // With each night's export (D108), and the invented kept sentences of a
    // build made for the by-eye review (D131 item 1).
    expect(
      text,
      contains(
        'JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, '
        "read: read, preview: const String.fromEnvironment('PREVIEW_KEPT'), feedback: feedback, readNight: readNight)",
      ),
    );
    // Every night read only in a build made for the by-eye preview (D110).
    // Otherwise a night is read when it holds its readings (D155 item 2).
    expect(text, contains("bool.fromEnvironment('PREVIEW_READ') ? allRead : isRead"));
    expect(text, contains("betaKey: const String.fromEnvironment('BETA_KEY')"));
    // Feedback, to our server with the same beta key (D152 item 5).
    expect(text, contains("final feedback = liveFeedback(betaKey: const String.fromEnvironment('BETA_KEY'));"));
    // The readings, through our server with the same beta key (head's
    // message 33: SoulDreams Dev only).
    // Each night's calls' counts kept beside it (head's message 34).
    expect(text, contains("liveReading(betaKey: const String.fromEnvironment('BETA_KEY'), keepUsage: true);"));
  });

  testWidgets('a folder that cannot open: a blank page, a code', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: Unopenable())));
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsNothing);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(lines, ['journalOpenFailed']);
  });

  // D103: before the consent, onboarding, held light whatever the time
  // (main-path.md, Every Screen), and nothing leaves the phone: no retry,
  // no stream, and nothing logged.
  testWidgets('no consent: onboarding, light at night, nothing retried', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    final files = MemoryJournalFiles();
    await waiting(files);
    final links = <MemoryLink>[];
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 23),
      home: JournalHome(files: files, recording: counted(links)),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Onboarding), findsOneWidget);
    expect(find.byType(JournalPage), findsNothing);
    expect(Theme.of(tester.element(find.byType(Onboarding))).brightness, Brightness.light);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(links, isEmpty);
    expect(lines, isEmpty);
    expect(files.files.keys, isNot(contains(JournalStore.consentFile)));
  });

  // D103 item 2; D122: "I consent" keeps the consents, (a) given and (b)
  // and (c) not (until onboarding asks the three), lets the theme go and
  // opens the first empty journal (main-path.md, Onboarding, 5); only then
  // may a recording waiting be retried.
  testWidgets('I agree keeps the consent, then the journal and its retries', (tester) async {
    JournalStore.newQueueForTests();
    final files = MemoryJournalFiles();
    await waiting(files);
    final links = <MemoryLink>[];
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 23),
      home: JournalHome(files: files, recording: counted(links)),
    ));
    await tester.pumpAndSettle();
    final started = DateTime.now();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
    await tester.pump();
    await tester.pump();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.MP_9.text(Lang.en)), findsNothing);
    expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
    final kept = jsonDecode(utf8.decode(files.files[JournalStore.consentFile]!)) as Map<String, dynamic>;
    expect(kept.keys, ['version', 'over18', 'readings', 'lifeContext']);
    expect([kept['version'], kept['over18']], [3, true]);
    expect([for (final c in ['readings', 'lifeContext']) kept[c]['given']], [true, false]);
    // Either side of a UTC midnight crossed while the test ran.
    expect(kept['readings']['day'], anyOf(dayOf(started), dayOf(DateTime.now())));
    expect(links, hasLength(1));
    // The journal opened once: its counts logged once (D98).
    expect(lines.where((l) => l.startsWith('journalAudio')), hasLength(1));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  // D91 item 2 ("I agree" twice in a row agrees once), review of Tasks 1 to 4:
  // a second tap landing after the keep is done and before onboarding has left
  // the tree must not open the journal a second time, which would leave a
  // retry engine nobody stops.
  testWidgets('a second I agree after the journal opened starts nothing more', (tester) async {
    JournalStore.newQueueForTests();
    final files = MemoryJournalFiles();
    await waiting(files);
    final links = <MemoryLink>[];
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links))));
    await tester.pumpAndSettle();
    final agree = tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed;
    agree(readingsOnly);
    await tester.pump();
    await tester.pump();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(links, hasLength(1));
    final settings = tester.widget<JournalPage>(find.byType(JournalPage)).settings;
    agree(readingsOnly);
    await tester.pump();
    await tester.pump();
    expect(links, hasLength(1));
    // One journal, with its one settings (D122).
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).settings, same(settings));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  // The fix above keeps the guard set once agreed; the start-over resets it,
  // so the next onboarding can agree again.
  testWidgets('after the journal is deleted, a new I consent opens it', (tester) async {
    JournalStore.newQueueForTests();
    final files = MemoryJournalFiles();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.deleteAll();
    await tester.pumpAndSettle();
    expect(find.byType(Onboarding), findsOneWidget);
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(files.files.keys, contains(JournalStore.consentFile));
  });

  testWidgets('a consent that cannot be kept: the journal, a code', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    final files = NoRename();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(readingsOnly);
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(lines, ['consentKeepFailed', 'journalAudio 0 0']);
    expect(files.files, isEmpty);
  });

  testWidgets('a consent that cannot be read: onboarding, a code', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(NoConsentRead()))));
    await tester.pumpAndSettle();
    expect(find.byType(Onboarding), findsOneWidget);
    expect(lines, ['consentReadFailed']);
  });

  // D110: the journal deleted, the consents with it, returns the app to its
  // start, whatever page is open, held light again.
  for (final (how, go) in <(String, Future<void> Function(Journal))>[
    ('deleted with the journal', (j) => j.deleteAll()),
  ]) {
    testWidgets('the consent $how: back to the start', (tester) async {
      JournalStore.newQueueForTests();
      final files = agreed(MemoryJournalFiles());
      await tester.pumpWidget(SoulDreamsApp(
        clock: () => DateTime(2026, 6, 10, 23),
        home: JournalHome(files: files),
      ));
      await tester.pumpAndSettle();
      final journal = tester.widget<JournalPage>(find.byType(JournalPage)).journal;
      await tester.tap(find.byKey(JournalPage.newDreamKey));
      await tester.pumpAndSettle();
      expect(find.byType(TypingPage), findsOneWidget);
      await go(journal);
      await tester.pumpAndSettle();
      expect(find.byType(TypingPage), findsNothing);
      expect(find.byType(JournalPage), findsNothing);
      expect(find.byType(Onboarding), findsOneWidget);
      expect(find.text(Lines.MP_3.text(Lang.en)), findsOneWidget);
      expect(Theme.of(tester.element(find.byType(Onboarding))).brightness, Brightness.light);
      expect(files.files.keys, isNot(contains(JournalStore.consentFile)));
    });
  }

  // D110: back at the start, nothing is retried until the consent is given
  // again.
  testWidgets('the journal deleted: the retry cut, none after', (tester) async {
    JournalStore.newQueueForTests();
    final files = agreed(MemoryJournalFiles());
    await waiting(files);
    final links = <MemoryLink>[];
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links))));
    await tester.pump();
    await tester.pump();
    expect(links, hasLength(1));
    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.deleteAll();
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.byType(Onboarding), findsOneWidget);
    expect(links.single.closed, isTrue);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(links, hasLength(1));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  // D121 item 5; D122: consent (a) not given, the journal opens as a private
  // journal: no recording by voice, nothing retried, every night there.
  testWidgets('consent (a) not given: the journal, no recording, no retry', (tester) async {
    JournalStore.newQueueForTests();
    final files = answered(MemoryJournalFiles(), {Consent.lifeContext: true});
    await waiting(files);
    final links = <MemoryLink>[];
    final keys = <void>[];
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links, keys))));
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).recording, isNull);
    expect(find.byKey(JournalPage.rowKey(nightsFromFixtures().first.id)), findsOneWidget);
    for (final state in [AppLifecycleState.inactive, AppLifecycleState.hidden, AppLifecycleState.inactive]) {
      tester.binding.handleAppLifecycleStateChanged(state);
    }
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(links, isEmpty);
    expect(keys, isEmpty);
  });

  // D128: before the dreamer has agreed, nothing is sent; the page knows it
  // (the microphone and Start Interpretation then show the popup).
  testWidgets('not agreed: the page is told, nothing retried', (tester) async {
    JournalStore.newQueueForTests();
    final files = answered(MemoryJournalFiles(), {});
    await waiting(files);
    final links = <MemoryLink>[];
    final keys = <void>[];
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links, keys))));
    await tester.pumpAndSettle();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.agreed, isFalse);
    expect(page.recording, isNull);
    expect(links, isEmpty);
    expect(keys, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });

  // D128 item 3: agreeing later, from Settings' Disclosure & privacy page, gives
  // both consents and starts the recording and the retries then; there is no
  // way back.
  testWidgets('agreeing later starts the recording and its retries', (tester) async {
    JournalStore.newQueueForTests();
    final files = answered(MemoryJournalFiles(), {});
    await waiting(files);
    final links = <MemoryLink>[];
    final keys = <void>[];
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links, keys))));
    await tester.pumpAndSettle();
    final settings = tester.widget<JournalPage>(find.byType(JournalPage)).settings!;
    expect(links, isEmpty);
    await settings.agree();
    await tester.pump();
    await tester.pump();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.agreed, isTrue);
    expect(page.recording, isNotNull);
    expect(links, hasLength(1));
    expect(decodeConsents(files.files[JournalStore.consentFile]!)!.given(Consent.readings), isTrue);
    expect(decodeConsents(files.files[JournalStore.consentFile]!)!.given(Consent.lifeContext), isTrue);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  // D122: the settings kept are followed when the journal opens: Word
  // Animation, Night/Day mode and Night images (no consent behind it, D125
  // item 8); deleting the journal returns them to their defaults.
  testWidgets('the settings kept are followed; the deletion resets them', (tester) async {
    JournalStore.newQueueForTests();
    addTearDown(() => wordAnimation = true);
    final files = answered(MemoryJournalFiles(), {Consent.readings: true});
    files.files[JournalStore.settingsFile] = encodeSettings(
      const Settings(wordAnimation: false, nightDay: NightDayMode.night, images: NightImages.random),
    );
    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 12), home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.images, isTrue);
    expect(page.settings!.settings.images, NightImages.random);
    expect(wordAnimation, isFalse);
    expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
    await page.journal.deleteAll();
    await tester.pumpAndSettle();
    expect(find.byType(Onboarding), findsOneWidget);
    expect(wordAnimation, isTrue);
    expect(tester.widget<NightDayChoice>(find.byType(NightDayChoice)).mode.value, NightDayMode.automatic);
  });

  // D57 Q15: a mode found at start is instant. Manual Night kept, Word
  // Animation on (the default), the hour's own theme light: the journal
  // opens dark with no five-second fade.
  testWidgets('a Manual mode kept shows at once when the journal opens', (tester) async {
    JournalStore.newQueueForTests();
    final files = answered(MemoryJournalFiles(), {Consent.readings: true});
    files.files[JournalStore.settingsFile] = encodeSettings(const Settings(nightDay: NightDayMode.night));
    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 12), home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeAnimationDuration, Duration.zero);
    // A change the dreamer makes afterwards still fades, in half a second.
    NightDayChoice.set(tester.element(find.byType(JournalPage)), NightDayMode.day);
    await tester.pump();
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeAnimationDuration, NightDay.quickFade);
    await tester.pumpAndSettle();
  });

  // MP·85, D125 item 8, D160: Night images is Personal until it is chosen
  // otherwise: a read night shows its painting.
  testWidgets('Night images is Personal by default', (tester) async {
    JournalStore.newQueueForTests();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()))));
    await tester.pumpAndSettle();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.images, isTrue);
    expect(page.settings!.settings.images, NightImages.personal);
  });

  // D160: Off stays a choice: kept, followed when the journal opens, every
  // night the gradient.
  testWidgets('Night images Off, chosen: every night the gradient', (tester) async {
    JournalStore.newQueueForTests();
    final files = agreed(MemoryJournalFiles());
    files.files[JournalStore.settingsFile] = encodeSettings(const Settings(images: NightImages.off));
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.images, isFalse);
    expect(page.settings!.settings.images, NightImages.off);
  });

  // D160: after Delete journal, "I agree" again: Personal, as in a fresh
  // journal; the Off that was chosen went with the journal.
  testWidgets('after Delete journal, "I agree" gives Personal again', (tester) async {
    JournalStore.newQueueForTests();
    final files = agreed(MemoryJournalFiles());
    files.files[JournalStore.settingsFile] = encodeSettings(const Settings(images: NightImages.off));
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted([]))));
    await tester.pumpAndSettle();
    final first = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(first.images, isFalse);
    await first.journal.deleteAll();
    await tester.pumpAndSettle();
    expect(find.byType(Onboarding), findsOneWidget);
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(
      const {Consent.readings: true, Consent.lifeContext: true},
    );
    await tester.pump();
    await tester.pump();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.images, isTrue);
    expect(page.settings!.settings.images, NightImages.personal);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  testWidgets('settings that cannot be read: the defaults, a code', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(NoSettingsRead()))));
    await tester.pumpAndSettle();
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).settings!.settings, const Settings());
    expect(lines, ['settingsReadFailed', 'journalAudio 0 0']);
  });

  // D122, D125 item 8: the two answers from onboarding are kept as given,
  // with the day; Night images is Personal by default (D160), no consent
  // behind it.
  testWidgets('the two answers are kept as given', (tester) async {
    JournalStore.newQueueForTests();
    final files = MemoryJournalFiles();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(
      const {Consent.readings: false, Consent.lifeContext: true},
    );
    await tester.pumpAndSettle();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.recording, isNull);
    expect(page.images, isTrue);
    expect(page.settings!.settings.images, NightImages.personal);
    final kept = decodeConsents(files.files[JournalStore.consentFile]!)!;
    expect([for (final c in Consent.values) kept.given(c)], [false, true]);
  });

  // D127 item 1: "I agree" from onboarding gives both consents: kept as given,
  // Life Context on, the recording and its retries on.
  testWidgets('both given from onboarding: kept, Life Context on', (tester) async {
    JournalStore.newQueueForTests();
    final files = MemoryJournalFiles();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted([]))));
    await tester.pumpAndSettle();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(
      const {Consent.readings: true, Consent.lifeContext: true},
    );
    await tester.pump();
    await tester.pump();
    final page = tester.widget<JournalPage>(find.byType(JournalPage));
    expect(page.settings!.consents.given(Consent.lifeContext), isTrue);
    expect(page.recording, isNotNull);
    final kept = decodeConsents(files.files[JournalStore.consentFile]!)!;
    expect([for (final c in Consent.values) kept.given(c)], [true, true]);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  // D125 item 8: a journal from before: consents that held (c), settings that
  // chose a painting for while it was given. A "yes" keeps the painting; a
  // "no" makes Night images Off, and either is kept as the new version, so
  // that nothing is sent that was not agreed to.
  for (final (given, images) in [(true, NightImages.random), (false, NightImages.off)]) {
    testWidgets('a journal from before, (c) $given: Night images ${images.name}', (tester) async {
      JournalStore.newQueueForTests();
      final files = MemoryJournalFiles();
      files.files[JournalStore.consentFile] = Uint8List.fromList(
        utf8.encode(
          '{"version":2,"over18":true,"readings":{"given":true,"day":"2026-11-20"},'
          '"lifeContext":{"given":false,"day":"2026-11-20"},"images":{"given":$given,"day":"2026-11-21"}}',
        ),
      );
      files.files[JournalStore.settingsFile] = Uint8List.fromList(
        utf8.encode('{"version":1,"wordAnimation":true,"nightDay":"automatic","images":"random","length":"twoWeeks"}'),
      );
      await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
      await tester.pumpAndSettle();
      final page = tester.widget<JournalPage>(find.byType(JournalPage));
      expect(page.settings!.settings.images, images);
      expect(page.images, images != NightImages.off);
      expect(jsonDecode(utf8.decode(files.files[JournalStore.settingsFile]!))['version'], 2);
      expect(decodeSettings(files.files[JournalStore.settingsFile]!)!.images, images);
    });
  }

  // D131 item 4: what is past Life Context's window goes when the journal
  // opens, and when the app comes back; nothing of it is logged but a count.
  testWidgets('the journal opening sweeps Life Context; coming back too', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    final files = answered(MemoryJournalFiles(), const {Consent.readings: true, Consent.lifeContext: true});
    files.files[JournalStore.settingsFile] = encodeSettings(const Settings(length: LifeContextLength.oneWeek));
    final night = nightsFromFixtures().first;
    final passages = [for (final n in inventedNights()) ...n.waking];
    var now = DateTime.now().toUtc().subtract(const Duration(days: 30));
    final store = await JournalStore.open(files);
    await store.save(night);
    final journal = Journal(store, now: () => now);
    await journal.keep(night.id, passages[0].text);
    now = DateTime.now().toUtc().subtract(const Duration(days: 1));
    await journal.keep(night.id, passages[1].text);
    lines.clear();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
    expect(lines, contains('keptExpired ${passages[0].sentences.length}'));
    lines.clear();
    // Six more days pass while the app is away (the phone's clock, moved).
    now = DateTime.now().toUtc().subtract(const Duration(days: 8));
    await journal.keep(night.id, passages[2].text);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
    expect(lines, contains('keptExpired ${passages[2].sentences.length}'));
    await tester.pumpWidget(const SizedBox());
  });

  // D131 item 1: SoulDreams Dev built with the preview seeds the invented
  // kept sentences before the journal opens, from onboarding's "I agree"
  // too; a seed that fails logs a code and the journal opens.
  testWidgets('the preview seeds before the journal opens; a failure, a code', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    final define = jsonEncode([
      for (final n in inventedNights())
        if (n.waking.isNotEmpty) {'lang': n.lang, 'dreams': n.dreams, 'waking': [for (final w in n.waking) w.text]},
    ]);
    final files = MemoryJournalFiles();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, preview: define)));
    await tester.pumpAndSettle();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed(
      const {Consent.readings: true, Consent.lifeContext: true},
    );
    await tester.pumpAndSettle();
    final journal = Journal(await JournalStore.open(files));
    expect(await journal.kept(), isNotEmpty);
    expect(find.byType(JournalPage), findsOneWidget);
    final seeded = [for (final n in inventedNights()) if (n.waking.isNotEmpty) n];
    final sentences = [for (final n in seeded) for (final w in n.waking) w.sentences.length].reduce((a, b) => a + b);
    expect(lines.where((l) => l.startsWith('preview')), ['previewSeeded ${seeded.length} $sentences']);
    await tester.pumpWidget(const SizedBox());
    // Life Context off (it only pauses, D134): the nights and the sentences.
    final off = answered(MemoryJournalFiles(), const {Consent.readings: true, Consent.lifeContext: false});
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: off, preview: define)));
    await tester.pumpAndSettle();
    final offJournal = Journal(await JournalStore.open(off));
    expect(await offJournal.newestFirst(), isNotEmpty);
    expect(await offJournal.kept(), isNotEmpty);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: agreed(MemoryJournalFiles()), preview: '[1]')));
    await tester.pumpAndSettle();
    expect(lines, contains('previewSeedFailed'));
    expect(find.byType(JournalPage), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
