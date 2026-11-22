// The settings and the consents while the journal is open (D121; D122): a
// change shows at once and is kept; one that cannot be kept logs a code and
// holds; Night images is a setting with no consent behind it (D125 item 8).
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
    final done = c.answer(Consent.lifeContext, true);
    expect(c.consents.given(Consent.lifeContext), isTrue);
    expect(told, 1);
    await done;
    expect(kept(f, JournalStore.consentFile)['lifeContext'], {'given': true, 'day': '2026-11-21'});
    expect(kept(f, JournalStore.consentFile)['readings'], {'given': true, 'day': '2026-01-01'});
    await c.answer(Consent.lifeContext, true);
    expect(told, 1);
    expect(lines, isEmpty);
  });

  // D128 item 3: "I agree" (from the Disclosure & privacy page) gives the
  // readings and Life Context together, shown at once, then kept with the day;
  // there is no withdrawing.
  test('agree gives both consents at once, then keeps them', () async {
    final (c, f) = await make(given: const {});
    var told = 0;
    c.addListener(() => told++);
    expect(c.agreed, isFalse);
    final done = c.agree();
    expect(c.agreed, isTrue);
    expect(c.consents.given(Consent.readings), isTrue);
    expect(c.consents.given(Consent.lifeContext), isTrue);
    expect(told, 1);
    await done;
    expect(kept(f, JournalStore.consentFile)['readings'], {'given': true, 'day': '2026-11-21'});
    expect(kept(f, JournalStore.consentFile)['lifeContext'], {'given': true, 'day': '2026-11-21'});
    expect(lines, isEmpty);
    // Agreed already: nothing more.
    await c.agree();
    expect(told, 1);
  });

  // Already agreed (the readings given): "I agree" is not offered, and does nothing.
  test('agree when the readings are already given changes nothing', () async {
    final (c, f) = await make();
    var told = 0;
    c.addListener(() => told++);
    expect(c.agreed, isTrue);
    await c.agree();
    expect(told, 0);
    expect(c.consents.given(Consent.lifeContext), isFalse);
    expect(f.files, isEmpty);
  });

  // Agreed is the readings alone: Life Context given without them is not it.
  test('agreed follows the readings, not Life Context', () async {
    final (c, _) = await make(given: const {Consent.lifeContext: true});
    expect(c.agreed, isFalse);
    expect(c.consents.given(Consent.lifeContext), isTrue);
  });

  test('agree that cannot be kept logs a code and holds', () async {
    final (c, f) = await make(given: const {}, files: NoRename());
    await c.agree();
    expect(c.agreed, isTrue);
    expect(c.consents.given(Consent.lifeContext), isTrue);
    expect(lines, ['consentKeepFailed']);
    expect(f.files, isEmpty);
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

  // D125 item 8: Night images is a setting with no consent behind it: Off by
  // default, any choice kept as a setting alone, the consents untouched.
  test('Night images is a setting: Off by default, no consent kept', () async {
    final (c, f) = await make();
    expect(c.settings.images, NightImages.off);
    await c.change(c.settings.copyWith(images: NightImages.random));
    expect(c.settings.images, NightImages.random);
    expect(kept(f, JournalStore.settingsFile)['images'], 'random');
    await c.change(c.settings.copyWith(images: NightImages.off));
    expect(kept(f, JournalStore.settingsFile)['images'], 'off');
    expect(f.files.keys, [JournalStore.settingsFile]);
    expect(c.consents.answers.keys, Consent.values);
    expect(lines, isEmpty);
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
