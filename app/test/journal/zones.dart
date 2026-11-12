// Fake zone tables for the night rules' tests (D49 O9): no test depends
// on the Mac's own time zone.
import 'package:souldreams/journal/night_rules.dart';

/// Stockholm in 2026: UTC+1, and UTC+2 from 29 March 01:00 UTC to
/// 25 October 01:00 UTC.
final class FakeStockholm implements Zone {
  const FakeStockholm();

  static final _summerFrom = DateTime.utc(2026, 3, 29, 1);
  static final _summerTo = DateTime.utc(2026, 10, 25, 1);

  int _offset(DateTime utc) => !utc.isBefore(_summerFrom) && utc.isBefore(_summerTo) ? 2 : 1;

  @override
  Wall wall(DateTime utc) {
    final l = utc.add(Duration(hours: _offset(utc)));
    return (year: l.year, month: l.month, day: l.day, hour: l.hour);
  }

  @override
  DateTime instantAt(int year, int month, int day, int hour) {
    final naive = DateTime.utc(year, month, day, hour);
    for (final o in const [2, 1]) {
      final c = naive.subtract(Duration(hours: o));
      if (_offset(c) == o) return c;
    }
    return naive.subtract(const Duration(hours: 1));
  }
}

/// A zone with a fixed offset from UTC, in hours.
final class FixedZone implements Zone {
  const FixedZone(this.hours);

  final int hours;

  @override
  Wall wall(DateTime utc) {
    final l = utc.add(Duration(hours: hours));
    return (year: l.year, month: l.month, day: l.day, hour: l.hour);
  }

  @override
  DateTime instantAt(int year, int month, int day, int hour) =>
      DateTime.utc(year, month, day, hour).subtract(Duration(hours: hours));
}

/// The instant Stockholm's wall clock shows this minute.
DateTime stockholm(int year, int month, int day, int hour, [int minute = 0]) =>
    const FakeStockholm().instantAt(year, month, day, hour).add(Duration(minutes: minute));
