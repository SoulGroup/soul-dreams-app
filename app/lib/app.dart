import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/always_light.dart';
import 'core/language.dart';
import 'core/night_day.dart';
import 'core/privacy_cover.dart';
import 'core/status_bar.dart';
import 'design/palette.dart';

/// The app, under the cover (D50 2) on every page, in the theme Night/Day
/// mode sets (D56; P14), in the language it shows (D57 Q12). Flutter's
/// own localizations give the month names (P5) and the framework's own
/// words, which are not ours under R1 (D57 Q9). A page may hold it in the
/// light theme, at once: onboarding (`AlwaysLight`).
class SoulDreamsApp extends StatefulWidget {
  const SoulDreamsApp({super.key, this.home, this.clock});

  /// The first page; a blank one when null. Only SoulDreams Dev sets it.
  final Widget? home;

  /// The phone's local time now; tests pass their own.
  final DateTime Function()? clock;

  @override
  State<SoulDreamsApp> createState() => _SoulDreamsAppState();
}

class _SoulDreamsAppState extends State<SoulDreamsApp> {
  final _light = ValueNotifier<bool>(false);
  bool _wasLight = false;
  // Night/Day mode, set from the settings (D122); Automatic until then.
  final _mode = NightDayModeNotifier(NightDayMode.automatic);

  @override
  void dispose() {
    _light.dispose();
    _mode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NightDayChoice(
      mode: _mode,
      child: AlwaysLight(
        light: _light,
        child: NightDay(
          now: widget.clock ?? DateTime.now,
          mode: _mode,
          builder: (context, mode, fade) => ValueListenableBuilder<bool>(
            valueListenable: _light,
            builder: (context, light, _) {
              // Held light, or let go: at once, never a fade.
              final held = light != _wasLight;
              _wasLight = light;
              return _app(light ? ThemeMode.light : mode, held ? Duration.zero : fade);
            },
          ),
        ),
      ),
    );
  }

  Widget _app(ThemeMode mode, Duration fade) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: themeFor(Brightness.light),
    darkTheme: themeFor(Brightness.dark),
    themeMode: mode,
    themeAnimationDuration: fade,
    // A gentle ease-in-out over the five seconds (head's message 20,
    // item 13).
    themeAnimationCurve: Curves.easeInOut,
    locale: Locale(appLanguage.name),
    supportedLocales: const [Locale('en'), Locale('sv')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    // The status bar follows the app's own theme, held under every page (D114):
    // a page that sets its own (a night's header) is overridden only while it
    // is shown, since Flutter leaves the last style in place when a frame has
    // none. The builder stands inside the theme, so a held-light page (and
    // the five-second fade) are followed.
    builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
      value: statusBarFor(Theme.of(context).brightness),
      child: PrivacyCover(child: child!),
    ),
    home: widget.home ?? const Scaffold(),
  );
}
