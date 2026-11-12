// The journal's folder in memory, for the pages' widget tests: the same
// rules as the phone's (journal_files.dart), no disk.
import 'dart:typed_data';

import 'package:souldreams/journal/journal_files.dart';

class MemoryJournalFiles implements JournalFiles {
  final files = <String, Uint8List>{};

  void _check(String name) {
    if (!validName(name)) throw ArgumentError('name');
  }

  @override
  Future<void> open() async {}

  @override
  Future<List<String>> list() async => files.keys.toList()..sort();

  @override
  Future<Uint8List?> read(String name) async {
    _check(name);
    return files[name];
  }

  @override
  Future<void> write(String name, Uint8List bytes) async {
    _check(name);
    files[name] = Uint8List.fromList(bytes);
  }

  @override
  Future<void> rename(String from, String to) async {
    _check(from);
    _check(to);
    files[to] = files.remove(from)!;
  }

  @override
  Future<void> delete(String name) async {
    _check(name);
    files.remove(name);
  }

  @override
  Future<void> deleteAll() async => files.clear();
}
