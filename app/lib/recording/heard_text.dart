// Words heard, put in at the insertion point (D87): where the caret was when
// the recording started (the end if the dreamer had not placed it). The
// text before it stays before, the text after it stays after. The dreamer
// cannot edit while a recording runs: an edit attempt only stops it, and a
// caret the dreamer placed is moved with the words ([caretSettled], D90).
// Soniox's tokens are sub-word pieces with their spaces inside them (D73),
// so their text is joined exactly as sent; the only thing trimmed is a
// space at the very start of an empty field. One space joins the text
// before to the words when neither side has a whitespace at the join
// (D74), and one space joins the words to the text after when that text
// does not start with one (D87).
final _space = RegExp(r'\s');

bool _white(String s, int i) => _space.hasMatch(s[i]);

/// The field's text with [words] (the final words heard so far, then the
/// provisional ones) between [before] and [after]; [end] is where the words
/// end, before any space that joins them to [after].
({String text, int end}) dictatedInto(String before, String words, String after) {
  if (words.isEmpty) return (text: before + after, end: before.length);
  final String middle;
  if (before.isEmpty) {
    middle = words.trimLeft();
  } else if (!_white(before, before.length - 1) && !_white(words, 0)) {
    middle = ' $words';
  } else {
    middle = words;
  }
  final join = after.isNotEmpty && middle.isNotEmpty && !_white(after, 0) && !_white(middle, middle.length - 1)
      ? ' '
      : '';
  return (text: before + middle + join + after, end: before.length + middle.length);
}

/// Where a caret the dreamer placed while recording, at [caret] in the text
/// then shown ([shownLength] long), lands once the last words have come
/// ([settledLength] long) (D90): before the insertion point [insertAt] it
/// stays; at or after it, it moves with the words, never before them.
int caretSettled(int caret, {required int insertAt, required int shownLength, required int settledLength}) {
  if (caret < insertAt) return caret;
  final moved = caret + settledLength - shownLength;
  return moved < insertAt ? insertAt : moved;
}
