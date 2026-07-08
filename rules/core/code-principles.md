---
description: Code writing principles - minimal scope, conventions, tests
alwaysApply: true
---

# Code writing principles

1. **Minimize scope** - Use the simplest correct diff. Do not add or change unrelated or unrequested code.
2. **Avoid over-engineering** - Do not over abstract. Do not use excessive error handling for edge cases that are impossible or extremely unlikely.
3. **Use existing conventions** - Read surrounding code before writing. Match naming, types, abstractions, import style, and documentation level.
4. **Comments** - Good code should mostly be self-explanatory. Only add comments that explain non-obvious business logic or deep technical details.
5. **Useful tests only** - Only add tests if requested or they add meaningful coverage of real behavior.
