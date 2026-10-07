# ai-config

Git storage for personal global agent standards. Edit the source files, then install so this machine's home directory points at them.

## What you edit

```
standards/*.md                         # always-on personal standards
skills/git-workflow/SKILL.md           # commit, PR, and cleanup steps
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

- A **post-commit** hook in this repo that pushes feature branches after each commit. It does not push `main` or `master`, and a failed push prints a warning without undoing the commit.
- A **scheduled pull** that fast-forwards only when the working tree is clean: Windows Task Scheduler at logon and hourly; Mac launchd at login and every hour

If `core.hooksPath` is set in your git config, git ignores this repo's `.git/hooks`, so the hook never runs; install-sync prints a warning when that is the case.

Pull logs: Windows `%LOCALAPPDATA%\ai-config\sync-pull.log`; Mac `~/Library/Logs/ai-config-sync-pull.log`.

Manual pull anytime:

```powershell
.\scripts\sync-pull.ps1
```

```bash
./scripts/sync-pull.sh
```

Pull skips if you have uncommitted changes or unpushed local commits. After a successful pull, the Cursor rule is rebuilt from `standards/`.

## After you change a standard

1. On a feature branch, edit `standards/*.md` or `skills/git-workflow/SKILL.md`
2. Re-run install to use the change on this machine
3. Commit; with sync installed, the hook pushes the branch
4. Open a PR and merge it; the other machine picks up `main` on its next scheduled pull

The skill symlink reads `SKILL.md` directly. The Cursor rule is the built file, so a standards edit is not live until install or sync-pull rebuilds it.

Cursor account User Rules are not written by install. Do not keep a second copy of `standards/` or the git skill there. Editor-only preferences, such as citation format, can stay in account rules.

## Local folder name

GitHub remote is `sydlab/ai-config`. If this clone is still named `cursor-dotfiles`, close Cursor, rename the folder to `~/Tech/repos/ai-config`, reopen that folder, and run install and install-sync again so the home symlinks and the scheduled pull use the new path.

## Not tracked

`build/`, cli-config, chat history, plugins, per-project rules, `rules/machines/*.local.md`
