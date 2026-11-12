// The typing screen (P2 to P4, P10, P12; D58 Q4): the field only, MP·12
// as its placeholder, MP·10 once then MP·32; Save and Back keep the text
// as a new dream; an empty Save keeps nothing; an edit replaces.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

import '../../fixtures.dart';
import '../memory_journal_files.dart';
import '../zones.dart';
import 'harness.dart';

/// A folder whose next [failures] writes throw, as a full disk would, and
/// whose writes wait while [hold] is open.
final class FlakyFiles extends MemoryJournalFiles {
  int failures = 0;
  Completer<void>? hold;

  @override
  Future<void> write(String name, Uint8List bytes) async {
    await hold?.future;
    if (failures > 0) {
      failures--;
      throw const FileSystemException('write');
    }
    return super.write(name, bytes);
  }
}

void main() {
  final dreams = invented('two-dreams-en').dreams;

  Future<Harness> open(WidgetTester tester, {DreamEdit? edit, MemoryJournalFiles? files}) async {
    final h = await Harness.make(files: files);
    await h.pump(
      tester,
      Opener(() async => TypingPage(journal: h.journal, target: await h.journal.targetNow(), edit: edit)),
    );
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
    expect(
      [for (final n in await h.nights()) n.dreams],
      [
        [dreams[0]],
      ],
    );
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

  testWidgets("the system's back button saves too", (tester) async {
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
      Opener(
        () async => TypingPage(
          journal: h.journal,
          target: await h.journal.targetNow(),
          edit: (id: id, index: 0, text: dreams[0]),
        ),
      ),
    );
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

  // D62 (the review of Task 9): a failed save, the iPhone's edge swipe,
  // the double tap, the keyboard, the edit's place, and the clock.
  Future<List<String>> logged() async {
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    return lines;
  }

  testWidgets('a failed Save stays on the screen; Save again keeps it', (tester) async {
    final lines = await logged();
    final files = FlakyFiles();
    final h = await open(tester, files: files);
    files.failures = 1;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    expect(find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en)), findsNothing);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    expect(find.text(dreams[0]), findsOneWidget);
    expect(await h.nights(), isEmpty);
    expect(lines, ['journalSaveFailed']);
    expect(find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en)), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect(
      [for (final n in await h.nights()) n.dreams],
      [
        [dreams[0]],
      ],
    );
  });

  testWidgets('a failed Back stays on the screen; Back again keeps it', (tester) async {
    final files = FlakyFiles();
    final h = await open(tester, files: files);
    files.failures = 1;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    expect(find.text(dreams[0]), findsOneWidget);
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [dreams[0]]);
  });

  testWidgets('the iPhone edge swipe saves, then leaves, like Back', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.flingFrom(const Offset(4, 300), const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [dreams[0]]);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('a short edge drag or a middle swipe saves nothing', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.dragFrom(const Offset(4, 300), const Offset(20, 0));
    await tester.flingFrom(const Offset(300, 300), const Offset(300, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    expect(await h.nights(), isEmpty);
  }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

  testWidgets('two quick taps on Save keep the dream once', (tester) async {
    final files = FlakyFiles();
    final h = await open(tester, files: files);
    // The first save is still running when the second tap lands.
    files.hold = Completer<void>();
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    files.hold!.complete();
    await tester.pumpAndSettle();
    expect(
      [for (final n in await h.nights()) n.dreams],
      [
        [dreams[0]],
      ],
    );
  });

  testWidgets('nothing else about the keyboard is overridden (P12)', (tester) async {
    await open(tester);
    final page = tester.widget<EditableText>(find.byType(EditableText));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
          ),
        ),
      ),
    );
    final bare = tester.widget<EditableText>(find.byType(EditableText));
    expect(page.autocorrect, bare.autocorrect);
    expect(page.enableSuggestions, bare.enableSuggestions);
    expect(page.smartQuotesType, bare.smartQuotesType);
    expect(page.smartDashesType, bare.smartDashesType);
    expect(page.enableIMEPersonalizedLearning, bare.enableIMEPersonalizedLearning);
    expect(page.spellCheckConfiguration.toString(), bare.spellCheckConfiguration.toString());
    expect(page.autofillHints, bare.autofillHints);
    expect(page.inputFormatters, bare.inputFormatters);
    expect(page.textInputAction, bare.textInputAction);
    expect(page.obscureText, bare.obscureText);
    expect(page.readOnly, bare.readOnly);
  });

  Future<Harness> editing(WidgetTester tester, int index) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 8));
    final shown = n.dreams[index];
    await h.pump(
      tester,
      Opener(
        () async => TypingPage(
          journal: h.journal,
          target: await h.journal.targetNow(),
          edit: (id: n.id, index: index, text: shown),
        ),
      ),
    );
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    return h;
  }

  testWidgets('an edit replaces the dream at its own place', (tester) async {
    final h = await editing(tester, 1);
    final other = invented('one-dream-sv').dreams[0];
    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.nights()).single.dreams, [dreams[0], other]);
  });

  testWidgets('an edit emptied to nothing removes that dream only', (tester) async {
    final h = await editing(tester, 0);
    await tester.enterText(find.byKey(TypingPage.fieldKey), ' \n ');
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.nights()).single.dreams, [dreams[1]]);
  });

  testWidgets('a lone dream emptied by an edit deletes the night', (tester) async {
    final h = await Harness.make();
    final n = await keep(h, 'one-dream-sv', stockholm(2026, 6, 10, 8));
    await h.pump(
      tester,
      Opener(
        () async => TypingPage(
          journal: h.journal,
          target: await h.journal.targetNow(),
          edit: (id: n.id, index: 0, text: n.dreams[0]),
        ),
      ),
    );
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(TypingPage.fieldKey), '');
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect(await h.nights(), isEmpty);
    expect(h.files.files.keys.where((k) => k.startsWith('night-')), isEmpty);
  });

  testWidgets('a screen open across 21:00 saves into its own night', (tester) async {
    final h = await Harness.make();
    Harness.clock = stockholm(2026, 6, 10, 20, 58);
    await h.journal.addDream(await h.journal.targetNow(), dreams[0], Lang.en);
    await h.pump(tester, Opener(() async => TypingPage(journal: h.journal, target: await h.journal.targetNow())));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    Harness.clock = stockholm(2026, 6, 10, 21, 2);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[1]);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect([for (final n in await h.nights()) n.dreams], [dreams]);
  });

  // D63 (Product's message 18): no automatic focus, a page that scrolls
  // with the keyboard up, MP·62 after a failed save, and a save when the
  // app is left.
  testWidgets('the field takes no focus; a tap brings the keyboard', (tester) async {
    await open(tester);
    EditableText field() => tester.widget<EditableText>(find.byType(EditableText));
    expect(field().focusNode.hasFocus, isFalse);
    await tester.tap(find.byKey(TypingPage.fieldKey));
    await tester.pump();
    expect(field().focusNode.hasFocus, isTrue);
  });

  // An iPhone SE (375 x 667) with its keyboard up, at a text scale.
  Future<void> se(WidgetTester tester, {required double scale, double keyboard = 300}) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(750, 1334);
    tester.view.viewInsets = FakeViewPadding(bottom: keyboard * 2);
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
  }

  for (final scale in [1.0, 2.0, 3.1]) {
    testWidgets('an iPhone SE, keyboard up at ${scale}x: no overflow, Save reachable', (tester) async {
      await se(tester, scale: scale);
      final h = await open(tester);
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byKey(TypingPage.fieldKey)).height, greaterThanOrEqualTo(100 * scale));
      expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
      await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
      await tester.tap(find.byKey(TypingPage.saveKey));
      await tester.pumpAndSettle();
      expect((await h.nights()).single.dreams, [dreams[0]]);
    });
  }

  testWidgets('with the keyboard up, MP·10 scrolls away and the field stays', (tester) async {
    await se(tester, scale: 3.1);
    await open(tester);
    final area = find.byType(SingleChildScrollView);
    expect(tester.getRect(find.byType(AppLine)).top, greaterThanOrEqualTo(tester.getRect(area).top));
    await tester.drag(area, const Offset(0, -6000));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(AppLine)).bottom, lessThanOrEqualTo(tester.getRect(area).top));
    expect(tester.getRect(find.byKey(TypingPage.fieldKey)).bottom, lessThanOrEqualTo(tester.getRect(area).bottom + 1));
    expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
  });

  // The app goes away and comes back, as on the phone: no frame is drawn
  // while it is away, so the page leaves once the app is back.
  Future<void> leave(WidgetTester tester, AppLifecycleState state) async {
    tester.binding.handleAppLifecycleStateChanged(state);
    await tester.pump();
    for (final back in [
      if (state == AppLifecycleState.paused) AppLifecycleState.hidden,
      AppLifecycleState.inactive,
      AppLifecycleState.resumed,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(back);
    }
    await tester.pumpAndSettle();
  }

  testWidgets('leaving the app saves what is typed, from the screen\'s opening', (tester) async {
    final h = await open(tester);
    final opened = Harness.clock;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    Harness.clock = stockholm(2026, 6, 11, 3);
    await leave(tester, AppLifecycleState.hidden);
    expect(find.byType(TypingPage), findsNothing);
    final n = (await h.nights()).single;
    expect(n.dreams, [dreams[0]]);
    expect(n.firstRecorded, opened);
    expect(n.date, (year: 2026, month: 6, day: 10));
  });

  testWidgets('going inactive saves nothing', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pumpAndSettle();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    expect(find.text(dreams[0]), findsOneWidget);
    expect(await h.nights(), isEmpty);
  });

  testWidgets('paused saves', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await leave(tester, AppLifecycleState.paused);
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [dreams[0]]);
  });

  testWidgets('leaving the app with nothing typed keeps nothing and stays', (tester) async {
    final h = await open(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), ' \n ');
    await leave(tester, AppLifecycleState.hidden);
    expect(find.byType(TypingPage), findsOneWidget);
    expect(await h.nights(), isEmpty);
  });

  testWidgets('leaving the app saves an edit too', (tester) async {
    final h = await editing(tester, 0);
    final other = invented('one-dream-sv').dreams[0];
    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
    await leave(tester, AppLifecycleState.hidden);
    expect((await h.nights()).single.dreams, [other, dreams[1]]);
  });

  testWidgets('a failed save on leaving logs a code and shows MP·62', (tester) async {
    final lines = await logged();
    final files = FlakyFiles();
    final h = await open(tester, files: files);
    files.failures = 1;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await leave(tester, AppLifecycleState.hidden);
    expect(lines, ['journalSaveFailed']);
    expect(find.byType(TypingPage), findsOneWidget);
    expect(find.text(dreams[0]), findsOneWidget);
    expect(find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en)), findsOneWidget);
    expect(await h.nights(), isEmpty);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.nights()).single.dreams, [dreams[0]]);
  });

  testWidgets('a failed save on leaving is not retried on return', (tester) async {
    final lines = await logged();
    final files = FlakyFiles();
    final h = await open(tester, files: files);
    files.failures = 1;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await leave(tester, AppLifecycleState.paused);
    expect(lines, ['journalSaveFailed']);
    expect(find.byType(TypingPage), findsOneWidget);
    expect(await h.nights(), isEmpty);
  });
}
