# Day 5, Part 1: Kubernetes

This module teaches Kubernetes fundamentals through a guided-learning path that moves from core cluster operations to production-style workload patterns.

## What You Will Learn

By the end of this module, you will be able to:

- Verify cluster readiness and use kubectl confidently
- Create and manage pods, deployments, and rollout workflows
- Expose workloads through Services and Ingress
- Apply configuration, secrets, and persistent storage patterns
- Run advanced controllers like StatefulSets, Jobs, and CronJobs
- Validate reliability with health checks and resource controls

## Time Estimate

Approximately **6 to 7 hours** total, split into 20 guided topics at about 20 minutes each.

## Prerequisites

- Completion of [08-GitHub-Actions](../08-GitHub-Actions/README.md)
- Kubernetes cluster access (provided by instructor)
- kubectl installed and configured

## Guided Learning Topics

Work through topics in [guided-learning/](guided-learning/) in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Kubernetes mindset and architecture essentials |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Cluster verification and kubectl setup checks |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | kubectl resource discovery |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Namespaces and context management |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Pod lifecycle and troubleshooting states |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Declarative YAML fundamentals |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | Multi-container pods and logs/exec |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Deployment fundamentals and ReplicaSets |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Deployment scaling and replica management |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Rolling updates and rollback |
| Topic 11 | [guided-learning/topic-11/](guided-learning/topic-11/) | Service fundamentals (ClusterIP) |
| Topic 12 | [guided-learning/topic-12/](guided-learning/topic-12/) | NodePort and LoadBalancer exposure patterns |
| Topic 13 | [guided-learning/topic-13/](guided-learning/topic-13/) | DNS and service discovery |
| Topic 14 | [guided-learning/topic-14/](guided-learning/topic-14/) | Ingress basics and traffic routing |
| Topic 15 | [guided-learning/topic-15/](guided-learning/topic-15/) | Network policies and connectivity controls |
| Topic 16 | [guided-learning/topic-16/](guided-learning/topic-16/) | ConfigMaps (env and file based) |
| Topic 17 | [guided-learning/topic-17/](guided-learning/topic-17/) | Secrets and secure configuration patterns |
| Topic 18 | [guided-learning/topic-18/](guided-learning/topic-18/) | Volumes, PV, and PVC workflows |
| Topic 19 | [guided-learning/topic-19/](guided-learning/topic-19/) | StatefulSets, Jobs, and CronJobs |
| Topic 20 | [guided-learning/topic-20/](guided-learning/topic-20/) | Health checks, resource limits, and mini workflow |

## Topic Assets

Each guided topic includes an `assets/` folder with the exact YAML and scripts needed for that topic.

Run commands from the topic folder so each lesson stays self-contained.

## Legacy References

Legacy narrative files remain in this module as reference material:

- 00-OVERVIEW.md
- 01-basics.md
- 02-pods-deployments.md
- 03-services-networking.md
- 04-storage-config.md
- 05-advanced.md

Primary learner flow is now the guided-learning topic sequence.
