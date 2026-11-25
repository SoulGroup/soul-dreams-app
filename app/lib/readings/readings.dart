// The readings, in plain Dart (head's message 33; D155 item 1): one POST to
// our server's /reading with the beta key and the night: its language, its
// dreams told in words and, only while Life Context is on, the sentences it
// keeps (D134; Off sends nothing kept); nothing that names the phone (R4).
// The answer is one to three readings, each a tradition (its place among
// the lens labels, W13) and its words, and each model call's counts and cost
// (head's message 34), kept beside the readings only in the builds that keep
// them (SoulDreams Dev; the founder's, later). What Start Interpretation does: the
// readings kept in the night, which is then read; a failure keeps nothing,
// and the night stays unread (handover §5). Nothing of a night is ever
// logged: a failure logs its status alone (R3). SoulDreams Dev only; until
// the instructions come, our server answers with its stand-in.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../core/hosts.dart';
import '../core/safe_log.dart';
import '../journal/journal.dart';
import '../journal/night.dart';
import '../life_context/life_context.dart';

/// The server gave no readings: its HTTP status, 0 for no answer, -1 for an
/// answer that is not one to three whole readings, -2 for no server or beta
/// key in this build.
final class ReadingFailure implements Exception {
  const ReadingFailure(this.status);

  final int status;
}

/// A night's answer: its readings, and its calls' counts where kept.
typedef NightAnswer = ({List<Reading> readings, List<ModelUsage>? usage});

/// Sends one night's request; completes with its answer.
typedef SendNight = Future<NightAnswer> Function(Map<String, Object?> body);

const _wait = Duration(seconds: 30);
final _betaShape = RegExp(r'^[A-Za-z0-9]{48}$');
const _readingKeys = {'lens', 'text'};
const _answerKeys = {'readings', 'usage'};

/// The request for [night]: its language and its dreams in words, and
/// [kept] only when given (Life Context on).
Map<String, Object?> requestOf(Night night, List<String>? kept) => {
  'lang': night.lang.name,
  'dreams': night.dreams,
  'kept': ?kept,
};

// The answer in [json], or null when it is not one to three whole readings
// and a list of whole calls.
NightAnswer? _answerOf(Object? json) {
  if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _answerKeys)) return null;
  final calls = json['usage'];
  if (calls is! List<Object?>) return null;
  final usage = [for (final c in calls) ModelUsage.fromJson(c)];
  if (usage.contains(null)) return null;
  final list = json['readings'];
  if (list is! List<Object?> || list.isEmpty || list.length > maxReadings) return null;
  final readings = <Reading>[];
  for (final r in list) {
    if (r is! Map<String, Object?> || !setEquals(r.keys.toSet(), _readingKeys)) return null;
    final lens = r['lens'];
    final text = r['text'];
    if (lens is! int || lens < 0 || text is! String || text.isEmpty) return null;
    readings.add(Reading(lens, text));
  }
  return (readings: readings, usage: usage.cast<ModelUsage>());
}

/// Sends [body] to [server]'s /reading; completes with the answer (200).
Future<NightAnswer> postReading(Uri server, String betaKey, Map<String, Object?> body) async {
  final client = HttpClient()
    ..userAgent = null
    ..connectionTimeout = _wait;
  final String answer;
  try {
    final bytes = utf8.encode(jsonEncode(body));
    final request = await client.postUrl(server.resolve('reading')).timeout(_wait);
    request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $betaKey');
    request.headers.contentType = ContentType.json;
    request.contentLength = bytes.length;
    request.add(bytes);
    final reply = await request.close().timeout(_wait);
    if (reply.statusCode != 200) throw ReadingFailure(reply.statusCode);
    try {
      answer = await utf8.decodeStream(reply).timeout(_wait);
    } on FormatException {
      throw const ReadingFailure(-1);
    }
  } on ReadingFailure {
    rethrow;
  } on Object {
    throw const ReadingFailure(0);
  } finally {
    client.close(force: true);
  }
  final Object? json;
  try {
    json = jsonDecode(answer);
  } on FormatException {
    throw const ReadingFailure(-1);
  }
  return _answerOf(json) ?? (throw const ReadingFailure(-1));
}

/// SoulDreams Dev's own: our server, with the build's beta key; with no
/// server or a beta key not of its shape, every reading fails (-2). The
/// calls' counts are kept only when [keepUsage] (head's message 34).
SendNight liveReading({required String betaKey, String server = Hosts.server, bool keepUsage = false}) {
  final on = server.isNotEmpty && _betaShape.hasMatch(betaKey);
  return (body) async {
    if (!on) throw const ReadingFailure(-2);
    final answer = await postReading(Uri.parse(server), betaKey, body);
    return keepUsage ? answer : (readings: answer.readings, usage: null);
  };
}

/// What Life Context gives a reading (D134): while on, the sentences in
/// the Recent window, word for word; while off, or with none, nothing.
Future<List<String>?> keptFor(LifeContext? life) async {
  if (life == null || !life.on) return null;
  final recent = await life.recent();
  // Off may have come while the sentences were read: nothing goes (D134).
  if (!life.on) return null;
  return [for (final k in recent) k.text];
}

/// Reads a night: its request made at the moment of reading.
final class Reader {
  Reader(this._send, this._kept);

  final SendNight _send;
  final Future<List<String>?> Function() _kept;

  Future<NightAnswer> read(Night night) async => _send(requestOf(night, await _kept()));
}

/// What one Start Interpretation did.
enum Interpreted { nothing, read, failed, gone }

/// Reads [night] with [reader] and keeps its readings in [journal]. A night
/// already read, or with no dream in words yet, is not sent.
Future<Interpreted> interpret(Journal journal, Reader reader, Night night) async {
  if (night.readings != null || night.dreams.isEmpty) return Interpreted.nothing;
  final NightAnswer answer;
  try {
    answer = await reader.read(night);
  } on Object catch (e) {
    SafeLog.event(LogEvent.readingFailed, [e is ReadingFailure ? e.status : -3]);
    return Interpreted.failed;
  }
  final bool kept;
  try {
    kept = await journal.keepReadings(night.id, answer.readings, usage: answer.usage);
  } on Object {
    SafeLog.event(LogEvent.readingKeepFailed);
    return Interpreted.failed;
  }
  if (!kept) return Interpreted.gone;
  SafeLog.event(LogEvent.readingRead, [answer.readings.length]);
  return Interpreted.read;
}
