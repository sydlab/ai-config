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

Use Conventional Commits:

```
type(scope): short imperative summary
```

- Entire commit message <= 120 characters. Subject only; no body
- No trailers, no Co-authored-by, no tool attribution, no `--trailer`
- Do not use the words `cursor`, `composer`, `claude`, or `copilot` (any casing)
- Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`, `build`, `perf`, `style`, `revert`

When actually committing, opening a PR, or cleaning up after merge, follow the **git-workflow** skill.
