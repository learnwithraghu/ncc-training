# Topic 6: Logs and Exec

**Time:** ~20 minutes

## What You'll Learn

1. Read container logs and open a shell with `kubectl exec`.
2. Break the Deployment on purpose, then diagnose and restore it.

## Goal

Practice the two commands you reach for first when a Pod misbehaves.
Then point the Deployment at stock nginx so the page is wrong, prove it
with `describe`/`exec`, and put `:1.0` back.

## Commands

```bash
kubectl apply -f deployment.yaml -f service.yaml
kubectl logs deploy/orbital-relay
kubectl exec -it deploy/orbital-relay -- sh
kubectl set image deployment/orbital-relay web=nginx:1.27-alpine
kubectl describe pod -l app=orbital-relay
```

- `logs` — nginx access/error stream.
- `exec` — a shell inside the running container.
- `set image ... nginx` — default nginx welcome page, not Orbital Relay.

## Guided Steps

1. Apply this folder and confirm the 1.0 page:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/06-logs-and-exec
kubectl apply -f deployment.yaml -f service.yaml
kubectl port-forward svc/orbital-relay 18090:80
```

`curl -s http://localhost:18090 | grep -o "Ground link v1"`

2. `kubectl exec -it deploy/orbital-relay -- sh`, then
   `ls /usr/share/nginx/html` and `exit`.
3. Break it:

```bash
kubectl set image deployment/orbital-relay web=nginx:1.27-alpine
kubectl rollout status deployment/orbital-relay
```

Curl again — nginx welcome page, not Orbital Relay.

4. Diagnose without opening the YAML: `kubectl describe pod -l app=orbital-relay`
   (check `Image`), then
   `kubectl exec -it deploy/orbital-relay -- cat /usr/share/nginx/html/index.html | head`
5. Restore: `kubectl apply -f deployment.yaml`, confirm **Ground link v1**.

## Task

Break the image, prove what changed with `describe`/`exec`, then restore it.

## Checkpoint

`kubectl logs` looked fine while the page was wrong. What can application
logs not tell you?

## What's Next?

Pods can be Running and still be the wrong place to send traffic. Next:
readiness/liveness probes and CPU/memory limits. **Topic 7: Health Checks and Limits.**
