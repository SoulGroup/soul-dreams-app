// The status bar follows the app's own theme everywhere (D114): light text
// over the dark theme, dark text over the light theme, whatever the phone's
// own setting is; a night's header keeps light text over its picture (D113).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/always_light.dart';
import 'package:souldreams/core/status_bar.dart';

import 'status_bar_recorder.dart';

void main() {
  test('light text over the dark theme, dark text over the light', () {
    expect(statusBarFor(Brightness.dark).statusBarBrightness, Brightness.dark);
    expect(statusBarFor(Brightness.dark).statusBarIconBrightness, Brightness.light);
    expect(statusBarFor(Brightness.light).statusBarBrightness, Brightness.light);
    expect(statusBarFor(Brightness.light).statusBarIconBrightness, Brightness.dark);
  });

  // iOS names the bar's own brightness: `dark` is light text.
  testWidgets('every page: by the app theme, not the phone setting', (tester) async {
    final calls = recordStatusBar(tester);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    // Night 22:00 is the dark theme, noon the light; the phone says the
    // opposite each time, and then the same.
    for (final (hour, phone) in [
      (12, Brightness.dark),
      (22, Brightness.light),
      (12, Brightness.light),
      (22, Brightness.dark),
    ]) {
      await tester.pumpWidget(const SizedBox());
      tester.platformDispatcher.platformBrightnessTestValue = phone;
      await forceChange(tester, calls);
      await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, hour)));
      await tester.pumpAndSettle();
      expect(calls.last, hour == 12 ? 'Brightness.light' : 'Brightness.dark', reason: 'hour $hour, phone $phone');
    }
  });

  testWidgets('held light (onboarding), at night: dark text on the light page', (tester) async {
    final calls = recordStatusBar(tester);
    await forceChange(tester, calls);
    late BuildContext page;
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 23),
      home: Builder(builder: (context) {
        page = context;
        return const Scaffold();
      }),
    ));
    await tester.pumpAndSettle();
    expect(calls.last, 'Brightness.dark');
    AlwaysLight.hold(page, true);
    await tester.pump();
    await tester.pump();
    expect(calls.last, 'Brightness.light');
  });
}
