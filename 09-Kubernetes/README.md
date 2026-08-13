# Day 5, Part 1: Kubernetes

This module teaches Kubernetes fundamentals by building the **Orbital
Relay** image, pushing it to ECR, then deploying, scaling, updating, and
operating that workload end to end on a real cluster.

## What You Will Learn

By the end of this module, you will be able to:

- Install and configure the AWS CLI, and push a custom image to ECR
- Install Docker on Amazon Linux when it is missing and validate it
- Verify cluster readiness and use kubectl confidently
- Run a workload as a Pod, then as a Deployment, and scale it
- Expose it with a Service and reach it without `port-forward`
- Ship a zero-downtime image update and roll it back
- Configure a workload with ConfigMaps and Secrets
- Diagnose a broken Pod with `kubectl logs`/`exec`
- Add liveness/readiness probes and resource requests/limits

## Time Estimate

Approximately **3 to 3.5 hours** total, split into 10 guided topics at
about 20 minutes each.

## Prerequisites

- Completion of [08-GitHub-Actions](../08-GitHub-Actions/README.md)
- Amazon Linux 2023 EC2 lab host (for AWS CLI / Docker topics)
- Instructor-provided AWS access keys and an ECR repository named
  `orbital-relay` in `us-east-1`
- Kubernetes cluster access (provided by instructor)
- Cluster nodes able to pull from that ECR repository
- kubectl installed and configured

## Verify Your Environment

Before starting the topics, run the instructor helper to confirm Docker,
AWS CLI, ECR, and the cluster can execute every command used across all
10 topics:

```bash
bash 09-Kubernetes/new-style/helpers/run-k8s-lab.sh
```

The script derives the ECR URI from `aws sts get-caller-identity` and
the `orbital-relay` repository in `us-east-1`. Pass `--ecr-image-uri`
only if you need a different registry or tag.

It installs Docker/AWS CLI if missing, builds and pushes the Orbital Relay
images, applies each Kubernetes topic's manifests into a scratch
namespace, exercises the rollout/rollback and probe-failure scenarios,
then cleans up. Fix any failures before teaching the module.

## Guided Learning Topics

Work through topics in [new-style/](new-style/) in order — see
[new-style/README.md](new-style/README.md) for the full topic list, folder
layout, and scope boundary.

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [new-style/01-install-aws-cli/](new-style/01-install-aws-cli/) | Install AWS CLI v2 |
| Topic 2 | [new-style/02-configure-aws-cli/](new-style/02-configure-aws-cli/) | Configure credentials, confirm ECR |
| Topic 3 | [new-style/03-build-docker-image/](new-style/03-build-docker-image/) | Install Docker if needed, build/push image |
| Topic 4 | [new-style/04-run-a-pod/](new-style/04-run-a-pod/) | Namespace setup, first Pod from ECR |
| Topic 5 | [new-style/05-deployment-and-scaling/](new-style/05-deployment-and-scaling/) | Deployment, ReplicaSets, scaling |
| Topic 6 | [new-style/06-expose-with-service/](new-style/06-expose-with-service/) | Service (NodePort), endpoints |
| Topic 7 | [new-style/07-rolling-update-and-rollback/](new-style/07-rolling-update-and-rollback/) | Image rollout `:1.0` → `:2.0`, rollback |
| Topic 8 | [new-style/08-configmap-and-secret/](new-style/08-configmap-and-secret/) | ConfigMap and Secret injection |
| Topic 9 | [new-style/09-logs-and-exec/](new-style/09-logs-and-exec/) | Logs, exec, break-and-diagnose |
| Topic 10 | [new-style/10-health-checks-and-limits/](new-style/10-health-checks-and-limits/) | Probes, resource requests/limits |

## Topic Assets

Each topic folder is self-contained: setup topics carry their install
steps (and Topic 3 carries `Dockerfile` / `index.html`); Kubernetes topics
carry their own manifests alongside `guide.md`, so you can teach any
single topic without needing files or state from a previous one.

Run commands from the topic folder so each lesson stays self-contained.
Replace `<ECR_REGISTRY>` in every Pod/Deployment before you apply.
