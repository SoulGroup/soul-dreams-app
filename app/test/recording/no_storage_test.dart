// The audio is never kept on the phone (D69, as D71 corrects it, for this
// slice): nothing in lib/recording/ can write a file, and only the
// microphone's own file reaches the `record` package. A floor, read from
// the source; the owner's phone check looks in the app's container.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _storage = RegExp(
  r'\b(File|Directory|RandomAccessFile|IOSink|Link)\b|path_provider|getTemporaryDirectory|writeAs|openWrite|startFile|RecordConfig\(\s*\)',
);

void main() {
  final files = Directory('lib/recording').listSync().whereType<File>().where((f) => f.path.endsWith('.dart')).toList();

  test('the recording files are these', () {
    expect(files.map((f) => f.uri.pathSegments.last).toSet(), {
      'heard_text.dart',
      'key_client.dart',
      'microphone.dart',
      'record_microphone.dart',
      'recording.dart',
      'soniox.dart',
    });
  });

  test('nothing in lib/recording/ names a file or a folder', () {
    for (final f in files) {
      expect(_storage.hasMatch(f.readAsStringSync()), isFalse, reason: f.path);
    }
  });

  test('only the microphone file uses the record package, in stream mode', () {
    for (final f in Directory(
      'lib',
    ).listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      final text = f.readAsStringSync();
      final uses = text.contains('package:record/');
      expect(uses, f.path.endsWith('lib/recording/record_microphone.dart'), reason: f.path);
    }
    final mic = File('lib/recording/record_microphone.dart').readAsStringSync();
    expect(mic, contains('startStream('));
    expect(mic, isNot(contains('.start(')));
    expect(mic, contains('categoryOptions: []'));
  });
}
