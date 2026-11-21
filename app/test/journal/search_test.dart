// Search, in plain Dart (D110; D116 items 1 to 3; D117 Q4, Q5, Q8): from
// three characters, case folded with marks kept, the typed characters at
// the start of a word, the first place in a night, the dreams' text only;
// the context line around it. Every text is an invented night (R2).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/search.dart';

import '../fixtures.dart';

String dream(String key, [int i = 0]) => invented(key).dreams[i];

String matched(String text, String query) {
  final s = firstMatch(text, query)!;
  return text.substring(s.start, s.end);
}

void main() {
  test('a search starts from three characters, the spaces around left out', () {
    expect(searchable(''), isNull);
    expect(searchable('  gl  '), isNull);
    expect(searchable(' gla '), 'gla');
    expect(searchable('g l'), 'g l');
    // Characters, not code units: one outside the basic plane counts once.
    expect(searchable('\u{1F319}a'), isNull);
    expect(searchable('\u{1F319}ab'), '\u{1F319}ab');
  });

  test('capitals fold; å, ä and ö stay apart', () {
    final text = dream('one-dream-sv');
    expect(matched(text, 'TÅG'), 'tåg');
    expect(matched(text, 'Glas'), 'glas');
    expect(firstMatch(text, 'tag'), isNull);
    expect(firstMatch(text, 'gläs'), isNull);
    expect(matched(dream('two-dreams-en'), 'LIGHTHOUSE'), 'lighthouse');
  });

  test('the typed characters match only at the start of a word', () {
    final sv = dream('one-dream-sv');
    expect(matched(sv, 'citron'), 'citron');
    expect(firstMatch(sv, 'träd'), isNull);
    final en = dream('two-dreams-en');
    expect(matched(en, 'fiel'), 'fiel');
    expect(firstMatch(en, 'ield'), isNull);
    expect(matched(en, 'wheat fi'), 'wheat fi');
  });

  test('the first place in the text, never a later one', () {
    final en = dream('two-dreams-en');
    final s = firstMatch(en, 'the')!;
    expect(s.start, en.indexOf('the'));
    expect(en.substring(s.start, s.end), 'the');
  });

  test('the span is on the text\'s own characters', () {
    // A capital I with a dot (U+0130) folds to a plain i.
    expect(firstMatch('ab İz', 'iZ'), (start: 3, end: 5));
    // U+10400 folds to U+10428, each two code units.
    expect(firstMatch('ab \u{10400}x', '\u{10428}X'), (start: 3, end: 6));
    // A letter outside the basic plane is a word's letter.
    expect(firstMatch('ab \u{10428}x', 'x'), isNull);
    // A symbol is no letter, so a word can start right after it.
    expect(firstMatch('ab \u{1F319}xy', 'xy'), (start: 5, end: 7));
  });

  test('curly quotes and dashes fold to straight ones, in both texts', () {
    // Typed curly, written straight.
    expect(firstMatch("it's here", 'it\u2019s'), (start: 0, end: 4));
    expect(firstMatch("it's here", 'IT\u2018S'), (start: 0, end: 4));
    expect(firstMatch('say "hi" now', '\u201chi\u201d'), (start: 4, end: 8));
    expect(firstMatch('one-two', 'one\u2013two'), (start: 0, end: 7));
    expect(firstMatch('one-two', 'one\u2014two'), (start: 0, end: 7));
    // Typed straight, written curly: the span is the text's own marks.
    expect(firstMatch('it\u2019s here', "it's"), (start: 0, end: 4));
    expect(firstMatch('it\u2018s here', "it's"), (start: 0, end: 4));
    expect(firstMatch('say \u201chi\u201d now', '"hi"'), (start: 4, end: 8));
    expect(firstMatch('one\u2013two', 'one-two'), (start: 0, end: 7));
    expect(firstMatch('one\u2014two', 'one-two'), (start: 0, end: 7));
    // Written curly and typed curly, the other way round.
    expect(firstMatch('it\u2019s here', 'it\u2018s'), (start: 0, end: 4));
    expect(firstMatch('one\u2013two', 'one\u2014two'), (start: 0, end: 7));
    // A quote is no letter: a word starts right after it.
    expect(firstMatch('say \u201chi\u201d now', 'hi'), (start: 5, end: 7));
  });

  test('only those marks fold, the others stay apart', () {
    expect(firstMatch("it's", 'it"s'), isNull);
    expect(firstMatch('it\u201cs', "it's"), isNull);
    expect(firstMatch("it's", 'it`s'), isNull);
    expect(firstMatch('one-two', 'one\u2212two'), isNull);
    expect(firstMatch('one-two', 'one_two'), isNull);
  });

  test('a night: its told dreams in order, never its name', () {
    final n = nightsFromFixtures().singleWhere((x) => x.name != null);
    final key = invented('named-three-dreams-sv');
    expect(findIn(n, 'glas')!.entry, 0);
    expect(findIn(n, 'NYCKEL')!.entry, 2);
    expect(findIn(n, 'nyckel')!.span, firstMatch(key.dreams[2], 'nyckel'));
    final waiting = n.withEntries([Waiting('e' * 32, 0), ...n.entries]);
    expect(findIn(waiting, 'nyckel')!.entry, 3);
    expect(findIn(n, key.name!.substring(0, 6)), isNull);
  });

  test('search keeps the order and leaves out nights with no match', () {
    final nights = nightsFromFixtures().reversed.toList();
    final glas = search(nights, 'glas');
    expect(glas.map((f) => f.night.id), [
      for (final n in nights)
        if (n.dreams.any((d) => d.contains('glas'))) n.id,
    ]);
    expect(glas, hasLength(2));
    expect(search(nights, 'zzz'), isEmpty);
  });

  test('the context: three words before, the match, then the rest', () {
    final long = dream('long-dream-en');
    final at = firstMatch(long, 'tortoise')!;
    final c = contextOf(long, at);
    expect(c.before, '$cut a crowd of ');
    expect(c.match, 'tortoise');
    expect(c.after, long.substring(at.end));
    final first = contextOf(dream('two-dreams-en'), firstMatch(dream('two-dreams-en'), 'lighth')!);
    expect(first.before, 'A ');
  });

  test('the context is one line, each run of spaces one space', () {
    final d = invented('named-three-dreams-sv').dreams;
    final text = '${d[0]}\n\n${d[1]}  ';
    final c = contextOf(text, firstMatch(text, 'sedan')!);
    final words = d[0].split(' ');
    expect(c.before, '$cut ${words.sublist(words.length - 3).join(' ')} ');
    expect(c.match, 'Sedan');
    expect(c.after, d[1].substring(5));
    final across = contextOf(text, firstMatch(text, 'molnen')!);
    expect(across.after, '. ${d[1]}');
  });
}
