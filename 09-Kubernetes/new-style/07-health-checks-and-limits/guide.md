# Topic 7: Health Checks and Limits

**Time:** ~20 minutes

## What You'll Learn

1. Readiness vs liveness probes.
2. CPU/memory requests and limits.

## Goal

Add probes and resource limits, then break readiness on purpose. Pods
stay `Running` but drop out of the Service until you restore the probe.

This is the last Kubernetes topic.

## Commands

```bash
kubectl apply -f deployment.yaml -f service.yaml
kubectl describe pod -l app=orbital-relay
kubectl get pods -l app=orbital-relay -w
```

- `readinessProbe` — fail this and the Pod leaves Service traffic; it is not restarted.
- `livenessProbe` — fail this and the kubelet restarts the container.
- `requests` / `limits` — what the scheduler reserves, and the hard ceiling.

## Guided Steps

1. Apply this folder:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/07-health-checks-and-limits
kubectl apply -f deployment.yaml -f service.yaml
```

2. `kubectl describe pod -l app=orbital-relay` — find Liveness, Readiness,
   Requests, and Limits.
3. `kubectl get pods` — `1/1 READY` only after the readiness probe passes.
4. Break readiness (port 81 is wrong; nginx listens on 80):

```bash
kubectl patch deployment orbital-relay --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/containers/0/readinessProbe/httpGet/port","value":81}]'
```

Watch `kubectl get pods -w`: `Running` but `0/1 READY`.
`kubectl get endpoints orbital-relay` goes empty — no restart, just no traffic.

5. Restore: `kubectl apply -f deployment.yaml`, confirm `1/1 READY`.

## Task

Break readiness, confirm endpoints drop while Pods stay Running, then restore.

## Checkpoint

Why does a failed liveness probe restart the container, while a failed
readiness probe does not?

## What's Next?

Packaging many YAML files as one installable unit is **[10-Helm](../../10-Helm/README.md)**.
