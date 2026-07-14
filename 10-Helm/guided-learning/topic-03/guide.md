# Topic 3: Release Lifecycle Basics

**Time:** 20 minutes

## Goal
Install and remove a Helm release while inspecting resulting Kubernetes resources.

## Commands to Use
```bash
cd /workspaces/ncc-training/10-Helm/guided-learning/topic-03
helm install topic3-nginx bitnami/nginx
helm list
kubectl get pods
kubectl get svc
helm status topic3-nginx
helm uninstall topic3-nginx
```

## Guided Steps
1. Install an nginx release from a repository chart.
2. Verify release state with Helm and kubectl.
3. Inspect release details.
4. Uninstall and confirm cleanup.

## Checkpoint
Which command shows detailed status for a specific release?
