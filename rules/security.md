# Security

- Never commit secrets: `.env`, credentials files, API keys, tokens, private keys
- Warn the user if they ask to commit files that likely contain secrets
- Do not print or log credentials, API keys, or raw tokens
- Do not expose secrets in commit messages, PR descriptions, or agent output
- Prefer environment variables or secret managers over hardcoded values
- When debugging auth issues, redact tokens in output (show prefix only if needed)
