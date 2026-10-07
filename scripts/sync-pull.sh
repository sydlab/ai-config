#!/usr/bin/env bash
# Fast-forward pull for the ai-config repo. Safe to run on a schedule.
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH:-/usr/bin:/bin:/usr/sbin:/sbin}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

if [[ ! -d .git ]]; then
  echo "Not a git repository: $REPO_ROOT" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "SKIP pull: working tree has local changes"
  exit 0
fi

git fetch origin

branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
if [[ -z "$branch" ]]; then
  echo "SKIP pull: detached HEAD"
  exit 0
fi

upstream="origin/$branch"
if ! git rev-parse --verify "$upstream" >/dev/null 2>&1; then
  echo "SKIP pull: no upstream $upstream"
  exit 0
fi

local_head="$(git rev-parse HEAD)"
remote_head="$(git rev-parse "$upstream")"

if [[ "$local_head" == "$remote_head" ]]; then
  echo "Already up to date ($branch)"
  exit 0
fi

merge_base="$(git merge-base HEAD "$upstream")"
if [[ "$merge_base" != "$local_head" ]]; then
  echo "SKIP pull: local commits not pushed; push or rebase first"
  exit 0
fi

git merge --ff-only "$upstream"
"$(dirname "$0")/build-agents.sh"
echo "Pulled and rebuilt standards ($branch)"
