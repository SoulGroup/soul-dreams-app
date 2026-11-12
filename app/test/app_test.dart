import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/privacy_cover.dart';

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
}
