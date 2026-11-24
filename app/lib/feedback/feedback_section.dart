// The Feedback section of Settings (D110; main-path.md, Settings; C18-P;
// D152), SoulDreams Dev only: MP·49 in h2, heard as a heading; then a white
// card holding C4-P·8 in the app's voice, the field (MP·46 as its hint, the
// dreamer's voice, at most 2,000 characters, no counter) and Submit (MP·47,
// color.button.filled). Submit with an empty or blank box does nothing;
// before the dreamer has agreed it shows the popup (MP·101) and sends
// nothing (D128 item 3); otherwise it sends once, the box closed to typing
// until the answer. Sent: the box empties and MP·106 shows; not sent: the
// text stays and MP·105 shows. Either line goes when the dreamer types. The
// text lives in the box only, never kept on the phone (R11). MP·105 and
// MP·106 are pending lines (D153): their words show in SoulDreams Dev only
// (R1). The box's border is the Settings value pills' (D154). The card,
// field and button sizes are stand-ins (TO TRY).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_line.dart';
import '../core/language.dart';
import '../design/palette.dart';
import '../design/stand_ins.dart';
import '../design/tokens.g.dart';
import '../journal/pages/parts.dart';
import '../settings/agreement_popup.dart';
import '../words/lines.g.dart';
import '../words/pending.g.dart';
import 'feedback.dart';

class FeedbackSection extends StatefulWidget {
  const FeedbackSection({super.key, required this.send, required this.agreed});

  final SendFeedback send;

  /// Whether the dreamer has agreed, asked at each Submit.
  final bool Function() agreed;

  static const fieldKey = Key('feedback-field');
  static const submitKey = Key('feedback-submit');
  static const lineKey = Key('feedback-line');

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  late final _form = FeedbackForm(widget.send)..addListener(_changed);
  final _text = TextEditingController();

  @override
  void dispose() {
    _form.dispose();
    _text.dispose();
    super.dispose();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  Future<void> _submit() async {
    final result = await _form.submit(_text.text, agreed: widget.agreed());
    if (!mounted) return;
    switch (result) {
      case Submitted.popup:
        await showAgreementPopup(context);
      case Submitted.sent:
        _text.clear();
      case Submitted.nothing || Submitted.unsent:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final line = switch (_form.state) {
      FeedbackState.sent => PendingLines.MP_106.text(appLanguage),
      FeedbackState.unsent => PendingLines.MP_105.text(appLanguage),
      FeedbackState.idle || FeedbackState.sending => null,
    };
    final edge = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Spacing.radius),
      borderSide: BorderSide(color: p.surfaceBorder),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(Lines.MP_49.text(appLanguage), textAlign: TextAlign.center, style: TypeRoles.h2.style(p.text)),
        ),
        const SizedBox(height: StandIns.gap),
        DecoratedBox(
          decoration: surface(p),
          child: Padding(
            padding: StandIns.feedbackPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppLine(Lines.C4_P_8.text(appLanguage), style: StandIns.voiceApp(p.text)),
                const SizedBox(height: StandIns.gap),
                TextField(
                  key: FeedbackSection.fieldKey,
                  controller: _text,
                  readOnly: _form.state == FeedbackState.sending,
                  minLines: StandIns.feedbackLines,
                  maxLines: StandIns.feedbackMaxLines,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [LengthLimitingTextInputFormatter(feedbackLimit)],
                  onChanged: (_) => _form.edited(),
                  style: TypeRoles.voiceDreamer.style(p.fieldText),
                  cursorColor: p.fieldText,
                  decoration: InputDecoration(
                    hintText: Lines.MP_46.text(appLanguage),
                    hintMaxLines: StandIns.feedbackLines,
                    hintStyle: TypeRoles.button.style(p.placeholder),
                    filled: true,
                    fillColor: p.field,
                    contentPadding: StandIns.fieldPadding,
                    border: edge,
                    enabledBorder: edge,
                    focusedBorder: edge,
                  ),
                ),
                const SizedBox(height: StandIns.gap),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: StandIns.feedbackSubmitInset),
                  child: _Submit(Lines.MP_47.text(appLanguage), onPressed: _submit),
                ),
                if (line != null) ...[
                  const SizedBox(height: StandIns.gap),
                  Semantics(
                    key: FeedbackSection.lineKey,
                    liveRegion: true,
                    child: Text(line, textAlign: TextAlign.center, style: TypeRoles.button.style(p.text)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Submit: a full pill in color.button.filled (C11-P), its words centred; at
/// large text they shrink to stay on one row.
class _Submit extends StatelessWidget {
  const _Submit(this.label, {required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Semantics(
      button: true,
      child: GestureDetector(
        key: FeedbackSection.submitKey,
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [p.filledTop, p.filledBottom],
            ),
            borderRadius: BorderRadius.circular(Spacing.radius),
          ),
          child: Padding(
            padding: StandIns.buttonPadding,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, textAlign: TextAlign.center, style: TypeRoles.button.style(p.filledText)),
            ),
          ),
        ),
      ),
    );
  }
}
