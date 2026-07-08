# Day 4, Part 2: GitHub Actions

This module covers CI/CD with GitHub Actions.

## What You Will Learn

By the end of this module, you will be able to:

- Understand GitHub Actions concepts (workflows, jobs, steps)
- Write YAML workflow files
- Trigger workflows on push, pull request, and schedule
- Build and push Docker images to Amazon ECR using Actions

## Time Estimate

Approximately **2 hours** (including hands-on exercises).

## Prerequisites

- Completion of [07-Jenkins](../07-Jenkins/README.md)
- GitHub repository `ncc-labs`
- AWS account and ECR access

## Guide Sequence

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [guide_01_actions_basics.md](guide_01_actions_basics.md) | Workflow structure, triggers, runners | 60 min |
| Guide 2 | [guide_02_ecr_workflow.md](guide_02_ecr_workflow.md) | Build and push to ECR | 60 min |

## Day 4 Narrative

You will implement the same CI/CD pipeline you built in Jenkins, but using GitHub Actions. This lets you compare the two tools and understand when to use each.

## Key Artifact

A `.github/workflows/docker-build.yml` that builds and pushes a Docker image to ECR.
