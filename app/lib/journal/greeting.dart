// The journal's greeting by time of day (D110; C18-P, MP·72 to MP·75), in
// plain Dart: the part of the day by the phone's wall clock, from 05:00,
// 11:00, 17:00 and 21:00 (start-inclusive), and one line of that part's four
// a day, the four in turn. A night after midnight keeps the line of the
// evening it began on, so the greeting never changes inside a part (D119
// item 4; the day counted under D91).
import '../words/lines.g.dart';
import 'night_rules.dart';

enum Daypart { morning, day, evening, night }

/// The part of the day at the wall clock's [hour].
Daypart daypartAt(int hour) => switch (hour) {
  >= 5 && < 11 => Daypart.morning,
  >= 11 && < 17 => Daypart.day,
  >= 17 && < 21 => Daypart.evening,
  _ => Daypart.night,
};

/// The register's place for [part]'s greeting.
Line greetingPlace(Daypart part) => switch (part) {
  Daypart.morning => Lines.MP_72,
  Daypart.day => Lines.MP_73,
  Daypart.evening => Lines.MP_74,
  Daypart.night => Lines.MP_75,
};

/// Which greeting stands at the wall clock's [wall]: its part, and the day
/// that part began on (days since 1970-01-01 by the calendar).
typedef Greeting = ({Daypart part, int day});

Greeting greetingAt(Wall wall) {
  final part = daypartAt(wall.hour);
  final back = wall.hour < 5 ? 1 : 0;
  final began = DateTime.utc(wall.year, wall.month, wall.day - back);
  return (part: part, day: began.difference(DateTime.utc(1970)).inDays);
}

/// The words of [g]: one of its place's four lines, the four in turn by day.
String greetingText(Greeting g, Lang lang) {
  final lines = greetingPlace(g.part).parts(lang);
  return lines[g.day % lines.length];
}
