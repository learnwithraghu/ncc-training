# Topic 8: Upgrade, Rollback, and Value Overrides

**Time:** 20 minutes

## Goal
Practice Helm release changes safely using upgrades, history, and rollback.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-08
mkdir -p workspace && cd workspace
helm create lifecycle-lab
helm install lifecycle-lab ./lifecycle-lab -f ../assets/values-dev.yaml
helm upgrade lifecycle-lab ./lifecycle-lab -f ../assets/values-prod.yaml
helm history lifecycle-lab
helm rollback lifecycle-lab 1
helm uninstall lifecycle-lab
```

## Guided Steps
1. Install chart with development values.
2. Upgrade same release with production values.
3. Inspect revision history.
4. Roll back to the previous version and clean up.

## Checkpoint
Why is rollback a core safety feature in Helm workflows?
