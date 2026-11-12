// The typing screen (P2 to P4, P10, P12; D58 Q4): the field only, MP·12
// as its placeholder, MP·10 once then MP·32; Save and Back keep the text
// as a new dream; an empty Save keeps nothing; an edit replaces.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/words/lines.g.dart';

import '../../fixtures.dart';
import 'harness.dart';

void main() {
  final dreams = invented('two-dreams-en').dreams;

  Future<Harness> open(WidgetTester tester, {DreamEdit? edit}) async {
    final h = await Harness.make();
    await h.pump(
        tester,
        Opener(() async =>
            TypingPage(journal: h.journal, target: await h.journal.targetNow(), edit: edit)));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    return h;
  }

  testWidgets('the field only, with MP·12 as its placeholder', (tester) async {
    final h = await open(tester);
    await h.journal.addDream(await h.journal.targetNow(), dreams[0], Lang.en);
    expect(find.byKey(TypingPage.fieldKey), findsOneWidget);
    expect(find.text(Lines.MP_12.text(Lang.en)), findsOneWidget);
    // Never tonight's earlier dreams (P2).
    expect(find.textContaining(dreams[0]), findsNothing);
    expect(find.text(Lines.MP_13.text(Lang.en)), findsOneWidget);
  });

  testWidgets('MP·10 on first use, MP·32 after', (tester) async {
    final h = await open(tester);
    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsOneWidget);
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(Lines.MP_32.text(Lang.en)), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsNothing);
    expect(await h.journal.firstUseSeen(), isTrue);
  });

  testWidgets('Save keeps the text as a new dream and goes back', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect([for (final n in await h.nights()) n.dreams], [
      [dreams[0]]
    ]);
  });

  testWidgets('Back saves like Save; a second Save adds a dream', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[1]);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect([for (final n in await h.nights()) n.dreams], [dreams]);
  });

  testWidgets("the system's back gesture saves too", (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [dreams[0]]);
  });

  testWidgets('an empty Save keeps nothing', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), ' \n ');
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect(await h.nights(), isEmpty);
    expect(h.files.files.keys.where((n) => n.startsWith('night-')), isEmpty);
  });

  testWidgets('an edit opens filled, and Save replaces the dream', (tester) async {
    final h = await Harness.make();
    await h.journal.addDream(await h.journal.targetNow(), dreams[0], Lang.en);
    final id = (await h.nights()).single.id;
    await h.pump(
        tester,
        Opener(() async => TypingPage(
            journal: h.journal, target: await h.journal.targetNow(), edit: (id: id, index: 0, text: dreams[0]))));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    expect(find.text(dreams[0]), findsOneWidget);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[1]);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.nights()).single.dreams, [dreams[1]]);
  });

  testWidgets("the keyboard follows the phone's own settings (P12)", (tester) async {
    await open(tester);
    // As the field resolves them: nothing turned off by the app.
    final field = tester.widget<EditableText>(find.byType(EditableText));
    expect(field.autocorrect, isTrue);
    expect(field.enableSuggestions, isTrue);
    expect(field.textCapitalization, TextCapitalization.sentences);
    expect(field.keyboardType, TextInputType.multiline);
  });
}
