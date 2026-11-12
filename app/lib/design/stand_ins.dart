// Values design-system.md leaves unset ("[to set in Framer]", §5, §7),
// each a named stand-in matched by eye to the founder's screenshots
// (P13; D58), never added to tokens.g.dart. The founder corrects them in
// Cohort 0. Every one is listed in docs/plans/journal-screens.md.
import 'package:flutter/painting.dart';

import 'tokens.g.dart';

abstract final class StandIns {
  /// The page's side margin.
  static const double pageSide = 18;

  /// The space between two journal rows.
  static const double rowGap = 10;

  /// Inside a journal row.
  static const rowPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 20);

  /// space.journal.end: below the last row, so the list scrolls clear of
  /// the record button.
  static const double journalEnd = 120;

  /// Above a month divider.
  static const double dividerAbove = 24;

  /// Below a month divider.
  static const double dividerBelow = 12;

  /// The record button.
  static const double recordHeight = 120;
  static const double recordWidth = 120;
  static const double recordBelow = 40;

  /// Inside a button, and a section label.
  static const buttonPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
  static const labelPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// Inside a dreamer's bubble, and between two of them.
  static const bubblePadding = EdgeInsets.symmetric(horizontal: 30, vertical: 30);
  static const double bubbleGap = 12;

  /// Inside the typing field, and around the typing screen's parts.
  static const fieldPadding = EdgeInsets.all(20);
  static const double gap = 20;

  /// The least height of the typing field, in lines of the dreamer's text
  /// at the phone's text size, so it stays usable with the keyboard up (D63).
  static const int fieldMinLines = 5;

  /// A row's summary: the dreamer's words (type role unset).
  static const summary = TypeRoles.voiceDreamer;
}
