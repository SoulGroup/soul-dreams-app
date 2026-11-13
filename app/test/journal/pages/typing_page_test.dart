// The typing screen (P2 to P4, P10, P12; D58 Q4; D70; D71): the field
// only, MP·12 as its placeholder, MP·10 once then MP·32; Save and Back
// keep the text as a new dream; an empty Save keeps nothing; an edit
// replaces; recording adds the words heard at the end.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/night_rules.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/recording/recording.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

import '../../fixtures.dart';
import '../memory_journal_files.dart';
import '../../recording/fakes.dart';
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

/// A folder whose listing, or whose write of the first-use flag, throws.
final class FirstUseFiles extends MemoryJournalFiles {
  bool listFails = false;
  bool markFails = false;

  @override
  Future<List<String>> list() async {
    if (listFails) throw const FileSystemException('list');
    return super.list();
  }

  @override
  Future<void> write(String name, Uint8List bytes) async {
    if (markFails && name == 'first-use-seen') throw const FileSystemException('write');
    return super.write(name, bytes);
  }
}

void main() {
  final dreams = invented('two-dreams-en').dreams;

  Future<Harness> open(WidgetTester tester, {DreamEdit? edit, MemoryJournalFiles? files, Recording? recording}) async {
    final h = await Harness.make(files: files);
    await h.pump(
      tester,
      Opener(
        () async => TypingPage(
          journal: h.journal,
          target: await h.journal.targetNow(),
          edit: edit,
          recording: recording,
        ),
      ),
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
      expect(find.byKey(TypingPage.fieldKey).hitTestable(), findsOneWidget);
      expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
      expect(find.byKey(TypingPage.startKey).hitTestable(), findsOneWidget);
      await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0] * 6);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
      await tester.tap(find.byKey(TypingPage.saveKey));
      await tester.pumpAndSettle();
      expect((await h.nights()).single.dreams, [dreams[0] * 6]);
    });
  }

  testWidgets('with the keyboard up, MP·10 scrolls away and the field stays', (tester) async {
    await se(tester, scale: 3.1);
    await open(tester);
    final area = find.byType(SingleChildScrollView);
    expect(tester.getRect(find.byType(AppLine)).top, greaterThanOrEqualTo(tester.getRect(area).top));
    await tester.drag(area, const Offset(0, -6000));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byType(AppLine)).top, lessThan(tester.getRect(area).top - 100));
    expect(find.byKey(TypingPage.fieldKey).hitTestable(), findsOneWidget);
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

  // 9c (the review of 9b): MP·62 sits in the instruction's scroll area,
  // so it can never squeeze the field away.
  testWidgets('a failure at largest text keeps the field, shows MP·62', (tester) async {
    await se(tester, scale: 3.1);
    final files = FlakyFiles();
    await open(tester, files: files);
    files.failures = 1;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final area = tester.getRect(find.byType(SingleChildScrollView));
    // Scrolled to its top (its padding first), the instruction above it out of sight.
    expect(tester.getRect(find.byType(AppLine).last).top, closeTo(area.top + StandIns.gap, 1));
    expect(find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en)), findsOneWidget);
    expect(find.byKey(TypingPage.fieldKey).hitTestable(), findsOneWidget);
    expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
  });

  testWidgets('MP·62 goes during a retry and stays if it fails', (tester) async {
    final files = FlakyFiles();
    final h = await open(tester, files: files);
    final shown = find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en));
    files.failures = 2;
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(shown, findsOneWidget);
    files.hold = Completer<void>();
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    expect(shown, findsNothing);
    files.hold!.complete();
    await tester.pumpAndSettle();
    expect(shown, findsOneWidget);
    files.hold = null;
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [dreams[0]]);
  });

  // D70 (head's message 20, Product message 19; D71).
  Future<Harness> tall(WidgetTester tester, {Recording? recording, MemoryJournalFiles? files}) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(786, 1704);
    addTearDown(tester.view.reset);
    final h = await Harness.make(files: files);
    await h.journal.markFirstUseSeen();
    await h.pump(
      tester,
      Opener(() async => TypingPage(journal: h.journal, target: await h.journal.targetNow(), recording: recording)),
    );
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    return h;
  }

  testWidgets('one line, growing with its words to 0.7 at most', (tester) async {
    await tall(tester);
    final field = find.byKey(TypingPage.fieldKey);
    final one = tester.getSize(field).height;
    expect(one, lessThan(80));
    final space = tester.getRect(find.byKey(TypingPage.saveKey)).top - StandIns.gap -
        tester.getRect(find.byKey(BackControl.buttonKey)).bottom;
    await tester.enterText(field, '${dreams[0]}\n${dreams[1]}');
    await tester.pumpAndSettle();
    expect(tester.getSize(field).height, greaterThan(one));
    expect(tester.getSize(field).height, lessThan(space * StandIns.fieldCap));
    await tester.enterText(field, List.filled(12, dreams[0]).join('\n'));
    await tester.pumpAndSettle();
    expect(tester.getSize(field).height, closeTo(space * StandIns.fieldCap, 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the instruction is centred, in the button type', (tester) async {
    await tall(tester);
    final line = tester.widget<AppLine>(find.byType(AppLine));
    expect(line.textAlign, TextAlign.center);
    expect(line.style.fontFamily, TypeRoles.button.style(Colors.black).fontFamily);
    expect(line.style.fontSize, TypeRoles.button.size);
  });

  testWidgets('Save on the left, Start Interpretation on the right', (tester) async {
    await tall(tester);
    final save = tester.getRect(find.byKey(TypingPage.saveKey));
    final start = tester.getRect(find.byKey(TypingPage.startKey));
    expect(find.text(Lines.EM_1.text(Lang.en)), findsOneWidget);
    expect(save.left, closeTo(StandIns.pageSide, 1));
    expect(start.right, closeTo(393 - StandIns.pageSide, 1));
    expect(save.center.dy, closeTo(start.center.dy, 1));
  });

  testWidgets('Start Interpretation does nothing yet (D71 Q3)', (tester) async {
    final h = await tall(tester);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    await tester.tap(find.byKey(TypingPage.startKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    expect(await h.nights(), isEmpty);
  });

  testWidgets('no microphone in a build that does not record', (tester) async {
    await tall(tester);
    expect(find.byKey(TypingPage.micKey), findsNothing);
  });

  // Recording (D69, as D71 corrects it), on a microphone of silence and a
  // stream held in memory.
  ({SilentMicrophone mic, MemoryLink link, Recording recording}) voice({bool on = true}) {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    return (
      mic: mic,
      link: link,
      recording: Recording(on: on, microphone: mic, key: () async => 'k', connect: (_) async => link),
    );
  }

  Future<void> record(WidgetTester tester) async {
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    await tester.pump();
  }

  final tokens = inventedTokens();

  testWidgets('words appear as they are heard; Save keeps them', (tester) async {
    final lines = await logged();
    final v = voice();
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    expect(v.mic.running, isTrue);
    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    expect(find.text(tokens[0] + tokens[1]), findsOneWidget);
    v.link.reply(reply(done: [tokens[1], tokens[2]]));
    await tester.pump();
    expect(find.text(tokens.take(3).join()), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    expect(v.mic.running, isFalse);
    expect(v.link.sent.last, '');
    v.link.reply(reply(done: [tokens[3]]));
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [tokens.take(4).join()]);
    expect(lines, ['recordingStarted', 'recordingEnded']);
  });

  testWidgets('heard words go at the end, never at the caret', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final typed = dreams[1];
    await tester.enterText(find.byKey(TypingPage.fieldKey), typed);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    field.controller!.selection = const TextSelection.collapsed(offset: 4);
    await record(tester);
    v.link.reply(reply(done: [tokens[0]]));
    await tester.pump();
    expect(field.controller!.text, '$typed ${tokens[0]}');
    expect(field.controller!.selection, const TextSelection.collapsed(offset: 4));
  });

  testWidgets('MP·33 is told once; the level line and the timer show', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    tester.takeAnnouncements();
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    await record(tester);
    expect([for (final a in tester.takeAnnouncements()) a.message], [Lines.MP_33.text(Lang.en)]);
    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
    v.mic.frame(16384);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('0:02'), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    expect(v.mic.running, isFalse);
    expect(tester.takeAnnouncements(), isEmpty);
  });

  testWidgets('a refused microphone shows nothing new, logs a code', (tester) async {
    final lines = await logged();
    final v = voice();
    v.mic.allow = false;
    await tall(tester, recording: v.recording);
    await record(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    expect(tester.takeAnnouncements(), isEmpty);
    expect(lines, ['recordingRefused']);
  });

  testWidgets('recording off: the microphone starts nothing', (tester) async {
    final lines = await logged();
    final v = voice(on: false);
    await tall(tester, recording: v.recording);
    await record(tester);
    expect(v.mic.running, isFalse);
    expect(lines, ['recordingOff']);
  });

  testWidgets('a broken stream stops, keeping the words shown', (tester) async {
    final lines = await logged();
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    await v.link.drop(1011);
    await tester.pumpAndSettle();
    expect(v.mic.running, isFalse);
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    expect(find.text(tokens[0] + tokens[1]), findsOneWidget);
    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
  });

  testWidgets('leaving the app while recording ends it and saves the words', (tester) async {
    final v = voice();
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    v.link.reply(reply(done: [tokens[0]]));
    await tester.pump();
    await leave(tester, AppLifecycleState.hidden);
    expect(v.mic.running, isFalse);
    expect(v.link.closed, isTrue);
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

  testWidgets('Back while recording waits for the last words, then saves', (tester) async {
    final v = voice();
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pump();
    v.link.reply(reply(done: [tokens[0]], finished: true));
    await tester.pumpAndSettle();
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

  // D74: a session starts after typed words with one space, and goes on
  // exactly as Soniox sends.
  testWidgets('a second recording starts after the first with one space', (tester) async {
    final heard = invented('two-dreams-en').heard;
    final first = heard[0].join();
    final second = heard[1];
    final mic = SilentMicrophone();
    final links = <MemoryLink>[];
    final recording = Recording(
      on: true,
      microphone: mic,
      key: () async => 'k',
      connect: (_) async => MemoryLink().._keep(links),
    );
    await tall(tester, recording: recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    links[0].reply(reply(done: heard[0]));
    await tester.pump();
    expect(field.controller!.text, first);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    links[0].reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(mic.running, isFalse);
    await record(tester);
    links[1].reply(reply(shown: [second[0]]));
    await tester.pump();
    expect(field.controller!.text, '$first ${second[0]}');
    links[1].reply(reply(done: [second[0]], shown: [second[1]]));
    await tester.pump();
    links[1].reply(reply(done: second.sublist(1, 3)));
    await tester.pump();
    for (final piece in second.sublist(3)) {
      links[1].reply(reply(done: [piece]));
      await tester.pump();
    }
    expect(field.controller!.text, '$first ${second.join()}');
  });

  // D74 (the re-review of Task 7b): Back or Save while the microphone is
  // still starting.
  testWidgets('Back while the microphone starts: it never streams', (tester) async {
    final v = voice();
    v.mic.startHold = Completer<void>();
    final h = await tall(tester, recording: v.recording);
    await tester.enterText(find.byKey(TypingPage.fieldKey), tokens[0]);
    await record(tester);
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pump();
    v.mic.startHold!.complete();
    await tester.pump();
    await tester.pump();
    expect(v.mic.stops, 1);
    expect(v.mic.running, isFalse);
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(v.link.sent, ['']);
    expect(v.mic.stops, 1);
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

  testWidgets('the microphone ignores taps while Save waits: no second session', (tester) async {
    final v = voice();
    v.mic.startHold = Completer<void>();
    final h = await tall(tester, recording: v.recording);
    await tester.enterText(find.byKey(TypingPage.fieldKey), tokens[0]);
    await record(tester);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    v.mic.startHold!.complete();
    await tester.pump();
    await tester.pump();
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    await tester.pump();
    expect(v.mic.starts, 1);
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(v.mic.starts, 1);
    expect(v.mic.stops, 1);
    expect(v.mic.running, isFalse);
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

  // D75 (the review of Task 8).
  // 1. A start that comes late from an earlier session changes nothing.
  Recording lateKey(SilentMicrophone mic, Completer<String> first, List<MemoryLink> links) {
    var asked = 0;
    return Recording(
      on: true,
      microphone: mic,
      key: () => asked++ == 0 ? first.future : Future.value('k'),
      connect: (_) async => MemoryLink().._keep(links),
    );
  }

  Future<void> stopsTheSecond(WidgetTester tester, SilentMicrophone mic, List<MemoryLink> links) async {
    expect(mic.running, isTrue);
    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    expect(mic.running, isFalse);
    links.single.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(mic.stops, 1);
    expect(find.byKey(TypingPage.levelKey), findsNothing);
  }

  testWidgets('a late start after leaving and coming back changes nothing', (tester) async {
    final mic = SilentMicrophone();
    final key = Completer<String>();
    final links = <MemoryLink>[];
    await tall(tester, recording: lateKey(mic, key, links));
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    await leave(tester, AppLifecycleState.hidden);
    expect(find.byType(TypingPage), findsOneWidget);
    await record(tester);
    key.complete('late');
    await tester.pump();
    await tester.pump();
    await stopsTheSecond(tester, mic, links);
  });

  testWidgets('a late start after a failed Save changes nothing', (tester) async {
    final files = FlakyFiles();
    final mic = SilentMicrophone();
    final key = Completer<String>();
    final links = <MemoryLink>[];
    await tall(tester, recording: lateKey(mic, key, links), files: files);
    await tester.enterText(find.byKey(TypingPage.fieldKey), tokens[0]);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    files.failures = 1;
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    await record(tester);
    key.complete('late');
    await tester.pump();
    await tester.pump();
    await stopsTheSecond(tester, mic, links);
  });

  // 2. An iPhone SE with the keyboard up, recording, at each text size.
  for (final scale in [1.0, 2.0, 3.1]) {
    testWidgets('an iPhone SE, keyboard up, recording at ${scale}x: words above Save', (tester) async {
      await se(tester, scale: scale);
      final v = voice();
      final h = await open(tester, recording: v.recording);
      await record(tester);
      expect(tester.takeException(), isNull);
      final long = tokensOf(invented('long-dream-en').dreams.single);
      v.link.reply(reply(done: long));
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
      final field = tester.getRect(find.byKey(TypingPage.fieldKey));
      final save = tester.getRect(find.byKey(TypingPage.saveKey));
      expect(field.bottom, lessThanOrEqualTo(save.top));
      expect(find.byKey(TypingPage.saveKey).hitTestable(), findsOneWidget);
      expect(find.byKey(TypingPage.levelKey), findsOneWidget);
      await tester.tap(find.byKey(TypingPage.saveKey));
      await tester.pump();
      v.link.reply(reply(finished: true));
      await tester.pumpAndSettle();
      expect((await h.nights()).single.dreams, [long.join()]);
    });
  }

  // 3. Typing during a recording drops the stale provisional piece.
  testWidgets('typing while words are provisional: they never double', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    v.link.reply(reply(shown: [tokens[0], tokens[1]]));
    await tester.pump();
    expect(field.controller!.text, tokens[0] + tokens[1]);
    field.controller!.text = '${field.controller!.text}x';
    v.link.reply(reply(done: [tokens[0], tokens[1]]));
    await tester.pump();
    expect(field.controller!.text, 'x ${tokens[0]}${tokens[1]}');
    v.link.reply(reply(done: [tokens[2]]));
    await tester.pump();
    expect(field.controller!.text, 'x ${tokens.take(3).join()}');
  });

  // D76: typed words that repeat the piece do not fool the drop.
  testWidgets('typing a copy of the provisional piece: the shown one goes', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    expect(field.controller!.text, tokens[0] + tokens[1]);
    field.controller!.text = '${field.controller!.text} q${tokens[1]}';
    v.link.reply(reply(done: [tokens[1]]));
    await tester.pump();
    expect(field.controller!.text, '${tokens[0]} q${tokens[1]}${tokens[1]}');
  });

  // D77: an edit before the piece, and the field emptied while dictating.
  testWidgets('typed before: a copy at the old offset stays', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    field.controller!.text = 'Q${tokens[1]} ${field.controller!.text}';
    v.link.reply(reply(done: [tokens[1]]));
    await tester.pump();
    expect(field.controller!.text, 'Q${tokens[1]} ${tokens[0]}${tokens[1]}');
  });

  testWidgets('the field emptied while dictating: later words still arrive', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    field.controller!.text = '';
    v.link.reply(reply(done: [tokens[1]]));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(field.controller!.text, tokens[1].trimLeft());
    v.link.reply(reply(done: [tokens[2]]));
    await tester.pump();
    expect(field.controller!.text, tokens[1].trimLeft() + tokens[2]);
  });

  // 4. Leaving the app while Save waits for the last words.
  testWidgets('leaving the app while Save waits: saved at once', (tester) async {
    final v = voice();
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    v.link.reply(reply(done: [tokens[0]]));
    await tester.pump();
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    expect(v.link.closed, isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump();
    await tester.pump();
    expect(v.link.closed, isTrue);
    expect(v.mic.running, isFalse);
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

  // 6. The keyboard's composing text survives words arriving after it; a
  // Save that waits does not touch a screen that has gone.
  testWidgets('heard words keep the composing text before them', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    field.controller!.value = TextEditingValue(
      text: tokens[0],
      selection: TextSelection.collapsed(offset: tokens[0].length),
      composing: TextRange(start: 0, end: tokens[0].length),
    );
    v.link.reply(reply(done: [tokens[1]]));
    await tester.pump();
    expect(field.controller!.value.composing, TextRange(start: 0, end: tokens[0].length));
    expect(field.controller!.text, tokens[0] + tokens[1]);
  });

  testWidgets('composing text in a changed part is dropped', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    v.link.reply(reply(shown: [tokens[0], tokens[1]]));
    await tester.pump();
    final typed = '${field.controller!.text}x';
    field.controller!.value = TextEditingValue(
      text: typed,
      selection: TextSelection.collapsed(offset: typed.length),
      composing: TextRange(start: typed.length - 1, end: typed.length),
    );
    v.link.reply(reply(done: [tokens[0], tokens[1]]));
    await tester.pump();
    expect(field.controller!.value.composing, TextRange.empty);
  });

  testWidgets('a Save that waits survives its screen going', (tester) async {
    final files = FlakyFiles();
    final v = voice();
    final h = await tall(tester, recording: v.recording, files: files);
    await tester.enterText(find.byKey(TypingPage.fieldKey), tokens[0]);
    files.failures = 1;
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    await record(tester);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    tester.state<NavigatorState>(find.byType(Navigator).first).pop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

  // D71 Q18: the first-use read or mark failing.
  Future<Harness> firstUse(WidgetTester tester, FirstUseFiles files) async {
    final h = await Harness.make(files: files);
    final target = NewNight(Harness.clock);
    await h.pump(tester, Opener(() async => TypingPage(journal: h.journal, target: target)));
    return h;
  }

  testWidgets('a failed first-use read shows MP·32, marks nothing, logs a code', (tester) async {
    final lines = await logged();
    final files = FirstUseFiles();
    await firstUse(tester, files);
    files.listFails = true;
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(Lines.MP_32.text(Lang.en)), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsNothing);
    expect(lines, ['firstUseReadFailed']);
    expect(files.files.containsKey('first-use-seen'), isFalse);
  });

  testWidgets('a failed first-use mark still shows MP·10, logs a code', (tester) async {
    final lines = await logged();
    final files = FirstUseFiles()..markFails = true;
    await firstUse(tester, files);
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(Lines.MP_10.text(Lang.en)), findsOneWidget);
    expect(lines, ['firstUseReadFailed']);
  });
}

extension on MemoryLink {
  void _keep(List<MemoryLink> links) => links.add(this);
}
