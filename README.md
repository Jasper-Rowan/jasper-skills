# Claude Skills

Personal Claude Code slash commands for Jasper Rowan.

## Setup on a new machine

```bash
# Clone directly into Claude's skills directory
git clone https://github.com/Jasper-Rowan/claude-skills.git ~/.claude/skills
```

That's it — Claude Code will pick up all skills automatically on next launch.

## Updating skills

```bash
cd ~/.claude/skills
git add -A
git commit -m "update skills"
git push
```

## Pulling updates on another machine

```bash
cd ~/.claude/skills
git pull
```

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| backup-logic | `/backup-logic` | Back up Logic Pro X projects to Google Drive (Zen Cruz folder) |
