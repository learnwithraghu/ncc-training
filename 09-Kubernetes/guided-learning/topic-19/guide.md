# Topic 19: StatefulSets, Jobs, and CronJobs

**Time:** 20 minutes

## Goal
Run advanced workload controllers for stateful and batch processing use cases.

## Commands to Use
```bash
cd /workspaces/ncc-training/09-Kubernetes/guided-learning/topic-19
kubectl apply -f assets/statefulset-example.yaml
kubectl get statefulsets
kubectl get pods -l app=nginx
kubectl apply -f assets/job-example.yaml
kubectl get jobs
kubectl apply -f assets/cronjob-example.yaml
kubectl get cronjobs
kubectl delete -f assets/statefulset-example.yaml
kubectl delete -f assets/job-example.yaml
kubectl delete -f assets/cronjob-example.yaml
```

## Guided Steps
1. Deploy a StatefulSet and inspect stable pod identity.
2. Run a one-time batch job.
3. Create a scheduled CronJob.
4. Compare controller behavior for each workload type.

## Checkpoint
Which controller would you pick for a nightly report job and why?
