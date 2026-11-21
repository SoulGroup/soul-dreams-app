// The journal list, the app's home (main-path.md, The Journal; C131-I
// items 1, 2; S5; D110, head's message 24; D112): a sun or a moon above a
// greeting by the part of the day (MP·72 to MP·75, one line a day; D119);
// New Dream (MP·11), opening the typing screen (the round record button is
// gone); one rounded row per night, newest first, carrying only its date
// over the night's picture (an unread night's the painted gradient), never
// a time; a month divider over each month with nights; C4-P·5 when there is
// no night. Straight from onboarding, the first empty journal also shows
// MP·9 under New Dream, with an arrow up to it, once (main-path.md,
// Onboarding, 5); the logo waits for the founder's file. No Settings entry
// and no search (later branches). Nothing on a row grades it: no badge,
// count or status.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../../recording/recording.dart';
import '../greeting.dart';
import '../journal.dart';
import '../night.dart';
import '../night_action.dart';
import '../night_look.dart';
import '../night_rules.dart';
import '../row_text.dart';
import '../sky.dart';
import 'night_art.dart';
import 'night_page.dart';
import 'sky_mark.dart';
import 'typing_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({
    super.key,
    required this.journal,
    this.recording,
    this.firstTime = false,
    this.nightAction,
    this.read = noneRead,
  });

  final Journal journal;

  /// Straight from onboarding: while the journal is empty, MP·9 and its
  /// arrow, until a night is there.
  final bool firstTime;

  static const arrowKey = Key('first-arrow');
  static const newDreamKey = Key('new-dream');

  /// A night's row.
  static Key rowKey(String id) => ValueKey('row-$id');

  /// How to record by voice in the typing screen, or null (D69).
  final Recording? recording;

  /// The item each night's menu gains, or null (D107 item 1).
  final NightAction? nightAction;

  /// Whether a night has been read: none is yet (the readings come later).
  final ReadCheck read;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
  List<Night>? _nights;
  late bool _first = widget.firstTime;
  late Greeting _greeting = _greetingNow();
  late Sky _sky = _skyNow();
  late final Timer _clock;

  Greeting _greetingNow() => greetingAt(widget.journal.zone.wall(widget.journal.now()));
  Sky _skyNow() => skyAt(widget.journal.zone.wall(widget.journal.now()).hour);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    widget.recording?.retries?.addListener(_load);
    // The greeting and the sky mark follow the clock while the page is open.
    _clock = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = _greetingNow();
      final sky = _skyNow();
      if (now != _greeting || sky != _sky) {
        setState(() {
          _greeting = now;
          _sky = sky;
        });
      }
    });
  }

  @override
  void dispose() {
    _clock.cancel();
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
      _greeting = _greetingNow();
      _sky = _skyNow();
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.greetingAbove, Spacing.pageSide, StandIns.journalEnd),
          children: [
            // The sun by day, the moon by night, then the greeting (D112).
            Center(child: SkyMark(_sky)),
            const SizedBox(height: StandIns.skyGap),
            // Centred in h2, heard as a heading (D110).
            Semantics(
              header: true,
              child: Text(
                greetingText(_greeting, appLanguage),
                textAlign: TextAlign.center,
                style: TypeRoles.h2.style(p.text),
              ),
            ),
            const SizedBox(height: StandIns.gap),
            Center(child: _NewDream(onPressed: _record)),
            if (nights != null && nights.isEmpty && _first) ...[
              const SizedBox(height: StandIns.arrowGap),
              Center(child: _Arrow(key: JournalPage.arrowKey, colour: p.text)),
              const SizedBox(height: StandIns.arrowGap),
              AppLine(Lines.MP_9.text(appLanguage), style: TypeRoles.button.style(p.text)),
            ],
            if (nights != null && nights.isEmpty) ...[
              const SizedBox(height: StandIns.listAbove),
              // In the button type, centred (head's message 20, item 7).
              AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text)),
            ],
            if (nights != null && nights.isNotEmpty) ...[
              const SizedBox(height: StandIns.listAbove - StandIns.dividerAbove),
              for (final item in listItems(nights))
                switch (item) {
                  MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
                  NightItem(:final night) => _Row(
                    night,
                    look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings),
                    onTap: () =>
                        _push(NightPage(
                          journal: widget.journal,
                          id: night.id,
                          recording: widget.recording,
                          action: widget.nightAction,
                          read: widget.read,
                        )),
                  ),
                },
            ],
          ],
        ),
      ),
    );
  }
}

/// New Dream (D110, D112): a pill on a night sky, its words in the button
/// type over it, opening the typing screen; heard as a button.
class _NewDream extends StatelessWidget {
  const _NewDream({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: GestureDetector(
      key: JournalPage.newDreamKey,
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Spacing.radius),
        child: NightSky(
          child: Padding(
            padding: StandIns.buttonPadding,
            child: Text(Lines.MP_11.text(appLanguage), style: TypeRoles.button.style(NightArt.over)),
          ),
        ),
      ),
    ),
  );
}

/// The first empty journal's arrow, up to New Dream: a thin line with a
/// thin head, drawn as the chevrons are. Heard as nothing.
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
    const tip = inset;
    final path = Path()
      ..moveTo(mid, size.height - inset)
      ..lineTo(mid, tip)
      ..moveTo(inset, tip + mid)
      ..lineTo(mid, tip)
      ..lineTo(size.width - inset, tip + mid);
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

/// A night's row (D110, D115): a rounded row, 48 from each side of the
/// screen and edged by a thin grey border, carrying only its date, centred in
/// h6 over the night's picture; heard as a button named by its date. A name
/// kept from before naming was removed is not shown.
class _Row extends StatelessWidget {
  const _Row(this.night, {required this.look, required this.onTap});

  final Night night;
  final NightLook look;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    // 48 from each side of the screen, the page's own margin included (D115).
    padding: const EdgeInsets.fromLTRB(StandIns.rowSide - Spacing.pageSide, 0, StandIns.rowSide - Spacing.pageSide, Spacing.journalRow),
    child: Semantics(
      button: true,
      child: GestureDetector(
        key: JournalPage.rowKey(night.id),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Spacing.radius),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: StandIns.rowHeight),
            // A thin grey border over the picture, the gradient's too (D115).
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Spacing.radius),
                border: Border.all(color: Palette.of(context).rowBorder, width: StandIns.rowBorderWidth),
              ),
              child: NightArt(
                look,
                child: Center(
                  child: Padding(
                    padding: StandIns.labelPadding,
                    child: DateShade.over(look, Text(shownDate(night.date), style: TypeRoles.rowDate.style(NightArt.over))),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
