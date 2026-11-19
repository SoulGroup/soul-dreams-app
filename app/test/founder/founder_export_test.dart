// The founder's export, its Dart side (D107; D108): MP·65 its label, the
// file's name and bytes its only message, a failure a code and nothing
// else. The phone's side is in native_test.dart and the owner's check.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/founder/export_text.dart';
import 'package:souldreams/founder/founder_export.dart';
import 'package:souldreams/words/lines.g.dart' show Lang;
import 'package:souldreams/words/pending.g.dart';

import '../fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const channel = MethodChannel(FounderExport.channelName);
  final night = nightsFromFixtures().first;
  late List<String> lines;

  setUp(() {
    lines = [];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
  });

  test('its label is MP·65, a pending line', () {
    expect(const FounderExport().action.label, PendingLines.MP_65.text(Lang.en));
  });

  test('the action shares the night it is given', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async => calls.add(call));
    await const FounderExport().action.run(night);
    expect([for (final c in calls) (c.arguments as Map<Object?, Object?>)['bytes']], [exportBytes(night)]);
  });

  test("one message: the file's name and bytes, nothing else", () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    await const FounderExport().share(night);
    expect(calls.single.method, 'share');
    final args = calls.single.arguments as Map<Object?, Object?>;
    expect(args.keys.toSet(), {'name', 'bytes'});
    expect(args['name'], exportFileName(night));
    expect(args['bytes'], isA<Uint8List>());
    expect(args['bytes'], exportBytes(night));
    expect(lines, isEmpty);
  });

  test('a refused share logs a code and nothing else', () async {
    messenger.setMockMethodCallHandler(channel, (call) async => throw PlatformException(code: 'export'));
    await const FounderExport().share(night);
    expect(lines, ['exportFailed']);
  });

  test('no channel at all logs the same code', () async {
    await const FounderExport().share(night);
    expect(lines, ['exportFailed']);
  });
}
