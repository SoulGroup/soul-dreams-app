#!/bin/sh
# The owner's import (docs/workflow.md, "Imports"; D32). Usage:
#   SOUL_DREAMS_DOCS=<documents repository> tool/import.sh <path> <sha256> <ordinal>
# Only the owner runs it: Claude Code never reads the documents (R6).
set -eu
: "${SOUL_DREAMS_DOCS:?set it to the documents repository}"
top=$(cd "$(dirname "$0")/.." && pwd)
exec python3 -I -B "$top/tool/checks/importer.py" --docs "$SOUL_DREAMS_DOCS" "$@"
