// The testers' SoulDreams (app.souldreams). It never imports lib/founder/:
// in a tester build the export is not built in (CLAUDE.md R8, G8).
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/safe_log.dart';

void main() {
  requireFlavour(Flavour.tester);
  SafeLog.event(LogEvent.appStarted);
  runApp(const SoulDreamsApp());
}
