# Day 5, Part 3: Document Search Capstone

This module is the final project of the NCC DevOps Bootcamp. You will deploy the document-search application using Docker and Kubernetes, with no ECR or external cloud dependencies.

## What You Will Learn

By the end of this module, you will be able to:

- Dockerize a real application
- Run the application locally with Docker Compose
- Deploy the application to Kubernetes
- Package the deployment with Helm
- Demonstrate a complete DevOps workflow

## Time Estimate

Approximately **1.5 hours**.

## Prerequisites

- Completion of [09-Kubernetes](../09-Kubernetes/README.md) and [10-Helm](../10-Helm/README.md)
- Docker and Kubernetes cluster access
- The document-search application source code

## Guide Sequence

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [guide_01_overview.md](guide_01_overview.md) | Capstone overview and goals | 15 min |
| Guide 2 | [guide_02_dockerize.md](guide_02_dockerize.md) | Build the Docker image locally | 20 min |
| Guide 3 | [guide_03_compose_local.md](guide_03_compose_local.md) | Run locally with Docker Compose | 15 min |
| Guide 4 | [guide_04_ci_review.md](guide_04_ci_review.md) | Review CI/CD concepts applied | 10 min |
| Guide 5 | [guide_05_k8s_deploy.md](guide_05_k8s_deploy.md) | Deploy with plain manifests | 20 min |
| Guide 6 | [guide_06_helm_chart.md](guide_06_helm_chart.md) | Deploy with Helm | 20 min |
| Guide 7 | [guide_07_final_demo.md](guide_07_final_demo.md) | Final demo and presentation | 20 min |

## Capstone Rules

- Use only Docker and Kubernetes — no ECR or external cloud services.
- The application image should be built locally and loaded into the cluster.
- All manifests and the Helm chart should be stored in `~/ncc-labs/day5/`.

## Key Artifact

A fully deployed document-search application running in Kubernetes, managed by a Helm chart.
