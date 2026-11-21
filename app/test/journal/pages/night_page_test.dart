// A night's page (P1, P6, P7; D58 Q1, Q3, Q4, Q8; head's message 20,
// items 10 to 12; D110): the header, its picture and date, the back control
// and the menu over it; on a read night, the jump buttons; "Dreams", the
// dreams; editing through the
// typing screen; Add dreams and Start Interpretation at the foot; the menu,
// a bordered pill opening the phone's menu, holding delete, spoken as
// MP·39, and above it the item an entry point gives (D107 item 1); one confirmation, Cancel first, Delete destructive; deleting
// leaves nothing.
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/app_line.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/design/stand_ins.dart';
import 'package:souldreams/design/tokens.g.dart';
import 'package:souldreams/journal/journal_audio.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_action.dart';
import 'package:souldreams/journal/night_look.dart';
import 'package:souldreams/journal/pages/night_art.dart';
import 'package:souldreams/journal/pages/night_page.dart';
import 'package:souldreams/journal/pages/parts.dart';
import 'package:souldreams/journal/pages/typing_page.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/recording/recording.dart';
import 'package:souldreams/words/lines.g.dart';

import '../../fixtures.dart';
import '../../recording/fakes.dart';
import '../memory_journal_files.dart';
import '../zones.dart';
import 'harness.dart';
import '../../core/status_bar_recorder.dart';

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

