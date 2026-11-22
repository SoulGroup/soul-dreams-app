// The journal list, the app's home (main-path.md, The Journal; C131-I
// items 1, 2; S5; D110, head's message 24; D112): a sun or a moon above a
// greeting by the part of the day (MP·72 to MP·75, one line a day; D119);
// New Dream (MP·11), opening the typing screen (the round record button is
// gone); one rounded row per night, newest first, carrying only its date
// over the night's picture (an unread night's the painted gradient), never
// a time; a month divider over each month with nights; C4-P·5 when there is
// no night. The first empty journal shows nothing more: no MP·9 and no arrow
// (D125 item 3); the logo waits for the founder's file. The settings button,
// top left, on the search field's row, opens Settings (main-path.md,
// Settings; D110; D122; D125 items 5 and 10): three sliders drawn in code in
// a 41 bordered circle in a 44 tap box, spoken as MP·25. Nothing on a row
// grades it: no badge, count or status.
// Search (D110; D116; D117): the field at the top, as wide as a row, EM·4
// its placeholder, a magnifier drawn in code and silent, no clear button.
// From three characters, where the list starts: the count of nights (MP·76)
// or W25, then only the matching nights' rows, newest first, under their
// month dividers, each with its context line under it, the match in Inter
// Bold. The query lives only while the page does: never kept, never logged
// (R3), no recent searches.
// The search field sits to the right of the settings button, on its row; the
// sky mark stays 140 down.
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
import '../../settings/settings_controller.dart';
import '../../settings/settings_page.dart';
import '../greeting.dart';
import '../journal.dart';
import '../night.dart';
import '../night_action.dart';
import '../night_look.dart';
import '../night_rules.dart';
import '../row_text.dart';
import '../search.dart';
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
    this.nightAction,
    this.read = noneRead,
    this.settings,
    this.images = true,
    this.agreed = true,
  });

  final Journal journal;

  static const gearKey = Key('gear');
  static const newDreamKey = Key('new-dream');
  static const searchKey = Key('search');
  static const searchFieldKey = Key('search-field');
  static const countKey = Key('search-count');

  /// A result's context line.
  static Key contextKey(String id) => ValueKey('context-$id');

  /// A night's row.
  static Key rowKey(String id) => ValueKey('row-$id');

  /// How to record by voice in the typing screen, or null (D69).
  final Recording? recording;

  /// The item each night's menu gains, or null (D107 item 1).
  final NightAction? nightAction;

  /// Whether a night has been read: none is yet (the readings come later).
  final ReadCheck read;

  /// The settings and the consents, which the gear opens (D122), or null.
  final SettingsController? settings;

  /// False while Night images is Off: every night shows the gradient
  /// (D121 item 3).
  final bool images;

  /// Whether the dreamer has agreed (D128): when not, the typing screen and
  /// a night show the microphone and Start Interpretation, and a tap shows the
  /// popup.
  final bool agreed;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> with WidgetsBindingObserver {
  List<Night>? _nights;
  late Greeting _greeting = _greetingNow();
  late Sky _sky = _skyNow();
  late final Timer _clock;

  // The search as typed, and as searched (null under three characters).
  final _search = TextEditingController();
  String? _query;

  Greeting _greetingNow() => greetingAt(widget.journal.zone.wall(widget.journal.now()));
  Sky _skyNow() => skyAt(widget.journal.zone.wall(widget.journal.now()).hour);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _search.addListener(_searched);
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

  // Consent (a) withdrawn or given again hands a new recording, or none
  // (D121 item 5): the list follows the new one's retries.
  @override
  void didUpdateWidget(JournalPage old) {
    super.didUpdateWidget(old);
    if (old.recording?.retries != widget.recording?.retries) {
      old.recording?.retries?.removeListener(_load);
      widget.recording?.retries?.addListener(_load);
    }
  }

  @override
  void dispose() {
    _clock.cancel();
    _search.dispose();
    WidgetsBinding.instance.removeObserver(this);
    widget.recording?.retries?.removeListener(_load);
    super.dispose();
  }

  void _searched() {
    final q = searchable(_search.text);
    if (q != _query) setState(() => _query = q);
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
      if (mounted) {
        await _push(
          TypingPage(journal: widget.journal, target: target, recording: widget.recording, agreed: widget.agreed),
        );
      }
    } finally {
      _recording = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final nights = _nights;
    final year = widget.journal.zone.wall(widget.journal.now()).year;
    final query = _query;
    final found = nights == null || query == null ? null : search(nights, query);
    final contexts = {
      for (final f in found ?? const <Found>[])
        f.night.id: contextOf((f.night.entries[f.entry] as Told).text, f.span),
    };
    Widget row(Night night) => _Row(
      night,
      look: lookOf(night, read: widget.read(night), paintings: NightArt.paintings, images: widget.images),
      line: contexts[night.id],
      onTap: () => _push(
        NightPage(
          journal: widget.journal,
          id: night.id,
          recording: widget.recording,
          action: widget.nightAction,
          read: widget.read,
          images: widget.images,
          agreed: widget.agreed,
          query: query,
        ),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.searchAbove, Spacing.pageSide, StandIns.journalEnd),
          children: [
            // The settings button, then the search field to its right, on one
            // row (D125 item 5); the field ends where the rows do.
            Row(
              children: [
                if (widget.settings case final settings?) ...[
                  _Gear(onPressed: () => _push(SettingsPage(journal: widget.journal, settings: settings))),
                  const SizedBox(width: StandIns.searchGap),
                ],
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: widget.settings == null ? StandIns.rowSide - Spacing.pageSide : 0,
                      right: StandIns.rowSide - Spacing.pageSide,
                    ),
                    child: _SearchField(_search),
                  ),
                ),
              ],
            ),
            const SizedBox(height: StandIns.greetingAbove - StandIns.searchAbove - Spacing.sizeFieldSearch),
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
            if (found != null) ...[
              const SizedBox(height: StandIns.listAbove),
              // The count of nights, or none (D117 Q2, Q3, Q5), where the
              // list starts, in the button type, centred.
              KeyedSubtree(
                key: JournalPage.countKey,
                child: AppLine(_count(found.length), style: TypeRoles.button.style(p.text)),
              ),
              for (final item in listItems([for (final f in found) f.night]))
                switch (item) {
                  MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
                  NightItem(:final night) => row(night),
                },
            ] else if (nights != null && nights.isEmpty) ...[
              const SizedBox(height: StandIns.listAbove),
              // In the button type, centred (head's message 20, item 7).
              AppLine(Lines.C4_P_5.text(appLanguage), style: TypeRoles.button.style(p.text)),
            ] else if (nights != null) ...[
              const SizedBox(height: StandIns.listAbove - StandIns.dividerAbove),
              for (final item in listItems(nights))
                switch (item) {
                  MonthItem(year: final y, :final month) => _Divider(monthDivider(y, month, year, appLanguage)),
                  NightItem(:final night) => row(night),
                },
            ],
          ],
        ),
      ),
    );
  }
}

