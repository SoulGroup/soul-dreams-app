// The sky mark above the journal's greeting (D112), in plain Dart: a sun by
// day and a moon by night, the dark theme's hours (21:00 to 08:00), by the
// phone's wall clock (its hour).
import '../core/night_day.dart';

enum Sky { sun, moon }

/// The mark at the wall clock's [hour]: the moon from 21:00 to 08:00, the
/// hours of the dark theme, so the mark and the theme never part.
Sky skyAt(int hour) => isNightAt(DateTime(2000, 1, 1, hour)) ? Sky.moon : Sky.sun;
