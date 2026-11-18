// Soniox's real-time stream, as the app speaks it (technical-answers a;
// D69; D71 Q8, Q9). The short-lived key goes in the handshake's
// Authorization header, never in the first message; the first message
// is exactly the settings below, English only; then the audio as binary
// frames; an empty text frame ends it. No header names the phone (R4).
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'microphone.dart';

/// The model, named once (D71 Q9).
const sonioxModel = 'stt-rt-v6';

/// The first message: exactly these settings.
Map<String, Object> sonioxSettings() => {
  'model': sonioxModel,
  'audio_format': 'pcm_s16le',
  'sample_rate': sampleRate,
  'num_channels': 1,
  'language_hints': ['en'],
  'language_hints_strict': true,
};

sealed class SonioxReply {
  const SonioxReply();
}

/// Words heard: the newly final ones, and the provisional ones now shown
/// in place of the last.
final class Heard extends SonioxReply {
  const Heard(this.finalText, this.provisional, {required this.finished, this.finalMs = 0});

  final String finalText;
  final String provisional;

  /// How much of the audio, in milliseconds from the stream's start, is in
  /// final words: Soniox's `final_audio_proc_ms` (D94).
  final int finalMs;

  /// Soniox has sent everything and will close.
  final bool finished;
}

/// Soniox refused or broke off: its error code, or -1 for a reply the app
/// cannot read.
final class Refused extends SonioxReply {
  const Refused(this.code);

  final int code;
}

// Markers Soniox may put among the words: never shown.
const _markers = {'<fin>', '<end>'};

SonioxReply readReply(String text) {
  final Object? parsed;
  try {
    parsed = jsonDecode(text);
  } on FormatException {
    return const Refused(-1);
  }
  if (parsed is! Map<String, Object?>) return const Refused(-1);
  final code = parsed['error_code'];
  if (code != null) return Refused(code is int ? code : -1);
  final tokens = parsed['tokens'];
  if (tokens is! List<Object?>) return const Refused(-1);
  final done = StringBuffer();
  final shown = StringBuffer();
  for (final t in tokens) {
    if (t is! Map<String, Object?>) return const Refused(-1);
    final word = t['text'];
    if (word is! String) return const Refused(-1);
    if (_markers.contains(word.trim())) continue;
    (t['is_final'] == true ? done : shown).write(word);
  }
  final ms = parsed['final_audio_proc_ms'];
  return Heard(
    done.toString(),
    shown.toString(),
    finished: parsed['finished'] == true,
    finalMs: ms is int && ms > 0 ? ms : 0,
  );
}

/// A stream to Soniox.
abstract interface class SonioxLink {
  /// Soniox's replies, as text; done when the stream closes.
  Stream<String> get replies;

  /// The close code once closed, if any.
  int? get closeCode;

  void add(Uint8List frame);

  /// Asks Soniox to finish: it sends the last words, then closes.
  void finish();

  Future<void> close();
}

final class SocketLink implements SonioxLink {
  SocketLink._(this._socket) : replies = _socket.where((m) => m is String).cast<String>();

  final WebSocket _socket;

  @override
  final Stream<String> replies;

  /// Opens [url] with the short-lived [key], and sends the settings.
  static Future<SocketLink> open(String url, String key) async {
    final client = HttpClient()..userAgent = null;
    final socket = await WebSocket.connect(
      url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $key'},
      customClient: client,
      compression: CompressionOptions.compressionOff,
    ).timeout(const Duration(seconds: 10));
    socket.add(jsonEncode(sonioxSettings()));
    return SocketLink._(socket);
  }

  @override
  int? get closeCode => _socket.closeCode;

  @override
  void add(Uint8List frame) => _socket.add(frame);

  @override
  void finish() => _socket.add('');

  @override
  Future<void> close() => _socket.close();
}
