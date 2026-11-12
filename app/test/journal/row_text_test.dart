// What a journal row shows (D58 Q7; P5): the opening trimmed of TECH·1's
// framing at its very start only, the date's digits, the month dividers.
// No month name and no framing is typed here: both come from the
// generated lists and from Flutter's localization data (R1).
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/row_text.dart';
import 'package:souldreams/words/lines.g.dart' show Lang;
import 'package:souldreams/words/lists.g.dart';

import '../fixtures.dart';

Night told(String first, {Lang lang = Lang.en, NightDate date = (year: 2026, month: 10, day: 12)}) {
  final base = nightsFromFixtures().first;
  return Night(
      id: base.id,
      firstRecorded: base.firstRecorded,
      date: date,
      closes: base.closes,
      lang: lang,
      dreams: [first]);
}

void main() {
  setUpAll(() => initializeDateFormatting());

  final rest = invented('two-dreams-en').dreams.first;
  final restSv = invented('one-dream-sv').dreams.first;

  test('each framing is trimmed from the very start, ignoring case', () {
    for (final f in ListWords.tech1En) {
      expect(opening(told('$f $rest')), rest, reason: f);
      expect(opening(told('${f.toUpperCase()}  $rest')), rest, reason: f);
      expect(opening(told('${f.toLowerCase()}\n$rest')), rest, reason: f);
    }
    for (final f in ListWords.tech1Sv) {
      expect(opening(told('$f $restSv', lang: Lang.sv)), restSv, reason: f);
    }
  });

  test('a framing is trimmed only whole, at the start', () {
    final f = ListWords.tech1En.first;
    for (final t in ['${f}s $rest', '$rest $f', ' $f $rest', f]) {
      expect(opening(told(t)), t);
    }
    // The other language's framing is not trimmed.
    expect(opening(told('$f $rest', lang: Lang.sv)), '$f $rest');
  });

  test('the longest framing wins', () {
    // A pair where one framing begins with the other and a space.
    final all = ListWords.tech1Sv;
    final (short, long) = [
      for (final a in all)
        for (final b in all)
          if (b.length > a.length && b.toLowerCase().startsWith('${a.toLowerCase()} ')) (a, b)
    ].first;
    expect(opening(told('$long $restSv', lang: Lang.sv)), restSv);
    expect(opening(told('$short $restSv', lang: Lang.sv)), restSv);
  });

  test('the invented framed night loses its framing', () {
    final framed = invented('framed-opening-en').dreams.first;
    final trimmed = opening(told(framed));
    expect(framed.endsWith(trimmed), isTrue);
    expect(trimmed.length, lessThan(framed.length));
  });

  test('the date is day/month/year, with no time', () {
    expect(dayDigits((year: 2026, month: 3, day: 5)), '05/03/2026');
    expect(dayDigits((year: 2026, month: 12, day: 31)), '31/12/2026');
  });

  test('a divider: the month alone this year, month and year before', () {
    for (final lang in Lang.values) {
      final own = DateFormat.LLLL(lang.name).format(DateTime(2026, 10));
      final now = monthDivider(2026, 10, 2026, lang);
      expect(now.toLowerCase(), own.toLowerCase());
      expect(now[0], now[0].toUpperCase());
      expect(now.contains(RegExp(r'\d')), isFalse);
      final before = monthDivider(2025, 10, 2026, lang);
      expect(before, '$now 2025');
    }
    // Flutter's Swedish month names are lower case; the divider's is not.
    final sv = DateFormat.LLLL('sv').format(DateTime(2026, 10));
    expect(sv[0], isNot(sv[0].toUpperCase()));
    expect(monthDivider(2026, 10, 2026, Lang.sv)[0], sv[0].toUpperCase());
  });

  test('a divider over each month with nights, and no other', () {
    final nights = [
      told(rest, date: (year: 2026, month: 11, day: 2)),
      told(rest, date: (year: 2026, month: 11, day: 1)),
      told(rest, date: (year: 2026, month: 9, day: 30)),
      told(rest, date: (year: 2025, month: 9, day: 30)),
    ];
    final items = listItems(nights);
    expect([
      for (final i in items)
        switch (i) {
          MonthItem(:final year, :final month) => '$year-$month',
          NightItem(:final night) => night.date.day,
        }
    ], ['2026-11', 2, 1, '2026-9', 30, '2025-9', 30]);
    expect(listItems(const []), isEmpty);
  });
}
