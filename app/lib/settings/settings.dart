// What the dreamer sets for themselves (main-path.md, Settings; C18-P,
// MP·26, MP·44, MP·84, MP·85; D110; D121; D122; D125 item 8), in plain Dart,
// kept on the phone in the journal's folder (R11; docs/workflow.md (c)):
// Word Animation, on by default (D110); Night/Day mode, Automatic by
// default, or Manual, Day or Night; Night images, Personal by default
// (D160), or Random or Off, with no consent behind it (D125 item 8); Life
// Context's length, 2 weeks by default (C159-I item 1), remembered now and
// used once Life Context is built (D121 item 2). Whether Life Context is on
// is consent (b), kept with the consents (`consents.dart`), never here.
// Written as version 2. Version 1, which chose a painting for while the
// retired consent (c) was given, still reads: as that choice only where (c)
// was given, else Night images is Off, so nothing is sent that was not
// agreed to; the store keeps it again as version 2.
import 'dart:convert';
import 'dart:typed_data';

import '../core/night_day.dart';

/// Night images (MP·85).
enum NightImages { personal, random, off }

/// Life Context length (MP·84), in its order.
enum LifeContextLength { oneWeek, twoWeeks, oneMonth, threeMonths }

final class Settings {
  const Settings({
    this.wordAnimation = true,
    this.nightDay = NightDayMode.automatic,
    this.images = NightImages.personal,
    this.length = LifeContextLength.twoWeeks,
  });

  final bool wordAnimation;
  final NightDayMode nightDay;

  final NightImages images;

  final LifeContextLength length;

  Settings copyWith({bool? wordAnimation, NightDayMode? nightDay, NightImages? images, LifeContextLength? length}) =>
      Settings(
        wordAnimation: wordAnimation ?? this.wordAnimation,
        nightDay: nightDay ?? this.nightDay,
        images: images ?? this.images,
        length: length ?? this.length,
      );

  @override
  bool operator ==(Object other) =>
      other is Settings &&
      other.wordAnimation == wordAnimation &&
      other.nightDay == nightDay &&
      other.images == images &&
      other.length == length;

  @override
  int get hashCode => Object.hash(wordAnimation, nightDay, images, length);
}

/// The file's bytes: version 2.
Uint8List encodeSettings(Settings s) => utf8.encode(
  jsonEncode({
    'version': 2,
    'wordAnimation': s.wordAnimation,
    'nightDay': s.nightDay.name,
    'images': s.images.name,
    'length': s.length.name,
  }),
);

T? _named<T extends Enum>(List<T> values, Object? name) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

/// Whether [bytes] hold a version 1 settings file.
bool isOldSettings(Uint8List bytes) {
  try {
    final json = jsonDecode(utf8.decode(bytes));
    return json is Map<String, dynamic> && json['version'] == 1;
  } on FormatException {
    return false;
  }
}

/// The settings [bytes] hold, or null when they do not read as version 2
/// exactly, or version 1 exactly. A version 1 painting counts only when
/// [imagesGiven] says consent (c) was given; else Night images is Off.
Settings? decodeSettings(Uint8List bytes, {bool imagesGiven = false}) {
  final Object? json;
  try {
    json = jsonDecode(utf8.decode(bytes));
  } on FormatException {
    return null;
  }
  if (json is! Map<String, dynamic> || json.length != 5) return null;
  final old = json['version'] == 1;
  if (!old && json['version'] != 2) return null;
  final animation = json['wordAnimation'];
  final nightDay = _named(NightDayMode.values, json['nightDay']);
  final images = _named(NightImages.values, json['images']);
  final length = _named(LifeContextLength.values, json['length']);
  if (animation is! bool || nightDay == null || images == null || length == null) return null;
  // Version 1 never held Off.
  if (old && images == NightImages.off) return null;
  return Settings(
    wordAnimation: animation,
    nightDay: nightDay,
    images: old && !imagesGiven ? NightImages.off : images,
    length: length,
  );
}
