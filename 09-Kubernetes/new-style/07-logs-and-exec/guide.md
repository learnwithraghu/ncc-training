# Topic 7: Logs, Exec, and Breaking Things on Purpose

**Time:** ~20 minutes

## Goal
Practice the two tools you reach for first when a Pod misbehaves -
`kubectl logs` and `kubectl exec` - by deliberately breaking this
Deployment yourself and diagnosing it. This folder is self-contained.

## Commands to Teach
```bash
kubectl apply -f configmap.yaml -f deployment.yaml -f service.yaml
kubectl logs deploy/orbital-relay
kubectl logs deploy/orbital-relay -f
kubectl exec -it deploy/orbital-relay -- sh
kubectl patch deployment orbital-relay --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/volumeMounts/0/mountPath","value":"/wrong/path"}]'
kubectl describe pod -l app=orbital-relay
```
- `logs` — nginx's access/error stream for a Pod; `-f` follows it live.
- `exec -it ... -- sh` — a shell inside the running container, same
  filesystem the process sees.
- `patch` — edit one field of a live object without hand-rewriting the
  whole YAML; here it's used to intentionally misconfigure the mount.
- `describe pod` — events and container state (`Running`,
  `CrashLoopBackOff`, `ImagePullBackOff`, etc.) in one place.

## Guided Steps
1. `cd` into this folder and apply all three manifests. Confirm the site
   works via `port-forward svc/orbital-relay 8080:80` + `curl`.
2. `kubectl exec -it deploy/orbital-relay -- sh`, then inside the
   container: `ls /usr/share/nginx/html` - see `index.html` from the
   ConfigMap. `exit` when done.
3. Break it: run the `kubectl patch` command above to mount the ConfigMap
   at `/wrong/path` instead of `/usr/share/nginx/html`.
4. `kubectl rollout status deployment/orbital-relay` then `curl` the site
   again - now serving nginx's default "Welcome" page, not Orbital Relay.
5. Diagnose without looking at the YAML: `kubectl describe pod -l
   app=orbital-relay` (check `Mounts` under the container), then `kubectl
   exec -it deploy/orbital-relay -- ls /usr/share/nginx/html` to see the
   ConfigMap content isn't there anymore - it's at `/wrong/path` instead.
6. Fix it: `kubectl apply -f deployment.yaml` to restore the original
   `mountPath`, then confirm the real site is back.

## Task
Break the mount path, prove to yourself (via `describe`/`exec`, not by
reading the YAML) exactly what changed, then restore it.

## Checkpoint
`kubectl logs` showed nothing wrong the whole time you had this broken -
why not, and what does that tell you about what application logs can and
can't diagnose?
