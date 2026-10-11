# ai-config

Git storage for personal global agent standards. Clone [github.com/sydlab/ai-config](https://github.com/sydlab/ai-config) to `~/tech/repos/ai-config`, edit the source files, then install so your home directory points at them.

## First-time setup (Mac)

```bash
cd ~/tech/repos/ai-config
./scripts/install.sh
./scripts/install-git-hooks.sh   # optional; enforces commit messages in every repo
```

After `git pull` here, run `./scripts/install.sh` again when the pull changed anything under `standards/`.

## How this fits together

Three layers, on purpose:

- **`standards/` → always-on rule** — small non-negotiables (security, paths, git safety, how to draft commits). Loaded every chat; keep it lean.
- **`skills/`** — procedures when relevant (commit, PR, merge cleanup). Not loaded on every message.
- **Global git hooks** — enforce message policy in git itself. No model tokens; rejects bad commits at commit/push time.

Do not duplicate the same text in Cursor account User Rules. One source here, then install.

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

The rules live in `commit_policy.py`, which the installer copies alongside the hooks.

Hook behavior (details not repeated in `standards/git.md`):

- Subject length and conventional format are enforced on the **subject line**; a body is allowed but you should still write subject-only per the standard.
- Git-generated subjects (`Merge `, `Revert "`, `fixup!`, `squash!`, `amend!`) skip length/format checks; trailers and banned words still fail.
- Trailer lines must look like real trailers (e.g. `Closes #3`, `Signed-off-by:`), not plain sentences starting with "Fixes".

A global `core.hooksPath` makes git skip each repository's own `.git/hooks` (project hooks such as Husky under `.git/hooks` will not run unless you add them under `~/.githooks` too). The hooks need `python3` on `PATH`. Edit the files in `scripts/git-hooks/global/`, then re-run the script.

## After you change a standard

1. On a feature branch, edit `standards/*.md` or `skills/git-workflow/SKILL.md`
2. Re-run install
3. Commit, push the branch, and open a PR

The skill symlink reads `SKILL.md` directly. The Cursor rule is the built file, so a standards edit is not live until install rebuilds it.

Cursor account User Rules are not written by install. Remove duplicate git, PR, code, or behavior rules from account settings if they mirror this repo. Keep only tiny editor-only preferences (e.g. citation format) that are not in `standards/`.

## Not tracked

`build/`, cli-config, chat history, plugins, per-project rules
