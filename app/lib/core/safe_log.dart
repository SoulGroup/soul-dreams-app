// The app's only logger (CLAUDE.md R3; G5 exempts this file). It takes
// an event code and numbers, never a String: nothing from a night can
// reach a log. Release builds log nothing (D20 Q17).
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Every event the app may log. A new event is a new value here.
enum LogEvent {
  appStarted,
  wrongFlavour,

  /// The journal (D49): a temporary file from an interrupted save removed;
  /// a file that does not read as a night skipped; the phone check's result.
  journalTempSwept,
  journalFileSkipped,
  journalCheckPassed,
  journalCheckFailed,

  /// SoulDreams Dev's journal could not open its folder (journal-screens).
  journalOpenFailed,

  /// The typing screen's save failed; the words stay on the screen (D62).
  journalSaveFailed,

  /// A night's page: its delete failed, or its read of the night did (D64).
  /// The page stays as it was.
  journalDeleteFailed,
  journalReadFailed,
}

abstract final class SafeLog {
  /// Where lines go. Tests replace it; the app writes to the debugger.
  @visibleForTesting
  static void Function(String line) sink = _toDebugger;

  static void event(LogEvent code, [List<num> numbers = const []]) {
    if (kReleaseMode) return;
    sink([code.name, for (final n in numbers) '$n'].join(' '));
  }

  static void _toDebugger(String line) => developer.log(line, name: 'souldreams');
}
