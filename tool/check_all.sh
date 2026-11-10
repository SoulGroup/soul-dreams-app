#!/bin/sh
# Runs every guard, the guard tests and the mutation checks, then the
# analyzers and tests of app/ and server/ where they exist. Runs every
# step, then exits 1 if any failed.
set -u
top=$(git rev-parse --show-toplevel) || exit 2
cd "$top" || exit 2
failed=''

fail() {
  failed="$failed $1"
  echo "FAILED: $1"
}

echo "python3: $(command -v python3)"
python3 -I -B --version || fail python

hooks=$(git rev-parse --git-path hooks)
if [ "$hooks" != ".githooks" ]; then
  echo "FAILED LOUDLY: core.hooksPath is not .githooks"
  fail hooks-path
fi
for f in .githooks/pre-commit tool/check_all.sh; do
  [ -x "$f" ] || fail "not-executable:$f"
done

python3 -I -B tool/checks/guards.py || fail guards
python3 -I -B tool/checks/tests/run_tests.py || fail guard-tests
python3 -I -B tool/checks/tests/mutations.py || fail mutations

if [ -d app ]; then
  # The pinned Flutter first, then the locked packages (offline: nothing
  # is fetched), the analyzer and the tests (D20 Q15).
  pin=$(sed -n 's/.*"flutter": *"\([^"]*\)".*/\1/p' app/.fvmrc)
  ran=$(cd app && fvm flutter --version --machine 2>/dev/null \
    | sed -n 's/.*"frameworkVersion": *"\([^"]*\)".*/\1/p')
  echo "flutter: pinned ${pin:-none}, running ${ran:-none}"
  if [ -z "$pin" ] || [ "$pin" != "$ran" ]; then
    fail flutter-version
  else
    (cd app && fvm flutter pub get --offline --enforce-lockfile \
      && fvm flutter analyze && fvm flutter test) || fail app
  fi
else
  echo "SKIPPED: app/ is not present yet"
fi
if [ -d server ]; then
  (cd server && npm run check && npm test) || fail server
else
  echo "SKIPPED: server/ is not present yet"
fi

if [ -n "$failed" ]; then
  echo "check_all: FAILED:$failed"
  exit 1
fi
echo "check_all: all passed"