/// The settings button (D122, D125 item 10; TO TRY): three sliders drawn in
/// code, in place of the gear, in a round bordered button of 41
/// (color.button), in a tap box of 44, as the back control; spoken as
/// MP·25.
class _Gear extends StatelessWidget {
  const _Gear({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    // Its own node: on the search field's row it is not read with the field.
    return Semantics(
      container: true,
      button: true,
      label: Lines.MP_25.text(appLanguage),
      excludeSemantics: true,
      child: GestureDetector(
        key: JournalPage.gearKey,
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox.square(
          dimension: StandIns.hitMin,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox.square(
              dimension: StandIns.backSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [p.buttonTop, p.buttonBottom],
                  ),
                  border: Border.all(color: p.buttonBorder),
                ),
                child: Center(
                  child: SizedBox.fromSize(size: StandIns.gear, child: CustomPaint(painter: _SlidersLine(p.buttonText))),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlidersLine extends CustomPainter {
  _SlidersLine(this.colour);

  final Color colour;

  /// Where each knob sits along its line, as a share of the width.
  static const knobs = [0.7, 0.3, 0.6];

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = colour
      ..style = PaintingStyle.stroke
      ..strokeWidth = StandIns.chevronStroke * 0.75
      ..strokeCap = StrokeCap.round;
    final knob = Paint()..color = colour;
    final r = size.height * 0.1;
    for (final (i, at) in knobs.indexed) {
      final y = size.height * (0.2 + 0.3 * i);
      canvas.drawLine(Offset(r, y), Offset(size.width - r, y), line);
      canvas.drawCircle(Offset(size.width * at, y), r * 1.5, knob);
    }
  }

  @override
  bool shouldRepaint(_SlidersLine old) => old.colour != colour;
}

/// The search's count: one night, more, or none (D117 Q2, Q3, Q5).
String _count(int nights) => switch (nights) {
  0 => Lines.W25.text(appLanguage),
  1 => Lines.MP_76(n: 1).parts(appLanguage).first,
  _ => Lines.MP_76(n: nights).parts(appLanguage).last,
};

/// The search field (D116; D117 Q7): a pill as wide as a row, 50 tall,
/// `color.field` with its border, a magnifier, and EM·4 as its placeholder
/// in `color.text.placeholder`; the dreamer's words in the button type. It
/// suggests and corrects nothing (main-path.md, Search).
class _SearchField extends StatelessWidget {
  const _SearchField(this.controller);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return ConstrainedBox(
      key: JournalPage.searchFieldKey,
      constraints: const BoxConstraints(minHeight: Spacing.sizeFieldSearch),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: p.field,
          borderRadius: BorderRadius.circular(Spacing.sizeFieldSearch / 2),
          border: Border.all(color: p.fieldBorder),
        ),
        child: Padding(
          padding: StandIns.searchPadding,
          child: Row(
            children: [
              ExcludeSemantics(
                child: SizedBox.fromSize(
                  size: StandIns.magnifier,
                  child: CustomPaint(painter: _Magnifier(p.placeholder)),
                ),
              ),
              const SizedBox(width: StandIns.searchGap),
              Expanded(
                child: TextField(
                  key: JournalPage.searchKey,
                  controller: controller,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.search,
                  style: TypeRoles.button.style(p.fieldText),
                  cursorColor: p.fieldText,
                  decoration: InputDecoration.collapsed(
                    hintText: Lines.EM_4.text(appLanguage),
                    hintStyle: TypeRoles.button.style(p.placeholder),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A magnifier: a ring and a handle to the lower right, drawn as the
/// chevrons are. Heard as nothing.
class _Magnifier extends CustomPainter {
  _Magnifier(this.colour);

  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = StandIns.magnifierStroke / 2;
    final r = size.width * 0.35;
    final centre = Offset(inset + r, inset + r);
    final paint = Paint()
      ..color = colour
      ..style = PaintingStyle.stroke
      ..strokeWidth = StandIns.magnifierStroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(centre, r, paint);
    final from = centre + Offset(r, r) * 0.7071;
    canvas.drawLine(from, Offset(size.width - inset, size.height - inset), paint);
  }

  @override
  bool shouldRepaint(_Magnifier old) => old.colour != colour;
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
/// type.row.date over the night's picture (C18-P); heard as a button named by its date. A name
/// kept from before naming was removed is not shown.
class _Row extends StatelessWidget {
  const _Row(this.night, {required this.look, required this.onTap, this.line});

  final Night night;
  final NightLook look;
  final VoidCallback onTap;

  /// A search result's context line, or null (D116 item 3).
  final Context? line;

  @override
  Widget build(BuildContext context) => Padding(
    // 48 from each side of the screen, the page's own margin included (D115).
    padding: const EdgeInsets.fromLTRB(StandIns.rowSide - Spacing.pageSide, 0, StandIns.rowSide - Spacing.pageSide, Spacing.journalRow),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _pill(context),
        if (line case final c?) ...[
          const SizedBox(height: StandIns.contextGap),
          _ContextLine(night.id, c),
        ],
      ],
    ),
  );

  Widget _pill(BuildContext context) => Semantics(
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
  );
}

/// A search result's context line (D116 item 3; D117 Q8): one line under
/// its row, as wide as the row, centred, in the button type and
/// `color.text.summary`, the matched characters in Inter Bold, cut with
/// an ellipsis where it runs out.
class _ContextLine extends StatelessWidget {
  const _ContextLine(this.id, this.line);

  final String id;
  final Context line;

  @override
  Widget build(BuildContext context) {
    final style = TypeRoles.button.style(Palette.of(context).summary);
    return Text.rich(
      key: JournalPage.contextKey(id),
      TextSpan(
        children: [
          TextSpan(text: line.before),
          TextSpan(text: line.match, style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: line.after),
        ],
      ),
      style: style,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
