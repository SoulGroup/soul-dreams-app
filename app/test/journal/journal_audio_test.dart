// The keep a recording hands its audio to (D92 item 1): the journal's
// folder, through the store's one queue.
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/journal_audio.dart';
import 'package:souldreams/journal/journal_store.dart';

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
}
