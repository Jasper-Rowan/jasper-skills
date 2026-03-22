---
name: notion-requirements
description: Create user-focused requirements for Notion databases with acceptance criteria. Use when the user wants to document requirements, create a requirements table for Notion, or needs help formatting requirements in a Notion-compatible markdown table.
---

# Notion Requirements Creator

This skill helps you create user-focused requirements formatted as markdown tables that can be pasted directly into Notion and converted to a database.

## Workflow

Follow this iterative process:

### Step 1: Present Requirements in Human-Readable Format

Present requirements in a conversational format with clear sections:

```markdown
## Must Have Requirements

**REQ-001: [Short Title]**
[1-3 sentence description focusing on user behavior and outcomes]

Acceptance Criteria:
- [Concise criterion 1]
- [Concise criterion 2]
- [Concise criterion 3]

**REQ-002: [Short Title]**
...

## Nice to Have Requirements

**REQ-003: [Short Title]**
...
```

### Step 2: Iterate Based on Feedback

Wait for user confirmation or feedback. Make adjustments as needed:
- Add/remove requirements
- Adjust priority (Must Have vs Nice to Have)
- Refine descriptions or acceptance criteria
- Ensure focus stays on user behavior, not technical implementation

### Step 3: Format as Markdown Table

Once requirements are confirmed, format as a markdown table:

```markdown
| Requirement Description | Priority | Acceptance Criteria |
|------------------------|----------|---------------------|
| [Full description] | Must have | [Criterion 1]. [Criterion 2]. [Criterion 3]. |
| [Full description] | Nice to have | [Criterion 1]. [Criterion 2]. |
```

Present the table in a code block so the user can copy it directly.

## Requirements Writing Guidelines

### Focus on User Behavior
- ✅ Good: "Users should be able to connect their personal calendar to use in AI chats"
- ❌ Avoid: "Create MCPConnection model with user FK and encrypted token field"

### Keep Descriptions Concise
- 1-3 sentences maximum
- Focus on WHAT the user can do and WHY it matters
- Avoid technical implementation details

### Write Clear Acceptance Criteria
- Each criterion should be testable/verifiable
- Keep criteria concise (one sentence each)
- Focus on observable outcomes
- In the markdown table, separate criteria with periods (not line breaks)

### Priority Levels
- **Must have**: Core functionality required for MVP
- **Nice to have**: Enhancements for future phases

## Formatting Rules for Notion

These rules ensure the table pastes cleanly into Notion:

1. **No HTML tags**: Never use `<br>`, `<b>`, `<i>`, or any HTML
2. **Plain text only**: Use markdown syntax, not HTML
3. **Single paragraph for criteria**: In the table, join all acceptance criteria into one paragraph separated by periods
4. **Proper table syntax**: Use `|` separators and header row with dashes

## Example Output

**Human-readable format (Step 1):**

```
## Must Have Requirements

**REQ-001: Connect Personal Tools**
Users should be able to connect their personal tools (Zapier, Fathom) to use in their AI chats. Each user's connections are private and isolated from other users.

Acceptance Criteria:
- User can add new connection with provider, URL, and token
- User can test and disconnect connections
- Other users cannot access credentials
- Personal tools appear in AI chats
```

**Markdown table format (Step 3):**

```markdown
| Requirement Description | Priority | Acceptance Criteria |
|------------------------|----------|---------------------|
| Users should be able to connect their personal tools (Zapier, Fathom) to use in their AI chats. Each user's connections are private and isolated from other users. | Must have | User can add new connection with provider, URL, and token. User can test and disconnect connections. Other users cannot access credentials. Personal tools appear in AI chats. |
```

## Common Pitfalls to Avoid

1. **Technical implementation details in requirements**
   - Requirements describe user behavior, not database schemas or API endpoints
   - Save technical details for tech specs or design docs

2. **Verbose acceptance criteria**
   - Keep each criterion to one sentence
   - Remove unnecessary words

3. **HTML formatting in table**
   - Notion doesn't handle HTML well when pasting
   - Use plain text only

4. **Skipping the iteration step**
   - Always present requirements in readable format first
   - Get confirmation before formatting as table

## Usage Tips

- Start by asking what feature or capability needs requirements
- Clarify Must Have vs Nice to Have priorities early
- Keep the total number of requirements manageable (5-10 is ideal)
- Remember: requirements are for understanding WHAT, not HOW
