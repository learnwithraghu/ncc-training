# Topic 4: Rolling Update and Rollback

**Time:** ~20 minutes

## What You'll Learn

1. Ship a new image tag without taking the Service down.
2. Roll back to the previous tag when you need the old page.

## Goal

Start on **1.0** (dark day-shift dashboard). Switch to **2.0** (paper
night board). Then undo. Both images are already on Docker Hub — you
only change the tag Kubernetes pulls.

Watch the browser (or curl) while Pods are replaced. The two pages look
nothing alike on purpose.

## Commands

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl set image deployment/orbital-relay web=learnwithraghu/ncc-workshop:2.0
kubectl rollout status deployment/orbital-relay
kubectl rollout undo deployment/orbital-relay
```

- `set image` — new ReplicaSet, Pods replaced a few at a time.
- `rollout status` — waits until the new Pods are Ready.
- `rollout undo` — back to the previous ReplicaSet (`:1.0`).

## Guided Steps

1. Apply this folder's manifests and confirm v1:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/04-rolling-update-and-rollback
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl port-forward svc/orbital-relay 8080:80
```

`curl -s http://localhost:8080 | grep -o "Ground link v1"` — dark page,
VERSION 1.0.

2. Keep port-forward running. In another terminal, roll to 2.0:

```bash
kubectl set image deployment/orbital-relay web=learnwithraghu/ncc-workshop:2.0
kubectl rollout status deployment/orbital-relay
```

Refresh the browser — cream night board, giant **2.0**, **Night Pass v2**.
Or: `curl -s http://localhost:8080 | grep -o "Night Pass v2"`.

3. `kubectl rollout history deployment/orbital-relay`

4. Roll back:

```bash
kubectl rollout undo deployment/orbital-relay
kubectl rollout status deployment/orbital-relay
```

Curl / refresh — **Ground link v1** again.

## Task

Get the live site from 1.0 to 2.0 with `rollout status` succeeding, then
undo back to 1.0.

## Checkpoint

Why does changing the image tag roll out a new ReplicaSet, while editing
files inside a running Pod is the wrong way to ship the same change?

## What's Next?

The page is baked into the image. Next we inject station settings
without rebuilding. **Topic 5: ConfigMap and Secret.**
