// Values design-system.md leaves unset ("[to set in Framer]", §5, §7),
// each a named stand-in matched by eye to the founder's screenshots
// (P13; D58), never added to tokens.g.dart. The founder corrects them in
// Cohort 0. Every one is listed in docs/plans/journal-screens.md.
import 'package:flutter/painting.dart';

abstract final class StandIns {
  /// The page's side margin (about 30, TO TRY: head's message 20, item 12).
  static const double pageSide = 30;

  /// The space between two journal rows (about 12, TO TRY: item 12).
  static const double rowGap = 12;

  /// The chevron at a row's trailing edge (item 4): its size, its line, and
  /// the space before it.
  static const rowChevron = Size(10, 18);
  static const double chevronStroke = 2;
  static const double chevronGap = 16;

  /// Inside a journal row.
  static const rowPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 20);

  /// space.journal.end: below the last row, so the list scrolls clear of
  /// the record button.
  static const double journalEnd = 120;

  /// Above a month divider.
  static const double dividerAbove = 24;

  /// Below a month divider.
  static const double dividerBelow = 12;

  /// The back control: a round button about 41 across (head's message 20,
  /// item 9), and its chevron.
  static const double backSize = 41;
  static const backChevron = Size(9, 16);

  /// The night's "⋯" menu: a bordered pill as tall as the back control
  /// (head's message 20, item 10).
  static const double menuWidth = 55;

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
  static const fieldPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);
  static const double gap = 20;

  /// The typing field grows with its words up to this share of the space
  /// between Back and the buttons ("most of the screen", D70 2; D71 Q7).
  static const double fieldCap = 0.7;

  /// While recording: the level line's height, and how many recent
  /// frames it draws (main-path.md, Recording; D71 Q7).
  static const double levelHeight = 24;
  static const int levelFrames = 48;
}
