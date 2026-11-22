// The settings and the consents while the journal is open (D121; D122): a
// change shows at once and is kept; one that cannot be kept logs a code and
// holds; Night images is Off while consent (c) is not given.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/night_day.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';
import 'package:souldreams/settings/settings_controller.dart';

import '../journal/memory_journal_files.dart';

/// A folder whose rename fails: nothing can be kept.
final class NoRename extends MemoryJournalFiles {
  @override
  Future<void> rename(String from, String to) async => throw StateError('journal-io');
}

final now = DateTime.utc(2026, 11, 21, 12);

Future<(SettingsController, MemoryJournalFiles)> make({
  Map<Consent, bool> given = const {Consent.readings: true},
  MemoryJournalFiles? files,
}) async {
  final f = files ?? MemoryJournalFiles();
  final journal = Journal(await JournalStore.open(f), now: () => now);
  return (SettingsController(journal, consents: Consents.answered(given, DateTime.utc(2026))), f);
}

Map<String, dynamic> kept(MemoryJournalFiles f, String name) =>
    jsonDecode(utf8.decode(f.files[name]!)) as Map<String, dynamic>;

void main() {
  late List<String> lines;
  final sink = SafeLog.sink;
  setUp(() {
    JournalStore.newQueueForTests();
    lines = [];
    SafeLog.sink = lines.add;
  });
  tearDown(() => SafeLog.sink = sink);

  test('a consent answered shows at once, then is kept', () async {
    final (c, f) = await make();
    var told = 0;
    c.addListener(() => told++);
    final done = c.answer(Consent.readings, false);
    expect(c.consents.given(Consent.readings), isFalse);
    expect(told, 1);
    await done;
    expect(kept(f, JournalStore.consentFile)['readings'], {'given': false, 'day': '2026-11-21'});
    expect(kept(f, JournalStore.consentFile)['lifeContext'], {'given': false, 'day': '2026-01-01'});
    await c.answer(Consent.readings, false);
    expect(told, 1);
    expect(lines, isEmpty);
  });

  test('a setting changed shows at once, then is kept', () async {
    final (c, f) = await make();
    var told = 0;
    c.addListener(() => told++);
    const next = Settings(nightDay: NightDayMode.night);
    final done = c.change(next);
    expect(c.settings, next);
    expect(told, 1);
    await done;
    expect(kept(f, JournalStore.settingsFile)['nightDay'], 'night');
    await c.change(next);
    expect(told, 1);
  });

  test('Night images is Off while consent (c) is not given', () async {
    final (c, _) = await make();
    expect(c.settings.images, NightImages.personal);
    expect(c.nightImages, NightImages.off);
    await c.setImages(NightImages.random);
    expect(c.consents.given(Consent.images), isTrue);
    expect(c.nightImages, NightImages.random);
    await c.setImages(NightImages.off);
    expect(c.consents.given(Consent.images), isFalse);
    expect(c.nightImages, NightImages.off);
    // The choice is kept for when (c) is given again.
    expect(c.settings.images, NightImages.random);
  });

  test('a change that cannot be kept logs a code and holds', () async {
    final (c, f) = await make(files: NoRename());
    await c.answer(Consent.lifeContext, true);
    await c.change(const Settings(wordAnimation: false));
    expect(c.consents.given(Consent.lifeContext), isTrue);
    expect(c.settings.wordAnimation, isFalse);
    expect(lines, ['consentKeepFailed', 'settingsKeepFailed']);
    expect(f.files, isEmpty);
  });
}
