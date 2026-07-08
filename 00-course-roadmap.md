# NCC DevOps Bootcamp — Course Roadmap

Welcome to the **Zero to Hero DevOps Bootcamp**. This roadmap shows how the 5 days connect together.

---

## The Big Picture

Each day builds on the previous day. You will create real artifacts and carry them forward:

```
Day 1: Linux + Bash + Python
       ↓ creates ~/ncc-labs/day1/ toolkit
Day 2: Git + GitHub
       ↓ commits toolkit to GitHub
Day 3: Docker + Docker Compose
       ↓ containerizes a Python app
Day 4: Jenkins + GitHub Actions + ECR
       ↓ builds CI/CD pipeline and pushes image
Day 5: Kubernetes + Helm + Capstone
       ↓ deploys document-search app with Helm
```

---

## Day-by-Day Breakdown

### Day 1: Linux, Bash Scripting, and Python Fundamentals

**Goal:** Build a working DevOps toolkit on the command line.

| Module | Guides | What You Build |
|--------|--------|----------------|
| [01-Linux](01-Linux/README.md) | 4 guides | Filesystem navigation, file management, vim, process monitoring |
| [02-Bash-Scripting](02-Bash-Scripting/README.md) | 2 guides | `backup.sh` automation script |
| [03-Python-Fundamentals](03-Python-Fundamentals/README.md) | 2 guides | `log_parser.py` and `run_day1.sh` orchestrator |

**Artifact:** `~/ncc-labs/day1/` folder ready to commit to Git.

---

### Day 2: Git and GitHub Basics

**Goal:** Version control your Day 1 work and collaborate using GitHub.

| Module | Guides | What You Build |
|--------|--------|----------------|
| [04-Git-and-GitHub](04-Git-and-GitHub/README.md) | 3 guides | Local Git repo, GitHub remote, branches, pull requests |

**Artifact:** GitHub repository `ncc-labs` containing your Day 1 toolkit.

---

### Day 3: Docker and Docker Compose

**Goal:** Containerize applications and run multi-service setups.

| Module | Guides | What You Build |
|--------|--------|----------------|
| [05-Docker](05-Docker/README.md) | 5+ guides | Docker image for a Python Flask app |
| [06-Docker-Compose](06-Docker-Compose/README.md) | 2 guides | `docker-compose.yml` for multi-service app |

**Artifact:** Docker image and Compose file for a Python web app.

---

### Day 4: Jenkins, GitHub Actions, and ECR

**Goal:** Automate builds and deployments with CI/CD pipelines.

| Module | Guides | What You Build |
|--------|--------|----------------|
| [07-Jenkins](07-Jenkins/README.md) | 6 guides | Jenkins pipeline that builds and pushes Docker image |
| [08-GitHub-Actions](08-GitHub-Actions/README.md) | 2 guides | GitHub Actions workflow for the same pipeline |

**Artifact:** CI/CD pipeline pushing the Day 3 image to Amazon ECR.

---

### Day 5: Kubernetes, Helm, and Document Search Capstone

**Goal:** Deploy containerized applications to Kubernetes using Helm.

| Module | Guides | What You Build |
|--------|--------|----------------|
| [09-Kubernetes](09-Kubernetes/README.md) | 5 levels | Kubernetes manifests and cluster operations |
| [10-Helm](10-Helm/README.md) | 2 guides | Helm chart for the capstone app |
| [11-Capstone-Document-Search](11-Capstone-Document-Search/README.md) | 7 guides | End-to-end deployment of the document-search app |

**Artifact:** Helm chart deploying the document-search app to Kubernetes.

---

## How to Use This Repository

1. Each numbered folder is a self-contained module.
2. Inside each module, follow the `guide_x.md` files in order.
3. Complete the labs and challenges before moving to the next module.
4. Use [99-quiz-challenge](99-quiz-challenge/README.md) to test your knowledge across all topics.

---

## Prerequisites

- A working terminal
- Internet access
- A GitHub account
- AWS account (for Days 4 and 5)
- Lab environment provided by the instructor

---

## Estimated Total Duration

- **Day 1:** 6 hours
- **Day 2:** 6 hours
- **Day 3:** 6 hours
- **Day 4:** 6 hours
- **Day 5:** 6 hours

**Total:** 30 hours of guided, hands-on learning.
