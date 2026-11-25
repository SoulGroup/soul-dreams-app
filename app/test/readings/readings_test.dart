// The readings, in plain Dart (head's message 33; D134; D155 item 1): one
// POST to our server's /reading with the beta key and the night (its
// language and its dreams in words) and, only while Life Context is on, the
// sentences it keeps; nothing that names the phone (R4). What Start
// Interpretation does: the readings kept in the night, which is then read;
// a failure keeps nothing and logs a code (R3).
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/hosts.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/journal/journal.dart';
import 'package:souldreams/journal/journal_store.dart';
import 'package:souldreams/journal/night.dart';
import 'package:souldreams/life_context/life_context.dart';
import 'package:souldreams/readings/readings.dart';
import 'package:souldreams/settings/consents.dart';
import 'package:souldreams/settings/settings.dart';
import 'package:souldreams/settings/settings_controller.dart';

import '../fixtures.dart';
import '../journal/memory_journal_files.dart';
import '../journal/zones.dart';

/// Our server's door, on this Mac: what each request held, and the answer.
final class FakeServer {
  FakeServer._(this._server);

  final HttpServer _server;
  final requests = <({String method, String path, Map<String, List<String>> headers, String body})>[];
  int status = 200;

  /// When set, the reply's bytes as they are (not text), instead of [reply].
  List<int>? rawReply;
  String reply = jsonEncode({
    'readings': [
      {'lens': 0, 'text': '[one]'},
      {'lens': 2, 'text': '[two]'},
    ],
    'usage': [call],
  });

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
    final body = await utf8.decodeStream(request);
    requests.add((method: request.method, path: request.uri.path, headers: headers, body: body));
    request.response.statusCode = status;
    if (rawReply case final raw?) {
      request.response.add(raw);
    } else {
      request.response.write(reply);
    }
    await request.response.close();
  }

  Future<void> stop() => _server.close(force: true);
}

/// One model call's counts, as our server gives them.
const call = {'step': 'readings', 'model': 'stand-in', 'input': 40, 'output': 9, 'cacheRead': 30, 'cacheWrite': 0, 'cost': 290};

