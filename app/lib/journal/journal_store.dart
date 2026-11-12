// The journal on the phone (D49 b; R11): one JSON file per night. A save
// writes the whole night to a temporary file and renames it into place,
// so the folder always holds one whole version of each night and no
// earlier one. Deleting a night deletes its file; deleting the journal
// deletes every file in the folder. A file that does not read as a night
// is skipped with a code and left exactly as it is (D49 c), until the
// journal is deleted.
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

  /// The name of a night's file.
  static String fileOf(String id) {
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    return 'night-$id.json';
  }

  /// Opens the folder, and removes what an interrupted save left.
  static Future<JournalStore> open(JournalFiles files) async {
    await files.open();
    for (final name in await files.list()) {
      if (name.startsWith(tempPrefix)) {
        await files.delete(name);
        SafeLog.event(LogEvent.journalTempSwept);
      }
    }
    return JournalStore._(files);
  }

  /// Every night that reads, earliest first recording first.
  Future<List<Night>> nights() async {
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
  }

  /// Saves the night whole, replacing any earlier version.
  Future<void> save(Night night) async {
    final name = fileOf(night.id);
    await _files.write(tempPrefix + name, encodeNight(night));
    await _files.rename(tempPrefix + name, name);
  }

  /// Deletes the night's file.
  Future<void> delete(String id) => _files.delete(fileOf(id));

  /// Deletes every file in the journal's folder.
  Future<void> deleteAll() async {
    for (final name in await _files.list()) {
      await _files.delete(name);
    }
  }

  Future<bool> firstUseSeen() async => (await _files.list()).contains(firstUseFlag);

  Future<void> markFirstUseSeen() => _files.write(firstUseFlag, Uint8List(0));
}
