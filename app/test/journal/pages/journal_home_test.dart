// SoulDreams Dev's first page: the journal, once its folder is open.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_audio.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/pages/journal_home.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/onboarding/onboarding.dart';
import 'package:souldreams/recording/recording.dart';
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

/// A folder whose read of the consent fails.
final class NoConsentRead extends MemoryJournalFiles {
  @override
  Future<Uint8List?> read(String name) async =>
      name == JournalStore.consentFile ? throw StateError('journal-io') : super.read(name);
}

/// [files] holding the consent, as "I agree" keeps it (D103).
T agreed<T extends MemoryJournalFiles>(T files) {
  files.files[JournalStore.consentFile] = Uint8List.fromList(utf8.encode('{"version":1,"over18":true}'));
  return files;
}

/// A night with a recording waiting, its audio kept, in [files].
Future<void> waiting(MemoryJournalFiles files) async {
  final store = await JournalStore.open(files);
  final x = '1' * 32;
  await store.save(nightsFromFixtures().first.withEntries([Waiting(x)]));
  await store.appendAudio(x, Uint8List(32000));
}

/// A recording whose streams are counted in [links].
Recording counted(List<MemoryLink> links) => Recording(
  on: true,
  microphone: SilentMicrophone(),
  key: () async => 'k',
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
    expect(text, contains('JournalHome(files: files, after: check, recording: recording)'));
    expect(text, contains("betaKey: const String.fromEnvironment('BETA_KEY')"));
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

  // D103 items 2 and 4: "I agree" keeps the consent, lets the theme go and
  // opens the first empty journal (main-path.md, Onboarding, 5); only then
  // may a recording waiting be retried.
  testWidgets('I agree keeps the consent, then the journal and its retries', (tester) async {
    JournalStore.newQueueForTests();
    final files = MemoryJournalFiles();
    await waiting(files);
    final links = <MemoryLink>[];
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 23),
      home: JournalHome(files: files, recording: counted(links)),
    ));
    await tester.pumpAndSettle();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
    await tester.pump();
    await tester.pump();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(tester.widget<JournalPage>(find.byType(JournalPage)).firstTime, isTrue);
    expect(Theme.of(tester.element(find.byType(JournalPage))).brightness, Brightness.dark);
    expect(utf8.decode(files.files[JournalStore.consentFile]!), '{"version":1,"over18":true}');
    expect(links, hasLength(1));
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
    agree();
    await tester.pump();
    await tester.pump();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(links, hasLength(1));
    agree();
    await tester.pump();
    await tester.pump();
    expect(links, hasLength(1));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 11));
  });

  // The fix above keeps the guard set once agreed; the start-over resets it,
  // so the next onboarding can agree again.
  testWidgets('after the consent goes, a new I agree opens the journal', (tester) async {
    JournalStore.newQueueForTests();
    final files = agreed(MemoryJournalFiles());
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files)));
    await tester.pumpAndSettle();
    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.withdrawConsent();
    await tester.pumpAndSettle();
    expect(find.byType(Onboarding), findsOneWidget);
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
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
    tester.widget<Onboarding>(find.byType(Onboarding)).onAgreed();
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

  // D103 item 4: the consent gone, withdrawn or deleted with the journal,
  // returns the app to its start, whatever page is open, held light again.
  for (final (how, go) in <(String, Future<void> Function(Journal))>[
    ('withdrawn', (j) => j.withdrawConsent()),
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
      await tester.tap(find.text(Lines.MP_11.text(Lang.en)));
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

  // D103 item 4: back at the start, nothing is retried until the consent
  // is given again.
  testWidgets('the consent withdrawn: the retry cut, none after', (tester) async {
    JournalStore.newQueueForTests();
    final files = agreed(MemoryJournalFiles());
    await waiting(files);
    final links = <MemoryLink>[];
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: files, recording: counted(links))));
    await tester.pump();
    await tester.pump();
    expect(links, hasLength(1));
    await tester.widget<JournalPage>(find.byType(JournalPage)).journal.withdrawConsent();
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
}
