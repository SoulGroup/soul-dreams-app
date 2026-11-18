// Recordings waiting on the phone, replayed through Soniox's real-time
// stream (D92 items 2 and 3; D94): a fresh key each time, the saved audio
// at real-time pace from where its words stopped, one at a time, the
// oldest night first, only while the app is open and no typing screen is;
// progress kept when a retry is cut short; the words a dream of their own
// in the recording's place (D93 Q2), the audio deleted at once.
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal_audio.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/recording/key_client.dart';
import 'package:souldreams/recording/recording.dart';
import 'package:souldreams/recording/retries.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';
import 'fakes.dart';

/// [n] bytes of made-up audio, every byte telling its place.
Uint8List sound(int n, [int from = 0]) => Uint8List.fromList([for (var i = from; i < from + n; i++) i % 251]);

/// The journal's audio, whose reads wait at [gate] once [open] reads have
/// gone through.
class Gated implements WaitingAudio {
  Gated(this._inner);

  final WaitingAudio _inner;
  int open = 1 << 30;
  Completer<void>? gate;
  int reads = 0;

  @override
  Future<List<Pending>> waiting() => _inner.waiting();

  @override
  Future<({int start, int size})?> part(String audio) => _inner.part(audio);

  @override
  Future<Uint8List> read(String audio, int start, int at, int length) async {
    if (reads++ >= open) await gate?.future;
    return _inner.read(audio, start, at, length);
  }

  @override
  Future<void> heard(Pending pending, String words, int to, {required bool done}) =>
      _inner.heard(pending, words, to, done: done);
}

/// The journal's audio, whose recording has no audio left, and which never
/// takes what it is told.
final class Deaf extends Gated {
  Deaf(super.inner);

  @override
  Future<({int start, int size})?> part(String audio) async => null;

  @override
  Future<void> heard(Pending pending, String words, int to, {required bool done}) async {}
}

