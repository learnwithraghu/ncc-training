# Topic 5: Pod Lifecycle and Troubleshooting States

**Time:** 20 minutes

## Goal
Create pods and interpret status transitions for quick troubleshooting.

## Commands to Use
```bash
kubectl run nginx --image=nginx
kubectl get pods -w
kubectl describe pod nginx
kubectl logs nginx
kubectl delete pod nginx
kubectl apply -f assets/simple-pod.yaml
kubectl get pods
kubectl delete -f assets/simple-pod.yaml
```

## Guided Steps
1. Launch a pod imperatively to observe fast feedback.
2. Watch pod state transitions and inspect events.
3. Read logs and understand common statuses like Pending and Running.
4. Recreate the same concept with a YAML manifest.

## Checkpoint
Which two commands help you diagnose a pod that is not becoming Running?
