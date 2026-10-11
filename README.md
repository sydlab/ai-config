# ai-config

Git storage for personal global agent standards. Edit the source files, then install so your home directory points at them.

## What you edit

```
standards/*.md                         # always-on personal standards
skills/git-workflow/SKILL.md           # commit, PR, and cleanup steps
scripts/git-hooks/global/              # global commit-policy hooks
```

`standards/` is the source for the Cursor rule. `skills/git-workflow/` is the source for the skill. Do not hand-edit `build/`.

## What install does

```bash
./scripts/install.sh
```

Install:

1. Builds `build/00-personal-standards.mdc` from `standards/*.md`
2. Symlinks `~/.cursor/rules/00-personal-standards.mdc` to that built file
3. Symlinks `~/.agents/skills/git-workflow` to `skills/git-workflow`

It does not copy `AGENTS.md` into other repositories.

## Global commit hooks

Optional, enforces the commit message rules in `standards/git.md` in every repository on the machine:

```bash
./scripts/install-git-hooks.sh
```

This copies `scripts/git-hooks/global/` to `~/.githooks` and sets `git config --global core.hooksPath` to it:

- **prepare-commit-msg** strips trailers and tool footers from the body, never the subject
- **commit-msg** rejects trailers, banned words, subjects over 120 characters, and non-conventional subjects
- **pre-push** re-checks every non-merge commit on every ref being pushed

The rules live in `commit_policy.py`, which the installer copies alongside the hooks. Git-generated subjects (`Merge `, `Revert "`, `fixup!`, `squash!`, `amend!`) skip the length and format checks but not the trailer and banned-word checks.

A global `core.hooksPath` makes git skip each repository's own `.git/hooks`. The hooks need `python3` on `PATH`. Edit the files in `scripts/git-hooks/global/`, then re-run the script.

## After you change a standard

1. On a feature branch, edit `standards/*.md` or `skills/git-workflow/SKILL.md`
2. Re-run install
3. Commit, push the branch, and open a PR

The skill symlink reads `SKILL.md` directly. The Cursor rule is the built file, so a standards edit is not live until install rebuilds it.

Cursor account User Rules are not written by install. Do not keep a second copy of `standards/` or the git skill there. Editor-only preferences, such as citation format, can stay in account rules.

## Not tracked

`build/`, cli-config, chat history, plugins, per-project rules
