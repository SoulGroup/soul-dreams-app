// Night/Day mode, Automatic (design-system.md §6; main-path.md, Settings;
// P14; D56): dark from 21:00, light from 08:00, by the phone's local time
// now. A change found while the app is open fades over five seconds; with
// the phone's Reduce Motion on, or animations disabled, it is instant. A
// change found at start or on returning to the app is instant (D57 Q15).
// On iOS, Reduce Motion is its own flag, which MediaQuery does not carry,
// so it is read from the platform's accessibility features. There is no
// Settings page yet, so no Manual mode and no Word Animation (P8).
import 'dart:async';

import 'package:flutter/material.dart';

/// Dark from 21:00 to 08:00, by the wall clock.
bool isNightAt(DateTime local) => local.hour >= 21 || local.hour < 8;

class NightDay extends StatefulWidget {
  const NightDay({super.key, required this.now, required this.builder});

  /// The phone's local time now.
  final DateTime Function() now;

  final Widget Function(BuildContext context, ThemeMode mode, Duration fade) builder;

  /// The fade while the app is open (§6).
  static const fade = Duration(seconds: 5);

  /// How often the clock is looked at.
  static const tick = Duration(minutes: 1);

  @override
  State<NightDay> createState() => _NightDayState();
}

class _NightDayState extends State<NightDay> with WidgetsBindingObserver {
  late bool _night = isNightAt(widget.now());
  Duration _fade = Duration.zero;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(NightDay.tick, (_) => _check());
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check(returning: true);
  }

  bool get _still {
    final f = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures;
    return f.reduceMotion || f.disableAnimations;
  }

  bool get _open {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == null || state == AppLifecycleState.resumed;
  }

  void _check({bool returning = false}) {
    final night = isNightAt(widget.now());
    if (night == _night) return;
    setState(() {
      _night = night;
      _fade = !returning && _open && !_still ? NightDay.fade : Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _night ? ThemeMode.dark : ThemeMode.light, _fade);
}
