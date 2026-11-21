// The journal's greeting by time of day (D110, head's message 24), in plain
// Dart: the part of the day by the phone's wall clock, and its greeting. The
// four parts and their hours are the plan's stand-ins until Product files
// the greetings; night begins at 21:00, as the dark theme does.
import 'owed.dart';

enum Daypart { morning, afternoon, evening, night }

/// The part of the day at the wall clock's [hour].
Daypart daypartAt(int hour) => switch (hour) {
  >= 5 && < 12 => Daypart.morning,
  >= 12 && < 17 => Daypart.afternoon,
  >= 17 && < 21 => Daypart.evening,
  _ => Daypart.night,
};

/// The greeting for [part]: owed by Product, shown as its handle (R1).
Owed greetingFor(Daypart part) => switch (part) {
  Daypart.morning => OwedLines.greetingMorning,
  Daypart.afternoon => OwedLines.greetingAfternoon,
  Daypart.evening => OwedLines.greetingEvening,
  Daypart.night => OwedLines.greetingNight,
};
