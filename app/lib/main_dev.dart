// SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
// nights only.
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/safe_log.dart';
import 'journal/channel_journal_files.dart';
import 'journal/self_check.dart';

void main() {
  requireFlavour(Flavour.dev);
  SafeLog.event(LogEvent.appStarted);
  runApp(const SoulDreamsApp());
  // The phone check (D49 c): only in a build made with
  // --dart-define=JOURNAL_SELF_CHECK=true.
  if (const bool.fromEnvironment('JOURNAL_SELF_CHECK')) {
    const files = ChannelJournalFiles();
    unawaited(journalSelfCheck(files, files));
  }
}
