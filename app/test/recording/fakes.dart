// Stand-ins for recording's tests: Soniox's real-time endpoint and our
// server's front door on this Mac's loopback, a microphone that sends
// silence, and Soniox's replies built from the invented nights (R2).
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:souldreams/recording/microphone.dart';
import 'package:souldreams/recording/soniox.dart';

import '../fixtures.dart';

/// A dream's words as Soniox's tokens: each word after the first with
/// its space in front, as Soniox sends them.
List<String> tokensOf(String dream) {
  final words = dream.split(' ');
  return [words.first, for (final w in words.skip(1)) ' $w'];
}

/// The first invented dream's tokens.
List<String> inventedTokens() => tokensOf(invented('two-dreams-en').dreams[0]);

String reply({List<String> done = const [], List<String> shown = const [], bool finished = false}) => jsonEncode({
  'tokens': [
    for (final t in done) {'text': t, 'is_final': true},
    for (final t in shown) {'text': t, 'is_final': false},
  ],
  'final_audio_proc_ms': 0,
  'total_audio_proc_ms': 0,
  if (finished) 'finished': true,
});

/// Soniox's endpoint, played on loopback: it records the handshake's
/// headers, the first message and every frame, and answers by [script].
final class FakeSoniox {
  FakeSoniox._(this._server);

  final HttpServer _server;
  final headers = <String, List<String>>{};
  final texts = <String>[];
  final frames = <Uint8List>[];
  WebSocket? socket;

  /// Called on each message after the first; may answer.
  void Function(FakeSoniox soniox, Object message)? script;

  /// Refuse the handshake with this status, if set.
  int? refuse;

  String get url => 'ws://127.0.0.1:${_server.port}/transcribe-websocket';

  static Future<FakeSoniox> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final fake = FakeSoniox._(server);
    server.listen(fake._handle);
    return fake;
  }

  Future<void> _handle(HttpRequest request) async {
    request.headers.forEach((name, values) => headers[name] = values);
    final status = refuse;
    if (status != null) {
      request.response.statusCode = status;
      await request.response.close();
      return;
    }
    final ws = await WebSocketTransformer.upgrade(request);
    socket = ws;
    ws.listen((message) {
      if (message is String) {
        texts.add(message);
      } else {
        frames.add(Uint8List.fromList(message as List<int>));
      }
      if (texts.length > 1 || message is! String) script?.call(this, message);
    });
  }

  void send(String text) => socket!.add(text);

  Future<void> stop() => _server.close(force: true);
}

/// Our server's front door, played on loopback.
final class FakeDoor {
  FakeDoor._(this._server);

  final HttpServer _server;
  final requests = <({String method, Map<String, List<String>> headers, int bodyLength})>[];
  int status = 200;
  String body = jsonEncode({'key': 'temporary-key-in-a-test', 'expiresAt': '2026-11-13T12:00:00Z'});
  Completer<void>? hold;

  Uri get url => Uri.parse('http://127.0.0.1:${_server.port}/');

  static Future<FakeDoor> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final fake = FakeDoor._(server);
    server.listen(fake._handle);
    return fake;
  }

  Future<void> _handle(HttpRequest request) async {
    final headers = <String, List<String>>{};
    request.headers.forEach((name, values) => headers[name] = values);
    final bytes = await request.fold<int>(0, (n, chunk) => n + chunk.length);
    requests.add((method: request.method, headers: headers, bodyLength: bytes));
    await hold?.future;
    request.response.statusCode = status;
    request.response.write(body);
    await request.response.close();
  }

  Future<void> stop() => _server.close(force: true);
}

/// A microphone that sends silence, one frame of 3200 bytes (a tenth of a
/// second) each time [frame] is called.
final class SilentMicrophone implements Microphone {
  bool allow = true;
  bool fails = false;
  int stops = 0;
  StreamController<Uint8List>? _frames;

  bool get running => _frames != null;

  @override
  Future<bool> allowed() async => allow;

  @override
  Future<Stream<Uint8List>> start() async {
    if (fails) throw StateError('microphone');
    final frames = StreamController<Uint8List>();
    _frames = frames;
    return frames.stream;
  }

  void frame([int value = 0]) {
    final bytes = Uint8List(3200);
    final data = ByteData.sublistView(bytes);
    for (var i = 0; i < 1600; i++) {
      data.setInt16(i * 2, value, Endian.little);
    }
    _frames!.add(bytes);
  }

  @override
  Future<void> stop() async {
    stops++;
    final frames = _frames;
    _frames = null;
    unawaited(frames?.close());
  }
}

/// A link held in memory: what was sent, and replies the test pushes.
final class MemoryLink implements SonioxLink {
  final _replies = StreamController<String>();
  final sent = <Object>[];
  bool closed = false;

  @override
  int? closeCode;

  @override
  Stream<String> get replies => _replies.stream;

  void reply(String text) => _replies.add(text);

  /// Soniox closes its end.
  Future<void> drop([int? code]) async {
    closeCode = code;
    await _replies.close();
  }

  @override
  void add(Uint8List frame) => sent.add(frame);

  @override
  void finish() => sent.add('');

  @override
  Future<void> close() async {
    closed = true;
    if (!_replies.isClosed) unawaited(_replies.close());
  }
}
