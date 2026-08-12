# Topic 8: Health Checks and Resource Limits

**Time:** ~20 minutes

## Goal
Give the Orbital Relay Deployment liveness/readiness probes and CPU/memory
limits, then watch what happens when a probe fails or a limit is hit. This
is the last topic in the module. This folder is self-contained.

## Commands to Teach
```bash
kubectl apply -f configmap.yaml -f deployment.yaml -f service.yaml
kubectl describe pod -l app=orbital-relay
kubectl get pods -l app=orbital-relay -w
kubectl top pods -l app=orbital-relay
```
- `readinessProbe` — a Pod that fails this stops receiving Service
  traffic, but isn't restarted.
- `livenessProbe` — a Pod that fails this gets restarted by the kubelet.
- `resources.requests` — what the scheduler reserves for this container
  when placing it on a node.
- `resources.limits` — the hard ceiling; exceeding the memory limit gets a
  container OOMKilled, exceeding CPU just throttles it.

## Guided Steps
1. `cd` into this folder and apply all three manifests.
2. `kubectl describe pod -l app=orbital-relay` - find `Liveness`,
   `Readiness`, and `Limits`/`Requests` in the container section.
3. `kubectl get pods -l app=orbital-relay` - Pods only show `1/1 READY`
   once the readiness probe passes, not just once the container starts.
4. Break readiness on purpose: `kubectl patch deployment orbital-relay
   --type=json -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/port","value":81}]'`
   (port 81 is wrong - nginx listens on 80). Roll it out and watch
   `kubectl get pods -w`: Pods go `Running` but `0/1 READY` and drop out of
   `kubectl get endpoints orbital-relay` - they never restart, they're just
   pulled from traffic.
5. Restore it: `kubectl apply -f deployment.yaml`, confirm `1/1 READY`
   again.
6. `kubectl top pods -l app=orbital-relay` (needs metrics-server on the
   cluster) and compare to the `requests`/`limits` in `deployment.yaml`.

## Task
Break the readiness probe, confirm via `kubectl get endpoints
orbital-relay` that the broken Pods stop receiving traffic while staying
`Running`, then restore it.

## Checkpoint
A Pod failing its liveness probe gets restarted; a Pod failing its
readiness probe does not. Why does Kubernetes treat these two failures so
differently, and what would go wrong if `livenessProbe` and
`readinessProbe` were merged into one?
