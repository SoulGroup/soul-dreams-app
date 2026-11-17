// The microphone through the record package (D71 Q14, Q15), and the
// phone's audio given back when a recording ends (D79 c): the session is
// deactivated with notify-others, through the Swift channel in
// ios/Runner/AppDelegate.swift, so music paused by a recording resumes.
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:record/record.dart';
import 'package:souldreams/recording/record_microphone.dart';

/// The package's recorder, played: each call is noted in [calls].
final class PlayedRecorder implements AudioRecorder {
  PlayedRecorder(this.calls);

  final List<String> calls;
  bool startFails = false;
  bool stopFails = false;

  @override
  Future<Stream<Uint8List>> startStream(RecordConfig config) async {
    calls.add('start');
    if (startFails) throw StateError('start');
    return const Stream<Uint8List>.empty();
  }

  @override
  Future<String?> stop() async {
    calls.add('stop');
    if (stopFails) throw StateError('stop');
    return null;
  }

  @override
  Stream<RecordState> onStateChanged() => const Stream<RecordState>.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<String> calls;
  late PlayedRecorder recorder;
  var releaseFails = false;

  setUp(() {
    calls = [];
    releaseFails = false;
    recorder = PlayedRecorder(calls);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel(audioSessionChannel),
      (call) async {
        calls.add(call.method);
        if (releaseFails) throw PlatformException(code: 'audio-session');
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel(audioSessionChannel),
      null,
    );
  });

  test('a stop gives the audio back after the recorder stops', () async {
    final mic = RecordMicrophone(recorder: recorder);
    await mic.start();
    await mic.stop();
    expect(calls, ['start', 'stop', 'release']);
  });

  test('a recorder that fails to stop still gives the audio back', () async {
    final mic = RecordMicrophone(recorder: recorder..stopFails = true);
    await expectLater(mic.stop(), throwsStateError);
    expect(calls, ['stop', 'release']);
  });

  test('a start that fails gives the audio back', () async {
    final mic = RecordMicrophone(recorder: recorder..startFails = true);
    await expectLater(mic.start(), throwsStateError);
    expect(calls, ['start', 'release']);
  });

  test('a failed start whose release fails too reports the start', () async {
    releaseFails = true;
    final mic = RecordMicrophone(recorder: recorder..startFails = true);
    await expectLater(mic.start(), throwsStateError);
    expect(calls, ['start', 'release']);
  });
}
