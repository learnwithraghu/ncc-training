# Day 5, Part 1: Kubernetes

This module teaches Kubernetes by deploying **Orbital Relay** from a
shared Docker Hub image. You do not install AWS CLI, and you do not
push images in class.

## What You Will Learn

- Run a workload as a Pod, then as a Deployment, and scale it
- Expose it with a Service
- Roll `:1.0` to `:2.0` (two different UIs) and undo
- Configure with ConfigMaps and Secrets
- Diagnose with `kubectl logs` / `exec`
- Add probes and resource limits
- Scale on CPU with a Horizontal Pod Autoscaler

## Time Estimate

About **2 hours 50 minutes**, eight topics at ~20 minutes each.

## Prerequisites

- Kubernetes cluster access and `kubectl`
- metrics-server on the cluster (`kubectl top pods` must work) for Topic 8
- Instructor has already pushed the two public images (see below)

Students pull:

- `learnwithraghu/ncc-workshop:1.0` — dark day-shift dashboard
- `learnwithraghu/ncc-workshop:2.0` — paper night board

### Instructor — before class

Docker must be running. Log in to Docker Hub as `learnwithraghu`, then:

```bash
cd 09-Kubernetes/new-style/helpers
docker login
bash build-and-push-images.sh
```

The script builds both tags, curls them locally so the pages are
different, then pushes to Docker Hub. Confirm Hub shows `:1.0` and
`:2.0` before you teach.

### Teaching host — clone and prove every command

On the machine that already has `kubectl` pointed at the class cluster
(no Docker needed here):

```bash
git clone https://github.com/learnwithraghu/ncc-training.git
cd ncc-training
kubectl get nodes
bash 09-Kubernetes/new-style/helpers/command-helper.sh
```

If the repo is already cloned:

```bash
cd ~/ncc-training
git pull
bash 09-Kubernetes/new-style/helpers/command-helper.sh
```

Exit code 0 means every topic command ran (Pod, Deployment, Service,
rollout `:1.0`→`:2.0`→undo, ConfigMap/Secret, logs/exec, probes, HPA).
The script uses scratch namespace `orbital-relay-lab` and deletes it
when it finishes.

## Guided Learning Topics

Work through [new-style/](new-style/) in order.

| Topic | Folder | Focus |
|-------|--------|-------|
| 1 | [new-style/01-run-a-pod/](new-style/01-run-a-pod/) | Namespace + Pod |
| 2 | [new-style/02-deployment-and-scaling/](new-style/02-deployment-and-scaling/) | Deployment, scale, self-heal |
| 3 | [new-style/03-expose-with-service/](new-style/03-expose-with-service/) | Service + endpoints |
| 4 | [new-style/04-rolling-update-and-rollback/](new-style/04-rolling-update-and-rollback/) | `:1.0` → `:2.0`, undo |
| 5 | [new-style/05-configmap-and-secret/](new-style/05-configmap-and-secret/) | ConfigMap + Secret |
| 6 | [new-style/06-logs-and-exec/](new-style/06-logs-and-exec/) | logs, exec, break-and-fix |
| 7 | [new-style/07-health-checks-and-limits/](new-style/07-health-checks-and-limits/) | probes + requests/limits |
| 8 | [new-style/08-horizontal-pod-autoscaler/](new-style/08-horizontal-pod-autoscaler/) | HPA on CPU |

Each folder is self-contained. Run commands from the topic folder.
The image is already in the YAML — do not replace a registry placeholder.
