// SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
// nights only.
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/safe_log.dart';

void main() {
  requireFlavour(Flavour.dev);
  SafeLog.event(LogEvent.appStarted);
  runApp(const SoulDreamsApp());
}
