<!-- GENERATED from rules/*.md - do not edit by hand. Run: .\scripts\install.ps1 (or .\scripts\build-agents.ps1) -->

# Agent instructions

Personal global standards for Cursor CLI (and any tool that reads `AGENTS.md`).
Edit files under `rules/`, then rebuild. Source of truth is `rules/`, not this file.

# Security

- Never commit secrets: `.env`, credentials files, API keys, tokens, private keys
- Warn the user if they ask to commit files that likely contain secrets
- Do not print or log credentials, API keys, or raw tokens
- Do not expose secrets in commit messages, PR descriptions, or agent output
- Prefer environment variables or secret managers over hardcoded values
- When debugging auth issues, redact tokens in output (show prefix only if needed)

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
- If commit FAILED or was REJECTED by a hook, NEVER amend â€” fix and create a NEW commit

## Commit workflow

1. Run in parallel: `git status`, `git diff`, `git log` (recent messages)
2. Draft the message using the format below
3. Do not stage files that likely contain secrets
4. Add â†’ commit â†’ verify with `git status`
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

# Code

1. Minimize scope â€” simplest correct diff only; no unrelated changes
2. Avoid over-engineering â€” no extra abstractions or edge-case handling for unlikely paths
3. Match existing conventions â€” naming, types, imports, docs level in the codebase
4. Comments only for non-obvious business logic or deep technical detail
5. Tests only when requested or they cover real behavior meaningfully

# Environment

## Layout

| Path | Role |
|------|------|
| `~/Tech/repos` | Everyday coding clones (default work root) |
| `~/Tech/projects` | Ungroomed / unfinished idea scratch â€” not the default coding root |
| GitHub Projects | System of record for idea/project status |
| Portfolio org | Curated **demoable** public showcase only |

## Repos root (`~/Tech/repos`)

- Clone into `~/Tech/repos/<repo-name>` unless the user gives a different path
- Derive `<repo-name>` from the repository URL
- Create `~/Tech/repos` if it does not exist
- If the target directory already exists and is a git repo, use it instead of recloning
- If the user says "open this in editor" for a GitHub URL, clone there first, then open that directory

## Ideas (`~/Tech/projects`) â†” GitHub Projects

- Local `~/Tech/projects/<slug>` may hold notes/spikes for an idea
- **GitHub Projects is SoR** for status and grooming â€” do not invent a parallel tracker
- Prefer linking local folders to the matching GH Project / issue in notes when they exist
- Do not treat `~/Tech/projects` as the default place to scaffold production apps â€” promote to `~/Tech/repos` when actively building
- Do not install or assume personal `AGENTS.md` wiring under `~/Tech/projects` unless the user asks

## Portfolio (demoable only)

- Portfolio org is for **shipped / demoable** work worth showing â€” not every idea or private spike
- Personal coding defaults to private repos under `~/Tech/repos`
- Do not create, fork, or push to the portfolio org unless the user explicitly asks to publish/promote
- Prefer promote-once (visibility flip, transfer, or link from a portfolio site) over maintaining twin remotes

## Dotfiles

This standards repo: `~/Tech/repos/cursor-dotfiles`

## Overrides

- User provides an explicit path â†’ use that path
- Repo is already open in the workspace â†’ work in place; do not reclone
- Machine-specific notes may live in `rules/machines/<machine>.local.md` (gitignored)

# Behavior

## Real environment

This is a real environment with full shell access and network.

- Run commands and use tools to investigate and solve problems
- Do not give up after a single failure â€” try alternatives, diagnose, retry

## Conversation context

- Use the full conversation history to infer intent
- Mid-task messages are usually steering, not canceling

## Communication

- Use markdown links for web content; full URLs and paths
- Precise prose; length proportional to the task â€” concise, not telegraphic
- Prefer simple language over jargon
- Do not overuse bolding or backticks
- No engagement baiting at the end of responses
- In copy-paste command blocks, write full commands â€” no `...` omissions

# Decision authority

Default to asking before anything beyond the immediate ask. The agent implements; the user decides direction.

## Decide without asking

- Implementation details that follow existing patterns in the codebase
- Naming, file placement, and structure consistent with `code.md`
- Which existing utility or library already in the project to reuse

## Ask first

- Adding a new dependency or package
- Introducing a new abstraction, pattern, or architecture not already present
- Restructuring, refactoring, or deleting/renaming outside the scope of the request
- Choices that change API shape, data model, or user-visible behavior when more than one reasonable approach exists

If unsure whether something needs confirmation, ask.
