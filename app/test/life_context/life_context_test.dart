// Life Context while the journal is open (C159-I item 1; D127; D128;
// D131): Off keeps nothing and deletes what is kept; the page's lists; the
// sweep when the journal opens, when the app comes back and at each local
// midnight; a change that cannot be done logs a code, never a sentence.
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/life_context/life_context.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';
import 'package:souldreams/settings/settings_controller.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';
import '../journal/zones.dart';

/// A folder whose deletes of the kept file fail.
final class NoKeptDelete extends MemoryJournalFiles {
  @override
  Future<void> delete(String name) async =>
      name == JournalStore.keptFile ? throw StateError('journal-io') : super.delete(name);
}

void main() {
  late DateTime now;
  final lines = <String>[];
  final sink = SafeLog.sink;
  final passages = [for (final n in inventedNights()) ...n.waking];

  setUp(() {
    JournalStore.newQueueForTests();
    now = DateTime.utc(2026, 11, 22, 9);
    lines.clear();
    SafeLog.sink = lines.add;
  });

  tearDown(() => SafeLog.sink = sink);

  Future<(Journal, SettingsController, LifeContext, List<Night>)> open({
    bool on = true,
    LifeContextLength length = LifeContextLength.twoWeeks,
    MemoryJournalFiles? files,
  }) async {
    final store = await JournalStore.open(files ?? MemoryJournalFiles());
    final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(4));
    final nights = nightsFromFixtures();
    for (final n in nights) {
      await store.save(n);
    }
    final settings = SettingsController(
      journal,
      consents: Consents.answered({Consent.readings: true, Consent.lifeContext: on}, now),
      settings: Settings(length: length),
    );
    return (journal, settings, LifeContext(journal, settings), nights);
  }

  test('Off, a capture keeps nothing', () async {
    final (journal, _, life, nights) = await open(on: false);
    expect(life.on, isFalse);
    expect(await life.capture(nights.first.id, passages.first.text), 0);
    expect(await journal.kept(), isEmpty);
    expect(await life.recent(), isEmpty);
  });

  test('On, a capture keeps each sentence word for word', () async {
    final (journal, _, life, nights) = await open();
    var told = 0;
    life.addListener(() => told++);
    expect(await life.capture(nights.first.id, passages.first.text), passages.first.sentences.length);
    expect([for (final k in await journal.kept()) k.text], passages.first.sentences);
    expect(told, 1);
  });

  test('Recent: only the window, newest first; Kept longer is empty', () async {
    final (_, _, life, nights) = await open();
    for (final (i, at) in [
      DateTime.utc(2026, 11, 2, 9),
      DateTime.utc(2026, 11, 9, 9),
      DateTime.utc(2026, 11, 20, 9),
    ].indexed) {
      now = at;
      await life.capture(nights[i].id, passages[i].text);
    }
    now = DateTime.utc(2026, 11, 22, 9);
    expect([for (final k in await life.recent()) k.text], [...passages[2].sentences, ...passages[1].sentences]);
    expect(life.longer, isEmpty);
  });

  test('turning Life Context off deletes everything kept', () async {
    final (journal, settings, life, nights) = await open();
    await life.capture(nights.first.id, passages.first.text);
    await settings.answer(Consent.lifeContext, false);
    expect(await journal.kept(), isEmpty);
    expect(settings.consents.given(Consent.lifeContext), isFalse);
    expect(lines, isEmpty);
  });

  test('a failed deletion at Off: still Off, a code, swept again', () async {
    final files = NoKeptDelete();
    final (journal, settings, life, nights) = await open(files: files);
    await life.capture(nights.first.id, passages.first.text);
    await settings.answer(Consent.lifeContext, false);
    expect(settings.consents.given(Consent.lifeContext), isFalse);
    expect(lines, ['keptDeleteFailed']);
    expect(await life.recent(), isEmpty);
    lines.clear();
    await life.sweep();
    expect(lines, ['keptDeleteFailed']);
  });

  test('the sweep: past the window goes, counted; while Off, everything', () async {
    final (journal, settings, life, nights) = await open(length: LifeContextLength.oneWeek);
    now = DateTime.utc(2026, 11, 10, 9);
    await life.capture(nights[0].id, passages[0].text);
    now = DateTime.utc(2026, 11, 21, 9);
    await life.capture(nights[1].id, passages[1].text);
    now = DateTime.utc(2026, 11, 22, 9);
    await life.sweep();
    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
    expect(lines, ['keptExpired ${passages[0].sentences.length}']);
    lines.clear();
    await life.sweep();
    expect(lines, isEmpty);
    await journal.keep(nights[2].id, passages[2].text);
    final off = LifeContext(
      journal,
      SettingsController(journal, consents: settings.consents.withAnswer(Consent.lifeContext, false, now)),
    );
    await off.sweep();
    expect(await journal.kept(), isEmpty);
  });

  test('edit, delete and delete all change the kept copies only', () async {
    final (journal, _, life, nights) = await open();
    await life.capture(nights.first.id, passages[0].text);
    await life.capture(nights[1].id, passages[1].text);
    var told = 0;
    life.addListener(() => told++);
    final kept = await journal.kept();
    await life.edit(kept[0].id, passages[2].sentences.first);
    await life.delete({kept[1].id});
    expect(
      [for (final k in await journal.kept()) k.text],
      [
        passages[2].sentences.first,
        ...[for (final k in kept.skip(2)) k.text],
      ],
    );
    expect(await journal.night(nights.first.id), nights.first);
    await life.deleteAll();
    expect(await journal.kept(), isEmpty);
    expect(told, 3);
  });

  testWidgets('start sweeps now, then at each local midnight', (tester) async {
    JournalStore.newQueueForTests();
    final start = DateTime.utc(2026, 11, 22, 21, 30);
    final (journal, _, life, nights) = await open(length: LifeContextLength.oneWeek);
    // Kept on 15 November, local: past the week once 22 November has begun.
    now = DateTime.utc(2026, 11, 15, 9);
    await journal.keep(nights.first.id, passages.first.text);
    now = start;
    life.start();
    await tester.pump();
    expect(lines, ['keptExpired ${passages.first.sentences.length}']);
    lines.clear();
    now = DateTime.utc(2026, 11, 16, 9);
    await journal.keep(nights.first.id, passages[1].text);
    // 23 November begins at 23:00 UTC (UTC+1); a minute before, nothing.
    now = start.add(const Duration(minutes: 89));
    await tester.pump(const Duration(minutes: 89));
    expect(lines, isEmpty);
    now = start.add(const Duration(minutes: 90));
    await tester.pump(const Duration(minutes: 1));
    await tester.pump();
    expect(lines, ['keptExpired ${passages[1].sentences.length}']);
    lines.clear();
    // And again at the next midnight.
    now = DateTime.utc(2026, 11, 17, 9);
    await journal.keep(nights.first.id, passages[2].text);
    now = DateTime.utc(2026, 11, 23, 23);
    await tester.pump(const Duration(hours: 24));
    await tester.pump();
    expect(lines, ['keptExpired ${passages[2].sentences.length}']);
    life.dispose();
  });

  test('coming back sweeps', () async {
    final (journal, _, life, nights) = await open(length: LifeContextLength.oneWeek);
    now = DateTime.utc(2026, 11, 1, 9);
    await life.capture(nights.first.id, passages.first.text);
    now = DateTime.utc(2026, 11, 22, 9);
    life.resumed();
    await Future<void>.delayed(Duration.zero);
    await journal.kept();
    expect(lines, ['keptExpired ${passages.first.sentences.length}']);
  });
}