void main() {
  final tokens = inventedTokens();
  final (x, y) = ('1' * 32, '2' * 32);
  late MemoryJournalFiles files;
  late JournalStore store;
  late Gated audio;
  late List<MemoryLink> links;
  late List<String> lines;
  late void Function(String) sink;
  late Future<String> Function() key;
  late FakeConnection connection;
  late Night first;
  late Night second;

  setUp(() async {
    lines = [];
    sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    JournalStore.newQueueForTests();
    files = MemoryJournalFiles();
    store = await JournalStore.open(files);
    audio = Gated(JournalAudio(store));
    links = [];
    key = () async => 'k';
    connection = FakeConnection();
    [first, second, ...] = nightsFromFixtures();
  });

  // A retry a test leaves running waits out Soniox's last words and then logs
  // a cut: into the next test's lines. Each is ended here, and finishes, before
  // the log goes back.
  final made = <Retries>[];

  tearDown(() async {
    for (final r in made) {
      try {
        r.dispose();
      } on Object {
        // Its test disposed it.
      }
    }
    made.clear();
    await pumpEventQueue();
    SafeLog.sink = sink;
  });

  Retries retries({bool on = true, double pace = 0}) {
    final r = Retries(
      Recording(
        on: on,
        microphone: SilentMicrophone(),
        key: () => key(),
        connect: (_) async {
          final link = MemoryLink();
          links.add(link);
          return link;
        },
        connection: connection,
      ),
      audio,
      pace: pace,
      wait: const Duration(milliseconds: 100),
    );
    made.add(r);
    return r;
  }

  Future<void> waits(Night n, List<Dream> entries, Map<String, int> bytes) async {
    await store.save(n.withEntries(entries));
    for (final MapEntry(:key, :value) in bytes.entries) {
      await store.appendAudio(key, sound(value));
    }
  }

  Future<List<Dream>?> entries(Night n) async {
    for (final m in await store.nights()) {
      if (m.id == n.id) return m.entries;
    }
    return null;
  }

  List<Object> frames(MemoryLink link) => [for (final f in link.sent) if (f is Uint8List) f];

  test('a recording replayed whole becomes its dream; the audio goes', () async {
    await waits(first, [Told(first.dreams[0]), Waiting(x)], {x: 6400});
    final r = retries();
    final seen = <String?>[];
    r.addListener(() => seen.add(r.transcribing));
    r.kick();
    await pumpEventQueue();
    final link = links.single;
    expect(frames(link), [sound(3200), sound(3200, 3200)]);
    expect(link.sent.last, '');
    link.reply(reply(done: tokens.take(3).toList(), finalMs: 200, finished: true));
    await pumpEventQueue();
    expect(await entries(first), [Told(first.dreams[0]), Told(tokens.take(3).join().trimLeft())]);
    expect(files.files.keys.where((n) => n.contains(x)), isEmpty);
    expect(link.closed, isTrue);
    expect(r.transcribing, isNull);
    expect(seen.first, x);
    expect(lines, ['retryStarted', 'retryDone']);
  });

  // D94: cut short, the final words go in before the recording, the audio
  // they cover is cut away, and the next retry starts from there.
  test('leaving keeps the progress; back, it resumes at the cut', () async {
    await waits(first, [Waiting(x)], {x: 32000});
    audio
      ..open = 4
      ..gate = Completer<void>();
    final r = retries();
    r.kick();
    await pumpEventQueue();
    links.single.reply(reply(done: [tokens[0]], shown: [tokens[1]], finalMs: 300));
    await pumpEventQueue();
    r.away();
    audio.gate!.complete();
    await pumpEventQueue();
    expect(await entries(first), [Told(tokens[0].trimLeft()), Waiting(x, 9600)]);
    expect(files.files.keys.where((n) => n.startsWith('audio-')), [JournalStore.audioOf(x, 9600)]);
    expect(files.files[JournalStore.audioOf(x, 9600)], sound(22400, 9600));
    expect(lines, ['retryStarted', 'retryCut']);
    audio.open = 1 << 30;
    r.back();
    await pumpEventQueue();
    final again = links.last;
    expect(links, hasLength(2));
    expect(frames(again).first, sound(3200, 9600));
    expect(frames(again), hasLength(7));
    again.reply(reply(done: [tokens[1]], finalMs: 700, finished: true));
    await pumpEventQueue();
    expect(await entries(first), [Told(tokens[0].trimLeft()), Told(tokens[1].trimLeft())]);
    expect(files.files.keys.where((n) => n.startsWith('audio-')), isEmpty);
  });

  test('a broken stream keeps the progress, and waits for a chance', () async {
    await waits(first, [Waiting(x)], {x: 32000});
    audio
      ..open = 3
      ..gate = Completer<void>();
    final r = retries();
    r.kick();
    await pumpEventQueue();
    links.single.reply(reply(done: [tokens[0]], finalMs: 200));
    await pumpEventQueue();
    await links.single.drop(1011);
    audio.gate!.complete();
    await pumpEventQueue();
    expect(await entries(first), [Told(tokens[0].trimLeft()), Waiting(x, 6400)]);
    expect(links, hasLength(1));
    connection.set(true);
    await pumpEventQueue();
    expect(links, hasLength(2));
    expect(frames(links.last).first, sound(3200, 6400));
  });

  test('no key: nothing changes, a code; the next chance tries again', () async {
    await waits(first, [Waiting(x)], {x: 3200});
    key = () async => throw const KeyFailure(502);
    final r = retries();
    r.kick();
    await pumpEventQueue();
    expect(links, isEmpty);
    expect(await entries(first), [Waiting(x)]);
    expect(r.transcribing, isNull);
    expect(lines, ['retryStarted', 'retryFailed 502']);
    key = () async => 'k';
    r.kick();
    await pumpEventQueue();
    links.single.reply(reply(done: [tokens[0]], finished: true));
    await pumpEventQueue();
    expect(await entries(first), [Told(tokens[0].trimLeft())]);
  });

  test("Soniox's error: a code, nothing lost, tried again later", () async {
    await waits(first, [Waiting(x)], {x: 3200});
    final r = retries();
    r.kick();
    await pumpEventQueue();
    links.single.reply('{"tokens":[],"error_code":402}');
    await pumpEventQueue();
    expect(await entries(first), [Waiting(x)]);
    expect(lines, ['retryStarted', 'retryFailed 402', 'retryCut']);
  });

  // D96 Q4: a recording whose retry failed goes to the back of the queue,
  // never deleted, so the ones behind it get their turn.
  test('a failing recording does not hold back the two behind', () async {
    final z = '3' * 32;
    await waits(first, [Waiting(x), Waiting(y), Waiting(z)], {x: 3200, y: 3200, z: 3200});
    final r = retries();
    final seen = <String?>[];
    r.addListener(() => seen.add(r.transcribing));
    r.kick();
    await pumpEventQueue();
    links[0].reply('{"tokens":[],"error_code":402}');
    await pumpEventQueue();
    expect(links, hasLength(2));
    links[1].reply(reply(done: [tokens[0]], finished: true));
    await pumpEventQueue();
    expect(links, hasLength(3));
    links[2].reply(reply(done: [tokens[1]], finished: true));
    await pumpEventQueue();
    expect(await entries(first), [Waiting(x), Told(tokens[0].trimLeft()), Told(tokens[1].trimLeft())]);
    expect(files.files.keys.where((n) => n.contains(x)), isNotEmpty);
    expect(r.transcribing, isNull);
    expect(seen.indexOf(x), lessThan(seen.indexOf(null)));
    expect(seen.indexOf(null), lessThan(seen.indexOf(y)));
    expect(lines.where((l) => l == 'retryFailed 402'), hasLength(1));
    // The next chance tries it again, and it is not lost.
    r.kick();
    await pumpEventQueue();
    expect(links, hasLength(4));
    links[3].reply(reply(done: [tokens[2]], finished: true));
    await pumpEventQueue();
    expect(await entries(first), [Told(tokens[2].trimLeft()), Told(tokens[0].trimLeft()), Told(tokens[1].trimLeft())]);
    expect(files.files.keys.where((n) => n.startsWith('audio-')), isEmpty);
  });

  test('all failing: each tried once per run, then it stops', () async {
    await waits(first, [Waiting(x), Waiting(y)], {x: 3200, y: 3200});
    key = () async => throw const KeyFailure(502);
    final r = retries();
    r.kick();
    await pumpEventQueue();
    expect(lines, ['retryStarted', 'retryFailed 502', 'retryStarted', 'retryFailed 502']);
    expect(await entries(first), [Waiting(x), Waiting(y)]);
    expect(r.transcribing, isNull);
  });

  // The phone says there is no connection: nothing is tried, nothing shows
  // (AI·6 would flash until a key request failed); it starts when the
  // connection returns.
  test('offline, no retry and no AI·6; the connection returning starts it', () async {
    await waits(first, [Waiting(x)], {x: 3200});
    connection.set(false);
    final r = retries();
    final seen = <String?>[];
    r.addListener(() => seen.add(r.transcribing));
    r.kick();
    r.back();
    r.release();
    await pumpEventQueue();
    expect(links, isEmpty);
    expect(lines, isEmpty);
    expect(seen, isEmpty);
    connection.set(true);
    await pumpEventQueue();
    expect(links, hasLength(1));
    expect(seen.first, x);
  });

  // The connection goes during a run: the recordings behind are not tried.
  test('connection going in a run: no key asked for the rest', () async {
    await waits(first, [Waiting(x), Waiting(y)], {x: 3200, y: 3200});
    key = () async {
      connection.set(false);
      throw const KeyFailure(502);
    };
    final r = retries();
    r.kick();
    await pumpEventQueue();
    expect(lines, ['retryStarted', 'retryFailed 502']);
    expect(r.transcribing, isNull);
  });

  // D93 Q7, P10: no words, and the recording goes; a night left with
  // nothing at all is deleted.
  test('silence: the recording goes, and an emptied night with it', () async {
    await waits(first, [Waiting(x)], {x: 3200});
    final r = retries();
    r.kick();
    await pumpEventQueue();
    links.single.reply(reply(finalMs: 100, finished: true));
    await pumpEventQueue();
    expect(await store.nights(), isEmpty);
    expect(files.files, isEmpty);
  });

  test('a recording whose audio is gone simply goes', () async {
    await store.save(first.withEntries([Told(first.dreams[0]), Waiting(x)]));
    retries().kick();
    await pumpEventQueue();
    expect(links, isEmpty);
    expect(await entries(first), [Told(first.dreams[0])]);
  });

  test('oldest night first, one at a time, each its own audio', () async {
    await waits(second, [Waiting(y)], {y: 3200});
    await waits(first, [Waiting(x)], {x: 6400});
    final r = retries();
    r.kick();
    r.kick();
    await pumpEventQueue();
    expect(links, hasLength(1));
    expect(frames(links.single), hasLength(2));
    links.single.reply(reply(done: [tokens[0]], finished: true));
    await pumpEventQueue();
    expect(links, hasLength(2));
    expect(frames(links.last), hasLength(1));
    links.last.reply(reply(done: [tokens[1]], finished: true));
    await pumpEventQueue();
    expect(await entries(first), [Told(tokens[0].trimLeft())]);
    expect(await entries(second), [Told(tokens[1].trimLeft())]);
  });

  test('a typing screen holds the retries; its closing starts them', () async {
    await waits(first, [Waiting(x)], {x: 3200});
    final r = retries();
    r.hold();
    r.kick();
    connection.set(true);
    await pumpEventQueue();
    expect(links, isEmpty);
    r.release();
    await pumpEventQueue();
    expect(links, hasLength(1));
  });

  test('away, nothing starts; the connection returning starts it', () async {
    await waits(first, [Waiting(x)], {x: 3200});
    final r = retries();
    r.away();
    r.kick();
    await pumpEventQueue();
    expect(links, isEmpty);
    r.back();
    await pumpEventQueue();
    expect(links, hasLength(1));
  });

  test('after dispose a retry ends quietly, and none starts', () async {
    await waits(first, [Waiting(x)], {x: 6400});
    audio
      ..open = 1
      ..gate = Completer<void>();
    final r = retries();
    r.kick();
    await pumpEventQueue();
    r.dispose();
    audio.gate!.complete();
    await pumpEventQueue();
    expect(links.single.closed, isTrue);
    r.kick();
    await pumpEventQueue();
    expect(links, hasLength(1));
    expect(lines, isNot(contains('retryFailed -2')));
  });

  test('words the journal does not take: a code, no going round', () async {
    await waits(first, [Waiting(x)], {x: 3200});
    final r = Retries(
      Recording(on: true, microphone: SilentMicrophone(), key: () async => 'k', connect: (_) async => MemoryLink()),
      Deaf(audio),
      pace: 0,
    );
    r.kick();
    await pumpEventQueue();
    expect(lines, ['retryFailed -3']);
    expect(await entries(first), [Waiting(x)]);
  });

  test('recording off: no retry', () async {
    await waits(first, [Waiting(x)], {x: 3200});
    retries(on: false).kick();
    await pumpEventQueue();
    expect(links, isEmpty);
  });

  // D92 item 4: a night deleted while its recording is replayed: nothing of
  // it comes back, and its audio is gone.
  test('deleted while replayed: nothing comes back, no audio stays', () async {
    await waits(first, [Waiting(x)], {x: 32000});
    audio
      ..open = 2
      ..gate = Completer<void>();
    final r = retries();
    r.kick();
    await pumpEventQueue();
    links.single.reply(reply(done: [tokens[0]], finalMs: 200));
    await store.delete(first.id);
    r.away();
    audio.gate!.complete();
    await pumpEventQueue();
    expect(await store.nights(), isEmpty);
    expect(files.files, isEmpty);
  });

  test('the audio goes at real-time pace', () async {
    await waits(first, [Waiting(x)], {x: 9600});
    final clock = Stopwatch()..start();
    retries(pace: 1).kick();
    while (links.isEmpty || links.single.sent.isEmpty || links.single.sent.last != '') {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(clock.elapsed, greaterThanOrEqualTo(const Duration(milliseconds: 280)));
    expect(frames(links.single), hasLength(3));
  });

  test('each frame is a tenth of a second of audio', () {
    expect(retryFrame, 3200);
  });
}
