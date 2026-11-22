// The settings and the consents while the journal is open (D110; D121;
// D122; D128), in plain Dart: what the Settings page shows and changes, and
// what the journal's home follows. A change shows at once and is then kept in
// the journal's folder; one that cannot be kept logs a code and holds until
// the app closes, and the next opening shows what was kept before.
//
// - Agreement (D128): "I agree", in onboarding or on the Disclosure & privacy
//   page from Settings, gives the readings (a) and Life Context (b) together;
//   there is no withdrawing. [agreed] is (a): until then nothing leaves the
//   phone, so no recording by voice and no retries, every night kept, and a
//   feature tapped shows the popup instead (MP·101).
// - Life Context (b): its setting, On or Off, is the consent (C159-I item 5;
//   MP·83): Off deletes what is kept, On shows its page. Nothing is kept yet
//   (D121 item 2).
// - Night images (MP·85) is a setting, Off, Personal or Random, with no
//   consent behind it (D125 item 8).
import 'package:flutter/foundation.dart';

import '../core/safe_log.dart';
import '../journal/journal.dart';
import 'consents.dart';
import 'settings.dart';

final class SettingsController extends ChangeNotifier {
  SettingsController(this._journal, {required this._consents, this._settings = const Settings()});

  final Journal _journal;
  Consents _consents;
  Settings _settings;

  Consents get consents => _consents;
  Settings get settings => _settings;

  /// Whether the dreamer has agreed: the readings consent (a) is given. Only
  /// then may anything leave the phone.
  bool get agreed => _consents.given(Consent.readings);

  /// Changes the settings, then keeps them.
  Future<void> change(Settings next) async {
    if (next == _settings) return;
    _settings = next;
    notifyListeners();
    try {
      await _journal.keepSettings(next);
    } on Object {
      SafeLog.event(LogEvent.settingsKeepFailed);
    }
  }

  /// Gives or turns off [consent] (Life Context's On and Off), then keeps the
  /// consents with the day.
  Future<void> answer(Consent consent, bool given) async {
    if (_consents.given(consent) == given) return;
    _consents = _consents.withAnswer(consent, given, _journal.now());
    notifyListeners();
    await _keep();
  }

  /// "I agree": the readings and Life Context given together (D128 item 3),
  /// shown at once, then kept. Nothing when already agreed.
  Future<void> agree() async {
    if (agreed) return;
    final now = _journal.now();
    _consents = _consents.withAnswer(Consent.readings, true, now).withAnswer(Consent.lifeContext, true, now);
    notifyListeners();
    await _keep();
  }

  Future<void> _keep() async {
    try {
      await _journal.keepConsents(_consents);
    } on Object {
      SafeLog.event(LogEvent.consentKeepFailed);
    }
  }
}
