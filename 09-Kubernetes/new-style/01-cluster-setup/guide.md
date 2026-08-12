# Topic 1: Meet the Cluster

**Time:** ~20 minutes

## Goal
Confirm you have working `kubectl` access to a cluster and create the
namespace every later topic in this module deploys into. This folder is
self-contained - no manifests, just cluster setup.

## Commands to Teach
```bash
kubectl config current-context
kubectl cluster-info
kubectl get nodes
kubectl create namespace orbital-relay
kubectl config set-context --current --namespace=orbital-relay
```
- `config current-context` / `cluster-info` — which cluster you're actually
  talking to, before you change anything on it.
- `get nodes` — proves the control plane can see worker capacity.
- `create namespace` — every topic in this module lives in `orbital-relay`,
  so nothing here collides with other workloads on the cluster.
- `config set-context --current --namespace=...` — stop typing
  `-n orbital-relay` on every command for the rest of the module.

## Guided Steps
1. Run `kubectl config current-context` and say out loud which cluster this
   is - the whole module points here.
2. `kubectl cluster-info` and `kubectl get nodes` - if either fails, stop
   and fix cluster access before going further.
3. Create the namespace: `kubectl create namespace orbital-relay`.
4. Set it as your default so every later `kubectl` command in this module
   is scoped to it automatically.
5. Confirm: `kubectl config view --minify | grep namespace`.

## Task
Get `kubectl get nodes` to return at least one `Ready` node, then create and
switch into the `orbital-relay` namespace.

## Checkpoint
What would go wrong in later topics if you skipped creating a dedicated
namespace and just used `default`?
