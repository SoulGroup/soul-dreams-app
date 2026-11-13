// One recording (D69, as D71 corrects it): it starts only with the
// microphone allowed, a key and a stream; the frames go to Soniox as they
// come and nowhere else; the words come back; a stop waits for the last
// words; a break keeps the words shown; each failure logs a code.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/recording/key_client.dart';
import 'package:souldreams/recording/recording.dart';
import 'package:souldreams/recording/soniox.dart';

import 'fakes.dart';

void main() {
  final tokens = inventedTokens();
  final beta = 'Ab0' * 16;
  late List<String> lines;
  late void Function(String) sink;
  setUp(() {
    lines = [];
    sink = SafeLog.sink;
    SafeLog.sink = lines.add;
  });
  tearDown(() => SafeLog.sink = sink);

  ({RecordingSession session, List<(String, String)> heard, List<double> levels, List<int> ended}) make(
    Recording recording,
  ) {
    final heard = <(String, String)>[];
    final levels = <double>[];
    final ended = <int>[];
    final session = RecordingSession(
      recording,
      onHeard: (f, p) => heard.add((f, p)),
      onLevel: levels.add,
      onEnded: () => ended.add(1),
    );
    return (session: session, heard: heard, levels: levels, ended: ended);
  }

  Recording memory(SilentMicrophone mic, MemoryLink link, {bool on = true, Future<String> Function()? key}) =>
      Recording(on: on, microphone: mic, key: key ?? () async => 'temporary-key-in-a-test', connect: (_) async => link);

  test('off: nothing asked, a code', () async {
    final mic = SilentMicrophone();
    final r = make(memory(mic, MemoryLink(), on: false));
    expect(await r.session.start(), isFalse);
    expect(lines, ['recordingOff']);
    expect(mic.running, isFalse);
  });

  test('live: off with no server address, or a misshapen beta key', () {
    final mic = SilentMicrophone();
    expect(Recording.live(microphone: mic, betaKey: beta, server: '').on, isFalse);
    expect(Recording.live(microphone: mic, betaKey: beta.substring(1), server: 'x').on, isFalse);
    expect(Recording.live(microphone: mic, betaKey: '$beta-'.substring(1), server: 'x').on, isFalse);
    expect(Recording.live(microphone: mic, betaKey: beta, server: 'x').on, isTrue);
  });

  test('the microphone refused: no key asked, a code', () async {
    var asked = 0;
    final mic = SilentMicrophone()..allow = false;
    final r = make(memory(mic, MemoryLink(), key: () async => '${asked++}'));
    expect(await r.session.start(), isFalse);
    expect(asked, 0);
    expect(lines, ['recordingRefused']);
  });

  test('no key: the microphone does not start, the status logged', () async {
    final mic = SilentMicrophone();
    final r = make(memory(mic, MemoryLink(), key: () async => throw const KeyFailure(401)));
    expect(await r.session.start(), isFalse);
    expect(mic.running, isFalse);
    expect(lines, ['recordingKeyFailed 401']);
  });

  test('no stream: the microphone does not start, a code', () async {
    final mic = SilentMicrophone();
    final r = make(
      Recording(on: true, microphone: mic, key: () async => 'k', connect: (_) async => throw StateError('x')),
    );
    expect(await r.session.start(), isFalse);
    expect(mic.running, isFalse);
    expect(lines, ['recordingStreamFailed 0']);
  });

  test('the microphone failing: the stream closed, a code', () async {
    final mic = SilentMicrophone()..fails = true;
    final link = MemoryLink();
    final r = make(memory(mic, link));
    expect(await r.session.start(), isFalse);
    expect(link.closed, isTrue);
    expect(lines, ['recordingMicFailed', 'recordingEnded']);
  });

  test('frames go to Soniox as they come; their level shown', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    expect(await r.session.start(), isTrue);
    mic.frame();
    mic.frame(16384);
    await pumpEventQueue();
    expect(link.sent, hasLength(2));
    expect((link.sent[1] as Uint8List).length, 3200);
    expect(r.levels, [0, 0.5]);
    expect(lines, ['recordingStarted']);
  });

  test('words come back; a stop waits for the last ones', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await pumpEventQueue();
    expect(r.heard, [(tokens[0], tokens[1])]);
    final stopping = r.session.stop();
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(link.sent.last, '');
    expect(r.ended, isEmpty);
    link.reply(reply(done: [tokens[1]]));
    link.reply(reply(finished: true));
    await stopping;
    expect(r.heard, [(tokens[0], tokens[1]), (tokens[1], ''), ('', '')]);
    expect(link.closed, isTrue);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingEnded']);
  });

  test('a stop waits for the last words five seconds at most', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    expect(r.session.wait, const Duration(seconds: 5));
    final quick = RecordingSession(
      memory(mic, link),
      onHeard: (_, _) {},
      onLevel: (_) {},
      onEnded: () {},
      wait: const Duration(milliseconds: 200),
    );
    await quick.start();
    final clock = Stopwatch()..start();
    await quick.stop();
    expect(clock.elapsedMilliseconds, greaterThanOrEqualTo(200));
    expect(link.closed, isTrue);
  });

  test("Soniox's error: the microphone stops, the words stay, its code", () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    link.reply(reply(done: [tokens[0]]));
    link.reply('{"error_code":402,"error_message":"x"}');
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.heard, [(tokens[0], '')]);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingStreamFailed 402', 'recordingEnded']);
  });

  test('the stream closing early: the microphone stops, its close code', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    await link.drop(1011);
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
  });

  test('cancel ends at once; a cancel while starting opens nothing', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final key = Completer<String>();
    final r = make(memory(mic, link, key: () => key.future));
    final started = r.session.start();
    await r.session.cancel();
    key.complete('k');
    expect(await started, isFalse);
    expect(mic.running, isFalse);
    final r2 = make(memory(SilentMicrophone(), MemoryLink()));
    await r2.session.start();
    await r2.session.cancel();
    expect(r2.ended, [1]);
  });

  test('end to end on loopback: the door, Soniox, the words', () async {
    final door = await FakeDoor.start();
    final soniox = await FakeSoniox.start();
    addTearDown(door.stop);
    addTearDown(soniox.stop);
    soniox.script = (s, message) {
      if (message is List<int>) s.send(reply(done: [tokens[s.frames.length - 1]]));
      if (message == '') {
        s.send(reply(finished: true));
        s.socket!.close();
      }
    };
    final mic = SilentMicrophone();
    final r = make(
      Recording(
        on: true,
        microphone: mic,
        key: () => fetchKey(door.url, beta),
        connect: (key) => SocketLink.open(soniox.url, key),
      ),
    );
    expect(await r.session.start(), isTrue);
    for (var i = 0; i < 3; i++) {
      mic.frame();
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    await r.session.stop();
    expect(soniox.headers['authorization'], ['Bearer temporary-key-in-a-test']);
    expect(soniox.frames, hasLength(3));
    expect([for (final h in r.heard) h.$1].join(), tokens.take(3).join());
    expect(lines, ['recordingStarted', 'recordingEnded']);
  });
}
