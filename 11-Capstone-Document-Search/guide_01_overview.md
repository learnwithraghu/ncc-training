# Day 5, Capstone Guide 1: Project Overview

## Goal
Understand the capstone project and what you will build.

## Time
Approximately **15 minutes**.

---

## The Application

The document-search application is a containerized web service. For the classroom, we use a simplified version that runs entirely locally without AWS services.

## What You Will Do

1. Build a Docker image for the application
2. Run it locally with Docker Compose
3. Deploy it to Kubernetes using manifests
4. Package the deployment with Helm
5. Demonstrate the final running application

## Project Structure

```
~/ncc-labs/day5/
├── document-search/
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│   ├── docker-compose.yml
│   └── k8s/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── configmap.yaml
└── document-search-chart/
    ├── Chart.yaml
    ├── values.yaml
    └── templates/
        ├── deployment.yaml
        ├── service.yaml
        └── configmap.yaml
```

## Constraints

- No ECR or external cloud services
- Image built locally
- Cluster can be Minikube, Kind, or instructor-provided

---

## Check Your Understanding

1. Why is this project called a "capstone"?
2. What technologies from previous days does this project use?
3. Why are we avoiding ECR in this particular project?
