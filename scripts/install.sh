#!/usr/bin/env bash
# Build AGENTS.md from rules/, then symlink into every git repo under ~/Tech/repos.
# Adds AGENTS.md to each repo's local .git/info/exclude (not committed).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES="$(cd "$SCRIPT_DIR/.." && pwd)"
AGENTS_SRC="$DOTFILES/AGENTS.md"
REPOS_ROOT="${HOME}/Tech/repos"

"$SCRIPT_DIR/build-agents.sh"

if [[ ! -d "$REPOS_ROOT" ]]; then
  echo "Repos root not found: $REPOS_ROOT" >&2
  exit 1
fi

linked=0
skipped=0

for repo in "$REPOS_ROOT"/*; do
  [[ -d "$repo" ]] || continue
  [[ -e "$repo/.git" ]] || { skipped=$((skipped + 1)); continue; }

  dest="$repo/AGENTS.md"
  if [[ "$repo" != "$DOTFILES" ]]; then
    rm -f "$dest"
    ln -s "$AGENTS_SRC" "$dest"
  fi

  exclude="$repo/.git/info/exclude"
  mkdir -p "$(dirname "$exclude")"
  if [[ -f "$exclude" ]]; then
    grep -qxF "AGENTS.md" "$exclude" || echo "AGENTS.md" >> "$exclude"
  else
    echo "AGENTS.md" > "$exclude"
  fi

  echo "OK  $repo"
  linked=$((linked + 1))
done

echo ""
echo "Linked/refreshed: $linked  Skipped: $skipped"
echo "Edit rules/*.md only. Re-run install after changes."
