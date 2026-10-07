#!/usr/bin/env bash
# Remove personal AGENTS.md symlinks left by the old install (pointing at this repo's AGENTS.md,
# or at AGENTS.md in a folder named cursor-dotfiles or ai-config, so links survive a folder rename).
set -euo pipefail

resolve_path() {
  python3 -c "import os, sys; print(os.path.realpath(sys.argv[1]))" "$1"
}

is_legacy_link() {
  local link="$1" target owner
  [[ "$(resolve_path "$link")" == "$AGENTS_IN_DOTFILES" ]] && return 0
  target="$(readlink "$link")"
  owner="$(basename "$(dirname "$target")")"
  [[ "$(basename "$target")" == "AGENTS.md" && ( "$owner" == "cursor-dotfiles" || "$owner" == "ai-config" ) ]]
}

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_IN_DOTFILES="$(resolve_path "$DOTFILES/AGENTS.md")"
TECH_ROOT="${HOME}/Tech"
PROJECTS_ROOT="${TECH_ROOT}/projects"

removed=0
skipped=0

while IFS= read -r -d '' gitentry; do
  repo="$(cd "$(dirname "$gitentry")" && pwd)"
  if [[ "$repo" == "$DOTFILES" ]]; then
    continue
  fi
  case "$repo" in
    "$PROJECTS_ROOT"|"$PROJECTS_ROOT"/*)
      skipped=$((skipped + 1))
      continue
      ;;
  esac

  dest="$repo/AGENTS.md"
  if [[ ! -L "$dest" ]]; then
    continue
  fi

  if ! is_legacy_link "$dest"; then
    echo "SKIP $dest (symlink elsewhere)"
    continue
  fi

  rm -f "$dest"
  echo "OK   $dest"
  removed=$((removed + 1))
done < <(find "$TECH_ROOT" \( -type d -o -type f \) -name .git -print0 2>/dev/null)

echo ""
echo "Removed: $removed  Skipped projects trees: $skipped"
