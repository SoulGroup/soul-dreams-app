// Values design-system.md leaves unset ("[to set in Framer]", §5, §7),
// each a named stand-in matched by eye to the founder's screenshots
// (P13; D58), never added to tokens.g.dart. The founder corrects them in
// Cohort 0. Every one is listed in docs/plans/journal-screens.md, or, for
// those of journal-design, in docs/plans/journal-design.md.
import 'package:flutter/painting.dart';

import 'tokens.g.dart';

abstract final class StandIns {
  // The page's side margin and the space between two journal rows, once
  // here, are filed at C17-P: `Spacing.pageSide` and `Spacing.journalRow`.

  /// `type.voice.app`'s line height, 1.3: the founder's override of the filed
  /// 1.5 (D125 item 1; for Product's next filing). Every use of that role
  /// goes through [voiceApp], never `TypeRoles.voiceApp` itself.
  static const double voiceAppHeight = 1.3;

  static TextStyle voiceApp(Color colour) => TypeRoles.voiceApp.style(colour).copyWith(height: voiceAppHeight);

  /// A chevron (head's message 20, items 4 and 9): its size, and its line.
  static const rowChevron = Size(10, 18);
  static const double chevronStroke = 2;

  /// The journal (D110, D115): above the sky mark and the greeting; between
  /// New Dream and the first row or the empty journal's line; a row's least
  /// height (D150: 64 and 5 more above and below the date) and the padding
  /// round a row's date (`labelPadding` and the same 5 more above and below).
  static const double greetingAbove = 140;
  static const double listAbove = 40;
  static const double rowHeight = 74;
  static const rowDatePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 13);

  /// A night's header date (D150): `type.h2`'s face and spacing in em at 55.
  static final headerDate = TypeRole(
    TypeRoles.h2.family,
    TypeRoles.h2.weight,
    55,
    TypeRoles.h2.height,
    TypeRoles.h2.letterEm,
  );

  /// A journal row (D115, P13): its distance from each side of the screen,
  /// and the thin grey border round it, one grey for each theme, chosen to
  /// read against a dark painting at night and a light one by day.
  static const double rowSide = 48;
  static const double rowBorderWidth = 1;
  static const rowBorderLight = Color(0xFF9E9E9E);
  static const rowBorderDark = Color(0xFF8A8A8A);

  /// The search field (D116; D117 Q7): above it, inside it at the sides,
  /// its magnifier, drawn as a ring and a handle, and the space after it;
  /// and the space between a result's row and its context line (D117 Q8).
  static const double searchAbove = 20;

  /// Settings (D122, D125, D128; TO TRY): the settings button's drawing (three
  /// sliders) inside its 41 circle; a row's padding (its right the same as its
  /// top and bottom, D128 item 6) and its one height; every
  /// value pill's one width and its padding; the pill's small chevron
  /// (pointing down); the quick toggle's sun or moon inside its circle.
  static const gear = Size(22, 22);
  static const settingPadding = EdgeInsets.fromLTRB(20, 10, 10, 10);
  static const double settingRowHeight = 64;
  static const double settingPillWidth = 128;
  static const settingValuePadding = EdgeInsets.symmetric(horizontal: 10, vertical: 10);
  static const settingChevron = Size(7, 12);
  static const toggleMark = Size(26, 26);
  static const searchPadding = EdgeInsets.symmetric(horizontal: 18);
  static const magnifier = Size(16, 16);
  static const double magnifierStroke = 1.5;
  static const double searchGap = 10;
  static const double contextGap = 6;

  /// The sky mark above the greeting (D112): its size, the space below it,
  /// and the colours of the sun and the moon, stand-ins drawn in code until
  /// the founder supplies the images.
  static const skyMark = Size(48, 48);
  static const double skyGap = 12;
  static const sunColour = Color(0xFFD68F1A);
  static const moonColour = Color(0xFFD9D6EA);

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

  /// The drawn tick of the control that ends selecting (D133 item 2), in the
  /// back control's round button (a stand-in, TO TRY).
  static const doneTick = Size(18, 13);

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

  /// Life Context's page (D110; D131; the founder's screen, TO TRY): inside
  /// a kept sentence's box, the space between its words and its date, the
  /// edit and delete icons and their tap boxes, and the dark theme's delete
  /// icon, #D0775A, proposed by C18-P for the founder to approve (#8F3D24
  /// fails on the dark box).
  static const keptPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 14);
  static const double keptDateGap = 4;
  static const double keptIcon = 20;
  static const keptDeleteDark = Color(0xFFD0775A);

  /// Feedback (D152; the founder's screen, docs/reference/screens/feedback.png):
  /// the card's inside, the field's least and most lines, Submit's side
  /// inset, and the gap above the line after a Submit.
  static const feedbackPadding = EdgeInsets.fromLTRB(24, 30, 24, 30);
  static const int feedbackLines = 4;
  static const int feedbackMaxLines = 10;
  static const double feedbackSubmitInset = 24;
}
