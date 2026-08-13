# Topic 5: ConfigMap and Secret

**Time:** ~20 minutes

## What You'll Learn

1. Inject non-sensitive settings with a ConfigMap.
2. Inject a token with a Secret, and see that it is encoded, not encrypted.

## Goal

Give the Orbital Relay Pods environment variables without changing the
image. ConfigMap for station name/region. Secret for the API token.

## Commands

```bash
kubectl apply -f station-config.yaml
kubectl apply -f station-secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl exec deploy/orbital-relay -- env | grep -E 'STATION_|RELAY_'
kubectl get secret station-secret -o jsonpath='{.data.RELAY_API_TOKEN}' | base64 -d
```

- ConfigMap values show as plain text in `kubectl get -o yaml`.
- Secret values show as base64. Anyone who can read the Secret can decode it.

## Guided Steps

1. Apply config and secret first, then the workload:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/05-configmap-and-secret
kubectl apply -f station-config.yaml
kubectl apply -f station-secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

2. `kubectl exec deploy/orbital-relay -- env | grep -E 'STATION_|RELAY_'`
   — all three values are in the container.
3. `kubectl get configmap station-config -o yaml` — plain text.
4. `kubectl get secret station-secret -o yaml` — base64. Decode:
   `kubectl get secret station-secret -o jsonpath='{.data.RELAY_API_TOKEN}' | base64 -d`

## Task

`STATION_NAME`, `STATION_REGION`, and `RELAY_API_TOKEN` all show up in
`kubectl exec ... -- env`.

## Checkpoint

If anyone with `kubectl get secret` can decode the value, what does a
Secret actually protect against?

## What's Next?

When the site looks wrong, you need logs and a shell in the container.
**Topic 6: Logs and Exec.**
