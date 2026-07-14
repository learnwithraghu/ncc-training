# Topic 1: Helm Mindset and Environment Checks

**Time:** 20 minutes

## Goal
Understand Helm's role in Kubernetes and verify your local tooling is ready.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-01
helm version
kubectl version --client
kubectl cluster-info
helm env
```

## Guided Steps
1. Verify Helm and kubectl are available.
2. Confirm Kubernetes cluster access.
3. Review Helm environment paths and defaults.
4. Explain why Helm adds value over raw manifest management.

## Checkpoint
What is the difference between a Helm chart and a Helm release?
