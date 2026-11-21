// The sky mark above the greeting (D112): a sun from 08:00 to 21:00, a moon
// from 21:00 to 08:00, the dark theme's hours, by the phone's wall clock.
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/night_day.dart';
import 'package:souldreams/journal/sky.dart';

void main() {
  test('moon from 21:00 to 08:00, sun from 08:00 to 21:00', () {
    expect([for (var h = 0; h < 24; h++) skyAt(h)], [
      for (var h = 0; h < 8; h++) Sky.moon,
      for (var h = 8; h < 21; h++) Sky.sun,
      for (var h = 21; h < 24; h++) Sky.moon,
    ]);
  });

  test('the moon is the dark theme, hour for hour', () {
    for (var h = 0; h < 24; h++) {
      expect(skyAt(h) == Sky.moon, isNightAt(DateTime(2026, 6, 10, h)), reason: 'hour $h');
    }
  });
}
