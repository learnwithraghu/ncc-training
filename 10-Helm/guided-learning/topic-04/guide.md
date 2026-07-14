# Topic 4: Create Your First Chart

**Time:** 20 minutes

## Goal
Generate a starter chart and understand its default folder layout.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-04
mkdir -p workspace && cd workspace
helm create hello-helm
tree hello-helm
cat hello-helm/Chart.yaml
cat hello-helm/values.yaml
```

## Guided Steps
1. Scaffold a chart with helm create.
2. Inspect chart folders and template files.
3. Review chart metadata and defaults.
4. Explain where application customization belongs.

## Checkpoint
What are the roles of Chart.yaml and values.yaml in a Helm chart?
