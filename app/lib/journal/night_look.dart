// A night's look (D110, head's messages 24 and 25), in plain Dart: a read
// night shows one painting of the set shipped in the app, chosen from the
// night's id alone, so from none of its words, and the same every time; an
// unread night shows the painted gradient, and so does any night while the
// app holds no painting, and every night while Night images is Off (D121
// item 3). While Night images is Personal, a read night whose own painting
// has come shows it (D162); until then, and always while Random, it shows
// the set's (D121 item 3; D122, the stop's question 9). The choice from the
// set stores nothing: the id is already random (128 bits from the phone's
// secure source, newNightId).
import 'dart:typed_data';

import 'night.dart';

sealed class NightLook {
  const NightLook();
}

/// The painted gradient: an unread night, or no painting to show.
final class PaintedGradient extends NightLook {
  const PaintedGradient();

  @override
  bool operator ==(Object other) => other is PaintedGradient;

  @override
  int get hashCode => 0;
}

/// The painting at [index] in the set.
final class Painting extends NightLook {
  const Painting(this.index);

  final int index;

  @override
  bool operator ==(Object other) => other is Painting && other.index == index;

  @override
  int get hashCode => index;
}

/// The night's own painting, from our server (D162): its JPEG.
final class PersonalPainting extends NightLook {
  const PersonalPainting(this.jpeg);

  final Uint8List jpeg;

  @override
  bool operator ==(Object other) => other is PersonalPainting && identical(other.jpeg, jpeg);

  @override
  int get hashCode => identityHashCode(jpeg);
}

/// Which of [count] paintings the night with [id] shows: its id's first 32
/// bits, modulo the count.
int paintingFor(String id, int count) => int.parse(id.substring(0, 8), radix: 16) % count;

/// The look of [night], [read] or not, with [paintings] in the set,
/// [images] false while Night images is Off, and [personal] its own
/// painting, given only while Night images is Personal.
NightLook lookOf(Night night, {required bool read, required int paintings, bool images = true, Uint8List? personal}) {
  if (!images || !read) return const PaintedGradient();
  if (personal != null) return PersonalPainting(personal);
  return paintings > 0 ? Painting(paintingFor(night.id, paintings)) : const PaintedGradient();
}

/// Whether a night has been read.
typedef ReadCheck = bool Function(Night night);

/// The readings come later, so no night is read yet.
bool noneRead(Night night) => false;

/// Whether [night] holds its readings (D155 item 2): SoulDreams Dev's.
bool isRead(Night night) => night.readings != null;

/// Every night read: SoulDreams Dev's by-eye preview of a read night's look
/// only, in a build made with --dart-define=PREVIEW_READ=true (D110).
bool allRead(Night night) => true;
