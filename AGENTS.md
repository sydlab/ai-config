# Agent instructions

Personal global standards for Cursor CLI (and any tool that reads `AGENTS.md`).
Source files live in `rules/`. Edit those, rebuild this file if you split changes, then re-run install.

## Security

- Never commit secrets: `.env`, credentials files, API keys, tokens, private keys
- Warn the user if they ask to commit files that likely contain secrets
- Do not print or log credentials, API keys, or raw tokens
- Do not expose secrets in commit messages, PR descriptions, or agent output
- Prefer environment variables or secret managers over hardcoded values
- When debugging auth issues, redact tokens in output (show prefix only if needed)

## Git

### When to commit / push

Commit when the user asks, or when the task clearly includes committing. If unclear, ask first.
Push when the user asks, or when the task clearly includes push. If unclear, ask first.

### Safety

- NEVER update the git config
- NEVER run destructive/irreversible git commands (push --force, hard reset, etc.) unless the user explicitly requests them
- NEVER skip hooks (`--no-verify`, `--no-gpg-sign`, etc.) unless the user explicitly requests it
- NEVER force-push to main/master; warn the user if they request it
- Avoid `git commit --amend`. ONLY use `--amend` when ALL of these are true:
  1. User explicitly requested amend, OR commit succeeded but pre-commit hook auto-modified files
  2. HEAD commit was created by you in this conversation
  3. Commit has NOT been pushed to remote
- If commit FAILED or was REJECTED by a hook, NEVER amend — fix and create a NEW commit

### Commit workflow

1. Run in parallel: `git status`, `git diff`, `git log` (recent messages)
2. Draft the message using the format below
3. Do not stage files that likely contain secrets
4. Add → commit → verify with `git status`
5. Pass commit messages via HEREDOC (or PowerShell here-string) for correct formatting

### Commit message format

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

### Pull requests

Use `gh` for all GitHub tasks (issues, PRs, checks, releases).

1. In parallel: `git status`, `git diff`, remote tracking check, `git log`, `git diff [base]...HEAD`
2. Analyze ALL commits in the PR, not only the latest
3. Push with `-u` if needed (only when asked or task includes push)
4. Create PR with Summary + Test plan body; return the PR URL
5. Link issues in the PR body (`Closes #N`), not in commit footers

## Code

1. Minimize scope — simplest correct diff only; no unrelated changes
2. Avoid over-engineering — no extra abstractions or edge-case handling for unlikely paths
3. Match existing conventions — naming, types, imports, docs level in the codebase
4. Comments only for non-obvious business logic or deep technical detail
5. Tests only when requested or they cover real behavior meaningfully

## Environment

Default clone and checkout location: `~/Tech/repos`

- Clone into `~/Tech/repos/<repo-name>` unless the user gives a different path
- Derive `<repo-name>` from the repository URL
- Create `~/Tech/repos` if it does not exist
- If the target directory already exists and is a git repo, use it instead of recloning
- If the user says "open this in editor" for a GitHub URL, clone there first, then open that directory
- Dotfiles repo: `~/Tech/repos/cursor-dotfiles`
- User provides an explicit path → use that path
- Repo is already open in the workspace → work in place; do not reclone

## Behavior

- Real environment: run commands, investigate, retry on failure
- Use full conversation history; mid-task messages are usually steering, not canceling
- Markdown links with full URLs/paths; proportional concise prose; no engagement baiting
- Full commands in copy-paste blocks — no `...` omissions

## Decision authority

Default to asking before anything beyond the immediate ask. The agent implements; the user decides direction.

Decide without asking:

- Implementation details that follow existing patterns in the codebase
- Naming, file placement, and structure consistent with the code standards above
- Which existing utility or library already in the project to reuse

Ask first:

- Adding a new dependency or package
- Introducing a new abstraction, pattern, or architecture not already present
- Restructuring, refactoring, or deleting/renaming outside the scope of the request
- Choices that change API shape, data model, or user-visible behavior when more than one reasonable approach exists

If unsure whether something needs confirmation, ask.
