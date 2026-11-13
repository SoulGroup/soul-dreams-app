// Asks our server for a short-lived Soniox key (D69; D71 Q11): one POST
// with no body, the beta key as a bearer token, and no other header that
// could name the phone (R4).
import 'dart:convert';
import 'dart:io';

/// The server gave no key: its HTTP status, 0 for no answer, -1 for an
/// unreadable one.
final class KeyFailure implements Exception {
  const KeyFailure(this.status);

  final int status;
}

const _wait = Duration(seconds: 10);

Future<String> fetchKey(Uri server, String betaKey) async {
  final client = HttpClient()
    ..userAgent = null
    ..connectionTimeout = _wait;
  try {
    final request = await client.postUrl(server).timeout(_wait);
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
    request.contentLength = 0;
    final reply = await request.close().timeout(_wait);
    final body = await utf8.decodeStream(reply).timeout(_wait);
    if (reply.statusCode != 200) throw KeyFailure(reply.statusCode);
    final Object? parsed;
    try {
      parsed = jsonDecode(body);
    } on FormatException {
      throw const KeyFailure(-1);
    }
    final key = parsed is Map<String, Object?> ? parsed['key'] : null;
    if (key is! String || key.isEmpty) throw const KeyFailure(-1);
    return key;
  } on KeyFailure {
    rethrow;
  } on Object {
    throw const KeyFailure(0);
  } finally {
    client.close(force: true);
  }
}
