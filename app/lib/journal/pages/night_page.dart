// Inside a night (main-path.md, The Journal, designs 2 and 3; P1, P6, P7;
// D58 Q1, Q4, Q8; head's message 20, items 10 to 12; D110, head's message
// 24): the header, the screen's width from its top, the night's picture (an
// unread night's the painted gradient, a read night's its painting) with
// its date centred over its foot, with a soft dark shade behind it over a
// painting (D113), and light status-bar text over the header, in both themes
// (D113; the app holds the style of its own theme under the other pages, D114); a name
// kept from before naming was removed is not shown. Over the header, the back control top left and the
// "⋯" menu top right, a bordered pill opening the phone's menu, spoken as
// MP·39,
// holding "delete this night" (EM·11's second part), plain, and above it
// the item the entry point gives, if any (D107 item 1: the founder's
// export, in SoulDreams Dev; R8); one
// confirmation, the phone's standard dialog, Cancel first and Delete
// destructive (MP·61, MP·60, pending lines); the dreams under "Dreams"
// (MP·38, centred, D112), in bubbles 30 from the screen's left edge and 10 from its
// right (Spacing.bubbleDreamer), each opening the typing screen to edit
// it; at the foot, "Add dreams" (MP·29) left and Start Interpretation
// (EM·1) right, which reads the night with the page's reader, SoulDreams
// Dev's only (head's message 33), and does nothing without one (P3, as D71
// Q3); it is gone once the night is read. While the night is read, AI·3
// shows under the dreams; a reading that fails shows the failure sentence
// (C4-P·6) alone there, and the night stays unread (handover §5). A read
// night shows, under its dreams, MP·20, "The Readings" (MP·36) and its
// readings, each in the readings' bubble under its tradition's label (W13,
// its handle until it has a line), with "Made by AI" (MP·71) quietly under
// each. A recording that
// waits to be turned into text shows nothing in its place and cannot be
// tapped; while it is being turned into text, AI·6 shows in its place,
// heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
// When its words come, the page shows them. On a read night, under the
// header, four jump buttons (MP·77: Dreams, Questions, Readings,
// Reflection; D119 item 4); Dreams brings "Dreams" into view and Readings
// "The Readings"; the other two do nothing until their sections come. Not
// built: the mirror, the opening, the close, and the space below the dreams
// with its field. Opened from a search, the night's first match shows in
// Bold in its dream, found again on each read; gone when the page goes
// (main-path.md, Search; D117 Q6). While Night images is Personal, a read
// night with no painting of its own yet asks our server for one, once each
// time its page opens and only with the page's painter (SoulDreams Dev's);
// while it is made, the header shows the set's painting with "New painting
// on the way" (MP·81) over it, heard as it comes; the night's own painting
// replaces it when it arrives; a failure leaves the set's, silently (D162
// items 1 and 2).
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:flutter/services.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../core/status_bar.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../../readings/painting.dart';
import '../../readings/readings.dart';
import '../../recording/recording.dart';
import '../journal.dart';
import '../night.dart';
import '../night_action.dart';
import '../night_look.dart';
import '../night_rules.dart';
import '../row_text.dart';
import '../../settings/agreement_popup.dart';
import '../../settings/settings.dart';
import '../search.dart';
import 'night_art.dart';
import 'parts.dart';
import 'typing_page.dart';

/// A tradition's label: [line]'s part at [lens] (W13), or its handle while
/// it has no line or no part there (R1).
String lensLabel(Line line, int lens, Lang lang) {
  final parts = line.parts(lang);
  return line.written && lens < parts.length ? parts[lens] : '[${line.handle}]';
}

/// A read night's jump buttons, in MP·77's order (C18-P; D119 item 4).
enum Jump {
  dreams,
  questions,
  readings,
  reflection;

  /// Its words: MP·77's part at this button's place.
  String text(Lang lang) => Lines.MP_77.parts(lang)[index];
}

