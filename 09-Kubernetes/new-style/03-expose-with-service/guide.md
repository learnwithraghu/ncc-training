# Topic 3: Expose with a Service

**Time:** ~20 minutes

## What You'll Learn

1. Give the Deployment a stable name with a Service.
2. See that the Service routes by label, and endpoints update when Pods change.

## Goal

Reach Orbital Relay without picking a Pod name. The Service selects
`app: orbital-relay` and load-balances across replicas.

## Commands

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get svc orbital-relay
kubectl get endpoints orbital-relay
kubectl port-forward svc/orbital-relay 8080:80
```

- `service.yaml` — NodePort Service, selector `app: orbital-relay`.
- `get endpoints` — live Pod IPs the Service is sending traffic to.
- `port-forward svc/...` — you forward to the Service, not one Pod.

## Guided Steps

1. `cd` into this folder and apply both files:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/03-expose-with-service
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

2. `kubectl get endpoints orbital-relay` — two IP:port rows, one per Pod.
3. `kubectl get svc orbital-relay` — note ClusterIP and NodePort `30080`.
4. Reach it: `kubectl port-forward svc/orbital-relay 8080:80` then
   `curl -s http://localhost:8080 | grep -o "Ground link v1"`.
   If node IPs are reachable, you can also try `http://<node-ip>:30080`.
5. Delete one Pod. `kubectl get endpoints orbital-relay` updates on its
   own.

## Task

`kubectl get endpoints orbital-relay` lists one address per replica, and
curl still works after a Pod is replaced.

## Checkpoint

The Service selector is `app: orbital-relay`. What happens if the
Deployment's Pod labels change and the Service selector does not?

## What's Next?

The site is still 1.0. Next we ship 2.0 with a rolling update, then
undo it — no downtime, two different UIs. **Topic 4: Rolling Update and Rollback.**
