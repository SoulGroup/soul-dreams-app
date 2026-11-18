// SoulDreams Dev's first page: the journal, once its folder is open.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_audio.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/pages/journal_home.dart';
import 'package:souldreams/journal/pages/journal_page.dart';
import 'package:souldreams/recording/recording.dart';

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

void main() {
  // The queue is renewed inside each test's own zone (journal_store.dart).
  testWidgets('it opens the folder, then shows the journal', (tester) async {
    JournalStore.newQueueForTests();
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: MemoryJournalFiles())));
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
    expect(lines, isEmpty);
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
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: MemoryJournalFiles(), recording: recording)));
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
    final files = MemoryJournalFiles();
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
    expect(lines, ['retryStarted', 'retryCut']);
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
    final files = Watched();
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
        home: JournalHome(files: MemoryJournalFiles(), after: check.future),
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
}
