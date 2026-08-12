# Topic 5: Override Values

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Change a live release with `helm upgrade -f`.
2. Apply a one-line override with `--set`.
3. Compare lab values vs upgrade values (NodePort / resources).
4. Confirm the Service NodePort changed in the cluster.
5. Solve "the chart defaults are wrong for my classroom — how do I customize?"

## Goal
Customize Signal Forge without forking the Jenkins chart — only values files
and `--set`.

This folder has `values-lab.yaml` and `values-upgrade.yaml`.

## Commands to Teach

```bash
cd ~/ncc-training/10-Helm/new-style/05-override-values
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-upgrade.yaml
helm get values signal-forge -n signal-forge
kubectl get svc -n signal-forge
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml \
  --set controller.resources.requests.memory=600Mi
```

- `-f values-upgrade.yaml` — merges your overrides on top of chart defaults.
- `--set` — quick single-key override (great for demos, easy to lose track of).
- Lab upgrade file moves NodePort from **32080** → **32081**.

## Guided Steps

1. Ensure the release exists (install with lab values if needed):

```bash
cd ~/ncc-training/10-Helm/new-style/05-override-values
helm status signal-forge -n signal-forge 2>/dev/null || \
  helm install signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
kubectl get svc -n signal-forge
```

2. Diff the two values files:

```bash
diff -u values-lab.yaml values-upgrade.yaml || true
```

3. Upgrade with the second file:

```bash
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-upgrade.yaml
kubectl get svc -n signal-forge
helm get values signal-forge -n signal-forge
```

NodePort should now be **32081**.

4. Try a `--set` tweak (then restore lab values if you want a clean baseline):

```bash
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml \
  --set controller.resources.requests.memory=600Mi
helm get values signal-forge -n signal-forge
```

## Task

Upgrade so the Jenkins Service NodePort becomes `32081`, then show
`helm get values`.

## Checkpoint

When should you prefer a values file over `--set`?

## What's Next?
This is good, but we still need:

1. A deliberate upgrade path students can repeat safely.
2. Release history so we know which revision is live.
3. A rollback when an upgrade is wrong.
4. Proof Helm keeps previous revisions for us.
5. Upgrade and rollback — **Topic 6: Upgrade and Rollback**.
