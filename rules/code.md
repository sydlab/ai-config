# Code

1. Minimize scope - simplest correct diff only; no unrelated changes
2. Avoid over-engineering - no extra abstractions or edge-case handling for unlikely paths
3. Match existing conventions - naming, types, imports, docs level in the codebase
4. Comments only for non-obvious business logic or deep technical detail
5. Tests only when requested or they cover real behavior meaningfully
6. For non-trivial changes, prefer evidence (command output / failing-to-passing check) over claims
