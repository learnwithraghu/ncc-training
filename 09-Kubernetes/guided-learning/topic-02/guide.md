# Topic 2: Cluster Verification and kubectl Setup Checks

**Time:** 20 minutes

## Goal
Confirm your Kubernetes access and verify the environment is ready for all later labs.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-02
kubectl config get-contexts
kubectl config current-context
kubectl auth can-i create deployments
kubectl get nodes -o wide
bash assets/verify-cluster.sh
```

## Guided Steps
1. Check your active kubectl context.
2. Verify required permissions for deployment operations.
3. Run the automated cluster verification script.
4. Review output and resolve any failed checks before continuing.

## Checkpoint
Which command tells you if your current user can create deployments?
