# cursor-dotfiles

Git storage for **personal global agent standards**. Aimed at Cursor CLI (`agent`), which reads `AGENTS.md` in the project root — there is no separate CLI global-rules file.

## What this buys you

- Same standards on every repo under `~/Tech/repos` after install (Mac + Win)
- Less re-prompting (git, security, code taste, decision authority)
- One place to edit prefs, then re-link

## Layout

```
AGENTS.md                 # what CLI loads (canonical runtime text)
rules/                    # modular source (edit here, keep AGENTS.md in sync)
rules/machines/           # optional OS/path overlays (*.local.md gitignored)
scripts/install.ps1       # Windows: link AGENTS.md into each repo
scripts/install.sh        # Mac/Linux: same
README.md
```

## Not tracked

cli-config, built-in skills, chat history, plugins, per-project app rules, `*.local.md`

## Setup (each machine)

```bash
git clone https://github.com/sydlab/cursor-dotfiles.git ~/Tech/repos/cursor-dotfiles
cd ~/Tech/repos/cursor-dotfiles
```

Windows (PowerShell, Developer Mode or admin may be needed for symlinks):

```powershell
.\scripts\install.ps1
```

Mac/Linux:

```bash
./scripts/install.sh
```

Install places `AGENTS.md` in each git repo under `~/Tech/repos` (symlink when allowed; **copy** fallback on Windows without Developer Mode) and adds `AGENTS.md` to that repo’s **local** `.git/info/exclude` so it stays personal (not committed). Re-run install after editing if your machine used COPY mode.

Optional: copy `rules/machines/*.example.md` → `*.local.md` for your own notes (not loaded by CLI unless you merge into `AGENTS.md`).

## Sync after editing standards

1. Edit `rules/*.md` and update `AGENTS.md` to match
2. Commit / pull on the other machine
3. Re-run `install.ps1` / `install.sh` (safe to re-run; refreshes links)

New repo under `~/Tech/repos` → re-run install once.

## IDE note

Cursor **User Rules** (Customize → Rules) are separate from CLI `AGENTS.md`. Optional: paste the same standards there for IDE Agent. This repo’s primary path is CLI install.
