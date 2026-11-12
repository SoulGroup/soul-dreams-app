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
  // The keyboard check (D50 1): only in a build made with
  // --dart-define=KEYBOARD_CHECK=true.
  runApp(SoulDreamsApp(
      home: const bool.fromEnvironment('KEYBOARD_CHECK')
          ? const KeyboardCheck()
          : const JournalHome(files: ChannelJournalFiles())));
  // The phone check (D49 c): only in a build made with
  // --dart-define=JOURNAL_SELF_CHECK=true.
  if (const bool.fromEnvironment('JOURNAL_SELF_CHECK')) {
    const files = ChannelJournalFiles();
    unawaited(journalSelfCheck(files, files));
  }
}
