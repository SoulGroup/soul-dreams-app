// The app's own words: Word Animation is on by default, and only the app's
// responses appear word by word, at about 60 ms a word (D110; D58 Q17); every
// other line stands whole (D106 2), and so does a response with the setting
// off or Reduce Motion on; always whole to a screen reader.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/words/lines.g.dart';

const style = TextStyle(fontSize: 18, color: Color(0xFF333333));

/// How many of the line's words are shown (not transparent).
int shown(WidgetTester tester) {
  final rich = tester.widget<RichText>(find.descendant(of: find.byType(AppLine), matching: find.byType(RichText)));
  var n = 0;
  (rich.text as TextSpan).visitChildren((span) {
    if (span is TextSpan && span.text != null && span.style?.color != const Color(0x00000000)) n++;
    return true;
  });
  return n;
}

void main() {
  final line = Lines.C4_P_5.text(Lang.en);
  final words = line.split(' ').length;

  Future<void> pump(WidgetTester tester, {bool response = false}) => tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr, child: Center(child: AppLine(line, style: style, response: response))));

  // The setting itself comes with Settings; until then only a test turns it
  // off.
  void still(WidgetTester tester) {
    wordAnimation = false;
    addTearDown(() => wordAnimation = true);
  }

  testWidgets('Word Animation is on by default (D110)', (tester) async {
    expect(wordAnimation, isTrue);
  });

  testWidgets('a line that is not a response stands whole', (tester) async {
    await pump(tester);
    expect(shown(tester), words);
  });

  testWidgets('with Word Animation off, a response stands whole', (tester) async {
    still(tester);
    await pump(tester, response: true);
    expect(shown(tester), words);
  });

  testWidgets('a response: one word, then one more every 60 ms', (tester) async {
    await pump(tester, response: true);
    expect(shown(tester), 1);
    await tester.pump(wordPace);
    expect(shown(tester), 2);
    await tester.pump(wordPace * (words - 2));
    expect(shown(tester), words);
    await tester.pump(wordPace * 3);
    expect(shown(tester), words);
  });

  testWidgets('with Reduce Motion, a response stands whole', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(reduceMotion: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pump(tester, response: true);
    expect(shown(tester), words);
  });

  testWidgets('a screen reader hears a response whole at once', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, response: true);
    expect(shown(tester), 1);
    expect(find.bySemanticsLabel(line), findsOneWidget);
    handle.dispose();
    await tester.pump(wordPace * words);
  });
}
