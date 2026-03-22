---
name: create-statsig-flags
description: >
  Creates Statsig feature flags using Siggy CLI and verifies configuration.
  Use when the user wants to create a Statsig gate, add a feature flag, set up
  a gate for development/staging/production, or confirm a flag is configured correctly.
---

# Create Statsig Feature Flags with Siggy

When the user asks to create a Statsig feature flag, gate, or wants to verify one exists, follow this workflow.

## Prerequisites

1. **Siggy installed:** `npm install -g @statsig/siggy`
2. **Siggy configured:** Run `siggy config` — if it reports missing keys, the user must run:
   - `siggy config -c <console-api-key>` (from Statsig Console → Settings → Keys & Environments)
   - `siggy config -k <client-api-key>` (use an all-environments key or environment-specific key)

## 1. Clarify Requirements

Ask or infer from the user:
- **Gate name** — kebab-case (e.g. `enable-fathom-skill`, `enable-new-feature`)
- **Environments** — development only, staging, production, or all
- **Rollout %** — usually 100 for full rollout in the chosen environment(s)

## 2. Create the Gate

```bash
siggy gates create <gate-name>
```

## 3. Update with Rules

Build the rules JSON based on the user's requirements.

**Development only (100%):**
```json
{
  "rules": [
    {
      "name": "development only",
      "passPercentage": 100,
      "conditions": [],
      "environments": ["development"]
    }
  ]
}
```

**Staging only (100%):**
```json
{
  "rules": [
    {
      "name": "staging only",
      "passPercentage": 100,
      "conditions": [],
      "environments": ["staging"]
    }
  ]
}
```

**Production only (100%):**
```json
{
  "rules": [
    {
      "name": "production only",
      "passPercentage": 100,
      "conditions": [],
      "environments": ["production"]
    }
  ]
}
```

**All environments (100%):** Omit `environments` or set to `null`:
```json
{
  "rules": [
    {
      "name": "everyone",
      "passPercentage": 100,
      "conditions": []
    }
  ]
}
```

**Partial rollout (e.g. 25%):** Set `passPercentage` and optionally add `environments`:
```json
{
  "rules": [
    {
      "name": "25% rollout",
      "passPercentage": 25,
      "conditions": [],
      "environments": ["production"]
    }
  ]
}
```

**Run update:**
```bash
siggy gates update <gate-name> '<rules-json>'
```

## 4. Verify Configuration

Use `siggy gates get` to confirm the gate was created and configured correctly:

```bash
siggy gates get <gate-name>
```

**Check:**
- `isEnabled` is true
- `rules` array contains the expected rule(s)
- `environments` on each rule matches what the user asked (development, staging, production)

**Summarize for the user:** Report gate name, environments, pass percentage, and whether it matches their request.

## 5. Optional: Check if Gate Exists

If the user asks whether a gate exists or what it's configured for:

```bash
siggy gates list
# or
siggy gates get <gate-name>
```

## Gate Naming Convention

Use kebab-case: `enable-<feature-name>`, e.g. `enable-fathom-skill`, `enable-new-dashboard`.

## Environment Reference

| Environment | Use case |
|-------------|----------|
| development | Local dev |
| staging | Pre-production |
| production | Live |

## Code Reference

When adding to code, the gate name typically becomes a constant:
```python
ENABLE_FATHOM_SKILL = "enable-fathom-skill"
```
And is checked via `has_statsig_switch(ENABLE_FATHOM_SKILL)`.
