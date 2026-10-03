# Environment

- Default work root: `~/Tech/repos` - clone into `~/Tech/repos/<repo-name>` unless given another path
- Derive `<repo-name>` from the repository URL
- Create `~/Tech/repos` if missing; if the target already exists as a git repo, use it; do not reclone
- Explicit path or an already-open workspace wins - work in place
- Do not invent a parallel status tracker; GitHub Projects is the system of record when status matters
- Ask before create/fork/push/promote to the portfolio org
- Personal standards are installed on this machine from the ai-config repo. They are not copied into other repos
- Config repo: `~/Tech/repos/ai-config`
- Machine-specific notes live in `rules/machines/<machine>.local.md` and are not committed
