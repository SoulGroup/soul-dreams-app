// The journal's operations (D58): the first Save makes the night, an
// empty Save keeps nothing, a screen saves into the night it began in,
// an emptied dream disappears, and an emptied night is deleted.
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_rules.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';
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

  // D121 item 5; D122: a consent withdrawn is an answer kept, every night
  // stays, and nothing is told; the app stays where it is.
  test('a consent withdrawn keeps every night, and tells nothing', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    var told = 0;
    journal.consentGone.addListener(() => told++);
    expect(await journal.consents(), isNull);
    final given = Consents.answered({Consent.readings: true}, journal.now());
    await journal.keepConsents(given);
    expect(await journal.consents(), given);
    final withdrawn = given.withAnswer(Consent.readings, false, journal.now());
    await journal.keepConsents(withdrawn);
    expect(await journal.consents(), withdrawn);
    await journal.keepSettings(const Settings(wordAnimation: false));
    expect(await journal.settings(), const Settings(wordAnimation: false));
    expect(told, 0);
    expect((await journal.newestFirst()).single.dreams, [a[0]]);
  });

  // D110: deleting the journal takes the consents, the settings and every
  // night, and is told once, so the app returns to its start.
  test('deleting the journal takes the consents and every night, told', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    await journal.keepConsents(Consents.answered({Consent.readings: true}, journal.now()));
    await journal.keepSettings(const Settings(wordAnimation: false));
    await journal.markFirstUseSeen();
    var told = 0;
    journal.consentGone.addListener(() => told++);
    await journal.deleteAll();
    expect(told, 1);
    expect(await journal.consents(), isNull);
    expect(await journal.settings(), isNull);
    expect(await journal.firstUseSeen(), isFalse);
    expect(await journal.newestFirst(), isEmpty);
    expect(files.everything(), isEmpty);
  });

  // D93 Q2: a dream's index counts waiting recordings too, and a waiting
  // one is never edited; a night left with only one stays.
  test('an edit counts waiting dreams, and never replaces one', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final n = (await journal.newestFirst()).single;
    final w = Waiting('c' * 32);
    await (await JournalStore.open(files)).save(n.withEntries([w, ...n.entries]));
    Future<List<Dream>> entries() async => (await journal.night(n.id))!.entries;
    await journal.editDream(n.id, 0, b[0]);
    expect(await entries(), [w, Told(a[0])]);
    await journal.editDream(n.id, 1, b[0]);
    expect(await entries(), [w, Told(b[0])]);
    await journal.addDream(IntoNight(n.id), a[1], Lang.en);
    expect(await entries(), [w, Told(b[0]), Told(a[1])]);
    await journal.editDream(n.id, 1, ' ');
    await journal.editDream(n.id, 1, '');
    expect(await entries(), [w]);
  });

  // D93 Q2, Q7: a Save keeps the recordings its screen left waiting, after
  // its words; with nothing typed, the recording alone keeps the night.
  test('a Save keeps waiting recordings after its words', () async {
    final (x, y) = (Waiting('1' * 32), Waiting('2' * 32, 64));
    expect(await journal.addDream(await journal.targetNow(), ' ', Lang.en, waiting: [x]), isTrue);
    final n = (await journal.newestFirst()).single;
    expect(n.entries, [x]);
    expect(await journal.addDream(IntoNight(n.id), a[0], Lang.en, waiting: [y]), isTrue);
    expect((await journal.night(n.id))!.entries, [x, Told(a[0]), y]);
  });

  test('an edit puts waiting recordings after its dream, or instead', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final n = (await journal.newestFirst()).single;
    await journal.addDream(IntoNight(n.id), a[1], Lang.en);
    final (x, y, z) = (Waiting('1' * 32), Waiting('2' * 32), Waiting('3' * 32));
    Future<List<Dream>> entries() async => (await journal.night(n.id))!.entries;
    await journal.editDream(n.id, 0, b[0], waiting: [x]);
    expect(await entries(), [Told(b[0]), x, Told(a[1])]);
    await journal.editDream(n.id, 2, '', waiting: [y]);
    expect(await entries(), [Told(b[0]), x, y]);
    await journal.editDream(n.id, 9, b[0], waiting: [z]);
    expect(await entries(), [Told(b[0]), x, y, z]);
  });

  // D94: words that came for a recording may move a dream while its screen
  // is open; the edit finds it by the words it opened with.
  test('an edit finds its dream by its words once moved', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final n = (await journal.newestFirst()).single;
    await journal.addDream(IntoNight(n.id), a[1], Lang.en);
    final w = Waiting('1' * 32);
    await (await JournalStore.open(files)).save(n.withEntries([Told(b[0]), w, Told(a[0]), Told(a[1])]));
    await journal.editDream(n.id, 1, 'x', was: a[1]);
    expect((await journal.night(n.id))!.entries, [Told(b[0]), w, Told(a[0]), const Told('x')]);
    await journal.editDream(n.id, 2, '', was: a[0]);
    expect((await journal.night(n.id))!.entries, [Told(b[0]), w, const Told('x')]);
  });

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

  // D94, D96: words that came for a recording moved the dream being edited;
  // it is found by its words, the one nearest where it was when two share
  // them.
  test('an edit finds its moved dream by where it was', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final n = (await journal.newestFirst()).single;
    final w = Waiting('d' * 32);
    final same = Told(a[0]);
    final moved = Told(b[0]);
    // The screen opened on dream 2 ("a[0]" again, after the recording);
    // a retry then put one dream before the recording.
    await (await JournalStore.open(files)).save(n.withEntries([same, moved, w, same]));
    await journal.editDream(n.id, 2, b[0], was: a[0]);
    expect((await journal.night(n.id))!.entries, [same, moved, w, Told(b[0])]);
    // And on dream 0 (it did not move): it stays the one edited.
    await (await JournalStore.open(files)).save(n.withEntries([same, moved, w, same]));
    await journal.editDream(n.id, 0, a[1], was: a[0]);
    expect((await journal.night(n.id))!.entries, [Told(a[1]), moved, w, same]);
    // Two as near as each other: the lower.
    await (await JournalStore.open(files)).save(n.withEntries([same, w, same]));
    await journal.editDream(n.id, 1, b[0], was: a[0]);
    expect((await journal.night(n.id))!.entries, [Told(b[0]), w, same]);
  });

  // D96 Q3: an edit says whether its night was there, as a Save does.
  test('an edit says whether its night was there', () async {
    await journal.addDream(await journal.targetNow(), a[0], Lang.en);
    final id = (await journal.newestFirst()).single.id;
    expect(await journal.editDream(id, 0, b[0]), isTrue);
    expect(await journal.editDream(id, 7, b[0]), isTrue);
    await journal.delete(id);
    expect(await journal.editDream(id, 0, b[0]), isFalse);
    expect(await journal.editDream(id, 0, b[0], waiting: [Waiting('1' * 32)]), isFalse);
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
