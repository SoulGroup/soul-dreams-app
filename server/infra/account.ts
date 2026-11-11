// The deploy refusal (D42 Q9). The account is never in the repository.
// With AWS credentials, the CDK CLI resolves an account; the app then
// refuses unless it equals the one the owner passes with
// `-c account=<id>`. With no credentials nothing can be deployed, and
// the stack is synthesized for no account.
export function pickAccount(passed: unknown, resolved: string | undefined): string | undefined {
  const wanted = typeof passed === 'number' ? String(passed) : passed;
  if (resolved === undefined || resolved === '') {
    if (wanted !== undefined) {
      throw new Error('account-unresolved');
    }
    return undefined;
  }
  if (wanted !== resolved) {
    throw new Error('account-mismatch');
  }
  return resolved;
}
