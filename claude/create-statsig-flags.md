# Create Statsig Feature Flags

Create Statsig feature gates using the Siggy CLI and verify configuration. Use when the user wants to create a Statsig gate, add a feature flag, or confirm a flag is configured correctly.

## Prerequisites

- **Siggy installed:** `npm install -g @statsig/siggy`
- **Siggy configured:** Run `siggy config` — if keys are missing, the user must run:
  - `siggy config -c <console-api-key>` (Statsig Console → Settings → Keys & Environments)
  - `siggy config -k <client-api-key>`

## Gate naming convention

Use kebab-case with `enable-` prefix: `enable-fathom-skill`, `enable-new-dashboard`.

In code, the gate name becomes a constant:
```python
ENABLE_FATHOM_SKILL = "enable-fathom-skill"
```
Checked via `has_statsig_switch(ENABLE_FATHOM_SKILL)`.

## Workflow

### 1. Clarify requirements

Ask or infer:
- **Gate name** — kebab-case
- **Environments** — development, staging, production, or all
- **Rollout %** — usually 100 for full rollout in chosen environment(s)

### 2. Create the gate

```bash
siggy gates create <gate-name>
```

### 3. Update with rules

Build the rules JSON and apply it:

```bash
siggy gates update <gate-name> '<rules-json>'
```

**Development only (100%):**
```json
{"rules": [{"name": "development only", "passPercentage": 100, "conditions": [], "environments": ["development"]}]}
```

**Staging only (100%):**
```json
{"rules": [{"name": "staging only", "passPercentage": 100, "conditions": [], "environments": ["staging"]}]}
```

**Production only (100%):**
```json
{"rules": [{"name": "production only", "passPercentage": 100, "conditions": [], "environments": ["production"]}]}
```

**All environments (100%):**
```json
{"rules": [{"name": "everyone", "passPercentage": 100, "conditions": []}]}
```

**Partial rollout (e.g. 25% in production):**
```json
{"rules": [{"name": "25% rollout", "passPercentage": 25, "conditions": [], "environments": ["production"]}]}
```

### 4. Verify

```bash
siggy gates get <gate-name>
```

Confirm: `isEnabled` is true, `rules` matches the request (environments and passPercentage correct).

Report back: gate name, environments, pass percentage, and whether it matches what the user asked for.

### 5. Check if a gate exists (optional)

```bash
siggy gates list
siggy gates get <gate-name>
```

## Environment reference

| Environment | Use case |
|-------------|----------|
| development | Local dev |
| staging | Pre-production |
| production | Live |
