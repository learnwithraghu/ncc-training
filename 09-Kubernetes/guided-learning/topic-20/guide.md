# Topic 20: Health Checks, Resource Limits, and Mini Workflow

**Time:** 20 minutes

## Goal
Validate production-style safeguards with probes, limits, and a quick end-to-end workflow.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-20
kubectl apply -f assets/health-checks-pod.yaml
kubectl apply -f assets/resource-limits-pod.yaml
kubectl get pods
kubectl describe pod health-check-pod
kubectl describe pod resource-demo
bash assets/monitoring-setup.sh
kubectl top nodes
kubectl top pods
```

## Guided Steps
1. Deploy pods with health probes and limits.
2. Inspect liveness/readiness and resource sections in describe output.
3. Run the monitoring helper script.
4. Perform a mini review from deployment state to runtime metrics.

## Checkpoint
How do probes and limits work together to improve reliability under load?
