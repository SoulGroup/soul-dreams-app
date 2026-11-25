// A read night's personal painting, in plain Dart (D162; D143; D145): one
// POST to our server's /painting with the beta key and nothing of the night
// (`{}`), and the answer is the JPEG our server had Black Forest Labs paint,
// with the invisible AI tag in it (D123). Only while Night images is
// Personal, only for a read night with no painting yet, and only while
// fewer than three tries have failed (D162 item 2): a failure is counted,
// silently, and tried again the next time the night is opened. The painting
// is kept beside its night on the phone and deleted with it (D162 item 3).
// Nothing of a night is ever logged: a failure logs its status alone (R3).
// SoulDreams Dev only, as the readings are.
import 'dart:io';
import 'dart:typed_data';

import '../core/hosts.dart';
import '../core/safe_log.dart';
import '../journal/journal.dart';
import '../journal/night.dart';
import '../settings/settings.dart';

/// The server gave no painting: its HTTP status, 0 for no answer, -1 for an
/// answer that is not a JPEG within its limit, -2 for no server or beta key
/// in this build.
final class PaintingFailure implements Exception {
  const PaintingFailure(this.status);

  final int status;
}

/// Asks our server for a painting; completes with its JPEG.
typedef SendPainting = Future<Uint8List> Function();

/// How many tries of a night's painting may fail before none is asked for
/// again (D162 item 2).
const maxPaintTries = 3;

/// The most a painting may weigh: our server's own limit.
const maxPaintingBytes = 4194304;

// Our server waits up to a minute for Black Forest Labs.
const _wait = Duration(seconds: 75);
final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');

/// Whether [bytes] are a whole JPEG: its start and its end.
bool isJpeg(Uint8List bytes) =>
    bytes.length >= 4 &&
    bytes[0] == 0xff &&
    bytes[1] == 0xd8 &&
    bytes[bytes.length - 2] == 0xff &&
    bytes[bytes.length - 1] == 0xd9;

/// Sends one painting's request to [server]'s /painting: nothing of the
/// night, `{}`; completes with the JPEG (200).
Future<Uint8List> postPainting(Uri server, String betaKey) async {
  final client = HttpClient()
    ..userAgent = null
    ..connectionTimeout = _wait;
  final bytes = BytesBuilder(copy: false);
  try {
    final request = await client.postUrl(server.resolve('painting')).timeout(_wait);
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
    request.headers.contentType = ContentType.json;
    request.contentLength = 2;
    request.write('{}');
    final reply = await request.close().timeout(_wait);
    if (reply.statusCode != 200) throw PaintingFailure(reply.statusCode);
    await for (final chunk in reply.timeout(_wait)) {
      bytes.add(chunk);
      if (bytes.length > maxPaintingBytes) throw const PaintingFailure(-1);
    }
  } on PaintingFailure {
    rethrow;
  } on Object {
    throw const PaintingFailure(0);
  } finally {
    client.close(force: true);
  }
  final jpeg = bytes.takeBytes();
  if (!isJpeg(jpeg)) throw const PaintingFailure(-1);
  return jpeg;
}

/// SoulDreams Dev's own: our server, with the build's beta key; with no
/// server or a beta key not of its shape, every painting fails (-2).
SendPainting livePainting({required String betaKey, String server = Hosts.server}) {
  final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);
  return () async {
    if (!on) throw const PaintingFailure(-2);
    return postPainting(Uri.parse(server), betaKey);
  };
}

/// What one painting did.
enum Painted { nothing, made, failed, gone }

/// Paints [night] with [send] and keeps it in [journal], when Night images
/// is Personal ([images]), the night is read, it has no painting yet and
/// fewer than [maxPaintTries] tries have failed; [sending] is told just
/// before the request goes. A failure is counted, and shows nothing. Never
/// throws.
Future<Painted> paintNight(
  Journal journal,
  SendPainting send,
  Night night,
  NightImages images, {
  void Function()? sending,
}) async {
  if (images != NightImages.personal || night.readings == null) return Painted.nothing;
  try {
    if (await journal.painting(night.id) != null) return Painted.nothing;
    if (await journal.paintTries(night.id) >= maxPaintTries) return Painted.nothing;
  } on Object {
    SafeLog.event(LogEvent.paintingKeepFailed);
    return Painted.nothing;
  }
  sending?.call();
  final Uint8List jpeg;
  try {
    jpeg = await send();
  } on Object catch (e) {
    SafeLog.event(LogEvent.paintingFailed, [e is PaintingFailure ? e.status : -3]);
    try {
      await journal.countPaintTry(night.id);
    } on Object {
      SafeLog.event(LogEvent.paintingKeepFailed);
    }
    return Painted.failed;
  }
  final bool kept;
  try {
    kept = await journal.keepPainting(night.id, jpeg);
  } on Object {
    SafeLog.event(LogEvent.paintingKeepFailed);
    return Painted.failed;
  }
  if (!kept) return Painted.gone;
  SafeLog.event(LogEvent.paintingMade, [jpeg.length]);
  return Painted.made;
}

/// Paints nights, one request at a time for each night: a night already
/// being painted is not asked for again, and whoever asks waits for the one
/// under way.
final class Painter {
  Painter(this._send);

  final SendPainting _send;
  final _under = <String, Future<Painted>>{};

  /// Whether night [id] is being painted now.
  bool busy(String id) => _under.containsKey(id);

  /// As [paintNight]; [sending] is told at once when the night is already
  /// being painted.
  Future<Painted> paint(Journal journal, Night night, NightImages images, {void Function()? sending}) {
    final under = _under[night.id];
    if (under != null) {
      sending?.call();
      return under;
    }
    final run = paintNight(journal, _send, night, images, sending: sending);
    _under[night.id] = run;
    return run.whenComplete(() => _under.remove(night.id));
  }
}
