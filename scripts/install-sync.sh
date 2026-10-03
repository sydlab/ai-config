#!/usr/bin/env bash
# Install post-commit push hook and a launchd agent to fast-forward pull this repo.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOK_SRC="$SCRIPT_DIR/git-hooks/post-commit"
HOOK_DEST="$REPO_ROOT/.git/hooks/post-commit"
PULL_SCRIPT="$SCRIPT_DIR/sync-pull.sh"
PLIST_LABEL="com.arifm.ai-config-sync-pull"
PLIST_PATH="$HOME/Library/LaunchAgents/${PLIST_LABEL}.plist"

if [[ ! -f "$HOOK_SRC" ]]; then
  echo "Missing hook template: $HOOK_SRC" >&2
  exit 1
fi

mkdir -p "$(dirname "$HOOK_DEST")"
cp "$HOOK_SRC" "$HOOK_DEST"
chmod +x "$HOOK_DEST"
echo "Hook  $HOOK_DEST"

mkdir -p "$HOME/Library/LaunchAgents"
cat > "$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${PLIST_LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${PULL_SCRIPT}</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
  </dict>
  <key>RunAtLoad</key>
  <true/>
  <key>StartInterval</key>
  <integer>3600</integer>
  <key>StandardOutPath</key>
  <string>${HOME}/Library/Logs/ai-config-sync-pull.log</string>
  <key>StandardErrorPath</key>
  <string>${HOME}/Library/Logs/ai-config-sync-pull.log</string>
</dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)/${PLIST_LABEL}" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"
echo "Agent $PLIST_PATH"
echo ""
echo "Sync: commit pushes via post-commit hook; pull runs at login and every hour when the tree is clean."
