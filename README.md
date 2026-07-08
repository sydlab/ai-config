# cursor-dotfiles

Version-controlled Cursor User Rules for **Mac laptop** and **Windows mini PC**.

Git is the source of truth. Import rule files into **Cursor → Customize → Rules** on each machine.

## Rules (12 total)

| Layer | Path | Count | Import? |
|-------|------|-------|---------|
| Core | `rules/core/*.md` | 9 | Yes |
| Cursor | `rules/cursor/*.md` | 2 | Yes |
| Machine | `rules/machines/<machine>.local.md` | 1 | Yes |

**Do not import:**

- `AGENTS.md` — duplicates `rules/core/`; CLI only
- `rules/machines/*.example.md` — setup templates, not User Rules

## Setup

See [EXPORT.md](EXPORT.md) for clone, import, and sync steps.

Machine overlay: create `*.local.md` from `rules/machines/*.example.md` (gitignored), then import the `.local.md` file only.

## Structure

```
cursor-dotfiles/
  rules/core/           User Rules — portable (9)
  rules/cursor/         User Rules — Cursor-only (2)
  rules/machines/       Setup templates (*.local.md gitignored)
  AGENTS.md             CLI digest only
  EXPORT.md             Cursor setup guide
  PLAN.md               Preservation plan
```

## Branch policy

Never push directly to `main`. Feature branches + PRs only.