void main() {
  final beta = 'Ab0' * 16;
  final readings = [Reading(0, '[one]'), Reading(2, '[two]')];
  final usage = [ModelUsage.fromJson(call)!];
  final answer = (readings: readings, usage: usage);
  final unkept = (readings: readings, usage: null);

  late List<String> lines;
  setUp(() {
    JournalStore.newQueueForTests();
    lines = [];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
  });

  // Two answers alike: the same readings and the same counts, or none.
  void same(NightAnswer a, NightAnswer b) {
    expect(a.readings, b.readings);
    expect(a.usage, b.usage);
  }

  Future<int> failure(Future<void> f) async {
    try {
      await f;
    } on ReadingFailure catch (e) {
      return e.status;
    }
    fail('no failure');
  }

  group('the request', () {
    test("the night's language and dreams in words; kept only when given", () {
      final n = nightsFromFixtures()[1];
      final night = n.withEntries([...n.entries, Waiting('e' * 32)]);
      expect(requestOf(night, null), {'lang': n.lang.name, 'dreams': n.dreams});
      expect(requestOf(night, []), {'lang': n.lang.name, 'dreams': n.dreams, 'kept': <String>[]});
      expect(requestOf(night, ['a', 'b']), {'lang': n.lang.name, 'dreams': n.dreams, 'kept': ['a', 'b']});
    });

    test('one POST to /reading: beta key and the night alone', () async {
      final server = await FakeServer.start();
      addTearDown(server.stop);
      final body = {'lang': 'sv', 'dreams': ['Ett hus.']};
      same(await postReading(server.url, beta, body), answer);
      final r = server.requests.single;
      expect(r.method, 'POST');
      expect(r.path, '/reading');
      expect(jsonDecode(r.body), body);
      expect(r.headers['authorization'], ['Bearer $beta']);
      expect(r.headers['content-type'], ['application/json; charset=utf-8']);
      expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'content-type', 'accept-encoding'});
    });

    test("not 200: the server's status; no answer: 0", () async {
      final server = await FakeServer.start();
      for (final status in [204, 400, 401, 413, 500, 502]) {
        server.status = status;
        expect(await failure(postReading(server.url, beta, {})), status);
      }
      final gone = server.url;
      await server.stop();
      expect(await failure(postReading(gone, beta, {})), 0);
    });

    test('a reply that is not text: -1, or its own status', () async {
      final server = await FakeServer.start();
      addTearDown(server.stop);
      server.rawReply = [0xff, 0xfe, 0x00];
      expect(await failure(postReading(server.url, beta, {})), -1);
      server.status = 502;
      expect(await failure(postReading(server.url, beta, {})), 502);
    });

    test('an answer that is not one to three whole readings: -1', () async {
      final server = await FakeServer.start();
      addTearDown(server.stop);
      for (final reply in [
        'not json',
        '[]',
        jsonEncode({'readings': [], 'usage': []}),
        jsonEncode({'readings': 'x', 'usage': []}),
        jsonEncode({'readings': [for (var i = 0; i < 4; i++) {'lens': i, 'text': '[x]'}], 'usage': []}),
        jsonEncode({'readings': [{'lens': -1, 'text': '[x]'}], 'usage': []}),
        jsonEncode({'readings': [{'lens': 1, 'text': ''}], 'usage': []}),
        jsonEncode({'readings': [{'lens': '1', 'text': '[x]'}], 'usage': []}),
        jsonEncode({'readings': [{'lens': 1, 'text': '[x]', 'extra': 1}], 'usage': []}),
        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}], 'usage': [], 'extra': 1}),
        // The calls' counts: missing, or not whole.
        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}]}),
        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}], 'usage': 'x'}),
        jsonEncode({'readings': [{'lens': 1, 'text': '[x]'}], 'usage': [{...call, 'input': -1}]}),
      ]) {
        server.reply = reply;
        expect(await failure(postReading(server.url, beta, {})), -1, reason: reply);
      }
    });

    test("Dev's own: our server, with a well-shaped beta key", () async {
      final server = await FakeServer.start();
      addTearDown(server.stop);
      // The calls' counts kept only when asked (head's message 34).
      same(await liveReading(betaKey: beta, server: '${server.url}')({}), unkept);
      same(await liveReading(betaKey: beta, server: '${server.url}', keepUsage: true)({}), answer);
      expect(await failure(liveReading(betaKey: 'short', server: '${server.url}')({})), -2);
      expect(await failure(liveReading(betaKey: beta, server: '')({})), -2);
      expect(server.requests, hasLength(2));
      expect(Hosts.server, isNotEmpty);
    });
  });

  group('Life Context (D134)', () {
    late DateTime now;
    final passages = [for (final n in inventedNights()) ...n.waking];

    Future<(Journal, SettingsController, LifeContext, List<Night>)> open({bool on = true}) async {
      now = DateTime.utc(2026, 11, 22, 9);
      final store = await JournalStore.open(MemoryJournalFiles());
      final journal = Journal(store, zone: const FixedZone(1), now: () => now, random: Random(4));
      final nights = nightsFromFixtures();
      for (final n in nights) {
        await store.save(n);
      }
      final settings = SettingsController(
        journal,
        consents: Consents.answered({Consent.readings: true, Consent.lifeContext: on}, now),
        settings: Settings(),
      );
      return (journal, settings, LifeContext(journal, settings), nights);
    }

    test('On: the Recent list, in its order, word for word', () async {
      final (_, _, life, nights) = await open();
      await life.capture(nights.first.id, passages.first.text);
      await life.capture(nights[1].id, passages[1].text);
      final recent = [for (final k in await life.recent()) k.text];
      expect(recent.toSet(), {...passages.first.sentences, ...passages[1].sentences});
      expect(await keptFor(life), recent);
    });

    test('On with nothing kept: an empty list, still sent', () async {
      final (_, _, life, _) = await open();
      expect(await keptFor(life), <String>[]);
    });

    test('Off: nothing kept is sent, and it comes back On', () async {
      final (_, settings, life, nights) = await open();
      await life.capture(nights.first.id, passages.first.text);
      await settings.answer(Consent.lifeContext, false);
      expect(await keptFor(life), isNull);
      await settings.answer(Consent.lifeContext, true);
      expect(await keptFor(life), passages.first.sentences);
    });

    test('Off while the kept sentences are read: nothing is sent', () async {
      final (_, settings, life, nights) = await open();
      await life.capture(nights.first.id, passages.first.text);
      final asked = keptFor(life);
      final off = settings.answer(Consent.lifeContext, false);
      expect(await asked, isNull);
      await off;
    });

    test('no Life Context: nothing kept is sent', () async {
      expect(await keptFor(null), isNull);
    });

    test("the Reader sends what Life Context gives when it reads", () async {
      final (_, settings, life, nights) = await open();
      await life.capture(nights.first.id, passages.first.text);
      final sent = <Map<String, Object?>>[];
      final reader = Reader((body) async {
        sent.add(body);
        return answer;
      }, () => keptFor(life));
      same(await reader.read(nights[1]), answer);
      await settings.answer(Consent.lifeContext, false);
      await reader.read(nights[1]);
      expect(sent, [requestOf(nights[1], passages.first.sentences), requestOf(nights[1], null)]);
      expect(sent.last.containsKey('kept'), isFalse);
    });
  });

  group('Start Interpretation', () {
    late Journal journal;
    late List<Night> nights;
    late List<Map<String, Object?>> sent;
    late Object? fails;

    setUp(() async {
      final store = await JournalStore.open(MemoryJournalFiles());
      journal = Journal(store, zone: const FixedZone(1), random: Random(4));
      nights = nightsFromFixtures();
      for (final n in nights) {
        await store.save(n);
      }
      sent = [];
      fails = null;
    });

    Reader reader() => Reader((body) async {
      sent.add(body);
      if (fails case final f?) throw f;
      return answer;
    }, () async => null);

    test('the readings kept in the night, which is read; one code', () async {
      expect(await interpret(journal, reader(), nights[2]), Interpreted.read);
      final read = await journal.night(nights[2].id);
      expect(read!.readings, readings);
      expect(read.usage, usage);
      expect(read.withEntries(nights[2].entries), nights[2].withReadings(readings, usage: usage));
      expect(sent, [requestOf(nights[2], null)]);
      expect(lines, ['readingRead 2']);
    });

    test('a failure keeps nothing, the night unread; its status logged', () async {
      for (final (f, line) in [
        (const ReadingFailure(502), 'readingFailed 502'),
        (const ReadingFailure(0), 'readingFailed 0'),
        (StateError('invented failure text'), 'readingFailed -3'),
      ]) {
        lines.clear();
        fails = f;
        expect(await interpret(journal, reader(), nights[0]), Interpreted.failed);
        expect((await journal.night(nights[0].id))!.readings, isNull);
        expect(lines, [line]);
      }
    });

    test('a night already read is not read again', () async {
      await journal.keepReadings(nights[0].id, readings);
      expect(await interpret(journal, reader(), (await journal.night(nights[0].id))!), Interpreted.nothing);
      expect(sent, isEmpty);
    });

    test('a night with no dream in words yet is not sent', () async {
      final waiting = nights[0].withEntries([Waiting('e' * 32)]);
      expect(await interpret(journal, reader(), waiting), Interpreted.nothing);
      expect(sent, isEmpty);
    });

    test('a night deleted while read keeps nothing, not made again', () async {
      final r = Reader((body) async {
        await journal.delete(nights[1].id);
        return answer;
      }, () async => null);
      expect(await interpret(journal, r, nights[1]), Interpreted.gone);
      expect(await journal.night(nights[1].id), isNull);
      expect(lines, isEmpty);
    });

    test('the readings that cannot be kept: failed, a code', () async {
      final r = Reader((body) async => answer, () async => null);
      final files = BrokenFiles();
      final broken = Journal(await JournalStore.open(files), random: Random(4));
      files.failing = true;
      expect(await interpret(broken, r, nights[1]), Interpreted.failed);
      expect(lines, ['readingKeepFailed']);
    });

    test("a build that keeps no counts: the readings kept, no usage", () async {
      final r = Reader((body) async => unkept, () async => null);
      expect(await interpret(journal, r, nights[2]), Interpreted.read);
      final read = await journal.night(nights[2].id);
      expect(read!.readings, readings);
      expect(read.usage, isNull);
    });

    test('keepReadings: a night read keeps its first readings', () async {
      expect(await journal.keepReadings(nights[0].id, readings), isTrue);
      expect(await journal.keepReadings(nights[0].id, [Reading(1, '[x]')]), isTrue);
      expect((await journal.night(nights[0].id))!.readings, readings);
      expect(await journal.keepReadings('f' * 32, readings), isFalse);
    });
  });
}

/// A folder that cannot be read once [failing] is set.
final class BrokenFiles extends MemoryJournalFiles {
  bool failing = false;

  @override
  Future<Uint8List?> read(String name) async => failing ? throw StateError('journal-io') : super.read(name);
}
