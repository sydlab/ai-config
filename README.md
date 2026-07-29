# cursor-dotfiles

Git storage for **personal global agent standards**. Aimed at Cursor CLI (`agent`), which reads `AGENTS.md` in the project root — there is no separate CLI global-rules file.

## What this buys you

- Same standards on every repo under `~/Tech/repos` after install (Mac + Win)
- Less re-prompting (git, security, code taste, decision authority)
- One place to edit prefs (`rules/`), then rebuild + re-link

## Source of truth

**Edit `rules/*.md` only.** `AGENTS.md` is **generated** — do not hand-edit it.

```
rules/*.md                # edit these
scripts/build-agents.*    # cats rules → AGENTS.md
scripts/install.*         # build, then link/copy into ~/Tech/repos
AGENTS.md                 # generated runtime file (committed for clones)
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

Install rebuilds `AGENTS.md` from `rules/`, places it in each git repo under `~/Tech/repos` (symlink via `mklink` when possible; copy fallback), and adds `AGENTS.md` to that repo’s **local** `.git/info/exclude` so it stays personal.

## Sync after editing standards

1. Edit `rules/*.md` only
2. Commit / pull on the other machine
3. Re-run `install.ps1` / `install.sh` (rebuilds `AGENTS.md`, refreshes links)

New repo under `~/Tech/repos` → re-run install once.

## Not tracked

cli-config, built-in skills, chat history, plugins, per-project app rules, `rules/machines/*.local.md`

## IDE note

Cursor **User Rules** (Customize → Rules) are separate from CLI `AGENTS.md`. Optional for IDE Agent; this repo’s primary path is CLI install.
