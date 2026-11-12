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
import 'dart:typed_data';

import '../core/safe_log.dart';
import 'journal_files.dart';
import 'night.dart';

final _nightFile = RegExp(r'^night-([0-9a-f]{32})\.json$');
final _id = RegExp(r'^[0-9a-f]{32}$');

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

  /// Opens the folder, and removes what an interrupted save left.
  static Future<JournalStore> open(JournalFiles files) => _run(() async {
    await files.open();
    for (final name in await files.list()) {
      if (name.startsWith(tempPrefix)) {
        await files.delete(name);
        SafeLog.event(LogEvent.journalTempSwept);
      }
    }
    return JournalStore._(files);
  });

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

  /// Deletes the night's file, and the temporary file of a save of it.
  Future<void> delete(String id) => _run(() => _delete(id));

  Future<void> _delete(String id) async {
    final name = fileOf(id);
    await _files.delete(name);
    await _files.delete(tempPrefix + name);
  }

  /// Deletes every entry in the journal's folder, whatever its name.
  Future<void> deleteAll() => _run(() => _files.deleteAll());

  Future<bool> firstUseSeen() => _run(() async => (await _files.list()).contains(firstUseFlag));

  Future<void> markFirstUseSeen() => _run(() => _files.write(firstUseFlag, Uint8List(0)));
}
