# ai-config

Git storage for personal global agent standards. Edit the source files, then install so this machine's home directory points at them.

## What you edit

```
standards/*.md                         # always-on personal standards
skills/git-workflow/SKILL.md           # commit, PR, and cleanup steps
scripts/git-hooks/global/              # global commit-policy hooks
rules/machines/*.local.md              # this machine only, not committed
```

`standards/` is the source for the Cursor rule. `skills/git-workflow/` is the source for the skill. Do not hand-edit `build/`.

## What install does

Windows:

```powershell
.\scripts\install.ps1
```

Mac or Linux:

```bash
chmod +x scripts/*.sh
./scripts/install.sh
```

Install:

1. Builds `build/00-personal-standards.mdc` from `standards/*.md`
2. Symlinks `~/.cursor/rules/00-personal-standards.mdc` to that built file
3. Symlinks `~/.agents/skills/git-workflow` to `skills/git-workflow`
4. Removes `~/.cursor/rules/10-git-workflow.mdc` if a previous install left it there

It does not scan `~/Tech` and does not copy `AGENTS.md` into other repositories. On Windows, symlink creation must succeed. If it fails, enable Developer Mode and run install again. Install will not leave a copy behind.

To remove old personal symlinks from a previous install:

```powershell
.\scripts\uninstall-legacy-agents.ps1
```

```bash
./scripts/uninstall-legacy-agents.sh
```

## Sync across machines

Optional automation after install:

```powershell
.\scripts\install-sync.ps1
```

```bash
./scripts/install-sync.sh
```

This installs:

- A **post-commit** hook in this repo that runs `git push` after each commit (push failures do not undo the commit)
- A **scheduled pull** that fast-forwards only when the working tree is clean: Windows Task Scheduler at logon and hourly; Mac launchd at login and every hour

Manual pull anytime:

```powershell
.\scripts\sync-pull.ps1
```

```bash
./scripts/sync-pull.sh
```

Pull skips if you have uncommitted changes or unpushed local commits. After a successful pull, the Cursor rule is rebuilt from `standards/`.

## Global commit hooks

Optional, enforces the commit message rules in `standards/git.md` in every repository on the machine:

```powershell
.\scripts\install-git-hooks.ps1
```

```bash
./scripts/install-git-hooks.sh
```

This copies `scripts/git-hooks/global/` to `~/.githooks` and sets `git config --global core.hooksPath` to it:

- **prepare-commit-msg** strips trailers and tool footers
- **commit-msg** rejects trailers, banned words, subjects over 120 characters, and non-conventional subjects
- **pre-push** re-checks every commit being pushed
- **post-commit** runs the repository's own `.git/hooks/post-commit`, so the sync push above keeps working

The hooks need `python3` on `PATH`. On Windows they run under Git Bash. Edit the files in `scripts/git-hooks/global/`, then re-run the script.

## After you change a standard

1. Edit `standards/*.md` or `skills/git-workflow/SKILL.md`
2. Re-run install (or rely on sync-pull after commit on the other machine)
3. Commit when ready; with sync installed, push runs from the hook

The skill symlink reads `SKILL.md` directly. The Cursor rule is the built file, so a standards edit is not live until install or sync-pull rebuilds it.

Cursor account User Rules are not written by install. Do not keep a second copy of `standards/` or the git skill there. Editor-only preferences, such as citation format, can stay in account rules.

## Local folder name

GitHub remote is `sydlab/ai-config`. If this clone is still named `cursor-dotfiles`, close Cursor, rename the folder to `~/Tech/repos/ai-config`, reopen that folder, and run install again so home symlinks use the new path.

## Not tracked

`build/`, cli-config, chat history, plugins, per-project rules, `rules/machines/*.local.md`
