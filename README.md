# Jasper's Skills

Shared AI tool configuration for Jasper Rowan — Claude Code skills and Cursor rules in one repo.

**Repo:** https://github.com/Jasper-Rowan/jasper-skills
**Local path:** `~/Cypress/skills/`

## Structure

```
jasper-skills/
├── claude/                         # Claude Code skills and config
│   ├── backup-logic.md             #   /backup-logic — back up Logic Pro to Google Drive
│   ├── build-skill.md              #   /build-skill  — create new skills and auto-push
│   ├── config/
│   │   └── settings.json           #   Claude Code settings (hooks, status line, etc.)
│   └── statusline/
│       └── statusline-command.sh   #   Status line script (rate limits + context %)
└── cursor/
    └── rules/                      # Cursor rules (.mdc files go here)
```

Claude Code reads skills from `~/.claude/skills/` — a symlink points there from `~/Cypress/skills/claude/`.
Cursor reads rules from `~/.cursor/rules/` — a symlink points there from `~/Cypress/skills/cursor/rules/`.

## Fresh machine setup

```bash
# 1. Clone the repo
git clone https://github.com/Jasper-Rowan/jasper-skills.git ~/Cypress/skills

# 2. Run setup
bash ~/Cypress/skills/claude/setup.sh
```

Restart Claude Code and Cursor. Done.

## Syncing changes

```bash
cd ~/Cypress/skills
git add -A
git commit -m "describe what changed"
git push
```

Pull on another machine:
```bash
cd ~/Cypress/skills && git pull
```

## Claude skills

| Command | Description |
|---------|-------------|
| `/backup-logic` | Zip Logic Pro X projects and upload to Google Drive (Zen Cruz > Logic Projects) |
| `/build-skill` | Create a new skill, save it locally, and auto-push to this repo |

## Cursor rules

*(None yet — add `.mdc` files to `cursor/rules/`)*
