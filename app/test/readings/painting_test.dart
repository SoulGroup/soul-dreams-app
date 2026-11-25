// A read night's personal painting, in plain Dart (D162; D143): one POST
// to our server's /painting with the beta key and nothing of the night;
// kept beside the night only while Night images is Personal, the night is
// read and has none yet; a failure counted silently, three at most; nothing
// of a night logged (R3).
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/hosts.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/readings/painting.dart';
import 'package:souldreams/settings/settings.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';
import '../journal/zones.dart';

/// A JPEG's start, a few bytes and its end.
final jpeg = Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3, 0xff, 0xd9]);

/// Our server's door, on this Mac: what each request held, and the answer.
final class FakeServer {
  FakeServer._(this._server);

  final HttpServer _server;
  final requests = <({String method, String path, Map<String, List<String>> headers, List<int> body})>[];
  int status = 200;
  List<int> reply = jpeg;

  Uri get url => Uri.parse('http://127.0.0.1:${_server.port}/');

  static Future<FakeServer> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final fake = FakeServer._(server);
    server.listen(fake._handle);
    return fake;
  }

  Future<void> _handle(HttpRequest request) async {
    final headers = <String, List<String>>{};
    request.headers.forEach((name, values) => headers[name] = values);
    final body = [for (final chunk in await request.toList()) ...chunk];
    requests.add((method: request.method, path: request.uri.path, headers: headers, body: body));
    request.response.statusCode = status;
    request.response.add(reply);
    await request.response.close();
  }

  Future<void> stop() => _server.close(force: true);
}

