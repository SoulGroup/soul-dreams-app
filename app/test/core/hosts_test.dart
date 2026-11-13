// Every host the app talks to lives in lib/core/hosts.dart (R10, G9).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/core/hosts.dart';

final _functionUrl = RegExp(r'^https://[a-z0-9]+\.lambda-url\.eu-north-1\.on\.aws/$');

void main() {
  test("Soniox's EU real-time endpoint", () {
    expect(Hosts.soniox, startsWith('wss://stt-rt.eu.soniox.com/'));
  });

  test('our server: empty until the first deploy, then its function URL', () {
    expect(Hosts.server.isEmpty || _functionUrl.hasMatch(Hosts.server), isTrue);
    expect(_functionUrl.hasMatch('https://abc123.lambda-url.eu-north-1.on.aws/'), isTrue);
    expect(_functionUrl.hasMatch('https://abc123.lambda-url.us-east-1.on.aws/'), isFalse);
    expect(_functionUrl.hasMatch('http://abc123.lambda-url.eu-north-1.on.aws/'), isFalse);
  });
}
