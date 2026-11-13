// The phone's microphone, as recording needs it (D69): sixteen-bit
// little-endian PCM, 16 kHz, one channel, handed on as it comes and never
// written anywhere. One implementation uses the `record` package
// (D71 Q14, Q15); tests use their own.
import 'dart:math' as math;
import 'dart:typed_data';

/// The audio's rate, as Soniox is told it.
const sampleRate = 16000;

abstract interface class Microphone {
  /// Whether the microphone may be used; the first time, the phone asks
  /// the dreamer, with EM·3.
  Future<bool> allowed();

  /// Starts the microphone: its frames, as they come.
  Future<Stream<Uint8List>> start();

  Future<void> stop();
}

/// How loud a frame of PCM is, from 0 to 1 (its root mean square), for
/// the level line.
double level(Uint8List frame) {
  final samples = frame.length ~/ 2;
  if (samples == 0) return 0;
  final data = ByteData.sublistView(frame);
  var sum = 0.0;
  for (var i = 0; i < samples; i++) {
    final s = data.getInt16(i * 2, Endian.little) / 32768;
    sum += s * s;
  }
  return math.min(1, math.sqrt(sum / samples));
}
