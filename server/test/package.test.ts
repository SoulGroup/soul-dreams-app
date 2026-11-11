// The server's packages (D41; D42 Q1, Q14): the five named, at exact
// versions, for development only, none running a script when installed,
// on Node 24. The owner installs them (D41); the lockfile records it.
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';

type Json = Record<string, unknown>;

function read(name: string): Json {
  return JSON.parse(readFileSync(new URL(`../${name}`, import.meta.url), 'utf8')) as Json;
}

const PACKAGES = {
  '@types/node': '24.19.2',
  'aws-cdk': '2.1147.0',
  'aws-cdk-lib': '2.275.0',
  constructs: '10.8.1',
  typescript: '6.0.3',
};

test('the five packages, exact, for development only', () => {
  const pkg = read('package.json');
  assert.deepEqual(pkg['devDependencies'], PACKAGES);
  assert.equal(pkg['dependencies'], undefined);
  assert.equal(pkg['private'], true);
  assert.equal(pkg['type'], 'module');
});

test('Node 24, pinned and running', () => {
  assert.deepEqual(read('package.json')['engines'], { node: '>=24 <25' });
  assert.equal(process.versions.node.split('.')[0], '24');
});

test('the lockfile holds them, with no install script', () => {
  const packages = read('package-lock.json')['packages'] as Record<string, Json>;
  assert.deepEqual(packages['']?.['devDependencies'], PACKAGES);
  assert.equal(packages['']?.['dependencies'], undefined);
  for (const [name, version] of Object.entries(PACKAGES)) {
    assert.equal(packages[`node_modules/${name}`]?.['version'], version, name);
  }
  const scripts = Object.keys(packages).filter((k) => packages[k]?.['hasInstallScript'] === true);
  assert.deepEqual(scripts, []);
});
