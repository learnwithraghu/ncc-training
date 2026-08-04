# Module 7: Jenkins CI/CD

This module introduces Jenkins as a CI/CD server. You will learn how to run Jenkins, create jobs, write pipelines, connect Jenkins to Gitea, and trigger builds automatically.

## What You Will Learn

By the end of this module, you will be able to:

- Run Jenkins locally with Docker
- Navigate the Jenkins web interface
- Create and run Freestyle jobs
- Write declarative pipelines with Groovy
- Connect Jenkins to a Gitea repository
- Trigger builds on code push

## Time Estimate

Approximately **4 hours** including hands-on exercises.

## Prerequisites

- Basic Linux command line skills
- Basic Git knowledge
- A running Gitea server (lab environment or instructor-provided)

## Guide Sequence

| Lesson | File | Topic | Duration |
|--------|------|-------|----------|
| 1 | [01-jenkins-docker-setup.md](01-jenkins-docker-setup.md) | Jenkins Docker setup | 20 min |
| 2 | [02-jenkins-ui-overview.md](02-jenkins-ui-overview.md) | Jenkins UI overview | 20 min |
| 3 | [03-jenkins-freestyle-job.md](03-jenkins-freestyle-job.md) | Freestyle job | 20 min |
| 4 | [04-jenkins-pipeline-basics.md](04-jenkins-pipeline-basics.md) | Pipeline basics | 20 min |
| 5 | [05-jenkins-pipeline-stages.md](05-jenkins-pipeline-stages.md) | Pipeline stages | 20 min |
| 6 | [06-jenkins-groovy-part1.md](06-jenkins-groovy-part1.md) | Groovy basics | 20 min |
| 7 | [07-jenkins-groovy-part2.md](07-jenkins-groovy-part2.md) | More Groovy | 20 min |
| 8 | [08-jenkins-gitea-integration.md](08-jenkins-gitea-integration.md) | Gitea integration | 20 min |
| 9 | [09-jenkins-features.md](09-jenkins-features.md) | Jenkins features | 20 min |
| 10 | [10-jenkins-build-on-push.md](10-jenkins-build-on-push.md) | Build on push | 20 min |

## Module Structure

- `00-OVERVIEW.md` — Theory and concepts
- `01-*.md` through `10-*.md` — Hands-on lessons
- `lab-project/` — Sample repository to upload to Gitea
- `guided-learning/` — Short topic guides for each lesson

## Key Artifact

A Jenkins pipeline connected to a Gitea repository that builds automatically on push to `main`.

## Completion Checklist

Before moving to the next module, ensure you can:

- [ ] Run Jenkins in Docker
- [ ] Create a Freestyle job
- [ ] Create a declarative pipeline
- [ ] Use Groovy in a pipeline
- [ ] Connect Jenkins to Gitea
- [ ] Trigger a build by pushing to `main`

## Next Steps

Start with the overview in [00-OVERVIEW.md](00-OVERVIEW.md), then work through the lessons in order.
