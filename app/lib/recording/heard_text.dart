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

/// The field's new text, and the provisional piece now at its end. [first]
/// is true until a final piece has been heard in this recording session.
({String text, String shown}) withHeard(
  String text,
  String shown,
  String finalText,
  String provisional, {
  bool first = false,
}) {
  final base = shown.isNotEmpty && text.endsWith(shown) ? text.substring(0, text.length - shown.length) : text;
  final withFinal = _join(base, finalText, spaced: first);
  final all = _join(withFinal, provisional, spaced: first && finalText.isEmpty);
  return (text: all, shown: all.substring(withFinal.length));
}
