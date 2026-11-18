// A recording's audio, kept in the journal's folder until its words come
// (D92 item 1): the keep a recording hands its audio to, and what the
// retries read and write (D94), over the store's one queue. New ids come
// from the system's secure source, as a night's do, and name files on the
// phone only (R4). Words that come put in their night in one turn of the
// queue, before the audio they cover is cut away or deleted, so a cut or
// a crash between the two never hears the same words twice.
import 'dart:math';
import 'dart:typed_data';

import '../core/safe_log.dart';
import '../recording/audio_keep.dart';
import '../recording/retries.dart';
import 'journal_store.dart';
import 'night.dart';
import 'night_rules.dart';

final class JournalAudio implements AudioKeep, WaitingAudio {
  JournalAudio(this._store, [this._random]);

  final JournalStore _store;
  final Random? _random;

  @override
  String newId() => newNightId(_random);

  @override
  Future<void> add(String id, Uint8List bytes, {bool last = false}) => _store.appendAudio(id, bytes, sync: last);

  @override
  Future<void> discard(String id) => _store.discardAudio(id);

  /// SoulDreams Dev's diagnostic (D98): the audio files in the folder and
  /// the recordings waiting, as two numbers (R3). It never throws.
  Future<void> logCounts() async {
    try {
      final c = await _store.audioCounts();
      SafeLog.event(LogEvent.journalAudio, [c.files, c.waiting]);
    } on Object {
      // A diagnostic: nothing depends on it.
    }
  }

  @override
  Future<List<Pending>> waiting() async => [
    for (final n in await _store.nights())
      for (final e in n.entries)
        if (e is Waiting) (night: n.id, audio: e.audio, from: e.from),
  ];

  @override
  Future<({int start, int size})?> part(String audio) => _store.audioPart(audio);

  @override
  Future<Uint8List> read(String audio, int start, int at, int length) => _store.readAudio(audio, start, at, length);

  // The words become a dream of their own in the recording's place (D93
  // Q2), trimmed at their start; none, and nothing is added (D93 Q7). A
  // night left with nothing is deleted (P10). The night, the recording, or
  // both gone: its audio goes too.
  @override
  Future<void> heard(Pending pending, String words, int to, {required bool done}) async {
    final text = words.trimLeft();
    var found = false;
    final landed = await _store.update(pending.night, (n) {
      final i = n.entries.indexWhere((e) => e is Waiting && e.audio == pending.audio);
      if (i < 0) return n;
      found = true;
      final told = [if (!isEmptyText(text)) Told(text)];
      final entries = [...n.entries]..replaceRange(i, i + 1, [...told, if (!done) Waiting(pending.audio, to)]);
      return entries.isEmpty ? null : n.withEntries(entries);
    });
    if (done || !found) {
      // A night that is there but does not read keeps the audio it names; a
      // damaged night is never touched (D49 c).
      if (landed || !await _store.hasNightFile(pending.night)) await _store.discardAudio(pending.audio);
    } else {
      await _store.cutAudio(pending.audio, to);
    }
  }
}
