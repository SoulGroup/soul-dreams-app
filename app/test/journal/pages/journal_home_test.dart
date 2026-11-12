// SoulDreams Dev's first page: the journal, once its folder is open.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/pages/journal_home.dart';
import 'package:souldreams/journal/pages/journal_page.dart';

import '../memory_journal_files.dart';

/// A folder that cannot be opened.
final class Unopenable extends MemoryJournalFiles {
  @override
  Future<void> open() async => throw StateError('journal-io');
}

void main() {
  // The queue is renewed inside each test's own zone (journal_store.dart).
  testWidgets('it opens the folder, then shows the journal', (tester) async {
    JournalStore.newQueueForTests();
    await tester.pumpWidget(SoulDreamsApp(home: JournalHome(files: MemoryJournalFiles())));
    await tester.pumpAndSettle();
    expect(find.byType(JournalPage), findsOneWidget);
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
