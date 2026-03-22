# PR Review

Perform a structured PR review: draft the description, validate feature flags, run E2E tests, do a senior dev code review, then offer to create the PR. Use when the user asks for a PR review or wants to prepare changes for merge.

## Step 1 — Draft the PR description

Run these first to understand scope:
```bash
git diff main --stat
git log main..HEAD --oneline
```

Check for a PR template at `.github/pull_request_template.md`. Use it if it exists. Otherwise use this structure:

- **Files changed** — table of each file with one sentence explaining why
- **Description** — summary, motivation, what it does
- **Links** — Jira ticket and/or Statsig flag
- **Tests** — what was tested and how to reproduce
- **How will you know this worked?** — verification steps
- **Rollout Plan** — feature flag switch, rollout percentage
- **Monitoring / Dashboards** — if relevant
- **Checklist** — style, self-review, comments, docs, tests

Fill every section from the actual changes.

## Step 2 — Validate feature flags for new features

**Rule:** New features must be behind feature flags. Bug fixes are exempt.

For each change, determine: new user-facing capability (needs flag) vs broken behavior fix (no flag needed).

**If new features are present:**
```bash
grep -r "ENABLE_\|enable-\|has_statsig_switch\|has_statsig_feature" .
```

Check that each new feature is gated:
- Constant in `constants.py` (e.g. `ENABLE_FATHOM_SKILL = "enable-fathom-skill"`)
- Gate in loader/catalog (visibility) and/or access checks (load time)
- Statsig flag created and noted in PR

**If a new feature is NOT behind a flag, call it out as a blocker before merge.**

## Step 3 — Run E2E tests

Check if E2E tests exist (look for `playwright`, `e2e`, `cypress` in package.json / config).

If Playwright tests exist, run them (use `/run-e2e-tests` skill):
```bash
pnpm e2e                          # from repo root
# or
npx playwright test --project=chromium --workers=1   # from apps/web
```

Always serve the report after:
```bash
cd apps/web && npx playwright show-report
```

If tests fail, the PR is not ready — report failures. If no E2E tests exist, note it and skip.

## Step 4 — Senior developer code review

Run `git diff main` to read the actual code (not just the stat). For each changed file evaluate:

- **Correctness** — Does the logic do what it claims? Edge cases, off-by-ones, race conditions?
- **Best practices** — Project conventions followed? Magic strings, deep nesting, duplication?
- **Error handling** — Errors caught appropriately? Could failures cascade?
- **Security** — Hardcoded secrets, missing input validation, XSS/injection risks?
- **Performance** — Unnecessary re-renders, N+1 queries, expensive ops in loops, missing memoization?
- **Readability** — Clear without excessive comments? Understandable to a new team member?
- **Type safety** — `any` used where a real type fits? Precise function signatures?

Group findings by severity:
1. **Blockers** — must fix before merge (bugs, security, broken logic)
2. **Recommendations** — should fix (anti-patterns, missing error handling)
3. **Nits** — optional (style, minor improvements)

If there are no issues, say so explicitly. Do not fabricate issues.

## Step 5 — Offer to create the PR

Present the drafted description and review summary, then ask:

> "Would you like me to create the PR with this description to merge [current-branch] into main?"

If yes:
```bash
gh pr create --title "..." --body "$(cat <<'EOF'
[full pr body]
EOF
)"
```

If no, provide the full PR body for them to paste manually.

## Checklist before marking ready

- [ ] PR description complete (all template sections filled)
- [ ] New features behind feature flags (or bug-fix only)
- [ ] E2E tests run and pass (or N/A)
- [ ] Code review done, blockers addressed
- [ ] User asked whether to create the PR
