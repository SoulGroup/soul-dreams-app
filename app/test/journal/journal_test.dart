// The journal's operations (D58): the first Save makes the night, an
// empty Save keeps nothing, a screen saves into the night it began in,
// an emptied dream disappears, and an emptied night is deleted.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night_rules.dart';
import 'package:souldreams/words/lines.g.dart' show Lang;

import '../fixtures.dart';
import 'io_journal_files.dart';
import 'zones.dart';

void main() {
  late Directory dir;
  late IoJournalFiles files;
  late DateTime clock;
  late Journal journal;
  final a = invented('two-dreams-en').dreams;
  final b = invented('one-dream-sv').dreams;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('journal-');
    files = IoJournalFiles(Directory('${dir.path}/Journal'));
    clock = stockholm(2026, 6, 10, 23);
    journal = Journal(await JournalStore.open(files),
        zone: const FakeStockholm(), now: () => clock, random: Random(3));
  });

  tearDown(() => dir.deleteSync(recursive: true));

  test('an empty Save keeps nothing', () async {
    for (final text in ['', '  \n ']) {
      expect(await journal.addDream(await journal.targetNow(), text, Lang.en), isFalse);
    }
    expect(files.everything(), isEmpty);
  });

  test('the first Save makes the night; later Saves add to it', () async {
    final opened = clock;
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    clock = stockholm(2026, 6, 11, 7);
    await journal.addDream(await journal.targetNow(), a[1], Lang.en);
    final [n] = await journal.newestFirst();
    expect(n.dreams, a);
    expect(n.firstRecorded, opened);
    expect(n.date, (year: 2026, month: 6, day: 10));
    expect(n.closes, stockholm(2026, 6, 11, 21));
    expect(n.lang, Lang.en);
  });

  test('after 21:00 a Save starts a new night', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    clock = stockholm(2026, 6, 11, 21);
    await journal.addDream(await journal.targetNow(), b[0], Lang.sv);
    final nights = await journal.newestFirst();
    expect([for (final n in nights) n.dreams], [b, [a[0]]]);
  });

  test('a screen open across 21:00 saves into its own night', () async {
    clock = stockholm(2026, 6, 11, 20, 58);
    final none = await journal.targetNow();
    clock = stockholm(2026, 6, 11, 21, 2);
    await journal.addDream(none, a[0], Lang.en);
    final [made] = await journal.newestFirst();
    expect(made.date, (year: 2026, month: 6, day: 11));
    expect(made.closes, stockholm(2026, 6, 11, 21));
    // Begun before 21:00 and saved after: the next screen starts fresh.
    expect(await journal.targetNow(), isA<NewNight>());

    final into = await journal.targetNow();
    clock = stockholm(2026, 6, 12, 0, 30);
    await journal.addDream(into, a[1], Lang.en);
    final open = (await journal.targetNow()) as IntoNight;
    clock = stockholm(2026, 6, 12, 21, 5);
    await journal.addDream(open, b[0], Lang.en);
    expect([for (final n in await journal.newestFirst()) n.dreams], [
      [a[1], b[0]],
      [a[0]],
    ]);
  });

  test('an edit replaces the dream; an emptied dream disappears', () async {
    for (final d in [...a, b[0]]) {
      await journal.addDream(await journal.targetNow(), d, Lang.en);
    }
    final id = (await journal.newestFirst()).single.id;
    await journal.editDream(id, 0, b[0]);
    expect((await journal.night(id))!.dreams, [b[0], a[1], b[0]]);
    await journal.editDream(id, 1, ' \n');
    expect((await journal.night(id))!.dreams, [b[0], b[0]]);
    expect(utf8.decode(files.everything().values.single).contains(jsonEncode(a[1])), isFalse);
  });

  test('a night whose every dream is emptied is deleted, nothing left', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    await journal.addDream(await journal.targetNow(), a[1], Lang.en);
    final id = (await journal.newestFirst()).single.id;
    await journal.editDream(id, 1, '');
    await journal.editDream(id, 0, '\t');
    expect(await journal.night(id), isNull);
    expect(files.everything(), isEmpty);
  });

  test('a Save into a night that is gone keeps nothing', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final t = await journal.targetNow();
    await journal.delete((t as IntoNight).id);
    expect(await journal.addDream(t, a[1], Lang.en), isFalse);
    expect(files.everything(), isEmpty);
  });

  // D61 (the review of Task 5): a read and the write that follows it are
  // one turn of the store's queue, so nothing falls between them.
  test('a delete queued behind a Save keeps the night deleted', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final t = await journal.targetNow() as IntoNight;
    final add = journal.addDream(t, a[1], Lang.en);
    final gone = journal.delete(t.id);
    await Future.wait([add, gone]);
    expect(files.everything(), isEmpty);
  });

  test('a delete queued right behind an edit keeps the night deleted', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final id = (await journal.newestFirst()).single.id;
    final edit = journal.editDream(id, 0, b[0]);
    final gone = journal.delete(id);
    await Future.wait([edit, gone]);
    expect(files.everything(), isEmpty);
  });

  test('two Saves at once into one night keep both dreams', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final t = await journal.targetNow();
    await Future.wait([journal.addDream(t, b[0], Lang.sv), journal.addDream(t, a[1], Lang.en)]);
    expect((await journal.newestFirst()).single.dreams, [a[0], b[0], a[1]]);
  });

  test('an edit and a Save at once keep both', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final t = await journal.targetNow() as IntoNight;
    await Future.wait([journal.editDream(t.id, 0, b[0]), journal.addDream(t, a[1], Lang.en)]);
    expect((await journal.night(t.id))!.dreams, [b[0], a[1]]);
  });

  test('an edit of a dream that is not there changes nothing', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    await journal.addDream(await journal.targetNow(), a[1], Lang.en);
    final id = (await journal.newestFirst()).single.id;
    final before = files.everything();
    for (final index in [-1, 2, 99]) {
      await journal.editDream(id, index, b[0]);
      await journal.editDream(id, index, '');
    }
    await journal.editDream('0' * 32, 0, b[0]);
    expect((await journal.night(id))!.dreams, a);
    final after = files.everything();
    expect(after.keys, before.keys);
    for (final name in before.keys) {
      expect(after[name], before[name]);
    }
  });
}
