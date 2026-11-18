// A recording's audio, kept in the journal's folder until its words come
// (D92 item 1): the keep a recording hands its audio to, over the store's
// one queue. New ids come from the system's secure source, as a night's
// do, and name files on the phone only (R4).
import 'dart:math';
import 'dart:typed_data';

import '../recording/audio_keep.dart';
import 'journal_store.dart';
import 'night.dart';

final class JournalAudio implements AudioKeep {
  JournalAudio(this._store, [this._random]);

  final JournalStore _store;
  final Random? _random;

  @override
  String newId() => newNightId(_random);

  @override
  Future<void> add(String id, Uint8List bytes, {bool last = false}) => _store.appendAudio(id, bytes, sync: last);

  @override
  Future<void> discard(String id) => _store.discardAudio(id);
}
