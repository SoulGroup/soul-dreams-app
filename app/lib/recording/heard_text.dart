// Words heard, joined to the field's text (D71 Q6): always at the end,
// never at the caret. The provisional words are shown after the final
// ones and replaced by the next reply: [withoutPiece] takes out what is
// left of the last piece, whatever the dreamer edited (Task 16e).
// Soniox's tokens are sub-word pieces with their spaces inside them (D73),
// so their text is joined exactly as sent; the only thing trimmed is a
// space at the very start of an empty field. At the start of a recording
// session only (D74), one space joins the typed words to the first piece
// heard, when neither side has a whitespace at the join.
final _space = RegExp(r'\s');

String _join(String base, String add, {bool spaced = false}) {
  if (base.isEmpty) return add.trimLeft();
  if (spaced && add.isNotEmpty && !_space.hasMatch(base[base.length - 1]) && !_space.hasMatch(add[0])) {
    return '$base $add';
  }
  return base + add;
}

/// The field's text [now] without what is left of the provisional piece
/// that started at [at], [length] long, in [was], the text the page last
/// set (Task 16e). The dreamer's edit since, if any, is placed by the
/// longest common start and end (never overlapping); every character of the
/// piece the edit left goes, wherever it is now, and every character the
/// dreamer put there stays. So the field never holds more than one
/// provisional piece, nor a stale one after a newer reply (D75 to D77 kept:
/// an edit before the piece moves it; the dreamer's own copies stay).
String withoutPiece(String was, String now, int at, int length) {
  if (length == 0) return now;
  final most = was.length < now.length ? was.length : now.length;
  var head = 0;
  while (head < most && was.codeUnitAt(head) == now.codeUnitAt(head)) {
    head++;
  }
  var tail = 0;
  while (tail < most - head && was.codeUnitAt(was.length - 1 - tail) == now.codeUnitAt(now.length - 1 - tail)) {
    tail++;
  }
  // The edit replaced was[head, wasEnd) with now[head, nowEnd).
  final wasEnd = was.length - tail;
  final nowEnd = now.length - tail;
  final end = at + length;
  if (wasEnd <= at) {
    // Wholly before the piece: it moved by the edit's change in length.
    final moved = at + now.length - was.length;
    return now.substring(0, moved) + now.substring(moved + length);
  }
  if (head >= end) {
    // After the piece, or no edit: the piece is where it was put.
    return now.substring(0, at) + now.substring(end);
  }
  // The edit cut into the piece: what is left of it before and after the
  // edit goes, the edit's own characters stay.
  final before = at < head ? at : head;
  final after = end > wasEnd ? end - wasEnd : 0;
  return now.substring(0, before) + now.substring(head, nowEnd) + now.substring(nowEnd + after);
}

/// The field's new text, from [base] (the text without the last piece, see
/// [withoutPiece]): the final words, then the provisional ones, which are
/// the new piece; and where that piece starts. [first] is true until a
/// final piece has been heard in this recording session.
({String text, String shown, int at}) withHeard(String base, String finalText, String provisional, {bool first = false}) {
  final withFinal = _join(base, finalText, spaced: first);
  final all = _join(withFinal, provisional, spaced: first && finalText.isEmpty);
  return (text: all, shown: all.substring(withFinal.length), at: withFinal.length);
}
