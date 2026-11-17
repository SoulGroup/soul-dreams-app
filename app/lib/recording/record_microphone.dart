// The phone's microphone through the `record` package (D71 Q14, exactly
// 7.1.2): its stream of sixteen-bit PCM at 16 kHz, one channel, handed on
// as it comes. In stream mode the package writes no file. The built-in
// microphone only: no Bluetooth route and no speaker setting (D71 Q15).
// The phone asks the dreamer the first time, with EM·3. When a recording
// ends, the phone's audio is given back with notify-others, so music the
// recording paused resumes (D79 c). The package never deactivates the
// session when a recording stops, so ours does, through the Swift channel
// in ios/Runner/AppDelegate.swift.
import 'package:flutter/services.dart';
import 'package:record/record.dart';

import '../core/safe_log.dart';
import 'microphone.dart';

const audioSessionChannel = 'souldreams/audio_session';

final class RecordMicrophone implements Microphone {
  RecordMicrophone({AudioRecorder? recorder, this._session = const MethodChannel(audioSessionChannel)})
    : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;
  final MethodChannel _session;

  // A release that fails has its own code (D85) and never hides what the
  // recorder did.
  Future<void> _release() async {
    try {
      await _session.invokeMethod<void>('release');
    } on Object {
      SafeLog.event(LogEvent.recordingReleaseFailed);
    }
  }

  // The package pauses its recording when a call or Siri takes the audio
  // (its default); this app never pauses, so a pause is an interruption
  // (D79 b). Read when a recording's frames start; the package's
  // startStream has already set up its state channel by then.
  @override
  late final Stream<void> interruptions = _recorder.onStateChanged().where((s) => s == RecordState.pause);

  @override
  Future<bool> allowed() => _recorder.hasPermission();

  // A start that fails may already have taken the phone's audio: it is
  // given back.
  @override
  Future<Stream<Uint8List>> start() async {
    try {
      return await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: sampleRate,
          numChannels: 1,
          iosConfig: IosRecordConfig(categoryOptions: []),
        ),
      );
    } on Object {
      await _release();
      rethrow;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _recorder.stop();
    } finally {
      await _release();
    }
  }
}
