<!-- GENERATED from rules/*.md - do not edit by hand. Run: .\scripts\install.ps1 (or .\scripts\build-agents.ps1) -->

# Agent instructions

Personal global standards for Cursor CLI and IDE Agent.
Edit files under `rules/`, then rebuild. Source of truth is `rules/`, not this file.

# Security

- Never commit secrets: `.env`, credentials files, API keys, tokens, private keys
- Warn the user if they ask to commit files that likely contain secrets
- Do not print or log credentials, API keys, or raw tokens
- Do not expose secrets in commit messages, PR descriptions, or agent output
- Prefer environment variables or secret managers over hardcoded values
- When debugging auth issues, redact tokens in output (show prefix only if needed)

# Git

Whether to commit or push is decided by Decision authority. This file is how.

## Safety

- NEVER update the git config
- NEVER run destructive/irreversible git commands (push --force, hard reset, etc.) unless the user explicitly requests them
- NEVER skip hooks (`--no-verify`, `--no-gpg-sign`, etc.) unless the user explicitly requests it
- NEVER force-push to main/master; warn the user if they request it
- Avoid `git commit --amend`. ONLY use `--amend` when ALL of these are true:
  1. User explicitly requested amend, OR commit succeeded but pre-commit hook auto-modified files
  2. HEAD commit was created by you in this conversation
  3. Commit has NOT been pushed to remote
- If commit FAILED or was REJECTED by a hook, NEVER amend - fix and create a NEW commit

## Commit workflow

1. Run in parallel: `git status`, `git diff`, `git log` (recent messages)
2. Draft the message using the format below
3. Do not stage files that violate Security rules
4. Add, commit, then verify with `git status`
5. Pass commit messages via HEREDOC (or PowerShell here-string) for correct formatting

## Commit message format

Use Conventional Commits. Prefer a **subject-only** message:

```
type(scope): short imperative summary
```

- Scope is optional; lowercase after the colon
- Entire commit message (subject + any body) <= 120 characters
- No multi-paragraph essays; if more detail is needed, keep it under the 120-char cap or put it in the PR body
- No footers, no trailers, no blank-line "body" blocks unless still within 120 chars total

Forbidden in commit messages:

- Git trailers of any kind (`Co-authored-by`, `Signed-off-by`, `Made-with`, `Fixes`, `Closes`, etc.)
- Co-author / tool attribution lines (including Cursor, Claude, Copilot, Composer)
- `--trailer` flags
- The words `cursor`, `composer`, `claude`, or `copilot` (any casing)

## After merge

When a PR is merged (and the user asked to merge or clean up):

1. Prefer GitHub "Automatically delete head branches" (`delete_branch_on_merge`) on the remote - do not rely on manual remote branch deletes
2. Switch local checkout off the merged feature branch (usually to `main`/`master`)
3. Delete the local feature branch: `git branch -d <branch>` (`-D` only if `-d` fails and the user confirmed)
4. Prune stale remotes: `git fetch --prune`

Do not delete branches the user did not ask to clean up, and never delete `main`/`master`.

## Pull requests

Use `gh` for all GitHub tasks (issues, PRs, checks, releases).

1. In parallel: `git status`, `git diff`, remote tracking check, `git log`, `git diff [base]...HEAD`
2. Analyze ALL commits in the PR, not only the latest
3. Push with `-u` only when authority already allows push
4. Create PR with Summary + Test plan body; return the PR URL
5. Link issues in the PR body (`Closes #N`), not in commit footers

# Code

1. Minimize scope - simplest correct diff only; no unrelated changes
2. Avoid over-engineering - no extra abstractions or edge-case handling for unlikely paths
3. Match existing conventions - naming, types, imports, docs level in the codebase
4. Comments only for non-obvious business logic or deep technical detail
5. Tests only when requested or they cover real behavior meaningfully
6. For non-trivial changes, prefer evidence (command output / failing-to-passing check) over claims

# Environment

- Default work root: `~/Tech/repos` - clone into `~/Tech/repos/<repo-name>` unless given another path
- Create `~/Tech/repos` if missing; if the target already exists as a git repo, use it; do not reclone
- Explicit path or an already-open workspace wins - work in place
- Do not invent a parallel status tracker; GitHub Projects is the system of record when status matters
- Ask before create/fork/push/promote to the portfolio org
- CLI standards install covers git repos under `~/Tech` except `~/Tech/projects`
- Dotfiles source: `~/Tech/repos/cursor-dotfiles`

# Behavior

- Investigate with tools; on failure try alternatives, diagnose, and retry
- Communicate concisely and proportionally - no fluff or closing CTAs; full commands in copy-paste blocks

# Decision authority

The agent implements; the user decides direction.
Stay inside the ask. Prefer one batched question over many.

## Decide without asking

- Local implementation that follows existing patterns in the codebase
- Naming, file placement, and structure consistent with `code.md`
- Reusing an existing project utility/library instead of adding a new one
- Minimal adjacent edits strictly required for the change to be correct
  (e.g. update a caller the edit breaks) - not drive-by cleanup

## Ask first

- Adding a dependency/package, or a new helper that duplicates existing code
- New abstraction, pattern, or architecture not already in the project
- Restructure, refactor, delete, or rename beyond what the change requires
- API shape, data model, or user-visible behavior with more than one
  reasonable approach
- Push, publish, deploy, delete remote data, message people, or change
  access/billing
- Commit or open a PR unless the user asked or the task clearly includes
  commit/PR (push still requires an explicit ask)

## How to ask

- Batch open questions into one message
- Prefer a short recommended option plus 1-2 alternatives
- Ask on medium or high blast radius; do not interrupt for low-risk local choices
