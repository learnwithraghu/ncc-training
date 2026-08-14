# Topic 8: Horizontal Pod Autoscaler

**Time:** ~20 minutes

## What You'll Learn

1. Let an HPA add Pods when CPU is high, then remove them when it drops.
2. Why CPU **requests** (Topic 7) are what the utilization % is measured against.

## Goal

Start Orbital Relay at 1 replica. Burn CPU inside the container, watch
the HPA scale toward 4, stop the burn, and watch it scale back toward 1.

Work in the `orbital-relay` namespace from Topic 1. This folder is
self-contained — apply its YAML even if Topic 7 is still running.

The cluster must have **metrics-server**. If `kubectl top pods` fails,
stop and tell the instructor; do not install metrics-server yourself.

## Commands

```bash
kubectl apply -f deployment.yaml -f hpa.yaml
kubectl get hpa
kubectl top pods
kubectl exec deploy/orbital-relay -- sh -c 'dd if=/dev/zero of=/dev/null'
kubectl get hpa,pods -w
```

- `deployment.yaml` — 1 replica, CPU request `100m` so HPA has a baseline.
- `hpa.yaml` — min 1, max 4, target 50% CPU. Scale-down wait is 30s (not the 5-minute default).
- `kubectl top` — live CPU from metrics-server.
- `dd` — busy-loop CPU in the nginx container. Curling the static page will not spike CPU.
- Ctrl+C the `dd` exec when you have seen scale-up.

## Guided Steps

1. Confirm metrics, then apply this folder:

```bash
kubectl top pods
cd ~/ncc-training/09-Kubernetes/new-style/08-horizontal-pod-autoscaler
kubectl apply -f deployment.yaml -f hpa.yaml
kubectl get hpa
```

`TARGETS` may show `<unknown>` for up to about 30 seconds. Wait until it
is a percentage, for example `0%/50%`.

2. Confirm the request is what HPA uses:

```bash
kubectl describe hpa orbital-relay
kubectl top pods
```

3. In a **second terminal**, burn CPU (leave the first terminal free to watch):

```bash
kubectl exec deploy/orbital-relay -- sh -c 'dd if=/dev/zero of=/dev/null'
```

4. In the first terminal:

```bash
kubectl get hpa,pods -w
```

Replicas should climb toward 4. One busy Pod is enough: unused new Pods
still leave the **average** well above 50% while `dd` is running.

5. Ctrl+C the `dd` command. After about 30–60 seconds, replicas should
   fall back toward 1.

## Task

Scale from 1 replica up under CPU load, then back down after you stop
`dd`. `kubectl get hpa` should show current vs target CPU.

## Checkpoint

Why does HPA compare usage to the container **request**, not the limit?
When would you still use Topic 2's `kubectl scale` instead of an HPA?

## What's Next?

Packaging many YAML files as one installable unit is **[10-Helm](../../10-Helm/README.md)**.
