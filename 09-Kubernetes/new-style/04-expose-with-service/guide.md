# Topic 4: Expose It With a Service

**Time:** ~20 minutes

## Goal
Give the Orbital Relay Deployment a stable network identity with a
Service, so you reach it without `port-forward` and without caring which
Pod answers. This folder is self-contained.

## Commands to Teach
```bash
kubectl apply -f configmap.yaml
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
  routing to right now - this is how you prove the `selector` matched.

## Guided Steps
1. `cd` into this folder.
2. Apply the ConfigMap, Deployment, and Service in that order.
3. `kubectl get endpoints orbital-relay` - you should see 2 IP:port
   entries, one per Pod.
4. `kubectl get svc orbital-relay` - note the `NodePort` value
   (`30080` in this manifest).
5. Reach it: if your cluster exposes node IPs directly, `curl
   http://<node-ip>:30080`; otherwise `kubectl port-forward
   svc/orbital-relay 8080:80` and curl `localhost:8080` - notice you're
   forwarding to the *Service* now, not a specific Pod.
6. Delete a Pod and immediately re-check `kubectl get endpoints
   orbital-relay` - the Service updates on its own.

## Task
Confirm `kubectl get endpoints orbital-relay` lists exactly as many
addresses as your Deployment has replicas, and that traffic still succeeds
after you delete and let one Pod be replaced.

## Checkpoint
The Service's `selector` is `app: orbital-relay` - what happens to routing
if you edit the Deployment's Pod template labels but forget to update the
Service's selector to match?
