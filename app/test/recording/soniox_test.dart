// Soniox's real-time stream (D69; D71 Q8, Q9): the settings exactly, the
// key in the handshake only, the frames as sent, an empty text frame to
// finish, and the replies read.
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/hosts.dart';
import 'package:souldreams/recording/soniox.dart';

import 'fakes.dart';

void main() {
  final tokens = inventedTokens();

  test("the settings: exactly these, English only, stt-rt-v6, no key in them", () {
    expect(sonioxSettings(), {
      'model': 'stt-rt-v6',
      'audio_format': 'pcm_s16le',
      'sample_rate': 16000,
      'num_channels': 1,
      'language_hints': ['en'],
      'language_hints_strict': true,
      // D99: Soniox's endpoint detection on, its three tunings at their
      // defaults (none sent).
      'enable_endpoint_detection': true,
    });
  });

  test("Soniox's EU real-time endpoint", () {
    final url = Uri.parse(Hosts.soniox);
    expect(url.scheme, 'wss');
    expect(url.host, 'stt-rt.eu.soniox.com');
    expect(url.path, '/transcribe-websocket');
  });

  test('final and provisional words, markers dropped', () {
    final r = readReply(reply(done: [tokens[0], '<fin>'], shown: [tokens[1], tokens[2]]));
    expect(r, isA<Heard>());
    r as Heard;
    expect(r.finalText, tokens[0]);
    expect(r.provisional, tokens[1] + tokens[2]);
    expect(r.finished, isFalse);
    expect((readReply(reply(finished: true)) as Heard).finished, isTrue);
  });

  // D99: with endpoint detection Soniox ends each stretch of speech with an
  // <end> token: never shown, as <fin> (D73), wherever it comes.
  test('the <end> token is dropped, final or not, among the words', () {
    final r = readReply(reply(done: [tokens[0], '<end>', tokens[1]], shown: ['<end>', tokens[2]]));
    r as Heard;
    expect(r.finalText, tokens[0] + tokens[1]);
    expect(r.provisional, tokens[2]);
    final alone = readReply(reply(done: ['<end>'])) as Heard;
    expect(alone.finalText, isEmpty);
    expect(alone.provisional, isEmpty);
  });

  // D94: how much of the audio is in final words, Soniox's own count.
  test('final_audio_proc_ms is read; missing or odd, it is 0', () {
    expect((readReply(reply(done: [tokens[0]], finalMs: 4800)) as Heard).finalMs, 4800);
    expect((readReply(jsonEncode({'tokens': <Object?>[]})) as Heard).finalMs, 0);
    for (final odd in [-5, 1.5, '4800', null]) {
      expect((readReply(jsonEncode({'tokens': <Object?>[], 'final_audio_proc_ms': odd})) as Heard).finalMs, 0);
    }
  });

  test("Soniox's error is its code; an unreadable reply is -1", () {
    expect((readReply(jsonEncode({'error_code': 402, 'error_message': 'x'})) as Refused).code, 402);
    expect((readReply('not json') as Refused).code, -1);
    expect((readReply('[]') as Refused).code, -1);
    expect((readReply(jsonEncode({'tokens': 'x'})) as Refused).code, -1);
    expect((readReply(jsonEncode({'tokens': [{'is_final': true}]})) as Refused).code, -1);
    expect((readReply(jsonEncode({'error_code': 'x'})) as Refused).code, -1);
  });

  test('the handshake carries the key and names nothing else', () async {
    final soniox = await FakeSoniox.start();
    addTearDown(soniox.stop);
    final link = await SocketLink.open(soniox.url, 'temporary-key-in-a-test');
    final frame = Uint8List.fromList(List.generate(320, (i) => i % 256));
    link.add(frame);
    link.finish();
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await link.close();
    expect(soniox.headers['authorization'], ['Bearer temporary-key-in-a-test']);
    // As dart:io sends them, with no user agent (R4).
    expect(soniox.headers.keys.toSet(), {
      'accept-encoding',
      'authorization',
      'cache-control',
      'connection',
      'host',
      'sec-websocket-key',
      'sec-websocket-version',
      'upgrade',
    });
    expect(soniox.texts.first, jsonEncode(sonioxSettings()));
    expect(jsonDecode(soniox.texts.first), isNot(contains('api_key')));
    expect(soniox.frames, [frame]);
    expect(soniox.texts.last, '');
    expect(soniox.texts.length, 2);
  });

  test('replies arrive as text, until Soniox closes', () async {
    final soniox = await FakeSoniox.start();
    addTearDown(soniox.stop);
    soniox.script = (s, message) {
      if (message == '') {
        s.send(reply(done: [tokens[0]]));
        s.send(reply(finished: true));
        s.socket!.close();
      }
    };
    final link = await SocketLink.open(soniox.url, 'temporary-key-in-a-test');
    final got = link.replies.toList();
    link.finish();
    expect(await got, [reply(done: [tokens[0]]), reply(finished: true)]);
  });
}
