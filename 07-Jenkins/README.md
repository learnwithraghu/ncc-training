# Day 4, Part 1: Jenkins

This module teaches Jenkins the way you'll actually run it in a lab or on a small team: in Docker,
built from a Dockerfile, with jobs created and triggered by hand from the Jenkins console.

## What You Will Learn

By the end of this module, you will be able to:

- Explain why installing Jenkins directly on a host is fragile, from a real failure you cause yourself
- Run Jenkins in Docker and keep its data safe across container restarts with a named volume
- Build a custom Jenkins image with plugins and a project baked in, and rebuild it as code changes
- Choose between rebuilding the image and bind-mounting a local folder, and explain the trade-off
- Create and run Pipeline jobs from the Jenkins console (New Item -> Build Now)
- Write a multi-stage Jenkinsfile: Lint, Test (with published JUnit results), Package, Docker Build
- Use build parameters and the Jenkins credentials store from the console
- Build a Docker image for an application from inside a Jenkins pipeline

## Time Estimate

Approximately **5 hours** total, split into 15 guided topics at about 20 minutes each.

## Prerequisites

- Completion of [05-Docker](../05-Docker/README.md) and [06-Docker-Compose](../06-Docker-Compose/README.md)
- Topic 1 needs an EC2 Amazon Linux instance with `sudo` access
- Topics 2-15 need any machine with Docker already installed (machine type does not matter)

## Verify Your Environment

Before starting Topic 2 onward, run the infrastructure validator:

```bash
/workspaces/ncc-training/07-Jenkins/helpers/validate-infra.sh
```

The validator checks Docker availability, free ports (8080, 50000), and that all module files are
present. Fix any failures before teaching or running the module. It does not check Topic 1's EC2
host — that topic is a standalone exercise on its own instance.

## Guided Learning Topics

Work through the topics in [guided-learning/](guided-learning/) in order:

| Topic | Folder | Focus |
|-------|--------|-------|
| Topic 1 | [guided-learning/topic-01/](guided-learning/topic-01/) | Manual Jenkins install on EC2 Amazon Linux — and why it fails |
| Topic 2 | [guided-learning/topic-02/](guided-learning/topic-02/) | Run Jenkins in Docker (quickstart) |
| Topic 3 | [guided-learning/topic-03/](guided-learning/topic-03/) | Don't lose your data (named volume) |
| Topic 4 | [guided-learning/topic-04/](guided-learning/topic-04/) | Build a custom Jenkins image |
| Topic 5 | [guided-learning/topic-05/](guided-learning/topic-05/) | Bake the lab project into the image |
| Topic 6 | [guided-learning/topic-06/](guided-learning/topic-06/) | Your first Pipeline job from the console |
| Topic 7 | [guided-learning/topic-07/](guided-learning/topic-07/) | A real Jenkinsfile for the lab project |
| Topic 8 | [guided-learning/topic-08/](guided-learning/topic-08/) | The rebuild loop |
| Topic 9 | [guided-learning/topic-09/](guided-learning/topic-09/) | Bind-mount instead of rebuild |
| Topic 10 | [guided-learning/topic-10/](guided-learning/topic-10/) | Add a Test stage (pytest + JUnit) |
| Topic 11 | [guided-learning/topic-11/](guided-learning/topic-11/) | Multi-stage pipeline: Lint -> Test -> Package |
| Topic 12 | [guided-learning/topic-12/](guided-learning/topic-12/) | Parameterized builds |
| Topic 13 | [guided-learning/topic-13/](guided-learning/topic-13/) | Jenkins credentials store |
| Topic 14 | [guided-learning/topic-14/](guided-learning/topic-14/) | Docker-in-Jenkins: build the app's own image |
| Topic 15 | [guided-learning/topic-15/](guided-learning/topic-15/) | Capstone: full rebuild-bake-run cycle |

## Module Files

- `application/` — the small Python CLI every pipeline lints, tests, packages, and containerizes
- `jenkins/` — the custom Jenkins `Dockerfile`, `plugins.txt`, and a reference `Jenkinsfile` showing the final state from Topic 15
- `helpers/validate-infra.sh` — infrastructure validator for Topics 2-15

## Key Artifact

A Jenkins instance in Docker with a Pipeline job that lints, tests, packages, and containerizes the
lab app — all triggered by a manual **Build Now** click from the console. [08-GitHub-Actions](../08-GitHub-Actions/README.md)
picks up from here and automates the trigger.