class NightPage extends StatefulWidget {
  const NightPage({
    super.key,
    required this.journal,
    required this.id,
    this.recording,
    this.action,
    this.read = noneRead,
    this.images = true,
    this.agreed = true,
    this.query,
    this.reader,
    this.personal = false,
    this.painter,
  });

  static const menuKey = Key('night-menu');
  static const deleteKey = Key('night-delete');
  static const actionKey = Key('night-action');
  static const addKey = Key('night-add');
  static const startKey = Key('night-start');
  static const transcribingKey = Key('night-transcribing');
  static const dreamsKey = Key('night-dreams');
  static const readingsKey = Key('night-readings');
  static const waitingKey = Key('night-reading-waits');
  static const failedKey = Key('night-reading-failed');
  static const paintingKey = Key('night-painting-made');

  /// The night's reading at [index].
  static Key readingKey(int index) => ValueKey('reading-$index');

  /// A read night's jump button.
  static Key jumpKey(Jump jump) => ValueKey('jump-${jump.name}');

  final Journal journal;
  final String id;

  /// How to record by voice in the typing screen, or null (D69).
  final Recording? recording;

  /// The menu's item above delete, or null (D107 item 1).
  final NightAction? action;

  /// Whether a night has been read: none is yet (the readings come later).
  final ReadCheck read;

  /// False while Night images is Off: the gradient (D121 item 3).
  final bool images;

  /// Whether the dreamer has agreed (D128): when not, Start Interpretation
  /// shows the popup.
  final bool agreed;

  /// The search this night was opened from, as searched, or null.
  final String? query;

  /// How Start Interpretation reads the night: SoulDreams Dev's only (head's
  /// message 33); null, and it does nothing.
  final Reader? reader;

  /// Whether Night images is Personal (D162): the night's own painting is
  /// shown, and asked for while it has none.
  final bool personal;

  /// How a read night's own painting is asked for: SoulDreams Dev's only;
  /// null, and none is.
  final Painter? painter;

  @override
  State<NightPage> createState() => _NightPageState();
}

class _NightPageState extends State<NightPage> {
  Night? _night;

  // A delete is in flight: the menu, Add dreams and the dreams wait (D64).
  bool _busy = false;

  // The "Dreams" label, which its jump button brings into view.
  final _dreamsLabel = GlobalKey();

  // "The Readings" label, which its jump button brings into view.
  final _readingsLabel = GlobalKey();

  // A reading under way, or the last one failed (handover §5).
  bool _reading = false;
  bool _failed = false;

  // The night's own painting, while Personal (D162); whether it is being
  // made; whether it was asked for since the page opened.
  Uint8List? _own;
  bool _making = false;
  bool _asked = false;

  // The part that scrolls: brought to its end, at once, when AI·3 comes, so
  // it shows where the readings, or the failure sentence, will.
  final _scroll = ScrollController();

