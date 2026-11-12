// A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8): header, "Dreams",
// the dreams; editing through the typing screen; Add dreams; the menu
// holding only delete, spoken as MP·39; one confirmation, Cancel first,
// Delete destructive; deleting leaves nothing.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/words/lines.g.dart';
import 'package:souldreams/words/pending.g.dart';

import '../../fixtures.dart';
import '../memory_journal_files.dart';
import '../zones.dart';
import 'harness.dart';

/// A folder that can fail a delete or a read, or hold a delete open.
final class UnsteadyFiles extends MemoryJournalFiles {
  bool failDeletes = false;
  Completer<void>? holdDeletes;
  bool failReads = false;
  int readsOk = 0;

  @override
  Future<void> delete(String name) async {
    await holdDeletes?.future;
    if (failDeletes) throw const FormatException('delete');
    return super.delete(name);
  }

  @override
  Future<Uint8List?> read(String name) async {
    if (failReads) {
      if (readsOk > 0) {
        readsOk--;
      } else {
        throw const FormatException('read');
      }
    }
    return super.read(name);
  }
}

void main() {
  late Harness h;
  late Night n;

  Future<void> open(WidgetTester tester, {UnsteadyFiles? files, String? name}) async {
    h = await Harness.make(files: files);
    n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    if (name != null) {
      // An invented name, added here and not in the fixture (D64).
      n = Night(
        id: n.id,
        firstRecorded: n.firstRecorded,
        date: n.date,
        closes: n.closes,
        lang: n.lang,
        name: name,
        dreams: n.dreams,
      );
      await h.store.save(n);
    }
    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id)));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byKey(NightPage.menuKey));
    await tester.pumpAndSettle();
  }

  testWidgets('the header, the label "Dreams", the dreams in order', (tester) async {
    await open(tester);
    expect(find.text(dayDigits(n.date)), findsOneWidget);
    expect(find.text(Lines.MP_38.text(Lang.en)), findsOneWidget);
    final first = tester.getTopLeft(find.text(n.dreams[0]));
    final second = tester.getTopLeft(find.text(n.dreams[1]));
    expect(first.dy, lessThan(second.dy));
    expect(find.text(Lines.MP_29.text(Lang.en)), findsOneWidget);
  });

  testWidgets('"Dreams" is heard as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester);
    expect(tester.getSemantics(find.text(Lines.MP_38.text(Lang.en))).flagsCollection.isHeader, isTrue);
    handle.dispose();
  });

  testWidgets('tapping a dream opens it filled; Save replaces it', (tester) async {
    await open(tester);
    await tester.tap(find.text(n.dreams[1]));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsOneWidget);
    final other = invented('one-dream-sv').dreams.single;
    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text(other), findsOneWidget);
    expect((await h.journal.night(n.id))!.dreams, [n.dreams[0], other]);
  });

  testWidgets('an emptied dream disappears; the others remain', (tester) async {
    await open(tester);
    await tester.tap(find.text(n.dreams[0]));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(TypingPage.fieldKey), '  ');
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsOneWidget);
    expect(find.text(n.dreams[0]), findsNothing);
    expect((await h.journal.night(n.id))!.dreams, [n.dreams[1]]);
  });

  testWidgets('a night emptied of every dream leaves, deleted', (tester) async {
    await open(tester);
    for (final d in n.dreams) {
      await tester.tap(find.text(d));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(TypingPage.fieldKey), '');
      await tester.tap(find.byKey(TypingPage.saveKey));
      await tester.pumpAndSettle();
    }
    expect(find.byType(NightPage), findsNothing);
    expect(await h.nights(), isEmpty);
    expect(h.files.files.keys.where((k) => k.contains(n.id)), isEmpty);
  });

  testWidgets('Add dreams adds to this night, even after its 21:00', (tester) async {
    await open(tester);
    Harness.clock = stockholm(2026, 6, 9, 12);
    await tester.tap(find.byKey(NightPage.addKey));
    await tester.pumpAndSettle();
    final added = invented('one-dream-sv').dreams.single;
    await tester.enterText(find.byKey(TypingPage.fieldKey), added);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.journal.night(n.id))!.dreams, [...n.dreams, added]);
    expect(await h.nights(), hasLength(1));
  });

  testWidgets('the menu: spoken as MP·39, holding only delete, plain', (tester) async {
    await open(tester);
    expect(find.byTooltip(Lines.MP_39.text(Lang.en)), findsOneWidget);
    await openMenu(tester);
    expect(find.byType(PopupMenuItem<int>), findsOneWidget);
    expect(find.text(Lines.EM_11.parts(Lang.en)[1]), findsOneWidget);
    expect(find.text(Lines.MP_28.text(Lang.en)), findsNothing);
  });

  testWidgets('one confirmation: Cancel first keeps the night', (tester) async {
    await open(tester);
    await openMenu(tester);
    await tester.tap(find.byKey(NightPage.deleteKey));
    await tester.pumpAndSettle();
    expect(find.text(Lines.C4_P_4.text(Lang.en)), findsOneWidget);
    final actions = tester.widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction)).toList();
    expect(actions, hasLength(2));
    expect(actions[0].isDestructiveAction, isFalse);
    expect(actions[1].isDestructiveAction, isTrue);
    expect((actions[0].child as Text).data, PendingLines.MP_61.text(Lang.en));
    expect((actions[1].child as Text).data, PendingLines.MP_60.text(Lang.en));
    await tester.tap(find.byWidget(actions[0]));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsOneWidget);
    expect(await h.nights(), hasLength(1));
  });

  testWidgets('Delete removes the night, leaving nothing, and goes back', (tester) async {
    await open(tester);
    await openMenu(tester);
    await tester.tap(find.byKey(NightPage.deleteKey));
    await tester.pumpAndSettle();
    final delete = tester.widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction)).last;
    await tester.tap(find.byWidget(delete));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsNothing);
    expect(await h.nights(), isEmpty);
    expect(h.files.files.keys.where((k) => k.contains(n.id)), isEmpty);
  });

  testWidgets('pending lines are placeholders outside Dev, words in Dev', (tester) async {
    expect(PendingLines.MP_60.text(Lang.en), '[MP·60]');
    expect(PendingLines.MP_60.text(Lang.en, flavor: 'tester'), '[MP·60]');
    expect(PendingLines.MP_60.text(Lang.en, flavor: 'founder'), '[MP·60]');
    expect(PendingLines.MP_60.text(Lang.en, flavor: 'dev'), isNot('[MP·60]'));
    expect(PendingLines.MP_61.text(Lang.sv, flavor: 'dev'), isNot(PendingLines.MP_61.text(Lang.en, flavor: 'dev')));
  });

  testWidgets('text at twice the size does not overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester);
    expect(tester.takeException(), isNull);
  });

  // D64 (the review of Task 10): failures, a delete in flight, semantics.
  Future<List<String>> logged() async {
    final lines = <String>[];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
    return lines;
  }

  Future<void> confirmDelete(WidgetTester tester) async {
    await openMenu(tester);
    await tester.tap(find.byKey(NightPage.deleteKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byWidget(tester.widgetList<CupertinoDialogAction>(find.byType(CupertinoDialogAction)).last));
    await tester.pumpAndSettle();
  }

  testWidgets('a failed delete keeps the page and night, logs a code', (tester) async {
    final lines = await logged();
    final files = UnsteadyFiles();
    await open(tester, files: files);
    files.failDeletes = true;
    await confirmDelete(tester);
    expect(tester.takeException(), isNull);
    expect(lines, ['journalDeleteFailed']);
    expect(find.byType(NightPage), findsOneWidget);
    expect(find.text(n.dreams[0]), findsOneWidget);
    expect(await h.nights(), hasLength(1));
    files.failDeletes = false;
    await confirmDelete(tester);
    expect(find.byType(NightPage), findsNothing);
    expect(await h.nights(), isEmpty);
  });

  testWidgets('a failed read after typing keeps the page, logs a code', (tester) async {
    final lines = await logged();
    final files = UnsteadyFiles();
    await open(tester, files: files);
    files.failReads = true;
    files.readsOk = 1;
    await tester.tap(find.text(n.dreams[0]));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BackControl.buttonKey));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(lines, ['journalReadFailed']);
    expect(find.byType(NightPage), findsOneWidget);
    expect(find.byType(TypingPage), findsNothing);
  });

  testWidgets('the menu, Add and a dream wait while a delete runs', (tester) async {
    final files = UnsteadyFiles();
    await open(tester, files: files);
    files.holdDeletes = Completer<void>();
    await confirmDelete(tester);
    await tester.tap(find.byKey(NightPage.menuKey), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(PopupMenuItem<int>), findsNothing);
    await tester.tap(find.byKey(NightPage.addKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text(n.dreams[0]));
    await tester.pumpAndSettle();
    expect(find.byType(TypingPage), findsNothing);
    expect(find.byType(NightPage), findsOneWidget);
    files.holdDeletes!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsNothing);
    expect(await h.nights(), isEmpty);
  });

  testWidgets('a dream is heard as a button', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester);
    for (final d in n.dreams) {
      expect(tester.getSemantics(find.text(d)).flagsCollection.isButton, isTrue, reason: d);
    }
    handle.dispose();
  });

  testWidgets('the date is heard as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester);
    expect(tester.getSemantics(find.text(dayDigits(n.date))).flagsCollection.isHeader, isTrue);
    handle.dispose();
  });

  testWidgets('a named night shows name over date, as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester, name: 'Night by the harbour');
    expect(find.text('Night by the harbour'), findsOneWidget);
    expect(find.text(dayDigits(n.date)), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Night by the harbour')).dy,
      lessThan(tester.getTopLeft(find.text(dayDigits(n.date))).dy),
    );
    expect(tester.getSemantics(find.text('Night by the harbour')).flagsCollection.isHeader, isTrue);
    handle.dispose();
  });

  testWidgets('text at twice the size, menu open: no overflow, delete reachable', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester);
    await openMenu(tester);
    expect(tester.takeException(), isNull);
    expect(find.byKey(NightPage.deleteKey).hitTestable(), findsOneWidget);
  });

  testWidgets('text at twice the size, dialog open: no overflow, both reachable', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester);
    await openMenu(tester);
    await tester.tap(find.byKey(NightPage.deleteKey));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final actions = find.byType(CupertinoDialogAction);
    expect(actions, findsNWidgets(2));
    expect(actions.first.hitTestable(), findsOneWidget);
    expect(actions.last.hitTestable(), findsOneWidget);
  });
}
