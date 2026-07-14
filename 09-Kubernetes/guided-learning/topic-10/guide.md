# Topic 10: Rolling Updates and Rollback

**Time:** 20 minutes

## Goal
Perform controlled image updates and rollback when needed.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-10
kubectl apply -f assets/nginx-deployment.yaml
kubectl set image deployment/nginx-deployment nginx=nginx:1.21
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment
bash assets/rollout-demo.sh
```

## Guided Steps
1. Trigger a deployment image update.
2. Watch rollout status until complete.
3. Inspect revision history.
4. Roll back to the previous stable revision.

## Checkpoint
Which command confirms rollout completion before traffic relies on the new version?
