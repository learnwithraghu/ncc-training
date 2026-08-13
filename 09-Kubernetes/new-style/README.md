# Kubernetes New Style — Orbital Relay on a Cluster

Work through these topics in order against a Kubernetes cluster
(`kubectl` already configured). Each folder has its own manifests and
`guide.md`. You do not need files from a previous folder.

The workload is **Orbital Relay**. Both versions are already on Docker
Hub. Class only runs kubectl.

- `learnwithraghu/ncc-workshop:1.0` — dark day-shift dashboard
- `learnwithraghu/ncc-workshop:2.0` — paper night board (rolling update)

## Instructor prerequisite

Before class, on a laptop with Docker:

```bash
cd ~/ncc-training/09-Kubernetes/new-style/helpers
docker login
bash build-and-push-images.sh
```

## Recommended Flow

1. Open the topic folder.
2. Read **What You'll Learn**.
3. Run the commands in **Guided Steps**.
4. Complete the **Task** and **Checkpoint**.
5. Read **What's Next?** and go to the next folder.

## Topic List

| Folder | Focus |
|--------|-------|
| [01-run-a-pod/](01-run-a-pod/) | Namespace + first Pod, `port-forward` |
| [02-deployment-and-scaling/](02-deployment-and-scaling/) | Deployment, scale, self-heal |
| [03-expose-with-service/](03-expose-with-service/) | Service, endpoints |
| [04-rolling-update-and-rollback/](04-rolling-update-and-rollback/) | `:1.0` → `:2.0`, `rollout undo` |
| [05-configmap-and-secret/](05-configmap-and-secret/) | ConfigMap + Secret env vars |
| [06-logs-and-exec/](06-logs-and-exec/) | logs, exec, break with stock nginx |
| [07-health-checks-and-limits/](07-health-checks-and-limits/) | probes + requests/limits |

## Scope

Pods, Deployments, Services, rollouts, ConfigMaps/Secrets, logs/exec, and
health checks. No Ingress, NetworkPolicies, volumes, StatefulSets, or
Jobs. Helm is [10-Helm](../../10-Helm/README.md).
