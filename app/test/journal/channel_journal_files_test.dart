// The Dart side of the journal's channel (D49 b): each call's name and
// arguments, as AppDelegate.swift reads them. `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/channel_journal_files.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(journalChannel);
  final calls = <MethodCall>[];
  late Object? Function(MethodCall) answer;
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    calls.clear();
    answer = (_) => null;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return answer(call);
    });
  });

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('each call has its name and arguments', () async {
    const files = ChannelJournalFiles();
    final bytes = Uint8List.fromList([1, 2, 3]);
    await files.open();
    await files.write('a.json', bytes);
    await files.rename('a.json', 'b.json');
    await files.read('b.json');
    await files.delete('b.json');
    await files.list();
    await files.deleteAll();
    expect([for (final c in calls) c.method],
        ['open', 'write', 'rename', 'read', 'delete', 'list', 'deleteAll']);
    expect(calls[0].arguments, isNull);
    expect(calls[1].arguments, {'name': 'a.json', 'bytes': bytes});
    expect(calls[2].arguments, {'from': 'a.json', 'to': 'b.json'});
    expect(calls[3].arguments, 'b.json');
    expect(calls[4].arguments, 'b.json');
    expect(calls[6].arguments, isNull);
  });

  // D92, D94: the audio's calls.
  test("the audio's calls have their names and arguments", () async {
    const files = ChannelJournalFiles();
    final bytes = Uint8List.fromList([1, 2]);
    await files.append('a.pcm', bytes);
    await files.append('a.pcm', bytes, sync: true);
    await files.size('a.pcm');
    await files.readRange('a.pcm', 64, 32);
    await files.copyTail('a.pcm', 'b.pcm', 64);
    expect([for (final c in calls) c.method], ['append', 'append', 'size', 'readRange', 'copyTail']);
    expect(calls[0].arguments, {'name': 'a.pcm', 'bytes': bytes, 'sync': false});
    expect(calls[1].arguments, {'name': 'a.pcm', 'bytes': bytes, 'sync': true});
    expect(calls[2].arguments, 'a.pcm');
    expect(calls[3].arguments, {'name': 'a.pcm', 'offset': 64, 'length': 32});
    expect(calls[4].arguments, {'from': 'a.pcm', 'to': 'b.pcm', 'offset': 64});
    answer = (call) => switch (call.method) {
          'size' => 7,
          'readRange' => Uint8List.fromList([9]),
          _ => null,
        };
    expect(await files.size('a.pcm'), 7);
    expect(await files.readRange('a.pcm', 0, 1), [9]);
    answer = (_) => null;
    expect(await files.size('a.pcm'), isNull);
    expect(await files.readRange('a.pcm', 0, 1), isEmpty);
    calls.clear();
    expect(() => files.append('../a', bytes), throwsArgumentError);
    expect(() => files.copyTail('a.pcm', '..', 0), throwsArgumentError);
    expect(calls, isEmpty);
  });

  test('answers come back as the store expects', () async {
    const files = ChannelJournalFiles();
    answer = (call) => switch (call.method) {
          'list' => ['a', 'b'],
          'read' => Uint8List.fromList([7]),
          'protection' => {'excluded': true, 'folderComplete': true, 'fileComplete': false},
          _ => null,
        };
    expect(await files.list(), ['a', 'b']);
    expect(await files.read('a'), [7]);
    expect(await files.protection('a'),
        (excluded: true, folderComplete: true, fileComplete: false));
  });

  test('a missing answer reads as nothing, never as protected', () async {
    const files = ChannelJournalFiles();
    expect(await files.list(), isEmpty);
    expect(await files.read('a'), isNull);
    expect(await files.protection('a'),
        (excluded: false, folderComplete: false, fileComplete: false));
  });

  test('a failure arrives as a code; a bad name never leaves', () async {
    const files = ChannelJournalFiles();
    answer = (_) => throw PlatformException(code: 'journal-io');
    await expectLater(files.open(),
        throwsA(isA<PlatformException>().having((e) => e.code, 'code', 'journal-io')));
    calls.clear();
    expect(() => files.read('../x'), throwsArgumentError);
    expect(calls, isEmpty);
  });

  test('the Swift side answers every method this side calls', () {
    final swift = File('ios/Runner/AppDelegate.swift').readAsStringSync();
    expect(swift, contains('"$journalChannel"'));
    for (final m in [
      'open',
      'list',
      'read',
      'write',
      'rename',
      'delete',
      'deleteAll',
      'protection',
      'append',
      'size',
      'readRange',
      'copyTail',
    ]) {
      expect(swift, contains('case "$m":'), reason: m);
    }
    for (final k in [
      'name',
      'bytes',
      'from',
      'to',
      'excluded',
      'folderComplete',
      'fileComplete',
      'sync',
      'offset',
      'length',
    ]) {
      expect(swift, contains('"$k"'), reason: k);
    }
    expect(swift, contains('.completeFileProtection'));
    expect(swift, contains('isExcludedFromBackup = true'));
    // D54: the bytes are flushed to the disk before the rename that
    // publishes them, and delete-all goes through every entry.
    expect(swift, contains('F_FULLFSYNC'));
    expect(swift, contains('try bytes.data.write(to: url, options: [.completeFileProtection])\n      try flush(url)'));
    expect(swift, contains('contentsOfDirectory(atPath: dir.path)'));
    // D92 item 5: the audio, created and copied under complete protection.
    expect(swift, contains('attributes: [.protectionKey: FileProtectionType.complete]'));
    expect(swift, contains('try rest.write(to: to, options: [.completeFileProtection])'));
    expect(swift, contains('try flush(to)'));
  });
}
