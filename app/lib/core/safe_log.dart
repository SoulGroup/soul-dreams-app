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

  /// A recording's audio that no night names, or an older copy of it,
  /// removed when the journal opens (D92).
  audioSwept,

  /// SoulDreams Dev's diagnostic (D98), numbers only: the audio files in the
  /// journal's folder, then the recordings its nights name as waiting; at
  /// launch and after each retry.
  journalAudio,

  /// SoulDreams Dev's journal could not open its folder (journal-screens).
  journalOpenFailed,

  /// The typing screen's save failed; the words stay on the screen (D62).
  journalSaveFailed,

  /// A night's page: its delete failed, or its read of the night did (D64).
  /// The page stays as it was.
  journalDeleteFailed,
  journalReadFailed,

  /// The journal list's read of the nights failed, on loading the list or
  /// at the record button; the list stays as it was (D71 Q18).
  journalListFailed,

  /// The typing screen's read or mark of first use failed (D71 Q18).
  firstUseReadFailed,

  /// Onboarding (D103): the consent could not be read, so onboarding asks
  /// again; or it could not be kept, so the journal opens and the next
  /// opening asks again.
  consentReadFailed,
  consentKeepFailed,

  /// Recording by voice (D69, D71). Off in this build; the microphone
  /// refused; no key from our server (its status); Soniox's stream refused
  /// or broken (its code); the microphone failing; a recording started,
  /// stopped by a call or Siri (D79 b), and ended; the phone's audio not
  /// given back after it (D85).
  recordingOff,
  recordingRefused,
  recordingKeyFailed,
  recordingStreamFailed,
  recordingMicFailed,
  recordingStarted,
  recordingInterrupted,
  recordingEnded,
  recordingReleaseFailed,

  /// A recording begun with no connection, its audio kept to wait (D93
  /// Q4); one stopped by itself at ten minutes (D93 Q6); its audio that
  /// could not be kept on the phone (D92).
  recordingOffline,
  recordingCapped,

  /// The phone reported its connection gone during a recording whose
  /// stream was open or opening (D100).
  recordingConnectionLost,
  audioKeepFailed,

  /// A recording that leaves audio waiting, as it ends (D98's diagnostic),
  /// numbers only: the milliseconds Soniox had made final, then the
  /// milliseconds recorded.
  recordingSettled,

  /// A waiting recording replayed to Soniox (D94): begun; all of it in
  /// words; cut short, its progress kept (with the bytes of audio now in
  /// words and the milliseconds Soniox said it had made final); failed (Soniox's code, our
  /// server's status, 0 for no answer, -2 for the journal, -3 for words
  /// the journal did not take).
  retryStarted,
  retryDone,
  retryCut,
  retryFailed,
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
