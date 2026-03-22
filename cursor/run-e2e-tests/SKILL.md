---
name: run-e2e-tests
description: Runs Playwright E2E tests and always serves the HTML report afterward for trace inspection. Use when the user asks to run E2E tests, run end-to-end tests, run a specific test file, run the file upload test, or run playwright tests.
---

# Run E2E Tests with Report

When the user asks to run E2E tests (all tests, a specific test file, or an individual test), follow this workflow:

## 1. Run the tests

- **All tests**: `pnpm e2e` (from repo root) or `npx playwright test --project=chromium --workers=1` (from apps/web)
- **Specific test file**: `pnpm e2e apps/web/e2e-tests/features/core/file-upload/upload-workflow.spec.ts` or equivalent path
- **With no retries** (for a single clean trace): add `--retries=0`

Use the project's existing commands. From repo root: `pnpm e2e [path]`. From apps/web: `npx playwright test [path] --project=chromium --workers=1`.

## 2. Always run the report after tests complete

**Regardless of pass or fail**, after the test run finishes, run:

```bash
cd apps/web && npx playwright show-report
```

Or from repo root:

```bash
pnpm --filter web e2e:report
```

This serves the HTML report so the user can:
- See test results and failures
- Click into traces for each test (especially failed ones)
- Inspect the trace viewer (timeline, actions, screenshots, network, console)

## 3. Tell the user the report is available

After starting the report server, tell the user:
- The report should open in their browser automatically
- If not, check the terminal for the URL (e.g. http://localhost:9323)
- They can click any test to view its trace

## Notes

- Run the report command **after** tests complete, not in parallel
- The report shows the most recent test run
- For a single failed test with a clean trace, use `--retries=0` when running tests
