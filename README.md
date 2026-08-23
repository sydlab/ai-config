# cursor-dotfiles

Git storage for **personal global agent standards**. One `rules/` tree builds:

- `AGENTS.md` — lean always-on core, linked into git repos under `~/Tech`
- `~/.cursor/rules/00-personal-standards.mdc` — same core for IDE (`alwaysApply: true`)
- `~/.cursor/rules/10-git-workflow.mdc` — commit/PR/merge procedures (`alwaysApply: false`, agent-requested)

Ask/Plan cannot commit or push anyway; heavy git procedure stays out of the always-on file so every prompt stays lighter.

## What this buys you

- Same standards on Mac + Windows after pull + install
- Less re-prompting (security, code taste, decision authority)
- Git **limits** always on; git **procedures** only when committing/PRing

Standards highlights: Conventional Commits (<=120 chars, no trailers/co-authors), push only when asked, never push straight to `main` (branch + PR), local cleanup after merge, GitHub `delete_branch_on_merge` for remotes.

## Source of truth

**Edit `rules/*.md` only.** `AGENTS.md` is **generated** — do not hand-edit it.

```
rules/security.md, git.md, code.md, ...   # always-on → AGENTS.md
rules/git-workflow.md                     # NOT in AGENTS.md → IDE 10-git-workflow.mdc
scripts/build-agents.*                    # cats always-on rules → AGENTS.md
scripts/install.*                         # build, link repos, write IDE .mdc files
```

`git-workflow.md` is excluded from the build-agents file list on purpose.

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

1. Rebuilds lean `AGENTS.md` from always-on `rules/`
2. Finds git repos under `~/Tech` (recursive), **skips** `~/Tech/projects`
3. Symlinks (or copies) `AGENTS.md` into each repo; adds it to local `.git/info/exclude`
4. Writes `00-personal-standards.mdc` (always) and `10-git-workflow.mdc` (agent-requested)

## Sync after editing standards

1. Edit `rules/*.md` only
2. Commit / pull on the other machine
3. Re-run `install.ps1` / `install.sh`

New git repo under `~/Tech` (outside `projects`) → re-run install once.

## Coverage

| Surface | Where it applies |
|---------|------------------|
| CLI `AGENTS.md` | Always-on core in git repos under `~/Tech`, except `projects` |
| IDE `00-*.mdc` | Always-on core on this machine |
| IDE `10-git-workflow.mdc` | When agent pulls it in for commit/PR/merge work |

`~/Tech/.cursor` is unrelated; this install does not manage it.

Default **work** root remains `~/Tech/repos`. Scratch under `projects` stays thin on purpose (no `AGENTS.md` wiring).

## Not tracked

cli-config, built-in skills, chat history, plugins, per-project app rules, `rules/machines/*.local.md`

## IDE note

Cursor **Settings → User Rules** (account UI) is separate and not written by this repo. Prefer the installed `~/.cursor/rules/*.mdc` files so Mac and mini stay aligned via git + install.
