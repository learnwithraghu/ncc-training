# Day 3, Part 2: Docker Compose

This module teaches you how to define and operate a multi-service
application with Docker Compose: a small Python (Flask) app connected to
a MySQL database.

## What You Will Learn

By the end of this module, you will be able to:

- Explain why Compose is useful in local DevOps workflows
- Read and edit a `docker-compose.yaml` file confidently
- Build, run, and inspect a Python app and a MySQL service together
- Use health checks, dependencies, volumes, and scaling
- Log into the database container and run MySQL commands directly
- Troubleshoot common Compose startup and runtime problems

## Time Estimate

Approximately **4 hours** total, split into 12 guided topics at about 20 minutes each.

## Prerequisites

- Completion of [05-Docker](../05-Docker/README.md)
- Docker Compose installed (`docker compose version`)

## Verify Your Environment

Before starting the topics, run the infrastructure validator to confirm this environment can build, run, and operate the full Compose stack:

```bash
/workspaces/ncc-training/06-Docker-Compose/helpers/validate-infra.sh
```

The validator checks the Docker Compose plugin, the project files, the `docker-compose.yaml` config, service health, env-file values, volume persistence, the database workflow (including a direct `mysql` login), scaling, rebuilds, and final cleanup. Fix any failures before teaching or running the module.

## Guided Learning Topics

Work through the topics in [guided-learning/](guided-learning/) in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Compose mindset and quick checks |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Compose file structure walkthrough |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Validate Compose config |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Build and start services |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Health checks and dependencies |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Environment and env files |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | Volumes and persistent data |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Database workflow with MySQL |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Logs, exec, and troubleshooting |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Service scaling patterns |
| Topic 11 | [guided-learning/topic-11/](guided-learning/topic-11/) | Rebuild and rollout workflow |
| Topic 12 | [guided-learning/topic-12/](guided-learning/topic-12/) | Compose mini workflow |

## Module App

Use the training app in [application/](application/) for all guided topics
- a Flask API (`web`) reading and writing an `items` table in MySQL
(`db`), started with `docker compose up -d --build` from
`application/docker-compose.yaml`.
