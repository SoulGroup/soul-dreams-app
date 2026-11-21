// The journal's greeting by time of day (D110; C18-P, MP·72 to MP·75): four
// parts of the day by the phone's wall clock, each with its filed place, and
// one line of its four a day, the four in turn (D119 item 4).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/greeting.dart';
import 'package:souldreams/journal/night_rules.dart';
import 'package:souldreams/words/lines.g.dart';

Wall at(int year, int month, int day, int hour) => (year: year, month: month, day: day, hour: hour);

void main() {
  test('the parts of the day: from 05, 11, 17, 21', () {
    final parts = [for (var h = 0; h < 24; h++) daypartAt(h)];
    expect(parts, [
      for (var h = 0; h < 5; h++) Daypart.night,
      for (var h = 5; h < 11; h++) Daypart.morning,
      for (var h = 11; h < 17; h++) Daypart.day,
      for (var h = 17; h < 21; h++) Daypart.evening,
      for (var h = 21; h < 24; h++) Daypart.night,
    ]);
  });

  test('each part has its filed place, four lines each', () {
    expect(greetingPlace(Daypart.morning), Lines.MP_72);
    expect(greetingPlace(Daypart.day), Lines.MP_73);
    expect(greetingPlace(Daypart.evening), Lines.MP_74);
    expect(greetingPlace(Daypart.night), Lines.MP_75);
    for (final part in Daypart.values) {
      for (final lang in Lang.values) {
        expect(greetingPlace(part).parts(lang), hasLength(4), reason: '$part $lang');
      }
    }
  });

  test('one line a day, the four in turn', () {
    for (final lang in Lang.values) {
      final seen = [
        for (var d = 0; d < 8; d++) greetingText(greetingAt(at(2026, 6, 10 + d, 12)), lang),
      ];
      final lines = Lines.MP_73.parts(lang);
      final first = lines.indexOf(seen.first);
      expect(first, isNot(-1));
      expect(seen, [for (var d = 0; d < 8; d++) lines[(first + d) % 4]]);
    }
  });

  test('one line all day; the day turns at a month end', () {
    final morning = greetingAt(at(2026, 6, 10, 5));
    expect(greetingAt(at(2026, 6, 10, 10)), morning);
    final june30 = greetingAt(at(2026, 6, 30, 12)).day;
    expect(greetingAt(at(2026, 7, 1, 12)).day, june30 + 1);
    final dec31 = greetingAt(at(2026, 12, 31, 12)).day;
    expect(greetingAt(at(2027, 1, 1, 12)).day, dec31 + 1);
  });

  test('after midnight, the line of the evening it began on', () {
    final late = greetingAt(at(2026, 6, 10, 23));
    expect(greetingAt(at(2026, 6, 11, 0)), late);
    expect(greetingAt(at(2026, 6, 11, 4)), late);
    expect(greetingAt(at(2026, 6, 11, 5)).day, late.day + 1);
    expect(greetingAt(at(2026, 6, 11, 5)).part, Daypart.morning);
    // On the first of a month, after midnight: the last day of the one before.
    expect(greetingAt(at(2026, 7, 1, 2)), greetingAt(at(2026, 6, 30, 22)));
  });
}
