// The phone's connection is watched from main(), before runApp: the watcher
// must not need Flutter's bindings to exist already, or its listen fails
// silently and the phone is taken as online for ever (check 4 of D97's
// phone checks). Its own file: no binding is made here.
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/recording/connection.dart';

void main() {
  test('the watcher made before runApp raises no error, has bindings', () async {
    final errors = <Object>[];
    await runZonedGuarded(() async {
      ChannelConnection();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }, (e, s) => errors.add(e));
    expect(errors, isEmpty);
    expect(WidgetsBinding.instance, isNotNull);
  });
}
