// Every host the app talks to lives here, and nowhere else (CLAUDE.md
// R10, G9): our server's front door and Soniox's EU real-time endpoint.
abstract final class Hosts {
  /// Soniox's EU real-time transcription (technical-answers a; D69).
  static const soniox = 'wss://stt-rt.eu.soniox.com/transcribe-websocket';

  /// Our server's function URL, set after the owner's first deploy (D71
  /// Q17). While it is empty, recording is off.
  static const server = 'https://rflalarrw3i56zqth2ynh6hbby0vquly.lambda-url.eu-north-1.on.aws/';
}
