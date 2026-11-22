// Life Context's kept sentences in the journal's folder (C159-I item 1;
// D131; R11; docs/workflow.md (c)): one file, written whole; kept only into
// a night that is there; deleted with their night (X11) and with the
// journal; an unreadable file shown as nothing and replaced; every other
// file of the folder untouched, byte for byte.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/night_day.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';
import '../journal/zones.dart';

void main() {
  late MemoryJournalFiles files;
  late DateTime now;
  final lines = <String>[];
  final sink = SafeLog.sink;
  final passages = [for (final n in inventedNights()) ...n.waking];

  setUp(() {
    files = MemoryJournalFiles();
    now = DateTime.utc(2026, 11, 22, 9);
    lines.clear();
    SafeLog.sink = lines.add;
  });

  tearDown(() => SafeLog.sink = sink);

  Future<(JournalStore, Journal, List<Night>)> open() async {
    final store = await JournalStore.open(files);
    final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(7));
    final nights = nightsFromFixtures();
    for (final n in nights) {
      await store.save(n);
    }
    return (store, journal, nights);
  }

  test("each sentence kept word for word, with its date and night", () async {
    final (_, journal, nights) = await open();
    final w = passages.first;
    expect(await journal.keep(nights.first.id, w.text), w.sentences.length);
    final kept = await journal.kept();
    expect([for (final k in kept) k.text], w.sentences);
    expect(kept.every((k) => k.night == nights.first.id), isTrue);
    expect(kept.every((k) => k.day == (year: 2026, month: 11, day: 22)), isTrue);
    expect(kept.map((k) => k.id).toSet(), hasLength(kept.length));
    expect(files.files.keys.where((n) => n.startsWith('kept')), [JournalStore.keptFile]);
  });

  test("the day is the phone's date when it was said", () async {
    final (_, journal, nights) = await open();
    now = DateTime.utc(2026, 11, 22, 23, 30);
    await journal.keep(nights.first.id, passages.first.text);
    expect((await journal.kept()).first.day, (year: 2026, month: 11, day: 23));
  });

  test('more sentences follow those kept before, in order', () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights.first.id, passages[0].text);
    await journal.keep(nights[1].id, passages[1].text);
    expect([for (final k in await journal.kept()) k.text], [...passages[0].sentences, ...passages[1].sentences]);
  });

  test('nothing is kept into a night that is not there', () async {
    final (_, journal, _) = await open();
    expect(await journal.keep(newNightId(Random(99)), passages.first.text), 0);
    expect(await journal.kept(), isEmpty);
    expect(files.files.containsKey(JournalStore.keptFile), isFalse);
  });

  test('deleting every kept sentence leaves no file of them', () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights.first.id, passages.first.text);
    files.files['${JournalStore.tempPrefix}${JournalStore.keptFile}'] = Uint8List(1);
    await journal.deleteAllKept();
    expect(files.files.keys.where((n) => n.contains('kept')), isEmpty);
    expect(await journal.kept(), isEmpty);
  });

  test("deleting a night deletes its sentences, no other night's", () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights[0].id, passages[0].text);
    await journal.keep(nights[1].id, passages[1].text);
    await journal.delete(nights[0].id);
    expect([for (final k in await journal.kept()) k.text], passages[1].sentences);
    await journal.delete(nights[1].id);
    expect(files.files.containsKey(JournalStore.keptFile), isFalse);
  });

  test("a night deleted with its last dream takes its sentences", () async {
    final (_, journal, nights) = await open();
    final one = nights.firstWhere((n) => n.entries.length == 1);
    await journal.keep(one.id, passages.first.text);
    await journal.editDream(one.id, 0, ' ');
    expect(await journal.night(one.id), isNull);
    expect(await journal.kept(), isEmpty);
  });

  test('deleting the journal takes the kept sentences', () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights.first.id, passages.first.text);
    await journal.deleteAll();
    expect(files.files, isEmpty);
  });

  test('at open, sentences whose night is gone go, with a code', () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights[0].id, passages[0].text);
    await journal.keep(nights[1].id, passages[1].text);
    files.files.remove(JournalStore.fileOf(nights[0].id));
    lines.clear();
    final again = Journal(await JournalStore.open(files));
    expect([for (final k in await again.kept()) k.text], passages[1].sentences);
    expect(lines, ['keptOrphansSwept ${passages[0].sentences.length}']);
  });

  test('a failed orphan sweep never stops the journal opening', () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights[0].id, passages[0].text);
    await journal.keep(nights[1].id, passages[1].text);
    files.files.remove(JournalStore.fileOf(nights[0].id));
    final full = _FailingKeptWrites(files.files);
    lines.clear();
    final again = Journal(await JournalStore.open(full));
    expect(lines, ['keptDeleteFailed']);
    expect(await again.newestFirst(), hasLength(nights.length - 1));
    full.failing = false;
    expect(await JournalStore.open(full).then((s) => Journal(s).kept()), isNotEmpty);
  });

  test('an unreadable kept file shows nothing, is logged, then replaced', () async {
    final (_, journal, nights) = await open();
    files.files[JournalStore.keptFile] = utf8.encode('{"version":9}');
    lines.clear();
    final reopened = Journal(await JournalStore.open(files), zone: const FixedZone(1), now: () => now);
    expect(files.files[JournalStore.keptFile], utf8.encode('{"version":9}'));
    expect(await reopened.kept(), isEmpty);
    expect(lines, ['keptFileSkipped']);
    await reopened.sweepKept(LifeContextLength.oneWeek);
    expect(files.files[JournalStore.keptFile], utf8.encode('{"version":9}'));
    await reopened.keep(nights.first.id, passages.first.text);
    expect([for (final k in await reopened.kept()) k.text], passages.first.sentences);
  });

  test('an edit changes only the kept copy, never the night', () async {
    final (_, journal, nights) = await open();
    final night = nights.first;
    await journal.keep(night.id, passages[0].text);
    final [first, second, ...] = await journal.kept();
    await journal.editKept(first.id, '  ${passages[1].sentences.first} ');
    final kept = await journal.kept();
    expect(kept.first.text, passages[1].sentences.first);
    expect((kept.first.id, kept.first.night, kept.first.day), (first.id, first.night, first.day));
    expect(kept[1], second);
    expect(await journal.night(night.id), night);
  });

  test('an edit to nothing but spaces deletes the sentence', () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights.first.id, passages[0].text);
    final [first, second, ...] = await journal.kept();
    await journal.editKept(first.id, ' \n ');
    expect(await journal.kept(), [second]);
  });

  test('deleting chosen sentences leaves the rest, in order', () async {
    final (_, journal, nights) = await open();
    await journal.keep(nights.first.id, passages[0].text);
    await journal.keep(nights.first.id, passages[1].text);
    final kept = await journal.kept();
    await journal.deleteKept({kept[0].id, kept[2].id});
    expect(await journal.kept(), [kept[1], ...kept.skip(3)]);
  });

  test('the sweep takes only what is past the window, counted', () async {
    final (_, journal, nights) = await open();
    for (final (i, at) in [
      DateTime.utc(2026, 11, 22, 9),
      DateTime.utc(2026, 11, 14, 9),
      DateTime.utc(2026, 11, 2, 9),
    ].indexed) {
      now = at;
      await journal.keep(nights[i].id, passages[i].text);
    }
    now = DateTime.utc(2026, 11, 22, 9);
    final before = await journal.kept();
    expect(await journal.sweepKept(LifeContextLength.threeMonths), 0);
    expect(await journal.kept(), before);
    expect(await journal.sweepKept(LifeContextLength.twoWeeks), passages[2].sentences.length);
    expect(await journal.sweepKept(LifeContextLength.oneWeek), passages[1].sentences.length);
    expect([for (final k in await journal.kept()) k.text], passages[0].sentences);
  });

  test('keeping and deleting sentences leaves every other file byte for byte', () async {
    final store = await JournalStore.open(files);
    final nights = nightsFromFixtures();
    for (final n in nights) {
      await store.save(n);
    }
    final waiting = newNightId(Random(5));
    await store.update(nights.first.id, (n) => n.withEntries([...n.entries, Waiting(waiting)]));
    await store.appendAudio(waiting, Uint8List.fromList(List.filled(64, 3)));
    await store.markFirstUseSeen();
    await store.keepConsents(Consents.answered({Consent.readings: true, Consent.lifeContext: true}, now));
    await store.keepSettings(const Settings(nightDay: NightDayMode.night, length: LifeContextLength.oneMonth));
    final before = {for (final e in files.files.entries) e.key: Uint8List.fromList(e.value)};
    final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(3));
    for (final (i, w) in passages.indexed) {
      await journal.keep(nights[i % nights.length].id, w.text);
    }
    final kept = await journal.kept();
    await journal.editKept(kept.first.id, kept.last.text);
    await journal.deleteKept({kept[1].id});
    await journal.sweepKept(LifeContextLength.oneWeek);
    expect(files.files.keys.toSet(), {...before.keys, JournalStore.keptFile});
    for (final name in before.keys) {
      expect(files.files[name], before[name], reason: name);
    }
    await journal.deleteAllKept();
    expect(files.files.keys.toSet(), before.keys.toSet());
    expect(await store.nights(), hasLength(nights.length));
    expect(await store.audioPart(waiting), (start: 0, size: 64));
    expect((await store.consents())!.given(Consent.lifeContext), isTrue);
    expect((await store.settings())!.length, LifeContextLength.oneMonth);
  });
}

// A folder whose kept file cannot be written (a full disk), until told otherwise.
class _FailingKeptWrites extends MemoryJournalFiles {
  _FailingKeptWrites(Map<String, Uint8List> from) {
    files.addAll(from);
  }

  bool failing = true;

  @override
  Future<void> write(String name, Uint8List bytes) async {
    if (failing && name.contains('kept')) throw StateError('disk');
    return super.write(name, bytes);
  }
}
