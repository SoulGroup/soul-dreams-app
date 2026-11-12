// Third-party keyboards refused, app-wide (D50 1). No test runs the
// Swift, so this one reads it, comments removed; the phone check proves
// it (the plan's Task 13). `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/app.dart';
import 'package:souldreams/core/keyboard_check.dart';

void main() {
  test('AppDelegate refuses the keyboard extension point, and only it', () {
    final swift = File('ios/Runner/AppDelegate.swift')
        .readAsLinesSync()
        .map((line) => line.split('//').first)
        .join('\n')
        .replaceAll(RegExp(r'\s+'), ' ');
    const method = 'override func application( _ application: UIApplication, '
        'shouldAllowExtensionPointIdentifier extensionPointIdentifier: '
        'UIApplication.ExtensionPointIdentifier ) -> Bool { '
        'return extensionPointIdentifier != .keyboard }';
    expect(swift, contains(method));
    expect('shouldAllowExtensionPointIdentifier'.allMatches(swift), hasLength(1));
  });

  testWidgets('the Dev keyboard check is one empty field, no words', (tester) async {
    await tester.pumpWidget(const SoulDreamsApp(home: KeyboardCheck()));
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).autofocus, isTrue);
    expect(find.byType(RichText), findsNothing);
    expect(find.byType(EditableText), findsOneWidget);
    expect(tester.widget<EditableText>(find.byType(EditableText)).controller.text, isEmpty);
  });
}
