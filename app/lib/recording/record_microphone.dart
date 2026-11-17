// The phone's microphone through the `record` package (D71 Q14, exactly
// 7.1.2): its stream of sixteen-bit PCM at 16 kHz, one channel, handed on
// as it comes. In stream mode the package writes no file. The built-in
// microphone only: no Bluetooth route and no speaker setting (D71 Q15).
// The phone asks the dreamer the first time, with EM·3.
import 'dart:typed_data';

import 'package:record/record.dart';

import 'microphone.dart';

final class RecordMicrophone implements Microphone {
  final _recorder = AudioRecorder();

  // The package pauses its recording when a call or Siri takes the audio
  // (its default); this app never pauses, so a pause is an interruption
  // (D79 b). Asked for at once, so the package listens from the start.
  @override
  late final Stream<void> interruptions = _recorder.onStateChanged().where((s) => s == RecordState.pause);

  @override
  Future<bool> allowed() => _recorder.hasPermission();

  @override
  Future<Stream<Uint8List>> start() => _recorder.startStream(
    const RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: sampleRate,
      numChannels: 1,
      iosConfig: IosRecordConfig(categoryOptions: []),
    ),
  );

  @override
  Future<void> stop() async {
    await _recorder.stop();
  }
}
