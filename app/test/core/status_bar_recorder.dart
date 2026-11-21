// A test helper: the status bar styles the app sends to the phone, as the
// brightness each names (iOS: `dark` is light text, `light` is dark text).
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Starts recording; the list grows with each style sent. Stops with the test.
List<String> recordStatusBar(WidgetTester tester) {
  final calls = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'SystemChrome.setSystemUIOverlayStyle') {
      calls.add(((call.arguments as Map)['statusBarBrightness'] ?? 'none') as String);
    }
    return null;
  });
  addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));
  return calls;
}

/// Sends a style the app never does, so the next one it sends is a change and
/// is not dropped as a repeat (Flutter keeps the last style it sent, across
/// tests); then forgets what was recorded.
Future<void> forceChange(WidgetTester tester, List<String> calls) async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Color(0x01000000)));
  await tester.pump();
  calls.clear();
}
