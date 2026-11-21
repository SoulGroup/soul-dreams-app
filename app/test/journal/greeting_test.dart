// The journal's greeting by time of day (D110): four parts of the day by the
// phone's wall clock, each with its owed greeting.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/journal/greeting.dart';
import 'package:souldreams/journal/owed.dart';

void main() {
  test('the parts of the day: from 05, 12, 17, 21', () {
    final parts = [for (var h = 0; h < 24; h++) daypartAt(h)];
    expect(parts, [
      for (var h = 0; h < 5; h++) Daypart.night,
      for (var h = 5; h < 12; h++) Daypart.morning,
      for (var h = 12; h < 17; h++) Daypart.afternoon,
      for (var h = 17; h < 21; h++) Daypart.evening,
      for (var h = 21; h < 24; h++) Daypart.night,
    ]);
  });

  test('each part of the day has its own greeting', () {
    expect(greetingFor(Daypart.morning), OwedLines.greetingMorning);
    expect(greetingFor(Daypart.afternoon), OwedLines.greetingAfternoon);
    expect(greetingFor(Daypart.evening), OwedLines.greetingEvening);
    expect(greetingFor(Daypart.night), OwedLines.greetingNight);
  });
}
