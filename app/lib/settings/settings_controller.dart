// The settings and the consents while the journal is open (D110; D121;
// D122), in plain Dart: what the Settings page shows and changes, and what
// the journal's home follows. A change shows at once and is then kept in
// the journal's folder; one that cannot be kept logs a code and holds until
// the app closes, and the next opening shows what was kept before.
//
// - Consent (a), the readings: withdrawn, nothing leaves the phone, so
//   recording by voice and its retries pause, and every night stays (D121
//   item 5). Given again, they resume. A withdrawal stops sending at once,
//   completes only after the retry in flight has stopped, and shows as
//   withdrawn only once it is kept; if it cannot be kept, sending stays
//   stopped for this session, the readings still show as given, and the
//   dreamer can try again (D124 items 1 and 2).
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

  // Sending stopped for this session by a withdrawal, kept or not.
  bool _withheld = false;
  bool _withdrawing = false;
  bool _notKept = false;
  bool _disposed = false;

  /// Stops what is sending and completes when it has stopped; the journal's
  /// home sets it. A withdrawal waits for it before it is kept (D124 item 1).
  Future<void> Function()? stopSending;

  Consents get consents => _consents;
  Settings get settings => _settings;

  /// Whether anything may leave the phone: consent (a) is given, and no
  /// withdrawal has stopped it this session (D124 item 2).
  bool get sending => _consents.given(Consent.readings) && !_withheld;

  /// Whether a withdrawal of consent (a) could not be kept: sending is stopped,
  /// and the readings still show as given (MP·62).
  bool get withdrawalNotKept => _notKept;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _tell() {
    if (!_disposed) notifyListeners();
  }

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
    if (consent == Consent.readings && !given) return _withdraw();
    if (_consents.given(consent) == given) return;
    _consents = _consents.withAnswer(consent, given, _journal.now());
    notifyListeners();
    try {
      await _journal.keepConsents(_consents);
    } on Object {
      SafeLog.event(LogEvent.consentKeepFailed);
    }
  }

  // Withdrawing (a): sending stops at once; the retry in flight is waited for;
  // then the withdrawal is kept and only then shown. Not kept, sending stays
  // stopped for the session and the consent shows as given, to try again.
  Future<void> _withdraw() async {
    if (_withdrawing || !_consents.given(Consent.readings)) return;
    _withdrawing = true;
    try {
      _withheld = true;
      _notKept = false;
      _tell();
      try {
        await stopSending?.call();
      } on Object {
        // Nothing further to wait for.
      }
      // The journal deleted while this waited: nothing is written into it
      // (D110).
      if (_disposed) return;
      final next = _consents.withAnswer(Consent.readings, false, _journal.now());
      try {
        await _journal.keepConsents(next);
      } on Object {
        SafeLog.event(LogEvent.consentKeepFailed);
        _notKept = true;
        _tell();
        return;
      }
      _consents = next;
      _withheld = false;
      _tell();
    } finally {
      _withdrawing = false;
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
