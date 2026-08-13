# Topic 4: Run the Orbital Relay Pod

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Create the `orbital-relay` namespace and set it as your default context.
2. Deploy Orbital Relay as a single Pod using the ECR image from Topic 3.
3. Replace `<ECR_REGISTRY>` in `pod.yaml` with your account's registry.
4. Reach the Pod from your laptop with `port-forward` (no cluster exposure yet).
5. Solve "I have an image in ECR, but nothing is running on the cluster yet."

## Goal
Deploy the Orbital Relay ground-station dashboard as a single Pod that
pulls `<ECR_REGISTRY>/orbital-relay:1.0` — the image you built and pushed
in Topic 3. This folder is self-contained: `pod.yaml` is the only
manifest.

Before you apply anything, create the namespace every later topic in this
module deploys into.

## Commands to Teach

```bash
kubectl create namespace orbital-relay
kubectl config set-context --current --namespace=orbital-relay
# edit pod.yaml: replace <ECR_REGISTRY> with ACCOUNT.dkr.ecr.us-east-1.amazonaws.com
kubectl apply -f pod.yaml
kubectl get pods -o wide
kubectl port-forward pod/orbital-relay 8080:80
```

- `create namespace` / `set-context` — every topic from here on lives in
  `orbital-relay`, so you stop typing `-n orbital-relay` on every command.
- `pod.yaml` — one container that pulls your ECR image (`imagePullPolicy:
  Always`) and serves the baked `index.html` on port 80.
- `get pods -o wide` — confirms the Pod scheduled and is `Running`, and
  which node it landed on.
- `port-forward` — reach a Pod's port from your machine without exposing
  anything on the cluster yet (that's Topic 6).

## Guided Steps

1. Confirm cluster access before you change anything:

```bash
kubectl config current-context
kubectl cluster-info
kubectl get nodes
```

2. Create the namespace and set it as the default for this context:

```bash
kubectl create namespace orbital-relay
kubectl config set-context --current --namespace=orbital-relay
kubectl config view --minify | grep namespace
```

3. `cd` into this folder. Replace `<ECR_REGISTRY>` in `pod.yaml` with your
   registry (same value as Topic 3):

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
sed -i "s|<ECR_REGISTRY>|${ECR_REGISTRY}|g" pod.yaml
grep image: pod.yaml
```

4. Apply the Pod: `kubectl apply -f pod.yaml`.
5. Watch it come up: `kubectl get pods -w` (Ctrl+C once it's `Running`).
6. In one terminal: `kubectl port-forward pod/orbital-relay 8080:80`. In
   another: `curl -s http://localhost:8080 | grep -o "Orbital Relay"`.
7. `kubectl describe pod orbital-relay` — find the `Image` field and
   confirm it matches your ECR URI.

## Task

Get `curl http://localhost:8080` to return the Orbital Relay page from a
Pod that pulls your ECR image, with the default namespace set to
`orbital-relay`.

## Checkpoint

If you `kubectl delete pod orbital-relay` right now, does anything
recreate it automatically? Why or why not — and what would you use instead
if you wanted it to?

## What's Next?

This is good, but we still need:

1. Automatic restart if someone deletes the Pod — bare Pods don't come back.
2. More than one replica so a single crash doesn't take the site down.
3. A controller that owns Pods instead of managing them by hand.
4. A safe way to scale up and down without rewriting Pod YAML each time.
5. Self-healing replicas — **Topic 5: Deployment and Scaling**.
