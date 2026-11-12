// What one night is: the first 21:00 after the first recording, in the
// zone in force then (C152-I item 2; D58 Q2, P9, P10).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/journal/night_rules.dart';

import '../fixtures.dart';
import 'zones.dart';

const sthlm = FakeStockholm();

Night nightAt(DateTime first, {String id = 'a'}) {
  final base = nightsFromFixtures().first;
  return Night(
    id: id * 32,
    firstRecorded: first,
    date: dateOf(first, sthlm),
    closes: closesAfter(first, sthlm),
    lang: base.lang,
    dreams: base.dreams,
  );
}

void main() {
  test('an evening night closes at 21:00 the next day', () {
    expect(closesAfter(stockholm(2026, 6, 10, 23), sthlm), stockholm(2026, 6, 11, 21));
    expect(closesAfter(stockholm(2026, 6, 11, 7), sthlm), stockholm(2026, 6, 11, 21));
  });

  test('20:59 closes a minute later; 21:00 itself starts a new night', () {
    expect(closesAfter(stockholm(2026, 6, 10, 20, 59), sthlm), stockholm(2026, 6, 10, 21));
    expect(closesAfter(stockholm(2026, 6, 10, 21), sthlm), stockholm(2026, 6, 11, 21));
    expect(closesAfter(stockholm(2026, 6, 10, 21, 1), sthlm), stockholm(2026, 6, 11, 21));
  });

  test('a night across a clock change still closes at 21:00 local', () {
    final spring = stockholm(2026, 3, 28, 23);
    expect(closesAfter(spring, sthlm).difference(spring), const Duration(hours: 21));
    final autumn = stockholm(2026, 10, 24, 23);
    expect(closesAfter(autumn, sthlm).difference(autumn), const Duration(hours: 23));
    expect(sthlm.wall(closesAfter(autumn, sthlm)).hour, 21);
  });

  test('the date is the local date of the first recording', () {
    expect(dateOf(stockholm(2026, 12, 31, 23, 30), sthlm), (year: 2026, month: 12, day: 31));
    expect(dateOf(stockholm(2027, 1, 1, 0, 30), sthlm), (year: 2027, month: 1, day: 1));
    expect(closesAfter(stockholm(2026, 12, 31, 22), sthlm), DateTime.utc(2027, 1, 1, 20));
  });

  test('the first zone fixes the 21:00 and the date (P9)', () {
    final n = nightAt(stockholm(2026, 6, 10, 20));
    const west = FixedZone(-5);
    // The phone moves west; the night still closes at Stockholm's 21:00.
    expect(tonight([n], stockholm(2026, 6, 10, 20, 59)), n);
    expect(tonight([n], stockholm(2026, 6, 10, 21)), isNull);
    expect(west.wall(n.closes).hour, 14);
    expect(n.date, (year: 2026, month: 6, day: 10));
  });

  test("tonight's night is the latest one not yet closed", () {
    final older = nightAt(stockholm(2026, 6, 9, 23), id: 'a');
    final newer = nightAt(stockholm(2026, 6, 10, 23), id: 'b');
    expect(tonight([older], stockholm(2026, 6, 10, 20)), older);
    expect(tonight([older, newer], stockholm(2026, 6, 11, 7)), newer);
    expect(tonight([older, newer], stockholm(2026, 6, 11, 21)), isNull);
    // The clock moved back by hand: both open, the latest wins (D57 Q13).
    expect(tonight([newer, older], stockholm(2026, 6, 9, 23, 30)), newer);
  });

  test('the target is fixed when the screen opens', () {
    final n = nightAt(stockholm(2026, 6, 10, 23));
    expect((targetAt([n], stockholm(2026, 6, 11, 20, 58)) as IntoNight).id, n.id);
    final opened = stockholm(2026, 6, 11, 21, 2);
    expect((targetAt([n], opened) as NewNight).begun, opened);
    expect((targetAt([], opened) as NewNight).begun, opened);
  });

  test('whitespace alone is empty', () {
    for (final t in ['', ' ', '\n\t ', ' ']) {
      expect(isEmptyText(t), isTrue, reason: t.codeUnits.toString());
    }
    expect(isEmptyText(nightsFromFixtures().first.dreams.first), isFalse);
  });
}