void main() {
  final beta = 'Ab0' * 16;

  late List<String> lines;
  setUp(() {
    JournalStore.newQueueForTests();
    lines = [];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
  });

  Future<int> failure(Future<void> f) async {
    try {
      await f;
    } on PaintingFailure catch (e) {
      return e.status;
    }
    fail('no failure');
  }

  group('the request', () {
    test('one POST to /painting: the beta key and nothing else', () async {
      final server = await FakeServer.start();
      addTearDown(server.stop);
      expect(await postPainting(server.url, beta), jpeg);
      final r = server.requests.single;
      expect(r.method, 'POST');
      expect(r.path, '/painting');
      expect(String.fromCharCodes(r.body), '{}');
      expect(r.headers['authorization'], ['Bearer $beta']);
      expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'content-type', 'accept-encoding'});
    });

    test("not 200: the server's status; no answer: 0", () async {
      final server = await FakeServer.start();
      for (final status in [204, 400, 401, 413, 500, 502]) {
        server.status = status;
        expect(await failure(postPainting(server.url, beta)), status);
      }
      final gone = server.url;
      await server.stop();
      expect(await failure(postPainting(gone, beta)), 0);
    });

    test('an answer that is no whole JPEG, or too big: -1', () async {
      final server = await FakeServer.start();
      addTearDown(server.stop);
      for (final reply in [
        <int>[],
        [0xff, 0xd8],
        [0xff, 0xd8, 1, 2],
        [0xff, 0xd8, 0xff, 0],
        [1, 2, 0xff, 0xd9],
        [0x89, 0x50, 0x4e, 0x47, 0xff, 0xd9],
        [...jpeg.sublist(0, 4), ...List.filled(maxPaintingBytes, 0), 0xff, 0xd9],
      ]) {
        server.reply = reply;
        expect(await failure(postPainting(server.url, beta)), -1, reason: '${reply.length}');
      }
    });

    test("Dev's own: our server, with a well-shaped beta key", () async {
      final server = await FakeServer.start();
      addTearDown(server.stop);
      expect(await livePainting(betaKey: beta, server: server.url.toString())(), jpeg);
      for (final (key, url) in [('short', server.url.toString()), (beta, ''), ('${beta}x', server.url.toString())]) {
        expect(await failure(livePainting(betaKey: key, server: url)()), -2);
      }
      expect(server.requests, hasLength(1));
      expect(Hosts.server, isNotEmpty);
    });
  });

  group('a night painted', () {
    late Journal journal;
    late Night read;
    late Night unread;
    setUp(() async {
      final store = await JournalStore.open(MemoryJournalFiles());
      journal = Journal(store, zone: const FixedZone(1), random: Random(4));
      final [first, second, ...] = nightsFromFixtures();
      read = first.withReadings([Reading(0, '[one]')]);
      unread = second;
      await store.save(read);
      await store.save(unread);
    });

    // A send that answers [answers] in turn (a JPEG, or a failure to throw),
    // counting its calls.
    ({SendPainting send, List<int> calls}) sender(List<Object> answers) {
      final calls = <int>[];
      return (
        calls: calls,
        send: () async {
          calls.add(calls.length);
          final answer = answers[min(calls.length - 1, answers.length - 1)];
          if (answer is Uint8List) return answer;
          throw answer;
        },
      );
    }

    test('Personal, read, none yet: painted, kept, one code', () async {
      final s = sender([jpeg]);
      var told = 0;
      expect(await paintNight(journal, s.send, read, NightImages.personal, sending: () => told++), Painted.made);
      expect(await journal.painting(read.id), jpeg);
      expect(told, 1);
      expect(lines, ['paintingMade ${jpeg.length}']);
    });

    test('Random, Off, or an unread night: nothing asked', () async {
      final s = sender([jpeg]);
      for (final images in [NightImages.random, NightImages.off]) {
        expect(await paintNight(journal, s.send, read, images), Painted.nothing);
      }
      expect(await paintNight(journal, s.send, unread, NightImages.personal), Painted.nothing);
      expect(s.calls, isEmpty);
      expect(await journal.paintings(), isEmpty);
    });

    test('a night with its painting is not painted again', () async {
      final s = sender([jpeg]);
      await paintNight(journal, s.send, read, NightImages.personal);
      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.nothing);
      expect(s.calls, hasLength(1));
    });

    test('a failure keeps nothing, counts a try, logs its status', () async {
      final s = sender([const PaintingFailure(502)]);
      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
      expect(await journal.painting(read.id), isNull);
      expect(await journal.paintTries(read.id), 1);
      expect(lines, ['paintingFailed 502']);
    });

    test('anything else failing logs -3, never its words', () async {
      final s = sender([StateError('invented failure text')]);
      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
      expect(lines, ['paintingFailed -3']);
    });

    test('three tries at most; then nothing is asked again', () async {
      final s = sender([const PaintingFailure(0)]);
      for (var i = 0; i < maxPaintTries; i++) {
        expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
      }
      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.nothing);
      expect(s.calls, hasLength(3));
      expect(maxPaintTries, 3);
    });

    test('a failure, then a painting on the next try', () async {
      final s = sender([const PaintingFailure(0), jpeg]);
      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.failed);
      expect(await paintNight(journal, s.send, read, NightImages.personal), Painted.made);
      expect(await journal.painting(read.id), jpeg);
      expect(await journal.paintTries(read.id), 0);
    });

    test('a night deleted while painted keeps nothing', () async {
      final gate = Completer<Uint8List>();
      final painting = paintNight(journal, () => gate.future, read, NightImages.personal);
      await pumpEventQueue();
      await journal.delete(read.id);
      gate.complete(jpeg);
      expect(await painting, Painted.gone);
      expect(await journal.paintings(), isEmpty);
    });

    test('the Painter asks once for a night being painted', () async {
      final gate = Completer<Uint8List>();
      var asked = 0;
      final painter = Painter(() {
        asked++;
        return gate.future;
      });
      var told = 0;
      final one = painter.paint(journal, read, NightImages.personal, sending: () => told++);
      await pumpEventQueue();
      expect(painter.busy(read.id), isTrue);
      final two = painter.paint(journal, read, NightImages.personal, sending: () => told++);
      gate.complete(jpeg);
      expect(await one, Painted.made);
      expect(await two, Painted.made);
      expect(asked, 1);
      expect(told, 2);
      expect(painter.busy(read.id), isFalse);
    });
  });
}
