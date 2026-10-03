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

## After you change a standard

1. Edit `standards/*.md` or `skills/git-workflow/SKILL.md`
2. Re-run install so the built Cursor rule is refreshed
3. Commit and pull on the other machine, then run install there

The skill symlink reads `SKILL.md` directly. The Cursor rule is the built file, so a standards edit is not live until install runs again.

Cursor account User Rules are not written by install. Keep editor-only preferences there; do not duplicate `standards/` or the git skill.

## Not tracked

`build/`, cli-config, chat history, plugins, per-project rules, `rules/machines/*.local.md`
