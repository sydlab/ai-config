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

Whether to commit or push is decided by Decision authority. This section is hard limits only.

## Safety

- NEVER update the git config
- NEVER run destructive/irreversible git commands (push --force, hard reset, etc.) unless the user explicitly requests them
- NEVER skip hooks (`--no-verify`, `--no-gpg-sign`, etc.) unless the user explicitly requests it
- NEVER force-push to main/master; warn the user if they request it
- NEVER push commits directly to `main`/`master` - use a feature branch and PR
- Avoid `git commit --amend`. ONLY use `--amend` when ALL of these are true:
  1. User explicitly requested amend, OR commit succeeded but pre-commit hook auto-modified files
  2. HEAD commit was created by you in this conversation
  3. Commit has NOT been pushed to remote
- If commit FAILED or was REJECTED by a hook, NEVER amend - fix and create a NEW commit

## Commit message (always)

Use Conventional Commits, subject-only preferred:

```
type(scope): short imperative summary
```

- Entire commit message <= 120 characters
- No trailers, no Co-authored-by, no tool attribution, no `--trailer`
- Do not use the words `cursor`, `composer`, `claude`, or `copilot` (any casing)

When actually committing, opening a PR, or cleaning up after merge, follow the **git-workflow** rule (`rules/git-workflow.md` / IDE `10-git-workflow.mdc`).

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
- Never push commits directly to `main`/`master` - always use a feature
  branch and open a PR (even when push is allowed)

## How to ask

- Batch open questions into one message
- Prefer a short recommended option plus 1-2 alternatives
- Ask on medium or high blast radius; do not interrupt for low-risk local choices
