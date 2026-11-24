// Feedback (D110; C18-P's MP·49, C4-P·8, MP·46 and MP·47; D152), in plain
// Dart: one POST to our server's /feedback with the beta key and the text
// alone, nothing that names the phone (R4); and what Submit does. Empty or
// blank, or while a send is under way, it does nothing; before the dreamer
// has agreed it asks for the popup (MP·101, D128 item 3) and sends nothing;
// otherwise it sends once. A text of invisible characters only (zero-width
// spaces, U+0000 and the like) is blank too (D156). The text is never kept
// on the phone (R11) and never logged: a failure logs its status alone
// (R3). SoulDreams Dev only (D152 item 5).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/hosts.dart';
import '../core/safe_log.dart';

/// At most this many characters, as a person counts them (D152 item 3).
const feedbackLimit = 2000;

/// The server did not keep it: its HTTP status, 0 for no answer, -2 for no
/// server or beta key in this build.
final class FeedbackFailure implements Exception {
  const FeedbackFailure(this.status);

  final int status;
}

typedef SendFeedback = Future<void> Function(String text);

const _wait = Duration(seconds: 15);
final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');

// Nothing a person can see: whitespace, control characters such as U+0000,
// and the characters Unicode marks as default-ignorable, such as the
// zero-width space and the joiners (D156).
final _invisible = RegExp(r'^[\p{White_Space}\p{Cc}\p{Default_Ignorable_Code_Point}]*$', unicode: true);

/// Sends [text] to [server]'s /feedback; completes when it is kept (204).
Future<void> postFeedback(Uri server, String betaKey, String text) async {
  final client = HttpClient()
    ..userAgent = null
    ..connectionTimeout = _wait;
  try {
    final body = utf8.encode(jsonEncode({'text': text}));
    final request = await client.postUrl(server.resolve('feedback')).timeout(_wait);
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
    request.headers.contentType = ContentType.json;
    request.contentLength = body.length;
    request.add(body);
    final reply = await request.close().timeout(_wait);
    await reply.drain<void>().timeout(_wait);
    if (reply.statusCode != 204) throw FeedbackFailure(reply.statusCode);
  } on FeedbackFailure {
    rethrow;
  } on Object {
    throw const FeedbackFailure(0);
  } finally {
    client.close(force: true);
  }
}

/// SoulDreams Dev's own: our server, with the build's beta key; with no
/// server or a beta key not of its shape, every send fails (-2).
SendFeedback liveFeedback({required String betaKey, String server = Hosts.server}) {
  final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);
  return (text) async {
    if (!on) throw const FeedbackFailure(-2);
    await postFeedback(Uri.parse(server), betaKey, text);
  };
}

/// Where the section stands: nothing yet, sending, sent, or not sent.
enum FeedbackState { idle, sending, sent, unsent }

/// What one Submit did.
enum Submitted { nothing, popup, sent, unsent }

final class FeedbackForm extends ChangeNotifier {
  FeedbackForm(this._send);

  final SendFeedback _send;

  FeedbackState get state => _state;
  FeedbackState _state = FeedbackState.idle;

  /// Submit with [text] in the box.
  Future<Submitted> submit(String text, {required bool agreed}) async {
    if (_state == FeedbackState.sending || _invisible.hasMatch(text)) return Submitted.nothing;
    if (!agreed) return Submitted.popup;
    _set(FeedbackState.sending);
    try {
      await _send(text);
    } on Object catch (e) {
      SafeLog.event(LogEvent.feedbackFailed, [e is FeedbackFailure ? e.status : -1]);
      _set(FeedbackState.unsent);
      return Submitted.unsent;
    }
    SafeLog.event(LogEvent.feedbackSent);
    _set(FeedbackState.sent);
    return Submitted.sent;
  }

  /// The box's text changed: a line from the last Submit goes.
  void edited() {
    if (_state == FeedbackState.sent || _state == FeedbackState.unsent) _set(FeedbackState.idle);
  }

  void _set(FeedbackState next) {
    _state = next;
    notifyListeners();
  }
}
