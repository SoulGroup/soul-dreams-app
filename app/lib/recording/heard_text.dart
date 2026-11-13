// Words heard, joined to the field's text (D71 Q6): always at the end,
// never at the caret. The provisional words are shown after the final
// ones and replaced by the next reply; [shown] is the provisional piece
// put there last time, taken off again first if it is still at the end.
final _space = RegExp(r'\s');

String _join(String base, String add) {
  if (add.isEmpty) return base;
  if (base.isEmpty || _space.hasMatch(base[base.length - 1])) return base + add.trimLeft();
  if (_space.hasMatch(add[0])) return base + add;
  return '$base $add';
}

/// The field's new text, and the provisional piece now at its end.
({String text, String shown}) withHeard(String text, String shown, String finalText, String provisional) {
  final base = shown.isNotEmpty && text.endsWith(shown) ? text.substring(0, text.length - shown.length) : text;
  final withFinal = _join(base, finalText);
  final all = _join(withFinal, provisional);
  return (text: all, shown: all.substring(withFinal.length));
}
