// The cover (D50 2; P11): when the app leaves the foreground, the plain
// page colour covers the screen before iOS takes its snapshot. No logo,
// no words. Covered from inactive on, removed on resumed.
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/privacy_cover.dart';
import 'package:souldreams/design/tokens.g.dart';

Widget _app({Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    builder: (context, child) => PrivacyCover(child: child!),
    home: const Scaffold(body: Center(child: Text('invented'))),
  );
}

// Whether the semantics tree, as VoiceOver gets it, holds the label.
bool _spoken(WidgetTester tester, String label) {
  var found = false;
  bool visit(SemanticsNode node) {
    if (node.label.contains(label)) found = true;
    node.visitChildren(visit);
    return true;
  }

  visit(tester.binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!);
  return found;
}

Future<void> _to(WidgetTester tester, AppLifecycleState state) async {
  tester.binding.handleAppLifecycleStateChanged(state);
  await tester.pump();
}

void main() {
  testWidgets('inactive covers the screen with the page colour, no text', (tester) async {
    await tester.pumpWidget(_app());
    expect(find.byKey(PrivacyCover.coverKey), findsNothing);
    await _to(tester, AppLifecycleState.inactive);
    final cover = find.byKey(PrivacyCover.coverKey);
    expect(cover, findsOneWidget);
    expect(tester.widget<ColoredBox>(cover).color, LightColours.page.colour);
    expect(tester.getSize(cover), tester.view.physicalSize / tester.view.devicePixelRatio);
    expect(find.descendant(of: cover, matching: find.byType(RichText)), findsNothing);
    expect(find.descendant(of: cover, matching: find.byType(Image)), findsNothing);
    expect(find.descendant(of: cover, matching: find.byType(Icon)), findsNothing);
    expect(find.descendant(of: cover, matching: find.byType(Widget)), findsNothing);
  });

  testWidgets('the cover is on top and hides what is under it', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_app());
    expect(_spoken(tester, 'invented'), isTrue);
    await _to(tester, AppLifecycleState.inactive);
    final stack = tester.widget<Stack>(find.byKey(PrivacyCover.stackKey));
    expect((stack.children.last as Positioned).child.key, PrivacyCover.coverKey);
    expect(find.text('invented'), findsOneWidget, reason: 'kept, not rebuilt');
    expect(_spoken(tester, 'invented'), isFalse);
    semantics.dispose();
  });

  testWidgets('hidden and paused keep it; resumed removes it', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_app());
    await _to(tester, AppLifecycleState.inactive);
    await _to(tester, AppLifecycleState.hidden);
    expect(find.byKey(PrivacyCover.coverKey), findsOneWidget);
    await _to(tester, AppLifecycleState.paused);
    expect(find.byKey(PrivacyCover.coverKey), findsOneWidget);
    await _to(tester, AppLifecycleState.hidden);
    await _to(tester, AppLifecycleState.inactive);
    expect(find.byKey(PrivacyCover.coverKey), findsOneWidget);
    await _to(tester, AppLifecycleState.resumed);
    expect(find.byKey(PrivacyCover.coverKey), findsNothing);
    expect(_spoken(tester, 'invented'), isTrue);
    semantics.dispose();
  });

  testWidgets('the dark theme gets the dark page colour', (tester) async {
    await tester.pumpWidget(_app(brightness: Brightness.dark));
    await _to(tester, AppLifecycleState.inactive);
    final cover = find.byKey(PrivacyCover.coverKey);
    expect(tester.widget<ColoredBox>(cover).color, DarkColours.page.colour);
  });
}
