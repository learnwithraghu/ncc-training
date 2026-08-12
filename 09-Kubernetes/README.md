# Day 5, Part 1: Kubernetes

This module teaches Kubernetes fundamentals by deploying, scaling,
updating, and operating one workload - **Orbital Relay**, a fictional
satellite ground-station dashboard - end to end on a real cluster.

## What You Will Learn

By the end of this module, you will be able to:

- Verify cluster readiness and use kubectl confidently
- Run a workload as a Pod, then as a Deployment, and scale it
- Expose it with a Service and reach it without `port-forward`
- Ship a zero-downtime update and roll it back
- Configure a workload with ConfigMaps and Secrets
- Diagnose a broken Pod with `kubectl logs`/`exec`
- Add liveness/readiness probes and resource requests/limits

## Time Estimate

Approximately **2.5 to 3 hours** total, split into 8 guided topics at
about 20 minutes each.

## Prerequisites

- Completion of [08-GitHub-Actions](../08-GitHub-Actions/README.md)
- Kubernetes cluster access (provided by instructor)
- kubectl installed and configured

## Verify Your Environment

Before starting the topics, run the instructor helper to confirm the
cluster can execute every command used across all 8 topics:

```bash
bash 09-Kubernetes/new-style/helpers/run-k8s-lab.sh
```

It applies each topic's manifests into a scratch namespace, exercises the
rollout/rollback and probe-failure scenarios, then cleans up. Fix any
failures before teaching the module.

## Guided Learning Topics

Work through topics in [new-style/](new-style/) in order - see
[new-style/README.md](new-style/README.md) for the full topic list, folder
layout, and scope boundary.

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [new-style/01-cluster-setup/](new-style/01-cluster-setup/) | kubectl access, namespace setup |
| Topic 2 | [new-style/02-run-a-pod/](new-style/02-run-a-pod/) | First Pod, ConfigMap-mounted site |
| Topic 3 | [new-style/03-deployment-and-scaling/](new-style/03-deployment-and-scaling/) | Deployment, ReplicaSets, scaling |
| Topic 4 | [new-style/04-expose-with-service/](new-style/04-expose-with-service/) | Service (NodePort), endpoints |
| Topic 5 | [new-style/05-rolling-update-and-rollback/](new-style/05-rolling-update-and-rollback/) | Zero-downtime rollout, rollback |
| Topic 6 | [new-style/06-configmap-and-secret/](new-style/06-configmap-and-secret/) | ConfigMap and Secret injection |
| Topic 7 | [new-style/07-logs-and-exec/](new-style/07-logs-and-exec/) | Logs, exec, break-and-diagnose |
| Topic 8 | [new-style/08-health-checks-and-limits/](new-style/08-health-checks-and-limits/) | Probes, resource requests/limits |

## Topic Assets

Each topic folder is self-contained: it carries its own manifests
(ConfigMap/Pod/Deployment/Service) alongside its `guide.md`, so you can
teach any single topic without needing files or state from a previous one.

Run commands from the topic folder so each lesson stays self-contained.
