import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/always_light.dart';
import 'package:souldreams/core/privacy_cover.dart';
import 'package:souldreams/design/tokens.g.dart';

void main() {
  testWidgets('the app shows a blank screen with no text', (tester) async {
    await tester.pumpWidget(const SoulDreamsApp());
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(RichText), findsNothing);
  });

  testWidgets('every page of the app is under the cover (D50 2)', (tester) async {
    await tester.pumpWidget(const SoulDreamsApp());
    expect(find.ancestor(of: find.byType(Scaffold), matching: find.byType(PrivacyCover)),
        findsOneWidget);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(find.byKey(PrivacyCover.coverKey), findsOneWidget);
  });

  // Onboarding is always in the light theme (main-path.md, Every Screen;
  // design-system.md §6), and so is the cover over it (P11): a page may hold
  // the whole app light, at once, whatever the time, and let it go.
  testWidgets('a page may hold the app light, cover included', (tester) async {
    late BuildContext page;
    await tester.pumpWidget(SoulDreamsApp(
      clock: () => DateTime(2026, 6, 10, 23),
      home: Builder(builder: (context) {
        page = context;
        return const Scaffold();
      }),
    ));
    expect(Theme.of(page).brightness, Brightness.dark);
    AlwaysLight.hold(page, true);
    await tester.pump();
    await tester.pump();
    expect(Theme.of(page).brightness, Brightness.light);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    expect(tester.widget<ColoredBox>(find.byKey(PrivacyCover.coverKey)).color, LightColours.page.colour);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    AlwaysLight.hold(page, false);
    await tester.pump();
    await tester.pump();
    expect(Theme.of(page).brightness, Brightness.dark);
  });
}
