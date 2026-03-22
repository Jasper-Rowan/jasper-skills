---
name: duplo-vpn-staging
description: >-
  Connects to DuploCloud staging VPC via OpenVPN, then uses duploctl/kubectl for
  read-only checks. Duplo portal host is https://duplo.cloud.cypressai.co (same portal for
  staging and prod tenants; profile-9 VPN). Use when the user asks about Duplo VPN, duploctl,
  listing tenants, or kubectl after VPN. Profile path is under ~/Cypress/.vpn (never commit).
---

# Duplo VPN (staging) + Duploctl

## Duplo portal (Cypress)

**`profile-9.ovpn`** is used to reach the VPC; the **Duplo web UI and API** for Cypress staging **and** prod tenants use this host:

| Use | URL |
|-----|-----|
| **API / `DUPLO_HOST`** | `https://duplo.cloud.cypressai.co` (origin only — no path) |
| **Browser login** | [DuploCloud Portal login](https://duplo.cloud.cypressai.co/app/login?returnUrl=%2Fapp) |

For `duploctl`, always set:

```bash
export DUPLO_HOST="https://duplo.cloud.cypressai.co"
```

Switch **tenant / environment** inside the portal or via `duploctl --tenant …` / context — do not confuse host with prod vs staging; both are managed from this portal.

## Constraints

- **Non-prod / staging only** unless the user explicitly says otherwise.
- **Never** commit `*.ovpn`, tokens, or `DUPLO_TOKEN`. The work profile lives under `~/Cypress/.vpn/` with `.gitignore` on secrets.
- OpenVPN on macOS usually needs **elevated privileges** for TUN (`sudo`) or use **OpenVPN Connect** GUI with the same profile.

## Long-term VPN profile location

| Item | Path |
|------|------|
| Duplo OpenVPN profile | `~/Cypress/.vpn/profile-9.ovpn` |
| Ignore rules | `~/Cypress/.vpn/.gitignore` |

After moving the file, re-import in **OpenVPN Connect** if the app still points at `Downloads/`.

## OpenVPN CLI (Homebrew)

Binary (Apple Silicon typical):

`/opt/homebrew/sbin/openvpn`

Install (once): `brew install openvpn`

**Foreground (see logs):**

```bash
sudo /opt/homebrew/sbin/openvpn --config "$HOME/Cypress/.vpn/profile-9.ovpn"
```

Use a dedicated terminal; stop with Ctrl+C.

**Verify tunnel is up (examples):**

```bash
ifconfig | grep -E "utun|tun"
ping -c 2 <private-ip-or-dns-inside-vpc>   # only if you know an internal host
```

## Duploctl (tenant list, read-only)

Already available via: `brew install duplocloud/tap/duploctl` → `duploctl` / `duploctl --version`.

**First-time auth (interactive, opens browser)** — use a **resource command** so the client actually completes OAuth and writes `~/.duplo/config` (a bare `duploctl --interactive` may only print settings):

```bash
export DUPLO_HOST="https://duplo.cloud.cypressai.co"
duploctl tenant list --admin --interactive -o yaml
```

Or set `DUPLO_TOKEN` from the Duplo portal (short-lived); **do not** paste tokens into chat or repos.

**List tenants (admin API, read-only):**

```bash
duploctl tenant list --admin -o yaml
# or
duploctl tenant list --admin -q "[].AccountName" -o string
```

Requires VPN only if the portal/API is restricted to the VPC; many portals are public HTTPS—follow org policy.

## kubectl via Duplo JIT (recommended)

Duploctl can **merge a context into `~/.kube/config`** using exec credentials ([JIT docs](https://cli.duplocloud.com/Jit/)). **Turn VPN on first** so the cluster API endpoint is reachable if it is private.

**1. Duplo API token (once per session or cached after interactive login)**

```bash
export DUPLO_HOST="https://duplo.cloud.cypressai.co"
duploctl tenant list --admin --interactive -o yaml   # complete browser login
```

**2. List plans** (pick the **staging / dev** plan name — not prod unless intended)

```bash
duploctl plan list --admin -o yaml
```

**3. Install kubectl context** (replace `PLAN_NAME`)

```bash
duploctl jit update_kubeconfig --plan PLAN_NAME --admin --interactive
```

This adds a `users[].user.exec` entry that runs `duploctl jit k8s` for auth ([`update_kubeconfig`](https://cli.duplocloud.com/Jit/)).

**4. Verify**

```bash
kubectl config get-contexts
kubectl get ns
```

**5. Read-only logs (example)**

```bash
kubectl logs deploy/<service> -n <namespace> --tail=200
```

**Tenant-scoped (non-admin)** users: set `--tenant <name>` on `duploctl` per Duplo docs instead of `--admin`; omit `--plan` or use the tenant flow your admin documents.

## Kubernetes (manual kubeconfig)

If Duplo UI offers **Download kubeconfig** for a tenant, merge it and use the same `kubectl` commands as above.

## Agent workflow checklist

1. Confirm user wants **staging**, not prod.
2. Prefer **OpenVPN Connect** if `sudo openvpn` is unavailable in the agent environment.
3. Use profile **`$HOME/Cypress/.vpn/profile-9.ovpn`**.
4. Set **`DUPLO_HOST`**, run **`duploctl tenant list --admin --interactive`** to cache a token, then **`duploctl plan list --admin`** and **`duploctl jit update_kubeconfig --plan <staging> --admin --interactive`** for kubectl.
5. Never store or echo secrets in project files or transcripts.

## If the agent cannot complete VPN connect

Sandboxed or non-interactive sessions may block `sudo` or TUN. In that case, tell the user to connect VPN locally, then re-run `duploctl` / `kubectl` in their terminal and paste **redacted** output.
