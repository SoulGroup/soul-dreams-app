import 'package:flutter/material.dart';

import '../design/tokens.g.dart';

/// The cover (D50 2; P11). iOS snapshots the screen for the app switcher
/// after the app leaves the foreground, and Apple advises hiding what is
/// private first (D49 O10). From `inactive` on, the plain page colour of
/// the current theme covers everything: no logo, no words. `resumed`
/// removes it. What is under it stays built, and out of the semantics.
class PrivacyCover extends StatefulWidget {
  const PrivacyCover({super.key, required this.child});

  final Widget child;

  static const coverKey = Key('privacy-cover');
  static const stackKey = Key('privacy-cover-stack');

  @override
  State<PrivacyCover> createState() => _PrivacyCoverState();
}

class _PrivacyCoverState extends State<PrivacyCover> with WidgetsBindingObserver {
  bool _covered = false;

  @override
  void initState() {
    super.initState();
    final state = WidgetsBinding.instance.lifecycleState;
    _covered = state != null && state != AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final covered = state != AppLifecycleState.resumed;
    if (covered != _covered) setState(() => _covered = covered);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final page = (dark ? DarkColours.page : LightColours.page).colour!;
    return Stack(
      key: PrivacyCover.stackKey,
      textDirection: TextDirection.ltr,
      children: [
        ExcludeSemantics(excluding: _covered, child: widget.child),
        if (_covered) Positioned.fill(child: ColoredBox(key: PrivacyCover.coverKey, color: page)),
      ],
    );
  }
}
