#!/usr/bin/env bash
# Build AGENTS.md from rules/, symlink into git repos under ~/Tech (skip projects),
# and write ~/.cursor/rules/00-personal-standards.mdc for IDE Agent.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$(cd "$SCRIPT_DIR/.." && pwd)"
AGENTS_SRC="$DOTFILES/AGENTS.md"
TECH_ROOT="${HOME}/Tech"
PROJECTS_ROOT="${TECH_ROOT}/projects"
CURSOR_RULES_DIR="${HOME}/.cursor/rules"
MDC_PATH="${CURSOR_RULES_DIR}/00-personal-standards.mdc"
GIT_WORKFLOW_SRC="${DOTFILES}/rules/git-workflow.md"
GIT_WORKFLOW_MDC="${CURSOR_RULES_DIR}/10-git-workflow.mdc"

"$SCRIPT_DIR/build-agents.sh"

if [[ ! -d "$TECH_ROOT" ]]; then
  echo "Tech root not found: $TECH_ROOT" >&2
  exit 1
fi

mkdir -p "$CURSOR_RULES_DIR"
# Always-on core from AGENTS.md
{
  cat <<'EOF'
---
description: Personal global standards (from cursor-dotfiles)
alwaysApply: true
---

# Agent instructions

EOF
  awk '
    BEGIN { skip=1 }
    /^# Security$/ { skip=0 }
    skip==0 { print }
  ' "$AGENTS_SRC"
} > "$MDC_PATH"
echo "IDE  $MDC_PATH"

# Agent-requested git procedures (not in AGENTS.md)
if [[ ! -f "$GIT_WORKFLOW_SRC" ]]; then
  echo "Missing $GIT_WORKFLOW_SRC" >&2
  exit 1
fi
{
  cat <<'EOF'
---
description: Git commit, PR, and post-merge cleanup procedures - use when committing, opening a PR, merging, or cleaning up branches
alwaysApply: false
---

EOF
  cat "$GIT_WORKFLOW_SRC"
  printf '\n'
} > "$GIT_WORKFLOW_MDC"
echo "IDE  $GIT_WORKFLOW_MDC (agent-requested)"

linked=0
skipped=0
failed=0

# Find git working trees (directory or file .git)
while IFS= read -r -d '' gitentry; do
  repo="$(dirname "$gitentry")"
  # Normalize
  repo="$(cd "$repo" && pwd)"

  case "$repo" in
    "$PROJECTS_ROOT"|"$PROJECTS_ROOT"/*)
      echo "SKIP $repo (projects)"
      skipped=$((skipped + 1))
      continue
      ;;
  esac

  dest="$repo/AGENTS.md"
  if [[ "$repo" == "$DOTFILES" ]]; then
    exclude="$repo/.git/info/exclude"
    mkdir -p "$(dirname "$exclude")"
    if [[ -f "$exclude" ]]; then
      grep -qxF "AGENTS.md" "$exclude" || echo "AGENTS.md" >> "$exclude"
    else
      echo "AGENTS.md" > "$exclude"
    fi
    echo "OK  $repo (source)"
    linked=$((linked + 1))
    continue
  fi

  if rm -f "$dest" && ln -s "$AGENTS_SRC" "$dest"; then
    exclude="$repo/.git/info/exclude"
    mkdir -p "$(dirname "$exclude")"
    if [[ -f "$exclude" ]]; then
      grep -qxF "AGENTS.md" "$exclude" || echo "AGENTS.md" >> "$exclude"
    else
      echo "AGENTS.md" > "$exclude"
    fi
    echo "OK  $repo"
    linked=$((linked + 1))
  else
    echo "FAIL $repo"
    failed=$((failed + 1))
  fi
done < <(find "$TECH_ROOT" \( -type d -o -type f \) -name .git -print0 2>/dev/null)

echo ""
echo "Done: $linked  Skipped: $skipped  Failed: $failed"
echo "Edit rules/*.md only. Re-run install after changes."
if [[ "$failed" -gt 0 ]]; then
  exit 1
fi
