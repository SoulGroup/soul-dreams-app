// Whether the phone has a connection (D92 item 3; D93 Q4): our own event
// channel, a true or false at each change, taken as online until it says.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/recording/connection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = EventChannel(networkChannel);
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late MockStreamHandlerEventSink sink;

  setUp(() {
    messenger.setMockStreamHandler(
      channel,
      MockStreamHandler.inline(onListen: (arguments, events) => sink = events),
    );
  });

  tearDown(() => messenger.setMockStreamHandler(channel, null));

  test('online until the phone says; each change once', () async {
    final connection = ChannelConnection();
    final seen = <bool>[];
    connection.changes.listen(seen.add);
    await pumpEventQueue();
    expect(connection.online, isTrue);
    sink.success(false);
    await pumpEventQueue();
    expect(connection.online, isFalse);
    sink.success(false);
    sink.success('x');
    sink.error(code: 'network');
    await pumpEventQueue();
    expect(connection.online, isFalse);
    sink.success(true);
    await pumpEventQueue();
    expect(connection.online, isTrue);
    expect(seen, [false, true]);
  });

  test('the Swift side watches the path, sending true or false', () {
    final swift = File('ios/Runner/AppDelegate.swift').readAsStringSync();
    expect(swift, contains('"$networkChannel"'));
    expect(swift, contains('import Network'));
    expect(swift, contains('NWPathMonitor()'));
    expect(swift, contains('let online = path.status == .satisfied'));
    expect(swift, contains('events(online)'));
    expect(swift, contains('channel.setStreamHandler(networkWatch)'));
  });
}
