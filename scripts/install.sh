#!/usr/bin/env bash
# Symlink this repo's AGENTS.md into every git repo under ~/Tech/repos.
# Adds AGENTS.md to each repo's local .git/info/exclude (not committed).
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_SRC="$DOTFILES/AGENTS.md"
REPOS_ROOT="${HOME}/Tech/repos"

if [[ ! -f "$AGENTS_SRC" ]]; then
  echo "Missing AGENTS.md at $AGENTS_SRC" >&2
  exit 1
fi
if [[ ! -d "$REPOS_ROOT" ]]; then
  echo "Repos root not found: $REPOS_ROOT" >&2
  exit 1
fi

linked=0
skipped=0
failed=0

for repo in "$REPOS_ROOT"/*; do
  [[ -d "$repo" ]] || continue
  [[ -e "$repo/.git" ]] || { skipped=$((skipped + 1)); continue; }

  dest="$repo/AGENTS.md"
  # Source repo already has the real AGENTS.md
  if [[ "$repo" == "$DOTFILES" ]]; then
    :
  elif [[ -L "$dest" || ! -e "$dest" ]]; then
    rm -f "$dest"
    ln -s "$AGENTS_SRC" "$dest"
  else
    # Replace unmanaged file with symlink (personal global install)
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
echo "Linked/refreshed: $linked  Skipped: $skipped  Failed: $failed"
