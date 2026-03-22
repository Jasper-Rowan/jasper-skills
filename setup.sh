#!/bin/bash
# Bootstrap Claude Code + Cursor on a new Mac
# Run: bash ~/Cypress/skills/setup.sh

set -e

SKILLS_ROOT="$(cd "$(dirname "$0")" && pwd)"  # ~/Cypress/skills
CLAUDE_DIR="$HOME/.claude"
CURSOR_DIR="$HOME/.cursor"

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

# ── Cursor ─────────────────────────────────────────────────────────────────────

mkdir -p "$CURSOR_DIR/skills"

# Copy each Cursor skill folder from the repo into ~/.cursor/skills/
for skill_dir in "$SKILLS_ROOT/cursor"/*/; do
  skill_name=$(basename "$skill_dir")
  dest="$CURSOR_DIR/skills/$skill_name"
  if [ -d "$dest" ]; then
    echo "  Cursor skill '$skill_name' already exists — skipping (delete manually to reinstall)"
  else
    cp -r "$skill_dir" "$dest"
    echo "✓ Cursor skill installed: $skill_name"
  fi
done

# ── Done ───────────────────────────────────────────────────────────────────────

echo ""
echo "Done! Restart Claude Code and Cursor to pick up all changes."
echo ""
echo "Claude skills:  /backup-logic, /build-skill, /duplo-vpn-staging,"
echo "                /create-branch, /create-statsig-flags, /notion-requirements,"
echo "                /pr-review, /run-e2e-tests"
echo "Cursor skills:  create-branch, create-statsig-flags, create-worktree,"
echo "                duplo-vpn-staging, notion-requirements, pr-review, run-e2e-tests"
echo "Status line:    5h / weekly rate limits + context usage"
echo "Stop hook:      Glass sound + notification when Claude finishes"
echo ""
echo "Note: backup-logic requires gcloud CLI authenticated as jasperrowan199@gmail.com"
echo "Sync changes:   cd ~/Cypress/skills && git add -A && git commit -m '...' && git push"
