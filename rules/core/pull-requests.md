---
description: Pull request workflow via gh
alwaysApply: true
---

# Pull request workflow

Use the `gh` command for ALL GitHub-related tasks (issues, PRs, checks, releases).

## Creating a PR

1. Run in parallel: `git status`, `git diff`, check remote tracking, `git log`, `git diff [base]...HEAD`
2. Analyze ALL commits that will be in the PR (not just the latest)
3. Push with `-u` if needed (only when asked)
4. Create PR with `gh pr create` and HEREDOC body

## PR body template

```markdown
## Summary
<1-3 bullet points>

## Test plan
[Checklist of testing TODOs]
```

## Rules

- Return the PR URL when done
- Link issues in the PR body (`Closes #N`), not in commit footers
