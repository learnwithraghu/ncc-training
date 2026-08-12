# Topic 3: Deployment and Scaling

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Replace a bare Pod with a Deployment that owns a ReplicaSet.
2. See the ownership chain: Deployment → ReplicaSet → Pods.
3. Scale replicas up without editing YAML by hand.
4. Prove self-healing by deleting a Pod and watching it get replaced.
5. Solve "my Pod died and nothing brought it back."

## Goal
Replace the bare Pod from Topic 2 with a Deployment, so a crashed or
deleted Pod gets replaced automatically, and scale it up. This folder is
self-contained.

## Commands to Teach
```bash
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl get deployments,replicasets,pods
kubectl scale deployment/orbital-relay --replicas=4
kubectl delete pod <one-pod-name>
```
- `deployment.yaml` — declares "2 replicas of this Pod template," and owns
  a ReplicaSet that owns the Pods, instead of you managing Pods directly.
- `get deployments,replicasets,pods` — see the ownership chain:
  Deployment → ReplicaSet → Pods.
- `scale --replicas=4` — change desired count without editing YAML.
- deleting a single Pod — proves the ReplicaSet notices and replaces it.

## Guided Steps
1. `cd` into this folder.
2. Apply the ConfigMap and the Deployment.
3. `kubectl get pods -l app=orbital-relay` - you should see 2 Pods with
   generated name suffixes, not `orbital-relay` like Topic 2.
4. `kubectl get rs` - find the ReplicaSet, then `kubectl describe rs
   <name>` and look at `Controlled By`.
5. Scale up: `kubectl scale deployment/orbital-relay --replicas=4`, then
   `kubectl get pods -l app=orbital-relay` again.
6. Delete one Pod by name and immediately re-run `kubectl get pods` - a
   replacement should already be starting.

## Task
Scale the Deployment to 4 replicas, delete one Pod, and confirm the
Deployment brings the count back to 4 on its own.

## Checkpoint
What's the actual chain of objects between `Deployment` and a running
container, and which one would you edit directly to change the container
image?

## What's Next?
This is good, but we still need:

1. A stable way to reach the app without picking one Pod name each time.
2. Load balancing across all replicas, not a single `port-forward` target.
3. A network identity that survives Pod restarts and new Pod IPs.
4. Endpoints that update automatically when Pods come and go.
5. Cluster networking for the Deployment — **Topic 4: Expose with a Service**.
