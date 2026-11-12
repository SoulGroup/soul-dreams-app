// The journal's folder, as the store sees it (D49 b): a flat folder of
// named files. On the phone it is Library/Application Support/Journal,
// excluded from backup, every file with complete file protection
// (ChannelJournalFiles and AppDelegate.swift). In tests, a folder on the
// Mac.
import 'dart:typed_data';

final _name = RegExp(r'^[A-Za-z0-9._-]+$');

/// A name the folder accepts: letters, digits, '.', '_' and '-', never
/// '.' and never starting with '..'. The Swift side holds the same rule.
bool validName(String name) => _name.hasMatch(name) && name != '.' && !name.startsWith('..');

abstract interface class JournalFiles {
  /// Creates the folder if needed and applies its protections.
  Future<void> open();

  /// Every file's name, sorted.
  Future<List<String>> list();

  /// The file's bytes, or null when there is no such file.
  Future<Uint8List?> read(String name);

  /// Creates or replaces the file.
  Future<void> write(String name, Uint8List bytes);

  /// Renames [from] to [to] in one step, replacing [to].
  Future<void> rename(String from, String to);

  /// Deletes the file; nothing happens when there is none.
  Future<void> delete(String name);
}

/// What the phone check reads back (D49 c): whether the folder is
/// excluded from backup, and whether the folder and the named file have
/// complete file protection.
typedef Protection = ({bool excluded, bool folderComplete, bool fileComplete});

abstract interface class JournalProtection {
  Future<Protection> protection(String name);
}
