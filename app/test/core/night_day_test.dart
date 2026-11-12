// Night/Day mode, Automatic (design-system.md §6; P14; D56; D57 Q15):
// dark at 21:00, light at 08:00; a five-second fade while the app is
// open; instant with Reduce Motion, at start and on returning.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/night_day.dart';
import 'package:souldreams/core/privacy_cover.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/design/tokens.g.dart';

Color pageOf(WidgetTester tester) =>
    Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor;

void main() {
  final light = LightColours.page.colour!;
  final dark = DarkColours.page.colour!;

  test('dark from 21:00 to 08:00, by the wall clock', () {
    expect(isNightAt(DateTime(2026, 6, 10, 7, 59)), isTrue);
    expect(isNightAt(DateTime(2026, 6, 10, 8)), isFalse);
    expect(isNightAt(DateTime(2026, 6, 10, 20, 59)), isFalse);
    expect(isNightAt(DateTime(2026, 6, 10, 21)), isTrue);
    expect(isNightAt(DateTime(2026, 6, 10, 0)), isTrue);
  });

  testWidgets('at start the theme is the hour\'s, with no fade', (tester) async {
    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 22)));
    expect(pageOf(tester), dark);
    expect(Palette.of(tester.element(find.byType(Scaffold))).page, dark);
  });

  testWidgets('at 21:00 the open app fades to dark over five seconds', (tester) async {
    var now = DateTime(2026, 6, 10, 20, 59, 30);
    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
    expect(pageOf(tester), light);
    now = DateTime(2026, 6, 10, 21, 0, 30);
    await tester.pump(NightDay.tick);
    await tester.pump(const Duration(milliseconds: 2500));
    final mid = pageOf(tester);
    expect(mid, isNot(light));
    expect(mid, isNot(dark));
    expect(mid, Color.lerp(light, dark, 0.5));
    await tester.pump(const Duration(milliseconds: 2600));
    expect(pageOf(tester), dark);
    // And back to light at 08:00.
    now = DateTime(2026, 6, 11, 8, 0, 30);
    await tester.pump(NightDay.tick);
    await tester.pump(NightDay.fade);
    expect(pageOf(tester), light);
  });

  testWidgets('with Reduce Motion the change is instant', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(reduceMotion: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    var now = DateTime(2026, 6, 10, 20, 59, 30);
    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
    now = DateTime(2026, 6, 10, 21, 0, 30);
    await tester.pump(NightDay.tick);
    await tester.pump();
    expect(pageOf(tester), dark);
  });

  testWidgets('a change found on returning to the app is instant', (tester) async {
    var now = DateTime(2026, 6, 10, 20, 50);
    await tester.pumpWidget(SoulDreamsApp(clock: () => now));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    now = DateTime(2026, 6, 10, 23);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(pageOf(tester), dark);
  });

  testWidgets('the cover follows the dark theme', (tester) async {
    await tester.pumpWidget(SoulDreamsApp(clock: () => DateTime(2026, 6, 10, 23)));
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(tester.widget<ColoredBox>(find.byKey(PrivacyCover.coverKey)).color, dark);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
  });
}
