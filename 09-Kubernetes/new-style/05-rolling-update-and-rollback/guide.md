# Topic 5: Rolling Update and Rollback

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Ship a new Orbital Relay version without tearing the Service down.
2. See why ConfigMap changes alone don't update already-running Pods.
3. Trigger and watch a zero-downtime rollout with `rollout status`.
4. Roll back to the previous version when the new one is wrong.
5. Solve "I need to change the live site without an outage."

## Goal
Ship a new version of the Orbital Relay site with zero downtime, then roll
it back. This folder is self-contained and includes two versions of the
ConfigMap: `configmap.yaml` (v1) and `configmap-v2.yaml` (v2, a visibly
different "Ground link" tag in the header).

## Commands to Teach
```bash
kubectl apply -f configmap.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f configmap-v2.yaml
kubectl rollout restart deployment/orbital-relay
kubectl rollout status deployment/orbital-relay
kubectl rollout undo deployment/orbital-relay
```
- ConfigMap changes alone don't trigger a rollout — Pods keep the mounted
  file version they started with, so you need `rollout restart` to pick up
  `configmap-v2.yaml`.
- `rollout status` — blocks until every new Pod is `Ready` and every old
  one is gone; this is what "zero downtime" looks like from the CLI.
- `rollout undo` — reverts to the previous ReplicaSet's Pod template.

## Guided Steps
1. `cd` into this folder.
2. Apply `configmap.yaml`, `deployment.yaml`, and `service.yaml`. Confirm
   `curl` (via `port-forward svc/orbital-relay 8080:80`) shows
   `Ground link v1` in the page.
3. Apply the new version: `kubectl apply -f configmap-v2.yaml`.
4. `curl` again - still `v1`. Explain why before moving on.
5. Trigger the rollout: `kubectl rollout restart deployment/orbital-relay`,
   then `kubectl rollout status deployment/orbital-relay` and watch it
   report success.
6. `curl` again - now `Ground link v2`. Check `kubectl rollout history
   deployment/orbital-relay`.
7. Roll back: `kubectl rollout undo deployment/orbital-relay`, wait for
   `rollout status` again, then `curl` once more - back to `v1`.

## Task
Get the live site from `v1` to `v2` with `kubectl rollout status` reporting
success and zero failed requests, then roll it back to `v1` the same way.

## Checkpoint
Why doesn't updating a ConfigMap that's already mounted into running Pods
change what those Pods serve immediately, and what real-world deployment
mistake does this guard against?

## What's Next?
This is good, but we still need:

1. Station-specific settings without editing the container image.
2. A clean split between public config and sensitive values.
3. Environment variables injected into the running Pods.
4. A Secret object (not plain ConfigMap text) for tokens/passwords.
5. Config and secrets injection — **Topic 6: ConfigMap and Secret**.
