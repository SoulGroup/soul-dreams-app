// The journal list, the app's home (main-path.md, The Journal, design 1;
// C131-I items 1, 2; S5): one row per night, newest first, never a time;
// a month divider over each month with nights; the record button bottom
// centre; C4-P·5 when there is no night. Straight from onboarding, the
// first empty journal also shows MP·9 with an arrow to the record button,
// once (main-path.md, Onboarding, 5); the logo above it waits for the
// founder's file. No Settings entry and no search (P8). Nothing on a row
// grades it: no badge, count or status.
import 'package:flutter/material.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../../recording/recording.dart';
import '../journal.dart';
import '../night.dart';
import '../night_action.dart';
import '../night_rules.dart';
import '../row_text.dart';
import 'night_page.dart';
import 'parts.dart';
import 'typing_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key, required this.journal, this.recording, this.firstTime = false, this.nightAction});

  final Journal journal;

  /// Straight from onboarding: while the journal is empty, MP·9 and its
  /// arrow, until a night is there.
  final bool firstTime;

  static const arrowKey = Key('first-arrow');

  /// How to record by voice in the typing screen, or null (D69).
  final Recording? recording;

  /// The item each night's menu gains, or null (D107 item 1).
  final NightAction? nightAction;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
  List<Night>? _nights;
  late bool _first = widget.firstTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    widget.recording?.retries?.addListener(_load);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.recording?.retries?.removeListener(_load);
    super.dispose();
  }

  // On returning, the year may have turned: the dividers are built again.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load();
  }

  // A failed read keeps what is shown and logs a code (D71 Q18, as D64).
  Future<void> _load() async {
    final List<Night> nights;
    try {
      nights = await widget.journal.newestFirst();
    } on Object {
      SafeLog.event(LogEvent.journalListFailed);
      return;
    }
    if (!mounted) return;
    setState(() {
      _nights = nights;
      // Shown once: a night there ends it, even one deleted later.
      if (nights.isNotEmpty) _first = false;
    });
  }

  Future<void> _push(Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
    await _load();
  }

  // A typing screen is opening or open: another tap opens nothing, so one
  // evening's dreams never go to two nights (the final review).
  bool _recording = false;

  // The screen's target is fixed now, when it opens (P10; D58 Q2).
  Future<void> _record() async {
    if (_recording) return;
    _recording = true;
    try {
      final Target target;
      try {
        target = await widget.journal.targetNow();
      } on Object {
        // Nothing opens; a code is logged (D71 Q18).
        SafeLog.event(LogEvent.journalListFailed);
        return;
      }
      if (mounted) await _push(TypingPage(journal: widget.journal, target: target, recording: widget.recording));
    } finally {
      _recording = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final nights = _nights;
    final year = widget.journal.zone.wall(widget.journal.now()).year;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (nights != null && nights.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
                  // In the button type, centred (head's message 20, item 7).
                  child: AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text)),
                ),
              ),
            if (nights != null && nights.isNotEmpty)
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  StandIns.pageSide,
                  0,
                  StandIns.pageSide,
                  StandIns.journalEnd + StandIns.recordHeight + StandIns.recordBelow,
                ),
                children: [
                  for (final item in listItems(nights))
                    switch (item) {
                      MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
                      NightItem(:final night) => _Row(
                        night,
                        onTap: () =>
                            _push(NightPage(
                              journal: widget.journal,
                              id: night.id,
                              recording: widget.recording,
                              action: widget.nightAction,
                            )),
                      ),
                    },
                ],
              ),
            if (nights != null && nights.isEmpty && _first)
              Positioned(
                left: StandIns.pageSide,
                right: StandIns.pageSide,
                bottom: StandIns.recordBelow + StandIns.recordHeight + StandIns.arrowGap,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppLine(Lines.MP_9.text(appLanguage), style: TypeRoles.button.style(p.text)),
                    const SizedBox(height: StandIns.arrowGap),
                    _Arrow(key: JournalPage.arrowKey, colour: p.text),
                  ],
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: StandIns.recordBelow,
              child: Center(child: RecordButton(onPressed: _record)),
            ),
          ],
        ),
      ),
    );
  }
}

/// The first empty journal's arrow, down to the record button: a thin line
/// with a thin head, drawn as the chevrons are. Heard as nothing.
class _Arrow extends StatelessWidget {
  const _Arrow({super.key, required this.colour});

  final Color colour;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.fromSize(
      size: StandIns.firstArrow,
      child: CustomPaint(painter: _ArrowLine(colour)),
    ),
  );
}

class _ArrowLine extends CustomPainter {
  _ArrowLine(this.colour);

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = StandIns.chevronStroke / 2;
    final mid = size.width / 2;
    final tip = size.height - inset;
    final path = Path()
      ..moveTo(mid, inset)
      ..lineTo(mid, tip)
      ..moveTo(inset, tip - mid)
      ..lineTo(mid, tip)
      ..lineTo(size.width - inset, tip - mid);
    canvas.drawPath(
      path,
      Paint()
        ..color = colour
        ..style = PaintingStyle.stroke
        ..strokeWidth = StandIns.chevronStroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_ArrowLine old) => old.colour != colour;
}

// Three empty lines: the summary's least height, as laid out.
const _threeLines = '\n\n';

class _Divider extends StatelessWidget {
  const _Divider(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: StandIns.dividerAbove, bottom: StandIns.dividerBelow),
    // Centred (head's message 20, item 5).
    child: Semantics(
      header: true,
      child: Text(text, textAlign: TextAlign.center, style: TypeRoles.h4.style(Palette.of(context).text)),
    ),
  );
}

/// A night's row: an unnamed night's date (h3), or a named night's name
/// (h5) with its date under it in the button style; then the opening,
/// always three lines, in the button type in color.text.summary (C10-P;
/// D58 Q7; head's message 20, item 1); a chevron at its trailing edge
/// (item 4).
class _Row extends StatelessWidget {
  const _Row(this.night, {required this.onTap});

  final Night night;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final summary = TypeRoles.button.style(p.summary);
    final name = night.name;
    // Three lines as laid out, which rounds each line's height.
    final three = TextPainter(
      text: TextSpan(text: _threeLines, style: summary),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final lines = three.height;
    three.dispose();
    return Padding(
      padding: const EdgeInsets.only(bottom: StandIns.rowGap),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: surface(p),
          padding: StandIns.rowPadding,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (name == null)
                      Text(dayDigits(night.date), style: TypeRoles.h3.style(p.text))
                    else ...[
                      Text(name, style: TypeRoles.h5.style(p.text)),
                      Text(dayDigits(night.date), style: TypeRoles.button.style(p.text)),
                    ],
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: lines),
                      child: Text(opening(night), maxLines: 3, overflow: TextOverflow.ellipsis, style: summary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: StandIns.chevronGap),
              Chevron(colour: p.text),
            ],
          ),
        ),
      ),
    );
  }
}
