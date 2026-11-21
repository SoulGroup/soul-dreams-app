// The places Product still owes (D110, head's message 24): no line and no
// handle in the register yet. Each shows a provisional handle in square
// brackets, as a place with no line shows its own (R1), until Product files
// it; then the page takes the register's line and its entry here goes. Each
// is listed in docs/plans/redesign-a.md.

/// A place Product owes, by its provisional handle.
final class Owed {
  const Owed(this.handle);

  final String handle;

  /// The visible placeholder (R1).
  String get text => '[$handle]';
}

abstract final class OwedLines {
  /// The journal's greeting, by the part of the day.
  static const greetingMorning = Owed('owed·greeting-morning');
  static const greetingAfternoon = Owed('owed·greeting-afternoon');
  static const greetingEvening = Owed('owed·greeting-evening');
  static const greetingNight = Owed('owed·greeting-night');

  /// The journal's button that opens the typing screen.
  static const newDream = Owed('owed·new-dream');

  /// A read night's jump buttons.
  static const jumpDreams = Owed('owed·jump-dreams');
  static const jumpQuestions = Owed('owed·jump-questions');
  static const jumpReadings = Owed('owed·jump-readings');
  static const jumpReflection = Owed('owed·jump-reflection');

  static const all = <Owed>[
    greetingMorning,
    greetingAfternoon,
    greetingEvening,
    greetingNight,
    newDream,
    jumpDreams,
    jumpQuestions,
    jumpReadings,
    jumpReflection,
  ];
}
