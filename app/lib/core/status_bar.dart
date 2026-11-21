// The status bar follows the app's own theme everywhere (D114): light text
// (time, battery) over the dark theme, dark text over the light theme,
// whatever the phone's own setting is, since the theme follows the clock and
// not the phone. A night's header keeps light text over its picture in both
// themes (D113). On iOS the style names the bar's own brightness, so light
// text is `dark`.
import 'package:flutter/services.dart';

/// The style that reads over a page of the [theme]'s brightness.
SystemUiOverlayStyle statusBarFor(Brightness theme) =>
    theme == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
