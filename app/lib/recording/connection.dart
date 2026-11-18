// Whether the phone has a connection, as the phone itself knows it
// (D92 item 3; D93 Q4): through Apple's network path monitor, by our own
// Swift event channel in ios/Runner/AppDelegate.swift, which sends one
// true or false at each change and nothing else, and sends nothing
// anywhere (R10). Built into all three apps, reached from SoulDreams Dev
// only.
import 'dart:async';

import 'package:flutter/services.dart';

const networkChannel = 'souldreams/network';

abstract interface class Connection {
  /// Whether the phone has a way out now. True until the phone says.
  bool get online;

  /// Each change, as it comes.
  Stream<bool> get changes;
}

final class ChannelConnection implements Connection {
  ChannelConnection([EventChannel channel = const EventChannel(networkChannel)]) {
    channel.receiveBroadcastStream().listen(
      (event) {
        if (event is! bool || event == _online) return;
        _online = event;
        _changes.add(event);
      },
      // A channel that fails says nothing: the phone is taken as online,
      // and a failure there shows as a key or a stream that fails.
      onError: (Object _) {},
    );
  }

  bool _online = true;
  final _changes = StreamController<bool>.broadcast();

  @override
  bool get online => _online;

  @override
  Stream<bool> get changes => _changes.stream;
}
