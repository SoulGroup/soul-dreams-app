// The journal on the phone (D49 b; R11): one JSON file per night. A save
// writes the whole night to a temporary file and renames it into place,
// so the folder always holds one whole version of each night and no
// earlier one. Deleting a night deletes its file and any temporary file
// of its save; deleting the journal deletes every file in the folder. A
// file that does not read as a night is skipped with a code and left
// exactly as it is (D49 c), until the journal is deleted.
//
// D54: every operation waits for the one before it (one queue), so a
// delete can never fall between a save's write and its rename, and a
// save in flight can never bring a night back after the journal is
// deleted. A save that fails removes its own temporary file.
//
// A recording's audio (D92, D94) is kept in the same folder until its
// words come: `audio-<id>-<start>.pcm`, plain 16 kHz mono PCM, holding
// the recording's bytes from `start` on. A night names it while it waits
// (a Waiting dream); deleting the night deletes it (D92 item 4). When
// part of its words have come, the part they cover is cut away: the rest
// is copied to a file with the later start, which then replaces it. At
// open, audio no night names is deleted, and so is an older copy left by
// a cut that did not finish.
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show visibleForTesting;

import '../core/safe_log.dart';
import 'journal_files.dart';
import 'night.dart';

final _nightFile = RegExp(r'^night-([0-9a-f]{32})\.json$');
final _id = RegExp(r'^[0-9a-f]{32}$');
final _audioFile = RegExp(r'^audio-([0-9a-f]{32})-(0|[1-9][0-9]{0,9})\.pcm$');
// How a night's file names a waiting recording (encodeNight's own form).
final _named = RegExp(r'"waiting":"([0-9a-f]{32})"');

/// What is left on the phone of a recording: its bytes from [start] of
/// the recording on, [size] of them.
typedef AudioPart = ({int start, int size});

final class JournalStore {
  JournalStore._(this._files);

  final JournalFiles _files;

  /// What a save writes first, before the rename.
  static const tempPrefix = '.tmp-';

  /// Kept once the recording screen's first-use line has been met
  /// (MP·10, then MP·32); removed with the journal (D49 c, O6).
  static const firstUseFlag = 'first-use-seen';

  // The one queue (D54): each operation starts when the one before it,
  // whether it succeeded or failed, has finished. No operation calls
  // another queued one.
  static Future<void> _tail = Future<void>.value();

  /// Starts a new queue. For widget tests only: each test runs in its own
  /// fake-async zone, and a queue left by an earlier test's zone never
  /// moves again in the next one.
  @visibleForTesting
  static void newQueueForTests() => _tail = Future<void>.value();

