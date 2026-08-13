# Topic 7: Rolling Update and Rollback

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Ship a new Orbital Relay version without tearing the Service down.
2. Build and push `:2.0` with a visibly different "Ground link" tag.
3. Trigger a zero-downtime update with `kubectl set image` and `rollout status`.
4. Roll back to `:1.0` when the new version is wrong.
5. Solve "I need to change the live site without an outage."

## Goal
Ship a new version of the Orbital Relay site with zero downtime, then roll
it back. This folder is self-contained and includes two image builds:
`index.html` + `Dockerfile` (v1, `Ground link v1`) and `index-v2.html` +
`Dockerfile.v2` (v2, `Ground link v2`).

## Commands to Teach

```bash
# edit deployment.yaml: replace <ECR_REGISTRY>
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
docker build -f Dockerfile.v2 -t orbital-relay:2.0 .
docker tag orbital-relay:2.0 <ECR_REGISTRY>/orbital-relay:2.0
docker push <ECR_REGISTRY>/orbital-relay:2.0
kubectl set image deployment/orbital-relay web=<ECR_REGISTRY>/orbital-relay:2.0
kubectl rollout status deployment/orbital-relay
kubectl rollout undo deployment/orbital-relay
```

- Image tag changes trigger a new ReplicaSet; that is how you ship a new
  baked page without editing live Pods by hand.
- `rollout status` — blocks until every new Pod is `Ready` and every old
  one is gone; this is what "zero downtime" looks like from the CLI.
- `rollout undo` — reverts to the previous ReplicaSet's Pod template
  (back to `:1.0`).

## Guided Steps

1. `cd` into this folder. Replace `<ECR_REGISTRY>` in `deployment.yaml`.
2. Apply `deployment.yaml` and `service.yaml`. Confirm `curl` (via
   `port-forward svc/orbital-relay 8080:80`) shows `Ground link v1`.
3. Build and push the v2 image:

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"

aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin "$ECR_REGISTRY"

docker build -f Dockerfile.v2 -t orbital-relay:2.0 .
docker tag orbital-relay:2.0 "${ECR_REGISTRY}/orbital-relay:2.0"
docker push "${ECR_REGISTRY}/orbital-relay:2.0"
```

4. Roll out the new image:

```bash
kubectl set image deployment/orbital-relay web="${ECR_REGISTRY}/orbital-relay:2.0"
kubectl rollout status deployment/orbital-relay
```

5. `curl` again — now `Ground link v2`. Check `kubectl rollout history
   deployment/orbital-relay`.
6. Roll back: `kubectl rollout undo deployment/orbital-relay`, wait for
   `rollout status` again, then `curl` once more — back to `v1`.

## Task

Get the live site from `v1` to `v2` with `kubectl rollout status` reporting
success, then roll it back to `v1` the same way.

## Checkpoint

Why does changing the container image trigger a new rollout, while editing
a running Pod by hand is the wrong way to ship the same change?

## What's Next?

This is good, but we still need:

1. Station-specific settings without editing the container image.
2. A clean split between public config and sensitive values.
3. Environment variables injected into the running Pods.
4. A Secret object (not plain ConfigMap text) for tokens/passwords.
5. Config and secrets injection — **Topic 8: ConfigMap and Secret**.
