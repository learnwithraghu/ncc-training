# Topic 2: Deployment and Scaling

**Time:** ~20 minutes

## What You'll Learn

1. Replace a bare Pod with a Deployment (Deployment → ReplicaSet → Pods).
2. Scale replicas and watch a deleted Pod come back.

## Goal

Run two copies of Orbital Relay 1.0, scale to four, then delete one Pod
and see Kubernetes replace it.

Work in the `orbital-relay` namespace from Topic 1. If the old Pod is
still there: `kubectl delete pod orbital-relay`.

## Commands

```bash
kubectl apply -f deployment.yaml
kubectl get deployments,replicasets,pods
kubectl scale deployment/orbital-relay --replicas=4
kubectl delete pod <one-pod-name>
```

- `deployment.yaml` — desired count is 2, image is `:1.0`.
- `get deployments,replicasets,pods` — ownership chain on one screen.
- `scale` — change the count without editing YAML.
- deleting a Pod — the ReplicaSet creates a replacement.

## Guided Steps

1. `cd` into this folder and apply:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/02-deployment-and-scaling
kubectl apply -f deployment.yaml
kubectl get deployments,replicasets,pods
```

You should see 2 Pods with generated names, not `orbital-relay`.

2. Scale up:

```bash
kubectl scale deployment/orbital-relay --replicas=4
kubectl get pods -l app=orbital-relay
```

3. Delete one Pod by name, then `kubectl get pods` again — a replacement
   should already be starting.

## Task

Scale to 4 replicas, delete one Pod, and confirm the count returns to 4
on its own.

## Checkpoint

What is the chain of objects between a Deployment and a running
container? Which object do you change to ship a new image?

## What's Next?

You still curl one Pod at a time. Next we add a Service so traffic hits
a stable name and spreads across replicas. **Topic 3: Expose with a Service.**
