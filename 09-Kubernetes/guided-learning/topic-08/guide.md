# Topic 8: Deployment Fundamentals and ReplicaSets

**Time:** 20 minutes

## Goal
Deploy applications using Deployment controllers and inspect ReplicaSets.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-08
kubectl apply -f assets/nginx-deployment.yaml
kubectl get deployments
kubectl get replicasets
kubectl get pods -l app=nginx
kubectl describe deployment nginx-deployment
```

## Guided Steps
1. Apply a deployment manifest.
2. Observe deployment, replicaset, and pod relationship.
3. Inspect labels and selectors used for pod management.
4. Review deployment strategy fields from describe output.

## Checkpoint
What problem does a Deployment solve that a standalone Pod does not?
