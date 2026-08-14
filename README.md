# NCC DevOps Bootcamp

A 5-day, hands-on journey from Linux fundamentals to Kubernetes and Helm. Each day builds on the previous day, and every day produces a real artifact that feeds into the next.

Start with [00-course-roadmap.md](00-course-roadmap.md) for the day-by-day map.

## Who This Course Is For

- Complete beginners with no prior DevOps or Linux experience
- Developers who want to understand deployment and operations
- System administrators moving into DevOps
- Students and career changers building foundational skills

## What You Will Learn

By the end of the 5-day path you will be able to:

- Navigate and manage Linux systems
- Write Bash and Python scripts for DevOps automation
- Use Git and GitHub for version control and collaboration
- Build and run containers with Docker and Docker Compose
- Set up CI/CD with Jenkins and GitHub Actions
- Deploy applications with Kubernetes and Helm

## Course Structure

```
ncc-training/
├── 00-course-roadmap.md              Day-by-day learning map
├── 01-Linux/                         Day 1 — Linux fundamentals
├── 02-Bash-Scripting/                Day 1 — Bash scripting
├── 03-Python-Fundamentals/           Day 1 — Python for DevOps
├── 04-Git-and-GitHub/                Day 2 — Version control
├── 05-Docker/                        Day 3 — Containerization
├── 06-Docker-Compose/                Day 3 — Multi-container apps
├── 07-Jenkins/                       Day 4 — CI/CD with Jenkins
├── 08-GitHub-Actions/                Day 4 — CI/CD with GitHub Actions
├── 09-Kubernetes/                    Day 5 — Container orchestration
├── 10-Helm/                          Day 5 — Kubernetes package manager
├── 11-Capstone-Document-Search/      Day 5 — End-to-end project
├── 12-AWS-Cloud/                     Optional — AWS service labs
├── 13-Python-Boto3/                  Optional — AWS automation with Python
├── 14-Ansible/                       Optional — infrastructure automation
├── 15-ai-k8-full-project/            Optional — AI trip planner on K8s
├── 99-quiz-challenge/                Optional — MCQ quiz across all topics
└── extras/                           Optional — extra Jenkins tracks
```

### 5-day path

| Day | Modules | What you build |
|-----|---------|----------------|
| 1 | [01-Linux](01-Linux/README.md), [02-Bash-Scripting](02-Bash-Scripting/README.md), [03-Python-Fundamentals](03-Python-Fundamentals/README.md) | `~/ncc-labs/day1/` toolkit |
| 2 | [04-Git-and-GitHub](04-Git-and-GitHub/README.md) | GitHub repo `ncc-labs` |
| 3 | [05-Docker](05-Docker/README.md), [06-Docker-Compose](06-Docker-Compose/README.md) | Image + Compose stack |
| 4 | [07-Jenkins](07-Jenkins/README.md), [08-GitHub-Actions](08-GitHub-Actions/README.md) | CI pipeline to Amazon ECR |
| 5 | [09-Kubernetes](09-Kubernetes/README.md), [10-Helm](10-Helm/README.md), [11-Capstone-Document-Search](11-Capstone-Document-Search/README.md) | Document-search app on Kubernetes |

Open each module README and follow its topic guides in order. Most topics are designed for about 20 minutes.

### Optional extras

These are not required for the 5-day bootcamp:

| Module | Focus |
|--------|--------|
| [12-AWS-Cloud](12-AWS-Cloud/README.md) | EC2, CLI, ASG, Lambda, SNS, ECS, Rekognition |
| [13-Python-Boto3](13-Python-Boto3/README.md) | Automate AWS from CloudShell with Boto3 |
| [14-Ansible](14-Ansible/README.md) | Inventory, playbooks, roles on web1/web2 |
| [15-ai-k8-full-project](15-ai-k8-full-project/README.md) | Daypack AI trip planner on Docker + Kubernetes |
| [99-quiz-challenge](99-quiz-challenge/README.md) | PIN-protected MCQ quiz |
| [extras/](extras/README.md) | Extra Jenkins tracks (KodeKloud PHP, Freestyle Python) |

## Getting Started

1. Clone this repository.
2. Open [00-course-roadmap.md](00-course-roadmap.md).
3. Start at [01-Linux](01-Linux/README.md) and work through the 5-day path in order.

You need a terminal, a GitHub account, and the lab environment the instructor provides. See [docs/ncc-prerequisites.pdf](docs/ncc-prerequisites.pdf) for the written checklist. Days 3–5 also use AWS and a Kubernetes cluster as described in each module’s `demo-infra-requirement.md`.

**Beginners:** complete modules 01 through 11 in sequence.

**Experienced learners:** skip to the module you need, then use that module’s README to fill gaps.

## How Each Module Works

1. Open the module README.
2. Walk through the topic guides with the learner.
3. Pause at the checkpoint prompts.
4. Finish the same lesson flow every time.

Do not skip the hands-on commands. Type them, break things on purpose, and read the failures.

## Feedback

This is a living course. Note confusing sections, report errors, and tell instructors what worked.
