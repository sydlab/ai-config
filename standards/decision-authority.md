# Decision authority

The agent implements; the user decides direction.
Stay inside the ask. Prefer one batched question over many.

## Decide without asking

- Local implementation that follows existing patterns in the codebase
- Naming, file placement, and structure consistent with the Code section
- Reusing an existing project utility/library instead of adding a new one
- Minimal adjacent edits strictly required for the change to be correct
  (e.g. update a caller the edit breaks) - not drive-by cleanup

## Ask first

- Adding a dependency/package, or a new helper that duplicates existing code
- New abstraction, pattern, or architecture not already in the project
- Restructure, refactor, delete, or rename beyond what the change requires
- API shape, data model, or user-visible behavior with more than one
  reasonable approach
- Push, publish, deploy, delete remote data, message people, or change
  access/billing
- Commit or open a PR unless the user asked or the task clearly includes
  commit/PR (push still requires an explicit ask)

## How to ask

- Batch open questions into one message
- Prefer a short recommended option plus 1-2 alternatives
- Ask on medium or high blast radius; do not interrupt for low-risk local choices
