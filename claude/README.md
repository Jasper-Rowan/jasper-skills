# Claude Skills

Personal Claude Code configuration, skills, and slash commands for Jasper Rowan.

## Fresh machine setup

```bash
# Clone directly into Claude's skills directory, then run setup
git clone https://github.com/Jasper-Rowan/claude-skills.git ~/.claude/skills
bash ~/.claude/skills/setup.sh
```

Restart Claude Code. That's it.

## What you get

| Thing | What it does |
|-------|-------------|
| `/backup-logic` | Zip Logic Pro X projects and upload to Google Drive (Zen Cruz > Logic Projects) |
| `/build-skill` | Create a new skill, write it to `~/.claude/skills/`, and auto-push to this repo |
| **Status line** | Shows `5h: X% \| week: X% \| ctx: X%` — rate limits and context usage |
| **Stop hook** | Plays a Glass sound + macOS notification when Claude finishes a task |

## Keeping skills in sync

When you add or update a skill:
```bash
cd ~/.claude/skills
git add -A
git commit -m "describe what changed"
git push
```

On another machine:
```bash
cd ~/.claude/skills
git pull
bash setup.sh  # re-run if you added new config files
```

## Repo structure

```
claude-skills/
├── README.md               # This file
├── setup.sh                # Bootstrap script for new machines
├── config/
│   └── settings.json       # Claude Code settings (hooks, status line, etc.)
├── statusline/
│   └── statusline-command.sh  # Status line script
├── backup-logic.md         # /backup-logic skill
└── build-skill.md          # /build-skill skill — create new skills and auto-push
```

## Dependencies for specific skills

**backup-logic:**
- `gcloud` CLI — authenticated as jasperrowan199@gmail.com
- Logic Pro installed
- Google Drive folder: My Drive > Jasper > Zen Cruz > Logic Projects (folder ID: `1bWmUCDPqfPE618_I_MkO6tJIsuB3JJL8`)
