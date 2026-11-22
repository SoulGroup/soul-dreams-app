// Night/Day mode (design-system.md §6; main-path.md, Settings; P14; D56;
// D122): Automatic, dark from 21:00 and light from 08:00 by the phone's
// local time now; or Manual, Day or Night, as the dreamer set it. A change
// found while the app is open fades over five seconds, easing in and out
// (head's message 20, item 13); with Word Animation off, or the phone's
// Reduce Motion on, or animations disabled, it is instant. A change found
// at start or on returning to the app is instant (D57 Q15). On iOS, Reduce
// Motion is its own flag, which MediaQuery does not carry, so it is read
// from the platform's accessibility features. The mode lives above the app
// (`NightDayChoice`), so a page under it can set it.
import 'dart:async';

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';

import 'app_line.dart' show wordAnimation;

/// Night/Day mode (MP·44): Automatic, or Manual, Day or Night
/// (main-path.md, Settings).
enum NightDayMode { automatic, day, night }

/// Dark from 21:00 to 08:00, by the wall clock.
bool isNightAt(DateTime local) => local.hour >= 21 || local.hour < 8;

/// Whether [mode] at the wall clock's [local] is dark.
bool isNight(NightDayMode mode, DateTime local) => switch (mode) {
  NightDayMode.automatic => isNightAt(local),
  NightDayMode.day => false,
  NightDayMode.night => true,
};

/// The mode, held above the app so a page under it can set it (D122).
class NightDayChoice extends InheritedWidget {
  const NightDayChoice({super.key, required this.mode, required super.child});

  final ValueNotifier<NightDayMode> mode;

  /// Sets the mode from a page under it.
  static void set(BuildContext context, NightDayMode mode) =>
      context.getInheritedWidgetOfExactType<NightDayChoice>()?.mode.value = mode;

  @override
  bool updateShouldNotify(NightDayChoice old) => old.mode != mode;
}

class NightDay extends StatefulWidget {
  const NightDay({super.key, required this.now, required this.builder, this.mode});

  /// The phone's local time now.
  final DateTime Function() now;

  /// The mode; Automatic when null.
  final ValueListenable<NightDayMode>? mode;

  final Widget Function(BuildContext context, ThemeMode mode, Duration fade) builder;

  /// The fade while the app is open (§6).
  static const fade = Duration(seconds: 5);

  /// How often the clock is looked at.
  static const tick = Duration(minutes: 1);

  @override
  State<NightDay> createState() => _NightDayState();
}

class _NightDayState extends State<NightDay> with WidgetsBindingObserver {
  late bool _night = _nightNow();

  bool _nightNow() => isNight(widget.mode?.value ?? NightDayMode.automatic, widget.now());
  Duration _fade = Duration.zero;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.mode?.addListener(_check);
    _timer = Timer.periodic(NightDay.tick, (_) => _check());
  }

  @override
  void dispose() {
    widget.mode?.removeListener(_check);
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
    return !wordAnimation || f.reduceMotion || f.disableAnimations;
  }

  bool get _open {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == null || state == AppLifecycleState.resumed;
  }

  void _check({bool returning = false}) {
    final night = _nightNow();
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