  static Future<T> _run<T>(Future<T> Function() operation) {
    final result = _tail.then((_) => operation());
    _tail = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  /// The name of a night's file.
  static String fileOf(String id) {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    return 'night-$id.json';
  }

  /// The name of the file holding recording [id]'s bytes from [start] on.
  static String audioOf(String id, int start) {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    if (start < 0 || start.isOdd) throw ArgumentError('start');
    return 'audio-$id-$start.pcm';
  }

  /// Opens the folder, and removes what an interrupted save left, and any
  /// audio no night names (an interrupted recording, or a night deleted
  /// before its audio was).
  static Future<JournalStore> open(JournalFiles files) => _run(() async {
    await files.open();
    for (final name in await files.list()) {
      if (name.startsWith(tempPrefix)) {
        await files.delete(name);
        SafeLog.event(LogEvent.journalTempSwept);
      }
    }
    final names = await files.list();
    final named = <String>{};
    for (final name in names.where(_nightFile.hasMatch)) {
      final bytes = await files.read(name);
      if (bytes != null) named.addAll(_namedIn(bytes));
    }
    final newest = <String, int>{};
    for (final (id, start) in _audio(names)) {
      if (named.contains(id) && start > (newest[id] ?? -1)) newest[id] = start;
    }
    for (final (id, start) in _audio(names)) {
      if (newest[id] != start) {
        await files.delete(audioOf(id, start));
        SafeLog.event(LogEvent.audioSwept);
      }
    }
    return JournalStore._(files);
  });

  // The recordings a night's file names, read from its bytes whether or
  // not it reads as a night, so a damaged night's audio is never swept.
  static Set<String> _namedIn(Uint8List bytes) =>
      {for (final m in _named.allMatches(utf8.decode(bytes, allowMalformed: true))) m[1]!};

  // Every audio file in [names]: its recording's id and its start.
  static Iterable<(String, int)> _audio(List<String> names) sync* {
    for (final name in names) {
      final m = _audioFile.firstMatch(name);
      if (m != null) yield (m[1]!, int.parse(m[2]!));
    }
  }

  /// Every night that reads, earliest first recording first.
  Future<List<Night>> nights() => _run(() async {
    final out = <Night>[];
    for (final name in await _files.list()) {
      final match = _nightFile.firstMatch(name);
      if (match == null) continue;
      final bytes = await _files.read(name);
      final night = bytes == null ? null : decodeNight(bytes);
      if (night == null || night.id != match[1]) {
        SafeLog.event(LogEvent.journalFileSkipped);
        continue;
      }
      out.add(night);
    }
    out.sort((a, b) {
      final c = a.firstRecorded.compareTo(b.firstRecorded);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
    return out;
  });

  /// Saves the night whole, replacing any earlier version. If the save
  /// fails, its temporary file is removed before the failure is passed on.
  Future<void> save(Night night) => _run(() => _save(night));

  Future<void> _save(Night night) async {
    final name = fileOf(night.id);
    try {
      await _files.write(tempPrefix + name, encodeNight(night));
      await _files.rename(tempPrefix + name, name);
    } on Object {
      try {
        await _files.delete(tempPrefix + name);
      } on Object {
        // The next open removes it.
      }
      rethrow;
    }
  }

  /// Reads night [id], and writes back what [change] makes of it, all in
  /// one turn of the queue (D61), so no delete or save can fall between
  /// the read and the write. [change] returns the night to keep, the same
  /// night for no change, or null to delete it; it must not wait. Returns
  /// whether the night was there to change: a file that does not read as
  /// that night is left exactly as it is.
  Future<bool> update(String id, Night? Function(Night night) change) => _run(() async {
    final bytes = await _files.read(fileOf(id));
    final night = bytes == null ? null : decodeNight(bytes);
    if (night == null || night.id != id) return false;
    final next = change(night);
    if (next == null) {
      await _delete(id);
    } else if (next != night) {
      if (next.id != id) throw ArgumentError('id');
      await _save(next);
    }
    return true;
  });

  /// Deletes the night's file, the temporary file of a save of it, and the
  /// audio of every recording of it still waiting (D92 item 4).
  Future<void> delete(String id) => _run(() => _delete(id));

  Future<void> _delete(String id) async {
    final name = fileOf(id);
    final bytes = await _files.read(name);
    await _files.delete(name);
    await _files.delete(tempPrefix + name);
    if (bytes == null) return;
    for (final audio in _namedIn(bytes)) {
      await _discard(audio);
    }
  }

  /// Adds [bytes] to recording [id]'s audio, as it is recorded; with
  /// [sync], forced to the disk (at the recording's end).
  Future<void> appendAudio(String id, Uint8List bytes, {bool sync = false}) =>
      _run(() => _files.append(audioOf(id, 0), bytes, sync: sync));

  /// How many audio files the folder holds, and how many recordings its
  /// nights that read name as waiting (D98's diagnostic).
  Future<({int files, int waiting})> audioCounts() => _run(() async {
    final names = await _files.list();
    var waiting = 0;
    for (final name in names) {
      if (_nightFile.firstMatch(name) == null) continue;
      final bytes = await _files.read(name);
      final night = bytes == null ? null : decodeNight(bytes);
      if (night != null) waiting += night.entries.whereType<Waiting>().length;
    }
    return (files: _audio(names).length, waiting: waiting);
  });

  /// Whether night [id]'s file is in the folder, however it reads.
  Future<bool> hasNightFile(String id) => _run(() async => await _files.size(fileOf(id)) != null);

  /// What is left of recording [id], or null when nothing is.
  Future<AudioPart?> audioPart(String id) => _run(() => _part(id));

  Future<AudioPart?> _part(String id) async {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    int? start;
    for (final (audio, s) in _audio(await _files.list())) {
      if (audio == id && s > (start ?? -1)) start = s;
    }
    if (start == null) return null;
    final size = await _files.size(audioOf(id, start));
    return size == null ? null : (start: start, size: size);
  }

  /// Up to [length] bytes of recording [id] from [at], counted from the
  /// recording's start, out of the part that begins at [start].
  Future<Uint8List> readAudio(String id, int start, int at, int length) =>
      _run(() => _files.readRange(audioOf(id, start), at - start, length));

  /// Cuts away recording [id]'s bytes before [from], whose words are now
  /// in its night (D94): the rest is copied to a part that starts at
  /// [from], which then replaces the older one.
  Future<void> cutAudio(String id, int from) => _run(() async {
    final part = await _part(id);
    if (part == null || part.start >= from) return;
    final next = audioOf(id, from);
    await _files.copyTail(audioOf(id, part.start), tempPrefix + next, from - part.start);
    await _files.rename(tempPrefix + next, next);
    await _files.delete(audioOf(id, part.start));
  });

  /// Deletes every part of recording [id] (its words are all in, or none
  /// will come).
  Future<void> discardAudio(String id) => _run(() => _discard(id));

  // Every part, and any temporary file of a cut of it.
  Future<void> _discard(String id) async {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    for (final name in await _files.list()) {
      final bare = name.startsWith(tempPrefix) ? name.substring(tempPrefix.length) : name;
      if (_audioFile.firstMatch(bare)?[1] == id) await _files.delete(name);
    }
  }

  /// Deletes every entry in the journal's folder, whatever its name.
  Future<void> deleteAll() => _run(() => _files.deleteAll());

  Future<bool> firstUseSeen() => _run(() async => (await _files.list()).contains(firstUseFlag));

  Future<void> markFirstUseSeen() => _run(() => _files.write(firstUseFlag, Uint8List(0)));
}
