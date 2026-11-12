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
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';

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
    final [good, other, ...] = nightsFromFixtures();
    await store.save(good);
    final wrongId = encodeNight(other);
    final bad = <String, Uint8List>{
      'night-${'a' * 32}.json': utf8.encode('not json'),
      'night-${'b' * 32}.json': Uint8List.fromList([0xff, 0xfe, 0x00]),
      'night-${'c' * 32}.json': wrongId,
      'night-${'d' * 32}.json': utf8.encode(utf8.decode(encodeNight(good)).replaceFirst('"version":1', '"version":2')),
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

  test('a malformed id is refused before any file is named', () {
    expect(() => JournalStore.fileOf('../x'), throwsArgumentError);
    expect(() => IoJournalFiles(dir).read('../x'), throwsArgumentError);
  });
}
