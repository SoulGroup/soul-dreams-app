// The settings and the consents while the journal is open (D121; D122): a
// change shows at once and is kept; one that cannot be kept logs a code and
// holds; Night images is a setting with no consent behind it (D125 item 8).
import 'dart:async';
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

/// A folder whose rename fails while [failing].
final class Flaky extends MemoryJournalFiles {
  bool failing = false;

  @override
  Future<void> rename(String from, String to) async =>
      failing ? throw StateError('journal-io') : super.rename(from, to);
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

/// A folder whose rename waits at [gate].
final class Slow extends MemoryJournalFiles {
  Completer<void>? gate;

  @override
  Future<void> rename(String from, String to) async {
    await gate?.future;
    return super.rename(from, to);
  }
}

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

  // D124 item 1: sending stops at once, the withdrawal waits for the retry
  // in flight to stop, and is shown only when it is kept.
  test('withdrawn: sending stops, the retry is waited for, then kept', () async {
    final (c, f) = await make();
    final stopped = Completer<void>();
    var asked = 0;
    c.stopSending = () {
      asked++;
      return stopped.future;
    };
    var told = 0;
    c.addListener(() => told++);
    expect(c.sending, isTrue);
    var done = false;
    final withdrawal = c.answer(Consent.readings, false).then((_) => done = true);
    expect(c.sending, isFalse);
    expect(told, 1);
    await pumpEventQueue();
    expect(asked, 1);
    expect(done, isFalse);
    expect(c.consents.given(Consent.readings), isTrue);
    expect(f.files, isEmpty);
    stopped.complete();
    await withdrawal;
    expect(c.consents.given(Consent.readings), isFalse);
    expect(c.sending, isFalse);
    expect(c.withdrawalNotKept, isFalse);
    expect(kept(f, JournalStore.consentFile)['readings'], {'given': false, 'day': '2026-11-21'});
    expect(lines, isEmpty);
    // Given again, sending resumes.
    await c.answer(Consent.readings, true);
    expect(c.sending, isTrue);
  });

  test('a second withdrawal while one is under way is ignored', () async {
    final (c, _) = await make();
    final stopped = Completer<void>();
    var asked = 0;
    c.stopSending = () {
      asked++;
      return stopped.future;
    };
    final first = c.answer(Consent.readings, false);
    final second = c.answer(Consent.readings, false);
    await pumpEventQueue();
    stopped.complete();
    await Future.wait([first, second]);
    expect(asked, 1);
  });

  // D124 item 2: not kept, sending still stops for the session, the readings
  // still show as given, and the dreamer can try again.
  test('withdrawal not kept: sending stops, shown given, retry keeps it', () async {
    final f = Flaky()..failing = true;
    final (c, _) = await make(files: f);
    var told = 0;
    c.addListener(() => told++);
    await c.answer(Consent.readings, false);
    expect(c.sending, isFalse);
    expect(c.consents.given(Consent.readings), isTrue);
    expect(c.withdrawalNotKept, isTrue);
    expect(told, greaterThanOrEqualTo(2));
    expect(lines, ['consentKeepFailed']);
    expect(f.files, isEmpty);
    f.failing = false;
    final before = told;
    final again = c.answer(Consent.readings, false);
    expect(c.withdrawalNotKept, isFalse);
    expect(told, greaterThan(before));
    await again;
    expect(c.consents.given(Consent.readings), isFalse);
    expect(c.sending, isFalse);
    expect(c.withdrawalNotKept, isFalse);
    expect(kept(f, JournalStore.consentFile)['readings'], {'given': false, 'day': '2026-11-21'});
    expect(lines, ['consentKeepFailed']);
  });

  test('not kept twice: sending still stops', () async {
    final (c, _) = await make(files: NoRename());
    await c.answer(Consent.readings, false);
    await c.answer(Consent.readings, false);
    expect(c.sending, isFalse);
    expect(c.withdrawalNotKept, isTrue);
    expect(c.consents.given(Consent.readings), isTrue);
    expect(lines, ['consentKeepFailed', 'consentKeepFailed']);
  });

  // The journal deleted while a withdrawal waits: it ends quietly.
  test('a withdrawal under way when the journal goes ends quietly', () async {
    final (c, f) = await make();
    final stopped = Completer<void>();
    c.stopSending = () => stopped.future;
    final withdrawal = c.answer(Consent.readings, false);
    await pumpEventQueue();
    c.dispose();
    stopped.complete();
    await withdrawal;
    // Nothing is written into a journal that has gone (D110).
    expect(f.files, isEmpty);
    expect(lines, isEmpty);
  });

  // The journal goes while the withdrawal is being written: it ends quietly.
  test('a withdrawal being written when the journal goes ends quietly', () async {
    final f = Slow();
    final (c, _) = await make(files: f);
    f.gate = Completer<void>();
    final withdrawal = c.answer(Consent.readings, false);
    await pumpEventQueue();
    c.dispose();
    f.gate!.complete();
    await withdrawal;
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
