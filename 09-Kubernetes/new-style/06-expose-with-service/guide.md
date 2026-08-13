# Topic 6: Expose It With a Service

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Give the Deployment a stable network identity with a Service.
2. Route traffic to Pods by label selector, not by Pod name.
3. Confirm live backends with `kubectl get endpoints`.
4. Reach the app via Service/`NodePort` (or Service `port-forward`).
5. Solve "replicas exist, but I still curl one Pod at a time."

## Goal
Give the Orbital Relay Deployment a stable network identity with a
Service, so you reach it without `port-forward` and without caring which
Pod answers. This folder is self-contained.

## Commands to Teach

```bash
# edit deployment.yaml: replace <ECR_REGISTRY>
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl get svc orbital-relay
kubectl get endpoints orbital-relay
```

- `service.yaml` — a `NodePort` Service selecting `app: orbital-relay`
  Pods, load-balancing across however many replicas exist.
- `get svc` — shows the stable `ClusterIP` and the `NodePort` on every
  node.
- `get endpoints` — the live list of Pod IPs the Service is actually
  routing to right now — this is how you prove the `selector` matched.

## Guided Steps

1. `cd` into this folder. Replace `<ECR_REGISTRY>` in `deployment.yaml`.
2. Apply the Deployment and Service in that order.
3. `kubectl get endpoints orbital-relay` — you should see 2 IP:port
   entries, one per Pod.
4. `kubectl get svc orbital-relay` — note the `NodePort` value
   (`30080` in this manifest).
5. Reach it: if your cluster exposes node IPs directly, `curl
   http://<node-ip>:30080`; otherwise `kubectl port-forward
   svc/orbital-relay 8080:80` and curl `localhost:8080` — notice you're
   forwarding to the *Service* now, not a specific Pod.
6. Delete a Pod and immediately re-check `kubectl get endpoints
   orbital-relay` — the Service updates on its own.

## Task

Confirm `kubectl get endpoints orbital-relay` lists exactly as many
addresses as your Deployment has replicas, and that traffic still succeeds
after you delete and let one Pod be replaced.

## Checkpoint

The Service's `selector` is `app: orbital-relay` — what happens to routing
if you edit the Deployment's Pod template labels but forget to update the
Service's selector to match?

## What's Next?

This is good, but we still need:

1. A way to ship a new site version without deleting the whole Deployment.
2. Zero-downtime updates so traffic keeps flowing during the change.
3. Visibility into whether the rollout finished successfully.
4. A fast undo if the new version is wrong.
5. Controlled releases — **Topic 7: Rolling Update and Rollback**.
