# Module 7: Jenkins CI/CD

This module introduces Jenkins as a CI/CD server. You will learn how to run Jenkins, create jobs, write pipelines, install plugins, build Docker images, connect Jenkins to Gitea, and trigger builds automatically.

## What You Will Learn

By the end of this module, you will be able to:

- Run Jenkins locally with Docker
- Navigate the Jenkins web interface
- Create and run Freestyle jobs
- Write declarative pipelines with Groovy
- Pause a pipeline for interactive user input
- Install and manage Jenkins plugins
- Build a Docker image from source
- Connect Jenkins to a Gitea repository
- Trigger builds on code push

## Time Estimate

Approximately **4 hours** including hands-on exercises.

## Prerequisites

- Basic Linux command line skills
- Basic Git knowledge
- A running Gitea server (lab environment or instructor-provided)

## Guided Learning Topics

Work through the topics in `guided-learning/` in order:

| Topic | Folder | Focus | Duration |
|-------|--------|-------|----------|
| 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Jenkins Docker setup | 20 min |
| 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Jenkins UI overview | 20 min |
| 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Freestyle job | 20 min |
| 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Pipeline basics | 20 min |
| 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Pipeline stages | 20 min |
| 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Groovy basics | 20 min |
| 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | More Groovy | 20 min |
| 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | Interactive user input | 20 min |
| 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | General plugin installation | 20 min |
| 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Docker Pipeline plugin | 20 min |
| 11 | [guided-learning/topic-11/](guided-learning/topic-11/) | Docker Hello World pipeline | 20 min |
| 12 | [guided-learning/topic-12/](guided-learning/topic-12/) | Gitea integration | 20 min |
| 13 | [guided-learning/topic-13/](guided-learning/topic-13/) | Docker build from Gitea | 20 min |
| 14 | [guided-learning/topic-14/](guided-learning/topic-14/) | Jenkins features | 20 min |
| 15 | [guided-learning/topic-15/](guided-learning/topic-15/) | Build on push | 20 min |

## Module Structure

- `00-OVERVIEW.md` — Theory and concepts
- `guided-learning/topic-01/` through `topic-15/` — Hands-on topics
- `lab-project/` — Sample repository, including the Docker build example, to upload to Gitea
- `scripts/jenkins-plugins.txt` — Plugin reference list

## Key Artifact

A Jenkins pipeline connected to a Gitea repository that builds a local Docker image and can build automatically on push to `main`.

## Completion Checklist

Before moving to the next module, ensure you can:

- [ ] Run Jenkins in Docker
- [ ] Create a Freestyle job
- [ ] Create a declarative pipeline
- [ ] Use Groovy in a pipeline
- [ ] Use interactive input in a pipeline
- [ ] Install Jenkins plugins
- [ ] Build a Docker image without pushing it
- [ ] Connect Jenkins to Gitea
- [ ] Trigger a build by pushing to `main`

## Next Steps

Start with the overview in [00-OVERVIEW.md](00-OVERVIEW.md), then work through the topics in order.
