# Day 5, Capstone Guide 4: CI/CD Review

## Goal
Review the CI/CD concepts applied to the capstone project.

## Time
Approximately **10 minutes**.

---

## What We Covered

| Day | Tool | What It Does for the Capstone |
|-----|------|-------------------------------|
| Day 2 | Git + GitHub | Source code is version controlled |
| Day 3 | Docker | Application is containerized |
| Day 3 | Docker Compose | Local multi-service testing |
| Day 4 | Jenkins | Could build and push image in a pipeline |
| Day 4 | GitHub Actions | Could build and push image on every commit |
| Day 5 | Kubernetes | Application runs in production-like environment |
| Day 5 | Helm | Deployment is reusable and configurable |

## For This Capstone

We intentionally keep CI/CD conceptual because the focus is on Docker + K8s deployment without ECR. In a real project, you would:

1. Push code to GitHub
2. Trigger Jenkins or GitHub Actions
3. Build and tag the Docker image
4. Push to a registry (ECR in the course, or a local registry here)
5. Deploy to Kubernetes using Helm

---

## Check Your Understanding

1. Which CI/CD tool would you choose for a GitHub-only project?
2. What is the role of a container registry in the pipeline?
3. How does Helm fit into CI/CD?
