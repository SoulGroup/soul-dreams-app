// The journal store (D49 b, c): deleting removes everything, an edit
// leaves one version, an interrupted save leaves nothing behind, and a
// file that does not read as a night is skipped and never touched. D54:
// a delete takes a cut save's temporary file too, a failed save removes its
// own, and every operation waits for the one before it.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/night_day.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';

import '../fixtures.dart';
import 'io_journal_files.dart';

/// True when [haystack] holds [needle] anywhere.
bool holds(Uint8List haystack, List<int> needle) {
  for (var i = 0; i + needle.length <= haystack.length; i++) {
    var all = true;
    for (var j = 0; j < needle.length && all; j++) {
      all = haystack[i + j] == needle[j];
    }
    if (all) return true;
  }
  return false;
}

/// Each way a night's words could sit in a file: as typed, and as JSON
/// writes them.
List<List<int>> traces(Night n) => [
      for (final d in n.dreams) ...[utf8.encode(d), utf8.encode(jsonEncode(d))],
      if (n.name != null) utf8.encode(n.name!),
      utf8.encode(n.id),
    ];

/// [n] bytes of made-up audio, every byte telling its place.
Uint8List sound(int n, [int from = 0]) => Uint8List.fromList([for (var i = from; i < from + n; i++) i % 251]);

/// The rename fails: a save interrupted between its two steps.
final class BrokenRename extends IoJournalFiles {
  BrokenRename(super.dir);

  @override
  Future<void> rename(String from, String to) async => throw const FileSystemException('rename');
}

/// A folder that records the order of its calls and can hold a rename
/// open, to put an operation in the middle of a save (D54).
final class Gated extends IoJournalFiles {
  Gated(super.dir);

  final log = <String>[];
  Completer<void> hold = Completer<void>()..complete();
  Completer<void> reached = Completer<void>();

  @override
  Future<void> rename(String from, String to) async {
    log.add('rename:start');
    if (!reached.isCompleted) reached.complete();
    await hold.future;
    await super.rename(from, to);
    log.add('rename:end');
  }

  @override
  Future<void> delete(String name) {
    log.add('delete:start');
    return super.delete(name);
  }

  @override
  Future<void> deleteAll() {
    log.add('deleteAll:start');
    return super.deleteAll();
  }
}

/// Deleting by name always fails, as it would for a name the channel
/// refuses: only the folder's own delete-all can still empty it (D54).
final class NoNamedDelete extends IoJournalFiles {
  NoNamedDelete(super.dir);

  @override
  Future<void> delete(String name) async => throw ArgumentError('name');
}

