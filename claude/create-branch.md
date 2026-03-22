# Create Branch

Create a properly named git branch from current uncommitted changes. Use when the user wants to create a new branch, move changes to a branch, or mentions "let's create a branch".

## Branch naming convention

**With Jira ticket:** `jrowan/TICKET-123/descriptive-name`
**Without ticket:** `jrowan/no-ticket/descriptive-name`

Descriptive name: lowercase, hyphens, 2–4 words, focused on the change (e.g. `add-user-auth`, `fix-login-bug`).

## Workflow

### 1. Analyze current changes

```bash
git status
git diff --stat
```

Read the changes to understand what's been modified. Note key files and areas changed.

### 2. Ask about a Jira ticket

Ask the user: "Do you have a Jira ticket for these changes?"

If yes, ask for the ticket number (e.g. `PROJ-123`).

### 3. Suggest a branch name

Based on the actual changes, suggest a branch name. Show what you based the name on:

> "I suggest: `jrowan/AGENT-456/add-mcp-testing` — based on your changes adding MCP connection tests and docs."

Ask if they want to proceed or modify it.

### 4. Create the branch

Once confirmed:

```bash
git checkout -b jrowan/TICKET-123/descriptive-name
```

Confirm: "✓ Created and switched to `jrowan/TICKET-123/descriptive-name`. Your changes are on this branch and ready to commit."

## Important notes

- **Don't commit** — just create the branch
- **Check if branch already exists** — suggest `-v2` suffix or ask for an alternative
- **Warn if not on main/master** — offer to switch to main first or branch from current location
- **If no changes detected** — confirm the user still wants a branch
- **Names from actual changes** — never use generic names like `new-feature` or `fix`
