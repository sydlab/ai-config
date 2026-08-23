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
