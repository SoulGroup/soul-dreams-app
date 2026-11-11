// Every host the server talks to lives in src/hosts.ts (R10, G9).
import assert from 'node:assert/strict';
import { test } from 'node:test';
import * as hosts from '../src/hosts.ts';

test('no host yet', () => {
  assert.deepEqual(Object.keys(hosts), ['HOSTS']);
  assert.deepEqual(hosts.HOSTS, []);
  assert.ok(Object.isFrozen(hosts.HOSTS));
});
