// Inside a night, not yet read (main-path.md, The Journal, designs 2 and
// 3; P1, P6, P7; D58 Q1, Q4, Q8; head's message 20, items 10 to 12): the
// header centred (the date, or the name and the date); the "⋯" menu top
// right, a bordered pill opening the phone's menu, spoken as MP·39,
// holding "delete this night" (EM·11's second part), plain, and above it
// the item the entry point gives, if any (D107 item 1: the founder's
// export, in SoulDreams Dev; R8); one
// confirmation, the phone's standard dialog, Cancel first and Delete
// destructive (MP·61, MP·60, pending lines); the dreams under "Dreams"
// (MP·38), in bubbles 30 from the screen's left edge and 10 from its
// right (Spacing.bubbleDreamer), each opening the typing screen to edit
// it; at the foot, "Add dreams" (MP·29) left and Start Interpretation
// (EM·1) right, which does nothing yet (P3, as D71 Q3). A recording that
// waits to be turned into text shows nothing in its place and cannot be
// tapped; while it is being turned into text, AI·6 shows in its place,
// heard by a screen reader (D93 Q3; the shimmer is not built, a stand-in).
// When its words come, the page shows them. Not built: naming, reading,
// and the space below the dreams with its field.
import 'package:flutter/cupertino.dart';
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
import 'parts.dart';
import 'typing_page.dart';

class NightPage extends StatefulWidget {
  const NightPage({super.key, required this.journal, required this.id, this.recording, this.action});

  static const menuKey = Key('night-menu');
  static const deleteKey = Key('night-delete');
  static const actionKey = Key('night-action');
  static const addKey = Key('night-add');
  static const startKey = Key('night-start');
  static const transcribingKey = Key('night-transcribing');

  final Journal journal;
  final String id;

  /// How to record by voice in the typing screen, or null (D69).
  final Recording? recording;

  /// The menu's item above delete, or null (D107 item 1).
  final NightAction? action;

  @override
  State<NightPage> createState() => _NightPageState();
}

class _NightPageState extends State<NightPage> {
  Night? _night;

  // A delete is in flight: the menu, Add dreams and the dreams wait (D64).
  bool _busy = false;

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

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final n = _night;
    const side = EdgeInsets.symmetric(horizontal: Spacing.pageSide);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: side,
              child: Row(
                children: [
                  BackControl(onPressed: () => Navigator.of(context).pop()),
                  const Spacer(),
                  _menu(p),
                ],
              ),
            ),
            if (n != null) ...[
              Expanded(
                // The bubbles keep their own margins from the screen's edges
                // (design-system.md §5); everything else keeps the page's.
                child: BelowTapBox(
                  child: ListView(
                    children: [
                      Padding(
                        padding: Spacing.nightHeader.add(side),
                        child: Semantics(
                          header: true,
                          child: n.name == null
                              ? Text(dayDigits(n.date), textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(n.name!, textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text)),
                                    Text(
                                      dayDigits(n.date),
                                      textAlign: TextAlign.center,
                                      style: TypeRoles.button.style(p.text),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      Padding(
                        padding: side,
                        child: Align(alignment: Alignment.centerLeft, child: SectionLabel(Lines.MP_38.text(appLanguage))),
                      ),
                      const SizedBox(height: StandIns.gap),
                      for (final (i, d) in n.entries.indexed)
                        if (d case Told(:final text)) ...[
                          DreamBubble(text, onTap: () => _type((id: n.id, index: i, text: text))),
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
              ),
              Padding(
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
            ],
          ],
        ),
      ),
    );
  }
}
