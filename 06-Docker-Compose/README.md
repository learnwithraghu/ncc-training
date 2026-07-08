# Day 3, Part 2: Docker Compose

This module teaches you how to run multi-container applications using Docker Compose.

## What You Will Learn

By the end of this module, you will be able to:

- Explain why Docker Compose is useful
- Write and read `docker-compose.yml` files
- Start, stop, and scale multi-service applications
- Add health checks and restart policies

## Time Estimate

Approximately **2 hours** (including hands-on exercises).

## Prerequisites

- Completion of [05-Docker](../05-Docker/README.md)
- Docker Compose installed (`docker compose version`)

## Guide Sequence

| Guide | File | Topic | Duration |
|-------|------|-------|----------|
| Guide 1 | [guide_01_compose_basics.md](guide_01_compose_basics.md) | Compose file structure, services, networks | 60 min |
| Guide 2 | [guide_02_multi_service_lab.md](guide_02_multi_service_lab.md) | Flask + Redis multi-service app | 60 min |

## Day 3 Narrative

You will extend the Docker image from Part 1 into a multi-service application. The `docker-compose.yml` you create here will later be referenced when building CI/CD pipelines on Day 4.

## Key Artifact

A `docker-compose.yml` that runs a Python web app with a Redis cache.
