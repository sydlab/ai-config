# Git workflow

Procedures for commit, PR, and post-merge cleanup. Use when the user asked to commit, open a PR, merge, or clean up branches - not needed for Ask/Plan advice-only chats.

## Commit workflow

1. Run in parallel: `git status`, `git diff`, `git log` (recent messages)
2. Draft a Conventional Commits subject-only message (<= 120 chars total; no trailers/co-authors)
3. Do not stage files that violate Security rules
4. Add, commit, then verify with `git status`
5. Pass commit messages via HEREDOC (or PowerShell here-string) for correct formatting

## After merge

When a PR is merged (and the user asked to merge or clean up):

1. Prefer GitHub "Automatically delete head branches" (`delete_branch_on_merge`) on the remote - do not rely on manual remote branch deletes
2. Switch local checkout off the merged feature branch (usually to `main`/`master`)
3. Delete the local feature branch: `git branch -d <branch>` (`-D` only if `-d` fails and the user confirmed)
4. Prune stale remotes: `git fetch --prune`

Do not delete branches the user did not ask to clean up, and never delete `main`/`master`.

## Pull requests

Never push commits directly to `main`/`master`. Always commit on a feature branch, push that branch, and open a PR with `gh`.

Use `gh` for all GitHub tasks (issues, PRs, checks, releases).

1. In parallel: `git status`, `git diff`, remote tracking check, `git log`, `git diff [base]...HEAD`
2. Analyze ALL commits in the PR, not only the latest
3. Push the feature branch with `-u` only when authority already allows push - never `git push` to `main`/`master`
4. Create PR with Summary + Test plan body; return the PR URL
5. Link issues in the PR body (`Closes #N`), not in commit footers
