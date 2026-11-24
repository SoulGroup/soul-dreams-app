// A night as the journal keeps it on the phone (D49 b; R11), and its
// file format. Which fields a night holds is settled with Product's
// answers; until the format first reaches the founder app it may change
// freely (D49, O5). After that, any change is a storage change
// (docs/workflow.md, "On-phone storage changes"). Version 2 (D92, D93
// Q2): a dream may be a recording that waits on the phone to be turned
// into text. Version 3 (D155 item 2): a read night holds its readings,
// an unread one null; and, beside them, each model call's counts and cost
// (head's message 34), in the builds that keep them, else null. Version 1
// and 2 files still read, unread, and are written as version 3 when next
// saved.
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../words/lines.g.dart' show Lang;

/// The file format's version, written in every night's file.
const formatVersion = 3;

/// The versions before it, still read (docs/workflow.md (c)).
const _firstVersion = 1;
const _secondVersion = 2;

/// At most three readings a night (L3).
const maxReadings = 3;

final _id = RegExp(r'^[0-9a-f]{32}$');
const _waitingKeys = {'waiting', 'from'};
final _date = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$');
const _keys = {'version', 'id', 'firstRecorded', 'date', 'closes', 'lang', 'name', 'dreams'};
const _readKeys = {..._keys, 'readings', 'usage'};
const _readingKeys = {'lens', 'text'};
const _usageKeys = {'step', 'model', 'input', 'output', 'cacheRead', 'cacheWrite', 'cost'};

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

/// One of a read night's readings, as our server gave it (head's message
/// 33): its tradition, as its place among the lens labels (W13), and its
/// words.
final class Reading {
  Reading(this.lens, this.text) {
    if (lens < 0) throw ArgumentError('lens');
    if (text.isEmpty) throw ArgumentError('text');
  }

  final int lens;
  final String text;

  @override
  bool operator ==(Object other) => other is Reading && other.lens == lens && other.text == text;

  @override
  int get hashCode => Object.hash(lens, text);
}

/// One model call's counts, as our server gave them (head's message 34): its
/// step and model by name, its input, output, cache-read and cache-written
/// tokens, and its cost in millionths of a US dollar. Never a word.
final class ModelUsage {
  ModelUsage({
    required this.step,
    required this.model,
    required this.input,
    required this.output,
    required this.cacheRead,
    required this.cacheWrite,
    required this.cost,
  }) {
    if (step.isEmpty) throw ArgumentError('step');
    if (model.isEmpty) throw ArgumentError('model');
    if ([input, output, cacheRead, cacheWrite, cost].any((n) => n < 0)) throw ArgumentError('count');
  }

  final String step;
  final String model;
  final int input;
  final int output;
  final int cacheRead;
  final int cacheWrite;
  final int cost;

  /// As its file and our server's answer hold it.
  Map<String, Object> toJson() => {
    'step': step,
    'model': model,
    'input': input,
    'output': output,
    'cacheRead': cacheRead,
    'cacheWrite': cacheWrite,
    'cost': cost,
  };

