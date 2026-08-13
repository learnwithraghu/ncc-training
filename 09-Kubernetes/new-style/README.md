# Kubernetes New Style — Orbital Relay on a Cluster

Work through these topics in order on Ubuntu, then against a real
Kubernetes cluster (`kubectl` configured and pointed at it). Each
topic folder is independent: it has its own manifests (or setup assets)
and `guide.md`. You do not need files from a previous folder.

The workload is **Orbital Relay**, a fictional satellite ground-station
dashboard: a static page baked into a custom image
(`orbital-relay:1.0`), pushed to ECR, then pulled by every Pod and
Deployment from Topic 4 onward.

## Recommended Flow

1. Open the topic folder.
2. Read **What You'll Learn (and Solve)** — five points on the goal.
3. Follow the guided steps (setup topics) or apply the manifests in the
   order the guide lists (Kubernetes topics).
4. Complete the **Task** and answer the **Checkpoint**.
5. Read **What's Next?** — five "this is good, but…" points that lead to the next topic.

## Topic List

| Folder | Focus |
|--------|-------|
| [01-install-aws-cli/](01-install-aws-cli/) | Install AWS CLI v2 on Ubuntu |
| [02-configure-aws-cli/](02-configure-aws-cli/) | `aws configure`, identity check, confirm ECR repo |
| [03-build-docker-image/](03-build-docker-image/) | Install Docker if needed, build/push `orbital-relay:1.0` to ECR |
| [04-run-a-pod/](04-run-a-pod/) | Namespace setup, first Pod from ECR, `port-forward` |
| [05-deployment-and-scaling/](05-deployment-and-scaling/) | Deployment, ReplicaSet ownership, `kubectl scale` |
| [06-expose-with-service/](06-expose-with-service/) | `Service` (NodePort), `kubectl get endpoints` |
| [07-rolling-update-and-rollback/](07-rolling-update-and-rollback/) | Image `:1.0` → `:2.0`, `rollout status`/`undo` |
| [08-configmap-and-secret/](08-configmap-and-secret/) | Config via `ConfigMap` env vars, secrets via `Secret` |
| [09-logs-and-exec/](09-logs-and-exec/) | `kubectl logs`/`exec`, break-and-diagnose a wrong image |
| [10-health-checks-and-limits/](10-health-checks-and-limits/) | `livenessProbe`/`readinessProbe`, CPU/memory `requests`/`limits` |

## How each folder is laid out

```text
# Topics 01–02
guide.md         install / configure steps

# Topic 03
index.html       Orbital Relay page baked into the image
Dockerfile       FROM nginx + COPY index.html
.dockerignore    keeps guide.md out of the build context
guide.md         install Docker (if needed), build, push

# Topics 04–10
pod.yaml / deployment.yaml / service.yaml   workload for that topic
station-config.yaml / station-secret.yaml   Topic 08 only
Dockerfile / index.html / Dockerfile.v2     Topic 07 rolling update assets
guide.md                                    commands, steps, task, checkpoint
```

Replace `<ECR_REGISTRY>` in every Pod/Deployment with
`ACCOUNT.dkr.ecr.us-east-1.amazonaws.com` before you apply.

## Instructor Helper

```bash
cd ~/ncc-training/09-Kubernetes/new-style/helpers
bash run-k8s-lab.sh
```

`--ecr-image-uri` is optional. If omitted, the script uses
`<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/orbital-relay:1.0` from
`aws sts get-caller-identity`.

The script installs Docker and AWS CLI v2 if missing, validates AWS
credentials and the ECR repository, builds and pushes `:1.0` and `:2.0`,
then applies every Kubernetes topic's manifests into a scratch namespace,
exercises rollout/rollback and probe-failure scenarios, and deletes the
namespace.

## Scope Boundary

This module covers AWS CLI setup, baking/pushing an image to ECR, then
Pods, Deployments, Services, rollouts, ConfigMaps/Secrets, logs/exec, and
health checks/resource limits — one linear build-and-operate story. It
does not cover Ingress, NetworkPolicies, PersistentVolumes/Claims,
StatefulSets, or Jobs/CronJobs. It also does not cover Helm — that's
[10-Helm](../../10-Helm/README.md), which builds on these fundamentals.
