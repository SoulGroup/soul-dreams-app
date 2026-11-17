// Words heard, put in at the insertion point (D87): where the caret was when
// the recording started (the end if the dreamer had not placed it). The
// text before it stays before, the text after it stays after. The dreamer
// cannot edit while a recording runs: an edit attempt stops it first and
// applies to the settled text ([editSettled]).
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

/// The dreamer's one edit, made on [old] (the text then shown) as [edited],
/// applied to [settled], the text once the last words came (D87 2). Both
/// texts keep the same [keepStart] characters before the dictated words and
/// [keepEnd] after them. A position in the kept text stays with it; one in
/// the dictated words is counted from their end, where the caret was. With
/// nothing typed, [caret] (in [old]) is moved likewise.
({String text, int caret}) editSettled(
  String settled,
  String old,
  String edited, {
  int? caret,
  required int keepStart,
  required int keepEnd,
}) {
  final oldEnd = old.length - keepEnd;
  final settledEnd = settled.length - keepEnd;
  int moved(int p) {
    if (p <= keepStart) return p;
    if (p >= oldEnd) return p + settled.length - old.length;
    final fromEnd = settledEnd - (oldEnd - p);
    return fromEnd < keepStart ? keepStart : fromEnd;
  }

  if (old == edited) return (text: settled, caret: moved(caret ?? old.length));
  // The edit, placed by the longest common start and end (never
  // overlapping), replaced old[head, oldTo) with edited[head, editedTo).
  final most = old.length < edited.length ? old.length : edited.length;
  var head = 0;
  while (head < most && old.codeUnitAt(head) == edited.codeUnitAt(head)) {
    head++;
  }
  var tail = 0;
  while (tail < most - head && old.codeUnitAt(old.length - 1 - tail) == edited.codeUnitAt(edited.length - 1 - tail)) {
    tail++;
  }
  final typed = edited.substring(head, edited.length - tail);
  final from = moved(head);
  final to = moved(old.length - tail);
  final until = to < from ? from : to;
  return (text: settled.substring(0, from) + typed + settled.substring(until), caret: from + typed.length);
}
