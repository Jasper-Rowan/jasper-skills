# Jasper's Skills

Personal AI skills for Jasper Rowan — Claude Code and Cursor slash commands in one repo.

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
└── cursor/                         # Cursor skills (add .md files here)
```

Claude Code reads skills from `~/.claude/skills/` — a symlink points there from `~/Cypress/skills/claude/`.

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
| `/duplo-vpn-staging` | Connect to DuploCloud staging VPC via OpenVPN, then use duploctl/kubectl to debug |

## Cursor skills

Cursor skills live in `~/.cursor/skills/<name>/SKILL.md`. Backed up here under `cursor/`.

| Skill | Description |
|-------|-------------|
| `create-branch` | Create a standardized git branch (jrowan/TICKET-123/description) |
| `create-statsig-flags` | Create Statsig feature flags via Siggy CLI |
| `create-worktree` | Create a git worktree branched from main for parallel work |
| `duplo-vpn-staging` | Connect to DuploCloud staging VPC, use duploctl/kubectl |
| `notion-requirements` | Create user-focused requirements tables for Notion |
| `pr-review` | Structured PR review: description, feature flags, E2E tests |
| `run-e2e-tests` | Run Playwright E2E tests and serve the HTML report |
