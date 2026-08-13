# Daypack: AI Trip Planner on Docker and Kubernetes

Build a small LangChain + Streamlit travel app (**Daypack**), bake classroom
API keys into a Docker image, push to Docker Hub, then deploy on an existing
Kubernetes cluster.

This module is different from [11-Capstone-Document-Search](../11-Capstone-Document-Search/README.md)
(no PDFs, no ECR/ECS/Helm). The teaching shape matches
[09-Kubernetes/new-style](../09-Kubernetes/new-style/README.md): one folder
per topic, self-contained, ~20 minutes each.

## What You Will Learn

- Run a Streamlit + LangChain app locally with keys from `.env`
- Write a Dockerfile that bakes `.env` into the image (classroom only)
- Build, run, and validate the image on your laptop
- Tag and push to `learnwithraghu/ai-k8-workshop:1.0`
- Deploy with a Namespace + Deployment + Service
- Reach the UI with `kubectl port-forward`

## Time Estimate

About **2 hours**, six topics at ~20 minutes each.

## Prerequisites

- Docker on your laptop (topics 01–04 and helper build script)
- Kubernetes cluster access and `kubectl` (topics 05–06 and helper deploy script)
- Classroom `.env` with KodeKloud AI credentials (copy from `.env_example`)

Cluster **setup** is out of scope — clone the repo and use an existing cluster.

## Image

| Tag | Purpose |
|-----|---------|
| `learnwithraghu/ai-k8-workshop:1.0` | Daypack trip planner (Streamlit on port 8501) |

## Instructor — before class (laptop with Docker)

```bash
cd ~/ncc-training/15-ai-k8-full-project
cp .env_example .env   # fill ai-key if not already present
docker login -u learnwithraghu
bash new-style/helpers/build-and-push.sh
```

The script builds from `04-tag-and-push/`, curls health + the Streamlit
HTML shell, then pushes `linux/amd64` and `linux/arm64` to Docker Hub.

## Teaching host — deploy (kubectl only)

```bash
git clone https://github.com/learnwithraghu/ncc-training.git
cd ncc-training
kubectl get nodes
bash 15-ai-k8-full-project/new-style/helpers/deploy-k8s.sh
```

Then open the UI:

```bash
kubectl port-forward svc/daypack 8501:8501 -n daypack
# http://localhost:8501
```

## Guided Learning Topics

Work through [new-style/](new-style/) in order.

| Topic | Folder | Focus |
|-------|--------|-------|
| 1 | [new-style/01-meet-the-app/](new-style/01-meet-the-app/) | Run Daypack with Streamlit |
| 2 | [new-style/02-dockerize/](new-style/02-dockerize/) | Dockerfile + bake `.env` |
| 3 | [new-style/03-build-and-run/](new-style/03-build-and-run/) | Build and test locally |
| 4 | [new-style/04-tag-and-push/](new-style/04-tag-and-push/) | Tag and push to Docker Hub |
| 5 | [new-style/05-k8s-deployment/](new-style/05-k8s-deployment/) | Namespace + Deployment |
| 6 | [new-style/06-k8s-service/](new-style/06-k8s-service/) | Service + port-forward |

Each folder is self-contained. Run commands from the topic folder.

## Secrets

- Never commit a real `.env` (gitignored). Commit `.env_example` only.
- This lab **bakes** `.env` into the image on purpose. Anyone who can pull
  the image can extract the key — acceptable only for supervised labs with
  disposable keys.

## Scope

Docker build/push, Deployment, Service, port-forward. No Ingress, Helm,
ECR, ECS, ConfigMap/Secret, or extra travel APIs.
