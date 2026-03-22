---
name: pr-review
description: >
  Performs a structured PR review including drafting the PR description,
  validating new features are behind feature flags, ensuring E2E tests pass,
  and offering to create the PR. Use when the user asks for a PR review,
  wants to prepare a PR for merge, or asks to review changes before merging.
---

# PR Review Workflow

When the user asks for a PR review or to prepare a PR for merge, follow this workflow in order.

## 1. Draft the PR Description

Create a complete PR description using the project's pull request template. If the repo has `.github/pull_request_template.md`, use it. Otherwise use a standard structure:

- **Files changed** — Table of each file with one sentence explaining why
- **Description** — Summary, motivation, and what it does
- **Links** — Jira ticket and/or Statsig flag
- **Tests** — What was tested and how to reproduce
- **How will you know this worked?** — Verification steps
- **Rollout Plan** — Feature flag rollout (switch, percentage)
- **Monitoring / Dashboards** — If relevant
- **Checklist** — Standard items (style, self-review, comments, docs, tests)

Fill in every section based on the actual changes. Run `git diff main --stat` and `git log main..HEAD --oneline` to understand scope.

## 2. Validate Feature Flags for New Features

**Rule:** New features must be behind feature flags so they can be rolled back. Bug fixes are exempt.

For each change, determine if it introduces a **new feature** (user-facing capability, new skill, new integration) vs a **bug fix** (fixing broken behavior, correcting logic).

**If the PR adds new features:**

1. Search for feature flag usage: `ENABLE_`, `enable-`, `has_statsig_switch`, `has_statsig_feature`
2. Check that the new feature is gated:
   - Constant in `constants.py` (or equivalent)
   - Gate in loader/catalog (visibility) and/or access checks (load time)
   - Statsig flag created and documented in the PR
3. **Flag any new feature that is NOT behind a feature flag** — call this out as a blocker before merge.

**Example pattern (background-tasks skills):**
- `apps/skills/constants.py` — `ENABLE_FATHOM_SKILL = "enable-fathom-skill"`
- `apps/skills/loader.py` — Filter skill from catalog when flag off
- `apps/skills/gating.py` — `check_skill_access` re-checks flag at load time

If you find new features without flags, list them clearly and ask the user to add gating before merge.

## 3. Ensure E2E Tests Have Run and Pass

1. **Check if E2E tests exist** — Look for `playwright`, `e2e`, `cypress`, or similar in package.json / config.
2. **Run E2E tests** — Use the `run-e2e-tests` skill if Playwright E2E tests exist. From repo root: `pnpm e2e` or `npx playwright test --project=chromium --workers=1`. Serve the report afterward.
3. **Confirm results** — If tests fail, the PR is not ready. Report failures and suggest fixes. If tests pass, note this in the review.

If the repo has no E2E tests, note that and skip this step (no E2E tests to run).

## 4. Senior Developer Code Review

Review every changed file as a senior developer would. Run `git diff main` to read the actual code changes (not just the stat summary). For each file, evaluate:

- **Correctness** — Does the logic do what it claims? Are there off-by-one errors, race conditions, or unhandled edge cases?
- **Best practices** — Does it follow the project's conventions (naming, file structure, patterns)? Are there anti-patterns like magic strings, deeply nested logic, or duplicated code?
- **Error handling** — Are errors caught and handled appropriately? Could a failure here cascade or leave the app in a bad state?
- **Security** — Are there hardcoded secrets, missing input validation, or XSS/injection risks?
- **Performance** — Are there unnecessary re-renders, N+1 queries, expensive operations in loops, or missing memoization?
- **Readability** — Is the code clear without excessive comments? Would a new team member understand it?
- **Type safety** — Are `any` types used where a proper type would be better? Are function signatures precise?

Present findings as a list grouped by severity:
1. **Blockers** — Must fix before merge (bugs, security issues, broken logic)
2. **Recommendations** — Should fix; improves quality (anti-patterns, missing error handling, readability)
3. **Nits** — Optional; style preferences or minor improvements

If there are no issues, say so explicitly. Do not fabricate issues.

## 5. Ask to Create the PR

After completing steps 1–4, present the PR description and review summary to the user. Then ask:

> Would you like me to create the PR with this description to merge [current-branch] into main?

If yes, use `gh pr create` (or equivalent) with the drafted description. If the user prefers to create it manually, provide the full PR body for them to paste.

---

## Summary Checklist

Before considering the PR ready:

- [ ] PR description drafted and complete (all template sections filled)
- [ ] New features are behind feature flags (or PR is bug-fix only)
- [ ] E2E tests have been run and pass (or N/A if no E2E tests)
- [ ] Senior developer code review completed (blockers addressed)
- [ ] User asked whether to create the PR
