# Topic 9: Logs, Exec, and Breaking Things on Purpose

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Read container logs with `kubectl logs` (and follow them live).
2. Open a shell in a running Pod with `kubectl exec`.
3. Break the Deployment on purpose by pointing it at stock nginx.
4. Diagnose with `describe`/`exec` instead of guessing from YAML.
5. Solve "the Deployment is up, but something inside is wrong."

## Goal
Practice the two tools you reach for first when a Pod misbehaves —
`kubectl logs` and `kubectl exec` — by deliberately breaking this
Deployment yourself and diagnosing it. This folder is self-contained.

## Commands to Teach

```bash
# edit deployment.yaml: replace <ECR_REGISTRY>
kubectl apply -f deployment.yaml -f service.yaml
kubectl logs deploy/orbital-relay
kubectl logs deploy/orbital-relay -f
kubectl exec -it deploy/orbital-relay -- sh
kubectl set image deployment/orbital-relay web=nginx:1.27-alpine
kubectl describe pod -l app=orbital-relay
```

- `logs` — nginx's access/error stream for a Pod; `-f` follows it live.
- `exec -it ... -- sh` — a shell inside the running container, same
  filesystem the process sees.
- `set image ... nginx:1.27-alpine` — intentionally serves the default
  nginx welcome page instead of Orbital Relay.
- `describe pod` — events and container state (`Running`,
  `CrashLoopBackOff`, `ImagePullBackOff`, etc.) in one place.

## Guided Steps

1. `cd` into this folder. Replace `<ECR_REGISTRY>` in `deployment.yaml`,
   then apply Deployment and Service. Confirm the site works via
   `port-forward svc/orbital-relay 8080:80` + `curl`.
2. `kubectl exec -it deploy/orbital-relay -- sh`, then inside the
   container: `ls /usr/share/nginx/html` — see the baked `index.html`.
   `exit` when done.
3. Break it: point the Deployment at stock nginx:

```bash
kubectl set image deployment/orbital-relay web=nginx:1.27-alpine
kubectl rollout status deployment/orbital-relay
```

4. `curl` the site again — now serving nginx's default "Welcome" page,
   not Orbital Relay.
5. Diagnose without looking at the YAML: `kubectl describe pod -l
   app=orbital-relay` (check `Image` under the container), then `kubectl
   exec -it deploy/orbital-relay -- cat /usr/share/nginx/html/index.html |
   head` to see the default nginx page instead of Orbital Relay.
6. Fix it: `kubectl apply -f deployment.yaml` to restore the ECR image,
   then confirm the real site is back.

## Task

Break the image, prove to yourself (via `describe`/`exec`, not by reading
the YAML) exactly what changed, then restore it.

## Checkpoint

`kubectl logs` showed nothing wrong the whole time you had this broken —
why not, and what does that tell you about what application logs can and
can't diagnose?

## What's Next?

This is good, but we still need:

1. Automatic detection when a container is alive but not ready for traffic.
2. Restarts when a process is stuck, not only when you notice by hand.
3. CPU/memory requests so the scheduler places Pods fairly.
4. Hard limits so one bad container can't starve the node.
5. Production hardening — **Topic 10: Health Checks and Limits**.
