---
description: Git commit format for all projects - no trailers, no AI tool attribution
alwaysApply: true
---

# Git commits (all projects)

Follow this format for every commit message.

## Format

```
type(scope): short imperative summary

Optional body in plain sentences. No footers.
```

- Scope is optional
- Subject line <= 72 characters, lowercase after the colon
- Body is plain prose; wrap at 72 characters

## Types

| Type | When to use |
|------|-------------|
| `feat` | New feature or capability |
| `fix` | Bug fix |
| `refactor` | Code restructured - no behavior change |
| `chore` | Tooling, deps, config, scripts |
| `docs` | Documentation only |
| `test` | Adding or updating tests |
| `ci` | CI/CD pipeline changes |
| `build` | Build system or dependency changes |
| `perf` | Performance improvement |
| `style` | Formatting only - no code change |
| `revert` | Revert a previous commit |

## Forbidden

- Git trailers: `Co-authored-by`, `Signed-off-by`, `Made-with`, `Fixes`, `Closes`, etc.
- Tool attribution or `--trailer` flags
- The words `cursor`, `composer`, `claude`, or `copilot` (any casing) in commit messages
