#!/bin/bash
# Bootstrap Claude Code on a new Mac
# Run: bash setup.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Claude Code from $REPO_DIR..."

# 1. Skills — already in place if you cloned into ~/.claude/skills
echo "✓ Skills are ready (in ~/.claude/skills/)"

# 2. Status line script
cp "$REPO_DIR/statusline/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
chmod +x "$CLAUDE_DIR/statusline-command.sh"
echo "✓ Status line script installed at ~/.claude/statusline-command.sh"

# 3. Settings
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "  settings.json already exists — skipping (merge manually if needed)"
  echo "  Reference config is at: $REPO_DIR/config/settings.json"
else
  cp "$REPO_DIR/config/settings.json" "$CLAUDE_DIR/settings.json"
  echo "✓ settings.json installed"
fi

echo ""
echo "Done! Restart Claude Code to pick up all changes."
echo ""
echo "What you get:"
echo "  - /backup-logic  Back up Logic Pro projects to Google Drive"
echo "  - Status line    Shows 5h / weekly rate limits + context usage"
echo "  - Stop hook      Plays a sound + shows a notification when Claude finishes"
echo ""
echo "Note: The backup-logic skill requires:"
echo "  - gcloud CLI authenticated as jasperrowan199@gmail.com"
echo "  - Logic Pro installed"
