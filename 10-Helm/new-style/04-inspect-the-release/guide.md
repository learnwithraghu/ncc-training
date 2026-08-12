# Topic 4: Inspect the Release

**Time:** ~15 minutes

## What You'll Learn (and Solve)

1. List releases with `helm list`.
2. Read release status with `helm status`.
3. See applied values with `helm get values`.
4. Dump rendered manifests with `helm get manifest`.
5. Solve "Helm installed something — how do I see what it owns?"

## Goal
Inspect the running `signal-forge` release and open the Jenkins UI.

If the release is missing, install it first with this folder's `values-lab.yaml`.

## Commands to Teach

```bash
cd ~/ncc-training/10-Helm/new-style/04-inspect-the-release
helm list -n signal-forge
helm status signal-forge -n signal-forge
helm get values signal-forge -n signal-forge
helm get manifest signal-forge -n signal-forge | head -n 60
kubectl get pods,svc -n signal-forge
```

- `helm list` — releases in the namespace.
- `helm status` — notes, last deploy time, resources summary.
- `helm get values` — overrides you passed (use `-a` for all computed values).
- `helm get manifest` — the YAML Helm applied for this revision.

## Guided Steps

1. If needed, install from this folder:

```bash
cd ~/ncc-training/10-Helm/new-style/04-inspect-the-release
helm repo add jenkins https://charts.jenkins.io 2>/dev/null || true
helm repo update
kubectl create namespace signal-forge --dry-run=client -o yaml | kubectl apply -f -
helm status signal-forge -n signal-forge 2>/dev/null || \
  helm install signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
```

2. Inspect with Helm:

```bash
helm list -n signal-forge
helm status signal-forge -n signal-forge
helm get values signal-forge -n signal-forge
```

3. Cross-check with kubectl:

```bash
kubectl get pods,svc -n signal-forge
```

4. Open Jenkins:

- If nodes are reachable: `http://<node-ip>:32080`
- Otherwise: `kubectl port-forward -n signal-forge svc/signal-forge-jenkins 8080:8080`
  then open `http://127.0.0.1:8080`

Login: **admin** / **Passw0rd** (from `values-lab.yaml`).

## Task

Show `helm status` for `signal-forge` and log into the Jenkins UI once.

## Checkpoint

When would you use `helm get manifest` instead of `kubectl get ... -o yaml`?

## What's Next?
This is good, but we still need:

1. A way to change settings after the first install.
2. Overrides via a second values file.
3. One-off overrides with `--set` for tiny experiments.
4. Proof the Service/NodePort actually changed.
5. Values overrides — **Topic 5: Override Values**.
