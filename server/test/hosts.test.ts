// Every host the server talks to lives in src/hosts.ts (R10, G9).
import assert from 'node:assert/strict';
import { test } from 'node:test';
import * as hosts from '../src/hosts.ts';

test("Soniox's EU REST host only", () => {
  assert.deepEqual(Object.keys(hosts).sort(), ['BFL_API_URL', 'BFL_HOST_SUFFIX', 'HOSTS', 'SONIOX_TEMPORARY_KEY_URL']);
  assert.deepEqual(hosts.HOSTS, ['api.eu.soniox.com']);
  assert.ok(Object.isFrozen(hosts.HOSTS));
});

test('the temporary-key address is on that host, over https', () => {
  const url = new URL(hosts.SONIOX_TEMPORARY_KEY_URL);
  assert.equal(url.protocol, 'https:');
  assert.ok(hosts.HOSTS.includes(url.host));
  assert.equal(url.pathname, '/v1/auth/temporary-api-key');
});

test("the image test's address is the EU endpoint's, not the server's", () => {
  const url = new URL(hosts.BFL_API_URL);
  assert.equal(url.protocol, 'https:');
  assert.equal(url.host, 'api.eu.bfl.ai');
  assert.equal(url.pathname, '/v1');
  assert.ok(url.host.endsWith(hosts.BFL_HOST_SUFFIX));
  assert.equal(hosts.HOSTS.includes(url.host), false);
});
