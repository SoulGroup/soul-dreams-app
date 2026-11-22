// SoulDreams Dev's invented kept sentences (D131 item 1): seeded once from
// what tool/preview_kept.py writes (the invented nights with waking
// passages, fixtures/invented-nights.json, R2), dated back, kept whatever
// Life Context's state (Off only pauses, D134), and logged as a count.
import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/life_context/preview.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';
import '../journal/zones.dart';

/// What tool/preview_kept.py carries into a Dev build.
String previewDefine() => jsonEncode([
  for (final n in inventedNights())
    if (n.waking.isNotEmpty)
      {
        'lang': n.lang,
        'dreams': n.dreams,
        'waking': [for (final w in n.waking) w.text],
      },
]);

void main() {
  late MemoryJournalFiles files;
  late JournalStore store;
  final now = DateTime.utc(2026, 11, 22, 9);
  final withWaking = [
    for (final n in inventedNights())
      if (n.waking.isNotEmpty) n,
  ];

  setUp(() async {
    JournalStore.newQueueForTests();
    files = MemoryJournalFiles();
    store = await JournalStore.open(files);
  });

  Future<void> seed(String define) =>
      seedPreview(store, define, now: () => now, zone: const FixedZone(1), random: Random(8));

  test('without the define, nothing is seeded', () async {
    await seed('');
    expect(files.files, isEmpty);
  });

  test('each invented night, dated back, its passages kept; once', () async {
    await seed(previewDefine());
    final nights = await store.nights();
    expect(nights, hasLength(withWaking.length));
    final back = [for (final n in nights) now.difference(n.firstRecorded).inDays]..sort();
    expect(back, [for (var i = 0; i < withWaking.length; i++) previewDaysBack[i % previewDaysBack.length]]..sort());
    expect({for (final n in nights) n.entries.length}, {for (final n in withWaking) n.dreams.length});
    final journal = Journal(store);
    final kept = await journal.kept();
    expect(
      [for (final k in kept) k.text],
      [
        for (final n in withWaking)
          for (final w in n.waking) ...w.sentences,
      ],
    );
    for (final k in kept) {
      expect(nights.firstWhere((n) => n.id == k.night).date, k.day);
    }
    expect(files.files.containsKey(previewFlag), isTrue);
    await seed(previewDefine());
    expect(await store.nights(), hasLength(nights.length));
    expect(await journal.kept(), kept);
  });

  // D134: Off only pauses, so the seed does not depend on Life Context being
  // on when it runs: with no consent at all, the sentences are there.
  test('no consent is read: the nights and every sentence are seeded', () async {
    expect(files.files.containsKey(JournalStore.consentFile), isFalse);
    await seed(previewDefine());
    expect(await store.nights(), hasLength(withWaking.length));
    expect(
      (await Journal(store).kept()).length,
      [for (final n in withWaking) for (final w in n.waking) w.sentences.length].reduce((a, b) => a + b),
    );
  });

  // So that a build with no sentences can be told from one whose seed did
  // not run: a code and two counts, never a word of a night (R3).
  test('the seed logs its counts once, and nothing the second time', () async {
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    await seed(previewDefine());
    final sentences = [for (final n in withWaking) for (final w in n.waking) w.sentences.length].reduce((a, b) => a + b);
    expect(lines, ['previewSeeded ${withWaking.length} $sentences']);
    lines.clear();
    await seed(previewDefine());
    expect(lines, isEmpty);
  });

  test('a define that does not read seeds nothing', () async {
    for (final bad in ['{', '{"a":1}', '[{"lang":"en"}]', '[1]']) {
      await expectLater(seed(bad), throwsFormatException, reason: bad);
    }
    expect(files.files, isEmpty);
  });
}
