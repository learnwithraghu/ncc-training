# Topic 2: Chart and Repository Discovery

**Time:** 20 minutes

## Goal
Find, add, and inspect chart repositories before installation.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-02
helm search hub nginx
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo bitnami/nginx
helm show chart bitnami/nginx
```

## Guided Steps
1. Search public chart hub results.
2. Add and update the Bitnami repository.
3. Search repository-local chart entries.
4. Inspect chart metadata.

## Checkpoint
Why should you inspect chart metadata before installing a chart?
