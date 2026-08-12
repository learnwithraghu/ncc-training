# Kubernetes New Style — Orbital Relay on a Cluster

Work through these topics in order against a real Kubernetes cluster
(`kubectl` configured and pointed at it). Each topic folder is independent:
it has its own manifests and `guide.md`. You do not need files from a
previous folder.

The workload is **Orbital Relay**, a fictional satellite ground-station
dashboard: a single static page served by a stock `nginx:1.27-alpine`
image, with the page content injected via a `ConfigMap` — no custom image
build or registry required anywhere in this module.

## Recommended Flow

1. Open the topic folder.
2. Apply the manifests in the order the guide lists.
3. Complete the **Task**.
4. Answer the checkpoint before moving on.

## Topic List

| Folder | Focus |
|--------|-------|
| [01-cluster-setup/](01-cluster-setup/) | `kubectl` access, cluster-info, create the `orbital-relay` namespace |
| [02-run-a-pod/](02-run-a-pod/) | First Pod, ConfigMap-mounted site, `port-forward` |
| [03-deployment-and-scaling/](03-deployment-and-scaling/) | Deployment, ReplicaSet ownership, `kubectl scale` |
| [04-expose-with-service/](04-expose-with-service/) | `Service` (NodePort), `kubectl get endpoints` |
| [05-rolling-update-and-rollback/](05-rolling-update-and-rollback/) | Zero-downtime rollout, `rollout status`/`undo` |
| [06-configmap-and-secret/](06-configmap-and-secret/) | Config via `ConfigMap` env vars, secrets via `Secret` |
| [07-logs-and-exec/](07-logs-and-exec/) | `kubectl logs`/`exec`, break-and-diagnose a bad mount |
| [08-health-checks-and-limits/](08-health-checks-and-limits/) | `livenessProbe`/`readinessProbe`, CPU/memory `requests`/`limits` |

## How each folder is laid out

```text
configmap.yaml   Orbital Relay index.html, injected as cluster config (not baked into an image)
pod.yaml / deployment.yaml / service.yaml   the workload for that topic
guide.md         commands, steps, task, checkpoint
```

## Instructor Helper

```bash
cd ~/ncc-training/09-Kubernetes/new-style/helpers
bash run-k8s-lab.sh
```

The script applies every topic's manifests into a scratch namespace, waits
for each rollout, curls Orbital Relay through a port-forward, exercises the
rollback and probe-failure scenarios, then deletes the namespace.

## Scope Boundary

This module covers Pods, Deployments, Services, rollouts, ConfigMaps/
Secrets, logs/exec, and health checks/resource limits - one linear
deploy-and-operate story. It does not cover Ingress, NetworkPolicies,
PersistentVolumes/Claims, StatefulSets, or Jobs/CronJobs. It also does not
cover Helm - that's [10-Helm](../../10-Helm/README.md), which builds on
these fundamentals.
