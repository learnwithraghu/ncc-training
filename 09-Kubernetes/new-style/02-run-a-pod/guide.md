# Topic 2: Run the Orbital Relay Pod

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Deploy Orbital Relay as a single Pod using a stock nginx image.
2. Store the site in a ConfigMap instead of baking a custom image.
3. Mount that ConfigMap into the container so nginx serves the page.
4. Reach the Pod from your laptop with `port-forward` (no cluster exposure yet).
5. Solve "I have a cluster, but nothing is running that I can curl."

## Goal
Deploy the Orbital Relay ground-station dashboard as a single Pod. This
folder is self-contained: `configmap.yaml` holds the site, `pod.yaml` runs
it - no build step, just a stock `nginx:1.27-alpine` image serving a file
mounted in from a ConfigMap.

## Commands to Teach
```bash
kubectl apply -f configmap.yaml
kubectl apply -f pod.yaml
kubectl get pods -o wide
kubectl port-forward pod/orbital-relay 8080:80
```
- `configmap.yaml` — the Orbital Relay `index.html`, stored as cluster
  config data, not baked into an image.
- `pod.yaml` — one container, `nginx:1.27-alpine`, that mounts the
  ConfigMap at `/usr/share/nginx/html` so nginx serves it as-is.
- `get pods -o wide` — confirms the Pod scheduled and is `Running`, and
  which node it landed on.
- `port-forward` — reach a Pod's port from your machine without exposing
  anything on the cluster yet (that's Topic 4).

## Guided Steps
1. `cd` into this folder - work only with the files here.
2. Apply the ConfigMap first: `kubectl apply -f configmap.yaml`.
3. Apply the Pod: `kubectl apply -f pod.yaml`.
4. Watch it come up: `kubectl get pods -w` (Ctrl+C once it's `Running`).
5. In one terminal: `kubectl port-forward pod/orbital-relay 8080:80`. In
   another: `curl -s http://localhost:8080 | grep -o "Orbital Relay"`.
6. `kubectl describe pod orbital-relay` - find the `Volumes` section and
   confirm it references the `orbital-site` ConfigMap.

## Task
Get `curl http://localhost:8080` to return the Orbital Relay page, then
explain in one sentence why the container needed no custom image to serve
it.

## Checkpoint
If you `kubectl delete pod orbital-relay` right now, does anything
recreate it automatically? Why or why not - and what would you use instead
if you wanted it to?

## What's Next?
This is good, but we still need:

1. Automatic restart if someone deletes the Pod — bare Pods don't come back.
2. More than one replica so a single crash doesn't take the site down.
3. A controller that owns Pods instead of managing them by hand.
4. A safe way to scale up and down without rewriting Pod YAML each time.
5. Self-healing replicas — **Topic 3: Deployment and Scaling**.
