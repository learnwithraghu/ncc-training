# Topic 6: Upgrade and Rollback

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Upgrade Signal Forge with a second values file.
2. Read revision history with `helm history`.
3. Roll back to the previous revision with `helm rollback`.
4. Confirm cluster state matches the rolled-back values.
5. Solve "the new values broke access — how do I undo the release?"

## Goal
Practice the Helm release lifecycle: upgrade → history → rollback.

## Commands to Teach

```bash
cd ~/ncc-training/10-Helm/new-style/06-upgrade-and-rollback
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-upgrade.yaml
helm history signal-forge -n signal-forge
helm rollback signal-forge 1 -n signal-forge
kubectl get svc -n signal-forge
```

- `helm upgrade` — creates a new revision of the same release name.
- `helm history` — lists revisions and statuses.
- `helm rollback <release> <revision>` — restores an earlier revision.

## Guided Steps

1. Start from a known baseline:

```bash
cd ~/ncc-training/10-Helm/new-style/06-upgrade-and-rollback
helm status signal-forge -n signal-forge 2>/dev/null || \
  helm install signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-lab.yaml
kubectl get svc -n signal-forge
```

2. Upgrade to the alternate values (NodePort **32081**):

```bash
helm upgrade signal-forge jenkins/jenkins -n signal-forge -f values-upgrade.yaml
helm history signal-forge -n signal-forge
kubectl get svc -n signal-forge
```

3. Roll back to revision 1 (or the revision that had NodePort **32080**):

```bash
helm history signal-forge -n signal-forge
helm rollback signal-forge 1 -n signal-forge
helm history signal-forge -n signal-forge
kubectl get svc -n signal-forge
```

Confirm the Service NodePort is back to **32080**.

## Task

Upgrade to `values-upgrade.yaml`, show `helm history`, roll back, and prove
the NodePort returned to `32080`.

## Checkpoint

Does `helm rollback` delete the bad revision from history, or add a new
revision that restores the old config?

## What's Next?
This is good, but we still need:

1. A way to preview YAML **before** touching the cluster.
2. Dry-run installs/upgrades for safety reviews.
3. A lint check on values/chart packaging issues.
4. Confidence that rendered templates look sane in CI.
5. Template and dry-run — **Topic 7: Template and Dry-Run**.
