# Git

## When to commit / push

Commit when the user asks, or when the task clearly includes committing. If unclear, ask first.
Push when the user asks, or when the task clearly includes push. If unclear, ask first.

## Safety

- NEVER update the git config
- NEVER run destructive/irreversible git commands (push --force, hard reset, etc.) unless the user explicitly requests them
- NEVER skip hooks (`--no-verify`, `--no-gpg-sign`, etc.) unless the user explicitly requests it
- NEVER force-push to main/master; warn the user if they request it
- Avoid `git commit --amend`. ONLY use `--amend` when ALL of these are true:
  1. User explicitly requested amend, OR commit succeeded but pre-commit hook auto-modified files
  2. HEAD commit was created by you in this conversation
  3. Commit has NOT been pushed to remote
- If commit FAILED or was REJECTED by a hook, NEVER amend — fix and create a NEW commit

## Commit workflow

1. Run in parallel: `git status`, `git diff`, `git log` (recent messages)
2. Draft the message using the format below
3. Do not stage files that likely contain secrets
4. Add → commit → verify with `git status`
5. Pass commit messages via HEREDOC (or PowerShell here-string) for correct formatting

## Commit message format

```
type(scope): short imperative summary

Optional body in plain sentences. No footers.
```

- Scope is optional
- Subject line <= 72 characters, lowercase after the colon
- Body is plain prose; wrap at 72 characters

Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`, `build`, `perf`, `style`, `revert`

Forbidden in commit messages:

- Git trailers (`Co-authored-by`, `Signed-off-by`, `Made-with`, `Fixes`, `Closes`, etc.)
- Tool attribution or `--trailer` flags
- The words `cursor`, `composer`, `claude`, or `copilot` (any casing)

## Pull requests

Use `gh` for all GitHub tasks (issues, PRs, checks, releases).

1. In parallel: `git status`, `git diff`, remote tracking check, `git log`, `git diff [base]...HEAD`
2. Analyze ALL commits in the PR, not only the latest
3. Push with `-u` if needed (only when asked or task includes push)
4. Create PR with Summary + Test plan body; return the PR URL
5. Link issues in the PR body (`Closes #N`), not in commit footers