  void _toEnd() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted && _scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
  });

  @override
  void initState() {
    super.initState();
    _load();
    widget.recording?.retries?.addListener(_retried);
  }

  @override
  void dispose() {
    widget.recording?.retries?.removeListener(_retried);
    _scroll.dispose();
    super.dispose();
  }

  String? get _transcribing => widget.recording?.retries?.transcribing;

  // A retry began, ended, or brought words (D94): shown at once.
  void _retried() {
    if (!mounted) return;
    setState(() {});
    if (!_busy) _load();
  }

  // A night gone (every dream emptied) leaves its page (P10).
  Future<void> _load() async {
    final Night? n;
    try {
      n = await widget.journal.night(widget.id);
    } on Object {
      SafeLog.event(LogEvent.journalReadFailed);
      return;
    }
    if (!mounted) return;
    if (n == null) {
      _leave();
      return;
    }
    Uint8List? own;
    if (widget.personal) {
      try {
        own = await widget.journal.painting(widget.id);
      } on Object {
        SafeLog.event(LogEvent.paintingKeepFailed);
      }
      if (!mounted) return;
    }
    setState(() {
      _night = n;
      _own = own;
    });
    _paint(n);
  }

  // A read night's own painting, asked for once each time the page opens,
  // while Personal and while it has none (D162 items 1 and 2): MP·81 shows
  // while it is made; when it comes, the page shows it.
  void _paint(Night n) {
    final painter = widget.painter;
    if (painter == null || !widget.images || !widget.personal || _asked || !widget.read(n)) return;
    _asked = true;
    final made = painter.paint(widget.journal, n, NightImages.personal, sending: () {
      if (mounted) setState(() => _making = true);
    });
    unawaited(made.then((done) async {
      if (!mounted) return;
      setState(() => _making = false);
      if (done == Painted.made) await _load();
    }));
  }

  // The page leaves by its own route: with a question or a typing screen
  // open above it, popping would close that instead (D96).
  void _leave() {
    final route = ModalRoute.of(context);
    if (route == null || route.isCurrent) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).removeRoute(route);
    }
  }

  Future<void> _type(DreamEdit? edit) async {
    if (_busy) return;
    final page = TypingPage(
      journal: widget.journal,
      target: IntoNight(widget.id),
      edit: edit,
      recording: widget.recording,
      agreed: widget.agreed,
    );
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
    await _load();
  }

  Future<void> _delete() async {
    if (_busy) return;
    final yes = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(Lines.C4_P_4.text(appLanguage)),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(Lines.MP_61.text(appLanguage)),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(Lines.MP_60.text(appLanguage)),
          ),
        ],
      ),
    );
    if (yes != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await widget.journal.delete(widget.id);
    } on Object {
      SafeLog.event(LogEvent.journalDeleteFailed);
      if (mounted) setState(() => _busy = false);
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  // Start Interpretation: the popup before agreeing (D128); else, with a
  // reader, the night read once at a time (head's message 33).
  Future<void> _start() async {
    if (!widget.agreed) {
      showAgreementPopup(context);
      return;
    }
    final reader = widget.reader;
    final night = _night;
    if (reader == null || night == null || _busy || _reading) return;
    setState(() {
      _reading = true;
      _failed = false;
    });
    _toEnd();
    final done = await interpret(widget.journal, reader, night);
    if (!mounted) return;
    setState(() {
      _reading = false;
      _failed = done == Interpreted.failed;
    });
    await _load();
  }

  // The entry point's item, with the night shown; not while a delete runs.
  Future<void> _act() async {
    final night = _night;
    if (_busy || night == null) return;
    await widget.action?.run(night);
  }

  // The "⋯" menu: a bordered pill (color.button) opening the phone's menu;
  // while a delete runs, a tap opens nothing (D64).
  Widget _menu(Palette p) => CupertinoMenuAnchor(
    // A tap outside the open menu only closes it (D102).
    consumeOutsideTaps: true,
    menuChildren: [
      if (widget.action case final action?)
        CupertinoMenuItem(
          key: NightPage.actionKey,
          onPressed: _act,
          child: Text(action.label),
        ),
      CupertinoMenuItem(
        key: NightPage.deleteKey,
        onPressed: _delete,
        child: Text(Lines.EM_11.parts(appLanguage)[1]),
      ),
    ],
    builder: (context, controller, _) => Tooltip(
      message: Lines.MP_39.text(appLanguage),
      child: Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_busy) return;
            // The menu hangs from the look, as before the tap box grew: its
            // right edge on the pill's, the framework's 8 below its foot (D102).
            controller.isOpen
                ? controller.close()
                : controller.open(position: const Offset(StandIns.menuWidth, StandIns.backSize + 8));
          },
          // A tap box of at least 44 around the look, anchored to the top
          // (D102).
          child: SizedBox(
            width: StandIns.menuWidth,
            height: StandIns.hitMin,
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                key: NightPage.menuKey,
                width: StandIns.menuWidth,
                height: StandIns.backSize,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [p.buttonTop, p.buttonBottom],
                    ),
                    borderRadius: BorderRadius.circular(StandIns.backSize / 2),
                    border: Border.all(color: p.buttonBorder),
                  ),
                  child: Icon(Icons.more_horiz, color: p.buttonText),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // Brings a section into view: only "Dreams" is built (D110).
  void _jump(GlobalKey? section) {
    final at = section?.currentContext;
    if (at == null) return;
    Scrollable.ensureVisible(at, duration: StandIns.jumpTime, curve: Curves.easeInOut);
  }

  // A read night's four jump buttons, centred, wrapping at large text.
  Widget _jumps(Palette p) {
    Widget jump(Jump label, List<Color> colours, GlobalKey? section) => Semantics(
      button: true,
      child: GestureDetector(
        key: NightPage.jumpKey(label),
        onTap: () => _jump(section),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colours),
            borderRadius: BorderRadius.circular(Spacing.radius),
          ),
          child: Padding(
            padding: StandIns.labelPadding,
            child: Text(label.text(appLanguage), style: TypeRoles.button.style(p.sectionText)),
          ),
        ),
      ),
    );
    final tradition = LightColours.labelTradition;
    final tag = LightColours.tagDream;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.pageSide),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: StandIns.jumpGap,
        runSpacing: StandIns.jumpGap,
        children: [
          jump(Jump.dreams, [p.sectionTop, p.sectionBottom], _dreamsLabel),
          jump(Jump.questions, StandIns.jumpQuestions, null),
          jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], _readingsLabel),
          jump(Jump.reflection, [tag.colour!, tag.colourEnd!], null),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final n = _night;
    const side = EdgeInsets.symmetric(horizontal: Spacing.pageSide);
    final top = MediaQuery.paddingOf(context).top;
    final read = n != null && widget.read(n);
    final look = n == null
        ? null
        : lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images, personal: _own);
    final query = widget.query;
    final found = n == null || query == null ? null : findIn(n, query);
    // Light time and battery over the header's picture, in both themes (D113);
    // while the page is blank, the app's own theme (D114).
    final overlay = look != null ? SystemUiOverlayStyle.light : statusBarFor(Theme.of(context).brightness);
    final controls = Padding(
      padding: side,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackControl(onPressed: () => Navigator.of(context).pop()),
          const Spacer(),
          _menu(p),
        ],
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The header: the picture from the screen's top, the controls
            // under the status bar, the date at its foot (D110).
            SizedBox(
              height: top + StandIns.headerHeight,
              child: n == null
                  ? Padding(padding: EdgeInsets.only(top: top), child: Align(alignment: Alignment.topCenter, child: controls))
                  : NightArt(
                      look!,
                      overlay: ArtOverlay.header,
                      child: Padding(
                        padding: EdgeInsets.only(top: top),
                        child: Column(
                          // The controls at the top, the date at the foot.
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            controls,
                            // MP·81 while the night's own painting is made
                            // (D162 item 1), scaled down to its room.
                            if (_making)
                              Flexible(
                                child: Padding(
                                  padding: side,
                                  child: Semantics(
                                    key: NightPage.paintingKey,
                                    liveRegion: true,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        Lines.MP_81.text(appLanguage),
                                        textAlign: TextAlign.center,
                                        style: TypeRoles.button.style(NightArt.over),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            // The date takes the room under the controls and
                            // scales down to it, so a very large text size
                            // never overflows the header (D150: it is 55 pt).
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: Spacing.pageSide,
                                  right: Spacing.pageSide,
                                  bottom: Spacing.nightHeader.bottom,
                                ),
                                child: Semantics(
                                  header: true,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      shownDate(n.date),
                                      textAlign: TextAlign.center,
                                      style: StandIns.headerDate.style(NightArt.over),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            if (n != null) ...[
              Expanded(
                // The bubbles keep their own margins from the screen's edges
                // (design-system.md §5); everything else keeps the page's.
                child: ListView(
                  controller: _scroll,
                  // Every part laid out, so a jump reaches a section below
                  // the screen (a night's page is short).
                  scrollCacheExtent: const ScrollCacheExtent.pixels(100000),
                  padding: EdgeInsets.only(top: Spacing.nightHeader.top),
                  children: [
                    // A read night's jump buttons head the part that scrolls.
                    if (read) ...[_jumps(p), const SizedBox(height: StandIns.gap)],
                    Padding(
                      key: NightPage.dreamsKey,
                      padding: side,
                      child: Align(
                        alignment: Alignment.center,
                        child: SectionLabel(key: _dreamsLabel, Lines.MP_38.text(appLanguage)),
                      ),
                    ),
                    const SizedBox(height: StandIns.gap),
                    for (final (i, d) in n.entries.indexed)
                      if (d case Told(:final text)) ...[
                        DreamBubble(
                          text,
                          bold: found?.entry == i ? found!.span : null,
                          onTap: () => _type((id: n.id, index: i, text: text)),
                        ),
                        const SizedBox(height: StandIns.bubbleGap),
                      ] else if (d case Waiting(:final audio) when _transcribing == audio) ...[
                        Padding(
                          padding: side,
                          child: Semantics(
                            key: NightPage.transcribingKey,
                            liveRegion: true,
                            child: AppLine(Lines.AI_6.text(appLanguage), style: StandIns.voiceApp(p.text)),
                          ),
                        ),
                        const SizedBox(height: StandIns.bubbleGap),
                      ],
                    ..._readings(n, p, side),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Spacing.pageSide, StandIns.gap, Spacing.pageSide, StandIns.gap),
                  child: ButtonRow(
                    left: KeyedSubtree(
                      key: NightPage.addKey,
                      child: PlainButton(Lines.MP_29.text(appLanguage), onPressed: () => _type(null)),
                    ),
                    // Gone once the night is read.
                    right: n.readings != null
                        ? const SizedBox.shrink()
                        : KeyedSubtree(
                            key: NightPage.startKey,
                            child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: _start),
                          ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Under the dreams: a read night's readings (MP·20, "The Readings", each
  // reading); while one is read, AI·3; when it failed, C4-P·6 alone.
  List<Widget> _readings(Night n, Palette p, EdgeInsets side) {
    Widget line(Key key, Line said) => Padding(
      padding: side,
      child: Semantics(
        key: key,
        liveRegion: true,
        child: AppLine(said.text(appLanguage), style: StandIns.voiceApp(p.text)),
      ),
    );
    if (n.readings case final readings?) {
      return [
        const SizedBox(height: Spacing.turnApp),
        Padding(padding: side, child: AppLine(Lines.MP_20.text(appLanguage), style: StandIns.voiceApp(p.text))),
        const SizedBox(height: StandIns.gap),
        Padding(
          key: NightPage.readingsKey,
          padding: side,
          child: Align(
            alignment: Alignment.center,
            child: SectionLabel(key: _readingsLabel, Lines.MP_36.text(appLanguage)),
          ),
        ),
        const SizedBox(height: Spacing.labelReadings),
        for (final (i, r) in readings.indexed) ...[
          ReadingBubble(
            key: NightPage.readingKey(i),
            label: lensLabel(Lines.W13, r.lens, appLanguage),
            text: r.text,
            mark: Lines.MP_71.text(appLanguage),
          ),
          const SizedBox(height: StandIns.bubbleGap),
        ],
      ];
    }
    if (_reading) return [const SizedBox(height: Spacing.turnApp), line(NightPage.waitingKey, Lines.AI_3)];
    if (_failed) return [const SizedBox(height: Spacing.turnApp), line(NightPage.failedKey, Lines.C4_P_6)];
    return const [];
  }
}
