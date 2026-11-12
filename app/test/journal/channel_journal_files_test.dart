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
    expect([for (final c in calls) c.method],
        ['open', 'write', 'rename', 'read', 'delete', 'list']);
    expect(calls[0].arguments, isNull);
    expect(calls[1].arguments, {'name': 'a.json', 'bytes': bytes});
    expect(calls[2].arguments, {'from': 'a.json', 'to': 'b.json'});
    expect(calls[3].arguments, 'b.json');
    expect(calls[4].arguments, 'b.json');
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
    for (final m in ['open', 'list', 'read', 'write', 'rename', 'delete', 'protection']) {
      expect(swift, contains('case "$m":'), reason: m);
    }
    for (final k in ['name', 'bytes', 'from', 'to', 'excluded', 'folderComplete', 'fileComplete']) {
      expect(swift, contains('"$k"'), reason: k);
    }
    expect(swift, contains('.completeFileProtection'));
    expect(swift, contains('isExcludedFromBackup = true'));
  });
}