  /// The call in [json], or null when it is not one whole call.
  static ModelUsage? fromJson(Object? json) {
    if (json is! Map<String, Object?> || !setEquals(json.keys.toSet(), _usageKeys)) return null;
    if (json
        case {
          'step': final String step,
          'model': final String model,
          'input': final int input,
          'output': final int output,
          'cacheRead': final int cacheRead,
          'cacheWrite': final int cacheWrite,
          'cost': final int cost,
        }) {
      if (step.isEmpty || model.isEmpty || [input, output, cacheRead, cacheWrite, cost].any((n) => n < 0)) {
        return null;
      }
      return ModelUsage(
        step: step,
        model: model,
        input: input,
        output: output,
        cacheRead: cacheRead,
        cacheWrite: cacheWrite,
        cost: cost,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is ModelUsage && mapEquals(other.toJson(), toJson());

  @override
  int get hashCode => Object.hashAll(toJson().values);
}

final class Night {
  /// A night of [dreams] told in words, or of [entries] (told or waiting);
  /// never both. Read when it holds [readings], one to three; [usage] only
  /// beside them.
  Night({
    required this.id,
    required this.firstRecorded,
    required this.date,
    required this.closes,
    required this.lang,
    this.name,
    List<String> dreams = const [],
    List<Dream>? entries,
    List<Reading>? readings,
    List<ModelUsage>? usage,
  }) : entries = List.unmodifiable(entries ?? [for (final d in dreams) Told(d)]),
       readings = readings == null ? null : List.unmodifiable(readings),
       usage = usage == null ? null : List.unmodifiable(usage) {
    if (usage != null && readings == null) throw ArgumentError('usage');
    if (entries != null && dreams.isNotEmpty) throw ArgumentError('dreams');
    if (readings != null && (readings.isEmpty || readings.length > maxReadings)) throw ArgumentError('readings');
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

  /// Its readings, in the order given, once read; null while unread.
  final List<Reading>? readings;

  /// The model calls that made its readings, where the build keeps them
  /// (SoulDreams Dev, the founder's); else null.
  final List<ModelUsage>? usage;

  /// The dreams told in words, in order.
  List<String> get dreams => List.unmodifiable([for (final e in entries) if (e is Told) e.text]);

  /// The same night holding [entries] instead; read or not as it was.
  Night withEntries(List<Dream> entries) => Night(
      id: id,
      firstRecorded: firstRecorded,
      date: date,
      closes: closes,
      lang: lang,
      name: name,
      entries: entries,
      readings: readings,
      usage: usage);

  /// The same night, read: holding [readings], and [usage] if kept.
  Night withReadings(List<Reading> readings, {List<ModelUsage>? usage}) => Night(
      id: id,
      firstRecorded: firstRecorded,
      date: date,
      closes: closes,
      lang: lang,
      name: name,
      entries: entries,
      readings: readings,
      usage: usage);

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
      listEquals(other.entries, entries) &&
      listEquals(other.readings, readings) &&
      listEquals(other.usage, usage);

  @override
  int get hashCode => Object.hash(id, firstRecorded, date, closes, lang, name, Object.hashAll(entries),
      switch (readings) { null => null, final r => Object.hashAll(r) },
      switch (usage) { null => null, final u => Object.hashAll(u) });
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
      'readings': switch (n.readings) {
        null => null,
        final readings => [for (final r in readings) {'lens': r.lens, 'text': r.text}],
      },
      'usage': n.usage?.map((u) => u.toJson()).toList(),
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

// A version-3 file's readings: (null,) for an unread night; null when they
// are not one to three whole readings.
(List<Reading>?,)? _readingsOf(Object? x) {
  if (x == null) return (null,);
  if (x is! List<Object?> || x.isEmpty || x.length > maxReadings) return null;
  final readings = <Reading>[];
  for (final r in x) {
    if (r is! Map<String, Object?> || !setEquals(r.keys.toSet(), _readingKeys)) return null;
    final lens = r['lens'];
    final text = r['text'];
    if (lens is! int || lens < 0 || text is! String || text.isEmpty) return null;
    readings.add(Reading(lens, text));
  }
  return (readings,);
}

// A version-3 file's usage: (null,) for none; null when it is not a list of
// whole calls, or held by an unread night.
(List<ModelUsage>?,)? _usageOf(Object? x, bool read) {
  if (x == null) return (null,);
  if (x is! List<Object?> || !read) return null;
  final usage = [for (final u in x) ModelUsage.fromJson(u)];
  return usage.contains(null) ? null : (usage.cast<ModelUsage>(),);
}

/// The night in [bytes], or null when they are not a whole night of
/// version 1, 2 or 3. Nothing is guessed or repaired.
Night? decodeNight(Uint8List bytes) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, Object?>) return null;
  // Only version 3 holds the readings' field (D155 item 2).
  if (!setEquals(json.keys.toSet(), json['version'] == formatVersion ? _readKeys : _keys)) return null;
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
    if (version != formatVersion && version != _secondVersion && version != _firstVersion) return null;
    if (!_id.hasMatch(id) || at == null || !at.isUtc || d == null || language == null) return null;
    if (shut == null || !shut.isUtc || !shut.isAfter(at) || shut.difference(at) > maxOpen) return null;
    final (y, m, day) = (int.parse(d[1]!), int.parse(d[2]!), int.parse(d[3]!));
    if (!_isDay(y, m, day)) return null;
    final entries = [for (final x in dreams) _dreamOf(x, version)];
    if (entries.contains(null)) return null;
    final audio = [for (final e in entries) if (e is Waiting) e.audio];
    if (audio.toSet().length != audio.length) return null;
    final read = version == formatVersion ? _readingsOf(json['readings']) : (null,);
    if (read == null) return null;
    final used = version == formatVersion ? _usageOf(json['usage'], read.$1 != null) : (null,);
    if (used == null) return null;
    return Night(
      id: id,
      firstRecorded: at,
      date: (year: y, month: m, day: day),
      closes: shut,
      lang: language,
      name: name,
      entries: entries.cast<Dream>(),
      readings: read.$1,
      usage: used.$1,
    );
  }
  return null;
}
