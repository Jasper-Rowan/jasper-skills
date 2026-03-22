---
name: create-worktree
description: Create a new git worktree branched from main. Use when the user wants to create a worktree, work on a feature in a separate directory, or needs parallel work on different branches. Always branches from main after pulling latest.
---

# Create Git Worktree

When creating a new git worktree, always branch from an up-to-date main. Applies to both **frontend** and **background-tasks** repos.

## Workflow

### Step 1: Identify the repo

- **Frontend**: `/Users/jasperrowan/Cypress/frontend`
- **Background-tasks**: `/Users/jasperrowan/Cypress/background-tasks`

### Step 2: Checkout main and pull

```bash
cd <repo-path>
git checkout main
git pull origin main
```

### Step 3: Create worktree from main

```bash
git worktree add <path> -b <branch-name>
```

**Path conventions:**
- Frontend: `../frontend-<feature-name>` (sibling of frontend)
- Background-tasks: `../background-tasks-<feature-name>` (sibling of background-tasks)

**Branch naming:** Use `jrowan/<ticket>/description` or `jrowan/no-ticket/description` when applicable.

### Step 4: Open in Cursor (optional)

```bash
cursor <worktree-path>
```

## Example: Frontend e2e fixes

```bash
cd /Users/jasperrowan/Cypress/frontend
git checkout main
git pull origin main
git worktree add ../frontend-e2e-fixes -b jrowan/e2e-test-fixes
cursor /Users/jasperrowan/Cypress/frontend-e2e-fixes
```

## Example: Background-tasks feature

```bash
cd /Users/jasperrowan/Cypress/background-tasks
git checkout main
git pull origin main
git worktree add ../background-tasks-my-feature -b jrowan/TICKET-123/my-feature
cursor /Users/jasperrowan/Cypress/background-tasks-my-feature
```

## Rules

- **Always** checkout main and pull before creating the worktree
- **Never** create a worktree from a feature branch or stale main
- Worktrees are for new features and should always start from the latest main
