// What Life Context keeps from the dreamer's own words (C159-I item 1;
// D110; D131): the sentences of a piece of text, word for word. Plain Dart,
// no screen. Nothing calls it yet: a night holds only dreams, and nothing
// from a dream is ever kept; its sources come with Questions and Reflection.
//
// A sentence ends at a run of `.`, `!`, `?` or `…`, with any closing quotes
// or brackets after it, followed by a space or the text's end; a line break
// ends one too. Each sentence is the text between those ends exactly as
// written, its spaces at either end left off; a piece with no letter or
// digit in it (a lone ellipsis) is no sentence. Nothing else changes: no
// case, spelling or punctuation, and no list of abbreviations, so "Dr."
// ends one (decided under D91; Part 1).

final _end = RegExp(r'''[.!?…]+[”’"')\]»]*(?=\s|$)''');
final _break = RegExp('\r\n|[\n\r\u0085\u2028\u2029]'); // not-dreamer-facing: the line breaks
final _letter = RegExp(r'[\p{L}\p{N}]', unicode: true);

/// The sentences of [text], in order, each word for word.
List<String> sentencesOf(String text) {
  final out = <String>[];
  void add(String piece) {
    final s = piece.trim();
    if (_letter.hasMatch(s)) out.add(s);
  }

  for (final line in text.split(_break)) {
    var start = 0;
    for (final m in _end.allMatches(line)) {
      add(line.substring(start, m.end));
      start = m.end;
    }
    add(line.substring(start));
  }
  return out;
}
