// Values design-system.md leaves unset ("[to set in Framer]", §5, §7),
// each a named stand-in matched by eye to the founder's screenshots
// (P13; D58), never added to tokens.g.dart. The founder corrects them in
// Cohort 0. Every one is listed in docs/plans/journal-screens.md, or, for
// those of journal-design, in docs/plans/journal-design.md.
import 'package:flutter/painting.dart';

abstract final class StandIns {
  // The page's side margin and the space between two journal rows, once
  // here, are filed at C17-P: `Spacing.pageSide` and `Spacing.journalRow`.

  /// A chevron (head's message 20, items 4 and 9): its size, and its line.
  static const rowChevron = Size(10, 18);
  static const double chevronStroke = 2;

  /// The journal (D110): above the greeting; between New Dream and the
  /// first row or the empty journal's line; a row's least height.
  static const double greetingAbove = 40;
  static const double listAbove = 40;
  static const double rowHeight = 64;

  /// space.journal.end: below the last row.
  static const double journalEnd = 40;

  /// Above a month divider.
  static const double dividerAbove = 24;

  /// Below a month divider.
  static const double dividerBelow = 12;

  /// The back control: a round button about 41 across (head's message 20,
  /// item 9), and its chevron.
  static const double backSize = 41;
  static const backChevron = Size(9, 16);

  /// The least a tap target measures, invisibly (Apple's 44; D102): the
  /// look stays 41, anchored to the page's margin and the row's top.
  static const double hitMin = 44;

  /// The night's "⋯" menu: a bordered pill as tall as the back control
  /// (head's message 20, item 10).
  static const double menuWidth = 55;

  /// A night's header, below the status bar (D110).
  static const double headerHeight = 240;

  /// A read night's jump buttons (D110): the space between two, how long a
  /// jump scrolls, and the Questions button's gradient (no role is filed
  /// for it; the others take the section label's, the tradition label's and
  /// the dream tag's).
  static const double jumpGap = 8;
  static const jumpTime = Duration(milliseconds: 300);
  static const jumpQuestions = [Color(0xFF8A5A1E), Color(0xFF5E3C12)];

  /// The first empty journal's arrow up to New Dream (main-path.md,
  /// Onboarding, 5): its size, and the space above and below it.
  static const firstArrow = Size(12, 32);
  static const double arrowGap = 8;

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