/// A phone's screen, 390 by 844 (D110: the header takes 240 of it).
void phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  late Harness h;
  late Night n;

  Future<void> open(
    WidgetTester tester, {
    UnsteadyFiles? files,
    String? name,
    NightAction? action,
    ReadCheck read = noneRead,
    String key = 'two-dreams-en',
    bool wide = false,
    int hour = 12,
    bool unread = false,
  }) async {
    // The test's own 800 by 600, where the foot's two buttons do not fill
    // the row, or a phone.
    if (!wide) phone(tester);
    h = await Harness.make(files: files);
    n = await keep(h, key, stockholm(2026, 6, 2, 23));
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
    // A first read that fails leaves the page blank, with no picture.
    if (unread) files!.failReads = true;
    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, action: action, read: read)),
        hour: hour);
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byKey(NightPage.menuKey));
    await tester.pumpAndSettle();
  }

  testWidgets('the header, the label "Dreams", the dreams in order', (tester) async {
    await open(tester);
    expect(find.text(shownDate(n.date)), findsOneWidget);
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
    // C18-P's larger voices push the second dream below the test's view.
    await tester.ensureVisible(find.text(n.dreams[1]));
    await tester.pumpAndSettle();
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

  // D93 Q3: a waiting recording shows nothing and cannot be tapped; the
  // told dreams around it keep their places.
  testWidgets('a waiting recording shows nothing; edits keep the order', (tester) async {
    await open(tester);
    final w1 = Waiting('1' * 32);
    final w2 = Waiting('2' * 32);
    await h.store.save(n.withEntries([w1, Told(n.dreams[0]), w2, Told(n.dreams[1])]));
    await tester.tap(find.byType(BackControl));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    expect(find.byType(DreamBubble), findsNWidgets(2));
    expect(tester.getTopLeft(find.text(n.dreams[0])).dy, lessThan(tester.getTopLeft(find.text(n.dreams[1])).dy));
    await tester.ensureVisible(find.text(n.dreams[1]));
    await tester.pumpAndSettle();
    await tester.tap(find.text(n.dreams[1]));
    await tester.pumpAndSettle();
    final other = invented('one-dream-sv').dreams.single;
    await tester.enterText(find.byKey(TypingPage.fieldKey), other);
    await tester.tap(find.byKey(TypingPage.saveKey));
    await tester.pumpAndSettle();
    expect((await h.journal.night(n.id))!.entries, [w1, Told(n.dreams[0]), w2, Told(other)]);
  });

  // D93 Q3: while a waiting recording is turned into words, AI·6 shows in
  // its place, heard by a screen reader; then its words, as its own dream.
  testWidgets('AI·6 shows in its place while it is transcribed', (tester) async {
    phone(tester);
    h = await Harness.make();
    n = await keep(h, 'two-dreams-en', stockholm(2026, 6, 2, 23));
    final x = '1' * 32;
    await h.store.save(n.withEntries([Told(n.dreams[0]), Waiting(x), Told(n.dreams[1])]));
    await h.store.appendAudio(x, Uint8List(6400));
    final links = <MemoryLink>[];
    final audio = JournalAudio(h.store);
    final recording = Recording(
      on: true,
      microphone: SilentMicrophone(),
      key: () async => 'k',
      connect: (_) async {
        final link = MemoryLink();
        links.add(link);
        return link;
      },
    ).keeping(audio, waiting: audio);
    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, recording: recording)));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    expect(find.byKey(NightPage.transcribingKey), findsNothing);
    recording.retries!.kick();
    await tester.pump();
    await tester.pump();
    final label = find.byKey(NightPage.transcribingKey);
    expect(label, findsOneWidget);
    expect(tester.widget<Semantics>(label).properties.liveRegion, isTrue);
    final line = tester.widget<AppLine>(find.descendant(of: label, matching: find.byType(AppLine)));
    expect(line.text, Lines.AI_6.text(Lang.en));
    expect(tester.getTopLeft(label).dy, greaterThan(tester.getTopLeft(find.text(n.dreams[0])).dy));
    expect(tester.getTopLeft(label).dy, lessThan(tester.getTopLeft(find.text(n.dreams[1])).dy));
    await tester.pump(const Duration(milliseconds: 300));
    final word = n.dreams[1].split(' ').first;
    links.single.reply(reply(done: [word], finished: true));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byKey(NightPage.transcribingKey), findsNothing);
    expect(find.byType(DreamBubble), findsNWidgets(3));
    expect((await h.journal.night(n.id))!.entries, [Told(n.dreams[0]), Told(word), Told(n.dreams[1])]);
    await tester.pump(const Duration(seconds: 11));
  });

  // D96: the page leaves by its own route. A night that goes while the delete
  // question is open (its only recording heard as silence) must not close the
  // question in the page's place.
  testWidgets('night gone under a question: page leaves, question stays', (tester) async {
    h = await Harness.make();
    n = await keep(h, 'one-dream-sv', stockholm(2026, 6, 2, 23));
    final x = '1' * 32;
    await h.store.save(n.withEntries([Waiting(x)]));
    await h.store.appendAudio(x, Uint8List(3200));
    final links = <MemoryLink>[];
    final audio = JournalAudio(h.store);
    final recording = Recording(
      on: true,
      microphone: SilentMicrophone(),
      key: () async => 'k',
      connect: (_) async {
        final link = MemoryLink();
        links.add(link);
        return link;
      },
    ).keeping(audio, waiting: audio);
    await h.pump(tester, Opener(() async => NightPage(journal: h.journal, id: n.id, recording: recording)));
    await tester.tap(find.byKey(Opener.openKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(NightPage.menuKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(NightPage.deleteKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    recording.retries!.kick();
    await tester.pump();
    await tester.pump();
    expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    links.single.reply(reply(finalMs: 100, finished: true));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(NightPage), findsNothing);
    expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    expect(await h.store.nights(), isEmpty);
    await tester.pump(const Duration(seconds: 11));
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
    final handle = tester.ensureSemantics();
    await open(tester);
    expect(find.byTooltip(Lines.MP_39.text(Lang.en)), findsOneWidget);
    final spoken = tester.getSemantics(find.byTooltip(Lines.MP_39.text(Lang.en)));
    expect(spoken.tooltip, Lines.MP_39.text(Lang.en));
    expect(spoken.flagsCollection.isButton, isTrue);
    await openMenu(tester);
    final items = tester.widgetList<CupertinoMenuItem>(find.byType(CupertinoMenuItem));
    expect(items, hasLength(1));
    expect(items.single.isDestructiveAction, isFalse);
    expect(find.text(Lines.EM_11.parts(Lang.en)[1]), findsOneWidget);
    handle.dispose();
  });

  // D107 item 1: the entry point's item, above delete, plain, its words given.
  NightAction given(List<Night> ran) =>
      NightAction(label: Lines.MP_65.text(Lang.en), run: (night) async => ran.add(night));

  testWidgets('a given item shows above delete, plain', (tester) async {
    await open(tester, action: given([]));
    await openMenu(tester);
    final items = tester.widgetList<CupertinoMenuItem>(find.byType(CupertinoMenuItem)).toList();
    expect([for (final i in items) i.key], [NightPage.actionKey, NightPage.deleteKey]);
    expect(items.first.isDestructiveAction, isFalse);
    expect(find.text(Lines.MP_65.text(Lang.en)), findsOneWidget);
  });

  testWidgets('a given item runs once, with the night shown', (tester) async {
    final ran = <Night>[];
    await open(tester, action: given(ran));
    await openMenu(tester);
    await tester.tap(find.byKey(NightPage.actionKey));
    await tester.pumpAndSettle();
    expect(ran, [n]);
    expect(find.byType(NightPage), findsOneWidget);
    expect(await h.nights(), [n]);
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
    expect((actions[0].child as Text).data, Lines.MP_61.text(Lang.en));
    expect((actions[1].child as Text).data, Lines.MP_60.text(Lang.en));
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

  // C17-P filed MP·60 and MP·61: words in every build, no longer pending.
  testWidgets('the confirmation\'s two choices are filed lines', (tester) async {
    for (final line in [Lines.MP_60, Lines.MP_61]) {
      expect(line.written, isTrue, reason: line.handle);
      expect(line.text(Lang.en), isNot('[${line.handle}]'));
      expect(line.text(Lang.sv), isNot(line.text(Lang.en)));
    }
  });

  testWidgets('text at twice the size does not overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a read night, text at twice the size: no overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(tester, read: (_) => true);
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
    expect(find.byType(CupertinoMenuItem), findsNothing);
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

  // D110: the header, the screen's width from its top, an unread night's
  // painted gradient; the date centred over its foot in h2.
  testWidgets("the header: the date centred over an unread night's gradient", (tester) async {
    await open(tester);
    final date = find.text(shownDate(n.date));
    expect(tester.widget<Text>(date).textAlign, TextAlign.center);
    final width = tester.getSize(find.byType(NightPage)).width;
    expect(tester.getCenter(date).dx, closeTo(width / 2, 1));
    final style = tester.widget<Text>(date).style!;
    expect(style.color, NightArt.over);
    expect(style.fontFamily, TypeRoles.h2.family);
    final art = find.byType(NightArt);
    expect(tester.widget<NightArt>(art).look, const PaintedGradient());
    final box = tester.getRect(art);
    expect(box, Rect.fromLTWH(0, 0, width, StandIns.headerHeight));
    expect(box.bottom - tester.getRect(date).bottom, closeTo(Spacing.nightHeader.bottom, 1));
    expect(tester.getTopLeft(find.text(Lines.MP_38.text(Lang.en))).dy, greaterThan(box.bottom));
  });

  // D110: naming is removed; a name kept from before is not shown.
  testWidgets('a named night shows only its date', (tester) async {
    await open(tester, name: 'Night by the harbour');
    expect(find.text('Night by the harbour'), findsNothing);
    expect(find.text(shownDate(n.date)), findsOneWidget);
  });

  testWidgets('an unread night has no jump buttons', (tester) async {
    await open(tester);
    // By key: MP·77's "Dreams" is MP·38's word too, which stands.
    for (final o in Jump.values) {
      expect(find.byKey(NightPage.jumpKey(o)), findsNothing);
    }
    expect(find.text(Lines.MP_77.parts(Lang.en)[1]), findsNothing);
  });

  // C18-P (D119 item 4): the jump buttons' words are MP·77's four parts, in
  // order, each on its own button.
  testWidgets("the jump buttons' words: MP·77, in order", (tester) async {
    await open(tester, read: (_) => true);
    expect([for (final o in Jump.values) o.text(Lang.en)], Lines.MP_77.parts(Lang.en));
    expect([for (final o in Jump.values) o.text(Lang.sv)], Lines.MP_77.parts(Lang.sv));
    for (final o in Jump.values) {
      final words = find.descendant(of: find.byKey(NightPage.jumpKey(o)), matching: find.byType(Text));
      expect(tester.widget<Text>(words).data, Lines.MP_77.parts(Lang.en)[o.index]);
    }
  });

  // D110: a read night shows its painting, and the four jump buttons in
  // order, centred under the header, each heard as a button.
  testWidgets('a read night: its painting, then four jump buttons', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester, read: (_) => true);
    final art = tester.widget<NightArt>(find.byType(NightArt));
    expect(art.look, Painting(paintingFor(n.id, NightArt.paintings)));
    final header = tester.getRect(find.byType(NightArt));
    final jumps = Jump.values;
    final boxes = [for (final o in jumps) tester.getRect(find.byKey(NightPage.jumpKey(o)))];
    for (final (i, b) in boxes.indexed) {
      expect(b.top, greaterThan(header.bottom));
      expect(b.bottom, lessThan(tester.getTopLeft(find.byKey(NightPage.dreamsKey)).dy));
      expect(tester.getSemantics(find.byKey(NightPage.jumpKey(jumps[i]))), matchesSemantics(
        label: jumps[i].text(Lang.en), isButton: true, hasTapAction: true));
      if (i > 0) expect(b.left > boxes[i - 1].right || b.top > boxes[i - 1].bottom, isTrue);
    }
    // Each row of them centred.
    final width = tester.getSize(find.byType(NightPage)).width;
    for (final top in {for (final b in boxes) b.top}) {
      final row = boxes.where((b) => b.top == top);
      expect((row.first.left + row.last.right) / 2, closeTo(width / 2, 1));
    }
    handle.dispose();
  });

  // The jump buttons' gradients: the section label's green, a stand-in
  // brown, the tradition label's terracotta and the dream tag's blue.
  testWidgets('the jump buttons: green, brown, terracotta, blue', (tester) async {
    await open(tester, read: (_) => true);
    List<Color> colours(Jump o) {
      final box = tester.widget<DecoratedBox>(
        find.descendant(of: find.byKey(NightPage.jumpKey(o)), matching: find.byType(DecoratedBox)),
      );
      return ((box.decoration as BoxDecoration).gradient! as LinearGradient).colors;
    }

    expect(colours(Jump.dreams), [LightColours.labelSection.colour, LightColours.labelSection.colourEnd]);
    expect(colours(Jump.questions), StandIns.jumpQuestions);
    expect(colours(Jump.readings), [LightColours.labelTradition.colour, LightColours.labelTradition.colourEnd]);
    expect(colours(Jump.reflection), [LightColours.tagDream.colour, LightColours.tagDream.colourEnd]);
  });

  // The jump buttons stand at the top of the scrolling part, so they scroll
  // away with it; Dreams brings its label to the top of that part.
  testWidgets('the Dreams jump brings "Dreams" to the top', (tester) async {
    await open(tester, read: (_) => true, key: 'long-dream-en');
    final list = tester.getRect(find.byType(ListView));
    final jump = find.byKey(NightPage.jumpKey(Jump.dreams));
    expect(find.descendant(of: find.byType(ListView), matching: jump), findsOneWidget);
    final label = find.descendant(of: find.byKey(NightPage.dreamsKey), matching: find.text(Lines.MP_38.text(Lang.en)));
    expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, greaterThan(list.top + 10));
    await tester.tap(jump);
    await tester.pump();
    await tester.pump(StandIns.jumpTime ~/ 2);
    expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, greaterThan(list.top));
    // It has arrived when the time is up, not before.
    await tester.pump(StandIns.jumpTime - StandIns.jumpTime ~/ 2);
    expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, closeTo(list.top, 1));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.byKey(NightPage.dreamsKey)).top, closeTo(list.top, 1));
    expect(label, findsOneWidget);
  });

  // D112: the "Dreams" label stands centred.
  testWidgets('the "Dreams" label is centred', (tester) async {
    await open(tester);
    final width = tester.getSize(find.byType(NightPage)).width;
    expect(tester.getCenter(find.text(Lines.MP_38.text(Lang.en))).dx, closeTo(width / 2, 1));
  });

  testWidgets('the three other jumps do nothing yet', (tester) async {
    await open(tester, read: (_) => true, key: 'long-dream-en');
    final at = tester.getRect(find.byKey(NightPage.dreamsKey));
    for (final o in [Jump.questions, Jump.readings, Jump.reflection]) {
      await tester.tap(find.byKey(NightPage.jumpKey(o)));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(NightPage.dreamsKey)), at);
      expect(find.byType(NightPage), findsOneWidget);
      expect(find.byType(TypingPage), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  // Item 10: the menu a bordered pill top right, on the page's margin.
  testWidgets('the menu: a bordered pill, top right', (tester) async {
    await open(tester);
    final menu = find.byKey(NightPage.menuKey);
    expect(tester.getSize(menu), const Size(StandIns.menuWidth, StandIns.backSize));
    final width = tester.getSize(find.byType(NightPage)).width;
    expect(tester.getTopRight(menu).dx, closeTo(width - Spacing.pageSide, 1));
    expect(tester.getCenter(menu).dy, closeTo(tester.getCenter(find.byKey(BackControl.buttonKey)).dy, 1));
    expect(tester.getTopLeft(find.byKey(BackControl.buttonKey)).dx, closeTo(Spacing.pageSide, 1));
    final look = tester.widget<DecoratedBox>(find.descendant(of: menu, matching: find.byType(DecoratedBox))).decoration
        as BoxDecoration;
    expect(look.border, Border.all(color: LightColours.button.border!));
    expect(look.borderRadius, BorderRadius.circular(StandIns.backSize / 2));
  });

  // D102 (1): a tap outside the open menu only closes it.
  testWidgets('a tap outside the open menu only closes it', (tester) async {
    await open(tester);
    for (final outside in [find.byKey(NightPage.addKey), find.text(n.dreams[0]), find.byKey(BackControl.buttonKey)]) {
      await openMenu(tester);
      expect(find.byType(CupertinoMenuItem), findsOneWidget);
      await tester.tap(outside, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoMenuItem), findsNothing);
      expect(find.byType(TypingPage), findsNothing);
      expect(find.byType(NightPage), findsOneWidget);
    }
  });

  // D102 (2): the pill and the back control look 41 and take a tap in a
  // box of 44 (Apple's minimum); the look and the layout are as reviewed.
  testWidgets('the back control and the pill take a tap in 44', (tester) async {
    await open(tester);
    final menu = tester.getTopLeft(find.byKey(NightPage.menuKey));
    await tester.tapAt(menu + const Offset(27, StandIns.hitMin - 1));
    await tester.pumpAndSettle();
    expect(find.byType(CupertinoMenuItem), findsOneWidget);
    await tester.tapAt(const Offset(2, 2));
    await tester.pumpAndSettle();
    final back = tester.getTopLeft(find.byKey(BackControl.buttonKey));
    await tester.tapAt(back + const Offset(StandIns.hitMin - 1, 20));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsNothing);
  });

  // D102 (2): the menu opens where it did, 8 below the 41 look, its right
  // edge on the pill's, not 3 lower with the tap box.
  testWidgets('the menu opens 8 below the look, on its right edge', (tester) async {
    await open(tester);
    final look = tester.getRect(find.byKey(NightPage.menuKey));
    await openMenu(tester);
    final item = tester.getRect(find.byType(CupertinoMenuItem));
    expect(item.top - look.bottom, closeTo(8, 0.5));
    expect(look.right - item.right, closeTo(0, 0.5));
  });

  // D113, D114: the light status-bar text is for the header alone. Flutter
  // leaves the last style in place when a frame has none, so the app holds
  // the style of its own theme under every page and the night page overrides
  // it while its picture shows.
  testWidgets("leaving a night gives back the app's own status bar", (tester) async {
    final calls = recordStatusBar(tester);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    // The phone's own setting plays no part: noon is the light theme, 22:00
    // the dark, whichever the phone says.
    for (final (hour, phone) in [
      (12, Brightness.light),
      (12, Brightness.dark),
      (22, Brightness.light),
      (22, Brightness.dark),
    ]) {
      tester.platformDispatcher.platformBrightnessTestValue = phone;
      await tester.pumpWidget(const SizedBox());
      await forceChange(tester, calls);
      await open(tester, hour: hour);
      expect(calls.last, 'Brightness.dark', reason: 'over the header, light text');
      await tester.tap(find.byKey(BackControl.buttonKey));
      await tester.pumpAndSettle();
      expect(find.byType(NightPage), findsNothing);
      // Over the light theme, dark text again (`light`); over the dark theme
      // it stays light text (`dark`).
      expect(calls.last, hour == 12 ? 'Brightness.light' : 'Brightness.dark', reason: 'hour $hour, phone $phone');
    }
  });

  // D113 (the review): the shade is behind the date, as wide as its words,
  // not a band across the header.
  testWidgets("the header's shade is as wide as the date", (tester) async {
    await open(tester, read: (_) => true);
    final shade = tester.getSize(find.byType(DateShade));
    final text = tester.getSize(find.text(shownDate(n.date)));
    expect(shade, text);
    // Not the page's whole content width, which a stretched date would have.
    expect(shade.width, lessThan(tester.getSize(find.byType(NightPage)).width - 2 * Spacing.pageSide));
  });

  // D113: a soft dark shade behind the date over a painting, none over the
  // painted gradient.
  testWidgets("a read header shades its date; an unread one does not", (tester) async {
    await open(tester, read: (_) => true);
    expect(find.descendant(of: find.byType(DateShade), matching: find.text(shownDate(n.date))), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await open(tester);
    expect(find.byType(DateShade), findsNothing);
  });

  // D113: over a night's header the status bar's time and battery are light,
  // in both themes; while the page is blank, they follow the theme.
  testWidgets('light status-bar text over the header, in both themes', (tester) async {
    for (final hour in [12, 22]) {
      await tester.pumpWidget(const SizedBox());
      await open(tester, hour: hour);
      final theme = Theme.of(tester.element(find.byType(NightPage))).brightness;
      expect(theme, hour == 12 ? Brightness.light : Brightness.dark);
      final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.descendant(of: find.byType(NightPage), matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>)));
      expect(region.value.statusBarBrightness, Brightness.dark);
      expect(region.value.statusBarIconBrightness, Brightness.light);
    }
  });

  testWidgets('while the page is blank, the status bar follows the theme', (tester) async {
    for (final hour in [12, 22]) {
      await tester.pumpWidget(const SizedBox());
      await open(tester, files: UnsteadyFiles(), hour: hour, unread: true);
      expect(find.byType(NightArt), findsNothing);
      final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.descendant(of: find.byType(NightPage), matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>)));
      expect(region.value.statusBarBrightness, hour == 12 ? Brightness.light : Brightness.dark);
    }
  });

  // D110: the picture runs from the screen's top and the header is 240 below
  // the status bar; the controls stand under it (the final review).
  testWidgets('the header and its controls clear the status bar', (tester) async {
    await open(tester);
    tester.view.padding = const FakeViewPadding(top: 141);
    tester.view.viewPadding = const FakeViewPadding(top: 141);
    await tester.pump();
    final art = tester.getRect(find.byType(NightArt));
    expect(art.top, 0);
    expect(art.height, 47 + StandIns.headerHeight);
    expect(tester.getTopLeft(find.byKey(BackControl.buttonKey)).dy, 47);
    expect(tester.getTopLeft(find.byKey(NightPage.menuKey)).dy, 47);
  });

  // D110: the back control and the pill stand over the header, at its top.
  testWidgets('the back control and the pill over the header', (tester) async {
    await open(tester);
    final back = find.byKey(BackControl.buttonKey);
    expect(tester.getSize(back), const Size(StandIns.backSize, StandIns.backSize));
    expect(tester.getSize(find.byKey(NightPage.menuKey)).height, StandIns.backSize);
    final top = tester.getTopLeft(back).dy;
    expect(top, 0);
    expect(tester.getTopLeft(find.byKey(NightPage.menuKey)).dy, top);
    expect(find.descendant(of: find.byType(NightArt), matching: back), findsOneWidget);
    expect(find.descendant(of: find.byType(NightArt), matching: find.byKey(NightPage.menuKey)), findsOneWidget);
    await tester.tapAt(tester.getTopLeft(back) + const Offset(20, StandIns.hitMin - 1));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsNothing);
  });

  // Item 11: the dreamer's bubbles 30 from the screen's left edge and 10
  // from its right (design-system.md §5).
  testWidgets("the bubbles: 30 from the left edge, 10 from the right", (tester) async {
    await open(tester);
    final width = tester.getSize(find.byType(NightPage)).width;
    for (final d in n.dreams) {
      final bubble = tester.getRect(find.ancestor(of: find.text(d), matching: find.byType(DecoratedBox)).first);
      expect(bubble.right, closeTo(width - Spacing.bubbleDreamer.right, 1), reason: d);
      expect(bubble.left, greaterThanOrEqualTo(Spacing.bubbleDreamer.left - 1), reason: d);
    }
  });

  // Item 10: at the foot, Add dreams on the left and Start Interpretation on
  // the right, which does nothing yet (P3, as D71 Q3).
  testWidgets('Add dreams bottom left, Start Interpretation bottom right', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester, wide: true);
    expect(tester.getSemantics(find.byKey(NightPage.startKey)).flagsCollection.isButton, isTrue);
    final size = tester.getSize(find.byType(NightPage));
    final add = tester.getRect(find.byKey(NightPage.addKey));
    final start = tester.getRect(find.byKey(NightPage.startKey));
    expect(find.text(Lines.EM_1.text(Lang.en)), findsOneWidget);
    expect(add.left, closeTo(Spacing.pageSide, 1));
    expect(start.right, closeTo(size.width - Spacing.pageSide, 1));
    expect(add.center.dy, closeTo(start.center.dy, 1));
    expect(add.bottom, closeTo(size.height - StandIns.gap, 1));
    await tester.tap(find.byKey(NightPage.startKey));
    await tester.pumpAndSettle();
    expect(find.byType(NightPage), findsOneWidget);
    expect(find.byType(TypingPage), findsNothing);
    expect((await h.journal.night(n.id))!.dreams, n.dreams);
    handle.dispose();
  });

  testWidgets('the date is heard as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    await open(tester);
    expect(tester.getSemantics(find.text(shownDate(n.date))).flagsCollection.isHeader, isTrue);
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
