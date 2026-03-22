# Duplo VPN (Staging) + kubectl

Connect to the CypressAI DuploCloud staging VPC via OpenVPN, then use duploctl/kubectl to inspect or debug services. Use when asked about Duplo VPN, duploctl, listing tenants, kubectl, or debugging anything inside the VPC.

## Key details

| Item | Value |
|------|-------|
| Duplo portal / `DUPLO_HOST` | `https://duplo.cloud.cypressai.co` (origin only, no path) |
| Browser login | `https://duplo.cloud.cypressai.co/app/login` |
| VPN profile | `~/Cypress/.vpn/profile-9.ovpn` |
| OpenVPN binary (Apple Silicon) | `/opt/homebrew/sbin/openvpn` |

## Constraints

- **Staging/non-prod only** unless the user explicitly says otherwise.
- **Never** commit `*.ovpn`, tokens, or `DUPLO_TOKEN` to any repo.
- Never echo or log secrets in transcripts.

## Step 1 — Connect VPN

```bash
sudo /opt/homebrew/sbin/openvpn --config "$HOME/Cypress/.vpn/profile-9.ovpn"
```

Run in a dedicated terminal (foreground). Stop with Ctrl+C. Verify tunnel:

```bash
ifconfig | grep -E "utun|tun"
```

If `sudo` is unavailable, ask the user to connect via the **OpenVPN Connect** GUI using the same profile and confirm when connected.

## Step 2 — Authenticate duploctl

```bash
export DUPLO_HOST="https://duplo.cloud.cypressai.co"
duploctl tenant list --admin --interactive -o yaml
```

This opens a browser for OAuth and caches credentials to `~/.duplo/config`. Only needed once per session.

## Step 3 — Set up kubectl context

```bash
# List plans (pick the staging/dev plan name)
duploctl plan list --admin -o yaml

# Install kubectl context (replace PLAN_NAME)
duploctl jit update_kubeconfig --plan PLAN_NAME --admin --interactive

# Verify
kubectl config get-contexts
kubectl get ns
```

## Step 4 — Inspect / debug

```bash
# View logs
kubectl logs deploy/<service> -n <namespace> --tail=200

# Get pods
kubectl get pods -n <namespace>

# Describe a pod
kubectl describe pod <pod-name> -n <namespace>

# Exec into a pod
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh
```

## Agent checklist

1. Confirm user wants **staging**, not prod.
2. VPN must be connected before kubectl can reach private cluster endpoints.
3. Set `DUPLO_HOST`, run `duploctl tenant list --admin --interactive` to cache token.
4. Run `duploctl plan list --admin` to find the right plan name.
5. Run `duploctl jit update_kubeconfig --plan <staging-plan> --admin --interactive`.
6. Then use `kubectl` as normal.

If the agent environment blocks `sudo` or TUN, instruct the user to connect VPN manually and confirm, then proceed with duploctl/kubectl commands.
