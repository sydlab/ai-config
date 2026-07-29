# Environment

## Layout

| Path | Role |
|------|------|
| `~/Tech/repos` | Everyday coding clones (default work root) |
| `~/Tech/projects` | Ungroomed / unfinished idea scratch — not the default coding root |
| GitHub Projects | System of record for idea/project status |
| Portfolio org | Curated **demoable** public showcase only |

## Repos root (`~/Tech/repos`)

- Clone into `~/Tech/repos/<repo-name>` unless the user gives a different path
- Derive `<repo-name>` from the repository URL
- Create `~/Tech/repos` if it does not exist
- If the target directory already exists and is a git repo, use it instead of recloning
- If the user says "open this in editor" for a GitHub URL, clone there first, then open that directory

## Ideas (`~/Tech/projects`) ↔ GitHub Projects

- Local `~/Tech/projects/<slug>` may hold notes/spikes for an idea
- **GitHub Projects is SoR** for status and grooming — do not invent a parallel tracker
- Prefer linking local folders to the matching GH Project / issue in notes when they exist
- Do not treat `~/Tech/projects` as the default place to scaffold production apps — promote to `~/Tech/repos` when actively building
- Do not install or assume personal `AGENTS.md` wiring under `~/Tech/projects` unless the user asks

## Portfolio (demoable only)

- Portfolio org is for **shipped / demoable** work worth showing — not every idea or private spike
- Personal coding defaults to private repos under `~/Tech/repos`
- Do not create, fork, or push to the portfolio org unless the user explicitly asks to publish/promote
- Prefer promote-once (visibility flip, transfer, or link from a portfolio site) over maintaining twin remotes

## Dotfiles

This standards repo: `~/Tech/repos/cursor-dotfiles`

## Overrides

- User provides an explicit path → use that path
- Repo is already open in the workspace → work in place; do not reclone
- Machine-specific notes may live in `rules/machines/<machine>.local.md` (gitignored)
