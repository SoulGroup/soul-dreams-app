// The journal's folder on the Mac, for tests: the same rules as the
// phone's (journal_files.dart), with no backup flag or file protection.
import 'dart:io';
import 'dart:typed_data';

import 'package:souldreams/journal/journal_files.dart';

class IoJournalFiles implements JournalFiles {
  IoJournalFiles(this.dir);

  final Directory dir;

  File _file(String name) {
    if (!validName(name)) throw ArgumentError('name');
    return File('${dir.path}/$name');
  }

  @override
  Future<void> open() => dir.create(recursive: true);

  @override
  Future<List<String>> list() async => [
        for (final e in dir.listSync())
          if (e is File) e.uri.pathSegments.last,
      ]..sort();

  @override
  Future<Uint8List?> read(String name) async {
    final f = _file(name);
    return f.existsSync() ? f.readAsBytesSync() : null;
  }

  @override
  Future<void> write(String name, Uint8List bytes) async =>
      _file(name).writeAsBytesSync(bytes, flush: true);

  @override
  Future<void> rename(String from, String to) async => _file(from).renameSync(_file(to).path);

  @override
  Future<void> delete(String name) async {
    final f = _file(name);
    if (f.existsSync()) f.deleteSync();
  }

  /// Every file's bytes, by name: what a look at the whole folder finds.
  Map<String, Uint8List> everything() => {
        for (final e in dir.listSync(recursive: true))
          if (e is File) e.path.substring(dir.path.length + 1): e.readAsBytesSync(),
      };
}
