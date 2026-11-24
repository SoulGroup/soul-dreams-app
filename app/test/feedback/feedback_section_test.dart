// The Feedback section of Settings (D110; C18-P; D152): MP·49 over a card
// holding C4-P·8, the field (MP·46 as its hint, at most 2,000 characters)
// and Submit (MP·47, color.button.filled). Empty does nothing; before "I
// agree", the popup; a send that fails keeps the text and shows [MP·105]; one
// that works empties the box and shows [MP·106]; typing again takes the line
// away. The two lines are owed: their handles show until the owner files
// them (R1).
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/language.dart';
import 'package:souldreams/design/palette.dart';
import 'package:souldreams/feedback/feedback.dart';
import 'package:souldreams/feedback/feedback_section.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

String en(Line line) => line.text(Lang.en);

void main() {
  late List<String> sent;
  late Completer<void>? hold;
  late Object? fails;
  late bool agreed;

  setUp(() {
    sent = [];
    hold = null;
    fails = null;
    agreed = true;
  });

  Future<void> show(WidgetTester tester, {Brightness brightness = Brightness.light}) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    wordAnimation = false;
    addTearDown(() => wordAnimation = true);
    await tester.pumpWidget(
      MaterialApp(
        theme: themeFor(brightness),
        home: Scaffold(
          body: SingleChildScrollView(
            child: FeedbackSection(
              send: (text) async {
                sent.add(text);
                await hold?.future;
                if (fails case final f?) throw f;
              },
              agreed: () => agreed,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byKey(FeedbackSection.fieldKey), text);
    await tester.pump();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(FeedbackSection.submitKey));
    await tester.tap(find.byKey(FeedbackSection.submitKey));
    await tester.pumpAndSettle();
  }

  String boxText(WidgetTester tester) =>
      tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey)).controller!.text;

  testWidgets('its title, its words, the field and Submit, in that order', (tester) async {
    await show(tester);
    final title = find.text(en(Lines.MP_49));
    expect(title, findsOneWidget);
    expect(tester.getSemantics(title).flagsCollection.isHeader, isTrue);
    expect(find.text(en(Lines.C4_P_8)), findsOneWidget);
    expect(find.text(en(Lines.MP_46)), findsOneWidget);
    expect(find.text(en(Lines.MP_47)), findsOneWidget);
    final ys = [
      title,
      find.text(en(Lines.C4_P_8)),
      find.byKey(FeedbackSection.fieldKey),
      find.byKey(FeedbackSection.submitKey),
    ].map((f) => tester.getCenter(f).dy).toList();
    expect(ys, orderedEquals([...ys]..sort()));
    expect(find.byKey(FeedbackSection.lineKey), findsNothing);
  });

  testWidgets('Submit is color.button.filled in each theme', (tester) async {
    for (final (brightness, p) in [(Brightness.light, Palette.light), (Brightness.dark, Palette.dark)]) {
      await show(tester, brightness: brightness);
      final box = tester.widget<DecoratedBox>(
        find.descendant(of: find.byKey(FeedbackSection.submitKey), matching: find.byType(DecoratedBox)).first,
      );
      final gradient = (box.decoration as BoxDecoration).gradient! as LinearGradient;
      expect(gradient.colors, [p.filledTop, p.filledBottom], reason: '$brightness');
      final words = tester.widget<Text>(find.text(en(Lines.MP_47)));
      expect(words.style!.color, p.filledText, reason: '$brightness');
    }
  });

  testWidgets('the field takes at most 2,000 characters, as counted', (tester) async {
    await show(tester);
    final field = tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey));
    final limit = field.inputFormatters!.whereType<LengthLimitingTextInputFormatter>().single;
    expect(limit.maxLength, feedbackLimit);
    await type(tester, '👨‍👩‍👧' * 2001);
    expect(boxText(tester).characters.length, 2000);
    expect(field.maxLength, isNull, reason: 'no counter is shown');
  });

  testWidgets('empty or blank: Submit does nothing', (tester) async {
    await show(tester);
    await submit(tester);
    await type(tester, '   \n ');
    await submit(tester);
    expect(sent, isEmpty);
    expect(find.byType(CupertinoAlertDialog), findsNothing);
    expect(find.byKey(FeedbackSection.lineKey), findsNothing);
  });

  testWidgets('before I agree: the popup, nothing sent, the text kept', (tester) async {
    agreed = false;
    await show(tester);
    await type(tester, 'The app opens slowly.');
    await submit(tester);
    expect(find.text(PendingLines.MP_101.text(appLanguage)), findsOneWidget);
    expect(sent, isEmpty);
    await tester.tap(find.text(PendingLines.MP_102.text(appLanguage)));
    await tester.pumpAndSettle();
    expect(boxText(tester), 'The app opens slowly.');
  });

  testWidgets('sent: the box empties, [MP·106] shows, typing clears it', (tester) async {
    await show(tester);
    await type(tester, 'The app opens slowly.');
    await submit(tester);
    expect(sent, ['The app opens slowly.']);
    expect(boxText(tester), '');
    expect(find.text('[MP·106]'), findsOneWidget);
    expect(tester.getSemantics(find.byKey(FeedbackSection.lineKey)).flagsCollection.isLiveRegion, isTrue);
    await type(tester, 'A');
    expect(find.byKey(FeedbackSection.lineKey), findsNothing);
  });

  testWidgets("not sent: the text stays, [MP·105] shows; Submit again sends it", (tester) async {
    fails = const FeedbackFailure(502);
    await show(tester);
    await type(tester, 'The app opens slowly.');
    await submit(tester);
    expect(boxText(tester), 'The app opens slowly.');
    expect(find.text('[MP·105]'), findsOneWidget);
    fails = null;
    await submit(tester);
    expect(sent, ['The app opens slowly.', 'The app opens slowly.']);
    expect(find.text('[MP·105]'), findsNothing);
    expect(find.text('[MP·106]'), findsOneWidget);
  });

  testWidgets('while sending: the box cannot change, a second Submit does nothing', (tester) async {
    hold = Completer<void>();
    await show(tester);
    await type(tester, 'The app opens slowly.');
    await tester.ensureVisible(find.byKey(FeedbackSection.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(FeedbackSection.submitKey));
    await tester.pump();
    expect(tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey)).readOnly, isTrue);
    await tester.tap(find.byKey(FeedbackSection.submitKey));
    await tester.pump();
    expect(sent, ['The app opens slowly.']);
    hold!.complete();
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(find.byKey(FeedbackSection.fieldKey)).readOnly, isFalse);
  });

  testWidgets('at the largest text, nothing overflows', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 3.1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    fails = const FeedbackFailure(0);
    await show(tester);
    await type(tester, 'The app opens slowly.');
    await submit(tester);
    expect(tester.takeException(), isNull);
  });
}
