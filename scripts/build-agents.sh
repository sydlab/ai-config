#!/usr/bin/env bash
# Build build/00-personal-standards.mdc from standards/*.md. Do not hand-edit the built file.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
STANDARDS="$DOTFILES/standards"
OUT_DIR="$DOTFILES/build"
OUT="$OUT_DIR/00-personal-standards.mdc"

ORDER=(
  security.md
  git.md
  code.md
  environment.md
  behavior.md
  decision-authority.md
)

for name in "${ORDER[@]}"; do
  if [[ ! -f "$STANDARDS/$name" ]]; then
    echo "Missing standards file: $STANDARDS/$name" >&2
    exit 1
  fi
done

mkdir -p "$OUT_DIR"

{
  cat <<'EOF'
---
description: Personal global standards (from ai-config)
alwaysApply: true
---

# Agent instructions

EOF
  first=1
  for name in "${ORDER[@]}"; do
    if [[ "$first" -eq 0 ]]; then
      printf '\n'
    fi
    first=0
    cat "$STANDARDS/$name"
    printf '\n'
  done
} > "$OUT"

echo "Built $OUT"
