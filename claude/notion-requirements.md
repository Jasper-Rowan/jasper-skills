# Notion Requirements

Create user-focused requirements formatted for Notion databases. Use when the user wants to document requirements, create a requirements table for Notion, or needs help formatting requirements.

## Workflow

### 1. Present requirements in human-readable format first

Start by asking what feature or capability needs requirements if not already clear. Then present them like this — **never skip straight to the table**:

```
## Must Have Requirements

**REQ-001: [Short Title]**
[1–3 sentences focusing on user behavior and outcomes, not technical implementation]

Acceptance Criteria:
- [Testable criterion 1]
- [Testable criterion 2]
- [Testable criterion 3]

## Nice to Have Requirements

**REQ-002: [Short Title]**
...
```

### 2. Iterate based on feedback

Wait for the user to confirm or request changes:
- Add/remove requirements
- Adjust priority (Must Have vs Nice to Have)
- Refine descriptions or acceptance criteria

Aim for 5–10 requirements total.

### 3. Format as Notion-ready markdown table

Once confirmed, output the table inside a code block so the user can copy it directly:

```markdown
| Requirement Description | Priority | Acceptance Criteria |
|------------------------|----------|---------------------|
| [Full description] | Must have | [Criterion 1]. [Criterion 2]. [Criterion 3]. |
| [Full description] | Nice to have | [Criterion 1]. [Criterion 2]. |
```

## Writing guidelines

**Focus on user behavior, not implementation:**
- ✅ "Users should be able to connect their personal calendar to use in AI chats"
- ❌ "Create MCPConnection model with user FK and encrypted token field"

**Acceptance criteria:**
- Each criterion is testable/verifiable in one sentence
- In the table, join all criteria into one paragraph separated by periods (no line breaks — Notion can't handle them)

**Priority levels:**
- **Must have** — core functionality required for MVP
- **Nice to have** — enhancements for future phases

## Notion formatting rules

1. **No HTML tags** — never use `<br>`, `<b>`, `<i>`, or any HTML
2. **Plain text only** — markdown syntax only
3. **Single paragraph for criteria in table** — join with periods, not newlines
4. **Proper table syntax** — `|` separators, header row with `---` dashes