void main() {
  late Directory dir;
  late IoJournalFiles files;
  final lines = <String>[];
  final sink = SafeLog.sink;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('journal-');
    files = IoJournalFiles(Directory('${dir.path}/Journal'));
    lines.clear();
    SafeLog.sink = lines.add;
  });

  tearDown(() {
    SafeLog.sink = sink;
    dir.deleteSync(recursive: true);
  });

  test('saved nights come back, earliest first, one file each', () async {
    final store = await JournalStore.open(files);
    final nights = nightsFromFixtures();
    for (final n in nights.reversed) {
      await store.save(n);
    }
    expect(await store.nights(), nights);
    expect(files.everything().keys.toSet(), {for (final n in nights) JournalStore.fileOf(n.id)});
    expect(lines, isEmpty);
  });

  // docs/workflow.md (c); D155 item 2: a journal of an older version reads
  // whole and unread; a save rewrites only the night saved, as version 3.
  for (final version in [1, 2]) {
    test('a version-$version journal reads whole; one save rewrites one night', () async {
      final nights = nightsFromFixtures();
      await files.open();
      for (final n in nights) {
        final json = {...jsonDecode(utf8.decode(encodeNight(n))) as Map<String, Object?>, 'version': version};
        await files.write(JournalStore.fileOf(n.id), utf8.encode(jsonEncode(json..remove('readings')..remove('usage'))));
      }
      final before = files.everything();
      final store = await JournalStore.open(files);
      final read = await store.nights();
      expect(read, nights);
      expect(read.where((n) => n.readings != null), isEmpty);
      expect(read.fold<int>(0, (sum, n) => sum + n.dreams.length), nights.fold<int>(0, (s, n) => s + n.dreams.length));
      final changed = nights[1].withDreams([...nights[1].dreams, 'x']);
      await store.save(changed);
      final after = files.everything();
      expect(after.keys.toSet(), before.keys.toSet());
      for (final n in nights) {
        final name = JournalStore.fileOf(n.id);
        if (n == nights[1]) {
          expect(jsonDecode(utf8.decode(after[name]!))['version'], 3);
        } else {
          expect(listEquals(after[name], before[name]), isTrue, reason: name);
        }
      }
      expect(await store.nights(), [for (final n in nights) n == nights[1] ? changed : n]);
      expect(lines, isEmpty);
    });
  }

  // D92 item 1: a recording's audio is kept in the journal's folder,
  // appended as it comes, read back in ranges.
  test('audio grows as appended, and reads back in ranges', () async {
    final store = await JournalStore.open(files);
    final id = 'a' * 32;
    await store.appendAudio(id, sound(6400));
    await store.appendAudio(id, sound(3200, 6400), sync: true);
    expect(files.everything().keys, [JournalStore.audioOf(id, 0)]);
    expect(await store.audioPart(id), (start: 0, size: 9600));
    expect(await store.readAudio(id, 0, 6000, 1000), sound(1000, 6000));
    expect(await store.readAudio(id, 0, 9000, 1000), sound(600, 9000));
    expect(await store.audioPart('b' * 32), isNull);
  });

  // D94: the part whose words are in is cut away; the rest keeps its place.
  test('a cut keeps only the rest, under its new start', () async {
    final store = await JournalStore.open(files);
    final id = 'a' * 32;
    await store.appendAudio(id, sound(64000), sync: true);
    await store.cutAudio(id, 32000);
    expect(files.everything().keys, [JournalStore.audioOf(id, 32000)]);
    expect(await store.audioPart(id), (start: 32000, size: 32000));
    expect(await store.readAudio(id, 32000, 40000, 100), sound(100, 40000));
    await store.cutAudio(id, 32000);
    await store.cutAudio(id, 2);
    expect(files.everything().keys, [JournalStore.audioOf(id, 32000)]);
    await store.cutAudio(id, 64000);
    expect(await store.audioPart(id), (start: 64000, size: 0));
  });

  test('a misshapen audio id or start is refused before any file', () {
    expect(() => JournalStore.audioOf('A' * 32, 0), throwsArgumentError);
    expect(() => JournalStore.audioOf('a' * 32, 3), throwsArgumentError);
    expect(() => JournalStore.audioOf('a' * 32, -2), throwsArgumentError);
    expect(JournalStore.audioOf('a' * 32, 64000), 'audio-${'a' * 32}-64000.pcm');
  });

  // D92 item 4 (R11; workflow (d)): deleting a night deletes the audio of
  // every recording of it still waiting, and nothing of another night.
  test("deleting a night deletes its waiting audio, no other's", () async {
    final store = await JournalStore.open(files);
    final [first, second, ...] = nightsFromFixtures();
    final (x, y, z) = ('1' * 32, '2' * 32, '3' * 32);
    await store.save(first.withEntries([...first.entries, Waiting(x), Waiting(y, 32000)]));
    await store.save(second.withEntries([Waiting(z), ...second.entries]));
    for (final id in [x, y, z]) {
      await store.appendAudio(id, sound(64000));
    }
    await store.cutAudio(y, 32000);
    await files.write('${JournalStore.tempPrefix}${JournalStore.audioOf(x, 640)}', sound(10));
    await store.delete(first.id);
    final after = files.everything();
    expect(after.keys.toSet(), {JournalStore.fileOf(second.id), JournalStore.audioOf(z, 0)});
    for (final bytes in after.values) {
      for (final t in [...traces(first), utf8.encode(x), utf8.encode(y)]) {
        expect(holds(bytes, t), isFalse);
      }
    }
  });

  test('discarding a recording removes every part of it', () async {
    final store = await JournalStore.open(files);
    final id = 'a' * 32;
    await store.appendAudio(id, sound(64000));
    await files.write(JournalStore.audioOf(id, 32000), sound(10));
    await store.discardAudio(id);
    expect(files.everything(), isEmpty);
  });

  // An interrupted recording, a night deleted before its audio, or a cut
  // that did not finish leaves audio no night needs: swept at open.
  test('at open, audio no night names is swept with a code', () async {
    await files.open();
    final [first, second, ...] = nightsFromFixtures();
    final (kept, old, damaged, loose) = ('1' * 32, '2' * 32, '3' * 32, '4' * 32);
    await files.write(JournalStore.fileOf(first.id), encodeNight(first.withEntries([Waiting(kept), Waiting(old, 64)])));
    final unreadable = utf8.decode(encodeNight(second.withEntries([Waiting(damaged)])));
    final damagedBytes = utf8.encode(unreadable.replaceFirst('"version":3', '"version":4'));
    await files.write(JournalStore.fileOf(second.id), damagedBytes);
    for (final name in [
      JournalStore.audioOf(kept, 0),
      JournalStore.audioOf(old, 0),
      JournalStore.audioOf(old, 64),
      JournalStore.audioOf(damaged, 0),
      JournalStore.audioOf(loose, 0),
      JournalStore.audioOf(loose, 64),
    ]) {
      await files.write(name, sound(128));
    }
    await JournalStore.open(files);
    expect(files.everything().keys.toSet(), {
      JournalStore.fileOf(first.id),
      JournalStore.fileOf(second.id),
      JournalStore.audioOf(kept, 0),
      JournalStore.audioOf(old, 64),
      JournalStore.audioOf(damaged, 0),
    });
    expect(lines, ['audioSwept', 'audioSwept', 'audioSwept']);
  });

  test('deleting the journal takes the audio too', () async {
    final store = await JournalStore.open(files);
    final first = nightsFromFixtures().first;
    await store.save(first.withEntries([Waiting('1' * 32)]));
    await store.appendAudio('1' * 32, sound(640));
    await store.deleteAll();
    expect(files.everything(), isEmpty);
  });

  test('deleting a night leaves nothing of it anywhere', () async {
    final store = await JournalStore.open(files);
    final nights = nightsFromFixtures();
    for (final n in nights) {
      await store.save(n);
    }
    final gone = nights[1];
    final before = files.everything();
    await store.delete(gone.id);
    final after = files.everything();
    expect(after.length, before.length - 1);
    for (final bytes in after.values) {
      for (final t in traces(gone)) {
        expect(holds(bytes, t), isFalse);
      }
    }
    after.forEach((name, bytes) => expect(listEquals(bytes, before[name]), isTrue, reason: name));
    expect(await store.nights(), [for (final n in nights) if (n != gone) n]);
  });

  test('an edit leaves one version, and the earlier words nowhere', () async {
    final store = await JournalStore.open(files);
    final [first, second, ...] = nightsFromFixtures();
    await store.save(first);
    final edited = first.withDreams(second.dreams);
    await store.save(edited);
    final all = files.everything();
    expect(all.keys, [JournalStore.fileOf(first.id)]);
    for (final t in traces(first).take(first.dreams.length * 2)) {
      expect(holds(all.values.single, t), isFalse);
    }
    expect(await store.nights(), [edited]);
  });

  test('deleting the journal empties the folder', () async {
    final store = await JournalStore.open(files);
    for (final n in nightsFromFixtures()) {
      await store.save(n);
    }
    await store.markFirstUseSeen();
    await files.write('night-${'0' * 32}.json', utf8.encode('{}'));
    await files.write('notes', utf8.encode('x'));
    await files.write('${JournalStore.tempPrefix}night-${'1' * 32}.json', utf8.encode('x'));
    await store.deleteAll();
    expect(files.everything(), isEmpty);
    expect(await store.firstUseSeen(), isFalse);
    expect(await store.nights(), isEmpty);
  });

  test('deleting the journal does not depend on file names', () async {
    final folder = NoNamedDelete(files.dir);
    final store = await JournalStore.open(folder);
    for (final n in nightsFromFixtures()) {
      await store.save(n);
    }
    File('${files.dir.path}/odd name').writeAsBytesSync([1]);
    File('${files.dir.path}/\u00e9').writeAsBytesSync([1]);
    Directory('${files.dir.path}/sub').createSync();
    File('${files.dir.path}/sub/inside').writeAsBytesSync([1]);
    await store.deleteAll();
    expect(files.dir.listSync(recursive: true), isEmpty);
    expect(await store.nights(), isEmpty);
  });

  test('a save cut short leaves the last whole version', () async {
    final night = nightsFromFixtures().first;
    final store = await JournalStore.open(files);
    await store.save(night);
    final changed = night.withDreams(nightsFromFixtures()[2].dreams);
    final broken = await JournalStore.open(BrokenRename(files.dir));
    await expectLater(broken.save(changed), throwsA(isA<FileSystemException>()));
    expect(files.everything().keys, [JournalStore.fileOf(night.id)],
        reason: 'a failed save removes its own temporary file');
    // A crash leaves what a failed save cleans up itself: the next open
    // removes it.
    await files.write(JournalStore.tempPrefix + JournalStore.fileOf(night.id), encodeNight(changed));
    final reopened = await JournalStore.open(files);
    expect(files.everything().keys, [JournalStore.fileOf(night.id)]);
    expect(await reopened.nights(), [night]);
    expect(lines, ['journalTempSwept']);
  });

  test('deleting a night takes a cut save temp file', () async {
    final store = await JournalStore.open(files);
    final [first, second, ...] = nightsFromFixtures();
    await store.save(first);
    final edited = first.withDreams(second.dreams);
    await files.write(JournalStore.tempPrefix + JournalStore.fileOf(first.id), encodeNight(edited));
    await store.delete(first.id);
    expect(files.everything(), isEmpty);
  });

  test('deleting the journal waits for a save in flight', () async {
    final gated = Gated(files.dir);
    final store = await JournalStore.open(gated);
    gated.hold = Completer<void>();
    addTearDown(() => gated.hold.isCompleted ? null : gated.hold.complete());
    final saving = store.save(nightsFromFixtures().first);
    await gated.reached.future;
    final deleting = store.deleteAll();
    await pumpEventQueue();
    gated.hold.complete();
    await Future.wait([saving, deleting]);
    expect(gated.log, ['rename:start', 'rename:end', 'deleteAll:start']);
    expect(files.everything(), isEmpty);
  });

  test('a delete between a save write and rename waits', () async {
    final gated = Gated(files.dir);
    final store = await JournalStore.open(gated);
    final night = nightsFromFixtures().first;
    gated.hold = Completer<void>();
    addTearDown(() => gated.hold.isCompleted ? null : gated.hold.complete());
    final saving = store.save(night);
    await gated.reached.future;
    final deleting = store.delete(night.id);
    await pumpEventQueue();
    gated.hold.complete();
    await Future.wait([saving, deleting]);
    expect(gated.log, ['rename:start', 'rename:end', 'delete:start', 'delete:start']);
    expect(files.everything(), isEmpty);
    expect(await store.nights(), isEmpty);
  });

  test('an unreadable file is skipped with a code, never touched', () async {
    final store = await JournalStore.open(files);
    final [good, other, third, ...] = nightsFromFixtures();
    await store.save(good);
    final wrongId = encodeNight(other);
    final bad = <String, Uint8List>{
      'night-${'a' * 32}.json': utf8.encode('not json'),
      'night-${'b' * 32}.json': Uint8List.fromList([0xff, 0xfe, 0x00]),
      'night-${'c' * 32}.json': wrongId,
      // Under its own id, so only the damage (an unknown version) refuses it.
      JournalStore.fileOf(third.id): utf8.encode(utf8.decode(encodeNight(third)).replaceFirst('"version":3', '"version":4')),
    };
    for (final MapEntry(:key, :value) in bad.entries) {
      await files.write(key, value);
    }
    expect(await store.nights(), [good]);
    expect(lines, List.filled(bad.length, 'journalFileSkipped'));
    await store.save(other);
    await store.delete(good.id);
    final all = files.everything();
    bad.forEach((name, bytes) => expect(listEquals(all[name], bytes), isTrue, reason: name));
  });

  test('a file that is not a night is left alone, silently', () async {
    final store = await JournalStore.open(files);
    await files.write('notes', utf8.encode('x'));
    expect(await store.nights(), isEmpty);
    expect(lines, isEmpty);
    expect(files.everything().keys, ['notes']);
  });

  test('the first-use flag is kept until the journal is deleted', () async {
    final store = await JournalStore.open(files);
    expect(await store.firstUseSeen(), isFalse);
    await store.markFirstUseSeen();
    expect(await store.firstUseSeen(), isTrue);
    expect(await (await JournalStore.open(files)).firstUseSeen(), isTrue);
    await store.deleteAll();
    expect(await store.firstUseSeen(), isFalse);
  });

  // D103; D122; D125 item 8; docs/workflow.md (c): the consents sit beside the
  // nights, hold only that the dreamer is 18 or over (C146-I item 1) and two
  // answers, (a) and (b), change no night, the first-use flag or any audio,
  // and survive the sweep at open. Version 1 (D103) reads as (a) given and (b)
  // not; version 2, which also held the retired night images consent (c),
  // still reads; keeping version 3 over either loses no night.
  test('version 1 reads; version 3 replaces it, changing no night', () async {
    final store = await JournalStore.open(files);
    final nights = nightsFromFixtures();
    for (final n in nights) {
      await store.save(n);
    }
    final x = '1' * 32;
    await store.save(nights.first.withEntries([...nights.first.entries, Waiting(x)]));
    await store.appendAudio(x, sound(64));
    await store.markFirstUseSeen();
    expect(await store.consents(), isNull);
    await files.write(JournalStore.consentFile, utf8.encode('{"version":1,"over18":true}'));
    final before = files.everything();
    final old = await store.consents();
    expect(old!.given(Consent.readings), isTrue);
    expect(old.given(Consent.lifeContext), isFalse);
    expect(old.answers[Consent.readings]!.day, isNull);
    expect(old.retiredImages, isNull);
    final now = DateTime.utc(2026, 11, 21, 22, 30);
    final next = old.withAnswer(Consent.lifeContext, true, now);
    await store.keepConsents(next);
    final reopened = await JournalStore.open(files);
    expect(await reopened.consents(), next);
    final after = files.everything();
    expect(after.keys.toSet(), before.keys.toSet());
    for (final name in before.keys.where((n) => n != JournalStore.consentFile)) {
      expect(listEquals(after[name], before[name]), isTrue, reason: name);
    }
    expect(jsonDecode(utf8.decode(after[JournalStore.consentFile]!)), {
      'version': 3,
      'over18': true,
      'readings': {'given': true},
      'lifeContext': {'given': true, 'day': '2026-11-21'},
    });
    expect((await reopened.nights()).length, nights.length);
    expect(lines, isEmpty);
  });

  // D125 item 8: a version 2 file reads as before, its (c) answer kept in
  // memory only (to carry a "no" to the Night images setting); keeping it
  // writes version 3 with no (c), changing no night.
  test('version 2 reads, its (c) apart; keeping writes (a) and (b)', () async {
    final store = await JournalStore.open(files);
    for (final n in nightsFromFixtures()) {
      await store.save(n);
    }
    for (final given in [true, false]) {
      await files.write(
        JournalStore.consentFile,
        utf8.encode(
          '{"version":2,"over18":true,"readings":{"given":true,"day":"2026-11-20"},'
          '"lifeContext":{"given":false,"day":"2026-11-20"},"images":{"given":$given,"day":"2026-11-21"}}',
        ),
      );
      final old = (await store.consents())!;
      expect(old.given(Consent.readings), isTrue);
      expect(old.given(Consent.lifeContext), isFalse);
      expect(old.answers[Consent.readings]!.day, '2026-11-20');
      expect(old.retiredImages, given);
      expect(Consent.values, [Consent.readings, Consent.lifeContext]);
    }
    final before = files.everything();
    await store.keepConsents((await store.consents())!);
    final kept = jsonDecode(utf8.decode(files.everything()[JournalStore.consentFile]!)) as Map<String, dynamic>;
    expect(kept.keys, ['version', 'over18', 'readings', 'lifeContext']);
    expect(kept['version'], 3);
    expect((await store.consents())!.retiredImages, isNull);
    final after = files.everything();
    for (final name in before.keys.where((n) => n != JournalStore.consentFile)) {
      expect(listEquals(after[name], before[name]), isTrue, reason: name);
    }
  });

  test('a consents file that does not read exactly is none', () async {
    final store = await JournalStore.open(files);
    const a = '"readings":{"given":true},"lifeContext":{"given":false}';
    const c = '"images":{"given":false}';
    for (final bad in [
      '',
      'x',
      '[]',
      '{}',
      '{"version":1}',
      '{"over18":true}',
      '{"version":1,"over18":false}',
      '{"version":4,"over18":true,$a}',
      '{"version":1,"over18":true,"x":1}',
      '{"version":3,"over18":true}',
      '{"version":3,"over18":false,$a}',
      '{"version":3,$a}',
      '{"version":3,"over18":true,$a,"x":1}',
      '{"version":3,"over18":true,$a,$c}',
      '{"version":3,"over18":true,"readings":{"given":true}}',
      '{"version":2,"over18":true}',
      '{"version":2,"over18":true,$a}',
      '{"version":2,"over18":true,$a,$c,"x":1}',
      '{"version":3,"over18":true,"readings":{"given":1},"lifeContext":{"given":false}}',
      '{"version":3,"over18":true,"readings":{},"lifeContext":{"given":false}}',
      '{"version":3,"over18":true,"readings":{"given":true,"x":1},"lifeContext":{"given":false}}',
      '{"version":3,"over18":true,"readings":{"given":true,"day":"21/11/26"},"lifeContext":{"given":false}}',
      '{"version":3,"over18":true,"readings":{"given":true,"day":7},"lifeContext":{"given":false}}',
      '{"version":2,"over18":true,"readings":{"given":true},"lifeContext":{"given":false},"images":{"given":1}}',
    ]) {
      await files.write(JournalStore.consentFile, utf8.encode(bad));
      expect(await store.consents(), isNull, reason: bad);
    }
    await files.write(JournalStore.consentFile, Uint8List.fromList([0xff, 0xfe]));
    expect(await store.consents(), isNull);
    await files.write(JournalStore.consentFile, utf8.encode('{"version":3,"over18":true,$a}'));
    expect((await store.consents())!.given(Consent.readings), isTrue);
    final k = Consents.answered({Consent.lifeContext: true}, DateTime.utc(2026, 1, 2));
    await store.keepConsents(k);
    expect(await store.consents(), k);
  });

  test('consents cut short leave none and no temporary file', () async {
    final store = await JournalStore.open(BrokenRename(files.dir));
    await expectLater(
      store.keepConsents(Consents.answered({}, DateTime.utc(2026))),
      throwsA(isA<FileSystemException>()),
    );
    expect(files.everything(), isEmpty);
    expect(await store.consents(), isNull);
  });

  // D122, D125 item 8; docs/workflow.md (c): the settings sit beside the
  // nights, change none of them, and read back exactly; a file that does not
  // read is none, and the defaults stand. Version 2 holds Night images as
  // chosen, Off included (no consent stands behind it now).
  test('the settings are kept beside the nights, changing none of them', () async {
    final store = await JournalStore.open(files);
    for (final n in nightsFromFixtures()) {
      await store.save(n);
    }
    await store.keepConsents(Consents.answered({Consent.readings: true}, DateTime.utc(2026)));
    final before = files.everything();
    expect(await store.settings(), isNull);
    expect(const Settings().images, NightImages.off);
    const s = Settings(wordAnimation: false, nightDay: NightDayMode.night, images: NightImages.random, length: LifeContextLength.threeMonths);
    await store.keepSettings(s);
    expect(await (await JournalStore.open(files)).settings(), s);
    final after = files.everything();
    expect(after.keys.toSet(), {...before.keys, JournalStore.settingsFile});
    before.forEach((name, bytes) => expect(listEquals(after[name], bytes), isTrue, reason: name));
    expect(jsonDecode(utf8.decode(after[JournalStore.settingsFile]!)), {
      'version': 2,
      'wordAnimation': false,
      'nightDay': 'night',
      'images': 'random',
      'length': 'threeMonths',
    });
    expect(lines, isEmpty);
  });

  test('a settings file that does not read exactly is none', () async {
    final store = await JournalStore.open(files);
    const good = '"wordAnimation":true,"nightDay":"automatic","images":"personal","length":"twoWeeks"';
    for (final bad in [
      '',
      '[]',
      '{"version":2}',
      '{"version":3,$good}',
      '{"version":2,$good,"x":1}',
      '{"version":2,"wordAnimation":1,"nightDay":"automatic","images":"personal","length":"twoWeeks"}',
      '{"version":2,"wordAnimation":true,"nightDay":"manual","images":"personal","length":"twoWeeks"}',
      '{"version":2,"wordAnimation":true,"nightDay":"automatic","images":"always","length":"twoWeeks"}',
      '{"version":2,"wordAnimation":true,"nightDay":"automatic","images":"personal","length":"forever"}',
      // Version 1 never held Off.
      '{"version":1,"wordAnimation":true,"nightDay":"automatic","images":"off","length":"twoWeeks"}',
    ]) {
      await files.write(JournalStore.settingsFile, utf8.encode(bad));
      expect(await store.settings(), isNull, reason: bad);
    }
    await files.write(JournalStore.settingsFile, utf8.encode('{"version":2,$good}'));
    expect((await store.settings())!.images, NightImages.personal);
    await files.write(JournalStore.settingsFile, utf8.encode('{"version":2,${good.replaceFirst("personal", "off")}}'));
    expect(await store.settings(), const Settings());
  });

  // D125 item 8: a version 1 settings file chose a painting for while consent
  // (c) was given. It reads as that choice only beside a version 2 consents
  // file with (c) given; beside any other, Night images is Off, so nothing
  // is sent that was not agreed to. Read, it is kept again as version 2,
  // losing no other setting.
  for (final (name, consents, images) in <(String, String?, NightImages)>[
    ('(c) given', '"images":{"given":true,"day":"2026-11-21"}', NightImages.random),
    ('(c) not given', '"images":{"given":false,"day":"2026-11-21"}', NightImages.off),
    ('no (c)', null, NightImages.off),
  ]) {
    test('version 1 settings beside a consents file with $name', () async {
      final store = await JournalStore.open(files);
      await files.write(
        JournalStore.consentFile,
        utf8.encode(
          consents == null
              ? '{"version":3,"over18":true,"readings":{"given":true},"lifeContext":{"given":false}}'
              : '{"version":2,"over18":true,"readings":{"given":true},"lifeContext":{"given":false},$consents}',
        ),
      );
      await files.write(
        JournalStore.settingsFile,
        utf8.encode(
          '{"version":1,"wordAnimation":false,"nightDay":"night","images":"random","length":"oneMonth"}',
        ),
      );
      final before = files.everything();
      final read = (await store.settings())!;
      expect(read.images, images);
      expect(read.wordAnimation, isFalse);
      expect(read.nightDay, NightDayMode.night);
      expect(read.length, LifeContextLength.oneMonth);
      final kept = jsonDecode(utf8.decode(files.everything()[JournalStore.settingsFile]!)) as Map<String, dynamic>;
      expect(kept['version'], 2);
      expect(kept['images'], images.name);
      expect(await store.settings(), read);
      final after = files.everything();
      for (final n in before.keys.where((n) => n != JournalStore.settingsFile)) {
        expect(listEquals(after[n], before[n]), isTrue, reason: n);
      }
    });
  }

  // D125 item 8 (review): before, "(c) given" with no settings file meant
  // Personal, the old default. That yes is kept: a version 2 consents file with
  // (c) given and no settings file reads as Personal, kept as version 2; with
  // (c) not given, or beside version 3, there are no settings, and the
  // defaults (Off) stand.
  for (final (name, consents, expected) in <(String, String, NightImages?)>[
    ('(c) given', '"images":{"given":true,"day":"2026-11-21"}', NightImages.personal),
    ('(c) not given', '"images":{"given":false,"day":"2026-11-21"}', null),
  ]) {
    test('no settings file beside version 2 with $name', () async {
      final store = await JournalStore.open(files);
      await files.write(
        JournalStore.consentFile,
        utf8.encode(
          '{"version":2,"over18":true,"readings":{"given":true},"lifeContext":{"given":false},$consents}',
        ),
      );
      final read = await store.settings();
      expect(read?.images, expected);
      if (expected == null) {
        expect(files.everything().keys, [JournalStore.consentFile]);
      } else {
        expect(read, const Settings(images: NightImages.personal));
        expect(decodeSettings(files.everything()[JournalStore.settingsFile]!), read);
      }
    });
  }

  test('no settings file beside version 3: none', () async {
    final store = await JournalStore.open(files);
    await store.keepConsents(Consents.answered({Consent.readings: true}, DateTime.utc(2026)));
    expect(await store.settings(), isNull);
    expect(files.everything().keys, [JournalStore.consentFile]);
  });

  test('settings cut short leave none and no temporary file', () async {
    final store = await JournalStore.open(BrokenRename(files.dir));
    await expectLater(store.keepSettings(const Settings()), throwsA(isA<FileSystemException>()));
    expect(files.everything(), isEmpty);
  });

  // X11; D54; D110: deleting the journal takes the consents and the
  // settings with everything else.
  test('deleting the journal takes the consents and the settings', () async {
    final store = await JournalStore.open(files);
    await store.save(nightsFromFixtures().first);
    await store.keepConsents(Consents.answered({Consent.readings: true}, DateTime.utc(2026)));
    await store.keepSettings(const Settings(wordAnimation: false));
    await store.deleteAll();
    expect(await store.consents(), isNull);
    expect(await store.settings(), isNull);
    expect(files.everything(), isEmpty);
  });

  test('a malformed id is refused before any file is named', () {
    expect(() => JournalStore.fileOf('../x'), throwsArgumentError);
    expect(() => IoJournalFiles(dir).read('../x'), throwsArgumentError);
  });

  // D61: one turn of the queue reads a night, changes it and writes it.
  test('an update changes a night; a delete behind it still wins', () async {
    final store = await JournalStore.open(files);
    final n = nightsFromFixtures().first;
    await store.save(n);
    final changed = store.update(n.id, (x) => x.withDreams(const ['x']));
    final gone = store.delete(n.id);
    expect(await changed, isTrue);
    await gone;
    expect(files.everything(), isEmpty);
  });

  test('an update changes the dreams, and null deletes the night', () async {
    final store = await JournalStore.open(files);
    final n = nightsFromFixtures().first;
    await store.save(n);
    expect(await store.update(n.id, (x) => x.withDreams([...x.dreams, 'x'])), isTrue);
    expect((await store.nights()).single.dreams, [...n.dreams, 'x']);
    expect(await store.update(n.id, (x) => null), isTrue);
    expect(files.everything(), isEmpty);
  });

  test('an update of a missing or unreadable night changes nothing', () async {
    final store = await JournalStore.open(files);
    final n = nightsFromFixtures().first;
    var called = false;
    Night? touch(Night x) {
      called = true;
      return null;
    }

    expect(await store.update(n.id, touch), isFalse);
    await files.write(JournalStore.fileOf(n.id), utf8.encode('not a night'));
    expect(await store.update(n.id, touch), isFalse);
    expect(called, isFalse);
    expect(utf8.decode(files.everything()[JournalStore.fileOf(n.id)]!), 'not a night');
  });

  test('an update that throws writes nothing, and the queue goes on', () async {
    final store = await JournalStore.open(files);
    final n = nightsFromFixtures().first;
    await store.save(n);
    final before = files.everything();
    await expectLater(store.update(n.id, (x) => throw StateError('x')), throwsStateError);
    await expectLater(store.update(n.id, (x) => x.withDreams(const ['y'])), completion(isTrue));
    expect(before.keys.single, files.everything().keys.single);
    expect((await store.nights()).single.dreams, const ['y']);
  });

  test('an update leaves a file that holds another id alone', () async {
    final store = await JournalStore.open(files);
    final [a, b] = nightsFromFixtures().take(2).toList();
    await files.write(JournalStore.fileOf(a.id), encodeNight(b));
    var called = false;
    expect(await store.update(a.id, (x) {
      called = true;
      return null;
    }), isFalse);
    expect(called, isFalse);
    expect(files.everything()[JournalStore.fileOf(a.id)], encodeNight(b));
  });
}
