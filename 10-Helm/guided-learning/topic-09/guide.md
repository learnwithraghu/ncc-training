# Topic 9: Package and Reuse a Chart

**Time:** 20 minutes

## Goal
Package a chart and reuse it with explicit value files.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-09
mkdir -p workspace && cd workspace
helm create package-lab
helm package package-lab
helm install package-lab ./package-lab-0.1.0.tgz -f ../assets/package-values.yaml
helm list
helm uninstall package-lab
```

## Guided Steps
1. Build a chart package artifact.
2. Install from the packaged chart instead of the folder.
3. Apply local value overrides.
4. Discuss how packaging helps promotion across environments.

## Checkpoint
What is the benefit of installing from a versioned .tgz chart package?
