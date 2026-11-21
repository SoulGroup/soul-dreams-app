// Search, in plain Dart (main-path.md, Search; D110, head's message 24;
// D116 items 1 to 3; D117 Q4, Q5, Q8). One matcher, [firstMatch], for
// search now and for recurring images later (head's message 8), so its
// rule can narrow in one place.
// - From three characters (D110), the spaces around the query left out.
// - A capital letter is not a different word (C151-I): each character is
//   folded by itself, Unicode-aware, and a letter with a mark stays its
//   own (D116 item 2). The span maps back to the text's own characters,
//   whatever length a character folds to.
// - The phone's smart punctuation is not a different word (D120): ’ and ‘
//   fold to ', “ and ” to ", and – and — to -, in the query and the text.
// - The typed characters at the start of a word (D117 Q4): so the same
//   word with another ending is found, and a word's middle never is.
// - The dreams' text only, told dreams in order, never a name (D116 item 1);
//   the first place in a night, never the best (C131-I item 3). A night is
//   one match (D117 Q5).
// - The context line (D116 item 3; D117 Q8): up to three words before
//   the match, the match, then the rest, on one line. Stand-ins, TO TRY.
// Nothing here is kept or logged: a query is the dreamer's words (R3).
import 'night.dart';

/// A stretch of a text: [start, end) in its UTF-16 code units.
typedef Span = ({int start, int end});

/// A night's first match: the night, its entry (in [Night.entries]),
/// and the span in that dream.
typedef Found = ({Night night, int entry, Span span});

/// The context line's three parts.
typedef Context = ({String before, String match, String after});

/// A search starts from this many characters (D110).
const int searchFrom = 3;

/// The words kept before a match in its context line (D117 Q8, a stand-in).
const int contextWordsBefore = 3;

/// Marks words left off before a match (D117 Q8: punctuation, not a word).
const String cut = '…';

/// The marks that fold to a straight one (D120), each one code unit: the
/// single curly quotes, the double curly quotes, the en and the em dash.
const _straight = {
  0x2018: "'",
  0x2019: "'",
  0x201C: '"',
  0x201D: '"',
  0x2013: '-',
  0x2014: '-',
};

final _wordChar = RegExp(r'[\p{L}\p{N}\p{M}]', unicode: true);
final _space = RegExp(r'\s+');
final _word = RegExp(r'\S+');

/// The query as searched, or null under three characters.
String? searchable(String typed) {
  final q = typed.trim();
  return q.runes.length >= searchFrom ? q : null;
}

/// A text folded one character at a time, each folded code unit knowing
/// the original character it came from.
final class _Folded {
  _Folded(String text) {
    final out = StringBuffer();
    var at = 0;
    for (final r in text.runes) {
      final width = r > 0xFFFF ? 2 : 1;
      final f = _straight[r] ?? String.fromCharCode(r).toLowerCase();
      for (var k = 0; k < f.length; k++) {
        from.add(at);
        to.add(at + width);
      }
      out.write(f);
      at += width;
    }
    folded = out.toString();
  }

  late final String folded;
  final from = <int>[];
  final to = <int>[];
}

String _fold(String s) => _Folded(s).folded;

bool _wordStart(String text, int i) {
  if (i == 0) return true;
  var j = i - 1;
  final unit = text.codeUnitAt(j);
  if (j > 0 && unit >= 0xDC00 && unit <= 0xDFFF) j--;
  return !_wordChar.hasMatch(text.substring(j, i));
}

/// The first place [query] (already [searchable]) starts a word in [text].
Span? firstMatch(String text, String query) {
  final q = _fold(query);
  if (q.isEmpty) return null;
  final t = _Folded(text);
  var at = t.folded.indexOf(q);
  while (at >= 0) {
    if (_wordStart(text, t.from[at])) {
      return (start: t.from[at], end: t.to[at + q.length - 1]);
    }
    at = t.folded.indexOf(q, at + 1);
  }
  return null;
}

/// A night's first match, its told dreams in order, or null.
Found? findIn(Night night, String query) {
  for (final (i, e) in night.entries.indexed) {
    if (e case Told(:final text)) {
      if (firstMatch(text, query) case final span?) return (night: night, entry: i, span: span);
    }
  }
  return null;
}

/// Every night with a match, in the order given (newest first).
List<Found> search(List<Night> nights, String query) => [
  for (final n in nights) ?findIn(n, query),
];

String _oneLine(String s) => s.replaceAll(_space, ' ');

/// The context line around [span] in [text].
Context contextOf(String text, Span span) {
  final head = text.substring(0, span.start);
  final words = _word.allMatches(head).toList();
  final left = words.length > contextWordsBefore;
  final kept = left ? head.substring(words[words.length - contextWordsBefore].start) : head;
  final before = _oneLine(kept).trimLeft();
  return (
    before: left ? '$cut $before' : before,
    match: _oneLine(text.substring(span.start, span.end)),
    after: _oneLine(text.substring(span.end)).trimRight(),
  );
}
