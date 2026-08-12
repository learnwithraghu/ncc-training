# Topic 6: Configuration With ConfigMaps and Secrets

**Time:** ~20 minutes

## Goal
Inject station-specific configuration into the Orbital Relay Deployment
without changing the container image: a plain ConfigMap for non-sensitive
values, and a Secret for something you wouldn't want in plain YAML in a
real cluster. This folder is self-contained.

## Commands to Teach
```bash
kubectl apply -f configmap.yaml
kubectl apply -f station-config.yaml
kubectl apply -f station-secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl exec deploy/orbital-relay -- env | grep -E 'STATION_|RELAY_'
kubectl get secret station-secret -o jsonpath='{.data.RELAY_API_TOKEN}' | base64 -d
```
- `station-config.yaml` — a *second*, separate ConfigMap (`STATION_NAME`,
  `STATION_REGION`), distinct from the site content ConfigMap from earlier
  topics.
- `station-secret.yaml` — a `Secret` with the same shape as a ConfigMap,
  but `kubectl get -o yaml` shows its values base64-encoded, not in plain
  text.
- `env.valueFrom.configMapKeyRef` / `secretKeyRef` in `deployment.yaml` —
  how both get exposed to the container as environment variables.
- `kubectl exec ... -- env` — proves the values actually reached the
  running container.

## Guided Steps
1. `cd` into this folder.
2. Apply all five manifests (site ConfigMap, station ConfigMap, Secret,
   Deployment, Service) in any order - `deployment.yaml` will fail to
   schedule Pods cleanly only if it comes up before its ConfigMap/Secret
   exist, so apply those first to avoid confusing errors.
3. `kubectl exec deploy/orbital-relay -- env | grep -E 'STATION_|RELAY_'`
   - confirm all three values are present in the container's environment.
4. `kubectl get configmap station-config -o yaml` - values are plain text.
5. `kubectl get secret station-secret -o yaml` - values are base64, not
   plaintext. Decode one: `kubectl get secret station-secret -o
   jsonpath='{.data.RELAY_API_TOKEN}' | base64 -d`.
6. Point out: base64 is encoding, not encryption - anyone who can `kubectl
   get secret` can decode it. RBAC is what actually protects it.

## Task
Get `STATION_NAME`, `STATION_REGION`, and `RELAY_API_TOKEN` all visible
inside a running container via `kubectl exec ... -- env`.

## Checkpoint
Given that `kubectl get secret -o yaml` can be decoded by anyone with read
access, what does a Kubernetes `Secret` actually protect against, and what
doesn't it protect against?
