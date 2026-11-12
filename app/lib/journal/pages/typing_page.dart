// The typing screen (main-path.md, Recording, as P2 to P4, P12 and D58
// shape it): the top line (MP·10 on first use, MP·32 after), the field
// only, never tonight's earlier dreams, with MP·12 as its placeholder;
// Save (MP·13) bottom right; Back (MP·14) top left, which saves just like
// Save; Save carries a sleeping-person icon (Material's "hotel", a
// stand-in until the founder's own). The same screen, filled with a dream, edits it (D58 Q4). The
// keyboard follows the phone's own settings (P12; D57 Q10). Not built:
// the record button and Start Interpretation. D62: Save, Back, the
// system's back and the iPhone's edge swipe all go through one _save;
// when it fails the words and the screen stay, one code is logged, and
// each of them tries again.
import 'package:flutter/material.dart';

import '../../core/app_line.dart';
import '../../core/language.dart';
import '../../core/safe_log.dart';
import '../../design/palette.dart';
import '../../design/stand_ins.dart';
import '../../design/tokens.g.dart';
import '../../words/lines.g.dart';
import '../journal.dart';
import '../night_rules.dart';
import 'parts.dart';

/// A dream to edit: its night, its place, its text.
typedef DreamEdit = ({String id, int index, String text});

class TypingPage extends StatefulWidget {
  const TypingPage({super.key, required this.journal, required this.target, this.edit});

  static const fieldKey = Key('typing-field');
  static const saveKey = Key('typing-save');

  final Journal journal;

  /// Where a new dream is saved, fixed when the screen opened (P10).
  final Target target;

  /// The dream being edited, or null for a new one.
  final DreamEdit? edit;

  @override
  State<TypingPage> createState() => _TypingPageState();
}

class _TypingPageState extends State<TypingPage> {
  late final _text = TextEditingController(text: widget.edit?.text);
  bool? _firstUse;
  bool _saving = false;

  // Flutter's own edge swipe is off while this screen's PopScope refuses
  // a pop, so the screen answers the swipe itself (D62): from the left
  // edge, a drag of this far, or a flick this fast, acts as Back.
  static const _edgeWidth = 20.0;
  static const _swipeFar = 60.0;
  static const _swipeFast = 300.0;
  double _swiped = 0;

  @override
  void initState() {
    super.initState();
    widget.journal.firstUseSeen().then((seen) async {
      if (!seen) await widget.journal.markFirstUseSeen();
      if (mounted) setState(() => _firstUse = !seen);
    });
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    _saving = true;
    try {
      final e = widget.edit;
      if (e == null) {
        await widget.journal.addDream(widget.target, _text.text, appLanguage);
      } else {
        await widget.journal.editDream(e.id, e.index, _text.text);
      }
    } on Object {
      SafeLog.event(LogEvent.journalSaveFailed);
      _saving = false;
      return;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final edge = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Spacing.radius),
      borderSide: BorderSide(color: p.fieldBorder),
    );
    final first = _firstUse;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _save();
      },
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: StandIns.pageSide),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackControl(onPressed: _save),
                    ),
                    if (first != null)
                      AppLine(
                        (first ? Lines.MP_10 : Lines.MP_32).text(appLanguage),
                        style: TypeRoles.voiceApp.style(p.text),
                      ),
                    const SizedBox(height: StandIns.gap),
                    Expanded(
                      child: TextField(
                        key: TypingPage.fieldKey,
                        controller: _text,
                        autofocus: true,
                        expands: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        textAlignVertical: TextAlignVertical.top,
                        style: TypeRoles.voiceDreamer.style(p.fieldText),
                        cursorColor: p.fieldText,
                        decoration: InputDecoration(
                          hintText: Lines.MP_12.text(appLanguage),
                          hintStyle: TypeRoles.button.style(p.placeholder),
                          filled: true,
                          fillColor: p.field,
                          contentPadding: StandIns.fieldPadding,
                          border: edge,
                          enabledBorder: edge,
                          focusedBorder: edge,
                        ),
                      ),
                    ),
                    const SizedBox(height: StandIns.gap),
                    Align(
                      alignment: Alignment.centerRight,
                      child: KeyedSubtree(
                        key: TypingPage.saveKey,
                        child: PlainButton(Lines.MP_13.text(appLanguage), icon: Icons.hotel, onPressed: _save),
                      ),
                    ),
                    const SizedBox(height: StandIns.gap),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: _edgeWidth,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragStart: (_) => _swiped = 0,
              onHorizontalDragUpdate: (d) => _swiped += d.delta.dx,
              onHorizontalDragEnd: (d) {
                if (_swiped >= _swipeFar || (d.primaryVelocity ?? 0) >= _swipeFast) _save();
              },
            ),
          ),
        ],
      ),
    );
  }
}
