// The phone check (D49 c), on the Mac: it passes with every protection
// in place, fails at the step that broke, and never leaves its probe.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_files.dart';
import 'package:souldreams/journal/self_check.dart';

import 'io_journal_files.dart';

final class Says implements JournalProtection {
  const Says(this.answer);

  final Protection answer;

  @override
  Future<Protection> protection(String name) async => answer;
}

const all = Says((excluded: true, folderComplete: true, fileComplete: true));

final class NoRename extends IoJournalFiles {
  NoRename(super.dir);

  @override
  Future<void> rename(String from, String to) async => throw const FileSystemException('rename');
}

void main() {
  late Directory dir;
  final lines = <String>[];
  final sink = SafeLog.sink;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('check-');
    lines.clear();
    SafeLog.sink = lines.add;
  });

  tearDown(() {
    SafeLog.sink = sink;
    dir.deleteSync(recursive: true);
  });

  test('every protection in place: it passes and leaves nothing', () async {
    final files = IoJournalFiles(dir);
    expect(await journalSelfCheck(files, all), isTrue);
    expect(lines, ['journalCheckPassed']);
    expect(files.everything(), isEmpty);
  });

  test('each missing protection fails at step 3, probe removed', () async {
    for (final p in [
      (excluded: false, folderComplete: true, fileComplete: true),
      (excluded: true, folderComplete: false, fileComplete: true),
      (excluded: true, folderComplete: true, fileComplete: false),
    ]) {
      lines.clear();
      final files = IoJournalFiles(dir);
      expect(await journalSelfCheck(files, Says(p)), isFalse);
      expect(lines, ['journalCheckFailed 3']);
      expect(files.everything(), isEmpty);
    }
  });

  test('a save that cannot finish fails at step 2', () async {
    expect(await journalSelfCheck(NoRename(dir), all), isFalse);
    expect(lines, ['journalCheckFailed 2']);
  });

  test('the probe is one marker word, and other nights stay', () async {
    final files = IoJournalFiles(dir);
    await files.write('night-${'e' * 32}.json', Uint8List(3));
    expect(await journalSelfCheck(files, all), isTrue);
    expect(files.everything().keys, ['night-${'e' * 32}.json']);
    expect(journalProbe, matches(RegExp(r'^[a-z0-9-]+$')));
  });
}
