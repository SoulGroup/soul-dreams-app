// SoulDreams Dev (app.souldreams.dev): the owner's test app, invented
// nights only. It opens on onboarding until the dreamer agrees, then on the
// journal (D49 O1; D56; D103). Each night's menu holds the founder's export
// (D107; D108; R8 lets this file and main_founder.dart import it). Built
// with --dart-define=PREVIEW_READ=true, every night shows as read, for the
// owner's by-eye review of a read night's look (D110); nothing is stored.
// Built with tool/preview_kept.py's file, it seeds the invented kept
// sentences once, for the review of Life Context's page (D131 item 1).
import 'dart:async';

import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/flavour.dart';
import 'core/keyboard_check.dart';
import 'core/safe_log.dart';
import 'founder/founder_export.dart';
import 'journal/channel_journal_files.dart';
import 'journal/night_look.dart';
import 'journal/pages/journal_home.dart';
import 'journal/self_check.dart';
import 'recording/connection.dart';
import 'recording/record_microphone.dart';
import 'recording/recording.dart';

void main() {
  requireFlavour(Flavour.dev);
  SafeLog.event(LogEvent.appStarted);
  // The phone check (D49 c): only in a build made with
  // --dart-define=JOURNAL_SELF_CHECK=true. The journal list waits for it
  // (D65), so its probe never shows as a row.
  const files = ChannelJournalFiles();
  final check = const bool.fromEnvironment('JOURNAL_SELF_CHECK') ? journalSelfCheck(files, files) : null;
  // Recording by voice (D69, D71): the beta key comes from the owner's
  // file through --dart-define-from-file (R5); with none, recording is off.
  // The phone's own connection status decides MP·15 at the tap (D93 Q4).
  final recording = Recording.live(
    microphone: RecordMicrophone(),
    betaKey: const String.fromEnvironment('BETA_KEY'),
    connection: ChannelConnection(),
  );
  const read = bool.fromEnvironment('PREVIEW_READ') ? allRead : noneRead;
  // The keyboard check (D50 1): only in a build made with
  // --dart-define=KEYBOARD_CHECK=true.
  runApp(
    SoulDreamsApp(
      home: const bool.fromEnvironment('KEYBOARD_CHECK')
          ? const KeyboardCheck()
          : JournalHome(files: files, after: check, recording: recording, nightAction: const FounderExport().action, read: read, preview: const String.fromEnvironment('PREVIEW_KEPT')),
    ),
  );
  if (check != null) unawaited(check);
}
