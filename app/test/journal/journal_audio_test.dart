// The keep a recording hands its audio to (D92 item 1): the journal's
// folder, through the store's one queue.
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_audio.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';

import '../fixtures.dart';
import 'io_journal_files.dart';

void main() {
  late Directory dir;
  late IoJournalFiles files;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('audio-');
    files = IoJournalFiles(Directory('${dir.path}/Journal'));
  });

  tearDown(() => dir.deleteSync(recursive: true));

  test('audio goes into the journal folder, and is discarded whole', () async {
    final store = await JournalStore.open(files);
    final keep = JournalAudio(store, Random(4));
    final id = keep.newId();
    expect(id, matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(keep.newId(), isNot(id));
    await keep.add(id, Uint8List.fromList([1, 2]));
    await keep.add(id, Uint8List.fromList([3, 4]), last: true);
    expect(files.everything().keys, [JournalStore.audioOf(id, 0)]);
    expect(files.everything().values.single, [1, 2, 3, 4]);
    await keep.discard(id);
    expect(files.everything(), isEmpty);
  });

  // D92 item 4: words for a recording its night no longer names change
  // nothing, and its audio goes.
  test('words for a recording no night names: its audio goes', () async {
    final store = await JournalStore.open(files);
    final keep = JournalAudio(store);
    final night = nightsFromFixtures().first;
    await store.save(night);
    final id = '1' * 32;
    await keep.add(id, Uint8List(6400), last: true);
    await keep.heard((night: night.id, audio: id, from: 0), 'x', 3200, done: false);
    expect(await store.nights(), [night]);
    expect(files.everything().keys, [JournalStore.fileOf(night.id)]);
  });

  // D49 c, decision 3: audio a night still names is not deleted because that
  // night's file stopped reading; a night truly gone loses its audio.
  test('unreadable night keeps its audio; a gone night loses it', () async {
    final store = await JournalStore.open(files);
    final keep = JournalAudio(store);
    final night = nightsFromFixtures().first;
    final x = '1' * 32;
    await store.save(night.withEntries([Waiting(x)]));
    await keep.add(x, Uint8List(6400), last: true);
    final name = JournalStore.fileOf(night.id);
    await files.write(name, Uint8List.fromList([1, 2, 3]));
    await keep.heard((night: night.id, audio: x, from: 0), 'words', 3200, done: false);
    expect(files.everything().keys, containsAll([name, JournalStore.audioOf(x, 0)]));
    await files.delete(name);
    await keep.heard((night: night.id, audio: x, from: 0), 'words', 3200, done: false);
    expect(files.everything(), isEmpty);
  });

  // D98: a line for DevTools, numbers only (R3): the audio files in the
  // folder, then the recordings its nights name as waiting.
  test('the counts line: audio files, then waiting recordings', () async {
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    final store = await JournalStore.open(files);
    final keep = JournalAudio(store);
    await keep.logCounts();
    expect(lines, ['journalAudio 0 0']);
    final night = nightsFromFixtures().first;
    final (x, y, z) = ('1' * 32, '2' * 32, '3' * 32);
    await store.save(night.withEntries([Told(night.dreams[0]), Waiting(x), Waiting(y)]));
    await keep.add(x, Uint8List(64), last: true);
    await keep.add(y, Uint8List(64), last: true);
    await keep.add(z, Uint8List(64), last: true);
    await keep.logCounts();
    expect(lines.last, 'journalAudio 3 2');
    expect(lines, hasLength(2));
  });
}
