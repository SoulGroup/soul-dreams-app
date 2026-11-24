// Feedback (D152): one POST to our server's /feedback with the beta key and
// the text alone, nothing that names the phone (R4); and what Submit does:
// nothing when empty or while sending, the popup before "I agree", else one
// send, its result kept for the section, its failure a code (R3).
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/hosts.dart';
import 'package:souldreams/core/safe_log.dart';
import 'package:souldreams/feedback/feedback.dart';

/// Our server's door, on this Mac: what each request held, and the answer.
final class FakeServer {
  FakeServer._(this._server);

  final HttpServer _server;
  final requests = <({String method, String path, Map<String, List<String>> headers, String body})>[];
  int status = 204;
  Completer<void>? hold;

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
    await hold?.future;
    request.response.statusCode = status;
    await request.response.close();
  }

  Future<void> stop() => _server.close(force: true);
}

void main() {
  final beta = 'Ab0' * 16;

  late List<String> lines;
  setUp(() {
    lines = [];
    final sink = SafeLog.sink;
    SafeLog.sink = lines.add;
    addTearDown(() => SafeLog.sink = sink);
  });

  Future<int> failure(Future<void> f) async {
    try {
      await f;
    } on FeedbackFailure catch (e) {
      return e.status;
    }
    fail('no failure');
  }

  test('at most 2,000 characters', () {
    expect(feedbackLimit, 2000);
  });

  test('one POST to /feedback: beta key and text alone', () async {
    final server = await FakeServer.start();
    addTearDown(server.stop);
    await postFeedback(server.url, beta, 'Två rader,\nen app.');
    final r = server.requests.single;
    expect(r.method, 'POST');
    expect(r.path, '/feedback');
    expect(jsonDecode(r.body), {'text': 'Två rader,\nen app.'});
    expect(r.headers['authorization'], ['Bearer $beta']);
    expect(r.headers['content-type'], ['application/json; charset=utf-8']);
    expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'content-type', 'accept-encoding'});
  });

  test("not 204: the server's status; no answer: 0", () async {
    final server = await FakeServer.start();
    for (final status in [200, 400, 401, 413, 500, 502]) {
      server.status = status;
      expect(await failure(postFeedback(server.url, beta, 'a')), status);
    }
    final gone = server.url;
    await server.stop();
    expect(await failure(postFeedback(gone, beta, 'a')), 0);
  });

  test("Dev's own: our server, with a well-shaped beta key", () async {
    final server = await FakeServer.start();
    addTearDown(server.stop);
    await liveFeedback(betaKey: beta, server: '${server.url}')('a');
    expect(server.requests, hasLength(1));
    expect(await failure(liveFeedback(betaKey: 'short', server: '${server.url}')('a')), -2);
    expect(await failure(liveFeedback(betaKey: beta, server: '')('a')), -2);
    expect(server.requests, hasLength(1));
    expect(Hosts.server, isNotEmpty);
  });

  group('Submit', () {
    late List<String> sent;
    late Completer<void>? hold;
    late Object? fails;
    FeedbackForm form() => FeedbackForm((text) async {
      sent.add(text);
      await hold?.future;
      if (fails case final f?) throw f;
    });

    setUp(() {
      sent = [];
      hold = null;
      fails = null;
    });

    test('empty or blank: nothing, nothing sent', () async {
      final f = form();
      for (final text in ['', ' ', '\n\t ']) {
        expect(await f.submit(text, agreed: true), Submitted.nothing);
      }
      expect(sent, isEmpty);
      expect(f.state, FeedbackState.idle);
      expect(lines, isEmpty);
    });

    test('invisible characters only count as blank: nothing, nothing sent (D156)', () async {
      final f = form();
      for (final text in ['\u200B', '\u0000', '\u200B\u0000 \uFEFF\u2060', '\u00AD\u3164\u{E0001}']) {
        expect(await f.submit(text, agreed: true), Submitted.nothing);
      }
      expect(sent, isEmpty);
      expect(await f.submit('\u200Ba', agreed: true), Submitted.sent);
      expect(sent, ['\u200Ba']);
    });

    test('before agreeing: the popup, nothing sent', () async {
      final f = form();
      expect(await f.submit('The app opens slowly.', agreed: false), Submitted.popup);
      expect(sent, isEmpty);
      expect(f.state, FeedbackState.idle);
    });

    test('sent as typed: sending, then sent, one code', () async {
      final f = form();
      hold = Completer<void>();
      final states = <FeedbackState>[];
      f.addListener(() => states.add(f.state));
      final done = f.submit('  The app opens slowly.  ', agreed: true);
      expect(f.state, FeedbackState.sending);
      hold!.complete();
      expect(await done, Submitted.sent);
      expect(sent, ['  The app opens slowly.  ']);
      expect(states, [FeedbackState.sending, FeedbackState.sent]);
      expect(lines, ['feedbackSent']);
    });

    test('while sending, Submit does nothing', () async {
      final f = form();
      hold = Completer<void>();
      final first = f.submit('one', agreed: true);
      expect(await f.submit('two', agreed: true), Submitted.nothing);
      hold!.complete();
      await first;
      expect(sent, ['one']);
    });

    test("a failure: unsent, the server's status logged, never the text", () async {
      for (final (thrown, logged) in [
        (const FeedbackFailure(413), 'feedbackFailed 413'),
        (const FeedbackFailure(0), 'feedbackFailed 0'),
        (StateError('invented failure text'), 'feedbackFailed -1'),
      ]) {
        lines.clear();
        fails = thrown;
        final f = form();
        expect(await f.submit('The app opens slowly.', agreed: true), Submitted.unsent);
        expect(f.state, FeedbackState.unsent);
        expect(lines, [logged]);
      }
    });

    test('a failure, then a send that works', () async {
      final f = form();
      fails = const FeedbackFailure(502);
      expect(await f.submit('a', agreed: true), Submitted.unsent);
      fails = null;
      expect(await f.submit('a', agreed: true), Submitted.sent);
      expect(f.state, FeedbackState.sent);
    });

    test('typing after sent or unsent returns to idle; otherwise nothing', () async {
      final f = form();
      var heard = 0;
      f.addListener(() => heard++);
      f.edited();
      expect(heard, 0);
      await f.submit('a', agreed: true);
      heard = 0;
      f.edited();
      expect(f.state, FeedbackState.idle);
      expect(heard, 1);
      fails = const FeedbackFailure(500);
      await f.submit('a', agreed: true);
      f.edited();
      expect(f.state, FeedbackState.idle);
    });
  });
}
