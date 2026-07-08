---
description: Machine layout and repo paths (portable - uses ~)
alwaysApply: true
---

# Environment

## Repos root

Default clone and checkout location on all machines:

`~/Tech/repos`

- Clone into `~/Tech/repos/<repo-name>` unless the user gives a different path
- Derive `<repo-name>` from the repository URL (e.g. `course-registrations` from `github.com/sydlab/course-registrations`)
- Create `~/Tech/repos` if it does not exist
- If the target directory already exists and is a git repo, use it instead of recloning
- If the user says "open this in editor" for a GitHub URL, clone there first, then open that directory

## Dotfiles

This repo: `~/Tech/repos/cursor-dotfiles`

## Overrides

- User provides an explicit path -> use that path
- Repo is already open in the workspace -> work in place; do not reclone
- Machine-specific notes live in `rules/machines/<machine>.local.md` (not in git)
