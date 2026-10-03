#!/usr/bin/env bash
# Build the Cursor standards rule from standards/, then symlink it and the
# git-workflow skill into the home directory. Does not copy AGENTS.md into other repos.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$(cd "$SCRIPT_DIR/.." && pwd)"

"$SCRIPT_DIR/build-agents.sh"

BUILT="$DOTFILES/build/00-personal-standards.mdc"
CURSOR_RULES_DIR="${HOME}/.cursor/rules"
MDC_PATH="${CURSOR_RULES_DIR}/00-personal-standards.mdc"
OLD_WORKFLOW="${CURSOR_RULES_DIR}/10-git-workflow.mdc"
SKILL_SRC="$DOTFILES/skills/git-workflow"
SKILL_DEST="${HOME}/.agents/skills/git-workflow"

mkdir -p "$CURSOR_RULES_DIR"
mkdir -p "${HOME}/.agents/skills"

if [[ ! -f "$BUILT" ]]; then
  echo "Missing built rule: $BUILT" >&2
  exit 1
fi
if [[ ! -d "$SKILL_SRC" ]]; then
  echo "Missing skill: $SKILL_SRC" >&2
  exit 1
fi

if [[ -L "$OLD_WORKFLOW" || -f "$OLD_WORKFLOW" ]]; then
  rm -f "$OLD_WORKFLOW"
  echo "Removed $OLD_WORKFLOW"
elif [[ -e "$OLD_WORKFLOW" ]]; then
  echo "Refusing to replace $OLD_WORKFLOW because it is not a file or symlink." >&2
  exit 1
fi

if [[ -L "$MDC_PATH" || -f "$MDC_PATH" ]]; then
  rm -f "$MDC_PATH"
elif [[ -e "$MDC_PATH" ]]; then
  echo "Refusing to replace $MDC_PATH because it is not a file or symlink." >&2
  exit 1
fi
ln -s "$BUILT" "$MDC_PATH"
echo "IDE  $MDC_PATH -> $BUILT"

if [[ -L "$SKILL_DEST" ]]; then
  rm "$SKILL_DEST"
elif [[ -e "$SKILL_DEST" ]]; then
  echo "Refusing to replace $SKILL_DEST because it is not a symlink." >&2
  exit 1
fi
ln -s "$SKILL_SRC" "$SKILL_DEST"
echo "SKILL $SKILL_DEST -> $SKILL_SRC"

echo ""
echo "Done. Edit standards/*.md and skills/, then re-run install."
