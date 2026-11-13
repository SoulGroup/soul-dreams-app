// Words heard, joined to the field's text (D71 Q6): always at the end,
// never at the caret. The provisional words are shown after the final
// ones and replaced by the next reply; [shown] is the provisional piece
// put there last time, taken off again first if it is still at the end.
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

// The text without the provisional piece shown last time: taken off the
// end if it is still there; if the dreamer typed after it (D75), the stale
// piece is dropped from where it stands and the typed words stay; if it
// was edited away, it is left alone.
String _withoutShown(String text, String shown) {
  if (shown.isEmpty) return text;
  if (text.endsWith(shown)) return text.substring(0, text.length - shown.length);
  final at = text.lastIndexOf(shown);
  if (at < 0) return text;
  return text.substring(0, at) + text.substring(at + shown.length);
}

/// The field's new text, and the provisional piece now at its end. [first]
/// is true until a final piece has been heard in this recording session.
({String text, String shown}) withHeard(
  String text,
  String shown,
  String finalText,
  String provisional, {
  bool first = false,
}) {
  final base = _withoutShown(text, shown);
  final withFinal = _join(base, finalText, spaced: first);
  final all = _join(withFinal, provisional, spaced: first && finalText.isEmpty);
  return (text: all, shown: all.substring(withFinal.length));
}
