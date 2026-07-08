---
description: Git commit safety protocol and workflow
alwaysApply: true
---

# Git commit protocol

Only create commits when requested by the user. If unclear, ask first.

## Git safety protocol

- NEVER update the git config
- NEVER run destructive/irreversible git commands (push --force, hard reset, etc.) unless the user explicitly requests them
- NEVER skip hooks (`--no-verify`, `--no-gpg-sign`, etc.) unless the user explicitly requests it
- NEVER force-push to main/master; warn the user if they request it
- Avoid `git commit --amend`. ONLY use `--amend` when ALL conditions are met:
  1. User explicitly requested amend, OR commit succeeded but pre-commit hook auto-modified files
  2. HEAD commit was created by you in this conversation
  3. Commit has NOT been pushed to remote
- If commit FAILED or was REJECTED by hook, NEVER amend — fix and create a NEW commit
- If already pushed to remote, NEVER amend unless the user explicitly requests it

## Commit workflow

1. Run in parallel: `git status`, `git diff`, `git log` (recent messages)
2. Analyze changes; draft a commit message per `git-commit-format.md`
3. Do not commit files likely containing secrets
4. Sequential: add files, commit, verify with `git status`
5. Do NOT push unless explicitly asked

Pass commit messages via HEREDOC for correct formatting.
