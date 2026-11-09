// SoulDreams (app.souldreams.founder): the owner's Cohort 0 app. Release
// builds only, built by the CLI command (D20 Q8).
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/safe_log.dart';

void main() {
  requireFlavour(Flavour.founder);
  SafeLog.event(LogEvent.appStarted);
  runApp(const SoulDreamsApp());
}
