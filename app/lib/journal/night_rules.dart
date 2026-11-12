// What one night is (C152-I item 2; main-path.md, Recording, "Nights";
// D58 Q2, P9, P10). A night closes at the first 21:00 after its first
// recording, by the phone's local time in the zone in force at that
// moment; the instant is kept, so a later change of zone or clock never
// moves it, and the date shown never moves. Until a night closes, a new
// dream joins it. Plain Dart, no screen: the clock and the zone are
// passed in, so tests use a fake zone table (D49 O9).
import 'night.dart';

/// A wall-clock reading of an instant.
typedef Wall = ({int year, int month, int day, int hour});

/// The phone's time zone, as the night rules need it.
abstract interface class Zone {
  /// What the wall clock showed at [utc].
  Wall wall(DateTime utc);

  /// The instant the wall clock shows [hour]:00 on that day. The day may
  /// run past the month's end.
  DateTime instantAt(int year, int month, int day, int hour);
}

/// The phone's own zone, through Dart's local time.
final class PhoneZone implements Zone {
  const PhoneZone();

  @override
  Wall wall(DateTime utc) {
    final l = utc.toLocal();
    return (year: l.year, month: l.month, day: l.day, hour: l.hour);
  }

  @override
  DateTime instantAt(int year, int month, int day, int hour) =>
      DateTime(year, month, day, hour).toUtc();
}

/// The hour a night closes (C152-I item 2).
const closingHour = 21;

/// The first 21:00 strictly after [first], in [zone].
DateTime closesAfter(DateTime first, Zone zone) {
  final w = zone.wall(first);
  final same = zone.instantAt(w.year, w.month, w.day, closingHour);
  return same.isAfter(first) ? same : zone.instantAt(w.year, w.month, w.day + 1, closingHour);
}

/// The phone's date at [first], in [zone].
NightDate dateOf(DateTime first, Zone zone) {
  final w = zone.wall(first);
  return (year: w.year, month: w.month, day: w.day);
}

/// Tonight's night: of the nights not yet closed at [now], the one with
/// the latest first recording (D57 Q13), or null.
Night? tonight(Iterable<Night> nights, DateTime now) {
  Night? out;
  for (final n in nights) {
    if (!n.closes.isAfter(now)) continue;
    if (out == null) {
      out = n;
      continue;
    }
    final c = n.firstRecorded.compareTo(out.firstRecorded);
    if (c > 0 || (c == 0 && n.id.compareTo(out.id) > 0)) out = n;
  }
  return out;
}

/// Where a typing screen saves. Fixed when the screen opens, so a screen
/// open across 21:00 saves into the night it began in (P10; D58 Q2).
sealed class Target {
  const Target();
}

/// Into a night that exists.
final class IntoNight extends Target {
  const IntoNight(this.id);

  final String id;
}

/// Into a new night, begun when the screen opened.
final class NewNight extends Target {
  const NewNight(this.begun);

  /// The moment the screen opened, in UTC: the night's first recording.
  final DateTime begun;
}

/// The target of a typing screen opened at [now] from the journal.
Target targetAt(Iterable<Night> nights, DateTime now) {
  final open = tonight(nights, now);
  return open == null ? NewNight(now) : IntoNight(open.id);
}

/// Nothing but whitespace counts as empty (P10; D58 Q3).
bool isEmptyText(String text) => text.trim().isEmpty;
