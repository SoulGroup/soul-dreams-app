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
// (EM·1) right, which does nothing yet (P3, as D71 Q3). A recording that
// waits to be turned into text shows nothing in its place and cannot be
// tapped; while it is being turned into text, AI·6 shows in its place,
// heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
// When its words come, the page shows them. On a read night, under the
// header, four jump buttons (MP·77: Dreams, Questions, Readings,
// Reflection; D119 item 4); Dreams brings "Dreams" into view, the
// other three do nothing until their sections come with the readings. No
// night is read yet. Not built: reading, and the space below the dreams
// with its field. Opened from a search, the night's first match shows in
// Bold in its dream, found again on each read; gone when the page goes
// (main-path.md, Search; D117 Q6).
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../core/status_bar.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../../recording/recording.dart';
import '../journal.dart';
import '../night.dart';
import '../night_action.dart';
import '../night_look.dart';
import '../night_rules.dart';
import '../row_text.dart';
import '../search.dart';
import 'night_art.dart';
import 'parts.dart';
import 'typing_page.dart';

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
    this.query,
  });

  static const menuKey = Key('night-menu');
  static const deleteKey = Key('night-delete');
  static const actionKey = Key('night-action');
  static const addKey = Key('night-add');
  static const startKey = Key('night-start');
  static const transcribingKey = Key('night-transcribing');
  static const dreamsKey = Key('night-dreams');

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

  /// The search this night was opened from, as searched, or null.
  final String? query;

  @override
  State<NightPage> createState() => _NightPageState();
}

class _NightPageState extends State<NightPage> {
  Night? _night;

  // A delete is in flight: the menu, Add dreams and the dreams wait (D64).
  bool _busy = false;

  // The "Dreams" label, which its jump button brings into view.
  final _dreamsLabel = GlobalKey();

  @override
  void initState() {
    super.initState();
    _load();
    widget.recording?.retries?.addListener(_retried);
  }

  @override
  void dispose() {
    widget.recording?.retries?.removeListener(_retried);
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
    setState(() => _night = n);
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
          jump(Jump.readings, [tradition.colour!, tradition.colourEnd!], null),
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
    final look = n == null ? null : lookOf(n, read: read, paintings: NightArt.paintings, images: widget.images);
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
                      child: Padding(
                        padding: EdgeInsets.only(top: top),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            controls,
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                left: Spacing.pageSide,
                                right: Spacing.pageSide,
                                bottom: Spacing.nightHeader.bottom,
                              ),
                              child: Semantics(
                                header: true,
                                // As wide as its words, so the shade stands
                                // behind the date and not across the header.
                                child: Center(
                                  child: DateShade.over(
                                    look,
                                    Text(
                                      shownDate(n.date),
                                      textAlign: TextAlign.center,
                                      style: TypeRoles.h2.style(NightArt.over),
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
                            child: AppLine(Lines.AI_6.text(appLanguage), style: TypeRoles.voiceApp.style(p.text)),
                          ),
                        ),
                        const SizedBox(height: StandIns.bubbleGap),
                      ],
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
                    right: KeyedSubtree(
                      key: NightPage.startKey,
                      // Nothing to start yet: the readings come later (P3, as D71 Q3).
                      child: PlainButton(Lines.EM_1.text(appLanguage), onPressed: () {}),
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
}
