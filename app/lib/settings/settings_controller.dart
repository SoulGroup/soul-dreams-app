// The settings and the consents while the journal is open (D110; D121;
// D122), in plain Dart: what the Settings page shows and changes, and what
// the journal's home follows. A change shows at once and is then kept in
// the journal's folder; one that cannot be kept logs a code and holds until
// the app closes, and the next opening shows what was kept before.
//
// - Consent (a), the readings: withdrawn, nothing leaves the phone, so
//   recording by voice and its retries pause, and every night stays (D121
//   item 5). Given again, they resume.
// - Consent (b), Life Context: its setting, On or Off, is the consent
//   (C159-I item 5; MP·83). Nothing is kept yet (D121 item 2).
// - Consent (c), the night images: Night images is Off while it is not
//   given (MP·85); Personal or Random is the choice kept for while it is.
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

  /// Night images as shown: Off while consent (c) is not given.
  NightImages get nightImages => _consents.given(Consent.images) ? _settings.images : NightImages.off;

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

  /// Gives [consent], or withdraws it, then keeps the consents with the day.
  Future<void> answer(Consent consent, bool given) async {
    if (_consents.given(consent) == given) return;
    _consents = _consents.withAnswer(consent, given, _journal.now());
    notifyListeners();
    try {
      await _journal.keepConsents(_consents);
    } on Object {
      SafeLog.event(LogEvent.consentKeepFailed);
    }
  }

  /// Night images set to [choice]: Off withdraws consent (c); Personal or
  /// Random is kept, and gives (c) when it is not given. The page asks
  /// for (c) first (D122, the stop's question 7).
  Future<void> setImages(NightImages choice) async {
    if (choice == NightImages.off) return answer(Consent.images, false);
    await change(_settings.copyWith(images: choice));
    await answer(Consent.images, true);
  }
}
