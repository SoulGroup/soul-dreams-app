import 'package:flutter/services.dart';

import 'safe_log.dart';

/// The three builds, named as their Xcode schemes (D20 Q5).
enum Flavour { dev, founder, tester }

/// Stops the app unless it was built as [expected]: `appFlavor` must be
/// its name. A build with another flavour, or none, never starts (D20 Q8).
void requireFlavour(Flavour expected, {String? flavor = appFlavor}) {
  if (flavor == expected.name) return;
  SafeLog.event(LogEvent.wrongFlavour);
  throw StateError('flavour');
}
