# Day 5, Part 2: Helm

This module covers Helm, the package manager for Kubernetes.

## What You Will Learn

By the end of this module, you will be able to:

- Explain what Helm is and why it is useful
- Create and structure a Helm chart
- Use Helm values and templates
- Install, upgrade, and rollback Helm releases

## Time Estimate

Approximately **1.5 hours** (including hands-on exercises).

## Prerequisites

- Completion of [09-Kubernetes](../09-Kubernetes/README.md)
- Helm installed (`helm version`)
- Kubernetes cluster access

## Guide Sequence

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [guide_01_helm_basics.md](guide_01_helm_basics.md) | Charts, releases, values | 45 min |
| Guide 2 | [guide_02_chart_for_capstone.md](guide_02_chart_for_capstone.md) | Build chart for document-search app | 60 min |

## Day 5 Narrative

You will package the Kubernetes manifests for the document-search capstone into a Helm chart. This makes the deployment reusable and configurable.

## Key Artifact

A Helm chart that deploys the document-search application to Kubernetes.
