// SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
// nights only. It opens on the journal (D49 O1; D56).
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/keyboard_check.dart';
import 'core/safe_log.dart';
import 'journal/channel_journal_files.dart';
import 'journal/pages/journal_home.dart';
import 'journal/self_check.dart';

void main() {
  requireFlavour(Flavour.dev);
  SafeLog.event(LogEvent.appStarted);
  // The phone check (D49 c): only in a build made with
  // --dart-define=JOURNAL_SELF_CHECK=true. The journal list waits for it
  // (D65), so its probe never shows as a row.
  const files = ChannelJournalFiles();
  final check = const bool.fromEnvironment('JOURNAL_SELF_CHECK') ? journalSelfCheck(files, files) : null;
  // The keyboard check (D50 1): only in a build made with
  // --dart-define=KEYBOARD_CHECK=true.
  runApp(
    SoulDreamsApp(
      home: const bool.fromEnvironment('KEYBOARD_CHECK')
          ? const KeyboardCheck()
          : JournalHome(files: files, after: check),
    ),
  );
  if (check != null) unawaited(check);
}
