// A line in the app's own voice (How the AI Appears §4). Word Animation is
// off everywhere by default (D106 2), so a line stands whole. With it on,
// the line appears word by word, one word about every 60 ms, the founder's
// pace to judge in Cohort 0 (D58 Q17); with the phone's Reduce Motion on, or
// animations disabled, it stands whole all the same. A screen reader always
// gets the line whole (§8). Words not yet shown keep their place, so the
// line never reflows as it appears.
import 'dart:async';

import 'package:flutter/widgets.dart';

/// The pace of the app's own words (D58 Q17).
const wordPace = Duration(milliseconds: 60);

/// Word Animation: off everywhere (D106 2). The setting itself comes with
/// Settings (P8); until then only a test turns it on.
bool wordAnimation = false;

class AppLine extends StatefulWidget {
  const AppLine(this.text, {super.key, required this.style, this.textAlign = TextAlign.center});

  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  State<AppLine> createState() => _AppLineState();
}

final _afterSpace = RegExp(r'(?<= )');

class _AppLineState extends State<AppLine> {
  late List<String> _words;
  int _shown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(AppLine old) {
    super.didUpdateWidget(old);
    if (old.text != widget.text) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    // Each word with the space after it, so the parts join to the line.
    _words = widget.text.split(_afterSpace);
    final f = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    if (!wordAnimation || f.reduceMotion || f.disableAnimations) {
      _shown = _words.length;
      return;
    }
    _shown = 1;
    _timer = Timer.periodic(wordPace, (t) {
      setState(() => _shown++);
      if (_shown >= _words.length) t.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    const hidden = TextStyle(color: Color(0x00000000));
    return Semantics(
      label: widget.text,
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(children: [
          for (final (i, w) in _words.indexed) TextSpan(text: w, style: i < _shown ? null : hidden),
        ]),
        style: widget.style,
        textAlign: widget.textAlign,
      ),
    );
  }
}
