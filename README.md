# cursor-dotfiles

Git storage for **personal global agent standards**. One `rules/` tree builds:

- `AGENTS.md` — linked into git repos under `~/Tech` (CLI / anything that reads it)
- `~/.cursor/rules/00-personal-standards.mdc` — IDE Agent (`alwaysApply`)

## What this buys you

- Same standards on Mac + Windows after pull + install
- Less re-prompting (git, security, code taste, decision authority)
- One place to edit prefs (`rules/`), then rebuild + re-link

Standards highlights (see `rules/` for full text): short Conventional Commits (<=120 chars, no trailers/co-authors), push only when asked, local branch cleanup after merge, GitHub `delete_branch_on_merge` preferred for remotes.

## Source of truth

**Edit `rules/*.md` only.** `AGENTS.md` is **generated** — do not hand-edit it.

```
rules/*.md                # edit these
scripts/build-agents.*    # cats rules → AGENTS.md
scripts/install.*         # build, link repos, write IDE .mdc
AGENTS.md                 # generated (committed for clones)
```

## Setup (each machine)

```bash
git clone https://github.com/sydlab/cursor-dotfiles.git ~/Tech/repos/cursor-dotfiles
cd ~/Tech/repos/cursor-dotfiles
```

Windows (PowerShell; Developer Mode recommended for symlinks):

```powershell
.\scripts\install.ps1
```

Mac/Linux:

```bash
chmod +x scripts/*.sh
./scripts/install.sh
```

Install:

1. Rebuilds `AGENTS.md` from `rules/`
2. Finds git repos under `~/Tech` (recursive), **skips** `~/Tech/projects`
3. Symlinks (or copies) `AGENTS.md` into each repo; adds it to local `.git/info/exclude`
4. Writes `~/.cursor/rules/00-personal-standards.mdc` for IDE Agent

## Sync after editing standards

1. Edit `rules/*.md` only
2. Commit / pull on the other machine
3. Re-run `install.ps1` / `install.sh`

New git repo under `~/Tech` (outside `projects`) → re-run install once.

## Coverage

| Surface | Where it applies |
|---------|------------------|
| CLI `AGENTS.md` | Git repos under `~/Tech`, except `~/Tech/projects` |
| IDE `.mdc` | `~/.cursor/rules/` on this machine after install (not Cursor account sync) |

`~/Tech/.cursor` is unrelated; this install does not manage it.

Default **work** root remains `~/Tech/repos`. Scratch under `projects` stays thin on purpose (no `AGENTS.md` wiring).

## Not tracked

cli-config, built-in skills, chat history, plugins, per-project app rules, `rules/machines/*.local.md`

## IDE note

Cursor **Settings → User Rules** (account UI) is separate and not written by this repo. Prefer the installed `~/.cursor/rules/00-personal-standards.mdc` so Mac and mini stay aligned via git + install. Avoid maintaining a second hand-edited copy in the Settings UI.
