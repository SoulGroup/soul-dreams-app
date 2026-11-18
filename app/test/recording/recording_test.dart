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

  ({
    RecordingSession session,
    List<(String, String)> heard,
    List<double> levels,
    List<int> ended,
    List<int> stopping,
  })
  make(Recording recording) {
    final heard = <(String, String)>[];
    final levels = <double>[];
    final ended = <int>[];
    final stopping = <int>[];
    final session = RecordingSession(
      recording,
      onHeard: (f, p) => heard.add((f, p)),
      onLevel: levels.add,
      onStopping: () => stopping.add(1),
      onEnded: () => ended.add(1),
    );
    return (session: session, heard: heard, levels: levels, ended: ended, stopping: stopping);
  }

  Recording memory(SilentMicrophone mic, MemoryLink link, {bool on = true, Future<String> Function()? key}) =>
      Recording(on: on, microphone: mic, key: key ?? () async => 'temporary-key-in-a-test', connect: (_) async => link);

  // A recording whose key or stream the test holds back.
  Recording held(SilentMicrophone mic, {Completer<String>? key, Completer<SonioxLink>? link, List<int>? connects}) =>
      Recording(
        on: true,
        microphone: mic,
        key: () => key != null ? key.future : Future.value('k'),
        connect: (_) {
          connects?.add(1);
          return link != null ? link.future : Future.value(MemoryLink());
        },
      );

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

  // D88: the microphone starts at once, before the key and the stream; a
  // key or a stream that then fails stops the recording as a broken stream
  // does (D71), holding nothing.
  test('no key: it stops as a broken stream does, a code', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link, key: () async => throw const KeyFailure(401)));
    expect(await r.session.start(), isTrue);
    mic.frame();
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(link.sent, isEmpty);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingKeyFailed 401', 'recordingEnded']);
  });

  test('no stream: it stops as a broken stream does, a code', () async {
    final mic = SilentMicrophone();
    final r = make(
      Recording(on: true, microphone: mic, key: () async => 'k', connect: (_) async => throw StateError('x')),
    );
    expect(await r.session.start(), isTrue);
    mic.frame();
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingStreamFailed 0', 'recordingEnded']);
  });

  test('the microphone starts at once; held audio goes first, in order', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final key = Completer<String>();
    final r = make(memory(mic, link, key: () => key.future));
    expect(await r.session.start(), isTrue);
    expect(mic.running, isTrue);
    for (final value in [1, 2, 3]) {
      mic.frame(value);
    }
    await pumpEventQueue();
    expect(link.sent, isEmpty);
    expect(r.levels, hasLength(3));
    key.complete('k');
    await pumpEventQueue();
    mic.frame(4);
    await pumpEventQueue();
    expect([for (final f in link.sent) ByteData.sublistView(f as Uint8List).getInt16(0, Endian.little)], [1, 2, 3, 4]);
  });

  test('the microphone failing: no key asked, a code', () async {
    var asked = 0;
    final mic = SilentMicrophone()..fails = true;
    final r = make(memory(mic, MemoryLink(), key: () async => '${asked++}'));
    expect(await r.session.start(), isFalse);
    await pumpEventQueue();
    expect(asked, 0);
    expect(lines, ['recordingMicFailed']);
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
    expect(mic.stops, 1);
    expect(link.closed, isTrue);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingEnded']);
  });

  // D79 b: a call or Siri stops the recording as Stop does.
  test('an interruption stops as Stop does, the words kept, a code', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    link.reply(reply(done: [tokens[0]], shown: [tokens[1]]));
    await pumpEventQueue();
    mic.interrupt();
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(link.sent.last, '');
    expect(r.ended, isEmpty);
    link.reply(reply(done: [tokens[1]]));
    link.reply(reply(finished: true));
    await pumpEventQueue();
    expect(r.heard, [(tokens[0], tokens[1]), (tokens[1], ''), ('', '')]);
    expect(mic.stops, 1);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingInterrupted', 'recordingEnded']);
  });

  // D83: the page is told the moment a stop begins, once, before the last
  // words; its clock stops there.
  test('a stop and an interruption each say so at once, once', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    final stopping = r.session.stop();
    await pumpEventQueue();
    expect(r.stopping, [1]);
    expect(r.ended, isEmpty);
    unawaited(r.session.stop());
    link.reply(reply(finished: true));
    await stopping;
    expect(r.stopping, [1]);
    final mic2 = SilentMicrophone();
    final r2 = make(memory(mic2, MemoryLink()));
    await r2.session.start();
    mic2.interrupt();
    await pumpEventQueue();
    expect(r2.stopping, [1]);
    expect(r2.ended, isEmpty);
    // A stop after the session ended by itself says nothing.
    final link3 = MemoryLink();
    final r3 = make(memory(SilentMicrophone(), link3));
    await r3.session.start();
    await link3.drop(1006);
    await pumpEventQueue();
    await r3.session.stop();
    expect(r3.ended, [1]);
    expect(r3.stopping, isEmpty);
  });

  test('an interruption during a stop, or after the end, changes nothing', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    final stopping = r.session.stop();
    await pumpEventQueue();
    mic.interrupt();
    await pumpEventQueue();
    link.reply(reply(finished: true));
    await stopping;
    mic.interrupt();
    await pumpEventQueue();
    expect(mic.stops, 1);
    expect(link.sent.where((m) => m == ''), hasLength(1));
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
      onStopping: () {},
      onEnded: () {},
      wait: const Duration(milliseconds: 200),
    );
    await quick.start();
    final clock = Stopwatch()..start();
    await quick.stop();
    expect(clock.elapsedMilliseconds, greaterThanOrEqualTo(200));
    expect(mic.stops, 1);
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
    expect(mic.stops, 1);
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
    expect(mic.stops, 1);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
  });

  test('a cancel before the stream opens sends nothing', () async {
    final mic = SilentMicrophone();
    final key = Completer<String>();
    final connects = <int>[];
    final r = make(held(mic, key: key, connects: connects));
    expect(await r.session.start(), isTrue);
    mic.frame();
    await r.session.cancel();
    key.complete('k');
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(connects, isEmpty);
    expect(r.ended, [1]);
    final mic2 = SilentMicrophone();
    final r2 = make(memory(mic2, MemoryLink()));
    await r2.session.start();
    await r2.session.cancel();
    expect(r2.ended, [1]);
    expect(mic2.stops, 1);
  });


  // D73 (the review of Task 7): an ended session leaves nothing running;
  // D88: a stop before the stream opens still sends the held audio first.
  test('a stop while the key comes: held audio, then the end', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final key = Completer<String>();
    final r = make(held(mic, key: key, link: Completer<SonioxLink>()..complete(link)));
    expect(await r.session.start(), isTrue);
    mic.frame(1);
    mic.frame(2);
    await pumpEventQueue();
    final stopping = r.session.stop();
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.stopping, [1]);
    key.complete('k');
    await pumpEventQueue();
    expect(link.sent, hasLength(3));
    expect(link.sent.last, '');
    link.reply(reply(done: [tokens[0]], finished: true));
    await stopping;
    expect(r.heard.first, (tokens[0], ''));
    expect(r.ended, [1]);
  });

  test('a stop while the stream opens: held audio, then the end', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final opening = Completer<SonioxLink>();
    final r = make(held(mic, link: opening));
    expect(await r.session.start(), isTrue);
    mic.frame();
    await pumpEventQueue();
    final stopping = r.session.stop();
    await pumpEventQueue();
    opening.complete(link);
    await pumpEventQueue();
    expect(link.sent, hasLength(2));
    expect(link.sent.last, '');
    link.reply(reply(finished: true));
    await stopping;
    expect(r.ended, [1]);
  });

  test('a stream not open in time: the stop ends, holding nothing', () async {
    final mic = SilentMicrophone();
    final key = Completer<String>();
    final connects = <int>[];
    final quick = RecordingSession(
      held(mic, key: key, connects: connects),
      onHeard: (_, _) {},
      onLevel: (_) {},
      onStopping: () {},
      onEnded: () {},
      wait: const Duration(milliseconds: 200),
    );
    expect(await quick.start(), isTrue);
    mic.frame();
    await quick.stop().timeout(const Duration(seconds: 1));
    key.complete('k');
    await pumpEventQueue();
    expect(connects, isEmpty);
    expect(mic.running, isFalse);
  });

  test('a cancel while the stream opens closes it on arrival', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final opening = Completer<SonioxLink>();
    final r = make(held(mic, link: opening));
    expect(await r.session.start(), isTrue);
    mic.frame();
    await pumpEventQueue();
    await r.session.cancel();
    opening.complete(link);
    await pumpEventQueue();
    expect(link.closed, isTrue);
    expect(link.sent, isEmpty);
  });


  test('a cancel while the microphone starts: stopped once on arrival', () async {
    final mic = SilentMicrophone()..startHold = Completer<void>();
    final connects = <int>[];
    final r = make(held(mic, connects: connects));
    final started = r.session.start();
    await pumpEventQueue();
    await r.session.cancel();
    mic.startHold!.complete();
    expect(await started, isFalse);
    expect(mic.stops, 1);
    expect(mic.running, isFalse);
    expect(connects, isEmpty);
    expect(r.ended, [1]);
  });

  test('a stop while the microphone starts: it never streams', () async {
    final mic = SilentMicrophone()..startHold = Completer<void>();
    final connects = <int>[];
    final r = make(held(mic, connects: connects));
    final started = r.session.start();
    await pumpEventQueue();
    await r.session.stop();
    mic.startHold!.complete();
    expect(await started, isFalse);
    expect(mic.stops, 1);
    expect(mic.running, isFalse);
    expect(connects, isEmpty);
    expect(r.ended, [1]);
    expect(lines, ['recordingEnded']);
  });

  test('a second stop is the first: one end frame', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    final first = r.session.stop();
    final second = r.session.stop();
    expect(identical(first, second), isTrue);
    await pumpEventQueue();
    link.reply(reply(finished: true));
    await Future.wait([first, second]);
    expect(link.sent.where((m) => m == ''), hasLength(1));
    expect(mic.stops, 1);
    expect(r.ended, [1]);
  });

  test('a break during a stop ends it at once', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    final stopping = r.session.stop();
    await pumpEventQueue();
    await link.drop(1011);
    await stopping.timeout(const Duration(seconds: 1));
    expect(mic.stops, 1);
    expect(r.ended, [1]);
  });

  // The review of 16h: a cancel ends a stop that waits for the stream (D75).
  test('a cancel ends a stop that waits for the stream', () async {
    final mic = SilentMicrophone();
    final key = Completer<String>();
    final r = make(held(mic, key: key));
    expect(await r.session.start(), isTrue);
    final stopping = r.session.stop();
    await pumpEventQueue();
    await r.session.cancel();
    await stopping.timeout(const Duration(seconds: 1));
    expect(r.ended, [1]);
    expect(mic.running, isFalse);
  });

  test('a cancel while a stop waits ends it at once', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    final stopping = r.session.stop();
    await pumpEventQueue();
    await r.session.cancel();
    await stopping.timeout(const Duration(seconds: 1));
    expect(mic.stops, 1);
    expect(r.ended, [1]);
  });

  test('a cancel after a stop changes nothing', () async {
    final mic = SilentMicrophone();
    final link = MemoryLink();
    final r = make(memory(mic, link));
    await r.session.start();
    final stopping = r.session.stop();
    await pumpEventQueue();
    link.reply(reply(finished: true));
    await stopping;
    await r.session.cancel();
    expect(mic.stops, 1);
    expect(r.ended, [1]);
    expect(lines, ['recordingStarted', 'recordingEnded']);
  });

  test('a close that never completes holds nothing up', () async {
    for (final stop in [false, true]) {
      final mic = SilentMicrophone();
      final link = MemoryLink()..closeHangs = true;
      final r = make(memory(mic, link));
      await r.session.start();
      await pumpEventQueue();
      final ending = stop ? r.session.stop() : r.session.cancel();
      await pumpEventQueue();
      if (stop) link.reply(reply(finished: true));
      await ending.timeout(const Duration(seconds: 1));
      expect(r.ended, [1]);
      expect(link.closed, isTrue);
      expect(mic.stops, 1);
    }
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

  // D88: a key fetched in advance when the typing screen opens, used once,
  // only while fresh; else, or if it failed, the tap fetches one.
  Recording counted(List<int> fetches, {DateTime Function()? now, bool fails = false}) => Recording(
    on: true,
    microphone: SilentMicrophone(),
    key: () async {
      fetches.add(1);
      if (fails && fetches.length == 1) throw const KeyFailure(0);
      return 'k${fetches.length}';
    },
    connect: (_) async => MemoryLink(),
    now: now,
  );

  test('a key fetched in advance is used once', () async {
    final fetches = <int>[];
    final recording = counted(fetches);
    recording.warm();
    expect(fetches, hasLength(1));
    expect(await recording.takeKey(), 'k1');
    expect(await recording.takeKey(), 'k2');
    expect(fetches, hasLength(2));
  });

  test('a key older than its freshness is never used', () async {
    final fetches = <int>[];
    var now = DateTime(2026);
    final recording = counted(fetches, now: () => now);
    recording.warm();
    now = now.add(keyFresh);
    expect(await recording.takeKey(), 'k2');
  });

  test('a key fetched in advance that failed: the tap fetches again', () async {
    final fetches = <int>[];
    final recording = counted(fetches, fails: true);
    recording.warm();
    await pumpEventQueue();
    expect(await recording.takeKey(), 'k2');
  });

  test('a session takes the key fetched in advance', () async {
    final fetches = <int>[];
    final recording = counted(fetches);
    recording.warm();
    final r = make(recording);
    expect(await r.session.start(), isTrue);
    await pumpEventQueue();
    expect(fetches, hasLength(1));
  });

  // Offline recording (D92 to D94): every recording's audio is kept from its
  // first frame; all final, it is deleted at once; else it waits from the
  // last final word.
  ({
    RecordingSession session,
    List<(String, String)> heard,
    List<Trouble> troubles,
    List<int> ended,
    List<int> cleared,
  }) kept(
    SilentMicrophone mic,
    MemoryKeep keep, {
    MemoryLink? link,
    FakeConnection? connection,
    Future<String> Function()? key,
    int cap = recordingCap,
  }) {
    final heard = <(String, String)>[];
    final troubles = <Trouble>[];
    final ended = <int>[];
    final cleared = <int>[];
    final recording = Recording(
      on: true,
      microphone: mic,
      key: key ?? () async => 'k',
      connect: (_) async => link ?? MemoryLink(),
      keep: keep,
      connection: connection,
      cap: cap,
    );
    final session = RecordingSession(
      recording,
      onHeard: (f, p) => heard.add((f, p)),
      onLevel: (_) {},
      onStopping: () {},
      onEnded: () => ended.add(1),
      onTrouble: troubles.add,
      onTroubleOver: () => cleared.add(1),
      wait: const Duration(milliseconds: 200),
    );
    return (session: session, heard: heard, troubles: troubles, ended: ended, cleared: cleared);
  }

  // [n] frames of a tenth of a second, each its own value.
  Future<void> frames(SilentMicrophone mic, int n, [int first = 1]) async {
    for (var i = 0; i < n; i++) {
      mic.frame(first + i);
    }
    await pumpEventQueue();
  }

  int firstSample(List<int> bytes, int at) =>
      ByteData.sublistView(Uint8List.fromList(bytes)).getInt16(at, Endian.little);

  test('every frame is kept in order; all final, deleted at once', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final link = MemoryLink();
    final r = kept(mic, keep, link: link);
    expect(await r.session.start(), isTrue);
    await frames(mic, 12);
    final id = keep.audio.keys.single;
    expect(keep.audio[id], hasLength(32000));
    expect(firstSample(keep.audio[id]!, 0), 1);
    expect(firstSample(keep.audio[id]!, 31998), 10);
    final stopped = r.session.stop();
    await pumpEventQueue();
    // Finished means every word is final, whatever the count says.
    link.reply(reply(done: [tokens[0]], finalMs: 1000, finished: true));
    await stopped;
    expect(keep.discarded, [id]);
    expect(r.session.left, isNull);
    expect(r.troubles, isEmpty);
  });

  test('no connection at the tap: no key, MP·15, it all waits', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    var asked = 0;
    final r = kept(mic, keep, connection: FakeConnection()..online = false, key: () async => '${asked++}');
    expect(await r.session.start(), isTrue);
    expect(r.troubles, [Trouble.offline]);
    await frames(mic, 5);
    await r.session.stop();
    await pumpEventQueue();
    expect(asked, 0);
    final id = keep.audio.keys.single;
    expect(keep.audio[id], hasLength(16000));
    expect(keep.ended, [id]);
    expect(r.session.left, (audio: id, from: 0));
    expect(lines, ['recordingStarted', 'recordingOffline', 'recordingEnded']);
  });

  test('a key that fails: it goes on, MP·54, it all waits', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final r = kept(mic, keep, key: () async => throw const KeyFailure(502));
    expect(await r.session.start(), isTrue);
    await frames(mic, 3);
    expect(mic.running, isTrue);
    expect(r.troubles, [Trouble.broke]);
    expect(r.ended, isEmpty);
    await frames(mic, 3, 4);
    await r.session.stop();
    await pumpEventQueue();
    final id = keep.audio.keys.single;
    expect(keep.audio[id], hasLength(19200));
    expect(r.session.left, (audio: id, from: 0));
    expect(lines, ['recordingStarted', 'recordingKeyFailed 502', 'recordingEnded']);
  });

  test('a break: final words stay; the rest waits from Soniox\'s count', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final link = MemoryLink();
    final r = kept(mic, keep, link: link);
    expect(await r.session.start(), isTrue);
    await frames(mic, 4);
    link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 200));
    await pumpEventQueue();
    await link.drop(1011);
    await pumpEventQueue();
    expect(mic.running, isTrue);
    expect(r.troubles, [Trouble.broke]);
    expect(r.heard, [(tokens[0], tokens[1]), ('', '')]);
    final sent = link.sent.length;
    await frames(mic, 2, 5);
    expect(link.sent, hasLength(sent));
    await r.session.stop();
    await pumpEventQueue();
    final id = keep.audio.keys.single;
    expect(keep.audio[id], hasLength(19200));
    expect(r.session.left, (audio: id, from: 6400));
    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'recordingEnded']);
  });

  test('a stop whose last words never all come: the rest waits', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final link = MemoryLink();
    final r = kept(mic, keep, link: link);
    expect(await r.session.start(), isTrue);
    await frames(mic, 4);
    link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 100));
    await r.session.stop();
    final id = keep.audio.keys.single;
    expect(r.session.left, (audio: id, from: 3200));
    expect(r.heard.last, ('', ''));
    expect(keep.discarded, isEmpty);
  });

  test('a cancel mid-stream: the rest waits; unsettled words leave', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final link = MemoryLink();
    final r = kept(mic, keep, link: link);
    expect(await r.session.start(), isTrue);
    await frames(mic, 4);
    link.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 300));
    await pumpEventQueue();
    await r.session.cancel();
    final id = keep.audio.keys.single;
    expect(r.session.left, (audio: id, from: 9600));
    expect(r.heard.last, ('', ''));
    expect(keep.ended, [id]);
  });

  test('nothing past the final words: deleted, nothing waits', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final link = MemoryLink();
    final r = kept(mic, keep, link: link);
    expect(await r.session.start(), isTrue);
    await frames(mic, 2);
    link.reply(reply(done: [tokens[0]], finalMs: 900));
    await pumpEventQueue();
    await link.drop(1011);
    await pumpEventQueue();
    await r.session.stop();
    expect(r.session.left, isNull);
    expect(keep.discarded, hasLength(1));
  });

  test('at the cap it stops itself as Stop does, a code', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final r = kept(mic, keep, connection: FakeConnection()..online = false, cap: 9600);
    expect(await r.session.start(), isTrue);
    await frames(mic, 2);
    expect(mic.running, isTrue);
    await frames(mic, 1, 3);
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.ended, [1]);
    expect(r.session.left, (audio: keep.audio.keys.single, from: 0));
    expect(lines, ['recordingStarted', 'recordingOffline', 'recordingCapped', 'recordingEnded']);
  });

  test('every recording stops at ten minutes (D93 Q6)', () {
    expect(recordingCap, 10 * 60 * 16000 * 2);
    expect(Recording(on: true, microphone: SilentMicrophone(), key: () async => 'k', connect: (_) async => MemoryLink())
        .cap, recordingCap);
  });

  test('a keep that fails: a code; a break stops it', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep()..fails = true;
    final link = MemoryLink();
    final r = kept(mic, keep, link: link);
    expect(await r.session.start(), isTrue);
    await frames(mic, 11);
    await link.drop(1011);
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.troubles, isEmpty);
    expect(r.session.left, isNull);
    expect(lines, ['recordingStarted', 'audioKeepFailed', 'recordingStreamFailed 1011', 'recordingEnded']);
  });

  // D96 Q1: a keep that fails once the recording is cut (no stream, or none
  // at all) stops it as a broken stream does, one code, and the notice
  // (MP·15 or MP·54, "it stays on your phone") goes.
  test('keep fails when offline: stops, one code, notice goes', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep()..fails = true;
    final r = kept(mic, keep, connection: FakeConnection()..online = false);
    expect(await r.session.start(), isTrue);
    expect(r.troubles, [Trouble.offline]);
    await frames(mic, 11);
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.ended, [1]);
    expect(r.cleared, [1]);
    expect(r.session.left, isNull);
    expect(keep.discarded, hasLength(1));
    expect(lines, ['recordingStarted', 'recordingOffline', 'audioKeepFailed', 'recordingEnded']);
  });

  test('keep fails after a break: stops, one code, notice goes', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final link = MemoryLink();
    final r = kept(mic, keep, link: link);
    expect(await r.session.start(), isTrue);
    await frames(mic, 5);
    await link.drop(1011);
    await pumpEventQueue();
    expect(r.troubles, [Trouble.broke]);
    expect(mic.running, isTrue);
    keep.fails = true;
    await frames(mic, 12, 6);
    await pumpEventQueue();
    expect(mic.running, isFalse);
    expect(r.ended, [1]);
    expect(r.cleared, [1]);
    expect(r.session.left, isNull);
    expect(lines, ['recordingStarted', 'recordingStreamFailed 1011', 'audioKeepFailed', 'recordingEnded']);
  });

  test('keep fails with a live stream: it goes on', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep()..fails = true;
    final r = kept(mic, keep);
    expect(await r.session.start(), isTrue);
    await frames(mic, 11);
    expect(mic.running, isTrue);
    expect(r.cleared, isEmpty);
    expect(r.ended, isEmpty);
  });

  // The last write is waited for: a recording is left waiting only when all
  // its audio really was kept (D92; D96).
  test('last write fails: nothing waits, audio deleted, one code', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep()..failsLast = true;
    final r = kept(mic, keep, connection: FakeConnection()..online = false);
    expect(await r.session.start(), isTrue);
    await frames(mic, 5);
    await r.session.stop();
    await pumpEventQueue();
    expect(r.session.left, isNull);
    expect(keep.discarded, hasLength(1));
    expect(r.cleared, [1]);
    expect(lines, ['recordingStarted', 'recordingOffline', 'audioKeepFailed', 'recordingEnded']);
  });

  test('a failed write: no later write, no gap, no half sample', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep()..gate = Completer<void>();
    final r = kept(mic, keep);
    expect(await r.session.start(), isTrue);
    await frames(mic, 22);
    expect(keep.calls, 1);
    keep.fails = true;
    keep.gate!.complete();
    await pumpEventQueue();
    await frames(mic, 5, 23);
    expect(keep.calls, 1);
    expect(keep.audio, isEmpty);
    expect(lines, ['recordingStarted', 'audioKeepFailed']);
  });

  test('the writes go one at a time, in order', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep()..gate = Completer<void>();
    final r = kept(mic, keep);
    expect(await r.session.start(), isTrue);
    await frames(mic, 22);
    expect(keep.calls, 1);
    keep.gate!.complete();
    await pumpEventQueue();
    expect(keep.calls, 2);
    final id = keep.audio.keys.single;
    expect(keep.audio[id], hasLength(64000));
    expect(firstSample(keep.audio[id]!, 0), 1);
    expect(firstSample(keep.audio[id]!, 32000), 11);
  });

  // A stop that finds the session already ending (a cancel while it waited,
  // the app left during a Save) returns only when the ending is done: what
  // waits is known by then, so a Save never misses it.
  test('cancel during a stop: it returns with what waits known', () async {
    final mic = SilentMicrophone();
    final keep = MemoryKeep();
    final r = kept(mic, keep, link: MemoryLink());
    expect(await r.session.start(), isTrue);
    await frames(mic, 5);
    final stopping = r.session.stop();
    await pumpEventQueue();
    unawaited(r.session.cancel());
    await stopping.timeout(const Duration(seconds: 1));
    expect(r.ended, [1]);
    final id = keep.audio.keys.single;
    expect(r.session.left, (audio: id, from: 0));
  });

  test('refused or off: no audio, no id', () async {
    final keep = MemoryKeep();
    final refused = kept(SilentMicrophone()..allow = false, keep);
    expect(await refused.session.start(), isFalse);
    expect(refused.troubles, [Trouble.refused]);
    expect(keep.audio, isEmpty);
    expect(keep.newId(), '1'.padLeft(32, '0'));
  });

  test('keeping makes the same recording, with the keep', () {
    final mic = SilentMicrophone();
    final connection = FakeConnection();
    final keep = MemoryKeep();
    final plain = Recording(
      on: true,
      microphone: mic,
      key: () async => 'k',
      connect: (_) async => MemoryLink(),
      connection: connection,
      cap: 64,
    );
    final kept = plain.keeping(keep);
    expect(kept.keep, same(keep));
    expect(plain.keep, isNull);
    expect([kept.on, kept.microphone, kept.connection, kept.cap], [true, mic, connection, 64]);
    expect(kept.key, same(plain.key));
    expect(kept.connect, same(plain.connect));
  });
}
