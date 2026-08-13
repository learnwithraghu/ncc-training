# Topic 8: Configuration With ConfigMaps and Secrets

**Time:** ~20 minutes

## What You'll Learn (and Solve)

1. Inject non-sensitive station settings via a ConfigMap as env vars.
2. Inject a sensitive token via a Secret the same way.
3. Prove values reached the container with `kubectl exec ... -- env`.
4. See that Secret data is base64-encoded, not encrypted.
5. Solve "I need per-station config without rebuilding the image."

## Goal
Inject station-specific configuration into the Orbital Relay Deployment
without changing the container image: a plain ConfigMap for non-sensitive
values, and a Secret for something you wouldn't want in plain YAML in a
real cluster. The site itself stays baked into
`<ECR_REGISTRY>/orbital-relay:1.0`. This folder is self-contained.

## Commands to Teach

```bash
# edit deployment.yaml: replace <ECR_REGISTRY>
kubectl apply -f station-config.yaml
kubectl apply -f station-secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl exec deploy/orbital-relay -- env | grep -E 'STATION_|RELAY_'
kubectl get secret station-secret -o jsonpath='{.data.RELAY_API_TOKEN}' | base64 -d
```

- `station-config.yaml` — a ConfigMap (`STATION_NAME`, `STATION_REGION`)
  for non-sensitive station settings.
- `station-secret.yaml` — a `Secret` with the same shape as a ConfigMap,
  but `kubectl get -o yaml` shows its values base64-encoded, not in plain
  text.
- `env.valueFrom.configMapKeyRef` / `secretKeyRef` in `deployment.yaml` —
  how both get exposed to the container as environment variables.
- `kubectl exec ... -- env` — proves the values actually reached the
  running container.

## Guided Steps

1. `cd` into this folder. Replace `<ECR_REGISTRY>` in `deployment.yaml`.
2. Apply station ConfigMap and Secret first, then Deployment and Service
   — so Pods do not start before their env sources exist.
3. `kubectl exec deploy/orbital-relay -- env | grep -E 'STATION_|RELAY_'`
   — confirm all three values are present in the container's environment.
4. `kubectl get configmap station-config -o yaml` — values are plain text.
5. `kubectl get secret station-secret -o yaml` — values are base64, not
   plaintext. Decode one: `kubectl get secret station-secret -o
   jsonpath='{.data.RELAY_API_TOKEN}' | base64 -d`.
6. Point out: base64 is encoding, not encryption — anyone who can `kubectl
   get secret` can decode it. RBAC is what actually protects it.

## Task

Get `STATION_NAME`, `STATION_REGION`, and `RELAY_API_TOKEN` all visible
inside a running container via `kubectl exec ... -- env`.

## Checkpoint

Given that `kubectl get secret -o yaml` can be decoded by anyone with read
access, what does a Kubernetes `Secret` actually protect against, and what
doesn't it protect against?

## What's Next?

This is good, but we still need:

1. A first response when the site looks wrong or Pods misbehave.
2. Application logs from the container without SSH to a node.
3. A shell inside the running container to inspect files.
4. Practice diagnosing a break you caused on purpose.
5. Day-2 ops skills — **Topic 9: Logs and Exec**.
