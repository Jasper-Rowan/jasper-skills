#!/bin/bash
# Bootstrap Claude Code + Cursor on a new Mac
# Run: bash ~/Cypress/skills/claude/setup.sh

set -e

SKILLS_ROOT="$(cd "$(dirname "$0")/.." && pwd)"  # ~/Cypress/skills
CLAUDE_DIR="$HOME/.claude"

echo "Setting up from $SKILLS_ROOT..."

# ── Claude Code ────────────────────────────────────────────────────────────────

# Skills symlink: ~/.claude/skills -> ~/Cypress/skills/claude/
if [ -L "$CLAUDE_DIR/skills" ]; then
  echo "✓ ~/.claude/skills symlink already exists"
elif [ -d "$CLAUDE_DIR/skills" ]; then
  echo "  ~/.claude/skills is a real directory — backing up to ~/.claude/skills.bak"
  mv "$CLAUDE_DIR/skills" "$CLAUDE_DIR/skills.bak"
  ln -s "$SKILLS_ROOT/claude" "$CLAUDE_DIR/skills"
  echo "✓ ~/.claude/skills → $SKILLS_ROOT/claude"
else
  ln -s "$SKILLS_ROOT/claude" "$CLAUDE_DIR/skills"
  echo "✓ ~/.claude/skills → $SKILLS_ROOT/claude"
fi

# Status line script
cp "$SKILLS_ROOT/claude/statusline/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
chmod +x "$CLAUDE_DIR/statusline-command.sh"
echo "✓ Status line script installed at ~/.claude/statusline-command.sh"

# Settings
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  echo "  ~/.claude/settings.json already exists — skipping (merge manually if needed)"
  echo "  Reference config: $SKILLS_ROOT/claude/config/settings.json"
else
  cp "$SKILLS_ROOT/claude/config/settings.json" "$CLAUDE_DIR/settings.json"
  echo "✓ ~/.claude/settings.json installed"
fi

# ── Done ───────────────────────────────────────────────────────────────────────

echo ""
echo "Done! Restart Claude Code and Cursor to pick up all changes."
echo ""
echo "Claude skills:  /backup-logic, /build-skill"
echo "Status line:    5h / weekly rate limits + context usage"
echo "Stop hook:      Glass sound + notification when Claude finishes"
echo ""
echo "Note: backup-logic requires gcloud CLI authenticated as jasperrowan199@gmail.com"
echo "Sync changes:   cd ~/Cypress/skills && git add -A && git commit -m '...' && git push"
