// The testers' SoulDreams (app.souldreams). It never imports lib/founder/:
// in a tester build the export is not built in (CLAUDE.md R8, G8).
import 'package:flutter/widgets.dart';

import 'app.dart';

void main() {
  runApp(const SoulDreamsApp());
}
