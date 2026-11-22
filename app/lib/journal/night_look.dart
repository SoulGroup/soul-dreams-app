// A night's look (D110, head's messages 24 and 25), in plain Dart: a read
// night shows one painting of the set shipped in the app, chosen from the
// night's id alone, so from none of its words, and the same every time; an
// unread night shows the painted gradient, and so does any night while the
// app holds no painting, and every night while Night images is Off (D121
// item 3). Personal and Random both show the set until the personal
// painting exists (D121 item 3; D122, the stop's question 9). Nothing is stored: the id is already random (128
// bits from the phone's secure source, newNightId).
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

/// Which of [count] paintings the night with [id] shows: its id's first 32
/// bits, modulo the count.
int paintingFor(String id, int count) => int.parse(id.substring(0, 8), radix: 16) % count;

/// The look of [night], [read] or not, with [paintings] in the set, and
/// [images] false while Night images is Off.
NightLook lookOf(Night night, {required bool read, required int paintings, bool images = true}) =>
    images && read && paintings > 0 ? Painting(paintingFor(night.id, paintings)) : const PaintedGradient();

/// Whether a night has been read.
typedef ReadCheck = bool Function(Night night);

/// The readings come later, so no night is read yet.
bool noneRead(Night night) => false;

/// Every night read: SoulDreams Dev's by-eye preview of a read night's look
/// only, in a build made with --dart-define=PREVIEW_READ=true (D110).
bool allRead(Night night) => true;
