# Topic 5: Values and Template Fundamentals

**Time:** 20 minutes

## Goal
Render templates and understand how values are injected into manifests.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-05
mkdir -p workspace && cd workspace
helm create values-lab
helm template values-lab ./values-lab
helm template values-lab ./values-lab --set replicaCount=3 --set service.type=NodePort
```

## Guided Steps
1. Generate chart manifests with helm template.
2. Compare default output with --set overrides.
3. Find where values appear in rendered YAML.
4. Discuss trade-offs between --set and values files.

## Checkpoint
When would you prefer a values file over long --set flags?
