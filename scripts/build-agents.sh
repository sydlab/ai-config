#!/usr/bin/env bash
# Build AGENTS.md from rules/*.md (source of truth). Do not hand-edit AGENTS.md.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
RULES="$DOTFILES/rules"
OUT="$DOTFILES/AGENTS.md"

ORDER=(
  security.md
  git.md
  code.md
  environment.md
  behavior.md
  decision-authority.md
)

for name in "${ORDER[@]}"; do
  if [[ ! -f "$RULES/$name" ]]; then
    echo "Missing rule file: $RULES/$name" >&2
    exit 1
  fi
done

{
  cat <<'EOF'
<!-- GENERATED from rules/*.md - do not edit by hand. Run: ./scripts/install.sh (or ./scripts/build-agents.sh) -->

# Agent instructions

Personal global standards for Cursor CLI and IDE Agent.
Edit files under `rules/`, then rebuild. Source of truth is `rules/`, not this file.
EOF
  for name in "${ORDER[@]}"; do
    printf '\n'
    cat "$RULES/$name"
    printf '\n'
  done
} > "$OUT"

echo "Built $OUT"
