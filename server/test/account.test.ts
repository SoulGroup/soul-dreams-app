// The deploy refusal (D42 Q9), in the function and in the app itself.
// The two accounts are invented.
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { tmpdir } from 'node:os';
import { test } from 'node:test';
import { fileURLToPath } from 'node:url';
import { pickAccount } from '../infra/account.ts';

const A = '111111111111';
const B = '222222222222';

test('no credentials and none passed: no account', () => {
  assert.equal(pickAccount(undefined, undefined), undefined);
  assert.equal(pickAccount(undefined, ''), undefined);
});

test('the account passed is the one resolved', () => {
  assert.equal(pickAccount(A, A), A);
  assert.equal(pickAccount(111111111111, A), A);
});

test('none passed, or another: refused', () => {
  assert.throws(() => pickAccount(undefined, A), { message: 'account-mismatch' });
  assert.throws(() => pickAccount(B, A), { message: 'account-mismatch' });
});

test('one passed with no credentials: refused', () => {
  assert.throws(() => pickAccount(A, undefined), { message: 'account-unresolved' });
});

const APP = fileURLToPath(new URL('../infra/app.ts', import.meta.url));

// Runs the app as the CLI would, with only these variables (and PATH and
// the temporary folder, where the CDK stages its files). Returns the
// refusal's code, 'ok' when it ran, or 'other'.
function app(env: Record<string, string>): string {
  const base = { PATH: process.env['PATH'] ?? '', TMPDIR: tmpdir() };
  const run = spawnSync(process.execPath, [APP], { env: { ...base, ...env }, encoding: 'utf8' });
  if (run.status === 0) {
    return 'ok';
  }
  return /Error: (account-[a-z]+)/.exec(run.stderr)?.[1] ?? 'other';
}

test('the app refuses a resolved account not passed', () => {
  const context = (account: string): string => JSON.stringify({ account });
  assert.equal(app({}), 'ok');
  assert.equal(app({ CDK_DEFAULT_ACCOUNT: A }), 'account-mismatch');
  assert.equal(app({ CDK_DEFAULT_ACCOUNT: A, CDK_CONTEXT_JSON: context(A) }), 'ok');
  assert.equal(app({ CDK_DEFAULT_ACCOUNT: A, CDK_CONTEXT_JSON: context(B) }), 'account-mismatch');
  assert.equal(app({ CDK_CONTEXT_JSON: context(A) }), 'account-unresolved');
});
