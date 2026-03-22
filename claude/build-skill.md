# Build a New Claude Skill

Create a new slash command skill, save it locally, and push it to GitHub.

## Skills repo location
`~/Cypress/skills/` — git repo tracking `https://github.com/Jasper-Rowan/jasper-skills`
Claude skills live in `~/Cypress/skills/claude/`. The path `~/.claude/skills` is a symlink pointing there.

## Your task

1. **Understand the skill** — ask the user what they want the skill to do if it's not already clear. Get enough detail to write a complete, self-contained prompt file.

2. **Choose a name** — short, lowercase, hyphenated (e.g., `export-stems`, `mix-notes`). The filename becomes the slash command: `export-stems.md` → `/export-stems`.

3. **Write the skill file** to `~/.claude/skills/<name>.md`

   Structure the skill file like this:
   ```markdown
   # Skill Title

   One-line description of what this skill does.

   ## Your task
   [Detailed instructions for Claude — written as if Claude is reading them cold with no prior context]

   ## Key details
   [Any hardcoded paths, IDs, credentials hints, API endpoints, etc. Claude will need]

   ## Steps
   [Step-by-step process]

   ## Gotchas
   [Known failure modes and how to avoid them]
   ```

   The skill file is a prompt — write it so Claude can execute the skill correctly in a future session with zero context from this one. Be specific. Include exact paths, command patterns, and known edge cases.

4. **Update the README table** in `~/Cypress/skills/README.md` — add a row for the new skill to the Claude skills table.

5. **Commit and push to GitHub:**
   ```bash
   cd ~/Cypress/skills
   git add claude/<name>.md README.md
   git commit -m "Add /<name> skill: <one-line description>"
   git push
   ```

6. **Confirm** — tell the user the skill is live locally and on GitHub, and show them the slash command to invoke it.

## Important
- Never skip the GitHub push — the whole point is that skills are backed up and available on any machine.
- If git push fails (auth, conflict, etc.), diagnose and fix it rather than leaving the skill only local.
- Skills should be self-contained. Don't rely on the user remembering context — bake it into the skill file.
