import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';

void main() {
  testWidgets('the app shows a blank screen with no text', (tester) async {
    await tester.pumpWidget(const SoulDreamsApp());
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(RichText), findsNothing);
  });
}
