// Words heard, joined to the field's text (D71 Q6): always at the end,
// never at the caret. The provisional words are shown after the final
// ones and replaced by the next reply; [shown] is the provisional piece
// put there last time and [at] where it starts. Next time it is taken out
// of [at] if it is still exactly there (D76), else off the end if it is
// still there; else it is left alone. [movedTo] carries [at] along when the
// dreamer edits before the piece (D77).
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

// The text without the provisional piece shown last time. [at] is where
// that piece was put (D76): if it is still exactly there, it is taken out
// of there and the typed words around it stay (D75). Otherwise it is taken
// off the end if it is still at the end; if it can be found in neither
// place, it is left alone. The dreamer's own copies of it are never taken.
String _withoutShown(String text, String shown, int at) {
  if (shown.isEmpty) return text;
  if (at >= 0 && at <= text.length && text.startsWith(shown, at)) {
    return text.substring(0, at) + text.substring(at + shown.length);
  }
  if (text.endsWith(shown)) return text.substring(0, text.length - shown.length);
  return text;
}

/// Where the piece that started at [at] in [was] starts in [now], when one
/// edit was made between the two: moved by the edit's change in length if
/// the edit lies wholly before the piece, else where it was. Any other
/// change leaves it to [withHeard]'s checks.
int movedTo(String was, String now, int at) {
  final most = was.length < now.length ? was.length : now.length;
  var head = 0;
  while (head < most && was.codeUnitAt(head) == now.codeUnitAt(head)) {
    head++;
  }
  var tail = 0;
  while (tail < most - head && was.codeUnitAt(was.length - 1 - tail) == now.codeUnitAt(now.length - 1 - tail)) {
    tail++;
  }
  return was.length - tail <= at ? at + now.length - was.length : at;
}

/// The field's new text, the provisional piece now at its end, and where
/// that piece starts. [first] is true until a final piece has been heard in
/// this recording session; [at] is where [shown] starts now (the start the
/// last call returned, through [movedTo]).
({String text, String shown, int at}) withHeard(
  String text,
  String shown,
  String finalText,
  String provisional, {
  bool first = false,
  required int at,
}) {
  final base = _withoutShown(text, shown, at);
  final withFinal = _join(base, finalText, spaced: first);
  final all = _join(withFinal, provisional, spaced: first && finalText.isEmpty);
  return (text: all, shown: all.substring(withFinal.length), at: withFinal.length);
}
