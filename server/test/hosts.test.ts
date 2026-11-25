// Every host the server talks to lives in src/hosts.ts (R10, G9).
import assert from 'node:assert/strict';
import { test } from 'node:test';
import * as hosts from '../src/hosts.ts';

test("Soniox's and Black Forest Labs' EU hosts only", () => {
  assert.deepEqual(Object.keys(hosts).sort(), [
    'AI_SOURCE_TYPE',
    'BFL_API_URL',
    'BFL_HOST_SUFFIX',
    'HOSTS',
    'SONIOX_TEMPORARY_KEY_URL',
    'XMP_HEADER',
    'XMP_IPTC_EXT',
    'XMP_RDF',
  ]);
  assert.deepEqual(hosts.HOSTS, ['api.eu.soniox.com', 'api.eu.bfl.ai']);
  assert.ok(Object.isFrozen(hosts.HOSTS));
});

test('the temporary-key address is on that host, over https', () => {
  const url = new URL(hosts.SONIOX_TEMPORARY_KEY_URL);
  assert.equal(url.protocol, 'https:');
  assert.ok(hosts.HOSTS.includes(url.host));
  assert.equal(url.pathname, '/v1/auth/temporary-api-key');
});

test("BFL's address is the EU endpoint's, a host of the server", () => {
  const url = new URL(hosts.BFL_API_URL);
  assert.equal(url.protocol, 'https:');
  assert.equal(url.host, 'api.eu.bfl.ai');
  assert.equal(url.pathname, '/v1');
  assert.ok(url.host.endsWith(hosts.BFL_HOST_SUFFIX));
  assert.ok(hosts.HOSTS.includes(url.host));
});

test("the AI tag's names: IPTC's and Adobe's, no server host", () => {
  assert.equal(hosts.AI_SOURCE_TYPE, 'http://cv.iptc.org/newscodes/digitalsourcetype/trainedAlgorithmicMedia');
  assert.equal(hosts.XMP_IPTC_EXT, 'http://iptc.org/std/Iptc4xmpExt/2008-02-29/');
  assert.equal(hosts.XMP_RDF, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
  assert.equal(hosts.XMP_HEADER, 'http://ns.adobe.com/xap/1.0/');
  for (const name of [hosts.AI_SOURCE_TYPE, hosts.XMP_IPTC_EXT, hosts.XMP_RDF, hosts.XMP_HEADER]) {
    assert.equal(hosts.HOSTS.includes(new URL(name).host), false);
  }
});
