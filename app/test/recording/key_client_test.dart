// The request for a short-lived key (D69; D71 Q11): one POST, no body,
// the beta key as bearer, nothing that names the phone (R4).
import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/recording/key_client.dart';

import 'fakes.dart';

void main() {
  final beta = 'Ab0' * 16;

  Future<int> failure(Future<String> f) async {
    try {
      await f;
    } on KeyFailure catch (e) {
      return e.status;
    }
    fail('no failure');
  }

  test('one POST, no body, the beta key, no user agent', () async {
    final door = await FakeDoor.start();
    addTearDown(door.stop);
    expect(await fetchKey(door.url, beta), 'temporary-key-in-a-test');
    expect(door.requests, hasLength(1));
    final r = door.requests.single;
    expect(r.method, 'POST');
    expect(r.bodyLength, 0);
    expect(r.headers['authorization'], ['Bearer $beta']);
    expect(r.headers.keys.toSet(), {'authorization', 'host', 'content-length', 'accept-encoding'});
  });

  test("the door's refusal carries its status", () async {
    final door = await FakeDoor.start();
    addTearDown(door.stop);
    for (final status in [401, 404, 500, 502]) {
      door.status = status;
      expect(await failure(fetchKey(door.url, beta)), status);
    }
  });

  test('an unreadable answer is -1; no answer is 0', () async {
    final door = await FakeDoor.start();
    for (final body in ['not json', '{}', '{"key":""}', '{"key":3}', '[]']) {
      door.body = body;
      expect(await failure(fetchKey(door.url, beta)), -1);
    }
    final gone = door.url;
    await door.stop();
    expect(await failure(fetchKey(gone, beta)), 0);
  });
}
