# Topic 1: Kubernetes Mindset and Architecture Essentials

**Time:** 20 minutes

## Goal
Understand core Kubernetes architecture and how control plane and worker nodes coordinate workloads.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes
cat 00-OVERVIEW.md
kubectl version --client
kubectl cluster-info
kubectl get nodes
```

## Guided Steps
1. Read the architecture section in 00-OVERVIEW.md.
2. Identify API server, scheduler, controller manager, kubelet, and kube-proxy roles.
3. Run cluster checks to connect concepts to a live cluster.
4. Explain how desired state is applied in Kubernetes.

## Checkpoint
In your own words, what is the difference between the control plane and worker nodes?
