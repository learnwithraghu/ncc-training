# Topic 9: Deployment Scaling and Replica Management

**Time:** 20 minutes

## Goal
Scale workloads safely and validate replica behavior.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-09
kubectl apply -f assets/nginx-deployment.yaml
kubectl scale deployment nginx-deployment --replicas=5
kubectl get deployment nginx-deployment
kubectl get pods -l app=nginx -w
bash assets/scaling-demo.sh
kubectl scale deployment nginx-deployment --replicas=2
```

## Guided Steps
1. Scale deployment up and verify replica count.
2. Watch pods being created and scheduled.
3. Run scaling demo script and inspect outcomes.
4. Scale down and confirm old pods terminate cleanly.

## Checkpoint
How do you confirm the deployment and pod replica counts are in sync?
