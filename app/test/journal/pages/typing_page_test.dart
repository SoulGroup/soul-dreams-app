// The typing screen (P2 to P4, P10, P12; D58 Q4; D70; D71): the field
// only, MP·12 as its placeholder, MP·10 once then MP·32; Save and Back
// keep the text as a new dream; an empty Save keeps nothing; an edit
// replaces; recording puts the words heard in at the caret (D87, D90).
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
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_rules.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/recording/heard_text.dart';
import 'package:souldreams/recording/recording.dart';
import 'package:souldreams/recording/retries.dart';
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

/// Recordings waiting, as the retries see them: none; it counts the looks.
final class NoneWaiting implements WaitingAudio {
  int looks = 0;

  @override
  Future<List<Pending>> waiting() async {
    looks++;
    return const [];
  }

  @override
  Future<({int start, int size})?> part(String audio) async => null;

  @override
  Future<Uint8List> read(String audio, int start, int at, int length) async => Uint8List(0);

  @override
  Future<void> heard(Pending pending, String words, int to, {required bool done}) async {}
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
  Future<Harness> tall(WidgetTester tester, {Recording? recording, MemoryJournalFiles? files, DreamEdit? edit}) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(786, 1704);
    addTearDown(tester.view.reset);
    final h = await Harness.make(files: files);
    await h.journal.markFirstUseSeen();
    await h.pump(
      tester,
      Opener(
        () async =>
            TypingPage(journal: h.journal, target: await h.journal.targetNow(), recording: recording, edit: edit),
      ),
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

  // D79 b: a call or Siri ends the recording as Stop does.
  testWidgets('an interruption ends the recording: words kept, the timer stops', (tester) async {
    final lines = await logged();
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    v.link.reply(reply(done: [tokens[0]]));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('0:02'), findsOneWidget);
    v.mic.interrupt();
    await tester.pump();
    expect(v.mic.running, isFalse);
    // The clock stops at once, while the last words are waited for (D83).
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('0:02'), findsOneWidget);
    v.link.reply(reply(done: [tokens[1]], finished: true));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    expect(field.controller!.text, tokens[0] + tokens[1]);
    expect(lines, ['recordingStarted', 'recordingInterrupted', 'recordingEnded']);
    expect(tester.widget<IconButton>(find.byKey(TypingPage.micKey)).isSelected, isFalse);
  });

  testWidgets('Stop tapped: the clock stops, the last words still come', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await record(tester);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('0:02'), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('0:02'), findsOneWidget);
    v.link.reply(reply(done: [tokens[0]], finished: true));
    await tester.pumpAndSettle();
    expect(field.controller!.text, tokens[0].trimLeft());
    expect(find.byKey(TypingPage.levelKey), findsNothing);
  });

  // D93 Q4: a refused microphone shows MP·63 where MP·62 shows, in place of
  // nothing, until the next tap of the microphone.
  testWidgets('a refused microphone shows MP·63, logs a code', (tester) async {
    final lines = await logged();
    final v = voice();
    v.mic.allow = false;
    await tall(tester, recording: v.recording);
    expect(find.byKey(TypingPage.noticeKey), findsNothing);
    await record(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    expect(tester.takeAnnouncements(), isEmpty);
    expect(lines, ['recordingRefused']);
    final shown = find.bySemanticsLabel(PendingLines.MP_63.text(Lang.en));
    expect(shown, findsOneWidget);
    final live = find.byWidgetPredicate((w) => w is Semantics && w.properties.liveRegion == true);
    expect(find.descendant(of: find.byKey(TypingPage.noticeKey), matching: live), findsOneWidget);
    final line = tester.widget<AppLine>(
      find.descendant(of: find.byKey(TypingPage.noticeKey), matching: find.byType(AppLine)),
    );
    expect(line.style.fontSize, TypeRoles.button.size);
  });

  testWidgets('MP·63 goes at the next tap, and returns on a refusal', (tester) async {
    final v = voice();
    v.mic.allow = false;
    await tall(tester, recording: v.recording);
    await record(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.noticeKey), findsOneWidget);
    v.mic.allow = true;
    await record(tester);
    expect(find.byKey(TypingPage.noticeKey), findsNothing);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    v.mic.allow = false;
    await record(tester);
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.noticeKey), findsOneWidget);
  });

  testWidgets('the microphone is named MP·11, and MP·64 while it records', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    String name() => tester.widget<IconButton>(find.byKey(TypingPage.micKey)).tooltip!;
    expect(name(), Lines.MP_11.text(Lang.en));
    await record(tester);
    expect(name(), PendingLines.MP_64.text(Lang.en));
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    expect(name(), PendingLines.MP_64.text(Lang.en));
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(name(), Lines.MP_11.text(Lang.en));
  });

  // Task 16f-1: after a start that fails, the field is the dreamer's again
  // at once: typing works.
  testWidgets('after a refused microphone the field takes typing', (tester) async {
    final v = voice();
    v.mic.allow = false;
    await tall(tester, recording: v.recording);
    await tester.showKeyboard(find.byKey(TypingPage.fieldKey));
    await record(tester);
    await tester.pumpAndSettle();
    final text = tester.widget<TextField>(find.byKey(TypingPage.fieldKey)).controller!;
    for (final typed in [tokens[0], tokens[0] + tokens[1]]) {
      tester.testTextInput.updateEditingValue(
        TextEditingValue(text: typed, selection: TextSelection.collapsed(offset: typed.length)),
      );
      await tester.pump();
      expect(text.text, typed);
    }
  });

  // D88: the recording starts the instant the microphone is tapped.
  testWidgets('the clock starts on the tap, before the stream opens', (tester) async {
    final mic = SilentMicrophone();
    final key = Completer<String>();
    final recording = Recording(on: true, microphone: mic, key: () => key.future, connect: (_) async => MemoryLink());
    await tall(tester, recording: recording);
    await record(tester);
    expect(mic.running, isTrue);
    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('0:02'), findsOneWidget);
  });

  testWidgets('the key fetched on opening is used by the tap', (tester) async {
    var fetched = 0;
    final recording = Recording(
      on: true,
      microphone: SilentMicrophone(),
      key: () async => '${fetched++}',
      connect: (_) async => MemoryLink(),
    );
    await tall(tester, recording: recording);
    expect(fetched, 1);
    await record(tester);
    await tester.pump();
    expect(fetched, 1);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump(lastWords);
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    expect(fetched, 2);
  });

  // The re-review of 16f-1: a stop while the microphone starts ends the
  // session before the start reports; the field is then the dreamer's.
  testWidgets('a key press while the microphone starts, then typing works', (tester) async {
    final mic = SilentMicrophone()..startHold = Completer<void>();
    final recording = Recording(on: true, microphone: mic, key: () async => 'k', connect: (_) async => MemoryLink());
    await tall(tester, recording: recording);
    await tester.showKeyboard(find.byKey(TypingPage.fieldKey));
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    Future<void> type(String text) async {
      tester.testTextInput.updateEditingValue(
        TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length)),
      );
      await tester.pump();
    }

    await type(tokens[0]);
    mic.startHold!.complete();
    await tester.pumpAndSettle();
    expect(mic.running, isFalse);
    final text = tester.widget<TextField>(find.byKey(TypingPage.fieldKey)).controller!;
    expect(text.text, '');
    await type(tokens[0]);
    await type(tokens[0] + tokens[1]);
    expect(text.text, tokens[0] + tokens[1]);
    expect(tester.takeException(), isNull);
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
    await tester.pumpAndSettle();
    // D88: the stream never opened; nothing was sent.
    expect(v.link.sent, isEmpty);
    expect(v.mic.stops, 1);
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

  testWidgets('the microphone ignores taps while Save waits: no second session', (tester) async {
    // D88: the recording has ended and Save's write is still under way.
    final files = FlakyFiles();
    final v = voice();
    final h = await tall(tester, recording: v.recording, files: files);
    files.hold = Completer<void>();
    await record(tester);
    v.link.reply(reply(done: [tokens[0]]));
    await tester.pump();
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    v.link.reply(reply(finished: true));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    await tester.pump();
    expect(v.mic.starts, 1);
    files.hold!.complete();
    await tester.pumpAndSettle();
    expect(v.mic.starts, 1);
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

  // D88: the first session's microphone started and was stopped; its late
  // key opens no stream; only the second session's stream exists.
  Future<void> stopsTheSecond(WidgetTester tester, SilentMicrophone mic, List<MemoryLink> links) async {
    expect(mic.running, isTrue);
    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
    final before = mic.stops;
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pump();
    expect(mic.running, isFalse);
    links.single.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(mic.stops, before + 1);
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
    // D88: Save waits, at most the five seconds of D75, for the stream that
    // never opens; then the write fails and the screen stays.
    await tester.pump(lastWords);
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

  // 3. (Typing during a recording: replaced by D87, below.)
  // 4. Leaving the app while Save waits for the last words.
  testWidgets('leaving while Save waits for the stream: saved at once', (tester) async {
    final key = Completer<String>();
    final recording = Recording(on: true, microphone: SilentMicrophone(), key: () => key.future, connect: (_) async => MemoryLink());
    final h = await tall(tester, recording: recording);
    await tester.enterText(find.byKey(TypingPage.fieldKey), tokens[0]);
    await record(tester);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump();
    await tester.pump();
    expect((await h.nights()).single.dreams, [tokens[0]]);
  });

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

  // Task 16a: the owner's crash. Backspace, as the phone's keyboard sends
  // it, over the heard words while final pieces keep arriving; under D90 the
  // first press only stops the recording and the rest of the wait's are
  // ignored: every word stays.
  testWidgets('backspacing over heard words while finals arrive', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    await tester.showKeyboard(find.byKey(TypingPage.fieldKey));
    await record(tester);
    v.link.reply(reply(done: tokens.take(4).toList(), shown: [tokens[4]]));
    await tester.pump();
    for (var i = 0; i < 40; i++) {
      final now = field.controller!.text;
      final cut = now.isEmpty ? '' : now.substring(0, now.length - 1);
      tester.testTextInput.updateEditingValue(
        TextEditingValue(text: cut, selection: TextSelection.collapsed(offset: cut.length)),
      );
      await tester.pump();
      if (i.isEven && i < 6) {
        v.link.reply(reply(done: [tokens[4 + i % 3]], shown: [tokens[5 + i % 3]]));
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
    }
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(field.controller!.text, tokens.take(4).join() + tokens[4] + tokens[6] + tokens[5]);
  });

  // D79 a: while recording, the field follows the end; scrolled up, it
  // stays until the dreamer is back at the bottom.
  ScrollPosition fieldScroll(WidgetTester tester) => tester
      .state<ScrollableState>(find.descendant(of: find.byKey(TypingPage.fieldKey), matching: find.byType(Scrollable)))
      .position;

  // Words heard, and a frame more for the field's new height (D80).
  Future<void> hear(WidgetTester tester, MemoryLink link, List<String> done) async {
    link.reply(reply(done: done));
    await tester.pump();
    await tester.pump();
  }

  bool atBottom(ScrollPosition scroll) => scroll.pixels >= scroll.maxScrollExtent - 1;

  Future<ScrollPosition> filled(WidgetTester tester, MemoryLink link) async {
    for (var i = 0; i < 6; i++) {
      await hear(tester, link, tokens);
    }
    final scroll = fieldScroll(tester);
    expect(scroll.maxScrollExtent, greaterThan(0));
    expect(atBottom(scroll), isTrue);
    return scroll;
  }

  testWidgets('recording: the field follows the newest words', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    await filled(tester, v.link);
  });

  // D80 2: an edit opens at its top; recording at its end jumps there at once.
  testWidgets('an edit opened at its top follows from the start', (tester) async {
    final v = voice();
    final long = List.filled(8, tokens.join()).join(' ');
    await tall(tester, recording: v.recording, edit: (id: 'n', index: 0, text: long));
    final scroll = fieldScroll(tester);
    expect(scroll.pixels, 0);
    await record(tester);
    await tester.pump();
    expect(atBottom(scroll), isTrue);
    await hear(tester, v.link, tokens);
    expect(scroll.pixels, greaterThan(0));
    expect(atBottom(scroll), isTrue);
  });

  testWidgets('an upward drag pauses; back at the bottom, it follows', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    final scroll = await filled(tester, v.link);
    await tester.drag(find.byKey(TypingPage.fieldKey), const Offset(0, 120));
    await tester.pumpAndSettle();
    final paused = scroll.pixels;
    expect(atBottom(scroll), isFalse);
    await hear(tester, v.link, tokens);
    expect(scroll.pixels, paused);
    await tester.drag(find.byKey(TypingPage.fieldKey), const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(atBottom(scroll), isTrue);
    await hear(tester, v.link, tokens);
    expect(atBottom(scroll), isTrue);
  });

  testWidgets('the app scrolling to the bottom does not resume', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    final scroll = await filled(tester, v.link);
    await tester.drag(find.byKey(TypingPage.fieldKey), const Offset(0, 120));
    await tester.pumpAndSettle();
    scroll.jumpTo(0);
    await tester.pump();
    scroll.jumpTo(scroll.maxScrollExtent);
    await tester.pump();
    final paused = scroll.pixels;
    await hear(tester, v.link, tokens);
    expect(scroll.pixels, paused);
    expect(atBottom(scroll), isFalse);
  });

  // D81: a jump scheduled before the dreamer's drag never fires during it.
  testWidgets('words arriving as an upward drag starts: it keeps going', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    final scroll = await filled(tester, v.link);
    v.link.reply(reply(done: tokens));
    await tester.idle();
    final drag = await tester.startGesture(tester.getCenter(find.byKey(TypingPage.fieldKey)));
    await drag.moveBy(const Offset(0, 30));
    await drag.moveBy(const Offset(0, 30));
    final held = scroll.pixels;
    await tester.pump();
    await tester.pump();
    expect(scroll.pixels, held);
    await drag.moveBy(const Offset(0, 60));
    expect(scroll.pixels, lessThan(held));
    await drag.up();
    await tester.pumpAndSettle();
  });

  testWidgets('words arriving as a short upward drag ends: the view stays', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    final scroll = await filled(tester, v.link);
    v.link.reply(reply(done: tokens));
    await tester.idle();
    await tester.drag(find.byKey(TypingPage.fieldKey), const Offset(0, 120));
    final held = scroll.pixels;
    await tester.pump();
    await tester.pump();
    expect(scroll.pixels, held);
    expect(atBottom(scroll), isFalse);
  });

  testWidgets('words arriving during a drag toward the end: it keeps going', (tester) async {
    final v = voice();
    final long = List.filled(8, tokens.join()).join(' ');
    await tall(tester, recording: v.recording, edit: (id: 'n', index: 0, text: long));
    // Dictation near the top: the insertion point in view, following on.
    tester.widget<TextField>(find.byKey(TypingPage.fieldKey)).controller!.selection =
        const TextSelection.collapsed(offset: 4);
    await tester.pump();
    await record(tester);
    await hear(tester, v.link, [tokens[1]]);
    final scroll = fieldScroll(tester);
    final drag = await tester.startGesture(tester.getCenter(find.byKey(TypingPage.fieldKey)));
    await drag.moveBy(const Offset(0, -30));
    await drag.moveBy(const Offset(0, -60));
    v.link.reply(reply(done: [tokens[2]]));
    await tester.idle();
    final held = scroll.pixels;
    await tester.pump();
    await tester.pump();
    expect(scroll.pixels, held);
    await drag.moveBy(const Offset(0, -20));
    expect(scroll.pixels, greaterThan(held));
    await drag.up();
    await tester.pumpAndSettle();
  });

  // D87, D90: dictation goes in at the caret where the recording started;
  // any edit attempt only stops it as Stop does and is never applied; a
  // tapped caret moves with the words; attempts during the wait are ignored.
  TextEditingController fieldText(WidgetTester tester) =>
      tester.widget<TextField>(find.byKey(TypingPage.fieldKey)).controller!;

  Future<void> keyboard(WidgetTester tester, String text) async {
    tester.testTextInput.updateEditingValue(
      TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length)),
    );
    await tester.pump();
  }

  testWidgets('dictation goes in at the caret; the rest stays after', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final typed = dreams[1];
    await tester.enterText(find.byKey(TypingPage.fieldKey), typed);
    final text = fieldText(tester);
    final at = typed.indexOf(' ');
    text.selection = TextSelection.collapsed(offset: at);
    await record(tester);
    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    final head = typed.substring(0, at);
    final tail = typed.substring(at);
    expect(text.text, '$head ${tokens[0]}${tokens[1]}$tail');
    expect(text.selection.baseOffset, at + 1 + (tokens[0] + tokens[1]).length);
    await tester.tap(find.byKey(TypingPage.micKey));
    v.link.reply(reply(done: [tokens[1], tokens[2]], finished: true));
    await tester.pumpAndSettle();
    expect(text.text, '$head ${tokens.take(3).join()}$tail');
  });

  testWidgets('dictation after a space: one space before the words after it', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final typed = dreams[1];
    await tester.enterText(find.byKey(TypingPage.fieldKey), typed);
    final text = fieldText(tester);
    final at = typed.indexOf(' ') + 1;
    text.selection = TextSelection.collapsed(offset: at);
    await record(tester);
    v.link.reply(reply(done: [tokens[0], tokens[1]]));
    await tester.pump();
    expect(text.text, '${typed.substring(0, at)}${tokens[0]}${tokens[1]} ${typed.substring(at)}');
  });

  testWidgets('a selected range: the words go in after it, it stays', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final typed = dreams[1];
    await tester.enterText(find.byKey(TypingPage.fieldKey), typed);
    final text = fieldText(tester);
    final at = typed.indexOf(' ');
    text.selection = TextSelection(baseOffset: 0, extentOffset: at);
    await record(tester);
    v.link.reply(reply(done: [tokens[0]]));
    await tester.pump();
    expect(text.text, '${typed.substring(0, at)} ${tokens[0]}${typed.substring(at)}');
  });

  // D90: an edit attempt while recording only stops it; the attempt is
  // never applied, and no character of the settled text changes.
  Future<({MemoryLink link, SilentMicrophone mic, TextEditingController text})> dictatingInto(
    WidgetTester tester, {
    String typed = '',
  }) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    if (typed.isNotEmpty) await tester.enterText(find.byKey(TypingPage.fieldKey), typed);
    await tester.showKeyboard(find.byKey(TypingPage.fieldKey));
    await record(tester);
    return (link: v.link, mic: v.mic, text: fieldText(tester));
  }

  Future<void> attemptStops(WidgetTester tester, String Function(String shown) attempt, {String typed = ''}) async {
    final r = await dictatingInto(tester, typed: typed);
    r.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    final shown = r.text.text;
    await keyboard(tester, attempt(shown));
    expect(r.text.text, shown);
    expect(r.mic.running, isFalse);
    expect(r.link.sent.last, '');
    r.link.reply(reply(done: [tokens[1], tokens[2]], finished: true));
    await tester.pumpAndSettle();
    final settled = dictatedInto(typed, tokens.take(3).join(), '');
    expect(r.text.text, settled.text);
    expect(r.text.selection, TextSelection.collapsed(offset: settled.end));
  }

  testWidgets('a key press only stops the recording', (tester) async {
    await attemptStops(tester, (shown) => '${shown}x');
  });

  testWidgets('a backspace only stops the recording', (tester) async {
    await attemptStops(tester, (shown) => shown.substring(0, shown.length - 1));
  });

  testWidgets('a paste only stops the recording', (tester) async {
    await attemptStops(tester, (shown) => shown + tokens[4] + tokens[5]);
  });

  testWidgets('a cut only stops the recording', (tester) async {
    await attemptStops(tester, (shown) => shown.substring(0, 1), typed: dreams[1]);
  });

  testWidgets('a backspace with typed text before the words only stops it', (tester) async {
    await attemptStops(tester, (shown) => shown.substring(0, shown.length - 1), typed: dreams[1]);
  });

  testWidgets('a backspace before any word only stops the recording', (tester) async {
    final r = await dictatingInto(tester, typed: dreams[1]);
    await keyboard(tester, dreams[1].substring(0, dreams[1].length - 1));
    expect(r.text.text, dreams[1]);
    expect(r.mic.running, isFalse);
    r.link.reply(reply(done: [tokens[0], tokens[1]], finished: true));
    await tester.pumpAndSettle();
    expect(r.text.text, dictatedInto(dreams[1], tokens[0] + tokens[1], '').text);
  });

  // The reviewer's case of 16g: a one-letter first piece, one backspace,
  // more words land: every word stays.
  testWidgets('a one-letter first piece and one backspace: every word stays', (tester) async {
    final r = await dictatingInto(tester);
    r.link.reply(reply(shown: [tokens[0]]));
    await tester.pump();
    expect(r.text.text, tokens[0]);
    await keyboard(tester, '');
    r.link.reply(reply(done: [tokens[0], tokens[1], tokens[2]], finished: true));
    await tester.pumpAndSettle();
    expect(r.text.text, tokens.take(3).join());
  });

  testWidgets('presses during the wait are ignored', (tester) async {
    final r = await dictatingInto(tester);
    r.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    final shown = r.text.text;
    await keyboard(tester, '${shown}x');
    await keyboard(tester, shown.substring(0, shown.length - 1));
    await tester.tapAt(tester.getTopLeft(find.byKey(TypingPage.fieldKey)) + const Offset(40, 30));
    await tester.pump();
    expect(r.text.text, shown);
    r.link.reply(reply(done: [tokens[1]], finished: true));
    await tester.pumpAndSettle();
    expect(r.text.text, tokens[0] + tokens[1]);
    expect(r.text.selection, TextSelection.collapsed(offset: r.text.text.length));
  });

  // Task 16g-2: a tap during the wait is ignored even when no last words
  // come (the stream drops): the caret ends after the dictated words (D90).
  testWidgets('tap in the wait, then a drop: caret after the words', (tester) async {
    final r = await dictatingInto(tester);
    r.link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await tester.pump();
    final shown = r.text.text;
    await keyboard(tester, '${shown}x');
    await tester.tapAt(tester.getTopLeft(find.byKey(TypingPage.fieldKey)) + const Offset(40, 30));
    await tester.pump();
    await r.link.drop(1000);
    await tester.pumpAndSettle();
    expect(r.text.text, shown);
    expect(r.text.selection, TextSelection.collapsed(offset: shown.length));
  });

  // A tap that moves the caret stops the recording; the caret lands where
  // the dreamer put it, moved with the words when at or after them.
  testWidgets('a tap moving the caret stops the recording; nothing lost', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    final text = fieldText(tester);
    v.link.reply(reply(done: [tokens[0], tokens[1], tokens[2]], shown: [tokens[3]]));
    await tester.pump();
    final shown = text.text.length;
    await tester.tapAt(tester.getTopLeft(find.byKey(TypingPage.fieldKey)) + const Offset(40, 30));
    await tester.pump();
    final tapped = text.selection.baseOffset;
    expect(v.mic.running, isFalse);
    v.link.reply(reply(done: [tokens[3], tokens[4]], finished: true));
    await tester.pumpAndSettle();
    expect(text.text, tokens.take(5).join());
    expect(text.selection.baseOffset, tapped + text.text.length - shown);
  });

  testWidgets('a tap in the text before the words keeps its place', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    final typed = dreams[1];
    await tester.enterText(find.byKey(TypingPage.fieldKey), typed);
    final text = fieldText(tester);
    text.selection = TextSelection.collapsed(offset: typed.length);
    await record(tester);
    v.link.reply(reply(done: [tokens[0], tokens[1]]));
    await tester.pump();
    await tester.tapAt(tester.getTopLeft(find.byKey(TypingPage.fieldKey)) + const Offset(40, 30));
    await tester.pump();
    final tapped = text.selection.baseOffset;
    expect(tapped, lessThan(typed.length));
    v.link.reply(reply(done: [tokens[2]], finished: true));
    await tester.pumpAndSettle();
    expect(text.text, '$typed ${tokens.take(3).join()}');
    expect(text.selection.baseOffset, tapped);
  });

  // The owner's check 1: backspace while newer guesses keep coming.
  testWidgets('backspace while guesses keep coming: no stale piece', (tester) async {
    final r = await dictatingInto(tester);
    r.link.reply(reply(done: [tokens[0]], shown: [tokens[1], tokens[2]]));
    await tester.pump();
    await keyboard(tester, r.text.text.substring(0, r.text.text.length - 1));
    r.link.reply(reply(shown: [tokens[1], tokens[2], tokens[3]]));
    await tester.pump();
    expect(r.text.text, tokens.take(4).join());
    r.link.reply(reply(done: [tokens[1], tokens[2], tokens[3]], finished: true));
    await tester.pumpAndSettle();
    expect(r.text.text, tokens.take(4).join());
  });

  testWidgets('plain dictation: one piece, never a stale one', (tester) async {
    final v = voice();
    await tall(tester, recording: v.recording);
    await record(tester);
    final text = fieldText(tester);
    for (var n = 1; n <= 5; n++) {
      v.link.reply(reply(shown: tokens.take(n).toList()));
      await tester.pump();
      expect(text.text, tokens.take(n).join().trimLeft());
    }
    v.link.reply(reply(done: tokens.take(3).toList(), shown: [tokens[3]]));
    await tester.pump();
    v.link.reply(reply(shown: [tokens[3], tokens[4]]));
    await tester.pump();
    expect(text.text, tokens.take(5).join().trimLeft());
  });

  // D87 3: following follows the insertion point.
  bool insertionInView(WidgetTester tester) {
    final editable = tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;
    final rect = editable.getLocalRectForCaret(TextPosition(offset: fieldText(tester).selection.baseOffset));
    return rect.top >= -1 && rect.bottom <= editable.size.height + 1;
  }

  testWidgets('dictation into a long text follows the insertion point', (tester) async {
    final v = voice();
    final long = List.filled(8, tokens.join()).join(' ');
    await tall(tester, recording: v.recording, edit: (id: 'n', index: 0, text: long));
    fieldText(tester).selection = const TextSelection.collapsed(offset: 4);
    await tester.pump();
    await record(tester);
    for (var i = 0; i < 6; i++) {
      await hear(tester, v.link, tokens);
      expect(insertionInView(tester), isTrue);
    }
    final scroll = fieldScroll(tester);
    expect(scroll.pixels, greaterThan(0));
    expect(scroll.pixels, lessThan(scroll.maxScrollExtent));
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
  // Offline recording (D92 to D94; D93 Q2, Q4, Q5, Q7), on a keep in memory.
  ({SilentMicrophone mic, MemoryLink link, MemoryKeep keep, FakeConnection connection, Recording recording}) offline({
    bool online = false,
  }) {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final keep = MemoryKeep();
    final connection = FakeConnection()..online = online;
    return (
      mic: mic,
      link: link,
      keep: keep,
      connection: connection,
      recording: Recording(
        on: true,
        microphone: mic,
        key: () async => 'k',
        connect: (_) async => link,
        keep: keep,
        connection: connection,
      ),
    );
  }

  Future<void> frames(WidgetTester tester, SilentMicrophone mic, int n) async {
    for (var i = 0; i < n; i++) {
      mic.frame(i + 1);
    }
    await tester.pump();
  }

  testWidgets('no connection: MP·15, no MP·33, and Save keeps it waiting', (tester) async {
    final v = offline();
    final h = await tall(tester, recording: v.recording);
    tester.takeAnnouncements();
    await record(tester);
    expect(tester.takeAnnouncements(), isEmpty);
    expect(find.byKey(TypingPage.levelKey), findsOneWidget);
    expect(find.bySemanticsLabel(Lines.MP_15.text(Lang.en)), findsOneWidget);
    await frames(tester, v.mic, 4);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    final id = v.keep.audio.keys.single;
    expect((await h.nights()).single.entries, [Waiting(id)]);
    expect(v.keep.audio[id], hasLength(12800));
  });

  testWidgets('a break shows MP·54; final words stay, the rest waits after', (tester) async {
    final lines = await logged();
    final v = offline(online: true);
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    await frames(tester, v.mic, 3);
    v.link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 100));
    await tester.pump();
    expect(find.text(tokens[0] + tokens[1]), findsOneWidget);
    await v.link.drop(1011);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(Lines.MP_54.text(Lang.en)), findsOneWidget);
    expect(v.mic.running, isTrue);
    final field = tester.widget<TextField>(find.byKey(TypingPage.fieldKey));
    expect(field.controller!.text, tokens[0].trimLeft());
    await frames(tester, v.mic, 2);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    final id = v.keep.audio.keys.single;
    expect((await h.nights()).single.entries, [Told(tokens[0].trimLeft()), Waiting(id, 3200)]);
    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
  });

  testWidgets('MP·54 goes at the next tap of the microphone', (tester) async {
    final links = <MemoryLink>[];
    final recording = Recording(
      on: true,
      microphone: SilentMicrophone(),
      key: () async => 'k',
      connect: (_) async => MemoryLink().._keep(links),
      keep: MemoryKeep(),
    );
    await tall(tester, recording: recording);
    await record(tester);
    await links.single.drop(1011);
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.noticeKey), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.micKey));
    await tester.pumpAndSettle();
    await record(tester);
    expect(find.byKey(TypingPage.noticeKey), findsNothing);
  });

  testWidgets('leaving with only a recording waiting keeps the night', (tester) async {
    final v = offline();
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    await frames(tester, v.mic, 2);
    await leave(tester, AppLifecycleState.hidden);
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.nights()).single.entries, [Waiting(v.keep.audio.keys.single)]);
  });

  testWidgets('two recordings waiting go after the words, in order', (tester) async {
    final v = offline();
    final h = await tall(tester, recording: v.recording);
    await tester.enterText(find.byKey(TypingPage.fieldKey), dreams[0]);
    for (var i = 0; i < 2; i++) {
      await record(tester);
      await frames(tester, v.mic, 1);
      await tester.tap(find.byKey(TypingPage.micKey));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    final [a, b] = v.keep.audio.keys.toList();
    expect((await h.nights()).single.entries, [Told(dreams[0]), Waiting(a), Waiting(b)]);
  });

  testWidgets('an edit with a recording waiting puts it after the dream', (tester) async {
    final v = offline();
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 8));
    await h.pump(
      tester,
      Opener(
        () async => TypingPage(
          journal: h.journal,
          target: IntoNight(n.id),
          edit: (id: n.id, index: 0, text: n.dreams[0]),
          recording: v.recording,
        ),
      ),
    );
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    await record(tester);
    await frames(tester, v.mic, 1);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    final id = v.keep.audio.keys.single;
    expect((await h.journal.night(n.id))!.entries, [Told(n.dreams[0]), Waiting(id), Told(n.dreams[1])]);
  });

  testWidgets('every word final: nothing waits, the audio is deleted', (tester) async {
    final v = offline(online: true);
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    await frames(tester, v.mic, 2);
    v.link.reply(reply(done: [tokens[0]], finalMs: 200));
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pump();
    v.link.reply(reply(finished: true));
    await tester.pumpAndSettle();
    expect((await h.nights()).single.entries, [Told(tokens[0].trimLeft())]);
    expect(v.keep.discarded, hasLength(1));
    expect(find.byKey(TypingPage.noticeKey), findsNothing);
  });

  // D94: no retry while a typing screen is open; its closing starts one.
  testWidgets('the typing screen holds the retries while it is open', (tester) async {
    final none = NoneWaiting();
    final recording = offline(online: true).recording.keeping(MemoryKeep(), waiting: none);
    await tall(tester, recording: recording);
    recording.retries!.kick();
    await tester.pump();
    expect(none.looks, 0);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(none.looks, 1);
  });

  testWidgets('a failed Save keeps the waiting recording for the next', (tester) async {
    final v = offline();
    final files = FlakyFiles();
    final h = await tall(tester, recording: v.recording, files: files);
    await record(tester);
    await frames(tester, v.mic, 1);
    files.failures = 1;
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.nights()).single.entries, [Waiting(v.keep.audio.keys.single)]);
  });

  // D96 Q1: a keep that fails once the recording is cut stops it, and the
  // notice that the audio stays on the phone goes.
  testWidgets('keep fails offline: recording stops, the notice goes', (tester) async {
    final lines = await logged();
    final v = offline();
    v.keep.fails = true;
    final h = await tall(tester, recording: v.recording);
    await record(tester);
    expect(find.bySemanticsLabel(Lines.MP_15.text(Lang.en)), findsOneWidget);
    await frames(tester, v.mic, 11);
    await tester.pumpAndSettle();
    expect(find.byKey(TypingPage.noticeKey), findsNothing);
    expect(find.byKey(TypingPage.levelKey), findsNothing);
    expect(v.mic.running, isFalse);
    expect(lines, ['recordingStarted', 'recordingOffline', 'audioKeepFailed', 'recordingEnded']);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(await h.nights(), isEmpty);
  });

  Future<({Harness h, Night n})> editingWith(WidgetTester tester, Recording? recording) async {
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 8));
    await h.pump(
      tester,
      Opener(
        () async => TypingPage(
          journal: h.journal,
          target: IntoNight(n.id),
          edit: (id: n.id, index: 0, text: n.dreams[0]),
          recording: recording,
        ),
      ),
    );
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    return (h: h, n: n);
  }

  // D96 Q2: leaving the app never removes a dream; only a Save does.
  testWidgets('leaving with emptied edit and recording keeps old words', (tester) async {
    final v = offline();
    final e = await editingWith(tester, v.recording);
    await tester.enterText(find.byKey(TypingPage.fieldKey), '');
    await record(tester);
    await frames(tester, v.mic, 1);
    await leave(tester, AppLifecycleState.hidden);
    expect(find.byType(TypingPage), findsNothing);
    final id = v.keep.audio.keys.single;
    expect((await e.h.journal.night(e.n.id))!.entries, [Told(e.n.dreams[0]), Waiting(id), Told(e.n.dreams[1])]);
  });

  testWidgets('Save with emptied edit and recording removes the dream', (tester) async {
    final v = offline();
    final e = await editingWith(tester, v.recording);
    await tester.enterText(find.byKey(TypingPage.fieldKey), '');
    await record(tester);
    await frames(tester, v.mic, 1);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    final id = v.keep.audio.keys.single;
    expect((await e.h.journal.night(e.n.id))!.entries, [Waiting(id), Told(e.n.dreams[1])]);
  });

  // D96 Q3: a Save that cannot land is a failed Save: MP·62, the screen, the
  // words and the recordings kept.
  testWidgets('Save into a vanished night fails: MP·62, words stay', (tester) async {
    final lines = await logged();
    final e = await editingWith(tester, null);
    await e.h.journal.delete(e.n.id);
    final other = invented('one-dream-sv').dreams[0];
    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    expect(find.text(other), findsOneWidget);
    expect(find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en)), findsOneWidget);
    expect(lines, ['journalSaveFailed']);
  });

  testWidgets('Save into a vanished night keeps the recording, MP·62', (tester) async {
    final lines = await logged();
    final v = offline();
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 8));
    await h.pump(
      tester,
      Opener(() async => TypingPage(journal: h.journal, target: IntoNight(n.id), recording: v.recording)),
    );
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    await record(tester);
    await frames(tester, v.mic, 1);
    await h.journal.delete(n.id);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    expect(find.bySemanticsLabel(PendingLines.MP_62.text(Lang.en)), findsOneWidget);
    expect(lines, ['recordingStarted', 'recordingOffline', 'recordingEnded', 'journalSaveFailed']);
  });

  testWidgets('empty Save into a vanished night keeps nothing, closes', (tester) async {
    final lines = await logged();
    final h = await Harness.make();
    final n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 10, 8));
    await h.pump(tester, Opener(() async => TypingPage(journal: h.journal, target: IntoNight(n.id))));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    await h.journal.delete(n.id);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect(lines, isEmpty);
  });
}

extension on MemoryLink {
  void _keep(List<MemoryLink> links) => links.add(this);
}
