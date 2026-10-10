#!/usr/bin/env bash
# Copy the global commit-policy hooks to ~/.githooks and point core.hooksPath at them.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HOOKS_SRC="$SCRIPT_DIR/git-hooks/global"
HOOKS_DEST="${HOME}/.githooks"
HOOKS=(prepare-commit-msg commit-msg pre-push post-commit)

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required by the commit-msg, prepare-commit-msg, and pre-push hooks." >&2
  exit 1
fi

mkdir -p "$HOOKS_DEST"
for hook in "${HOOKS[@]}"; do
  if [[ ! -f "$HOOKS_SRC/$hook" ]]; then
    echo "Missing hook: $HOOKS_SRC/$hook" >&2
    exit 1
  fi
  cp "$HOOKS_SRC/$hook" "$HOOKS_DEST/$hook"
  chmod +x "$HOOKS_DEST/$hook"
  echo "Hook  $HOOKS_DEST/$hook"
done

current="$(git config --global core.hooksPath || true)"
if [[ "$current" != "$HOOKS_DEST" ]]; then
  git config --global core.hooksPath "$HOOKS_DEST"
fi
echo "core.hooksPath=$(git config --global core.hooksPath)"
echo ""
echo "Done. Edit scripts/git-hooks/global/, then re-run this script."
