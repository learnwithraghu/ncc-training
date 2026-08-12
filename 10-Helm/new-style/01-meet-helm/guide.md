# Topic 1: Meet Helm

**Time:** ~15 minutes

## What You'll Learn (and Solve)

1. Explain why Helm exists after you already know kubectl YAML.
2. Confirm the Helm CLI works on your machine.
3. Confirm kubectl still points at a usable cluster.
4. Create the `signal-forge` namespace for this module's Jenkins release.
5. Solve "I can deploy with kubectl, but managing many YAML files is painful."

## Goal
Connect Kubernetes fundamentals to Helm, verify tooling, and prepare the
namespace for **Signal Forge** (Jenkins via an official Helm chart).

## Commands to Teach

```bash
helm version
kubectl cluster-info
kubectl get nodes
kubectl create namespace signal-forge
kubectl config set-context --current --namespace=signal-forge
```

- `helm version` — proves the Helm client is installed.
- `kubectl cluster-info` / `get nodes` — same cluster readiness check as Topic 1 in Kubernetes.
- `create namespace signal-forge` — every later Helm release in this module lives here.
- `set-context --namespace=...` — stop typing `-n signal-forge` on every command.

## Guided Steps

1. Confirm Helm:

```bash
helm version
```

2. Confirm cluster access:

```bash
kubectl cluster-info
kubectl get nodes
```

3. Create and switch into the lab namespace:

```bash
kubectl create namespace signal-forge
kubectl config set-context --current --namespace=signal-forge
kubectl config view --minify | grep namespace
```

4. Say the story out loud: Kubernetes gave you Pods, Deployments, and Services.
   Helm packages those objects into a **chart**, and an installed chart becomes a
   **release** you can upgrade and roll back as one unit.

## Task

Get `helm version` working, create `signal-forge`, and set it as your current namespace.

## Checkpoint

What is the difference between a Helm **chart** and a Helm **release**?

## What's Next?
This is good, but we still need:

1. A real chart to install — not just an empty namespace.
2. A place to download open-source charts from (a chart repository).
3. A way to search for the Jenkins chart by name.
4. A way to inspect default values before installing anything.
5. Repo discovery — **Topic 2: Add Repo and Search**.
