// A night as the journal keeps it on the phone (D49 b; R11), and its
// file format. Which fields a night holds is settled with Product's
// answers; until the format first reaches the founder app it may change
// freely (D49, O5). After that, any change is a storage change
// (docs/workflow.md, "On-phone storage changes"). Version 2 (D92, D93
// Q2): a dream may be a recording that waits on the phone to be turned
// into text; version 1 files still read, and are written as version 2
// when next saved.
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../words/lines.g.dart' show Lang;

/// The file format's version, written in every night's file.
const formatVersion = 2;

/// The version before it, still read (docs/workflow.md (c)).
const _firstVersion = 1;

final _id = RegExp(r'^[0-9a-f]{32}$');
const _waitingKeys = {'waiting', 'from'};
final _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
const _keys = {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'};

/// A new night's id: 128 bits from the system's secure source, as 32 hex
/// digits. It names a file on the phone and is never sent anywhere (R4).
String newNightId([Random? random]) {
  final r = random ?? Random.secure();
  return [for (var i = 0; i < 16; i++) r.nextInt(256).toRadixString(16).padLeft(2, '0')].join();
}

/// The longest a night stays open after its first recording: the next 21:00
/// is at most 25 hours on, across a clock change (D61). A file that says
/// more is damaged.
const maxOpen = Duration(hours: 26);

/// A calendar date, as the phone showed it at the first recording.
typedef NightDate = ({int year, int month, int day});

// A real day its file can hold: four digits of year, a month and a day
// that exist. The constructor and decodeNight share it, so every night
// that can be made reads back after a save.
bool _isDay(int y, int m, int d) {
  if (y < 0 || y > 9999) return false;
  final check = DateTime.utc(y, m, d);
  return check.year == y && check.month == m && check.day == d;
}

/// One of a night's dreams, in order: told in words, or a recording that
/// waits to be turned into text (D93 Q2).
sealed class Dream {
  const Dream();
}

/// A dream in the dreamer's words.
final class Told extends Dream {
  const Told(this.text);

  final String text;

  @override
  bool operator ==(Object other) => other is Told && other.text == text;

  @override
  int get hashCode => text.hashCode;
}

/// A recording kept on the phone until its words come (D92, D94): its
/// audio's id, and how many bytes from its start are already in words
/// (always whole samples, so even).
final class Waiting extends Dream {
  Waiting(this.audio, [this.from = 0]) {
    if (!_id.hasMatch(audio)) throw ArgumentError('audio');
    if (from < 0 || from.isOdd) throw ArgumentError('from');
  }

  final String audio;
  final int from;

  @override
  bool operator ==(Object other) => other is Waiting && other.audio == audio && other.from == from;

  @override
  int get hashCode => Object.hash(audio, from);
}

final class Night {
  /// A night of [dreams] told in words, or of [entries] (told or waiting);
  /// never both.
  Night({
    required this.id,
    required this.firstRecorded,
    required this.date,
    required this.closes,
    required this.lang,
    this.name,
    List<String> dreams = const [],
    List<Dream>? entries,
  }) : entries = List.unmodifiable(entries ?? [for (final d in dreams) Told(d)]) {
    if (entries != null && dreams.isNotEmpty) throw ArgumentError('dreams');
    final audio = [for (final e in this.entries) if (e is Waiting) e.audio];
    if (audio.toSet().length != audio.length) throw ArgumentError('entries');
    if (!_id.hasMatch(id)) throw ArgumentError('id');
    if (!firstRecorded.isUtc) throw ArgumentError('firstRecorded');
    if (!_isDay(date.year, date.month, date.day)) throw ArgumentError('date');
    if (!closes.isUtc || !closes.isAfter(firstRecorded) || closes.difference(firstRecorded) > maxOpen) {
      throw ArgumentError('closes');
    }
  }

  final String id;

  /// The moment of the first recording, in UTC.
  final DateTime firstRecorded;

  /// The phone's date at the first recording, kept so that it never moves.
  final NightDate date;

  /// The first 21:00 after the first recording, in the zone in force at
  /// that moment, in UTC (C152-I item 2; D58 Q2, P9). Fixed once: a later
  /// change of zone or clock never moves it.
  final DateTime closes;

  /// The language the night was recorded in.
  final Lang lang;

  /// The dreamer's name for the night, if they gave one.
  final String? name;

  /// The dreams, in order: told, or waiting to be turned into text.
  final List<Dream> entries;

  /// The dreams told in words, in order.
  List<String> get dreams => List.unmodifiable([for (final e in entries) if (e is Told) e.text]);

  /// The same night holding [entries] instead.
  Night withEntries(List<Dream> entries) => Night(
      id: id, firstRecorded: firstRecorded, date: date, closes: closes, lang: lang, name: name, entries: entries);

  /// The same night holding [dreams], all told, instead.
  Night withDreams(List<String> dreams) => withEntries([for (final d in dreams) Told(d)]);

  @override
  bool operator ==(Object other) =>
      other is Night &&
      other.id == id &&
      other.firstRecorded == firstRecorded &&
      other.date == date &&
      other.closes == closes &&
      other.lang == lang &&
      other.name == name &&
      listEquals(other.entries, entries);

  @override
  int get hashCode => Object.hash(id, firstRecorded, date, closes, lang, name, Object.hashAll(entries));
}

String _two(int n) => n.toString().padLeft(2, '0');

/// The night's file: UTF-8 JSON, version [formatVersion].
Uint8List encodeNight(Night n) => utf8.encode(jsonEncode({
      'version': formatVersion,
      'id': n.id,
      'firstRecorded': n.firstRecorded.toIso8601String(),
      'date': '${n.date.year.toString().padLeft(4, '0')}-${_two(n.date.month)}-${_two(n.date.day)}',
      'closes': n.closes.toIso8601String(),
      'lang': n.lang.name,
      'name': n.name,
      'dreams': [
        for (final e in n.entries)
          switch (e) {
            Told(:final text) => text,
            Waiting(:final audio, :final from) => {'waiting': audio, 'from': from},
          },
      ],
    }));

// One dream as its file holds it: words, or (from version 2) a waiting
// recording; null when it is neither.
Dream? _dreamOf(Object? x, int version) {
  if (x is String) return Told(x);
  if (version == _firstVersion || x is! Map<String, Object?> || !setEquals(x.keys.toSet(), _waitingKeys)) {
    return null;
  }
  final audio = x['waiting'];
  final from = x['from'];
  if (audio is! String || !_id.hasMatch(audio) || from is! int || from < 0 || from.isOdd) return null;
  return Waiting(audio, from);
}

/// The night in [bytes], or null when they are not a whole night of
/// version 1 or 2. Nothing is guessed or repaired.
Night? decodeNight(Uint8List bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _keys)) return null;
  if (json
      case {
        'version': final int version,
        'id': final String id,
        'firstRecorded': final String recorded,
        'date': final String date,
        'closes': final String closes,
        'lang': final String lang,
        'name': final String? name,
        'dreams': final List<Object?> dreams,
      }) {
    final at = DateTime.tryParse(recorded);
    final shut = DateTime.tryParse(closes);
    final d = _date.firstMatch(date);
    final language = Lang.values.where((l) => l.name == lang).firstOrNull;
    if (version != formatVersion && version != _firstVersion) return null;
    if (!_id.hasMatch(id) || at == null || !at.isUtc || d == null || language == null) return null;
    if (shut == null || !shut.isUtc || !shut.isAfter(at) || shut.difference(at) > maxOpen) return null;
    final (y, m, day) = (int.parse(d[1]!), int.parse(d[2]!), int.parse(d[3]!));
    if (!_isDay(y, m, day)) return null;
    final entries = [for (final x in dreams) _dreamOf(x, version)];
    if (entries.contains(null)) return null;
    final audio = [for (final e in entries) if (e is Waiting) e.audio];
    if (audio.toSet().length != audio.length) return null;
    return Night(
      id: id,
      firstRecorded: at,
      date: (year: y, month: m, day: day),
      closes: shut,
      lang: language,
      name: name,
      entries: entries.cast<Dream>(),
    );
  }
  return null;
}
