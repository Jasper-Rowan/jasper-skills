---
name: create-branch
description: Create a new git branch with standardized naming (jrowan/TICKET-123/description or jrowan/no-ticket/description) based on current changes. Use when the user wants to create a new branch, move changes to a branch, or mentions creating a branch for uncommitted work.
---

# Create Branch

Interactive workflow to create a properly named git branch from uncommitted changes.

## When to Use

Use this skill when:

- User asks to create a new branch
- User wants to move current changes to a branch
- User mentions "let's create a branch" or similar
- User has uncommitted changes on main/master they want to isolate

## Workflow

### Step 1: Analyze Current Changes

Check git status and recent changes:

```bash
git status
git diff --stat
```

Examine the changes to understand what's been modified.

### Step 2: Ask About Jira Ticket

Use the AskQuestion tool to ask if there's a Jira ticket:

```
AskQuestion with:
- prompt: "Do you have a Jira ticket for these changes?"
- options:
  - "Yes, I have a ticket"
  - "No ticket"
```

### Step 3: Get Ticket Number (if applicable)

If user has a ticket, ask conversationally:
"What's the Jira ticket number? (e.g., PROJ-123)"

Wait for their response.

### Step 4: Generate Branch Name

Based on the changes analyzed, suggest a descriptive branch name following this format:

**With ticket:**

```
jrowan/TICKET-123/descriptive-name
```

**Without ticket:**

```
jrowan/no-ticket/descriptive-name
```

**Descriptive name guidelines:**

- Use lowercase with hyphens
- 2-4 words maximum
- Focus on the main change/feature
- Examples: `add-user-auth`, `fix-login-bug`, `update-api-endpoints`

### Step 5: Present and Confirm

Present the suggested branch name to the user:

"I suggest creating this branch:
`jrowan/TICKET-123/descriptive-name`

Based on your changes to [list key files/areas changed]."

Ask if they want to proceed or modify the name.

### Step 6: Create Branch

Once confirmed, create the branch:

```bash
git checkout -b branch-name
```

Confirm success:
"✓ Created and switched to branch `branch-name`
Your changes are now on this branch and ready to commit."

## Example Interaction

**User:** "Let's create a new branch for this"

**Agent:**

1. Checks git status, sees changes to `apps/agents_v2/test_mcp_connection.py` and `docs/LOCAL_MCP_SETUP.md`
2. Asks via AskQuestion: "Do you have a Jira ticket for these changes?"
3. User selects "Yes, I have a ticket"
4. Agent asks: "What's the Jira ticket number?"
5. User responds: "AGENT-456"
6. Agent suggests: "I suggest creating this branch: `jrowan/AGENT-456/add-mcp-testing`
   Based on your changes adding MCP connection tests and documentation."
7. User confirms
8. Agent runs: `git checkout -b jrowan/AGENT-456/add-mcp-testing`
9. Agent confirms: "✓ Created and switched to branch `jrowan/AGENT-456/add-mcp-testing`"

## Important Notes

- **Always check git status first** to understand the changes
- **Use AskQuestion tool** for the ticket question (better UX than conversational)
- **Generate meaningful names** from the actual changes, don't use generic names
- **Don't commit** - just create the branch, user will commit when ready
- **Verify you're on main/master** before creating branch (warn if not)
- **Check for conflicts** - if branch name exists, suggest alternatives

## Error Handling

**If branch already exists:**
Suggest: `jrowan/TICKET-123/descriptive-name-v2` or ask user for alternative

**If not on main/master:**
Warn: "You're currently on branch `current-branch`. Do you want to:

- Switch to main first, then create new branch
- Create branch from current location"

**If no changes detected:**
Inform: "No uncommitted changes detected. Do you still want to create a branch?"
