// Every host the app talks to lives here, and nowhere else (CLAUDE.md
// R10, G9): our server's front door and Soniox's EU real-time endpoint.
abstract final class Hosts {
  /// Soniox's EU real-time transcription (technical-answers a; D69).
  static const soniox = 'wss://stt-rt.eu.soniox.com/transcribe-websocket';

  /// Our server's function URL, set after the owner's first deploy on
  /// 2026-11-13 (D71 Q17). An empty address turns recording off.
  static const server = 'https://rflalarrw3i56zqth2ynh6hbby0vquly.lambda-url.eu-north-1.on.aws/';
}
