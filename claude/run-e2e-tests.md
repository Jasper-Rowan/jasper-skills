# Run E2E Tests

Run Playwright E2E tests and serve the HTML report afterward for trace inspection. Use when the user asks to run E2E tests, end-to-end tests, a specific test file, or Playwright tests.

## Step 1 — Run the tests

**All tests (from repo root):**
```bash
pnpm e2e
```

**All tests (from apps/web):**
```bash
npx playwright test --project=chromium --workers=1
```

**Specific test file:**
```bash
pnpm e2e apps/web/e2e-tests/features/core/file-upload/upload-workflow.spec.ts
```

**With no retries** (single clean trace for debugging):
```bash
pnpm e2e --retries=0
```

## Step 2 — Always serve the report after

**Regardless of pass or fail**, after the run completes:

```bash
cd apps/web && npx playwright show-report
```

Or from repo root:
```bash
pnpm --filter web e2e:report
```

## Step 3 — Tell the user

- The report should open in their browser automatically
- If not, check the terminal for the URL (typically `http://localhost:9323`)
- They can click any test to view its trace (timeline, actions, screenshots, network, console)
- For failed tests, the trace is the fastest way to see exactly what went wrong

## Notes

- Run the report **after** tests complete, not in parallel
- The report always shows the most recent run
- Use `--retries=0` when you want a single clean trace for a failing test
